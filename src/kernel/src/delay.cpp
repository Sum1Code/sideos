#include "delay.h"
#include "stdint.h"
#include "x86.h"

// volatile uint32_t timer_ticks = 0;
// uint32_t delay_ticks = 0;

// void init_timer(uint32_t freq) {
//   uint32_t divisor = 1193180 / freq;
//   x86_outb(0x43, 0x36);
//   x86_outb(0x40, divisor & 0xff);
//   x86_outb(0x40, (divisor >> 8) & 0xff);
// }

// void handle_timer(){
//   timer_ticks++;
//   if
// }

void sleep(uint32_t ms) {
  uint32_t timer = ms * 10000;
  while (timer > 0) {
    timer--;
  }
}
