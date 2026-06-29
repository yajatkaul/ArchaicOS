[org 0x7C00]                    ; Boot start
[bits 16]                       ; 16 bit instructions to be genned

start:
    mov ax, 0                   ; Initialize all the registers
    mov ds, ax                  
    mov es, ax                  
    mov ss, ax                  
    mov sp, 0x7C00              

    mov si, message             ; Move message data into si register

    call print_string           ; Call the print function

hang:                           ; Loop so it doesnt crash since rest of the code is empty
    jmp hang

print_string:
    .loop:
        mov al,[si]             ; Move si into al register (what char to print)

        cmp al,0                ; Check if al == 0

        je .done                ; If its equal jump to .done function

        mov ah,0x0E             ; Tell it to Print on the start of the boot loader with 0x0E
        int 0x10                ; Call the interrupt which takes al and ah in this case

        inc si                  ; Increment si to the next bit so from 'H' to 'e'

        jmp .loop               ; Call loop again (recursion)

    .done:
        ret                     ; If it reached 0 then just return back

message:
    db "Hello World!",0         ; Stores all bytes after db into until it hits 0 (null terminator)

times 510-($-$$) db 0           ; To ensure 512 bytes since last 2 bytes need to be 55 AA (endianness)
dw 0xAA55