# Sipeed Tang Nano 9K

## Specification

* On-Board FPGA: Gowin GW2AR-LV18QN88C8/I7 includes
 - LUT4:  20736
 - FF: 15552 
 - ShadowSRAM: 41472 bits 
 - BSRAM: 828K
 - User flash: 
 - 32bit SDRAM: 64M bits
 - 2x PLL
Board contans also:
* external crystal frequency: 27MHz;
* 7x LEDs and 1 RGB LED
* TF card slot
* HDMI (TDMS Video Output), 
* MIPI DPI connector
* 2x user buttons

## Site URL
  https://www.aliexpress.com/item/1005006721863996.html

## Documentation, code

Wiki:
    https://wiki.sipeed.com/hardware/en/tang/tang-nano-20k/nano-20k.html

Examples:
    https://github.com/sipeed/TangNano-20K-example

# Fmax

| CPU   | MHz    |
|-------|--------|
| vm1   | 87.203 |
| vm2   | 68.890 |
| vm3   | 55.448 |
| lsi   | 61.111 |
| am4   | 55.727 |
| f11   | 58.764 |

# Report Instance Areas

## VM1 

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 1781/20736  9%
        --LUT,ALU,ROM16           | 1781(1714 LUT, 67 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 623/15750  4%
        --Logic Register as Latch | 0/15552  0%
        --Logic Register as FF    | 623/15552  5%
        --I/O Register as Latch   | 0/198  0%
        --I/O Register as FF      | 0/198  0%
      CLS                         | 1129/10368  11%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 20%
        --SP                      | 8
        --DPB                     | 1
      DSP                         | 0%
      PLL                         | 1/2  50%

## VM2

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 2096/20736  11%
        --LUT,ALU,ROM16           | 2096(2021 LUT, 75 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 785/15750  5%
        --Logic Register as Latch | 0/15552  0%
        --Logic Register as FF    | 785/15552  6%
        --I/O Register as Latch   | 0/198  0%
        --I/O Register as FF      | 0/198  0%
      CLS                         | 1384/10368  14%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 18%
        --SP                      | 8
      DSP                         | 0%
      PLL                         | 1/2  50%


## VM3


      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 3759/20736  19%
        --LUT,ALU,ROM16           | 3759(3664 LUT, 95 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 1644/15750  11%
        --Logic Register as Latch | 0/15552  0%
        --Logic Register as FF    | 1644/15552  11%
        --I/O Register as Latch   | 0/198  0%
        --I/O Register as FF      | 0/198  0%
      CLS                         | 2728/10368  27%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 33%
        --SP                      | 7
        --SPX9                    | 8
      DSP                         | 0%
      PLL                         | 1/2  50%


## LSI

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 1640/20736  8%
        --LUT,ALU,ROM16           | 1640(1586 LUT, 54 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 590/15750  4%
        --Logic Register as Latch | 0/15552  0%
        --Logic Register as FF    | 590/15552  4%
        --I/O Register as Latch   | 0/198  0%
        --I/O Register as FF      | 0/198  0%
      CLS                         | 1110/10368  11%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 22%
        --SP                      | 8
        --pROMX9                  | 2
      DSP                         | 0%
      PLL                         | 1/2  50%
      DCS                         | 0/8  0%

## AM4

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 1058/20736  6%
        --LUT,ALU,ROM16           | 1010(944 LUT, 66 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 8
      Register                    | 391/15750  3%
        --Logic Register as Latch | 0/15552  0%
        --Logic Register as FF    | 391/15552  3%
        --I/O Register as Latch   | 0/198  0%
        --I/O Register as FF      | 0/198  0%
      CLS                         | 680/10368  7%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 27%
        --SP                      | 8
        --pROM                    | 4
      DSP                         | 0%
      PLL                         | 1/2  50%

## F11

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 3379/20736  17%
        --LUT,ALU,ROM16           | 3379(3296 LUT, 83 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 1353/15750  9%
        --Logic Register as Latch | 0/15552  0%
        --Logic Register as FF    | 1353/15552  9%
        --I/O Register as Latch   | 0/198  0%
        --I/O Register as FF      | 0/198  0%
      CLS                         | 2407/10368  24%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 42%
        --SP                      | 7
        --SPX9                    | 8
        --SDPB                    | 1
        --pROM                    | 3
      DSP                         | 0%
      PLL                         | 1/2  50%
     

