module testbench_PC;
    reg clk;        //values that we give for test bench as reg
    reg reset;
    reg enable;
    wire [7:0] PC; //values that come as output go on wires, we cannot initialise these

    ProgramCounter uut( //this name should be same as our module we are testing
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .PC(PC)
    );

    //clock generate
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,testbench_PC);

        //initialize
        clk = 0;
        //print to console
        $monitor(
            "T=%0t | clk=%b | reset=%b | PC=%d",
            $time,
            clk,
            reset,
            PC
        );

        reset = 1;
        enable = 1;

        #27; //wait 27ns (reset = 1 for these 27 secs) // PC = 0 till 25s

        reset = 0;
        #29;         // at 35s PC = 1, 45s PC = 2, 55s PC = 3

        enable = 0;
        #30;         // till 85s PC = 3
        
        enable = 1;
        #50;         // from 95s onwards pc starts increasing


        $finish;

    end
endmodule

