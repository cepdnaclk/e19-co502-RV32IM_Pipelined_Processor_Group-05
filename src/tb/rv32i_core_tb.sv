`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 05:44:59 PM
// Design Name: 
// Module Name: rv32i_core_tb
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


module rv32i_core_tb;

    // Parameters
    localparam WIDTH = 32;  //default bit width
    localparam CLOCK = 10;  // clock period in ns

    // Inputs
    logic clk;
    logic rst;

    // Instantiate the Unit Under Test (UUT)
    rv32i_core uut (
        .clk(clk),
        .rst(rst)
    );

    // Iterate through addresses
    initial begin
        rst = 1'b1;
        #(CLOCK);
        rst = 1'b0;

        // Wait for a few clock cycles
        repeat (300) begin
            #(CLOCK);
        end

        $finish;
    end

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

    // Monitor signals
    initial begin
        $dumpfile("rv32i_core_tb.vcd");
        $dumpvars(0, rv32i_core_tb);
    end
    
endmodule
