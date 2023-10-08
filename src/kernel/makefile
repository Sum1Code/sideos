BUILDDIR?=build/
ASM?=nasm
GCC?=i386-elf-g++
CFLAGS?=-ffreestanding -m32 -ggdb -c -nostdlib -Iheaders -Wno-narrowing
LD?=i386-elf-ld

SRCS=$(wildcard src/*.cpp)
OBJS=$(patsubst src/%.cpp, $(BUILDDIR)/%.o, $(SRCS))
.PHONY: all clean

all: kernel

kernel: $(BUILDDIR)/kernel.bin

build: $(BUILDDIR)/kernel.bin

$(BUILDDIR)/kernel_entry.o: kernel_entry.asm
	$(ASM) -f elf -o $@ $<

$(BUILDDIR)/x86.o: x86.asm
	$(ASM) -f elf -o $@ $<

$(BUILDDIR)/%.o: src/%.cpp
	$(GCC) $(CFLAGS) $< -o $@

$(BUILDDIR)/kernel.bin: $(BUILDDIR)/kernel_entry.o $(BUILDDIR)/x86.o $(OBJS) 
	$(LD) -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

clean:
	rm -f $(BUILDDIR)/kernel.bin $(OBJS) $(BUILDDIR)/kernel_entry.o
