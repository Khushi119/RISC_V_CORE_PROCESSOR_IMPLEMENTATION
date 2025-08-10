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

# RISC-V Processor Pipeline Stages

The RISC-V core processes each instruction through five fundamental stages—Instruction Fetch, Instruction Decode, Execute, Memory Access, and Write Back—arranged in a pipelined architecture. In pipelining, multiple instructions are processed simultaneously, with each stage handling a different instruction at any given clock cycle, significantly improving throughput compared to sequential execution.

Instruction Fetch (IF): The Program Counter (PC) generates the address of the next instruction, retrieved from Instruction Memory. The PC is updated either sequentially (PC+4) or with branch/jump targets, allowing the fetch stage to work ahead while previous instructions are still in later stages.

Instruction Decode (ID): The instruction is decoded and control signals are generated. Operand values are read from the Register File, and immediate values are sign-extended. As this happens, the fetch stage already retrieves the next instruction in parallel.

Execute (EX): The ALU performs arithmetic, logical, or address calculations, while also computing potential branch targets. Multiplexers select between register and immediate operands. Other instructions simultaneously proceed through their decode and fetch stages.

Memory Access (MEM): Data memory is read or written depending on the instruction type, with the address taken from the ALU result. While this occurs, newer instructions are being executed and decoded in earlier pipeline stages.

Write Back (WB): The computed result—whether from the ALU, memory, or PC+4—is written into the destination register. By this point, four other instructions are already somewhere in the pipeline, ensuring a continuous flow of operations.
