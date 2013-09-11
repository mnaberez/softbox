; z80dasm 1.1.3
; command line: z80dasm --origin 256 --labels --address xfer.com

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point
fcb:           equ  005ch ;BDOS default FCB
dma_buf:       equ  0080h ;Default DMA buffer area (128 bytes) for disk I/O
eoisav:        equ 0ea6ch ;Stores ppi2_pa IEEE-488 ctrl lines after get byte
dos_msg:       equ 0eac0h ;Last error message returned from CBM DOS
ieee_listen:   equ 0f033h ;Send LISTEN to an IEEE-488 device
ieee_unlisten: equ 0f036h ;Send UNLISTEN to all IEEE-488 devices
ieee_talk:     equ 0f039h ;Send TALK to an IEEE-488 device
ieee_untalk:   equ 0f03ch ;Send UNTALK to all IEEE-488 devices
ieee_get_byte: equ 0f03fh ;Read byte from an IEEE-488 device
ieee_put_byte: equ 0f042h ;Send byte to an IEEE-488 device
get_dtype:     equ 0f051h ;Get drive type for a CP/M drive number
get_ddev:      equ 0f054h ;Get device address for a CP/M drive number
ieee_read_err: equ 0f05ah ;Read the error channel of an IEEE-488 device
ieee_open:     equ 0f05dh ;Open a file on an IEEE-488 device
ieee_close:    equ 0f060h ;Close an open file on an IEEE-488 device
ieee_init_drv: equ 0f078h ;Initialize an IEEE-488 disk drive

cwrite:        equ 02h    ;Console Output
cwritestr:     equ 09h    ;Output String
creadstr:      equ 0ah    ;Buffered Console Input
fopen:         equ 0fh    ;Open File
fclose:        equ 10h    ;Close File
fdelete:       equ 13h    ;Delete File
fread:         equ 14h    ;Read Next Record
fwrite:        equ 15h    ;Write Next Record
fmake:         equ 16h    ;Create File

lf:            equ 0ah    ;Line Feed
cr:            equ 0dh    ;Carriage Return
eof:           equ 1ah    ;End of File marker (CTRL-Z)

    org 0100h             ;CP/M TPA

    nop
    nop
    nop
    ld sp,(0006h)

    ld a,(fcb+1)        ;A = first char in filename
    cp ' '              ;Is it a space?
    jp z,exit_bad_file  ;  Yes: exit with missing filename erro

    ld hl,fcb+1         ;HL = first char of filename
    ld b,0bh            ;B = 11 chars in filename (8 chars + 3 chars ext)
check_wild:
    ld a,(hl)           ;A = char in filename
    cp '?'              ;Is it a wildcard?
    jp z,exit_bad_file  ;  Yes: exit with bad filename error
    inc hl              ;Increment HL to point to next char in filename
    djnz check_wild     ;Decrement B, loop until all chars are checked

get_selection:
;Show the menu options and get a selection
;
    call newline        ;Write newline to console out

    ld de,menu          ;DE = address of main menu string
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    call input          ;Get a line of user input
    ld a,(table_0+2)    ;A = first char from input

    ld hl,insert_lf     ;HL = address of insert linefeeds flag
    ld (hl),00h         ;Insert linefeeds flag = off

    cp '1'              ;1 = Copy sequential file to PET DOS
    jp z,seq_to_pet

    cp '2'              ;2 = Copy sequential file from PET DOS
    jp z,seq_from_pet

    cp '3'              ;3 = Copy BASIC program from PET DOS
    jp z,bas_from_pet

    inc (hl)            ;Insert linefeeds flag = on

    cp '4'              ;4 = As 2. but insert line feeds
    jp z,seq_from_pet

    ld de,bad_command   ;DE = address of bad command string
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call
    jr get_selection    ;Try again

seq_from_pet:
;Copy sequential file from PET DOS
;
    ld a,'S'            ;A = 'S' for CBM DOS sequential file
    call sub_0247h

    ld hl,dma_buf
l015ah:
    call cbm_get_byte   ;Read a data byte from the CBM drive
    ld d,a              ;Save the byte in D

    ld a,(eoisav)       ;A = ppi2_pa after get byte (IEEE-488 ctrl lines in)
    and 10h             ;Mask off all except bit 4 (EOI in)
    push af             ;Push EOI state onto the stack

    ld a,(insert_lf)    ;A = insert linefeeds flag
    or a                ;Set flags
    ld a,d              ;Recall data byte
    jr z,l0174h         ;Jump if insert linefeeds = off

    cp cr               ;Is the byte a carriage return?
    jr nz,l0174h        ;  No: jump over skip over LF insertion

    call write_to_file  ;Write CR to file
    ld a,lf             ;A = linefeed
                        ;Fall through to write LF to file

l0174h:
    call write_to_file  ;Write byte to file

    pop af              ;Pop EOI state from the stack
    jr z,l015ah         ;Loop for next byte if EOI=high indicating more data
                        ;  (IEEE-488 line states are inverted)

l017ah:
    ld de,(cbm_device)  ;D = IEEE-488 primary address, E = file number
    call ieee_close     ;Close open file on IEEE-488 device

    ld b,7fh            ;B = number EOF filler bytes to write
l0183h:
    push bc
    ld a,eof            ;A = End of File marker (CTRL-Z)
    call write_to_file  ;Write EOF char to file
    pop bc
    djnz l0183h         ;Decrement B, loop until B=0

    ld de,fcb           ;DE = address of FCB
    ld c,fclose         ;C = Close File
    call bdos           ;BDOS system call

    ld de,complete      ;DE = address of "Transfer complete"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    jp warm             ;Warm start

bas_from_pet:
;Copy BASIC program from PET DOS
;
    ld a,'P'            ;A = 'P' for CBM DOS program file
    call sub_0247h

    ld hl,dma_buf       ;HL = address of DMA buffer

    call cbm_get_byte   ;Read start address low byte (discarded)
    call cbm_get_byte   ;Read high byte (discarded)

bas_line:
;Process a tokenized line in the BASIC program.
;
                        ;Read pointer to next BASIC line:
    call cbm_get_byte   ;  A = Read pointer to next BASIC line low byte
    push af             ;  Push it onto the stack
    call cbm_get_byte   ;  A = Read pointer to next BASIC line high byte
    pop bc              ;  B = pop pointer low byte from stack

                        ;Detect end of BASIC program:
    or b                ;  Perform logical OR between the pointer bytes
    jr z,l017ah         ;  Jump to finish up if the pointer is zero.
                        ;    (End of BASIC program reached)

    push hl             ;Push DMA address onto stack

                        ;Read BASIC line number:
    call cbm_get_byte   ;  A = read low byte of BASIC line number
    push af             ;  Save line number low byte on stack
    call cbm_get_byte   ;  A = read high byte of BASIC line number
    ld d,a              ;  Move it into D
    pop af              ;  Pop line number high byte from stack
    ld e,a              ;  Move it into E
                        ;  BASIC line number is now in DE

    ld bc,10000         ;Write the line number as decimal in ASCII
    call bas_num        ;  TODO: comment these
    ld bc,1000
    call bas_num
    ld bc,100
    call bas_num
    ld bc,10
    call bas_num
    ld a,e
    add a,30h           ;Convert it to ASCII
    call write_to_file  ;Write it out

    ld a,' '
    call write_to_file  ;Write space after BASIC line number

bas_char:
;Get the next byte in the BASIC line and handle it.  The byte may
;be a token, end of line marker (null byte), or other character.
;
    call cbm_get_byte   ;Read next byte in BASIC line
    or a                ;Set flags
    jr z,bas_eol        ;Jump if zero (indicates end of current BASIC line)
    jp m,bas_token      ;Jump if bit 7 is set (indicates a BASIC token)

    call write_to_file  ;Byte is not a token, so write it out as-is
    jr bas_char         ;Loop to get the next byte on this line

bas_eol:
;End of current BASIC line has been reached.  Write CRLF to the output
;file and then loop to do the next line
;
    ld a,cr
    call write_to_file  ;Write carriage return
    ld a,lf
    call write_to_file  ;Write line feed
    jr bas_line         ;Loop to do the next line

bas_token:
;The current byte in the line is a BASIC token.  Find the ASCII
;command text for the token in the basic4_cmds table and write
;it to the output file.
;
    ld de,basic4_cmds   ;DE = address of BASIC commands table
    and 7fh             ;Strip high bit from the token
    ld b,a              ;Move it into B
    inc b               ;Add one

bas_find_tok:
;Loop until the BASIC command text for the token is found in the
;basic4_cmds table.
;
    djnz bas_next_tok   ;Decrement B, loop until B=0

bas_found_tok:
;The text for the current BASIC token has been found.  On entry,
;DE will be pointing at the first char of the command text.
;Write the command text to the output file.
;
    ld a,(de)           ;A = char from BASIC commands table
    and 7fh             ;Strip high bit
    push de
    call write_to_file  ;Write char from the command to file
    pop de
    ld a,(de)           ;A = same char from BASIC commands table
    rla                 ;Rotate bit 7 of command text into carry
    inc de              ;Increment pointer to commands table
    jr nc,bas_found_tok ;Loop for next if more chars in command text
    jr bas_char         ;Otherwise, this token is done, continue on
                        ;  to the next byte in the line.

bas_next_tok:
;Advance the pointer in DE to the next command in the
;basic4_cmds table.
;
    ld a,(de)           ;A = char from commands table
    inc de              ;Increment pointer to next char in command
    cp 0ffh             ;End of commands table reached?
    jr z,bas_char       ;  Yes: forget this char, jump to read next byte
    rla                 ;Rotate to test bit 7
    jr nc,bas_next_tok  ;Jump if bit 7 is not set (more chars in command)
    jr bas_find_tok

bas_num:
;DE = BASIC line number
;
    push hl
    ex de,hl
    ld a,2fh
l0227h:
    inc a
    or a
    sbc hl,bc
    jr nc,l0227h
    add hl,bc
    ex (sp),hl
    call write_to_file
    pop de
    ret

write_to_file:
;Write the byte in A to the DMA buffer via the pointer in HL
;and advance the pointer.  When the DMA buffer is full, write it
;to the current CP/M file and then reset the pointer.
;
    ld (hl),a           ;Store byte in DMA buffer
    inc l               ;Increment DMA buffer pointer
    ret nz              ;Return if the buffer is not full

    ld de,fcb           ;DE = address of FCB
    ld c,fwrite         ;C = Close File
    call bdos           ;BDOS system call
    or a                ;Set flags (A=0 means no error)
    jp nz,exit_full     ;Exit with "disk full" message if error

    ld hl,dma_buf       ;Reset the pointer to the DMA pointer
    ret

sub_0247h:
;Called from seq_from_pet, bas_from_pet
;
;A = CBM DOS file type ('P'=program, 'S'=sequential)
;
    push af             ;Push file type char onto stack
l0248h:
    ld de,ask_src_drive ;DE = address of "PET DOS source drive (A-P)?"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    call input          ;Get a line of input from the user
    ld a,(table_0+2)    ;Take the first character from that input
    sub 41h             ;Convert drive letter to number (A=0, B=1, C=2, ...)
    ld (src_drive),a    ;Save the source drive number
    call get_dtype      ;Check if drive is valid (carry set = valid)
    jr c,l026ah         ;Jump if drive is valid

    ld de,bad_drive     ;DE = address of "Bad drive"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    jr l0248h           ;Try again

l026ah:
    ld de,ask_src_file  ;DE = address of "PET DOS source file? "
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    call input          ;Get a line of input from the user

    ld a,(src_drive)    ;A = CP/M source drive number
    call ieee_init_drv  ;Initialize the CBM disk drive

    ld a,(src_drive)    ;A = CP/M source drive number
    and 01h             ;Mask off all except bit one.  Bit 0 of the CP/M
                        ;  drive number indicates which drive in a
                        ;  CBM dual drive unit.
    add a,30h           ;Convert it to ASCII (0="0", 1="1")
    ld (table_0),a      ;Save the CBM drive number

    ld a,(src_drive)    ;A = CP/M drive number
    call get_ddev       ;D = IEEE-488 primary address for the drive
                        ;  (D will be used below)

    ld hl,table_0+1     ;HL = address of table_0+1
    ld a,(hl)
    add a,06h
    ld c,a
    ld (hl),':'
    ld hl,0759h
    ld b,00h
    add hl,bc

    ld (hl),','         ;Append ','
    inc hl
    pop af              ;Pop file type char off stack
    ld (hl),a           ;Append file type ('P' or 'S')
    inc hl
    ld (hl),','         ;Append ','
    inc hl
    ld (hl),'R'         ;Append 'R' (Read mode)

    ld hl,table_0

    ld e,03h            ;E = file number
                        ;D = primary address set in get_ddev call above
    ld (cbm_device),de  ;Store primary address and file number
    call ieee_open      ;Open a file on an IEEE-488 device

    ld a,(src_drive)    ;A = CP/M source drive
    call ieee_read_err  ;Read the CBM DOS error channel
    or a                ;Set flags (0=OK)
    jp nz,exit_dos_err  ;Jump if the status is not OK

    ld de,fcb           ;DE = address of FCB
    ld c,fdelete        ;C = Delete File
    call bdos           ;BDOS system call

    ld de,fcb           ;DE = address of FCB
    ld c,fmake          ;C = Create File
    call bdos           ;BDOS system call
    inc a               ;Increment to check error from fmake
                        ;  (fmake returns A=0FFh if an error occurred)
    ret nz              ;Return if an error occurred

    ld de,(cbm_device)  ;D = IEEE-488 primary address, E = file number
    call ieee_close     ;Close open file on IEEE-488 device

exit_full:
;Print disk full error and return to CP/M
;
    ld de,disk_full     ;DE = address of "Disk or directory full"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call
    jp warm             ;Warm start

seq_to_pet:
;Copy sequential file to PET DOS
;
    ld de,ask_dest_drv  ;DE = address of "PET DOS destination drive?"
    ld c,cwritestr      ;C = Ouput String
    call bdos           ;BDOS system call

    call input          ;Get a line of input from the user
    ld a,(table_0+2)    ;Take the first character from that input
    sub 41h             ;Convert drive letter to number (A=0, B=1, C=2, ...)
    ld (src_drive),a    ;Save the source drive number
    call get_dtype      ;Check if drive is valid (carry set = valid)
    jr c,l0301h         ;Jump if drive is valid

    ld de,bad_drive     ;DE = address of "Bad drive"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    jr seq_to_pet       ;Try again

l0301h:
    ld de,ask_dest_file ;DE = address of "PET DOS destination file?"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    call input          ;Get a line of input from the user

    ld a,(src_drive)    ;A = CP/M source drive
    call ieee_init_drv  ;Initialize an IEEE-488 disk drive

    ld a,(src_drive)    ;A = CP/M source drive number
    and 01h             ;Mask off all except bit one.  Bit 0 of the CP/M
                        ;  drive number indicates which drive in a
                        ;  CBM dual drive unit.
    add a,30h           ;Convert it to ASCII (0="0", 1="1")
    ld (table_0),a      ;Save the CBM drive number

    ld a,(src_drive)    ;A = CP/M source drive
    call get_ddev       ;D = IEEE-488 primary address for the drive
                        ;  (D will be used below)

    ld hl,table_0+1
    ld c,(hl)
    ld b,00h
    ld ix,table_0+2
    add ix,bc
    ld (ix+00h),','     ;Append ','
    ld (ix+01h),'S'     ;Append 'S' (for Sequential file)
    ld (ix+02h),','     ;Append ','
    ld (ix+03h),'W'     ;Append 'W' (for Write mode)
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    ld (hl),3ah
    dec hl

    ld e,03h            ;E = file number
                        ;D = primary address set in get_ddev call above
    ld (cbm_device),de  ;Store primary address and file number
    call ieee_open      ;Open a file on an IEEE-488 device

    ld a,(src_drive)    ;A = CP/M source drive
    call ieee_read_err  ;Read the CBM DOS error channel
    or a                ;Set flags (0=OK)
    jp nz,exit_dos_err  ;Jump if the status is not OK

                        ;Open the CP/M input file:
    ld de,fcb           ;  DE = address of FCB
    ld c,fopen          ;  C = Open File
    call bdos           ;  BDOS system call
    inc a               ;  Increment to check error from fopen
                        ;    (fopen returns A=0FFh if an error occurred)
    jp z,exit_no_file   ;  Jump if an error occurred in fopen

seq_next_record:
                        ;Read the next record from the CP/M input file:
    ld de,fcb           ;  DE = address of FCB
    ld c,fread          ;  C = Read Next Record
    call bdos           ;  BDOS system call
    or a                ;  Set flags (fread returns A=0 if OK)
    jr nz,seq_done      ;  Jump if an error occurred in fread

    ld de,(cbm_device)  ;D = IEEE-488 primary address, E = file number
    call ieee_listen    ;Send LISTEN

                        ;Send all bytes in the DMA buffer to CBM DOS:
    ld hl,dma_buf       ;  HL = address of DMA buffer
seq_dma_loop:           ;
    ld a,(hl)           ;  A = get byte from the DMA buffer
    push hl             ;
    call ieee_put_byte  ;  Send it to the drive
    pop hl              ;
    inc l               ;  Increment low byte of DMA buffer pointer
    jr nz,seq_dma_loop  ;  Loop until L rolls over to 0, indicating that
                        ;    all 128 bytes in the DMA buffer have been sent

    call ieee_unlisten  ;Send UNLISTEN
    jr seq_next_record  ;Loop to do the next record

seq_done:
    ld de,(cbm_device)  ;D = IEEE-488 primary address, E = file number
    call ieee_close     ;Close open file on IEEE-488 device

    ld de,complete      ;DE = address of "Transfer complete"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call
    jp warm             ;Warm start

exit_no_file:
;Print file not found message and return to CP/M
;
    ld de,not_found     ;DE = address of "File not found"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call
    jp warm             ;Warm start

cbm_get_byte:
;Get the next byte from the CBM drive
;Returns the byte in A.
;
    push hl
    ld de,(cbm_device)  ;D = IEEE-488 primary address, E = file number
    call ieee_talk      ;Send TALK
    call ieee_get_byte  ;Get byte
    push af
    call ieee_untalk    ;Send UNTALK
    pop af
    pop hl
    ret

input:
;Read a line of input from the user and store it in
;the buffer at table_0.
;
    ld de,table_0       ;DE = address of buffer to receive user input
    ld a,50h            ;A = 50 bytes available in the buffer
    ld (de),a           ;Store bytes available where BDOS reads it
    ld c,creadstr       ;C = Buffered Console Input
    call bdos           ;BDOS system call

    call newline        ;Print a newline

    ld a,(table_0+1)    ;A = number of characters in the buffer
    ld hl,table_0+2     ;HL = address of first char in the buffer

    ld b,a              ;Move number of chars in buffer to B
    inc b               ;Increment B

l03ceh:
    ld a,(hl)           ;Get a char from the buffer

    cp 61h              ;Set carry if A < 97, clear carry if A >= 97
    jr c,l03dah         ;Jump if A < 97 (ASCII "a")

    cp 7bh              ;Set carry if A < 123, clear carry if A >= 123
    jr nc,l03dah        ;Jump if A >= 123 (ASCII "z" + 1)

                        ;Char is in the range of 97 ("a") and 123 ("z").

    sub 20h             ;Convert ASCII lowercase to uppercase
    ld (hl),a           ;Save it back to the buffer

l03dah:
    inc hl              ;Increment pointer to next char in the buffer
    djnz l03ceh         ;Decrement B, loop until B=0

    dec hl
    ld (hl),cr
    ret

exit_bad_file:
;Print bad filename message and return to CP/M.
;
    ld de,bad_filename  ;DE = address of "Bad filename"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call
    jp warm             ;Warm start

exit_dos_err:
;Print CBM DOS error message and return to CP/M
;
    ld de,disk_error    ;DE = address of "Disk error:"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    ld hl,dos_msg       ;HL = address of last CBM DOS error message
l03f7h:
    push hl             ;Save HL
    ld e,(hl)           ;E = char from CBM DOS error message
    ld c,cwrite         ;C = write char to console out
    call bdos           ;BDOS system call
    pop hl              ;Restore HL

    ld a,(hl)           ;A = char from CBM DOS error message
    inc hl              ;Increment to next char in the message
    cp cr               ;Is this char a carriage return?
    jr nz,l03f7h        ;  No: loop to handle next char
    jp warm             ;Warm start

newline:
;Print a newline (CR+LF)
;
    ld e,cr             ;E = carriage return
    ld c,cwrite         ;C = write char to console out
    call bdos           ;BDOS system call

    ld e,lf             ;E = line feed
    ld c,cwrite         ;C = write char to console out
    jp bdos             ;Jump out to BDOS, it will return to caller

menu:
    db "CP/M <--> Pet DOS file transfer",cr,lf
    db "----      --- --- ---- --------",cr,lf

    db lf,"1.  Copy sequential file to PET DOS",cr,lf
    db lf,"2.  Copy sequential file from PET DOS",cr,lf
    db lf,"3.  Copy BASIC program from PET DOS",cr,lf
    db lf,"4.  As 2.  but insert line feeds",cr,lf
    db lf,"Which type of transfer (1 to 4) ? $"
ask_src_drive:
    db "PET DOS source drive (A-P) ? $"
ask_src_file:
    db "PET DOS source file ? $"
ask_dest_drv:
    db "PET DOS destination drive (A-P) ? $"
ask_dest_file:
    db "PET DOS destn. file ? $"
bad_filename:
    db cr,lf,"Bad file name$"
bad_drive:
    db cr,lf,"Bad drive name$"
bad_command:
    db cr,lf,"Bad command",cr,lf,"$"
disk_error:
    db cr,lf,"Disk error :",cr,lf,"$"
disk_full:
    db cr,lf,"Disk or directory full$"
complete:
    db cr,lf,"Transfer complete$"
not_found:
    db cr,lf,"File not found$"

basic4_cmds:
;CBM BASIC 4.0 commands ordered by token
;Last character of each command has bit 7 set
;
    db "EN",0c4h        ;END
    db "FO",0d2h        ;FOR
    db "NEX",0d4h       ;NEXT
    db "DAT",0c1h       ;DATA
    db "INPUT",0a3h     ;INPUT#
    db "INPU",0d4h      ;INPUT
    db "DI",0cdh        ;DIM
    db "REA",0c4h       ;READ
    db "LE",0d4h        ;LET
    db "GOT",0cfh       ;GOTO
    db "RU",0ceh        ;RUN
    db "I",0c6h         ;IF
    db "RESTOR",0c5h    ;RESTORE
    db "GOSU",0c2h      ;GOSUB
    db "RETUR",0ceh     ;RETURN
    db "RE",0cdh        ;REM
    db "STO",0d0h       ;STOP
    db "O",0ceh         ;ON
    db "WAI",0d4h       ;WAIT
    db "LOA",0c4h       ;LOAD
    db "SAV",0c5h       ;SAVE
    db "VERIF",0d9h     ;VERIFY
    db "DE",0c6h        ;DEF
    db "POK",0c5h       ;POKE
    db "PRINT",0a3h     ;PRINT#
    db "PRIN",0d4h      ;PRINT
    db "CON",0d4h       ;CONT
    db "LIS",0d4h       ;LIST
    db "CL",0d2h        ;CLR
    db "CM",0c4h        ;CMD
    db "SY",0d3h        ;SYS
    db "OPE",0ceh       ;OPEN
    db "CLOS",0c5h      ;CLOSE
    db "GE",0d4h        ;GET
    db "NE",0d7h        ;NEW
    db "TAB",0a8h       ;TAB(
    db "T",0cfh         ;TO
    db "F",0ceh         ;FN
    db "SPC",0a8h       ;SPC(
    db "THE",0ceh       ;THEN
    db "NO",0d4h        ;NOT
    db "STE",0d0h       ;STEP
    db 0abh             ;+
    db 0adh             ;-
    db 0aah             ;*
    db 0afh             ;/
    db 0deh             ;^
    db "AN",0c4h        ;AND
    db "O",0d2h         ;OR
    db 0beh             ;>
    db 0bdh             ;=
    db 0bch             ;<
    db "SG",0ceh        ;SGN
    db "IN",0d4h        ;INT
    db "AB",0d3h        ;ABS
    db "US",0d2h        ;USR
    db "FR",0c5h        ;FRE
    db "PO",0d3h        ;POS
    db "SQ",0d2h        ;SQR
    db "RN",0c4h        ;RND
    db "LO",0c7h        ;LOG
    db "EX",0d0h        ;EXP
    db "CO",0d3h        ;COS
    db "SI",0ceh        ;SIN
    db "TA",0ceh        ;TAN
    db "AT",0ceh        ;ATN
    db "PEE",0cbh       ;PEEK
    db "LE",0ceh        ;LEN
    db "STR",0a4h       ;STR$
    db "VA",0cch        ;VAL
    db "AS",0c3h        ;ASC
    db "CHR",0a4h       ;CHR$
    db "LEFT",0a4h      ;LEFT$
    db "RIGHT",0a4h     ;RIGHT$
    db "MID",0a4h       ;MID$
    db "G",0cfh         ;GO
    db "CONCA",0d4h     ;CONCAT
    db "DOPE",0ceh      ;DOPEN
    db "DCLOS",0c5h     ;DCLOSE
    db "RECOR",0c4h     ;RECORD
    db "HEADE",0d2h     ;HEADER
    db "COLLEC",0d4h    ;COLLECT
    db "BACKU",0d0h     ;BACKUP
    db "COP",0d9h       ;COPY
    db "APPEN",0c4h     ;APPEND
    db "DSAV",0c5h      ;DSAVE
    db "DLOA",0c4h      ;DLOAD
    db "CATALO",0c7h    ;CATALOG
    db "RENAM",0c5h     ;RENAME
    db "SCRATC",0c8h    ;SCRATCH
    db "DIRECTOR",0d9h  ;DIRECTORY
    db 0ffh             ;End of table

table_0:
    db 2ah,0a0h,3ch,19h,34h,0d1h,0f1h,0e6h,7fh,0f5h,87h,0fah,92h,2fh,2ah
    db 8eh,3ch,7eh,0b7h,0cah,81h,2fh,0f1h,0c5h,47h,04h,2bh,05h,0cah,6ch,2fh
    db 7eh,0d5h,2fh,5fh,16h,0ffh,19h,0d1h,0c3h,5dh,2fh,7eh,0b7h,0cah,8fh,2fh
    db 3dh,47h,2bh,7eh,04h,05h,0cah,8fh,2fh,0cdh,21h,31h,05h,0c3h,73h,2fh
    db 0f1h,2bh,3ch,3dh,0cah,8ch,2fh,2bh,0c3h,84h,2fh,7eh,0e1h,0c9h,0c1h,0e1h
    db 0c9h,3eh,2eh,0cdh,21h,31h,0cdh,21h,31h,0f1h,0e6h,3fh,0c5h,2ah,9bh,3ch
    db 4fh,06h,00h,09h,44h,0cdh,0b6h,17h,45h,0cdh,0b6h,17h,0c1h,0e1h,1bh,1ah
    db 0c9h,0e5h,0cdh,54h,0bh,0e1h,0c4h,0cbh,2fh,0f5h,11h,16h,3bh,1ah,3ch,4fh
    db 1ah,77h,13h

src_drive:
    db 2bh      ;CP/M source drive number (0=A:, 1=B:, ...)
cbm_device:
    db 0dh      ;IEEE-488 primary address of CBM drive
cbm_file:
    db 0c2h     ;File number on CBM drive
insert_lf:
    db 0c1h     ;Insert linefeeds flag (0=off, 1=on)

unknown:
    db 0f1h,0e6h,7fh,0f5h,87h,0fah,92h,2fh,2ah,8eh,3ch
    db 7eh,0b7h,0cah,81h,2fh,0f1h,0c5h,47h,04h,2bh,05h,0cah,6ch,2fh
    db 7eh,0d5h,2fh,5fh
