[bits 32]

global load_int

extern divide_by_zero_stub
extern invalid_opcode_stub
extern general_protection_stub
extern page_fault_stub

extern load_idt
extern idt_set_gate
extern load_irq

extern print_string

section .text

load_int:
    ; Kernel exception interrupts
    mov eax, 0                      ; Interrupt Vector 0
    mov ebx, divide_by_zero_stub    ; Handler Address
    mov cx, 0x08                    ; Code Segment
    mov dl, 10001110b               ; Flags
    call idt_set_gate

    mov eax, 6                      ; Interrupt Vector 6
    mov ebx, invalid_opcode_stub    ; Handler Address
    mov cx, 0x08                    ; Code Segment
    mov dl, 10001110b               ; Flags
    call idt_set_gate

    mov eax, 13                      
    mov ebx, general_protection_stub    
    mov cx, 0x08                  
    mov dl, 10001110b       
    call idt_set_gate

    mov eax, 14                    
    mov ebx, page_fault_stub    
    mov cx, 0x08                  
    mov dl, 10001110b         
    call idt_set_gate

    ; Hardware interrupts
    call load_irq

    call load_idt                   ; Loads idt address into CPU

    ret

section .rodata

msg:
    dw "Loaded interrupts!", 10, 0
