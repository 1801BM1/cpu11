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

const struct plm_desc plm_desc_vm1a = {
	.p = {
		NULL, /* 0 */
		NULL, /* 1 */
		"xxxxxxx111xxxxxxxxxxxxxx01xx111", /* 2 */
		"x00xxxxxxx00xxxx100xxxxx01x1010", /* 3 */
		"x00xxxxxxx0x0xxx100xxxxx011101x", /* 4 */
		"xxxxxxxxxxxxx111xxxxxxxx100x111", /* 5 */
		"0xxxx101xxxxxxxxxxxx1x1x000010x", /* 6 */
		"xxxxxx1xxxxxxxxxxxxxx1xx1001x0x", /* 7 */
		"x00xxxxxxxxx0xxx100xxxxx011x011", /* 8 */
		"x000101111xxxxxx001xxxxxx111110", /* 9 */
		"0xxxx1x1xxxxxxxxxxxx000x000010x", /* 10 */
		"xxxxx00111000xxx001xxxxx11111x0", /* 11 */
		"x111xxxxxxxxxxxx0xxxxxxx01x011x", /* 12 */
		"xxxxx1x01xxxxxxx1xxxxxxx011x11x", /* 13 */
		"x00xxxxxxxxxxxxx100xxxxx0110010", /* 14 */
		"xxxxx000xxxxxxxxxxxx1xxx0000100", /* 15 */
		"xxxxxxxxxx000111001xxxxxx111110", /* 16 */
		"1xxxx001xxxxxxxxxxxx0xxx00x010x", /* 17 */
		"x00xxxxxxxx00xxx100xxxxx0111010", /* 18 */
		"xxxxxxxxxxxx0xxxxxx1xxxx1010x0x", /* 19 */
		"0000000001000xxx00xxxxxx11111x0", /* 20 */
		"1xxxxx011xxxxxxxxxxxxxxx0111000", /* 21 */
		"0000100xxx000xxx00xxxxxx11111x0", /* 22 */
		"xxxxxxxx1xx0xxxxxxxxxxxx1001001", /* 23 */
		"10001000xxxxxxxx00xxxxxxx111110", /* 24 */
		"1xxxxxxxxxxxxxxxxxxx0xxx01x1110", /* 25 */
		"1xxxxxxxxxxx011xxx1xxxxx01x1010", /* 26 */
		"xxxxxxxxxxxxxxxx11xxxxxx0110111", /* 27 */
		"1000100xxxxxxxxx001xxxxxx111110", /* 28 */
		"0xxx0111xxxxxxxxxxxx101x00x010x", /* 29 */
		"0xxxx011xxxxxxxxxxxxx0xx00x010x", /* 30 */
		"x001xxxxxx00xxxxxxxxxxxx0111x10", /* 31 */
		"1xxxx011xxxxxxxxxxxxx0x000x010x", /* 32 */
		"x000xxxxxxxx0xxxx01xxxxx0110011", /* 33 */
		"xxxxxxxxxx000xxxxxxxxxxx1111011", /* 34 */
		"x000xx1010xxxxxx1xxxxxxx011x11x", /* 35 */
		"0000000000000101001xxxxx11111x0", /* 36 */
		"0xxxx1x0xxxxxxxxxxxx0x1x00x010x", /* 37 */
		"x001xxxxxx0x0xxxxxxxxxxx0111x10", /* 38 */
		"x100xxxxxxxxxxxx0xxxxxxx01x011x", /* 39 */
		"1xxxx101xxxxxxxxxxxxxx0x00x010x", /* 40 */
		"0xxxx101xxxxxxxxxxxx0x0x000010x", /* 41 */
		"x010xxxxxxxxxxxx0xxxxxxx01x011x", /* 42 */
		"xxxxxxxxxxxxx111xxxxxxxx01xx11x", /* 43 */
		"1xxxx100xxxxxxxxxxxxxx1x00x010x", /* 44 */
		"1xxxx111xxxxxxxxxxxxxxx000x010x", /* 45 */
		"x001xxxxxxx00xxxxxxxxxxx0111x10", /* 46 */
		"1xxxxx10xxxxxxxxxxxxxxx100x010x", /* 47 */
		"0000x1x111xxxxxx1xxx1xxx011x11x", /* 48 */
		"0xxxx1x0xxxxxxxxxxxx1x0x00x010x", /* 49 */
		"xxxxxxxxxxxxxxx1xxxxxxxx000101x", /* 50 */
		"x0000xxx1xxxxxxx111xxxxx0110111", /* 51 */
		"0xxxx110xxxxxxxxxxxxx1xx00x010x", /* 52 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0100110", /* 53 */
		"xxxxxxxxxxxxxxxxxx1xxxxx0110x11", /* 54 */
		"xxxxx010xxxxxxxxxxxxx1xx00x010x", /* 55 */
		"10001101xx000xxx001xxxxxx111110", /* 56 */
		"101xxxxxxxxxxxxxxxxxxxxxx1x011x", /* 57 */
		"x000xxxxxxxxxxxx000xxxxx011x01x", /* 58 */
		"x000xx1101xxxxxx1xxxxxxx011011x", /* 59 */
		"x000x1x0x1xxxxxx1xxxxxxx011011x", /* 60 */
		"x0000xxxxxxxxxxx100xxxxx0110111", /* 61 */
		"0110xxxxxxxxxxxx0xxxxxxx01x011x", /* 62 */
		"x001xxxxxxxx0xxxxxxxxxxx0110011", /* 63 */
		"1x00x1x111xxxxxx1x1xxxxx0110111", /* 64 */
		"x000101xxx000xxx001xxxxx11111x0", /* 65 */
		"xxxxxxxx10xxxxxxxxxxxxxxx101111", /* 66 */
		"xxxxxxxxxxxxxxxx000xxxxx11111x0", /* 67 */
		"x000xxxxxxxxxxxxx01xxxxx011x010", /* 68 */
		"xxxx0xxx0xxxxxx11xxxx1xx10x1001", /* 69 */
		"1000x1x1x0xxxxxx1x1xxxxx0110111", /* 70 */
		"x001xxxxxxxxxxxxxxxxxxxx0110010", /* 71 */
		"xxxxxxx11xxxxxxxxxxxxxxxx101111", /* 72 */
		"xxxxxxxxxxxxx1xxxxxxxxxx0xx0x1x", /* 73 */
		"x0001100xx000xxx001xxxxx11111x0", /* 74 */
		"0111111xxxxxxxxx001xxxxx11111x0", /* 75 */
		"xxxxxxxxxxxxxxxx0xxxxxxx1110101", /* 76 */
		"x00xxxxxxxxxxxxx0xxxxxxx0110111", /* 77 */
		"xxxxxxxxxxxxxx1xxxxxxxxx0000x1x", /* 78 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1110000", /* 79 */
		"xxxx0xxx10xxxxxxxxxxxxxx1001000", /* 80 */
		"xxxxxxxxxxxxxxx1xxxxxxxx0x01110", /* 81 */
		"000000001x000xxx001xxxxxx111110", /* 82 */
		"xxxx000xxxxxxxxxxxxxxxxx0111000", /* 83 */
		"0xxxxxxxxxxxxxxxxxxxxxxx01x1110", /* 84 */
		"xxxxxxxxxxxxx1xxxxxxxxxx0x1xx1x", /* 85 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1100110", /* 86 */
		"xxxxxxxxxxxxxx1xxxxxxxxx0x01110", /* 87 */
		"1xxxxxxxxxxxxxxxxxxxxxxx1001x00", /* 88 */
		"xxxxxxxxxxxxxxx1xxxxxxxx001xx1x", /* 89 */
		"xxxxxxxxxxxxx1xxxxxxxxxx000101x", /* 90 */
		"0000000000000000001xxxxxx111110", /* 91 */
		"xxxxxxxx1xxxxxxxxxxxxxxxxx1100x", /* 92 */
		"xxxxxxxxxxxxx1xxxxxxxxxx0001110", /* 93 */
		"xxxxxxxxxxxx1xxxxxxxxxxx0010101", /* 94 */
		"xxxxxxx1xxxxxxxxxxxxxxxxx1001x1", /* 95 */
		"xxxxxxxx0xxxxxxxxxxxxxxxx101111", /* 96 */
		"x10xxxxxxxxxxxxxxxxxxxxx011001x", /* 97 */
		"xxxxxxxxxxxxxx1xxxxxxxxx000101x", /* 98 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1100011", /* 99 */
		"xxxxxxxxxx1xxxxxxxxxxxxxx101010", /* 100 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1000010", /* 101 */
		"xxxxxxx1xxxxxxxxxxxxxxxxxx1100x", /* 102 */
		"x000xx1000xxxxxx1xxxxxxx011011x", /* 103 */
		"xxxxxxxxxxxxxxxxx0xxxxxx1101x11", /* 104 */
		"xxxxxxxxxx101xxxxxxxxxxx0111x10", /* 105 */
		"xxxxxxxxx1xxxxxxxxxxxxxxxx1100x", /* 106 */
		"0000110111000xxx001xxxxxx111110", /* 107 */
		"xxxxxxxxxxxxxxxxxx1xxxxx1101000", /* 108 */
		"xxxxxxxxxxxxxxxx1xxxxxxx1110101", /* 109 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0000x01", /* 110 */
		"x01xxxxxxxxxxxxxxxxxxxxx010011x", /* 111 */
		"xxxxxxx1xxxxxxxxxxxxxxxxx01010x", /* 112 */
		"xxxxxxxx1xxxxxxxxxxxxxxxx1001x1", /* 113 */
		"x000x1x1x1xxxxxxxxxxxxxx011011x", /* 114 */
		"xxxxxxxxxxxxxxx1xxxxxxxx0x00x1x", /* 115 */
		"xx00xxxxxxxxxxxxx1xxxxxx011001x", /* 116 */
		"0xxxxxxxxxxxxxxxxxxxxxxx01xx0xx", /* 117 */
		"0111100xxx000xxx001xxxxxx111110", /* 118 */
		"xxxxxxxxxxxxxxxxxxxxxxxx11x1111", /* 119 */
		"xxxxxxxxxxxxxx1xxxxxxxxx010xx1x", /* 120 */
		"xxxxxxxxxxxxxxxxxxxxxxxx100111x", /* 121 */
		"xxxx0xxxxx0xxxx0xxx0xxxx10x1001", /* 122 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1010011", /* 123 */
		"xxxxxxxxxxxxxxxx10xxxxxxx111110", /* 124 */
		"1000000xxxxxxxxx001xxxxxx111110", /* 125 */
		"xxxxxxxxxxxx1xxxxxxxxxxx1010000", /* 126 */
		"xxxxxxxxxx011xxxxxxxxxxx0111x10", /* 127 */
		"x000xxxxxxxxxxxxx1xxxxxx0111x10", /* 128 */
		"xxxx101xxxxxxxxxxxxxxxxx0111000", /* 129 */
		"00000001xxxxxxxx001xxxxxx111110", /* 130 */
		"xxxxxxxxxx11xxxxxxxxxxxx0111x10", /* 131 */
		"xxxxxxxxxxxxxxxxxxxxxxxxx100101", /* 132 */
		"xxxx0xxx0xxxx0x1xxxxxxxx1001x00", /* 133 */
		"x000x00xxxxxxxxx1xxxxxxx0110111", /* 134 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1101010", /* 135 */
		"0001xxxxxxxxxxxxxxxxxxxx010011x", /* 136 */
		"xxxxxxxxxxxxxxxx01xxxxxxx111110", /* 137 */
		"xxxxxxxxx1xxxxxxxxxxxxxxx101111", /* 138 */
		"0000000000001xxx001xxxxxx111110", /* 139 */
		"x000xx1111xxxxxx1xxxxxxx011011x", /* 140 */
		"xxxx0xxx0xxxxxx10xxxx1xx10x1001", /* 141 */
		"xxxxxxxxx1xxxxxxxxxxxxxxx1001x1", /* 142 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1100001", /* 143 */
		"x000x1x0xxxxxxxx1xxxxxxx011011x", /* 144 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1000110", /* 145 */
		"x000xx1001xxxxxx1xxxxxxx011011x", /* 146 */
		"1xxxxxxxxxxxxxxxxxxxxxxx01x1110", /* 147 */
		"xxxxxxxxxxxx1xxxxxxxxxxx0110011", /* 148 */
		"xxxxxxxxxxxxxxxxx1xxxxxx1101x11", /* 149 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1100010", /* 150 */
		"xx1xxxxxxxxxxxxxxxxxxxxx011001x", /* 151 */
		"x01x000xxx000xxx001xxxxxx111110", /* 152 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1010010", /* 153 */
		"xxxxxxxxxxxx0xxxxxxxxxxx00x0101", /* 154 */
		"xxxx011xxxxxxxxxxxxxxxxx0111000", /* 155 */
		"xxxx11xxxxxxxxxxxxxxxxxx0111000", /* 156 */
		"xxxx10xxxxxxxxxxxxxxxxxx100100x", /* 157 */
		"xxxxxxxxxxxxxxxxxxxxxxxx111x100", /* 158 */
		"xxxxxxxxxxxxxxxxxxxxxxxx011111x", /* 159 */
		"xxxxxxxxxxxxx0xxxxxxxxxx1010101", /* 160 */
		"x10xxxxxxxxxxxxxxxxxxxxx0111x10", /* 161 */
		"xxxxxxx0xxxxxxxxxxxxxxxx0010100", /* 162 */
		"xxxxxxxxxxxxxxx1xxxxxxxx01xxx1x", /* 163 */
		"xxxxxxxxxxx1xxxxxxxxxxxxx101010", /* 164 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1100000", /* 165 */
		"xx11xxxxxxxxxxxxxxxxxxxx01x011x", /* 166 */
		"x000xx1110xxxxxx1xxxxxxx011011x", /* 167 */
		"x10xxxxxxxxxxxxx0xxxxxxx01x011x", /* 168 */
		"100xxxxxxxxxxxxxxxxxxxxx010011x", /* 169 */
		"1x0xxxxxxxxxxxxxxxxxxxxxx1x011x", /* 170 */
		"x000xx101xxxxxxx1xxxxxxx011011x", /* 171 */
		"xx10xxxxxxxxxxxxxxxxxxxx01x011x", /* 172 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1000x11", /* 173 */
		"xx01000xxx000xxx001xxxxxx111110", /* 174 */
		"xxxxxxxxxxxxxxxx11xxxxxxx111110", /* 175 */
		"xxxxxxxxxxxxx1xxxxxxxxxx01xxx1x", /* 176 */
		"xxxxxxxxxxxxxxxxxxxxxxxx11x1100", /* 177 */
		"xxxxxx1xxxxxxxxxxxxxxxxx101xx00", /* 178 */
		"x000xx110xxxxxxx1xxxxxxx011011x", /* 179 */
		"xx1xxxxxxxxxxxxxxxxxxxxx0111x10", /* 180 */
		"x1x0000xxx000xxx001xxxxx11111x0", /* 181 */
		"xxxxxxxxxxxxxxxxxxxxxxxx110111x", /* 182 */
		"xxxxxxxxxxxxxxxx0xxxxxxx0110x11", /* 183 */
		"xxxxxx1xxxxxxxxxxxxxxxxx0111x01", /* 184 */
		"xxxxxxxxxxxxxxxxxx0xxxxx1101000", /* 185 */
		"xxxxxxxxxxxxxxxxxxxxxxxx10111x0", /* 186 */
		"xxxxxxxxxxxxxxxxx0xxxxxx011x01x", /* 187 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1011111", /* 188 */
		"x000010xxxxxxxxx001xxxxxx111110", /* 189 */
		"xxxxxxxx1xxxxxxxxxxxxxxx10x100x", /* 190 */
		"0000110100xxxxxx001xxxxxx111110", /* 191 */
		"0xxx000011000xxx001xxxxxx111110", /* 192 */
		"0000000000000011001xxxxxx111110", /* 193 */
		"0000000000000100001xxxxxx111110", /* 194 */
		"xxxxxxx1xxxxxxxxxxxxxxxx10x100x", /* 195 */
		"00000000101xxxxx001xxxxxx111110", /* 196 */
		"x0000x1xxxxxxxxx001xxxxxx111110", /* 197 */
		"xxxxxxxxxxxxxx1xxxxxxxxx0x1xx1x", /* 198 */
		"xxxx0xxxx00xx0x0xxx1xxxx100100x", /* 199 */
		"0000000000000x10001xxxxxx111110", /* 200 */
		"0000000000000001001xxxxxx111110", /* 201 */
		"xxxx0xxxx00xx1x1xxxxxxxx1001000", /* 202 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0110001", /* 203 */
		"0xxxx10xxxxxxxxxxxxxxxxx1001x00", /* 204 */
		"0000000001xxxxxx001xxxxxx111110", /* 205 */
		"xxxxxxxxxxxxxxxxxxxxxxxx101x100", /* 206 */
		"xxxx001xxxxxxxxxxxxxxxxx0111000", /* 207 */
		"xxxx0xxx0xxxxxx0xxx0xxxx1001x00", /* 208 */
		"xxxx0xxx00xxx1x1xxxxx0xx1001x01", /* 209 */
		"1000110100xxxxxx001xxxxxx111110", /* 210 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1010001", /* 211 */
		"xxxxxxxxxxxxxxxxxxxxxxxx101110x", /* 212 */
		"1xxxxxxxxxxxxxxxxxxxxxxx10x1001", /* 213 */
		"xxxxxxxxxxxxx1xxxxxxxxxx1010101", /* 214 */
		"xxxx0xxx11xxxxxxxxxxxxxx1001x0x", /* 215 */
		"xxxx0xxxx00xx1x0xxx1xxxx1001000", /* 216 */
		"0xxxx1xxxxxxxxxxxxxxxxxx10x1001", /* 217 */
		"xxxxxxx00xxxx1x0xxx1xxxx1001001", /* 218 */
		"xxxx0xxxxx1xxxxxxxxxxxxx10x1001", /* 219 */
		"xxxxxxxxxxxxxxxxxxxxxxxx100110x", /* 220 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0110010", /* 221 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1111011", /* 222 */
		"xxxxxxxxxxxxxxxxxx0xxxxx01xx0xx", /* 223 */
		"x000100xxxxxxxxx001xxxxx11111x0", /* 224 */
		"xxxxxxxxxxxx0xxxxxxxxxxx1010x0x", /* 225 */
		"xxxxxx0xxxxxxxxxxxxxxxxx0111x01", /* 226 */
		"xxxxxxxxxx001xxxxxxxxxxx0111010", /* 227 */
		"xxxxxx1xxxxxxxxxxxxxxxxx1001x0x", /* 228 */
		"x0001100xxxxxxxx001xxxxx11111x0", /* 229 */
		"xxxx100xxxxxxxxxxxxxxxxx0111000", /* 230 */
		"xxxxxx0xxxxxxxxxxxxxxxxx1011x00", /* 231 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1x01111", /* 232 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1x0x1x1", /* 233 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0110111", /* 234 */
		"0000000011xxxxxx001xxxxx11111x0", /* 235 */
		"xxxx010xxxxxxxxxxxxxxxxx0111000", /* 236 */
		"xxxxxxxxxxxx0xxxxxxxxxxx0110011", /* 237 */
		"xxxxxxxxxxxxxxxxxxxxxxxx01xx11x", /* 238 */
		"xxxxxxxxxx100xxxxxxxxxxx0111x10", /* 239 */
		"xxxxxxxxxx010xxxxxxxxxxx0111x10", /* 240 */
		"x10xxxxxxxxxxxxx001xxxxx11111x0", /* 241 */
		"x000110111xxxxxx001xxxxx11111x0", /* 242 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0000100", /* 243 */
		"x000101xxxxxxxxx001xxxxx11111x0", /* 244 */
		"0111100xxxxxxxxx001xxxxx11111x0", /* 245 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1011001", /* 246 */
		"x1x0xxxxxxxxxxxx001xxxxx11111x0", /* 247 */
		"x01xxxxxxxxxxxxx001xxxxxx111110", /* 248 */
		"xx01xxxxxxxxxxxx001xxxxxx111110"  /* 249 */
	},
	.s = {
		(const int16_t[]) { /* 0 */
			246, 243, 236, 234, 231, 230, 228, 226, 225, 220,
			219, 217, 215, 213, 212, 211, 209, 208, 207, 206,
			204, 203, 202, 201, 200, 199, 196, 195, 194, 193,
			191, 190, 188, 186, 185, 182, 179, 178, 177, 175,
			173, 172, 171, 168, 167, 166, 165, 162, 160, 159,
			158, 157, 154, 153, 150, 149, 147, 146, 144, 143,
			141, 140, 139, 137, 136, 133, 126, 124, 123, 122,
			119, 114, 112, 109, 108, 107, 104, 103, 101, 99,
			96,  94,  91,  86,  84,  79,  76,  75,  74,  69,
			67,  66,  65,  36,  34,  28,  22,  20,  -1
		},
		(const int16_t[]) { /* 1 */
			249, 248, 247, 246, 245, 244, 243, 242, 241, 240,
			239, 237, 236, 235, 234, 232, 231, 230, 229, 228,
			227, 226, 225, 224, 222, 221, 220, 218, 217, 216,
			215, 214, 213, 212, 211, 210, 209, 207, 206, 205,
			204, 203, 202, 201, 200, 199, 197, 196, 195, 194,
			193, 191, 189, 188, 186, 185, 184, 178, 177, 175,
			173, 169, 165, 164, 162, 160, 159, 158, 157, 156,
			155, 153, 150, 149, 148, 145, 143, 141, 139, 138,
			137, 135, 133, 132, 131, 130, 129, 127, 126, 125,
			124, 123, 122, 121, 112, 110, 109, 108, 105, 104,
			101, 100, 99,  96,  91,  86,  83,  82,  80,  79,
			76,  75,  69,  66,  43,  36,  2,   -1
		},
		(const int16_t[]) { /* 2 */
			232, 218, 216, 196, 192, 181, 174, 154, 152, 119,
			118, 110, 107, 94,  74,  67,  65,  56,  -1,  -1
		},
		(const int16_t[]) { /* 3 */
			236, 230, 226, 208, 207, 206, 203, 200, 184, 182,
			180, 175, 161, 158, 156, 155, 154, 153, 151, 148,
			145, 137, 135, 131, 129, 128, 127, 126, 116, 105,
			101, 97,  94,  68,  58,  33,  -1
		},
		(const int16_t[]) { /* 4 */
			225, 215, 209, 202, 179, 178, 172, 169, 167, 146,
			144, 140, 103, 84,  72,  -1
		},
		(const int16_t[]) { /* 5 */
			246, 231, 225, 218, 217, 216, 214, 212, 211, 209,
			206, 204, 202, 201, 200, 197, 196, 191, 189, 186,
			178, 175, 173, 162, 158, 157, 153, 145, 141, 139,
			134, 130, 126, 125, 123, 110, 107, 96,  88,  80,
			75,  74,  70,  66,  65,  36,  34,  -1
		},
		(const int16_t[]) { /* 6 */
			249, 248, 247, 246, 245, 244, 243, 242, 241, 238,
			235, 232, 231, 229, 228, 225, 224, 223, 222, 220,
			219, 218, 217, 216, 215, 214, 213, 212, 211, 210,
			209, 208, 206, 205, 204, 202, 201, 200, 199, 197,
			196, 195, 194, 193, 191, 190, 189, 188, 186, 185,
			184, 182, 178, 177, 175, 173, 165, 164, 162, 160,
			158, 157, 156, 155, 154, 153, 150, 149, 148, 145,
			143, 141, 139, 137, 135, 133, 132, 131, 130, 129,
			127, 126, 125, 124, 123, 122, 121, 119, 117, 112,
			110, 109, 108, 105, 104, 101, 100, 99,  94,  91,
			86,  83,  82,  79,  76,  75,  69,  67,  36,  -1
		},
		(const int16_t[]) { /* 7 */
			246, 243, 238, 236, 232, 231, 230, 228, 226, 225,
			222, 220, 219, 218, 217, 216, 215, 214, 213, 212,
			211, 209, 208, 207, 204, 203, 202, 201, 200, 196,
			192, 191, 188, 187, 186, 185, 184, 182, 181, 178,
			177, 175, 174, 173, 165, 164, 162, 160, 158, 156,
			155, 154, 153, 152, 150, 148, 145, 143, 139, 135,
			133, 132, 131, 129, 127, 126, 123, 118, 112, 110,
			109, 108, 107, 105, 101, 100, 88,  86,  83,  80,
			74,  65,  56,  -1
		},
		(const int16_t[]) { /* 8 */
			246, 243, 238, 231, 228, 225, 222, 220, 219, 217,
			215, 214, 213, 212, 211, 209, 204, 202, 201, 195,
			191, 190, 188, 186, 185, 178, 177, 173, 165, 164,
			162, 160, 157, 154, 150, 149, 143, 139, 132, 124,
			123, 112, 109, 108, 104, 100, 99,  86,  83,  71,
			63,  46,  38,  31,  18,  14,  8,   4,   3,   -1
		},
		(const int16_t[]) { /* 9 */
			246, 245, 243, 240, 239, 234, 232, 228, 225, 220,
			217, 215, 214, 213, 209, 204, 202, 201, 200, 197,
			196, 192, 191, 189, 188, 185, 181, 178, 177, 174,
			173, 169, 160, 159, 158, 152, 150, 149, 141, 138,
			137, 130, 125, 124, 112, 108, 107, 104, 101, 99,
			96,  88,  86,  83,  82,  80,  79,  76,  74,  69,
			66,  65,  56,  43,  36,  34,  2,   -1
		},
		(const int16_t[]) { /* 10 */
			237, 234, 226, 225, 222, 221, 214, 211, 203, 186,
			184, 173, 165, 162, 160, 159, 158, 150, 148, 123,
			112, 36, -1
		},
		(const int16_t[]) { /* 11 */
			246, 240, 237, 236, 232, 227, 226, 222, 221, 220,
			219, 218, 217, 216, 215, 213, 212, 211, 208, 207,
			204, 203, 200, 196, 192, 184, 183, 182, 181, 177,
			174, 173, 172, 169, 168, 166, 165, 162, 159, 158,
			156, 155, 154, 152, 148, 145, 144, 138, 136, 135,
			134, 132, 131, 127, 123, 118, 112, 110, 108, 107,
			100, 94,  86,  83,  74,  65,  64,  56,  -1
		},
		(const int16_t[]) { /* 12 */
			249, 248, 247, 246, 245, 244, 243, 242, 241, 240,
			239, 238, 237, 236, 235, 232, 231, 230, 229, 228,
			227, 226, 225, 224, 222, 221, 220, 219, 218, 217,
			216, 215, 214, 213, 212, 211, 210, 209, 208, 207,
			206, 205, 204, 203, 202, 201, 200, 199, 197, 196,
			195, 194, 193, 191, 190, 189, 188, 186, 185, 184,
			182, 178, 177, 175, 173, 165, 164, 162, 160, 158,
			157, 156, 155, 154, 153, 150, 149, 148, 145, 143,
			141, 139, 137, 135, 133, 132, 131, 130, 129, 127,
			126, 125, 124, 123, 122, 121, 119, 112, 110, 109,
			108, 105, 104, 101, 100, 99,  94,  91,  86,  83,
			82,  79,  76,  75,  69,  67,  36,  -1
		},
		(const int16_t[]) { /* 13 */
			246, 243, 239, 237, 231, 230, 228, 226, 225, 222,
			221, 220, 219, 217, 214, 213, 212, 211, 209, 206,
			204, 203, 202, 201, 195, 191, 188, 186, 185, 184,
			183, 179, 178, 175, 173, 172, 171, 169, 168, 167,
			166, 165, 164, 162, 160, 159, 158, 157, 153, 150,
			149, 148, 147, 146, 143, 140, 139, 137, 136, 132,
			129, 126, 124, 123, 114, 112, 109, 105, 104, 103,
			101, 99,  96,  94,  84,  80,  72,  70,  66,  -1
		},
		(const int16_t[]) { /* 14 */
			246, 244, 243, 242, 240, 239, 237, 236, 235, 232,
			230, 229, 228, 227, 226, 224, 222, 221, 220, 218,
			217, 216, 212, 211, 210, 209, 208, 207, 206, 205,
			204, 203, 202, 201, 200, 199, 196, 194, 193, 191,
			188, 185, 184, 182, 181, 179, 178, 177, 175, 174,
			173, 172, 171, 169, 167, 165, 164, 162, 159, 158,
			157, 156, 155, 154, 153, 152, 149, 148, 145, 143,
			141, 139, 137, 136, 135, 132, 131, 129, 127, 126,
			124, 123, 122, 121, 118, 114, 112, 110, 108, 105,
			104, 103, 101, 100, 99,  94,  83,  80,  77,  72, -1
		},
		(const int16_t[]) { /* 15 */
			245, 237, 232, 227, 221, 218, 217, 216, 214, 211,
			206, 200, 197, 189, 185, 184, 181, 174, 173, 165,
			164, 162, 158, 155, 153, 152, 150, 148, 145, 143,
			139, 137, 131, 130, 129, 127, 126, 125, 123, 121,
			110, 109, 108, 105, 101, 100, 83,  77,  -1
		},
		(const int16_t[]) { /* 16 */
			248, 246, 243, 240, 237, 236, 232, 227, 226, 225,
			224, 222, 221, 220, 219, 218, 217, 216, 215, 214,
			213, 212, 211, 210, 208, 207, 206, 205, 204, 203,
			202, 201, 200, 199, 196, 194, 193, 192, 191, 188,
			184, 182, 181, 177, 175, 174, 173, 169, 168, 165,
			162, 160, 159, 158, 156, 155, 154, 153, 150, 148,
			147, 145, 144, 143, 139, 138, 137, 136, 135, 134,
			133, 132, 131, 127, 123, 122, 121, 118, 114, 112,
			110, 109, 108, 107, 103, 101, 100, 99,  96,  94,
			86,  84,  83,  80,  77,  74,  70,  65,  62,  59,
			56,  35,  9,   -1
		},
		(const int16_t[]) { /* 17 */
			249, 248, 245, 244, 243, 242, 241, 240, 237, 236,
			235, 232, 229, 226, 225, 218, 216, 214, 210, 208,
			201, 200, 199, 196, 194, 193, 191, 184, 182, 181,
			179, 160, 156, 155, 153, 148, 146, 145, 135, 131,
			127, 122, 121, 110, 109, 101, 96,  91,  84,  82,
			75,  70,  62,  42,  39,  35,  28,  25,  23,  22,
			20,  12,  -1
		},
		(const int16_t[]) { /* 18 */
			215, 213, 205, 199, 194, 193, 170, 122, 96,  88,
			84,  72,  57,  24,  22,  -1
		},
		(const int16_t[]) { /* 19 */
			246, 245, 243, 237, 233, 228, 227, 221, 219, 218,
			217, 216, 215, 214, 213, 212, 208, 206, 200, 199,
			197, 194, 193, 192, 189, 188, 186, 182, 181, 179,
			175, 174, 172, 171, 169, 168, 167, 166, 165, 164,
			160, 159, 154, 152, 147, 146, 145, 144, 143, 140,
			138, 136, 135, 133, 130, 125, 124, 123, 122, 121,
			119, 114, 112, 110, 107, 103, 100, 99,  94,  91,
			86,  84,  83,  82,  79,  77,  76,  74,  69,  67,
			66,  65,  61,  56,  34,  28,  22,  20,  -1
		},
		(const int16_t[]) { /* 20 */
			237, 227, 226, 224, 221, 215, 214, 210, 207, 206,
			205, 203, 202, 191, 186, 184, 183, 175, 164, 160,
			158, 154, 153, 150, 149, 148, 143, 139, 137, 126,
			111, 101, 100, 99,  96,  94,  84,  83,  80,  66,
			55,  52,  49,  47,  45,  44,  41,  40,  37,  32,
			30,  29,  17,  16,  15,  11,  10,  7,   6,   5, -1
		},
		(const int16_t[]) { /* 21 */
			225, 209, 202, 199, 193, 178, 169, 122, 91,  72,
			24, -1
		},
		(const int16_t[]) { /* 22 */
			225, 209, 202, 199, 194, 193, 178, 171, 169, 168,
			166, 147, 136, 122, 114, 91,  86,  72,  -1
		},
		(const int16_t[]) { /* 23 */
			236, 232, 231, 230, 226, 218, 216, 214, 208, 207,
			206, 203, 200, 196, 192, 191, 185, 184, 183, 182,
			181, 180, 177, 175, 174, 161, 160, 158, 157, 156,
			155, 153, 152, 151, 150, 149, 148, 145, 143, 141,
			137, 135, 131, 129, 128, 127, 126, 124, 118, 116,
			110, 108, 107, 105, 104, 101, 99,  97,  96,  86,
			74,  71,  70,  69,  68,  65,  64,  63,  58,  56,
			54,  46,  38,  31,  27,  -1
		},
		(const int16_t[]) { /* 24 */
			244, 243, 242, 240, 239, 237, 236, 235, 232, 230,
			229, 228, 227, 226, 224, 222, 221, 220, 219, 217,
			215, 213, 212, 211, 210, 208, 207, 205, 203, 200,
			199, 194, 193, 188, 183, 182, 181, 179, 177, 175,
			174, 173, 172, 171, 169, 168, 167, 166, 164, 160,
			159, 158, 154, 153, 152, 150, 148, 147, 146, 144,
			140, 138, 137, 136, 135, 133, 132, 131, 127, 122,
			121, 119, 118, 114, 112, 105, 103, 100, 94,  91,
			86,  84,  82,  79,  76,  69,  67,  -1
		},
		(const int16_t[]) { /* 25 */
			243, 237, 231, 228, 226, 222, 221, 220, 219, 214,
			213, 212, 211, 204, 203, 191, 184, 183, 175, 173,
			167, 165, 162, 160, 159, 158, 150, 148, 146, 144,
			143, 140, 139, 123, 112, 99,  94,  80,  72,  66,
			64,  59,  53,  48,  -1
		},
		(const int16_t[]) { /* 26 */
			246, 243, 237, 228, 226, 225, 222, 221, 220, 219,
			217, 213, 212, 211, 206, 204, 203, 202, 191, 188,
			186, 184, 173, 167, 165, 162, 159, 158, 148, 147,
			137, 123, 112, 109, 95,  94,  84,  80,  72,  64,
			59,  13,  -1
		},
		(const int16_t[]) { /* 27 */
			246, 243, 237, 232, 226, 223, 222, 221, 218, 216,
			213, 211, 209, 208, 203, 202, 201, 200, 196, 192,
			188, 185, 184, 183, 182, 181, 175, 174, 173, 165,
			162, 159, 158, 157, 156, 155, 153, 152, 149, 148,
			145, 143, 139, 138, 135, 131, 129, 127, 126, 124,
			123, 118, 117, 113, 112, 110, 107, 105, 104, 101,
			99,  96,  88,  80,  79,  76,  74,  70,  65,  64,
			60,  56,  53,  51,  26,  21,  -1
		},
		(const int16_t[]) { /* 28 */
			246, 240, 239, 237, 236, 232, 231, 230, 228, 226,
			222, 221, 218, 217, 216, 213, 211, 209, 208, 206,
			203, 202, 201, 200, 196, 192, 191, 188, 185, 184,
			183, 182, 181, 178, 175, 174, 173, 171, 165, 164,
			162, 159, 158, 157, 156, 155, 153, 152, 149, 148,
			146, 145, 143, 142, 140, 137, 135, 131, 129, 127,
			126, 124, 123, 118, 112, 110, 107, 105, 104, 101,
			80,  74,  66,  65,  56,  53,  48,  -1
		},
		(const int16_t[]) { /* 29 */
			246, 245, 237, 236, 231, 230, 227, 226, 221, 218,
			216, 214, 212, 209, 207, 206, 204, 203, 202, 200,
			192, 186, 185, 184, 181, 177, 174, 165, 164, 158,
			156, 155, 153, 152, 150, 135, 131, 129, 126, 110,
			108, 100, 88,  83,  82,  80,  61,  56,  34,  19, -1
		},
		(const int16_t[]) { /* 30 */
			234, 225, 222, 219, 215, 214, 213, 209, 188, 186,
			177, 165, 162, 160, 154, 153, 150, 149, 132, 126,
			123, 109, 101, 88,  86,  -1
		},
		(const int16_t[]) { /* 31 */
			249, 248, 247, 245, 244, 243, 242, 235, 234, 232,
			229, 228, 225, 220, 219, 218, 217, 216, 215, 214,
			213, 212, 211, 210, 209, 208, 204, 201, 200, 196,
			195, 191, 188, 186, 185, 182, 177, 176, 173, 165,
			162, 160, 157, 156, 154, 153, 150, 149, 145, 135,
			131, 126, 124, 123, 112, 110, 109, 108, 104, 102,
			101, 93,  90,  86,  85,  73,  -1
		},
		(const int16_t[]) { /* 32 */
			249, 248, 247, 245, 244, 243, 242, 235, 234, 232,
			229, 228, 225, 222, 220, 219, 218, 217, 216, 215,
			214, 213, 212, 211, 210, 208, 204, 201, 200, 198,
			196, 191, 190, 188, 186, 185, 182, 177, 173, 165,
			162, 160, 157, 156, 150, 145, 135, 132, 131, 124,
			123, 120, 110, 109, 108, 104, 98,  92,  88,  87,
			86,  78,  -1
		},
		(const int16_t[]) { /* 33 */
			249, 248, 247, 245, 244, 243, 242, 235, 234, 232,
			229, 228, 222, 220, 218, 217, 216, 215, 214, 212,
			211, 210, 208, 201, 196, 191, 186, 185, 182, 173,
			163, 160, 156, 150, 132, 131, 115, 112, 110, 108,
			106, 89, 86, 81, 50, -1
		}
	},
	.xin = 0x7F,
	.xout = ((1ull << 0 | 1ull << 5 | 1ull << 9 | 1ull << 15 |
		  1ull << 19 | 1ull << 24 | 1ull << 29) ^ 0x3FFFFFFFFull) |
		  1ull << (0 + PLM_S_MAX) | 1ull << (1 + PLM_S_MAX) |
		  1ull << (2 + PLM_S_MAX) | 1ull << (6 + PLM_S_MAX),
	.in_nb = 31,
	.out_nb = 34,
	.na_nb = 7,
	.na_bits = { 29, 24, 19, 15, 9, 5, 0 }
};

const struct plm_desc plm_desc_vm1g = {
	.p = {
		NULL, /* 0 */
		"xxx1000xxx000xxx0x1xxxxxx11x110", /* 1 */
		"xxxxx00111000xxx0x1xxxxxxx11110", /* 2 */
		"1000x000xxxxxxxx001xxxxxxx11110", /* 3 */
		"xxxxxxxxxxxxx111xxxxxxxx111101x", /* 4 */
		"0xxxx110xxxxxxxxxxxx100x100x110", /* 5 */
		"xxxxxxxxxx000111001xxxxx111x110", /* 6 */
		"0xx0x101xxxxxxxxxxxx1x1x1x0011x", /* 7 */
		"xxxxxxx111xxxxxxxxxxxxxxx100x11", /* 8 */
		"x100xxxxxxxxxxxx1xxxxxxx01x011x", /* 9 */
		"xxxxx000xxxxxxxxxxxx1xxx1000110", /* 10 */
		"1xxxxx011xxxxxxxxx1xxxxxxx11000", /* 11 */
		"0xxxx111xxxxxxxxxxxx000x100x110", /* 12 */
		"0000000001000xxx001xxxxxxx11110", /* 13 */
		"xxxxx1xxxxxxxxxxxxxxx1xx1011xxx", /* 14 */
		"xxxxxxxxxx000xxxxxxxxxxx11x00x1", /* 15 */
		"x000101111xxxxxx001xxxxxxx11110", /* 16 */
		"0000100xxx000xxx001xxxxxxx11110", /* 17 */
		"xxxxxxxxxx10xxxxxxxxxxxxxx11011", /* 18 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1x110x1", /* 19 */
		"x010xxxxxxxxxxxx1xxxxxxx01x011x", /* 20 */
		"1000100xxxxxxxxx0x1xxxxx1xx1110", /* 21 */
		"xxxxxx1010xxxxxx0xxxxxxx011x11x", /* 22 */
		"1xx0x001xxxxxxxxxxxx0xxx1x0011x", /* 23 */
		"0xxxx111xxxxxxxxxxxx101x100x110", /* 24 */
		"1xxxxxxxxxxxxxxxxxxxxxxx110011x", /* 25 */
		"xxxxxxxxxxxxx11xxxxxxxxxx1x101x", /* 26 */
		"0xxxx011xxxxxxxxxxxxx0xx100x110", /* 27 */
		"1xxxx011xxxxxxxxxxxxx0x0100011x", /* 28 */
		"1xxxx101xxxxxxxxxxxxxx0x100x110", /* 29 */
		"1xxxx111xxxxxxxxxxxxxxx0100011x", /* 30 */
		"xxxxxxxxxxxxx1xxxxxxxxxx1x00111", /* 31 */
		"0xxxx101xxxxxxxxxxxx0x0x100011x", /* 32 */
		"xxxxxxxxxxxxx111xxxxxxxx01xx11x", /* 33 */
		"0110xxxxxxxxxxxx1xxxxxxx01x011x", /* 34 */
		"0xxxx1x0xxxxxxxxxxxx0x1x100011x", /* 35 */
		"1xxxx100xxxxxxxxxxxxxx1x100011x", /* 36 */
		"0000000000000101001xxxxxxx11110", /* 37 */
		"1xxxxxxxxxxxxxxxxxxx0xxx0xx1110", /* 38 */
		"xxxxxxxxxxxxxxxxxxxx00xx0000x00", /* 39 */
		"0xxxx1x111xxxxxx0xxx1xxx011x11x", /* 40 */
		"xxxxxxxxxxxxxxxxxxxx0xxx0x00010", /* 41 */
		"xxxxxxxxxxxxxxxxxxxxxxxx11x000x", /* 42 */
		"1xxxxx10xxxxxxxxxxxxxxx1100x110", /* 43 */
		"xxxxxxx0xxxxxxxxxxx0xxxx1010101", /* 44 */
		"0111111xxxxxxxxx001xxxxxxx11110", /* 45 */
		"xxxxxxx1xxxxxxxxxxxxxxxx0x001x1", /* 46 */
		"xxxx000xxxxxxxxxxxxxxxxx011x000", /* 47 */
		"xxxxxxxxxxxxxxxxxxxxxx0x00x0100", /* 48 */
		"0xx0xx00xxxxxxxxxxxx1x0x1x00110", /* 49 */
		"0xxxx110xxxxxxxxxxxxx1xx100011x", /* 50 */
		"xxxxx1x01xxxxxxx0xxxxxxx011x11x", /* 51 */
		"xxxxx010xxxxxxxxxxxxx1xx100011x", /* 52 */
		"000000001x000xxx001xxxxx111x110", /* 53 */
		"x000100xxxxxxxxx001xxxxxxx11110", /* 54 */
		"xxxxxx1101xxxxxx0xxxxxxx011x11x", /* 55 */
		"xxxxx1x0x1xxxxxx0xxxxxxx011x11x", /* 56 */
		"1xxxxxxxxxxxxxxxxx1xxxxx01x011x", /* 57 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0100x10", /* 58 */
		"xxxxxxxxxx101xxxxxxxxxxx01xx010", /* 59 */
		"x000101xxx000xxx001xxxxx111x110", /* 60 */
		"xxxxxxxxxxxxxxxxxxxx1xxx0001001", /* 61 */
		"xxxxxxxx1xxxxxxxxxxxxxxx0x001x1", /* 62 */
		"xxxxxxxxxx0xxxxxxxxxxxxxx111101", /* 63 */
		"0000010xxxxxxxxx001xxxxx111x110", /* 64 */
		"xxxxxxx0x1xxxxxxxxxxxxxx0101x11", /* 65 */
		"0xxx100xxxxxxxxx0xxxxxxx011x111", /* 66 */
		"0111100xxx100xxx001xxxxx111x110", /* 67 */
		"1xxxxx0111xxxxxx0x1xxxxx011x111", /* 68 */
		"0xxx0xxx1xxxxxxx0xxxxxxx0110111", /* 69 */
		"xxxxxxxxx1xxxxxxxxxxxxxx0x001x1", /* 70 */
		"xxxxxxxxxxxxxxxxxxxxxxxx00001x0", /* 71 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1111x11", /* 72 */
		"xxxxxxxxxx0xxxxx1xxxx1xxxx11011", /* 73 */
		"xxxxxxxxxxxxxxxxxxxxxxxx110x000", /* 74 */
		"xxxxxxx0x0xxxxxxxxxxxxxx0101x11", /* 75 */
		"xxxxxxxxxxxxxxxx000xxxxx1111110", /* 76 */
		"0xxxxxxxxxxxxxxxxxxxxxxx01xx0xx", /* 77 */
		"00000001xxxxxxxx001xxxxxxx11110", /* 78 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0x111x1", /* 79 */
		"0000000000000000001xxxxxxx11110", /* 80 */
		"xxxxxxxxxx011xxxxxxxxxxx0111x10", /* 81 */
		"x011xxxxxxxxxxxx1xxxxxxx01x011x", /* 82 */
		"00001101x1000xxx001xxxxxxx11110", /* 83 */
		"xxxxx0xxxxxxxxxxxxxxxxxx0011001", /* 84 */
		"0xxxxxxxx1xxxxxxxxxxxxxx0xx1110", /* 85 */
		"xxxxxxxxxxxxxxxxxxxxxxx00010110", /* 86 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1000010", /* 87 */
		"1xxxxx01x0xxxxxx0x1xxxxx011x111", /* 88 */
		"x0001100xx000xxx001xxxxxxx11110", /* 89 */
		"01111xxxxxxxxxxx1xxxxxxx01x011x", /* 90 */
		"10001101xx000xxx001xxxxxxx11110", /* 91 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1x11101", /* 92 */
		"0111100xxxx10xxx001xxxxx1x11110", /* 93 */
		"xxxxxxxxxxxxxxxxxx0xxxxx01xx0xx", /* 94 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0100101", /* 95 */
		"xxx1xx0xxxxxxxxxxxxxxxxx1011xxx", /* 96 */
		"xxxxxx1000xxxxxx0xxxxxxx011011x", /* 97 */
		"10000x0xxxxxxxxx001xxxxx1x11110", /* 98 */
		"xxxxxxxxxx11xxxxxxxxxxxx011x010", /* 99 */
		"x01xxxxxxxxxxxxxxxxxxxxxx10011x", /* 100 */
		"xxxxx0xxxxxxxxxxxxxxxxxx0011xx0", /* 101 */
		"xxxx10xxxxxxxxxxxxxxxxxx110xx11", /* 102 */
		"x00xxxxxxxxxxxxx1xxxxxxx011x111", /* 103 */
		"xxxxxxxxxxxxxxxx01xxxxxx111x110", /* 104 */
		"xxxxxxxxxxxxxxxxxxxx01xx0000011", /* 105 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1x01101", /* 106 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0111100", /* 107 */
		"xxxx101xxxxxxxxxxxxxxxxx011x000", /* 108 */
		"xxxxxxxxx1xxxxxxxxxxxxxxxx1100x", /* 109 */
		"xxxxxxxxxxxxxxxx10xxxxxx111x110", /* 110 */
		"xxxx011xxxxxxxxxxxxxxxxx011x000", /* 111 */
		"xxxxxxxxxxxx00xxxxx1xxxxx001110", /* 112 */
		"xxxxxxxxxx1xxxxxxxxxxxxxxx11101", /* 113 */
		"xxxxxxxxxxx0xxxxxxxxxxxx010x01x", /* 114 */
		"xxxxxxxx0xxxxxxxxxxxxxxx0101111", /* 115 */
		"xxxxxxxxxx0xxxxx0xxxx1xxx011011", /* 116 */
		"xxxxxxxxxxxxxxxxxxxxxxxx11100x0", /* 117 */
		"xxxxxxxxxxxxxxxxxxxxxxxx00001x1", /* 118 */
		"01110xxxxxxxxxxxxxxxxxxx011x111", /* 119 */
		"x101xxxxxxxxxxxxxxxxxxxx011x01x", /* 120 */
		"0xxxx00xxxxxxxxx0xxxxxxx0110111", /* 121 */
		"xxxxxx1111xxxxxx0xxxxxxx011011x", /* 122 */
		"1xxxxxxxx1xxxxxxxxxxxxxx01x1111", /* 123 */
		"xxxxxxxxxxxxxxxxxxxxxxxx10x1000", /* 124 */
		"x110000xxx000xxx001xxxxx1x11x10", /* 125 */
		"xxxxxxxxxxxx1xxxxxxxxxxxx111011", /* 126 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0111110", /* 127 */
		"xxxxxx1001xxxxxx0xxxxxxx011011x", /* 128 */
		"x10xxxxxxxxxxxxx1xxxxxxx01x011x", /* 129 */
		"xxxxxxxxxxxxxxxxxx1xxxxx1001111", /* 130 */
		"xxxxxxxxxxxxxxx1xxxxxxxx01xxx1x", /* 131 */
		"xxxxxxxxxxxxxxxxxxxxxxxx111x000", /* 132 */
		"xxxxxx1110xxxxxx0xxxxxxx011011x", /* 133 */
		"xxxxxxx1xxxxxxxxxxxxxxxxxx1100x", /* 134 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1101110", /* 135 */
		"xxxxxxxx1xxxxxxxxxxxxxxxxx11x0x", /* 136 */
		"000xxxxxxxxxxxxxxxxxxxxx010011x", /* 137 */
		"xxxxx1xxxxxxxxxxxxxxxxxx110x111", /* 138 */
		"xxxxxxxxxxxxxxxxxxxxxxx10001010", /* 139 */
		"xxxxxxxxxxxxx1xxxxxxxxxx01xxx1x", /* 140 */
		"xxxxxxxxxxxxxx1xxxxxxxxx01xxx1x", /* 141 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0010000", /* 142 */
		"xxxxxxx1xxxxxxxxxxxxxxxx101x10x", /* 143 */
		"xxxx11xxxxxxxxxxxxxxxxxx011x000", /* 144 */
		"0xxxxxxxxxxxxxxxxxxxxxxxxx11xxx", /* 145 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1101100", /* 146 */
		"xxxxx0xxxxxxxxxxxxx0xxxx00x1110", /* 147 */
		"1xxxxxxxxxxxxxxxxxxxxxxx0x01110", /* 148 */
		"xxxxx1x1x1xxxxxx0xxxxxxx011011x", /* 149 */
		"xxxxxxxxxxxxxxxxxxxxxxxx10x1011", /* 150 */
		"xx10xxxxxxxxxxxx1xxxxxxx01x011x", /* 151 */
		"xxxxxxxxxxxxxxxx11xxxxxx111x110", /* 152 */
		"xxxxxx101xxxxxxx0xxxxxxx011011x", /* 153 */
		"100xxxxxxxxxxxxxxxxxxxxx010011x", /* 154 */
		"xxxxxxxxxxxxxxxxxxxxxxxx111110x", /* 155 */
		"xxxxxxxxxxxxxxxxxxxx1xxx0000x00", /* 156 */
		"00001101x0xxxxxx001xxxxx111x110", /* 157 */
		"xxxxxx110xxxxxxx0xxxxxxx011011x", /* 158 */
		"0000000000001xxx001xxxxx1x11110", /* 159 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0010011", /* 160 */
		"0000000011000xxx001xxxxx1x11110", /* 161 */
		"xxxxx1x0xxxxxxxx0xxxxxxx011011x", /* 162 */
		"xxxxxxxxxxxxxxxx1xxxxxxx0110111", /* 163 */
		"xxxxxxxxxxxxxxxxxxxxxxxx100x100", /* 164 */
		"xxxx0xxxxxxxxxxxxxxxxxxx110x111", /* 165 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0001000", /* 166 */
		"xxxxxxxxxxxxxxxxxxxxxxxx110100x", /* 167 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0110111", /* 168 */
		"xxxxxxxxxxxxxxxxxxxxxxxx00x1001", /* 169 */
		"xxxxxxxxxxxxxxxxx0xxxxxx110001x", /* 170 */
		"xxxxxx1xxxxxxxxxxxxxxxxx0111x01", /* 171 */
		"xxxxxxxxxxxx1xxxxxxxxxxxx001110", /* 172 */
		"xxxxxxxxxx100xxxxxxxxxxx011x010", /* 173 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1000x00", /* 174 */
		"xxxxxxxxxxxxxxxxxxxxxxxx11x0110", /* 175 */
		"00000000101xxxxx001xxxxx111x110", /* 176 */
		"xx11xxxxxxxxxxxxxxxxxxxx011x01x", /* 177 */
		"0000000000000011001xxxxx1x11110", /* 178 */
		"xxxxxxxxxx1xxxxxxxxxxxxxx011x11", /* 179 */
		"xxxxxxxxxxxxxxxxxxxxxxxx101x00x", /* 180 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1101010", /* 181 */
		"x0000x1xxxxxxxxx001xxxxx1x11110", /* 182 */
		"xxxxxxxxxxxxxxxxxx0xxxxx1001111", /* 183 */
		"xxxxxxxxxxxxxxxxx0xxxxxx011x01x", /* 184 */
		"0000000000000x10001xxxxx111x110", /* 185 */
		"xxxxxxxxxxxxxxxxxxxxxxxx001110x", /* 186 */
		"xxxx001xxxxxxxxxxxxxxxxx011x000", /* 187 */
		"0000000000000100001xxxxx1x11110", /* 188 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1x00011", /* 189 */
		"xxxxxxxxxxxxxxxxxxxxx0xx0000001", /* 190 */
		"0111100xxxxx1xxx001xxxxx1x11110", /* 191 */
		"xxxxxxxxxx00xxxxxxxxxxxx011x010", /* 192 */
		"xxxxxxxxxxxx0xxxxxx0xxxx1001110", /* 193 */
		"xxxxxxxxxx0x0xxxxxxxxxxx0111010", /* 194 */
		"0000000000000001001xxxxx111x110", /* 195 */
		"xxx0xxxxxxxxxxxxxxxxxxxx011x01x", /* 196 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0010001", /* 197 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1x00111", /* 198 */
		"x01x000xxx000xxx001xxxxx1x11110", /* 199 */
		"xxxxxxxxxxxxxxxxxxxxxxxxx110011", /* 200 */
		"xxxxxx1xxxxxxxxxxxxxxxxx00x10xx", /* 201 */
		"x001000xxx000xxx001xxxxx1x11110", /* 202 */
		"xxxx100xxxxxxxxxxxxxxxxx011x000", /* 203 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0000x10", /* 204 */
		"x10x000xxx000xxx001xxxxx1x11110", /* 205 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0001011", /* 206 */
		"xxxxxxxxxxxx0xxxxxxxxxxxx111011", /* 207 */
		"xxxxxxxxxxxxxxxxxxxxx1xx0000001", /* 208 */
		"xxxxxxxxxxxxxxxxxxxxxxxx10x0100", /* 209 */
		"xxxxxxxxxxxxxxxxxxxxxxxx011000x", /* 210 */
		"xxxxxxxxxxxxxxxxxxxx1xxx0000011", /* 211 */
		"1000110100xxxxxx001xxxxx1x11110", /* 212 */
		"xxxxxxxxxxxxxxxxxxxxxxxx0010010", /* 213 */
		"0xx0xxxxxxxxxxxxxxxxxxxxx011010", /* 214 */
		"xxxx010xxxxxxxxxxxxxxxxx011x000", /* 215 */
		"xxxxxx0xxxxxxxxxxxxxxxxx0111001", /* 216 */
		"0111000xxxxxxxxx001xxxxx1x11110", /* 217 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1001010", /* 218 */
		"xxxxxxxxxxxxxxxxxxxx00xx00000xx", /* 219 */
		"xxxxxxxxxxxxxxxxxxxxxxx00001010", /* 220 */
		"xxxxxxxxxxxxxxxxxxxxxxxx00x0100", /* 221 */
		"xxxxxxxxxxxxxxxxx1xxxxxx110001x", /* 222 */
		"xxxxxxxxxxxxxxxxxxxxxxx10010110", /* 223 */
		"xxxxxxxxxxxxxxxxxxxxxxxx11xx011", /* 224 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1011x11", /* 225 */
		"0000000001xxxxxx001xxxxx1x11110", /* 226 */
		"xxxxxxxxxxxxxxxxxxxxxxxxx011110", /* 227 */
		"xxxxxxxxxxxx01xxxxx1xxxxx001110", /* 228 */
		"xxxxxxx0xxxxxxxxxxxxxxxx1010101", /* 229 */
		"xxx0xxx00xxxxxxxxxxxx0xxx011011", /* 230 */
		"xxxxxxxxxxxxxxxxxxxxxxxx111000x", /* 231 */
		"xxxxxxxxxxxxxxxxxxxx0xxx0000xx0", /* 232 */
		"xxx0xxxxxxxxxxxxxxxxxxxx00x1010", /* 233 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1011x00", /* 234 */
		"xxxxxxxxxxxxxxxxxxxxxxxx1x11x01", /* 235 */
		"xxxxxx1xxxxxxxxxxxxxxxxxx0x1x10", /* 236 */
		"xxxxxxxxxxx1xxxxxxxxxxxx010x01x", /* 237 */
		"x0001100xxxxxxxx001xxxxx111x110", /* 238 */
		"xxxxxxxxxxxxxxxxxxxxxxxx111101x", /* 239 */
		"xxxxxxxxxxxxxxxxxxxxxxxx01xx11x", /* 240 */
		"xxxxxxxxxxxxxxxxxxxxxxxx10001x0", /* 241 */
		"x000xx0x11xxxxxx001xxxxx1x11110", /* 242 */
		"xxxxxxxxxxxxxxxxxxxxxxxx011x0xx", /* 243 */
		"x00010xxxxxxxxxx001xxxxx1x11110", /* 244 */
		"x110xxxxxxxxxxxx001xxxxx1x11x10", /* 245 */
		"0111100xxx000xxx001xxxxx111x110", /* 246 */
		"x001xxxxxxxxxxxx001xxxxx111x110", /* 247 */
		"x10xxxxxxxxxxxxx001xxxxx111x110", /* 248 */
		"x01xxxxxxxxxxxxx001xxxxx111x110"  /* 249 */
	},
	.s = {
		(const int16_t[]) { /* 0 */
			246, 241, 236, 234, 233, 232, 228, 227, 225, 224,
			222, 219, 218, 216, 215, 213, 210, 209, 205, 204,
			203, 202, 201, 199, 198, 193, 190, 189, 188, 187,
			185, 182, 180, 179, 178, 175, 174, 172, 170, 169,
			168, 167, 165, 164, 162, 160, 159, 158, 156, 153,
			152, 151, 150, 149, 148, 147, 143, 137, 135, 133,
			132, 129, 128, 127, 124, 122, 119, 117, 116, 115,
			112, 110, 106, 104, 98,  97,  92,  90,  85,  82,
			80,  78,  76,  75,  74,  73,  72,  64,  63,  44,
			37,  21,  17,  15,  13,  -1
		},
		(const int16_t[]) { /* 1 */
			249, 248, 247, 246, 245, 244, 243, 242, 241, 239,
			238, 237, 236, 235, 234, 233, 232, 231, 230, 229,
			228, 227, 226, 225, 224, 223, 222, 221, 220, 219,
			217, 214, 213, 212, 211, 209, 208, 206, 204, 201,
			198, 197, 195, 191, 190, 189, 188, 186, 185, 183,
			182, 181, 180, 178, 176, 175, 174, 172, 170, 169,
			168, 167, 166, 165, 164, 160, 159, 157, 156, 155,
			154, 152, 150, 147, 146, 143, 142, 139, 138, 136,
			132, 130, 127, 124, 123, 119, 118, 117, 116, 115,
			114, 112, 110, 107, 106, 105, 104, 102, 101, 98,
			96,  95,  93,  87,  86,  80,  79,  78,  75,  74,
			73,  67,  65,  64,  53,  45,  37,  33,  8, -1
		},
		(const int16_t[]) { /* 2 */
			246, 239, 228, 218, 205, 202, 199, 176, 172, 161,
			125, 91,  89,  83,  76,  72,  60, -1
		},
		(const int16_t[]) { /* 3 */
			225, 224, 218, 216, 215, 213, 210, 203, 196, 193,
			189, 187, 185, 181, 177, 174, 171, 160, 152, 144,
			135, 126, 120, 111, 108, 104, 99,  81,  59, -1
		},
		(const int16_t[]) { /* 4 */
			230, 229, 223, 221, 220, 214, 211, 208, 206, 201,
			166, 165, 162, 158, 156, 154, 151, 139, 133, 132,
			128, 123, 122, 105, 97,  86,  85,  39,  -1
		},
		(const int16_t[]) { /* 5 */
			246, 235, 230, 229, 228, 225, 224, 223, 222, 221,
			220, 214, 211, 209, 208, 206, 205, 202, 201, 199,
			197, 189, 186, 185, 183, 182, 174, 172, 170, 166,
			164, 160, 159, 157, 155, 146, 142, 139, 138, 130,
			124, 119, 116, 113, 110, 106, 105, 104, 102, 101,
			98,  96,  86,  78,  64,  45,  37,  31,  1, -1
		},
		(const int16_t[]) { /* 6 */
			249, 248, 247, 246, 245, 244, 242, 241, 240, 239,
			238, 237, 236, 235, 234, 233, 232, 231, 230, 229,
			228, 227, 226, 225, 224, 223, 222, 221, 220, 219,
			218, 217, 214, 213, 212, 211, 209, 208, 206, 204,
			201, 198, 197, 195, 193, 191, 190, 189, 188, 186,
			185, 183, 182, 181, 180, 179, 178, 176, 175, 174,
			172, 171, 170, 169, 167, 166, 165, 164, 160, 159,
			157, 156, 155, 152, 150, 147, 146, 145, 144, 143,
			142, 139, 138, 135, 130, 126, 124, 118, 117, 114,
			112, 111, 110, 108, 107, 106, 105, 104, 102, 99,
			98,  95,  94,  87,  86,  81,  77,  76,  74,  72,
			59,  47,  -1
		},
		(const int16_t[]) { /* 7 */
			246, 241, 240, 239, 237, 236, 235, 234, 233, 232,
			231, 230, 229, 228, 227, 225, 224, 223, 221, 220,
			219, 216, 215, 214, 213, 211, 210, 209, 208, 206,
			205, 204, 203, 202, 201, 199, 198, 197, 195, 193,
			190, 189, 187, 186, 185, 184, 183, 181, 180, 179,
			176, 175, 172, 171, 167, 166, 165, 164, 161, 160,
			159, 157, 156, 155, 152, 150, 146, 144, 143, 142,
			139, 138, 135, 132, 130, 126, 125, 118, 117, 114,
			113, 111, 108, 106, 105, 101, 99,  96,  95,  91,
			89,  86,  84,  83,  81,  79,  61,  60,  59,  47, -1
		},
		(const int16_t[]) { /* 8 */
			249, 248, 247, 246, 245, 244, 242, 239, 238, 228,
			225, 224, 216, 215, 213, 212, 210, 203, 196, 193,
			189, 187, 185, 181, 177, 176, 174, 172, 171, 160,
			152, 144, 135, 126, 120, 111, 108, 104, 99,  81,
			59, -1
		},
		(const int16_t[]) { /* 9 */
			246, 241, 239, 236, 234, 233, 232, 229, 228, 227,
			222, 221, 219, 217, 213, 211, 209, 208, 205, 204,
			202, 199, 198, 197, 194, 191, 190, 182, 180, 175,
			174, 173, 172, 170, 168, 167, 166, 165, 164, 161,
			159, 156, 154, 150, 146, 143, 139, 127, 124, 123,
			119, 117, 115, 110, 107, 105, 104, 98,  93,  91,
			87,  86,  84,  78,  75,  73,  67,  65,  64,  53,
			47,  33,  19,  8, -1
		},
		(const int16_t[]) { /* 10 */
			234, 231, 229, 216, 213, 210, 209, 207, 200, 198,
			180, 171, 168, 164, 155, 143, 127, 126, 117, 92,
			37, -1
		},
		(const int16_t[]) { /* 11 */
			246, 239, 235, 234, 233, 231, 229, 228, 227, 224,
			223, 221, 220, 218, 216, 215, 213, 210, 209, 208,
			207, 206, 205, 202, 200, 199, 194, 193, 192, 187,
			186, 185, 181, 180, 179, 176, 175, 172, 171, 167,
			166, 165, 163, 162, 161, 155, 154, 151, 150, 146,
			144, 143, 139, 137, 135, 132, 130, 129, 127, 126,
			125, 123, 121, 119, 118, 114, 111, 105, 99,  96,
			95,  91,  90,  89,  86,  84,  83,  82,  81,  68,
			65,  61,  60,  47,  -1
		},
		(const int16_t[]) { /* 12 */
			249, 248, 247, 246, 245, 244, 243, 242, 241, 240,
			239, 238, 237, 236, 235, 234, 233, 232, 231, 230,
			229, 228, 227, 226, 225, 224, 223, 222, 221, 220,
			219, 218, 217, 214, 213, 212, 211, 209, 208, 206,
			204, 201, 198, 197, 195, 193, 191, 190, 189, 188,
			186, 185, 183, 182, 181, 180, 179, 178, 176, 175,
			174, 172, 170, 169, 167, 166, 165, 164, 160, 159,
			157, 156, 155, 152, 150, 147, 146, 143, 142, 139,
			138, 136, 135, 132, 130, 124, 118, 117, 116, 114,
			112, 110, 107, 106, 105, 104, 102, 101, 98,  96,
			95,  93,  87,  86,  80,  79,  78,  76,  74,  73,
			72,  67,  64,  53,  45,  37,  -1
		},
		(const int16_t[]) { /* 13 */
			241, 237, 236, 235, 234, 233, 232, 231, 230, 229,
			227, 225, 223, 222, 219, 218, 216, 214, 213, 211,
			210, 209, 207, 204, 203, 201, 200, 198, 197, 195,
			190, 189, 186, 183, 180, 179, 174, 173, 171, 170,
			167, 164, 160, 159, 158, 157, 156, 155, 154, 153,
			152, 151, 149, 148, 146, 143, 142, 138, 137, 133,
			132, 129, 128, 127, 126, 124, 123, 122, 118, 117,
			115, 113, 110, 108, 106, 104, 103, 102, 101, 97,
			96,  95,  90,  88,  85,  84,  82,  75,  61,  59, -1
		},
		(const int16_t[]) { /* 14 */
			249, 248, 247, 246, 245, 243, 241, 239, 237, 236,
			235, 234, 231, 230, 229, 228, 227, 225, 224, 223,
			222, 218, 217, 214, 213, 211, 209, 201, 197, 195,
			193, 191, 189, 188, 186, 185, 183, 181, 180, 178,
			176, 174, 172, 170, 169, 167, 161, 160, 159, 158,
			157, 155, 154, 153, 152, 151, 150, 149, 147, 146,
			143, 142, 137, 135, 133, 132, 130, 127, 124, 123,
			119, 118, 116, 114, 113, 112, 110, 107, 106, 104,
			103, 102, 97,  96,  95,  93,  91,  89,  87,  83,
			71,  67,  60,  39,  21,  17,  13, -1
		},
		(const int16_t[]) { /* 15 */
			246, 239, 237, 225, 224, 223, 220, 217, 216, 215,
			213, 211, 210, 209, 208, 207, 206, 205, 203, 202,
			200, 199, 192, 191, 187, 183, 182, 174, 171, 160,
			159, 155, 152, 150, 146, 142, 130, 126, 114, 111,
			108, 107, 105, 103, 98,  96,  93,  89,  87,  83,
			81, 78, 67, 64, 60, 59, 47, 19, -1
		},
		(const int16_t[]) { /* 16 */
			249, 246, 241, 239, 235, 234, 233, 232, 231, 229,
			228, 227, 226, 225, 224, 223, 221, 220, 219, 218,
			217, 216, 215, 214, 213, 212, 210, 209, 208, 207,
			206, 205, 204, 202, 200, 198, 197, 195, 194, 193,
			192, 190, 188, 187, 186, 185, 181, 180, 179, 178,
			176, 175, 174, 172, 171, 167, 166, 165, 164, 162,
			161, 160, 159, 157, 155, 154, 152, 150, 149, 148,
			147, 146, 144, 143, 142, 139, 137, 135, 132, 130,
			129, 127, 126, 125, 124, 123, 121, 119, 118, 115,
			114, 113, 112, 111, 107, 106, 105, 104, 103, 99,
			97,  96,  95,  91,  89,  88,  87,  86,  85,  84,
			83,  81,  79,  65,  60,  55,  54,  47,  34,  22,
			16, -1
		},
		(const int16_t[]) { /* 17 */
			249, 248, 247, 246, 244, 242, 241, 239, 238, 228,
			226, 225, 224, 223, 217, 216, 215, 212, 207, 198,
			195, 194, 193, 191, 188, 185, 181, 178, 176, 172,
			171, 160, 158, 157, 156, 147, 144, 135, 128, 126,
			125, 115, 112, 111, 99,  93,  90,  88,  87,  85,
			81,  80,  67,  53,  45,  38,  34,  22,  20,  18,
			9, -1
		},
		(const int16_t[]) { /* 18 */
			233, 226, 188, 178, 165, 147, 138, 123, 115, 112,
			88,  85,  68,  57,  25,  17,  3,   -1
		},
		(const int16_t[]) { /* 19 */
			241, 239, 237, 236, 233, 232, 229, 225, 224, 223,
			222, 220, 219, 218, 217, 207, 206, 204, 200, 198,
			195, 193, 192, 191, 190, 189, 188, 186, 185, 182,
			181, 180, 179, 178, 176, 175, 174, 170, 165, 163,
			162, 161, 158, 157, 156, 154, 153, 151, 149, 148,
			147, 146, 143, 137, 135, 133, 129, 128, 127, 125,
			123, 122, 119, 118, 117, 115, 114, 112, 107, 104,
			98,  97,  93,  92,  91,  90,  89,  88,  87,  85,
			83,  82,  80,  78,  76,  74,  73,  72,  69,  67,
			66,  65,  64,  63,  60,  53,  47,  21,  17,  13, -1
		},
		(const int16_t[]) { /* 20 */
			237, 226, 225, 222, 218, 216, 214, 213, 212, 211,
			210, 207, 200, 198, 192, 189, 187, 174, 171, 165,
			164, 163, 160, 159, 157, 152, 142, 126, 124, 117,
			115, 114, 113, 104, 100, 85,  79,  75,  54,  52,
			50,  49,  47,  43,  39,  36,  35,  32,  30,  29,
			28,  27,  24,  23,  14,  12,  10,  7,   6,   5,
			4,   2, -1
		},
		(const int16_t[]) { /* 21 */
			230, 229, 223, 220, 214, 211, 208, 206, 201, 178,
			166, 154, 147, 139, 123, 112, 105, 80,  3,   -1
		},
		(const int16_t[]) { /* 22 */
			230, 229, 220, 214, 211, 208, 206, 201, 188, 178,
			175, 166, 154, 153, 149, 148, 147, 139, 137, 129,
			123, 112, 105, 90, 82, 80, -1
		},
		(const int16_t[]) { /* 23 */
			246, 239, 228, 225, 224, 222, 216, 215, 213, 210,
			207, 205, 203, 202, 200, 199, 198, 194, 193, 192,
			189, 187, 185, 183, 181, 176, 175, 174, 173, 172,
			171, 170, 168, 164, 161, 160, 157, 152, 150, 144,
			142, 135, 130, 126, 125, 124, 116, 115, 111, 110,
			108, 104, 102, 101, 99,  91,  89,  83,  81,  73,
			60,  59,  -1
		},
		(const int16_t[]) { /* 24 */
			246, 244, 242, 241, 239, 238, 237, 236, 235, 234,
			233, 232, 231, 230, 229, 228, 227, 226, 222, 220,
			219, 218, 214, 212, 208, 207, 206, 205, 204, 202,
			201, 200, 199, 198, 197, 194, 193, 192, 190, 188,
			186, 182, 181, 180, 179, 178, 175, 174, 173, 172,
			170, 167, 166, 165, 162, 159, 158, 156, 155, 154,
			153, 152, 151, 150, 149, 148, 147, 146, 143, 142,
			138, 137, 135, 133, 129, 128, 127, 126, 124, 123,
			122, 118, 116, 115, 114, 113, 112, 110, 107, 106,
			103, 99,  98,  97,  95,  90,  88,  87,  85,  82,
			81,  80,  78,  76,  73,  72,  69,  66,  65,  64,
			63,  59,  53,  37,  -1
		},
		(const int16_t[]) { /* 25 */
			241, 236, 235, 234, 233, 231, 229, 223, 221, 218,
			216, 213, 211, 210, 209, 207, 200, 198, 186, 180,
			179, 171, 167, 166, 164, 163, 162, 159, 157, 155,
			152, 146, 143, 142, 133, 132, 128, 127, 126, 124,
			123, 122, 113, 101, 96,  86,  75,  68,  61,  58,
			55,  40, -1
		},
		(const int16_t[]) { /* 26 */
			241, 236, 234, 233, 231, 229, 227, 223, 220, 218,
			216, 214, 213, 210, 209, 207, 206, 200, 197, 186,
			180, 179, 174, 171, 167, 157, 155, 148, 146, 143,
			133, 127, 126, 123, 117, 113, 104, 92,  86,  85,
			84,  71,  68,  61,  55,  51,  48,  46,  -1
		},
		(const int16_t[]) { /* 27 */
			246, 241, 239, 234, 233, 231, 230, 229, 228, 225,
			224, 222, 216, 214, 213, 210, 209, 207, 205, 202,
			200, 199, 197, 195, 193, 189, 185, 183, 181, 180,
			176, 172, 171, 170, 163, 161, 160, 159, 155, 152,
			144, 143, 142, 138, 135, 127, 126, 125, 124, 123,
			115, 113, 111, 110, 108, 102, 99,  96,  94,  92,
			91, 89, 88, 84, 83, 81,  77,  71,  69,  68,
			65, 62, 60, 59, 58, 56,  42,  26,  11,  -1
		},
		(const int16_t[]) { /* 28 */
			246, 243, 239, 237, 236, 235, 234, 233, 231, 230,
			229, 228, 227, 225, 224, 222, 219, 214, 213, 211,
			209, 205, 202, 201, 199, 195, 193, 190, 189, 185,
			183, 181, 180, 176, 174, 172, 170, 163, 161, 160,
			157, 156, 155, 153, 152, 143, 142, 135, 128, 127,
			125, 122, 113, 110, 104, 102, 101, 96,  91,  89,
			84,  83,  75,  71,  70,  60,  58,  41,  40, -1
		},
		(const int16_t[]) { /* 29 */
			237, 235, 234, 230, 227, 224, 222, 217, 216, 215,
			214, 211, 210, 207, 203, 200, 197, 195, 192, 191,
			189, 187, 176, 174, 171, 170, 161, 159, 155, 144,
			139, 132, 126, 124, 119, 118, 115, 114, 113, 111,
			110, 108, 107, 101, 99,  96,  93,  91,  88,  87,
			81, 75, 69, 67, 66, 59,  53,  47,  -1
		},
		(const int16_t[]) { /* 30 */
			233, 232, 231, 230, 229, 225, 223, 222, 221, 220,
			219, 211, 209, 208, 206, 204, 198, 197, 190, 189,
			180, 179, 175, 168, 166, 165, 164, 160, 156, 150,
			139, 138, 118, 117, 106, 105, 96,  95,  86,  61, -1
		},
		(const int16_t[]) { /* 31 */
			249, 248, 247, 246, 245, 244, 242, 241, 239, 238,
			236, 234, 233, 232, 230, 229, 228, 227, 225, 224,
			222, 219, 212, 209, 204, 198, 195, 193, 190, 189,
			186, 185, 183, 181, 180, 179, 176, 175, 172, 170,
			168, 167, 165, 164, 160, 157, 156, 155, 150, 146,
			144, 143, 140, 138, 135, 134, 130, 117, 110, 102,
			99, 92, -1
		},
		(const int16_t[]) { /* 32 */
			249, 248, 247, 246, 245, 244, 242, 241, 239, 238,
			236, 234, 233, 232, 231, 229, 228, 227, 224, 220,
			219, 212, 209, 206, 204, 198, 195, 193, 190, 186,
			185, 183, 181, 180, 179, 176, 175, 172, 170, 168,
			167, 165, 164, 157, 156, 155, 150, 146, 144, 141,
			139, 138, 136, 135, 130, 118, 117, 110, 102, 99,
			96, 95, 92, -1
		},
		(const int16_t[]) { /* 33 */
			249, 248, 247, 246, 245, 244, 242, 241, 239, 238,
			236, 235, 234, 231, 228, 227, 220, 212, 208, 206,
			198, 197, 195, 193, 183, 176, 175, 172, 168, 167,
			166, 165, 164, 157, 155, 146, 144, 143, 135, 131,
			130, 118, 117, 109, 105, 99,  95,  -1
		}
	},
	.xin = 0x7F,
	.xout = ((1ull << 0 | 1ull << 5 | 1ull << 8 | 1ull << 9 | 1ull << 15 |
		  1ull << 19 | 1ull << 24 | 1ull << 29) ^ 0x3FFFFFFFFull) |
		  1ull << (0 + PLM_S_MAX) | 1ull << (1 + PLM_S_MAX) |
		  1ull << (2 + PLM_S_MAX) | 1ull << (6 + PLM_S_MAX),
	.in_nb = 31,
	.out_nb = 34,
	.na_nb = 7,
	.na_bits = { 29, 24, 19, 15, 9, 5, 0 }
};

const struct plm_desc plm_desc_vm2 = {
	.p = {
		NULL, /* 0 */
		NULL, /* 1 */
		"xxxxxxxxxxxxx111xxxxxx110x11", /* 2 */
		"xxxxxxxxxx11xxxxxxxxxx0x1100", /* 3 */
		"xxxxxxxxxx11xxxxxxxxxx110x1x", /* 4 */
		"xxxx1x1010xxxxxx0xxxxx001xx0", /* 5 */
		"0x10xxxxxxxxxxxxxxxxxxx0x100", /* 6 */
		"xxxxx1x00xxxxxxx0xxxxx001x00", /* 7 */
		"xxxxxxxxxx000xxxxxx1xx001101", /* 8 */
		"xxxx0xxxxx0111xxxxxx1x111010", /* 9 */
		"xxxx001xxxxxxxxxxxxxxx011000", /* 10 */
		"xxxxxxxxxxxxx111xxxxxxx0xx00", /* 11 */
		"xxxxx01xxxxxxxxxxxxxxx11x001", /* 12 */
		"xxxx0xxxxx01101xxxxx1x111010", /* 13 */
		"xxxx010xxxxxxxxxxxxxxx001010", /* 14 */
		"xxxxxxxxxxxxxxxxxxx1xx11x10x", /* 15 */
		"x101xxxxxxxxxxxxxxxxxxx0x100", /* 16 */
		"xxx11xxxxxxxxxxxx1xxxx001x10", /* 17 */
		"xxxxxxxxxx000xxxxxxxxx001101", /* 18 */
		"x0xxxx1101xxxxxx0xxxxx001xx0", /* 19 */
		"xxxxx0x1xxxxxxxxxxxxxx111010", /* 20 */
		"xxx1x00xxxxxxxxxxxxxxxx10011", /* 21 */
		"x1111xxxxxxxxxxxxxxxxxx0x100", /* 22 */
		"xxxxxxxxxxxxxxxxxxx11xx11001", /* 23 */
		"x100xxxxxxxxxxxxxxxxxxx0x100", /* 24 */
		"xxx0xxxxxx000xxxxxxxxx011000", /* 25 */
		"xxxxxxxxxxxxxxxx1xxxxx001100", /* 26 */
		"xxxxxxx10xxxxxxxxxxxxxxx010x", /* 27 */
		"xxxx010xxxxxxxxxx11xxx110x0x", /* 28 */
		"xxxx0xxxxx000x11xxxxxx111010", /* 29 */
		"xxxxxxxxxxxxxxxxx1xxxx010010", /* 30 */
		"xxxxxxx01xxxxxxxxxxxxxxx0101", /* 31 */
		"xxx0xxx0xxxxx1xxxxxxxx001010", /* 32 */
		"xxxxxxxxxx000xxxxxx1xx110x00", /* 33 */
		"xxxxx11xxxxxxxxxxxxxxxx10011", /* 34 */
		"xxxxx00xxxxxxxxxxxxxxxx00101", /* 35 */
		"xxxx0xxxxx1xxxxxxxxxxx111010", /* 36 */
		"xxxxxxxxxx000xxxxxxxxx110x00", /* 37 */
		"xxxxxxxxxxxxxxxxxxx0xx1011x0", /* 38 */
		"xxx0xxxxxx011xx1xxxxxx011000", /* 39 */
		"x0xxxxx0xxxx10xxx0xxxx001x10", /* 40 */
		"xxxxx11xxxxxxxxxxxxxxxx001x1", /* 41 */
		"xxxx00xxxxxxxxxxxxxxxx110x00", /* 42 */
		"1xxxx1x111xxxxxx0xxxxx001xx0", /* 43 */
		"xxxxxxxxxxxxxxxxxxxxxx101101", /* 44 */
		"xxxx0xxxxx011000xxxx1x111010", /* 45 */
		"xxxx0xxxxx01xxxxxxxx0x111010", /* 46 */
		"xxxxxx00xxxxxx0xxxxxxx100110", /* 47 */
		"xxx1x0xxxxxxxxxxxxxxxx110011", /* 48 */
		"xxxxxxxxxxxxxxxxxxxxxxx00000", /* 49 */
		"xxx0xxxxxx0010xxxxxxxx011000", /* 50 */
		"xxxxxxxxxxxxxxxxxxxxxx11100x", /* 51 */
		"xxxxxxxxxxxxxxxxxxxxxx101111", /* 52 */
		"x111x00xxxxxxxxxxxxxxxx0x100", /* 53 */
		"xxxxxxxx1xxxxxxxxxxxxx1100x1", /* 54 */
		"xxxxxxxxxxxxxxxxxxxxxx010001", /* 55 */
		"xxxxxx0xxxxxxxxxxxxxxx100001", /* 56 */
		"xxxx0xxxxx001xxxxxxx0x111010", /* 57 */
		"xxxx0xxxxx0001x1xxxxxx111010", /* 58 */
		"x011xxxxxxxxxxxxxxxxxxx0x100", /* 59 */
		"xxx0xxxxxx011xx0xxxxxx011000", /* 60 */
		"xxxx010xxxxxxxxxx0xxxx110x0x", /* 61 */
		"xxxx001xxxxxxxxxxxxxxx001010", /* 62 */
		"xxxxxxxxxxxxxxxxxxxxxx010011", /* 63 */
		"xxxxxxxxxxxxxxxxxxxxxx000110", /* 64 */
		"x0xx0xxx11xxxxxx0xxxxx001xx0", /* 65 */
		"xxxx0xxxxx000001xxxxxx111010", /* 66 */
		"xxxxxxxxxx0x0xxxxx1xx1101000", /* 67 */
		"xxxx11xxxxxxxxxxx0xxxx011000", /* 68 */
		"xxx1xxxxxxxxxxxxxxxxxxx00111", /* 69 */
		"xxxxxxx11xxxxxxxxxxxxxxx010x", /* 70 */
		"xxxxxxxxxxxxxxxxxxx000x11110", /* 71 */
		"xxxxxxxxx1xxxxxxxxxxxxxx010x", /* 72 */
		"xxxxxxxxx1xxxxxxxxxxxx1100xx", /* 73 */
		"xxxx0x0xxxxxxx1xxxxxxx001110", /* 74 */
		"xxxxx0xxxxxxxxxxxxxxxxx00101", /* 75 */
		"xxxxxxxxxxxxxxxxxxxxxx001101", /* 76 */
		"xxxx0xxx0xx10000xxxx1x111010", /* 77 */
		"xxxxxxxxxx00xxxxxxxxxx101000", /* 78 */
		"xxx0xxxxxx11xxxxxxxxxx011000", /* 79 */
		"xxxxxxxxxxxxxxxxx0xxxx1110x1", /* 80 */
		"xxx0xxx1xxxxxxxxxxxxxx001010", /* 81 */
		"xx0xxxxxxxxxxxxx1xxxxxx0x100", /* 82 */
		"xxxxxx1100xxxxxx0xxxxx001x00", /* 83 */
		"xxxx0x0xxxxx0xxxxxxxxxx10110", /* 84 */
		"xxx0xxxxxx0x11xxxxxxxx011000", /* 85 */
		"xxx00xxxx1xxxxxxxxxxxxx00111", /* 86 */
		"xxxxx10xxxxxxxxxxxxxxx011000", /* 87 */
		"xxx0xxxxxxxxxxxxxxxxxx110x01", /* 88 */
		"x010xxxxxxxxxxxxxxxxxxx0x100", /* 89 */
		"xxxxx1xxxxxxxxxxxxxxxxx00111", /* 90 */
		"xxxxxxxxxx011xxxxxxxx0101000", /* 91 */
		"xxxxxxx1xxxxxxxxxxxxxx1100xx", /* 92 */
		"xxxxxxxxxxxxxxxxxxxxxxx10100", /* 93 */
		"xxx0xxx0xxxxx0xxx1xxxx001010", /* 94 */
		"00xxx1x1x1xxxxxx0xxxxx001xx0", /* 95 */
		"xxxxxx1xxxxxxxxxxxxxxx111010", /* 96 */
		"xx0x0xxx10xxxxxxxxxxxx0010x0", /* 97 */
		"xxxx0xxxxx000100xxxxxx111010", /* 98 */
		"xxx0xx1000xxxxxx0xxxxx001xx0", /* 99 */
		"xxxx0xxxxx011001xxxx1x111010", /* 100 */
		"xxx0xxxxxx10xxxxxxxxxx011000", /* 101 */
		"xxxxxxxxxxxxxxxxxxxxx0001011", /* 102 */
		"xxxxxxxxxxxxxxxxxxxxxx00110x", /* 103 */
		"xxxx0xxxxx000000xxxxxx111010", /* 104 */
		"xxxxx1xxxxxxxxxxxxxxxx100110", /* 105 */
		"xxxxxxxx1xxxxxxxxxxxxx11x0x0", /* 106 */
		"xxxxxxxxxx101xxxxxxxxx101000", /* 107 */
		"xxx1x00xxxxxxxxxxxxxxx001x10", /* 108 */
		"xxxxxxxxxxxxxxxxxxx1xxx11110", /* 109 */
		"xxxxxx1xxxxxxxxxxxxxxxx10101", /* 110 */
		"xxxxxxxxxxxxxxxxxxxx0x101110", /* 111 */
		"xxxx0xxx0xx10001xxxx1x111010", /* 112 */
		"xxxx0xxx0xx00x10xxxxxx111010", /* 113 */
		"x1110xxxxxxxxxxx1xxxxxx0x100", /* 114 */
		"xxxxxxxxxxxxxxxxxxxxxx011100", /* 115 */
		"xxxxxxxxxxxxxxxxxxxxxx100011", /* 116 */
		"xxxxx1x1x0xxxxxx0xxxxx001x00", /* 117 */
		"xxxx10xxxxxxxxxxxxxxxx011000", /* 118 */
		"xxxxxxxxxxxxxxxxxxxxxx001111", /* 119 */
		"xxxxxxxxxxxxxxxxxxxxxx110010", /* 120 */
		"xxxxxx1111xxxxxx0xxxxx001x00", /* 121 */
		"xxxxxxxxxxxxxxxxxxxxxx011010", /* 122 */
		"xxxx0x0xxxxxxx0xx1xxxx001110", /* 123 */
		"xxxx011xxxxxxxxxx1xxxx110x00", /* 124 */
		"xxxxxxxx1xxxxxxxxxxxxxxx0x00", /* 125 */
		"xxxxxxxxxxxxxxxxxxxxxx011111", /* 126 */
		"xxxxxxxxxxxxxxxxxxxxxx001001", /* 127 */
		"xxx1xxxxxxxxxxxxxxxxxx100110", /* 128 */
		"xxxx0xxx0xx1x1xxxxxxxx1110x0", /* 129 */
		"x110xxxxxxxxxxxx1xxxxxx0x100", /* 130 */
		"xxxxx00xxxxxxxxxxxxxxx110x00", /* 131 */
		"xxxxxxxxxxx00xxxxxxxxx101000", /* 132 */
		"xxxxxx0xxxxxxxxxxxxxxxx10101", /* 133 */
		"xxx11xxxxxxxxxxxxxxxxx001x10", /* 134 */
		"xxxx100xxxxxxxxx0xxxxx0011x0", /* 135 */
		"xxxx0xxxxx001xxxxxxx1x111010", /* 136 */
		"xxxxxxxxxx0x0xxxxxxxx0101000", /* 137 */
		"xxxxxxxxxxxxxxxxxxxxx1001011", /* 138 */
		"xxxxxxxxxxxxxxxxx1xxxx1110x1", /* 139 */
		"xxx0xxxxxx0x0xxxxxxxxx01x000", /* 140 */
		"xxxxxx1xxxxxxxxxxxxxxx100001", /* 141 */
		"xxxx11xxxxxxxxxxx1xxxx011000", /* 142 */
		"xxxx000x0xxxxxxx0xxxxx001100", /* 143 */
		"xxxxxxxxxxxxxxxxx1x0011x1110", /* 144 */
		"xxxxx00xxxxxxx1xx1xxxx100110", /* 145 */
		"xxx1x00xxxxxxxxxxxxxxx011000", /* 146 */
		"xxxx11x0x1xxxxxx0xxxxx001xx0", /* 147 */
		"xxxxxxxxxx111xxxxxxxxx101000", /* 148 */
		"xxxx10xxxxxxxxxxxxxxxxx10110", /* 149 */
		"xxxx1xxxxxxxxxxxxxxxxx001110", /* 150 */
		"1xxxxxxxxxxxxxxxxxxxxx111010", /* 151 */
		"xxxxxxxxxxxxx1xxxxxxxxx0xx00", /* 152 */
		"xxxxxxxxxxxxxxxxxxx001011110", /* 153 */
		"xxxx01xxxxxxxxxxxxxxxx001x10", /* 154 */
		"xxxx010xxxxxxxxxx10xxx110x0x", /* 155 */
		"xxxxxxxxxxxxxx1xxxxxxxx0xx00", /* 156 */
		"xxxxx1xxxxxxxxxxxxxxxx111010", /* 157 */
		"xxxxxxxxxxxxxxx1xxxxxxx0xx00", /* 158 */
		"xxxx101xxxxxxxxxxxxxxx110x0x", /* 159 */
		"xxx00xxxx0xxxxxxxxxxxxx00111", /* 160 */
		"xxxxxx1xxxxxxxxxxxxxxx00111x", /* 161 */
		"xxxx0xxx0xx1x01xxxxxxx1110x0", /* 162 */
		"x000xx101xxxxxxx0xxxxx001x00", /* 163 */
		"xxxxxxxxxx011xxxxxxxx1101000", /* 164 */
		"xxxx0x1xxxxxxxxxxxxxxx011000", /* 165 */
		"xxxx10xxxxxxxxxxxxxxxxx00111", /* 166 */
		"xxxxxxxxxxxxxxxxx0x0011x1110", /* 167 */
		"xxxx11x0x0xxxxxx0xxxxx001xx0", /* 168 */
		"xxxxxxxxxx110xxxxxxxxx101000", /* 169 */
		"xxxxxxxxxxxxxxxxxxxxxx010010", /* 170 */
		"xxxxxxxxxxxxxxxxxxxxxx11x10x", /* 171 */
		"xxxx011xxxxxxxxxx0xxxx110x00", /* 172 */
		"xxxxxxxxxxxxxxxxxxxxxx011101", /* 173 */
		"xxxxxxxxxxxxxxxxxxxxxxx00101", /* 174 */
		"xxxx110xxxxxxxxxxxxxxx110x0x", /* 175 */
		"xxxxxxxxxxxxxxxxxxxx1x101110", /* 176 */
		"xxxx111xxxxxxxxxxxxxxx110x0x", /* 177 */
		"xxx0xxxxxxxxxxxxxxxxxxx10011", /* 178 */
		"x000xx1110xxxxxx0xxxxx001xx0", /* 179 */
		"xxxxxxxxxxxxxxxxxxxxxx0x0000", /* 180 */
		"xxx00xxxxxxx0xxxx0xxxx100110", /* 181 */
		"xxxxxxxxxxxxxxxxxxxxxx010111", /* 182 */
		"xxxxxxxxxx010xxxxx0xx1101000", /* 183 */
		"xxxxxxxxxxxxxxxxxxxxxx0000x0", /* 184 */
		"xxxxxx1xxxxxxxxxxxxxxxx10110", /* 185 */
		"x000xx1x01xxxxxx0xxxxx001xx0", /* 186 */
		"xxxxxxxxxxxxxxxxxxxxxx000011", /* 187 */
		"xxxx0x0xxxxx1xxxxxxxxxx10110", /* 188 */
		"xxxxxxxxxxxxxxxxxxxxxx1x1001", /* 189 */
		"xxxxxxxxxxxxxxxxxxxxxxx11001", /* 190 */
		"xxxxxxxxxxxxxxxxxxxxxx100010", /* 191 */
		"xxxxxxxxxxxxxxxxxxxxxx00000x", /* 192 */
		"xxxxxxxxxxxxxxxxxxxxxx11x111", /* 193 */
		"xxxxx1xxxxxxxxxxxxxxxxx10110", /* 194 */
		"xxxxxxxxxxxxxxxxxxxxxx1x110x", /* 195 */
		"xxxxxxxxxxxxxxxxxxxxxxx10000", /* 196 */
		"xxxxxxxxxxxxxxxxxxxxxxx011x1", /* 197 */
		"xxxx0xxxxxxxxxxxxxxxxxx10011", /* 198 */
		"xxxxxxxxxxxxxxxxxxxxxx110x01", /* 199 */
	},
	.s = {
		(const int16_t[]) { /* 0 */
			170, 151, 134, 119, 104,  98,  90,  66,  64,  58,
			57,  51,  46,  32,  29, -1
		},
		(const int16_t[]) { /* 1 */
			199, 198, 197, 196, 194, 193, 192, 191, 189, 188,
			185, 184, 183, 182, 181, 178, 176, 174, 173, 171,
			170, 169, 167, 166, 165, 164, 162, 161, 160, 157,
			154, 153, 151, 150, 149, 148, 146, 145, 144, 143,
			142, 141, 140, 139, 138, 137, 136, 135, 134, 133,
			132, 129, 128, 127, 126, 123, 122, 120, 116, 115,
			114, 113, 112, 111, 110, 109, 108, 107, 106, 105,
			104, 102, 101, 100, 98,  97,  96,  93,  91,  87,
			86,  85,  84,  81,  80,  79,  78,  77,  71,  69,
			68,  67,  62,  57,  55,  51,  50,  49,  47,  46,
			45,  39,  29,  23, -1
		},
		(const int16_t[]) { /* 2 */
			192, 191, 188, 184, 183, 181, 180, 177, 175, 173,
			172, 169, 166, 164, 160, 159, 155, 153, 150, 148,
			145, 137, 132, 131, 124, 113, 112, 107, 104, 102,
			100, 91,  78,  76,  61,  58,  55,  42,  17, -1
		},
		(const int16_t[]) { /* 3 */
			192, 191, 189, 184, 183, 180, 177, 175, 173, 169,
			167, 166, 164, 159, 157, 155, 148, 143, 141, 135,
			132, 131, 124, 121, 118, 114, 107, 102, 100, 90,
			89, 76, 60, 59, 55, 52, 40, 36, 32, 28, -1
		},
		(const int16_t[]) { /* 4 */
			193, 191, 190, 187, 185, 184, 182, 180, 176, 174,
			173, 171, 165, 161, 146, 141, 138, 133, 128, 127,
			122, 118, 116, 115, 111, 110, 109, 108, 103, 101,
			96,  93,  87,  85,  84,  80,  79,  77,  74,  71,
			69,  68,  67,  63,  62,  50,  44,  39, -1
		},
		(const int16_t[]) { /* 5 */
			194, 193, 192, 191, 190, 189, 188, 187, 184, 182,
			181, 180, 176, 173, 167, 166, 160, 157, 153, 152,
			150, 149, 145, 144, 142, 141, 139, 138, 136, 127,
			126, 122, 118, 116, 115, 113, 112, 111, 109, 105,
			103, 101, 100, 96,  92,  86,  85,  84,  81,  80,
			79,  77,  74,  71,  68,  63,  62,  55,  52,  50,
			39,  25, -1
		},
		(const int16_t[]) { /* 6 */
			197, 194, 192, 191, 189, 188, 187, 181, 180, 173,
			171, 167, 166, 165, 160, 157, 156, 153, 150, 149,
			145, 144, 142, 139, 136, 127, 126, 118, 116, 113,
			108, 106, 103, 93,  87,  86,  81,  60,  55,  54,
			39,  25, -1
		},
		(const int16_t[]) { /* 7 */
			197, 194, 193, 191, 189, 188, 187, 184, 180, 173,
			171, 167, 158, 157, 153, 149, 146, 144, 142, 139,
			138, 136, 128, 127, 126, 122, 118, 116, 115, 112,
			110, 109, 105, 103, 100, 96,  93,  86,  80,  77,
			73,  71,  68,  62,  39,  34,  25,  21,  12, -1
		},
		(const int16_t[]) { /* 8 */
			192, 191, 189, 188, 187, 186, 184, 183, 182, 181,
			179, 177, 176, 175, 172, 169, 167, 166, 164, 163,
			162, 160, 159, 157, 155, 153, 150, 148, 145, 144,
			142, 141, 139, 137, 136, 132, 131, 129, 128, 127,
			124, 121, 120, 116, 113, 112, 111, 108, 107, 102,
			100, 99,  95,  94,  91,  85,  83,  69,  67,  63,
			61,  55,  52,  50,  45,  36,  10, -1
		},
		(const int16_t[]) { /* 9 */
			199, 198, 195, 193, 191, 190, 186, 185, 179, 176,
			165, 162, 161, 154, 149, 146, 143, 140, 139, 138,
			136, 135, 127, 126, 122, 117, 115, 109, 108, 105,
			102, 101, 96,  95,  87,  86,  84,  81,  80,  79,
			77,  74,  71,  68,  49,  43,  26,  -1
		},
		(const int16_t[]) { /* 10 */
			194, 193, 191, 190, 187, 185, 182, 178, 177, 175,
			171, 169, 165, 164, 162, 161, 149, 148, 146, 143,
			140, 138, 136, 135, 129, 127, 126, 124, 122, 121,
			117, 116, 115, 111, 109, 105, 102, 101, 99,  97,
			96,  88,  87,  86,  85,  84,  83,  81,  80,  79,
			77,  74,  71,  70,  69,  68,  67,  63,  50,  49,
			45,  44,  43,  38,  27, -1
		},
		(const int16_t[]) { /* 11 */
			197, 196, 195, 192, 190, 189, 188, 186, 184, 183,
			182, 181, 179, 178, 176, 169, 167, 166, 164, 163,
			162, 160, 153, 150, 148, 145, 144, 143, 141, 140,
			137, 136, 135, 132, 129, 128, 127, 126, 125, 120,
			116, 113, 112, 108, 107, 105, 100, 97,  94,  91,
			88,  86,  85,  84,  74,  70,  67,  56,  55,  50,
			47,  31,  26, -1
		},
		(const int16_t[]) { /* 12 */
			197, 195, 194, 193, 192, 190, 189, 188, 185, 184,
			183, 181, 178, 177, 176, 175, 172, 169, 167, 166,
			165, 164, 162, 161, 160, 159, 157, 155, 153, 150,
			149, 148, 146, 145, 144, 142, 141, 140, 138, 136,
			127, 126, 124, 123, 122, 115, 113, 112, 110, 109,
			108, 107, 105, 101, 100, 97,  96,  95,  91,  88,
			87,  84,  81,  80,  79,  77,  74,  72,  71,  68,
			67,  55,  49,  48,  47,  34,  26, -1
		},
		(const int16_t[]) { /* 13 */
			192, 191, 189, 188, 187, 185, 184, 183, 181, 179,
			177, 175, 172, 169, 167, 166, 163, 161, 160, 159,
			157, 155, 153, 150, 148, 145, 144, 142, 141, 139,
			137, 133, 132, 131, 130, 128, 121, 120, 113, 112,
			107, 101, 100, 99,  94,  91,  89,  83,  79,  63,
			61,  59,  58,  55,  52,  35,  24,  22,  19,  16, -1
		},
		(const int16_t[]) { /* 14 */
			191, 189, 188, 186, 185, 184, 182, 181, 180, 177,
			175, 173, 172, 169, 168, 167, 161, 160, 157, 153,
			150, 148, 147, 145, 139, 137, 133, 128, 118, 117,
			114, 113, 112, 97,  94,  91,  89,  88,  83,  78,
			76,  66,  65,  62,  61,  60,  52,  42,  40,  35,
			28,  13,  9,   6,   5, -1
		},
		(const int16_t[]) { /* 15 */
			187, 141, 101, 99, 64, 63, 59, 24, -1
		},
		(const int16_t[]) { /* 16 */
			79, 16, -1
		},
		(const int16_t[]) { /* 17 */
			192, 191, 189, 188, 185, 184, 183, 182, 181, 180,
			179, 177, 176, 175, 173, 172, 169, 168, 167, 166,
			163, 161, 160, 159, 157, 155, 153, 150, 148, 147,
			145, 144, 142, 139, 137, 133, 132, 131, 130, 128,
			120, 118, 117, 114, 113, 112, 107, 104, 101, 100,
			97,  94,  91,  88,  78,  76,  65,  63,  62,  61,
			60,  55,  52,  42,  40,  35,  28,  24,  20,  19,
			13,  9, -1
		},
		(const int16_t[]) { /* 18 */
			185, 119, 65, 56, 47, 20, 7, -1
		},
		(const int16_t[]) { /* 19 */
			185, 151, 147, 123, 119, 98, 56, 47, -1
		},
		(const int16_t[]) { /* 20 */
			168, 151, 134, 119, 57, 51, 46, 35, -1
		},
		(const int16_t[]) { /* 21 */
			189, 183, 173, 169, 167, 164, 138, 137, 132, 112,
			109, 100, 96,  78,  77,  67,  52, -1
		},
		(const int16_t[]) { /* 22 */
			191, 189, 188, 184, 181, 180, 177, 175, 172, 167,
			160, 159, 155, 153, 150, 148, 145, 138, 131, 124,
			113, 112, 109, 107, 102, 96,  91,  77,  76,  61,
			52,  42, -1
		},
		(const int16_t[]) { /* 23 */
			192, 189, 167, 166, 138, 100, 55, 52, -1
		},
		(const int16_t[]) { /* 24 */
			191, 184, 183, 181, 180, 177, 175, 173, 172, 169,
			164, 160, 159, 155, 150, 148, 145, 138, 137, 132,
			131, 124, 113, 109, 107, 102, 96, 91, 78, 77,
			76,  67,  61,  42, -1
		},
		(const int16_t[]) { /* 25 */
			186, 179, 168, 163, 154, 147, 133, 130, 128, 121,
			99,  95,  89,  83,  82,  65,  59,  43,  40,  22, -1
		},
		(const int16_t[]) { /* 26 */
			186, 179, 168, 167, 154, 147, 141, 133, 130, 128,
			121, 120, 118, 99,  94,  89,  83,  65,  60,  56,
			40, 25, -1
		},
		(const int16_t[]) { /* 27 */
			190, 180, 177, 176, 175, 173, 171, 169, 164, 148,
			140, 126, 124, 118, 111, 105, 103, 84,  74,  67,
			49,  44,  38, -1
		},
		(const int16_t[]) { /* 28 */
			199, 197, 194, 192, 191, 190, 189, 188, 187, 185,
			184, 182, 181, 180, 178, 176, 174, 173, 172, 171,
			170, 167, 166, 165, 161, 160, 159, 157, 154, 153,
			151, 150, 146, 145, 144, 143, 141, 138, 137, 136,
			135, 134, 133, 132, 131, 128, 127, 126, 123, 120,
			118, 117, 116, 115, 114, 113, 112, 111, 110, 109,
			108, 107, 104, 102, 100, 98,  97,  96,  94,  93,
			91,  90,  87,  85,  84,  81,  78,  77,  74,  69,
			66,  64,  63,  62,  61,  60,  58,  57,  56,  55,
			51,  50,  47,  46,  45,  42,  36,  32,  29,  25, -1
			},
		(const int16_t[]) { /* 29 */
			191, 184, 183, 182, 180, 177, 175, 173, 169, 164,
			157, 155, 154, 148, 143, 141, 135, 124, 123, 121,
			118, 117, 114, 102, 97,  89,  88,  76,  60,  59,
			56,  47,  40,  36,  28,  13,  9, -1
		},
		(const int16_t[]) { /* 30 */
			183, 175, 173, 169, 164, 155, 137, 132, 131, 124,
			78,  76,  67,  61,  42,  28, -1
				},
		(const int16_t[]) { /* 31 */
			199, 192, 191, 184, 182, 180, 177, 176, 172, 170,
			167, 166, 159, 154, 148, 143, 135, 133, 128, 127,
			117, 116, 114, 111, 108, 107, 102, 97,  91,  90,
			75,  63,  55,  47,  44,  41,  33,  15,  8, -1
		},
		(const int16_t[]) { /* 32 */
			199, 198, 194, 193, 192, 191, 190, 188, 187, 186,
			185, 182, 181, 180, 179, 178, 176, 168, 167, 165,
			163, 162, 161, 157, 153, 151, 150, 149, 147, 146,
			145, 144, 143, 142, 141, 140, 139, 135, 134, 130,
			129, 127, 126, 123, 122, 121, 119, 118, 117, 115,
			109, 105, 104, 102, 101, 99,  98,  97,  95,  94,
			90,  89,  87,  86,  85,  83,  82,  81,  80,  79,
			71,  68,  66,  65,  64,  62,  60,  59,  58,  57,
			56,  53,  51,  49,  46,  44,  43,  40,  39,  32,
			30,  29,  14, -1
		},
		(const int16_t[]) { /* 33 */
			198, 197, 196, 194, 193, 191, 190, 188, 186, 185,
			183, 182, 181, 179, 178, 173, 169, 168, 167, 164,
			163, 162, 161, 153, 151, 150, 149, 148, 147, 145,
			144, 143, 142, 140, 139, 137, 135, 134, 132, 130,
			129, 123, 122, 121, 117, 114, 109, 108, 107, 105,
			104, 102, 101, 99,  98,  97,  95,  94,  91,  90,
			89,  86,  84,  83,  82,  81,  80,  79,  78,  75,
			74,  71,  68,  67,  66,  65,  62,  59,  57,  53,
			51,  50,  49,  46,  43,  41,  40,  39,  32,  29, -1
		},
		(const int16_t[]) { /* 34 */
			199, 192, 190, 187, 182, 178, 176, 170, 166, 161,
			160, 154, 150, 145, 143, 141, 138, 135, 133, 128,
			126, 123, 117, 116, 114, 111, 108, 97,  90,  81,
			75,  63,  62,  47,  41,  32,  25, -1
		},
		(const int16_t[]) { /* 35 */
			194, 192, 190, 189, 187, 185, 183, 181, 177, 176,
			173, 172, 171, 169, 165, 164, 161, 160, 159, 157,
			150, 146, 143, 137, 135, 132, 128, 127, 126, 123,
			118, 117, 114, 111, 109, 108, 97,  94,  93,  87,
			85,  78,  67,  60,  56,  55,  52,  47,  44,  37,
			25,  18, -1
		},
		(const int16_t[]) { /* 36 */
			194, 191, 190, 185, 184, 183, 181, 180, 177, 176,
			174, 173, 172, 169, 165, 164, 159, 157, 149, 148,
			146, 144, 142, 141, 139, 138, 137, 136, 132, 127,
			126, 122, 120, 118, 116, 115, 113, 112, 111, 110,
			107, 105, 102, 100, 96,  94,  91,  87,  86,  85,
			84,  78,  77,  74,  69,  67,  64,  63,  60,  58,
			56,  55,  50,  49,  45,  36,  30,  11,  4,   3,
			2, -1
		},
	},
	.xin = 0x3F,
	.xout = ((1ull << 34 | 1ull << 35 | 1ull << 36) ^ 0x1FFFFFFFFFull) |
		  1ull << (0 + PLM_S_MAX) | 1ull << (1 + PLM_S_MAX) |
		  1ull << (2 + PLM_S_MAX),
	.in_nb = 28,
	.out_nb = 37,
	.na_nb = 6,
	.na_bits = { 31, 32, 33, 34, 35, 36 }
};
