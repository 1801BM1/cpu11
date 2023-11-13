//
// Copyright (c) 2021 by 1801BM1@gmail.com
//
// Testbench for the DC303 ROM/PLM test reading
//______________________________________________________________________________
//
`include "../../tbe/config.v"

`define NANO_CMD_NOP    16'b1101010101111111    // no operation
`define NANO_CMD_LD     16'b1101010100011111    // load D-register, no AX toggle, no D->NA
`define NANO_CMD_AXT    16'b1101010100001111    // load D-register, AX toggle, D->NA, D->MC
`define NOT_USED_PLA    6'b000001               // not used PLA address for D->NA jump, < 0x10
`define NOT_USED_CHIP   5'b11111                // not used chip address to clear CS/AXT
`define DUMMY_MI        16'o100000              // some dummy opcode for DC303 only

module tb_303();

integer i;
reg   clk;
reg [15:0] ad;
reg [15:0] mi;
tri1 [15:0] m;
reg   m_oe;
reg   rst;
reg   ez_n;
tri1  cs_n;
reg [3:0] taa;

reg [15:0] mc, mc0;     // read microinstruction
reg [9:0] na, na0;      // read next address

//______________________________________________________________________________
//
dc303 pla
(
   .pin_clk(clk),
   .pin_ad(ad),
   .pin_m(m),
   .pin_rst(rst),
   .pin_ez_n(ez_n),
   .pin_cs_n(cs_n)
);

//_____________________________________________________________________________
//
// Simulation time limit (first breakpoint)
//
initial
begin
   #`SIM_CONFIG_TIME_LIMIT $finish;
end

//_____________________________________________________________________________
//
//               clk = 0  clk = 1
// toggle AXT  - 4'bxx0x, 4'bx000
// data to mc  - 4'bxx10, 4'bx000
// data to na  - 4'bxxx1, 4'bx000
//
// Check whether we can set UNUSED PLA address in the Next Address register
// with direct D-register and with PLA MA output
//
// clk   ad             mi
//
// H0:   NOT_USED_PLA   NANO_CMD_LD    - load D-register with non-used address
// L0:   NOT_USED_PLA   jmp nochip:0   - jump to invalid chip, reset CS and AXT
// H1:   NOT_USED_PLA   NANO_CMD_NOP   - reset CS and AXT
// L1:   NOT_USED_PLA   jmp chip:addr  - jump to test address in valid chip
// H2:   NOT_USED_PLA   NANO_CMD_AXT   - apply D-register to MA output, no AXT toggle
// L2:   NOT_USED_PLA   jcond addr     - now NOT_USED_PLA expected in the NA register
// H3:   NOT_USED_PLA   NANO_CMD_NOP   - allow read Next Address at NOT_USED_PLA
// L3:   NOT_USED_PLA   DUMMY_MI       - propagate read address to see on next read
// H3:   NOT_USED_PLA   NANO_CMD_NOP
// L4:   NOT_USED_PLA   readout
//
// Returns na, if the value is 0x1FF - the tested address can be used
// to set arbitrary target address to read
//
task read_tst
(
   input [4:0] chip,
   input [3:0] addr
);
begin
   clk  = 1;
   rst  = 0;
   ad   = `NOT_USED_PLA;
   ez_n = 0;
   mi   = `NANO_CMD_LD;
   m_oe = 1;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   mi  = {5'b00000, `NOT_USED_CHIP, 6'b000000};

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   mi  = `NANO_CMD_NOP;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   mi = {5'b00000, chip, 2'b11, addr};

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   mi  = `NANO_CMD_AXT;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   mi  = {5'b00001, 7'b0000011, addr};

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   mi  = `NANO_CMD_NOP;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   mi  = `DUMMY_MI;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   ez_n = 1;
   mi  = `NANO_CMD_NOP;
   mi[10] = 0;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   m_oe = 0;

#`SIM_CONFIG_CLOCK_HPERIOD;
   na = m[9:0];
end
endtask

//_____________________________________________________________________________
//
task jump_all                 // do preparation cycle to read
(                             // address or microcode for PLA
   input [4:0] chip,          // with any addresses
   input [9:0] addr,          // uses the single direct
   input [15:0] data,         //
   input na                   //
);
begin
   clk  = 1;                  // just ensure high clock phase on entry
   rst  = 0;                  // make sure there is no reset
   ad   = `NOT_USED_PLA;      //
   ez_n = 0;                  // disable microinstruction bus output on low clock
   mi   = `NANO_CMD_LD;       // load DI, no AXT toggle
   m_oe = 1;

#`SIM_CONFIG_CLOCK_HPERIOD;   // jump to non-existing chip
   clk = 0;                   // to reset AXT and CS
   mi  = {5'b00000, `NOT_USED_CHIP, 6'b000000};

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   mi  = `NANO_CMD_NOP;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   mi = {5'b00000, chip, 2'b11, taa};
   mi[5] = ~addr[9];
   mi[4] = 1;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   mi  = `NANO_CMD_AXT;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   mi  = `DUMMY_MI;
   mi[5] = 1;
   mi[4] = 1;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   ad = {6'o00, addr};
   mi  = `NANO_CMD_AXT;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   mi  = `DUMMY_MI;

   if (na)
   begin
#`SIM_CONFIG_CLOCK_HPERIOD;
      clk = 1;
      ad  = data;
      mi  = `NANO_CMD_LD;

#`SIM_CONFIG_CLOCK_HPERIOD;
      clk = 0;
      mi  = `DUMMY_MI;
   end

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   ez_n = 1;
   ad = data;
   mi  = `NANO_CMD_LD;
   mi[10] = ~na;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   m_oe = 0;

#`SIM_CONFIG_CLOCK_HPERIOD;
end
endtask

//_____________________________________________________________________________
//
task jump_a64                 // do preparation cycle to read
(                             // address or microcode for PLA
   input [4:0] chip,          // with addresses < 64
   input [9:0] addr,          // uses the single direct
   input [15:0] data,         // chip jump microinstruction
   input na
);
begin
   clk  = 1;                  // just ensure high clock phase on entry
   rst  = 0;                  // make sure there is no reset
   ad   = data;               // assign desired data to be assigned
   ez_n = 0;                  // disable microinstruction bus output on low clock
   mi   = `NANO_CMD_LD;       // load DI, no AXT toggle
   m_oe = 1;

#`SIM_CONFIG_CLOCK_HPERIOD;   // jump to non-existing chip
   clk = 0;                   // to reset AXT and CS
   mi  = {5'b00000, `NOT_USED_CHIP, 6'b000000};


#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   mi  = `NANO_CMD_NOP;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;                   // jump to target chip
   mi = {5'b00000, chip, addr[5:0]};

   if (na)
   begin
#`SIM_CONFIG_CLOCK_HPERIOD;
      clk = 1;
      mi  = `NANO_CMD_NOP;

#`SIM_CONFIG_CLOCK_HPERIOD;
      clk = 0;
      mi  = `DUMMY_MI;
   end
#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
   ez_n = 1;
   mi  = `NANO_CMD_NOP;
   mi[10] = ~na;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;
   m_oe = 0;

#`SIM_CONFIG_CLOCK_HPERIOD;
end
endtask

//_____________________________________________________________________________
//
// read_mc64 and read_na64 read the microcode and next address for the
// input address range [0-63] using direct jmp instruction, this bypasses
// clr_na[3:0] for special addresses. read_mc/read_na uses direct D-register
// promotion to the Next Address register and clr_na[3:0] affect its
// results. This can be used to detect special addresses in the PLAs.
//
task read_mc64
(
   input [4:0] chip,
   input [9:0] addr,
   input [15:0] data
);
begin
   if (addr < 64)
      jump_a64(chip, addr, data, 0);
   else
      jump_all(chip, addr, data, 0);

   mc = m[15:0];
end
endtask

task read_na64
(
   input [4:0] chip,
   input [9:0] addr,
   input [15:0] data
);
begin
   if (addr < 64)
      jump_a64(chip, addr, data, 1);
   else
      jump_all(chip, addr, data, 1);
   na = m[9:0];
end
endtask

task read_mc
(
   input [4:0] chip,
   input [9:0] addr,
   input [15:0] data
);
begin
   jump_all(chip, addr, data, 0);
   mc = m[15:0];
end
endtask

task read_na
(
   input [4:0] chip,
   input [9:0] addr,
   input [15:0] data
);
begin
   jump_all(chip, addr, data, 1);
   na = m[9:0];
end
endtask

//_____________________________________________________________________________
//
assign m = m_oe ? mi : 16'hZZZZ;

initial
begin
   clk = 0;
   rst = 1;
   ez_n = 0;
   m_oe = 0;
   mi = 16'h0000;
   ad = 16'h0000;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;

   rst = 0;
   ez_n = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
   //
   // Look for the test address that can be used to apply
   // next address directly to the matrix output. The address
   // field read from the test address must be 0x1FF (all ones,
   // because D-register will be AND-ed with this value)
   // and must be independent from data in D-register
   //
   taa = 4'b0000;
   for (i=0; i<16; i = i + 1)
   begin
      read_tst(0, i);
      if ((na == 10'h1FF) & (taa[3:0] == 4'b0000))
      begin
         taa = i;
         i = 16;
      end
   end
   $display("Test address: %03X", taa);
   if (taa == 4'b0000)
      $finish;

   for (i='h80; i<'h200; i = i + 1)
   begin
         read_mc(0, i, 0);    // we can't read mc/na in the same cycle
         read_na(0, i, 0);    // read mc might affect next na (jump/jcond)
         $display("%03X: %03X%04X;", i, na, mc);
   end
   $finish;
end

//_____________________________________________________________________________
//
endmodule
