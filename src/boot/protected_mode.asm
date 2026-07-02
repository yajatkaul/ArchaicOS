enter_protected_mode:
    cli
    ; Tell the CPU where the GDT is
    lgdt [gdt_descriptor]


    ; Copies all the settings from CR0 to EAX 
    ; EAX since CR is a 32 bit reg
    mov eax, cr0

    ; Set bit 0 (PE = Protection Enable).
    ; OR with 1 changes only bit 0 while
    ; leaving every other bit unchanged.
    or eax, 1

    ; Write EAX back into CR0, Protection Mode is not enabled
    mov cr0, eax

    ; Far jump into our 32-bit code segment, this reloads CS with CODE_SEG
    ; flushes the CPU's instruction queue, and begins executing using the
    ; descriptor stored in the GDT
    jmp CODE_SEG:protected_mode

[bits 32]
protected_mode:
    ; Load every segment register with
    ; our data segment selector
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Create a brand new 32-bit stack
    ; Above the bootloader (0x7C00)
    ; Above the kernel (0x10000)
    ; Below 1 MB
    mov esp, 0x90000

    mov eax, 0x10000
    jmp eax