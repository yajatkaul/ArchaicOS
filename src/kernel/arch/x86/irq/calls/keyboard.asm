[bits 32]

global keyboard_call

extern keyboard_handler

section .text

keyboard_call:
    call keyboard_handler

    ret