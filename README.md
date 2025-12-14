# Single-Cycle ARMv8-Style Processor

This repository contains a single-cycle ARMv8-style processor implemented in Verilog, along with a self-checking testbench and memory models. The design implements a meaningful subset of the ARMv8 instruction set and demonstrates full datapath and control integration, including instruction fetch, decode, execute, memory access, and writeback in a single cycle.

---

## Features

- 64-bit single-cycle datapath  
- Opcode-driven control unit  
- Register file with ARMv8 XZR semantics  
- ALU with Zero flag support for conditional branches  
- Immediate generation for multiple ARMv8 formats  
- Instruction and data memory models  
- Self-checking testbench with waveform generation  

---

## Supported Instruction Subset

The processor supports the following ARMv8 instructions:

### Arithmetic / Logical
- `ADD`, `SUB`
- `AND`, `ORR`

### Immediate Operations
- `ADD (immediate)`
- `SUB (immediate)`
- `MOVZ` (with LSL 0/16/32/48)

### Memory
- `LDUR`
- `STUR`

### Control Flow
- `B`
- `CBZ`

This subset is sufficient to execute non-trivial programs involving loops, masking, memory access, and constant construction.

---

## Module Overview

### `singlecycle`

Top-level processor module that integrates all datapath components:
- Instruction fetch  
- Decode and control  
- ALU execution  
- Memory access  
- Writeback  
- Program counter update  

---

### `control`

Opcode-based control unit that generates:
- Register file control signals  
- ALU control signals  
- Memory read/write enables  
- Branch and unconditional branch signals  
- Immediate selection signals  

---

### `ALU`

64-bit arithmetic logic unit supporting:
- `AND`, `ORR`, `ADD`, `SUB`
- Pass-through operation for `CBZ`
- Zero flag generation  

---

### `RegisterFile`

- 32 registers × 64 bits  
- Register 31 behaves as `XZR` (always reads as zero, writes ignored)  
- Synchronous write, combinational read  

---

### `SignExtender`

Generates 64-bit immediates for:
- I-type  
- D-type  
- B-type  
- CB-type  
- `MOVZ` (half-word shifting)  

---

### `InstructionMemory`

- Read-only instruction memory  
- Encodes test programs directly in Verilog  
- Includes example programs exercising the full instruction subset  

---

### `DataMemory`

- Byte-addressable data memory  
- Supports aligned 64-bit loads and stores  
- Big-endian layout  
- Initialized with test data for validation  

---

### `NextPClogic`

Handles program counter updates for:
- Sequential execution (`PC + 4`)  
- Conditional branches (`CBZ`)  
- Unconditional branches (`B`)  

---

## Testbench

### `SingleCycleProcTest_v`

- Executes real ARMv8 instruction sequences  
- Uses a watchdog timer to detect infinite loops  
- Automatically checks results and reports pass/fail status  
- Generates a `.vcd` waveform file for debugging  

**Example validated behaviors:**
- Loop execution using `CBZ` and `B`
- Constant construction using `MOVZ`
- Correct load/store behavior
- ALU correctness across operations

Waveforms are dumped to `singlecycle.vcd` and can be viewed with tools like **GTKWave**.

---

## Running the Simulation

### Requirements
- Icarus Verilog (`iverilog`, `vvp`) or equivalent Verilog simulator

### Compile
```bash
iverilog -g2012 -o processor *.v
```
Run
```bash
vvp processor
```
View Waveforms (optional)
```bash
gtkwave singlecycle.vcd
```

---

Design Notes
- This is a single-cycle design: all instructions complete in one clock cycle.
- No pipelining, forwarding, or hazard handling is implemented.
- The design prioritizes clarity and correctness over performance.
- Intended for simulation and architectural understanding, not synthesis.

---

Educational Purpose

This project demonstrates:
- CPU datapath construction
- Control signal generation
- Instruction decoding
- Hardware-software interface concepts
- RTL simulation and debugging

It serves as a foundation for more advanced designs such as multi-cycle or pipelined processors.
