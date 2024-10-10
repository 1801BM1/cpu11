//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Testbench for the QA7 board with various Wishbone CPUs
//______________________________________________________________________________
//

module qa7_tb();

reg         clk50;
reg [4:0]   button;
reg [0:0]   switch;
wire [7:0]  hex;
wire [2:0]  hex_sel;
wire [5:0]  led;
wire	    reset_n;
                           //
wire        uart_txd;      // UART transmitter
reg         uart_rxd;      // UART receiver
wire        uart_cts;      // UART clear to send
reg         uart_rts;      // UART request to send

wire [1:0] gpio1;       // GPIO Connection 1 Data Bus

//_____________________________________________________________________________
//
// defparam dut.cpu.reset.DCLO_WIDTH = 3; // affects count_os counter size
defparam dut.cpu.reset.DCLO_WIDTH = 2;
initial
begin
//
// Let PLL to lock incoming clock and short debouncer start time
//
// #100000
#6000
   button = 5'b00111;
   dut.cpu.reset.count_db = `CONFIG_RESET_BUTTON_DEBOUNCE_MS-1;
   dut.cpu.reset.key_down = 0;
#6004;
   // dut.cpu.reset.key_down = 1;
   // dut.cpu.reset.count_os = dut.cpu.reset.DCLO_WIDTH - 1;
   // dut.cpu.reset.sys_dclo = 0;
//#20010
//   dut.cpu.reset.sys_aclo = 0;
// uart_send("T");
// uart_send("E");
// uart_send("S");
// uart_send("T");
end

initial
begin
   button = 5'b00111;
   clk50 = 0;
   forever
      begin
         #10 clk50 = 0;
         #10 clk50 = 1;
      end
end

initial
begin
   // switch = 10'b0000000000;
   switch = 1'b0;
   uart_rxd = 1'b1;
   uart_rts = 1'b0;
end

initial
begin
   #`CONFIG_SIM_TIME_LIMIT
`ifdef CONFIG_CPU_VM1
  $display("VIM1 Sim finished with PC @ %06O", dut.cpu.cpu.vreg_ff.gpr[7][15:0]);
`endif
   $finish;
end

`ifdef CONFIG_HAS_LCD
always @(posedge lcd_en)
begin
#2
   $display("tty: %03O (%c)", lcd_data, (lcd_data > 8'o037) ? lcd_data : 8'o52);
end

always @(posedge lcd_rs)
begin
   $display("Stop on debug request");
   $finish;
end
`endif


assign reset_n = 1'b1;

qa7_top dut(
   .qa7_clock_50(clk50),
   .qa7_reset_n(reset_n),
   .qa7_button(button),
   .qa7_hex(hex),
   .qa7_hsel(hex_sel),
   .qa7_led(led),

   .qa7_uart_txd(uart_txd),
   .qa7_uart_rxd(uart_rxd),
/*
   .qa7_dram_dq(dram_dq),
   .qa7_dram_addr(dram_addr),
   .qa7_dram_ldqm(dram_ldqm),
   .qa7_dram_udqm(dram_udqm),
   .qa7_dram_we_n(dram_we_n),
   .qa7_dram_cas_n(dram_cas_n),
   .qa7_dram_ras_n(dram_ras_n),
   .qa7_dram_cs_n(dram_cs_n),
   .qa7_dram_ba(dram_ba),
   .qa7_dram_clk(dram_clk),
   .qa7_dram_cke(dram_cke),
*/
   .qa7_gpio1(gpio1)
);

//_____________________________________________________________________________
//
`define  UBIT (1000000000 / `CONFIG_BAUD_RATE)

task uart_send
(
   input [7:0] data
);
begin
   uart_rxd = 1'b1;
   #`UBIT uart_rxd = 1'b0;
   #`UBIT uart_rxd = data[0];
   #`UBIT uart_rxd = data[1];
   #`UBIT uart_rxd = data[2];
   #`UBIT uart_rxd = data[3];
   #`UBIT uart_rxd = data[4];
   #`UBIT uart_rxd = data[5];
   #`UBIT uart_rxd = data[6];
   #`UBIT uart_rxd = data[7];
   #`UBIT uart_rxd = 1'b1;
   #`UBIT uart_rxd = 1'b1;
end
endtask

//_____________________________________________________________________________
//
// Stop simulation on regular (non debug) HALT
//
`ifdef CONFIG_CPU_VM3
initial
begin
@ (negedge dut.cpu.vm_dclo_in);
   forever
   begin
      @ (posedge dut.cpu.vm_hltm);
      if (~dut.cpu.halt_en)
      begin
         $display("HALT @ %06O", dut.cpu.cpu.pc);
         $finish;
      end
   end
end
`endif

`ifdef __ICARUS__
initial begin
  $dumpfile ("wave.vcd");
  $dumpvars (0, dut.cpu.reset);
  #1;
end
`endif
//_____________________________________________________________________________
//
PREDEF pd();
endmodule

`ifdef __ICARUS__
       `define _SIM_PLL_
`elsif  XILINX_SIMULATOR
       `define _SIM_PLL_
`elsif XILINX_ISIM
       `define _SIM_PLL_
`endif

`ifdef _SIM_PLL_

module xsimpll
 (// Clock in ports
  // Clock out ports
  output        c0,
  output        c1,
  // Status and control signals
  output reg    locked,
  input         inclk0
 );

 // assign locked = 1'b1;
 assign	c0 = inclk0;
 assign	c1 = !inclk0;

 initial begin
   #0;
   locked = 0;
   #100;
   locked = 1;
 end
endmodule
`endif

//----
//
module PREDEF;

   initial begin
`ifdef VCS
      $display("Synopsis VCS");
`endif
`ifdef INCA
      $display("Cadence NC-Verilog");
`endif
`ifdef MODEL_TECH
      $display("Mentor Graphics ModelSIM/Questa");
`endif
`ifdef XILINX_ISIM
      $display("Xilinx ISE Simulator");
`endif
`ifdef XILINX_SIMULATOR
      $display("Xilinx Vivado Simulator");
`endif
`ifdef __ICARUS__
      $display("Icarus Verilog <http://iverilog.icarus.com>");
`endif
`ifdef VERILATOR
      $display("Verilator <https://www.veripool.org/wiki/verilator>");
`endif
`ifdef Veritak
      $display("Veritak <http://www.sugawara-systems.com>");
`endif
`ifdef YOSYS
      $display("YOSYS <https://www.yosyshq.com/>");
`endif
`ifdef XILINX
      $display("Xilinx ISE");
`endif
`ifdef XILINX_DSP
      $display("Xilinx DSP");
`endif
`ifdef XILINX_EDK
      $display("Xilinx EDK");
`endif
`ifdef XILINX_PLANHEAD
      $display("Xilinx Planhead");
`endif
`ifdef ALTERA_RESERVED_QIS
      $display("Quartus");
`endif

`ifdef CONFIG_WBC_PLL
  `ifndef __ICARUS__
    $display("I'm using custom PLL %s", `"`CONFIG_WBC_PLL`");
  `endif
`endif
   end // initial begin
endmodule
