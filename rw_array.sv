
module rw_array #(
	parameter s_index = 3,
	parameter width = 1
)
(
	input logic 							clk,
	 													read,
	 													load,
	input logic [s_index-1:0] rindex,
					 									windex,
														datain,
	input logic [width-1:0]		initial_values,
	output logic [width-1:0] 	dataout
);

localparam num_sets = 2**s_index;

logic [width-1:0] data [num_sets-1:0] /* synthesis ramstyle = "logic" */;
logic [width-1:0] _dataout;
assign dataout = _dataout;

/* Initialize array */
initial
begin
    for (int i = 0; i < num_sets; i++)
    begin
        data[i] = initial_values;
    end
end

always_ff @(posedge clk)
begin
    if (read)
        _dataout <= (load  & (rindex == windex)) ? datain : data[rindex];

    if(load)
        data[windex] <= datain;
end

endmodule : rw_array
