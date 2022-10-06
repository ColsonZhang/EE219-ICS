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

    reg [DATA_WIDTH-1:0] data_out;
    reg [ADDR_WIDTH-1:0] addr_wr_a,addr_rd_a;
    wire [ADDR_WIDTH-1:0] addr_wr_a,addr_rd_a;
    wire [DATA_WIDTH-1:0] data_out;
    reg [DATA_WIDTH-1:0] count;
    

    always @(posedge clk or posedge rst )
    begin
        if (rst)
            begin
              count =0;
            end
        else if (count==IMG_W*IMG_H*FILTER_SIZE*FILTER_SIZE)
            begin
               count =0;
            end
        else 
            begin
               count =count+1;
            end
    end
                
    always @(posedge clk or posedge rst )
    begin
        if (rst)  
            begin
              mem_wr_en <= 0;
            end
        else  if(clk==1)
            begin 
              mem_wr_en <= 1;
            end
        else  if (clk==0)
            begin 
              mem_wr_en <= 0;
            end
    end

    always @(posedge clk or posedge rst )
    begin
        if (rst)  
            begin
              done <= 0;
            end
        else if (count==IMG_W*IMG_H*FILTER_SIZE*FILTER_SIZE)
            begin
              done <= 1;
            end
        else 
            begin
              done <= 0;
            end
    end

    always @(posedge clk or posedge rst )
    begin
        if (rst)
            addr_wr_a=IM2COL_BASE-1;
        else 
            addr_wr_a=addr_wr_a+1;
    end

    always @(posedge clk or posedge rst )
    begin
        if (rst)
        begin
            addr_rd_a=0;
        end
        else  
        begin
          addr_rd_a=IMG_BASE+ ((count-1)/(FILTER_SIZE*FILTER_SIZE)+ IMG_W*(((count-1)%(FILTER_SIZE*FILTER_SIZE))/FILTER_SIZE - 1) + ((count-1)%(FILTER_SIZE*FILTER_SIZE))%FILTER_SIZE -1);
        end
    end

    always @(posedge clk or posedge rst )
    begin
        if (rst)
        begin
            data_out=0; 
        end
        else if(mem_wr_en)
        begin
            data_out=data_rd;
        end
    end

    assign addr_rd = addr_rd_a;
    assign addr_wr = addr_wr_a;

    assign data_wr=data_out;



endmodule

