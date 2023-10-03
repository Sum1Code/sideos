org 0x7c00

;
; SOME CODE SNIPPETS ARE SOURCED FROM https://github.com/nanobyte-dev/nanobyte_os.git
; FAT-12 header taken directly from nanobyte_os
; 
;
ENDL equ 0xA, 0xD, 0x0

jmp short main
nop 

db_oem:                    db 'MSWIN4.1'           ; 8 bytes
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


;   Put to Screen until 0 byte detected
;   param: Si: string
;
puts:
    push ax
    push bx
    push si

    mov ah,0xe  
    mov bh, 0  
    ploop:
        lodsb
        or al, al ; check if al = 0
        jz done    ; if it is jump to done
        int 0x10
        jmp ploop  ; if not loop back
    done:
        pop si
        pop bx
        pop ax
        ret

main:
    mov ax, 0
    mov ds, ax
    mov es, ax


    mov ax, 1       ; sectors start from 0, this means we are reading the second sector
    mov cl, 1       ; 1 sector to read
    mov dl, 0       ; disk num
    mov bx, 0x7e00 
    call read_disk

    mov si, 0x7e00
    call puts
_halt:
    cli
    hlt
;
;   SECTION DISK OPERATIONS
;

; LBA TO CHS TAKEN DIRECTLY FROM nanobyte_os 
;
; Converts an LBA address to a CHS address
; Parameters:
;   - ax: LBA address
; Returns:
;   - cx [bits 0-5]: sector number
;   - cx [bits 6-15]: cylinder
;   - dh: head
;
lba_to_chs:

    push ax
    push dx

    xor dx, dx                          ; dx = 0
    div word [bdb_sectors_per_track]    ; ax = LBA / SectorsPerTrack
                                        ; dx = LBA % SectorsPerTrack

    inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
    mov cx, dx                          ; cx = sector

    xor dx, dx                          ; dx = 0
    div word [bdb_heads]                ; ax = (LBA / SectorsPerTrack) / Heads = cylinder
                                        ; dx = (LBA / SectorsPerTrack) % Heads = head
    mov dh, dl                          ; dh = head
    mov ch, al                          ; ch = cylinder (lower 8 bits)
    shl ah, 6
    or cl, ah                           ; put upper 2 bits of cylinder in CL

    pop ax
    mov dl, al                          ; restore DL
    pop ax
    ret




;   read disk 
;   proc param:
;       - ax: LBA address           - cl: sectors to read 
;       - dl: drive num             - es:bx: where to load the read data
; 
;   INT 0x13,2 PARAMS (IGNORE THIS):
;       - al: sectors to read        - ch: cylinder number
;       - cl: sector number         - dh: head number
;       - dl: disk number           - es:bx: where to load read data
;   param_source: lba2chs
;
read_disk:
    push ax                             ; save registers we will modify
    push bx
    push cx
    push dx
    push di

    push si ; used for read attempts2

    push cx     ; save cl for lba2chs
    call lba_to_chs            
    pop ax 
    mov si, 3 ; read attempts
    mov ah, 0x2
    
    _rdmain:
    int 0x13
    jnc _rddone ; if succeeds then done 
    ; if not continue retry 

    ; error handling
    call disk_reset
    dec si
    test si, 0
    jnz _rdmain

    _rderr:
    mov si, msg_disk_err
    call puts
    jmp err_reboot

    _rddone:
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax                             
    ret


; RESET DISK CONTROLLER
; params:
; - dl: drive number
disk_reset:
    pusha
    mov ah, 0
    stc
    int 13h
    jc disk_reset_err
    popa
    ret
;
;   SECTION ERRORS
;
disk_reset_err:
    mov si, msg_disk_res_err
    call puts
    jmp err_reboot
    
err_reboot:
    mov si, msg_reboot
    call puts
    mov ah, 0
    int 0x16
    jmp 0x0FFFF:0 ;jump back to the very beginning, effectvely rebooting
    jmp _halt ; incase if something happens, the processor simply halts

;
;   SECTION STRINGS
;
msg_disk_err:       db 'Disk read attempts exhausted, failed to read after 3 tries', ENDL
msg_disk_res_err:   db 'Disk controller reset failure', ENDL
msg_reboot:         db 'Press any key to reboot', ENDL

times 510-($-$$) db 0
 dw 0xAA55

;
;   THE NEXT SECTOR OF THE DISK
;

 
