BUILDDIR?=build/
ASM?=fasm

.PHONY: all clean

all: stage2
stage2: $(BUILDDIR)/stage2.bin

$(BUILDDIR)/stage2.bin:
	$(ASM) main.asm $@

clean:
	rm -f $(BUILD_DIR)/stage2.bin