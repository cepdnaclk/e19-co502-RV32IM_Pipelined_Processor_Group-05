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
    input logic [6:0] i_opcode,
    input logic [2:0] i_funct3,
    input logic [6:0] i_funct7,
    input logic [WIDTH-1:0] i_rs1_data,
    input logic [WIDTH-1:0] i_rs2_data,
    input logic [WIDTH-1:0] i_imm
);

    logic opcode_rtype, opcode_itype;

    assign opcode_rtype = (i_opcode == `OPCODE_RTYPE);

    logic [WIDTH-1:0] rs1, rs2;
    // shift amount
    logic shamt;

    always_comb begin
        rs1   = i_rs1_data;
        rs2   = (opcode_rtype) ? i_rs2_data : i_imm;
        shamt = (opcode_rtype) ? rs2[4:0] : i_imm[4:0];
        case (i_funct3)
            `FUNCT3_ADD_SUB: o_result = (i_funct7[5] & opcode_rtype) ? (rs1 - rs2) : (rs1 + rs2);
            `FUNCT3_SLL: o_result = rs1 << shamt;
            `FUNCT3_SLT: o_result = ($signed(rs1) < $signed(rs2));
            `FUNCT3_SLTU: o_result = (rs1 < rs2);
            `FUNCT3_XOR: o_result = rs1 ^ rs2;
            `FUNCT3_SRL_SRA: o_result = (i_funct7[5]) ? ($signed(rs1) >>> shamt) : (rs1 >> shamt);
            `FUNCT3_OR: o_result = rs1 | rs2;
            `FUNCT3_AND: o_result = rs1 & rs2;
            default: o_result = 0;  // Default case to avoid latches
        endcase
    end
endmodule
