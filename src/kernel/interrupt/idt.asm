[bits 32]

global idt
global idt_descriptor
global idt_set_gate
global load_idt

IDT_ENTRIES    equ 256
IDT_ENTRY_SIZE equ 8

section .bss                           ; Uninitialized data

idt:
    resb IDT_ENTRIES * IDT_ENTRY_SIZE  ; Reserve bytes for 

section .text

idt_set_gate:
    push eax                    ; EAX = Interrupt Number
    push ebx                    ; EBX = Handler Address
    push ecx                    ; CX  = Code Segment Selector
    push edx                    ; DL  = Flags
    push edi

    ; Calculate address of this IDT entry
    shl eax, 3                  ; interrupt * 8, shift to multiply
    add eax, idt                ; resolve address since its interrupt * 8 bytes from idt address
    mov edi, eax                ; Store it

    ; Lower 16 bits of handler
    mov word [edi], bx          ; Byte 1-2

    ; Code segment selector
    mov word [edi + 2], cx      ; Byte 3-4

    ; Reserved byte
    mov byte [edi + 4], 0       ; Byte 5

    ; Flags
    mov byte [edi + 5], dl      ; Byte 6

    ; Upper 16 bits of handler
    mov eax, ebx
    shr eax, 16
    mov word [edi + 6], ax      ; Byte 7-8

    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

load_idt:
    lidt [idt_descriptor]

    ret

section .data

idt_descriptor:
    dw (IDT_ENTRIES * IDT_ENTRY_SIZE) - 1       ; Intel takes needs last bytes to be gangsta -> Limit
    dd idt                                      ; Fill last 4 bytes still idt address -> Base