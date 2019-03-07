import rv32i_types::*;

module cpu_datapath
(

);

/*
 * Instruction fetch
 */

assign pc_plus4_out = pc_out + 4;
assign mem_wdata = rs2_out;

mux2 pcmux
(
    .sel(memwb_pcmux_sel), //not sure yet
    .a(pc_plus4_out),
    .b(memwb_alu_out),
    .f(pcmux_out)
);

pc_register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

if_id_reg if_id
(
	.clk,
	.load(1), //to be changed for data hazards
	.instr_in(rdata_a),
	.pc_in(pc_out),
	.instr_out(ifid_instr),
	.pc_out(ifid_pc)
);

/*
 * Instruction decode
 */

ir IR
(
   .*,
   .clk,
   .load(1), //to be changed
   .in(ifid_instr)
);

regfile regfile
(
    .clk,
    .load(controlw.load_regfile),
    .in(memwb_reg_out),
    .src_a(rs1),
    .src_b(rs2),
    .dest(rd),
    .reg_a(rs1_out),
    .reg_b(rs2_out)
);

id_ex_reg id_ex
(
	.clk,
	.load(1), //to be changed
	.controlw_in(controlw),
	.controlw_out(idex_controlw),
	.pc_in(ifid_pc),
	.i_imm_in(i_imm),
	.s_imm_in(s_imm),
	.b_imm_in(b_imm),
	.u_imm_in(u_imm),
	.j_imm_in(j_imm),
	.rs1out_in(rs1_out),
	.rs2out_in(rs2_out),
	.funct3_in(funct3),
	.funct7_in(funct7),

	.pc_out (idex_pc),
	.i_imm_out(idex_i_imm),
	.s_imm_out(idex_s_imm),
	.b_imm_out(idex_b_imm),
	.u_imm_out(idex_u_imm),
	.j_imm_out(idex_j_imm),
	.rs1out_out(idex_rs1out),
	.rs2out_out(idex_rs2out),
	.funct3_out(idex_funct3),
	.funct7_out(idex_funct7)
);


/*
 * Execute
 */

mux2 cmpmux
(
    .sel(idex_controlw.cmpmux_sel),
    .a(idex_rs2out),
    .b(idex_i_imm),
    .f(cmpmux_out)
);

cmp cmp
(
    .cmpop,
    .a(idex_rs1out),
    .b(cmpmux_out),
    .f(br_en)
);

alu alu
(
    .aluop,
    .a(alumux1_out),
    .b(alumux2_out),
    .f(alu_out)
);

mux2 alumux1
(
    .sel(idex_controlw.alumux1_sel),
    .a(idex_rs1out),
    .b(idex_pc),
    .f(alumux1_out)
);

mux8 alumux2
(
    .sel(idex_controlw.alumux2_sel),
    .a(idex_i_imm),
    .b(idex_u_imm),
    .c(idex_b_imm),
    .d(idex_s_imm),
    .e(idex_rs2out),
    .f(idex_j_imm),
    .q(alumux2_out)
);

ex_mem_reg ex_mem
(
	.clk,
	.load(1), //to be changed
	.controlw_in (idex_controlw),
	.controlw_out(exmem_controlw),
	.aluout_in   (alu_out),
	.rs2out_in   (idex_rs2out),
	.bren_in     ({ 31'd0, br_en }),
	.aluout_out  (exmem_aluout),
	.rs2out_out  (exmem_rs2out),
	.bren_out    (exmem_bren)

);

/*
 * Memory
 */






