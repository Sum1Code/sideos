#include "stdint.h"
#include "memloc.h"
#include "vga.h"

extern "C" void main(){
    ScreenBuffer buff = {0xb8000};
    Writer screen = {.Buffer = &buff, .colmn_pos = 0, .color_code=get_color_code(Black, Yellow)};
    screen._write_string((uint8_t*)"Hello, world!");
    
}