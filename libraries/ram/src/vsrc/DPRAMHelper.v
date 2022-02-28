
import "DPI-C" function void ram_write_helper
(
  input  longint    wIdx,
  input  longint    wdata,
  input  longint    wmask,
  input  bit        wen
);

import "DPI-C" function longint ram_read_helper
(
  input  bit        en,
  input  longint    rIdx
);

module DPRAMHelper(
  input         clk,

  input         ren_1,
  input  [31:0] rIdx_1,
  output [63:0] rdata_1,

  input         ren_2,
  input  [31:0] rIdx_2,
  output [63:0] rdata_2,
  
  input  [31:0] wIdx,
  input  [63:0] wdata,
  input  [63:0] wmask,
  input         wen
);

    wire [63 : 0] addr_r_1;
    wire [63 : 0] addr_r_2;
    wire [63 : 0] addr_w ;

    assign addr_r_1 = { 32'h0000_0000, rIdx_1 } ;
    assign addr_r_2 = { 32'h0000_0000, rIdx_2 } ;
    assign addr_w   = { 32'h0000_0000, wIdx } ;

    assign rdata_1 = ram_read_helper(ren_1, addr_r_1);
    assign rdata_2 = ram_read_helper(ren_2, addr_r_2);

    always @(posedge clk) begin
        ram_write_helper(addr_w, wdata, wmask, wen);
    end

endmodule
