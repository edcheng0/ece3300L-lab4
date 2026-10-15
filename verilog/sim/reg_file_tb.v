`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: reg_file_tb
// Description: Self-checking testbench for reg_file (N = 3 -> 8 rows, BITS = 4).
//   1) Write a different value into every row
//   2) Read every row back and compare
//   3) Try a write with WE = 0 and confirm nothing changes
//   4) Write and read different rows in the same cycle (dual port)
//////////////////////////////////////////////////////////////////////////////////

module reg_file_tb();
    localparam N = 3;
    localparam BITS = 4;
    localparam T = 10;

    reg clk, WE;
    reg [N - 1:0] address_w, address_r;
    reg [BITS - 1:0] data_w;
    wire [BITS - 1:0] data_r;

    integer i, errors;

    reg_file #(.N(N), .BITS(BITS)) uut (
        .clk(clk), .WE(WE),
        .address_w(address_w), .data_w(data_w),
        .address_r(address_r), .data_r(data_r)
    );

    // clock
    always
    begin
        clk = 1'b0; #(T / 2);
        clk = 1'b1; #(T / 2);
    end

    // expected value stored in row a
    function [BITS - 1:0] expected;
        input [N - 1:0] a;
        expected = (a * 3 + 5) % 16;
    endfunction

    initial
    begin
        errors = 0;
        WE = 0; address_w = 0; address_r = 0; data_w = 0;
        @(negedge clk);

        // 1) write every row
        $display("--- Writing all rows ---");
        for (i = 0; i < 2 ** N; i = i + 1)
        begin
            address_w = i;
            data_w = expected(i);
            WE = 1;
            @(negedge clk);
            $display("t=%0t  wrote row %0d <- %h", $time, i, data_w);
        end
        WE = 0;

        // 2) read every row
        $display("--- Reading all rows ---");
        for (i = 0; i < 2 ** N; i = i + 1)
        begin
            address_r = i;
            #1;
            if (data_r !== expected(i))
            begin
                $display("ERROR row %0d: got %h, expected %h", i, data_r, expected(i));
                errors = errors + 1;
            end
            else
                $display("t=%0t  read  row %0d -> %h  OK", $time, i, data_r);
            @(negedge clk);
        end

        // 3) WE = 0 must not write
        $display("--- Write attempt with WE = 0 ---");
        address_w = 2; data_w = 4'hF; WE = 0;
        @(negedge clk);
        address_r = 2; #1;
        if (data_r !== expected(2))
        begin
            $display("ERROR: row 2 changed with WE = 0 (got %h)", data_r);
            errors = errors + 1;
        end
        else
            $display("t=%0t  row 2 still %h  OK", $time, data_r);

        // 4) simultaneous write (row 6) and read (row 1)
        $display("--- Simultaneous write row 6 / read row 1 ---");
        address_w = 6; data_w = 4'hA; WE = 1; address_r = 1;
        #1;
        if (data_r !== expected(1))
        begin
            $display("ERROR: read of row 1 disturbed (got %h)", data_r);
            errors = errors + 1;
        end
        else
            $display("t=%0t  row 1 -> %h while writing row 6  OK", $time, data_r);
        @(negedge clk);
        WE = 0; address_r = 6; #1;
        if (data_r !== 4'hA)
        begin
            $display("ERROR: row 6 = %h, expected a", data_r);
            errors = errors + 1;
        end
        else
            $display("t=%0t  row 6 -> %h  OK", $time, data_r);

        if (errors == 0) $display("=== ALL TESTS PASSED ===");
        else             $display("=== %0d TEST(S) FAILED ===", errors);
        $stop;
    end
endmodule
