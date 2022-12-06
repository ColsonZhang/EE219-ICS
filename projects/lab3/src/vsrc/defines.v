
`timescale 1ns / 1ps

`define ZERO_WORD       32'h0000_0000

`define PC_START        32'h8000_0000

`define INST_WIDTH      32
`define INST_ADDR_BUS   31 : 0 
`define INST_BUS        31 : 0

`define REG_WIDTH       32
`define REG_BUS         31 : 0
`define REG_ADDR_BUS    4  : 0

`define MEM_ADDR_BUS    31 : 0
`define MEM_DATA_BUS    31 : 0

`define RAM_ADDR_BUS    31 : 0
`define RAM_DATA_BUS    31 : 0

`define VLEN            256
`define SEW             32
`define LMUL            1
`define VLMAX           (`VLEN/`SEW) * `LMUL

`define VREG_WIDTH      `VLEN
`define VREG_BUS        `VLEN-1 : 0
`define VREG_ADDR_BUS   4  : 0

`define VMEM_ADDR_BUS   31 : 0
`define VMEM_DATA_BUS   `VLEN-1 : 0

`define VRAM_ADDR_BUS   31 : 0
`define VRAM_DATA_BUS   `VLEN-1 : 0

`define ALU_OP_BUS      7  : 0

// -------------------------------------------------
// ALU_OP
// -------------------------------------------------
`define ALU_OP_NOP      8'b0000_0000
`define ALU_OP_ADD      8'b0000_0001
// hint: add more

`define VALU_OP_NOP     8'b1000_0000
// hint: add more

// -------------------------------------------------
// Instruction OPCODE
// -------------------------------------------------
`define OPCODE_ADDI     7'b001_0011
`define FUNCT3_ADDI     3'b000
// hint: add more

`define OPCODE_VL       7'b000_0111 
`define WIDTH_VLE32     3'b110
`define FUNCT6_VLE32    6'b00_0000
// hint: add more