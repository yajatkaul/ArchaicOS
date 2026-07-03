[bits 32]

global kernel_start
extern print_string

section .text

kernel_start:
    mov esi, msg
    call print_string

.loop:
    jmp .loop                   ; Loop so it doesnt crash

section .rodata                 ; Read only

msg:
    db "Xarotrisa", 0


times 512-($-$$) db 0