global common_exception

extern divide_by_zero
extern invalid_opcode
extern general_protection
extern page_fault

section .text

common_exception:
    pushad                                  ; Save all CPU data when handling interrupts

    mov eax, [esp+32]                       ; Interrupt number, when we push the interrupt number 
                                            ; in the stubs we put the value 32 bytes from esp, this just fetches it

    mov ebx, [exception_table + eax*4]      ; exception_table + EAX(interrupt number)*4(each is 4 bytes apart) = address of handler

    call ebx                                ; Call handler

    popad                                   ; Restore all CPU data when handling interrupts

    add esp, 8                              ; Remove error code + interrupt number
                                            ; When we go back we still have the Error code and Interrupt number
                                            ; in the stack so we move the stack by 8 bytes (4 and 4) to remove that data
                                            ; otherwise it does not get removed automatically with iret

    iret                                    ; Return from interrupt

section .data

exception_table:
    dd divide_by_zero       ; 0-4 bytes, 4 Bytes = 32 BITS
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd invalid_opcode
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd 0
    dd general_protection
    dd page_fault