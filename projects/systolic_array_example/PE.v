module PE #(parameter width = 8, sum_width = 32) 
(reset, clk, load_w, load_x, en, W, X, P, x_out, p_sum);
input [width-1:0] W, X;
input [sum_width-1:0] P;
input reset, clk, load_w, load_x, en;
output reg [width-1:0] x_out;
output reg [sum_width-1:0] p_sum;

reg [width-1:0] w_out;
wire [2*width-1:0] prod;
wire [sum_width-1:0] prod_temp;
wire [sum_width-1:0] sum;
assign prod_temp[sum_width-1:2*width]=0;

assign prod=X*w_out;
assign sum=P+prod_temp;
assign prod_temp[2*width-1:0]=prod;

always @(posedge clk, posedge reset) begin
if (reset) 
begin x_out <= 0; w_out <= 0; p_sum <= 0; end
else case({load_x,load_w,en})
	3'b000: ;
	3'b010: w_out <= W;
	3'b100: x_out <= X;
	3'b110: begin w_out <= W; x_out <= X; end
	3'b001: p_sum <= sum;
	3'b011: begin w_out <= W; p_sum <= sum; end
	3'b101: begin x_out <= X; p_sum <= sum; end
	3'b111: begin w_out <= W; x_out <= X; p_sum <= sum; end
	default: begin x_out <= 0; w_out <= 0; p_sum <= 0; end
endcase 
end

endmodule

