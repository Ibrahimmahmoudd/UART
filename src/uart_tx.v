module tx_unit
    ( input wire clock, rst, tick, go ,input wire [7:0] data_in,        
    output reg serial_out, is_busy);
    reg [3:0] state;
    reg [7:0] shift;
    reg [3:0] bit_pos;

    always @(posedge clock or posedge rst) begin
        if (rst) begin
            state <= 0;
            serial_out <= 1;
            is_busy <= 0;
            shift <= 0;
            bit_pos <= 0;
        end else begin
            case (state)
                0: if (go) begin
                    shift <= data_in;
                    state <= 1;
                    is_busy <= 1;
                end
                1: if (tick) begin
                    serial_out <= 0;
                    state <= 2;
                    bit_pos <= 0;
                end
                2: if (tick) begin
                    serial_out <= shift[0];
                    shift <= shift >> 1;
                    bit_pos <= bit_pos + 1;
                    if (bit_pos == 7) state <= 3;
                end
                3: if (tick) begin
                    serial_out <= 1;
                    state <= 0;
                end
            endcase
        end
    end

endmodule