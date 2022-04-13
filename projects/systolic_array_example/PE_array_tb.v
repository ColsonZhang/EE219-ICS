module PE_array_tb #(parameter height=3, width=2, bit_width = 8, sum_width = 32);
reg clk, reset, en, load_x, load_w; 
reg [height*bit_width-1:0] X;
reg [height*width*bit_width-1:0] W;
wire [width*sum_width-1:0] Y;
initial begin
clk = 1'b0; 
  repeat(20) #1 clk = ~clk;  //Run for 10 clock cycles
end
initial begin
	reset = 1'b1;
	en = 1'b0;
	load_x = 1'b0;
	load_w = 1'b0;
	X = 0;
  W = 48'h010203040506; //The weight matrix [[1,2,3],[4,5,6],[7,8,9]]
	#5 reset = 1'b0;      //Reset
        load_w = 1'b1;  //Load the weights
  #2 X = 24'h010000;   //Load the inputs in the following order [1,0,0]',[4,2,0]',[7,5,3]',[0,8,6]',[0,0,9]', each vector per clock cycle 
 	load_x = 1'b1;
	en = 1'b1;           //Enable computation of the partial sum for each PE
	load_w = 1'b0;       //Stop loading the weights
	#2 X = 24'h040200;
	#2 X = 24'h07_05_03;
	#2 X = 24'h000806;
	#2 X = 24'h000009;
	#2 X = 0;
	#4 load_x = 1'b0;
	en = 1'b0;	
end
PE_array PE_array_test(.clk(clk),.reset(reset),.en(en),.load_x(load_x),.load_w(load_w),.X(X),.W(W),.Y(Y));
  initial $monitor("At time %t, Y = %d", $time, Y);  //Produce the results, notice that they are printed in decimal while each output is the concatenation of two results.
initial
begin
  $dumpfile("PE_array_tb.vcd"); //Generate vcd waveform
  $dumpvars(0, PE_array_tb);    //Record all the signals
end

endmodule
