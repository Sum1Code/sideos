//========KERNEL.cpp========
// the kernel itself
//

#include "delay.h"
#include "stdio.h"

extern "C" void main() {
  for (int i = 0; i < 500; i++) {
    puts("COEMS!\n");
    sleep(1000);
  }
}
