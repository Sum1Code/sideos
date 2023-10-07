BUILDDIR?=build/
ASM?=nasm
GCC?=i386-elf-g++
CFLAGS?=-ffreestanding -m32 -g -c -nostdlib -Iheaders
LD?=i386-elf-ld

SRCS=$(wildcard *.cpp)
OBJS=$(patsubst %.cpp, $(BUILDDIR)/%.o, $(SRCS))
.PHONY: all clean

all: kernel

kernel: $(BUILDDIR)/kernel.bin
	$(LD) -m elf_i386 -o $@ -Ttext 0x1000 $(BUILDDIR)/kernel_entry.o $(OBJS) --oformat binary

build: $(BUILDDIR)/kernel.bin

$(BUILDDIR)/kernel_entry.o: kernel_entry.asm
	$(ASM) -f elf -o $@ $<

$(BUILDDIR)/%.o: %.cpp
	$(GCC) $(CFLAGS) $< -o $@

$(BUILDDIR)/kernel.bin: $(BUILDDIR)/kernel_entry.o $(OBJS)
	$(LD) -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

clean:
	rm -f $(BUILDDIR)/kernel.bin $(OBJS) $(BUILDDIR)/kernel_entry.o
