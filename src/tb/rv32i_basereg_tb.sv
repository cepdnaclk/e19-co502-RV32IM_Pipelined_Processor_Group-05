`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/07/2025 03:14:33 PM
// Design Name:
// Module Name: rv32i_basereg_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Testbench for rv32i_basereg
//
// Dependencies: rv32i_basereg.sv
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added comprehensive test cases
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module rv32i_basereg_tb;

    localparam int WIDTH = 32;  //default bit width
    localparam int ADDR_WIDTH = 5; // address width
    localparam int CLOCK = 10;  // clock period in ns

    // Testbench signals
    logic clk;
    logic rst;
    logic [ADDR_WIDTH-1:0] i_rs1_addr;
    logic [ADDR_WIDTH-1:0] i_rs2_addr;
    logic [ADDR_WIDTH-1:0] i_rd_addr;
    logic [WIDTH-1:0] i_rd_data;
    logic i_we;
    logic [WIDTH-1:0] o_rs1_data;
    logic [WIDTH-1:0] o_rs2_data;

    // Instantiate the Unit Under Test (UUT)
    rv32i_basereg #(.WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .i_we(i_we),
        .i_rs1_addr(i_rs1_addr),
        .i_rs2_addr(i_rs2_addr),
        .i_rd_addr(i_rd_addr),
        .i_rd_data(i_rd_data),
        .o_rs1_data(o_rs1_data),
        .o_rs2_data(o_rs2_data)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

    // Test sequence
    initial begin
        $display("Starting rv32i_basereg_tb test sequence...");

        // 1. Initialize and Reset
        rst = 1'b1;
        i_we = 1'b0;
        i_rs1_addr = 5'd0;
        i_rs2_addr = 5'd0;
        i_rd_addr = 5'd0;
        i_rd_data = 32'd0;
        #(2 * CLOCK); // Hold reset for 2 clock cycles
        rst = 1'b0;
        #(CLOCK); // Wait for reset to de-assert and propagate
        $display("Reset complete.");

        // 2. Test Write to x1 and Read from x1
        $display("Test 1: Write to x1, Read from x1");
        i_we = 1'b1;
        i_rd_addr = 5'd1;  // Write to register x1
        i_rd_data = 32'hAAAAAAAA;
        #(CLOCK); // Wait for write to complete

        i_we = 1'b0;  // Disable write
        i_rs1_addr = 5'd1;  // Read from register x1
        i_rs2_addr = 5'd0;  // Read x0 (should be 0)
        #(CLOCK); // Wait for read to propagate

        if (o_rs1_data === 32'hAAAAAAAA) begin
            $display("Test 1 PASSED. Read from x1: %h", o_rs1_data);
        end else begin
            $error("Test 1 FAILED! Expected x1: %h, Got: %h", 32'hAAAAAAAA, o_rs1_data);
        end
        if (o_rs2_data === 32'd0) begin
            $display("Test 1 PASSED. Read from x0 (rs2): %h", o_rs2_data);
        end else begin
            $error("Test 1 FAILED! Expected x0 (rs2): %h, Got: %h", 32'd0, o_rs2_data);
        end

        // 3. Test Write to x2 and Read from x2 (rs2_data) and x1 (rs1_data)
        $display("Test 2: Write to x2, Read from x1 (rs1) and x2 (rs2)");
        i_we = 1'b1;
        i_rd_addr = 5'd2;  // Write to register x2
        i_rd_data = 32'hBBBBBBBB;
        #(CLOCK);

        i_we = 1'b0;
        i_rs1_addr = 5'd1;  // Read from x1
        i_rs2_addr = 5'd2;  // Read from x2
        #(CLOCK);

        if (o_rs1_data === 32'hAAAAAAAA) begin
            $display("Test 2 PASSED. Read from x1: %h", o_rs1_data);
        end else begin
            $error("Test 2 FAILED! Expected x1: %h, Got: %h", 32'hAAAAAAAA, o_rs1_data);
        end
        if (o_rs2_data === 32'hBBBBBBBB) begin
            $display("Test 2 PASSED. Read from x2: %h", o_rs2_data);
        end else begin
            $error("Test 2 FAILED! Expected x2: %h, Got: %h", 32'hBBBBBBBB, o_rs2_data);
        end

        // 4. Test Write to x0 (should have no effect)
        $display("Test 3: Write to x0 (should be ignored)");
        i_we = 1'b1;
        i_rd_addr = 5'd0;  // Attempt to write to register x0
        i_rd_data = 32'hDEADBEEF;
        #(CLOCK);

        i_we = 1'b0;
        i_rs1_addr = 5'd0;  // Read from x0
        #(CLOCK);

        if (o_rs1_data === 32'd0) begin
            $display("Test 3 PASSED. Read from x0 after attempted write: %h", o_rs1_data);
        end else begin
            $error("Test 3 FAILED! Expected x0: %h, Got: %h", 32'd0, o_rs1_data);
        end

        // 5. Test Write to x31 and Read
        $display("Test 4: Write to x31, Read from x31");
        i_we = 1'b1;
        i_rd_addr = 5'd31; // Write to register x31
        i_rd_data = 32'hC0DEC0DE;
        #(CLOCK);

        i_we = 1'b0;
        i_rs1_addr = 5'd31;
        i_rs2_addr = 5'd2; // Read x2 again
        #(CLOCK);

        if (o_rs1_data === 32'hC0DEC0DE) begin
            $display("Test 4 PASSED. Read from x31: %h", o_rs1_data);
        end else begin
            $error("Test 4 FAILED! Expected x31: %h, Got: %h", 32'hC0DEC0DE, o_rs1_data);
        end
         if (o_rs2_data === 32'hBBBBBBBB) begin
            $display("Test 4 PASSED. Read from x2 (rs2): %h", o_rs2_data);
        end else begin
            $error("Test 4 FAILED! Expected x2 (rs2): %h, Got: %h", 32'hBBBBBBBB, o_rs2_data);
        end

        // 6. Test Read from unwritten register (e.g., x5, should be 0 after reset)
        $display("Test 5: Read from unwritten register x5 (should be 0)");
        i_rs1_addr = 5'd5;
        #(CLOCK);
        if (o_rs1_data === 32'd0) begin
            $display("Test 5 PASSED. Read from x5: %h", o_rs1_data);
        end else begin
            $error("Test 5 FAILED! Expected x5: %h, Got: %h", 32'd0, o_rs1_data);
        end

        $display("All tests completed.");
        $finish;
    end

    // VCD dump
    initial begin
        $dumpfile("rv32i_basereg_tb.vcd");
        $dumpvars(0, rv32i_basereg_tb); // Dump all signals in the testbench and below
    end

endmodule