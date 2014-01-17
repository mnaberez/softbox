; insrtln.asm

; PURPOSE:      To insert a blank line and scroll lower lines down.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef insrtln

insrtln equ *

      ; find the bottom of the screen
        lda #$C0                       ; address of start of the last line of a
        ldy #$83                       ; 40 column screen is $83C0.
        ldx scrsz                      ; Present screen size
        cpx #80                        ; compare it with a screen size of 80
        if eq                          ; if it is 80 columns and not 40 then
           lda #$80+(nlines-25)*80     ;    use the address $8780 for the start
           ldy #$87                    ;    of last line of an 80 column screen
        endif                          ; endif
        sta T1                         ; save pointer to last line
        sty T1 + 1
        lda #$00               ; set column number to zero
        sta curcol

      ; shift lines down starting at the bottom and working
      ; up toward the cursor line
        loop
           lda T1            ; check the lower and upper
           cmp scraddr       ; bytes of the line to be
           if eq             ; shifted, pointed to by T1,
               lda T1 + 1    ; and quite shifting
               cmp scraddr+1 ; lines if it is the cursor line
               beq L1
           endif
           lda T1               ; copy T1 low byte to T2 low byte
           sta T2
           sec
           sbc scrsz            ; move T1 low byte up one line
           sta T1
           lda T1 + 1           ; copy T1 high byte to T2 high byte
           sta T2 + 1
           sbc #$00             ; carry from T1 high byte
           sta T1 + 1
           ldy #$00
           loop
              lda (T1),y        ; shift line pointed to by T1
              sta (T2),y        ; to line pointed to by T2
              iny
              cpy scrsz         ; transfer all characters in the line
           until eq
        endloop

      ; fill in the cursor line with blanks
L1      ldy #$00
        lda #blank
        loop
           sta (scraddr),y
           iny
           cpy scrsz
        until eq
        rts
