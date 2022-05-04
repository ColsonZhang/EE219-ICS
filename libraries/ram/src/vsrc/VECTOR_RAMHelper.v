
module VECTOR_RAMHelper(
  input          clk,
  input          ren,
  input  [31 :0] rIdx,
  output [255:0] rdata,
  input          wen,
  input  [31 :0] wIdx,
  input  [255:0] wdata,
  input  [255:0] wmask
);
  wire [63:0] addr_r ;
  wire [63:0] addr_w ;

  assign addr_r   = { 32'h0000_0000, rIdx } ;
  assign addr_w   = { 32'h0000_0000, wIdx } ;

  assign rdata[63 : 0]  = ram_read_helper(ren, addr_r );
  assign rdata[127:64]  = ram_read_helper(ren, addr_r + 1 );
  assign rdata[191:128] = ram_read_helper(ren, addr_r + 2 );
  assign rdata[255:192] = ram_read_helper(ren, addr_r + 3 );

  always @(posedge clk) begin
    ram_write_helper(addr_w     , wdata[63 :  0],  wmask[63 :  0], wen );
    ram_write_helper(addr_w + 1 , wdata[127: 64],  wmask[127: 64], wen );
    ram_write_helper(addr_w + 2, wdata[191:128],  wmask[191:128], wen );
    ram_write_helper(addr_w + 3, wdata[255:192],  wmask[255:192], wen );
  end

endmodule

