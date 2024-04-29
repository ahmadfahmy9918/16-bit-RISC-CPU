# 16-bit-RISC-CPU
## **Abstract**

## **Introduction**


## **Specifications**
 The outlined design features were as follows:
 
* A 32-bit external data bus, 16-bit instruction bus, and 8-bit data memory bus. The 16-bit memory address enables 256B of instruction memory whereas the custom-made data memory supports 1KB.
* Two visible 32-bit working registers (A and B) used to store operands and results of data computation.
* A Load/Store, Harvard-based architecture, wherein, all data computations are performed in the working registers and consisting of separate instruction and data storage units.
* Multi-cycle instructions along with a simple instruction set. 

### Instruction Set Architecture 
[insert instruction format fig here]

Fig. 1. Instruction Format

Table I. Mnemonic Instruction Set Architecture 
[insert table 1 here]

The instruction set's architecture is streamlined, with each instruction encompassing a 32-bit length and occupying a 4-byte memory space. In direct addressing mode, the lower 16 bits can denote either a memory address or a constant value, while only the 8 least significant bits are employed for memory addressing during data storage and retrieval operations. Instructions not involved in memory addressing are dedicated to data manipulation and program flow control, conforming to one of two depicted format structures in Figure 1. The processor's instruction set, outlined in Table 1, enumerates instructions through mnemonic representation and structural configuration. The operation type is indicated by the instruction's most significant 4 bits (IR [31…28]), which discern addressing or data processing operations—the latter identified by an OpCode of "0111". Within instructions, the bits IR [15…0] define the precise value for the operation, such as embedding a 16-bit constant into the upper half of register A during a 'Load Upper Immediate' (LUI) operation. Immediate (IMM) operations like 'Load Immediate' (LDAI) and 'Add Immediate' (ADDI) directly propagate their value to the target registers and signals, as exemplified by the execution of LDAI resulting in the assignment A <= IR [15…0].

### Register Set
[insert figs. 2 and 3 here here]

Fig. 2. System Registers

The processor is equipped with several registers that facilitate a variety of operations, some of which are available for user access, while others fulfill internal operational needs. The user-accessible registers are delineated in Figure 2. Registers A and B are designated as 32-bit working registers for executing data processing tasks. Registers C and Z are 1-bit status registers that signal 'Carry' and 'Zero' conditions, respectively—these are generally utilized in branch operations. Registers not visible to the user are dedicated to internal functions, as depicted in Figure 2. Among these, the PC (Program Counter) is pivotal during instruction execution, pinpointing the address for the subsequent instruction. The IR (Instruction Register) is tasked with storing instructions and decoding them for execution.

### Instruction Execution
[insert Instruction Execution ASM (state) chart here]

Fig. 4. Instruction Execution ASM (state) chart

[insert Data mem enable states ASM chart here]

Fig. 5. Data mem enable states ASM chart

The processor operates using a state machine, cyclically executing each instruction from its set, with each instruction's completion spread across three distinct clock cycles, designated as T0, T1, and T2 phases, shown in fig. 4. These cycles are intricately associated with a series of operations as detailed below:

* T0: Instruction Fetch 1 - During this initial phase, the state machine retrieves the address of the forthcoming instruction from the Program Counter (PC). The PC's current value, which points to the next instruction, is then moved to the Instruction Register (IR).
* T1: Instruction Fetch 2 and Memory Preparation - The state machine progresses the PC, aligning it with the subsequent instruction, and primes the memory for access. This preparation phase is critical for ensuring data is ready for the ensuing operations:
  * For operations like LDA/LDB, control signals are activated to initiate data transfer from memory to the A/B registers, preparing for the information to be captured in T2.
  * For STA/STB operations, the write-enable and other control signals, along with the multiplexer settings, are asserted to configure the system for the data's storage by the end of T2.
 
It is essential during this phase that the PC is also advanced in tandem with the memory's pre-decoding process, aligning with the state machine's sequential nature. Further details and nuances regarding the data memory enable states are outlined in Fig. 5.
* T2: Instruction Decode and Execution - At this juncture, the instruction previously fetched is deciphered by inspecting its content within the IR. The IR's uppermost bits (IR[31..28]) and the immediate data bits (IR[15..0]) guide the state machine in identifying the operation's nature—whether it involves addressing or data processing. Execution is enacted in this phase, with operations like LDA/LDB and STA/STB being actualized. Specifically, for memory storage operations, the system ensures that multiplexer signals remain active for the precise duration to achieve correct data storage.

This sequence of operations within the state machine is perpetually iterative, ensuring continuous processing and execution of instructions.

## **Design**


## **Results**


## **Conclusion**

