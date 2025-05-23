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
    input logic [6:0] i_opcode,
    input logic [WIDTH-1:0] pc
    );

    logic i_mem_to_reg;
    assign i_mem_to_reg = (i_opcode == `OPCODE_LOAD) ? 1'b1 : 1'b0;

    always_comb begin
        if (i_mem_to_reg) begin
            o_wb_data = i_mem_data;
        end else begin
            o_wb_data = i_alu_result;
        end
    end
endmodule
