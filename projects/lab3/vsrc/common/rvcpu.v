`include "defines.v"

module rvcpu(
    input   clk,
    input   rst,

    input [`INST_BUS]       inst,
    output[`INST_ADDR_BUS]  inst_addr,
    output                  inst_ena,

    output                  ram_r_ena,
    output [`RAM_ADDR_BUS]  ram_r_addr,
    input [`RAM_DATA_BUS]   ram_r_data,

    output                  ram_w_ena,
    output [`RAM_ADDR_BUS]  ram_w_addr,
    output [`RAM_DATA_BUS]  ram_w_data,
    output [`RAM_DATA_BUS]  ram_w_mask,

    output                  vram_r_ena,
    output [`VRAM_ADDR_BUS] vram_r_addr,
    input [`VRAM_DATA_BUS]  vram_r_data,

    output                  vram_w_ena,
    output [`VRAM_ADDR_BUS] vram_w_addr,
    output [`VRAM_DATA_BUS] vram_w_data,
    output [`VRAM_DATA_BUS] vram_w_mask
);

wire [`ALU_OP_BUS]      alu_opcode ;

wire                    pc_branch ;
wire                    pc_ena ;
wire [`INST_ADDR_BUS]   pc_current ;
wire [`INST_ADDR_BUS]   pc_offset ;
wire [`INST_ADDR_BUS]   pc_next ;


// scalar
wire [`REG_BUS]         rs1_data ;
wire                    rs1_r_ena ;
wire [`REG_ADDR_BUS]    rs1_r_addr ;

wire [`REG_BUS]         rs2_data ;
wire                    rs2_r_ena ;
wire [`REG_ADDR_BUS]    rs2_r_addr ;

wire [`REG_BUS]         rd_w_data ;
wire                    rd_w_ena ;
wire [`REG_ADDR_BUS]    rd_w_addr ;

wire [`REG_BUS]         operand_rs1 ;
wire [`REG_BUS]         operand_rs2 ;
wire [`REG_BUS]         exe_result ;

wire                    wb_ena ;
wire                    wb_sel ;
wire [`REG_ADDR_BUS]    wb_addr ;

wire                    mem_r_ena ;
wire [`MEM_DATA_BUS]    mem_r_data ;
wire                    mem_w_ena ;
wire [`MEM_DATA_BUS]    mem_w_data ;


// vector
wire [`VREG_BUS]        vs1_data  ;
wire                    vs1_r_ena  ;
wire [`VREG_ADDR_BUS]   vs1_r_addr  ;

wire [`VREG_BUS]        vs2_data  ;
wire                    vs2_r_ena  ;
wire [`VREG_ADDR_BUS]   vs2_r_addr  ;

wire [`VREG_BUS]        vd_w_data ;
wire                    vd_w_ena ;
wire [`VREG_ADDR_BUS]   vd_w_addr ;

wire [`VREG_BUS]        operand_vs1  ;
wire [`VREG_BUS]        operand_vs2  ;
wire [`VREG_BUS]        vexe_result ;

wire                    vwb_ena  ;
wire [1:0]              vwb_sel  ;
wire [`VREG_ADDR_BUS]   vwb_addr  ;

wire                    vmem_r_ena  ;
wire [`VMEM_ADDR_BUS]   vmem_r_addr  ;
wire [`VMEM_DATA_BUS]   vmem_r_data ;

wire                    vmem_w_ena  ;
wire [`VMEM_ADDR_BUS]   vmem_w_addr  ; 
wire [`VMEM_DATA_BUS]   vmem_w_data  ;
 
// mac-unit
wire [2:0]              vmac_sel ;
wire [`VREG_BUS]        vmac_result ;

if_stage IF_Stage(
    .clk            ( clk ),
    .rst            ( rst ),

    .pc_branch_i    ( pc_ena ),
    .pc_in_i        ( pc_next ),
    .pc_out_o       ( pc_current ),

    .inst_addr_o    ( inst_addr ),
    .inst_ena_o     ( inst_ena )
);

id_stage ID_Stage(
    .rst            ( rst ),
    .inst_i         ( inst ),

    // common signals
    .alu_opcode_o   ( alu_opcode ),
    .pc_branch_o    ( pc_branch ),
    .pc_offset_o    ( pc_offset ),

    // scalar signals
    .rs1_data_i     ( rs1_data ),
    .rs1_r_ena_o    ( rs1_r_ena ),
    .rs1_r_addr_o   ( rs1_r_addr ),

    .rs2_data_i     ( rs2_data ),
    .rs2_r_ena_o    ( rs2_r_ena ),
    .rs2_r_addr_o   ( rs2_r_addr ),

    .operand_rs1_o  ( operand_rs1 ),
    .operand_rs2_o  ( operand_rs2 ),

    .wb_ena_o       ( wb_ena ),
    .wb_sel_o       ( wb_sel ),
    .wb_addr_o      ( wb_addr ),

    .mem_r_ena_o    ( mem_r_ena ),
    .mem_w_ena_o    ( mem_w_ena ),
    .mem_w_data_o   ( mem_w_data ),

    // vetcor signal
    .vs1_data_i     ( vs1_data ),
    .vs1_r_ena_o    ( vs1_r_ena ),
    .vs1_r_addr_o   ( vs1_r_addr ),

    .vs2_data_i     ( vs2_data ),
    .vs2_r_ena_o    ( vs2_r_ena ),
    .vs2_r_addr_o   ( vs2_r_addr ),

    .operand_vs1_o  ( operand_vs1 ),
    .operand_vs2_o  ( operand_vs2 ),

    .vwb_ena_o      ( vwb_ena ),
    .vwb_sel_o      ( vwb_sel ),
    .vwb_addr_o     ( vwb_addr ),

    .vmem_r_ena_o   ( vmem_r_ena ),
    .vmem_r_addr_o  ( vmem_r_addr ),
    .vmem_w_ena_o   ( vmem_w_ena ),
    .vmem_w_data_o  ( vmem_w_data ),
    .vmem_w_addr_o  ( vmem_w_addr ),

    .vmac_sel_o     ( vmac_sel )

);

alu_stage ALU_Stage(
    .clk            ( clk ),
    .rst            ( rst ),
    .alu_opcode_i   ( alu_opcode ),

    .operand_rs1_i  ( operand_rs1 ),
    .operand_rs2_i  ( operand_rs2 ),
    .exe_result_o   ( exe_result ),

    .operand_vs1_i  ( operand_vs1 ),
    .operand_vs2_i  ( operand_vs2 ),
    .vexe_result_o  ( vexe_result ),

    .vmac_sel_i     ( vmac_sel ),
    .vmac_result_o  ( vmac_result )
);

branch_stage BRANCH_Stage(
    .rst            ( rst ),
    .pc_judege_i    ( exe_result[0] ),
    .pc_branch_i    ( pc_branch ),
    .pc_in_i        ( pc_current ),
    .pc_offset_i    ( pc_offset ),
    .pc_ena_o       ( pc_ena ),
    .pc_out_o       ( pc_next )
);


mem_stage MEM_Stage(
    .rst            ( rst ),

    .mem_r_ena_i    ( mem_r_ena ),
    .mem_r_addr_i   ( exe_result ),
    .mem_r_data_o   ( mem_r_data ),

    .mem_w_ena_i    ( mem_w_ena ),
    .mem_w_addr_i   ( exe_result ),
    .mem_w_data_i   ( mem_w_data ),

    .ram_r_ena_o    ( ram_r_ena ),
    .ram_r_data_i   ( ram_r_data ),
    .ram_r_addr_o   ( ram_r_addr ),

    .ram_w_ena_o    ( ram_w_ena ),
    .ram_w_addr_o   ( ram_w_addr ),
    .ram_w_data_o   ( ram_w_data ),
    .ram_w_mask_o   ( ram_w_mask )
);

wb_stage WB_Stage(
    .rst            ( rst ),
    .wb_ena_i       ( wb_ena ),
    .wb_addr_i      ( wb_addr ),
    .wb_sel_i       ( wb_sel ),
    .exe_data_i     ( exe_result ),
    .mem_data_i     ( mem_r_data ),
    .wb_ena_o       ( rd_w_ena ),
    .wb_addr_o      ( rd_w_addr ),
    .wb_data_o      ( rd_w_data )
);

regfile REGFILE(
    .clk            ( clk ),
    .rst            ( rst ),
    .w_addr_i       ( rd_w_addr ),
    .w_data_i       ( rd_w_data ),
    .w_ena_i        ( rd_w_ena ),
    .r_ena1_i       ( rs1_r_ena ),
    .r_addr1_i      ( rs1_r_addr ),
    .r_data1_o      ( rs1_data ),
    .r_ena2_i       ( rs2_r_ena ),
    .r_addr2_i      ( rs2_r_addr ),
    .r_data2_o      ( rs2_data )
);

// vector
vmem_stage VMEM_Stage(
    .rst            ( rst ),

    .vmem_r_ena_i    ( vmem_r_ena ),
    .vmem_r_addr_i   ( vmem_r_addr ),
    .vmem_r_data_o   ( vmem_r_data ),

    .vmem_w_ena_i    ( vmem_w_ena ),
    .vmem_w_addr_i   ( vmem_w_addr ),
    .vmem_w_data_i   ( vmem_w_data ),

    .vram_r_ena_o    ( vram_r_ena ),
    .vram_r_data_i   ( vram_r_data ),
    .vram_r_addr_o   ( vram_r_addr ),

    .vram_w_ena_o    ( vram_w_ena ),
    .vram_w_addr_o   ( vram_w_addr ),
    .vram_w_data_o   ( vram_w_data ),
    .vram_w_mask_o   ( vram_w_mask )
);

vwb_stage VWB_Stage(
    .rst            ( rst ),

    .vwb_ena_i      ( vwb_ena ),
    .vwb_addr_i     ( vwb_addr ),
    .vwb_sel_i      ( vwb_sel ),
    
    .vexe_data_i    ( vexe_result ),
    .vmem_data_i    ( vmem_r_data ),
    .vmac_data_i    ( vmac_result ),

    .vwb_ena_o      ( vd_w_ena ),
    .vwb_addr_o     ( vd_w_addr ),
    .vwb_data_o     ( vd_w_data )
);

vregfile VREGFILE(
    .clk            ( clk ),
    .rst            ( rst ),
    .w_addr_i       ( vd_w_addr ),
    .w_data_i       ( vd_w_data ),
    .w_ena_i        ( vd_w_ena ),
    .r_ena1_i       ( vs1_r_ena ),
    .r_addr1_i      ( vs1_r_addr ),
    .r_data1_o      ( vs1_data ),
    .r_ena2_i       ( vs2_r_ena ),
    .r_addr2_i      ( vs2_r_addr ),
    .r_data2_o      ( vs2_data )
);


endmodule