#pragma once

#include "stdint.h"
#include "memloc.h"
enum Color {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    Pink = 13,
    Yellow = 14,
    White = 15,
};

typedef uint8_t ColorCode;

typedef struct{
    uint8_t ASCIICHAR;
    uint8_t colorcode;
} ScreenChar;

typedef struct{
    ScreenChar chars[SCREEN_BUFFER_HEIGHT][SCREEN_BUFFER_WIDTH];
} ScreenBuffer;

typedef struct{
    uint8_t colmn_pos;
    ColorCode color_code;
    ScreenBuffer* Buffer;

    void _write_byte(uint8_t byte){
        switch (byte)
        {
        case '\n':
            newline();
            break;
        
        default:
            uint8_t row = SCREEN_BUFFER_HEIGHT - 1;
            uint8_t col = colmn_pos;
            ColorCode colorcd = color_code;
            Buffer->chars[row][col] = ScreenChar {.ASCIICHAR=byte, .colorcode=colorcd};
            colmn_pos += 1;
            break;
        }
    }

        void _write_string(uint8_t* str) {
            for (uint8_t* byte = str; *byte != '\0'; byte++) {
                if ((*byte >= 0x20 && *byte <= 0x7e) || *byte == '\n') {
                    _write_byte(*byte);
                } else {
                    _write_byte(0xfe);
                }
    }
}
    void newline(){
        
    }
} Writer;

ColorCode get_color_code(Color bg, Color fg){
    return bg << 4 | fg;
}
