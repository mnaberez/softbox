; dltln.asm

; PURPOSE:      To delete a line by scrolling lower lines upward.

;include <k.incl>

; EXTERNAL REFERENCES
        xref scroll             ; entry point to 'scrollup' for
                                ; scrolling only part of the screen.

        xref curadr             ; gets cursor address

; EXTERNAL DEFINITIONS
        xdef dltln

dltln   equ *
        lda #$00        ; set up so that 'scrollup' will scroll
        sta curcol      ; starting from the line just below
        jsr curadr      ; the cursor line.
        lda scraddr
        clc
        adc scrsz
        sta T1
        lda scraddr+1
        adc #$00
        sta T1+1
        lda #nlines-1
        sec
        sbc currow      ; number of lines to be scrolled upward
        tax             ; place in X for use by 'scrollup'
        jmp scroll
