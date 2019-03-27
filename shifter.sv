module shifter #(parameter width = 32)
(
     input [2:0] sel,
     input [width-1:0] in,
     input [width-1:0] address,
     output logic [31:0] out
);
always_comb
begin
    case(sel)

        3'b010: out = in;

        3'b000: begin
            case(address[1:0])
                2'b00: out = in;
                2'b01: out = in << 8;
                2'b10: out = in << 16;
                2'b11: out = in << 24;
            endcase
        end
        3'b001:begin
            case(address[1])
                0: out = in;
                1: out = in << 16 ;
            endcase
        end
        default: out = in;
    endcase
end

endmodule : shifter
