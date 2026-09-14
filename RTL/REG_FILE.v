//REGISTER FILE 
//8 REGISTER 8 BIT EACH
// 2 READ REGS
// 1 WRITE REG
// CLOCK

module register_file(
  input clk,
  input write_enable,
  input [2:0] read_ad1,
  input [2:0] read_ad2,
  input [2:0] write_addr,
  input [7:0] write_data,
  output[7:0] read_data1,
  output[7:0] read_data2 
);
  
  reg[7:0] registers [0:7]; //8 bit registers, named from 0 to 7 (3bit names) 
  
  initial begin
    registers[0] = 8'd0;
    registers[1] = 8'd0;
    registers[2] = 8'd10;
    registers[3] = 8'd5;
    registers[4] = 8'd20;
    registers[5] = 8'd15;
    registers[6] = 8'd8;
    registers[7] = 8'd3;
  end

  assign read_data1 = registers[read_ad1]; //combinational reads no clock req
  assign read_data2 = registers[read_ad2];
  
  always @(posedge clk) 
    begin
      if(write_enable)
        registers[write_addr] <= write_data;
      
    end
endmodule
