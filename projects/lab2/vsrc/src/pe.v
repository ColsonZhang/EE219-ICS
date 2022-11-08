`timescale 1ns / 1ps

module pe #(
    parameter DATA_WIDTH = 32
) (
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] w,
    input [DATA_WIDTH-1:0] x_in,
    input [DATA_WIDTH-1:0] y_in,
    output reg [DATA_WIDTH-1:0] x_out,
    output reg [DATA_WIDTH-1:0] y_out
);

endmodule