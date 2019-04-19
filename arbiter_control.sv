module arbiter_control
(
    input logic 			clk,

    input logic				pmem_read_a,
    output logic			pmem_resp_a,

    input logic				pmem_read_b,
                            pmem_write_b,
    output logic			pmem_resp_b,

    input logic         	mem_resp,
    output logic        	mem_read,
                            mem_write,
                            req_a,
                            req_b,
                            load_prefetch,

    output logic [1:0]      addrmux_sel
);

enum int unsigned {
    idle,
    s_instr,
    s_data,
    s_prefetch
} state, next_state;

logic get_more_stuff;
initial begin
    get_more_stuff = 0;
end

always_comb
begin
    addrmux_sel = 0;
    req_a = 0;
    req_b = 0;
    mem_read = 0;
    mem_write = 0;
    pmem_resp_a = 0;
    pmem_resp_b = 0;
    load_prefetch = 0;

    case(state)
        //idle:
        s_instr: begin
            addrmux_sel = 0;
            req_a = 1;
            pmem_resp_a = mem_resp;
            mem_read = 1;
            load_prefetch = 1;
        end
        s_data: begin
            addrmux_sel = 1;
            req_b = 1;
            pmem_resp_b = mem_resp;
            mem_read = pmem_read_b;
            mem_write = pmem_write_b;
            load_prefetch = 1;
        end

        s_prefetch: begin
            addrmux_sel = 2;
            mem_read = 1;
        end

    endcase
end

always_comb
begin
    next_state = state;
    case(state)
        idle: begin
            if (pmem_read_a)
                next_state = s_instr;
            else if (pmem_read_b | pmem_write_b)
                next_state = s_data;
            else if (get_more_stuff)
                next_state = s_prefetch;
        end

        s_instr: if (mem_resp) next_state = idle;
        s_data: if (mem_resp) next_state = idle;
        s_prefetch: if (mem_resp) next_state = idle;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
    case (state)
        s_instr: if (~mem_resp) get_more_stuff <= 1;
        s_data: if (~mem_resp) get_more_stuff <= 1;
        s_prefetch: get_more_stuff <= 0;
    endcase
end

endmodule
