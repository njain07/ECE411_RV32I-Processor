import rv32i_types::*;

module check_branch_prediction
(
  input logic        prediction,
                     br_en,
  input rv32i_control_word idex_controlw,
  input logic [31:0] btb_out,
                     alu_out,
  output logic       misprediction,
                     load_btb
);

always_comb begin
    misprediction = 0;
    load_btb = 0;
    if(idex_controlw.branch) begin
        if (btb_out != alu_out) begin
            load_btb = 1;
            misprediction = br_en;
        end
        if (prediction != br_en)
            misprediction = 1;

        end else if (idex_controlw.jump) begin
        if((btb_out != alu_out) || ~prediction) begin
          misprediction = 1;
          load_btb = 1;
        end else if (prediction) begin
        misprediction = 1;
        end
    end
end

endmodule
