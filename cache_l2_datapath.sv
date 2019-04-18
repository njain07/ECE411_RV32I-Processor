module cache_l2_datapath #(
    parameter s_offset = 5,
    parameter s_index  = 5,
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
                          prefetch,

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

logic[s_tag-1:0] tag_addr;
logic[s_index-1:0] set;
logic[s_offset-1:0] offset;

logic valid1_out, valid2_out, way, lru_out, tag1_hit, tag2_hit, datareadmux_sel;
logic array1_load, array2_load, mem_access, dirty_in, lru_in;
logic [1:0] set_dirty, dirty_out;
logic [s_tag-1:0] tag1_out, tag2_out, tag_lru;
logic [s_line-1:0] data1_out, data2_out, wdata, wdata256;
logic [s_line-1:0] rdata, rdata256, pmdr_out;
logic [s_mask-1:0] data1_load, data2_load, data_load256, data_load;
logic [31:0] addr, prefetch_addr;

assign mem_access = mem_read | mem_write;

/*
 * Hardware prefetch
 */
register prefetch_mem_address
(
    .clk,
    .load(mem_access & ~prefetch),
    .in(mem_address),
    .out(prefetch_addr)
);

mux2 addr_mux
(
    .sel(prefetch),
    .a(mem_address),
    .b(prefetch_addr + 32'h00000032),
    .f(addr)
);


/*
 * Address decoder
 */
assign offset = addr[s_offset-1:0];
assign set = addr[s_offset+s_index-1:s_offset];
assign tag_addr = addr[31:s_offset+s_index];

/*
 * Valid
 */

array #(.s_index(s_index)) valid[1:0]
(
    clk,
    array_read,
    {array1_load,array2_load},
    set,
    1'b1,
    {valid1_out,valid2_out}
);

/*
 * LRU
 */

assign lru_in = hit ? ~way : ~lru_out;
array #(.s_index(s_index)) lru
(
  .clk,
  .read(array_read),
  .load(lru_load),
  .index(set),
  .datain(lru_in),
  .dataout(lru_out)
);

/*
 * Dirty
 */

assign dirty_in = prefetch ? 0 : mem_write;

array #(.s_index(s_index)) dirty[1:0]
(
    clk,
    array_read,
    set_dirty,
    set,
    dirty_in,
    dirty_out
);

/*
 * Tag
 */

array #(.width(s_tag), .s_index(s_index)) tag[1:0]
(
    clk,
    array_read,
    {array1_load,array2_load},
    set,
    tag_addr,
    {tag1_out,tag2_out}
);


mux2 #(.width(s_tag)) tagmux
(
  .sel(lru_out),
  .a(tag1_out),
  .b(tag2_out),
  .f(tag_lru)
);

assign tag1_hit = valid1_out & (tag1_out == tag_addr);
assign tag2_hit = valid2_out & (tag2_out == tag_addr);

assign hit = tag1_hit | tag2_hit;
assign way = tag1_hit ? 0 : 1;

assign way0_select = hit ? ~way : ~lru_out;
assign way1_select = hit ? way : lru_out;

assign array1_load = array_load & ( (mem_write & way0_select) |
                                    (mem_read & ~lru_out) );

assign array2_load = array_load & ( (mem_write & way1_select) |
                                    (mem_read & lru_out) );

assign datareadmux_sel = hit ? way : lru_out;
assign set_dirty[0] = dirty_load & way0_select;
assign set_dirty[1] = dirty_load & way1_select;
assign eviction = dirty_out[lru_out];

/*
 * Physical memory
 */

assign pmem_wdata = rdata;

mux2 pmemaddr_mux
(
  .sel(pmemaddrmux_sel),
  .a(addr),
  .b({tag_lru, set, 5'd0}),
  .f(pmem_address)
);

/*
 * Data
*/

assign data1_load = {32{array1_load}};
assign data2_load = {32{array2_load}};

data_array #(.s_index(s_index)) line[1:0]
(
    clk,
    array_read,
    {data1_load,data2_load},
    set,
    wdata,
    {data1_out,data2_out}
);


mux2 #(.width(256)) datareadmux
(
  .sel(datareadmux_sel),
  .a(data1_out),
  .b(data2_out),
  .f(rdata)
);

mux2 #(.width(256)) datawritemux
(
  .sel(datawritemux_sel),
  .a(pmdr_out),
  .b(mem_wdata),
  .f(wdata)
);

register #(.width(256)) pmdr
(
  .clk,
  .load(pmdr_load),
  .in(pmem_rdata),
  .out(pmdr_out)
);

/*
 * Adapter
 */

mux2 #(.width(256)) adaptermux
(
  .sel(adaptermux_sel),
  .a(rdata),
  .b(pmdr_out),
  .f(mem_rdata)
);

endmodule : cache_l2_datapath
