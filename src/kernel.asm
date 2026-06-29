[org 0]                         ; When we jumped from bootloader into kernal the offset is 0 since its a different sector
[bits 16]

kernel_start:
    mov ax, cs                  ; Cant copy from one segment reg to another
    mov ds, ax                  ; Make sure to update the ds with the cs so it gets the correct address for message, since we are in a differnt segment now from bootloader

    mov ah, 0x0E                ; Good ol teletype interrupt this is the same we are still in the bios
    mov si, message
    call print_string

.loop:
    jmp .loop                   ; Loop so it doesnt crash

message:
    db "OK!",0 

%include "src/print.asm"

times 512-($-$$) db 0