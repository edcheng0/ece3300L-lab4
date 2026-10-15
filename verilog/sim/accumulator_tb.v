`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: accumulator_tb
// Description: Self-checking testbench for accumulator (N = 4).
//   Checks reset, add, subtract, hold (load = 0), wrap-around, and
//   asynchronous reset in the middle of a clock period.
//////////////////////////////////////////////////////////////////////////////////

module accumulator_tb();
    localparam T = 10;

    reg clk, reset_n, load, add_sub;
    reg [3:0] X;
    wire [3:0] Q;
    wire c_out, overflow;

    reg [3:0] model;        // what Q should be
    integer errors;

    accumulator #(.N(4)) uut (
        .clk(clk), .reset_n(reset_n), .load(load), .add_sub(add_sub),
        .X(X), .Q(Q), .c_out(c_out), .overflow(overflow)
    );

    always
    begin
        clk = 1'b0; #(T / 2);
        clk = 1'b1; #(T / 2);
    end

    // apply one operation for one clock cycle and check the result
    task do_op;
        input ld;
        input sub;
        input [3:0] val;
        begin
            load = ld; add_sub = sub; X = val;
            @(negedge clk);
            if (ld) model = sub ? model - val : model + val;
            if (Q !== model)
            begin
                $display("ERROR t=%0t: load=%b %s %h -> Q=%h, expected %h",
                         $time, ld, sub ? "sub" : "add", val, Q, model);
                errors = errors + 1;
            end
            else
                $display("t=%0t  load=%b  %s %h  ->  Q = %h  OK",
                         $time, ld, sub ? "sub" : "add", val, Q);
        end
    endtask

    initial
    begin
        errors = 0;
        load = 0; add_sub = 0; X = 0;

        // reset
        reset_n = 0; model = 0;
        #(2 * T);
        @(negedge clk) reset_n = 1;
        $display("t=%0t  after reset Q = %h", $time, Q);

        do_op(1, 0, 4'd3);      // 0 + 3 = 3
        do_op(1, 0, 4'd4);      // 3 + 4 = 7
        do_op(0, 0, 4'd9);      // load = 0: stays 7
        do_op(1, 1, 4'd2);      // 7 - 2 = 5
        do_op(1, 0, 4'd15);     // 5 + 15 = 20 -> wraps to 4
        do_op(1, 1, 4'd6);      // 4 - 6 = -2 -> E
        do_op(1, 0, 4'd2);      // E + 2 = 0

        // asynchronous reset in the middle of a cycle
        do_op(1, 0, 4'd9);      // Q = 9
        load = 0;
        #(T / 4) reset_n = 0;   // not on a clock edge
        #1;
        model = 0;
        if (Q !== 4'h0) begin $display("ERROR: async reset failed, Q=%h", Q); errors = errors + 1; end
        else $display("t=%0t  async reset -> Q = %h  OK", $time, Q);
        @(negedge clk) reset_n = 1;

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $stop;
    end
endmodule
