`timescale 1ns / 1ps

module pe #(
    parameter M = 5,
    parameter N = 3,
    parameter K = 4,
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

always@(posedge clk or posedge rst) begin
    if (rst) begin
        x_out <= 0;
        y_out <= 0;
    end
    else begin
        y_out <= y_in + x_in * w;
        x_out <= x_in;
    end
end

endmodule