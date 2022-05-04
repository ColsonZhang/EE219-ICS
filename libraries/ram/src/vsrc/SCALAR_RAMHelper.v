

module SCALAR_RAMHelper(
  input         clk,
  input         ren,
  input  [31:0] rIdx,
  output [63:0] rdata,
  input         wen,
  input  [31:0] wIdx,
  input  [63:0] wdata,
  input  [63:0] wmask
);

    wire [63 : 0] addr_r;
    wire [63 : 0] addr_w ;

    assign addr_r  = { 32'h0000_0000, rIdx } ;
    assign addr_w   = { 32'h0000_0000, wIdx } ;

  assign rdata = ram_read_helper(ren, addr_r);

  always @(posedge clk) begin
    ram_write_helper(addr_w, wdata, wmask, wen);
  end

endmodule

