//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.8
//Part Number: GW1NSR-LV4CQN48PC7/I6
//Device: GW1NSR-4C
//Created Time: Thu Feb 17 07:52:16 2022

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    mem16x8k_lsi your_instance_name(
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
