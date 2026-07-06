global timer_handler
global ticks

extern print_string

section .bss

ticks:
    resd 1

section .text

timer_handler:
    inc dword [ticks]           ; Keeps incrementing ticks ever time timer int is called

    ret