module decoder_tb;
    reg [12:0] instruction;

    wire [2:0] opcode;
    wire [2:0] destination_R;
    wire [2:0] source_R1;
    wire [2:0] source_R2;
    wire direction;

    decoder uut(
        .instruction(instruction),
        .opcode(opcode),
        .destination_R(destination_R),
        .source_R1(source_R1),
        .source_R2(source_R2),
        .direction(direction),
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,decoder_tb);

        instruction = 13'b1010000111110;
        #10;

        $finish;
    end
endmodule

