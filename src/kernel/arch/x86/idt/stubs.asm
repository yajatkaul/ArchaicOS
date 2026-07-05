global divide_by_zero_stub
global invalid_opcode_stub
global general_protection_stub
global page_fault_stub

extern common_exception

section .text

; We push 8 bytes with error code and interrupt code in all
; Then common exception handles it and calls the appropriate call
divide_by_zero_stub:
    push dword 0            ; Pushes error code, in this case always 0
    push dword 0            ; Pushes interrupt number
    jmp common_exception

invalid_opcode_stub:
    push dword 0
    push dword 6
    jmp common_exception

general_protection_stub:
    push dword 13          ; CPU already pushed the error code
    jmp common_exception

page_fault_stub:
    push dword 14          ; CPU already pushed the error code
    jmp common_exception