//
// Copyright (c) 2025 by 1801BM1@gmail.com
//
// T-11 programmable logic matrices (PLM)
//______________________________________________________________________________
//
// Main matrix inputs format:
//
//    m[9:0] - instruction code latched in instrustion register (opcode)
//    n[7:0] - microinstruction next address
//
module t11_plm
(
   input         init,
   input  [9:0]  m,
   input  [7:0]  n,
   output [29:0] sp
);
wire [140:0] p;
wire [29:0] pl;

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

assign p[0]   = init;
assign p[1]   = cmp({m, n}, {10'bxxxxxxxxx1, 8'b11111111});
assign p[2]   = cmp({m, n}, {10'bxxxxxxx1x0, 8'b11111111});
assign p[3]   = cmp({m, n}, {10'bxxxxxxx010, 8'b11111111});
assign p[4]   = cmp({m, n}, {10'bxx10000000, 8'b11111111});
assign p[5]   = cmp({m, n}, {10'b0000000xxx, 8'b11100010});
assign p[6]   = cmp({m, n}, {10'b0000000101, 8'b11101000});
assign p[7]   = cmp({m, n}, {10'bxxx1000000, 8'b11111111});
assign p[8]   = cmp({m, n}, {10'bxxxxxx1000, 8'b11111111});
assign p[9]   = cmp({m, n}, {10'b0000000000, 8'b11111111});
assign p[10]  = cmp({m, n}, {10'b0000000000, 8'b11101000});
assign p[11]  = cmp({m, n}, {10'b0000000001, 8'b11101000});
assign p[12]  = cmp({m, n}, {10'b0000000011, 8'b11101000});
assign p[13]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b11x1100x});
assign p[14]  = cmp({m, n}, {10'bxxxx100000, 8'b11111111});
assign p[15]  = cmp({m, n}, {10'b0000000x10, 8'b11101000});
assign p[16]  = cmp({m, n}, {10'bxxxx001xxx, 8'b11x0000x});
assign p[17]  = cmp({m, n}, {10'bxxxx010xxx, 8'b11x0000x});
assign p[18]  = cmp({m, n}, {10'bxxxx011xxx, 8'b11x000xx});
assign p[19]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b11101111});
assign p[20]  = cmp({m, n}, {10'bxxxx000xxx, 8'b11x001x1});
assign p[21]  = cmp({m, n}, {10'bxxxx11xxxx, 8'b11x000xx});
assign p[22]  = cmp({m, n}, {10'bxxxx110xxx, 8'b111010x1});
assign p[23]  = cmp({m, n}, {10'b0000000100, 8'b11101000});
assign p[24]  = cmp({m, n}, {10'bxxxx111xxx, 8'b111010x1});
assign p[25]  = cmp({m, n}, {10'bxxxxx10000, 8'b11111111});
assign p[26]  = cmp({m, n}, {10'b0000001xxx, 8'b11100010});
assign p[27]  = cmp({m, n}, {10'b0000100xxx, 8'b11x1x010});
assign p[28]  = cmp({m, n}, {10'b0000100xxx, 8'b11100010});
assign p[29]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b11001111});
assign p[30]  = cmp({m, n}, {10'bx000101001, 8'b11x001x1});
assign p[31]  = cmp({m, n}, {10'bx000101111, 8'b11x001x1});
assign p[32]  = cmp({m, n}, {10'b0xxxxxxxxx, 8'b11x0000x});
assign p[33]  = cmp({m, n}, {10'bxxxx100xxx, 8'b11x0000x});
assign p[34]  = cmp({m, n}, {10'b0000000xxx, 8'b11101010});
assign p[35]  = cmp({m, n}, {10'bx001xxxxxx, 8'b11x001x1});
assign p[36]  = cmp({m, n}, {10'bx010xxxxxx, 8'b11x001x1});
assign p[37]  = cmp({m, n}, {10'bx011xxxxxx, 8'b11x001x1});
assign p[38]  = cmp({m, n}, {10'b1000110100, 8'b11x00110});
assign p[39]  = cmp({m, n}, {10'bx101xxxxxx, 8'b11x001x1});
assign p[40]  = cmp({m, n}, {10'b0110xxxxxx, 8'b11x001x1});
assign p[41]  = cmp({m, n}, {10'b1110xxxxxx, 8'b11x001x1});
assign p[42]  = cmp({m, n}, {10'bxxxx101xxx, 8'b11x000xx});
assign p[43]  = cmp({m, n}, {10'bx0000xxxxx, 8'b11001000});
assign p[44]  = cmp({m, n}, {10'b0000000011, 8'b11x001x1});
assign p[45]  = cmp({m, n}, {10'bx000101000, 8'b11x001x1});
assign p[46]  = cmp({m, n}, {10'b1110xxxxxx, 8'b11x0000x});
assign p[47]  = cmp({m, n}, {10'bx000101010, 8'b11x001x1});
assign p[48]  = cmp({m, n}, {10'bx000101011, 8'b11x001x1});
assign p[49]  = cmp({m, n}, {10'bx000101100, 8'b11x001x1});
assign p[50]  = cmp({m, n}, {10'bx000101101, 8'b11x001x1});
assign p[51]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b11101101});
assign p[52]  = cmp({m, n}, {10'bxxxxxxx11x, 8'b11x0000x});
assign p[53]  = cmp({m, n}, {10'bx000110000, 8'b11x001x1});
assign p[54]  = cmp({m, n}, {10'bx000110001, 8'b11x001x1});
assign p[55]  = cmp({m, n}, {10'bx000110010, 8'b11x001x1});
assign p[56]  = cmp({m, n}, {10'bx000110011, 8'b11x001x1});
assign p[57]  = cmp({m, n}, {10'b0000110111, 8'b11x001x1});
assign p[58]  = cmp({m, n}, {10'b0111100xxx, 8'b11x001x1});
assign p[59]  = cmp({m, n}, {10'bx000101110, 8'b11x001x1});
assign p[60]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b11x00111});
assign p[61]  = cmp({m, n}, {10'b1000110111, 8'b11x001x1});
assign p[62]  = cmp({m, n}, {10'b1000110100, 8'b11x001x0});
assign p[63]  = cmp({m, n}, {10'bx100xxxxxx, 8'b11x001x1});
assign p[64]  = cmp({m, n}, {10'b0xxxxxxxxx, 8'b11x0x1xx});
assign p[65]  = cmp({m, n}, {10'b0111111xxx, 8'b11001000});
assign p[66]  = cmp({m, n}, {10'b000010xxxx, 8'b11101010});
assign p[67]  = cmp({m, n}, {10'b000011xxxx, 8'b11101010});
assign p[68]  = cmp({m, n}, {10'b0000000001, 8'b11x1x010});
assign p[69]  = cmp({m, n}, {10'b0000010xxx, 8'b11100010});
assign p[70]  = cmp({m, n}, {10'b1110xxxxxx, 8'b11x011x1});
assign p[71]  = cmp({m, n}, {10'b10001000xx, 8'b11001000});
assign p[72]  = cmp({m, n}, {10'b10001001xx, 8'b11001000});
assign p[73]  = cmp({m, n}, {10'b0000000111, 8'b11101000});
assign p[74]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00000010});
assign p[75]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'bxxxxxxxx});
assign p[76]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'bxxxxxxxx});
assign p[77]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'bxxxxxxxx});
assign p[78]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'bxxxxxxxx});
assign p[79]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00111111});
assign p[80]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00111110});
assign p[81]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00111101});
assign p[82]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00100011});
assign p[83]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00011110});
assign p[84]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00001101});
assign p[85]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00111001});
assign p[86]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00111000});
assign p[87]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00001100});
assign p[88]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'bxxxxxxxx});
assign p[89]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00110101});
assign p[90]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00110100});
assign p[91]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00110011});
assign p[92]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00110010});
assign p[93]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00110001});
assign p[94]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00110000});
assign p[95]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00101111});
assign p[96]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00101110});
assign p[97]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00101101});
assign p[98]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00101100});
assign p[99]  = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00010101});
assign p[100] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00010111});
assign p[101] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00101001});
assign p[102] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00101000});
assign p[103] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00011001});
assign p[104] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00100110});
assign p[105] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00110110});
assign p[106] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00111100});
assign p[107] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00100100});
assign p[108] = cmp({m, n}, {10'bxxxxxxxxxx, 8'bxxxxxxxx});
assign p[109] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00000111});
assign p[110] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00100000});
assign p[111] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00110111});
assign p[112] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00111011});
assign p[113] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00011101});
assign p[114] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00011100});
assign p[115] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00011011});
assign p[116] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00011010});
assign p[117] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00100111});
assign p[118] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00001111});
assign p[119] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00101010});
assign p[120] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00000110});
assign p[121] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00101011});
assign p[122] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00010100});
assign p[123] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00111010});
assign p[124] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00100101});
assign p[125] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00010001});
assign p[126] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00010000});
assign p[127] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00011000});
assign p[128] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00001110});
assign p[129] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00010011});
assign p[130] = cmp({m, n}, {10'bxxxxxxxxxx, 8'bxxxxxxxx});
assign p[131] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00001011});
assign p[132] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00001010});
assign p[133] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00001001});
assign p[134] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00001000});
assign p[135] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00000000});
assign p[136] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00010110});
assign p[137] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00000101});
assign p[138] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00000100});
assign p[139] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00010010});
assign p[140] = cmp({m, n}, {10'bxxxxxxxxxx, 8'b00000011});

//
// Summ-Of-Products
//
assign sp = ~pl;

assign pl[0]   = p[140] | p[139] | p[138] | p[136] | p[134] | p[132] | p[128] | p[127] | p[123] | p[118]
               | p[116] | p[114] | p[112] | p[104] | p[103] | p[102] | p[101] | p[100] | p[98]  | p[96]
               | p[92]  | p[91]  | p[89]  | p[83]  | p[80]  | p[79]  | p[74]  | p[68]  | p[66]  | p[63]
               | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[51]
               | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]  | p[41]  | p[40]  | p[39]
               | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[31]  | p[30]  | p[28]  | p[27]  | p[21]
               | p[18]  | p[17]  | p[16]  | p[13]  | p[11]  | p[8]   | p[7]   | p[4]   | p[3]   | p[0];

assign pl[1]   = p[140] | p[138] | p[135] | p[134] | p[131] | p[129] | p[128] | p[126] | p[122] | p[121]
               | p[120] | p[118] | p[117] | p[116] | p[115] | p[114] | p[111] | p[110] | p[109] | p[107]
               | p[106] | p[103] | p[102] | p[98]  | p[95]  | p[94]  | p[92]  | p[91]  | p[89]  | p[87]
               | p[86]  | p[84]  | p[82]  | p[79]  | p[74]  | p[73]  | p[72]  | p[71]  | p[68]  | p[62]
               | p[60]  | p[51]  | p[43]  | p[37]  | p[36]  | p[34]  | p[31]  | p[28]  | p[27]  | p[26]
               | p[24]  | p[23]  | p[21]  | p[17]  | p[16]  | p[13]  | p[12]  | p[11]  | p[10]  | p[9]
               | p[8]   | p[6]   | p[5]   | p[4]   | p[2]   | p[1]   | p[0];

assign pl[2]   = p[140] | p[138] | p[137] | p[136] | p[135] | p[134] | p[128] | p[127] | p[126] | p[125]
               | p[124] | p[123] | p[118] | p[117] | p[116] | p[110] | p[109] | p[105] | p[104] | p[103]
               | p[102] | p[101] | p[98]  | p[97]  | p[96]  | p[95]  | p[94]  | p[92]  | p[91]  | p[86]
               | p[83]  | p[82]  | p[81]  | p[80]  | p[74]  | p[72]  | p[71]  | p[69]  | p[68]  | p[67]
               | p[66]  | p[63]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]
               | p[53]  | p[51]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]  | p[41]
               | p[40]  | p[39]  | p[37]  | p[36]  | p[35]  | p[34]  | p[31]  | p[30]  | p[24]  | p[23]
               | p[21]  | p[19]  | p[18]  | p[17]  | p[16]  | p[15]  | p[13]  | p[12]  | p[11]  | p[10]
               | p[9]   | p[7]   | p[6]   | p[5]   | p[2]   | p[1]   | p[0];

assign pl[3]   = p[140] | p[138] | p[135] | p[134] | p[133] | p[132] | p[131] | p[128] | p[126] | p[125]
               | p[123] | p[121] | p[119] | p[118] | p[116] | p[115] | p[114] | p[112] | p[110] | p[106]
               | p[103] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[95]  | p[94]  | p[92]  | p[90]
               | p[85]  | p[83]  | p[82]  | p[81]  | p[80]  | p[79]  | p[74]  | p[72]  | p[71]  | p[68]
               | p[67]  | p[66]  | p[63]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
               | p[54]  | p[53]  | p[51]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]
               | p[42]  | p[41]  | p[40]  | p[39]  | p[37]  | p[36]  | p[35]  | p[33]  | p[31]  | p[30]
               | p[27]  | p[23]  | p[22]  | p[17]  | p[16]  | p[15]  | p[13]  | p[12]  | p[11]  | p[10]
               | p[9]   | p[7]   | p[6]   | p[5]   | p[2]   | p[1]   | p[0];

assign pl[4]   = p[139] | p[136] | p[134] | p[129] | p[128] | p[127] | p[123] | p[122] | p[120] | p[118]
               | p[115] | p[114] | p[112] | p[111] | p[107] | p[106] | p[105] | p[101] | p[99]  | p[98]
               | p[95]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[87]  | p[86]  | p[85]  | p[84]
               | p[83]  | p[81]  | p[80]  | p[74]  | p[69]  | p[68]  | p[65]  | p[62]  | p[60]  | p[51]
               | p[43]  | p[42]  | p[37]  | p[36]  | p[33]  | p[31]  | p[28]  | p[26]  | p[24]  | p[22]
               | p[21]  | p[18]  | p[15]  | p[11]  | p[9]   | p[7]   | p[6]   | p[3]   | p[1]   | p[0];

assign pl[5]   = p[140] | p[138] | p[135] | p[134] | p[129] | p[128] | p[124] | p[123] | p[122] | p[121]
               | p[120] | p[119] | p[118] | p[117] | p[112] | p[111] | p[110] | p[107] | p[106] | p[105]
               | p[104] | p[102] | p[101] | p[100] | p[99]  | p[98]  | p[97]  | p[96]  | p[94]  | p[93]
               | p[92]  | p[91]  | p[90]  | p[89]  | p[87]  | p[86]  | p[85]  | p[84]  | p[82]  | p[81]
               | p[80]  | p[79]  | p[74]  | p[72]  | p[71]  | p[68]  | p[63]  | p[61]  | p[60]  | p[59]
               | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[51]  | p[50]  | p[49]  | p[48]
               | p[47]  | p[45]  | p[44]  | p[43]  | p[41]  | p[40]  | p[39]  | p[37]  | p[36]  | p[35]
               | p[31]  | p[30]  | p[29]  | p[26]  | p[25]  | p[23]  | p[22]  | p[19]  | p[14]  | p[12]
               | p[11]  | p[10]  | p[8]   | p[6]   | p[5]   | p[3]   | p[2]   | p[1]   | p[0];

assign pl[6]   = p[134] | p[129] | p[128] | p[122] | p[118] | p[113] | p[103] | p[100] | p[99]  | p[92]
               | p[74]  | p[68]  | p[63]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
               | p[54]  | p[53]  | p[51]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]
               | p[41]  | p[40]  | p[39]  | p[37]  | p[36]  | p[35]  | p[31]  | p[30]  | p[29]  | p[26]
               | p[22]  | p[19]  | p[17]  | p[16]  | p[13]  | p[11]  | p[0];

assign pl[7]   = p[134] | p[129] | p[128] | p[122] | p[118] | p[113] | p[103] | p[100] | p[99]  | p[92]
               | p[74]  | p[68]  | p[63]  | p[61]  | p[60]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]
               | p[54]  | p[53]  | p[51]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]
               | p[41]  | p[40]  | p[39]  | p[37]  | p[36]  | p[35]  | p[31]  | p[30]  | p[29]  | p[26]
               | p[22]  | p[19]  | p[17]  | p[16]  | p[13]  | p[11]  | p[0];

assign pl[8]   = p[140] | p[138] | p[134] | p[133] | p[132] | p[129] | p[128] | p[123] | p[122] | p[121]
               | p[120] | p[114] | p[112] | p[111] | p[106] | p[104] | p[102] | p[101] | p[100] | p[99]
               | p[98]  | p[93]  | p[92]  | p[89]  | p[86]  | p[85]  | p[84]  | p[83]  | p[81]  | p[73]
               | p[70]  | p[69]  | p[68]  | p[65]  | p[64]  | p[58]  | p[57]  | p[44]  | p[43]  | p[41]
               | p[40]  | p[34]  | p[33]  | p[28]  | p[27]  | p[26]  | p[25]  | p[14]  | p[8]   | p[7];

assign pl[9]   = p[139] | p[135] | p[126] | p[125] | p[122] | p[117] | p[115] | p[110] | p[109] | p[96]
               | p[95]  | p[94]  | p[91]  | p[90]  | p[82]  | p[80]  | p[79]  | p[74]  | p[72]  | p[71]
               | p[67]  | p[66]  | p[59]  | p[54]  | p[52]  | p[50]  | p[46]  | p[42]  | p[32]  | p[28]
               | p[27]  | p[23]  | p[21]  | p[18]  | p[15]  | p[12]  | p[11]  | p[10]  | p[9]   | p[6]
               | p[5]   | p[3]   | p[2]   | p[1];

assign pl[10]  = p[139] | p[133] | p[129] | p[126] | p[123] | p[122] | p[112] | p[111] | p[110] | p[106]
               | p[96]  | p[95]  | p[92]  | p[91]  | p[90]  | p[89]  | p[73]  | p[69]  | p[65]  | p[59]
               | p[58]  | p[55]  | p[53]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[42]
               | p[38]  | p[34]  | p[33]  | p[31]  | p[30]  | p[28]  | p[27]  | p[26]  | p[24]  | p[22]
               | p[20]  | p[9]   | p[7];

assign pl[11]  = p[139] | p[135] | p[128] | p[126] | p[125] | p[122] | p[117] | p[115] | p[110] | p[109]
               | p[96]  | p[95]  | p[94]  | p[93]  | p[91]  | p[90]  | p[82]  | p[80]  | p[79]  | p[74]
               | p[72]  | p[71]  | p[67]  | p[66]  | p[52]  | p[49]  | p[47]  | p[46]  | p[42]  | p[41]
               | p[36]  | p[32]  | p[28]  | p[27]  | p[23]  | p[21]  | p[18]  | p[17]  | p[15]  | p[12]
               | p[11]  | p[10]  | p[9]   | p[6]   | p[5]   | p[3]   | p[2]   | p[1];

assign pl[12]  = p[139] | p[137] | p[136] | p[133] | p[129] | p[127] | p[126] | p[124] | p[123] | p[117]
               | p[115] | p[112] | p[111] | p[110] | p[109] | p[103] | p[95]  | p[93]  | p[91]  | p[90]
               | p[81]  | p[79]  | p[69]  | p[65]  | p[63]  | p[61]  | p[58]  | p[56]  | p[54]  | p[53]
               | p[44]  | p[41]  | p[40]  | p[39]  | p[37]  | p[36]  | p[35]  | p[26]  | p[25]  | p[24]
               | p[22]  | p[21]  | p[20]  | p[18]  | p[17]  | p[16]  | p[15]  | p[14]  | p[13]  | p[9]
               | p[8]   | p[7];

assign pl[13]  = p[135] | p[134] | p[133] | p[129] | p[94]  | p[91]  | p[90]  | p[87]  | p[82]  | p[80]
               | p[74]  | p[72]  | p[71]  | p[69]  | p[68]  | p[62]  | p[61]  | p[59]  | p[58]  | p[57]
               | p[49]  | p[48]  | p[43]  | p[42]  | p[40]  | p[39]  | p[35]  | p[34]  | p[33]  | p[30]
               | p[28]  | p[27]  | p[26]  | p[24]  | p[23]  | p[22]  | p[14]  | p[12]  | p[11]  | p[10]
               | p[6]   | p[5]   | p[3]   | p[2]   | p[1];

assign pl[14]  = p[140] | p[137] | p[136] | p[134] | p[133] | p[132] | p[131] | p[129] | p[128] | p[127]
               | p[124] | p[121] | p[119] | p[117] | p[115] | p[113] | p[109] | p[105] | p[103] | p[102]
               | p[101] | p[98]  | p[97]  | p[96]  | p[95]  | p[93]  | p[87]  | p[86]  | p[85]  | p[84]
               | p[81]  | p[79]  | p[69]  | p[68]  | p[65]  | p[63]  | p[62]  | p[61]  | p[58]  | p[51]
               | p[42]  | p[41]  | p[40]  | p[39]  | p[37]  | p[36]  | p[35]  | p[34]  | p[26]  | p[24]
               | p[22]  | p[21]  | p[18]  | p[17]  | p[16]  | p[15]  | p[13]  | p[9]   | p[4];

assign pl[15]  = p[139] | p[138] | p[135] | p[134] | p[133] | p[129] | p[128] | p[126] | p[125] | p[123]
               | p[122] | p[121] | p[120] | p[117] | p[116] | p[115] | p[114] | p[113] | p[110] | p[109]
               | p[107] | p[104] | p[100] | p[99]  | p[96]  | p[95]  | p[94]  | p[93]  | p[92]  | p[91]
               | p[90]  | p[89]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[82]  | p[81]  | p[80]
               | p[79]  | p[74]  | p[73]  | p[72]  | p[71]  | p[69]  | p[68]  | p[67]  | p[66]  | p[65]
               | p[63]  | p[62]  | p[61]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]
               | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]  | p[40]
               | p[39]  | p[35]  | p[34]  | p[33]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]
               | p[24]  | p[23]  | p[22]  | p[21]  | p[19]  | p[18]  | p[17]  | p[15]  | p[14]  | p[12]
               | p[11]  | p[10]  | p[9]   | p[6]   | p[5]   | p[3]   | p[2]   | p[1];

assign pl[16]  = p[140] | p[138] | p[134] | p[133] | p[132] | p[129] | p[128] | p[123] | p[122] | p[120]
               | p[116] | p[114] | p[111] | p[107] | p[104] | p[102] | p[101] | p[100] | p[99]  | p[98]
               | p[92]  | p[87]  | p[84]  | p[83]  | p[73]  | p[69]  | p[68]  | p[63]  | p[62]  | p[61]
               | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[51]  | p[50]  | p[49]
               | p[48]  | p[47]  | p[45]  | p[44]  | p[43]  | p[41]  | p[40]  | p[39]  | p[37]  | p[36]
               | p[35]  | p[34]  | p[33]  | p[31]  | p[30]  | p[29]  | p[28]  | p[27]  | p[26]  | p[25]
               | p[19]  | p[7];

assign pl[17]  = p[140] | p[132] | p[122] | p[121] | p[117] | p[115] | p[109] | p[102] | p[101] | p[98]
               | p[96]  | p[95]  | p[89]  | p[87]  | p[86]  | p[85]  | p[84]  | p[81]  | p[79]  | p[65]
               | p[63]  | p[58]  | p[57]  | p[51]  | p[50]  | p[47]  | p[44]  | p[43]  | p[40]  | p[39]
               | p[31]  | p[24]  | p[22]  | p[21]  | p[18]  | p[17]  | p[15]  | p[14]  | p[9];

assign pl[18]  = p[134] | p[133] | p[129] | p[128] | p[122] | p[121] | p[113] | p[105] | p[96]  | p[93]
               | p[92]  | p[87]  | p[86]  | p[85]  | p[84]  | p[81]  | p[79]  | p[73]  | p[69]  | p[68]
               | p[65]  | p[63]  | p[62]  | p[61]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]
               | p[53]  | p[50]  | p[49]  | p[48]  | p[47]  | p[45]  | p[44]  | p[43]  | p[42]  | p[41]
               | p[40]  | p[39]  | p[37]  | p[36]  | p[35]  | p[34]  | p[33]  | p[31]  | p[30]  | p[28]
               | p[27]  | p[26]  | p[24]  | p[22];

assign pl[19]  = p[121] | p[113] | p[96]  | p[92]  | p[86]  | p[85]  | p[84]  | p[81]  | p[79]  | p[73]
               | p[65]  | p[63]  | p[59]  | p[58]  | p[56]  | p[55]  | p[54]  | p[53]  | p[49]  | p[48]
               | p[45]  | p[43]  | p[42]  | p[40]  | p[33]  | p[30]  | p[28]  | p[27]  | p[24]  | p[22]
               | p[14];

assign pl[20]  = p[139] | p[133] | p[123] | p[121] | p[113] | p[110] | p[96]  | p[91]  | p[90]  | p[89]
               | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[61]  | p[57]  | p[55]  | p[53]  | p[25]
               | p[14];

assign pl[21]  = p[128] | p[121] | p[96]  | p[93]  | p[86]  | p[85]  | p[81]  | p[79]  | p[65]  | p[59]
               | p[57]  | p[49]  | p[48]  | p[42]  | p[41]  | p[36]  | p[33]  | p[30]  | p[28]  | p[27];

assign pl[22]  = p[135] | p[125] | p[110] | p[94]  | p[91]  | p[82]  | p[74]  | p[72]  | p[71]  | p[63]
               | p[61]  | p[59]  | p[58]  | p[57]  | p[56]  | p[55]  | p[54]  | p[53]  | p[50]  | p[49]
               | p[48]  | p[47]  | p[45]  | p[44]  | p[41]  | p[40]  | p[39]  | p[37]  | p[36]  | p[35]
               | p[31]  | p[30]  | p[23]  | p[12]  | p[10]  | p[6]   | p[5]   | p[2]   | p[1];

assign pl[23]  = p[135] | p[126] | p[125] | p[110] | p[94]  | p[91]  | p[90]  | p[82]  | p[80]  | p[74]
               | p[72]  | p[71]  | p[63]  | p[61]  | p[58]  | p[57]  | p[48]  | p[47]  | p[39]  | p[37]
               | p[35]  | p[23]  | p[12]  | p[11]  | p[5]   | p[3];

assign pl[24]  = p[139] | p[135] | p[128] | p[126] | p[110] | p[94]  | p[93]  | p[90]  | p[80]  | p[72]
               | p[71]  | p[67]  | p[66]  | p[59]  | p[56]  | p[54]  | p[48]  | p[42]  | p[41]  | p[33]
               | p[28]  | p[27]  | p[12];

assign pl[25]  = p[126] | p[125] | p[121] | p[113] | p[110] | p[96]  | p[90]  | p[86]  | p[85]  | p[82]
               | p[81]  | p[79]  | p[72]  | p[71]  | p[65]  | p[59]  | p[56]  | p[54]  | p[48]  | p[43]
               | p[42]  | p[40]  | p[33]  | p[28]  | p[27]  | p[24]  | p[23]  | p[22]  | p[14]  | p[1];

assign pl[26]  = p[139] | p[126] | p[121] | p[113] | p[110] | p[96]  | p[94]  | p[90]  | p[86]  | p[85]
               | p[82]  | p[81]  | p[79]  | p[74]  | p[72]  | p[67]  | p[66]  | p[65]  | p[36]  | p[12]
               | p[5]   | p[3]   | p[1];

assign pl[27]  = p[139] | p[138] | p[137] | p[134] | p[131] | p[128] | p[125] | p[121] | p[119] | p[116]
               | p[115] | p[114] | p[109] | p[107] | p[104] | p[102] | p[101] | p[98]  | p[95]  | p[93]
               | p[92]  | p[91]  | p[90]  | p[89]  | p[87]  | p[86]  | p[85]  | p[84]  | p[83]  | p[79]
               | p[73]  | p[68]  | p[67]  | p[66]  | p[62]  | p[43]  | p[34]  | p[27]  | p[21]  | p[15]
               | p[11]  | p[10]  | p[9]   | p[6]   | p[4]   | p[2]   | p[1];

assign pl[28]  = p[140] | p[139] | p[138] | p[137] | p[133] | p[132] | p[127] | p[125] | p[122] | p[121]
               | p[120] | p[116] | p[107] | p[103] | p[98]  | p[93]  | p[92]  | p[91]  | p[87]  | p[86]
               | p[85]  | p[84]  | p[83]  | p[74]  | p[73]  | p[67]  | p[66]  | p[65]  | p[62]  | p[60]
               | p[42]  | p[33]  | p[28]  | p[18]  | p[17]  | p[16]  | p[11]  | p[10]  | p[6]   | p[4]
               | p[2]   | p[1];

assign pl[29]  = p[139] | p[138] | p[137] | p[133] | p[132] | p[131] | p[127] | p[122] | p[121] | p[119]
               | p[115] | p[109] | p[103] | p[97]  | p[96]  | p[93]  | p[92]  | p[90]  | p[86]  | p[85]
               | p[83]  | p[81]  | p[80]  | p[79]  | p[73]  | p[67]  | p[66]  | p[65]  | p[62]  | p[42]
               | p[33]  | p[29]  | p[28]  | p[27]  | p[18]  | p[17]  | p[16]  | p[15]  | p[11]  | p[10]
               | p[6]   | p[3]   | p[2]   | p[1];

endmodule

//______________________________________________________________________________
//
// Instruction decoder matrix
//
module t11_pid
(
   input  [15:0] ir,
   output [17:0] id
);

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

assign id[0]   = cmp(ir, 16'bxxxx000xxxxxxxxx);
assign id[1]   = cmp(ir, 16'bxxxx000xxxxxxxxx);
assign id[2]   = cmp(ir, 16'bx10xxxxxxxxxxxxx);
assign id[3]   = cmp(ir, 16'bx000101xxxxxxxxx);
assign id[4]   = cmp(ir, 16'bx0001100xxxxxxxx);
assign id[5]   = cmp(ir, 16'b0111100xxxxxxxxx);    // xor
assign id[6]   = cmp(ir, 16'bx0x1xxxxxxxxxxxx);
assign id[7]   = cmp(ir, 16'bxx10xxxxxxxxxxxx);
assign id[8]   = cmp(ir, 16'b0000100xxxxxxxxx);    // jsr
assign id[9]   = cmp(ir, 16'b0000000001xxxxxx);    // jmp
assign id[10]  = cmp(ir, 16'b1000110100xxxxxx);
assign id[11]  = cmp(ir, 16'bx000110111xxxxxx);    // sxt
assign id[12]  = cmp(ir, 16'b0000000011xxxxxx);    // swab
assign id[13]  = cmp(ir, 16'b00000000xxxxxxxx);
assign id[14]  = cmp(ir, 16'b0000000000000001);    // wait
assign id[15]  = cmp(ir, 16'b0000000010xxxxxx);
assign id[16]  = cmp(ir, 16'b00000000x0xxxxxx);
assign id[17]  = cmp(ir, 16'bxxxxxxxxxx000xxx);

endmodule

//______________________________________________________________________________
//
// I/O operations decoder
//
module t11_pio
(
   input  [6:0] op,
   output [14:0] iop
);

function cmp
(
   input [6:0] ai,
   input [6:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign iop[0]  = cmp(op, 7'bx110xx1);
assign iop[1]  = cmp(op, 7'bx010xx1);
assign iop[2]  = cmp(op, 7'b110100x);  // aspi transaction
assign iop[3]  = cmp(op, 7'b01x1010);  // iako transaction
assign iop[4]  = cmp(op, 7'bxx0xxx1);
assign iop[5]  = cmp(op, 7'b010x00x);
assign iop[6]  = cmp(op, 7'b1110001);
assign iop[7]  = cmp(op, 7'b11100x1);
assign iop[8]  = cmp(op, 7'b1110111);
assign iop[9]  = cmp(op, 7'bx1011xx);
assign iop[10] = cmp(op, 7'bx100xxx);
assign iop[11] = cmp(op, 7'b1111100);
assign iop[12] = cmp(op, 7'b1111000);
assign iop[13] = cmp(op, 7'bx111xx1);
assign iop[14] = cmp(op, 7'b0111100);

endmodule
