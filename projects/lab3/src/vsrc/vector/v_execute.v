`include "defines.v"

module v_execute(
    input                   rst,
    input [`ALU_OP_BUS]     alu_opcode_i,
    input [`VREG_BUS]       operand_vs1_i,
    input [`VREG_BUS]       operand_vs2_i,
    output reg [`VREG_BUS]  vexe_result_o
);

genvar i ;

for(i=0; i < `VLMAX; i=i+1)begin
    always @(*) begin
        if(rst) begin
            vexe_result_o = 0 ;
        end
        else begin
            case( alu_opcode_i ) 
                `VALU_OP_NOP: begin 
                    vexe_result_o = 0 ;
                end 
                default: begin
                    vexe_result_o = 0 ;
                end
            endcase
        end
    end
end


endmodule