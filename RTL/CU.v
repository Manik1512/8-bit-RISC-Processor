module CU(
    input [2:0] opcode, //we are only reading opcode, no need to use reg
    
    output reg[2:0] alu_op,
    output reg reg_write, //being assigned inside always block hence be reg.
    output reg pc_enable
);

//cpu is combinational 

always @(*) begin
    //default 
    alu_op = 3'b000; // initialise the poutputs that we will be getting 
    reg_write = 1'b0;
    pc_enable = 1'b0;

    case(opcode)

    3'b000: begin
        // ADD
        alu_op = 3'b000;
        reg_write = 1'b1;
        pc_enable = 1'b1;
    end

    3'b001: begin
        // SUB
        alu_op = 3'b001;
        reg_write = 1'b1;
        pc_enable = 1'b1;
    end

    3'b010: begin
        // AND
        alu_op = 3'b010;
        reg_write = 1'b1;
        pc_enable = 1'b1;
    end

    3'b011: begin
        // OR
        alu_op = 3'b011;
        reg_write = 1'b1;
        pc_enable = 1'b1;
    end

    3'b100: begin
        // XOR
        alu_op = 3'b100;
        reg_write = 1'b1;
        pc_enable = 1'b1;
    end

    3'b101: begin
        // MOV
        alu_op = 3'b101;
        reg_write = 1'b1;
        pc_enable = 1'b1;
    end

    3'b110: begin
        // SHIFT
        alu_op = 3'b110;
        reg_write = 1'b1;
        pc_enable = 1'b1;
    end

    3'b111: begin
        // SPECIAL
        alu_op = 3'b111;
        reg_write = 1'b0;
        pc_enable = 1'b1;
    end

    endcase 
end 
endmodule 
