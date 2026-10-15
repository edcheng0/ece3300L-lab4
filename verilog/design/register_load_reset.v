`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: register_load_reset
// Description: simple_register_load with an added asynchronous, active-low
//              reset (needed for the accumulator's reset_n in Part 2).
//////////////////////////////////////////////////////////////////////////////////

module register_load_reset
    #(parameter N = 4)(
        input clk,
        input reset_n,          // active low: 0 clears the register
        input load,
        input [N - 1:0] I,
        output [N - 1:0] Q
    );

    reg [N - 1:0] Q_reg, Q_next;

    // State register with asynchronous reset
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            Q_reg <= 'b0;
        else
            Q_reg <= Q_next;
    end

    // Next state logic
    always @(load, I, Q_reg)
    begin
        if (load)
            Q_next = I;
        else
            Q_next = Q_reg;
    end

    // Output logic
    assign Q = Q_reg;
endmodule
