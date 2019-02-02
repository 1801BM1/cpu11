//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// 1801VM1 programmable logic matrices (PLM)
//______________________________________________________________________________
//
// Main matrix inputs format:
//
//    ir[15:0] - instruction code latched in instrustion register (opcode)
//    mr[14:0] - microinstruction state word also latched
//       mr[6:0] - address/state field, controlled by PLM outputs
//          sp[0]  -> mr[6]
//          sp[5]  -> mr[5]
//          sp[9]  -> mr[4]
//          sp[15] -> mr[3]
//          sp[19] -> mr[2]
//          sp[24] -> mr[1]
//          spl29] -> mr[0] + reset
//
//       mr[7]  - psw[0] - C (carry) flag or condition
//       mr[8]  - psw[1] - V (overflow) flag or condition)
//       mr[9]  - psw[2] - Z (zero) flag or condition
//       mr[10] - psw[3] - N (negative) flag or condition
//       mr[11] - psw[4] - T (trap) flag
//
//    mr[14:12] - multiplexed
//       priority encoder branch:
//          mr[12]   -  sp[9] priority encoder
//          mr[13]   - ~sp[7] priority encoder
//          mr[14]   - ~sp[5] priority encoder
//       feedback from main matrix
//          mr[12]   - ~plr17
//          mr[13]   -  plr16
//          mr[14]   - ~plr14
//
// Main matrix outputs format (after SOP inversion):
//    plx[0]   ~mj[6]   - next microcode address
//    plx[5]    mj[5]
//    plx[9]    mj[4]
//    plx[15]   mj[3]
//    plx[19]  ~mj[2]
//    plx[24]  ~mj[1]
//    plx[29]  ~mj[0]
//
//    plx[1]   IR register operation
//    plx[2]
//    plx[3]         irq_check  wait_IR  start_IR  Note
//                000   no       no       no       no operation
//                001   no       yes      no       RTT opcode, wait fetch completion
//                010   no       no       no       non-IR data retrieving
//                011   yes      yes      yes      usual IR fetch
//                100   no       no       yes      early IR prefetch
//                101   yes      no       no       WAIT opcode, check irq only
//                110   no       no       no       no operation
//                111   yes      yes      no       ~RTT opcode, wait fetch completion
//
//    plx[6]   QBUS operation type: byte operation flag
//    plx[7]   QBUS operation type: write flag
//    plx[8]   QBUS operation type: read flag
//                00x - nothing
//                010 - write word
//                011 - write byte
//                100 - read word
//                101 - read byte
//                110 - read-modify-write word
//                111 - read-modify-write byte
//
//    plx[10]  not to wait data from Q-bus
//    plx[12]  opcode is not recognized
//    plx[11]  Y bus operand type selector
//    plx[13]  Y bus operand type selector/ALU operation
//    plx[14]  Y bus operand type selector/ALU operation
//    plx[16]  ALU opcode
//    plx[17]  ALU opcode
//    plx[18]  word operation (0 - byte operation)
//    plx[20]  write ALU result flag to register
//    plx[4]   PSW and microcode control (plop)
//    plx[21]
//    plx[22]
//    plx[23]  no wait areg free or write completion
//    plx[25]
//    plx[26]
//    plx[27]  if (~plr[11] & ~plr[13]):
//    plx[28]
//                0000     - Q         1111  - R0
//                0001     - R7        0111  - R1
//                0010     - R11       1011  - R2
//                0011     - R3        0011  - R3
//                0100     - R13       1101  - R4
//                0101     - R5        0101  - R5
//                0110     - R9        1001  - R6
//                0111     - R1        0001  - R7
//                1000     - PSW       1110  - R8
//                1001     - R6        0110  - R9
//                1010     - R10       1010  - R10
//                1011     - R2        0010  - R11
//                1100     - R12       1100  - R12
//                1101     - R4        0100  - R13
//                1110     - R8        1000  - PSW
//                1111     - R0        0000  - Q
//
//    plx[30]  X selector, inverted and bit order reversed
//    plx[31]
//    plx[32]     0000     - Q         1111  - R0
//    plx[33]     0001     - R7        0111  - R1
//                0010     - R11       1011  - R2
//                0011     - R3        0011  - R3
//                0100     - R13       1101  - R4
//                0101     - R5        0101  - R5
//                0110     - R9        1001  - R6
//                0111     - R1        0001  - R7
//                1000     - PSW       1110  - R8
//                1001     - R6        0110  - R9
//                1010     - R10       1010  - R10
//                1011     - R2        0010  - R11
//                1100     - R12       1100  - R12
//                1101     - R4        0100  - R13
//                1110     - R8        1000  - PSW
//                1111     - R0        0000  - Q
//
//    Instruction decoding phase - (plm[11] & plm[13])
//       plx[7]   - 0 - set wait mode
//       plx[10]  - 0 - assert INIT
//       plx[12]  - 1 - invalid opcode
//       plx[14]  - inverted mj[14] input
//       plx[16]  - direct   mj[13] input
//       plx[17]  - inverted mj[12] input
//       plx[18]  - vector selector
//       plx[20]  - vector selector
//       plx[21]  - vector selector
//       plx[22]  - vector selector
//       plx[23]  - 0 - deassert INIT
//       plx[25]  - 0 - set stop mode
//       plx[26]  - 0 - set error 2
//       plx[27]  - 0 - reset wait mode/ack interrupt
//       plx[28]  - 0 - set error 3
//       plx[30]  - 0 - set error 7
//
module vm1a_plm
(
   input  [15:0]  ir,
   input  [14:0]  mr,
   output [33:0]  sp
);
wire [249:2] p;
wire [33:0] pl;

function cmp
(
   input [30:0] ai,
   input [30:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[2]   = cmp({ir, mr}, {16'bxxxxxxx111xxxxxx, 15'bxxxxxxxx01xx111});
assign p[3]   = cmp({ir, mr}, {16'bx00xxxxxxx00xxxx, 15'b100xxxxx01x1010});
assign p[4]   = cmp({ir, mr}, {16'bx00xxxxxxx0x0xxx, 15'b100xxxxx011101x});
assign p[5]   = cmp({ir, mr}, {16'bxxxxxxxxxxxxx111, 15'bxxxxxxxx100x111});
assign p[6]   = cmp({ir, mr}, {16'b0xxxx101xxxxxxxx, 15'bxxxx1x1x000010x});
assign p[7]   = cmp({ir, mr}, {16'bxxxxxx1xxxxxxxxx, 15'bxxxxx1xx1001x0x});
assign p[8]   = cmp({ir, mr}, {16'bx00xxxxxxxxx0xxx, 15'b100xxxxx011x011});
assign p[9]   = cmp({ir, mr}, {16'bx000101111xxxxxx, 15'b001xxxxxx111110});
assign p[10]  = cmp({ir, mr}, {16'b0xxxx1x1xxxxxxxx, 15'bxxxx000x000010x});
assign p[11]  = cmp({ir, mr}, {16'bxxxxx00111000xxx, 15'b001xxxxx11111x0});
assign p[12]  = cmp({ir, mr}, {16'bx111xxxxxxxxxxxx, 15'b0xxxxxxx01x011x});
assign p[13]  = cmp({ir, mr}, {16'bxxxxx1x01xxxxxxx, 15'b1xxxxxxx011x11x});
assign p[14]  = cmp({ir, mr}, {16'bx00xxxxxxxxxxxxx, 15'b100xxxxx0110010});
assign p[15]  = cmp({ir, mr}, {16'bxxxxx000xxxxxxxx, 15'bxxxx1xxx0000100});
assign p[16]  = cmp({ir, mr}, {16'bxxxxxxxxxx000111, 15'b001xxxxxx111110});
assign p[17]  = cmp({ir, mr}, {16'b1xxxx001xxxxxxxx, 15'bxxxx0xxx00x010x});
assign p[18]  = cmp({ir, mr}, {16'bx00xxxxxxxx00xxx, 15'b100xxxxx0111010});
assign p[19]  = cmp({ir, mr}, {16'bxxxxxxxxxxxx0xxx, 15'bxxx1xxxx1010x0x});
assign p[20]  = cmp({ir, mr}, {16'b0000000001000xxx, 15'b00xxxxxx11111x0});
assign p[21]  = cmp({ir, mr}, {16'b1xxxxx011xxxxxxx, 15'bxxxxxxxx0111000});
assign p[22]  = cmp({ir, mr}, {16'b0000100xxx000xxx, 15'b00xxxxxx11111x0});
assign p[23]  = cmp({ir, mr}, {16'bxxxxxxxx1xx0xxxx, 15'bxxxxxxxx1001001});
assign p[24]  = cmp({ir, mr}, {16'b10001000xxxxxxxx, 15'b00xxxxxxx111110});
assign p[25]  = cmp({ir, mr}, {16'b1xxxxxxxxxxxxxxx, 15'bxxxx0xxx01x1110});
assign p[26]  = cmp({ir, mr}, {16'b1xxxxxxxxxxx011x, 15'bxx1xxxxx01x1010});
assign p[27]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b11xxxxxx0110111});
assign p[28]  = cmp({ir, mr}, {16'b1000100xxxxxxxxx, 15'b001xxxxxx111110});
assign p[29]  = cmp({ir, mr}, {16'b0xxx0111xxxxxxxx, 15'bxxxx101x00x010x});
assign p[30]  = cmp({ir, mr}, {16'b0xxxx011xxxxxxxx, 15'bxxxxx0xx00x010x});
assign p[31]  = cmp({ir, mr}, {16'bx001xxxxxx00xxxx, 15'bxxxxxxxx0111x10});
assign p[32]  = cmp({ir, mr}, {16'b1xxxx011xxxxxxxx, 15'bxxxxx0x000x010x});
assign p[33]  = cmp({ir, mr}, {16'bx000xxxxxxxx0xxx, 15'bx01xxxxx0110011});
assign p[34]  = cmp({ir, mr}, {16'bxxxxxxxxxx000xxx, 15'bxxxxxxxx1111011});
assign p[35]  = cmp({ir, mr}, {16'bx000xx1010xxxxxx, 15'b1xxxxxxx011x11x});
assign p[36]  = cmp({ir, mr}, {16'b0000000000000101, 15'b001xxxxx11111x0});
assign p[37]  = cmp({ir, mr}, {16'b0xxxx1x0xxxxxxxx, 15'bxxxx0x1x00x010x});
assign p[38]  = cmp({ir, mr}, {16'bx001xxxxxx0x0xxx, 15'bxxxxxxxx0111x10});
assign p[39]  = cmp({ir, mr}, {16'bx100xxxxxxxxxxxx, 15'b0xxxxxxx01x011x});
assign p[40]  = cmp({ir, mr}, {16'b1xxxx101xxxxxxxx, 15'bxxxxxx0x00x010x});
assign p[41]  = cmp({ir, mr}, {16'b0xxxx101xxxxxxxx, 15'bxxxx0x0x000010x});
assign p[42]  = cmp({ir, mr}, {16'bx010xxxxxxxxxxxx, 15'b0xxxxxxx01x011x});
assign p[43]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxx111, 15'bxxxxxxxx01xx11x});
assign p[44]  = cmp({ir, mr}, {16'b1xxxx100xxxxxxxx, 15'bxxxxxx1x00x010x});
assign p[45]  = cmp({ir, mr}, {16'b1xxxx111xxxxxxxx, 15'bxxxxxxx000x010x});
assign p[46]  = cmp({ir, mr}, {16'bx001xxxxxxx00xxx, 15'bxxxxxxxx0111x10});
assign p[47]  = cmp({ir, mr}, {16'b1xxxxx10xxxxxxxx, 15'bxxxxxxx100x010x});
assign p[48]  = cmp({ir, mr}, {16'b0000x1x111xxxxxx, 15'b1xxx1xxx011x11x});
assign p[49]  = cmp({ir, mr}, {16'b0xxxx1x0xxxxxxxx, 15'bxxxx1x0x00x010x});
assign p[50]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxx1, 15'bxxxxxxxx000101x});
assign p[51]  = cmp({ir, mr}, {16'bx0000xxx1xxxxxxx, 15'b111xxxxx0110111});
assign p[52]  = cmp({ir, mr}, {16'b0xxxx110xxxxxxxx, 15'bxxxxx1xx00x010x});
assign p[53]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0100110});
assign p[54]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxx1xxxxx0110x11});
assign p[55]  = cmp({ir, mr}, {16'bxxxxx010xxxxxxxx, 15'bxxxxx1xx00x010x});
assign p[56]  = cmp({ir, mr}, {16'b10001101xx000xxx, 15'b001xxxxxx111110});
assign p[57]  = cmp({ir, mr}, {16'b101xxxxxxxxxxxxx, 15'bxxxxxxxxx1x011x});
assign p[58]  = cmp({ir, mr}, {16'bx000xxxxxxxxxxxx, 15'b000xxxxx011x01x});
assign p[59]  = cmp({ir, mr}, {16'bx000xx1101xxxxxx, 15'b1xxxxxxx011011x});
assign p[60]  = cmp({ir, mr}, {16'bx000x1x0x1xxxxxx, 15'b1xxxxxxx011011x});
assign p[61]  = cmp({ir, mr}, {16'bx0000xxxxxxxxxxx, 15'b100xxxxx0110111});
assign p[62]  = cmp({ir, mr}, {16'b0110xxxxxxxxxxxx, 15'b0xxxxxxx01x011x});
assign p[63]  = cmp({ir, mr}, {16'bx001xxxxxxxx0xxx, 15'bxxxxxxxx0110011});
assign p[64]  = cmp({ir, mr}, {16'b1x00x1x111xxxxxx, 15'b1x1xxxxx0110111});
assign p[65]  = cmp({ir, mr}, {16'bx000101xxx000xxx, 15'b001xxxxx11111x0});
assign p[66]  = cmp({ir, mr}, {16'bxxxxxxxx10xxxxxx, 15'bxxxxxxxxx101111});
assign p[67]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b000xxxxx11111x0});
assign p[68]  = cmp({ir, mr}, {16'bx000xxxxxxxxxxxx, 15'bx01xxxxx011x010});
assign p[69]  = cmp({ir, mr}, {16'bxxxx0xxx0xxxxxx1, 15'b1xxxx1xx10x1001});
assign p[70]  = cmp({ir, mr}, {16'b1000x1x1x0xxxxxx, 15'b1x1xxxxx0110111});
assign p[71]  = cmp({ir, mr}, {16'bx001xxxxxxxxxxxx, 15'bxxxxxxxx0110010});
assign p[72]  = cmp({ir, mr}, {16'bxxxxxxx11xxxxxxx, 15'bxxxxxxxxx101111});
assign p[73]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxx1xx, 15'bxxxxxxxx0xx0x1x});
assign p[74]  = cmp({ir, mr}, {16'bx0001100xx000xxx, 15'b001xxxxx11111x0});
assign p[75]  = cmp({ir, mr}, {16'b0111111xxxxxxxxx, 15'b001xxxxx11111x0});
assign p[76]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b0xxxxxxx1110101});
assign p[77]  = cmp({ir, mr}, {16'bx00xxxxxxxxxxxxx, 15'b0xxxxxxx0110111});
assign p[78]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxx1x, 15'bxxxxxxxx0000x1x});
assign p[79]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1110000});
assign p[80]  = cmp({ir, mr}, {16'bxxxx0xxx10xxxxxx, 15'bxxxxxxxx1001000});
assign p[81]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxx1, 15'bxxxxxxxx0x01110});
assign p[82]  = cmp({ir, mr}, {16'b000000001x000xxx, 15'b001xxxxxx111110});
assign p[83]  = cmp({ir, mr}, {16'bxxxx000xxxxxxxxx, 15'bxxxxxxxx0111000});
assign p[84]  = cmp({ir, mr}, {16'b0xxxxxxxxxxxxxxx, 15'bxxxxxxxx01x1110});
assign p[85]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxx1xx, 15'bxxxxxxxx0x1xx1x});
assign p[86]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1100110});
assign p[87]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxx1x, 15'bxxxxxxxx0x01110});
assign p[88]  = cmp({ir, mr}, {16'b1xxxxxxxxxxxxxxx, 15'bxxxxxxxx1001x00});
assign p[89]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxx1, 15'bxxxxxxxx001xx1x});
assign p[90]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxx1xx, 15'bxxxxxxxx000101x});
assign p[91]  = cmp({ir, mr}, {16'b0000000000000000, 15'b001xxxxxx111110});
assign p[92]  = cmp({ir, mr}, {16'bxxxxxxxx1xxxxxxx, 15'bxxxxxxxxxx1100x});
assign p[93]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxx1xx, 15'bxxxxxxxx0001110});
assign p[94]  = cmp({ir, mr}, {16'bxxxxxxxxxxxx1xxx, 15'bxxxxxxxx0010101});
assign p[95]  = cmp({ir, mr}, {16'bxxxxxxx1xxxxxxxx, 15'bxxxxxxxxx1001x1});
assign p[96]  = cmp({ir, mr}, {16'bxxxxxxxx0xxxxxxx, 15'bxxxxxxxxx101111});
assign p[97]  = cmp({ir, mr}, {16'bx10xxxxxxxxxxxxx, 15'bxxxxxxxx011001x});
assign p[98]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxx1x, 15'bxxxxxxxx000101x});
assign p[99]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1100011});
assign p[100] = cmp({ir, mr}, {16'bxxxxxxxxxx1xxxxx, 15'bxxxxxxxxx101010});
assign p[101] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1000010});
assign p[102] = cmp({ir, mr}, {16'bxxxxxxx1xxxxxxxx, 15'bxxxxxxxxxx1100x});
assign p[103] = cmp({ir, mr}, {16'bx000xx1000xxxxxx, 15'b1xxxxxxx011011x});
assign p[104] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bx0xxxxxx1101x11});
assign p[105] = cmp({ir, mr}, {16'bxxxxxxxxxx101xxx, 15'bxxxxxxxx0111x10});
assign p[106] = cmp({ir, mr}, {16'bxxxxxxxxx1xxxxxx, 15'bxxxxxxxxxx1100x});
assign p[107] = cmp({ir, mr}, {16'b0000110111000xxx, 15'b001xxxxxx111110});
assign p[108] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxx1xxxxx1101000});
assign p[109] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b1xxxxxxx1110101});
assign p[110] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0000x01});
assign p[111] = cmp({ir, mr}, {16'bx01xxxxxxxxxxxxx, 15'bxxxxxxxx010011x});
assign p[112] = cmp({ir, mr}, {16'bxxxxxxx1xxxxxxxx, 15'bxxxxxxxxx01010x});
assign p[113] = cmp({ir, mr}, {16'bxxxxxxxx1xxxxxxx, 15'bxxxxxxxxx1001x1});
assign p[114] = cmp({ir, mr}, {16'bx000x1x1x1xxxxxx, 15'bxxxxxxxx011011x});
assign p[115] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxx1, 15'bxxxxxxxx0x00x1x});
assign p[116] = cmp({ir, mr}, {16'bxx00xxxxxxxxxxxx, 15'bx1xxxxxx011001x});
assign p[117] = cmp({ir, mr}, {16'b0xxxxxxxxxxxxxxx, 15'bxxxxxxxx01xx0xx});
assign p[118] = cmp({ir, mr}, {16'b0111100xxx000xxx, 15'b001xxxxxx111110});
assign p[119] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx11x1111});
assign p[120] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxx1x, 15'bxxxxxxxx010xx1x});
assign p[121] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx100111x});
assign p[122] = cmp({ir, mr}, {16'bxxxx0xxxxx0xxxx0, 15'bxxx0xxxx10x1001});
assign p[123] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1010011});
assign p[124] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b10xxxxxxx111110});
assign p[125] = cmp({ir, mr}, {16'b1000000xxxxxxxxx, 15'b001xxxxxx111110});
assign p[126] = cmp({ir, mr}, {16'bxxxxxxxxxxxx1xxx, 15'bxxxxxxxx1010000});
assign p[127] = cmp({ir, mr}, {16'bxxxxxxxxxx011xxx, 15'bxxxxxxxx0111x10});
assign p[128] = cmp({ir, mr}, {16'bx000xxxxxxxxxxxx, 15'bx1xxxxxx0111x10});
assign p[129] = cmp({ir, mr}, {16'bxxxx101xxxxxxxxx, 15'bxxxxxxxx0111000});
assign p[130] = cmp({ir, mr}, {16'b00000001xxxxxxxx, 15'b001xxxxxx111110});
assign p[131] = cmp({ir, mr}, {16'bxxxxxxxxxx11xxxx, 15'bxxxxxxxx0111x10});
assign p[132] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxxx100101});
assign p[133] = cmp({ir, mr}, {16'bxxxx0xxx0xxxx0x1, 15'bxxxxxxxx1001x00});
assign p[134] = cmp({ir, mr}, {16'bx000x00xxxxxxxxx, 15'b1xxxxxxx0110111});
assign p[135] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1101010});
assign p[136] = cmp({ir, mr}, {16'b0001xxxxxxxxxxxx, 15'bxxxxxxxx010011x});
assign p[137] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b01xxxxxxx111110});
assign p[138] = cmp({ir, mr}, {16'bxxxxxxxxx1xxxxxx, 15'bxxxxxxxxx101111});
assign p[139] = cmp({ir, mr}, {16'b0000000000001xxx, 15'b001xxxxxx111110});
assign p[140] = cmp({ir, mr}, {16'bx000xx1111xxxxxx, 15'b1xxxxxxx011011x});
assign p[141] = cmp({ir, mr}, {16'bxxxx0xxx0xxxxxx1, 15'b0xxxx1xx10x1001});
assign p[142] = cmp({ir, mr}, {16'bxxxxxxxxx1xxxxxx, 15'bxxxxxxxxx1001x1});
assign p[143] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1100001});
assign p[144] = cmp({ir, mr}, {16'bx000x1x0xxxxxxxx, 15'b1xxxxxxx011011x});
assign p[145] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1000110});
assign p[146] = cmp({ir, mr}, {16'bx000xx1001xxxxxx, 15'b1xxxxxxx011011x});
assign p[147] = cmp({ir, mr}, {16'b1xxxxxxxxxxxxxxx, 15'bxxxxxxxx01x1110});
assign p[148] = cmp({ir, mr}, {16'bxxxxxxxxxxxx1xxx, 15'bxxxxxxxx0110011});
assign p[149] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bx1xxxxxx1101x11});
assign p[150] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1100010});
assign p[151] = cmp({ir, mr}, {16'bxx1xxxxxxxxxxxxx, 15'bxxxxxxxx011001x});
assign p[152] = cmp({ir, mr}, {16'bx01x000xxx000xxx, 15'b001xxxxxx111110});
assign p[153] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1010010});
assign p[154] = cmp({ir, mr}, {16'bxxxxxxxxxxxx0xxx, 15'bxxxxxxxx00x0101});
assign p[155] = cmp({ir, mr}, {16'bxxxx011xxxxxxxxx, 15'bxxxxxxxx0111000});
assign p[156] = cmp({ir, mr}, {16'bxxxx11xxxxxxxxxx, 15'bxxxxxxxx0111000});
assign p[157] = cmp({ir, mr}, {16'bxxxx10xxxxxxxxxx, 15'bxxxxxxxx100100x});
assign p[158] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx111x100});
assign p[159] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx011111x});
assign p[160] = cmp({ir, mr}, {16'bxxxxxxxxxxxxx0xx, 15'bxxxxxxxx1010101});
assign p[161] = cmp({ir, mr}, {16'bx10xxxxxxxxxxxxx, 15'bxxxxxxxx0111x10});
assign p[162] = cmp({ir, mr}, {16'bxxxxxxx0xxxxxxxx, 15'bxxxxxxxx0010100});
assign p[163] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxx1, 15'bxxxxxxxx01xxx1x});
assign p[164] = cmp({ir, mr}, {16'bxxxxxxxxxxx1xxxx, 15'bxxxxxxxxx101010});
assign p[165] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1100000});
assign p[166] = cmp({ir, mr}, {16'bxx11xxxxxxxxxxxx, 15'bxxxxxxxx01x011x});
assign p[167] = cmp({ir, mr}, {16'bx000xx1110xxxxxx, 15'b1xxxxxxx011011x});
assign p[168] = cmp({ir, mr}, {16'bx10xxxxxxxxxxxxx, 15'b0xxxxxxx01x011x});
assign p[169] = cmp({ir, mr}, {16'b100xxxxxxxxxxxxx, 15'bxxxxxxxx010011x});
assign p[170] = cmp({ir, mr}, {16'b1x0xxxxxxxxxxxxx, 15'bxxxxxxxxx1x011x});
assign p[171] = cmp({ir, mr}, {16'bx000xx101xxxxxxx, 15'b1xxxxxxx011011x});
assign p[172] = cmp({ir, mr}, {16'bxx10xxxxxxxxxxxx, 15'bxxxxxxxx01x011x});
assign p[173] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1000x11});
assign p[174] = cmp({ir, mr}, {16'bxx01000xxx000xxx, 15'b001xxxxxx111110});
assign p[175] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b11xxxxxxx111110});
assign p[176] = cmp({ir, mr}, {16'bxxxxxxxxxxxxx1xx, 15'bxxxxxxxx01xxx1x});
assign p[177] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx11x1100});
assign p[178] = cmp({ir, mr}, {16'bxxxxxx1xxxxxxxxx, 15'bxxxxxxxx101xx00});
assign p[179] = cmp({ir, mr}, {16'bx000xx110xxxxxxx, 15'b1xxxxxxx011011x});
assign p[180] = cmp({ir, mr}, {16'bxx1xxxxxxxxxxxxx, 15'bxxxxxxxx0111x10});
assign p[181] = cmp({ir, mr}, {16'bx1x0000xxx000xxx, 15'b001xxxxx11111x0});
assign p[182] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx110111x});
assign p[183] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b0xxxxxxx0110x11});
assign p[184] = cmp({ir, mr}, {16'bxxxxxx1xxxxxxxxx, 15'bxxxxxxxx0111x01});
assign p[185] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxx0xxxxx1101000});
assign p[186] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx10111x0});
assign p[187] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bx0xxxxxx011x01x});
assign p[188] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1011111});
assign p[189] = cmp({ir, mr}, {16'bx000010xxxxxxxxx, 15'b001xxxxxx111110});
assign p[190] = cmp({ir, mr}, {16'bxxxxxxxx1xxxxxxx, 15'bxxxxxxxx10x100x});
assign p[191] = cmp({ir, mr}, {16'b0000110100xxxxxx, 15'b001xxxxxx111110});
assign p[192] = cmp({ir, mr}, {16'b0xxx000011000xxx, 15'b001xxxxxx111110});
assign p[193] = cmp({ir, mr}, {16'b0000000000000011, 15'b001xxxxxx111110});
assign p[194] = cmp({ir, mr}, {16'b0000000000000100, 15'b001xxxxxx111110});
assign p[195] = cmp({ir, mr}, {16'bxxxxxxx1xxxxxxxx, 15'bxxxxxxxx10x100x});
assign p[196] = cmp({ir, mr}, {16'b00000000101xxxxx, 15'b001xxxxxx111110});
assign p[197] = cmp({ir, mr}, {16'bx0000x1xxxxxxxxx, 15'b001xxxxxx111110});
assign p[198] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxx1x, 15'bxxxxxxxx0x1xx1x});
assign p[199] = cmp({ir, mr}, {16'bxxxx0xxxx00xx0x0, 15'bxxx1xxxx100100x});
assign p[200] = cmp({ir, mr}, {16'b0000000000000x10, 15'b001xxxxxx111110});
assign p[201] = cmp({ir, mr}, {16'b0000000000000001, 15'b001xxxxxx111110});
assign p[202] = cmp({ir, mr}, {16'bxxxx0xxxx00xx1x1, 15'bxxxxxxxx1001000});
assign p[203] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0110001});
assign p[204] = cmp({ir, mr}, {16'b0xxxx10xxxxxxxxx, 15'bxxxxxxxx1001x00});
assign p[205] = cmp({ir, mr}, {16'b0000000001xxxxxx, 15'b001xxxxxx111110});
assign p[206] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx101x100});
assign p[207] = cmp({ir, mr}, {16'bxxxx001xxxxxxxxx, 15'bxxxxxxxx0111000});
assign p[208] = cmp({ir, mr}, {16'bxxxx0xxx0xxxxxx0, 15'bxxx0xxxx1001x00});
assign p[209] = cmp({ir, mr}, {16'bxxxx0xxx00xxx1x1, 15'bxxxxx0xx1001x01});
assign p[210] = cmp({ir, mr}, {16'b1000110100xxxxxx, 15'b001xxxxxx111110});
assign p[211] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1010001});
assign p[212] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx101110x});
assign p[213] = cmp({ir, mr}, {16'b1xxxxxxxxxxxxxxx, 15'bxxxxxxxx10x1001});
assign p[214] = cmp({ir, mr}, {16'bxxxxxxxxxxxxx1xx, 15'bxxxxxxxx1010101});
assign p[215] = cmp({ir, mr}, {16'bxxxx0xxx11xxxxxx, 15'bxxxxxxxx1001x0x});
assign p[216] = cmp({ir, mr}, {16'bxxxx0xxxx00xx1x0, 15'bxxx1xxxx1001000});
assign p[217] = cmp({ir, mr}, {16'b0xxxx1xxxxxxxxxx, 15'bxxxxxxxx10x1001});
assign p[218] = cmp({ir, mr}, {16'bxxxxxxx00xxxx1x0, 15'bxxx1xxxx1001001});
assign p[219] = cmp({ir, mr}, {16'bxxxx0xxxxx1xxxxx, 15'bxxxxxxxx10x1001});
assign p[220] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx100110x});
assign p[221] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0110010});
assign p[222] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1111011});
assign p[223] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxx0xxxxx01xx0xx});
assign p[224] = cmp({ir, mr}, {16'bx000100xxxxxxxxx, 15'b001xxxxx11111x0});
assign p[225] = cmp({ir, mr}, {16'bxxxxxxxxxxxx0xxx, 15'bxxxxxxxx1010x0x});
assign p[226] = cmp({ir, mr}, {16'bxxxxxx0xxxxxxxxx, 15'bxxxxxxxx0111x01});
assign p[227] = cmp({ir, mr}, {16'bxxxxxxxxxx001xxx, 15'bxxxxxxxx0111010});
assign p[228] = cmp({ir, mr}, {16'bxxxxxx1xxxxxxxxx, 15'bxxxxxxxx1001x0x});
assign p[229] = cmp({ir, mr}, {16'bx0001100xxxxxxxx, 15'b001xxxxx11111x0});
assign p[230] = cmp({ir, mr}, {16'bxxxx100xxxxxxxxx, 15'bxxxxxxxx0111000});
assign p[231] = cmp({ir, mr}, {16'bxxxxxx0xxxxxxxxx, 15'bxxxxxxxx1011x00});
assign p[232] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1x01111});
assign p[233] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1x0x1x1});
assign p[234] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0110111});
assign p[235] = cmp({ir, mr}, {16'b0000000011xxxxxx, 15'b001xxxxx11111x0});
assign p[236] = cmp({ir, mr}, {16'bxxxx010xxxxxxxxx, 15'bxxxxxxxx0111000});
assign p[237] = cmp({ir, mr}, {16'bxxxxxxxxxxxx0xxx, 15'bxxxxxxxx0110011});
assign p[238] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx01xx11x});
assign p[239] = cmp({ir, mr}, {16'bxxxxxxxxxx100xxx, 15'bxxxxxxxx0111x10});
assign p[240] = cmp({ir, mr}, {16'bxxxxxxxxxx010xxx, 15'bxxxxxxxx0111x10});
assign p[241] = cmp({ir, mr}, {16'bx10xxxxxxxxxxxxx, 15'b001xxxxx11111x0});
assign p[242] = cmp({ir, mr}, {16'bx000110111xxxxxx, 15'b001xxxxx11111x0});
assign p[243] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0000100});
assign p[244] = cmp({ir, mr}, {16'bx000101xxxxxxxxx, 15'b001xxxxx11111x0});
assign p[245] = cmp({ir, mr}, {16'b0111100xxxxxxxxx, 15'b001xxxxx11111x0});
assign p[246] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1011001});
assign p[247] = cmp({ir, mr}, {16'bx1x0xxxxxxxxxxxx, 15'b001xxxxx11111x0});
assign p[248] = cmp({ir, mr}, {16'bx01xxxxxxxxxxxxx, 15'b001xxxxxx111110});
assign p[249] = cmp({ir, mr}, {16'bxx01xxxxxxxxxxxx, 15'b001xxxxxx111110});

//
// Summ-Of-Products
//
assign sp = ~pl;
assign pl[0]   = p[246] | p[243] | p[236] | p[234] | p[231] | p[230] | p[228] | p[226] | p[225] | p[220]
               | p[219] | p[217] | p[215] | p[213] | p[212] | p[211] | p[209] | p[208] | p[207] | p[206]
               | p[204] | p[203] | p[202] | p[201] | p[200] | p[199] | p[196] | p[195] | p[194] | p[193]
               | p[191] | p[190] | p[188] | p[186] | p[185] | p[182] | p[179] | p[178] | p[177] | p[175]
               | p[173] | p[172] | p[171] | p[168] | p[167] | p[166] | p[165] | p[162] | p[160] | p[159]
               | p[158] | p[157] | p[154] | p[153] | p[150] | p[149] | p[147] | p[146] | p[144] | p[143]
               | p[141] | p[140] | p[139] | p[137] | p[136] | p[133] | p[126] | p[124] | p[123] | p[122]
               | p[119] | p[114] | p[112] | p[109] | p[108] | p[107] | p[104] | p[103] | p[101] | p[99]
               | p[96]  | p[94]  | p[91]  | p[86]  | p[84]  | p[79]  | p[76]  | p[75]  | p[74]  | p[69]
               | p[67]  | p[66]  | p[65]  | p[36]  | p[34]  | p[28]  | p[22]  | p[20];

assign pl[1]   = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[243] | p[242] | p[241] | p[240]
               | p[239] | p[237] | p[236] | p[235] | p[234] | p[232] | p[231] | p[230] | p[229] | p[228]
               | p[227] | p[226] | p[225] | p[224] | p[222] | p[221] | p[220] | p[218] | p[217] | p[216]
               | p[215] | p[214] | p[213] | p[212] | p[211] | p[210] | p[209] | p[207] | p[206] | p[205]
               | p[204] | p[203] | p[202] | p[201] | p[200] | p[199] | p[197] | p[196] | p[195] | p[194]
               | p[193] | p[191] | p[189] | p[188] | p[186] | p[185] | p[184] | p[178] | p[177] | p[175]
               | p[173] | p[169] | p[165] | p[164] | p[162] | p[160] | p[159] | p[158] | p[157] | p[156]
               | p[155] | p[153] | p[150] | p[149] | p[148] | p[145] | p[143] | p[141] | p[139] | p[138]
               | p[137] | p[135] | p[133] | p[132] | p[131] | p[130] | p[129] | p[127] | p[126] | p[125]
               | p[124] | p[123] | p[122] | p[121] | p[112] | p[110] | p[109] | p[108] | p[105] | p[104]
               | p[101] | p[100] | p[99]  | p[96]  | p[91]  | p[86]  | p[83]  | p[82]  | p[80]  | p[79]
               | p[76]  | p[75]  | p[69]  | p[66]  | p[43]  | p[36]  | p[2];

assign pl[2]   = p[232] | p[218] | p[216] | p[196] | p[192] | p[181] | p[174] | p[154] | p[152] | p[119]
               | p[118] | p[110] | p[107] | p[94]  | p[74]  | p[67]  | p[65]  | p[56];

assign pl[3]   = p[236] | p[230] | p[226] | p[208] | p[207] | p[206] | p[203] | p[200] | p[184] | p[182]
               | p[180] | p[175] | p[161] | p[158] | p[156] | p[155] | p[154] | p[153] | p[151] | p[148]
               | p[145] | p[137] | p[135] | p[131] | p[129] | p[128] | p[127] | p[126] | p[116] | p[105]
               | p[101] | p[97]  | p[94]  | p[68]  | p[58]  | p[33];

assign pl[4]   = p[225] | p[215] | p[209] | p[202] | p[179] | p[178] | p[172] | p[169] | p[167] | p[146]
               | p[144] | p[140] | p[103] | p[84]  | p[72];

assign pl[5]   = p[246] | p[231] | p[225] | p[218] | p[217] | p[216] | p[214] | p[212] | p[211] | p[209]
               | p[206] | p[204] | p[202] | p[201] | p[200] | p[197] | p[196] | p[191] | p[189] | p[186]
               | p[178] | p[175] | p[173] | p[162] | p[158] | p[157] | p[153] | p[145] | p[141] | p[139]
               | p[134] | p[130] | p[126] | p[125] | p[123] | p[110] | p[107] | p[96]  | p[88]  | p[80]
               | p[75]  | p[74]  | p[70]  | p[66]  | p[65]  | p[36]  | p[34];

assign pl[6]   = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[243] | p[242] | p[241] | p[238]
               | p[235] | p[232] | p[231] | p[229] | p[228] | p[225] | p[224] | p[223] | p[222] | p[220]
               | p[219] | p[218] | p[217] | p[216] | p[215] | p[214] | p[213] | p[212] | p[211] | p[210]
               | p[209] | p[208] | p[206] | p[205] | p[204] | p[202] | p[201] | p[200] | p[199] | p[197]
               | p[196] | p[195] | p[194] | p[193] | p[191] | p[190] | p[189] | p[188] | p[186] | p[185]
               | p[184] | p[182] | p[178] | p[177] | p[175] | p[173] | p[165] | p[164] | p[162] | p[160]
               | p[158] | p[157] | p[156] | p[155] | p[154] | p[153] | p[150] | p[149] | p[148] | p[145]
               | p[143] | p[141] | p[139] | p[137] | p[135] | p[133] | p[132] | p[131] | p[130] | p[129]
               | p[127] | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[119] | p[117] | p[112]
               | p[110] | p[109] | p[108] | p[105] | p[104] | p[101] | p[100] | p[99]  | p[94]  | p[91]
               | p[86]  | p[83]  | p[82]  | p[79]  | p[76]  | p[75]  | p[69]  | p[67]  | p[36];

assign pl[7]   = p[246] | p[243] | p[238] | p[236] | p[232] | p[231] | p[230] | p[228] | p[226] | p[225]
               | p[222] | p[220] | p[219] | p[218] | p[217] | p[216] | p[215] | p[214] | p[213] | p[212]
               | p[211] | p[209] | p[208] | p[207] | p[204] | p[203] | p[202] | p[201] | p[200] | p[196]
               | p[192] | p[191] | p[188] | p[187] | p[186] | p[185] | p[184] | p[182] | p[181] | p[178]
               | p[177] | p[175] | p[174] | p[173] | p[165] | p[164] | p[162] | p[160] | p[158] | p[156]
               | p[155] | p[154] | p[153] | p[152] | p[150] | p[148] | p[145] | p[143] | p[139] | p[135]
               | p[133] | p[132] | p[131] | p[129] | p[127] | p[126] | p[123] | p[118] | p[112] | p[110]
               | p[109] | p[108] | p[107] | p[105] | p[101] | p[100] | p[88]  | p[86]  | p[83]  | p[80]
               | p[74]  | p[65]  | p[56];

assign pl[8]   = p[246] | p[243] | p[238] | p[231] | p[228] | p[225] | p[222] | p[220] | p[219] | p[217]
               | p[215] | p[214] | p[213] | p[212] | p[211] | p[209] | p[204] | p[202] | p[201] | p[195]
               | p[191] | p[190] | p[188] | p[186] | p[185] | p[178] | p[177] | p[173] | p[165] | p[164]
               | p[162] | p[160] | p[157] | p[154] | p[150] | p[149] | p[143] | p[139] | p[132] | p[124]
               | p[123] | p[112] | p[109] | p[108] | p[104] | p[100] | p[99]  | p[86]  | p[83]  | p[71]
               | p[63]  | p[46]  | p[38]  | p[31]  | p[18]  | p[14]  | p[8]   | p[4]   | p[3];

assign pl[9]   = p[246] | p[245] | p[243] | p[240] | p[239] | p[234] | p[232] | p[228] | p[225] | p[220]
               | p[217] | p[215] | p[214] | p[213] | p[209] | p[204] | p[202] | p[201] | p[200] | p[197]
               | p[196] | p[192] | p[191] | p[189] | p[188] | p[185] | p[181] | p[178] | p[177] | p[174]
               | p[173] | p[169] | p[160] | p[159] | p[158] | p[152] | p[150] | p[149] | p[141] | p[138]
               | p[137] | p[130] | p[125] | p[124] | p[112] | p[108] | p[107] | p[104] | p[101] | p[99]
               | p[96]  | p[88]  | p[86]  | p[83]  | p[82]  | p[80]  | p[79]  | p[76]  | p[74]  | p[69]
               | p[66]  | p[65]  | p[56]  | p[43]  | p[36]  | p[34]  | p[2];

assign pl[10]  = p[237] | p[234] | p[226] | p[225] | p[222] | p[221] | p[214] | p[211] | p[203] | p[186]
               | p[184] | p[173] | p[165] | p[162] | p[160] | p[159] | p[158] | p[150] | p[148] | p[123]
               | p[112] | p[36];

assign pl[11]  = p[246] | p[240] | p[237] | p[236] | p[232] | p[227] | p[226] | p[222] | p[221] | p[220]
               | p[219] | p[218] | p[217] | p[216] | p[215] | p[213] | p[212] | p[211] | p[208] | p[207]
               | p[204] | p[203] | p[200] | p[196] | p[192] | p[184] | p[183] | p[182] | p[181] | p[177]
               | p[174] | p[173] | p[172] | p[169] | p[168] | p[166] | p[165] | p[162] | p[159] | p[158]
               | p[156] | p[155] | p[154] | p[152] | p[148] | p[145] | p[144] | p[138] | p[136] | p[135]
               | p[134] | p[132] | p[131] | p[127] | p[123] | p[118] | p[112] | p[110] | p[108] | p[107]
               | p[100] | p[94]  | p[86]  | p[83]  | p[74]  | p[65]  | p[64] | p[56];

assign pl[12]  = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[243] | p[242] | p[241] | p[240]
               | p[239] | p[238] | p[237] | p[236] | p[235] | p[232] | p[231] | p[230] | p[229] | p[228]
               | p[227] | p[226] | p[225] | p[224] | p[222] | p[221] | p[220] | p[219] | p[218] | p[217]
               | p[216] | p[215] | p[214] | p[213] | p[212] | p[211] | p[210] | p[209] | p[208] | p[207]
               | p[206] | p[205] | p[204] | p[203] | p[202] | p[201] | p[200] | p[199] | p[197] | p[196]
               | p[195] | p[194] | p[193] | p[191] | p[190] | p[189] | p[188] | p[186] | p[185] | p[184]
               | p[182] | p[178] | p[177] | p[175] | p[173] | p[165] | p[164] | p[162] | p[160] | p[158]
               | p[157] | p[156] | p[155] | p[154] | p[153] | p[150] | p[149] | p[148] | p[145] | p[143]
               | p[141] | p[139] | p[137] | p[135] | p[133] | p[132] | p[131] | p[130] | p[129] | p[127]
               | p[126] | p[125] | p[124] | p[123] | p[122] | p[121] | p[119] | p[112] | p[110] | p[109]
               | p[108] | p[105] | p[104] | p[101] | p[100] | p[99]  | p[94]  | p[91]  | p[86]  | p[83]
               | p[82]  | p[79]  | p[76]  | p[75]  | p[69]  | p[67]  | p[36];

assign pl[13]  = p[246] | p[243] | p[239] | p[237] | p[231] | p[230] | p[228] | p[226] | p[225] | p[222]
               | p[221] | p[220] | p[219] | p[217] | p[214] | p[213] | p[212] | p[211] | p[209] | p[206]
               | p[204] | p[203] | p[202] | p[201] | p[195] | p[191] | p[188] | p[186] | p[185] | p[184]
               | p[183] | p[179] | p[178] | p[175] | p[173] | p[172] | p[171] | p[169] | p[168] | p[167]
               | p[166] | p[165] | p[164] | p[162] | p[160] | p[159] | p[158] | p[157] | p[153] | p[150]
               | p[149] | p[148] | p[147] | p[146] | p[143] | p[140] | p[139] | p[137] | p[136] | p[132]
               | p[129] | p[126] | p[124] | p[123] | p[114] | p[112] | p[109] | p[105] | p[104] | p[103]
               | p[101] | p[99]  | p[96]  | p[94]  | p[84]  | p[80]  | p[72]  | p[70]  | p[66];

assign pl[14]  = p[246] | p[244] | p[243] | p[242] | p[240] | p[239] | p[237] | p[236] | p[235] | p[232]
               | p[230] | p[229] | p[228] | p[227] | p[226] | p[224] | p[222] | p[221] | p[220] | p[218]
               | p[217] | p[216] | p[212] | p[211] | p[210] | p[209] | p[208] | p[207] | p[206] | p[205]
               | p[204] | p[203] | p[202] | p[201] | p[200] | p[199] | p[196] | p[194] | p[193] | p[191]
               | p[188] | p[185] | p[184] | p[182] | p[181] | p[179] | p[178] | p[177] | p[175] | p[174]
               | p[173] | p[172] | p[171] | p[169] | p[167] | p[165] | p[164] | p[162] | p[159] | p[158]
               | p[157] | p[156] | p[155] | p[154] | p[153] | p[152] | p[149] | p[148] | p[145] | p[143]
               | p[141] | p[139] | p[137] | p[136] | p[135] | p[132] | p[131] | p[129] | p[127] | p[126]
               | p[124] | p[123] | p[122] | p[121] | p[118] | p[114] | p[112] | p[110] | p[108] | p[105]
               | p[104] | p[103] | p[101] | p[100] | p[99]  | p[94]  | p[83]  | p[80]  | p[77]  | p[72];

assign pl[15]  = p[245] | p[237] | p[232] | p[227] | p[221] | p[218] | p[217] | p[216] | p[214] | p[211]
               | p[206] | p[200] | p[197] | p[189] | p[185] | p[184] | p[181] | p[174] | p[173] | p[165]
               | p[164] | p[162] | p[158] | p[155] | p[153] | p[152] | p[150] | p[148] | p[145] | p[143]
               | p[139] | p[137] | p[131] | p[130] | p[129] | p[127] | p[126] | p[125] | p[123] | p[121]
               | p[110] | p[109] | p[108] | p[105] | p[101] | p[100] | p[83]  | p[77];

assign pl[16]  = p[248] | p[246] | p[243] | p[240] | p[237] | p[236] | p[232] | p[227] | p[226] | p[225]
               | p[224] | p[222] | p[221] | p[220] | p[219] | p[218] | p[217] | p[216] | p[215] | p[214]
               | p[213] | p[212] | p[211] | p[210] | p[208] | p[207] | p[206] | p[205] | p[204] | p[203]
               | p[202] | p[201] | p[200] | p[199] | p[196] | p[194] | p[193] | p[192] | p[191] | p[188]
               | p[184] | p[182] | p[181] | p[177] | p[175] | p[174] | p[173] | p[169] | p[168] | p[165]
               | p[162] | p[160] | p[159] | p[158] | p[156] | p[155] | p[154] | p[153] | p[150] | p[148]
               | p[147] | p[145] | p[144] | p[143] | p[139] | p[138] | p[137] | p[136] | p[135] | p[134]
               | p[133] | p[132] | p[131] | p[127] | p[123] | p[122] | p[121] | p[118] | p[114] | p[112]
               | p[110] | p[109] | p[108] | p[107] | p[103] | p[101] | p[100] | p[99]  | p[96]  | p[94]
               | p[86]  | p[84]  | p[83]  | p[80]  | p[77]  | p[74]  | p[70]  | p[65]  | p[62]  | p[59]
               | p[56]  | p[35]  | p[9];

assign pl[17]  = p[249] | p[248] | p[245] | p[244] | p[243] | p[242] | p[241] | p[240] | p[237] | p[236]
               | p[235] | p[232] | p[229] | p[226] | p[225] | p[218] | p[216] | p[214] | p[210] | p[208]
               | p[201] | p[200] | p[199] | p[196] | p[194] | p[193] | p[191] | p[184] | p[182] | p[181]
               | p[179] | p[160] | p[156] | p[155] | p[153] | p[148] | p[146] | p[145] | p[135] | p[131]
               | p[127] | p[122] | p[121] | p[110] | p[109] | p[101] | p[96]  | p[91]  | p[84]  | p[82]
               | p[75]  | p[70]  | p[62]  | p[42]  | p[39]  | p[35]  | p[28]  | p[25]  | p[23]  | p[22]
               | p[20]  | p[12];

assign pl[18]  = p[215] | p[213] | p[205] | p[199] | p[194] | p[193] | p[170] | p[122] | p[96]  | p[88]
               | p[84]  | p[72]  | p[57]  | p[24]  | p[22];

assign pl[19]  = p[246] | p[245] | p[243] | p[237] | p[233] | p[228] | p[227] | p[221] | p[219] | p[218]
               | p[217] | p[216] | p[215] | p[214] | p[213] | p[212] | p[208] | p[206] | p[200] | p[199]
               | p[197] | p[194] | p[193] | p[192] | p[189] | p[188] | p[186] | p[182] | p[181] | p[179]
               | p[175] | p[174] | p[172] | p[171] | p[169] | p[168] | p[167] | p[166] | p[165] | p[164]
               | p[160] | p[159] | p[154] | p[152] | p[147] | p[146] | p[145] | p[144] | p[143] | p[140]
               | p[138] | p[136] | p[135] | p[133] | p[130] | p[125] | p[124] | p[123] | p[122] | p[121]
               | p[119] | p[114] | p[112] | p[110] | p[107] | p[103] | p[100] | p[99]  | p[94]  | p[91]
               | p[86]  | p[84]  | p[83]  | p[82]  | p[79]  | p[77]  | p[76]  | p[74]  | p[69]  | p[67]
               | p[66]  | p[65]  | p[61]  | p[56]  | p[34]  | p[28]  | p[22]  | p[20];

assign pl[20]  = p[237] | p[227] | p[226] | p[224] | p[221] | p[215] | p[214] | p[210] | p[207] | p[206]
               | p[205] | p[203] | p[202] | p[191] | p[186] | p[184] | p[183] | p[175] | p[164] | p[160]
               | p[158] | p[154] | p[153] | p[150] | p[149] | p[148] | p[143] | p[139] | p[137] | p[126]
               | p[111] | p[101] | p[100] | p[99]  | p[96]  | p[94]  | p[84]  | p[83]  | p[80]  | p[66]
               | p[55]  | p[52]  | p[49]  | p[47]  | p[45]  | p[44]  | p[41]  | p[40]  | p[37]  | p[32]
               | p[30]  | p[29]  | p[17]  | p[16]  | p[15]  | p[11]  | p[10]  | p[7]   | p[6]   | p[5];

assign pl[21]  = p[225] | p[209] | p[202] | p[199] | p[193] | p[178] | p[169] | p[122] | p[91]  | p[72]
               | p[24];

assign pl[22]  = p[225] | p[209] | p[202] | p[199] | p[194] | p[193] | p[178] | p[171] | p[169] | p[168]
               | p[166] | p[147] | p[136] | p[122] | p[114] | p[91]  | p[86]  | p[72];

assign pl[23]  = p[236] | p[232] | p[231] | p[230] | p[226] | p[218] | p[216] | p[214] | p[208] | p[207]
               | p[206] | p[203] | p[200] | p[196] | p[192] | p[191] | p[185] | p[184] | p[183] | p[182]
               | p[181] | p[180] | p[177] | p[175] | p[174] | p[161] | p[160] | p[158] | p[157] | p[156]
               | p[155] | p[153] | p[152] | p[151] | p[150] | p[149] | p[148] | p[145] | p[143] | p[141]
               | p[137] | p[135] | p[131] | p[129] | p[128] | p[127] | p[126] | p[124] | p[118] | p[116]
               | p[110] | p[108] | p[107] | p[105] | p[104] | p[101] | p[99]  | p[97]  | p[96]  | p[86]
               | p[74]  | p[71]  | p[70]  | p[69]  | p[68]  | p[65]  | p[64]  | p[63]  | p[58]  | p[56]
               | p[54]  | p[46]  | p[38]  | p[31]  | p[27];

assign pl[24]  = p[244] | p[243] | p[242] | p[240] | p[239] | p[237] | p[236] | p[235] | p[232] | p[230]
               | p[229] | p[228] | p[227] | p[226] | p[224] | p[222] | p[221] | p[220] | p[219] | p[217]
               | p[215] | p[213] | p[212] | p[211] | p[210] | p[208] | p[207] | p[205] | p[203] | p[200]
               | p[199] | p[194] | p[193] | p[188] | p[183] | p[182] | p[181] | p[179] | p[177] | p[175]
               | p[174] | p[173] | p[172] | p[171] | p[169] | p[168] | p[167] | p[166] | p[164] | p[160]
               | p[159] | p[158] | p[154] | p[153] | p[152] | p[150] | p[148] | p[147] | p[146] | p[144]
               | p[140] | p[138] | p[137] | p[136] | p[135] | p[133] | p[132] | p[131] | p[127] | p[122]
               | p[121] | p[119] | p[118] | p[114] | p[112] | p[105] | p[103] | p[100] | p[94]  | p[91]
               | p[86]  | p[84]  | p[82]  | p[79]  | p[76]  | p[69]  | p[67];

assign pl[25]  = p[243] | p[237] | p[231] | p[228] | p[226] | p[222] | p[221] | p[220] | p[219] | p[214]
               | p[213] | p[212] | p[211] | p[204] | p[203] | p[191] | p[184] | p[183] | p[175] | p[173]
               | p[167] | p[165] | p[162] | p[160] | p[159] | p[158] | p[150] | p[148] | p[146] | p[144]
               | p[143] | p[140] | p[139] | p[123] | p[112] | p[99]  | p[94]  | p[80]  | p[72]  | p[66]
               | p[64]  | p[59]  | p[53]  | p[48];

assign pl[26]  = p[246] | p[243] | p[237] | p[228] | p[226] | p[225] | p[222] | p[221] | p[220] | p[219]
               | p[217] | p[213] | p[212] | p[211] | p[206] | p[204] | p[203] | p[202] | p[191] | p[188]
               | p[186] | p[184] | p[173] | p[167] | p[165] | p[162] | p[159] | p[158] | p[148] | p[147]
               | p[137] | p[123] | p[112] | p[109] | p[95]  | p[94]  | p[84]  | p[80]  | p[72]  | p[64]
               | p[59]  | p[13];

assign pl[27]  = p[246] | p[243] | p[237] | p[232] | p[226] | p[223] | p[222] | p[221] | p[218] | p[216]
               | p[213] | p[211] | p[209] | p[208] | p[203] | p[202] | p[201] | p[200] | p[196] | p[192]
               | p[188] | p[185] | p[184] | p[183] | p[182] | p[181] | p[175] | p[174] | p[173] | p[165]
               | p[162] | p[159] | p[158] | p[157] | p[156] | p[155] | p[153] | p[152] | p[149] | p[148]
               | p[145] | p[143] | p[139] | p[138] | p[135] | p[131] | p[129] | p[127] | p[126] | p[124]
               | p[123] | p[118] | p[117] | p[113] | p[112] | p[110] | p[107] | p[105] | p[104] | p[101]
               | p[99]  | p[96]  | p[88]  | p[80]  | p[79]  | p[76]  | p[74]  | p[70]  | p[65]  | p[64]
               | p[60]  | p[56]  | p[53]  | p[51]  | p[26]  | p[21];

assign pl[28]  = p[246] | p[240] | p[239] | p[237] | p[236] | p[232] | p[231] | p[230] | p[228] | p[226]
               | p[222] | p[221] | p[218] | p[217] | p[216] | p[213] | p[211] | p[209] | p[208] | p[206]
               | p[203] | p[202] | p[201] | p[200] | p[196] | p[192] | p[191] | p[188] | p[185] | p[184]
               | p[183] | p[182] | p[181] | p[178] | p[175] | p[174] | p[173] | p[171] | p[165] | p[164]
               | p[162] | p[159] | p[158] | p[157] | p[156] | p[155] | p[153] | p[152] | p[149] | p[148]
               | p[146] | p[145] | p[143] | p[142] | p[140] | p[137] | p[135] | p[131] | p[129] | p[127]
               | p[126] | p[124] | p[123] | p[118] | p[112] | p[110] | p[107] | p[105] | p[104] | p[101]
               | p[80]  | p[74]  | p[66]  | p[65]  | p[56]  | p[53]  | p[48];

assign pl[29]  = p[246] | p[245] | p[237] | p[236] | p[231] | p[230] | p[227] | p[226] | p[221] | p[218]
               | p[216] | p[214] | p[212] | p[209] | p[207] | p[206] | p[204] | p[203] | p[202] | p[200]
               | p[192] | p[186] | p[185] | p[184] | p[181] | p[177] | p[174] | p[165] | p[164] | p[158]
               | p[156] | p[155] | p[153] | p[152] | p[150] | p[135] | p[131] | p[129] | p[126] | p[110]
               | p[108] | p[100] | p[88]  | p[83]  | p[82]  | p[80]  | p[61]  | p[56]  | p[34]  | p[19];

assign pl[30]  = p[234] | p[225] | p[222] | p[219] | p[215] | p[214] | p[213] | p[209] | p[188] | p[186]
               | p[177] | p[165] | p[162] | p[160] | p[154] | p[153] | p[150] | p[149] | p[132] | p[126]
               | p[123] | p[109] | p[101] | p[88]  | p[86];

assign pl[31]  = p[249] | p[248] | p[247] | p[245] | p[244] | p[243] | p[242] | p[235] | p[234] | p[232]
               | p[229] | p[228] | p[225] | p[220] | p[219] | p[218] | p[217] | p[216] | p[215] | p[214]
               | p[213] | p[212] | p[211] | p[210] | p[209] | p[208] | p[204] | p[201] | p[200] | p[196]
               | p[195] | p[191] | p[188] | p[186] | p[185] | p[182] | p[177] | p[176] | p[173] | p[165]
               | p[162] | p[160] | p[157] | p[156] | p[154] | p[153] | p[150] | p[149] | p[145] | p[135]
               | p[131] | p[126] | p[124] | p[123] | p[112] | p[110] | p[109] | p[108] | p[104] | p[102]
               | p[101] | p[93]  | p[90]  | p[86]  | p[85]  | p[73];

assign pl[32]  = p[249] | p[248] | p[247] | p[245] | p[244] | p[243] | p[242] | p[235] | p[234] | p[232]
               | p[229] | p[228] | p[225] | p[222] | p[220] | p[219] | p[218] | p[217] | p[216] | p[215]
               | p[214] | p[213] | p[212] | p[211] | p[210] | p[208] | p[204] | p[201] | p[200] | p[198]
               | p[196] | p[191] | p[190] | p[188] | p[186] | p[185] | p[182] | p[177] | p[173] | p[165]
               | p[162] | p[160] | p[157] | p[156] | p[150] | p[145] | p[135] | p[132] | p[131] | p[124]
               | p[123] | p[120] | p[110] | p[109] | p[108] | p[104] | p[98]  | p[92]  | p[88]  | p[87]
               | p[86]  | p[78];

assign pl[33]  = p[249] | p[248] | p[247] | p[245] | p[244] | p[243] | p[242] | p[235] | p[234] | p[232]
               | p[229] | p[228] | p[222] | p[220] | p[218] | p[217] | p[216] | p[215] | p[214] | p[212]
               | p[211] | p[210] | p[208] | p[201] | p[196] | p[191] | p[186] | p[185] | p[182] | p[173]
               | p[163] | p[160] | p[156] | p[150] | p[132] | p[131] | p[115] | p[112] | p[110] | p[108]
               | p[106] | p[89]  | p[86]  | p[81]  | p[50];
endmodule

//______________________________________________________________________________
//
module vm1g_plm
(
   input  [15:0]  ir,
   input  [14:0]  mr,
   output [33:0]  sp
);
wire [249:1] p;
wire [33:0] pl;

function cmp
(
   input [30:0] ai,
   input [30:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

assign p[1]   = cmp({ir, mr}, {16'bxxx1000xxx000xxx, 15'b0x1xxxxxx11x110});
assign p[2]   = cmp({ir, mr}, {16'bxxxxx00111000xxx, 15'b0x1xxxxxxx11110});
assign p[3]   = cmp({ir, mr}, {16'b1000x000xxxxxxxx, 15'b001xxxxxxx11110});
assign p[4]   = cmp({ir, mr}, {16'bxxxxxxxxxxxxx111, 15'bxxxxxxxx111101x});
assign p[5]   = cmp({ir, mr}, {16'b0xxxx110xxxxxxxx, 15'bxxxx100x100x110});
assign p[6]   = cmp({ir, mr}, {16'bxxxxxxxxxx000111, 15'b001xxxxx111x110});
assign p[7]   = cmp({ir, mr}, {16'b0xx0x101xxxxxxxx, 15'bxxxx1x1x1x0011x});
assign p[8]   = cmp({ir, mr}, {16'bxxxxxxx111xxxxxx, 15'bxxxxxxxxx100x11});
assign p[9]   = cmp({ir, mr}, {16'bx100xxxxxxxxxxxx, 15'b1xxxxxxx01x011x});
assign p[10]  = cmp({ir, mr}, {16'bxxxxx000xxxxxxxx, 15'bxxxx1xxx1000110});
assign p[11]  = cmp({ir, mr}, {16'b1xxxxx011xxxxxxx, 15'bxx1xxxxxxx11000});
assign p[12]  = cmp({ir, mr}, {16'b0xxxx111xxxxxxxx, 15'bxxxx000x100x110});
assign p[13]  = cmp({ir, mr}, {16'b0000000001000xxx, 15'b001xxxxxxx11110});
assign p[14]  = cmp({ir, mr}, {16'bxxxxx1xxxxxxxxxx, 15'bxxxxx1xx1011xxx});
assign p[15]  = cmp({ir, mr}, {16'bxxxxxxxxxx000xxx, 15'bxxxxxxxx11x00x1});
assign p[16]  = cmp({ir, mr}, {16'bx000101111xxxxxx, 15'b001xxxxxxx11110});
assign p[17]  = cmp({ir, mr}, {16'b0000100xxx000xxx, 15'b001xxxxxxx11110});
assign p[18]  = cmp({ir, mr}, {16'bxxxxxxxxxx10xxxx, 15'bxxxxxxxxxx11011});
assign p[19]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1x110x1});
assign p[20]  = cmp({ir, mr}, {16'bx010xxxxxxxxxxxx, 15'b1xxxxxxx01x011x});
assign p[21]  = cmp({ir, mr}, {16'b1000100xxxxxxxxx, 15'b0x1xxxxx1xx1110});
assign p[22]  = cmp({ir, mr}, {16'bxxxxxx1010xxxxxx, 15'b0xxxxxxx011x11x});
assign p[23]  = cmp({ir, mr}, {16'b1xx0x001xxxxxxxx, 15'bxxxx0xxx1x0011x});
assign p[24]  = cmp({ir, mr}, {16'b0xxxx111xxxxxxxx, 15'bxxxx101x100x110});
assign p[25]  = cmp({ir, mr}, {16'b1xxxxxxxxxxxxxxx, 15'bxxxxxxxx110011x});
assign p[26]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxx11x, 15'bxxxxxxxxx1x101x});
assign p[27]  = cmp({ir, mr}, {16'b0xxxx011xxxxxxxx, 15'bxxxxx0xx100x110});
assign p[28]  = cmp({ir, mr}, {16'b1xxxx011xxxxxxxx, 15'bxxxxx0x0100011x});
assign p[29]  = cmp({ir, mr}, {16'b1xxxx101xxxxxxxx, 15'bxxxxxx0x100x110});
assign p[30]  = cmp({ir, mr}, {16'b1xxxx111xxxxxxxx, 15'bxxxxxxx0100011x});
assign p[31]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxx1xx, 15'bxxxxxxxx1x00111});
assign p[32]  = cmp({ir, mr}, {16'b0xxxx101xxxxxxxx, 15'bxxxx0x0x100011x});
assign p[33]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxx111, 15'bxxxxxxxx01xx11x});
assign p[34]  = cmp({ir, mr}, {16'b0110xxxxxxxxxxxx, 15'b1xxxxxxx01x011x});
assign p[35]  = cmp({ir, mr}, {16'b0xxxx1x0xxxxxxxx, 15'bxxxx0x1x100011x});
assign p[36]  = cmp({ir, mr}, {16'b1xxxx100xxxxxxxx, 15'bxxxxxx1x100011x});
assign p[37]  = cmp({ir, mr}, {16'b0000000000000101, 15'b001xxxxxxx11110});
assign p[38]  = cmp({ir, mr}, {16'b1xxxxxxxxxxxxxxx, 15'bxxxx0xxx0xx1110});
assign p[39]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxx00xx0000x00});
assign p[40]  = cmp({ir, mr}, {16'b0xxxx1x111xxxxxx, 15'b0xxx1xxx011x11x});
assign p[41]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxx0xxx0x00010});
assign p[42]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx11x000x});
assign p[43]  = cmp({ir, mr}, {16'b1xxxxx10xxxxxxxx, 15'bxxxxxxx1100x110});
assign p[44]  = cmp({ir, mr}, {16'bxxxxxxx0xxxxxxxx, 15'bxxx0xxxx1010101});
assign p[45]  = cmp({ir, mr}, {16'b0111111xxxxxxxxx, 15'b001xxxxxxx11110});
assign p[46]  = cmp({ir, mr}, {16'bxxxxxxx1xxxxxxxx, 15'bxxxxxxxx0x001x1});
assign p[47]  = cmp({ir, mr}, {16'bxxxx000xxxxxxxxx, 15'bxxxxxxxx011x000});
assign p[48]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxx0x00x0100});
assign p[49]  = cmp({ir, mr}, {16'b0xx0xx00xxxxxxxx, 15'bxxxx1x0x1x00110});
assign p[50]  = cmp({ir, mr}, {16'b0xxxx110xxxxxxxx, 15'bxxxxx1xx100011x});
assign p[51]  = cmp({ir, mr}, {16'bxxxxx1x01xxxxxxx, 15'b0xxxxxxx011x11x});
assign p[52]  = cmp({ir, mr}, {16'bxxxxx010xxxxxxxx, 15'bxxxxx1xx100011x});
assign p[53]  = cmp({ir, mr}, {16'b000000001x000xxx, 15'b001xxxxx111x110});
assign p[54]  = cmp({ir, mr}, {16'bx000100xxxxxxxxx, 15'b001xxxxxxx11110});
assign p[55]  = cmp({ir, mr}, {16'bxxxxxx1101xxxxxx, 15'b0xxxxxxx011x11x});
assign p[56]  = cmp({ir, mr}, {16'bxxxxx1x0x1xxxxxx, 15'b0xxxxxxx011x11x});
assign p[57]  = cmp({ir, mr}, {16'b1xxxxxxxxxxxxxxx, 15'bxx1xxxxx01x011x});
assign p[58]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0100x10});
assign p[59]  = cmp({ir, mr}, {16'bxxxxxxxxxx101xxx, 15'bxxxxxxxx01xx010});
assign p[60]  = cmp({ir, mr}, {16'bx000101xxx000xxx, 15'b001xxxxx111x110});
assign p[61]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxx1xxx0001001});
assign p[62]  = cmp({ir, mr}, {16'bxxxxxxxx1xxxxxxx, 15'bxxxxxxxx0x001x1});
assign p[63]  = cmp({ir, mr}, {16'bxxxxxxxxxx0xxxxx, 15'bxxxxxxxxx111101});
assign p[64]  = cmp({ir, mr}, {16'b0000010xxxxxxxxx, 15'b001xxxxx111x110});
assign p[65]  = cmp({ir, mr}, {16'bxxxxxxx0x1xxxxxx, 15'bxxxxxxxx0101x11});
assign p[66]  = cmp({ir, mr}, {16'b0xxx100xxxxxxxxx, 15'b0xxxxxxx011x111});
assign p[67]  = cmp({ir, mr}, {16'b0111100xxx100xxx, 15'b001xxxxx111x110});
assign p[68]  = cmp({ir, mr}, {16'b1xxxxx0111xxxxxx, 15'b0x1xxxxx011x111});
assign p[69]  = cmp({ir, mr}, {16'b0xxx0xxx1xxxxxxx, 15'b0xxxxxxx0110111});
assign p[70]  = cmp({ir, mr}, {16'bxxxxxxxxx1xxxxxx, 15'bxxxxxxxx0x001x1});
assign p[71]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx00001x0});
assign p[72]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1111x11});
assign p[73]  = cmp({ir, mr}, {16'bxxxxxxxxxx0xxxxx, 15'b1xxxx1xxxx11011});
assign p[74]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx110x000});
assign p[75]  = cmp({ir, mr}, {16'bxxxxxxx0x0xxxxxx, 15'bxxxxxxxx0101x11});
assign p[76]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b000xxxxx1111110});
assign p[77]  = cmp({ir, mr}, {16'b0xxxxxxxxxxxxxxx, 15'bxxxxxxxx01xx0xx});
assign p[78]  = cmp({ir, mr}, {16'b00000001xxxxxxxx, 15'b001xxxxxxx11110});
assign p[79]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0x111x1});
assign p[80]  = cmp({ir, mr}, {16'b0000000000000000, 15'b001xxxxxxx11110});
assign p[81]  = cmp({ir, mr}, {16'bxxxxxxxxxx011xxx, 15'bxxxxxxxx0111x10});
assign p[82]  = cmp({ir, mr}, {16'bx011xxxxxxxxxxxx, 15'b1xxxxxxx01x011x});
assign p[83]  = cmp({ir, mr}, {16'b00001101x1000xxx, 15'b001xxxxxxx11110});
assign p[84]  = cmp({ir, mr}, {16'bxxxxx0xxxxxxxxxx, 15'bxxxxxxxx0011001});
assign p[85]  = cmp({ir, mr}, {16'b0xxxxxxxx1xxxxxx, 15'bxxxxxxxx0xx1110});
assign p[86]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxx00010110});
assign p[87]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1000010});
assign p[88]  = cmp({ir, mr}, {16'b1xxxxx01x0xxxxxx, 15'b0x1xxxxx011x111});
assign p[89]  = cmp({ir, mr}, {16'bx0001100xx000xxx, 15'b001xxxxxxx11110});
assign p[90]  = cmp({ir, mr}, {16'b01111xxxxxxxxxxx, 15'b1xxxxxxx01x011x});
assign p[91]  = cmp({ir, mr}, {16'b10001101xx000xxx, 15'b001xxxxxxx11110});
assign p[92]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1x11101});
assign p[93]  = cmp({ir, mr}, {16'b0111100xxxx10xxx, 15'b001xxxxx1x11110});
assign p[94]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxx0xxxxx01xx0xx});
assign p[95]  = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0100101});
assign p[96]  = cmp({ir, mr}, {16'bxxx1xx0xxxxxxxxx, 15'bxxxxxxxx1011xxx});
assign p[97]  = cmp({ir, mr}, {16'bxxxxxx1000xxxxxx, 15'b0xxxxxxx011011x});
assign p[98]  = cmp({ir, mr}, {16'b10000x0xxxxxxxxx, 15'b001xxxxx1x11110});
assign p[99]  = cmp({ir, mr}, {16'bxxxxxxxxxx11xxxx, 15'bxxxxxxxx011x010});
assign p[100] = cmp({ir, mr}, {16'bx01xxxxxxxxxxxxx, 15'bxxxxxxxxx10011x});
assign p[101] = cmp({ir, mr}, {16'bxxxxx0xxxxxxxxxx, 15'bxxxxxxxx0011xx0});
assign p[102] = cmp({ir, mr}, {16'bxxxx10xxxxxxxxxx, 15'bxxxxxxxx110xx11});
assign p[103] = cmp({ir, mr}, {16'bx00xxxxxxxxxxxxx, 15'b1xxxxxxx011x111});
assign p[104] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b01xxxxxx111x110});
assign p[105] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxx01xx0000011});
assign p[106] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1x01101});
assign p[107] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0111100});
assign p[108] = cmp({ir, mr}, {16'bxxxx101xxxxxxxxx, 15'bxxxxxxxx011x000});
assign p[109] = cmp({ir, mr}, {16'bxxxxxxxxx1xxxxxx, 15'bxxxxxxxxxx1100x});
assign p[110] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b10xxxxxx111x110});
assign p[111] = cmp({ir, mr}, {16'bxxxx011xxxxxxxxx, 15'bxxxxxxxx011x000});
assign p[112] = cmp({ir, mr}, {16'bxxxxxxxxxxxx00xx, 15'bxxx1xxxxx001110});
assign p[113] = cmp({ir, mr}, {16'bxxxxxxxxxx1xxxxx, 15'bxxxxxxxxxx11101});
assign p[114] = cmp({ir, mr}, {16'bxxxxxxxxxxx0xxxx, 15'bxxxxxxxx010x01x});
assign p[115] = cmp({ir, mr}, {16'bxxxxxxxx0xxxxxxx, 15'bxxxxxxxx0101111});
assign p[116] = cmp({ir, mr}, {16'bxxxxxxxxxx0xxxxx, 15'b0xxxx1xxx011011});
assign p[117] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx11100x0});
assign p[118] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx00001x1});
assign p[119] = cmp({ir, mr}, {16'b01110xxxxxxxxxxx, 15'bxxxxxxxx011x111});
assign p[120] = cmp({ir, mr}, {16'bx101xxxxxxxxxxxx, 15'bxxxxxxxx011x01x});
assign p[121] = cmp({ir, mr}, {16'b0xxxx00xxxxxxxxx, 15'b0xxxxxxx0110111});
assign p[122] = cmp({ir, mr}, {16'bxxxxxx1111xxxxxx, 15'b0xxxxxxx011011x});
assign p[123] = cmp({ir, mr}, {16'b1xxxxxxxx1xxxxxx, 15'bxxxxxxxx01x1111});
assign p[124] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx10x1000});
assign p[125] = cmp({ir, mr}, {16'bx110000xxx000xxx, 15'b001xxxxx1x11x10});
assign p[126] = cmp({ir, mr}, {16'bxxxxxxxxxxxx1xxx, 15'bxxxxxxxxx111011});
assign p[127] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0111110});
assign p[128] = cmp({ir, mr}, {16'bxxxxxx1001xxxxxx, 15'b0xxxxxxx011011x});
assign p[129] = cmp({ir, mr}, {16'bx10xxxxxxxxxxxxx, 15'b1xxxxxxx01x011x});
assign p[130] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxx1xxxxx1001111});
assign p[131] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxx1, 15'bxxxxxxxx01xxx1x});
assign p[132] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx111x000});
assign p[133] = cmp({ir, mr}, {16'bxxxxxx1110xxxxxx, 15'b0xxxxxxx011011x});
assign p[134] = cmp({ir, mr}, {16'bxxxxxxx1xxxxxxxx, 15'bxxxxxxxxxx1100x});
assign p[135] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1101110});
assign p[136] = cmp({ir, mr}, {16'bxxxxxxxx1xxxxxxx, 15'bxxxxxxxxxx11x0x});
assign p[137] = cmp({ir, mr}, {16'b000xxxxxxxxxxxxx, 15'bxxxxxxxx010011x});
assign p[138] = cmp({ir, mr}, {16'bxxxxx1xxxxxxxxxx, 15'bxxxxxxxx110x111});
assign p[139] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxx10001010});
assign p[140] = cmp({ir, mr}, {16'bxxxxxxxxxxxxx1xx, 15'bxxxxxxxx01xxx1x});
assign p[141] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxx1x, 15'bxxxxxxxx01xxx1x});
assign p[142] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0010000});
assign p[143] = cmp({ir, mr}, {16'bxxxxxxx1xxxxxxxx, 15'bxxxxxxxx101x10x});
assign p[144] = cmp({ir, mr}, {16'bxxxx11xxxxxxxxxx, 15'bxxxxxxxx011x000});
assign p[145] = cmp({ir, mr}, {16'b0xxxxxxxxxxxxxxx, 15'bxxxxxxxxxx11xxx});
assign p[146] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1101100});
assign p[147] = cmp({ir, mr}, {16'bxxxxx0xxxxxxxxxx, 15'bxxx0xxxx00x1110});
assign p[148] = cmp({ir, mr}, {16'b1xxxxxxxxxxxxxxx, 15'bxxxxxxxx0x01110});
assign p[149] = cmp({ir, mr}, {16'bxxxxx1x1x1xxxxxx, 15'b0xxxxxxx011011x});
assign p[150] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx10x1011});
assign p[151] = cmp({ir, mr}, {16'bxx10xxxxxxxxxxxx, 15'b1xxxxxxx01x011x});
assign p[152] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b11xxxxxx111x110});
assign p[153] = cmp({ir, mr}, {16'bxxxxxx101xxxxxxx, 15'b0xxxxxxx011011x});
assign p[154] = cmp({ir, mr}, {16'b100xxxxxxxxxxxxx, 15'bxxxxxxxx010011x});
assign p[155] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx111110x});
assign p[156] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxx1xxx0000x00});
assign p[157] = cmp({ir, mr}, {16'b00001101x0xxxxxx, 15'b001xxxxx111x110});
assign p[158] = cmp({ir, mr}, {16'bxxxxxx110xxxxxxx, 15'b0xxxxxxx011011x});
assign p[159] = cmp({ir, mr}, {16'b0000000000001xxx, 15'b001xxxxx1x11110});
assign p[160] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0010011});
assign p[161] = cmp({ir, mr}, {16'b0000000011000xxx, 15'b001xxxxx1x11110});
assign p[162] = cmp({ir, mr}, {16'bxxxxx1x0xxxxxxxx, 15'b0xxxxxxx011011x});
assign p[163] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'b1xxxxxxx0110111});
assign p[164] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx100x100});
assign p[165] = cmp({ir, mr}, {16'bxxxx0xxxxxxxxxxx, 15'bxxxxxxxx110x111});
assign p[166] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0001000});
assign p[167] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx110100x});
assign p[168] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0110111});
assign p[169] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx00x1001});
assign p[170] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bx0xxxxxx110001x});
assign p[171] = cmp({ir, mr}, {16'bxxxxxx1xxxxxxxxx, 15'bxxxxxxxx0111x01});
assign p[172] = cmp({ir, mr}, {16'bxxxxxxxxxxxx1xxx, 15'bxxxxxxxxx001110});
assign p[173] = cmp({ir, mr}, {16'bxxxxxxxxxx100xxx, 15'bxxxxxxxx011x010});
assign p[174] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1000x00});
assign p[175] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx11x0110});
assign p[176] = cmp({ir, mr}, {16'b00000000101xxxxx, 15'b001xxxxx111x110});
assign p[177] = cmp({ir, mr}, {16'bxx11xxxxxxxxxxxx, 15'bxxxxxxxx011x01x});
assign p[178] = cmp({ir, mr}, {16'b0000000000000011, 15'b001xxxxx1x11110});
assign p[179] = cmp({ir, mr}, {16'bxxxxxxxxxx1xxxxx, 15'bxxxxxxxxx011x11});
assign p[180] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx101x00x});
assign p[181] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1101010});
assign p[182] = cmp({ir, mr}, {16'bx0000x1xxxxxxxxx, 15'b001xxxxx1x11110});
assign p[183] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxx0xxxxx1001111});
assign p[184] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bx0xxxxxx011x01x});
assign p[185] = cmp({ir, mr}, {16'b0000000000000x10, 15'b001xxxxx111x110});
assign p[186] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx001110x});
assign p[187] = cmp({ir, mr}, {16'bxxxx001xxxxxxxxx, 15'bxxxxxxxx011x000});
assign p[188] = cmp({ir, mr}, {16'b0000000000000100, 15'b001xxxxx1x11110});
assign p[189] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1x00011});
assign p[190] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxx0xx0000001});
assign p[191] = cmp({ir, mr}, {16'b0111100xxxxx1xxx, 15'b001xxxxx1x11110});
assign p[192] = cmp({ir, mr}, {16'bxxxxxxxxxx00xxxx, 15'bxxxxxxxx011x010});
assign p[193] = cmp({ir, mr}, {16'bxxxxxxxxxxxx0xxx, 15'bxxx0xxxx1001110});
assign p[194] = cmp({ir, mr}, {16'bxxxxxxxxxx0x0xxx, 15'bxxxxxxxx0111010});
assign p[195] = cmp({ir, mr}, {16'b0000000000000001, 15'b001xxxxx111x110});
assign p[196] = cmp({ir, mr}, {16'bxxx0xxxxxxxxxxxx, 15'bxxxxxxxx011x01x});
assign p[197] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0010001});
assign p[198] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1x00111});
assign p[199] = cmp({ir, mr}, {16'bx01x000xxx000xxx, 15'b001xxxxx1x11110});
assign p[200] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxxx110011});
assign p[201] = cmp({ir, mr}, {16'bxxxxxx1xxxxxxxxx, 15'bxxxxxxxx00x10xx});
assign p[202] = cmp({ir, mr}, {16'bx001000xxx000xxx, 15'b001xxxxx1x11110});
assign p[203] = cmp({ir, mr}, {16'bxxxx100xxxxxxxxx, 15'bxxxxxxxx011x000});
assign p[204] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0000x10});
assign p[205] = cmp({ir, mr}, {16'bx10x000xxx000xxx, 15'b001xxxxx1x11110});
assign p[206] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0001011});
assign p[207] = cmp({ir, mr}, {16'bxxxxxxxxxxxx0xxx, 15'bxxxxxxxxx111011});
assign p[208] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxx1xx0000001});
assign p[209] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx10x0100});
assign p[210] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx011000x});
assign p[211] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxx1xxx0000011});
assign p[212] = cmp({ir, mr}, {16'b1000110100xxxxxx, 15'b001xxxxx1x11110});
assign p[213] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx0010010});
assign p[214] = cmp({ir, mr}, {16'b0xx0xxxxxxxxxxxx, 15'bxxxxxxxxx011010});
assign p[215] = cmp({ir, mr}, {16'bxxxx010xxxxxxxxx, 15'bxxxxxxxx011x000});
assign p[216] = cmp({ir, mr}, {16'bxxxxxx0xxxxxxxxx, 15'bxxxxxxxx0111001});
assign p[217] = cmp({ir, mr}, {16'b0111000xxxxxxxxx, 15'b001xxxxx1x11110});
assign p[218] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1001010});
assign p[219] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxx00xx00000xx});
assign p[220] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxx00001010});
assign p[221] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx00x0100});
assign p[222] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bx1xxxxxx110001x});
assign p[223] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxx10010110});
assign p[224] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx11xx011});
assign p[225] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1011x11});
assign p[226] = cmp({ir, mr}, {16'b0000000001xxxxxx, 15'b001xxxxx1x11110});
assign p[227] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxxx011110});
assign p[228] = cmp({ir, mr}, {16'bxxxxxxxxxxxx01xx, 15'bxxx1xxxxx001110});
assign p[229] = cmp({ir, mr}, {16'bxxxxxxx0xxxxxxxx, 15'bxxxxxxxx1010101});
assign p[230] = cmp({ir, mr}, {16'bxxx0xxx00xxxxxxx, 15'bxxxxx0xxx011011});
assign p[231] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx111000x});
assign p[232] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxx0xxx0000xx0});
assign p[233] = cmp({ir, mr}, {16'bxxx0xxxxxxxxxxxx, 15'bxxxxxxxx00x1010});
assign p[234] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1011x00});
assign p[235] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx1x11x01});
assign p[236] = cmp({ir, mr}, {16'bxxxxxx1xxxxxxxxx, 15'bxxxxxxxxx0x1x10});
assign p[237] = cmp({ir, mr}, {16'bxxxxxxxxxxx1xxxx, 15'bxxxxxxxx010x01x});
assign p[238] = cmp({ir, mr}, {16'bx0001100xxxxxxxx, 15'b001xxxxx111x110});
assign p[239] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx111101x});
assign p[240] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx01xx11x});
assign p[241] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx10001x0});
assign p[242] = cmp({ir, mr}, {16'bx000xx0x11xxxxxx, 15'b001xxxxx1x11110});
assign p[243] = cmp({ir, mr}, {16'bxxxxxxxxxxxxxxxx, 15'bxxxxxxxx011x0xx});
assign p[244] = cmp({ir, mr}, {16'bx00010xxxxxxxxxx, 15'b001xxxxx1x11110});
assign p[245] = cmp({ir, mr}, {16'bx110xxxxxxxxxxxx, 15'b001xxxxx1x11x10});
assign p[246] = cmp({ir, mr}, {16'b0111100xxx000xxx, 15'b001xxxxx111x110});
assign p[247] = cmp({ir, mr}, {16'bx001xxxxxxxxxxxx, 15'b001xxxxx111x110});
assign p[248] = cmp({ir, mr}, {16'bx10xxxxxxxxxxxxx, 15'b001xxxxx111x110});
assign p[249] = cmp({ir, mr}, {16'bx01xxxxxxxxxxxxx, 15'b001xxxxx111x110});

//
// Summ-Of-Products
//
assign sp = ~pl;
assign pl[0]   = p[246] | p[241] | p[236] | p[234] | p[233] | p[232] | p[228] | p[227] | p[225] | p[224]
               | p[222] | p[219] | p[218] | p[216] | p[215] | p[213] | p[210] | p[209] | p[205] | p[204]
               | p[203] | p[202] | p[201] | p[199] | p[198] | p[193] | p[190] | p[189] | p[188] | p[187]
               | p[185] | p[182] | p[180] | p[179] | p[178] | p[175] | p[174] | p[172] | p[170] | p[169]
               | p[168] | p[167] | p[165] | p[164] | p[162] | p[160] | p[159] | p[158] | p[156] | p[153]
               | p[152] | p[151] | p[150] | p[149] | p[148] | p[147] | p[143] | p[137] | p[135] | p[133]
               | p[132] | p[129] | p[128] | p[127] | p[124] | p[122] | p[119] | p[117] | p[116] | p[115]
               | p[112] | p[110] | p[106] | p[104] | p[98]  | p[97]  | p[92]  | p[90]  | p[85]  | p[82]
               | p[80]  | p[78]  | p[76]  | p[75]  | p[74]  | p[73]  | p[72]  | p[64]  | p[63]  | p[44]
               | p[37]  | p[21]  | p[17]  | p[15]  | p[13];

assign pl[1]   = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[243] | p[242] | p[241] | p[239]
               | p[238] | p[237] | p[236] | p[235] | p[234] | p[233] | p[232] | p[231] | p[230] | p[229]
               | p[228] | p[227] | p[226] | p[225] | p[224] | p[223] | p[222] | p[221] | p[220] | p[219]
               | p[217] | p[214] | p[213] | p[212] | p[211] | p[209] | p[208] | p[206] | p[204] | p[201]
               | p[198] | p[197] | p[195] | p[191] | p[190] | p[189] | p[188] | p[186] | p[185] | p[183]
               | p[182] | p[181] | p[180] | p[178] | p[176] | p[175] | p[174] | p[172] | p[170] | p[169]
               | p[168] | p[167] | p[166] | p[165] | p[164] | p[160] | p[159] | p[157] | p[156] | p[155]
               | p[154] | p[152] | p[150] | p[147] | p[146] | p[143] | p[142] | p[139] | p[138] | p[136]
               | p[132] | p[130] | p[127] | p[124] | p[123] | p[119] | p[118] | p[117] | p[116] | p[115]
               | p[114] | p[112] | p[110] | p[107] | p[106] | p[105] | p[104] | p[102] | p[101] | p[98]
               | p[96]  | p[95]  | p[93]  | p[87]  | p[86]  | p[80]  | p[79]  | p[78]  | p[75]  | p[74]
               | p[73]  | p[67]  | p[65]  | p[64]  | p[53]  | p[45]  | p[37]  | p[33]  | p[8];

assign pl[2]   = p[246] | p[239] | p[228] | p[218] | p[205] | p[202] | p[199] | p[176] | p[172] | p[161]
               | p[125] | p[91]  | p[89]  | p[83]  | p[76]  | p[72]  | p[60];

assign pl[3]   = p[225] | p[224] | p[218] | p[216] | p[215] | p[213] | p[210] | p[203] | p[196] | p[193]
               | p[189] | p[187] | p[185] | p[181] | p[177] | p[174] | p[171] | p[160] | p[152] | p[144]
               | p[135] | p[126] | p[120] | p[111] | p[108] | p[104] | p[99]  | p[81]  | p[59];

assign pl[4]   = p[230] | p[229] | p[223] | p[221] | p[220] | p[214] | p[211] | p[208] | p[206] | p[201]
               | p[166] | p[165] | p[162] | p[158] | p[156] | p[154] | p[151] | p[139] | p[133] | p[132]
               | p[128] | p[123] | p[122] | p[105] | p[97]  | p[86]  | p[85]  | p[39];

assign pl[5]   = p[246] | p[235] | p[230] | p[229] | p[228] | p[225] | p[224] | p[223] | p[222] | p[221]
               | p[220] | p[214] | p[211] | p[209] | p[208] | p[206] | p[205] | p[202] | p[201] | p[199]
               | p[197] | p[189] | p[186] | p[185] | p[183] | p[182] | p[174] | p[172] | p[170] | p[166]
               | p[164] | p[160] | p[159] | p[157] | p[155] | p[146] | p[142] | p[139] | p[138] | p[130]
               | p[124] | p[119] | p[116] | p[113] | p[110] | p[106] | p[105] | p[104] | p[102] | p[101]
               | p[98]  | p[96]  | p[86]  | p[78]  | p[64]  | p[45]  | p[37]  | p[31]  | p[1];

assign pl[6]   = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[242] | p[241] | p[240] | p[239]
               | p[238] | p[237] | p[236] | p[235] | p[234] | p[233] | p[232] | p[231] | p[230] | p[229]
               | p[228] | p[227] | p[226] | p[225] | p[224] | p[223] | p[222] | p[221] | p[220] | p[219]
               | p[218] | p[217] | p[214] | p[213] | p[212] | p[211] | p[209] | p[208] | p[206] | p[204]
               | p[201] | p[198] | p[197] | p[195] | p[193] | p[191] | p[190] | p[189] | p[188] | p[186]
               | p[185] | p[183] | p[182] | p[181] | p[180] | p[179] | p[178] | p[176] | p[175] | p[174]
               | p[172] | p[171] | p[170] | p[169] | p[167] | p[166] | p[165] | p[164] | p[160] | p[159]
               | p[157] | p[156] | p[155] | p[152] | p[150] | p[147] | p[146] | p[145] | p[144] | p[143]
               | p[142] | p[139] | p[138] | p[135] | p[130] | p[126] | p[124] | p[118] | p[117] | p[114]
               | p[112] | p[111] | p[110] | p[108] | p[107] | p[106] | p[105] | p[104] | p[102] | p[99]
               | p[98]  | p[95]  | p[94]  | p[87]  | p[86]  | p[81]  | p[77]  | p[76]  | p[74]  | p[72]
               | p[59]  | p[47];

assign pl[7]   = p[246] | p[241] | p[240] | p[239] | p[237] | p[236] | p[235] | p[234] | p[233] | p[232]
               | p[231] | p[230] | p[229] | p[228] | p[227] | p[225] | p[224] | p[223] | p[221] | p[220]
               | p[219] | p[216] | p[215] | p[214] | p[213] | p[211] | p[210] | p[209] | p[208] | p[206]
               | p[205] | p[204] | p[203] | p[202] | p[201] | p[199] | p[198] | p[197] | p[195] | p[193]
               | p[190] | p[189] | p[187] | p[186] | p[185] | p[184] | p[183] | p[181] | p[180] | p[179]
               | p[176] | p[175] | p[172] | p[171] | p[167] | p[166] | p[165] | p[164] | p[161] | p[160]
               | p[159] | p[157] | p[156] | p[155] | p[152] | p[150] | p[146] | p[144] | p[143] | p[142]
               | p[139] | p[138] | p[135] | p[132] | p[130] | p[126] | p[125] | p[118] | p[117] | p[114]
               | p[113] | p[111] | p[108] | p[106] | p[105] | p[101] | p[99]  | p[96]  | p[95]  | p[91]
               | p[89]  | p[86]  | p[84]  | p[83]  | p[81]  | p[79]  | p[61]  | p[60]  | p[59]  | p[47];
//
// Auxilliary selectable inversion at the matrix output buffer (VM1G revision)
//
assign pl[8] = ~(p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[242] | p[239] | p[238] | p[228]
               | p[225] | p[224] | p[216] | p[215] | p[213] | p[212] | p[210] | p[203] | p[196] | p[193]
               | p[189] | p[187] | p[185] | p[181] | p[177] | p[176] | p[174] | p[172] | p[171] | p[160]
               | p[152] | p[144] | p[135] | p[126] | p[120] | p[111] | p[108] | p[104] | p[99]  | p[81]
               | p[59]);

assign pl[9]   = p[246] | p[241] | p[239] | p[236] | p[234] | p[233] | p[232] | p[229] | p[228] | p[227]
               | p[222] | p[221] | p[219] | p[217] | p[213] | p[211] | p[209] | p[208] | p[205] | p[204]
               | p[202] | p[199] | p[198] | p[197] | p[194] | p[191] | p[190] | p[182] | p[180] | p[175]
               | p[174] | p[173] | p[172] | p[170] | p[168] | p[167] | p[166] | p[165] | p[164] | p[161]
               | p[159] | p[156] | p[154] | p[150] | p[146] | p[143] | p[139] | p[127] | p[124] | p[123]
               | p[119] | p[117] | p[115] | p[110] | p[107] | p[105] | p[104] | p[98]  | p[93]  | p[91]
               | p[87]  | p[86]  | p[84]  | p[78]  | p[75]  | p[73]  | p[67]  | p[65]  | p[64]  | p[53]
               | p[47]  | p[33]  | p[19]  | p[8];

assign pl[10]  = p[234] | p[231] | p[229] | p[216] | p[213] | p[210] | p[209] | p[207] | p[200] | p[198]
               | p[180] | p[171] | p[168] | p[164] | p[155] | p[143] | p[127] | p[126] | p[117] | p[92]
               | p[37];

assign pl[11]  = p[246] | p[239] | p[235] | p[234] | p[233] | p[231] | p[229] | p[228] | p[227] | p[224]
               | p[223] | p[221] | p[220] | p[218] | p[216] | p[215] | p[213] | p[210] | p[209] | p[208]
               | p[207] | p[206] | p[205] | p[202] | p[200] | p[199] | p[194] | p[193] | p[192] | p[187]
               | p[186] | p[185] | p[181] | p[180] | p[179] | p[176] | p[175] | p[172] | p[171] | p[167]
               | p[166] | p[165] | p[163] | p[162] | p[161] | p[155] | p[154] | p[151] | p[150] | p[146]
               | p[144] | p[143] | p[139] | p[137] | p[135] | p[132] | p[130] | p[129] | p[127] | p[126]
               | p[125] | p[123] | p[121] | p[119] | p[118] | p[114] | p[111] | p[105] | p[99]  | p[96]
               | p[95]  | p[91]  | p[90]  | p[89]  | p[86]  | p[84]  | p[83]  | p[82]  | p[81]  | p[68]
               | p[65]  | p[61]  | p[60]  | p[47];

assign pl[12]  = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[243] | p[242] | p[241] | p[240]
               | p[239] | p[238] | p[237] | p[236] | p[235] | p[234] | p[233] | p[232] | p[231] | p[230]
               | p[229] | p[228] | p[227] | p[226] | p[225] | p[224] | p[223] | p[222] | p[221] | p[220]
               | p[219] | p[218] | p[217] | p[214] | p[213] | p[212] | p[211] | p[209] | p[208] | p[206]
               | p[204] | p[201] | p[198] | p[197] | p[195] | p[193] | p[191] | p[190] | p[189] | p[188]
               | p[186] | p[185] | p[183] | p[182] | p[181] | p[180] | p[179] | p[178] | p[176] | p[175]
               | p[174] | p[172] | p[170] | p[169] | p[167] | p[166] | p[165] | p[164] | p[160] | p[159]
               | p[157] | p[156] | p[155] | p[152] | p[150] | p[147] | p[146] | p[143] | p[142] | p[139]
               | p[138] | p[136] | p[135] | p[132] | p[130] | p[124] | p[118] | p[117] | p[116] | p[114]
               | p[112] | p[110] | p[107] | p[106] | p[105] | p[104] | p[102] | p[101] | p[98]  | p[96]
               | p[95]  | p[93]  | p[87]  | p[86]  | p[80]  | p[79]  | p[78]  | p[76]  | p[74]  | p[73]
               | p[72]  | p[67]  | p[64]  | p[53]  | p[45]  | p[37];

assign pl[13]  = p[241] | p[237] | p[236] | p[235] | p[234] | p[233] | p[232] | p[231] | p[230] | p[229]
               | p[227] | p[225] | p[223] | p[222] | p[219] | p[218] | p[216] | p[214] | p[213] | p[211]
               | p[210] | p[209] | p[207] | p[204] | p[203] | p[201] | p[200] | p[198] | p[197] | p[195]
               | p[190] | p[189] | p[186] | p[183] | p[180] | p[179] | p[174] | p[173] | p[171] | p[170]
               | p[167] | p[164] | p[160] | p[159] | p[158] | p[157] | p[156] | p[155] | p[154] | p[153]
               | p[152] | p[151] | p[149] | p[148] | p[146] | p[143] | p[142] | p[138] | p[137] | p[133]
               | p[132] | p[129] | p[128] | p[127] | p[126] | p[124] | p[123] | p[122] | p[118] | p[117]
               | p[115] | p[113] | p[110] | p[108] | p[106] | p[104] | p[103] | p[102] | p[101] | p[97]
               | p[96]  | p[95]  | p[90]  | p[88]  | p[85]  | p[84]  | p[82]  | p[75]  | p[61]  | p[59];

assign pl[14]  = p[249] | p[248] | p[247] | p[246] | p[245] | p[243] | p[241] | p[239] | p[237] | p[236]
               | p[235] | p[234] | p[231] | p[230] | p[229] | p[228] | p[227] | p[225] | p[224] | p[223]
               | p[222] | p[218] | p[217] | p[214] | p[213] | p[211] | p[209] | p[201] | p[197] | p[195]
               | p[193] | p[191] | p[189] | p[188] | p[186] | p[185] | p[183] | p[181] | p[180] | p[178]
               | p[176] | p[174] | p[172] | p[170] | p[169] | p[167] | p[161] | p[160] | p[159] | p[158]
               | p[157] | p[155] | p[154] | p[153] | p[152] | p[151] | p[150] | p[149] | p[147] | p[146]
               | p[143] | p[142] | p[137] | p[135] | p[133] | p[132] | p[130] | p[127] | p[124] | p[123]
               | p[119] | p[118] | p[116] | p[114] | p[113] | p[112] | p[110] | p[107] | p[106] | p[104]
               | p[103] | p[102] | p[97]  | p[96]  | p[95]  | p[93]  | p[91]  | p[89]  | p[87]  | p[83]
               | p[71]  | p[67]  | p[60]  | p[39]  | p[21]  | p[17]  | p[13];

assign pl[15]  = p[246] | p[239] | p[237] | p[225] | p[224] | p[223] | p[220] | p[217] | p[216] | p[215]
               | p[213] | p[211] | p[210] | p[209] | p[208] | p[207] | p[206] | p[205] | p[203] | p[202]
               | p[200] | p[199] | p[192] | p[191] | p[187] | p[183] | p[182] | p[174] | p[171] | p[160]
               | p[159] | p[155] | p[152] | p[150] | p[146] | p[142] | p[130] | p[126] | p[114] | p[111]
               | p[108] | p[107] | p[105] | p[103] | p[98]  | p[96]  | p[93]  | p[89]  | p[87]  | p[83]
               | p[81]  | p[78]  | p[67]  | p[64]  | p[60]  | p[59]  | p[47]  | p[19];

assign pl[16]  = p[249] | p[246] | p[241] | p[239] | p[235] | p[234] | p[233] | p[232] | p[231] | p[229]
               | p[228] | p[227] | p[226] | p[225] | p[224] | p[223] | p[221] | p[220] | p[219] | p[218]
               | p[217] | p[216] | p[215] | p[214] | p[213] | p[212] | p[210] | p[209] | p[208] | p[207]
               | p[206] | p[205] | p[204] | p[202] | p[200] | p[198] | p[197] | p[195] | p[194] | p[193]
               | p[192] | p[190] | p[188] | p[187] | p[186] | p[185] | p[181] | p[180] | p[179] | p[178]
               | p[176] | p[175] | p[174] | p[172] | p[171] | p[167] | p[166] | p[165] | p[164] | p[162]
               | p[161] | p[160] | p[159] | p[157] | p[155] | p[154] | p[152] | p[150] | p[149] | p[148]
               | p[147] | p[146] | p[144] | p[143] | p[142] | p[139] | p[137] | p[135] | p[132] | p[130]
               | p[129] | p[127] | p[126] | p[125] | p[124] | p[123] | p[121] | p[119] | p[118] | p[115]
               | p[114] | p[113] | p[112] | p[111] | p[107] | p[106] | p[105] | p[104] | p[103] | p[99]
               | p[97]  | p[96]  | p[95]  | p[91]  | p[89]  | p[88]  | p[87]  | p[86]  | p[85]  | p[84]
               | p[83]  | p[81]  | p[79]  | p[65]  | p[60]  | p[55]  | p[54]  | p[47]  | p[34]  | p[22]
               | p[16];

assign pl[17]  = p[249] | p[248] | p[247] | p[246] | p[244] | p[242] | p[241] | p[239] | p[238] | p[228]
               | p[226] | p[225] | p[224] | p[223] | p[217] | p[216] | p[215] | p[212] | p[207] | p[198]
               | p[195] | p[194] | p[193] | p[191] | p[188] | p[185] | p[181] | p[178] | p[176] | p[172]
               | p[171] | p[160] | p[158] | p[157] | p[156] | p[147] | p[144] | p[135] | p[128] | p[126]
               | p[125] | p[115] | p[112] | p[111] | p[99]  | p[93]  | p[90]  | p[88]  | p[87]  | p[85]
               | p[81]  | p[80]  | p[67]  | p[53]  | p[45]  | p[38]  | p[34]  | p[22]  | p[20]  | p[18]
               | p[9];

assign pl[18]  = p[233] | p[226] | p[188] | p[178] | p[165] | p[147] | p[138] | p[123] | p[115] | p[112]
               | p[88]  | p[85]  | p[68]  | p[57]  | p[25]  | p[17]  | p[3];

assign pl[19]  = p[241] | p[239] | p[237] | p[236] | p[233] | p[232] | p[229] | p[225] | p[224] | p[223]
               | p[222] | p[220] | p[219] | p[218] | p[217] | p[207] | p[206] | p[204] | p[200] | p[198]
               | p[195] | p[193] | p[192] | p[191] | p[190] | p[189] | p[188] | p[186] | p[185] | p[182]
               | p[181] | p[180] | p[179] | p[178] | p[176] | p[175] | p[174] | p[170] | p[165] | p[163]
               | p[162] | p[161] | p[158] | p[157] | p[156] | p[154] | p[153] | p[151] | p[149] | p[148]
               | p[147] | p[146] | p[143] | p[137] | p[135] | p[133] | p[129] | p[128] | p[127] | p[125]
               | p[123] | p[122] | p[119] | p[118] | p[117] | p[115] | p[114] | p[112] | p[107] | p[104]
               | p[98]  | p[97]  | p[93]  | p[92]  | p[91]  | p[90]  | p[89]  | p[88]  | p[87]  | p[85]
               | p[83]  | p[82]  | p[80]  | p[78]  | p[76]  | p[74]  | p[73]  | p[72]  | p[69]  | p[67]
               | p[66]  | p[65]  | p[64]  | p[63]  | p[60]  | p[53]  | p[47]  | p[21]  | p[17]  | p[13];

assign pl[20]  = p[237] | p[226] | p[225] | p[222] | p[218] | p[216] | p[214] | p[213] | p[212] | p[211]
               | p[210] | p[207] | p[200] | p[198] | p[192] | p[189] | p[187] | p[174] | p[171] | p[165]
               | p[164] | p[163] | p[160] | p[159] | p[157] | p[152] | p[142] | p[126] | p[124] | p[117]
               | p[115] | p[114] | p[113] | p[104] | p[100] | p[85]  | p[79]  | p[75]  | p[54]  | p[52]
               | p[50]  | p[49]  | p[47]  | p[43]  | p[39]  | p[36]  | p[35]  | p[32]  | p[30]  | p[29]
               | p[28]  | p[27]  | p[24]  | p[23]  | p[14]  | p[12]  | p[10]  | p[7]   | p[6]   | p[5]
               | p[4]   | p[2];

assign pl[21]  = p[230] | p[229] | p[223] | p[220] | p[214] | p[211] | p[208] | p[206] | p[201] | p[178]
               | p[166] | p[154] | p[147] | p[139] | p[123] | p[112] | p[105] | p[80]  | p[3];

assign pl[22]  = p[230] | p[229] | p[220] | p[214] | p[211] | p[208] | p[206] | p[201] | p[188] | p[178]
               | p[175] | p[166] | p[154] | p[153] | p[149] | p[148] | p[147] | p[139] | p[137] | p[129]
               | p[123] | p[112] | p[105] | p[90]  | p[82]  | p[80];

assign pl[23]  = p[246] | p[239] | p[228] | p[225] | p[224] | p[222] | p[216] | p[215] | p[213] | p[210]
               | p[207] | p[205] | p[203] | p[202] | p[200] | p[199] | p[198] | p[194] | p[193] | p[192]
               | p[189] | p[187] | p[185] | p[183] | p[181] | p[176] | p[175] | p[174] | p[173] | p[172]
               | p[171] | p[170] | p[168] | p[164] | p[161] | p[160] | p[157] | p[152] | p[150] | p[144]
               | p[142] | p[135] | p[130] | p[126] | p[125] | p[124] | p[116] | p[115] | p[111] | p[110]
               | p[108] | p[104] | p[102] | p[101] | p[99]  | p[91]  | p[89]  | p[83]  | p[81]  | p[73]
               | p[60]  | p[59];

assign pl[24]  = p[246] | p[244] | p[242] | p[241] | p[239] | p[238] | p[237] | p[236] | p[235] | p[234]
               | p[233] | p[232] | p[231] | p[230] | p[229] | p[228] | p[227] | p[226] | p[222] | p[220]
               | p[219] | p[218] | p[214] | p[212] | p[208] | p[207] | p[206] | p[205] | p[204] | p[202]
               | p[201] | p[200] | p[199] | p[198] | p[197] | p[194] | p[193] | p[192] | p[190] | p[188]
               | p[186] | p[182] | p[181] | p[180] | p[179] | p[178] | p[175] | p[174] | p[173] | p[172]
               | p[170] | p[167] | p[166] | p[165] | p[162] | p[159] | p[158] | p[156] | p[155] | p[154]
               | p[153] | p[152] | p[151] | p[150] | p[149] | p[148] | p[147] | p[146] | p[143] | p[142]
               | p[138] | p[137] | p[135] | p[133] | p[129] | p[128] | p[127] | p[126] | p[124] | p[123]
               | p[122] | p[118] | p[116] | p[115] | p[114] | p[113] | p[112] | p[110] | p[107] | p[106]
               | p[103] | p[99]  | p[98]  | p[97]  | p[95]  | p[90]  | p[88]  | p[87]  | p[85]  | p[82]
               | p[81]  | p[80]  | p[78]  | p[76]  | p[73]  | p[72]  | p[69]  | p[66]  | p[65]  | p[64]
               | p[63]  | p[59]  | p[53]  | p[37];

assign pl[25]  = p[241] | p[236] | p[235] | p[234] | p[233] | p[231] | p[229] | p[223] | p[221] | p[218]
               | p[216] | p[213] | p[211] | p[210] | p[209] | p[207] | p[200] | p[198] | p[186] | p[180]
               | p[179] | p[171] | p[167] | p[166] | p[164] | p[163] | p[162] | p[159] | p[157] | p[155]
               | p[152] | p[146] | p[143] | p[142] | p[133] | p[132] | p[128] | p[127] | p[126] | p[124]
               | p[123] | p[122] | p[113] | p[101] | p[96]  | p[86]  | p[75]  | p[68]  | p[61]  | p[58]
               | p[55] | p[40];

assign pl[26]  = p[241] | p[236] | p[234] | p[233] | p[231] | p[229] | p[227] | p[223] | p[220] | p[218]
               | p[216] | p[214] | p[213] | p[210] | p[209] | p[207] | p[206] | p[200] | p[197] | p[186]
               | p[180] | p[179] | p[174] | p[171] | p[167] | p[157] | p[155] | p[148] | p[146] | p[143]
               | p[133] | p[127] | p[126] | p[123] | p[117] | p[113] | p[104] | p[92]  | p[86]  | p[85]
               | p[84]  | p[71]  | p[68]  | p[61]  | p[55]  | p[51]  | p[48]  | p[46];

assign pl[27]  = p[246] | p[241] | p[239] | p[234] | p[233] | p[231] | p[230] | p[229] | p[228] | p[225]
               | p[224] | p[222] | p[216] | p[214] | p[213] | p[210] | p[209] | p[207] | p[205] | p[202]
               | p[200] | p[199] | p[197] | p[195] | p[193] | p[189] | p[185] | p[183] | p[181] | p[180]
               | p[176] | p[172] | p[171] | p[170] | p[163] | p[161] | p[160] | p[159] | p[155] | p[152]
               | p[144] | p[143] | p[142] | p[138] | p[135] | p[127] | p[126] | p[125] | p[124] | p[123]
               | p[115] | p[113] | p[111] | p[110] | p[108] | p[102] | p[99]  | p[96]  | p[94]  | p[92]
               | p[91]  | p[89]  | p[88]  | p[84]  | p[83]  | p[81]  | p[77]  | p[71]  | p[69]  | p[68]
               | p[65]  | p[62]  | p[60]  | p[59]  | p[58]  | p[56]  | p[42]  | p[26]  | p[11];

assign pl[28]  = p[246] | p[243] | p[239] | p[237] | p[236] | p[235] | p[234] | p[233] | p[231] | p[230]
               | p[229] | p[228] | p[227] | p[225] | p[224] | p[222] | p[219] | p[214] | p[213] | p[211]
               | p[209] | p[205] | p[202] | p[201] | p[199] | p[195] | p[193] | p[190] | p[189] | p[185]
               | p[183] | p[181] | p[180] | p[176] | p[174] | p[172] | p[170] | p[163] | p[161] | p[160]
               | p[157] | p[156] | p[155] | p[153] | p[152] | p[143] | p[142] | p[135] | p[128] | p[127]
               | p[125] | p[122] | p[113] | p[110] | p[104] | p[102] | p[101] | p[96]  | p[91]  | p[89]
               | p[84]  | p[83]  | p[75]  | p[71]  | p[70]  | p[60]  | p[58]  | p[41]  | p[40];

assign pl[29]  = p[237] | p[235] | p[234] | p[230] | p[227] | p[224] | p[222] | p[217] | p[216] | p[215]
               | p[214] | p[211] | p[210] | p[207] | p[203] | p[200] | p[197] | p[195] | p[192] | p[191]
               | p[189] | p[187] | p[176] | p[174] | p[171] | p[170] | p[161] | p[159] | p[155] | p[144]
               | p[139] | p[132] | p[126] | p[124] | p[119] | p[118] | p[115] | p[114] | p[113] | p[111]
               | p[110] | p[108] | p[107] | p[101] | p[99]  | p[96]  | p[93]  | p[91]  | p[88]  | p[87]
               | p[81]  | p[75]  | p[69]  | p[67]  | p[66]  | p[59]  | p[53]  | p[47];

assign pl[30]  = p[233] | p[232] | p[231] | p[230] | p[229] | p[225] | p[223] | p[222] | p[221] | p[220]
               | p[219] | p[211] | p[209] | p[208] | p[206] | p[204] | p[198] | p[197] | p[190] | p[189]
               | p[180] | p[179] | p[175] | p[168] | p[166] | p[165] | p[164] | p[160] | p[156] | p[150]
               | p[139] | p[138] | p[118] | p[117] | p[106] | p[105] | p[96]  | p[95]  | p[86]  | p[61];

assign pl[31]  = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[242] | p[241] | p[239] | p[238]
               | p[236] | p[234] | p[233] | p[232] | p[230] | p[229] | p[228] | p[227] | p[225] | p[224]
               | p[222] | p[219] | p[212] | p[209] | p[204] | p[198] | p[195] | p[193] | p[190] | p[189]
               | p[186] | p[185] | p[183] | p[181] | p[180] | p[179] | p[176] | p[175] | p[172] | p[170]
               | p[168] | p[167] | p[165] | p[164] | p[160] | p[157] | p[156] | p[155] | p[150] | p[146]
               | p[144] | p[143] | p[140] | p[138] | p[135] | p[134] | p[130] | p[117] | p[110] | p[102]
               | p[99]  | p[92];

assign pl[32]  = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[242] | p[241] | p[239] | p[238]
               | p[236] | p[234] | p[233] | p[232] | p[231] | p[229] | p[228] | p[227] | p[224] | p[220]
               | p[219] | p[212] | p[209] | p[206] | p[204] | p[198] | p[195] | p[193] | p[190] | p[186]
               | p[185] | p[183] | p[181] | p[180] | p[179] | p[176] | p[175] | p[172] | p[170] | p[168]
               | p[167] | p[165] | p[164] | p[157] | p[156] | p[155] | p[150] | p[146] | p[144] | p[141]
               | p[139] | p[138] | p[136] | p[135] | p[130] | p[118] | p[117] | p[110] | p[102] | p[99]
               | p[96]  | p[95]  | p[92];

assign pl[33]  = p[249] | p[248] | p[247] | p[246] | p[245] | p[244] | p[242] | p[241] | p[239] | p[238]
               | p[236] | p[235] | p[234] | p[231] | p[228] | p[227] | p[220] | p[212] | p[208] | p[206]
               | p[198] | p[197] | p[195] | p[193] | p[183] | p[176] | p[175] | p[172] | p[168] | p[167]
               | p[166] | p[165] | p[164] | p[157] | p[155] | p[146] | p[144] | p[143] | p[135] | p[131]
               | p[130] | p[118] | p[117] | p[109] | p[105] | p[99]  | p[95];
endmodule

//______________________________________________________________________________
//
// Interrupt priority matrix input description:
//
//    rq[0]    - psw[10]
//    rq[1]    - feedback - output  sp[4] (pli4r net)
//    rq[2]    - psw[11]
//    rq[3]    - unknown opcode error
//    rq[4]    - psw[7] interrupt priority/disable
//    rq[5]    - unused (former some error 2 request)
//    rq[6]    - unused (former start request)
//    rq[7]    - unused (former some error 3 request)
//    rq[8]    - vectored interrupt request (low active)
//    rq[9]    - normal qbus timeout trap or odd address
//    rq[10]   - double error trap
//    rq[11]   - nACLO falling edge detector (nACLO failed)
//    rq[12]   - wait mode (bit 2 of mode register 177700)
//    rq[13]   - nACLO raising edge detector (nACLO restored)
//    rq[14]   - radial interrupt request IRQ1
//    rq[15]   - psw[4] T-bit
//    rq[16]   - radial interrupt request IRQ2
//    rq[17]   - vector fetch qbus timeout
//    rq[18]   - radial interrupt request IRQ3
//    rq[19]   - VM1 unused, VM1G VE-timer request
//
// Interrupt priority matrix output description:
//
//    sp[0]    - vector generator selector  bit 0
//    sp[1]    - vector generator selector  bit 1
//    sp[2]    - vector generator selector ~bit 2
//    sp[3]    - vector generator selector  bit 3
//    sp[4]    - feedback to priority matrix - plir
//
//    sp[6]    - controls the request detectors rearm
//    sp[8]    - controls the request detectors rearm
//    sp[10]   - controls the request detectors rearm
//
// 3'b000:  - undefined operation detector rearm
// 3'b001:  - IRQ3 edge detector rearm
// 3'b011:  - IRQ2 edge detector rearm
// 3'b100:  - ACLO rise/fall edges detector rearm
// 3'b101:  - VE-timer interrupt rearm
//
//    sp[5]    - goes to the main microcode register ~mj[14]
//    sp[7]    - goes to the main microcode register ~mj[13]
//    sp[9]    - goes to the main microcode register  mj[12]
//
// On schematics vsel is {pli[3], ~pli[2], pli[1], pli[0]}
//
// 4'b0000: vmux = 16'o160006;      // double error
// 4'b0001: vmux = 16'o000020;      // IOT instruction      (0001 never generated by matrix A/G)
// 4'b0010: vmux = 16'o000010;      // reserved opcode
// 4'b0011: vmux = 16'o000014;      // T-bit trap
// 4'b0100: vmux = 16'o000004;      // invalid opcode
// 4'b0101:                         // or qbus timeout
//    case (pa[1:0])                // initial start
//       2'b00: vmux = 16'o177716;  // register base
//       2'b01: vmux = 16'o177736;  // depends on
//       2'b10: vmux = 16'o177756;  // processor number
//       2'b10: vmux = 16'o177776;  //
//    endcase                       //
// 4'b0110: vmux = 16'o000030;      // EMT instruction      (0110 never generated by matrix A/G)
// 4'b0111: vmux = 16'o160012;      // int ack timeout
// 4'b1000: vmux = 16'o000270;      // IRQ3 falling edge
// 4'b1001: vmux = 16'o000024;      // ACLO falling edge
// 4'b1010: vmux = 16'o000100;      // IRQ2 falling edge
// 4'b1011: vmux = 16'o160002;      // IRQ1 low level/HALT
// 4'b1100: vmux = 16'o000034;      // TRAP instruction     (1100 never generated by matrix A/G)
// 4'b1101: vmux = vreg;            // vector register      (1101 never generated by matrix A/G)
// 4'b1110: vmux = svec;            // start @177704        (1110 never generated by matrix A/G)
// 4'b1111: vmux = 16'o000000;      // unused vector
//
//______________________________________________________________________________
//
// 1801VM1A interrupt matrix
//
module vm1a_pli
(
   input  [19:0]  rq,
   output [10:0]  sp
);
wire [20:0] p;
wire [10:0] pl;
wire [3:1]  irq;
wire [11:4] psw;
wire  virq;
wire  plir, uerr;
wire  wcpu, dble;
wire  acok, aclo;    // ACLO detector requests
wire  iato, qbto;    // qbus timeouts and odd address

assign psw[10] = rq[0];
assign plir    = rq[1];
assign psw[11] = rq[2];
assign uerr    = rq[3];
assign psw[7]  = rq[4];
assign virq    = rq[8];       // low active level
assign qbto    = rq[9];
assign dble    = rq[10];
assign aclo    = rq[11];
assign wcpu    = rq[12];
assign acok    = rq[13];
assign irq[1]  = rq[14];
assign psw[4]  = rq[15];
assign irq[2]  = rq[16];
assign iato    = rq[17];
assign irq[3]  = rq[18];

//______________________________________________________________________________
//
// wcpu = 0, simplified matrix to demostrate priority encoding
//
//                          iato   &  qbto;
//                         ~iato   &  qbto &  dble;
//    psw[11]            & ~iato   &  qbto & ~dble;
//               psw[10] & ~iato   &  qbto & ~dble;
//   ~psw[11] & ~psw[10] & ~iato   &  qbto & ~dble;
//
//                                   ~qbto &  uerr;
//              ~psw[10] &  psw[4] & ~qbto & ~uerr;
//              ~psw[10] & ~psw[4] & ~qbto & ~uerr &  aclo;
//   ~psw[11] & ~psw[10] & ~psw[4] & ~qbto & ~uerr & ~aclo           &  irq[1];
//              ~psw[10] & ~psw[4] & ~qbto & ~uerr & ~aclo & ~psw[7] & ~irq[1] &  irq[2];
//              ~psw[10] & ~psw[4] & ~qbto & ~uerr & ~aclo & ~psw[7] & ~irq[1] & ~irq[2] &  irq[3];
//              ~psw[10] & ~psw[4] & ~qbto & ~uerr & ~aclo & ~psw[7] & ~irq[1] & ~irq[2] & ~irq[3] & ~virq;
//
assign p[0]    =  plir                                 & ~qbto & ~aclo & ~uerr &  wcpu           & ~irq[1] & ~irq[2] & ~irq[3] &  virq;
assign p[10]   =  plir            & ~psw[10]           & ~qbto & ~aclo & ~uerr &  wcpu           & ~irq[1];
assign p[3]    =  plir & ~psw[11] & ~psw[10] &  psw[4] & ~qbto & ~aclo & ~uerr &  wcpu           &  irq[1];
assign p[2]    =  plir & ~psw[11] & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr                   &  irq[1];
assign p[1]    =  plir            & ~psw[10]           & ~qbto & ~aclo & ~uerr &  wcpu & ~psw[7] & ~irq[1] &  irq[2];
assign p[7]    =  plir            & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr         & ~psw[7] & ~irq[1] &  irq[2];
assign p[6]    =  plir            & ~psw[10] &  psw[4] & ~qbto & ~aclo & ~uerr &  wcpu & ~psw[7] & ~irq[1] & ~irq[2] &  irq[3];
assign p[9]    =  plir            & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr         & ~psw[7] & ~irq[1] & ~irq[2] &  irq[3];
assign p[4]    =  plir            & ~psw[10] &  psw[4] & ~qbto & ~aclo & ~uerr &  wcpu & ~psw[7] & ~irq[1] & ~irq[2] & ~irq[3] & ~virq;
assign p[5]    =  plir            & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr         & ~psw[7] & ~irq[1] & ~irq[2] & ~irq[3] & ~virq;
assign p[11]   =  plir            & ~psw[10] & ~psw[4] & ~qbto &  aclo & ~uerr;
assign p[12]   =  plir            & ~psw[10] &  psw[4] & ~qbto         & ~uerr & ~wcpu;
assign p[13]   =  plir            & ~psw[10] &  psw[4] & ~qbto &  aclo & ~uerr &  wcpu;
assign p[20]   =  plir & ~psw[11] & ~psw[10] & ~iato   &  qbto & ~dble;
assign p[14]   =  plir &  psw[11]            & ~iato   &  qbto & ~dble;
assign p[18]   =  plir            &  psw[10] & ~iato   &  qbto & ~dble;
assign p[19]   =  plir                       & ~iato   &  qbto &  dble;
assign p[16]   =  plir                       &  iato   &  qbto;
assign p[15]   =  plir                       &  uerr   & ~qbto;
assign p[8]    = ~plir & ~acok;
assign p[17]   = ~plir &  acok;

assign sp      = ~pl;
assign pl[0]   = p[20] | p[19] | p[15] | p[9]  | p[7]  | p[6]  | p[1];
assign pl[1]   = p[20] | p[19] | p[17] | p[13] | p[11] | p[9]  | p[6];
assign pl[2]   = p[20] | p[17] | p[16] | p[5]  | p[4];
assign pl[3]   = p[20] | p[19] | p[17] | p[16] | p[15] | p[12];
assign pl[4]   = p[8];
assign pl[5]   = p[20] | p[17] | p[15] | p[13] | p[12] | p[11] | p[9]  | p[7]  | p[6]  | p[5]  | p[4] | p[1];
assign pl[7]   = p[19] | p[18] | p[17] | p[16] | p[14] | p[3]  | p[2];
assign pl[9]   = p[14] | p[13] | p[12] | p[11] | p[10] | p[9]  | p[8]  | p[7]  | p[5]  | p[3]  | p[2] | p[0];
assign pl[6]   = p[20] | p[19] | p[18] |         p[16] | p[15] | p[14] | p[12] | p[10] | p[9]  | p[7] | p[5];
assign pl[8]   = p[20] | p[19] | p[18] | p[17] | p[16] | p[15] | p[14] | p[13] | p[11] | p[9]  | p[6];
assign pl[10]  = p[20] | p[19] | p[18] | p[17] | p[16] | p[15] | p[14] | p[13] | p[12] | p[11] | p[5] | p[4];
endmodule

//______________________________________________________________________________
//
// 1801VM1G interrupt matrix
//
module vm1g_pli
(
   input  [19:0]  rq,
   output [10:0]  sp
);
wire [21:0] p;
wire [10:0] pl;
wire [3:1]  irq;
wire [11:4] psw;
wire  virq;
wire  plir, uerr;
wire  wcpu, dble;
wire  acok, aclo;    // ACLO detector requests
wire  iato, qbto;    // qbus timeouts and odd address
wire  tve;

assign psw[10] = rq[0];
assign plir    = rq[1];
assign psw[11] = rq[2];
assign uerr    = rq[3];
assign psw[7]  = rq[4];
assign virq    = rq[8];       // low active level
assign qbto    = rq[9];
assign dble    = rq[10];
assign aclo    = rq[11];
assign wcpu    = rq[12];      // low active level
assign acok    = rq[13];
assign irq[1]  = rq[14];
assign psw[4]  = rq[15];
assign irq[2]  = rq[16];
assign iato    = rq[17];
assign irq[3]  = rq[18];
assign tve     = rq[19];

//______________________________________________________________________________
//
// wcpu = 0, simplified matrix to demostrate priority encoding
//
//                            &  iato   &  qbto;
//                            & ~iato   &  qbto &  dble;
//         psw[11]            & ~iato   &  qbto & ~dble;
//                 &  psw[10] & ~iato   &  qbto & ~dble;
//        ~psw[11] & ~psw[10] & ~iato   &  qbto & ~dble;
//
//                               uerr   & ~qbto;
//                   ~psw[10] &  psw[4] & ~qbto         & ~uerr;
//                   ~psw[10] & ~psw[4] & ~qbto &  aclo & ~uerr;
//        ~psw[11] & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr           &  irq[1];
//  tve &          & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr & ~psw[7] & ~irq[1];
// ~tve &          & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr & ~psw[7] & ~irq[1] &  irq[2];
// ~tve &          & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr & ~psw[7] & ~irq[1] & ~irq[2] &  irq[3];
// ~tve &          & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr & ~psw[7] & ~irq[1] & ~irq[2] & ~irq[3] & ~virq;
//
assign p[0]    =  ~tve & plir                                 & ~qbto & ~aclo & ~uerr &  wcpu           & ~irq[1] & ~irq[2] & ~irq[3] &  virq;
assign p[10]   =         plir            & ~psw[10]           & ~qbto         & ~uerr &  wcpu           & ~irq[1];
assign p[4]    =         plir            & ~psw[10] &  psw[4] & ~qbto         & ~uerr &  wcpu           &  irq[1];
assign p[1]    =         plir & ~psw[11] & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr                   &  irq[1];
assign p[6]    =   tve & plir            & ~psw[10] &  psw[4] & ~qbto         & ~uerr &  wcpu & ~psw[7] & ~irq[1];
assign p[8]    =   tve & plir            & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr         & ~psw[7] & ~irq[1];
assign p[13]   =  ~tve & plir            & ~psw[10] &  psw[4] & ~qbto         & ~uerr &  wcpu & ~psw[7] & ~irq[1] &  irq[2];
assign p[3]    =  ~tve & plir            & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr         & ~psw[7] & ~irq[1] &  irq[2];
assign p[14]   =  ~tve & plir            & ~psw[10] &  psw[4] & ~qbto         & ~uerr &  wcpu & ~psw[7] & ~irq[1] & ~irq[2] &  irq[3];
assign p[9]    =  ~tve & plir            & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr         & ~psw[7] & ~irq[1] & ~irq[2] &  irq[3];
assign p[2]    =  ~tve & plir            & ~psw[10] &  psw[4] & ~qbto         & ~uerr &  wcpu & ~psw[7] & ~irq[1] & ~irq[2] & ~irq[3] & ~virq;
assign p[5]    =  ~tve & plir            & ~psw[10] & ~psw[4] & ~qbto & ~aclo & ~uerr         & ~psw[7] & ~irq[1] & ~irq[2] & ~irq[3] & ~virq;
assign p[11]   =         plir            & ~psw[10] &  psw[4] & ~qbto         & ~uerr & ~wcpu;
assign p[12]   =         plir            & ~psw[10] & ~psw[4] & ~qbto &  aclo & ~uerr;
assign p[21]   =         plir & ~psw[11] & ~psw[10] & ~iato   &  qbto & ~dble;
assign p[15]   =         plir &  psw[11]            & ~iato   &  qbto & ~dble;
assign p[19]   =         plir            &  psw[10] & ~iato   &  qbto & ~dble;
assign p[20]   =         plir                       & ~iato   &  qbto &  dble;
assign p[17]   =         plir                       &  iato   &  qbto;
assign p[16]   =         plir                       &  uerr   & ~qbto;
assign p[7]    =        ~plir & ~acok;
assign p[18]   =        ~plir &  acok;

assign sp      = ~pl;
assign pl[0]   = p[21] | p[20] | p[16] | p[14] | p[13] | p[9] | p[8] | p[6] | p[3] | p[2];
assign pl[1]   = p[21] | p[20] | p[18] | p[14] | p[12] | p[9] | p[8] | p[6];
assign pl[2]   = p[21] | p[18] | p[17] | p[5] | p[2];
assign pl[3]   = p[21] | p[20] | p[18] | p[17] | p[16] | p[11];
assign pl[4]   = p[7];
assign pl[5]   = p[21] | p[18] | p[16] | p[14] | p[13] | p[12] | p[11] | p[9] | p[8] | p[6] | p[5] | p[3] | p[2];
assign pl[6]   = p[21] | p[20] | p[19] | p[17] | p[16] | p[15] | p[14] | p[13] | p[11] | p[9] | p[5] | p[3] | p[2];
assign pl[7]   = p[20] | p[19] | p[18] | p[17] | p[15] | p[4] | p[1];
assign pl[8]   = p[21] | p[20] | p[19] | p[18] | p[17] | p[16] | p[15] | p[14] | p[12] | p[9] | p[8] | p[6];
assign pl[9]   = p[14] | p[13] | p[12] | p[11] | p[10] | p[9] | p[8] | p[7] | p[5] | p[4] | p[3] | p[1] | p[0];
assign pl[10]  = p[21] | p[20] | p[19] | p[18] | p[17] | p[16] | p[15] | p[12] | p[11] | p[5] | p[2];
endmodule
