// MEMORY CYCLE CODE:
//module memory cycle---------------------------------------------------------------
module memory_cycle(clk, rst, RegWriteM,ResultSrcM,RD_M,MemWriteM, PCPlus4M, WriteDataM,ALU_ResultM,RegWriteW, ResultSrcW, RD_W, PCPlus4W, ALU_ResultW, ReadDataW );
input clk, rst, RegWriteM, ResultSrcM, MemWriteM;
input [4:0] RD_M;
input [31:0] PCPlus4M, WriteDataM,ALU_ResultM;
output RegWriteW, ResultSrcW;
output [31:0] ALU_ResultW, ReadDataW, PCPlus4W;
output [4:0] RD_W;

//declaration of wires:
wire [31:0] ReadDataM;

//declaration of modules initiation:
Data_Memory dmem(.clk(clk),
                 .rst(rst), 
                 .WE(MemWriteM), 
                 .WD(WriteDataM),
                 .A(ALU_ResultM),
                 .RD(ReadDataM));

//registers declaration:
reg RegWriteM_r, ResultSrcM_r;
reg [31:0] ALU_ResultM_r, ReadDataM_r, PCPlus4M_r;
reg [4:0] RD_M_r;

always @(posedge clk or posedge rst) begin 
if(rst==1'b1) begin 
    RegWriteM_r<=1'b0;
    ResultSrcM_r<=1'b0;
    ALU_ResultM_r<=32'b0;
    ReadDataM_r<=32'b0;
    PCPlus4M_r<=32'b0;
    RD_M_r<=5'b0;
    end
else begin 
    RegWriteM_r<=RegWriteM;
    ResultSrcM_r<=ResultSrcM;
    ALU_ResultM_r<=ALU_ResultM;
    ReadDataM_r<=ReadDataM;
    PCPlus4M_r<=PCPlus4M;
    RD_M_r<=RD_M;
    end
end

//declaration of output assignments:
assign RegWriteW=RegWriteM_r;
assign ResultSrcW=ResultSrcM_r;
assign RD_W=RD_M_r;
assign PCPlus4W=PCPlus4M_r;
assign ALU_ResultW=ALU_ResultM_r;
assign ReadDataW=ReadDataM_r;
endmodule
