`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 03:32:40 PM
// Design Name: 
// Module Name: p_id_ex_stage
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

module p_id_ex_stage (
    input logic clk,
    rst,
    en,
    // From IF/ID stage
    input logic [31:0] i_inst,
    i_pc_plus_4,
    i_pc,
    // Non-pipeline inputs
    input logic ext_reg_write_en,
    input logic [31:0] ext_rd_data,
    input logic [4:0] ext_rd_addr,
    // CU outputs
    output logic o_reg_write_en,
    o_mem_write_en,
    o_mem_read_en,
    o_alu_src_a,
    o_do_branch,
    o_do_jump,
    output logic [1:0] o_wb_sel,
    output logic [1:0] o_alu_src_b,
    // Pipeline Bypass
    output logic [31:0] o_pc_plus_4,
    o_pc,
    // Register outputs
    output logic [31:0] o_rs1_data,
    o_rs2_data,
    // Decoder outputs
    output logic [31:0] o_imm,
    output logic [4:0] o_rd_addr,
    output logic [2:0] o_funct3,
    output logic [6:0] o_opcode,
    output logic [`ALU_OP_WIDTH-1:0] o_alu_op,
    output logic [`ALU_OP_WIDTH-1:0] o_branch_op
);

    localparam WIDTH = 32;

    // Pipeline registers
    p_reg #(
        .WIDTH(WIDTH)
    ) p_pc_plus_4_reg (
        .d(i_pc_plus_4),
        .q(o_pc_plus_4),
        .*
    );

    p_reg #(
        .WIDTH(WIDTH)
    ) p_pc_reg (
        .d(i_pc),
        .q(o_pc),
        .*
    );

    // Internal signals
    logic [31:0] w_imm, w_rs1_data, w_rs2_data;

    p_reg #(
        .WIDTH(WIDTH)
    ) p_rs1_data_reg (
        .d(w_rs1_data),
        .q(o_rs1_data),
        .*
    );
    p_reg #(
        .WIDTH(WIDTH)
    ) p_rs2_data_reg (
        .d(w_rs2_data),
        .q(o_rs2_data),
        .*
    );

    p_reg #(
        .WIDTH(32)
    ) p_imm_reg (
        .d(w_imm),
        .q(o_imm),
        .*
    );

    // Internal signal
    logic [4:0] w_rd_addr;

    p_reg #(
        .WIDTH(5)
    ) p_rd_addr_reg (
        .d(w_rd_addr),
        .q(o_rd_addr),
        .*
    );

    // Internal signals
    logic [2:0] w_funct3;
    logic [`ALU_OP_WIDTH-1:0] w_alu_op, w_branch_op;

    p_reg #(
        .WIDTH(3)
    ) p_funct3_reg (
        .d(w_funct3),
        .q(o_funct3),
        .*
    );
    p_reg #(
        .WIDTH(`ALU_OP_WIDTH)
    ) p_alu_op_reg (
        .d(w_alu_op),
        .q(o_alu_op),
        .*
    );
    p_reg #(
        .WIDTH(`ALU_OP_WIDTH)
    ) p_branch_op_reg (
        .d(w_branch_op),
        .q(o_branch_op),
        .*
    );

    // Internal signals
    logic [6:0] w_opcode;
    logic [4:0] w_rs1_addr, w_rs2_addr;

    // bypass signals
    logic [31:0] w_pc_plus_4, w_pc;

    rv32i_decoder decoder (
        .i_inst(i_inst),
        .o_rs1_addr(w_rs1_addr),
        .o_rs2_addr(w_rs2_addr),
        .o_rd_addr(w_rd_addr),
        .o_imm(w_imm),
        .o_opcode(w_opcode),
        .o_funct3(w_funct3),
        .o_alu_op(w_alu_op),
        .o_branch_op(w_branch_op)
    );

    rv32i_cu control_unit (
        .i_opcode(w_opcode),
        .o_reg_write_en(reg_write_en),
        .o_mem_write_en(mem_write_en),
        .o_mem_read_en(mem_read_en),
        .o_alu_src_a(alu_src_a),
        .o_alu_src_b(alu_src_b),
        .o_do_branch(do_branch),
        .o_do_jump(do_jump),
        .o_wb_sel(wb_sel)
    );

    rv32i_basereg #(
        .WIDTH(WIDTH)
    ) reg_file (
        .clk(clk),
        .rst(rst),
        .i_we(ext_reg_write_en),
        .i_rd_addr(ext_rd_addr),
        .i_rd_data(ext_rd_data),
        .i_rs1_addr(w_rs1_addr),
        .i_rs2_addr(w_rs2_addr),
        .o_rs1_data(w_rs1_data),
        .o_rs2_data(w_rs1_data)
    );
endmodule
