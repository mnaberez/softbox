cinv_lo     = 0x90    ;KERNAL IRQ vector LO
cinv_hi     = 0x91    ;KERNAL IRQ vector HI
keyd        = 0x026f   ;Keyboard Buffer
screen      = 0x8000   ;Start of screen RAM
pia1_row    = 0xe810   ;6520 PIA #1 Keyboard Row Select
pia1_eoi    = 0xe811   ;6520 PIA #1 Control
pia1_col    = 0xe812   ;6520 PIA #1 Keyboard Columns Read
pia2_ieee   = 0xe820   ;6520 PIA #2 IEEE Input
pia2_ndac   = 0xe821   ;6520 PIA #2 IEEE NDAC control
pia2_iout   = 0xe822   ;6520 PIA #2 IEEE Output
pia2_dav    = 0xe823   ;6520 PIA #2 IEEE DAV control
via_pb      = 0xe840   ;6522 VIA Port B
via_pcr     = 0xe84c   ;6522 VIA Peripheral Control Register (PCR)
chrout      = 0xffd2   ;KERNAL Send a char to the current output device
;
scrline_lo  = 0x02    ;Pointer to start of current line in screen RAM - LO
scrline_hi  = 0x03    ;Pointer to start of current line in screen RAM - HI
cursor_x    = 0x04    ;Current X position: 0-79
cursor_y    = 0x05    ;Current Y position: 0-24
cursor_on   = 0x06    ;Cursor visible flag (hide = 0x00, show = 0x80)
cursor_tmp  = 0x07    ;Saves original cursor_on value during screen updates
scrcode     = 0x08    ;Screen code under the cursor
keycount    = 0x09    ;Number of keys in the buffer at keyd
columns     = 0x0a    ;Screen width (X) in characters (40 or 80)
lines       = 0x0b    ;Screen height (Y) in characters (24 or 25)
moveto_cnt  = 0x0c    ;Counts down bytes to consume in a move-to (CTRL_1B) seq
source_lo   = 0x0d    ;Pointer to source address for memory operations - LO
source_hi   = 0x0e    ;Pointer to source address for memory operations - HI
target_lo   = 0x0f    ;Pointer to target address for memory operations - LO
target_hi   = 0x10    ;Pointer to target address for memory operations - HI
xfer_lo     = 0x11    ;Memory transfer byte counter - LO
xfer_hi     = 0x12    ;Memory transfer byte counter - HI
char_mask   = 0x13    ;Masks incoming bytes for 7- or 8-bit character mode
rtc_jiffies = 0x14    ;Real Time Clock Jiffies
rtc_secs    = 0x15    ;Real Time Clock Seconds   Note: the RTC and Jiffy
rtc_mins    = 0x16    ;Real Time Clock Minutes   locations can't be changed
rtc_hours   = 0x17    ;Real Time Clock Hours     because they are accessed by
jiffy2      = 0x18    ;Jiffy Counter (MSB)       the SoftBox BIOS to support
jiffy1      = 0x19    ;Jiffy Counter             CP/M programs like TIME.COM.
jiffy0      = 0x1a    ;Jiffy Counter (LSB)
blink_cnt   = 0x1b    ;Counts down number of IRQs until cursor reverses
blink_on    = 0x1c    ;Cursor blink flag (blink off = 0x00, blink on = 0x80)
uppercase   = 0x1d    ;Uppercase graphics flag (lower = 0x00, upper = 0x80)
rvs_mask    = 0x1e    ;Reverse video mask (normal = 0x00, reverse = 0x80)
scroll_up_y = 0x1f    ;Top Y position in the generated scroll up code
scroll_dn_y = 0x20    ;Top Y position in the generated scroll down code
clear_eos_y = 0x21    ;Top Y position in the generated clear to EOS code

    .area CODE1 (ABS)
    .org 0x0400

bas_header:
;"50 sys1037"
;  Note: The line number is used in a clever way.  It is changed by the
;  configuration utility NEWSYS to either 50 or 60.  This tells the program
;  the frequency (in Hertz) at which the CBM system interrupt occurs.
;
    .byte 0x00          ;Null byte at start of BASIC program
    .word bas_eol+1     ;Pointer to the next BASIC line
bas_line:
    .word 0x0032        ;Line number (50 or 60)
    .byte 0x9e          ;Token for SYS command
    .ascii "1037"       ;Arguments for SYS
bas_eol:
    .byte 0x00          ;End of BASIC line
    .byte 0x00,0x00     ;End of BASIC program

init:
    sei                 ;Disable interrupts
    ldx #0xff
    txs                 ;Initialize stack pointer
    lda #<irq_handler
    sta cinv_lo
    lda #>irq_handler
    sta cinv_hi         ;Install our interrupt handler
    lda #0x00
    sta rtc_jiffies     ;Reset software real time clock
    sta rtc_secs
    sta rtc_mins
    sta rtc_hours
    sta jiffy2          ;Reset jiffy counter
    sta jiffy1
    sta jiffy0
    sta keycount        ;Reset key counter (no keys hit)
    lda #0x0a
    sta repeatcount1    ;Number of interrupts between repeats of a key

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
    lda #40
    sta columns         ;Initialize screen width to 40 columns
    lda #24
    sta lines           ;Initialize screen height to 24 lines

    lda #0x55
    sta screen          ;Store 0x55in first byte of screen RAM.
    asl ;a
    sta screen+0x400     ;Store 0xAAin first byte of 80 col page.
    cmp screen+0x400     ;Does it read back correctly?
    bne init_scrn_done  ;  No: we're done, columns = 40.
    lsr ;a
    cmp screen          ;Is the 0x55still intact?
    bne init_scrn_done  ;  No: incomplete decoding, columns = 40
    asl columns         ;  Yes: columns = 80 characters
init_scrn_done:
    lda #0x93           ;CHR$(147) = Clear Screen
    jsr chrout          ;Perform an initial clear of the entire screen

    lda #0x00
    sta cursor_x        ;Initialize cursor position
    sta cursor_y
    jsr init_scrlines   ;Initialize screen line pointer table
    jsr get_scrline     ;Initialize current screen line pointer

    lda #0x80
    sta cursor_on       ;Cursor state = show the cursor
    sta blink_on        ;Cursor blink = blinking on

    lda #0x20           ;Screen code for space, also initial value for blink
    sta scrcode         ;Initialize screen code under the cursor
    sta blink_cnt       ;Initialize cursor blink countdown

    lda #0xff           ;Clear caches of generated code
    sta scroll_up_y
    sta scroll_dn_y
    sta clear_eos_y

    cli                 ;Enable interrupts again
                        ;Fall through into init_term

init_term:
    jsr ctrl_16         ;Go to lowercase mode
    jsr ctrl_02         ;Go to 7-bit character mode
    jsr ctrl_06         ;Clear all tab stops
    lda #0x00
    sta moveto_cnt      ;Move-to counter = not in a move-to seq
    lda #0x1a           ;Load 0x1A= CTRL_1A Clear Screen
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
    and #0b11111011
    sta via_pb          ;ATN_OUT=low

    lda #0b00110100
    sta pia2_dav        ;DAV_OUT=low

    lda #0xc6
    sta pia2_iout       ;Put 0x39(SoftBox address) on IEEE data lines

    ldy #0x00
l_04d4:
    dey
    bne l_04d4          ;Let 0x39sit on the lines so the SoftBox sees it

    lda #0xff
    sta pia2_iout       ;Release IEEE data lines

    lda #0b00111100
    sta pia1_eoi        ;EOI_OUT=high, disable IRQ from CA1 (Cassette Read)
    sta pia2_ndac       ;NDAC_OUT=high, disable IRQ from CA1 (ATN_IN)
    sta pia2_dav        ;DAV_OUT=high, disable IRQ from CB1 (SRQ_IN),
                        ;  CB1 transition mode = positive (low-to-high)

main_loop:
    lda #0b00111100
    sta pia2_ndac       ;NDAC_OUT=high

    lda via_pb
    ora #0b00000110
    sta via_pb          ;NRFD_OUT=high, ATN_OUT=high

wait_for_srq:
    bit pia2_dav        ;Bit 7 = IRQB1 flag for CB1 (SRQ_IN detect)
    bpl wait_for_srq    ;Wait until positive transition on SRQ_IN is detected

    lda pia2_iout       ;Read clears IRQB1 flag (SRQ_IN detect)

    lda #0b00110100
    sta pia2_ndac       ;NDAC_OUT=low

    lda pia2_ieee       ;Read IEEE data byte from SoftBox
    eor #0xff           ;Invert it (IEEE-488 uses negative logic)
    and #0b00111111      ;Remove bits 7-6 which are only used for handshaking
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

    lda #0xbf           ;Response will be 0x40(no key available)
    ldy keycount        ;Is the keyboard buffer empty?
    beq send_key_avail  ;  Yes: Keep response as 0x40(no key available)
    lda #0x7f           ;  No:  Response will be 0x80(key available)

send_key_avail:
    sta pia2_iout       ;Put keyboard status on the data lines

handshake:
    lda pia2_ieee       ;Read IEEE data byte
    and #0b00111111      ;Mask off bits 7-6 since we are driving them
    cmp #0b00111111
    bne handshake       ;Wait for the SoftBox to release the other lines

    lda #0xff
    sta pia2_iout       ;Release all data lines

dispatch_command:
    cpx #0x01           ;0x01= Key availability (sent with handshake, so done)
    beq main_loop
    cpx #0x02           ;0x02= Wait for a key and send it
    beq do_get_key
    cpx #0x04           ;0x04= Write to the terminal screen
    beq do_terminal
    cpx #0x08           ;0x08= Execute a subroutine in CBM memory
    beq do_execute
    cpx #0x10           ;0x10= Transfer from CBM memory to the SoftBox
    beq do_peek
    cpx #0x20           ;0x20= Transfer from the SoftBox to CBM memory
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
    jmp [target_lo]

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

    ldy #0x00
l_05a5:
    dey
    bne l_05a5          ;Delay loop

l_05a8:
    lda [source_lo],y
    jsr ieee_put_byte
    iny
    bne l_05b2
    inc source_hi
l_05b2:
    lda xfer_lo
    sec
    sbc #0x01
    sta xfer_lo
    lda xfer_hi
    sbc #0x00
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
    ldy #0x00
l_0571:
    jsr ieee_get_byte
    sta [target_lo],y
    iny
    bne l_057b
    inc target_hi
l_057b:
    lda xfer_lo
    sec
    sbc #0x01
    sta xfer_lo
    lda xfer_hi
    sbc #0x00
    sta xfer_hi
    ora xfer_lo
    bne l_0571
    jmp main_loop

ieee_get_byte:
;Receive a byte from the SoftBox over the IEEE-488 bus.
;
    lda via_pb
    ora #0b00000010
    sta via_pb          ;NRFD_OUT=high

l_05d7:
    bit via_pb
    bmi l_05d7          ;Wait until DAV_IN=low

    lda pia2_ieee       ;Read data byte
    eor #0xff           ;Invert it
    pha                 ;Push data byte

    lda via_pb
    and #0b11111101
    sta via_pb          ;NRFD_OUT=low

    lda #0b00111100
    sta pia2_ndac       ;NDAC_OUT=high

l_05ef:
    bit via_pb
    bpl l_05ef          ;Wait until DAV_IN=high

    lda #0b00110100
    sta pia2_ndac       ;NDAC_OUT=low

    pla
    rts

ieee_put_byte:
;Send a byte to the SoftBox over the IEEE-488 bus.
;
    eor #0xff           ;Invert the byte
    sta pia2_iout       ;Put byte on IEEE data output lines

    lda via_pb
    ora #0b00000010
    sta via_pb          ;NRFD_OUT=high

    lda #0b00111100
    sta pia2_ndac       ;NDAC_OUT=high

l_060d:
    bit via_pb
    bvc l_060d          ;Wait until NRFD_IN=high

    lda #0b00110100
    sta pia2_dav        ;DAV_OUT=low

l_0617:
    lda via_pb
    lsr ;a
    bcc l_0617          ;Wait until NDAC_IN=high

    lda #0b00111100
    sta pia2_dav        ;DAV_OUT=high

    lda #0xff
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
    lda #0xff           ;FF = no key
    sei                 ;Disable interrupts
    ldx keycount        ;Is there a key waiting in the buffer?
    beq l_0649          ;  No: nothing to do with the buffer.
    lda keyd            ;Read the next key in the buffer (FIFO)
    pha                 ;Push the key onto the stack
    ldx #0x00
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
    cmp #0xff           ;No key or key is "NONE" in the tables?
    beq get_key         ;  No key:  loop until we get one.
    rts                 ;  Got key: done.  Key is now in A.

irq_handler:
;On PET/CBM, an IRQ occurs at 50 or 60 Hz depending on the model and ROMs.
;The 6502 calls the main IRQ entry point (0xE442 on BASIC 4.0) which pushes
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
    cmp bas_line        ;50 or 60 (Hz).  See note in BAS_HEADER.
    bne irq_blink
    lda #0x00           ;Reset RTC_JIFFIES counter
    sta rtc_jiffies
    inc rtc_secs        ;Increment Seconds
    lda rtc_secs
    cmp #0x3c           ;Have we reached 60 seconds?
    bne irq_blink       ;   No, skip
    lda #0x00           ;   Yes, reset seconds
    sta rtc_secs
    inc rtc_mins        ;Increment Minutes
    lda rtc_mins
    cmp #0x3c           ;Have we reached 60 minutes?
    bne irq_blink       ; No, skip
    lda #0x00           ; Yes, reset minutes
    sta rtc_mins
    inc rtc_hours       ;Increment hours
    lda rtc_hours
    cmp #0x18           ;Have we reached 24 hours?
    bne irq_blink       ; No, skip
    lda #0x00           ; Yes, reset hours
    sta rtc_hours

irq_blink:
;Blink the cursor
    bit cursor_on       ;Is the cursor on?
    bpl irq_repeat      ;  No: skip cursor blink

    ldy cursor_x
    lda [scrline_lo],y  ;Read character at cursor

    bit blink_on        ;Is cursor blink on?
    bmi irq_blink_on    ;  Yes: branch to blink the cursor

    ora #0x80           ;Set reverse bit for steady cursor
    bmi irq_blink_store

irq_blink_on:
    dec blink_cnt       ;Decrement cursor blink countdown
    bne irq_repeat      ;Not time to blink? Done.
    ldx #0x14
    stx blink_cnt       ;Reset cursor blink countdown

    eor #0x80           ;Flip reverse bit to blink cursor
irq_blink_store:
    sta [scrline_lo],y

irq_repeat:
;Repeat key handling
    lda scancode        ;Get the SCANCODE
    cmp repeatcode      ;Compare to SAVED scancode
    beq l_06b1          ;They are the same, so continue
    sta repeatcode      ;if not, save it
    lda #0x10           ;reset counter
    sta repeatcount0    ;save to counter
    bne irq_scan
l_06b1:
    cmp #0xff           ;NO KEY?
    beq irq_scan        ;Yes, jump to scan for another
    lda repeatcount0    ;No, there was a key, so get the counter
    beq l_06bf          ;Is it zero?
    dec repeatcount0    ;Count Down
    bne irq_scan        ;Is it Zero
l_06bf:
    dec repeatcount1    ;Count Down
    bne irq_scan        ;Is it zero? No, scan for another
    lda #0x04           ;Yes, Reset it to 4
    sta repeatcount1    ;Store it
    lda #0x00           ;Clear the SCANCODE and allow the key to be processed
    sta scancode        ;Store it
    lda #0x02
    sta blink_cnt       ;Blink cursor faster when key is repeating

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
    cpx #0x50           ;Is the keyboard buffer full?
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
    tax                 ;Save A in X
    lda cursor_on       ;Get the current cursor state
    sta cursor_tmp      ;  Remember it
    lsr cursor_on       ;Hide the cursor
    lda scrcode         ;Get the screen code under the cursor
    ldy cursor_x
    sta [scrline_lo],y  ;Put it on the screen to erase the cursor
    txa                 ;Restore A
    and char_mask       ;Mask off bits depending on char mode
    ldx moveto_cnt      ;More bytes to consume for a move-to sequence?
    bne process_move    ;  Yes: branch to jump to move-to handler
    cmp #0x20           ;Is this byte a control code?
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
    jmp [target_lo]
process_move:
    jsr move_to         ;JSR to move-to sequence handler
    jmp process_done
process_char:
    tax
    lda asc_trans,x     ;Get CBM screen code for the character
    eor rvs_mask        ;Reverse the screen code if needed
    sta [scrline_lo],y  ;Write the screen code to screen RAM
    jsr ctrl_0c         ;Advance the cursor
process_done:
    jsr get_scrline     ;Update screen RAM pointer
    lda [scrline_lo],y  ;Get the screen code under the cursor
    sta scrcode         ;  Remember it
    lda cursor_tmp      ;Get the previous state of the cursor
    sta cursor_on       ;  Restore it
    rts

move_to:
;Implements CTRL_1B by handling the X-position byte on the first call
;and the Y-position byte on the second call.  After the Y-position byte
;has been consumed, MOVETO_CNT = 0, exiting the move-to sequence.
;
    sec
    sbc #0x20           ;Pos = Pos - 0x20(ADM-3A compatibility)

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

init_asc_trans:
;Build the ASCII to CBM screen code translation table
;
    ldy #0x00           ;Start at ASCII code 0
init_ct_loop:
    tya
    jsr trans_char      ;Translate to a CBM screen code
    sta asc_trans,y     ;Store it in the table
    iny
    bne init_ct_loop    ;Loop until 256 codes are translated
    rts

trans_char:
;Convert an ASCII (not PETSCII) character in the accumulator to its
;equivalent CBM screen code.
;
;Bytes 0x00-7F (bit 7 off) always correspond to the 7-bit standard
;ASCII character set and are converted to the equivalent CBM screen code.
;
;Bytes 0x80-FF (bit 7 on) are a special extended mode that display
;the CBM graphics characters if the terminal is in 8-bit mode (CTRL_01):
;
;  Byte      Screen Code
;  0x80-BF -> 0x40-7F
;  0xC0-FF -> 0x40-7F
;
    ldx #0x5d           ;Change to PETSCII vertical line
    cmp #0x7c           ;  from ASCII pipe ("|") character
    beq l_07c6
    ldx #0x64           ;Change to PETSCII underscore
    cmp #0x5f           ;  from ASCII underscore ("_") character
    beq l_07c6

    cmp #0x40           ;Is it < 64?
    bcc trans_done      ;  Yes: done, no translation
    cmp #0x60           ;Is it >= 96?
    bcs l_07a6          ;  Yes: branch to L_07A6
    and #0x3f           ;Turn off bits 6 and 7
    jmp l_07ac          ;Jump to L_07AC
l_07a6:
    cmp #0x80           ;Is bit 7 set?
    bcs l_07ca          ;  Yes: branch to L_07CA
    and #0x5f
l_07ac:
    tax
    and #0x3f           ;Turn off bit 7 and bit 6
    beq l_07c6
    cmp #0x1b
    bcs l_07c6
    txa
    eor #0x40           ;Flip bit 6
    bit uppercase
    bpl trans_done      ;Branch if lowercase mode
    and #0x1f
    jmp trans_done
l_07c6:
    txa
    jmp trans_done
l_07ca:
    and #0x7f           ;Turn off bit 7
    ora #0x40           ;Turn on bit 6
trans_done:
    rts

ctrl_codes:
;Terminal control code dispatch table.  These control codes are based
;on the Lear Seigler ADM-3A terminal.  Some bytes that are unused on
;that terminal are used for other purposes here.
;
                    ;Hex  Keyboard
    .word ctrl_00   ;00   CTRL-@    Do nothing
    .word ctrl_01   ;01   CTRL-A    Go to 8-bit character mode
    .word ctrl_02   ;02   CTRL-B    Go to 7-bit character mode
    .word ctrl_03   ;03   CTRL-C    Do nothing
    .word ctrl_04   ;04   CTRL-D    Set a TAB stop at current position
    .word ctrl_05   ;05   CTRL-E    Clear TAB stop at current position
    .word ctrl_06   ;06   CTRL-F    Clear all TAB stops
    .word ctrl_07   ;07   CTRL-G    Ring bell
    .word ctrl_08   ;08   CTRL-H    Cursor left
    .word ctrl_09   ;09   CTRL-I    Perform TAB
    .word ctrl_0a   ;0A   CTRL-J    Cursor down (Line feed)
    .word ctrl_0b   ;0B   CTRL-K    Cursor up
    .word ctrl_0c   ;0C   CTRL-L    Cursor right
    .word ctrl_0d   ;0D   CTRL-M    Carriage return
    .word ctrl_0e   ;0E   CTRL-N    Reverse video on
    .word ctrl_0f   ;0F   CTRL-O    Reverse video off
    .word ctrl_10   ;10   CTRL-P    Cursor on
    .word ctrl_11   ;11   CTRL-Q    Insert line
    .word ctrl_12   ;12   CTRL-R    Delete line
    .word ctrl_13   ;13   CTRL-S    Clear to end of line
    .word ctrl_14   ;14   CTRL-T    Clear to end of screen
    .word ctrl_15   ;15   CTRL-U    Go to uppercase mode
    .word ctrl_16   ;16   CTRL-V    Go to lowercase mode
    .word ctrl_17   ;17   CTRL-W    Set line spacing for graphics
    .word ctrl_18   ;18   CTRL-X    Set line spacing for text
    .word ctrl_19   ;19   CTRL-Y    Cursor off
    .word ctrl_1a   ;1A   CTRL-Z    Clear screen
    .word ctrl_1b   ;1B   ESC       Move cursor to X,Y position
    .word ctrl_1c   ;1C   CTRL-/    Insert character
    .word ctrl_1d   ;1D   CTRL-]    Delete character
    .word ctrl_1e   ;1E   CTRL-^    Home cursor
    .word ctrl_1f   ;1F             Do nothing

ctrl_00:
ctrl_03:
ctrl_1f:
;Do nothing
    rts

ctrl_01:
;Go to 8-bit character mode
;See trans_char for how this mode is used to display CBM graphics.
;
    lda #0xff
    sta char_mask
    rts

ctrl_02:
;Go to 7-bit character mode
;
    lda #0x7f
    sta char_mask
    rts

ctrl_15:
;Go to uppercase mode
;
    lda #0x80
    sta uppercase
    jsr init_asc_trans  ;Rebuild translation table for uppercase
    lda #0x0c
    sta via_pcr         ;Graphic mode = uppercase
    rts

ctrl_16:
;Go to lowercase mode
;
    lda #0x00
    sta uppercase
    jsr init_asc_trans  ;Rebuild translation table for lowercase
    lda #0x0e
    sta via_pcr         ;Graphic mode = lowercase
    rts

ctrl_17:
;Set line spacing for graphics (the default spacing for uppercase mode).
;The current graphic mode will not be changed.
;
    lda via_pcr         ;Remember current upper/lower graphic mode
    pha
    lda #0x8e           ;CHR$(142) = Switch to uppercase mode
    jsr chrout          ;  and set less vertical space between chars
    pla
    sta via_pcr         ;Restore graphic mode
    rts

ctrl_18:
;Set line spacing for text (the default spacing for lowercase mode).
;The current graphic mode will not be changed.
;
    lda via_pcr         ;Remember current upper/lower graphic mode
    pha
    lda #0x0e           ;CHR$(14) = Switch to lowercase mode
    jsr chrout          ;  and set more vertical space between chars
    pla
    sta via_pcr         ;Restore graphic mode
    rts

ctrl_07:
;Ring bell
;
    lda #0x07           ;CHR$(7) = Bell
    jmp chrout

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
    ldx #0x00
    stx cursor_x        ;  Yes: Carriage return, then
    jmp ctrl_0a         ;       jump out to line feed

ctrl_0d:
;Carriage return
;
    ldx #0x00           ;Move to X=0 on this line
    stx cursor_x
    rts

ctrl_0a:
;Cursor down (Line feed)
;
    ldy cursor_y
    iny
    cpy lines           ;Are we on the bottom line?
    bne ctrl_0a_incy    ;  No:  Increment cursor_y, do not scroll up
    ldy #0x00           ;Start scrolling from the top line
    jmp scroll_up       ;Jump out to scroll up
ctrl_0a_incy:
    inc cursor_y        ;Increment Y position
    rts

ctrl_1e:
;Home cursor
;
    lda #0x00
    sta cursor_y
    sta cursor_x
    rts

ctrl_1a:
;Clear screen
;
    jsr ctrl_0f         ;Reverse video off
    jsr ctrl_1e         ;Home cursor
    ldy #0x00           ;Start clearing from the top line
    jmp clear_eos       ;Jump out to clear to end of screen

ctrl_10:
;Cursor on
;
    lda #0x80
    sta cursor_tmp
    rts

ctrl_19:
;Cursor off
;
    lda #0x00
    sta cursor_tmp
    rts

ctrl_0e:
;Reverse video on
;
    lda #0x80
    sta rvs_mask
    rts

ctrl_0f:
;Reverse video off
;
    lda #0x00
    sta rvs_mask
    rts

ctrl_13:
;Clear to end of line
;
    ldy cursor_x
    lda #0x20           ;Space character
l_0863:
    sta [scrline_lo],y  ;Write space to screen RAM
    iny                 ;X=X+1
    cpy columns
    bne l_0863          ;Loop until end of line
    rts

ctrl_14:
;Clear to end of screen.
;
;All lines below the current line will be erased.
;The current line and cursor position are not changed.
;
    jsr ctrl_13         ;Clear to the end of the current line
    ldy cursor_y        ;Get current Y position
ctrl_14_next:
    iny                 ;Y=Y+1
    cpy lines           ;Incremented past last line?
    beq ctrl_14_done    ;  Yes: done
    jmp clear_eos       ;   No: jump out to clear to end of screen
ctrl_14_done:
    rts

ctrl_04:
;Set TAB stop at current position
;
    ldx cursor_x        ;Get cursor position
    lda #0x01
    sta tab_stops,x     ;Set a TAB stop at that position
    rts

ctrl_05:
;Clear TAB stop at current position
;
    ldx cursor_x        ;Get cursor position
    lda #0x00
    sta tab_stops,x     ;Clear a TAB stop at that position
    rts

ctrl_06:
;Clear all TAB stops
;
    ldx #0x4f           ;80 characters - 1
    lda #0x00
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
    cpx #0x50           ;80 characters?
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
    lda #0x02           ;Two more bytes to consume (X-pos, Y-pos)
    sta moveto_cnt      ;Store count for next pass of PROCESS_BYTE
    rts

ctrl_1c:
;Insert character
;
    ldy columns         ;number of characters on line
    dey
l_08f4:
    cpy cursor_x
    beq l_0901
    dey
    lda [scrline_lo],y  ;read a character from line
    iny                 ;position to the right
    sta [scrline_lo],y  ;write it back
    dey                 ;we are counting down to zero
    bne l_08f4          ;loop for another character
l_0901:
    lda #0x20           ;SPACE
    sta [scrline_lo],y  ;Write it to current character position
    rts

ctrl_1d:
;Delete character
;
    ldy cursor_x
l_090b:
    iny
    cpy columns
    beq l_0918
    lda [scrline_lo],y  ;read a character from the line
    dey                 ;position to the left
    sta [scrline_lo],y  ;write it back
    iny                 ;we are counting UP
    bne l_090b          ;loop for another character
l_0918:
    dey
    lda #0x20           ;SPACE
    sta [scrline_lo],y  ;write it to the current character position
    rts

ctrl_12:
;Delete line
;
;The current line is replaced by the one below it, and each successive
;line is replaced by the one below it.  The bottommost screen line is
;cleared.  The cursor is moved to the first column of the current line.
;
    lda #0x00
    sta cursor_x       ;Move cursor to beginning of line

    ldy cursor_y       ;Scroll from current line to bottom of screen
    jmp scroll_up      ;Jump out to scroll up

ctrl_11:
;Insert line
;
;The current line is cleared and its original contents moved to the
;line below it.  Each successive line is moved to one below it.  The
;cursor is moved to the first column of the current line.
;
    lda #0x00
    sta cursor_x        ;Move cursor to beginning of line

    ldy cursor_y        ;Scroll from current line to bottom of screen
    jmp scroll_down     ;Jump out to scroll down

init_scrlines:
;Build the screen line pointer tables.
;
    ldy #0x00           ;Start at line 0
init_scrl_loop:
    jsr calc_scrline    ;Calculate pointer
    lda scrline_lo
    sta scrline_los,y   ;Save pointer low byte
    lda scrline_hi
    sta scrline_his,y   ;Save pointer high byte
    iny                 ;Increment to next line index
    cpy lines
    bne init_scrl_loop  ;Loop until all pointers are calculated
    rts

calc_scrline:
;Calculate a pointer to the first byte of a line in screen RAM by
;multiplying the line number in Y by the screen width (40 or 80).
;
;Preserves X and Y.
;Stores the pointer in scrline.
;
    lda #0x00
    sta scrline_hi      ;Initialize high byte to zero
    tya
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
    rts

get_scrline:
;Get a pointer to the first byte of the current line (cursor_y)
;in screen RAM.
;
;Preserves A and X.
;Returns cursor_x in Y.
;Stores the pointer in scrline.
;
    pha                 ;Save A
    ldy cursor_y        ;Get cursor Y position (line)
    lda scrline_los,y   ;Look up low byte of pointer
    sta scrline_lo      ;Store it
    lda scrline_his,y   ;Look up high byte of pointer
    sta scrline_hi      ;Store it
    ldy cursor_x        ;Load cursor X position in Y
    pla                 ;Restore A
    rts

clear_eos:
;Clear to end of screen.  Pass a screen line index in Y, and that line
;and below will be cleared.
;
    cpy clear_eos_y     ;Is the clearing code for this Y-position?
    beq clear_eos_call  ;  Yes: skip code generation
    jsr gen_clear_eos   ;   No: generate new clearing code first
clear_eos_call:
    jmp _clear_eos      ;Jump out to the generated code

gen_clear_eos:
;Code generator used by clear_eos.  This generates the _clear_eos routine,
;an unrolled loop that quickly clears the screen from the line index
;passed in Y to the bottom of the screen.
;
;  _clear_eos:
;      lda #0x20    ;space character
;      ldx #79      ;index of last column
;  L1: sta 0x8000,x  ;clear line 0
;      sta 0x8050,x  ;clear line 1
;      ...
;      dex
;      bmi L2
;      jmp L1
;  L2: rts
;
    sty clear_eos_y     ;Save top screen line index passed in Y
    ldx #0x00           ;Index into generated code

    ;Generate: LDA #0x20 (load space character)

    lda #0xa9           ;0xa9= LDA imm
    sta _clear_eos,x
    inx
    lda #0x20           ;Immediate value for LDA (space character)
    sta _clear_eos,x
    inx

    ;Generate: LDX #79  (index of last column)

    lda #0xa2           ;0xa2= LDX immediate
    sta _clear_eos,x    ;Write opcode
    inx
    ldy columns         ;Get number of columns
    dey                 ;Decrement to get index of last column
    tya
    sta _clear_eos,x    ;Write immediate value for LDX
    inx

    lda cursor_y        ;Preserve cursor_y
    pha

    ldy clear_eos_y     ;Y = Index of current screen line number

gen_clreos_loop:
    sty cursor_y
    jsr get_scrline     ;Get pointer to screen line
    ldy cursor_y        ;Reload because Y is destroyed by get_scrline

    ;Generate: STA scrline,x  (store on this line)

    lda #0x9d           ;0x9d= STA abs,x
    sta _clear_eos,x    ;Write opcode
    inx
    lda scrline_lo      ;Write low byte for LDA address
    sta _clear_eos,x
    inx
    lda scrline_hi      ;Write high byte for LDA address
    sta _clear_eos,x
    inx

    iny                 ;Increment to next line down the screen

    cpy lines           ;Reached end of screen?
    bne gen_clreos_loop ;  No: loop to generate code for remaining lines

    ;Generate: DEX

    lda #0xca           ;0xca= DEX
    sta _clear_eos,x
    inx

    ;Generate: BMI +3 (skip over next JMP)

    lda #0x30           ;0x30= BMI
    sta _clear_eos,x    ;Write opcode
    inx
    lda #0x03           ;Write displacement for BMI
    sta _clear_eos,x
    inx

    ;Generate: JMP _clear_eos+4

    lda #0x4c           ;0xca= JMP abs
    sta _clear_eos,x    ;Write opcode
    inx
    lda #<_clear_eos+4
    sta _clear_eos,x    ;Write low byte for JMP address
    inx
    lda #>_clear_eos+4  ;Write high byte for JMP address
    sta _clear_eos,x
    inx

    ;Generate: RTS

    lda #0x60           ;0x60= RTS
    sta _clear_eos,x    ;Write opcode

    pla                 ;Restore original cursor_y
    sta cursor_y
    rts

scroll_up:
;Scroll the screen up.  Pass a screen line index in Y, and that line
;and below will be scrolled up.
;
    cpy scroll_up_y     ;Is the scroll code for this Y-position?
    beq scroll_up_call  ;  Yes: skip code generation
    jsr gen_scroll_up   ;   No: generate new scroll code first
scroll_up_call:
    jmp _scroll_up      ;Jump out to the generated code

gen_scroll_up:
;Code generator used by scroll_up.  This generates the _scroll_up routine,
;an unrolled loop that quickly scrolls the screen up.  The generated code
;will start scrolling at the line index passed in Y.
;
;  _scroll_up:
;      ldx #79      ;index of last column
;  L1: lda 0x8050,x  ;from line 1
;      sta 0x8000,x  ;       to line 0
;      lda 0x80a0,x  ;from line 2
;      sta 0x8050,x  ;       to line 1
;      ...
;      lda #0x20    ;space character
;      sta 0x8780,x  ;       to last line
;      dex
;      bmi L2       ;branch if done with all columns
;      jmp L1
;  L2: rts
;
    sty scroll_up_y     ;Save top screen line index passed in Y
    ldx #0x00           ;Index into generated code

    ;Generate: LDX #79  (index of last column)

    lda #0xa2           ;0xa2= LDX immediate
    sta _scroll_up,x    ;Write opcode
    inx
    ldy columns         ;Get number of columns
    dey                 ;Decrement to get index of last column
    tya
    sta _scroll_up,x    ;Write immediate value for LDX
    inx

    lda cursor_y        ;Preserve cursor_y
    pha

    ldy scroll_up_y     ;Y = Index of current screen line number

gen_scrup_loop:
    iny                 ;Source line number (current line + 1)
    sty cursor_y
    jsr get_scrline     ;Get pointer to screen line
    ldy cursor_y        ;Reload because Y is destroyed by get_scrline

    ;Generate: LDA scrline+1,x  (load from next line)

    lda #0xbd           ;0xbd= LDA abs,x
    sta _scroll_up,x    ;Write opcode
    inx
    lda scrline_lo
    sta _scroll_up,x    ;Write low byte for LDA address
    inx
    lda scrline_hi
    sta _scroll_up,x    ;Write high byte for LDA address
    inx

    dey                 ;Destination line number (current line)
    sty cursor_y
    jsr get_scrline     ;Get pointer to screen line
    ldy cursor_y        ;Reload because Y is destroyed by get_scrline

    ;Generate: STA scrline,x  (store on this line)

    lda #0x9d           ;0x9d= STA abs,x
    sta _scroll_up,x    ;Write opcode
    inx
    lda scrline_lo      ;Write low byte for LDA address
    sta _scroll_up,x
    inx
    lda scrline_hi      ;Write high byte for LDA address
    sta _scroll_up,x
    inx

    iny                 ;Increment to next line down the screen

    lda lines
    sec
    sbc #0x01
    sta cursor_y        ;Set cursor_y to number of screen lines - 1
                        ;  (index of the bottom screen line)

    cpy cursor_y        ;Reached the bottom line?
    bne gen_scrup_loop    ;  No: loop to generate code for remaining lines

    ;Generate: LDA #0x20 (load space character)

    lda #0xa9           ;0xa9= LDA imm
    sta _scroll_up,x
    inx
    lda #0x20           ;Immediate value for LDA (space character)
    sta _scroll_up,x
    inx

    ;Generate: STA scrline,x  (store on this line)

    sty cursor_y
    jsr get_scrline     ;Get pointer to screen line
    ldy cursor_y        ;Reload because Y is destroyed by get_scrline

    lda #0x9d           ;0x9d= STA abs,x
    sta _scroll_up,x    ;Write opcode
    inx
    lda scrline_lo      ;Write low byte for LDA address
    sta _scroll_up,x
    inx
    lda scrline_hi      ;Write high byte for LDA address
    sta _scroll_up,x
    inx

    ;Generate: DEX

    lda #0xca           ;0xca= DEX
    sta _scroll_up,x
    inx

    ;Generate: BMI +3 (skip over next JMP)

    lda #0x30           ;0x30= BMI
    sta _scroll_up,x    ;Write opcode
    inx
    lda #0x03           ;Write displacement for BMI
    sta _scroll_up,x
    inx

    ;Generate: JMP _scroll_up+2

    lda #0x4c           ;0xca= JMP abs
    sta _scroll_up,x    ;Write opcode
    inx
    lda #<_scroll_up+2
    sta _scroll_up,x    ;Write low byte for JMP address
    inx
    lda #>_scroll_up+2  ;Write high byte for JMP address
    sta _scroll_up,x
    inx

    ;Generate: RTS

    lda #0x60           ;0x60= RTS
    sta _scroll_up,x    ;Write opcode

    pla                 ;Restore original cursor_y
    sta cursor_y
    rts


scroll_down:
;Scroll the screen down.  Pass a screen line index in Y, and that line
;line will be moved to the one below it.  Each successive line will
;be moved to the one below it.  The line in Y will be cleared.
;
    cpy scroll_dn_y     ;Is the scroll code for this Y-position?
    beq scroll_dn_call  ;  Yes: skip code generation
    jsr gen_scroll_down ;   No: generate new scroll code first
scroll_dn_call:
    jmp _scroll_down    ;Jump out to the generated code

gen_scroll_down:
;Code generator used by scroll_down.  This generates the _scroll_down
;routine, an unrolled loop that quickly scrolls the screen down.  The
;generated code will start scrolling at the line index passed in Y.
;
;  _scroll_down:
;      ldx #79      ;index of last column
;  L1: lda 0x86e0,x  ;from line 22
;      sta 0x8730,x  ;       to line 23
;      lda 0x8690,x  ;from line 21
;      sta 0x86e0,x  ;       to line 22
;      ...
;      lda #0x20    ;space character
;      sta 0x8000,x  ;       to first line
;      dex
;      bmi L2       ;branch if done with all columns
;      jmp L1
;  L2: rts
;
    sty scroll_dn_y     ;Save top screen line index passed in Y
    ldx #0x00           ;Index into generated code

    ;Generate: LDX #79  (index of last column)

    lda #0xa2           ;0xa2= LDX immediate
    sta _scroll_down,x  ;Write opcode
    inx
    ldy columns         ;Get number of columns
    dey                 ;Decrement to get index of last column
    tya
    sta _scroll_down,x  ;Write immediate value for LDX
    inx

    lda cursor_y        ;Preserve cursor_y
    pha

    ldy lines
    dey                 ;Index of current screen line number

gen_scrdn_loop:
    cpy scroll_dn_y     ;Source line index = current line index?
    beq gen_scrdn_eras  ;  Yes: done copying lines

    dey                 ;Move one line up the screen
    sty cursor_y

    jsr get_scrline     ;Get pointer to screen line
    ldy cursor_y        ;Reload because Y is destroyed by get_scrline

    ;Generate: LDA scrline,x  (load from current line)

    lda #0xbd           ;0xbd= LDA abs,x
    sta _scroll_down,x  ;Write opcode
    inx
    lda scrline_lo
    sta _scroll_down,x  ;Write low byte for LDA address
    inx
    lda scrline_hi
    sta _scroll_down,x  ;Write high byte for LDA address
    inx

    iny                 ;Increment to get destination line (next line down)
    sty cursor_y
    jsr get_scrline     ;Get pointer to screen line
    ldy cursor_y        ;Reload because Y is destroyed by get_scrline

    ;Generate: STA scrline+1,x  (store on next line)

    lda #0x9d           ;0x9d= STA abs,x
    sta _scroll_down,x  ;Write opcode
    inx
    lda scrline_lo      ;Write low byte for LDA address
    sta _scroll_down,x
    inx
    lda scrline_hi      ;Write high byte for LDA address
    sta _scroll_down,x
    inx

    dey                 ;Decrement back to source line
    jmp gen_scrdn_loop  ;Loop to handle the next line up the screen

gen_scrdn_eras:
    ldy scroll_dn_y     ;Move to the topmost line

    ;Generate: LDA #0x20 (load space character)

    lda #0xa9           ;0xa9= LDA imm
    sta _scroll_down,x
    inx
    lda #0x20           ;Immediate value for LDA (space character)
    sta _scroll_down,x
    inx

    ;Generate: STA scrline,x  (store on this line)

    ldy scroll_dn_y     ;Go back to the original (topmost) line
    sty cursor_y
    jsr get_scrline     ;Get pointer to screen line
    ldy cursor_y        ;Reload because Y is destroyed by get_scrline

    lda #0x9d           ;0x9d= STA abs,x
    sta _scroll_down,x  ;Write opcode
    inx
    lda scrline_lo      ;Write low byte for LDA address
    sta _scroll_down,x
    inx
    lda scrline_hi      ;Write high byte for LDA address
    sta _scroll_down,x
    inx

    ;Generate: DEX

    lda #0xca           ;0xca= DEX
    sta _scroll_down,x
    inx

    ;Generate: BMI +3 (skip over next JMP)

    lda #0x30           ;0x30= BMI
    sta _scroll_down,x  ;Write opcode
    inx
    lda #0x03           ;Write displacement for BMI
    sta _scroll_down,x
    inx

    ;Generate: JMP _scroll_down+2

    lda #0x4c           ;0xca= JMP abs
    sta _scroll_down,x  ;Write opcode
    inx
    lda #<_scroll_down+2
    sta _scroll_down,x  ;Write low byte for JMP address
    inx
    lda #>_scroll_down+2
    sta _scroll_down,x  ;Write high byte for JMP address
    inx

    ;Generate: RTS

    lda #0x60           ;0x60= RTS
    sta _scroll_down,x  ;Write opcode

    pla                 ;Restore original cursor_y
    sta cursor_y
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
;Uses: scancode   - Code of Pressed KEY (0xFF=NONE)
;      lastcode   - Code of Previous KEY
;      rowcount   - Keyboard ROW counter
;      shift_flag - SHIFT key flag
;      ctrl_flag  - CTRL key flag
;
;Note: the PET/CBM machines do not have a key labeled CTRL.  The OFF/RVS
;      key is used as the CTRL key.
;
    lda scancode        ;Old SCANCODE
    sta lastcode        ;Save It
    ldx #0x00           ;X=0 Index into Keyboard Scan Table
    stx shift_flag      ;Reset SHIFT key flag
    stx ctrl_flag       ;Reset CTRL key flag

    stx pia1_row        ;Select a keyboard ROW
    lda #0xff           ;0xFF= no key
    sta scancode        ;Set it
    lda #0x0a           ;Keyboard has 10 ROWS
    sta rowcount        ;ROW=10 - Keyboard ROW counter

;---- top of loop for keyboard ROWS
;
scan_row:
    ldy #0x08           ;Y=8 -- 8 Columns in Table

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
    cmp #0x01           ;Is it the SHIFT key?
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
; Check if there is anything to do. SCANCODE will be 0xFF if no key.
; If the SCANCODE = LASTCODE then key is being held down. Don't do anything until it is released.
; The IRQ handler implements key repeat by clearing the SCANCODE after a short interval.

    lda scancode        ;Get the current SCANCODE
    cmp #0xff           ;Is it NO KEY?
    beq keydone         ; Yes, exit

    cmp lastcode        ;Is it the same as last? (Key is registered on key UP?)
    beq keydone         ; Yes, exit

key_check1:
    cmp #0x00           ;Is bit 7 set?
    bpl key_low         ;  No: branch to key_low

key_hi:
    and #0x7f           ;Remove the TOP bit (shift flag for character?)
    ldy shift_flag      ;Check SHIFT Flag
    beq key_low         ;SHIFT=0? Yes, skip
    eor #0x10           ;No, flip BIT 4 (what does bit 4 do?)
    rts

;---- Check if in A-Z range
key_low:
    cmp #0x40           ;Start of compare to A-Z Range. "@" is lower limit?
    bcc key_check2      ;It is below? Yes, must be COMMAND character
    cmp #0x60           ;Compare to upper ascii limit?
    bcs key_check2      ;Is it above the A-Z range? Yes, skip

;---- Check CTRL key flag
    ldy ctrl_flag       ;Check CTRL key flag
    beq key_atoz        ;Is it zero? Yes, skip
    and #0x1f           ;RETURN CTRL-A to Z - Use only the lower 5 BITS (0 to 31)

keydone:
    rts

;---- Check A to Z or CTRL key
key_atoz:
    cmp #0x40           ;Compare to "@" symbol
    beq key_check2
    cmp #0x5b           ;Compare to "[" symbol?
    bcs key_check2

    ldy shift_flag      ;Is SHIFT Flag set?
    bne key_check2      ; No,skip to next test

;---- Handle regular A-Z
    bit uppercase
    bmi key_check2      ;Branch if uppercase mode
    ora #0x20           ;Convert character to UPPERCASE HERE
    rts                 ;Return with character code in A

;---- Check SHIFT flag
key_check2:
    ldy shift_flag      ;Check SHIFT flag for zero
    beq key_set         ;  Yes, skip out

;---- Translate SHIFTED 0-31 codes to terminal control codes
key_sh_codes:
    ldx #0x0b           ;Change to 0x0b(cursor up)
    cmp #0x0a           ;  from 0x0a(cursor down)
    beq key_in_x
    ldx #0x08           ;Change to 0x08(cursor left)
    cmp #0x0c           ;  from 0x0c(cursor right)
    beq key_in_x
    ldx #0x1a           ;Change to 0x1a(clear screen)
    cmp #0x1e           ;  from 0x1e(home)
    beq key_in_x
    ldx #0x7b           ;Change to 0x7b( { )
    cmp #0x5b           ;  from 0x5b( [ )
    beq key_in_x
    ldx #0x7c           ;Change to 0x7c( | )
    cmp #0x5c           ;  from 0x5c( \ )
    beq key_in_x
    ldx #0x7d           ;Change to 0x7d( } )
    cmp #0x5d           ;  from 0x5d( ] )
    beq key_in_x
    ldx #0x7e           ;Change to 0x7e( ~ )
    cmp #0x5e           ;  from 0x5e( ^ )
    beq key_in_x

;---- these must be normal shifted keys or Graphics?
    bit uppercase
    bpl key_set         ;Branch if lowercase mode
    ora #0x80           ;Set the HIGH BIT
    rts                 ;Return with character code in A?

;---- Return the key in the X register
key_in_x:
    txa                 ;Substitute the terminal control code
    rts                 ;Return with control code in A

key_set:
    cmp #0x00
    rts


;40-column graphics keyboard table           ----- ----- ----- ----- ----- ----- ----- -----    Notes
graphics_keys:
    .byte 0x21,0x23,0x25,0x26,0x28,0x5f,0x1e,0x0c;  !     #     %     &     (     BARRW HOME  RIGHT    UARRW = Up Arrow
    .byte 0x22,0x24,0x27,0x5c,0x29,0xff,0x0a,0x7f;  "     0x    '     \     )     NONE  CSRDN DEL      BARRW = Back Arrow
    .byte 0x51,0x45,0x54,0x55,0x4f,0x5e,0x37,0x39;  Q     E     T     U     O     UARRW 7     9        NONE  = No key
    .byte 0x57,0x52,0x59,0x49,0x50,0xff,0x38,0x2f;  W     R     Y     I     P     NONE  8     /
    .byte 0x41,0x44,0x47,0x4a,0x4c,0xff,0x34,0x36;  A     D     G     J     L     NONE  4     6        STOP key is used as
    .byte 0x53,0x46,0x48,0x4b,0x3a,0xff,0x35,0x2a;  S     F     H     K     :     NONE  5     *        ESC since graphics
    .byte 0x5a,0x43,0x42,0x4d,0x3b,0x0d,0x31,0x33;  Z     C     B     M     ;     RETRN 1     3        keyboard has no ESC.
    .byte 0x58,0x56,0x4e,0x2c,0x3f,0xff,0x32,0x2b;  X     V     N     ,     ?     NONE  2     +
    .byte 0x01,0x40,0x5d,0xff,0x3e,0x01,0x30,0x2d;  SHIFT @     ]     NONE  >     SHIFT 0     -        SHIFT = 0x01
    .byte 0x00,0x5b,0x20,0x3c,0x1b,0xff,0x2e,0x3d;  RVS   [     SPACE >     STOP  NONE  .     =        RVS   = 0x00(CTRL key)

;80-column business keyboard table           ----- ----- ----- ----- ----- ----- ----- -----
business_keys:
    .byte 0xb2,0xb5,0xb8,0xad,0x38,0x0c,0xff,0xff;  ^2    ^5    ^8    -     8     CSRRT NONE  NONE     ^ = Bit 7 is set,
    .byte 0xb1,0xb4,0xb7,0x30,0x37,0x5e,0xff,0x39;  ^1    ^4    ^7    0     7     UARRW NONE  9            indicating the
    .byte 0x1b,0x53,0x46,0x48,0x5d,0x4b,0xbb,0x35;  ESC   S     F     H     ]     K     ;     5            key shifts to a
    .byte 0x41,0x44,0x47,0x4a,0x0d,0x4c,0x40,0x36;  A     D     G     J     RTRN  L     @     6            special character
    .byte 0x09,0x57,0x52,0x59,0x5c,0x49,0x50,0x7f;  TAB   W     R     Y     \     I     P     DEL
    .byte 0x51,0x45,0x54,0x55,0x0a,0x4f,0x5b,0x34;  Q     E     T     U     CSRDN O     [     4        STOP has no function
    .byte 0x01,0x43,0x42,0xae,0x2e,0xff,0x01,0x33;  SHIFT C     B     ^.    .     NONE  SHIFT 3        on business keyboard.
    .byte 0x5a,0x56,0x4e,0xac,0x30,0xff,0xff,0x32;  Z     V     N     ,     0     NONE  NONE  2
    .byte 0x00,0x58,0x20,0x4d,0x1e,0xff,0xaf,0x31;  RVS   X     SPACE M     HOME  NONE  ^/    1
    .byte 0x5f,0xb3,0xb6,0xb9,0xff,0xba,0xff,0xff;  BARRW ^3    ^6    ^9    STOP  ^:    NONE  NONE

;Storage locations used in keyboard scanning routine SCAN_KEYB
;
scancode:       .byte 0xaa  ;Holds scancode of the key
lastcode:       .byte 0xaa  ;Temporarily holds scancode of previous key
rowcount:       .byte 0xaa  ;Row counter for keyboard scan
shift_flag:     .byte 0xaa  ;SHIFT key flag
ctrl_flag:      .byte 0xaa  ;CTRL key flag
repeatcount0:   .byte 0xaa  ;Number of interrupts until start of key repeats
repeatcount1:   .byte 0xaa  ;Number of interrupts until next repeat
repeatcode:     .byte 0xaa  ;Scancode of last key; used in repeat handling

;Buffer for TAB stop positions (80 bytes: one for each screen column)
tab_stops = .

;Screen line pointer low bytes (25 bytes: one for each screen line)
scrline_los = tab_stops + 80

;Screen line pointer high bytes (25 bytes: one for each screen line)
scrline_his = scrline_los + 25

;ASCII to CBM screen code translation table (256 bytes)
asc_trans = scrline_his + 25

;Generated code for fast screen scroll up (175 bytes, see gen_scroll_up)
_scroll_up = asc_trans + 256

;Generated code for fast screen scroll down (175 bytes, see gen_scroll_down)
_scroll_down = _scroll_up + 175

;Generated code for fast clear to end of screen (175 bytes, see gen_clear_eos)
_clear_eos = _scroll_down + 175
