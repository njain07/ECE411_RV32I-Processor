import rv32i_types::*;

module btb
(
  input logic         clk,
                      load_btb,
  input logic [31:0]  target_addr,
							 pc_out,
							 idex_pc_value,
  output logic [31:0] btb_out
);

// Internal signals
logic btb_load;
logic [9:0] rindex, windex;

rw_array #(.s_index(10), .width(32)) btb_array
(
  .clk,
  .read(1'b1),
  .load(btb_load),
  .rindex(rindex),
	.windex(windex),
  .datain(target_addr),
  .dataout(btb_out)
  // .initial_values(32'b0)
);

always_comb begin
  btb_load = 0;
  rindex = pc_out[9:0];
  windex = idex_pc_value[9:0];

  if(load_btb) btb_load = 1;
end

endmodule : btb
