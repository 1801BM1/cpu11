//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Universal Serial Asynchronous Receiver-Transmitter (065-style)
//
// - Wishbone complatible
// - Configurable with external signals
// - Phase accumulator generates arbitrary baud rate without extra PLL
// - Supports vectored interruts in cooperation with wbc_vic
//______________________________________________________________________________
//
module wbc_uart #(parameter REFCLK=100000000)
(
   input                wb_clk_i,   // system clock
   input                wb_rst_i,   // peripheral reset
                                    //
   input  [2:0]         wb_adr_i,   //
   input  [15:0]        wb_dat_i,   //
   output reg [15:0]    wb_dat_o,   //
   input                wb_cyc_i,   //
   input                wb_we_i,    //
   input                wb_stb_i,   //
   output reg           wb_ack_o,   //
                                    //
   output               tx_dat_o,   // output serial data (txd))
   input                tx_cts_i,   // enable transmitter (rts)
   input                rx_dat_i,   // input serial data (rxd)
   output               rx_dtr_o,   // receiver ready (cts)
                                    //
   output reg           tx_irq_o,   // tx interrupt request
   input                tx_ack_i,   //
   output reg           rx_irq_o,   // rx interrupt request
   input                rx_ack_i,   //
                                    //
   input [15:0]         cfg_bdiv,   // baudrate divisor: (921600/baud)-1
   input [1:0]          cfg_nbit,   // word length: 00-5, 01-6, 10-7, 11-8 bit
   input                cfg_nstp,   // tx stop bits: 0 - 1 stop, 1 - 2 stop
   input                cfg_pena,   // parity control enable
   input                cfg_podd    // odd parity (complete to odd ones)
);

wire  [63:0]   add_arg;
reg   [16:0]   add_reg;
reg   [15:0]   baud_div;
reg            baud_x16;
wire           baud_ref;
reg   [1:0]    tx_cts_reg;
reg   [1:0]    rx_dat_reg;

reg   [1:0]    tx_irq_edge, rx_irq_edge;
wire           rx_csr_wstb, rx_rbr_rstb;
wire           tx_csr_wstb, tx_thr_wstb;

wire           tx_par;
wire  [15:0]   tx_csr;
reg   [7:0]    tx_thr;
reg   [9:0]    tx_shr;
reg   [7:0]    tx_bcnt;
reg            tx_busy;
reg            tx_csr_ie, tx_csr_flg, tx_csr_tst, tx_csr_brk;

wire           rx_dat;
wire  [15:0]   rx_csr;
reg   [7:0]    rx_rbr;
reg   [8:0]    rx_shr;
reg   [7:0]    rx_bcnt;
reg            rx_csr_ie, rx_csr_flg, rx_csr_perr, rx_csr_ovf, rx_csr_brk;
wire           rx_load, rx_stb;
reg            rx_frame, rx_start, rx_par;

//______________________________________________________________________________
//
// Caution note: the arithmetic expressions should be calculated in 64-bit width
//
assign   add_arg = (64'h0000000000010000 * 64'd921600 * 64'd16)/REFCLK;
assign   baud_ref = add_reg[16];
//
// Phase accumulator to generate 921600 * 16 Hz reference clock strobe
//
always @(posedge wb_clk_i or posedge wb_rst_i)
begin
   if (wb_rst_i)
      add_reg <= 17'h00000;
   else
   begin
      add_reg <= {1'b0, add_reg[15:0]} + add_arg[16:0];
   end
end
//
// Baud rate x16 generator
//
always @(posedge wb_clk_i or posedge wb_rst_i)
begin
   if (wb_rst_i)
   begin
      baud_div <= 16'h0000;
      baud_x16 <= 1'b0;
   end
   else
   begin
      if (baud_ref)
         if (baud_div == cfg_bdiv)
            baud_div <= 16'h0000;
         else
            baud_div <= baud_div + 16'h0001;

      baud_x16 <= baud_ref & (baud_div == 16'h0000);
   end

end

//______________________________________________________________________________
//
assign tx_csr = 16'o000000 | (tx_csr_flg<<7) | (tx_csr_ie<<6) | (tx_csr_brk<<0) | (tx_csr_tst<<2) ;
assign rx_csr = 16'o000000 | (rx_csr_flg<<7) | (rx_csr_ie<<6) | (rx_csr_brk<<0) | (rx_csr_perr<<15) | (rx_csr_ovf<<12);

assign rx_csr_wstb = wb_cyc_i & wb_stb_i &  wb_we_i &  wb_ack_o & (wb_adr_i[2:1] == 2'b00);
assign rx_rbr_rstb = wb_cyc_i & wb_stb_i & ~wb_we_i & ~wb_ack_o & (wb_adr_i[2:1] == 2'b01);
assign tx_csr_wstb = wb_cyc_i & wb_stb_i &  wb_we_i &  wb_ack_o & (wb_adr_i[2:1] == 2'b10);
assign tx_thr_wstb = wb_cyc_i & wb_stb_i &  wb_we_i &  wb_ack_o & (wb_adr_i[2:1] == 2'b11);
//
// Output data multiplexed register
//
always @(posedge wb_clk_i or posedge wb_rst_i)
begin
   if (wb_rst_i)
      wb_dat_o <= 16'h0000;
   else
      if (wb_cyc_i & wb_stb_i & ~wb_ack_o)
         case(wb_adr_i[2:1])
            2'b00:   wb_dat_o <= rx_csr;  // 177560
            2'b01:   wb_dat_o <= rx_rbr;  // 177562
            2'b10:   wb_dat_o <= tx_csr;  // 177564
            default: wb_dat_o <= 16'o000000;
         endcase
end

always @(posedge wb_clk_i)
   wb_ack_o <= wb_cyc_i & wb_stb_i & ~wb_ack_o;

//
// Control register bits
//
always @(posedge wb_clk_i or posedge wb_rst_i)
begin
   if (wb_rst_i)
   begin
      rx_csr_ie  <= 1'b0;
      tx_csr_ie  <= 1'b0;
      tx_csr_tst <= 1'b0;
      tx_csr_brk <= 1'b0;
   end
   else
   begin
      if (rx_csr_wstb)
         rx_csr_ie <= wb_dat_i[6];

      if (tx_csr_wstb)
      begin
         tx_csr_ie  <= wb_dat_i[6];
         tx_csr_tst <= wb_dat_i[2];
         tx_csr_brk <= wb_dat_i[0];
      end
   end
end

//______________________________________________________________________________
//
// Interrupts
//
always @(posedge wb_clk_i or posedge wb_rst_i)
begin
   if (wb_rst_i)
   begin
      rx_irq_edge <= 2'b00;
      tx_irq_edge <= 2'b00;
      tx_irq_o    <= 1'b0;
      rx_irq_o    <= 1'b0;
   end
   else
   begin
      rx_irq_edge[0] <= rx_csr_flg & rx_csr_ie;
      if (rx_csr_flg & rx_csr_ie & ~rx_irq_edge[0])
         rx_irq_edge[1] <= 1'b1;
      else
         if (rx_ack_i | rx_rbr_rstb)
            rx_irq_edge[1] <= 1'b0;

      tx_irq_edge[0] <= tx_csr_flg & tx_csr_ie;
      if (tx_csr_flg & tx_csr_ie & ~tx_irq_edge[0])
         tx_irq_edge[1] <= 1'b1;
      else
         if (tx_ack_i)
            tx_irq_edge[1] <= 1'b0;

      if (rx_ack_i)
         rx_irq_o <= 1'b0;
      else
         rx_irq_o <= rx_irq_edge[1] & rx_csr_flg & rx_csr_ie;

      if (tx_ack_i)
         tx_irq_o <= 1'b0;
      else
         tx_irq_o <= tx_irq_edge[1] & tx_csr_flg & tx_csr_ie;
   end
end

//______________________________________________________________________________
//
// Metastability issues
//
always @(posedge wb_clk_i)
begin
   tx_cts_reg[0] <= ~tx_cts_i;
   tx_cts_reg[1] <= tx_cts_reg[0];

   rx_dat_reg[0] <= rx_dat_i;
   rx_dat_reg[1] <= rx_dat_reg[0];
end

//______________________________________________________________________________
//
// Transmitter unit
//
assign tx_par = tx_thr[0] ^ tx_thr[1] ^ tx_thr[2] ^ tx_thr[3] ^ tx_thr[4]
              ^ (tx_thr[5] & (cfg_nbit >= 2'b01))
              ^ (tx_thr[6] & (cfg_nbit >= 2'b10))
              ^ (tx_thr[7] & (cfg_nbit == 2'b11))
              ^ cfg_podd;
assign tx_dat_o = tx_shr[0] & ~tx_csr_brk;

always @(posedge wb_clk_i or posedge wb_rst_i)
begin
   if (wb_rst_i)
   begin
      tx_csr_flg <= 1'b1;
      tx_shr  <= 10'o1777;
      tx_busy <= 1'b0;
      tx_bcnt <= 8'b00000000;
      tx_thr  <= 8'b00000000;
   end
   else
   begin
      //
      // Transmitter hold register write
      //
      if (tx_thr_wstb)
      begin
         tx_csr_flg <= 1'b0;
         tx_thr <= wb_dat_i[7:0];
      end

      if (baud_x16)
      begin
         //
         // Transmit process
         //
         if (tx_busy)
         begin
            if (tx_bcnt == 8'b00000001)
               tx_busy <= 1'b0;

            if (tx_bcnt != 8'b00000000)
               tx_bcnt <= tx_bcnt - 8'b00000001;

            if (tx_bcnt[3:0] == 4'b0000)
               tx_shr  <= {1'b1, tx_shr[9:1]};
         end

         //
         // Starting new word transmit
         //
         if (~tx_csr_flg & ~tx_busy & tx_cts_reg[1])
         begin
            tx_busy    <= 1'b1;
            tx_csr_flg <= ~tx_thr_wstb;
            tx_bcnt    <= {4'b0110 + {2'b00, cfg_nbit} + {3'b000, cfg_pena} + {3'b000, cfg_nstp}, 4'b1111};

            if (cfg_pena)
               case(cfg_nbit)
                  2'b00:   tx_shr <= {3'b111, tx_par, tx_thr[4:0], 1'b0};
                  2'b01:   tx_shr <= {2'b11,  tx_par, tx_thr[5:0], 1'b0};
                  2'b10:   tx_shr <= {1'b1,   tx_par, tx_thr[6:0], 1'b0};
                  default: tx_shr <= {        tx_par, tx_thr[7:0], 1'b0};
               endcase
            else
               case(cfg_nbit)
                  2'b00:   tx_shr <= {4'b1111, tx_thr[4:0], 1'b0};
                  2'b01:   tx_shr <= {3'b111,  tx_thr[5:0], 1'b0};
                  2'b10:   tx_shr <= {2'b11,   tx_thr[6:0], 1'b0};
                  default: tx_shr <= {1'b1,    tx_thr[7:0], 1'b0};
               endcase
         end
      end
   end
end

//______________________________________________________________________________
//
// Receiver unit
//
assign rx_dtr_o = rx_csr_flg;
assign rx_dat =  tx_csr_tst & tx_dat_o
              | ~tx_csr_tst & rx_dat_reg[1];

assign rx_load = rx_stb & (rx_bcnt[7:4] == 4'b0000);
assign rx_stb  = (rx_bcnt[3:0] == 4'b0001) & baud_x16;

always @(posedge wb_clk_i or posedge wb_rst_i)
begin
   if (wb_rst_i)
   begin
      rx_csr_flg  <= 1'b0;
      rx_csr_perr <= 1'b0;
      rx_csr_ovf  <= 1'b0;
      rx_csr_brk  <= 1'b0;
      rx_frame    <= 1'b0;
      rx_start    <= 1'b0;
      rx_par      <= 1'b0;
      rx_rbr  <= 8'b00000000;
      rx_shr  <= 9'b00000000;
      rx_bcnt <= 8'b00000000;
   end
   else
   begin
      if (rx_load)
      begin
         rx_csr_flg  <= 1'b1;
         case(cfg_nbit)
            2'b00:   rx_rbr <= {3'b000, rx_shr[4:0]};
            2'b01:   rx_rbr <= {2'b00, rx_shr[5:0]};
            2'b10:   rx_rbr <= {1'b0, rx_shr[6:0]};
            default: rx_rbr <= rx_shr[7:0];
         endcase
         rx_csr_perr <= rx_par;
         rx_csr_ovf  <= rx_csr_flg;
         rx_csr_brk  <= ~rx_dat;
      end
      else
         if (rx_rbr_rstb)
         begin
            rx_csr_flg  <= 1'b0;
            rx_csr_perr <= 1'b0;
            rx_csr_ovf  <= 1'b0;
         end

      if (baud_x16)
      begin
         if (~rx_frame)
            //
            // Waiting for start bit
            //
            if (~rx_dat)
            begin
               rx_par   <= cfg_pena & cfg_podd;
               rx_start <= 1'b1;
               rx_frame <= 1'b1;
               rx_bcnt  <= {4'b0110 + {2'b00, cfg_nbit} + {3'b000, cfg_pena}, 4'b0111};
            end
            else
            begin
               rx_start <= 1'b0;
               rx_bcnt  <= 8'b00000000;
            end
         else
         begin
            //
            // Receiving frame
            //
            if (rx_bcnt != 8'b00000000)
               rx_bcnt <= rx_bcnt - 8'b00000001;
            //
            // Start bit monitoring
            //
            if (rx_start)
            begin
               if (rx_dat)
               begin
                  //
                  // Spurrious start bit
                  //
                  rx_start <= 1'b0;
                  rx_frame <= 1'b0;
                  rx_bcnt  <= 8'b00000000;
               end
               else
                  if (rx_bcnt[3:0] == 4'b0010)
                     rx_start <= 1'b0;
            end
            else
            begin
               //
               // Receiving data
               //
               if (rx_stb)
               begin
                  rx_par <= (rx_par ^ rx_dat) & cfg_pena;
                  if (cfg_pena)
                     case(cfg_nbit)
                        2'b00:   rx_shr <= {3'b000, rx_dat, rx_shr[5:1]};
                        2'b01:   rx_shr <= {2'b00, rx_dat, rx_shr[6:1]};
                        2'b10:   rx_shr <= {1'b0, rx_dat, rx_shr[7:1]};
                        default: rx_shr <= {rx_dat, rx_shr[8:1]};
                     endcase
                  else
                     case(cfg_nbit)
                        2'b00:   rx_shr <= {4'b0000, rx_dat, rx_shr[4:1]};
                        2'b01:   rx_shr <= {3'b000, rx_dat, rx_shr[5:1]};
                        2'b10:   rx_shr <= {2'b00, rx_dat, rx_shr[6:1]};
                        default: rx_shr <= {1'b0, rx_dat, rx_shr[7:1]};
                     endcase
                  if (rx_load & rx_dat)
                  begin
                     //
                     // Stop bit detected
                     //
                     rx_frame <= 1'b0;
                     rx_bcnt  <= 8'b00000000;
                  end
               end
               if ((rx_bcnt == 8'b00000000) & rx_dat)
                  rx_frame <= 1'b0;
            end
         end
      end
   end
end
endmodule
