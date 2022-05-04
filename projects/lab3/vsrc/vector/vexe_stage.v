`include "defines.v"

module vexe_stage(
    input                   rst,
    input [`ALU_OP_BUS]     alu_opcode_i,
    input [`VREG_BUS]       operand_vs1_i,
    input [`VREG_BUS]       operand_vs2_i,

    output reg [`VREG_BUS]  vexe_result_o
);



endmodule