

module SCALAR_RAMHelper(
  input         clk,
  input         ren,
  input  [31:0] raddr,
  output [31:0] rdata,
  input         wen,
  input  [31:0] waddr,
  input  [31:0] wdata,
  input  [31:0] wmask
);

assign rdata = ram_read_helper(ren, raddr);

always @(posedge clk) begin
	ram_write_helper(waddr, wdata, wmask, wen);
end

endmodule

