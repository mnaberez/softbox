; clreos.asm

; PURPOSE:      To clear from cursor position
;               to the bottom of the screen.

;include <k.incl>

; EXTERNAL REFERENCES
        xref clreol             ; clears to the end of current line

; EXTERNAL DEFINITION
        xdef clreos

clreos  equ *
        jsr clreol              ; clear rest of line
        ldx currow              ; load current row number
        loop                    ; loop
           inx                  ;    increment row number
           cpx #nlines          ;    if bottom of screen reached
           quif eq              ;    then quit and return
           clc                  ;    otherwise set the address of
           lda scraddr          ;    the start of line pointer to
           adc scrsz            ;    point to the next line by adding
           sta scraddr          ;    the line length to the lower byte
           if cs                ;    and incrementing the upper
               inc scraddr+1    ;    byte on carry from the lower
           endif                ;    byte
           lda #blank           ;    Load A with a blank character
           ldy #$00             ;    and initialize the index register
           loop                 ;    loop
              sta (scraddr),y   ;       now clear the line by incrementing
              iny               ;       incrementing the Y
              cpy scrsz         ;       index register
           until eq             ;    until it equals the line length
        until ne                ; then repeat tne loop
        rts
