; putieee.asm

; PURPOSE:      To write a character from register A to the
;               IEEE-488 interface.  Note: the complement of
;               the character is actually written as per IEEE
;               requirements.

; PERIPHERAL CHIP ADDRESSES
    ; PIA 2
        PIAcrA   equ $E821      ; CA1 = ATN in  &  CA2 = NDAC out
        PIAportB equ $E822      ; output buffer for the ieee bus
        PIAcrB   equ $E823      ; CB1 = SRQ in  &  CB2 = DAV out

    ; VIA
        VIAportB equ $E840      ; bit 6 = NRFD in    bit 1 = NRFD out
                                ; bit 0 = NDAC in

; EXTERNAL DEFINITIONS
        xdef putieee

putieee equ *
        eor #$ff        ; take complement of character
        sta PIAportB    ; and put it in the output port

    ; set NRFD out high (false) to indicate ready for data to be sent
        lda VIAportB    ; get register contents
        ora #$02        ; set bit 1 high for NRFD false
        sta VIAportB    ; and put it back in the register

    ; set ATN in low and NDAC out high 'data accepted'
        lda #$3c
        sta PIAcrA      ; sets CA1 low and CA2 high

    ; wait for NRFD in to go high (false) ie. until OK to send
        loop
           bit VIAportB ; sets overflow if bit 6 of VIAportB is one
        until vs

    ; set SRQ in low (true) and DAV out true, 'data valid'
        lda #$34
        sta PIAcrB      ; sets CB1 low and CB2 low

    ; wait until NDAC in is high (false) 'data accepted'
        loop
           lda VIAportB ; bit 0 is the NDAC in flag
           lsr          ; shift bit 0 into carry
        until cs        ; test for high bit

    ; set SRQ in true and DAV out false. 'data not valid'
        lda #$3c
        sta PIAcrB

    ; set all bits high in output buffer (these are zeros for IEEE)
        lda #$ff
        sta PIAportB

    ; wait until NDAC in is low (true) 'data not accepted'
        loop
           lda VIAportB
           lsr
        until cc

    ; all finished so return
        rts
