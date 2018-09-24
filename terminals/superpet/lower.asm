; lower.asm

; PURPOSE:      To switch to lower case screen mode.

; VIA PERIPHERAL CHIP
        VIApcr equ $E84C        ; controls text or graphics mode

; EXTERNAL DEFINITION
        xdef lower

lower   equ *
        lda #$0c        ; POKE(59468,12)
        sta VIApcr      ; to set lower case
        rts
