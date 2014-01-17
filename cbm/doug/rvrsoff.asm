; rvrsoff.asm

; PURPOSE:      To set the reverse on/off flag to off.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef rvrsoff

rvrsoff equ *
        lda #$00                ; set flag OFF
        sta rvrsflg
        rts
