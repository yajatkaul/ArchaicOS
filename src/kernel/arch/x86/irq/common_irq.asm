global common_irq

extern timer_handler
extern keyboard_handler

section .text

; Similar to common_exception.asm
common_irq:
    pushad

    mov eax, [esp+32]

    mov ebx, [irq_table + eax*4]

    call ebx

    popad

    add esp, 4                          ; 4 not 8 because IRQ's dont send things like error code like CPU Ints

    mov al, 0x20                        ; Master PIC's Command Port
    out 0x20, al                        ; End Of Interrupt, tells that the interrupt has finsihed to the PIC

    iret

irq_table:
    dd timer_handler
    dd keyboard_handler