; delete.asm

; PURPOSE:      To delete the character beneath the cursor
;               and move subsequent characters to the left
;               by one.

;include <k.incl>

; EXTERNAL REFERENCES
        xref    curadr          ; gets the current cursor position

; EXTERNAL DEFINITION
        xdef delete

delete  equ *
        jsr curadr              ; get the current cursor location
        ldy curcol              ; start from current position
        loop                    ; loop
           iny                  ;    move to next character
           cpy scrsz            ;    quit loop if right side
           quif eq              ;    is reached
           lda (scraddr),y      ;    otherwise a character
           dey                  ;    left one place
           sta (scraddr),y      ;    and then
           iny                  ;    reset index
        until eq                ; until index overflows (should'nt happen)
        dey                     ; now place a
        lda #blank              ; blank character in the
        sta (scraddr),y         ; last position.
        rts
