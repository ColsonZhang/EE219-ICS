`timescale 1ns / 1ps

module systolic_array#(
    parameter M = 5,
    parameter N = 3,
    parameter K = 4,
    parameter DATA_WIDTH = 32
) (
    input clk,
    input rst,
    input [DATA_WIDTH*N-1:0] X,
    input [DATA_WIDTH*N*K-1:0] W,
    output reg [DATA_WIDTH*K-1:0] Y,
    output valid
);

wire [DATA_WIDTH*N-1:0] X_pipe;
wire [DATA_WIDTH*K-1:0] Y_pipe;
reg [31:0] count;

array #(
    .M(M),
    .N(N),
    .K(K),
    .DATA_WIDTH(DATA_WIDTH)
)array(
    .clk(clk),
    .rst(rst),
    .X(X_pipe),
    .W(W),
    .Y(Y_pipe)
);

genvar i;

assign X_pipe[DATA_WIDTH-1:0] = X[DATA_WIDTH-1:0];
for(i = 1; i < N; i = i + 1) begin
    pipe#(
        .DATA_WIDTH(DATA_WIDTH),
        .pipes(i)
    )pipes_X(
        .clk(clk),
        .rst(rst),
        .in_p(X[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH]),
        .out_p(X_pipe[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH])
    );
end

assign Y[K*DATA_WIDTH-1:(K-1)*DATA_WIDTH] = Y_pipe[K*DATA_WIDTH-1:(K-1)*DATA_WIDTH];
for(i = 1; i < K; i = i + 1) begin
    pipe#(
        .DATA_WIDTH(DATA_WIDTH),
        .pipes(i)
    )pipes_Y(
        .clk(clk),
        .rst(rst),
        .in_p(Y_pipe[(K-i)*DATA_WIDTH-1:(K-i-1)*DATA_WIDTH]),
        .out_p(Y[(K-i)*DATA_WIDTH-1:(K-i-1)*DATA_WIDTH])
    );
end

always@(posedge clk or posedge rst) begin
    if (rst) begin
        valid <= 0;
        count <= 0;
    end
    else begin
        count <= count + 1;
        if (count > N+K-1 && count < N+K+M-1) begin
            valid <= 1;
        end
    end
end

endmodule