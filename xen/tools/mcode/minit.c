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
	.xin = 0,
	.xout = ((1ull << 31 | 1ull << 32 | 1ull << 33) ^ 0x1FFFFFFFFFull) |
		  1ull << (3 + PLM_S_MAX) | 1ull << (4 + PLM_S_MAX) |
		  1ull << (5 + PLM_S_MAX),
	.in_nb = 28,
	.out_nb = 37,
	.na_nb = 6,
	.na_bits = { 31, 32, 33, 34, 35, 36 }
};

const struct plm_desc plm_desc_f11_cs0 = {
	.p = {
		"11x00x0001010xxx1xxxx", /* 0 */
		"11x00x0001101xxx1xxxx", /* 1 */
		"11x00x0101111xx10x000", /* 2 */
		"11x00x1001000xx000xxx", /* 3 */
		"11x00x0010011xx000xxx", /* 4 */
		"11x00x1x00111xxx00xxx", /* 5 */
		"11x00x0100100xx000xxx", /* 6 */
		"11x00x1x10010xx000xxx", /* 7 */
		"11x00x1x10000xx000xxx", /* 8 */
		"11x00x1x10011xxx01xxx", /* 9 */
		"11x00x0110xxxxxx1xxxx", /* 10 */
		"11x00x0110xxxxxx0xxxx", /* 11 */
		"11x00xxxxxxxxxxxxxxxx", /* 12 */
		"010110111011xxxxxxxxx", /* 13 */
		"010110111010xxxxxxxxx", /* 14 */
		"010110111001xxxxxxxxx", /* 15 */
		"010110111000xxxxxxxxx", /* 16 */
		"1011001110xxxxx000xxx", /* 17 */
		"0100101110xxxxx000xxx", /* 18 */
		"0111110001001xxxxxxxx", /* 19 */
		"0111110001000xxxxxxxx", /* 20 */
		"0111100000000101xxxxx", /* 21 */
		"011110000110100xxxxxx", /* 22 */
		"011110111111xxxxxxxxx", /* 23 */
		"0111110000xxxxxxxxxxx", /* 24 */
		"01111000001xxxxxxxxxx", /* 25 */
		"011110000001xxxxxxxxx", /* 26 */
		"0111100000001xxxxxxxx", /* 27 */
		"011110000000010000xxx", /* 28 */
		"000100000100xxxxxxxxx", /* 29 */
		"000100000000001xxxxxx", /* 30 */
		"00111xxxxxxxxxx111xxx", /* 31 */
		"00111xxxxxxxxxx110xxx", /* 32 */
		"00111xxxxxxxxxx101xxx", /* 33 */
		"00111xxxxxxxxxx100xxx", /* 34 */
		"00111xxxxxxxxxx011xxx", /* 35 */
		"00111xxxxxxxxxx010xxx", /* 36 */
		"00111xxxxxxxxxx001xxx", /* 37 */
		"00111xxxxxxxxxx000xxx", /* 38 */
		"010xxx000110110xxxxxx", /* 39 */
		"01111x000110110xxxxxx", /* 40 */
		"01011x000110101xxxxxx", /* 41 */
		"10110x000110101000xxx", /* 42 */
		"01001x000110101000xxx", /* 43 */
		"010111000110100xxxxxx", /* 44 */
		"101101000110100000xxx", /* 45 */
		"10101xxxxxxxxxxxxxxxx", /* 46 */
		"010011000110100000xxx", /* 47 */
		"010x11000110111xxxxxx", /* 48 */
		"01001xxxxxxxxxxxxxxxx", /* 49 */
		"010xx0111100xxxxxxxxx", /* 50 */
		"010xx0000110111xxxxxx", /* 51 */
		"010xxx000110011xxxxxx", /* 52 */
		"010xxx000110010xxxxxx", /* 53 */
		"010xxx000110001xxxxxx", /* 54 */
		"010xxx000110000xxxxxx", /* 55 */
		"010xxx000101111xxxxxx", /* 56 */
		"010xxx000101110xxxxxx", /* 57 */
		"010xxx000101101xxxxxx", /* 58 */
		"010xxx000101100xxxxxx", /* 59 */
		"010xxx000101011xxxxxx", /* 60 */
		"010xxx000101010xxxxxx", /* 61 */
		"010xxx000101001xxxxxx", /* 62 */
		"010xxx000101000xxxxxx", /* 63 */
		"010xx0000000011xxxxxx", /* 64 */
		"01000xxxxxxxxxx000xxx", /* 65 */
		"010x0xxxx000xxxxxxxxx", /* 66 */
		"010xx0xxxxxxxxxxxxxxx", /* 67 */
		"010xx1110xxxxxxxxxxxx", /* 68 */
		"010xx0110xxxxxxxxxxxx", /* 69 */
		"010xxx101xxxxxxxxxxxx", /* 70 */
		"010xxx100xxxxxxxxxxxx", /* 71 */
		"010xxx011xxxxxxxxxxxx", /* 72 */
		"010xxx010xxxxxxxxxxxx", /* 73 */
		"010xxx001xxxxxxxxxxxx", /* 74 */
		"1101xx000110101xxxxxx", /* 75 */
		"1101x1110xxxxxxxxxxxx", /* 76 */
		"1101x0xxxxxxxxxxxxxxx", /* 77 */
		"11011xxxxxxxxxxxxxxxx", /* 78 */
		"11010xxxxxxxxxxxxxxxx", /* 79 */
		"00100x000110101xxxxxx", /* 80 */
		"0010001110xxxxxxxxxxx", /* 81 */
		"001001000110100xxxxxx", /* 82 */
		"00100x000101111xxxxxx", /* 83 */
		"00100x01xxxxxxxxxxxxx", /* 84 */
		"00100x000110110xxxxxx", /* 85 */
		"00100x000101000xxxxxx", /* 86 */
		"00100x000110111xxxxxx", /* 87 */
		"00100x001xxxxxxxxxxxx", /* 88 */
		"0x10xx000110110xxxxxx", /* 89 */
		"0x10xx000110101xxxxxx", /* 90 */
		"0x10xxxxxxxxxxxxxx11x", /* 91 */
		"0x10x1110xxxxxxxxxxxx", /* 92 */
		"0x10x0xxxxxxxxxxxxxxx", /* 93 */
		"00100xxxxxxxxxx100xxx", /* 94 */
		"00100xxxxxxxxxx010xxx", /* 95 */
		"00100xxxxxxxxxxxxxxxx", /* 96 */
		"0110xxxxxxxxxxx111xxx", /* 97 */
		"0110xxxxxxxxxxx110xxx", /* 98 */
		"0110xxxxxxxxxxx101xxx", /* 99 */
		"0110xxxxxxxxxxx100xxx", /* 100 */
		"0110xxxxxxxxxxx011xxx", /* 101 */
		"0110xxxxxxxxxxx010xxx", /* 102 */
		"0110xxxxxxxxxxx001xxx", /* 103 */
		"00110xxxxxxxxxxxxxxxx", /* 104 */
		"01110xxxxxxx11xxxxxxx", /* 105 */
		"0x1101110xxxxxxxxxxxx", /* 106 */
		"0x1100xxxxxxxxxxxxxxx", /* 107 */
		"01110xxxx111xxxxxxxxx", /* 108 */
		"01110xxxx110xxxxxxxxx", /* 109 */
		"01110xxxx101xxxxxxxxx", /* 110 */
		"01110xxxx100xxxxxxxxx", /* 111 */
		"01110xxxx011xxxxxxxxx", /* 112 */
		"01110xxxx010xxxxxxxxx", /* 113 */
		"01110xxxx001xxxxxxxxx", /* 114 */
		"10010xxxxxxxxxxxxxxxx", /* 115 */
		"10000xxxxxxxxxxxxxxxx", /* 116 */
		"011111111xxxxxxxxxxxx", /* 117 */
		"01xxx0111110xxxxxxxxx", /* 118 */
		"01xxx0111101xxxxxxxxx", /* 119 */
		"01xxx0000000000000xxx", /* 120 */
		"000000000000001001001", /* 121 */
		"000001000000001001001", /* 122 */
		"00000x000000001101001", /* 123 */
		"00000x000100001x01001", /* 124 */
		"00000x000x10001x01001", /* 125 */
		"00000x000xx1001x01001", /* 126 */
		"00000x001xxx001x01001", /* 127 */
		"00000x00xxxx101x01001", /* 128 */
		"00000x00xxxxx11x01001", /* 129 */
		"00000x01xxxxxx1x01001", /* 130 */
		"00000x1xxxxxxx1x01001", /* 131 */
		"00000xxxxxxxxx0x01001", /* 132 */
		"00000xxxxxxxxxxx01101", /* 133 */
		"00000xxxxxxxxxxx01x11", /* 134 */
		"00000xxxxxxxxxxx00xx1", /* 135 */
		"00000xxxxxxxxxxx1xxx1", /* 136 */
		"00000xxxxxxxxxxxxxxx0", /* 137 */
	},
	.s = {
		(const int16_t[]) { /* mc[0] - pl[1] */
			136, 135, 132, 130, 129, 127, 118, 114, 113, 112,
			111, 110, 104, 41,  40,  38,  37,  36,  29,  23,
			20,  19,  16,  15,  10,  9,   4,   1,   0,   -1
		},
		(const int16_t[]) { /* mc[1] - pl[3] */
			131, 120, 114, 113, 112, 111, 110, 102, 101, 100,
			99,  95,  94,  65,  49,  47,  46,  43,  35,  34,
			33,  23,  22,  21,  18,  13,  11,  2,   -1
		},
		(const int16_t[]) { /* mc[2] - pl[5] */
			136, 135, 134, 133, 131, 130, 129, 128, 127, 126,
			125, 124, 120, 118, 116, 115, 46,  38,  37,  36,
			22,  21,  20,  19,  13,  11,  8,   4,   2,   1,
			0,  -1
		},
		(const int16_t[]) { /* mc[3] - pl[7] */
			121, 109, 108, 98,  97,  47,  43,  41,  40,  32,
			31,  30,  29,  28,  27,  26,  25,  24,  18,  -1
		},
		(const int16_t[]) { /* mc[4] - pl[9] */
			136, 135, 131, 130, 129, 128, 126, 125, 124, 121,
			114, 113, 112, 109, 108, 104, 101, 98,  97,  96,
			95,  94,  88,  87,  86,  85,  84,  83,  82,  81,
			80,  79,  78,  77,  76,  75,  74,  73,  72,  71,
			70,  69,  68,  66,  50,  48,  46,  44,  40,  39,
			38,  35,  32,  31,  30,  27,  26,  25,  24,  23,
			22,  21,  16,  15,  14,  13,  11,  10,  7,   6,
			1,   -1
		},
		(const int16_t[]) { /* mc[5] - pl[11] */
			136, 131, 130, 127, 118, 114, 113, 112, 109, 108,
			104, 103, 102, 101, 98,  97,  96,  95,  94,  88,
			87,  86,  85,  84,  83,  82,  81,  80,  79,  78,
			77,  76,  75,  66,  50,  49,  48,  47,  46,  45,
			44,  43,  42,  40,  38,  37,  36,  35,  32,  31,
			28,  23,  22,  21,  20,  19,  18,  17,  15,  14,
			13,  7,   6,   4,   2,   -1
		},
		(const int16_t[]) { /* mc[6] - pl[13] */
			136, 135, 134, 133, 131, 130, 128, 126, 125, 124,
			118, 116, 115, 104, 85,  80,  79,  78,  77,  76,
			75,  48,  47,  46,  44,  43,  38,  30,  27,  26,
			25,  24,  22,  21,  20,  19,  18,  9,   8,   7,
			6,   4,   3,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* mc[7] - pl[15] */
			136, 131, 130, 129, 128, 127, 126, 125, 124, 121,
			117, 114, 113, 112, 109, 108, 101, 98,  97,  96,
			95,  94,  88,  87,  86,  85,  84,  83,  82,  81,
			80,  47,  46,  43,  40,  38,  35,  32,  31,  21,
			20,  19,  18,  13,  9,   7,   6,   3,   -1
		},
		(const int16_t[]) { /* mc[8] - pl[17] */
			136, 135, 134, 133, 132, 131, 130, 128, 126, 125,
			121, 120, 119, 118, 117, 116, 115, 112, 110, 109,
			108, 107, 106, 105, 103, 102, 101, 99,  98,  97,
			93,  92,  91,  90,  89,  77,  76,  75,  69,  68,
			67,  64,  51,  50,  47,  45,  44,  43,  42,  41,
			40,  39,  38,  37,  36,  35,  34,  33,  32,  31,
			30,  29,  28,  27,  26,  25,  24,  23,  20,  19,
			18,  17,  16,  15,  14,  13,  11,  10,  8,   7,
			6,   2,   0,   -1
		},
		(const int16_t[]) { /* mc[9] - pl[18] */
			136, 135, 132, 130, 129, 128, 127, 126, 124, 121,
			120, 119, 117, 113, 112, 109, 108, 101, 98,  97,
			95,  78,  74,  73,  72,  71,  70,  69,  68,  64,
			63,  62,  61,  60,  59,  58,  57,  56,  55,  54,
			53,  52,  51,  50,  48,  47,  46,  43,  42,  40,
			39,  38,  35,  32,  31,  22,  20,  19,  18,  16,
			14,  13,  7,   6,   3,   -1

		},
		(const int16_t[]) { /* mc[10] - pl[19] */
			136, 135, 134, 133, 132, 131, 129, 128, 127, 125,
			124, 120, 119, 118, 117, 116, 115, 104, 103, 102,
			88,  87,  86,  85,  79,  78,  77,  76,  75,  74,
			73,  72,  71,  69,  68,  63,  61,  60,  59,  56,
			53,  52,  50,  48,  47,  46,  45,  44,  43,  37,
			36,  30,  28,  27,  23,  20,  18,  17,  16,  15,
			14,  13,  10,  8,   7,   6,   5,   3,   2,   0,
			-1
		},
		(const int16_t[]) { /* mc[11] - pl[20] */
			134, 133, 132, 130, 129, 127, 126, 125, 124, 121,
			120, 119, 118, 117, 114, 113, 112, 109, 108, 104,
			103, 102, 101, 98,  97,  84,  83,  82,  81,  80,
			79,  78,  77,  76,  75,  74,  71,  70,  69,  68,
			59,  56,  55,  53,  51,  48,  47,  46,  45,  43,
			40,  38,  37,  36,  35,  32,  31,  30,  28,  27,
			22,  18,  17,  15,  14,  13,  4,   3,   1,   0,
			-1
		},
		(const int16_t[]) { /* mc[12] - pl[21] */
			136, 135, 132, 131, 130, 128, 126, 125, 124, 120,
			119, 118, 117, 116, 115, 111, 110, 103, 102, 100,
			99,  74,  71,  70,  69,  64,  63,  61,  58,  55,
			54,  53,  52,  51,  50,  48,  47,  45,  44,  43,
			41,  38,  37,  36,  34,  33,  30,  29,  28,  27,
			22,  21,  20,  19,  18,  17,  16,  15,  11,  10,
			9,   8,   5,   4,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* mc[13] - pl[22] */
			132, 131, 129, 127, 121, 120, 119, 118, 117, 116,
			115, 114, 113, 112, 111, 110, 109, 108, 104, 103,
			102, 101, 100, 99,  98,  97,  96,  95,  94,  88,
			87,  86,  85,  84,  83,  82,  81,  80,  79,  78,
			77,  76,  75,  74,  73,  63,  62,  59,  55,  54,
			53,  52,  51,  48,  47,  46,  45,  43,  41,  40,
			37,  36,  35,  34,  33,  32,  31,  30,  29,  28,
			18,  17,  16,  15,  14,  10,  8,   7,   6,   5,
			3,   2,   -1
		},
		(const int16_t[]) { /* mc[14] - pl[23] */
			136, 135, 132, 130, 129, 128, 127, 126, 125, 124,
			121, 119, 118, 117, 114, 113, 112, 109, 108, 101,
			98,  97,  96,  95,  94,  88,  87,  86,  85,  84,
			83,  82,  81,  80,  73,  69,  68,  62,  61,  60,
			59,  58,  57,  55,  54,  53,  52,  47,  46,  43,
			40,  38,  35,  32,  31,  27,  23,  22,  20,  19,
			18,  10,  9,   4,   3,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* mc[15] - pl[24] */
			136, 135, 132, 131, 130, 129, 128, 127, 126, 125,
			124, 121, 120, 119, 117, 114, 113, 112, 111, 110,
			109, 108, 101, 100, 99,  98,  97,  96,  95,  94,
			88,  87,  86,  85,  84,  83,  82,  81,  80,  47,
			46,  43,  41,  40,  38,  35,  34,  33,  32,  31,
			29,  22,  21,  20,  19,  18,  14,  13,  9,   7,
			6,   4,   3,   1,   0,  -1
		},
		(const int16_t[]) { /* ma[0] - pl[0] */
			137, 136, 135, 134, 130, 129, 128, 126, 125, 124,
			122, 116, 115, 114, 113, 112, 111, 109, 108, 104,
			103, 102, 100, 99,  84,  83,  82,  81,  80,  74,
			73,  72,  71,  70,  69,  68,  65,  64,  63,  62,
			61,  60,  59,  58,  57,  56,  55,  54,  53,  52,
			51,  50,  49,  48,  44,  39,  38,  37,  36,  34,
			32,  31,  30,  27,  26,  25,  24,  22,  21,  20,
			19,  16,  15,  14,  10,  7,   6,   4,   3,   -1
		},
		(const int16_t[]) { /* ma[1] - pl[2] */
			137, 134, 133, 128, 126, 125, 124, 123, 122, 120,
			118, 116, 111, 110, 108, 104, 103, 102, 100, 99,
			98,  73,  72,  65,  56,  49,  44,  41,  36,  35,
			32,  30,  29,  28,  27,  26,  25,  24,  16,  15,
			14,  11,  9,   5,   3,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* ma[2] - pl[4] */
			136, 135, 134, 133, 131, 130, 128, 126, 125, 124,
			123, 122, 121, 118, 116, 115, 111, 110, 109, 99,
			98,  97,  96,  95,  94,  88,  87,  86,  85,  84,
			83,  82,  81,  80,  79,  78,  77,  76,  75,  73,
			72,  65,  56,  49,  45,  44,  42,  38,  37,  36,
			35,  34,  33,  30,  29,  27,  26,  25,  24,  22,
			20,  19,  17,  16,  15,  14,  13,  9,   8,   4,
			2,   1,   0,   -1
		},
		(const int16_t[]) { /* ma[3] - pl[6] */
			137, 136, 135, 134, 130, 128, 126, 125, 124, 122,
			121, 120, 116, 115, 114, 113, 111, 110, 109, 108,
			103, 102, 101, 100, 73,  72,  65,  56,  49,  44,
			41,  40,  38,  37,  30,  29,  28,  27,  26,  25,
			24,  23,  20,  19,  16,  15,  14,  9,   8,   7,
			6,   5,   3,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* ma[4] - pl[8] */
			137, 128, 126, 125, 124, 122, 121, 120, 116, 114,
			113, 111, 110, 109, 108, 104, 103, 102, 101, 100,
			99,  98,  97,  88,  87,  86,  85,  79,  78,  77,
			76,  75,  74,  73,  72,  71,  70,  69,  68,  65,
			64,  63,  62,  61,  60,  59,  58,  57,  56,  55,
			54,  53,  52,  51,  50,  49,  48,  46,  45,  42,
			39,  37,  30,  29,  28,  27,  26,  25,  24,  23,
			22,  21,  17,  16,  15,  11,  10,  7,   6,   4,
			3,   2,   -1
		},
		(const int16_t[]) { /* ma[5] - pl[10] */
			137, 134, 133, 131, 129, 127, 122, 116, 114, 113,
			111, 110, 109, 108, 104, 103, 102, 101, 100, 99,
			98,  97,  96,  95,  94,  88,  87,  85,  84,  83,
			82,  81,  80,  79,  78,  77,  76,  75,  74,  73,
			72,  71,  70,  69,  68,  65,  64,  63,  62,  61,
			60,  59,  58,  57,  56,  55,  54,  53,  52,  51,
			50,  49,  48,  46,  45,  44,  42,  41,  40,  39,
			37,  36,  35,  34,  33,  32,  31,  30,  27,  26,
			25,  24,  17,  16,  11,  10,  9,   8,   7,   6,
			5,   3,   1,   0,   -1
		},
		(const int16_t[]) { /* ma[6] - pl[12] */
			137, 134, 133, 131, 129, 128, 127, 126, 125, 124,
			122, 121, 120, 118, 116, 114, 113, 112, 104, 103,
			102, 100, 96,  95,  94,  88,  87,  86,  85,  84,
			83,  82,  81,  80,  79,  78,  77,  76,  75,  73,
			72,  65,  56,  49,  45,  42,  37,  30,  27,  26,
			25,  24,  17,  16,  15,  14,  13,  11,  10,  9,
			8,   7,   6,   5,   4,   3,   2,   -1
		},
		(const int16_t[]) { /* ma[7] - pl[14] */
			137, 136, 135, 134, 133, 131, 130, 129, 128, 127,
			126, 125, 124, 122, 121, 120, 118, 116, 115, 114,
			113, 112, 111, 110, 109, 108, 104, 103, 102, 101,
			100, 99,  98,  97,  96,  95,  94,  88,  87,  86,
			85,  84,  83,  82,  81,  80,  79,  78,  77,  76,
			75,  74,  73,  72,  71,  70,  69,  68,  65,  64,
			63,  62,  61,  60,  59,  58,  57,  56,  55,  54,
			53,  52,  51,  50,  49,  48,  46,  45,  44,  42,
			41,  40,  39,  38,  37,  36,  35,  34,  33,  32,
			31,  30,  29,  28,  27,  26,  25,  24,  23,  22,
			21,  20,  19,  17,  -1
		},
		(const int16_t[]) { /* ma[8] - pl[16] */
			122, 116, 114, 113, 104, 103, 102, 100, 96,  95,
			94,  88,  87,  86,  85,  84,  83,  82,  81,  80,
			79,  78,  77,  76,  75,  73,  72,  65,  56,  49,
			45,  42,  37,  30,  27,  26,  25,  24,  17,  12,
			11,  10,  9,   8,   7,   6,   5,   4,   3,   2,
			1,   0,   -1
		},
	},
	.xin = 0,
	.xout = 0x1FFFFFF,
	.in_nb = 21,
	.out_nb = 25,
	.na_nb = 9,
	.na_bits = { 16, 17, 18, 19, 20, 21, 22, 23, 24 }
};

const struct plm_desc plm_desc_f11_na_clr0 = {
	.p = {
		"1110000x00001xxxxxx",	/* 0 - na_clr[3] */
		"1110000100xxxxxxxxx",	/* 1 */
		"xxxx1x0000xxx000xxx",	/* 2 - na_clr[2] */
		"xxxxx01000xxx000xxx",	/* 3 */
		"xxxx01x000xxx000xxx",	/* 4 */
		"x111000110x0x000xxx",	/* 5 */
		"x11x0001100xx000xxx",	/* 6 */
		"x11x000110xx1000xxx",	/* 7 */
		"x11x000101xxx000xxx",	/* 8 */
		"x1101110xxxxx000xxx",	/* 9 */
		"x110111x00xxx000xxx",	/* 10 */
		"x110xxx000011000xxx",	/* 11 */
		"x00xxxxxxxxxx000xxx",	/* 12 */
		"xxxx1x0000xxxxxxxxx",	/* 13 - na_clr[1] */
		"xxxxx01000xxxxxxxxx",	/* 14 */
		"xxxx01x000xxxxxxxxx",	/* 15 */
		"1x11000110x0xxxxxxx",	/* 16 */
		"1x1x0001100xxxxxxxx",	/* 17 */
		"1x1x000110xx1xxxxxx",	/* 18 */
		"1x1x000101xxxxxxxxx",	/* 19 */
		"1x101110xxxxxxxxxxx",	/* 20 */
		"1x10111x00xxxxxxxxx",	/* 21 */
		"1x10xxx000011xxxxxx",	/* 22 */
		"xxxx1x0xxxxxxxxxxxx",	/* 23 - na_clr[0] */
		"xxxxx01xxxxxxxxxxxx",	/* 24 */
		"xxxx01xxxxxxxxxxxxx",	/* 25 */

	},
	.s = {
		(const int16_t[]) { /* na_clr[0] */
			25, 24, 23, -1
		},
		(const int16_t[]) { /* na_clr[1] */
			22, 21, 20, 19, 18, 17, 16, 15, 14, 13, -1
		},
		(const int16_t[]) { /* na_clr[2] */
			12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, -1
		},
		(const int16_t[]) { /* na_clr[3] */
			1, 0, -1
		},
	},
	.xin = 0,
	.xout = 0,
	.in_nb = 19,
	.out_nb = 4,
	.na_nb = 4,
	.na_bits = { 0, 1, 2, 3 }
};

const struct plm_desc plm_desc_f11_cs1 = {
	.p = {
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 0 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 1 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 2 */
		"x011111xxxxxxxxxx11xxxx", /* 3 */
		"x011111xxxxxxxxxx001111", /* 4 */
		"x0111110xxxxxxxxx000111", /* 5 */
		"x0111111xxxxxxxxx000111", /* 6 */
		"x011111xxxxxxxxxx10xxxx", /* 7 */
		"x011111xxxxxxxxxx01x111", /* 8 */
		"x011111xxxxxxxxxx0xxxx0", /* 9 */
		"x011111xxxxxxxxxx0xxx0x", /* 10 */
		"x011111xxxxxxxxxx0xx0xx", /* 11 */
		"x111011xxxxxxxxxxxxxxxx", /* 12 */
		"x10001000xx1011xxxxxxxx", /* 13 */
		"x10001001xx1011xxxxxxxx", /* 14 */
		"x10001010xx1011xxxxxxxx", /* 15 */
		"x10001011xx1011xxxxxxxx", /* 16 */
		"x111101xxxx1011xxxxxxxx", /* 17 */
		"x011110xxxx1110xxxxxxxx", /* 18 */
		"x1000000xxx1110xxxxxxxx", /* 19 */
		"x1000001xxx1110xxxxxxxx", /* 20 */
		"x000110x0xx1110xxxxxxxx", /* 21 */
		"x000110x1xx1110xxxxxxxx", /* 22 */
		"x000011xxxx1110xxxxxxxx", /* 23 */
		"x011110xxxx1100xxxxxxxx", /* 24 */
		"x100111xxxx1100xxxxxxxx", /* 25 */
		"x100011xxxx1100xxxxxxxx", /* 26 */
		"x000011xxxx1100xxxxxxxx", /* 27 */
		"x100111xxxx111xxxxxxxxx", /* 28 */
		"x1111010xxx1111xxxxxxxx", /* 29 */
		"x1111011xxx1111xxxxxxxx", /* 30 */
		"x000011xxxx1111xxxxxxxx", /* 31 */
		"x000011xxxx1000xxxxxxxx", /* 32 */
		"x011110xxxx0101xxxxxxxx", /* 33 */
		"x1111010xxx0101xxxxxxxx", /* 34 */
		"x1111011xxx0101xxxxxxxx", /* 35 */
		"x011110xxxx00011xxxxxxx", /* 36 */
		"x110101xxxx000111xxxxxx", /* 37 */
		"x110101xxxx000110xxxxxx", /* 38 */
		"x111101xxxx00011xxxxxxx", /* 39 */
		"x011110xxxx000100xxxxxx", /* 40 */
		"x100011xxxx000100xxxxxx", /* 41 */
		"x000011xxxx000100xxxxxx", /* 42 */
		"x011110xxxx000101xxxxxx", /* 43 */
		"x111101xxxx00010xxxxxxx", /* 44 */
		"x011110xxxx11x1xxxxxxxx", /* 45 */
		"x000110xxxx1101xxxxxxxx", /* 46 */
		"x000011xxxx1101xxxxxxxx", /* 47 */
		"x011110xxxx101xxxxxxxxx", /* 48 */
		"x111101xxxx1010xxxxxxxx", /* 49 */
		"x000011xxxx101xxxxxxxxx", /* 50 */
		"x000011xxxx000011xxxxxx", /* 51 */
		"x000011xxxx000010xxxxxx", /* 52 */
		"x000110xxxx000001xxxxxx", /* 53 */
		"x000011xxxx000001xxxxxx", /* 54 */
		"x000011xxxx00000000x010", /* 55 */
		"x000011xxxx00000000x001", /* 56 */
		"x000011xxxx000000000000", /* 57 */
		"x111111xxxxxxxxxxxxxxxx", /* 58 */
		"x0110010xxxxxxxxxxxxxxx", /* 59 */
		"x0110011xxxxxxxxxxxxxxx", /* 60 */
		"x111101xxxx1001xxxxxxxx", /* 61 */
		"x111101xxxx0100xxxxxxxx", /* 62 */
		"x111101xxxx0x1xxxxxxxxx", /* 63 */
		"x111001xxxx0x1xxxxxxxxx", /* 64 */
		"x111001xxxx01x0xxxxxxxx", /* 65 */
		"x111001xxxx0101xxxxxxxx", /* 66 */
		"x111001xxxx1111xxxxxxxx", /* 67 */
		"x111001xxxx1001xxxxxxxx", /* 68 */
		"x111001xxxx0001xxxxxxxx", /* 69 */
		"x000011xxxx0x1xxxxxxxxx", /* 70 */
		"x000011xxxx01x0xxxxxxxx", /* 71 */
		"x000011xxxx1001xxxxxxxx", /* 72 */
		"x000011xxxx0101xxxxxxxx", /* 73 */
		"x000011xxxx00011xxxxxxx", /* 74 */
		"x000011xxxx0001x1xxxxxx", /* 75 */
		"x110111xxxxx0xxxxxxxxxx", /* 76 */
		"x110111xxxx0xxxxxxxxxxx", /* 77 */
		"x110111xxxx11xxxxxxxxxx", /* 78 */
		"x101100xxxxxxxxxx111xxx", /* 79 */
		"x101100xxxxxxxxxx110xxx", /* 80 */
		"x101100xxxxxxxxxx101xxx", /* 81 */
		"x101100xxxxxxxxxx100xxx", /* 82 */
		"x101100xxxxxxxxxx011xxx", /* 83 */
		"x101100xxxxxxxxxx010xx0", /* 84 */
		"x101100xxxxxxxxxx010x0x", /* 85 */
		"x101100xxxxxxxxxx0100xx", /* 86 */
		"x101100xxxxxxxxxx010111", /* 87 */
		"x101100xxxxxxxxxx001xxx", /* 88 */
		"x101100xxxxxxxxxx000x0x", /* 89 */
		"x101100xxxxxxxxxx0000xx", /* 90 */
		"x101000xxxxxxxxxx111xxx", /* 91 */
		"x101000xxxxxxxxxx110xxx", /* 92 */
		"x101000xxxxxxxxxx101xxx", /* 93 */
		"x1011010xxxxxxxxx100xxx", /* 94 */
		"x1011011xxxxxxxxx100xxx", /* 95 */
		"x101000xxxxxxxxxx100xxx", /* 96 */
		"x101000xxxxxxxxxx011xxx", /* 97 */
		"x1010110xxxxxxxxxxxxxxx", /* 98 */
		"x1010111xxxxxxxxxxxxxxx", /* 99 */
		"x101000xxxxxxxxxx010xx0", /* 100 */
		"x101000xxxxxxxxxx010x0x", /* 101 */
		"x101000xxxxxxxxxx0100xx", /* 102 */
		"x101000xxxxxxxxxx010111", /* 103 */
		"x1010100xxxxxxxxxxxxxxx", /* 104 */
		"x1010101xxxxxxxxxxxxxxx", /* 105 */
		"x101000xxxxxxxxxx001xxx", /* 106 */
		"x1010010xxxxxxxxxxxxxxx", /* 107 */
		"x1010011xxxxxxxxxxxxxxx", /* 108 */
		"x101000xxxxxxxxxx000x0x", /* 109 */
		"x101000xxxxxxxxxx0000xx", /* 110 */
		"x101x00xxxxxxxxxx00011x", /* 111 */
		"x010101x0xxxxxxxxxxxxxx", /* 112 */
		"x010101x1xxxxxxxxxxxxxx", /* 113 */
		"x010110xxxx101xxxxxxxxx", /* 114 */
		"x010110xxxx00001xxxxxxx", /* 115 */
		"x010111x0xxxxxxxxxxxxxx", /* 116 */
		"x010111x1xxxxxxxxxxxxxx", /* 117 */
		"x010110xxxx1110xxxxxxxx", /* 118 */
		"x010110xxxx1101xxxxxxxx", /* 119 */
		"x010110xxxx000001xxxxxx", /* 120 */
		"x010x00xxxxxxxxxx111xxx", /* 121 */
		"x010x00xxxxxxxxxx110xxx", /* 122 */
		"x010x00xxxxxxxxxx101xxx", /* 123 */
		"x000100x0xxxxxxxx100xxx", /* 124 */
		"x000100x1xxxxxxxx100xxx", /* 125 */
		"x010x00xxxxxxxxxx100xxx", /* 126 */
		"x010x00xxxxxxxxxx011xxx", /* 127 */
		"x010010x0xxxxxxxxxxxxxx", /* 128 */
		"x010010x1xxxxxxxxxxxxxx", /* 129 */
		"x010x00xxxxxxxxxx010xx0", /* 130 */
		"x010x00xxxxxxxxxx010x0x", /* 131 */
		"x010x00xxxxxxxxxx0100xx", /* 132 */
		"x010100xxxxxxxxxx010111", /* 133 */
		"x010000xxxxxxxxxx010111", /* 134 */
		"x010x00xxxxxxxxxx001xxx", /* 135 */
		"x010100xxxxxxxxxx000xxx", /* 136 */
		"x010000xxxxxxxxxx000xxx", /* 137 */
	},
	.s = {
		(const int16_t[]) { /* mc[0] - pl[1] */
			137, 135, 132, 131, 130, 126, 125, 124, 120, 119,
			118, 117, 116, 115, 114, 113, 112, 110, 109, 106,
			102, 101, 100, 96,  95,  94,  90,  89,  88,  86,
			85,  84,  82,  63,  62,  61,  60,  56,  55,  52,
			50,  44,  42,  41,  39,  38,  37,  36,  35,  34,
			33,  32,  29,  28,  27,  26,  24,  22,  21,  20,
			19,  18,  11,  10,   9,   8,   7,   6,   5,   3,
			-1
		},
		(const int16_t[]) { /* mc[1] - pl[3] */
			136, 134, 133, 129, 128, 127, 123, 103, 99,  98,
			97,  93,  87,  83,  81,  78,  67,  66,  60,  59,
			58,  48,  46,  33,  30,  25,  19,  18,  17,  16,
			15,  14,  13,  -1
		},
		(const int16_t[]) { /* mc[2] - pl[5] */
			135, 132, 131, 130, 126, 125, 124, 120, 119, 118,
			115, 114, 111, 106, 102, 101, 100, 96,  95,  94,
			88,  86,  85,  84,  82,  78,  77,  76,  69,  68,
			67,  66,  65,  64,  63,  62,  61,  60,  59,  58,
			49,  48,  46,  45,  44,  43,  42,  40,  39,  36,
			33,  30,  29,  27,  26,  25,  24,  22,  21,  20,
			19,  18,  17,  16,  15,  14,  13,  11,  10,  9,
			8,   7,   6,   5,   3,   -1
		},
		(const int16_t[]) { /* mc[3] - pl[7] */
			122, 121, 92, 91, 80, 79, 60, 36, 33, 18, -1
		},
		(const int16_t[]) { /* mc[4] - pl[9] */
			136, 134, 133, 129, 128, 127, 122, 121, 120, 119,
			118, 117, 116, 115, 114, 113, 112, 111, 105, 104,
			103, 99,  98,  97,  92,  91,  87,  83,  80,  79,
			78,  75,  74,  73,  72,  71,  70,  69,  68,  67,
			66,  65,  64,  63,  62,  61,  60,  59,  58,  57,
			56,  55,  52,  51,  48,  46,  44,  41,  39,  38,
			37,  36,  31,  29,  26,  25,  24,  23,  21,  20,
			17,  14,  13,  12,   6,   5,  -1
		},
		(const int16_t[]) { /* mc[5] - pl[11] */
			137, 135, 134, 133, 132, 131, 130, 129, 128, 127,
			126, 122, 121, 120, 119, 118, 117, 116, 115, 114,
			113, 112, 111, 110, 109, 108, 107, 106, 105, 104,
			103, 102, 101, 100, 99,  98,  97,  96,  92,  91,
			90,  89,  88,  87,  86,  85,  84,  83,  82,  80,
			79,  69,  68,  67,  66,  65,  64,  60,  59,  56,
			55,  51,  42,  33,  30,  27,  24,  22,  18,  17,
			16,  15,  12,  6,   5, -1
		},
		(const int16_t[]) { /* mc[6] - pl[13] */
			129, 128, 117, 116, 113, 112, 111, 105, 104, 99,
			98,  78,  77,  76,  75,  74,  73,  72,  71,  70,
			69,  68,  67,  66,  65,  64,  63,  62,  61,  57,
			56,  53,  52,  49,  48,  46,  45,  43,  42,  40,
			38,  37,  36,  33,  31,  30,  27,  26,  25,  24,
			23,  22,  21,  20,  19,  18,  16,  15,  12,  6,
			5,   -1
		},
		(const int16_t[]) { /* mc[7] - pl[15] */
			134, 133, 129, 128, 127, 122, 121, 120, 119, 118,
			115, 114, 113, 112, 111, 103, 99,  98,  97,  92,
			91,  87,  83,  80,  79,  72,  71,  70,  69,  68,
			67,  66,  65,  64,  60,  59,  58,  55,  53,  51,
			33,  18,  12,  6,   5,   -1
		},
		(const int16_t[]) { /* mc[8] - pl[17] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 124, 123, 122, 121, 120, 119, 118,
			117, 116, 115, 114, 113, 112, 111, 110, 109, 108,
			107, 106, 105, 104, 103, 102, 101, 100, 99,  98,
			97,  96,  95,  94,  93,  92,  91,  90,  89,  88,
			87,  86,  85,  84,  83,  82,  81,  80,  79,  78,
			77,  76,  75,  74,  73,  72,  71,  70,  69,  68,
			65,  64,  63,  62,  61,  60,  59,  58,  57,  56,
			55,  53,  52,  51,  50,  49,  48,  46,  45,  44,
			43,  42,  41,  40,  39,  38,  37,  36,  35,  34,
			33,  32,  31,  30,  29,  28,  27,  26,  25,  24,
			23,  22,  21,  20,  19,  18,  17,  16,  15,  14,
			13,  11,  10,  9,   8,   7,   6,   5,   3,   -1
		},
		(const int16_t[]) { /* mc[9] - pl[18] */
			134, 133, 128, 127, 124, 122, 121, 120, 119, 118,
			115, 114, 113, 112, 103, 99,  98,  97,  95,  94,
			92,  91,  90,  89,  87,  83,  80,  79,  69,  68,
			65,  64,  63,  62,  61,  60,  58,  56,  55,  53,
			51,  36,  35,  34,  33,  28,  24,  22,  21,  18,
			17,  8,   3,   -1
		},
		(const int16_t[]) { /* mc[10] - pl[19] */
			137, 136, 135, 133, 132, 131, 130, 129, 126, 117,
			116, 115, 114, 113, 112, 111, 110, 109, 108, 107,
			106, 105, 104, 102, 101, 100, 98,  96,  94,  90,
			89,  88,  87,  86,  85,  84,  82,  78,  77,  76,
			75,  74,  73,  72,  71,  70,  63,  62,  61,  60,
			59,  58,  57,  56,  55,  53,  52,  51,  50,  49,
			48,  46,  45,  44,  43,  42,  41,  40,  39,  38,
			37,  36,  35,  34,  33,  32,  31,  30,  29,  28,
			27,  26,  25,  24,  23,  22,  21,  20,  19,  18,
			17,  16,  15,  14,  13,  12,  6,   -1
		},
		(const int16_t[]) { /* mc[11] - pl[20] */
			137, 136, 135, 134, 132, 131, 130, 129, 128, 127,
			126, 122, 121, 120, 119, 118, 117, 116, 113, 112,
			111, 110, 109, 108, 107, 106, 105, 104, 103, 102,
			101, 100, 99,  97,  96,  92,  91,  90,  89,  88,
			86,  85,  84,  83,  82,  80,  79,  78,  77,  76,
			75,  74,  73,  72,  71,  70,  63,  62,  61,  60,
			59,  58,  57,  56,  55,  53,  52,  51,  50,  48,
			46,  45,  43,  42,  38,  36,  35,  34,  33,  32,
			31,  28,  27,  25,  24,  23,  22,  21,  20,  19,
			18,  17,  14,  13,  12,  6,   5,  -1
		},
		(const int16_t[]) { /* mc[12] - pl[21] */
			137, 136, 135, 132, 131, 130, 129, 128, 126, 125,
			124, 123, 111, 106, 102, 101, 100, 99,  98,  96,
			95,  94,  93,  88,  86,  85,  84,  82,  81,  69,
			68,  65,  64,  56,  55,  53,  51,  49,  44,  42,
			41,  40,  39,  38,  37,  36,  33,  30,  29,  27,
			26,  24,  22,  21,  18,  17,  16,  15,  11,  10,
			9,   8,   7,   6,   5,   3,   -1
		},
		(const int16_t[]) { /* mc[13] - pl[22] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 124, 123, 122, 121, 120, 119, 118,
			117, 116, 115, 114, 113, 112, 110, 109, 108, 107,
			106, 105, 104, 103, 102, 101, 100, 99,  98,  97,
			96,  95,  94,  93,  92,  91,  90,  89,  88,  87,
			86,  85,  84,  83,  82,  81,  80,  79,  78,  75,
			74,  73,  72,  71,  70,  67,  66,  63,  62,  61,
			60,  59,  58,  57,  52,  50,  49,  48,  46,  44,
			42,  41,  40,  39,  36,  35,  34,  33,  32,  31,
			30,  29,  28,  27,  26,  25,  23,  20,  19,  18,
			16,  15,  14,  13,  12,  11,  10,  9,   8,   7,
			6,  5,  3, -1
		},
		(const int16_t[]) { /* mc[14] - pl[23] */
			134, 133, 127, 122, 121, 120, 119, 118, 115, 114,
			113, 112, 111, 103, 97,  92,  91,  90,  89,  87,
			83,  80,  79,  69,  68,  65,  64,  63,  62,  61,
			60,  58,  56,  55,  53,  51,  44,  42,  39,  36,
			35,  34,  33,  29,  28,  27,  24,  22,  21,  18,
			12,  -1
		},
		(const int16_t[]) { /* mc[15] - pl[24] */
			134, 133, 129, 128, 127, 125, 124, 123, 122, 121,
			120, 119, 118, 115, 114, 113, 112, 111, 103, 99,
			98,  97,  95,  94,  93,  92,  91,  90,  89,  87,
			83,  81,  80,  79,  69,  68,  67,  66,  65,  64,
			63,  62,  61,  60,  58,  56,  55,  53,  51,  36,
			35,  34,  33,  28,  24,  22,  21,  18,  17,  12,
			11,  10,  9,   8,   7,   6,   5,   3,   -1
		},
		(const int16_t[]) { /* ma[0] - pl[0] */
			137, 135, 134, 132, 131, 130, 129, 128, 127, 126,
			124, 122, 121, 117, 106, 99,  98,  95,  93,  90,
			89,  86,  85,  84,  83,  80,  79,  72,  71,  70,
			67,  66,  57,  54,  52,  50,  47,  46,  41,  40,
			39,  35,  32,  29,  26,  22,  21,  20,  17,  16,
			12,  11,  10,  9,   8,   7,   6,   5,   4,   3,
			-1
		},
		(const int16_t[]) { /* ma[1] - pl[2] */
			134, 133, 126, 124, 123, 121, 115, 114, 112, 111,
			110, 109, 106, 105, 103, 99,  98,  97,  96,  93,
			92,  88,  87,  81,  79,  75,  74,  73,  72,  71,
			70,  69,  68,  65,  64,  63,  62,  61,  59,  57,
			54,  53,  52,  51,  49,  47,  42,  40,  39,  38,
			37,  35,  34,  31,  27,  25,  24,  22,  21,  20,
			19,  16,  15,  13,  12,  -1
		},
		(const int16_t[]) { /* ma[2] - pl[4] */
			134, 133, 132, 131, 130, 127, 125, 121, 116, 111,
			110, 109, 108, 103, 102, 101, 100, 93,  92,  91,
			87,  86,  85,  84,  79,  78,  72,  71,  70,  68,
			67,  66,  65,  64,  63,  62,  61,  57,  56,  55,
			54,  53,  50,  47,  46,  44,  42,  41,  38,  37,
			32,  31,  30,  29,  27,  26,  25,  24,  23,  20,
			19,  17,  16,  15,  13,  12,  -1
		},
		(const int16_t[]) { /* ma[3] - pl[6] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 124, 123, 122, 120, 119, 118, 117,
			115, 114, 113, 111, 108, 106, 104, 99,  98,  93,
			92,  91,  90,  89,  81,  80,  75,  74,  73,  72,
			71,  70,  69,  68,  65,  64,  58,  54,  53,  52,
			51,  48,  47,  42,  39,  38,  37,  32,  29,  27,
			26,  25,  24,  23,  15,  14,  12,  -1
		},
		(const int16_t[]) { /* ma[4] - pl[8] */
			137, 134, 133, 127, 126, 125, 124, 123, 122, 121,
			117, 116, 112, 110, 109, 107, 103, 102, 101, 100,
			97,  96,  95,  94,  87,  86,  85,  84,  83,  82,
			75,  74,  73,  72,  71,  70,  69,  67,  66,  60,
			59,  53,  51,  50,  49,  42,  41,  40,  39,  38,
			37,  35,  34,  29,  27,  26,  25,  20,  16,  14,
			13,  -1
		},
		(const int16_t[]) { /* ma[5] - pl[10] */
			137, 135, 134, 133, 132, 131, 130, 129, 128, 127,
			126, 125, 124, 123, 122, 121, 120, 119, 118, 117,
			116, 115, 114, 112, 108, 107, 106, 105, 104, 99,
			98,  87,  86,  85,  84,  83,  82,  81,  80,  79,
			78,  77,  76,  63,  62,  61,  54,  53,  52,  51,
			50,  49,  48,  47,  46,  45,  43,  42,  39,  38,
			37,  35,  34,  32,  31,  30,  27,  26,  25,  24,
			23,  22,  21,  16,  15,  14,  13,  -1
		},
		(const int16_t[]) { /* ma[6] - pl[12] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 124, 123, 122, 121, 120, 119, 118,
			117, 116, 115, 114, 113, 112, 110, 109, 108, 107,
			106, 105, 104, 103, 102, 101, 100, 99,  98,  97,
			96,  95,  94,  93,  92,  91,  90,  89,  88,  69,
			63,  62,  61,  54,  53,  52,  51,  50,  49,  48,
			47,  46,  44,  41,  40,  38,  37,  26,  25,  24,
			23,  22,  21,  19,  17,  -1
		},
		(const int16_t[]) { /* ma[7] - pl[14] */
			137, 136, 135, 132, 131, 130, 129, 128, 126, 120,
			119, 118, 117, 115, 114, 113, 110, 109, 102, 101,
			100, 96,  63,  62,  61,  54,  53,  52,  51,  50,
			49,  48,  47,  46,  44,  42,  40,  39,  35,  34,
			32,  31,  30,  29,  28,  27,  20,  11,  10,  9,
			8,   7,   6,   5,   4,   3,   -1
		},
		(const int16_t[]) { /* ma[8] - pl[16] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 124, 123, 122, 121, 120, 119, 118,
			117, 116, 115, 114, 113, 112, 110, 109, 108, 107,
			106, 105, 104, 103, 102, 101, 100, 99,  98,  97,
			96,  95,  94,  93,  92,  91,  90,  89,  88,  87,
			86,  85,  84,  83,  82,  81,  80,  79,  78,  77,
			76,  75,  74,  73,  72,  71,  70,  69,  67,  66,
			63,  62,  61,  60,  59,  58,  57,  56,  55,  54,
			52,  47,  45,  43,  41,  40,  -1
		},
	},
	.xin = 0,
	.xout = 0x1FFFFFF,
	.in_nb = 23,
	.out_nb = 25,
	.na_nb = 9,
	.na_bits = { 16, 17, 18, 19, 20, 21, 22, 23, 24 }
};

const struct plm_desc plm_desc_f11_cs2 = {
	.p = {
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 0 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 1 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 2 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 3 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 4 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 5 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 6 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 7 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 8 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 9 */
		"xxxxxxxxxxxxxxxxxxxxxxx", /* 10 */
		"x10011100000000xxxxxxxx", /* 11 */
		"x110011xxxxx011xxxxxxxx", /* 12 */
		"x110011xxxx1001xxxxxxxx", /* 13 */
		"x110011xxxx0xx0xxxxxxxx", /* 14 */
		"x100111xxx1xxxxxxxxxxxx", /* 15 */
		"x100000xxxxxxxxxxxxxxxx", /* 16 */
		"x0100100xxxxxxxxxxxxxxx", /* 17 */
		"x0100101xxxxxxxxxxxxxxx", /* 18 */
		"x1100100xxxxxxxxxxxxxxx", /* 19 */
		"x1100101xxxxxxxxxxxxxxx", /* 20 */
		"x101011xxxxx011xxxxxxxx", /* 21 */
		"x101011xxxx0111xxxxxxxx", /* 22 */
		"x101011xxxx1001xxxxxxxx", /* 23 */
		"x101011xxxx0xx0xxxxxxxx", /* 24 */
		"x100011xxxx00011xxxxxxx", /* 25 */
		"x100011xxxx1xxxxxxxxxxx", /* 26 */
		"x100011xxxxx1xxxxxxxxxx", /* 27 */
		"x100011xxxxxx1xxxxxxxxx", /* 28 */
		"x100010xxxxxxxxxx11xxxx", /* 29 */
		"x100010xxxxxxxxxx101xxx", /* 30 */
		"x1000100xxxxxxxxx100xxx", /* 31 */
		"x1000101xxxxxxxxx100xxx", /* 32 */
		"x100010xxxxxxxxxx011xxx", /* 33 */
		"x1000100xxxxxxxxx010xx0", /* 34 */
		"x1000100xxxxxxxxx010x0x", /* 35 */
		"x1000100xxxxxxxxx0100xx", /* 36 */
		"x1000101xxxxxxxxx010xx0", /* 37 */
		"x1000101xxxxxxxxx010x0x", /* 38 */
		"x1000101xxxxxxxxx0100xx", /* 39 */
		"x100010xxxxxxxxxx010111", /* 40 */
		"x100010xxxxxxxxxx00xxxx", /* 41 */
		"x100111xxx01xxxxxxxxxxx", /* 42 */
		"x100111xxx0x1xxxxxxxxxx", /* 43 */
		"x100111xxx0xx1xxxxxxxxx", /* 44 */
		"x00xxxxxxx010000xxxxxxx", /* 45 */
		"x00xxxxxxx0x1000xxxxxxx", /* 46 */
		"x00xxxxxxx0xx100xxxxxxx", /* 47 */
		"x00xxxxxxx1xxx00xxxxxxx", /* 48 */
		"x00xxxxxxxxxxx10xxxxxxx", /* 49 */
		"x00xxxxxxxxxxxx1xxxxxxx", /* 50 */
		"x0111000xxxxxxxxxxxxxxx", /* 51 */
		"x0111001xxxxxxxxxxxxxxx", /* 52 */
		"x0111100xxxxxxxxxxxxxxx", /* 53 */
		"x0111101xxxxxxxxxxxxxxx", /* 54 */
		"x101000xx1x1001xxxxxxxx", /* 55 */
		"x101000xx1x0xx0xxxxxxxx", /* 56 */
		"x101000xx0x1001xxxxxxxx", /* 57 */
		"x101000xx0x0xx0xxxxxxxx", /* 58 */
		"x111011xx1xxxxxxxxxxxxx", /* 59 */
		"x111011xx0xxxxxxxxxxxxx", /* 60 */
		"x1010100xxxxxxxxxxxxxxx", /* 61 */
		"x1010101xxxxxxxxxxxxxxx", /* 62 */
		"x101000xxxx1011xxxxxxxx", /* 63 */
		"x011111xxxx0011xxxxxxxx", /* 64 */
		"x0111110xxx1001xxxxxxxx", /* 65 */
		"x0111111xxx1001xxxxxxxx", /* 66 */
		"x0111110xxx0010xxxxxxxx", /* 67 */
		"x0111111xxx0010xxxxxxxx", /* 68 */
		"x000111xxx000000xxxxxxx", /* 69 */
		"x0111110xxx01x0xxxxxxxx", /* 70 */
		"x000011xxx000000xxxxxxx", /* 71 */
		"x0111111xxx01x0xxxxxxxx", /* 72 */
		"x001100xxx000000xxxxxxx", /* 73 */
		"x000010xxx000000xxxxxxx", /* 74 */
		"x000100xxx000000xxxxxxx", /* 75 */
		"x1010010xxxxxxxxxxxxxxx", /* 76 */
		"x000000xxx000000xxxxxxx", /* 77 */
		"x1010011xxxxxxxxxxxxxxx", /* 78 */
		"x1100001xxx0011xxxxxxxx", /* 79 */
		"x1100000xxx001xxxxxxxxx", /* 80 */
		"x1100001xxx0010xxxxxxxx", /* 81 */
		"x1100000xxx1001xxxxxxxx", /* 82 */
		"x1100001xxx1001xxxxxxxx", /* 83 */
		"x011011xxxx1001xxxxxxxx", /* 84 */
		"x011011xxxx001xxxxxxxxx", /* 85 */
		"x011001xxxx1001xxxxxxxx", /* 86 */
		"x011001xxxx001xxxxxxxxx", /* 87 */
		"x0110000xxxxxxxxxxxxxxx", /* 88 */
		"x0110001xxxxxxxxxxxxxxx", /* 89 */
		"x010000xxxx1001xxxxxxxx", /* 90 */
		"x010000xxxx001xxxxxxxxx", /* 91 */
		"x1101100xxxxxxxxxxxxxxx", /* 92 */
		"x1101101xxxxxxxxxxxxxxx", /* 93 */
		"x1101010xxxxxxxxxxxxxxx", /* 94 */
		"x1101011xxxxxxxxxxxxxxx", /* 95 */
		"x011101x0xxxxx1xxxxxxxx", /* 96 */
		"x011101x0xxxxx011xxxxxx", /* 97 */
		"x011101x0xxxxx01011xxxx", /* 98 */
		"x011101x0xxxxx01010xxxx", /* 99 */
		"x011101x0xxxxx01001xxxx", /* 100 */
		"x011101x0xxxxx010001xxx", /* 101 */
		"x011101x0xxxxx01000x1xx", /* 102 */
		"x011101x0xxxxx01000xx1x", /* 103 */
		"x011101x0xxxxx01000xxx1", /* 104 */
		"x011101x0xxxxx010000000", /* 105 */
		"x011101xxxxxxx00xxxxxxx", /* 106 */
		"x011101x1xxxxxxxxxxxxxx", /* 107 */
		"x000101xxx000000xxxxxxx", /* 108 */
		"x101000xxxx0011xxxxxxxx", /* 109 */
		"x1001000xxxxxxxxxxxxxxx", /* 110 */
		"x1001001xxxxxxxxxxxxxxx", /* 111 */
		"x010000xxxx0111xxxxxxxx", /* 112 */
		"x111111xxxxxxxxxxxxxxxx", /* 113 */
		"x001001xxx000000xxxxxxx", /* 114 */
		"x111000xxxxxxxxxxxxxxx1", /* 115 */
		"x111000xxxxxxxxxxxxxxx0", /* 116 */
		"x001010xxx000000xxxxxx1", /* 117 */
		"x001010xxx000000xxxxxx0", /* 118 */
		"x110100xxxxxxxxxxxxxxx1", /* 119 */
		"x110100xxxxxxxxxxxxxxx0", /* 120 */
		"x101111xxxxxxxxxxxxxxx1", /* 121 */
		"x101111xxxxxxxxxxxxxxx0", /* 122 */
		"x001000xxx000000xxxxxxx", /* 123 */
		"x1110100xxxxxxxxxxxxxxx", /* 124 */
		"x1110101xxxxxxxxxxxxxxx", /* 125 */
		"x1011100xxxxxxxxxxxxxxx", /* 126 */
		"x1011101xxxxxxxxxxxxxxx", /* 127 */
		"x0101110xxxxxxxxxxxxxxx", /* 128 */
		"x0101111xxxxxxxxxxxxxxx", /* 129 */
		"x0101100xxxxxxxxxxxxxxx", /* 130 */
		"x0101101xxxxxxxxxxxxxxx", /* 131 */
		"x0101010xxxxxxxxxxxxxxx", /* 132 */
		"x0101011xxxxxxxxxxxxxxx", /* 133 */
		"x0101000xxxxxxxxxxxxxxx", /* 134 */
		"x0101001xxxxxxxxxxxxxxx", /* 135 */
		"x010000xxxx0110xxxxxxxx", /* 136 */
		"x010000xxxx0100xxxxxxxx", /* 137 */
	},
	.s = {
		(const int16_t[]) { /* mc[0] - pl[1] */
			137, 136, 126, 125, 124, 123, 122, 121, 110, 104,
			103, 102, 101, 99,  91,  90,  86,  79,  76,  74,
			73,  71,  69,  60,  58,  57,  28,  27,  26,  25,
			16, -1
		},
		(const int16_t[]) { /* mc[1] - pl[3] */
			137, 136, 135, 134, 133, 132, 129, 128, 122, 121,
			120, 116, 114, 107, 106, 105, 104, 103, 102, 101,
			100, 93,  91,  90,  89,  88,  83,  81,  80,  78,
			77,  76,  74,  71,  69,  63,  62,  61,  54,  52,
			50,  49,  48,  47,  46,  45,  40,  39,  38,  37,
			36,  35,  34,  33,  32,  31,  30,  28,  27,  26,
			25,  20,  19,  18,  17,  16, -1
		},
		(const int16_t[]) { /* mc[2] - pl[5] */
			136, 126, 125, 124, 123, 122, 121, 114, 112, 109,
			107, 106, 105, 104, 103, 102, 101, 100, 99,  98,
			97,  96,  91,  90,  89,  88,  85,  84,  81,  80,
			79,  78,  77,  76,  75,  74,  73,  72,  70,  68,
			67,  66,  65,  64,  63,  62,  61,  50,  49,  48,
			47,  46,  45,  28,  27,  26,  20,  19,  16,  15,
			13,  12,  11, -1
		},
		(const int16_t[]) { /* mc[3] - pl[7] */
			137, 136, 135, 134, 133, 132, 129, 128, 125, 124,
			123, 122, 121, 120, 119, 116, 115, 112, 110, 109,
			104, 103, 102, 101, 100, 99,  98,  97,  96,  93,
			92,  91,  90,  89,  88,  87,  83,  82,  79,  78,
			76,  75,  74,  73,  71,  69,  62,  61,  54,  53,
			52,  51,  44,  43,  42,  29,  24,  23,  22,  21,
			20,  19,  18,  17,  16,  14, -1
		},
		(const int16_t[]) { /* mc[4] - pl[9] */
			136, 126, 125, 124, 123, 115, 112, 110, 104, 103,
			102, 101, 99,  87,  85,  84,  83,  82,  76,  74,
			73,  71,  69,  60,  59,  58,  57,  56,  55,  32,
			31,  30,  25,  16,  14,  13,  12, -1
		},
		(const int16_t[]) { /* mc[5] - pl[11] */

			136, 125, 124, 123, 122, 120, 111, 104, 103, 102,
			101, 100, 95,  93,  87,  83,  82,  81,  80,  78,
			74,  72,  71,  70,  69,  68,  67,  66,  65,  64,
			59,  56,  55,  52,  32,  31,  30,  28,  27,  26,
			16,  14,  13,  12, -1
		},
		(const int16_t[]) { /* mc[6] - pl[13] */
			136, 126, 125, 124, 123, 122, 121, 115, 114, 112,
			109, 107, 106, 105, 95,  94,  83,  82,  81,  80,
			78,  77,  76,  75,  74,  73,  72,  70,  68,  67,
			66,  65,  64,  63,  60,  59,  58,  57,  56,  55,
			50,  49,  48,  47,  46,  45,  32,  31,  30,  28,
			27,  26,  15, -1
		},
		(const int16_t[]) { /* mc[7] - pl[15] */
			125, 124, 123, 122, 121, 120, 119, 111, 109, 104,
			103, 102, 101, 100, 99,  98,  97,  96,  93,  92,
			85,  84,  83,  82,  79,  78,  77,  76,  75,  74,
			73,  71,  69,  52,  51,  32,  31,  30,  28,  27,
			26,  25,  24,  23,  22,  21,  16,  11, -1
		},
		(const int16_t[]) { /* mc[8] - pl[17] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 122, 121, 120, 119, 118, 117, 116,
			115, 114, 112, 111, 110, 109, 108, 107, 106, 105,
			104, 103, 102, 101, 100, 99,  98,  97,  96,  95,
			94,  93,  92,  91,  90,  89,  88,  85,  84,  81,
			80,  78,  77,  76,  75,  74,  73,  72,  71,  70,
			69,  68,  67,  66,  65,  64,  63,  62,  61,  60,
			59,  58,  57,  56,  55,  54,  53,  52,  51,  50,
			49,  48,  47,  46,  45,  44,  43,  42,  40,  39,
			38,  37,  36,  35,  34,  33,  32,  31,  30,  29,
			28,  27,  26,  25,  24,  23,  22,  21,  20,  19,
			18,  17,  16,  15,  11, -1
		},
		(const int16_t[]) { /* mc[9] - pl[18] */
			136, 129, 128, 127, 126, 125, 124, 123, 120, 119,
			118, 117, 116, 115, 111, 109, 95,  94,  87,  86,
			83,  82,  76,  75,  74,  73,  72,  71,  70,  69,
			68,  67,  66,  65,  64,  62,  61,  60,  59,  58,
			57,  56,  55,  54,  53,  39,  38,  37,  36,  35,
			34,  32,  31,  25,  20,  19,  18,  17,  14,  13,
			12,  11, -1
		},
		(const int16_t[]) { /* mc[10] - pl[19] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 124, 123, 122, 121, 120, 119, 116,
			115, 114, 112, 111, 110, 109, 108, 107, 106, 105,
			104, 103, 102, 101, 100, 99,  98,  97,  96,  95,
			94,  93,  92,  91,  90,  89,  88,  87,  86,  85,
			84,  83,  82,  81,  79,  78,  77,  76,  68,  67,
			66,  65,  64,  63,  62,  61,  60,  59,  58,  57,
			56,  55,  54,  53,  50,  49,  48,  47,  46,  45,
			36,  35,  34,  31,  30,  28,  27,  26,  25,  24,
			23,  22,  21,  20,  19,  18,  17,  16,  15,  14,
			13,  12,  11, -1
		},
		(const int16_t[]) { /* mc[11] - pl[20] */
			137, 136, 135, 134, 133, 132, 131, 130, 127, 126,
			125, 124, 123, 118, 117, 116, 115, 114, 112, 111,
			110, 107, 106, 105, 104, 103, 102, 101, 100, 99,
			98,  97,  96,  91,  90,  89,  88,  85,  84,  83,
			82,  79,  78,  76,  75,  63,  62,  61,  59,  56,
			55,  54,  53,  50,  49,  48,  47,  46,  45,  32,
			30,  28,  27,  26,  25,  20,  19,  18,  17,  16,
			15,  11, -1
		},
		(const int16_t[]) { /* mc[12] - pl[21] */
			136, 133, 132, 125, 124, 120, 119, 118, 117, 116,
			115, 109, 104, 103, 102, 101, 100, 99,  98,  97,
			96,  93,  92,  87,  86,  85,  83,  82,  81,  80,
			79,  77,  75,  74,  73,  72,  71,  70,  69,  68,
			67,  66,  65,  64,  60,  59,  58,  57,  56,  55,
			54,  53,  52,  51,  44,  43,  42,  40,  39,  38,
			37,  36,  35,  34,  33,  32,  31,  30,  29,  25,
			24,  23,  22,  21,  14,  13,  12,  11, -1
		},
		(const int16_t[]) { /* mc[13] - pl[22] */
			137, 135, 134, 133, 132, 131, 130, 129, 128, 127,
			126, 123, 120, 119, 118, 117, 114, 112, 110, 109,
			107, 106, 105, 104, 103, 102, 101, 100, 99,  98,
			97,  96,  93,  92,  91,  90,  89,  88,  87,  86,
			81,  77,  76,  75,  74,  73,  72,  71,  70,  69,
			68,  67,  66,  65,  64,  63,  62,  61,  60,  58,
			57,  50,  49,  48,  47,  46,  45,  44,  43,  42,
			40,  39,  38,  37,  36,  35,  34,  33,  32,  31,
			30,  29,  28,  27,  26,  25,  24,  23,  22,  21,
			20,  19,  18,  17,  16,  14,  13,  12,  11, -1
		},
		(const int16_t[]) { /* mc[14] - pl[23] */
			136, 129, 128, 127, 126, 125, 124, 123, 122, 121,
			120, 119, 118, 117, 116, 115, 111, 108, 95,  94,
			87,  86,  85,  84,  83,  82,  79,  77,  75,  74,
			73,  72,  71,  70,  69,  68,  67,  66,  65,  64,
			62,  61,  60,  59,  58,  57,  56,  55,  54,  53,
			28,  27,  26,  25,  20,  19,  18,  17,  14,  13,
			12,  11, -1
		},
		(const int16_t[]) { /* mc[15] - pl[24] */
			136, 125, 124, 123, 122, 121, 95,  94,  87,  86,
			83,  82,  79,  77,  76,  72,  70,  68,  67,  66,
			65,  64,  62,  61,  59,  56,  55,  44,  43,  42,
			40,  39,  38,  37,  36,  35,  34,  33,  32,  31,
			30,  29,  28,  27,  26,  25,  20,  19,  18,  17,
			14,  13,  12,  11, -1
		},
		(const int16_t[]) { /* ma[0] - pl[0] */
			137, 136, 133, 132, 130, 129, 128, 125, 124, 123,
			118, 117, 116, 115, 114, 112, 111, 110, 109, 108,
			104, 103, 102, 101, 99,  97,  96,  91,  90,  87,
			86,  84,  83,  81,  80,  79,  78,  75,  73,  72,
			71,  67,  65,  64,  62,  61,  60,  59,  58,  57,
			56,  55,  54,  53,  44,  43,  42,  28,  27,  26,
			18,  14,  13,  12, -1
		},
		(const int16_t[]) { /* ma[1] - pl[2] */
			137, 136, 135, 132, 131, 130, 129, 128, 127, 125,
			124, 120, 118, 116, 112, 111, 107, 106, 105, 99,
			98,  95,  94,  92,  91,  90,  89,  87,  86,  85,
			83,  81,  75,  74,  73,  71,  70,  69,  68,  66,
			62,  60,  58,  57,  54,  50,  49,  48,  47,  46,
			45,  24,  23,  22,  21,  19,  18,  16,  15,  14,
			13,  12, -1
		},
		(const int16_t[]) { /* ma[2] - pl[4] */
			136, 134, 130, 128, 127, 125, 124, 123, 122, 121,
			119, 117, 115, 113, 112, 110, 109, 104, 103, 102,
			101, 100, 95,  94,  93,  91,  90,  89,  83,  82,
			81,  79,  77,  75,  72,  69,  63,  62,  53,  52,
			50,  49,  48,  47,  46,  45,  44,  43,  42,  41,
			40,  39,  38,  37,  36,  35,  34,  33,  32,  31,
			30,  29,  24,  23,  22,  21,  18,  17,  15,  14,
			13,  12, -1
		},
		(const int16_t[]) { /* ma[3] - pl[6] */
			137, 136, 135, 134, 131, 129, 128, 126, 120, 119,
			116, 115, 114, 111, 109, 108, 89,  87,  86,  81,
			80,  78,  76,  73,  72,  71,  70,  63,  61,  52,
			50,  49,  48,  47,  46,  45,  44,  43,  42,  41,
			40,  39,  38,  37,  36,  35,  34,  33,  32,  31,
			30,  29,  28,  27,  26,  24,  23,  22,  21,  20,
			19,  18,  17,  16,  15, -1
		},
		(const int16_t[]) { /* ma[4] - pl[8] */
			136, 135, 134, 130, 125, 124, 120, 119, 118, 117,
			113, 111, 110, 88,  82,  80,  79,  76,  75,  63,
			62,  61,  54,  53,  51,  50,  49,  48,  47,  46,
			45,  44,  43,  42,  41,  40,  39,  38,  37,  36,
			35,  34,  33,  32,  31,  30,  29,  28,  27,  26,
			24,  23,  22,  18,  17,  16, -1
		},
		(const int16_t[]) { /* ma[5] - pl[10] */
			137, 136, 135, 134, 133, 132, 125, 124, 120, 119,
			118, 117, 116, 115, 114, 113, 112, 91,  90,  89,
			88,  87,  86,  85,  84,  83,  76,  75,  74,  72,
			71,  70,  69,  68,  67,  66,  65,  64,  60,  59,
			58,  57,  56,  55,  50,  49,  48,  47,  46,  45,
			28,  27,  26,  21,  20,  19, -1
		},
		(const int16_t[]) { /* ma[6] - pl[12] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 124, 123, 122, 121, 91,  90,  89,
			88,  87,  86,  85,  84,  81,  80,  79,  78,  77,
			72,  71,  70,  69,  68,  67,  66,  65,  64,  63,
			62,  61,  60,  59,  58,  57,  56,  55,  54,  53,
			52,  51,  44,  43,  42,  41,  40,  39,  38,  37,
			36,  35,  34,  33,  32,  31,  30,  29,  18, -1
		},
		(const int16_t[]) { /* ma[7] - pl[14] */
			137, 125, 124, 91,  90,  89,  88,  87,  86,  85,
			84,  83,  82,  81,  80,  79,  78,  77,  76,  75,
			74,  73,  60,  59,  58,  57,  56,  55,  44,  43,
			42,  41,  40,  39,  38,  37,  36,  35,  34,  33,
			32,  31,  30,  29,  18, -1
		},
		(const int16_t[]) { /* ma[8] - pl[16] */
			137, 136, 135, 134, 133, 132, 131, 130, 129, 128,
			127, 126, 125, 124, 123, 122, 121, 120, 119, 118,
			117, 116, 115, 114, 112, 111, 110, 109, 108, 104,
			103, 102, 101, 100, 99,  98,  97,  96,  95,  94,
			93,  92,  91,  90,  60,  59,  58,  57,  56,  55,
			44,  43,  42,  41,  40,  39,  38,  37,  36,  35,
			34,  33,  32,  31,  30,  29,  18, -1
		},
	},
	.xin = 0,
	.xout = 0x1FFFFFF,
	.in_nb = 23,
	.out_nb = 25,
	.na_nb = 9,
	.na_bits = { 16, 17, 18, 19, 20, 21, 22, 23, 24 }
};

const struct plm_desc plm_desc_vm2_dec = {
	.p = {
		"0000000000000110", /* 0 */
		"1000110100000xxx", /* 1 */
		"0000110100xxxxxx", /* 2 */
		"000000000001xxxx", /* 3 */
		"01110xxxxx000xxx", /* 4 */
		"00000000101xxxxx", /* 5 */
		"0111100xxx000xxx", /* 6 */
		"01111010000xxxxx", /* 7 */
		"x000110111000xxx", /* 8 */
		"x0x1000xxx000xxx", /* 9 */
		"0000000000001xxx", /* 10 */
		"x0001100xx000xxx", /* 11 */
		"000000001x000xxx", /* 12 */
		"0000x0x000xxxxxx", /* 13 */
		"x10x000xxx000xxx", /* 14 */
		"0000000000000011", /* 15 */
		"x000101111xxxxxx", /* 16 */
		"0000000000000x01", /* 17 */
		"10000000xxxxxxxx", /* 18 */
		"0000100xxx000xxx", /* 19 */
		"0000000001000xxx", /* 20 */
		"x0000xx0000xxxx0", /* 21 */
		"x0000001xxxxxxxx", /* 22 */
		"xx10000xxx000xxx", /* 23 */
		"1000x00xxxxxxxxx", /* 24 */
		"x000101xxx000xxx", /* 25 */
		"0001xxxxxxxxxxxx", /* 26 */
		"0111111xxxxxxxxx", /* 27 */
		"0000xx01xxxxxxxx", /* 28 */
		"x000001xxxxxxxxx", /* 29 */
		"1000110100xxxxxx", /* 30 */
		"x00001xxxxxxxxxx", /* 31 */
		"x0000xx00xxxxxxx", /* 32 */
		"x0001100xxxxxxxx", /* 33 */
		"00000000x1xxxxxx", /* 34 */
		"x10x000xxxxxxxxx", /* 35 */
		"x000110111xxxxxx", /* 36 */
		"0000100xxxxxxxxx", /* 37 */
		"1x0xxxxxxxxxxxxx", /* 38 */
		"0111100xxxxxxxxx", /* 39 */
		"x0x1000xxxxxxxxx", /* 40 */
		"xx10000xxxxxxxxx", /* 41 */
		"x000101xxxxxxxxx", /* 42 */
		"01110xxxxxxxxxxx", /* 43 */
		"10xxxxxxxxxxxxxx", /* 44 */
		"xx01xxxxxxxxxxxx", /* 45 */
		"x1x0xxxxxxxxxxxx", /* 46 */
		"x01xxxxxxxxxxxxx", /* 47 */
	},
	.s = {
		(const int16_t[]) { /* pl[0] */
			43, 41, 40, 39, 35, 25, 20, 19, 12, 11, 8, 1, -1
		},
		(const int16_t[]) { /* pl[1] */
			-1
		},
		(const int16_t[]) { /* pl[2] */
			0, -1
		},
		(const int16_t[]) { /* pl[3] */
			47, 43, 37, 32, 30, 16, -1
		},
		(const int16_t[]) { /* pl[4] */
			37, 32, 28, 26, 13, -1
		},
		(const int16_t[]) { /* pl[5] */
			42, 37, 36, 34, 33, 30, 12, -1
		},
		(const int16_t[]) { /* pl[6] */
			43, 41, 40, 39, 35, 20, 19, -1
		},
		(const int16_t[]) { /* pl[7] */
			47, 46, 45, 43, 39, 27, -1
		},
		(const int16_t[]) { /* pl[8] */
			42, 37, 36, 34, 33, 30, 23, 14, 12, 9,
			6,  4,  -1
		},
		(const int16_t[]) { /* pl[9] */
			31, 29, 27, 24, 22, 21, 20, 19, 17, 15,
			10, 7,  5,  3,  2,  -1
		},
		(const int16_t[]) { /* pl[10] */
			44, 38, -1
		},
		(const int16_t[]) { /* pl[11] */
			31, 29, 22, 20, 19, 18, -1
		},
	},
	.xin = 0,
	.xout = (0xFFFull ^ (1 << 6 | 1 << 9 | 1 << 11)) |
		(0x38ull << (0 + PLM_S_MAX)),
	.in_nb = 16,
	.out_nb = 12,
	.na_nb = 6,
	.na_bits = { 11, 9, 6, 7, 8, 0 }
};

const struct plm_desc plm_desc_vm3_dec = {
	.p = {		// ins, fpp, ir[15:0]
		"1xxxxx1xxxxxxxxxxx", /* 0 */
		"1xxxxxx1xxxxxxxxxx", /* 1 */
		"1xxxxxxx1xxxxxxxxx", /* 2 */
		"1xxxxx000xxxxxxxxx", /* 3 */
		"111111000000xxxxxx", /* 4 */
		"111111000x1xxxxxxx", /* 5 */
		"1xxxxxxxxxxx1xxxxx", /* 6 */
		"1xxxxxxxxxxxx1xxxx", /* 7 */
		"11111100010xxxxxxx", /* 8 */
		"11111101xxxxxxxxxx", /* 9 */
		"1xxxxxxxxxxxxx1xxx", /* 10 */
		"111111100xxxxxxxxx", /* 11 */
		"111111101xxxxxxxxx", /* 12 */
		"111111001xxxxxxxxx", /* 13 */
		"1x0111100xxxxxxxxx", /* 14 */
		"1xx000110111xxxxxx", /* 15 */
		"1xx010xxxxxxxxxxxx", /* 16 */
		"1111111x00xxxxxxxx", /* 17 */
		"1x0xxxxxxxxxxxxxxx", /* 18 */
		"1xx000110101xxxxxx", /* 19 */
		"11111111x0xxxxxxxx", /* 20 */
		"1xx0001100xxxxxxxx", /* 21 */
		"1111110000x1xxxxxx", /* 22 */
		"1xxx01xxxxxxxxxxxx", /* 23 */
		"1xx0x1xxxxxxxxxxxx", /* 24 */
		"1xxxxx0000xxxxxxxx", /* 25 */
		"1xx110xxxxxxxxxxxx", /* 26 */
		"1xx0001011xxxxxxxx", /* 27 */
		"1xxxxx000xxxx0xxxx", /* 28 */
		"1111111101xxxxxxxx", /* 29 */
		"1xx00010101xxxxxxx", /* 30 */
		"1xxxxx000xxx0xxxxx", /* 31 */
		"1111111x11xxxxxxxx", /* 32 */
		"1xx000110110xxxxxx", /* 33 */
		"xxxxxx000xx0xxxxx1", /* 34 */
		"1xxxxx000xx0xxxxxx", /* 35 */
		"1x01110xxxxxxxxxxx", /* 36 */
		"1xx000101x00xxxxxx", /* 37 */
		"1x00000000x1xxxxxx", /* 38 */
		"1xx000100xxxxxxxxx", /* 39 */
		"1xx100xxxxxxxxxxxx", /* 40 */
		"1x0000000000000x00", /* 41 */
		"1x0000000010000xxx", /* 42 */
		"1x0000000000000x01", /* 43 */
		"xxxxxx000x0xxxxx1x", /* 44 */
		"1xxxxx000x0xxxxxxx", /* 45 */
		"1x00000001xxxxxxxx", /* 46 */
		"1111110000x0xxxxxx", /* 47 */
		"1x1000110100xxxxxx", /* 48 */
		"1xx0000x1xxxxxxxxx", /* 49 */
		"111111000011xxxxxx", /* 50 */
		"1xxxxxxxxxxx000xxx", /* 51 */
		"1xx01xxxxxxxxxxxxx", /* 52 */
		"1xx0001010x1xxxxxx", /* 53 */
		"1xx00001xxxxxxxxxx", /* 54 */
		"1x0111010xxxxxxxxx", /* 55 */
		"xxxx0xxx01xxxxxxxx", /* 56 */
		"1x10000xxxxxxxxxxx", /* 57 */
		"1x00000000101xxxxx", /* 58 */
		"xxxxxx000xxx00xxxx", /* 59 */
		"1xxxxx0x00xxxxx1xx", /* 60 */
		"0xxxxxxxxxxxxxxxxx", /* 61 */
		"1xx0000xxxx00xx1xx", /* 62 */
		"111111xxxxxx00011x", /* 63 */
		"1x0000100xxxxxxxxx", /* 64 */
		"1xx0001100x1xxxxxx", /* 65 */
		"xxxxxxxxx111xxxxxx", /* 66 */
		"1x0000000000000011", /* 67 */
		"1xxxxx000xx1xxxxx0", /* 68 */
		"1xx0001011x0xxxxxx", /* 69 */
		"1x0000000000000x10", /* 70 */
		"xxx111xx0xxx000xxx", /* 71 */
		"111111000x00xxxxxx", /* 72 */
		"1xxxxxxxxxxxxxx111", /* 73 */
		"1x0111x11xxxxxxxxx", /* 74 */
		"1xxxxx000x1xxxxx0x", /* 75 */
		"1xx00011001xxxxxxx", /* 76 */
		"1xx01x10x111xxxxxx", /* 77 */
		"1111111110xxxxxxxx", /* 78 */
		"1x1110xxxxxxxxxxxx", /* 79 */
		"11111100000000x1xx", /* 80 */
		"1xx000101011xxxxxx", /* 81 */
		"11111100000001xxxx", /* 82 */
		"1x0000110100xxxxxx", /* 83 */
		"1xxxx01xxxxxx00111", /* 84 */
		"1111111111xxxxxxxx", /* 85 */
		"1111110000001xxxxx", /* 86 */
		"1xxx0110x111xxxxxx", /* 87 */
		"1x01110x1xxxxxxxxx", /* 88 */
		"1x01110xxxxxx0x111", /* 89 */
		"1xxxxx0001xxxxx0xx", /* 90 */
		"1xxxx01xxxxx10x111", /* 91 */
		"1xxx01xxxxxxx00111", /* 92 */
		"11111100000000xx00", /* 93 */
		"1xx000101111xxxxxx", /* 94 */
		"11111100000000x011", /* 95 */
		"1xx1x010x111xxxxxx", /* 96 */
		"xx0000xx0xx1xxxxxx", /* 97 */
		"111111000x0x001000", /* 98 */
		"1x0xxxx00xxxx00111", /* 99 */
		"1x01110xx11xxxxxxx", /* 100 */
		"1xxxxx000xxx11xxxx", /* 101 */
		"1xxx01xxxxxx10x111", /* 102 */
		"1xx01xxxxxxxx00111", /* 103 */
		"1x0000x00001xxxxxx", /* 104 */
		"1xx1x0xxxxxxx00111", /* 105 */
		"1xx1x0xxxxxx10x111", /* 106 */
		"1xx01xxxxxxx10x111", /* 107 */
		"1x0xxxx00xxx10x111", /* 108 */
		"1x0000x0000x000100", /* 109 */
	},
	.s = {
		(const int16_t[]) { /* pl[0] */
			36, 13, 9, 3, 0, -1
		},
		(const int16_t[]) { /* pl[1] */
			53, 48, 39, 37, 36, 33, 32, 30, 29, 27,
			21, 20,	19, 17, 15, 14, 13, 12, 11, 9,
			3, -1
		},
		(const int16_t[]) { /* pl[2] */
			66, -1
		},
		(const int16_t[]) { /* pl[3] */
			51, 4, -1
		},
		(const int16_t[]) { /* pl[4] */
			97, 71, 48, 45, 39, 36, 35, 31, 29, 28,
			25, 22, 21, 19, 17, 11, 9, 8, 5, 4, 2, -1
		},
		(const int16_t[]) { /* pl[5] */
			101, 90, 75, 68, 60, 59, 53, 44, 39, 38,
			37, 36, 34, 30, 27, 22, 14, 13, 12, 11,
			8, 5, 4, 1, -1
		},
		(const int16_t[]) { /* pl[6] */
			109, 104, 67, 39, 33, 32, 29, 22, 20, 19,
			17, 15, 13, 12, 11, 9, 8, 5, 4, -1
		},
		(const int16_t[]) { /* pl[7] */
			83, 74, 70, 67, 61, 58, 57, 54, 53, 49,
			48, 46, 43, 42, 41, 39, 38, 37, 36, 33,
			32, 30, 29, 27, 22, 21, 20, 19, 17, 13,
			12, 11, 9, 8, 5, 4, -1
		},
		(const int16_t[]) { /* pl[8] */
			98, 95, 86, 82, 80, 64, 53, 48, 40, 38,
			37, 36, 33, 32, 30, 29, 27, 26, 24, 23,
			22, 21, 20, 19, 17, 16, 15, 14, 13, 12,
			11, 9, 8, 5, -1
		},
		(const int16_t[]) { /* pl[9] */
			85, 83, 81, 76, 63, 58, 50, 47, 42, 41,
			37, 36, 24, 23, 17, 16, 15, 13, 11, 9,
			8, 4, -1
		},
		(const int16_t[]) { /* pl[10] */
			94, 83, 74, 57, 54, 52, 49, 48, 46, 42,
			36, 32, 29, 22, 20, 17, 16, 13, 12, 11,
			9, 8, 5, 4, -1
		},
		(const int16_t[]) { /* pl[11] */
			73, -1
		},
		(const int16_t[]) { /* pl[12] */
			108, 107, 106, 105, 103, 102, 100, 99, 96, 92,
			91, 89, 87, 84, 77, -1
		},
		(const int16_t[]) { /* pl[13] */
			33, 26, 19, 18, 14, -1
		},
		(const int16_t[]) { /* pl[14] */
			72, 70, 64, 63, 61, 58, 53, 47, 43, 37,
			33, 30, 27, 26, 24, 17, 16, 15, 14, 12,
			4, -1
		},
		(const int16_t[]) { /* pl[15] */
			10, -1
		},
		(const int16_t[]) { /* pl[16] */
			7, -1
		},
		(const int16_t[]) { /* pl[17] */
			6, -1
		},
		(const int16_t[]) { /* pl[18] */
			55, 40, 33, 27, 26, 24, 23, 21, 19, 16, 15, 14, -1
		},
		(const int16_t[]) { /* pl[19] */
			36, 21, -1
		},
		(const int16_t[]) { /* pl[20] */
			95, 93, 88, 86, 82, 80, 79, 69, 67, 65,
			64, 63, 62, 57, 54, 50, 49, 46, 42, 41,
			38, 32, 30, 20, 16, -1
		},
		(const int16_t[]) { /* pl[21] */
			78, 74, 65, 63, 61, 58, 57, 56, 55, 54,
			53, 49, 48, 47, 46, 43, 42, 41, 40, 33,
			30, 29, 24, 23, 22, 19, 15, 14, 12, 4, -1
		},
	},
	.xin = 0,
	.xout = 0x3FFFFFull | (0x3Full << (0 + PLM_S_MAX)),
	.in_nb = 18,
	.out_nb = 22,
	.na_nb = 6,
	.na_bits = { 0, 1, 2, 3, 4, 5 }
};

const struct plm_desc plm_desc_vm3 = {
	.p = {
		"x0xxxxxxxx1xx10x0xxx011", /* 0 */
		"xxxxxxxxxxx0xxx0xx01x00", /* 1 */
		"0xxxxxxxx010x10x0xx0x0x", /* 2 */
		"01xxxxxxxxx0xxx0xx0x001", /* 3 */
		"x1xxxxxxxx0xx1xx0xx0011", /* 4 */
		"0xxxxxxxxx00xxx00xx0x0x", /* 5 */
		"00xxxxxxxx10xxx001xx00x", /* 6 */
		"01xxxxxxx01011x1xxxxxxx", /* 7 */
		"xxxxxxxxxxxxxxx0xx0101x", /* 8 */
		"00xxxxxxx01011x1xxxxxxx", /* 9 */
		"0xxxx0xxx1001xx1xxxxxxx", /* 10 */
		"xxxxxx0xxxxxx0x00x00x00", /* 11 */
		"xxxxxxxxxxxxxxx01x11xx0", /* 12 */
		"xxxxxxxxxxxxx0x01011001", /* 13 */
		"xxxxxx10xxxxx0x00xx0x00", /* 14 */
		"xxxxxxxxxxxxxxx00101x00", /* 15 */
		"x0xxxxxxx0x010x1xxxxxxx", /* 16 */
		"xxxxxxxxx0x0x1xx0xxxx00", /* 17 */
		"xxxxxxxxxxx1xxx10xxxx10", /* 18 */
		"xxxxxxxxxxxxxxx011x0x10", /* 19 */
		"xxxxxxxxxxxxxxx01x10001", /* 20 */
		"0xxxxxxxxxx1x11x0xxx011", /* 21 */
		"10xxxxxxxxxxx10x0xx0011", /* 22 */
		"xxxxxxxxxxxxxxx01010x10", /* 23 */
		"xxxxxxxxxxxxxxx0100xx0x", /* 24 */
		"01xxxxxxx00011x1xxxxxxx", /* 25 */
		"1xxxxxxxxxx1xxxx00x1010", /* 26 */
		"00xxx0xxx1x01xx1xxxxxxx", /* 27 */
		"10xxxxxxxxxxx11x011xx00", /* 28 */
		"xxxxxxx1xxxxxxx01x001x0", /* 29 */
		"xx101xxx1xx1xxx100xx011", /* 30 */
		"1xxxxxxxxxx1xxxx01x1010", /* 31 */
		"0xxxxxxxxxx1xxxx01x0010", /* 32 */
		"1xxxxxxxxxx0x1xx0xx0x0x", /* 33 */
		"xxx1xxxxxxxxxxx00x1x10x", /* 34 */
		"xx101xxx0xx1xxx100xx01x", /* 35 */
		"1xxxx0xxxxx011x1xxxxxxx", /* 36 */
		"xx1x1xxx01x1xxxxx001x0x", /* 37 */
		"xx111xxxxxx1xxx100xx01x", /* 38 */
		"1xxxxxxxxxxxxxx01x00001", /* 39 */
		"xxxxxxxxxxx1xxxx11111x1", /* 40 */
		"xxxxxxxxxxxxxxx01xx011x", /* 41 */
		"x0xxxxxxx1x1xxxx0x10x01", /* 42 */
		"00xxxxxxxxx1xxxx01x1010", /* 43 */
		"0xxxxxxxxxx111xx0xx0x00", /* 44 */
		"xxxxxxxxxxxxxxx01x10000", /* 45 */
		"xxxxxxxxxxx1xxx10x1xxxx", /* 46 */
		"10xxxxxxxx0xx1xx0111x0x", /* 47 */
		"11xxxxxxxxxxx1xx0xx101x", /* 48 */
		"xxxxxxxxxxx0xxx0x1010x1", /* 49 */
		"0xxxxxxxxx0xx1xx0111x01", /* 50 */
		"xxxxxxxxxxxxxxx011x11xx", /* 51 */
		"0xxxxxxxxxx1x10x0xxx011", /* 52 */
		"xxxxx0xxx1xxxx100xx001x", /* 53 */
		"x1xxx0x1xxx1xxx00x10x01", /* 54 */
		"xxxxxxxxxxxxxxx000xx101", /* 55 */
		"xxxxxxxxxxxxxxx0xx00000", /* 56 */
		"0xxxxxxxx0xxx10x00x101x", /* 57 */
		"1xxxxxxxxxx1xxxx01x0010", /* 58 */
		"xxxxx1xxxxx1x0xxx1010x1", /* 59 */
		"xxxxxxxxxxxxxxx00x000xx", /* 60 */
		"xxxxxxxxxxxxxxx0101x101", /* 61 */
		"xxxxxxxxxxx1x1x1x01x1x1", /* 62 */
		"xxxxxxxxxxxxxxx01x11011", /* 63 */
		"xxxxx1xxxx1xxxx001110xx", /* 64 */
		"xxxxxxxxxxx1xxxxx00x011", /* 65 */
		"xxxxxxxxxxx1x1xxx000x0x", /* 66 */
		"xxxxxxxxxxx1xxxx00x001x", /* 67 */
		"x1xxxxxxx0x010x1xxxxxxx", /* 68 */
		"xxxxx0xxxxxxx1x00x00x00", /* 69 */
		"xxxxxxxxx10xx0x00x100xx", /* 70 */
		"xxxxxxxxxxx1xxx1x11xx10", /* 71 */
		"xx1x1xxx00x1xxxx1001x0x", /* 72 */
		"x0xxxxxxxx1xx11x0xx101x", /* 73 */
		"xxxxxxxxxxx1x1x1x100x0x", /* 74 */
		"xxxxxxx0xxxxxxx011xx1x0", /* 75 */
		"10xxxxxxxxx1xxxxx101001", /* 76 */
		"xxx11xxxxxx1xxxx1001x0x", /* 77 */
		"xxxxxxxxx1xx10xx0xxx01x", /* 78 */
		"xxxxxxxxxxxxxxx0x10x01x", /* 79 */
		"0xxxxxxxxx01xxxxx101001", /* 80 */
		"xxxxxxxxxxx1x1x1x10xx11", /* 81 */
		"xxxxxxxxxxxxxxx00xx0101", /* 82 */
		"xxxxxxxxxxxxxxx01x1111x", /* 83 */
		"xx1x1xxx1xx1xxxx1001x0x", /* 84 */
		"10xxxxxxxxxxx1xx0xx1011", /* 85 */
		"xxxxxxxxxx1xx0x001110xx", /* 86 */
		"xxxxxxxxxxx000x11xxxxxx", /* 87 */
		"00xxxxxxxxxxxxx0110x0x1", /* 88 */
		"0xxxxxxxxxx1xxxx0x11x00", /* 89 */
		"xxxxxxxxxxx1xxx100xx11x", /* 90 */
		"xxxxxxxxxxxxxxx01110x11", /* 91 */
		"xx11xxxxxxx1xxxx1001x0x", /* 92 */
		"xxxxxxx0xxxxx0x001110xx", /* 93 */
		"xxxxxxxxxxxxxxx00101101", /* 94 */
		"xx001xxxxxx1xxxx1001x0x", /* 95 */
		"xxxxxxxxxxx1x1x1x01xx10", /* 96 */
		"xxxxxxxxxx1xxxx00x1xx00", /* 97 */
		"00xxxxxxx00011x1xxxxxxx", /* 98 */
		"xxxxxxxxxxx1x11x0x100x1", /* 99 */
		"xxxxxxxxxxx1xxx1000x1xx", /* 100 */
		"xxxxxxxxxxxxxx001111x01", /* 101 */
		"xxxxx1xxxxxxx0x00x10x0x", /* 102 */
		"xxxxxxxxxxxxxxx0x0000xx", /* 103 */
		"xxxxxxxxxxxxxxx0xx1x100", /* 104 */
		"xxxxxxxxxxx1xxx1011000x", /* 105 */
		"x0xxx0xxx011x0x1x000xxx", /* 106 */
		"xxxxxxxxxxx00xx10xxxxxx", /* 107 */
		"00xxx0xxxx01x0xxx000x0x", /* 108 */
		"x0xxx0xxx1x1x0x111xxxxx", /* 109 */
		"11xxxxxxxxx1x0xxx000x0x", /* 110 */
		"xxxxxxxxxxx1x1x1x1100x1", /* 111 */
		"xxxxxxxxxxxxxxx00011x00", /* 112 */
		"xxxxxxxxxxx1xxx101xx01x", /* 113 */
		"11xxxxxxxxxxx1xx01x1001", /* 114 */
		"xxx0xxxxx1x1xxx101xxxxx", /* 115 */
		"xxxxxxxxxxx1xxxx00x00x1", /* 116 */
		"xxxxxxxxxxx1xxx11110x11", /* 117 */
		"xxxxxxxxxxxxxxx0xxxx110", /* 118 */
		"01xxx0xxx1101xx1xxxxxxx", /* 119 */
		"11xxxxxxxxx1xxxx0x110x0", /* 120 */
		"x0xxx1xxx011x0x1x000xxx", /* 121 */
		"xxxxxxxxxxx1xxxx011010x", /* 122 */
		"xx100xxx0xx1xxxx1001x0x", /* 123 */
		"xxxxxxxxxxxxxxx0111x1xx", /* 124 */
		"xxxxxxxxxxxxxxx0001x001", /* 125 */
		"01xxx1xxxxx1x0x110x0xxx", /* 126 */
		"xxxxxxxxx0x1x0x1x10xxxx", /* 127 */
		"xxxxxxxxxxx1xxxx110xx10", /* 128 */
		"xxxxxxxxxxx1xxxx000x0xx", /* 129 */
		"1xxxxxxxxxxxx1xx0x00x00", /* 130 */
		"xx00xxxxxxx1xxx100xx01x", /* 131 */
		"xxxxxxxxxxx001x1xxxxxxx", /* 132 */
		"xxxxxxxxxxxxxxx0101x0xx", /* 133 */
		"xx010xxxxxx1x0x11x01xxx", /* 134 */
		"xxxxxxxxxxx1xxx1111x011", /* 135 */
		"0xxxxxxxx01xxx100x10x0x", /* 136 */
		"x0xxx1xxx1x11xx111xxxxx", /* 137 */
		"0xxxx1xxxx01x0x1x000xxx", /* 138 */
		"xxxxxxxxxxx1x1x1xx1x101", /* 139 */
		"xxxxxxxxxxxxxxx000xx011", /* 140 */
		"x1xxx1xxx1x1x0x111xxxxx", /* 141 */
		"xx100xxx1xx1xxx11001x0x", /* 142 */
		"xxx0xxxxxxxxxxx00x1x10x", /* 143 */
		"x1xxx0xxx111x0x11x00xxx", /* 144 */
		"xxxxxxxxxx11x0x1101xxxx", /* 145 */
		"xxxxxxxxxxx1xxx1x00x111", /* 146 */
		"xx0x1xxxxxx110x1xx01xxx", /* 147 */
		"xxxxxxxxxxx1x1x1x1x1x01", /* 148 */
		"1xxxxxxxx0xxxx0001x0x00", /* 149 */
		"xxxxxx0xxxx10xx1xxxxxxx", /* 150 */
		"xxxxxx0xxxx100x1xxx0xxx", /* 151 */
		"xxxxxxxxxxxxxxx01x0x11x", /* 152 */
		"1xxxxxxxxx01x0x1x000xxx", /* 153 */
		"xxxxxxxxxxx1xxx1x11xx00", /* 154 */
		"xx000xxxxxx1x0x11x01xxx", /* 155 */
		"xxxxx0xxxx1xxxx001010x1", /* 156 */
		"xxxx0xxxxxx1xxx100xx01x", /* 157 */
		"xxxxxxxxxxx1x1x1x01xx0x", /* 158 */
		"xxxxxxxxxxx1xxx1x00xx10", /* 159 */
		"xxxxxxxxxxxx10x101xx11x", /* 160 */
		"xxxxxxxxxxxxxxx01x001x1", /* 161 */
		"xxxxxxxxxxxx10x10xx100x", /* 162 */
		"1xxxxxxxx11111x1xxx0xxx", /* 163 */
		"x0xxxxxxx1x110x1x0x0xxx", /* 164 */
		"x1xxxxxxxxxxxxx00xx1010", /* 165 */
		"x1xxx0xxx011xxx1x0x0x00", /* 166 */
		"xxx1xxxxxxxx10x1010xxxx", /* 167 */
		"01xxxxxxx001x0x1x0x0xx0", /* 168 */
		"xxxxxxxxxxx100x1xx1xxxx", /* 169 */
		"xxxxxxxxx0xxx0x00x100xx", /* 170 */
		"xxxxx1xxx1x01xx1xxxxxxx", /* 171 */
		"xxxxxx0xxxx1x1x1xx0xx0x", /* 172 */
		"xxxxxxxxx0x111x1x1xxxxx", /* 173 */
		"xxxxxxxxxx1xx1x001010x1", /* 174 */
		"xxxxx0xxxxxx10x10x111xx", /* 175 */
		"xxxxxxxxx0x1x1x1xx0xx0x", /* 176 */
		"xxxxxxxxxxx1xxx101x1x0x", /* 177 */
		"xxxxxxxxxxxxxxx000x0x0x", /* 178 */
		"xxxxxxxxxx11x1x1xx00x0x", /* 179 */
		"xxxxxxxxxxx10xx1xx00xx1", /* 180 */
		"xx010xxxxxx1x1xx1001x0x", /* 181 */
		"1xxxxxxxxx0111x1xxx0xxx", /* 182 */
		"xxxxxxxxxxxxxx101111x01", /* 183 */
		"xxxxxxxxxxxx10xx00x0x00", /* 184 */
		"xx1x1xxx1xxx10xx1x01xxx", /* 185 */
		"x0xxxxxxxxxx1xxx00x010x", /* 186 */
		"xxxxxxxxxxxx10010x11x0x", /* 187 */
		"xxxxxxxxxxx1xxxx101x0x1", /* 188 */
		"x1xxxxx1xxxxx0x001110xx", /* 189 */
		"0xxxxxxxxxx1xxx10011x0x", /* 190 */
		"xxxxxxxxxxx1xxx10011x0x", /* 191 */
		"xx11xxxxxxx110x11x01xxx", /* 192 */
		"xxxxxx1xxxx100x1x1xxxxx", /* 193 */
		"xx100xxx0xx110x11x01xxx", /* 194 */
		"x1xxx1xxx1x1x0x1x0x0xxx", /* 195 */
		"xx011xxxxxxx10x100xx011", /* 196 */
		"xxxxxxxxxxx1xxx1x101x0x", /* 197 */
		"xxxxxxxxxxxxxxx00xxx111", /* 198 */
		"xxxxxxxxxxxx10x1000xxxx", /* 199 */
		"xxxxxxxxx0x10xx1xx0xxxx", /* 200 */
		"xxxxx1xxxxx111x1xxx0xxx", /* 201 */
		"xxxxxx0xx00111x1xxx0xxx", /* 202 */
		"xxxxx0x0xx1xx0x00x10x0x", /* 203 */
		"x1xxx0xxxx11x0xxx000x0x", /* 204 */
		"x0xxxxxxx1x111x1xxx0xxx", /* 205 */
		"xx000xxxxxx1x1xx1001x0x", /* 206 */
		"0xxxxx1xx01111x1xxx0xxx", /* 207 */
		"xxxxxxxxx1x111x1x100x0x", /* 208 */
		"10xxx10xxx1111x1xxx0xxx", /* 209 */
		"xxxxxxxxxxxxxxx0x0x0011", /* 210 */
		"1xxxxxxxxxx101x1xx00x0x", /* 211 */
		"xxxx1xxxx11110x1xx01xxx", /* 212 */
		"x0xxx1xxx1x1x0x111xxxxx", /* 213 */
		"0xxxx0xxx101x1x1xx00x0x", /* 214 */
		"xxxxxxxxxxxxxxx0000xx01", /* 215 */
		"xxxxxxxxxxxxx1x0101x0x1", /* 216 */
		"xxxxxxxxxxxxxxxx01xx10x", /* 217 */
		"xxxxxxxxxxxxxxx0010x0x0", /* 218 */
		"0xxxx0xxxx1111x1xxx0xxx", /* 219 */
		"00xxxxxxxx1x100x00x00x1", /* 220 */
		"1xxxxxxxx01111x1x1xxxxx", /* 221 */
		"x0xxx0xxx1xxxxx11x00x0x", /* 222 */
		"xxxxxxx1xxxxx0x00xx0100", /* 223 */
		"01xxxxxxxxxxx0x1001xx0x", /* 224 */
		"xxxxxx0xxxxxx0000x00x00", /* 225 */
		"xx1x1xxx0xx1xxxxx011x01", /* 226 */
		"x1xxxxxxxxxxxxx001x0010", /* 227 */
		"xxxxxxxxxxxxxxx0x0x0101", /* 228 */
		"xxxxxxxxx0x10xx1xx00x0x", /* 229 */
		"01x1x0xxx10011x11xxxxxx", /* 230 */
		"xxxxxxxxxxx101x1x100x0x", /* 231 */
		"xxxxx01xx1x10xxxx000x0x", /* 232 */
		"01xxxxxxxxxx10x100x0xxx", /* 233 */
		"0xxxx1xxxx0x1xx1001x1xx", /* 234 */
		"0xxxxxxxx1x0xxx001xx0xx", /* 235 */
		"xxxxxxxxxxx11xx1xxx0x1x", /* 236 */
		"x1x0xxxxx1xx10x101xxxxx", /* 237 */
		"x0xxxxxxxx01x1x1xx00x0x", /* 238 */
		"x1xxx1xxxxx1x1x1xx00x0x", /* 239 */
		"xxxxxxxxxxxxxxx01x11x00", /* 240 */
		"00xxx0xxx10x1xx1xxx0xxx", /* 241 */
		"00xxxxxxxx1x1x1100x00x1", /* 242 */
		"xxxxx1x1x1xxx1xx011x0xx", /* 243 */
		"xxxxxxx0xxx10xx1x110x01", /* 244 */
		"xxx11xxxx0xx10x1x10xxxx", /* 245 */
		"xx1x1xxx1xxxxxx00101x00", /* 246 */
		"xxxxxx1xxxx1x1x1xx00x0x", /* 247 */
		"11xxx0xxxxx1x0x110x0xxx", /* 248 */
		"00xxxxxxxxxxxxxx0110x01", /* 249 */
		"1xxxxxxxxxxx1x0100x0xx1", /* 250 */
		"x0xxx0xxxxx1xxx10x111xx", /* 251 */
		"xx1x1xxx1xx1x1x11100x0x", /* 252 */
		"xxxxxxxxxxx1xx1000x1010", /* 253 */
		"00xxxxxxxx0x1xx100x0xx1", /* 254 */
		"xx1x1xxx0xx1x0x11x01xxx", /* 255 */
		"x11xx0xx0101xxx11001x0x", /* 256 */
		"x110100x0101xxx11001x0x", /* 257 */
		"xxxxx0xxxxxxx11x0xx0100", /* 258 */
		"xxxxxxxxxxxxxx10100x011", /* 259 */
		"x1xxx0xxx1011xx1x1xxxxx", /* 260 */
		"xxxxxxxxxxxxxx10x011001", /* 261 */
		"0xxxxxxxxxxx1x010011001", /* 262 */
		"x1xxx0xxx101xxxx0x0xxxx", /* 263 */
		"xxxxx0xxx1010xx1x10xx01", /* 264 */
		"xxxxxxxxxxx1xxxxx001x00", /* 265 */
		"x1xx10xxx101xxx11001x0x", /* 266 */
		"xxxxx0xxx10101x111x0x00", /* 267 */
		"xxxxxx1xxxxxx0100x00x00", /* 268 */
		"1xxxxxxxxx1x1xx100xx11x", /* 269 */
		"xxx11xxxxxx110x1xx01xxx", /* 270 */
		"00xxxxxxxx1x1x0100111xx", /* 271 */
		"x1xxxxxxxx1xxxx001110xx", /* 272 */
		"00xxxxxxxxx0xxx00xx0x0x", /* 273 */
		"0xxxxxxxxx1x1xx1011000x", /* 274 */
		"xxxxx0xxx1xxxx000xx001x", /* 275 */
		"xxxxx1xxx01111x1x1xxxxx", /* 276 */
		"x111x0xxx101xxx11001x0x", /* 277 */
		"xxx11xxxx1x110x1xx01xxx", /* 278 */
		"xxxxxxxxx00111x1x1xxxxx", /* 279 */
		"xx1x1xxx11x110x1xxx1xxx", /* 280 */
	},
	.s = {
		(const int16_t[]) { /* pl[0] */
			279, 276, 274, 265, 251, 243, 232, 223,	209, 203,
			193, 189, 167, 151, 144, 141, 115, 114, 112, 103,
			101, 98,  91,  88,  86,  80,  76,  70,  62,  61,
			58,  54,  52,  50,  49,  48,  47,  45,  44,  43,
			32,  31,  29,  28,  17,  12,  9,   4,	3,   -1
		},
		(const int16_t[]) { /* pl[1] */
			271, 269, 262, 251, 240, 226, 224, 216, 206, 203,
			198, 197, 196, 195, 193, 189, 188, 186, 184, 183,
			181, 178, 174, 171, 170, 169, 168, 166, 165, 164,
			161, 160, 158, 157, 156, 155, 154, 152, 151, 148,
			145, 144, 143, 142, 141, 139, 138, 135,	134, 132,
			131, 130, 129, 127, 125, 123, 121, 118, 117, 116,
			115, 114, 113, 111, 109, 108, 107, 106, 104, 103,
			101, 100, 98,  96,  95,  93,  92,  91,  88,  86,
			85,  84,  83,  82,  81,  80,  79,  78,  77,  76,
			75,  74,  73,  72,  71,  70,  69,  68,  67,  66,
			65,  64,  62,  61,  60,  59,  58,  56,  54,  53,
			50,  49,  47,  42,  41,  40,  39,  38,  37,  36,
			35,  34,  33,  30,  29,  27,  25,  24,	23,  22,
			21,  18,  17,  15,  14,  11,  10,  8,   7,   4,
			3,   2,   1,   -1
		},
		(const int16_t[]) { /* pl[2] */
			261, 259, 249, 245, 234, 218, 216, 215,	207, 206,
			202, 198, 184, 183, 181, 175, 174, 171, 169, 167,
			164, 162, 155, 154, 153, 152, 149, 145, 144, 141,
			140, 134, 132, 130, 126, 120, 118, 117, 114, 113,
			112, 110, 109, 107, 105, 102, 101, 99,	98,  93,
			91,  90,  89,  88,  86,  80,  76,  63,  60,  59,
			58,  53,  52,  51,  50,  49,  48,  47,  45,  44,
			43,  42,  36,  33,  32,  31,  28,  27,  26,  25,
			22,  21,  20,  17,  16,  12,  9,   7,   6,   5,
			4,   3,   1,   0,   -1
		},
		(const int16_t[]) { /* pl[3] */
			275, 273, 251, 246, 245, 244, 236, 232,	231, 226,
			221, 210, 209, 208, 203, 195, 190, 188, 187, 183,
			177, 168, 167, 156, 154, 151, 148, 146, 145, 140,
			138, 137, 135, 129, 125, 123, 121, 115, 109, 108,
			106, 103, 102, 96,  95,  93,  92,  88,	86,  84,
			81,  77,  76,  72,  71,  70,  65,  63,  61,  59,
			54,  52,  51,  50,  48,  47,  44,  43,  41,  40,
			37,  36,  28,  27,  26,  25,  24,  19,  12,  8,
			7,   5,   3,   1,   -1
		},
		(const int16_t[]) { /* pl[4] */
			206, 203, 197, 193, 189, 186, 181, 178, 170, 168,
			167, 166, 165, 161, 158, 157, 156, 155, 151, 144,
			143, 142, 141, 139, 138, 135, 134, 131, 129, 123,
			121, 115, 111, 108, 104, 103, 100, 95,  92,  88,
			87,  85,  84,  83,  82,  79,  78,  77,	75,  74,
			73,  72,  70,  69,  68,  67,  66,  64,  60,  56,
			54,  51,  49,  39,  38,  37,  35,  34,  33,  29,
			24,  17,  15,  14,  13,  11,  10,  3,   2,   1,
			-1
		},
		(const int16_t[]) { /* pl[5] */
			251, 248, 206, 204, 198, 197, 189, 186, 184, 181,
			167, 158, 155, 142, 139, 134, 133, 127, 124, 122,
			118, 116, 111, 106, 105, 101, 100, 90,  87,  61,
			58,  55,  48,  47,  43,  31,  29,  23,  19,  18,
			16,  13,  9,   8,   -1
		},
		(const int16_t[]) { /* pl[6] */
			280, 278, 252, 248, 209, 207, 206, 202,	195, 193,
			181, 178, 174, 170, 169, 166, 165, 161, 155, 151,
			149, 145, 144, 143, 142, 141, 140, 134, 130, 127,
			120, 119, 118, 114, 112, 109, 106, 104, 102, 99,
			98,  93,  89,  86,  85,  83,  82,  80,	79,  78,
			76,  75,  73,  70,  69,  68,  67,  66,  64,  60,
			59,  58,  56,  55,  53,  52,  50,  48,  47,  46,
			44,  43,  42,  38,  36,  35,  34,  32,  31,  30,
			28,  27,  26,  25,  22,  21,  18,  16,	15,  14,
			11,  10,  9,   7,   6,   5,   4,   2,   0,   -1
		},
		(const int16_t[]) { /* pl[7] */
			203, 198, 196, 195, 193, 186, 183, 178,	174, 171,
			170, 169, 168, 167, 166, 165, 164, 161, 157, 156,
			152, 151, 149, 145, 144, 143, 141, 140, 138, 135,
			133, 132, 131, 130, 125, 124, 121, 120, 118, 114,
			112, 109, 108, 107, 104, 102, 101, 100,	99,  98,
			93,  91,  89,  88,  87,  86,  85,  83,  82,  80,
			79,  78,  76,  75,  74,  73,  70,  69,  68,  67,
			66,  64,  63,  61,  60,  59,  58,  56,  55,  54,
			53,  52,  51,  50,  49,  48,  47,  45,	44,  43,
			42,  41,  39,  38,  36,  35,  34,  33,  32,  31,
			30,  28,  27,  26,  25,  23,  22,  21,  20,  19,
			18,  17,  16,  15,  14,  13,  12,  11,  10,  9,
			8,   7,   6,   5,   4,   3,   2,   1,	0,   -1
		},
		(const int16_t[]) { /* pl[8] */
			212, 210, 206, 203, 197, 194, 193, 192,	189, 188,
			185, 183, 181, 178, 171, 170, 168, 167, 166, 165,
			164, 162, 161, 159, 158, 156, 155, 154, 153, 152,
			151, 149, 148, 147, 146, 143, 142, 140, 139, 138,
			137, 136, 135, 134, 132, 130, 128, 127,	126, 125,
			124, 121, 120, 118, 117, 115, 114, 112, 111, 110,
			109, 108, 107, 106, 104, 103, 101, 100, 99,  98,
			97,  96,  94,  93,  91,  89,  88,  87,  86,  85,
			83,  82,  81,  80,  79,  78,  76,  75,	74,  73,
			72,  71,  70,  69,  68,  67,  66,  65,  64,  63,
			62,  61,  60,  59,  58,  57,  56,  55,  54,  53,
			52,  51,  50,  49,  48,  47,  46,  45,  44,  43,
			42,  41,  40,  39,  38,  36,  35,  34,	33,  32,
			31,  30,  29,  28,  27,  26,  25,  24,  23,  22,
			21,  20,  19,  18,  17,  16,  15,  14,  13,  12,
			11,  10,  9,   8,   7,   6,   5,   4,   3,   2,
			1,   0,  -1
		},
		(const int16_t[]) { /* pl[9] */
			213, 206, 188, 159, 155, 136, 123, 97,  96,  95,
			94,  72,  65,  57,  37,  -1
		},
		(const int16_t[]) { /* pl[10] */
			246, 243, 235, 232, 223, 218, 209, 207, 204, 203,
			202, 198, 197, 196, 193, 191, 189, 186, 184, 183,
			181, 177, 175, 174, 171, 169, 168, 167, 164, 162,
			160, 158, 156, 154, 153, 152, 151, 149, 148, 146,
			145, 144, 142, 141, 140, 139, 138, 137, 136, 135,
			134, 133, 132, 130, 129, 128, 127, 126, 125, 124,
			122, 121, 120, 119, 118, 117, 116, 115, 114, 113,
			112, 111, 110, 109, 108, 107, 106, 105, 104, 103,
			102, 101, 100, 99,  98,  97,  94,  93,	92,  91,
			90,  89,  88,  87,  86,  84,  83,  81,  80,  79,
			77,  76,  74,  71,  70,  63,  62,  61,  60,  59,
			58,  57,  56,  55,  54,  53,  52,  51,  50,  49,
			48,  47,  45,  44,  43,  42,  41,  40,	39,  36,
			33,  32,  31,  30,  29,  28,  27,  26,  25,  24,
			23,  22,  21,  20,  19,  18,  17,  16,  13,  12,
			9,   8,   7,   6,   5,   4,   3,   1,   0,  -1
		},
		(const int16_t[]) { /* pl[11] */
			267, 264, 260, 213, 206, 196, 193, 191,	184, 181,
			178, 177, 174, 169, 167, 165, 160, 159, 157, 156,
			155, 153, 148, 146, 145, 144, 143, 142, 141, 136,
			135, 134, 131, 128, 127, 126, 124, 122, 121, 120,
			119, 116, 115, 113, 111, 110, 109, 108,	106, 105,
			103, 102, 98,  97,  96,  95,  94,  92,  90,  89,
			88,  87,  86,  84,  82,  81,  79,  78,  77,  76,
			75,  72,  71,  70,  69,  68,  67,  66,  64,  63,
			62,  61,  60,  57,  56,  52,  51,  50,	49,  47,
			45,  44,  43,  42,  41,  38,  37,  36,  35,  34,
			31,  30,  29,  26,  25,  24,  23,  21,  20,  19,
			18,  17,  14,  12,  11,  9,   7,   5,   4,   2,
			1,   0,  -1
		},
		(const int16_t[]) { /* pl[12] */
			151, 127, 89, 76, 72, 46, 37, 31,  9,   7, -1
		},
		(const int16_t[]) { /* pl[13] */
			214, 183, 180, 150, 127, 125, 101, 89,  80,  76,
			70,  46,  28,  13,  8,   7,   6,   0,  -1
		},
		(const int16_t[]) { /* pl[14] */
			232, 151, 89,  76,  70,  31,  26,  7,   6,   0,
			-1
		},
		(const int16_t[]) { /* pl[15] */
			215, 210, 204, 196, 193, 189, 186, 174, 169, 168,
			157, 154, 153, 144, 141, 139, 138, 137, 131, 130,
			129, 124, 119, 117, 116, 110, 100, 97,  93,  91,
			83,  79,  78,  76,  74,  70,  68,  65,  64,  63,
			61,  59,  57,  54,  52,  44,  41,  40,  39,  38,
			35,  34,  30,  26,  21,  20,  18,  17,  16,  11,
			5,   3,   0,   -1
		},
		(const int16_t[]) { /* pl[16] */
			227, 212, 206, 198, 197, 194, 193, 192,	189, 188,
			185, 183, 181, 178, 171, 170, 167, 165, 164, 162,
			161, 159, 158, 156, 155, 154, 153, 152, 151, 149,
			148, 147, 146, 143, 142, 140, 139, 137, 136, 135,
			134, 133, 132, 130, 128, 127, 126, 125,	124, 121,
			120, 119, 118, 117, 115, 114, 111, 110, 109, 108,
			107, 106, 104, 103, 101, 100, 99,  98,  97,  96,
			94,  93,  91,  89,  88,  86,  85,  83,  82,  81,
			80,  79,  78,  76,  75,  74,  73,  72,	71,  70,
			69,  68,  66,  65,  64,  63,  62,  61,  60,  59,
			58,  57,  56,  55,  54,  53,  52,  51,  50,  49,
			48,  46,  45,  44,  43,  42,  41,  40,  39,  38,
			36,  35,  34,  33,  31,  30,  29,  28,	27,  26,
			25,  24,  23,  22,  21,  20,  19,  18,  17,  16,
			15,  14,  13,  12,  11,  10,  9,   8,   7,   6,
			5,   4,	  3,   2,   1,   0,  -1
		},
		(const int16_t[]) { /* pl[17] */
			197, 191, 184, 178, 177, 171, 165, 164, 162, 160,
			159, 158, 156, 154, 152, 148, 146, 145, 139, 137,
			136, 135, 132, 128, 127, 122, 120, 118, 114, 113,
			111, 109, 108, 107, 106, 105, 102, 101, 99,  97,
			96,  94,  90,  89,  87,  86,  83,  81,	80,  76,
			75,  71,  67,  62,  61,  58,  57,  56,  54,  52,
			51,  50,  49,  48,  47,  45,  44,  43,  42,  36,
			33,  31,  29,  25,  23,  22,  19,  17,  13,  12,
			9,   7,   5,   4,   3,   2,   1,  -1
		},
		(const int16_t[]) { /* pl[18] */
			232, 213, 209, 206, 204, 202, 198, 197,	189, 188,
			183, 181, 174, 171, 170, 169, 168, 167, 164, 161,
			159, 158, 155, 154, 153, 152, 151, 149, 148, 146,
			145, 144, 143, 142, 141, 140, 139, 138, 136, 135,
			134, 133, 132, 129, 128, 127, 126, 125,	124, 123,
			121, 119, 118, 117, 115, 114, 112, 111, 110, 109,
			108, 107, 106, 104, 103, 102, 101, 100, 99,  98,
			97,  96,  95,  94,  93,  92,  91,  89,  88,  87,
			86,  85,  84,  83,  82,  81,  80,  79,  77,  76,
			75,  73,  72,  71,  68,  67,  65,  64,  63,  62,
			61,  60,  59,  58,  57,  56,  55,  54,  53,  52,
			51,  50,  49,  48,  47,  46,  45,  44,  42,  41,
			40,  39,  38,  37,  36,  35,  34,  33,	32,  31,
			30,  29,  28,  27,  26,  25,  24,  23,  22,  21,
			20,  19,  18,  17,  16,  15,  14,  13,  12,  10,
			9,   8,   7,   6,   5,   4,   3,   2,   1,   0,
			-1
		},
		(const int16_t[]) { /* pl[19] */
			215, 209, 204, 203, 186, 184, 183, 177,	168, 160,
			144, 141, 138, 135, 126, 125, 122, 121, 113, 108,
			106, 105, 101, 90,  16,  -1
		},
		(const int16_t[]) { /* pl[20] */
			268, 258, 241, 230, 225, 215, 213, 210, 206, 202,
			199, 196, 193, 189, 188, 186, 184, 181, 179, 177,
			173, 171, 168, 167, 166, 164, 163, 160, 159, 157,
			156, 155, 154, 153, 152, 148, 146, 145, 144, 142,
			141, 139, 138, 136, 135, 134, 132, 131,	130, 128,
			126, 124, 122, 121, 120, 119, 118, 117, 116, 115,
			113, 111, 110, 109, 108, 107, 106, 105, 103, 102,
			100, 98,  97,  96,  95,  94,  93,  92,  91,  90,
			87,  84,  83,  82,  81,  79,  78,  77,	76,  75,
			72,  71,  70,  68,  65,  64,  63,  62,  61,  60,
			59,  57,  56,  54,  52,  51,  49,  45,  44,  42,
			41,  40,  39,  38,  37,  36,  35,  34,  30,  29,
			26,  25,  24,  23,  20,  19,  18,  17,	16,  12,
			9,   7,   5,   4,   3,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* pl[21] */
			270, 253, 239, 237, 228, 215, 210, 204,	202, 201,
			199, 196, 193, 189, 188, 186, 184, 171, 170, 168,
			165, 164, 157, 156, 154, 153, 152, 149, 146, 145,
			144, 142, 141, 139, 138, 137, 135, 132, 131, 130,
			126, 124, 121, 119, 118, 117, 110, 108,	107, 106,
			103, 100, 98,  97,  94,  93,  92,  91,  90,  85,
			84,  83,  81,  79,  78,  76,  72,  70,  69,  68,
			65,  64,  63,  62,  59,  57,  54,  50,  45,  43,
			42,  40,  39,  38,  37,  36,  35,  34,	30,  23,
			19,  18,  17,  16,  14,  11,  10,  5,   4,   3,
			1,  -1
		},
		(const int16_t[]) { /* pl[22] */
			235, 215, 205, 201, 197, 183, 182, 181,	179, 177,
			174, 169, 167, 163, 160, 158, 151, 149, 148, 145,
			143, 140, 136, 134, 128, 125, 122, 120, 116, 115,
			114, 113, 112, 111, 109, 105, 104, 102, 101, 99,
			87,  86,  85,  82,  80,  77,  75,  74,  71,  69,
			66,  60,  58,  56,  53,  52,  51,  49,  48,  47,
			44,  41,  36,  32,  31,  29,  28,  27,  26,  25,
			24,  22,  21,  20,  16,  14,  13,  12,  11,  10,
			9,   8,   7,   6,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* pl[23] */
			217, 216, 212, 210, 206, 203, 200, 199,	198, 197,
			196, 195, 194, 193, 192, 191, 189, 188, 186, 185,
			181, 178, 176, 175, 171, 170, 169, 168, 167, 166,
			165, 164, 161, 160, 159, 158, 157, 156, 155, 154,
			153, 152, 151, 149, 148, 147, 146, 145,	143, 142,
			141, 140, 139, 138, 137, 136, 134, 132, 131, 130,
			128, 127, 124, 122, 120, 119, 118, 117, 116, 115,
			114, 112, 111, 110, 107, 104, 103, 99,  98,  97,
			96,  94,  93,  91,  89,  88,  87,  86,	85,  83,
			82,  81,  80,  79,  78,  76,  75,  74,  73,  72,
			71,  70,  69,  68,  67,  66,  65,  64,  63,  62,
			61,  60,  59,  58,  57,  56,  55,  54,  53,  52,
			51,  50,  49,  48,  47,  45,  44,  43,  42,  41,
			40,  39,  38,  36,  35,  34,  33,  32,  31,  30,
			29,  28,  27,  26,  25,  24,  23,  22,  21,  20,
			19,  18,  17,  16,  15,  14,  13,  11,  10,  9,
			8,   7,   6,   5,   4,   3,   2,   1,	0,  -1
		},
		(const int16_t[]) { /* pl[24] */
			255, 227, 219, 215, 206, 205, 203, 202,	201, 183,
			182, 181, 177, 174, 173, 169, 167, 166, 163, 160,
			159, 155, 151, 149, 148, 145, 140, 136, 134, 129,
			128, 125, 123, 122, 116, 115, 114, 113, 111, 109,
			105, 104, 102, 101, 96,  95,  88,  87,	85,  82,
			80,  77,  75,  71,  69,  60,  56,  52,  51,  49,
			44,  41,  37,  36,  33,  29,  28,  26,  25,  24,
			21,  20,  16,  14,  13,  12,  11,  10,  9,   8,
			7,   6,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* pl[25] */
			277, 266, 263, 256, 255, 212, 199, 198,	197, 196,
			194, 193, 192, 191, 189, 188, 186, 185, 178, 175,
			174, 171, 170, 168, 167, 166, 165, 164, 162, 161,
			158, 157, 156, 154, 153, 152, 151, 149, 148, 147,
			144, 143, 140, 139, 138, 137, 136, 133,	132, 131,
			130, 127, 124, 120, 119, 118, 116, 115, 114, 113,
			112, 111, 110, 109, 107, 105, 104, 103, 102, 99,
			98,  97,  94,  93,  91,  89,  88,  87,  86,  85,
			83,  82,  80,  79,  78,  76,  75,  74,	73,  72,
			70,  69,  68,  67,  66,  64,  63,  61,  60,  59,
			58,  57,  56,  55,  54,  53,  52,  51,  50,  49,
			48,  47,  45,  44,  43,  42,  41,  39,  38,  35,
			34,  33,  32,  31,  30,  29,  28,  27,	26,  25,
			24,  23,  22,  21,  20,  19,  18,  17,  16,  15,
			14,  13,  12,  11,  10,  9,   8,   7,   6,   5,
			4,   3,   2,   0,   -1
		},
		(const int16_t[]) { /* pl[26] */
			253, 238, 237, 233, 228, 225, 222, 220,	210, 207,
			205, 204, 202, 199, 196, 193, 189, 188, 186, 184,
			181, 171, 168, 167, 165, 164, 157, 156, 154, 153,
			152, 146, 145, 144, 142, 141, 139, 138, 137, 136,
			135, 134, 132, 131, 130, 128, 126, 124,	121, 120,
			119, 118, 117, 110, 109, 108, 107, 106, 103, 102,
			100, 98,  97,  94,  93,  92,  91,  90,  87,  84,
			83,  81,  79,  78,  77,  76,  72,  71,  70,  68,
			65,  64,  63,  62,  59,  57,  54,  45,	43,  42,
			41,  40,  39,  38,  37,  36,  35,  34,  31,  30,
			23,  21,  19,  18,  17,  12,  7,   5,   4,   3,
			2,   1,  -1
		},
		(const int16_t[]) { /* pl[27] */
			257, 216, 212, 210, 206, 203, 199, 198,	197, 196,
			195, 194, 193, 192, 191, 189, 188, 185, 183, 181,
			178, 175, 172, 171, 170, 167, 165, 164, 161, 159,
			158, 157, 156, 155, 154, 153, 152, 150, 149, 148,
			147, 146, 145, 144, 143, 142, 141, 140,	139, 137,
			136, 134, 132, 131, 130, 128, 127, 125, 120, 119,
			118, 116, 115, 114, 112, 111, 110, 109, 107, 104,
			103, 102, 101, 99,  98,  97,  94,  93,  91,  89,
			88,  87,  86,  85,  83,  82,  80,  79,  78,  76,
			75,  74,  73,  72,  70,  69,  68,  67,  66,  64,
			61,  60,  59,  58,  57,  56,  54,  53,  52,  51,
			50,  49,  48,  47,  45,  44,  43,  42,  41,  39,
			38,  36,  35,  34,  33,  32,  31,  30,  29,  28,
			27,  26,  25,  24,  23,  22,  21,  20,  19,  18,
			17,  15,  14,  13,  12,  11,  10,  9,   8,   7,
			6,   5,   4,   3,   2,   1,   0,   -1
		},
		(const int16_t[]) { /* pl[28] */
			247, 193, 130, 70, -1
		},
		(const int16_t[]) { /* pl[29] */
			216, 212, 203, 199, 198, 197, 194, 193,	192, 189,
			188, 185, 183, 178, 171, 168, 167, 166, 165, 164,
			162, 161, 158, 156, 154, 153, 152, 151, 148, 147,
			143, 139, 138, 137, 135, 132, 130, 127, 126, 125,
			121, 120, 119, 118, 115, 114, 112, 111,	110, 108,
			107, 106, 103, 101, 99,  98,  97,  94,  93,  89,
			88,  87,  86,  83,  82,  80,  78,  76,  75,  74,
			73,  72,  70,  69,  68,  67,  66,  64,  61,  60,
			59,  58,  57,  56,  55,  54,  53,  52, 	51,  50,
			49,  48,  47,  46,  45,  44,  43,  42,  41,  39,
			38,  35,  34,  33,  32,  31,  30,  29,  27,  26,
			25,  24,  23,  22,  21,  20,  19,  18,  17,  16,
			15,  14,  13,  11,  9,   8,   7,   6,   5,   4,
			3,   2,   0,   -1
		},
		(const int16_t[]) { /* pl[30] */
			272, 243, 229, 223, 216, 215, 210, 209,	207, 206,
			202, 199, 198, 196, 193, 192, 189, 188, 184, 183,
			174, 170, 169, 161, 159, 157, 156, 155, 153, 151,
			149, 147, 146, 145, 142, 140, 135, 131, 130, 129,
			126, 125, 123, 121, 119, 116, 112, 110,	108, 106,
			104, 103, 98,  96,  95,  93,  91,  90,  85,  84,
			79,  78,  74,  73,  72,  68,  65,  62,  59,  53,
			50,  45,  42,  41,  39,  38,  37,  36,  35,  32,
			30,  28,  27,  26,  25,  23,  21,  20,	19,  18,
			16,  15,  10,  9,   8,   6,   4,   2,   1,   0,
			-1
		},
		(const int16_t[]) { /* pl[31] */
			229, 216, 215, 213, 207, 206, 202, 198,	196, 195,
			189, 188, 183, 177, 174, 173, 169, 161, 160, 159,
			157, 155, 153, 151, 147, 146, 145, 144, 142, 141,
			131, 130, 129, 125, 124, 123, 122, 119, 117, 116,
			113, 112, 110, 105, 103, 100, 98,  97,	96,  95,
			94,  93,  92,  84,  81,  73,  72,  68,  65,  63,
			62,  59,  57,  53,  50,  41,  40,  39,  38,  37,
			36,  35,  32,  30,  27,  26,  25,  21,  20,  18,
			16,  15,  9,   8,   6,   4,   2,   1,	0,  -1
		},
		(const int16_t[]) { /* pl[32] */
			180, 178, 165, 159, 148, 146, 143, 128,	111, 99,
			96,  86,  81,  73,  71,  67,  62,  55,  53,  48,
			47,  43,  42,  31,  27,  7,   -1
		},
		(const int16_t[]) { /* pl[33] */
			228, 225, 222, 214, 213, 211, 207, 206,	203, 202,
			198, 197, 193, 189, 188, 183, 182, 181, 178, 174,
			173, 171, 169, 168, 167, 166, 165, 164, 163, 161,
			159, 158, 156, 155, 154, 153, 152, 148, 146, 145,
			144, 143, 142, 141, 139, 138, 136, 135,	134, 133,
			132, 130, 129, 128, 127, 126, 125, 124, 123, 121,
			119, 118, 117, 115, 114, 112, 111, 110, 109, 108,
			107, 106, 104, 103, 102, 101, 100, 99,  98,  97,
			96,  95,  94,  93,  92,  91,  88,  87,	86,  84,
			83,  82,  81,  80,  79,  78,  77,  76,  75,  73,
			72,  71,  70,  68,  67,  65,  64,  63,  62,  60,
			59,  58,  57,  56,  54,  52,  51,  49,  48,  47,
			46,  45,  44,  43,  42,  41,  40,  39,  38,  37,
			36,  35,  34,  33,  32,  30,  29,  26,  25,  24,
			23,  22,  21,  20,  19,  18,  17,  15,  13,  12,
			9,   8,   7,   6,   5,   4,   3,   2,   1,   0,
			-1
		},
		(const int16_t[]) { /* pl[34] */
			254, 250, 242, 215, 197, 184, 182, 180,	174, 173,
			171, 169, 166, 164, 163, 158, 154, 152, 140, 139,
			137, 136, 135, 132, 120, 118, 114, 108, 107, 106,
			99,  97,  94,  90,  89,  86,  83,  82,  80,  77,
			73,  61,  60,  58,  57,  53,  50,  48,	47,  45,
			33,  32,  28,  25,  23,  22,  21,  19,  17,  16,
			10,  9,   4,   3,   2,  -1
		},
		(const int16_t[]) { /* pl[35] */
			219, 215, 184, 181, 167, 151, 148, 145,	140, 137,
			136, 135, 134, 128, 116, 115, 109, 108, 106, 102,
			97,  94,  90,  87,  86,  85,  83,  75,  73,  69,
			61,  57,  56,  53,  51,  49,  41,  36,  33,  29,
			28,  27,  25,  24,  23,  20,  19,  17,	16,  14,
			12,  11,  10,  9,   6,   5,   2,   1,   -1
		},
		(const int16_t[]) { /* pl[36] */
			241, 233, 220, 184, 181, 167, 163, 151,	149, 148,
			145, 137, 136, 135, 134, 128, 115, 111, 109, 108,
			106, 102, 97,  94,  90,  87,  86,  85,  83,  82,
			77,  75,  71,  61,  60,  57,  56,  52,  51,  49,
			44,  41,  36,  33,  29,  26,  25,  24,	23,  20,
			19,  17,  12,  9,   7,   5,   4,   3,   2,   1,
			0,  -1
		},
		(const int16_t[]) { /* pl[37] */
			224, 220, 182, 181, 177, 173, 167, 166,	162, 160,
			148, 145, 144, 134, 128, 122, 115, 114, 113, 111,
			109, 105, 102, 87,  85,  82,  77,  75,  71,  69,
			60,  56,  51,  49,  41,  36,  32,  29,  24,  21,
			20,  14,  12,  10,  9,   6,   1,  -1
		}
	},
	.xin = 0,
	.xout = 0x3FFFFFFFFFull | (0xFFull << (0 + PLM_S_MAX)),
	.in_nb = 23,
	.out_nb = 38,
	.na_nb = 8,
	.na_bits = { 0, 1, 2, 3, 4, 5, 6, 7 }
};

