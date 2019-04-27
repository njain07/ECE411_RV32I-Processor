import rv32i_types::*;

module btb #(
	parameter s_index = 10
)
(
  input logic           clk,
                        load_btb,
  input logic [31:0]    target_addr,
                        pc_out,
                        idex_pc_value,
  output logic [31:0]   btb_out
);

// Internal signals
logic btb_load;
logic [s_index-1:0] rindex, windex;

rw_array #(.s_index(s_index), .width(32)) btb_array
(
  .clk,
  .read(1'b1),
  .load(load_btb),
  .rindex(rindex),
  .windex(windex),
  .datain(target_addr),
  .dataout(btb_out)
);

always_comb begin
  rindex = pc_out[s_index+1:2];
  windex = idex_pc_value[s_index+1:2];
end

endmodule : btb
