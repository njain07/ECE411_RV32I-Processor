import rv32i_types::*;

module tournament_predictor
(
	input logic 				clk,
								local_prediction,
								global_prediction,
								br_en,
	input rv32i_control_word 	idex_controlw,
	output logic 				predictor
);

logic [1:0] state, next_state;
logic take_branch, local_correct, global_correct;

initial
begin
	state = 2'b01;
end

always_comb begin
	take_branch = idex_controlw.branch & br_en | idex_controlw.jump;
	local_correct = (local_prediction == take_branch);
	global_correct = (global_prediction == take_branch);
	predictor = state[1];
    case(state)
      2'b00 : begin
        if(~local_correct & global_correct) next_state = 2'b01;
        else next_state = 2'b00;
      end

      2'b01 : begin
        if(local_correct) next_state = 2'b00;
        else if (global_correct & ~local_correct) next_state = 2'b10;
        else next_state = 2'b01;
      end

      2'b10 : begin
        if(global_correct) next_state = 2'b11;
        else if (~global_correct & local_correct) next_state = 2'b01;
        else next_state = 2'b10;
      end

      2'b11 : begin
        if(~global_correct & local_correct) next_state = 2'b10;
        else next_state = 2'b11;
      end
    endcase
end

always_ff @ (posedge clk)
begin
	state <= next_state;
end

endmodule
