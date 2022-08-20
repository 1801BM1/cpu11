/* SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Microcode programmable logic	matrix analyzer.
 * Copyright 2015-2020 Viacheslav Ovsiienko <1801BM1@gmail.com>
 *
 * This	program	is free	software: you can redistribute it and/or modify
 * it under the	terms of the GNU General Public	License	version	3
 * as published	by the Free Software Foundation.
 *
 * This	program	is distributed in the hope that	it will	be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see	<http://www.gnu.org/licenses/>.
 */
#include "mcode.h"

enum arr_index {
	ARR_VALUE = 0,		/* original values */
	ARR_REDUX,		/* reduced after essentials */
	ARR_CHECK,		/* gathering for check */
	ARR_PRIME_V,		/* prime implicant values */
	ARR_PRIME_M,		/* prime implicant masks */
	ARR_ESSEN_V,		/* essential implicant values */
	ARR_ESSEN_M,		/* essential implicant mask */
	ARR_MAX
};

#define QMC_NBIT   16			/* width of input field in bits */
#define QMC_NMAX   (1 << QMC_NBIT)	/* array sizes for full range */
#define QMC_ALIGN  16			/* buffer alignments in qmc_t */
#define QMC_EXT	   0x4000		/* number of elements to extend */
#define QMC_INI	   64			/* initial number of elements */

typedef uint16_t   qmc_t;		/* basic data element */
typedef uint32_t   len_t;		/* data element array length */

struct arr {
	len_t	size;			/* array size in elements */
	len_t	len;			/* number of stored elements */
					/* alignment for AVX2 vectors */
	uint8_t align[QMC_ALIGN * sizeof(qmc_t) - 2 * sizeof(len_t)];
	qmc_t	data[0];		/* data array */
};

struct grp {
	len_t	    ncnt;		/* number of nodes */
	struct arr  *xmsk;		/* array of X-masks */
	struct arr  *node[0];		/* array of data for masks */
};

/* pointers to lowest level loop routines, can be vectorized */
static int (*qmc_check)(const struct arr *a, qmc_t value);
static void (*qmc_scan)(qmc_t term, qmc_t xmask,
			const struct arr *array,
			struct grp *prime);
static void (*qmc_term)(qmc_t term, qmc_t xmask,
			const struct arr *anext,
			const struct grp *gprev,
			struct grp *merge,
			struct grp *prime);
#ifdef __GNUC__
static inline void *_aligned_malloc(size_t size, size_t align)
{
	return aligned_alloc(align, size);
}

static inline void _aligned_free(void *p)
{
	free(p);
}
#endif

static void qmc_print(qmc_t term, qmc_t xmsk, char *line)
{
	uint16_t i = QMC_NBIT;

	do {
		line[i-1] = (xmsk & 1) ? 'x' : (term & 1) + '0';
		term >>= 1;
		xmsk >>= 1;
	} while (--i);
	line[QMC_NBIT] = 0;
}

static void arr_print(struct arr *av, char *text)
{
	len_t i;

	if (!av || !av->len) {
		printf("%s (empty)\n", text);
		return;
	}
	printf("%s:\n", text);
	for (i = 0; i < av->len; i++) {
		char line[QMC_NBIT + 1];

		qmc_print(av->data[i], 0, line);
		printf("  %s\n", line);
	}
}

static void arr_print2(struct arr *av, struct arr *am, char *text)
{
	len_t i;

	if (!av || !am || !av->len || !am->len) {
		printf("%s (empty)\n", text);
		return;
	}
	printf("%s: %u\n", text, av->len);
	for (i = 0; i < av->len; i++) {
		char line[QMC_NBIT + 1];

		qmc_print(av->data[i], am->data[i], line);
		printf("  %s\n", line);
	}
}

static void grp_print(struct grp *group, char *text)
{
	char line[QMC_NBIT + 1];
	struct arr *x = group->xmsk;
	len_t i, j;

	if (!x || !x->len) {
		printf("%s (empty)\n", text);
		return;
	}
	printf("%s:\n", text);
	for (i = 0; i < x->len; i++) {
		qmc_t xmsk = x->data[i];
		struct arr *d = group->node[xmsk];

		if (!d || !d->len)
			continue;
		for (j = 0; j < d->len; j++) {
			qmc_print(d->data[j], xmsk, line);
			printf("  %s\n", line);
		}
	}
}

/* Frees the allocated arr structure */
static inline void arr_free(struct arr *a)
{
	_aligned_free(a);
}

/*
 * Reallocates the arr structure to accomodate the specified amount of
 * elements, if the first parameter is not NULL the elements from this
 * are copied to the new allocated structure.
 */
static struct arr *arr_alloc(struct arr *a, len_t size)
{
	struct arr *p;

	if (a && a->size >= size)
		return a;

	size = (size + QMC_ALIGN - 1) & ~(QMC_ALIGN - 1);
	p = _aligned_malloc(size * sizeof(qmc_t) + sizeof(struct arr),
			    QMC_ALIGN * sizeof(qmc_t));
	if (!p) {
		printf("mcode: memory allocation failure (%u)\n", size);
		exit(-1);
	}
	if (a) {
		p->size = size;
		p->len = a->len;
		assert(p->size >= a->size);
		memcpy(p->data, a->data, a->len * sizeof(qmc_t));
		arr_free(a);
	} else {
		memset(p, 0, sizeof(struct arr));
		p->size = size;
	}
	return p;
}

/*
 * Extends the arr structure to accomodate the specified amount of
 * new elements is going to be appended to existing ones.
 */
static inline void arr_extend(struct arr **pa, len_t size)
{
	struct arr *a = *pa;
	len_t asiz = a->size;

	size += a->len;
	if (size <= asiz)
		return;
	do {
		asiz = (asiz > QMC_EXT) ?
		       (size + QMC_EXT - 1) & ~(QMC_EXT - 1) : asiz * 2;
	} while (asiz < size);
	*pa = arr_alloc(a, asiz);
}

/* Appends single element to the and of data array */
static inline void arr_append(struct arr **pa, qmc_t value)
{
	arr_extend(pa, 1);
	pa[0]->data[pa[0]->len++] = value;

	assert(pa[0]->len <= QMC_NMAX);
}

static len_t grp_len(const struct grp *g)
{
	len_t len = 0;

	if (g && g->xmsk && g->xmsk->len) {
		struct arr *x = g->xmsk;
		len_t i;

		for (i = 0; i < x->len; i++)
			len += g->node[x->data[i]]->len;
	}
	return len;
}

static void grp_prime(struct grp *group, struct grp *store)
{
	struct arr *x = group->xmsk;
	len_t len = grp_len(group);
	len_t i, j;

	if (x == NULL || x->len == 0 || len == 0)
		return;
	arr_free(store->node[ARR_PRIME_V]);
	arr_free(store->node[ARR_PRIME_M]);
	store->node[ARR_PRIME_V] = arr_alloc(NULL, len);
	store->node[ARR_PRIME_M] = arr_alloc(NULL, len);
	for (i = 0; i < x->len; i++) {
		qmc_t xmsk = x->data[i];
		struct arr *d = group->node[xmsk];

		if (!d || !d->len)
			continue;
		for (j = 0; j < d->len; j++) {
			arr_append(&store->node[ARR_PRIME_V], d->data[j]);
			arr_append(&store->node[ARR_PRIME_M], xmsk);
		}
	}
}

/* Frees the allocated grp structure */
static inline void grp_free(struct grp *g)
{
	if (!g)
		return;
	if (g->xmsk && g->xmsk->len) {
		struct arr *x = g->xmsk;
		len_t i;

		for (i = 0; i < x->len; i++)
			arr_free(g->node[x->data[i]]);
	}
	_aligned_free(g);
}

static struct grp *grp_alloc(len_t ncnt)
{
	struct grp *p;

	p = _aligned_malloc(sizeof(struct grp) + ncnt * sizeof(struct arr *),
			    QMC_ALIGN * sizeof(qmc_t));
	if (!p) {
		printf("mcode: memory allocation failure (GRP)\n");
		exit(-1);
	}
	memset(p, 0, sizeof(struct grp) + ncnt * sizeof(struct arr *));
	p->ncnt = ncnt;
	p->xmsk = arr_alloc(NULL, QMC_INI);
	return p;
}

static int qmc_check_u32(const struct arr *a, qmc_t value)
{
	const qmc_t *p;
	len_t n;

	if (!a || !a->len)
		return 0;
	n = a->len;
	p = a->data;

	do {
		if (*p++ == value)
			return 1;
	} while (--n);
	return 0;
}

static int qmc_check_128(const struct arr *a, qmc_t value)
{
	const qmc_t *p;
	len_t n, vn;

	if (!a || !a->len)
		return 0;
	n = a->len;
	p = a->data;
	vn = n >> 3;
	if (vn) {
		const register __m128i vc = _mm_set1_epi16(value);
		register __m128i vx;
		const __m128i *vp = (const __m128i *)p;

		p += vn << 3;
		/* SSE2/128-bit code, handles eight elements per iteration */
		do {
			vx = _mm_load_si128(vp);
			vx = _mm_cmpeq_epi16(vx, vc);
			if (_mm_movemask_epi8(vx))
				return 1;
			++vp;
		} while (--vn);
		n &= (8 - 1);
	}
	while (n--) {
		if (*p++ == value)
			return 1;
	}
	return 0;
}

static int qmc_check_256(const struct arr *a, qmc_t value)
{
	const qmc_t *p;
	len_t n, vn;

	if (!a || !a->len)
		return 0;
	n = a->len;
	p = a->data;
	vn = n >> 4;
	if (vn) {
		const register __m256i vc = _mm256_set1_epi16(value);
		register __m256i vx;
		const __m256i *vp = (const __m256i *)p;

		p += vn << 4;
		/* AVX2/256-bit code, handles sixteen elements per iteration */
		do {
			vx = _mm256_load_si256(vp);
			vx = _mm256_cmpeq_epi16(vx, vc);
			if (_mm256_movemask_epi8(vx))
				return 1;
			++vp;
		} while (--vn);
		n &= (16 - 1);
	}
	while (n--) {
		if (*p++ == value)
			return 1;
	}
	return 0;
}

static void grp_append(struct grp *g, qmc_t term, qmc_t xmsk)
{
	if (!g->node[xmsk]) {
		g->node[xmsk] = arr_alloc(NULL, QMC_INI);
		arr_append(&g->xmsk, xmsk);
		arr_append(&g->node[xmsk], term);
		return;
	}
	if (qmc_check(g->node[xmsk], term))
		return;
	arr_append(&g->node[xmsk], term);
}

static inline void grp_cat(struct grp *prime, const struct grp *group)
{
	if (group && group->xmsk && group->xmsk->len) {
		struct arr *x = group->xmsk;
		len_t i, j;

		for (i = 0; i < x->len; i++) {
			const qmc_t xm = x->data[i];
			struct arr *a = group->node[xm];
			const len_t len = a->len;

			if (len)
				for (j = 0; j < len; j++)
					grp_append(prime, a->data[j], xm);
		}
	}
}

static void qmc_scan_u32(qmc_t term, qmc_t xmask,
			 const struct arr *array,
			 struct grp *prime)
{
	const qmc_t *p = array->data;
	len_t n = array->len;

	while (n--) {
		qmc_t v = term ^ *p++;

		assert(v);
		if ((v & (v - 1)) == 0)
			return;
	}
	grp_append(prime, term, xmask);
}

static void qmc_scan_128(qmc_t term, qmc_t xmask,
			 const struct arr *array,
			 struct grp *prime)
{
	const qmc_t *p = array->data;
	len_t n = array->len;
	len_t vn = n >> 3;

	if (vn) {
		const register __m128i vc = _mm_set1_epi16(term);
		const register __m128i vo = _mm_set1_epi16(1);
		const register __m128i vz = _mm_setzero_si128();
		register __m128i vx, vt;
		const __m128i *vp = (const __m128i *)p;

		p += vn << 3;
		/* SSE2/128-bit code, handles eight elements per iteration */
		do {
			vx = _mm_load_si128(vp);
			vx = _mm_xor_si128(vx, vc);
			vt = _mm_sub_epi16(vx, vo);
			vx = _mm_and_si128(vx, vt);
			vx = _mm_cmpeq_epi16(vx, vz);
			if (_mm_movemask_epi8(vx))
				return;
			++vp;
		} while (--vn);
		n &= (8 - 1);
	}
	while (n--) {
		qmc_t v = term ^ *p++;

		if ((v & (v - 1)) == 0)
			return;
	}
	grp_append(prime, term, xmask);
}

static void qmc_scan_256(qmc_t term, qmc_t xmask,
	const struct arr *array,
	struct grp *prime)
{
	const qmc_t *p = array->data;
	len_t n = array->len;
	len_t vn = n >> 4;

	if (vn) {
		const register __m256i vc = _mm256_set1_epi16(term);
		const register __m256i vo = _mm256_set1_epi16(1);
		const register __m256i vz = _mm256_setzero_si256();
		register __m256i vx, vt;
		const __m256i *vp = (const __m256i *)p;

		p += vn << 4;
		/* AVX2/256-bit code, handles sixteen elements per iteration */
		do {
			vx = _mm256_load_si256(vp);
			vx = _mm256_xor_si256(vx, vc);
			vt = _mm256_sub_epi16(vx, vo);
			vx = _mm256_and_si256(vx, vt);
			vx = _mm256_cmpeq_epi16(vx, vz);
			if (_mm256_movemask_epi8(vx))
				return;
			++vp;
		} while (--vn);
		n &= (16 - 1);
	}
	while (n--) {
		qmc_t v = term ^ *p++;

		if ((v & (v - 1)) == 0)
			return;
	}
	grp_append(prime, term, xmask);
}

/* Scans array of terms in the specified group, not found is added to primes */
static inline void arr_scan(const struct arr *array,
			    qmc_t xmask,
			    const struct grp *group,
			    struct grp *prime)
{
	const struct arr *ga = group->node[xmask];
	const qmc_t *p = array->data;
	len_t n = array->len;

	assert(n);
	if (ga)
		do {
			qmc_scan(*p++, xmask, ga, prime);
		} while (--n);
	else
		do {
			grp_append(prime, *p++, xmask);
		} while (--n);
}

static void qmc_term_u32(qmc_t term, qmc_t xmask,
			 const struct arr *anext,
			 const struct grp *gprev,
			 struct grp *merge,
			 struct grp *prime)
{
	if (anext) {
		const qmc_t *p = anext->data;
		len_t n = anext->len;
		len_t m = 0;

		assert(n);
		while (n--) {
			qmc_t v = term ^ *p++;

			assert(v);
			if ((v & (v - 1)) == 0) {
				grp_append(merge, term & ~v, xmask | v);
				m++;
			}
		}
		if (m)
			return;
	}
	if (gprev && gprev->node[xmask])
		qmc_scan(term, xmask, gprev->node[xmask], prime);
	else
		grp_append(prime, term, xmask);
}

static void qmc_term_128(qmc_t term, qmc_t xmask,
	const struct arr *anext,
	const struct grp *gprev,
	struct grp *merge,
	struct grp *prime)
{
	if (anext) {
		const qmc_t *p = anext->data;
		len_t n = anext->len;
		len_t m = 0;
		len_t vn = n >> 3;

		if (vn) {
			const register __m128i vc = _mm_set1_epi16(term);
			const register __m128i vs = _mm_set1_epi16(xmask);
			const register __m128i vo = _mm_set1_epi16(1);
			const register __m128i vz = _mm_setzero_si128();
			register __m128i vx, vt;
			const __m128i *vp = (const __m128i *)p;
			uint32_t vm;

			p += vn << 3;
			/* SSE2/128-bit code, handles eight elements */
			do {
				vx = _mm_load_si128(vp);
				vx = _mm_xor_si128(vx, vc);	/* ^ term */
				vt = _mm_sub_epi16(vx, vo);	/* v - 1 */
				vt = _mm_and_si128(vx, vt);	/* v & (v-1) */
				vt = _mm_cmpeq_epi16(vt, vz);
				vm = _mm_movemask_epi8(vt);
				++vp;
				if (!vm)
					continue;
				m++;
				vt = _mm_xor_si128(vt, vx);	/* ~v */
				vt = _mm_and_si128(vt, vc);	/* & term */
				vx = _mm_or_si128(vx, vs);	/* | mask */

				if (vm & (3ul << 0))
					grp_append(merge,
						_mm_extract_epi16(vt, 0),
						_mm_extract_epi16(vx, 0));
				if (vm & (3ul << 2))
					grp_append(merge,
						_mm_extract_epi16(vt, 1),
						_mm_extract_epi16(vx, 1));
				if (vm & (3ul << 4))
					grp_append(merge,
						_mm_extract_epi16(vt, 2),
						_mm_extract_epi16(vx, 2));
				if (vm & (3ul << 6))
					grp_append(merge,
						_mm_extract_epi16(vt, 3),
						_mm_extract_epi16(vx, 3));
				vm &= ~0x000000FF;
				if (!vm)
					continue;

				if (vm & (3ul << 8))
					grp_append(merge,
						_mm_extract_epi16(vt, 4),
						_mm_extract_epi16(vx, 4));
				if (vm & (3ul << 10))
					grp_append(merge,
						_mm_extract_epi16(vt, 5),
						_mm_extract_epi16(vx, 5));
				if (vm & (3ul << 12))
					grp_append(merge,
						_mm_extract_epi16(vt, 6),
						_mm_extract_epi16(vx, 6));
				if (vm & (3ul << 14))
					grp_append(merge,
						_mm_extract_epi16(vt, 7),
						_mm_extract_epi16(vx, 7));
			} while (--vn);
			n &= (8 - 1);
		}
		while (n--) {
			qmc_t v = term ^ *p++;

			assert(v);
			if ((v & (v - 1)) == 0) {
				grp_append(merge, term & ~v, xmask | v);
				m++;
			}
		}
		if (m)
			return;
	}
	if (gprev && gprev->node[xmask])
		qmc_scan(term, xmask, gprev->node[xmask], prime);
	else
		grp_append(prime, term, xmask);
}

static void qmc_term_256(qmc_t term, qmc_t xmask,
	const struct arr *anext,
	const struct grp *gprev,
	struct grp *merge,
	struct grp *prime)
{
	if (anext) {
		const qmc_t *p = anext->data;
		len_t n = anext->len;
		len_t m = 0;
		len_t vn = n >> 4;

		if (vn) {
			const register __m256i vc = _mm256_set1_epi16(term);
			const register __m256i vs = _mm256_set1_epi16(xmask);
			const register __m256i vo = _mm256_set1_epi16(1);
			const register __m256i vz = _mm256_setzero_si256();
			register __m256i vx, vt;
			const __m256i *vp = (const __m256i *)p;
			uint32_t vm;

			p += vn << 4;
			/* AVX2/256-bit code, handles sixteen elements */
			do {
				vx = _mm256_load_si256(vp);
				vx = _mm256_xor_si256(vx, vc);	/* ^ term */
				vt = _mm256_sub_epi16(vx, vo);  /* v - 1 */
				vt = _mm256_and_si256(vx, vt);  /* v & (v-1) */
				vt = _mm256_cmpeq_epi16(vt, vz);
				vm = _mm256_movemask_epi8(vt);
				++vp;
				if (!vm)
					continue;
				m++;
				vt = _mm256_xor_si256(vt, vx);	/* ~v */
				vt = _mm256_and_si256(vt, vc);	/* & term */
				vx = _mm256_or_si256(vx, vs);	/* | mask */

				if (vm & (3ul << 0))
					grp_append(merge,
						_mm256_extract_epi16(vt, 0),
						_mm256_extract_epi16(vx, 0));
				if (vm & (3ul << 2))
					grp_append(merge,
						_mm256_extract_epi16(vt, 1),
						_mm256_extract_epi16(vx, 1));
				if (vm & (3ul << 4))
					grp_append(merge,
						_mm256_extract_epi16(vt, 2),
						_mm256_extract_epi16(vx, 2));
				if (vm & (3ul << 6))
					grp_append(merge,
						_mm256_extract_epi16(vt, 3),
						_mm256_extract_epi16(vx, 3));
				vm &= ~0x000000FF;
				if (!vm)
					continue;

				if (vm & (3ul << 8))
					grp_append(merge,
						_mm256_extract_epi16(vt, 4),
						_mm256_extract_epi16(vx, 4));
				if (vm & (3ul << 10))
					grp_append(merge,
						_mm256_extract_epi16(vt, 5),
						_mm256_extract_epi16(vx, 5));
				if (vm & (3ul << 12))
					grp_append(merge,
						_mm256_extract_epi16(vt, 6),
						_mm256_extract_epi16(vx, 6));
				if (vm & (3ul << 14))
					grp_append(merge,
						_mm256_extract_epi16(vt, 7),
						_mm256_extract_epi16(vx, 7));
				vm &= ~0x0000FF00;
				if (!vm)
					continue;

				if (vm & (3ul << 16))
					grp_append(merge,
						_mm256_extract_epi16(vt, 8),
						_mm256_extract_epi16(vx, 8));
				if (vm & (3ul << 18))
					grp_append(merge,
						_mm256_extract_epi16(vt, 9),
						_mm256_extract_epi16(vx, 9));
				if (vm & (3ul << 20))
					grp_append(merge,
						_mm256_extract_epi16(vt, 10),
						_mm256_extract_epi16(vx, 10));
				if (vm & (3ul << 22))
					grp_append(merge,
						_mm256_extract_epi16(vt, 11),
						_mm256_extract_epi16(vx, 11));
				vm &= ~0x00FF0000;
				if (!vm)
					continue;

				if (vm & (3ul << 24))
					grp_append(merge,
						_mm256_extract_epi16(vt, 12),
						_mm256_extract_epi16(vx, 12));
				if (vm & (3ul << 26))
					grp_append(merge,
						_mm256_extract_epi16(vt, 13),
						_mm256_extract_epi16(vx, 13));
				if (vm & (3ul << 28))
					grp_append(merge,
						_mm256_extract_epi16(vt, 14),
						_mm256_extract_epi16(vx, 14));
				if (vm & (3ul << 30))
					grp_append(merge,
						_mm256_extract_epi16(vt, 15),
						_mm256_extract_epi16(vx, 15));
			} while (--vn);
			n &= (16 - 1);
		}
		while (n--) {
			qmc_t v = term ^ *p++;

			assert(v);
			if ((v & (v - 1)) == 0) {
				grp_append(merge, term & ~v, xmask | v);
				m++;
			}
		}
		if (m)
			return;
	}
	if (gprev && gprev->node[xmask])
		qmc_scan(term, xmask, gprev->node[xmask], prime);
	else
		grp_append(prime, term, xmask);
}

/*
 * Scans terms from array in the next group, appends next order terms
 * to merge on found matches, if nothing found, scans the prev group,
 * if found neither it is appended to primes.
 */
static inline void arr_term(const struct arr *array,
			    qmc_t xmask,
			    const struct grp *gprev,
			    const struct grp *gnext,
			    struct grp *merge,
			    struct grp *prime)
{
	const qmc_t *p = array->data;
	len_t n = array->len;

	assert(n);
	while (n--)
		qmc_term(*p++, xmask, gnext->node[xmask], gprev, merge, prime);
}

/* Builds the next order terms for the group with the next neighbour only */
static inline struct grp *grp_merge_first(const struct grp *group,
					  const struct grp *gnext,
					  struct grp *prime)
{
	struct grp *merge = grp_alloc(QMC_NMAX);
	struct arr *x = group->xmsk;
	qmc_t *p;
	len_t n;

	if (!x || !x->len)
		return merge;
	if (!gnext->xmsk || !gnext->xmsk->len) {
		grp_cat(prime, group);
		return merge;
	}
	p = x->data;
	n = x->len;
	do {
		qmc_t xmask = *p++;

		arr_term(group->node[xmask], xmask, NULL, gnext, merge, prime);
	} while (--n);
	return merge;
}

/* Builds the next order terms for the group with the prev neighbour only */
static inline void grp_merge_last(const struct grp *group,
				  const struct grp *gprev,
				  struct grp *prime)
{
	struct arr *x = group->xmsk;
	qmc_t *p;
	len_t n;

	if (!x || !x->len)
		return;
	if (!gprev->xmsk || !gprev->xmsk->len) {
		grp_cat(prime, group);
		return;
	}
	p = x->data;
	n = x->len;
	do {
		qmc_t xmask = *p++;

		arr_scan(group->node[xmask], xmask, gprev, prime);
	} while (--n);
}

/* Builds the next order terms for the group with both neighbours */
static inline struct grp *grp_merge_next(const struct grp *group,
					 const struct grp *gprev,
					 const struct grp *gnext,
					 struct grp *prime)
{
	struct grp *merge = grp_alloc(QMC_NMAX);
	struct arr *x = group->xmsk;
	qmc_t *p;
	len_t n;

	if (!x || !x->len)
		return merge;
	if (!gnext->xmsk || !gnext->xmsk->len) {
		grp_merge_last(group, gprev, prime);
		return merge;
	}
	p = x->data;
	n = x->len;
	do {
		qmc_t xmask = *p++;

		arr_term(group->node[xmask], xmask,
			 gprev, gnext, merge, prime);
	} while (--n);
	return merge;
}

static void qmc16_order(struct grp **group, struct grp *prime, uint32_t n)
{
	struct grp *gprev = NULL;
	uint32_t i;

	for (i = 0; i <= QMC_NBIT - n; i++) {
		struct grp *gnext;
		uint64_t start;
		len_t len;

		 /* grp_print(group[i], "  group data"); */
		start = mc_query_ms();
		if (!i) {
			gnext = grp_merge_first(group[0], group[1], prime);
		} else if (i == QMC_NBIT - n) {
			grp_merge_last(group[i], gprev, prime);
			grp_free(gprev);
			gnext = NULL;
		} else {
			gnext = grp_merge_next(group[i], gprev,
					       group[i + 1], prime);
			grp_free(gprev);
		}
		gprev = group[i];
		group[i] = gnext;

		len = grp_len(gnext);
		if (len) {
			start = mc_query_ms() - start;
			printf("  round [%u,%u]", n, i);
			printf(" %u/%u (%" PRIu64 ".%03" PRIu64 " ms)\n",
			       len, grp_len(prime),
			       start / 1000, start % 1000);
		}
	}
}

/* Finding the prime minterms */
static void qmc16_essen(struct grp *store)
{
	len_t i, nv = store->node[ARR_VALUE]->len;
	uint64_t start;

	store->node[ARR_ESSEN_V] =
			arr_alloc(NULL, store->node[ARR_PRIME_V]->size);
	store->node[ARR_ESSEN_M] =
			arr_alloc(NULL, store->node[ARR_PRIME_V]->size);
	store->node[ARR_REDUX] = arr_alloc(NULL, QMC_INI);
	start = mc_query_ms();

	for (i = 0; i < nv; i++) {
		qmc_t v = store->node[ARR_VALUE]->data[i];
		qmc_t *pv = store->node[ARR_PRIME_V]->data;
		qmc_t *pm = store->node[ARR_PRIME_M]->data;
		len_t j, np = store->node[ARR_PRIME_V]->len;
		int ec = -1;

		for (j = 0; j < np; j++) {
			if ((v & ~*pm++) == *pv++) {
				if (ec >= 0)
					break;
				ec = j;
			}
		}
		assert(ec >= 0);
		if (j >= np) {
			if (!qmc_check(store->node[ARR_ESSEN_V], ec))
				arr_append(&store->node[ARR_ESSEN_V], ec);
		}
	}
	/* Convert pprime indices into values/masks. */
	nv = store->node[ARR_ESSEN_V]->len;
	for (i = 0; i < nv; i++) {
		len_t x = store->node[ARR_ESSEN_V]->data[i];

		store->node[ARR_ESSEN_V]->data[i] =
					store->node[ARR_PRIME_V]->data[x];
		store->node[ARR_ESSEN_M]->data[i] =
					store->node[ARR_PRIME_M]->data[x];
	}
	store->node[ARR_ESSEN_M]->len = store->node[ARR_ESSEN_V]->len;

	start = mc_query_ms() - start;
	arr_print2(store->node[ARR_ESSEN_V],
		   store->node[ARR_ESSEN_M],
		   "Found essential implicants");
	printf("Essentials done in: %" PRIu64 ".%03" PRIu64 "\n", start / 1000, start % 1000);

	/* Exclude values covered with essentials. */
	start = mc_query_ms();
	nv = store->node[ARR_VALUE]->len;
	for (i = 0; i < nv; i++) {
		qmc_t v = store->node[ARR_VALUE]->data[i];
		qmc_t *ev = store->node[ARR_ESSEN_V]->data;
		qmc_t *em = store->node[ARR_ESSEN_M]->data;
		len_t j, ne = store->node[ARR_ESSEN_V]->len;

		for (j = 0; j < ne; j++)
			if ((v & ~*em++) == *ev++)
				break;
		if (j >= ne)
			arr_append(&store->node[ARR_REDUX], v);
	}
	start = mc_query_ms() - start;
	printf("Not covered by essen %u/%u in: %" PRIu64 ".%03" PRIu64 "\n",
		store->node[ARR_REDUX]->len,
		store->node[ARR_VALUE]->len,
		start / 1000, start % 1000);
	if (cl_qmc > 2)
		arr_print(store->node[ARR_REDUX], "Redux");
}

static void qmc_gather(const struct plm *tpl,
		       struct arr *av, struct arr *ap, struct arr *am)
{
	len_t val, max;

	max = 1ul << tpl->in_nb;
	for (val = 0; val < max; val++) {
		qmc_t *pv = ap->data;
		qmc_t *pm = am->data;
		len_t n = ap->len;

		do {
			if ((val & ~*pm++) == *pv++) {
				arr_append(&av, val);
				break;
			}
		} while (--n);
	}
}

/* Check the value coverage */
static void qmc16_verify(const struct plm *tpl, struct grp *store)
{
	uint64_t start;
	len_t vlen;

	if (!store->node[ARR_VALUE] ||
	    !store->node[ARR_PRIME_V] ||
	    !store->node[ARR_PRIME_M] ||
	    !store->node[ARR_VALUE]->len ||
	    !store->node[ARR_PRIME_V]->len ||
	    !store->node[ARR_PRIME_M]->len)
		return;
	start = mc_query_ms();
	vlen = store->node[ARR_VALUE]->len;
	arr_free(store->node[ARR_CHECK]);
	store->node[ARR_CHECK] = arr_alloc(NULL, vlen);

	qmc_gather(tpl,
		   store->node[ARR_CHECK],
		   store->node[ARR_PRIME_V],
		   store->node[ARR_PRIME_M]);
	if (store->node[ARR_CHECK]->len != vlen ||
	    memcmp(store->node[ARR_CHECK]->data,
		   store->node[ARR_VALUE]->data,
		   sizeof(qmc_t) * vlen)) {
		start = mc_query_ms() - start;
		printf("Verification failed");
		/* arr_print(store->node[ARR_VALUE], "Value"); */
		/* arr_print(store->node[ARR_CHECK], "Check"); */
	} else {
		start = mc_query_ms() - start;
		printf("Verification succeeded");
	}
	printf(" in: %" PRIu64 ".%03" PRIu64 "\n", start / 1000, start % 1000);
}

/* Finding the prime minterms */
static void qmc16_prime(const struct plm *tpl,
			struct grp **group,
			struct grp *store)
{
	struct grp *prime = grp_alloc(QMC_NMAX);
	uint32_t i;

	printf("Finding prime implicants, wait...\n");
	for (i = 0; i < QMC_NBIT; i++)
		qmc16_order(group, prime, i);

	grp_prime(prime, store);
	grp_free(prime);
	arr_print2(store->node[ARR_PRIME_V],
		   store->node[ARR_PRIME_M],
		   "Found prime implicants");
	if (cl_qmc > 1)
		qmc16_essen(store);
	qmc16_verify(tpl, store);
}

static int qmc16_opt(enum opt_type opt)
{
	switch (opt) {
	case PLM_OPT_32:
	case PLM_OPT_32_TREE:
	case PLM_OPT_64:
	case PLM_OPT_64_TREE:
		qmc_check = qmc_check_u32;
		qmc_scan  = qmc_scan_u32;
		qmc_term  = qmc_term_u32;
		return 0;
	case PLM_OPT_128:
	case PLM_OPT_128_TREE:
		if (sizeof(qmc_t) == sizeof(uint16_t) &&
			(mc_query_simd() & SIMD_SSE2)) {
			qmc_check = qmc_check_128;
			qmc_scan  = qmc_scan_128;
			qmc_term  = qmc_term_128;
			return 0;
		}
		printf("mcode: AVX2 is required\n");
		return -1;
	case PLM_OPT_256:
	case PLM_OPT_256_TREE:
		if (sizeof(qmc_t) == sizeof(uint16_t) &&
		    (mc_query_simd() & SIMD_AVX2)) {
			qmc_check = qmc_check_256;
			qmc_scan  = qmc_scan_256;
			qmc_term  = qmc_term_256;
			return 0;
		}
		printf("mcode: AVX2 is required\n");
		return -1;
	default:
		printf("mcode: unrecognized opt type %d\n", opt);
		assert(0);
		return -1;
	}
}

void mc_test_qmc16(const struct plm *tpl)
{
	struct grp *store;
	struct grp *group[QMC_NBIT + 1];
	uint32_t amx, adr, ab, ae;
	uint32_t val, max, i, n, op, om;
	uint64_t start;

	if (qmc16_opt(tpl->opt))
		return;
	max = 1ul << tpl->in_nb;	/* input value limit */
	amx = 1ul << tpl->na_nb;	/* microaddress limit */
	ab = cl_ab < 0 ? 0 : MIN(cl_ab, (int)amx);
	ae = cl_ae < 0 ? amx : MIN(cl_ae, (int)amx);
	op = cl_op < 0 ? 0 : (uint32_t)cl_op;
	om = cl_om < 0 ? 0 : (uint32_t)cl_om;

	start = mc_query_ms();
	for (adr = ab; adr < ae; adr++) {
		store = grp_alloc(ARR_MAX);
		for (i = 0; i <= QMC_NBIT; i++)
			group[i] = grp_alloc(QMC_NMAX);
		n = 0;
		/* fill the groups depending on the number of bits */
		if (om) {
			for (val = 0; val < max; val++) {
				uint64_t sop;

				if ((val & om) != op)
					continue;
				sop = plm_get(tpl, val) >> PLM_S_MAX;
				if (sop == adr) {
					i = _mm_popcnt_u32(val);
					assert(i <= QMC_NBIT);
					grp_append(group[i], val, 0);
					grp_append(store, val, ARR_VALUE);
					n++;
				}
			}
		} else {
			for (val = 0; val < max; val++) {
				uint64_t sop = plm_get(tpl, val) >> PLM_S_MAX;

				if (sop == adr) {
					i = _mm_popcnt_u32(val);
					assert(i <= QMC_NBIT);
					grp_append(group[i], val, 0);
					grp_append(store, val, ARR_VALUE);
					n++;
				}
			}
		}
		if (n) {
			printf("Adress %02X: %u\n", adr, n);
			if (cl_qmc <= 0) {
				for (i = 0; i <= QMC_NBIT; i++)
					if (group[i]->node[0] &&
					    group[i]->node[0]->len)
						printf("  [%02u] %u\n", i,
						       group[i]->node[0]->len);
			} else {
				/* execute the next stages of algorithm */
				qmc16_prime(tpl, group, store);
			}
		}
		for (i = 0; i <= QMC_NBIT; i++)
			grp_free(group[i]);
		grp_free(store);
	}
	start = mc_query_ms() - start;
	printf("Elapsed: %" PRIu64 ".%03" PRIu64 "\n",
		start / 1000, start % 1000);
}

