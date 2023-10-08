#include "stdio.h"
#include "delay.h"
#include "memloc.h"
#include "vga.h"

int16_t screenX, screenY;

void putc(char c) {
  switch (c) {
  case '\n':
    screenX = 0;
    screenY++;
    break;
  default:
    vga_putc(screenX, screenY, DEFAULT_COLOR, c);
    screenX++;
    break;
  }

  if (screenX > SCREEN_BUFFER_WIDTH) {
    screenX = 0;
    screenY++;
  }
  if (screenY > SCREEN_BUFFER_HEIGHT) {
    vga_scroll(1, &screenY);
  }
}

void puts(const char *str) {
  for (char *ptr = (char *)str; *ptr != '\0'; ptr++) {
    putc(*ptr);
  }
}
