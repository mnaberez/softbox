; insert.asm

; PURPOSE:      To insert a blank at the position of the
;               cursor and move characters to the right
;               of the cursor ahead one place.

;include <k.incl>

; EXTERNAL REFERENCES
        xref curadr             ; finds the cursor address

; EXTERNAL DEFINITION
        xdef insert

insert  equ *
        jsr curadr              ; get cursor location
        ldy scrsz               ; start at the end of the line
        dey                     ; (index register off by one)
        loop                    ; loop
           cpy curcol           ;    quit shifting if cursor
           quif eq              ;    position has been reached
           dey                  ;    otherwise decrement index
           lda (scraddr),y      ;    and shift character
           iny                  ;    along one positio
           sta (scraddr),y      ;    to the right and reset the
           dey                  ;    index.
        until eq                ; until left side reached
        lda #blank              ; store a blank
        sta (scraddr),y         ; at the cursor position
        rts
