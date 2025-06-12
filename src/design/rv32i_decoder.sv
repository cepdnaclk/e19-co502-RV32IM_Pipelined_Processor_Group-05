`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/08/2025 10:37:41 AM
// Design Name:
// Module Name: rv32i_decoder
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

module rv32i_decoder (
    input logic [31:0] i_inst,
    output logic [4:0] o_rs1_addr,
    output logic [4:0] o_rs2_addr,
    output logic [4:0] o_rd_addr,
    output logic [31:0] o_imm,
    output logic [2:0] o_funct3,
    output logic [6:0] o_opcode,
    output logic [`ALU_OP_WIDTH-1:0] o_alu_op,
    output logic [`ALU_OP_WIDTH-1:0] o_branch_op
);

    // Immediate generation
    logic [31:0] imm;
    logic [ 6:0] o_funct7;

    always_comb begin
        o_opcode   = i_inst[6:0];
        o_funct3   = i_inst[14:12];
        o_funct7   = i_inst[31:25];
        o_rs1_addr = i_inst[19:15];
        o_rs2_addr = i_inst[24:20];
        o_rd_addr  = i_inst[11:7];
    end


    always_comb begin
        unique case (o_opcode)
            `OPCODE_LUI, `OPCODE_AUIPC: imm = {i_inst[31], i_inst[30:12], {12{1'b0}}};  // (U-type)
            `OPCODE_ITYPE, `OPCODE_LOAD, `OPCODE_JALR:
            imm = {{21{i_inst[31]}}, i_inst[30:20]};  // (I-type)
            `OPCODE_STORE: imm = {{21{i_inst[31]}}, i_inst[30:25], i_inst[11:7]};  // (S-type)
            `OPCODE_BRANCH:
            imm = {{20{i_inst[31]}}, i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};  // (B-type)
            `OPCODE_JAL:
            imm = {{12{i_inst[31]}}, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0};  // (J-type)
            `OPCODE_SYSTEM, `OPCODE_FENCE: imm = 0;
            default: imm = 0;
        endcase
    end

    assign o_imm = imm;

    // ALU operation arithmetic logic
    always_comb begin
        unique case (o_opcode)
            `OPCODE_RTYPE, `OPCODE_ITYPE: begin
                unique case (o_funct3)
                    `FUNCT3_ADD_SUB:
                    o_alu_op = (o_funct7[5] && (o_opcode == `OPCODE_RTYPE)) ? `ALU_SUB : `ALU_ADD;
                    `FUNCT3_SLL: o_alu_op = `ALU_SLL;
                    `FUNCT3_SLT: o_alu_op = `ALU_SLT;
                    `FUNCT3_SLTU: o_alu_op = `ALU_SLTU;
                    `FUNCT3_XOR: o_alu_op = `ALU_XOR;
                    `FUNCT3_SRL_SRA: o_alu_op = (o_funct7[5]) ? `ALU_SRA : `ALU_SRL;
                    `FUNCT3_OR: o_alu_op = `ALU_OR;
                    `FUNCT3_AND: o_alu_op = `ALU_AND;
                    default: o_alu_op = 5'd0;  // Defaultcase to avoid latches
                endcase
            end
            `OPCODE_LUI:   o_alu_op = `ALU_LUI;  // LUI just forwards the immediate
            `OPCODE_AUIPC: o_alu_op = `ALU_ADD;  // AUIPC adds the immediate to the PC
            default:       o_alu_op = `ALU_ADD;  // Defaultcase
        endcase
    end

    // Branch condition logic
    always_comb begin
        if (o_opcode == `OPCODE_BRANCH) begin
            unique case (o_funct3)
                `FUNCT3_EQ:  o_branch_op = `ALU_EQ;
                `FUNCT3_NEQ: o_branch_op = `ALU_NEQ;
                `FUNCT3_LT:  o_branch_op = `ALU_LT;
                `FUNCT3_GE:  o_branch_op = `ALU_GE;
                `FUNCT3_LTU: o_branch_op = `ALU_LTU;
                `FUNCT3_GEU: o_branch_op = `ALU_GEU;
                default:     o_branch_op = `ALU_ADD;  // Defaultcase to avoid latches
            endcase
        end else o_branch_op = 'd0;  //NOP
    end

endmodule
