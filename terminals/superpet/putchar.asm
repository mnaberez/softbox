; putchar.asm

; PURPOSE:      To print a character to the screen.  Character will
;               be printed in reverse if reverse flag is on.

; ENTRY:        A - Character to be printed
;               Y - Number of spaces between cursor and printed character.
;                   This should probably be set to zero.  Y is probably
;                   simply used to allow indirect address operation.
;               $0A - Non zero for reversed character.

;include <k.incl>

; EXTERNAL REFERENCES
        xref curadr
        xref scrollup

; EXTERNAL DEFINITION
        xdef putchar    ; print character entry
        xdef crsrrt     ; cursor right entry
        xdef crsrdn     ; cursor down entry

putchar equ *                   ; entry to print a character
        ldx rvrsflg             ; get the reverse flag
        if ne                   ; if non-zero
            eor #$80            ;     set high bit on
        endif                   ; endif
        jsr curadr              ; find the position of the cursor
        sta (scraddr),y         ; and poke the character

crsrrt  equ *                   ; entry to move cursor right one space
        inc curcol              ; increment the column number
        ldx curcol              ; and then test whether it now equals
        cpx scrsz               ; the maximum screen line length
        if eq                   ; if it does then
            lda #$00            ;    set the column number
            sta curcol          ;    back to zero and test
crsrdn      ldy currow          ;    whether the line is at
            cpy #nlines-1       ;    the bottom of the screen
            if eq               ;    if it is then
                jmp scrollup    ;        scroll screen up
            endif               ;    endif
            inc currow          ;    increase the row number
            rts                 ;    and return
        endif                   ; endif
        rts                     ; else return
