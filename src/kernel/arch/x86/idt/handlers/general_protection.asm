global general_protection

extern print_string

section .text

; You break a CPU protection rule. Eg. Jump to an invalid code segment.
general_protection:
    mov esi, msg
    call print_string

    cli

.hang:
    hlt
    jmp .hang

section .rodata

msg:
    db "General Protection Fault!", 10, 0