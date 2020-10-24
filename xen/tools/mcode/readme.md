## Programmable Logic Matrices

The 1801 series microprocessors are mainly built around the one programmable
logic matrix - PLM. This matrix combines the horizontal microcode, the state
machine control and the operation decode logic and can be considered as simple
combinatorial functions of input logic vector X providing the output vector Y:

```
y[m:0] = f(x[n:0])
```

The state is defined as the address of "microinstruction", the some number
of least significant bits of the input vector is the micro address field
and the output vector contains the new value to be assigned to the micro
address register - "next address" field". These next address bits might be
spread over the output vector bits due to the bit order is defined in the
reverse engineering process, and it is not always obvious where these bits are.
The sixteen most significant bits of the input vector is always the current
PDP-11 instruction opcode.

The matrix encompasses the logical functions in the disjunctive normal form.
There is a set of products compared against the input vector with masking
and the matched products are merged to the output vector with logical OR.

The table presents the matrix parameters for the processors of the 1801 series:

| Model    | Input  | Output | Address | Products |
|----------|--------|--------|---------|----------|
| 1801BM1A | 31     | 34     | 7       | 248      |
| 1801BM1G | 31     | 34     | 7       | 249      |
| 1801BM2  | 28     | 37     | 6       | 198      |

## Matrix routine

The matrix routine implements the matrix function. The supported width
of input vector is limited by 32 bits and the supported width of output
vector is limited by 64 bits, the prototype of the routine looks like:

```
uint64_t f(uint32_t x);
```

The main algorithm is to check all the products and to OR the matching ones:

```
for each product { if product matches input { add to result } }
```

There are some straightforward optimizations possible. Because product masked
matching is the logical XOR and AND, it is possible to use SIMD
instructions to handle multiple vectors in one operation. The SSE2
implementation handles four vectors per product loop iteration,
AVX2 implementation can handle eight vectors per iteration.

Another optimization is to split the input vector values in the multiple
groups, using the values of some selected bits. Then we can check all the
products and assign only matching ones to each group. At the calculation
time, we check the selected bit values and decide the products for which group
should be looped to calculate the results. Because the products that do not
match to this given vector are excluded (missing in the array of products
for this group) the number of loop iterations is lesser.

For example, we have selected the four least significant bits as a group index,
and have built (once at the initialization time) the sixteen arrays of products
matching with group indices 0..15. The input vectors xxxx0 will use
the products of group 0 to calculate the result, the vectors xxxx5 will use
group 5 and so on.

The choice of the most optimal bits is not so straightforward,
the code implements checking all possible bit combinations for the given
matrix and chooses the combination producing the tree (set of product arrays)
of the minimum height.

## Microcode Analyzing Application

The sample application provides testing, scanning matrices for specified
input vector patterns and performance measurement means.

There is the reference matrix for 1801BM1A is implemented in the very
straightforward fashion and this one was proven with Verilog simulation while
documenting the microcode execution. The new matrix routine implementations
including SIMD and tree optimized ones can be directly compared with proven
reference, this functionality is enabled with --match key and provided for
1801BM1A matrix only.

The --speed key enables the performance measurement tests, all input range is
calculated and the resulting time is reported. There are some results obtained
on the developer machine (Haswell i7-4770, @3.4GHz, single core):

| Matrix/method            | x86-32    | x86-64    |
|--------------------------|-----------|-----------|
| vm1a reference           | 5:50      | 5:37      |
| vm1a 32b/tree(4)         | 5:50/0:65 | 5:53/0:51 |
| vm1a 64b/tree(4)         | 5:27/1:23 | 4:27/0:50 |
| vm1a 128b (SSE2)/tree(4) | 2:57/0:34 | 2:51/0:27 |
| vm1a 256b (AVX2)/tree(4) | 1:31/0:28 | 1:25/0:21 |
| vm2 32b/tree(4)          | -         | 0:36/0:06 |
| vm2 64b/tree(4)          | -         | 0:29/0:04 |
| vm2 128b (SSE2)/tree(4)  | -         | 0:17/0:03 |
| vm2 256b (AVX2)/tree(4)  | -         | 0:09/0:02 |

The --table method builds the micro address tables and gathers the statistics 
about jumps to target micro addresses.

The application was compiled/tested on Windows x86/x64 environment. Also
was compiled in RHEL 8.2 with x86-64 settings, Makefile is included.
