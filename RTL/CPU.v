module CPU(
    input clk,
    input reset
);

wire [7:0] PC;


wire [12:0] instruction;


wire [2:0] opcode; // the wire that comes out of decoder and goes into CU

wire [2:0] rd;
wire [2:0] rs1;
wire [2:0] rs2;
wire direction;


wire [2:0] alu_op; //comes out of CU and goes into ALU
wire reg_write;
wire pc_enable;


wire [7:0] data1;
wire [7:0] data2;

wire [7:0] result;



wire [7:0] R0;
wire [7:0] R1;
wire [7:0] R2;
wire [7:0] R3;
wire [7:0] R4;
wire [7:0] R5;
wire [7:0] R6;
wire [7:0] R7;



ProgramCounter pc_unit(
    .clk(clk),
    .reset(reset),
    .enable(pc_enable),
    .PC(PC)
);

ins_memory ins_unit(
    .pc(PC),
    .instruction(instruction)
);

decoder decoder_unit(
    .instruction(instruction),
    .opcode(opcode),
    .destination_R(rd),
    .source_R1(rs1),
    .source_R2(rs2),
    .direction(direction)
);

CU cu_unit(
    .opcode(opcode),
    .alu_op(alu_op),
    .reg_write(reg_write),
    .pc_enable(pc_enable)
);

register_file regf_unit(
    .clk(clk),
    .write_enable(reg_write),
    .read_ad1(rs1),
    .read_ad2(rs2),
    .write_addr(rd),
    .write_data(result),
    .read_data1(data1),
    .read_data2(data2)
);
assign R0 = regf_unit.registers[0];
assign R1 = regf_unit.registers[1];
assign R2 = regf_unit.registers[2];
assign R3 = regf_unit.registers[3];
assign R4 = regf_unit.registers[4];
assign R5 = regf_unit.registers[5];
assign R6 = regf_unit.registers[6];
assign R7 = regf_unit.registers[7];


ALU alu_unit(
    .a(data1),
    .b(data2),
    .direction(direction),
    .alu_op(alu_op),
    .result(result)
);

endmodule
