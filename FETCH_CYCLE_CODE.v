// FETCH CYCLE CODE :
module fetch_cycle(clk, rst, PCSrcE, PCTargetE,PCD, InstrD,PCPlus4D);
input clk, rst, PCSrcE;
input [31:0] PCTargetE;
output [31:0] InstrD,PCPlus4D,PCD;

//declaring interim wires:
wire [31:0] PC_F,PCF,PCPlus4F,InstrF;

//initiation of modules:
Mux PC_Mux(.a(PCPlus4F),.b(PCTargetE),.s(PCSrcE),.c(PC_F));
PC_Module Program_Counter(.clk(clk),.rst(rst),.PC(PCF),.PC_Next(PC_F));
Instruction_Memory IMEM(.rst(rst),.A(PCF),.RD(InstrF));
PC_Adder pc_adder(.a(PCF),.b(32'd4),.c(PCPlus4F));

//declaration of register
reg [31:0] InstrF_reg,PCF_reg,PCPlus4F_reg;
always @(posedge clk or posedge rst) begin 
if (rst==1'b1) begin 
     InstrF_reg<=32'b0;
     PCF_reg<=32'b0;
     PCPlus4F_reg<=32'b0;
    end
else begin 
     InstrF_reg<=InstrF;
     PCF_reg<=PCF;
     PCPlus4F_reg<=PCPlus4F;
    end
end

//assigning registers to the output port 
assign InstrD=InstrF_reg;
assign PCD=PCF_reg;
assign PCPlus4D=PCPlus4F_reg;
endmodule
