module ProgramCounter(
    input clk,
    input reset,
    input enable,
    output reg [7:0] PC
);

always @(posedge clk)
begin
    if (reset)
        PC <= 8'd0;
    
    else if (enable)
        PC <= PC + 1;

    else 
        PC <= PC;
end
endmodule 
