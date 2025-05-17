`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 01:17:25 AM
// Design Name: 
// Module Name: rv32i_alu_tb
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


module rv32i_alu_tb;

    localparam WIDTH = 32;  //default bit width
    localparam CLOCK = 10;  // clock period in ns

    // common signals
    logic clk;
    logic rst;

    // define inputs and outputs
    logic [WIDTH-1:0] o_result;
    logic [6:0] i_opcode;
    logic [2:0] i_funct3;
    logic [6:0] i_funct7;
    logic [WIDTH-1:0] i_rs1_data;
    logic [WIDTH-1:0] i_rs2_data;
    logic [WIDTH-1:0] i_imm;

    // instantiate the ALU
    rv32i_alu #(
        .WIDTH(WIDTH)
    ) uut (
        .o_result(o_result),
        .i_opcode(i_opcode),
        .i_funct3(i_funct3),
        .i_funct7(i_funct7),
        .i_rs1_data(i_rs1_data),
        .i_rs2_data(i_rs2_data),
        .i_imm(i_imm)
    );

    initial begin
        // add 5 + 3
        i_opcode = 7'b0110011; // R-type opcode
        i_funct3 = 3'b000;     // ADD funct3
        i_funct7 = 7'b0000000; // ADD funct7
        i_rs1_data = 32'd5; // rs1 = 5
        i_rs2_data = 32'd3; // rs2 = 3
        i_imm = 32'd0; // immediate value

        // Wait for a clock cycle
        #CLOCK;

        // add 100 + 200
        i_opcode = 7'b0110011; // R-type opcode
        i_funct3 = 3'b000;     // ADD funct3
        i_funct7 = 7'b0000000; // ADD funct7
        i_rs1_data = 32'd100; // rs1 = 100
        i_rs2_data = 32'd200; // rs2 = 200
        i_imm = 32'd0; // immediate value

        // Wait for a clock cycle
        #CLOCK;

        // addi 300 + (-100)
        i_opcode = 7'b0010011; // R-type opcode
        i_funct3 = 3'b000;     // ADD funct3
        i_funct7 = 7'b1111100; // ADD funct7
        i_rs1_data = 32'd300; // rs1 = 100
        i_rs2_data = 32'd0; // rs2 = 200
        i_imm = 32'b11111111111111111111111110011100; // immediate value -100

        // Wait for a clock cycle
        #CLOCK;

        $finish;
    end

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

endmodule
