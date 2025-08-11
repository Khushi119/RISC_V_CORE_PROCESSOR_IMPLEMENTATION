//DECODE CYCLE CODE:
//module decode cycle------------------------------------------------------------------------------------------------
module decode_cycle(clk, rst, InstrD,PCD, PCPlus4D, RegWriteW, RDW, ResultW, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE,BranchE, ALUControlE,RD1_E,RD2_E, Imm_Ext_E, RD_E,PCE, PCPlus4E);
input clk,rst, RegWriteW;
input [31:0] InstrD, PCD, PCPlus4D,ResultW;
input [4:0] RDW;
output RegWriteE,ALUSrcE, MemWriteE,ResultSrcE,BranchE;
output [2:0] ALUControlE;
output [31:0] PCE, PCPlus4E, RD1_E,RD2_E,Imm_Ext_E;
output [4:0] RD_E;

//declare interim wires:
wire RegWriteD, ALUSrcD, MemWriteD, ResultSrcD, BranchD;
wire [1:0] ImmSrcD;
wire [2:0] ALUControlD;
wire [31:0] RD1_D, RD2_D,Imm_Ext_D;

// module initiation
Control_Unit_Top Control_Unit_Top(.Op(InstrD[6:0]),
                 .RegWrite(RegWriteD),
                 .ImmSrc(ImmSrcD),
                 .ALUSrc(ALUSrcD),
                 .MemWrite(MemWriteD),
                 .ResultSrc(ResultSrcD),
                 .Branch(BranchD),
                 .funct3(InstrD[14:12]),
                 .funct7(InstrD[31:25]),
                 .ALUControl(ALUControlD)
        );


//register file module:
Register_File Register_File(.clk(clk),
                     .rst(rst),
                     .WE3(RegWriteW),
                     .WD3(ResultW),
                     .A1(InstrD[19:15]),
                     .A2(InstrD[24:20]),
                     .A3(RDW),
                     .RD1(RD1_D),
                     .RD2(RD2_D)
            );

//sign extension module:
Sign_Extend  Sign_Extend(.In(InstrD[31:0]),
             .Imm_Ext(Imm_Ext_D),
             .ImmSrc(ImmSrcD));

//declaration of interim registers:
reg RegWriteD_r, ALUSrcD_r, MemWriteD_r,ResultSrcD_r, BranchD_r;
reg [2:0]ALUControlD_r;
reg [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r;
reg [4:0] RD_D_r;
reg [31:0] PCD_r, PCPlus4D_r;

//declare register logic:
always @(posedge clk or posedge rst) begin 
if(rst==1'b1) begin 
    RegWriteD_r<=1'b0;
    ALUSrcD_r<=1'b0;
    MemWriteD_r<=1'b0;
    ResultSrcD_r<=1'b0;
    BranchD_r<=1'b0;
    ALUControlD_r<=3'b000;
    RD1_D_r<=32'b0;
    RD2_D_r<=32'b0;
    Imm_Ext_D_r<=32'b0;
    RD_D_r<=5'b0;
    PCD_r<=32'b0;
    PCPlus4D_r<=32'b0;
    end
else begin 
        RegWriteD_r<=RegWriteD;
    ALUSrcD_r<=ALUSrcD;
    MemWriteD_r<=MemWriteD;
    ResultSrcD_r<=ResultSrcD;
    BranchD_r<=BranchD;
    ALUControlD_r<=ALUControlD;
    RD1_D_r<=RD1_D;
    RD2_D_r<=RD2_D;
    Imm_Ext_D_r<=Imm_Ext_D;
    RD_D_r<=InstrD[11:7];
    PCD_r<=PCD;
    PCPlus4D_r<=PCPlus4D;
  end
end

//output assignments:
assign RegWriteE=RegWriteD_r;
assign ALUSrcE=ALUSrcD_r;
assign MemWriteE=MemWriteD_r;
assign ResultSrcE=ResultSrcD_r;
assign BranchE=BranchD_r;
assign ALUControlE=ALUControlD_r;
assign RD1_E=RD1_D_r;
assign RD2_E=RD2_D_r;
assign Imm_Ext_E=Imm_Ext_D_r;
assign RD_E=RD_D_r;
assign PCE=PCD_r;
assign PCPlus4E=PCPlus4D_r;

endmodule
