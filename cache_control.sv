
module cache_control
(
    input logic          clk,

    //Control-datapath signals
    input logic           hit,
                          way,
                          lru_out,
    input logic [1:0]     dirty_out,
    output logic          array_read,
                          array1_load,
                          array2_load,
                          lru_load,
                          pmdr_load,
                          datareadmux_sel,
                          datawritemux_sel,
                          adaptermux_sel,
                          pmemaddrmux_sel,
    output logic [1:0]    dirty_load,

    //Control-CPU signals
    input logic           mem_write,
                          mem_read,
    input logic [3:0]     mem_byte_enable,
    output logic          mem_resp,

    //Control-memory signals
    input logic           pmem_resp,
    output logic          pmem_write,
                          pmem_read
);


enum int unsigned {
    check,
    write_back,
    update,
    update_read
} state, next_state;

always_comb
begin : state_actions
    //Default values
    array_read = 1;
    array1_load = 0;
    array2_load = 0;
    lru_load = 0;
    mem_resp = 0;
    pmem_write = 0;
    pmem_read = 0;
    pmdr_load = 0;
    datareadmux_sel = 0;
    datawritemux_sel = 0;
    adaptermux_sel = 0;
    pmemaddrmux_sel = 0;
    dirty_load = 2'b00;

    case(state)
      check:
        if (hit) begin
          lru_load = 1;
          mem_resp = 1;
          datareadmux_sel = way;
          adaptermux_sel = 0;
          if (mem_write) begin
            if (way)
              array2_load = 1;
            else
              array1_load = 1;
            dirty_load[way] = 1;
            datawritemux_sel = 1;
          end
        end

      write_back: begin
        datareadmux_sel = lru_out;
        pmemaddrmux_sel = 1;
        pmem_write = 1;
      end

      update: begin
        dirty_load[lru_out] = 1;
        if (mem_read) begin
          pmem_read = 1;
          pmdr_load = 1;
          pmemaddrmux_sel = 0;
        end else begin
          if (lru_out)
            array2_load = 1;
          else
            array1_load = 1;
          lru_load = 1;
          mem_resp = 1;
          datareadmux_sel = lru_out;
          datawritemux_sel = 1;
        end
      end

      update_read: begin
        if (lru_out)
          array2_load = 1;
        else
          array1_load = 1;
        lru_load = 1;
        mem_resp = 1;
        datareadmux_sel = lru_out;
        datawritemux_sel = 0;
        adaptermux_sel = 1;
      end

    endcase
end

always_comb
begin : next_state_logic
    next_state = state;
    case(state)
      check: begin
        if (~mem_read & ~mem_write)
            next_state = check;
        else begin
            if (hit) begin
              next_state = check;
            end else begin
              if (dirty_out[lru_out])
                next_state = write_back;
              else
                next_state = update;
            end
        end
      end

      write_back: if (pmem_resp) next_state = update;

      update: begin
      if (mem_write)
        next_state = check;
      else
        if (pmem_resp)
          next_state = update_read;
      end

      update_read: next_state = check;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : cache_control
