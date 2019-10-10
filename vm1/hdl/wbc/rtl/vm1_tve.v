//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// 1801VM1 timer module (rudimentary, VE1-style)
//______________________________________________________________________________
//
module vm1_timer
(
   input          tve_clk,       // main system clock
   input          tve_ena,       // clock enable
   input          tve_reset,     // timer reset
   input          tve_dclo,      // timer powerup reset
   input          tve_sp,        // external timer clock
                                 //
   input  [15:0]  tve_din,       // input data
   output [15:0]  tve_dout,      // output data
                                 //
   input          tve_csr_oe,    // read timer control
   input          tve_cnt_oe,    // read timer counter
   input          tve_lim_oe,    // read timer limit
   input          tve_csr_wr,    // write timer control
   input          tve_lim_wr,    // write timer limit
                                 //
   output         tve_irq,       // interrupt request
   input          tve_ack        // interrupt acknowledgement
);

reg   [15:0]      tve_limit;     // timer reload & capture register
reg   [15:0]      tve_count;     // timer counter register
reg   [7:0]       tve_csr;       // timer control register
reg   [6:0]       tve_pre;       // clock prescaler counter
reg   [5:0]       tve_div;       // timer clock divisor
reg   [2:0]       tve_edge;      // external falling edge detector
reg               tve_tclk;      // selected timer clock
reg               tve_tclk4;     // prescaler /4 output
wire              tve_tclk128;   // prescaler /128 output
reg   [1:0]       tve_intrq;     // hidden interrupt request
                                 //
reg               tve_zprev;     // zero value edge detector
wire              tve_spclk;     // external event on SP
wire              tve_zero;      // timer counter zero value
wire              tve_load;      // timer counter load
wire              tve_back;      // timer capture load

//
// Reading the timer registers content to the shared bus
//
assign tve_dout = (tve_csr_oe ? {8'b11111111, tve_csr} : 16'o000000)
                | (tve_cnt_oe ? tve_count : 16'o000000)
                | (tve_lim_oe ? tve_limit : 16'o000000);

//
// Hidden clock prescaler, generates the /4 and /128 frequencies
//
assign tve_tclk128 = (tve_pre[6:0] == 7'b1111111);
assign tve_spclk   = tve_edge[1] & ~tve_edge[2];

//
// Actually we do not care about power-up values in these registers, so
// we can use the initial block to setup ones for definitive simulation,
// the synthesis is just the bonus option (if any)
//
initial
begin
   //
   // Power-up timer counter and preload settings, no in original 1801VM1,
   // added here to provide the comfortable simulation. Note. the control
   // timer register reset is implemented in the original chip though
   //
   tve_count   = 16'o000000;
   tve_limit   = 16'o000000;
   //
   // Power-up prescaler reset, no in original 1801VM1 (undefined values)
   // added here to provide the comfortable simulation. Zero is preferrable
   // due to simpler synthesis results
   //
   tve_pre     = 7'b0000000;
   tve_div     = 6'b000000;
end

always @(posedge tve_clk)
begin
   if (tve_ena)
   begin
      tve_pre     <= tve_pre + 7'b0000001;
      //
      // Documented divisor 1/4, 1/16, 1/64
      //
      if (tve_tclk128)
         tve_div     <= tve_div + 6'b000001;
   end
end

always @(posedge tve_clk or posedge tve_reset)
begin
   if (tve_reset)
   begin
      //
      // Asynchronous prescaler reset, no in original 1801VM1,
      // added here to provide the comfortable simulation
      //
      tve_tclk4   <= 1'b0;
      tve_tclk    <= 1'b0;
      tve_edge    <= 3'b000;
      tve_zprev   <= 1'b1;
   end
   else
   begin
      if (tve_ena)
      begin
         tve_tclk4   <= (tve_pre[1:0] == 2'b11);
         //
         // Timer clock selector
         //
         tve_tclk    <= ~tve_csr[0] & ~tve_csr[6] & ~tve_csr[5] & tve_tclk128
                      | ~tve_csr[0] &  tve_csr[6] & ~tve_csr[5] & tve_tclk128 & (tve_div[1:0] == 2'b11)
                      | ~tve_csr[0] & ~tve_csr[6] &  tve_csr[5] & tve_tclk128 & (tve_div[3:0] == 4'b1111)
                      | ~tve_csr[0] &  tve_csr[6] &  tve_csr[5] & tve_tclk128 & (tve_div[5:0] == 6'b111111)
                      |  tve_csr[0] &  tve_spclk & (tve_pre[1:0] == 2'b11);
         //
         // Falling edge detector (raising for the inverted input tve_sp)
         //
         if (tve_tclk4)
         begin
            //
            // Input metastability eliminator and synchronizer
            //
            tve_edge[0] <= tve_sp;
            tve_edge[1] <= tve_edge[0];
            tve_edge[2] <= tve_edge[1];
            //
            // Counter zero flag edge detector
            //
            tve_zprev <= tve_zero;
         end
      end
   end
end

assign tve_zero = (tve_count == 16'o000000) & ~tve_csr[1];
assign tve_back = tve_csr[4] & tve_csr[1] & tve_spclk & tve_tclk4;
assign tve_load = ~tve_zprev & tve_zero & tve_tclk4 & ~tve_csr[1];
assign tve_irq  = tve_intrq[0];

always @(posedge tve_clk or posedge tve_dclo)
begin
   if (tve_dclo)
      tve_intrq   <= 2'b00;
   else
   begin
      if (tve_ack)
         //
         // New timer interrupt request raising while
         // acknowledgement can be missed
         //
         tve_intrq[0] <= 1'b0;
      else
         if (tve_ena)
         begin
            //
            // Interrupt flags
            //
            if (tve_csr[2] & (tve_zero | tve_back))
               tve_intrq[0] <= 1'b1;
         end

      if (~(tve_csr[2] & (tve_zero | tve_back)))
         tve_intrq[1] <= tve_intrq[0];
   end
end

//
// Timer control register
//
always @(posedge tve_clk or posedge tve_reset)
begin
   if (tve_reset)
   begin
      //
      // The control timer register reset as implemented in the original chip
      //
      tve_csr <= 8'b00000000;
   end
   else
   begin
      //
      // Timer control register
      //
      // csr[0]   - selects external clock source
      // csr[1]   - selects capture mode
      // csr[2]   - enables interrupt request
      // csr[3]   - selects one-shot mode
      // csr[4]   - timer count enable
      // csr[5]   - 1/16 divider enable
      // csr[6]   - 1/4 divider enable
      // csr[7]   - interrupt overflow flag
      //
      if (tve_csr_wr)
         //
         // The prioritized CSR write from bus
         // Clocked every system bus cycle
         //
         tve_csr <= tve_din[7:0];
      else
         if (tve_ena)
         begin
            if (tve_zero & tve_csr[3])
               //
               // Reset the RUN bit in one-shot mode
               //
               tve_csr[4] <= 1'b0;

            if (tve_intrq[1] & tve_csr[2] & (tve_zero | tve_back))
               //
               // Set the interrupt overflow flag if enabled
               //
               tve_csr[7] <= 1'b1;
         end
   end
end

//
// Timer counter and preload/capture registers
//
always @(posedge tve_clk)
begin
   if (tve_csr_wr)
      //
      // Counter is written unconditionally at every CSR bus write
      //
      tve_count <= tve_limit;

   if (tve_lim_wr)
      //
      // The prioritized register write from bus
      // Clocked every system bus cycle
      //
      tve_limit <= tve_din;

   if (tve_ena)
   begin
      //
      // Timer preload and capture value register
      //
      if (~tve_lim_wr & tve_back)
         //
         // Capture the current counter value
         //
         tve_limit <= tve_count;

      //
      // Decrementing counter register
      //
      if (~tve_csr_wr)
      begin
         if (tve_load)
            //
            // Counter is being reloaded
            //
            tve_count <= tve_limit;
         else
            if (tve_tclk & tve_csr[4])
               //
               // Count selected clock events if enabled
               //
               tve_count <= tve_count - 16'o000001;
      end
   end
end
endmodule
