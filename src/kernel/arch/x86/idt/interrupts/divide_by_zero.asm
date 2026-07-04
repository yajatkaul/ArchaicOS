[bits 32]

global load_divide_by_zero

extern idt_set_gate
extern print_string

section .text

divide_by_zero_handler:
    pushad                          ; Save all regs during interrupt

    mov esi, msg
    call print_string

    popad                           ; Restore all regs during interrupt

    cli                             ; Disables further maskable interrupts

    .halt:
        hlt
        jmp .halt

load_divide_by_zero:
    mov eax, 0                      ; Interrupt Vector 0
    mov ebx, divide_by_zero_handler ; Handler Address
    mov cx, 0x08                    ; Code Segment
    mov dl, 10001110b               ; Flags

    call idt_set_gate

    ret
    
section .rodata                 ; Read only

msg:
    db "Divide By Zero!", 10, 0