; hibiton.asm

; PURPOSE:      To set a mask so that the hi bit will
;               not be removed.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef hibiton

hibiton equ *
        lda #$ff        ; and with $ff will change nothing
        sta mask
        rts
