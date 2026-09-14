module CU_TB;
    reg [2:0] opcode;

    wire [2:0] alu_op;
    wire reg_write;
    wire pc_enable;

CU uut(
    .opcode(opcode),
    .alu_op(alu_op),
    .reg_write(reg_write),
    .pc_enable(pc_enable)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, CU_TB);

    $monitor (
        "T = %0t | opcode = %d | alu_op = %d | reg_write = %b | pc_enable = %b ",
        $time,
        opcode,
        alu_op,
        reg_write,
        pc_enable
    );

    //initializing 000
    opcode = 3'b000;
    #10;

    opcode = 3'b001;
    #10;

    opcode = 3'b011;
    #10;

    opcode = 3'b111;
    #10;

    opcode = 3'b100;
    #10;

    $finish;

end
endmodule
