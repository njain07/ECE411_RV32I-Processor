module cache_l2_control
(
    input logic          clk,

    //Control-datapath signals
    input logic           hit,
                          eviction,
    output logic          array_read,
                          array_load,
                          lru_load,
                          pmdr_load,
                          datawritemux_sel,
                          adaptermux_sel,
                          pmemaddrmux_sel,
                          dirty_load,

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

<<<<<<< HEAD
logic get_more_stuff, mem_access, prefetch_reg, check_prefetch;

assign prefetch = prefetch_reg | check_prefetch;
assign mem_access = mem_read | mem_write;

initial begin
    get_more_stuff = 0;
    prefetch_reg = 0;
end

=======
logic mem_access;
assign mem_access = mem_read | mem_write;

>>>>>>> devel
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
    array_load = 0;
    lru_load = 0;
    mem_resp = 0;
    pmem_write = 0;
    pmem_read = 0;
    pmdr_load = 0;
    datawritemux_sel = 0;
    adaptermux_sel = 0;
    pmemaddrmux_sel = 0;
    dirty_load = 0;
    check_prefetch = 0;

    case(state)
      check: begin
<<<<<<< HEAD
        check_prefetch = mem_access ? 0 : get_more_stuff;
        if (mem_access | check_prefetch) begin
            if (hit) begin
                lru_load = 1;
                mem_resp = ~check_prefetch;
=======
        if (mem_access) begin
            if (hit) begin
                lru_load = 1;
                mem_resp = 1;
>>>>>>> devel
                adaptermux_sel = 0;
                if (mem_write) begin
                  array_load = 1;
                  dirty_load = 1;
                  datawritemux_sel = 1;
                end
            end
        end
      end

      write_back: begin
        pmemaddrmux_sel = 1;
        pmem_write = 1;
      end

      update: begin
        dirty_load = 1;
<<<<<<< HEAD
        if (mem_read | prefetch_reg) begin
=======
        if (mem_read) begin
>>>>>>> devel
          pmem_read = 1;
          pmdr_load = 1;
          pmemaddrmux_sel = 0;
        end else begin
          array_load = 1;
          lru_load = 1;
          mem_resp = 1;
          datawritemux_sel = 1;
        end
      end

      update_read: begin
        array_load = 1;
        datawritemux_sel = 0;
        adaptermux_sel = 1;
<<<<<<< HEAD
        if (~prefetch_reg) begin
            lru_load = 1;
            mem_resp = 1;
        end
=======
        lru_load = 1;
        mem_resp = 1;
>>>>>>> devel
      end

      endcase

end

always_comb
begin : next_state_logic
    next_state = state;
    case(state)
      check: begin
<<<<<<< HEAD
         if (mem_access | check_prefetch) begin
=======
         if (mem_access) begin
>>>>>>> devel
            if (hit) begin
              next_state = check;
            end else begin
              if (eviction)
                next_state = write_back;
              else
                next_state = update;
            end
         end
      end

      write_back: if (pmem_resp) next_state = update;

      update: begin
<<<<<<< HEAD
      if (mem_write & ~prefetch_reg)
=======
      if (mem_write)
>>>>>>> devel
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
<<<<<<< HEAD
    case (state)
        check: begin
            prefetch_reg <= check_prefetch;
            if (~mem_access & hit) get_more_stuff <= 0;
        end
        update_read : get_more_stuff <= mem_access;
    endcase
=======
>>>>>>> devel
end

endmodule : cache_l2_control
