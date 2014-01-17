; curposon.asm

; PURPOSE:      To enable cursor positioning by column and
;               row coordinates.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef curposon

curposon equ *
       ; set the curposflg to a non-zero value of 2 to indicate that
       ; the two cursor positioning bytes are to follow.
         lda #$02
         sta curposflg
         rts
