; getbuf.asm

; PURPOSE:      To get next non-null character from the buffer.
;               Character returned in A.

;include <k.incl>

; EXTERNAL REFERENCES
        xref buff               ; reference to the buffer ares

; EXTERNAL DEFINITION
        xdef getbuf

getbuf  equ *
        ldx curcol
        loop                    ; skip nulls
           inx
           cpx #bufsize
           bcs rtrn
           lda buff,x
        until ne
        stx curcol              ; new cursor position
rtrn    rts
