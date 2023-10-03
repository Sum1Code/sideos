BUILDDIR?=build/
ASM?=fasm

.PHONY: all clean

all: stage1
stage1: $(BUILDDIR)/stage1.bin

$(BUILDDIR)/stage1.bin:
	$(ASM) boot.asm $@

clean:
	rm -f $(BUILD_DIR)/stage1.bin