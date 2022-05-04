`include "defines.v"
`include "ram_helper.v"

module top(
    input clk,
    input rst 
);

reg  [`INST_BUS]        inst ;
wire [`INST_ADDR_BUS]   inst_addr ; 
wire                    inst_ena ;

wire                    ren_inst;
wire [`RAM_ADDR_BUS]    rIdx_inst;
wire [`RAM_DATA_BUS]    rdata_inst;

wire                    ram_r_ena ;
wire [`RAM_ADDR_BUS]    ram_r_addr ;
reg  [`RAM_DATA_BUS]    ram_r_data ;

wire                    ram_w_ena ;
wire [`RAM_ADDR_BUS]    ram_w_addr ;
wire [`RAM_DATA_BUS]    ram_w_data ;
wire [`RAM_DATA_BUS]    ram_w_mask ;

wire                    vram_r_ena ;
wire [31:0]             vram_r_addr ;
wire [255:0]            vram_r_data ;

wire                    vram_w_ena ;
wire [31:0]             vram_w_addr ;
wire [255:0]            vram_w_data ;
wire [255:0]            vram_w_mask ;    

rvcpu RVCPU(
    .clk            ( clk ),
    .rst            ( rst ),
    .inst           ( inst ),
    .inst_addr      ( inst_addr ),
    .inst_ena       ( inst_ena ),

    .ram_r_ena      ( ram_r_ena ),
    .ram_r_addr     ( ram_r_addr ),
    .ram_r_data     ( ram_r_data ),
     
    .ram_w_ena      ( ram_w_ena ),
    .ram_w_addr     ( ram_w_addr ),
    .ram_w_data     ( ram_w_data ),
    .ram_w_mask     ( ram_w_mask ),

    .vram_r_ena     ( vram_r_ena ),
    .vram_r_addr    ( vram_r_addr ),
    .vram_r_data    ( vram_r_data ),
     
    .vram_w_ena     ( vram_w_ena ),
    .vram_w_addr    ( vram_w_addr ),
    .vram_w_data    ( vram_w_data ),
    .vram_w_mask    ( vram_w_mask )
);


assign ren_inst     = inst_ena ;
assign rIdx_inst    = inst_addr  ;
assign inst         = inst_addr[2] ? rdata_inst[63:32] : rdata_inst[31:0] ;

INST_RAMHelper INST_RAMHelper(
    .clk        ( clk ),

    .ren        ( ren_inst ),
    .rIdx       ( rIdx_inst >> 3 ),
    .rdata      ( rdata_inst )    
);


SCALAR_RAMHelper SCALAR_RAMHelper(
    .clk        ( clk ),

    .ren        ( ram_r_ena ),
    .rIdx       ( ram_r_addr >> 3 ),
    .rdata      ( ram_r_data ),

    .wen        ( ram_w_ena ),
    .wIdx       ( ram_w_addr >> 3 ),
    .wdata      ( ram_w_data ),
    .wmask      ( ram_w_mask )
);

VECTOR_RAMHelper VECTOR_RAMHelper(
    .clk        ( clk ),

    .ren        ( vram_r_ena ),
    .rIdx       ( vram_r_addr >> 3 ),
    .rdata      ( vram_r_data ),

    .wen        ( vram_w_ena ),
    .wIdx       ( vram_w_addr >> 3 ),
    .wdata      ( vram_w_data ),
    .wmask      ( vram_w_mask )
);


endmodule
