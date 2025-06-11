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

`include "rv32i_decoder_header.vh"

module rv32i_alu_tb;

    localparam WIDTH = 32;  //default bit width
    localparam CLOCK = 10;  // clock period in ns

    // common signals
    logic clk;
    logic rst;

    // define inputs and outputs
    logic [WIDTH-1:0] o_result;
    logic o_take_branch;
    logic [`ALU_OP_WIDTH-1:0] i_alu_op;
    logic i_alu_src_a;
    logic [WIDTH-1:0] i_rs1_data;
    logic [WIDTH-1:0] i_pc;
    logic [1:0] i_alu_src_b;
    logic [WIDTH-1:0] i_rs2_data;
    logic [WIDTH-1:0] i_imm;


    // instantiate the ALU
    rv32i_alu #(.WIDTH(WIDTH)) uut (.*);

    initial begin
        // Wait for a clock cycle
        #CLOCK;

        rst = 1'b0; // reset the ALU

        // add x1 and x2 and store in x3
        i_alu_op = `ALU_ADD;
        i_rs1_data = 32'h00000001; // x1 = 1
        i_rs2_data = 32'h00000002; // x2 = 2
        i_alu_src_a = `ALU_SRC_A_REG; // use rs1
        i_alu_src_b = `ALU_SRC_B_REG; // use rs2
        i_pc = 32'h00000000; // PC value
        i_imm = 32'h00000000; // immediate value
        #CLOCK; // wait for ALU operation to complete

        // addi x1 and immediate value 5 and store in x4
        i_alu_op = `ALU_ADD;
        i_rs1_data = 32'h00000001; // x1 = 1
        i_rs2_data = 32'h00000000; // not used in this case
        i_alu_src_a = `ALU_SRC_A_REG; // use rs1
        i_alu_src_b = `ALU_SRC_B_IMM; // use immediate value
        i_imm = 32'h00000005; // immediate value 5
        #CLOCK; // wait for ALU operation to complete

        // branch if x1 is equal to x2
        i_rs1_data = 32'h00000001; // x1 = 1
        i_rs2_data = 32'h00000002; // x2 = 2
        i_alu_src_a = `ALU_SRC_A_REG; // use rs1
        i_alu_src_b = `ALU_SRC_B_REG; // use rs2
        i_pc = 32'h00000000; // PC value
        i_alu_op = `ALU_EQ; // set branch operation to equality
        #CLOCK; // wait for ALU operation to complete

        // branch if x1 is not equal to x2
        i_rs1_data = 32'h00000001; // x1 = 1
        i_rs2_data = 32'h00000002; // x2 = 2
        i_alu_src_a = `ALU_SRC_A_REG; // use rs1
        i_alu_src_b = `ALU_SRC_B_REG; // use rs2
        i_pc = 32'h00000000; // PC value
        i_alu_op = `ALU_NEQ; // set branch operation to not equal
        #CLOCK; // wait for ALU operation to complete


        $finish;
    end

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

endmodule
