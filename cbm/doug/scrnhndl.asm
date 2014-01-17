; scrnhndlr.asm

; PURPOSE:      To apply the screen control codes.
;               Enter with control character in A register.

;include <k.incl>

; EXTERNAL REFERENCES
        xref curadr             ; gets the cursor address
        xref print1             ; gets character under cursor
        xref setcur             ; sets cursor position
        xref print2             ; prints a character to the screen

; EXTERNAL REFERENCES FOR JUMP TABLE
        xref return
        xref hibiton
        xref hibitof
        xref nullchar1
        xref nullchar
        xref nulbuf
        xref bell
        xref crsrl
        xref getbuf
        xref crsrdn
        xref crsrup
        xref crsrrt
        xref crsrl2
        xref rvrson
        xref rvrsoff
        xref crsron
        xref insrtln
        xref dltln
        xref clreol
        xref clreos
        xref lower
        xref upper
        xref graphics
        xref text
        xref crsroff
        xref clear
        xref curposon
        xref insert
        xref delete
        xref home

; EXTERNAL DEFINITIONS
        xdef scrnhndlr          ; entry for screen control codes
        xdef jump_table         ; entry to screen handling jump table

scrnhndlr equ *
        pha             ; save A register
        lda curflg      ; and save the cursor flag
        sta curflgs     ; as well
        lda #$FF        ; now set high bit of curflg to disable
        sta curflg      ; cursor blinking during interrupts
        jsr curadr      ; find the cursor
        lda curchar     ; and poke the current character there in case
        sta (scraddr),y ; it was reversed by the cursor blink routine
        pla             ; retrieve contents of A register

        and mask        ; mask off the high bit (if hibitof  set)

        ldx curposflg   ; test whether this should be a cursor positioning byte
        bne L1          ; if cursor position byte, reset the cursor position

        cmp #$20        ; check whether it is a control character
        bcs L2          ; if not control character (>= $20) then display

        asl             ; control character so mult by 2 since it
        tax             ; references jump address to be indexed by X
        lda table,x     ; get the two address bytes from the jump
        sta T1          ; table and store them in the indirect
        lda table+1,x   ; address locations
        sta T1+1        ; T1 & T1+1
        jsr jump_table  ; go to the appropriate routine
        jmp print1      ; reset the cursor position coordinates and
                        ; update the current character

L1      jmp setcur      ; reset the cursor position

L2      jmp print2      ; display the character

jump_table   jmp (T1)   ; indirect jump

                        ; HEX  Keybd.   Meaning
                        ; ---  ------   ----------------------------
table fdb return        ;  00  CTRL-@   Null
      fdb hibiton       ;  01  CTRL-A   Enable graphics chars (bit 8 set)
      fdb hibitof       ;  02  CTRL-B   Disable bit 8
      fdb return        ;  03  CTRL-C   Reserved for future use
      fdb nullchar1     ;  04  CTRL-D   Set tab position ????
      fdb nullchar      ;  05  CTRL-E   Clear tab position
      fdb nulbuf        ;  06  CTRL-F   Clear all tabs
      fdb bell          ;  07  CTRL-G   Ring the bell
      fdb crsrl         ;  08  CTRL-H   Cursor left
      fdb getbuf        ;  09  CTRL-I   Tab
      fdb crsrdn        ;  0A  CTRL-J   Line feed
      fdb crsrup        ;  0B  CTRL-K   Cursor up
      fdb crsrrt        ;  0C  CTRL-L   Cursor right
      fdb crsrl2        ;  0d  CTRL-M   Carriage return
      fdb rvrson        ;  0E  CTRL-N   Reverse on
      fdb rvrsoff       ;  0F  CTRL-O   Reverse off
      fdb crsron        ;  10  CTRL-P   Cursor on
      fdb insrtln       ;  11  CTRL-Q   Insert line
      fdb dltln         ;  12  CTRL-R   Delete line
      fdb clreol        ;  13  CTRL-S   Erase to end of line
      fdb clreos        ;  14  CTRL-T   Erase to end of screen
      fdb lower         ;  15  CTRL-U   Upper case only mode
      fdb upper         ;  16  CTRL-V   Lower and upper case
      fdb graphics      ;  17  CTRL-W   Graphics mode
      fdb text          ;  18  CTRL-X   Text mode
      fdb crsroff       ;  19  CTRL-Y   Cursor off
      fdb clear         ;  1A  CTRL-Z   Clear screen
      fdb curposon      ;  1B  ESCAPE   Special screen functions
      fdb insert        ;  1C  CTRL-/   Insert character
      fdb delete        ;  1D  CTRL-]   Delete character
      fdb home          ;  1E  CTRL-    Cursor home
      fdb return        ;  1F
