`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/06/2025 08:23:38 PM
// Design Name:
// Module Name: rv32i_pc
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


module rv32i_pc #(
    parameter int WIDTH = 32
) (
    input logic clk,
    rst,
    i_pc_sel,
    input logic [WIDTH-1:0] i_jump_target,
    output logic [WIDTH-1:0] o_pc, o_pc_plus_4
);
    
    assign o_pc_plus_4 = o_pc + 32'd4;

    always_ff @(posedge clk) begin
        if (rst) o_pc <= 32'd0;
        else o_pc <= (i_pc_sel) ? i_jump_target : o_pc_plus_4;
    end


endmodule
