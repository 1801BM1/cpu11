//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
// DC304 MMU and Register Chip model
//_____________________________________________________________________________
//
module dc304
#(
   parameter DC304_FPP = 1,
   parameter DC304_MMU = 1
)
(
   input          pin_clk,    // main clock
   input          pin_mce_p,  // master rising edge
   input          pin_mce_n,  // master falling edge
   input  [15:0]  pin_adi,    // input address/data bus
   output [15:0]  pin_ado,    // output address/data bus
   output [21:16] pin_a,      // high address bus
   output         pin_bso,    // bus select output
   input          pin_bsi,    // bus select input
   input  [12:4]  pin_m,      // microinstruction bus
   input  [12:4]  pin_mo,     // microinstruction early status
   input  [12:4]  pin_mc,     // microinstruction latched status
   output         pin_m15,    // address conversion flag
   output         pin_me,     // mapping enabled
   output         pin_ra,     // register access reply
   output         pin_de,     // invalid memory access
   input  [2:0]   pin_pga     // early page address
);

//______________________________________________________________________________
//
wire [12:4] m;                // microinstuction register
wire [12:4] mo;               // microinstruction early status
wire [12:4] mc;               // microinstruction latched status
reg  [15:0] va;               // virtual address input register
wire [15:0] d;                // data bus multiplexer
wire [12:1] ax;               // input address multiplexer
wire [21:16] a;               // high address lines
                              //
wire wl, wh, wf;              // write strobe to MMU/FPP registers
wire astb_rc;                 // Q-bus address microcycle
reg  astb;                    // latched address strobe
reg  atreq;                   // address translation request
                              //
reg  sa_7572;                 // SR0 address decoded on A/D bus
reg  sa_7576;                 // SR2 address decoded on A/D bus
reg  sa_2516;                 // SR3 address decoded on A/D bus
reg  sa_2376;                 // PAR/PDR access from register file
reg  sa_23xx;                 // kernel PAR/PDR access
reg  mr_sel;                  // MMU register access on A/D bus
wire fp_sel;                  // floating point register access
                              //
wire sa_7572_rc;              //
wire sa_7574_rc;              //
wire sa_7576_rc;              //
wire sa_2516_rc;              //
wire sa_23xx_rc;              //
wire sa_76xx_rc;              //
wire mr_sel_rc;               //
                              //
reg  [5:0] ba;                // latched bus access address VA/PA
reg  [4:0] lb;                //
wire [4:0] ma;                // MMU register index port PAR
wire [4:0] mb;                // MMU register index port PDR
wire [3:0] id;                //
                              //
wire fa_m765;                 // FPP register index m[7:5]
wire fa_s210;                 // FPP register index ir[2:0] - fsrc/fdst
wire fa_s076;                 // FPP register index ir[7:6] - ac
wire [5:0] fa;                // FPP register index
                              //
wire en_um;                   // UMAP translate
wire en_as;                   // AS, 22-bit address
wire mmu_en;                  // MMU enable
wire bso, bs;                 //
reg  bsi;                     //
                              //
reg [7:0] fa_mux;             //
wire fa_stb;                  //
reg  fa0t;                    //
wire km_sel;                  //
wire km_sel_rc;               //
reg  sr_rst;                  // status register reset
wire w_set, w_clr;            // W (dirty page) flag set/clr
                              //
reg  [15:0] pa;               // page address to translate
reg  [15:0] pd;               // page descriptor to translate
                              //
wire [15:0] rda;              // RAM read data port A
wire [15:0] rdb;              // RAM read data port B
wire [15:0] wda;              // RAM write data port A
wire [15:0] wdb;              // RAM write data port B
wire [15:0] dx;               //
wire [15:0] df;               //
                              //
wire err_stb;                 //
wire sta_stb;                 //
reg  [15:0] sr0;              //
reg  [15:0] sr2;              //
reg  [15:0] sr3;              //
reg  sr2_rw;                  //
                              //
wire ta_err;                  // address translation error
wire req_ro;                  // aborted on readonly
wire req_le;                  // aborted on limit exceeded
wire req_nr;                  // aborted on non-resident
reg  abt;                     //
                              //
wire fr_ena;                  //
wire rx_ena;                  //
                              //
wire [21:6] sa;               // physical address adder
wire lim_err;                 // address comparator result
                              //
//______________________________________________________________________________
//
assign mo[12:4] = pin_mo[12:4];
assign mc[12:4] = pin_mc[12:4];
assign m[12:4] = pin_m[12:4];

always @(posedge pin_clk)
begin
   if (pin_mce_n) va <= pin_adi;
   if (pin_mce_n) bsi <= pin_bsi;
end

assign pin_ado[15:0] = d[15:0];
assign pin_a[21:16] = a[21:16];

assign pin_m15 = DC304_MMU ? ~(astb_rc & mmu_en & ~m[7]) : 1'b1;
assign pin_me  = DC304_MMU ? en_um : 1'b0;
assign pin_ra  = DC304_MMU ? mr_sel : 1'b0;
assign pin_de  = DC304_MMU ? ta_err : 1'b0;
assign pin_bso = DC304_MMU ? bso : 1'b0;

//______________________________________________________________________________
//
// Internal bus multiplexer
//
assign d[15:0] = ((DC304_MMU && sa_7572) ? (sr0[15:0] & 16'o160157) : 16'o000000)
               | ((DC304_MMU && sa_7576) ? (sr2[15:0] & 16'o177777) : 16'o000000)
               | ((DC304_MMU && sa_2516) ? (sr3[15:0] & 16'o000060) : 16'o000000)
               | ((DC304_MMU && atreq)   ? {sa[15:6], ba[5:0]} : 16'o000000)
               | ((DC304_MMU && rx_ena)  ? dx : 16'o000000)
               | ((DC304_FPP && fr_ena)  ? df : 16'o000000);

//______________________________________________________________________________
//
assign astb_rc = ~mo[12] & m[12];
always @(posedge pin_clk)
begin
   if (pin_mce_p)
   begin
      astb  <= astb_rc;
      atreq <= astb_rc & mmu_en & ~m[7];
   end
end

assign id[0] = mc[12] & ~mc[9];                    // write data
assign id[1] = mc[12] &  mc[9] & ~mc[8];           // read data
assign id[2] = mc[12] & ~mc[9] & ~mc[8] & ~ba[0]   // write low byte
             | mc[12] & ~mc[9] &  mc[8];           // write word
assign id[3] = mc[12] & ~mc[9] & ~mc[8] &  ba[0]   // write high byte
             | mc[12] & ~mc[9] &  mc[8];           // write word
                                                   //
assign wl = pin_mce_n & mr_sel & id[2];            // write MMU low byte
assign wh = pin_mce_n & mr_sel & id[3];            // write MMU high byte
assign wf = pin_mce_n & fp_sel & mc[12] & ~mc[9];  // write FPP word

assign km_sel_rc = ~mo[4] | ~mo[5] | mo[6];                       // early flags
assign km_sel = ~mc[4] | ~mc[5] | mc[6];                          // kernel mode
assign fp_sel = mc[5] & mc[4] & mc[7] & (m[5] | m[6]) & ~mr_sel;  // FPP access

always @(posedge pin_clk)
begin
   if (pin_mce_n)
      sr_rst <= ~mc[4] & ~mc[5] & mc[6] & m[7] & ~mc[9];
end

//______________________________________________________________________________
//
// MMU resister access from the bus transactions (read/write by PDP-11 CPU)
//
assign ax[5:1]  = ba[5:1];
assign ax[12:6] = atreq ? sa[12:6] : va[12:6]; // translated or virtual
assign bs = DC304_MMU  ? (atreq ? bso : bsi) : 1'b0;

assign sa_7572_rc = bs & (ax[12:1] == (13'o17572 >> 1)); // SR0 access
assign sa_7574_rc = bs & (ax[12:1] == (13'o17574 >> 1)); // SR1 access
assign sa_7576_rc = bs & (ax[12:1] == (13'o17576 >> 1)); // SR2 access
assign sa_2516_rc = bs & (ax[12:1] == (13'o12516 >> 1)); // SR3 access
assign sa_23xx_rc = bs & (ax[12:6] == 7'o123) & ~ax[4];  // kernel set
assign sa_76xx_rc = bs & (ax[12:6] == 7'o176) & ~ax[4];  // user set
assign mr_sel_rc  = sa_7572_rc | sa_7574_rc | sa_7576_rc
                  | sa_2516_rc | sa_23xx_rc | sa_76xx_rc;

always @(posedge pin_clk)
begin
   if (pin_mce_n & astb)
      ba[5:0] <= pin_adi[5:0];

   if (pin_mce_p)
   begin
      if (mc[7]) // no SYNC asserted
      begin
         sa_7572 <= 1'b0;
         sa_7576 <= 1'b0;
         sa_2516 <= 1'b0;
         sa_2376 <= 1'b0;
         sa_23xx <= 1'b0;
         mr_sel  <= 1'b0;
      end
      else
      begin
         if (astb)
         begin
            sa_7572 <= sa_7572_rc;
            sa_7576 <= sa_7576_rc;
            sa_2516 <= sa_2516_rc;
            sa_23xx <= sa_23xx_rc;
            sa_2376 <= sa_23xx_rc | sa_76xx_rc;
            mr_sel  <= mr_sel_rc;
         end
      end
   end
end

assign bso = (~en_as | sa[21:18] == 4'b1111) & (sa[17:13] == 5'b11111);
assign fr_ena = ~astb & ~mr_sel;
assign rx_ena = ~astb & sa_2376;

//______________________________________________________________________________
//
// Floating point register indices
//
assign fa_m765 = ~m[7] | ~m[6];        // FPP register in m[7:5]
assign fa_s210 = m[7] & m[6] & ~m[5];  // FPP register in ir[2:0] - fsrc/fdst
assign fa_s076 = m[7] & m[6] & m[5];   // FPP register in ir[7:6] - ac
assign fa_stb  = mc[4] & ~mc[5] & ~mc[6];

always @(posedge pin_clk)
begin
   if (pin_mce_n)
      if (fa_stb)
      begin
         fa_mux[7:0] <= pin_adi[7:0];
         fa0t <= 1'b0;
      end
      else
         if (fp_sel & ~fa[4] & (id[0] | id[1]))
            fa0t <= ~fa0t;
end

assign fa[0]   = fa0t & ~fa[4];
assign fa[5:4] = {~m[4], ~m[6]};
assign fa[3:1] = ( (fa_s210 ? fa_mux[2:0]         : 3'b000)
                 | (fa_m765 ? {~m[7], m[6:5]}     : 3'b000)
                 | (fa_s076 ? {1'b0, fa_mux[7:6]} : 3'b000))
                 & (fa[4] ? 3'b101 : 3'b111);

//______________________________________________________________________________
//
// FPP register file
//
dc_fpp fpr(
   .clock(pin_clk),
   .address(fa),
   .data(pin_adi),
   .wren(wf),
   .rden(pin_mce_p),
   .q(df)
);

//______________________________________________________________________________
//
// MMU error logic
//
assign sta_stb = pin_mce_p & ~abt & atreq;
assign err_stb = pin_mce_p & ~abt & atreq & ta_err;

assign req_nr = atreq & ~pd[1];
assign req_ro = atreq & pd[1] & ~pd[2] & ~mc[9];
assign req_le = atreq & lim_err;
assign ta_err = req_ro | req_le | req_nr;

//______________________________________________________________________________
//
// SRx MMU registers write logic
//
always @(posedge pin_clk)
begin
   if (pin_mce_p)                         // SR0 error bits are frozen
      abt <= sr0[15:13] != 3'b000;        // on the first error occurrence
                                          //
   if (pin_mce_n & astb & m[5] & ~abt)    // instruction fetch address
      sr2 <= pin_adi;                     // frozen on error occurrence
end

always @(posedge pin_clk or posedge sr_rst)
begin
   if (sr_rst)
   begin
      sr0[15:0] <= 16'o000000;
      sr3[15:0] <= 16'o000000;
   end
   else
   begin                                  //
      sr0[4]    <= 1'b0;                  // unused bits of SR0/SR3
      sr0[12:7] <= 6'o00;                 //
      sr3[3:0]  <= 4'o00;                 //
      sr3[15:6] <= 10'o0000;              //
                                          //
      if (wl & sa_2516)                   //
         sr3[5:4] <= pin_adi[5:4];        // SR3 write
                                          //
      if (wl & sa_7572)                   //
         sr0[0] <= pin_adi[0];            // SR0 write
                                          //
      if (wh & sa_7572)                   //
         sr0[15:13] <= pin_adi[15:13];    //
      else
         if (err_stb)
            sr0[15:13] <= {req_nr, req_le, req_ro};

      if (sta_stb)
      begin
         sr0[3:1] <= va[15:13];
         sr0[6:5] <= {~km_sel, ~km_sel};
      end
   end
end

assign mmu_en = sr0[0];
assign en_as  = sr3[4];
assign en_um  = sr3[5];

//______________________________________________________________________________
//
// MMU register file indices
//
always @(posedge pin_clk) if (pin_mce_p) lb <= mb;

assign ma = astb_rc ? {1'b1, km_sel_rc, pin_pga[2:0]} :  // translation PAR
            astb ?    {ba[5], sa_23xx_rc, ba[3:1]} :     // read/write RxR
                      {ba[5], sa_23xx, ba[3:1]};
assign mb = astb_rc ? {1'b0, km_sel_rc, pin_pga[2:0]} :  // translation PDR
            astb ? lb : {1'b0, sa_23xx, ba[3:1]};        // W-bit clr/set

//______________________________________________________________________________
//
// MMU register file
//
dc_mmu mrx(
   .clock(pin_clk),
   .address_a(ma),
   .address_b(mb),
   .byteena_a({wh, wl}),
   .byteena_b(2'b01),
   .data_a(wda),
   .data_b(wdb),
   .q_a(rda),
   .q_b(rdb),
   .wren_a(rx_ena & (wl | wh)),
   .wren_b(pin_mce_p & w_set | pin_mce_n & w_clr)
);

always @(posedge pin_clk)
begin
   if (pin_mce_n & atreq) pa <= rda;
   if (pin_mce_n & (atreq | sa_2376)) pd <= rdb & 16'o077516;
end

assign dx  = rda & (ba[5] ? 16'o177777 : 16'o077516);
assign wda = pin_adi[15:0] & (~ba[5] ? 16'o077416 : 16'o177777);
assign wdb = pd & 16'o077416 | (w_set ? 16'o000100 : 16'o000000);

assign w_set = ~mr_sel_rc & ~mc[9] & ~ta_err & atreq;    // write not MMU reg
assign w_clr = sa_2376 & ba[5] & ~mc[9] & mc[12];        // write PAR

//______________________________________________________________________________
//
// Address adder and comparator
//
assign lim_err = ~pd[3] ? (va[12:6] > pd[14:8]) :     // page grows up
                          (va[12:6] < pd[14:8]);      // page grows down

assign a[21:16] = (DC304_MMU && atreq) ? sa[21:16] : 6'b000000;
assign sa[21:6] = {(en_as ? pa[15:12] : 4'b0000), pa[11:0]} + {9'o000, va[12:6]};

//______________________________________________________________________________
//
endmodule
