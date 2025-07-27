module rx_unit(
    input wire clk,reset, sample_tick,rx_in,
    output reg [7:0] data_out, output reg ready, err);
    reg [3:0] rx_phase;
    reg [3:0] samples;
    reg [3:0] bits;
    reg [7:0] buffer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_phase <= 0;
            data_out <= 0;
            ready <= 0;
            err <= 0;
            samples <= 0;
            bits <= 0;
            buffer <= 0;
        end else if (sample_tick) begin
            case (rx_phase)
                0: if (rx_in == 0) begin
                    rx_phase <= 1;
                    samples <= 0;
                end
                1: begin
                    samples <= samples + 1;
                    if (samples == 7) begin
                        if (rx_in == 0) begin
                            rx_phase <= 2;
                            samples <= 0;
                            bits <= 0;
                        end else begin
                            rx_phase <= 0;
                        end
                    end
                end
                2: begin
                    samples <= samples + 1;
                    if (samples == 15) begin
                        buffer <= {rx_in, buffer[7:1]};
                        bits <= bits + 1;
                        samples <= 0;
                        if (bits == 7) rx_phase <= 3;
                    end
                end
                3: begin
                    samples <= samples + 1;
                    if (samples == 15) begin
                        if (rx_in == 1) begin
                            data_out <= buffer;
                            ready <= 1;
                            rx_phase <= 0;
                        end else begin
                            err <= 1;
                            rx_phase <= 0;
                        end
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (ready) ready <= 0;
        if (err) err <= 0;
    end

endmodule