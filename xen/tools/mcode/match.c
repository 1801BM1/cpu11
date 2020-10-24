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

struct mc_plm {
	uint32_t pmask;
	uint32_t xmask;
	union {
		uint32_t s32dw[2];
		uint64_t smask;
	};
};

#define	MCODE_P_MIN	2		/* minimal product index used */
#define	MCODE_P_MAX	250		/* maximal product index used */
#define	MCODE_S_MAX	34		/* maximal SoP index used */

static struct mc_plm plm[MCODE_P_MAX];

static void mc_pmask_assign(uint32_t n, const char *text)
{
	uint32_t i, m, x;

	m = x = 0;
	for (i = 0; i < 31; i++) {
		switch (text[i]) {
		case '0':
			break;
		case '1':
			m |= 1 << (30 - i);
			break;
		case 'x':
			x |= 1 << (30 - i);
			break;
		default:
			printf("\r\nInvalid character: %s", text);
			exit(-1);
		}
	}
	plm[n].pmask = m;
	plm[n].xmask = ~x;
}

static void mc_smask_assign
	(int m, int a0, int a1, int a2, int a3, int a4,
		int a5, int a6, int a7, int a8, int a9)
{
	uint64_t set;

	set = 1ull << m;
	if (a0 >= 0)
		plm[a0].smask |= set;
	if (a1 >= 0)
		plm[a1].smask |= set;
	if (a2 >= 0)
		plm[a2].smask |= set;
	if (a3 >= 0)
		plm[a3].smask |= set;
	if (a4 >= 0)
		plm[a4].smask |= set;
	if (a5 >= 0)
		plm[a5].smask |= set;
	if (a6 >= 0)
		plm[a6].smask |= set;
	if (a7 >= 0)
		plm[a7].smask |= set;
	if (a8 >= 0)
		plm[a8].smask |= set;
	if (a9 >= 0)
		plm[a9].smask |= set;
}

void mc_load_vm1a(void)
{
	printf("Loading 1801BM1A microcode...\n");

	memset(plm, 0, sizeof(plm));
	mc_pmask_assign(2, "xxxxxxx111xxxxxxxxxxxxxx01xx111");
	mc_pmask_assign(3, "x00xxxxxxx00xxxx100xxxxx01x1010");
	mc_pmask_assign(4, "x00xxxxxxx0x0xxx100xxxxx011101x");
	mc_pmask_assign(5, "xxxxxxxxxxxxx111xxxxxxxx100x111");
	mc_pmask_assign(6, "0xxxx101xxxxxxxxxxxx1x1x000010x");
	mc_pmask_assign(7, "xxxxxx1xxxxxxxxxxxxxx1xx1001x0x");
	mc_pmask_assign(8, "x00xxxxxxxxx0xxx100xxxxx011x011");
	mc_pmask_assign(9, "x000101111xxxxxx001xxxxxx111110");
	mc_pmask_assign(10, "0xxxx1x1xxxxxxxxxxxx000x000010x");
	mc_pmask_assign(11, "xxxxx00111000xxx001xxxxx11111x0");
	mc_pmask_assign(12, "x111xxxxxxxxxxxx0xxxxxxx01x011x");
	mc_pmask_assign(13, "xxxxx1x01xxxxxxx1xxxxxxx011x11x");
	mc_pmask_assign(14, "x00xxxxxxxxxxxxx100xxxxx0110010");
	mc_pmask_assign(15, "xxxxx000xxxxxxxxxxxx1xxx0000100");
	mc_pmask_assign(16, "xxxxxxxxxx000111001xxxxxx111110");
	mc_pmask_assign(17, "1xxxx001xxxxxxxxxxxx0xxx00x010x");
	mc_pmask_assign(18, "x00xxxxxxxx00xxx100xxxxx0111010");
	mc_pmask_assign(19, "xxxxxxxxxxxx0xxxxxx1xxxx1010x0x");
	mc_pmask_assign(20, "0000000001000xxx00xxxxxx11111x0");
	mc_pmask_assign(21, "1xxxxx011xxxxxxxxxxxxxxx0111000");
	mc_pmask_assign(22, "0000100xxx000xxx00xxxxxx11111x0");
	mc_pmask_assign(23, "xxxxxxxx1xx0xxxxxxxxxxxx1001001");
	mc_pmask_assign(24, "10001000xxxxxxxx00xxxxxxx111110");
	mc_pmask_assign(25, "1xxxxxxxxxxxxxxxxxxx0xxx01x1110");
	mc_pmask_assign(26, "1xxxxxxxxxxx011xxx1xxxxx01x1010");
	mc_pmask_assign(27, "xxxxxxxxxxxxxxxx11xxxxxx0110111");
	mc_pmask_assign(28, "1000100xxxxxxxxx001xxxxxx111110");
	mc_pmask_assign(29, "0xxx0111xxxxxxxxxxxx101x00x010x");
	mc_pmask_assign(30, "0xxxx011xxxxxxxxxxxxx0xx00x010x");
	mc_pmask_assign(31, "x001xxxxxx00xxxxxxxxxxxx0111x10");
	mc_pmask_assign(32, "1xxxx011xxxxxxxxxxxxx0x000x010x");
	mc_pmask_assign(33, "x000xxxxxxxx0xxxx01xxxxx0110011");
	mc_pmask_assign(34, "xxxxxxxxxx000xxxxxxxxxxx1111011");
	mc_pmask_assign(35, "x000xx1010xxxxxx1xxxxxxx011x11x");
	mc_pmask_assign(36, "0000000000000101001xxxxx11111x0");
	mc_pmask_assign(37, "0xxxx1x0xxxxxxxxxxxx0x1x00x010x");
	mc_pmask_assign(38, "x001xxxxxx0x0xxxxxxxxxxx0111x10");
	mc_pmask_assign(39, "x100xxxxxxxxxxxx0xxxxxxx01x011x");
	mc_pmask_assign(40, "1xxxx101xxxxxxxxxxxxxx0x00x010x");
	mc_pmask_assign(41, "0xxxx101xxxxxxxxxxxx0x0x000010x");
	mc_pmask_assign(42, "x010xxxxxxxxxxxx0xxxxxxx01x011x");
	mc_pmask_assign(43, "xxxxxxxxxxxxx111xxxxxxxx01xx11x");
	mc_pmask_assign(44, "1xxxx100xxxxxxxxxxxxxx1x00x010x");
	mc_pmask_assign(45, "1xxxx111xxxxxxxxxxxxxxx000x010x");
	mc_pmask_assign(46, "x001xxxxxxx00xxxxxxxxxxx0111x10");
	mc_pmask_assign(47, "1xxxxx10xxxxxxxxxxxxxxx100x010x");
	mc_pmask_assign(48, "0000x1x111xxxxxx1xxx1xxx011x11x");
	mc_pmask_assign(49, "0xxxx1x0xxxxxxxxxxxx1x0x00x010x");
	mc_pmask_assign(50, "xxxxxxxxxxxxxxx1xxxxxxxx000101x");
	mc_pmask_assign(51, "x0000xxx1xxxxxxx111xxxxx0110111");
	mc_pmask_assign(52, "0xxxx110xxxxxxxxxxxxx1xx00x010x");
	mc_pmask_assign(53, "xxxxxxxxxxxxxxxxxxxxxxxx0100110");
	mc_pmask_assign(54, "xxxxxxxxxxxxxxxxxx1xxxxx0110x11");
	mc_pmask_assign(55, "xxxxx010xxxxxxxxxxxxx1xx00x010x");
	mc_pmask_assign(56, "10001101xx000xxx001xxxxxx111110");
	mc_pmask_assign(57, "101xxxxxxxxxxxxxxxxxxxxxx1x011x");
	mc_pmask_assign(58, "x000xxxxxxxxxxxx000xxxxx011x01x");
	mc_pmask_assign(59, "x000xx1101xxxxxx1xxxxxxx011011x");
	mc_pmask_assign(60, "x000x1x0x1xxxxxx1xxxxxxx011011x");
	mc_pmask_assign(61, "x0000xxxxxxxxxxx100xxxxx0110111");
	mc_pmask_assign(62, "0110xxxxxxxxxxxx0xxxxxxx01x011x");
	mc_pmask_assign(63, "x001xxxxxxxx0xxxxxxxxxxx0110011");
	mc_pmask_assign(64, "1x00x1x111xxxxxx1x1xxxxx0110111");
	mc_pmask_assign(65, "x000101xxx000xxx001xxxxx11111x0");
	mc_pmask_assign(66, "xxxxxxxx10xxxxxxxxxxxxxxx101111");
	mc_pmask_assign(67, "xxxxxxxxxxxxxxxx000xxxxx11111x0");
	mc_pmask_assign(68, "x000xxxxxxxxxxxxx01xxxxx011x010");
	mc_pmask_assign(69, "xxxx0xxx0xxxxxx11xxxx1xx10x1001");
	mc_pmask_assign(70, "1000x1x1x0xxxxxx1x1xxxxx0110111");
	mc_pmask_assign(71, "x001xxxxxxxxxxxxxxxxxxxx0110010");
	mc_pmask_assign(72, "xxxxxxx11xxxxxxxxxxxxxxxx101111");
	mc_pmask_assign(73, "xxxxxxxxxxxxx1xxxxxxxxxx0xx0x1x");
	mc_pmask_assign(74, "x0001100xx000xxx001xxxxx11111x0");
	mc_pmask_assign(75, "0111111xxxxxxxxx001xxxxx11111x0");
	mc_pmask_assign(76, "xxxxxxxxxxxxxxxx0xxxxxxx1110101");
	mc_pmask_assign(77, "x00xxxxxxxxxxxxx0xxxxxxx0110111");
	mc_pmask_assign(78, "xxxxxxxxxxxxxx1xxxxxxxxx0000x1x");
	mc_pmask_assign(79, "xxxxxxxxxxxxxxxxxxxxxxxx1110000");
	mc_pmask_assign(80, "xxxx0xxx10xxxxxxxxxxxxxx1001000");
	mc_pmask_assign(81, "xxxxxxxxxxxxxxx1xxxxxxxx0x01110");
	mc_pmask_assign(82, "000000001x000xxx001xxxxxx111110");
	mc_pmask_assign(83, "xxxx000xxxxxxxxxxxxxxxxx0111000");
	mc_pmask_assign(84, "0xxxxxxxxxxxxxxxxxxxxxxx01x1110");
	mc_pmask_assign(85, "xxxxxxxxxxxxx1xxxxxxxxxx0x1xx1x");
	mc_pmask_assign(86, "xxxxxxxxxxxxxxxxxxxxxxxx1100110");
	mc_pmask_assign(87, "xxxxxxxxxxxxxx1xxxxxxxxx0x01110");
	mc_pmask_assign(88, "1xxxxxxxxxxxxxxxxxxxxxxx1001x00");
	mc_pmask_assign(89, "xxxxxxxxxxxxxxx1xxxxxxxx001xx1x");
	mc_pmask_assign(90, "xxxxxxxxxxxxx1xxxxxxxxxx000101x");
	mc_pmask_assign(91, "0000000000000000001xxxxxx111110");
	mc_pmask_assign(92, "xxxxxxxx1xxxxxxxxxxxxxxxxx1100x");
	mc_pmask_assign(93, "xxxxxxxxxxxxx1xxxxxxxxxx0001110");
	mc_pmask_assign(94, "xxxxxxxxxxxx1xxxxxxxxxxx0010101");
	mc_pmask_assign(95, "xxxxxxx1xxxxxxxxxxxxxxxxx1001x1");
	mc_pmask_assign(96, "xxxxxxxx0xxxxxxxxxxxxxxxx101111");
	mc_pmask_assign(97, "x10xxxxxxxxxxxxxxxxxxxxx011001x");
	mc_pmask_assign(98, "xxxxxxxxxxxxxx1xxxxxxxxx000101x");
	mc_pmask_assign(99, "xxxxxxxxxxxxxxxxxxxxxxxx1100011");
	mc_pmask_assign(100, "xxxxxxxxxx1xxxxxxxxxxxxxx101010");
	mc_pmask_assign(101, "xxxxxxxxxxxxxxxxxxxxxxxx1000010");
	mc_pmask_assign(102, "xxxxxxx1xxxxxxxxxxxxxxxxxx1100x");
	mc_pmask_assign(103, "x000xx1000xxxxxx1xxxxxxx011011x");
	mc_pmask_assign(104, "xxxxxxxxxxxxxxxxx0xxxxxx1101x11");
	mc_pmask_assign(105, "xxxxxxxxxx101xxxxxxxxxxx0111x10");
	mc_pmask_assign(106, "xxxxxxxxx1xxxxxxxxxxxxxxxx1100x");
	mc_pmask_assign(107, "0000110111000xxx001xxxxxx111110");
	mc_pmask_assign(108, "xxxxxxxxxxxxxxxxxx1xxxxx1101000");
	mc_pmask_assign(109, "xxxxxxxxxxxxxxxx1xxxxxxx1110101");
	mc_pmask_assign(110, "xxxxxxxxxxxxxxxxxxxxxxxx0000x01");
	mc_pmask_assign(111, "x01xxxxxxxxxxxxxxxxxxxxx010011x");
	mc_pmask_assign(112, "xxxxxxx1xxxxxxxxxxxxxxxxx01010x");
	mc_pmask_assign(113, "xxxxxxxx1xxxxxxxxxxxxxxxx1001x1");
	mc_pmask_assign(114, "x000x1x1x1xxxxxxxxxxxxxx011011x");
	mc_pmask_assign(115, "xxxxxxxxxxxxxxx1xxxxxxxx0x00x1x");
	mc_pmask_assign(116, "xx00xxxxxxxxxxxxx1xxxxxx011001x");
	mc_pmask_assign(117, "0xxxxxxxxxxxxxxxxxxxxxxx01xx0xx");
	mc_pmask_assign(118, "0111100xxx000xxx001xxxxxx111110");
	mc_pmask_assign(119, "xxxxxxxxxxxxxxxxxxxxxxxx11x1111");
	mc_pmask_assign(120, "xxxxxxxxxxxxxx1xxxxxxxxx010xx1x");
	mc_pmask_assign(121, "xxxxxxxxxxxxxxxxxxxxxxxx100111x");
	mc_pmask_assign(122, "xxxx0xxxxx0xxxx0xxx0xxxx10x1001");
	mc_pmask_assign(123, "xxxxxxxxxxxxxxxxxxxxxxxx1010011");
	mc_pmask_assign(124, "xxxxxxxxxxxxxxxx10xxxxxxx111110");
	mc_pmask_assign(125, "1000000xxxxxxxxx001xxxxxx111110");
	mc_pmask_assign(126, "xxxxxxxxxxxx1xxxxxxxxxxx1010000");
	mc_pmask_assign(127, "xxxxxxxxxx011xxxxxxxxxxx0111x10");
	mc_pmask_assign(128, "x000xxxxxxxxxxxxx1xxxxxx0111x10");
	mc_pmask_assign(129, "xxxx101xxxxxxxxxxxxxxxxx0111000");
	mc_pmask_assign(130, "00000001xxxxxxxx001xxxxxx111110");
	mc_pmask_assign(131, "xxxxxxxxxx11xxxxxxxxxxxx0111x10");
	mc_pmask_assign(132, "xxxxxxxxxxxxxxxxxxxxxxxxx100101");
	mc_pmask_assign(133, "xxxx0xxx0xxxx0x1xxxxxxxx1001x00");
	mc_pmask_assign(134, "x000x00xxxxxxxxx1xxxxxxx0110111");
	mc_pmask_assign(135, "xxxxxxxxxxxxxxxxxxxxxxxx1101010");
	mc_pmask_assign(136, "0001xxxxxxxxxxxxxxxxxxxx010011x");
	mc_pmask_assign(137, "xxxxxxxxxxxxxxxx01xxxxxxx111110");
	mc_pmask_assign(138, "xxxxxxxxx1xxxxxxxxxxxxxxx101111");
	mc_pmask_assign(139, "0000000000001xxx001xxxxxx111110");
	mc_pmask_assign(140, "x000xx1111xxxxxx1xxxxxxx011011x");
	mc_pmask_assign(141, "xxxx0xxx0xxxxxx10xxxx1xx10x1001");
	mc_pmask_assign(142, "xxxxxxxxx1xxxxxxxxxxxxxxx1001x1");
	mc_pmask_assign(143, "xxxxxxxxxxxxxxxxxxxxxxxx1100001");
	mc_pmask_assign(144, "x000x1x0xxxxxxxx1xxxxxxx011011x");
	mc_pmask_assign(145, "xxxxxxxxxxxxxxxxxxxxxxxx1000110");
	mc_pmask_assign(146, "x000xx1001xxxxxx1xxxxxxx011011x");
	mc_pmask_assign(147, "1xxxxxxxxxxxxxxxxxxxxxxx01x1110");
	mc_pmask_assign(148, "xxxxxxxxxxxx1xxxxxxxxxxx0110011");
	mc_pmask_assign(149, "xxxxxxxxxxxxxxxxx1xxxxxx1101x11");
	mc_pmask_assign(150, "xxxxxxxxxxxxxxxxxxxxxxxx1100010");
	mc_pmask_assign(151, "xx1xxxxxxxxxxxxxxxxxxxxx011001x");
	mc_pmask_assign(152, "x01x000xxx000xxx001xxxxxx111110");
	mc_pmask_assign(153, "xxxxxxxxxxxxxxxxxxxxxxxx1010010");
	mc_pmask_assign(154, "xxxxxxxxxxxx0xxxxxxxxxxx00x0101");
	mc_pmask_assign(155, "xxxx011xxxxxxxxxxxxxxxxx0111000");
	mc_pmask_assign(156, "xxxx11xxxxxxxxxxxxxxxxxx0111000");
	mc_pmask_assign(157, "xxxx10xxxxxxxxxxxxxxxxxx100100x");
	mc_pmask_assign(158, "xxxxxxxxxxxxxxxxxxxxxxxx111x100");
	mc_pmask_assign(159, "xxxxxxxxxxxxxxxxxxxxxxxx011111x");
	mc_pmask_assign(160, "xxxxxxxxxxxxx0xxxxxxxxxx1010101");
	mc_pmask_assign(161, "x10xxxxxxxxxxxxxxxxxxxxx0111x10");
	mc_pmask_assign(162, "xxxxxxx0xxxxxxxxxxxxxxxx0010100");
	mc_pmask_assign(163, "xxxxxxxxxxxxxxx1xxxxxxxx01xxx1x");
	mc_pmask_assign(164, "xxxxxxxxxxx1xxxxxxxxxxxxx101010");
	mc_pmask_assign(165, "xxxxxxxxxxxxxxxxxxxxxxxx1100000");
	mc_pmask_assign(166, "xx11xxxxxxxxxxxxxxxxxxxx01x011x");
	mc_pmask_assign(167, "x000xx1110xxxxxx1xxxxxxx011011x");
	mc_pmask_assign(168, "x10xxxxxxxxxxxxx0xxxxxxx01x011x");
	mc_pmask_assign(169, "100xxxxxxxxxxxxxxxxxxxxx010011x");
	mc_pmask_assign(170, "1x0xxxxxxxxxxxxxxxxxxxxxx1x011x");
	mc_pmask_assign(171, "x000xx101xxxxxxx1xxxxxxx011011x");
	mc_pmask_assign(172, "xx10xxxxxxxxxxxxxxxxxxxx01x011x");
	mc_pmask_assign(173, "xxxxxxxxxxxxxxxxxxxxxxxx1000x11");
	mc_pmask_assign(174, "xx01000xxx000xxx001xxxxxx111110");
	mc_pmask_assign(175, "xxxxxxxxxxxxxxxx11xxxxxxx111110");
	mc_pmask_assign(176, "xxxxxxxxxxxxx1xxxxxxxxxx01xxx1x");
	mc_pmask_assign(177, "xxxxxxxxxxxxxxxxxxxxxxxx11x1100");
	mc_pmask_assign(178, "xxxxxx1xxxxxxxxxxxxxxxxx101xx00");
	mc_pmask_assign(179, "x000xx110xxxxxxx1xxxxxxx011011x");
	mc_pmask_assign(180, "xx1xxxxxxxxxxxxxxxxxxxxx0111x10");
	mc_pmask_assign(181, "x1x0000xxx000xxx001xxxxx11111x0");
	mc_pmask_assign(182, "xxxxxxxxxxxxxxxxxxxxxxxx110111x");
	mc_pmask_assign(183, "xxxxxxxxxxxxxxxx0xxxxxxx0110x11");
	mc_pmask_assign(184, "xxxxxx1xxxxxxxxxxxxxxxxx0111x01");
	mc_pmask_assign(185, "xxxxxxxxxxxxxxxxxx0xxxxx1101000");
	mc_pmask_assign(186, "xxxxxxxxxxxxxxxxxxxxxxxx10111x0");
	mc_pmask_assign(187, "xxxxxxxxxxxxxxxxx0xxxxxx011x01x");
	mc_pmask_assign(188, "xxxxxxxxxxxxxxxxxxxxxxxx1011111");
	mc_pmask_assign(189, "x000010xxxxxxxxx001xxxxxx111110");
	mc_pmask_assign(190, "xxxxxxxx1xxxxxxxxxxxxxxx10x100x");
	mc_pmask_assign(191, "0000110100xxxxxx001xxxxxx111110");
	mc_pmask_assign(192, "0xxx000011000xxx001xxxxxx111110");
	mc_pmask_assign(193, "0000000000000011001xxxxxx111110");
	mc_pmask_assign(194, "0000000000000100001xxxxxx111110");
	mc_pmask_assign(195, "xxxxxxx1xxxxxxxxxxxxxxxx10x100x");
	mc_pmask_assign(196, "00000000101xxxxx001xxxxxx111110");
	mc_pmask_assign(197, "x0000x1xxxxxxxxx001xxxxxx111110");
	mc_pmask_assign(198, "xxxxxxxxxxxxxx1xxxxxxxxx0x1xx1x");
	mc_pmask_assign(199, "xxxx0xxxx00xx0x0xxx1xxxx100100x");
	mc_pmask_assign(200, "0000000000000x10001xxxxxx111110");
	mc_pmask_assign(201, "0000000000000001001xxxxxx111110");
	mc_pmask_assign(202, "xxxx0xxxx00xx1x1xxxxxxxx1001000");
	mc_pmask_assign(203, "xxxxxxxxxxxxxxxxxxxxxxxx0110001");
	mc_pmask_assign(204, "0xxxx10xxxxxxxxxxxxxxxxx1001x00");
	mc_pmask_assign(205, "0000000001xxxxxx001xxxxxx111110");
	mc_pmask_assign(206, "xxxxxxxxxxxxxxxxxxxxxxxx101x100");
	mc_pmask_assign(207, "xxxx001xxxxxxxxxxxxxxxxx0111000");
	mc_pmask_assign(208, "xxxx0xxx0xxxxxx0xxx0xxxx1001x00");
	mc_pmask_assign(209, "xxxx0xxx00xxx1x1xxxxx0xx1001x01");
	mc_pmask_assign(210, "1000110100xxxxxx001xxxxxx111110");
	mc_pmask_assign(211, "xxxxxxxxxxxxxxxxxxxxxxxx1010001");
	mc_pmask_assign(212, "xxxxxxxxxxxxxxxxxxxxxxxx101110x");
	mc_pmask_assign(213, "1xxxxxxxxxxxxxxxxxxxxxxx10x1001");
	mc_pmask_assign(214, "xxxxxxxxxxxxx1xxxxxxxxxx1010101");
	mc_pmask_assign(215, "xxxx0xxx11xxxxxxxxxxxxxx1001x0x");
	mc_pmask_assign(216, "xxxx0xxxx00xx1x0xxx1xxxx1001000");
	mc_pmask_assign(217, "0xxxx1xxxxxxxxxxxxxxxxxx10x1001");
	mc_pmask_assign(218, "xxxxxxx00xxxx1x0xxx1xxxx1001001");
	mc_pmask_assign(219, "xxxx0xxxxx1xxxxxxxxxxxxx10x1001");
	mc_pmask_assign(220, "xxxxxxxxxxxxxxxxxxxxxxxx100110x");
	mc_pmask_assign(221, "xxxxxxxxxxxxxxxxxxxxxxxx0110010");
	mc_pmask_assign(222, "xxxxxxxxxxxxxxxxxxxxxxxx1111011");
	mc_pmask_assign(223, "xxxxxxxxxxxxxxxxxx0xxxxx01xx0xx");
	mc_pmask_assign(224, "x000100xxxxxxxxx001xxxxx11111x0");
	mc_pmask_assign(225, "xxxxxxxxxxxx0xxxxxxxxxxx1010x0x");
	mc_pmask_assign(226, "xxxxxx0xxxxxxxxxxxxxxxxx0111x01");
	mc_pmask_assign(227, "xxxxxxxxxx001xxxxxxxxxxx0111010");
	mc_pmask_assign(228, "xxxxxx1xxxxxxxxxxxxxxxxx1001x0x");
	mc_pmask_assign(229, "x0001100xxxxxxxx001xxxxx11111x0");
	mc_pmask_assign(230, "xxxx100xxxxxxxxxxxxxxxxx0111000");
	mc_pmask_assign(231, "xxxxxx0xxxxxxxxxxxxxxxxx1011x00");
	mc_pmask_assign(232, "xxxxxxxxxxxxxxxxxxxxxxxx1x01111");
	mc_pmask_assign(233, "xxxxxxxxxxxxxxxxxxxxxxxx1x0x1x1");
	mc_pmask_assign(234, "xxxxxxxxxxxxxxxxxxxxxxxx0110111");
	mc_pmask_assign(235, "0000000011xxxxxx001xxxxx11111x0");
	mc_pmask_assign(236, "xxxx010xxxxxxxxxxxxxxxxx0111000");
	mc_pmask_assign(237, "xxxxxxxxxxxx0xxxxxxxxxxx0110011");
	mc_pmask_assign(238, "xxxxxxxxxxxxxxxxxxxxxxxx01xx11x");
	mc_pmask_assign(239, "xxxxxxxxxx100xxxxxxxxxxx0111x10");
	mc_pmask_assign(240, "xxxxxxxxxx010xxxxxxxxxxx0111x10");
	mc_pmask_assign(241, "x10xxxxxxxxxxxxx001xxxxx11111x0");
	mc_pmask_assign(242, "x000110111xxxxxx001xxxxx11111x0");
	mc_pmask_assign(243, "xxxxxxxxxxxxxxxxxxxxxxxx0000100");
	mc_pmask_assign(244, "x000101xxxxxxxxx001xxxxx11111x0");
	mc_pmask_assign(245, "0111100xxxxxxxxx001xxxxx11111x0");
	mc_pmask_assign(246, "xxxxxxxxxxxxxxxxxxxxxxxx1011001");
	mc_pmask_assign(247, "x1x0xxxxxxxxxxxx001xxxxx11111x0");
	mc_pmask_assign(248, "x01xxxxxxxxxxxxx001xxxxxx111110");
	mc_pmask_assign(249, "xx01xxxxxxxxxxxx001xxxxxx111110");

	mc_smask_assign(0, 246, 243, 236, 234, 231, 230, 228, 226, 225, 220);
	mc_smask_assign(0, 219, 217, 215, 213, 212, 211, 209, 208, 207, 206);
	mc_smask_assign(0, 204, 203, 202, 201, 200, 199, 196, 195, 194, 193);
	mc_smask_assign(0, 191, 190, 188, 186, 185, 182, 179, 178, 177, 175);
	mc_smask_assign(0, 173, 172, 171, 168, 167, 166, 165, 162, 160, 159);
	mc_smask_assign(0, 158, 157, 154, 153, 150, 149, 147, 146, 144, 143);
	mc_smask_assign(0, 141, 140, 139, 137, 136, 133, 126, 124, 123, 122);
	mc_smask_assign(0, 119, 114, 112, 109, 108, 107, 104, 103, 101, 99);
	mc_smask_assign(0, 96, 94, 91, 86, 84, 79, 76, 75, 74, 69);
	mc_smask_assign(0, 67, 66, 65, 36, 34, 28, 22, 20, -1, -1);

	mc_smask_assign(1, 249, 248, 247, 246, 245, 244, 243, 242, 241, 240);
	mc_smask_assign(1, 239, 237, 236, 235, 234, 232, 231, 230, 229, 228);
	mc_smask_assign(1, 227, 226, 225, 224, 222, 221, 220, 218, 217, 216);
	mc_smask_assign(1, 215, 214, 213, 212, 211, 210, 209, 207, 206, 205);
	mc_smask_assign(1, 204, 203, 202, 201, 200, 199, 197, 196, 195, 194);
	mc_smask_assign(1, 193, 191, 189, 188, 186, 185, 184, 178, 177, 175);
	mc_smask_assign(1, 173, 169, 165, 164, 162, 160, 159, 158, 157, 156);
	mc_smask_assign(1, 155, 153, 150, 149, 148, 145, 143, 141, 139, 138);
	mc_smask_assign(1, 137, 135, 133, 132, 131, 130, 129, 127, 126, 125);
	mc_smask_assign(1, 124, 123, 122, 121, 112, 110, 109, 108, 105, 104);
	mc_smask_assign(1, 101, 100, 99, 96, 91, 86, 83, 82, 80, 79);
	mc_smask_assign(1, 76, 75, 69, 66, 43, 36, 2, -1, -1, -1);

	mc_smask_assign(2, 232, 218, 216, 196, 192, 181, 174, 154, 152, 119);
	mc_smask_assign(2, 118, 110, 107, 94, 74, 67, 65, 56, -1, -1);

	mc_smask_assign(3, 236, 230, 226, 208, 207, 206, 203, 200, 184, 182);
	mc_smask_assign(3, 180, 175, 161, 158, 156, 155, 154, 153, 151, 148);
	mc_smask_assign(3, 145, 137, 135, 131, 129, 128, 127, 126, 116, 105);
	mc_smask_assign(3, 101, 97, 94, 68, 58, 33, -1, -1, -1, -1);

	mc_smask_assign(4, 225, 215, 209, 202, 179, 178, 172, 169, 167, 146);
	mc_smask_assign(4, 144, 140, 103, 84, 72, -1, -1, -1, -1, -1);

	mc_smask_assign(5, 246, 231, 225, 218, 217, 216, 214, 212, 211, 209);
	mc_smask_assign(5, 206, 204, 202, 201, 200, 197, 196, 191, 189, 186);
	mc_smask_assign(5, 178, 175, 173, 162, 158, 157, 153, 145, 141, 139);
	mc_smask_assign(5, 134, 130, 126, 125, 123, 110, 107, 96, 88, 80);
	mc_smask_assign(5, 75, 74, 70, 66, 65, 36, 34, -1, -1, -1);

	mc_smask_assign(6, 249, 248, 247, 246, 245, 244, 243, 242, 241, 238);
	mc_smask_assign(6, 235, 232, 231, 229, 228, 225, 224, 223, 222, 220);
	mc_smask_assign(6, 219, 218, 217, 216, 215, 214, 213, 212, 211, 210);
	mc_smask_assign(6, 209, 208, 206, 205, 204, 202, 201, 200, 199, 197);
	mc_smask_assign(6, 196, 195, 194, 193, 191, 190, 189, 188, 186, 185);
	mc_smask_assign(6, 184, 182, 178, 177, 175, 173, 165, 164, 162, 160);
	mc_smask_assign(6, 158, 157, 156, 155, 154, 153, 150, 149, 148, 145);
	mc_smask_assign(6, 143, 141, 139, 137, 135, 133, 132, 131, 130, 129);
	mc_smask_assign(6, 127, 126, 125, 124, 123, 122, 121, 119, 117, 112);
	mc_smask_assign(6, 110, 109, 108, 105, 104, 101, 100, 99, 94, 91);
	mc_smask_assign(6, 86, 83, 82, 79, 76, 75, 69, 67, 36, -1);

	mc_smask_assign(7, 246, 243, 238, 236, 232, 231, 230, 228, 226, 225);
	mc_smask_assign(7, 222, 220, 219, 218, 217, 216, 215, 214, 213, 212);
	mc_smask_assign(7, 211, 209, 208, 207, 204, 203, 202, 201, 200, 196);
	mc_smask_assign(7, 192, 191, 188, 187, 186, 185, 184, 182, 181, 178);
	mc_smask_assign(7, 177, 175, 174, 173, 165, 164, 162, 160, 158, 156);
	mc_smask_assign(7, 155, 154, 153, 152, 150, 148, 145, 143, 139, 135);
	mc_smask_assign(7, 133, 132, 131, 129, 127, 126, 123, 118, 112, 110);
	mc_smask_assign(7, 109, 108, 107, 105, 101, 100, 88, 86, 83, 80);
	mc_smask_assign(7, 74, 65, 56, -1, -1, -1, -1, -1, -1, -1);

	mc_smask_assign(8, 246, 243, 238, 231, 228, 225, 222, 220, 219, 217);
	mc_smask_assign(8, 215, 214, 213, 212, 211, 209, 204, 202, 201, 195);
	mc_smask_assign(8, 191, 190, 188, 186, 185, 178, 177, 173, 165, 164);
	mc_smask_assign(8, 162, 160, 157, 154, 150, 149, 143, 139, 132, 124);
	mc_smask_assign(8, 123, 112, 109, 108, 104, 100, 99, 86, 83, 71);
	mc_smask_assign(8, 63, 46, 38, 31, 18, 14, 8, 4, 3, -1);

	mc_smask_assign(9, 246, 245, 243, 240, 239, 234, 232, 228, 225, 220);
	mc_smask_assign(9, 217, 215, 214, 213, 209, 204, 202, 201, 200, 197);
	mc_smask_assign(9, 196, 192, 191, 189, 188, 185, 181, 178, 177, 174);
	mc_smask_assign(9, 173, 169, 160, 159, 158, 152, 150, 149, 141, 138);
	mc_smask_assign(9, 137, 130, 125, 124, 112, 108, 107, 104, 101, 99);
	mc_smask_assign(9, 96, 88, 86, 83, 82, 80, 79, 76, 74, 69);
	mc_smask_assign(9, 66, 65, 56, 43, 36, 34, 2, -1, -1, -1);

	mc_smask_assign(10, 237, 234, 226, 225, 222, 221, 214, 211, 203, 186);
	mc_smask_assign(10, 184, 173, 165, 162, 160, 159, 158, 150, 148, 123);
	mc_smask_assign(10, 112, 36, -1, -1, -1, -1, -1, -1, -1, -1);

	mc_smask_assign(11, 246, 240, 237, 236, 232, 227, 226, 222, 221, 220);
	mc_smask_assign(11, 219, 218, 217, 216, 215, 213, 212, 211, 208, 207);
	mc_smask_assign(11, 204, 203, 200, 196, 192, 184, 183, 182, 181, 177);
	mc_smask_assign(11, 174, 173, 172, 169, 168, 166, 165, 162, 159, 158);
	mc_smask_assign(11, 156, 155, 154, 152, 148, 145, 144, 138, 136, 135);
	mc_smask_assign(11, 134, 132, 131, 127, 123, 118, 112, 110, 108, 107);
	mc_smask_assign(11, 100, 94, 86, 83, 74, 65, 64, 56, -1, -1);

	mc_smask_assign(12, 249, 248, 247, 246, 245, 244, 243, 242, 241, 240);
	mc_smask_assign(12, 239, 238, 237, 236, 235, 232, 231, 230, 229, 228);
	mc_smask_assign(12, 227, 226, 225, 224, 222, 221, 220, 219, 218, 217);
	mc_smask_assign(12, 216, 215, 214, 213, 212, 211, 210, 209, 208, 207);
	mc_smask_assign(12, 206, 205, 204, 203, 202, 201, 200, 199, 197, 196);
	mc_smask_assign(12, 195, 194, 193, 191, 190, 189, 188, 186, 185, 184);
	mc_smask_assign(12, 182, 178, 177, 175, 173, 165, 164, 162, 160, 158);
	mc_smask_assign(12, 157, 156, 155, 154, 153, 150, 149, 148, 145, 143);
	mc_smask_assign(12, 141, 139, 137, 135, 133, 132, 131, 130, 129, 127);
	mc_smask_assign(12, 126, 125, 124, 123, 122, 121, 119, 112, 110, 109);
	mc_smask_assign(12, 108, 105, 104, 101, 100, 99, 94, 91, 86, 83);
	mc_smask_assign(12, 82, 79, 76, 75, 69, 67, 36, -1, -1, -1);

	mc_smask_assign(13, 246, 243, 239, 237, 231, 230, 228, 226, 225, 222);
	mc_smask_assign(13, 221, 220, 219, 217, 214, 213, 212, 211, 209, 206);
	mc_smask_assign(13, 204, 203, 202, 201, 195, 191, 188, 186, 185, 184);
	mc_smask_assign(13, 183, 179, 178, 175, 173, 172, 171, 169, 168, 167);
	mc_smask_assign(13, 166, 165, 164, 162, 160, 159, 158, 157, 153, 150);
	mc_smask_assign(13, 149, 148, 147, 146, 143, 140, 139, 137, 136, 132);
	mc_smask_assign(13, 129, 126, 124, 123, 114, 112, 109, 105, 104, 103);
	mc_smask_assign(13, 101, 99, 96, 94, 84, 80, 72, 70, 66, -1);

	mc_smask_assign(14, 246, 244, 243, 242, 240, 239, 237, 236, 235, 232);
	mc_smask_assign(14, 230, 229, 228, 227, 226, 224, 222, 221, 220, 218);
	mc_smask_assign(14, 217, 216, 212, 211, 210, 209, 208, 207, 206, 205);
	mc_smask_assign(14, 204, 203, 202, 201, 200, 199, 196, 194, 193, 191);
	mc_smask_assign(14, 188, 185, 184, 182, 181, 179, 178, 177, 175, 174);
	mc_smask_assign(14, 173, 172, 171, 169, 167, 165, 164, 162, 159, 158);
	mc_smask_assign(14, 157, 156, 155, 154, 153, 152, 149, 148, 145, 143);
	mc_smask_assign(14, 141, 139, 137, 136, 135, 132, 131, 129, 127, 126);
	mc_smask_assign(14, 124, 123, 122, 121, 118, 114, 112, 110, 108, 105);
	mc_smask_assign(14, 104, 103, 101, 100, 99, 94, 83, 80, 77, 72);

	mc_smask_assign(15, 245, 237, 232, 227, 221, 218, 217, 216, 214, 211);
	mc_smask_assign(15, 206, 200, 197, 189, 185, 184, 181, 174, 173, 165);
	mc_smask_assign(15, 164, 162, 158, 155, 153, 152, 150, 148, 145, 143);
	mc_smask_assign(15, 139, 137, 131, 130, 129, 127, 126, 125, 123, 121);
	mc_smask_assign(15, 110, 109, 108, 105, 101, 100, 83, 77, -1, -1);

	mc_smask_assign(16, 248, 246, 243, 240, 237, 236, 232, 227, 226, 225);
	mc_smask_assign(16, 224, 222, 221, 220, 219, 218, 217, 216, 215, 214);
	mc_smask_assign(16, 213, 212, 211, 210, 208, 207, 206, 205, 204, 203);
	mc_smask_assign(16, 202, 201, 200, 199, 196, 194, 193, 192, 191, 188);
	mc_smask_assign(16, 184, 182, 181, 177, 175, 174, 173, 169, 168, 165);
	mc_smask_assign(16, 162, 160, 159, 158, 156, 155, 154, 153, 150, 148);
	mc_smask_assign(16, 147, 145, 144, 143, 139, 138, 137, 136, 135, 134);
	mc_smask_assign(16, 133, 132, 131, 127, 123, 122, 121, 118, 114, 112);
	mc_smask_assign(16, 110, 109, 108, 107, 103, 101, 100, 99, 96, 94);
	mc_smask_assign(16, 86, 84, 83, 80, 77, 74, 70, 65, 62, 59);
	mc_smask_assign(16, 56, 35, 9, -1, -1, -1, -1, -1, -1, -1);

	mc_smask_assign(17, 249, 248, 245, 244, 243, 242, 241, 240, 237, 236);
	mc_smask_assign(17, 235, 232, 229, 226, 225, 218, 216, 214, 210, 208);
	mc_smask_assign(17, 201, 200, 199, 196, 194, 193, 191, 184, 182, 181);
	mc_smask_assign(17, 179, 160, 156, 155, 153, 148, 146, 145, 135, 131);
	mc_smask_assign(17, 127, 122, 121, 110, 109, 101, 96, 91, 84, 82);
	mc_smask_assign(17, 75, 70, 62, 42, 39, 35, 28, 25, 23, 22);
	mc_smask_assign(17, 20, 12, -1, -1, -1, -1, -1, -1, -1, -1);

	mc_smask_assign(18, 215, 213, 205, 199, 194, 193, 170, 122, 96, 88);
	mc_smask_assign(18, 84, 72, 57, 24, 22, -1, -1, -1, -1, -1);

	mc_smask_assign(19, 246, 245, 243, 237, 233, 228, 227, 221, 219, 218);
	mc_smask_assign(19, 217, 216, 215, 214, 213, 212, 208, 206, 200, 199);
	mc_smask_assign(19, 197, 194, 193, 192, 189, 188, 186, 182, 181, 179);
	mc_smask_assign(19, 175, 174, 172, 171, 169, 168, 167, 166, 165, 164);
	mc_smask_assign(19, 160, 159, 154, 152, 147, 146, 145, 144, 143, 140);
	mc_smask_assign(19, 138, 136, 135, 133, 130, 125, 124, 123, 122, 121);
	mc_smask_assign(19, 119, 114, 112, 110, 107, 103, 100, 99, 94, 91);
	mc_smask_assign(19, 86, 84, 83, 82, 79, 77, 76, 74, 69, 67);
	mc_smask_assign(19, 66, 65, 61, 56, 34, 28, 22, 20, -1, -1);

	mc_smask_assign(20, 237, 227, 226, 224, 221, 215, 214, 210, 207, 206);
	mc_smask_assign(20, 205, 203, 202, 191, 186, 184, 183, 175, 164, 160);
	mc_smask_assign(20, 158, 154, 153, 150, 149, 148, 143, 139, 137, 126);
	mc_smask_assign(20, 111, 101, 100, 99, 96, 94, 84, 83, 80, 66);
	mc_smask_assign(20, 55, 52, 49, 47, 45, 44, 41, 40, 37, 32);
	mc_smask_assign(20, 30, 29, 17, 16, 15, 11, 10, 7, 6, 5);

	mc_smask_assign(21, 225, 209, 202, 199, 193, 178, 169, 122, 91, 72);
	mc_smask_assign(21, 24, -1, -1, -1, -1, -1, -1, -1, -1, -1);

	mc_smask_assign(22, 225, 209, 202, 199, 194, 193, 178, 171, 169, 168);
	mc_smask_assign(22, 166, 147, 136, 122, 114, 91, 86, 72, -1, -1);

	mc_smask_assign(23, 236, 232, 231, 230, 226, 218, 216, 214, 208, 207);
	mc_smask_assign(23, 206, 203, 200, 196, 192, 191, 185, 184, 183, 182);
	mc_smask_assign(23, 181, 180, 177, 175, 174, 161, 160, 158, 157, 156);
	mc_smask_assign(23, 155, 153, 152, 151, 150, 149, 148, 145, 143, 141);
	mc_smask_assign(23, 137, 135, 131, 129, 128, 127, 126, 124, 118, 116);
	mc_smask_assign(23, 110, 108, 107, 105, 104, 101, 99, 97, 96, 86);
	mc_smask_assign(23, 74, 71, 70, 69, 68, 65, 64, 63, 58, 56);
	mc_smask_assign(23, 54, 46, 38, 31, 27, -1, -1, -1, -1, -1);

	mc_smask_assign(24, 244, 243, 242, 240, 239, 237, 236, 235, 232, 230);
	mc_smask_assign(24, 229, 228, 227, 226, 224, 222, 221, 220, 219, 217);
	mc_smask_assign(24, 215, 213, 212, 211, 210, 208, 207, 205, 203, 200);
	mc_smask_assign(24, 199, 194, 193, 188, 183, 182, 181, 179, 177, 175);
	mc_smask_assign(24, 174, 173, 172, 171, 169, 168, 167, 166, 164, 160);
	mc_smask_assign(24, 159, 158, 154, 153, 152, 150, 148, 147, 146, 144);
	mc_smask_assign(24, 140, 138, 137, 136, 135, 133, 132, 131, 127, 122);
	mc_smask_assign(24, 121, 119, 118, 114, 112, 105, 103, 100, 94, 91);
	mc_smask_assign(24, 86, 84, 82, 79, 76, 69, 67, -1, -1, -1);

	mc_smask_assign(25, 243, 237, 231, 228, 226, 222, 221, 220, 219, 214);
	mc_smask_assign(25, 213, 212, 211, 204, 203, 191, 184, 183, 175, 173);
	mc_smask_assign(25, 167, 165, 162, 160, 159, 158, 150, 148, 146, 144);
	mc_smask_assign(25, 143, 140, 139, 123, 112, 99, 94, 80, 72, 66);
	mc_smask_assign(25, 64, 59, 53, 48, -1, -1, -1, -1, -1, -1);

	mc_smask_assign(26, 246, 243, 237, 228, 226, 225, 222, 221, 220, 219);
	mc_smask_assign(26, 217, 213, 212, 211, 206, 204, 203, 202, 191, 188);
	mc_smask_assign(26, 186, 184, 173, 167, 165, 162, 159, 158, 148, 147);
	mc_smask_assign(26, 137, 123, 112, 109, 95, 94, 84, 80, 72, 64);
	mc_smask_assign(26, 59, 13, -1, -1, -1, -1, -1, -1, -1, -1);

	mc_smask_assign(27, 246, 243, 237, 232, 226, 223, 222, 221, 218, 216);
	mc_smask_assign(27, 213, 211, 209, 208, 203, 202, 201, 200, 196, 192);
	mc_smask_assign(27, 188, 185, 184, 183, 182, 181, 175, 174, 173, 165);
	mc_smask_assign(27, 162, 159, 158, 157, 156, 155, 153, 152, 149, 148);
	mc_smask_assign(27, 145, 143, 139, 138, 135, 131, 129, 127, 126, 124);
	mc_smask_assign(27, 123, 118, 117, 113, 112, 110, 107, 105, 104, 101);
	mc_smask_assign(27, 99, 96, 88, 80, 79, 76, 74, 70, 65, 64);
	mc_smask_assign(27, 60, 56, 53, 51, 26, 21, -1, -1, -1, -1);

	mc_smask_assign(28, 246, 240, 239, 237, 236, 232, 231, 230, 228, 226);
	mc_smask_assign(28, 222, 221, 218, 217, 216, 213, 211, 209, 208, 206);
	mc_smask_assign(28, 203, 202, 201, 200, 196, 192, 191, 188, 185, 184);
	mc_smask_assign(28, 183, 182, 181, 178, 175, 174, 173, 171, 165, 164);
	mc_smask_assign(28, 162, 159, 158, 157, 156, 155, 153, 152, 149, 148);
	mc_smask_assign(28, 146, 145, 143, 142, 140, 137, 135, 131, 129, 127);
	mc_smask_assign(28, 126, 124, 123, 118, 112, 110, 107, 105, 104, 101);
	mc_smask_assign(28, 80, 74, 66, 65, 56, 53, 48, -1, -1, -1);

	mc_smask_assign(29, 246, 245, 237, 236, 231, 230, 227, 226, 221, 218);
	mc_smask_assign(29, 216, 214, 212, 209, 207, 206, 204, 203, 202, 200);
	mc_smask_assign(29, 192, 186, 185, 184, 181, 177, 174, 165, 164, 158);
	mc_smask_assign(29, 156, 155, 153, 152, 150, 135, 131, 129, 126, 110);
	mc_smask_assign(29, 108, 100, 88, 83, 82, 80, 61, 56, 34, 19);

	mc_smask_assign(30, 234, 225, 222, 219, 215, 214, 213, 209, 188, 186);
	mc_smask_assign(30, 177, 165, 162, 160, 154, 153, 150, 149, 132, 126);
	mc_smask_assign(30, 123, 109, 101, 88, 86, -1, -1, -1, -1, -1);

	mc_smask_assign(31, 249, 248, 247, 245, 244, 243, 242, 235, 234, 232);
	mc_smask_assign(31, 229, 228, 225, 220, 219, 218, 217, 216, 215, 214);
	mc_smask_assign(31, 213, 212, 211, 210, 209, 208, 204, 201, 200, 196);
	mc_smask_assign(31, 195, 191, 188, 186, 185, 182, 177, 176, 173, 165);
	mc_smask_assign(31, 162, 160, 157, 156, 154, 153, 150, 149, 145, 135);
	mc_smask_assign(31, 131, 126, 124, 123, 112, 110, 109, 108, 104, 102);
	mc_smask_assign(31, 101, 93, 90, 86, 85, 73, -1, -1, -1, -1);

	mc_smask_assign(32, 249, 248, 247, 245, 244, 243, 242, 235, 234, 232);
	mc_smask_assign(32, 229, 228, 225, 222, 220, 219, 218, 217, 216, 215);
	mc_smask_assign(32, 214, 213, 212, 211, 210, 208, 204, 201, 200, 198);
	mc_smask_assign(32, 196, 191, 190, 188, 186, 185, 182, 177, 173, 165);
	mc_smask_assign(32, 162, 160, 157, 156, 150, 145, 135, 132, 131, 124);
	mc_smask_assign(32, 123, 120, 110, 109, 108, 104, 98, 92, 88, 87);
	mc_smask_assign(32, 86, 78, -1, -1, -1, -1, -1, -1, -1, -1);

	mc_smask_assign(33, 249, 248, 247, 245, 244, 243, 242, 235, 234, 232);
	mc_smask_assign(33, 229, 228, 222, 220, 218, 217, 216, 215, 214, 212);
	mc_smask_assign(33, 211, 210, 208, 201, 196, 191, 186, 185, 182, 173);
	mc_smask_assign(33, 163, 160, 156, 150, 132, 131, 115, 112, 110, 108);
	mc_smask_assign(33, 106, 89, 86, 81, 50, -1, -1, -1, -1, -1);
}

/*
 * Reference matrix for the 1801VM1A/G
 */
static uint64_t mc_plm64_vm1(uint32_t src)
{
	struct mc_plm *p;
	uint64_t r;

	src ^= 0x7F;
	r = 0ull;
	for (p = plm + MCODE_P_MIN; p < (plm + MCODE_P_MAX); p++) {
		if (((src ^ p->pmask) & p->xmask) == 0)
			r |= p->smask;
	}
	r ^= (1 << 0) | (1 << 5) | (1 << 9) | (1 << 15) |
	     (1 << 19) | (1 << 24) | (1 << 29);
	return ~r & 0x3FFFFFFFFull;
}

/*
 * Builds next micro address from the lower part of PLM output
 */
static uint32_t mc_naf_vm1(uint32_t plm)
{
	uint32_t ma = 0;
	/*
	 *    plx[0]   ~mj[6]	- next microcode address
	 *    plx[5]    mj[5]
	 *    plx[9]    mj[4]
	 *    plx[15]   mj[3]
	 *    plx[19]  ~mj[2]
	 *    plx[24]  ~mj[1]
	 *    plx[29]  ~mj[0]
	 */
	if (!(plm & (1 << 29)))
		ma |= (1 << 0);
	if (!(plm & (1 << 24)))
		ma |= (1 << 1);
	if (!(plm & (1 << 19)))
		ma |= (1 << 2);
	if ((plm & (1 << 15)))
		ma |= (1 << 3);
	if ((plm & (1 << 9)))
		ma |= (1 << 4);
	if ((plm & (1 << 5)))
		ma |= (1 << 5);
	if (!(plm & (1 << 0)))
		ma |= (1 << 6);
	return ma;
}

/* Test the routine for compliance with reference matrix */
void mc_test_ref(enum plm_type type, enum opt_type opt, const char *text)
{
	static struct plm tpl;
	uint32_t a, m0, m1;
	uint64_t p0, p1;
	int ret;

	mc_load_vm1a();
	printf("Microcode match test: %s\n", text);
	ret = plm_init(&tpl, type);
	if (ret)
		exit(-1);
	ret = plm_opt(&tpl, opt);
	if (ret)
		exit(-1);

	for (a = 0x00000000; a < 0x80000000; a++) {
		if ((a << 8) == 0)
			printf("%08X ...\n", a);
		p0 = mc_plm64_vm1(a);
		p1 = plm_get(&tpl, a);
		m1 = p1 >> 48;
		m0 = mc_naf_vm1((uint32_t)p0);
		p1 = (p1 << 16) >> 16;
		if (p0 != p1) {
			printf("mcode: failed match %s: %08X: %10" PRIX64
			       " %10" PRIX64 "\n", text, a, p0, p1);
			exit(-1);
		}
		if (m0 != m1) {
			printf("mcode: failed match %s: %08X: %10" PRIX64
			       " %10" PRIX64 "", text, a, p0, p1);
			printf(" - %08X: %04X %04X\n", a, m0, m1);
			exit(-1);
		}
	}
}
