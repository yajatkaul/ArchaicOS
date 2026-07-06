global timer_stub
global keyboard_stub

extern common_irq

section .text

; Similar to idt stubs
timer_stub:
    push dword 0            ; IRQ number
    jmp common_irq

keyboard_stub:
    push dword 1
    jmp common_irq