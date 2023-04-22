/* SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Microcode programmable logic matrix analyzer.
 * Copyright 2015-2020 Viacheslav Ovsiienko <1801BM1@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "mcode.h"

/* Command line recognezed parameters */
int8_t cl_match = -1;
int8_t cl_speed = -1;
int8_t cl_table = -1;
int8_t cl_mterm = -1;
int8_t cl_count = -1;
const char *cl_fname;

enum opt_type cl_opt = PLM_OPT_NONE;
enum plm_type cl_type = PLM_TYPE_NONE;

int32_t cl_ab = -1;
int32_t cl_ae = -1;
int32_t cl_as = -1;
int32_t cl_az = -1;
int32_t cl_op = -1;
int32_t cl_om = -1;
int64_t cl_qv = -1;
int64_t cl_qm = -1;
int32_t cl_qmc = -1;

char cl_text[16];

int plm_init(struct plm *plm, enum plm_type type)
{
	const struct plm_desc *desc = NULL;
	uint16_t i, j;

	switch (type) {
	case PLM_TYPE_VM1A_MAIN:
		desc = &plm_desc_vm1a;
		break;
	case PLM_TYPE_VM1G_MAIN:
		desc = &plm_desc_vm1g;
		break;
	case PLM_TYPE_VM2_MAIN:
		desc = &plm_desc_vm2;
		break;
	case PLM_TYPE_F11_CS0:
		desc = &plm_desc_f11_cs0;
		break;
	case PLM_TYPE_F11_CS1:
		desc = &plm_desc_f11_cs1;
		break;
	case PLM_TYPE_F11_CS2:
		desc = &plm_desc_f11_cs2;
		break;
	case PLM_TYPE_F11_NA_CLR0:
		desc = &plm_desc_f11_na_clr0;
		break;
	case PLM_TYPE_VM2_DEC:
		desc = &plm_desc_vm2_dec;
		break;
	case PLM_TYPE_VM3_DEC:
		desc = &plm_desc_vm3_dec;
		break;
	case PLM_TYPE_VM3_MAIN:
		desc = &plm_desc_vm3;
		break;
	default:
		printf("mcode: unrecognized plm type %d\n", type);
		assert(0);
		return -1;
	}

	/* Initialize the plm structure */
	assert(desc);
	memset(plm, 0, sizeof(struct plm));
	plm->type = type;
	plm->opt = PLM_OPT_NONE;

	plm->p_xin = desc->xin;
	plm->p_xout = desc->xout;
	plm->in_nb = desc->in_nb;
	plm->out_nb = desc->out_nb;

	/* Initialize the products */
	plm->p_min = UINT16_MAX;
	for (i = 0; i < PLM_P_MAX; i++) {
		const char *p = desc->p[i];
		uint32_t m = 0, x = 0, s;

		if (p == NULL)
			continue;
		plm->p_max = i + 1;
		if (plm->p_min > i)
			plm->p_min = i;
		if (strlen(p) != plm->in_nb) {
			printf("mcode: invalid p-line length\n");
			exit(-1);
		}
		s = 1ul << (plm->in_nb - 1);
		do {
			switch (*p++) {
			case '0':
				break;
			case '1':
				x |= s;
				break;
			case 'x':
				m |= s;
				break;
			default:
				printf("mcode: bad character: %s\n", p);
				exit(-1);
			}
			s >>= 1;
		} while (s);
		plm->p[i].xor = x;
		plm->p[i].and = ~m;
	}

	/* Initialize Sum-of-Products */
	for (i = 0; i < PLM_S_MAX; i++) {
		const int16_t *c = desc->s[i];

		if (c == NULL)
			continue;
		for (j = 0; j < PLM_P_MAX; j++) {
			int16_t k = *c++;

			if (k < 0)
				break;
			plm->p[k].sop |= 1ull << i;
		}
	}

	/* Initialize address bits */
	plm->na_nb = desc->na_nb;
	memcpy(plm->na_bits, desc->na_bits, plm->na_nb);

	/* Duplicate micro-address bits in Sum-of-Products */
	for (i = plm->p_min; i < plm->p_max; i++) {
		if (plm->p[i].sop == 0)
			continue;
		for (j = 0; j < plm->na_nb; j++)
			if (plm->p[i].sop & (1ull << plm->na_bits[j]))
				plm->p[i].sop |= 1ull << (j + PLM_S_MAX);
	}
	return plm_opt(plm, PLM_OPT_32);
}

static inline uint64_t plm_node_32(const struct plm_n *node, uint32_t value)
{
	const struct plm_p32 *p = node->p32;
	uint32_t n = node->n;
	uint64_t s = 0;

	/* 32-bit code, handles one product per iteration */
	do {
		if (((value ^ p->xor) & p->and) == 0)
			s |= p->sop;
		++p;
	} while (--n);
	return s;
}

static inline uint64_t plm_node_64(const struct plm_n *node, uint32_t value)
{
	const struct plm_p64 *p = node->p64;
	uint32_t n = node->n;
	uint64_t s = 0, v64;

	/* 64-bit code, handles two products per iteration */
	v64 = value | ((uint64_t)value) << 32;
	do {
		uint64_t t = (v64 ^ p->xor) & p->and;

		if ((t & UINT32_MAX) == 0)
			s |= p->sop[0];
		if ((t >> 32) == 0)
			s |= p->sop[1];
		++p;
	} while (--n);
	return s;
}

static inline uint64_t plm_node_128(const struct plm_n *node, uint32_t value)
{
	register __m128i v, s, a, x, z, t;
	const struct plm_p128 *p = node->p128;
	uint32_t n = node->n;

	/* SSE2/128-bit code, handles four products per iteration */
	v = _mm_set1_epi32(value);
	s = _mm_setzero_si128();
	z = _mm_setzero_si128();
	do {
		x = _mm_load_si128(&p->xor);
		a = _mm_load_si128(&p->and);
		t = _mm_load_si128(&p->sop[0]);
		x = _mm_xor_si128(x, v);
		x = _mm_and_si128(x, a);
		x = _mm_cmpeq_epi32(x, z);
		a = _mm_unpacklo_epi32(x, x);
		a = _mm_and_si128(a, t);
		t = _mm_load_si128(&p->sop[1]);
		s = _mm_or_si128(s, a);
		a = _mm_unpackhi_epi32(x, x);
		a = _mm_and_si128(a, t);
		s = _mm_or_si128(s, a);
		++p;
	} while (--n);
	t = _mm_unpackhi_epi64(s, s);
	s = _mm_or_si128(s, t);
	return (uint64_t)_mm_extract_epi64(s, 0);
}

static inline uint64_t plm_node_256(const struct plm_n *node, uint32_t value)
{
	register __m256i v, s, a, x, z, t;
	const struct plm_p256 *p = node->p256;
	uint32_t n = node->n;

	/* AVX2/256-bit code, handles eight products per iteration */
	v = _mm256_set1_epi32(value);
	s = _mm256_setzero_si256();
	z = _mm256_setzero_si256();
	do {
		x = _mm256_load_si256(&p->xor);
		a = _mm256_load_si256(&p->and);
		t = _mm256_load_si256(&p->sop[0]);
		x = _mm256_xor_si256(x, v);
		x = _mm256_and_si256(x, a);
		x = _mm256_cmpeq_epi32(x, z);
		a = _mm256_unpacklo_epi32(x, x);
		a = _mm256_and_si256(a, t);
		t = _mm256_load_si256(&p->sop[1]);
		s = _mm256_or_si256(s, a);
		a = _mm256_unpackhi_epi32(x, x);
		a = _mm256_and_si256(a, t);
		s = _mm256_or_si256(s, a);
		++p;
	} while (--n);
	t = _mm256_castsi128_si256(_mm256_extracti128_si256(s, 1));
	s = _mm256_or_si256(s, t);
	t = _mm256_unpackhi_epi64(s, s);
	s = _mm256_or_si256(s, t);
	return (uint64_t)_mm256_extract_epi64(s, 0);
}

static void
plm_optn_32(struct plm *plm, struct plm_n *node, uint32_t val, uint32_t and)
{
	struct plm_p32 *p = node->p32;
	uint32_t n = 0, i;

	memset(p, 0, sizeof(struct plm_n));
	for (i = plm->p_min; i < plm->p_max; i++) {
		if (plm->p[i].sop == 0)
			continue;
		if ((plm->p[i].xor ^ val) & plm->p[i].and & and)
			continue;
		p->and = plm->p[i].and;
		p->xor = plm->p[i].xor;
		p->sop = plm->p[i].sop;
		++p;
		++n;
	}
	node->n = n;
}

static void
plm_optn_64(struct plm *plm, struct plm_n *node, uint32_t val, uint32_t and)
{
	struct plm_p64 *p = node->p64;
	uint32_t n = 0, i;

	memset(p, 0, sizeof(struct plm_n));
	for (i = plm->p_min; i < plm->p_max; i++) {
		if (plm->p[i].sop == 0)
			continue;
		if ((plm->p[i].xor ^ val) & plm->p[i].and & and)
			continue;
		switch (n & 1) {
		case 0:
			p->and = plm->p[i].and;
			p->xor = plm->p[i].xor;
			p->sop[0] = plm->p[i].sop;
			break;
		case 1:
			p->and |= ((uint64_t)plm->p[i].and) << 32;
			p->xor |= ((uint64_t)plm->p[i].xor) << 32;
			p->sop[1] = plm->p[i].sop;
			++p;
			break;
		}
		++n;
	}
	node->n = (n + 1) / 2;
}

static void
plm_optn_128(struct plm *plm, struct plm_n *node, uint32_t val, uint32_t and)
{
	struct plm_p128 *p = node->p128;
	uint32_t n = 0, i;

	memset(p, 0, sizeof(struct plm_n));
	for (i = plm->p_min; i < plm->p_max; i++) {
		if (plm->p[i].sop == 0)
			continue;
		if ((plm->p[i].xor ^ val) & plm->p[i].and & and)
			continue;
		p->xor32[n & 3] = plm->p[i].xor;
		p->and32[n & 3] = plm->p[i].and;
		p->sop64[n & 3] = plm->p[i].sop;
		if ((n & 3) == 3)
			++p;
		++n;
	}
	node->n = (n + 3) / 4;
}

static void
plm_optn_256(struct plm *plm, struct plm_n *node, uint32_t val, uint32_t and)
{
	struct plm_p256 *p = node->p256;
	uint32_t n = 0, i;

	memset(p, 0, sizeof(struct plm_n));
	for (i = plm->p_min; i < plm->p_max; i++) {
		if (plm->p[i].sop == 0)
			continue;
		if ((plm->p[i].xor ^ val) & plm->p[i].and & and)
			continue;
		p->xor32[n & 7] = plm->p[i].xor;
		p->and32[n & 7] = plm->p[i].and;
		/* Preliminary shuffle for the m256_unpackxx_epi32 */
		switch (n & 7) {
		case 0:
		case 1:
		case 6:
		case 7:
			p->sop64[n & 7] = plm->p[i].sop;
			break;
		case 2:
		case 3:
		case 4:
		case 5:
			p->sop64[(n & 7) ^ 6] = plm->p[i].sop;
			break;
		}
		if ((n & 7) == 7)
			++p;
		++n;
	}
	node->n = (n + 7) / 8;
}

/* Calculation subroutines w/o tree optimization. */
static uint64_t plm_get_32(const struct plm *plm, uint32_t value)
{
	return plm_node_32(&plm->tree[0], value ^ plm->p_xin) ^ plm->p_xout;
}

static uint64_t plm_get_64(const struct plm *plm, uint32_t value)
{
	return plm_node_64(&plm->tree[0], value ^ plm->p_xin) ^ plm->p_xout;
}

static uint64_t plm_get_128(const struct plm *plm, uint32_t value)
{
	return plm_node_128(&plm->tree[0], value ^ plm->p_xin) ^ plm->p_xout;
}

static uint64_t plm_get_256(const struct plm *plm, uint32_t value)
{
	return plm_node_256(&plm->tree[0], value ^ plm->p_xin) ^ plm->p_xout;
}

/* Calculation subroutines with tree optimization */
static inline uint32_t plm_index_tree(const struct plm *plm, uint32_t value)
{
	uint32_t index = 0;

	index |= (value >> plm->mt_bits[0]) & (1u << 0);
#if PLM_M_TREE_BITS > 1
	index |= (value >> plm->mt_bits[1]) & (1u << 1);
#if PLM_M_TREE_BITS > 2
	index |= (value >> plm->mt_bits[2]) & (1u << 2);
#if PLM_M_TREE_BITS > 3
	index |= (value >> plm->mt_bits[3]) & (1u << 3);
#if PLM_M_TREE_BITS > 4
	index |= (value >> plm->mt_bits[4]) & (1u << 4);
#if PLM_M_TREE_BITS > 5
	index |= (value >> plm->mt_bits[5]) & (1u << 5);
#if PLM_M_TREE_BITS > 6
	index |= (value >> plm->mt_bits[6]) & (1u << 6);
#if PLM_M_TREE_BITS > 7
	index |= (value >> plm->mt_bits[7]) & (1u << 7);
#if PLM_M_TREE_BITS > 8
#error "PLM_M_TREE_BITS exeeds 8"
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
	return index;
}

static uint64_t plm_get_tree_32(const struct plm *plm, uint32_t value)
{
	uint32_t n;

	value ^= plm->p_xin;
	n = plm_index_tree(plm, value);
	if (plm->tree[n].n)
		return plm_node_32(&plm->tree[n], value) ^ plm->p_xout;
	return plm->p_xout;
}

static uint64_t plm_get_tree_64(const struct plm *plm, uint32_t value)
{
	uint32_t n;

	value ^= plm->p_xin;
	n = plm_index_tree(plm, value);
	if (plm->tree[n].n)
		return plm_node_64(&plm->tree[n], value) ^ plm->p_xout;
	return plm->p_xout;
}

static uint64_t plm_get_tree_128(const struct plm *plm, uint32_t value)
{
	uint32_t n;

	value ^= plm->p_xin;
	n = plm_index_tree(plm, value);
	if (plm->tree[n].n)
		return plm_node_128(&plm->tree[n], value) ^ plm->p_xout;
	return plm->p_xout;
}

static uint64_t plm_get_tree_256(const struct plm *plm, uint32_t value)
{
	uint32_t n;

	value ^= plm->p_xin;
	n = plm_index_tree(plm, value);
	if (plm->tree[n].n)
		return plm_node_256(&plm->tree[n], value) ^ plm->p_xout;
	return plm->p_xout;
}

void plm_show_tree(const struct plm *plm)
{
	uint32_t i, h = 0;

	for (i = 0; i < PLM_M_TREE; i++) {
		printf("%u, ", plm->tree[i].n);
		h += plm->tree[i].n;
	}
	printf("total %u, bits:", h);
	for (i = 0; i < PLM_M_TREE_BITS; i++)
		printf(" %u", plm->mt_bits[i] + i);
	printf("\n");
}

static inline uint32_t
plm_build_tree(struct plm *plm, uint8_t *tb,
	       void (*func)(struct plm*, struct plm_n*, uint32_t, uint32_t))
{
	uint32_t and = 0, h = 0, i;

	for (i = 0; i < PLM_M_TREE_BITS; i++) {
		and |= 1 << tb[i];
		plm->mt_bits[i] = tb[i] - i;
	}
	for (i = 0; i < PLM_M_TREE; i++) {
		uint32_t val = 0, j;

		for (j = 0; j < PLM_M_TREE_BITS; j++)
			val |= (i & (1 << j)) ? 1 << tb[j] : 0;
		func(plm, &plm->tree[i], val, and);
		h += plm->tree[i].n;
	}
	return h;
}

static inline void
plm_scan_tree(struct plm *plm, struct plm_scan *s, uint8_t deep,
	      void (*func)(struct plm*, struct plm_n*, uint32_t, uint32_t))
{
	uint8_t *c = s->b + deep;
	uint8_t lim = plm->in_nb - (PLM_M_TREE_BITS - deep - 1);

	*c = (deep == 0) ? 0 : s->b[deep - 1] + 1;
	for (; *c < lim; ++(*c)) {
		if (deep < (PLM_M_TREE_BITS - 1)) {
			plm_scan_tree(plm, s, deep + 1, func);
		} else {
			uint32_t h = plm_build_tree(plm, s->b, func);

			if (h < s->hmin) {
				s->hmin = h;
				memcpy(s->o, s->b,
				       PLM_M_TREE_BITS * sizeof(*c));
			}
		}
	}
}

static uint32_t
plm_opt_tree(struct plm *plm,
	     void (*func)(struct plm *, struct plm_n *, uint32_t, uint32_t))
{
	struct plm_scan s = {.hmin = UINT32_MAX};
	uint32_t h;

	plm_scan_tree(plm, &s, 0, func);
	h = plm_build_tree(plm, &s.o[0], func);
/*	plm_show_tree(plm); */
	return h;
}

int plm_opt(struct plm *plm, enum opt_type opt)
{
	switch (opt) {
	case PLM_OPT_32:
		plm_optn_32(plm, &plm->tree[0], 0, 0);
		plm->opt = PLM_OPT_32;
		plm->get = plm_get_32;
		return 0;
	case PLM_OPT_32_TREE:
		plm_opt_tree(plm, plm_optn_32);
		plm->opt = PLM_OPT_32_TREE;
		plm->get = plm_get_tree_32;
		return 0;
	case PLM_OPT_64:
		plm_optn_64(plm, &plm->tree[0], 0, 0);
		plm->opt = PLM_OPT_64;
		plm->get = plm_get_64;
		return 0;
	case PLM_OPT_64_TREE:
		plm_opt_tree(plm, plm_optn_64);
		plm->opt = PLM_OPT_64_TREE;
		plm->get = plm_get_tree_64;
		return 0;
	case PLM_OPT_128:
		if ((mc_query_simd() & SIMD_SSE2) == 0) {
			printf("mcode: SSE2 is required\n");
			assert(0);
			return -1;
		}
		plm_optn_128(plm, &plm->tree[0], 0, 0);
		plm->opt = PLM_OPT_128;
		plm->get = plm_get_128;
		return 0;
	case PLM_OPT_128_TREE:
		if ((mc_query_simd() & SIMD_SSE2) == 0) {
			printf("mcode: SSE2 is required\n");
			assert(0);
			return -1;
		}
		plm_opt_tree(plm, plm_optn_128);
		plm->opt = PLM_OPT_128_TREE;
		plm->get = plm_get_tree_128;
		return 0;
	case PLM_OPT_256:
		if ((mc_query_simd() & SIMD_AVX2) == 0) {
			printf("mcode: AVX2 is required\n");
			assert(0);
			return -1;
		}
		plm_optn_256(plm, &plm->tree[0], 0, 0);
		plm->opt = PLM_OPT_256;
		plm->get = plm_get_256;
		return 0;
	case PLM_OPT_256_TREE:
		if ((mc_query_simd() & SIMD_AVX2) == 0) {
			printf("mcode: AVX2 is required\n");
			assert(0);
			return -1;
		}
		plm_opt_tree(plm, plm_optn_256);
		plm->opt = PLM_OPT_256_TREE;
		plm->get = plm_get_tree_256;
		return 0;
	default:
		printf("mcode: unrecognized opt type %d\n", opt);
		assert(0);
		return -1;
	}
}

/*
 * Benchmarking results, Haswell i7-4770, 3.4GHz
 * Full matrix range run	x86-32		x86-64
 * vma1 reference		5:50		5:37
 * vma1 32b/tree(4)		5:50/0:65	5:53/0:51
 * vma1 64b/tree(4)		5:27/1:23	4:27/0:50
 * vma1 128b (SSE2)/tree(4)	2:57/0:34	2:51/0:27
 * vma1 256b (AVX2)/tree(4)	1:31/0:28	1:25/0:21
 */
static void
mc_test_speed(enum plm_type type, enum opt_type opt, const char *text)
{
	static struct plm tpl;
	uint64_t start;
	uint64_t t = 0;
	uint32_t i, max;
	int ret;

	printf("Microcode speed test: %s, wait...\n", text);
	ret = plm_init(&tpl, type);
	if (ret)
		exit(-1);
	ret = plm_opt(&tpl, opt);
	if (ret)
		exit(-1);

	max = 1ul << tpl.in_nb;
	start = mc_query_ms();
	for (i = 0; i < max; i++)
		t |= plm_get(&tpl, i);
	start = mc_query_ms() - start;
	printf("Elapsed %s: %" PRIu64 ".%03" PRIu64 " (%" PRIX64 ")\n",
	       text, start / 1000, start % 1000, t);
}

static void
mc_test_decode(enum plm_type type, enum opt_type opt,
	       struct plm *tpl, const char *text)
{
	static struct ma_stats tab;
	uint32_t val, max, amx, ina;
	uint32_t op, om;
	uint64_t start;

	max = 1ul << tpl->in_nb;	/* input value limit */
	amx = 1ul << tpl->na_nb;	/* microaddress limit */
	memset(&tab, 0, sizeof(tab));
	op = cl_op < 0 ? 0 : ((cl_op & UINT16_MAX) << (tpl->in_nb - 16));
	om = cl_om < 0 ? 0 : ((cl_om & UINT16_MAX) << (tpl->in_nb - 16));
	start = mc_query_ms();
	for (val = 0; val < max; val++) {
		if ((val & om) == op) {
			uint64_t sop = plm_get(tpl, val);

			ina = (uint32_t)(sop >> PLM_S_MAX);
			tab.jmp[ina].count++;
			tab.jmp[ina].zeros |=  val;
			tab.jmp[ina].ones  |= ~val;
		}
	}
	start = mc_query_ms() - start;
	printf("Elapsed %s: %" PRIu64 ".%03" PRIu64 "\n", text,
		start / 1000, start % 1000);

	for (ina = 0; ina < amx; ina++) {
		if (tab.jmp[ina].count) {
			printf("  %02X: %08X z:%06o o:%06o\n", ina,
				tab.jmp[ina].count,
				~tab.jmp[ina].zeros & UINT16_MAX,
				~tab.jmp[ina].ones & UINT16_MAX);
		}
	}
}

static void
mc_test_table(enum plm_type type, enum opt_type opt, const char *text)
{
	static struct plm tpl;
	static struct ma_stats tab[PLM_NA_MAX];
	struct ma_check {
		uint32_t uop;
		uint32_t opcode;
		uint32_t opmask;
	} chk = { 0 };
	uint32_t val, max, adr, amx, ina;
	uint32_t ab, ae, op, om;
	uint64_t start;
	int ret;

	printf("Microcode jump table build: %s, wait...\n", text);
	ret = plm_init(&tpl, type);
	if (ret)
		exit(-1);
	ret = plm_opt(&tpl, opt);
	if (ret)
		exit(-1);
	switch (type) {
	case PLM_TYPE_VM1A_MAIN:
	case PLM_TYPE_VM1G_MAIN:
		op = cl_op < 0 ? 0 : ((cl_op & UINT16_MAX) << (tpl.in_nb - 16));
		om = cl_om < 0 ? 0 : ((cl_om & UINT16_MAX) << (tpl.in_nb - 16));
		chk.uop = (1 << 12);
		break;
	case PLM_TYPE_VM2_MAIN:
	case PLM_TYPE_VM3_MAIN:
		op = cl_op < 0 ? 0 : ((uint32_t)cl_op << tpl.na_nb);
		om = cl_om < 0 ? 0 : ((uint32_t)cl_om << tpl.na_nb);
		break;
	case PLM_TYPE_VM2_DEC:
		mc_test_decode(type, opt, &tpl, text);
		return;
	case PLM_TYPE_NONE:
	default:
		printf("mcode: unsupported build for table %s\n", text);
		exit(-1);
	}
	max = 1ul << tpl.in_nb;	/* input value limit */
	amx = 1ul << tpl.na_nb; /* microaddress limit */
	memset(&tab, 0, sizeof(tab));
	ab = cl_ab < 0 ? 0 : MIN(cl_ab, (int)amx);
	ae = cl_ae < 0 ? amx : MIN(cl_ae, (int)amx);

	start = mc_query_ms();
	for (adr = ab; adr < ae; adr++) {
		printf("%02X ...\n", adr);
		for (val = adr; val < max; val += amx) {
			if ((val & om) == op) {
				uint64_t sop = plm_get(&tpl, val);

				ina = (uint32_t)(sop >> PLM_S_MAX);
				tab[adr].jmp[ina].count++;
				tab[adr].jmp[ina].zeros |=  val;
				tab[adr].jmp[ina].ones  |= ~val;

				if (sop & chk.uop)
					tab[adr].uops++;
			}
		}
	}
	start = mc_query_ms() - start;
	printf("Elapsed %s: %" PRIu64 ".%03" PRIu64 "\n", text,
		start / 1000, start % 1000);

	for (adr = ab; adr < ae; adr++) {
		printf("[%02X]", adr);
		/* print addresses jumping from to current */
		for (ina = 0; ina < amx; ina++) {
			if (tab[ina].jmp[adr].count) {
				ret = 0;
				printf(" %02X", ina);
			}
		}
		if (ret)
			printf(" none");
		if (tab[adr].uops)
			printf(" uop:%08X%s\n", tab[adr].uops,
			       tab[adr].uops == max / amx ? " (full)" : "");
		else
			printf("\n");
		/* print addresses jumping to from current */
		for (ina = 0; ina < amx; ina++) {
			if (tab[adr].jmp[ina].count) {
				uint32_t zs = ~tab[adr].jmp[ina].zeros;
				uint32_t os = ~tab[adr].jmp[ina].ones;

				zs &= (1ul << tpl.in_nb) - 1;
				os &= (1ul << tpl.in_nb) - 1;
				zs >>= tpl.na_nb;
				os >>= tpl.na_nb;
				printf("  %02X: %08X z:%08X o:%08X\n", ina,
				       tab[adr].jmp[ina].count, zs, os);
			}
		}
	}
	/* remove not referenced addresses */
	do {
		ret = 0;
		for (adr = ab; adr < ae; adr++) {
			uint32_t ref = 0;

			for (ina = 0; ina < amx; ina++) {
				if (tab[ina].jmp[adr].count) {
					ref++;
					break;
				}
			}
			if (ref)
				continue;
			for (ina = 0; ina < amx; ina++) {
				if (tab[adr].jmp[ina].count) {
					tab[adr].jmp[ina].count = 0;
					ret++;
				}
			}
		}
		if (ret)
			printf("Unused destination reference(s): %u\n", ret);
	} while (ret);
	/* print addresses jumping from to current */
	for (adr = ab; adr < ae; adr++) {
		printf("[%02X]", adr);
		for (ina = 0; ina < amx; ina++)
			if (tab[ina].jmp[adr].count)
				printf(" %02X", ina);
		printf("\n");
	}
}

/* Quine-McCluskey term minimization for decoders */
void mc_test_qmc(enum plm_type type, enum opt_type opt, const char *text)
{
	static struct plm tpl;
	int ret;

	switch (type) {
	case PLM_TYPE_VM2_DEC:
		break;
	case PLM_TYPE_VM3_DEC:
		break;
	default:
		printf("Unsupported type for Quine-McCluskey: %s\n", text);
		return;
	}
	printf("Quine-McCluskey decoder matrix minimization (%s)\n", text);
	ret = plm_init(&tpl, type);
	if (ret)
		exit(-1);
	ret = plm_opt(&tpl, opt);
	if (ret)
		exit(-1);
	switch (type) {
	case PLM_TYPE_VM2_DEC:
	case PLM_TYPE_VM3_DEC:
		mc_test_qmc16(&tpl);
		break;
	default:
		break;
	}
}

static void
mc_test_count(enum plm_type type, enum opt_type opt, const char *text)
{
	static struct plm tpl;
	uint64_t start, qm, qv;
	uint32_t op, om, max, i, n;
	int ret;

	printf("Minterm table output match counting, wait...\n");
	ret = plm_init(&tpl, type);
	if (ret)
		exit(-1);
	ret = plm_opt(&tpl, opt);
	if (ret)
		exit(-1);

	max = 1ul << tpl.in_nb;	/* input value limit */
	qv = cl_qv < 0 ? 0 : (uint64_t)cl_qv;
	qm = cl_qm < 0 ? (1ull << tpl.out_nb) - 1 : (uint64_t)cl_qm;
	op = cl_op < 0 ? 0 : (uint32_t)cl_op;
	om = cl_om < 0 ? 0 : (uint32_t)cl_om;

	n = 0;
	start = mc_query_ms();
	for (i = 0; i < max; i++) {
		if ((i & om) == op) {
			uint64_t sop;

			sop = plm_get(&tpl, i);
			if ((sop & qm) == qv)
				n++;
		}
	}
	start = mc_query_ms() - start;
	printf("Elapsed %s: %" PRIu64 ".%03" PRIu64 " (%u/0x%X\n)",
	       text, start / 1000, start % 1000, n, n);
}

static int mc_param_hex(char *s)
{
	int r = 0;

	if (*s == 0) {
		printf("mcode: empty parameter\n");
		return -1;
	}
	do {
		char c = *s++;

		if (!c)
			break;
		if (c == '_' || c == '-')
			continue;
		if (c >= '0' && c <= '9') {
			c -= '0';
			r = (r << 4) + c;
		} else if (c >= 'a' && c <= 'f') {
			c -= 'a' - 10;
			r = (r << 4) + c;
		} else if (c >= 'A' && c <= 'F') {
			c -= 'A' - 10;
			r = (r << 4) + c;
		} else {
			printf("mcode: invalid hex parameter: %s\n", s);
			return -1;
		}
		if (r >= UINT32_MAX/2) {
			printf("mcode: hex parameter overflow: %05X\n", r);
			return -1;
		}
	} while (1);
	return r;
}

static int64_t mc_param_oct(char *s, int64_t limit)
{
	int r = 0;

	if (*s == 0) {
		printf("mcode: empty parameter\n");
		return -1;
	}
	do {
		char c = *s++;

		if (!c)
			break;
		if (c == '_' || c == '-')
			continue;
		if (c >= '0' && c <= '7') {
			c -= '0';
			r = (r << 3) + c;
		} else {
			printf("mcode: invalid octal parameter: %s\n", s);
			return -1;
		}
		if (r < 0 || r > limit) {
			printf("mcode: octal parameter overflow: %llo\n",
				(uint64_t)r);
			return -1;
		}
	} while (1);
	return r;
}

static int mc_param_dec(char *s)
{
	int r = 0;

	if (*s == 0) {
		printf("mcode: empty parameter\n");
		return -1;
	}
	do {
		char c = *s++;

		if (!c)
			break;
		if (c >= '0' && c <= '9') {
			c -= '0';
			r = r * 10 + c;
		} else {
			printf("mcode: invalid decimal parameter: %s\n", s);
			return -1;
		}
		if (r > UINT16_MAX) {
			printf("mcode: decimal parameter overflow: %d\n", r);
			return -1;
		}
	} while (1);
	return r;
}

static int mc_proc_param(const char *p)
{
	char b[MCODE_PARAM_LEN];
	char *eq, *s;

	strncpy(b, p, MCODE_PARAM_LEN - 1);
	b[MCODE_PARAM_LEN-1] = 0;
	s = b;
	while (*s) {
		*s = tolower(*s);
		s++;
	};
	if (b[0] != '-') {
		cl_fname = p;
		return 0;
	}
	if (!strcmp(b, "--match")) {
		cl_match = 1;
		return 0;
	}
	if (!strcmp(b, "--mterm")) {
		cl_mterm = 1;
		return 0;
	}
	if (!strcmp(b, "--speed")) {
		cl_speed = 1;
		return 0;
	}
	if (!strcmp(b, "--table")) {
		cl_table = 1;
		return 0;
	}
	if (!strcmp(b, "--count")) {
		cl_count = 1;
		return 0;
	}
	if (!strcmp(b, "--32")) {
		cl_opt = PLM_OPT_32;
		return 0;
	}
	if (!strcmp(b, "--32t")) {
		cl_opt = PLM_OPT_32_TREE;
		return 0;
	}
	if (!strcmp(b, "--64")) {
		cl_opt = PLM_OPT_64;
		return 0;
	}
	if (!strcmp(b, "--64t")) {
		cl_opt = PLM_OPT_64_TREE;
		return 0;
	}
	if (!strcmp(b, "--128")) {
		cl_opt = PLM_OPT_128;
		return 0;
	}
	if (!strcmp(b, "--128t")) {
		cl_opt = PLM_OPT_128_TREE;
		return 0;
	}
	if (!strcmp(b, "--256")) {
		cl_opt = PLM_OPT_256;
		return 0;
	}
	if (!strcmp(b, "--256t")) {
		cl_opt = PLM_OPT_256_TREE;
		return 0;
	}
	if (!strcmp(b, "--vm1a")) {
		cl_type = PLM_TYPE_VM1A_MAIN;
		return 0;
	}
	if (!strcmp(b, "--vm1g")) {
		cl_type = PLM_TYPE_VM1G_MAIN;
		return 0;
	}
	if (!strcmp(b, "--vm2")) {
		cl_type = PLM_TYPE_VM2_MAIN;
		return 0;
	}
	if (!strcmp(b, "--vm2d")) {
		cl_type = PLM_TYPE_VM2_DEC;
		return 0;
	}
	if (!strcmp(b, "--vm3")) {
		cl_type = PLM_TYPE_VM3_MAIN;
		return 0;
	}
	if (!strcmp(b, "--vm3d")) {
		cl_type = PLM_TYPE_VM3_DEC;
		return 0;
	}
	if (!strcmp(b, "--f11-0")) {
		cl_type = PLM_TYPE_F11_CS0;
		return 0;
	}
	if (!strcmp(b, "--f11-1")) {
		cl_type = PLM_TYPE_F11_CS1;
		return 0;
	}
	if (!strcmp(b, "--f11-2")) {
		cl_type = PLM_TYPE_F11_CS2;
		return 0;
	}
	eq = strchr(b, '=');
	if (eq) {
		eq++;
		if (strstr(b, "--ab=") == b) {
			cl_ab = mc_param_hex(eq);
			return cl_ab >= 0 ? 0 : -1;
		}
		if (strstr(b, "--ae=") == b) {
			cl_ae = mc_param_hex(eq);
			return cl_ae >= 0 ? 0 : -1;
		}
		if (strstr(b, "--as=") == b) {
			cl_as = mc_param_hex(eq);
			return cl_as >= 0 ? 0 : -1;
		}
		if (strstr(b, "--az=") == b) {
			cl_az = mc_param_hex(eq);
			return cl_az >= 0 ? 0 : -1;
		}
		if (strstr(b, "--op=") == b) {
			cl_op = (int)mc_param_oct(eq, (1ll << PLM_S_MAX) - 1);
			return cl_op >= 0 ? 0 : -1;
		}
		if (strstr(b, "--om=") == b) {
			cl_om = (int)mc_param_oct(eq, (1ll << PLM_S_MAX) - 1);
			return cl_om >= 0 ? 0 : -1;
		}
		if (strstr(b, "--qv=") == b) {
			cl_qv = (int)mc_param_oct(eq, (1ll << PLM_S_MAX) - 1);
			return cl_qv >= 0 ? 0 : -1;
		}
		if (strstr(b, "--qm=") == b) {
			cl_qm = (int)mc_param_oct(eq, (1ll << PLM_S_MAX) - 1);
			return cl_qm >= 0 ? 0 : -1;
		}
		if (strstr(b, "--qmc=") == b) {
			cl_qmc = mc_param_dec(eq);
			return cl_qmc >= 0 ? 0 : -1;
		}
	}
	printf("mcode: unrecognized parameter: %s\n", p);
	return -1;
}

static void mc_cmd_line(int argc, char *argv[])
{
	int i;

	if (argc <= 1) {
		printf("Supported command line parameters:\n"
		       "  --match - check compliance (against file)\n"
		       "  --mterm - write table to file\n"
		       "  --speed - performance test\n"
		       "  --table - build address table\n"
		       "  --32 --32t - select 32 bit operations (with tree)\n"
		       "  --64 --64t - select 64 bit operations (with tree)\n"
		       "  --128 --128t - select 128 bit operations (with tree)\n"
		       "  --256 --256t - select 256 bit operations (with tree)\n"
		       "  --vm1a (vm1g vm2 vm2d vm3 vm3d f11-x) - select matrix\n"
		       "  --ab=xxx --ae=xxx - optional address range in hex\n"
		       "  --as=xxx --az=xxx - optional address set/zero mask\n"
		       "  --op=oooooo --om=oooooo - opcode mask in octal\n"
		       "  --qv=oooooo --qm=oooooo - QnM match in octal\n"
		       "  --qmc=n - Quine-McCluskey minimization attempt\n"
		       "  filename - file for matrix input or output\n"
		);
		exit(0);
	}
	for (i = 1; i < argc; i++) {
		if (mc_proc_param(argv[i]))
			exit(-1);
	}
	/* Default action is compliance check */
	if (cl_speed < 0 && cl_match < 0 && cl_count < 0 &&
	    cl_table < 0 && cl_mterm < 0 && cl_qmc < 0)
		cl_match = 1;
	/* Default matrix is VM1A main PLM */
	if (cl_type == PLM_TYPE_NONE)
		cl_type = PLM_TYPE_VM1A_MAIN;
	/* Operations is selected depending on SIMD */
	if (cl_opt == PLM_OPT_NONE) {
		if (mc_query_simd() & SIMD_AVX2)
			cl_opt = PLM_OPT_256_TREE;
		else if (mc_query_simd() & SIMD_SSE2)
			cl_opt = PLM_OPT_128_TREE;
		else
			cl_opt = PLM_OPT_64_TREE;
	}

	switch (cl_type) {
	case PLM_TYPE_NONE:
		strcpy(cl_text, "none");
		break;
	case PLM_TYPE_VM1A_MAIN:
		strcpy(cl_text, "vm1a");
		break;
	case PLM_TYPE_VM1G_MAIN:
		strcpy(cl_text, "vm1g");
		break;
	case PLM_TYPE_VM2_MAIN:
		strcpy(cl_text, "vm2");
		break;
	case PLM_TYPE_VM2_DEC:
		strcpy(cl_text, "vm2d");
		break;
	case PLM_TYPE_VM3_MAIN:
		strcpy(cl_text, "vm3");
		break;
	case PLM_TYPE_VM3_DEC:
		strcpy(cl_text, "vm3d");
		break;
	case PLM_TYPE_F11_CS0:
		strcpy(cl_text, "f11-0");
		break;
	case PLM_TYPE_F11_CS1:
		strcpy(cl_text, "f11-1");
		break;
	case PLM_TYPE_F11_CS2:
		strcpy(cl_text, "f11-2");
		break;
	default:
		printf("Unrecognized plm type\n");
		exit(-1);
	}

	switch (cl_opt) {
	case PLM_OPT_NONE:
		strcat(cl_text, "_none");
		break;
	case PLM_OPT_32:
		strcat(cl_text, "_32");
		break;
	case PLM_OPT_64:
		strcat(cl_text, "_64");
		break;
	case PLM_OPT_128:
		strcat(cl_text, "_128");
		break;
	case PLM_OPT_256:
		strcat(cl_text, "_256");
		break;
	case PLM_OPT_32_TREE:
		strcat(cl_text, "_32t");
		break;
	case PLM_OPT_64_TREE:
		strcat(cl_text, "_64t");
		break;
	case PLM_OPT_128_TREE:
		strcat(cl_text, "_128t");
		break;
	case PLM_OPT_256_TREE:
		strcat(cl_text, "_256t");
		break;
	default:
		printf("Unrecognized plm optimization\n");
		exit(-1);
	}
}

int main(int argc, char *argv[])
{
	printf("\r\nMicrocode matrix test utility (c) 1801BM1, 2020-2022\n");
	mc_cmd_line(argc, argv);
	mc_query_simd();

	if (cl_match > 0) {
		if (cl_type != PLM_TYPE_VM1A_MAIN && !cl_fname) {
			printf("mcode: reference match is for vm1a only\n");
			exit(-1);
		}
		if (cl_type == PLM_TYPE_VM1A_MAIN) {
			mc_test_ref(PLM_TYPE_VM1A_MAIN, cl_opt, cl_text);
		} else {
			if (!cl_fname) {
				printf("mcode: input file must be specified\n");
				exit(-1);
			}
			mc_mterm_match(cl_type, cl_opt, cl_fname, cl_text);
		}
		exit(-1);
	}
	if (cl_speed > 0) {
		mc_test_speed(cl_type, cl_opt, cl_text);
		exit(-1);
	}
	if (cl_table > 0) {
		mc_test_table(cl_type, cl_opt, cl_text);
		exit(-1);
	}
	if (cl_count > 0) {
		mc_test_count(cl_type, cl_opt, cl_text);
		exit(-1);
	}
	if (cl_mterm > 0 && cl_match < 0) {
		if (!cl_fname) {
			printf("mcode: output file must be specified\n");
			exit(-1);
		}
		mc_mterm_write(cl_type, cl_opt, cl_fname, cl_text);
	}
	if (cl_qmc >= 0) {
		mc_test_qmc(cl_type, cl_opt, cl_text);
		exit(-1);
	}
	printf("\n");
}
