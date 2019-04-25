module cache_4way_datapath #(
    parameter s_offset = 5,
    parameter s_index  = 8,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)

(
    input logic           clk,

    //Datapath-control signals
    input logic           array_read,
                          array_load,
                          lru_load,
                          pmdr_load,
                          datawritemux_sel,
                          adaptermux_sel,
                          pmemaddrmux_sel,
                          dirty_load,

    output logic          hit,
                          eviction,
    //Cache-CPU signals
    input logic           mem_write,
                          mem_read,
    input logic [31:0]    mem_address,
    input logic [255:0]   mem_wdata,
    output logic [255:0]  mem_rdata,

    //Cache-memory signal
    input logic [255:0]   pmem_rdata,
    output logic [255:0]  pmem_wdata,
    output logic [31:0]   pmem_address
);

logic comp0_select, comp1_select, array0_load, array1_load;
logic lru0_load, lru1_load, dirty0_load, dirty1_load, lru_in;
logic hit0, hit1, eviction0, eviction1, lru_out;
logic [255:0] mem_rdata0, mem_rdata1;
logic [255:0] pmem_wdata0, pmem_wdata1;
logic [31:0] pmem_address0, pmem_address1;

logic[s_tag-1:0] tag_addr;
logic[s_index-1:0] set;
logic[s_offset-1:0] offset;


assign offset = mem_address[s_offset-1:0];
assign set = mem_address[s_offset+s_index-1:s_offset];
assign tag_addr = mem_address[31:s_offset+s_index];

assign comp0_select = (hit & hit0) | (~hit & ~lru_out);
assign comp1_select = (hit & hit1) | (~hit & lru_out);

assign array0_load = array_load & comp0_select;
assign array1_load = array_load & comp1_select;

assign lru0_load = lru_load & comp0_select;
assign lru1_load = lru_load & comp1_select;

assign dirty0_load = dirty_load & comp0_select;
assign dirty1_load = dirty_load & comp1_select;


assign hit = hit0 | hit1;


cache_l2_datapath component0
(
    .*,
    .array_load(array0_load),
    .lru_load(lru0_load),
    .pmdr_load(pmdr_load & ~lru_out),
    .dirty_load(dirty0_load),
    .hit(hit0),
    .eviction(eviction0),
    .mem_rdata(mem_rdata0),
    .pmem_wdata(pmem_wdata0),
    .pmem_address(pmem_address0)
);

cache_l2_datapath component1
(
    .*,
    .array_load(array1_load),
    .lru_load(lru1_load),
    .pmdr_load(pmdr_load & lru_out),
    .dirty_load(dirty1_load),
    .hit(hit1),
    .eviction(eviction1),
    .mem_rdata(mem_rdata1),
    .pmem_wdata(pmem_wdata1),
    .pmem_address(pmem_address1)
);

assign lru_in = hit ? hit0 : ~lru_out;
array #(.s_index(s_index)) lru
(
  .clk,
  .read(array_read),
  .load(lru_load),
  .index(set),
  .datain(lru_in),
  .dataout(lru_out)
);

mux2 #(.width(1)) evictionmux
(
    .sel(lru_out),
    .a(eviction0),
    .b(eviction1),
    .f(eviction)
);

mux2 #(.width(256)) rdatamux
(
    .sel(hit ? hit1 : lru_out),
    .a(mem_rdata0),
    .b(mem_rdata1),
    .f(mem_rdata)
);

mux2 #(.width(256)) pmem_wdatamux
(
    .sel(lru_out),
    .a(pmem_wdata0),
    .b(pmem_wdata1),
    .f(pmem_wdata)
);

mux2 pmem_addrmux
(
    .sel(lru_out),
    .a(pmem_address0),
    .b(pmem_address1),
    .f(pmem_address)
);

endmodule
