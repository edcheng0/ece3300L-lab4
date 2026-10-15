`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: accumulator
// Description: N-bit accumulator (Lab 4, Part 2, Figure 2).
//   On a clock edge with load = 1:  acc <= acc + X  (add_sub = 0)
//                                    acc <= acc - X  (add_sub = 1)
// Uses: adder_subtractor.v (-> rca_nbit.v -> full_adder.v -> half_adder.v),
//       register_load_reset.v
//////////////////////////////////////////////////////////////////////////////////

module accumulator
    #(parameter N = 4)(
    input clk,
    input reset_n,
    input load,
    input add_sub,              // 0 = add, 1 = subtract
    input [N - 1:0] X,
    output [N - 1:0] Q,         // accumulator value
    output c_out,
    output overflow
    );

    wire [N - 1:0] sum;

    // Q feeds back into the adder's first input (the loop in Figure 2)
    adder_subtractor #(.n(N)) alu (
        .x(Q),
        .y(X),
        .add_n(add_sub),
        .s(sum),
        .c_out(c_out),
        .overflow(overflow)
    );

    register_load_reset #(.N(N)) acc_reg (
        .clk(clk),
        .reset_n(reset_n),
        .load(load),
        .I(sum),
        .Q(Q)
    );
endmodule
