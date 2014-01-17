; getchar.asm

; PURPOSE:      To get a character from the keyboard buffer
;               and return the character in A.  If there
;               are no characters in the buffer, wait until
;               one is entered.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef getchar

getchar equ *
        loop
           lda #$ff               ; load illegal character
           sei                    ; disable interupts for this routine
           ldx nchar              ; characters in the buffer?
           if ne                  ; if not skip to end, else
                lda keybuf        ;    get character from head
                pha               ;    of the buffer and save it.
                ldx #$00          ;    initialize index register,
                dec nchar         ;    and update character count
                loop              ;    loop
                   lda keybuf+1,x ;       shift characters in buffer
                   sta keybuf,x   ;       down one position
                   inx            ;       using the X register
                   cpx nchar      ;
                until eq          ;     until all have been shifted.
                pla               ;     retrieve the saved character
           endif                  ; endif
           cli                    ; enable interrupts
           cmp #$ff               ; and check for legal character
        until ne
        rts
