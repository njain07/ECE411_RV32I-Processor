import rv32i_types::*;

module cpu_control
(

);

enum int unsigned {
	/* List of states */
	s_fetch1,
	s_fetch2,
	s_fetch3,
	s_decode,
	s_aupic,
	s_imm,
	s_br,
	s_calc_addr,
	s_ldr1,
	s_ldr2,
	s_str1,
	s_str2,
	s_lui,
	s_reg,
	s_jal,
	s_jalr
	// do we need more states??
} state, next_state;

always_comb
begin: state_actions
	/* Default output assignments */

	/* Actions for each state */
	case(state)
		s_fetch1 : begin
		end

		s_fetch2 : begin
		end

		s_fetch3 : begin
		end

		s_decode : ;

		s_aupic : begin
		end

		s_imm : begin
		end

		s_br : begin
		end

		s_calc_addr : begin
		end

		s_ldr1 : begin
		end

		s_ldr2 : begin
		end

		s_str1 : begin
		end

		s_str2 : begin
		end

		s_lui : begin
		end

		s_reg : begin
		end

		s_jal : begin
		end

		s_jalr : begin
		end

		default : ;
	endcase 
end

always_comb
begin : next_state_logic
	next_state = state;
	case(state)
		s_fetch1 : begin
		end

		s_fetch2 : begin
		end

		s_fetch3 : begin
		end

		s_decode : ;

		s_aupic : begin
		end

		s_imm : begin
		end

		s_br : begin
		end

		s_calc_addr : begin
		end

		s_ldr1 : begin
		end

		s_ldr2 : begin
		end

		s_str1 : begin
		end

		s_str2 : begin
		end

		s_lui : begin
		end

		s_reg : begin
		end

		s_jal : begin
		end

		s_jalr : begin
		end

		default : ;
	endcase 
end

always_ff @(posedge clk)
begin: next_state_assignment
	state <= next_state;
end

endmodule : cpu_control