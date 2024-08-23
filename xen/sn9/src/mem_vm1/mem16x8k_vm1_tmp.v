//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.8.08
//Part Number: GW1N-LV9QN48C6/I5
//Device: GW1N-9C
//Created Time: Sat Aug 24 11:19:53 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    mem16x8k_vm1 your_instance_name(
        .dout(dout_o), //output [15:0] dout
        .clk(clk_i), //input clk
        .oce(oce_i), //input oce
        .ce(ce_i), //input ce
        .reset(reset_i), //input reset
        .wre(wre_i), //input wre
        .ad(ad_i), //input [12:0] ad
        .din(din_i) //input [15:0] din
    );

//--------Copy end-------------------
