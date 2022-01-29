//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
//______________________________________________________________________________
//
module dc_pla_1
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

assign p[0]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[1]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[2]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[3]   = cmp({d_in, a_in}, {16'bxxxxxxxxxx11xxxx, 7'bx011111});
assign p[4]   = cmp({d_in, a_in}, {16'bxxxxxxxxxx001111, 7'bx011111});
assign p[5]   = cmp({d_in, a_in}, {16'b0xxxxxxxxx000111, 7'bx011111});
assign p[6]   = cmp({d_in, a_in}, {16'b1xxxxxxxxx000111, 7'bx011111});
assign p[7]   = cmp({d_in, a_in}, {16'bxxxxxxxxxx10xxxx, 7'bx011111});
assign p[8]   = cmp({d_in, a_in}, {16'bxxxxxxxxxx01x111, 7'bx011111});
assign p[9]   = cmp({d_in, a_in}, {16'bxxxxxxxxxx0xxxx0, 7'bx011111});
assign p[10]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx0xxx0x, 7'bx011111});
assign p[11]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx0xx0xx, 7'bx011111});
assign p[12]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bx111011});
assign p[13]  = cmp({d_in, a_in}, {16'b00xx1011xxxxxxxx, 7'bx100010});
assign p[14]  = cmp({d_in, a_in}, {16'b01xx1011xxxxxxxx, 7'bx100010});
assign p[15]  = cmp({d_in, a_in}, {16'b10xx1011xxxxxxxx, 7'bx100010});
assign p[16]  = cmp({d_in, a_in}, {16'b11xx1011xxxxxxxx, 7'bx100010});
assign p[17]  = cmp({d_in, a_in}, {16'bxxxx1011xxxxxxxx, 7'bx111101});
assign p[18]  = cmp({d_in, a_in}, {16'bxxxx1110xxxxxxxx, 7'bx011110});
assign p[19]  = cmp({d_in, a_in}, {16'b0xxx1110xxxxxxxx, 7'bx100000});
assign p[20]  = cmp({d_in, a_in}, {16'b1xxx1110xxxxxxxx, 7'bx100000});
assign p[21]  = cmp({d_in, a_in}, {16'bx0xx1110xxxxxxxx, 7'bx000110});
assign p[22]  = cmp({d_in, a_in}, {16'bx1xx1110xxxxxxxx, 7'bx000110});
assign p[23]  = cmp({d_in, a_in}, {16'bxxxx1110xxxxxxxx, 7'bx000011});
assign p[24]  = cmp({d_in, a_in}, {16'bxxxx1100xxxxxxxx, 7'bx011110});
assign p[25]  = cmp({d_in, a_in}, {16'bxxxx1100xxxxxxxx, 7'bx100111});
assign p[26]  = cmp({d_in, a_in}, {16'bxxxx1100xxxxxxxx, 7'bx100011});
assign p[27]  = cmp({d_in, a_in}, {16'bxxxx1100xxxxxxxx, 7'bx000011});
assign p[28]  = cmp({d_in, a_in}, {16'bxxxx111xxxxxxxxx, 7'bx100111});
assign p[29]  = cmp({d_in, a_in}, {16'b0xxx1111xxxxxxxx, 7'bx111101});
assign p[30]  = cmp({d_in, a_in}, {16'b1xxx1111xxxxxxxx, 7'bx111101});
assign p[31]  = cmp({d_in, a_in}, {16'bxxxx1111xxxxxxxx, 7'bx000011});
assign p[32]  = cmp({d_in, a_in}, {16'bxxxx1000xxxxxxxx, 7'bx000011});
assign p[33]  = cmp({d_in, a_in}, {16'bxxxx0101xxxxxxxx, 7'bx011110});
assign p[34]  = cmp({d_in, a_in}, {16'b0xxx0101xxxxxxxx, 7'bx111101});
assign p[35]  = cmp({d_in, a_in}, {16'b1xxx0101xxxxxxxx, 7'bx111101});
assign p[36]  = cmp({d_in, a_in}, {16'bxxxx00011xxxxxxx, 7'bx011110});
assign p[37]  = cmp({d_in, a_in}, {16'bxxxx000111xxxxxx, 7'bx110101});
assign p[38]  = cmp({d_in, a_in}, {16'bxxxx000110xxxxxx, 7'bx110101});
assign p[39]  = cmp({d_in, a_in}, {16'bxxxx00011xxxxxxx, 7'bx111101});
assign p[40]  = cmp({d_in, a_in}, {16'bxxxx000100xxxxxx, 7'bx011110});
assign p[41]  = cmp({d_in, a_in}, {16'bxxxx000100xxxxxx, 7'bx100011});
assign p[42]  = cmp({d_in, a_in}, {16'bxxxx000100xxxxxx, 7'bx000011});
assign p[43]  = cmp({d_in, a_in}, {16'bxxxx000101xxxxxx, 7'bx011110});
assign p[44]  = cmp({d_in, a_in}, {16'bxxxx00010xxxxxxx, 7'bx111101});
assign p[45]  = cmp({d_in, a_in}, {16'bxxxx11x1xxxxxxxx, 7'bx011110});
assign p[46]  = cmp({d_in, a_in}, {16'bxxxx1101xxxxxxxx, 7'bx000110});
assign p[47]  = cmp({d_in, a_in}, {16'bxxxx1101xxxxxxxx, 7'bx000011});
assign p[48]  = cmp({d_in, a_in}, {16'bxxxx101xxxxxxxxx, 7'bx011110});
assign p[49]  = cmp({d_in, a_in}, {16'bxxxx1010xxxxxxxx, 7'bx111101});
assign p[50]  = cmp({d_in, a_in}, {16'bxxxx101xxxxxxxxx, 7'bx000011});
assign p[51]  = cmp({d_in, a_in}, {16'bxxxx000011xxxxxx, 7'bx000011});
assign p[52]  = cmp({d_in, a_in}, {16'bxxxx000010xxxxxx, 7'bx000011});
assign p[53]  = cmp({d_in, a_in}, {16'bxxxx000001xxxxxx, 7'bx000110});
assign p[54]  = cmp({d_in, a_in}, {16'bxxxx000001xxxxxx, 7'bx000011});
assign p[55]  = cmp({d_in, a_in}, {16'bxxxx00000000x010, 7'bx000011});
assign p[56]  = cmp({d_in, a_in}, {16'bxxxx00000000x001, 7'bx000011});
assign p[57]  = cmp({d_in, a_in}, {16'bxxxx000000000000, 7'bx000011});
assign p[58]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bx111111});
assign p[59]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx011001});
assign p[60]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx011001});
assign p[61]  = cmp({d_in, a_in}, {16'bxxxx1001xxxxxxxx, 7'bx111101});
assign p[62]  = cmp({d_in, a_in}, {16'bxxxx0100xxxxxxxx, 7'bx111101});
assign p[63]  = cmp({d_in, a_in}, {16'bxxxx0x1xxxxxxxxx, 7'bx111101});
assign p[64]  = cmp({d_in, a_in}, {16'bxxxx0x1xxxxxxxxx, 7'bx111001});
assign p[65]  = cmp({d_in, a_in}, {16'bxxxx01x0xxxxxxxx, 7'bx111001});
assign p[66]  = cmp({d_in, a_in}, {16'bxxxx0101xxxxxxxx, 7'bx111001});
assign p[67]  = cmp({d_in, a_in}, {16'bxxxx1111xxxxxxxx, 7'bx111001});
assign p[68]  = cmp({d_in, a_in}, {16'bxxxx1001xxxxxxxx, 7'bx111001});
assign p[69]  = cmp({d_in, a_in}, {16'bxxxx0001xxxxxxxx, 7'bx111001});
assign p[70]  = cmp({d_in, a_in}, {16'bxxxx0x1xxxxxxxxx, 7'bx000011});
assign p[71]  = cmp({d_in, a_in}, {16'bxxxx01x0xxxxxxxx, 7'bx000011});
assign p[72]  = cmp({d_in, a_in}, {16'bxxxx1001xxxxxxxx, 7'bx000011});
assign p[73]  = cmp({d_in, a_in}, {16'bxxxx0101xxxxxxxx, 7'bx000011});
assign p[74]  = cmp({d_in, a_in}, {16'bxxxx00011xxxxxxx, 7'bx000011});
assign p[75]  = cmp({d_in, a_in}, {16'bxxxx0001x1xxxxxx, 7'bx000011});
assign p[76]  = cmp({d_in, a_in}, {16'bxxxxx0xxxxxxxxxx, 7'bx110111});
assign p[77]  = cmp({d_in, a_in}, {16'bxxxx0xxxxxxxxxxx, 7'bx110111});
assign p[78]  = cmp({d_in, a_in}, {16'bxxxx11xxxxxxxxxx, 7'bx110111});
assign p[79]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx111xxx, 7'bx101100});
assign p[80]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx110xxx, 7'bx101100});
assign p[81]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx101xxx, 7'bx101100});
assign p[82]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx100xxx, 7'bx101100});
assign p[83]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx011xxx, 7'bx101100});
assign p[84]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx010xx0, 7'bx101100});
assign p[85]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx010x0x, 7'bx101100});
assign p[86]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx0100xx, 7'bx101100});
assign p[87]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx010111, 7'bx101100});
assign p[88]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx001xxx, 7'bx101100});
assign p[89]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx000x0x, 7'bx101100});
assign p[90]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx0000xx, 7'bx101100});
assign p[91]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx111xxx, 7'bx101000});
assign p[92]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx110xxx, 7'bx101000});
assign p[93]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx101xxx, 7'bx101000});
assign p[94]  = cmp({d_in, a_in}, {16'b0xxxxxxxxx100xxx, 7'bx101101});
assign p[95]  = cmp({d_in, a_in}, {16'b1xxxxxxxxx100xxx, 7'bx101101});
assign p[96]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx100xxx, 7'bx101000});
assign p[97]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx011xxx, 7'bx101000});
assign p[98]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx101011});
assign p[99]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx101011});
assign p[100] = cmp({d_in, a_in}, {16'bxxxxxxxxxx010xx0, 7'bx101000});
assign p[101] = cmp({d_in, a_in}, {16'bxxxxxxxxxx010x0x, 7'bx101000});
assign p[102] = cmp({d_in, a_in}, {16'bxxxxxxxxxx0100xx, 7'bx101000});
assign p[103] = cmp({d_in, a_in}, {16'bxxxxxxxxxx010111, 7'bx101000});
assign p[104] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx101010});
assign p[105] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx101010});
assign p[106] = cmp({d_in, a_in}, {16'bxxxxxxxxxx001xxx, 7'bx101000});
assign p[107] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx101001});
assign p[108] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx101001});
assign p[109] = cmp({d_in, a_in}, {16'bxxxxxxxxxx000x0x, 7'bx101000});
assign p[110] = cmp({d_in, a_in}, {16'bxxxxxxxxxx0000xx, 7'bx101000});
assign p[111] = cmp({d_in, a_in}, {16'bxxxxxxxxxx00011x, 7'bx101x00});
assign p[112] = cmp({d_in, a_in}, {16'bx0xxxxxxxxxxxxxx, 7'bx010101});
assign p[113] = cmp({d_in, a_in}, {16'bx1xxxxxxxxxxxxxx, 7'bx010101});
assign p[114] = cmp({d_in, a_in}, {16'bxxxx101xxxxxxxxx, 7'bx010110});
assign p[115] = cmp({d_in, a_in}, {16'bxxxx00001xxxxxxx, 7'bx010110});
assign p[116] = cmp({d_in, a_in}, {16'bx0xxxxxxxxxxxxxx, 7'bx010111});
assign p[117] = cmp({d_in, a_in}, {16'bx1xxxxxxxxxxxxxx, 7'bx010111});
assign p[118] = cmp({d_in, a_in}, {16'bxxxx1110xxxxxxxx, 7'bx010110});
assign p[119] = cmp({d_in, a_in}, {16'bxxxx1101xxxxxxxx, 7'bx010110});
assign p[120] = cmp({d_in, a_in}, {16'bxxxx000001xxxxxx, 7'bx010110});
assign p[121] = cmp({d_in, a_in}, {16'bxxxxxxxxxx111xxx, 7'bx010x00});
assign p[122] = cmp({d_in, a_in}, {16'bxxxxxxxxxx110xxx, 7'bx010x00});
assign p[123] = cmp({d_in, a_in}, {16'bxxxxxxxxxx101xxx, 7'bx010x00});
assign p[124] = cmp({d_in, a_in}, {16'bx0xxxxxxxx100xxx, 7'bx000100});
assign p[125] = cmp({d_in, a_in}, {16'bx1xxxxxxxx100xxx, 7'bx000100});
assign p[126] = cmp({d_in, a_in}, {16'bxxxxxxxxxx100xxx, 7'bx010x00});
assign p[127] = cmp({d_in, a_in}, {16'bxxxxxxxxxx011xxx, 7'bx010x00});
assign p[128] = cmp({d_in, a_in}, {16'bx0xxxxxxxxxxxxxx, 7'bx010010});
assign p[129] = cmp({d_in, a_in}, {16'bx1xxxxxxxxxxxxxx, 7'bx010010});
assign p[130] = cmp({d_in, a_in}, {16'bxxxxxxxxxx010xx0, 7'bx010x00});
assign p[131] = cmp({d_in, a_in}, {16'bxxxxxxxxxx010x0x, 7'bx010x00});
assign p[132] = cmp({d_in, a_in}, {16'bxxxxxxxxxx0100xx, 7'bx010x00});
assign p[133] = cmp({d_in, a_in}, {16'bxxxxxxxxxx010111, 7'bx010100});
assign p[134] = cmp({d_in, a_in}, {16'bxxxxxxxxxx010111, 7'bx010000});
assign p[135] = cmp({d_in, a_in}, {16'bxxxxxxxxxx001xxx, 7'bx010x00});
assign p[136] = cmp({d_in, a_in}, {16'bxxxxxxxxxx000xxx, 7'bx010100});
assign p[137] = cmp({d_in, a_in}, {16'bxxxxxxxxxx000xxx, 7'bx010000});

assign pl[0]   = p[137] | p[135] | p[134] | p[132] | p[131] | p[130] | p[129] | p[128] | p[127] | p[126]
               | p[124] | p[122] | p[121] | p[117] | p[106] | p[99]  | p[98]  | p[95]  | p[93]  | p[90]
               | p[89]  | p[86]  | p[85]  | p[84]  | p[83]  | p[80]  | p[79]  | p[72]  | p[71]  | p[70]
               | p[67]  | p[66]  | p[57]  | p[54]  | p[52]  | p[50]  | p[47]  | p[46]  | p[41]  | p[40]
               | p[39]  | p[35]  | p[32]  | p[29]  | p[26]  | p[22]  | p[21]  | p[20]  | p[17]  | p[16]
               | p[12]  | p[11]  | p[10]  | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[4]   | p[3];

assign pl[1]   = p[137] | p[135] | p[132] | p[131] | p[130] | p[126] | p[125] | p[124] | p[120] | p[119]
               | p[118] | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[110] | p[109] | p[106]
               | p[102] | p[101] | p[100] | p[96]  | p[95]  | p[94]  | p[90]  | p[89]  | p[88]  | p[86]
               | p[85]  | p[84]  | p[82]  | p[63]  | p[62]  | p[61]  | p[60]  | p[56]  | p[55]  | p[52]
               | p[50]  | p[44]  | p[42]  | p[41]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]
               | p[33]  | p[32]  | p[29]  | p[28]  | p[27]  | p[26]  | p[24]  | p[22]  | p[21]  | p[20]
               | p[19]  | p[18]  | p[11]  | p[10]  | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[3];

assign pl[2]   = p[134] | p[133] | p[126] | p[124] | p[123] | p[121] | p[115] | p[114] | p[112] | p[111]
               | p[110] | p[109] | p[106] | p[105] | p[103] | p[99]  | p[98]  | p[97]  | p[96]  | p[93]
               | p[92]  | p[88]  | p[87]  | p[81]  | p[79]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]
               | p[70]  | p[69]  | p[68]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[59]  | p[57]
               | p[54]  | p[53]  | p[52]  | p[51]  | p[49]  | p[47]  | p[42]  | p[40]  | p[39]  | p[38]
               | p[37]  | p[35]  | p[34]  | p[31]  | p[27]  | p[25]  | p[24]  | p[22]  | p[21]  | p[20]
               | p[19]  | p[16]  | p[15]  | p[13]  | p[12];

assign pl[3]   = p[136] | p[134] | p[133] | p[129] | p[128] | p[127] | p[123] | p[103] | p[99]  | p[98]
               | p[97]  | p[93]  | p[87]  | p[83]  | p[81]  | p[78]  | p[67]  | p[66]  | p[60]  | p[59]
               | p[58]  | p[48]  | p[46]  | p[33]  | p[30]  | p[25]  | p[19]  | p[18]  | p[17]  | p[16]
               | p[15]  | p[14]  | p[13];

assign pl[4]   = p[134] | p[133] | p[132] | p[131] | p[130] | p[127] | p[125] | p[121] | p[116] | p[111]
               | p[110] | p[109] | p[108] | p[103] | p[102] | p[101] | p[100] | p[93]  | p[92]  | p[91]
               | p[87]  | p[86]  | p[85]  | p[84]  | p[79]  | p[78]  | p[72]  | p[71]  | p[70]  | p[68]
               | p[67]  | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[57]  | p[56]  | p[55]
               | p[54]  | p[53]  | p[50]  | p[47]  | p[46]  | p[44]  | p[42]  | p[41]  | p[38]  | p[37]
               | p[32]  | p[31]  | p[30]  | p[29]  | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[20]
               | p[19]  | p[17]  | p[16]  | p[15]  | p[13]  | p[12];

assign pl[5]   = p[135] | p[132] | p[131] | p[130] | p[126] | p[125] | p[124] | p[120] | p[119] | p[118]
               | p[115] | p[114] | p[111] | p[106] | p[102] | p[101] | p[100] | p[96]  | p[95]  | p[94]
               | p[88]  | p[86]  | p[85]  | p[84]  | p[82]  | p[78]  | p[77]  | p[76]  | p[69]  | p[68]
               | p[67]  | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]
               | p[49]  | p[48]  | p[46]  | p[45]  | p[44]  | p[43]  | p[42]  | p[40]  | p[39]  | p[36]
               | p[33]  | p[30]  | p[29]  | p[27]  | p[26]  | p[25]  | p[24]  | p[22]  | p[21]  | p[20]
               | p[19]  | p[18]  | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[11]  | p[10]  | p[9]
               | p[8]   | p[7]   | p[6]   | p[5]   | p[3];

assign pl[6]   = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[120] | p[119] | p[118] | p[117]
               | p[115] | p[114] | p[113] | p[111] | p[108] | p[106] | p[104] | p[99]  | p[98]  | p[93]
               | p[92]  | p[91]  | p[90]  | p[89]  | p[81]  | p[80]  | p[75]  | p[74]  | p[73]  | p[72]
               | p[71]  | p[70]  | p[69]  | p[68]  | p[65]  | p[64]  | p[58]  | p[54]  | p[53]  | p[52]
               | p[51]  | p[48]  | p[47]  | p[42]  | p[39]  | p[38]  | p[37]  | p[32]  | p[29]  | p[27]
               | p[26]  | p[25]  | p[24]  | p[23]  | p[15]  | p[14]  | p[12];

assign pl[7]   = p[122] | p[121] | p[92]  | p[91]  | p[80]  | p[79]  | p[60]  | p[36]  | p[33]  | p[18];

assign pl[8]   = p[137] | p[134] | p[133] | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121]
               | p[117] | p[116] | p[112] | p[110] | p[109] | p[107] | p[103] | p[102] | p[101] | p[100]
               | p[97]  | p[96]  | p[95]  | p[94]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]
               | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[67]  | p[66]  | p[60]
               | p[59]  | p[53]  | p[51]  | p[50]  | p[49]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]
               | p[37]  | p[35]  | p[34]  | p[29]  | p[27]  | p[26]  | p[25]  | p[20]  | p[16]  | p[14]
               | p[13];

assign pl[9]   = p[136] | p[134] | p[133] | p[129] | p[128] | p[127] | p[122] | p[121] | p[120] | p[119]
               | p[118] | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[111] | p[105] | p[104]
               | p[103] | p[99]  | p[98]  | p[97]  | p[92]  | p[91]  | p[87]  | p[83]  | p[80]  | p[79]
               | p[78]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[67]
               | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]
               | p[56]  | p[55]  | p[52]  | p[51]  | p[48]  | p[46]  | p[44]  | p[41]  | p[39]  | p[38]
               | p[37]  | p[36]  | p[31]  | p[29]  | p[26]  | p[25]  | p[24]  | p[23]  | p[21]  | p[20]
               | p[17]  | p[14]  | p[13]  | p[12]  | p[6]   | p[5];

assign pl[10]  = p[137] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128] | p[127]
               | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[120] | p[119] | p[118] | p[117]
               | p[116] | p[115] | p[114] | p[112] | p[108] | p[107] | p[106] | p[105] | p[104] | p[99]
               | p[98]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]
               | p[78]  | p[77]  | p[76]  | p[63]  | p[62]  | p[61]  | p[54]  | p[53]  | p[52]  | p[51]
               | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[43]  | p[42]  | p[39]  | p[38]
               | p[37]  | p[35]  | p[34]  | p[32]  | p[31]  | p[30]  | p[27]  | p[26]  | p[25]  | p[24]
               | p[23]  | p[22]  | p[21]  | p[16]  | p[15]  | p[14]  | p[13];

assign pl[11]  = p[137] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128] | p[127]
               | p[126] | p[122] | p[121] | p[120] | p[119] | p[118] | p[117] | p[116] | p[115] | p[114]
               | p[113] | p[112] | p[111] | p[110] | p[109] | p[108] | p[107] | p[106] | p[105] | p[104]
               | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[92]  | p[91]
               | p[90]  | p[89]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[80]
               | p[79]  | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]  | p[60]  | p[59]  | p[56]
               | p[55]  | p[51]  | p[42]  | p[33]  | p[30]  | p[27]  | p[24]  | p[22]  | p[18]  | p[17]
               | p[16]  | p[15]  | p[12]  | p[6]   | p[5];

assign pl[12]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[120] | p[119] | p[118]
               | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[110] | p[109] | p[108] | p[107]
               | p[106] | p[105] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]
               | p[96]  | p[95]  | p[94]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[69]
               | p[63]  | p[62]  | p[61]  | p[54]  | p[53]  | p[52]  | p[51]  | p[50]  | p[49]  | p[48]
               | p[47]  | p[46]  | p[44]  | p[41]  | p[40]  | p[38]  | p[37]  | p[26]  | p[25]  | p[24]
               | p[23]  | p[22]  | p[21]  | p[19]  | p[17];

assign pl[13]  = p[129] | p[128] | p[117] | p[116] | p[113] | p[112] | p[111] | p[105] | p[104] | p[99]
               | p[98]  | p[78]  | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]
               | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[57]
               | p[56]  | p[53]  | p[52]  | p[49]  | p[48]  | p[46]  | p[45]  | p[43]  | p[42]  | p[40]
               | p[38]  | p[37]  | p[36]  | p[33]  | p[31]  | p[30]  | p[27]  | p[26]  | p[25]  | p[24]
               | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[16]  | p[15]  | p[12]  | p[6]
               | p[5];

assign pl[14]  = p[137] | p[136] | p[135] | p[132] | p[131] | p[130] | p[129] | p[128] | p[126] | p[120]
               | p[119] | p[118] | p[117] | p[115] | p[114] | p[113] | p[110] | p[109] | p[102] | p[101]
               | p[100] | p[96]  | p[63]  | p[62]  | p[61]  | p[54]  | p[53]  | p[52]  | p[51]  | p[50]
               | p[49]  | p[48]  | p[47]  | p[46]  | p[44]  | p[42]  | p[40]  | p[39]  | p[35]  | p[34]
               | p[32]  | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[20]  | p[11]  | p[10]  | p[9]
               | p[8]   | p[7]   | p[6]   | p[5]   | p[4]   | p[3];

assign pl[15]  = p[134] | p[133] | p[129] | p[128] | p[127] | p[122] | p[121] | p[120] | p[119] | p[118]
               | p[115] | p[114] | p[113] | p[112] | p[111] | p[103] | p[99]  | p[98]  | p[97]  | p[92]
               | p[91]  | p[87]  | p[83]  | p[80]  | p[79]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]
               | p[67]  | p[66]  | p[65]  | p[64]  | p[60]  | p[59]  | p[58]  | p[55]  | p[53]  | p[51]
               | p[33]  | p[18]  | p[12]  | p[6]   | p[5];

assign pl[16]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[120] | p[119] | p[118]
               | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[110] | p[109] | p[108] | p[107]
               | p[106] | p[105] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]
               | p[96]  | p[95]  | p[94]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[87]
               | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[77]
               | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[67]  | p[66]
               | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]
               | p[52]  | p[47]  | p[45]  | p[43]  | p[41]  | p[40];

assign pl[17]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[120] | p[119] | p[118]
               | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[111] | p[110] | p[109] | p[108]
               | p[107] | p[106] | p[105] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]
               | p[97]  | p[96]  | p[95]  | p[94]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]
               | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]
               | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]
               | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]
               | p[55]  | p[53]  | p[52]  | p[51]  | p[50]  | p[49]  | p[48]  | p[46]  | p[45]  | p[44]
               | p[43]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]
               | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]
               | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[17]  | p[16]  | p[15]  | p[14]
               | p[13]  | p[11]  | p[10]  | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[3];

assign pl[18]  = p[134] | p[133] | p[128] | p[127] | p[124] | p[122] | p[121] | p[120] | p[119] | p[118]
               | p[115] | p[114] | p[113] | p[112] | p[103] | p[99]  | p[98]  | p[97]  | p[95]  | p[94]
               | p[92]  | p[91]  | p[90]  | p[89]  | p[87]  | p[83]  | p[80]  | p[79]  | p[69]  | p[68]
               | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[58]  | p[56]  | p[55]  | p[53]
               | p[51]  | p[36]  | p[35]  | p[34]  | p[33]  | p[28]  | p[24]  | p[22]  | p[21]  | p[18]
               | p[17]  | p[8]   | p[3];

assign pl[19]  = p[137] | p[136] | p[135] | p[133] | p[132] | p[131] | p[130] | p[129] | p[126] | p[117]
               | p[116] | p[115] | p[114] | p[113] | p[112] | p[111] | p[110] | p[109] | p[108] | p[107]
               | p[106] | p[105] | p[104] | p[102] | p[101] | p[100] | p[98]  | p[96]  | p[94]  | p[90]
               | p[89]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[82]  | p[78]  | p[77]  | p[76]
               | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[63]  | p[62]  | p[61]  | p[60]
               | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[53]  | p[52]  | p[51]  | p[50]  | p[49]
               | p[48]  | p[46]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]
               | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[28]
               | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]
               | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[12]  | p[6];

assign pl[20]  = p[137] | p[136] | p[135] | p[134] | p[132] | p[131] | p[130] | p[129] | p[128] | p[127]
               | p[126] | p[122] | p[121] | p[120] | p[119] | p[118] | p[117] | p[116] | p[113] | p[112]
               | p[111] | p[110] | p[109] | p[108] | p[107] | p[106] | p[105] | p[104] | p[103] | p[102]
               | p[101] | p[100] | p[99]  | p[97]  | p[96]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]
               | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[80]  | p[79]  | p[78]  | p[77]  | p[76]
               | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[63]  | p[62]  | p[61]  | p[60]
               | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[53]  | p[52]  | p[51]  | p[50]  | p[48]
               | p[46]  | p[45]  | p[43]  | p[42]  | p[38]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]
               | p[31]  | p[28]  | p[27]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]
               | p[18]  | p[17]  | p[14]  | p[13]  | p[12]  | p[6]   | p[5];

assign pl[21]  = p[137] | p[136] | p[135] | p[132] | p[131] | p[130] | p[129] | p[128] | p[126] | p[125]
               | p[124] | p[123] | p[111] | p[106] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[96]
               | p[95]  | p[94]  | p[93]  | p[88]  | p[86]  | p[85]  | p[84]  | p[82]  | p[81]  | p[69]
               | p[68]  | p[65]  | p[64]  | p[56]  | p[55]  | p[53]  | p[51]  | p[49]  | p[44]  | p[42]
               | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[33]  | p[30]  | p[29]  | p[27]
               | p[26]  | p[24]  | p[22]  | p[21]  | p[18]  | p[17]  | p[16]  | p[15]  | p[11]  | p[10]
               | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[3];

assign pl[22]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[120] | p[119] | p[118]
               | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[110] | p[109] | p[108] | p[107]
               | p[106] | p[105] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]
               | p[96]  | p[95]  | p[94]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[87]
               | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[75]
               | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[67]  | p[66]  | p[63]  | p[62]  | p[61]
               | p[60]  | p[59]  | p[58]  | p[57]  | p[52]  | p[50]  | p[49]  | p[48]  | p[46]  | p[44]
               | p[42]  | p[41]  | p[40]  | p[39]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]
               | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[23]  | p[20]  | p[19]  | p[18]
               | p[16]  | p[15]  | p[14]  | p[13]  | p[12]  | p[11]  | p[10]  | p[9]   | p[8]   | p[7]
               | p[6]   | p[5]   | p[3];

assign pl[23]  = p[134] | p[133] | p[127] | p[122] | p[121] | p[120] | p[119] | p[118] | p[115] | p[114]
               | p[113] | p[112] | p[111] | p[103] | p[97]  | p[92]  | p[91]  | p[90]  | p[89]  | p[87]
               | p[83]  | p[80]  | p[79]  | p[69]  | p[68]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]
               | p[60]  | p[58]  | p[56]  | p[55]  | p[53]  | p[51]  | p[44]  | p[42]  | p[39]  | p[36]
               | p[35]  | p[34]  | p[33]  | p[29]  | p[28]  | p[27]  | p[24]  | p[22]  | p[21]  | p[18]
               | p[12];

assign pl[24]  = p[134] | p[133] | p[129] | p[128] | p[127] | p[125] | p[124] | p[123] | p[122] | p[121]
               | p[120] | p[119] | p[118] | p[115] | p[114] | p[113] | p[112] | p[111] | p[103] | p[99]
               | p[98]  | p[97]  | p[95]  | p[94]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[87]
               | p[83]  | p[81]  | p[80]  | p[79]  | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]
               | p[63]  | p[62]  | p[61]  | p[60]  | p[58]  | p[56]  | p[55]  | p[53]  | p[51]  | p[36]
               | p[35]  | p[34]  | p[33]  | p[28]  | p[24]  | p[22]  | p[21]  | p[18]  | p[17]  | p[12]
               | p[11]  | p[10]  | p[9]   | p[8]   | p[7]   | p[6]   | p[5]   | p[3];

assign ma = ~{pl[16],    pl[14], pl[12], pl[10], pl[8], pl[6], pl[4], pl[2], pl[0]};
assign mc = ~{pl[24:17], pl[15], pl[13], pl[11], pl[9], pl[7], pl[5], pl[3], pl[1]};

endmodule
