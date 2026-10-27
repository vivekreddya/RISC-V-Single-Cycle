module controller (
    input  logic        clk, 
    input  logic        reset, 
    input  logic        funct7b5, 
    input  logic        FlushE, 
    input  logic        ZeroE, 
    input  logic [2:0]  funct3, 
    input  logic [6:0]  opD, 
    output logic [2:0]  ImmSrcD, 
    output logic [2:0]  ALUControlE, 
    output logic [1:0]  ResultSrcW, 
    output logic        PCSrcE, 
    output logic        ALUSrcAE, 
    output logic        ALUSrcBE, 
    output logic        ResultSrcEb0, 
    output logic        MemWriteM, 
    output logic        RegWriteM, 
    output logic        RegWriteW
);
 
logic [2:0] ALUControlD;
    logic [1:0] ALUOpD, ResultSrcD, ResultSrcE, ResultSrcM;
    logic       RegWriteD, RegWriteE, MemWriteD, MemWriteE, JumpD, JumpE, BranchD, BranchE, ALUSrcAD, ALUSrcBD;

    // Main Decoder
    maindec md (
        .op(opD[5:0]), // or appropriate bit slice depending on maindec definition
        .RegWrite(RegWriteD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .Jump(JumpD),
        .Branch(BranchD),
        .ALUSrc(ALUSrcBD),
        .ImmSrc(ImmSrcD),
        .ALUOp(ALUOpD)
    );

    // Pipeline Register: Decode to Execute (controlre)
    floprc #(11) controlre (
        .clk(clk), 
        .reset(reset), 
        .clear(FlushE), 
        .d({RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcAD, ALUSrcBD}), 
        .q({RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcAE, ALUSrcBE})
    );
 assign PCSrcE = (BranchE & ZeroE) | JumpE;
    assign ResultSrcEb0 = ResultSrcE[0];

    // Pipeline Register: Execute to Memory (controlregM)
    flopr #(4) controlregM (
        .clk(clk), 
        .reset(reset), 
        .d({RegWriteE, ResultSrcE, MemWriteE}), 
        .q({RegWriteM, ResultSrcM, MemWriteM})
    );

    // Pipeline Register: Memory to Writeback (controlregW)
    flopr #(3) controlregW (
        .clk(clk), 
        .reset(reset), 
        .d({RegWriteM, ResultSrcM}), 
        .q({RegWriteW, ResultSrcW})
    );

endmodule

