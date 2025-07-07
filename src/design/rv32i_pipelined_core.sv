`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 11:01:05 PM
// Design Name: 
// Module Name: rv32i_pipelined_core
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

module rv32i_pipelined_core (
    input logic clk,
    rst
);

    localparam WIDTH = 32;

    // IF/ID Stage outputs
    logic [WIDTH-1:0] if_id_inst, if_id_pc_plus_4, if_id_pc;

    // External PC selection and jump target
    logic [WIDTH-1:0] ext_jump_target;
    logic ext_pc_sel;

    p_if_id_stage if_id_stage (
        .clk(clk),
        .rst(rst),
        .en(1'b1),  // Enable signal
        .o_inst(if_id_inst),
        .o_pc_plus_4(if_id_pc_plus_4),
        .o_pc(if_id_pc),
        .ext_pc_sel(ext_pc_sel),  // No external PC selection in this example
        .ext_jump_target(ext_jump_target)  // No external jump target
    );

    // ID/EX Stage outputs
    logic
        id_ex_reg_write_en,
        id_ex_mem_write_en,
        id_ex_mem_read_en,
        id_ex_alu_src_a,
        id_ex_do_branch,
        id_ex_do_jump;
    logic [1:0] id_ex_wb_sel;
    logic [1:0] id_ex_alu_src_b;
    logic [31:0] id_ex_pc_plus_4, id_ex_pc;
    logic [31:0] id_ex_rs1_data, id_ex_rs2_data;
    logic [31:0] id_ex_imm;
    logic [4:0] id_ex_rd_addr;
    logic [2:0] id_ex_funct3;
    logic [6:0] id_ex_opcode;
    logic [`ALU_OP_WIDTH-1:0] id_ex_alu_op;
    logic [`ALU_OP_WIDTH-1:0] id_ex_branch_op;

    // External inputs
    logic ext_reg_write_en;
    logic [4:0] ext_rd_addr;
    logic [31:0] ext_rd_data;

    // DEBUG
    logic [WIDTH-1:0] id_ex_mem_inst;

    p_id_ex_stage id_ex_stage (
        .clk(clk),
        .rst(rst),
        .en(1'b1),  // Enable signal
        .i_inst(if_id_inst),
        .i_pc_plus_4(if_id_pc_plus_4),
        .i_pc(if_id_pc),
        .ext_reg_write_en(ext_reg_write_en),  // No external register write enable in this example
        .ext_rd_data(ext_rd_data),  // No external read data
        .ext_rd_addr(ext_rd_addr),  // No external read address
        .o_reg_write_en(id_ex_reg_write_en),
        .o_mem_write_en(id_ex_mem_write_en),
        .o_mem_read_en(id_ex_mem_read_en),
        .o_alu_src_a(id_ex_alu_src_a),
        .o_do_branch(id_ex_do_branch),
        .o_do_jump(id_ex_do_jump),
        .o_wb_sel(id_ex_wb_sel),
        .o_alu_src_b(id_ex_alu_src_b),
        .o_pc_plus_4(id_ex_pc_plus_4),
        .o_pc(id_ex_pc),
        .o_rs1_data(id_ex_rs1_data),
        .o_rs2_data(id_ex_rs2_data),
        .o_imm(id_ex_imm),
        .o_rd_addr(id_ex_rd_addr),
        .o_funct3(id_ex_funct3),
        .o_opcode(id_ex_opcode),
        .o_alu_op(id_ex_alu_op),
        .o_branch_op(id_ex_branch_op),
        .o_debug_inst(id_ex_mem_inst)  // Debug instruction output
    );

    // EX/MEM Stage outputs
    logic ex_mem_reg_write_en, ex_mem_dm_write_en, ex_mem_dm_read_en;
    logic [1:0] ex_mem_wb_sel;
    logic [31:0] ex_mem_pc_plus_4, ex_mem_alu_result, ex_mem_rs2_data;
    logic [4:0] ex_mem_rd_addr;
    logic [2:0] ex_mem_funct3;

    // DEBUG
    logic [WIDTH-1:0] ex_mem_wb_inst;

    p_ex_mem_stage ex_mem_stage (
        .clk(clk),
        .rst(rst),
        .en(1'b1),  // Enable signal
        .i_reg_write_en(id_ex_reg_write_en),
        .i_mem_write_en(id_ex_mem_write_en),
        .i_mem_read_en(id_ex_mem_read_en),
        .i_alu_src_a(id_ex_alu_src_a),
        .i_do_branch(id_ex_do_branch),
        .i_do_jump(id_ex_do_jump),
        .i_wb_sel(id_ex_wb_sel),
        .i_alu_src_b(id_ex_alu_src_b),
        .i_pc_plus_4(id_ex_pc_plus_4),
        .i_pc(id_ex_pc),
        .i_rs1_data(id_ex_rs1_data),
        .i_rs2_data(id_ex_rs2_data),
        .i_imm(id_ex_imm),
        .i_rd_addr(id_ex_rd_addr),
        .i_funct3(id_ex_funct3),
        .i_opcode(id_ex_opcode),
        .i_alu_op(id_ex_alu_op),
        .i_branch_op(id_ex_branch_op),
        // Outputs to MEM/WB stage
        .o_reg_write_en(ex_mem_reg_write_en),
        .o_dm_write_en(ex_mem_dm_write_en),
        .o_dm_read_en(ex_mem_dm_read_en),
        .o_wb_sel(ex_mem_wb_sel),
        .o_pc_plus_4(ex_mem_pc_plus_4),
        .o_alu_result(ex_mem_alu_result),
        .o_rs2_data(ex_mem_rs2_data),
        .o_rd_addr(ex_mem_rd_addr),
        .o_funct3(ex_mem_funct3),
        // Non-pipeline outputs
        .ext_pc_sel(ext_pc_sel),  // No external PC selection in this example
        .ext_jump_target(ext_jump_target),  // No external jump target
        // Debug
        .i_debug_inst(id_ex_mem_inst),  // Pass debug instruction from ID/EX
        .o_debug_inst(ex_mem_wb_inst)  // Debug instruction output
    );

    // MEM/WB Stage outputs
    logic [1:0] mem_wb_wb_sel;
    logic [31:0] mem_wb_pc_plus_4, mem_wb_alu_result, mem_wb_dm_data;

    // DEBUG
    logic [WIDTH-1:0] mem_wb_wb_inst;

    p_mem_wb_stage mem_wb_stage (
        .clk(clk),
        .rst(rst),
        .en(1'b1),  // Enable signal
        // From EX/MEM stage
        .i_reg_write_en(ex_mem_reg_write_en),
        .i_mem_write_en(ex_mem_dm_write_en),
        .i_mem_read_en(ex_mem_dm_read_en),
        .i_wb_sel(ex_mem_wb_sel),
        .i_pc_plus_4(ex_mem_pc_plus_4),
        .i_alu_result(ex_mem_alu_result),
        .i_rs2_data(ex_mem_rs2_data),
        .i_rd_addr(ex_mem_rd_addr),
        .i_funct3(ex_mem_funct3),
        // Outputs to WB stage
        .o_reg_write_en(ext_reg_write_en),
        .o_wb_sel(mem_wb_wb_sel),
        .o_pc_plus_4(mem_wb_pc_plus_4),
        .o_alu_result(mem_wb_alu_result),
        .o_mem_data(mem_wb_dm_data),
        .o_rd_addr(ext_rd_addr),
        // Debug
        .i_debug_inst(ex_mem_wb_inst),  // Pass debug instruction from EX/MEM
        .o_debug_inst(mem_wb_wb_inst)  // Debug instruction output
    );

    // WRITE BACK STAGE

    // DEBUG
    logic [WIDTH-1:0] WB_DEBUG_INST;
    assign WB_DEBUG_INST = mem_wb_wb_inst;

    rv32i_write_back_mux #(
        .WIDTH(WIDTH)
    ) wb_mux (
        .o_wb_data(ext_rd_data),
        .i_alu_result(mem_wb_alu_result),
        .i_mem_data(mem_wb_dm_data),
        .i_pc_plus_4(mem_wb_pc_plus_4),  // PC + 4 for JALR and JAL
        .i_wb_sel(mem_wb_wb_sel)
    );
endmodule
