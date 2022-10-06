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

parameter WEIGHT_SIZE = FILTER_SIZE * FILTER_SIZE;
reg [ADDR_WIDTH-1:0] cntr, cntr_wr;
wire i_valid, j_valid, padding;
reg padding_wr;
wire [ADDR_WIDTH-1:0] img_i, img_j, kernel_i, kernel_j, img_row, img_col;
reg [ADDR_WIDTH-1:0] addr_wr_reg0, addr_wr_reg1;

assign kernel_j = cntr % FILTER_SIZE;
assign kernel_i = (cntr / FILTER_SIZE) % FILTER_SIZE;
assign img_j = (cntr / WEIGHT_SIZE) % IMG_W;
assign img_i = (cntr / (WEIGHT_SIZE * IMG_W)) % IMG_H;
assign img_row = img_i + kernel_i - 1;
assign img_col = img_j + kernel_j - 1;
assign i_valid = (img_row < IMG_H) ? 1 : 0;
assign j_valid = (img_col < IMG_W) ? 1 : 0;
assign padding = (i_valid & j_valid) ? 0 : 1;
assign addr_rd = (padding) ? 0 : IMG_BASE + img_row * IMG_W + img_col;
assign addr_wr = IM2COL_BASE + cntr_wr;
assign data_wr = (padding_wr) ? 0 : data_rd;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cntr <= 0;
        cntr_wr <= 0;
        mem_wr_en <= 0;
        done <= 0;
    end
    else begin
        if (cntr < IMG_W * IMG_H * WEIGHT_SIZE) begin
            mem_wr_en <= 1;
            cntr <= cntr + 1;
            cntr_wr <= cntr;
            padding_wr <= padding;
        end
        else begin
            mem_wr_en <= 0;
            done <= 1;
        end
    end
end

endmodule