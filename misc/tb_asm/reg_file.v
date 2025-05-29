module MyModule;
    reg [31:0] MEM[0:255];
    `include "riscv_assembly.v"  // yes, needs to be included from here.

    // labels goes here.
    // labels are defind as; integer L_line_number = line_number*4; //starting from 0
    integer L0_ = 8;

    initial begin
        LUI(x4, 18);
        ADDI(x4, x4, 32'h345);
        LUI(x5, 32'h000AB);
        ADDI(x5, x5, 32'h7F);
        ADDI(x5, x5, 32'h100);
        ADDI(x5, x5, 32'h200);
        LUI(x6, 32'h00F00);
        ADDI(x6, x6, 32'h001);
        LUI(x7, 32'hFFFFF);
        ADDI(x7, x7, -2048);
        LUI(x8, 32'h80000);
        ADDI(x8, x8, 0);
        LUI(x9, 32'h00001);
        ADDI(x9, x9, -32'h800);
        ADDI(x9, x9, -32'h800);

        EBREAK();

        endASM();
    end


    integer i;
    integer file;
    initial begin
        file = $fopen("mem_contents.txt", "w");
        if (file) begin
            for (i = 0; i < 255; i = i + 1) begin
                $fwrite(file, "%08x\n", MEM[i]);
            end
            $fclose(file);
        end else begin
            $display("Error opening file for writing.");
        end
    end

endmodule
