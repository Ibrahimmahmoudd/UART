module uart(
    input wire clock, reset, start, rx_in, input wire [7:0] send_data,
    output wire busy, tx_out, rx_done, rx_fail, output wire [7:0] rx_data);
    wire baud_signal;
    wire sample_signal;

    baud_gen bg(
        .clk(clock),
        .reset(reset),
        .baud_pulse(baud_signal),
        .sample_pulse(sample_signal)
    );

    tx_unit tx(
        .clock(clock),
        .rst(reset),
        .tick(baud_signal),
        .data_in(send_data),
        .go(start),
        .serial_out(tx_out),
        .is_busy(busy)
    );

    rx_unit rx(
        .clk(clock),
        .reset(reset),
        .sample_tick(sample_signal),
        .rx_in(rx_in),
        .data_out(rx_data),
        .ready(rx_done),
        .err(rx_fail)
    );

endmodule