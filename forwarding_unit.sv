import rv32i_types::*;

module forwarding_unit
(
    input rv32i_control_word    exmem_controlw,
                                memwb_controlw,
    input logic [31:0]          exmem_aluout,
    input logic [31:0]          memwb_aluout,

    input logic [4:0]           rs1,
                                rs2,
                                alumux1_sel,
                                alumux2_sel,

    output logic [2:0]          forwardA,
                                forwardB
);

logic ex_forwardA, ex_forwardB, wb_forwardA, wb_forwardB;
logic memrd_forwardA, memrd_forwardB, wbrd_forwardA, wbrd_forwardB;
always_comb
begin
    ex_forwardA = exmem_controlw.load_regfile & (|rs1) &
                    (|exmem_controlw.rd) & (~exmem_controlw.mem_read) &
                    (exmem_controlw.rd == rs1) & (~alumux1_sel);
    ex_forwardB = exmem_controlw.load_regfile & (|rs2) &
                    (|exmem_controlw.rd) & (~exmem_controlw.mem_read) &
                    (exmem_controlw.rd == rs2) & (alumux2_sel == 3'b100);

    wb_forwardA = memwb_controlw.load_regfile & (~ex_forwardA) & (|rs1) &
                    (|memwb_controlw.rd) & (~memwb_controlw.mem_read)
                    (memwb_controlw.rd == rs1) & (~alumux1_sel);
    wb_forwardB = memwb_controlw.load_regfile & (~ex_forwardB) & (|rs2) &
                    (|memwb_controlw.rd) & (~memwb_controlw.mem_read) &
                    (memwb_controlw.rd == rs2) & (alumux2_sel == 3'b100);

    memrd_forwardA = exmem_controlw.load_regfile & (|rs1) &
                    (|exmem_controlw.rd) & (exmem_controlw.mem_read) &
                    (exmem_controlw.rd == rs1) & (~alumux1_sel);
    memrd_forwardB = exmem_controlw.load_regfile & (|rs2) &
                    (|exmem_controlw.rd) & (exmem_controlw.mem_read) &
                    (exmem_controlw.rd == rs2) & (alumux2_sel == 3'b100);

    wbrd_forwardA = memwb_controlw.load_regfile & (~ex_forwardA) & (|rs1) &
                    (|memwb_controlw.rd) & (memwb_controlw.mem_read)
                    (memwb_controlw.rd == rs1) & (~alumux1_sel);
    wbrd_forwardB = memwb_controlw.load_regfile & (~ex_forwardB) & (|rs2) &
                    (|memwb_controlw.rd) & (memwb_controlw.mem_read) &
                    (memwb_controlw.rd == rs2) & (alumux2_sel == 3'b100);


    forwardA = { mem_read,(ex_forwardA | wb_forwardA),( (~ex_forwardA) | wb_forwardA ) };
    forwardB = { mem_read,(ex_forwardB | wb_forwardB),( (~ex_forwardB) | wb_forwardB ) };
end

//000, 01 -> no forwarding
//010 -> forward ex
//011 -> forward wb
//1xx -> forward rdata

endmodule
