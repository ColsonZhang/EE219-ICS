module PE_array #(parameter height=3, width=2, bit_width = 8, sum_width = 32)
(clk, reset, W, X, Y, en, load_x, load_w);
input clk, reset, en, load_x, load_w; 
input [height*bit_width-1:0] X;
input [height*width*bit_width-1:0] W;
output [width*sum_width-1:0] Y;

wire [(height+1)*width*sum_width-1:0] p_sum;
wire [height*(width+1)*bit_width-1:0] x_temp;

assign p_sum[(height+1)*width*sum_width-1:height*width*sum_width] = 0;
assign Y = p_sum[width*sum_width-1:0];
assign x_temp[height*(width+1)*bit_width-1:height*width*bit_width] = X;

genvar i;
generate for (i=0; i<height; i=i+1)
begin: PE_column
	genvar j;
	for (j=0; j<width; j=j+1)
	begin: PE_row
		PE #(bit_width, sum_width) PE_N (
	.clk(clk),.reset(reset),.load_x(load_x),.load_w(load_w),. en(en),
               .X(x_temp[((i+height*(j+1)+1)*bit_width-1):((i+height*(j+1))*bit_width)]),
	.P(p_sum[(((i+1)*width+j+1)*sum_width-1):(((i+1)*width+j)*sum_width)]),
	.W(W[((i*width+j+1)*bit_width-1):((i*width+j)*bit_width)]),
	.p_sum(p_sum[((i*width+j+1)*sum_width-1):((i*width+j)*sum_width)]),
	.x_out(x_temp[((i+height*j+1)*bit_width-1):((i+height*j)*bit_width)])); end
end
endgenerate
endmodule

