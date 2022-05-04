`include "defines.v"

module mem_stage (
    input                   rst,

    input                   mem_r_ena_i,
    input [`MEM_ADDR_BUS]   mem_r_addr_i,
    output [`MEM_DATA_BUS]  mem_r_data_o,

    input                   mem_w_ena_i,
    input [`MEM_ADDR_BUS]   mem_w_addr_i,
    input [`MEM_DATA_BUS]   mem_w_data_i,

    output                  ram_r_ena_o,
    input [`RAM_DATA_BUS]   ram_r_data_i,
    output [`RAM_ADDR_BUS]  ram_r_addr_o,

    output                  ram_w_ena_o,
    output [`RAM_ADDR_BUS]  ram_w_addr_o,
    output [`RAM_DATA_BUS]  ram_w_data_o,
    output [`RAM_DATA_BUS]  ram_w_mask_o
);

assign ram_r_ena_o = mem_r_ena_i ;
assign ram_r_addr_o = mem_r_addr_i ;
assign mem_r_data_o = mem_r_addr_i[2] ? ram_r_data_i[63:32] : ram_r_data_i[31: 0] ;

assign ram_w_ena_o  = 0 ;
assign ram_w_addr_o = 0 ;
assign ram_w_data_o = 0 ;
assign ram_w_mask_o = 0 ;


endmodule