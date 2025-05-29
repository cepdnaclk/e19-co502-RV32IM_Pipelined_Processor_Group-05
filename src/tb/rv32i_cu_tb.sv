`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2025 07:11:28 PM
// Design Name: 
// Module Name: rv32i_cu_tb
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

module rv32i_cu_tb;
    localparam WIDTH = 32;  //default bit width
    localparam CLOCK = 10;  // clock period in ns

    // common ports declaration
    logic clk;
    logic rst;

    // ports for the instruction memory
    logic [WIDTH-1:0] i_addr;
    logic [WIDTH-1:0] o_inst;
    
    // ports for the decoder
    logic [WIDTH-1:0] i_inst;
    logic [4:0] o_rs1_addr;
    logic [4:0] o_rs2_addr;
    logic [4:0] o_rd_addr;
    logic [31:0] o_imm;
    logic [2:0] o_funct3;
    logic [6:0] o_funct7;
    logic [6:0] o_opcode;
    logic [`ALU_OP_WIDTH-1:0] o_alu_op;
    logic [2:0] o_branch_op;

    // ports for the control unit
    logic [6:0] i_opcode;
    logic o_reg_write_en;
    logic o_mem_write_en;
    logic o_mem_read_en;
    logic o_mem_to_reg;
    logic o_alu_src_a;
    logic [1:0] o_alu_src_b;


    // Instantiate the instruction memory
    rv32i_inst_mem #(
        .INST_WIDTH(WIDTH)
    ) uut_inst_mem (
        .*
    );

    assign i_inst = o_inst;

    // Instantiate the decoder
    rv32i_decoder uut_decoder (
        .*
    );

    // connect the opcode to the control unit
    assign i_opcode = o_opcode;

    // Instantiate the control unit
    rv32i_cu uut_cu (
        .*
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

    // Iterate through addresses
    initial begin
        rst = 1'b1;
        #(CLOCK);
        rst = 1'b0;

        for (int i = 0; i < 100; i = i + 4) begin
            i_addr = i;
            #(CLOCK);
            $display("Address: %0d, Instruction: %h", i_addr, o_inst);
        end

        $finish;
    end

    initial begin
        $dumpfile("rv32i_cu_tb.vcd");
        $dumpvars(0, uut_decoder);
        $dumpvars(0, uut_inst_mem);
        $dumpvars(0, uut_cu);
    end

endmodule
