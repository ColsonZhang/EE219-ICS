`timescale 1ns / 1ps

module pe #(
    parameter N = 8,
    parameter MAX_CNT = 8,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
)(
    input clk,
    input rst,
    input init,
    input [DATA_WIDTH-1:0] in_a,
    input [DATA_WIDTH-1:0] in_b,
    output reg [DATA_WIDTH-1:0] out_a,
    output reg [DATA_WIDTH-1:0] out_b,
    output [ACC_WIDTH-1:0] out_sum,
    output valid_D
);

endmodule