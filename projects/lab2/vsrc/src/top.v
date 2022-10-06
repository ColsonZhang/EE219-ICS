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
reg [DATA_WIDTH*K-1:0] Y;
reg [DATA_WIDTH*N*K-1:0] W;

systolic_array #(
    .M(M),
    .N(N),
    .K(K),
    .DATA_WIDTH(DATA_WIDTH)
)systolic_array(
    .clk(clk),
    .rst(rst),
    .X(X),
    .W(W),
    .Y(Y)
);

// wire [DATA_WIDTH*N-1:0] X_pipe;
// reg [DATA_WIDTH*N-1:0] X;
// reg [DATA_WIDTH*N*K-1:0] W;
// wire [DATA_WIDTH*K-1:0] Y_pipe;
// reg [DATA_WIDTH*K-1:0] Y;

// systolic_array #(
//     .M(M),
//     .N(N),
//     .K(K),
//     .DATA_WIDTH(DATA_WIDTH)
// )array(
//     .clk(clk),
//     .rst(rst),
//     .X(X_pipe),
//     .W(W),
//     .Y(Y_pipe)
// );

// genvar i;

// assign X_pipe[DATA_WIDTH-1:0] = X[DATA_WIDTH-1:0];
// for(i = 1; i < N; i = i + 1) begin
//     pipe#(
//         .DATA_WIDTH(DATA_WIDTH),
//         .pipes(i)
//     )pipes_X(
//         .clk(clk),
//         .rst(rst),
//         .in_p(X[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH]),
//         .out_p(X_pipe[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH])
//     );
// end

// assign Y[K*DATA_WIDTH-1:(K-1)*DATA_WIDTH] = Y_pipe[K*DATA_WIDTH-1:(K-1)*DATA_WIDTH];
// for(i = 1; i < K; i = i + 1) begin
//     pipe#(
//         .DATA_WIDTH(DATA_WIDTH),
//         .pipes(i)
//     )pipes_Y(
//         .clk(clk),
//         .rst(rst),
//         .in_p(Y_pipe[(K-i)*DATA_WIDTH-1:(K-i-1)*DATA_WIDTH]),
//         .out_p(Y[(K-i)*DATA_WIDTH-1:(K-i-1)*DATA_WIDTH])
//     );
// end

reg [31:0] rst_cyc;
reg [31:0] clk_cnt;

initial begin
    rst_cyc = 5;
    clk_cnt = 0;
    W = 96'h020102010102010202010201;
    // X = 24'h010203;
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

always@(posedge clk) begin
    clk_cnt <= clk_cnt + 1;
    case (clk_cnt) 
        5: X <= 24'h010203;
        6: X <= 24'h030201;
        7: X <= 24'h010302;
        default: X <= 0;
    endcase
end

endmodule