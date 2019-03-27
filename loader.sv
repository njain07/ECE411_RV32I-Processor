 module loader #(parameter width = 32)
         (
             input [2:0] load_sel,
             input [width-1:0] in,
				 input [width-1:0] address,
             output logic [31:0] out
			);
         always_comb
			
			begin 
			case(load_sel)
			
			3'b010: out = in;
			
			3'b000:begin
					case(address[1:0])
						2'b00: out = 32'(signed'(in[7:0]));
						2'b01: out = 32'(signed'(in[15:8]));
						2'b10: out = 32'(signed'(in[23:16]));
						2'b11: out = 32'(signed'(in[31:24]));
					endcase	
				end	
			3'b001:begin
					case(address[1])
						0: out = 32'(signed'(in[15:0]));
						1: out = 32'(signed'(in[31:16]));
						endcase
					end
		   3'b100:begin
					case(address[1:0])
						2'b00: out = {24'h0000,in[7:0]};
						2'b01: out = {24'h0000,in[15:8]};
						2'b10: out = {24'h0000,in[23:16]};
						2'b11: out = {24'h0000,in[31:24]};
						endcase
					end
			3'b101:begin
					case(address[1])
						0: out = {16'h0000,in[15:0]};
						1: out = {16'h0000,in[31:16]};
						endcase
					end
			default:out = in;
			endcase
			end
			
		endmodule : loader