import rv32i_types::*;

module check_branch_prediction
(
  input logic        prediction,
                     br_en,
  input rv32i_control_word idex_controlw,
  input logic [31:0] btb_out,
                     alu_out,
  output logic       misprediction,
                     load_btb,
  output logic [1:0] predmux_sel
);

always_comb begin
    misprediction = 0;
    load_btb = 0;
    predmux_sel = 1;
    if(idex_controlw.branch) begin
        if (btb_out != alu_out || prediction != br_en) begin
            load_btb = 1;
            misprediction = prediction | br_en;
            predmux_sel = {~br_en, 1'b0};
        end

    end else if (idex_controlw.jump) begin
        if((btb_out != alu_out) || ~prediction) begin
          misprediction = 1;
          load_btb = 1;
          predmux_sel = 0;
        end
    end else if (prediction & idex_controlw.opcode) begin
        misprediction = 1;
        predmux_sel = 2;
    end

end

endmodule
