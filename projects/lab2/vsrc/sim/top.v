`timescale 1ns / 1ps
`define IMG_W 4
`define IMG_H 5
`define FILTER_NUM 5
`define FILTER_SIZE 3
`define DEBUG 0

module pe_top_row(
    input clk
);

parameter IMG_H = `IMG_H;
parameter IMG_W = `IMG_W;
parameter FILTER_NUM = `FILTER_NUM;
parameter FILTER_SIZE = `FILTER_SIZE;
parameter M = `IMG_H * `IMG_W;
parameter N = `FILTER_SIZE * `FILTER_SIZE;
parameter K = `FILTER_NUM;
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32;

parameter MEM_SIZE = 32'h00005000;
parameter IMG_BASE = 32'h00000000;
parameter WEIGHT_BASE = 32'h00001000;
parameter IM2COL_BASE = 32'h00002000;
parameter OUTPUT_BASE = 32'h00003000;

reg rst;
reg [DATA_WIDTH*N-1:0] X;
reg [DATA_WIDTH*K-1:0] Y;
wire [DATA_WIDTH*N*K-1:0] W;

reg [DATA_WIDTH*N-1:0] X_buffer [0:M];
reg [DATA_WIDTH*K-1:0] Y_buffer [0:M];
reg [DATA_WIDTH-1:0] W_buffer [N-1:0][K-1:0];

genvar i, j, k;
for (i = 0; i < N; i = i + 1) begin
    for (j = 0; j < K; j = j + 1) begin
        assign W[(i*K+j+1)*DATA_WIDTH-1:(i*K+j)*DATA_WIDTH] = W_buffer[i][j];
    end
end

wire [ADDR_WIDTH-1:0] addr_rd, addr_wr;
reg [DATA_WIDTH-1:0] mem [MEM_SIZE-1:0];
reg [DATA_WIDTH-1:0] data_rd;
wire [DATA_WIDTH-1:0] data_wr;
wire mem_wr_en;

reg [31:0] rst_cyc;
reg [31:0] clk_cnt;
reg rst_im2col, rst_systolic;
wire im2col_done, systolic_done;
reg [31:0] im2col_idle, systolic_idle;

im2col #(
    .IMG_W(IMG_W),
    .IMG_H(IMG_H),
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .FILTER_SIZE(FILTER_SIZE),
    .IMG_BASE(IMG_BASE),
    .IM2COL_BASE(IM2COL_BASE)
)im2col(
    .clk(clk),
    .rst(rst_im2col),
    .data_rd(data_rd),
    .data_wr(data_wr),
    .addr_rd(addr_rd),
    .addr_wr(addr_wr),
    .done(im2col_done),
    .mem_wr_en(mem_wr_en)
);

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

integer i0, j0, k0;
task display_img();
begin
    $write("\nimage:\n");
    for (i0 = 0; i0 < IMG_H; i0 = i0 + 1) begin
        for (j0 = 0; j0 < IMG_W; j0 = j0 + 1) begin
            $write("%04h ", mem[IMG_BASE + IMG_W * i0 + j0]);
        end
        $write("\n");
    end
end
endtask

task display_im2col();
begin
    $write("\nim2col:\n");
    for (i0 = 0; i0 < N; i0 = i0 + 1) begin
        for (j0 = 0; j0 < M; j0 = j0 + 1) begin
            $write("%04h ", mem[IM2COL_BASE + N * j0 + i0]);
        end
        $write("\n");
    end
end
endtask

task load_weight();
begin
    $write("\nweight:\n");
    for (i0 = 0; i0 < N; i0 = i0 + 1) begin
        for (j0 = 0; j0 < K; j0 = j0 + 1) begin
            W_buffer[i0][j0] = mem[WEIGHT_BASE + K*j0 + i0];
            $write("%04h ", mem[WEIGHT_BASE + K*j0 + i0]);
        end
        $write("\n");
    end
end
endtask

// Memory
always @(posedge clk) begin
    data_rd <= mem[addr_rd];
    if (mem_wr_en) begin
        mem[addr_wr] <= data_wr;
    end
end


always @(posedge clk) begin
    if (im2col_idle == 0) begin
        rst_im2col <= 0;
    end
    else begin
        im2col_idle <= im2col_idle - 1;
        rst_im2col <= 1;
    end
end

always @(posedge clk) begin
    if (~im2col_done) begin
        rst_systolic <= 1;
    end
    else begin
        if (systolic_idle == 0) begin
            rst_systolic <= 0;
        end
        else begin
            systolic_idle <= systolic_idle - 1;
        end
    end
end

// Load weight


initial begin
    $readmemh("../mem/mem_init.txt", mem);
    rst_cyc = 5;
    im2col_idle = 5;
    systolic_idle = 5;
end

always@(posedge im2col_done) begin
    $writememh("../mem/mem_out.txt", mem);
    // load_weight();
    // display_img();
    // display_im2col();
end

endmodule