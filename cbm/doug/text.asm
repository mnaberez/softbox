; text.asm

; PURPOSE:      To set PET screen to text mode.  Leaves spaces
;               between lines.  Operation is not understood!!

; VIA PERIPHERAL CHIP
        VIApcr equ $E84C        ; controls text or graphics mode

; EXTERNAL REFERENCES
        xref putchar_           ; system routine to write to screen

; EXTERNAL DEFINITION
        xdef text

text    equ *
        lda VIApcr      ; Get contents of control register
        pha             ; and save.
        lda #$0e        ; Print CHR$(14)
        jsr putchar_    ; to the screen for text mode.
        pla             ; Retrieve control register contents
        sta VIApcr      ; and poke back to register.
        rts
