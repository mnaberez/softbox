; upper.asm

; PURPOSE:      To switch to upper case screen mode.

; VIA PERIPHERAL CHIP
        VIApcr equ $E84C        ; controls text or graphics mode

; EXTERNAL DEFINITION
        xdef upper

upper   equ *
        lda #$0e        ; POKE(59468,14)
        sta VIApcr      ; to set upper case
        rts
