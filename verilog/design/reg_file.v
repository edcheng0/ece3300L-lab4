`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: reg_file
// Description: Generic 2^N x BITS register file with one write port and one
//              read port (Lab 4, Part 1).
//   - Write port: N-to-2^N decoder (enabled by WE) picks which register loads.
//   - Read port : N-to-2^N decoder (always enabled) turns on exactly one
//                 tri-state buffer, which drives data_r.
// Uses: simple_register_load.v, decoder_generic.v
//////////////////////////////////////////////////////////////////////////////////

module reg_file
    #(parameter N = 3,          // address width -> 2^N registers
      parameter BITS = 4)(      // width of each register
    input clk,
    // write port
    input WE,
    input [N - 1:0] address_w,
    input [BITS - 1:0] data_w,
    // read port
    input [N - 1:0] address_r,
    output [BITS - 1:0] data_r
    );

    // one "load" line per register (only the addressed one is 1, and only when WE = 1)
    wire [0:2 ** N - 1] load_sel;
    // one "read enable" line per tri-state buffer (exactly one is 1)
    wire [0:2 ** N - 1] read_sel;

    // Write-port decoder: enabled by WE
    decoder_generic #(.N(N)) write_decoder (
        .w(address_w),
        .en(WE),
        .y(load_sel)
    );

    // Read-port decoder: always enabled
    decoder_generic #(.N(N)) read_decoder (
        .w(address_r),
        .en(1'b1),
        .y(read_sel)
    );

    // 2^N registers, each followed by a tri-state buffer onto data_r
    generate
        genvar k;
        for (k = 0; k < 2 ** N; k = k + 1)
        begin: row
            wire [BITS - 1:0] q;    // output of register k

            simple_register_load #(.N(BITS)) register (
                .clk(clk),
                .load(load_sel[k]),
                .I(data_w),
                .Q(q)
            );

            // Tri-state buffer: drive the shared bus only when selected,
            // otherwise high impedance (Z) so other rows can drive it.
            assign data_r = read_sel[k] ? q : {BITS{1'bz}};
        end
    endgenerate
endmodule
