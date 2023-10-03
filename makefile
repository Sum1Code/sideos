ASM=fasm

SRCDIR=src
BUILDDIR=build
TRGT=$(BUILDDIR)/boot.img

default:$(TRGT)

$(TRGT): $(BUILDDIR)/boot.bin
	dd if=/dev/zero of=$(TRGT) bs=512 count=1880
	dd if=$< of=$(TRGT) conv=notrunc

$(BUILDDIR)/boot.bin: $(SRCDIR)/boot.asm init 
	$(ASM) $< $@

init:
	mkdir -p build
clean:
	rm -rf build