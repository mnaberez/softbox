; hibitof.asm

; PURPOSE:      To set a mask so that the hi bit will
;               be removed.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef hibitof

hibitof equ *
        lda #$7f        ; and with $7f will remove hi bit
        sta mask
        rts
