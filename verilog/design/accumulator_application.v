`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: accumulator_application
// Description: Lab 4, Part 2 board test of the 4-bit accumulator.
//   SW3..SW0    -> X
//   SW15        -> Add/Sub (0 = add, 1 = subtract)
//   BTND        -> load (one add/subtract per press)
//   CPU_RESETN  -> reset_n (already active low on the board)
//   7-seg AN0   -> accumulator value in hex
// Uses: accumulator.v, button_debounce.v, hex2sseg.v (+ their sub-modules)
//////////////////////////////////////////////////////////////////////////////////

module accumulator_application(
    input clk,              // 100 MHz board clock
    input [15:0] sw,
    input btnD,             // down pushbutton
    input cpu_resetn,       // red CPU RESET button, 0 when pressed
    output [7:0] an,
    output [6:0] sseg,
    output dp
    );

    wire load_pulse;
    wire [3:0] acc;
    wire c_out, overflow;   // not displayed, but available

    // One clean pulse per press (debounced so bounce can't add twice)
    button_debounce #(.N(3), .DIV(1_000_000)) load_button (
        .clk(clk),
        .in(btnD),
        .out(load_pulse)
    );

    accumulator #(.N(4)) acc0 (
        .clk(clk),
        .reset_n(cpu_resetn),
        .load(load_pulse),
        .add_sub(sw[15]),
        .X(sw[3:0]),
        .Q(acc),
        .c_out(c_out),
        .overflow(overflow)
    );

    hex2sseg display (
        .hex(acc),
        .sseg(sseg)
    );

    assign an = 8'b1111_1110;   // only digit 0 on
    assign dp = 1'b1;           // decimal point off
endmodule
