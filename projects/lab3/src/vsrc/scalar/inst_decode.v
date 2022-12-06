`include "defines.v"

module inst_decode(
    input                       rst,
    input   [`INST_BUS]         inst_i,
    // register
    input   [`REG_BUS]          rs1_data_i,
	output                      rs1_r_ena_o,
	output  [`REG_ADDR_BUS]     rs1_r_addr_o,
    input   [`REG_BUS]          rs2_data_i,
	output                      rs2_r_ena_o,
	output  [`REG_ADDR_BUS]     rs2_r_addr_o,
    // execute
    output  [`ALU_OP_BUS]       alu_opcode_o,
	output  [`REG_BUS]          operand_rs1_o,
	output  [`REG_BUS]          operand_rs2_o,
    output                      branch_en_o,
    output  [`INST_ADDR_BUS]    branch_offset_o,
    output                      jump_en_o,
    output  [`INST_ADDR_BUS]    jump_offset_o,
    // memory
    output                      mem_r_ena_o,
    output                      mem_w_ena_o,
    output  [`MEM_DATA_BUS]     mem_w_data_o,
    // write-back
    output                      wb_ena_o,
    output                      wb_sel_o,
    output  [`REG_ADDR_BUS]     wb_addr_o
);

// ====================================================
// wire declaration
// ====================================================

wire [11 : 0]   imm_i ;
// hint: to add imm_u, imm_b, imm_j, imm_s

wire [6  : 0]   funct7 ;
wire [4  : 0]   rs2;
wire [4  : 0]   rs1;
wire [2  : 0]   funct3;
wire [4  : 0]   rd;
wire [6  : 0]   opcode;

wire op_imm ;
wire [`REG_BUS] operand_rs_imm ;


wire inst_addi ;
// hint: too add other instructions

// ====================================================
// Parse
// ====================================================
assign imm_i    = inst_i[ 31 : 20 ] ;
// hint: to add imm_u, imm_b, imm_j, imm_s

assign funct7   = inst_i[ 31 : 25 ] ;
assign rs2      = inst_i[ 24 : 20 ] ;
assign rs1      = inst_i[ 19 : 15 ] ;
assign funct3   = inst_i[ 14 : 12 ] ;
assign rd       = inst_i[ 11 :  7 ] ;
assign opcode   = inst_i[  6 :  0 ] ;

assign inst_addi    =   ( opcode == `OPCODE_ADDI ) & ( funct3 == `FUNCT3_ADDI ) ;
// hint: too add other instructions

// ====================================================
// Decode
// ====================================================
// hint: too finish the decoding part
// hint: no need to add new assign code.

// Control ALU Operation
assign alu_opcode_o =   ( rst == 1'b1   )   ?   `ALU_OP_NOP     :
                        ( inst_addi     )   ?   `ALU_OP_ADD     :
                                                `ALU_OP_NOP     ;

// Control the register visiting and immediate parsing
assign rs1_r_ena_o      =   ( rst != 1'b1 ) & ( inst_addi ) ;
assign rs1_r_addr_o     =   ( rs1_r_ena_o ) ?   rs1 : 0 ;
assign rs2_r_ena_o      =   1'b0;
assign rs2_r_addr_o     =   ( rs2_r_ena_o ) ?   rs2 : 0 ;
assign op_imm           =   ( inst_addi ) ;
assign operand_rs_imm   =   ( inst_addi )  ?   { {(32-12){imm_i[11]}}  , imm_i }   :    0 ;

// Control ALU operands
assign operand_rs1_o    =   ( rs1_r_ena_o   )   ?   rs1_data_i      :   0 ;
assign operand_rs2_o    =   ( op_imm        )   ?   operand_rs_imm  : 
                            ( rs2_r_ena_o   )   ?   rs2_data_i      :   0 ;

// Conditional Branching
assign branch_en_o      =   1'b0 ;
assign branch_offset_o  =   0 ;

// Unconditional Branching (Jumping)
assign jump_en_o        =   1'b0 ;
assign jump_offset_o    =   0 ;

// Control Memory Access 
assign mem_r_ena_o      =   0 ;
assign mem_w_ena_o      =   0 ;
assign mem_w_data_o     =   0 ;

// Control Write-Back
assign wb_ena_o         =   ( inst_addi );
assign wb_sel_o         =   1'b0 ;
assign wb_addr_o        =   ( wb_ena_o )    ?   rd  : 0 ;

endmodule
