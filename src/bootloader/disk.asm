[bits 16]


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