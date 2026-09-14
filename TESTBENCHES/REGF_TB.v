module tb_regfile;

    reg clk;
    reg write_enable;

    reg [2:0] read_ad1;
    reg [2:0] read_ad2;
    reg [2:0] write_addr;

    reg [7:0] write_data;

    wire [7:0] read_data1;
    wire [7:0] read_data2;

    // Instantiate the Register File
    register_file uut(
        .clk(clk),
        .write_enable(write_enable),
        .read_ad1(read_ad1),
        .read_ad2(read_ad2),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    initial begin

        // Generate waveform
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_regfile);

        // Print everything to console
        $monitor(
        "T=%0t | CLK=%b WE=%b | WA=%d WD=%d | RA1=%d RD1=%d | RA2=%d RD2=%d",
        $time,
        clk,
        write_enable,
        write_addr,
        write_data,
        read_ad1,
        read_data1,
        read_ad2,
        read_data2
        );

        // Initialize all signals
        clk = 0;
        write_enable = 0;

        read_ad1 = 0;
        read_ad2 = 0;

        write_addr = 0;
        write_data = 0;

        #2;

        //-------------------------------------------------
        // Write 42 into Register 3
        //-------------------------------------------------

        write_enable = 1;
        write_addr = 3;
        write_data = 8'd42;

        #10;

        //-------------------------------------------------
        // Write 99 into Register 5
        //-------------------------------------------------

        write_addr = 5;
        write_data = 8'd99;

        #10;

        //-------------------------------------------------
        // Write 7 into Register 1
        //-------------------------------------------------

        write_addr = 1;
        write_data = 8'd7;

        #10;

        //-------------------------------------------------
        // Disable write
        //-------------------------------------------------

        write_enable = 0;

        //-------------------------------------------------
        // Read Register 3 and Register 5
        //-------------------------------------------------

        read_ad1 = 3;
        read_ad2 = 5;

        #10;

        //-------------------------------------------------
        // Read Register 1 and Register 3
        //-------------------------------------------------

        read_ad1 = 1;
        read_ad2 = 3;

        #10;

        $finish;

    end

endmodule
