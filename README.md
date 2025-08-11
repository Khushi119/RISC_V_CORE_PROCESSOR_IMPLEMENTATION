# HDL Implementation of RISC-V Processor Architecture

This project presents the HDL implementation of a single-cycle RISC-V processor architecture using Verilog on Xilinx Vivado. The design models the core functionalities of the RISC-V instruction set architecture, leveraging the modularity and precision of Verilog to describe and interconnect fundamental processor components such as the ALU, Control Unit, Register File, Program Counter, and memory modules. The RISC-V architecture, with its open-source and reduced instruction set design, enables efficient execution of instructions and flexibility for customization. Implementing it in Verilog ensures a hardware-accurate representation that can be simulated, debugged, and synthesized for FPGA deployment. Xilinx Vivado serves as the development environment, providing integrated tools for behavioral simulation, waveform analysis, and synthesis, thereby bridging theoretical ISA knowledge with practical hardware realization while developing industry-relevant digital design skills.

### Tools and Technologies ------->
---
- Verilog HDL : Programming Language
- Xilinx Vivado 2024.2 : Development Environment

### Introduction ------->
---
### Verilog HDL

Verilog is a Hardware Description Language (HDL) used to model, design, and verify digital circuits at various abstraction levels, from gate-level to register-transfer level (RTL). Unlike software languages that give instructions to a processor, Verilog describes the processor itself — defining how data moves between registers, how logic operates, and how timing is controlled. It is inherently parallel, matching the nature of hardware, where multiple operations occur simultaneously. Its syntax, inspired by C, makes it approachable while still capable of expressing low-level structural details. Verilog enables behavioral modeling for functional simulation, structural modeling for gate connections, and RTL modeling for practical hardware synthesis. It forms the bridge between a conceptual design and a physically implementable circuit, as synthesis tools like Xilinx Vivado can convert it directly into an FPGA or ASIC layout. Mastery of Verilog equips an engineer to not just write code, but to design hardware architectures, optimize performance, and control physical behavior at the clock-cycle level — skills at the heart of chip design and processor development.

### RISC-V Processor Architecture

RISC-V is an open-source Instruction Set Architecture (ISA) based on the Reduced Instruction Set Computer (RISC) philosophy, designed to be simple, modular, and extensible. Unlike proprietary ISAs, RISC-V is royalty-free, enabling anyone to design, modify, and implement processors without licensing restrictions. Its fixed-length, load/store instruction format simplifies decoding and hardware design, improving execution efficiency. The base integer set (RV32I, RV64I, etc.) can be extended with standardized modules for multiplication, floating-point, atomic operations, vector processing, or custom instructions. RISC-V follows a clean, orthogonal design where each instruction performs a single, well-defined task, allowing efficient pipelining and easier verification. Its open nature fosters innovation in academia, industry, and research, making it ideal for custom SoCs, embedded systems, and high-performance processors. By understanding and implementing RISC-V at the hardware level, an engineer gains direct insight into how an ISA translates into datapaths, control logic, and timing — the core of processor microarchitecture. This clarity and adaptability have made RISC-V one of the fastest-growing ISAs in modern computing.

![DRC Report Screenshot](https://github.com/Khushi119/RISC_V_CORE_PROCESSOR_IMPLEMENTATION/blob/72441cddb5affdb8a1a7adf5151b524e265c39b1/RISC%20Pipelined%20Architecture.png)

### RISC-V Processor Pipeline Stages

The RISC-V core processes each instruction through five fundamental stages—Instruction Fetch, Instruction Decode, Execute, Memory Access, and Write Back—arranged in a pipelined architecture. In pipelining, multiple instructions are processed simultaneously, with each stage handling a different instruction at any given clock cycle, significantly improving throughput compared to sequential execution.

Instruction Fetch (IF): The Program Counter (PC) generates the address of the next instruction, retrieved from Instruction Memory. The PC is updated either sequentially (PC+4) or with branch/jump targets, allowing the fetch stage to work ahead while previous instructions are still in later stages. These are instruction set formats used in RISC: 

![DRC Report Screenshot](https://github.com/Khushi119/RISC_V_CORE_PROCESSOR_IMPLEMENTATION/blob/096f1c03a2f11a99ebbb815b5ed62a8459440c6b/Fig%202_Instruction_set_architecture.png)

Instruction Decode (ID): The instruction is decoded and control signals are generated. Operand values are read from the Register File, and immediate values are sign-extended. As this happens, the fetch stage already retrieves the next instruction in parallel. The decoder interfaces with the Control Unit, which generates the necessary control signals by referencing the Main Decoder Logic Table, ensuring correct instruction execution flow in accordance with the RISC-V ISA.

![DRC Report Screenshot](https://github.com/Khushi119/RISC_V_CORE_PROCESSOR_IMPLEMENTATION/blob/ecb2b98b05815269ffbaaeccaf903692fe9ecefd/Fig%203_%20Main_Decoder_logic_table.png)

Execute (EX): The ALU performs arithmetic, logical, or address calculations, while also computing potential branch targets. Multiplexers select between register and immediate operands. Other instructions simultaneously proceed through their decode and fetch stages. Within the Execute stage, the ALU operation is determined by the ALU Decoder, which maps the instruction’s funct fields and control signals to specific arithmetic or logical operations as defined in the ALU Control Logic Table. 

![DRC Report Screenshot](https://github.com/Khushi119/RISC_V_CORE_PROCESSOR_IMPLEMENTATION/blob/4e2d2c753f41a29c31eea63f879cc286296b844d/Fig%204_ALU_Logic_Table.png)

![DRC Report Screenshot](https://github.com/Khushi119/RISC_V_CORE_PROCESSOR_IMPLEMENTATION/blob/4e2d2c753f41a29c31eea63f879cc286296b844d/Fig%205_ALU_Deocder_Logic_table.png)

Memory Access (MEM): Data memory is read or written depending on the instruction type, with the address taken from the ALU result. While this occurs, newer instructions are being executed and decoded in earlier pipeline stages.

Write Back (WB): The computed result—whether from the ALU, memory, or PC+4—is written into the destination register. By this point, four other instructions are already somewhere in the pipeline, ensuring a continuous flow of operations.

### RISC-V Pipeline Execution Results ------->
---

This README documents the results of executing a small RISC-V program on a 5-stage pipeline processor. The focus is on verifying correct register updates through the `RD_W` (destination register) and `ResultW` (computed value) signals in the write-back stage.

Program executes the following instructions:
The instructions are clearly visible in the InstrD of FETCH CYCLE GROUP

![DRC Report Screenshot](https://github.com/Khushi119/RISC_V_CORE_PROCESSOR_IMPLEMENTATION/blob/65b9a4d5ffb458f6e33da0bb6cc58e6355e44b98/Result_Image_2.png)

1. `ADDI x6, x0, 3` – Set x6 = 3
2. `ADDI x5, x0, 5` – Set x5 = 5
3. `LW x8, 0(x0)` – Load x8 from data memory address 0
4. `ADDI x9, x0, 1` – Set x9 = 1
5. `ADD x7, x5, x6` – Compute x7 = x5 + x6
6. `ADD x10, x8, x9` – Compute x10 = x8 + x9

Initial Register State:
x5 = 5 ; x6 = 4; x7 = 3; x8 = 7; x9 = 2; All others = 1 (except x0 = 0)

Expected Final Register State *(assuming data memory\[0] = 3)* :
x6 = 3  ; x5 = 5 ; x8 = 3; x9 = 1; x7 = 8; x10 = 4

### Verification in Simulation ------->

In the waveform or simulation output:
* **`RD_W`** displays the destination register number for the instruction in the write-back stage.
* **`ResultW`** displays the final computed value to be written to that register.

![DRC Report Screenshot](https://github.com/Khushi119/RISC_V_CORE_PROCESSOR_IMPLEMENTATION/blob/65b9a4d5ffb458f6e33da0bb6cc58e6355e44b98/Result%20_Image_3.png)

Monitoring these signals confirms correct execution and register file updates.

### Conclusion ------->
---
This project implements a RISC-V pipelined processor capable of executing instructions across multiple stages for improved throughput. The design successfully achieves correct instruction execution with higher efficiency compared to a single-cycle processor, and its modular architecture ensures clarity, scalability, and ease of debugging. While the current implementation meets the targeted functionality, further enhancements such as introducing data forwarding (bypassing) to reduce data hazards, implementing hazard detection and resolution techniques for control and structural hazards, and optimizing execution speed can make the pipeline hazard-free and elevate its performance to match real-world processor standards.

## Source Code
The complete project code is available below:  
- [All Modules](./All_Modules.v)  
- [FETCH CYCLE CODE](./FETCH_CYCLE_CODE.v)  
- [DECODE CYCLE CODE](./DECODE_CYCLE_CODE.v)  
- [EXECUTE CYCLE CODE](./EXECUTE_CYCLE_CODE.v)
- [MEMORY CYCLE CODE](./MEMORY_CYCLE_CODE.v)
- [WRITE BACK CYCLE CODE](./WRITE_BACK_CYCLE_CODE.v)
- [TOP MODULE CODE](./TOP_MODULE_CODE.v)
- [TESTBENCH MODULE CODE](./TESTBENCH_MODULE_CODE.v)
