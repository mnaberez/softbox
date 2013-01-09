;CBM-II Port of Softbox CP/M Loader
;
cinv_lo     = $0300   ;KERNAL IRQ vector LO
cinv_hi     = $0301   ;KERNAL IRQ vector HI
keyd        = $03ab   ;Keyboard Buffer
screen      = $d000   ;Start of screen RAM
vic         = $d800   ;6567/6569 VIC-II (P-series)
crtc        = $d800   ;6545 CRTC (B-series)
cia2_pa     = $dc00   ;6526 CIA #2 Port A
cia2_ddra   = $dc02   ;6526 CIA #2 Data Direction Register A
tpi1_pa     = $de00   ;6525 TPI #1 Port A
tpi1_pb     = $de01   ;6525 TPI #1 Port B
tpi1_pc     = $de02   ;6525 TPI #1 Port C
tpi1_ddra   = $de03   ;6525 TPI #1 Data Direction Register A
tpi1_ddrc   = $de05   ;6525 TPI #1 Data Direction Register C
tpi1_cr     = $de06   ;6525 TPI #1 Control Register
tpi1_air    = $de07   ;6525 TPI #1 Active Interrupt Register
tpi2_pa     = $df00   ;6525 TPI #1 Port A - Keyboard Row select LO
tpi2_pb     = $df01   ;6525 TPI #1 Port B - Keyboard Row select HI
tpi2_pc     = $df02   ;6525 TPI #1 Port C - Keyboard Col read
chrout      = $ffd2   ;KERNAL Send a char to the current output device
scrorg      = $ffed   ;KERNAL Get screen dimensions
;
e6509       = $00     ;6509 Execute Register
i6509       = $01     ;6509 Indirect Register
scrpos_lo   = $02     ;Pointer to current screen RAM position - LO
scrpos_hi   = $03     ;Pointer to current screen RAM position - HI
cursor_x    = $04     ;Current X position: 0-79
cursor_y    = $05     ;Current Y position: 0-24
cursor_off  = $06     ;Cursor state: zero = show, nonzero = hide
scrcode_tmp = $07     ;Temporary storage for the last screen code
keycount    = $08     ;Number of keys in the buffer at keyd
x_width     = $09     ;Width of X in characters (40 or 80)
reverse     = $0a     ;Reverse video flag (reverse on = 1)
moveto_cnt  = $0b     ;Counts down bytes to consume in a move-to (CTRL_1B) seq
cursor_tmp  = $0c     ;Pending cursor state used with CURSOR_OFF
target_lo   = $0d     ;Target address for mem xfers, ind jump, & CTRL_11 - LO
target_hi   = $0e     ;Target address for mem xfers, ind jump, & CTRL_11 - HI
insert_lo   = $0f     ;Insert line (CTRL_11) destination screen address - LO
insert_hi   = $10     ;Insert line (CTRL_11) destination screen address - HI
xfer_lo     = $11     ;Memory transfer byte counter - LO
xfer_hi     = $12     ;Memory transfer byte counter - HI
char_mask   = $13     ;Masks incoming bytes for 7- or 8-bit character mode
rtc_jiffies = $14     ;Software Real Time Clock
rtc_secs    = $15     ;  The RTC locations can't be changed because they
rtc_mins    = $16     ;  are accessed directly by the SoftBox CP/M program
rtc_hours   = $17     ;  TIME.COM using DO_READ_MEM and DO_WRITE_MEM.
jiffy2      = $18     ;Jiffy counter (MSB)
jiffy1      = $19     ;Jiffy counter
jiffy0      = $1a     ;Jiffy counter (LSB)
blink_cnt   = $1b     ;Counter used for cursor blink timing
got_srq     = $1c     ;IEEE-488 SRQ detect: zero=no SRQ, nonzero=SRQ pending
uppercase   = $1d     ;Uppercase graphics flag (uppercase on = 1)
hertz       = $1e     ;Constant for powerline frequency: 50 or 60 Hz

;Configure VICE
;  Settings > CBM2 Settings > Memory > Enable Bank 15 $4000-5FFF RAM
;
;B-series
;  BLOAD"CBM2.PRG",B15  ;BLOAD into Bank 15
;  SYS 16384            ;Start terminal
;
;P-series
;  SYS 4                ;Start monitor
;  L"CBM2.PRG",08       ;"08" is the device number in hex
;  X                    ;Exit monitor
;  SYS 16384            ;Start terminal

    *=$4000

init:
    sei                ;Disable interrupts
    lda #$0f
    sta i6509          ;Bank 15 (System Bank)
    lda #<irq_handler
    sta cinv_lo
    lda #>irq_handler
    sta cinv_hi        ;Install our interrupt handler
    lda tpi1_pb
    and #%10111111
    sta tpi1_pb        ;Turn cassette motor off
    lda #$00
    sta keycount       ;Reset key counter (no keys hit)
    sta rtc_jiffies    ;Reset software real time clock
    sta rtc_secs
    sta rtc_mins
    sta rtc_hours
    sta jiffy2         ;Reset jiffy counter
    sta jiffy1
    sta jiffy0
    lda #$0a
    sta repeatcount1   ;Store #$0A in REPEATCOUNT1
;--    CLI                ;Enable interrupts again
    lda #$14
    sta blink_cnt      ;Initialize cursor blink countdown
    lda #$00
    sta cursor_off     ;Cursor state = show the cursor

init_4080:
;Detect 40/80 column screen and store in X_WIDTH.
;Initialize VIC-II registers for P500.
;
    jsr scrorg         ;Returns X=width, Y=height
    stx x_width
    cpx #$28           ;40 column screen?
    bne init_hertz     ;  No: Skip P500 init
    lda #$00
    sta vic+$20        ;VIC-II Border color = Black
    sta vic+$21        ;VIC-II Background color = Black

init_hertz:
;Initialize powerline frequency constant used by the software clock.
;TODO: Implemention for P500
    lda #$32           ;50 Hz
    sta hertz
    bit x_width        ;40 column screen?
    bvc init_term      ;  Yes: We're done, assume 50 Hz
    bit tpi2_pc        ;Machine jumpered for 50 Hz?
    bvc init_term      ;  Yes: hertz = 50 Hz
    lda #$3c
    sta hertz          ;  No: hertz = 60 Hz

init_term:
    jsr ctrl_16        ;Go to lowercase mode
    jsr ctrl_02        ;Go to 7-bit character mode
    jsr ctrl_06        ;Clear all tab stops
    lda #$00
    sta moveto_cnt     ;Move-to counter = not in a move-to seq
    lda #$1a           ;Load #$1A = CTRL_1A Clear Screen
    jsr process_byte   ;Call into terminal to execute clear screen


;TODO: Temporary hack for keyboard debugging
;Remove this loop for actual IEEE-488 operation
forever:
    jsr get_key        ;Wait for a key
    jsr process_byte   ;Send it to the terminal screen
    jmp forever


init_ieee:
;
;6525 TPI #1 ($DE00)
;    PA0 75161A pin 11 DC
;    PA1 75161A pin  1 TE
;    PA2 REN
;    PA3 ATN
;    PA4 DAV
;    PA5 EOI
;    PA6 NDAC
;    PA7 NRFD
;
;    PB0 IFC
;    PB1 SRQ
;
;6526 CIA #2 ($DC00)
;    PA0-7 Data
;
;    lda tpi1_ddrc
;    and #%11111101
;    sta tpi1_ddrc      ;Disable IRQs from IEEE SRQ
;
;    lda tpi1_pc
;    and #%11111101
;    sta tpi1_pc        ;Clear any previous IRQ from IEEE SRQ
;    sta tpi1_air

    lda #$00
    sta got_srq

    ;Data byte must be inverted
    lda #$ff
    sta cia2_ddra      ;Data lines all outputs
    lda #$c6
    sta cia2_pa        ;Put #$39 on IEEE data lines

    lda #%00111111     ;PA7 NRFD  Input
                       ;PA6 NDAC  Input
                       ;PA5 EOI   Output
                       ;PA4 DAV   Output
                       ;PA3 ATN   Output
                       ;PA2 REN   Output
                       ;PA1 TE    Output
                       ;PA0 DC    Output
    sta tpi1_ddra

    lda #%00100010     ;EOI=hi, DAV=lo, ATN=lo, REN=lo
    sta tpi1_pa

    ldx #$02
atn_wait:
    ldy #$00
atn_wait_1:
    dey
    bne atn_wait_1     ;Let #$39 sit on the lines so the SoftBox sees it
    dex
    bne atn_wait

    lda #%00111010     ;EOI=hi, DAV=hi, ATN=hi, REN=lo, TE=1, DC=0
    sta tpi1_pa

main_loop:
    lda #$00
    sta got_srq

    cli

    lda #$00
    sta cia2_ddra     ;Data lines all inputs

    lda #%11001000    ;NRFD=hi, NDAC=hi, ATN=hi, REN=lo, TE=lo, DC=lo
    sta tpi1_pa

    lda #%11001111    ;PA7 NRFD  Output
                      ;PA6 NDAC  Output
                      ;PA5 EOI   Input
                      ;PA4 DAV   Input
                      ;PA3 ATN   Output
                      ;PA2 REN   Output
                      ;PA1 TE    Output
                      ;PA0 DC    Output
    sta tpi1_ddra


wait_for_srq:
    lda got_srq
    beq wait_for_srq

    sei

    lda tpi1_pa
    and #%10111111
    sta tpi1_pa        ;NDAC=lo

    ldx cia2_pa        ;Read IEEE data byte with command from SoftBox
                       ;
                       ; Bit 7: CBM to SoftBox: Key not available
                       ; Bit 6: CBM to SoftBox: Key available
                       ; Bit 5: SoftBox to CBM: Transfer from the SoftBox to CBM memory
                       ; Bit 4: SoftBox to CBM: Transfer from CBM memory to the SoftBox
                       ; Bit 3: SoftBox to CBM: Jump to an address
                       ; Bit 2: SoftBox to CBM: Write to the terminal screen
                       ; Bit 1: SoftBox to CBM: Wait for a key and send it
                       ; Bit 0: SoftBox to CBM: Key available?

    txa                ;Remember the original command byte in X
    ror ;a

    lda #$7f           ;Next byte we'll put on IEEE will be #$80 (key available)
    bcs send_key_avail ;Bypass the key buffer check

    ldy keycount       ;Is there a key in the buffer?
    bne send_key_avail ;  No:  Response will be #$80 (key available)
    lda #$bf           ;  Yes: Response will be #$40 (no key available)

send_key_avail:
    sta cia2_pa        ;Put keyboard status on the bus

    lda #$ff
    sta cia2_ddra      ;Data lines all outputs

    lda #%00111111     ;PA7 NRFD  Input
                       ;PA6 NDAC  Input
                       ;PA5 EOI   Output
                       ;PA4 DAV   Output
                       ;PA3 ATN   Output
                       ;PA2 REN   Output
                       ;PA1 TE    Output
                       ;PA0 DC    Output
    sta tpi1_ddra

    lda #%00111010     ;EOI=hi, DAV=hi, ATN=hi, REN=lo, TE=1, DC=0
    sta tpi1_pa

    ldy #$10
send_k_a_wait:
    dey
    bne send_k_a_wait  ;Let keyboard status sit on the lines a while

    lda #$00
    sta cia2_ddra      ;Data lines all inputs

    lda #%11001111     ;PA7 NRFD  Output
                       ;PA6 NDAC  Output
                       ;PA5 EOI   Input
                       ;PA4 DAV   Input
                       ;PA3 ATN   Output
                       ;PA2 REN   Output
                       ;PA1 TE    Output
                       ;PA0 DC    Output
    sta tpi1_ddra

    lda #%11001000    ;NRFD=hi, NDAC=hi, ATN=hi, REN=lo, TE=lo, DC=lo
    sta tpi1_pa

handshake:
    lda cia2_pa
    and #$3f
    cmp #$3f
    bne handshake

dispatch_command:
    txa                ;Recall the original command byte from X
    ror ;a
    bcc main_loop      ;Bit 0: Key availability
    ror ;a
    bcc do_get_key     ;Bit 1: Wait for a key and send it
    ror ;a
    bcc do_terminal    ;Bit 2: Write to the terminal screen
    ror ;a
    bcc do_jump        ;Bit 3: Jump to an address
    ror ;a
    bcc do_read_mem    ;Bit 4: Transfer from CBM memory to the SoftBox
    jmp do_write_mem   ;Bit 5: Transfer from the SoftBox to CBM memory

do_get_key:
;Wait for a key and send it to the SoftBox.
;
;At the CP/M "A>" prompt, the SoftBox sends this command and then
;waits for the CBM to answer.
;
    jsr get_key         ;Block until we get a key.  Key will be in A.
    jsr ieee_send_byte  ;Send the key to the Softbox.
    jmp main_loop

do_terminal:
;Write to the terminal screen
    jsr ieee_get_byte
    pha
    lda tpi1_pa
    ora #%01000000
    sta tpi1_pa        ;NDAC=hi
    pla
    jsr process_byte
    jmp main_loop

do_jump:
;Jump to an address
    jsr ieee_get_byte  ;Get byte
    sta target_lo      ; -> Command vector lo
    jsr ieee_get_byte  ;Get byte
    sta target_hi      ; -> Command vector hi
    lda tpi1_pa
    ora #%01000000
    sta tpi1_pa        ;NDAC=hi
    jsr jump_cmd       ;Jump to the command through TARGET_LO
    jmp main_loop

do_read_mem:
;Transfer bytes from CBM memory to the SoftBox
    jsr ieee_get_byte
    sta xfer_lo
    jsr ieee_get_byte
    sta xfer_hi
    jsr ieee_get_byte
    sta target_lo
    jsr ieee_get_byte
    sta target_hi
    ldy #$00
l_05a5:
    dey
    bne l_05a5   ; delay
l_05a8:
    lda (target_lo),y
    jsr ieee_send_byte
    iny
    bne l_05b2
    inc target_hi
l_05b2:
    lda xfer_lo
    sec
    sbc #$01
    sta xfer_lo
    lda xfer_hi
    sbc #$00
    sta xfer_hi
    ora xfer_lo
    bne l_05a8
    jmp main_loop

do_write_mem:
;Transfer bytes from the SoftBox to CBM memory
    jsr ieee_get_byte
    sta xfer_lo
    jsr ieee_get_byte
    sta xfer_hi
    jsr ieee_get_byte
    sta target_lo
    jsr ieee_get_byte
    sta target_hi
    ldy #$00
l_0571:
    jsr ieee_get_byte
    sta (target_lo),y
    iny
    bne l_057b
    inc target_hi
l_057b:
    lda xfer_lo
    sec
    sbc #$01
    sta xfer_lo
    lda xfer_hi
    sbc #$00
    sta xfer_hi
    ora xfer_lo
    bne l_0571
    jmp main_loop

ieee_get_byte:
;Receive a byte from the SoftBox over the IEEE-488 bus.
;
    lda tpi1_pa
    ora #%10000000
    sta tpi1_pa       ;NRFD=hi

l_05d7:
    lda tpi1_pa
    and #%00010000
    bne l_05d7        ;Wait for DAV = lo (Softbox says data is valid)

    lda cia2_pa
    eor #$ff          ;Invert the byte (IEEE true = low)
    pha               ;Push data byte

    lda tpi1_pa
    and #%01111111    ;NRFD=lo
    ora #%01000000    ;NDAC=hi
    sta tpi1_pa

l_05ef:
    lda tpi1_pa
    and #%00010000
    beq l_05ef         ;Wait until DAV=hi

    lda tpi1_pa
    and #%10111111     ;NDAC=lo
    sta tpi1_pa
    pla
    rts

ieee_send_byte:
;Send a byte to the SoftBox over the IEEE-488 bus.
;
    eor #$ff           ;Invert the byte (IEEE true = low)
    sta cia2_pa        ;Put byte on IEEE data output lines

    ;Switch IEEE to Output
    lda #$ff
    sta cia2_ddra      ;Data lines all outputs

    lda #%00111111     ;PA7 NRFD  Input
                       ;PA6 NDAC  Input
                       ;PA5 EOI   Output
                       ;PA4 DAV   Output
                       ;PA3 ATN   Output
                       ;PA2 REN   Output
                       ;PA1 TE    Output
                       ;PA0 DC    Output
    sta tpi1_ddra

    lda #%00111010     ;EOI=hi, DAV=hi, ATN=hi, REN=lo, TE=1, DC=0
    sta tpi1_pa

l_060d:
    ;INC SCREEN+$0010   ;XXX Debug

    bit tpi1_pa
    bpl l_060d         ;Wait for NRFD=hi

    lda tpi1_pa
    and #%11101111     ;DAV=lo
    sta tpi1_pa

l_0617:
    bit tpi1_pa
    bvs l_0617         ;Wait for NDAC=lo

    lda tpi1_pa
    ora #%00010000     ;DAV=hi
    sta tpi1_pa


l_0627:
;    INC SCREEN+$0012   ;XXX Debug

    bit tpi1_pa
    bpl l_0627         ;Wait for NDAC=hi

    ;Switch IEEE to Input
    lda #$00
    sta cia2_ddra     ;Data lines all inputs

    lda #%11001111    ;PA7 NRFD  Output
                      ;PA6 NDAC  Output
                      ;PA5 EOI   Input
                      ;PA4 DAV   Input
                      ;PA3 ATN   Output
                      ;PA2 REN   Output
                      ;PA1 TE    Output
                      ;PA0 DC    Output
    sta tpi1_ddra

    lda #%11001000    ;NRFD=hi, NDAC=hi, ATN=hi, REN=lo, TE=lo, DC=lo
    sta tpi1_pa

    rts

get_key:
;Get the next key waiting from the keyboard buffer and return
;it in the accumulator.  If there is no key, this routine will
;block until it gets one.  Meanwhile, the interrupt handler
;calls SCAN_KEYB and puts any key into the buffer.
;
    lda #$ff        ;FF = no key
    sei             ;Disable interrupts
    ldx keycount    ;Is there a key waiting in the buffer?
    beq l_0649      ;  No: nothing to do with the buffer.
    lda keyd        ;Read the next key in the buffer (FIFO)
    pha             ;Push the key onto the stack
    ldx #$00
    dec keycount    ;Keycount = Keycount - 1
l_063d:
    lda keyd+1,x    ;Remove the key from the buffer by rotating
    sta keyd,x      ;  bytes in the buffer to the left
    inx
    cpx keycount    ;Finished updating the buffer?
    bne l_063d      ;  No: loop until we're done.
    pla             ;Pull the key off the stack.
l_0649:
    cli             ;Enable interrupts again
    cmp #$ff        ;No key or key is "NONE" in the tables?
    beq get_key     ;  No key:  loop until we get one.
    rts             ;  Got key: done.  Key is now in A.

irq_handler:
;On the PET/CBM, an IRQ occurs at 50 or 60 Hz depending on the power line
;frequency.  The 6502 calls the main IRQ entry point ($E442 on BASIC 4.0)
;which pushes A, X, and Y onto the stack and then executes JMP (cinv_lo).
;We install this routine, IRQ_HANDLER, into cinv_lo during init.
;
    lda i6509
    pha                 ;Preserve 6509 Indirect Register

    lda tpi1_air        ;Read the AIR to find the active interrupt and
                        ;tell the TPI that interrupt service has begun.

check_tpi1:             ;IRQ from TPI #1?
    bne check_acia
    jmp irq_done
check_acia:
    cmp #$10            ;IRQ from ACIA?
    bne check_proc
    jmp irq_done
check_proc:
    cmp #$08            ;IRQ from Coprocessor?
    bne check_cia
    jmp irq_done
check_cia:
    cmp #$04            ;IRQ from CIA?
    bne check_ieee
    jmp irq_done
check_ieee:
    cmp #$02            ;IRQ from IEEE-488?
    bne irq_50hz
    sta got_srq
    jmp irq_done

;IRQ must have been caused by 50/60 Hz
;
irq_50hz:
    inc jiffy0          ;Counts number of Interrupts
    bne l_0659
    inc jiffy1          ;counter
    bne l_0659
    inc jiffy2          ;counter
l_0659:
    inc rtc_jiffies     ;Increment Jiffies
    lda rtc_jiffies
    cmp hertz           ;50 or 60 Hz
    bne blink_cursor
    lda #$00            ;Reset RTC_JIFFIES counter
    sta rtc_jiffies
    inc rtc_secs        ;Increment Seconds
    lda rtc_secs
    cmp #$3c            ;Have we reached 60 seconds?
    bne blink_cursor    ; No, skip
    lda #$00            ; Yes, reset seconds
    sta rtc_secs
    inc rtc_mins        ;Increment Minutes
    lda rtc_mins
    cmp #$3c            ;Have we reached 60 minutes?
    bne blink_cursor    ; No, skip
    lda #$00            ; Yes, reset minutes
    sta rtc_mins
    inc rtc_hours       ;Increment hours
    lda rtc_hours
    cmp #$18            ;Have we reached 24 hours
    bne blink_cursor    ; No, skip
    lda #$00            ; Yes, reset hours
    sta rtc_hours
blink_cursor:
    lda cursor_off      ;Is the cursor off?
    bne l_069f          ;  Yes: skip cursor blink
    dec blink_cnt       ;Decrement cursor blink countdown
    bne l_069f          ;Not time to blink? Done.
    lda #$14
    sta blink_cnt       ;Reset cursor blink countdown
    jsr calc_scrpos
    lda (scrpos_lo),y   ;Read character at cursor
    eor #$80            ;Flip the REVERSE bit
    sta (scrpos_lo),y   ;Write it back
l_069f:
    lda scancode        ;Get the SCANCODE
    cmp repeatcode      ;Compare to SAVED scancode
    beq l_06b1          ;They are the same, so continue
    sta repeatcode      ;if not, save it
    lda #$10            ;reset counter
    sta repeatcount0    ;save to counter
    bne irq_key
l_06b1:
    cmp #$ff            ; NO KEY?
    beq irq_key         ; Yes, jump to scan for another
    lda repeatcount0    ; No, there was a key, so get the counter
    beq l_06bf          ; Is it zero?
    dec repeatcount0    ; Count Down
    bne irq_key         ; Is it Zero
l_06bf:
    dec repeatcount1    ; Count Down
    bne irq_key         ; Is it zero? No, scan for another
    lda #$04            ; Yes, Reset it to 4
    sta repeatcount1    ; Store it
    lda #$00            ;Clear the SCANCODE and allow the key to be processed
    sta scancode        ;Store it
    lda #$02
    sta blink_cnt       ;Fast cursor blink(?)
irq_key:
    jsr scan_keyb       ;Scan the keyboard
    beq irq_done        ;Nothing to do if no key was pressed.
    ldx keycount
    cpx #$50            ;Is the keyboard buffer full?
    beq irq_done        ;  Yes:  Nothing we can do.  Forget the key.
    sta keyd,x          ;  No:   Store the key in the buffer
    inc keycount        ;        and increment the keycount.

irq_done:
    sta tpi1_air        ;Write to the AIR to tell the TPI that the
                        ;interrupt service has concluded.
    pla
    sta i6509           ;Restore 6509 indirect register
    pla
    tay                 ;Restore Y
    pla
    tax                 ;Restore X
    pla                 ;Restore A
    rti


process_byte:
;This is the core of the terminal emulator.  It accepts a byte in
;the accumulator, determines if it is a control code or character
;to display, and then jumps accordingly.  After the jump, all
;code paths will end up at PROCESS_DONE.
;
    pha
    lda cursor_off    ;Get the current cursor state
    sta cursor_tmp    ;  Remember it
    lda #$ff
    sta cursor_off    ;Hide the cursor
    jsr calc_scrpos   ;Calculate screen RAM pointer
    lda scrcode_tmp   ;Get the screen code previously saved
    sta (scrpos_lo),y ;  Put it on the screen
    pla
    and char_mask     ;Mask off bits depending on char mode
    ldx moveto_cnt    ;More bytes to consume for a move-to seq?
    bne l_0715        ;  Yes: branch to jump to move-to handler
    cmp #$20          ;Is this byte a control code?
    bcs l_0718        ;  No: branch to put char on screen
    asl ;a
    tax
    lda ctrl_codes,x  ;Load vector from control code table
    sta target_lo
    lda ctrl_codes+1,x
    sta target_hi
    jsr jump_cmd      ;Jump to vector to handle control code
    jmp process_done
l_0715:
    jmp move_to       ;Jump to handle move-to sequence
l_0718:
    jmp put_char      ;Jump to put character on the screen
jump_cmd:
    jmp (target_lo)   ;Jump to handle the control code

ctrl_codes:
;Terminal control code dispatch table.  These control codes are based
;on the Lear Seigler ADM-3A terminal.  Some bytes that are unused on
;that terminal are used for other purposes here.
;
    !word ctrl_00   ; Do nothing
    !word ctrl_01   ; Go to 8-bit character mode
    !word ctrl_02   ; Go to 7-bit character mode
    !word ctrl_03   ; Do nothing
    !word ctrl_04   ; Set TAB STOP at current position
    !word ctrl_05   ; Clear TAB STOP at current position
    !word ctrl_06   ; Clear all TAB STOPS
    !word ctrl_07   ; Ring bell
    !word ctrl_08   ; Cursor left
    !word ctrl_09   ; Perform TAB
    !word ctrl_0a   ; Line feed
    !word ctrl_0b   ; Cursor up
    !word ctrl_0c   ; Cursor right
    !word ctrl_0d   ; Carriage return
    !word ctrl_0e   ; Reverse video on
    !word ctrl_0f   ; Reverse video off
    !word ctrl_10   ; Cursor off
    !word ctrl_11   ; Insert a blank line
    !word ctrl_12   ; Scroll up one line
    !word ctrl_13   ; Clear to end of line
    !word ctrl_14   ; Clear to end of screen
    !word ctrl_15   ; Go to uppercase mode
    !word ctrl_16   ; Go to lowercase mode
    !word ctrl_17   ; Set line spacing to tall
    !word ctrl_18   ; Set line spacing to short
    !word ctrl_19   ; Cursor on
    !word ctrl_1a   ; Clear screen
    !word ctrl_1b   ; Move cursor to X,Y position
    !word ctrl_1c   ; Insert a space on current line
    !word ctrl_1d   ; Delete character at cursor
    !word ctrl_1e   ; Home cursor
    !word ctrl_1f   ; Do nothing

ctrl_07:
;Ring bell
;
    lda #$07   ;CHR$(7) = Bell
    jmp chrout ;Kernal Print a byte

ctrl_18:
;Set line spacing to tall (the default spacing for lowercase graphic mode).
;The current graphic mode will not be changed.
;
    rts          ;No effect on CBM-II.


ctrl_17:
;Set line spacing to short (the default spacing for uppercase graphic mode).
;The current graphic mode will not be changed.
;
    rts          ;No effect on CBM-II.

ctrl_01:
;Go to 8-bit character mode
;See PUT_CHAR for how this mode is used to display CBM graphics.
;
    lda #$ff
    sta char_mask
    rts

ctrl_02:
;Go to 7-bit character mode
;
    lda #$7f
    sta char_mask
    rts

ctrl_00:
ctrl_03:
ctrl_1f:
;Do nothing
    rts

putscr_then_done:
;Put the screen code in the accumulator on the screen
;and then fall through to PROCESS_DONE.
;
    jsr put_scrcode

process_done:
;This routine always returns to DO_TERMINAL except during init.
;
    jsr calc_scrpos   ;Calculate screen RAM pointer
    lda (scrpos_lo),y ;Get the current character on the screen
    sta scrcode_tmp   ;  Remember it
    lda cursor_tmp    ;Get the previous state of the cursor
    sta cursor_off    ;  Restore it
    rts

put_char:
;Puts an ASCII (not PETSCII) character in the accumulator on the screen
;at the current CURSOR_X and CURSOR_Y position.  This routine first
;converts the character to its equivalent CBM screen code and then
;jumps out to print it to the screen.
;
;Bytes $00-7F (bit 7 off) always correspond to the 7-bit standard
;ASCII character set and are converted to the equivalent CBM screen code.
;
;Bytes $80-FF (bit 7 on) are a special extended mode that display
;the CBM graphics characters if the terminal is in 8-bit mode (CTRL_01):
;
;  Byte      Screen Code
;  $80-BF -> $40-7F
;  $C0-FF -> $40-7F
;
    cmp #$40              ;Is it < 64?
    bcc putscr_then_done  ;  Yes: done, put it on the screen
    cmp #$60              ;Is it >= 96?
    bcs l_07a6            ;  Yes: branch to L_07A6
    and #$3f              ;Turn off bits 6 and 7
    jmp l_07ac            ;Jump to L_07CA
l_07a6:
    cmp #$80              ;Is bit 7 set?
    bcs l_07ca            ;  Yes: branch to L_07CA
    and #$5f
l_07ac:
    tax
    and #$3f              ;Turn off bit 7 and bit 6
    beq l_07c6
    cmp #$1b
    bcs l_07c6
    txa
    eor #$40              ;Flip bit 6
    tax
    lda uppercase
    beq l_07c6            ;Branch if lowercase mode
    txa
    and #$1f
    jmp putscr_then_done
l_07c6:
    txa
    jmp putscr_then_done
l_07ca:
    and #$7f              ;Turn off bit 7
    ora #$40              ;Turn on bit 6
    jmp putscr_then_done  ;Put it on the screen

ctrl_15:
;Go to uppercase mode
;
    lda #$01
    sta uppercase         ;Set flag to indicate uppercase = on
    bit x_width           ;40 columns?
    bvc ctrl_15_1         ;  Yes: branch to P-series routine
    lda tpi1_cr
    ora #%00010000
    sta tpi1_cr           ;B-series graphic mode = uppercase
    rts
ctrl_15_1:
    lda #$41
    sta vic+$18           ;P-series graphic mode = uppercase
    rts

ctrl_16:
;Go to lowercase mode
;
    lda #$00
    sta uppercase         ;Set flag to indicate uppercase = off
    bit x_width           ;40 columns?
    bvc ctrl_16_1         ;  Yes: branch to P-series routine
    lda tpi1_cr
    and #%11101111
    sta tpi1_cr           ;B-series graphic mode = lowercase
    rts
ctrl_16_1:
    lda #$43
    sta vic+$18           ;P-series graphic mode = lowercase
    rts

ctrl_08:
;Cursor left
;
    ldx cursor_x
    bne l_07e9     ; X > 0? Y will not change.
    ldx x_width    ; X = max X + 1
    lda cursor_y
    beq l_07ec     ; Y=0? Can't move up.
    dec cursor_y   ; Y=Y-1
l_07e9:
    dex
    stx cursor_x   ; X=X-1
l_07ec:
    rts

ctrl_0b:
;Cursor up
;
    ldy cursor_y
    beq l_07ec     ; Y=0? Can't move up.
    dec cursor_y   ; Y=Y-1
    rts

put_scrcode:
;Put the screen code in A on the screen at the current cursor position
;
    ldx reverse      ;Is reverse video mode on?
    beq l_07fa       ;  No:  leave character alone
    eor #$80         ;  Yes: Flip bit 7 to reverse the character
l_07fa:
    jsr calc_scrpos    ;Calculate screen RAM pointer
    sta (scrpos_lo),y  ;Write the character to the screen
                       ;Fall through into CTRL_0C to advance cursor

ctrl_0c:
;Cursor right
;
    inc cursor_x   ;X=X+1
    ldx cursor_x
    cpx x_width    ;X > max X?
    bne l_0817     ;  No:  Done, no need to scroll up.
    lda #$00       ;  Yes: Set X=0 and then
    sta cursor_x   ;       fall through into CTRL_0A to scroll.

ctrl_0a:
;Line feed
;
    ldy cursor_y
    cpy #$18       ;Are we on line 24?
    bne l_0814     ;  No:  Done, scroll is not needed
    jmp scroll_up  ;  Yes: Scroll the screen up first
l_0814:
    inc cursor_y   ;Increment Y position
    rts
l_0817:
    rts

ctrl_1e:
;Home cursor
;
    lda #$00       ;Home cursor
    sta cursor_y
    sta cursor_x
    rts

ctrl_1a:
;Clear screen
;
    jsr ctrl_0f        ;Reverse video off
    jsr ctrl_1e        ;Home cursor
    ldx #$00
ctrl_1a_1:
    lda #$20           ;Space character
    sta screen,x       ;Fill first 1K
    sta screen+$100,x  ;  This is always screen RAM on both B-series
    sta screen+$200,x  ;  and P-series machines.
    sta screen+$300,x
    bit x_width        ;80 columns?
    bvs ctrl_1a_2      ;  Yes: B-series, continue to fill with space char.
    lda #$0f           ;  No:  P-series, fill second 1K with Light Grey.
ctrl_1a_2:
    sta screen+$400,x  ;Fill second 1K
    sta screen+$500,x  ;  On B-series, this is more screen RAM.
    sta screen+$600,x  ;  On P-series, this is the VIC-II color RAM.
    sta screen+$700,x
    inx
    bne ctrl_1a_1
    rts

ctrl_0d:
;Carriage return
;
    lda #$00       ;Move to X=0 on this line
    sta cursor_x
    rts

ctrl_10:
;Cursor on
;
    lda #$00
    sta cursor_tmp
    rts

ctrl_19:
;Cursor off
;
    lda #$ff
    sta cursor_tmp
    rts

ctrl_0e:
;Reverse video on
;
    lda #$01
    sta reverse
    rts

ctrl_0f:
;Reverse video off
;
    lda #$00
    sta reverse
    rts

ctrl_13:
;Clear to end of line
;
    jsr calc_scrpos    ;Leaves CURSOR_X in Y register
    lda #$20           ;Space character
l_0863:
    sta (scrpos_lo),y  ;Write space to screen RAM
    iny                ;X=X+1
    cpy x_width
    bne l_0863         ;Loop until end of line
    rts

ctrl_14:
;Clear from Current line to end of screen
;
    jsr ctrl_13     ;Clear to the end of the current line
    ldx cursor_y    ;Get the Current line#
l_0870:
    inx             ;Next Row
    cpx #$19        ;Is it 25 (last line of screen?
    beq l_088d      ;  Yes, we're done
    clc             ;  No, continue
    lda scrpos_lo   ;Current screen position
    adc x_width     ;Add the line width
    sta scrpos_lo   ;Save it
    bcc l_0880      ;Need to update HI?
    inc scrpos_hi   ;  Yes, increment HI pointer
l_0880:
    lda #$20        ;SPACE
    ldy #$00        ;Position 0
l_0884:
    sta (scrpos_lo),y ;Write a space
    iny               ;Next character
    cpy x_width       ;Is it end of line?
    bne l_0884        ;No, loop back for more on this line
    beq l_0870        ;Yes, loop back for next line
l_088d:
    rts

scroll_up:
;Scroll the screen up one line
;
    lda #$00
    sta scrpos_lo
    lda x_width
    sta target_lo
    lda #>screen
    sta scrpos_hi
    sta target_hi
    ldx #$18
l_089e:
    ldy #$00
l_08a0:
    lda (target_lo),y
    sta (scrpos_lo),y
    iny
    cpy x_width
    bne l_08a0
    lda target_lo
    sta scrpos_lo
    clc
    adc x_width
    sta target_lo
    lda target_hi
    sta scrpos_hi
    adc #$00
    sta target_hi
    dex
    bne l_089e
    ldy #$00
    lda #$20          ;SPACE
l_08c1:
    sta (scrpos_lo),y
    iny
    cpy x_width
    bne l_08c1
    rts

ctrl_04:
;Set TAB stop at current position
;
    lda #$01         ;1=TAB STOP yes
    !byte $2c ; Falls through to become BIT $00A9

ctrl_05:
;Clear TAB stop at current position
;
    lda #$00         ;0=No TAB STOP
    ldx cursor_x     ;Get cursor position
    sta tab_stops,x  ;Clear the TAB at that position
    rts

ctrl_06:
;Clear ALL TAB STOPS
;
    ldx #$4f  ; 80 characters-1
    lda #$00  ; zero
l_08d8:
    sta tab_stops,x  ;store in the buffer
    dex
    bpl l_08d8
    rts

ctrl_09:
;Perform TAB.  Move to next TAB STOP as indicated in the TAB_STOPS table.
;
    ldx cursor_x
l_08e1:
    inx               ; next position
    cpx #$50          ; 80 characters?
    bcs l_08ed        ; yes, exit
    lda tab_stops,x   ; read from the TAB STOPS table
    beq l_08e1        ; is it zero? yes, loop again
    stx cursor_x      ; no, we hit a STOP, so store the position
l_08ed:
    rts

ctrl_1c:
;Insert space at current cursor position
;
    jsr calc_scrpos
    ldy x_width       ;number of characters on line
    dey
l_08f4:
    cpy cursor_x
    beq l_0901
    dey
    lda (scrpos_lo),y  ;read a character from line
    iny                ;position to the right
    sta (scrpos_lo),y  ;write it back
    dey                ;we are counting down to zero
    bne l_08f4         ;loop for another character
l_0901:
    lda #$20           ; SPACE
    sta (scrpos_lo),y  ; Write it to current character position
    rts

ctrl_1d:
;Delete a character
;
    jsr calc_scrpos
    ldy cursor_x
l_090b:
    iny
    cpy x_width
    beq l_0918
    lda (scrpos_lo),y  ;read a character from the line
    dey                ;position to the left
    sta (scrpos_lo),y  ;write it back
    iny                ;we are counting UP
    bne l_090b         ;loop for another character
l_0918:
    dey
    lda #$20           ;SPACE
    sta (scrpos_lo),y  ;write it to the current character position
    rts

ctrl_12:
;Scroll up one line
;
;The screen is shifted upward so that each line Y+1 is copied into Y.  Screen
;contents are preserved except for the bottommost line, which is erased
;(filled with spaces).  The current cursor position will not be changed.
;
    lda #$00
    sta cursor_x
    jsr calc_scrpos
    lda $02
    clc
    adc x_width
    sta target_lo
    lda scrpos_hi
    adc #$00
    sta target_hi
    lda #$18
    sec
    sbc cursor_y
    tax
    jmp l_089e         ;Jump into SCROLL_UP, bypassing some init

ctrl_11:
;Insert a blank line
;
;The screen is shifted downward so that each line Y is copied into Y+1.
;The line at the current position will be erased (filled with spaces).
;The current cursor position will not be changed.
;
    lda #<screen+$03c0 ;A->TARGET_LO, Y->TARGET_HI
    ldy #>screen+$03c0 ;Start address of last 40 col line
    ldx x_width
    cpx #$50           ;Is this an 80 column screen?
    bne l_0949         ;  No: keep address for 40 col
    lda #<screen+$0780
    ldy #>screen+$0780 ;Start address of last 80 col line
l_0949:
    sta target_lo
    sty target_hi
    lda #$00
    sta cursor_x
l_0951:
    lda target_lo
    cmp scrpos_lo
    bne l_095d
    lda target_hi
    cmp scrpos_hi
    beq l_097c
l_095d:
    lda target_lo
    sta insert_lo
    sec
    sbc x_width
    sta target_lo
    lda target_hi
    sta insert_hi
    sbc #$00
    sta target_hi
    ldy #$00
l_0970:
    lda (target_lo),y
    sta (insert_lo),y
    iny
    cpy x_width
    bne l_0970
    jmp l_0951
l_097c:
    ldy #$00
    lda #$20          ;SPACE
l_0980:
    sta (scrpos_lo),y
    iny
    cpy x_width
    bne l_0980
    rts

calc_scrpos:
;Calculate a new pointer to screen memory (scrpos_lo/scrpos_hi)
;from cursor position at cursor_x and cursor_y.
;
    pha
    lda #$00
    sta scrpos_hi
    lda cursor_y
    sta scrpos_lo
    asl ;a
    asl ;a
    adc scrpos_lo
    asl ;a
    asl ;a
    rol scrpos_hi
    asl ;a
    rol scrpos_hi
    sta scrpos_lo
    bit x_width
    bvc l_09a8
    asl scrpos_lo
    rol scrpos_hi
l_09a8:
    clc
    ldy cursor_x
    lda scrpos_hi
    adc #>screen
    sta scrpos_hi
    pla
    rts

ctrl_1b:
;Move cursor to X,Y position
;
;This control code is unlike the others because it requires an
;additional two bytes to follow: first X-position, then Y-position.
;
;The MOVETO_CNT byte counts down the remaining bytes to consume.  On
;successive passes through PROCESS_BYTE, the X and Y bytes are handled
;by MOVE_TO.
;
;Note: The X and Y values use the same layout as CURSOR_X and CURSOR_Y
;but they require an offset.  You must add decimal 32 to each value to
;get the equivalent CURSOR_X and CURSOR_Y.  The offset is because this
;emulates the behavior of the Lear Siegler ADM-3A terminal.
;
    lda #$02          ;Two more bytes to consume (X-pos, Y-pos)
    sta moveto_cnt    ;Store count for next pass of PROCESS_BYTE
    rts

move_to:
;Implements CTRL_1B by handling the X-position byte on the first call
;and the Y-position byte on the second call.  After the Y-position byte
;has been consumed, MOVETO_CNT = 0, exiting the move-to sequence.
;
    dec moveto_cnt    ;Decrement bytes remaining to consume
    beq l_09c8        ;Already got X pos?  Handle this byte as Y.
    sec
    sbc #$20          ;X-pos = X-pos - #$20
    cmp x_width       ;Requested X position out of range?
    bcs l_09c5        ;  Yes: Do nothing.
    sta cursor_x      ;  No:  Move cursor to requested X.
l_09c5:
    jmp process_done  ;Done.
l_09c8:
    sec
    sbc #$20          ;Y-pos = Y-pos - #$20
    cmp #$19          ;Requested Y position out of range?
    bcs l_09c5        ;  Yes: Do nothing.
    sta cursor_y      ;  No:  Move cursor to requested Y.
    jmp process_done  ;Done.

scan_keyb:
;Scan the keyboard.
;The CBM-II uses a 16x6 Keyboard Matrix. There are 16 ROWS and 6 COLS.
;The keyboard uses 3 ports on TPI#2. Two ports control the ROW. Setting the line LOW selects the ROW.
;Reading the COL tells which key(s) are down. If a key is down the bit will be 0.
;
; TPI2_PA     = $DF00   ;6525 TPI #1 Port A - Keyboard Row select LO
; TPI2_PB     = $DF01   ;6525 TPI #1 Port B - Keyboard Row select HI
; TPI2_PC     = $DF02   ;6525 TPI #1 Port C - Keyboard Col read

;
; USES: SCANCODE  - Code of Pressed KEY ($FF=NONE)
;       LASTCODE  - Code of Previous KEY
;       ROWCOUNT  - Keyboard ROW counter
;       SHIFTFLAG - Shift Flag
;       KEYFLAG   - Regular Key Flag
;       KEYOFFSET - Pointer into keyboard table

    lda scancode           ;Old SCANCODE
    sta lastcode           ;Save It
    ldx #$00               ;X=0 Index into Keyboard Scan Table
    stx keyoffset          ;Reset index into table
    stx shiftflag          ;Reset Shift Flag
    stx keyflag            ;Reset Key Flag
    lda #$ff               ;$FF = no key
    sta scancode           ;Set it
    lda #$0                ;Keyboard has 16 ROWS
    sta rowcount           ;ROW=0 - Keyboard ROW counter

;---- top of loop for keyboard ROWS
;
scan_row:
;                           We need to set ALL bits on PORTA and PORTB to ONE, except the line we need to check
;                           The KEY_SEL table holds the values to place in the port. We use the ROW as an offset into the tables.
;                           There are THREE sets of 8 bytes so that the middle is common, we use an offset of 0 for PORTB so
;                           that it starts at $FF (no row selected) and an offset of 8 for PORTA to that it starts at $FE.
;                           As the ROW increases the ZERO bit 'walks' from one port to the other without doing any
;                           complicated bit shifting and comparing
;
    ldx rowcount           ;Get Keyboard ROW counter. Use as offset to table
    lda key_sel1,x         ;Get value to place in PORTA
    sta tpi2_pa            ;set it
    lda key_sel2,x         ;Get value to place in PORTB
    sta tpi2_pb            ;set it

debounce:
    lda tpi2_pc            ;TPI2 Port C- Keyboard Columns Read
    cmp tpi2_pc            ;TPI2 Port C- Keyboard Columns Read
    bne debounce           ;wait for stable value on keyboard switches (debounce)
    and #%00111111         ;Mask off top two bits (used for machine configuration)
                           ;Result of Row scan is now in A (call is SCANCODE)

    ldy #$06               ;Y=6 -- 6 Columns in Table

;---- top of loop to go through each bit returned from scan. Each "0" bit represents a key pressed down

scan_col:
    lsr ;a                 ;Shift byte RIGHT leaving CARRY flag set if it is a "1"
    pha                    ;Push it to the stack
    bcs nextcol            ;Is the BIT a "1"? Yes. Means key was NOT pressed. Bypass testing
    ldx keyoffset
    lda key_table,x        ;  Yes, read from keyboard table
    cmp #$01               ;IS it the SHIFT key?
    beq key_shift          ; Yes, skip
    bcc key_reg            ; No, It's a regular key
    sta scancode           ;Store the SCANCODE as-is
    bcs nextcol

key_shift:
    inc shiftflag          ;Increment SHIFT Flag
    bne nextcol            ; Is it >0? Yes, loop back for another key

key_reg:
    inc keyflag            ;Increment KEY flag

nextcol:
    pla                    ;pull the original scan value from stack
    inc keyoffset          ;X=X+1 - next entry in table
    dey                    ;Y=Y-1 - next BIT in scan value
    bne scan_col           ;Is it ZERO? No, go back for next COL

nextrow:
    inc rowcount           ;ROW=ROW+1
    lda rowcount
    cmp #$10               ;Is it ROW 16?
    bne scan_row           ;  NO, loop back up for next ROW

;-------------------------------------- end of scanning loops
; Check if there is anything to do. SCANCODE will be $FF if no key.
; If the SCANCODE = LASTCODE then key is being held down. Don't do anything until it is released.
; The IRQ handler implements key repeat by clearing the SCANCODE after a short interval.

    lda scancode           ;Get the current SCANCODE
    cmp #$ff               ;Is it NO KEY?
    beq keydone            ; Yes, exit
    cmp lastcode           ;Is it the same as last? (Key is registered on key UP?)
    beq keydone            ; Yes, exit

;---- Check for CTRL key
key_check1:
    cmp #$00               ;Compare to CTRL key
    bpl key_low            ;No, skip

;---- CTRL KEY not pressed
key_hi:
    and #$7f               ;Remove the TOP bit (shift flag for character?)
    ldy shiftflag          ;Check SHIFT Flag
    beq key_low            ;SHIFT=0? Yes, skip
    eor #$10               ;No, flip BIT 4 (what does bit 4 do?)
    rts

;---- Check if in A-Z range
key_low:
    cmp #$40               ;Start of compare to A-Z Range. "@" is lower limit?
    bcc key_check2         ;It is below? Yes, must be COMMAND character
    cmp #$60               ;Compare to upper ascii limit?
    bcs key_check2         ;Is it above the A-Z range? Yes, skip

;----  Check KEY Flag
    ldy keyflag            ;Check KEY Flag
    beq key_atoz           ;Is it zero? Yes, skip
    and #$1f               ;RETURN CTRL-A to Z - Use only the lower 5 BITS (0 to 31)

keydone:
    rts

;---- Check A to Z or CTRL key
key_atoz:
    cmp #$40               ;Compare to "@" symbol
    beq key_check2
    cmp #$5b               ;Compare to "[" symbol?
    bcs key_check2

    ldy shiftflag          ;Is SHIFT Flag set?
    bne key_check2         ; No,skip to next test

;---- Handle regular A-Z
    ;pha                    ;Yes, push the character code to stack
    ;lda via_pcr            ;Bit 1 off = uppercase, on = lowercase
    ;lsr ;a                 ;shift
    ;lsr ;a                 ;shift to get BIT 2
    ;pla                    ;pull the character code from stack
    ;bcc key_check2         ;Branch if uppercase mode
    ora #$20               ;Convert character to UPPERCASE HERE

    rts                    ;Return with character code in A

;---- Check SHIFT flag
key_check2:
    ldy shiftflag          ;Check SHIFT flag for zero
    beq key_set            ;  Yes, skip out

;---- Translate SHIFTED 0-31 codes to terminal control codes
key_sh_codes:
    ldx #$0b               ;CTRL_0B Cursor up
    cmp #$0a               ;SCAN=CRSR DOWN
    beq key_ctrl_code
    ldx #$08               ;CTRL_08 Cursor left
    cmp #$0c               ;SCAN=CRSR RIGHT
    beq key_ctrl_code
    ldx #$1a               ;CTRL_1A Clear screen
    cmp #$1e               ;SCAN=HOME
    beq key_ctrl_code

;---- these must be normal shifted keys or Graphics?
    ;pha                    ;Push key to stack
    ;lda uppercase          ;Bit 0 off = lowercase, on = uppercase
    ;ror ;a                 ;Rotate uppercase flag bit into carry
    ;pla                    ;Pull original key from stack
    ;bcc key_set            ;Branch if lowercase mode

    ora #$80               ;Set the HIGH BIT
    rts                    ;Return with character code in A?

;---- Return a terminal control code (CTRL_CODES table)
key_ctrl_code:
    txa                    ;Substitute the terminal control code
    rts                    ;Return with control code in A

key_set:
    cmp #$00               ;Set CARRY if non-zero character?
    rts

;---- This is a table of values to write to keyboard ROW select ports
key_sel1:
    !byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
key_sel2:
    !byte $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f
    !byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

;---------- Keyboard Table
key_table:
;                                   ----- ----- ----- ----- ----- -----
;                                   COL0  COL1  COl2  COL3  COL4  COL5
;                                   ----- ----- ----- ----- ----- -----
    !byte $ff,$1b,$09,$ff,$01,$00 ; F1    ESC   TAB   NONE  SHIFT CTRL
    !byte $ff,$b1,$51,$41,$5a,$ff ; F2    1     Q     A     Z     NONE
    !byte $ff,$b2,$57,$53,$58,$43 ; F3    2     W     S     X     C
    !byte $ff,$b3,$45,$44,$46,$56 ; F4    3     E     D     F     V
    !byte $ff,$b4,$52,$54,$47,$42 ; F5    4     R     T     G     B
    !byte $ff,$b5,$b6,$59,$48,$4e ; F6    5     6     Y     H     N
    !byte $ff,$b7,$55,$4a,$4d,$20 ; F7    7     U     J     M     SPACE
    !byte $ff,$b8,$49,$4b,$2c,$2e ; F8    8     I     K     ,     .
    !byte $ff,$b9,$4f,$4c,$3b,$2f ; F9    9     NONE  L     ;     /
    !byte $ff,$b0,$2d,$50,$5b,$27 ; F10   0     -     P     [     '
    !byte $11,$3d,$5f,$5d,$0d,$de ; DOWN  =     BARRW ]     RETRN PI
    !byte $91,$9d,$1d,$7f,$02,$ff ; UP    LEFT  RIGHT DEL   CBM   NONE
    !byte $13,$3f,$37,$34,$31,$30 ; HOME  ?     7     4     1     0
    !byte $12,$04,$38,$35,$32,$2e ; RVS   CE    8     5     2     .
    !byte $8e,$2a,$39,$36,$33,$30 ; GRAPH *     9     6     3     00
    !byte $03,$2f,$2d,$2b,$0d,$ff ; STOP  /     -     +     ENTER NONE


;Storage locations used in keyboard scanning routine SCAN_KEYB
scancode:
    !byte $aa

lastcode:
    !byte $aa

rowcount:
    !byte $aa

shiftflag:
    !byte $aa

keyflag:
    !byte $aa

repeatcount0:
    !byte $aa

repeatcount1:
    !byte $aa

repeatcode:
    !byte $aa
keyoffset:
    !byte $aa

;Start of buffer used by control codes 05, 06, and 09
tab_stops:
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa
