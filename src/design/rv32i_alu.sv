`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/17/2025 12:03:51 AM
// Design Name:
// Module Name: rv32i_alu
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

module rv32i_alu #(
    parameter WIDTH = 32
) (
    output logic [WIDTH-1:0] o_result,
    input logic [`ALU_OP_WIDTH-1:0] i_alu_op,
    input logic i_alu_src_a,
    input logic [WIDTH-1:0] i_rs1_data,
    input logic [WIDTH-1:0] i_pc,
    input logic [1:0] i_alu_src_b,
    input logic [WIDTH-1:0] i_rs2_data,
    input logic [WIDTH-1:0] i_imm
);

    logic [WIDTH-1:0] rs1;
    logic [WIDTH-1:0] rs2;
    assign rs1 = (i_alu_src_a) ? i_pc : i_rs1_data;

    always_comb
        unique case (i_alu_src_b)
            `ALU_SRC_B_IMM: rs2 = i_imm;
            `ALU_SRC_B_PL4: rs2 = 32'd4;
            default:        rs2 = i_rs2_data;
        endcase

    logic [4:0] shamt;
    assign shamt = rs2[4:0];

    // arithmetic operation logic
    always_comb begin
        o_result      = 'd0;  // Default value to avoid latches
        unique case (i_alu_op)
            `ALU_ADD:  o_result = (rs1 + rs2);
            `ALU_SUB:  o_result = (rs1 - rs2);
            `ALU_SLL:  o_result = rs1 << shamt;
            `ALU_SLT:  o_result = ($signed(rs1) < $signed(rs2));
            `ALU_SLTU: o_result = (rs1 < rs2);
            `ALU_XOR:  o_result = rs1 ^ rs2;
            `ALU_SRL:  o_result = (rs1 >> shamt);
            `ALU_SRA:  o_result = ($signed(rs1) >>> shamt);
            `ALU_OR:   o_result = rs1 | rs2;
            `ALU_AND:  o_result = rs1 & rs2;
            `ALU_LUI:  o_result = rs2;  // LUI operation
        endcase
    end

    // // branch condition logic
    // always_comb begin
    // 	unique case (i_branch_op)
    // 		default : o_take_branch = 1'b0;
    // 	endcase
    // end
endmodule
