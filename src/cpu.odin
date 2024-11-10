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
    Implicit,
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
    IndexedIndirect,
    IndirectIndexed
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

}

