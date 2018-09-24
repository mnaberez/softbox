; bell.asm

; PURPOSE:      To ring the bell

; EXTERNAL REFERENCES
        xref putchar_   ; system routine to write to screen

; EXTERNAL DEFINITION
        xdef bell

bell    equ *
        lda #$07        ; ASCII bell character
        jmp putchar_    ; print it to screen to ring bell
                        ; return is in putchar_.
