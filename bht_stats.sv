import rv32i_types::*;

module bht_stats
(
    input logic                 clk,
    input logic                 misprediction,
    input rv32i_control_word    idex_controlw,
    output logic [31:0]         num_predictions,
                                num_correct
);

logic [31:0] num_mispredictions;
initial begin
    num_predictions = 0;
    num_mispredictions = 0;
end

assign num_correct = num_predictions - num_mispredictions;

always_ff @(posedge clk) begin
    if(idex_controlw.jump || idex_controlw.branch)
        num_predictions <= num_predictions + 1;
    if(misprediction)
        num_mispredictions <= num_mispredictions + 1;
end

endmodule
