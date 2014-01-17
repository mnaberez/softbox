; crsron.asm

; PURPOSE:      To turn on the cursor

;include <k.incl>

; EXTERNAL DEFINITION
        xdef crsron

crsron  equ *
        lda #$00
        sta curflgs
        rts
