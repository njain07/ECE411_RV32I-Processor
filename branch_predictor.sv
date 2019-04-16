import rv32i_types::*;
module branch_predictor
  (
  input logic clk,

  input logic addr_load,
  //input logic pred_load,
  input logic [31:0] curr_pc_value,
  input logic [31:0] old_pc_value
  input logic [31:0] addr_value,
  input logic branch_taken,


  output logic [31:0] pc_value,
  output logic prediction
  );

  //Internal Signals

  logic [1:0] pred, new_pred;
  logic pred_load, btb_load;
  logic [9:0] bht_index,btb_index;
  logic [31:0] input_pc,output_pc


  //Modules inside

   array #(.s_index(10),.width(32)) btb_array
   (
   .clk,
   .read(),
   .load(btb_load),
   .index(btb_index),
   .datain(input_pc),
   .dataout(output_pc)
   );

   array #(.s_index(10),.width(2)) bht_array
   (
   .clk,
   .read(),
   .load(bht_load),
   .index(bht_index),
   .datain(new_pred),
   .dataout(pred)
   );

// any btb logic will be written here

always_comb
  begin
    //Initial values
    btb_load = 0;
    bht_load = 0;
    btb_index = 0;
    bht_index = 0;
    input_pc = 0;
    new_pred = 0;

    btb_index = curr_pc_value[9:0];
    pc_value = output_pc;

    bth_index = curr_pc_value[9:0];
    if (pred[1] == 1'b0)
      prediction = 0;
    else
      prediction =1;


    bth_index = old_pc_value[9:0];
    case(pred)
        2'b00:begin
          if(branch_taken)
            new_pred = 2'b01;
          else
            new_pred = 2'b00;
        end

        2'b01:begin
          if(branch_taken)
            new_pred = 2'b10;
          else
            new_pred = 2'b00;
        end

        2'b10:begin
          if(branch_taken)
            new_pred = 2'b11;
          else
            new_pred = 2'b01;
        end

        2'b11:begin
          if(branch_taken)
            new_pred = 2'b11;
          else
            new_pred = 2'b10;
        end

      endcase

    if(addr_load)
      begin
        bht_load = 1'b1;
        btb_index = old_pc_value[9:0];
        input_pc = addr_value;
        btb_load = 1'b1;
    end

  end

  always_ff @(posedge clk)
  begin


  end

endmodule
