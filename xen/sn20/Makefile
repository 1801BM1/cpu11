.PHONY:	mif

all:	./impl/pnr/sn20_am4.fs \
	./impl/pnr/sn20_lsi.fs \
	./impl/pnr/sn20_vm1.fs \
	./impl/pnr/sn20_vm2.fs \
	./impl/pnr/sn20_vm3.fs

mif:	src/mem_am4/am4.mif \
	src/mem_lsi/lsi.mif \
	src/mem_vm1/vm1.mif \
	src/mem_vm2/vm2.mif \
	src/mem_vm3/vm3.mif \
	src/mem_f11/f11.mif

src/mem_am4/am4.mif:	../tst/am4.mif
	./fix_mif.py -f ../tst/am4.mif -o src/mem_am4/am4.mif

./impl/pnr/sn20_am4.fs: rtl/am4_defs.v rtl/sn20_top.v src/mem_am4/am4.mif
	./gw_sh.sh syn/am4.tcl


src/mem_lsi/lsi.mif:	../tst/lsi.mif
	./fix_mif.py -f ../tst/lsi.mif -o src/mem_lsi/lsi.mif

./impl/pnr/sn20_lsi.fs: rtl/lsi_defs.v rtl/sn20_top.v src/mem_lsi/lsi.mif
	./gw_sh.sh syn/lsi.tcl


src/mem_vm1/vm1.mif:	../tst/vm1.mif
	./fix_mif.py -f ../tst/vm1.mif -o src/mem_vm1/vm1.mif

./impl/pnr/sn20_vm1.fs: rtl/vm1_defs.v rtl/sn20_top.v src/mem_vm1/vm1.mif
	./gw_sh.sh syn/vm1.tcl

src/mem_vm2/vm2.mif:	../tst/vm2.mif
	./fix_mif.py -f ../tst/vm2.mif -o src/mem_vm2/vm2.mif

./impl/pnr/sn20_vm2.fs: rtl/vm2_defs.v rtl/sn20_top.v src/mem_vm2/vm2.mif
	./gw_sh.sh syn/vm2.tcl

src/mem_vm3/vm3.mif:	../tst/vm3.mif
	./fix_mif.py -f ../tst/vm3.mif -o src/mem_vm3/vm3.mif

./impl/pnr/sn20_vm3.fs: rtl/vm3_defs.v rtl/sn20_top.v src/mem_vm3/vm3.mif
	./gw_sh.sh syn/vm3.tcl

src/mem_f11/f11.mif:	../tst/f11.mif
	./fix_mif.py -f ../tst/f11.mif -o src/mem_f11/f11.mif

./impl/pnr/sn20_f11.fs: rtl/f11_defs.v rtl/sn20_top.v src/mem_f11/f11.mif
	./gw_sh.sh syn/f11.tcl

