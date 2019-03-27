
 module shifter #(parameter width = 32)
         (
             input [3:0] sel,
             input [width-1:0] in,
             output logic [width-1:0] out
			);
         always_comb
         case(sel)
				4'b0001: out = in ;
				4'b0010: out = in << 8;
				4'b0100: out = in << 16;
				4'b1000: out = in << 24;
				4'b1100: out = in <<16;
				4'b0011: out = in;
				default: out = in ;
			endcase

endmodule : shifter