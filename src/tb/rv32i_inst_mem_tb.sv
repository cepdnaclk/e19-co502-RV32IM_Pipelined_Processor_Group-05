`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2025 01:38:10 PM
// Design Name: 
// Module Name: rv32i_inst_mem_tb
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


module rv32i_inst_mem_tb;

    localparam int WIDTH = 32; //default bit width
    localparam int CLOCK = 10; // clock period in ns

    logic clk;
    logic rst;
    logic [WIDTH-1:0] i_addr;
    logic [WIDTH-1:0] o_inst;

    rv32i_inst_mem #(
        .INST_WIDTH(WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .i_addr(i_addr),
        .o_inst(o_inst)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

    // Iterate through addresses
    initial begin
        rst = 1'b1;
        #(CLOCK);
        rst = 1'b0;

        for (int i = 0; i < 100; i = i + 4) begin
            i_addr = i;
            #(CLOCK);
            $display("Address: %0d, Instruction: %h", i_addr, o_inst);
        end

        $finish;
    end

    initial begin
        $dumpfile("rv32i_inst_mem_tb.vcd");
        $dumpvars(0, uut);
    end

endmodule

