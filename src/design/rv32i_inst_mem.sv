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
    input logic [INST_WIDTH-1:0] i_addr,
    output logic [INST_WIDTH-1:0] o_inst
);

    logic [INST_WIDTH-1:0] inst_mem [0:255]; // 256 instructions

    initial begin
        $readmemh("./mem_data.mem", inst_mem); // Load instructions from file
    end

    assign o_inst = inst_mem[i_addr[9:2]]; // Use lower 8 bits as index (word-aligned)

endmodule
