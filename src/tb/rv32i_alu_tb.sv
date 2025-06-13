`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/17/2025 01:17:25 AM
// Design Name:
// Module Name: rv32i_alu_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Testbench for rv32i_alu
//
// Dependencies: rv32i_alu.sv, rv32i_decoder_header.vh
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Extended test cases, improved reset, added result checking
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

`include "rv32i_decoder_header.vh"

module rv32i_alu_tb;

    localparam WIDTH = 32;  //default bit width
    localparam CLOCK = 10;  // clock period in ns

    // common signals
    logic clk;
    logic rst;

    // define inputs and outputs for the ALU
    logic [WIDTH-1:0] o_result;
    // logic o_take_branch; // Removed as rv32i_alu.sv does not output this

    logic [`ALU_OP_WIDTH-1:0] i_alu_op;
    logic i_alu_src_a;
    logic [WIDTH-1:0] i_rs1_data;
    logic [WIDTH-1:0] i_pc;
    logic [1:0] i_alu_src_b;
    logic [WIDTH-1:0] i_rs2_data;
    logic [WIDTH-1:0] i_imm;

    // Test cases
    logic [WIDTH-1:0] expected_result;

    // instantiate the ALU
    rv32i_alu #(.WIDTH(WIDTH)) uut (
        .o_result(o_result),
        .i_alu_op(i_alu_op),
        .i_alu_src_a(i_alu_src_a),
        .i_rs1_data(i_rs1_data),
        .i_pc(i_pc),
        .i_alu_src_b(i_alu_src_b),
        .i_rs2_data(i_rs2_data),
        .i_imm(i_imm)
        // .o_take_branch - not in DUT
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize signals and apply reset
        rst = 1'b1; // Assert reset
        i_alu_op    = `ALU_ADD; // Default to avoid X during reset
        i_alu_src_a = `ALU_SRC_A_REG;
        i_rs1_data  = 32'd0;
        i_pc        = 32'd0;
        i_alu_src_b = `ALU_SRC_B_REG;
        i_rs2_data  = 32'd0;
        i_imm       = 32'd0;
        #(2 * CLOCK);
        rst = 1'b0;    // De-assert reset
        #CLOCK;        // Wait for reset to propagate

        // Test 1: ADD (rs1 + rs2)
        $display("Starting Test 1: ADD (rs1 + rs2)");
        i_alu_op = `ALU_ADD;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'd10;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd20;
        expected_result = 32'd30;
        #CLOCK;
        if (o_result === expected_result) $display("Test 1 PASSED. %d + %d = %d", i_rs1_data, i_rs2_data, o_result);
        else $error("Test 1 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 2: ADD (rs1 + imm)
        $display("Starting Test 2: ADD (rs1 + imm)");
        i_alu_op = `ALU_ADD;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'd15;
        i_alu_src_b = `ALU_SRC_B_IMM; i_imm = 32'd25;
        expected_result = 32'd40;
        #CLOCK;
        if (o_result === expected_result) $display("Test 2 PASSED. %d + %d (imm) = %d", i_rs1_data, i_imm, o_result);
        else $error("Test 2 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 3: ADD (pc + imm)
        $display("Starting Test 3: ADD (pc + imm)");
        i_alu_op = `ALU_ADD;
        i_alu_src_a = `ALU_SRC_A_PC;  i_pc = 32'h1000;
        i_alu_src_b = `ALU_SRC_B_IMM; i_imm = 32'h40;
        expected_result = 32'h1040;
        #CLOCK;
        if (o_result === expected_result) $display("Test 3 PASSED. %h (pc) + %h (imm) = %h", i_pc, i_imm, o_result);
        else $error("Test 3 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 4: ADD (pc + 4)
        $display("Starting Test 4: ADD (pc + 4)");
        i_alu_op = `ALU_ADD;
        i_alu_src_a = `ALU_SRC_A_PC;  i_pc = 32'h2000;
        i_alu_src_b = `ALU_SRC_B_PL4; // rs2 becomes 4
        expected_result = 32'h2004;
        #CLOCK;
        if (o_result === expected_result) $display("Test 4 PASSED. %h (pc) + 4 = %h", i_pc, o_result);
        else $error("Test 4 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 5: SUB (rs1 - rs2)
        $display("Starting Test 5: SUB (rs1 - rs2)");
        i_alu_op = `ALU_SUB;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'd50;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd20;
        expected_result = 32'd30;
        #CLOCK;
        if (o_result === expected_result) $display("Test 5 PASSED. %d - %d = %d", i_rs1_data, i_rs2_data, o_result);
        else $error("Test 5 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 6: SUB (rs1 - rs2) with negative result
        $display("Starting Test 6: SUB (negative result)");
        i_alu_op = `ALU_SUB;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'd20;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd50;
        expected_result = 32'hFFFFFFE2; // -30
        #CLOCK;
        if (o_result === expected_result) $display("Test 6 PASSED. %d - %d = %h (%d)", i_rs1_data, i_rs2_data, o_result, $signed(o_result));
        else $error("Test 6 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 7: SLL (rs1 << shamt from rs2[4:0])
        $display("Starting Test 7: SLL");
        i_alu_op = `ALU_SLL;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'h0000000F;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd3; // shamt = 3
        expected_result = 32'h00000078;
        #CLOCK;
        if (o_result === expected_result) $display("Test 7 PASSED. %h << %d = %h", i_rs1_data, i_rs2_data[4:0], o_result);
        else $error("Test 7 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 8: SLT (signed rs1 < signed rs2) - True
        $display("Starting Test 8: SLT (True)");
        i_alu_op = `ALU_SLT;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'sd10;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'sd20;
        expected_result = 32'd1;
        #CLOCK;
        if (o_result === expected_result) $display("Test 8 PASSED. signed(%d) < signed(%d) is %d", $signed(i_rs1_data), $signed(i_rs2_data), o_result);
        else $error("Test 8 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 9: SLT (signed rs1 < signed rs2) - False
        $display("Starting Test 9: SLT (False)");
        i_alu_op = `ALU_SLT;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'sd20;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'sd10;
        expected_result = 32'd0;
        #CLOCK;
        if (o_result === expected_result) $display("Test 9 PASSED. signed(%d) < signed(%d) is %d", $signed(i_rs1_data), $signed(i_rs2_data), o_result);
        else $error("Test 9 FAILED. Expected %h, Got %h", expected_result, o_result);
        
        // Test 10: SLT (signed rs1 < signed rs2) - Negative numbers
        $display("Starting Test 10: SLT (Negative numbers)");
        i_alu_op = `ALU_SLT;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'hFFFFFFF_B; // -5
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'sd2;       //  2
        expected_result = 32'd1;
        #CLOCK;
        if (o_result === expected_result) $display("Test 10 PASSED. signed(%d) < signed(%d) is %d", $signed(i_rs1_data), $signed(i_rs2_data), o_result);
        else $error("Test 10 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 11: SLTU (unsigned rs1 < unsigned rs2) - True
        $display("Starting Test 11: SLTU (True)");
        i_alu_op = `ALU_SLTU;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'd10;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd20;
        expected_result = 32'd1;
        #CLOCK;
        if (o_result === expected_result) $display("Test 11 PASSED. unsigned(%d) < unsigned(%d) is %d", i_rs1_data, i_rs2_data, o_result);
        else $error("Test 11 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 12: SLTU (unsigned rs1 < unsigned rs2) - False (large unsigned vs small)
        $display("Starting Test 12: SLTU (False, large unsigned)");
        i_alu_op = `ALU_SLTU;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'hFFFFFFF_B; // Large positive unsigned
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd2;         // Small positive unsigned
        expected_result = 32'd0;
        #CLOCK;
        if (o_result === expected_result) $display("Test 12 PASSED. unsigned(%h) < unsigned(%h) is %d", i_rs1_data, i_rs2_data, o_result);
        else $error("Test 12 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 13: XOR
        $display("Starting Test 13: XOR");
        i_alu_op = `ALU_XOR;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'hA5A5A5A5;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'h5A5A5A5A;
        expected_result = 32'hFFFFFFFF;
        #CLOCK;
        if (o_result === expected_result) $display("Test 13 PASSED. %h ^ %h = %h", i_rs1_data, i_rs2_data, o_result);
        else $error("Test 13 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 14: SRL (Logical Right Shift)
        $display("Starting Test 14: SRL");
        i_alu_op = `ALU_SRL;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'hF000000F;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd4; // shamt = 4
        expected_result = 32'h0F000000;
        #CLOCK;
        if (o_result === expected_result) $display("Test 14 PASSED. %h >> %d = %h", i_rs1_data, i_rs2_data[4:0], o_result);
        else $error("Test 14 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 15: SRA (Arithmetic Right Shift) - Negative number
        $display("Starting Test 15: SRA (Negative)");
        i_alu_op = `ALU_SRA;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'hF000000F; // MSB is 1
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd4; // shamt = 4
        expected_result = 32'hFF000000;
        #CLOCK;
        if (o_result === expected_result) $display("Test 15 PASSED. signed %h >>> %d = %h", i_rs1_data, i_rs2_data[4:0], o_result);
        else $error("Test 15 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 16: SRA (Arithmetic Right Shift) - Positive number
        $display("Starting Test 16: SRA (Positive)");
        i_alu_op = `ALU_SRA;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'h7000000F; // MSB is 0
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'd4; // shamt = 4
        expected_result = 32'h07000000;
        #CLOCK;
        if (o_result === expected_result) $display("Test 16 PASSED. signed %h >>> %d = %h", i_rs1_data, i_rs2_data[4:0], o_result);
        else $error("Test 16 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 17: OR
        $display("Starting Test 17: OR");
        i_alu_op = `ALU_OR;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'hA5A50000;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'h5A5AFFFF;
        expected_result = 32'hFFFFFFFF;
        #CLOCK;
        if (o_result === expected_result) $display("Test 17 PASSED. %h | %h = %h", i_rs1_data, i_rs2_data, o_result);
        else $error("Test 17 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 18: AND
        $display("Starting Test 18: AND");
        i_alu_op = `ALU_AND;
        i_alu_src_a = `ALU_SRC_A_REG; i_rs1_data = 32'hA5A5F0F0;
        i_alu_src_b = `ALU_SRC_B_REG; i_rs2_data = 32'h5A5A0F0F;
        expected_result = 32'h00000000;
        #CLOCK;
        if (o_result === expected_result) $display("Test 18 PASSED. %h & %h = %h", i_rs1_data, i_rs2_data, o_result);
        else $error("Test 18 FAILED. Expected %h, Got %h", expected_result, o_result);

        // Test 19: LUI (Load Upper Immediate)
        $display("Starting Test 19: LUI");
        i_alu_op = `ALU_LUI;
        i_alu_src_a = `ALU_SRC_A_REG; // rs1 not directly used by LUI in this ALU, but src_a must be set
        i_rs1_data = 32'hDEADBEEF;   // Value for rs1, though not used by LUI result
        i_alu_src_b = `ALU_SRC_B_IMM; // Selects i_imm for rs2, which LUI uses
        i_imm = 32'hABCDE000;
        expected_result = 32'hABCDE000;
        #CLOCK;
        if (o_result === expected_result) $display("Test 19 PASSED. LUI with imm %h results in %h", i_imm, o_result);
        else $error("Test 19 FAILED. Expected %h, Got %h", expected_result, o_result);

        $display("All tests completed.");
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t rst=%b i_alu_op=%h i_alu_src_a=%b i_rs1_data=%h i_pc=%h i_alu_src_b=%b i_rs2_data=%h i_imm=%h o_result=%h",
                 $time, rst, i_alu_op, i_alu_src_a, i_rs1_data, i_pc, i_alu_src_b, i_rs2_data, i_imm, o_result);
    end

endmodule