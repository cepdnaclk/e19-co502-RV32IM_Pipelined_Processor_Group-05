`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2025 03:14:33 PM
// Design Name: 
// Module Name: rv32i_basereg_tb
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


module rv32i_basereg_tb;

    localparam int WIDTH = 32;  //default bit width
    localparam int CLOCK = 10;  // clock period in ns

    logic clk;
    logic rst;
    logic [4:0] i_rs1_addr = 5'd0;
    logic [4:0] i_rs2_addr = 5'd0;
    logic [4:0] i_rd_addr = 5'd0;
    logic [WIDTH-1:0] i_rd_data;
    logic i_we;
    logic [WIDTH-1:0] o_rs1_data;
    logic [WIDTH-1:0] o_rs2_data;

    rv32i_basereg #(.WIDTH(WIDTH)) uut (.*);

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

    // Test sequence
    initial begin
        #(CLOCK / 2);
        rst = 1'b1;
        #(CLOCK);
        rst = 1'b0;

        // Test write and read operations
        i_we = 1'b1;
        i_rd_addr = 5'd1;  // Write to register 1
        i_rd_data = 32'hA5A5A5A5;  // Data to write
        #(CLOCK);

        i_we = 1'b0;  // Disable write
        i_rs1_addr = 5'd1;  // Read from register 1
        #(CLOCK);

        if (o_rs1_data !== 32'hA5A5A5A5) begin
            $error("Test failed! Expected: %h, Got: %h", 32'hA5A5A5A5, o_rs1_data);
            $finish;
        end else begin
            $display("Test passed! Read data: %h", o_rs1_data);
        end

        $finish;
    end

    initial begin
        $dumpfile("rv32i_basereg_tb.vcd");
        $dumpvars(0, uut);
    end

endmodule
