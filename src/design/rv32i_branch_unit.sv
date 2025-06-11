`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/29/2025 08:05:53 PM
// Design Name:
// Module Name: rv32i_branch_unit
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

module rv32i_branch_unit #(
    parameter WIDTH = 32
) (
    output logic o_pc_sel,
    input logic [`ALU_OP_WIDTH-1:0] i_branch_op,
    input logic [WIDTH-1:0] i_rs1_data,
    input logic [WIDTH-1:0] i_rs2_data,
    input logic i_do_branch,
    i_do_jump
);

	logic o_take_branch;
    logic [WIDTH-1:0] rs1;
    logic [WIDTH-1:0] rs2;
    assign rs1 = i_rs1_data;
    assign rs2 = i_rs2_data;

    always_comb begin
        o_take_branch = 1'b0;  // Default value
        unique case (i_branch_op)
            `ALU_EQ:  o_take_branch = (rs1 == rs2);
            `ALU_NEQ: o_take_branch = (rs1 != rs2);
            `ALU_LT:  o_take_branch = ($signed(rs1) < $signed(rs2));
            `ALU_GE:  o_take_branch = ($signed(rs1) >= $signed(rs2));
            `ALU_LTU: o_take_branch = (rs1 < rs2);
            `ALU_GEU: o_take_branch = (rs1 >= rs2);
            default:  o_take_branch = 1'b0;  // Default case
        endcase
    end

	assign o_pc_sel = (i_do_branch && o_take_branch) || i_do_jump;

endmodule
