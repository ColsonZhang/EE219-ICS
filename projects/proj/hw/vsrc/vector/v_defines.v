`define VLEN            512
`define SEW             64
`define LMUL            1
`define VLMAX           (`VLEN/`SEW) * `LMUL

`define VINST_BUS       31:0
`define SREG_BUS        63:0
`define SREG_ADDR_BUS   4:0

`define VREG_WIDTH      `VLEN
`define VREG_BUS        `VLEN-1 : 0
`define VREG_ADDR_BUS   4  : 0

`define VMEM_ADDR_BUS   63 : 0
`define VMEM_DATA_BUS   `VLEN-1 : 0

`define VRAM_ADDR_BUS   63 : 0
`define VRAM_DATA_BUS   `VLEN-1 : 0

`define ALU_OP_BUS      7  : 0
