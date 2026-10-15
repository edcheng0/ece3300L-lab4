# ece3300L-lab4 : Registers

## Files

### Design
- [`src/simple_register_load.v`](verilog/design/simple_register_load.v) – starter: register with load enable
- [`src/decoder_generic.v`](verilog/design/decoder_generic.v) – starter: parameterized decoder
- [`src/hex2sseg.v`](verilog/design/hex2sseg.v) – starter: hex to seven-segment converter
- [`src/button.v`](verilog/design/button.v) – starter: synchronizer, debouncer, and edge detector
- [`src/adder_subtractor.v`](verilog/design/adder_subtractor.v) – starter: n-bit adder/subtractor
- [`src/rca_nbit.v`](verilog/design/rca_nbit.v) – starter: n-bit ripple-carry adder
- [`src/full_adder.v`](verilog/design/full_adder.v) – starter: 1-bit full adder
- [`src/half_adder.v`](verilog/design/half_adder.v) – starter: 1-bit half adder
- [`src/reg_file.v`](verilog/design/reg_file.v) – Part 1 generic register file
- [`src/reg_file_application.v`](verilog/design/reg_file_application.v) – Part 1 top module
- [`src/register_load_reset.v`](verilog/design/register_load_reset.v) – Part 2 register with load and active-low reset
- [`src/accumulator.v`](verilog/design/accumulator.v) – Part 2 accumulator
- [`src/button_debounce.v`](verilog/design/button_debounce.v) – Part 2 slow-sampled button debouncer
- [`src/accumulator_application.v`](verilog/design/accumulator_application.v) – Part 2 top module

### Sim
- [`tb/button_tb.v`](verilog/sim/button_tb.v) – starter: button testbench
- [`tb/reg_file_tb.v`](verilog/sim/reg_file_tb.v) – Part 1 testbench
- [`tb/accumulator_tb.v`](verilog/sim/accumulator_tb.v) – Part 2 testbench

### Constraints
- [`constraints/reg_file_application.xdc`](verilog/constraints/reg_file_application.xdc) – Part 1 board constraints, Nexys A7-100T
- [`constraints/accumulator_application.xdc`](verilog/constraints/accumulator_application.xdc) – Part 2 board constraints, Nexys A7-100T

## Part 1: Register File
Simulation waveform:

![Part 1 waveform](screenshots/part1_waveform.png)

Schematic:

![Part 1 schematic](screenshots/part1_schematic.png)

Flip-flops used on the board: 529

Demo video: [Part 1 FPGA demo](videos/part1_demo.mp4)

## Part 2: Accumulator
Simulation waveform:

![Part 2 waveform](screenshots/part2_waveform.png)

Block diagram:

![Part 2 block diagram](screenshots/part2_blockdiagram.png)

Demo video: [Part 2 FPGA demo](videos/part2_demo.mp4)
