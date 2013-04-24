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
scrline_lo  = $02     ;Pointer to start of current line in screen RAM - LO
scrline_hi  = $03     ;Pointer to start of current line in screen RAM - HI
cursor_x    = $04     ;Current X position: 0-79
cursor_y    = $05     ;Current Y position: 0-24
cursor_off  = $06     ;Cursor state: zero = show, nonzero = hide
scrcode_tmp = $07     ;Temporary storage for the last screen code
keycount    = $08     ;Number of keys in the buffer at keyd
columns     = $09     ;Screen width (X) in characters (40 or 80)
lines       = $0a     ;Screen height (Y) in characters (24 or 25)
moveto_cnt  = $0b     ;Counts down bytes to consume in a move-to (CTRL_1B) seq
cursor_tmp  = $0c     ;Pending cursor state used with CURSOR_OFF
source_lo   = $0d     ;Pointer to source address for memory operations - LO
source_hi   = $0e     ;Pointer to source address for memory operations - HI
target_lo   = $0f     ;Pointer to target address for memory operations - LO
target_hi   = $10     ;Pointer to target address for memory operations - HI
xfer_lo     = $11     ;Memory transfer byte counter - LO
xfer_hi     = $12     ;Memory transfer byte counter - HI
char_mask   = $13     ;Masks incoming bytes for 7- or 8-bit character mode
rtc_jiffies = $14     ;Real Time Clock Jiffies
rtc_secs    = $15     ;Real Time Clock Seconds   Note: the RTC and Jiffy
rtc_mins    = $16     ;Real Time Clock Minutes   locations can't be changed
rtc_hours   = $17     ;Real Time Clock Hours     because they are accessed by
jiffy2      = $18     ;Jiffy Counter (MSB)       the SoftBox BIOS to support
jiffy1      = $19     ;Jiffy Counter             CP/M programs like TIME.COM.
jiffy0      = $1a     ;Jiffy Counter (LSB)
blink_cnt   = $1b     ;Counts down number of IRQs until cursor reverses
uppercase   = $1c     ;Uppercase graphics flag (lower = $00, upper = $80)
rvs_mask    = $1d     ;Reverse video mask (normal = $00, reverse = $80)

    *=$0400

bas_header:
;"50 sys(1039)"
;  Note: The line number is used in a clever way.  It is changed by the
;  configuration utility NEWSYS to either 50 or 60.  This tells the program
;  the frequency (in Hertz) at which the CBM system interrupt occurs.
;
    !byte $00,$0d,$04,$32,$00,$9e,$28,$31
    !byte $30,$33,$39,$29,$00,$00,$00
;
    jmp init

copyright:
    !text "  SOFTBOX LOADER (C) COPYRIGHT 1981 KEITH FREWIN  "

init:
    sei                 ;Disable interrupts
    ldx #$ff
    tsx                 ;Initialize stack pointer
    lda #<irq_handler
    sta cinv_lo
    lda #>irq_handler
    sta cinv_hi         ;Install our interrupt handler
    lda #$00
    sta rtc_jiffies     ;Reset software real time clock
    sta rtc_secs
    sta rtc_mins
    sta rtc_hours
    sta jiffy2          ;Reset jiffy counter
    sta jiffy1
    sta jiffy0
    sta keycount        ;Reset key counter (no keys hit)
    lda #$0a
    sta repeatcount1    ;Number of interrupts between repeats of a key
    cli                 ;Enable interrupts again

init_scrn:
;Initialize the screen
;
;This routine checks for an 80 column screen by writing to screen RAM
;that should not be present on a 40 column machine.  If the computer
;has been modified so that it has a 40 column screen but the extra
;screen RAM is present, this routine will think the machine has 80 columns.
;The number of columns detected is stored in COLUMNS.
;
;COLUMNS is also used in the keyboard scanning routine to select between
;business keyboard (80 columns) or graphics keyboard (40 columns).  This
;means the 2001B machines (40-column, business keyboard) are not supported.
;
    lda #25
    sta lines           ;Initialize screen height to 25 lines
    lda #40
    sta columns         ;Initialize screen width to 40 columns
    lda #$55
    sta screen          ;Store #$55 in first byte of screen RAM.
    asl ;a
    sta screen+$400     ;Store #$AA in first byte of 80 col page.
    cmp screen+$400     ;Does it read back correctly?
    bne init_scrn_done  ;  No: we're done, columns = 40.
    lsr ;a
    cmp screen          ;Is the #$55 still intact?
    bne init_scrn_done  ;  No: incomplete decoding, columns = 40
    asl columns         ;  Yes: columns = 80 characters
init_scrn_done:
    lda #$14
    sta blink_cnt       ;Initialize cursor blink countdown
    lda #$00
    sta cursor_off      ;Cursor state = show the cursor
                        ;Fall through into init_term

init_term:
    jsr ctrl_16         ;Go to lowercase mode
    jsr ctrl_02         ;Go to 7-bit character mode
    jsr ctrl_06         ;Clear all tab stops
    lda #$00
    sta moveto_cnt      ;Move-to counter = not in a move-to seq
    lda #$1a            ;Load #$1A = CTRL_1A Clear Screen
    jsr process_byte    ;Call into terminal to execute clear screen

init_ieee:
;
;6522 VIA            6520 PIA #1            6520 PIA #2
;  PB0: NDAC_IN       PA0-7: Data In         CA1: ATN_IN
;  PB1: NRFD_OUT      PB0-7: Data Out        CA2: NDAC_OUT
;  PB2: ATN_OUT       CA2: EOI_OUT           CB1: SRQ_IN
;  PB6: NFRD_IN                              CB2: DAV_OUT
;  PB7: DAV_IN
;
    lda pia2_iout       ;Read clears IRQA1 flag (ATN_IN detect)

    lda via_pb
    and #%11111011
    sta via_pb          ;ATN_OUT=low

    lda #%00110100
    sta pia2_dav        ;DAV_OUT=low

    lda #$c6
    sta pia2_iout       ;Put #$39 on IEEE data lines

    ldy #$00
l_04d4:
    dey
    bne l_04d4          ;Let #$39 sit on the lines so the SoftBox sees it

    lda #$ff
    sta pia2_iout       ;Release IEEE data lines

    lda #%00111100
    sta pia1_eoi        ;EOI_OUT=high, disable IRQ from CA1 (Cassette Read)
    sta pia2_ndac       ;NDAC_OUT=high, disable IRQ from CA1 (ATN_IN)
    sta pia2_dav        ;DAV_OUT=high, disable IRQ from CB1 (SRQ_IN),
                        ;  CB1 transition mode = positive (low-to-high)

main_loop:
    lda #%00111100
    sta pia2_ndac       ;NDAC_OUT=high

    lda via_pb
    ora #%00000110
    sta via_pb          ;NRFD_OUT=high, ATN_OUT=high

wait_for_srq:
    bit pia2_dav        ;Bit 7 = IRQB1 flag for CB1 (SRQ_IN detect)
    bpl wait_for_srq    ;Wait until positive transition on SRQ_IN is detected

    lda pia2_iout       ;Read clears IRQB1 flag (SRQ_IN detect)

    lda #%00110100
    sta pia2_ndac       ;NDAC_OUT=low

    lda pia2_ieee       ;Read IEEE data byte from SoftBox
    eor #$ff            ;Invert it (IEEE-488 uses negative logic)
    and #%00111111      ;Remove bits 7-6 which are only used for handshaking
    tax                 ;Save the command byte in X

                        ;The hardware of both the PET/CBM machines and the
                        ;SoftBox allows each IEEE-488 data line to be
                        ;individually selected as an input or output.  The
                        ;SoftBox exploits this by using the lower 6 bits of
                        ;the data bus to output a command, while the upper
                        ;2 bits are used as input:
                        ;
                        ;Bits 7-6: CBM to SoftBox: Handshake & key status
                        ;Bits 5-0: SoftBox to CBM: Command

    lda #$bf            ;Response will be $40 (no key available)
    ldy keycount        ;Is the keyboard buffer empty?
    beq send_key_avail  ;  Yes: Keep response as $40 (no key available)
    lda #$7f            ;  No:  Response will be $80 (key available)

send_key_avail:
    sta pia2_iout       ;Put keyboard status on the data lines

handshake:
    lda pia2_ieee       ;Read IEEE data byte
    and #%00111111      ;Mask off bits 7-6 since we are driving them
    cmp #%00111111
    bne handshake       ;Wait for the SoftBox to release the other lines

    lda #$ff
    sta pia2_iout       ;Release all data lines

dispatch_command:
    cpx #$01            ;$01 = Key availability (sent with handshake, so done)
    beq main_loop
    cpx #$02            ;$02 = Wait for a key and send it
    beq do_get_key
    cpx #$04            ;$04 = Write to the terminal screen
    beq do_terminal
    cpx #$08            ;$08 = Jump to a subroutine in CBM memory
    beq do_execute
    cpx #$10            ;$10 = Transfer from CBM memory to the SoftBox
    beq do_peek
    cpx #$20            ;$20 = Transfer from the SoftBox to CBM memory
    beq do_poke
    jmp main_loop       ;Bad command

do_get_key:
;Wait for a key and send it to the SoftBox.
;
;At the CP/M "A>" prompt, the SoftBox sends this command and then
;waits for the CBM to return a key.
;
    jsr get_key         ;Block until we get a key.  Key will be in A.
    jsr ieee_put_byte   ;Send the key to the Softbox.
    jmp main_loop

do_terminal:
;Write to the terminal screen
;
    jsr ieee_get_byte
    jsr process_byte
    jmp main_loop

do_execute:
;Execute a subroutine in CBM memory
;
    jsr ieee_get_byte   ;Get byte
    sta target_lo       ; -> Target vector lo
    jsr ieee_get_byte   ;Get byte
    sta target_hi       ; -> Target vector hi
    jsr do_execute_ind  ;Jump to the subroutine through TARGET_LO
    jmp main_loop
do_execute_ind:
    jmp (target_lo)

do_peek:
;Transfer bytes from CBM memory to the SoftBox
;
    jsr ieee_get_byte
    sta xfer_lo
    jsr ieee_get_byte
    sta xfer_hi
    jsr ieee_get_byte
    sta source_lo
    jsr ieee_get_byte
    sta source_hi

    ldy #$00
l_05a5:
    dey
    bne l_05a5          ;Delay loop

l_05a8:
    lda (source_lo),y
    jsr ieee_put_byte
    iny
    bne l_05b2
    inc source_hi
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

do_poke:
;Transfer bytes from the SoftBox to CBM memory
;
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
    ora #%00000010
    sta via_pb          ;NRFD_OUT=high

l_05d7:
    bit via_pb
    bmi l_05d7          ;Wait until DAV_IN=low

    lda pia2_ieee       ;Read data byte
    eor #$ff            ;Invert it
    pha                 ;Push data byte

    lda via_pb
    and #%11111101
    sta via_pb          ;NRFD_OUT=low

    lda #%00111100
    sta pia2_ndac       ;NDAC_OUT=high

l_05ef:
    bit via_pb
    bpl l_05ef          ;Wait until DAV_IN=high

    lda #%00110100
    sta pia2_ndac       ;NDAC_OUT=low

    pla
    rts

ieee_put_byte:
;Send a byte to the SoftBox over the IEEE-488 bus.
;
    eor #$ff            ;Invert the byte
    sta pia2_iout       ;Put byte on IEEE data output lines

    lda via_pb
    ora #%00000010
    sta via_pb          ;NRFD_OUT=high

    lda #%00111100
    sta pia2_ndac       ;NDAC_OUT=high

l_060d:
    bit via_pb
    bvc l_060d          ;Wait until NRFD_IN=high

    lda #%00110100
    sta pia2_dav        ;DAV_OUT=low

l_0617:
    lda via_pb
    lsr ;a
    bcc l_0617          ;Wait until NDAC_IN=high

    lda #%00111100
    sta pia2_dav        ;DAV_OUT=high

    lda #$ff
    sta pia2_iout       ;Release data lines

l_0627:
    lda via_pb
    lsr ;a
    bcs l_0627          ;Wait until NDAC_IN=low
    rts

get_key:
;Get the next key waiting from the keyboard buffer and return
;it in the accumulator.  If there is no key, this routine will
;block until it gets one.  Meanwhile, the interrupt handler
;calls SCAN_KEYB and puts any key into the buffer.
;
    lda #$ff            ;FF = no key
    sei                 ;Disable interrupts
    ldx keycount        ;Is there a key waiting in the buffer?
    beq l_0649          ;  No: nothing to do with the buffer.
    lda keyd            ;Read the next key in the buffer (FIFO)
    pha                 ;Push the key onto the stack
    ldx #$00
    dec keycount        ;Keycount = Keycount - 1
l_063d:
    lda keyd+1,x        ;Remove the key from the buffer by rotating
    sta keyd,x          ;  bytes in the buffer to the left
    inx
    cpx keycount        ;Finished updating the buffer?
    bne l_063d          ;  No: loop until we're done.
    pla                 ;Pull the key off the stack.
l_0649:
    cli                 ;Enable interrupts again
    cmp #$ff            ;No key or key is "NONE" in the tables?
    beq get_key         ;  No key:  loop until we get one.
    rts                 ;  Got key: done.  Key is now in A.

irq_handler:
;On PET/CBM, an IRQ occurs at 50 or 60 Hz depending on the model and ROMs.
;The 6502 calls the main IRQ entry point ($E442 on BASIC 4.0) which pushes
;A, X, and Y onto the stack and then executes JMP (cinv_lo).  We install
;this routine, IRQ_HANDLER, into cinv_lo during init.
;
    inc jiffy0          ;Counts number of Interrupts
    bne irq_clock
    inc jiffy1          ;counter
    bne irq_clock
    inc jiffy2          ;counter

irq_clock:
;Update the jiffy clock
    inc rtc_jiffies     ;Increment Jiffies
    lda rtc_jiffies
    cmp bas_header+3    ;50 or 60 (Hz).  See note in BAS_HEADER.
    bne irq_blink
    lda #$00            ;Reset RTC_JIFFIES counter
    sta rtc_jiffies
    inc rtc_secs        ;Increment Seconds
    lda rtc_secs
    cmp #$3c            ;Have we reached 60 seconds?
    bne irq_blink       ;   No, skip
    lda #$00            ;   Yes, reset seconds
    sta rtc_secs
    inc rtc_mins        ;Increment Minutes
    lda rtc_mins
    cmp #$3c            ;Have we reached 60 minutes?
    bne irq_blink       ; No, skip
    lda #$00            ; Yes, reset minutes
    sta rtc_mins
    inc rtc_hours       ;Increment hours
    lda rtc_hours
    cmp #$18            ;Have we reached 24 hours?
    bne irq_blink       ; No, skip
    lda #$00            ; Yes, reset hours
    sta rtc_hours

irq_blink:
;Blink the cursor
    lda cursor_off      ;Is the cursor off?
    bne irq_repeat          ;  Yes: skip cursor blink
    dec blink_cnt       ;Decrement cursor blink countdown
    bne irq_repeat          ;Not time to blink? Done.
    lda #$14
    sta blink_cnt       ;Reset cursor blink countdown
    jsr calc_scrline
    lda (scrline_lo),y  ;Read character at cursor
    eor #$80            ;Flip the REVERSE bit
    sta (scrline_lo),y  ;Write it back

irq_repeat:
;Repeat key handling
    lda scancode        ;Get the SCANCODE
    cmp repeatcode      ;Compare to SAVED scancode
    beq l_06b1          ;They are the same, so continue
    sta repeatcode      ;if not, save it
    lda #$10            ;reset counter
    sta repeatcount0    ;save to counter
    bne irq_scan
l_06b1:
    cmp #$ff            ; NO KEY?
    beq irq_scan        ; Yes, jump to scan for another
    lda repeatcount0    ; No, there was a key, so get the counter
    beq l_06bf          ; Is it zero?
    dec repeatcount0    ; Count Down
    bne irq_scan        ; Is it Zero
l_06bf:
    dec repeatcount1    ; Count Down
    bne irq_scan        ; Is it zero? No, scan for another
    lda #$04            ; Yes, Reset it to 4
    sta repeatcount1    ; Store it
    lda #$00            ;Clear the SCANCODE and allow the key to be processed
    sta scancode        ;Store it
    lda #$02
    sta blink_cnt       ;Fast cursor blink(?)

irq_scan:
;Scan the keyboard
    jsr scan_keyb       ;Scan the keyboard
                        ;  An important side effect of scan_keyb is
                        ;  that it reads pia1_col.  The read clears
                        ;  PIA #1's IRQB1 flag (50/60 Hz interrupt).
                        ;  If this read is not performed, IRQ will
                        ;  continuously retrigger.
    beq irq_done        ;Nothing to do if no key was pressed.
    ldx keycount
    cpx #$50            ;Is the keyboard buffer full?
    beq irq_done        ;  Yes:  Nothing we can do.  Forget the key.
    sta keyd,x          ;  No:   Store the key in the buffer
    inc keycount        ;        and increment the keycount.

irq_done:
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
    lda cursor_off      ;Get the current cursor state
    sta cursor_tmp      ;  Remember it
    lda #$ff
    sta cursor_off      ;Hide the cursor
    jsr calc_scrline    ;Calculate screen RAM pointer
    lda scrcode_tmp     ;Get the screen code previously saved
    sta (scrline_lo),y  ;  Put it on the screen
    pla
    and char_mask       ;Mask off bits depending on char mode
    ldx moveto_cnt      ;More bytes to consume for a move-to sequence?
    bne process_move    ;  Yes: branch to jump to move-to handler
    cmp #$20            ;Is this byte a control code?
    bcs process_char    ;  No: branch to put char on screen
process_ctrl:
    asl ;a
    tax
    lda ctrl_codes,x    ;Load vector from control code table
    sta target_lo
    lda ctrl_codes+1,x
    sta target_hi
    jsr process_ctrl_ind  ;JSR to control code handler through vector
    jmp process_done
process_ctrl_ind:
    jmp (target_lo)
process_move:
    jsr move_to         ;JSR to move-to sequence handler
    jmp process_done
process_char:
    jsr put_char        ;JSR to put a character on the screen
process_done:
    jsr calc_scrline    ;Calculate screen RAM pointer
    lda (scrline_lo),y  ;Get the current character on the screen
    sta scrcode_tmp     ;  Remember it
    lda cursor_tmp      ;Get the previous state of the cursor
    sta cursor_off      ;  Restore it
    rts

move_to:
;Implements CTRL_1B by handling the X-position byte on the first call
;and the Y-position byte on the second call.  After the Y-position byte
;has been consumed, MOVETO_CNT = 0, exiting the move-to sequence.
;
    sec
    sbc #$20            ;Pos = Pos - #$20 (ADM-3A compatibility)

    dec moveto_cnt      ;Decrement bytes remaining to consume
    beq move_to_y       ;Already got X pos?  Handle this byte as Y.
                        ;Fall through into move_to_x
move_to_x:
    cmp columns         ;Requested X position out of range?
    bcs move_to_x_done  ;  Yes: Do nothing.
    sta cursor_x        ;  No:  Move cursor to requested X.
move_to_x_done:
    rts

move_to_y:
    cmp lines           ;Requested Y position out of range?
    bcs move_to_y_done  ;  Yes: Do nothing.
    sta cursor_y        ;  No:  Move cursor to requested Y.
move_to_y_done:
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
    cmp #$40            ;Is it < 64?
    bcc put_scrcode     ;  Yes: done, put it on the screen
    cmp #$60            ;Is it >= 96?
    bcs l_07a6          ;  Yes: branch to L_07A6
    and #$3f            ;Turn off bits 6 and 7
    jmp l_07ac          ;Jump to L_07AC
l_07a6:
    cmp #$80            ;Is bit 7 set?
    bcs l_07ca          ;  Yes: branch to L_07CA
    and #$5f
l_07ac:
    tax
    and #$3f            ;Turn off bit 7 and bit 6
    beq l_07c6
    cmp #$1b
    bcs l_07c6
    txa
    eor #$40            ;Flip bit 6
    bit uppercase
    bpl put_scrcode     ;Branch if lowercase mode
    and #$1f
    jmp put_scrcode
l_07c6:
    txa
    jmp put_scrcode
l_07ca:
    and #$7f            ;Turn off bit 7
    ora #$40            ;Turn on bit 6
put_scrcode:
    eor rvs_mask        ;Reverse the screen code if needed
    jsr calc_scrline    ;Calculate screen RAM pointer
    sta (scrline_lo),y  ;Write the screen code to screen RAM
    jmp ctrl_0c         ;Jump out to advance the cursor and return

ctrl_codes:
;Terminal control code dispatch table.  These control codes are based
;on the Lear Seigler ADM-3A terminal.  Some bytes that are unused on
;that terminal are used for other purposes here.
;
                    ;Hex  Keyboard
    !word ctrl_00   ;00   CTRL-@    Do nothing
    !word ctrl_01   ;01   CTRL-A    Go to 8-bit character mode
    !word ctrl_02   ;02   CTRL-B    Go to 7-bit character mode
    !word ctrl_03   ;03   CTRL-C    Do nothing
    !word ctrl_04   ;04   CTRL-D    Set a TAB stop at current position
    !word ctrl_05   ;05   CTRL-E    Clear TAB stop at current position
    !word ctrl_06   ;06   CTRL-F    Clear all TAB stops
    !word ctrl_07   ;07   CTRL-G    Ring bell
    !word ctrl_08   ;08   CTRL-H    Cursor left
    !word ctrl_09   ;09   CTRL-I    Perform TAB
    !word ctrl_0a   ;0A   CTRL-J    Cursor down (Line feed)
    !word ctrl_0b   ;0B   CTRL-K    Cursor up
    !word ctrl_0c   ;0C   CTRL-L    Cursor right
    !word ctrl_0d   ;0D   CTRL-M    Carriage return
    !word ctrl_0e   ;0E   CTRL-N    Reverse video on
    !word ctrl_0f   ;0F   CTRL-O    Reverse video off
    !word ctrl_10   ;10   CTRL-P    Cursor off
    !word ctrl_11   ;11   CTRL-Q    Insert a blank line
    !word ctrl_12   ;12   CTRL-R    Scroll up one line
    !word ctrl_13   ;13   CTRL-S    Clear to end of line
    !word ctrl_14   ;14   CTRL-T    Clear to end of screen
    !word ctrl_15   ;15   CTRL-U    Go to uppercase mode
    !word ctrl_16   ;16   CTRL-V    Go to lowercase mode
    !word ctrl_17   ;17   CTRL-W    Set line spacing to tall
    !word ctrl_18   ;18   CTRL-X    Set line spacing to short
    !word ctrl_19   ;19   CTRL-Y    Cursor on
    !word ctrl_1a   ;1A   CTRL-Z    Clear screen
    !word ctrl_1b   ;1B   ESC       Move cursor to X,Y position
    !word ctrl_1c   ;1C   CTRL-/    Insert a space on current line
    !word ctrl_1d   ;1D   CTRL-]    Delete character at cursor
    !word ctrl_1e   ;1E   CTRL-^    Home cursor
    !word ctrl_1f   ;1F             Do nothing

ctrl_07:
;Ring bell
;
    lda #$07            ;CHR$(7) = Bell
    jmp chrout

ctrl_18:
;Set line spacing to tall (the default spacing for lowercase graphic mode).
;The current graphic mode will not be changed.
;
    lda via_pcr         ;Remember current upper/lower graphic mode
    pha
    lda #$0e            ;CHR$(14) = Switch to lowercase mode
    jsr chrout          ;  and set more vertical space between chars
    pla
    sta via_pcr         ;Restore graphic mode
    rts

ctrl_17:
;Set line spacing to short (the default spacing for uppercase graphic mode).
;The current graphic mode will not be changed.
;
    lda via_pcr         ;Remember current upper/lower graphic mode
    pha
    lda #$8e            ;CHR$(142) = Switch to uppercase mode
    jsr chrout          ;  and set less vertical space between chars
    pla
    sta via_pcr         ;Restore graphic mode
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
    sta via_pcr         ;Graphic mode = uppercase
    rts

ctrl_16:
;Go to lowercase mode
;
    lda #$00
    sta uppercase
    lda #$0e
    sta via_pcr         ;Graphic mode = lowercase
    rts

ctrl_08:
;Cursor left
;
    ldx cursor_x
    bne ctrl_08_decx    ;X > 0? Y will not change.
    ldx columns         ;X = max X + 1
    lda cursor_y
    beq ctrl_08_done    ;Y=0? Can't move up.
    dec cursor_y        ;Y=Y-1
ctrl_08_decx:
    dex
    stx cursor_x        ;X=X-1
ctrl_08_done:
    rts

ctrl_0b:
;Cursor up
;
    ldy cursor_y
    beq ctrl_0b_done    ;Y=0? Can't move up.
    dec cursor_y        ;Y=Y-1
ctrl_0b_done:
    rts

ctrl_0c:
;Cursor right
;
    inc cursor_x        ;X=X+1
    ldx cursor_x
    cpx columns         ;X > max X?
    beq ctrl_0c_crlf
    rts                 ;  No:  Done, stay on the current line
ctrl_0c_crlf:
    ldx #$00
    stx cursor_x        ;  Yes: Carriage return, then
    jmp ctrl_0a         ;       jump out to line feed

ctrl_0d:
;Carriage return
;
    ldx #$00            ;Move to X=0 on this line
    stx cursor_x
    rts

ctrl_0a:
;Cursor down (Line feed)
;
    ldy cursor_y
    iny
    cpy lines           ;Are we on the bottom line?
    bne ctrl_0a_incy    ;  No:  Increment cursor_y, do not scroll up
    jmp scroll_up       ;  Yes: Do not change cursor_y, jump out to scroll
ctrl_0a_incy:
    inc cursor_y        ;Increment Y position
    rts

ctrl_1e:
;Home cursor
;
    lda #$00
    sta cursor_y
    sta cursor_x
    rts

ctrl_1a:
;Clear screen
;
    jsr ctrl_0f         ;Reverse video off
    jsr ctrl_1e         ;Home cursor
    lda #$20            ;Space character
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
    jsr calc_scrline    ;Leaves CURSOR_X in Y register
    lda #$20            ;Space character
l_0863:
    sta (scrline_lo),y  ;Write space to screen RAM
    iny                 ;X=X+1
    cpy columns
    bne l_0863          ;Loop until end of line
    rts

ctrl_14:
;Clear from current line to end of screen
;
    jsr ctrl_13         ;Clear to the end of the current line
    ldx cursor_y        ;Get current Y position
ctrl_14_next:
    inx                 ;Y=Y+1
    cpx lines           ;Incremented past last line?
    beq ctrl_14_done    ;  Yes: done
    clc                 ;Advance scrline pointer
    lda scrline_lo
    adc columns
    sta scrline_lo
    bcc ctrl_14_eraline
    inc scrline_hi
ctrl_14_eraline:
    lda #$20            ;Space character
    ldy columns
ctrl_14_erachar:
    dey
    sta (scrline_lo),y
    bne ctrl_14_erachar ;Loop until entire line is erased
    beq ctrl_14_next    ;Continue to the next line
ctrl_14_done:
    rts

ctrl_04:
;Set TAB stop at current position
;
    ldx cursor_x        ;Get cursor position
    lda #$01
    sta tab_stops,x     ;Set a TAB stop at that position
    rts

ctrl_05:
;Clear TAB stop at current position
;
    ldx cursor_x        ;Get cursor position
    lda #$00
    sta tab_stops,x     ;Clear a TAB stop at that position
    rts

ctrl_06:
;Clear all TAB stops
;
    ldx #$4f            ;80 characters - 1
    lda #$00
l_08d8:
    sta tab_stops,x     ;Clear a TAB stop at this position
    dex
    bpl l_08d8          ;Loop until all stops are cleared
    rts

ctrl_09:
;Perform TAB.  Move to next TAB STOP as indicated in the TAB_STOPS table.
;
    ldx cursor_x
l_08e1:
    inx                 ;next position
    cpx #$50            ;80 characters?
    bcs l_08ed          ;  yes, exit
    lda tab_stops,x     ;read from the TAB STOPS table
    beq l_08e1          ;is it zero? yes, loop again
    stx cursor_x        ;  no, we hit a STOP, so store the position
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
    lda #$02            ;Two more bytes to consume (X-pos, Y-pos)
    sta moveto_cnt      ;Store count for next pass of PROCESS_BYTE
    rts

ctrl_1c:
;Insert space at current cursor position
;
    jsr calc_scrline
    ldy columns         ;number of characters on line
    dey
l_08f4:
    cpy cursor_x
    beq l_0901
    dey
    lda (scrline_lo),y  ;read a character from line
    iny                 ;position to the right
    sta (scrline_lo),y  ;write it back
    dey                 ;we are counting down to zero
    bne l_08f4          ;loop for another character
l_0901:
    lda #$20            ;SPACE
    sta (scrline_lo),y  ;Write it to current character position
    rts

ctrl_1d:
;Delete a character
;
    jsr calc_scrline    ;Leaves cursor_x in Y register
l_090b:
    iny
    cpy columns
    beq l_0918
    lda (scrline_lo),y  ;read a character from the line
    dey                 ;position to the left
    sta (scrline_lo),y  ;write it back
    iny                 ;we are counting UP
    bne l_090b          ;loop for another character
l_0918:
    dey
    lda #$20            ;SPACE
    sta (scrline_lo),y  ;write it to the current character position
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
    jsr calc_scrline
    lda scrline_lo
    clc
    adc columns
    sta source_lo
    lda scrline_hi
    adc #$00
    sta source_hi
    ldx lines
    dex
    txa
    sec
    sbc cursor_y
    tax
    jmp scroll

ctrl_11:
;Insert a blank line
;
;The screen is shifted downward so that each line Y is copied into Y+1.
;The line at the current position will be erased (filled with spaces).
;The current cursor position will not be changed.
;
    lda #<screen+$0780  ;Start address of last 80 col line
    ldy #>screen+$0780
    bit columns         ;80 columns?
    bvs l_0949          ;  Yes: branch to keep address for 80 col
    lda #<screen+$03c0  ;Start address of last 40 col line
    ldy #>screen+$03c0
l_0949:
    sta source_lo
    sty source_hi
    lda #$00
    sta cursor_x
l_0951:
    lda source_lo
    cmp scrline_lo
    bne l_095d
    lda source_hi
    cmp scrline_hi
    beq l_097c
l_095d:
    lda source_lo
    sta target_lo
    sec
    sbc columns
    sta source_lo
    lda source_hi
    sta target_hi
    sbc #$00
    sta source_hi
    ldy columns
    dey
l_0970:
    lda (source_lo),y
    sta (target_lo),y
    dey
    bpl l_0970
    bmi l_0951
l_097c:
    lda #$20            ;SPACE
    ldy columns
l_0980:
    dey
    sta (scrline_lo),y
    bne l_0980
    rts

calc_scrline:
;Calculate a new pointer (scrline) to the first byte of the current
;line in screen RAM by multiplying cursor_y by 40 or 80.
;
;Preserves A and X.
;Returns cursor_x in Y.
;
    tay
    lda #$00
    sta scrline_hi      ;Initialize high byte to zero
    lda cursor_y
    sta scrline_lo      ;Initialize low byte to row number (Y-pos)

                        ;Multiply by ( 2 * 2 + 1 ) * 2 * 2 * 2 = 40
    asl ;a              ;  * 2
    asl ;a              ;  * 2
    adc scrline_lo      ;  + 1
    asl ;a              ;  * 2
    asl ;a              ;  * 2
    rol scrline_hi      ;  Rotate any carry into high byte
    asl ;a              ;  * 2
    rol scrline_hi      ;  Rotate any additional carry into high byte
    sta scrline_lo      ;  Save row number (Y-pos) multiplied by 40

    bit columns         ;80 columns?
    bvc l_09a8          ;  No: done multiplying
    asl scrline_lo
    rol scrline_hi      ;  Yes: multiply by 2 again

l_09a8:
    lda scrline_hi      ;Add screen base address to high byte
    clc
    adc #>screen
    sta scrline_hi

    tya                 ;Return with column (X-pos) in Y register
    ldy cursor_x
    rts

scroll_up:
;Scroll the screen up one line
;
    lda #$00
    sta scrline_lo
    lda columns
    sta source_lo
    lda #>screen
    sta scrline_hi
    sta source_hi
    ldx lines
    dex
scroll:
    ldy columns
    dey
l_08a0:
    lda (source_lo),y
    sta (scrline_lo),y
    dey
    bpl l_08a0
    lda source_lo
    sta scrline_lo
    clc
    adc columns
    sta source_lo
    lda source_hi
    sta scrline_hi
    adc #$00
    sta source_hi
    dex
    bne scroll
    lda #$20            ;SPACE
    ldy columns
l_08c1:
    dey
    sta (scrline_lo),y
    bne l_08c1
    rts

scan_keyb:
;Scan the keyboard.
;
;The PET/CBM machines use a 10x8 keyboard matrix.  There are 10 rows and
;8 columns.  To scan you select a row by writing the row number to the
;pia1_row register.  The lower 4 bits are sent to a 4 to 10 decoder.  The
;pia1_col register is then read and each of the 8 bits represent one key
;in that row.  If a key is pressed, the bit will be zero.
;
;There are two keyboard tables: one for "graphics" (40 columns) and
;one for "business" (80 columns).
;
;Uses: scancode   - Code of Pressed KEY ($FF=NONE)
;      lastcode   - Code of Previous KEY
;      rowcount   - Keyboard ROW counter
;      shift_flag - SHIFT key flag
;      ctrl_flag  - CTRL key flag
;
    lda scancode        ;Old SCANCODE
    sta lastcode        ;Save It
    ldx #$00            ;X=0 Index into Keyboard Scan Table
    stx shift_flag      ;Reset SHIFT key flag
    stx ctrl_flag       ;Reset CTRL key flag

    stx pia1_row        ;Select a keyboard ROW
    lda #$ff            ;$FF = no key
    sta scancode        ;Set it
    lda #$0a            ;Keyboard has 10 ROWS
    sta rowcount        ;ROW=10 - Keyboard ROW counter

;---- top of loop for keyboard ROWS
;
scan_row:
    ldy #$08            ;Y=8 -- 8 Columns in Table

debounce:
    lda pia1_col        ;PIA#1 Keyboard Columns Read
    cmp pia1_col        ;PIA#1 Keyboard Columns Read
    bne debounce        ;wait for stable value on keyboard switches (debounce)
                        ;Result of Row scan is now in A (call is SCANCODE)

;---- top of loop to go through each bit returned from scan. Each "0" bit represents a key pressed down

scan_col:
    lsr ;a              ;Shift byte RIGHT leaving CARRY flag set if it is a "1"
    pha                 ;Push it to the stack
    bcs nextcol         ;Continue to next col if no key was detected

    bit columns         ;80 columns?
    bvc skip40
    lda business_keys,x ;  Yes, read from Business keyboard table
    jmp got_row
skip40:
    lda graphics_keys,x ;  No,  read from Graphics keyboard table

got_row:
    cmp #$01            ;Is it the SHIFT key?
    beq key_shift       ;  Yes: branch to handle SHIFT
    bcc key_ctrl        ;  No:  if it is < 1 then it is CTRL key,
                        ;         branch to handle CTRL key

    sta scancode        ;Store the SCANCODE as-is
    bcs nextcol         ;Always branch to nextcol

key_shift:
    inc shift_flag      ;Increment SHIFT key flag
    bne nextcol         ;Always branch to nextcol

key_ctrl:
    inc ctrl_flag       ;Increment CTRL key flag
                        ;Fall through to nextcol

nextcol:
    pla                 ;pull the original scan value from stack
    inx                 ;X=X+1 - next entry in table
    dey                 ;Y=Y-1 - next BIT in scan value
    bne scan_col        ;Is it ZERO? No, go back for next COL

nextrow:
    inc pia1_row        ;Increment Keyboard scanning ROW register - PIA#1 Keyboard Row Select
    dec rowcount        ;ROW=ROW-1
    bne scan_row        ;Is ROW > 0 ? Yes, loop back up for next ROW

;-------------------------------------- end of scanning loops
; Check if there is anything to do. SCANCODE will be $FF if no key.
; If the SCANCODE = LASTCODE then key is being held down. Don't do anything until it is released.
; The IRQ handler implements key repeat by clearing the SCANCODE after a short interval.

    lda scancode        ;Get the current SCANCODE
    cmp #$ff            ;Is it NO KEY?
    beq keydone         ; Yes, exit

    cmp lastcode        ;Is it the same as last? (Key is registered on key UP?)
    beq keydone         ; Yes, exit

key_check1:
    cmp #$00            ;Is bit 7 set?
    bpl key_low         ;  No: branch to key_low

key_hi:
    and #$7f            ;Remove the TOP bit (shift flag for character?)
    ldy shift_flag      ;Check SHIFT Flag
    beq key_low         ;SHIFT=0? Yes, skip
    eor #$10            ;No, flip BIT 4 (what does bit 4 do?)
    rts

;---- Check if in A-Z range
key_low:
    cmp #$40            ;Start of compare to A-Z Range. "@" is lower limit?
    bcc key_check2      ;It is below? Yes, must be COMMAND character
    cmp #$60            ;Compare to upper ascii limit?
    bcs key_check2      ;Is it above the A-Z range? Yes, skip

;---- Check CTRL key flag
    ldy ctrl_flag       ;Check CTRL key flag
    beq key_atoz        ;Is it zero? Yes, skip
    and #$1f            ;RETURN CTRL-A to Z - Use only the lower 5 BITS (0 to 31)

keydone:
    rts

;---- Check A to Z or CTRL key
key_atoz:
    cmp #$40            ;Compare to "@" symbol
    beq key_check2
    cmp #$5b            ;Compare to "[" symbol?
    bcs key_check2

    ldy shift_flag      ;Is SHIFT Flag set?
    bne key_check2      ; No,skip to next test

;---- Handle regular A-Z
    bit uppercase
    bmi key_check2      ;Branch if uppercase mode
    ora #$20            ;Convert character to UPPERCASE HERE
    rts                 ;Return with character code in A

;---- Check SHIFT flag
key_check2:
    ldy shift_flag      ;Check SHIFT flag for zero
    beq key_set         ;  Yes, skip out

;---- Translate SHIFTED 0-31 codes to terminal control codes
key_sh_codes:
    ldx #$0b            ;Change to $0b (cursor up)
    cmp #$0a            ;  from $0a (cursor down)
    beq key_in_x
    ldx #$08            ;Change to $08 (cursor left)
    cmp #$0c            ;  from $0c (cursor right)
    beq key_in_x
    ldx #$1a            ;Change to $1a (clear screen)
    cmp #$1e            ;  from $1e (home)
    beq key_in_x
    ldx #$7b            ;Change to $7b ( { )
    cmp #$5b            ;  from $5b ( [ )
    beq key_in_x
    ldx #$7c            ;Change to $7c ( | )
    cmp #$5c            ;  from $5c ( \ )
    beq key_in_x
    ldx #$7d            ;Change to $7d ( } )
    cmp #$5d            ;  from $5d ( ] )
    beq key_in_x
    ldx #$7e            ;Change to $7e ( ~ )
    cmp #$5e            ;  from $5e ( ^ )
    beq key_in_x

;---- these must be normal shifted keys or Graphics?
    bit uppercase
    bpl key_set         ;Branch if lowercase mode
    ora #$80            ;Set the HIGH BIT
    rts                 ;Return with character code in A?

;---- Return the key in the X register
key_in_x:
    txa                 ;Substitute the terminal control code
    rts                 ;Return with control code in A

key_set:
    cmp #$00            ;Set CARRY if non-zero character?
    rts


;40-column graphics keyboard table           ----- ----- ----- ----- ----- ----- ----- -----    Notes
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

;80-column business keyboard table           ----- ----- ----- ----- ----- ----- ----- -----
business_keys:
    !byte $b2,$b5,$b8,$ad,$38,$0c,$ff,$ff ;  ^2    ^5    ^8    -     8     CSRRT NONE  NONE     UARROW = Up Arrow
    !byte $b1,$b4,$b7,$30,$37,$5e,$ff,$39 ;  ^1    ^4    ^7    0     7     UARRW NONE  9
    !byte $1b,$53,$46,$48,$5d,$4b,$bb,$35 ;  ESC   S     F     H     ]     K     ;     5        ^ = Bit 7 is set,
    !byte $41,$44,$47,$4a,$0d,$4c,$40,$36 ;  A     D     G     J     RTRN  L     @     6            indicating the
    !byte $09,$57,$52,$59,$5c,$49,$50,$7f ;  TAB   W     R     Y     \     I     P     DEL          key shifts to a
    !byte $51,$45,$54,$55,$0a,$4f,$5b,$34 ;  Q     E     T     U     CSRDN O     [     4            special character
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

shift_flag:
    !byte $aa

ctrl_flag:
    !byte $aa

repeatcount0:
    !byte $aa

repeatcount1:
    !byte $aa

repeatcode:
    !byte $aa

;Buffer for TAB stop positions (80 bytes: one for each screen column)
tab_stops:
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
    !byte $aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa,$aa
