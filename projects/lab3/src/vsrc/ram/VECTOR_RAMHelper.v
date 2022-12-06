
module VECTOR_RAMHelper(
  input          clk,
  input          ren,
  input  [31 :0] raddr,
  output [255:0] rdata,
  input          wen,
  input  [31 :0] waddr,
  input  [255:0] wdata,
  input  [255:0] wmask
);

  assign rdata[31 :  0] = ram_read_helper(ren, raddr + 0 );
  assign rdata[63 : 32] = ram_read_helper(ren, raddr + 1 );
  assign rdata[95 : 64] = ram_read_helper(ren, raddr + 2 );
  assign rdata[127: 96] = ram_read_helper(ren, raddr + 3 );
  assign rdata[159:128] = ram_read_helper(ren, raddr + 4 );
  assign rdata[191:160] = ram_read_helper(ren, raddr + 5 );
  assign rdata[223:192] = ram_read_helper(ren, raddr + 6 );
  assign rdata[255:224] = ram_read_helper(ren, raddr + 7 );

  always @(posedge clk) begin
    ram_write_helper(waddr + 0, wdata[31 :  0],  wmask[31 :  0], wen );
    ram_write_helper(waddr + 1, wdata[63 : 32],  wmask[63 : 32], wen );
    ram_write_helper(waddr + 2, wdata[95 : 64],  wmask[95 : 64], wen );
    ram_write_helper(waddr + 3, wdata[127: 96],  wmask[127: 96], wen );
    ram_write_helper(waddr + 4, wdata[159:128],  wmask[159:128], wen );
    ram_write_helper(waddr + 5, wdata[191:160],  wmask[191:160], wen );
    ram_write_helper(waddr + 6, wdata[223:192],  wmask[223:192], wen );
    ram_write_helper(waddr + 7, wdata[255:224],  wmask[255:224], wen );
  end

endmodule

