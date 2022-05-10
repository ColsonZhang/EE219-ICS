// This is a referenc file for id_stage.v
// All the code block that needs your modification is  
// show with the specific annotation like this,
// ***************
// Task-1
// ***************


`include "defines.v"

module id_stage_ref(
    input                       rst,

    input [`INST_BUS]           inst_i,

    // scalar
    input [`REG_BUS]            rs1_data_i,
	output            	        rs1_r_ena_o,
	output [`REG_ADDR_BUS]   	rs1_r_addr_o,

    input [`REG_BUS]            rs2_data_i,
	output            	        rs2_r_ena_o,
	output [`REG_ADDR_BUS]   	rs2_r_addr_o,

    output [`ALU_OP_BUS]        alu_opcode_o,
	output [`REG_BUS]	        operand_rs1_o,
	output [`REG_BUS]           operand_rs2_o,

    output                      pc_branch_o,
    output [`INST_ADDR_BUS]     pc_offset_o,

    output                      wb_ena_o,
    output                      wb_sel_o,
    output [`REG_ADDR_BUS]      wb_addr_o,

    output                      mem_r_ena_o,
    output                      mem_w_ena_o,
    output [`MEM_DATA_BUS]      mem_w_data_o,

    // vector
    input [`VREG_BUS]           vs1_data_i,
	output            	        vs1_r_ena_o,
	output [`VREG_ADDR_BUS]   	vs1_r_addr_o,

    input [`VREG_BUS]           vs2_data_i,
	output            	        vs2_r_ena_o,
	output [`VREG_ADDR_BUS]   	vs2_r_addr_o,

	output [`VREG_BUS]	        operand_vs1_o,
	output [`VREG_BUS]          operand_vs2_o,

    output                      vwb_ena_o,
    output [1:0]                vwb_sel_o,
    output [`VREG_ADDR_BUS]     vwb_addr_o,

    output                      vmem_r_ena_o,
    output [`VMEM_ADDR_BUS]     vmem_r_addr_o,    
    output                      vmem_w_ena_o,
    output [`VMEM_DATA_BUS]     vmem_w_data_o,
    output [`VMEM_ADDR_BUS]     vmem_w_addr_o,

    output [2:0]                vmac_sel_o

);

localparam imm_sign_ext_num = 32-12;

// Dismantled signals
wire [5  : 0]   funct6 ;
wire            vm ;
wire [6  : 0]   funct7 ;
wire [11 : 0]   imm ;
wire [4  : 0]   rs2;
wire [4  : 0]   rs1;
wire [2  : 0]   funct3;
wire [4  : 0]   rd;
wire [6  : 0]   opcode;

wire op_imm ;
wire [`REG_BUS] operand_rs_imm ;

// Instructions
wire inst_addi ;
wire inst_add ;
wire inst_lw ;
wire inst_sw ;
wire inst_bne ;
wire inst_mul ;

wire inst_vadd_vv ;
wire inst_vmul_vv ;
wire inst_vle32_v ;
wire inst_vse32_v ;

wire inst_vmac_lw ;
wire inst_vmac_sw ;
wire inst_vmac_en ;

// ====================================================
// Common Decode
// ====================================================

assign {funct6, vm} = inst_i[ 31 : 25 ]  ;
assign funct7       = inst_i[ 31 : 25 ]  ;
assign imm          = inst_i[ 31 : 20 ] ;
assign rs2          = inst_i[ 24 : 20 ] ;
assign rs1          = inst_i[ 19 : 15 ] ;
assign funct3       = inst_i[ 14 : 12 ] ;
assign rd           = inst_i[ 11 :  7 ] ;
assign opcode       = inst_i[  6 :  0 ] ;

// ------------------------------
// Scalar Instructions
// ------------------------------
assign inst_addi    =  ( opcode == `OPCODE_ADDI )   & ( funct3 == `FUNCT3_ADDI ) ;
assign inst_lw      =  ( opcode == `OPCODE_LW )     & ( funct3 == `FUNCT3_LW ) ;  
assign inst_bne     =  ( opcode == `OPCODE_BNE )    & ( funct3 == `FUNCT3_BNE ) ;
assign inst_add     =  ( opcode == `OPCODE_ADD )    & ( funct3 == `FUNCT3_ADD ) & ( funct7 == `FUNCT7_ADD ) ;
// ******************************
// Task - 1
// add inst_mul and inst_sw
// ******************************


// ------------------------------
// Vector Instructions
// ------------------------------

// ******************************
// Task - 2
// add inst_vadd_vv inst_vmul_vv inst_vle32_v inst_vse32_v
// ******************************

// ------------------------------
// Custom Instructions
// ------------------------------
assign inst_vmac_lw =  ( opcode == `OPCODE_IVV )    & ( funct3 == `FUNCT3_IVV ) & ( funct6 == `FUNCT6_VMAC_LW ) ;
assign inst_vmac_sw =  ( opcode == `OPCODE_IVV )    & ( funct3 == `FUNCT3_IVV ) & ( funct6 == `FUNCT6_VMAC_SW ) ;
assign inst_vmac_en =  ( opcode == `OPCODE_IVV )    & ( funct3 == `FUNCT3_IVV ) & ( funct6 == `FUNCT6_VMAC_EN ) ;


// ------------------------------
// ALU Opcode
// ------------------------------
assign alu_opcode_o =   ( rst == 1'b1 )                     ?   `ALU_OP_NOP :
                        ( inst_addi || inst_lw  || inst_add ) 
                                                            ?   `ALU_OP_ADD :
                        inst_bne                            ?   `ALU_OP_BNE :
                        // ******************************
                        // Task-1
                        // add the alu_opcode for sw and mul
                        // 
                        // Task-2
                        // add the alu opcode for
                        // inst_vadd_vv inst_vmul_vv inst_vle32_v inst_vse32_v
                        // ******************************
                        inst_vmac_lw                        ?   `ALU_OP_VMAC_LW:
                        inst_vmac_sw                        ?   `ALU_OP_VMAC_SW:
                        inst_vmac_en                        ?   `ALU_OP_VMAC_EN:

                                                                `ALU_OP_NOP ;

// ====================================================
// Scalar Decode
// ====================================================

assign rs1_r_ena_o =    ( rst == 1'b1 )                             ?   1'b0    :
                        ( inst_addi || inst_lw  || inst_add || inst_bne )
                        // ******************************
                        // Task - 1
                        // Task - 2
                        // ******************************
                                                                    ?   1'b1    :
                                                                        1'b0    ;

assign rs1_r_addr_o =   ( rst == 1'b1 )                             ?   0       :
                        ( inst_addi || inst_lw || inst_add || inst_bne  )
                        // ******************************
                        // Task - 1
                        // Task - 2
                        // ******************************
                                                                    ?   rs1     :
                                                                        0       ;

assign rs2_r_ena_o =    ( rst == 1'b1 )                             ?   1'b0    :
                        ( inst_add || inst_bne )                    ?   1'b1    :
                        // ******************************
                        // Task - 1
                        // ******************************
                                                                        1'b0    ;

assign rs2_r_addr_o =   ( rst == 1'b1 )                             ?   0       :
                        ( inst_add || inst_bne  )         
                        // ******************************
                        // Task - 1
                        // ******************************
                                                                    ?   rs2     :
                                                                        0       ;

// ******************************
// Task - 1
// add the analysis of immediate number
// ******************************
assign op_imm = ( inst_addi || inst_lw ) ;
assign operand_rs_imm = (inst_addi || inst_lw)  ?   { {(imm_sign_ext_num){imm[11]}} , imm } : 0 ;


// ******************************
// Task - 1
// add the selection for alu's operands
// ******************************
assign operand_rs1_o =  ( inst_addi || inst_lw ||  inst_bne || inst_add  ) ?   rs1_data_i  : 0 ;
assign operand_rs2_o =  ( op_imm )                                      ?   operand_rs_imm  : 
                        ( inst_add || inst_bne )                        ?   rs2_data_i      :
                                                                            0 ;

// Already Done, Do not modify.
assign pc_branch_o = inst_bne ;
assign pc_offset_o = pc_branch_o ? { {(imm_sign_ext_num-1){imm[11]}}, imm[11], rd[0], imm[10:5], rd[4:1], 1'b0 } : 0 ;

// ******************************
// Task - 1
// add the selection for wrting back
// ******************************
assign wb_ena_o = inst_addi || inst_lw || inst_add ;
assign wb_sel_o = (inst_lw) ? 1'b1  : 0 ;
assign wb_addr_o = ( wb_ena_o )    ?   rd  : 0 ;

// ******************************
// Task - 1
// add the memory writing signals
// ******************************
assign mem_r_ena_o = inst_lw ? 1'b1 : 0 ;
assign mem_w_ena_o = 0 ;
assign mem_w_data_o = 0 ;


// ====================================================
// Vector Decode
// ====================================================

assign vs1_r_ena_o =    ( rst == 1'b1 )                             ?   1'b0    :
                        ( inst_vmac_lw || inst_vmac_en )            ?   1'b1    :
                        // ******************************
                        // Task - 2
                        // ******************************
                                                                        1'b0    ;

assign vs1_r_addr_o =   ( rst == 1'b1 )                             ?   0       :
                        (inst_vmac_lw || inst_vmac_en )             ?   rs1     :
                        // ******************************
                        // Task - 2
                        // ******************************
                                                                        0       ;

assign vs2_r_ena_o =    ( rst == 1'b1 )                             ?   1'b0    :
                        (inst_vmac_en )                             ?   1'b1    :
                        // ******************************
                        // Task - 2
                        // ******************************
                                                                        1'b0    ;

assign vs2_r_addr_o =   ( rst == 1'b1 )                             ?   0       :
                        (inst_vmac_en )                             ?   rs2     :
                        // ******************************
                        // Task - 2
                        // ******************************
                                                                        0       ;


// ******************************
// Task - 2
// ******************************
assign operand_vs1_o =  ( inst_vmac_lw || inst_vmac_en )    ?   vs1_data_i : 0 ;
assign operand_vs2_o =  ( inst_vmac_en  )                   ?   vs2_data_i : 0 ;

// ******************************
// Task - 2
// ******************************
assign vwb_ena_o = ( inst_vmac_sw ) ;
assign vwb_sel_o = (inst_vmac_sw )  ? 2'b10 : 0 ;
assign vwb_addr_o = ( vwb_ena_o )   ?   rd  : 0 ;

// ******************************
// Task - 2
// ******************************
assign vmem_r_ena_o =    0 ;
assign vmem_r_addr_o =   0 ;

// ******************************
// Task - 2
// ******************************
assign vmem_w_ena_o =    0 ;
assign vmem_w_addr_o =   0 ;
assign vmem_w_data_o =   0 ;

// Already Done, Do not modify.
assign vmac_sel_o =     inst_vmac_en ? rd[2:0] : 0 ;

endmodule