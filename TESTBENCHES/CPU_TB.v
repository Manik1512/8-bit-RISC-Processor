module CPU_TB;
    reg clk;
    reg reset;

    CPU uut(
        .clk(clk),
        .reset(reset)
    );

    always #5 clk=~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, CPU_TB);


        //INITIALIZE THE CLK AND RESET
        clk = 0;
        reset = 1; 
        #10; //create a 10ns steady state where pc = 0 becuase reset dont change until we give reset = 0

        reset = 0;
        #100;

        $finish;
    end
endmodule


