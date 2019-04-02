import rv32i_types::*;

module cpu_datapath
(
	input logic 		clk,
						resp_a,
						resp_b,


	input logic	[31:0]	rdata_a,
						rdata_b,

	output logic		read_b,
						write,
						read_a,

	output logic [3:0] 	wmask,

	output logic [31:0]	address_a,
						address_b,
						wdata
);

//Internal signals
//IF
logic [31:0] pc_plus4, pcmux_out, pc_out, pc_sync_out, pc_4_sync, instr_mdr_out, nop;
logic pc_load;
//IF_ID
logic [31:0] ifid_instr, ifid_pc, ifid_pc_4, ifid_pc_sync, ifid_pc4_sync;
//ID
rv32i_opcode opcode;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] i_imm, s_imm, b_imm, u_imm, j_imm;
logic [4:0] rs1, rs2, rd;
logic [31:0] rs1_out, rs2_out;
//ID_EX
logic [2:0] idex_funct3;
logic [4:0] idex_rs1, idex_rs2;
logic [6:0] idex_funct7;
logic [31:0] idex_i_imm, idex_s_imm, idex_b_imm, idex_u_imm, idex_j_imm;
logic [31:0] idex_rs1out, idex_rs2out, idex_pc, idex_pc_4;
//EX
logic br_en;
logic [31:0] cmpmux_out, alumux1_out, alumux2_out, alu_out,mux_forwardB_out;
logic alumux1_sel_0;
logic [1:0] forwardA, forwardB;
//EX_MEM
logic [31:0] exmem_aluout, exmem_rs2out, exmem_bren, exmem_u_imm, exmem_pc_4;
logic load;
logic [31:0] final_rdata_b;
logic [31:0] final_wdata;
//Mem_WB
logic [31:0] memwb_aluout, memwb_bren, memwb_rdata, memwb_u_imm, memwb_pc_4, data_mdr_out;
logic [31:0] bren_sync, aluout_sync, controlw_sync, u_imm_sync;
//WB
logic [31:0] memwbmux_out;
logic 		 memwb_pcmuxsel;

//Control
rv32i_control_word controlw, idex_controlw, exmem_controlw, memwb_controlw;

/*
 * Instruction fetch
 */

// assign nop = 32'h00000013;
assign pc_plus4 = pc_out + 4;
assign address_a = pc_out;

instr_read instr_read (.*);


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

if_id_reg ifid_sync
(
	.clk,
	.load(resp_a), //to be changed for data hazards
	.instr_in(rdata_a),
	.pc_in(pc_out),
	.pc_4_in(pc_plus4),
	.instr_out(instr_mdr_out),
	.pc_out(pc_sync_out),
	.pc_4_out(pc_4_sync)
);

// mux2 nop_mux
// (
// 	.sel(~pc_load),
// 	.a(rdata_a),
// 	.b(nop),
// 	.f(instr_out)
// );



if_id_reg if_id
(
	.clk,
	.load, //to be changed for data hazards
	.instr_in(instr_mdr_out),
	.pc_in(pc_sync_out),
	.pc_4_in(pc_4_sync),
	.instr_out(ifid_instr),
	.pc_out(ifid_pc),
	.pc_4_out(ifid_pc_4)
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

register id_pc_sync
(
	.clk,
	.load,
	.in(ifid_pc),
	.out(ifid_pc_sync)
);

register id_pc4_sync
(
	.clk,
	.load,
	.in(ifid_pc_4),
	.out(ifid_pc4_sync)
);

id_ex_reg id_ex
(
	.clk,
	.load, //to be changed
	.controlw_in(controlw),
	.controlw_out(idex_controlw),
	.pc_in(ifid_pc_sync),
	.pc_4_in(ifid_pc4_sync),
	.i_imm_in(i_imm),
	.s_imm_in(s_imm),
	.b_imm_in(b_imm),
	.u_imm_in(u_imm),
	.j_imm_in(j_imm),
	.rs1out_in(rs1_out),
	.rs2out_in(rs2_out),
	.rs1_in(rs1),
	.rs2_in(rs2),
	.funct3_in(funct3),
	.funct7_in(funct7),
	.pc_out (idex_pc),
	.pc_4_out(idex_pc_4),
	.i_imm_out(idex_i_imm),
	.s_imm_out(idex_s_imm),
	.b_imm_out(idex_b_imm),
	.u_imm_out(idex_u_imm),
	.j_imm_out(idex_j_imm),
	.rs1out_out(idex_rs1out),
	.rs2out_out(idex_rs2out),
	.rs1_out(idex_rs1),
	.rs2_out(idex_rs2),
	.funct3_out(idex_funct3),
	.funct7_out(idex_funct7)
);

/*
 * Execute
 */

forwarding_unit forward
(
	.*,
	.rs1(idex_rs1),
	.rs2(idex_rs2)
);


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
    .b(mux_forwardB_out), //alumux2_out was replaced with forwarded values
    .f(alu_out)
);

mux4 alumux1
(
    .sel({forwardA[1],alumux1_sel_0}),
    .a(idex_rs1out),
    .b(idex_pc),
	.c(exmem_aluout),
	.d(memwb_aluout),
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

mux2 #(.width(1)) mux_forwardA
(
	.sel(forwardA[1]),
	.a(idex_controlw.alumux1_sel),
	.b(forwardA[0]),
	.f(alumux1_sel_0)
);

mux4 mux_forwardB
(
	.sel(forwardB),
	.a(alumux2_out),
	.b(alumux2_out),
	.c(exmem_aluout),
	.d(memwb_aluout),
	.f(mux_forwardB_out)
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
	.pc_4_in(idex_pc_4),
	.aluout_out(exmem_aluout),
	.rs2out_out(exmem_rs2out),
	.bren_out(exmem_bren),
	.u_imm_out(exmem_u_imm),
	.pc_4_out(exmem_pc_4)
);

/*
 * Memory
 */

assign read_b = exmem_controlw.mem_read;
assign address_b = exmem_aluout;
assign write = exmem_controlw.mem_write;

loader load_reg
(
	.load_sel(exmem_controlw.funct3),
	.in(rdata_b),
	.address(address_b),
	.out(final_rdata_b)
);

shifter shift_data
(
	.sel(exmem_controlw.funct3),
	.in(exmem_rs2out),
	.address(address_b),
	.out(wdata),
	.wmask
);


mem_stall stall (.*);

mem_wb_reg mem_wb
(
	.clk,
	.load, //to be changed
	.controlw_in (exmem_controlw),
	.controlw_out(memwb_controlw),
	.aluout_in(exmem_aluout),
	.bren_in(exmem_bren),
	.dmemout_in(final_rdata_b),
	.u_imm_in(exmem_u_imm),
	.pc_4_in(exmem_pc_4),
	.aluout_out(memwb_aluout),
	.bren_out(memwb_bren),
	.dmemout_out(memwb_rdata),
	.u_imm_out(memwb_u_imm),
	.pc_4_out(memwb_pc_4),
	.pcmuxsel(memwb_pcmuxsel)
);

/*
 * Write back
 */


mux8 memwb_mux
(
	.sel(memwb_controlw.memwbmux_sel),
	.a(memwb_aluout),
	.b(memwb_bren),
	.c(memwb_u_imm),
	.d(memwb_rdata),
	.e(memwb_pc_4),
	.f(),
	.g(),
	.h(),
	.q(memwbmux_out)
);

endmodule
