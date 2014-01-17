; nullchar.asm

; PURPOSE:      To write a null byte in a buffer at a position
;               in the buffer corresponding to the column
;               position of the cursor.

;include <k.incl>

; EXTERNAL REFERENCES
        xref buff               ; reference to the buffer area

; EXTERNAL DEFINITION
        xdef nullchar1
        xdef nullchar

nullchar1 equ *                 ; These three bytes of junk, which completely
        fcb $A9                 ; alter the routine, are in the SOFTBOX program
        fcb $01                 ; and are even referenced by the jump table.
        fcb $2c                 ; WHY???

nullchar equ *
        lda #$00                ; poke a null into the
        ldx curcol              ; buffer position corresponding
        sta buff,x              ; to the position of the cursor
        rts
