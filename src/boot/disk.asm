; We call this to put that 512 bytes of kernal into the ram
load_kernel:
    mov ax, 0x1000                  ; We want to put the kernal at this loc
    mov es, ax                      ; Put ax val in es since special regs dont accept immediate values (only reg to reg)

    mov bx, 0                       ; Address for bx, physical address is es:bx

    mov ah, 0x02                    ; Function you are calling 0x02 that is read sector in this case
    ; TODO this is supposed to be dynamic
    mov al, 0x04                    ; This tells how many sectors we want to read here it is just 4

    ; Older BIOS used CHS(Cylinder, Head, Sector)
    ; A cylinder is a set of tracks at the same radius across all platters.
    ; A head selects which platter surface to read.
    ; A sector is a small slice of a track.
    mov ch, 0                       ; Cylinder
    mov cl, 2                       ; Sector is 2 since 1 is for bootloader
    mov dh, 0                       ; Head

    mov dl, [boot_drive]            ; Put boot drive number into dl, boot_drive was set in boot.asm

    int 0x13                        ; Call the interrupt since all registers have been filled with details to call the read sector
                                    ; Read 1 sector from Cylinder 0, Head 0, Sector 2 of the drive in DL, and copy it to memory at 0x10000.
                                    ; After interrupt is called it clears/sets the Carry Flag if 0 then success if 1 then Failed

    jc disk_error                   ; Jump if carry (if carry flag is 1), so if it failed call disk_error function that prints the error message

    ret

disk_error:
    mov si, disk_error_msg
    call print_string
    jmp $                           ; Loop so it doesnt crash and you can see the error

disk_error_msg:
    db "Disk Error!", 0