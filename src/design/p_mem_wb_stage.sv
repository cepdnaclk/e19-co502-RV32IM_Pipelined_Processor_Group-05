`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 03:32:40 PM
// Design Name: 
// Module Name: p_mem_wb_stage
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


module p_mem_wb_stage (
    input logic clk,
    rst,
    en,

    // From EX/MEM stage
    input logic i_reg_write_en,
    input logic i_mem_write_en,
    input logic i_mem_read_en,
    input logic [1:0] i_wb_sel,
    input logic [31:0] i_pc_plus_4,
    input logic [31:0] i_alu_result,
    input logic [31:0] i_rs2_data,
    input logic [4:0] i_rd_addr,
    input logic [2:0] i_funct3,

    // Outputs to WB stage
    output logic o_reg_write_en,
    output logic [1:0] o_wb_sel,
    output logic [31:0] o_pc_plus_4,
    output logic [31:0] o_alu_result,
    output logic [31:0] o_mem_data,
    output logic [4:0] o_rd_addr,

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
        .WIDTH(104)
    ) p_bypass_reg (
        .d({i_reg_write_en, i_wb_sel, i_pc_plus_4, i_alu_result, i_rd_addr, i_debug_inst}),
        .q({o_reg_write_en, o_wb_sel, o_pc_plus_4, o_alu_result, o_rd_addr, o_debug_inst}),
        .*
    );

    // Internal signal for memory data output
    logic [WIDTH-1:0] w_dm_data_out;

    // Pipeline register for memory data
    p_reg #(
        .WIDTH(WIDTH)
    ) p_mem_data_reg (
        .d(w_dm_data_out),
        .q(o_mem_data),
        .*
    );


    // Data Memory
    rv32i_data_mem #(
        .WIDTH(WIDTH)
    ) data_mem (
        .clk(clk),
        .rst(rst),
        .i_dm_we(i_mem_write_en),
        .i_dm_addr(i_alu_result),
        .i_dm_data_in(i_rs2_data),
        .i_dm_func3(i_funct3),
        .o_dm_data_out(w_dm_data_out)
    );
endmodule
