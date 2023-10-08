#pragma once

//===========VGA.h============
// contains graphics directive
//============================

#include "memloc.h"
#include "stdint.h"

const int32_t DEFAULT_COLOR = 0x7;
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
typedef int32_t colorMode;

void vga_putc(int16_t x, int16_t y, colorMode color, uint8_t chr);
void vga_scroll(int32_t lines, int16_t *screenY);
uint8_t get_color(Color fg, Color bg);
