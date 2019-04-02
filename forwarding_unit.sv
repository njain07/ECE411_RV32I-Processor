import rv32i_types::*;

module forwarding_unit
(
    input rv32i_control_word    exmem_controlw,
                                memwb_controlw,
    input logic [31:0]          exmem_aluout,
    input logic [31:0]          memwb_aluout,

    input logic [4:0]           rs1,
                                rs2,

    output logic [1:0]          forwardA,
                                forwardB
);

logic ex_forwardA, ex_forwardB, wb_forwardA, wb_forwardB;
always_comb
begin
    ex_forwardA = exmem_controlw.load_regfile &
                    (|exmem_controlw.rd) & (|rs1) & (exmem_controlw.rd == rs1);
    ex_forwardB = exmem_controlw.load_regfile &
                    (|exmem_controlw.rd) & (|rs2) & (exmem_controlw.rd == rs2);

    wb_forwardA = memwb_controlw.load_regfile & (~ex_forwardA) &
                    (|memwb_controlw.rd) & (|rs1) & (memwb_controlw.rd == rs1);
    wb_forwardB = memwb_controlw.load_regfile & (~ex_forwardB) &
                    (|memwb_controlw.rd) & (|rs2) & (memwb_controlw.rd == rs2);

    forwardA = {(ex_forwardA | wb_forwardA), ( (~ex_forwardA) | wb_forwardA )};
    forwardB = {(ex_forwardB | wb_forwardB), ( (~ex_forwardB) | wb_forwardB )};
end

//00, 01 -> no forwarding
//10 -> forward ex
//11 -> forward wb

endmodule
