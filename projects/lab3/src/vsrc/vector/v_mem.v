`include "defines.v"

module v_mem (
    input                   rst,

    input                   vmem_r_ena_i,
    input [`VMEM_ADDR_BUS]  vmem_r_addr_i,
    output [`VMEM_DATA_BUS] vmem_r_data_o,

    input                   vmem_w_ena_i,
    input [`VMEM_ADDR_BUS]  vmem_w_addr_i,
    input [`VMEM_DATA_BUS]  vmem_w_data_i,

    output                  vram_r_ena_o,
    input [`VRAM_DATA_BUS]  vram_r_data_i,
    output [`VRAM_ADDR_BUS] vram_r_addr_o,

    output                  vram_w_ena_o,
    output [`VRAM_ADDR_BUS] vram_w_addr_o,
    output [`VRAM_DATA_BUS] vram_w_data_o,
    output [`VRAM_DATA_BUS] vram_w_mask_o  
);

assign vram_r_ena_o = vmem_r_ena_i ;
assign vram_r_addr_o = vmem_r_addr_i ;
assign vmem_r_data_o = vram_r_data_i ;

assign vram_w_ena_o = vmem_w_ena_i ;
assign vram_w_addr_o = vmem_w_addr_i ;
assign vram_w_data_o = vmem_w_data_i ;
assign vram_w_mask_o = {(`VLEN){1'b1}} ;

endmodule