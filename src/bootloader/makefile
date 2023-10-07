BUILDDIR?=build/
ASM?=nasm

.PHONY: all clean

all: bootloader
bootloader: $(BUILDDIR)/bootloader.bin

$(BUILDDIR)/bootloader.bin:
	$(ASM) -fbin boot.asm -o $@

clean:
	rm -f $(BUILD_DIR)/bootloader.bin