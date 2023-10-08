ASM=nasm

BOOTLOADERSRC=src/bootloader
BUILDDIR=build
TRGT=target/os.img
BOOTLOADER=$(BUILDDIR)/bootloader.bin
#CFLAGS=-ffreestanding -m32 -g -c 
#export CFLAGS

KERNELSRC=src/kernel
KERNEL=$(BUILDDIR)/kernel.bin

default:run

run: $(TRGT)
	qemu-system-i386 -fda $(TRGT) -m 128m  

debug: $(TRGT)
	qemu-system-i386 -fda $(TRGT) -m 5m -s -S 


bootloader:  $(BOOTLOADERSRC) init
	$(MAKE) -C $(BOOTLOADERSRC) BUILDDIR=$(abspath $(BUILDDIR))

kernel: $(KERNELSRC)
	$(MAKE) -C $(KERNELSRC) BUILDDIR=$(abspath $(BUILDDIR)) 

$(TRGT): bootloader kernel
	dd if=/dev/zero of=$(TRGT) bs=512 count=2880
	mkfs.fat -F12 -n "RBOS" $(TRGT)
	cat "$(BOOTLOADER)" "$(KERNEL)" > $(BUILDDIR)/os.bin
	dd if=$(BUILDDIR)/os.bin of=$(TRGT) conv=notrunc


init:
	mkdir -p build target
clean:
	rm -rf build target
