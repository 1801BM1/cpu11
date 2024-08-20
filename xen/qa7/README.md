# qa7 board
`qa7` is a Xilinx/AMD Artix-7 based board by QMTech-China

This folder contains projects for each cpu11 model:
 * qa7-am4.tcl
 * qa7-f11.tcl
 * qa7-lsi.tcl
 * qa7-vm1.tcl
 * qa7-vm2.tcl
 * qa7-vm3.tcl

The above files contain commands to create Vivado XPR project file for particular CPU11 model.
Need to note, those projects have a new Verilog defines like below:

    CONFIG_WBC_CPU=wbc_vm3

This `CONFIG_WBC_CPU` macro is used in the top module to instanciate a CPU.
Also, it simplifies configuration a bit: look at the `xen/lib/config.v` for the reference

## How to build the project from command line

Assuming you have loasded Vivado shell env by the following command:

    . /opt/xilinx/Vivado/2018.3/settings64.sh


There are 2 steps to build a project by Vivado from CLI:

1. Regenerate Vivado project in XPR format by the TCL script
2. Build the project pointing at XPR file

In fact, `build-xpr.sh` script makes all those steps for you.
For example:

     ./build-xpr.sh  vm3

It will generate all related files into `./qa7-vm3` subfolder.
And you may find resulting bitstream in the `./qa7-vm3/qa7-vm3.runs/impl_3/qa7_top.bit` file.
Also, you may find utilization and timing reports in the `qa7-vm3/qa7-vm3.runs/impl_3/` folder

I.e. for each CPU we have own build directry to build the project.


## Implementation issues

### Timing constraings

I got `vm3` and `lsi` implemented only for 85MHz due to timing constraints.
So, the new `CONFIG_PLL_85` macro has been added to `xen/lib/config.v` and 
corresponding board specific file -- `xen/qa7/rtl/qa7_top.v`

