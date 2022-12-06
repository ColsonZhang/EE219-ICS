`include "defines.v"
`include "ram_helper.v"

module top(
    input clk,
    input rst 
);

wire [`INST_BUS]        inst ;
wire [`INST_ADDR_BUS]   inst_addr ; 
wire                    inst_ena ;

wire                    ren_inst;
wire [`RAM_ADDR_BUS]    raddr_inst;
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
    .inst_en        ( inst_ena ),
    .inst_addr      ( inst_addr ),

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
assign raddr_inst   = inst_addr  ;
assign inst         = rdata_inst ;

INST_RAMHelper INST_RAMHelper(
    .clk        ( clk ),

    .ren        ( inst_ena ),
    .raddr      ( inst_addr >> 2 ),
    .rdata      ( rdata_inst )    
);


SCALAR_RAMHelper SCALAR_RAMHelper(
    .clk        ( clk ),

    .ren        ( ram_r_ena ),
    .raddr      ( ram_r_addr >> 2 ),
    .rdata      ( ram_r_data ),

    .wen        ( ram_w_ena ),
    .waddr      ( ram_w_addr >> 2 ),
    .wdata      ( ram_w_data ),
    .wmask      ( ram_w_mask )
);

VECTOR_RAMHelper VECTOR_RAMHelper(
    .clk        ( clk ),

    .ren        ( vram_r_ena ),
    .raddr      ( vram_r_addr >> 2 ),
    .rdata      ( vram_r_data ),

    .wen        ( vram_w_ena ),
    .waddr      ( vram_w_addr >> 2 ),
    .wdata      ( vram_w_data ),
    .wmask      ( vram_w_mask )
);


endmodule
