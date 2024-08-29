#!/bin/bash
. /etc/os-release
case "$NAME$VERSION_ID" in
  Ubuntu24.04)
    LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libfreetype.so.6 \
        /opt/gowin/1.9.10.01/IDE/bin/gw_sh $@
	;;
  *)
        /opt/gowin/1.9.10.01/IDE/bin/gw_sh $@
        ;;
esac
