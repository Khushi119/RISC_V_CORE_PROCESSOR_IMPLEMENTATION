// TESTBENCH MODULE CODE:
`timescale 1ns / 1ps

module testbench;
    reg clk, rst;

    // Instantiate the full pipeline
    pipeline_top uut (.clk(clk), .rst(rst));

    // Clock generator
    always #10 clk = ~clk;

    // Reset and simulation control
    initial begin
        clk = 0;
        rst = 1;
        #15;
        rst = 0;
        #1500;
        $finish;
    end
endmodule
