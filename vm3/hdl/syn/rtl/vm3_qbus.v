
// Copyright (c) 2014-2023 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Version of 1801VM3 processor with Q-bus external interface
// All external signal transitions should be synchronzed with pin_clk
// The core does not contain any extra metastability eliminators itself
//
module vm3_qbus
#(parameter
//______________________________________________________________________________
//
// If VM3_CORE_FIX_SR3_RESERVED is nonzero the SR3 reserved bits are zeroed.
//
// On the original 1801VM3 processor the reserved bits of MMU SR3 register
// are read out as ones, resulting in incorrect CPU type rocognition on
// some operating systems.
//
   VM3_CORE_FIX_SR3_RESERVED = 0,
//______________________________________________________________________________
//
// The 1801VM3 has the following prefetch bug:
//  - CPU reads "mov #addr, PC" instruction opcode successfully
//  - then perefetching happens to read the word after this instruction
//  - bus timeout happens, it is ignored for the prefetch
//  - control is transferred to "addr"
//  - instruction fetch happens successfully at addr, one or two words
//  - abort on timeout happens, due to prefetch timeout flag was not cleared
//
   VM3_CORE_FIX_PREFETCH_TIMEOUT = 1
)
(
   input          pin_clk_p,        // processor clock, rising edge
   input          pin_clk_n,        // processor clock, falling edge
   input          pin_dclo,         // processor reset
   input          pin_aclo,         // power fail notificaton
   input  [3:0]   pin_virq,         // vectored interrupt request
   input          pin_halt,         // halt mode request
   input          pin_evnt,         // timer event interrupt
                                    //
   input          pin_init_in,      // peripheral reset input
   output         pin_init_out,     // peripheral reset output
                                    //
   input  [15:0]  pin_ad_in,        // data bus input
   output [15:0]  pin_ad_out,       // address/data bus output
   output         pin_ad_ena,       // address/data bus enable
   output [21:16] pin_a_out,        // high address bus output
   output         pin_a_ena,        // high address bus enable
   output         pin_umap,         // upper address mapping
   output         pin_bs,           // I/O bank select
                                    //
   output         pin_sync,         // address strobe
   output         pin_wtbt,         // write/byte status
   output         pin_dout,         // data output strobe
   output         pin_din,          // data input strobe
   output         pin_iako,         // interrupt vector input
   input          pin_rply,         // transaction reply
                                    //
   output         pin_hltm,         // halt mode
   output         pin_sel,          // access for halt mode space
   input          pin_bsel          // start from 173000
);

//______________________________________________________________________________
//
reg  [6:0]  la;                     // low address latch
reg  [21:0] ra;                     // instruction prefetch
reg  [21:0] ca;                     // compare prefetch
reg  [21:0] a;                      // bus output address
reg  [21:6] sa;                     // address adder
wire [21:6] sx;                     // address adder mux
wire [21:0] as;                     // address register mux
                                    //
wire        sa77;                   //
wire        s23xx, s76xx;           // system/user mode PARs/PDRs
wire        s757x, s251x;           // SR0/1/2, SR3/PARH
wire        s7777;                  // external PSW address
                                    //
reg         r2376, rmsel;           //
reg         r757x, r251x;           //
reg         r7777;                  //
                                    //
wire        wr_2376, rd_2376;       //
wire        dn_2376, dn_2376_in;    //
reg         dn_2376_t;              //
                                    //
reg         rmsel_clr;              //
reg         rg_wr_lh;               // MMU reguster write/read
reg  [2:0]  rmsel_st_t;             //
wire        rmsel_st;               // MMU registers strobe
                                    //
reg         di_oe;                  //
reg         rg_oe;                  //
wire        rg_wr;                  //
reg         dx_stb;                 //
wire        dx_stb_rc;              //
wire        dx_swp;                 //
wire        di_lat;                 //
wire        do_lat;                 //
wire        do_clr;                 //
reg         doh_lat, dol_lat;       //
reg         do_oe;                  //
reg         fx_swp;                 //
                                    //
wire        psw_oe;                 // read registers to D-mux
wire        parh_oe, sr0_oe;        //
wire        sr2_oe, sr3_oe;         //
wire        par_oe, pdr_oe;         //
                                    //
wire        par_wl, par_wh;         // low/high byte write to PAR
wire        pdr_wl, pdr_wh;         // low/high byte write to PDR
wire        parh_en, parh_wr;       //
wire        sr0_wl, sr0_wh;         // low/high byte write to SR0
wire        sr3_wr;                 //
                                    //
wire [15:0] d;                      // data bus mux
wire [15:0] dx;                     // data bus byte swapper
wire [15:0] ba;                     // buffer address output
reg  [15:0] di_reg;                 // data input register
reg  [15:0] do_reg;                 // data output register
reg  [15:0] ba_ax;                  // address from ALU argument
reg  [15:0] ba_fr;                  // address from ALU function
wire        a0_reg;                 //
                                    //
reg  [15:0] ireg;                   // instruction register
reg  [15:0] ireg_p;                 // instruction register pipeline stage P
reg  [8:0]  ireg_r;                 // instruction register pipeline stage R
reg  [8:0]  ireg_m;                 // instruction register pipeline stage M
wire        ir_zf;                  // zero opcode in instruction register
                                    //
wire        ir_oe;                  // read immediate data from IR
reg         ir_doe;                 // read data from instruction
wire        doe_clr;                //
                                    //
reg         ir_stb;                 // instruction register strobe
wire        ir_set0, ir_set1;       //
wire        ir_clr;                 //
reg         ir_set0_t;              //
reg         ir_tout;                // timed-out IR prefetch
                                    //
wire        plm_lat_fc, alu_ea2_fc; //
wire        alu_rq;                 // ALU cycle start request
wire        alu_rdy, ardy_st;       // ALU ready to start
reg         alu_rdy_lh;             //
reg         alu_plm, alu_plm_h;     // ALU PLM ready
reg  [2:1]  alu_ea;                 // ALU extended arithmetics states
reg  [1:0]  alu_st;                 // ALU cycle states
reg         alu_stb;                // ALU result strobe
reg         alu_rd, alu_rd_lh;      // ALU input arguments strobe
wire        alu_wr_rc, alu_stb_rc;  //
reg         alu_wr;                 // ALU result write code
wire        alu_run;                // start ALU operation
wire        alu_mc;                 // microcode ALU request
reg [33:18] plm_as;                 // ALU register control
                                    //
reg  [15:0] rra;                    // extended arithmetics register
wire [15:0] rra_ix;                 // extended arithmetics input mux
wire        rra_wr;                 //
wire        rra_shl, rra_shr;       //
wire        rra_zf;                 //
wire        rra_in0, rra_in15;      //
wire        r10_b15, r11_b15;       //
                                    //
reg  [5:0]  act_n;                  // arithmetic counter latches
wire [3:0]  act_c;                  // counter carries
wire        act_zf;                 //
wire        act_w15, act_w17;       //
wire        act_wr;                 //
reg         act_wr_t;               //
                                    //
reg  [15:0] vmux;                   // interrupt vector mux
reg  [15:0] cmux;                   // constant generator mux
                                    //
wire        plm85n;                 // register selection type
wire        plm85p;                 // register selection type
wire        lin_en;                 // load instruction enable
                                    //
wire        mc_res, abort;          // microcode abort
wire [21:0] pld;                    // instruction decoder matrix outputs
reg  [21:0] dc;                     // instruction decoder output register
reg  [8:6]  dci;                    // decoder/interrupt status
reg  [3:0]  dcf_m;                  // flag operation stage R
reg  [3:0]  dcf_r;                  // flag operation stage M
reg         dc_rtx, dc_rtt;         // rti / rtt commands decoded
wire        dc_rtx_rc, dc_rtt_rc;   //
                                    //
reg  [7:0]  na;                     // next microinstruction address
reg  [7:0]  ma;                     // microinstruction address
reg         ma_lat;                 // load microaddress from next
wire        ma_ldr;                 // load microaddress from predecoder
wire        m0_set, m0_clr;         //
                                    //
reg         dc_stb;                 //
reg         dc_stb_h, dc_stb_hl;    //
wire [2:0]  dc_stb_set;             //
wire [3:0]  dc_en;                  //
reg         dc_en2_t;               //
reg         pa_rdy;                 // address buffer ready for prefetch
wire        ir_rdy;                 // instruction  register ready
                                    //
wire [22:0] m;                      // main microcode matrix inputs
wire [37:0] pl;                     // main microcode matrix outputs
reg  [37:8] plr;                    // main microcode output register
reg  [37:8] plm;                    // microcode instruction register
                                    //
reg         plr_lat;                //
reg         plr_rdy;                //
                                    //
reg         plm_rdy;                //
reg         plm_set1_t;             //
wire        plm_set1, plm_set0;     //
wire        plm_set_fc, plm_clr_fc; //
reg         plm_set0_l, plm_set0_lh;//
reg         plm_en;                 //
reg         plm_lat;                //
reg         plm_lat_h, plm_lat_hl;  //
wire        plm_f30, plm_f30_as;    // address from ALU function
wire        plm_f31, plm_f31_as;    // address from ALU function
wire        plm_f32;                // address from ALU argument
                                    //
wire        im_dis;                 //
wire        ri_stb;                 //
reg         ri_stb_s;               //
reg         hltm_ri, hltm_dc;       //
reg         hltm;                   //
wire        hltm_set, hltm_clr;     //
                                    //
reg  [10:0] pli_rq;                 // interrupt requests
wire [10:0] pli_ro;                 // interrupt matrix outputs
wire [3:0]  pli_ri;                 // interrupt matrix output index
reg  [3:0]  ri;                     //
                                    //
wire        irq_ack, irq_lat;       //
wire        halt_req, halt_op;      // external/opcode halt request
reg         halt_in, aclo;          // AC power failure request
reg         evnt_in, evnt, evnt_th; //
wire        evnt_req;               //
wire        aclo_ok, aclo_bad;      //
reg         ac_th, ac_tl;           //
reg         ysp_en, vec_bus;        //
                                    //
reg         fpp_req, mmu_req;       //
reg         dbl_req, ber_req;       //
reg         ysp_req;                //
wire        irq_req;                //
                                    //
reg         ac_th_clr, ac_tl_clr;   //
reg         ev_rq_clr;              //
reg         fpp_rq_clr, mmu_rq_clr; //
reg         ber_rq_clr, ysp_rq_clr; //
                                    //
reg         mmu_exc;                //
wire        dbl_exc;                //
wire        bus_exc, ysp_exc;       //
wire        exc_abt, exc_abt_st;    //
reg         exc_abt_lh;             //
reg         exc_abt_lhlh;           //
wire        fpp_exc;                // FPP trap/fatal error
                                    //
wire        init_clr, init_set;     //
reg         init_out;               //
reg         dclo;                   // DC low, hardware reset
                                    //
wire        ac_dst, ac_src;         // src/dst address change with 2
reg         ac_plr, ac_plm;         // alternate constant flag
                                    //
wire [7:0]  rsel;                   // register file selector index
wire [4:0]  gr_rx;                  // register row select X
wire [4:0]  gr_ry;                  // register row select Y
wire [4:0]  gr_wr;                  // register row select write
reg  [4:0]  gr_wr_t;                //
                                    //
wire        dst_r6, src_r6;         // SP access flag
wire        psw_r6, sys_r6;         // SP kernel/user mode select
wire        plm_rw;                 //
                                    //
wire        gr0_rx, gr0_ry;         // read register file 0
wire        gr0_wl, gr0_wh;         // write register file 0
reg         gr0_wr_t;               //
                                    //
wire        gr1_rx, gr1_ry;         // read register file 1
wire        gr1_wl, gr1_wh;         // write register file 1
reg         gr1_wr_t;               //
                                    //
reg  [15:0] gr0[4:0];               // general register file 0
reg  [15:0] gr1[4:0];               // general register file 1
reg  [15:0] pc;                     // program counter
reg  [15:0] pc2;                    // program counter prefetch
wire [15:0] pca;                    // prefetch address
                                    //
wire        psw_smod;               //
reg         psw_smod_sa;            //
reg [15:14] psw_t;                  // temporary mode register
reg  [15:0] psw;                    // processor status word
reg  [3:0]  psw_s;                  // hidded backup register
                                    //
wire        pswh_inf, pswl_inf;     // write PSW from ALU function
wire        pswh_ind, pswl_ind;     // write PSW from data bus mux
wire        pswl_inp;               // write ALU operation flags
wire        pswl_ins;               // restore flags from backup
wire        pswl_stb;               // hidden backup register strobe
reg         pswh_inf_t;             //
reg         pswl_inf_t;             //
reg         pswl_inp_t;             //
reg         pswl_ins_t;             //
                                    //
wire [4:0]  ov;                     // outputs vector matrix
wire [3:0]  vsel;                   // vector mux control
wire [4:0]  csel;                   // const mux control
reg         dc_tbit;                //
wire        vsel_my;                //
wire        csel_my;                //
wire        vec_stb;                //
                                    //
wire [4:0]  eac;                    // ALU extended arithmetics control
wire [4:0]  plf;                    // ALU flag control matrix outputs
reg  [13:0] cia;                    // ALU flag control matrix inputs
wire        cia_s4, cia_s6;         //
reg         eaf4;                   // extended arithmetics flag
reg  [6:0]  ic;                     // ALU conarol matrix inpiuts
wire [17:0] ac;                     // ALU control matrix outputs
reg         ic0_t, ic1_t;           //
                                    //
wire [7:0]  m8_in;                  //
reg         alu_zfr, alu_nfr;       //
reg  [1:0]  rra15_t;                //
reg  [1:0]  alu_vfr_t;              //
reg  [2:0]  eac0_t;                 //
                                    //
wire        alu_zh, alu_zl;         // ALU Z flags
wire        alu_zf, alu_zhr;        //
wire        c15af, cin0;            //
wire        cin15, cin7;            //
                                    //
wire        alu_shl;                // ALU result shifter controls
wire        alu_shr;                //
wire        alu_dir;                //
wire        alu_b, alu_c;           //
wire        alu_d, alu_e;           //
wire        alu_f, alu_g;           //
wire        alu_ac;                 // ALU adder lsb carry
                                    //
wire [15:0] af;                     // ALU adder result
wire [15:0] c;                      // ALU adder carry
wire [15:0] s;                      // ALU adder sum
wire [15:0] ana;                    // ALU and half-adder
wire [15:0] ora;                    // ALU or half-adder
wire [15:0] f;                      // ALU shifter output
reg  [15:0] fr;                     // ALU output register
wire [15:0] fx;                     // ALU function byte swap
wire [15:0] x;                      // ALU argument X mux
wire [15:0] y;                      // ALU argument Y mux
reg  [15:0] ax;                     // ALU X argument register
reg  [15:0] ay;                     // ALU Y argument register
wire [15:0] mx;                     //
wire [15:0] my;                     //
wire [15:0] rx0;                    // register file 0 read mux
wire [15:0] rx1;                    // register file 1 read mux
wire [15:0] ry0;                    // register file 0 read mux
wire [15:0] ry1;                    // register file 1 read mux
                                    //
wire        mx_rx, my_ry;           // read muxes to X/Y bus
wire        pc_rx, pc_ry;           // read PC to X/Y bus
wire        dx_mx, dx_my;           // read swap to X/Y mux
wire        rra_mx, rra_my;         // read shift to X/Y mux
wire        psw_mx;                 // read PSW to X/Y mux
                                    //
reg  [15:0] par[15:0];              // MMU page address registers
reg  [14:1] pdr[15:0];              // MMU page descriptor registers
reg  [15:0] parh;                   // halt mode page address
wire [15:0] par_d;                  //
wire [15:0] pdr_d;                  //
wire [15:0] mmu_a;                  //
wire [14:1] mmu_d;                  //
reg  [15:0] sr0;                    //
reg  [15:0] sr2[4:0];               // MMU pipelined address
wire [15:0] sr3;                    //
reg  [15:0] ws_pdr;                 // MMU selector storage
reg  [6:0]  msta[3:0];              // MMU pipelined status
wire [6:5]  ms_mod;                 //
wire [15:13] ms_ba;                 //
wire        sr0_mrqt, sr0_mrqs;     //
wire        mrqs_pl, mrqs_nr;       //
wire        rd_err, init_nrpl;      //
                                    //
wire [3:0]  parh_sel;               // page address halt mode
wire [15:0] padr_sel;               // page address/descriptor selectors
reg  [3:0]  mm_sa;                  //
reg         mm_sah;                 //
wire        mm_stb;                 //
reg         mm_stbs;                //
wire        mm_stb_set;             //
reg         mm_stb_clr;             //
                                    //
wire        sr0_er;                 //
reg         sr0_er_hl;              //
wire        sr0_m, sr0_en;          //
wire        sr3_ah;                 // AS unmasked by halt mode
reg         sr3_as;                 // Enable 22-bit address
reg         sr3_um;                 // Unibus mapping enable
wire        mmu_en;                 // MMU enable
wire        hm_men;                 // halt mode MMU enable
                                    //
wire        ra_s22, ra_s16;         //
wire        sa_s22, sa_s16;         //
wire        sa_sxa;                 //
reg         sa_sxa_h;               //
wire        sa_pfa_fc;              //
reg         sa_pfa;                 //
reg         ra_s22_h, ra_s22_hlh;   //
reg         sa_s22_h;               //
reg         sa_req, sa_req_l;       //
                                    //
wire        bs_a18, bs_a22, bs_ax;  // I/O bank select
reg         adr_eq;                 // prefetched address match
wire        io_lat0, io_lat1;       //
wire        io_lat2, io_res2;       //
reg         iop_rdy;                // I/O opcode register ready
                                    //
reg         at_stb;                 //
reg         ba_pca, ba_pca_hl;      //
reg         ba_rdy_l, ba_rdy_lh;    //
                                    //
wire        ba_rdy, ba_ins;         //
wire        ba_lat, ba_lat0;        //
wire        ba_lat1, ba_lat2;       //
wire        ba_lat3, ba_lat4;       //
reg         ba_lat2_l, ba_lat2_lh;  //
reg         ba_fsel;                //
wire        ba_dir;                 //
                                    //
wire        wf_set, wrf_set;        //
wire        ws_set;                 //
wire        opwf_clr;               //
reg         op0_wf, op1_wf;         //
reg         op2_wf, op3_wf;         //
                                    //
reg         rg_rmw;                 //
reg         di_rmw_tl;              //
wire        di_rmw;                 //
                                    //
reg         alu_drdy;               //
reg         do_rdy;                 // output register ready
reg         rd_oe;                  //
reg         io_s0_as;               //
reg         io_s3_wr;               //
wire        out_rs, s3_out;         //
                                    //
wire [3:0]  io_s;                   //
wire [3:0]  iop;                    // I/O operation code
reg  [4:0]  iop_m;                  // IO opcode register, memory translation
reg  [3:0]  iop_t;                  // IO opcode register, bus transaction
wire [5:0]  io_dc;                  // IO transaction opcode
wire [3:0]  mt_op;                  // memory translation opcode
wire        dwbl, dwbh;             // byte selection strobes
                                    //
reg         hmod;                   // halt mode flag
reg         hm_lat, hm_lat_h;       //
reg         hm_lat_set_l;           //
wire        hm_lat_set, hm_lat_clr; //
                                    //
wire        mrq_pl;                 // page limit error request
reg         mrq_pl_t;               //
wire        mrq_ro, mrq_nr;         // readonly/not resident
reg         mrq_ro_t, mrq_nr_t;     //
wire        sx_pl, sx_ro, sx_nr;    //
wire        mrqt_er;                //
reg         mrqt_nr;                // registered traslate results
reg         mrqt_ro;                //
reg         mrqt_pl;                //
reg [15:13] mt_ba;                  //
wire  [6:5] mt_mod;                 //
wire        ir_mmu_err;             //
                                    //
wire        pf_init;                //
wire [1:0]  pf_rc;                  // prefetch status
wire [2:0]  pf;                     // prefetch status
reg         pf_ena;                 //
wire        pf_ena_clr;             //
wire        pf_00, pf_01;           //
wire        pf_10, pf_11;           //
wire        pf_ena_rc;              //
wire        pf_00_rc, pf_10_rc;     //
wire        pf_00a_rc;              //
reg         pf_00m;                 // latched on plm
reg         pf_00a, pf_00r;         // latched on addr, plr
reg         pf_ba0_h, pf_ba0_hl;    //
wire        pf_pa, pf_pa_rc;        //
wire        pf_inv, pf_doe;         //
wire        pf_tout, pf_tout_st;    //
reg         pf_doe_lh, pf_tout_lh;  //
wire        pf_ins;                 //
reg         pf_rdy;                 //
reg         pf_end0;                //
wire        pf_end1;                //
                                    //
wire        pc_wr0, pc_wr1;         //
wire        pc_wr2, pc2_wrq;        //
wire        pc2_wrc_rc;             //
reg         pc2_wrr, pc2_wrm;       //
reg         pc2_wrf, pc2_wrc;       //
reg         pc3_rdy, pc3_rdy_h;     //
reg         pc_wr_t;                //
                                    //
wire        sel;                    // halt mode bus access
reg         sel_sa, sel_ra;         //
wire        irply_clr;              //
reg         irply, irply_lh;        //
reg         rply;                   //
wire        rply_in;                //
wire        rply_fc;                //
wire        bus_free;               //
                                    //
reg  [7:0]  qt;                     // Q-bus timer
wire        qt_ena;                 //
reg         qt_out;                 //
wire        qt_out_rc;              //
                                    //
wire        oat, qtout;             //
reg         qerr, qerr_lh;          //
                                    //
reg         pa_req;                 // bus address request
reg         pa_oe, pa_oe_lh;        //
wire        pa_oe_set, pa_oe_rc;    //
wire        ad_oe;                  //
reg         bd_oe;                  //
                                    //
wire        wtbt;                   //
reg         irply_en, irply_pf;     //
reg         sync;                   //
reg         din, din_lh;            //
reg         dout, dout_lh;          //
reg         dout_set;               //
wire        dout_dn;                // dout done
wire        din_end, dout_end;      //
wire        dio_clr_rc;             //
reg         dio_clr;                // din/dout outputs reset
reg         dvc_stb;                //
reg         iako;                   //
reg         iako_en;                //
reg         iako_en_l, iako_en_lh;  //
wire        iako_st, iako_set;      //
                                    //
reg         a21_ins, a21_req;       //
wire        ins_set;                //
wire        arb_ena;                //
reg         arb_ena_t;              //
wire        dmr_clr;                //
reg         dmr_clr_h;              //
reg         dmr_en;                 //
                                    // for debug purposes only
wire        oat_dbg;                // suppress Q-bus glitches
//______________________________________________________________________________
//
// For simulation purposes only
//
initial
begin
   psw[15:0] <= 16'o000000;
   plr[37:8] <= 30'o0000000000;
   plm[37:8] <= 30'o0000000000;

   gr0[0] = 16'o177777;
   gr0[1] = 16'o177777;
   gr0[2] = 16'o177777;
   gr0[3] = 16'o177777;
   gr0[4] = 16'o177777;

   gr1[0] = 16'o177777;
   gr1[1] = 16'o177777;
   gr1[2] = 16'o177777;
   gr1[3] = 16'o177777;
   gr1[4] = 16'o177777;

   msta[0] = 7'o000;
   msta[1] = 7'o000;
   msta[2] = 7'o000;
   msta[3] = 7'o000;

   par[0]  = 16'o000000;
   par[1]  = 16'o000000;
   par[2]  = 16'o000000;
   par[3]  = 16'o000000;
   par[4]  = 16'o000000;
   par[5]  = 16'o000000;
   par[6]  = 16'o000000;
   par[7]  = 16'o000000;
   par[8]  = 16'o000000;
   par[9]  = 16'o000000;
   par[10] = 16'o000000;
   par[11] = 16'o000000;
   par[12] = 16'o000000;
   par[13] = 16'o000000;
   par[14] = 16'o000000;
   par[15] = 16'o000000;

   pdr[0]  = 14'o00000;
   pdr[1]  = 14'o00000;
   pdr[2]  = 14'o00000;
   pdr[3]  = 14'o00000;
   pdr[4]  = 14'o00000;
   pdr[5]  = 14'o00000;
   pdr[6]  = 14'o00000;
   pdr[7]  = 14'o00000;
   pdr[8]  = 14'o00000;
   pdr[9]  = 14'o00000;
   pdr[10] = 14'o00000;
   pdr[11] = 14'o00000;
   pdr[12] = 14'o00000;
   pdr[13] = 14'o00000;
   pdr[14] = 14'o00000;
   pdr[15] = 14'o00000;
end

//______________________________________________________________________________
//
// Q-bus
//
assign pin_ad_ena = ad_oe;
assign pin_ad_out[15:0] = pa_oe ? a[15:0] : do_reg[15:0];
assign pin_a_out[17:16] = a[17:16];
assign pin_a_out[21:18] = bs_a18 ? 4'b1111 : a[21:18];

assign pin_a_ena = pa_oe;
assign pin_bs = ~sel & (bs_a18 | bs_a22);
assign pin_sel = sel;

assign pin_init_out = init_out | dclo;
assign pin_hltm = hltm;
assign pin_umap = sr3_um;

assign oat_dbg = ~(oat | qerr);
assign pin_iako = iako;
assign pin_sync = sync & oat_dbg;
assign pin_wtbt = wtbt & oat_dbg;
assign pin_dout = dout & oat_dbg;
assign pin_din = din & oat_dbg;
assign rply_fc = rply_in | (irply & ~irply_lh);

always @(posedge pin_clk_n) rply <= rply_fc;
always @(posedge pin_clk_p) irply_lh <= irply;
assign rply_in = pin_rply;

always @(posedge pin_clk_p)
begin
   if (di_lat)
      di_reg[15:0] <= pin_ad_in[15:0];
   if (doh_lat)
      do_reg[15:8] <= fx[15:8];
   if (dol_lat)
      do_reg[7:0] <= fx[7:0];
end

assign fx = {fx_swp ? fr[7:0] : fr[15:8], fr[7:0]};
assign dx_swp = io_s0_as | (~ir_oe & a0_reg & ~mt_op[2] & ~io_s0_as);
assign do_lat = ~plm_as[29] & ~plm_as[30] & plm_as[31] & alu_stb & alu_wr_rc;
assign do_clr = dx_stb & do_oe | dout_dn;
assign dout_dn = dout_end | rg_wr_lh;

always @(posedge pin_clk_p)
begin
   doh_lat <= ((mt_op[2] | io_s0_as) | ~(mt_op[2] | io_s0_as) & a0_reg) & do_lat;
   dol_lat <= ((mt_op[2] | io_s0_as) | ~a0_reg) & do_lat;
   if (do_lat)
      fx_swp <= ~(mt_op[2] | io_s0_as) & a0_reg;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      do_oe <= 1'b0;
   else
      if (do_clr)
         do_oe <= 1'b0;
      else
         if (do_lat)
            do_oe <= 1'b1;
end

//______________________________________________________________________________
//
// PSW and MMU register bus access decoder
//
assign s23xx = bs_ax & (as[15:6] == 10'o1723)  & ~as[4];
assign s251x = bs_ax & (as[15:3] == 13'o17251) &  as[1];
assign s757x = bs_ax & (as[15:3] == 13'o17757) & (as[2] | as[1]);
assign s76xx = bs_ax & (as[15:6] == 10'o1776)  & ~as[4];
assign s7777 = bs_ax & (as[15:3] == 13'o17777) &  as[2] & as[1];

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
   begin
      rmsel <= 1'b0;
      r2376 <= 1'b0;
      r251x <= 1'b0;
      r757x <= 1'b0;
      r7777 <= 1'b0;
   end
   else
   begin
      if (rmsel_clr)
         rmsel <= 1'b0;
      else
         if (pa_oe_rc)
            rmsel <= s23xx | s76xx | s7777 | s757x | s251x;

      if (dn_2376)
         r2376 <= 1'b0;
      else
         if (pa_oe_rc)
            r2376 <= s23xx | s76xx;

      if (pa_oe_rc)
      begin
         r251x <= s251x;
         r757x <= s757x;
         r7777 <= s7777;
      end
   end
end

always @(posedge pin_clk_p)
begin
   if (pa_oe_rc)
      la[6:0] <= a[6:0];

   dn_2376_t <= dn_2376_in;

   rmsel_st_t[0] <= rmsel;
   rmsel_st_t[1] <= rmsel_st_t[0];
   rmsel_st_t[2] <= rmsel_st_t[1];

   rg_wr_lh <= rg_wr;
end

assign wr_2376 = r2376 & rg_wr;
assign rd_2376 = r2376 & rg_oe;

assign dn_2376_in = wr_2376 | (rd_2376 & ~io_dc[5]);
assign dn_2376 = ~dn_2376_in & dn_2376_t;

assign rmsel_st = rmsel & rmsel_st_t[2];
assign rg_wr = ~rg_wr_lh & rmsel_st & alu_drdy & (~io_dc[1] | rg_rmw);
assign di_rmw = di_rmw_tl & ~rply;
assign di_lat = ~di_oe & rply & din & ~a21_ins & ~io_dc[2];

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      rmsel_clr <= 1'b0;
   else
      rmsel_clr <= rg_wr | (rg_oe & dx_stb & ~io_dc[5]);
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      rg_oe <= 1'b0;
   else
      if (dx_stb)
         rg_oe <= 1'b0;
      else
         if (~io_dc[2] & pa_oe & rmsel)
            rg_oe <= 1'b1;


end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      rg_rmw <= 1'b0;
   else
      if (rg_oe)
         rg_rmw <= io_dc[5];
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      di_oe <= 1'b0;
   else
      if (dx_stb_rc)
         di_oe <= 1'b0;
      else
         if (di_lat)
            di_oe <= 1'b1;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      di_rmw_tl <= 1'b0;
   else
      if (di_rmw)
         di_rmw_tl <= 1'b0;
      else
         if (di_lat)
            di_rmw_tl <= io_dc[5];
end

assign dx_stb_rc = alu_rd & (dx_mx | dx_my) & ~dx_stb;
always @(posedge pin_clk_p) dx_stb <= dx_stb_rc;

//______________________________________________________________________________
//
// Internal data bus mux
//
//  * - input, o - output, 0 - zero ouput
//
//     N   Pin  Fx  Dx  PSW  PDR   SR0  SR1 SR2 SR3  DI  IR  PAR
// D0  23  *    oo  **  *oo  0     *oo  0   oo       oo  oo  **oo
// D1  25  *    oo  **  *oo  **oo   oo  0   oo       oo  oo  **oo
// D2  25  *    oo  **  *oo  **oo   oo  0   oo       oo  oo  **oo
// D3  25  *    oo  **  *oo  **oo   oo  0   oo       oo  oo  **oo
// D4  24  *    oo  **   oo  0      0   0   oo  **oo oo  oo  **oo
// D5  26  *    oo  **  *oo  0      oo  0   oo  **oo oo  oo  **oo
// D6  23  *    oo  **  *oo  oo     oo  0   oo       oo  oo  **oo
// D7  21  *    oo  **  *oo  0      0   0   oo       oo  oo  **oo
// D8  24  *    oo  **    0  **oo  *oo  0   oo       oo  oo  **oo
// D9  22  *    oo  **    0  **oo   0   0   oo       oo  oo  **oo
// D10 22  *    oo  **    0  **oo   0   0   oo       oo  oo  **oo
// D11 22  *    oo  **    0  **oo   0   0   oo       oo  oo  **oo
// D12 25  *    oo  **  *oo  **oo   0   0   oo       oo  oo  **ooo
// D13 27  *    oo  **  *oo  **oo  *oo  0   oo       oo  oo  **ooo
// D14 27  *    oo  **  *oo  **oo  *oo  0   oo       oo  oo  **ooo
// D15 24  *    oo  **  *oo  0     *oo  0   oo       oo  oo  **ooo
//
// VM3 bug - SR3 reserved bits are read out as ones (should be zeroes)
//
assign d = (do_oe  ? fx     : 16'o000000)    // ALU output
         | (di_oe  ? di_reg : 16'o000000)    // Data input
         | (ir_oe  ? ireg   : 16'o000000)    // Instruction
         | (psw_oe ? psw    : 16'o000000)    // PSW
         | (par_oe ? par_d  : 16'o000000)    // MMU PARs
         | (pdr_oe ? pdr_d  : 16'o000000)    // MMU PDRs
         | (sr0_oe ? sr0    : 16'o000000)    // MMU SR0
         | (sr2_oe ? sr2[4] : 16'o000000)    // MMU SR2
         | (sr3_oe ? sr3    : 16'o000000);   // MMU SR3
                                             // SR1 always 0

assign sr3 = VM3_CORE_FIX_SR3_RESERVED ? {10'o0000, sr3_um, sr3_as, 4'o00} :
                                         {10'o1777, sr3_um, sr3_as, 4'o17};

assign par_d = {sr3_ah ? mmu_a[15:12] : 4'o00, mmu_a[11:0]};
assign pdr_d = {1'b0, mmu_d[14:8], 1'b0, mmu_d[6], 2'b00, mmu_d[3:1], 1'b0};
assign dx = dx_swp ? {d[7:0], d[15:8]} : d;

assign psw_oe = rg_oe & r7777;
assign sr0_oe = rg_oe & r757x & ~la[2] & la[1];
assign sr2_oe = rg_oe & r757x &  la[2] & la[1];
assign sr3_oe = rg_oe & r251x &  la[2];
assign par_oe = rg_oe & r2376 &  la[5] | parh_oe;
assign pdr_oe = rg_oe & r2376 & ~la[5];
assign parh_oe = rg_oe & r251x & ~la[2];

//______________________________________________________________________________
//
// Reset circuits
//
always @(posedge pin_clk_p) dclo <= pin_dclo;

always @(posedge pin_clk_p or posedge dclo)
begin
   if (dclo)
      init_out <= 1'b0;
   else
      if (init_clr)
         init_out <= 1'b0;
      else
         if (init_set)
            init_out <= 1'b1;
end

assign init_clr = alu_rd & (rsel[7:4] == 4'b1011);
assign init_set = alu_rd & (rsel[7:4] == 4'b1010)
                & ~mt_mod[6] & ~plm[22] & plm[24];

assign mc_res = dclo | abort;

//______________________________________________________________________________
//
// Instruction register pipeline
//
always @(posedge pin_clk_p)
begin
   if (ir_stb) ireg[15:0] <= pin_ad_in[15:0];
   if (dc_stb) ireg_p[15:0] <= ireg[15:0];
   if (plr_lat) ireg_r[8:0] <= ireg_p[8:0];
   if (plm_lat) ireg_m[8:0] <= ireg_r[8:0];
end

assign ir_oe = ~ir_stb & ir_doe & do_rdy;
always @(posedge pin_clk_n) do_rdy <= io_s0_as | ~do_oe | do_clr;

assign ir_set0 = ~ir_stb & (~ir_set0_t & ~pf_pa | pf_init);
assign ir_set1 = ~dc_stb & (iako_st | dc_stb_hl | ir_set0);
assign doe_clr = ir_oe & dx_stb;
assign ir_clr = ir_stb & ~mc_res & (iako_en | a21_ins) & rply & din;

assign irply_clr = VM3_CORE_FIX_PREFETCH_TIMEOUT ?
                   ir_clr & rply_in : 1'b0;

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
   begin
      ir_stb <=1'b1;
      ir_set0_t <= 1'b1;
      ir_doe <=1'b0;
   end
   else
   begin
      if (doe_clr | ir_set1)
         ir_stb <=1'b1;
      else
         if (ir_clr)
            ir_stb <=1'b0;

      if (pf_init)
         ir_set0_t <= 1'b0;
      else
         if (pf_pa)
            ir_set0_t <= 1'b1;

      if (doe_clr)
         ir_doe <=1'b0;
      else
         if (plm_lat & pf_01)
            ir_doe <=1'b1;
   end
end

//______________________________________________________________________________
//
// Instruction opcode predecoder
//
vm3_pld pld_mx(.ins(lin_en), .fpp(1'b0), .ir(ireg), .dc(pld[21:0]));

always @(posedge pin_clk_p)
begin
   if (dc_stb)
   begin
      dc[21:0] <= pld[21:0];
      dci[8:6] <= (ri_stb ? pli_ri[0] : ri[0]) ?
                  3'b000 : {~pld[8], ~pld[7], pld[6]};

      dc_rtx <= dc_rtx_rc;
      dc_rtt <= dc_rtt_rc;
   end

   if (plr_lat)
      dcf_r[3:0] <= dc[21:18];
   if (plm_lat)
      dcf_m[3:0] <= dcf_r[3:0];
end

assign dc_rtt_rc = pld[6] & ~pld[7] & pld[8] & pld[21] & ~pld[20];
assign dc_rtx_rc = pld[6] & ~pld[7] & pld[8] & pld[21];

assign lin_en  =  plr[16] | ~plr[8];
assign plm85n  = ~plm[16] |  plm[8];
assign plm85p  = ~plm[16] | ~plm[8];

always @(posedge pin_clk_p) dc_stb_h <= dc_stb;
always @(posedge pin_clk_n) dc_stb_hl <= dc_stb;

assign dc_stb_set[0] = pf_11 & ir_rdy & &dc_en[3:0];
assign dc_stb_set[1] = ir_rdy & pa_rdy;
assign dc_stb_set[2] = plm_lat & ~lin_en;

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      dc_stb <= 1'b0;
   else
      if (dc_stb)
         dc_stb <= 1'b0;
      else
         if (|dc_stb_set[2:0])
            dc_stb <= 1'b1;
end

assign dc_en[0] = ~halt_op & ~hltm_set;
assign dc_en[1] = pf_rdy | (ba_rdy & hm_lat_h);
assign dc_en[2] = dc_en2_t & ~pf_inv;
assign dc_en[3] = (~op0_wf & ~op1_wf) | opwf_clr;

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      dc_en2_t <= 1'b0;
   else
      if (pf_inv)
         dc_en2_t <= 1'b0;
      else
         if (pf_end0)
            dc_en2_t <= 1'b1;
         else
            if (dc_stb)
               dc_en2_t <= pld[12];
end

//______________________________________________________________________________
//
// Main microcode
//
vm3_plm plm_mx(.dc(m[22:9]), .mx(m[8]), .ma(m[7:0]), .sp(pl));

assign m[7:0]  = ma[7:0];
assign m[8]    = (plm[14:12] == 3'b000) & ~m8_in[0]
               | (plm[14:12] == 3'b001) & ~m8_in[1]
               | (plm[14:12] == 3'b010) & ~m8_in[2]
               | (plm[14:12] == 3'b011) & ~m8_in[3]
               | (plm[14:12] == 3'b100) & ~m8_in[4]
               | (plm[14:12] == 3'b101) & ~m8_in[5]
               | (plm[14:12] == 3'b110) & ~m8_in[6]   // take branch
               | (plm[14:12] == 3'b111) & ~m8_in[7];  // halt mode
assign m[22:9] = {dc[21:20], dc[17:13], dc[3], dc[11:9], dci[8:6]};

always @(posedge pin_clk_p)
begin
   if (m0_clr)
      ma[0] <= 1'b0;
   else
      if (m0_set)
         ma[0] <= 1'b1;
      else
         if (ma_ldr)
            ma[0] <= pld[0];
         else
            if (ma_lat)
               ma[0] <= na[0];
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      ma[7:1] <= {2'b00, ma[5:3], 2'b11};
   else
      if (ma_ldr)
         ma[7:1] <= {2'b11, pld[5:1]};
      else
         if (ma_lat)
            ma[7:1] <= na[7:1];
end

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      ma_lat <= 1'b0;
   else
      if (ma_ldr | plm_set_fc)
         ma_lat <= 1'b0;
      else
         if (plm_clr_fc)
            ma_lat <= 1'b1;
end

assign m0_clr = ~dclo & mc_res & (mmu_req | ~vec_bus);
assign m0_set =  dclo | (mc_res & ~(mmu_req | ~vec_bus));
assign ma_ldr = lin_en & dc_stb;

always @(posedge pin_clk_p)
begin
   if (plr_lat) na[7:0] <= pl[7:0];
   if (plr_lat) plr[37:8] <= pl[37:8];
   if (plm_lat) plm[25:8] <= plr[25:8];
   if (plm_lat) plm[32:27] <= plr[32:27];
   if (plm_lat) plm[37:34] <= plr[37:34];
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
   begin
      plm[26] <= 1'b1;
      plm[33] <= 1'b1;
   end
   else
   begin
      if (plm_lat) plm[26] <= plr[26];
      if (plm_lat) plm[33] <= plr[33];
   end
end

assign plm_f30 = plm[31:29] == 3'b111;
assign plm_f31 = plm[31:29] == 3'b001;
assign plm_f32 = plm[31:30] == 2'b01;

assign plm_f30_as = plm_as[31:29] == 3'b111;
assign plm_f31_as = plm_as[31:29] == 3'b001;

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      plr_lat <= 1'b0;
   else
      if (plr_lat)
         plr_lat <= 1'b0;
      else
         if (plm_en)
            plr_lat <= 1'b1;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      plr_rdy <= 1'b0;
   else
      if (plm_lat)
         plr_rdy <= 1'b0;
      else
         if (plr_lat)
            plr_rdy <= 1'b1;
end

assign plm_set0 = pf_rdy & (pf_10 | ~pf_ena);
assign plm_set1 = ~(~plm[12] & plm[13] & plm[14]) | plm_set1_t;
always @(posedge pin_clk_p) plm_set1_t <= ~plm[12] & plm[13] & plm[14];

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      plm_lat <= 1'b0;
   else
      if (plm_lat)
         plm_lat <= 1'b0;
      else
         if (plr_rdy & alu_rdy)
            plm_lat <= 1'b1;
end

always @(posedge pin_clk_p) plm_lat_h <= plm_lat;
always @(posedge pin_clk_n) plm_lat_hl <= plm_lat;

assign plm_set_fc = ~plm_en & plm_set0 & plm_set1 & ardy_st
                  & ~plr_rdy & (lin_en | ~plm_lat);
assign plm_clr_fc = plm_en & plr_lat;

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      plm_en <= 1'b0;
   else
      if (plm_clr_fc)
         plm_en <= 1'b0;
      else
         if (plm_set_fc)
            plm_en <= 1'b1;
end

//______________________________________________________________________________
//
// Microcode conditional flag input mux
//
assign m8_in[0] = alu_zfr;
assign m8_in[1] = alu_nfr;
assign m8_in[2] = alu_zfr ? r10_b15 : rra15_t[1];
assign m8_in[3] = ( rra15_t[1] | ~rra[15])
                & (~rra15_t[1] |  rra[15] | rra_zf)
                & (alu_vfr_t[0] ^ alu_vfr_t[1]);
assign m8_in[4] = dc[20] ^ dc[21]; // FPP stubs
assign m8_in[5] = pin_bsel;
assign m8_in[7] = hmod;

always @(posedge pin_clk_p)
begin
   if (rra_shl & alu_stb) rra15_t[0] <= rra[15];
   if (rra_wr) rra15_t[1] <= rra15_t[0];

   if (alu_wr & ~eac[0]) alu_vfr_t[0] <= ~cia[6];
   if (alu_wr & ~eac0_t[2]) alu_vfr_t[1] <= ~cia[6];

   if (alu_stb) eac0_t[0] <= eac[0];
   if (~alu_stb) eac0_t[1] <= eac0_t[0];
   if (alu_stb) eac0_t[2] <= eac0_t[1];
end

//______________________________________________________________________________
//
// ALU state machine
//
assign alu_rdy = (alu_stb ? eac[4] : alu_ea[1]) & ~alu_plm_h;
assign alu_rq = ~alu_st[0] & alu_plm & alu_run;

assign alu_mc = plm_lat ?
                (~plr[11] | plr[15]) & (~plr[22] | plr[24]) :
                (~plm[11] | plm[15]) & (~plm[22] | plm[24]);

assign alu_run = iop_rdy & plm_rdy & ~io_s[2]
               & do_rdy & (rd_oe | alu_mc);

always @(posedge pin_clk_n)
begin
   alu_st[0] <= alu_rq & ~alu_st[0];
   alu_st[1] <= alu_st[0] & ~mc_res;

   alu_ea[2] <= ~eac[4] & alu_st[1];
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      alu_ea[1] <= 1'b1;
   else
      if (alu_stb)
         alu_ea[1] <= eac[4];
end

assign plm_lat_fc = plr_rdy & alu_rdy & ~plm_lat;
assign alu_ea2_fc = ~eac[4] & alu_st[1];
always @(posedge pin_clk_p) alu_plm_h <= alu_plm;

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      alu_plm <= 1'b0;
   else
      if (alu_st[0])
         alu_plm <= 1'b0;
      else
         if (plm_lat_fc | alu_ea2_fc)
            alu_plm <= 1'b1;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      alu_rd <= 1'b0;
   else
      if (alu_rq)
         alu_rd <= 1'b1;
      else
         if (alu_st[0])
            alu_rd <= 1'b0;
end

assign alu_wr_rc = alu_st[1];
assign alu_stb_rc = ~alu_st[1] & alu_st[0];

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      alu_stb <= 1'b0;
   else
      if (alu_wr_rc)
         alu_stb <= 1'b0;
      else
         if (alu_stb_rc)
            alu_stb <= 1'b1;
end

always @(posedge pin_clk_p)
begin
   alu_wr <= alu_wr_rc;
   alu_rdy_lh <= alu_rdy;

   if (alu_stb_rc)
      plm_as[33:18] <= plm[33:18];
end

assign ardy_st = plm[14] | (alu_rdy & alu_rdy_lh);
always @(posedge pin_clk_n) rd_oe <= ir_oe | rg_oe | di_oe | io_s0_as;

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      io_s3_wr <= 1'b0;
   else
      if (dout_dn)
         io_s3_wr <= 1'b0;
      else
         if (alu_rd & io_s[3])
            io_s3_wr <= 1'b1;
end

//______________________________________________________________________________
//
// Vector and constant generator
//
always @(*)
begin
case(vsel)
   4'b0000: vmux = 16'o000100;   // timer
   4'b0001: vmux = 16'o000004;   // bus error, yellow stack
   4'b0010: vmux = 16'o000250;   // MMU
   4'b0011: vmux = 16'o000244;   // FPP
   4'b0100: vmux = 16'o000024;   // power on
   4'b0101: vmux = 16'o000010;   // illegal opcode
   4'b0110: vmux = 16'o000000;   // unused
   4'b0111: vmux = 16'o000024;   // power fail
   4'b1000: vmux = 16'o000030;   // EMT
   4'b1001: vmux = 16'o000014;   // BPT, T-bit
   4'b1010: vmux = 16'o000034;   // TRAP
   4'b1011: vmux = 16'o000020;   // IOT
   4'b1100: vmux = 16'o000001;   // unused
   4'b1101: vmux = 16'o173000;   // start address
   4'b1110: vmux = 16'o100000;   // halt SP value
   4'b1111: vmux = {8'o000, ireg[7:1], 1'b0};
   default: vmux = 16'o000000;
endcase
end

always @(*)
begin
case(csel)
   5'b00000: cmux = {ireg_m[7] ? 8'o377 : 8'o000, ireg_m[6:0], 1'b0};
   5'b00001: cmux = 16'o000002;
   5'b00010: cmux = ac_dst ? 16'o000002 : 16'o000001;
   5'b00011: cmux = ac_src ? 16'o000002 : 16'o000001;
   5'b00100: cmux = {12'o0000, ireg_m[3:0]};
   5'b00101: cmux = 16'o177400;
   5'b00110: cmux = 16'o000000;
   5'b00111: cmux = 16'o000002;
   5'b01000: cmux = {9'o000, ireg_m[5:0], 1'b0};
   5'b01001: cmux = 16'o000010;
   5'b01010: cmux = {15'o00000, psw[0]};
   5'b01011: cmux = 16'o000001;
   5'b01100: cmux = 16'o177774;
   5'b01101: cmux = 16'o177770;
   5'b01110: cmux = 16'o000040;
   5'b01111: cmux = 16'o000000;
   5'b11100: cmux = 16'o177760;
   5'b11101: cmux = 16'o177777;
   5'b11110: cmux = 16'o177776;
   5'b11111: cmux = 16'o000340;
   default:  cmux = 16'o000000;
endcase
end

assign csel[4:0] = {plm[13] & plm[37] & plm[36], plm[37:34]};
assign vsel[3:0] = {~ov[2], ov[1], ov[0], ~ov[3]};

//
// Update register by 2 selector (alternate constant)
//
assign ac_dst = (ireg_m[2] & ireg_m[1]) | ac_plm;
assign ac_src = (ireg_m[8] & ireg_m[7]) | ac_plm;

always @(posedge pin_clk_p)
begin
   if (plm_lat) ac_plm <= ac_plr;
   if (plr_lat) ac_plr <= ~dc[13];
end

//______________________________________________________________________________
//
// Interrupts and exceptions
//
vm3_plv plv_mx(.ib({psw[15], dc_tbit, ri[3:0],
                    ~dc[21:20], ~dc[8:6], pin_bsel}), .ov(ov));

always @(posedge pin_clk_p or posedge dclo)
begin
   if (dclo)
      dc_tbit <= 1'b0;
   else
      if (dc_stb)
         dc_tbit <= psw[4] & ~dc_rtt;
end

always @(posedge pin_clk_p)
begin
   if (ri_stb) ri <= pli_ri;

   aclo <= pin_aclo;
   halt_in <= pin_halt;
   evnt_in <= pin_evnt;
   evnt <= evnt_in;

   exc_abt_lh <= exc_abt;
   exc_abt_lhlh <= exc_abt_lh;
end

assign ir_zf = (ireg[15:0] == 16'o000000);
assign halt_req = halt_in & ~hltm;
assign halt_op = ir_zf & ~ir_stb & lin_en & ~psw[15] & ~ri[0];
assign im_dis = dc_rtt & hltm_ri;
assign ri_stb = ri_stb_s ? plr_lat : dc_stb;

always @(posedge pin_clk_n or posedge dclo)
begin
   if (dclo)
      ri_stb_s <= 1'b0;
   else
      if (ri_stb)
         ri_stb_s <= 1'b0;
      else
         if (exc_abt_st)
            ri_stb_s <= 1'b1;
end

assign hltm_set = halt_op | pli_ro[8] | pli_ro[0];
assign hltm_clr = pf_00 & ~dc_stb & hltm_dc & dc_rtx;

always @(posedge pin_clk_p or posedge dclo)
begin
   if (dclo)
      hltm_dc <= 1'b0;
   else
      if (dc_stb)
         hltm_dc <= hltm;

   if (dclo)
      hltm_ri <= 1'b0;
   else
      if (ri_stb)
         hltm_ri <= hltm & ~hltm_clr | hltm_set;

   if (dclo)
      hltm <= 1'b0;
   else
      if (hltm_clr)
         hltm <= 1'b0;
      else
         if (hltm_set & ri_stb)
            hltm <= 1'b1;
end

vm3_pli pli_mx(.rq({im_dis, pli_rq}), .ro(pli_ro), .ri(pli_ri));

always @(posedge pin_clk_p)
begin
   pli_rq[4] <= psw[4] & ~dc_rtt;
   if (irq_lat)
   begin
      pli_rq[0] <= dbl_req & ~(irq_ack & hltm) | ~irq_ack & dbl_exc;
      pli_rq[1] <= mmu_req & ~(irq_ack & mmu_rq_clr) | ~irq_ack & mmu_exc;
      pli_rq[2] <= ber_req & ~(irq_ack & ber_rq_clr) | ~irq_ack & bus_exc;
      pli_rq[3] <= fpp_req & ~(irq_ack & fpp_rq_clr) | ~irq_ack & fpp_exc;
      pli_rq[5] <= ysp_req & ~(irq_ack & ysp_rq_clr) | ~irq_ack & ysp_exc;
      pli_rq[6] <= aclo_ok & ~(irq_ack & ac_th_clr | hltm);
      pli_rq[7] <= aclo_bad & ~(irq_ack & ac_tl_clr);
      pli_rq[8] <= halt_req;
      pli_rq[9] <= evnt_req & ~(irq_ack & ev_rq_clr);
      pli_rq[10] <= irq_req;
   end
end

assign irq_req = ~aclo & ((psw[7:5] < 3'o7) & pin_virq[3]
                        | (psw[7:5] < 3'o6) & pin_virq[2]
                        | (psw[7:5] < 3'o5) & pin_virq[1]
                        | (psw[7:5] < 3'o4) & pin_virq[0]);

always @(posedge pin_clk_p or posedge pin_init_in)
begin
   if (pin_init_in)
   begin
      ac_tl <= 1'b0;
      ac_th <= 1'b0;
      evnt_th <= 1'b0;
      fpp_req <= 1'b0;
      mmu_req <= 1'b0;
      dbl_req <= 1'b0;
      ber_req <= 1'b0;
      ysp_req <= 1'b0;
   end
   else
   begin
      if (irq_ack)
      begin
         if (ac_th_clr | hltm) ac_th <= 1'b0;
         if (ac_tl_clr) ac_tl <= 1'b0;
         if (ev_rq_clr) evnt_th <= 1'b0;
         if (fpp_rq_clr) fpp_req <= 1'b0;
         if (mmu_rq_clr) mmu_req <= 1'b0;
         if (ber_rq_clr) ber_req <= 1'b0;
         if (ysp_rq_clr) ysp_req <= 1'b0;
         if (hltm) dbl_req <= 1'b0;
      end
      else
      begin
         if (hltm)
            ac_th <= 1'b0;
         else
            if (aclo) ac_th <= 1'b1;
         if (~aclo) ac_tl <= 1'b1;
         if (evnt) evnt_th <= 1'b1;
         if (fpp_exc) fpp_req <= 1'b1;
         if (mmu_exc) mmu_req <= 1'b1;
         if (bus_exc) ber_req <= 1'b1;
         if (ysp_exc) ysp_req <= 1'b1;
         if (dbl_exc) dbl_req <= 1'b1;
      end
   end
end

always @(posedge pin_clk_p)
begin
   if (ri_stb)
   begin
      ac_th_clr <= pli_ro[6];
      ac_tl_clr <= pli_ro[7];
      ev_rq_clr <= pli_ro[9];
      fpp_rq_clr <= pli_ro[3];
      mmu_rq_clr <= pli_ro[1];
      ber_rq_clr <= pli_ro[2];
      ysp_rq_clr <= pli_ro[5];
   end
end

assign irq_ack = ov[4] & vec_stb;
assign irq_lat = exc_abt_st | (~plr_lat & plm_en) | (pf_00 & plm_lat_hl);
assign exc_abt = dbl_exc | bus_exc | mmu_req | fpp_req;
assign exc_abt_st = exc_abt & ~exc_abt_lh;
assign aclo_ok = ac_th & ~aclo & ~hltm;
assign aclo_bad = ac_tl & aclo & ~hltm;
assign evnt_req = (psw[7:5] >= 3'o6) & ~evnt & evnt_th;
assign abort = exc_abt & ~exc_abt_lhlh;

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      ysp_en <= 1'b1;
   else
      if (pf_00)
         ysp_en <= 1'b1;
      else
         if (ysp_rq_clr & dc_stb_h)
            ysp_en <= 1'b0;
end

always @(posedge pin_clk_p or posedge dclo)
begin
   if (dclo)
      vec_bus <= 1'b0;
   else
      if (dc_stb & pf_00)
         vec_bus <= 1'b0;
      else
         if (vec_stb)
            vec_bus <= 1'b1;
end

assign fpp_exc = 1'b0;
assign ysp_exc = ysp_en & alu_zhr & gr_wr[3] & gr0_wl
               & ~plm_as[33] & ~plm_as[26] & plm_as[21] & ~plm_as[20];
assign bus_exc = qerr & ~vec_bus;
assign dbl_exc = qerr & vec_bus;

always @(posedge pin_clk_p) mmu_exc <= mmu_en & ((mrqt_er & ba_lat2) | ir_mmu_err);

//______________________________________________________________________________
//
// Branch circuits
//
vm3_plb plb_mx(.br({ireg_p[15], ireg_p[10:8], psw[3:0]}), .sp(m8_in[6]));

//______________________________________________________________________________
//
// Processor Status Word matrix and logic
//
// 14 inputs:
//    9:0   - flag multiplexer
//    13:10 - opcode decoder bits 21:18
//
// 5 ouputs:
//    0 - CF
//    1 - VF
//    2 - ZF
//    3 - NF
//    4 - extra ALU flag
//
vm3_plf plf_mx(.cf(cia), .fl(plf));

assign cia_s4 = ~(alu_shr & af[0]);
assign cia_s6 = ~(plm[28] ? af[15] : af[7]);

always @(posedge pin_clk_p)
begin
   if (alu_wr)
      eaf4 <= plf[4] & ~eac[4];

   if (alu_stb & alu_wr_rc)
   begin
      cia[0]  <= ~(rra_shr & rra[0]);
      cia[1]  <= ~(f[15:0] == 16'o177777);
      cia[2]  <= ~(plm[28] ? f[15] : f[7]);
      cia[3]  <= ~(plm[28] ? (c15af ^ c[14]) : (c[7] ^ c[6]));
      cia[4]  <= ~(alu_shr & af[0]);
      cia[5]  <= ~(plm[28] ? ~c15af : ~c[7]);
      cia[6]  <= ~(plm[28] ? af[15] : af[7]);
      cia[7]  <= psw[0];
      cia[8]  <= alu_zf & (rra_zf | dcf_m[3] | dcf_m[1] | ~dcf_m[0]);
      cia[9]  <= eaf4;
      cia[10] <= dcf_m[0] & (~eac[2] | ~eac[3]);
      cia[11] <= dcf_m[1];
      cia[12] <= dcf_m[2] & (~eac[2] | ~eac[3]);
      cia[13] <= dcf_m[3];

      alu_nfr <= plm[28] ? f[15] : f[7];
      alu_zfr <= alu_zf;
   end
end

always @(posedge pin_clk_p)
begin
   if (alu_stb & alu_wr_rc)
      psw_smod_sa <= psw_smod;

   if (pswh_inf)
      psw[15:12] <= {fr[15:14], psw_smod_sa ? psw[15:14] : fr[15:14]};
   else
      if (pswh_ind)
         psw[15:12] <= fx[15:12];

   psw[11:8] <= 4'b0000;               // always zero, reserved

   if (dclo)
      psw[7:4] <= 4'b0000;
   else
   begin
      if (pswh_inf)
         psw[7:5] <= fr[7:5];
      else
         if (pswl_ind)
            psw[7:5] <= fx[7:5];
      if (pswl_inf)                    // T-bit can't be altered
         psw[4] <= fr[4];               // from data bus, ALU only
   end

   if (pswl_ind)
      psw[3:0] <= fx[3:0];
   else
      if (pswl_inp)
         psw[3:0] <= plf[3:0];
      else
         if (pswl_inf)
            psw[3:0] <= fr[3:0];
         else
            if (pswl_ins)              // restore flags on bus timeout
               psw[3:0] <= psw_s[3:0]; // from the hidden backup register

   if (pswl_stb)
      psw_s[3:0] <= psw[3:0];          // save flags to backup register
end

assign psw_smod = ~ba_pca & mt_op[1];
assign pswl_ins = pswl_ins_t & qerr_lh;
assign pswh_ind = rg_wr & r7777 & dwbh;
assign pswl_ind = rg_wr & r7777 & dwbl;
assign pswh_inf = pswh_inf_t & alu_wr;
assign pswl_inf = pswl_inf_t & alu_wr;
assign pswl_inp = pswl_inp_t & alu_wr & ~pswl_ind;
assign pswl_stb = (plm_as[31:29] == 3'b100) & ~alu_wr & alu_stb;

always @(posedge pin_clk_p)
begin
   if (alu_stb & alu_wr_rc)
   begin
      pswl_inp_t <= plm_as[18];
      pswh_inf_t <= (plm_as[31:29] == 3'b101) & (~mt_mod[6] | ~dc_rtx);
      pswl_inf_t <= (plm_as[31:29] == 3'b101);
      pswl_ins_t <= (plm_as[31:29] == 3'b100);
   end
end

//______________________________________________________________________________
//
// ALU input multiplexers
//
assign x = (pc_rx  ? pc  : 16'o000000)       // Program counter
         | (mx_rx  ? mx  : 16'o000000)       // Extended mux
         | (gr0_rx ? rx0 : 16'o000000)       // Register file 0
         | (gr1_rx ? rx1 : 16'o000000);      // Register file 1

assign y = (pc_ry  ? pc  : 16'o000000)       // Program counter
         | (my_ry  ? my  : 16'o000000)       // Extended mux
         | (gr0_ry ? ry0 : 16'o000000)       // Register file 0
         | (gr1_ry ? ry1 : 16'o000000);      // Register file 1

assign mx = (dx_mx  ? dx  : 16'o000000)      // Data bus byte swap
          | (rra_mx ? rra : 16'o000000)      // EA shift register
          | (psw_mx ? psw : 16'o000000);     // Processor status word

assign my = (dx_my   ? dx   : 16'o000000)    // Data bus byte swap
          | (rra_my  ? rra  : 16'o000000)    // EA shift register
          | (vsel_my ? vmux : 16'o000000)    // Vector selector
          | (csel_my ? cmux : 16'o000000);   // Constant selector

assign psw_mx =  plm[11] &  plm[15];
assign mx_rx  =  plm[11] | ~plm[15];
assign pc_rx  = ~plm[11] &  plm[15] & rsel[2] & rsel[1] & rsel[0];
assign dx_mx  =  plm[11] & ~plm[15];
assign rra_mx = ~plm[11] & ~plm[15];

assign my_ry  =  plm[22] | ~plm[24];
assign pc_ry  = ~plm[22] &  plm[24] & rsel[6] & rsel[5] & rsel[4];
assign dx_my  =  plm[22] & ~plm[24];
assign rra_my =  plm[22] &  plm[24];

assign gr0_rx = ~mx_rx & (dst_r6 ? sys_r6 : ~rsel[0]);
assign gr0_ry = ~my_ry & (src_r6 ? sys_r6 : ~rsel[4]);
assign gr1_rx = ~mx_rx & (dst_r6 ? ~sys_r6 : rsel[0]);
assign gr1_ry = ~my_ry & (src_r6 ? ~sys_r6 : rsel[4]);

//______________________________________________________________________________
//
// ALU address request - pre- and post-processing
//
assign ba_lat = hm_lat & plm_f32 & alu_rd
              | hm_lat & (plm_f30 | plm_f31) & alu_stb & alu_wr_rc;

always @(posedge pin_clk_p)
begin
   if (hm_lat)
   begin
      if (alu_rd & plm_f32) ba_ax <= x;
      if (alu_stb & alu_wr_rc & (plm_f30 | plm_f31)) ba_fr <= f;
      if (ba_lat) ba_fsel <= ~(alu_rd & plm_f32);
   end
end

//______________________________________________________________________________
//
// ALU control matrix and controls
//
// 11 inputs:
//    6:0   - control inputs
//    10:7  - microcode matrix ouptus [33,26,21,20]
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
vm3_plc plc_mx(.ic({plm[33], plm[26], plm[21], plm[20], ic}), .oc(ac));

always @(posedge pin_clk_p)
begin
   if (~alu_stb)
   begin
      ic[0] <= ic0_t;
      ic[1] <= ic1_t;
      ic[2] <= r11_b15 ^ cia[6];
      ic[3] <= r10_b15 ^ cia[6];
      ic[4] <= act_zf;
      ic[5] <= plm[33] ? ~alu_zfr : act_n[5];
      ic[6] <= plm[33] ? ~rra[0] : act_n[0];
   end
   if (alu_stb)
   begin
      ic0_t <= ~ac[8];
      ic1_t <= ~ac[11];
   end
end

assign eac[0] = ac[2];
assign eac[1] = ac[10];
assign eac[2] = ac[14];
assign eac[3] = ac[15];
assign eac[4] = ac[5];

assign alu_b = ~ac[6];     // X-argument inversion
assign alu_c = ~ac[9];     // no add - suppress carries
assign alu_d = ~ac[0];     // ALU AND control
assign alu_e = ~ac[4];     // ALU AND control
assign alu_f = ~ac[3];     // ALU OR control
assign alu_g = ~ac[1];     // ALU OR control
assign alu_ac = ~ac[7];    // ALU adder lsb carry

assign alu_shl = ac[13];
assign alu_shr = ~ac[17];
assign alu_dir = ~ac[16];

//
// ALIU output shifter
//
assign f = (alu_dir ? af : 16'o000000)
         | (alu_shr ? {cin15, af[15:9], cin7, af[7:1]} : 16'o000000)
         | (alu_shl ? {af[14:0], cin0} : 16'o000000);

always @(posedge pin_clk_p)
begin
   if (alu_rd) ax <= x;
   if (alu_rd) ay <= y;
   if (alu_stb) fr <= f;
end

assign ana = (alu_d ?  ay : 16'o000000) & (alu_b ? ~ax : ax)
           | (alu_e ? ~ay : 16'o000000) & (alu_b ? ~ax : ax);

assign ora = (alu_b ? ~ax : ax)
           | (alu_f ? ~ay : 16'o000000)
           | (alu_g ?  ay : 16'o000000);

assign s = ora & ~ana;
assign c = ana | ora & {c[14:0], alu_ac};
assign af = s ^ (alu_c ? 16'o000000 : {c[14:0], alu_ac});

assign alu_zhr = (fr[15:8] == 8'b00000000);
assign alu_zh = (f[15:8] == 8'b00000000);
assign alu_zl = (f[7:0] == 8'b00000000);
assign alu_zf = alu_zl & (alu_zh | ~plm[28]);

assign cin0 = psw[0] & ~ac[12] | rra[15] & (eac[2] | ~eac[3]);
assign cin7 = plm[28] ? af[8] : (ac[12] ? af[7] : psw[0]);
assign cin15 = ac[12] ? (s[15] ? ~c15af : c15af) : psw[0];
assign c15af = c[15] & ~alu_c;

//______________________________________________________________________________
//
// Extended arithmetics shift register
//
always @(posedge pin_clk_p) if (rra_wr) rra <= rra_ix;

assign rra_ix = rra_shr ? {rra_in15, rra[15:1]} :
                rra_shl ? {rra[14:0], rra_in0} : fr;

assign rra_zf = (rra_ix == 16'o000000);
assign rra_shl = eac[2];
assign rra_shr = ~eac[1];
assign rra_in0 = ~eac[3] & (r10_b15 ^ cia_s6);
assign rra_in15 = ~cia_s4;

assign rra_wr = (rra_shr | rra_shl | (plm_as[31:29] == 3'b000)) & alu_wr;

//______________________________________________________________________________
//
// Extended arithmetics counter
//
always @(posedge pin_clk_p)
begin
   if (alu_wr)
   begin
      if (act_wr)
         act_n <= fr[5:0];
      else
      begin
         if (act_w15)
            act_n <= 6'b001111;
         else
            if (act_w17)
               act_n <= 6'b010001;
            else
               act_n <= act_n ^ {1'b0, act_c[3:0], 1'b1};
      end
   end
end

assign act_wr = alu_wr & plm_rw & act_wr_t;
assign act_c = ~act_n[3:0] & {act_c[2:0], 1'b1};
assign act_zf = (act_n[4:1] == 4'b0000);

assign act_w15 = ~eac[0] & eac[3] & ~eac[4];
assign act_w17 = ~eac[0] & ~eac[3];

//______________________________________________________________________________
//
// Source/destination selector for X-bus/argument
//
// index reg   bank  strobe
//   0   R0    gp0      0
//   1   R1    gp1      0
//   2   R2    gp0      1
//   3   R3    gp1      1
//   4   R4    gp0      2
//   5   R5    gp1      2
//   6   KSP   gp0      3     system mode SP
//   6   USP   gp1      3     user mode SP
//   7   PC    pc3      -
//  10   R10   gp0      4     halt mode SP
//  11   R11   gp1      4
//  12
//  13
//  14   ACT   act      -     arithmetics counter
//  15   R5    gp1      2
//  16   KSP   gp0      3     system mode
//  16   USP   gp1      3     user mode
//  17   PC    pc3      -
//
assign rsel[0] = ~plm[17] & ~plm[32] & (ireg_m[6] | ~plm85n)
               | ~plm[17] &  plm[32] & (~plm[34]  | ~plm85n)
               |  plm[17] &  ireg_m[0];

assign rsel[1] = ~plm[17] & ~plm[32] & ireg_m[7]
               | ~plm[17] &  plm[32] & ~plm[35] & (plm[36] | ~plm[34] | ~plm85n | ~hltm)
               |  plm[17] &  ireg_m[1];

assign rsel[2] = ~plm[17] & ~plm[32] & ireg_m[8]
               | ~plm[17] &  plm[32] & ~plm[36] & (plm[35] | ~plm[34] | ~plm85n | ~hltm)
               |  plm[17] &  ireg_m[2];

assign rsel[3] = ~plm[17] & ~plm[32] & 1'b0
               | ~plm[17] &  plm[32] & 1'b1
               |  plm[17] & 1'b0;

//
// Source selector for Y-bus/argument
//
assign rsel[4] =  plm[32] & (ireg_m[6] | ~plm85n)
               | ~plm[32] & (~plm[34] | ~plm85n);

assign rsel[5] =  plm[32] & ireg_m[7]
               | ~plm[32] & ~plm[35] & (plm[36] | ~plm[34] | ~plm85n | ~hltm);

assign rsel[6] =  plm[32] & ireg_m[8]
               | ~plm[32] & ~plm[36] & (plm[35] | ~plm[34] | ~plm85n | ~hltm);

assign rsel[7] = ~plm[32];

//
// Constant and interrupt vector selectors
//
assign vsel_my = ~plm[24] & ~plm[22] & ~plm[13] & (plm[37:34] == 4'b1111);
assign csel_my = ~plm[24] & ~plm[22] & ~(~plm[13] & (plm[37:34] == 4'b1111));
assign vec_stb = alu_rd & vsel_my;

//
// Register strobe input latches
//
always @(posedge pin_clk_p)
begin
   if (alu_rd)
   begin
      gr_wr_t <= gr_rx;
      gr0_wr_t <= dst_r6 ? sys_r6 : ~rsel[0];
      gr1_wr_t <= dst_r6 ? ~sys_r6 : rsel[0];
      act_wr_t <= rsel[3:0] == 4'b1100;
      pc_wr_t <= rsel[2:0] == 3'b111;
   end
end

assign gr_rx[0] = ~rsel[3] & ~rsel[2] & ~rsel[1];  // R1:R0
assign gr_rx[1] = ~rsel[3] & ~rsel[2] &  rsel[1];  // R3:R2
assign gr_rx[2] = (~rsel[3] | rsel[0])             // R15 & R5
                &  rsel[2] & ~rsel[1];             // R5:R4
assign gr_rx[3] = rsel[2] &  rsel[1] & ~rsel[0];   // USP:KSP
assign gr_rx[4] = rsel[3] & ~rsel[2] & ~rsel[1];   // R11:R10

assign gr_ry[0] = ~rsel[7] & ~rsel[6] & ~rsel[5];  // R1:R0
assign gr_ry[1] = ~rsel[7] & ~rsel[6] &  rsel[5];  // R3:R2
assign gr_ry[2] = (~rsel[7] | rsel[4])             // R15 & R5
                &  rsel[6] & ~rsel[5];             // R5:R4
assign gr_ry[3] = rsel[6] &  rsel[5] & ~rsel[4];   // USP:KSP
assign gr_ry[4] = rsel[7] & ~rsel[6] & ~rsel[5];   // R11:R10

assign gr_wr = (alu_wr & plm_rw) ? gr_wr_t : 5'b00000;

assign plm_rw = (plm_as[31:29] == 3'b010) | (plm_as[31] & plm_as[30]);
assign dst_r6 = rsel[2] & rsel[1] & ~rsel[0];
assign src_r6 = rsel[6] & rsel[5] & ~rsel[4];
assign psw_r6 = (iop != 4'b0001) & (iop != 4'b1000);
assign sys_r6 = psw_r6 ? ~psw[15] : ~psw[13];

assign gr0_wl = alu_wr & plm_rw & gr0_wr_t;
assign gr0_wh = alu_wr & plm_rw & gr0_wr_t & plm_as[28];

assign gr1_wl = alu_wr & plm_rw & gr1_wr_t;
assign gr1_wh = alu_wr & plm_rw & gr1_wr_t & plm_as[28];

//______________________________________________________________________________
//
// Register files
//
always @(posedge pin_clk_p)
begin
   if (gr0_wl)
   begin
      if (gr_wr[0]) gr0[0][7:0] <= fr[7:0];
      if (gr_wr[1]) gr0[1][7:0] <= fr[7:0];
      if (gr_wr[2]) gr0[2][7:0] <= fr[7:0];
      if (gr_wr[3]) gr0[3][7:0] <= fr[7:0];
      if (gr_wr[4]) gr0[4][7:0] <= fr[7:0];
   end
   if (gr0_wh)
   begin
      if (gr_wr[0]) gr0[0][15:8] <= fr[15:8];
      if (gr_wr[1]) gr0[1][15:8] <= fr[15:8];
      if (gr_wr[2]) gr0[2][15:8] <= fr[15:8];
      if (gr_wr[3]) gr0[3][15:8] <= fr[15:8];
      if (gr_wr[4]) gr0[4][15:8] <= fr[15:8];
   end
   if (gr1_wl)
   begin
      if (gr_wr[0]) gr1[0][7:0] <= fr[7:0];
      if (gr_wr[1]) gr1[1][7:0] <= fr[7:0];
      if (gr_wr[2]) gr1[2][7:0] <= fr[7:0];
      if (gr_wr[3]) gr1[3][7:0] <= fr[7:0];
      if (gr_wr[4]) gr1[4][7:0] <= fr[7:0];
   end
   if (gr1_wh)
   begin
      if (gr_wr[0]) gr1[0][15:8] <= fr[15:8];
      if (gr_wr[1]) gr1[1][15:8] <= fr[15:8];
      if (gr_wr[2]) gr1[2][15:8] <= fr[15:8];
      if (gr_wr[3]) gr1[3][15:8] <= fr[15:8];
      if (gr_wr[4]) gr1[4][15:8] <= fr[15:8];
   end
end

assign r10_b15 = gr0[4][15];  // auxiliary direct outputs
assign r11_b15 = gr1[4][15];  // for extended arithmetics

assign rx0 = (gr_rx[0] ? gr0[0] : 16'o000000)
           | (gr_rx[1] ? gr0[1] : 16'o000000)
           | (gr_rx[2] ? gr0[2] : 16'o000000)
           | (gr_rx[3] ? gr0[3] : 16'o000000)
           | (gr_rx[4] ? gr0[4] : 16'o000000);

assign rx1 = (gr_rx[0] ? gr1[0] : 16'o000000)
           | (gr_rx[1] ? gr1[1] : 16'o000000)
           | (gr_rx[2] ? gr1[2] : 16'o000000)
           | (gr_rx[3] ? gr1[3] : 16'o000000)
           | (gr_rx[4] ? gr1[4] : 16'o000000);

assign ry0 = (gr_ry[0] ? gr0[0] : 16'o000000)
           | (gr_ry[1] ? gr0[1] : 16'o000000)
           | (gr_ry[2] ? gr0[2] : 16'o000000)
           | (gr_ry[3] ? gr0[3] : 16'o000000)
           | (gr_ry[4] ? gr0[4] : 16'o000000);

assign ry1 = (gr_ry[0] ? gr1[0] : 16'o000000)
           | (gr_ry[1] ? gr1[1] : 16'o000000)
           | (gr_ry[2] ? gr1[2] : 16'o000000)
           | (gr_ry[3] ? gr1[3] : 16'o000000)
           | (gr_ry[4] ? gr1[4] : 16'o000000);

//______________________________________________________________________________
//
// PC registers
//
always @(posedge pin_clk_p)
begin
   if (pc_wr0)
      pc <= fr;
   else
      if (pc_wr1)
         pc[15:1] <= pc_wr2 ? pca[15:1]: pc2[15:1];

   if (pc_wr0)
      pc2[15:0] <= {fr[15:1], 1'b0};
   else
      if (pc_wr2)
         pc2[15:0] <= {pca[15:1], 1'b0};
end

assign pca = {pc2[15:1], pc[0]} + 16'o000002;

//______________________________________________________________________________
//
// MMU registers
//
always @(posedge pin_clk_p)
begin
   if (par_wl)
   begin
      if (parh_sel[2]) parh[7:0] <= fx[7:0];
      if (padr_sel[0]) par[0][7:0] <= fx[7:0];
      if (padr_sel[1]) par[1][7:0] <= fx[7:0];
      if (padr_sel[2]) par[2][7:0] <= fx[7:0];
      if (padr_sel[3]) par[3][7:0] <= fx[7:0];
      if (padr_sel[4]) par[4][7:0] <= fx[7:0];
      if (padr_sel[5]) par[5][7:0] <= fx[7:0];
      if (padr_sel[6]) par[6][7:0] <= fx[7:0];
      if (padr_sel[7]) par[7][7:0] <= fx[7:0];
      if (padr_sel[8]) par[8][7:0] <= fx[7:0];
      if (padr_sel[9]) par[9][7:0] <= fx[7:0];
      if (padr_sel[10]) par[10][7:0] <= fx[7:0];
      if (padr_sel[11]) par[11][7:0] <= fx[7:0];
      if (padr_sel[12]) par[12][7:0] <= fx[7:0];
      if (padr_sel[13]) par[13][7:0] <= fx[7:0];
      if (padr_sel[14]) par[14][7:0] <= fx[7:0];
      if (padr_sel[15]) par[15][7:0] <= fx[7:0];
   end
   if (par_wh)
   begin
      if (parh_sel[2]) parh[15:8] <= fx[15:8];
      if (padr_sel[0]) par[0][15:8] <= fx[15:8];
      if (padr_sel[1]) par[1][15:8] <= fx[15:8];
      if (padr_sel[2]) par[2][15:8] <= fx[15:8];
      if (padr_sel[3]) par[3][15:8] <= fx[15:8];
      if (padr_sel[4]) par[4][15:8] <= fx[15:8];
      if (padr_sel[5]) par[5][15:8] <= fx[15:8];
      if (padr_sel[6]) par[6][15:8] <= fx[15:8];
      if (padr_sel[7]) par[7][15:8] <= fx[15:8];
      if (padr_sel[8]) par[8][15:8] <= fx[15:8];
      if (padr_sel[9]) par[9][15:8] <= fx[15:8];
      if (padr_sel[10]) par[10][15:8] <= fx[15:8];
      if (padr_sel[11]) par[11][15:8] <= fx[15:8];
      if (padr_sel[12]) par[12][15:8] <= fx[15:8];
      if (padr_sel[13]) par[13][15:8] <= fx[15:8];
      if (padr_sel[14]) par[14][15:8] <= fx[15:8];
      if (padr_sel[15]) par[15][15:8] <= fx[15:8];
   end

   if (pdr_wl)
   begin
      if (padr_sel[0]) pdr[0][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[1]) pdr[1][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[2]) pdr[2][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[3]) pdr[3][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[4]) pdr[4][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[5]) pdr[5][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[6]) pdr[6][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[7]) pdr[7][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[8]) pdr[8][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[9]) pdr[9][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[10]) pdr[10][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[11]) pdr[11][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[12]) pdr[12][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[13]) pdr[13][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[14]) pdr[14][5:1] <= {2'b00, fx[3:1]};
      if (padr_sel[15]) pdr[15][5:1] <= {2'b00, fx[3:1]};
   end
   if (pdr_wh)
   begin
      if (padr_sel[0]) pdr[0][14:8] <= fx[14:8];
      if (padr_sel[1]) pdr[1][14:8] <= fx[14:8];
      if (padr_sel[2]) pdr[2][14:8] <= fx[14:8];
      if (padr_sel[3]) pdr[3][14:8] <= fx[14:8];
      if (padr_sel[4]) pdr[4][14:8] <= fx[14:8];
      if (padr_sel[5]) pdr[5][14:8] <= fx[14:8];
      if (padr_sel[6]) pdr[6][14:8] <= fx[14:8];
      if (padr_sel[7]) pdr[7][14:8] <= fx[14:8];
      if (padr_sel[8]) pdr[8][14:8] <= fx[14:8];
      if (padr_sel[9]) pdr[9][14:8] <= fx[14:8];
      if (padr_sel[10]) pdr[10][14:8] <= fx[14:8];
      if (padr_sel[11]) pdr[11][14:8] <= fx[14:8];
      if (padr_sel[12]) pdr[12][14:8] <= fx[14:8];
      if (padr_sel[13]) pdr[13][14:8] <= fx[14:8];
      if (padr_sel[14]) pdr[14][14:8] <= fx[14:8];
      if (padr_sel[15]) pdr[15][14:8] <= fx[14:8];
   end
   pdr[0][7] <= 1'b0;
   pdr[1][7] <= 1'b0;
   pdr[2][7] <= 1'b0;
   pdr[3][7] <= 1'b0;
   pdr[4][7] <= 1'b0;
   pdr[5][7] <= 1'b0;
   pdr[6][7] <= 1'b0;
   pdr[7][7] <= 1'b0;
   pdr[8][7] <= 1'b0;
   pdr[9][7] <= 1'b0;
   pdr[10][7] <= 1'b0;
   pdr[11][7] <= 1'b0;
   pdr[12][7] <= 1'b0;
   pdr[13][7] <= 1'b0;
   pdr[14][7] <= 1'b0;
   pdr[15][7] <= 1'b0;
end

assign mmu_a[15:0] = (parh_sel[2] ? parh : 16'o000000)
                   | (parh_sel[3] ? 16'o177600 : 16'o000000)
                   | (padr_sel[0] ? par[0] : 16'o000000)
                   | (padr_sel[1] ? par[1] : 16'o000000)
                   | (padr_sel[2] ? par[2] : 16'o000000)
                   | (padr_sel[3] ? par[3] : 16'o000000)
                   | (padr_sel[4] ? par[4] : 16'o000000)
                   | (padr_sel[5] ? par[5] : 16'o000000)
                   | (padr_sel[6] ? par[6] : 16'o000000)
                   | (padr_sel[7] ? par[7] : 16'o000000)
                   | (padr_sel[8] ? par[8] : 16'o000000)
                   | (padr_sel[9] ? par[9] : 16'o000000)
                   | (padr_sel[10] ? par[10] : 16'o000000)
                   | (padr_sel[11] ? par[11] : 16'o000000)
                   | (padr_sel[12] ? par[12] : 16'o000000)
                   | (padr_sel[13] ? par[13] : 16'o000000)
                   | (padr_sel[14] ? par[14] : 16'o000000)
                   | (padr_sel[15] ? par[15] : 16'o000000);

always @(posedge pin_clk_p)
begin
   if (ws_set & mm_stb)    // save MMU register selector
      ws_pdr <= padr_sel;  // issued prefetch may override
   else
      if (rd_2376)
         ws_pdr <= 16'o000000;

   if (wr_2376)   // reset page dirty W-bit
   begin
      if (padr_sel[0]) pdr[0][6] <= 1'b0;
      if (padr_sel[1]) pdr[1][6] <= 1'b0;
      if (padr_sel[2]) pdr[2][6] <= 1'b0;
      if (padr_sel[3]) pdr[3][6] <= 1'b0;
      if (padr_sel[4]) pdr[4][6] <= 1'b0;
      if (padr_sel[5]) pdr[5][6] <= 1'b0;
      if (padr_sel[6]) pdr[6][6] <= 1'b0;
      if (padr_sel[7]) pdr[7][6] <= 1'b0;
      if (padr_sel[8]) pdr[8][6] <= 1'b0;
      if (padr_sel[9]) pdr[9][6] <= 1'b0;
      if (padr_sel[10]) pdr[10][6] <= 1'b0;
      if (padr_sel[11]) pdr[11][6] <= 1'b0;
      if (padr_sel[12]) pdr[12][6] <= 1'b0;
      if (padr_sel[13]) pdr[13][6] <= 1'b0;
      if (padr_sel[14]) pdr[14][6] <= 1'b0;
      if (padr_sel[15]) pdr[15][6] <= 1'b0;
   end
   if (wf_set) // set page dirty W-bit
   begin
      if (ws_pdr[0]) pdr[0][6] <= 1'b1;
      if (ws_pdr[1]) pdr[1][6] <= 1'b1;
      if (ws_pdr[2]) pdr[2][6] <= 1'b1;
      if (ws_pdr[3]) pdr[3][6] <= 1'b1;
      if (ws_pdr[4]) pdr[4][6] <= 1'b1;
      if (ws_pdr[5]) pdr[5][6] <= 1'b1;
      if (ws_pdr[6]) pdr[6][6] <= 1'b1;
      if (ws_pdr[7]) pdr[7][6] <= 1'b1;
      if (ws_pdr[8]) pdr[8][6] <= 1'b1;
      if (ws_pdr[9]) pdr[9][6] <= 1'b1;
      if (ws_pdr[10]) pdr[10][6] <= 1'b1;
      if (ws_pdr[11]) pdr[11][6] <= 1'b1;
      if (ws_pdr[12]) pdr[12][6] <= 1'b1;
      if (ws_pdr[13]) pdr[13][6] <= 1'b1;
      if (ws_pdr[14]) pdr[14][6] <= 1'b1;
      if (ws_pdr[15]) pdr[15][6] <= 1'b1;
   end
end

assign ws_set = ~ba_pca & op1_wf;
assign wf_set = mmu_en & (op3_wf | ba_lat2 & op2_wf & ~mc_res) & wrf_set;
assign wrf_set = (rply & dout) | rmsel & ~(r757x & ~a[2] & a[1]) & pa_oe;

assign mmu_d[14:1] = (padr_sel[0] ? pdr[0] : 14'o00000)
                   | (padr_sel[1] ? pdr[1] : 14'o00000)
                   | (padr_sel[2] ? pdr[2] : 14'o00000)
                   | (padr_sel[3] ? pdr[3] : 14'o00000)
                   | (padr_sel[4] ? pdr[4] : 14'o00000)
                   | (padr_sel[5] ? pdr[5] : 14'o00000)
                   | (padr_sel[6] ? pdr[6] : 14'o00000)
                   | (padr_sel[7] ? pdr[7] : 14'o00000)
                   | (padr_sel[8] ? pdr[8] : 14'o00000)
                   | (padr_sel[9] ? pdr[9] : 14'o00000)
                   | (padr_sel[10] ? pdr[10] : 14'o00000)
                   | (padr_sel[11] ? pdr[11] : 14'o00000)
                   | (padr_sel[12] ? pdr[12] : 14'o00000)
                   | (padr_sel[13] ? pdr[13] : 14'o00000)
                   | (padr_sel[14] ? pdr[14] : 14'o00000)
                   | (padr_sel[15] ? pdr[15] : 14'o00000);

assign parh_sel[0] = ~mm_sa[2] & ~mm_sa[1] & mm_sah;
assign parh_sel[1] = ~mm_sa[2] &  mm_sa[1] & mm_sah;
assign parh_sel[2] =  mm_sa[2] & ~mm_sa[1] & mm_sah | parh_en;
assign parh_sel[3] =  mm_sa[2] &  mm_sa[1] & mm_sah;

assign padr_sel[0]  = (mm_sa == 4'b0000) & ~mm_sah;
assign padr_sel[1]  = (mm_sa == 4'b0001) & ~mm_sah;
assign padr_sel[2]  = (mm_sa == 4'b0010) & ~mm_sah;
assign padr_sel[3]  = (mm_sa == 4'b0011) & ~mm_sah;
assign padr_sel[4]  = (mm_sa == 4'b0100) & ~mm_sah;
assign padr_sel[5]  = (mm_sa == 4'b0101) & ~mm_sah;
assign padr_sel[6]  = (mm_sa == 4'b0110) & ~mm_sah;
assign padr_sel[7]  = (mm_sa == 4'b0111) & ~mm_sah;
assign padr_sel[8]  = (mm_sa == 4'b1000) & ~mm_sah;
assign padr_sel[9]  = (mm_sa == 4'b1001) & ~mm_sah;
assign padr_sel[10] = (mm_sa == 4'b1010) & ~mm_sah;
assign padr_sel[11] = (mm_sa == 4'b1011) & ~mm_sah;
assign padr_sel[12] = (mm_sa == 4'b1100) & ~mm_sah;
assign padr_sel[13] = (mm_sa == 4'b1101) & ~mm_sah;
assign padr_sel[14] = (mm_sa == 4'b1110) & ~mm_sah;
assign padr_sel[15] = (mm_sa == 4'b1111) & ~mm_sah;

assign mm_stb = mm_stbs | rd_2376 | wr_2376;
assign mm_stb_set = (ba_pca & ~ba_pca_hl)
                  | (hm_men & ba_rdy_l & ~sa_pfa & ~hm_lat & ~at_stb & ~ba_pca);

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      mm_stbs <= 1'b0;
   else
      if (sa_s16 | at_stb)
         mm_stbs <= 1'b0;
      else
         if (mm_stb_set)
            mm_stbs <= 1'b1;
end

always @(posedge pin_clk_p)
begin
   if (~mm_stb)
   begin
      mm_sa <= r2376 ? (pa_oe ? {a[6], a[3:1]} : {la[6], la[3:1]})
                     : {~mt_mod[6], ba[15:13]};
      mm_sah <= hmod & ~r2376;
   end

   mm_stb_clr <= sa_s16 | at_stb;
end

assign parh_en = parh_wr | parh_oe;
assign parh_wr = rg_wr & r251x & ~la[2];

assign par_wl = parh_wr | wr_2376 & la[5] & dwbl;
assign par_wh = parh_wr | wr_2376 & la[5] & dwbh;
assign pdr_wl = wr_2376 & ~la[5] & dwbl;
assign pdr_wh = wr_2376 & ~la[5] & dwbh;

assign sr0_wl = rg_wr & r757x & ~la[2] & la[1] & dwbl;
assign sr0_wh = rg_wr & r757x & ~la[2] & la[1] & dwbh;
assign sr3_wr = rg_wr & r251x & la[2];

assign sr3_ah = sr3_as | hmod;     // 22-bit is enforced by halt mode

always @(posedge pin_clk_p or posedge pin_init_in)
begin
   if (pin_init_in)
      sr0 <= 16'o000000;
   else
   begin
      if (sr0_mrqt)
      begin
         sr0[6:5] <= mt_mod[6:5];
         sr0[3:1] <= mt_ba[15:13];
         sr0[13] <= mrqt_ro;
         sr0[14] <= mrqt_pl;
         sr0[15] <= mrqt_nr;
      end
      if (sr0_mrqs)
      begin
         sr0[6:5] <= ms_mod[6:5];
         sr0[3:1] <= ms_ba[15:13];
         sr0[13] <= 1'b0;
         sr0[14] <= mrqs_pl;
         sr0[15] <= mrqs_nr;
      end
      if (sr0_wh)
      begin
         sr0[15:13] <= fx[15:13];
         sr0[8] <= fx[8];
      end
      if (sr0_wl)
         sr0[0] <= fx[0];

      sr0[4] <= 1'b0;
      sr0[7] <= 1'b0;
      sr0[12:9] <= 4'b0000;
   end
end

always @(posedge pin_clk_p or posedge pin_init_in)
begin
   if (pin_init_in)
   begin
      sr3_um <= 1'b0;
      sr3_as <= 1'b0;
   end
   else
   if (sr3_wr)
   begin
      sr3_um <= fx[5];
      sr3_as <= fx[4];
   end
end

assign sr0_en = sr0[0];
assign sr0_m = sr0[8];
assign sr0_er = sr0[13] | sr0[14] | sr0[15];
assign mmu_en = sr0_en | sr0_m & mt_op[3];
assign hm_men = mmu_en | hmod;

always @(posedge pin_clk_p)
begin
   if (ba_lat0) sr2[0] <= ba;
   if (ba_dir) sr2[1] <= ba;
   if (ba_lat1) sr2[1] <= sr2[0];
   if (ba_lat2) sr2[2] <= sr2[1];

   if (ba_lat3)
      if (ba_lat2)
         sr2[3] <= sr2[1];
      else
         sr2[3] <= sr2[2];

   if (ba_lat4)
      if (ba_lat3)
         sr2[3] <= sr2[2];
      else
         sr2[4] <= sr2[3];
end

assign ba_rdy = ~pa_req & ~pa_oe & ~sa_sxa_h;
assign ba_dir = (sa_s16 | sa_s22) & pf_00;
assign ba_lat0 = ba_pca & at_stb;
assign ba_lat1 = sa_pfa;
assign ba_lat2 = pa_oe & (~a[0] | ~io_dc[3]);
assign ba_lat3 = ir_stb;
assign ba_lat4 = ~sr0_er & ~mrqt_er & dc_stb;

always @(posedge pin_clk_p)
begin
   if (ra_s22) msta[0] <= {mt_mod[6:5], ba[15:13], mrq_nr, mrq_pl};
   if (ba_lat1) msta[1] <= msta[0];
   if (ba_lat2) msta[2] <= msta[1];
   if (ba_lat3) msta[3] <= msta[2];
   if (init_nrpl)
   begin
      msta[0][1:0] <= 2'b00;
      msta[1][1:0] <= 2'b00;
      msta[2][1:0] <= 2'b00;
      msta[3][1:0] <= 2'b00;
   end
end

assign ms_mod[6:5] = msta[3][6:5];
assign ms_ba[15:13] = msta[3][4:2];
assign mrqs_nr = msta[3][1];
assign mrqs_pl = msta[3][0];
assign rd_err = (msta[0][0] | msta[0][1]) & ra_s22_hlh;
assign init_nrpl = pin_init_in | pf_init;

assign ir_mmu_err = (ir_oe | dc_stb) & (mrqs_pl | mrqs_nr);

always @(posedge pin_clk_n) sr0_er_hl <= sr0_er | ~mmu_en;
always @(posedge pin_clk_p) ba_lat2_lh <= ba_lat2;

always @(posedge pin_clk_n) ba_rdy_l <= ba_rdy;
always @(posedge pin_clk_p) ba_rdy_lh <= ba_rdy_l;

assign sr0_mrqs = ~mrqt_er & (ir_oe | dc_stb) & ~sr0_er_hl;
assign sr0_mrqt = ba_lat2 & ~sr0_er_hl;

//______________________________________________________________________________
//
// Address translation and prefetch pipepline
//
assign as = sa_s22 ? {at_stb ? sx[21:6] : sa[21:6], ba[5:0]} :
            sa_s16 ? {sa77 ? 6'o77 : 6'o00, ba[15:0]} :
            sa_pfa ? ra : a;

always @(posedge pin_clk_p)
begin
   if (ra_s22) ra <= {at_stb ? sx[21:6] : sa[21:6], ba[5:0]};  // translate instruction
   if (ra_s16) ra <= {sa77 ? 6'o77 : 6'o00, ba[15:0]};         // prefetch address

   if (sa_pfa) ca <= ra;                                       // store prefetch address
   if (pa_oe) adr_eq <= (ca[21:1] == a[21:1]);                 // for write compare
   if (sa_pfa | sa_sxa) a <= as;                               // strobe address register

   if (at_stb)
   begin
      sa[21:6] <= sx[21:6];
      mrq_pl_t <= sx_pl;
      mrq_ro_t <= sx_ro;
      mrq_nr_t <= sx_nr;
   end

   if (ra_s16 | ra_s22) sel_ra <= hmod & ~ba[15];
   if (sa_s16 | sa_s22) sel_sa <= hmod & ~ba[15];
   if (sa_pfa) sel_sa <= sel_ra;
end

assign sel = sel_sa;
assign sx[21:6] = {sr3_ah ? mmu_a[15:12] : 4'b0000, mmu_a[11:0]}
                + {9'b000000000 + ba[12:6]};

assign sx_pl = ~mmu_d[3] ? (ba[12:6] > mmu_d[14:8]) :    // page grows up
                           (ba[12:6] < mmu_d[14:8]);     // page grows down
assign sx_ro = op1_wf & ~mmu_d[2] & mmu_d[1];            // readonly error
assign sx_nr = ~mmu_d[1] | (mt_mod[5] ^ mt_mod[6]);      // not resident or bad mode

assign a0_reg = ba_fsel ? ba_fr[0] : ba_ax[0];
assign ba = ba_pca ? pca : (ba_fsel ? ba_fr : ba_ax);
assign sa77 = ba[15:13] == 3'b111;

assign bs_a22 = (a[21:13] == 9'o777);
assign bs_a18 = (a[17:13] == 5'o37) & ~sr3_ah;
assign bs_ax = (as[21:13] == 9'o777) | (as[17:13] == 5'o37) & ~sr3_ah;

assign mrq_pl = ~hmod & (at_stb ? sx_pl : mrq_pl_t);     // page limit error
assign mrq_ro = ~hmod & (at_stb ? sx_ro : mrq_ro_t);     // readonly error
assign mrq_nr = ~hmod & (at_stb ? sx_nr : mrq_nr_t);     // not resident or bad mode
assign mrqt_er = mrqt_pl | mrqt_ro | mrqt_nr;

assign mt_mod[5] = ((mt_op[0] | ba_pca) ? psw[14] : psw[12]) & ~psw_smod;
assign mt_mod[6] = ((mt_op[0] | ba_pca) ? psw[15] : psw[13]) & ~psw_smod;

always @(posedge pin_clk_p)
begin
   if (pin_init_in)
   begin
      mrqt_pl <= 1'b0;
      mrqt_ro <= 1'b0;
      mrqt_nr <= 1'b0;
   end
   else
   if (sa_s22)
   begin
      mt_ba[15:13] <= ba[15:13];
      mrqt_pl <= mrq_pl;
      mrqt_ro <= mrq_ro;
      mrqt_nr <= mrq_nr;
   end
end

always @(posedge pin_clk_p)
begin
   sa_s22_h <= sa_s22;
   ra_s22_h <= ra_s22;
   ra_s22_hlh <= ra_s22_h;
   sa_sxa_h <= sa_sxa;
   ba_pca_hl <= ba_pca;
end

assign ra_s16 = at_stb & ba_pca & ~(hm_men & ~sr0_m);
assign ra_s22 = at_stb & ba_pca & hm_men & ~sr0_m;
assign sa_s22 = at_stb & ~ba_pca;
assign sa_sxa = sa_s16 | sa_s22;
assign sa_s16 = ~hm_lat_set_l & ~hm_men & ~ba_pca & ~sa_pfa & ba_rdy_l & ~hm_lat;
assign sa_pfa_fc = ~mc_res & ~(sa_pfa & ~ba_rdy) & (ba_ins | sa_pfa);

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
   begin
      ba_pca <= 1'b0;
      at_stb <= 1'b0;
      sa_pfa <= 1'b0;
   end
   else
   begin
      if (mm_stb_clr)
         ba_pca <= 1'b0;
      else
         if (ba_rdy_lh & ~r2376 & ~pf_ba0_h & pc3_rdy_h & ~mm_stbs)
            ba_pca <= 1'b1;

      if (mm_stb_clr)
         at_stb <= 1'b0;
      else
         if (mm_stbs)
            at_stb <= 1'b1;

      if (sa_pfa & ~ba_rdy)
         sa_pfa <= 1'b0;
      else
         if (ba_ins)
            sa_pfa <= 1'b1;
   end
end

//______________________________________________________________________________
//
// Prefetch controls
//
assign pf = {plr[12], plr[9], plr[10]};
assign pf_rc = {pl[9], pl[10]};

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      pf_ena <= 1'b0;
   else
      if (pf_ena_clr)
         pf_ena <= 1'b0;
      else
         if (plr_lat)
            pf_ena <= 1'b1;
end

assign pf_ena_rc = ~mc_res & ~pf_ena_clr & (plr_lat | pf_ena);
assign pf_00_rc = pf_ena_rc & (plr_lat ? ~pf_rc[1] & ~pf_rc[0] : ~pf[1] & ~pf[0]);
assign pf_10_rc = pf_ena_rc & (plr_lat ?  pf_rc[1] & ~pf_rc[0] :  pf[1] & ~pf[0]);
assign pf_pa_rc = pf_00a & pa_oe_rc;

assign pf_00 = pf_ena & ~pf[1] & ~pf[0];
assign pf_01 = pf_ena & ~pf[1] &  pf[0];
assign pf_10 = pf_ena &  pf[1] & ~pf[0];
assign pf_11 = pf_ena &  pf[1] &  pf[0];
assign pf_pa = pf_00a & pa_oe;

assign pf_inv = rd_err | (qt_out & irply_en)
              | (op1_wf & opwf_clr & (rmsel | adr_eq));

assign pf_ena_clr = pf_end0 | dc_stb | (plm_lat & (pf_01 | pf_10));
assign pf_00a_rc = pf_00m & ~dc_stb_hl | plm_lat & pf_00;

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      pf_00r <= 1'b0;
   else
      if (plr_lat)
         pf_00r <= pf_00_rc;

   if (mc_res)
      pf_00m <= 1'b0;
   else
      if (dc_stb_h)
         pf_00m <= 1'b0;
      else
         if (plm_lat & pf_00)
            pf_00m <= 1'b1;

   if (mc_res)
      pf_00a <= 1'b0;
   else
      if (dc_stb)
         pf_00a <= 1'b0;
      else
         if (sa_sxa)
            pf_00a <= pf_00a_rc;
end

always @(posedge pin_clk_n) pf_ba0_hl <= pf_ba0_h;
always @(posedge pin_clk_p)
begin
   if (pf_init | sa_pfa)
      pf_ba0_h <= 1'b0;
   else
      if (ba_lat0)
         pf_ba0_h <= 1'b1;
end

assign pc_wr0 = alu_wr & plm_rw & pc_wr_t;
assign pc_wr1 = (pc_wr2 & ~pc2_wrr) | (alu_stb & pc2_wrc);
assign pc_wr2 = (pc3_rdy & ~pf_init) & (pf_init | sa_pfa) & pf_ba0_hl;
assign pc2_wrq = pf_11 & dc_en[2];
assign pc2_wrc_rc = alu_rd & pc2_wrf & pc2_wrm;

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
   begin
      pc2_wrf <= 1'b0;
      pc2_wrm <= 1'b0;
   end
   else
   begin
      if (alu_rd)
         pc2_wrm <= 1'b0;
      else
         if (plm_lat & pc2_wrr)
            pc2_wrm <= 1'b1;

      if (pc2_wrc_rc)
         pc2_wrf <= 1'b0;
      else
         if (pc2_wrr & pc_wr2)
            pc2_wrf <= 1'b1;
   end
end

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      pc2_wrr <= 1'b1;
   else
      if (plr_lat)
         pc2_wrr <= pc2_wrq | (~pf[2] & pf_01);

   if (mc_res)
      pc3_rdy <= 1'b0;
   else
      if (pf_init)
         pc3_rdy <= 1'b0;
      else
         if (pf_00m & pc_wr0)
            pc3_rdy <= 1'b1;
end

assign pf_init = pf_00 & plm_lat;
assign ir_rdy = ~ir_stb & ~ir_doe;

always @(posedge pin_clk_p)
begin
   if (pf_pa_rc)
      pa_rdy <= 1'b1;
   else
      if (pf_00m & dc_stb)
         pa_rdy <= 1'b0;
end

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      plm_rdy <= 1'b1;
   else
      if (pf_end1 | sa_pfa_fc)
         plm_rdy <= 1'b1;
      else
         if (plm_lat_fc & ~pf_00r & ~pf_rdy)
            plm_rdy <= 1'b0;
end

always @(posedge pin_clk_p)
begin
   pc2_wrc <= pc2_wrc_rc;
   pc3_rdy_h <= pc3_rdy & ~pf_init;

   pf_doe_lh <= pf_doe;
   pf_tout_lh <= pf_tout;
end

assign pf_tout = irply & pf_doe_lh;
assign pf_tout_st = pf_tout & ~pf_tout_lh;
assign pf_doe = pf_01 | pc2_wrq | ir_doe;
assign ins_set = a21_req | sa_pfa | (sa_sxa & pf_00a_rc);
assign pf_ins = ~pf_ena | pf_00 | pf_01 | pf_10 | (dc_en[0] & dc_en[2] & dc_en[3]);
assign ba_ins = pf_ba0_h & hm_lat_h & ~pf_rdy
              & ~pf_00 & pf_ins & ba_rdy
              & (~pf_doe | (~irply & ~ir_stb));

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
   begin
      a21_ins <= 1'b0;
      a21_req <= 1'b0;
   end
   else
   begin
      if (ir_stb & ir_clr)
         a21_ins <= 1'b0;
      else
         if (bus_free & ins_set)
            a21_ins <= 1'b1;

      if (~a21_ins & bus_free & ins_set)
         a21_req <= 1'b0;
      else
         if (~bus_free & ins_set)
            a21_req <= 1'b1;
   end
end

always @(posedge pin_clk_n) pf_end0 <= pf_11 & (~dc_en[2] | ~dc_en[0]);
assign pf_end1 = pf_tout_st | pf_end0;

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      pf_rdy <= 1'b1;
   else
      if (sa_pfa | pf_tout_st | pf_end0)
         pf_rdy <= 1'b1;
      else
         if (~(pf_10_rc | ~pf_ena_rc) & plm_set0)
            pf_rdy <= 1'b0;
end

//______________________________________________________________________________
//
// HALT mode flag
//
always @(posedge pin_clk_p or posedge dclo)
begin
   if (dclo)
      hmod <= 1'b0;
   else
      if (hm_lat)
         hmod <= hltm;
end

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      hm_lat <= 1'b1;
   else
      if (hm_lat_set)
         hm_lat <= 1'b1;
   else
      if (hm_lat_clr)
         hm_lat <= 1'b0;
end

assign hm_lat_clr = hm_lat & ( alu_wr & (plm_f30_as | plm_f31_as)
                             | alu_stb & plm_f32 );
assign hm_lat_set = ~ba_pca & mm_stb_clr;

always @(posedge pin_clk_p) hm_lat_h <= hm_lat;
always @(posedge pin_clk_n) hm_lat_set_l <= hm_lat_set;

//______________________________________________________________________________
//
// IO operations and memory translations decoder
//
assign iop = {plm[25], plm[27], plm[19], plm[23]};

always @(posedge pin_clk_p)
begin
   if (io_lat1)
      iop_m <= {~plm85p, iop[3:0]};

   if (io_res2)
      iop_t <= 4'b0010;
   else
      if (io_lat2)
         iop_t <= io_lat1 ? iop[3:0] : iop_m[3:0];
end

assign io_s[0] = (iop == 4'b0000);
assign io_s[1] = (iop == 4'b1001) & (ov[3:0] == 4'b0011);
assign io_s[2] = (iop == 4'b1001) & (ov[3:0] == 4'b0011) & ~dvc_stb;
assign io_s[3] = (iop == 4'b1101);

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      alu_drdy <= 1'b0;
   else
      if (do_clr)
         alu_drdy <= 1'b0;
      else
         if ((do_lat | do_oe) & ~io_s0_as)
            alu_drdy <= 1'b1;
end

always @(posedge pin_clk_p)
begin
   if (alu_stb_rc) io_s0_as <= io_s[0];
   alu_rd_lh <= alu_rd;

   if (io_lat0)
      op0_wf <= plm[23] & (~plm[25] | plm[19]);
   else
      if (alu_rd_lh)
         op0_wf <= 1'b0;

   if (opwf_clr)
      op1_wf <= 1'b0;
   else
      if (io_lat1)
         op1_wf <= op0_wf | io_lat0 & plm[23] & (~plm[25] | plm[19]);
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      op2_wf <= 1'b0;
   else
      if (ba_lat2_lh)
         op2_wf <= 1'b0;
      else
         if (sa_s22_h & ~mrqt_er & op1_wf)
            op2_wf <= 1'b1;

   if (mc_res)
      op3_wf <= 1'b0;
   else
      if (ba_lat2)
         op3_wf <= op2_wf | sa_s22_h & ~mrqt_er & op1_wf;
end

assign opwf_clr = pa_oe_lh & (~io_dc[1] | io_dc[5]);

//
// active high
// io_dc[0] - block DIN set
// io_dc[1] - read transaction
// io_dc[3] - word transaction
// io_dc[4] - write data not ready, block DOUT set
// io_dc[5] - read-modify-write transaction
//
assign io_dc[0] = (~iop_t[3] | ~iop_t[1])
                & ( iop_t[3] | ~iop_t[2] | ~iop_t[1] | iop_t[0])
                & (~iop_t[3] |  iop_t[2] |  iop_t[1] | iop_t[0])
                & (~iop_t[3] | ~iop_t[2] |  iop_t[1] | iop_t[0])
                & ~a21_ins;
assign io_dc[1] = ( iop_t[3] | ~iop_t[0]);
assign io_dc[2] = (~iop_t[3] | ~iop_t[1])
                & ( iop_t[3] | ~iop_t[2] | ~iop_t[1] | iop_t[0])
                & (~iop_t[3] |  iop_t[2] |  iop_t[1] | iop_t[0]);
assign io_dc[3] = ~iop_t[2] | ~iop_t[1] | (~iop_t[0] & ~iop_t[3]);
assign io_dc[4] =  iop_t[3] | ~iop_t[2] | iop_t[1] | ~iop_t[0] | 1'b1; // FPP removed
assign io_dc[5] =  iop_t[3] & iop_t[1] & iop_t[0];

assign mt_op[0] = (iop_m[3:0] != 4'b0001) & (iop_m[3:0] != 4'b1000);
assign mt_op[1] = (iop_m[3:0] == 4'b0110);
assign mt_op[2] = (~iop_m[3] & ~iop_m[0]) | ~iop_m[2] | ~iop_m[1];
assign mt_op[3] = iop_m[4];

assign dwbh = io_dc[3] |  la[0]; // io_dc[3] - word operation
assign dwbl = io_dc[3] | ~la[0]; //

assign io_lat0 = (plm_f30 | plm_f31 | plm_f32) & plm_lat_h;
assign io_lat1 = (plm_f30 | plm_f31 | plm_f32) & alu_rd;
assign io_lat2 = bus_free & (sa_req_l | sa_sxa);
assign io_res2 = ~io_lat2 & (mc_res | rmsel_clr | din_end | dout_end);

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      sa_req <= 1'b0;
   else
      if (io_lat2)
         sa_req <= 1'b0;
      else
         if (~bus_free & sa_sxa)
            sa_req <= 1'b1;
end

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      iop_rdy <= 1'b1;
   else
      if (io_lat2)
         iop_rdy <= 1'b1;
      else
         if (io_lat1)
            iop_rdy <= 1'b0;
end

always @(posedge pin_clk_n) sa_req_l <= sa_req;

//______________________________________________________________________________
//
// Q-bus timer - transaction and bus arbiter timeouts
//
assign qt_ena = dout | din;
assign qt_out_rc = qt[7] & qt_ena;

always @(posedge pin_clk_p)
begin
   if (qt_ena)
      qt <= qt + 8'o001;
   else
      qt <= 8'o000;

   qt_out <= qt_out_rc;
end

//______________________________________________________________________________
//
// Q-bus logic
//
assign oat = io_dc[3] & a[0] & pa_oe;
assign qtout = ir_tout | (qt_out & ~irply_en);

always @(posedge pin_clk_p)
begin
   qerr <= oat | qtout;
   qerr_lh <= qerr;
   pa_oe_lh <= pa_oe;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      pa_oe <= 1'b0;
   else
      pa_oe <= pa_oe_rc;
end

assign pa_oe_rc = pa_oe_set & ~pa_oe & ~mc_res;
assign pa_oe_set = (sa_sxa_h | sa_pfa | pa_req) & bus_free;
assign ad_oe = pa_oe | bd_oe;
assign wtbt = (~io_dc[3] & bd_oe) | (pa_oe & ~io_dc[1]);

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      bd_oe <= 1'b0;
   else
      if (dio_clr)
         bd_oe <= 1'b0;
      else
         if (dout_set & alu_drdy)
            bd_oe <= 1'b1;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      pa_req <= 1'b0;
   else
      if (pa_oe_rc)
         pa_req <= 1'b0;
      else
         if (~bus_free & (sa_sxa_h | sa_pfa))
            pa_req <= 1'b1;
end

always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      sync <= 1'b0;
   else
      if (dout_end | din_end)
         sync <= 1'b0;
      else
         if (~rmsel & pa_oe)
            sync <= 1'b1;
end

assign din_end = ~din & din_lh & ~io_dc[5];
assign dout_end = ~dout & dout_lh;
assign dio_clr_rc = rply & (ir_clr | ~a21_ins);
assign s3_out = io_s3_wr & bus_free & hm_lat & ba_rdy_l;
assign out_rs = di_rmw | s3_out | (~rmsel & pa_oe & ~io_dc[1]);

always @(posedge pin_clk_p)
begin
   dio_clr <= dio_clr_rc;
   din_lh <= din;
   dout_lh <= dout;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
   begin
      din <= 1'b0;
      dout <= 1'b0;
      dout_set <= 1'b0;
      iako_en <= 1'b0;
   end
   else
   begin
      if (dio_clr_rc)
         din <= 1'b0;
      else
         if (~rmsel & pa_oe & ~io_dc[0] | ~iako_en_lh & iako_en)
            din <= 1'b1;

      if (dio_clr_rc)
         dout <= 1'b0;
      else
         if (dout_set & ~io_dc[4] | bd_oe)
            dout <= 1'b1;

      if (dout | dout_set & ~io_dc[4] | bd_oe)
         dout_set <= 1'b0;
      else
         if (out_rs)
            dout_set <= 1'b1;

      if (~io_s[1])
         iako_en <= 1'b0;
      else
         if (iako_set)
            iako_en <= 1'b1;
   end
end

assign iako_st = iako_set & ~iako_en;
assign iako_set = ~iako_en_lh & io_s[1] & bus_free & hm_lat & ba_rdy_l;

always @(posedge pin_clk_n) iako <= din & iako_en;
always @(posedge pin_clk_p)
begin
   iako_en_lh <= iako_en;
   dvc_stb <= iako_en_lh & ~ir_stb;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      ir_tout <= 1'b0;
   else
   if (ir_oe)
      ir_tout <= irply | qt_out_rc;
end

always @(posedge pin_clk_p)
begin
   if (pin_init_in | pf_init | irply_clr)
      irply <= 1'b0;          // phantom internal reply
   else                       // for timed-out prefetch
      if (qt_out_rc)
         irply <= irply_en;

   if (iako_en)
      irply_en <= 1'b0;
   else
      if (pa_oe)
         irply_en <= irply_pf | sa_pfa & ~sa_sxa_h;

   if (sa_sxa_h)
      irply_pf <= 1'b0;
   else
      if (sa_pfa)
         irply_pf <= 1'b1;
end

always @(posedge pin_clk_p or posedge mc_res)
begin
   if (mc_res)
      arb_ena_t <= 1'b0;
   else
      if (arb_ena)
         arb_ena_t <= 1'b0;
      else
         if (di_rmw)
            arb_ena_t <= 1'b1;
end

assign arb_ena = rply_fc & (arb_ena_t | a21_ins | ~io_dc[5]);
assign dmr_clr = iako_set | s3_out | pa_oe_set;
assign bus_free = ~rply & dmr_en;

always @(posedge pin_clk_p) dmr_clr_h <= dmr_clr;
always @(posedge pin_clk_n or posedge mc_res)
begin
   if (mc_res)
      dmr_en <= 1'b1;
   else
      if (arb_ena | rmsel_clr)
         dmr_en <= 1'b1;
      else
         if (dmr_clr_h)
            dmr_en <= 1'b0;
end

//______________________________________________________________________________
//
endmodule
