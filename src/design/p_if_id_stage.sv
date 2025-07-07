`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 03:32:40 PM
// Design Name: 
// Module Name: p_if_id_stage
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


module p_if_id_stage (
    input logic clk,
    rst,
    en,
    output logic [31:0] o_inst,
    o_pc_plus_4,
    o_pc,
    // Non-pipeline inputs
    input logic ext_pc_sel,
    input logic [31:0] ext_jump_target
);

    localparam WIDTH = 32;

    // Internal signals
    logic [WIDTH-1:0] w_pc, w_pc_plus_4, w_inst;

    // DEBUG
    logic [WIDTH-1:0] DEBUG_INST;
    assign DEBUG_INST = w_inst;

    // Pipeline registers
    p_reg #(
        .WIDTH(32)
    ) p_inst_reg (
        .d(w_inst),
        .q(o_inst),
        .*
    );

    p_reg #(
        .WIDTH(32)
    ) p_pc_plus_4_reg (
        .d(w_pc_plus_4),
        .q(o_pc_plus_4),
        .*
    );

    p_reg #(
        .WIDTH(32)
    ) p_pc_reg (
        .d(w_pc),
        .q(o_pc),
        .*
    );

    // Program Counter
    rv32i_pc #(
        .WIDTH(WIDTH)
    ) pc_unit (
        .clk(clk),
        .rst(rst),
        .i_jump_target(ext_jump_target),  // ALU result used for branch/jump offsets
        .o_pc(w_pc),
        .o_pc_plus_4(w_pc_plus_4),
        .i_pc_sel(ext_pc_sel)  // Branch decision from  branch unit
    );

    // Instruction Memory
    rv32i_inst_mem #(
        .INST_WIDTH(WIDTH)
    ) inst_mem (
        .i_addr(w_pc),
        .o_inst(w_inst)
    );

endmodule
