//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
//______________________________________________________________________________
//
module dc_pla_2
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
assign p[3]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[4]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[5]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[6]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[7]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[8]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[9]   = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[10]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bxxxxxxx});
assign p[11]  = cmp({d_in, a_in}, {16'b00000000xxxxxxxx, 7'bx100111});
assign p[12]  = cmp({d_in, a_in}, {16'bxxxxx011xxxxxxxx, 7'bx110011});
assign p[13]  = cmp({d_in, a_in}, {16'bxxxx1001xxxxxxxx, 7'bx110011});
assign p[14]  = cmp({d_in, a_in}, {16'bxxxx0xx0xxxxxxxx, 7'bx110011});
assign p[15]  = cmp({d_in, a_in}, {16'bxxx1xxxxxxxxxxxx, 7'bx100111});
assign p[16]  = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bx100000});
assign p[17]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx010010});
assign p[18]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx010010});
assign p[19]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx110010});
assign p[20]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx110010});
assign p[21]  = cmp({d_in, a_in}, {16'bxxxxx011xxxxxxxx, 7'bx101011});
assign p[22]  = cmp({d_in, a_in}, {16'bxxxx0111xxxxxxxx, 7'bx101011});
assign p[23]  = cmp({d_in, a_in}, {16'bxxxx1001xxxxxxxx, 7'bx101011});
assign p[24]  = cmp({d_in, a_in}, {16'bxxxx0xx0xxxxxxxx, 7'bx101011});
assign p[25]  = cmp({d_in, a_in}, {16'bxxxx00011xxxxxxx, 7'bx100011});
assign p[26]  = cmp({d_in, a_in}, {16'bxxxx1xxxxxxxxxxx, 7'bx100011});
assign p[27]  = cmp({d_in, a_in}, {16'bxxxxx1xxxxxxxxxx, 7'bx100011});
assign p[28]  = cmp({d_in, a_in}, {16'bxxxxxx1xxxxxxxxx, 7'bx100011});
assign p[29]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx11xxxx, 7'bx100010});
assign p[30]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx101xxx, 7'bx100010});
assign p[31]  = cmp({d_in, a_in}, {16'b0xxxxxxxxx100xxx, 7'bx100010});
assign p[32]  = cmp({d_in, a_in}, {16'b1xxxxxxxxx100xxx, 7'bx100010});
assign p[33]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx011xxx, 7'bx100010});
assign p[34]  = cmp({d_in, a_in}, {16'b0xxxxxxxxx010xx0, 7'bx100010});
assign p[35]  = cmp({d_in, a_in}, {16'b0xxxxxxxxx010x0x, 7'bx100010});
assign p[36]  = cmp({d_in, a_in}, {16'b0xxxxxxxxx0100xx, 7'bx100010});
assign p[37]  = cmp({d_in, a_in}, {16'b1xxxxxxxxx010xx0, 7'bx100010});
assign p[38]  = cmp({d_in, a_in}, {16'b1xxxxxxxxx010x0x, 7'bx100010});
assign p[39]  = cmp({d_in, a_in}, {16'b1xxxxxxxxx0100xx, 7'bx100010});
assign p[40]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx010111, 7'bx100010});
assign p[41]  = cmp({d_in, a_in}, {16'bxxxxxxxxxx00xxxx, 7'bx100010});
assign p[42]  = cmp({d_in, a_in}, {16'bxxx01xxxxxxxxxxx, 7'bx100111});
assign p[43]  = cmp({d_in, a_in}, {16'bxxx0x1xxxxxxxxxx, 7'bx100111});
assign p[44]  = cmp({d_in, a_in}, {16'bxxx0xx1xxxxxxxxx, 7'bx100111});
assign p[45]  = cmp({d_in, a_in}, {16'bxxx010000xxxxxxx, 7'bx00xxxx});
assign p[46]  = cmp({d_in, a_in}, {16'bxxx0x1000xxxxxxx, 7'bx00xxxx});
assign p[47]  = cmp({d_in, a_in}, {16'bxxx0xx100xxxxxxx, 7'bx00xxxx});
assign p[48]  = cmp({d_in, a_in}, {16'bxxx1xxx00xxxxxxx, 7'bx00xxxx});
assign p[49]  = cmp({d_in, a_in}, {16'bxxxxxxx10xxxxxxx, 7'bx00xxxx});
assign p[50]  = cmp({d_in, a_in}, {16'bxxxxxxxx1xxxxxxx, 7'bx00xxxx});
assign p[51]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx011100});
assign p[52]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx011100});
assign p[53]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx011110});
assign p[54]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx011110});
assign p[55]  = cmp({d_in, a_in}, {16'bxx1x1001xxxxxxxx, 7'bx101000});
assign p[56]  = cmp({d_in, a_in}, {16'bxx1x0xx0xxxxxxxx, 7'bx101000});
assign p[57]  = cmp({d_in, a_in}, {16'bxx0x1001xxxxxxxx, 7'bx101000});
assign p[58]  = cmp({d_in, a_in}, {16'bxx0x0xx0xxxxxxxx, 7'bx101000});
assign p[59]  = cmp({d_in, a_in}, {16'bxx1xxxxxxxxxxxxx, 7'bx111011});
assign p[60]  = cmp({d_in, a_in}, {16'bxx0xxxxxxxxxxxxx, 7'bx111011});
assign p[61]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx101010});
assign p[62]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx101010});
assign p[63]  = cmp({d_in, a_in}, {16'bxxxx1011xxxxxxxx, 7'bx101000});
assign p[64]  = cmp({d_in, a_in}, {16'bxxxx0011xxxxxxxx, 7'bx011111});
assign p[65]  = cmp({d_in, a_in}, {16'b0xxx1001xxxxxxxx, 7'bx011111});
assign p[66]  = cmp({d_in, a_in}, {16'b1xxx1001xxxxxxxx, 7'bx011111});
assign p[67]  = cmp({d_in, a_in}, {16'b0xxx0010xxxxxxxx, 7'bx011111});
assign p[68]  = cmp({d_in, a_in}, {16'b1xxx0010xxxxxxxx, 7'bx011111});
assign p[69]  = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx000111});
assign p[70]  = cmp({d_in, a_in}, {16'b0xxx01x0xxxxxxxx, 7'bx011111});
assign p[71]  = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx000011});
assign p[72]  = cmp({d_in, a_in}, {16'b1xxx01x0xxxxxxxx, 7'bx011111});
assign p[73]  = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx001100});
assign p[74]  = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx000010});
assign p[75]  = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx000100});
assign p[76]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx101001});
assign p[77]  = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx000000});
assign p[78]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx101001});
assign p[79]  = cmp({d_in, a_in}, {16'b1xxx0011xxxxxxxx, 7'bx110000});
assign p[80]  = cmp({d_in, a_in}, {16'b0xxx001xxxxxxxxx, 7'bx110000});
assign p[81]  = cmp({d_in, a_in}, {16'b1xxx0010xxxxxxxx, 7'bx110000});
assign p[82]  = cmp({d_in, a_in}, {16'b0xxx1001xxxxxxxx, 7'bx110000});
assign p[83]  = cmp({d_in, a_in}, {16'b1xxx1001xxxxxxxx, 7'bx110000});
assign p[84]  = cmp({d_in, a_in}, {16'bxxxx1001xxxxxxxx, 7'bx011011});
assign p[85]  = cmp({d_in, a_in}, {16'bxxxx001xxxxxxxxx, 7'bx011011});
assign p[86]  = cmp({d_in, a_in}, {16'bxxxx1001xxxxxxxx, 7'bx011001});
assign p[87]  = cmp({d_in, a_in}, {16'bxxxx001xxxxxxxxx, 7'bx011001});
assign p[88]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx011000});
assign p[89]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx011000});
assign p[90]  = cmp({d_in, a_in}, {16'bxxxx1001xxxxxxxx, 7'bx010000});
assign p[91]  = cmp({d_in, a_in}, {16'bxxxx001xxxxxxxxx, 7'bx010000});
assign p[92]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx110110});
assign p[93]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx110110});
assign p[94]  = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx110101});
assign p[95]  = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx110101});
assign p[96]  = cmp({d_in, a_in}, {16'bx0xxxxx1xxxxxxxx, 7'bx011101});
assign p[97]  = cmp({d_in, a_in}, {16'bx0xxxxx011xxxxxx, 7'bx011101});
assign p[98]  = cmp({d_in, a_in}, {16'bx0xxxxx01011xxxx, 7'bx011101});
assign p[99]  = cmp({d_in, a_in}, {16'bx0xxxxx01010xxxx, 7'bx011101});
assign p[100] = cmp({d_in, a_in}, {16'bx0xxxxx01001xxxx, 7'bx011101});
assign p[101] = cmp({d_in, a_in}, {16'bx0xxxxx010001xxx, 7'bx011101});
assign p[102] = cmp({d_in, a_in}, {16'bx0xxxxx01000x1xx, 7'bx011101});
assign p[103] = cmp({d_in, a_in}, {16'bx0xxxxx01000xx1x, 7'bx011101});
assign p[104] = cmp({d_in, a_in}, {16'bx0xxxxx01000xxx1, 7'bx011101});
assign p[105] = cmp({d_in, a_in}, {16'bx0xxxxx010000000, 7'bx011101});
assign p[106] = cmp({d_in, a_in}, {16'bxxxxxxx00xxxxxxx, 7'bx011101});
assign p[107] = cmp({d_in, a_in}, {16'bx1xxxxxxxxxxxxxx, 7'bx011101});
assign p[108] = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx000101});
assign p[109] = cmp({d_in, a_in}, {16'bxxxx0011xxxxxxxx, 7'bx101000});
assign p[110] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx100100});
assign p[111] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx100100});
assign p[112] = cmp({d_in, a_in}, {16'bxxxx0111xxxxxxxx, 7'bx010000});
assign p[113] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxxx, 7'bx111111});
assign p[114] = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx001001});
assign p[115] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxx1, 7'bx111000});
assign p[116] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxx0, 7'bx111000});
assign p[117] = cmp({d_in, a_in}, {16'bxxx000000xxxxxx1, 7'bx001010});
assign p[118] = cmp({d_in, a_in}, {16'bxxx000000xxxxxx0, 7'bx001010});
assign p[119] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxx1, 7'bx110100});
assign p[120] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxx0, 7'bx110100});
assign p[121] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxx1, 7'bx101111});
assign p[122] = cmp({d_in, a_in}, {16'bxxxxxxxxxxxxxxx0, 7'bx101111});
assign p[123] = cmp({d_in, a_in}, {16'bxxx000000xxxxxxx, 7'bx001000});
assign p[124] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx111010});
assign p[125] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx111010});
assign p[126] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx101110});
assign p[127] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx101110});
assign p[128] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx010111});
assign p[129] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx010111});
assign p[130] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx010110});
assign p[131] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx010110});
assign p[132] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx010101});
assign p[133] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx010101});
assign p[134] = cmp({d_in, a_in}, {16'b0xxxxxxxxxxxxxxx, 7'bx010100});
assign p[135] = cmp({d_in, a_in}, {16'b1xxxxxxxxxxxxxxx, 7'bx010100});
assign p[136] = cmp({d_in, a_in}, {16'bxxxx0110xxxxxxxx, 7'bx010000});
assign p[137] = cmp({d_in, a_in}, {16'bxxxx0100xxxxxxxx, 7'bx010000});

assign pl[0]   = p[137] | p[136] | p[133] | p[132] | p[130] | p[129] | p[128] | p[125] | p[124] | p[123]
               | p[118] | p[117] | p[116] | p[115] | p[114] | p[112] | p[111] | p[110] | p[109] | p[108]
               | p[104] | p[103] | p[102] | p[101] | p[99]  | p[97]  | p[96]  | p[91]  | p[90]  | p[87]
               | p[86]  | p[84]  | p[83]  | p[81]  | p[80]  | p[79]  | p[78]  | p[75]  | p[73]  | p[72]
               | p[71]  | p[67]  | p[65]  | p[64]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]
               | p[56]  | p[55]  | p[54]  | p[53]  | p[44]  | p[43]  | p[42]  | p[28]  | p[27]  | p[26]
               | p[18]  | p[14]  | p[13]  | p[12];

assign pl[1]   = p[137] | p[136] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[110] | p[104]
               | p[103] | p[102] | p[101] | p[99]  | p[91]  | p[90]  | p[86]  | p[79]  | p[76]  | p[74]
               | p[73]  | p[71]  | p[69]  | p[60]  | p[58]  | p[57]  | p[28]  | p[27]  | p[26]  | p[25]
               | p[16];

assign pl[2]   = p[137] | p[136] | p[135] | p[132] | p[131] | p[130] | p[129] | p[128] | p[127] | p[125]
               | p[124] | p[120] | p[118] | p[116] | p[112] | p[111] | p[107] | p[106] | p[105] | p[99]
               | p[98]  | p[95]  | p[94]  | p[92]  | p[91]  | p[90]  | p[89]  | p[87]  | p[86]  | p[85]
               | p[83]  | p[81]  | p[75]  | p[74]  | p[73]  | p[71]  | p[70]  | p[69]  | p[68]  | p[66]
               | p[62]  | p[60]  | p[58]  | p[57]  | p[54]  | p[50]  | p[49]  | p[48]  | p[47]  | p[46]
               | p[45]  | p[24]  | p[23]  | p[22]  | p[21]  | p[19]  | p[18]  | p[16]  | p[15]  | p[14]
               | p[13]  | p[12];

assign pl[3]   = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[129] | p[128] | p[122] | p[121]
               | p[120] | p[116] | p[114] | p[107] | p[106] | p[105] | p[104] | p[103] | p[102] | p[101]
               | p[100] | p[93]  | p[91]  | p[90]  | p[89]  | p[88]  | p[83]  | p[81]  | p[80]  | p[78]
               | p[77]  | p[76]  | p[74]  | p[71]  | p[69]  | p[63]  | p[62]  | p[61]  | p[54]  | p[52]
               | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[40]  | p[39]  | p[38]  | p[37]
               | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[28]  | p[27]  | p[26]
               | p[25]  | p[20]  | p[19]  | p[18]  | p[17]  | p[16];

assign pl[4]   = p[136] | p[134] | p[130] | p[128] | p[127] | p[125] | p[124] | p[123] | p[122] | p[121]
               | p[119] | p[117] | p[115] | p[113] | p[112] | p[110] | p[109] | p[104] | p[103] | p[102]
               | p[101] | p[100] | p[95]  | p[94]  | p[93]  | p[91]  | p[90]  | p[89]  | p[83]  | p[82]
               | p[81]  | p[79]  | p[77]  | p[75]  | p[72]  | p[69]  | p[63]  | p[62]  | p[53]  | p[52]
               | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]
               | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]
               | p[30]  | p[29]  | p[24]  | p[23]  | p[22]  | p[21]  | p[18]  | p[17]  | p[15]  | p[14]
               | p[13]  | p[12];

assign pl[5]   = p[136] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[114] | p[112] | p[109]
               | p[107] | p[106] | p[105] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]
               | p[97]  | p[96]  | p[91]  | p[90]  | p[89]  | p[88]  | p[85]  | p[84]  | p[81]  | p[80]
               | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[70]  | p[68]
               | p[67]  | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[50]  | p[49]  | p[48]
               | p[47]  | p[46]  | p[45]  | p[28]  | p[27]  | p[26]  | p[20]  | p[19]  | p[16]  | p[15]
               | p[13]  | p[12]  | p[11];

assign pl[6]   = p[137] | p[136] | p[135] | p[134] | p[131] | p[129] | p[128] | p[126] | p[120] | p[119]
               | p[116] | p[115] | p[114] | p[111] | p[109] | p[108] | p[89]  | p[87]  | p[86]  | p[81]
               | p[80]  | p[78]  | p[76]  | p[73]  | p[72]  | p[71]  | p[70]  | p[63]  | p[61]  | p[52]
               | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]
               | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]
               | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]
               | p[19]  | p[18]  | p[17]  | p[16]  | p[15];

assign pl[7]   = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[129] | p[128] | p[125] | p[124]
               | p[123] | p[122] | p[121] | p[120] | p[119] | p[116] | p[115] | p[112] | p[110] | p[109]
               | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[93]
               | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[87]  | p[83]  | p[82]  | p[79]  | p[78]
               | p[76]  | p[75]  | p[74]  | p[73]  | p[71]  | p[69]  | p[62]  | p[61]  | p[54]  | p[53]
               | p[52]  | p[51]  | p[44]  | p[43]  | p[42]  | p[29]  | p[24]  | p[23]  | p[22]  | p[21]
               | p[20]  | p[19]  | p[18]  | p[17]  | p[16]  | p[14];

assign pl[8]   = p[136] | p[135] | p[134] | p[130] | p[125] | p[124] | p[120] | p[119] | p[118] | p[117]
               | p[113] | p[111] | p[110] | p[88]  | p[82]  | p[80]  | p[79]  | p[76]  | p[75]  | p[63]
               | p[62]  | p[61]  | p[54]  | p[53]  | p[51]  | p[50]  | p[49]  | p[48]  | p[47]  | p[46]
               | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]
               | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]
               | p[24]  | p[23]  | p[22]  | p[18]  | p[17]  | p[16];

assign pl[9]   = p[136] | p[126] | p[125] | p[124] | p[123] | p[115] | p[112] | p[110] | p[104] | p[103]
               | p[102] | p[101] | p[99]  | p[87]  | p[85]  | p[84]  | p[83]  | p[82]  | p[76]  | p[74]
               | p[73]  | p[71]  | p[69]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[32]
               | p[31]  | p[30]  | p[25]  | p[16]  | p[14]  | p[13]  | p[12];

assign pl[10]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[125] | p[124] | p[120] | p[119]
               | p[118] | p[117] | p[116] | p[115] | p[114] | p[113] | p[112] | p[91]  | p[90]  | p[89]
               | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[76]  | p[75]  | p[74]  | p[72]
               | p[71]  | p[70]  | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]  | p[60]  | p[59]
               | p[58]  | p[57]  | p[56]  | p[55]  | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]
               | p[28]  | p[27]  | p[26]  | p[21]  | p[20]  | p[19];

assign pl[11]  = p[136] | p[125] | p[124] | p[123] | p[122] | p[120] | p[111] | p[104] | p[103] | p[102]
               | p[101] | p[100] | p[95]  | p[93]  | p[87]  | p[83]  | p[82]  | p[81]  | p[80]  | p[78]
               | p[74]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]
               | p[59]  | p[56]  | p[55]  | p[52]  | p[32]  | p[31]  | p[30]  | p[28]  | p[27]  | p[26]
               | p[16]  | p[14]  | p[13]  | p[12];

assign pl[12]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[91]  | p[90]  | p[89]
               | p[88]  | p[87]  | p[86]  | p[85]  | p[84]  | p[81]  | p[80]  | p[79]  | p[78]  | p[77]
               | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]  | p[63]
               | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]
               | p[52]  | p[51]  | p[44]  | p[43]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[37]
               | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[18];

assign pl[13]  = p[136] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[115] | p[114] | p[112]
               | p[109] | p[107] | p[106] | p[105] | p[95]  | p[94]  | p[83]  | p[82]  | p[81]  | p[80]
               | p[78]  | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[70]  | p[68]  | p[67]
               | p[66]  | p[65]  | p[64]  | p[63]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
               | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[32]  | p[31]  | p[30]  | p[28]
               | p[27]  | p[26]  | p[15];

assign pl[14]  = p[137] | p[125] | p[124] | p[91]  | p[90]  | p[89]  | p[88]  | p[87]  | p[86]  | p[85]
               | p[84]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[78]  | p[77]  | p[76]  | p[75]
               | p[74]  | p[73]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[44]  | p[43]
               | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]
               | p[32]  | p[31]  | p[30]  | p[29]  | p[18];

assign pl[15]  = p[125] | p[124] | p[123] | p[122] | p[121] | p[120] | p[119] | p[111] | p[109] | p[104]
               | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[93]  | p[92]
               | p[85]  | p[84]  | p[83]  | p[82]  | p[79]  | p[78]  | p[77]  | p[76]  | p[75]  | p[74]
               | p[73]  | p[71]  | p[69]  | p[52]  | p[51]  | p[32]  | p[31]  | p[30]  | p[28]  | p[27]
               | p[26]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[16]  | p[11];

assign pl[16]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[120] | p[119] | p[118]
               | p[117] | p[116] | p[115] | p[114] | p[112] | p[111] | p[110] | p[109] | p[108] | p[104]
               | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[95]  | p[94]
               | p[93]  | p[92]  | p[91]  | p[90]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
               | p[44]  | p[43]  | p[42]  | p[41]  | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]
               | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[18];

assign pl[17]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[122] | p[121] | p[120] | p[119] | p[118] | p[117] | p[116]
               | p[115] | p[114] | p[112] | p[111] | p[110] | p[109] | p[108] | p[107] | p[106] | p[105]
               | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[95]
               | p[94]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[85]  | p[84]  | p[81]
               | p[80]  | p[78]  | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]
               | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]
               | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[52]  | p[51]  | p[50]
               | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[44]  | p[43]  | p[42]  | p[40]  | p[39]
               | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]
               | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]  | p[20]  | p[19]
               | p[18]  | p[17]  | p[16]  | p[15]  | p[11];

assign pl[18]  = p[136] | p[129] | p[128] | p[127] | p[126] | p[125] | p[124] | p[123] | p[120] | p[119]
               | p[118] | p[117] | p[116] | p[115] | p[111] | p[109] | p[95]  | p[94]  | p[87]  | p[86]
               | p[83]  | p[82]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]
               | p[68]  | p[67]  | p[66]  | p[65]  | p[64]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]
               | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]
               | p[34]  | p[32]  | p[31]  | p[25]  | p[20]  | p[19]  | p[18]  | p[17]  | p[14]  | p[13]
               | p[12]  | p[11];

assign pl[19]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[120] | p[119] | p[116]
               | p[115] | p[114] | p[112] | p[111] | p[110] | p[109] | p[108] | p[107] | p[106] | p[105]
               | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[95]
               | p[94]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[87]  | p[86]  | p[85]
               | p[84]  | p[83]  | p[82]  | p[81]  | p[79]  | p[78]  | p[77]  | p[76]  | p[68]  | p[67]
               | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]
               | p[56]  | p[55]  | p[54]  | p[53]  | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]
               | p[36]  | p[35]  | p[34]  | p[31]  | p[30]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]
               | p[23]  | p[22]  | p[21]  | p[20]  | p[19]  | p[18]  | p[17]  | p[16]  | p[15]  | p[14]
               | p[13]  | p[12]  | p[11];

assign pl[20]  = p[137] | p[136] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[127] | p[126]
               | p[125] | p[124] | p[123] | p[118] | p[117] | p[116] | p[115] | p[114] | p[112] | p[111]
               | p[110] | p[107] | p[106] | p[105] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]
               | p[98]  | p[97]  | p[96]  | p[91]  | p[90]  | p[89]  | p[88]  | p[85]  | p[84]  | p[83]
               | p[82]  | p[79]  | p[78]  | p[76]  | p[75]  | p[63]  | p[62]  | p[61]  | p[59]  | p[56]
               | p[55]  | p[54]  | p[53]  | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[32]
               | p[30]  | p[28]  | p[27]  | p[26]  | p[25]  | p[20]  | p[19]  | p[18]  | p[17]  | p[16]
               | p[15]  | p[11];

assign pl[21]  = p[136] | p[133] | p[132] | p[125] | p[124] | p[120] | p[119] | p[118] | p[117] | p[116]
               | p[115] | p[109] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]
               | p[96]  | p[93]  | p[92]  | p[87]  | p[86]  | p[85]  | p[83]  | p[82]  | p[81]  | p[80]
               | p[79]  | p[77]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]
               | p[67]  | p[66]  | p[65]  | p[64]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
               | p[54]  | p[53]  | p[52]  | p[51]  | p[44]  | p[43]  | p[42]  | p[40]  | p[39]  | p[38]
               | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]  | p[30]  | p[29]  | p[25]
               | p[24]  | p[23]  | p[22]  | p[21]  | p[14]  | p[13]  | p[12]  | p[11];

assign pl[22]  = p[137] | p[135] | p[134] | p[133] | p[132] | p[131] | p[130] | p[129] | p[128] | p[127]
               | p[126] | p[123] | p[120] | p[119] | p[118] | p[117] | p[114] | p[112] | p[110] | p[109]
               | p[107] | p[106] | p[105] | p[104] | p[103] | p[102] | p[101] | p[100] | p[99]  | p[98]
               | p[97]  | p[96]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[87]  | p[86]
               | p[81]  | p[77]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[71]  | p[70]  | p[69]
               | p[68]  | p[67]  | p[66]  | p[65]  | p[64]  | p[63]  | p[62]  | p[61]  | p[60]  | p[58]
               | p[57]  | p[50]  | p[49]  | p[48]  | p[47]  | p[46]  | p[45]  | p[44]  | p[43]  | p[42]
               | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]
               | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[24]  | p[23]  | p[22]  | p[21]
               | p[20]  | p[19]  | p[18]  | p[17]  | p[16]  | p[14]  | p[13]  | p[12]  | p[11];

assign pl[23]  = p[136] | p[129] | p[128] | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121]
               | p[120] | p[119] | p[118] | p[117] | p[116] | p[115] | p[111] | p[108] | p[95]  | p[94]
               | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[79]  | p[77]  | p[75]  | p[74]
               | p[73]  | p[72]  | p[71]  | p[70]  | p[69]  | p[68]  | p[67]  | p[66]  | p[65]  | p[64]
               | p[62]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]
               | p[28]  | p[27]  | p[26]  | p[25]  | p[20]  | p[19]  | p[18]  | p[17]  | p[14]  | p[13]
               | p[12]  | p[11];

assign pl[24]  = p[136] | p[125] | p[124] | p[123] | p[122] | p[121] | p[95]  | p[94]  | p[87]  | p[86]
               | p[83]  | p[82]  | p[79]  | p[77]  | p[76]  | p[72]  | p[70]  | p[68]  | p[67]  | p[66]
               | p[65]  | p[64]  | p[62]  | p[61]  | p[59]  | p[56]  | p[55]  | p[44]  | p[43]  | p[42]
               | p[40]  | p[39]  | p[38]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[32]  | p[31]
               | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]  | p[20]  | p[19]  | p[18]  | p[17]
               | p[14]  | p[13]  | p[12]  | p[11];

assign ma = ~{pl[16],    pl[14], pl[12], pl[10], pl[8], pl[6], pl[4], pl[2], pl[0]};
assign mc = ~{pl[24:17], pl[15], pl[13], pl[11], pl[9], pl[7], pl[5], pl[3], pl[1]};

endmodule
