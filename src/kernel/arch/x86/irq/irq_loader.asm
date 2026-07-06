[bits 32]

global load_irq

extern idt_set_gate

extern timer_stub
extern keyboard_stub

section .text

; Similar to iloader.asm
load_irq:
    mov eax, 32                 ; Interrupt Vector
    mov ebx, timer_stub         ; Handler Address
    mov cx, 0x08                ; Code Segment
    mov dl, 10001110b           ; Interrupt Gate
    call idt_set_gate

    mov eax, 33
    mov ebx, keyboard_stub
    mov cx, 0x08
    mov dl, 10001110b
    call idt_set_gate

    ret