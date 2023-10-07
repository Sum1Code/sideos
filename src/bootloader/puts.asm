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

