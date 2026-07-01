print_string:
    push ax                 ; Save AX
    push si                 ; Save SI

    .loop:
        mov al, [si]            ; Put value of si in al

        cmp al, 0               ; Check if al is 0 meaning string finished
        je .done                ; If its equal to 0 then jump to done

        mov ah, 0x0E            ; If not equal then it moves 0x0E into ah that means teletype function for interrupt
        int 0x10                ; Call the interupt it takes values from al(value) and ah(function) 

        inc si                  ; Increment the value of si to the next bit
        jmp .loop               ; Loop again until the string ends(0)

    .done:
        pop si                  ; Restore SI
        pop ax                  ; Restore AX

        ret                     ; Once loop is finished return back