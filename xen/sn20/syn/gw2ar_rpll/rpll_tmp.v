//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.9.03 Education
//Part Number: GW2AR-LV18QN88C8/I7
//Device: GW2AR-18
//Device Version: C
//Created Time: Tue Aug 27 18:34:32 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    gwn_pll54 your_instance_name(
        .clkout(clkout), //output clkout
        .lock(lock), //output lock
        .clkoutp(clkoutp), //output clkoutp
        .clkin(clkin) //input clkin
    );

//--------Copy end-------------------
