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

`include "rv32i_decoder_header.vh"

module rv32i_cu (
    input logic [6:0] i_opcode,
    output logic o_reg_write_en,
    output logic o_mem_write_en,
    output logic o_mem_read_en,
    output logic o_mem_to_reg,
    output logic o_alu_src_a,
    output logic [1:0] o_alu_src_b
);

    always_comb begin : control_unit
        o_reg_write_en = 0;
        o_mem_write_en = 0;
        o_mem_read_en = 0;
        o_mem_to_reg = `MEM_TO_REG_ALU;
        o_alu_src_a = `ALU_SRC_A_REG;
        o_alu_src_b = `ALU_SRC_B_REG;
        unique case (i_opcode)
            `OPCODE_RTYPE: begin
                o_reg_write_en = 1;
                o_alu_src_a = `ALU_SRC_A_REG;
                o_alu_src_b = `ALU_SRC_B_REG;
            end
            `OPCODE_ITYPE: begin
                o_reg_write_en = 1;
                o_alu_src_a = `ALU_SRC_A_REG;
                o_alu_src_b = `ALU_SRC_B_IMM;
            end
            `OPCODE_JAL: begin
                o_reg_write_en = 1;
                o_alu_src_a = `ALU_SRC_A_PC;
                o_alu_src_b = `ALU_SRC_B_PL4;
            end
            `OPCODE_JALR: begin
                o_reg_write_en = 1;
                o_alu_src_a = `ALU_SRC_A_PC;
                o_alu_src_b = `ALU_SRC_B_PL4;
            end
            `OPCODE_LUI: begin
                o_reg_write_en = 1;
                o_alu_src_b = `ALU_SRC_B_IMM;
            end
            `OPCODE_STORE: begin
                o_mem_write_en = 1;
                o_alu_src_a = `ALU_SRC_A_REG;
                o_alu_src_b = `ALU_SRC_B_IMM;
            end
            `OPCODE_LOAD: begin
                o_reg_write_en = 1;
                // o_mem_read_en = 1;
                o_alu_src_a = `ALU_SRC_A_REG;
                o_alu_src_b = `ALU_SRC_B_IMM;
            end
        endcase
    end
endmodule
