module program_simulation;
    reg clk;
    reg reset;

    CPU uut(
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Waveform dump
        $dumpfile("program_simulation.vcd");
        $dumpvars(0, program_simulation);

        // Initial reset
        reset = 1'b1;

        // Allow time for reset
        #10;

        // Load test program into instruction memory
        uut.ins_unit.memory[0] = 13'b0000010100110; // ADD R1,R2,R3
        uut.ins_unit.memory[1] = 13'b0011011000110; // SUB R5,R4,R3
        uut.ins_unit.memory[2] = 13'b0101100010100; // AND R6,R1,R2
        uut.ins_unit.memory[3] = 13'b0111110100110; // OR  R7,R2,R3
        uut.ins_unit.memory[4] = 13'b1000000010110; // XOR R0,R1,R3

        // Initialize register values
        uut.regf_unit.registers[0] = 8'd0;
        uut.regf_unit.registers[1] = 8'd0;
        uut.regf_unit.registers[2] = 8'd10;
        uut.regf_unit.registers[3] = 8'd5;
        uut.regf_unit.registers[4] = 8'd20;
        uut.regf_unit.registers[5] = 8'd0;
        uut.regf_unit.registers[6] = 8'd0;
        uut.regf_unit.registers[7] = 8'd0;

        // Release reset
        reset = 1'b0;

        // Allow the program to execute
        #60;

        $finish;

    end

endmodule
