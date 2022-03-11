`timescale 1ns / 1ps

module systolic #(
    parameter M = 12,
    parameter N = 6,
    parameter K = 8,
    parameter ARR_SIZE = 4,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
)(
    input clk,
    input rst,
    input enable_row_count_A,
    input [DATA_WIDTH*ARR_SIZE-1:0] A,
    input [DATA_WIDTH*ARR_SIZE-1:0] B,
    output [ACC_WIDTH*ARR_SIZE*ARR_SIZE-1:0] D,
    output [ARR_SIZE*ARR_SIZE-1:0] valid_D,
    output [31:0] pixel_cntr_A,
    output [31:0] slice_cntr_A,
    output [31:0] pixel_cntr_B,
    output [31:0] slice_cntr_B
);

endmodule

