; clear.asm

; PURPOSE:      To clear the screen

;include <k.incl>

; EXTERNAL DEFINITION
        xdef clear

clear   equ *
        ldx #$00                ; initialize X register
        stx curcol              ; set column number and
        stx currow              ; row number to zero
        stx rvrsflg             ; and reverse off
        lda #blank              ; load blank character
        loop                    ; loop
           sta screen,x         ;    and store
           sta screen+$100,x    ;    in the
           sta screen+$200,x    ;    X'th
           sta screen+$300,x    ;    byte of
           sta screen+$400,x    ;    each of
           sta screen+$500,x    ;    the
           sta screen+$600,x    ;    eight
           sta screen+$700,x    ;    screen
           inx                  ;    pages
        until eq                ; for $00 <= X <= $100
        rts
