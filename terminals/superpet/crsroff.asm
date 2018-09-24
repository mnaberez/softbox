; crsroff.asm

; PURPOSE:      To turn off the cursor

;include <k.incl>

; EXTERNAL DEFINITION
        xdef crsroff

crsroff equ *
        lda #$FF
        sta curflgs
        rts
