module decoder(
    input [12:0] instruction,

    output [2:0] opcode,
    output [2:0] destination_R,
    output [2:0] source_R1,
    output [2:0] source_R2,
    output direction
);

assign opcode = instruction[12:10];
assign destination_R = instruction[9:7];
assign source_R1 = instruction[6:4];
assign source_R2 = instruction[3:1];
assign direction = instruction[0];

endmodule
