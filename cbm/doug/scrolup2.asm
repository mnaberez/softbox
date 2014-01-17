; scrollup.asm

; PURPOSE:      To scroll the screen up.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef scrollup           ; entry to scroll complete screen
        xdef scroll             ; entry to scroll partial screen

scrollup equ *
        lda #$00        ; initialize scraddr to point
        sta scraddr     ; to the screen origin
        lda scrsz       ; and a temporary  pointer
        sta T1          ; to point to the beginning
        lda #$80        ; of the second screen line.
        sta scraddr+1   ; (note registers must be off by one)
        sta T1+1        ;
        ldx #nlines-1           ; initialize X to number lines to shift
scroll  loop                    ; loop
           ldy #$00             ;    transfer a line up
           loop                 ;    loop
              lda (T1),y        ;       load a character from lower line
              sta (scraddr),y   ;       and put it in upper line
              iny               ;       for each character of
              cpy scrsz         ;       the line
           until eq             ;    until all characters in line transferred
           lda T1               ;    transfer the address of the lower
           sta scraddr          ;    line to scraddr and add a full
           clc                  ;    line to the next line pointer.
           adc scrsz            ;    Add line length to lower byte
           sta T1               ;    and any carry to the upper byte.
           lda T1 + 1           ;
           sta scraddr+1        ;
           adc #$00             ;
           sta T1+1             ;
           dex                  ;    then index the next line
        until eq                ; until the bottom has been reached.

        ldy #$00                ; now write a line of
        lda #blank              ; blanks on the bottom line.
        loop                    ;
           sta (scraddr),y      ;
           iny                  ;
           cpy scrsz            ;
        until eq
        rts
