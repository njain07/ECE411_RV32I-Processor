import rv32i_types::*;

module check_branch_prediction
(
  input logic        prediction,
                     br_en,
  input rv32i_opcode opcode,
  input logic [31:0] btb_out,
                     alu_out,
  output logic       misprediction
);

always_comb begin
  misprediction = 0;
  if(opcode == op_br || opcode == op_jal || opcode == op_jalr ) begin
    if((prediction != br_en) || (btb_out != alu_out))
      misprediction = 1;
  end
end

endmodule
