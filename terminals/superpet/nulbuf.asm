; nulbuf.asm

; PURPOSE:      To put nulls in an 80 character buffer.

;include <k.incl>

; EXTERNAL REFERENCES
        xref buff       ; buffer area

; EXTERNAL DEFINITION
        xdef nulbuf

nulbuf  equ *
        ldx #bufsize-1
        lda #$00
        loop
           sta buff,x
           dex
        until mi
        rts
