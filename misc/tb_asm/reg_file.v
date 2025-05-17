module MyModule;
    reg [31:0] MEM[0:255];
    `include "riscv_assembly.v"  // yes, needs to be included from here.
    integer L0_;
    initial begin
        ADD(x1, x0, x0);
        ADDI(x2, x0, 32);
        ADDI(x1, x1, 1);
        SUB(x3, x2, x1);
        EBREAK();
    end


    integer i;
    integer file;
    initial begin
        file = $fopen("mem_contents.txt", "w");
        if (file) begin
            for (i = 0; i < 10; i = i + 1) begin
                $fwrite(file, "%08x\n", MEM[i]);
            end
            $fclose(file);
        end else begin
            $display("Error opening file for writing.");
        end
    end

endmodule
