package OES

// Reads an 8-bit byte from the bus, located at the specified 16-bit memory address.
cpu_Read :: proc(addr: u16) -> u8 {
    return bus_Read(addr, false)
}

// Writes a byte to the bus at the specified memory address.
cpu_Write :: proc(addr: u16 ,data: u8) {
    bus_Write(addr, data)
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