//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// MC1611 Microinstruction Decoder for LSI-11
// MC1621 Microinstruction Decoder for LSI-11
// MC1621 Programmable Translation Array (PTA) for LSI-11
// Compatible with DEC MCP-1631-07/10/15 MicROM
//______________________________________________________________________________
//
// Array 1/2 takes Location Counter(LC) and provides 7 bit Translation Code (TC)
//
module mcp_pta12
(
   input  rni,          // read next instruction
   input  [10:0] lc,    // location counter
   output [6:0] tc      // translation code
);

reg [6:0] tcr;
assign tc = rni ? 7'h4A : tcr;

always @(*)
case(lc)
   11'b00000110111: tcr <= 7'h25;   // 0067 / 037
   11'b00001000000: tcr <= 7'h13;   // 0100 / 040
   11'b00001000001: tcr <= 7'h51;   // 0101 / 041
   11'b00001001000: tcr <= 7'h32;   // 0110 / 048
   11'b00001001001: tcr <= 7'h13;   // 0111 / 049
   11'b00001001010: tcr <= 7'h51;   // 0112 / 04A
   11'b00001010000: tcr <= 7'h16;   // 0120 / 050
   11'b00001010001: tcr <= 7'h13;   // 0121 / 051
   11'b00001010010: tcr <= 7'h64;   // 0122 / 052
   11'b00001010011: tcr <= 7'h51;   // 0123 / 053
   11'b00001011010: tcr <= 7'h32;   // 0132 / 05A
   11'b00001011011: tcr <= 7'h13;   // 0133 / 05B
   11'b00001011100: tcr <= 7'h4C;   // 0134 / 05C
   11'b00001011111: tcr <= 7'h51;   // 0137 / 05F
   11'b00001100001: tcr <= 7'h23;   // 0141 / 061
   11'b00001100011: tcr <= 7'h13;   // 0143 / 063
   11'b00001101100: tcr <= 7'h32;   // 0154 / 06C
   11'b00001101101: tcr <= 7'h13;   // 0155 / 06D
   11'b00001110011: tcr <= 7'h32;   // 0163 / 073
   11'b00001110100: tcr <= 7'h13;   // 0164 / 074
   11'b00001111101: tcr <= 7'h32;   // 0175 / 07D
   11'b00001111110: tcr <= 7'h13;   // 0176 / 07E
   11'b00001111111: tcr <= 7'h52;   // 0177 / 07F
   11'b00010000000: tcr <= 7'h68;   // 0200 / 080
   11'b00010001010: tcr <= 7'h38;   // 0212 / 08C
   11'b00010010010: tcr <= 7'h38;   // 0222 / 092
   11'b00010011100: tcr <= 7'h38;   // 0234 / 09C
   11'b00010100100: tcr <= 7'h38;   // 0244 / 0A4
   11'b00010101110: tcr <= 7'h38;   // 0256 / 0AE
   11'b00010110101: tcr <= 7'h38;   // 0265 / 0B5
   11'b00010111111: tcr <= 7'h38;   // 0277 / 0BF
   11'b00011001000: tcr <= 7'h15;   // 0310 / 0C8
   11'b00011010001: tcr <= 7'h15;   // 0321 / 0D1
   11'b00011011001: tcr <= 7'h15;   // 0331 / 0D9
   11'b00011100010: tcr <= 7'h15;   // 0342 / 0E2
   11'b00011101011: tcr <= 7'h15;   // 0353 / 0EB
   11'b00011110010: tcr <= 7'h15;   // 0362 / 0F2
   11'b00011111100: tcr <= 7'h15;   // 0374 / 0FC
   11'b00100000000: tcr <= 7'h70;   // 0400 / 100
   11'b00100001010: tcr <= 7'h58;   // 0412 / 10A
   11'b00100001101: tcr <= 7'h2A;   // 0415 / 10D
   11'b00100010001: tcr <= 7'h2C;   // 0421 / 111
   11'b00100010010: tcr <= 7'h58;   // 0422 / 112
   11'b00100010100: tcr <= 7'h58;   // 0424 / 114
   11'b00100011100: tcr <= 7'h58;   // 0434 / 11C
   11'b00100100001: tcr <= 7'h49;   // 0441 / 121
   11'b00100100011: tcr <= 7'h58;   // 0443 / 123
   11'b00100100110: tcr <= 7'h58;   // 0446 / 126
   11'b00100101110: tcr <= 7'h58;   // 0456 / 12E
   11'b00100110101: tcr <= 7'h58;   // 0465 / 135
   11'b00100111111: tcr <= 7'h58;   // 0477 / 13F
   11'b00101000000: tcr <= 7'h0B;   // 0500 / 140
   11'b00101001000: tcr <= 7'h4A;   // 0510 / 148
   11'b00101001100: tcr <= 7'h4A;   // 0514 / 14C
   11'b00101010000: tcr <= 7'h4A;   // 0520 / 150
   11'b00101010100: tcr <= 7'h4A;   // 0524 / 154
   11'b00101011000: tcr <= 7'h4A;   // 0530 / 158
   11'b00101011100: tcr <= 7'h4A;   // 0534 / 15C
   11'b00101100000: tcr <= 7'h07;   // 0540 / 160
   11'b00101100010: tcr <= 7'h26;   // 0542 / 162
   11'b00101101000: tcr <= 7'h4A;   // 0550 / 168
   11'b00101101100: tcr <= 7'h4A;   // 0554 / 16C
   11'b00101110000: tcr <= 7'h4A;   // 0560 / 170
   11'b00101110100: tcr <= 7'h4A;   // 0564 / 174
   11'b00101111000: tcr <= 7'h4A;   // 0570 / 178
   11'b00110000000: tcr <= 7'h0E;   // 0600 / 180
   11'b00110001000: tcr <= 7'h4A;   // 0610 / 188
   11'b00110001100: tcr <= 7'h4A;   // 0614 / 18C
   11'b00110100000: tcr <= 7'h0D;   // 0640 / 1A0
   11'b00110101000: tcr <= 7'h4A;   // 0650 / 1A8
   11'b00110101100: tcr <= 7'h4A;   // 0654 / 1AC
   11'b00111101000: tcr <= 7'h4A;   // 0750 / 1E8
   11'b00111101100: tcr <= 7'h4A;   // 0754 / 1EC
   11'b01000000000: tcr <= 7'h4A;   // 1000 / 200
   11'b01000101000: tcr <= 7'h4A;   // 1050 / 228
   11'b01000101100: tcr <= 7'h4A;   // 1054 / 22C
   11'b01010100100: tcr <= 7'h54;   // 1244 / 2A4
   11'b01100101001: tcr <= 7'h1A;   // 1451 / 329
   11'b01101000010: tcr <= 7'h1C;   // 1502 / 342
   11'b01110110011: tcr <= 7'h1C;   // 1663 / 3B3
   11'b01111000111: tcr <= 7'h1C;   // 1707 / 3C7
   11'b01111010001: tcr <= 7'h1C;   // 1721 / 3D1
   11'b01111101000: tcr <= 7'h1C;   // 1750 / 3E8
   11'b10000011011: tcr <= 7'h34;   // 2033 / 41B
   11'b10000111011: tcr <= 7'h34;   // 2073 / 43B
   11'b10001010011: tcr <= 7'h19;   // 2123 / 453
   11'b10001111010: tcr <= 7'h19;   // 2172 / 47A
   11'b10010010000: tcr <= 7'h62;   // 2220 / 490
   11'b10010101100: tcr <= 7'h62;   // 2254 / 4AC
   11'b10010111100: tcr <= 7'h62;   // 2274 / 4BC
   11'b10011010000: tcr <= 7'h62;   // 2320 / 4D0
   11'b10100000110: tcr <= 7'h62;   // 2406 / 506
   11'b10100100111: tcr <= 7'h34;   // 2447 / 527
   11'b10101001110: tcr <= 7'h19;   // 2516 / 54E
   11'b10101101000: tcr <= 7'h29;   // 2550 / 568
   11'b10101101001: tcr <= 7'h29;   // 2551 / 569
   11'b10101101010: tcr <= 7'h29;   // 2552 / 56A
   11'b10101101011: tcr <= 7'h29;   // 2553 / 56B
   11'b10101111001: tcr <= 7'h13;   // 2571 / 579
   11'b10101000000: tcr <= 7'h34;   // 2500 / 540
   11'b10101100000: tcr <= 7'h34;   // 2540 / 560
   11'b10110000100: tcr <= 7'h34;   // 2604 / 584
   11'b10110001100: tcr <= 7'h34;   // 2614 / 58C
   11'b10110010010: tcr <= 7'h19;   // 2622 / 592
   11'b10110011000: tcr <= 7'h19;   // 2630 / 598
   11'b10110100100: tcr <= 7'h34;   // 2644 / 5A4
   11'b10110101100: tcr <= 7'h34;   // 2654 / 5AC
   11'b10111000000: tcr <= 7'h34;   // 2700 / 5C0
   11'b10111001000: tcr <= 7'h34;   // 2710 / 5C8
   11'b10111001100: tcr <= 7'h19;   // 2714 / 5CC
   11'b10111001111: tcr <= 7'h19;   // 2717 / 5CF
   11'b10111100000: tcr <= 7'h34;   // 2740 / 5E0
   11'b10111101000: tcr <= 7'h34;   // 2750 / 5E8
   11'b10111101100: tcr <= 7'h19;   // 2754 / 5EC
   default: tcr <= 7'h7f;
endcase
endmodule

//______________________________________________________________________________
//
// LoCations of translation
//
//  07: 160
//  0B: 140
//  0D: 1A0
//  0E: 180
//  13: 040 049 051 05B 063 06D 074 07E 579
//  15: 0C8 0D1 0D9 0E2 0EB 0F2 0FC
//  16: 050
// *19: 453 47A 54E 592 598 5CC 5CF 5EC
//  1A: 329
// *1C: 342 3B3 3C7 3D1 3E8
//  23: 061
//  25: 037
// *26: 162
// *29: 568 569 56A 56B
// *2A: 10D
//  2C: 111
//  32: 048 05A 06C 073 07D
// *34: 41B 43B 527 540 560 584 58C 5A4 5AC 5C0 5C8 5E0 5E8
//  38: 08A 092 09C 0A4 0AE 0B5 0BF
//  49: 121
// *4A: 150 154 158 15C 170 174 178 148 14C 168 16C 188 18C
//      1A8 1AC 1E8 1EC 200 228 22C
//  4C: 05C
//  51: 041 04A 053 05F
//  52: 07F
//  54: 2A4
//  58: 10A 112 114 11C 123 126 12E 135 13F
// *62: 4AC 4BC 490 4D0 506
//  64: 052
//  68: 080
//  70: 100
//
//______________________________________________________________________________
//
// Targets locations for the translation (depends on TSR and TR)
//
// 07: 1C0 1C4 1C8 1CC 1D0 1D4 1D8 1DC 1E0 1E4 1E8 1EC 1F0 1F4 1F8 1FC
// 0B: 200 204 208 20C 210 214 218 21C 220 224 228 22C 230 234 238 23C
// 0D: 240 244 248 24C 250 254 258 25C 260 264 268 26C 270 274 278 27C
// 0E: 280 284 288 28C 290 294 298 29C 2A0 2A4 2A8 2AC 2B0 2B4 2B8 2BC
// 13: 080 088 090 098 0A0 0A8 0B0 0B8 2C0 2C8 2D0 2D8 2E0 2E8 2F0 2F8
// 15: 002 012
// 16: 052
// 19: 568 569 56A 56B
// 1A: 163 343 3B4 3C8 3D2 3E9
// 1C: 31D
// 23: 05C
// 25: 020 029 040 064 07F 0E5 11D
// 26: 081 184 1C2 31D
// 29: load lc from return register
// 2A: 035 037 03D 040 041 042 048 04B 050 058 060 068 070 078 07F 09D 0B6 400 579 601
// 2C: 113
// 32: 04A
// 34: 5CF
// 38: 180 181 184 188 18C 190 194 198 19C 1B8 5FC 5FD
// 49: 124
// 4A: 081 10B 184 1BA 1C2 31D
// 4C: 047
// 51: 100 108 110 118 120 128 130 138
// 52: 0C0 0C8 0D0 0D8 0E0 0E8 0F0 0F8
// 54: 2A0
// 58: 1A0 1A1 1A4 1A8 1AC 1B0 1B4 1B8 1BC 5FC 5FD
// 62: 592
// 64: 041
// 68: 140 141 144 148 14C 150 154 158 15C 178 57C 57D
// 70: 160 161 164 168 16C 170 174 178 17C 57C 57D
//______________________________________________________________________________
//
// Known translation description
//
// 13: DMW - destination translation for EIS M0 (tr[5:3])
// 19: PSW - PSW translation that regenerates bit 7 and T-bit, 0x568+flags
// 1C: REF - handle DRAM refresh routine
// 26: QBR - query branch on interrupt requests
// 29: RET - load location counter from return register
// 2A: ID1 - decode upper byte of PDP-11 opcode
// 34: EII - EIS interrupt test (also used for fadd/fsub), 0x5CF on irq
// 4A: RNI - read next instruction
// 62: FII - FIS interrupt test for fmul and fdiv, 0x592 on irq
//______________________________________________________________________________
//
// Array 3/4
//
module mcp_pta34
(
   input  [15:0] tr,    // translation register high/low
   input  [7:1] irq,    // interrupt requests
   input  [6:0] tc,     // translation code
   input  [2:0] ts,     // translation status
   output [10:0] pta,   // programmable translation address
   output [2:0] tsr,    // translation status register
   output lra,          // load return address
   output lta,          // load translation address
   output ltsr          // load translation status register
);

function cmp
(
   input [17:0] ai,
   input [17:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

wire [99:0] p;
wire [7:0] tmx;
wire q;

assign tmx[7:0] = ts[2] ? tr[7:0] : tr[15:8];
assign q = (tr[14:12] == 3'b000) | (tr[14:12] == 3'b111);

assign p[0]  = cmp({q, ts[1:0], tc, tmx}, {1'b0, 2'bxx, 7'b0x0x0x0, 8'bxxxxxxxx});  // ** ID1
assign p[1]  = cmp({q, ts[1:0], tc, tmx}, {1'b0, 2'bxx, 7'b0x0x0x0, 8'bxxxx1xxx});  // -- ID1
assign p[2]  = cmp({q, ts[1:0], tc, tmx}, {1'b0, 2'bxx, 7'b0x0x0x0, 8'bxxxxx1xx});  // -- ID1
assign p[3]  = cmp({q, ts[1:0], tc, tmx}, {1'b0, 2'bxx, 7'b0x0x0x0, 8'bxxxxxx1x});  // -- ID1
assign p[4]  = cmp({q, ts[1:0], tc, tmx}, {1'b0, 2'bxx, 7'b0x0x0x0, 8'b10xx000x});  // -- ID1
assign p[5]  = cmp({q, ts[1:0], tc, tmx}, {1'b0, 2'bxx, 7'b0x0x0x0, 8'b1x0x000x});  // -- ID1
assign p[6]  = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b10xxxxxx});  // -- ID1
assign p[7]  = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b1x0xxxxx});  // -- ID1
assign p[8]  = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b10xxxxx1});  // -- ID1
assign p[13] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b10001101});  // ** ID1
assign p[14] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b0001xxxx});  // -* ID1
assign p[27] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b1x0xxxx1});  // -- ID1
assign p[28] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b00000000});  // ** ID1
assign p[30] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b01110xxx});  // ** ID1
assign p[32] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b01111010});  // *- ID1
assign p[33] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'bx0000xxx});  // *- ID1
assign p[36] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b0111111x});  // *- ID1
assign p[37] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b1000101x});  // ** ID1
assign p[38] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b10001100});  // ** ID1
assign p[39] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b0000101x});  // ** ID1
assign p[40] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b00001100});  // ** ID1
assign p[41] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b0111100x});  // ** ID1
assign p[42] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b00001101});  // ** ID1
assign p[43] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b0000100x});  // ** ID1
assign p[44] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b10001000});  // *- ID1
assign p[45] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b10001001});  // *- ID1
assign p[52] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x0x0, 8'b1111xxxx});  // *- ID1
                                                                                    //
assign p[9]  = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bx0x00xx, 8'bxxxx1xxx});  // -- 13, 51, 52 (43 not used)
assign p[10] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bx0x00xx, 8'bxxx1xxxx});  // -- 13, 51, 52 (43 not used)
assign p[11] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bx0x00xx, 8'bxx1xxxxx});  // -- 13, 51, 52 (43 not used)
assign p[12] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00x00xx, 8'bxxxxxxxx});  // ** 13
assign p[15] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00x00xx, 8'bxxxxx11x});  // -- 13
assign p[31] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'b10, 7'b00x00xx, 8'bxxxxxxxx});  // -- 13
assign p[51] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bx0x000x, 8'bxxxxxxxx});  // ** 51
assign p[54] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bx0x000x, 8'bxxxxx11x});  // -- 51
assign p[66] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bx0x00x0, 8'bxxxxxxxx});  // *- 52
                                                                                    //
assign p[16] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'bxxx1xxxx});  // -- 38, 58, 68, 70
assign p[17] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'bxx1xxxxx});  // -- 38, 58, 68, 70
assign p[18] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'bx1xxxxxx});  // -- 38, 58, 68, 70
assign p[20] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'bxxxxx1xx});  // -- 38, 58, 68, 70
assign p[21] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'bxxxxxxx1});  // -- 38, 58, 68, 70
assign p[23] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'b1110xxxx});  // -- 38, 58, 68, 70
assign p[24] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'b00000000});  // -- 38, 58, 68, 70
assign p[76] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'b01110x1x});  // -- 38, 58, 68, 70
assign p[77] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxxx000, 8'b01110x0x});  // -- 38, 58, 68, 70
assign p[19] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxxx0000, 8'bxxxxxxxx});  // ** 70
assign p[22] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bxx0x000, 8'bxxxxxxxx});  // ** 68
assign p[25] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bx0xx000, 8'bxxxxxxxx});  // ** 58
assign p[26] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0xxx000, 8'bxxxxxxxx});  // ** 38
                                                                                    //
assign p[29] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x00x0x, 8'b00000xxx});  // *- 25
assign p[35] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x00x0x, 8'b00000x10});  // *- 25
assign p[63] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x00x0x, 8'b10000xxx});  // *- 25
assign p[64] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x00x0x, 8'b01xxxxxx});  // *- 25
assign p[65] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x00x0x, 8'b11xxxxxx});  // *- 25
assign p[78] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x00x0x, 8'b1010xxxx});  // *- 25
assign p[79] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x00x0x, 8'b1011xxxx});  // *- 25
                                                                                    //
assign p[55] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b000xxxx, 8'b1xxxxxxx});  // -- 07, 0B, 0D, 0E
assign p[56] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b000xxxx, 8'bx1xxxxxx});  // -- 07, 0B, 0D, 0E
assign p[57] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bx1, 7'b000xxxx, 8'bxxxxxxxx});  // -- 07, 0B, 0D, 0E
assign p[58] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'b1x, 7'b000xxxx, 8'bxxxxxxxx});  // -- 07, 0B, 0D, 0E
assign p[59] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0000xxx, 8'bxxxxxxxx});  // *- 07
assign p[60] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b000x0xx, 8'bxxxxxxxx});  // *- 0B
assign p[61] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b000xx0x, 8'bxxxxxxxx});  // *- 0D
assign p[62] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b000xxx0, 8'bxxxxxxxx});  // *- 0E
                                                                                    //
assign p[34] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'bx0x0x00, 8'bxxxxxxxx});  // *- 54
assign p[46] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bx1, 7'b0xx00x0, 8'bxxxxxxxx});  // *- 32
assign p[47] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bx1, 7'b00x0xx0, 8'bxxxxxxxx});  // *- 16
assign p[48] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bx1, 7'b0x000xx, 8'bxxxxxxxx});  // *- 23
assign p[49] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'b1x, 7'bxx00x00, 8'b1xxxxxxx});  // *- 64
assign p[50] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'b1x, 7'bx00xx00, 8'b1xxxxxxx});  // *- 4C
assign p[71] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'b1x, 7'b0x0xx00, 8'bxxxxxxxx});  // *- 2C
assign p[72] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'b1x, 7'bx00x00x, 8'bxxxxxxxx});  // *- 49
assign p[74] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b0x0x00x, 8'bxxxxxxxx});  // -- DMW (LRA)
                                                                                    //
assign p[67] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bx1, 7'b00x0x0x, 8'bxxxxxxxx});  // *- 15
assign p[68] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'b11, 7'b00x0x0x, 8'b11xxxxxx});  // *- 15
assign p[53] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx00x, 8'b1xxxxxxx});  // -- PSW
assign p[70] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx00x, 8'bxxx1xxxx});  // -- PSW
assign p[75] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx00x, 8'bxxxxxxxx});  // *- PSW
                                                                                    //
assign p[83] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx0x0, 8'b0000xxxx});  // *- 1A
assign p[73] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx0x0, 8'b0001xxxx});  // *- 1A
assign p[82] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx0x0, 8'b0010xxxx});  // *- 1A
assign p[81] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx0x0, 8'b0100xxxx});  // *- 1A
assign p[80] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx0x0, 8'b0110xxxx});  // *- 1A
assign p[69] = cmp({q, ts[1:0], tc, tmx}, {1'bx, 2'bxx, 7'b00xx0x0, 8'b1000xxxx});  // *- 1A
//
// Interrupt register irq[7:1]
//  i6   - interrupt handling by microcode at 0x604 (for both event and device)
//  i5   - interrupt enabled (for both event and device)
//  i4   - trace trap
//  i3   - memory refresh request
//  i2   - power fail, bus fault (distinguish by a FAST DATA IN cycle)
//  i1   - event interrupt (line time clock)
//  i0   - device vector interrupt
//
assign p[95] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b00xxx00, 8'bxxxx1xxx}); // REF
assign p[84] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bxx000x0, 8'bxx1xxx01}); // FII
assign p[88] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bxx000x0, 8'bxx1xxx1x}); // FII
assign p[85] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b0xx0x00, 8'bxx1xxx01}); // EII
assign p[86] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b0xx0x00, 8'bxx1xxx1x}); // EII
assign p[87] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b0x00xx0, 8'bxx100001}); // QBR
assign p[90] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b0x00xx0, 8'bxx10001x}); // QBR
assign p[91] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b0x00xx0, 8'bxxx001xx}); // QBR
assign p[92] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b0x00xx0, 8'bxxxx1xxx}); // QBR
                                                                                              //
assign p[89] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx00x0x0, 8'bx00000xx}); // RNI
assign p[99] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx00x0x0, 8'bx0x00000}); // RNI
assign p[93] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx00x0x0, 8'bx0100001}); // RNI
assign p[96] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx00x0x0, 8'bx010001x}); // RNI
assign p[97] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx00x0x0, 8'bx0x001xx}); // RNI
assign p[98] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx00x0x0, 8'bx0xx1xxx}); // RNI
assign p[94] = cmp({q, ts[1:0], tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx00x0x0, 8'bx0x10xxx}); // RNI

assign lra = p[74];
assign lta = p[0]  | p[12] | p[13] | p[19] | p[22] | p[25] | p[26] | p[28] | p[29] | p[30]
           | p[32] | p[33] | p[34] | p[35] | p[36] | p[37] | p[38] | p[39] | p[40] | p[41]
           | p[42] | p[43] | p[44] | p[45] | p[46] | p[47] | p[48] | p[49] | p[50] | p[51]
           | p[52] | p[59] | p[60] | p[61] | p[62] | p[63] | p[64] | p[65] | p[66] | p[67]
           | p[68] | p[69] | p[71] | p[72] | p[73] | p[75] | p[78] | p[79] | p[80] | p[81]
           | p[82] | p[83] | p[84] | p[85] | p[86] | p[87] | p[88] | p[89] | p[90] | p[91]
           | p[92] | p[93] | p[94] | p[95] | p[96] | p[97] | p[98] | p[99];

assign ltsr = p[0]  | p[12] | p[13] | p[14] | p[19] | p[22] | p[25] | p[26] | p[28] | p[30]
            | p[37] | p[38] | p[39] | p[40] | p[41] | p[42] | p[43] | p[51] | p[84] | p[85]
            | p[86] | p[87] | p[88] | p[89] | p[90] | p[91] | p[92] | p[93] | p[94] | p[95]
            | p[96] | p[97] | p[98] | p[99];

assign tsr[0] = p[6]  | p[7]  | p[21] | p[43] | p[53];
assign tsr[1] = p[8]  | p[14] | p[15] | p[20] | p[27] | p[54];
assign tsr[2] = p[0]  | p[13] | p[19] | p[22] | p[25] | p[26] | p[28]
              | p[30] | p[37] | p[38] | p[39] | p[40] | p[41] | p[42] | p[43];

assign pta[0] = p[4] | p[5] | p[13] | p[24] | p[30] | p[33] | p[35] | p[36] | p[37] | p[38]
              | p[43] | p[45] | p[49] | p[50] | p[52] | p[64] | p[69] | p[70] | p[71] | p[77]
              | p[78] | p[79] | p[80] | p[83] | p[85] | p[86] | p[87] | p[89] | p[92] | p[93]
              | p[95] | p[98] | p[99];
assign pta[1] = p[28] | p[36] | p[42] | p[43] | p[44] | p[46] | p[47] | p[50] | p[53] | p[64]
              | p[67] | p[68] | p[69] | p[71] | p[81] | p[83] | p[84] | p[85] | p[86] | p[88]
              | p[89] | p[90] | p[94] | p[96] | p[99];
assign pta[2] = p[13] | p[16] | p[33] | p[43] | p[44] | p[45] | p[48] | p[50] | p[55] | p[63]
              | p[64] | p[72] | p[73] | p[78] | p[79] | p[85] | p[86] | p[91] | p[92] | p[95]
              | p[97] | p[98];
assign pta[3] = p[3] | p[9] | p[13] | p[17] | p[30] | p[35] | p[36] | p[43] | p[45] | p[46]
              | p[48] | p[56] | p[64] | p[75] | p[78] | p[80] | p[82] | p[85] | p[86] | p[89]
              | p[92] | p[94] | p[95] | p[98] | p[99];
assign pta[4] = p[2] | p[10] | p[13] | p[18] | p[30] | p[33] | p[43] | p[44] | p[45] | p[47]
              | p[48] | p[57] | p[64] | p[68] | p[71] | p[73] | p[78] | p[81] | p[84] | p[88]
              | p[92] | p[94] | p[95] | p[98];
assign pta[5] = p[1] | p[11] | p[13] | p[19] | p[23] | p[25] | p[29] | p[30] | p[33] | p[34]
              | p[43] | p[44] | p[58] | p[63] | p[64] | p[72] | p[73] | p[75] | p[76] | p[77]
              | p[79] | p[80] | p[83] | p[94];
assign pta[6] = p[0] | p[19] | p[22] | p[30] | p[31] | p[36] | p[37] | p[38] | p[39] | p[40]
              | p[41] | p[42] | p[43] | p[46] | p[47] | p[48] | p[49] | p[50] | p[59] | p[61]
              | p[63] | p[64] | p[65] | p[66] | p[69] | p[75] | p[76] | p[77] | p[79] | p[80]
              | p[81] | p[82] | p[83] | p[85] | p[86] | p[90] | p[96];
assign pta[7] = p[12] | p[25] | p[26] | p[34] | p[44] | p[45] | p[59] | p[62] | p[66] | p[73]
              | p[79] | p[80] | p[81] | p[82] | p[84] | p[85] | p[86] | p[87] | p[88] | p[90]
              | p[91] | p[93] | p[94] | p[96] | p[97];
assign pta[8] = p[19] | p[22] | p[25] | p[26] | p[30] | p[51] | p[59] | p[69] | p[71] | p[72]
              | p[73] | p[75] | p[78] | p[80] | p[81] | p[82] | p[83] | p[84] | p[85] | p[86]
              | p[88] | p[89] | p[90] | p[91] | p[92] | p[94] | p[95] | p[96] | p[97] | p[98]
              | p[99];
assign pta[9] = p[31] | p[34] | p[52] | p[60] | p[61] | p[62] | p[69] | p[73] | p[80] | p[81]
              | p[82] | p[92] | p[95] | p[98];
assign pta[10] = p[30] | p[32] | p[52] | p[75] | p[76] | p[77] | p[84] | p[85] | p[86] | p[88];

endmodule

//______________________________________________________________________________
//
module mcp_pta
(
   input  rni,          // read next instruction
   input  [10:0] lc,    // location counter
   input  [15:0] tr,    // translation register
   input  [2:0] ts,     // translation status
   input  [7:1] irq,    // interrupt requests
   output [10:0] pta,   // programmable translation address
   output [2:0] tsr,    // translation status register
   output lra,          // load return address
   output lta,          // load translation address
   output ltsr          // load translation status register
);

wire [6:0] tc;

mcp_pta12 pta12
(
   .rni(rni),
   .lc(lc),
   .tc(tc)
);

mcp_pta34 pta34
(
   .tr(tr),
   .irq(irq),
   .tc(tc),
   .ts(ts),
   .pta(pta),
   .tsr(tsr),
   .lra(lra),
   .lta(lta),
   .ltsr(ltsr)
);
endmodule

//______________________________________________________________________________
//
// Decoding microinstruction array for 1621 (Control Chip)
//
module mcp_plc
(
   input  q,            // Q input
   input  [15:0] mir,   // microinstruction
   output [19:0] plm    // matrix output
);

wire [23:0]pl;

function cmp
(
   input [8:0] ai,
   input [8:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign pl[0]  = cmp({q, mir[15:8]}, 9'b0000xxxxx); // jmp/jxx/rfs
assign pl[20] = cmp({q, mir[15:8]}, 9'b011110x1x); // riw/wiw
assign pl[21] = cmp({q, mir[15:8]}, 9'b01110xx1x); // isw/ltr
assign pl[22] = cmp({q, mir[15:8]}, 9'b0110xxx1x); // word ops
assign pl[23] = cmp({q, mir[15:8]}, 9'b010xxxx1x); // word ops

assign pl[1]  = cmp({q, mir[15:8]}, 9'b000000xxx); // jmp
assign pl[2]  = cmp({q, mir[15:8]}, 9'b00001xxxx); // jxx
assign pl[3]  = cmp({q, mir[15:8]}, 9'b000001xxx); // rfs
assign pl[4]  = cmp({q, mir[15:8]}, 9'bx111000xx); // ib/iw
assign pl[5]  = cmp({q, mir[15:8]}, 9'bx1111110x); // ob/ow/os
assign pl[6]  = cmp({q, mir[15:8]}, 9'b011101110); // ltr
assign pl[7]  = cmp({q, mir[15:8]}, 9'bx11111110); // os
assign pl[8]  = cmp({q, mir[15:8]}, 9'b01110001x); // iw
assign pl[9]  = cmp({q, mir[15:8]}, 9'b011110xx1); // wixx
assign pl[10] = cmp({q, mir[15:8]}, 9'bx111110x1); // ob
assign pl[11] = cmp({q, mir[15:8]}, 9'bx11111100);
assign pl[12] = cmp({q, mir[15:8]}, 9'bx01110000);
assign pl[13] = cmp({q, mir[15:8]}, 9'bx01110001);
assign pl[14] = cmp({q, mir[15:8]}, 9'bx01110100);
assign pl[15] = cmp({q, mir[15:8]}, 9'b0111110xx); // r/w/o
assign pl[16] = cmp({q, mir[15:8]}, 9'b011110xxx); // rixx/wixx
assign pl[17] = cmp({q, mir[15:8]}, 9'b011110xx0); // rixx
assign pl[18] = cmp({q, mir[15:8]}, 9'bx111110x0); // r/ra
assign pl[19] = cmp({q, mir[15:8]}, 9'bx1111101x); // ra/wa

assign plm[19:1] = pl[19:1];
assign plm[0] = pl[0] | pl[20] | pl[21] | pl[22] | pl[23];
endmodule

//______________________________________________________________________________
//
// Decoding microinstruction array for 1611 (Data Chip)
//
module mcp_pld
(
   input  inpl,         // input enable
   input  [7:0] psw,    // PSW flags
   input  [15:0] mir,   // microinstruction
   output [20:0] pld    // matrix output, C3 latch
);

wire [55:0] p;
wire [20:0] pl;
wire [20:0] pl_n;

function cmp
(
   input [9:0] ai,
   input [9:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[0]  = cmp({inpl, psw[0], mir[15:8]}, 10'bxx01110011);
assign p[1]  = cmp({inpl, psw[0], mir[15:8]}, 10'bxx0111011x);
assign p[2]  = cmp({inpl, psw[0], mir[15:8]}, 10'bxx01110010);
assign p[3]  = cmp({inpl, psw[0], mir[15:8]}, 10'bxx11011xxx);
assign p[4]  = cmp({inpl, psw[0], mir[15:8]}, 10'bxx11100x0x);
assign p[5]  = cmp({inpl, psw[0], mir[15:8]}, 10'bxx11100x1x);
assign p[6]  = cmp({inpl, psw[0], mir[15:8]}, 10'b0x111101xx);
assign p[7]  = cmp({inpl, psw[0], mir[15:8]}, 10'b0x100101xx);
assign p[8]  = cmp({inpl, psw[0], mir[15:8]}, 10'b0110x010xx);
assign p[9]  = cmp({inpl, psw[0], mir[15:8]}, 10'b00101110xx);
assign p[10] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x0011xxxx);
assign p[11] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x111100xx);
assign p[12] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x10110xxx);
assign p[13] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x1001x0xx);
assign p[14] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx000xxxxx);
assign p[15] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx0010xxxx);
assign p[16] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx0011xxxx);
assign p[17] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx0100xxxx);
assign p[18] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx0101xxxx);
assign p[19] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx0110xxxx);
assign p[20] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx0111xxxx);
assign p[21] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx011100xx);
assign p[22] = cmp({inpl, psw[0], mir[15:8]}, 10'bxxx1110010);
assign p[23] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx0111010x);
assign p[24] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx01110110);
assign p[25] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx01110111);
assign p[26] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx01111xxx);
assign p[27] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx10000xxx);
assign p[28] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx10001xxx);
assign p[29] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx10010xxx);
assign p[30] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx10011xxx);
assign p[31] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx1010xxxx);
assign p[32] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx1011x0xx);
assign p[33] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx101101xx);
assign p[34] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx101111xx);
assign p[35] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx110000xx);
assign p[36] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx110001xx);
assign p[37] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx110010xx);
assign p[38] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx110011xx);
assign p[39] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx110100xx);
assign p[40] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx110101xx);
assign p[41] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx11011xxx);
assign p[42] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx11100xxx);
assign p[43] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx111x1xxx);
assign p[44] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx11110xxx);
assign p[45] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x1xxxxxxx);
assign p[46] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx10xxxx0x);
assign p[47] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx1111xx0x);
assign p[48] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx10xxxxx1);
assign p[49] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx1x0xxxx1);
assign p[50] = cmp({inpl, psw[0], mir[15:8]}, 10'bxx1xx0xxx1);
assign p[51] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x000xxxxx);
assign p[52] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x11110x1x);
assign p[53] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x1110xx1x);
assign p[54] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x110xxx1x);
assign p[55] = cmp({inpl, psw[0], mir[15:8]}, 10'b0x10xxxx1x);

assign pl[12:0] = 13'b0000000000000;
assign pl[13] = p[8] | p[9] | p[10] | p[11] | p[12] | p[13];
assign pl[14] = p[6] | p[7];
assign pl[15] = p[0];
assign pl[16] = p[1];
assign pl[17] = p[2];
assign pl[18] = p[3];
assign pl[19] = p[4];
assign pl[20] = p[5];

assign pl_n[0]  = p[14] | p[16] | p[17] | p[18] | p[19] | p[21] | p[23] | p[24] | p[26] | p[27]
                | p[29] | p[30] | p[32] | p[33] | p[35] | p[36] | p[37] | p[38] | p[39] | p[40]
                | p[41] | p[42] | p[43] | p[44];
assign pl_n[1]  = p[14] | p[15] | p[17] | p[18] | p[19] | p[21] | p[23] | p[24] | p[26] | p[27]
                | p[28] | p[29] | p[30] | p[31] | p[34] | p[35] | p[36] | p[37] | p[38] | p[39]
                | p[40] | p[41] | p[42] | p[43] | p[44];
assign pl_n[2]  = p[14] | p[15] | p[16] | p[17] | p[18] | p[19] | p[20] | p[27] | p[29] | p[30]
                | p[31] | p[32] | p[33] | p[35] | p[36] | p[37] | p[38] | p[39] | p[40] | p[41]
                | p[42] | p[43] | p[44];
assign pl_n[3]  = p[14] | p[15] | p[17] | p[18] | p[19] | p[21] | p[23] | p[24] | p[26] | p[27]
                | p[28] | p[29] | p[31] | p[35] | p[36] | p[37] | p[38] | p[39] | p[40] | p[41]
                | p[42] | p[43] | p[44];
assign pl_n[4]  = p[14] | p[16] | p[17] | p[18] | p[21] | p[23] | p[24] | p[26] | p[28] | p[30]
                | p[32] | p[33] | p[34] | p[35] | p[36] | p[39] | p[40] | p[42] | p[43] | p[44];
assign pl_n[5]  = p[14] | p[16] | p[17] | p[18] | p[19] | p[21] | p[23] | p[25] | p[26] | p[27]
                | p[28] | p[29] | p[32] | p[33] | p[35] | p[36] | p[40] | p[41] | p[42] | p[43];
assign pl_n[6]  = p[14] | p[15] | p[21] | p[23] | p[25] | p[26] | p[28] | p[30] | p[31] | p[34]
                | p[38] | p[39] | p[40] | p[42] | p[43];
assign pl_n[7]  = p[48] | p[49] | p[50];
assign pl_n[8]  = p[15] | p[16] | p[17] | p[18] | p[19] | p[24] | p[25] | p[27] | p[28] | p[29]
                | p[30] | p[31] | p[32] | p[33] | p[34] | p[35] | p[36] | p[37] | p[38] | p[39]
                | p[41] | p[42] | p[44];
assign pl_n[9]  = p[15] | p[16] | p[24] | p[25] | p[28] | p[29] | p[30] | p[31] | p[32] | p[33]
                | p[34] | p[41] | p[44];
assign pl_n[10] = p[15] | p[17] | p[19] | p[22] | p[24] | p[25] | p[27] | p[28] | p[29] | p[30]
                | p[31] | p[32] | p[34] | p[35] | p[37] | p[38] | p[39] | p[41] | p[42] | p[44];
assign pl_n[11] = p[16] | p[30] | p[32] | p[33] | p[34];
assign pl_n[12] = p[51] | p[52] | p[53] | p[54] | p[55];
assign pl_n[13] = p[14] | p[15] | p[16] | p[17] | p[18] | p[19] | p[21] | p[23] | p[26] | p[27]
                | p[35] | p[36] | p[37] | p[38] | p[39] | p[40] | p[41] | p[42] | p[43] | p[45]
                | p[46] | p[47] | ~psw[4];
assign pl_n[20:14] = 7'b1111111;

assign pld = pl | ~pl_n;
endmodule

//______________________________________________________________________________
//
// Decoding jump microinstruction array for 1611 (Data Chip)
//
module mcp_plj
(
   input  inpl,         // input enable
   input  icc,          // indirect condition code
   input  [7:0] psw,    // PSW flags
   input  [15:8] mir,   // microinstruction
   output jump          // jump condition met
);

wire [15:0] pl;
//
// ALU/status flags [7:0] "NB ZB C4 C8 N Z V C"
//
assign pl[0]  = (mir[15:8] == 8'h10) & ~psw[6];    // jzbf - if ZB is false
assign pl[1]  = (mir[15:8] == 8'h11) &  psw[6];    // jzbt - if ZB is true
assign pl[2]  = (mir[15:8] == 8'h12) & ~psw[4];    // jc8f - if C8 is false
assign pl[3]  = (mir[15:8] == 8'h13) &  psw[4];    // jc8t - if C8 is true
assign pl[4]  = (mir[15:8] == 8'h14) & ~icc;       // jif - if ICC is false
assign pl[5]  = (mir[15:8] == 8'h15) &  icc;       // jit - if ICC is true
assign pl[6]  = (mir[15:8] == 8'h16) & ~psw[7];    // jnbf - if NB is false
assign pl[7]  = (mir[15:8] == 8'h17) &  psw[7];    // jnbt - if NB is true
assign pl[8]  = (mir[15:8] == 8'h18) & ~psw[2];    // jzf - if Z is false
assign pl[9]  = (mir[15:8] == 8'h19) &  psw[2];    // jzt - if Z is true
assign pl[10] = (mir[15:8] == 8'h1a) & ~psw[0];    // jcf - if C is false
assign pl[11] = (mir[15:8] == 8'h1b) &  psw[0];    // jct - if C is true
assign pl[12] = (mir[15:8] == 8'h1c) & ~psw[1];    // jvf - if V is false
assign pl[13] = (mir[15:8] == 8'h1d) &  psw[1];    // jvt - if V is true
assign pl[14] = (mir[15:8] == 8'h1e) & ~psw[3];    // jnf - if N is false
assign pl[15] = (mir[15:8] == 8'h1f) &  psw[3];    // jnt - if N is true

assign jump = ~inpl & |pl;
endmodule

//______________________________________________________________________________
//
// Decoding microinstruction array for 1611 (Data Chip)
//
module mcp_pli
(
   input  inpl,         // input enable
   input  [15:8] mir,   // microinstruction
   output [10:0] dmi    // decoded output
);
wire [10:0] pl;

function cmp
(
   input [7:0] ai,
   input [7:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign pl[0]  = cmp(mir[15:8], 8'b1010111x);  // cawi
assign pl[1]  = cmp(mir[15:8], 8'b10x001xx);  // cmb/cmw/cab/caw
assign pl[2]  = cmp(mir[15:8], 8'b110110xx);  // srbc/swrc
assign pl[3]  = cmp(mir[15:8], 8'b10101100);  // cad
assign pl[4]  = cmp(mir[15:8], 8'b11111111);  // nop
assign pl[5]  = cmp(mir[15:8], 8'b1111xxxx);  // I/O opcodes
assign pl[6]  = cmp(mir[15:8], 8'bx11111xx);  // output
assign pl[7]  = cmp(mir[15:8], 8'b1110001x);  // iw
assign pl[8]  = cmp(mir[15:8], 8'b111011xx);  // mi
assign pl[9]  = cmp(mir[15:8], 8'b01110101);  // lgl
assign pl[10] = cmp(mir[15:8], 8'b10xxxxxx);  // mb/mw

assign dmi[0]  = pl[0];
assign dmi[1]  = pl[1];
assign dmi[2]  = pl[2] & ~inpl;
assign dmi[3]  = pl[3];
assign dmi[4]  = pl[4];
assign dmi[5]  = pl[5] & ~inpl;
assign dmi[6]  = pl[6] & ~inpl;
assign dmi[7]  = pl[7] & ~inpl;
assign dmi[8]  = pl[8] & ~inpl;
assign dmi[9]  = pl[9] & ~inpl;
assign dmi[10] = pl[10];

endmodule

//______________________________________________________________________________
//
// PDP-11 conditional branch instruction matrix
//
module mcp_plb
(
   input  [15:0] dal,   // dal[15,11,10,9,8] bits
   input  [7:0] psw,    // processor status word
   output jump          // jump taken
);

function cmp
(
   input [4:0] br,
   input [4:0] op
);
begin
   casex(br)
      op:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

wire [4:0] br;

assign br = {dal[15], dal[11:8]};
assign jump = ~br[0] ^
            ( cmp(br[4:0], 5'b1011x) & psw[0]              // bcc/bcs, C
            | cmp(br[4:0], 5'b1010x) & psw[1]              // bvc/bvs, V
            | cmp(br[4:0], 5'b1001x) & psw[2]              // bhi/blos, Z | C
            | cmp(br[4:0], 5'b1001x) & psw[0]              // bhi/blos, Z | C
            | cmp(br[4:0], 5'b1000x) & psw[3]              // bpl/bmi, N
            | cmp(br[4:0], 5'b0011x) & (psw[3] ^ psw[1])   // bgt/ble, Z | (N ^ V)
            | cmp(br[4:0], 5'b0011x) & psw[2]              // bgt/ble, Z | (N ^ V)
            | cmp(br[4:0], 5'b0010x) & (psw[3] ^ psw[1])   // bge/blt, N ^ V
            | cmp(br[4:0], 5'b0001x) & psw[2]              // bne/beq, Z
            | cmp(br[4:0], 5'b0000x));                     // br
endmodule
