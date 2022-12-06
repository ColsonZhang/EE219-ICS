`include "defines.v"

module rvcpu(
    input                       clk,
    input                       rst,

    input   [`INST_BUS]         inst,
    output                      inst_en,
    output  [`INST_ADDR_BUS]    inst_addr,

    output                      ram_r_ena,
    output  [`RAM_ADDR_BUS]     ram_r_addr,
    input   [`RAM_DATA_BUS]     ram_r_data,

    output                      ram_w_ena,
    output  [`RAM_ADDR_BUS]     ram_w_addr,
    output  [`RAM_DATA_BUS]     ram_w_data,
    output  [`RAM_DATA_BUS]     ram_w_mask,

    output                      vram_r_ena,
    output  [`VRAM_ADDR_BUS]    vram_r_addr,
    input   [`VRAM_DATA_BUS]    vram_r_data,

    output                      vram_w_ena,
    output  [`VRAM_ADDR_BUS]    vram_w_addr,
    output  [`VRAM_DATA_BUS]    vram_w_data,
    output  [`VRAM_DATA_BUS]    vram_w_mask
);

wire                        transfer_en ;
wire    [`INST_ADDR_BUS]    transfer_pc ;
wire    [`INST_ADDR_BUS]    current_pc ;

wire    [`REG_BUS]          rs1_data ;
wire                        rs1_r_ena ;
wire    [`REG_ADDR_BUS]     rs1_r_addr ;

wire    [`REG_BUS]          sca_rs1_data ;
wire                        sca_rs1_r_ena ;
wire    [`REG_ADDR_BUS]     sca_rs1_r_addr ;

wire    [`REG_BUS]          rs2_data ;
wire                        rs2_r_ena ;
wire    [`REG_ADDR_BUS]     rs2_r_addr ;

wire    [`REG_BUS]          operand_rs1 ;
wire    [`REG_BUS]          operand_rs2 ;

wire    [`ALU_OP_BUS]       alu_opcode ;
wire    [`REG_BUS]          exe_result ;
wire                        branch_en ;
wire    [`INST_ADDR_BUS]    branch_offset ;
wire                        jump_en ;
wire    [`INST_ADDR_BUS]    jump_offset ;

wire                        mem_r_ena ;
wire                        mem_w_ena ;
wire    [`MEM_DATA_BUS]     mem_w_data ;
wire    [`MEM_DATA_BUS]     mem_r_data ;
wire    [`MEM_DATA_BUS]     mem_w_data ;

wire                        wb_ena ;
wire                        wb_sel ;
wire    [`REG_ADDR_BUS]     wb_addr ;
wire                        rd_w_ena ;
wire    [`REG_ADDR_BUS]     rd_w_addr ;
wire    [`REG_BUS]          rd_w_data ;

// =================================================
//                  Scalar
// =================================================
inst_fetch IF_Stage(
    .clk            ( clk           ),
    .rst            ( rst           ),

    .transfer_en_i  ( transfer_en   ),
    .transfer_pc_i  ( transfer_pc   ),
    .current_pc_o   ( current_pc    ),

    .inst_en_o      ( inst_en       ),
    .inst_addr_o    ( inst_addr     )
);

inst_decode ID_Stage(
    .rst            ( rst           ),
    .inst_i         ( inst          ),

    .rs1_data_i     ( sca_rs1_data  ),
    .rs1_r_ena_o    ( sca_rs1_r_ena ),
    .rs1_r_addr_o   ( sca_rs1_r_addr),

    .rs2_data_i     ( rs2_data      ),
    .rs2_r_ena_o    ( rs2_r_ena     ),
    .rs2_r_addr_o   ( rs2_r_addr    ),

    .alu_opcode_o   ( alu_opcode    ),
    .operand_rs1_o  ( operand_rs1   ),
    .operand_rs2_o  ( operand_rs2   ),
    .branch_en_o    ( branch_en     ),
    .branch_offset_o( branch_offset ),
    .jump_en_o      ( jump_en       ),
    .jump_offset_o  ( jump_offset   ),

    .mem_r_ena_o    ( mem_r_ena     ),
    .mem_w_ena_o    ( mem_w_ena     ),
    .mem_w_data_o   ( mem_w_data    ),

    .wb_ena_o       ( wb_ena        ),
    .wb_sel_o       ( wb_sel        ),
    .wb_addr_o      ( wb_addr       )
);

execute EXE_Stage(
    .rst            ( rst           ),

    .alu_opcode_i   ( alu_opcode    ),
    .operand_rs1_i  ( operand_rs1   ),
    .operand_rs2_i  ( operand_rs2   ),
    .exe_result_o   ( exe_result    ),

    .current_pc_i   ( current_pc    ),
    .branch_en_i    ( branch_en     ),
    .branch_offset_i( branch_offset ),
    .jump_en_i      ( jump_en       ),
    .jump_offset_i  ( jump_offset   ),

    .transfer_en_o  ( transfer_en   ),
    .transfer_pc_o  ( transfer_pc   )
);


mem MEM_Stage(
    .rst            ( rst           ),

    .mem_r_ena_i    ( mem_r_ena     ),
    .mem_r_addr_i   ( exe_result    ),
    .mem_r_data_o   ( mem_r_data    ),

    .mem_w_ena_i    ( mem_w_ena     ),
    .mem_w_addr_i   ( exe_result    ),
    .mem_w_data_i   ( mem_w_data    ),

    .ram_r_ena_o    ( ram_r_ena     ),
    .ram_r_data_i   ( ram_r_data    ),
    .ram_r_addr_o   ( ram_r_addr    ),

    .ram_w_ena_o    ( ram_w_ena     ),
    .ram_w_addr_o   ( ram_w_addr    ),
    .ram_w_data_o   ( ram_w_data    ),
    .ram_w_mask_o   ( ram_w_mask    )
);

write_back WB_Stage(
    .rst            ( rst           ),

    .wb_ena_i       ( wb_ena        ),
    .wb_addr_i      ( wb_addr       ),
    .wb_sel_i       ( wb_sel        ),
    .exe_data_i     ( exe_result    ),
    .mem_data_i     ( mem_r_data    ),

    .wb_ena_o       ( rd_w_ena      ),
    .wb_addr_o      ( rd_w_addr     ),
    .wb_data_o      ( rd_w_data     )
);


assign rs1_r_ena    =   ( sca_rs1_r_ena || vec_rs1_r_ena ) ;
assign rs1_r_addr   =   ( sca_rs1_r_ena ) ?   sca_rs1_r_addr  :
                        ( vec_rs1_r_ena ) ?   vec_rs1_r_addr  : 0 ;
assign sca_rs1_data =   rs1_data ;
assign vec_rs1_data =   rs1_data ;

regfile REGFILE(
    .clk            ( clk           ),
    .rst            ( rst           ),
    .w_addr_i       ( rd_w_addr     ),
    .w_data_i       ( rd_w_data     ),
    .w_ena_i        ( rd_w_ena      ),
    .r_ena1_i       ( rs1_r_ena     ),
    .r_addr1_i      ( rs1_r_addr    ),
    .r_data1_o      ( rs1_data      ),
    .r_ena2_i       ( rs2_r_ena     ),
    .r_addr2_i      ( rs2_r_addr    ),
    .r_data2_o      ( rs2_data      )
);


// =================================================
//                  Vector
// =================================================
wire    [`REG_BUS]          vec_rs1_data ;
wire                        vec_rs1_r_ena ;
wire    [`REG_ADDR_BUS]     vec_rs1_r_addr ;

wire    [`VREG_BUS]         vs1_data  ;
wire                        vs1_r_ena  ;
wire    [`VREG_ADDR_BUS]    vs1_r_addr  ;

wire    [`VREG_BUS]         vs2_data  ;
wire                        vs2_r_ena  ;
wire    [`VREG_ADDR_BUS]    vs2_r_addr  ;

wire    [`VREG_BUS]         vd_w_data ;
wire                        vd_w_ena ;
wire    [`VREG_ADDR_BUS]    vd_w_addr ;

wire    [`ALU_OP_BUS]       v_alu_opcode ;
wire    [`VREG_BUS]         operand_vs1  ;
wire    [`VREG_BUS]         operand_vs2  ;
wire    [`VREG_BUS]         vexe_result ;

wire                        vmem_r_ena  ;
wire    [`VMEM_ADDR_BUS]    vmem_r_addr  ;
wire    [`VMEM_DATA_BUS]    vmem_r_data ;
wire                        vmem_w_ena  ;
wire    [`VMEM_ADDR_BUS]    vmem_w_addr  ; 
wire    [`VMEM_DATA_BUS]    vmem_w_data  ;

wire                        vwb_ena  ;
wire                        vwb_sel  ;
wire    [`VREG_ADDR_BUS]    vwb_addr  ;

v_inst_decode V_ID_Stage(
    .rst            ( rst           ),
    .inst_i         ( inst          ),

    .rs1_data_i     ( vec_rs1_data  ),
    .rs1_r_ena_o    ( vec_rs1_r_ena ),
    .rs1_r_addr_o   ( vec_rs1_r_addr),

    .vs1_data_i     ( vs1_data      ),
    .vs1_r_ena_o    ( vs1_r_ena     ),
    .vs1_r_addr_o   ( vs1_r_addr    ),
    .vs2_data_i     ( vs2_data      ),
    .vs2_r_ena_o    ( vs2_r_ena     ),
    .vs2_r_addr_o   ( vs2_r_addr    ),

    .alu_opcode_o   ( v_alu_opcode ),
    .operand_vs1_o  ( operand_vs1   ),
    .operand_vs2_o  ( operand_vs2   ),

    .vwb_ena_o      ( vwb_ena       ),
    .vwb_sel_o      ( vwb_sel       ),
    .vwb_addr_o     ( vwb_addr      ),

    .vmem_r_ena_o   ( vmem_r_ena    ),
    .vmem_r_addr_o  ( vmem_r_addr   ),
    .vmem_w_ena_o   ( vmem_w_ena    ),
    .vmem_w_data_o  ( vmem_w_data   ),
    .vmem_w_addr_o  ( vmem_w_addr   )
);

v_execute V_EXE_Stage(
    .rst            ( rst ),
    .alu_opcode_i   ( v_alu_opcode  ),
    .operand_vs1_i  ( operand_vs1   ),
    .operand_vs2_i  ( operand_vs2   ),
    .vexe_result_o  ( vexe_result   )
);

v_mem V_MEM_Stage(
    .rst            ( rst ),

    .vmem_r_ena_i   ( vmem_r_ena ),
    .vmem_r_addr_i  ( vmem_r_addr ),
    .vmem_r_data_o  ( vmem_r_data ),

    .vmem_w_ena_i   ( vmem_w_ena ),
    .vmem_w_addr_i  ( vmem_w_addr ),
    .vmem_w_data_i  ( vmem_w_data ),

    .vram_r_ena_o   ( vram_r_ena ),
    .vram_r_data_i  ( vram_r_data ),
    .vram_r_addr_o  ( vram_r_addr ),

    .vram_w_ena_o   ( vram_w_ena ),
    .vram_w_addr_o  ( vram_w_addr ),
    .vram_w_data_o  ( vram_w_data ),
    .vram_w_mask_o  ( vram_w_mask )
);

v_write_back V_WB_Stage(
    .rst            ( rst ),

    .vwb_ena_i      ( vwb_ena ),
    .vwb_addr_i     ( vwb_addr ),
    .vwb_sel_i      ( vwb_sel ),
    
    .vexe_data_i    ( vexe_result ),
    .vmem_data_i    ( vmem_r_data ),

    .vwb_ena_o      ( vd_w_ena ),
    .vwb_addr_o     ( vd_w_addr ),
    .vwb_data_o     ( vd_w_data )       
);

v_regfile V_REGFILE(
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