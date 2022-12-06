`include "defines.v"

module v_write_back(
    input                   rst,

    input                   vwb_ena_i,
    input [`VREG_ADDR_BUS]  vwb_addr_i,
    input                   vwb_sel_i,

    input [`VREG_BUS]       vexe_data_i,
    input [`VREG_BUS]       vmem_data_i,

    output                  vwb_ena_o,
    output [`VREG_ADDR_BUS] vwb_addr_o,
    output [`VREG_BUS]      vwb_data_o

);

assign vwb_ena_o     =   (rst == 1'b1) ? 0 : vwb_ena_i ;
assign vwb_addr_o    =   (rst == 1'b1) ? 0 : vwb_addr_i ;
assign vwb_data_o    =   (rst == 1'b1)          ? 0           : 
                         (vwb_sel_i == 1'b0)   ? vexe_data_i  :
                         (vwb_sel_i == 1'b1)   ? vmem_data_i  :
                                                  0 ;

endmodule