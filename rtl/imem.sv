module imem(
    input  logic [31:0] a,    // Address
    output logic [31:0] rd    // Instruction
);

    // Memory stores 32-bit words and contains 64 words
    logic [31:0] RAM [63:0];

    initial begin
        // Initialize instruction memory from a hex file
        $readmemh("riscvtest.txt", RAM);
    end

    // Combinational read (byte addressable, word aligned via a[31:2] or a / 4)
    assign rd = RAM[a[31:2]];

endmodule