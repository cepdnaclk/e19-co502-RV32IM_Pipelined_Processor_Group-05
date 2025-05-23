`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2025 10:37:41 AM
// Design Name: 
// Module Name: rv32i_cu
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


module rv32i_cu(
        input logic [6:0] i_opcode,
        output logic o_reg_write_en,
        output logic o_mem_write_en,
        output logic o_mem_read_en,
        output logic o_mem_to_reg,
        output logic o_alu_src_1,
        output logic [1:0] o_alu_src_2
    );
endmodule
