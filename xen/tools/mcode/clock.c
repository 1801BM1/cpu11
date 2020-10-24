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

#if defined(_WIN32) || defined(_WIN64)

/* Windows implementation */
static uint64_t	f1000 =	UINT64_MAX;

uint64_t mc_query_ms(void)
{
	LARGE_INTEGER time, freq;

	if (f1000 == UINT64_MAX) {
		if (!QueryPerformanceFrequency(&freq)) {
			printf("mcode: query performance frequency failed\n");
			exit(-1);
		}
		f1000 =	freq.QuadPart /	1000ull;
	}
	if (!QueryPerformanceCounter(&time)) {
		printf("mcode: query performance fcounter failed\n");
		exit(-1);
	}
	return time.QuadPart / f1000;
}
#else

/* Posix/Linux implementation */
#include <time.h>
#include <sys/time.h>

uint64_t mc_query_ms(void)
{
	struct timeval time;

	if (gettimeofday(&time,	NULL)) {
		printf("mcode: get time of the day failed\n");
		exit(-1);
	}
	return time.tv_sec * 1000ull + time.tv_usec / 1000ull;
}
#endif
