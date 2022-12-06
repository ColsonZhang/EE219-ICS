`include "defines.v"

module inst_fetch(
    input                       clk,
    input                       rst,

    input                       transfer_en_i,
    input   [`INST_ADDR_BUS]    transfer_pc_i,
    output  [`INST_ADDR_BUS]    current_pc_o,

    output                      inst_en_o,
    output  [`INST_ADDR_BUS]    inst_addr_o
);

reg [`INST_ADDR_BUS]    pc ;
reg [`INST_ADDR_BUS]    addr ;

always @( posedge clk ) begin
    if( rst == 1'b1 ) begin
        pc <= `PC_START ;
        addr <= `PC_START ;
    end else begin
        if( transfer_en_i ) begin
            pc <= transfer_pc_i + 4 ;
            addr <= transfer_pc_i ;
        end else begin
            pc <= pc + 4 ;
            addr <= pc ;
        end
    end
end

assign current_pc_o = addr ;
assign inst_addr_o = addr ;
assign inst_en_o = ( rst != 1'b1 ) ;


endmodule