`include "defines.v"

module vregfile(
    input clk,
    input rst,

    input                   w_ena_i,
    input [`VREG_ADDR_BUS]  w_addr_i,
    input [`VREG_BUS]       w_data_i,

    input                   r_ena1_i,
    input [`VREG_ADDR_BUS]  r_addr1_i,
    output reg [`VREG_BUS]  r_data1_o,

    input                   r_ena2_i,
    input [`VREG_ADDR_BUS]  r_addr2_i,
    output reg [`VREG_BUS]  r_data2_o
);

reg [`VREG_BUS]     vregs [31:0] ;


endmodule