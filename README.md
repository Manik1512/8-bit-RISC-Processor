# Custom 8-bit RISC Processor | Verilog

A custom 8-bit RISC processor built from the ground up in Verilog, featuring a 13-bit instruction set, a full datapath, a control unit, an 8×8 register file, instruction memory, and simulation-based verification in Xilinx Vivado.

---

## 1. Project Overview

This project designs a simple RISC-style processor starting from the instruction set architecture and working down to individual RTL modules, which are then integrated into a working CPU.

The processor operates on 8-bit data and supports eight core operations spanning arithmetic, logic, data movement, and shift instructions. Instructions live in instruction memory and are fetched sequentially by the program counter. Each fetched instruction is decoded to produce the register addresses, ALU operation, and control signals needed to execute it.

The full datapath was written as synthesizable Verilog RTL and verified through simulation in **Xilinx Vivado**.

---

## 2. Processor Specifications

| Parameter | Specification |
|---|---|
| Data width | 8 bits |
| Number of registers | 8 |
| Register width | 8 bits |
| Instruction width | 13 bits |
| Instruction memory | 256 × 13 bits = 416 Bytes |
| Register read ports | 2 |
| Register write ports | 1 |
| Opcode width | 3 bits |
| Addressing | Register-based |
| HDL | Verilog |
| Verification | Xilinx Vivado (simulation) |

---

## 3. Processor Architecture

The processor implements a straightforward fetch → decode → execute → write-back datapath:

```
PC → Instruction Memory → Instruction Decoder → Control Unit / Register File → ALU → Register File
```

The program counter holds the address of the instruction currently being executed. Instruction memory returns the 13-bit word at that address, which the instruction decoder splits into opcode, destination register, source registers, and shift direction.

The control unit reads the opcode and generates the ALU operation select, along with the register-write and PC-enable signals. The register file drives two operands into the ALU through its read ports; the ALU carries out the selected operation and the result flows back to the destination register through the write port.

---

## 4. Instruction Set Architecture

### 4.1 Instruction Format

All instructions are a fixed 13 bits wide:

```
12                                   0
+---------+------+-------+-------+---+
| Opcode  |  RD  |  RS1  |  RS2  | D |
+---------+------+-------+-------+---+
   3 bits   3       3       3      1
```

| Field | Width | Description |
|---|---:|---|
| Opcode | 3 bits | Operation to perform |
| RD | 3 bits | Destination register |
| RS1 | 3 bits | Source register 1 |
| RS2 | 3 bits | Source register 2 |
| D | 1 bit | Shift direction (SHIFT only) |

The 3-bit opcode field allows for eight distinct operations.

### 4.2 Register Organization

| Binary | Register |
|--------|----------|
| 000 | R0 |
| 001 | R1 |
| 010 | R2 |
| 011 | R3 |
| 100 | R4 |
| 101 | R5 |
| 110 | R6 |
| 111 | R7 |

### 4.3 Opcode Table

| Opcode | Instruction | Operation |
|---|---|---|
| 000 | ADD | RD ← RS1 + RS2 |
| 001 | SUB | RD ← RS1 − RS2 |
| 010 | AND | RD ← RS1 & RS2 |
| 011 | OR | RD ← RS1 \| RS2 |
| 100 | XOR | RD ← RS1 ^ RS2 |
| 101 | MOV | RD ← RS1 |
| 110 | SHIFT | Shift RS1 according to D |
| 111 | *reserved* | Reserved for future use |

### 4.4 Shift Direction (D)

The D bit only applies to SHIFT instructions:

| D | Operation |
|---|---|
| 0 | Logical left shift |
| 1 | Logical right shift |

### 4.5 Instruction Definitions

**ADD**
```
ADD RD, RS1, RS2
RD ← RS1 + RS2
```

**SUB**
```
SUB RD, RS1, RS2
RD ← RS1 - RS2
```

**AND**
```
AND RD, RS1, RS2
RD ← RS1 & RS2
```

**OR**
```
OR RD, RS1, RS2
RD ← RS1 | RS2
```

**XOR**
```
XOR RD, RS1, RS2
RD ← RS1 ^ RS2
```

**MOV**
```
MOV RD, RS1
RD ← RS1
```
The source register is left unchanged — MOV only copies its value into RD.

**SHIFT**
```
SHIFT RD, RS1
```
- If D = 0: `RD ← RS1 << 1`
- If D = 1: `RD ← RS1 >> 1`

**Reserved (opcode 111)**

Opcode `111` is set aside for future extensions such as NOP, HALT, INC, DEC, or NOT.

---

## 5. RTL Implementation

The processor is split into independent RTL modules, integrated at the top-level CPU.

### 5.1 Program Counter
Holds the address of the current instruction. It resets to zero, and increments each cycle the enable signal is asserted to fetch the next instruction.

### 5.2 Instruction Memory
Stores the processor's 13-bit instruction words:

```
PC → Instruction Memory → Instruction
```

Implemented as a 256-entry array, addressable directly by the 8-bit program counter.

### 5.3 Instruction Decoder
Splits the fetched 13-bit instruction into its component fields — opcode, destination register, source register 1, source register 2, and direction — and distributes them to the control unit, register file, and ALU.

### 5.4 Control Unit
Takes the 3-bit opcode from the decoder and produces the control signals that drive the rest of the datapath:
- ALU operation select
- Register write enable
- Program counter enable

In effect, the control unit decides how the datapath reacts to whatever instruction is currently active.

### 5.5 Register File
Eight 8-bit general-purpose registers (R0–R7), with:
- Two combinational read ports
- One synchronous write port

The two source-register fields select the ALU's operands; the destination-register field picks where the ALU's result lands when the write-enable signal is high.

### 5.6 Arithmetic Logic Unit (ALU)
Executes whichever operation the control unit selects:
- Addition
- Subtraction
- AND
- OR
- XOR
- MOV
- Left shift
- Right shift

Takes two 8-bit operands plus the ALU operation and shift direction, and produces an 8-bit result.

---

## 6. CPU Integration

The individual modules connect together at the top level as follows:

- PC → Instruction Memory
- Instruction Memory → Instruction Decoder
- Instruction Decoder → Control Unit
- Instruction Decoder → Register File
- Register File → ALU
- Control Unit → ALU
- ALU → Register File

The ALU's result is routed back to the register file and written into the destination register whenever the register-write control signal is asserted.

---

## 7. Simulation & Verification (Vivado)

### 7.1 Objective

Program-level simulation checks the CPU's modules working together, rather than testing each RTL block in isolation. A sequence of instructions is loaded into instruction memory and run through the full datapath, exercising instruction fetch, decode, register access, ALU execution, and write-back end to end.

### 7.2 Test Configuration

Registers are pre-loaded with known values so results are deterministic:

| Register | Initial Value |
|---|---:|
| R2 | 10 |
| R3 | 5 |
| R4 | 20 |

### 7.3 Test Program

| PC | Instruction | Expected Result |
|---:|---|---|
| 0 | ADD R1, R2, R3 | R1 = 15 |
| 1 | SUB R5, R4, R3 | R5 = 15 |
| 2 | AND R6, R1, R2 | R6 = 10 |
| 3 | OR R7, R2, R3 | R7 = 15 |
| 4 | XOR R0, R1, R3 | R0 = 10 |

### 7.4 Instruction Encoding

| PC | Instruction | Binary Encoding |
|---:|---|---|
| 0 | ADD R1, R2, R3 | 000 001 010 011 0 |
| 1 | SUB R5, R4, R3 | 001 101 100 011 0 |
| 2 | AND R6, R1, R2 | 010 110 001 010 0 |
| 3 | OR R7, R2, R3 | 011 111 010 011 0 |
| 4 | XOR R0, R1, R3 | 100 000 001 011 0 |

### 7.5 Simulation Flow (Vivado)

The testbench in Vivado:

1. Generates the processor clock.
2. Applies the reset signal.
3. Pre-loads the required register values.
4. Loads the encoded instructions into instruction memory.
5. Runs the processor for the needed number of clock cycles.
6. Captures waveform output for signal-level analysis via Vivado's simulator (XSim).

### 7.6 Signals Observed

- Program Counter
- Instruction
- Opcode
- Destination Register
- Source Register 1 / Source Register 2
- Direction
- ALU Operation
- ALU Operands
- ALU Result
- Register Write Enable
- Register Values

These let each instruction be traced across the entire datapath.

### 7.7 Example Trace

For the first instruction, `ADD R1, R2, R3`, with R2 = 10 and R3 = 5:

- The register file supplies both operands to the ALU.
- The control unit selects the ADD operation.
- The ALU computes R1 = 10 + 5 = 15.
- The result is written back to R1 once the register-write signal goes high.

The remaining instructions are verified the same way against their expected values.

### 7.8 Waveform Verification

Expected pipeline of activity:

```
Instruction Fetch → Instruction Decode → Register Read → ALU Execution → Register Write-Back
```


### 7.9 Result

The program-level simulation confirms the processor's modules integrate correctly, with correct instruction sequencing, control-signal generation, operand selection, ALU execution, and register write-back all verified in Vivado.

---

## Version History

**v1.0**
- 8-bit architecture finalized
- 8 general-purpose registers
- 13-bit instruction format defined
- ALU instruction set finalized
- Shift direction bit introduced
