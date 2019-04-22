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
logic [31:0] pc_plus4, pcmux_out, pc_out, pc_sync_out, pc_4_sync, instr_mdr_out, nop, targ_addr;
logic if_id_load;
logic [1:0] predmux_sel, pred_sync, ifid_pred, ifid_pred_sync, pred;
//IF_ID
logic [31:0] ifid_instr, ifid_pc, ifid_pc_4, ifid_pc_sync, ifid_pc4_sync;
logic [9:0] bhr_out, bhr_sync, ifid_bhr, ifid_bhr_sync, idex_bhr;
//ID
rv32i_opcode opcode;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] i_imm, s_imm, b_imm, u_imm, j_imm;
logic [4:0] rs1, rs2, rd;
logic [31:0] rs1_out, rs2_out;
logic prediction, misprediction, load_btb;
logic [31:0] btb_out;
//ID_EX
logic idex_prediction;
logic [2:0] idex_funct3;
logic [4:0] idex_rs1, idex_rs2;
logic [6:0] idex_funct7;
logic [31:0] idex_i_imm, idex_s_imm, idex_b_imm, idex_u_imm, idex_j_imm;
logic [31:0] idex_rs1out, idex_rs2out, idex_pc, idex_pc_4;
logic [31:0] idex_btb_out;
logic [1:0] idex_pred_state;
//EX
logic pcmuxsel, br_en;
logic [31:0] cmpmux_out, alumux1_out, alumux2_out, alu_out;
logic [31:0] mux_forwardA_out, mux_forwardB_out, mux_forwardRS1_out, mux_forwardRS2_out;
logic [1:0] forwardA, forwardB, forwardRS2;
logic stall_lw;
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

//Counters
logic datamux_sel;
logic [31:0] num_instr_access, num_data_access, num_l1_access, counter_data;
logic [31:0] instr_cycles, data_cycles, l1_cycles;
logic [31:0] num_predictions, num_correct, mem_rdata;

//Control
rv32i_control_word controlw, idex_controlw, exmem_controlw, memwb_controlw;

/*
 * Instruction fetch
 */

// assign nop = 32'h00000013;
assign pc_plus4 = pc_out + 4;
assign address_a = pc_out;
assign read_a = 1;
assign nop = 32'h00000013;

assign if_id_load = load & ~stall_lw;

cpu_control ctrl
(
	.*,
	.rs1_in(rs1),
	.rs2_in(rs2),
	.cword(controlw)
);

assign prediction = pred[1];
assign predmux_sel = {misprediction & ~br_en & ~idex_controlw.jump, prediction & ~misprediction};

mux4 predmux
(
	.sel(predmux_sel),
	.a(alu_out),
	.b(btb_out),
	.c(idex_pc_4),
	.d(idex_pc_4),
	.f(targ_addr)
);

mux2 pcmux
(
    .sel(prediction | misprediction),
    .a(pc_plus4),
    .b(targ_addr),
    .f(pcmux_out)
);

pc_register pc
(
    .clk,
    .load(if_id_load),
    .in(pcmux_out),
    .out(pc_out)
);

if_id_reg ifid_sync
(
	.clk,
	.load(if_id_load),
	.instr_in(rdata_a),
	.pc_in(pc_out),
	.pc_4_in(pc_plus4),
	.pred_in(pred),
	.bhr_in(bhr_out),
	.flush(misprediction),
	.instr_out(instr_mdr_out),
	.pc_out(pc_sync_out),
	.pc_4_out(pc_4_sync),
	.pred_out(pred_sync),
	.bhr_out(bhr_sync)
);


if_id_reg if_id
(
	.clk,
	.load(if_id_load), //to be changed for data hazards
	.instr_in(instr_mdr_out),
	.pc_in(pc_sync_out),
	.pc_4_in(pc_4_sync),
	.pred_in(pred_sync),
	.bhr_in(bhr_sync),
	.flush(misprediction),
	.instr_out(ifid_instr),
	.pc_out(ifid_pc),
	.pc_4_out(ifid_pc_4),
	.pred_out(ifid_pred),
	.bhr_out(ifid_bhr)
);

/*
 * Instruction decode
 */

ir IR
(
   .*,
   .clk,
   .load(if_id_load),
   .in(misprediction ? nop : ifid_instr)
);

regfile regfile
(
    .clk,
    .load(memwb_controlw.load_regfile),
    .in(memwbmux_out),
    .src_a(idex_controlw.rs1),
    .src_b(idex_controlw.rs2),
    .dest(memwb_controlw.rd),
    .reg_a(rs1_out),
    .reg_b(rs2_out)
);

register id_pc_sync
(
	.clk,
	.load(if_id_load),
	.in(ifid_pc),
	.out(ifid_pc_sync)
);

register id_pc4_sync
(
	.clk,
	.load(if_id_load),
	.in(ifid_pc_4),
	.out(ifid_pc4_sync)
);

register #(.width(2)) id_pred_sync
(
	.clk,
	.load(if_id_load),
	.in(ifid_pred),
	.out(ifid_pred_sync)
);

register #(.width(10)) id_bhr_sync
(
	.clk,
	.load(if_id_load),
	.in(ifid_bhr),
	.out(ifid_bhr_sync)
);

forwarding_unit lw_hazard_stall
(
	.*,
	.rs1(controlw.rs1),
	.rs2(controlw.rs2),
	.forwardA(),
	.forwardB()
);

register #(.width(10)) bhr
(
	.clk,
	.load,
	.in({ bhr_out[9:1], ((idex_controlw.branch & br_en) | idex_controlw.jump)} ),
	.out(bhr_out)
);

btb btb
(
	.clk,
	.load_btb,
	.target_addr(alu_out),
	.pc_out,
	.idex_pc_value(idex_pc), //idex_pc
	.btb_out
);

branch_predictor local_bht
(
	.clk,
	.rindex(bhr_out),
	.windex(idex_bhr),
	.br_en,
	.jump(idex_controlw.jump),
	.branch(idex_controlw.branch),
	.idex_pred_state,
	.pred
);

check_branch_prediction check_branch_prediction
(
	.*,
	.prediction(idex_pred_state[1]),
	.btb_out(idex_btb_out)
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
	.funct3_in(funct3),
	.funct7_in(funct7),
	.pred_in(ifid_pred_sync),
	.bhr_in(ifid_bhr_sync),
	.flush(misprediction | stall_lw),
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
	.funct7_out(idex_funct7),
	.btb_out_in(btb_out),
	.btb_out_out(idex_btb_out),
	.pred_out(idex_pred_state),
	.bhr_out(idex_bhr)
);

/*
 * Execute
 */

forwarding_unit forward
(
	.*,
	.rs1(idex_rs1),
	.rs2(idex_rs2),
	.stall_lw()
);


mux2 cmpmux
(
    .sel(idex_controlw.cmpmux_sel),
    .a(mux_forwardRS2_out),
    .b(idex_i_imm),
    .f(cmpmux_out)
);

cmp cmp
(
    .cmpop(idex_controlw.cmpop),
    .a(mux_forwardRS1_out),
    .b(cmpmux_out),
    .f(br_en)
);

alu alu
(
    .aluop(idex_controlw.aluop),
    .a(mux_forwardA_out),
    .b(mux_forwardB_out),
    .f(alu_out)
);

mux2 alumux1
(
    .sel(idex_controlw.alumux1_sel),
    .a(rs1_out),
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
    .e(rs2_out),
    .f(idex_j_imm),
    .g(),
    .h(),
    .q(alumux2_out)
);


mux4 mux_forwardA
(
	.sel({forwardA[1] & idex_controlw.forwardA, forwardA[0]}),
	.a(alumux1_out),
	.b(alumux1_out),
	.c(exmem_aluout),
	.d(memwb_aluout),
	.f(mux_forwardA_out)
);

mux4 mux_forwardB
(
	.sel({forwardB[1] & idex_controlw.forwardB, forwardB[0]}),
	.a(alumux2_out),
	.b(alumux2_out),
	.c(exmem_aluout),
	.d(memwb_aluout),
	.f(mux_forwardB_out)
);

mux4 mux_forwardRS1
(
	.sel(forwardA),
	.a(rs1_out),
	.b(rs1_out),
	.c(exmem_aluout),
	.d(memwb_aluout),
	.f(mux_forwardRS1_out)
);


mux4 mux_forwardRS2
(
	.sel(forwardB),
	.a(rs2_out),
	.b(rs2_out),
	.c(exmem_aluout),
	.d(memwb_aluout),
	.f(mux_forwardRS2_out)
);

ex_mem_reg ex_mem
(
	.clk,
	.load, //to be changed
	.controlw_in (idex_controlw),
	.controlw_out(exmem_controlw),
	.aluout_in(alu_out),
	.rs2out_in(mux_forwardRS2_out),
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

assign address_b = exmem_aluout;

mem_signals mem_signals (.*);

mux2 datamux
(
	.sel(datamux_sel),
	.a(final_rdata_b),
	.b(counter_data),
	.f(mem_rdata)
);

loader rdata_mask
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

bht_stats branch_pred_stats (.*);

cache_stats stats
(
    .*,
    .instr_access(read_a),
    .instr_resp(resp_a),
    .data_access(read_b | write),
    .data_resp(resp_b)
);

mem_wb_reg mem_wb
(
	.clk,
	.load, //to be changed
	.controlw_in (exmem_controlw),
	.controlw_out(memwb_controlw),
	.aluout_in(exmem_aluout),
	.bren_in(exmem_bren),
	.dmemout_in(mem_rdata),
	.u_imm_in(exmem_u_imm),
	.pc_4_in(exmem_pc_4),
	.aluout_out(memwb_aluout),
	.bren_out(memwb_bren),
	.dmemout_out(memwb_rdata),
	.u_imm_out(memwb_u_imm),
	.pc_4_out(memwb_pc_4)
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
