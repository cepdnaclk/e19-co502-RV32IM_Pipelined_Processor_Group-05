`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 03:32:40 PM
// Design Name: 
// Module Name: p_reg
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


module p_reg #(
    parameter WIDTH = 32
) (
    input logic clk,
    rst,
    en,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
    // always_ff @(posedge clk or negedge rst) begin
    //     if (!rst) begin
    //         q <= '0;
    //     end else if (en) begin
    //         q <= d;
    //     end
    // end

    always_ff @(posedge clk) begin
        if (rst) q <= '0;
        else if (en) q <= d;
    end

    //! DEBUG ONLY
    // Bypass the register functionality, essentially making it a wire
    // assign q = d;
endmodule
