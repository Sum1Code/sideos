BUILDDIR?=build/
ASM?=nasm
GCC?=i386-elf-g++
CFLAGS?=-ffreestanding -m32 -g -c -nostdlib
LD?=i386-elf-ld


.PHONY: all clean

all: kernel
kernel: build
	

build: $(BUILDDIR)/kernel.bin
$(BUILDDIR)/kernel.bin:
	$(ASM) -felf kernel_entry.asm -o $(BUILDDIR)/kernel_entry.o
	$(GCC) $(CFLAGS) kernel.cpp -o $(BUILDDIR)/kernel.o
	$(LD) -m elf_i386 -o $(BUILDDIR)/kernel.bin -Ttext 0x1000 $(BUILDDIR)/kernel_entry.o $(BUILDDIR)/kernel.o --oformat binary
#
clean:
	rm -f $(BUILD_DIR)/kernel.bin $(BUILD_DIR)/kernel.o $(BUILD_DIR)/kernel_entry.o