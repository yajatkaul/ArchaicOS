[bits 32]

global load_int

extern load_divide_by_zero
extern load_idt
extern print_string

section .text

load_int:
    push esi

    call load_divide_by_zero
    call load_idt

    mov esi, msg
    call print_string

    pop esi
    ret

section .rodata

msg:
    dw "Loaded interrupts!", 10, 0
