`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: reg_file_application
// Description: Lab 4, Part 1 board test of a 128 x 4 register file (N = 7).
//   SW3..SW0   -> data_w
//   SW10..SW4  -> address (shared by write and read)
//   SW15       -> which address SW10..SW4 is setting
//                 0 = write address, 1 = read address
//   BTND       -> WE (through button.v: synchronizer + edge detector)
//   7-seg AN0  -> data_r in hex
// Uses: reg_file.v, simple_register_load.v, decoder_generic.v, button.v, hex2sseg.v
//////////////////////////////////////////////////////////////////////////////////

module reg_file_application(
    input clk,              // 100 MHz board clock
    input [15:0] sw,
    input btnD,             // down pushbutton
    output [7:0] an,        // 7-seg anodes (active low)
    output [6:0] sseg,      // 7-seg segments gfedcba (active low)
    output dp               // decimal point (active low)
    );

    localparam N = 7;       // 2^7 = 128 rows
    localparam BITS = 4;    // 4 bits per row

    wire [N - 1:0] address_w, address_r;
    wire [BITS - 1:0] data_r;
    wire we_pulse;

    // ---- Address "demultiplexing" ----
    // The 7 address switches are shared. SW15 decides which address register
    // captures them. The other register keeps its last value, so both
    // addresses exist at the same time.
    simple_register_load #(.N(N)) write_addr_reg (
        .clk(clk),
        .load(~sw[15]),         // SW15 = 0 -> switches set the WRITE address
        .I(sw[10:4]),
        .Q(address_w)
    );

    simple_register_load #(.N(N)) read_addr_reg (
        .clk(clk),
        .load(sw[15]),          // SW15 = 1 -> switches set the READ address
        .I(sw[10:4]),
        .Q(address_r)
    );

    // ---- Pushbutton -> one-clock-cycle WE pulse ----
    button we_button (
        .clk(clk),
        .in(btnD),
        .out(we_pulse)
    );

    // ---- The register file ----
    reg_file #(.N(N), .BITS(BITS)) rf (
        .clk(clk),
        .WE(we_pulse),
        .address_w(address_w),
        .data_w(sw[3:0]),
        .address_r(address_r),
        .data_r(data_r)
    );

    // ---- Display data_r on the right-most digit ----
    hex2sseg display (
        .hex(data_r),
        .sseg(sseg)
    );

    assign an = 8'b1111_1110;   // only digit 0 on
    assign dp = 1'b1;           // decimal point off
endmodule
