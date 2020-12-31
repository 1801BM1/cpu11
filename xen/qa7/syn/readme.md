# QMTech Artix-7 DDR3 board 

## Specification

* On-Board FPGA: XC7A35T-1FTG256C;
* On-Board FPGA external crystal frequency: 50MHz;
* XC7A35T-1FTG256C has rich block RAM resource up to 1,800Kb;
* XC7A35T-1FTG256C has 33,280 logic cells;
* On-Board N25Q064 SPI Flash，8M bytes for user configuration code;
* On-Board 256MB Micron DDR3，MT41J128M16-15E;

## Site URL
  https://www.aliexpress.com/item/32964497318.html

## Documentation, code
  https://github.com/ChinaQMTECH/QM_XC7A35T_DDR3

# Pi 1000 digits test

| CPU   | Ticks (50MHz) |
|-------|---------------|
| vm1   |  1173         |
| vm2   |   224         |
| lsi   |   568         |
| am4   |   308         |

# Report Instance Areas: 
## VM1 

	+------+----------------------+-------------+------+
	|      |Instance              |Module       |Cells |
	+------+----------------------+-------------+------+
	|1     |top                   |             |  3182|
	|2     |  cpu                 |wbc_vm1      |  3109|
	|3     |    cpu               |vm1_wb       |  1760|
	|4     |      timer           |vm1_timer    |   151|
	|5     |      vreg_rm         |vm1_reg_ram  |   232|
	|6     |        vm1_vcram_reg |vm1_vcram    |   226|
	|7     |    mem               |wbc_mem      |   931|
	|8     |      ram             |qa7_mem      |   928|
	|9     |    reset             |wbc_rst      |   203|
	|10    |    uart              |wbc_uart     |   199|
	|11    |    vic               |wbc_vic      |    16|
	|12    |  tog1                |wbc_toggle   |    20|
	|13    |    button            |wbc_button_1 |    19|
	|14    |  tog2                |wbc_toggle_0 |    20|
	|15    |    button            |wbc_button   |    19|
	+------+----------------------+-------------+------+

## VM2

	+------+-----------+-------------+------+
	|      |Instance   |Module       |Cells |
	+------+-----------+-------------+------+
	|1     |top        |             |  3691|
	|2     |  cpu      |wbc_vm2      |  3618|
	|3     |    cpu    |vm2_wb       |  2250|
	|4     |    mem    |wbc_mem      |   949|
	|5     |      ram  |qa7_mem      |   946|
	|6     |    reset  |wbc_rst      |   204|
	|7     |    uart   |wbc_uart     |   198|
	|8     |    vic    |wbc_vic      |    17|
	|9     |  tog1     |wbc_toggle   |    20|
	|10    |    button |wbc_button_1 |    19|
	|11    |  tog2     |wbc_toggle_0 |    20|
	|12    |    button |wbc_button   |    19|
	+------+-----------+-------------+------+

## LSI

	+------+--------------+-------------+------+
	|      |Instance      |Module       |Cells |
	+------+--------------+-------------+------+
	|1     |top           |             |  3050|
	|2     |  cpu         |wbc_lsi      |  2971|
	|3     |    cpu       |lsi_wb       |  1616|
	|4     |      control |mcp1621      |   630|
	|5     |      data    |mcp1611      |   801|
	|6     |      microm  |mcp1631      |    44|
	|7     |    mem       |wbc_mem      |   929|
	|8     |      ram     |qa7_mem      |   927|
	|9     |    reset     |wbc_rst      |   208|
	|10    |    uart      |wbc_uart     |   202|
	|11    |    vic       |wbc_vic      |    16|
	|12    |  tog1        |wbc_toggle   |    19|
	|13    |    button    |wbc_button_1 |    18|
	|14    |  tog2        |wbc_toggle_0 |    27|
	|15    |    button    |wbc_button   |    18|
	+------+--------------+-------------+------+

## AM4

	+------+-----------+-------------+------+
	|      |Instance   |Module       |Cells |
	+------+-----------+-------------+------+
	|1     |top        |             |  2184|
	|2     |  cpu      |wbc_am4      |  2111|
	|3     |    cpu    |am4_wb       |   727|
	|4     |      alu  |am4_alu      |    52|
	|5     |      rom  |mcrom        |   323|
	|6     |      seq  |am4_seq      |   167|
	|7     |    mem    |wbc_mem      |   939|
	|8     |      ram  |qa7_mem      |   936|
	|9     |    reset  |wbc_rst      |   205|
	|10    |    uart   |wbc_uart     |   224|
	|11    |    vic    |wbc_vic      |    16|
	|12    |  tog1     |wbc_toggle   |    20|
	|13    |    button |wbc_button_1 |    19|
	|14    |  tog2     |wbc_toggle_0 |    20|
	|15    |    button |wbc_button   |    19|
	+------+-----------+-------------+------+
