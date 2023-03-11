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
#pragma once

#define	_CRT_SECURE_NO_DEPRECATE	1

#if defined(_WIN32) || defined(_WIN64)
#include <windows.h>
#endif

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <inttypes.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <immintrin.h>
#include <errno.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>

#define PLM_S_MAX 48		/* maximal width of Sum-of-Products */
#define PLM_P_MAX 400		/* maximal number of products supported */
#define PLM_NA_MAX_BITS 9	/* the maximal Next Address field */
#define PLM_M_TREE_BITS 4	/* the number of bits M optimization */
#define PLM_M_TREE (1u << PLM_M_TREE_BITS)
#define PLM_NA_MAX (1u << PLM_NA_MAX_BITS)
#define MCODE_PARAM_LEN 80
#define FILE_BUF_WORDS	0x10000
#define FILE_MAX_ERRORS	0x100

enum plm_type {
	PLM_TYPE_NONE = 0,
	PLM_TYPE_VM1A_MAIN,
	PLM_TYPE_VM1G_MAIN,
	PLM_TYPE_VM2_MAIN,
	PLM_TYPE_F11_CS0,
	PLM_TYPE_F11_CS1,
	PLM_TYPE_F11_CS2,
	PLM_TYPE_F11_NA_CLR0,
	PLM_TYPE_VM2_DEC,
	PLM_TYPE_VM3_DEC,
	PLM_TYPE_VM3_MAIN,
};

enum opt_type {
	PLM_OPT_NONE,
	PLM_OPT_32,		/* Direct matrix calculation over */
	PLM_OPT_64,		/* all configured products */
	PLM_OPT_128,
	PLM_OPT_256,
	PLM_OPT_32_TREE,	/* Matrix calculation over M-tree */
	PLM_OPT_64_TREE,	/* M-tree is ver simplified */
	PLM_OPT_128_TREE,	/* It has the single root */
	PLM_OPT_256_TREE,	/* with M leaves */
};

/* Programmable logic matrix descriptor to init */
struct plm_desc {
	const char *p[PLM_P_MAX];
	const int16_t *s[PLM_S_MAX];

	uint64_t xout;		/* Final inversion mask */
	uint32_t xin;		/* Input inversion mask */
	uint8_t  in_nb;		/* Input bitwidth */
	uint8_t  out_nb;	/* Output bitwidth */
	uint8_t na_nb;		/* Number of next address bits */
	uint8_t na_bits[PLM_NA_MAX_BITS];
};

struct plm_p {
	uint32_t xor;
	uint32_t and;
	uint64_t sop;
};

struct plm_p32 {
	uint32_t xor;
	uint32_t and;
	uint64_t sop;
};

struct plm_p64 {
	uint64_t xor;
	uint64_t and;
	uint64_t sop[2];
};

struct plm_p128 {
	union {
		uint32_t xor32[4];
		__m128i xor;
	};
	union {
		uint32_t and32[4];
		__m128i and;
	};
	union {
		uint64_t sop64[4];
		__m128i sop[2];
	};
};

struct plm_p256 {
	union {
		uint32_t xor32[8];
		__m256i xor;
	};
	union {
		uint32_t and32[8];
		__m256i and;
	};
	union {
		uint64_t sop64[8];
		__m256i sop[2];
	};
};

/* Packed array for vector optimizations */
struct plm_n {
	uint32_t n;
	union {
		struct plm_p32 p32[PLM_P_MAX];
		struct plm_p64 p64[PLM_P_MAX / 2];
		struct plm_p128 p128[PLM_P_MAX / 4];
		struct plm_p256 p256[PLM_P_MAX / 8];
	};
};

/* Programmable logic matrix object */
struct plm {
	uint16_t type;		/* Matrix type initialized */
	uint16_t opt;		/* Optimization type configured */
	uint16_t p_min;		/* Minimal index of product */
	uint16_t p_max;		/* Maximal index of product */
	uint64_t (*get)(const struct plm *mx, uint32_t val);
	uint64_t p_xout;	/* Final inversion mask */
	uint32_t p_xin;		/* Input inversion mask */
	uint8_t  in_nb;		/* Input bitwidth */
	uint8_t  out_nb;	/* Output bitwidth */

	uint8_t na_nb;
	uint8_t na_bits[PLM_NA_MAX_BITS];
	uint8_t mt_bits[PLM_M_TREE_BITS];

	struct plm_p p[PLM_P_MAX];
	struct plm_n tree[PLM_M_TREE];
};

struct plm_scan {
	uint8_t b[PLM_M_TREE_BITS];
	uint8_t o[PLM_M_TREE_BITS];
	uint32_t hmin;
};

extern const struct plm_desc plm_desc_vm1a;
extern const struct plm_desc plm_desc_vm1g;
extern const struct plm_desc plm_desc_vm2;
extern const struct plm_desc plm_desc_vm3;
extern const struct plm_desc plm_desc_vm2_dec;
extern const struct plm_desc plm_desc_vm3_dec;
extern const struct plm_desc plm_desc_f11_cs0;
extern const struct plm_desc plm_desc_f11_cs1;
extern const struct plm_desc plm_desc_f11_cs2;
extern const struct plm_desc plm_desc_f11_na_clr0;

extern int32_t cl_ab;
extern int32_t cl_ae;
extern int32_t cl_as;
extern int32_t cl_az;
extern int32_t cl_op;
extern int32_t cl_om;
extern int64_t cl_qv;
extern int64_t cl_qm;
extern int32_t cl_qmc;

/* Programmable logic matrix API */
int plm_init(struct plm *plm, enum plm_type type);
int plm_opt(struct plm *plm, enum opt_type opt);
void plm_show_tree(const struct plm *plm);
static inline uint64_t plm_get(const struct plm *plm, uint32_t value)
{
	return plm->get(plm, value);
}

struct ma_stats {
	struct {
		uint32_t count;
		uint32_t zeros;
		uint32_t ones;
	} jmp[PLM_NA_MAX];
	uint32_t uops;
};

void mc_test_ref(enum plm_type type, enum opt_type opt, const char *text);
void mc_mterm_match(enum plm_type type, enum opt_type opt,
		    const char *fname, const char *text);
void mc_mterm_write(enum plm_type type, enum opt_type opt,
		    const char *fname, const char *text);
void mc_test_qmc16(const struct plm *tpl);

#define SIMD_MMX	(1u << 0)
#define SIMD_SSE	(1u << 1)
#define SIMD_SSE2	(1u << 2)
#define SIMD_SSE3	(1u << 3)
#define SIMD_SSSE3	(1u << 4)
#define SIMD_SSE41	(1u << 5)
#define SIMD_SSE42	(1u << 6)
#define SIMD_AVX	(1u << 7)
#define SIMD_AVX2	(1u << 8)

uint32_t mc_query_simd(void);
uint64_t mc_query_ms(void);

#ifndef MIN
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a, b) (((a) > (b)) ? (a) : (b))
#endif
