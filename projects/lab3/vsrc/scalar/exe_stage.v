`include "defines.v"

module exe_stage(
    input                   rst,
    
    input [`ALU_OP_BUS]     alu_opcode_i,
    input [`REG_BUS]        operand_rs1_i,
    input [`REG_BUS]        operand_rs2_i,

    output reg [`REG_BUS]   exe_result_o
);

always @( * ) begin
    if( rst == 1'b1 ) begin
        exe_result_o = 0 ;
    end
    else begin
        case( alu_opcode_i )
            `ALU_OP_ADD: begin
                exe_result_o = operand_rs1_i + operand_rs2_i ;
            end
            `ALU_OP_NOP: begin
                exe_result_o = 0 ;
            end
            `ALU_OP_BNE: begin
                exe_result_o = ( operand_rs1_i != operand_rs2_i ) ? 1 : 0 ;
            end
            default: begin
                exe_result_o = 0 ;
            end
        endcase
    end
end

endmodule