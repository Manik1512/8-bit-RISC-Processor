module ALU(
  input [7:0] a, //source1
  input [7:0] b, //source2
  input direction,
  input [2:0] alu_op,
  output reg[7:0] result
);
  
  always @(*)
    begin
      case(alu_op)
        3'b000 : result = a + b; //add
        3'b001 : result = a - b; //sub
        3'b010 : result = a & b; //and
        3'b011 : result = a | b; //or
        3'b100 : result = a ^ b; //xor
        3'b101 : result = a; //MOV result <-- a
        3'b110 : //shift
        begin
          if(direction) 
            result = a>>1; //right
          else 
            result = a<<1; //left
        end 
        3'b111 : result = 8'b0 ; //special not defined yet
        default: result = 8'b0 ;
      endcase
    end
    
endmodule
