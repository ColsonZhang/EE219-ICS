`timescale 1ns / 1ps
module im2col #(
    parameter IMG_W = 8,
    parameter IMG_H = 8,
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 32,
    parameter FILTER_SIZE = 3,
    parameter IMG_BASE = 16'h0000,
    parameter IM2COL_BASE = 16'h2000
) (
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] data_rd,
    output [DATA_WIDTH-1:0] data_wr,
    output [ADDR_WIDTH-1:0] addr_wr,
    output [ADDR_WIDTH-1:0] addr_rd,
    output reg done,
    output reg mem_wr_en
);

endmodule