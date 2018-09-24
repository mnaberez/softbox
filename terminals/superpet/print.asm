; print.asm

; PURPOSE:      To print to the screen.  This routine includes
;               a character translation from ?????  to CBM
;               screen code.  There are three entry points
;               'print', 'print1', and 'print2'.

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

print2  cmp #$40
        bcc print
        cmp #$60
        if  cc          ; if A < $60
            and #$3F    ;     remove bit 6
            jmp L1      ;     and go directly to L1
        endif           ; endif
        cmp #$80        ; test for high bit
        bcs L2          ; If A >= $80 ie. high bit set go directly to L2

        and #$5F            ; remove bits 7 and 5

L1      guess
            tax             ; save copy of char in X register
            and #$3F        ; strip bits 7 and 6
        quif eq             ; if there is nothing left then print copy

            cmp #$1B        ; otherwise compare with $1B
        quif cs             ; if >= $1B then print the copy

            txa             ; otherwise retreive copy of char
            eor #$40        ; make sure bit 6 is high
            tax             ; save new copy of char
            lda $E84C       ; check for graphics mode
            lsr             ; by shifting bit one to the
            lsr             ; carry and testing if carry set
        quif cs             ; if it is then get copy of char and print it

            txa             ; otherwise get copy of char
            and #$1F        ; strip bits 7, 6, and 5
            jmp print       ; and print it
        endguess
        txa                 ; retreive copy of char from X register
        jmp print           ; and print it

L2      and #$7F        ; remove high bit
        ora #$40        ; make sure bit 6 is set
        jmp print
