[org 0x7C00]                    ; Bootloader starts here
[bits 16]                       ; Tell instructions are supposed to be 16 bits cuz of bios

start:
    cli                         ; Disable interrupts

    xor ax, ax                  ; Initialize every register with 0 dont trust BIOS
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00              ; Move stack pointer to 0x7C00

    mov [boot_drive], dl        ; Bios puts the boot drive location into dl at start

    mov si, message             ; Load message string into si register
    call print_string

    call load_kernel

    jmp 0x1000:0x0000

hang:
    jmp hang                    ; Loop so it doesnt go below where there is no code which can crash

message:
    db "Hello World!",0         ; Message you want to print

boot_drive:
    db 0                        ; Stores the address of the boot drive (usb, ssd)

%include "src/print.asm"
%include "src/disk.asm"

times 510-($-$$) db 0           ; Make it exactly 512 for boot sector to load
dw 0xAA55                       ; Make sure it ends with 55 AA so it knows this sector is bootable