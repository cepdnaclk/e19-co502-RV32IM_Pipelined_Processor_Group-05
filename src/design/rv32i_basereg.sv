`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2025 02:53:09 PM
// Design Name: 
// Module Name: rv32i_basereg
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


module rv32i_basereg #(
    parameter int WIDTH = 32,
    parameter int ADDR_WIDTH = 5
) (
    input logic clk,
    rst,
    i_we,
    input logic [ADDR_WIDTH-1:0] i_rs1_addr,
    input logic [ADDR_WIDTH-1:0] i_rs2_addr,
    input logic [ADDR_WIDTH-1:0] i_rd_addr,
    input logic [WIDTH-1:0] i_rd_data,
    output logic [WIDTH-1:0] o_rs1_data,
    output logic [WIDTH-1:0] o_rs2_data
);

    logic [WIDTH-1:0] reg_file[0:31];  // 32 registers, each WIDTH bits wide

    always_comb begin
        o_rs1_data  = reg_file[i_rs1_addr];
        o_rs2_data  = reg_file[i_rs2_addr];
        reg_file[0] = 0;  // Register 0 is hardwired to 0
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) begin
                reg_file[i] <= 0;
            end
        end else if (i_we && i_rd_addr != 0) begin
            reg_file[i_rd_addr] <= i_rd_data;
        end
    end

endmodule
