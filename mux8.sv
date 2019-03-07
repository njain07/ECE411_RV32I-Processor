module mux8 #(parameter width = 32)
(
	input [2:0] sel,
	input [width-1:0] a, b, c, d, e, f, g, h,
	output logic [width-1:0] q
);

always_comb
	begin
		case (sel)
			3'b000 : q = a;
			3'b001 : q = b;
			3'b010 : q = c;
			3'b011 : q = d;
			3'b100 : q = e;
			3'b101 : q = f;
			3'b110 : q = g;
			3'b111 : q = h;
		endcase
	end

endmodule // mux8
