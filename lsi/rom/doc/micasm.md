## Micro Assembler

The [Micro Assembler](/lsi/rom/tools/cp16mic.py) to compile the microcode
was develeoped in Python. It compiles the multiple source files in two
passes and writes out the united object file in Verlig Memory format
and optionally the TTL/PLA translation fields content. Program uses standard
Python 3.x libraries only and has no external dependencies.

### Usage

```
cp16mic.py srcfile [srcfile ..] [-l|--lst lstfile] [-o|--obj objfile] [-t|--ttl ttlfile]
```

### Numeric, literals values and labels
- **_axxxx_** - identifier should start with letter
- **_. (point)_** - current location counter, assignable
- **_nnnn$_** - is treated as local label
- **_0xNNNN_** - always hexadecimal
- **_0bNNNN_** - always binary
- **_NNNN._** - always decimal
- **_0NNNN_** - always octal
- **_NNNN_** - depends on .radix settings
- **_'N'_** - character code
- **_"string"_** - string literal (supports \\,\",\')

### Supported directives

The following directives are supported:

- **_name=expr_** - assign the name with specified expression,
                     ")(~+-*/|&^" operations supported, C-language priorities
- **_.title "string"_** - provide the title "string", ignored
- **_.radix expr_** - provide default base for the numeric values,
                      8 is assigned at the beginning of each source file by default,
                      8 an 10 values are supported.
- **_.align expr_** - align the location counter on specified power of 2
- **_.tran name, expr_** - defines name of translation with specified value
- **_.reg name, expr_** - defines name of register with specified value
- **_.org expr_** - assign the specified value to location counter
- **_.loc expr_** - assign the specified value to location counter
- **_.end_** - finished the current source file processing

### Predefined register names

These names are predefined as register names:
- **_G, GL, GH_** - access by G index register
- **_RBA, RBAL, RBAH_** - bus address register, lower and upper halves
- **_RSRC, RSRCL, RSRCH_** - source register,  lower and upper halves
- **_RDST, RDSTL, RDSTH_** - destination register, lower and upper halves
- **_RIR, RIRL, RIRH_**  - PDP-11 instruction register, lower and upper halves
- **_RPSW, RPSWL, RPSWH_**  - PDP-11 status word register, lower and upper halves
- **_SP, SPL, SPH_**  - PDP-11 stack pointer register, lower and upper halves
- **_PC, PCL, PCH_**  - PDP-11 program counter register, lower and upper halves

These names are predefined as flag bitmasks:
- **_I4, I5, I6_** - interrupt set/clear masks
- **_C, V, Z, N, T_** - PDP-11 arithmetic flags and T-bit
- **_C8, C4, ZB, NB_** - MCP-1600 ALU flags
- **_UB, LB, UBC, LBC, RMW_** - input/output mode
- **_TG6, TG8_** - instruction fetch control

These names are predefined as extension field bits:
- **_LRR_** - load location counter from return register
- **_RSVC_** - read next instruction

Standard MCP-1600 [mnemonics](/lsi/rom/doc/mcp1600.pdf),
defined in vendor documentation are supported.
