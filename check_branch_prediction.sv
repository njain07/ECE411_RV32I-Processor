module check_branch_prediction
(
  input logic        prediction,
                     br_en,
  input logic [31:0] btb_out,
                     alu_out,
  output logic       misprediction
);

always_comb begin
  misprediction = 1;
  if(prediction == br_en) && (btb_out == alu_out)
    misprediction = 0;
end
