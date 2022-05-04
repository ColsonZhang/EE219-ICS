
`timescale 1ns / 1ps

`define ZERO_WORD       32'h0000_0000

// ======================================
// MEMORY BASE ADDRESS
// ======================================
`define PC_START        32'h8000_0000
`define DATA_A_BASE     32'h0010_0000
`define DATA_B_BASE     32'h0020_0000
`define DATA_C_BASE     32'h0030_0000
`define DATA_D_BASE     32'h0040_0000


// ======================================
// SCALARE SIGNAL BUS
// ======================================
`define INST_WIDTH      32
`define INST_ADDR_BUS   31 : 0 
`define INST_BUS        31 : 0

`define REG_WIDTH       32
`define REG_BUS         31 : 0
`define REG_ADDR_BUS    4  : 0

`define MEM_ADDR_BUS    31 : 0
`define MEM_DATA_BUS    31 : 0

`define RAM_ADDR_BUS    31 : 0
`define RAM_DATA_BUS    63 : 0

// ======================================
// VECTOR SIGNAL BUS
// ======================================
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

// ======================================
// ALU OPERATION SIGNALS
// ======================================
`define ALU_OP_BUS      7  : 0
`define ALU_OP_NOP      8'b0000_0000
`define ALU_OP_ADD      8'b0000_0001
`define ALU_OP_BNE      8'b0000_0010
`define ALU_OP_MUL      8'b0000_0011

`define ALU_OP_VADD     8'b0000_0100
`define ALU_OP_VMUL     8'b0000_0101

`define ALU_OP_VMAC_LW  8'b0000_0110
`define ALU_OP_VMAC_SW  8'b0000_0111
`define ALU_OP_VMAC_EN  8'b0000_1000

// ======================================
// SCALAR INSTRUCTIONS
// ======================================
`define OPCODE_ADDI     7'b001_0011
`define FUNCT3_ADDI     3'b111

`define OPCODE_LW       7'b000_0011
`define FUNCT3_LW       3'b010

`define OPCODE_SW       7'b010_0011 
`define FUNCT3_SW       3'b010

`define OPCODE_BNE      7'b110_0011
`define FUNCT3_BNE      3'b001

`define OPCODE_ADD      7'b011_0011
`define FUNCT3_ADD      3'b000
`define FUNCT7_ADD      7'b000_0000

`define OPCODE_MUL      7'b011_0011 
`define FUNCT3_MUL      3'b000
`define FUNCT7_MUL      7'b000_0001

// ======================================
// VECTOR INSTRUCTIONS
// ======================================
`define OPCODE_VL       7'b000_0111 
`define FUNCT3_VLE32    3'b110
`define FUNCT6_VLE32    6'b00_0000

`define OPCODE_VS       7'b010_0111
`define FUNCT3_VSE32    3'b110
`define FUNCT6_VSE32    6'b00_0000

`define OPCODE_IVV      7'b101_0111 
`define FUNCT3_IVV      3'b000 

`define FUNCT6_VADD_VV  6'b00_0000 
`define FUNCT6_VMUL_VV  6'b10_0101 

// ======================================
// CUSTOM INSTRUCTIONS
// ======================================
`define FUNCT6_VMAC_LW  6'b00_0001 
`define FUNCT6_VMAC_SW  6'b00_1000 
`define FUNCT6_VMAC_EN  6'b11_0100 