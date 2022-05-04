`include "defines.v"

module branch_stage (
    input rst,

    input                   pc_judege_i,
    input                   pc_branch_i,
    input [`INST_ADDR_BUS]  pc_in_i,
    input [`INST_ADDR_BUS]  pc_offset_i,

    output                  pc_ena_o ,
    output [`INST_ADDR_BUS] pc_out_o
);


assign pc_ena_o = pc_judege_i & pc_branch_i ;

assign pc_out_o =   (rst == 1'b1)   ?   `PC_START : 
                    (pc_ena_o)      ?   pc_in_i + pc_offset_i :
                                        pc_in_i ;

endmodule