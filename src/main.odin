package OES
import rl "vendor:raylib"

// Default NES resolution
WINDOW_WIDTH :: 256
WINDOW_HEIGHT :: 240
windowScale: i32 = 3

main :: proc() {
    rl.InitWindow(WINDOW_WIDTH * windowScale, WINDOW_HEIGHT * windowScale, "OES Emulator")
    
    for !rl.WindowShouldClose(){
        rl.BeginDrawing()
        
        rl.ClearBackground(rl.WHITE)
        
        rl.EndDrawing()
    }

    bus_InitRam()
}
