module ins_memory(
    input [7:0] pc,

    output [12:0] instruction
);

reg[12:0] memory [0:255];

initial begin
    memory[0] = 13'b0000010100110;
    memory[1] = 13'b1011000010000;
    memory[2] = 13'b1101001000000;
    memory[3] = 13'b1001011000010;
    memory[4] = 13'b0101101010100;
    memory[5] = 13'b0011111100000;
    memory[6] = 13'b1101111110001;
    memory[7] = 13'b1011100110101; //random
end 

assign instruction = memory[pc];

endmodule
