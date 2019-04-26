import rv32i_types::*;

module mem_signals
(
    input rv32i_control_word    exmem_controlw,
    input logic [31:0]          address_b,
    input logic [31:0]	        num_instr_access,
        						num_data_access,
        						num_l1_access,
        						instr_cycles,
        						data_cycles,
        						l1_cycles,
                                num_predictions,
                                num_mispredictions,
    output logic                read_b,
                                write,
                                datamux_sel,
    output logic [31:0]         counter_data
);

mux8 dataoutmux
(
    .sel(address_b[4:2]),
    .a(num_instr_access),
    .b(num_data_access),
    .c(num_l1_access),
    .d(instr_cycles),
    .e(data_cycles),
    .f(l1_cycles),
    .g(num_predictions),
    .h(num_mispredictions),
    .q(counter_data)
);


always_comb
begin
    read_b = 0;
    write = 0;
    datamux_sel = 1;
    if (address_b >= 32) begin
        read_b = exmem_controlw.mem_read;
        write = exmem_controlw.mem_write;
        datamux_sel = 0;
    end
end

endmodule
