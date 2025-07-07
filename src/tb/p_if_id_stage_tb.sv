`timescale 1ns / 1ps

module tb_p_if_id_stage;

    // Parameters
    localparam CLOCK = 10; // Clock period in ns

    // Clock and reset
    logic clk;
    logic rst;
    logic en;
    logic ext_pc_sel;
    logic [31:0] ext_jump_target;

    // Outputs
    logic [31:0] o_inst;
    logic [31:0] o_pc;
    logic [31:0] o_pc_plus_4;

    // Instantiate the DUT (Device Under Test)
    p_if_id_stage dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .ext_pc_sel(ext_pc_sel),
        .ext_jump_target(ext_jump_target),
        .o_inst(o_inst),
        .o_pc(o_pc),
        .o_pc_plus_4(o_pc_plus_4)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #(CLOCK / 2) clk = ~clk;
    end

    // Initialize and run the test
    initial begin
        // Waveform dump (optional)
        $dumpfile("tb_p_if_id_stage.vcd");
        $dumpvars(0, tb_p_if_id_stage);

        // Initial state
        en = 1;
        rst = 1;
        ext_pc_sel = 0;
        ext_jump_target = 0;

        #(CLOCK); // Wait for 2 clock cycles
        rst = 0;

        #(5*CLOCK); // Wait for a few cycles to stabilize
        en = 0; // Disable the stage

        // Reset for 2 cycles
        repeat (100) #(CLOCK);

        // Let it run for several instructions
        // repeat (10) begin
        //     @(posedge clk);
        //     $display("Cycle %0t | PC = 0x%08h | PC+4 = 0x%08h | INST = 0x%08h", $time, o_pc,
        //              o_pc_plus_4, o_inst);
        // end

        // Finish simulation
        $finish;
    end

endmodule
