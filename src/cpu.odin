package OES

// Reads an 8-bit byte from the bus, located at the specified 16-bit memory address.
cpu_Read :: proc(addr: u16) -> u8 {
    return bus_Read(addr, false)
}

// Writes a byte to the bus at the specified memory address.
cpu_Write :: proc(addr: u16 ,data: u8) {
    bus_Write(addr, data)
}
