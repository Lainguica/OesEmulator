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
    0x00 = {CPU_OPCODES.BRK, CPU_ADDR_MODE.Implied, 1, 7},
    0x01 = {CPU_OPCODES.ORA, CPU_ADDR_MODE.IndirectX, 2, 6},
    0x05 = {CPU_OPCODES.ORA, CPU_ADDR_MODE.ZeroPage, 2, 2},
    0x06 = {CPU_OPCODES.ASL, CPU_ADDR_MODE.ZeroPage, 2, 5},
    0x08 = {CPU_OPCODES.PHP, CPU_ADDR_MODE.Implied, 1, 3},
    0x09 = {CPU_OPCODES.ORA, CPU_ADDR_MODE.Immediate, 2, 2},
    0x0A = {CPU_OPCODES.ASL, CPU_ADDR_MODE.Accumulator, 1, 2},
    0x0D = {CPU_OPCODES.ORA, CPU_ADDR_MODE.Absolute, 3, 4},
    0x0E = {CPU_OPCODES.ASL, CPU_ADDR_MODE.Absolute, 3, 6},
    0x10 = {CPU_OPCODES.BPL, CPU_ADDR_MODE.Relative, 2, 2},
    0x11 = {CPU_OPCODES.ORA, CPU_ADDR_MODE.IndirectY, 2, 5},
    0x13 = {CPU_OPCODES.ASL, CPU_ADDR_MODE.AbsoluteX, 3, 7},
    0x15 = {CPU_OPCODES.ORA, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0x16 = {CPU_OPCODES.ASL, CPU_ADDR_MODE.ZeroPageX, 2, 6},
    0x18 = {CPU_OPCODES.CLC, CPU_ADDR_MODE.Implied, 1, 2},  
    0x19 = {CPU_OPCODES.ORA, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0x1D = {CPU_OPCODES.ORA, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0x20 = {CPU_OPCODES.JSR, CPU_ADDR_MODE.Absolute, 3, 6},
    0x21 = {CPU_OPCODES.AND, CPU_ADDR_MODE.IndirectX, 2, 6},
    0x24 = {CPU_OPCODES.BIT, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x25 = {CPU_OPCODES.AND, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x26 = {CPU_OPCODES.ROL, CPU_ADDR_MODE.ZeroPage, 2, 5},
    0x28 = {CPU_OPCODES.PLP, CPU_ADDR_MODE.Implied, 1, 4},
    0x29 = {CPU_OPCODES.AND, CPU_ADDR_MODE.Immediate, 2, 2},
    0x2A = {CPU_OPCODES.ROL, CPU_ADDR_MODE.Accumulator, 1, 2},
    0x2C = {CPU_OPCODES.BIT, CPU_ADDR_MODE.ZeroPage, 3, 4},
    0x2D = {CPU_OPCODES.AND, CPU_ADDR_MODE.Absolute, 3, 4},
    0x2E = {CPU_OPCODES.ROL, CPU_ADDR_MODE.Absolute, 3, 6},
    0x30 = {CPU_OPCODES.BMI, CPU_ADDR_MODE.Relative, 2, 2},
    0x31 = {CPU_OPCODES.AND, CPU_ADDR_MODE.IndirectY, 2, 5},
    0x35 = {CPU_OPCODES.AND, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0x36 = {CPU_OPCODES.ROL, CPU_ADDR_MODE.ZeroPageX, 2, 6},
    0x38 = {CPU_OPCODES.SEC, CPU_ADDR_MODE.Implied, 1, 2},
    0x39 = {CPU_OPCODES.AND, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0x3D = {CPU_OPCODES.AND, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0x3E = {CPU_OPCODES.ROL, CPU_ADDR_MODE.AbsoluteX, 3, 7},
    0x40 = {CPU_OPCODES.RTI, CPU_ADDR_MODE.Implied, 1, 6},
    0x41 = {CPU_OPCODES.EOR, CPU_ADDR_MODE.IndirectX, 2, 6},
    0x45 = {CPU_OPCODES.EOR, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x46 = {CPU_OPCODES.LSR, CPU_ADDR_MODE.ZeroPage, 2, 5},
    0x48 = {CPU_OPCODES.PHA, CPU_ADDR_MODE.Implied, 1, 3},
    0x49 = {CPU_OPCODES.EOR, CPU_ADDR_MODE.Immediate, 2, 2},
    0x4A = {CPU_OPCODES.LSR, CPU_ADDR_MODE.Accumulator, 1, 2},
    0x4C = {CPU_OPCODES.JMP, CPU_ADDR_MODE.Absolute, 3, 3},
    0x4D = {CPU_OPCODES.EOR, CPU_ADDR_MODE.Absolute, 3, 4},
    0x4E = {CPU_OPCODES.LSR, CPU_ADDR_MODE.Absolute, 3, 6},
    0x50 = {CPU_OPCODES.BVC, CPU_ADDR_MODE.Relative, 2, 2},
    0x51 = {CPU_OPCODES.EOR, CPU_ADDR_MODE.IndirectY, 2, 5},
    0x55 = {CPU_OPCODES.EOR, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0x56 = {CPU_OPCODES.LSR, CPU_ADDR_MODE.ZeroPageX, 2, 6},
    0x58 = {CPU_OPCODES.CLI, CPU_ADDR_MODE.Implied, 1, 2},
    0x59 = {CPU_OPCODES.EOR, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0x5D = {CPU_OPCODES.EOR, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0x5E = {CPU_OPCODES.LSR, CPU_ADDR_MODE.AbsoluteX, 3, 7},
    0x60 = {CPU_OPCODES.RTS, CPU_ADDR_MODE.Implied, 1, 6},
    0x61 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.IndirectX, 2, 6},
    0x65 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x66 = {CPU_OPCODES.ROR, CPU_ADDR_MODE.ZeroPage, 2, 5},
    0x68 = {CPU_OPCODES.PLA, CPU_ADDR_MODE.Implied, 1, 4},
    0x69 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.Immediate, 2, 2},
    0x6A = {CPU_OPCODES.ROR, CPU_ADDR_MODE.Accumulator, 1, 2},
    0x6C = {CPU_OPCODES.JMP, CPU_ADDR_MODE.Indirect, 3, 5},
    0x6D = {CPU_OPCODES.ADC, CPU_ADDR_MODE.Absolute, 3, 4},
    0x6E = {CPU_OPCODES.ROR, CPU_ADDR_MODE.Absolute, 3, 6},
    0x70 = {CPU_OPCODES.BVS, CPU_ADDR_MODE.Relative, 2, 2},
    0x71 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.IndirectX, 2, 5},
    0x75 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0x76 = {CPU_OPCODES.ROR, CPU_ADDR_MODE.ZeroPageX, 2, 6},
    0x78 = {CPU_OPCODES.SEI, CPU_ADDR_MODE.Implied, 1, 2},
    0x79 = {CPU_OPCODES.ADC, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0x7D = {CPU_OPCODES.ADC, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0x7E = {CPU_OPCODES.ROR, CPU_ADDR_MODE.AbsoluteX, 3, 7},
    0x81 = {CPU_OPCODES.STA, CPU_ADDR_MODE.IndirectX, 2, 6},
    0x84 = {CPU_OPCODES.STY, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x85 = {CPU_OPCODES.STA, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x86 = {CPU_OPCODES.STX, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0x88 = {CPU_OPCODES.DEY, CPU_ADDR_MODE.Implied, 1, 2},
    0x8A = {CPU_OPCODES.TXA, CPU_ADDR_MODE.Implied, 1, 2},
    0x8C = {CPU_OPCODES.STY, CPU_ADDR_MODE.Absolute, 3, 4},
    0x8D = {CPU_OPCODES.STA, CPU_ADDR_MODE.Absolute, 3, 4},
    0x8E = {CPU_OPCODES.STX, CPU_ADDR_MODE.Absolute, 3, 4},
    0x90 = {CPU_OPCODES.BCC, CPU_ADDR_MODE.Relative, 2, 2},
    0x91 = {CPU_OPCODES.STA, CPU_ADDR_MODE.IndirectY, 2, 7},
    0x94 = {CPU_OPCODES.STY, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0x95 = {CPU_OPCODES.STA, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0x96 = {CPU_OPCODES.STX, CPU_ADDR_MODE.ZeroPageY, 2, 4},
    0x98 = {CPU_OPCODES.TYA, CPU_ADDR_MODE.Implied, 1, 2},
    0x99 = {CPU_OPCODES.STA, CPU_ADDR_MODE.AbsoluteY, 3, 5},
    0x9A = {CPU_OPCODES.TXS, CPU_ADDR_MODE.Implied, 1, 2},
    0x9D = {CPU_OPCODES.STA, CPU_ADDR_MODE.AbsoluteX, 3, 5},
    0xA0 = {CPU_OPCODES.LDY, CPU_ADDR_MODE.Immediate, 2, 2},
    0xA1 = {CPU_OPCODES.LDA, CPU_ADDR_MODE.IndirectX, 2, 6},
    0xA2 = {CPU_OPCODES.LDX, CPU_ADDR_MODE.Immediate, 2, 2},
    0xA4 = {CPU_OPCODES.LDY, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xA5 = {CPU_OPCODES.LDA, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xA6 = {CPU_OPCODES.LDX, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xA8 = {CPU_OPCODES.TAY, CPU_ADDR_MODE.Implied, 1, 2},
    0xA9 = {CPU_OPCODES.LDA, CPU_ADDR_MODE.Immediate, 2, 2},
    0xAA = {CPU_OPCODES.TAX, CPU_ADDR_MODE.Implied, 1, 2},
    0xAC = {CPU_OPCODES.LDY, CPU_ADDR_MODE.Absolute, 3, 4},
    0xAD = {CPU_OPCODES.LDA, CPU_ADDR_MODE.Absolute, 3, 4},
    0xAE = {CPU_OPCODES.LDX, CPU_ADDR_MODE.Absolute, 3, 4},
    0xB0 = {CPU_OPCODES.BCS, CPU_ADDR_MODE.Relative, 2, 2},
    0xB1 = {CPU_OPCODES.LDA, CPU_ADDR_MODE.IndirectY, 2, 5},
    0xB4 = {CPU_OPCODES.LDY, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0xB5 = {CPU_OPCODES.LDA, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0xB6 = {CPU_OPCODES.LDX, CPU_ADDR_MODE.ZeroPageY, 2, 4},
    0xB8 = {CPU_OPCODES.CLV, CPU_ADDR_MODE.Implied, 1, 2},
    0xB9 = {CPU_OPCODES.LDA, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0xBA = {CPU_OPCODES.TSX, CPU_ADDR_MODE.Implied, 1, 2},
    0xBC = {CPU_OPCODES.LDY, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0xBD = {CPU_OPCODES.LDA, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0xBE = {CPU_OPCODES.LDX, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0xC0 = {CPU_OPCODES.CPY, CPU_ADDR_MODE.Immediate, 2, 2},
    0xC1 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.IndirectX, 2, 6},
    0xC4 = {CPU_OPCODES.CPY, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xC5 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xC6 = {CPU_OPCODES.DEC, CPU_ADDR_MODE.ZeroPage, 2, 5},
    0xC8 = {CPU_OPCODES.INY, CPU_ADDR_MODE.Implied, 1, 2},
    0xC9 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.Immediate, 2, 2},
    0xCA = {CPU_OPCODES.DEX, CPU_ADDR_MODE.Implied, 1, 2},
    0xCC = {CPU_OPCODES.CPY, CPU_ADDR_MODE.Absolute, 3, 4},
    0xCD = {CPU_OPCODES.CMP, CPU_ADDR_MODE.Absolute, 3, 4},
    0xCE = {CPU_OPCODES.DEC, CPU_ADDR_MODE.Absolute, 3, 6},
    0xD0 = {CPU_OPCODES.BNE, CPU_ADDR_MODE.Relative, 2, 2},
    0xD1 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.IndirectY, 2, 5},
    0xD5 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0xD6 = {CPU_OPCODES.DEC, CPU_ADDR_MODE.ZeroPageX, 2, 6},
    0xD8 = {CPU_OPCODES.CLD, CPU_ADDR_MODE.Implied, 1, 2},
    0xD9 = {CPU_OPCODES.CMP, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0xDD = {CPU_OPCODES.CMP, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0xDE = {CPU_OPCODES.DEC, CPU_ADDR_MODE.AbsoluteX, 3, 7},
    0xE0 = {CPU_OPCODES.CPX, CPU_ADDR_MODE.Immediate, 2, 2},
    0xE1 = {CPU_OPCODES.SBC, CPU_ADDR_MODE.IndirectX, 2, 6},
    0xE4 = {CPU_OPCODES.CPX, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xE5 = {CPU_OPCODES.SBC, CPU_ADDR_MODE.ZeroPage, 2, 3},
    0xE6 = {CPU_OPCODES.INC, CPU_ADDR_MODE.ZeroPage, 2, 5},
    0xE8 = {CPU_OPCODES.INX, CPU_ADDR_MODE.Implied, 1, 2},
    0xE9 = {CPU_OPCODES.SBC, CPU_ADDR_MODE.Immediate, 2, 2},
    0xEA = {CPU_OPCODES.NOP, CPU_ADDR_MODE.Implied, 1, 2},
    0xEC = {CPU_OPCODES.CPX, CPU_ADDR_MODE.Absolute, 3, 4},
    0xED = {CPU_OPCODES.SBC, CPU_ADDR_MODE.Absolute, 3, 4},
    0xEE = {CPU_OPCODES.INC, CPU_ADDR_MODE.Absolute, 3, 6},
    0xF0 = {CPU_OPCODES.BEQ, CPU_ADDR_MODE.Relative, 2, 2},
    0xF1 = {CPU_OPCODES.SBC, CPU_ADDR_MODE.IndirectY, 2, 5},
    0xF5 = {CPU_OPCODES.SBC, CPU_ADDR_MODE.ZeroPageX, 2, 4},
    0xF6 = {CPU_OPCODES.INC, CPU_ADDR_MODE.ZeroPageX, 2, 6},
    0xF8 = {CPU_OPCODES.SED, CPU_ADDR_MODE.Implied, 1, 2},
    0xF9 = {CPU_OPCODES.SBC, CPU_ADDR_MODE.AbsoluteY, 3, 4},
    0xFD = {CPU_OPCODES.SBC, CPU_ADDR_MODE.AbsoluteX, 3, 4},
    0xFE = {CPU_OPCODES.INC, CPU_ADDR_MODE.AbsoluteY, 3, 7},



}



