[bits 32]

global kernel_start
extern print_string
extern clear_screen

section .text

kernel_start:
    mov esi, msg

    call clear_screen
    call print_string

.loop:
    jmp .loop                   ; Loop so it doesnt crash

section .rodata                 ; Read only

msg:
    db "Line 01", 10
    db "Line 02", 10
    db "Line 03", 10
    db "Line 04", 10
    db "Line 05", 10
    db "Line 06", 10
    db "Line 07", 10
    db "Line 08", 10
    db "Line 09", 10
    db "Line 10", 10
    db "Line 11", 10
    db "Line 12", 10
    db "Line 13", 10
    db "Line 14", 10
    db "Line 15", 10
    db "Line 16", 10
    db "Line 17", 10
    db "Line 18", 10
    db "Line 19", 10
    db "Line 20", 10
    db "Line 21", 10
    db "Line 22", 10
    db "Line 23", 10
    db "Line 24", 10
    db "Line 25", 0

times 512-($-$$) db 0