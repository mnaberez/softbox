; curadr.asm

; PURPOSE:      To get the address of the start of the screen
;               line containing the cursor.  Address is placed
;               in $02 & $03.  The cursor column number is
;               returned in the Y register.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef curadr

curadr  equ *
        pha             ; save A
        lda #$00
        sta scraddr+1   ; set high byte of scraddr to zero
        lda currow
        sta scraddr     ; load scraddr with row number

      ; multiply by  ( 2 * 2 + 1 ) * 2 * 2 * 2  =  40
        asl             ; * 2
        asl             ; * 2
        adc scraddr     ; + 1
        asl             ; * 2
        asl             ; * 2
        rol scraddr+1   ; rotate any carry into high byte
        asl             ; * 2
        rol scraddr+1   ; and rotate any additional carry into high byte
        sta scraddr     ; save row number multiplied by 40

      ; if screen is actually 80 columns multiply by 2 again
        lda scrsz
        cmp #80
        if eq
            asl scraddr         ; * 2
            rol scraddr+1       ; rotate any carry to high byte
        endif

        clc
        ldy curcol              ; exit with cursor column number in Y

        lda scraddr+1
        adc #$80                ; add $80 to high byte to provide the
        sta scraddr+1           ; screen address base of $8000

        pla                     ; retreive A
        rts                     ; and return
