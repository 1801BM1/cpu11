OUTPUT_FORMAT("a.out-pdp11")
ENTRY(start)
phys = 00001000;
SECTIONS
{
  .text phys : AT(phys) {
    code = .;
    crt0.o(.text)
    *(.text)
    *(.rodata)
    . = ALIGN(0100);
  }
  .data : AT(phys + (data - code))
  {
    data = .;
    *(.data)
    . = ALIGN(0100);
  }
  .bss : AT(phys + (bss - code))
  {
    bss = .;
    *(.bss)
    . = ALIGN(0100);
  }
  end = .;
}
