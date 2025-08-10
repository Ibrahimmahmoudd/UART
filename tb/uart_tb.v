module uart_test;

    reg clk;
    reg rst;
    reg [7:0] tx_input;
    reg tx_trigger;
    wire tx_status;
    wire tx_wire;
    wire rx_wire;
    wire [7:0] rx_output;
    wire rx_complete;
    wire rx_error;

    assign rx_wire = tx_wire;

    uart device(
        .clock(clk),
        .reset(rst),
        .send_data(tx_input),
        .start(tx_trigger),
        .busy(tx_status),
        .tx_out(tx_wire),
        .rx_in(rx_wire),
        .rx_data(rx_output),
        .rx_done(rx_complete),
        .rx_fail(rx_error)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst = 1;
        tx_trigger = 0;
        tx_input = 8'h00;
        #100;
        rst = 0;
        #100;

        tx_input = 8'hAA;
        tx_trigger = 1;
        #20;
        tx_trigger = 0;
        wait(tx_status == 0);
        wait(rx_complete);
        if (rx_output == 8'hAA && !rx_error) $display("AA worked fine");
        else $display("AA messed up");

        #100;

        tx_input = 8'h55;
        tx_trigger = 1;
        #20;
        tx_trigger = 0;
        wait(tx_status == 0);
        wait(rx_complete);
        if (rx_output == 8'h55 && !rx_error) $display("55 worked fine");
        else $display("55 messed up");

        #100;
        $finish;
    end

endmodule