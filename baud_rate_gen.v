module baud_gen(
    input wire clk, reset,
    output reg baud_pulse, sample_pulse
);

    reg [15:0] baud_count;
    reg [15:0] sample_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            baud_count <= 0;
            sample_count <= 0;
            baud_pulse <= 0;
            sample_pulse <= 0;
        end else begin
            if (baud_count == 5207) begin
                baud_count <= 0;
                baud_pulse <= 1;
            end else begin
                baud_count <= baud_count + 1;
                baud_pulse <= 0;
            end
            if (sample_count == 324) begin
                sample_count <= 0;
                sample_pulse <= 1;
            end else begin
                sample_count <= sample_count + 1;
                sample_pulse <= 0;
            end
        end
    end

endmodule