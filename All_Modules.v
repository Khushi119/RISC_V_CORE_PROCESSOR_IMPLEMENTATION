//ALL MODULES :
//mux module ------------------------------------------------------------------------------------------------------------
module Mux (a,b,s,c);
    input [31:0]a,b;
    input s;
    output [31:0]c;
    assign c = (s==1'b0) ? a : b ;
endmodule
// module PC--------------------------------------------------------------------------------------------------------
module PC_Module(clk,rst,PC,PC_Next);
    input clk,rst;
    input [31:0]PC_Next;
    output [31:0]PC;
    reg [31:0]PC;

    always @(posedge clk or posedge rst)
    begin
        if(rst==1'b1)
            PC <= {32{1'b0}};
        else
            PC <= PC_Next;
    end
endmodule

//instruction memory module--------------------------------------------------------------------------------------------
module Instruction_Memory (
    input rst,
    input [31:0] A,
    output [31:0] RD
);

    reg [31:0] mem [0:1023];

    assign RD = (rst == 1'b1) ? 32'b0 : mem[A[31:2]];
    integer i;
    initial begin 
        mem[0] = 32'h00300313; // x6=3
        mem[1] = 32'h00500293; // x5=5
        mem[2] = 32'h00002403; // x8=0
        mem[3] = 32'h00100493; // x9=1
        mem[4] = 32'h006283B3;// x7=8
        mem[5] = 32'h00940533; // x10=1
        // Fill the rest with NOP (addi x0, x0, 0)
        for (i = 6; i < 1024; i = i + 1) begin
            mem[i] = 32'h00000013; // NOP
        end
    end

endmodule



//pc adder--------------------------------------------------------------------------------------------------------
module PC_Adder (a,b,c);
    input [31:0]a,b;
    output [31:0]c;
    assign c = a + b;  
endmodule

// module control unit--------------------------------------------------------------------------------------------------
module Control_Unit_Top(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,funct3,funct7,ALUControl);

    input [6:0]Op,funct7;
    input [2:0]funct3;
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch;
    output [1:0]ImmSrc;
    output [2:0]ALUControl;

    wire [1:0]ALUOp;

    Main_Decoder Main_Decoder(
                .Op(Op),
                .RegWrite(RegWrite),
                .ImmSrc(ImmSrc),
                .MemWrite(MemWrite),
                .ResultSrc(ResultSrc),
                .Branch(Branch),
                .ALUSrc(ALUSrc),
                .ALUOp(ALUOp)
    );

    ALU_Decoder ALU_Decoder(
                            .ALUOp(ALUOp),
                            .funct3(funct3),
                            .funct7(funct7),
                            .op(Op),
                            .ALUControl(ALUControl)
    );

endmodule

//module register file---------------------------------------------------------------------------------------------
module Register_File(clk,rst,WE3,WD3,A1,A2,A3,RD1,RD2);

    input clk,rst,WE3;
    input [4:0]A1,A2,A3;
    input [31:0]WD3;
    output [31:0]RD1,RD2;

    reg [31:0] Register [31:0];

    always @ (posedge clk)
    begin
        if (WE3 && A3 != 5'd0)
begin
            Register[A3] <= WD3;
    end 
    else begin Register[A3]<=32'b0;
     end
end
    assign RD1 = (rst==1'b1) ? 32'd0 : Register[A1];
    assign RD2 = (rst==1'b1) ? 32'd0 : Register[A2];
integer i;
    initial begin
    
          for (i = 1; i < 32; i = i + 1) begin
          Register[i] = 32'd1; end
        Register[5] = 32'h00000005;
        Register[6] = 32'h00000004;
        Register[7] = 32'h00000003;
        Register[8]=32'd7;
        Register[9] = 32'h00000002; end 
endmodule

//module sign extender----------------------------------------------------------------------------
module Sign_Extend (In,Imm_Ext,ImmSrc);

    input [31:0]In;
    input ImmSrc;
    output [31:0]Imm_Ext;

    assign Imm_Ext = (ImmSrc == 1'b1) ? ({{20{In[31]}},In[31:25],In[11:7]}):
                                        {{20{In[31]}},In[31:20]};
endmodule

//module ALU---------------------------------------------------------------------------------------------
module ALU(A,B,Result,ALUControl,OverFlow,Carry,Zero,Negative);

    input [31:0]A,B;
    input [2:0]ALUControl;
    output Carry,OverFlow,Zero,Negative;
    output [31:0]Result;

    wire Cout;
    wire [31:0]Sum;

    assign Sum = (ALUControl[0] == 1'b0) ? A + B :
                                          (A + ((~B)+1)) ;
    assign {Cout,Result} = (ALUControl == 3'b000) ? Sum :
                           (ALUControl == 3'b001) ? Sum :
                           (ALUControl == 3'b010) ? A & B :
                           (ALUControl == 3'b011) ? A | B :
                           (ALUControl == 3'b101) ? {{32{1'b0}},(Sum[31])} :
                           {33{1'b0}};
    assign OverFlow = ((Sum[31] ^ A[31]) & 
                      (~(ALUControl[0] ^ B[31] ^ A[31])) &
                      (~ALUControl[1]));
    assign Carry = ((~ALUControl[1]) & Cout);
    assign Zero = &(~Result);
    assign Negative = Result[31];
endmodule

//module data memory------------------------------------------------------------------------------------
module Data_Memory(clk, rst, WE, WD, A, RD);
    input clk, rst, WE;
    input [31:0] A, WD;
    output reg [31:0] RD;

    reg [31:0] mem [1023:0];

    always @(posedge clk) begin
        if (WE)
            mem[A[11:2]] <= WD;
        else  RD =(rst==1'b1)? 32'b0: mem[A[11:2]];
    end

    integer i;
initial begin
    for (i = 0; i < 1024; i = i + 1)
        mem[i] = 32'd0;
    mem[28] = 32'h00000020; // Optional
end

endmodule


//main Decoder---------------------------------------------------------------------------------------
module Main_Decoder(Op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUOp);
    input [6:0]Op;
    output RegWrite,ALUSrc,MemWrite,ResultSrc,Branch;
    output [1:0]ImmSrc,ALUOp;

    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0110011 | Op == 7'b0010011) ? 1'b1 : 1'b0;

    assign ImmSrc = (Op == 7'b0100011) ? 2'b01 : 
                    (Op == 7'b1100011) ? 2'b10 :    
                                         2'b00 ;
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011) ? 1'b1 : 1'b0 ;

    assign MemWrite = (Op == 7'b0100011) ? 1'b1 :
                                           1'b0 ;
    assign ResultSrc = (Op == 7'b0000011) ? 1'b1 :
                                            1'b0 ;
    assign Branch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ;
    assign ALUOp = (Op == 7'b0110011) ? 2'b10 :
                   (Op == 7'b1100011) ? 2'b01 :
                    (Op == 7'b0010011) ? 2'b11 :  // I-type ALU
                                        2'b00 ;
endmodule

//ALU Decoder------------------------------------------------------------------------------------pahle wala
module ALU_Decoder(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] op,             // Add this input to match your original design
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000; // For load/store: ADD
        2'b01: ALUControl = 4'b0001; // For BEQ: SUB
        2'b10: begin // R-type
            case ({funct7, funct3})
                10'b0000000000: ALUControl = 4'b0000; // ADD
                10'b0100000000: ALUControl = 4'b0001; // SUB
                10'b0000000111: ALUControl = 4'b0010; // AND
                10'b0000000110: ALUControl = 4'b0011; // OR
                default:        ALUControl = 4'b1111; // Invalid
            endcase
        end
        2'b11: begin // I-type ALU (e.g., addi)
            case (funct3)
                3'b000: ALUControl = 4'b0000; // ADDI
                3'b111: ALUControl = 4'b0010; // ANDI
                3'b110: ALUControl = 4'b0011; // ORI
                default: ALUControl = 4'b1111;
            endcase
        end
        default: ALUControl = 4'b1111;
    endcase
end

endmodule
