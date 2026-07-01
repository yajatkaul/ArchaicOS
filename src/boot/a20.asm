; Allows the system to go above 1mb limit(backwards compatiblity), Address 20
enable_a20:
    mov ax, 0x2401                  ; AX = AH, AL. So here we put AH=24 and AL=01
    int 0x15                        ; Then we call the interrupt to enable A20

    jc .failed                      ; Jump if carry flag is 1, meaning if interrupt 0x15 failed it puts 1 in the carry flag

    ret

.failed:
    mov si, a20_failed_msg
    call print_string
    jmp $
