package OES

fetched: u8         // Represents the working input value to the ALU
temp:u16            // A convenience variable used everywhere
addr_abs: u16       // All used memory addresses end up in here
addr_rel: u16       // Represents absolute address following a branch
opcode: u8          // Is the instruction byte
cycles: u8          // Counts how many cycles the instruction has remaining
clock_count: u32    // A global accumulation of the number of clocks


// Reads an 8-bit byte from the bus, located at the specified 16-bit memory address.
cpu_Read :: proc(addr: u16) -> u8 {
    return bus_Read(addr, false)
}


// Writes a byte to the bus at the specified memory address.
cpu_Write :: proc(addr: u16 ,data: u8) {
    bus_Write(addr, data)
}


// Set the CPU_FLAGS from the Status Register
cpu_SetFlag :: proc(flag: CPU_FLAGS, value: bool) {

}


// Get the CPU_FLAGS from the Status Register
cpu_GetFlag :: proc(flag: CPU_FLAGS) -> u16 {
    return 0 // TODO
}


// Perform one clock cycle's worth of update
cpu_clock :: proc() {
    
}


// Reset Interrupt - Forces CPU into known state
cpu_reset :: proc() {
    
}


// Interrupt Request - Executes an instruction at a specific location
cpu_irq :: proc() {
    
}


// Non-Maskable Interrupt Request - Executes an instruction at a specific location, 
//but cannot be disabled
cpu_nmi :: proc() {
    
}


cpu_fetch :: proc() -> u8 {
    return 0 // todo
}


/*  
    NVUB DIZC
    ││││ ││││
    ││││ │││╰─ Carry Bit
    ││││ ││╰── Zero
    ││││ │╰─── Disable Interrupts
    ││││ ╰──── Decimal Mode
    │││╰────── Break
    ││╰─────── Unused
    │╰──────── Overflow
    ╰───────── Negative
*/
CPU_FLAGS :: enum {
    // Every flag, was bitwised left shift (<<) n times, to correspond the table above
    C = 1 << 0, // Carry Bit
    Z = 1 << 1, // Zero
    I = 1 << 2, // Disable Interrupts
    D = 1 << 3, // Decimal Mode
    B = 1 << 4, // Break
    U = 1 << 5, // Unused
    V = 1 << 6, // Overflow
    N = 1 << 7, // Negative
}


// CPU registers
CPU_REGISTERS :: struct {
    A: u8,  // Accumulator Register
    X: u8,  // X Register
    Y: u8,  // Y Register
    SP: u8, // Stack Pointer
    PC: u16, // Program Counter
    S: u8,  // Status Register
}
register := CPU_REGISTERS{} //Initialize to Zero


// 6502 Addressing Modes - www.nesdev.org/obelisk-6502-guide/addressing.html
CPU_ADDR_MODE :: enum {
    Implied,
    Accumulator,
    Immediate,
    ZeroPage,
    ZeroPageX,
    ZeroPageY,
    Relative,
    Absolute,
    AbsoluteX,
    AbsoluteY,
    Indirect,
    IndirectX,
    IndirectY,
}

// 6502 Opcodes - www.nesdev.org/obelisk-6502-guide/instructions.html
CPU_OPCODES :: enum {
     ADC,   AND,  ASL,  BCC,
	 BCS,   BEQ,  BIT,  BMI,
	 BNE,   BPL,  BRK,  BVC,
	 BVS,   CLC,  CLD,  CLI,
	 CLV,   CMP,  CPX,  CPY,
	 DEC,   DEX,  DEY,  EOR,
	 INC,   INX,  INY,  JMP,
	 JSR,   LDA,  LDX,  LDY,
	 LSR,   NOP,  ORA,  PHA,
	 PHP,   PLA,  PLP,  ROL,
	 ROR,   RTI,  RTS,  SBC,
	 SEC,   SED,  SEI,  STA,
	 STX,   STY,  TAX,  TAY,
	 TSX,   TXA,  TXS,  TYA,
}

// Bruh
INSTRUCTION_SET :: struct {
    O: CPU_OPCODES,      // OP Code 
    A: CPU_ADDR_MODE,    // Addressing Mode 
    I: i8,               // Instruction Bytes 
    C: i8,               // Cycles
}
// Instruction Set
is := INSTRUCTION_SET{}
//0x00 = {CPU_OPCODES, CPU_ADDR_MODE, 0, 0},
// www.nesdev.org/obelisk-6502-guide/reference.html
// Instruction set OP code Matrix
OPMatrix := [256] INSTRUCTION_SET {
    0x69 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.Immediate, 2, 2},
    0x65 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x75 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0x6D = {CPU_OPCODES.ADC, CPU_ADDR_MODE.Absolute, 3, 4},
    0x7D = {CPU_OPCODES.ADC, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0x79 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0x61 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.IndirectX, 2, 6},
    0x71 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.IndirectX, 2, 5},

    0x29 = {CPU_OPCODES.AND, CPU_ADDR_MODE.Immediate, 2, 2},
    0x25 = {CPU_OPCODES.AND, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x35 = {CPU_OPCODES.AND, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0x2D = {CPU_OPCODES.AND, CPU_ADDR_MODE.Absolute, 3, 4},
    0x3D = {CPU_OPCODES.AND, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0x39 = {CPU_OPCODES.AND, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0x21 = {CPU_OPCODES.AND, CPU_ADDR_MODE.IndirectX, 2, 6},
    0x31 = {CPU_OPCODES.AND, CPU_ADDR_MODE.IndirectY, 2, 5},

    0x0A = {CPU_OPCODES.ASL, CPU_ADDR_MODE.Accumulator, 1, 2},
    0x06 = {CPU_OPCODES.ASL, CPU_ADDR_MODE.ZeroPage, 2, 5},
    0x16 = {CPU_OPCODES.ASL, CPU_ADDR_MODE.ZeroPageX, 2, 6},
    0x0E = {CPU_OPCODES.ASL, CPU_ADDR_MODE.Absolute, 3, 6},
    0x13 = {CPU_OPCODES.ASL, CPU_ADDR_MODE.AbsoluteX, 3, 7},

    0x90 = {CPU_OPCODES.BCC, CPU_ADDR_MODE.Relative, 2, 2},
    0xB0 = {CPU_OPCODES.BCS, CPU_ADDR_MODE.Relative, 2, 2},
    0xF0 = {CPU_OPCODES.BEQ, CPU_ADDR_MODE.Relative, 2, 2},
    0x30 = {CPU_OPCODES.BMI, CPU_ADDR_MODE.Relative, 2, 2},
    0xD0 = {CPU_OPCODES.BNE, CPU_ADDR_MODE.Relative, 2, 2},
    0x10 = {CPU_OPCODES.BPL, CPU_ADDR_MODE.Relative, 2, 2},
    0x50 = {CPU_OPCODES.BVC, CPU_ADDR_MODE.Relative, 2, 2},
    0x70 = {CPU_OPCODES.BVS, CPU_ADDR_MODE.Relative, 2, 2},

    0x24 = {CPU_OPCODES.BIT, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x26 = {CPU_OPCODES.BIT, CPU_ADDR_MODE.ZeroPage, 3, 4},

    0x00 = {CPU_OPCODES.BRK, CPU_ADDR_MODE.Implied, 1, 7},
    0x18 = {CPU_OPCODES.CLC, CPU_ADDR_MODE.Implied, 1, 2},  
    0xD8 = {CPU_OPCODES.CLD, CPU_ADDR_MODE.Implied, 1, 2},
    0x58 = {CPU_OPCODES.CLI, CPU_ADDR_MODE.Implied, 1, 2},
    0xB8 = {CPU_OPCODES.CLV, CPU_ADDR_MODE.Implied, 1, 2},

    0xC9 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.Immediate, 2, 2},
    0xC5 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xD5 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0xCD = {CPU_OPCODES.CMP, CPU_ADDR_MODE.Absolute, 3, 4},
    0xDD = {CPU_OPCODES.CMP, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0xD9 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0xC1 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.IndirectX, 2, 6},
    0xD1 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.IndirectY, 2, 5},

    0xE0 = {CPU_OPCODES.CPX, CPU_ADDR_MODE.Immediate, 2, 2},
    0xE4 = {CPU_OPCODES.CPX, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xEC = {CPU_OPCODES.CPX, CPU_ADDR_MODE.Absolute, 3, 4},

    0xC0 = {CPU_OPCODES.CPY, CPU_ADDR_MODE.Immediate, 2, 2},
    0xC4 = {CPU_OPCODES.CPY, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xCC = {CPU_OPCODES.CPY, CPU_ADDR_MODE.Absolute, 3, 4},

    0xC6 = {CPU_OPCODES.DEC, CPU_ADDR_MODE.ZeroPage, 2, 5},
    0xD6 = {CPU_OPCODES.DEC, CPU_ADDR_MODE.ZeroPageX, 2, 6},
    0xCE = {CPU_OPCODES.DEC, CPU_ADDR_MODE.Absolute, 3, 6},
    0xDE = {CPU_OPCODES.DEC, CPU_ADDR_MODE.AbsoluteX, 3, 7},
    
}



