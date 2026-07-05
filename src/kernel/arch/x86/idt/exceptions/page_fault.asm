global page_fault

extern print_string

section .text

; The CPU cannot translate a virtual address to physical memory.
page_fault:
    mov esi, msg
    call print_string

    cli

.hang:
    hlt
    jmp .hang

section .rodata

msg:
    db "Page Fault!", 10, 0