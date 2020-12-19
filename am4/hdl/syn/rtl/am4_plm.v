//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// M4 processor PDP-11 instruction decoding PLM (D123, D136)
//
module plm_dec
(
   input  [15:0] ins,      // PDP-11 instruction opcode
   output reg bf,          // byte operation flag
   output reg [6:0] ad     // address of microcode
);

wire rs = ins[11:9] == 3'b000;
wire rd = ins[5:3] == 3'b000;

always @(*)
casex(ins)                 // clrb/comb/incb/decb
   16'o105xxx: bf = 1'b1;  // negb/adcb/sbcb/tstb
   16'o1060xx: bf = 1'b1;  // rorb
   16'o1061xx: bf = 1'b1;  // rolb
   16'o1062xx: bf = 1'b1;  // asrb
   16'o1063xx: bf = 1'b1;  // aslb
   16'o1064xx: bf = 1'b1;  // mtps
   16'o1067xx: bf = 1'b1;  // mfps
   16'o11xxxx: bf = 1'b1;  // movb
   16'o12xxxx: bf = 1'b1;  // cmpb
   16'o13xxxx: bf = 1'b1;  // bitb
   16'o14xxxx: bf = 1'b1;  // bicb
   16'o15xxxx: bf = 1'b1;  // bisb
   default: bf = 1'b0;
endcase

always @(*)
casex(ins)
   16'o000000: ad = 7'h00; // halt
   16'o000001: ad = 7'h03; // wait
   16'o000002: ad = 7'h02; // rti
   16'o000003: ad = 7'h04; // bpt
   16'o000004: ad = 7'h07; // iot
   16'o000005: ad = 7'h06; // reset
   16'o000006: ad = 7'h02; // rtt
   16'o0001xx: ad = 7'h0E; // jmp
   16'o00020x: ad = 7'h36; // rts
   16'o00024x: ad = 7'h40; // clx
   16'o00025x: ad = 7'h40; // clx
   16'o00026x: ad = 7'h43; // sex
   16'o00027x: ad = 7'h43; // sex
   16'o0003xx: ad = ~rd ? 7'h41  // swab
/* 16'o00030x: */       : 7'h44; // swab Rd
   16'o0004xx: ad = 7'h1F; // br
   16'o0005xx: ad = 7'h1F; //
   16'o0006xx: ad = 7'h1F; //
   16'o0007xx: ad = 7'h1F; //
   16'o001xxx: ad = 7'h1F; // bne/beq
   16'o002xxx: ad = 7'h1F; // bge/blt
   16'o003xxx: ad = 7'h1F; // bgt/ble
   16'o004xxx: ad = 7'h37; // jsr
                           //
   16'o0050xx: ad = ~rd ? 7'h12  // clr
/* 16'o00500x: */       : 7'h22; // clr Rd
   16'o0051xx: ad = ~rd ? 7'h14  // com
/* 16'o00510x: */       : 7'h24; // com Rd
   16'o0052xx: ad = ~rd ? 7'h16  // inc
/* 16'o00520x: */       : 7'h26; // inc Rd
   16'o0053xx: ad = ~rd ? 7'h18  // dec
/* 16'o00530x: */       : 7'h28; // dec Rd
   16'o0054xx: ad = ~rd ? 7'h1A  // neg
/* 16'o00540x: */       : 7'h2A; // neg Rd
   16'o0055xx: ad = ~rd ? 7'h0D  // adc
/* 16'o00550x: */       : 7'h4D; // adc Rd
   16'o0056xx: ad = ~rd ? 7'h53  // sbc
/* 16'o00560x: */       : 7'h4A; // sbc Rd
   16'o0057xx: ad = ~rd ? 7'h2C  // tst
/* 16'o00570x: */       : 7'h6C; // tst Rd
   16'o0060xx: ad = ~rd ? 7'h15  // ror
/* 16'o00600x: */       : 7'h55; // ror Rd
   16'o0061xx: ad = ~rd ? 7'h17  // rol
/* 16'o00610x: */       : 7'h56; // rol Rd
   16'o0062xx: ad = ~rd ? 7'h1B  // asr
/* 16'o00620x: */       : 7'h5B; // asr Rd
   16'o0063xx: ad = ~rd ? 7'h1D  // asl
/* 16'o00630x: */       : 7'h5C; // asl Rd
   16'o0064xx: ad = 7'h09; // mark
   16'o0067xx: ad = 7'h08; // sxt
                           //
   16'o01xxxx: ad = (~rs | ~rd) ? 7'h31  // mov
/* 16'o010x0x: */               : 7'h30; // mov Rs, Rd
   16'o02xxxx: ad = (~rs | ~rd) ? 7'h13  // cmp
/* 16'o020x0x: */               : 7'h3A; // cmp Rs, Rd
   16'o03xxxx: ad = (~rs | ~rd) ? 7'h1C  // bit
/* 16'o030x0x: */               : 7'h3C; // bit Rs, Rd
   16'o04xxxx: ad = (~rs | ~rd) ? 7'h1E  // bic
/* 16'o040x0x: */               : 7'h3E; // bic Rs, Rd
   16'o05xxxx: ad = (~rs | ~rd) ? 7'h10  // bis
/* 16'o050x0x: */               : 7'h20; // bis Rs, Rd
   16'o06xxxx: ad = ~rs ? 7'h35 // add
/* 16'o060xxx: */ : ~rd ? 7'h34 // add Rs, xx
/* 16'o060x0x: */ : 7'h74; // add Rs, Rd
   16'o070xxx: ad = 7'h47; // mul
   16'o071xxx: ad = 7'h48; // div
   16'o072xxx: ad = 7'h42; // ash
   16'o073xxx: ad = 7'h45; // ashc
   16'o074xxx: ad = 7'h0B; // xor
   16'o07500x: ad = 7'h0F; // fadd
   16'o07501x: ad = 7'h0F; // fsub
   16'o07502x: ad = 7'h0F; // fmul
   16'o07503x: ad = 7'h0F; // fdiv
   16'o077xxx: ad = 7'h0A; // sob
                           //
   16'o100xxx: ad = 7'h1F; // bpl/bmi
   16'o101xxx: ad = 7'h1F; // bhi/blos
   16'o102xxx: ad = 7'h1F; // bvc/bvs
   16'o103xxx: ad = 7'h1F; // bcc/bcs
   16'o1040xx: ad = 7'h39; // emt
   16'o1041xx: ad = 7'h39; // emt
   16'o1042xx: ad = 7'h39; // emt
   16'o1043xx: ad = 7'h39; // emt
   16'o1044xx: ad = 7'h38; // trap
   16'o1045xx: ad = 7'h38; // trap
   16'o1046xx: ad = 7'h38; // trap
   16'o1047xx: ad = 7'h38; // trap
   16'o1050xx: ad = 7'h25; // clrb
   16'o1051xx: ad = 7'h27; // comb
   16'o1052xx: ad = 7'h29; // incb
   16'o1053xx: ad = 7'h2B; // decb
   16'o1054xx: ad = 7'h2D; // negb
   16'o1055xx: ad = 7'h51; // adcb
   16'o1056xx: ad = 7'h52; // sbcb
   16'o1057xx: ad = 7'h2F; // tstb
   16'o1060xx: ad = 7'h54; // rorb
   16'o1061xx: ad = 7'h59; // rolb
   16'o1062xx: ad = 7'h5A; // asrb
   16'o1063xx: ad = 7'h5F; // aslb
   16'o1064xx: ad = 7'h2E; // mtps
   16'o1067xx: ad = 7'h0C; // mfps
   16'o11xxxx: ad = (~rs | ~rd) ? 7'h33  // movb
/* 16'o110x0x: */               : 7'h32; // movb Rd, Rs
   16'o12xxxx: ad = 7'h3D; // cmpb
   16'o13xxxx: ad = 7'h3F; // bitb
   16'o14xxxx: ad = 7'h21; // bicb
   16'o15xxxx: ad = 7'h23; // bisb
   16'o16xxxx: ad = (~rs | ~rd) ? 7'h19  // sub
/* 16'o160x0x: */               : 7'h3B; // sub Rd, Rs
   default:    ad = 7'h01; // undefined
endcase

endmodule
