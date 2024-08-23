# Sipeed Tang Nano 9K

## Specification

* On-Board FPGA: Gowin GW1NR-LV9QN88PC6/I5
 - LUT4: 8640
 - FF: 6480
 - ShadowSRAM: 17280 bits
 - BSRAM: 468K bits
 - User flash: 608K bits
 - SDR SDRAM: 64M bits
* On-Board FPGA external crystal frequency: 27MHz;
* On-board 32 Mbpi SPI flash
* On-board TF card slot, HDMI, RGB screen interface
* On-Board 256MB Micron DDR3，MT41J128M16-15E;

## Site URL
  https://www.aliexpress.com/item/1005003803994525.html

## Documentation, code

Wiki:
    https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html

Examples:
    https://github.com/sipeed/TangNano-9K-example

# Fmax

| CPU   | MHz    |
|-------|--------|
| vm1   | 50.816 |
| vm2   | 40.464 |
| vm3   | 30.449 |
| lsi   | 36.297 |
| am4   | 29.446 |
| f11   | 38.261 |

# Report Instance Areas

## VM1 

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 1777/8640  20%
        --LUT,ALU,ROM16           | 1777(1710 LUT, 67 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 623/6693  9%
        --Logic Register as Latch | 0/6480  0%
        --Logic Register as FF    | 623/6480  9%
        --I/O Register as Latch   | 0/213  0%
        --I/O Register as FF      | 0/213  0%
      CLS                         | 1108/4320  25%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 38%
        --SP                      | 8
        --DPB                     | 2
      DSP                         | 0%
      PLL                         | 1/2  50%

## VM2

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 2096/8640  25%
        --LUT,ALU,ROM16           | 2096(2021 LUT, 75 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 785/6693  12%
        --Logic Register as Latch | 0/6480  0%
        --Logic Register as FF    | 785/6480  13%
        --I/O Register as Latch   | 0/213  0%
        --I/O Register as FF      | 0/213  0%
      CLS                         | 1389/4320  33%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 31%
        --SP                      | 8
      DSP                         | 0%
      PLL                         | 1/2  50%


## VM3

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 3759/8640  44%
        --LUT,ALU,ROM16           | 3759(3664 LUT, 95 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 1644/6693  25%
        --Logic Register as Latch | 0/6480  0%
        --Logic Register as FF    | 1644/6480  26%
        --I/O Register as Latch   | 0/213  0%
        --I/O Register as FF      | 0/213  0%
      CLS                         | 2741/4320  64%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 58%
        --SP                      | 7
        --SPX9                    | 8
      DSP                         | 0%
      PLL                         | 1/2  50%

## LSI

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 1724/8640  19%
        --LUT,ALU,ROM16           | 1724(1670 LUT, 54 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 590/6693  8%
        --Logic Register as Latch | 0/6480  0%
        --Logic Register as FF    | 590/6480  9%
        --I/O Register as Latch   | 0/213  0%
        --I/O Register as FF      | 0/213  0%
      CLS                         | 1147/4320  26%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 38%
        --SP                      | 8
        --pROMX9                  | 2
      DSP                         | 0%
      PLL                         | 1/2  50%

## AM4

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 1020/8640  11%
        --LUT,ALU,ROM16           | 972(906 LUT, 66 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 8
      Register                    | 391/6693  5%
        --Logic Register as Latch | 0/6480  0%
        --Logic Register as FF    | 391/6480  6%
        --I/O Register as Latch   | 0/213  0%
        --I/O Register as FF      | 0/213  0%
      CLS                         | 672/4320  15%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 46%
        --SP                      | 8
        --pROMX9                  | 4
      DSP                         | 0%
      PLL                         | 1/2  50%

## F11

      ----------------------------------------------------------
      Resources                   | Usage
      ----------------------------------------------------------
      Logic                       | 3484/8640  41%
        --LUT,ALU,ROM16           | 3484(3401 LUT, 83 ALU, 0 ROM16)
        --SSRAM(RAM16)            | 0
      Register                    | 1351/6693  21%
        --Logic Register as Latch | 0/6480  0%
        --Logic Register as FF    | 1351/6480  21%
        --I/O Register as Latch   | 0/213  0%
        --I/O Register as FF      | 0/213  0%
      CLS                         | 2445/4320  57%
      I/O Port                    | 11
      I/O Buf                     | 10
        --Input Buf               | 3
        --Output Buf              | 7
        --Inout Buf               | 0
      IOLOGIC                     | 0%
      BSRAM                       | 62%
        --SP                      | 7
        --SPX9                    | 8
        --SDPB                    | 1
      DSP                         | 0%
      PLL                         | 1/2  50%

