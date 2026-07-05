global invalid_opcode

extern print_string

section .text

; The CPU sees an instruction it doesnt understand
invalid_opcode:
    mov esi, msg
    call print_string

    cli
.hang:
    hlt
    jmp .hang

section .rodata

msg:
    db "Invalid Opcode!", 10, 0