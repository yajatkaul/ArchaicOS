[bits 32]

global keyboard_handler

section .bss

last_scancode:                      ; Store last key pressed
    resb 1

section .text

keyboard_handler:
    in al, 0x60                     ; Stores code put on 0x60 PORT by the keyboard into al

    mov [last_scancode], al         ; Update last scaned code

    ret