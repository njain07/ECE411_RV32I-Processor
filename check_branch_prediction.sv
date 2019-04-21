import rv32i_types::*;

module check_branch_prediction
(
  input logic        prediction,
                     br_en,
  input rv32i_control_word idex_controlw,
  input logic [31:0] btb_out,
                     alu_out,
  output logic       misprediction
);

always_comb begin
  misprediction = 0;
  if(idex_controlw.branch | idex_controlw.jump ) begin
    if((prediction != br_en) || (btb_out != alu_out))
      misprediction = 1;
  end
end

endmodule
