import rv32i_types::*;

module branch_predictor
(
  input logic clk,
  input logic [31:0] pc_out,
  input logic [31:0] idex_pc_value,
  input logic br_en,
  input logic jump,

  output logic prediction
);

// Internal Signals
logic [1:0] pred, new_pred;
logic pred_load;
logic [9:0] rindex, windex;

rw_array #(.s_index(10), .width(2)) bht_array
(
  .clk,
  .read(1),
  .load(bht_load),
  .rindex(rindex),
	.windex(windex),
  .datain(new_pred),
  .dataout(pred),
	.initial_values(2'b01)	//weakly not taken
);

always_comb begin
  bht_load = 0;
  new_pred = 0;

  // Read
  rindex = pc_out[9:0];
  if (pred[1] == 1'b0)
    prediction = 0;
  else
    prediction = 1;

  // Write
	windex = idex_pc_value[9:0];
  if(jump)
    new_pred = 2'b11;
  else begin
    case(pred)
      2'b00 : begin
        if(br_en) new_pred = 2'b01;
        else new_pred = 2'b00;
      end

      2'b01 : begin
        if(br_en) new_pred = 2'b10;
        else new_pred = 2'b00;
      end

      2'b10 : begin
        if(br_en) new_pred = 2'b11;
        else new_pred = 2'b01;
      end

      2'b11 : begin
        if(br_en) new_pred = 2'b11;
        else new_pred = 2'b10;
      end
    endcase
  end
  bht_load = 1'b1;
end

endmodule : branch_predictor
