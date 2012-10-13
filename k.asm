; Auto Disassembly of: k
;----- Equates
;
INTVECL     = $90     ;hardware interrupt vector LO
INTVECH     = $91     ;hardware interrupt vector HI
KEYBUF      = $026F   ;Keyboard Input Buffer
SCREEN      = $8000   ;Start of screen ram
PIA1ROW     = $E810   ;PIA#1 Keyboard Row Select
PIA1COL     = $E812   ;PIA#1 Keyboard Columns Read
PIA2IEEE    = $E820   ;PIA#2 IEEE Input
PIA2NDAC    = $E821   ;PIA#2 IEEE NDAC control
PIA2IOUT    = $E822   ;PIA#2 IEEE Output
PIA2DAV     = $E823   ;PIA#2 IEEE DAV control
VIAPB       = $E840   ;VIA PortB
VIA_PCR     = $E84C   ;VIA Peripheral Control Register (PCR)
CHROUT      = $FFD2   ;Kernal Print a byte
;
BLINK_CNT   = $01     ;Counter used for cursor blink timing
SCNPOSL     = $02     ;Pointer to current screen -LO
SCNPOSH     = $03     ;Pointer to current screen -HI
CURSOR_X    = $04     ;Current X position: 0-79
CURSOR_Y    = $05     ;Current Y position: 0-24
CURSOR_OFF  = $06     ;Cursor state: hide cursor if 0, else show cursor
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
; ?????     = $13     ;????????
; ?????     = $14     ;????????
; ?????     = $15     ;????????
; ?????     = $16     ;????????
; ?????     = $17     ;????????
; ?????     = $18     ;????????
; ?????     = $19     ;????????
; ?????     = $1A     ;????????
;
*=$0400

;"50 sys(1039)"
$0400:           .BYT 00,0D,04,32,00,9E,28,31 ;tokenized basic
$0408:           .BYT 30,33,39,29,00,00,00    ;tokenized basic
;
$040F: 4C 66 04  JMP INIT

;"  SOFTBOX LOADER (C) COPYRIGHT 1981 KEITH FREWIN   "
;"----  REVISON :  5 JULY 1981     "
$0412:           .BYT 20,20,53,4F,46,54,42,4F ;copyright text
$041A:           .BYT 58,20,4C,4F,41,44,45,52 ;copyright text
$0422:           .BYT 20,28,43,29,20,43,4F,50 ;copyright text
$042A:           .BYT 59,52,49,47,48,54,20,31 ;copyright text
$0432:           .BYT 39,38,31,20,4B,45,49,54 ;copyright text
$043A:           .BYT 48,20,46,52,45,57,49,4E ;copyright text
$0442:           .BYT 20,20,20,2D,2D,2D,2D,20 ;copyright text
$044A:           .BYT 20,52,45,56,49,53,4F,4E ;copyright text
$0452:           .BYT 20,3A,20,20,35,20,4A,55 ;copyright text
$045A:           .BYT 4C,59,20,31,39,38,31,20 ;copyright text
$0462:           .BYT 20,20,20,20             ;copyright text

:INIT
$0466: 78        SEI                ;Disable interrupts
$0467: A9 4F     LDA #<INT_HANDLER  ;Interrupt handler address LO (#$4F)
$0469: 85 90     STA INTVECL
$046B: A9 06     LDA #>INT_HANDLER  ;Interrupt handler address HI (#$06)
$046D: 85 91     STA INTVECH        ;Install interrupt handler
$046F: A9 00     LDA #$00
$0471: 85 08     STA KEYCOUNT       ;Initialize key counter (no keys hit)
$0473: A9 00     LDA #$00           ;Initialize other zero page locations
$0475: 85 14     STA $14
$0477: 85 15     STA $15
$0479: 85 16     STA $16
$047B: 85 17     STA $17
$047D: 85 18     STA $18
$047F: 85 19     STA $19
$0481: 85 1A     STA $1A
$0483: A9 0A     LDA #$0A
$0485: 8D 3D 0B  STA UNKNOWN_7      ;Store #$0A in UNKNOWN_7 (?)
$0488: 58        CLI                ;Enable interrupts again
$0489: A9 0E     LDA #$0E
$048B: 8D 4C E8  STA VIA_PCR        ;CA2 = High Output (IEEE-488 /NDAC = 1)
$048E: 20 84 07  JSR CTRL_02        ;CTRL_02 stores #$7F in $13
$0491: A9 14     LDA #$14
$0493: 85 01     STA BLINK_CNT      ;Initialize cursor blink countdown
$0495: A9 00     LDA #$00
$0497: 85 06     STA CURSOR_OFF     ;Cursor state = show the cursor
$0499: 85 0B     STA MOVETO_CNT     ;Move-to counter = not in a move-to seq

:INIT_4080
;Detect 40/80 column screen and store in X_WIDTH
;
;This routine checks for an 80 column screen by writing to screen RAM
;that should not be present on a 40 column machine.  If the computer
;has been modified so that it has a 40 column screen but the extra
;screen RAM is present, this routine will think the machine has 80 columns.
;
;X_WIDTH is also used in the keyboard scanning routine to select between
;business keyboard (80 columns) or graphics keyboard (40 columns).  This
;means the 2001B machines (40-column, business keyboard) are not supported.
;
;Question: assuming good screen RAM, under what circumstances
;          would the check at $04AE fail?
;
$049B: A9 28     LDA #$28
$049D: 85 09     STA X_WIDTH        ;X_WIDTH = 40 characters
$049F: A9 55     LDA #$55
$04A1: 8D 00 80  STA SCREEN         ;Start of screen RAM for both 40 and 80 cols
$04A4: 0A        ASL A
$04A5: 8D 00 84  STA SCREEN+$400    ;Store test byte in first page of 80 col RAM
$04A8: CD 00 84  CMP SCREEN+$400    ;Test byte for 80 column RAM successful?
$04AB: D0 08     BNE INIT_TERM      ;  No: we're done, X_WIDTH = 40.
$04AD: 4A        LSR A
$04AE: CD 00 80  CMP SCREEN         ;Test byte for common screen RAM successful?
$04B1: D0 02     BNE INIT_TERM      ;  No:  we're done, X_WIDTH = 40.
$04B3: 06 09     ASL X_WIDTH        ;  Yes: X_WIDTH = 80 characters

:INIT_TERM
$04B5: A9 1A     LDA #$1A           ;Load #$1A = CTRL_1A Clear Screen
$04B7: 20 E8 06  JSR PROCESS_BYTE   ;Call into terminal to execute clear screen
$04BA: 20 D4 08  JSR CTRL_06        ;Clear all tab stops

:INIT_IEEE
$04BD: AD 22 E8  LDA PIA2IOUT       ;PIA#2 IEEE Output
$04C0: AD 40 E8  LDA VIAPB          ;VIA PortB
$04C3: 29 FB     AND #$FB
$04C5: 8D 40 E8  STA VIAPB          ;VIA PortB
$04C8: A9 34     LDA #$34
$04CA: 8D 23 E8  STA PIA2DAV        ;PIA#2 IEEE DAV control
$04CD: A9 C6     LDA #$C6
$04CF: 8D 22 E8  STA PIA2IOUT       ;PIA#2 IEEE Output
$04D2: A0 00     LDY #$00
:L_04D4
$04D4: 88        DEY
$04D5: D0 FD     BNE L_04D4         ;delay loop
$04D7: A9 FF     LDA #$FF
$04D9: 8D 22 E8  STA PIA2IOUT       ;PIA#2 IEEE Output
$04DC: A9 3C     LDA #$3C
$04DE: 8D 11 E8  STA $E811
$04E1: 8D 21 E8  STA PIA2NDAC       ;PIA#2 IEEE NDAC control
$04E4: 8D 23 E8  STA PIA2DAV        ;PIA#2 IEEE DAV control

:MAIN_LOOP
$04E7: A9 3C     LDA #$3C
$04E9: 8D 21 E8  STA PIA2NDAC       ;PIA#2 IEEE NDAC control
$04EC: AD 40 E8  LDA VIAPB          ;VIA PortB
$04EF: 09 06     ORA #$06
$04F1: 8D 40 E8  STA VIAPB          ;VIA PortB
:L_04F4
$04F4: AD 23 E8  LDA PIA2DAV        ;PIA#2 IEEE DAV control
$04F7: 0A        ASL A
$04F8: 90 FA     BCC L_04F4
$04FA: AD 22 E8  LDA PIA2IOUT       ;PIA#2 IEEE Output
$04FD: A9 34     LDA #$34
$04FF: 8D 21 E8  STA PIA2NDAC       ;PIA#2 IEEE NDAC control
$0502: AE 20 E8  LDX PIA2IEEE       ;PIA#2 IEEE Input
$0505: 8A        TXA
$0506: 6A        ROR A
$0507: A9 7F     LDA #$7F
$0509: B0 06     BCS L_0511
$050B: A4 08     LDY KEYCOUNT
$050D: D0 02     BNE L_0511
$050F: A9 BF     LDA #$BF
:L_0511
$0511: 8D 22 E8  STA PIA2IOUT       ;PIA#2 IEEE Output
:L_0514
$0514: AD 20 E8  LDA PIA2IEEE       ;PIA#2 IEEE Input
$0517: 29 3F     AND #$3F
$0519: C9 3F     CMP #$3F
$051B: D0 F7     BNE L_0514
$051D: A9 FF     LDA #$FF
$051F: 8D 22 E8  STA PIA2IOUT       ;PIA#2 IEEE Output
$0522: 8A        TXA
;
; It looks like a control byte is received first where
; each bit indicates a different function to perform:
;
$0523: 6A        ROR A
$0524: 90 C1     BCC MAIN_LOOP      ;Do nothing
$0526: 6A        ROR A
$0527: 90 0C     BCC DO_GET_KEY     ;Wait for a key and send it to the SoftBox
$0529: 6A        ROR A
$052A: 90 0C     BCC DO_TERMINAL    ;Write to the terminal screen
$052C: 6A        ROR A
$052D: 90 17     BCC DO_JUMP        ;Jump to an address
$052F: 6A        ROR A
$0530: 90 5D     BCC DO_WRITE_MEM   ;Transfer from the SoftBox to PET memory
$0532: 4C 5B 05  JMP DO_READ_MEM    ;Transfer from PET memory to the SoftBox

:DO_GET_KEY
;Wait for a key and send it to the SoftBox.
$0535: 4C C6 05  JMP L_05C6

:DO_TERMINAL
;Write to the terminal screen
$0538: 20 CF 05  JSR IEEE_GET_BYTE
$053B: A2 3C     LDX #$3C
$053D: 8E 21 E8  STX PIA2NDAC       ;PIA#2 IEEE NDAC control
$0540: 20 E8 06  JSR PROCESS_BYTE
$0543: 4C E7 04  JMP MAIN_LOOP

:DO_JUMP
;Jump to an address
$0546: 20 CF 05  JSR IEEE_GET_BYTE  ;Get byte
$0549: 85 0D     STA TARGET_LO      ; -> Command vector lo
$054B: 20 CF 05  JSR IEEE_GET_BYTE  ;Get byte
$054E: 85 0E     STA TARGET_HI      ; -> Command vector hi
$0550: A2 3C     LDX #$3C
$0552: 8E 21 E8  STX PIA2NDAC       ;PIA#2 IEEE NDAC control
$0555: 20 1B 07  JSR JUMP_CMD       ;Jump to the command through CMDVECL
$0558: 4C E7 04  JMP MAIN_LOOP

:DO_READ_MEM
;Transfer bytes from PET memory to the SoftBox
$055B: 20 CF 05  JSR IEEE_GET_BYTE
$055E: 85 11     STA XFER_LO
$0560: 20 CF 05  JSR IEEE_GET_BYTE
$0563: 85 12     STA XFER_HI
$0565: 20 CF 05  JSR IEEE_GET_BYTE
$0568: 85 0D     STA TARGET_LO
$056A: 20 CF 05  JSR IEEE_GET_BYTE
$056D: 85 0E     STA TARGET_HI
$056F: A0 00     LDY #$00
:L_0571
$0571: 20 CF 05  JSR IEEE_GET_BYTE
$0574: 91 0D     STA (TARGET_LO),Y
$0576: C8        INY
$0577: D0 02     BNE L_057B
$0579: E6 0E     INC TARGET_HI
:L_057B
$057B: A5 11     LDA XFER_LO
$057D: 38        SEC
$057E: E9 01     SBC #$01
$0580: 85 11     STA XFER_LO
$0582: A5 12     LDA XFER_HI
$0584: E9 00     SBC #$00
$0586: 85 12     STA XFER_HI
$0588: 05 11     ORA XFER_LO
$058A: D0 E5     BNE L_0571
$058C: 4C E7 04  JMP MAIN_LOOP

:DO_WRITE_MEM
;Transfer from the SoftBox to PET memory
$058F: 20 CF 05  JSR IEEE_GET_BYTE
$0592: 85 11     STA XFER_LO
$0594: 20 CF 05  JSR IEEE_GET_BYTE
$0597: 85 12     STA XFER_HI
$0599: 20 CF 05  JSR IEEE_GET_BYTE
$059C: 85 0D     STA TARGET_LO
$059E: 20 CF 05  JSR IEEE_GET_BYTE
$05A1: 85 0E     STA TARGET_HI
$05A3: A0 00     LDY #$00
:L_05A5
$05A5: 88        DEY
$05A6: D0 FD     BNE L_05A5   ; delay
:L_05A8
$05A8: B1 0D     LDA (TARGET_LO),Y
$05AA: 20 FB 05  JSR IEEE_SEND_BYTE
$05AD: C8        INY
$05AE: D0 02     BNE L_05B2
$05B0: E6 0E     INC TARGET_HI
:L_05B2
$05B2: A5 11     LDA XFER_LO
$05B4: 38        SEC
$05B5: E9 01     SBC #$01
$05B7: 85 11     STA XFER_LO
$05B9: A5 12     LDA XFER_HI
$05BB: E9 00     SBC #$00
$05BD: 85 12     STA XFER_HI
$05BF: 05 11     ORA XFER_LO
$05C1: D0 E5     BNE L_05A8
$05C3: 4C E7 04  JMP MAIN_LOOP

:L_05C6
;Wait for a key and send it to the SoftBox.
$05C6: 20 2E 06  JSR GET_KEY         ;Block until we get a key.  Key will be in A.
$05C9: 20 FB 05  JSR IEEE_SEND_BYTE  ;Send the key to the Softbox.
$05CC: 4C E7 04  JMP MAIN_LOOP

:IEEE_GET_BYTE
;
;TODO: It looks like this routine reads a byte from IEEE.  Needs disassembly.
;
$05CF: AD 40 E8  LDA VIAPB ;VIA PortB
$05D2: 09 02     ORA #$02
$05D4: 8D 40 E8  STA VIAPB ;VIA PortB
:L_05D7
$05D7: 2C 40 E8  BIT VIAPB ;VIA PortB
$05DA: 30 FB     BMI L_05D7
$05DC: AD 20 E8  LDA PIA2IEEE ;PIA#2 IEEE Input
$05DF: 49 FF     EOR #$FF
$05E1: 48        PHA
$05E2: AD 40 E8  LDA VIAPB ;VIA PortB
$05E5: 29 FD     AND #$FD
$05E7: 8D 40 E8  STA VIAPB ;VIA PortB
$05EA: A9 3C     LDA #$3C
$05EC: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
:L_05EF
$05EF: 2C 40 E8  BIT VIAPB ;VIA PortB
$05F2: 10 FB     BPL L_05EF
$05F4: A9 34     LDA #$34
$05F6: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
$05F9: 68        PLA
$05FA: 60        RTS

:IEEE_SEND_BYTE
;
;TODO: It looks like this routine writes a byte to IEEE.  Needs disassembly.
;
$05FB: 49 FF     EOR #$FF
$05FD: 8D 22 E8  STA PIA2IOUT ;PIA#2 IEEE Output
$0600: AD 40 E8  LDA VIAPB ;VIA PortB
$0603: 09 02     ORA #$02
$0605: 8D 40 E8  STA VIAPB ;VIA PortB
$0608: A9 3C     LDA #$3C
$060A: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
:L_060D
$060D: 2C 40 E8  BIT VIAPB ;VIA PortB
$0610: 50 FB     BVC L_060D
$0612: A9 34     LDA #$34
$0614: 8D 23 E8  STA PIA2DAV ;PIA#2 IEEE DAV control
:L_0617
$0617: AD 40 E8  LDA VIAPB ;VIA PortB
$061A: 4A        LSR A
$061B: 90 FA     BCC L_0617
$061D: A9 3C     LDA #$3C
$061F: 8D 23 E8  STA PIA2DAV ;PIA#2 IEEE DAV control
$0622: A9 FF     LDA #$FF
$0624: 8D 22 E8  STA PIA2IOUT ;PIA#2 IEEE Output
:L_0627
$0627: AD 40 E8  LDA VIAPB ;VIA PortB
$062A: 4A        LSR A
$062B: B0 FA     BCS L_0627
$062D: 60        RTS

:GET_KEY
;Get the next key waiting from the keyboard buffer and return
;it in the accumulator.  If there is no key, this routine will
;block until it gets one.  Meanwhile, the interrupt handler
;calls SCAN_KEYB and puts any key into the buffer.
;
$062E: A9 FF     LDA #$FF        ;FF = no key
$0630: 78        SEI             ;Disable interrupts
$0631: A6 08     LDX KEYCOUNT    ;Is there a key waiting in the buffer?
$0633: F0 14     BEQ L_0649      ;  No: nothing to do with the buffer.
$0635: AD 6F 02  LDA KEYBUF      ;Read the next key in the buffer (FIFO)
$0638: 48        PHA             ;Push the key onto the stack
$0639: A2 00     LDX #$00
$063B: C6 08     DEC KEYCOUNT    ;Keycount = Keycount - 1
:L_063D
$063D: BD 70 02  LDA KEYBUF+1,X  ;Remove the key from the buffer by rotating
$0640: 9D 6F 02  STA KEYBUF,X    ;  bytes in the buffer to the left
$0643: E8        INX
$0644: E4 08     CPX KEYCOUNT    ;Finished updating the buffer?
$0646: D0 F5     BNE L_063D      ;  No: loop until we're done.
$0648: 68        PLA             ;Pull the key off the stack.
:L_0649
$0649: 58        CLI             ;Enable interrupts again
$064A: C9 FF     CMP #$FF        ;No key or key is "NONE" in the tables?
$064C: F0 E0     BEQ GET_KEY     ;  No key:  loop until we get one.
$064E: 60        RTS             ;  Got key: done.  Key is now in A.

;START OF INTERRUPT HANDLER
:INT_HANDLER
$064F: E6 1A     INC $1A       ;counter
$0651: D0 06     BNE L_0659
$0653: E6 19     INC $19       ;counter
$0655: D0 02     BNE L_0659
$0657: E6 18     INC $18       ;counter
:L_0659
$0659: E6 14     INC $14
$065B: A5 14     LDA $14
$065D: CD 03 04  CMP $0403     ;?? this is in the BASIC header area
$0660: D0 28     BNE BLINK_CURSOR
$0662: A9 00     LDA #$00
$0664: 85 14     STA $14
$0666: E6 15     INC $15
$0668: A5 15     LDA $15
$066A: C9 3C     CMP #$3C      ;60
$066C: D0 1C     BNE BLINK_CURSOR
$066E: A9 00     LDA #$00
$0670: 85 15     STA $15
$0672: E6 16     INC $16
$0674: A5 16     LDA $16
$0676: C9 3C     CMP #$3C      ;60
$0678: D0 10     BNE BLINK_CURSOR
$067A: A9 00     LDA #$00
$067C: 85 16     STA $16
$067E: E6 17     INC $17
$0680: A5 17     LDA $17
$0682: C9 18     CMP #$18      ;24
$0684: D0 04     BNE BLINK_CURSOR
$0686: A9 00     LDA #$00
$0688: 85 17     STA $17
:BLINK_CURSOR
$068A: A5 06     LDA CURSOR_OFF    ;Is the cursor off?
$068C: D0 11     BNE L_069F        ;  Yes: skip cursor blink
$068E: C6 01     DEC BLINK_CNT     ;Decrement cursor blink countdown
$0690: D0 0D     BNE L_069F        ;Not time to blink? Done.
$0692: A9 14     LDA #$14
$0694: 85 01     STA BLINK_CNT     ;Reset cursor blink countdown
$0696: 20 88 09  JSR CALC_SCNPOS
$0699: B1 02     LDA (SCNPOSL),Y   ;Read character at cursor
$069B: 49 80     EOR #$80          ;Flip the REVERSE bit
$069D: 91 02     STA (SCNPOSL),Y   ;Write it back
:L_069F
$069F: AD 37 0B  LDA UNKNOWN_1
$06A2: CD 3E 0B  CMP UNKNOWN_8
$06A5: F0 0A     BEQ L_06B1
$06A7: 8D 3E 0B  STA UNKNOWN_8
$06AA: A9 10     LDA #$10
$06AC: 8D 3C 0B  STA UNKNOWN_6
$06AF: D0 21     BNE L_06D2
:L_06B1
$06B1: C9 FF     CMP #$FF
$06B3: F0 1D     BEQ L_06D2
$06B5: AD 3C 0B  LDA UNKNOWN_6
$06B8: F0 05     BEQ L_06BF
$06BA: CE 3C 0B  DEC UNKNOWN_6
$06BD: D0 13     BNE L_06D2
:L_06BF
$06BF: CE 3D 0B  DEC UNKNOWN_7
$06C2: D0 0E     BNE L_06D2
$06C4: A9 04     LDA #$04
$06C6: 8D 3D 0B  STA UNKNOWN_7
$06C9: A9 00     LDA #$00
$06CB: 8D 37 0B  STA UNKNOWN_1
$06CE: A9 02     LDA #$02
$06D0: 85 01     STA BLINK_CNT ;Fast cursor blink(?)
:L_06D2
$06D2: 20 D4 09  JSR SCAN_KEYB ;Scan the keyboard
$06D5: F0 0B     BEQ L_06E2    ;Nothing to do if no key was pressed.
$06D7: A6 08     LDX KEYCOUNT
$06D9: E0 50     CPX #$50      ;Is the keyboard buffer full?
$06DB: F0 05     BEQ L_06E2    ;  Yes:  Nothing we can do.  Forget the key.
$06DD: 9D 6F 02  STA KEYBUF,X  ;  No:   Store the key in the buffer
$06E0: E6 08     INC KEYCOUNT  ;        and increment the keycount.
:L_06E2
$06E2: 68        PLA
$06E3: A8        TAY
$06E4: 68        PLA
$06E5: AA        TAX
$06E6: 68        PLA
$06E7: 40        RTI

:PROCESS_BYTE
;This is the core of the terminal emulator.  It accepts a byte in
;the accumulator, determines if it is a control code or character
;to display, and then jumps accordingly.  After the jump, all
;code paths will end up at PROCESS_DONE.
;
$06E8: 48        PHA
$06E9: A5 06     LDA CURSOR_OFF    ;Get the current cursor state
$06EB: 85 0C     STA CURSOR_TMP    ;  Remember it
$06ED: A9 FF     LDA #$FF
$06EF: 85 06     STA CURSOR_OFF    ;Hide the cursor
$06F1: 20 88 09  JSR CALC_SCNPOS   ;Calculate screen RAM pointer
$06F4: A5 07     LDA SCNCODE_TMP   ;Get the screen code previously saved
$06F6: 91 02     STA (SCNPOSL),Y   ;  Put it on the screen
$06F8: 68        PLA
$06F9: 25 13     AND $13
$06FB: A6 0B     LDX MOVETO_CNT    ;More bytes to consume for a move-to seq?
$06FD: D0 16     BNE L_0715        ;  Yes: branch to jump to move-to handler
$06FF: C9 20     CMP #$20          ;Is this byte a control code?
$0701: B0 15     BCS L_0718        ;  No: branch to put char on screen
$0703: 0A        ASL A
$0704: AA        TAX
$0705: BD 1E 07  LDA CTRL_CODES,X  ;Load vector from control code table
$0708: 85 0D     STA TARGET_LO
$070A: BD 1F 07  LDA CTRL_CODES+1,X
$070D: 85 0E     STA TARGET_HI
$070F: 20 1B 07  JSR JUMP_CMD      ;Jump to vector to handle control code
$0712: 4C 8D 07  JMP PROCESS_DONE
:L_0715
$0715: 4C B8 09  JMP MOVE_TO       ;Jump to handle move-to sequence
:L_0718
$0718: 4C 99 07  JMP PUT_CHAR      ;Jump to put character on the screen
:JUMP_CMD
$071B: 6C 0D 00  JMP (TARGET_LO)   ;Jump to handle the control ocde

;Terminal control code dispatch table
:CTRL_CODES
$071E:           .WORD CTRL_00  ;Do nothing
$0720:           .WORD CTRL_01  ;Store #$FF in $13
$0722:           .WORD CTRL_02  ;Store #$7F in $13
$0724:           .WORD CTRL_03  ;Do nothing
$0726:           .WORD CTRL_04  ;Set TAB STOP at current position
$0728:           .WORD CTRL_05  ;Clear TAB STOP at current position
$072A:           .WORD CTRL_06  ;Clear all TAB STOPS
$072C:           .WORD CTRL_07  ;Ring bell
$072E:           .WORD CTRL_08  ;Cursor left
$0730:           .WORD CTRL_09  ;Perform TAB
$0732:           .WORD CTRL_0A  ;Line feed
$0734:           .WORD CTRL_0B  ;Cursor up
$0736:           .WORD CTRL_0C  ;Cursor right
$0738:           .WORD CTRL_0D  ;Carriage return
$073A:           .WORD CTRL_0E  ;Reverse video on
$073C:           .WORD CTRL_0F  ;Reverse video off
$073E:           .WORD CTRL_10  ;Cursor off
$0740:           .WORD CTRL_11  ;Insert a blank line
$0742:           .WORD CTRL_12  ;Scroll up one line
$0744:           .WORD CTRL_13  ;Clear to end of line
$0746:           .WORD CTRL_14  ;Clear to end of screen
$0748:           .WORD CTRL_15  ;Set IEEE-488 /NDAC = 0
$074A:           .WORD CTRL_16  ;Set IEEE-488 /NDAC = 1
$074C:           .WORD CTRL_17  ;Go to uppercase mode
$074E:           .WORD CTRL_18  ;Go to lowercase mode
$0750:           .WORD CTRL_19  ;Cursor on
$0752:           .WORD CTRL_1A  ;Clear screen
$0754:           .WORD CTRL_1B  ;Move cursor to X,Y position
$0756:           .WORD CTRL_1C  ;Insert a space on current line
$0758:           .WORD CTRL_1D  ;Delete character at cursor
$075A:           .WORD CTRL_1E  ;Home cursor
$075C:           .WORD CTRL_1F  ;Do nothing

;START OF CONTROL CODE 07
;Ring bell
:CTRL_07
$075E: A9 07     LDA #$07   ;CHR$(7) = Bell
$0760: 4C D2 FF  JMP CHROUT ;Kernal Print a byte

;START OF CONTROL CODE 18
;Go to lowercase mode
:CTRL_18
$0763: AD 4C E8  LDA VIA_PCR
$0766: 48        PHA
$0767: A9 0E     LDA #$0E     ;CHR$(14) = Switch to lowercase mode
$0769: 20 D2 FF  JSR CHROUT   ;Kernal Print a byte
$076C: 68        PLA
$076D: 8D 4C E8  STA VIA_PCR
$0770: 60        RTS

;START OF CONTROL CODE 17
;Go to uppercase mode
:CTRL_17
$0771: AD 4C E8  LDA VIA_PCR
$0774: 48        PHA
$0775: A9 8E     LDA #$8E     ;CHR$(142) = Switch to uppercase mode
$0777: 20 D2 FF  JSR CHROUT   ;Kernal Print a byte
$077A: 68        PLA
$077B: 8D 4C E8  STA VIA_PCR
$077E: 60        RTS

;START OF CONTROL CODE 01
:CTRL_01
$077F: A9 FF     LDA #$FF
$0781: 85 13     STA $13
$0783: 60        RTS

;START OF CONTROL CODE 02
:CTRL_02
$0784: A9 7F     LDA #$7F
$0786: 85 13     STA $13
$0788: 60        RTS

;START OF CONTROL CODES 00, 03, 1F
;Do nothing
:CTRL_00
:CTRL_03
:CTRL_1F
$0789: 60        RTS

:PUTSCN_THEN_DONE
;Put the screen code in the accumulator on the screen
;and then fall through to PROCESS_DONE.
;
$078A: 20 F4 07  JSR PUT_SCNCODE

:PROCESS_DONE
;This routine always returns to DO_TERMINAL except during init.
;
$078D: 20 88 09  JSR CALC_SCNPOS   ;Calculate screen RAM pointer
$0790: B1 02     LDA (SCNPOSL),Y   ;Get the current character on the screen
$0792: 85 07     STA SCNCODE_TMP   ;  Remember it
$0794: A5 0C     LDA CURSOR_TMP    ;Get the previous state of the cursor
$0796: 85 06     STA CURSOR_OFF    ;  Restore it
$0798: 60        RTS

:PUT_CHAR
;Puts an ASCII (not PETSCII) character in the accumulator on the screen
;at the current CURSOR_X and CURSOR_Y position.  This routine first
;converts the character to its equivalent CBM screen code and then
;jumps out to print it to the screen.
;
$0799: C9 40     CMP #$40
$079B: 90 ED     BCC PUTSCN_THEN_DONE
$079D: C9 60     CMP #$60
$079F: B0 05     BCS L_07A6
$07A1: 29 3F     AND #$3F
$07A3: 4C AC 07  JMP L_07AC
:L_07A6
$07A6: C9 80     CMP #$80
$07A8: B0 20     BCS L_07CA
$07AA: 29 5F     AND #$5F
:L_07AC
$07AC: AA        TAX
$07AD: 29 3F     AND #$3F
$07AF: F0 15     BEQ L_07C6
$07B1: C9 1B     CMP #$1B
$07B3: B0 11     BCS L_07C6
$07B5: 8A        TXA
$07B6: 49 40     EOR #$40
$07B8: AA        TAX
$07B9: AD 4C E8  LDA VIA_PCR
$07BC: 4A        LSR A
$07BD: 4A        LSR A
$07BE: B0 06     BCS L_07C6
$07C0: 8A        TXA
$07C1: 29 1F     AND #$1F
$07C3: 4C 8A 07  JMP PUTSCN_THEN_DONE
:L_07C6
$07C6: 8A        TXA
$07C7: 4C 8A 07  JMP PUTSCN_THEN_DONE
:L_07CA
$07CA: 29 7F     AND #$7F
$07CC: 09 40     ORA #$40
$07CE: 4C 8A 07  JMP PUTSCN_THEN_DONE

;START OF CONTROL CODE 15
;Set IEEE-488 /NDAC = 0
:CTRL_15
$07D1: A9 0C     LDA #$0C
$07D3: 8D 4C E8  STA VIA_PCR  ;CA2 = Low Output (IEEE-488 /NDAC = 0)
$07D6: 60        RTS

;START OF CONTROL CODE 16
;Set IEEE-488 /NDAC = 1
:CTRL_16
$07D7: A9 0E     LDA #$0E
$07D9: 8D 4C E8  STA VIA_PCR  ;CA2 = High Output (IEEE-488 /NDAC = 1)
$07DC: 60        RTS

;START OF CONTROL CODE 08
;Cursor left
:CTRL_08
$07DD: A6 04     LDX CURSOR_X
$07DF: D0 08     BNE L_07E9     ; X > 0? Y will not change.
$07E1: A6 09     LDX X_WIDTH    ; X = max X + 1
$07E3: A5 05     LDA CURSOR_Y
$07E5: F0 05     BEQ L_07EC     ; Y=0? Can't move up.
$07E7: C6 05     DEC CURSOR_Y   ; Y=Y-1
:L_07E9
$07E9: CA        DEX
$07EA: 86 04     STX CURSOR_X   ; X=X-1
:L_07EC
$07EC: 60        RTS

;START OF CONTROL CODE 0B
;Cursor up
:CTRL_0B
$07ED: A4 05     LDY CURSOR_Y
$07EF: F0 FB     BEQ L_07EC     ; Y=0? Can't move up.
$07F1: C6 05     DEC CURSOR_Y   ; Y=Y-1
$07F3: 60        RTS

:PUT_SCNCODE
;Put the screen code in A on the screen at the current cursor position
$07F4: A6 0A     LDX REVERSE      ;Is reverse video mode on?
$07F6: F0 02     BEQ L_07FA       ;  No:  leave character alone
$07F8: 49 80     EOR #$80         ;  Yes: Flip bit 7 to reverse the character
:L_07FA
$07FA: 20 88 09  JSR CALC_SCNPOS  ;Calculate screen RAM pointer
$07FD: 91 02     STA (SCNPOSL),Y  ;Write the character to the screen
                                  ;Fall through into CTRL_0C to advance cursor

;START OF CONTROL CODE 0C
;Cursor right
:CTRL_0C
$07FF: E6 04     INC CURSOR_X   ;X=X+1
$0801: A6 04     LDX CURSOR_X
$0803: E4 09     CPX X_WIDTH    ;X > max X?
$0805: D0 10     BNE L_0817     ;  No:  Done, no need to scroll up.
$0807: A9 00     LDA #$00       ;  Yes: Set X=0 and then
$0809: 85 04     STA CURSOR_X   ;       fall through into CTRL_0A to scroll.

;START OF CONTROL CODE 0A
;Line feed
:CTRL_0A
$080B: A4 05     LDY CURSOR_Y
$080D: C0 18     CPY #$18       ;Are we on line 24?
$080F: D0 03     BNE L_0814     ;  No:  Done, scroll is not needed
$0811: 4C 8E 08  JMP SCROLL_UP  ;  Yes: Scroll the screen up first
:L_0814
$0814: E6 05     INC CURSOR_Y   ;Increment Y position
$0816: 60        RTS
:L_0817
$0817: 60        RTS

;START OF CONTROL CODE 1E
;Home cursor
:CTRL_1E
$0818: A9 00     LDA #$00       ;Home cursor
$081A: 85 05     STA CURSOR_Y
$081C: 85 04     STA CURSOR_X
$081E: 60        RTS

;START OF CONTROL CODE 1A
;Clear screen
:CTRL_1A
$081F: A2 00     LDX #$00      ; Home cursor
$0821: 86 04     STX CURSOR_X
$0823: 86 05     STX CURSOR_Y
$0825: 86 0A     STX REVERSE   ;Reverse video off
$0827: A9 20     LDA #$20      ;Space character
:L_0829
$0829: 9D 00 80  STA SCREEN,X
$082C: 9D 00 81  STA SCREEN+$100,X
$082F: 9D 00 82  STA SCREEN+$200,X
$0832: 9D 00 83  STA SCREEN+$300,X
$0835: 9D 00 84  STA SCREEN+$400,X
$0838: 9D 00 85  STA SCREEN+$500,X
$083B: 9D 00 86  STA SCREEN+$600,X
$083E: 9D 00 87  STA SCREEN+$700,X
$0841: E8        INX
$0842: D0 E5     BNE L_0829
$0844: 60        RTS

;START OF CONTROL CODE 0D
;Carriage return
:CTRL_0D
$0845: A9 00     LDA #$00       ;Move to X=0 on this line
$0847: 85 04     STA CURSOR_X
$0849: 60        RTS

;START OF CONTROL CODE 10
;Cursor on
:CTRL_10
$084A: A9 00     LDA #$00
$084C: 85 0C     STA CURSOR_TMP
$084E: 60        RTS

;START OF CONTROL CODE 19
;Cursor off
:CTRL_19
$084F: A9 FF     LDA #$FF
$0851: 85 0C     STA CURSOR_TMP
$0853: 60        RTS

;START OF CONTROL CODE 0E
;Reverse video on
:CTRL_0E
$0854: A9 01     LDA #$01
$0856: 85 0A     STA REVERSE
$0858: 60        RTS

;START OF CONTROL CODE 0F
;Reverse video off
:CTRL_0F
$0859: A9 00     LDA #$00
$085B: 85 0A     STA REVERSE
$085D: 60        RTS

;START OF CONTROL CODE 13
;Clear to end of line
:CTRL_13
:L_085E
$085E: 20 88 09  JSR CALC_SCNPOS    ;Leaves CURSOR_X in Y register
$0861: A9 20     LDA #$20           ;Space character
:L_0863
$0863: 91 02     STA (SCNPOSL),Y    ;Write space to screen RAM
$0865: C8        INY                ;X=X+1
$0866: C4 09     CPY X_WIDTH
$0868: D0 F9     BNE L_0863         ;Loop until end of line
$086A: 60        RTS

;START OF CONTROL CODE 14
:CTRL_14
;Clear from Current line to end of screen
;
$086B: 20 5E 08  JSR L_085E
$086E: A6 05     LDX CURSOR_Y    ;Get the Current line#
:L_0870
$0870: E8        INX             ;Next Row
$0871: E0 19     CPX #$19        ;Is it 25 (last line of screen?
$0873: F0 18     BEQ L_088D      ;  Yes, we're done
$0875: 18        CLC             ;  No, continue
$0876: A5 02     LDA SCNPOSL     ;Current screen position
$0878: 65 09     ADC X_WIDTH     ;Add the line width
$087A: 85 02     STA SCNPOSL     ;Save it
$087C: 90 02     BCC L_0880      ;Need to update HI?
$087E: E6 03     INC SCNPOSH     ;  Yes, increment HI pointer
:L_0880
$0880: A9 20     LDA #$20        ;SPACE
$0882: A0 00     LDY #$00        ;Position 0
:L_0884
$0884: 91 02     STA (SCNPOSL),Y ;Write a space
$0886: C8        INY             ;Next character
$0887: C4 09     CPY X_WIDTH     ;Is it end of line?
$0889: D0 F9     BNE L_0884      ;No, loop back for more on this line
$088B: F0 E3     BEQ L_0870      ;Yes, loop back for next line
:L_088D
$088D: 60        RTS

;Scroll the screen up one line
:SCROLL_UP
$088E: A9 00     LDA #$00
$0890: 85 02     STA SCNPOSL
$0892: A5 09     LDA X_WIDTH
$0894: 85 0D     STA TARGET_LO
$0896: A9 80     LDA #$80
$0898: 85 03     STA SCNPOSH
$089A: 85 0E     STA TARGET_HI
$089C: A2 18     LDX #$18
:L_089E
$089E: A0 00     LDY #$00
:L_08A0
$08A0: B1 0D     LDA (TARGET_LO),Y
$08A2: 91 02     STA (SCNPOSL),Y
$08A4: C8        INY
$08A5: C4 09     CPY X_WIDTH
$08A7: D0 F7     BNE L_08A0
$08A9: A5 0D     LDA TARGET_LO
$08AB: 85 02     STA SCNPOSL
$08AD: 18        CLC
$08AE: 65 09     ADC X_WIDTH
$08B0: 85 0D     STA TARGET_LO
$08B2: A5 0E     LDA TARGET_HI
$08B4: 85 03     STA SCNPOSH
$08B6: 69 00     ADC #$00
$08B8: 85 0E     STA TARGET_HI
$08BA: CA        DEX
$08BB: D0 E1     BNE L_089E
$08BD: A0 00     LDY #$00
$08BF: A9 20     LDA #$20          ;SPACE
:L_08C1
$08C1: 91 02     STA (SCNPOSL),Y
$08C3: C8        INY
$08C4: C4 09     CPY X_WIDTH
$08C6: D0 F9     BNE L_08C1
$08C8: 60        RTS

;START OF CONTROL CODE 04
; Set TAB STOP at current Position
:CTRL_04
$08C9: A9 01     LDA #$01         ;1=TAB STOP yes
$08CB:           .BYT 2C          ;Falls through to become BIT $00A9

;START OF CONTROL CODE 05
; Clear TAB STOP at current position
:CTRL_05
$08CC: A9 00     LDA #$00         ;0=No TAB STOP
$08CE: A6 04     LDX CURSOR_X     ;Get cursor position
$08D0: 9D 3F 0B  STA TAB_STOPS,X  ;Clear the TAB at that position
$08D3: 60        RTS

;START OF CONTROL CODE 06
; Clear ALL TAB STOPS
:CTRL_06
$08D4: A2 4F     LDX #$4F  ; 80 characters-1
$08D6: A9 00     LDA #$00  ; zero
:L_08D8
$08D8: 9D 3F 0B  STA TAB_STOPS,X  ;store in the buffer
$08DB: CA        DEX
$08DC: 10 FA     BPL L_08D8
$08DE: 60        RTS

;START OF CONTROL CODE 09
; perform TAB - Move to next TAB STOP as indicated in the TAB_STOP table
:CTRL_09
$08DF: A6 04     LDX CURSOR_X
:L_08E1
$08E1: E8        INX               ; next position
$08E2: E0 50     CPX #$50          ; 80 characters?
$08E4: B0 07     BCS L_08ED        ; yes, exit
$08E6: BD 3F 0B  LDA TAB_STOPS,X   ; read from the TAB STOPS table
$08E9: F0 F6     BEQ L_08E1        ; is it zero? yes, loop again
$08EB: 86 04     STX CURSOR_X      ; no, we hit a STOP, so store the position
:L_08ED
$08ED: 60        RTS

;START OF CONTROL CODE 1C
;Insert space at current cursor position
:CTRL_1C
$08EE: 20 88 09  JSR CALC_SCNPOS
$08F1: A4 09     LDY X_WIDTH       ;number of characters on line
$08F3: 88        DEY
:L_08F4
$08F4: C4 04     CPY CURSOR_X
$08F6: F0 09     BEQ L_0901
$08F8: 88        DEY
$08F9: B1 02     LDA (SCNPOSL),Y    ;read a character from line
$08FB: C8        INY                ;position to the right
$08FC: 91 02     STA (SCNPOSL),Y    ;write it back
$08FE: 88        DEY                ;we are counting down to zero
$08FF: D0 F3     BNE L_08F4         ;loop for another character
:L_0901
$0901: A9 20     LDA #$20           ; SPACE
$0903: 91 02     STA (SCNPOSL),Y    ; Write it to current character position
$0905: 60        RTS

;START OF CONTROL CODE 1D
;Delete a character
:CTRL_1D
$0906: 20 88 09  JSR CALC_SCNPOS
$0909: A4 04     LDY CURSOR_X
:L_090B
$090B: C8        INY
$090C: C4 09     CPY X_WIDTH
$090E: F0 08     BEQ L_0918
$0910: B1 02     LDA (SCNPOSL),Y    ;read a character from the line
$0912: 88        DEY                ;position to the left
$0913: 91 02     STA (SCNPOSL),Y    ;write it back
$0915: C8        INY                ;we are counting UP
$0916: D0 F3     BNE L_090B         ;loop for another character
:L_0918
$0918: 88        DEY
$0919: A9 20     LDA #$20           ;SPACE
$091B: 91 02     STA (SCNPOSL),Y    ;write it to the current character position
$091D: 60        RTS

;START OF CONTROL CODE 12
:CTRL_12
;Scroll up one line
;
;The screen is shifted upward so that each line Y+1 is copied into Y.  Screen
;contents are preserved except for the bottommost line, which is erased
;(filled with spaces).  The current cursor position will not be changed.
;
$091E: A9 00     LDA #$00
$0920: 85 04     STA CURSOR_X
$0922: 20 88 09  JSR CALC_SCNPOS
$0925: A5 02     LDA $02
$0927: 18        CLC
$0928: 65 09     ADC X_WIDTH
$092A: 85 0D     STA TARGET_LO
$092C: A5 03     LDA SCNPOSH
$092E: 69 00     ADC #$00
$0930: 85 0E     STA TARGET_HI
$0932: A9 18     LDA #$18
$0934: 38        SEC
$0935: E5 05     SBC CURSOR_Y
$0937: AA        TAX
$0938: 4C 9E 08  JMP L_089E        ;Jump into SCROLL_UP, bypassing some init

;START OF CONTROL CODE 11
;Insert a blank line
;
;The screen is shifted downward so that each line Y is copied into Y+1.
;The line at the current position will be erased (filled with spaces).
;The current cursor position will not be changed.
;
:CTRL_11
$093B: A9 C0     LDA #$C0
$093D: A0 83     LDY #$83
$093F: A6 09     LDX X_WIDTH
$0941: E0 50     CPX #$50
$0943: D0 04     BNE L_0949
$0945: A9 80     LDA #$80
$0947: A0 87     LDY #$87
:L_0949
$0949: 85 0D     STA TARGET_LO
$094B: 84 0E     STY TARGET_HI
$094D: A9 00     LDA #$00
$094F: 85 04     STA CURSOR_X
:L_0951
$0951: A5 0D     LDA TARGET_LO
$0953: C5 02     CMP SCNPOSL
$0955: D0 06     BNE L_095D
$0957: A5 0E     LDA TARGET_HI
$0959: C5 03     CMP SCNPOSH
$095B: F0 1F     BEQ L_097C
:L_095D
$095D: A5 0D     LDA TARGET_LO
$095F: 85 0F     STA INSERT_LO
$0961: 38        SEC
$0962: E5 09     SBC X_WIDTH
$0964: 85 0D     STA TARGET_LO
$0966: A5 0E     LDA TARGET_HI
$0968: 85 10     STA INSERT_HI
$096A: E9 00     SBC #$00
$096C: 85 0E     STA TARGET_HI
$096E: A0 00     LDY #$00
:L_0970
$0970: B1 0D     LDA (TARGET_LO),Y
$0972: 91 0F     STA (INSERT_LO),Y
$0974: C8        INY
$0975: C4 09     CPY X_WIDTH
$0977: D0 F7     BNE L_0970
$0979: 4C 51 09  JMP L_0951
:L_097C
$097C: A0 00     LDY #$00
$097E: A9 20     LDA #$20          ;SPACE
:L_0980
$0980: 91 02     STA (SCNPOSL),Y
$0982: C8        INY
$0983: C4 09     CPY X_WIDTH
$0985: D0 F9     BNE L_0980
$0987: 60        RTS

:CALC_SCNPOS
;Calculate a new pointer to screen memory (SCNPOSL/SCNPOSH)
;from cursor position at CURSOR_X and CURSOR_Y
$0988: 48        PHA
$0989: A9 00     LDA #$00
$098B: 85 03     STA SCNPOSH
$098D: A5 05     LDA CURSOR_Y
$098F: 85 02     STA SCNPOSL
$0991: 0A        ASL A
$0992: 0A        ASL A
$0993: 65 02     ADC SCNPOSL
$0995: 0A        ASL A
$0996: 0A        ASL A
$0997: 26 03     ROL SCNPOSH
$0999: 0A        ASL A
$099A: 26 03     ROL SCNPOSH
$099C: 85 02     STA SCNPOSL
$099E: A5 09     LDA X_WIDTH
$09A0: C9 50     CMP #$50
$09A2: D0 04     BNE L_09A8
$09A4: 06 02     ASL SCNPOSL
$09A6: 26 03     ROL SCNPOSH
:L_09A8
$09A8: 18        CLC
$09A9: A4 04     LDY CURSOR_X
$09AB: A5 03     LDA SCNPOSH
$09AD: 69 80     ADC #$80
$09AF: 85 03     STA SCNPOSH
$09B1: 68        PLA
$09B2: 60        RTS

;START OF CONTROL CODE 1B
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
:CTRL_1B
$09B3: A9 02     LDA #$02          ;Two more bytes to consume (X-pos, Y-pos)
$09B5: 85 0B     STA MOVETO_CNT    ;Store count for next pass of PROCESS_BYTE
$09B7: 60        RTS

:MOVE_TO
;Implements CTRL_1B by handling the X-position byte on the first call
;and the Y-position byte on the second call.  After the Y-position byte
;has been consumed, MOVETO_CNT = 0, exiting the move-to sequence.
;
$09B8: C6 0B     DEC MOVETO_CNT    ;Decrement bytes remaining to consume
$09BA: F0 0C     BEQ L_09C8        ;Already got X pos?  Handle this byte as Y.
$09BC: 38        SEC
$09BD: E9 20     SBC #$20          ;X-pos = X-pos - #$20
$09BF: C5 09     CMP X_WIDTH       ;Requested X position out of range?
$09C1: B0 02     BCS L_09C5        ;  Yes: Do nothing.
$09C3: 85 04     STA CURSOR_X      ;  No:  Move cursor to requested X.
:L_09C5
$09C5: 4C 8D 07  JMP PROCESS_DONE  ;Done.
:L_09C8
$09C8: 38        SEC
$09C9: E9 20     SBC #$20          ;Y-pos = Y-pos - #$20
$09CB: C9 19     CMP #$19          ;Requested Y position out of range?
$09CD: B0 F6     BCS L_09C5        ;  Yes: Do nothing.
$09CF: 85 05     STA CURSOR_Y      ;  No:  Move cursor to requested Y.
$09D1: 4C 8D 07  JMP PROCESS_DONE  ;Done.

:SCAN_KEYB
;Scan the keyboard.
; USES: UNKNOWN_1 - Shift Flag?
;       UNKNOWN_2 -
;       UNKNOWN_3 - Row counter?
;       UNKNOWN_4 -
;       UNKNOWN_5 -
$09D4: AD 37 0B  LDA UNKNOWN_1
$09D7: 8D 38 0B  STA UNKNOWN_2
$09DA: A2 00     LDX #$00               ;Start at ROW 0
$09DC: 8E 3A 0B  STX UNKNOWN_4          ;save it
$09DF: 8E 3B 0B  STX UNKNOWN_5          ;save it
$09E2: 8E 10 E8  STX PIA1ROW            ;Select a keyboard ROW
$09E5: A9 FF     LDA #$FF
$09E7: 8D 37 0B  STA UNKNOWN_1
$09EA: A9 0A     LDA #$0A               ;10 rows in table????
$09EC: 8D 39 0B  STA UNKNOWN_3
:L_09EF
;---- top of loop for keyboard ROWS
$09EF: A0 08     LDY #$08               ;8 bits???
:L_09F1
$09F1: AD 12 E8  LDA PIA1COL            ;PIA#1 Keyboard Columns Read
$09F4: CD 12 E8  CMP PIA1COL            ;PIA#1 Keyboard Columns Read
$09F7: D0 F8     BNE L_09F1             ;wait for stable value on keyboard switches (debounce)
:L_09F9
;---- top of loop to go through each bit returned from scan.
;     each "1" bit represents a key pressed down
$09F9: 4A        LSR A                  ;Shift byte RIGHT leaving CARRY flag set if it is a "1"
$09FA: 48        PHA                    ;Push it to the stack
$09FB: B0 22     BCS L_0A1F             ;was the BIT a "1"? Yes, skip
$09FD: A5 09     LDA X_WIDTH
$09FF: C9 50     CMP #$50               ;Is this an 80 column screen?
$0A01: D0 06     BNE L_0A09             ;
$0A03: BD E7 0A  LDA BUSINESS_KEYS,X    ;  Yes: read from Business keyboard table
$0A06: 4C 0C 0A  JMP L_0A0C
:L_0A09
$0A09: BD 97 0A  LDA GRAPHICS_KEYS,X    ;  No:  read from Graphics keyboard table
:L_0A0C
$0A0C: C9 01     CMP #$01               ;SHIFT KEY?
$0A0E: F0 07     BEQ L_0A17
$0A10: 90 0A     BCC L_0A1C
$0A12: 8D 37 0B  STA UNKNOWN_1          ;SHIFT FLAG?
$0A15: B0 08     BCS L_0A1F
:L_0A17
$0A17: EE 3A 0B  INC UNKNOWN_4
$0A1A: D0 03     BNE L_0A1F
:L_0A1C
$0A1C: EE 3B 0B  INC UNKNOWN_5
:L_0A1F
$0A1F: 68        PLA                    ;pull the original scan value from stack
$0A20: E8        INX                    ;next entry in table
$0A21: 88        DEY                    ;next BIT?
$0A22: D0 D5     BNE L_09F9             ;Is it ZERO? No, go back for more table entries
$0A24: EE 10 E8  INC PIA1ROW            ;PIA#1 Keyboard Row Select
$0A27: CE 39 0B  DEC UNKNOWN_3          ;previous row?
$0A2A: D0 C3     BNE L_09EF             ; Is it Zero? No, loop back up
$0A2C: AD 37 0B  LDA UNKNOWN_1
$0A2F: C9 FF     CMP #$FF
$0A31: F0 22     BEQ L_0A55
$0A33: CD 38 0B  CMP UNKNOWN_2
$0A36: F0 1D     BEQ L_0A55
$0A38: C9 00     CMP #$00
$0A3A: 10 0A     BPL L_0A46
$0A3C: 29 7F     AND #$7F               ;remove the TOP bit (shift flag for character?)
$0A3E: AC 3A 0B  LDY UNKNOWN_4
$0A41: F0 03     BEQ L_0A46
$0A43: 49 10     EOR #$10               ;convert to ASCII?
$0A45: 60        RTS
:L_0A46
$0A46: C9 40     CMP #$40               ;"@"?
$0A48: 90 25     BCC L_0A6F
$0A4A: C9 60     CMP #$60               ;upper ascii limit?
$0A4C: B0 21     BCS L_0A6F
$0A4E: AC 3B 0B  LDY UNKNOWN_5
$0A51: F0 03     BEQ L_0A56
$0A53: 29 1F     AND #$1F               ;CTRL key?
:L_0A55
$0A55: 60        RTS
:L_0A56
$0A56: C9 40     CMP #$40               ;"@"?
$0A58: F0 15     BEQ L_0A6F
$0A5A: C9 5B     CMP #$5B               ;"["?
$0A5C: B0 11     BCS L_0A6F
$0A5E: AC 3A 0B  LDY UNKNOWN_4
$0A61: D0 0C     BNE L_0A6F
$0A63: 48        PHA
$0A64: AD 4C E8  LDA VIA_PCR
$0A67: 4A        LSR A
$0A68: 4A        LSR A
$0A69: 68        PLA
$0A6A: 90 03     BCC L_0A6F
$0A6C: 09 20     ORA #$20
$0A6E: 60        RTS
:L_0A6F
$0A6F: AC 3A 0B  LDY UNKNOWN_4
$0A72: F0 20     BEQ L_0A94
$0A74: A2 0B     LDX #$0B
$0A76: C9 0A     CMP #$0A
$0A78: F0 18     BEQ L_0A92
$0A7A: A2 08     LDX #$08
$0A7C: C9 0C     CMP #$0C
$0A7E: F0 12     BEQ L_0A92
$0A80: A2 1A     LDX #$1A
$0A82: C9 1E     CMP #$1E
$0A84: F0 0C     BEQ L_0A92
$0A86: 48        PHA
$0A87: AD 4C E8  LDA VIA_PCR
$0A8A: 4A        LSR A
$0A8B: 4A        LSR A
$0A8C: 68        PLA
$0A8D: B0 05     BCS L_0A94
$0A8F: 09 80     ORA #$80
$0A91: 60        RTS
:L_0A92
$0A92: 8A        TXA
$0A93: 60        RTS
:L_0A94
$0A94: C9 00     CMP #$00
$0A96: 60        RTS

;40-column graphics keyboard table               ----- ----- ----- ----- ----- ----- ----- -----    Notes
:GRAPHICS_KEYS
$0A97:           .BYT 21,23,25,26,28,5F,1E,0C  ; !     #     %     &     (     BARRW HOME  RIGHT    BARRW= Back Arrow
$0A9F:           .BYT 22,24,27,5C,29,FF,0A,7F  ; "     $     '     \     )     NONE  CSRDN DEL      NONE = No key
$0AA7:           .BYT 51,45,54,55,4F,5E,37,39  ; Q     E     T     U     O     ^     7     9
$0AAF:           .BYT 57,52,59,49,50,FF,38,2F  ; W     R     Y     I     P     NONE  8     /
$0AB7:           .BYT 41,44,47,4A,4C,FF,34,36  ; A     D     G     J     L     NONE  4     6
$0ABF:           .BYT 53,46,48,4B,3A,FF,35,2A  ; S     F     H     K     :     NONE  5     *
$0AC7:           .BYT 5A,43,42,4D,3B,0D,31,33  ; Z     C     B     M     ;     RETRN 1     3
$0ACF:           .BYT 58,56,4E,2C,3F,FF,32,2B  ; X     V     N     ,     ?     NONE  2     +
$0AD7:           .BYT 01,40,5D,FF,3E,01,30,2D  ; SHIFT @     ]     NONE  >     SHIFT 0     -
$0ADF:           .BYT 00,5B,20,3C,1B,FF,2E,3D  ; RVS   [     SPACE >     STOP  NONE  .     =

;80-column business keyboard table               ----- ----- ----- ----- ----- ----- ----- -----
:BUSINESS_KEYS
$0AE7:           .BYT B2,B5,B8,AD,38,0C,FF,FF  ; ^2    ^5    ^8    -     8     CSRRT NONE  NONE     ^ = Extra Bits Set
$0AEF:           .BYT B1,B4,B7,30,37,5E,FF,39  ; ^1    ^4    ^7    0     7     UARRW NONE  9        UARROW = Up Arrow
$0AF7:           .BYT 1B,53,46,48,5D,4B,BB,35  ; ESC   S     F     H     ]     K     ;     5
$0AFF:           .BYT 41,44,47,4A,0D,4C,40,36  ; A     D     G     J     RTRN  L     @     6
$0B07:           .BYT 09,57,52,59,5C,49,50,7F  ; TAB   W     R     Y     \     I     P     DEL
$0B0F:           .BYT 51,45,54,55,0A,4F,5B,34  ; Q     E     T     U     CSRDN O     [     4
$0B17:           .BYT 01,43,42,AE,2E,FF,01,33  ; SHIFT C     B     ^.    .     NONE  SHIFT 3
$0B1F:           .BYT 5A,56,4E,AC,30,FF,FF,32  ; Z     V     N     ,     0     NONE  NONE  2
$0B27:           .BYT 00,58,20,4D,1E,FF,AF,31  ; RVS   X     SPACE M     HOME  NONE  ^/    1
$0B2F:           .BYT 5F,B3,B6,B9,FF,BA,FF,FF  ; BARRW ^3    ^6    ^9    STOP  ^:    NONE  NONE

;Storage locations used in keyboard scanning routine SCAN_KEYB
:UNKNOWN_1
$0B37:           .BYT AA
:UNKNOWN_2
$0B38:           .BYT AA
:UNKNOWN_3
$0B39:           .BYT AA
:UNKNOWN_4
$0B3A:           .BYT AA
:UNKNOWN_5
$0B3B:           .BYT AA
:UNKNOWN_6
$0B3C:           .BYT AA
:UNKNOWN_7
$0B3D:           .BYT AA
:UNKNOWN_8
$0B3E:           .BYT AA

;Start of buffer used by control codes 05, 06, and 09
:TAB_STOPS
$0B3F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B47:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B4F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B57:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B5F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B67:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B6F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B77:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B7F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B87:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B8F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B97:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0B9F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BA7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BAF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BB7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BBF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BC7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BCF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BD7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BDF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BE7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BEF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA
$0BF7:           .BYT AA,AA,AA,AA,AA,AA,AA
