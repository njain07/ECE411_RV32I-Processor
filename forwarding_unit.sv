import rv32i_types::*;

module forwarding_unit
(
    input rv32i_control_word    idex_controlw,
                                exmem_controlw,
                                memwb_controlw,

    input logic [4:0]           rs1,
                                rs2,

    output logic [1:0]          forwardA,
                                forwardB,
    output logic                stall_lw
);

logic mem_forwardA, mem_forwardB, wb_forwardA, wb_forwardB;
logic ex_forwardA, ex_forwardB;

always_comb
begin
    ex_forwardA = idex_controlw.load_regfile & (|rs1) &
                    (|idex_controlw.rd) &
                    (idex_controlw.rd == rs1);
    ex_forwardB = idex_controlw.load_regfile & (|rs2) &
                    (|idex_controlw.rd) &
                    (idex_controlw.rd == rs2);

    mem_forwardA = exmem_controlw.load_regfile & (|rs1) &
                    (|exmem_controlw.rd) &
                    (exmem_controlw.rd == rs1) ;
    mem_forwardB = exmem_controlw.load_regfile & (|rs2) &
                    (|exmem_controlw.rd) &
                    (exmem_controlw.rd == rs2) ;

    wb_forwardA = memwb_controlw.load_regfile & (~mem_forwardA) & (|rs1) &
                    (|memwb_controlw.rd) &
                    (memwb_controlw.rd == rs1);
    wb_forwardB = memwb_controlw.load_regfile & (~mem_forwardB) & (|rs2) &
                    (|memwb_controlw.rd) &
                    (memwb_controlw.rd == rs2);


    stall_lw = ((ex_forwardA | ex_forwardB) & idex_controlw.mem_read) |
                 ((mem_forwardA | mem_forwardB) & exmem_controlw.mem_read) |
                 ((wb_forwardA | wb_forwardB) & memwb_controlw.mem_read);

    forwardA = { (mem_forwardA | wb_forwardA),( (~mem_forwardA) | wb_forwardA ) };
    forwardB = { (mem_forwardB | wb_forwardB),( (~mem_forwardB) | wb_forwardB ) };
end


//000, 01 -> no forwarding
//10 -> forward ex
//11 -> forward wb

endmodule
