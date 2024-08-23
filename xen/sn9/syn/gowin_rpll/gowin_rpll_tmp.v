//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.8.08
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9C
//Created Time: Sat Aug 24 02:40:33 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    gwn_pll54 your_instance_name(
        .clkout(clkout_o), //output clkout
        .lock(lock_o), //output lock
        .clkoutp(clkoutp_o), //output clkoutp
        .clkin(clkin_i) //input clkin
    );

//--------Copy end-------------------
