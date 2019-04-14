module cache_datapath #(
    parameter s_offset = 5,
    parameter s_index  = 3,
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
    input logic           dirty_load,

    output logic          hit,
                          eviction,
    //Cache-CPU signals
    input logic           mem_write,
                          mem_read,
    input logic [3:0]     mem_byte_enable,
    input logic [31:0]    mem_address,
                          mem_wdata,
    output logic [31:0]   mem_rdata,

    //Cache-memory signal
    input logic [255:0]   pmem_rdata,
    output logic [255:0]  pmem_wdata,
    output logic [31:0]   pmem_address
);

logic[23:0] tag_addr;
logic[2:0] set;
logic[4:0] offset;

logic valid1_out, valid2_out, way, lru_out, tag1_hit, tag2_hit, datareadmux_sel;
logic array1_load, array2_load;
logic [1:0] set_dirty, dirty_out;
logic [23:0] tag1_out, tag2_out, tag_lru;
logic [255:0] data1_out, data2_out, wdata, wdata256;
logic [255:0] rdata, rdata256, pmdr_out;
logic [31:0] data1_load, data2_load, data_load256, data_load;
/*
 * Address decoder
 */
decoder addr_decoder
(
  .in(mem_address),
  .tag(tag_addr),
  .set,
  .offset
);

/*
 * Valid
 */


array valid[1:0]
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
array lru
(
  .clk,
  .read(array_read),
  .load(lru_load),
  .index(set),
  .datain((hit & ~way) | (~hit & ~lru_out)),
  .dataout(lru_out)
);

/*
 * Dirty
 */

array dirty[1:0]
(
    clk,
    array_read,
    set_dirty,
    set,
    mem_write,
    dirty_out
);

/*
 * Tag
 */

array #(.width(24)) tag[1:0]
(
    clk,
    array_read,
    {array1_load,array2_load},
    set,
    tag_addr,
    {tag1_out,tag2_out}
);


mux2 #(.width(24)) tagmux
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

assign array1_load = array_load & ((mem_write & (hit & ~way) | (~hit & ~lru_out)) |
                                  (mem_read & ~lru_out));

assign array2_load = array_load & ((mem_write & (hit & way) | (~hit & lru_out)) |
                                (mem_read & lru_out));

assign datareadmux_sel = hit ? way : lru_out;
assign set_dirty[0] = dirty_load & ((hit & ~way) | (~hit & ~lru_out));
assign set_dirty[1] = dirty_load & ((hit & way) | (~hit & lru_out));
assign eviction = dirty_out[lru_out];

/*
 * Physical memory
 */

assign pmem_wdata = rdata;

mux2 pmemaddr_mux
(
  .sel(pmemaddrmux_sel),
  .a(mem_address),
  .b({tag_lru, set, 5'd0}),
  .f(pmem_address)
);

/*
 * Data
*/

data_array line[1:0]
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
  .b(wdata256),
  .f(wdata)
);

mux2 dataloadmux
(
  .sel(mem_write),
  .a(32'hffffffff),
  .b(data_load256),
  .f(data_load)
);

register #(.width(256)) pmdr
(
  .clk,
  .load(pmdr_load),
  .in(pmem_rdata),
  .out(pmdr_out)
);

assign data1_load = {32{array1_load}} & data_load;
assign data2_load = {32{array2_load}} & data_load;

/*
 * Adapter
 */

mux2 #(.width(256)) adaptermux
(
  .sel(adaptermux_sel),
  .a(rdata),
  .b(pmdr_out),
  .f(rdata256)
);

//MODULE PROBABLY NEEDS TO CHANGE FOR STORES
bus_adapter adapter
(
  .mem_wdata256(wdata256),
  .mem_rdata256(rdata256),
  .mem_wdata,
  .mem_rdata,
  .mem_byte_enable,
  .mem_byte_enable256(data_load256),
  .address(mem_address)
);


endmodule : cache_datapath
