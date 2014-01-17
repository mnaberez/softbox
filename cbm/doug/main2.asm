; main2.asm

; PURPOSE:      Mainline terminal emulation routine

;       main2 is a modified version of main.  Number of lines to the
;       screen has been changed to 24 and the SUPERPET ASCII screen
;       font has been selected.


; CREATING THE LOAD MODULE:
;       The original terminal emulation program 'k' occupied 9 blocks
;       on the disk.  The latter part of the program was padded and
;       the program itself did not occupy the full 9 blocks.  Thus there
;       is some room for expansion without using more disk space.  It
;       is not known whether proper operation will occur if 'k' should
;       occupy more space and therefore shift the 'cp/m' system.  It is
;       probably safe if any additions to this program do not spill beyond
;       the 9 blocks.  When saving the newly created load module, it is
;       necessary to save from $0400 to ensure the first byte is a null.
;       The 9 blocks will just be filled if the memory from $0400 to
;       $0CEB is saved so that it is best if the program does not extend
;       beyond $0CEB.  Thus, after loading the BASIC starter and the
;       assembled 'k.mod', the following save command may be used:
;
;                       .s "0:k2",08,0400,0CEC


;include <k.incl>

; EXTERNAL REFERENCES
        xref repeat             ; number of interrupts to key repeat
        xref inthndlr           ; address of interupt handler
        xref hibitof            ; disable graphics
        xref scrnhndlr          ; special screen operations
        xref nulbuf             ; clear all tabs
        xref getieee            ; read a character from the IEEE bus
        xref jump_table         ; to execute routines
        xref putieee            ; to write to the IEEE bus
        xref getchar            ; to get a character from keyboard buffer

        jmp start

        fcc "  SOFTBOX LOADER (C) COPYRIGHT 1981 KEITH FREWIN"
        fcc "  ----  REVISION :  5 JULY 1981     "
        fcc "  2ND   REVISION : 17  AUG 1983  24 LINE SUPERPET ASCII SCREEN"

; SET INTERRUPT VECTOR AND INTERRUPT PARAMETERS
start   sei             ; disable interrupts while setting new vector
        lda #<inthndlr  ; lower byte of interrupt handler
        sta intvctr     ; stored in lower byte of interrupt vector
        lda #>inthndlr  ; upper byte of interrupt handler
        sta intvctr+1   ; stored in upper byte of interrupt vector

        lda #$00        ; initialize interrupt dependent variables
        sta nchar       ; no characters in keyboard buffer
        lda #$00
        sta jif         ; zero jiffies
        sta secs        ; zero seconds
        sta min         ; zero minutes
        sta hrs         ; zero hours
        sta nints       ; zero interrupts
        sta nints+1
        sta nints+2
        lda #nrepeat    ; initialize number of interrupts to
        sta repeat      ; the next repeated key
        cli             ; enable interrupts again

; INITIALIZE PARAMETERS
        jsr hibitof     ; disable graphics
        lda #20
        sta crblink     ; 20 interrupts between cursor reverses
        lda #$00
        sta curflg      ; enable cursor blinking
        sta curposflg   ; cursor positioning flag off

        lda #80         ; set screen size (SUPERPET is 80)
        sta scrsz

        lda #$1A        ; clear screen
        jsr scrnhndlr
        jsr nulbuf      ; and clear tabs

; SET SUPERPET ASCII SCREEN
        lda #$0C
        sta $E880
        lda #$30
        sta $E881
        lda #$0C
        sta $E84C

; INITIALIZE THE IEEE BUS
        lda $E822       ; IEEE output port. clear interrupts ???

        ; set ATN low (true) 'send IEEE commands, not data'
        lda $E840       ; get the IEEE control register
        and #$FB        ; set bit 2 (ATN out) low
        sta $E840       ; put back in register

        ; set SRQ in low (true) and DAV out true, 'data valid'
        lda #$34
        sta $E823

        ; set $C6 in output register  ???
        lda #$C6
        sta $E822

        ; delay for a while
        ldy #$00
        loop
           dey
        until eq

        ; now set $FF in output register
        lda #$FF
        sta $E822       ; this is zero for inverted bus logic

        ; set output EOI high (false), 'not end of message'
        lda #$3C
        sta $E811

        ; set ATN in low and NDAC out high, 'data accepted'
        sta $E821

        ; set SRQ in true and DAV out false, 'data not valid'
        sta $E823

; BEGIN MAIN LOOP
begin   equ *

        ; set ATN in low, and NDAC out high, 'data accepted'
        lda #$3C
        sta $E821

        ; set ATN out high (false), NRFD out high (false) 'send data not cmds'
        lda $E840
        ora #$06        ; set bits 1 and 2
        sta $E840

        ; wait for SRQ in to go high
        loop
           lda $E823    ; Control register CRB of PIA 2
           asl          ; shift bit 7 (CB1 or SRQ in) into CARRY
        until cs        ; leave loop when CARRY is set

        lda $E822       ; IEEE output register ??  Clears interrupts??

        ; set ATN in low, and NDAC out low, 'data not accepted'
        lda #$34
        sta $E821

        ; sample the IEEE input register and save in X
        ldx $E820

        guess           ; guess
           txa          ;     transfer a copy to A so that the
           ror          ;     low bit can be put in Carry
           lda #$7F     ;     now load $7F
        quif cs         ; if low bit was set $7F is what is wanted
           ldy nchar    ;     else load Y with no. of chars in keybrd. buffer
        quif ne         ; if keybrd buffer not empty retain $7F in A
           lda #$BF     ;     otherwise use $BF
        endguess        ; endguess
        sta $E822       ; and put A on the bus

        ; wait until bus data is $3F
        loop
           lda $E820
           and #$3F     ; so that CARRY won't be set during compare??
           cmp #$3F
        until eq

        ; put $FF (zero for the inverted IEEE logic) on bus
        lda #$FF
        sta $E822

        ; take another look at low bit of sample which was saved in X
        txa
        ror             ; look at its low bit (bit 0)
        bcc begin       ; loop to the beginning if it was zero
        ror             ; else look at the next bit (bit 1)
        bcc J1          ; if zero get keyboard byte and send it to the IEEE
        ror             ; else look at the next bit (bit 2)
        bcc display     ; if zero then send next byte to screen
        ror             ; else look at the next bit (bit 3)
        bcc execute     ; if zero then address of program to execute follows
        ror             ; else look at the next bit (bit 4)
        bcc peek        ; if zero put a whole block onto IEEE bus
        jmp poke        ; else input a block of bytes from IEEE bus
                        ;    perhaps this block of bytes could be
                        ;    a program downloaded from the SOFTBOX.

J1      jmp getput      ; read byte from keyboard buffer and put to IEEE

display jsr getieee     ; read byte from IEEE
        ldx #$3C        ; set ATN in low, and NDAC out high
        stx $E821       ; ie. 'data accepted'
        jsr scrnhndlr   ; print the byte to the screen
        jmp begin       ; and go back to the beginning.

execute equ *           ; EXECUTE a PET program
        jsr getieee     ; read address of special PET routine from
        sta T1          ; SOFTBOX and place it in the indirect
        jsr getieee     ; address locations used for the jump table.
        sta T1+1        ; Note: A routine will have to be placed there first
        ldx #$3C        ; set ATN in low and NDAC out high,
        stx $E821       ; ie 'data accepted'.
        jsr jump_table  ; execute the code
        jmp begin       ; and return to the beginning

poke    equ *           ; get a block of bytes from IEEE
        jsr getieee     ; get number of bytes
        sta nbytes      ; in the block and store in
        jsr getieee     ; nbytes & nbytes+1 ie. two byte integer.
        sta nbytes+1
        jsr getieee     ; get start address of destination
        sta T1          ; of the block of bytes in the PET
        jsr getieee     ; memory and store in T1 & T1+1
        sta T1+1
        ldy #$00        ; initialize index register
        loop            ; loop
           jsr getieee  ;    read the next character
           sta (T1),y   ;    store it in the next position of memory
           iny          ;    increment the register
           if eq        ;    if it overflowed then
              inc T1+1  ;       increment high byte of address
           endif        ;    endif
           lda nbytes   ;    subtract one from the number of
           sec          ;    bytes remaining to be read from the
           sbc #1       ;    bus this is a two byte integer so
           sta nbytes   ;    that the high byte must
           lda nbytes+1 ;    have the carry subtracted
           sbc #0       ;    if needed.
           sta nbytes+1 ;    when there are no more bytes
           ora nbytes   ;    to be read then quit loop, that is
        until eq        ; until both bytes are equal to zero
        jmp begin       ; return to the beginning of the main loop.

peek    equ *           ; put a block of bytes to the IEEE bus
        jsr getieee     ; get number of bytes in the block
        sta nbytes      ; and store as a two byte integer
        jsr getieee     ; at nbytes
        sta nbytes+1
        jsr getieee     ; get starting address of the block
        sta T1          ; and store in the indirect address
        jsr getieee     ; location T1 & T1+1
        sta T1+1
        ldy #$00        ; delay for a short time
        loop
           dey
        until eq        ; Y index register is zero at end of delay
        loop            ; loop
           lda (T1),y   ;    get the next byte from memory
           jsr putieee  ;    and write it to IEEE
           iny          ;    increment Y for the next byte
           if eq        ;    if it overflowed
               inc T1+1 ;        increment high byte of address
           endif        ;    endif
           lda nbytes   ;    decrement the number of
           sec          ;    bytes left to send
           sbc #1
           sta nbytes
           lda nbytes+1
           sbc #0
           sta nbytes+1
           ora nbytes
        until eq        ; until there are non left to send
        jmp begin       ; then return to the start of the main loop

getput equ *            ; read from the keyboard buffer and send on IEEE
        jsr getchar     ; get character from keyboard buffer
        jsr putieee     ; send it to the IEEE bus
        jmp begin       ; and return to main loop
