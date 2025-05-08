`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/07/2025 10:21:49 AM
// Design Name:
// Module Name: rv32i_pc_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module rv32i_pc_tb;

    localparam int N = 8;  // counter bit width
    localparam int T = 10;  // clock period in ns

    logic clk;
    logic rst;
    logic en;
    logic [N-1:0] count;

    rv32i_pc #(
        .N(N)
    ) uut (
        .*
    );

    // Clock
    always begin
        clk = 1'b1;
        #(T / 2);
        clk = 1'b0;
        #(T / 2);
    end

    // Async reset (over the first half cycle)
    initial begin
        rst = 1'b1;
        #(T / 2);
        rst = 1'b0;
    end

    // Enable on the third cycle and count for 10 cycles
    initial begin
        en = 0;
        repeat (3) @(negedge clk);
        en = 1;
        #(10 * T) $finish;
    end

    initial begin
        $timeformat(-9, 1, " ns", 8);
        $monitor("time=%t clk=%b rst=%b en=%b count=%2d", $time, clk, rst, en, count);
        $dumpfile("rv32i_pc_tb.vcd");
        $dumpvars(0, uut);
    end

endmodule
