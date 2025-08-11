// TOP MODULE CODE:
module pipeline_top(clk, rst);

//declaration of inputs and outputs:
input clk, rst;

//declaration of interim wires:
wire PCSrcE, RegWriteW, RegWriteE, ALUSrcE,MemWriteE, ResultSrcE, BranchE;
wire [31:0]PCTargetE, InstrD,PCD, PCPlus4D, ResultW, RD1_E, RD2_E;
wire [4:0] RD_W, RD_E, RD_M;
wire RegWriteM, MemWriteM, ResultSrcM, ResultSrcW;
wire [2:0] ALUControlE;
wire [31:0] Imm_Ext_E, PCE, PCPlus4E, PCPlus4M, WriteDataM, ALU_ResultM, PCPlus4W, ALU_ResultW, ReadDataW;

//module initiation '
//fetch cycle:
fetch_cycle Fetch(.clk(clk), 
                   .rst(rst),
                   .PCSrcE(PCSrcE),
                   .PCTargetE(PCTargetE),
                   .PCD(PCD),
                    .InstrD(InstrD),
                    .PCPlus4D(PCPlus4D));

//decode cycle
decode_cycle Decode(.clk(clk),
                    .rst(rst),
                    .InstrD(InstrD),
                    .PCD(PCD),
                    .PCPlus4D(PCPlus4D),
                    .RegWriteW(RegWriteW), 
                    .RDW(RD_W),
                    .ResultW(ResultW), 
                    .RegWriteE(RegWriteE),
                    .ALUSrcE(ALUSrcE), 
                    .MemWriteE(MemWriteE),
                    .ResultSrcE(ResultSrcE),
                    .BranchE(BranchE),
                    .ALUControlE(ALUControlE),
                    .RD1_E(RD1_E),
                    .RD2_E(RD2_E),
                    .Imm_Ext_E(Imm_Ext_E),
                    .RD_E(RD_E), 
                    .PCE(PCE),
                    .PCPlus4E(PCPlus4E));

execute_cycle Execute(.clk(clk),
                      .rst(rst), 
                      .RegWriteE(RegWriteE),
                       .ALUSrcE(ALUSrcE), 
                       .MemWriteE(MemWriteE), 
                       .ResultSrcE(ResultSrcE), 
                       .BranchE(BranchE), 
                       .ALUControlE(ALUControlE), 
                       .RD1_E(RD1_E), 
                       .RD2_E(RD2_E), 
                       .Imm_Ext_E(Imm_Ext_E), 
                       .RD_E(RD_E), 
                       .PCE(PCE), 
                       .PCPlus4E(PCPlus4E), 
                       .PCTargetE(PCTargetE), 
                       .PCSrcE(PCSrcE), 
                       .RegWriteM(RegWriteM),
                       .MemWriteM(MemWriteM), 
                        .ResultSrcM(ResultSrcM),
                         .RD_M(RD_M), 
                         .PCPlus4M(PCPlus4M), 
                         .WriteDataM(WriteDataM), 
                         .ALUResultM(ALU_ResultM));

memory_cycle Memory(.clk(clk), 
                    .rst(rst),
                    .RegWriteM(RegWriteM),
                    .ResultSrcM(ResultSrcM),
                    .RD_M(RD_M),
                    .MemWriteM(MemWriteM), 
                    .PCPlus4M(PCPlus4M), 
                    .WriteDataM(WriteDataM),
                    .ALU_ResultM(ALU_ResultM),
                    .RegWriteW(RegWriteW),
                     .ResultSrcW(ResultSrcW),
                      .RD_W(RD_W),
                       .PCPlus4W(PCPlus4W), 
                       .ALU_ResultW(ALU_ResultW), 
                       .ReadDataW(ReadDataW) );

writeback_cycle Writeback(.clk(clk), 
                          .rst(rst), 
                          .ResultSrcW(ResultSrcW),
                         .PCPlus4W(PCPlus4W), 
                          .ALU_ResultW(ALU_ResultW),
                          .ReadDataW(ReadDataW),
                           .ResultW(ResultW));
endmodule
