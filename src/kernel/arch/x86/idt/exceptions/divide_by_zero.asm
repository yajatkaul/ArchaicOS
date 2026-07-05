global divide_by_zero

extern print_string

section .text

divide_by_zero:
    mov esi,msg
    call print_string

    cli                 ; Disable interrupts

.loop:
    hlt
    jmp .loop

section .rodata

msg:
    db "Divide By Zero!",10,0