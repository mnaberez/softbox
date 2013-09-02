; z80dasm 1.1.3
; command line: z80dasm --origin 256 --labels --address xfer.com

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point
fcb:           equ  005ch ;BDOS default FCB
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

    ld hl,07e2h
    ld (hl),00h

    cp '1'              ;1 = Copy sequential file to PET DOS
    jp z,seq_to_pet

    cp '2'              ;2 = Copy sequential file from PET DOS
    jp z,seq_from_pet

    cp '3'              ;3 = Copy BASIC program from PET DOS
    jp z,bas_from_pet

    inc (hl)
    cp '4'              ;4 = As 2. but insert line feeds
    jp z,seq_from_pet

    ld de,bad_command   ;DE = address of bad command string
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call
    jr get_selection    ;Try again

seq_from_pet:
;Copy sequential file from PET DOS
;
    ld a,53h
    call sub_0247h
    ld hl,0080h
l015ah:
    call cbm_get_byte
    ld d,a
    ld a,(eoisav)
    and 10h
    push af
    ld a,(07e2h)
    or a
    ld a,d
    jr z,l0174h
    cp cr
    jr nz,l0174h
    call sub_0234h
    ld a,lf
l0174h:
    call sub_0234h
    pop af
    jr z,l015ah
l017ah:
    ld de,(table_1+1)
    call ieee_close
    ld b,7fh
l0183h:
    push bc
    ld a,1ah
    call sub_0234h
    pop bc
    djnz l0183h
    ld de,fcb
    ld c,fclose
    call bdos
    ld de,complete      ;DE = address of "Transfer complete"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call
    jp warm             ;Warm start

bas_from_pet:
;Copy BASIC program from PET DOS
;
    ld a,50h
    call sub_0247h
    ld hl,0080h
    call cbm_get_byte
    call cbm_get_byte
l01adh:
    call cbm_get_byte
    push af
    call cbm_get_byte
    pop bc
    or b
    jr z,l017ah
    push hl
    call cbm_get_byte
    push af
    call cbm_get_byte
    ld d,a
    pop af
    ld e,a
    ld bc,2710h
    call sub_0223h
    ld bc,03e8h
    call sub_0223h
    ld bc,0064h
    call sub_0223h
    ld bc,000ah
    call sub_0223h
    ld a,e
    add a,30h
    call sub_0234h
    ld a,20h
    call sub_0234h
l01e6h:
    call cbm_get_byte
    or a
    jr z,l01f4h
    jp m,l0200h
    call sub_0234h
    jr l01e6h
l01f4h:
    ld a,cr
    call sub_0234h
    ld a,lf
    call sub_0234h
    jr l01adh
l0200h:
    ld de,basic4_cmds
    and 7fh
    ld b,a
    inc b
l0207h:
    djnz l0218h
l0209h:
    ld a,(de)
    and 7fh
    push de
    call sub_0234h
    pop de
    ld a,(de)
    rla
    inc de
    jr nc,l0209h
    jr l01e6h
l0218h:
    ld a,(de)
    inc de
    cp 0ffh
    jr z,l01e6h
    rla
    jr nc,l0218h
    jr l0207h
sub_0223h:
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
    call sub_0234h
    pop de
    ret

sub_0234h:
    ld (hl),a
    inc l
    ret nz
    ld de,fcb
    ld c,fwrite
    call bdos
    or a
    jp nz,exit_full
    ld hl,0080h
    ret

sub_0247h:
    push af
l0248h:
    ld de,src_drive     ;DE = address of "PET DOS source drive (A-P)?"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    call input          ;Get a line of input from the user
    ld a,(table_0+2)
    sub 41h
    ld (table_1),a
    call get_dtype
    jr c,l026ah

    ld de,bad_drive     ;DE = address of "Bad drive"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    jr l0248h           ;Try again

l026ah:
    ld de,src_filename  ;DE = address of "PET DOS source file? "
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    call input          ;Get a line of input from the user
    ld a,(table_1)
    call ieee_init_drv
    ld a,(table_1)
    and 01h
    add a,30h
    ld (table_0),a
    ld a,(table_1)
    call get_ddev
    ld hl,table_0+1
    ld a,(hl)
    add a,06h
    ld c,a
    ld (hl),3ah
    ld hl,0759h
    ld b,00h
    add hl,bc
    ld (hl),2ch
    inc hl
    pop af
    ld (hl),a
    inc hl
    ld (hl),2ch
    inc hl
    ld (hl),52h
    ld hl,table_0
    ld e,03h
    ld (table_1+1),de
    call ieee_open
    ld a,(table_1)
    call ieee_read_err
    or a
    jp nz,exit_dos_err
    ld de,fcb
    ld c,fdelete
    call bdos
    ld de,fcb
    ld c,fmake
    call bdos
    inc a
    ret nz
    ld de,(table_1+1)
    call ieee_close

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
    ld de,dest_drive    ;DE = address of "PET DOS destination drive?"
    ld c,cwritestr      ;C = Ouput String
    call bdos           ;BDOS system call

    call input          ;Get a line of input from the user
    ld a,(table_0+2)
    sub 41h
    ld (table_1),a
    call get_dtype
    jr c,l0301h

    ld de,bad_drive     ;DE = address of "Bad drive"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    jr seq_to_pet       ;Try again

l0301h:
    ld de,dest_filename ;DE = address of "PET DOS destination file?"
    ld c,cwritestr      ;C = Output String
    call bdos           ;BDOS system call

    call input          ;Get a line of input from the user
    ld a,(table_1)
    call ieee_init_drv
    ld a,(table_1)
    and 01h
    add a,30h
    ld (table_0),a
    ld a,(table_1)
    call get_ddev
    ld hl,table_0+1
    ld c,(hl)
    ld b,00h
    ld ix,table_0+2
    add ix,bc
    ld (ix+00h),02ch
    ld (ix+01h),053h
    ld (ix+02h),02ch
    ld (ix+03h),057h
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    ld (hl),3ah
    dec hl
    ld e,03h
    ld (table_1+1),de
    call ieee_open
    ld a,(table_1)
    call ieee_read_err
    or a
    jp nz,exit_dos_err
    ld de,fcb
    ld c,fopen
    call bdos
    inc a
    jp z,exit_no_file
l0366h:
    ld de,fcb
    ld c,fread
    call bdos
    or a
    jr nz,l0389h
    ld de,(table_1+1)
    call ieee_listen
    ld hl,0080h
l037bh:
    ld a,(hl)
    push hl
    call ieee_put_byte
    pop hl
    inc l
    jr nz,l037bh
    call ieee_unlisten
    jr l0366h
l0389h:
    ld de,(table_1+1)
    call ieee_close

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
    ld de,(table_1+1)   ;D = IEEE-488 primary address, E = secondary
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
    ld de,table_0
    ld a,50h
    ld (de),a
    ld c,creadstr
    call bdos
    call newline
    ld a,(table_0+1)
    ld hl,table_0+2
    ld b,a
    inc b
l03ceh:
    ld a,(hl)
    cp 61h
    jr c,l03dah
    cp 7bh
    jr nc,l03dah
    sub 20h
    ld (hl),a
l03dah:
    inc hl
    djnz l03ceh
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
src_drive:
    db "PET DOS source drive (A-P) ? $"
src_filename:
    db "PET DOS source file ? $"
dest_drive:
    db "PET DOS destination drive (A-P) ? $"
dest_filename:
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

table_1:
    db 2bh,0dh,0c2h,0c1h,0f1h,0e6h,7fh,0f5h,87h,0fah,92h,2fh,2ah
    db 8eh,3ch,7eh,0b7h,0cah,81h,2fh,0f1h,0c5h,47h,04h,2bh,05h,0cah,6ch,2fh
    db 7eh,0d5h,2fh,5fh
