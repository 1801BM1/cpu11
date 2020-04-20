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
assign tc = rni ? ~7'h4A : ~tcr;

always @(*)
case(lc)
   11'b00000110111: tcr <= 7'h25;   // 0067
   11'b00001000000: tcr <= 7'h13;   // 0100
   11'b00001000001: tcr <= 7'h51;   // 0101
   11'b00001001000: tcr <= 7'h32;   // 0110
   11'b00001001001: tcr <= 7'h13;   // 0111
   11'b00001001010: tcr <= 7'h51;   // 0112
   11'b00001010000: tcr <= 7'h16;   // 0120
   11'b00001010001: tcr <= 7'h13;   // 0121
   11'b00001010010: tcr <= 7'h64;   // 0122
   11'b00001010011: tcr <= 7'h51;   // 0123
   11'b00001011010: tcr <= 7'h32;   // 0132
   11'b00001011011: tcr <= 7'h13;   // 0133
   11'b00001011100: tcr <= 7'h4C;   // 0134
   11'b00001011111: tcr <= 7'h51;   // 0137
   11'b00001100001: tcr <= 7'h23;   // 0141
   11'b00001100011: tcr <= 7'h13;   // 0143
   11'b00001101100: tcr <= 7'h32;   // 0154
   11'b00001101101: tcr <= 7'h13;   // 0155
   11'b00001110011: tcr <= 7'h32;   // 0163
   11'b00001110100: tcr <= 7'h13;   // 0164
   11'b00001111101: tcr <= 7'h32;   // 0175
   11'b00001111110: tcr <= 7'h13;   // 0176
   11'b00001111111: tcr <= 7'h52;   // 0177
   11'b00010000000: tcr <= 7'h68;   // 0200
   11'b00010001010: tcr <= 7'h38;   // 0212
   11'b00010010010: tcr <= 7'h38;   // 0222
   11'b00010011100: tcr <= 7'h38;   // 0234
   11'b00010100100: tcr <= 7'h38;   // 0244
   11'b00010101110: tcr <= 7'h38;   // 0256
   11'b00010110101: tcr <= 7'h38;   // 0265
   11'b00010111111: tcr <= 7'h38;   // 0277
   11'b00011001000: tcr <= 7'h15;   // 0310
   11'b00011010001: tcr <= 7'h15;   // 0321
   11'b00011011001: tcr <= 7'h15;   // 0331
   11'b00011100010: tcr <= 7'h15;   // 0342
   11'b00011101011: tcr <= 7'h15;   // 0353
   11'b00011110010: tcr <= 7'h15;   // 0362
   11'b00011111100: tcr <= 7'h15;   // 0374
   11'b00100000000: tcr <= 7'h70;   // 0400
   11'b00100001010: tcr <= 7'h58;   // 0412
   11'b00100001101: tcr <= 7'h2A;   // 0415
   11'b00100010001: tcr <= 7'h2C;   // 0421
   11'b00100010010: tcr <= 7'h58;   // 0422
   11'b00100010100: tcr <= 7'h58;   // 0424
   11'b00100011100: tcr <= 7'h58;   // 0434
   11'b00100100001: tcr <= 7'h49;   // 0441
   11'b00100100011: tcr <= 7'h58;   // 0443
   11'b00100100110: tcr <= 7'h58;   // 0446
   11'b00100101110: tcr <= 7'h58;   // 0456
   11'b00100110101: tcr <= 7'h58;   // 0465
   11'b00100111111: tcr <= 7'h58;   // 0477
   11'b00101000000: tcr <= 7'h0B;   // 0500
   11'b00101001000: tcr <= 7'h4A;   // 0510
   11'b00101001100: tcr <= 7'h4A;   // 0514
   11'b00101010000: tcr <= 7'h4A;   // 0520
   11'b00101010100: tcr <= 7'h4A;   // 0524
   11'b00101011000: tcr <= 7'h4A;   // 0530
   11'b00101011100: tcr <= 7'h4A;   // 0534
   11'b00101100000: tcr <= 7'h07;   // 0540
   11'b00101100010: tcr <= 7'h26;   // 0542
   11'b00101101000: tcr <= 7'h4A;   // 0550
   11'b00101101100: tcr <= 7'h4A;   // 0554
   11'b00101110000: tcr <= 7'h4A;   // 0560
   11'b00101110100: tcr <= 7'h4A;   // 0564
   11'b00101111000: tcr <= 7'h4A;   // 0570
   11'b00110000000: tcr <= 7'h0E;   // 0600
   11'b00110100000: tcr <= 7'h0D;   // 0640
   11'b00110001000: tcr <= 7'h4A;   // 0610
   11'b00110001100: tcr <= 7'h4A;   // 0614
   11'b00110101000: tcr <= 7'h4A;   // 0650
   11'b00110101100: tcr <= 7'h4A;   // 0654
   11'b00111101000: tcr <= 7'h4A;   // 0750
   11'b00111101100: tcr <= 7'h4A;   // 0754
   11'b01000000000: tcr <= 7'h4A;   // 1000
   11'b01000101000: tcr <= 7'h4A;   // 1050
   11'b01000101100: tcr <= 7'h4A;   // 1054
   11'b01010100100: tcr <= 7'h54;   // 1244
   11'b01100101001: tcr <= 7'h1A;   // 1451
   11'b01101000010: tcr <= 7'h1C;   // 1502
   11'b01110110011: tcr <= 7'h1C;   // 1663
   11'b01111000111: tcr <= 7'h1C;   // 1707
   11'b01111010001: tcr <= 7'h1C;   // 1721
   11'b01111101000: tcr <= 7'h1C;   // 1750
   11'b10000011011: tcr <= 7'h34;   // 2033
   11'b10000111011: tcr <= 7'h34;   // 2073
   11'b10001010011: tcr <= 7'h19;   // 2123
   11'b10001111010: tcr <= 7'h19;   // 2172
   11'b10010010000: tcr <= 7'h62;   // 2220
   11'b10010101100: tcr <= 7'h62;   // 2254
   11'b10010111100: tcr <= 7'h62;   // 2274
   11'b10011010000: tcr <= 7'h62;   // 2320
   11'b10100000110: tcr <= 7'h62;   // 2406
   11'b10100100111: tcr <= 7'h34;   // 2447
   11'b10101001110: tcr <= 7'h19;   // 2516
   11'b10101101000: tcr <= 7'h29;   // 2550
   11'b10101101001: tcr <= 7'h29;   // 2551
   11'b10101101010: tcr <= 7'h29;   // 2552
   11'b10101101011: tcr <= 7'h29;   // 2553
   11'b10101111001: tcr <= 7'h13;   // 2571
   11'b10101000000: tcr <= 7'h34;   // 2500
   11'b10101100000: tcr <= 7'h34;   // 2540
   11'b10110010010: tcr <= 7'h19;   // 2622
   11'b10110011000: tcr <= 7'h19;   // 2630
   11'b10110000100: tcr <= 7'h34;   // 2604
   11'b10110001100: tcr <= 7'h34;   // 2614
   11'b10110100100: tcr <= 7'h34;   // 2644
   11'b10110101100: tcr <= 7'h34;   // 2654
   11'b10111000000: tcr <= 7'h34;   // 2700
   11'b10111001000: tcr <= 7'h34;   // 2710
   11'b10111001100: tcr <= 7'h19;   // 2714
   11'b10111001111: tcr <= 7'h19;   // 2717
   11'b10111100000: tcr <= 7'h34;   // 2740
   11'b10111101000: tcr <= 7'h34;   // 2750
   11'b10111101100: tcr <= 7'h19;   // 2754
   default: tcr <= 7'h00;
endcase
endmodule

//______________________________________________________________________________
//
//  07: 0540
//  0B: 0500
//  0D: 0640
//  0E: 0600
//  13: 0100 0111 0121 0133 0143 0155 0164 0176 2571
//  15: 0310 0321 0331 0342 0353 0362 0374
//  16: 0120
// *19: 2123 2172 2516 2622 2630 2714 2717 2754
//  1A: 1451
// *1C: 1502 1663 1707 1721 1750
//  23: 0141
//  25: 0067
//  26: 0542
// *29: 2550 2551 2552 2553
// *2A: 0415
//  2C: 0421
//  32: 0110 0132 0154 0163 0175
// *34: 2033 2073 2447 2500 2540 2604 2614 2644 2654 2700 2710 2740 2750
//  38: 0212 0222 0234 0244 0256 0265 0277
//  49: 0441
// *4A: 0510 0514 0520 0524 0530 0534 0550 0554 0560 0564
//      0570 0610 0614 0650 0654 0750 0754 1000 1050 1054
//  4C: 0134
//  51: 0101 0112 0123 0137
//  52: 0177
//  54: 1244
//  58: 0412 0422 0424 0434 0443 0446 0456 0465 0477
// *62: 2254 2274 2220 2320 2406
//  64: 0122
//  68: 0200
//  70: 0400
//______________________________________________________________________________
//
// Known translation description
//
// 19: PSW - PSW translation that regenerates bit 7 and T-bit, 0x568+flags
// 1C: REF - handle DRAM refresh routine
// 29: DMW - destination translation for EIS M0 (tr[5:3])
// 2A: DC1 - decode upper byte of PDP-11 opcode
// 34: EII - FIS interrupt test (also used for fadd/fsub), 0x5CF on irq
// 4A: RNI - read next instruction
// 62: FII - FIS interrupt test for fmul and fdiv, 0x592 on irq
//______________________________________________________________________________
//
// Array 3/4
//
module mcp_pta34
(
   input  [7:0] tr,     // translation register high/low
   input  [7:1] irq,    // interrupt requests
   input  [6:0] tc,     // translation code
   input  [1:0] ts,     // translation status
   input  q,            // translation status 14:12
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

assign p[0]  = cmp({q, ts, tc, tr}, {1'b0, 2'bxx, 7'b1x1x1x1, 8'bxxxxxxxx});
assign p[1]  = cmp({q, ts, tc, tr}, {1'b0, 2'bxx, 7'b1x1x1x1, 8'bxxxx1xxx});
assign p[2]  = cmp({q, ts, tc, tr}, {1'b0, 2'bxx, 7'b1x1x1x1, 8'bxxxxx1xx});
assign p[3]  = cmp({q, ts, tc, tr}, {1'b0, 2'bxx, 7'b1x1x1x1, 8'bxxxxxx1x});
assign p[4]  = cmp({q, ts, tc, tr}, {1'b0, 2'bxx, 7'b1x1x1x1, 8'b10xx000x});
assign p[5]  = cmp({q, ts, tc, tr}, {1'b0, 2'bxx, 7'b1x1x1x1, 8'b1x0x000x});
assign p[6]  = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b10xxxxxx});
assign p[7]  = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b1x0xxxxx});
assign p[8]  = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b10xxxxx1});
assign p[9]  = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bx1x11xx, 8'bxxxx1xxx});
assign p[10] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bx1x11xx, 8'bxxx1xxxx});
assign p[11] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bx1x11xx, 8'bxx1xxxxx});
assign p[12] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11x11xx, 8'bxxxxxxxx});
assign p[13] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b10001101});
assign p[14] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b0001xxxx});
assign p[15] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11x11xx, 8'bxxxxx11x});
assign p[16] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'bxxx1xxxx});
assign p[17] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'bxx1xxxxx});
assign p[18] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'bx1xxxxxx});
assign p[19] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxx1111, 8'bxxxxxxxx});
assign p[20] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'bxxxxx1xx});
assign p[21] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'bxxxxxxx1});
assign p[22] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxx1x111, 8'bxxxxxxxx});
assign p[23] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'b1110xxxx});
assign p[24] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'b00000000});
assign p[25] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bx1xx111, 8'bxxxxxxxx});
assign p[26] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1xxx111, 8'bxxxxxxxx});
assign p[27] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b1x0xxxx1});
assign p[28] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b00000000});
assign p[29] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x11x1x, 8'b00000xxx});
assign p[30] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b01110xxx});
assign p[31] = cmp({q, ts, tc, tr}, {1'bx, 2'b10, 7'b11x11xx, 8'bxxxxxxxx});
assign p[32] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b01111010});
assign p[33] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'bx0000xxx});
assign p[34] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bx1x1x11, 8'bxxxxxxxx});
assign p[35] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x11x1x, 8'b00000x10});
assign p[36] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b0111111x});
assign p[37] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b1000101x});
assign p[38] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b10001100});
assign p[39] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b0000101x});
assign p[40] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b00001100});
assign p[41] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b0111100x});
assign p[42] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b00001101});
assign p[43] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b0000100x});
assign p[44] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b10001000});
assign p[45] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b10001001});
assign p[46] = cmp({q, ts, tc, tr}, {1'bx, 2'bx1, 7'b1xx11x1, 8'bxxxxxxxx});
assign p[47] = cmp({q, ts, tc, tr}, {1'bx, 2'bx1, 7'b11x1xx1, 8'bxxxxxxxx});
assign p[48] = cmp({q, ts, tc, tr}, {1'bx, 2'bx1, 7'b1x111xx, 8'bxxxxxxxx});
assign p[49] = cmp({q, ts, tc, tr}, {1'bx, 2'b1x, 7'bxx11x11, 8'b1xxxxxxx});
assign p[50] = cmp({q, ts, tc, tr}, {1'bx, 2'b1x, 7'bx11xx11, 8'b1xxxxxxx});
assign p[51] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bx1x111x, 8'bxxxxxxxx});
assign p[52] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x1x1, 8'b1111xxxx});
assign p[53] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx11x, 8'b1xxxxxxx});
assign p[54] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bx1x111x, 8'bxxxxx11x});
assign p[55] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b111xxxx, 8'b1xxxxxxx});
assign p[56] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b111xxxx, 8'bx1xxxxxx});
assign p[57] = cmp({q, ts, tc, tr}, {1'bx, 2'bx1, 7'b111xxxx, 8'bxxxxxxxx});
assign p[58] = cmp({q, ts, tc, tr}, {1'bx, 2'b1x, 7'b111xxxx, 8'bxxxxxxxx});
assign p[59] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1111xxx, 8'bxxxxxxxx});
assign p[60] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b111x1xx, 8'bxxxxxxxx});
assign p[61] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b111xx1x, 8'bxxxxxxxx});
assign p[62] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b111xxx1, 8'bxxxxxxxx});
assign p[63] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x11x1x, 8'b10000xxx});
assign p[64] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x11x1x, 8'b01xxxxxx});
assign p[65] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x11x1x, 8'b11xxxxxx});
assign p[66] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bx1x11x1, 8'bxxxxxxxx});
assign p[67] = cmp({q, ts, tc, tr}, {1'bx, 2'bx1, 7'b11x1x1x, 8'bxxxxxxxx});
assign p[68] = cmp({q, ts, tc, tr}, {1'bx, 2'b11, 7'b11x1x1x, 8'b11xxxxxx});
assign p[69] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx1x1, 8'b1000xxxx});
assign p[70] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx11x, 8'bxxx1xxxx});
assign p[71] = cmp({q, ts, tc, tr}, {1'bx, 2'b1x, 7'b1x1xx11, 8'bxxxxxxxx});
assign p[72] = cmp({q, ts, tc, tr}, {1'bx, 2'b1x, 7'bx11x11x, 8'bxxxxxxxx});
assign p[73] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx1x1, 8'b0001xxxx});
assign p[74] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x1x11x, 8'bxxxxxxxx});
assign p[75] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx11x, 8'bxxxxxxxx});
assign p[76] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'b01110x1x});
assign p[77] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'bxxxx111, 8'b01110x0x});
assign p[78] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x11x1x, 8'b1010xxxx});
assign p[79] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b1x11x1x, 8'b1011xxxx});
assign p[80] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx1x1, 8'b0110xxxx});
assign p[81] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx1x1, 8'b0100xxxx});
assign p[82] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx1x1, 8'b0010xxxx});
assign p[83] = cmp({q, ts, tc, tr}, {1'bx, 2'bxx, 7'b11xx1x1, 8'b0000xxxx});

assign p[84] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bxx111x1, 8'bxx1xxx01}); // FII
assign p[85] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b1xx1x11, 8'bxx1xxx01}); // EII
assign p[86] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b1xx1x11, 8'bxx1xxx1x}); // EII
assign p[87] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b1x11xx1, 8'bxx100001});
assign p[88] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bxx111x1, 8'bxx1xxx1x}); // FII
assign p[89] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx11x1x1, 8'bx00000xx}); // RNI
assign p[90] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b1x11xx1, 8'bxx10001x});
assign p[91] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b1x11xx1, 8'bxxx001xx});
assign p[92] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b1x11xx1, 8'bxxxx1xxx});
assign p[93] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx11x1x1, 8'bx0100001}); // RNI
assign p[94] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx11x1x1, 8'bx0x10xxx}); // RNI
assign p[95] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'b11xxx11, 8'bxxxx1xxx}); // REF
assign p[96] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx11x1x1, 8'bx010001x}); // RNI
assign p[97] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx11x1x1, 8'bx0x001xx}); // RNI
assign p[98] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx11x1x1, 8'bx0xx1xxx}); // RNI
assign p[99] = cmp({q, ts, tc, 1'b0, irq[7:1]}, {1'bx, 2'bxx, 7'bx11x1x1, 8'bx0x00000}); // RNI

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

assign tsr[0] = p[6] | p[7] | p[21] | p[43] | p[53];
assign tsr[1] = p[8] | p[14] | p[15] | p[20] | p[27] | p[54];
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
   input  c1,           // clock phases
   input  c2,           //
   input  c3,           //
   input  c4,           //
   input  rni,          // read next instruction
   input  [10:0] lc,    // location counter
   input  [7:0] tr,     // translation register high/low
   input  [1:0] ts,     // translation status
   input  [7:1] irq,    // interrupt requests
   input  qtr,          // translation status 14:12
   output [10:0] pta,   // programmable translation address
   output [2:0] tsr,    // translation status register
   output lra,          // load return address
   output lta,          // load translation address
   output ltsr,         // load translation status register
   output tcmax         // no lc address catch
);

wire [6:0] tc;
reg  [6:0] tc_c3;

wire [10:0] pta_pl;
wire [2:0] tsr_pl;
wire lra_pl;
wire lta_pl;
wire ltsr_pl;

reg  [10:0] pta_c4;
reg  [2:0] tsr_c4;
reg  lra_c4;
reg  lta_c4;
reg  ltsr_c4;
reg  tcmax_c4;

mcp_pta12 pta12
(
   .rni(rni),
   .lc(lc),
   .tc(tc)
);

always @(*)
begin
   if (c3)
      tc_c3 <= tc;
   if (c4)
      tcmax_c4 <= tc_c3 == 7'h7f;
end

mcp_pta34 pta34
(
   .tr(tr),
   .irq(irq),
   .tc(tc_c3),
   .ts(ts),
   .q(qtr),
   .pta(pta_pl),
   .tsr(tsr_pl),
   .lra(lra_pl),
   .lta(lta_pl),
   .ltsr(ltsr_pl)
);

assign pta = pta_c4;
assign tsr = tsr_c4;
assign lra = lra_c4;
assign lta = lta_c4;
assign ltsr = ltsr_c4;
assign tcmax = tcmax_c4;

always @(*)
begin
   if (c2)
   begin
      pta_c4   <= 11'h000;
      tsr_c4   <= 3'b000;
      lra_c4   <= 1'b0;
      lta_c4   <= 1'b0;
      ltsr_c4  <= 1'b0;
   end
   if (c4)
   begin
      pta_c4   <= pta_pl;
      tsr_c4   <= tsr_pl;
      lra_c4   <= lra_pl;
      lta_c4   <= lta_pl;
      ltsr_c4  <= ltsr_pl;
   end
end
endmodule

//______________________________________________________________________________
//
// Decoding microinstruction array for 1621 (Control Chip)
//
module mcp_plc
(
   input  c1,           // clock phases
   input  c2,           //
   input  c3,           //
   input  c4,           //
   input  q,            // Q input
   input  [15:0] mir,   // microinstruction
   output [19:0] plm    // matrix output
);

wire [23:0]pl;
reg q_c2;

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

always @(*) if (c2) q_c2 <= q;

assign pl[0]  = cmp({q_c2, mir[15:8]}, 9'b0000xxxxx);
assign pl[20] = cmp({q_c2, mir[15:8]}, 9'b011110x1x);
assign pl[21] = cmp({q_c2, mir[15:8]}, 9'b01110xx1x);
assign pl[22] = cmp({q_c2, mir[15:8]}, 9'b0110xxx1x);
assign pl[23] = cmp({q_c2, mir[15:8]}, 9'b010xxxx1x);

assign pl[1]  = cmp({q_c2, mir[15:8]}, 9'b000000xxx);
assign pl[2]  = cmp({q_c2, mir[15:8]}, 9'b00001xxxx);
assign pl[3]  = cmp({q_c2, mir[15:8]}, 9'b000001xxx);
assign pl[4]  = cmp({q_c2, mir[15:8]}, 9'bx111000xx);
assign pl[5]  = cmp({q_c2, mir[15:8]}, 9'bx1111110x);
assign pl[6]  = cmp({q_c2, mir[15:8]}, 9'b011101110);
assign pl[7]  = cmp({q_c2, mir[15:8]}, 9'bx11111110);
assign pl[8]  = cmp({q_c2, mir[15:8]}, 9'b01110001x);
assign pl[9]  = cmp({q_c2, mir[15:8]}, 9'b011110xx1);
assign pl[10] = cmp({q_c2, mir[15:8]}, 9'bx111110x1);
assign pl[11] = cmp({q_c2, mir[15:8]}, 9'bx11111100);
assign pl[12] = cmp({q_c2, mir[15:8]}, 9'bx01110000);
assign pl[13] = cmp({q_c2, mir[15:8]}, 9'bx01110001);
assign pl[14] = cmp({q_c2, mir[15:8]}, 9'bx01110100);
assign pl[15] = cmp({q_c2, mir[15:8]}, 9'b0111110xx);
assign pl[16] = cmp({q_c2, mir[15:8]}, 9'b011110xxx);
assign pl[17] = cmp({q_c2, mir[15:8]}, 9'b011110xx0);
assign pl[18] = cmp({q_c2, mir[15:8]}, 9'bx111110x0);
assign pl[19] = cmp({q_c2, mir[15:8]}, 9'bx1111101x);

assign plm[19:1] = c3 ? pl[19:1] : 18'h00000;
assign plm[0] = c3 & (pl[0] | pl[20] | pl[21] | pl[22] | pl[23]);
endmodule

//______________________________________________________________________________
//
// Decoding microinstruction array for 1611 (Data Chip)
//
module mcp_pld
(
   input  c1,           // clock phases
   input  c2,           //
   input  c3,           //
   input  c4,           //
   input  inpl,         // input enable
   input  [7:0] psw,    // PSW flags
   input  [15:0] mir,   // microinstruction
   output [20:0] pl_c3, // matrix output, c3 latch
   output [20:0] pl_c4  // matrix output, c4 latch
);

wire [55:0] p;
wire [20:0] pl;
wire [20:0] pl_n;
reg [20:0] plr_c3;
reg [20:0] plr_c4;

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

assign pl_c3 = plr_c3;
assign pl_c4 = plr_c4;

always @(*)
begin
   if (c3)
      plr_c3 <= pl | ~pl_n;
   if (c4)
      plr_c4 <= pl | ~pl_n;
end
endmodule

//______________________________________________________________________________
//
// Decoding jump microinstruction array for 1611 (Data Chip)
//
module mcp_plj
(
   input  c1,           // clock phases
   input  c2,           //
   input  c3,           //
   input  c4,           //
   input  inpl,         // input enable
   input  icc,          // indirect condition code
   input  [7:0] psw,    // PSW flags
   input  [15:8] mir,   // microinstruction
   output jump          // jump condition met
);

reg jump_c3;
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

always @(*) if (c3) jump_c3 <= ~inpl & |pl;
assign jump = c4 & jump_c3;
endmodule

//______________________________________________________________________________
//
// Decoding microinstruction array for 1611 (Data Chip)
//
module mcp_pli
(
   input  c1,           // clock phases
   input  c2,           //
   input  c3,           //
   input  c4,           //
   input  inpl,         // input enable
   input  [15:8] mir,   // microinstruction
   output [10:0] dmi    // decoded output
);
wire [10:0] pl;
reg  [10:0] dmi_c3;

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
assign pl[10] = cmp(mir[15:8], 8'b10xxxxxx);  //

assign dmi[10:0] = dmi_c3[10:0];
always @(*)
if (c3)
begin
   dmi_c3[0]  <= pl[0];
   dmi_c3[1]  <= pl[1];
   dmi_c3[2]  <= pl[2] & ~inpl;
   dmi_c3[3]  <= pl[3];
   dmi_c3[4]  <= pl[4];
   dmi_c3[5]  <= pl[5] & ~inpl;
   dmi_c3[6]  <= pl[6] & ~inpl;
   dmi_c3[7]  <= pl[7] & ~inpl;
   dmi_c3[8]  <= pl[8] & ~inpl;
   dmi_c3[9]  <= pl[9] & ~inpl;
   dmi_c3[10] <= pl[10];
end
endmodule

//______________________________________________________________________________
//
// PDP-11 conditional branch instruction matrix
//
module mcp_plb
(
   input  c1,           // clock phases
   input  c2,           //
   input  c3,           //
   input  c4,           //
   input  [4:0] dal,    // dal[15,11,10,9,8] bits
   input  [7:0] psw,    // processor status word
   input  mo_ad,        // translate AD to MI bus
   output jump          // jump taken
);

function cmp
(
   input [3:0] br,
   input [3:0] op
);
begin
   casex(br)
      op:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

reg jcond_c2;
reg jcond_c4;
reg moad_c1;

assign jump = jcond_c2;

always @(*)
begin
   if (c1)
      moad_c1 <= mo_ad;
   if (c2 & moad_c1)
      jcond_c2 <= ~(jcond_c4 ^ dal[0]);
   if (c4)
      jcond_c4 <= cmp(dal[4:1], 4'b1011) & psw[0]              // bcc/bcs, C
                | cmp(dal[4:1], 4'b1010) & psw[1]              // bvc/bvs, V
                | cmp(dal[4:1], 4'b1001) & psw[2]              // bhi/blos, Z | C
                | cmp(dal[4:1], 4'b1001) & psw[0]              // bhi/blos, Z | C
                | cmp(dal[4:1], 4'b1000) & psw[3]              // bpl/bmi, N
                | cmp(dal[4:1], 4'b0011) & (psw[3] ^ psw[1])   // bgt/ble, Z | (N ^ V)
                | cmp(dal[4:1], 4'b0011) & psw[2]              // bgt/ble, Z | (N ^ V)
                | cmp(dal[4:1], 4'b0010) & (psw[3] ^ psw[1])   // bge/blt, N ^ V
                | cmp(dal[4:1], 4'b0001) & psw[2]              // bne/beq, Z
                | cmp(dal[4:1], 4'b0000);                      // br
end
endmodule
