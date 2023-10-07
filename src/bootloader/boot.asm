[org 0x7c00]
[bits 16]
;
; SOME CODE SNIPPETS ARE SOURCED FROM https://github.com/nanobyte-dev/nanobyte_os.git
; FAT-12 header taken directly from nanobyte_os
; 
;
%define ENDL 0xA, 0xD, 0x0

jmp main
nop 

bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0F0h                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h   ; serial number, value doesn't matter
ebr_volume_label:           db 'NANOBYTE OS'        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '           ; 8 bytes

KERNEL_LOC equ 0x1000

%include "puts.asm"
%include "disk.asm"
%include "errors.asm"


_halt:
    cli
    hlt
main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov [ebr_drive_number], dl

    mov ax, 1       ; sectors start from 0, this means we are reading the second sector
    mov cl, 40      ; 1 sector to read
    mov dl, 0       ; disk num
    mov bx, KERNEL_LOC 
    call read_disk

    ;switch text mode

    mov ah, 0x0
    mov al, 0x3
    int 0x10


%include "gdt.asm"
[bits 32]
start_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000   ;stack pointer base
    mov esp, ebp       ; set stack 

    jmp KERNEL_LOC
;
;   SECTION DISK OPERATIONS
;



;
;   SECTION STRINGS
;


times 510-($-$$) db 0
 dw 0xAA55

;
;   THE NEXT SECTOR OF THE DISK
;
