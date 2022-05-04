

module INST_RAMHelper(
  input         clk,
  input         ren,
  input  [31:0] rIdx,
  output [63:0] rdata
);

  wire [63 : 0] addr_r;
  assign addr_r = { 32'h0000_0000, rIdx } ;

  assign rdata = ram_read_helper(ren, addr_r);

endmodule

