`include "defines.v"

module execute(
    input                           rst,

    // the alu signals
    input       [`ALU_OP_BUS]       alu_opcode_i,
    input       [`REG_BUS]          operand_rs1_i,
    input       [`REG_BUS]          operand_rs2_i,
    output      [`REG_BUS]          exe_result_o,

    // the branching singals
    input       [`INST_ADDR_BUS]    current_pc_i,
    input                           branch_en_i,
    input       [`INST_ADDR_BUS]    branch_offset_i,
    input                           jump_en_i,
    input       [`INST_ADDR_BUS]    jump_offset_i,

    // the branching signal sent to inst_fetch.v
    output                          transfer_en_o,
    output      [`INST_ADDR_BUS]    transfer_pc_o
);

reg [`REG_BUS] alu_result ;

always @(*) begin
    if( rst == 1'b1 ) begin
        alu_result = 0 ;
    end else begin
        case ( alu_opcode_i )
            `ALU_OP_ADD:    alu_result = ( operand_rs1_i + operand_rs2_i   ) ;
            // hint: add more operations
            `ALU_OP_NOP:    alu_result = 0 ;
            default:        alu_result = 0 ;
        endcase
    end
end

// The execute_stage result
assign exe_result_o     =   ( jump_en_i )       ?   ( current_pc_i+4 ) : ( alu_result ) ;

// Control Branching
assign transfer_en_o    =   1'b0 ;
assign transfer_pc_o    =   `PC_START ;

endmodule
