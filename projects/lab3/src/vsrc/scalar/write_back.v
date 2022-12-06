`include "defines.v"

module write_back (
    input                   rst,

    input                   wb_ena_i,
    input [`REG_ADDR_BUS]   wb_addr_i,
    input                   wb_sel_i,
    input [`REG_BUS]        exe_data_i,
    input [`REG_BUS]        mem_data_i,

    output                  wb_ena_o,
    output [`REG_ADDR_BUS]  wb_addr_o,
    output [`REG_BUS]       wb_data_o

);

assign wb_ena_o     =   (rst == 1'b1) ? 0 : wb_ena_i ;
assign wb_addr_o    =   (rst == 1'b1) ? 0 : wb_addr_i ;
assign wb_data_o    =   (rst == 1'b1) ? 0           : 
                        (wb_sel_i)    ? mem_data_i  :
                                        exe_data_i ;

endmodule