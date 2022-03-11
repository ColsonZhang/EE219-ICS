`timescale 1ns / 1ps
`define ARR_SIZE 4
`define IMG_W 4
`define IMG_H 5
`define FILTER_NUM 7
`define FILTER_SIZE 3
`define DEBUG 0

module top(
    input clk
);


parameter ARR_SIZE = `ARR_SIZE;
parameter IMG_W = `IMG_W;
parameter IMG_H = `IMG_H;
parameter FILTER_SIZE = `FILTER_SIZE;
parameter M_in = `FILTER_NUM;
parameter M = (M_in >= ARR_SIZE && M_in % ARR_SIZE == 0) ? M_in : (M_in / ARR_SIZE + 1) * ARR_SIZE;
parameter N = FILTER_SIZE * FILTER_SIZE;
parameter K_in = IMG_W * IMG_H;
parameter K = (K_in >= ARR_SIZE && K_in % ARR_SIZE == 0) ? K_in : (K_in / ARR_SIZE + 1) * ARR_SIZE;
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 32;
parameter ACC_WIDTH = 32;

parameter MEM_SIZE = 32'h00005000;
parameter IMG_BASE = 32'h00000000;
parameter WEIGHT_BASE = 32'h00001000;
parameter IM2COL_BASE = 32'h00002000;
parameter OUTPUT_BASE = 32'h00003000;

reg rst_systolic;
reg rd_en_A;
reg rd_en_B;

integer rd_addr_A, rd_addr_B;
wire [31:0] pixel_cntr_A, pixel_cntr_B, slice_cntr_A, slice_cntr_B;

reg [ARR_SIZE*DATA_WIDTH-1:0] A;
reg [ARR_SIZE*DATA_WIDTH-1:0] B;
wire [ARR_SIZE*DATA_WIDTH-1:0] A_pipe;
wire [ARR_SIZE*DATA_WIDTH-1:0] B_pipe;
wire [ACC_WIDTH*ARR_SIZE*ARR_SIZE-1:0] D;

reg [DATA_WIDTH*ARR_SIZE-1:0] buffer_A [0:(N*M)/ARR_SIZE-1];
reg [DATA_WIDTH*ARR_SIZE-1:0] buffer_B [0:(N*K)/ARR_SIZE-1];

reg [2:0] rst_pe = 3'b00;
reg init = 0;
reg [31:0] patch =1;

wire [ARR_SIZE-1:0] init_pe_pipe [ARR_SIZE-1:0];
assign rd_addr_A = slice_cntr_A * N + pixel_cntr_A;
assign rd_addr_B = slice_cntr_B * N + pixel_cntr_B;

reg enable_row_count_A = 1;
wire [ARR_SIZE*ARR_SIZE-1:0] valid_D;
reg [31:0] valid_cnt[ARR_SIZE-1:0][ARR_SIZE-1:0];
reg systolic_done;
genvar i, j, k;
integer i0, j0, k0;
reg [31:0] im2col_idle, systolic_idle;
reg [31:0] clk_cnt;

wire [ADDR_WIDTH-1:0] addr_rd, addr_wr;
reg [DATA_WIDTH-1:0] mem [MEM_SIZE-1:0];
reg [DATA_WIDTH-1:0] data_rd;
wire [DATA_WIDTH-1:0] data_wr;
wire mem_wr_en;
reg rst_im2col;
wire im2col_done;

initial begin
    $readmemh("../mem/mem_init.txt", mem);
    im2col_idle = 5;
    systolic_idle = 5;
end

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

always @(posedge clk or posedge rst_im2col) begin
    if (rst_im2col) begin
        clk_cnt <= 0;
    end
    else begin
        clk_cnt <= clk_cnt + 1;
    end
end

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
    .rst_im2col(rst_im2col),
    .data_rd(data_rd),
    .data_wr(data_wr),
    .addr_rd(addr_rd),
    .addr_wr(addr_wr),
    .im2col_done(im2col_done),
    .mem_wr_en(mem_wr_en)
);

systolic #(
    .M(M),
    .N(N),
    .K(K),
    .ARR_SIZE(ARR_SIZE),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
)
systolic_array
(
    .clk(clk),
    .rst(rst_systolic),
    .enable_row_count_A(enable_row_count_A),
    .slice_cntr_A(slice_cntr_A),
    .slice_cntr_B(slice_cntr_B),
    .pixel_cntr_A(pixel_cntr_A),
    .pixel_cntr_B(pixel_cntr_B),
    .A(A_pipe),
    .B(B_pipe), 
    .D(D),
    .valid_D(valid_D)
);

for (i = 0; i < ARR_SIZE; i = i + 1) begin
    for (j = 0; j < ARR_SIZE; j = j + 1) begin
        pipe#(
            .DATA_WIDTH(1),
            .pipes(i+j+1)
        )
        pipe_inst_rst(
            .clk(clk),
            .rst(),
            .in_p(rst_pe[0]),
            .out_p(init_pe_pipe[i][j])
        );
    end
end

assign A_pipe[DATA_WIDTH-1:0] = A[DATA_WIDTH-1:0];
for (i = 1; i < ARR_SIZE; i = i + 1) begin
    pipe#(
        .DATA_WIDTH(DATA_WIDTH),
        .pipes(i)
    )
    pipe_inst_A (
        .clk(clk),
        .rst(rst_systolic),
        .in_p(A[((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH]),
        .out_p(A_pipe[((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH])
    );
end

assign B_pipe[DATA_WIDTH-1:0] = B[DATA_WIDTH-1:0];
for (i = 1; i < ARR_SIZE; i = i + 1) begin
    pipe#(
        .DATA_WIDTH(DATA_WIDTH),
        .pipes(i)
    )
    pipe_inst_B(
        .clk(clk),
        .rst(rst_systolic),
        .in_p(B[((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH]),
        .out_p(B_pipe[((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH])
    );
end

always@(posedge clk) begin
    rst_systolic <= rst_systolic >> 1;
    if (rst_systolic) begin
        rd_en_A <= 1;
        rd_en_B <= 1;
        A <= 0;
        B <= 0;
        rst_pe <= 3'b0;
        enable_row_count_A <= 1'b0;
        patch <= 1;
    end
    else begin
        if (rd_en_A) begin
            A  <= buffer_A[rd_addr_A];
        end

        if (rd_en_B) begin
            B  <= buffer_B[rd_addr_B];
        end

        if (pixel_cntr_A == N-1)
		begin
			rst_pe <= 3'b01;
		end
		else
		begin
			rst_pe <= rst_pe >> 1;
		end

        if (enable_row_count_A == 1'b1) begin
            enable_row_count_A <= 1'b0;
        end
        else if (pixel_cntr_A == N-2 && patch == (K/ARR_SIZE)) begin
            patch <= 1;
            enable_row_count_A <= ~enable_row_count_A;
        end
        else if (pixel_cntr_A == N-2) begin
            patch <= patch + 1 ;
        end
    end
end


`define BLOCK_I (valid_cnt[i][j] / (K / ARR_SIZE))
`define BLOCK_J (valid_cnt[i][j] % (K / ARR_SIZE))
`define D_I_J D[ACC_WIDTH*(i*ARR_SIZE+j+1)-1 : ACC_WIDTH*(i*ARR_SIZE+j)]

for ( i = 0; i < ARR_SIZE; i = i + 1) begin
    for (j = 0; j < ARR_SIZE; j = j + 1) begin
        always@(posedge clk) begin
            if (rst_systolic) begin
                valid_cnt[i][j] <= 0;
            end
            else if (valid_D[i*ARR_SIZE+j]==1'b1) begin
                valid_cnt[i][j] <= valid_cnt[i][j] + 1;
                if (`DEBUG) begin
                    $write("PE[%0d][%0d]: 0x%04H, valid at time %0d\n", i, j, `D_I_J, clk_cnt);
                end
                if (`BLOCK_I*ARR_SIZE+i < M_in && `BLOCK_J*ARR_SIZE+j < K_in) begin
                    mem[OUTPUT_BASE + (`BLOCK_I*ARR_SIZE+i)*K_in + `BLOCK_J*ARR_SIZE+j] <= `D_I_J;
                end
            end
        end
    end
end

always @(posedge clk) begin
    if (rst_systolic) begin
        systolic_done <= 0;
    end
    else if (valid_cnt[ARR_SIZE-1][ARR_SIZE-1] == (M*K)/(ARR_SIZE*ARR_SIZE) || (clk_cnt > 2990)) begin
        systolic_done <= 1;
    end
end

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
        for (j0 = 0; j0 < K; j0 = j0 + 1) begin
            $write("%04h ", mem[IM2COL_BASE + N * j0 + i0]);
        end
        $write("\n");
    end
end
endtask

task display_weight();
begin
    $write("\nweight:\n");
    for (i0 = 0; i0 < M; i0 = i0 + 1) begin
        for (j0 = 0; j0 < N; j0 = j0 + 1) begin
            $write("%04h ", mem[WEIGHT_BASE + N * i0 + j0]);
        end
        $write("\n");
    end
end
endtask

task display_output();
begin
    $write("\noutput:\n");
    for (i0 = 0; i0 < M_in; i0 = i0 + 1) begin
        for (j0 = 0; j0 < K_in; j0 = j0 + 1) begin
            $write("%004h ", mem[OUTPUT_BASE+i0*K_in+j0]);
        end
        $write("\n");
    end
end
endtask

always @(posedge systolic_done) begin
    $writememh("../mem/mem_out.txt", mem);
    if (`DEBUG) begin
        $write("image size: %0d*%0d\n", IMG_H, IMG_W);
        $write("filter size: %0d*%0d\n", FILTER_SIZE, FILTER_SIZE);
        $write("number of filters: %0d\n", M);
        display_img();
        display_weight();
        display_im2col();
        display_output();
    end
end

`define BUF_A_IJK buffer_A[N*k+i][DATA_WIDTH*(j+1)-1:DATA_WIDTH*j]
`define BUF_B_IJK buffer_B[N*k+i][DATA_WIDTH*(j+1)-1:DATA_WIDTH*j]
`define WEIGHT_IJK mem[WEIGHT_BASE+(ARR_SIZE*k+j)*N+i]
`define IM2COL_IJK mem[IM2COL_BASE+(ARR_SIZE*k+j)*N+i]
for (k = 0; k < M/ARR_SIZE; k = k + 1) begin
    for (i = 0; i < N; i = i + 1) begin
        for (j = 0; j < ARR_SIZE; j = j + 1) begin
            always @(posedge im2col_done) begin
                `BUF_A_IJK <= `WEIGHT_IJK;
            end
            
        end
    end
end
for (k = 0; k < K/ARR_SIZE; k = k + 1) begin
    for (i = 0; i < N; i = i + 1) begin
        for (j = 0; j < ARR_SIZE; j = j + 1) begin
            always @(posedge im2col_done) begin
                `BUF_B_IJK <= `IM2COL_IJK;
            end
            
        end
    end
end

endmodule
























