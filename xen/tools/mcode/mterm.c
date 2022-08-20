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

struct match_stat {
	uint32_t aerr0, cnt0;
	uint32_t aerr1, cnt1;
};

static struct match_stat mc_stat[PLM_S_MAX];

static union {
	uint32_t w32[FILE_BUF_WORDS];
	uint64_t w64[FILE_BUF_WORDS];
} fbuf;

static struct plm tpl_na_clr;

static void mc_match_stat_update(uint32_t a, uint64_t df, uint64_t dp)
{
	struct match_stat *ps = mc_stat;
	uint64_t x = df ^ dp;

	do {
		if (x & 1) {
			if (df & x & 1) {
				/* Bit was wrongly cleared in PLM equations. */
				ps->aerr0 |= a;
				ps->cnt0++;
			} else {
				/* Bit was wrongly set in PLM equations. */
				ps->aerr1 |= a;
				ps->cnt1++;
			}
		}
		x >>= 1;
		df >>= 1;
		ps++;
	} while (x);
}

static void mc_match_stat_show(void)
{
	struct match_stat *ps = mc_stat;
	uint32_t i;

	for (i = 0; i < PLM_S_MAX; i++) {
		if (ps->aerr0 || ps->cnt0 || ps->aerr1 || ps->cnt1)
			printf("%02u 0:%08X-%08X 1:%08X-%08X\n",
			       i, ps->aerr0, ps->cnt0, ps->aerr1, ps->cnt1);
		ps++;
	}
}

static int mc_tst_naclr(uint32_t a, uint32_t t, uint32_t v)
{
	uint32_t org;

	org = (t & 0x0070000) | (a & 0x000FFFF);
	org = (uint32_t)(plm_get(&tpl_na_clr, org) & 0x0F);
	t &= ~(org << 16);
	return t == v;
}

static void mc_match_32(FILE *f, struct plm *tpl, const char *text)
{
	uint64_t mask = (1llu << PLM_S_MAX) - 1;
	uint32_t max, i, w, err_max = 0;
	uint32_t aerr = 0, derr = 0, cs0 = 0;
	uint32_t ab, ae, az, as;
	size_t ret;

	max = 1ul << tpl->in_nb;
	ab = cl_ab < 0 ? 0 : (uint32_t)cl_ab;
	ae = cl_ae < 0 ? max : (uint32_t)cl_ae;
	az = cl_az < 0 ? 0 : (uint32_t)cl_az;
	as = cl_as < 0 ? 0 : (uint32_t)cl_as;

	for (i = 0; i < max; i += FILE_BUF_WORDS) {
		ret = fread(fbuf.w32, sizeof(uint32_t), FILE_BUF_WORDS, f);
		if (ret != FILE_BUF_WORDS) {
			printf("mcode: input file read error (%d)\n", errno);
			fclose(f);
			exit(-1);
		}
		for (w = 0; w < FILE_BUF_WORDS; w++) {
			uint32_t t, a;

			a = i + w;
			if (a < ab)
				continue;
			if (a >= ae)
				break;
			if (a & az)
				continue;
			if (~a & as)
				continue;
			t = (uint32_t)(plm_get(tpl, a) & mask);
			if (t != fbuf.w32[w]) {
				if ((tpl->type == PLM_TYPE_F11_CS0) &&
				    (((t ^ fbuf.w32[w]) & 0x1F8FFFF) == 0) &&
				    (((t >> 16) & 0x1F8) == 0x008) &&
				    ((t ^ fbuf.w32[w]) & fbuf.w32[w]) == 0) {
					/* na_clr matrix of f11_cs0 */
					if (mc_tst_naclr(a, t, fbuf.w32[w])) {
						cs0++;
						continue;
					}
				}
				derr |= t ^ fbuf.w32[w];
				aerr |= a;
				mc_match_stat_update(a, fbuf.w32[w], t);
				if (err_max++ >= FILE_MAX_ERRORS)
					continue;
				printf("Mismatch: %08X != %08X @ %08X\n",
					t, fbuf.w32[w], a);
			}
		}
		if (i >= ae)
			break;
	}
	printf("Match result %s: %08X, %08X\n", text, aerr, derr);
	if (cs0)
		printf("Ignored f11-cs0 na_clr resets: %08X\n", cs0);
	if (err_max)
		mc_match_stat_show();
}

static void mc_match_64(FILE *f, struct plm *tpl, const char *text)
{
	uint64_t mask = (1llu << PLM_S_MAX) - 1;
	uint32_t max, i, w, err_max = 0;
	uint32_t aerr = 0;
	uint64_t derr = 0;
	uint32_t ab, ae, az, as;
	size_t ret;

	max = 1ul << tpl->in_nb;
	ab = cl_ab < 0 ? 0 : (uint32_t)cl_ab;
	ae = cl_ae < 0 ? max : (uint32_t)cl_ae;
	az = cl_az < 0 ? 0 : (uint32_t)cl_az;
	as = cl_as < 0 ? 0 : (uint32_t)cl_as;

	for (i = 0; i < max; i += FILE_BUF_WORDS) {
		ret = fread(fbuf.w64, sizeof(uint64_t), FILE_BUF_WORDS, f);
		if (ret != FILE_BUF_WORDS) {
			printf("mcode: input file read error (%d)\n", errno);
			fclose(f);
			exit(-1);
		}
		for (w = 0; w < FILE_BUF_WORDS; w++) {
			uint64_t t;
			uint32_t a;

			a = i + w;
			if (a < ab)
				continue;
			if (a >= ae)
				break;
			if (a & az)
				continue;
			if (~a & as)
				continue;
			t = plm_get(tpl, a) & mask;
			if (t != fbuf.w64[w]) {
				derr |= t ^ fbuf.w64[w];
				aerr |= a;
				mc_match_stat_update(a, fbuf.w64[w], t);
				if (err_max++ >= FILE_MAX_ERRORS)
					continue;
				printf("Mismatch: %08" PRIX64
				       " != %08" PRIX64 " @ %08X\n",
				       t, fbuf.w64[w], a);
			}
		}
		if (i >= ae)
			break;
	}
	printf("Match result %s: %08X, %08" PRIX64 "\n", text, aerr, derr);
	if (err_max)
		mc_match_stat_show();
}

/* Read binary file and check against generated matrix */
void mc_mterm_match(enum plm_type type, enum opt_type opt,
		    const char *fname, const char *text)
{
	static struct plm tpl;
	uint64_t start;
	FILE *f = NULL;
	long sz, ms;

	memset(&mc_stat, 0, sizeof(mc_stat));
	printf("Microcode table binary match: %s, %s\n", text, fname);
	f = fopen(fname, "rb");
	if (!f) {
		printf("mcode: input file open error (%s, %d)\n",
			fname, errno);
		exit(-1);
	}
	if (fseek(f, 0, SEEK_END)) {
		printf("mcode: input file end seek error (%d)\n", errno);
		fclose(f);
		exit(-1);
	}
	sz = ftell(f);
	if (sz < 0) {
		printf("mcode: unable to get file size (%d)\n", errno);
		fclose(f);
		exit(-1);
	}
	if (fseek(f, 0, SEEK_SET)) {
		printf("mcode: input file rewind error (%d)\n", errno);
		fclose(f);
		exit(-1);
	}
	start = mc_query_ms();
	if (plm_init(&tpl, type) || plm_opt(&tpl, opt)) {
		fclose(f);
		exit(-1);
	}
	if (type == PLM_TYPE_F11_CS0 &&
	    (plm_init(&tpl_na_clr, PLM_TYPE_F11_NA_CLR0) ||
	     plm_opt(&tpl_na_clr, PLM_OPT_32))) {
		printf("mcode: na_clr PLM initialization failure\n");
		fclose(f);
		exit(-1);
	}
	if (tpl.out_nb <= 32)
		ms = sizeof(uint32_t) * (1ull << tpl.in_nb);
	else if (tpl.out_nb <= 64)
		ms = sizeof(uint64_t) * (1ull << tpl.in_nb);
	else {
		printf("mcode: output word is too large (%s, %u)\n",
			text, tpl.out_nb);
		assert(0);
		fclose(f);
		exit(-1);
	}
	if (sz != ms) {
		printf("mcode: invalid input file size"
		       " (%s, %" PRIu64 ", %" PRIu64 ")\n",
		       fname, (uint64_t)sz, (uint64_t)ms);
		assert(0);
		fclose(f);
		exit(-1);
	}
	if (tpl.out_nb <= 32)
		mc_match_32(f, &tpl, text);
	else if (tpl.out_nb <= 64)
		mc_match_64(f, &tpl, text);
	start = mc_query_ms() - start;
	printf("Elapsed %s: %" PRIu64 ".%03" PRIu64"\n",
		text, start / 1000, start % 1000);
	fclose(f);
}

static void mc_write_32(FILE *f, struct plm *tpl, const char *text)
{
	uint64_t mask = 1llu << PLM_S_MAX;
	uint32_t max, i, w;
	size_t ret;

	max = 1ul << tpl->in_nb;
	for (i = 0; i < max; i += FILE_BUF_WORDS) {
		for (w = 0; w < FILE_BUF_WORDS; w++)
			fbuf.w32[w] = (uint32_t)(plm_get(tpl, i + w) & mask);
		ret = fwrite(fbuf.w32, sizeof(uint32_t), FILE_BUF_WORDS, f);
		if (ret != FILE_BUF_WORDS) {
			printf("mcode: output file write error (%d)\n", errno);
			fclose(f);
			exit(-1);
		}
	}
}

static void mc_write_64(FILE *f, struct plm *tpl, const char *text)
{
	uint64_t mask = 1llu << PLM_S_MAX;
	uint32_t max, i, w;
	size_t ret;

	max = 1ul << tpl->in_nb;
	for (i = 0; i < max; i += FILE_BUF_WORDS) {

		for (w = 0; w < FILE_BUF_WORDS; w++)
			fbuf.w64[w] = plm_get(tpl, i + w) & mask;
		ret = fwrite(fbuf.w64, sizeof(uint64_t), FILE_BUF_WORDS, f);
		if (ret != FILE_BUF_WORDS) {
			printf("mcode: output file write error (%d)\n", errno);
			fclose(f);
			exit(-1);
		}
	}
}

/* Generate the matrix and write to the binary file */
void mc_mterm_write(enum plm_type type, enum opt_type opt,
		    const char *fname, const char *text)
{
	static struct plm tpl;
	uint64_t start;
	FILE *f = NULL;

	printf("Microcode table binary write: %s, %s\n", text, fname);
	f = fopen(fname, "wb");
	if (!f) {
		printf("mcode: output file open error (%s, %d)\n",
		       fname, errno);
		exit(-1);
	}
	start = mc_query_ms();
	if (plm_init(&tpl, type) || plm_opt(&tpl, opt)) {
		printf("mcode: primary PLM initialization failure\n");
		fclose(f);
		exit(-1);
	}
	if (tpl.out_nb <= 32)
		mc_write_32(f, &tpl, text);
	else if (tpl.out_nb <= 64)
		mc_write_64(f, &tpl, text);
	else {
		printf("mcode: output word is too large (%s, %u)\n",
			text, tpl.out_nb);
			assert(0);
		fclose(f);
		exit(-1);
	}
	start = mc_query_ms() - start;
	printf("Elapsed %s: %" PRIu64 ".%03" PRIu64"\n",
		text, start / 1000, start % 1000);
	fclose(f);
}
