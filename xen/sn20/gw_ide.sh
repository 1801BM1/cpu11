#!/bin/bash
cd /opt/gowin/1.9.9.03/IDE
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libfreetype.so.6 \
	/opt/gowin/1.9.9.03/IDE/bin/gw_ide $@
