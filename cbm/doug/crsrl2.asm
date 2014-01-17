; crsrl2.asm

; PURPOSE:      To set the cursor position to the left
;               of the screen on the current line.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef crsrl2

crsrl2  equ *
        lda #$00
        sta curcol
        rts
