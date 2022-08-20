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

#if defined(_WIN32) || defined(_WIN64)
static inline int get_cpuid(uint32_t *info, uint32_t leaf)
{
	__cpuid(info, leaf);
	return 0;
}

static inline int get_cpuid_ex(uint32_t *info, uint32_t leaf, uint32_t subleaf)
{
	__cpuidex(info, leaf, subleaf);
	return 0;
}

#else
#ifdef __GNUC__
#include <cpuid.h>
#include <xsaveintrin.h>

#define _XCR_XFEATURE_ENABLED_MASK 0

static inline int get_cpuid(uint32_t *info, uint32_t leaf)
{
	return __get_cpuid(leaf, info + 0, info + 1,
				 info + 2, info + 3);
}

static inline int get_cpuid_ex(uint32_t *info, uint32_t leaf, uint32_t subleaf)
{
	__cpuid_count(leaf, subleaf, info[0], info[1], info[2], info[3]);
	return 0;
}
#endif
#endif

static uint32_t simd = UINT32_MAX;

uint32_t mc_query_simd(void)
{
	if (simd == UINT32_MAX) {
		uint32_t cpuinfo[4] = { 0 };

		simd = 0;
		printf("simd:");
		get_cpuid(cpuinfo, 1);
		if (cpuinfo[3] & (1 << 25)) {
			simd |= SIMD_SSE;
			printf(" SSE");
		}
		if (cpuinfo[3] & (1 << 26)) {
			simd |= SIMD_SSE2;
			printf(" SSE2");
		}
		if (cpuinfo[2] & (1 << 0)) {
			simd |= SIMD_SSE3;
			printf(" SSE3");
		}
		if (cpuinfo[2] & (1 << 9)) {
			simd |= SIMD_SSSE3;
			printf(" SSSE3");
		}
		if (cpuinfo[2] & (1 << 19)) {
			simd |= SIMD_SSE41;
			printf(" SSE41");
		}
		if (cpuinfo[2] & (1 << 20)) {
			simd |= SIMD_SSE42;
			printf(" SSE42");
		}
		/*
		 * Checking for AVX requires 3 things:
		 * - CPUID indicates that the OS uses XSAVE and XRSTORE
		 *   instructions (allowing saving YMM registers on context
		 *   switch
		 * - CPUID indicates support for AVX
		 *   XGETBV indicates the AVX registers will be saved and
		 *   restored on context switch
		 *
		 * Note that XGETBV is only available on 686 or later CPUs, so
		 * the instruction needs to be conditionally run.
		 */
		if (cpuinfo[2] & (1u << 27) &&  /* Save and Restore YMM regs */
		    cpuinfo[2] & (1u << 28) &&  /* AVX support is claimed */
		    _xgetbv(_XCR_XFEATURE_ENABLED_MASK)) { /* OS support */
			simd |= SIMD_AVX;
			printf(" AVX");
			get_cpuid_ex(cpuinfo, 7, 0);
			if (cpuinfo[1] & (1 << 5)) {
				simd |= SIMD_AVX2;
				printf(" AVX2");
			}
		}
		if (simd == 0)
			printf(" none\n");
		else
			printf("\n");
	}
	return simd;
}
