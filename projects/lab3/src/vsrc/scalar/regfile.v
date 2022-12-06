`include "defines.v"

module regfile(
    input                   clk,
    input                   rst,

	input [`REG_ADDR_BUS]   w_addr_i,
	input [`REG_BUS] 	    w_data_i,
	input   		  		w_ena_i,
	
	input   		  		r_ena1_i,
	input [`REG_ADDR_BUS]   r_addr1_i,
	output reg [`REG_BUS]   r_data1_o,
	
	input   		  		r_ena2_i,
	input [`REG_ADDR_BUS]   r_addr2_i,
	output reg [`REG_BUS] 	r_data2_o
);

integer i ;

reg [`REG_BUS] 	regs	[31 : 0];

always @(posedge clk ) begin
    if( rst == 1'b1 ) begin
        regs[0] <= `ZERO_WORD ;

        for(i=1; i<32; i=i+1) begin
            regs[i] <= `ZERO_WORD ;
        end
    end
    else begin
        if( (w_ena_i == 1'b1) && (w_addr_i != 0) ) begin
            regs[w_addr_i] <= w_data_i ;
        end
    end
end

always @( * ) begin
    if( rst == 1'b1 ) begin
        r_data1_o = `ZERO_WORD ;
    end
    else if( r_ena1_i ) begin
        r_data1_o = regs[r_addr1_i];
    end
    else begin
        r_data1_o = `ZERO_WORD;
    end
end

always @(*) begin
    if (rst == 1'b1)
        r_data2_o = `ZERO_WORD;
    else if (r_ena2_i == 1'b1)
        r_data2_o = regs[r_addr2_i];
    else
        r_data2_o = `ZERO_WORD;
end


endmodule