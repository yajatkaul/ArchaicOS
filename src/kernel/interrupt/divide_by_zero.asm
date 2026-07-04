[bits 32]

global load_divide_by_zero

extern idt_set_gate
extern print_string

section .text

divide_by_zero_handler:
    pushad

    mov esi, msg
    call print_string
    .hang:
        jmp .hang

load_divide_by_zero:
    mov eax, 0                      ; Interrupt Vector 0
    mov ebx, divide_by_zero_handler ; Handler Address
    mov cx, 0x08                    ; Code Segment
    mov dl, 10001110b               ; Flags

    call idt_set_gate

    ret
    
section .rodata                 ; Read only

msg:
    db "Divide By Zero!", 0