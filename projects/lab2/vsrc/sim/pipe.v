`timescale 1ns / 1ps

module pipe #(
    parameter integer DATA_WIDTH = 8,
    parameter integer pipes = 10
)
(
    input                     clk,
    input                     rst,
    input   wire    [DATA_WIDTH-1:0]  in_p,
    output  wire    [DATA_WIDTH-1:0]  out_p
);

reg [DATA_WIDTH-1:0]    regs    [pipes-1:0];

always@(posedge clk) begin
    if (rst) begin
        regs[0] <= 0;
    end
    else begin
        regs[0] <= in_p;
    end
end

assign  out_p = regs[pipes-1]; 

genvar i;
for (i = 1; i < pipes; i = i+1) begin
    always@(posedge clk) begin
        if(rst) begin
            regs[i] <= 0;
        end
        else begin
            regs[i] <= regs[i-1];
        end
    end
end

endmodule
