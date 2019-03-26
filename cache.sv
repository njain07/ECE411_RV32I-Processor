module cache #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
    input logic             clk,
                            read_a,
                            read_b,
                            write,
    output logic            resp_a,
                            resp_b,
    input logic [31:0]      address_a,
                            address_b,
                            wdata,
    input logic [3:0]       wmask,
    output logic [31:0]     rdata_a,
                            rdata_b,

    input logic             pmem_resp,
    output logic            pmem_read,
                            pmem_write,
    input logic [255:0]     pmem_rdata,
    output logic [255:0]    pmem_wdata,
    output logic [31:0]     pmem_address
);

logic pmem_read_a, pmem_resp_a, pmem_read_b, pmem_resp_b, pmem_write_b;
logic [31:0] pmem_addr_a, pmem_addr_b;
logic [255:0] pmem_rdata_a, pmem_rdata_b, pmem_wdata_b;

instr_cache instr_cache (.*);
data_cache data_cache (.*);
cache_arbiter arbiter (.*);

endmodule : cache
