org 0x7c00

ENDL equ 0xA, 0xD, 0x0

jmp main

;   Put to Screen until 0 byte
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

    pusha
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0
    mov bx, 0x7e00
    call read_chs
    popa

    mov si, 0x7e00
    call puts
_halt:
    cli
    hlt
;
;   SECTION DISK OPERATIONS
;

;   read disk using chs addressing
;   params:
;       - al: sector to read        - ch: cylinder number
;       - cl: sector number         - dh: head number
;       - dl: disk number           - es:bx: where to load read data
read_chs:
    push si ; used for read attempts

    mov si, 3 ; read attempts
    mov ah, 2
    
    _rchsmain:
    int 0x13
    jnc _rchsdone ; if succeeds then done 
    ; if not continue retry 

    _rchsretry:
    call disk_reset
    dec si
    test si, 0
    jnz _rchsmain

    _rchserr:
    mov si, msg_disk_err
    call puts
    jmp err_reboot

    _rchsdone:
    pop si
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

db 'WE READ A STRING !!!!', ENDL
