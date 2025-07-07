`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 03:32:40 PM
// Design Name: 
// Module Name: p_ex_mem_stage
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

module p_ex_mem_stage (
    input logic clk,
    rst,
    en,

    // From ID/EX stage
    // CU outputs
    input logic i_reg_write_en,
    input logic i_mem_write_en,
    input logic i_mem_read_en,
    input logic i_alu_src_a,
    input logic i_do_branch,
    input logic i_do_jump,
    input logic [1:0] i_wb_sel,
    input logic [1:0] i_alu_src_b,
    // Pipeline Bypass
    input logic [31:0] i_pc_plus_4,
    input logic [31:0] i_pc,
    // Register outputs
    input logic [31:0] i_rs1_data,
    input logic [31:0] i_rs2_data,
    // Decoder outputs
    input logic [31:0] i_imm,
    input logic [4:0] i_rd_addr,
    input logic [2:0] i_funct3,
    input logic [6:0] i_opcode,
    input logic [`ALU_OP_WIDTH-1:0] i_alu_op,
    input logic [`ALU_OP_WIDTH-1:0] i_branch_op,

    // Outputs to MEM/WB stage
    output logic o_reg_write_en,
    output logic o_dm_write_en,
    output logic o_dm_read_en,
    output logic [1:0] o_wb_sel,
    output logic [31:0] o_pc_plus_4,
    output logic [31:0] o_alu_result,
    output logic [31:0] o_rs2_data,
    output logic [4:0] o_rd_addr,
    output logic [2:0] o_funct3,

    // Non-pipeline outputs
    output logic ext_pc_sel,
    output logic [31:0] ext_jump_target,

    // Debug
    input logic [31:0] i_debug_inst,
    output logic [31:0] o_debug_inst
);

    localparam WIDTH = 32;

    // DEBUG
    logic [WIDTH-1:0] DEBUG_INST;
    assign DEBUG_INST = i_debug_inst;

    // Bypass from previous stage
    p_reg #(
        .WIDTH(109)
    ) p_bypass_reg (
        .d({
            i_reg_write_en,
            i_wb_sel,
            i_mem_read_en,
            i_mem_write_en,
            i_funct3,
            i_pc_plus_4,
            i_rs2_data,
            i_rd_addr,
            i_debug_inst
        }),
        .q({
            o_reg_write_en,
            o_wb_sel,
            o_dm_read_en,
            o_dm_write_en,
            o_funct3,
            o_pc_plus_4,
            o_rs2_data,
            o_rd_addr,
            o_debug_inst
        }),
        .*
    );

    // Internal signals
    logic [WIDTH-1:0] w_alu_result;
    assign ext_jump_target = w_alu_result; // ALU result used for branch/jump offsets
    assign o_alu_result = w_alu_result;

        // ALU
    rv32i_alu #(
        .WIDTH(WIDTH)
    ) alu (
        .o_result(w_alu_result),
        .i_alu_op(i_alu_op),
        .i_alu_src_a(i_alu_src_a),
        .i_rs1_data(i_rs1_data),
        .i_pc(i_pc),
        .i_alu_src_b(i_alu_src_b),
        .i_rs2_data(i_rs2_data),
        .i_imm(i_imm)
    );

    // Branch unit
    rv32i_branch_unit #(
        .WIDTH(WIDTH)
    ) branch_unit (
        .o_pc_sel(ext_pc_sel),
        .i_branch_op(i_branch_op),
        .i_rs1_data(i_rs1_data),
        .i_rs2_data(i_rs2_data),
        .i_do_branch(i_do_branch),
        .i_do_jump(i_do_jump)
    );

endmodule
