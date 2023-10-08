#include "vga.h"
#include "memloc.h"
#include "stdint.h"

uint8_t *screenbuf = (uint8_t *)SCREEN_BUFFER_START;

uint8_t get_color(Color fg, Color bg) { return bg << 4 | fg; }
void vga_putc(int16_t x, int16_t y, colorMode color, uint8_t chr) {
  screenbuf[2 * (y * SCREEN_BUFFER_WIDTH + x)] = chr;
  screenbuf[2 * (y * SCREEN_BUFFER_WIDTH + x) + 1] = color;
};
char vga_readc(int16_t x, int16_t y, colorMode *out_color) {
  colorMode readcolor = screenbuf[2 * (y * SCREEN_BUFFER_WIDTH + x) + 1];
  *out_color = readcolor;
  return screenbuf[2 * (y * SCREEN_BUFFER_WIDTH + x)];
}

void vga_scroll(int32_t lines, int16_t *screenY) {
  colorMode text_color;
  char chr;
  for (int32_t row = lines; row < SCREEN_BUFFER_HEIGHT; row++) {
    for (int32_t colmn = 0; colmn < SCREEN_BUFFER_WIDTH; colmn++) {
      chr = vga_readc(row, colmn, &text_color);
      vga_putc(row, colmn, text_color, chr);
    }
  }

  for (int y = SCREEN_BUFFER_HEIGHT - lines; y < SCREEN_BUFFER_HEIGHT; y++)
    for (int x = 0; x < SCREEN_BUFFER_WIDTH; x++) {
      vga_putc(x, y, DEFAULT_COLOR, '\0');
    }
  *screenY = 0;
}
