cinv_lo     = $90     ;KERNAL IRQ vector LO
cinv_hi     = $91     ;KERNAL IRQ vector HI
keyd        = $026f   ;Keyboard Buffer
screen      = $8000   ;Start of screen RAM
pia1_row    = $e810   ;6520 PIA #1 Keyboard Row Select
pia1_eoi    = $e811   ;6520 PIA #1 Control
pia1_col    = $e812   ;6520 PIA #1 Keyboard Columns Read
pia2_ieee   = $e820   ;6520 PIA #2 IEEE Input
pia2_ndac   = $e821   ;6520 PIA #2 IEEE NDAC control
pia2_iout   = $e822   ;6520 PIA #2 IEEE Output
pia2_dav    = $e823   ;6520 PIA #2 IEEE DAV control
via_pb      = $e840   ;6522 VIA Port B
via_pcr     = $e84c   ;6522 VIA Peripheral Control Register (PCR)
chrout      = $ffd2   ;KERNAL Send a char to the current output device
;
blink_cnt   = $01     ;Counter used for cursor blink timing
scrpos_lo   = $02     ;Pointer to current screen RAM position - LO
scrpos_hi   = $03     ;Pointer to current screen RAM position - HI
cursor_x    = $04     ;Current X position: 0-79
cursor_y    = $05     ;Current Y position: 0-24
cursor_off  = $06     ;Cursor state: zero = show, nonzero = hide
scrcode_tmp = $07     ;Temporary storage for the last screen code
keycount    = $08     ;Number of keys in the buffer at keyd
x_width     = $09     ;Width of X in characters (40 or 80)
rvs_mask    = $0a     ;Reverse video mask (normal = $00, reverse = $80)
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
rtc_hours   = $17     ;  TIME.COM using DO_MEM_READ and DO_MEM_WRITE.
jiffy2      = $18     ;Jiffy counter (MSB)
jiffy1      = $19     ;Jiffy counter
jiffy0      = $1a     ;Jiffy counter (LSB)
uppercase   = $1b     ;Uppercase graphics flag (lower = $00, upper = $80)
;
    *=$0400

bas_header:
;"50 sys(1039)"
;  Note: The line number is used in a clever way.  It can be manually set
;  to either 50 or 60 to tell the program whether the power line frequency
;  is 50 Hz (Europe) or 60 Hz (North America).
;
    !byte $00,$0d,$04,$32,$00,$9e,$28,$31
    !byte $30,$33,$39,$29,$00,$00,$00
;
    jmp init

copyright:
    !text "  SOFTBOX LOADER (C) COPYRIGHT 1981 KEITH FREWIN  "

init:
    sei                ;Disable interrupts
    lda #<irq_handler
    sta cinv_lo
    lda #>irq_handler
    sta cinv_hi        ;Install our interrupt handler
    lda #$00
    sta rtc_jiffies    ;Reset software real time clock
    sta rtc_secs
    sta rtc_mins
    sta rtc_hours
    sta jiffy2         ;Reset jiffy counter
    sta jiffy1
    sta jiffy0
    sta keycount       ;Reset key counter (no keys hit)
    lda #$0a
    sta repeatcount1   ;Store #$0A in REPEATCOUNT1
    cli                ;Enable interrupts again

init_scrn:
;Initialize the screen
;
;This routine checks for an 80 column screen by writing to screen RAM
;that should not be present on a 40 column machine.  If the computer
;has been modified so that it has a 40 column screen but the extra
;screen RAM is present, this routine will think the machine has 80 columns.
;The number of columns detected is stored in X_WIDTH
;
;X_WIDTH is also used in the keyboard scanning routine to select between
;business keyboard (80 columns) or graphics keyboard (40 columns).  This
;means the 2001B machines (40-column, business keyboard) are not supported.
;
    lda #$28
    sta x_width        ;X_WIDTH = 40 characters
    lda #$55
    sta screen         ;Store #$55 in first byte of screen RAM.
    asl ;a
    sta screen+$400    ;Store #$AA in first byte of 80 col page.
    cmp screen+$400    ;Does it read back correctly?
    bne init_scrn_done ;  No: we're done, X_WIDTH = 40.
    lsr ;a
    cmp screen         ;Is the #$55 still intact?
    bne init_scrn_done ;  No: incomplete decoding, X_WIDTH = 40
    asl x_width        ;  Yes: X_WIDTH = 80 characters
init_scrn_done:
    lda #$14
    sta blink_cnt      ;Initialize cursor blink countdown
    lda #$00
    sta cursor_off     ;Cursor state = show the cursor
                       ;Fall through into init_term

init_term:
    jsr ctrl_16        ;Go to lowercase mode
    jsr ctrl_02        ;Go to 7-bit character mode
    jsr ctrl_06        ;Clear all tab stops
    lda #$00
    sta moveto_cnt     ;Move-to counter = not in a move-to seq
    lda #$1a           ;Load #$1A = CTRL_1A Clear Screen
    jsr process_byte   ;Call into terminal to execute clear screen

init_ieee:
;
;6522 VIA            6520 PIA #1            6520 PIA #2
;  PB0: !NDAC_IN       PA0-7: Data In         CA1: !ATN_IN
;  PB1: !NRFD_OUT      PB0-7: Data Out        CA2: !NDAC_OUT
;  PB2: !ATN_OUT       CA2: !EOI_OUT          CB1: !SRQ_IN
;  PB6: !NFRD_IN                              CB2: !DAV_OUT
;  PB7: !DAV_IN
;
    lda pia2_iout      ;Clears IRQA1 flag (!ATN_IN detect)
    lda via_pb
    and #$fb
    sta via_pb         ;Set !ATN_OUT = 0 to get SoftBox's attention
    lda #$34
    sta pia2_dav       ;Set !DAV_OUT = 0 to tell SoftBox our data is valid
    lda #$c6
    sta pia2_iout      ;Put #$39 on IEEE data lines
    ldy #$00

l_04d4:
    dey
    bne l_04d4         ;Let #$39 sit on the lines so the SoftBox sees it

    lda #$ff
    sta pia2_iout      ;Release IEEE data lines

    lda #%00111100
    sta pia1_eoi       ;Set !EOI_OUT = 1 and disable IRQ from CA1 (Cassette Read)
    sta pia2_ndac      ;Set !NDAC_OUT = 1 and disable IRQ from CA1 (!ATN_IN)
    sta pia2_dav       ;Set !DAV = 1

main_loop:
    lda #$3c
    sta pia2_ndac      ;Set !NDAC_OUT = 1
    lda via_pb
    ora #$06
    sta via_pb         ;Set !NRFD_OUT = 1, !ATN_OUT = 1

wait_for_srq:
    lda pia2_dav       ;Read PIA #2 CRB
    asl ;a             ;  bit 7 = IRQA1 flag for CA1 (!SRQ_IN detect)
    bcc wait_for_srq   ;Wait until !SRQ_IN is detected

    lda pia2_iout      ;Clears IRQA1 flag (!SRQ_IN detect)
    lda #$34
    sta pia2_ndac      ;Set !NDAC_OUT = 0 to indicate we do not accept the data yet

    ldx pia2_ieee      ;Read IEEE data byte with command from SoftBox
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
    ror ;A
    lda #$7f           ;Next byte we'll put on IEEE will be #$80 (key available)
    bcs send_key_avail ;Bypass the key buffer check

    ldy keycount       ;Is there a key in the buffer?
    bne send_key_avail ;  No:  Response will be #$80 (key available)
    lda #$bf           ;  Yes: Response will be #$40 (no key available)

send_key_avail:
    sta pia2_iout      ;Put keyboard status on the data lines

handshake:
    lda pia2_ieee      ;Read IEEE data byte
    and #$3f           ;We are driving only bits 7 and 6 with the keyboard status
    cmp #$3f
    bne handshake      ;Wait for the SoftBox to drive the other lines to zero
    lda #$ff
    sta pia2_iout      ;Release all data lines

dispatch_command:
    txa                ;Recall the original command byte from X
    ror ;a             ;Bit 0: Key availability was already answered above
    bcc main_loop      ;       so we're done
    ror ;a
    bcc do_get_key     ;Bit 1: Wait for a key and send it
    ror ;a
    bcc do_terminal    ;Bit 2: Write to the terminal screen
    ror ;a
    bcc do_mem_jsr     ;Bit 3: Jump to a subroutine in CBM memory
    ror ;a
    bcc do_mem_read    ;Bit 4: Transfer from CBM memory to the SoftBox
    jmp do_mem_write   ;Bit 5: Transfer from the SoftBox to CBM memory

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
    ldx #$3c
    stx pia2_ndac      ;Set !NDAC_OUT = 1 to indicate we accept the data
    jsr process_byte
    jmp main_loop

do_mem_jsr:
;Jump to a subroutine in CBM memory
    jsr ieee_get_byte  ;Get byte
    sta target_lo      ; -> Target vector lo
    jsr ieee_get_byte  ;Get byte
    sta target_hi      ; -> Target vector hi
    ldx #$3c
    stx pia2_ndac      ;Set !NDAC_OUT = 1 to indicate we accept the data
    jsr do_mem_jsr_ind ;Jump to the subroutine through TARGET_LO
    jmp main_loop
do_mem_jsr_ind:
    jmp (target_lo)

do_mem_read:
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

do_mem_write:
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
    lda via_pb
    ora #$02
    sta via_pb         ;Set !NRFD OUT = 1
l_05d7:
    bit via_pb         ;Wait for !NRFD_IN = 1 (SoftBox is ready for data)
    bmi l_05d7         ;Wait for !DAV_IN = 0 (Softbox says data is valid)

    lda pia2_ieee      ;Read data byte
    eor #$ff           ;Invert the byte (IEEE true = low)
    pha                ;Push data byte
    lda via_pb
    and #$fd
    sta via_pb         ;Set !NRFD_OUT = 0 (we are not ready for data)
    lda #$3c
    sta pia2_ndac      ;Set !NDAC_OUT = 1 (we accept the last data byte)
l_05ef:
    bit via_pb
    bpl l_05ef         ;Wait for !DAV_IN = 0 (SoftBox says data is valid)
    lda #$34
    sta pia2_ndac      ;Set NDAC_OUT = 0 (we do not accept data)
    pla
    rts

ieee_send_byte:
;Send a byte to the SoftBox over the IEEE-488 bus.
;
    eor #$ff           ;Invert the byte (IEEE true = low)
    sta pia2_iout      ;Put byte on IEEE data output lines
    lda via_pb
    ora #$02
    sta via_pb         ;Set !NRFD_OUT = 1
    lda #$3c
    sta pia2_ndac      ;Set !NDAC_OUT = 1
l_060d:
    bit via_pb
    bvc l_060d         ;Wait for !NRFD_IN = 1 (SoftBox is ready for data)
    lda #$34
    sta pia2_dav       ;Set !DAV_OUT = 0 to indicate our data is valid
l_0617:
    lda via_pb
    lsr ;a
    bcc l_0617         ;Wait for SoftBox to set NDAC_IN = 0 (not accepted)
    lda #$3c
    sta pia2_dav       ;Set !DAV_OUT = 1
    lda #$ff
    sta pia2_iout      ;Release data lines
l_0627:
    lda via_pb
    lsr ;a
    bcs l_0627         ;Wait for SoftBox to set !NDAC_IN = 1 (data accepted)
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
    inc jiffy0          ;Counts number of Interrupts
    bne l_0659
    inc jiffy1          ;counter
    bne l_0659
    inc jiffy2          ;counter
l_0659:
    inc rtc_jiffies     ;Increment Jiffies
    lda rtc_jiffies
    cmp bas_header+3    ;50 or 60 (Hz).  See note in BAS_HEADER.
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
                        ;  An important side effect of scan_keyb is
                        ;  that it reads pia1_col.  The read clears
                        ;  PIA #1's IRQB1 flag (50/60 Hz interrupt).
                        ;  If this read is not performed, IRQ will
                        ;  continuously retrigger.
    beq l_06e2          ;Nothing to do if no key was pressed.
    ldx keycount
    cpx #$50            ;Is the keyboard buffer full?
    beq l_06e2          ;  Yes:  Nothing we can do.  Forget the key.
    sta keyd,x          ;  No:   Store the key in the buffer
    inc keycount        ;        and increment the keycount.
l_06e2:
    pla
    tay
    pla
    tax
    pla
    rti

process_byte:
;This is the core of the terminal emulator.  It accepts a byte in
;the accumulator, determines if it is a control code or character
;to display, and handles it accordingly.
;
    pha
    lda cursor_off        ;Get the current cursor state
    sta cursor_tmp        ;  Remember it
    lda #$ff
    sta cursor_off        ;Hide the cursor
    jsr calc_scrpos       ;Calculate screen RAM pointer
    lda scrcode_tmp       ;Get the screen code previously saved
    sta (scrpos_lo),y     ;  Put it on the screen
    pla
    and char_mask         ;Mask off bits depending on char mode
    ldx moveto_cnt        ;More bytes to consume for a move-to sequence?
    bne process_move      ;  Yes: branch to jump to move-to handler
    cmp #$20              ;Is this byte a control code?
    bcs process_char      ;  No: branch to put char on screen
process_ctrl:
    asl ;a
    tax
    lda ctrl_codes,x      ;Load vector from control code table
    sta target_lo
    lda ctrl_codes+1,x
    sta target_hi
    jsr process_ctrl_ind  ;JSR to control code handler through vector
    jmp process_done
process_ctrl_ind:
    jmp (target_lo)
process_move:
    jsr move_to           ;JSR to move-to sequence handler
    jmp process_done
process_char:
    jsr put_char          ;JSR to put a character on the screen
process_done:
    jsr calc_scrpos       ;Calculate screen RAM pointer
    lda (scrpos_lo),y     ;Get the current character on the screen
    sta scrcode_tmp       ;  Remember it
    lda cursor_tmp        ;Get the previous state of the cursor
    sta cursor_off        ;  Restore it
    rts

move_to:
;Implements CTRL_1B by handling the X-position byte on the first call
;and the Y-position byte on the second call.  After the Y-position byte
;has been consumed, MOVETO_CNT = 0, exiting the move-to sequence.
;
    dec moveto_cnt        ;Decrement bytes remaining to consume
    beq move_to_ypos      ;Already got X pos?  Handle this byte as Y.
    sec
    sbc #$20              ;X-pos = X-pos - #$20
    cmp x_width           ;Requested X position out of range?
    bcs move_to_done      ;  Yes: Do nothing.
    sta cursor_x          ;  No:  Move cursor to requested X.
move_to_ypos:
    sec
    sbc #$20              ;Y-pos = Y-pos - #$20
    cmp #$19              ;Requested Y position out of range?
    bcs move_to_done      ;  Yes: Do nothing.
    sta cursor_y          ;  No:  Move cursor to requested Y.
move_to_done:
    rts

put_char:
;Puts an ASCII (not PETSCII) character in the accumulator on the screen
;at the current CURSOR_X and CURSOR_Y position.  This routine converts the
;character to its equivalent CBM screen code, puts it on the screen, then
;advances the cursor and returns to the caller.
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
    bcc put_scrcode       ;  Yes: done, put it on the screen
    cmp #$60              ;Is it >= 96?
    bcs l_07a6            ;  Yes: branch to L_07A6
    and #$3f              ;Turn off bits 6 and 7
    jmp l_07ac            ;Jump to L_07AC
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
    bit uppercase
    bpl put_scrcode       ;Branch if lowercase mode
    and #$1f
    jmp put_scrcode
l_07c6:
    txa
    jmp put_scrcode
l_07ca:
    and #$7f              ;Turn off bit 7
    ora #$40              ;Turn on bit 6
put_scrcode:
    eor rvs_mask          ;Reverse the screen code if needed
    jsr calc_scrpos       ;Calculate screen RAM pointer
    sta (scrpos_lo),y     ;Write the screen code to screen RAM
    jmp ctrl_0c           ;Jump out to advance the cursor and return

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
    !word ctrl_0a   ; Cursor down (Line feed)
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
    lda via_pcr  ;Remember current upper/lower graphic mode
    pha
    lda #$0e     ;CHR$(14) = Switch to lowercase mode
    jsr chrout   ;  and set more vertical space between chars
    pla
    sta via_pcr  ;Restore graphic mode
    rts

ctrl_17:
;Set line spacing to short (the default spacing for uppercase graphic mode).
;The current graphic mode will not be changed.
;
    lda via_pcr  ;Remember current upper/lower graphic mode
    pha
    lda #$8e     ;CHR$(142) = Switch to uppercase mode
    jsr chrout   ;  and set less vertical space between chars
    pla
    sta via_pcr  ;Restore graphic mode
    rts

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

ctrl_15:
;Go to uppercase mode
;
    lda #$80
    sta uppercase
    lda #$0c
    sta via_pcr           ;Graphic mode = uppercase
    rts

ctrl_16:
;Go to lowercase mode
;
    lda #$00
    sta uppercase
    lda #$0e
    sta via_pcr           ;Graphic mode = lowercase
    rts

ctrl_08:
;Cursor left
;
    ldx cursor_x
    bne ctrl_08_decx      ;X > 0? Y will not change.
    ldx x_width           ;X = max X + 1
    lda cursor_y
    beq ctrl_08_done      ;Y=0? Can't move up.
    dec cursor_y          ;Y=Y-1
ctrl_08_decx:
    dex
    stx cursor_x          ;X=X-1
ctrl_08_done:
    rts

ctrl_0b:
;Cursor up
;
    ldy cursor_y
    beq ctrl_0b_done      ;Y=0? Can't move up.
    dec cursor_y          ;Y=Y-1
ctrl_0b_done:
    rts

ctrl_0c:
;Cursor right
;
    inc cursor_x          ;X=X+1
    ldx cursor_x
    cpx x_width           ;X > max X?
    beq ctrl_0c_crlf
    rts                   ;  No:  Done, stay on the current line
ctrl_0c_crlf:
    jsr ctrl_0d           ;  Yes: Carriage return, then
    jmp ctrl_0a           ;       jump out to line feed

ctrl_0d:
;Carriage return
;
    lda #$00       ;Move to X=0 on this line
    sta cursor_x
    rts

ctrl_0a:
;Cursor down (Line feed)
;
    ldy cursor_y
    cpy #$18          ;Are we on the bottom line?
    bne ctrl_0a_incy  ;  No:  Increment Y, do not scroll up
    jmp scroll_up     ;  Yes: Y remains unchanged, jump out to scroll
ctrl_0a_incy:
    inc cursor_y      ;Increment Y position
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
    lda #$20           ;Space character
    ldx #$00
l_0829:
    sta screen,x
    sta screen+$100,x
    sta screen+$200,x
    sta screen+$300,x
    sta screen+$400,x
    sta screen+$500,x
    sta screen+$600,x
    sta screen+$700,x
    inx
    bne l_0829
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
    lda #$80
    sta rvs_mask
    rts

ctrl_0f:
;Reverse video off
;
    lda #$00
    sta rvs_mask
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

ctrl_04:
;Set TAB stop at current position
;
    ldx cursor_x     ;Get cursor position
    lda #$01
    sta tab_stops,x  ;Set a TAB stop at that position
    rts

ctrl_05:
;Clear TAB stop at current position
;
    ldx cursor_x     ;Get cursor position
    lda #$00
    sta tab_stops,x  ;Clear a TAB stop at that position
    rts

ctrl_06:
;Clear all TAB stops
;
    ldx #$4f         ;80 characters - 1
    lda #$00
l_08d8:
    sta tab_stops,x  ;Clear a TAB stop at this position
    dex
    bpl l_08d8       ;Loop until all stops are cleared
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

scan_keyb:
;Scan the keyboard.
; The PET/CBM uses a 10x8 keyboard matrix. There are 10 rows, and 8 columns.
; To scan you select a ROW by writing the ROW NUMBER to the pia1_row register. The lower 4 bits are sent to
; a 4 to 10 decoder. Then the PAI1COL register is read and each of the 8 bits represent one key in that row.
; IMPORTANT!!!! If a key is PRESSED the BIT will be ZERO.
; There are two keyboard tables which consists of 80 bytes each.
; One for "Graphic" (40 column) and one for "Business" (80 column).
;
; USES: SCANCODE  - Code of Pressed KEY ($FF=NONE)
;       LASTCODE  - Code of Previous KEY
;       ROWCOUNT  - Keyboard ROW counter
;       SHIFTFLAG - Shift Flag
;       KEYFLAG   - Regular Key Flag
;
    lda scancode           ;Old SCANCODE
    sta lastcode           ;Save It
    ldx #$00               ;X=0 Index into Keyboard Scan Table
    stx shiftflag          ;Reset Shift Flag
    stx keyflag            ;Reset Key Flag

    stx pia1_row           ;Select a keyboard ROW
    lda #$ff               ;$FF = no key
    sta scancode           ;Set it
    lda #$0a               ;Keyboard has 10 ROWS
    sta rowcount           ;ROW=10 - Keyboard ROW counter

;---- top of loop for keyboard ROWS
;
scan_row:
    ldy #$08               ;Y=8 -- 8 Columns in Table

debounce:
    lda pia1_col           ;PIA#1 Keyboard Columns Read
    cmp pia1_col           ;PIA#1 Keyboard Columns Read
    bne debounce           ;wait for stable value on keyboard switches (debounce)
                           ;Result of Row scan is now in A (call is SCANCODE)

;---- top of loop to go through each bit returned from scan. Each "0" bit represents a key pressed down

scan_col:
    lsr ;a                 ;Shift byte RIGHT leaving CARRY flag set if it is a "1"
    pha                    ;Push it to the stack
    bcs nextcol            ;Continue to next col if no key was detected

    bit x_width            ;80 columns?
    bvc skip40
    lda business_keys,x    ;  Yes, read from Business keyboard table
    jmp got_row
skip40:
    lda graphics_keys,x    ;  No,  read from Graphics keyboard table

got_row:
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
    inx                    ;X=X+1 - next entry in table
    dey                    ;Y=Y-1 - next BIT in scan value
    bne scan_col           ;Is it ZERO? No, go back for next COL

nextrow:
    inc pia1_row           ;Increment Keyboard scanning ROW register - PIA#1 Keyboard Row Select
    dec rowcount           ;ROW=ROW-1
    bne scan_row           ;Is ROW > 0 ? Yes, loop back up for next ROW

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
    bit uppercase
    bmi key_check2         ;Branch if uppercase mode
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
    bit uppercase
    bpl key_set            ;Branch if lowercase mode
    ora #$80               ;Set the HIGH BIT
    rts                    ;Return with character code in A?

;---- Return a terminal control code (CTRL_CODES table)
key_ctrl_code:
    txa                    ;Substitute the terminal control code
    rts                    ;Return with control code in A

key_set:
    cmp #$00               ;Set CARRY if non-zero character?
    rts


;40-column graphics keyboard table               ----- ----- ----- ----- ----- ----- ----- -----    Notes
graphics_keys:
    !byte $21,$23,$25,$26,$28,$5f,$1e,$0c ;  !     #     %     &     (     BARRW HOME  RIGHT    BARRW= Back Arrow
    !byte $22,$24,$27,$5c,$29,$ff,$0a,$7f ;  "     $     '     \     )     NONE  CSRDN DEL      NONE = No key
    !byte $51,$45,$54,$55,$4f,$5e,$37,$39 ;  Q     E     T     U     O     ^     7     9
    !byte $57,$52,$59,$49,$50,$ff,$38,$2f ;  W     R     Y     I     P     NONE  8     /
    !byte $41,$44,$47,$4a,$4c,$ff,$34,$36 ;  A     D     G     J     L     NONE  4     6
    !byte $53,$46,$48,$4b,$3a,$ff,$35,$2a ;  S     F     H     K     :     NONE  5     *
    !byte $5a,$43,$42,$4d,$3b,$0d,$31,$33 ;  Z     C     B     M     ;     RETRN 1     3
    !byte $58,$56,$4e,$2c,$3f,$ff,$32,$2b ;  X     V     N     ,     ?     NONE  2     +
    !byte $01,$40,$5d,$ff,$3e,$01,$30,$2d ;  SHIFT @     ]     NONE  >     SHIFT 0     -        SHIFT= $01
    !byte $00,$5b,$20,$3c,$1b,$ff,$2e,$3d ;  RVS   [     SPACE >     STOP  NONE  .     =        RVS  = $00 (CTRL key)

;80-column business keyboard table               ----- ----- ----- ----- ----- ----- ----- -----
business_keys:
    !byte $b2,$b5,$b8,$ad,$38,$0c,$ff,$ff ;  ^2    ^5    ^8    -     8     CSRRT NONE  NONE     ^ = Extra Bits Set
    !byte $b1,$b4,$b7,$30,$37,$5e,$ff,$39 ;  ^1    ^4    ^7    0     7     UARRW NONE  9        UARROW = Up Arrow
    !byte $1b,$53,$46,$48,$5d,$4b,$bb,$35 ;  ESC   S     F     H     ]     K     ;     5
    !byte $41,$44,$47,$4a,$0d,$4c,$40,$36 ;  A     D     G     J     RTRN  L     @     6
    !byte $09,$57,$52,$59,$5c,$49,$50,$7f ;  TAB   W     R     Y     \     I     P     DEL
    !byte $51,$45,$54,$55,$0a,$4f,$5b,$34 ;  Q     E     T     U     CSRDN O     [     4
    !byte $01,$43,$42,$ae,$2e,$ff,$01,$33 ;  SHIFT C     B     ^.    .     NONE  SHIFT 3
    !byte $5a,$56,$4e,$ac,$30,$ff,$ff,$32 ;  Z     V     N     ,     0     NONE  NONE  2
    !byte $00,$58,$20,$4d,$1e,$ff,$af,$31 ;  RVS   X     SPACE M     HOME  NONE  ^/    1
    !byte $5f,$b3,$b6,$b9,$ff,$ba,$ff,$ff ;  BARRW ^3    ^6    ^9    STOP  ^:    NONE  NONE

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

;Buffer for TAB stop positions (80 bytes: one for each screen column)
tab_stops:
    !fill $aa, $50
