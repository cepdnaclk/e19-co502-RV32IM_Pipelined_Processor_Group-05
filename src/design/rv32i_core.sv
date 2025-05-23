`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 05:40:13 PM
// Design Name: 
// Module Name: rv32i_core
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


module rv32i_core(
        input logic clk, rst
    );

    localparam WIDTH = 32;

    // program counter
    logic [WIDTH-1:0] pc;
    logic [WIDTH-1:0] next_pc;

    // TODO: implement branch/jump logic
    assign next_pc = pc + 4; // for now, just increment by 4

    rv32i_pc #(
        .WIDTH(WIDTH)
    ) pc_unit (
        .clk(clk),
        .rst(rst),
        .i_pc(next_pc),
        .o_pc(pc)
    );

    // instruction memory
    logic [WIDTH-1:0] inst;

    rv32i_inst_mem #(
        .INST_WIDTH(WIDTH)
    ) inst_mem (
        .clk(clk),
        .rst(rst),
        .i_addr(pc),
        .o_inst(inst)
    );

    // instruction decoder
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [4:0] rd_addr;
    logic [31:0] imm;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [6:0] opcode;

    rv32i_decoder decoder (
        .i_inst(inst),
        .o_rs1_addr(rs1_addr),
        .o_rs2_addr(rs2_addr),
        .o_rd_addr(rd_addr),
        .o_imm(imm),
        .o_funct3(funct3),
        .o_funct7(funct7),
        .o_opcode(opcode)
    );

    // register file
    logic [WIDTH-1:0] rs1_data;
    logic [WIDTH-1:0] rs2_data;
    logic [WIDTH-1:0] rd_data;
    // TODO: implement write back logic
    logic we = 1'b1; // write enable signal

    rv32i_basereg #(
        .WIDTH(WIDTH)
    ) reg_file (
        .clk(clk),
        .rst(rst),
        .i_we(we),
        .i_rs1_addr(rs1_addr),
        .i_rs2_addr(rs2_addr),
        .i_rd_addr(rd_addr),
        .i_rd_data(rd_data),
        .o_rs1_data(rs1_data),
        .o_rs2_data(rs2_data)
    );

    // ALU
    logic [WIDTH-1:0] alu_result;

    rv32i_alu #(
        .WIDTH(WIDTH)
    ) alu (
        .o_result(alu_result),
        .i_opcode(opcode),
        .i_funct3(funct3),
        .i_funct7(funct7),
        .i_rs1_data(rs1_data),
        .i_rs2_data(rs2_data),
        .i_imm(imm)
    );

    // assign rd_data = alu_result; // for now, just write back ALU result
    rv32i_write_back_mux #(
        .WIDTH(WIDTH)
    ) wb_mux (
        .o_wb_data(rd_data),
        .i_alu_result(alu_result),
        .i_mem_data(32'b0), // TODO: connect to memory data
        .i_opcode(opcode)
    );

endmodule
