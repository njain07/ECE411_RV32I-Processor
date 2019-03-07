module pipeline_reg_signals
(
  input logic  clk,
               stall,
               opcode,
  output logic if_id_load,
               id_ex_load,
               ex_mem_load,
               mem_wb_load,
               if_id_store,
               id_ex_store,
               ex_mem_store,
               mem_wb_store,
);

always_ff @ (posedge clk) begin
  if_id_load <= ~stall;
  id_ex_load <= ~stall;
  ex_mem_load <= id_ex_load || ~stall; //prev_load || curr_load
  mem_wb_load <= ex_mem_load;
end

always_ff @ (negedge clk) begin
  if_id_store <= ~stall;
  id_ex_store <= ~stall;
  ex_mem_store <= id_ex_store || ~stall;
  mem_wb_store <= ex_mem_store;
end

endmodule : pipeline_reg_signals
