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
    o_mem_write_en,
    o_mem_read_en,
    o_alu_src_a,
    o_do_branch,
    o_do_jump,
    output logic [1:0] o_wb_sel,
    output logic [1:0] o_alu_src_b
);

    always_comb begin : control_unit
        o_reg_write_en = 0;
        o_mem_write_en = 0;
        o_mem_read_en  = 0;
        o_do_branch    = 0;
        o_do_jump      = 0;
        o_wb_sel       = `WB_SEL_ALU;
        o_alu_src_a    = `ALU_SRC_A_REG;
        o_alu_src_b    = `ALU_SRC_B_REG;
        unique case (i_opcode)
            `OPCODE_RTYPE: begin
                o_alu_src_a    = `ALU_SRC_A_REG;
                o_alu_src_b    = `ALU_SRC_B_REG;
                o_reg_write_en = 1;
                o_wb_sel       = `WB_SEL_ALU;
            end
            `OPCODE_ITYPE: begin
                o_alu_src_a    = `ALU_SRC_A_REG;
                o_alu_src_b    = `ALU_SRC_B_IMM;
                o_reg_write_en = 1;
                o_wb_sel       = `WB_SEL_ALU;
            end
            `OPCODE_BRANCH: begin
                o_alu_src_a    = `ALU_SRC_A_PC;
                o_alu_src_b    = `ALU_SRC_B_IMM;
                o_do_branch    = 1;
            end
            `OPCODE_JAL: begin
                o_alu_src_a    = `ALU_SRC_A_PC;
                o_alu_src_b    = `ALU_SRC_B_IMM;
                o_do_jump      = 1;
                o_reg_write_en = 1;
                o_wb_sel       = `WB_SEL_PC; // JAL writes PC + 4 to the register

            end
            `OPCODE_JALR: begin
                o_alu_src_a    = `ALU_SRC_A_REG;
                o_alu_src_b    = `ALU_SRC_B_IMM;
                o_do_jump      = 1;
                o_reg_write_en = 1;
                o_wb_sel       = `WB_SEL_PC; // JALR writes PC + 4 to the register

            end
            `OPCODE_LUI: begin
                o_alu_src_b    = `ALU_SRC_B_IMM;
                o_reg_write_en = 1;
                o_wb_sel       = `WB_SEL_ALU; // LUI writes immediate to the register

            end
            `OPCODE_AUIPC: begin
                o_alu_src_a    = `ALU_SRC_A_PC;
                o_alu_src_b    = `ALU_SRC_B_IMM;
                o_reg_write_en = 1;
                o_wb_sel       = `WB_SEL_ALU; // AUIPC writes PC + immediate to the register

            end
            `OPCODE_STORE: begin
                o_mem_write_en = 1;
                o_alu_src_a    = `ALU_SRC_A_REG;
                o_alu_src_b    = `ALU_SRC_B_IMM;
            end
            `OPCODE_LOAD: begin
                o_alu_src_a    = `ALU_SRC_A_REG;
                o_alu_src_b    = `ALU_SRC_B_IMM;
                o_reg_write_en = 1;
                o_wb_sel       = `WB_SEL_MEM; // Load writes memory data to the register
            end
            default: begin
                // Default case, no operation
                o_reg_write_en = 0;
                o_mem_write_en = 0;
                o_mem_read_en  = 0;
                o_do_branch    = 0;
                o_do_jump      = 0;
                o_wb_sel       = `WB_SEL_ALU; // Default write back is ALU result
                o_alu_src_a    = `ALU_SRC_A_REG;
                o_alu_src_b    = `ALU_SRC_B_REG;
            end
        endcase
    end
endmodule
