[bits 16]

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

msg_disk_err:       db 'Disk read attempts exhausted, failed to read after 3 tries', ENDL
msg_disk_res_err:   db 'Disk controller reset failure', ENDL
msg_reboot:         db 'Press any key to reboot', ENDL