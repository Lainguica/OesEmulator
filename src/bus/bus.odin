package bus
import cpu "../cpu"
import fmt "core:fmt"

ram: [64]u8

write :: proc(addr: u16 ,data: u8) {
    if addr >= 0x0000 && addr <= 0xFFFF{
        ram[addr] = data
    }
}

read :: proc(addr: u16, readOnly: b8) -> u8 {
    if addr >= 0x0000 && addr <= 0xFFFF{
        return ram[addr]
    }
} 

}

initRam :: proc() {
    // Set RAM to zero
    for i in ram {
        ram[i] = 0x00
        fmt.println(ram[i])
    }
}