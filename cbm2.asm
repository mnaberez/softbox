INTVECL     = $0300   ;Hardware interrupt vector LO
INTVECH     = $0301   ;Hardware interrupt vector HI
KEYBUF      = $03AB   ;Keyboard Input Buffer
TPI1_PB     = $DE01   ;6525 TPI #1 Port B
TPI1_CR     = $DE06   ;6525 TPI #1 Control Register
TPI1_AIR    = $DE07   ;6525 TPI #1 Active Interrupt Register
TPI2_PA     = $DF00   ;6525 TPI #1 Port A - Keyboard Row select LO
TPI2_PB     = $DF01   ;6525 TPI #1 Port B - Keyboard Row select HI
TPI2_PC     = $DF02   ;6525 TPI #1 Port C - Keyboard Col read
SCREEN      = $D000   ;Start of screen RAM
CHROUT      = $FFD2   ;Kernal Print a byte
;
EXE_REG     = $00     ;6509 Execute Register
IND_REG     = $01     ;6509 Indirect Register
SCNPOSL     = $02     ;Pointer to current screen -LO
SCNPOSH     = $03     ;Pointer to current screen -HI
CURSOR_X    = $04     ;Current X position: 0-79
CURSOR_Y    = $05     ;Current Y position: 0-24
CURSOR_OFF  = $06     ;Cursor state: zero = show, nonzero = hide
SCNCODE_TMP = $07     ;Temporary storage for the last screen code
KEYCOUNT    = $08     ;Number of keys in the buffer at KEYBUF
X_WIDTH     = $09     ;Width of X in characters (40 or 80)
REVERSE     = $0A     ;Reverse video flag (reverse on = 1)
MOVETO_CNT  = $0B     ;Counts down bytes to consume in a move-to (CTRL_1B) seq
CURSOR_TMP  = $0C     ;Pending cursor state used with CURSOR_OFF
TARGET_LO   = $0D     ;Target address for mem xfers, ind jump, & CTRL_11 - LO
TARGET_HI   = $0E     ;Target address for mem xfers, ind jump, & CTRL_11 - HI
INSERT_LO   = $0F     ;Insert line (CTRL_11) destination screen address - LO
INSERT_HI   = $10     ;Insert line (CTRL_11) destination screen address - HI
XFER_LO     = $11     ;Memory transfer byte counter - LO
XFER_HI     = $12     ;Memory transfer byte counter - HI
CHAR_MASK   = $13     ;Masks incoming bytes for 7- or 8-bit character mode
RTC_JIFFIES = $14     ;Software Real Time Clock
RTC_SECS    = $15     ;  The RTC locations can't be changed because they
RTC_MINS    = $16     ;  are accessed directly by the SoftBox CP/M program
RTC_HOURS   = $17     ;  TIME.COM using DO_READ_MEM and DO_WRITE_MEM.
JIFFY2      = $18     ;Jiffy counter (MSB)
JIFFY1      = $19     ;Jiffy counter
JIFFY0      = $1A     ;Jiffy counter (LSB)
BLINK_CNT   = $1B     ;Counter used for cursor blink timing

;Configure VICE
;  Settings > CBM2 Settings > Memory > Enable Bank 15 $C000-CFFF RAM
;
;Load and Run
;  BLOAD"CBM2.PRG",B15
;  BANK 15 : SYS 49152

    *=$C000

INIT:
    SEI                ;Disable interrupts
    LDA #$0F
    STA EXE_REG
    STA IND_REG        ;Bank 15 (System Bank)
    LDA #<INT_HANDLER
    STA INTVECL
    LDA #>INT_HANDLER
    STA INTVECH        ;Install our interrupt handler
    LDA #$00
    STA KEYCOUNT       ;Reset key counter (no keys hit)
    LDA #$00
    STA RTC_JIFFIES    ;Reset software real time clock
    STA RTC_SECS
    STA RTC_MINS
    STA RTC_HOURS
    STA JIFFY2         ;Reset jiffy counter
    STA JIFFY1
    STA JIFFY0
    LDA #$0A
    STA REPEATCOUNT1   ;Store #$0A in REPEATCOUNT1
    CLI                ;Enable interrupts again
    JSR CTRL_16        ;Go to lowercase mode
    JSR CTRL_02        ;Go to 7-bit character mode
    LDA #$14
    STA BLINK_CNT      ;Initialize cursor blink countdown
    LDA #$00
    STA CURSOR_OFF     ;Cursor state = show the cursor
    STA MOVETO_CNT     ;Move-to counter = not in a move-to seq

INIT_4080:
;Detect 40/80 column screen and store in X_WIDTH
;
;TODO: Detect P500 and set to 40 columns.
;
    LDA #$50           ;80 column screen
    STA X_WIDTH

INIT_TERM:
    LDA #$1A           ;Load #$1A = CTRL_1A Clear Screen
    JSR PROCESS_BYTE   ;Call into terminal to execute clear screen
    JSR CTRL_06        ;Clear all tab stops

;TODO: Temporary hack until the code below is ported
    LDA #$48           ;"H"
    JSR PROCESS_BYTE
    LDA #$69           ;"i"
    JSR PROCESS_BYTE
    LDA #$0D           ;Carriage return
    JSR PROCESS_BYTE
    LDA #$0A           ;Line feed
    JSR PROCESS_BYTE

FOREVER:
    JSR GET_KEY        ;Wait for a key
    JSR PROCESS_BYTE   ;Send it to the terminal screen
    JMP FOREVER


INIT_IEEE:
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
    LDA $E822          ;Clears IRQA1 flag (!ATN_IN detect)
    LDA $E840
    AND #$FB
    STA $E840          ;Set !ATN_OUT = 0 to get SoftBox's attention
    LDA #$34
    STA $E823          ;Set !DAV_OUT = 0 to tell SoftBox our data is valid
    LDA #$C6
    STA $E822          ;Put #$39 on IEEE data lines
    LDY #$00

L_04D4:
    DEY
    BNE L_04D4         ;Let #$39 sit on the lines so the SoftBox sees it

    LDA #$FF
    STA $E822          ;Release IEEE data lines

    LDA #%00111100
    STA $E811          ;Set !EOI_OUT = 1 and disable IRQ from CA1 (Cassette Read)
    STA $E821          ;Set !NDAC_OUT = 1 and disable IRQ from CA1 (!ATN_IN)
    STA $E823          ;Set !DAV = 1

MAIN_LOOP:
    LDA #$3C
    STA $E821          ;Set !NDAC_OUT = 1
    LDA $E840
    ORA #$06
    STA $E840          ;Set !NRFD_OUT = 1, !ATN_OUT = 1

WAIT_FOR_SRQ:
    LDA $E823          ;Read PIA #2 CRB
    ASL ;A             ;  bit 7 = IRQA1 flag for CA1 (!SRQ_IN detect)
    BCC WAIT_FOR_SRQ   ;Wait until !SRQ_IN is detected

    LDA $E822          ;Clears IRQA1 flag (!SRQ_IN detect)
    LDA #$34
    STA $E821          ;Set !NDAC_OUT = 0 to indicate we do not accept the data yet

    LDX $E820          ;Read IEEE data byte with command from SoftBox
                       ;
                       ; Bit 7: PET to SoftBox: Key not available
                       ; Bit 6: PET to SoftBox: Key available
                       ; Bit 5: SoftBox to PET: Transfer from the SoftBox to PET memory
                       ; Bit 4: SoftBox to PET: Transfer from PET memory to the SoftBox
                       ; Bit 3: SoftBox to PET: Jump to an address
                       ; Bit 2: SoftBox to PET: Write to the terminal screen
                       ; Bit 1: SoftBox to PET: Wait for a key and send it
                       ; Bit 0: SoftBox to PET: Key available?

    TXA                ;Remember the original command byte in X
    ROR ;A
    LDA #$7F           ;Next byte we'll put on IEEE will be #$80 (no key available)
    BCS SEND_KEY_AVAIL ;Bypass the key buffer check if SoftBox doesn't want key status

    LDY KEYCOUNT       ;Is there a key in the buffer?
    BNE SEND_KEY_AVAIL ;  No:  Response will be #$80 (no key available)
    LDA #$BF           ;  Yes: Response will be #$40 (key available)

SEND_KEY_AVAIL:
    STA $E822          ;Drive only bit 7 (no key) or bit 6 (key) on the bus

HANDSHAKE:
    LDA $E820          ;Read IEEE data byte
    AND #$3F           ;We are driving only bits 7 and 6 with the keyboard status
    CMP #$3F
    BNE HANDSHAKE      ;Wait for the SoftBox to drive the other lines to zero
    LDA #$FF
    STA $E822          ;Release all data lines

DISPATCH_COMMAND:
    TXA                ;Recall the original command byte from X
    ROR ;A             ;Bit 0: Key availability was already answered above
    BCC MAIN_LOOP      ;       so we're done
    ROR ;A
    BCC DO_GET_KEY     ;Bit 1: Wait for a key and send it
    ROR ;A
    BCC DO_TERMINAL    ;Bit 2: Write to the terminal screen
    ROR ;A
    BCC DO_JUMP        ;Bit 3: Jump to an address
    ROR ;A
    BCC DO_READ_MEM    ;Bit 4: Transfer from PET memory to the SoftBox
    JMP DO_WRITE_MEM   ;Bit 5: Transfer from the SoftBox to PET memory

DO_GET_KEY:
;Wait for a key and send it to the SoftBox.
;
;At the CP/M "A>" prompt, the SoftBox sends this command and then
;waits for the PET to answer.
;
    JSR GET_KEY         ;Block until we get a key.  Key will be in A.
    JSR IEEE_SEND_BYTE  ;Send the key to the Softbox.
    JMP MAIN_LOOP

DO_TERMINAL:
;Write to the terminal screen
    JSR IEEE_GET_BYTE
    LDX #$3C
    STX $E821          ;Set !NDAC_OUT = 1 to indicate we accept the data
    JSR PROCESS_BYTE
    JMP MAIN_LOOP

DO_JUMP:
;Jump to an address
    JSR IEEE_GET_BYTE  ;Get byte
    STA TARGET_LO      ; -> Command vector lo
    JSR IEEE_GET_BYTE  ;Get byte
    STA TARGET_HI      ; -> Command vector hi
    LDX #$3C
    STX $E821          ;Set !NDAC_OUT = 1 to indicate we accept the data
    JSR JUMP_CMD       ;Jump to the command through CMDVECL
    JMP MAIN_LOOP

DO_READ_MEM:
;Transfer bytes from PET memory to the SoftBox
    JSR IEEE_GET_BYTE
    STA XFER_LO
    JSR IEEE_GET_BYTE
    STA XFER_HI
    JSR IEEE_GET_BYTE
    STA TARGET_LO
    JSR IEEE_GET_BYTE
    STA TARGET_HI
    LDY #$00
L_05A5:
    DEY
    BNE L_05A5   ; delay
L_05A8:
    LDA (TARGET_LO),Y
    JSR IEEE_SEND_BYTE
    INY
    BNE L_05B2
    INC TARGET_HI
L_05B2:
    LDA XFER_LO
    SEC
    SBC #$01
    STA XFER_LO
    LDA XFER_HI
    SBC #$00
    STA XFER_HI
    ORA XFER_LO
    BNE L_05A8
    JMP MAIN_LOOP

DO_WRITE_MEM:
;Transfer from the SoftBox to PET memory
    JSR IEEE_GET_BYTE
    STA XFER_LO
    JSR IEEE_GET_BYTE
    STA XFER_HI
    JSR IEEE_GET_BYTE
    STA TARGET_LO
    JSR IEEE_GET_BYTE
    STA TARGET_HI
    LDY #$00
L_0571:
    JSR IEEE_GET_BYTE
    STA (TARGET_LO),Y
    INY
    BNE L_057B
    INC TARGET_HI
L_057B:
    LDA XFER_LO
    SEC
    SBC #$01
    STA XFER_LO
    LDA XFER_HI
    SBC #$00
    STA XFER_HI
    ORA XFER_LO
    BNE L_0571
    JMP MAIN_LOOP

IEEE_GET_BYTE:
;Receive a byte from the SoftBox over the IEEE-488 bus.
;
    LDA $E840
    ORA #$02
    STA $E840          ;Set !NRFD OUT = 1
L_05D7:
    BIT $E840          ;Wait for !NRFD_IN = 1 (SoftBox is ready for data)
    BMI L_05D7         ;Wait for !DAV_IN = 0 (Softbox says data is valid)

    LDA $E820          ;Read data byte
    EOR #$FF           ;Invert the byte (IEEE true = low)
    PHA                ;Push data byte
    LDA $E840
    AND #$FD
    STA $E840          ;Set !NRFD_OUT = 0 (we are not ready for data)
    LDA #$3C
    STA $E821          ;Set !NDAC_OUT = 1 (we accept the last data byte)
L_05EF:
    BIT $E840
    BPL L_05EF         ;Wait for !DAV_IN = 0 (SoftBox says data is valid)
    LDA #$34
    STA $E821          ;Set NDAC_OUT = 0 (we do not accept data)
    PLA
    RTS

IEEE_SEND_BYTE:
;Send a byte to the SoftBox over the IEEE-488 bus.
;
    EOR #$FF           ;Invert the byte (IEEE true = low)
    STA $E822          ;Put byte on IEEE data output lines
    LDA $E840
    ORA #$02
    STA $E840          ;Set !NRFD_OUT = 1
    LDA #$3C
    STA $E821          ;Set !NDAC_OUT = 1
L_060D:
    BIT $E840
    BVC L_060D         ;Wait for !NRFD_IN = 1 (SoftBox is ready for data)
    LDA #$34
    STA $E823          ;Set !DAV_OUT = 0 to indicate our data is valid
L_0617:
    LDA $E840
    LSR ;A
    BCC L_0617         ;Wait for SoftBox to set NDAC_IN = 0 (not accepted)
    LDA #$3C
    STA $E823          ;Set !DAV_OUT = 1
    LDA #$FF
    STA $E822          ;Release data lines
L_0627:
    LDA $E840
    LSR ;A
    BCS L_0627         ;Wait for SoftBox to set !NDAC_IN = 1 (data accepted)
    RTS

GET_KEY:
;Get the next key waiting from the keyboard buffer and return
;it in the accumulator.  If there is no key, this routine will
;block until it gets one.  Meanwhile, the interrupt handler
;calls SCAN_KEYB and puts any key into the buffer.
;
    LDA #$FF        ;FF = no key
    SEI             ;Disable interrupts
    LDX KEYCOUNT    ;Is there a key waiting in the buffer?
    BEQ L_0649      ;  No: nothing to do with the buffer.
    LDA KEYBUF      ;Read the next key in the buffer (FIFO)
    PHA             ;Push the key onto the stack
    LDX #$00
    DEC KEYCOUNT    ;Keycount = Keycount - 1
L_063D:
    LDA KEYBUF+1,X  ;Remove the key from the buffer by rotating
    STA KEYBUF,X    ;  bytes in the buffer to the left
    INX
    CPX KEYCOUNT    ;Finished updating the buffer?
    BNE L_063D      ;  No: loop until we're done.
    PLA             ;Pull the key off the stack.
L_0649:
    CLI             ;Enable interrupts again
    CMP #$FF        ;No key or key is "NONE" in the tables?
    BEQ GET_KEY     ;  No key:  loop until we get one.
    RTS             ;  Got key: done.  Key is now in A.

INT_HANDLER:
;On the PET, an IRQ occurs at 50 or 60 Hz depending on the power line
;frequency.  The 6502 calls the main IRQ entry point ($E442 on BASIC 4.0)
;which pushes A, X, and Y onto the stack and then executes JMP (INTVECL).
;We install this routine, INT_HANDLER, into INTVECL during init.
;
    LDA IND_REG
    PHA                 ;Preserve 6509 Indirect Register

CHECK_TPI1:             ;IRQ from TPI #1?
    LDA TPI1_AIR
    BNE CHECK_ACIA
    JMP IRQ_DONE
CHECK_ACIA:
    CMP #$10            ;IRQ from ACIA?
    BNE CHECK_PROC
    JMP IRQ_DONE
CHECK_PROC:
    CMP #$08            ;IRQ from Coprocessor?
    BNE CHECK_CIA
    JMP IRQ_DONE
CHECK_CIA:
    CMP #$04            ;IRQ from CIA?
    BNE CHECK_IEEE
    JMP IRQ_DONE
CHECK_IEEE:
    CMP #$02            ;IRQ from IEEE-488?
    BNE IRQ_50HZ
    JMP IRQ_DONE

;IRQ must have been caused by 50/60 Hz
;
IRQ_50HZ:
    INC JIFFY0          ;Counts number of Interrupts
    BNE L_0659
    INC JIFFY1          ;counter
    BNE L_0659
    INC JIFFY2          ;counter
L_0659:
    INC RTC_JIFFIES     ;Increment Jiffies
    LDA RTC_JIFFIES

;--    CMP BAS_HEADER+3    ;50 or 60 (Hz).  See note in BAS_HEADER.
    CMP #$32            ;Force 50 Hz for now

    BNE BLINK_CURSOR
    LDA #$00            ;Reset RTC_JIFFIES counter
    STA RTC_JIFFIES
    INC RTC_SECS        ;Increment Seconds
    LDA RTC_SECS
    CMP #$3C            ;Have we reached 60 seconds?
    BNE BLINK_CURSOR    ; No, skip
    LDA #$00            ; Yes, reset seconds
    STA RTC_SECS
    INC RTC_MINS        ;Increment Minutes
    LDA RTC_MINS
    CMP #$3C            ;Have we reached 60 minutes?
    BNE BLINK_CURSOR    ; No, skip
    LDA #$00            ; Yes, reset minutes
    STA RTC_MINS
    INC RTC_HOURS       ;Increment hours
    LDA RTC_HOURS
    CMP #$18            ;Have we reached 24 hours
    BNE BLINK_CURSOR    ; No, skip
    LDA #$00            ; Yes, reset hours
    STA RTC_HOURS
BLINK_CURSOR:
    LDA CURSOR_OFF      ;Is the cursor off?
    BNE L_069F          ;  Yes: skip cursor blink
    DEC BLINK_CNT       ;Decrement cursor blink countdown
    BNE L_069F          ;Not time to blink? Done.
    LDA #$14
    STA BLINK_CNT       ;Reset cursor blink countdown
    JSR CALC_SCNPOS
    LDA (SCNPOSL),Y     ;Read character at cursor
    EOR #$80            ;Flip the REVERSE bit
    STA (SCNPOSL),Y     ;Write it back
L_069F:
    LDA SCANCODE        ;Get the SCANCODE
    CMP REPEATCODE      ;Compare to SAVED scancode
    BEQ L_06B1          ;They are the same, so continue
    STA REPEATCODE      ;if not, save it
    LDA #$10            ;reset counter
    STA REPEATCOUNT0    ;save to counter
    BNE IRQ_KEY
L_06B1:
    CMP #$FF            ; NO KEY?
    BEQ IRQ_KEY         ; Yes, jump to scan for another
    LDA REPEATCOUNT0    ; No, there was a key, so get the counter
    BEQ L_06BF          ; Is it zero?
    DEC REPEATCOUNT0    ; Count Down
    BNE IRQ_KEY         ; Is it Zero
L_06BF:
    DEC REPEATCOUNT1    ; Count Down
    BNE IRQ_KEY         ; Is it zero? No, scan for another
    LDA #$04            ; Yes, Reset it to 4
    STA REPEATCOUNT1    ; Store it
    LDA #$00            ;Clear the SCANCODE and allow the key to be processed
    STA SCANCODE        ;Store it
    LDA #$02
    STA BLINK_CNT       ;Fast cursor blink(?)
IRQ_KEY:
L_06D2:
    JSR SCAN_KEYB       ;Scan the keyboard
    BEQ L_06E2          ;Nothing to do if no key was pressed.
    LDX KEYCOUNT
    CPX #$50            ;Is the keyboard buffer full?
    BEQ L_06E2          ;  Yes:  Nothing we can do.  Forget the key.
    STA KEYBUF,X        ;  No:   Store the key in the buffer
    INC KEYCOUNT        ;        and increment the keycount.

L_06E2:
;http://www.von-bassewitz.de/uz/oldcomputers/p500/rom500.s.html
;TODO: Comment and simplify if possible.  These routines were
;borrowed from the bottom of the P500 interrupt handler.
P500_FC95:
    LDA TPI1_PB
    BPL P500_LFCA3
    ORA #$40
    BNE P500_LFCAA
P500_LFCA3:
    AND #$BF
P500_LFCAA:
    STA TPI1_PB
P500_LFCAD:
    STA TPI1_AIR
    LDA #$FF
    STA TPI1_PB
    STA TPI1_AIR

IRQ_DONE:
    PLA
    STA IND_REG        ;Restore 6502 indirect register
    PLA
    TAY                ;Restore Y
    PLA
    TAX                ;Restore X
    PLA                ;Restore A
    RTI

PROCESS_BYTE:
;This is the core of the terminal emulator.  It accepts a byte in
;the accumulator, determines if it is a control code or character
;to display, and then jumps accordingly.  After the jump, all
;code paths will end up at PROCESS_DONE.
;
    PHA
    LDA CURSOR_OFF    ;Get the current cursor state
    STA CURSOR_TMP    ;  Remember it
    LDA #$FF
    STA CURSOR_OFF    ;Hide the cursor
    JSR CALC_SCNPOS   ;Calculate screen RAM pointer
    LDA SCNCODE_TMP   ;Get the screen code previously saved
    STA (SCNPOSL),Y   ;  Put it on the screen
    PLA
    AND CHAR_MASK     ;Mask off bits depending on char mode
    LDX MOVETO_CNT    ;More bytes to consume for a move-to seq?
    BNE L_0715        ;  Yes: branch to jump to move-to handler
    CMP #$20          ;Is this byte a control code?
    BCS L_0718        ;  No: branch to put char on screen
    ASL ;A
    TAX
    LDA CTRL_CODES,X  ;Load vector from control code table
    STA TARGET_LO
    LDA CTRL_CODES+1,X
    STA TARGET_HI
    JSR JUMP_CMD      ;Jump to vector to handle control code
    JMP PROCESS_DONE
L_0715:
    JMP MOVE_TO       ;Jump to handle move-to sequence
L_0718:
    JMP PUT_CHAR      ;Jump to put character on the screen
JUMP_CMD:
    JMP (TARGET_LO)   ;Jump to handle the control code

CTRL_CODES:
;Terminal control code dispatch table.  These control codes are based
;on the Lear Seigler ADM-3A terminal.  Some bytes that are unused on
;that terminal are used for other purposes here.
;
    !word CTRL_00   ; Do nothing
    !word CTRL_01   ; Go to 8-bit character mode
    !word CTRL_02   ; Go to 7-bit character mode
    !word CTRL_03   ; Do nothing
    !word CTRL_04   ; Set TAB STOP at current position
    !word CTRL_05   ; Clear TAB STOP at current position
    !word CTRL_06   ; Clear all TAB STOPS
    !word CTRL_07   ; Ring bell
    !word CTRL_08   ; Cursor left
    !word CTRL_09   ; Perform TAB
    !word CTRL_0A   ; Line feed
    !word CTRL_0B   ; Cursor up
    !word CTRL_0C   ; Cursor right
    !word CTRL_0D   ; Carriage return
    !word CTRL_0E   ; Reverse video on
    !word CTRL_0F   ; Reverse video off
    !word CTRL_10   ; Cursor off
    !word CTRL_11   ; Insert a blank line
    !word CTRL_12   ; Scroll up one line
    !word CTRL_13   ; Clear to end of line
    !word CTRL_14   ; Clear to end of screen
    !word CTRL_15   ; Go to uppercase mode
    !word CTRL_16   ; Go to lowercase mode
    !word CTRL_17   ; Set line spacing to tall
    !word CTRL_18   ; Set line spacing to short
    !word CTRL_19   ; Cursor on
    !word CTRL_1A   ; Clear screen
    !word CTRL_1B   ; Move cursor to X,Y position
    !word CTRL_1C   ; Insert a space on current line
    !word CTRL_1D   ; Delete character at cursor
    !word CTRL_1E   ; Home cursor
    !word CTRL_1F   ; Do nothing

CTRL_07:
;Ring bell
;
    LDA #$07   ;CHR$(7) = Bell
    JMP CHROUT ;Kernal Print a byte

CTRL_18:
;Set line spacing to tall (the default spacing for lowercase graphic mode).
;The current graphic mode will not be changed.
;
    RTS          ;No effect on CBM-II.


CTRL_17:
;Set line spacing to short (the default spacing for uppercase graphic mode).
;The current graphic mode will not be changed.
;
    RTS          ;No effect on CBM-II.

CTRL_01:
;Go to 8-bit character mode
;See PUT_CHAR for how this mode is used to display CBM graphics.
;
    LDA #$FF
    STA CHAR_MASK
    RTS

CTRL_02:
;Go to 7-bit character mode
;
    LDA #$7F
    STA CHAR_MASK
    RTS

CTRL_00:
CTRL_03:
CTRL_1F:
;Do nothing
    RTS

PUTSCN_THEN_DONE:
;Put the screen code in the accumulator on the screen
;and then fall through to PROCESS_DONE.
;
    JSR PUT_SCNCODE

PROCESS_DONE:
;This routine always returns to DO_TERMINAL except during init.
;
    JSR CALC_SCNPOS   ;Calculate screen RAM pointer
    LDA (SCNPOSL),Y   ;Get the current character on the screen
    STA SCNCODE_TMP   ;  Remember it
    LDA CURSOR_TMP    ;Get the previous state of the cursor
    STA CURSOR_OFF    ;  Restore it
    RTS

PUT_CHAR:
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
    CMP #$40              ;Is it < 64?
    BCC PUTSCN_THEN_DONE  ;  Yes: done, put it on the screen
    CMP #$60              ;Is it >= 96?
    BCS L_07A6            ;  Yes: branch to L_07A6
    AND #$3F              ;Turn off bits 6 and 7
    JMP L_07AC            ;Jump to L_07CA
L_07A6:
    CMP #$80              ;Is bit 7 set?
    BCS L_07CA            ;  Yes: branch to L_07CA
    AND #$5F
L_07AC:
    TAX
    AND #$3F              ;Turn off bit 7 and bit 6
    BEQ L_07C6
    CMP #$1B
    BCS L_07C6
    TXA
    EOR #$40              ;Flip bit 6
    TAX
    LDA TPI1_CR           ;Bit 4 on = uppercase, off = lowercase
    AND #%00010000
    BEQ L_07C6            ;Branch if lowercase mode
    TXA
    AND #$1F
    JMP PUTSCN_THEN_DONE
L_07C6:
    TXA
    JMP PUTSCN_THEN_DONE
L_07CA:
    AND #$7F              ;Turn off bit 7
    ORA #$40              ;Turn on bit 6
    JMP PUTSCN_THEN_DONE  ;Put it on the screen

CTRL_15:
;Go to uppercase mode
;
    LDA TPI1_CR
    ORA #%00010000
    STA TPI1_CR             ;Graphic mode = uppercase
    RTS

CTRL_16:
;Go to lowercase mode
;
    LDA TPI1_CR
    AND #%11101111
    STA TPI1_CR            ;Graphic mode = lowercase
    RTS

CTRL_08:
;Cursor left
;
    LDX CURSOR_X
    BNE L_07E9     ; X > 0? Y will not change.
    LDX X_WIDTH    ; X = max X + 1
    LDA CURSOR_Y
    BEQ L_07EC     ; Y=0? Can't move up.
    DEC CURSOR_Y   ; Y=Y-1
L_07E9:
    DEX
    STX CURSOR_X   ; X=X-1
L_07EC:
    RTS

CTRL_0B:
;Cursor up
;
    LDY CURSOR_Y
    BEQ L_07EC     ; Y=0? Can't move up.
    DEC CURSOR_Y   ; Y=Y-1
    RTS

PUT_SCNCODE:
;Put the screen code in A on the screen at the current cursor position
;
    LDX REVERSE      ;Is reverse video mode on?
    BEQ L_07FA       ;  No:  leave character alone
    EOR #$80         ;  Yes: Flip bit 7 to reverse the character
L_07FA:
    JSR CALC_SCNPOS  ;Calculate screen RAM pointer
    STA (SCNPOSL),Y  ;Write the character to the screen
                     ;Fall through into CTRL_0C to advance cursor

CTRL_0C:
;Cursor right
;
    INC CURSOR_X   ;X=X+1
    LDX CURSOR_X
    CPX X_WIDTH    ;X > max X?
    BNE L_0817     ;  No:  Done, no need to scroll up.
    LDA #$00       ;  Yes: Set X=0 and then
    STA CURSOR_X   ;       fall through into CTRL_0A to scroll.

CTRL_0A:
;Line feed
;
    LDY CURSOR_Y
    CPY #$18       ;Are we on line 24?
    BNE L_0814     ;  No:  Done, scroll is not needed
    JMP SCROLL_UP  ;  Yes: Scroll the screen up first
L_0814:
    INC CURSOR_Y   ;Increment Y position
    RTS
L_0817:
    RTS

CTRL_1E:
;Home cursor
;
    LDA #$00       ;Home cursor
    STA CURSOR_Y
    STA CURSOR_X
    RTS

CTRL_1A:
;Clear screen
;
    LDX #$00      ; Home cursor
    STX CURSOR_X
    STX CURSOR_Y
    STX REVERSE   ;Reverse video off
    LDA #$20      ;Space character
L_0829:
    STA SCREEN,X
    STA SCREEN+$100,X
    STA SCREEN+$200,X
    STA SCREEN+$300,X
    STA SCREEN+$400,X
    STA SCREEN+$500,X
    STA SCREEN+$600,X
    STA SCREEN+$700,X
    INX
    BNE L_0829
    RTS

CTRL_0D:
;Carriage return
;
    LDA #$00       ;Move to X=0 on this line
    STA CURSOR_X
    RTS

CTRL_10:
;Cursor on
;
    LDA #$00
    STA CURSOR_TMP
    RTS

CTRL_19:
;Cursor off
;
    LDA #$FF
    STA CURSOR_TMP
    RTS

CTRL_0E:
;Reverse video on
;
    LDA #$01
    STA REVERSE
    RTS

CTRL_0F:
;Reverse video off
;
    LDA #$00
    STA REVERSE
    RTS

CTRL_13:
;Clear to end of line
;
    JSR CALC_SCNPOS    ;Leaves CURSOR_X in Y register
    LDA #$20           ;Space character
L_0863:
    STA (SCNPOSL),Y    ;Write space to screen RAM
    INY                ;X=X+1
    CPY X_WIDTH
    BNE L_0863         ;Loop until end of line
    RTS

CTRL_14:
;Clear from Current line to end of screen
;
    JSR CTRL_13     ;Clear to the end of the current line
    LDX CURSOR_Y    ;Get the Current line#
L_0870:
    INX             ;Next Row
    CPX #$19        ;Is it 25 (last line of screen?
    BEQ L_088D      ;  Yes, we're done
    CLC             ;  No, continue
    LDA SCNPOSL     ;Current screen position
    ADC X_WIDTH     ;Add the line width
    STA SCNPOSL     ;Save it
    BCC L_0880      ;Need to update HI?
    INC SCNPOSH     ;  Yes, increment HI pointer
L_0880:
    LDA #$20        ;SPACE
    LDY #$00        ;Position 0
L_0884:
    STA (SCNPOSL),Y ;Write a space
    INY             ;Next character
    CPY X_WIDTH     ;Is it end of line?
    BNE L_0884      ;No, loop back for more on this line
    BEQ L_0870      ;Yes, loop back for next line
L_088D:
    RTS

SCROLL_UP:
;Scroll the screen up one line
;
    LDA #$00
    STA SCNPOSL
    LDA X_WIDTH
    STA TARGET_LO
    LDA #>SCREEN
    STA SCNPOSH
    STA TARGET_HI
    LDX #$18
L_089E:
    LDY #$00
L_08A0:
    LDA (TARGET_LO),Y
    STA (SCNPOSL),Y
    INY
    CPY X_WIDTH
    BNE L_08A0
    LDA TARGET_LO
    STA SCNPOSL
    CLC
    ADC X_WIDTH
    STA TARGET_LO
    LDA TARGET_HI
    STA SCNPOSH
    ADC #$00
    STA TARGET_HI
    DEX
    BNE L_089E
    LDY #$00
    LDA #$20          ;SPACE
L_08C1:
    STA (SCNPOSL),Y
    INY
    CPY X_WIDTH
    BNE L_08C1
    RTS

CTRL_04:
;Set TAB stop at current position
;
    LDA #$01         ;1=TAB STOP yes
    !byte $2C ; Falls through to become BIT $00A9

CTRL_05:
;Clear TAB stop at current position
;
    LDA #$00         ;0=No TAB STOP
    LDX CURSOR_X     ;Get cursor position
    STA TAB_STOPS,X  ;Clear the TAB at that position
    RTS

CTRL_06:
;Clear ALL TAB STOPS
;
    LDX #$4F  ; 80 characters-1
    LDA #$00  ; zero
L_08D8:
    STA TAB_STOPS,X  ;store in the buffer
    DEX
    BPL L_08D8
    RTS

CTRL_09:
;Perform TAB.  Move to next TAB STOP as indicated in the TAB_STOPS table.
;
    LDX CURSOR_X
L_08E1:
    INX               ; next position
    CPX #$50          ; 80 characters?
    BCS L_08ED        ; yes, exit
    LDA TAB_STOPS,X   ; read from the TAB STOPS table
    BEQ L_08E1        ; is it zero? yes, loop again
    STX CURSOR_X      ; no, we hit a STOP, so store the position
L_08ED:
    RTS

CTRL_1C:
;Insert space at current cursor position
;
    JSR CALC_SCNPOS
    LDY X_WIDTH       ;number of characters on line
    DEY
L_08F4:
    CPY CURSOR_X
    BEQ L_0901
    DEY
    LDA (SCNPOSL),Y    ;read a character from line
    INY                ;position to the right
    STA (SCNPOSL),Y    ;write it back
    DEY                ;we are counting down to zero
    BNE L_08F4         ;loop for another character
L_0901:
    LDA #$20           ; SPACE
    STA (SCNPOSL),Y    ; Write it to current character position
    RTS

CTRL_1D:
;Delete a character
;
    JSR CALC_SCNPOS
    LDY CURSOR_X
L_090B:
    INY
    CPY X_WIDTH
    BEQ L_0918
    LDA (SCNPOSL),Y    ;read a character from the line
    DEY                ;position to the left
    STA (SCNPOSL),Y    ;write it back
    INY                ;we are counting UP
    BNE L_090B         ;loop for another character
L_0918:
    DEY
    LDA #$20           ;SPACE
    STA (SCNPOSL),Y    ;write it to the current character position
    RTS

CTRL_12:
;Scroll up one line
;
;The screen is shifted upward so that each line Y+1 is copied into Y.  Screen
;contents are preserved except for the bottommost line, which is erased
;(filled with spaces).  The current cursor position will not be changed.
;
    LDA #$00
    STA CURSOR_X
    JSR CALC_SCNPOS
    LDA $02
    CLC
    ADC X_WIDTH
    STA TARGET_LO
    LDA SCNPOSH
    ADC #$00
    STA TARGET_HI
    LDA #$18
    SEC
    SBC CURSOR_Y
    TAX
    JMP L_089E         ;Jump into SCROLL_UP, bypassing some init

CTRL_11:
;Insert a blank line
;
;The screen is shifted downward so that each line Y is copied into Y+1.
;The line at the current position will be erased (filled with spaces).
;The current cursor position will not be changed.
;
    LDA #<SCREEN+$03C0 ;A->TARGET_LO, Y->TARGET_HI
    LDY #>SCREEN+$03C0 ;Start address of last 40 col line
    LDX X_WIDTH
    CPX #$50           ;Is this an 80 column screen?
    BNE L_0949         ;  No: keep address for 40 col
    LDA #<SCREEN+$0780
    LDY #>SCREEN+$0780 ;Start address of last 80 col line
L_0949:
    STA TARGET_LO
    STY TARGET_HI
    LDA #$00
    STA CURSOR_X
L_0951:
    LDA TARGET_LO
    CMP SCNPOSL
    BNE L_095D
    LDA TARGET_HI
    CMP SCNPOSH
    BEQ L_097C
L_095D:
    LDA TARGET_LO
    STA INSERT_LO
    SEC
    SBC X_WIDTH
    STA TARGET_LO
    LDA TARGET_HI
    STA INSERT_HI
    SBC #$00
    STA TARGET_HI
    LDY #$00
L_0970:
    LDA (TARGET_LO),Y
    STA (INSERT_LO),Y
    INY
    CPY X_WIDTH
    BNE L_0970
    JMP L_0951
L_097C:
    LDY #$00
    LDA #$20          ;SPACE
L_0980:
    STA (SCNPOSL),Y
    INY
    CPY X_WIDTH
    BNE L_0980
    RTS

CALC_SCNPOS:
;Calculate a new pointer to screen memory (SCNPOSL/SCNPOSH)
;from cursor position at CURSOR_X and CURSOR_Y
;
    PHA
    LDA #$00
    STA SCNPOSH
    LDA CURSOR_Y
    STA SCNPOSL
    ASL ;A
    ASL ;A
    ADC SCNPOSL
    ASL ;A
    ASL ;A
    ROL SCNPOSH
    ASL ;A
    ROL SCNPOSH
    STA SCNPOSL
    LDA X_WIDTH
    CMP #$50
    BNE L_09A8
    ASL SCNPOSL
    ROL SCNPOSH
L_09A8:
    CLC
    LDY CURSOR_X
    LDA SCNPOSH
    ADC #>SCREEN
    STA SCNPOSH
    PLA
    RTS

CTRL_1B:
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
    LDA #$02          ;Two more bytes to consume (X-pos, Y-pos)
    STA MOVETO_CNT    ;Store count for next pass of PROCESS_BYTE
    RTS

MOVE_TO:
;Implements CTRL_1B by handling the X-position byte on the first call
;and the Y-position byte on the second call.  After the Y-position byte
;has been consumed, MOVETO_CNT = 0, exiting the move-to sequence.
;
    DEC MOVETO_CNT    ;Decrement bytes remaining to consume
    BEQ L_09C8        ;Already got X pos?  Handle this byte as Y.
    SEC
    SBC #$20          ;X-pos = X-pos - #$20
    CMP X_WIDTH       ;Requested X position out of range?
    BCS L_09C5        ;  Yes: Do nothing.
    STA CURSOR_X      ;  No:  Move cursor to requested X.
L_09C5:
    JMP PROCESS_DONE  ;Done.
L_09C8:
    SEC
    SBC #$20          ;Y-pos = Y-pos - #$20
    CMP #$19          ;Requested Y position out of range?
    BCS L_09C5        ;  Yes: Do nothing.
    STA CURSOR_Y      ;  No:  Move cursor to requested Y.
    JMP PROCESS_DONE  ;Done.

SCAN_KEYB:
;Scan the keyboard.
;TODO: Implementation for CBM-II keyboard
;
; TPI2_PA     = $DF00   ;6525 TPI #1 Port A - Keyboard Row select LO
; TPI2_PB     = $DF01   ;6525 TPI #1 Port B - Keyboard Row select HI
; TPI2_PC     = $DF02   ;6525 TPI #1 Port C - Keyboard Col read

    LDA #$FF          ;No key hit
    STA SCANCODE
    STA LASTCODE
    RTS

SK_TOP:
    LDA #$00
    RTS

;---------- Keyboard Table
KEY_TABLE:
;                                   ----- ----- ----- ----- ----- -----
;                                   COL0  COL1  COl2  COL3  COL4  COL5
;                                   ----- ----- ----- ----- ----- -----
    !byte $FF,$1B,$09,$FF,$01,$00 ; F1    ESC   TAB   NONE  SHIFT CTRL
    !byte $FF,$31,$51,$41,$5A,$FF ; F2    1     Q     A     Z     NONE
    !byte $FF,$32,$57,$53,$58,$43 ; F3    2     W     S     X     C
    !byte $FF,$33,$45,$44,$46,$56 ; F4    3     E     D     F     V
    !byte $FF,$34,$52,$54,$47,$42 ; F5    4     R     T     G     B
    !byte $FF,$35,$36,$59,$48,$4E ; F6    5     6     Y     H     N
    !byte $FF,$37,$55,$4A,$4D,$20 ; F7    7     U     J     M     SPACE
    !byte $FF,$38,$49,$4B,$2C,$2E ; F8    8     I     K     ,     .
    !byte $FF,$39,$4F,$4C,$3B,$2F ; F9    9     NONE  L     ;     /
    !byte $FF,$30,$2D,$50,$5B,$27 ; F10   0     -     P     [     '
    !byte $11,$3D,$5F,$5D,$0D,$DE ; DOWN  =     BARRW ]     RETRN PI
    !byte $91,$9D,$1D,$14,$02,$FF ; UP    LEFT  RIGHT DEL   CBM   NONE
    !byte $13,$3F,$37,$34,$31,$30 ; HOME  ?     7     4     1     0
    !byte $12,$04,$38,$35,$32,$2E ; RVS   CE    8     5     2     .
    !byte $8E,$2A,$39,$36,$33,$30 ; GRAPH *     9     6     3     00
    !byte $03,$2F,$2D,$2B,$0D,$FF ; STOP  /     -     +     ENTER NONE


;Storage locations used in keyboard scanning routine SCAN_KEYB
SCANCODE:
    !byte $AA

LASTCODE:
    !byte $AA

ROWCOUNT:
    !byte $AA

SHIFTFLAG:
    !byte $AA

KEYFLAG:
    !byte $AA

REPEATCOUNT0:
    !byte $AA

REPEATCOUNT1:
    !byte $AA

REPEATCODE:
    !byte $AA

;Start of buffer used by control codes 05, 06, and 09
TAB_STOPS:
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
    !byte $AA,$AA,$AA,$AA,$AA,$AA,$AA
