module bht_array #(
	parameter s_index = 10,
	parameter width = 2
)
(
	input logic 				clk,
	 							read,
	 							load,
	input logic [s_index-1:0] 	rindex,
					 			windex,
	input logic [width-1:0]		datain,
	output logic [width-1:0] 	dataout
);

localparam num_sets = 2**s_index;

logic [width-1:0] data [num_sets-1:0] /* synthesis ramstyle = "logic" */;
// logic [width-1:0] _dataout;
assign dataout = data[rindex];

/* Initialize array */
initial
begin
    for (int i = 0; i < num_sets; i++)
    begin
        data[i] = 2'b01;
    end
end

always_ff @(posedge clk)
begin
    if(load)
        data[windex] <= datain;
end

endmodule : bht_array

/**********************************************************************************/

module branch_predictor #(
	parameter s_index = 10
)
(
	input logic 				clk,
	input logic [s_index-1:0] 	rindex,
	 							windex,
	input logic 				br_en,
								jump,
								branch,
								load_bht,

	input logic [1:0] 			idex_pred_state,
  	output logic [1:0]			pred
);

logic [1:0] new_pred;

bht_array #(.s_index(s_index)) bht_array
(
	.clk,
	.read(1'b1),
	.load(load_bht),
	.rindex(rindex),
	.windex(windex),
	.datain(new_pred),
	.dataout(pred)
);

always_comb begin
	new_pred = 0;

	if(branch | jump) begin
	    case(idex_pred_state)
	      2'b00 : begin
	        if(br_en | jump) new_pred = 2'b01;
	        else new_pred = 2'b00;
	      end

	      2'b01 : begin
	        if(br_en | jump) new_pred = 2'b10;
	        else new_pred = 2'b00;
	      end

	      2'b10 : begin
	        if(br_en | jump) new_pred = 2'b11;
	        else new_pred = 2'b01;
	      end

	      2'b11 : begin
	        if(br_en | jump) new_pred = 2'b11;
	        else new_pred = 2'b10;
	      end
	    endcase
	end
end

endmodule : branch_predictor
