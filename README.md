# UART Verilog Implementation

## Overview
This project is a modular UART (Universal Asynchronous Receiver/Transmitter) implementation in Verilog, designed for serial communication. It supports 8-bit data transmission and reception at a 9600 baud rate using a 50 MHz system clock. The design includes a baud rate generator, transmitter, receiver, and a top-level module, along with a testbench for verification.

## Project Structure
The repository contains the following Verilog files:
- **`baud_gen.v`**: Generates baud rate and 16x oversampling pulses for the transmitter and receiver.
- **`tx_unit.v`**: Serializes 8-bit parallel data into a serial stream with start and stop bits.
- **`rx_unit.v`**: Deserializes incoming serial data, performs 16x oversampling, and detects errors.
- **`uart.v`**: Integrates the baud rate generator, transmitter, and receiver into a complete UART system.
- **`uart_test.v`**: Testbench to verify UART functionality by sending and receiving test data.

## Features
- 8-bit data, 1 start bit, 1 stop bit, no parity.
- Configurable baud rate (default: 9600 baud) with a 50 MHz clock.
- 16x oversampling in the receiver for reliable data sampling.
- Error detection for stop bit errors in the receiver.
- Loopback testing in the testbench to verify transmit and receive operations.

## Usage
1. **Simulation**:
   - Use a Verilog simulator (e.g., ModelSim, Vivado, or Icarus Verilog).
   - Compile all Verilog files (`baud_gen.v`, `tx_unit.v`, `rx_unit.v`, `uart.v`, `uart_test.v`).
   - Run the simulation with `uart_test.v` as the top module to verify functionality.
   - The testbench sends test data (`0xAA`, `0x55`) and checks for correct reception.

2. **Customization**:
   - Modify `baud_gen.v` to adjust the baud rate or clock frequency by updating the divisors (`5208` for baud rate, `324` for 16x sampling).
   - Example: For a 100 MHz clock and 9600 baud, set `BAUD_COUNT = 10417` and `SAMPLE_COUNT = 651`.

3. **Synthesis**:
   - The design is synthesizable for FPGA implementation (e.g., on Xilinx or Altera boards).
   - Ensure the target FPGA clock matches the 50 MHz assumption or adjust divisors accordingly.

## Baud Rate Configuration
- **Baud Rate**: 9600 baud (default).
- **Clock**: 50 MHz.
- **Baud Divisor**: \( \frac{50,000,000}{9600} \approx 5208 \).
- **Sample Divisor**: \( \frac{50,000,000}{16 \times 9600} \approx 325 \).

## Testbench
The testbench (`uart_test.v`) performs loopback testing by connecting the transmitter output to the receiver input. It sends two test bytes (`0xAA`, `0x55`) and checks if they are received correctly without errors. Simulation results are displayed via `$display` statements.
