; graphics.asm

; PURPOSE:      To set PET screen to graphics mode.  Removes spaces
;               from between lines.  Operation is not understood!!

; VIA PERIPHERAL CHIP
        VIApcr equ $E84C        ; controls text or graphics mode

; EXTERNAL REFERENCES
        xref putchar_           ; system routine to write to screen

; EXTERNAL DEFINITION
        xdef graphics

graphics  equ *
          lda VIApcr      ; Get contents of control register
          pha             ; and save.
          lda #$8e        ; Print CHR$(142)
          jsr putchar_    ; to the screen for graphics mode.
          pla             ; Retrieve control register contents
          sta VIApcr      ; and poke back to register.
          rts
