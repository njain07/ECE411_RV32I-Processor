import rv32i_types::*;

module cpu_control
(
	input rv32i_opcode opcode,
	input logic [2:0] funct3,
	input logic [6:0] funct7,
	input logic [4:0] rd,

	output rv32i_control_word cword
);
arith_funct3_t arith_funct3;

assign arith_funct3 = arith_funct3_t'(funct3);

always_comb
begin
	/* Default assignments */
	cword.opcode = opcode;
	cword.aluop = alu_add;
	cword.rd = rd;
	cword.load_regfile = 0;
	cword.cmpmux_sel = 0;
	cword.alumux1_sel = 0;
	cword.mem_read = 0;
	cword.mem_write = 0;
	cword.memwbmux_sel = 0;
	cword.alumux2_sel = 0;
	cword.jump = 0;
	cword.branch = 0;
	cword.cmpop = branch_funct3_t'(funct3);
	cword.funct3 = funct3;

	/* Assign control signals */
	case(opcode)
		op_lui : begin
			cword.load_regfile = 1;
			cword.memwbmux_sel = 2;
		end

		op_auipc : begin
			cword.load_regfile = 1;
			cword.alumux1_sel = 1;
			cword.alumux2_sel = 1;
			cword.aluop = alu_add;
		end

		op_jal : begin
			cword.load_regfile = 1;
			cword.memwbmux_sel = 4;
			cword.alumux1_sel = 1;
			cword.alumux2_sel = 5;
			cword.aluop = alu_add;
			cword.jump = 1;
		end


		op_jalr : begin
			cword.load_regfile = 1;
			cword.memwbmux_sel = 4;
			cword.aluop = alu_add;
			cword.jump = 1;

		end


		op_br : begin
			cword.alumux1_sel = 1;
			cword.alumux2_sel = 2;
			cword.aluop = alu_add;
			cword.branch = 1;
		end

		op_load : begin
			cword.aluop = alu_add;
			cword.mem_read = 1;
			cword.memwbmux_sel = 3;
			cword.load_regfile = 1;
		end

		op_store : begin
			cword.alumux2_sel = 3;
			cword.aluop = alu_add;
			cword.mem_write = 1;
		end

		op_imm : begin
			cword.load_regfile = 1;
			cword.aluop = alu_ops'(funct3);
			case(arith_funct3)
				slt : begin
					cword.cmpop = blt;
					cword.memwbmux_sel = 1;
					cword.cmpmux_sel = 1;
				end

				sltu : begin
					cword.cmpop = bltu;
					cword.memwbmux_sel = 1;
					cword.cmpmux_sel = 1;
				end

				sr : begin
					if(funct7[5])
						cword.aluop = alu_sra;
					else
						cword.aluop = alu_srl;
				end

			endcase
		end

		op_reg : begin
			cword.load_regfile = 1;
			cword.alumux2_sel = 4;
			cword.aluop = alu_ops'(funct3);
			case(arith_funct3)
				add : begin
					if(funct7[5])
						cword.aluop = alu_sub;
				end

				slt : begin
					cword.cmpop = blt;
					cword.memwbmux_sel = 1;
				end

				sltu : begin
					cword.cmpop = bltu;
					cword.memwbmux_sel = 1;
				end

				sr : begin
					if(funct7[5])
						cword.aluop = alu_sra;
					else
						cword.aluop = alu_srl;
				end

			endcase
		end

	endcase
end

endmodule : cpu_control
