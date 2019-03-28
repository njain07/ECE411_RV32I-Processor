module shifter #(parameter width = 32)
(
     input [2:0] sel,
     input [width-1:0] in,
     input [width-1:0] address,
     output logic [31:0] out,
     output logic [3:0] wmask
);
always_comb
begin
    case(sel)
        3'b010: begin
            out = in;
            wmask = 4'b1111;
        end
        3'b000: begin
            case(address[1:0])
                2'b00: begin
                    out = in;
                    wmask = 4'b0001;
                end
                2'b01: begin
                    out = in << 8;
                    wmask = 4'b0010;
                end
                2'b10: begin
                    out = in << 16;
                    wmask = 4'b0100;
                end
                2'b11: begin
                    out = in << 24;
                    wmask = 4'b1000;
                end
            endcase
        end
        3'b001:begin
            case(address[1])
                0: begin
                     out = in;
                     wmask = 4'b0011;
                 end
                1: begin
                     out = in << 16;
                     wmask = 4'b1100;
                 end
            endcase
        end
        default: begin
            out = in;
            wmask = 4'b1111;
        end
    endcase
end

endmodule : shifter
