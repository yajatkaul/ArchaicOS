[bits 32]

global load_int

extern load_divide_by_zero
extern load_idt

section .text

load_int:
    call load_divide_by_zero
    call load_idt

    ret