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

`include "rv32i_decoder_header.vh"

module rv32i_core (
    input logic clk,
    rst
);

    localparam WIDTH = 32;

    // We define alu result here to be used for the program counter and other operations
    logic [WIDTH-1:0] alu_result;
    logic pc_sel;
    logic [WIDTH-1:0] pc, pc_plus_4;

    // Program Counter
    rv32i_pc #(
        .WIDTH(WIDTH)
    ) pc_unit (
        .clk(clk),
        .rst(rst),
        .i_jump_target(alu_result),  // ALU result used for branch/jump offsets
        .o_pc(pc),
        .o_pc_plus_4(pc_plus_4),
        .i_pc_sel(pc_sel)  // Branch decision from  branch unit
    );

    // instruction memory
    logic [WIDTH-1:0] inst;

    rv32i_inst_mem #(
        .INST_WIDTH(WIDTH)
    ) inst_mem (
        .i_addr(pc),
        .o_inst(inst)
    );

    // instruction decoder
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [4:0] rd_addr;
    logic [31:0] imm;
    logic [2:0] funct3;
    logic [6:0] opcode;
    logic [`ALU_OP_WIDTH-1:0] alu_op, branch_op;

    rv32i_decoder decoder (
        .i_inst(inst),
        .o_rs1_addr(rs1_addr),
        .o_rs2_addr(rs2_addr),
        .o_rd_addr(rd_addr),
        .o_imm(imm),
        .o_funct3(funct3),
        .o_opcode(opcode),
        .o_alu_op(alu_op),
        .o_branch_op(branch_op)
    );

    // control unit
    logic reg_write_en;
    logic mem_write_en;
    logic mem_read_en;
    logic mem_to_reg;
    logic alu_src_a;
    logic do_branch, do_jump;
    logic [1:0] alu_src_b, wb_sel;

    rv32i_cu control_unit (
        .i_opcode(opcode),
        .o_reg_write_en(reg_write_en),
        .o_mem_write_en(mem_write_en),
        .o_mem_read_en(mem_read_en),
        .o_alu_src_a(alu_src_a),
        .o_alu_src_b(alu_src_b),
        .o_do_branch(do_branch),
        .o_do_jump(do_jump),
        .o_wb_sel(wb_sel)
    );

    // register file
    logic [WIDTH-1:0] rs1_data;
    logic [WIDTH-1:0] rs2_data;
    logic [WIDTH-1:0] rd_data;

    rv32i_basereg #(
        .WIDTH(WIDTH)
    ) reg_file (
        .clk(clk),
        .rst(rst),
        .i_we(reg_write_en),
        .i_rs1_addr(rs1_addr),
        .i_rs2_addr(rs2_addr),
        .i_rd_addr(rd_addr),
        .i_rd_data(rd_data),
        .o_rs1_data(rs1_data),
        .o_rs2_data(rs2_data)
    );

    // ALU
    rv32i_alu #(
        .WIDTH(WIDTH)
    ) alu (
        .o_result(alu_result),
        .i_alu_op(alu_op),
        .i_alu_src_a(alu_src_a),
        .i_rs1_data(rs1_data),
        .i_pc(pc),
        .i_alu_src_b(alu_src_b),
        .i_rs2_data(rs2_data),
        .i_imm(imm)
    );

    // Branch unit
    rv32i_branch_unit #(
        .WIDTH(WIDTH)
    ) branch_unit (
        .o_pc_sel(pc_sel),
        .i_branch_op(branch_op),
        .i_rs1_data(rs1_data),
        .i_rs2_data(rs2_data),
        .i_do_branch(do_branch),
        .i_do_jump(do_jump)
    );

    // Data memory
    logic [WIDTH-1:0] dm_data_out;

    rv32i_data_mem #(
        .WIDTH(WIDTH)
    ) data_mem (
        .clk(clk),
        .rst(rst),
        .i_dm_we(mem_write_en),
        .i_dm_addr(alu_result),
        .i_dm_data_in(rs2_data),
        .i_dm_func3(funct3),
        .o_dm_data_out(dm_data_out)
    );

    // assign rd_data = alu_result; // for now, just write back ALU result
    rv32i_write_back_mux #(
        .WIDTH(WIDTH)
    ) wb_mux (
        .o_wb_data(rd_data),
        .i_alu_result(alu_result),
        .i_mem_data(dm_data_out),
        .i_pc_plus_4(pc_plus_4), // PC + 4 for JALR and JAL
        .i_wb_sel(wb_sel)
    );

endmodule
