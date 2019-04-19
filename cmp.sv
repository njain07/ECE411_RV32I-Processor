import rv32i_types::*;

module cmp
(
	input branch_funct3_t cmpop,
	input rv32i_word a, b,
	output logic f
);

always_comb
begin
	case (cmpop)
		beq: f = a == b;
		bne: f = a != b;
		bltu: f = a < b;
		bgeu: f = a >= b;
		blt: f = $signed(a) < $signed(b);
		bge: f = $signed(a) >= $signed(b);
	endcase
end

endmodule
