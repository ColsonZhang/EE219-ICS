`timescale 1ns / 1ps
`define M 5
`define N 3
`define K 4
`define DATA_WIDTH 8

module top#(
    parameter M = `M,
    parameter N = `N,
    parameter K = `K,
    parameter DATA_WIDTH = `DATA_WIDTH
)(
    input clk
);

reg rst;
reg [DATA_WIDTH*N-1:0] X;
reg [DATA_WIDTH*N*K-1:0] W;
reg [DATA_WIDTH*K-1:0] Y;

systolic_array #(
    .M(M),
    .N(N),
    .K(K),
    .DATA_WIDTH(DATA_WIDTH)
)array(
    .clk(clk),
    .rst(rst),
    .X(X),
    .W(W),
    .Y(Y)
);

reg [31:0] rst_cyc;

initial begin
    rst_cyc = 5;
    W = 96'h010201020102010201020102;
    X = 24'h000002;
end

always@(posedge clk) begin
    if(rst_cyc == 0) begin
        rst <= 0;
    end
    else begin
        rst_cyc <= rst_cyc - 1;
        rst <= 1;
    end
end

endmodule