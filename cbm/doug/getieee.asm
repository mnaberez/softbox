; getieee.asm

; PURPOSE:      To obtain a character from the IEEE-488 interface
;               and return it in A.

; PERIPHERAL CHIP ADDRESSES
    ; PIA 2
        PIAportA equ $E820     ; input buffer for the ieee bus - PIA port A
        PIAcrA   equ $E821     ; CA1 = IEEE ATN in  &  CA2 = NDAC out

    ; VIA
        VIAportB equ $E840     ; bit 7 = DAV in  bit 6 = NRFD in
                               ; bit 2 = ATN out bit 1 = NRFD out
                               ; bit 0 = NDAC in

; EXTERNAL DEFINITION
        xdef getieee

getieee equ *

    ; set NRFD out high (false) to signal ready for data
        lda VIAportB    ; get register contents
        ora #$02        ; set bit 2 high for NRFD false
        sta VIAportB    ; and put it back in the register

    ; wait until the data valid signal is sent
        loop
           bit VIAportB   ; wait until bit 7 is low (DAV bit)
        until pl

    ; get the input character (actually its complement)
        lda PIAportA
        eor #$ff        ; take its complement

    ; save the character temporarily
        pha

    ; set NRFD out low (true) to signal not ready for more data
        lda VIAportB    ; get the register contents
        and #$fd        ; make bit 2 zero
        sta VIAportB    ; and put it back in the register

    ; set ATN in low, and NDAC out high (data accepted)
        lda #$3c
        sta PIAcrA      ; sets CA1 low and CA2 high

    ; wait until DAV in is low (true). (data valid)
        loop
           bit VIAportB  ; wait for bit 7 to go high (DAV bit)
        until mi

    ; set ATN in low and NDAC out low (data not accepted)
        lda #$34
        sta PIAcrA      ; sets CA1 low and CA2 low

    ; retrieve the character and return
        pla
        rts
