//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// 1801VM2 programmable logic matrices (PLM)
//______________________________________________________________________________
//
// Main microcode inputs description:
//
//    ir[15:0] - instruction code latched in instruction register (opcode)
//    ix[2:0]  - aux conditions from predecoder
//    ri[2:0]  - interrupt unit query register
//    ia[5:0]  - microinstruction address
//
// Outputs:
//
//    plm[8]   - microinstruction type selection
//    plm[0]      x0 - system control register strobe
//                01 - two operand microinstruction (x, y)
//                11 - one operand microinstruction (x, const/vector)
//
//    plm[2]   - write result target
//    plm[3]      000   - y
//    plm[29]     001   - x
//                010   - acc
//                011   - x, fr1, fr (address register, read phase)
//                101   - x, fr
//                110   - acc, fw (address register, write phase)
//                111   - x, fw
//
//    plm[9:12] - y operand for two-ops microinstruction
//    plm[4]    - x operand
//    plm[5]      0000  - R0
//    plm[6]      0001  - R1
//    plm[7]      0010  - R2
//                0011  - R3
//                0100  - R4
//                0101  - R5
//                0110  - R6
//                0111  - R7
//                1000  - EA_RA1 (Extended Arithmetics Register 1)
//                1001  - EA_RA2 (Extended Arithmetics Register 2)
//                1010  - EA_CNT (Extended Arithmetics Counter), no connection
//                1011  - SRC (Source Register))
//                1100  - PSW
//                1101  - ACC (Accumulator)
//                1110  - AREG (QBus Address), no connection
//                1111  - QREG (QBus Data)
//
//    plm[9]    - constant/vector selector for single-op microinstruction
//    plm[10]     0000  - psw                - PSW
//    plm[11]     0001  - 00000000iiiiiii0   - offset from opcode, MARK, SOB
//    plm[12]     0010  - 000001             - INC, DEC
//                0011  - 000002             - INC
//                0100  - 000000             - CLR
//                0101  - 000004
//                0110  - cpsw               - copy PSW
//                0111  - bir                - command buffer (prefetched 2nd/3rd word)
//                1000  - branch             - sign extended offset in BR instruction
//                1001  - nnnnnnnnnnnnnnnn   - result sign extention
//                1010  - 000000000000000c   - C flag
//                1011  - 000020
//                1100  - vector             - defined by vsel, see the next table
//                1101  - 000024
//                1110  - cpc                - copy of PC
//                1111  - cpc                - copy of PC
//
//    plm[13]     - ALU operation
//    plm[14]     00000 -  y
//    plm[15]     00001 - ~y
//    plm[16]     01000 - ~x
//    plm[17]     01001 -  x
//                10001 -  x-y
//                11000: op = " y-x";
//                11001: op = " x+y";
//                10000: op = " x^y";
//                10010: op = " x|y";
//                10100: op = " x&y";
//                10101: op = "x&~y";
//
//    plm[20:17]
//    vsel[0:3] - vector index
//                0000  - 000030
//                0001  - 000020
//                0010  - 000010
//                0011  - 000014
//                0100  - 000004
//                0101  - 000174
//                0110  - 000000
//                1000  - 000250
//                1001  - 000024
//                1010  - 000100
//                1011  - 000170
//                1100  - 000034
//                1101  - 000274
//
//    plm[20:18]  - ALU result shift mode
//                000   - not used
//                001   - not used
//                010   - shift right, arithmetic, msb replicated
//                011   - shift right, param bit shifted in
//                100   - shift left, zero shited in
//                101   - shift left, param bit shifted in
//                110   - no shift
//                111   - no shift, byte xchg
//
//    plm[36:31] - next microinstruction address [5:0]
//
// System control outputs (sp[0] == 0):
//    sp[3:1]  - interrupt reason register (ri[0:2])
//    sp[13]   - INIT output set (INIT reset is done by timer)
//    sp[14]   - go to waiting state
//    sp[15]   - reset interrupt source
//    sp[20:17] - set vector vsel[0:3]
//
module vm2_plm
(
   input  [15:0] ir,
   input  [2:0]  ix,
   input  [2:0]  ri,
   input  [5:0]  ia,
   output [36:0] sp
);
wire [199:2] p;
wire [36:0] pl;

function cmp
(
   input [27:0] ai,
   input [27:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[2]   = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxx111, 3'bxxx, 3'bxxx, 6'b110x11});
assign p[3]   = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx11xxxx, 3'bxxx, 3'bxxx, 6'b0x1100});
assign p[4]   = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx11xxxx, 3'bxxx, 3'bxxx, 6'b110x1x});
assign p[5]   = cmp({ir, ix, ri, ia}, {16'bxxxx1x1010xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[6]   = cmp({ir, ix, ri, ia}, {16'b0x10xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx0x100});
assign p[7]   = cmp({ir, ix, ri, ia}, {16'bxxxxx1x00xxxxxxx, 3'b0xx, 3'bxxx, 6'b001x00});
assign p[8]   = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx000xxx, 3'bxxx, 3'b1xx, 6'b001101});
assign p[9]   = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx0111xx, 3'bxxx, 3'bx1x, 6'b111010});
assign p[10]  = cmp({ir, ix, ri, ia}, {16'bxxxx001xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[11]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxx111, 3'bxxx, 3'bxxx, 6'bx0xx00});
assign p[12]  = cmp({ir, ix, ri, ia}, {16'bxxxxx01xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b11x001});
assign p[13]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx01101x, 3'bxxx, 3'bx1x, 6'b111010});
assign p[14]  = cmp({ir, ix, ri, ia}, {16'bxxxx010xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001010});
assign p[15]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'b1xx, 6'b11x10x});
assign p[16]  = cmp({ir, ix, ri, ia}, {16'bx101xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx0x100});
assign p[17]  = cmp({ir, ix, ri, ia}, {16'bxxx11xxxxxxxxxxx, 3'bx1x, 3'bxxx, 6'b001x10});
assign p[18]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx000xxx, 3'bxxx, 3'bxxx, 6'b001101});
assign p[19]  = cmp({ir, ix, ri, ia}, {16'bx0xxxx1101xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[20]  = cmp({ir, ix, ri, ia}, {16'bxxxxx0x1xxxxxxxx, 3'bxxx, 3'bxxx, 6'b111010});
assign p[21]  = cmp({ir, ix, ri, ia}, {16'bxxx1x00xxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10011});
assign p[22]  = cmp({ir, ix, ri, ia}, {16'bx1111xxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx0x100});
assign p[23]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'b11x, 6'bx11001});
assign p[24]  = cmp({ir, ix, ri, ia}, {16'bx100xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx0x100});
assign p[25]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxx000xxx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[26]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'b1xx, 3'bxxx, 6'b001100});
assign p[27]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxx10xxxxxxx, 3'bxxx, 3'bxxx, 6'bxx010x});
assign p[28]  = cmp({ir, ix, ri, ia}, {16'bxxxx010xxxxxxxxx, 3'bx11, 3'bxxx, 6'b110x0x});
assign p[29]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx000x11, 3'bxxx, 3'bxxx, 6'b111010});
assign p[30]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bx1x, 3'bxxx, 6'b010010});
assign p[31]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxx01xxxxxxx, 3'bxxx, 3'bxxx, 6'bxx0101});
assign p[32]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxx0xxxxx1xx, 3'bxxx, 3'bxxx, 6'b001010});
assign p[33]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx000xxx, 3'bxxx, 3'b1xx, 6'b110x00});
assign p[34]  = cmp({ir, ix, ri, ia}, {16'bxxxxx11xxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10011});
assign p[35]  = cmp({ir, ix, ri, ia}, {16'bxxxxx00xxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx00101});
assign p[36]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx1xxxxx, 3'bxxx, 3'bxxx, 6'b111010});
assign p[37]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx000xxx, 3'bxxx, 3'bxxx, 6'b110x00});
assign p[38]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'b0xx, 6'b1011x0});
assign p[39]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxx011xx1, 3'bxxx, 3'bxxx, 6'b011000});
assign p[40]  = cmp({ir, ix, ri, ia}, {16'bx0xxxxx0xxxx10xx, 3'bx0x, 3'bxxx, 6'b001x10});
assign p[41]  = cmp({ir, ix, ri, ia}, {16'bxxxxx11xxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx001x1});
assign p[42]  = cmp({ir, ix, ri, ia}, {16'bxxxx00xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110x00});
assign p[43]  = cmp({ir, ix, ri, ia}, {16'b1xxxx1x111xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[44]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b101101});
assign p[45]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx011000, 3'bxxx, 3'bx1x, 6'b111010});
assign p[46]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx01xxxx, 3'bxxx, 3'bx0x, 6'b111010});
assign p[47]  = cmp({ir, ix, ri, ia}, {16'bxxxxxx00xxxxxx0x, 3'bxxx, 3'bxxx, 6'b100110});
assign p[48]  = cmp({ir, ix, ri, ia}, {16'bxxx1x0xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110011});
assign p[49]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx00000});
assign p[50]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxx0010xx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[51]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b11100x});
assign p[52]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b101111});
assign p[53]  = cmp({ir, ix, ri, ia}, {16'bx111x00xxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx0x100});
assign p[54]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxx1xxxxxxx, 3'bxxx, 3'bxxx, 6'b1100x1});
assign p[55]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b010001});
assign p[56]  = cmp({ir, ix, ri, ia}, {16'bxxxxxx0xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b100001});
assign p[57]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx001xxx, 3'bxxx, 3'bx0x, 6'b111010});
assign p[58]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx0001x1, 3'bxxx, 3'bxxx, 6'b111010});
assign p[59]  = cmp({ir, ix, ri, ia}, {16'bx011xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx0x100});
assign p[60]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxx011xx0, 3'bxxx, 3'bxxx, 6'b011000});
assign p[61]  = cmp({ir, ix, ri, ia}, {16'bxxxx010xxxxxxxxx, 3'bx0x, 3'bxxx, 6'b110x0x});
assign p[62]  = cmp({ir, ix, ri, ia}, {16'bxxxx001xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001010});
assign p[63]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b010011});
assign p[64]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b000110});
assign p[65]  = cmp({ir, ix, ri, ia}, {16'bx0xx0xxx11xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[66]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx000001, 3'bxxx, 3'bxxx, 6'b111010});
assign p[67]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx0x0xxx, 3'bxx1, 3'bxx1, 6'b101000});
assign p[68]  = cmp({ir, ix, ri, ia}, {16'bxxxx11xxxxxxxxxx, 3'bx0x, 3'bxxx, 6'b011000});
assign p[69]  = cmp({ir, ix, ri, ia}, {16'bxxx1xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx00111});
assign p[70]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxx11xxxxxxx, 3'bxxx, 3'bxxx, 6'bxx010x});
assign p[71]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'b000, 6'bx11110});
assign p[72]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxx1xxxxxx, 3'bxxx, 3'bxxx, 6'bxx010x});
assign p[73]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxx1xxxxxx, 3'bxxx, 3'bxxx, 6'b1100xx});
assign p[74]  = cmp({ir, ix, ri, ia}, {16'bxxxx0x0xxxxxxx1x, 3'bxxx, 3'bxxx, 6'b001110});
assign p[75]  = cmp({ir, ix, ri, ia}, {16'bxxxxx0xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx00101});
assign p[76]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001101});
assign p[77]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxx0xx10000, 3'bxxx, 3'bx1x, 6'b111010});
assign p[78]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx00xxxx, 3'bxxx, 3'bxxx, 6'b101000});
assign p[79]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxx11xxxx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[80]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bx0x, 3'bxxx, 6'b1110x1});
assign p[81]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxx1xxxxxxxx, 3'bxxx, 3'bxxx, 6'b001010});
assign p[82]  = cmp({ir, ix, ri, ia}, {16'bxx0xxxxxxxxxxxxx, 3'b1xx, 3'bxxx, 6'bx0x100});
assign p[83]  = cmp({ir, ix, ri, ia}, {16'bxxxxxx1100xxxxxx, 3'b0xx, 3'bxxx, 6'b001x00});
assign p[84]  = cmp({ir, ix, ri, ia}, {16'bxxxx0x0xxxxx0xxx, 3'bxxx, 3'bxxx, 6'bx10110});
assign p[85]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxx0x11xx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[86]  = cmp({ir, ix, ri, ia}, {16'bxxx00xxxx1xxxxxx, 3'bxxx, 3'bxxx, 6'bx00111});
assign p[87]  = cmp({ir, ix, ri, ia}, {16'bxxxxx10xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[88]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110x01});
assign p[89]  = cmp({ir, ix, ri, ia}, {16'bx010xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx0x100});
assign p[90]  = cmp({ir, ix, ri, ia}, {16'bxxxxx1xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx00111});
assign p[91]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx011xxx, 3'bxxx, 3'bxx0, 6'b101000});
assign p[92]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxx1xxxxxxxx, 3'bxxx, 3'bxxx, 6'b1100xx});
assign p[93]  = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10100});
assign p[94]  = cmp({ir, ix, ri, ia}, {16'bxxx0xxx0xxxxx0xx, 3'bx1x, 3'bxxx, 6'b001010});
assign p[95]  = cmp({ir, ix, ri, ia}, {16'b00xxx1x1x1xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[96]  = cmp({ir, ix, ri, ia}, {16'bxxxxxx1xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b111010});
assign p[97]  = cmp({ir, ix, ri, ia}, {16'bxx0x0xxx10xxxxxx, 3'bxxx, 3'bxxx, 6'b0010x0});
assign p[98]  = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx000100, 3'bxxx, 3'bxxx, 6'b111010});
assign p[99]  = cmp({ir, ix, ri, ia}, {16'bxxx0xx1000xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[100] = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx011001, 3'bxxx, 3'bx1x, 6'b111010});
assign p[101] = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxx10xxxx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[102] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxx0, 6'b001011});
assign p[103] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b00110x});
assign p[104] = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx000000, 3'bxxx, 3'bxxx, 6'b111010});
assign p[105] = cmp({ir, ix, ri, ia}, {16'bxxxxx1xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b100110});
assign p[106] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxx1xxxxxxx, 3'bxxx, 3'bxxx, 6'b11x0x0});
assign p[107] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx101xxx, 3'bxxx, 3'bxxx, 6'b101000});
assign p[108] = cmp({ir, ix, ri, ia}, {16'bxxx1x00xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001x10});
assign p[109] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'b1xx, 6'bx11110});
assign p[110] = cmp({ir, ix, ri, ia}, {16'bxxxxxx1xxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10101});
assign p[111] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bx0x, 6'b101110});
assign p[112] = cmp({ir, ix, ri, ia}, {16'bxxxx0xxx0xx10001, 3'bxxx, 3'bx1x, 6'b111010});
assign p[113] = cmp({ir, ix, ri, ia}, {16'bxxxx0xxx0xx00x10, 3'bxxx, 3'bxxx, 6'b111010});
assign p[114] = cmp({ir, ix, ri, ia}, {16'bx1110xxxxxxxxxxx, 3'b1xx, 3'bxxx, 6'bx0x100});
assign p[115] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011100});
assign p[116] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b100011});
assign p[117] = cmp({ir, ix, ri, ia}, {16'bxxxxx1x1x0xxxxxx, 3'b0xx, 3'bxxx, 6'b001x00});
assign p[118] = cmp({ir, ix, ri, ia}, {16'bxxxx10xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[119] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001111});
assign p[120] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110010});
assign p[121] = cmp({ir, ix, ri, ia}, {16'bxxxxxx1111xxxxxx, 3'b0xx, 3'bxxx, 6'b001x00});
assign p[122] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011010});
assign p[123] = cmp({ir, ix, ri, ia}, {16'bxxxx0x0xxxxxxx0x, 3'bx1x, 3'bxxx, 6'b001110});
assign p[124] = cmp({ir, ix, ri, ia}, {16'bxxxx011xxxxxxxxx, 3'bx1x, 3'bxxx, 6'b110x00});
assign p[125] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxx1xxxxxxx, 3'bxxx, 3'bxxx, 6'bxx0x00});
assign p[126] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011111});
assign p[127] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001001});
assign p[128] = cmp({ir, ix, ri, ia}, {16'bxxx1xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b100110});
assign p[129] = cmp({ir, ix, ri, ia}, {16'bxxxx0xxx0xx1x1xx, 3'bxxx, 3'bxxx, 6'b1110x0});
assign p[130] = cmp({ir, ix, ri, ia}, {16'bx110xxxxxxxxxxxx, 3'b1xx, 3'bxxx, 6'bx0x100});
assign p[131] = cmp({ir, ix, ri, ia}, {16'bxxxxx00xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110x00});
assign p[132] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxx00xxx, 3'bxxx, 3'bxxx, 6'b101000});
assign p[133] = cmp({ir, ix, ri, ia}, {16'bxxxxxx0xxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10101});
assign p[134] = cmp({ir, ix, ri, ia}, {16'bxxx11xxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001x10});
assign p[135] = cmp({ir, ix, ri, ia}, {16'bxxxx100xxxxxxxxx, 3'b0xx, 3'bxxx, 6'b0011x0});
assign p[136] = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxx001xxx, 3'bxxx, 3'bx1x, 6'b111010});
assign p[137] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx0x0xxx, 3'bxxx, 3'bxx0, 6'b101000});
assign p[138] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxx1, 6'b001011});
assign p[139] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bx1x, 3'bxxx, 6'b1110x1});
assign p[140] = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxx0x0xxx, 3'bxxx, 3'bxxx, 6'b01x000});
assign p[141] = cmp({ir, ix, ri, ia}, {16'bxxxxxx1xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b100001});
assign p[142] = cmp({ir, ix, ri, ia}, {16'bxxxx11xxxxxxxxxx, 3'bx1x, 3'bxxx, 6'b011000});
assign p[143] = cmp({ir, ix, ri, ia}, {16'bxxxx000x0xxxxxxx, 3'b0xx, 3'bxxx, 6'b001100});
assign p[144] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bx1x, 3'b001, 6'b1x1110});
assign p[145] = cmp({ir, ix, ri, ia}, {16'bxxxxx00xxxxxxx1x, 3'bx1x, 3'bxxx, 6'b100110});
assign p[146] = cmp({ir, ix, ri, ia}, {16'bxxx1x00xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[147] = cmp({ir, ix, ri, ia}, {16'bxxxx11x0x1xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[148] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx111xxx, 3'bxxx, 3'bxxx, 6'b101000});
assign p[149] = cmp({ir, ix, ri, ia}, {16'bxxxx10xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10110});
assign p[150] = cmp({ir, ix, ri, ia}, {16'bxxxx1xxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001110});
assign p[151] = cmp({ir, ix, ri, ia}, {16'b1xxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b111010});
assign p[152] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxx1xx, 3'bxxx, 3'bxxx, 6'bx0xx00});
assign p[153] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'b001, 6'b011110});
assign p[154] = cmp({ir, ix, ri, ia}, {16'bxxxx01xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b001x10});
assign p[155] = cmp({ir, ix, ri, ia}, {16'bxxxx010xxxxxxxxx, 3'bx10, 3'bxxx, 6'b110x0x});
assign p[156] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxx1x, 3'bxxx, 3'bxxx, 6'bx0xx00});
assign p[157] = cmp({ir, ix, ri, ia}, {16'bxxxxx1xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b111010});
assign p[158] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxx1, 3'bxxx, 3'bxxx, 6'bx0xx00});
assign p[159] = cmp({ir, ix, ri, ia}, {16'bxxxx101xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110x0x});
assign p[160] = cmp({ir, ix, ri, ia}, {16'bxxx00xxxx0xxxxxx, 3'bxxx, 3'bxxx, 6'bx00111});
assign p[161] = cmp({ir, ix, ri, ia}, {16'bxxxxxx1xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b00111x});
assign p[162] = cmp({ir, ix, ri, ia}, {16'bxxxx0xxx0xx1x01x, 3'bxxx, 3'bxxx, 6'b1110x0});
assign p[163] = cmp({ir, ix, ri, ia}, {16'bx000xx101xxxxxxx, 3'b0xx, 3'bxxx, 6'b001x00});
assign p[164] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx011xxx, 3'bxxx, 3'bxx1, 6'b101000});
assign p[165] = cmp({ir, ix, ri, ia}, {16'bxxxx0x1xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011000});
assign p[166] = cmp({ir, ix, ri, ia}, {16'bxxxx10xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx00111});
assign p[167] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bx0x, 3'b001, 6'b1x1110});
assign p[168] = cmp({ir, ix, ri, ia}, {16'bxxxx11x0x0xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[169] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx110xxx, 3'bxxx, 3'bxxx, 6'b101000});
assign p[170] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b010010});
assign p[171] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b11x10x});
assign p[172] = cmp({ir, ix, ri, ia}, {16'bxxxx011xxxxxxxxx, 3'bx0x, 3'bxxx, 6'b110x00});
assign p[173] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b011101});
assign p[174] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx00101});
assign p[175] = cmp({ir, ix, ri, ia}, {16'bxxxx110xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110x0x});
assign p[176] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bx1x, 6'b101110});
assign p[177] = cmp({ir, ix, ri, ia}, {16'bxxxx111xxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110x0x});
assign p[178] = cmp({ir, ix, ri, ia}, {16'bxxx0xxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10011});
assign p[179] = cmp({ir, ix, ri, ia}, {16'bx000xx1110xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[180] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b0x0000});
assign p[181] = cmp({ir, ix, ri, ia}, {16'bxxx00xxxxxxx0xxx, 3'bx0x, 3'bxxx, 6'b100110});
assign p[182] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b010111});
assign p[183] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxx010xxx, 3'bxx0, 3'bxx1, 6'b101000});
assign p[184] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b0000x0});
assign p[185] = cmp({ir, ix, ri, ia}, {16'bxxxxxx1xxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10110});
assign p[186] = cmp({ir, ix, ri, ia}, {16'bx000xx1x01xxxxxx, 3'b0xx, 3'bxxx, 6'b001xx0});
assign p[187] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b000011});
assign p[188] = cmp({ir, ix, ri, ia}, {16'bxxxx0x0xxxxx1xxx, 3'bxxx, 3'bxxx, 6'bx10110});
assign p[189] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b1x1001});
assign p[190] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx11001});
assign p[191] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b100010});
assign p[192] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b00000x});
assign p[193] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b11x111});
assign p[194] = cmp({ir, ix, ri, ia}, {16'bxxxxx1xxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10110});
assign p[195] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b1x110x});
assign p[196] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10000});
assign p[197] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx011x1});
assign p[198] = cmp({ir, ix, ri, ia}, {16'bxxxx0xxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'bx10011});
assign p[199] = cmp({ir, ix, ri, ia}, {16'bxxxxxxxxxxxxxxxx, 3'bxxx, 3'bxxx, 6'b110x01});
//
// Summ-Of-Products
//
assign sp = ~pl;
assign pl[0]   = p[170] | p[151] | p[134] | p[119] | p[104] | p[98]  | p[90]  | p[66]  | p[64]  | p[58]
               | p[57]  | p[51]  | p[46]  | p[32]  | p[29];

assign pl[1]   = p[199] | p[198] | p[197] | p[196] | p[194] | p[193] | p[192] | p[191] | p[189] | p[188]
               | p[185] | p[184] | p[183] | p[182] | p[181] | p[178] | p[176] | p[174] | p[173] | p[171]
               | p[170] | p[169] | p[167] | p[166] | p[165] | p[164] | p[162] | p[161] | p[160] | p[157]
               | p[154] | p[153] | p[151] | p[150] | p[149] | p[148] | p[146] | p[145] | p[144] | p[143]
               | p[142] | p[141] | p[140] | p[139] | p[138] | p[137] | p[136] | p[135] | p[134] | p[133]
               | p[132] | p[129] | p[128] | p[127] | p[126] | p[123] | p[122] | p[120] | p[116] | p[115]
               | p[114] | p[113] | p[112] | p[111] | p[110] | p[109] | p[108] | p[107] | p[106] | p[105]
               | p[104] | p[102] | p[101] | p[100] | p[98]  | p[97]  | p[96]  | p[93]  | p[91]  | p[87]
               | p[86]  | p[85]  | p[84]  | p[81]  | p[80]  | p[79]  | p[78]  | p[77]  | p[71]  | p[69]
               | p[68]  | p[67]  | p[62]  | p[57]  | p[55]  | p[51]  | p[50]  | p[49]  | p[47]  | p[46]
               | p[45]  | p[39]  | p[29]  | p[23];

assign pl[2]   = p[192] | p[191] | p[188] | p[184] | p[183] | p[181] | p[180] | p[177] | p[175] | p[173]
               | p[172] | p[169] | p[166] | p[164] | p[160] | p[159] | p[155] | p[153] | p[150] | p[148]
               | p[145] | p[137] | p[132] | p[131] | p[124] | p[113] | p[112] | p[107] | p[104] | p[102]
               | p[100] | p[91]  | p[78]  | p[76]  | p[61]  | p[58]  | p[55]  | p[42]  | p[17];

assign pl[3]   = p[192] | p[191] | p[189] | p[184] | p[183] | p[180] | p[177] | p[175] | p[173] | p[169]
               | p[167] | p[166] | p[164] | p[159] | p[157] | p[155] | p[148] | p[143] | p[141] | p[135]
               | p[132] | p[131] | p[124] | p[121] | p[118] | p[114] | p[107] | p[102] | p[100] | p[90]
               | p[89]  | p[76]  | p[60]  | p[59]  | p[55]  | p[52]  | p[40]  | p[36]  | p[32]  | p[28];

assign pl[4]   = p[193] | p[191] | p[190] | p[187] | p[185] | p[184] | p[182] | p[180] | p[176] | p[174]
               | p[173] | p[171] | p[165] | p[161] | p[146] | p[141] | p[138] | p[133] | p[128] | p[127]
               | p[122] | p[118] | p[116] | p[115] | p[111] | p[110] | p[109] | p[108] | p[103] | p[101]
               | p[96]  | p[93]  | p[87]  | p[85]  | p[84]  | p[80]  | p[79]  | p[77]  | p[74]  | p[71]
               | p[69]  | p[68]  | p[67]  | p[63]  | p[62]  | p[50]  | p[44]  | p[39];

assign pl[5]   = p[194] | p[193] | p[192] | p[191] | p[190] | p[189] | p[188] | p[187] | p[184] | p[182]
               | p[181] | p[180] | p[176] | p[173] | p[167] | p[166] | p[160] | p[157] | p[153] | p[152]
               | p[150] | p[149] | p[145] | p[144] | p[142] | p[141] | p[139] | p[138] | p[136] | p[127]
               | p[126] | p[122] | p[118] | p[116] | p[115] | p[113] | p[112] | p[111] | p[109] | p[105]
               | p[103] | p[101] | p[100] | p[96]  | p[92]  | p[86]  | p[85]  | p[84]  | p[81]  | p[80]
               | p[79]  | p[77]  | p[74]  | p[71]  | p[68]  | p[63]  | p[62]  | p[55]  | p[52]  | p[50]
               | p[39]  | p[25];

assign pl[6]   = p[197] | p[194] | p[192] | p[191] | p[189] | p[188] | p[187] | p[181] | p[180] | p[173]
               | p[171] | p[167] | p[166] | p[165] | p[160] | p[157] | p[156] | p[153] | p[150] | p[149]
               | p[145] | p[144] | p[142] | p[139] | p[136] | p[127] | p[126] | p[118] | p[116] | p[113]
               | p[108] | p[106] | p[103] | p[93]  | p[87]  | p[86]  | p[81]  | p[60]  | p[55]  | p[54]
               | p[39]  | p[25];

assign pl[7]   = p[197] | p[194] | p[193] | p[191] | p[189] | p[188] | p[187] | p[184] | p[180] | p[173]
               | p[171] | p[167] | p[158] | p[157] | p[153] | p[149] | p[146] | p[144] | p[142] | p[139]
               | p[138] | p[136] | p[128] | p[127] | p[126] | p[122] | p[118] | p[116] | p[115] | p[112]
               | p[110] | p[109] | p[105] | p[103] | p[100] | p[96]  | p[93]  | p[86]  | p[80]  | p[77]
               | p[73]  | p[71]  | p[68]  | p[62]  | p[39]  | p[34]  | p[25]  | p[21]  | p[12];

assign pl[8]   = p[192] | p[191] | p[189] | p[188] | p[187] | p[186] | p[184] | p[183] | p[182] | p[181]
               | p[179] | p[177] | p[176] | p[175] | p[172] | p[169] | p[167] | p[166] | p[164] | p[163]
               | p[162] | p[160] | p[159] | p[157] | p[155] | p[153] | p[150] | p[148] | p[145] | p[144]
               | p[142] | p[141] | p[139] | p[137] | p[136] | p[132] | p[131] | p[129] | p[128] | p[127]
               | p[124] | p[121] | p[120] | p[116] | p[113] | p[112] | p[111] | p[108] | p[107] | p[102]
               | p[100] | p[99]  | p[95]  | p[94]  | p[91]  | p[85]  | p[83]  | p[69]  | p[67]  | p[63]
               | p[61]  | p[55]  | p[52]  | p[50]  | p[45]  | p[36]  | p[10];

assign pl[9]   = p[199] | p[198] | p[195] | p[193] | p[191] | p[190] | p[186] | p[185] | p[179] | p[176]
               | p[165] | p[162] | p[161] | p[154] | p[149] | p[146] | p[143] | p[140] | p[139] | p[138]
               | p[136] | p[135] | p[127] | p[126] | p[122] | p[117] | p[115] | p[109] | p[108] | p[105]
               | p[102] | p[101] | p[96]  | p[95]  | p[87]  | p[86]  | p[84]  | p[81]  | p[80]  | p[79]
               | p[77]  | p[74]  | p[71]  | p[68]  | p[49]  | p[43]  | p[26];

assign pl[10]  = p[194] | p[193] | p[191] | p[190] | p[187] | p[185] | p[182] | p[178] | p[177] | p[175]
               | p[171] | p[169] | p[165] | p[164] | p[162] | p[161] | p[149] | p[148] | p[146] | p[143]
               | p[140] | p[138] | p[136] | p[135] | p[129] | p[127] | p[126] | p[124] | p[122] | p[121]
               | p[117] | p[116] | p[115] | p[111] | p[109] | p[105] | p[102] | p[101] | p[99]  | p[97]
               | p[96]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[81]  | p[80]  | p[79]
               | p[77]  | p[74]  | p[71]  | p[70]  | p[69]  | p[68]  | p[67]  | p[63]  | p[50]  | p[49]
               | p[45]  | p[44]  | p[43]  | p[38]  | p[27];

assign pl[11]  = p[197] | p[196] | p[195] | p[192] | p[190] | p[189] | p[188] | p[186] | p[184] | p[183]
               | p[182] | p[181] | p[179] | p[178] | p[176] | p[169] | p[167] | p[166] | p[164] | p[163]
               | p[162] | p[160] | p[153] | p[150] | p[148] | p[145] | p[144] | p[143] | p[141] | p[140]
               | p[137] | p[136] | p[135] | p[132] | p[129] | p[128] | p[127] | p[126] | p[125] | p[120]
               | p[116] | p[113] | p[112] | p[108] | p[107] | p[105] | p[100] | p[97]  | p[94]  | p[91]
               | p[88]  | p[86]  | p[85]  | p[84]  | p[74]  | p[70]  | p[67]  | p[56]  | p[55]  | p[50]
               | p[47]  | p[31]  | p[26];

assign pl[12]  = p[197] | p[195] | p[194] | p[193] | p[192] | p[190] | p[189] | p[188] | p[185] | p[184]
               | p[183] | p[181] | p[178] | p[177] | p[176] | p[175] | p[172] | p[169] | p[167] | p[166]
               | p[165] | p[164] | p[162] | p[161] | p[160] | p[159] | p[157] | p[155] | p[153] | p[150]
               | p[149] | p[148] | p[146] | p[145] | p[144] | p[142] | p[141] | p[140] | p[138] | p[136]
               | p[127] | p[126] | p[124] | p[123] | p[122] | p[115] | p[113] | p[112] | p[110] | p[109]
               | p[108] | p[107] | p[105] | p[101] | p[100] | p[97]  | p[96]  | p[95]  | p[91]  | p[88]
               | p[87]  | p[84]  | p[81]  | p[80]  | p[79]  | p[77]  | p[74]  | p[72]  | p[71]  | p[68]
               | p[67]  | p[55]  | p[49]  | p[48]  | p[47]  | p[34]  | p[26];

assign pl[13]  = p[192] | p[191] | p[189] | p[188] | p[187] | p[185] | p[184] | p[183] | p[181] | p[179]
               | p[177] | p[175] | p[172] | p[169] | p[167] | p[166] | p[163] | p[161] | p[160] | p[159]
               | p[157] | p[155] | p[153] | p[150] | p[148] | p[145] | p[144] | p[142] | p[141] | p[139]
               | p[137] | p[133] | p[132] | p[131] | p[130] | p[128] | p[121] | p[120] | p[113] | p[112]
               | p[107] | p[101] | p[100] | p[99]  | p[94]  | p[91]  | p[89]  | p[83]  | p[79]  | p[63]
               | p[61]  | p[59]  | p[58]  | p[55]  | p[52]  | p[35]  | p[24]  | p[22]  | p[19]  | p[16];

assign pl[14]  = p[191] | p[189] | p[188] | p[186] | p[185] | p[184] | p[182] | p[181] | p[180] | p[177]
               | p[175] | p[173] | p[172] | p[169] | p[168] | p[167] | p[161] | p[160] | p[157] | p[153]
               | p[150] | p[148] | p[147] | p[145] | p[139] | p[137] | p[133] | p[128] | p[118] | p[117]
               | p[114] | p[113] | p[112] | p[97]  | p[94]  | p[91]  | p[89]  | p[88]  | p[83 ] | p[78]
               | p[76]  | p[66]  | p[65]  | p[62]  | p[61]  | p[60]  | p[52]  | p[42]  | p[40]  | p[35]
               | p[28]  | p[13]  | p[9]   | p[6]   | p[5];

assign pl[15]  = p[187] | p[141] | p[101] | p[99] | p[64] | p[63] | p[59] | p[24];
assign pl[16]  = p[79]  | p[16];

assign pl[17]  = p[192] | p[191] | p[189] | p[188] | p[185] | p[184] | p[183] | p[182] | p[181] | p[180]
               | p[179] | p[177] | p[176] | p[175] | p[173] | p[172] | p[169] | p[168] | p[167] | p[166]
               | p[163] | p[161] | p[160] | p[159] | p[157] | p[155] | p[153] | p[150] | p[148] | p[147]
               | p[145] | p[144] | p[142] | p[139] | p[137] | p[133] | p[132] | p[131] | p[130] | p[128]
               | p[120] | p[118] | p[117] | p[114] | p[113] | p[112] | p[107] | p[104] | p[101] | p[100]
               | p[97]  | p[94]  | p[91]  | p[88]  | p[78]  | p[76]  | p[65]  | p[63]  | p[62]  | p[61]
               | p[60]  | p[55]  | p[52]  | p[42]  | p[40]  | p[35]  | p[28]  | p[24]  | p[20]  | p[19]
               | p[13]  | p[9];

assign pl[18]  = p[185] | p[119] | p[65]  | p[56]  | p[47]  | p[20] | p[7];
assign pl[19]  = p[185] | p[151] | p[147] | p[123] | p[119] | p[98] | p[56] | p[47];
assign pl[20]  = p[168] | p[151] | p[134] | p[119] | p[57]  | p[51] | p[46] | p[35];

assign pl[21]  = p[189] | p[183] | p[173] | p[169] | p[167] | p[164] | p[138] | p[137] | p[132] | p[112]
               | p[109] | p[100] | p[96]  | p[78]  | p[77]  | p[67]  | p[52];

assign pl[22]  = p[191] | p[189] | p[188] | p[184] | p[181] | p[180] | p[177] | p[175] | p[172] | p[167]
               | p[160] | p[159] | p[155] | p[153] | p[150] | p[148] | p[145] | p[138] | p[131] | p[124]
               | p[113] | p[112] | p[109] | p[107] | p[102] | p[96]  | p[91]  | p[77]  | p[76]  | p[61]
               | p[52]  | p[42];

assign pl[23]  = p[192] | p[189] | p[167] | p[166] | p[138] | p[100] | p[55]  | p[52];

assign pl[24]  = p[191] | p[184] | p[183] | p[181] | p[180] | p[177] | p[175] | p[173] | p[172] | p[169]
               | p[164] | p[160] | p[159] | p[155] | p[150] | p[148] | p[145] | p[138] | p[137] | p[132]
               | p[131] | p[124] | p[113] | p[109] | p[107] | p[102] | p[96]  | p[91]  | p[78]  | p[77]
               | p[76]  | p[67]  | p[61]  | p[42];

assign pl[25]  = p[186] | p[179] | p[168] | p[163] | p[154] | p[147] | p[133] | p[130] | p[128] | p[121]
               | p[99]  | p[95]  | p[89]  | p[83]  | p[82]  | p[65]  | p[59]  | p[43]  | p[40]  | p[22];

assign pl[26]  = p[186] | p[179] | p[168] | p[167] | p[154] | p[147] | p[141] | p[133] | p[130] | p[128]
               | p[121] | p[120] | p[118] | p[99]  | p[94]  | p[89]  | p[83]  | p[65]  | p[60]  | p[56]
               | p[40]  | p[25];

assign pl[27]  = p[190] | p[180] | p[177] | p[176] | p[175] | p[173] | p[171] | p[169] | p[164] | p[148]
               | p[140] | p[126] | p[124] | p[118] | p[111] | p[105] | p[103] | p[84]  | p[74]  | p[67]
               | p[49]  | p[44]  | p[38];

assign pl[28]  = p[199] | p[197] | p[194] | p[192] | p[191] | p[190] | p[189] | p[188] | p[187] | p[185]
               | p[184] | p[182] | p[181] | p[180] | p[178] | p[176] | p[174] | p[173] | p[172] | p[171]
               | p[170] | p[167] | p[166] | p[165] | p[161] | p[160] | p[159] | p[157] | p[154] | p[153]
               | p[151] | p[150] | p[146] | p[145] | p[144] | p[143] | p[141] | p[138] | p[137] | p[136]
               | p[135] | p[134] | p[133] | p[132] | p[131] | p[128] | p[127] | p[126] | p[123] | p[120]
               | p[118] | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[111] | p[110] | p[109]
               | p[108] | p[107] | p[104] | p[102] | p[100] | p[98]  | p[97]  | p[96]  | p[94]  | p[93]
               | p[91]  | p[90]  | p[87]  | p[85]  | p[84]  | p[81]  | p[78]  | p[77]  | p[74]  | p[69]
               | p[66]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[58]  | p[57]  | p[56]  | p[55]
               | p[51]  | p[50]  | p[47]  | p[46]  | p[45]  | p[42]  | p[36]  | p[32]  | p[29]  | p[25];

assign pl[29]  = p[191] | p[184] | p[183] | p[182] | p[180] | p[177] | p[175] | p[173] | p[169] | p[164]
               | p[157] | p[155] | p[154] | p[148] | p[143] | p[141] | p[135] | p[124] | p[123] | p[121]
               | p[118] | p[117] | p[114] | p[102] | p[97]  | p[89]  | p[88]  | p[76]  | p[60]  | p[59]
               | p[56]  | p[47]  | p[40]  | p[36]  | p[28]  | p[13]  | p[9];

assign pl[30]  = p[183] | p[175] | p[173] | p[169] | p[164] | p[155] | p[137] | p[132] | p[131] | p[124]
               | p[78]  | p[76]  | p[67]  | p[61]  | p[42]  | p[28];

assign pl[31]  = p[199] | p[192] | p[191] | p[184] | p[182] | p[180] | p[177] | p[176] | p[172] | p[170]
               | p[167] | p[166] | p[159] | p[154] | p[148] | p[143] | p[135] | p[133] | p[128] | p[127]
               | p[117] | p[116] | p[114] | p[111] | p[108] | p[107] | p[102] | p[97]  | p[91]  | p[90]
               | p[75]  | p[63]  | p[55]  | p[47]  | p[44]  | p[41]  | p[33]  | p[15]  | p[8];

assign pl[32]  = p[199] | p[198] | p[194] | p[193] | p[192] | p[191] | p[190] | p[188] | p[187] | p[186]
               | p[185] | p[182] | p[181] | p[180] | p[179] | p[178] | p[176] | p[168] | p[167] | p[165]
               | p[163] | p[162] | p[161] | p[157] | p[153] | p[151] | p[150] | p[149] | p[147] | p[146]
               | p[145] | p[144] | p[143] | p[142] | p[141] | p[140] | p[139] | p[135] | p[134] | p[130]
               | p[129] | p[127] | p[126] | p[123] | p[122] | p[121] | p[119] | p[118] | p[117] | p[115]
               | p[109] | p[105] | p[104] | p[102] | p[101] | p[99]  | p[98]  | p[97]  | p[95]  | p[94]
               | p[90]  | p[89]  | p[87]  | p[86]  | p[85]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]
               | p[71]  | p[68]  | p[66]  | p[65]  | p[64]  | p[62]  | p[60]  | p[59]  | p[58]  | p[57]
               | p[56]  | p[53]  | p[51]  | p[49]  | p[46]  | p[44]  | p[43]  | p[40]  | p[39]  | p[32]
               | p[30]  | p[29]  | p[14];

assign pl[33]  = p[198] | p[197] | p[196] | p[194] | p[193] | p[191] | p[190] | p[188] | p[186] | p[185]
               | p[183] | p[182] | p[181] | p[179] | p[178] | p[173] | p[169] | p[168] | p[167] | p[164]
               | p[163] | p[162] | p[161] | p[153] | p[151] | p[150] | p[149] | p[148] | p[147] | p[145]
               | p[144] | p[143] | p[142] | p[140] | p[139] | p[137] | p[135] | p[134] | p[132] | p[130]
               | p[129] | p[123] | p[122] | p[121] | p[117] | p[114] | p[109] | p[108] | p[107] | p[105]
               | p[104] | p[102] | p[101] | p[99]  | p[98]  | p[97]  | p[95]  | p[94]  | p[91]  | p[90]
               | p[89]  | p[86]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[75]
               | p[74]  | p[71]  | p[68]  | p[67]  | p[66]  | p[65]  | p[62]  | p[59]  | p[57]  | p[53]
               | p[51]  | p[50]  | p[49]  | p[46]  | p[43]  | p[41]  | p[40]  | p[39]  | p[32]  | p[29];

assign pl[34]  = p[199] | p[192] | p[190] | p[187] | p[182] | p[178] | p[176] | p[170] | p[166] | p[161]
               | p[160] | p[154] | p[150] | p[145] | p[143] | p[141] | p[138] | p[135] | p[133] | p[128]
               | p[126] | p[123] | p[117] | p[116] | p[114] | p[111] | p[108] | p[97]  | p[90]  | p[81]
               | p[75]  | p[63]  | p[62]  | p[47]  | p[41]  | p[32]  | p[25];

assign pl[35]  = p[194] | p[192] | p[190] | p[189] | p[187] | p[185] | p[183] | p[181] | p[177] | p[176]
               | p[173] | p[172] | p[171] | p[169] | p[165] | p[164] | p[161] | p[160] | p[159] | p[157]
               | p[150] | p[146] | p[143] | p[137] | p[135] | p[132] | p[128] | p[127] | p[126] | p[123]
               | p[118] | p[117] | p[114] | p[111] | p[109] | p[108] | p[97]  | p[94]  | p[93]  | p[87]
               | p[85]  | p[78]  | p[67]  | p[60]  | p[56]  | p[55]  | p[52]  | p[47]  | p[44]  | p[37]
               | p[25]  | p[18];

assign pl[36]  = p[194] | p[191] | p[190] | p[185] | p[184] | p[183] | p[181] | p[180] | p[177] | p[176]
               | p[174] | p[173] | p[172] | p[169] | p[165] | p[164] | p[159] | p[157] | p[149] | p[148]
               | p[146] | p[144] | p[142] | p[141] | p[139] | p[138] | p[137] | p[136] | p[132] | p[127]
               | p[126] | p[122] | p[120] | p[118] | p[116] | p[115] | p[113] | p[112] | p[111] | p[110]
               | p[107] | p[105] | p[102] | p[100] | p[96]  | p[94]  | p[91]  | p[87]  | p[86]  | p[85]
               | p[84]  | p[78]  | p[77]  | p[74]  | p[69]  | p[67]  | p[64]  | p[63]  | p[60]  | p[58]
               | p[56]  | p[55]  | p[50]  | p[49]  | p[45]  | p[36]  | p[30]  | p[11]  | p[4]   | p[3]
               | p[2];
endmodule

//______________________________________________________________________________
//
// Interrupt priority matrix input description:
//
//    rq[0]    - nACLO raising edge detector (nACLO restored)
//    rq[1]    - interrupt disable (both psw[7] & psw[8] are set)
//    rq[2]    - unused
//    rq[3]    - interrupt request HALT
//    rq[4]    - normal QBUS timeout
//    rq[5]    - vectored interrupt request (nVIRQ low level)
//    rq[6]    - nACLO falling edge detector (nACLO failed)
//    rq[7]    - nIAKO transaction flag (vector timeout detect)
//    rq[8]    - double QBUS timeout
//    rq[9]    - wait mode (waiting for interrupt)
//    rq[10]   - timer interrupt request nEVNT (falling edge)
//    rq[11]   - T-bit trap request (function of psw[4])
//    rq[12]   - RTT instruction T-bit supress
//    rq[13]   - psw[8]
//    rq[14]   - psw[7]
//    rq[15]   - AC0 matrix feedback (output sp[3])
//
// Interrupt priority matrix output description:
//
//    sp[0]    - vector generator selector  bit 3
//    sp[2]    - vector generator selector ~bit 2
//    sp[7]    - vector generator selector ~bit 1
//    sp[9]    - vector generator selector  bit 0
//
//    sp[3]    - feedback to priority matrix - AC0
//    sp[6]    - controls the request detectors rearm
//    sp[8]    - controls the request detectors rearm
//
//    sp[1]    - goes to the main matrix register ~ri[0]
//    sp[5]    - goes to the main matrix register ~ri[1]
//    sp[4]    - goes to the main matrix register  ri[2]
//
//______________________________________________________________________________
//
// 1801VM2 interrupt matrix
//
module vm2_pli
(
   input  [15:0] rq,
   output [9:0] sp
);
wire [23:0] p;
wire [9:0] pl;

wire  acok, aclo;          // ACLO detector requests
wire  halt, evnt, virq;    // external requests
wire  psw7, psw8;
wire  wcpu, mask, acin;
wire  iako, qbto, dble;    // qbus timeouts and odd address
wire  tbit, rtto;

assign acok    =  rq[0];   // nACLO raising edge detector
assign mask    =  rq[1];   // interrupt disable (psw[7] & psw[8])
assign halt    =  rq[3];   // interrupt request HALT
assign qbto    =  rq[4];   // normal QBUS timeout
assign virq    =  rq[5];   // vectored interrupt request
assign aclo    =  rq[6];   // nACLO falling edge detector
assign iako    =  rq[7];   // nIAKO transaction
assign dble    =  rq[8];   // double QBUS timeout
assign wcpu    =  rq[9];   // waiting for interrupt
assign evnt    =  rq[10];  // timer interrupt request nEVNT
assign tbit    =  rq[11];  // T-bit trap request (function of psw[4])
assign rtto    =  rq[12];  // RTT instruction T-bit ingibition
assign psw8    =  rq[13];  //
assign psw7    =  rq[14];  //
assign acin    =  rq[15];  // AC0 matrix feedback

function cmp
(
   input [10:0] ai,
   input [10:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[1]    = ~acin &  acok;
assign p[10]   = ~acin & ~acok;

assign p[6]    =  acin &  qbto &  iako;
assign p[2]    =  acin &  qbto & ~iako &  dble;
assign p[0]    =  acin &  qbto & ~iako & ~dble;
assign p[18]   =  acin &  qbto & ~iako & ~dble & psw8;

assign p[8]    =  acin & ~qbto                 &  tbit & ~wcpu;
assign p[12]   =  acin & ~qbto                 &  tbit & ~wcpu &  rtto;

assign p[15]   =  acin & ~qbto &  aclo & ~mask &  tbit &  wcpu;
assign p[17]   =  acin & ~qbto &  aclo &  mask         &  wcpu;
assign p[22]   =  acin & ~qbto &  aclo & ~mask & ~tbit;
assign p[13]   =  acin & ~qbto &  aclo &  mask & ~tbit & ~wcpu;

assign p[9]    =  acin & ~qbto & ~aclo & ~psw8 &  tbit &  wcpu &  halt;
assign p[21]   =  acin & ~qbto & ~aclo &  psw8         &  wcpu &  halt;
assign p[7]    =  acin & ~qbto & ~aclo & ~psw8 & ~tbit         &  halt;
assign p[11]   =  acin & ~qbto & ~aclo &  psw8 & ~tbit & ~wcpu &  halt;

assign p[5]    =  acin & ~qbto & ~aclo & ~psw7 &  tbit &  wcpu & ~halt &  evnt;
assign p[16]   =  acin & ~qbto & ~aclo &  psw7         &  wcpu & ~halt;
assign p[3]    =  acin & ~qbto & ~aclo & ~psw7 & ~tbit         & ~halt &  evnt;
assign p[4]    =  acin & ~qbto & ~aclo &  psw7 & ~tbit & ~wcpu & ~halt;

assign p[23]   =  acin & ~qbto & ~aclo & ~psw7         &  wcpu & ~halt & ~evnt &  virq;
assign p[20]   =  acin & ~qbto & ~aclo                 &  wcpu & ~halt & ~evnt & ~virq;
assign p[19]   =  acin & ~qbto & ~aclo & ~psw7 & ~tbit         & ~halt & ~evnt &  virq;
assign p[14]   =  acin & ~qbto & ~aclo         & ~tbit & ~wcpu & ~halt & ~evnt & ~virq;

assign sp      = ~pl;
assign pl[0]   = p[8]  | p[2]  | p[1]  | p[0];
assign pl[1]   = p[23] | p[19] | p[14] | p[13] | p[12] | p[11] | p[4]  | p[1];
assign pl[2]   = p[6]  | p[2]  | p[1]  | p[0];
assign pl[3]   = p[10];
assign pl[4]   = p[21] | p[20] | p[17] | p[16] | p[14] | p[13] | p[12] | p[11] | p[10] | p[4];
assign pl[5]   = p[18] | p[9]  | p[7]  | p[6]  | p[2]  | p[1];
assign pl[6]   = p[22] | p[15] | p[6]  | p[2]  | p[1]  | p[0];
assign pl[7]   = p[9]  | p[8]  | p[7]  | p[5]  | p[3]  | p[1];
assign pl[8]   = p[6]  | p[5]  | p[3]  | p[2]  | p[0];
assign pl[9]   = p[5]  | p[3]  | p[1]  | p[0];
endmodule

//______________________________________________________________________________
//
// 1801VM2 branch processing matrix
//
//    rq[0]    - instruction register [8]
//    rq[1]    - instruction register [9]
//    rq[2]    - instruction register [10]
//    rq[3]    - instruction register [12]
//    rq[4]    - instruction register [13]
//    rq[5]    - instruction register [14]
//    rq[6]    - instruction register [15]
//    rq[7]    - dc_b7
//    rq[8]    - C - psw[0]/cond_c
//    rq[9]    - V - psw[1]/cond_v
//    rq[10]   - N - psw[2]/cond_z
//    rq[11]   - Z - psw[3]/cond_n
//    rq[12]   - naf[4]
//    rq[13]   - naf[5]
//
module vm2_plb
(
   input  [13:0] rq,
   output sp
);
wire [19:0] p;

function cmp
(
   input [13:0] ai,
   input [13:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[5]    = cmp(rq[13:0], 14'b11xxxxx0000001);   //      br        0004ss
assign p[6]    = cmp(rq[13:0], 14'bx1x0xxx0000010);   // z    bne       0010ss
assign p[16]   = cmp(rq[13:0], 14'b11x1xxx0000x11);   // Z    beq/ble   0014ss
assign p[10]   = cmp(rq[13:0], 14'b110x0xx0000100);   // nv   bge       0020ss   n xor v == 0
assign p[0]    = cmp(rq[13:0], 14'b111x1xx0000100);   // NV   bge       0020ss   n xor v == 0
assign p[11]   = cmp(rq[13:0], 14'b110x1xx00001x1);   // nV   blt/ble   0024ss   n xor v == 1
assign p[13]   = cmp(rq[13:0], 14'b111x0xx00001x1);   // Nv   blt/ble   0024ss   n xor v == 1
assign p[1]    = cmp(rq[13:0], 14'bx1000xx00001x0);   // nvz  bgt/bge   0030ss   (z == 0) and (n xor v) == 0
assign p[3]    = cmp(rq[13:0], 14'bx1101xx0000110);   // NVz  bgt       0030ss   (z == 0) and (n xor v) == 0
assign p[2]    = cmp(rq[13:0], 14'b110xxxx1000000);   // n    bpl       1000ss
assign p[14]   = cmp(rq[13:0], 14'b111xxxx1000001);   // N    bmi       1004ss
assign p[7]    = cmp(rq[13:0], 14'bx1x0x0x1000010);   // zc   bhi       1010ss   (z == 0) & (c == 0)
assign p[18]   = cmp(rq[13:0], 14'b11x1xxxx000011);   // Z    beq/blos  0014ss
assign p[8]    = cmp(rq[13:0], 14'b11xx0xx1000100);   // v    bvc       1020ss
assign p[4]    = cmp(rq[13:0], 14'b11xx1xx1000101);   // V    bvs       1024ss
assign p[9]    = cmp(rq[13:0], 14'b11xxx1x1000x11);   // C    bcs/blos  1034ss
assign p[12]   = cmp(rq[13:0], 14'b11xxx0x1000110);   // c    bcc       1030ss
assign p[19]   = cmp(rq[13:0], 14'b000xxxxxxxxxxx);
assign p[17]   = cmp(rq[13:0], 14'b01x0xxxxxxxxxx);
assign p[15]   = cmp(rq[13:0], 14'b10xxxx0xxxxxxx);

assign sp = ~|p[19:0];
endmodule

//______________________________________________________________________________
//
// 1801VM2 instruction predecoder matrix
//
module vm2_pld
(
   input  [15:0] rq,
   output [11:0] sp
);
wire [47:0] p;
wire [11:0] pl;

function cmp
(
   input [15:0] ai,
   input [15:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[15]   = cmp(rq[15:0], 16'b0000000000000011);    // bpt
assign p[0]    = cmp(rq[15:0], 16'b0000000000000110);    // rtt
assign p[22]   = cmp(rq[15:0], 16'bx0000001xxxxxxxx);    // br/bmi
assign p[18]   = cmp(rq[15:0], 16'b10000000xxxxxxxx);    // bpl
assign p[24]   = cmp(rq[15:0], 16'b1000x00xxxxxxxxx);    // bpl/bmi/emt
assign p[10]   = cmp(rq[15:0], 16'b0000000000001xxx);
assign p[3]    = cmp(rq[15:0], 16'b000000000001xxxx);
assign p[5]    = cmp(rq[15:0], 16'b00000000101xxxxx);
assign p[2]    = cmp(rq[15:0], 16'b0000110100xxxxxx);
assign p[4]    = cmp(rq[15:0], 16'b01110xxxxx000xxx);
assign p[6]    = cmp(rq[15:0], 16'b0111100xxx000xxx);
assign p[7]    = cmp(rq[15:0], 16'b01111010000xxxxx);
assign p[1]    = cmp(rq[15:0], 16'b1000110100000xxx);
assign p[8]    = cmp(rq[15:0], 16'bx000110111000xxx);
assign p[9]    = cmp(rq[15:0], 16'bx0x1000xxx000xxx);
assign p[11]   = cmp(rq[15:0], 16'bx0001100xx000xxx);
assign p[12]   = cmp(rq[15:0], 16'b000000001x000xxx);
assign p[13]   = cmp(rq[15:0], 16'b0000x0x000xxxxxx);
assign p[14]   = cmp(rq[15:0], 16'bx10x000xxx000xxx);
assign p[16]   = cmp(rq[15:0], 16'bx000101111xxxxxx);
assign p[17]   = cmp(rq[15:0], 16'b0000000000000x01);
assign p[19]   = cmp(rq[15:0], 16'b0000100xxx000xxx);
assign p[20]   = cmp(rq[15:0], 16'b0000000001000xxx);
assign p[21]   = cmp(rq[15:0], 16'bx0000xx0000xxxx0);
assign p[23]   = cmp(rq[15:0], 16'bxx10000xxx000xxx);
assign p[25]   = cmp(rq[15:0], 16'bx000101xxx000xxx);
assign p[26]   = cmp(rq[15:0], 16'b0001xxxxxxxxxxxx);
assign p[27]   = cmp(rq[15:0], 16'b0111111xxxxxxxxx);
assign p[28]   = cmp(rq[15:0], 16'b0000xx01xxxxxxxx);
assign p[29]   = cmp(rq[15:0], 16'bx000001xxxxxxxxx);
assign p[30]   = cmp(rq[15:0], 16'b1000110100xxxxxx);
assign p[31]   = cmp(rq[15:0], 16'bx00001xxxxxxxxxx);
assign p[32]   = cmp(rq[15:0], 16'bx0000xx00xxxxxxx);
assign p[33]   = cmp(rq[15:0], 16'bx0001100xxxxxxxx);
assign p[34]   = cmp(rq[15:0], 16'b00000000x1xxxxxx);
assign p[35]   = cmp(rq[15:0], 16'bx10x000xxxxxxxxx);
assign p[36]   = cmp(rq[15:0], 16'bx000110111xxxxxx);
assign p[37]   = cmp(rq[15:0], 16'b0000100xxxxxxxxx);
assign p[38]   = cmp(rq[15:0], 16'b1x0xxxxxxxxxxxxx);
assign p[39]   = cmp(rq[15:0], 16'b0111100xxxxxxxxx);
assign p[40]   = cmp(rq[15:0], 16'bx0x1000xxxxxxxxx);
assign p[41]   = cmp(rq[15:0], 16'bxx10000xxxxxxxxx);
assign p[42]   = cmp(rq[15:0], 16'bx000101xxxxxxxxx);
assign p[43]   = cmp(rq[15:0], 16'b01110xxxxxxxxxxx);
assign p[44]   = cmp(rq[15:0], 16'b10xxxxxxxxxxxxxx);
assign p[45]   = cmp(rq[15:0], 16'bxx01xxxxxxxxxxxx);
assign p[46]   = cmp(rq[15:0], 16'bx1x0xxxxxxxxxxxx);
assign p[47]   = cmp(rq[15:0], 16'bx01xxxxxxxxxxxxx);

assign sp      = ~pl;
assign pl[1]   = 1'b0;
assign pl[2]   = p[0];
assign pl[0]   = p[43] | p[41] | p[40] | p[39] | p[35] | p[25] | p[20] | p[19] | p[12] | p[11] | p[8] | p[1];
assign pl[3]   = p[47] | p[43] | p[37] | p[32] | p[30] | p[16];
assign pl[4]   = p[37] | p[32] | p[28] | p[26] | p[13];
assign pl[5]   = p[42] | p[37] | p[36] | p[34] | p[33] | p[30] | p[12];
assign pl[6]   = p[43] | p[41] | p[40] | p[39] | p[35] | p[20] | p[19];
assign pl[7]   = p[47] | p[46] | p[45] | p[43] | p[39] | p[27];
assign pl[8]   = p[42] | p[37] | p[36] | p[34] | p[33] | p[30] | p[23] | p[14] | p[12] | p[9] | p[6] | p[4];
assign pl[9]   = p[31] | p[29] | p[27] | p[24] | p[22] | p[21] | p[20] | p[19] | p[17] | p[15] | p[10] | p[7] | p[5] | p[3] | p[2];
assign pl[10]  = p[44] | p[38];
assign pl[11]  = p[31] | p[29] | p[22] | p[20] | p[19] | p[18];
endmodule
