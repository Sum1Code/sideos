ASM=fasm

STG1SRC=src/stage1
STG2SRC=src/stage2
BUILDDIR=build
TRGT=$(BUILDDIR)/os.img
STAGE1=$(BUILDDIR)/stage1.bin
STAGE2=$(BUILDDIR)/stage2.bin
default:run

run: $(TRGT)
	qemu-system-i386 -fda $(TRGT)

debug: $(TRGT)
	bochs -f bohcsconf -q
bootloader: STAGE1 STAGE2


STAGE2: $(STAGE2)
$(STAGE2): $(STG2SRC)
	$(MAKE) -C $(STG2SRC) BUILDDIR=$(abspath $(BUILDDIR))

STAGE1: $(STAGE1) 

$(STAGE1): $(STG1SRC) init
	$(MAKE) -C $(STG1SRC) BUILDDIR=$(abspath $(BUILDDIR))

$(TRGT): bootloader
	dd if=/dev/zero of=$(TRGT) bs=512 count=2880
	mkfs.fat -F12 -n "RBOS" $(TRGT)
#cat $(STAGE2) >> $(STAGE1)
	dd if=$(STAGE1) of=$(TRGT) conv=notrunc
	mcopy -i $(TRGT) $(STAGE2) "::stage2.bin"

$(BUILDDIR)/boot.bin: $(SRCDIR)/boot.asm init 
	$(ASM) $< $@

init:
	mkdir -p build
clean:
	rm -rf build
