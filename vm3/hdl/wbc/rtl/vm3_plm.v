//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
// 1801VM3 programmable logic matrices (PLM)
//______________________________________________________________________________
//
// 1801VM3 main microcode matrix
//
// 23 inputs:
//    7:0         - microinstruction address
//    8           - multiplexed flag
//    11:9        - interrupt status/predecoder
//    22:12       - opcode predecoder outputs
//
// 38 outputs:
//    7:0         - next microinstruction address
//    8,16        - instruction fetch flags
//    18          - commit ALU flags to PSW
//    28          - word operation flag
//    33,26,21,20 - ALU opcode
//    36-34       - X/result selector
//
module vm3_plm
(
   input  [7:0] ma,     // instruction/exception
   input  mx,           // multiplexed flag
   input  [13:0] dc,    // decoder/masked in
   output [37:0] sp
);
wire [280:0] p;
wire [37:0] pl;

function cmp
(
   input [22:0] ai,
   input [22:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[0]   = cmp({dc, mx, ma}, {14'bx0xxxxxxxx1xx1, 1'b0, 8'bx0xxx011});
assign p[1]   = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx0xx, 1'bx, 8'b0xx01x00});
assign p[2]   = cmp({dc, mx, ma}, {14'b0xxxxxxxx010x1, 1'b0, 8'bx0xx0x0x});
assign p[3]   = cmp({dc, mx, ma}, {14'b01xxxxxxxxx0xx, 1'bx, 8'b0xx0x001});
assign p[4]   = cmp({dc, mx, ma}, {14'bx1xxxxxxxx0xx1, 1'bx, 8'bx0xx0011});
assign p[5]   = cmp({dc, mx, ma}, {14'b0xxxxxxxxx00xx, 1'bx, 8'b00xx0x0x});
assign p[6]   = cmp({dc, mx, ma}, {14'b00xxxxxxxx10xx, 1'bx, 8'b001xx00x});
assign p[7]   = cmp({dc, mx, ma}, {14'b01xxxxxxx01011, 1'bx, 8'b1xxxxxxx});
assign p[8]   = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0xx0101x});
assign p[9]   = cmp({dc, mx, ma}, {14'b00xxxxxxx01011, 1'bx, 8'b1xxxxxxx});
assign p[10]  = cmp({dc, mx, ma}, {14'b0xxxx0xxx1001x, 1'bx, 8'b1xxxxxxx});
assign p[11]  = cmp({dc, mx, ma}, {14'bxxxxxx0xxxxxx0, 1'bx, 8'b00x00x00});
assign p[12]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01x11xx0});
assign p[13]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxx0, 1'bx, 8'b01011001});
assign p[14]  = cmp({dc, mx, ma}, {14'bxxxxxx10xxxxx0, 1'bx, 8'b00xx0x00});
assign p[15]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b00101x00});
assign p[16]  = cmp({dc, mx, ma}, {14'bx0xxxxxxx0x010, 1'bx, 8'b1xxxxxxx});
assign p[17]  = cmp({dc, mx, ma}, {14'bxxxxxxxxx0x0x1, 1'bx, 8'bx0xxxx00});
assign p[18]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b10xxxx10});
assign p[19]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b011x0x10});
assign p[20]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01x10001});
assign p[21]  = cmp({dc, mx, ma}, {14'b0xxxxxxxxxx1x1, 1'b1, 8'bx0xxx011});
assign p[22]  = cmp({dc, mx, ma}, {14'b10xxxxxxxxxxx1, 1'b0, 8'bx0xx0011});
assign p[23]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01010x10});
assign p[24]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0100xx0x});
assign p[25]  = cmp({dc, mx, ma}, {14'b01xxxxxxx00011, 1'bx, 8'b1xxxxxxx});
assign p[26]  = cmp({dc, mx, ma}, {14'b1xxxxxxxxxx1xx, 1'bx, 8'bx00x1010});
assign p[27]  = cmp({dc, mx, ma}, {14'b00xxx0xxx1x01x, 1'bx, 8'b1xxxxxxx});
assign p[28]  = cmp({dc, mx, ma}, {14'b10xxxxxxxxxxx1, 1'b1, 8'bx011xx00});
assign p[29]  = cmp({dc, mx, ma}, {14'bxxxxxxx1xxxxxx, 1'bx, 8'b01x001x0});
assign p[30]  = cmp({dc, mx, ma}, {14'bxx101xxx1xx1xx, 1'bx, 8'b100xx011});
assign p[31]  = cmp({dc, mx, ma}, {14'b1xxxxxxxxxx1xx, 1'bx, 8'bx01x1010});
assign p[32]  = cmp({dc, mx, ma}, {14'b0xxxxxxxxxx1xx, 1'bx, 8'bx01x0010});
assign p[33]  = cmp({dc, mx, ma}, {14'b1xxxxxxxxxx0x1, 1'bx, 8'bx0xx0x0x});
assign p[34]  = cmp({dc, mx, ma}, {14'bxxx1xxxxxxxxxx, 1'bx, 8'b00x1x10x});
assign p[35]  = cmp({dc, mx, ma}, {14'bxx101xxx0xx1xx, 1'bx, 8'b100xx01x});
assign p[36]  = cmp({dc, mx, ma}, {14'b1xxxx0xxxxx011, 1'bx, 8'b1xxxxxxx});
assign p[37]  = cmp({dc, mx, ma}, {14'bxx1x1xxx01x1xx, 1'bx, 8'bxx001x0x});
assign p[38]  = cmp({dc, mx, ma}, {14'bxx111xxxxxx1xx, 1'bx, 8'b100xx01x});
assign p[39]  = cmp({dc, mx, ma}, {14'b1xxxxxxxxxxxxx, 1'bx, 8'b01x00001});
assign p[40]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bx11111x1});
assign p[41]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01xx011x});
assign p[42]  = cmp({dc, mx, ma}, {14'bx0xxxxxxx1x1xx, 1'bx, 8'bx0x10x01});
assign p[43]  = cmp({dc, mx, ma}, {14'b00xxxxxxxxx1xx, 1'bx, 8'bx01x1010});
assign p[44]  = cmp({dc, mx, ma}, {14'b0xxxxxxxxxx111, 1'bx, 8'bx0xx0x00});
assign p[45]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01x10000});
assign p[46]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b10x1xxxx});
assign p[47]  = cmp({dc, mx, ma}, {14'b10xxxxxxxx0xx1, 1'bx, 8'bx0111x0x});
assign p[48]  = cmp({dc, mx, ma}, {14'b11xxxxxxxxxxx1, 1'bx, 8'bx0xx101x});
assign p[49]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx0xx, 1'bx, 8'b0x1010x1});
assign p[50]  = cmp({dc, mx, ma}, {14'b0xxxxxxxxx0xx1, 1'bx, 8'bx0111x01});
assign p[51]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b011x11xx});
assign p[52]  = cmp({dc, mx, ma}, {14'b0xxxxxxxxxx1x1, 1'b0, 8'bx0xxx011});
assign p[53]  = cmp({dc, mx, ma}, {14'bxxxxx0xxx1xxxx, 1'b1, 8'b00xx001x});
assign p[54]  = cmp({dc, mx, ma}, {14'bx1xxx0x1xxx1xx, 1'bx, 8'b00x10x01});
assign p[55]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b000xx101});
assign p[56]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0xx00000});
assign p[57]  = cmp({dc, mx, ma}, {14'b0xxxxxxxx0xxx1, 1'b0, 8'bx00x101x});
assign p[58]  = cmp({dc, mx, ma}, {14'b1xxxxxxxxxx1xx, 1'bx, 8'bx01x0010});
assign p[59]  = cmp({dc, mx, ma}, {14'bxxxxx1xxxxx1x0, 1'bx, 8'bxx1010x1});
assign p[60]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b00x000xx});
assign p[61]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0101x101});
assign p[62]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'b1x01x1x1});
assign p[63]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01x11011});
assign p[64]  = cmp({dc, mx, ma}, {14'bxxxxx1xxxx1xxx, 1'bx, 8'b001110xx});
assign p[65]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bxx00x011});
assign p[66]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'bxx000x0x});
assign p[67]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bx00x001x});
assign p[68]  = cmp({dc, mx, ma}, {14'bx1xxxxxxx0x010, 1'bx, 8'b1xxxxxxx});
assign p[69]  = cmp({dc, mx, ma}, {14'bxxxxx0xxxxxxx1, 1'bx, 8'b00x00x00});
assign p[70]  = cmp({dc, mx, ma}, {14'bxxxxxxxxx10xx0, 1'bx, 8'b00x100xx});
assign p[71]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b1x11xx10});
assign p[72]  = cmp({dc, mx, ma}, {14'bxx1x1xxx00x1xx, 1'bx, 8'bx1001x0x});
assign p[73]  = cmp({dc, mx, ma}, {14'bx0xxxxxxxx1xx1, 1'b1, 8'bx0xx101x});
assign p[74]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'b1x100x0x});
assign p[75]  = cmp({dc, mx, ma}, {14'bxxxxxxx0xxxxxx, 1'bx, 8'b011xx1x0});
assign p[76]  = cmp({dc, mx, ma}, {14'b10xxxxxxxxx1xx, 1'bx, 8'bxx101001});
assign p[77]  = cmp({dc, mx, ma}, {14'bxxx11xxxxxx1xx, 1'bx, 8'bx1001x0x});
assign p[78]  = cmp({dc, mx, ma}, {14'bxxxxxxxxx1xx10, 1'bx, 8'bx0xxx01x});
assign p[79]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0x10x01x});
assign p[80]  = cmp({dc, mx, ma}, {14'b0xxxxxxxxx01xx, 1'bx, 8'bxx101001});
assign p[81]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'b1x10xx11});
assign p[82]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b00xx0101});
assign p[83]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01x1111x});
assign p[84]  = cmp({dc, mx, ma}, {14'bxx1x1xxx1xx1xx, 1'bx, 8'bx1001x0x});
assign p[85]  = cmp({dc, mx, ma}, {14'b10xxxxxxxxxxx1, 1'bx, 8'bx0xx1011});
assign p[86]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxx1xx0, 1'bx, 8'b001110xx});
assign p[87]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx000, 1'bx, 8'b11xxxxxx});
assign p[88]  = cmp({dc, mx, ma}, {14'b00xxxxxxxxxxxx, 1'bx, 8'b0110x0x1});
assign p[89]  = cmp({dc, mx, ma}, {14'b0xxxxxxxxxx1xx, 1'bx, 8'bx0x11x00});
assign p[90]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b100xx11x});
assign p[91]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01110x11});
assign p[92]  = cmp({dc, mx, ma}, {14'bxx11xxxxxxx1xx, 1'bx, 8'bx1001x0x});
assign p[93]  = cmp({dc, mx, ma}, {14'bxxxxxxx0xxxxx0, 1'bx, 8'b001110xx});
assign p[94]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b00101101});
assign p[95]  = cmp({dc, mx, ma}, {14'bxx001xxxxxx1xx, 1'bx, 8'bx1001x0x});
assign p[96]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'b1x01xx10});
assign p[97]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxx1xxx, 1'bx, 8'b00x1xx00});
assign p[98]  = cmp({dc, mx, ma}, {14'b00xxxxxxx00011, 1'bx, 8'b1xxxxxxx});
assign p[99]  = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'b1, 8'bx0x100x1});
assign p[100] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b1000x1xx});
assign p[101] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'b0, 8'b01111x01});
assign p[102] = cmp({dc, mx, ma}, {14'bxxxxx1xxxxxxx0, 1'bx, 8'b00x10x0x});
assign p[103] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0x0000xx});
assign p[104] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0xx1x100});
assign p[105] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b1011000x});
assign p[106] = cmp({dc, mx, ma}, {14'bx0xxx0xxx011x0, 1'bx, 8'b1x000xxx});
assign p[107] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx00x, 1'bx, 8'b10xxxxxx});
assign p[108] = cmp({dc, mx, ma}, {14'b00xxx0xxxx01x0, 1'bx, 8'bxx000x0x});
assign p[109] = cmp({dc, mx, ma}, {14'bx0xxx0xxx1x1x0, 1'bx, 8'b111xxxxx});
assign p[110] = cmp({dc, mx, ma}, {14'b11xxxxxxxxx1x0, 1'bx, 8'bxx000x0x});
assign p[111] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'b1x1100x1});
assign p[112] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b00011x00});
assign p[113] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b101xx01x});
assign p[114] = cmp({dc, mx, ma}, {14'b11xxxxxxxxxxx1, 1'bx, 8'bx01x1001});
assign p[115] = cmp({dc, mx, ma}, {14'bxxx0xxxxx1x1xx, 1'bx, 8'b101xxxxx});
assign p[116] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bx00x00x1});
assign p[117] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b11110x11});
assign p[118] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0xxxx110});
assign p[119] = cmp({dc, mx, ma}, {14'b01xxx0xxx1101x, 1'bx, 8'b1xxxxxxx});
assign p[120] = cmp({dc, mx, ma}, {14'b11xxxxxxxxx1xx, 1'bx, 8'bx0x110x0});
assign p[121] = cmp({dc, mx, ma}, {14'bx0xxx1xxx011x0, 1'bx, 8'b1x000xxx});
assign p[122] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bx011010x});
assign p[123] = cmp({dc, mx, ma}, {14'bxx100xxx0xx1xx, 1'bx, 8'bx1001x0x});
assign p[124] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0111x1xx});
assign p[125] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0001x001});
assign p[126] = cmp({dc, mx, ma}, {14'b01xxx1xxxxx1x0, 1'bx, 8'b110x0xxx});
assign p[127] = cmp({dc, mx, ma}, {14'bxxxxxxxxx0x1x0, 1'bx, 8'b1x10xxxx});
assign p[128] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bx110xx10});
assign p[129] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bx000x0xx});
assign p[130] = cmp({dc, mx, ma}, {14'b1xxxxxxxxxxxx1, 1'bx, 8'bx0x00x00});
assign p[131] = cmp({dc, mx, ma}, {14'bxx00xxxxxxx1xx, 1'bx, 8'b100xx01x});
assign p[132] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx001, 1'bx, 8'b1xxxxxxx});
assign p[133] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0101x0xx});
assign p[134] = cmp({dc, mx, ma}, {14'bxx010xxxxxx1x0, 1'bx, 8'b11x01xxx});
assign p[135] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b1111x011});
assign p[136] = cmp({dc, mx, ma}, {14'b0xxxxxxxx01xxx, 1'b1, 8'b00x10x0x});
assign p[137] = cmp({dc, mx, ma}, {14'bx0xxx1xxx1x11x, 1'bx, 8'b111xxxxx});
assign p[138] = cmp({dc, mx, ma}, {14'b0xxxx1xxxx01x0, 1'bx, 8'b1x000xxx});
assign p[139] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'b1xx1x101});
assign p[140] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b000xx011});
assign p[141] = cmp({dc, mx, ma}, {14'bx1xxx1xxx1x1x0, 1'bx, 8'b111xxxxx});
assign p[142] = cmp({dc, mx, ma}, {14'bxx100xxx1xx1xx, 1'bx, 8'b11001x0x});
assign p[143] = cmp({dc, mx, ma}, {14'bxxx0xxxxxxxxxx, 1'bx, 8'b00x1x10x});
assign p[144] = cmp({dc, mx, ma}, {14'bx1xxx0xxx111x0, 1'bx, 8'b11x00xxx});
assign p[145] = cmp({dc, mx, ma}, {14'bxxxxxxxxxx11x0, 1'bx, 8'b1101xxxx});
assign p[146] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b1x00x111});
assign p[147] = cmp({dc, mx, ma}, {14'bxx0x1xxxxxx110, 1'bx, 8'b1xx01xxx});
assign p[148] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'b1x1x1x01});
assign p[149] = cmp({dc, mx, ma}, {14'b1xxxxxxxx0xxxx, 1'b0, 8'b001x0x00});
assign p[150] = cmp({dc, mx, ma}, {14'bxxxxxx0xxxx10x, 1'bx, 8'b1xxxxxxx});
assign p[151] = cmp({dc, mx, ma}, {14'bxxxxxx0xxxx100, 1'bx, 8'b1xxx0xxx});
assign p[152] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01x0x11x});
assign p[153] = cmp({dc, mx, ma}, {14'b1xxxxxxxxx01x0, 1'bx, 8'b1x000xxx});
assign p[154] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b1x11xx00});
assign p[155] = cmp({dc, mx, ma}, {14'bxx000xxxxxx1x0, 1'bx, 8'b11x01xxx});
assign p[156] = cmp({dc, mx, ma}, {14'bxxxxx0xxxx1xxx, 1'bx, 8'b001010x1});
assign p[157] = cmp({dc, mx, ma}, {14'bxxxx0xxxxxx1xx, 1'bx, 8'b100xx01x});
assign p[158] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1x1, 1'bx, 8'b1x01xx0x});
assign p[159] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b1x00xx10});
assign p[160] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxx10, 1'bx, 8'b101xx11x});
assign p[161] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01x001x1});
assign p[162] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxx10, 1'bx, 8'b10xx100x});
assign p[163] = cmp({dc, mx, ma}, {14'b1xxxxxxxx11111, 1'bx, 8'b1xxx0xxx});
assign p[164] = cmp({dc, mx, ma}, {14'bx0xxxxxxx1x110, 1'bx, 8'b1x0x0xxx});
assign p[165] = cmp({dc, mx, ma}, {14'bx1xxxxxxxxxxxx, 1'bx, 8'b00xx1010});
assign p[166] = cmp({dc, mx, ma}, {14'bx1xxx0xxx011xx, 1'bx, 8'b1x0x0x00});
assign p[167] = cmp({dc, mx, ma}, {14'bxxx1xxxxxxxx10, 1'bx, 8'b1010xxxx});
assign p[168] = cmp({dc, mx, ma}, {14'b01xxxxxxx001x0, 1'bx, 8'b1x0x0xx0});
assign p[169] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx100, 1'bx, 8'b1xx1xxxx});
assign p[170] = cmp({dc, mx, ma}, {14'bxxxxxxxxx0xxx0, 1'bx, 8'b00x100xx});
assign p[171] = cmp({dc, mx, ma}, {14'bxxxxx1xxx1x01x, 1'bx, 8'b1xxxxxxx});
assign p[172] = cmp({dc, mx, ma}, {14'bxxxxxx0xxxx1x1, 1'bx, 8'b1xx0xx0x});
assign p[173] = cmp({dc, mx, ma}, {14'bxxxxxxxxx0x111, 1'bx, 8'b1x1xxxxx});
assign p[174] = cmp({dc, mx, ma}, {14'bxxxxxxxxxx1xx1, 1'bx, 8'b001010x1});
assign p[175] = cmp({dc, mx, ma}, {14'bxxxxx0xxxxxx10, 1'bx, 8'b10x111xx});
assign p[176] = cmp({dc, mx, ma}, {14'bxxxxxxxxx0x1x1, 1'bx, 8'b1xx0xx0x});
assign p[177] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b101x1x0x});
assign p[178] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b000x0x0x});
assign p[179] = cmp({dc, mx, ma}, {14'bxxxxxxxxxx11x1, 1'bx, 8'b1xx00x0x});
assign p[180] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx10x, 1'bx, 8'b1xx00xx1});
assign p[181] = cmp({dc, mx, ma}, {14'bxx010xxxxxx1x1, 1'bx, 8'bx1001x0x});
assign p[182] = cmp({dc, mx, ma}, {14'b1xxxxxxxxx0111, 1'bx, 8'b1xxx0xxx});
assign p[183] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'b1, 8'b01111x01});
assign p[184] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxx10, 1'bx, 8'bx00x0x00});
assign p[185] = cmp({dc, mx, ma}, {14'bxx1x1xxx1xxx10, 1'bx, 8'bx1x01xxx});
assign p[186] = cmp({dc, mx, ma}, {14'bx0xxxxxxxxxx1x, 1'bx, 8'bx00x010x});
assign p[187] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxx10, 1'b0, 8'b10x11x0x});
assign p[188] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bx101x0x1});
assign p[189] = cmp({dc, mx, ma}, {14'bx1xxxxx1xxxxx0, 1'bx, 8'b001110xx});
assign p[190] = cmp({dc, mx, ma}, {14'b0xxxxxxxxxx1xx, 1'bx, 8'b10011x0x});
assign p[191] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b10011x0x});
assign p[192] = cmp({dc, mx, ma}, {14'bxx11xxxxxxx110, 1'bx, 8'b11x01xxx});
assign p[193] = cmp({dc, mx, ma}, {14'bxxxxxx1xxxx100, 1'bx, 8'b1x1xxxxx});
assign p[194] = cmp({dc, mx, ma}, {14'bxx100xxx0xx110, 1'bx, 8'b11x01xxx});
assign p[195] = cmp({dc, mx, ma}, {14'bx1xxx1xxx1x1x0, 1'bx, 8'b1x0x0xxx});
assign p[196] = cmp({dc, mx, ma}, {14'bxx011xxxxxxx10, 1'bx, 8'b100xx011});
assign p[197] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'b1x101x0x});
assign p[198] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b00xxx111});
assign p[199] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxx10, 1'bx, 8'b1000xxxx});
assign p[200] = cmp({dc, mx, ma}, {14'bxxxxxxxxx0x10x, 1'bx, 8'b1xx0xxxx});
assign p[201] = cmp({dc, mx, ma}, {14'bxxxxx1xxxxx111, 1'bx, 8'b1xxx0xxx});
assign p[202] = cmp({dc, mx, ma}, {14'bxxxxxx0xx00111, 1'bx, 8'b1xxx0xxx});
assign p[203] = cmp({dc, mx, ma}, {14'bxxxxx0x0xx1xx0, 1'bx, 8'b00x10x0x});
assign p[204] = cmp({dc, mx, ma}, {14'bx1xxx0xxxx11x0, 1'bx, 8'bxx000x0x});
assign p[205] = cmp({dc, mx, ma}, {14'bx0xxxxxxx1x111, 1'bx, 8'b1xxx0xxx});
assign p[206] = cmp({dc, mx, ma}, {14'bxx000xxxxxx1x1, 1'bx, 8'bx1001x0x});
assign p[207] = cmp({dc, mx, ma}, {14'b0xxxxx1xx01111, 1'bx, 8'b1xxx0xxx});
assign p[208] = cmp({dc, mx, ma}, {14'bxxxxxxxxx1x111, 1'bx, 8'b1x100x0x});
assign p[209] = cmp({dc, mx, ma}, {14'b10xxx10xxx1111, 1'bx, 8'b1xxx0xxx});
assign p[210] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0x0x0011});
assign p[211] = cmp({dc, mx, ma}, {14'b1xxxxxxxxxx101, 1'bx, 8'b1xx00x0x});
assign p[212] = cmp({dc, mx, ma}, {14'bxxxx1xxxx11110, 1'bx, 8'b1xx01xxx});
assign p[213] = cmp({dc, mx, ma}, {14'bx0xxx1xxx1x1x0, 1'bx, 8'b111xxxxx});
assign p[214] = cmp({dc, mx, ma}, {14'b0xxxx0xxx101x1, 1'bx, 8'b1xx00x0x});
assign p[215] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0000xx01});
assign p[216] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxx1, 1'bx, 8'b0101x0x1});
assign p[217] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'bx01xx10x});
assign p[218] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0010x0x0});
assign p[219] = cmp({dc, mx, ma}, {14'b0xxxx0xxxx1111, 1'bx, 8'b1xxx0xxx});
assign p[220] = cmp({dc, mx, ma}, {14'b00xxxxxxxx1x10, 1'b0, 8'bx00x00x1});
assign p[221] = cmp({dc, mx, ma}, {14'b1xxxxxxxx01111, 1'bx, 8'b1x1xxxxx});
assign p[222] = cmp({dc, mx, ma}, {14'bx0xxx0xxx1xxxx, 1'bx, 8'b11x00x0x});
assign p[223] = cmp({dc, mx, ma}, {14'bxxxxxxx1xxxxx0, 1'bx, 8'b00xx0100});
assign p[224] = cmp({dc, mx, ma}, {14'b01xxxxxxxxxxx0, 1'bx, 8'b1001xx0x});
assign p[225] = cmp({dc, mx, ma}, {14'bxxxxxx0xxxxxx0, 1'b0, 8'b00x00x00});
assign p[226] = cmp({dc, mx, ma}, {14'bxx1x1xxx0xx1xx, 1'bx, 8'bxx011x01});
assign p[227] = cmp({dc, mx, ma}, {14'bx1xxxxxxxxxxxx, 1'bx, 8'b001x0010});
assign p[228] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b0x0x0101});
assign p[229] = cmp({dc, mx, ma}, {14'bxxxxxxxxx0x10x, 1'bx, 8'b1xx00x0x});
assign p[230] = cmp({dc, mx, ma}, {14'b01x1x0xxx10011, 1'bx, 8'b11xxxxxx});
assign p[231] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx101, 1'bx, 8'b1x100x0x});
assign p[232] = cmp({dc, mx, ma}, {14'bxxxxx01xx1x10x, 1'bx, 8'bxx000x0x});
assign p[233] = cmp({dc, mx, ma}, {14'b01xxxxxxxxxx10, 1'bx, 8'b100x0xxx});
assign p[234] = cmp({dc, mx, ma}, {14'b0xxxx1xxxx0x1x, 1'bx, 8'b1001x1xx});
assign p[235] = cmp({dc, mx, ma}, {14'b0xxxxxxxx1x0xx, 1'bx, 8'b001xx0xx});
assign p[236] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx11x, 1'bx, 8'b1xxx0x1x});
assign p[237] = cmp({dc, mx, ma}, {14'bx1x0xxxxx1xx10, 1'bx, 8'b101xxxxx});
assign p[238] = cmp({dc, mx, ma}, {14'bx0xxxxxxxx01x1, 1'bx, 8'b1xx00x0x});
assign p[239] = cmp({dc, mx, ma}, {14'bx1xxx1xxxxx1x1, 1'bx, 8'b1xx00x0x});
assign p[240] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'bx, 8'b01x11x00});
assign p[241] = cmp({dc, mx, ma}, {14'b00xxx0xxx10x1x, 1'bx, 8'b1xxx0xxx});
assign p[242] = cmp({dc, mx, ma}, {14'b00xxxxxxxx1x1x, 1'b1, 8'b100x00x1});
assign p[243] = cmp({dc, mx, ma}, {14'bxxxxx1x1x1xxx1, 1'bx, 8'bx011x0xx});
assign p[244] = cmp({dc, mx, ma}, {14'bxxxxxxx0xxx10x, 1'bx, 8'b1x110x01});
assign p[245] = cmp({dc, mx, ma}, {14'bxxx11xxxx0xx10, 1'bx, 8'b1x10xxxx});
assign p[246] = cmp({dc, mx, ma}, {14'bxx1x1xxx1xxxxx, 1'bx, 8'b00101x00});
assign p[247] = cmp({dc, mx, ma}, {14'bxxxxxx1xxxx1x1, 1'bx, 8'b1xx00x0x});
assign p[248] = cmp({dc, mx, ma}, {14'b11xxx0xxxxx1x0, 1'bx, 8'b110x0xxx});
assign p[249] = cmp({dc, mx, ma}, {14'b00xxxxxxxxxxxx, 1'bx, 8'bx0110x01});
assign p[250] = cmp({dc, mx, ma}, {14'b1xxxxxxxxxxx1x, 1'b0, 8'b100x0xx1});
assign p[251] = cmp({dc, mx, ma}, {14'bx0xxx0xxxxx1xx, 1'bx, 8'b10x111xx});
assign p[252] = cmp({dc, mx, ma}, {14'bxx1x1xxx1xx1x1, 1'bx, 8'b11100x0x});
assign p[253] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'b1, 8'b000x1010});
assign p[254] = cmp({dc, mx, ma}, {14'b00xxxxxxxx0x1x, 1'bx, 8'b100x0xx1});
assign p[255] = cmp({dc, mx, ma}, {14'bxx1x1xxx0xx1x0, 1'bx, 8'b11x01xxx});
assign p[256] = cmp({dc, mx, ma}, {14'bx11xx0xx0101xx, 1'bx, 8'b11001x0x});
assign p[257] = cmp({dc, mx, ma}, {14'bx110100x0101xx, 1'bx, 8'b11001x0x});
assign p[258] = cmp({dc, mx, ma}, {14'bxxxxx0xxxxxxx1, 1'b1, 8'bx0xx0100});
assign p[259] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'b1, 8'b0100x011});
assign p[260] = cmp({dc, mx, ma}, {14'bx1xxx0xxx1011x, 1'bx, 8'b1x1xxxxx});
assign p[261] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxxxxx, 1'b1, 8'b0x011001});
assign p[262] = cmp({dc, mx, ma}, {14'b0xxxxxxxxxxx1x, 1'b0, 8'b10011001});
assign p[263] = cmp({dc, mx, ma}, {14'bx1xxx0xxx101xx, 1'bx, 8'bx0x0xxxx});
assign p[264] = cmp({dc, mx, ma}, {14'bxxxxx0xxx1010x, 1'bx, 8'b1x10xx01});
assign p[265] = cmp({dc, mx, ma}, {14'bxxxxxxxxxxx1xx, 1'bx, 8'bxx001x00});
assign p[266] = cmp({dc, mx, ma}, {14'bx1xx10xxx101xx, 1'bx, 8'b11001x0x});
assign p[267] = cmp({dc, mx, ma}, {14'bxxxxx0xxx10101, 1'bx, 8'b111x0x00});
assign p[268] = cmp({dc, mx, ma}, {14'bxxxxxx1xxxxxx0, 1'b1, 8'b00x00x00});
assign p[269] = cmp({dc, mx, ma}, {14'b1xxxxxxxxx1x1x, 1'bx, 8'b100xx11x});
assign p[270] = cmp({dc, mx, ma}, {14'bxxx11xxxxxx110, 1'bx, 8'b1xx01xxx});
assign p[271] = cmp({dc, mx, ma}, {14'b00xxxxxxxx1x1x, 1'b0, 8'b100111xx});
assign p[272] = cmp({dc, mx, ma}, {14'bx1xxxxxxxx1xxx, 1'bx, 8'b001110xx});
assign p[273] = cmp({dc, mx, ma}, {14'b00xxxxxxxxx0xx, 1'bx, 8'b00xx0x0x});
assign p[274] = cmp({dc, mx, ma}, {14'b0xxxxxxxxx1x1x, 1'bx, 8'b1011000x});
assign p[275] = cmp({dc, mx, ma}, {14'bxxxxx0xxx1xxxx, 1'b0, 8'b00xx001x});
assign p[276] = cmp({dc, mx, ma}, {14'bxxxxx1xxx01111, 1'bx, 8'b1x1xxxxx});
assign p[277] = cmp({dc, mx, ma}, {14'bx111x0xxx101xx, 1'bx, 8'b11001x0x});
assign p[278] = cmp({dc, mx, ma}, {14'bxxx11xxxx1x110, 1'bx, 8'b1xx01xxx});
assign p[279] = cmp({dc, mx, ma}, {14'bxxxxxxxxx00111, 1'bx, 8'b1x1xxxxx});
assign p[280] = cmp({dc, mx, ma}, {14'bxx1x1xxx11x110, 1'bx, 8'b1xxx1xxx});

assign pl[0]  = p[279] | p[276] | p[274] | p[265] | p[251] | p[243] | p[232] | p[223]
              | p[209] | p[203] | p[193] | p[189] | p[167] | p[151] | p[144] | p[141]
              | p[115] | p[114] | p[112] | p[103] | p[101] | p[98]  | p[91]  | p[88]
              | p[86]  | p[80]  | p[76]  | p[70]  | p[62]  | p[61]  | p[58]  | p[54]
              | p[52]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]
              | p[32]  | p[31]  | p[29]  | p[28]  | p[17]  | p[12]  | p[9]   | p[4]
              | p[3];

assign pl[1]  = p[271] | p[269] | p[262] | p[251] | p[240] | p[226] | p[224] | p[216]
              | p[206] | p[203] | p[198] | p[197] | p[196] | p[195] | p[193] | p[189]
              | p[188] | p[186] | p[184] | p[183] | p[181] | p[178] | p[174] | p[171]
              | p[170] | p[169] | p[168] | p[166] | p[165] | p[164] | p[161] | p[160]
              | p[158] | p[157] | p[156] | p[155] | p[154] | p[152] | p[151] | p[148]
              | p[145] | p[144] | p[143] | p[142] | p[141] | p[139] | p[138] | p[135]
              | p[134] | p[132] | p[131] | p[130] | p[129] | p[127] | p[125] | p[123]
              | p[121] | p[118] | p[117] | p[116] | p[115] | p[114] | p[113] | p[111]
              | p[109] | p[108] | p[107] | p[106] | p[104] | p[103] | p[101] | p[100]
              | p[98]  | p[96]  | p[95]  | p[93]  | p[92]  | p[91]  | p[88]  | p[86]
              | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]
              | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]
              | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]  | p[62]  | p[61]
              | p[60]  | p[59]  | p[58]  | p[56]  | p[54]  | p[53]  | p[50]  | p[49]
              | p[47]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]
              | p[35]  | p[34]  | p[33]  | p[30]  | p[29]  | p[27]  | p[25]  | p[24]
              | p[23]  | p[22]  | p[21]  | p[18]  | p[17]  | p[15]  | p[14]  | p[11]
              | p[10]  | p[8]   | p[7]   | p[4]   | p[3]   | p[2]   | p[1];

assign pl[2]  = p[261] | p[259] | p[249] | p[245] | p[234] | p[218] | p[216] | p[215]
              | p[207] | p[206] | p[202] | p[198] | p[184] | p[183] | p[181] | p[175]
              | p[174] | p[171] | p[169] | p[167] | p[164] | p[162] | p[155] | p[154]
              | p[153] | p[152] | p[149] | p[145] | p[144] | p[141] | p[140] | p[134]
              | p[132] | p[130] | p[126] | p[120] | p[118] | p[117] | p[114] | p[113]
              | p[112] | p[110] | p[109] | p[107] | p[105] | p[102] | p[101] | p[99]
              | p[98]  | p[93]  | p[91]  | p[90]  | p[89]  | p[88]  | p[86]  | p[80]
              | p[76]  | p[63]  | p[60]  | p[59]  | p[58]  | p[53]  | p[52]  | p[51]
              | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]  | p[42]
              | p[36]  | p[33]  | p[32]  | p[31]  | p[28]  | p[27]  | p[26]  | p[25]
              | p[22]  | p[21]  | p[20]  | p[17]  | p[16]  | p[12]  | p[9]   | p[7]
              | p[6]   | p[5]   | p[4]   | p[3]   | p[1]   | p[0];

assign pl[3]  = p[275] | p[273] | p[251] | p[246] | p[245] | p[244] | p[236] | p[232]
              | p[231] | p[226] | p[221] | p[210] | p[209] | p[208] | p[203] | p[195]
              | p[190] | p[188] | p[187] | p[183] | p[177] | p[168] | p[167] | p[156]
              | p[154] | p[151] | p[148] | p[146] | p[145] | p[140] | p[138] | p[137]
              | p[135] | p[129] | p[125] | p[123] | p[121] | p[115] | p[109] | p[108]
              | p[106] | p[103] | p[102] | p[96]  | p[95]  | p[93]  | p[92]  | p[88]
              | p[86]  | p[84]  | p[81]  | p[77]  | p[76]  | p[72]  | p[71]  | p[70]
              | p[65]  | p[63]  | p[61]  | p[59]  | p[54]  | p[52]  | p[51]  | p[50]
              | p[48]  | p[47]  | p[44]  | p[43]  | p[41]  | p[40]  | p[37]  | p[36]
              | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[19]  | p[12]  | p[8]
              | p[7]   | p[5]   | p[3]   | p[1];

assign pl[4]  = p[206] | p[203] | p[197] | p[193] | p[189] | p[186] | p[181] | p[178]
              | p[170] | p[168] | p[167] | p[166] | p[165] | p[161] | p[158] | p[157]
              | p[156] | p[155] | p[151] | p[144] | p[143] | p[142] | p[141] | p[139]
              | p[138] | p[135] | p[134] | p[131] | p[129] | p[123] | p[121] | p[115]
              | p[111] | p[108] | p[104] | p[103] | p[100] | p[95]  | p[92]  | p[88]
              | p[87]  | p[85]  | p[84]  | p[83]  | p[82]  | p[79]  | p[78]  | p[77]
              | p[75]  | p[74]  | p[73]  | p[72]  | p[70]  | p[69]  | p[68]  | p[67]
              | p[66]  | p[64]  | p[60]  | p[56]  | p[54]  | p[51]  | p[49]  | p[39]
              | p[38]  | p[37]  | p[35]  | p[34]  | p[33]  | p[29]  | p[24]  | p[17]
              | p[15]  | p[14]  | p[13]  | p[11]  | p[10]  | p[3]   | p[2]   | p[1];

assign pl[5]  = p[251] | p[248] | p[206] | p[204] | p[198] | p[197] | p[189] | p[186]
              | p[184] | p[181] | p[167] | p[158] | p[155] | p[142] | p[139] | p[134]
              | p[133] | p[127] | p[124] | p[122] | p[118] | p[116] | p[111] | p[106]
              | p[105] | p[101] | p[100] | p[90]  | p[87]  | p[61]  | p[58]  | p[55]
              | p[48]  | p[47]  | p[43]  | p[31]  | p[29]  | p[23]  | p[19]  | p[18]
              | p[16]  | p[13]  | p[9]   | p[8];

assign pl[6]  = p[280] | p[278] | p[252] | p[248] | p[209] | p[207] | p[206] | p[202]
              | p[195] | p[193] | p[181] | p[178] | p[174] | p[170] | p[169] | p[166]
              | p[165] | p[161] | p[155] | p[151] | p[149] | p[145] | p[144] | p[143]
              | p[142] | p[141] | p[140] | p[134] | p[130] | p[127] | p[120] | p[119]
              | p[118] | p[114] | p[112] | p[109] | p[106] | p[104] | p[102] | p[99]
              | p[98]  | p[93]  | p[89]  | p[86]  | p[85]  | p[83]  | p[82]  | p[80]
              | p[79]  | p[78]  | p[76]  | p[75]  | p[73]  | p[70]  | p[69]  | p[68]
              | p[67]  | p[66]  | p[64]  | p[60]  | p[59]  | p[58]  | p[56]  | p[55]
              | p[53]  | p[52]  | p[50]  | p[48]  | p[47]  | p[46]  | p[44]  | p[43]
              | p[42]  | p[38]  | p[36]  | p[35]  | p[34]  | p[32]  | p[31]  | p[30]
              | p[28]  | p[27]  | p[26]  | p[25]  | p[22]  | p[21]  | p[18]  | p[16]
              | p[15]  | p[14]  | p[11]  | p[10]  | p[9]   | p[7]   | p[6]   | p[5]
              | p[4]   | p[2]   | p[0];

assign pl[7]  = p[203] | p[198] | p[196] | p[195] | p[193] | p[186] | p[183] | p[178]
              | p[174] | p[171] | p[170] | p[169] | p[168] | p[167] | p[166] | p[165]
              | p[164] | p[161] | p[157] | p[156] | p[152] | p[151] | p[149] | p[145]
              | p[144] | p[143] | p[141] | p[140] | p[138] | p[135] | p[133] | p[132]
              | p[131] | p[130] | p[125] | p[124] | p[121] | p[120] | p[118] | p[114]
              | p[112] | p[109] | p[108] | p[107] | p[104] | p[102] | p[101] | p[100]
              | p[99]  | p[98]  | p[93]  | p[91]  | p[89]  | p[88]  | p[87]  | p[86]
              | p[85]  | p[83]  | p[82]  | p[80]  | p[79]  | p[78]  | p[76]  | p[75]
              | p[74]  | p[73]  | p[70]  | p[69]  | p[68]  | p[67]  | p[66]  | p[64]
              | p[63]  | p[61]  | p[60]  | p[59]  | p[58]  | p[56]  | p[55]  | p[54]
              | p[53]  | p[52]  | p[51]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]
              | p[44]  | p[43]  | p[42]  | p[41]  | p[39]  | p[38]  | p[36]  | p[35]
              | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[28]  | p[27]  | p[26]
              | p[25]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[17]
              | p[16]  | p[15]  | p[14]  | p[13]  | p[12]  | p[11]  | p[10]  | p[9]
              | p[8]   | p[7]   | p[6]   | p[5]   | p[4]   | p[3]   | p[2]   | p[1]
              | p[0];

assign pl[8]  = p[212] | p[210] | p[206] | p[203] | p[197] | p[194] | p[193] | p[192]
              | p[189] | p[188] | p[185] | p[183] | p[181] | p[178] | p[171] | p[170]
              | p[168] | p[167] | p[166] | p[165] | p[164] | p[162] | p[161] | p[159]
              | p[158] | p[156] | p[155] | p[154] | p[153] | p[152] | p[151] | p[149]
              | p[148] | p[147] | p[146] | p[143] | p[142] | p[140] | p[139] | p[138]
              | p[137] | p[136] | p[135] | p[134] | p[132] | p[130] | p[128] | p[127]
              | p[126] | p[125] | p[124] | p[121] | p[120] | p[118] | p[117] | p[115]
              | p[114] | p[112] | p[111] | p[110] | p[109] | p[108] | p[107] | p[106]
              | p[104] | p[103] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]
              | p[94]  | p[93]  | p[91]  | p[89]  | p[88]  | p[87]  | p[86]  | p[85]
              | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[76]  | p[75]
              | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[67]
              | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[59]
              | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[52]  | p[51]
              | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[44]  | p[43]
              | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[36]  | p[35]  | p[34]
              | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]
              | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]
              | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[12]  | p[11]  | p[10]
              | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[4]   | p[3]   | p[2]
              | p[1]   | p[0];

assign pl[9]  = p[213] | p[206] | p[188] | p[159] | p[155] | p[136] | p[123] | p[97]
              | p[96]  | p[95]  | p[94]  | p[72]  | p[65]  | p[57]  | p[37];

assign pl[10] = p[246] | p[243] | p[235] | p[232] | p[223] | p[218] | p[209] | p[207]
              | p[204] | p[203] | p[202] | p[198] | p[197] | p[196] | p[193] | p[191]
              | p[189] | p[186] | p[184] | p[183] | p[181] | p[177] | p[175] | p[174]
              | p[171] | p[169] | p[168] | p[167] | p[164] | p[162] | p[160] | p[158]
              | p[156] | p[154] | p[153] | p[152] | p[151] | p[149] | p[148] | p[146]
              | p[145] | p[144] | p[142] | p[141] | p[140] | p[139] | p[138] | p[137]
              | p[136] | p[135] | p[134] | p[133] | p[132] | p[130] | p[129] | p[128]
              | p[127] | p[126] | p[125] | p[124] | p[122] | p[121] | p[120] | p[119]
              | p[118] | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[111]
              | p[110] | p[109] | p[108] | p[107] | p[106] | p[105] | p[104] | p[103]
              | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[94]  | p[93]
              | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[87]  | p[86]  | p[84]
              | p[83]  | p[81]  | p[80]  | p[79]  | p[77]  | p[76]  | p[74]  | p[71]
              | p[70]  | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]
              | p[56]  | p[55]  | p[54]  | p[53]  | p[52]  | p[51]  | p[50]  | p[49]
              | p[48]  | p[47]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[40]
              | p[39]  | p[36]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[28]
              | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]
              | p[19]  | p[18]  | p[17]  | p[16]  | p[13]  | p[12]  | p[9]   | p[8]
              | p[7]   | p[6]   | p[5]   | p[4]   | p[3]   | p[1]   | p[0];

assign pl[11] = p[267] | p[264] | p[260] | p[213] | p[206] | p[196] | p[193] | p[191]
              | p[184] | p[181] | p[178] | p[177] | p[174] | p[169] | p[167] | p[165]
              | p[160] | p[159] | p[157] | p[156] | p[155] | p[153] | p[148] | p[146]
              | p[145] | p[144] | p[143] | p[142] | p[141] | p[136] | p[135] | p[134]
              | p[131] | p[128] | p[127] | p[126] | p[124] | p[122] | p[121] | p[120]
              | p[119] | p[116] | p[115] | p[113] | p[111] | p[110] | p[109] | p[108]
              | p[106] | p[105] | p[103] | p[102] | p[98]  | p[97]  | p[96]  | p[95]
              | p[94]  | p[92]  | p[90]  | p[89]  | p[88]  | p[87]  | p[86]  | p[84]
              | p[82]  | p[81]  | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[72]
              | p[71]  | p[70]  | p[69]  | p[68]  | p[67]  | p[66]  | p[64]  | p[63]
              | p[62]  | p[61]  | p[60]  | p[57]  | p[56]  | p[52]  | p[51]  | p[50]
              | p[49]  | p[47]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[38]
              | p[37]  | p[36]  | p[35]  | p[34]  | p[31]  | p[30]  | p[29]  | p[26]
              | p[25]  | p[24]  | p[23]  | p[21]  | p[20]  | p[19]  | p[18]  | p[17]
              | p[14]  | p[12]  | p[11]  | p[9]   | p[7]   | p[5]   | p[4]   | p[2]
              | p[1]   | p[0];

assign pl[12] = p[151] | p[127] | p[89]  | p[76]  | p[72]  | p[46]  | p[37]  | p[31]
              | p[9]   | p[7];

assign pl[13] = p[214] | p[183] | p[180] | p[150] | p[127] | p[125] | p[101] | p[89]
              | p[80]  | p[76]  | p[70]  | p[46]  | p[28]  | p[13]  | p[8]   | p[7]
              | p[6]   | p[0];

assign pl[14] = p[232] | p[151] | p[89]  | p[76]  | p[70]  | p[31]  | p[26]  | p[7]
              | p[6]   | p[0];

assign pl[15] = p[215] | p[210] | p[204] | p[196] | p[193] | p[189] | p[186] | p[174]
              | p[169] | p[168] | p[157] | p[154] | p[153] | p[144] | p[141] | p[139]
              | p[138] | p[137] | p[131] | p[130] | p[129] | p[124] | p[119] | p[117]
              | p[116] | p[110] | p[100] | p[97]  | p[93]  | p[91]  | p[83]  | p[79]
              | p[78]  | p[76]  | p[74]  | p[70]  | p[68]  | p[65]  | p[64]  | p[63]
              | p[61]  | p[59]  | p[57]  | p[54]  | p[52]  | p[44]  | p[41]  | p[40]
              | p[39]  | p[38]  | p[35]  | p[34]  | p[30]  | p[26]  | p[21]  | p[20]
              | p[18]  | p[17]  | p[16]  | p[11]  | p[5]   | p[3]   | p[0];

assign pl[16] = p[227] | p[212] | p[206] | p[198] | p[197] | p[194] | p[193] | p[192]
              | p[189] | p[188] | p[185] | p[183] | p[181] | p[178] | p[171] | p[170]
              | p[167] | p[165] | p[164] | p[162] | p[161] | p[159] | p[158] | p[156]
              | p[155] | p[154] | p[153] | p[152] | p[151] | p[149] | p[148] | p[147]
              | p[146] | p[143] | p[142] | p[140] | p[139] | p[137] | p[136] | p[135]
              | p[134] | p[133] | p[132] | p[130] | p[128] | p[127] | p[126] | p[125]
              | p[124] | p[121] | p[120] | p[119] | p[118] | p[117] | p[115] | p[114]
              | p[111] | p[110] | p[109] | p[108] | p[107] | p[106] | p[104] | p[103]
              | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[94]  | p[93]
              | p[91]  | p[89]  | p[88]  | p[86]  | p[85]  | p[83]  | p[82]  | p[81]
              | p[80]  | p[79]  | p[78]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]
              | p[71]  | p[70]  | p[69]  | p[68]  | p[66]  | p[65]  | p[64]  | p[63]
              | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
              | p[54]  | p[53]  | p[52]  | p[51]  | p[50]  | p[49]  | p[48]  | p[46]
              | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]
              | p[36]  | p[35]  | p[34]  | p[33]  | p[31]  | p[30]  | p[29]  | p[28]
              | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]
              | p[19]  | p[18]  | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[12]
              | p[11]  | p[10]  | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[4]
              | p[3]   | p[2]   | p[1]   | p[0];

assign pl[17] = p[197] | p[191] | p[184] | p[178] | p[177] | p[171] | p[165] | p[164]
              | p[162] | p[160] | p[159] | p[158] | p[156] | p[154] | p[152] | p[148]
              | p[146] | p[145] | p[139] | p[137] | p[136] | p[135] | p[132] | p[128]
              | p[127] | p[122] | p[120] | p[118] | p[114] | p[113] | p[111] | p[109]
              | p[108] | p[107] | p[106] | p[105] | p[102] | p[101] | p[99]  | p[97]
              | p[96]  | p[94]  | p[90]  | p[89]  | p[87]  | p[86]  | p[83]  | p[81]
              | p[80]  | p[76]  | p[75]  | p[71]  | p[67]  | p[62]  | p[61]  | p[58]
              | p[57]  | p[56]  | p[54]  | p[52]  | p[51]  | p[50]  | p[49]  | p[48]
              | p[47]  | p[45]  | p[44]  | p[43]  | p[42]  | p[36]  | p[33]  | p[31]
              | p[29]  | p[25]  | p[23]  | p[22]  | p[19]  | p[17]  | p[13]  | p[12]
              | p[9]   | p[7]   | p[5]   | p[4]   | p[3]   | p[2]   | p[1];

assign pl[18] = p[232] | p[213] | p[209] | p[206] | p[204] | p[202] | p[198] | p[197]
              | p[189] | p[188] | p[183] | p[181] | p[174] | p[171] | p[170] | p[169]
              | p[168] | p[167] | p[164] | p[161] | p[159] | p[158] | p[155] | p[154]
              | p[153] | p[152] | p[151] | p[149] | p[148] | p[146] | p[145] | p[144]
              | p[143] | p[142] | p[141] | p[140] | p[139] | p[138] | p[136] | p[135]
              | p[134] | p[133] | p[132] | p[129] | p[128] | p[127] | p[126] | p[125]
              | p[124] | p[123] | p[121] | p[119] | p[118] | p[117] | p[115] | p[114]
              | p[112] | p[111] | p[110] | p[109] | p[108] | p[107] | p[106] | p[104]
              | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]
              | p[95]  | p[94]  | p[93]  | p[92]  | p[91]  | p[89]  | p[88]  | p[87]
              | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]
              | p[77]  | p[76]  | p[75]  | p[73]  | p[72]  | p[71]  | p[68]  | p[67]
              | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]
              | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[52]  | p[51]  | p[50]
              | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[44]  | p[42]  | p[41]
              | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]
              | p[32]  | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]
              | p[24]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[17]
              | p[16]  | p[15]  | p[14]  | p[13]  | p[12]  | p[10]  | p[9]   | p[8]
              | p[7]   | p[6]   | p[5]   | p[4]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[19] = p[215] | p[209] | p[204] | p[203] | p[186] | p[184] | p[183] | p[177]
              | p[168] | p[160] | p[144] | p[141] | p[138] | p[135] | p[126] | p[125]
              | p[122] | p[121] | p[113] | p[108] | p[106] | p[105] | p[101] | p[90]
              | p[16];

assign pl[20] = p[268] | p[258] | p[241] | p[230] | p[225] | p[215] | p[213] | p[210]
              | p[206] | p[202] | p[199] | p[196] | p[193] | p[189] | p[188] | p[186]
              | p[184] | p[181] | p[179] | p[177] | p[173] | p[171] | p[168] | p[167]
              | p[166] | p[164] | p[163] | p[160] | p[159] | p[157] | p[156] | p[155]
              | p[154] | p[153] | p[152] | p[148] | p[146] | p[145] | p[144] | p[142]
              | p[141] | p[139] | p[138] | p[136] | p[135] | p[134] | p[132] | p[131]
              | p[130] | p[128] | p[126] | p[124] | p[122] | p[121] | p[120] | p[119]
              | p[118] | p[117] | p[116] | p[115] | p[113] | p[111] | p[110] | p[109]
              | p[108] | p[107] | p[106] | p[105] | p[103] | p[102] | p[100] | p[98]
              | p[97]  | p[96]  | p[95]  | p[94]  | p[93]  | p[92]  | p[91]  | p[90]
              | p[87]  | p[84]  | p[83]  | p[82]  | p[81]  | p[79]  | p[78]  | p[77]
              | p[76]  | p[75]  | p[72]  | p[71]  | p[70]  | p[68]  | p[65]  | p[64]
              | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[57]  | p[56]  | p[54]
              | p[52]  | p[51]  | p[49]  | p[45]  | p[44]  | p[42]  | p[41]  | p[40]
              | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[30]  | p[29]
              | p[26]  | p[25]  | p[24]  | p[23]  | p[20]  | p[19]  | p[18]  | p[17]
              | p[16]  | p[12]  | p[9]   | p[7]   | p[5]   | p[4]   | p[3]   | p[2]
              | p[1]   | p[0];

assign pl[21] = p[270] | p[253] | p[239] | p[237] | p[228] | p[215] | p[210] | p[204]
              | p[202] | p[201] | p[199] | p[196] | p[193] | p[189] | p[188] | p[186]
              | p[184] | p[171] | p[170] | p[168] | p[165] | p[164] | p[157] | p[156]
              | p[154] | p[153] | p[152] | p[149] | p[146] | p[145] | p[144] | p[142]
              | p[141] | p[139] | p[138] | p[137] | p[135] | p[132] | p[131] | p[130]
              | p[126] | p[124] | p[121] | p[119] | p[118] | p[117] | p[110] | p[108]
              | p[107] | p[106] | p[103] | p[100] | p[98]  | p[97]  | p[94]  | p[93]
              | p[92]  | p[91]  | p[90]  | p[85]  | p[84]  | p[83]  | p[81]  | p[79]
              | p[78]  | p[76]  | p[72]  | p[70]  | p[69]  | p[68]  | p[65]  | p[64]
              | p[63]  | p[62]  | p[59]  | p[57]  | p[54]  | p[50]  | p[45]  | p[43]
              | p[42]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]
              | p[30]  | p[23]  | p[19]  | p[18]  | p[17]  | p[16]  | p[14]  | p[11]
              | p[10]  | p[5]   | p[4]   | p[3]   | p[1];

assign pl[22] = p[235] | p[215] | p[205] | p[201] | p[197] | p[183] | p[182] | p[181]
              | p[179] | p[177] | p[174] | p[169] | p[167] | p[163] | p[160] | p[158]
              | p[151] | p[149] | p[148] | p[145] | p[143] | p[140] | p[136] | p[134]
              | p[128] | p[125] | p[122] | p[120] | p[116] | p[115] | p[114] | p[113]
              | p[112] | p[111] | p[109] | p[105] | p[104] | p[102] | p[101] | p[99]
              | p[87]  | p[86]  | p[85]  | p[82]  | p[80]  | p[77]  | p[75]  | p[74]
              | p[71]  | p[69]  | p[66]  | p[60]  | p[58]  | p[56]  | p[53]  | p[52]
              | p[51]  | p[49]  | p[48]  | p[47]  | p[44]  | p[41]  | p[36]  | p[32]
              | p[31]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[22]
              | p[21]  | p[20]  | p[16]  | p[14]  | p[13]  | p[12]  | p[11]  | p[10]
              | p[9]   | p[8]   | p[7]   | p[6]   | p[2]   | p[1]   | p[0];

assign pl[23] = p[217] | p[216] | p[212] | p[210] | p[206] | p[203] | p[200] | p[199]
              | p[198] | p[197] | p[196] | p[195] | p[194] | p[193] | p[192] | p[191]
              | p[189] | p[188] | p[186] | p[185] | p[181] | p[178] | p[176] | p[175]
              | p[171] | p[170] | p[169] | p[168] | p[167] | p[166] | p[165] | p[164]
              | p[161] | p[160] | p[159] | p[158] | p[157] | p[156] | p[155] | p[154]
              | p[153] | p[152] | p[151] | p[149] | p[148] | p[147] | p[146] | p[145]
              | p[143] | p[142] | p[141] | p[140] | p[139] | p[138] | p[137] | p[136]
              | p[134] | p[132] | p[131] | p[130] | p[128] | p[127] | p[124] | p[122]
              | p[120] | p[119] | p[118] | p[117] | p[116] | p[115] | p[114] | p[112]
              | p[111] | p[110] | p[107] | p[104] | p[103] | p[99]  | p[98]  | p[97]
              | p[96]  | p[94]  | p[93]  | p[91]  | p[89]  | p[88]  | p[87]  | p[86]
              | p[85]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[76]
              | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]
              | p[67]  | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]
              | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[52]
              | p[51]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]
              | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[36]  | p[35]  | p[34]
              | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]
              | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]
              | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[11]  | p[10]  | p[9]
              | p[8]   | p[7]   | p[6]   | p[5]   | p[4]   | p[3]   | p[2]   | p[1]
              | p[0];

assign pl[24] = p[255] | p[227] | p[219] | p[215] | p[206] | p[205] | p[203] | p[202]
              | p[201] | p[183] | p[182] | p[181] | p[177] | p[174] | p[173] | p[169]
              | p[167] | p[166] | p[163] | p[160] | p[159] | p[155] | p[151] | p[149]
              | p[148] | p[145] | p[140] | p[136] | p[134] | p[129] | p[128] | p[125]
              | p[123] | p[122] | p[116] | p[115] | p[114] | p[113] | p[111] | p[109]
              | p[105] | p[104] | p[102] | p[101] | p[96]  | p[95]  | p[88]  | p[87]
              | p[85]  | p[82]  | p[80]  | p[77]  | p[75]  | p[71]  | p[69]  | p[60]
              | p[56]  | p[52]  | p[51]  | p[49]  | p[44]  | p[41]  | p[37]  | p[36]
              | p[33]  | p[29]  | p[28]  | p[26]  | p[25]  | p[24]  | p[21]  | p[20]
              | p[16]  | p[14]  | p[13]  | p[12]  | p[11]  | p[10]  | p[9]   | p[8]
              | p[7]   | p[6]   | p[2]   | p[1]   | p[0];

assign pl[25] = p[277] | p[266] | p[263] | p[256] | p[255] | p[212] | p[199] | p[198]
              | p[197] | p[196] | p[194] | p[193] | p[192] | p[191] | p[189] | p[188]
              | p[186] | p[185] | p[178] | p[175] | p[174] | p[171] | p[170] | p[168]
              | p[167] | p[166] | p[165] | p[164] | p[162] | p[161] | p[158] | p[157]
              | p[156] | p[154] | p[153] | p[152] | p[151] | p[149] | p[148] | p[147]
              | p[144] | p[143] | p[140] | p[139] | p[138] | p[137] | p[136] | p[133]
              | p[132] | p[131] | p[130] | p[127] | p[124] | p[120] | p[119] | p[118]
              | p[116] | p[115] | p[114] | p[113] | p[112] | p[111] | p[110] | p[109]
              | p[107] | p[105] | p[104] | p[103] | p[102] | p[99]  | p[98]  | p[97]
              | p[94]  | p[93]  | p[91]  | p[89]  | p[88]  | p[87]  | p[86]  | p[85]
              | p[83]  | p[82]  | p[80]  | p[79]  | p[78]  | p[76]  | p[75]  | p[74]
              | p[73]  | p[72]  | p[70]  | p[69]  | p[68]  | p[67]  | p[66]  | p[64]
              | p[63]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
              | p[54]  | p[53]  | p[52]  | p[51]  | p[50]  | p[49]  | p[48]  | p[47]
              | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[39]  | p[38]  | p[35]
              | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[28]  | p[27]
              | p[26]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]
              | p[18]  | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[12]  | p[11]
              | p[10]  | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[4]   | p[3]
              | p[2]   | p[0];

assign pl[26] = p[253] | p[238] | p[237] | p[233] | p[228] | p[225] | p[222] | p[220]
              | p[210] | p[207] | p[205] | p[204] | p[202] | p[199] | p[196] | p[193]
              | p[189] | p[188] | p[186] | p[184] | p[181] | p[171] | p[168] | p[167]
              | p[165] | p[164] | p[157] | p[156] | p[154] | p[153] | p[152] | p[146]
              | p[145] | p[144] | p[142] | p[141] | p[139] | p[138] | p[137] | p[136]
              | p[135] | p[134] | p[132] | p[131] | p[130] | p[128] | p[126] | p[124]
              | p[121] | p[120] | p[119] | p[118] | p[117] | p[110] | p[109] | p[108]
              | p[107] | p[106] | p[103] | p[102] | p[100] | p[98]  | p[97]  | p[94]
              | p[93]  | p[92]  | p[91]  | p[90]  | p[87]  | p[84]  | p[83]  | p[81]
              | p[79]  | p[78]  | p[77]  | p[76]  | p[72]  | p[71]  | p[70]  | p[68]
              | p[65]  | p[64]  | p[63]  | p[62]  | p[59]  | p[57]  | p[54]  | p[45]
              | p[43]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]
              | p[35]  | p[34]  | p[31]  | p[30]  | p[23]  | p[21]  | p[19]  | p[18]
              | p[17]  | p[12]  | p[7]   | p[5]   | p[4]   | p[3]   | p[2]   | p[1];

assign pl[27] = p[257] | p[216] | p[212] | p[210] | p[206] | p[203] | p[199] | p[198]
              | p[197] | p[196] | p[195] | p[194] | p[193] | p[192] | p[191] | p[189]
              | p[188] | p[185] | p[183] | p[181] | p[178] | p[175] | p[172] | p[171]
              | p[170] | p[167] | p[165] | p[164] | p[161] | p[159] | p[158] | p[157]
              | p[156] | p[155] | p[154] | p[153] | p[152] | p[150] | p[149] | p[148]
              | p[147] | p[146] | p[145] | p[144] | p[143] | p[142] | p[141] | p[140]
              | p[139] | p[137] | p[136] | p[134] | p[132] | p[131] | p[130] | p[128]
              | p[127] | p[125] | p[120] | p[119] | p[118] | p[116] | p[115] | p[114]
              | p[112] | p[111] | p[110] | p[109] | p[107] | p[104] | p[103] | p[102]
              | p[101] | p[99]  | p[98]  | p[97]  | p[94]  | p[93]  | p[91]  | p[89]
              | p[88]  | p[87]  | p[86]  | p[85]  | p[83]  | p[82]  | p[80]  | p[79]
              | p[78]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[70]  | p[69]
              | p[68]  | p[67]  | p[66]  | p[64]  | p[61]  | p[60]  | p[59]  | p[58]
              | p[57]  | p[56]  | p[54]  | p[53]  | p[52]  | p[51]  | p[50]  | p[49]
              | p[48]  | p[47]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[39]
              | p[38]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]
              | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[22]
              | p[21]  | p[20]  | p[19]  | p[18]  | p[17]  | p[15]  | p[14]  | p[13]
              | p[12]  | p[11]  | p[10]  | p[9]   | p[8]   | p[7]   | p[6]   | p[5]
              | p[4]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[28] = p[247] | p[193] | p[130] | p[70];

assign pl[29] = p[216] | p[212] | p[203] | p[199] | p[198] | p[197] | p[194] | p[193]
              | p[192] | p[189] | p[188] | p[185] | p[183] | p[178] | p[171] | p[168]
              | p[167] | p[166] | p[165] | p[164] | p[162] | p[161] | p[158] | p[156]
              | p[154] | p[153] | p[152] | p[151] | p[148] | p[147] | p[143] | p[139]
              | p[138] | p[137] | p[135] | p[132] | p[130] | p[127] | p[126] | p[125]
              | p[121] | p[120] | p[119] | p[118] | p[115] | p[114] | p[112] | p[111]
              | p[110] | p[108] | p[107] | p[106] | p[103] | p[101] | p[99]  | p[98]
              | p[97]  | p[94]  | p[93]  | p[89]  | p[88]  | p[87]  | p[86]  | p[83]
              | p[82]  | p[80]  | p[78]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]
              | p[70]  | p[69]  | p[68]  | p[67]  | p[66]  | p[64]  | p[61]  | p[60]
              | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[52]
              | p[51]  | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[44]
              | p[43]  | p[42]  | p[41]  | p[39]  | p[38]  | p[35]  | p[34]  | p[33]
              | p[32]  | p[31]  | p[30]  | p[29]  | p[27]  | p[26]  | p[25]  | p[24]
              | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[17]  | p[16]
              | p[15]  | p[14]  | p[13]  | p[11]  | p[9]   | p[8]   | p[7]   | p[6]
              | p[5]   | p[4]   | p[3]   | p[2]   | p[0];

assign pl[30] = p[272] | p[243] | p[229] | p[223] | p[216] | p[215] | p[210] | p[209]
              | p[207] | p[206] | p[202] | p[199] | p[198] | p[196] | p[193] | p[192]
              | p[189] | p[188] | p[184] | p[183] | p[174] | p[170] | p[169] | p[161]
              | p[159] | p[157] | p[156] | p[155] | p[153] | p[151] | p[149] | p[147]
              | p[146] | p[145] | p[142] | p[140] | p[135] | p[131] | p[130] | p[129]
              | p[126] | p[125] | p[123] | p[121] | p[119] | p[116] | p[112] | p[110]
              | p[108] | p[106] | p[104] | p[103] | p[98]  | p[96]  | p[95]  | p[93]
              | p[91]  | p[90]  | p[85]  | p[84]  | p[79]  | p[78]  | p[74]  | p[73]
              | p[72]  | p[68]  | p[65]  | p[62]  | p[59]  | p[53]  | p[50]  | p[45]
              | p[42]  | p[41]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[32]
              | p[30]  | p[28]  | p[27]  | p[26]  | p[25]  | p[23]  | p[21]  | p[20]
              | p[19]  | p[18]  | p[16]  | p[15]  | p[10]  | p[9]   | p[8]   | p[6]
              | p[4]   | p[2]   | p[1]   | p[0];

assign pl[31] = p[229] | p[216] | p[215] | p[213] | p[207] | p[206] | p[202] | p[198]
              | p[196] | p[195] | p[189] | p[188] | p[183] | p[177] | p[174] | p[173]
              | p[169] | p[161] | p[160] | p[159] | p[157] | p[155] | p[153] | p[151]
              | p[147] | p[146] | p[145] | p[144] | p[142] | p[141] | p[131] | p[130]
              | p[129] | p[125] | p[124] | p[123] | p[122] | p[119] | p[117] | p[116]
              | p[113] | p[112] | p[110] | p[105] | p[103] | p[100] | p[98]  | p[97]
              | p[96]  | p[95]  | p[94]  | p[93]  | p[92]  | p[84]  | p[81]  | p[73]
              | p[72]  | p[68]  | p[65]  | p[63]  | p[62]  | p[59]  | p[57]  | p[53]
              | p[50]  | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]
              | p[32]  | p[30]  | p[27]  | p[26]  | p[25]  | p[21]  | p[20]  | p[18]
              | p[16]  | p[15]  | p[9]   | p[8]   | p[6]   | p[4]   | p[2]   | p[1]
              | p[0];

assign pl[32] = p[180] | p[178] | p[165] | p[159] | p[148] | p[146] | p[143] | p[128]
              | p[111] | p[99]  | p[96]  | p[86]  | p[81]  | p[73]  | p[71]  | p[67]
              | p[62]  | p[55]  | p[53]  | p[48]  | p[47]  | p[43]  | p[42]  | p[31]
              | p[27]  | p[7];

assign pl[33] = p[228] | p[225] | p[222] | p[214] | p[213] | p[211] | p[207] | p[206]
              | p[203] | p[202] | p[198] | p[197] | p[193] | p[189] | p[188] | p[183]
              | p[182] | p[181] | p[178] | p[174] | p[173] | p[171] | p[169] | p[168]
              | p[167] | p[166] | p[165] | p[164] | p[163] | p[161] | p[159] | p[158]
              | p[156] | p[155] | p[154] | p[153] | p[152] | p[148] | p[146] | p[145]
              | p[144] | p[143] | p[142] | p[141] | p[139] | p[138] | p[136] | p[135]
              | p[134] | p[133] | p[132] | p[130] | p[129] | p[128] | p[127] | p[126]
              | p[125] | p[124] | p[123] | p[121] | p[119] | p[118] | p[117] | p[115]
              | p[114] | p[112] | p[111] | p[110] | p[109] | p[108] | p[107] | p[106]
              | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]
              | p[96]  | p[95]  | p[94]  | p[93]  | p[92]  | p[91]  | p[88]  | p[87]
              | p[86]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]
              | p[77]  | p[76]  | p[75]  | p[73]  | p[72]  | p[71]  | p[70]  | p[68]
              | p[67]  | p[65]  | p[64]  | p[63]  | p[62]  | p[60]  | p[59]  | p[58]
              | p[57]  | p[56]  | p[54]  | p[52]  | p[51]  | p[49]  | p[48]  | p[47]
              | p[46]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[40]  | p[39]
              | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[30]
              | p[29]  | p[26]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]
              | p[19]  | p[18]  | p[17]  | p[15]  | p[13]  | p[12]  | p[9]   | p[8]
              | p[7]   | p[6]   | p[5]   | p[4]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[34] = p[254] | p[250] | p[242] | p[215] | p[197] | p[184] | p[182] | p[180]
              | p[174] | p[173] | p[171] | p[169] | p[166] | p[164] | p[163] | p[158]
              | p[154] | p[152] | p[140] | p[139] | p[137] | p[136] | p[135] | p[132]
              | p[120] | p[118] | p[114] | p[108] | p[107] | p[106] | p[99]  | p[97]
              | p[94]  | p[90]  | p[89]  | p[86]  | p[83]  | p[82]  | p[80]  | p[77]
              | p[73]  | p[61]  | p[60]  | p[58]  | p[57]  | p[53]  | p[50]  | p[48]
              | p[47]  | p[45]  | p[33]  | p[32]  | p[28]  | p[25]  | p[23]  | p[22]
              | p[21]  | p[19]  | p[17]  | p[16]  | p[10]  | p[9]   | p[4]   | p[3]
              | p[2];

assign pl[35] = p[219] | p[215] | p[184] | p[181] | p[167] | p[151] | p[148] | p[145]
              | p[140] | p[137] | p[136] | p[135] | p[134] | p[128] | p[116] | p[115]
              | p[109] | p[108] | p[106] | p[102] | p[97]  | p[94]  | p[90]  | p[87]
              | p[86]  | p[85]  | p[83]  | p[75]  | p[73]  | p[69]  | p[61]  | p[57]
              | p[56]  | p[53]  | p[51]  | p[49]  | p[41]  | p[36]  | p[33]  | p[29]
              | p[28]  | p[27]  | p[25]  | p[24]  | p[23]  | p[20]  | p[19]  | p[17]
              | p[16]  | p[14]  | p[12]  | p[11]  | p[10]  | p[9]   | p[6]   | p[5]
              | p[2]   | p[1];

assign pl[36] = p[241] | p[233] | p[220] | p[184] | p[181] | p[167] | p[163] | p[151]
              | p[149] | p[148] | p[145] | p[137] | p[136] | p[135] | p[134] | p[128]
              | p[115] | p[111] | p[109] | p[108] | p[106] | p[102] | p[97]  | p[94]
              | p[90]  | p[87]  | p[86]  | p[85]  | p[83]  | p[82]  | p[77]  | p[75]
              | p[71]  | p[61]  | p[60]  | p[57]  | p[56]  | p[52]  | p[51]  | p[49]
              | p[44]  | p[41]  | p[36]  | p[33]  | p[29]  | p[26]  | p[25]  | p[24]
              | p[23]  | p[20]  | p[19]  | p[17]  | p[12]  | p[9]   | p[7]   | p[5]
              | p[4]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[37] = p[224] | p[220] | p[182] | p[181] | p[177] | p[173] | p[167] | p[166]
              | p[162] | p[160] | p[148] | p[145] | p[144] | p[134] | p[128] | p[122]
              | p[115] | p[114] | p[113] | p[111] | p[109] | p[105] | p[102] | p[87]
              | p[85]  | p[82]  | p[77]  | p[75]  | p[71]  | p[69]  | p[60]  | p[56]
              | p[51]  | p[49]  | p[41]  | p[36]  | p[32]  | p[29]  | p[24]  | p[21]
              | p[20]  | p[14]  | p[12]  | p[10]  | p[9]   | p[6]   | p[1];

assign sp = ~pl;
endmodule

//______________________________________________________________________________
//
// 1801VM3 instruction predecoder matrix
//
// 18 inputs:
//    15:0  - instruction opcode [15:0]
//    16    - fpp presense
//    17    - instruction/exception decode
//
// 22 outputs:
//    5:0   - start microinstruction address
//    8:6   - interrupt/exception vector selector
//    17:15 - inverted instruction opcode [5:3]
//    21:18 - control PSW flags matrix
//
module vm3_pld
(
   input  ins,          // instruction/exception
   input  fpp,          // fpp present
   input  [15:0] ir,    // instruction opcode
   output [21:0] dc     // predecoder outputs
);
wire [109:0] p;
wire [21:0] pl;

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

assign p[61]  = cmp({ins, fpp, ir}, {1'b0, 1'bx, 16'bxxxxxxxxxxxxxxxx});   // Interrupt
assign p[34]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxxxx000xx0xxxxx1});
assign p[44]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxxxx000x0xxxxx1x});
assign p[56]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxx0xxx01xxxxxxxx});
assign p[59]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxxxx000xxx00xxxx});
assign p[71]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bx111xx0xxx000xxx});
assign p[97]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'b0000xx0xx1xxxxxx});

assign p[66]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxxxxxxx111xxxxxx});
assign p[0]   = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx1xxxxxxxxxxx});
assign p[1]   = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxxx1xxxxxxxxxx});
assign p[2]   = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxxxx1xxxxxxxxx});
assign p[6]   = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxxxxxxxx1xxxxx});
assign p[7]   = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxxxxxxxxx1xxxx});
assign p[10]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxxxxxxxxxx1xxx});
assign p[73]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxxxxxxxxxxx111});

assign p[4]   = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111000000xxxxxx});   // FPP
assign p[5]   = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111000x1xxxxxxx});
assign p[8]   = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b111100010xxxxxxx});
assign p[9]   = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b111101xxxxxxxxxx});
assign p[11]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111100xxxxxxxxx});
assign p[12]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111101xxxxxxxxx});
assign p[13]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111001xxxxxxxxx});
assign p[17]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b11111x00xxxxxxxx});
assign p[20]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b111111x0xxxxxxxx});
assign p[22]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b11110000x1xxxxxx});
assign p[29]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b11111101xxxxxxxx});
assign p[32]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b11111x11xxxxxxxx});
assign p[47]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b11110000x0xxxxxx});
assign p[50]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111000011xxxxxx});
assign p[72]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111000x00xxxxxx});
assign p[63]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111xxxxxx00011x});
assign p[78]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b11111110xxxxxxxx});
assign p[80]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b111100000000x1xx});
assign p[82]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b111100000001xxxx});
assign p[85]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b11111111xxxxxxxx});
assign p[86]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b11110000001xxxxx});
assign p[93]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b111100000000xx00});
assign p[95]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b111100000000x011});
assign p[98]  = cmp({ins, fpp, ir}, {1'b1, 1'b1, 16'b1111000x0x001000});

assign p[3]   = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx000xxxxxxxxx});
assign p[14]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0111100xxxxxxxxx});
assign p[15]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx000110111xxxxxx});
assign p[16]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx010xxxxxxxxxxxx});
assign p[18]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0xxxxxxxxxxxxxxx});
assign p[19]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx000110101xxxxxx});
assign p[21]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx0001100xxxxxxxx});
assign p[23]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxx01xxxxxxxxxxxx});
assign p[24]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx0x1xxxxxxxxxxxx});
assign p[25]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx0000xxxxxxxx});
assign p[26]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx110xxxxxxxxxxxx});
assign p[27]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx0001011xxxxxxxx});
assign p[28]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx000xxxx0xxxx});
assign p[30]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx00010101xxxxxxx});
assign p[31]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx000xxx0xxxxx});
assign p[33]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx000110110xxxxxx});
assign p[35]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx000xx0xxxxxx});
assign p[36]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b01110xxxxxxxxxxx});
assign p[37]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx000101x00xxxxxx});
assign p[38]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b00000000x1xxxxxx});
assign p[39]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx000100xxxxxxxxx});
assign p[40]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx100xxxxxxxxxxxx});
assign p[41]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000000000000x00});
assign p[42]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000000010000xxx});
assign p[43]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000000000000x01});
assign p[45]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx000x0xxxxxxx});
assign p[46]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b00000001xxxxxxxx});
assign p[48]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b1000110100xxxxxx});
assign p[49]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx0000x1xxxxxxxxx});
assign p[51]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxxxxxxxx000xxx});
assign p[52]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx01xxxxxxxxxxxxx});
assign p[53]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx0001010x1xxxxxx});
assign p[54]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx00001xxxxxxxxxx});
assign p[55]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0111010xxxxxxxxx});
assign p[57]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b10000xxxxxxxxxxx});
assign p[58]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b00000000101xxxxx});
assign p[60]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx0x00xxxxx1xx});
assign p[62]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx0000xxxx00xx1xx});
assign p[64]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000100xxxxxxxxx});
assign p[65]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx0001100x1xxxxxx});
assign p[67]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000000000000011});
assign p[68]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx000xx1xxxxx0});
assign p[69]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx0001011x0xxxxxx});
assign p[70]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000000000000x10});
assign p[74]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0111x11xxxxxxxxx});
assign p[75]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx000x1xxxxx0x});
assign p[76]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx00011001xxxxxxx});
assign p[77]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx01x10x111xxxxxx});
assign p[79]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b1110xxxxxxxxxxxx});
assign p[81]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx000101011xxxxxx});
assign p[83]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000110100xxxxxx});
assign p[84]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxx01xxxxxx00111});
assign p[87]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxx0110x111xxxxxx});
assign p[88]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b01110x1xxxxxxxxx});
assign p[89]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b01110xxxxxx0x111});
assign p[90]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx0001xxxxx0xx});
assign p[91]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxx01xxxxx10x111});
assign p[92]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxx01xxxxxxx00111});
assign p[94]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx000101111xxxxxx});
assign p[96]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx1x010x111xxxxxx});
assign p[99]  = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0xxxx00xxxx00111});
assign p[100] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b01110xx11xxxxxxx});
assign p[101] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxxxx000xxx11xxxx});
assign p[102] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bxx01xxxxxx10x111});
assign p[103] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx01xxxxxxxx00111});
assign p[104] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000x00001xxxxxx});
assign p[105] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx1x0xxxxxxx00111});
assign p[106] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx1x0xxxxxx10x111});
assign p[107] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'bx01xxxxxxx10x111});
assign p[108] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0xxxx00xxx10x111});
assign p[109] = cmp({ins, fpp, ir}, {1'b1, 1'bx, 16'b0000x0000x000100});

//
// Exception processing mode reductions (ins = 0)
//
// assign p[34]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxxxx000xx0xxxxx1});
// assign p[44]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxxxx000x0xxxxx1x});
// assign p[56]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxx0xxx01xxxxxxxx});
// assign p[59]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxxxx000xxx00xxxx});
// assign p[61]  = cmp({ins, fpp, ir}, {1'b0, 1'bx, 16'bxxxxxxxxxxxxxxxx});
// assign p[66]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bxxxxxxx111xxxxxx});
// assign p[71]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'bx111xx0xxx000xxx});
// assign p[97]  = cmp({ins, fpp, ir}, {1'bx, 1'bx, 16'b0000xx0xx1xxxxxx});
//
// assign pl[2]  = p[66];           - initial address (ignored, no ma_ldr)
// assign pl[4]  = p[97] | p[71];   - initial address (ignored, no ma_ldr)
// assign pl[5]  = p[44] | p[34];   - initial address (ignored, no ma_ldr)
// assign pl[7]  = p[61];
// assign pl[14] = p[61];
// assign pl[21] = p[61] | p[56];
//

assign pl[0]  = p[36]  | p[13]  | p[9]   | p[3]   | p[0];
assign pl[1]  = p[53]  | p[48]  | p[39]  | p[37]  | p[36]  | p[33]  | p[32]  | p[30]
              | p[29]  | p[27]  | p[21]  | p[20]  | p[19]  | p[17]  | p[15]  | p[14]
              | p[13]  | p[12]  | p[11]  | p[9]   | p[3];
assign pl[2]  = p[66];
assign pl[3]  = p[51]  | p[4];
assign pl[4]  = p[97]  | p[71]  | p[48]  | p[45]  | p[39]  | p[36]  | p[35]  | p[31]
              | p[29]  | p[28]  | p[25]  | p[22]  | p[21]  | p[19]  | p[17]  | p[11]
              | p[9]   | p[8]   | p[5]   | p[4]   | p[2];
assign pl[5]  = p[101] | p[90]  | p[75]  | p[68]  | p[60]  | p[59]  | p[53]  | p[44]
              | p[39]  | p[38]  | p[37]  | p[36]  | p[34]  | p[30]  | p[27]  | p[22]
              | p[14]  | p[13]  | p[12]  | p[11]  | p[8]   | p[5]   | p[4]   | p[1];
assign pl[6]  = p[109] | p[104] | p[67]  | p[39]  | p[33]  | p[32]  | p[29]  | p[22]
              | p[20]  | p[19]  | p[17]  | p[15]  | p[13]  | p[12]  | p[11]  | p[9]
              | p[8]   | p[5]   | p[4];
assign pl[7]  = p[83]  | p[74]  | p[70]  | p[67]  | p[61]  | p[58]  | p[57]  | p[54]
              | p[53]  | p[49]  | p[48]  | p[46]  | p[43]  | p[42]  | p[41]  | p[39]
              | p[38]  | p[37]  | p[36]  | p[33]  | p[32]  | p[30]  | p[29]  | p[27]
              | p[22]  | p[21]  | p[20]  | p[19]  | p[17]  | p[13]  | p[12]  | p[11]
              | p[9]   | p[8]   | p[5]   | p[4];
assign pl[8]  = p[98]  | p[95]  | p[86]  | p[82]  | p[80]  | p[64]  | p[53]  | p[48]
              | p[40]  | p[38]  | p[37]  | p[36]  | p[33]  | p[32]  | p[30]  | p[29]
              | p[27]  | p[26]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]
              | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[12]  | p[11]  | p[9]
              | p[8]   | p[5];
assign pl[9]  = p[85]  | p[83]  | p[81]  | p[76]  | p[63]  | p[58]  | p[50]  | p[47]
              | p[42]  | p[41]  | p[37]  | p[36]  | p[24]  | p[23]  | p[17]  | p[16]
              | p[15]  | p[13]  | p[11]  | p[9]   | p[8]   | p[4];
assign pl[10] = p[94]  | p[83]  | p[74]  | p[57]  | p[54]  | p[52]  | p[49]  | p[48]
              | p[46]  | p[42]  | p[36]  | p[32]  | p[29]  | p[22]  | p[20]  | p[17]
              | p[16]  | p[13]  | p[12]  | p[11]  | p[9]   | p[8]   | p[5]   | p[4];
assign pl[11] = p[73];
assign pl[12] = p[108] | p[107] | p[106] | p[105] | p[103] | p[102] | p[100] | p[99]
              | p[96]  | p[92]  | p[91]  | p[89]  | p[87]  | p[84]  | p[77];
assign pl[13] = p[33]  | p[26]  | p[19]  | p[18]  | p[14];
assign pl[14] = p[72]  | p[70]  | p[64]  | p[63]  | p[61]  | p[58]  | p[53]  | p[47]
              | p[43]  | p[37]  | p[33]  | p[30]  | p[27]  | p[26]  | p[24]  | p[17]
              | p[16]  | p[15]  | p[14]  | p[12]  | p[4];
assign pl[15] = p[10];  // opcode [3]
assign pl[16] = p[7];   // opcode [4]
assign pl[17] = p[6];   // opcode [5]
assign pl[18] = p[55]  | p[40]  | p[33]  | p[27]  | p[26]  | p[24]  | p[23]  | p[21]
              | p[19]  | p[16]  | p[15]  | p[14];
assign pl[19] = p[36]  | p[21];
assign pl[20] = p[95]  | p[93]  | p[88]  | p[86]  | p[82]  | p[80]  | p[79]  | p[69]
              | p[67]  | p[65]  | p[64]  | p[63]  | p[62]  | p[57]  | p[54]  | p[50]
              | p[49]  | p[46]  | p[42]  | p[41]  | p[38]  | p[32]  | p[30]  | p[20]
              | p[16];
assign pl[21] = p[78]  | p[74]  | p[65]  | p[63]  | p[61]  | p[58]  | p[57]  | p[56]
              | p[55]  | p[54]  | p[53]  | p[49]  | p[48]  | p[47]  | p[46]  | p[43]
              | p[42]  | p[41]  | p[40]  | p[33]  | p[30]  | p[29]  | p[24]  | p[23]
              | p[22]  | p[19]  | p[15]  | p[14]  | p[12]  | p[4];

assign dc = ~pl;
endmodule

//______________________________________________________________________________
//
// 1801VM3 branch processing matrix
//
// 8 inputs:
//    br[0]    - C - psw[0]
//    br[1]    - V - psw[1]
//    br[2]    - Z - psw[2]
//    br[3]    - N - psw[3]
//    br[4]    - instruction register [8]
//    br[5]    - instruction register [9]
//    br[6]    - instruction register [10]
//    br[7]    - instruction register [15]
//
module vm3_plb
(
   input  [7:0] br,
   output sp
);
wire [16:0] p;

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

assign p[7]  = cmp(br, 8'b000xxxxx);   //      br        0004ss
assign p[0]  = cmp(br, 8'b00x0x0xx);   // z    bne       0010ss
assign p[8]  = cmp(br, 8'bx011x1xx);   // Z    beq/ble   0014ss
assign p[9]  = cmp(br, 8'b0x001x1x);   // nv   bge       0020ss   n xor v == 0
assign p[13] = cmp(br, 8'b01000x0x);   // NV   bge       0020ss   n xor v == 0
assign p[5]  = cmp(br, 8'b01x10x1x);   // nV   blt/ble   0024ss   n xor v == 1
assign p[6]  = cmp(br, 8'b01x11x0x);   // Nv   blt/ble   0024ss   n xor v == 1
assign p[10] = cmp(br, 8'b0xx0000x);   // nvz  bgt/bge   0030ss   (z == 0) and (n xor v) == 0
assign p[11] = cmp(br, 8'b0x10101x);   // NVz  bgt       0030ss   (z == 0) and (n xor v) == 0
assign p[3]  = cmp(br, 8'bx0000xxx);   // n    bpl       1000ss
assign p[15] = cmp(br, 8'b10011xxx);   // N    bmi       1004ss
assign p[1]  = cmp(br, 8'bx010x0x0);   // zc   bhi       1010ss   (z == 0) & (c == 0)
assign p[16] = cmp(br, 8'b0x11x1xx);   // Z    beq/blos  0014ss
assign p[12] = cmp(br, 8'b1100xx0x);   // v    bvc       1020ss
assign p[2]  = cmp(br, 8'b1101xx1x);   // V    bvs       1024ss
assign p[14] = cmp(br, 8'b1110xxx0);   // c    bcc       1030ss
assign p[4]  = cmp(br, 8'b1x11xxx1);   // C    bcs/blos  1034ss

assign sp = |p[16:0];
endmodule

//______________________________________________________________________________
//
// 1801VM3 interrupt and exceptions priority matrix
//
// 12 inputs:
//    rq[0]    - double Q-bus error
//    rq[1]    - MMU exception
//    rq[2]    - Q-bus timeout error
//    rq[3]    - FPP trap
//    rq[4]    - T-bit trap request (on psw[4])
//    rq[5]    - yellow stack exception
//    rq[6]    - nACLO raising edge detector (nACLO restored)
//    rq[7]    - nACLO falling edge detector (nACLO failed)
//    rq[8]    - interrupt request HALT
//    rq[9]    - timer interrupt request nEVNT (rising edge)
//    rq[10]   - IRQ[3:0] vectored interrupt
//    rq[11]   - halt mode interrupts masking
//
// 4 outputs (lsb - active interrupt request):
//   0000 - xxx - no interrupt/exception
// m 0001 - 100 - timer interrupt request nEVNT (rising edge)
//   0011 - 004 - Q-bus timeout/odd address error
// m 0011 - 004 - yellow stack exception
//   0101 - 250 - MMU exception
//   0111 - 244 - FPP trap
// m 1001 - 014 - T-bit trap request (on psw[4])
// m 1001 - 024 - nACLO raising edge detector (nACLO restored)
// m 1011 - vvv - IRQ[3:0] vectored interrupt
//   1101 - double Q-bus error
// m 1101 - hlt - interrupt request HALT
// m 1111 - 024 - nACLO falling edge detector (nACLO failed)
// m      - masked in halt mode
//
module vm3_pli
(
   input  [11:0] rq,
   output [10:0] ro,
   output [3:0] ri
);
wire [10:0] p;

function cmp
(
   input [11:0] ai,
   input [11:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction
                                             // 0000 - no interrupt
assign p[0]  = cmp(rq, 12'bxxxxxxxxxxx1);    // 1101 - Q-bus timeout/odd address error
assign p[1]  = cmp(rq, 12'bxxxxxxxx0010);    // 0101 - MMU exception
assign p[2]  = cmp(rq, 12'bxxxxxxxx0100);    // 0011 - double Q-bus error
assign p[3]  = cmp(rq, 12'bxxxxxxxx1000);    // 0111 - FPP trap
assign p[4]  = cmp(rq, 12'b0xxxxxx10000);    // 1001 - T-bit trap request (on psw[4])
assign p[5]  = cmp(rq, 12'b0xxxxx100000);    // 0011 - yellow stack exception
assign p[6]  = cmp(rq, 12'b0xxx01000000);    // 1001 - nACLO raising edge detector (nACLO restored)
assign p[7]  = cmp(rq, 12'b0xxx10000000);    // 1111 - nACLO falling edge detector (nACLO failed)
assign p[8]  = cmp(rq, 12'b0xx100000000);    // 1101 - interrupt request HALT
assign p[9]  = cmp(rq, 12'b0x1000000000);    // 0001 - timer interrupt request nEVNT (rising edge)
assign p[10] = cmp(rq, 12'b010000000000);    // 1011 - IRQ[3:0] vectored interrupt

assign ri[0] = |p[10:0];
assign ri[1] = p[2] | p[3] | p[5] | p[7] | p[10];
assign ri[2] = p[0] | p[1] | p[3] | p[7] | p[8];
assign ri[3] = p[0] | p[4] | p[6] | p[7] | p[8] | p[10];

assign ro[10:0] = p[10:0];
endmodule

//______________________________________________________________________________
//
// 1801VM3 processor status word matrix
//
// 14 inputs:
//    9:0   - flag multiplexer
//    13:10 - opcode decoder bits 21:18
//
// 5 outputs:
//    0 - CF
//    1 - VF
//    2 - ZF
//    3 - NF
//    4 - XF - sticky (extended) arithmetic overflow
//
module vm3_plf
(
   input  [13:0] cf,
   output [4:0] fl
);
wire [23:0] p;

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

assign p[0]  = cmp(cf, 14'bxxxxxxxxxxx0xx);  // N
assign p[1]  = cmp(cf, 14'bxxxxx0xxxxxxxx);  // Z
assign p[2]  = cmp(cf, 14'bx10111xxx1xxxx);  //
assign p[3]  = cmp(cf, 14'b1101xxxxx0xxxx);  //
assign p[4]  = cmp(cf, 14'b1x10xxxxxx0xxx);  // V
assign p[5]  = cmp(cf, 14'b1x00xxxxx0x1xx);  //
assign p[6]  = cmp(cf, 14'b00xx1xxxxxxxxx);  //
assign p[7]  = cmp(cf, 14'b001xxxxxxx0xxx);  //
assign p[8]  = cmp(cf, 14'b1x00xxxxx1x0xx);  //
assign p[9]  = cmp(cf, 14'b00x00xx1xxx0xx);  //
assign p[10] = cmp(cf, 14'b00x00xx0xxx1xx);  //
assign p[11] = cmp(cf, 14'b1111xxxxxxxxxx);  // C
assign p[12] = cmp(cf, 14'b0x01xxxxxxxxx1);  //
assign p[13] = cmp(cf, 14'b1xx1xxxxx0xx0x);  //
assign p[14] = cmp(cf, 14'b001xxx0xxxxxxx);  //
assign p[15] = cmp(cf, 14'b0x10xx0xxxxxxx);  //
assign p[16] = cmp(cf, 14'b10x1xxxxxxxxxx);  //
assign p[17] = cmp(cf, 14'b1110xxxx0xxxxx);  //
assign p[18] = cmp(cf, 14'b10x0xxxx1xxxxx);  //
assign p[19] = cmp(cf, 14'bx10xx1xxx1xxxx);  //
assign p[20] = cmp(cf, 14'bx100xxxxx1xxxx);  //
assign p[21] = cmp(cf, 14'b00x0xxx1xxxxxx);  //
assign p[22] = cmp(cf, 14'bxx0x1xxxxxxxxx);  // aux
assign p[23] = cmp(cf, 14'bx1xxx0xxxxxxxx);  //

assign fl[0] = ~|p[21:11];    // C
assign fl[1] = |p[10:4];      // V
assign fl[2] = ~|p[3:1];      // Z
assign fl[3] = p[0];          // N
assign fl[4] = p[3] | p[9] | p[10] | p[22] | p[23];
endmodule

//______________________________________________________________________________
//
// 1801VM3 ALU control matrix
//
// 11 inputs:
//    6:0   - control inputs
//    10:7  - microcode matrix outputs [33,26,21,20]
//
// 18 outputs:
//    0  - ALU AND control
//    1  - ALU OR control
//    3  - ALU OR control
//    4  - ALU AND control
//    6  - no ALU X-argument inversion
//    7  - ALU adder lsb carry
//    9  - no ALU adder - disable carries
//    12 - select psw[0] for shift in
//    13 - ALU shift left
//    16 - ALU no shift
//    17 - ALU shift right
//
module vm3_plc
(
   input  [10:0] ic,
   output [17:0] oc
);
wire [26:0] p;
wire [17:0] pl;

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

assign p[0]  = cmp(ic, 11'b10101xxxxxx);
assign p[1]  = cmp(ic, 11'b101xxxxx110);
assign p[2]  = cmp(ic, 11'b1010xxxxxx0);
assign p[3]  = cmp(ic, 11'b100xxxxxxxx);
assign p[4]  = cmp(ic, 11'b0xx1xxxxxxx);
assign p[5]  = cmp(ic, 11'b1011xx1xxx1);
assign p[6]  = cmp(ic, 11'b00x0xxxxxxx);
assign p[7]  = cmp(ic, 11'b0001x1xxxxx);
assign p[8]  = cmp(ic, 11'b101xx1x1x1x);
assign p[9]  = cmp(ic, 11'b010xxxxxxxx);
assign p[10] = cmp(ic, 11'b0011xxxxxxx);
assign p[11] = cmp(ic, 11'b1011xxx0x0x);
assign p[12] = cmp(ic, 11'b0001xx0xxxx);
assign p[13] = cmp(ic, 11'b000101xxxxx);
assign p[14] = cmp(ic, 11'b0x0xxxxxxxx);
assign p[15] = cmp(ic, 11'b1010xx0xxx1);
assign p[16] = cmp(ic, 11'bx111xxxxxxx);
assign p[17] = cmp(ic, 11'bx110xxxxxxx);
assign p[18] = cmp(ic, 11'b101xx0xxx1x);
assign p[19] = cmp(ic, 11'b1101xxxxxxx);
assign p[20] = cmp(ic, 11'b11x0xxxxxxx);
assign p[21] = cmp(ic, 11'b1011xxxxx00);
assign p[22] = cmp(ic, 11'b101xx1x0x1x);
assign p[23] = cmp(ic, 11'b10100x1xxx1);
assign p[24] = cmp(ic, 11'b1011xxx1x0x);
assign p[25] = cmp(ic, 11'b0001001xxxx);
assign p[26] = cmp(ic, 11'bxx00xxxxxxx);

assign pl[0]  = p[22] | p[21] | p[20] | p[18] | p[17] | p[15] | p[14] | p[11]
              | p[10] | p[3]  | p[2]  | p[1]  | p[0];
assign pl[1]  = p[22] | p[21] | p[19] | p[18] | p[17] | p[15] | p[14] | p[11]
              | p[4]  | p[3]  | p[2]  | p[1]  | p[0];
assign pl[2]  = p[21] | p[2];
assign pl[3]  = p[24] | p[23] | p[21] | p[18] | p[14] | p[8]  | p[6]  | p[3]
              | p[1]  | p[0];
assign pl[4]  = p[24] | p[23] | p[21] | p[18] | p[16] | p[14] | p[8]  | p[6]
              | p[3]  | p[1]  | p[0];
assign pl[5]  = p[24] | p[21] | p[15] | p[13] | p[12] | p[11] | p[5]  | p[2];
assign pl[6]  = p[21] | p[18] | p[14] | p[4]  | p[3]  | p[1]  | p[0];
assign pl[7]  = p[24] | p[23] | p[8]  | p[6]  | p[4];
assign pl[8]  = p[24] | p[21] | p[15] | p[11] | p[2]  | p[0];
assign pl[9]  = p[21] | p[20] | p[19] | p[18] | p[16] | p[14] | p[3]  | p[1]  | p[0];
assign pl[10] = p[23] | p[15] | p[7]  | p[2]  | p[0];
assign pl[11] = p[18] | p[5];
assign pl[12] = p[26];
assign pl[13] = p[25] | p[23] | p[22] | p[21] | p[20] | p[19] | p[18] | p[17]
              | p[16] | p[15] | p[10] | p[9]  | p[8]  | p[7]  | p[6]  | p[5]
              | p[2]  | p[1]  | p[0];
assign pl[14] = p[25] | p[23] | p[22] | p[21] | p[20] | p[19] | p[18] | p[17]
              | p[16] | p[15] | p[10] | p[9]  | p[8]  | p[7]  | p[6]  | p[3]
              | p[2]  | p[1]  | p[0];
assign pl[15] = p[24] | p[22] | p[21] | p[18] | p[11] | p[8]  | p[5]  | p[1];
assign pl[16] = p[25] | p[22] | p[21] | p[20] | p[19] | p[18] | p[17] | p[16]
              | p[10] | p[8]  | p[6]  | p[5]  | p[1];
assign pl[17] = p[23] | p[15] | p[9]  | p[7]  | p[2]  | p[0];

assign oc = ~pl;
endmodule

//______________________________________________________________________________
//
// 1801VM3 interrupt vector selection matrix
//
// 12 inputs
//    0 - WO
//    3:1 - inverted opcode decoder [8:6]
//    5:4 - inverted opcode decoder [21:20]
//    9:6 - interrupt register [3:0]
//       0000 - no interrupt
//       0001 - timer interrupt request nEVNT (rising edge)
//       0011 - Q-bus timeout/odd address error
//       0011 - yellow stack exception
//       0101 - MMU exception
//       0111 - FPP trap
//       1001 - T-bit trap request (on psw[4])
//       1001 - nACLO raising edge detector (nACLO restored)
//       1011 - IRQ[3:0] vectored interrupt
//       1101 - double Q-bus error
//       1101 - interrupt request HALT
//       1111 - nACLO falling edge detector (nACLO failed)
//
//    10  - masked T-bit
//    11  - psw[15]
//
// 5 outputs
//    3:0 - vector select
//       0000 - 000014  BPT, T-bit
//       0001 - 000020  IOT
//       0010 - 173000  start address
//       0011 - virq    device vector
//       0100 - 000004  bus error, yellow stack
//       0101 - 000244  FPP
//       0110 - 000010  illegal opcode
//       0111 - 000024  power fail
//       1000 - 000030  EMT
//       1001 - 000034  TRAP
//       1010 - 000001  unused
//       1011 - 100000  halt SP value
//       1100 - 000100  timer
//       1101 - 000250  MMU
//       1110 - 000024  power on
//       1111 - 000000  unused
//    4   - reset interrupt/exception request
//
// T req irq   dc dcd   vector
//
// 1  0  xxx   xx xxx   0000  - BPT, T-bit
//
// 1  1  000   xx xxx   1100  - timer
//       001   xx xxx   0100  - bus error, yellow stack
//       010   xx xxx   1101  - MMU exception
//       011   xx xxx   0101  - FPP trap
//       100   xx xxx   0000  - BPT, T-bit
//       101   xx xxx   0000  - BPT, T-bit
//       110   xx xxx   1011  - halt SP
//       111   xx xxx   0111  - power fail
//
// 0  0  xxx   xx 000   0110  - illegal opcode
//       xxx   ** 001   *00*  - not used (no value from decoder)
//       xxx   xx 010   1011  - halt SP value (kernel mode)
//       xxx   xx 010   0110  - illegal opcode (user mode)
//       xxx   ** 011   *00*  - BPT/IOT/EMT/TRAP by opcode
//       xxx   xx 100   0100  - bus error, yellow stack
//       xxx   xx 101   0100  - bus error, yellow stack
//       xxx   xx 110   0101  - FPP trap
//       xxx   xx 111   0101  - FPP trap
//
// 0  1  000   xx xxx   1100  - timer
//       001   xx xxx   0100  - bus error, yellow stack
//       010   xx xxx   1101  - MMU exception
//       011   xx xxx   0101  - FPP trap
//       100   xx xxx   **10  - start address/power on
//       101   xx xxx   0011  - vector interrupt
//       110   xx xxx   1011  - halt SP
//       111   xx xxx   0111  - power fail
//
module vm3_plv
(
   input  [11:0] ib,
   output [4:0] ov
);
wire [17:0] p;
wire [4:0] pl;

function cmp
(
   input [11:0] ai,
   input [11:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[13] = cmp(ib, 12'b0xxxx0xxx10x); // kernel mode
assign p[7]  = cmp(ib, 12'b10xxx0xxx10x); // user mode
assign p[0]  = cmp(ib, 12'bx0xxx00x0x1x);
assign p[1]  = cmp(ib, 12'bx0xxx0x10x1x);
assign p[6]  = cmp(ib, 12'bx0xxx0xx0x1x);
assign p[8]  = cmp(ib, 12'bx0xxx0xx1xxx);
assign p[2]  = cmp(ib, 12'bx0xxx0xxx0xx);
assign p[16] = cmp(ib, 12'bx1xxx0xxxxxx);
assign p[15] = cmp(ib, 12'bxx0xx1xxxxxx);
assign p[10] = cmp(ib, 12'bxxxx11xxxxxx);
assign p[3]  = cmp(ib, 12'bxx00x1xxxxxx);
assign p[5]  = cmp(ib, 12'bx01001xxxxxx);
assign p[11] = cmp(ib, 12'bx0100xxxxxx1); // WO - 173000
assign p[14] = cmp(ib, 12'bx01x11xxxxxx);
assign p[4]  = cmp(ib, 12'bxx101xxxxxxx);
assign p[9]  = cmp(ib, 12'bxx110xxxxxxx);
assign p[17] = cmp(ib, 12'bx110xxxxxxxx);
assign p[12] = cmp(ib, 12'bx111xxxxxxxx);

assign pl[0] = p[17] | p[16] | p[8]  | p[7]  | p[5]  | p[3] | p[2] | p[0];
assign pl[1] = p[17] | p[16] | p[15] | p[8]  | p[6];
assign pl[2] = p[17] | p[16] | p[13] | p[11] | p[9]  | p[6] | p[4];
assign pl[3] = p[17] | p[16] | p[14] | p[11] | p[10] | p[8] | p[7] | p[2] | p[1];
assign pl[4] = p[15] | p[14] | p[12] | p[9]  | p[5];

assign ov[3:0] = ~pl[3:0];
assign ov[4] = pl[4];
endmodule
