`include "defines.v"

module if_stage(
    input clk,
    input rst,

    input                   pc_branch_i,
    input [`INST_ADDR_BUS]  pc_in_i,
    output [`INST_ADDR_BUS] pc_out_o,

    output [`INST_ADDR_BUS] inst_addr_o,
    output inst_ena_o
);


reg [`INST_ADDR_BUS] pc;
reg [`INST_ADDR_BUS] the_addr;

always@( posedge clk )
begin
    if( rst == 1'b1 ) begin
        pc <= `PC_START ;
    end
    else begin
        if(pc_branch_i) begin
            pc <= pc_in_i + 4 ;
            the_addr <= pc_in_i ;
        end
        else begin
            pc <= pc + 4;
            the_addr <= pc ;
        end
    end
end

assign pc_out_o = pc ;
assign inst_addr_o = the_addr;
assign inst_ena_o  = ( rst == 1'b1 ) ? 1'b0 : 1'b1;

endmodule