`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2025 08:25:57 AM
// Design Name: 
// Module Name: rv32i_data_mem
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

module rv32i_data_mem #(
    parameter int WIDTH = 32,
    parameter int ADDR_WIDTH = 32
) (
    input logic clk,
    rst,
    i_dm_we,
    input logic [ADDR_WIDTH-1:0] i_dm_addr,
    input logic [WIDTH-1:0] i_dm_data_in,
    input logic [2:0] i_dm_func3,  // Function code for memory operation
    output logic [WIDTH-1:0] o_dm_data_out
);

    logic [WIDTH-1:0] data_memory[0:255];  // 256 words of memory, each WIDTH bits wide

    logic [WIDTH-1:0] LOAD_w;
    logic [15:0] LOAD_hw;
    logic [7:0] LOAD_b;
    logic LOAD_sign;

    logic [ADDR_WIDTH-1:0] i_dm_addr_aligned;
    assign i_dm_addr_aligned = i_dm_addr[ADDR_WIDTH-1:2];

    always_comb begin

        // load halfword fitst and then byte
        LOAD_w = data_memory[i_dm_addr_aligned];  // Load word from memory
        LOAD_hw = i_dm_addr[1] ? LOAD_w[31:16] : LOAD_w[15:0];
        LOAD_b = i_dm_addr[0] ? LOAD_hw[15:8] : LOAD_hw[7:0];

        // extract sign bit depending -> (funct3_signed) -> hw or b
        LOAD_sign = !i_dm_func3[2] ? (i_dm_func3[0] ? LOAD_hw[15] : LOAD_b[7]) : 1'b0;

        // output data based on funct3
        unique case (i_dm_func3)
            `FUNCT3_LB, `FUNCT3_LBU:
            o_dm_data_out = {{24{LOAD_sign}}, LOAD_b};  // Load byte (signed or unsigned)
            `FUNCT3_LH, `FUNCT3_LHU:
            o_dm_data_out = {{16{LOAD_sign}}, LOAD_hw};  // Load half-word (signed or unsigned)
            `FUNCT3_LW: o_dm_data_out = LOAD_w;  // Load word
            default: o_dm_data_out = '0;  // Default case
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 256; i++) begin
                data_memory[i] <= 0;
            end
        end else if (i_dm_we) begin
            unique case (i_dm_func3)
                `FUNCT3_SW: data_memory[i_dm_addr_aligned] <= i_dm_data_in;  // Store word
                `FUNCT3_SH: data_memory[i_dm_addr_aligned] <= {data_memory[i_dm_addr_aligned][31:16], i_dm_data_in[15:0]};  // Store half-word
                `FUNCT3_SB: data_memory[i_dm_addr_aligned] <= {data_memory[i_dm_addr_aligned][31:8], i_dm_data_in[7:0]};  // Store byte
                default: ;
            endcase
        end
    end
endmodule
