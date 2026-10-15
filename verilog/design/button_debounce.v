`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: button_debounce
// Description: Same idea as the provided button.v (shift register looking for
//   1...10), but the shift register only shifts once every DIV clock cycles.
//   At 100 MHz with DIV = 1_000_000 it samples every 10 ms, which is slower
//   than contact bounce, so one press = exactly one pulse.
//   With DIV = 1 it behaves exactly like button.v.
//   Output is still a single-clock-cycle pulse.
//////////////////////////////////////////////////////////////////////////////////

module button_debounce
    #(parameter N = 3,
      parameter DIV = 1_000_000)(
    input clk,
    input in,
    output out
    );

    localparam W = (DIV > 1) ? $clog2(DIV) : 1;

    reg [W - 1:0] count = 0;
    reg [N - 1:0] Q_reg = 0;
    wire tick = (count == DIV - 1);     // 1 for one clk cycle every DIV cycles

    always @(posedge clk)
    begin
        if (tick)
        begin
            count <= 0;
            Q_reg <= {in, Q_reg[N - 1:1]};   // right shift, same as button.v
        end
        else
            count <= count + 1;
    end

    // Pattern 1...10 found, gated with tick so it lasts exactly one clk cycle
    assign out = tick & (&Q_reg[N - 1:1]) & ~Q_reg[0];
endmodule
