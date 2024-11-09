package OES
import fmt "core:fmt"

ram: [64]u8

bus_Read :: proc(addr: u16, readOnly: bool) -> u8 {
    if addr >= 0x0000 && addr <= 0xFFFF {
        return ram[addr]
    } 
    else {
        return 0x00
    }
} 

bus_Write :: proc(addr: u16 ,data: u8) {
    if addr >= 0x0000 && addr <= 0xFFFF {
        ram[addr] = data
    }
}

bus_InitRam :: proc() {
    // Set RAM to zero.
    for i in ram {
        ram[i] = 0x00
    }
}