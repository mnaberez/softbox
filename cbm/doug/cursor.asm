; cursor.asm

; PURPOSE:      To move cursor left or up by one position

; NOTE:         Follows Soft Box code exactly including
;               interior labelled return.

;include <k.incl>

; EXTERNAL DEFINITIONS
        xdef crsrl              ; cursor left entry
        xdef crsrup             ; cursor up entry

crsrl   equ *                   ; for cursor left
        ldx curcol              ; get the column position
        if eq                   ; if it is zero (left end of screen)
            ldx scrsz           ;     get line length
            lda currow          ;     and row number
            beq rtrn            ;     but do nothing if top row
            dec currow          ;     otherwise decrement row number
        endif                   ; endif
        dex                     ; decrement column number
        stx curcol              ; update cursor column pointer
rtrn    rts                     ; and return

crsrup  ldy currow              ; for cursor up, get row number
        beq rtrn                ; and just return if at top
        dec currow              ; otherwise decrement row number
        rts
