

module INST_RAMHelper(
  input         clk,
  input         ren,
  input  [31:0] raddr,
  output [31:0] rdata
);

  assign rdata = ram_read_helper(ren, raddr);

endmodule

