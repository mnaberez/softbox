; clreol.asm

; PURPOSE:      To clear screen from cursor to end of line.

;include <k.incl>

; EXTERNAL REFERENCES
        xref curadr             ; finds the cursor address and
                                ; puts it in locations $02 & $03.

; EXTERNAL DEFINITION
        xdef clreol

clreol  equ *
        jsr curadr              ; get the current cursor address
        lda #blank              ; load A with a blank character
        loop                    ; loop
           sta (scraddr),y      ;    and store blanks in
           iny                  ;    the cursor location and
           cpy scrsz            ;    each subsequent location
        until eq                ; until the end of the line is reached.
        rts
