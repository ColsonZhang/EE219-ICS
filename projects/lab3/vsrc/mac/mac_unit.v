`include "defines.v"

module mac_unit(
    input               clk,
    input               rst,
    input [`ALU_OP_BUS] alu_opcode_i,
    input [2 : 0]       mac_sel_i,

  	input [`VREG_BUS]   mac_op_v1_i,
  	input [`VREG_BUS]   mac_op_v2_i,
    output [`VREG_BUS]  mac_result_o
);


endmodule