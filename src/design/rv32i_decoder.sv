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
    input logic clk,
    rst,
    input logic [31:0] i_inst,
    output logic [4:0] o_rs1_addr,
    output logic [4:0] o_rs2_addr,
    output logic [4:0] o_rd_addr,
    output logic [31:0] o_imm,
    output logic [`OPCODE_WIDTH-1:0] o_opcode,
    output logic [`ALU_WIDTH-1:0] o_alu_op
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [4:0] rd_addr;

    always_comb begin
        opcode   = i_inst[6:0];
        funct3   = i_inst[14:12];
        funct7   = i_inst[31:25];

        rs1_addr = i_inst[19:15];
        rs2_addr = i_inst[24:20];
        rd_addr  = i_inst[11:7];
    end

    logic [31:0] imm;
    logic
        alu_add,
        alu_sub,
        alu_slt,
        alu_sltu,
        alu_xor,
        alu_or,
        alu_and,
        alu_sll,
        alu_srl,
        alu_sra,
        alu_eq,
        alu_neq,
        alu_ge,
        alu_geu;

    logic
        opcode_rtype,
        opcode_itype,
        opcode_load,
        opcode_store,
        opcode_branch,
        opcode_jal,
        opcode_jalr,
        opcode_lui,
        opcode_auipc;

    // Decode the instruction type
    always_comb begin
        opcode_rtype = (opcode == `OPCODE_RTYPE);
        opcode_itype = (opcode == `OPCODE_ITYPE);
        opcode_load = (opcode == `OPCODE_LOAD);
        opcode_store = (opcode == `OPCODE_STORE);
        opcode_branch = (opcode == `OPCODE_BRANCH);
        opcode_jal = (opcode == `OPCODE_JAL);
        opcode_jalr = (opcode == `OPCODE_JALR);
        opcode_lui = (opcode == `OPCODE_LUI);
        opcode_auipc = (opcode == `OPCODE_AUIPC);
    end

    // Decode the ALU operation
    always_comb begin
        if (opcode_rtype || opcode_itype) begin
            if (opcode_rtype) begin
                alu_add = (funct3 == `FUNCT3_ADD) ? !i_inst[30] : 0; //add and sub has same o_funct3 code
                alu_sub = (funct3 == `FUNCT3_ADD) ? i_inst[30] : 0;  //differs on i_inst[30]
            end else alu_add = (funct3 == `FUNCT3_ADD);

            alu_slt = (funct3 == `FUNCT3_SLT);
            alu_sltu = (funct3 == `FUNCT3_SLTU);
            alu_xor = (funct3 == `FUNCT3_XOR);
            alu_or = (funct3 == `FUNCT3_OR);
            alu_and = (funct3 == `FUNCT3_AND);
            alu_sll = (funct3 == `FUNCT3_SLL);
            alu_srl  = (funct3 == `FUNCT3_SRA) ? !i_inst[30] : 0;//srl and sra has same o_funct3 code
            alu_sra = (funct3 == `FUNCT3_SRA) ? i_inst[30] : 0;  //differs on i_inst[30]
        
            // set branch operations to 0 to avoid undefined behavior
            alu_eq = 1'b0;
            alu_neq = 1'b0;
            alu_ge = 1'b0;
            alu_geu = 1'b0;
        
        end else if (opcode_branch) begin
            alu_eq   = (funct3 == `FUNCT3_EQ);
            alu_neq  = (funct3 == `FUNCT3_NEQ);
            alu_slt  = (funct3 == `FUNCT3_LT);
            alu_ge   = (funct3 == `FUNCT3_GE);
            alu_sltu = (funct3 == `FUNCT3_LTU);
            alu_geu  = (funct3 == `FUNCT3_GEU);

        end else alu_add = 1'b1;  // Default to addition for other types
    end

    // Immediate generation
    always_comb begin
        case (opcode)
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

    always_comb begin

        /// ALU Operations
        o_alu_op[`ADD] = alu_add ? 1'b1 : 1'b0;
        o_alu_op[`SUB] = alu_sub ? 1'b1 : 1'b0;
        o_alu_op[`SLT] = alu_slt ? 1'b1 : 1'b0;
        o_alu_op[`SLTU] = alu_sltu ? 1'b1 : 1'b0;
        o_alu_op[`XOR] = alu_xor ? 1'b1 : 1'b0;
        o_alu_op[`OR] = alu_or ? 1'b1 : 1'b0;
        o_alu_op[`AND] = alu_and ? 1'b1 : 1'b0;
        o_alu_op[`SLL] = alu_sll ? 1'b1 : 1'b0;
        o_alu_op[`SRL] = alu_srl ? 1'b1 : 1'b0;
        o_alu_op[`SRA] = alu_sra ? 1'b1 : 1'b0;
        o_alu_op[`EQ] = alu_eq ? 1'b1 : 1'b0;
        o_alu_op[`NEQ] = alu_neq ? 1'b1 : 1'b0;
        o_alu_op[`GE] = alu_ge ? 1'b1 : 1'b0;
        o_alu_op[`GEU] = alu_geu ? 1'b1 : 1'b0;

        /// Opcode Operations
        o_opcode[`RTYPE]  = opcode_rtype;
        o_opcode[`ITYPE]  = opcode_itype;
        o_opcode[`LOAD]   = opcode_load;
        o_opcode[`STORE]  = opcode_store;
        o_opcode[`BRANCH] = opcode_branch;
        o_opcode[`JAL]    = opcode_jal;
        o_opcode[`JALR]   = opcode_jalr;
        o_opcode[`LUI]    = opcode_lui;
        o_opcode[`AUIPC]  = opcode_auipc;
        // o_opcode[`SYSTEM] = opcode_system;
        // o_opcode[`FENCE]  = opcode_fence;

        o_imm = imm;
        o_rs1_addr = rs1_addr;
        o_rs2_addr = rs2_addr;
        o_rd_addr = rd_addr;
    end
endmodule
