module alu #(parameter WIDTH = 32) (
    input  logic [WIDTH-1:0] a, b,
    input  logic [2:0]       alucontrol,
    output logic [WIDTH-1:0] result,
    output logic             zero
);
    logic [WIDTH-1:0] condinvb, sum;
    
    // For subtraction (alucontrol[0] = 1), invert b and add 1 (two's complement)
    assign condinvb = alucontrol[0] ? ~b : b;
    assign sum = a + condinvb + alucontrol[0];
    
    always_comb begin
        case (alucontrol[2:0])
            3'b000:  result = sum;          // ADD
            3'b001:  result = sum;          // SUB
            3'b010:  result = a & b;        // AND
            3'b011:  result = a | b;        // OR
            3'b101:  result = {31'b0, sum[WIDTH-1]}; // SLT (Set Less Than)
            default: result = {WIDTH{1'b0}};
        endcase
    end
    
    assign zero = (result == {WIDTH{1'b0}});
endmodule