//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
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
//  - CPU reads "mov #addr, PC" insrtuction opcode successfully
//  - then perefetching happens to read the word after this instruction
//  - bus timeout happens, it is ignored for the prefetch
//  - control is transferred to "addr"
//  - instruction fetch happens successfully at addr, one or two words
//  - abort on timeout happens, due to prefetch timeout flag was not cleared
//
   VM3_CORE_FIX_PREFETCH_TIMEOUT = 1
)
(
   input          pin_clk,          // processor clock
   input          pin_dclo,         // processor reset
   input          pin_aclo,         // power fail notificaton
   input  [3:0]   pin_virq,         // vectored interrupt request
   input          pin_halt,         // halt mode request
   input          pin_evnt,         // timer event interrupt
                                    //
   input          pin_ssync,        // wait for address ready
   input          pin_dmr,          // bus access request
   input          pin_sack,         // bus acknowlegement
   output         pin_dmgo,         // bus access grant
   input          pin_init_in,      // peripheral reset input
   output         pin_init_out,     // peripheral reset output
                                    //
   input  [15:0]  pin_ad_in,        // data bus input
   output [15:0]  pin_ad_out,       // address/data bus output
   output         pin_ad_ena,       // address/data bus enable
   output [21:16] pin_a_out,        // high address bus output
   output         pin_a_ena,        // high address bus enable
   output         pin_ins_out,      // instruction flag output
   output         pin_ins_ena,      // instruction flag enable
   output         pin_bs,           // I/O bank select
   output         pin_ctrl_ena,     // enable control outputs
                                    //
   output         pin_sync,         // address strobe
   output         pin_wtbt,         // write/byte status
   output         pin_dout,         // data output strobe
   output         pin_din,          // data input strobe
   output         pin_iako,         // interrupt vector input
   input          pin_rply,         // transaction reply
                                    //
   output         pin_umap,         // upper address mapping
   output         pin_hltm,         // halt mode
   output         pin_sel,          // access for halt mode space
   output         pin_ta,           // address translation
   output         pin_lin,          // load instruction
                                    //
   output         pin_ftrp_out,     // fatal error notification
   input          pin_ftrp_in,      // FPP trap request input
   input          pin_frdy,         // FPP present/ready
   input          pin_drdy,         // FPP data ready
   input          pin_fl,           // Float ong
   input          pin_fd,           // Float double
   input          pin_et,           // enable timeout
   input          pin_wo            // start from 173000
);

//______________________________________________________________________________
//
reg [21:16] ha;                     // high address latch
reg  [6:0]  la;                     // low address latch
reg  [15:0] ad;                     // A/D output latch
reg  [21:0] ra;                     // instruction prefetch
reg  [21:0] ca;                     // compare prefetch
reg  [21:0] a;                      // bus output address
reg  [21:6] sa;                     // address adder
reg  [21:6] sa_t;                   //
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
reg         wr_2376_t, rd_2376_t;   //
reg         rd_2376_h;              //
reg         rd_2376_l, rd_2376_lh;  //
wire        dn_2376, dn_2376_in;    //
reg         dn_2376_t0, dn_2376_t1; //
                                    //
wire        rmsel_clr;              // MMU register select clear
reg         rmsel_clr_h;            //
reg         rg_wr_l, rg_wr_lh;      // MMU reguster write
reg         rg_wr_lhl;              //
reg         rg_oe_h, rg_oe_hl;      //
reg  [5:0]  rmsel_st_t;             //
wire        rmsel_st;               // MMU registers strobe
                                    //
reg         di_oe, di_oe_t;         //
wire        di_oe_set;              //
reg         rg_oe, rg_oe_t;         //
wire        rg_wr;                  //
reg         dx_stb, dx_stb_t;       //
reg         dx_stb_l;               //
wire        dx_swp;                 //
wire        di_lat, do_lat;         //
reg         do_oe, do_oe_h;         //
reg         do_oe_clr;              //
reg         doh_lat_t;              //
reg         dox_lat_t;              //
reg         dol_lat_t;              //
wire        doh_lat;                //
wire        dox_lat;                //
wire        dol_lat;                //
                                    //
wire        psw_oe;                 // read registers to D-mux
wire        parh_oe, sr0_oe;        //
wire        sr2_oe, sr3_oe;         //
wire        par_oe, pdr_oe;         //
reg         psw_oe_t, parh_oe_t;    //
reg         sr0_oe_t, sr2_oe_t;     //
                                    //
wire        par_wl, par_wh;         // low/high byte write to PAR
wire        pdr_wl, pdr_wh;         // low/high byte write to PDR
wire        parh_en, parh_wr;       //
wire        sr0_wl, sr0_wh;         // low/high byte write to SR0
wire        sr3_wr;                 //
reg         sr3_wr_t;               //
                                    //
wire [15:0] d;                      // data bus mux
wire [15:0] dx;                     // data bus byte swapper
wire [15:0] ba;                     // buffer address output
reg         a0_reg;                 //
reg  [15:0] di_reg;                 // data input register
reg  [15:0] do_reg;                 // data output register
reg  [15:0] ba_reg;                 // address buffer register
                                    //
reg  [15:0] ireg;                   // instruction register
reg  [15:0] ireg_t;                 // instruction register output latch
reg  [15:0] ireg_p;                 // instruction register pipeline stage P
reg  [8:0]  ireg_r;                 // instruction register pipeline stage R
reg  [8:0]  ireg_m;                 // instruction register pipeline stage M
wire        ir_zf;                  // zero opcode in instruction register
                                    //
wire        ir_oe;                  // read immediate data from IR
reg         ir_oe_h, ir_doe_h;      //
reg         ir_doe, doe_clr_t;      // read data from instruction
wire        doe_clr;                //
                                    //
reg         ir_stb, ir_stb_t;       // instruction register strobe
reg         ir_stb_l, ir_stb_lh;    //
wire        ir_set0, ir_set1;       //
wire        ir_clr;                 //
reg         ir_set0_h, ir_set0_t;   //
reg         ir_tout;                // timed-out IR prefetch
                                    //
wire        pir_lat;                //
wire        mc_res, abort;          // microcode abort
reg         mc_res_l, abort_lhl;    //
reg         abort_l, abort_lh;      //
                                    //
wire        alu_rq;                 // ALU cycle start request
wire        alu_rdy, ardy_st;       // ALU ready to start
reg         alu_rdy_l, alu_rdy_lh;  //
reg         alu_plm, alu_plm_h;     // ALU PLM ready
reg  [2:1]  alu_ea;                 // ALU extended arithmetics states
reg  [1:0]  alu_st;                 // ALU cycle states
reg         alu_stb, alu_stb_l;     // ALU control and arguments strobe
reg         alu_rd, alu_rd_l;       // ALU input arguments strobe
reg         alu_rd_lh, alu_rd_lhl;  //
reg         alu_wr;                 // ALU result write code
wire        alu_wra;                // ALU result write RRA
wire        alu_run;                // start ALU operation
reg [33:18] plm_as;                 // ALU register control
                                    //
reg  [15:0] rra;                    // extended arithmetics register
reg  [15:0] rra_ix;                 // extended arithmetics input mux
wire        rra_fwr, rra_wr;        //
reg         rra_fwr_t, rra_wr_t;    //
wire        rra_shl, rra_shr;       //
wire        rra_zf;                 //
wire        rra_in0, rra_in15;      //
wire        r10_b15, r11_b15;       //
                                    //
reg  [5:0]  act_n;                  // arithmetic counter latches
reg  [5:0]  act_i;                  // counter input latches
wire [5:0]  act_b;                  // counter outputs
wire [3:0]  act_c;                  // counter carries
wire        act_lat;                //
wire        act_zf;                 //
wire        act_w15, act_w17;       //
wire        act_wr;                 //
reg         act_wr_t, act_rd_t;     //
                                    //
reg  [15:0] vmux;                   // interrupt vector mux
reg  [15:0] cmux;                   // constant generator mux
                                    //
wire        plm85n;                 // register selection type
wire        plm85p;                 // register selection type
wire        lin_en;                 // load instruction enable
                                    //
wire [21:0] pld;                    // instruction decoder matrix outputs
reg  [21:0] dc;                     // instruction decoder output register
reg  [8:6]  dci;                    // decoder/interrupt status
reg  [3:0]  dcf_m;                  // flag operation stage R
reg  [3:0]  dcf_r;                  // flag operation stage M
wire        dcf_stb;                //
wire        dc_rtx, dc_rtt;         // rti / rtt commands decoded
reg         dc_rtt_t;               //
                                    //
reg  [7:0]  na;                     // next microinstruction address
reg  [7:0]  ma;                     // microinstruction address
reg  [1:0]  ma_lat_t;               //
reg         ma_lat;                 // load microaddress from next
wire        ma_ldr;                 // load microaddress from predecoder
reg         ma_ldr_t;               //
wire        m0_set, m0_clr;         //
                                    //
reg         dc_stb;                 //
reg         dc_stb_h, dc_stb_hl;    //
reg  [2:0]  dc_stb_set;             //
wire [3:0]  dc_en;                  //
reg         dc_en2_t;               //
reg         fpp_pa;                 // address buffer ready for FPP
wire        fpp_ir;                 // data buffer ready for FPP
                                    //
reg  [22:0] m;                      // main microcode matrix inputs
wire [37:0] pl;                     // main microcode matrix outputs
reg  [37:8] plr;                    // main microcode output register
reg  [37:8] plm;                    // microcode instruction register
                                    //
wire        plr_clr;                //
reg         plr_lat, plr_lat_t;     //
reg         plr_lat_h;              //
reg         plr_rdy;                //
                                    //
reg         plm_rdy;                //
reg  [2:0]  plm_set1_t;             //
wire        plm_set1, plm_set0;     //
reg         plm_set0_l, plm_set0_lh;//
reg         plm_en, plm_en_t;       //
reg         plm_en_h;               //
reg         plm_lat, plm_lat_t;     //
reg         plm_lat_h, plm_lat_hl;  //
wire        plm_f30, plm_f30_as;    //
wire        plm_f31, plm_f31_as;    //
wire        plm_f32;                //
                                    //
wire        im_dis;                 //
wire        ri_stb, ri_stb_st;      //
reg         ri_stb_h, ri_stb_hl;    //
reg         ri_stb_t;               //
reg         hltm_ri;                //
reg  [1:0]  hltm_dc;                //
reg         hltm;                   //
wire        hltm_set, hltm_clr;     //
                                    //
reg  [10:0] pli_rq;                 // interrupt requests
wire [10:0] pli_ro;                 // interrupt matrix outputs
wire [3:0]  pli_ri;                 // interrupt matrix output index
reg  [3:0]  ri;                     //
reg         ri0_h;                  //
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
reg         ysp_req, irq_req;       //
                                    //
reg         ac_th_clr, ac_tl_clr;   //
reg         ev_rq_clr;              //
reg         fpp_rq_clr, mmu_rq_clr; //
reg         ber_rq_clr, ysp_rq_clr; //
                                    //
wire        mmu_exc, dbl_exc;       //
wire        bus_exc, ysp_exc;       //
wire        exc_abt, exc_abt_st;    //
reg         exc_abt_lh, exc_abt_lhl;//
reg         exc_abt_l, exc_abt_lhlh;//
                                    //
wire        fpp_exc, ftrpi;         // FPP trap/fatal error
reg         fpp_ena;                // FPP presence
reg         frdy_in;                // FPP ready input latch
wire        fpp_rdy;                // FPP ready
reg         fpp_rdy_l, fpp_rdy_lh;  //
reg         drdy_h, drdy_hl;        // FPP data ready
                                    //
wire        init_clr, init_set;     //
reg         init_out;               //
reg  [1:0]  dclo_in;                // DCLO input latch
wire        dclo;                   // DC low, hardware reset
reg         dclo_l;                 //
                                    //
wire        ac_dst, ac_src;         // src/dst address change with 2
reg         ac_plr, ac_plm;         // alternate constant flag
                                    //
wire [7:0]  rsel;                   // register file selector index
wire [4:0]  gr_rx;                  // register row select X
reg  [4:0]  gr_rx_t;                //
wire [4:0]  gr_ry;                  // register row select Y
reg  [4:0]  gr_ry_t;                //
wire [4:0]  gr_wr;                  // register row select write
reg  [4:0]  gr_wr_rt;               //
reg  [4:0]  gr_wr_wt;               //
                                    //
wire        dst_r6, src_r6;         // SP access flag
wire        psw_r6, sys_r6;         // SP kernel/user mode select
wire        plm_rw;                 //
                                    //
wire        gr0_rx, gr0_ry;         // read register file 0
wire        gr0_wl, gr0_wh;         // write register file 0
reg         gr0_wl_t, gr0_wh_t;     //
reg         gr0_wr_t;               //
                                    //
wire        gr1_rx, gr1_ry;         // read register file 1
wire        gr1_wl, gr1_wh;         // write register file 1
reg         gr1_wl_t, gr1_wh_t;     //
reg         gr1_wr_t;               //
                                    //
reg  [15:0] gr0[4:0];               // general register file 0
reg  [15:0] gr1[4:0];               // general register file 1
reg  [15:0] pc;                     // program counter
reg  [15:0] pc2;                    // program counter prefetch
reg  [15:0] pc2_t;                  // program counter latch
wire [15:0] pca;                    // prefetch address
                                    //
wire        psw_smod;               //
reg [15:14] psw_t;                  // temporary mode register
reg  [15:0] psw;                    // processor status word
reg  [3:0]  psw_s;                  // hidded backup register
                                    //
wire        psw_lat;                // common PSW write strobe
wire        pswh_inf, pswl_inf;     // write PSW from ALU function
wire        pswh_ind, pswl_ind;     // write PSW from data bus mux
wire        pswl_inp;               // write ALU operation flags
wire        pswl_ins;               // restore flags from backup
wire        pswl_stb;               // hidden backup register strobe
reg         pswh_inf_t;             //
reg         pswl_inf_t;             //
reg         pswl_ind_t;             //
reg         pswl_inp_t;             //
reg         pswl_ins_t;             //
                                    //
wire [4:0]  ov;                     // outputs vector matrix
reg  [3:0]  vsel;                   // vector mux control
reg  [4:0]  csel;                   // const mux control
reg         dc_tbit;                //
wire        vsel_my;                //
wire        csel_my;                //
wire        vec_stb;                //
reg         vec_stb_t;              //
wire        con_stb;                //
reg         con_stb_t;              //
                                    //
reg  [4:0]  eac;                    // ALU extended arithmetics control
wire [4:0]  plf;                    // ALU flag control matrix outputs
reg  [13:0] cia;                    // ALU flag control matrix inputs
reg         eaf4;                   // extended arithmetics flag
reg  [6:0]  ic;                     // ALU conarol matrix inpiuts
wire [17:0] ac;                     // ALU control matrix outputs
reg         alu_stw;                //
reg         ic0_t, ic1_t;           //
                                    //
wire [7:0]  m8_in;                  //
reg         alu_zfr, alu_nfr;       //
reg  [1:0]  rra15_t;                //
reg  [1:0]  alu_vfr_t;              //
reg  [2:0]  eac0_t;                 //
                                    //
reg         psw0r;                  // registered psw[0]
wire        alu_zh, alu_zl;         // ALU Z flags
wire        alu_zf;                 //
wire        c15af, cin0;            //
wire        cin15, cin7;            //
                                    //
wire        alu_shl;                // ALU result shifter controls
wire        alu_shr;                //
wire        alu_dir;                //
reg         alu_shl_t;              //
reg         alu_shr_t;              //
reg         alu_dir_t;              //
                                    //
wire        alu_b, alu_c;           //
wire        alu_d, alu_e;           //
wire        alu_f, alu_g;           //
wire        alu_ac;                 // ALU adder lsb carry
                                    //
wire [15:0] af;                     // ALU adder result
wire [15:0] c;                      // ALU adder carry
wire [15:0] s;                      // ALU adder sum
reg  [15:0] ana;                    // ALU and half-adder
reg  [15:0] ora;                    // ALU or half-adder
reg  [15:0] f;                      // ALU shifter output
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
reg         mx_rx_t, my_ry_t;       //
reg         pc_rx_t, pc_ry_t;       //
reg         dx_mx_t, dx_my_t;       //
reg         rra_mx_t, rra_my_t;     //
reg         psw_mx_t;               //
                                    //
reg  [15:0] par[15:0];              // MMU page address registers
reg  [14:1] pdr[15:0];              // MMU page descriptor registers
reg  [15:0] parh;                   // halt mode page address
wire [15:0] par_d;                  //
wire [15:0] pdr_d;                  //
wire [15:0] mmu_a;                  //
wire [14:1] mmu_d;                  //
reg  [15:0] pa;                     //
reg  [14:1] pd;                     //
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
reg  [3:0]  parh_sel_t;             //
wire [15:0] padr_sel;               // page address/descriptor selectors
reg  [15:0] padr_sel_t;             //
wire [3:0]  mm_sa;                  //
reg  [3:0]  mm_sa_t;                //
wire        mm_sah;                 //
wire        mm_stb;                 //
reg         mm_stbs, mm_stbs_t;     //
wire        mm_stb_set;             //
reg         mm_stb_clr;             //
reg         mm_stb_clr_l;           //
                                    //
wire        sr0_er;                 //
reg         sr0_er_h, sr0_er_hl;    //
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
reg         sa_sxa_h, sa_sxa_hl;    //
reg         sa_pfa, sa_pfa_t;       //
reg         sa_pfa_h, sa_pfa_hl;    //
reg         ra_s22_t, ra_s16_t;     //
reg         sa_s22_t;               //
reg         ra_s22_h;               //
reg         ra_s22_hl, ra_s22_hlh;  //
reg         sa_s22_h, sa_s22_hl;    //
                                    //
wire        bs_a18, bs_a22;         // I/O banck select
reg         adr_eq;                 // prefetched address match
wire        io_lat0, io_lat1;       //
wire        io_lat2, io_res2;       //
reg         io_lat2_t0;             //
reg         io_lat2_h, io_lat2_hl;  //
reg         iodc_rdy, iodc_rdy_l;   // I/O decoder ready
                                    //
reg         at_stb, at_stb_t;       //
reg         ba_pca, ba_pca_t;       //
reg         ba_pca_h, ba_pca_hl;    //
reg         ba_rdy_l, ba_rdy_lh;    //
reg         ba_pca_clr_t;           //
wire        ba_pca_clr;             //
                                    //
wire        ba_rdy, ba_ins;         //
wire        ba_lat, ba_lat0;        //
wire        ba_lat1, ba_lat2;       //
wire        ba_lat3, ba_lat4;       //
reg         ba_lat0_t, ba_lat2_lh;  //
reg         ba_lat2_l, ba_lat2_lhl; //
wire        ba_fsel, ba_dir;        //
reg         ba_fsel_t;              //
                                    //
wire        wf_set, wrf_set;        //
wire        ws_set, ws_rst;         //
wire        opwf_clr;               //
reg         opwf_clr_l;             //
reg         op0_wf, op1_wf;         //
reg         op2_wf, op3_wf;         //
reg         op3_wf_l, op3_wf_lh;    //
reg         ws_rst_t0, ws_rst_t1;   //
                                    //
reg  [1:0]  rg_rmw_t;               //
wire        rg_rmw;                 //
reg  [1:0]  di_rmw_t;               //
reg         di_rmw_h, di_rmw_tl;    //
wire        di_rmw;                 //
                                    //
reg         alu_drdy;               //
wire        s0_rdy;                 //
reg         rd_oe_l, io_s0_rd_h;    //
reg         io_s0_as, io_s0_rd;     //
reg         io_s3_wr;               //
reg         io_s3_h, io_s3_hl;      //
reg         io_s4_h, io_s4_hl;      //
wire        out_rs, s3_out;         //
                                    //
wire [4:0]  io_s;                   //
wire [3:0]  iop;                    // I/O operation code
reg  [4:0]  iop_m;                  // IO opcode register, memory translation
reg  [3:0]  iop_t;                  // IO opcode register, bus transaction
wire [5:0]  io_dc;                  // IO transaction opcode
wire [3:0]  mt_op;                  // memory translation opcode
wire        dwbl, dwbh;             // byte selection strobes
                                    //
reg         hmod;                   // halt mode flag
reg         hm_lat, hm_lat_h;       //
reg         hm_lat_clr_t;           //
wire        hm_lat_set, hm_lat_clr; //
                                    //
wire        mrq_pl;                 // page limit error request
reg         mrq_pl_t0, mrq_pl_t1;   //
wire        mrq_ro, mrq_nr;         // readonly/ not resident
wire        mrqt_er;                //
reg         mrqt_nr;                // registered traslate results
reg         mrqt_ro;                //
reg         mrqt_pl;                //
reg [15:13] mt_ba;                  //
wire  [6:5] mt_mod;                 //
wire        ir_mmu_err;             //
reg         ir_mmu_err_h;           //
reg         ir_mmu_err_hl;          //
                                    //
wire        pf_init;                //
wire [2:0]  pf_p;                   // positive register output
wire [2:0]  pf_n;                   // negative register output
reg  [2:0]  pf_t;                   //
reg         pf_ena;                 //
wire        pf_ena_clr;             //
wire        pf_00, pf_01;           //
reg         pf_00_l, pf_01_l;       //
reg         pf_00m, pf_00m_t;       // latched on plm
reg         pf_00a, pf_00r;         // latcged on addr, plr
reg         pf_ba0, pf_pa_l;        //
reg         pf_ba0_h, pf_ba0_hl;    //
wire        pf_pa, pf_inv;          //
wire        pf_doe;                 //
wire        pf_tout, pf_tout_st;    //
reg         pf_doe_l, pf_doe_lh;    //
reg         pf_tout_l, pf_tout_lh;  //
wire        pf_ins;                 //
reg         pf_rdy;                 //
reg         pf_end0, pf_end0_h;     //
reg         pf_end1, dc_en2_h;      //
                                    //
wire        pc_wr0, pc_wr1, pc_wr2; //
wire        pc2_wrc, pc2_wrq;       //
reg         pc2_wrc_l, pc2_wrc_lh;  //
reg         pc_wr0_rt, pc_wr0_wt;   //
reg         pc2_wrr, pc2_wrm;       //
reg         pc2_wrf;                //
reg         pc3_rdy, pc3_rdy_h;     //
reg         pc3_rdy_set;            //
                                    //
wire        sel;                    // halt mode bus access
reg         sel_sa_t, sel_ra_t;     //
reg         dmr_in, dmr;            //
reg         sack_in, sack;          //
reg         irply_l, irply_lh;      //
reg         rply_in, rply_in_l;     //
reg         rply, rply_h;           //
wire        irply_clr;              //
reg         ssync_in, ssync;        //
reg         dmgo;                   //
wire        ct_oe;                  //
wire        bus_free;               //
reg         ba_req, ba_req_l;       // address request
                                    //
reg         qt_tmr, qt_tmr_l;       // Q-bus timer
reg  [3:0]  qt_div_h;               //
reg  [3:0]  qt_div_l;               //
reg  [4:0]  qt;                     //
reg  [4:1]  qt_h;                   //
wire        qt_ena, qt_stb, qt_out; //
reg         qt_stb_h, qt_stb_hl;    //
reg         qt_ena_h, qt_ena_hl;    //
reg         qt_ena_hlh;             //
                                    // for debug purposes only
wire        oat_dbg, mmu_dbg;       // suppress Q-bus glitches
wire        oat, qerr, qtout;       //
reg         oat_l, oat_lh;          //
reg         qerr_l, qerr_lh;        //
reg         qtout_l, qtout_lh;      //
                                    //
reg         pa_oe, pa_oe_t;         //
reg         pa_oe_l, pa_oe_lh;      //
reg         pa_oe_clr;              //
wire        pa_oe_set;              //
reg  [2:0]  ad_oe_t;                //
wire        ad_a_nd;                //
wire        ad_oe;                  //
reg         bd_oe, bd_oe_t;         //
                                    //
wire        wtbt;                   //
reg         irply;                  //
reg         irply_en, irply_en_t;   //
reg         sync, sync_t;           //
reg         sync_clr;               //
reg         dout, dout_l, dout_lh;  //
reg         din, din_l, din_lh;     //
reg  [2:0]  din_set_t;              //
wire        din_set0, din_set1;     //
reg  [1:0]  dout_set_t;             //
reg         dout_set, dout_set_l;   //
reg         dout_dn;                //
wire        din_end, dout_end;      //
wire        dio_clr;                // din/dout outputs reset
reg         dio_clr_l;              //
reg         dvc_stb;                //
reg         iako;                   //
reg         iako_en, iako_ent;      //
reg         iako_en_l, iako_en_lh;  //
wire        iako_st, iako_set;      //
                                    //
reg         a21_ins;                //
reg         a21_ins_l, a21_ins_lh;  //
reg         ins_req, ins_req_l;     //
wire        ins_set;                //
wire        arb_ena;                //
reg         arb_ena_t;              //
reg         arb_ena_h, arb_ena_hl;  //
wire        dmr_en, dmr_clr;        //
reg         dmr_clr_h, dmr_clr_hl;  //
reg         dmr_en_t;               //
                                    //
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
assign pin_ad_out[15:0] = ad[15:0];
always @(*) if (~ad_oe) ad[15:0] <= ad_a_nd ? a[15:0] : d[15:0];

assign pin_bs = ct_oe & ~sel & (bs_a18 | bs_a22);
assign pin_sel = ct_oe & sel;
assign pin_a_ena = pa_oe;
assign pin_a_out[21:16] = ha[21:16];
assign pin_ins_ena = din;
assign pin_ins_out = a21_ins;

assign pin_init_out = init_out | dclo;
assign pin_lin = dc_stb & lin_en & ~ri[0];
assign pin_hltm = hltm;
assign pin_umap = sr3_um;
assign pin_ta = pa_oe & io_dc[1];
assign pin_ftrp_out = abort;

assign oat_dbg = ~(oat | oat_l);
assign mmu_dbg = ~hm_men | ~pa_oe_l;
assign pin_ctrl_ena = ct_oe;
assign pin_dmgo = dmgo;
assign pin_iako = iako;
assign pin_sync = sync & oat_dbg;
assign pin_wtbt = wtbt & oat_dbg;
assign pin_dout = dout & oat_dbg & mmu_dbg;
assign pin_din = din & oat_dbg & mmu_dbg;

always @(*)
begin
   if (qt_tmr_l)
   begin
      dmr_in <= 1'b0;
      dmr <= 1'b0;
   end
   else
   begin
      if (pin_clk) dmr_in <= pin_dmr;
      if (~pin_clk) dmr <= dmr_in;
   end

   if (~pin_clk) qt_tmr_l <= qt_tmr;
   if (~pin_clk) irply_l <= irply;
   if (pin_clk) irply_lh <= irply_l;

   if (pin_clk) sack_in <= pin_sack;
   if (~pin_clk) sack <= sack_in;

   if (pin_clk) ssync_in <= pin_ssync;
   if (~pin_clk) ssync <= ssync_in;

   if (pin_clk) rply_in <= pin_rply;
   if (~pin_clk) rply_in_l <= rply_in;
   if (~pin_clk) rply <= rply_in | (irply & ~irply_lh);
   if (pin_clk) rply_h <= rply;
end

always @(*)
begin
   if (~pa_oe)
      ha[21:16] <= {bs_a18 ? 4'b1111 : a[21:18], a[17:16]};
   if (pa_oe)
      la[6:0] <= a[6:0];
end

always @(*)
begin
   if (di_lat)
      di_reg[15:0] <= pin_ad_in[15:0];

   if (doh_lat)
      do_reg[15:8] <= f[15:8];
   else
      if (dox_lat)
         do_reg[15:8] <= f[7:0];

   if (dol_lat)
      do_reg[7:0] <= f[7:0];
end

assign di_lat = ~di_oe;
assign do_lat = ~plm_as[29] & ~plm_as[30] & plm_as[31] & alu_stb_l;

assign doh_lat = do_lat & doh_lat_t;
assign dox_lat = do_lat & dox_lat_t;
assign dol_lat = do_lat & dol_lat_t;
assign dx_swp = io_s0_rd | (~ir_oe & a0_reg & ~mt_op[2] & ~io_s0_as);

always @(*)
begin
   if (~do_lat)
   begin
      doh_lat_t <=   mt_op[2] | io_s0_as;
      dox_lat_t <= ~(mt_op[2] | io_s0_as) & a0_reg;
      dol_lat_t <=  (mt_op[2] | io_s0_as) | ~a0_reg;
   end
end

always @(*)
begin
   if (mc_res | do_oe_clr)
         do_oe <= 1'b0;
   else
      if (do_lat)
         do_oe <= 1'b1;

   if (pin_clk) do_oe_h <= do_oe;
   if (~pin_clk) do_oe_clr <= (dx_stb & do_oe_h) | dout_dn;
end

//______________________________________________________________________________
//
assign s23xx = (ha[21:16] == 6'o77) & (ad[15:6] == 10'o1723)  & ~ad[4];
assign s76xx = (ha[21:16] == 6'o77) & (ad[15:6] == 10'o1776)  & ~ad[4];
assign s7777 = (ha[21:16] == 6'o77) & (ad[15:3] == 13'o17777) &  ad[2] & ad[1];
assign s757x = (ha[21:16] == 6'o77) & (ad[15:3] == 13'o17757) & (ad[2] | ad[1]);
assign s251x = (ha[21:16] == 6'o77) & (ad[15:3] == 13'o17251) &  ad[1];

always @(*)
begin
   if (mc_res | rmsel_clr_h)
      rmsel <= 1'b0;
   else
      if (pa_oe)
         rmsel <= s23xx | s76xx | s7777 | s757x | s251x;

   if (dn_2376)
      r2376 <= 1'b0;
   else
      if (pa_oe)
         r2376 <= s23xx | s76xx;

   if (pa_oe)
   begin
      r251x <= s251x;
      r757x <= s757x;
      r7777 <= s7777;
   end

   if (~rg_wr) wr_2376_t <= r2376;
   if (~rg_oe) rd_2376_t <= r2376;
   if (pin_clk) rd_2376_h <= rd_2376;
   if (~pin_clk) rd_2376_l <= rd_2376;
   if (pin_clk) rd_2376_lh <= rd_2376_l;
   if (~pin_clk) dn_2376_t0 <= dn_2376_in;
   if (pin_clk) dn_2376_t1 <= dn_2376_t0;
   if (~pin_clk) dx_stb_t <= (dx_mx | dx_my) & ~dx_stb;
   if (pin_clk) dx_stb <= dx_stb_t;
   if (~pin_clk) dx_stb_l <= dx_stb;
end

assign dn_2376_in = ~wr_2376 & (~rd_2376_h | io_dc[5]);
assign dn_2376 = mc_res | (dn_2376_in & ~dn_2376_t1);
assign wr_2376 = wr_2376_t & rg_wr;
assign rd_2376 = rd_2376_t & rg_oe;

always @(*)
begin
   if (pin_clk) rmsel_clr_h <= rmsel_clr;
   if (~pin_clk) rg_wr_l <= rg_wr;
   if (pin_clk) rg_wr_lh <= rg_wr_l;
   if (~pin_clk) rg_wr_lhl <= rg_wr_lh;
   if (pin_clk) rg_oe_h <= rg_oe;
   if (~pin_clk) rg_oe_hl <= rg_oe_h;

   if (pin_clk)
   begin
      rmsel_st_t[1] <= rmsel_st_t[0];
      rmsel_st_t[3] <= rmsel_st_t[2];
      rmsel_st_t[5] <= rmsel_st_t[4];
   end
   else
   begin
      rmsel_st_t[0] <= rmsel;
      rmsel_st_t[2] <= rmsel_st_t[1];
      rmsel_st_t[4] <= rmsel_st_t[3];
   end
end

assign rmsel_clr = rg_wr_lhl | (~rg_oe & rg_oe_hl & ~io_dc[5]);
assign rmsel_st = rmsel & rmsel_st_t[5];
assign rg_wr = ~rg_wr_lhl & ~rg_wr_lh & rmsel_st
             & alu_drdy & (~io_dc[1] | rg_rmw);
assign rg_rmw = rg_rmw_t[1];
assign di_rmw = di_rmw_tl & ~rply;

always @(*)
begin
   if (mc_res | dx_stb_l)
      rg_oe <= 1'b0;
   else
      if (pin_clk & rg_oe_t)
         rg_oe <= 1'b1;

   if (~pin_clk)
      rg_oe_t <= ~rg_oe & ~io_dc[2] & pa_oe_l & rmsel;

   if (mc_res)
      rg_rmw_t[0] <= 1'b0;
   else
      if (rg_oe)
         rg_rmw_t[0] <= io_dc[5];
   if (~rg_oe)
      rg_rmw_t[1] <= rg_rmw_t[0];
end

always @(*)
begin
   if (mc_res | dx_stb_l)
      di_oe <= 1'b0;
   else
      if (pin_clk & di_oe_t)
         di_oe <= 1'b1;

   if (~pin_clk)
      di_oe_t <= ~di_oe & rply & di_oe_set & din_l;

   if (pin_clk)
      di_rmw_h <= di_rmw;

   if (~pin_clk)
      di_rmw_tl <= di_rmw_t[1];

   if (di_rmw_h | mc_res)
      di_rmw_t[1] <= 1'b0;
   else
      if (di_oe)
         di_rmw_t[1] <= di_rmw_t[0];

   if (di_rmw_h)
      di_rmw_t[0] <= 1'b0;
   else
      if (~di_oe)
         di_rmw_t[0] <= io_dc[5];
end

assign di_oe_set = ~a21_ins_l & (~io_dc[2] | io_s[4]);
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
assign d = (do_oe  ? do_reg : 16'o000000)    // ALU output
         | (di_oe  ? di_reg : 16'o000000)    // Data input
         | (ir_oe  ? ireg_t : 16'o000000)    // Instruction
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

always @(*)
begin
   if (~rg_oe)
   begin
      psw_oe_t  <= r7777;
      sr0_oe_t  <= r757x & ~la[2] & la[1];
      sr2_oe_t  <= r757x &  la[2] & la[1];
      parh_oe_t <= r251x & ~la[2];
   end
end

assign parh_oe = parh_oe_t & rg_oe;
assign psw_oe = psw_oe_t & rg_oe;
assign sr0_oe = sr0_oe_t & rg_oe;
assign sr2_oe = sr2_oe_t & rg_oe;
assign sr3_oe = rg_oe & r251x & la[2];
assign par_oe = rd_2376 &  la[5] | parh_oe;
assign pdr_oe = rd_2376 & ~la[5];

//______________________________________________________________________________
//
// Reset circuits
//
always @(*)
begin
   if (~pin_clk) dclo_in[0] <= pin_dclo;
   if ( pin_clk) dclo_in[1] <= dclo_in[0];
   if (~pin_clk) dclo_l <= dclo;
end

assign dclo = dclo_in[1];

always @(*)
begin
   if (dclo | init_clr)
      init_out <= 1'b0;
   else
      if (init_set)
         init_out <= 1'b1;
end

assign init_clr = alu_rd & (rsel[7:4] == 4'b1011);
assign init_set = alu_rd & (rsel[7:4] == 4'b1010)
                & ~mt_mod[6] & ~plm[22] & plm[24];

assign mc_res = dclo | abort;
always @(*)
begin
   if (~pin_clk) mc_res_l <= mc_res;
end

//______________________________________________________________________________
//
// FPP ready and presence
//
always @(*)
begin
   if (dclo) fpp_ena <= pin_frdy;
   if (pin_clk) frdy_in <= pin_frdy;
   if (pin_clk) drdy_h <= pin_drdy;
   if (~pin_clk) drdy_hl <= drdy_h;
   if (~pin_clk) fpp_rdy_l <= fpp_rdy;
   if (pin_clk) fpp_rdy_lh <= fpp_rdy_l;
end

assign fpp_rdy = frdy_in | ~fpp_ena;
//______________________________________________________________________________
//
// Instruction register pipeline
//
always @(*)
begin
   if (ir_stb) ireg[15:0] <= pin_ad_in[15:0];
   if (pir_lat) ireg_p[15:0] <= ireg[15:0];
   if (plr_lat) ireg_r[8:0] <= ireg_p[8:0];
   if (plm_lat) ireg_m[8:0] <= ireg_r[8:0];
   if (~ir_oe) ireg_t[15:0] <= ireg[15:0];
end

assign pir_lat = ~plr_lat & dc_stb;
assign ir_oe = ~ir_stb_l & ir_doe & s0_rdy;
assign ir_zf = ~ir_stb & (ireg[15:0] == 16'o000000);
assign s0_rdy = io_s0_rd | ~do_oe;

assign ir_set0 = ~ir_stb_l & ~ir_set0_t;
assign ir_set1 = ~dc_stb & (iako_st | dc_stb_hl | ir_set0_h);
assign ir_clr = iako_en | a21_ins_l;
assign doe_clr = doe_clr_t & pin_clk;

assign irply_clr = VM3_CORE_FIX_PREFETCH_TIMEOUT ?
                   pin_clk & ir_stb_t & rply_in_l : 1'b0;
always @(*)
begin
   if (mc_res | doe_clr | ir_set1)
      ir_stb <=1'b1;
   else
      if (pin_clk & ir_stb_t)
         ir_stb <=1'b0;

   if (~pin_clk)
      ir_stb_t <= ir_stb & ir_stb_l & ~mc_res & rply & ir_clr & din_l;

   if (mc_res | doe_clr)
      ir_doe <=1'b0;
   else
      if (plm_lat & pf_01_l)
         ir_doe <=1'b1;

   if (~pin_clk)
      doe_clr_t <= ir_oe & dx_stb;

   if (pf_init)
      ir_set0_t <= 1'b0;
   else
      if (mc_res | pf_pa_l)
         ir_set0_t <= 1'b1;

   if (pin_clk) ir_set0_h <= ir_set0;
   if (pin_clk) ir_oe_h <= ir_oe;
   if (pin_clk) ir_doe_h <= ir_doe;
   if (~pin_clk) ir_stb_l <= ir_stb;
   if (pin_clk) ir_stb_lh <= ir_stb_l;
end

always @(*)
begin

end

//______________________________________________________________________________
//
// Instruction opcode predecoder
//
vm3_pld pld_mx(.ins(lin_en), .fpp(fpp_ena), .ir(ireg), .dc(pld[21:0]));

always @(*)
begin
   if (dc_stb)
   begin
      dc[21:0] <= pld[21:0];
      dci[8:6] <= ri[0] ? 3'b000 : {~pld[8], ~pld[7], pld[6]};
   end
end

always @(*)
begin
   if (dcf_stb)
      dcf_r[3:0] <= dc[21:18];
   if (plm_lat)
      dcf_m[3:0] <= dcf_r[3:0];
end

assign dc_rtx = dc[6] & ~dc[7] & dc[8] & dc[21];            // rtt/rti
assign dc_rtt = dc[6] & ~dc[7] & dc[8] & dc[21] & ~dc[20];  // rtt

assign dcf_stb =  plr_lat & ~dc_stb;
assign lin_en  =  plr[16] | ~plr[8];
assign plm85n  = ~plm[16] |  plm[8];
assign plm85p  = ~plm[16] | ~plm[8];

always @(*)
begin
   if (mc_res | dc_stb_hl)
      dc_stb <= 1'b0;
   if (~pin_clk & |dc_stb_set[2:0])
      dc_stb <= 1'b1;

   if (pin_clk)
   begin
      dc_stb_set[0] <= ~dc_stb & ~pf_n[0] & ~pf_n[1]
                     & fpp_rdy & fpp_ir & &dc_en[3:0];
      dc_stb_set[1] <= ~dc_stb & fpp_rdy & fpp_ir & fpp_pa;
      dc_stb_set[2] <= ~dc_stb & plm_lat & ~lin_en;
   end

   if (pin_clk) dc_stb_h <= dc_stb;
   if (~pin_clk) dc_stb_hl <= dc_stb_h;
end

assign dc_en[0] = ~halt_op & ~hltm_set;
assign dc_en[2] = dc_en2_t;
assign dc_en[1] = pf_rdy | (ba_rdy & hm_lat_h);
assign dc_en[3] = (~op0_wf & ~op1_wf) | opwf_clr;

always @(*)
begin
   if (mc_res | pf_inv)
      dc_en2_t <= 1'b0;
   else
      if (pf_end0_h)
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

always @(*)
begin
   if (~plm_en)
   begin
      m[7:0]  <= ma[7:0];
      m[8]    <= (plm[14:12] == 3'b000) & ~m8_in[0]
               | (plm[14:12] == 3'b001) & ~m8_in[1]
               | (plm[14:12] == 3'b010) & ~m8_in[2]
               | (plm[14:12] == 3'b011) & ~m8_in[3]
               | (plm[14:12] == 3'b100) & ~m8_in[4]
               | (plm[14:12] == 3'b101) & ~m8_in[5]
               | (plm[14:12] == 3'b110) & ~m8_in[6]   // take branch
               | (plm[14:12] == 3'b111) & ~m8_in[7];  // halt mode
      m[22:9] <= {dc[21:20], dc[17:13], dc[3], dc[11:9], dci[8:6]};
   end
end

always @(*)
begin
   if (m0_clr)
      ma[0] <= 1'b0;
   else
      if (m0_set)
         ma[0] <= 1'b1;
      else
         if (ma_lat)
            ma[0] <= na[0];
         else
            if (ma_ldr)
               ma[0] <= pld[0];

   if (mc_res)
      ma[7:1] <= {2'b00, ma[5:3], 2'b11};
   else
      if (ma_lat)
         ma[7:1] <= na[7:1];
      else
         if (ma_ldr)
            ma[7:1] <= {2'b11, pld[5:1]};
end

always @(*)
begin
   if (mc_res | ma_ldr)
      ma_lat_t[0] <= 1'b0;
   else
      if (plm_en)
         ma_lat_t[0] <= 1'b1;

   if (mc_res | ma_ldr)
      ma_lat_t[1] <= 1'b0;
   else
      if (plm_en)
         ma_lat_t[1] <= ma_lat_t[0];

   if (plm_en | ma_ldr | mc_res)
      ma_lat <= 1'b0;
   else
      if (ma_lat_t[1])
         ma_lat <= 1'b1;
end

assign m0_clr = ~dclo_l & mc_res & (mmu_req | ~vec_bus);
assign m0_set =  dclo_l | (mc_res & ~(mmu_req | ~vec_bus));
assign ma_ldr = ma_ldr_t & dc_stb;
always @(*) if (~dc_stb) ma_ldr_t <= lin_en;

always @(*)
begin
   if (plr_lat) na[7:0] <= pl[7:0];
   if (plr_lat) plr[37:8] <= pl[37:8];
   if (plm_lat) plm[25:8] <= plr[25:8];
   if (plm_lat) plm[32:27] <= plr[32:27];
   if (plm_lat) plm[37:34] <= plr[37:34];
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

assign plr_clr = ~pin_clk & plr_lat_h;
always @(*)
begin
   if (mc_res | plr_clr)
      plr_lat <= 1'b0;
   else
      if (~pin_clk & plr_lat_t)
         plr_lat <= 1'b1;

   if (pin_clk)
      plr_lat_t = ~plr_lat & ~mc_res & ~plr_clr & plm_en_h;

   if (mc_res | pin_clk & plm_lat)
      plr_rdy <= 1'b0;
   else
      if (pin_clk & plr_lat)
         plr_rdy <= 1'b1;

   if (pin_clk) plr_lat_h <= plr_lat;
end

assign plm_set0 = pf_rdy & (pf_n[0] | ~pf_ena) & (pf_p[1] | ~pf_ena);
assign plm_set1 = ~plm_set1_t[0] | plm_set1_t[2];
always @(*)
begin
   if (pin_clk)  plm_set1_t[0] <= ~plm[12] & plm[13] & plm[14];
   if (~pin_clk) plm_set1_t[1] <= plm_set1_t[0];
   if (pin_clk)  plm_set1_t[2] <= plm_set1_t[1];
   if (~pin_clk) plm_set0_l <= plm_set0;
   if (pin_clk) plm_set0_lh <= plm_set0_l;
end

always @(*)
begin
   if (mc_res | plm_lat_hl)
      plm_lat <= 1'b0;
   else
      if (~pin_clk & plm_lat_t)
         plm_lat <= 1'b1;

   if (pin_clk)
      plm_lat_t = ~plm_lat & plr_rdy & alu_rdy;

   if (pin_clk) plm_lat_h <= plm_lat;
   if (~pin_clk) plm_lat_hl <= plm_lat_h;
end

always @(*)
begin
   if (mc_res | plr_clr)
      plm_en <= 1'b0;
   else
      if (~pin_clk & plm_en_t)
         plm_en <= 1'b1;

   if (pin_clk)
      plm_en_t = ~plm_en & plm_set0 & plm_set1 & ardy_st
               & ~plr_rdy & ~mc_res & (lin_en | ~plm_lat_h);

   if (pin_clk) plm_en_h <= plm_en;
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
assign m8_in[4] = ( dc[20] |  dc[21] | pin_fl)
                & (~dc[20] | ~dc[21] | pin_fd)
                & ( dc[20] | ~dc[21] | ~pin_fd);
assign m8_in[5] = pin_wo ;
assign m8_in[7] = hmod;

always @(*)
begin
   if (alu_wr)
   begin
      alu_zfr <= alu_zf;
      alu_nfr <= ~cia[2];
   end

   if (rra_shl) rra15_t[0] <= rra[15];
   if (rra_wr) rra15_t[1] <= rra15_t[0];

   if (alu_wra & ~eac[0]) alu_vfr_t[0] <= ~cia[6];
   if (alu_wra & ~eac0_t[2]) alu_vfr_t[1] <= ~cia[6];

   if (alu_stb) eac0_t[0] <= eac[0];
   if (~alu_stb) eac0_t[1] <= eac0_t[0];
   if (alu_stb) eac0_t[2] <= eac0_t[1];
end

//______________________________________________________________________________
//
// ALU state machine
//
assign alu_rdy = ~alu_ea[1] & ~alu_plm_h;
assign alu_rq = ~alu_st[0] & alu_plm & alu_run;
assign alu_wra = alu_wr & ~pin_clk;
assign alu_run = iodc_rdy_l & plm_rdy & ~io_s[2] & s0_rdy
               & (rd_oe_l | ~plm[11] | plm[15])
               & (rd_oe_l | ~plm[22] | plm[24]);

always @(negedge pin_clk)
begin
   alu_st[0] <= alu_rq & ~alu_st[0];
   alu_st[1] <= alu_st[0] & ~mc_res;

   alu_ea[2] <= ~eac[4] & alu_st[1];
end

always @(*)
begin
   if (mc_res)
      alu_ea[1] <= 1'b0;
   else
      if (alu_stb)
         alu_ea[1] <= ~eac[4];

   if (alu_stb) plm_as[33:18] <= plm[33:18];

   if (mc_res | alu_st[1])
         alu_plm <= 1'b0;
   else
      if (plm_lat | alu_ea[2])
         alu_plm <= 1'b1;
   if (pin_clk) alu_plm_h <= alu_plm;

   if (pin_clk & alu_rq)
      alu_rd <= 1'b1;
   else
      if (alu_st[1] | mc_res_l)
         alu_rd <= 1'b0;

   if (pin_clk)
      alu_wr <= alu_st[1];

   if (alu_wr | mc_res_l)
      alu_stb <= 1'b0;
   else
      if (alu_st[0] & ~mc_res & pin_clk & ~alu_stb)
         alu_stb <= 1'b1;
end

always @(*)
begin
   if (~pin_clk) alu_stb_l <= alu_stb;

   if (~pin_clk) alu_rd_l <= alu_rd;
   if (pin_clk) alu_rd_lh <= alu_rd_l;
   if (~pin_clk) alu_rd_lhl <= alu_rd_lh;

   if (~pin_clk) alu_rdy_l <= alu_rdy;
   if (pin_clk) alu_rdy_lh <= alu_rdy_l;
end

assign ardy_st = plm[14] | (alu_rdy & alu_rdy_lh);
always @(*)
begin
   if (pin_clk) io_s0_rd_h <= io_s0_rd;
   if (~pin_clk) dout_dn <= dout_end | rg_wr_lh;
   if (~pin_clk)
      rd_oe_l <= ir_oe_h | rg_oe | di_oe | io_s0_rd_h;

   if (pin_clk) io_s3_h <= io_s[3];
   if (~pin_clk) io_s3_hl <= io_s3_h;
   if (pin_clk) io_s4_h <= io_s[4];
   if (~pin_clk) io_s4_hl <= io_s4_h;

   if (mc_res | dout_dn)
      io_s3_wr <= 1'b0;
   else
      if (alu_rd_l & io_s3_hl)
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

always @(*) if (~alu_rd) csel[4:0] <= {plm[13] & plm[37] & plm[36], plm[37:34]};
always @(*) if (~alu_rd) vsel[3:0] <= {~ov[2], ov[1], ov[0], ~ov[3]};

assign vsel_my = alu_rd & vec_stb;
assign csel_my = alu_rd & con_stb;
//
// Update register by 2 selector (alternate constant)
//
assign ac_dst = (ireg_m[2] & ireg_m[1]) | ac_plm;
assign ac_src = (ireg_m[8] & ireg_m[7]) | ac_plm;

always @(*) if (plm_lat) ac_plm <= ac_plr;
always @(*) if (plr_lat & ~dc_stb) ac_plr <= ~dc[13];

//______________________________________________________________________________
//
// Interrupts and exceptions
//
vm3_plv plv_mx(.ib({psw[15], dc_tbit, ri[3:0],
                    ~dc[21:20], ~dc[8:6], pin_wo}), .ov(ov));
always @(*)
begin
   if (dclo)
      dc_tbit <= 1'b0;
   else
      if (dc_stb)
         dc_tbit <= pli_rq[4];

   if (~dc_stb)
      dc_rtt_t <= dc_rtt;
end

always @(*)
begin
   if (~irq_lat)
   begin
      aclo <= pin_aclo;
      halt_in <= pin_halt;
   end

   if (pin_clk) evnt_in <= pin_evnt;
   if (~pin_clk) evnt <= evnt_in;
end

assign halt_req = halt_in & ~hltm;
assign halt_op = ir_zf & ~ir_stb & lin_en & ~psw[15] & ~ri0_h;
assign im_dis = dc_rtt_t & hltm_ri;

assign ri_stb = ri_stb_t ? plr_lat : dc_stb;
assign ri_stb_st = ri_stb_hl & ~ri_stb;

always @(*)
begin
   if (ri_stb) ri <= pli_ri;
   if (pin_clk) ri0_h <= ri[0];

   if (pin_clk) ri_stb_h <= ri_stb;
   if (~pin_clk) ri_stb_hl <= ri_stb_h;

   if (dclo | ri_stb_st)
      ri_stb_t <= 1'b0;
   else
      if (exc_abt_st)
         ri_stb_t <= 1'b1;

   if (~pin_clk) exc_abt_l <= exc_abt;
   if (pin_clk) exc_abt_lh <= exc_abt_l;
   if (~pin_clk) exc_abt_lhl <= exc_abt_lh;
   if (pin_clk) exc_abt_lhlh <= exc_abt_lhl;
end

assign hltm_set = halt_op | pli_ro[8] | pli_ro[0];
assign hltm_clr = pf_00 & ~dc_stb & hltm_dc[1] & dc_rtx;

always @(*)
begin
   if (dclo)
      hltm_ri <= 1'b0;
   else
      if (ri_stb_st)
         hltm_ri <= hltm;

   if (dclo)
      hltm_dc[1:0] <= 2'b00;
   else
   begin
      if (~dc_stb) hltm_dc[0] <= hltm;
      if (dc_stb) hltm_dc[1] <= hltm_dc[0];
   end

   if (hltm_clr | dclo)
      hltm <= 1'b0;
   else
      if (hltm_set & ri_stb)
         hltm <= 1'b1;
end

vm3_pli pli_mx(.rq({im_dis, pli_rq}), .ro(pli_ro), .ri(pli_ri));

always @(*)
begin
   pli_rq[4] <= psw[4] & ~dc_rtt_t;
   if (irq_lat)
   begin
      pli_rq[0] <= dbl_req;
      pli_rq[1] <= mmu_req;
      pli_rq[2] <= ber_req;
      pli_rq[3] <= fpp_req;
      pli_rq[5] <= ysp_req;
      pli_rq[6] <= aclo_ok;
      pli_rq[7] <= aclo_bad;
      pli_rq[8] <= halt_req;
      pli_rq[9] <= evnt_req;
      pli_rq[10] <= irq_req;
   end
end

always @(*)
begin
   if (~irq_lat)
      irq_req <= ~aclo & ((psw[7:5] < 3'o7) & pin_virq[3]
                        | (psw[7:5] < 3'o6) & pin_virq[2]
                        | (psw[7:5] < 3'o5) & pin_virq[1]
                        | (psw[7:5] < 3'o4) & pin_virq[0]);
   if (dclo | pin_init_in)
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

always @(*)
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
assign exc_abt = dbl_req | mmu_req | fpp_req | ber_req;
assign exc_abt_st = exc_abt_l & ~exc_abt_lhl;
assign aclo_ok = ac_th & ~aclo & ~hltm;
assign aclo_bad = ac_tl & aclo & ~hltm;
assign evnt_req = (psw[7:5] != 3'o7) & ~evnt & evnt_th;
assign abort = exc_abt & ~exc_abt_lhlh;
assign ftrpi = pin_ftrp_in | abort;

always @(*)
begin
   if (~pin_clk) abort_l <= abort;
   if (pin_clk) abort_lh <= abort_l;
   if (~pin_clk) abort_lhl <= abort_lh;
end

always @(*)
begin
   if (mc_res | pf_00)
      ysp_en <= 1'b1;
   else
      if (ysp_rq_clr & dc_stb_h)
         ysp_en <= 1'b0;

   if (dclo | dc_stb & pf_00_l)
      vec_bus <= 1'b0;
   else
      if (vec_stb)
         vec_bus <= 1'b1;
end

assign fpp_exc = ftrpi & ~abort & ~abort_lhl;
assign ysp_exc = ysp_en & alu_zh & gr_wr[3] & gr0_wl
               & ~plm_as[33] & ~plm_as[26] & plm_as[21] & ~plm_as[20];
assign bus_exc = qerr & ~vec_bus;
assign dbl_exc = qerr & vec_bus;
assign mmu_exc = mmu_en & ((mrqt_er & ba_lat2_lh) | ir_mmu_err_hl);

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

always @(*)
begin
   if (alu_stb)
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
   end
end

always @(negedge alu_stb) eaf4 <= plf[4] & ~eac[4];

always @(*)
begin
   if (~psw_lat)
      psw_t[15:14] <= psw_smod ? psw[15:14] : f[15:14];

   if (pswh_inf)
      psw[15:12] <= {f[15:14], psw_t[15:14]};
   else
      if (pswh_ind)
         psw[15:12] <= d[15:12];

   psw[11:8] <= 4'b0000;               // always zero, reserved

   if (dclo)
      psw[7:4] <= 4'b0000;
   else
   begin
      if (pswh_inf)
         psw[7:5] <= f[7:5];
      else
         if (pswl_ind)
            psw[7:5] <= d[7:5];
      if (pswl_inf)                    // T-bit can't be altered
         psw[4] <= f[4];               // from data bus, ALU only
   end

   if (pswl_stb)
      psw_s[3:0] <= psw[3:0];          // save flags to backup register

   if (pswl_inp)
      psw[3:0] <= plf[3:0];
   else
      if (pswl_inf)
         psw[3:0] <= f[3:0];
      else
         if (pswl_ind)
            psw[3:0] <= d[3:0];
         else
            if (pswl_ins)              // restore flags on bus timeout
               psw[3:0] <= psw_s[3:0]; // from the hidden backup register
end

assign psw_smod = ~ba_pca & mt_op[1];
assign psw_lat  = alu_wr | pswh_ind | pswl_ind | pswl_ins;
assign pswl_ins = pswl_ins_t & qerr_lh;
assign pswh_ind = rg_wr & r7777 & dwbh;
assign pswl_ind = rg_wr & r7777 & dwbl;
assign pswh_inf = pswh_inf_t & alu_wr;
assign pswl_inf = pswl_inf_t & alu_wr;
assign pswl_inp = pswl_inp_t & alu_wr & ~pswl_ind & ~pswl_ind_t;
assign pswl_stb = (plm_as[31:29] == 3'b100) & ~alu_wr & alu_stb;

always @(*)
begin
   if (~pin_clk) pswl_ind_t <= pswl_ind;
   if (~psw_lat)
   begin
      pswh_inf_t <= (plm_as[31:29] == 3'b101) & (~mt_mod[6] | ~dc_rtx);
      pswl_inf_t <= (plm_as[31:29] == 3'b101);
      pswl_inp_t <= plm_as[18] & ~pswl_ind & ~pswl_ind_t;
   end

   if (~alu_stb)
      pswl_ins_t <= plm_as[31:29] == 3'b100;
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

always @(*)
begin
   if (~alu_rd)
   begin
      mx_rx_t  <=  plm[11] | ~plm[15];
      pc_rx_t  <= ~plm[11] &  plm[15] & rsel[2] & rsel[1] & rsel[0];
      dx_mx_t  <=  plm[11] & ~plm[15];
      rra_mx_t <= ~plm[11] & ~plm[15];
      psw_mx_t <=  plm[11] &  plm[15];

      my_ry_t  <=  plm[22] | ~plm[24];
      pc_ry_t  <= ~plm[22] &  plm[24] & rsel[6] & rsel[5] & rsel[4];
      dx_my_t  <=  plm[22] & ~plm[24];
      rra_my_t <=  plm[22] &  plm[24];

      ba_fsel_t <= plm_f32;
   end
end

assign mx_rx  = alu_rd & mx_rx_t;
assign my_ry  = alu_rd & my_ry_t;
assign pc_rx  = alu_rd & pc_rx_t;
assign pc_ry  = alu_rd & pc_ry_t;
assign dx_mx  = alu_rd & dx_mx_t;
assign dx_my  = alu_rd & dx_my_t;
assign rra_mx = alu_rd & rra_mx_t;
assign rra_my = alu_rd & rra_my_t;
assign psw_mx = alu_rd & psw_mx_t;
assign ba_fsel = ~(alu_rd & ba_fsel_t);

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

always @(*)
begin
   if (alu_stb)
      alu_stw <= 1'b0;
   else
      if (alu_wr)
         alu_stw <= 1'b1;
end

always @(*)
begin
   if (alu_stw)
   begin
      ic[0] <= ic0_t;
      ic[1] <= ic1_t;
   end
   else
   begin
      ic0_t <= ~ac[8];
      ic1_t <= ~ac[11];
   end

   if (~alu_stb)
   begin
      ic[2] <= r11_b15 ^ cia[6];
      ic[3] <= r10_b15 ^ cia[6];
      ic[4] <= act_zf;
      ic[5] <= plm[33] ? ~alu_zf : act_b[5];
      ic[6] <= plm[33] ? ~rra[0] : act_b[0];
   end
end

always @(*)
begin
   if (~alu_wr)   // extended arithmetics controls
   begin
      eac[0] <= ac[2];
      eac[1] <= ac[10];
      eac[2] <= ac[14];
      eac[3] <= ac[15];
      eac[4] <= ac[5];
      psw0r <= psw[0];
   end
end

always @(*)
begin
   if (~alu_stb)
   begin
      alu_shl_t <= ac[13];
      alu_shr_t <= ~ac[17];
      alu_dir_t <= ~ac[16];
   end
end

assign alu_b = ~ac[6];     // X-argument inversion
assign alu_c = ~ac[9];     // no add - suppress carries
assign alu_d = ~ac[0];     // ALU AND control
assign alu_e = ~ac[4];     // ALU AND control
assign alu_f = ~ac[3];     // ALU OR control
assign alu_g = ~ac[1];     // ALU OR control
assign alu_ac = ~ac[7];    // ALU adder lsb carry

assign alu_shl = alu_shl_t & alu_stb;
assign alu_shr = alu_shr_t & alu_stb;
assign alu_dir = alu_dir_t & alu_stb;

always @(*)
begin
   if (alu_dir)
      f <= af;
   else
      if (alu_shr)
         f <= {cin15, af[15:9], cin7, af[7:1]};
      else
         if (alu_shl)
            f <= {af[14:0], cin0};
end

always @(*)
begin
   if (~alu_stb)
   begin
      ax <= x;
      ay <= y;
      ana <= 16'o000000;
      ora <= 16'o177777;
   end
   else
   begin
      ana <= (alu_d ?  ay : 16'o000000) & (alu_b ? ~ax : ax)
           | (alu_e ? ~ay : 16'o000000) & (alu_b ? ~ax : ax);

      ora <= (alu_b ? ~ax : ax)
           | (alu_f ? ~ay : 16'o000000)
           | (alu_g ?  ay : 16'o000000);
   end
end

assign s = ora & ~ana;
assign c = ana | ora & {c[14:0], alu_ac};
assign af = s ^ (alu_c ? 16'o000000 : {c[14:0], alu_ac});

assign alu_zh = (f[15:8] == 8'b00000000);
assign alu_zl = (f[7:0] == 8'b00000000);
assign alu_zf = alu_zl & (alu_zh | ~plm[28]);

assign cin0 = psw0r & ~ac[12] | rra[15] & (eac[2] | ~eac[3]);
assign cin7 = plm[28] ? af[8] : (ac[12] ? af[7] : psw0r);
assign cin15 = ac[12] ? (s[15] ? ~c15af : c15af) : psw0r;
assign c15af = c[15] & ~alu_c;

//______________________________________________________________________________
//
// Extended arithmetics shift register
//
always @(*)
begin
   if (rra_fwr) rra_ix <= f;
   if (rra_shr) rra_ix <= {rra_in15, rra[15:1]};
   if (rra_shl) rra_ix <= {rra[14:0], rra_in0};
   if (rra_wr) rra <= rra_ix;
end

assign rra_zf = (rra_ix == 16'b000000);
assign rra_shl = alu_stb & eac[2];
assign rra_shr = alu_stb & ~eac[1];
assign rra_in0 = ~eac[3] & (r10_b15 ^ cia[6]);
assign rra_in15 = ~cia[4];

always @(*)
begin
   if (~alu_wr)
   begin
      rra_fwr_t <= eac[1] & ~eac[2];
      rra_wr_t <= ~rra_fwr_t | (plm_as[31:29] == 3'b000);
   end
end

assign rra_fwr = rra_fwr_t & alu_wr;
assign rra_wr = rra_wr_t & alu_wra & alu_wr;

//______________________________________________________________________________
//
// Extended arithmetics counter
//
always @(*)
begin
   if (act_wr) act_i <= f[5:0];
   if (act_w15) act_i <= 6'b001111;
   if (act_w17) act_i <= 6'b010001;
   if (~act_lat) act_i <= ~act_n ^ {1'b0, act_c[3:0], 1'b1};

   if (act_lat) act_n <= ~act_i;
end

always @(*)
begin
   if (~alu_wr) act_wr_t <= plm_rw & act_rd_t;
   if (alu_rd) act_rd_t <= ~rsel[0] & ~rsel[1] & rsel[2] & rsel[3];
end

assign act_wr = act_wr_t & alu_wr;
assign act_lat = ~alu_stb;
assign act_c = act_n[3:0] & {act_c[2:0], 1'b1};
assign act_zf = (act_b[4:1] == 4'b0000);
assign act_b = ~act_n;

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
assign con_stb = alu_rd & con_stb_t;
assign vec_stb = alu_rd & vec_stb_t;

always @(*)
begin
   if (~alu_rd)
   begin
      vec_stb_t <= ~plm[24] & ~plm[22] & ~plm[13] & (plm[37:34] == 4'b1111);
      con_stb_t <= ~plm[24] & ~plm[22] & ~(~plm[13] & (plm[37:34] == 4'b1111));
   end
end

//
// Register strobe input latches
//
always @(*)
begin
   if (~alu_rd)
   begin
      gr_rx_t[0] <= ~rsel[3] & ~rsel[2] & ~rsel[1];   // R1:R0
      gr_rx_t[1] <= ~rsel[3] & ~rsel[2] &  rsel[1];   // R3:R2
      gr_rx_t[2] <= (~rsel[3] | rsel[0])              // R15 & R5
                             &  rsel[2] & ~rsel[1];   // R5:R4
      gr_rx_t[3] <=  rsel[2] &  rsel[1] & ~rsel[0];   // USP:KSP
      gr_rx_t[4] <=  rsel[3] & ~rsel[2] & ~rsel[1];   // R11:R10

      gr_ry_t[0] <= ~rsel[7] & ~rsel[6] & ~rsel[5];   // R1:R0
      gr_ry_t[1] <= ~rsel[7] & ~rsel[6] &  rsel[5];   // R3:R2
      gr_ry_t[2] <= (~rsel[7] | rsel[4])              // R15 & R5
                             &  rsel[6] & ~rsel[5];   // R5:R4
      gr_ry_t[3] <=  rsel[6] &  rsel[5] & ~rsel[4];   // USP:KSP
      gr_ry_t[4] <=  rsel[7] & ~rsel[6] & ~rsel[5];   // R11:R10
   end

   if (alu_rd)
   begin
      gr_wr_rt[0] <= ~rsel[3] & ~rsel[2] & ~rsel[1];  // R1:R0
      gr_wr_rt[1] <= ~rsel[3] & ~rsel[2] &  rsel[1];  // R3:R2
      gr_wr_rt[2] <= (~rsel[3] | rsel[0])             // R15 & R5
                             &  rsel[2] & ~rsel[1];   // R5:R4
      gr_wr_rt[3] <=  rsel[2] &  rsel[1] & ~rsel[0];  // USP:KSP
      gr_wr_rt[4] <=  rsel[3] & ~rsel[2] & ~rsel[1];  // R11:R10

      gr0_wr_t <= dst_r6 ? sys_r6 : ~rsel[0];
      gr1_wr_t <= dst_r6 ? ~sys_r6 : rsel[0];
   end

   if (~alu_wr)
   begin
      gr_wr_wt <= plm_rw ? gr_wr_rt : 5'b00000;

      gr0_wl_t <= plm_rw & gr0_wr_t;
      gr0_wh_t <= plm_rw & gr0_wr_t & plm_as[28];
      gr1_wl_t <= plm_rw & gr1_wr_t;
      gr1_wh_t <= plm_rw & gr1_wr_t & plm_as[28];
   end
end

assign gr_rx = alu_rd ? gr_rx_t  : 5'b00000;
assign gr_ry = alu_rd ? gr_ry_t  : 5'b00000;
assign gr_wr = alu_wr ? gr_wr_wt : 5'b00000;

assign plm_rw = (plm_as[31:29] == 3'b010) | (plm_as[31] & plm_as[30]);
assign dst_r6 = alu_rd & rsel[2] & rsel[1] & ~rsel[0];
assign src_r6 = alu_rd & rsel[6] & rsel[5] & ~rsel[4];
assign psw_r6 = (iop != 4'b0001) & (iop != 4'b1000);
assign sys_r6 = psw_r6 ? ~psw[15] : ~psw[13];

assign gr0_rx = ~mx_rx & (dst_r6 ? sys_r6 : ~rsel[0]);
assign gr0_ry = ~my_ry & (src_r6 ? sys_r6 : ~rsel[4]);
assign gr0_wl = alu_wr & gr0_wl_t;
assign gr0_wh = alu_wr & gr0_wh_t;

assign gr1_rx = ~mx_rx & (dst_r6 ? ~sys_r6 : rsel[0]);
assign gr1_ry = ~my_ry & (src_r6 ? ~sys_r6 : rsel[4]);
assign gr1_wl = alu_wr & gr1_wl_t;
assign gr1_wh = alu_wr & gr1_wh_t;

//______________________________________________________________________________
//
// Register files
//
always @(*)
begin
   if (gr0_wl)
   begin
      if (gr_wr[0]) gr0[0][7:0] <= f[7:0];
      if (gr_wr[1]) gr0[1][7:0] <= f[7:0];
      if (gr_wr[2]) gr0[2][7:0] <= f[7:0];
      if (gr_wr[3]) gr0[3][7:0] <= f[7:0];
      if (gr_wr[4]) gr0[4][7:0] <= f[7:0];
   end
   if (gr0_wh)
   begin
      if (gr_wr[0]) gr0[0][15:8] <= f[15:8];
      if (gr_wr[1]) gr0[1][15:8] <= f[15:8];
      if (gr_wr[2]) gr0[2][15:8] <= f[15:8];
      if (gr_wr[3]) gr0[3][15:8] <= f[15:8];
      if (gr_wr[4]) gr0[4][15:8] <= f[15:8];
   end
   if (gr1_wl)
   begin
      if (gr_wr[0]) gr1[0][7:0] <= f[7:0];
      if (gr_wr[1]) gr1[1][7:0] <= f[7:0];
      if (gr_wr[2]) gr1[2][7:0] <= f[7:0];
      if (gr_wr[3]) gr1[3][7:0] <= f[7:0];
      if (gr_wr[4]) gr1[4][7:0] <= f[7:0];
   end
   if (gr1_wh)
   begin
      if (gr_wr[0]) gr1[0][15:8] <= f[15:8];
      if (gr_wr[1]) gr1[1][15:8] <= f[15:8];
      if (gr_wr[2]) gr1[2][15:8] <= f[15:8];
      if (gr_wr[3]) gr1[3][15:8] <= f[15:8];
      if (gr_wr[4]) gr1[4][15:8] <= f[15:8];
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
always @(*)
begin
   if (pc_wr0)
      pc <= f;
   else
      if (pc_wr1)
         pc[15:1] <= pc2[15:1];

   if (pc_wr0)
      pc2[15:0] <= {f[15:1], 1'b0};
   else
      if (pc_wr2)
         pc2[15:0] <= pc2_t[15:0];

   if (~pc_wr2)
      pc2_t[15:0] <= {pca[15:1], 1'b0};
end

assign pca = {pc2[15:1], pc[0]} + 16'o000002;

//______________________________________________________________________________
//
// MMU registers
//
always @(*)
begin
   if (par_wl)
   begin
      if (parh_sel[2]) parh[7:0] <= d[7:0];
      if (padr_sel[0]) par[0][7:0] <= d[7:0];
      if (padr_sel[1]) par[1][7:0] <= d[7:0];
      if (padr_sel[2]) par[2][7:0] <= d[7:0];
      if (padr_sel[3]) par[3][7:0] <= d[7:0];
      if (padr_sel[4]) par[4][7:0] <= d[7:0];
      if (padr_sel[5]) par[5][7:0] <= d[7:0];
      if (padr_sel[6]) par[6][7:0] <= d[7:0];
      if (padr_sel[7]) par[7][7:0] <= d[7:0];
      if (padr_sel[8]) par[8][7:0] <= d[7:0];
      if (padr_sel[9]) par[9][7:0] <= d[7:0];
      if (padr_sel[10]) par[10][7:0] <= d[7:0];
      if (padr_sel[11]) par[11][7:0] <= d[7:0];
      if (padr_sel[12]) par[12][7:0] <= d[7:0];
      if (padr_sel[13]) par[13][7:0] <= d[7:0];
      if (padr_sel[14]) par[14][7:0] <= d[7:0];
      if (padr_sel[15]) par[15][7:0] <= d[7:0];
   end
   if (par_wh)
   begin
      if (parh_sel[2]) parh[15:8] <= d[15:8];
      if (padr_sel[0]) par[0][15:8] <= d[15:8];
      if (padr_sel[1]) par[1][15:8] <= d[15:8];
      if (padr_sel[2]) par[2][15:8] <= d[15:8];
      if (padr_sel[3]) par[3][15:8] <= d[15:8];
      if (padr_sel[4]) par[4][15:8] <= d[15:8];
      if (padr_sel[5]) par[5][15:8] <= d[15:8];
      if (padr_sel[6]) par[6][15:8] <= d[15:8];
      if (padr_sel[7]) par[7][15:8] <= d[15:8];
      if (padr_sel[8]) par[8][15:8] <= d[15:8];
      if (padr_sel[9]) par[9][15:8] <= d[15:8];
      if (padr_sel[10]) par[10][15:8] <= d[15:8];
      if (padr_sel[11]) par[11][15:8] <= d[15:8];
      if (padr_sel[12]) par[12][15:8] <= d[15:8];
      if (padr_sel[13]) par[13][15:8] <= d[15:8];
      if (padr_sel[14]) par[14][15:8] <= d[15:8];
      if (padr_sel[15]) par[15][15:8] <= d[15:8];
   end
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

always @(*)
begin
   if (pdr_wl)
   begin
      if (padr_sel[0]) pdr[0][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[1]) pdr[1][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[2]) pdr[2][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[3]) pdr[3][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[4]) pdr[4][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[5]) pdr[5][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[6]) pdr[6][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[7]) pdr[7][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[8]) pdr[8][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[9]) pdr[9][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[10]) pdr[10][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[11]) pdr[11][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[12]) pdr[12][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[13]) pdr[13][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[14]) pdr[14][5:1] <= {2'b00, d[3:1]};
      if (padr_sel[15]) pdr[15][5:1] <= {2'b00, d[3:1]};

      if (padr_sel[0]) pdr[0][7] <= 1'b0;
      if (padr_sel[1]) pdr[1][7] <= 1'b0;
      if (padr_sel[2]) pdr[2][7] <= 1'b0;
      if (padr_sel[3]) pdr[3][7] <= 1'b0;
      if (padr_sel[4]) pdr[4][7] <= 1'b0;
      if (padr_sel[5]) pdr[5][7] <= 1'b0;
      if (padr_sel[6]) pdr[6][7] <= 1'b0;
      if (padr_sel[7]) pdr[7][7] <= 1'b0;
      if (padr_sel[8]) pdr[8][7] <= 1'b0;
      if (padr_sel[9]) pdr[9][7] <= 1'b0;
      if (padr_sel[10]) pdr[10][7] <= 1'b0;
      if (padr_sel[11]) pdr[11][7] <= 1'b0;
      if (padr_sel[12]) pdr[12][7] <= 1'b0;
      if (padr_sel[13]) pdr[13][7] <= 1'b0;
      if (padr_sel[14]) pdr[14][7] <= 1'b0;
      if (padr_sel[15]) pdr[15][7] <= 1'b0;
   end
   if (pdr_wh)
   begin
      if (padr_sel[0]) pdr[0][14:8] <= d[14:8];
      if (padr_sel[1]) pdr[1][14:8] <= d[14:8];
      if (padr_sel[2]) pdr[2][14:8] <= d[14:8];
      if (padr_sel[3]) pdr[3][14:8] <= d[14:8];
      if (padr_sel[4]) pdr[4][14:8] <= d[14:8];
      if (padr_sel[5]) pdr[5][14:8] <= d[14:8];
      if (padr_sel[6]) pdr[6][14:8] <= d[14:8];
      if (padr_sel[7]) pdr[7][14:8] <= d[14:8];
      if (padr_sel[8]) pdr[8][14:8] <= d[14:8];
      if (padr_sel[9]) pdr[9][14:8] <= d[14:8];
      if (padr_sel[10]) pdr[10][14:8] <= d[14:8];
      if (padr_sel[11]) pdr[11][14:8] <= d[14:8];
      if (padr_sel[12]) pdr[12][14:8] <= d[14:8];
      if (padr_sel[13]) pdr[13][14:8] <= d[14:8];
      if (padr_sel[14]) pdr[14][14:8] <= d[14:8];
      if (padr_sel[15]) pdr[15][14:8] <= d[14:8];
   end

   if (ws_rst)
      ws_pdr[15:0] <= 16'o000000;
   else
      if (ws_set) // store register selection
      begin
         if (padr_sel[0]) ws_pdr[0] <= 1'b1;
         if (padr_sel[1]) ws_pdr[1] <= 1'b1;
         if (padr_sel[2]) ws_pdr[2] <= 1'b1;
         if (padr_sel[3]) ws_pdr[3] <= 1'b1;
         if (padr_sel[4]) ws_pdr[4] <= 1'b1;
         if (padr_sel[5]) ws_pdr[5] <= 1'b1;
         if (padr_sel[6]) ws_pdr[6] <= 1'b1;
         if (padr_sel[7]) ws_pdr[7] <= 1'b1;
         if (padr_sel[8]) ws_pdr[8] <= 1'b1;
         if (padr_sel[9]) ws_pdr[9] <= 1'b1;
         if (padr_sel[10]) ws_pdr[10] <= 1'b1;
         if (padr_sel[11]) ws_pdr[11] <= 1'b1;
         if (padr_sel[12]) ws_pdr[12] <= 1'b1;
         if (padr_sel[13]) ws_pdr[13] <= 1'b1;
         if (padr_sel[14]) ws_pdr[14] <= 1'b1;
         if (padr_sel[15]) ws_pdr[15] <= 1'b1;
      end

   if (wf_set)    // set page dirty W-bit
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
   else
   if (wr_2376)   // reset page dirty W-bit
   begin
      if (ws_pdr[0]) pdr[0][6] <= 1'b0;
      if (ws_pdr[1]) pdr[1][6] <= 1'b0;
      if (ws_pdr[2]) pdr[2][6] <= 1'b0;
      if (ws_pdr[3]) pdr[3][6] <= 1'b0;
      if (ws_pdr[4]) pdr[4][6] <= 1'b0;
      if (ws_pdr[5]) pdr[5][6] <= 1'b0;
      if (ws_pdr[6]) pdr[6][6] <= 1'b0;
      if (ws_pdr[7]) pdr[7][6] <= 1'b0;
      if (ws_pdr[8]) pdr[8][6] <= 1'b0;
      if (ws_pdr[9]) pdr[9][6] <= 1'b0;
      if (ws_pdr[10]) pdr[10][6] <= 1'b0;
      if (ws_pdr[11]) pdr[11][6] <= 1'b0;
      if (ws_pdr[12]) pdr[12][6] <= 1'b0;
      if (ws_pdr[13]) pdr[13][6] <= 1'b0;
      if (ws_pdr[14]) pdr[14][6] <= 1'b0;
      if (ws_pdr[15]) pdr[15][6] <= 1'b0;
   end
end

always @(*)
begin
   if (pin_clk) ws_rst_t0 <= wf_set | io_res2;
   if (~pin_clk) ws_rst_t1 <= ws_rst_t0;
   if (pin_clk) op3_wf_lh  <= op3_wf_l;
   if (~pin_clk) op3_wf_l  <= op3_wf;
end

assign ws_set = wr_2376 | rd_2376 | (~ba_pca & op1_wf);
assign ws_rst = mc_res | (~rd_2376 & rd_2376_lh) | (op3_wf_lh & ws_rst_t1);
assign wf_set = mmu_en & op3_wf & wrf_set;
assign wrf_set = (rply & dout_l) | rmsel & ~(r757x & ~la[2] & la[1]) & pa_oe_l;

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

always @(*)
begin
   if (~mm_stb)   // MMU register selectors
   begin
      parh_sel_t[0] <= ~mm_sa[2] & ~mm_sa[1] & mm_sah;
      parh_sel_t[1] <= ~mm_sa[2] &  mm_sa[1] & mm_sah;
      parh_sel_t[2] <= 1'b0;
      parh_sel_t[3] <=  mm_sa[2] &  mm_sa[1] & mm_sah;

      mm_sa_t <= r2376 ? {la[6], la[3:1]} :
                         {~mt_mod[6], ba[15:13]};

      padr_sel_t[0]  <= (mm_sa == 4'b0000) & ~mm_sah;
      padr_sel_t[1]  <= (mm_sa == 4'b0001) & ~mm_sah;
      padr_sel_t[2]  <= (mm_sa == 4'b0010) & ~mm_sah;
      padr_sel_t[3]  <= (mm_sa == 4'b0011) & ~mm_sah;
      padr_sel_t[4]  <= (mm_sa == 4'b0100) & ~mm_sah;
      padr_sel_t[5]  <= (mm_sa == 4'b0101) & ~mm_sah;
      padr_sel_t[6]  <= (mm_sa == 4'b0110) & ~mm_sah;
      padr_sel_t[7]  <= (mm_sa == 4'b0111) & ~mm_sah;
      padr_sel_t[8]  <= (mm_sa == 4'b1000) & ~mm_sah;
      padr_sel_t[9]  <= (mm_sa == 4'b1001) & ~mm_sah;
      padr_sel_t[10] <= (mm_sa == 4'b1010) & ~mm_sah;
      padr_sel_t[11] <= (mm_sa == 4'b1011) & ~mm_sah;
      padr_sel_t[12] <= (mm_sa == 4'b1100) & ~mm_sah;
      padr_sel_t[13] <= (mm_sa == 4'b1101) & ~mm_sah;
      padr_sel_t[14] <= (mm_sa == 4'b1110) & ~mm_sah;
      padr_sel_t[15] <= (mm_sa == 4'b1111) & ~mm_sah;
   end
end

assign mm_stb = mm_stbs | rd_2376 | wr_2376;
assign mm_stb_set = (ba_pca & ~ba_pca_hl)
                  | (hm_men & ba_rdy_l & ~sa_pfa & ~hm_lat & ~at_stb & ~ba_pca);

always @(*)
begin
   if (mc_res | mm_stb_clr)
      mm_stbs <= 1'b0;
   else
      if (pin_clk & mm_stbs_t)
         mm_stbs <= 1'b1;
   if (~pin_clk)
      mm_stbs_t <= mm_stb_set & ~mm_stbs;

   if (pin_clk) mm_stb_clr <= sa_s16 | at_stb;
   if (~pin_clk) mm_stb_clr_l <= mm_stb_clr;
end

assign parh_sel[0] = parh_sel_t[0] & mm_stb;
assign parh_sel[1] = parh_sel_t[1] & mm_stb;
assign parh_sel[2] = mm_stb & mm_sah & mm_sa[2] & ~mm_sa[1] | parh_en;
assign parh_sel[3] = parh_sel_t[3] & mm_stb;

assign padr_sel = mm_stb ? padr_sel_t : 16'o000000;
assign mm_sah = hmod & ~r2376;
assign mm_sa = mm_sa_t;

assign parh_en = parh_wr | parh_oe;
assign parh_wr = rg_wr & r251x & ~la[2];

assign par_wl = parh_wr | wr_2376 & la[5] & dwbl;
assign par_wh = parh_wr | wr_2376 & la[5] & dwbh;
assign pdr_wl = wr_2376 & ~la[5] & dwbl;
assign pdr_wh = wr_2376 & ~la[5] & dwbh;

assign sr0_wl = rg_wr & r757x & ~la[2] & la[1] & dwbl;
assign sr0_wh = rg_wr & r757x & ~la[2] & la[1] & dwbh;
assign sr3_wr = rg_wr & sr3_wr_t;
always @(*) if (~rg_wr) sr3_wr_t <= r251x & la[2];

assign sr3_ah = sr3_as | hmod;     // 22-bit is enforced by halt mode

always @(*)
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
         sr0[15:13] <= d[15:13];
         sr0[8] <= d[8];
      end
      if (sr0_wl)
         sr0[0] <= d[0];
   end

   if (pin_init_in)
   begin
      sr3_um <= 1'b0;
      sr3_as <= 1'b0;
   end
   else
   if (sr3_wr)
   begin
      sr3_um <= d[5];
      sr3_as <= d[4];
   end
end

assign sr0_en = sr0[0];
assign sr0_m = sr0[8];
assign sr0_er = sr0[13] | sr0[14] | sr0[15];
assign mmu_en = sr0_en | sr0_m & mt_op[3];
assign hm_men = mmu_en | hmod;

always @(*)
begin
   if (ba_lat0) sr2[0] <= ba;
   if (ba_dir) sr2[1] <= ba;
   if (ba_lat1) sr2[1] <= sr2[0];
   if (ba_lat2) sr2[2] <= sr2[1];
   if (ba_lat3) sr2[3] <= sr2[2];
   if (ba_lat4) sr2[4] <= sr2[3];
end

assign ba_rdy = ~ba_req & ~pa_oe & ~sa_sxa_h;
assign ba_dir = (sa_s16 | sa_s22) & pf_00;
assign ba_lat = (~plm_f32 | ~alu_stb) & hm_lat;
assign ba_lat0 = ba_lat0_t & at_stb;
assign ba_lat1 = sa_pfa;
assign ba_lat2 = pa_oe & (~a[0] | ~io_dc[3]);
assign ba_lat3 = ir_stb;
assign ba_lat4 = ~sr0_er & ~mrqt_er & dc_stb;

always @(*)
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

   if (~at_stb) ba_lat0_t <= ba_pca;
end

assign ms_mod[6:5] = msta[3][6:5];
assign ms_ba[15:13] = msta[3][4:2];
assign mrqs_nr = msta[3][1];
assign mrqs_pl = msta[3][0];
assign rd_err = (msta[0][0] | msta[0][1]) & ra_s22_hlh;
assign init_nrpl = pin_init_in | pf_init;

assign ir_mmu_err = (ir_oe | dc_stb) & (mrqs_pl | mrqs_nr);
always @(*)
begin
   if (pin_clk) ir_mmu_err_h <= ir_mmu_err;
   if (~pin_clk) ir_mmu_err_hl <= ir_mmu_err_h;

   if (pin_clk) sr0_er_h <= sr0_er;
   if (~pin_clk) sr0_er_hl = sr0_er_h | ~mmu_en;

   if (~pin_clk) ba_lat2_l <= ba_lat2;
   if (pin_clk) ba_lat2_lh <= ba_lat2_l;
   if (~pin_clk) ba_lat2_lhl <= ba_lat2_lh;

   if (~pin_clk) ba_rdy_l <= ba_rdy;
   if (pin_clk) ba_rdy_lh <= ba_rdy_l;
end

assign sr0_mrqs = ~mrqt_er & (ir_oe | dc_stb) & ~sr0_er_hl;
assign sr0_mrqt = ba_lat2_l & ~sr0_er_hl;

//______________________________________________________________________________
//
// Address translation and prefetch pipepline
//
always @(*)
begin
   if (ba_lat) ba_reg <= ba_fsel ? f : x;
   if (~ba_lat) a0_reg <= ba_reg[0];

   if (ra_s22) ra <= {sa[21:6], ba[5:0]};                // translate instruction
   if (ra_s16) ra <= {sa77 ? 6'o77 : 6'o00, ba[15:0]};   // prefetch address

   if (sa_pfa) ca <= ra;                                 // store prefetch address
   if (sa_pfa) a <= ra;                                  // for write compare
   if (pa_oe) adr_eq <= (ca[21:1] == a[21:1]);           // prefetch address compare

   if (sa_s22) a <= {sa[21:6], ba[5:0]};                 // translate regular
   if (sa_s16) a <= {sa77 ? 6'o77 : 6'o00, ba[15:0]};    // data exchange address
   if (dclo) a[21] <= 1'b0;

   if (~at_stb)
   begin
      sa_t[21:6] <= {sr3_ah ? pa[15:12] : 4'b0000, pa[11:0]}
                  + {9'b000000000 + ba[12:6]};

      mrq_pl_t0 <= ~pd[3] ? (ba[12:6] > pd[14:8]) :   // page grows up
                            (ba[12:6] < pd[14:8]);    // page grows down
   end
   else
   begin
      sa[21:6] <= sa_t[21:6];
      mrq_pl_t1 <= mrq_pl_t0;
   end

end

assign ba = ba_pca ? pca : ba_reg;
assign sa77 = ba[15:13] == 3'b111;

always @(*) if (mm_stb) pa[15:0] <= mmu_a[15:0];
always @(*) if (mm_stb) pd[14:1] <= mmu_d[14:1];

assign bs_a22 = (a[21:13] == 9'o777);
assign bs_a18 = (a[17:13] == 5'o37) & ~sr3_ah;

always @(*)
begin
   if (ra_s16 | ra_s22)
      sel_ra_t <= hmod & ~ba[15];
   if (dclo)
      sel_sa_t <= 1'b0;
   else
      if (sa_pfa)
         sel_sa_t <= sel_ra_t;
      else
         if (sa_s16 | sa_s22)
            sel_sa_t <= hmod & ~ba[15];
end
assign sel = sel_sa_t;

assign mrq_pl = ~hmod & mrq_pl_t1;                             // page limit error
assign mrq_ro = ~hmod & op1_wf & ~pd[2] & pd[1];               // readonly error
assign mrq_nr = ~hmod & (~pd[1] | (mt_mod[5] ^ mt_mod[6]));    // not resident or bad mode
assign mrqt_er = mrqt_pl | mrqt_ro | mrqt_nr;

assign mt_mod[5] = ((mt_op[0] | ba_pca) ? psw[14] : psw[12]) & ~psw_smod;
assign mt_mod[6] = ((mt_op[0] | ba_pca) ? psw[15] : psw[13]) & ~psw_smod;

always @(*)
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

always @(*)
begin
   if (pin_clk) sa_s22_h <= sa_s22;
   if (~pin_clk) sa_s22_hl <= sa_s22_h;

   if (pin_clk) ra_s22_h <= ra_s22;
   if (~pin_clk) ra_s22_hl <= ra_s22_h;
   if (pin_clk) ra_s22_hlh <= ra_s22_hl;

   if (pin_clk) sa_sxa_h <= sa_sxa;
   if (~pin_clk) sa_sxa_hl <= sa_sxa_h;
end

always @(*)
begin
   ra_s16_t <= ba_pca & ~(hm_men & ~sr0_m);
   ra_s22_t <= ba_pca & hm_men & ~sr0_m;
   sa_s22_t <= ~ba_pca;
end

assign ra_s16 = ra_s16_t & at_stb;
assign ra_s22 = ra_s22_t & at_stb;
assign sa_s22 = sa_s22_t & at_stb;
assign sa_sxa = sa_s16 | sa_s22;
assign sa_s16 = ~hm_lat_set & ~hm_men & ~ba_pca & ~sa_pfa & ba_rdy_l & ~hm_lat;

assign ba_pca_clr = ~at_stb & ~ba_pca_clr_t;
always @(*)
begin
   if (mc_res | ba_pca_clr)
      ba_pca <= 1'b0;
   else
      if (~pin_clk & ba_pca_t)
         ba_pca <= 1'b1;

   if (pin_clk)
      ba_pca_t <= ~ba_pca & ba_rdy_lh & ~r2376 & ~pf_ba0_h
                & pc3_rdy_h & ~mm_stbs & ~mm_stb_clr;

   if (pin_clk) ba_pca_h <= ba_pca;
   if (~pin_clk) ba_pca_hl <= ba_pca_h;

   if (~pin_clk & mm_stb_clr)
      ba_pca_clr_t <= 1'b0;
   else
      if (pin_clk & ~ba_pca)
         ba_pca_clr_t <= 1'b1;
end

always @(*)
begin
   if (mc_res | mm_stb_clr_l)
      at_stb <= 1'b0;
   else
      if (~pin_clk & at_stb_t)
         at_stb <= 1'b1;

   if (pin_clk)
      at_stb_t <= ~at_stb & mm_stbs;
end

always @(*)
begin
   if (mc_res | (sa_pfa_hl & ~ba_rdy_l))
      sa_pfa <= 1'b0;
   else
      if (~pin_clk & sa_pfa_t)
         sa_pfa <= 1'b1;

   if (pin_clk)
      sa_pfa_t <= ~sa_pfa & ba_ins;

   if (pin_clk) sa_pfa_h <= sa_pfa;
   if (~pin_clk) sa_pfa_hl <= sa_pfa_h;
end

//______________________________________________________________________________
//
// Prefetch controls
//
assign pf_p = pf_ena ? pf_t : 3'b111;
assign pf_n = pf_ena ? ~pf_t : 3'b111;

always @(*)
begin
   if (~pf_ena)
      pf_t <= {pl[12], pl[9], pl[10]};

   if (mc_res | (pf_ena_clr & pin_clk))
      pf_ena <= 1'b0;
   else
      if (pin_clk & plr_lat)
         pf_ena <= 1'b1;

   if (~pin_clk) pf_00_l <= pf_00;
   if (~pin_clk) pf_01_l <= pf_01;
end

assign pf_00 = ~pf_p[1] & ~pf_p[0];
assign pf_01 = ~pf_p[1] & ~pf_n[0];
assign pf_pa = pf_00a & pa_oe;

assign pf_inv = rd_err | (qt_out & irply_en)
              | (op1_wf & opwf_clr & (rmsel | adr_eq));

assign pf_ena_clr = pf_end0 | dc_stb
                  | (plm_lat & (pf_01 | (~pf_p[0] & ~pf_n[1])));

always @(*)
begin
   if (mc_res)
      pf_00r <= 1'b0;
   else
      if (plr_lat_h)
         pf_00r <= pf_00;

   if (mc_res | dc_stb_hl)
      pf_00m_t <= 1'b0;
   else
      if (plm_lat & pf_00)
         pf_00m_t <= 1'b1;

   if (pin_clk) pf_00m <= pf_00m_t;

   if (mc_res | dc_stb)
      pf_00a <= 1'b0;
   else
      if (sa_sxa)
         pf_00a <= pf_00m;
end

always @(*)
begin
   if (pf_init | sa_pfa)
      pf_ba0 <= 1'b0;
   else
      if (ba_lat0)
         pf_ba0 <= 1'b1;

   if (pin_clk) pf_ba0_h <= pf_ba0;
   if (~pin_clk) pf_ba0_hl <= pf_ba0_h;
end

assign pc_wr0 = pc_wr0_wt & alu_wr;
assign pc_wr1 = (pc_wr2 & ~pc2_wrr) | (alu_stb & pc2_wrc_lh);
assign pc_wr2 = pc3_rdy & ~pf_ba0 & pf_ba0_hl;
assign pc2_wrc = alu_rd & pc2_wrf & pc2_wrm;
assign pc2_wrq = ~pf_n[0] & ~pf_n[1] & dc_en[2];

always @(*)
begin
   if (mc_res | alu_rd_lh)
      pc2_wrm <= 1'b0;
   else
      if (plm_lat & pc2_wrr)
         pc2_wrm <= 1'b1;

   if (mc_res)
      pc2_wrr <= 1'b1;
   else
      if (plr_lat_h)
         pc2_wrr <= pc2_wrq | (pf_n[2] & pf_01);

   if (mc_res | pc2_wrc_lh)
      pc2_wrf <= 1'b0;
   else
      if (pc2_wrr & pc_wr2)
         pc2_wrf <= 1'b1;

   if (~pin_clk) pc2_wrc_l <= pc2_wrc;
   if (pin_clk) pc2_wrc_lh <= pc2_wrc_l;
end

always @(*)
begin
   if (~alu_wr) pc_wr0_wt <= plm_rw & pc_wr0_rt;
   if (alu_rd) pc_wr0_rt <= rsel[2:0] == 3'b111;

   if (~pin_clk)
      pc3_rdy_set <= pf_00m & pc_wr0;

   if (mc_res | pf_init)
      pc3_rdy <= 1'b0;
   else
      if (pc3_rdy_set)
         pc3_rdy <= 1'b1;

   if (pin_clk) pc3_rdy_h <= pc3_rdy;
end

assign pf_init = pf_00 & plm_lat;
assign fpp_ir = ~ir_stb & ~ir_doe_h;

always @(*)
begin
   if (pf_pa)
      fpp_pa <= 1'b1;
   else
      if (pf_00m & dc_stb_h)
         fpp_pa <= 1'b0;

   if (~pin_clk) pf_pa_l <= pf_pa;
end

always @(*)
begin
   if (mc_res | pf_end1 | sa_pfa)
      plm_rdy <= 1'b1;
   else
      if (plm_lat & ~pf_00r & ~pf_rdy)
         plm_rdy <= 1'b0;
end

always @(*)
begin
   if (~pin_clk) pf_doe_l <= pf_doe;
   if (pin_clk) pf_doe_lh <= pf_doe_l;
   if (~pin_clk) pf_tout_l <= pf_tout;
   if (pin_clk) pf_tout_lh <= pf_tout_l;
end

assign pf_tout = irply & pf_doe_lh;
assign pf_tout_st = pf_tout & ~pf_tout_lh;
assign pf_doe = pf_01 | pc2_wrq | ir_doe_h;
assign ins_set = sa_pfa | (sa_sxa & pf_00a) | ins_req_l;
assign pf_ins = pf_n[0] | pf_n[1] | (dc_en[0] & dc_en[2] & dc_en[3]);
assign ba_ins = (ir_doe_h | fpp_rdy_lh)
              & pf_ba0_h & hm_lat_h & ~pf_rdy
              & ~pf_00 & pf_ins & ba_rdy
              & (~pf_doe | (~irply & ~ir_stb));

always @(*)
begin
   if (mc_res | (~ir_stb & ir_stb_l))
      a21_ins <= 1'b0;
   else
      if (pin_clk & bus_free & ins_set)
         a21_ins <= 1'b1;

   if (~pin_clk) a21_ins_l <= a21_ins;
   if (pin_clk) a21_ins_lh <= a21_ins_l;

   if (mc_res | (~a21_ins_lh & a21_ins_l))
      ins_req <= 1'b0;
   else
      if (pin_clk & ~bus_free & ins_set)
         ins_req <= 1'b1;

   if (~pin_clk) ins_req_l <= ins_req;
end

always @(*)
begin
   if (~pin_clk)
      pf_end0 <= ~pf_n[1] & ~pf_n[0] & (~dc_en2_h | ~dc_en[0]);

   if (~pin_clk)
      pf_end1 <= pf_tout_st | pf_end0_h;

   if (mc_res | sa_pfa_h | pf_tout_st | pf_end0_h)
      pf_rdy <= 1'b1;
   else
      if (~plm_set0 & plm_set0_lh)
         pf_rdy <= 1'b0;

   if (pin_clk) dc_en2_h <= dc_en[2];
   if (pin_clk) pf_end0_h <= pf_end0;
end

//______________________________________________________________________________
//
// HALT mode flag
//
always @(*)
begin
   if (dclo)
      hmod <= 1'b0;
   else
      if (hm_lat)
         hmod <= hltm;

   if (hm_lat_set | mc_res)
      hm_lat <= 1'b1;
   else
      if (hm_lat_clr_t & ~pin_clk)
         hm_lat <= 1'b0;

   if (pin_clk)
      hm_lat_clr_t <= hm_lat_clr;

   if (pin_clk)
      hm_lat_h <= hm_lat;
end

assign hm_lat_clr = hm_lat & ( alu_wr & (plm_f30_as | plm_f31_as)
                             | alu_stb & plm_f32 );
assign hm_lat_set = ~ba_pca_hl & mm_stb_clr_l;

//______________________________________________________________________________
//
// IO operations and memory translations decoder
//
assign iop = {plm[25], plm[27], plm[19], plm[23]};

always @(*)
begin
   if (io_lat1)
      iop_m <= {~plm85p, iop[3:0]};

   if (io_res2)
      iop_t <= 4'b0010;
   else
      if (io_lat2)
         iop_t <= iop_m[3:0];
end

assign io_s[0] = (iop == 4'b0000);
assign io_s[1] = (iop == 4'b1001) & (ov[3:0] == 4'b0011);
assign io_s[2] = (iop == 4'b1001) & (ov[3:0] == 4'b0011) & ~dvc_stb;
assign io_s[3] = (iop == 4'b1101);
assign io_s[4] = (iop == 4'b0100);

always @(*)
begin
   if (alu_stb) io_s0_as <= io_s[0];
   if (~alu_rd) io_s0_rd <= io_s0_as;
   if (pin_clk) alu_drdy <= do_oe & ~io_s0_rd;

   if (io_lat0)
      op0_wf <= plm[23] & (~plm[25] | plm[19]);
   else
      if (alu_rd_lhl)
         op0_wf <= 1'b0;

   if (opwf_clr_l)
      op1_wf <= 1'b0;
   else
      if (io_lat1)
         op1_wf <= op0_wf;

   if (~pin_clk)
      opwf_clr_l <= opwf_clr;

   if (mc_res | ba_lat2_lhl)
      op2_wf <= 1'b0;
   else
      if (~mrqt_er & sa_s22_hl & op1_wf)
         op2_wf <= 1'b1;

   if (mc_res)
      op3_wf <= 1'b0;
   if (ba_lat2 & ~ba_lat2_lh)
      op3_wf <= op2_wf;
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
assign io_dc[4] =  iop_t[3] | ~iop_t[2] | iop_t[1] | ~iop_t[0] | ~drdy_hl;
assign io_dc[5] =  iop_t[3] & iop_t[1] & iop_t[0];

assign mt_op[0] = (iop_m[3:0] != 4'b0001) & (iop_m[3:0] != 4'b1000);
assign mt_op[1] = (iop_m[3:0] == 4'b0110);
assign mt_op[2] = (~iop_m[3] & ~iop_m[0]) | ~iop_m[2] | ~iop_m[1];
assign mt_op[3] = iop_m[4];

assign dwbh = io_dc[3] |  la[0]; // io_dc[3] - word operation
assign dwbl = io_dc[3] | ~la[0]; //


assign io_lat0 = (plm_f30 | plm_f31 | plm_f32) & plm_lat_h;
assign io_lat1 = (plm_f30 | plm_f31 | plm_f32) & alu_rd & alu_rd_lh;
assign io_lat2 = bus_free & (io_lat2_t0 | sa_sxa);
assign io_res2 = ~io_lat2 & (mc_res | rmsel_clr | din_end | dout_end);

always @(*)
begin
   if (pin_clk) io_lat2_h <= io_lat2;
   if (~pin_clk) io_lat2_hl <= io_lat2_h;

   if (mc_res | io_lat2_hl)
      io_lat2_t0 <= 1'b0;
   else
      if (~bus_free & sa_sxa)
         io_lat2_t0 <= 1'b1;
end

always @(*)
begin
   if (mc_res | io_lat2_h)
      iodc_rdy <= 1'b1;
   else
      if (io_lat1)
         iodc_rdy <= 1'b0;

   if (~pin_clk) iodc_rdy_l <= iodc_rdy;
end
//______________________________________________________________________________
//
// Q-bus timer - transaction and bus arbiter timeouts
//
always @(*)
begin
   if (~pin_clk)
      qt_div_l[0] <= ~qt_div_h[0];
   else
      qt_div_h[0] <= qt_ena & qt_div_l[0];

   if (qt_ena & qt_div_l[0])
      qt_div_l[1] <= ~qt_div_h[1];
   else
      qt_div_h[1] <= qt_ena & qt_div_l[1];

   if (qt_ena & qt_div_l[1])
      qt_div_l[2] <= ~qt_div_h[2];
   else
      qt_div_h[2] <= qt_ena & qt_div_l[2];

   if (qt_ena & qt_div_l[2])
      qt_div_l[3] <= ~qt_div_h[3];
   else
      qt_div_h[3] <= qt_ena & qt_div_l[3];

   if (pin_clk) qt_stb_h <= qt_stb;
   if (~pin_clk) qt_stb_hl <= qt_stb_h;

   if (pin_clk) qt_ena_h <= qt_ena;
   if (~pin_clk) qt_ena_hl <= qt_ena_h;
   if (pin_clk) qt_ena_hlh <= qt_ena_hl;

   qt[0] <= qt_stb & qt_stb_hl & qt_ena_hlh;
   if (~qt_ena)
   begin
      qt[4:1] <= 4'b0000;
      qt_h[4:1] <= 4'b0000;
   end
   else
   begin
      if (qt[0])
         qt_h[1] <= ~qt[1];
      else
         qt[1] <= qt_h[1];

      if (qt[1])
         qt_h[2] <= ~qt[2];
      else
         qt[2] <= qt_h[2];

      if (qt[2])
         qt_h[3] <= ~qt[3];
      else
         qt[3] <= qt_h[3];

      if (qt[3])
         qt_h[4] <= ~qt[4];
      else
         qt[4] <= qt_h[4];
   end
end

assign qt_stb = qt_ena & qt_div_l[3];
assign qt_out = qt_tmr & qt_ena;
assign qt_ena = dout_l | din_l;
always @(*)
begin
   if (pin_clk)
      qt_tmr <= qt[4] & qt[3] & qt[2] & qt[1] & ~qt[0] & pin_et;
end

//______________________________________________________________________________
//
// Q-bus logic
//
assign bus_free = ~rply & dmr_en & ~dmr;
assign oat = io_dc[3] & a[0] & pa_oe;
assign qtout = ir_tout | (qt_out & ~irply_en);
assign qerr = oat_lh | qtout_lh;

always @(*)
begin
   if (pin_clk) dmgo <= dmr & dmr_en & ~rply;

   if (~pin_clk) oat_l <= oat;
   if (pin_clk) oat_lh <= oat_l;

   if (~pin_clk) qerr_l <= qerr;
   if (pin_clk) qerr_lh <= qerr_l;

   if (~pin_clk) qtout_l <= qtout;
   if (pin_clk) qtout_lh <= qtout_l;
end

always @(*)
begin
   if (~pin_clk) pa_oe_l <= pa_oe;
   if (pin_clk) pa_oe_lh <= pa_oe_l;

   if (pin_clk)
      pa_oe_clr <= pa_oe_l & (ssync | rmsel);

   if (~pin_clk)
      pa_oe_t <= ~pa_oe & pa_oe_set & bus_free;

   if (mc_res | pa_oe_clr)
      pa_oe <= 1'b0;
   else
      if (pin_clk & pa_oe_t)
         pa_oe <= 1'b1;


end

assign pa_oe_set = sa_sxa_hl | sa_pfa | ba_req_l;
assign ad_a_nd = ~dout_set & ~bd_oe;
assign ad_oe = (ad_oe_t[0] & pa_oe) | (ad_oe_t[1] & bd_oe);
assign wtbt = (ad_oe_t[2] & bd_oe) | (pa_oe & ~io_dc[1]);

always @(*)
begin
   if (~pa_oe & ~bd_oe)
   begin
      ad_oe_t[0] <= ad_a_nd;
      ad_oe_t[1] <= ~ad_a_nd;
      ad_oe_t[2] <= ~io_dc[3];
   end

   if (mc_res | dio_clr_l)
      bd_oe <= 1'b0;
   else
      if (~pin_clk & bd_oe_t)
         bd_oe <= 1'b1;

   if (pin_clk) bd_oe_t <= ~bd_oe & dout_set & alu_drdy;
end

always @(*)
begin
   if (~pin_clk) ba_req_l <= ba_req;

   if (mc_res | pa_oe)
      ba_req <= 1'b0;
   else
      if (pin_clk & ~bus_free & (sa_pfa | sa_sxa_hl))
         ba_req <= 1'b1;
end

always @(*)
begin
   if (mc_res | sync_clr)
      sync <= 1'b0;
   else
      if (~pin_clk & sync_t)
         sync <= 1'b1;

   if (pin_clk) sync_t <= ~rmsel & pa_oe;
   if (~pin_clk) sync_clr <= dout_end | din_end;
end

assign ct_oe = ~dmgo & ~sack;
assign din_set0 = ~io_s3_wr & io_s4_hl & bus_free & hm_lat & ba_rdy_l;
assign din_set1 = ssync & ~rmsel & pa_oe_l;
assign din_end = ~din & din_lh & ~io_dc[5];
assign dout_end = ~dout & dout_lh;
assign dio_clr = rply_h & ((~ir_stb & ir_stb_lh) | ~a21_ins_l);
assign s3_out = io_s3_wr & bus_free & hm_lat & ba_rdy_l;
assign out_rs = di_rmw | s3_out | (din_set1 & ~io_dc[1]);

always @(*)
begin
   if (mc_res | dio_clr)
      din <= 1'b0;
   else
      if (pin_clk & |din_set_t[2:0])
         din <= 1'b1;

   if (~pin_clk)
   begin
      din_l <= din;
      din_set_t[0] <= ~din & din_set0;
      din_set_t[1] <= ~din & din_set1 & ~io_dc[0];
      din_set_t[2] <= ~din & ~iako_ent & iako_en_l;
   end
   if (pin_clk) din_lh <= din_l;
end

always @(*)
begin
   if (mc_res | dio_clr)
      dout <= 1'b0;
   else
      if (pin_clk & |dout_set_t[1:0])
         dout <= 1'b1;

   if (~pin_clk)
   begin
      dout_l <= dout;
      dout_set_l <= dout_set;
      dout_set_t[0] <= ~dout & dout_set_l & ~io_dc[4];
      dout_set_t[1] <= ~dout & bd_oe & ~dout_l;
   end
   if (pin_clk) dout_lh <= dout_l;

   if (mc_res | dout)
      dout_set <= 1'b0;
   else
      if (pin_clk & out_rs)
         dout_set <= 1'b1;

   if (~pin_clk) dio_clr_l <= dio_clr;
end

assign iako_st = iako_en & ~iako_en_lh;
assign iako_set = ~iako_ent & io_s[1] & bus_free & hm_lat & ba_rdy_l;

always @(*)
begin
   if (mc_res | ~io_s[1])
      iako_en <= 1'b0;
   else
      if (pin_clk & iako_set)
         iako_en <= 1'b1;

   if (~pin_clk) iako <= din & iako_en;
   if (~pin_clk) dvc_stb <= iako_ent & ~ir_stb;

   if (~pin_clk) iako_en_l <= iako_en;
   if (pin_clk) iako_en_lh <= iako_en_l;
   if (~pin_clk) iako_ent <= iako_en_lh;
end

always @(*)
begin
   if (pin_init_in | pf_init | irply_clr)
      irply <= 1'b0;          // phantom internal reply
   else                       // for timed-out prefetch
      if (qt_out)
         irply <= irply_en;

   if (mc_res)
      ir_tout <= 1'b0;
   else
      if (ir_oe)
         ir_tout <= irply;

   if (iako_en)
      irply_en <= 1'b0;
   else
      if (pa_oe)
         irply_en <= irply_en_t;

   if (sa_sxa_hl)
      irply_en_t <= 1'b0;
   else
      if (sa_pfa)
         irply_en_t <= 1'b1;
end

assign arb_ena = rply & (arb_ena_t | a21_ins | ~io_dc[5]);
always @(*)
begin
   if (mc_res | arb_ena_hl)
      arb_ena_t <= 1'b0;
   else
      if (pin_clk & di_rmw)
      arb_ena_t <= 1'b1;

   if (pin_clk) arb_ena_h <= arb_ena;
   if (~pin_clk) arb_ena_hl <= arb_ena_h;
end

assign dmr_en = ~sack & dmr_en_t;
assign dmr_clr = iako_set | din_set0 | s3_out | (pa_oe_set & bus_free);

always @(*)
begin
   if (mc_res | arb_ena | rmsel_clr)
      dmr_en_t <= 1'b1;
   else
      if (dmr_clr_hl)
         dmr_en_t <= 1'b0;

   if (pin_clk) dmr_clr_h <= dmr_clr;
   if (~pin_clk) dmr_clr_hl <= dmr_clr_h;
end

//______________________________________________________________________________
//
// ir_zero     = ir_zf & ~ir_stb;
// sa_stb      = at_stb
// a21_oe      = din
// sr0_oes     = r757x & ~la[2] & la[1]
// rply_dout   = rply & dout_l
// act_lat     = ~alu_stb
// adh_ena     = pa_oe
// plm_sen     = plm_en
// plr_stb     = plr_lat
// air         = ireg_m
// dc_irstb    = dc_stb
// ir_lat      = ir_stb
// di_lat      = ~di_oe
// ipsw[3:0]   = psw[3:0]
// dc_stbs     = dc_stb
// alu_stbt    = alu_stb
// sa_men      = hm_men & ~sr0_m
//
//______________________________________________________________________________
//
endmodule
