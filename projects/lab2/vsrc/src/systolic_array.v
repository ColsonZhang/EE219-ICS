`timescale 1ns / 1ps

module systolic_array #(
    parameter M = 5,
    parameter N = 3,
    parameter K = 4,
    parameter DATA_WIDTH = 32
) (
    input clk,
    input rst,
    input [DATA_WIDTH*N-1:0] X,
    input [DATA_WIDTH*N*K-1:0] W,
    output reg [DATA_WIDTH*K-1:0] Y
);

wire [DATA_WIDTH-1:0] x_out_arr[N-1:0][K-1:0];
wire [DATA_WIDTH-1:0] y_out_arr[N-1:0][K-1:0];
wire [DATA_WIDTH-1:0] x_in_arr[N-1:0][K-1:0];
wire [DATA_WIDTH-1:0] y_in_arr[N-1:0][K-1:0];
wire [DATA_WIDTH-1:0] w_arr[N-1:0][K-1:0];

genvar i, j, k;

for (i = 0; i < N; i = i + 1) begin
    for (j = 0; j < K; j = j + 1) begin
        assign w_arr[i][j] = W[(i*K+j+1)*DATA_WIDTH-1:(i*K+j)*DATA_WIDTH];
    end
end

for (j = 0; j < K; j = j + 1) begin
    assign Y[(j+1)*DATA_WIDTH-1:j*DATA_WIDTH] = y_out_arr[N-1][j];
end

for (i = 0; i < N; i = i + 1) begin
    for (j = 0; j < K; j = j + 1) begin
        if (i > 0 && j > 0) begin
            pe#(
                .M(M),
                .N(N),
                .K(K),
                .DATA_WIDTH(DATA_WIDTH)
            )pe_body(
                .clk(clk),
                .rst(rst),
                .w(w_arr[i][j]),
                .x_in(x_out_arr[i][j-1]),
                .y_in(y_out_arr[i-1][j]),
                .x_out(x_out_arr[i][j+1]),
                .y_out(y_out_arr[i+1][j])
            );
        end
        if (i == 0 && j ==0) begin
            pe#(
                .M(M),
                .N(N),
                .K(K),
                .DATA_WIDTH(DATA_WIDTH)
            )pe_upper_left(
                .clk(clk),
                .rst(rst),
                .w(w_arr[i][j]),
                .x_in(X[DATA_WIDTH-1:0]),
                .y_in(0),
                .x_out(x_out_arr[i][j+1]),
                .y_out(y_out_arr[i+1][j])
            );
        end
        if (i > 0 && j == 0) begin
            pe#(
                .M(M),
                .N(N),
                .K(K),
                .DATA_WIDTH(DATA_WIDTH)
            )pe_left_col(
                .clk(clk),
                .rst(rst),
                .w(w_arr[i][j]),
                .x_in(X[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH]),
                .y_in(y_out_arr[i-1][j]),
                .x_out(x_out_arr[i][j+1]),
                .y_out(y_out_arr[i+1][j])
            );
        end
        if (i == 0 && j > 0) begin
            pe#(
                .M(M),
                .N(N),
                .K(K),
                .DATA_WIDTH(DATA_WIDTH)
            )pe_top_row(
                .clk(clk),
                .rst(rst),
                .w(w_arr[i][j]),
                .x_in(x_out_arr[i][j-1]),
                .y_in(0),
                .x_out(x_out_arr[i][j+1]),
                .y_out(y_out_arr[i+1][j])
            );
        end
    end
end



endmodule