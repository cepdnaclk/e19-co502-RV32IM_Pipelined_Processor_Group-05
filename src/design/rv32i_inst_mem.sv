`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/06/2025 08:23:38 PM
// Design Name:
// Module Name: rv32i_inst_mem
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


module rv32i_inst_mem #(
    parameter int INST_WIDTH = 32
) (
    input logic clk, rst,
    input logic [INST_WIDTH-1:0] i_addr,
    output logic [INST_WIDTH-1:0] o_inst
);

    logic [INST_WIDTH-1:0] inst_mem [0:255]; // 256 instructions

    initial begin
        $readmemh("mem_data.mem", inst_mem); // Load instructions from file
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            o_inst <= 0;
        else
            o_inst <= inst_mem[i_addr[INST_WIDTH-1:2]]; // Read instruction from memory
    end

endmodule
