; Tells the CPU about the segments if they are valid and so on
gdt_start:

gdt_null:
    dq 0

; Code segment
gdt_code:
    dw 0xFFFF       ; Limit (low 16 bits)

    dw 0x0000       ; Base (low 16 bits)
    db 0x00         ; Base (middle 8 bits)

    ; Present(1), Privilege(2), Type(1), Exe(1), Conforming(1), Readable(1), Accessed(1) 
    db 10011010b    ; Access byte = 0x9A

    ; Above since limit is set to FFFF its 16 bits only
    ; We add 1111 = F making it 20 bits
    ; Upper 1100 - Granularity something to do with page sizing upto 4 gigs, (1), 32-bit protected mode(1), 64-bit mode(1), Available for OS use(1)
    db 11001111b    ; Flags + high 4 bits of limit = 0xCF, b just means binary

    db 0x00         ; Base (high 8 bits), 16+8+8=32 bits

; Data segment
gdt_data:
    dw 0xFFFF       ; Limit (low 16 bits)

    dw 0x0000       ; Base (low 16 bits)
    db 0x00         ; Base (middle 8 bits)

    ; Present(1), Privilege(2), Type(1), Exe(1), Conforming(1), Readable(1), Accessed(1) 
    db 10010010b

    ; Similar to code segment
    ; Granularity = 1 (4 kb pages), Size = 1 (32-bit), 64-bit mode = 0, Reserved = 0
    ; Upper Limit = 1111 = F making it 20 bits
    db 11001111b

    db 0x00         ; Base (high 8 bits), 16+8+8=32 bits

gdt_end:

; Limit(2 Bytes) + Base(4 Bytes)
gdt_descriptor:
    ; Size of the GDT in bytes minus one.
    ; The CPU expects the index of the last valid byte,
    ; not the total size.
    dw gdt_end - gdt_start - 1      ; Limit

    ; 32-bit address where the GDT begins.
    ; LGDT will load this into the GDTR register.
    dd gdt_start                    ; Base

; Offsets (selectors) of our descriptors within the GDT
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start