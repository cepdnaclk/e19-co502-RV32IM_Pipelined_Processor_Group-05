`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2025 10:21:32 PM
// Design Name: 
// Module Name: rv32i_write_back_mux
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

module rv32i_write_back_mux #(
    parameter WIDTH = 32
) (
    output logic [WIDTH-1:0] o_wb_data,
    input logic [WIDTH-1:0] i_alu_result,
    input logic [WIDTH-1:0] i_mem_data,
    input logic [WIDTH-1:0] i_pc_plus_4,
    input logic [1:0] i_wb_sel
    );

    always_comb begin
        unique case (i_wb_sel)
            `WB_SEL_ALU: o_wb_data = i_alu_result;  // ALU result
            `WB_SEL_MEM: o_wb_data = i_mem_data;    // Memory data
            `WB_SEL_PC:  o_wb_data = i_pc_plus_4;           // Program counter
            default:     o_wb_data = 'd0;            // Default case to avoid latches
        endcase
    end
endmodule
