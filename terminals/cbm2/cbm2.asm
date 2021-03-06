;CBM-II Port of Softbox CP/M Loader
;Requires expansion RAM in Bank 15 (System Bank)
;
;Configure VICE
;  Settings > CBM2 Settings > Memory > Enable Bank 15 $4000-5FFF RAM
;
;B-series
;  bload"cbm2.prg",b15  ;BLOAD into bank 15
;  sys 16384            ;Start terminal
;
;P-series
;  sys 4                ;Start monitor
;  l"cbm2.prg",08       ;"08" is the device number in hex
;  g 4000               ;Start terminal
;

cinv_lo     = $0300   ;KERNAL IRQ vector LO
cinv_hi     = $0301   ;KERNAL IRQ vector HI
keyd        = $03ab   ;Keyboard Buffer
screen      = $d000   ;Start of screen RAM
vic         = $d800   ;6567/6569 VIC-II (P-series)
crtc        = $d800   ;6545 CRTC (B-series)
sid         = $da00   ;6581 SID
cia2_pa     = $dc00   ;6526 CIA #2 Port A
cia2_ddra   = $dc02   ;6526 CIA #2 Data Direction Register A
cia2_cra    = $dc0e   ;6526 CIA #2 Control Register A
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
scrorg      = $ffed   ;KERNAL Get screen dimensions
;
e6509       = $00     ;6509 Execute Register
i6509       = $01     ;6509 Indirect Register
scrline_lo  = $02     ;Pointer to start of current line in screen RAM - LO
scrline_hi  = $03     ;Pointer to start of current line in screen RAM - HI
cursor_x    = $04     ;Current X position: 0-79
cursor_y    = $05     ;Current Y position: 0-24
cursor_on   = $06     ;Cursor visible flag (hide = $00, show = $80)
cursor_tmp  = $07     ;Saves original cursor_on value during screen updates
scrcode     = $08     ;Screen code under the cursor
keycount    = $09     ;Number of keys in the buffer at keyd
columns     = $0a     ;Screen width (X) in characters (40 or 80)
lines       = $0b     ;Screen height (Y) in characters (24 or 25)
moveto_cnt  = $0c     ;Counts down bytes to consume in a move-to (CTRL_1B) seq
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
blink_on    = $1c     ;Cursor blink flag (blink off = $00, blink on = $80)
uppercase   = $1d     ;Uppercase graphics flag (lower = $00, upper = $80)
rvs_mask    = $1e     ;Reverse video mask (normal = $00, reverse = $80)
got_srq     = $1f     ;IEEE-488 SRQ detect: 0=no SRQ, 1=SRQ pending
hertz       = $20     ;Stores the system interrupt frequency: 50 or 60 Hz

    *=$4000

init:
    sei                 ;Disable interrupts
    ldx #$ff
    txs                 ;Initialize stack pointer
    lda #$0f
    sta i6509           ;Bank 15 (System Bank)
    lda #<irq_handler
    sta cinv_lo
    lda #>irq_handler
    sta cinv_hi         ;Install our interrupt handler
    lda #%0000011       ;Bit 1: IEEE-488 SRQ
                        ;Bit 0: 50/60 Hz
    sta tpi1_ddrc       ;TPI Interrupt Mask Register
    lda tpi1_pb
    and #%10111111
    sta tpi1_pb         ;Turn cassette motor off
    lda #$15
    sta sid+$18         ;SID mode/vol (used by bell)
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

init_scrn:
;Detect 40/80 column screen and store in columns.
;Initialize VIC-II registers for P500.
;Initialize cursor state.
;
    jsr scrorg          ;Returns X=columns, Y=lines
    stx columns         ;Initialize screen width to 40 or 80 columns
    dey
    sty lines           ;Initialize screen height to 24 lines

    cpx #40             ;40 column screen?
    bne init_scrn_done  ;  No: Skip P500 init
    lda #$00
    sta vic+$20         ;VIC-II Border color = Black
    sta vic+$21         ;VIC-II Background color = Black
init_scrn_done:
    lda #$00
    sta cursor_x        ;Initialize cursor position
    sta cursor_y
    jsr init_scrlines   ;Initialize screen line pointer table
    jsr get_scrline     ;Initialize current screen line pointer

    lda #$80
    sta cursor_on       ;Cursor state = show the cursor
    sta blink_on        ;Cursor blink = blinking on

    lda #$20            ;Screen code for space, also initial value for blink
    sta scrcode         ;Initialize screen code under the cursor
    sta blink_cnt       ;Initialize cursor blink countdown

                        ;Fall through to init_hertz

init_hertz:
;Initialize the powerline frequency constant used by our software clock.
;On power up, the KERNAL routine IOINIT on both B-series and P-series will
;detect 50 or 60 Hz and set the TODIN bit in CIA 2's Control Register A.
;
    lda #50
    bit cia2_cra        ;CRA Bit 7 (TODIN): off = 60 Hz, on = 50 Hz
    bmi store_hertz     ;Did the KERNAL set TODIN for 50 Hz?
    lda #60             ;  No: hertz = 60
store_hertz:
    sta hertz           ;  Yes: hertz = 50

init_term:
    jsr ctrl_16         ;Go to lowercase mode
    jsr ctrl_02         ;Go to 7-bit character mode
    jsr ctrl_06         ;Clear all tab stops
    lda #$00
    sta moveto_cnt      ;Move-to counter = not in a move-to seq
    lda #$1a            ;Load $1A = CTRL_1A Clear Screen
    jsr process_byte    ;Call into terminal to execute clear screen

init_ieee:
;
;6525 TPI #1 ($DE00)
;    PA7 NRFD
;    PA6 NDAC
;    PA5 EOI
;    PA4 DAV
;    PA3 ATN
;    PA2 REN
;    PA1 75161A pin  1 TE
;    PA0 75161A pin 11 DC
;
;    PB1 SRQ
;    PB0 IFC
;
;6526 CIA #2 ($DC00)
;    PA0-7 Data
;
    lda #$00
    sta got_srq         ;Initialize SRQ pending flag

    lda #$c6
    sta cia2_pa         ;Put $39 (SoftBox address) on IEEE data lines

    lda #$ff
    sta cia2_ddra       ;Data lines all outputs

    lda #%00100010      ;EOI=high, DAV=low, ATN=low, REN=low
    sta tpi1_pa

    lda #%00111111      ;PA7 NRFD  Input
                        ;PA6 NDAC  Input
                        ;PA5 EOI   Output
                        ;PA4 DAV   Output
                        ;PA3 ATN   Output
                        ;PA2 REN   Output
                        ;PA1 TE    Output
                        ;PA0 DC    Output
    sta tpi1_ddra

    ldx #$02
atn_wait:
    ldy #$00
atn_wait_1:
    dey
    bne atn_wait_1      ;Let $39 sit on the lines so the SoftBox sees it
    dex
    bne atn_wait

    lda #%00111010      ;EOI=high, DAV=high, ATN=high, REN=low, TE=high, DC=low
    sta tpi1_pa

    cli                 ;Enable interrupts again

main_loop:
    lda #$00
    sta cia2_ddra       ;Data lines all inputs

    lda #%11001000      ;NRFD=high, NDAC=high, ATN=high, REN=low, TE=low, DC=low
    sta tpi1_pa

    lda #%11001111      ;PA7 NRFD  Output
                        ;PA6 NDAC  Output
                        ;PA5 EOI   Input
                        ;PA4 DAV   Input
                        ;PA3 ATN   Output
                        ;PA2 REN   Output
                        ;PA1 TE    Output
                        ;PA0 DC    Output
    sta tpi1_ddra

wait_srq_low:
    lda got_srq
    beq wait_srq_low    ;Wait until the 6525 detects a falling edge on SRQ.

    dec got_srq         ;Clear SRQ pending flag (decrement 1 to 0)

wait_srq_high:
    lda tpi1_pb         ;Wait until SRQ returns high.
    and #%00000010      ;  The command byte is only valid after SRQ returns
    beq wait_srq_high   ;  high.  Unfortunately, SRQ is wired to a pin on the
                        ;  the 6525 that can't detect a rising edge.

    lda cia2_pa         ;Read IEEE data byte from SoftBox
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
                        ;
                        ;The CBM-II machines have different IEEE-488 hardware
                        ;and are not capable of driving some data lines while
                        ;reading others.  See the note below.

    lda #$bf            ;Response will be $40 (no key available)
    ldy keycount        ;Is the keyboard buffer empty?
    beq send_key_avail  ;  Yes: Keep response as $40 (no key available)
    lda #$7f            ;  No:  Response will be $80 (key available)

send_key_avail:
    sta cia2_pa         ;Put keyboard status on the bus

    lda #$ff
    sta cia2_ddra       ;Data lines all outputs

    lda #%00111010      ;EOI=high, DAV=high, ATN=high, REN=low, TE=high, DC=low
    sta tpi1_pa

    lda #%00111111      ;PA7 NRFD  Input
                        ;PA6 NDAC  Input
                        ;PA5 EOI   Output
                        ;PA4 DAV   Output
                        ;PA3 ATN   Output
                        ;PA2 REN   Output
                        ;PA1 TE    Output
                        ;PA0 DC    Output
    sta tpi1_ddra

                        ;At this point the SoftBox is guaranteed to be waiting
                        ;for bit 6 or 7 to be pulled low.  It will be within
                        ;this loop in its cbm_srq routine:
                        ;
                        ;  lfc95h:
                        ;    in a,(ppi1_pa) ;Read IEEE data byte
                        ;    and 0c0h       ;Mask off all except bits 6 and 7
                        ;    jr z,lfc95h    ;Wait one of those bits to go low
                        ;
                        ;One pass through the loop takes ~10 microseconds.

                        ;The PET/CBM code pulls bits 7-6 low, then waits for
                        ;the SoftBox to release bits 5-0 to high.  The CBM-II
                        ;hardware is not capable of this, so we must wait:

    ldy #$06            ;Delay count for B-series
    bit columns         ;80 columns?
    bvs send_k_a_wait   ;  Yes: Keep B-series count
    ldy #$02            ;  No:  Delay count for P-series

send_k_a_wait:          ;Wait at least 20 microseconds after the keyboard
    dey                 ;  status is put on the data bus to ensure the
    bne send_k_a_wait   ;  SoftBox receives it.

                        ;After the SoftBox receives the keyboard status, it
                        ;loops waiting for all data lines to return high.
                        ;The data lines will return high when we switch the
                        ;drivers back to input mode:

    lda #%11001111      ;PA7 NRFD  Output
                        ;PA6 NDAC  Output
                        ;PA5 EOI   Input
                        ;PA4 DAV   Input
                        ;PA3 ATN   Output
                        ;PA2 REN   Output
                        ;PA1 TE    Output
                        ;PA0 DC    Output
    sta tpi1_ddra

    lda #%00001000      ;NRFD=low, NDAC=low, ATN=high, REN=low, TE=low, DC=low
    sta tpi1_pa

    lda #$00
    sta cia2_ddra       ;Data lines all inputs

dispatch_command:
    cpx #$01            ;$01 = Key availability (sent with handshake, so done)
    beq main_loop
    cpx #$02            ;$02 = Wait for a key and send it
    beq do_get_key
    cpx #$04            ;$04 = Write to the terminal screen
    beq do_terminal
    cpx #$08            ;$08 = Execute a subroutine in CBM memory
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
    lda tpi1_pa
    ora #%10000000
    sta tpi1_pa         ;NRFD=high

l_05d7:
    lda tpi1_pa
    and #%00010000
    bne l_05d7          ;Wait until DAV=low

    lda cia2_pa         ;Read the data byte
    eor #$ff            ;Invert it
    pha                 ;Push data byte

    lda tpi1_pa
    and #%01111111      ;NRFD=low
    ora #%01000000      ;NDAC=high
    sta tpi1_pa

l_05ef:
    lda tpi1_pa
    and #%00010000
    beq l_05ef          ;Wait until DAV=high

    lda tpi1_pa
    and #%10111111      ;NDAC=low
    sta tpi1_pa
    pla
    rts

ieee_put_byte:
;Send a byte to the SoftBox over the IEEE-488 bus.
;
    eor #$ff            ;Invert the byte
    sta cia2_pa         ;Put byte on IEEE data output lines

    ;Switch IEEE to Output
    lda #$ff
    sta cia2_ddra       ;Data lines all outputs

    lda #%00111010      ;EOI=high, DAV=high, ATN=high, REN=low, TE=high, DC=low
    sta tpi1_pa

    lda #%00111111      ;PA7 NRFD  Input
                        ;PA6 NDAC  Input
                        ;PA5 EOI   Output
                        ;PA4 DAV   Output
                        ;PA3 ATN   Output
                        ;PA2 REN   Output
                        ;PA1 TE    Output
                        ;PA0 DC    Output
    sta tpi1_ddra

l_060d:
    bit tpi1_pa
    bpl l_060d          ;Wait until NRFD=high

    lda tpi1_pa
    and #%11101111      ;DAV=low
    sta tpi1_pa

l_0617:
    bit tpi1_pa
    bvc l_0617          ;Wait until NDAC=high

    lda tpi1_pa
    ora #%00010000      ;DAV=high
    sta tpi1_pa

l_0627:
    bit tpi1_pa
    bvs l_0627          ;Wait until NDAC=low

    ;Switch IEEE to Input
    lda #$00
    sta cia2_ddra       ;Data lines all inputs

    lda #%00001000      ;NRFD=low, NDAC=low, ATN=high, REN=low, TE=low, DC=low
    sta tpi1_pa

    lda #%11001111      ;PA7 NRFD  Output
                        ;PA6 NDAC  Output
                        ;PA5 EOI   Input
                        ;PA4 DAV   Input
                        ;PA3 ATN   Output
                        ;PA2 REN   Output
                        ;PA1 TE    Output
                        ;PA0 DC    Output
    sta tpi1_ddra

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
;On the CBM-II machines, an IRQ occurs at 50 or 60 Hz depending on the
;power line frequency.  The 6502 calls the main IRQ entry point which
;pushes A, X, and Y onto the stack and then executes JMP (cinv_lo).
;We install this routine, irq_handler, into cinv_lo during init.
;
    lda tpi1_air        ;Read the active interrupt

check_ieee:
    cmp #$02            ;IRQ from IEEE-488 SRQ?
    bne irq_50hz
    inc got_srq         ;Set SRQ pending flag (increment 0 to 1)
    jmp irq_done

;IRQ must have been caused by 50/60 Hz

irq_50hz:
;Update the jiffy clock
    inc jiffy0          ;Counts number of Interrupts
    bne irq_clock
    inc jiffy1          ;counter
    bne irq_clock
    inc jiffy2          ;counter

irq_clock:
;Update the software real time clock
    inc rtc_jiffies     ;Increment Jiffies
    lda rtc_jiffies
    cmp hertz           ;50 or 60 Hz
    bne irq_blink
    lda #$00            ;Reset RTC_JIFFIES counter
    sta rtc_jiffies
    inc rtc_secs        ;Increment Seconds
    lda rtc_secs
    cmp #$3c            ;Have we reached 60 seconds?
    bne irq_blink       ; No, skip
    lda #$00            ; Yes, reset seconds
    sta rtc_secs
    inc rtc_mins        ;Increment Minutes
    lda rtc_mins
    cmp #$3c            ;Have we reached 60 minutes?
    bne irq_blink       ; No, skip
    lda #$00            ; Yes, reset minutes
    sta rtc_mins
    inc rtc_hours       ;Increment hours
    lda rtc_hours
    cmp #$18            ;Have we reached 24 hours
    bne irq_blink       ; No, skip
    lda #$00            ; Yes, reset hours
    sta rtc_hours

irq_blink:
;Blink the cursor
    bit cursor_on       ;Is the cursor off?
    bpl irq_repeat      ;  No: skip cursor blink

    ldy cursor_x
    lda (scrline_lo),y  ;Read character at cursor

    bit blink_on        ;Is cursor blink on?
    bmi irq_blink_on    ;  Yes: branch to blink the cursor

    ora #$80            ;Set reverse bit for steady cursor
    bmi irq_blink_store

irq_blink_on:
    dec blink_cnt       ;Decrement cursor blink countdown
    bne irq_repeat      ;Not time to blink? Done.
    ldx #$14
    stx blink_cnt       ;Reset cursor blink countdown

    eor #$80            ;Flip reverse bit to blink cursor
irq_blink_store:
    sta (scrline_lo),y

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
    cmp #$ff            ;NO KEY?
    beq irq_scan        ;Yes, jump to scan for another
    lda repeatcount0    ;No, there was a key, so get the counter
    beq l_06bf          ;Is it zero?
    dec repeatcount0    ;Count Down
    bne irq_scan        ;Is it Zero
l_06bf:
    dec repeatcount1    ;Count Down
    bne irq_scan        ;Is it zero? No, scan for another
    lda #$04            ;Yes, Reset it to 4
    sta repeatcount1    ;Store it
    lda #$00            ;Clear the SCANCODE and allow the key to be processed
    sta scancode        ;Store it
    lda #$02
    sta blink_cnt       ;Blink cursor faster when key is repeating

irq_scan:
;Scan the keyboard
    jsr scan_keyb       ;Scan the keyboard
    beq irq_done        ;Nothing to do if no key was pressed.
    cmp #$05            ;F10 pressed for Softbox reset?
    beq irq_reset       ;  Yes: rti will start the reset routine
    cmp #$06            ;F9 pressed for simulate SRQ?
    bne irq_scan_2      ;  No: process the key normally
    inc got_srq         ;  Yes: set the SRQ flag (incr 0 to 1) and exit
    jmp irq_done
irq_scan_2:
    ldx keycount
    cpx #$50            ;Is the keyboard buffer full?
    beq irq_done        ;  Yes:  Nothing we can do.  Forget the key.
    sta keyd,x          ;  No:   Store the key in the buffer
    inc keycount        ;        and increment the keycount.

irq_done:
    sta tpi1_air        ;Pop interrupt off TPI interrupt stack
    pla
    tay                 ;Restore Y
    pla
    tax                 ;Restore X
    pla                 ;Restore A
    rti

irq_reset:
    sta tpi1_air        ;Pop interrupt off TPI interrupt stack
    ldx #$ff            ;Reset the stack pointer
    tsx
    lda #>reset_softbox ;Push reset routine as return address
    pha
    lda #<reset_softbox
    pha
    lda #$00            ;Push new status register
    pha
    rti

reset_softbox:
;Pulse IFC to reset the IEEE-488 bus, wait enough time for the
;SoftBox to start up, then start again from the beginning.
;
    jsr ctrl_1a         ;Clear screen
    lda #%00000010
    sta tpi1_pa         ;75161A TE=high
    lda tpi1_pb
    and #$fe
    sta tpi1_pb         ;IFC=low

    ldx #$80
    stx cursor_tmp      ;Turn cursor on
    stx cursor_on
    stx rtc_jiffies     ;Reset jiffy counter
    ldx #$0d
reset_ifc:
    cpx rtc_jiffies
    bcs reset_ifc       ;Wait while IFC is asserted
    ora #$01
    sta tpi1_pb         ;IFC=high

    ldx #$00
    stx rtc_secs        ;Reset seconds counter
    ldx #$05
reset_wait:
    cpx rtc_secs
    bcs reset_wait      ;Wait for SoftBox to start

    jmp init            ;Start again from the beginning

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
    sta (scrline_lo),y  ;Put it on the screen to erase the cursor
    txa                 ;Restore A
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
    tax
    lda asc_trans,x     ;Get CBM screen code for the character
    eor rvs_mask        ;Reverse the screen code if needed
    sta (scrline_lo),y  ;Write the screen code to screen RAM
    jsr ctrl_0c         ;Advance the cursor
process_done:
    jsr get_scrline     ;Update screen RAM pointer
    lda (scrline_lo),y  ;Get the screen code under the cursor
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
    sbc #$20            ;Pos = Pos - $20 (ADM-3A compatibility)

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
    ldy #$00            ;Start at ASCII code 0
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
    ldx #$5d            ;Change to PETSCII vertical line
    cmp #$7c            ;  from ASCII pipe ("|") character
    beq l_07c6
    ldx #$64            ;Change to PETSCII underscore
    cmp #$5f            ;  from ASCII underscore ("_") character
    beq l_07c6

    cmp #$40            ;Is it < 64?
    bcc trans_done      ;  Yes: done, no translation
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
    bpl trans_done      ;Branch if lowercase mode
    and #$1f
    jmp trans_done
l_07c6:
    txa
    jmp trans_done
l_07ca:
    and #$7f            ;Turn off bit 7
    ora #$40            ;Turn on bit 6
trans_done:
    rts

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
    !word ctrl_10   ;10   CTRL-P    Cursor on
    !word ctrl_11   ;11   CTRL-Q    Insert line
    !word ctrl_12   ;12   CTRL-R    Delete line
    !word ctrl_13   ;13   CTRL-S    Clear to end of line
    !word ctrl_14   ;14   CTRL-T    Clear to end of screen
    !word ctrl_15   ;15   CTRL-U    Go to uppercase mode
    !word ctrl_16   ;16   CTRL-V    Go to lowercase mode
    !word ctrl_17   ;17   CTRL-W    Set line spacing for graphics
    !word ctrl_18   ;18   CTRL-X    Set line spacing for text
    !word ctrl_19   ;19   CTRL-Y    Cursor off
    !word ctrl_1a   ;1A   CTRL-Z    Clear screen
    !word ctrl_1b   ;1B   ESC       Move cursor to X,Y position
    !word ctrl_1c   ;1C   CTRL-/    Insert character
    !word ctrl_1d   ;1D   CTRL-]    Delete character
    !word ctrl_1e   ;1E   CTRL-^    Home cursor
    !word ctrl_1f   ;1F             Do nothing

ctrl_00:
ctrl_03:
ctrl_1f:
;Do nothing
    rts

ctrl_01:
;Go to 8-bit character mode
;See trans_char for how this mode is used to display CBM graphics.
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

ctrl_15:
;Go to uppercase mode
;
    lda #$80
    sta uppercase       ;Set flag to indicate uppercase = on
    jsr init_asc_trans  ;Rebuild character translation table
    bit columns         ;40 columns?
    bvc ctrl_15_1       ;  Yes: branch to P-series routine
    lda tpi1_cr
    ora #%00010000
    sta tpi1_cr         ;B-series graphic mode = uppercase
    rts
ctrl_15_1:
    lda #$41
    sta vic+$18         ;P-series graphic mode = uppercase
    rts

ctrl_16:
;Go to lowercase mode
;
    lda #$00
    sta uppercase       ;Set flag to indicate uppercase = off
    jsr init_asc_trans  ;Rebuild character translation table
    bit columns         ;40 columns?
    bvc ctrl_16_1       ;  Yes: branch to P-series routine
    lda tpi1_cr
    and #%11101111
    sta tpi1_cr         ;B-series graphic mode = lowercase
    rts
ctrl_16_1:
    lda #$43
    sta vic+$18         ;P-series graphic mode = lowercase
    rts

ctrl_17:
;Set line spacing for graphics (the default spacing for uppercase mode).
;The current graphic mode will not be changed.
;
    rts                 ;No effect on CBM-II.

ctrl_18:
;Set line spacing for text (the default spacing for lowercase mode).
;The current graphic mode will not be changed.
;
    rts                 ;No effect on CBM-II.

ctrl_07:
;Ring bell
;
   bit columns          ;80 columns?
   bvs ctrl_07_b        ;  Yes: branch to B-series settings
ctrl_07_p:
   lda #$40             ;P-series settings
   ldx #$09
   jmp ctrl_07_bell
ctrl_07_b:
   lda #$20             ;B-series settings
   ldx #$0a
ctrl_07_bell:
   sta sid+$01          ;Voice 1 Freq Hi
   stx sid+$05          ;Voice 1 Attack/Decay
   lda #$00
   sta sid+$06          ;Voice 1 Sustain/Release
   sta sid+$04          ;Voice 1 = No waveform, Gate off
   lda #$11
   sta sid+$04          ;Voice 1 = Triangle waveform, Gate on
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
    ldx #$00
ctrl_1a_1:
    lda #$20            ;Space character
    sta screen,x        ;Fill first 1K
    sta screen+$100,x   ;  This is always screen RAM on both B-series
    sta screen+$200,x   ;  and P-series machines.
    sta screen+$300,x
    bit columns         ;80 columns?
    bvs ctrl_1a_2       ;  Yes: B-series, continue to fill with space char.
    lda #$0f            ;  No:  P-series, fill second 1K with Light Grey.
ctrl_1a_2:
    sta screen+$400,x   ;Fill second 1K
    sta screen+$500,x   ;  On B-series, this is more screen RAM.
    sta screen+$600,x   ;  On P-series, this is the VIC-II color RAM.
    sta screen+$700,x
    inx
    bne ctrl_1a_1
    rts

ctrl_10:
;Cursor on
;
    lda #$80
    sta cursor_tmp
    rts

ctrl_19:
;Cursor off
;
    lda #$00
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
    ldy cursor_x
    lda #$20            ;Space character
l_0863:
    sta (scrline_lo),y  ;Write space to screen RAM
    iny                 ;X=X+1
    cpy columns
    bne l_0863          ;Loop until end of line
    rts

ctrl_14:
;Clear to end of screen.  All lines below the current line will be
;erased.  The current line and cursor position are not changed.
;
    jsr ctrl_13         ;Clear to the end of the current line
    ldx cursor_y        ;Get current Y position
ctrl_14_next:
    inx                 ;Y=Y+1
    cpx lines           ;Incremented past last line?
    beq ctrl_14_done    ;  Yes: done

    lda scrline_los,x   ;Get scrline pointer
    sta scrline_lo
    lda scrline_his,x
    sta scrline_hi
ctrl_14_eraline:
    lda #$20            ;Space character
    ldy columns
ctrl_14_erachar:
    dey
    sta (scrline_lo),y
    bne ctrl_14_erachar ;Loop until entire line is erased
    beq ctrl_14_next    ;Loop to do next line
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
;Insert character
;
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
;Delete character
;
    ldy cursor_x
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
;Delete line
;
;The current line is replaced by the one below it, and each successive
;line is replaced by the one below it.  The bottommost screen line is
;cleared.  The cursor is moved to the first column of the current line.
;
    lda #$00
    sta cursor_x       ;Move cursor to beginning of line

    ldx cursor_y       ;Scroll from current line to bottom of screen
    jmp scroll         ;Jump out to scroll

ctrl_11:
;Insert line
;
;The current line is cleared and its original contents moved to the
;line below it.  Each successive line is moved to one below it.  The
;cursor is moved to the first column of the current line.
;
    ldx lines
    dex                 ;Index of last line on the screen
l_0951:
    cpx cursor_y        ;Source line index = current line index?
    beq l_097c          ;  Yes: done copying lines
    dex                 ;Decrement source line index

    lda scrline_los,x   ;Get source line pointer
    sta source_lo
    lda scrline_his,x
    sta source_hi

    lda scrline_los+1,x ;Get target line pointer
    sta target_lo
    lda scrline_his+1,x
    sta target_hi

    ldy columns         ;Copy source line into target line
    dey
l_0970:
    lda (source_lo),y
    sta (target_lo),y
    dey
    bpl l_0970          ;Loop until this line is copied
    bmi l_0951          ;Loop to do the next line

l_097c:                 ;Erase current line with spaces
    lda #$20
    ldy columns
l_0980:
    dey
    sta (scrline_lo),y
    bne l_0980

    lda #$00            ;Move cursor to beginning of line
    sta cursor_x
    rts

init_scrlines:
;Build the screen line pointer tables.
;
    ldy #$00            ;Start at line 0
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
    lda #$00
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

scroll_up:
;Scroll the entire screen up one line.
;
    ldx #$00            ;Start scrolling from the top line
                        ;Fall through to scroll.

scroll:
;Scroll the screen up one line starting at the Y-position given in X.
;Any lines above the starting line will not be changed.
;The cursor position will not be changed.
;
    lda scrline_los+1,x ;Get source line pointer
    sta source_lo
    lda scrline_his+1,x
    sta source_hi

    lda scrline_los,x   ;Get target line pointer
    sta target_lo
    lda scrline_his,x
    sta target_hi

    inx                 ;Increment the index to move down one
                        ;  screen line for the next time around

    cpx lines           ;Current line = last line on screen?
    beq scroll_erase    ;  Yes: do not copy, branch to finish up

    ldy columns         ;Copy source line into target line
    dey
scroll_cp_loop:
    lda (source_lo),y
    sta (target_lo),y
    dey
    bpl scroll_cp_loop  ;Loop until this line is copied
    bmi scroll          ;Loop to do the next line

scroll_erase:           ;Erase the bottom line
    lda #$20
    ldy columns
scroll_era_loop:
    dey
    sta (target_lo),y
    bne scroll_era_loop ;Loop until line is erased
    rts

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
; USES: scancode   - Code of Pressed KEY ($FF=NONE)
;       lastcode   - Code of Previous KEY
;       rowcount   - Keyboard ROW counter
;       shift_flag - SHIFT key flag
;       ctrl_flag  - CTRL key flag
;       keyoffset  - Pointer into keyboard table
;
    lda scancode        ;Old SCANCODE
    sta lastcode        ;Save It
    ldx #$00            ;X=0 Index into Keyboard Scan Table
    stx keyoffset       ;Reset index into table
    stx shift_flag      ;Reset SHIFT key flag
    stx ctrl_flag       ;Reset CTRL key flag
    lda #$ff            ;$FF = no key
    sta scancode        ;Set it
    lda #$0             ;Keyboard has 16 ROWS
    sta rowcount        ;ROW=0 - Keyboard ROW counter

;---- top of loop for keyboard ROWS
;
scan_row:
;We need to set ALL bits on PORTA and PORTB to ONE, except the line we need to check
;The KEY_SEL table holds the values to place in the port. We use the ROW as an offset into the tables.
;There are THREE sets of 8 bytes so that the middle is common, we use an offset of 0 for PORTB so
;that it starts at $FF (no row selected) and an offset of 8 for PORTA to that it starts at $FE.
;As the ROW increases the ZERO bit 'walks' from one port to the other without doing any
;complicated bit shifting and comparing
;
    ldx rowcount        ;Get Keyboard ROW counter. Use as offset to table
    lda key_sel1,x      ;Get value to place in PORTA
    sta tpi2_pa         ;set it
    lda key_sel2,x      ;Get value to place in PORTB
    sta tpi2_pb         ;set it

debounce:
    lda tpi2_pc         ;TPI2 Port C- Keyboard Columns Read
    cmp tpi2_pc         ;TPI2 Port C- Keyboard Columns Read
    bne debounce        ;wait for stable value on keyboard switches (debounce)
    and #%00111111      ;Mask off top two bits (used for machine configuration)
                        ;Result of Row scan is now in A (call is SCANCODE)

    ldy #$06            ;Y=6 -- 6 Columns in Table

;---- top of loop to go through each bit returned from scan. Each "0" bit represents a key pressed down

scan_col:
    lsr ;a              ;Shift byte RIGHT leaving CARRY flag set if it is a "1"
    pha                 ;Push it to the stack
    bcs nextcol         ;Is the BIT a "1"? Yes. Means key was NOT pressed. Bypass testing
    ldx keyoffset
    lda key_table,x     ;  Yes, read from keyboard table
    cmp #$01            ;IS it the SHIFT key?
    beq key_shift       ; Yes, skip
    bcc key_reg         ; No, It's a regular key
    sta scancode        ;Store the SCANCODE as-is
    bcs nextcol

key_shift:
    inc shift_flag      ;Increment SHIFT Flag
    bne nextcol         ; Is it >0? Yes, loop back for another key

key_reg:
    inc ctrl_flag       ;Increment CTRL key flag
                        ;Fall through to nextcol

nextcol:
    pla                 ;pull the original scan value from stack
    inc keyoffset       ;X=X+1 - next entry in table
    dey                 ;Y=Y-1 - next BIT in scan value
    bne scan_col        ;Is it ZERO? No, go back for next COL

nextrow:
    inc rowcount        ;ROW=ROW+1
    lda rowcount
    cmp #$10            ;Is it ROW 16?
    bne scan_row        ;  NO, loop back up for next ROW

;-------------------------------------- end of scanning loops
; Check if there is anything to do. SCANCODE will be $FF if no key.
; If the SCANCODE = LASTCODE then key is being held down. Don't do anything until it is released.
; The IRQ handler implements key repeat by clearing the SCANCODE after a short interval.

    lda scancode        ;Get the current SCANCODE
    cmp #$ff            ;Is it NO KEY?
    beq keydone         ; Yes, exit
    cmp lastcode        ;Is it the same as last? (Key is registered on key UP?)
    beq keydone         ; Yes, exit

;---- Check for CTRL key
key_check1:
    cmp #$00            ;Compare to CTRL key
    bpl key_low         ;No, skip

;---- CTRL KEY not pressed
key_hi:
    and #%01111111      ;Clear bit 7
    ldy shift_flag      ;SHIFT key pressed?
    beq key_low         ;  No: skip translation to symbol

    ldx #$22            ;Change to $22 ( " )
    cmp #$27            ;  from $27 ( ' )
    beq key_in_x
    ldx #$3c            ;Change to $3c ( < )
    cmp #$2c            ;  from $2c ( , )
    beq key_in_x
    ldx #$29            ;Change to $29 ( ) )
    cmp #$30            ;  from $30 ( 0 )
    beq key_in_x
    ldx #$40            ;Change to $40 ( @ )
    cmp #$32            ;  from $30 ( 2 )
    beq key_in_x
    ldx #$5e            ;Change to $5e ( ^ )
    cmp #$36            ;  from $36 ( 6 )
    beq key_in_x
    ldx #$26            ;Change to $26 ( & )
    cmp #$37            ;  from $37 ( 7 )
    beq key_in_x
    ldx #$2a            ;Change to $2a ( * )
    cmp #$38            ;  from $38 ( 8 )
    beq key_in_x
    ldx #$28            ;Change to $28 ( ( )
    cmp #$39            ;  from $39 ( 9 )
    beq key_in_x
    ldx #$3a            ;Change to $3a ( : )
    cmp #$3b            ;  from $3b ( ; )
    beq key_in_x
    ldx #$2b            ;Change to $2a ( + )
    cmp #$3d            ;  from $38 ( = )
    beq key_in_x

    eor #$10            ;Invert bit 4 to shift the character
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
    ldx #$1a            ;Change to $1a (clear screen)
    cmp #$1e            ;  from $1e (home)
    beq key_in_x

;---- these must be normal shifted keys or Graphics?
    bit uppercase
    bpl key_set         ;Branch if lowercase mode
    ora #$80            ;Set the HIGH BIT
    rts                 ;Return with character code in A?

;---- Return the key in the X register
key_in_x:
    txa
    rts                 ;Return with the key in A

key_set:
    cmp #$00
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
    !byte $ff,$1b,$09,$ff,$01,$00 ; F1    ESC   TAB   NONE  SHIFT CTRL   ^ = Bit 7 is set,
    !byte $ff,$b1,$51,$41,$5a,$ff ; F2    ^1    Q     A     Z     NONE       indicating the
    !byte $ff,$b2,$57,$53,$58,$43 ; F3    ^2    W     S     X     C          key shifts to a
    !byte $ff,$b3,$45,$44,$46,$56 ; F4    ^3    E     D     F     V          special character
    !byte $ff,$b4,$52,$54,$47,$42 ; F5    ^4    R     T     G     B
    !byte $ff,$b5,$b6,$59,$48,$4e ; F6    ^5    6     Y     H     N
    !byte $ff,$b7,$55,$4a,$4d,$20 ; F7    ^7    U     J     M     SPACE
    !byte $ff,$b8,$49,$4b,$ac,$ae ; F8    ^8    I     K     ^,    ^.
    !byte $06,$b9,$4f,$4c,$bb,$af ; F9    ^9    NONE  L     ^;    ^/
    !byte $05,$b0,$2d,$50,$5b,$a7 ; F10   ^0    -     P     [     ^'
    !byte $0a,$bd,$5f,$5d,$0d,$de ; DOWN  ^=    BARRW ]     RETRN PI
    !byte $0b,$08,$0c,$7f,$02,$ff ; UARRW LEFT  RIGHT DEL   CBM   NONE
    !byte $1e,$3f,$37,$34,$31,$30 ; HOME  ?     7     4     1     0
    !byte $12,$04,$38,$35,$32,$2e ; RVS   CE    8     5     2     .
    !byte $8e,$2a,$39,$36,$33,$30 ; GRAPH *     9     6     3     00
    !byte $03,$2f,$2d,$2b,$0d,$ff ; STOP  /     -     +     ENTER NONE


;Storage locations used in keyboard scanning routine SCAN_KEYB
;
scancode:       !byte $aa   ;Holds scancode of the key
lastcode:       !byte $aa   ;Temporarily holds scancode of previous key
rowcount:       !byte $aa   ;Row counter for keyboard scan
shift_flag:     !byte $aa   ;SHIFT key flag
ctrl_flag:      !byte $aa   ;CTRL key flag
repeatcount0:   !byte $aa   ;Number of interrupts until start of key repeats
repeatcount1:   !byte $aa   ;Number of interrupts until next repeat
repeatcode:     !byte $aa   ;Scancode of last key; used in repeat handling
keyoffset:      !byte $aa   ;Pointer into keyboard table

;Buffer for TAB stop positions (80 bytes: one for each screen column)
tab_stops = *

;Screen line pointer low bytes (50 bytes: one for each screen line)
scrline_los = tab_stops + 80

;Screen line pointer high bytes (50 bytes: one for each screen line)
scrline_his = scrline_los + 50

;ASCII to CBM screen code translation table (256 bytes)
asc_trans = scrline_his + 50
