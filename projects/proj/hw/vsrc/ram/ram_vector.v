
module RAMVectorHelper(
  input           clk,
  input           ren,
  input  [63: 0]  rIdx,
  output [511:0]  rdata,
  input  [63: 0]  wIdx,
  input  [511:0]  wdata,
  input  [511:0]  wmask,
  input           wen
);
  genvar i ;
  for (i=0; i<8; i=i+1) begin
    assign rdata[64*(i+1)-1:64*i] = ram_read_helper(ren, rIdx+i);
  end

  for (i=0; i<8; i=i+1) begin
    always @(posedge clk) begin
      ram_write_helper(wIdx+i, wdata[64*(i+1)-1:64*i], wmask[64*(i+1)-1:64*i], wen );
    end  
  end
endmodule 
