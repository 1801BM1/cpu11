# qk7 board
`qk7` is a Xilinx/AMD Kintex-7 based board by QMTech-China

## Specification

* On-Board FPGA: XC7K325T-1FFG676C;
* On-Board FPGA external crystal frequency: 50MHz;
* XC7K325T-1FFG676C has rich block RAM resource up to 16,020Kb;
* XC7K325T-1FFG676C has 326,080 logic cells;
* On-Board S25FL256:LAGM SPI Flash 32M bytes for user configuration code (91,548,896 bits are used for device configuration);
* On-Board 256MB Micron DDR3 MT41J128M16JT-125:K;
* 3 user switches and 4 user LEDs on the "Core" board

## Site URL

  https://www.aliexpress.com/item/32964497318.html

## Documentation, code

  https://github.com/ChinaQMTECH/QMTECH_XC7K325T_CORE_BOARD

# The code

This folder contains projects for each cpu11 model:
* qk7-f11/qk7-f11.xpr
* qk7-vm1/qk7-vm1.xpr
* qk7-vm2/qk7-vm2.xpr
* qk7-vm3/qk7-vm3.xpr

The above files contain commands to create Vivado XPR project file for particular CPU11 model.
Need to note, those projects have a new Verilog defines like below:

    CONFIG_WBC_CPU=wbc_vm3
    CONFIG_WBC_TTL=qk7_ttl125
    CONFIG_WBC_MEM=wbc_mem_32k

You may find all realted defines in `rtl/*_defs.v` files for each CPU.

Those `CONFIG_WBC_CPU`, `CONFIG_WBC_TTL`, `CONFIG_WBC_MEM` macros are used in the top module to instanciate a CPU.
Also, it simplifies configuration a bit: look at the `xen/lib/config.v` for the reference

# How to build the project from command line

Assuming you have loasded Vivado shell env by the following command:

    . /opt/xilinx/Vivado/2023.2/settings64.sh


    ./build-xpr.sh  vm3

It will generate all related files into `./qa7-vm3` subfolder.
And you may find resulting bitstream in the `./qa7-vm3/qa7-vm3.runs/impl_1/qa7_top.bit` file.
Also, you may find utilization and timing reports in the `qa7-vm3/qa7-vm3.runs/impl_1/` folder

I.e. for each CPU we have own build directry to build the project.


# Implementation issues

## Timing constraings

PLL for each CPU could be different and is defined in `rtl/${CPUID}_defs.v`
So, the top-level module includes proper PLL module -- `xen/qk7/rtl/qk7_top.v`

## Fmax

| CPU   | MHz    |
|-------|--------|
| vm1   | 150    |
| vm2   | 150    |
| vm3   | 133    |
| lsi   | 133    |
| am4   | 114    |
| f11   | 133    |

