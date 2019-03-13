import rv32i_types::*;

module cpu_datapath
(
	input logic 				clk,
											resp_a,
											resp_b,

	input logic	[31:0]	rdata_a,
											rdata_b,

	output logic				read_b,
											write,
											read_a,

	output logic [3:0] 	wmask,

	output logic [31:0]	address_a,
											address_b,
											wdata
);

//Internal signals
//IF
logic [31:0] pc_plus4, pcmux_out, pc_out, pc_sync_out;
//IF_ID
logic [31:0] ifid_instr, ifid_pc;
//ID
rv32i_opcode opcode;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] i_imm, s_imm, b_imm, u_imm, j_imm;
logic [4:0] rs1, rs2, rd;
logic [31:0] rs1_out, rs2_out;
//ID_EX
logic [2:0] idex_funct3;
logic [6:0] idex_funct7;
logic [31:0] idex_i_imm, idex_s_imm, idex_b_imm, idex_u_imm, idex_j_imm;
logic [31:0] idex_rs1out, idex_rs2out, idex_pc;
//EX
logic br_en;
logic [31:0] cmpmux_out, alumux1_out, alumux2_out, alu_out;
//EX_MEM
logic [31:0] exmem_aluout, exmem_rs2out, exmem_bren, exmem_u_imm;
logic load;
//Mem_WB
logic [31:0] memwb_aluout, memwb_bren, memwb_rdata, memwb_u_imm;
//WB
logic [31:0] memwbmux_out;
logic 		 memwb_pcmuxsel;

//Control
rv32i_control_word controlw, idex_controlw, exmem_controlw, memwb_controlw;

/*
 * Instruction fetch
 */


assign pc_plus4 = pc_out + 4;
assign read_a = 1; //to be changed
assign address_a = pc_out;

cpu_control ctrl
(
	.*,
	.cword(controlw)
);

mux2 pcmux
(
    .sel(memwb_pcmuxsel),
    .a(pc_plus4),
    .b(memwb_aluout),
    .f(pcmux_out)
);

pc_register pc
(
    .clk,
    .load, //needs to be changed
    .in(pcmux_out),
    .out(pc_out)
);

register pc_sync
(
	.clk,
	.load,
	.in(pc_out),
	.out(pc_sync_out)
);

if_id_reg if_id
(
	.clk,
	.load, //to be changed for data hazards
	.instr_in(rdata_a),
	.pc_in(pc_sync_out),
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
   .load, //to be changed
   .in(ifid_instr)
);

regfile regfile
(
    .clk,
    .load(memwb_controlw.load_regfile),
    .in(memwbmux_out),
    .src_a(rs1),
    .src_b(rs2),
    .dest(memwb_controlw.rd),
    .reg_a(rs1_out),
    .reg_b(rs2_out)
);


id_ex_reg id_ex
(
	.clk,
	.load, //to be changed
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
    .cmpop(idex_controlw.cmpop),
    .a(idex_rs1out),
    .b(cmpmux_out),
    .f(br_en)
);

alu alu
(
    .aluop(idex_controlw.aluop),
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
    .g(),
    .h(),
    .q(alumux2_out)
);

ex_mem_reg ex_mem
(
	.clk,
	.load, //to be changed
	.controlw_in (idex_controlw),
	.controlw_out(exmem_controlw),
	.aluout_in(alu_out),
	.rs2out_in(idex_rs2out),
	.bren_in({ 31'd0, br_en }),
	.u_imm_in(idex_u_imm),
	.aluout_out(exmem_aluout),
	.rs2out_out(exmem_rs2out),
	.bren_out(exmem_bren),
	.u_imm_out(exmem_u_imm)
);

/*
 * Memory
 */

assign read_b = exmem_controlw.mem_read;
assign write = exmem_controlw.mem_write;
assign wmask = exmem_controlw.mem_wmask;
assign address_b = exmem_aluout;
assign wdata = exmem_rs2out;

mem_stall stall (.*);

mem_wb_reg mem_wb
(
	.clk,
	.load, //to be changed
	.controlw_in (exmem_controlw),
	.controlw_out(memwb_controlw),
	.aluout_in(exmem_aluout),
	.bren_in(exmem_bren),
	.dmemout_in(rdata_b),
	.u_imm_in(exmem_u_imm),
	.aluout_out(memwb_aluout),
	.bren_out(memwb_bren),
	.dmemout_out(memwb_rdata),
	.u_imm_out(memwb_u_imm),
	.pcmuxsel(memwb_pcmuxsel)
);

/*
 * Write back
 */


mux4 memwb_mux
(
	.sel(memwb_controlw.memwbmux_sel),
	.a(memwb_aluout),
	.b(memwb_bren),
	.c(memwb_u_imm),
	.d(memwb_rdata),
	.f(memwbmux_out)
);

/*
 * TODO:
 * 1. Verify that there are no race conditions in pipeline registers while r/w
 * 2. Incorporate data hazard handling logic
 * 3. Stall on mem_resp
 */
endmodule
