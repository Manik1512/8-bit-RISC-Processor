module testbench_ALU;
  reg[7:0] a, b;
  reg[2:0] alu_op;
  reg direction;

  wire[7:0] result;
  
  ALU uut(
    .a(a),
    .b(b),
    .alu_op(alu_op),
    .direction(direction),
    .result(result)
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench_ALU);
    $monitor(
      "T=%0t | a = %b | b = %b | direction = %b | result = %b",
      $time,
      a,
      b,
      direction,
      result
    );
    //initializing
    a = 8'd27; b = 8'd19; direction = 1'b0;
    
    alu_op = 3'd0; #10;
    alu_op = 3'd4; #10;
    alu_op = 3'd2; #10;
    alu_op = 3'd1; #10;
    alu_op = 3'd5; #10;
    alu_op = 3'd6; 
    direction = 1'b1; #10;
    direction = 1'b0; #10;
    
    $finish;
    
  end
endmodule
