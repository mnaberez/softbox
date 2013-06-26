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

    org 0100h

    nop
    nop
    nop
    ld sp,(0006h)
    ld a,(fcb+1)
    cp ' '
    jp z,exit_bad_file
    ld hl,fcb+1
    ld b,0bh
l0114h:
    ld a,(hl)
    cp '?'
    jp z,exit_bad_file
    inc hl
    djnz l0114h
l011dh:
    call newline
    ld de,menu
    ld c,cwritestr
    call bdos

    call sub_03b8h
    ld a,(table_0+2)
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
    ld de,bad_command
    ld c,cwritestr
    call bdos
    jr l011dh

seq_from_pet:
;Copy sequential file from PET DOS
;
    ld a,53h            ;0152 3e 53
    call sub_0247h      ;0154 cd 47 02
    ld hl,0080h         ;0157 21 80 00
l015ah:
    call sub_03a6h      ;015a cd a6 03
    ld d,a              ;015d 57
    ld a,(eoisav)       ;015e 3a 6c ea
    and 10h             ;0161 e6 10
    push af             ;0163 f5
    ld a,(07e2h)        ;0164 3a e2 07
    or a                ;0167 b7
    ld a,d              ;0168 7a
    jr z,l0174h         ;0169 28 09
    cp cr               ;016b fe 0d
    jr nz,l0174h        ;016d 20 05
    call sub_0234h      ;016f cd 34 02
    ld a,lf             ;0172 3e 0a
l0174h:
    call sub_0234h      ;0174 cd 34 02
    pop af              ;0177 f1
    jr z,l015ah         ;0178 28 e0
l017ah:
    ld de,(table_1+1)   ;017a ed 5b e0 07
    call ieee_close     ;017e cd 60 f0
    ld b,7fh            ;0181 06 7f
l0183h:
    push bc             ;0183 c5
    ld a,1ah            ;0184 3e 1a
    call sub_0234h      ;0186 cd 34 02
    pop bc              ;0189 c1
    djnz l0183h         ;018a 10 f7
    ld de,fcb           ;018c 11 5c 00
    ld c,fclose         ;018f 0e 10
    call bdos           ;0191 cd 05 00
    ld de,complete      ;0194 11 dd 05
    ld c,cwritestr      ;0197 0e 09
    call bdos           ;0199 cd 05 00
    jp warm             ;019c c3 00 00

bas_from_pet:
;Copy BASIC program from PET DOS
;
    ld a,50h            ;019f 3e 50
    call sub_0247h      ;01a1 cd 47 02
    ld hl,0080h         ;01a4 21 80 00
    call sub_03a6h      ;01a7 cd a6 03
    call sub_03a6h      ;01aa cd a6 03
l01adh:
    call sub_03a6h      ;01ad cd a6 03
    push af             ;01b0 f5
    call sub_03a6h      ;01b1 cd a6 03
    pop bc              ;01b4 c1
    or b                ;01b5 b0
    jr z,l017ah         ;01b6 28 c2
    push hl             ;01b8 e5
    call sub_03a6h      ;01b9 cd a6 03
    push af             ;01bc f5
    call sub_03a6h      ;01bd cd a6 03
    ld d,a              ;01c0 57
    pop af              ;01c1 f1
    ld e,a              ;01c2 5f
    ld bc,2710h         ;01c3 01 10 27
    call sub_0223h      ;01c6 cd 23 02
    ld bc,03e8h         ;01c9 01 e8 03
    call sub_0223h      ;01cc cd 23 02
    ld bc,0064h         ;01cf 01 64 00
    call sub_0223h      ;01d2 cd 23 02
    ld bc,000ah         ;01d5 01 0a 00
    call sub_0223h      ;01d8 cd 23 02
    ld a,e              ;01db 7b
    add a,30h           ;01dc c6 30
    call sub_0234h      ;01de cd 34 02
    ld a,20h            ;01e1 3e 20
    call sub_0234h      ;01e3 cd 34 02
l01e6h:
    call sub_03a6h      ;01e6 cd a6 03
    or a                ;01e9 b7
    jr z,l01f4h         ;01ea 28 08
    jp m,l0200h         ;01ec fa 00 02
    call sub_0234h      ;01ef cd 34 02
    jr l01e6h           ;01f2 18 f2
l01f4h:
    ld a,cr             ;01f4 3e 0d
    call sub_0234h      ;01f6 cd 34 02
    ld a,lf             ;01f9 3e 0a
    call sub_0234h      ;01fb cd 34 02
    jr l01adh           ;01fe 18 ad
l0200h:
    ld de,basic4_cmds   ;0200 11 02 06
    and 7fh             ;0203 e6 7f
    ld b,a              ;0205 47
    inc b               ;0206 04
l0207h:
    djnz l0218h         ;0207 10 0f
l0209h:
    ld a,(de)           ;0209 1a
    and 7fh             ;020a e6 7f
    push de             ;020c d5
    call sub_0234h      ;020d cd 34 02
    pop de              ;0210 d1
    ld a,(de)           ;0211 1a
    rla                 ;0212 17
    inc de              ;0213 13
    jr nc,l0209h        ;0214 30 f3
    jr l01e6h           ;0216 18 ce
l0218h:
    ld a,(de)           ;0218 1a
    inc de              ;0219 13
    cp 0ffh             ;021a fe ff
    jr z,l01e6h         ;021c 28 c8
    rla                 ;021e 17
    jr nc,l0218h        ;021f 30 f7
    jr l0207h           ;0221 18 e4
sub_0223h:
    push hl             ;0223 e5
    ex de,hl            ;0224 eb
    ld a,2fh            ;0225 3e 2f
l0227h:
    inc a               ;0227 3c
    or a                ;0228 b7
    sbc hl,bc           ;0229 ed 42
    jr nc,l0227h        ;022b 30 fa
    add hl,bc           ;022d 09
    ex (sp),hl          ;022e e3
    call sub_0234h      ;022f cd 34 02
    pop de              ;0232 d1
    ret                 ;0233 c9
sub_0234h:
    ld (hl),a           ;0234 77
    inc l               ;0235 2c
    ret nz              ;0236 c0
    ld de,fcb           ;0237 11 5c 00
    ld c,fwrite         ;023a 0e 15
    call bdos           ;023c cd 05 00
    or a                ;023f b7
    jp nz,exit_full     ;0240 c2 d4 02
    ld hl,0080h         ;0243 21 80 00
    ret                 ;0246 c9
sub_0247h:
    push af             ;0247 f5
l0248h:
    ld de,src_drive     ;0248 11 13 05
    ld c,cwritestr      ;024b 0e 09
    call bdos           ;024d cd 05 00
    call sub_03b8h      ;0250 cd b8 03
    ld a,(table_0+2)    ;0253 3a 5f 07
    sub 41h             ;0256 d6 41
    ld (table_1),a      ;0258 32 df 07
    call get_dtype      ;025b cd 51 f0
    jr c,l026ah         ;025e 38 0a
    ld de,bad_drive     ;0260 11 92 05
    ld c,cwritestr      ;0263 0e 09
    call bdos           ;0265 cd 05 00
    jr l0248h           ;0268 18 de
l026ah:
    ld de,src_filename  ;026a 11 31 05
    ld c,cwritestr      ;026d 0e 09
    call bdos           ;026f cd 05 00
    call sub_03b8h      ;0272 cd b8 03
    ld a,(table_1)      ;0275 3a df 07
    call ieee_init_drv  ;0278 cd 78 f0
    ld a,(table_1)      ;027b 3a df 07
    and 01h             ;027e e6 01
    add a,30h           ;0280 c6 30
    ld (table_0),a      ;0282 32 5d 07
    ld a,(table_1)      ;0285 3a df 07
    call get_ddev       ;0288 cd 54 f0
    ld hl,table_0+1     ;028b 21 5e 07
    ld a,(hl)           ;028e 7e
    add a,06h           ;028f c6 06
    ld c,a              ;0291 4f
    ld (hl),3ah         ;0292 36 3a
    ld hl,0759h         ;0294 21 59 07
    ld b,00h            ;0297 06 00
    add hl,bc           ;0299 09
    ld (hl),2ch         ;029a 36 2c
    inc hl              ;029c 23
    pop af              ;029d f1
    ld (hl),a           ;029e 77
    inc hl              ;029f 23
    ld (hl),2ch         ;02a0 36 2c
    inc hl              ;02a2 23
    ld (hl),52h         ;02a3 36 52
    ld hl,table_0       ;02a5 21 5d 07
    ld e,03h            ;02a8 1e 03
    ld (table_1+1),de   ;02aa ed 53 e0 07
    call ieee_open      ;02ae cd 5d f0
    ld a,(table_1)      ;02b1 3a df 07
    call ieee_read_err  ;02b4 cd 5a f0
    or a                ;02b7 b7
    jp nz,exit_dos_err  ;02b8 c2 ec 03
    ld de,fcb           ;02bb 11 5c 00
    ld c,fdelete        ;02be 0e 13
    call bdos           ;02c0 cd 05 00
    ld de,fcb           ;02c3 11 5c 00
    ld c,fmake          ;02c6 0e 16
    call bdos           ;02c8 cd 05 00
    inc a               ;02cb 3c
    ret nz              ;02cc c0
    ld de,(table_1+1)   ;02cd ed 5b e0 07
    call ieee_close     ;02d1 cd 60 f0

exit_full:
;Print disk full error and return to CP/M
;
    ld de,disk_full
    ld c,cwritestr
    call bdos
    jp warm

seq_to_pet:
;Copy sequential file to PET DOS
;
    ld de,dest_drive    ;02df 11 48 05
    ld c,cwritestr      ;02e2 0e 09
    call bdos           ;02e4 cd 05 00
    call sub_03b8h      ;02e7 cd b8 03
    ld a,(table_0+2)    ;02ea 3a 5f 07
    sub 41h             ;02ed d6 41
    ld (table_1),a      ;02ef 32 df 07
    call get_dtype      ;02f2 cd 51 f0
    jr c,l0301h         ;02f5 38 0a
    ld de,bad_drive     ;02f7 11 92 05
    ld c,cwritestr      ;02fa 0e 09
    call bdos           ;02fc cd 05 00
    jr seq_to_pet       ;02ff 18 de
l0301h:
    ld de,dest_filename ;0301 11 6b 05
    ld c,cwritestr      ;0304 0e 09
    call bdos           ;0306 cd 05 00
    call sub_03b8h      ;0309 cd b8 03
    ld a,(table_1)      ;030c 3a df 07
    call ieee_init_drv  ;030f cd 78 f0
    ld a,(table_1)      ;0312 3a df 07
    and 01h             ;0315 e6 01
    add a,30h           ;0317 c6 30
    ld (table_0),a      ;0319 32 5d 07
    ld a,(table_1)      ;031c 3a df 07
    call get_ddev       ;031f cd 54 f0
    ld hl,table_0+1     ;0322 21 5e 07
    ld c,(hl)           ;0325 4e
    ld b,00h            ;0326 06 00
    ld ix,table_0+2     ;0328 dd 21 5f 07
    add ix,bc           ;032c dd 09
    ld (ix+00h),02ch    ;032e dd 36 00 2c
    ld (ix+01h),053h    ;0332 dd 36 01 53
    ld (ix+02h),02ch    ;0336 dd 36 02 2c
    ld (ix+03h),057h    ;033a dd 36 03 57
    inc bc              ;033e 03
    inc bc              ;033f 03
    inc bc              ;0340 03
    inc bc              ;0341 03
    inc bc              ;0342 03
    inc bc              ;0343 03
    ld (hl),3ah         ;0344 36 3a
    dec hl              ;0346 2b
    ld e,03h            ;0347 1e 03
    ld (table_1+1),de   ;0349 ed 53 e0 07
    call ieee_open      ;034d cd 5d f0
    ld a,(table_1)      ;0350 3a df 07
    call ieee_read_err  ;0353 cd 5a f0
    or a                ;0356 b7
    jp nz,exit_dos_err  ;0357 c2 ec 03
    ld de,fcb           ;035a 11 5c 00
    ld c,fopen          ;035d 0e 0f
    call bdos           ;035f cd 05 00
    inc a               ;0362 3c
    jp z,exit_no_file   ;0363 ca 9b 03
l0366h:
    ld de,fcb           ;0366 11 5c 00
    ld c,fread          ;0369 0e 14
    call bdos           ;036b cd 05 00
    or a                ;036e b7
    jr nz,l0389h        ;036f 20 18
    ld de,(table_1+1)   ;0371 ed 5b e0 07
    call ieee_listen    ;0375 cd 33 f0
    ld hl,0080h         ;0378 21 80 00
l037bh:
    ld a,(hl)           ;037b 7e
    push hl             ;037c e5
    call ieee_put_byte  ;037d cd 42 f0
    pop hl              ;0380 e1
    inc l               ;0381 2c
    jr nz,l037bh        ;0382 20 f7
    call ieee_unlisten  ;0384 cd 36 f0
    jr l0366h           ;0387 18 dd
l0389h:
    ld de,(table_1+1)   ;0389 ed 5b e0 07
    call ieee_close     ;038d cd 60 f0
    ld de,complete      ;0390 11 dd 05
    ld c,cwritestr      ;0393 0e 09
    call bdos           ;0395 cd 05 00
    jp warm             ;0398 c3 00 00

exit_no_file:
;Print file not found message and return to CP/M
;
    ld de,not_found
    ld c,cwritestr
    call bdos
    jp warm

sub_03a6h:
    push hl             ;03a6 e5
    ld de,(table_1+1)   ;03a7 ed 5b e0 07
    call ieee_talk      ;03ab cd 39 f0
    call ieee_get_byte  ;03ae cd 3f f0
    push af             ;03b1 f5
    call ieee_untalk    ;03b2 cd 3c f0
    pop af              ;03b5 f1
    pop hl              ;03b6 e1
    ret                 ;03b7 c9
sub_03b8h:
    ld de,table_0       ;03b8 11 5d 07
    ld a,50h            ;03bb 3e 50
    ld (de),a           ;03bd 12
    ld c,creadstr       ;03be 0e 0a
    call bdos           ;03c0 cd 05 00
    call newline        ;03c3 cd 08 04
    ld a,(table_0+1)    ;03c6 3a 5e 07
    ld hl,table_0+2     ;03c9 21 5f 07
    ld b,a              ;03cc 47
    inc b               ;03cd 04
l03ceh:
    ld a,(hl)           ;03ce 7e
    cp 61h              ;03cf fe 61
    jr c,l03dah         ;03d1 38 07
    cp 7bh              ;03d3 fe 7b
    jr nc,l03dah        ;03d5 30 03
    sub 20h             ;03d7 d6 20
    ld (hl),a           ;03d9 77
l03dah:
    inc hl              ;03da 23
    djnz l03ceh         ;03db 10 f1
    dec hl              ;03dd 2b
    ld (hl),cr          ;03de 36 0d
    ret                 ;03e0 c9

exit_bad_file:
;Print bad filename message and return to CP/M.
;
    ld de,bad_filename
    ld c,cwritestr
    call bdos
    jp warm

exit_dos_err:
;Print CBM DOS error message and return to CP/M
;
    ld de,disk_error
    ld c,cwritestr
    call bdos
    ld hl,dos_msg
l03f7h:
    push hl
    ld e,(hl)
    ld c,cwrite
    call bdos
    pop hl
    ld a,(hl)
    inc hl
    cp cr
    jr nz,l03f7h
    jp warm

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
