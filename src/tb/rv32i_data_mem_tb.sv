`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 11:58:55 AM
// Design Name: 
// Module Name: rv32i_data_mem_tb
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

// Testbench for rv32i_data_mem
`timescale 1ns / 1ps

`include "rv32i_decoder_header.vh"

module rv32i_data_mem_tb;
    // Parameters
    localparam WIDTH = 32;
    localparam ADDR_WIDTH = 32;

    // Inputs
    logic clk = 0;
    logic rst;
    logic i_dm_we;
    logic [ADDR_WIDTH-1:0] i_dm_addr;
    logic [WIDTH-1:0] i_dm_data_in;
    logic [2:0] i_dm_func3;
    // Output
    logic [WIDTH-1:0] o_dm_data_out;

    // Instantiate the data memory
    rv32i_data_mem #(
        .WIDTH(WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .*
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin

        $display("==== rv32i_data_mem Testbench ====");

        rst = 1;
        #10;

        // Release reset
        rst = 0;
        i_dm_we = 0;
        i_dm_addr = 0;
        i_dm_data_in = 0;
        i_dm_func3 = 0;
        #10;

        // Store Word
        i_dm_addr = 32'd0;
        i_dm_data_in = 32'hDEADBEEF;
        i_dm_func3 = `FUNCT3_SW;
        i_dm_we = 1;
        #10;

        // Load Word
        i_dm_addr = 32'd0;
        i_dm_func3 = `FUNCT3_LW;
        #10;
        $display("LW: Addr=%0d Data=0x%08X", i_dm_addr, o_dm_data_out);

        // Store Halfword
        i_dm_addr = 32'd4;
        i_dm_data_in = 32'hDEADBEEF;
        i_dm_func3 = `FUNCT3_SH;
        i_dm_we = 1;
        #10;
        i_dm_we = 0;
        #10;

        // Load Halfword
        i_dm_addr = 32'd4;
        i_dm_func3 = `FUNCT3_LHU;
        #10;
        $display("LH: Addr=%0d Data=0x%08X", i_dm_addr, o_dm_data_out);

        // Store Byte
        i_dm_addr = 32'd8;
        i_dm_data_in = 32'hDEADBEEF;
        i_dm_func3 = `FUNCT3_SB;
        i_dm_we = 1;
        #10;
        i_dm_we = 0;

        // Load Byte
        i_dm_addr = 32'd8;
        i_dm_func3 = `FUNCT3_LBU;
        #10;
        $display("LB: Addr=%0d Data=0x%08X", i_dm_addr, o_dm_data_out);

        $display("==== Test Signal Values ====");

        // store negative value
        i_dm_addr = 5'd12;
        i_dm_data_in = -32'd5;
        i_dm_func3 = `FUNCT3_SW;
        i_dm_we = 1;
        #10;
        i_dm_we = 0;

        // Load signed Word
        i_dm_addr = 5'd12;
        i_dm_func3 = `FUNCT3_LW;
        #10;
        $display("LW (signed): Addr=%0d Data=0x%08X", i_dm_addr, o_dm_data_out);

        // Load signed Halfword
        i_dm_addr = 5'd12;
        i_dm_func3 = `FUNCT3_LH;
        #10;
        $display("LH (signed): Addr=%0d Data=0x%08X", i_dm_addr, o_dm_data_out);

        // Load signed Byte
        i_dm_addr = 5'd12;
        i_dm_func3 = `FUNCT3_LB;
        #10;
        $display("LB (signed): Addr=%0d Data=0x%08X", i_dm_addr, o_dm_data_out);

        $display("==== Testbench Complete ====");
        $finish;
    end
endmodule
