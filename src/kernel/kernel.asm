[bits 32]

global kernel_start

extern print_string
extern clear_screen

extern load_int
extern pic_remap
extern pit_init

extern terminal_init
extern terminal_update

section .text

kernel_start:
    call load_int
    call pic_remap
    call pit_init

    sti                         ; Enable hardware interrupts again now

    ; Div by 0
    ; mov eax, 100
    ; xor ebx, ebx
    ; div ebx

    ; Invalid OP Code
    ; ud2

    ; Page fault
    ; mov eax, [0xFFFFFFFF]

    call terminal_init

    .loop:
        call terminal_update
        jmp .loop

section .rodata                 ; Read only

times 512-($-$$) db 0