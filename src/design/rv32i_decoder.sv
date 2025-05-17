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
    output logic [6:0] o_funct7,
    output logic [6:0] o_opcode
);

    always_comb begin
        o_opcode   = i_inst[6:0];
        o_funct3   = i_inst[14:12];
        o_funct7   = i_inst[31:25];
        o_rs1_addr = i_inst[19:15];
        o_rs2_addr = i_inst[24:20];
        o_rd_addr  = i_inst[11:7];
    end

    // Immediate generation
    logic [31:0] imm;
    
    always_comb begin
        case (o_opcode)
            `OPCODE_ITYPE, `OPCODE_LOAD, `OPCODE_JALR: imm = {{20{i_inst[31]}}, i_inst[31:20]};
            `OPCODE_STORE: imm = {{20{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
            `OPCODE_BRANCH:
            imm = {{19{i_inst[31]}}, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
            `OPCODE_JAL:
            imm = {{11{i_inst[31]}}, i_inst[31], i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0};
            `OPCODE_LUI, `OPCODE_AUIPC: imm = {i_inst[31:12], 12'h000};
            `OPCODE_SYSTEM, `OPCODE_FENCE: imm = {20'b0, i_inst[31:20]};
            default: imm = 0;
        endcase
    end

    assign o_imm = imm;
    
endmodule
