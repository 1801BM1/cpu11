//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
//______________________________________________________________________________
//
module dc_pla_0
(
   input [6:0]    a_in,
   input [15:0]   d_in,
   output [8:0]   ma,
   output [15:0]  mc
);

function cmp
(
   input [23:0] ai,
   input [23:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

wire [137:0] p;
wire [24:0] pl;

assign p[0]   = cmp({d_in, a_in}, {16'bx0001010xxx1xxxx, 7'bxx11x00});
assign p[1]   = cmp({d_in, a_in}, {16'bx0001101xxx1xxxx, 7'bxx11x00});
assign p[2]   = cmp({d_in, a_in}, {16'bx0101111xx10x000, 7'bxx11x00});
assign p[3]   = cmp({d_in, a_in}, {16'bx1001000xx000xxx, 7'bxx11x00});
assign p[4]   = cmp({d_in, a_in}, {16'bx0010011xx000xxx, 7'bxx11x00});
assign p[5]   = cmp({d_in, a_in}, {16'bx1x00111xxx00xxx, 7'bxx11x00});
assign p[6]   = cmp({d_in, a_in}, {16'bx0100100xx000xxx, 7'bxx11x00});
assign p[7]   = cmp({d_in, a_in}, {16'bx1x10010xx000xxx, 7'bxx11x00});
assign p[8]   = cmp({d_in, a_in}, {16'bx1x10000xx000xxx, 7'bxx11x00});
assign p[9]   = cmp({d_in, a_in}, {16'bx1x10011xxx01xxx, 7'bxx11x00});
assign p[10]  = cmp({d_in, a_in}, {16'bx0110xxxxxx1xxxx, 7'bxx11x00});
assign p[11]  = cmp({d_in, a_in}, {16'bx0110xxxxxx0xxxx, 7'bxx11x00});
assign p[12]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx11x00});
assign p[13]  = cmp({d_in, a_in}, {16'b0111011xxxxxxxxx, 7'bxx01011});
assign p[14]  = cmp({d_in, a_in}, {16'b0111010xxxxxxxxx, 7'bxx01011});
assign p[15]  = cmp({d_in, a_in}, {16'b0111001xxxxxxxxx, 7'bxx01011});
assign p[16]  = cmp({d_in, a_in}, {16'b0111000xxxxxxxxx, 7'bxx01011});
assign p[17]  = cmp({d_in, a_in}, {16'b01110xxxxx000xxx, 7'bxx10110});
assign p[18]  = cmp({d_in, a_in}, {16'b01110xxxxx000xxx, 7'bxx01001});
assign p[19]  = cmp({d_in, a_in}, {16'b10001001xxxxxxxx, 7'bxx01111});
assign p[20]  = cmp({d_in, a_in}, {16'b10001000xxxxxxxx, 7'bxx01111});
assign p[21]  = cmp({d_in, a_in}, {16'b00000000101xxxxx, 7'bxx01111});
assign p[22]  = cmp({d_in, a_in}, {16'b0000110100xxxxxx, 7'bxx01111});
assign p[23]  = cmp({d_in, a_in}, {16'b0111111xxxxxxxxx, 7'bxx01111});
assign p[24]  = cmp({d_in, a_in}, {16'b10000xxxxxxxxxxx, 7'bxx01111});
assign p[25]  = cmp({d_in, a_in}, {16'b000001xxxxxxxxxx, 7'bxx01111});
assign p[26]  = cmp({d_in, a_in}, {16'b0000001xxxxxxxxx, 7'bxx01111});
assign p[27]  = cmp({d_in, a_in}, {16'b00000001xxxxxxxx, 7'bxx01111});
assign p[28]  = cmp({d_in, a_in}, {16'b0000000010000xxx, 7'bxx01111});
assign p[29]  = cmp({d_in, a_in}, {16'b0000100xxxxxxxxx, 7'bxx00010});
assign p[30]  = cmp({d_in, a_in}, {16'b0000000001xxxxxx, 7'bxx00010});
assign p[31]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx111xxx, 7'bxx00111});
assign p[32]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx110xxx, 7'bxx00111});
assign p[33]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx101xxx, 7'bxx00111});
assign p[34]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx100xxx, 7'bxx00111});
assign p[35]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx011xxx, 7'bxx00111});
assign p[36]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx010xxx, 7'bxx00111});
assign p[37]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx001xxx, 7'bxx00111});
assign p[38]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx000xxx, 7'bxx00111});
assign p[39]  = cmp({d_in, a_in}, {16'bx000110110xxxxxx, 7'bxx010xx});
assign p[40]  = cmp({d_in, a_in}, {16'bx000110110xxxxxx, 7'bxx01111});
assign p[41]  = cmp({d_in, a_in}, {16'bx000110101xxxxxx, 7'bxx01011});
assign p[42]  = cmp({d_in, a_in}, {16'bx000110101000xxx, 7'bxx10110});
assign p[43]  = cmp({d_in, a_in}, {16'bx000110101000xxx, 7'bxx01001});
assign p[44]  = cmp({d_in, a_in}, {16'b1000110100xxxxxx, 7'bxx01011});
assign p[45]  = cmp({d_in, a_in}, {16'b1000110100000xxx, 7'bxx10110});
assign p[46]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx10101});
assign p[47]  = cmp({d_in, a_in}, {16'b1000110100000xxx, 7'bxx01001});
assign p[48]  = cmp({d_in, a_in}, {16'b1000110111xxxxxx, 7'bxx010x1});
assign p[49]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx01001});
assign p[50]  = cmp({d_in, a_in}, {16'b0111100xxxxxxxxx, 7'bxx010xx});
assign p[51]  = cmp({d_in, a_in}, {16'b0000110111xxxxxx, 7'bxx010xx});
assign p[52]  = cmp({d_in, a_in}, {16'bx000110011xxxxxx, 7'bxx010xx});
assign p[53]  = cmp({d_in, a_in}, {16'bx000110010xxxxxx, 7'bxx010xx});
assign p[54]  = cmp({d_in, a_in}, {16'bx000110001xxxxxx, 7'bxx010xx});
assign p[55]  = cmp({d_in, a_in}, {16'bx000110000xxxxxx, 7'bxx010xx});
assign p[56]  = cmp({d_in, a_in}, {16'bx000101111xxxxxx, 7'bxx010xx});
assign p[57]  = cmp({d_in, a_in}, {16'bx000101110xxxxxx, 7'bxx010xx});
assign p[58]  = cmp({d_in, a_in}, {16'bx000101101xxxxxx, 7'bxx010xx});
assign p[59]  = cmp({d_in, a_in}, {16'bx000101100xxxxxx, 7'bxx010xx});
assign p[60]  = cmp({d_in, a_in}, {16'bx000101011xxxxxx, 7'bxx010xx});
assign p[61]  = cmp({d_in, a_in}, {16'bx000101010xxxxxx, 7'bxx010xx});
assign p[62]  = cmp({d_in, a_in}, {16'bx000101001xxxxxx, 7'bxx010xx});
assign p[63]  = cmp({d_in, a_in}, {16'bx000101000xxxxxx, 7'bxx010xx});
assign p[64]  = cmp({d_in, a_in}, {16'b0000000011xxxxxx, 7'bxx010xx});
assign p[65]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx000xxx, 7'bxx01000});
assign p[66]  = cmp({d_in, a_in}, {16'bxxxx000xxxxxxxxx, 7'bxx010x0});
assign p[67]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bxx010xx});
assign p[68]  = cmp({d_in, a_in}, {16'b1110xxxxxxxxxxxx, 7'bxx010xx});
assign p[69]  = cmp({d_in, a_in}, {16'b0110xxxxxxxxxxxx, 7'bxx010xx});
assign p[70]  = cmp({d_in, a_in}, {16'bx101xxxxxxxxxxxx, 7'bxx010xx});
assign p[71]  = cmp({d_in, a_in}, {16'bx100xxxxxxxxxxxx, 7'bxx010xx});
assign p[72]  = cmp({d_in, a_in}, {16'bx011xxxxxxxxxxxx, 7'bxx010xx});
assign p[73]  = cmp({d_in, a_in}, {16'bx010xxxxxxxxxxxx, 7'bxx010xx});
assign p[74]  = cmp({d_in, a_in}, {16'bx001xxxxxxxxxxxx, 7'bxx010xx});
assign p[75]  = cmp({d_in, a_in}, {16'bx000110101xxxxxx, 7'bxx1101x});
assign p[76]  = cmp({d_in, a_in}, {16'b1110xxxxxxxxxxxx, 7'bxx1101x});
assign p[77]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bxx1101x});
assign p[78]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx11011});
assign p[79]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx11010});
assign p[80]  = cmp({d_in, a_in}, {16'bx000110101xxxxxx, 7'bxx00100});
assign p[81]  = cmp({d_in, a_in}, {16'b01110xxxxxxxxxxx, 7'bxx00100});
assign p[82]  = cmp({d_in, a_in}, {16'b1000110100xxxxxx, 7'bxx00100});
assign p[83]  = cmp({d_in, a_in}, {16'bx000101111xxxxxx, 7'bxx00100});
assign p[84]  = cmp({d_in, a_in}, {16'bx01xxxxxxxxxxxxx, 7'bxx00100});
assign p[85]  = cmp({d_in, a_in}, {16'bx000110110xxxxxx, 7'bxx00100});
assign p[86]  = cmp({d_in, a_in}, {16'bx000101000xxxxxx, 7'bxx00100});
assign p[87]  = cmp({d_in, a_in}, {16'bx000110111xxxxxx, 7'bxx00100});
assign p[88]  = cmp({d_in, a_in}, {16'bx001xxxxxxxxxxxx, 7'bxx00100});
assign p[89]  = cmp({d_in, a_in}, {16'bx000110110xxxxxx, 7'bxx0x10x});
assign p[90]  = cmp({d_in, a_in}, {16'bx000110101xxxxxx, 7'bxx0x10x});
assign p[91]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxx11x, 7'bxx0x10x});
assign p[92]  = cmp({d_in, a_in}, {16'b1110xxxxxxxxxxxx, 7'bxx0x10x});
assign p[93]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bxx0x10x});
assign p[94]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx100xxx, 7'bxx00100});
assign p[95]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx010xxx, 7'bxx00100});
assign p[96]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx00100});
assign p[97]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx111xxx, 7'bxx0110x});
assign p[98]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx110xxx, 7'bxx0110x});
assign p[99]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx101xxx, 7'bxx0110x});
assign p[100] = cmp({d_in, a_in}, {16'bxxxxxxxxxx100xxx, 7'bxx0110x});
assign p[101] = cmp({d_in, a_in}, {16'bxxxxxxxxxx011xxx, 7'bxx0110x});
assign p[102] = cmp({d_in, a_in}, {16'bxxxxxxxxxx010xxx, 7'bxx0110x});
assign p[103] = cmp({d_in, a_in}, {16'bxxxxxxxxxx001xxx, 7'bxx0110x});
assign p[104] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx00110});
assign p[105] = cmp({d_in, a_in}, {16'bxxxxxxx11xxxxxxx, 7'bxx01110});
assign p[106] = cmp({d_in, a_in}, {16'b1110xxxxxxxxxxxx, 7'bxx0x110});
assign p[107] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bxx0x110});
assign p[108] = cmp({d_in, a_in}, {16'bxxxx111xxxxxxxxx, 7'bxx01110});
assign p[109] = cmp({d_in, a_in}, {16'bxxxx110xxxxxxxxx, 7'bxx01110});
assign p[110] = cmp({d_in, a_in}, {16'bxxxx101xxxxxxxxx, 7'bxx01110});
assign p[111] = cmp({d_in, a_in}, {16'bxxxx100xxxxxxxxx, 7'bxx01110});
assign p[112] = cmp({d_in, a_in}, {16'bxxxx011xxxxxxxxx, 7'bxx01110});
assign p[113] = cmp({d_in, a_in}, {16'bxxxx010xxxxxxxxx, 7'bxx01110});
assign p[114] = cmp({d_in, a_in}, {16'bxxxx001xxxxxxxxx, 7'bxx01110});
assign p[115] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx10010});
assign p[116] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxx10000});
assign p[117] = cmp({d_in, a_in}, {16'b1111xxxxxxxxxxxx, 7'bxx01111});
assign p[118] = cmp({d_in, a_in}, {16'b0111110xxxxxxxxx, 7'bxx01xxx});
assign p[119] = cmp({d_in, a_in}, {16'b0111101xxxxxxxxx, 7'bxx01xxx});
assign p[120] = cmp({d_in, a_in}, {16'b0000000000000xxx, 7'bxx01xxx});
assign p[121] = cmp({d_in, a_in}, {16'b0000000001001001, 7'bxx00000});
assign p[122] = cmp({d_in, a_in}, {16'b1000000001001001, 7'bxx00000});
assign p[123] = cmp({d_in, a_in}, {16'bx000000001101001, 7'bxx00000});
assign p[124] = cmp({d_in, a_in}, {16'bx000100001x01001, 7'bxx00000});
assign p[125] = cmp({d_in, a_in}, {16'bx000x10001x01001, 7'bxx00000});
assign p[126] = cmp({d_in, a_in}, {16'bx000xx1001x01001, 7'bxx00000});
assign p[127] = cmp({d_in, a_in}, {16'bx001xxx001x01001, 7'bxx00000});
assign p[128] = cmp({d_in, a_in}, {16'bx00xxxx101x01001, 7'bxx00000});
assign p[129] = cmp({d_in, a_in}, {16'bx00xxxxx11x01001, 7'bxx00000});
assign p[130] = cmp({d_in, a_in}, {16'bx01xxxxxx1x01001, 7'bxx00000});
assign p[131] = cmp({d_in, a_in}, {16'bx1xxxxxxx1x01001, 7'bxx00000});
assign p[132] = cmp({d_in, a_in}, {16'bxxxxxxxxx0x01001, 7'bxx00000});
assign p[133] = cmp({d_in, a_in}, {16'bxxxxxxxxxxx01101, 7'bxx00000});
assign p[134] = cmp({d_in, a_in}, {16'bxxxxxxxxxxx01x11, 7'bxx00000});
assign p[135] = cmp({d_in, a_in}, {16'bxxxxxxxxxxx00xx1, 7'bxx00000});
assign p[136] = cmp({d_in, a_in}, {16'bxxxxxxxxxxx1xxx1, 7'bxx00000});
assign p[137] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxx0, 7'bxx00000});

assign pl[0]   = p[137] | p[136] | p[135] | p[134] | p[130] | p[129] | p[128] | p[126] | p[125] | p[124]
               | p[122] | p[116] | p[115] | p[114] | p[113] | p[112] | p[111] | p[109] | p[108] | p[104]
               | p[103] | p[102] | p[100] | p[99]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[74]
               | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[65]  | p[64]  | p[63]  | p[62]
               | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[52]
               | p[51]  | p[50]  | p[49]  | p[48]  | p[44]  | p[39]  | p[38]  | p[37]  | p[36]  | p[34]
               | p[32]  | p[31]  | p[30]  | p[27]  | p[26]  | p[25]  | p[24]  | p[22]  | p[21]  | p[20]
               | p[19]  | p[16]  | p[15]  | p[14]  | p[10]  | p[7]   | p[6]   | p[4]   | p[3];

assign pl[1]   = p[136] | p[135] | p[132] | p[130] | p[129] | p[127] | p[118] | p[114] | p[113] | p[112]
               | p[111] | p[110] | p[104] | p[41]  | p[40]  | p[38]  | p[37]  | p[36]  | p[29]  | p[23]
               | p[20]  | p[19]  | p[16]  | p[15]  | p[10]  | p[9]   | p[4]   | p[1]   | p[0];

assign pl[2]   = p[137] | p[134] | p[133] | p[128] | p[126] | p[125] | p[124] | p[123] | p[122] | p[120]
               | p[118] | p[116] | p[111] | p[110] | p[108] | p[104] | p[103] | p[102] | p[100] | p[99]
               | p[98]  | p[73]  | p[72]  | p[65]  | p[56]  | p[49]  | p[44]  | p[41]  | p[36]  | p[35]
               | p[32]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[16]  | p[15]
               | p[14]  | p[11]  | p[9]   | p[5]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[3]   = p[131] | p[120] | p[114] | p[113] | p[112] | p[111] | p[110] | p[102] | p[101] | p[100]
               | p[99]  | p[95]  | p[94]  | p[65]  | p[49]  | p[47]  | p[46]  | p[43]  | p[35]  | p[34]
               | p[33]  | p[23]  | p[22]  | p[21]  | p[18]  | p[13]  | p[11]  | p[2];

assign pl[4]   = p[136] | p[135] | p[134] | p[133] | p[131] | p[130] | p[128] | p[126] | p[125] | p[124]
               | p[123] | p[122] | p[121] | p[118] | p[116] | p[115] | p[111] | p[110] | p[109] | p[99]
               | p[98]  | p[97]  | p[96]  | p[95]  | p[94]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]
               | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[73]
               | p[72]  | p[65]  | p[56]  | p[49]  | p[45]  | p[44]  | p[42]  | p[38]  | p[37]  | p[36]
               | p[35]  | p[34]  | p[33]  | p[30]  | p[29]  | p[27]  | p[26]  | p[25]  | p[24]  | p[22]
               | p[20]  | p[19]  | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[9]   | p[8]   | p[4]
               | p[2]   | p[1]   | p[0];

assign pl[5]   = p[136] | p[135] | p[134] | p[133] | p[131] | p[130] | p[129] | p[128] | p[127] | p[126]
               | p[125] | p[124] | p[120] | p[118] | p[116] | p[115] | p[46]  | p[38]  | p[37]  | p[36]
               | p[22]  | p[21]  | p[20]  | p[19]  | p[13]  | p[11]  | p[8]   | p[4]   | p[2]   | p[1]
               | p[0];

assign pl[6]   = p[137] | p[136] | p[135] | p[134] | p[130] | p[128] | p[126] | p[125] | p[124] | p[122]
               | p[121] | p[120] | p[116] | p[115] | p[114] | p[113] | p[111] | p[110] | p[109] | p[108]
               | p[103] | p[102] | p[101] | p[100] | p[73]  | p[72]  | p[65]  | p[56]  | p[49]  | p[44]
               | p[41]  | p[40]  | p[38]  | p[37]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]
               | p[24]  | p[23]  | p[20]  | p[19]  | p[16]  | p[15]  | p[14]  | p[9]   | p[8]   | p[7]
               | p[6]   | p[5]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[7]   = p[121] | p[109] | p[108] | p[98]  | p[97]  | p[47]  | p[43]  | p[41]  | p[40]  | p[32]
               | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[18];

assign pl[8]   = p[137] | p[128] | p[126] | p[125] | p[124] | p[122] | p[121] | p[120] | p[116] | p[114]
               | p[113] | p[111] | p[110] | p[109] | p[108] | p[104] | p[103] | p[102] | p[101] | p[100]
               | p[99]  | p[98]  | p[97]  | p[88]  | p[87]  | p[86]  | p[85]  | p[79]  | p[78]  | p[77]
               | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[65]
               | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
               | p[54]  | p[53]  | p[52]  | p[51]  | p[50]  | p[49]  | p[48]  | p[46]  | p[45]  | p[42]
               | p[39]  | p[37]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[23]
               | p[22]  | p[21]  | p[17]  | p[16]  | p[15]  | p[11]  | p[10]  | p[7]   | p[6]   | p[4]
               | p[3]   | p[2];

assign pl[9]   = p[136] | p[135] | p[131] | p[130] | p[129] | p[128] | p[126] | p[125] | p[124] | p[121]
               | p[114] | p[113] | p[112] | p[109] | p[108] | p[104] | p[101] | p[98]  | p[97]  | p[96]
               | p[95]  | p[94]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]
               | p[80]  | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]
               | p[70]  | p[69]  | p[68]  | p[66]  | p[50]  | p[48]  | p[46]  | p[44]  | p[40]  | p[39]
               | p[38]  | p[35]  | p[32]  | p[31]  | p[30]  | p[27]  | p[26]  | p[25]  | p[24]  | p[23]
               | p[22]  | p[21]  | p[16]  | p[15]  | p[14]  | p[13]  | p[11]  | p[10]  | p[7]   | p[6]
               | p[1];

assign pl[10]  = p[137] | p[134] | p[133] | p[131] | p[129] | p[127] | p[122] | p[116] | p[114] | p[113]
               | p[111] | p[110] | p[109] | p[108] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]
               | p[98]  | p[97]  | p[96]  | p[95]  | p[94]  | p[88]  | p[87]  | p[85]  | p[84]  | p[83]
               | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[74]  | p[73]
               | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]
               | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[52]  | p[51]
               | p[50]  | p[49]  | p[48]  | p[46]  | p[45]  | p[44]  | p[42]  | p[41]  | p[40]  | p[39]
               | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[27]  | p[26]
               | p[25]  | p[24]  | p[17]  | p[16]  | p[11]  | p[10]  | p[9]   | p[8]   | p[7]   | p[6]
               | p[5]   | p[3]   | p[1]   | p[0];

assign pl[11]  = p[136] | p[131] | p[130] | p[127] | p[118] | p[114] | p[113] | p[112] | p[109] | p[108]
               | p[104] | p[103] | p[102] | p[101] | p[98]  | p[97]  | p[96]  | p[95]  | p[94]  | p[88]
               | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]
               | p[77]  | p[76]  | p[75]  | p[66]  | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]
               | p[44]  | p[43]  | p[42]  | p[40]  | p[38]  | p[37]  | p[36]  | p[35]  | p[32]  | p[31]
               | p[28]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[17]  | p[15]  | p[14]
               | p[13]  | p[7]   | p[6]   | p[4]   | p[2];

assign pl[12]  = p[137] | p[134] | p[133] | p[131] | p[129] | p[128] | p[127] | p[126] | p[125] | p[124]
               | p[122] | p[121] | p[120] | p[118] | p[116] | p[114] | p[113] | p[112] | p[104] | p[103]
               | p[102] | p[100] | p[96]  | p[95]  | p[94]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]
               | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[73]
               | p[72]  | p[65]  | p[56]  | p[49]  | p[45]  | p[42]  | p[37]  | p[30]  | p[27]  | p[26]
               | p[25]  | p[24]  | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[11]  | p[10]  | p[9]
               | p[8]   | p[7]   | p[6]   | p[5]   | p[4]   | p[3]   | p[2];

assign pl[13]  = p[136] | p[135] | p[134] | p[133] | p[131] | p[130] | p[128] | p[126] | p[125] | p[124]
               | p[118] | p[116] | p[115] | p[104] | p[85]  | p[80]  | p[79]  | p[78]  | p[77]  | p[76]
               | p[75]  | p[48]  | p[47]  | p[46]  | p[44]  | p[43]  | p[38]  | p[30]  | p[27]  | p[26]
               | p[25]  | p[24]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[9]   | p[8]   | p[7]
               | p[6]   | p[4]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[14]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[131] | p[130] | p[129] | p[128] | p[127]
               | p[126] | p[125] | p[124] | p[122] | p[121] | p[120] | p[118] | p[116] | p[115] | p[114]
               | p[113] | p[112] | p[111] | p[110] | p[109] | p[108] | p[104] | p[103] | p[102] | p[101]
               | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[95]  | p[94]  | p[88]  | p[87]  | p[86]
               | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[77]  | p[76]
               | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[65]  | p[64]
               | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]
               | p[53]  | p[52]  | p[51]  | p[50]  | p[49]  | p[48]  | p[46]  | p[45]  | p[44]  | p[42]
               | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]
               | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[22]
               | p[21]  | p[20]  | p[19]  | p[17];

assign pl[15]  = p[136] | p[131] | p[130] | p[129] | p[128] | p[127] | p[126] | p[125] | p[124] | p[121]
               | p[117] | p[114] | p[113] | p[112] | p[109] | p[108] | p[101] | p[98]  | p[97]  | p[96]
               | p[95]  | p[94]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]
               | p[80]  | p[47]  | p[46]  | p[43]  | p[40]  | p[38]  | p[35]  | p[32]  | p[31]  | p[21]
               | p[20]  | p[19]  | p[18]  | p[13]  | p[9]   | p[7]   | p[6]   | p[3];

assign pl[16]  = p[122] | p[116] | p[114] | p[113] | p[104] | p[103] | p[102] | p[100] | p[96]  | p[95]
               | p[94]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]
               | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[73]  | p[72]  | p[65]  | p[56]  | p[49]
               | p[45]  | p[42]  | p[37]  | p[30]  | p[27]  | p[26]  | p[25]  | p[24]  | p[17]  | p[12]
               | p[11]  | p[10]  | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[4]   | p[3]   | p[2]
               | p[1]   | p[0];

assign pl[17]  = p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[128] | p[126] | p[125]
               | p[121] | p[120] | p[119] | p[118] | p[117] | p[116] | p[115] | p[112] | p[110] | p[109]
               | p[108] | p[107] | p[106] | p[105] | p[103] | p[102] | p[101] | p[99]  | p[98]  | p[97]
               | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[77]  | p[76]  | p[75]  | p[69]  | p[68]
               | p[67]  | p[64]  | p[51]  | p[50]  | p[47]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]
               | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]
               | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[20]  | p[19]
               | p[18]  | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[11]  | p[10]  | p[8]   | p[7]
               | p[6]   | p[2]   | p[0];

assign pl[18]  = p[136] | p[135] | p[132] | p[130] | p[129] | p[128] | p[127] | p[126] | p[124] | p[121]
               | p[120] | p[119] | p[117] | p[113] | p[112] | p[109] | p[108] | p[101] | p[98]  | p[97]
               | p[95]  | p[78]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[64]
               | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]
               | p[53]  | p[52]  | p[51]  | p[50]  | p[48]  | p[47]  | p[46]  | p[43]  | p[42]  | p[40]
               | p[39]  | p[38]  | p[35]  | p[32]  | p[31]  | p[22]  | p[20]  | p[19]  | p[18]  | p[16]
               | p[14]  | p[13]  | p[7]   | p[6]   | p[3];

assign pl[19]  = p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[129] | p[128] | p[127] | p[125]
               | p[124] | p[120] | p[119] | p[118] | p[117] | p[116] | p[115] | p[104] | p[103] | p[102]
               | p[88]  | p[87]  | p[86]  | p[85]  | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[74]
               | p[73]  | p[72]  | p[71]  | p[69]  | p[68]  | p[63]  | p[61]  | p[60]  | p[59]  | p[56]
               | p[53]  | p[52]  | p[50]  | p[48]  | p[47]  | p[46]  | p[45]  | p[44]  | p[43]  | p[37]
               | p[36]  | p[30]  | p[28]  | p[27]  | p[23]  | p[20]  | p[18]  | p[17]  | p[16]  | p[15]
               | p[14]  | p[13]  | p[10]  | p[8]   | p[7]   | p[6]   | p[5]   | p[3]   | p[2]   | p[0];

assign pl[20]  = p[134] | p[133] | p[132] | p[130] | p[129] | p[127] | p[126] | p[125] | p[124] | p[121]
               | p[120] | p[119] | p[118] | p[117] | p[114] | p[113] | p[112] | p[109] | p[108] | p[104]
               | p[103] | p[102] | p[101] | p[98]  | p[97]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]
               | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[74]  | p[71]  | p[70]  | p[69]  | p[68]
               | p[59]  | p[56]  | p[55]  | p[53]  | p[51]  | p[48]  | p[47]  | p[46]  | p[45]  | p[43]
               | p[40]  | p[38]  | p[37]  | p[36]  | p[35]  | p[32]  | p[31]  | p[30]  | p[28]  | p[27]
               | p[22]  | p[18]  | p[17]  | p[15]  | p[14]  | p[13]  | p[4]   | p[3]   | p[1]   | p[0];

assign pl[21]  = p[136] | p[135] | p[132] | p[131] | p[130] | p[128] | p[126] | p[125] | p[124] | p[120]
               | p[119] | p[118] | p[117] | p[116] | p[115] | p[111] | p[110] | p[103] | p[102] | p[100]
               | p[99]  | p[74]  | p[71]  | p[70]  | p[69]  | p[64]  | p[63]  | p[61]  | p[58]  | p[55]
               | p[54]  | p[53]  | p[52]  | p[51]  | p[50]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]
               | p[41]  | p[38]  | p[37]  | p[36]  | p[34]  | p[33]  | p[30]  | p[29]  | p[28]  | p[27]
               | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[17]  | p[16]  | p[15]  | p[11]  | p[10]
               | p[9]   | p[8]   | p[5]   | p[4]   | p[2]   | p[1]   | p[0];

assign pl[22]  = p[132] | p[131] | p[129] | p[127] | p[121] | p[120] | p[119] | p[118] | p[117] | p[116]
               | p[115] | p[114] | p[113] | p[112] | p[111] | p[110] | p[109] | p[108] | p[104] | p[103]
               | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[95]  | p[94]  | p[88]
               | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]
               | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[63]  | p[62]  | p[59]  | p[55]  | p[54]
               | p[53]  | p[52]  | p[51]  | p[48]  | p[47]  | p[46]  | p[45]  | p[43]  | p[41]  | p[40]
               | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[28]
               | p[18]  | p[17]  | p[16]  | p[15]  | p[14]  | p[10]  | p[8]   | p[7]   | p[6]   | p[5]
               | p[3]   | p[2];

assign pl[23]  = p[136] | p[135] | p[132] | p[130] | p[129] | p[128] | p[127] | p[126] | p[125] | p[124]
               | p[121] | p[119] | p[118] | p[117] | p[114] | p[113] | p[112] | p[109] | p[108] | p[101]
               | p[98]  | p[97]  | p[96]  | p[95]  | p[94]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]
               | p[83]  | p[82]  | p[81]  | p[80]  | p[73]  | p[69]  | p[68]  | p[62]  | p[61]  | p[60]
               | p[59]  | p[58]  | p[57]  | p[55]  | p[54]  | p[53]  | p[52]  | p[47]  | p[46]  | p[43]
               | p[40]  | p[38]  | p[35]  | p[32]  | p[31]  | p[27]  | p[23]  | p[22]  | p[20]  | p[19]
               | p[18]  | p[10]  | p[9]   | p[4]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[24]  = p[136] | p[135] | p[132] | p[131] | p[130] | p[129] | p[128] | p[127] | p[126] | p[125]
               | p[124] | p[121] | p[120] | p[119] | p[117] | p[114] | p[113] | p[112] | p[111] | p[110]
               | p[109] | p[108] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[95]  | p[94]
               | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[47]
               | p[46]  | p[43]  | p[41]  | p[40]  | p[38]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]
               | p[29]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[14]  | p[13]  | p[9]   | p[7]
               | p[6]   | p[4]   | p[3]   | p[1]   | p[0];

assign ma = ~{pl[16],    pl[14], pl[12], pl[10], pl[8], pl[6], pl[4], pl[2], pl[0]};
assign mc = ~{pl[24:17], pl[15], pl[13], pl[11], pl[9], pl[7], pl[5], pl[3], pl[1]};

endmodule
