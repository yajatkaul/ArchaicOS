[org 0x10000]                         ; When we jumped from bootloader into kernal the offset is 0 since its a different sector, this is just an offset not location
[bits 32]

kernel_start:
    mov esi, msg
    call print_string

.loop:
    jmp .loop                   ; Loop so it doesnt crash

msg:
    db "Xarotri", 0

%include "src/kernel/vga.asm"

times 512-($-$$) db 0