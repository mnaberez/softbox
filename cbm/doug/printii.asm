; printII.asm

; PURPOSE:      To print to the screen.  This routine includes
;               a character translation from ASCII  to CBM
;               screen code.  There are three entry points
;               'print', 'print1', and 'print2'.

;       printII has been modified to poke ascii characters directly
;       to the superpet ascii screen font.

;include <k.incl>

; EXTERNAL REFERENCES
        xref putchar    ; pokes to screen - reversed if reverse flag ON
        xref curadr     ; sets the pointers to start of cursor line

; EXTERNAL DEFINITION
        xdef print      ; first entry
        xdef print1     ; second entry
        xdef print2     ; third entry

print   jsr putchar

print1  jsr curadr      ; set cursor position
        lda (scraddr),y ; and retrieve character under the cursor
        sta curchar     ; store it in the current character location
        lda curflgs     ; get old value of curflg and
        sta curflg      ; restore the cursor on/off flag
        rts

print2  and #$7f        ; remove hi bit.  Putchar will put it back if reversed.
        jmp print
