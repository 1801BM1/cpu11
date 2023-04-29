//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// System clock and reset controller
//
// - External button support
// - Power and Warm reset support
// - Long button click causes Power Reset event
// - Short button click causes Warm Reset event
// - PLL lock failure causes Power Reset event
// - DCLO and ACLO generating for DEC processors
// - 1 us and 1 ms strobes generating
//______________________________________________________________________________
//
module wbc_rst #(parameter

   OSCCLK=50000000,           // oscillator clock frequency in Hz
   REFCLK=100000000,          // system clock frequency in Hz
   PWR_WIDTH=7,               // minimal Power Reset width in system ticks
   DCLO_WIDTH=15,             // minimal DCLO width in system ticks
   ACLO_DELAY=7,              // ACLO after DCLO delay in system ticks
   LONGKEY=1000,              // button long press, in milliseconds
   DEBOUNCE=10,               // button debounce interval in milliseconds
   SYSTICK=20000,             // system timer interrupt ticks in us
   SLOW_DIV=20                // slow mode divisor
)
(
   input       osc_clk,       // oscillator clock
   input       sys_clk,       // system clock
   input       pll_lock,      // PLL lock status
   input       button,        // external reset button
   input       sys_ready,     // external system ready
                              //
   output reg  pwr_rst,       // power reset event
   output reg  sys_rst,       // system reset event
   output reg  sys_dclo,      // DCLO output
   output reg  sys_aclo,      // ACLO output
   output reg  sys_us,        // 1 microsecond clock enable strobe
   output reg  sys_ms,        // 1 millisecond clock enable strobe
   output reg  sys_slow,      // slow clock enable strobe
   output reg  sys_irq        // system timer interrupt
);
localparam US_COUNTER_WIDTH = log2(REFCLK/1000000);
localparam MS_COUNTER_WIDTH = log2(1000);
localparam ST_COUNTER_WIDTH = log2(SYSTICK);
localparam DB_COUNTER_WIDTH = log2(DEBOUNCE);
localparam KL_COUNTER_WIDTH = log2(LONGKEY);
localparam OS_COUNTER_WIDTH = log2(OSCCLK/1000);
localparam SL_COUNTER_WIDTH = log2(SLOW_DIV);

localparam PW_COUNTER_WIDTH = log2(PWR_WIDTH);
localparam DC_COUNTER_WIDTH = log2(DCLO_WIDTH);
localparam AC_COUNTER_WIDTH = log2(ACLO_DELAY);

reg   [DB_COUNTER_WIDTH-1:0] count_db;
reg   [KL_COUNTER_WIDTH-1:0] count_kl;
reg   [OS_COUNTER_WIDTH-1:0] count_os;

reg   [SL_COUNTER_WIDTH-1:0] count_sl;
reg   [US_COUNTER_WIDTH-1:0] count_us;
reg   [MS_COUNTER_WIDTH-1:0] count_ms;
reg   [ST_COUNTER_WIDTH-1:0] count_st;
reg   [PW_COUNTER_WIDTH-1:0] count_pw;
reg   [DC_COUNTER_WIDTH-1:0] count_dc;
reg   [AC_COUNTER_WIDTH-1:0] count_ac;

reg   ena_us;
reg   osc_ms;
reg   pll_reg;
reg   but_reg;
reg   key_down;
reg   key_long;

reg   [1:0] key_syn;
reg   pwr_event;
wire  key_event;

//______________________________________________________________________________
//
// Oscillator clock domain - button and PLL failure detectors
//
always @(posedge osc_clk)
begin
   if (count_os < ((OSCCLK/1000)-1))
   begin
      count_os <= count_os + 1'b1;
      osc_ms <= 1'b0;
   end
   else
   begin
      count_os <= 0;
      osc_ms <= 1'b1;
   end
end
//
// External button debouncer
//
always @(posedge osc_clk)
begin
   if (~but_reg | ~pll_reg)
   begin
      count_db <= 0;
      key_down <= 1'b1;
   end
   else
      if (osc_ms)
      begin
         if (count_db < (DEBOUNCE-1))
            count_db <= count_db + 1'b1;
         else
            key_down <= 1'b0;
      end
   pll_reg <= pll_lock;
   but_reg <= button;
   pwr_event <= ~pll_reg | key_long;
end
//
// External button long press detector
//
always @(posedge osc_clk)
begin
   if (~key_down)
   begin
      count_kl <= 0;
      key_long <= 1'b0;
   end
   else
      if (osc_ms)
      begin
         if (count_kl < (LONGKEY-1))
            count_kl <= count_kl + 1'b1;
         else
            key_long <= 1'b1;
      end
end
//______________________________________________________________________________
//
// System clock domain metastability synchronizers
//
always @(posedge sys_clk)
begin
   key_syn[0] <= key_down | key_long;
   key_syn[1] <= key_syn[0];
end
assign key_event = key_syn[1];

always @(posedge sys_clk or posedge pwr_event)
begin
   if (pwr_event)
   begin
      count_pw <= 0;
      count_dc <= 0;
      count_ac <= 0;

      pwr_rst  <= 1'b1;
      sys_rst  <= 1'b1;
      sys_dclo <= 1'b1;
      sys_aclo <= 1'b1;
   end
   else
   begin
      //
      // Power Reset deassertion delay after Power Event
      //
      if (count_pw < (PWR_WIDTH-1))
         count_pw <= count_pw + 1'b1;
      else
         pwr_rst <= 1'b0;
      //
      // Assert System Reset if button is pressed
      //
      if (key_event)
      begin
         count_dc <= 0;
         count_ac <= 0;
         sys_rst  <= 1'b1;
         sys_dclo <= 1'b1;
         sys_aclo <= 1'b1;
      end
      //
      // System Reset waits for System Ready
      // Some system components may require time to complete
      // its internal initialization, for example, memory
      // controller may initialize the SDRAM chips.
      //
      if (~pwr_rst & sys_ready & ~key_event)
         sys_rst <= 1'b0;
      //
      // DCLO and ACLO synchronous deassertions
      //
      if (~pwr_rst & ~sys_rst & ~key_event)
      begin
         //
         // Count the DCLO pulse
         //
         if (count_dc < (DCLO_WIDTH-1))
            count_dc <= count_dc + 1'b1;
         else
            sys_dclo <= 1'b0;
         //
         // After DCLO deassertion start ACLO counter
         //
         if (~sys_dclo)
            if (count_ac < (ACLO_DELAY-1))
               count_ac <= count_ac + 1'b1;
            else
               sys_aclo <= 1'b0;
      end
   end
end
//______________________________________________________________________________
//
// Timer IRQ, and us/ms system clock enable strobes
//
always @(posedge sys_clk)
begin
   if (sys_rst)
   begin
      ena_us   <= 1'b0;
      sys_us   <= 1'b0;
      sys_ms   <= 1'b0;
      sys_irq  <= 1'b0;
      sys_slow <= 1'b0;

      count_sl <= 0;
      count_us <= 0;
      count_ms <= 0;
      count_st <= 0;
      end
   else
   begin
      if (count_sl == (SLOW_DIV-1))
      begin
         sys_slow <= 1'b1;
         count_sl <= 0;
      end
      else
      begin
         sys_slow <= 1'b0;
         count_sl <= count_sl + 1'b1;
      end
      //
      // One microsecond interval counter
      //
      if (count_us == ((REFCLK/1000000)-1))
      begin
         ena_us <= 1'b1;
         count_us <= 0;
      end
      else
      begin
         ena_us <= 1'b0;
         count_us <= count_us + 1'b1;
      end
      sys_us <= ena_us;
      //
      // One millisecond interval counter
      //
      if (ena_us)
      begin
         if (count_ms == (1000-1))
         begin
            sys_ms <= 1'b1;
            count_ms <= 0;
         end
         else
            count_ms <= count_ms + 1'b1;
         //
         // System Timer interrupt
         //
         if (count_st == (SYSTICK-1))
         begin
            sys_irq <= 1'b0;
            count_st <= 0;
         end
         else
         begin
            count_st <= count_st + 1'b1;
            if (count_st == (SYSTICK/2-1))
                  sys_irq <= 1'b1;
         end
      end
      else
         sys_ms <= 1'b0;
   end
end

function integer log2(input integer value);
   begin
      for (log2=0; value>0; log2=log2+1)
         value = value >> 1;
   end
endfunction
endmodule

//______________________________________________________________________________
//
module wbc_button #(parameter

   DEBOUNCE=10             // button debounce interval in milliseconds
)
(
   input       clk,        // system clock
   input       rst,        // system reset
   input       but_n,      // button input
   input       ena_ms,     // millisecond strobe
   output reg  out,        // debounced output
   output reg  out_rise,   // press event
   output reg  out_fall    // depress event
);
localparam DB_COUNTER_WIDTH = log2(DEBOUNCE);

reg [DB_COUNTER_WIDTH-1:0] cnt;
reg [1:0] val;

always @(posedge clk)
begin
   if (rst)
   begin
      cnt <= 0;
      val[1:0] <= {~but_n, ~but_n};
      out <= but_n;
      out_rise <= 1'b0;
      out_fall <= 1'b0;
   end
   else
   begin
      if (val[0] ^ val[1])
      begin
         cnt <= 0;
         out_rise <= 1'b0;
         out_fall <= 1'b0;
      end
      else
         if (cnt >= (DEBOUNCE-1))
         begin
            out_rise <= ~out & val[1];
            out_fall <= out & ~val[1];
            out <= val[1];
         end
         else
         begin
            if (ena_ms)
               cnt <= cnt + 1'b1;
         end
      val[0] <= ~but_n;
      val[1] <= val[0];
   end
end

function integer log2(input integer value);
   begin
      for (log2=0; value>0; log2=log2+1)
         value = value >> 1;
   end
endfunction
endmodule

//______________________________________________________________________________
//
module wbc_toggle #(parameter

   DEBOUNCE=10             // button debounce interval in milliseconds
)
(
   input       clk,        // system clock
   input       rst,        // system reset
   input       but_n,      // button input
   input       ena_ms,     // millisecond strobe
   output reg  out         // debounced output
);
wire rise, fall, bout;

defparam button.DEBOUNCE = DEBOUNCE;
wbc_button button(
   .clk(clk),
   .rst(rst),
   .but_n(but_n),
   .ena_ms(ena_ms),
   .out(bout),
   .out_rise(rise),
   .out_fall(fall)
);

always @(posedge clk)
begin
   if (rst)
      out <= 1'b0;
   else
      if (rise)
         out <= ~out;
end
endmodule
