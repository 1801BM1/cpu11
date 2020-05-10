//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// MCP-1611 Data Chip model, for debug and simulating only
//______________________________________________________________________________
//
module mcp1611
(
   input          pin_clk_p,     // main clock
   input          pin_clk_n,     //
   input          pin_wi,        // wait for ready
   input  [15:0]  pin_mi,        // microbus input
   output [15:0]  pin_mo,        // microbus output
   output         pin_cond,      // condition taken
   input  [15:0]  pin_adi,       // data input bus
   output [15:0]  pin_ado,       // data/address output
   output         pin_astb,      // address strobe
   output         pin_dstb       // data strobe
);

//______________________________________________________________________________
//
genvar   i;             //
                        //
reg  [15:0] dir;        // microinstriction
reg         inpl;       //
wire        m04rs;      // mir 0&4 reset
wire        mo_fa;      //
wire        mo_ad;      //
wire        m_in;       //
reg         addr0;      //
                        //
reg  [7:0]  psw;        // processor status word
wire        wr_f0;      //
wire        wr_f1;      //
wire        wr_f2;      //
wire        wr_f3;      //
wire        wr_f4;      //
                        //
wire        st_fx;      //
wire        st_f0;      //
wire        st_f1;      //
wire        st_f4;      //
wire        st_f6;      //
                        //
reg         jump;       // indirect condition code
wire        jbxx;       // for PDP-11 branch opcodes
wire [10:0] dmi;        // decoded microinstruction
wire [20:0] pl;         // matrix control
                        //
reg  [2:0]  g;          // G register
wire        wr_g0;      // write ALU to G
wire        wr_g1;      // write ad[6:4] to G
wire        wr_g2;      // write ad[8:6] to G
                        //
                        //
reg  [7:0]  r[0:25];    // general register file
wire [7:0]  ra;         // register file port A
wire [7:0]  rb;         // register file port B
wire [25:0] rsela;      // register select A
wire [25:0] rselb;      // register select B
                        //
wire [7:0]  md;         // data multiplexer
wire        mdl_rd;     //
wire        mdh_rd;     //
wire        psw_rd;     //
wire        alu_rd;     //
wire        alu_sh;     //
                        //
wire        f03_wr;     //
wire        f47_wr;     //
reg         fb7z;       //
reg         sb_ext;     // port B sign extension
                        //
wire [7:0]  fa;         // ALU input port A
wire [7:0]  fb;         // ALU input port B
                        //
wire [7:0]  c;          // carry chain
wire [7:0]  ax;         // OR subfunction
wire [7:0]  ay;         // AND subfunction
wire [7:0]  alu;        //
wire        alu_sh8;    // ALU shift-in flag
wire        alu_c;      // ALU flags
wire        alu_v;      //
wire        alu_z;      //
wire        alu_z_c4;   //
wire        alu_n;      //
wire        alu_c8;     //
wire        alu_c4;     //
                        //
//______________________________________________________________________________
//
assign m_in = pl[12] & ~pin_wi;
assign mo_fa = dmi[8] & ~pin_wi;
assign mo_ad = (dir[4] | dir[5]) & dmi[7] & ~pin_wi;

//______________________________________________________________________________
//
// Processor status word (PSW)
//
always @(posedge pin_clk_p)
begin
   if (wr_f4)
   begin
      if (wr_f0) psw[0] <= fa[0];
      if (wr_f1) psw[1] <= fa[1];
      if (wr_f2) psw[2] <= fa[2];
      if (wr_f3) psw[3] <= fa[3];
      psw[7:4] <= fa[7:4];
   end
   else
   begin
      if (st_f0) psw[0] <= alu_c;
      if (st_f1) psw[1] <= alu_v;
      if (st_f1) psw[2] <= alu_z;
      if (st_f1) psw[3] <= alu_n;
      if (st_f4) psw[4] <= alu_c8;
      if (st_f4) psw[5] <= alu_c4;
      if (st_f6) psw[6] <= alu_z;
      if (st_f6) psw[7] <= alu_n;
   end
end

assign st_fx = (psw[0] | ~dmi[1]) & (jump | ~dmi[0]) & ~pin_wi;
assign st_f0 = st_fx & ~pl[7] & ~pl[9] & pl[12];
assign st_f1 = st_fx & ~pl[7] & ~pl[8] & pl[12];
assign st_f4 = st_fx & ~pl[9];
assign st_f6 = st_fx & ~pl[8];

assign wr_f0 = dir[4];
assign wr_f1 = dir[5];
assign wr_f2 = dir[6];
assign wr_f3 = dir[7];
assign wr_f4 = pl[15];

//______________________________________________________________________________
//
// Register G
//
always @(posedge pin_clk_p)
begin
   if (wr_g0)
      g[2:0] <= fa[2:0];
   if (wr_g1)
      g[2:0] <= pin_adi[6:4];
   if (wr_g2)
      g[2:0] <= pin_adi[8:6];
end

assign wr_g0 = ~pin_wi & dmi[9];
assign wr_g1 = ~pin_wi & dmi[7] &  dir[4] & ~dir[5];
assign wr_g2 = ~pin_wi & dmi[7] & ~dir[4] &  dir[5];

//______________________________________________________________________________
//
// Dual-port register file 26x8
//
assign rsela[0]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b000);
assign rsela[1]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b000);
assign rsela[2]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b001);
assign rsela[3]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b001);
assign rsela[4]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b010);
assign rsela[5]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b010);
assign rsela[6]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b011);
assign rsela[7]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b011);
assign rsela[8]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b100);
assign rsela[9]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b100);
assign rsela[10] = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b101);
assign rsela[11] = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b101);

assign rsela[12] = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b111)
                 | (dir[3:0] == 4'b1111);
assign rsela[13] = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b111)
                 | (dir[3:0] == 4'b1110);
assign rsela[14] = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b110)
                 | (dir[3:0] == 4'b1101);
assign rsela[15] = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b110)
                 | (dir[3:0] == 4'b1100);

assign rsela[16] = (dir[3:0] == 4'b1011);
assign rsela[17] = (dir[3:0] == 4'b1010);
assign rsela[18] = (dir[3:0] == 4'b1001);
assign rsela[19] = (dir[3:0] == 4'b1000);
assign rsela[20] = (dir[3:0] == 4'b0111);
assign rsela[21] = (dir[3:0] == 4'b0110);
assign rsela[22] = (dir[3:0] == 4'b0101);
assign rsela[23] = (dir[3:0] == 4'b0100);
assign rsela[24] = (dir[3:0] == 4'b0011);
assign rsela[25] = (dir[3:0] == 4'b0010);

assign rselb[0]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b000);
assign rselb[1]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b000);
assign rselb[2]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b001);
assign rselb[3]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b001);
assign rselb[4]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b010);
assign rselb[5]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b010);
assign rselb[6]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b011);
assign rselb[7]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b011);
assign rselb[8]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b100);
assign rselb[9]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b100);
assign rselb[10] = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b101);
assign rselb[11] = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b101);

assign rselb[12] = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b111)
                 | (dir[7:4] == 4'b1111);
assign rselb[13] = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b111)
                 | (dir[7:4] == 4'b1110);
assign rselb[14] = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b110)
                 | (dir[7:4] == 4'b1101);
assign rselb[15] = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b110)
                 | (dir[7:4] == 4'b1100);

assign rselb[16] = (dir[7:4] == 4'b1011);
assign rselb[17] = (dir[7:4] == 4'b1010);
assign rselb[18] = (dir[7:4] == 4'b1001);
assign rselb[19] = (dir[7:4] == 4'b1000);
assign rselb[20] = (dir[7:4] == 4'b0111);
assign rselb[21] = (dir[7:4] == 4'b0110);
assign rselb[22] = (dir[7:4] == 4'b0101);
assign rselb[23] = (dir[7:4] == 4'b0100);
assign rselb[24] = (dir[7:4] == 4'b0011);
assign rselb[25] = (dir[7:4] == 4'b0010);

assign ra = (rsela[0]  ? r[0]  : 8'h00)
          | (rsela[1]  ? r[1]  : 8'h00)
          | (rsela[2]  ? r[2]  : 8'h00)
          | (rsela[3]  ? r[3]  : 8'h00)
          | (rsela[4]  ? r[4]  : 8'h00)
          | (rsela[5]  ? r[5]  : 8'h00)
          | (rsela[6]  ? r[6]  : 8'h00)
          | (rsela[7]  ? r[7]  : 8'h00)
          | (rsela[8]  ? r[8]  : 8'h00)
          | (rsela[9]  ? r[9]  : 8'h00)
          | (rsela[10] ? r[10] : 8'h00)
          | (rsela[11] ? r[11] : 8'h00)
          | (rsela[12] ? r[12] : 8'h00)
          | (rsela[13] ? r[13] : 8'h00)
          | (rsela[14] ? r[14] : 8'h00)
          | (rsela[15] ? r[15] : 8'h00)
          | (rsela[16] ? r[16] : 8'h00)
          | (rsela[17] ? r[17] : 8'h00)
          | (rsela[18] ? r[18] : 8'h00)
          | (rsela[19] ? r[19] : 8'h00)
          | (rsela[20] ? r[20] : 8'h00)
          | (rsela[21] ? r[21] : 8'h00)
          | (rsela[22] ? r[22] : 8'h00)
          | (rsela[23] ? r[23] : 8'h00)
          | (rsela[24] ? r[24] : 8'h00)
          | (rsela[25] ? r[25] : 8'h00);

assign rb = (rselb[0]  ? r[0]  : 8'h00)
          | (rselb[1]  ? r[1]  : 8'h00)
          | (rselb[2]  ? r[2]  : 8'h00)
          | (rselb[3]  ? r[3]  : 8'h00)
          | (rselb[4]  ? r[4]  : 8'h00)
          | (rselb[5]  ? r[5]  : 8'h00)
          | (rselb[6]  ? r[6]  : 8'h00)
          | (rselb[7]  ? r[7]  : 8'h00)
          | (rselb[8]  ? r[8]  : 8'h00)
          | (rselb[9]  ? r[9]  : 8'h00)
          | (rselb[10] ? r[10] : 8'h00)
          | (rselb[11] ? r[11] : 8'h00)
          | (rselb[12] ? r[12] : 8'h00)
          | (rselb[13] ? r[13] : 8'h00)
          | (rselb[14] ? r[14] : 8'h00)
          | (rselb[15] ? r[15] : 8'h00)
          | (rselb[16] ? r[16] : 8'h00)
          | (rselb[17] ? r[17] : 8'h00)
          | (rselb[18] ? r[18] : 8'h00)
          | (rselb[19] ? r[19] : 8'h00)
          | (rselb[20] ? r[20] : 8'h00)
          | (rselb[21] ? r[21] : 8'h00)
          | (rselb[22] ? r[22] : 8'h00)
          | (rselb[23] ? r[23] : 8'h00)
          | (rselb[24] ? r[24] : 8'h00)
          | (rselb[25] ? r[25] : 8'h00);

//
// Ouput ports A/B multiplexers
//
assign fa[7:0] = ra[7:0];
assign fb[7:0] = (~dir[15] ? dir[11:4] : 8'h00)
               | ((dir[15] & ~sb_ext) ? rb[7:0] : 8'h00)
               | ((dir[15] &  sb_ext) ? (fb7z ? 8'h00 : 8'hff) : 8'h00);

always @(posedge pin_clk_p)
begin
   sb_ext <= ~pin_wi & ~pl[12] & dmi[10] & dir[4];
   fb7z <= ~fb[7];
end

//
// Minimal required registers initalization, otherwise,
// undefined content would prevent simulation. Only PDP-11
// registers are reset, because its behaviour depends on software
//
initial
begin
   r[0] = 8'h00;
   r[1] = 8'h00;
   r[2] = 8'h00;
   r[3] = 8'h00;
   r[4] = 8'h00;
   r[5] = 8'h00;
   r[6] = 8'h00;
   r[7] = 8'h00;
   r[8] = 8'h00;
   r[9] = 8'h00;
   r[10] = 8'h00;
   r[11] = 8'h00;
end

//
// Register write strobes
//
assign f03_wr = st_fx & ~pl[10] & (~dmi[3] | ~psw[5]);
assign f47_wr = st_fx & ~pl[10] & (~dmi[3] | ~psw[4]);

generate
for (i=0; i<26; i=i+1)
begin : gen_wreg
   always @(posedge pin_clk_p)
   begin
      if (f03_wr & rsela[i]) r[i][3:0] <= md[3:0];
      if (f47_wr & rsela[i]) r[i][7:4] <= md[7:4];
   end
end
endgenerate

//______________________________________________________________________________
//
// Output address and data register
//
assign pin_astb = ~dmi[4] & ~pin_wi & dmi[5];
assign pin_dstb = ~dmi[4] & dmi[6];
assign pin_ado[15:0] = {fb[7:0], fa[7:0]};
always @(posedge pin_clk_p) if (pin_astb) addr0 <= fa[0];


//______________________________________________________________________________
//
// Data multiplexer
//
assign md[7:0] = (psw_rd ? psw[7:0] : 8'h00)
               | (mdl_rd ? pin_adi[7:0] : 8'h00)
               | (mdh_rd ? pin_adi[15:8] : 8'h00)
               | (alu_rd ? alu[7:0] : 8'h00)
               | (alu_sh ? {alu_sh8, alu[7:1]} : 8'h00);

assign mdl_rd = ~(pl[19] & ~dir[4] & ~dir[5])
              & ~(pl[19] & dir[5] & (addr0 ^ dir[4]))
              & ~(pl[20] & inpl)
              & (pl[20] | pl[19]);
assign mdh_rd = (pl[19] & ~dir[4] & ~dir[5])
              | (pl[19] & dir[5] & (addr0 ^ dir[4]))
              | (pl[20] & inpl);

assign psw_rd = pl[17];
assign alu_rd = (pl[20:17] == 4'b0000);
assign alu_sh = pl[18];

//______________________________________________________________________________
//
// ALU
//
generate
for (i=0; i<8; i=i+1)
begin : gen_alu
   //
   // OR functions
   //
   assign ax[i] = fa[i] ? (fb[i] ? pl[6] : pl[5]) : (fb[i] ? pl[4] : pl[3]);
   //
   // AND functions
   //
   assign ay[i] = fa[i] ? (fb[i] ? pl[0] : pl[1]) : (fb[i] ? pl[2] : 1'b0);
end
endgenerate

//
// Carry chain pl[13] is external carry (+1), pl[14] ic c[0] carry (+2)
//
assign c[0] = ay[0] | ax[0] & pl[13] | pl[14];
assign c[1] = ay[1] | ax[1] & c[0];
assign c[2] = ay[2] | ax[2] & c[1];
assign c[3] = ay[3] | ax[3] & c[2];
assign c[4] = ay[4] | ax[4] & c[3] & ~dmi[3];
assign c[5] = ay[5] | ax[5] & c[4];
assign c[6] = ay[6] | ax[6] & c[5];
assign c[7] = ay[7] | ax[7] & c[6];
//
// Summ output
//
assign alu[0] = pl[13] ^ ax[0];
assign alu[1] = c[0] ^ ax[1];
assign alu[2] = c[1] ^ ax[2];
assign alu[3] = c[2] ^ ax[3];
assign alu[4] = (c[3] & ~dmi[3]) ^ ax[4];
assign alu[5] = c[4] ^ ax[5];
assign alu[6] = c[5] ^ ax[6];
assign alu[7] = c[6] ^ ax[7];

//
// ALU flags
//
assign alu_z_c4 = ~inpl & ~pl[16];
assign alu_sh8  = psw[0] & dmi[2] | psw[4] & inpl;

assign alu_z  = (md[7:0] == 8'h00) & (alu_z_c4 | psw[6]);
assign alu_n  = md[7];
assign alu_c4 = c[3];
assign alu_c8 = alu_sh ? alu[0] : c[7];
assign alu_c  = alu_sh ? alu[0] : (~c[7] ^ pl[11]);
assign alu_v  = c[6] ^ c[7];

//______________________________________________________________________________
//
// Microinstruction bus and register
//
assign pin_mo[15:0] = (mo_ad ? pin_adi[15:0] : 16'h0000)
                    | (mo_fa ? {fb[7:0],fa[7:0]} : 16'h0000);

assign m04rs = ~pl[12] & ~pin_wi;

always @(posedge pin_clk_p)
begin
   inpl <= ~pl[12] & ~pin_wi;

   dir[15:5] <= m_in ? pin_mi[15:5] : dir[15:5];
   dir[3:1] <= m_in ? pin_mi[3:1] : dir[3:1];
   //
   // Modify microinstruction register for 16-bit ALU operations
   //
   dir[0] <= m04rs ? ~dir[0] : (m_in ? pin_mi[0] : dir[0]);
   dir[4] <= m04rs ? ~dir[4] : (m_in ? pin_mi[4] : dir[4]);
end

//______________________________________________________________________________
//
// Decoding jump microinstruction array for 1611 (Data Chip)
//
mcp_plj plj
(
   .inpl(inpl),         // input enable
   .icc(jump),          // indirect condition code
   .psw(psw),           // PSW flags
   .mir(dir[15:8]),     // microinstruction
   .jump(pin_cond)      // jump condition met
);

//______________________________________________________________________________
//
// PDP-11 conditional branch instruction matrix
// Generates indirect condition code
//
mcp_plb plb
(
   .dal(pin_adi),       // PDP-11 branch opcode
   .psw(psw),           // processor status word
   .jump(jbxx)          // jump taken
);

always @(posedge pin_clk_p) if (mo_ad) jump <= jbxx;
//______________________________________________________________________________
//
// Decoding microinstruction array for 1611 (Data Chip)
//
mcp_pli pli
(
   .inpl(inpl),         // input enable
   .mir(dir[15:8]),     // microinstruction
   .dmi(dmi[10:0])      // decoded output
);

//______________________________________________________________________________
//
// Decoding microinstruction array for 1611 (Data Chip)
//
mcp_pld pld
(
   .inpl(inpl),         // input enable
   .psw(psw),           // processor status word
   .mir(dir[15:0]),     // microinstruction
   .pld(pl[20:0])       // matrix output
);

//______________________________________________________________________________
//
endmodule
