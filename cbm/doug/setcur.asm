; setcur.asm

; PURPOSE:      To set the cursor position row and column
;               numbers.  Column number is set by first byte
;               and row number by second byte.  Curposflg is
;               used to indicate whether the row or column is
;               to be set.

; ENTRY:        A register holds the column or row coordinate
;               with a bias of $20 added.
;               If the 'curposflg' is 2 then A represents a column number
;               If the 'curposflg' is 1 then A represents a row number

;include <k.incl>

; EXTERNAL REFERENCES
        xref print1             ; Part of print routine. Not understood.

; EXTERNAL DEFINITION
        xdef setcur

; NOTES:        By initially setting curposflg to a non-zero value
;               using 'curposon' this routine will be entered.  This
;               routine will immediatly decrement the flag by 1 to
;               indicate that the contents of A represent the


setcur  equ *
        dec curposflg

      ; column positioning
        if ne                   ; if curposflg was >= 2 then
           sec                  ;    column positioning
           sbc #$20             ;    remove the bias
           cmp scrsz            ;    compare with screensize
           if cc                ;    if less than screensize
               sta curcol       ;        then set new column number
           endif                ;    endif
L1         jmp print1           ;    move cursor and store character under it
        endif

      ; row positioning
            sec                 ;    column positioning
            sbc #$20            ;    remove bias
            cmp #nlines         ;    compare with max lines
            bcs L1              ;    move cursor and store character under it
            sta currow          ;    if above last line, set new row number
            jmp print1          ;    move cursor and get character under it
