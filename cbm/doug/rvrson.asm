; rvrson.asm

; PURPOSE:      To set the reverse flag on.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef rvrson

rvrson  equ *
        lda #$01                ; set flag on
        sta rvrsflg
        rts
