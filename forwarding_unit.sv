import rv32i_types::*;

module forwarding_unit
(
    input rv32i_control_word    exmem_controlw,
                                memwb_controlw,
    input logic [31:0]          exmem_aluout,
    input logic [31:0]          memwb_aluout,

    input logic [4:0]           rs1,
                                rs2,
    input logic                 alumux1_sel,
    input logic [2:0]           alumux2_sel,

    output logic [2:0]          forwardA,
                                forwardB,
                                forwardRS2
);

logic ex_forwardA, ex_forwardB, wb_forwardA, wb_forwardB, ex_rs2, wb_rs2;
logic read_A, read_B, read_rs2;

always_comb
begin
    ex_forwardA = exmem_controlw.load_regfile & (|rs1) &
                    (|exmem_controlw.rd) & (~alumux1_sel) &
                    (exmem_controlw.rd == rs1) ;
    ex_forwardB = exmem_controlw.load_regfile & (|rs2) &
                    (|exmem_controlw.rd) & (alumux2_sel == 3'b100) &
                    (exmem_controlw.rd == rs2) ;

    wb_forwardA = memwb_controlw.load_regfile & (~ex_forwardA) & (|rs1) &
                    (|memwb_controlw.rd) & (~alumux1_sel) &
                    (memwb_controlw.rd == rs1);
    wb_forwardB = memwb_controlw.load_regfile & (~ex_forwardB) & (|rs2) &
                    (|memwb_controlw.rd) & (alumux2_sel == 3'b100) &
                    (memwb_controlw.rd == rs2);

    ex_rs2 = exmem_controlw.load_regfile & (|rs2) &
                    (|exmem_controlw.rd) &
                    (exmem_controlw.rd == rs2) ;

    wb_rs2 = memwb_controlw.load_regfile & (~ex_rs2) & (|rs2) &
                    (|memwb_controlw.rd) &
                    (memwb_controlw.rd == rs2);


    read_A = (exmem_controlw.mem_read & ex_forwardA) |
                (memwb_controlw.mem_read & wb_forwardA);
    read_B = (exmem_controlw.mem_read & ex_forwardB) |
                (memwb_controlw.mem_read & wb_forwardB);
    read_rs2 = (exmem_controlw.mem_read & ex_rs2) |
                (memwb_controlw.mem_read & wb_rs2);
    
    forwardA = { read_A,(ex_forwardA | wb_forwardA),( (~ex_forwardA) | wb_forwardA ) };
    forwardB = { read_B,(ex_forwardB | wb_forwardB),( (~ex_forwardB) | wb_forwardB ) };
    forwardRS2 = { read_rs2,(ex_rs2 | wb_rs2),( (~ex_rs2) | wb_rs2 ) };
end

//000, 01 -> no forwarding
//010 -> forward ex
//011 -> forward wb
//1xx -> forward rdata

endmodule
