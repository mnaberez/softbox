;NEWDOS.COM
;  Configure HardBox settings on the MW-1000.
;
;This program was not written in assembly language.  It was written
;in a high level language but the compiler is unknown.  This is a
;disassembly of the compiled program.
;

corvus:        equ  18h   ;Corvus data bus

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point

cwrite:        equ 02h    ;Console Output
creadstr:      equ 0ah    ;Buffered Console Input

bell:          equ 07h    ;Bell
lf:            equ 0ah    ;Line Feed
cr:            equ 0dh    ;Carriage Return

l4000h:        equ  4000h ;opcode "jp" (1 Byte)
l4001h:        equ  4001h ;jump address (2 Bytes)

                          ;here starts the user area
l4003h:        equ  4003h ;Physical drive number (1 .. 4, 1 Byte)
l4004h:        equ  4004h ;Starting sector number on drive (An Absolute Sector Number, 3 Bytes)
l4007h:        equ  4007h ;User area size in kilobytes, there are 4 blocks (2 Bytes)
l4009h:        equ  4009h ;Type of user area (Single user or Multi-user) (1 Byte)
l400ah:        equ  400ah ;Maximum numbers of files allowed (2 Bytes)
l400ch:        equ  400ch ;direct access size (2 Bytes)
l400eh:        equ  400eh ;tracks per drive (2 Bytes)
l4010h:        equ  4010h ;sectors per track (3 Bytes)
l4023h:        equ  4023h ;user name (16 Bytes)

                          ;here starts the global area
l4033h:        equ  4033h ;Max. head number (1 Byte)
l4034h:        equ  4034h ;First cylinder number using for HardBox (2 Bytes)
l4036h:        equ  4036h ;IEEE-488 primary address (1 Byte)

    org 0100h

    jp start

end:
;Exit back to CP/M.
    jp warm             ;Jump to CP/M warm start
    ret

check_error:
    ;IF (l3000h AND &H40) <> 0 THEN GOTO got_error
    ld a,(l3000h)
    and 40h
    jp nz,got_error

    ;RETURN
    ret

got_error:
    ;PRINT "DRIVE ERROR #";
    ld bc,l0aedh
    call print_str

    ;IF l3000h <> &H40 THEN GOTO is_err_42h
    ld a,(l3000h)
    cp 40h
    jp nz,is_err_42h

    ;PRINT "40 - header write error"
    ld bc,l0afbh
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_42h:
    ;IF l3000h <> &H42 THEN GOTO is_err_44h
    ld a,(l3000h)
    cp 42h
    jp nz,is_err_44h

    ;PRINT "42 - header read error"
    ld bc,l0b13h
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_44h:
    ;IF l3000h <> &H44 THEN GOTO is_err_46h
    ld a,(l3000h)
    cp 44h
    jp nz,is_err_46h

    ;PRINT "44 - data read error"
    ld bc,l0b2ah
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_46h:
    ;IF l3000h <> &H46 THEN GOTO is_err_47h
    ld a,(l3000h)
    cp 46h
    jp nz,is_err_47h

    ;PRINT "46 - write fault"
    ld bc,l0b3fh
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_47h:
    ;IF l3000h <> &H47 THEN GOTO is_err_49h
    ld a,(l3000h)
    cp 47h
    jp nz,is_err_49h

    ;PRINT "47 - disk not ready"
    ld bc,l0b50h
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_49h:
    ;IF l3000h <> &H49 THEN GOTO unknown_err
    ld a,(l3000h)
    cp 49h
    jp nz,unknown_err

    ;PRINT "49 - illegal command"
    ld bc,l0b64h
    call print_str

    ;GOTO got_error_done
    jp got_error_done

unknown_err:
    ;PRINT "xx - unknown error code"
    ld bc,l0b79h
    call print_str

got_error_done:
    ;PRINT
    call print_eol

    ;RETURN
    ret

readline:
    ld hl,l301eh        ;0186 21 1e 30
    ld (hl),80h         ;0189 36 80
    ld de,l301eh        ;018b 11 1e 30
    ld c,creadstr       ;018e 0e 0a
    call bdos           ;0190 cd 05 00
    call print_eol      ;0193 cd 27 02
    ld hl,0000h         ;0196 21 00 00
    ld (l3004h),hl      ;0199 22 04 30
    ld a,(l301fh)       ;019c 3a 1f 30
    or a                ;019f b7
    jp nz,l01abh        ;01a0 c2 ab 01
    ld hl,l3002h        ;01a3 21 02 30
    ld (hl),00h         ;01a6 36 00
    jp l0218h           ;01a8 c3 18 02
l01abh:
    ld a,(l3020h)       ;01ab 3a 20 30
    ld (l3002h),a       ;01ae 32 02 30
    cp 'a'              ;01b1 fe 61
    jp m,l01c2h         ;01b3 fa c2 01
    cp 'z'+1            ;01b6 fe 7b
    jp p,l01c2h         ;01b8 f2 c2 01
    ld hl,l3002h        ;01bb 21 02 30
    ld a,(hl)           ;01be 7e
    add a,0e0h          ;01bf c6 e0
    ld (hl),a           ;01c1 77
l01c2h:
    ld hl,l30a1h        ;01c2 21 a1 30
    ld (hl),00h         ;01c5 36 00
l01c7h:
    ld a,(l30a1h)       ;01c7 3a a1 30
    ld l,a              ;01ca 6f
    rla                 ;01cb 17
    sbc a,a             ;01cc 9f
    ld bc,l3020h        ;01cd 01 20 30
    ld h,a              ;01d0 67
    add hl,bc           ;01d1 09
    ld a,(hl)           ;01d2 7e
    cp '0'              ;01d3 fe 30
    jp m,l0218h         ;01d5 fa 18 02
    ld a,(l30a1h)       ;01d8 3a a1 30
    ld l,a              ;01db 6f
    rla                 ;01dc 17
    sbc a,a             ;01dd 9f
    ld bc,l3020h        ;01de 01 20 30
    ld h,a              ;01e1 67
    add hl,bc           ;01e2 09
    ld a,(hl)           ;01e3 7e
    cp '9'+1            ;01e4 fe 3a
    jp p,l0218h         ;01e6 f2 18 02
    ld hl,(l3004h)      ;01e9 2a 04 30
    ld b,h              ;01ec 44
    ld c,l              ;01ed 4d
    ld de,000ah         ;01ee 11 0a 00
    call sub_129ah      ;01f1 cd 9a 12
    ld a,(l30a1h)       ;01f4 3a a1 30
    ld l,a              ;01f7 6f
    rla                 ;01f8 17
    sbc a,a             ;01f9 9f
    ld bc,l3020h        ;01fa 01 20 30
    ld h,a              ;01fd 67
    add hl,bc           ;01fe 09
    ld a,(hl)           ;01ff 7e
    ld l,a              ;0200 6f
    rla                 ;0201 17
    sbc a,a             ;0202 9f
    ld bc,0ffd0h        ;0203 01 d0 ff
    ld h,a              ;0206 67
    add hl,bc           ;0207 09
    add hl,de           ;0208 19
    ld (l3004h),hl      ;0209 22 04 30
    ld hl,l30a1h        ;020c 21 a1 30
    inc (hl)            ;020f 34
    ld a,(hl)           ;0210 7e
    ld hl,l301fh        ;0211 21 1f 30
    cp (hl)             ;0214 be
    jp m,l01c7h         ;0215 fa c7 01
l0218h:
    ret                 ;0218 c9

print_char:
;Print character in C
    ld hl,l30a2h
    ld (hl),c
    ld c,cwrite
    ld a,(l30a2h)
    ld e,a
    call bdos
    ret

print_eol:
;Print end of line (CR+LF)
    ld c,cr
    call print_char
    ld c,lf
    call print_char
    ret

print_str:
;Print string at BC
    ld hl,l30a3h+1
    ld (hl),b
    dec hl
    ld (hl),c
    ld hl,(l30a3h)
    ld a,(hl)
    ld (l30a5h),a
l023fh:
    ld hl,(l30a3h)
    inc hl
    ld (l30a3h),hl
    ld hl,(l30a3h)
    ld c,(hl)
    call print_char
    ld hl,l30a5h
    dec (hl)
    ld a,(hl)
    or a
    jp nz,l023fh
    ret

sub_0257h:
    call sub_1382h      ;0257 cd 82 13
    db 00h, 02h
    dw l30a6h
    ld hl,l30a6h+1      ;025e 21 a7 30
    ld (hl),b           ;0261 70
    dec hl              ;0262 2b
    ld (hl),c           ;0263 71
    ld hl,(l30a6h)      ;0264 2a a6 30
    ld a,l              ;0267 7d
    or h                ;0268 b4
    jp z,l028ch         ;0269 ca 8c 02
    ld hl,(l30a6h)      ;026c 2a a6 30
    ld b,h              ;026f 44
    ld c,l              ;0270 4d
    ld de,10            ;0271 11 0a 00
    call sub_12f6h      ;0274 cd f6 12 (Library DIV)
    call sub_0257h      ;0277 cd 57 02
    ld hl,(l30a6h)      ;027a 2a a6 30
    ld b,h              ;027d 44
    ld c,l              ;027e 4d
    ld de,10            ;027f 11 0a 00
    call sub_12f6h      ;0282 cd f6 12 (Library DIV - HL=MOD)
    ld a,l              ;0285 7d
    add a,'0'           ;0286 c6 30
    ld c,a              ;0288 4f
    call print_char     ;0289 cd 19 02
l028ch:
    call sub_13c5h      ;028c cd c5 13
    db 02h
    dw l30a6h

print_int:
    ld hl,l30a8h+1      ;0292 21 a9 30
    ld (hl),b           ;0295 70
    dec hl              ;0296 2b
    ld (hl),c           ;0297 71
    ld hl,(l30a8h)      ;0298 2a a8 30
    ld a,l              ;029b 7d
    or h                ;029c b4
    jp nz,l02a9h        ;029d c2 a9 02

    ;PRINT "0"
    ld bc,l0b91h        ;02a0 01 91 0b
    call print_str      ;02a3 cd 32 02

    jp l02b1h           ;02a6 c3 b1 02

l02a9h:
    ld hl,(l30a8h)      ;02a9 2a a8 30
    ld b,h              ;02ac 44
    ld c,l              ;02ad 4d
    call sub_0257h      ;02ae cd 57 02
l02b1h:
    ret                 ;02b1 c9

l02b2h:
    ld hl,l30aah+1      ;02b2 21 ab 30
    ld (hl),b           ;02b5 70
    dec hl              ;02b6 2b
    ld (hl),c           ;02b7 71
    ld hl,(l30aah)      ;02b8 2a aa 30
    add hl,hl           ;02bb 29
    jp nc,l02d5h        ;02bc d2 d5 02

    ;PRINT "-"
    ld bc,l0b93h        ;02bf 01 93 0b
    call print_str      ;02c2 cd 32 02

    ;l30aah = -l30aah
    ld hl,(l30aah)      ;02c5 2a aa 30
    ld a,l              ;02c8 7d
    cpl                 ;02c9 2f
    add a,01h           ;02ca c6 01
    ld l,a              ;02cc 6f
    ld a,h              ;02cd 7c
    cpl                 ;02ce 2f
    adc a,00h           ;02cf ce 00
    ld h,a              ;02d1 67
    ld (l30aah),hl      ;02d2 22 aa 30

l02d5h:
    ;PRINT l30aah
    ld hl,(l30aah)      ;02d5 2a aa 30
    ld b,h              ;02d8 44
    ld c,l              ;02d9 4d
    call print_int      ;02da cd 92 02
    ret                 ;02dd c9

    ld hl,l30ach+1      ;02de 21 ad 30
    ld (hl),b           ;02e1 70
    dec hl              ;02e2 2b
    ld (hl),c           ;02e3 71
    inc hl              ;02e4 23
    inc hl              ;02e5 23
    ld (hl),01h         ;02e6 36 01
    jp l032bh           ;02e8 c3 2b 03
l02ebh:
    ld c,0ch            ;02eb 0e 0c
    ld hl,(l30ach)      ;02ed 2a ac 30
    jp l02fah           ;02f0 c3 fa 02

l02f3h:
    or a                ;02f3 b7
    ld a,h              ;02f4 7c
    rra                 ;02f5 1f
    ld h,a              ;02f6 67
    ld a,l              ;02f7 7d
    rra                 ;02f8 1f
    ld l,a              ;02f9 6f
l02fah:
    dec c               ;02fa 0d
    jp p,l02f3h         ;02fb f2 f3 02

    ld a,l              ;02fe 7d
    and 0fh             ;02ff e6 0f
    ld (l30afh),a       ;0301 32 af 30
    cp 10               ;0304 fe 0a
    jp m,l030eh         ;0306 fa 0e 03
    add a,'A'-10        ;0309 c6 37
    jp l0313h           ;030b c3 13 03

l030eh:
    ld a,(l30afh)       ;030e 3a af 30
    add a,'0'           ;0311 c6 30
l0313h:
    ld c,a              ;0313 4f
    call print_char     ;0314 cd 19 02
    ld c,04h            ;0317 0e 04
    ld hl,(l30ach)      ;0319 2a ac 30
    jp l0320h           ;031c c3 20 03

l031fh:
    add hl,hl           ;031f 29
l0320h:
    dec c               ;0320 0d
    jp p,l031fh         ;0321 f2 1f 03

    ld (l30ach),hl      ;0324 22 ac 30
    ld hl,l30aeh        ;0327 21 ae 30
    inc (hl)            ;032a 34
l032bh:
    ld a,(l30aeh)       ;032b 3a ae 30
    cp 05h              ;032e fe 05
    jp m,l02ebh         ;0330 fa eb 02
    ret                 ;0333 c9

start:
    ld hl,(0006h)       ;0334 2a 06 00
    ld sp,hl            ;0337 f9

ask_drv_type:
    ;PRINT CHR$(26); ' Clear screen
    ld c,1ah
    call print_char

    ;PRINT "HardBox configuration program"
    ld bc,l0b95h
    call print_str
    call print_eol

    ;PRINT "For Mini-Winchester"
    ld bc,l0bb3h
    call print_str
    call print_eol

    ;PRINT "--- ---------------"
    ld bc,l0bc7h
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Revision 2.1"
    ld bc,l0bdbh
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Drive sizes supported : "
    ld bc,l0be8h
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "A.   3  Mbyte      (191 cyl)"
    ld bc,l0c01h
    call print_str
    call print_eol

    ;PRINT "B.   6  Mbyte      (191 cyl)"
    ld bc,l0c1eh
    call print_str
    call print_eol

    ;PRINT "C.   12 Mbyte      (191 cyl)"
    ld bc,l0c3bh
    call print_str
    call print_eol

    ;PRINT "D.   5  Mbyte      (320 cyl)"
    ld bc,l0c58h
    call print_str
    call print_eol

    ;PRINT "E.   10 Mbyte      (320 cyl)"
    ld bc,l0c75h
    call print_str
    call print_eol

    ;PRINT "F.   15 Mbyte      (320 cyl)"
    ld bc,l0c92h
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Which drive type (A-F) ? ";
    ld bc,l0cafh
    call print_str

    ;GOSUB readline
    call readline

    ;IF l3002h <> &H41 THEN GOTO is_drv_type_b
    ld a,(l3002h)
    cp 'A'              ;Is it 'A': 3 Mbyte (191 cyl)?
    jp nz,is_drv_type_b ;  No: jump to check for 'B'

    ;REM User selected 'A' for 3 Mbyte (191 cyl)

    ;heads = 2
    ld hl,heads
    ld (hl),2

    ;cylinders = 191
    ld hl,191
    ld (cylinders),hl

    ;GOTO ask_hbox_conf
    jp ask_hbox_conf

is_drv_type_b:
    ;IF l3002h <> &H42 THEN GOTO is_drv_type_c
    ld a,(l3002h)
    cp 'B'              ;Is it 'B': 6 Mbyte (191 cyl)?
    jp nz,is_drv_type_c ;  No: jump to check for 'C'

    ;REM User selected 'B' for 6 Mbyte (191 cyl)

    ;heads = 4
    ld hl,heads
    ld (hl),4

    ;cylinders = 191
    ld hl,191
    ld (cylinders),hl

    ;GOTO ask_hbox_conf
    jp ask_hbox_conf

is_drv_type_c:
    ;IF l3002h <> &H43 THEN GOTO is_drv_type_d
    ld a,(l3002h)
    cp 'C'              ;Is it 'C': 12 Mbyte (191 cyl)?
    jp nz,is_drv_type_d ;  No: jump to check for 'D'

    ;REM User selected 'C' for 12 Mbyte (191 cyl)

    ;heads = 8
    ld hl,heads
    ld (hl),8

    ;cylinders = 191
    ld hl,191
    ld (cylinders),hl

    ;GOTO ask_hbox_conf
    jp ask_hbox_conf

is_drv_type_d:
    ;IF l3002h <> &H44 THEN GOTO is_drv_type_e
    ld a,(l3002h)
    cp 'D'              ;Is it 'D': 5 Mbyte (320 cyl)?
    jp nz,is_drv_type_e ;  No: jump to check for 'E'

    ;REM User selected 'D' for 5 Mbyte (320 cyl)

    ;heads = 2
    ld hl,heads
    ld (hl),2

    ;cylinders = 320
    ld hl,320
    ld (cylinders),hl

    ;GOTO ask_hbox_conf
    jp ask_hbox_conf

is_drv_type_e:
    ;IF l3002h <> &H45 THEN GOTO is_drv_type_f
    ld a,(l3002h)
    cp 'E'              ;Is it 'E': 10 Mbyte (320 cyl)?
    jp nz,is_drv_type_f ;  No: jump to check for 'F'

    ;REM User selected 'E' for 10 Mbyte (320 cyl)

    ;heads = 4
    ld hl,heads
    ld (hl),4

    ;cylinders = 320
    ld hl,320
    ld (cylinders),hl

    ;GOTO ask_hbox_conf
    jp ask_hbox_conf

is_drv_type_f:
    ;IF l3002h <> &H46 THEN GOTO bad_drv_type
    ld a,(l3002h)
    cp 'F'              ;Is it 'F': 15 Mbyte (320 cyl)?
    jp nz,bad_drv_type  ;  No: bad drive type entered

    ;REM User selected 'F' for 15 Mbyte (320 cyl)

    ;heads = 6
    ld hl,heads
    ld (hl),6

    ;cylinders = 320
    ld hl,320
    ld (cylinders),hl

    ;GOTO ask_hbox_conf
    jp ask_hbox_conf

bad_drv_type:
    ;GOTO ask_drv_type
    jp ask_drv_type

ask_hbox_conf:
    ;PRINT
    call print_eol

    ;PRINT "Configure entire drive as HardBox"
    ld bc,l0cc9h
    call print_str
    call print_eol

    ;PRINT "or just the last half (E/H) ? "
    ld bc,l0cebh
    call print_str

    ;GOSUB readline
    call readline

    ;IF l3002h <> &H48 THEN GOTO not_half_hbox
    ld a,(l3002h)
    cp 'H'              ;Is it 'H': use last half only for HardBox?
    jp nz,not_half_hbox ;  No: jump to not_half_hbox

    ;REM User selected 'H' for use last half for HardBox

    ;l3003h = 1
    ld hl,l3003h        ;045f 21 03 30
    ld (hl),01h         ;0462 36 01

    ;l4034h = (cylinders / 2) + 1
    ld hl,(cylinders)   ;0464 2a 06 30
    ld b,h              ;0467 44
    ld c,l              ;0468 4d
    ld de,0002h         ;0469 11 02 00
    call sub_12f6h      ;046c cd f6 12 (Library DIV)
    inc bc              ;046f 03
    ld h,b              ;0470 60
    ld l,c              ;0471 69
    ld (l4034h),hl      ;0472 22 34 40

    ;GOTO got_hbox_conf
    jp got_hbox_conf

not_half_hbox:
    ;IF l3002h <> &H45 THEN GOTO bad_hbox_conf
    ld a,(l3002h)
    cp 'E'              ;Is it 'E': use entire drive for HardBox?
    jp nz,bad_hbox_conf ;  No: jump to bad_hbox_conf

    ;REM User selected 'E' for use entire drive for HardBox

    ;l3003h = 0
    ld hl,l3003h        ;0480 21 03 30
    ld (hl),00h         ;0483 36 00

    ;l4034h = 1
    ld hl,0001h         ;0485 21 01 00
    ld (l4034h),hl      ;0488 22 34 40

    ;GOTO got_hbox_conf
    jp got_hbox_conf    ;048b c3 97 04

bad_hbox_conf:
    ;PRINT "Please answer E or H : "
    ld bc,l0d0ah
    call print_str

    ;GOTO ask_hbox_conf
    jp ask_hbox_conf

got_hbox_conf:
    ;l4007h = heads*(cylinders-l4034h)*8
    ld a,(heads)        ;0497 3a 01 30
    ld l,a              ;049a 6f
    rla                 ;049b 17
    sbc a,a             ;049c 9f
    ex de,hl            ;049d eb
    ld hl,(cylinders)   ;049e 2a 06 30
    ld d,a              ;04a1 57
    ld a,l              ;04a2 7d
    ld b,h              ;04a3 44
    ld hl,(l4034h)      ;04a4 2a 34 40
    sub l               ;04a7 95
    ld c,a              ;04a8 4f
    ld a,b              ;04a9 78
    sbc a,h             ;04aa 9c
    ld b,d              ;04ab 42
    ld d,c              ;04ac 51
    ld c,e              ;04ad 4b
    ld h,d              ;04ae 62
    ld d,a              ;04af 57
    ld e,h              ;04b0 5c
    call sub_129ah      ;04b1 cd 9a 12
    ex de,hl            ;04b4 eb
    add hl,hl           ;04b5 29
    add hl,hl           ;04b6 29
    add hl,hl           ;04b7 29
    ld (l4007h),hl      ;04b8 22 07 40

ask_direct:
    ;PRINT
    call print_eol      ;04bb cd 27 02

    ;PRINT "Do you wish to use the direct access"
    ld bc,l0d22h
    call print_str
    call print_eol

    ;PRINT "commands B-W, B-R, U1, U2 etc. (Y/N) ? "
    ld bc,l0d47h
    call print_str

    ;GOSUB readline
    call readline

    ;l400ch = 0 : l4010h = 0 : l400eh = 0
    ld hl,0000h         ;04d0 21 00 00
    ld (l400ch),hl      ;direct access size = 0
    ld (l4010h),hl      ;sectors per track = 0
    ld (l400eh),hl      ;tracks per drive = 0

    ;IF l3002h <> &H4E THEN GOTO l04f0h
    ld a,(l3002h)
    cp 'N'
    jp nz,l04f0h

    ;REM User selected 'N' for no direct access

    ld (l400ch),hl      ;04e4 22 0c 40
    ld (l4010h),hl      ;04e7 22 10 40
    ld (l400eh),hl      ;04ea 22 0e 40

    ;GOTO l05dfh
    jp l05dfh

l04f0h:
    ;IF l3002h <> &H59 THEN GOTO l05d6h
    ld a,(l3002h)
    cp 'Y'
    jp nz,l05d6h

    ;REM User selected 'Y' for use direct access

l04f8h:
    ;PRINT CHR$(26)
    ld c,1ah
    call print_char

    ;PRINT "Any number of kilobytes from zero to"
    ld bc,l0d6fh
    call print_str
    call print_eol

    ;PRINT l4007h-10;"may be reserved for direct access"
    ld bc,0fff6h        ;0506 01 f6 ff
    ld hl,(l4007h)      ;0509 2a 07 40
    add hl,bc           ;050c 09
    ld b,h              ;050d 44
    ld c,l              ;050e 4d
    call print_int      ;050f cd 92 02
    ld bc,l0d94h
    call print_str
    call print_eol

    ;PRINT "rather than sequential files."
    ld bc,l0db6h
    call print_str
    call print_eol

    ;PRINT "Alternatively for emulation of twin 8050"
    ld bc,l0dd4h
    call print_str
    call print_eol

    ;PRINT "floppies you may enter an 'E'."
    ld bc,l0dfdh
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Amount of space to reserve for direct"
    ld bc,l0e1ch
    call print_str
    call print_eol

    ;PRINT "access commands (in kilobytes) ? ";
    ld bc,l0e42h
    call print_str

    ;GOSUB readline
    call readline

    ;IF l3002h <> &H45 THEN GOTO l0568h
    ld a,(l3002h)
    cp 'E'
    jp nz,l0568h

    ;REM User selected 'E' for 8050 emulation

    ;l400ch = 1117 : l4010h = 29 : l400eh = 77
    ld hl,1117
    ld (l400ch),hl      ;direct access size = 1117

    ld hl,29
    ld (l4010h),hl      ;sectors per track = 29

    ld hl,77
    ld (l400eh),hl      ;tracks per drive = 77

    ;GOTO l05d3h
    jp l05d3h

l0568h:
    ;REM User did not select 8050 emulation

    ;l400ch = l3004h
    ld hl,(l3004h)      ;0568 2a 04 30
    ld (l400ch),hl      ;056b 22 0c 40

    ;IF &H400C = 0 THEN GOTO l04f8h
    ld hl,(l400ch)
    ld a,l
    or h
    jp z,l04f8h

    ;PRINT "You now need to specify the number of"
    ld bc,l0e64h
    call print_str
    call print_eol

    ;PRINT "apparent sectors per track and tracks"
    ld bc,l0e8ah
    call print_str
    call print_eol

    ;PRINT "per drive when using direct access : "
    ld bc,l0eb0h
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "For example to emulate an 8050 unit :"
    ld bc,l0ed6h
    call print_str
    call print_eol

    ;PRINT "   sectors per track = 29"
    ld bc,l0efch
    call print_str
    call print_eol

    ;PRINT "   tracks per drive = 77"
    ld bc,l0f16h
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Number of sectors per track ? ";
    ld bc,l0f2fh
    call print_str

    ;GOSUB readline
    call readline

    ;l4010h = l3004h
    ld hl,(l3004h)      ;05bb 2a 04 30
    ld (l4010h),hl      ;05be 22 10 40

    ;PRINT
    call print_eol

    ;PRINT "Number of tracks per drive ? ";
    ld bc,l0f4eh
    call print_str

    ;GOSUB readline
    call readline

    ;l400eh = l3004h
    ld hl,(l3004h)      ;05cd 2a 04 30
    ld (l400eh),hl      ;05d0 22 0e 40

l05d3h:
    jp l05dfh           ;05d3 c3 df 05

l05d6h:
    ;PRINT "Please answer Y or N : "
    ld bc,l0f6ch
    call print_str

    ;GOTO ask_direct
    jp ask_direct

l05dfh:
    ;l301ah = heads * l4034h * 32
    ld a,(heads)        ;05df 3a 01 30
    ld l,a              ;05e2 6f
    rla                 ;05e3 17
    sbc a,a             ;05e4 9f
    push hl             ;05e5 e5
    ld hl,(l4034h)      ;05e6 2a 34 40
    ld b,h              ;05e9 44
    ld c,l              ;05ea 4d
    pop hl              ;05eb e1
    ld d,a              ;05ec 57
    ld e,l              ;05ed 5d
    call sub_129ah      ;05ee cd 9a 12
    ex de,hl            ;05f1 eb
    add hl,hl           ;05f2 29
    add hl,hl           ;05f3 29
    add hl,hl           ;05f4 29
    add hl,hl           ;05f5 29
    add hl,hl           ;05f6 29
    ld (l301ah),hl      ;05f7 22 1a 30

    ;l3008h = l4007h-l400ch
    ld hl,(l4007h)      ;05fa 2a 07 40
    ld a,l              ;05fd 7d
    ex de,hl            ;05fe eb
    ld hl,(l400ch)      ;05ff 2a 0c 40
    sub l               ;0602 95
    ld e,a              ;0603 5f
    ld a,d              ;0604 7a
    sbc a,h             ;0605 9c
    ld h,a              ;0606 67
    ld l,e              ;0607 6b
    ld (l3008h),hl      ;0608 22 08 30

    ;l400ah = l3008h / 5
    ld hl,(l3008h)      ;060b 2a 08 30
    ld b,h              ;060e 44
    ld c,l              ;060f 4d
    ld de,0005h         ;0610 11 05 00
    call sub_12f6h      ;0613 cd f6 12 (Library DIV)
    ld h,b              ;0616 60
    ld l,c              ;0617 69
    ld (l400ah),hl      ;0618 22 0a 40

    ;l4000h = 0c3h
    ld hl,l4000h        ;061b 21 00 40
    ld (hl),0c3h        ;061e 36 c3

    ;l4001h = 0200h
    ld hl,0200h         ;0620 21 00 02
    ld (l4001h),hl      ;0623 22 01 40

    ;l4003h = 1
    ld hl,l4003h        ;0626 21 03 40
    ld (hl),01h         ;0629 36 01

    ;l4004h = 0 ' Starting sector number (first 2 of 3 bytes)
    ld hl,0000h         ;062b 21 00 00
    ld (l4004h),hl      ;062e 22 04 40

    ;l4006h = 0  ' Starting sector number (last byte)
    ld hl,l4004h+2      ;0631 21 06 40
    ld (hl),00h         ;0634 36 00

    ;l4009h = 0
    inc hl              ;0636 23
    inc hl              ;0637 23
    inc hl              ;0638 23
    ld (hl),00h         ;0639 36 00

    ;l4010h+2 = 0
    ld hl,l4010h+2      ;063b 21 12 40
    ld (hl),00h         ;063e 36 00

    ld hl,l4023h        ;0640 21 23 40
    ld (hl),'H'         ;0643 36 48
    inc hl              ;0645 23
    ld (hl),'A'         ;0646 36 41
    inc hl              ;0648 23
    ld (hl),'R'         ;0649 36 52
    inc hl              ;064b 23
    ld (hl),'D'         ;064c 36 44
    inc hl              ;064e 23
    ld (hl),' '         ;064f 36 20
    inc hl              ;0651 23
    ld (hl),'D'         ;0652 36 44
    inc hl              ;0654 23
    ld (hl),'I'         ;0655 36 49
    inc hl              ;0657 23
    ld (hl),'S'         ;0658 36 53
    inc hl              ;065a 23
    ld (hl),'K'         ;065b 36 4b
    inc hl              ;065d 23
    ld (hl),' '         ;065e 36 20
    inc hl              ;0660 23
    ld (hl),' '         ;0661 36 20
    inc hl              ;0663 23
    ld (hl),' '         ;0664 36 20
    inc hl              ;0666 23
    ld (hl),' '         ;0667 36 20
    inc hl              ;0669 23
    ld (hl),' '         ;066a 36 20
    inc hl              ;066c 23
    ld (hl),' '         ;066d 36 20
    inc hl              ;066f 23
    ld (hl),' '         ;0670 36 20

    ;l4033 = heads - 1
    ld a,(heads)        ;0672 3a 01 30
    dec a               ;0675 3d
    ld (l4033h),a       ;0676 32 33 40

    ;POKE &H4036, 8 ' IEEE-488 primary address
    ld hl,l4036h
    ld (hl),08h

    ;PRINT CHR$(26);
    ld c,1ah
    call print_char

    ;PRINT "Logical specifications :"
    ld bc,l0f84h
    call print_str
    call print_eol

    ;PRINT "User area size :           ";l4007h;" Kbytes"
    ld bc,l0f9dh
    call print_str
    ld hl,(l4007h)      ;0692 2a 07 40
    ld b,h              ;0695 44
    ld c,l              ;0696 4d
    call print_int      ;0697 cd 92 02
    ld bc,l0fb9h
    call print_str
    call print_eol

    ;PRINT "Direct access size :       ";l400ch;" Kbytes"
    ld bc,l0fc1h
    call print_str
    ld hl,(l400ch)      ;06a9 2a 0c 40
    ld b,h              ;06ac 44
    ld c,l              ;06ad 4d
    call print_int      ;06ae cd 92 02
    ld bc,l0fddh
    call print_str
    call print_eol

    ;PRINT "Direct sectors per track : ";l4010h;
    ld bc,l0fe5h
    call print_str
    ld hl,(l4010h)       ;06c0 2a 10 40
    ld b,h              ;06c3 44
    ld c,l              ;06c4 4d
    call print_int      ;06c5 cd 92 02
    call print_eol      ;06c8 cd 27 02

    ;PRINT "Direct tracks per drive :  ";l400eh
    ld bc,l1001h        ;06cb 01 01 10
    call print_str      ;06ce cd 32 02
    ld hl,(l400eh)      ;06d1 2a 0e 40
    ld b,h              ;06d4 44
    ld c,l              ;06d5 4d
    call print_int      ;06d6 cd 92 02
    call print_eol

    ;PRINT "Max number of files :      ";l400ah
    ld bc,l101dh        ;06dc 01 1d 10
    call print_str      ;06df cd 32 02
    ld hl,(l400ah)      ;06e2 2a 0a 40
    ld b,h              ;06e5 44
    ld c,l              ;06e6 4d
    call print_int      ;06e7 cd 92 02
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Physical specifications :"
    ld bc,l1039h
    call print_str
    call print_eol

    ;PRINT "Sectors per track :        32"
    ld bc,l1053h
    call print_str
    call print_eol

    ;PRINT "Tracks per cylinder :      ";heads
    ld bc,l1071h
    call print_str
    ld a,(heads)        ;070b 3a 01 30
    ld l,a              ;070e 6f
    rla                 ;070f 17
    sbc a,a             ;0710 9f
    ld b,a              ;0711 47
    ld c,l              ;0712 4d
    call print_int      ;0713 cd 92 02
    call print_eol

    ;PRINT "Total cylinders on drive : ";cylinders
    ld bc,l108dh
    call print_str
    ld hl,(cylinders)   ;071f 2a 06 30
    ld b,h              ;0722 44
    ld c,l              ;0723 4d
    call print_int      ;0724 cd 92 02
    call print_eol

    ;PRINT "Total kbyte capacity :     ";heads*cylinders*8
    ld bc,l10a9h
    call print_str
    ld a,(heads)        ;0730 3a 01 30
    ld l,a              ;0733 6f
    rla                 ;0734 17
    sbc a,a             ;0735 9f
    push hl             ;0736 e5
    ld hl,(cylinders)   ;0737 2a 06 30
    ld b,h              ;073a 44
    ld c,l              ;073b 4d
    pop hl              ;073c e1
    ld d,a              ;073d 57
    ld e,l              ;073e 5d
    call sub_129ah      ;073f cd 9a 12
    ex de,hl            ;0742 eb
    add hl,hl           ;0743 29
    add hl,hl           ;0744 29
    add hl,hl           ;0745 29
    ld b,h              ;0746 44
    ld c,l              ;0747 4d
    call print_int      ;0748 cd 92 02
    call print_eol

    ;PRINT "First user cylinder :      ";l4034h
    ld bc,l10c5h
    call print_str
    ld hl,(l4034h)      ;0754 2a 34 40
    ld b,h              ;0757 44
    ld c,l              ;0758 4d
    call print_int      ;0759 cd 92 02
    call print_eol

    ;PRINT "Number of user cylinders : ";cylinders-l4034h
    ld bc,l10e1h
    call print_str
    ld hl,(cylinders)   ;0765 2a 06 30
    ld a,l              ;0768 7d
    ex de,hl            ;0769 eb
    ld hl,(l4034h)      ;076a 2a 34 40
    sub l               ;076d 95
    ld e,a              ;076e 5f
    ld a,d              ;076f 7a
    sbc a,h             ;0770 9c
    ld b,a              ;0771 47
    ld c,e              ;0772 4b
    call print_int      ;0773 cd 92 02
    call print_eol      ;0776 cd 27 02

    ;PRINT "User area starts at :      ";l301ah
    ld bc,l10fdh
    call print_str
    ld hl,(l301ah)      ;077f 2a 1a 30
    ld b,h              ;0782 44
    ld c,l              ;0783 4d
    call print_int      ;0784 cd 92 02
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "WARNING :  This command will destroy all"
    ld bc,l1119h
    call print_str
    call print_eol

    ;PRINT "data on the";
    ld bc,l1142h
    call print_str

    ;IF l3003h <> 1 THEN GOTO l07aah
    ld a,(l3003h)
    cp 01h
    jp nz,l07aah

    ;PRINT " second half of the"
    ld bc,l114eh
    call print_str

l07aah:
    ;PRINT " drive"
    ld bc,l1162h
    call print_str
    call print_eol

l07b3h:
    ;PRINT
    call print_eol

    ;PRINT "Continue (Y/N) ? ";
    ld bc,l1169h
    call print_str

    ;GOSUB readline
    call readline

    ;IF l3002h <> &H4E THEN GOTO l07cah
    ld a,(l3002h)
    cp 'N'
    jp nz,l07cah

    ;END
    call end

l07cah:
    ;IF l3002h <> &H59 THEN GOTO l07b3h
    ld a,(l3002h)
    cp 'Y'
    jp nz,l07b3h

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Writing new configuration data ..."
    ld bc,l117bh
    call print_str
    call print_eol

    ;REM Write absolute sector 32 with data at &H4000
    ;CALL mw_write(&H20,&H4000)
    ld de,0020h         ;07e1 11 20 00
    ld bc,4000h         ;07e4 01 00 40
    call mw_write       ;07e7 cd 00 12

    ;GOSUB check_error
    call check_error

    ;PRINT "Formatting directory ..."
    ld bc,l119eh
    call print_str
    call print_eol

    ld hl,0000h         ;07f6 21 00 00
    ld (l3016h),hl      ;07f9 22 16 30
    jp l08feh           ;07fc c3 fe 08

l07ffh:
    ld c,04h            ;07ff 0e 04
    ld hl,(l3016h)      ;0801 2a 16 30
    jp l0808h           ;0804 c3 08 08

l0807h:
    add hl,hl           ;0807 29
l0808h:
    dec c               ;0808 0d
    jp p,l0807h         ;0809 f2 07 08

    ld (l3018h),hl      ;080c 22 18 30

    ;POKE l3018h+&H7000,&H48 (???)
    ld bc,7000h         ;080f 01 00 70
    ld hl,(l3018h)      ;0812 2a 18 30
    add hl,bc           ;0815 09
    ld (hl),'H'         ;0816 36 48

    ;POKE l3018h+1+&H7000,&H41 (???)
    ld hl,(l3018h)      ;0818 2a 18 30
    inc hl              ;081b 23
    ld bc,7000h         ;081c 01 00 70
    add hl,bc           ;081f 09
    ld (hl),'A'         ;0820 36 41

    ;POKE l3018h+2+&H7000,&H52 (???)
    ld hl,(l3018h)      ;0822 2a 18 30
    inc hl              ;0825 23
    inc hl              ;0826 23
    ld bc,7000h         ;0827 01 00 70
    add hl,bc           ;082a 09
    ld (hl),'R'         ;082b 36 52

    ;POKE l3018h+3+&H7000,&H44 (???)
    ld hl,(l3018h)      ;082d 2a 18 30
    inc hl              ;0830 23
    inc hl              ;0831 23
    inc hl              ;0832 23
    ld bc,7000h         ;0833 01 00 70
    add hl,bc           ;0836 09
    ld (hl),'D'         ;0837 36 44

    ;POKE l3018h+4+&H7000,&H42 (???)
    ld bc,0004h         ;0839 01 04 00
    ld hl,(l3018h)      ;083c 2a 18 30
    add hl,bc           ;083f 09
    ld bc,7000h         ;0840 01 00 70
    add hl,bc           ;0843 09
    ld (hl),'B'         ;0844 36 42

    ;POKE l3018h+5+&H7000,&H4f (???)
    ld bc,0005h         ;0846 01 05 00
    ld hl,(l3018h)      ;0849 2a 18 30
    add hl,bc           ;084c 09
    ld bc,7000h         ;084d 01 00 70
    add hl,bc           ;0850 09
    ld (hl),'O'         ;0851 36 4f

    ;POKE l3018h+6+&H7000,&H58 (???)
    ld bc,0006h         ;0853 01 06 00
    ld hl,(l3018h)      ;0856 2a 18 30
    add hl,bc           ;0859 09
    ld bc,7000h         ;085a 01 00 70
    add hl,bc           ;085d 09
    ld (hl),'X'         ;085e 36 58

    ;POKE l3018h+7+&H7000,&H20 (???)
    ld bc,0007h         ;0860 01 07 00
    ld hl,(l3018h)      ;0863 2a 18 30
    add hl,bc           ;0866 09
    ld bc,7000h         ;0867 01 00 70
    add hl,bc           ;086a 09
    ld (hl),' '         ;086b 36 20

    ;POKE l3018h+8+&H7000,&H20 (???)
    ld bc,0008h         ;086d 01 08 00
    ld hl,(l3018h)      ;0870 2a 18 30
    add hl,bc           ;0873 09
    ld bc,7000h         ;0874 01 00 70
    add hl,bc           ;0877 09
    ld (hl),' '         ;0878 36 20

    ;POKE l3018h+9+&H7000,&H20 (???)
    ld bc,0009h         ;087a 01 09 00
    ld hl,(l3018h)      ;087d 2a 18 30
    add hl,bc           ;0880 09
    ld bc,7000h         ;0881 01 00 70
    add hl,bc           ;0884 09
    ld (hl),' '         ;0885 36 20

    ;POKE l3018h+10+&H7000,&H20 (???)
    ld bc,000ah         ;0887 01 0a 00
    ld hl,(l3018h)      ;088a 2a 18 30
    add hl,bc           ;088d 09
    ld bc,7000h         ;088e 01 00 70
    add hl,bc           ;0891 09
    ld (hl),' '         ;0892 36 20

    ;POKE l3018h+11+&H7000,&H20 (???)
    ld bc,000bh         ;0894 01 0b 00
    ld hl,(l3018h)      ;0897 2a 18 30
    add hl,bc           ;089a 09
    ld bc,7000h         ;089b 01 00 70
    add hl,bc           ;089e 09
    ld (hl),' '         ;089f 36 20

    ;POKE l3018h+12+&H7000,&H20 (???)
    ld bc,000ch         ;08a1 01 0c 00
    ld hl,(l3018h)      ;08a4 2a 18 30
    add hl,bc           ;08a7 09
    ld bc,7000h         ;08a8 01 00 70
    add hl,bc           ;08ab 09
    ld (hl),' '         ;08ac 36 20

    ;POKE l3018h+13+&H7000,&H20 (???)
    ld bc,000dh         ;08ae 01 0d 00
    ld hl,(l3018h)      ;08b1 2a 18 30
    add hl,bc           ;08b4 09
    ld bc,7000h         ;08b5 01 00 70
    add hl,bc           ;08b8 09
    ld (hl),' '         ;08b9 36 20

    ;POKE l3018h+14+&H7000,&H20 (???)
    ld bc,000eh         ;08bb 01 0e 00
    ld hl,(l3018h)      ;08be 2a 18 30
    add hl,bc           ;08c1 09
    ld bc,7000h         ;08c2 01 00 70
    add hl,bc           ;08c5 09
    ld (hl),' '         ;08c6 36 20

    ;POKE l3018h+15+&H7000,&H20 (???)
    ld bc,000fh         ;08c8 01 0f 00
    ld hl,(l3018h)      ;08cb 2a 18 30
    add hl,bc           ;08ce 09
    ld bc,7000h         ;08cf 01 00 70
    add hl,bc           ;08d2 09
    ld (hl),' '         ;08d3 36 20

    ;l3018h = l3016h * 2 + 160
    ld bc,00a0h         ;08d5 01 a0 00
    ld hl,(l3016h)      ;08d8 2a 16 30
    add hl,bc           ;08db 09
    ex de,hl            ;08dc eb
    ld hl,(l3016h)      ;08dd 2a 16 30
    add hl,de           ;08e0 19
    ld (l3018h),hl      ;08e1 22 18 30

    ;POKE l1318h+&H7000,&H4b
    ld bc,7000h         ;08e4 01 00 70
    ld hl,(l3018h)      ;08e7 2a 18 30
    add hl,bc           ;08ea 09
    ld (hl),'K'         ;08eb 36 4b

    ;POKE l1318h+1+&H7000,&H46
    ld hl,(l3018h)      ;08ed 2a 18 30
    inc hl              ;08f0 23
    ld bc,7000h         ;08f1 01 00 70
    add hl,bc           ;08f4 09
    ld (hl),'F'         ;08f5 36 46

    ;l3016h = l3016h + 1
    ld hl,(l3016h)      ;08f7 2a 16 30
    inc hl              ;08fa 23
    ld (l3016h),hl      ;08fb 22 16 30

l08feh:
    ld bc,-10           ;08fe 01 f6 ff
    ld hl,(l3016h)      ;0901 2a 16 30
    add hl,bc           ;0904 09
    add hl,hl           ;0905 29
    jp c,l07ffh         ;0906 da ff 07

    ;REM Write absolute sector l301ah with data at &H7000
    ;CALL mw_write(&H7000,l301ah)
    ld hl,(l301ah)      ;0909 2a 1a 30
    ex de,hl            ;090c eb
    ld bc,7000h         ;090d 01 00 70
    call mw_write       ;0910 cd 00 12

    ;GOSUB check_error
    call check_error

    ;l3016h = 0
    ld hl,0000h         ;0916 21 00 00
    ld (l3016h),hl      ;0919 22 16 30

    jp l092fh           ;091c c3 2f 09

l091fh:
    ;POKE l3016h+&H7000,&HE5
    ld bc,7000h         ;091f 01 00 70
    ld hl,(l3016h)      ;0922 2a 16 30
    add hl,bc           ;0925 09
    ld (hl),0e5h        ;0926 36 e5

    ;l3016h = l3016h + 1
    ld hl,(l3016h)      ;0928 2a 16 30
    inc hl              ;092b 23
    ld (l3016h),hl      ;092c 22 16 30

l092fh:
    ld bc,-256          ;092f 01 00 ff
    ld hl,(l3016h)      ;0932 2a 16 30
    add hl,bc           ;0935 09
    add hl,hl           ;0936 29
    jp c,l091fh         ;0937 da 1f 09

    ;l400ah = 2
    ld c,02h            ;093a 0e 02
    ld hl,(l400ah)      ;093c 2a 0a 40

    ;GOTO l0949h
    jp l0949h           ;093f c3 49 09

l0942h:
    or a                ;0942 b7
    ld a,h              ;0943 7c
    rra                 ;0944 1f
    ld h,a              ;0945 67
    ld a,l              ;0946 7d
    rra                 ;0947 1f
    ld l,a              ;0948 6f
l0949h:
    dec c               ;0949 0d
    jp p,l0942h         ;094a f2 42 09
    ld (l300ah),hl      ;094d 22 0a 30
    ld hl,0000h         ;0950 21 00 00
    ld (l3016h),hl      ;0953 22 16 30
    ld hl,(l300ah)      ;0956 2a 0a 30
    ld (l301ch),hl      ;0959 22 1c 30
    jp l0981h           ;095c c3 81 09

l095fh:
    ;REM Write absolute sector l3016h+l301ah+4 with data at &H7000
    ;CALL mw_write(&H7000,l3016h+l301ah+4)
    ld bc,4             ;095f 01 04 00
    ld hl,(l301ah)      ;0962 2a 1a 30
    add hl,bc           ;0965 09
    ex de,hl            ;0966 eb
    ld hl,(l3016h)      ;0967 2a 16 30
    add hl,de           ;096a 19
    ex de,hl            ;096b eb
    ld bc,7000h         ;096c 01 00 70
    call mw_write       ;096f cd 00 12

    ;GOSUB check_error
    call check_error

    ;PRINT ".";
    ld c,'.'            ;0975 0e 2e
    call print_char     ;0977 cd 19 02

    ;l3016h = l3016h + 1
    ld hl,(l3016h)      ;097a 2a 16 30
    inc hl              ;097d 23
    ld (l3016h),hl      ;097e 22 16 30

l0981h:
    ld hl,(l301ch)      ;0981 2a 1c 30
    ld a,l              ;0984 7d
    ex de,hl            ;0985 eb
    ld hl,(l3016h)      ;0986 2a 16 30
    sub l               ;0989 95
    ld a,d              ;098a 7a
    sbc a,h             ;098b 9c
    jp p,l095fh         ;098c f2 5f 09

    ld hl,(l400ch)      ;098f 2a 0c 40
    ld a,l              ;0992 7d
    or h                ;0993 b4
    jp z,l0aeah         ;0994 ca ea 0a

    ;PRINT "clearing direct access BAM ..."
    ld bc,l11b7h
    call print_str
    call print_eol

    ld hl,(l400ah)      ;09a0 2a 0a 40
    ld (l3012h),hl      ;09a3 22 12 30
    ld c,08h            ;09a6 0e 08
    ld hl,(l4007h)      ;09a8 2a 07 40
    jp l09b5h           ;09ab c3 b5 09
l09aeh:
    or a                ;09ae b7
    ld a,h              ;09af 7c
    rra                 ;09b0 1f
    ld h,a              ;09b1 67
    ld a,l              ;09b2 7d
    rra                 ;09b3 1f
    ld l,a              ;09b4 6f
l09b5h:
    dec c               ;09b5 0d
    jp p,l09aeh         ;09b6 f2 ae 09
    ex de,hl            ;09b9 eb
    ld hl,(l400ah)      ;09ba 2a 0a 40
    add hl,de           ;09bd 19
    ld (l3010h),hl      ;09be 22 10 30
    ld c,09h            ;09c1 0e 09
    ld hl,(l400ch)      ;09c3 2a 0c 40
    jp l09d0h           ;09c6 c3 d0 09
l09c9h:
    or a                ;09c9 b7
    ld a,h              ;09ca 7c
    rra                 ;09cb 1f
    ld h,a              ;09cc 67
    ld a,l              ;09cd 7d
    rra                 ;09ce 1f
    ld l,a              ;09cf 6f
l09d0h:
    dec c               ;09d0 0d
    jp p,l09c9h         ;09d1 f2 c9 09
    inc hl              ;09d4 23
    ld (l300ch),hl      ;09d5 22 0c 30
    ld c,05h            ;09d8 0e 05
    ld hl,(l400ah)      ;09da 2a 0a 40
    jp l09e7h           ;09dd c3 e7 09
l09e0h:
    or a                ;09e0 b7
    ld a,h              ;09e1 7c
    rra                 ;09e2 1f
    ld h,a              ;09e3 67
    ld a,l              ;09e4 7d
    rra                 ;09e5 1f
    ld l,a              ;09e6 6f
l09e7h:
    dec c               ;09e7 0d
    jp p,l09e0h         ;09e8 f2 e0 09
    ex de,hl            ;09eb eb
    ld hl,(l4007h)      ;09ec 2a 07 40
    ld a,l              ;09ef 7d
    sub e               ;09f0 93
    ld l,a              ;09f1 6f
    ld a,h              ;09f2 7c
    sbc a,d             ;09f3 9a
    ld c,03h            ;09f4 0e 03
    ex de,hl            ;09f6 eb
    ld hl,(l3012h)      ;09f7 2a 12 30
    ld d,a              ;09fa 57
    jp l0a05h           ;09fb c3 05 0a
l09feh:
    or a                ;09fe b7
    ld a,h              ;09ff 7c
    rra                 ;0a00 1f
    ld h,a              ;0a01 67
    ld a,l              ;0a02 7d
    rra                 ;0a03 1f
    ld l,a              ;0a04 6f
l0a05h:
    dec c               ;0a05 0d
    jp p,l09feh         ;0a06 f2 fe 09
    ld a,e              ;0a09 7b
    sub l               ;0a0a 95
    ld e,a              ;0a0b 5f
    ld a,d              ;0a0c 7a
    sbc a,h             ;0a0d 9c
    ld c,02h            ;0a0e 0e 02
    ld hl,(l3010h)      ;0a10 2a 10 30
    ld d,a              ;0a13 57
    jp l0a1eh           ;0a14 c3 1e 0a
l0a17h:
    or a                ;0a17 b7
    ld a,h              ;0a18 7c
    rra                 ;0a19 1f
    ld h,a              ;0a1a 67
    ld a,l              ;0a1b 7d
    rra                 ;0a1c 1f
    ld l,a              ;0a1d 6f
l0a1eh:
    dec c               ;0a1e 0d
    jp p,l0a17h         ;0a1f f2 17 0a
    ld a,e              ;0a22 7b
    sub l               ;0a23 95
    ld e,a              ;0a24 5f
    ld a,d              ;0a25 7a
    sbc a,h             ;0a26 9c
    ld d,a              ;0a27 57
    ld a,e              ;0a28 7b
    ld hl,(l400ch)      ;0a29 2a 0c 40
    sub l               ;0a2c 95
    ld e,a              ;0a2d 5f
    ld a,d              ;0a2e 7a
    sbc a,h             ;0a2f 9c
    ld d,a              ;0a30 57
    ld a,e              ;0a31 7b
    ld hl,(l300ch)      ;0a32 2a 0c 30
    sub l               ;0a35 95
    ld e,a              ;0a36 5f
    ld a,d              ;0a37 7a
    sbc a,h             ;0a38 9c
    ld bc,-4            ;0a39 01 fc ff
    ld h,a              ;0a3c 67
    ld l,e              ;0a3d 6b
    add hl,bc           ;0a3e 09
    or a                ;0a3f b7
    ld a,h              ;0a40 7c
    rra                 ;0a41 1f
    ld h,a              ;0a42 67
    ld a,l              ;0a43 7d
    rra                 ;0a44 1f
    ld l,a              ;0a45 6f
    ld (l3014h),hl      ;0a46 22 14 30
    ld bc,0004h         ;0a49 01 04 00
    ld hl,(l301ah)      ;0a4c 2a 1a 30
    add hl,bc           ;0a4f 09
    ld c,03h            ;0a50 0e 03
    ex de,hl            ;0a52 eb
    ld hl,(l400ah)      ;0a53 2a 0a 40
    jp l0a60h           ;0a56 c3 60 0a
l0a59h:
    or a                ;0a59 b7
    ld a,h              ;0a5a 7c
    rra                 ;0a5b 1f
    ld h,a              ;0a5c 67
    ld a,l              ;0a5d 7d
    rra                 ;0a5e 1f
    ld l,a              ;0a5f 6f
l0a60h:
    dec c               ;0a60 0d
    jp p,l0a59h         ;0a61 f2 59 0a
    inc hl              ;0a64 23
    add hl,de           ;0a65 19
    ex de,hl            ;0a66 eb
    ld hl,(l3012h)      ;0a67 2a 12 30
    or a                ;0a6a b7
    ld a,h              ;0a6b 7c
    rra                 ;0a6c 1f
    ld h,a              ;0a6d 67
    ld a,l              ;0a6e 7d
    rra                 ;0a6f 1f
    ld l,a              ;0a70 6f
    inc hl              ;0a71 23
    add hl,de           ;0a72 19
    ex de,hl            ;0a73 eb
    ld hl,(l3010h)      ;0a74 2a 10 30
    add hl,de           ;0a77 19
    ld c,03h            ;0a78 0e 03
    ex de,hl            ;0a7a eb
    ld hl,(l3014h)      ;0a7b 2a 14 30
    jp l0a82h           ;0a7e c3 82 0a
l0a81h:
    add hl,hl           ;0a81 29
l0a82h:
    dec c               ;0a82 0d
    jp p,l0a81h         ;0a83 f2 81 0a
    add hl,de           ;0a86 19
    ld (l300eh),hl      ;0a87 22 0e 30

    ;l3016h = 0
    ld hl,0000h         ;0a8a 21 00 00
    ld (l3016h),hl      ;0a8d 22 16 30

    ;GOTO l0aa3h
    jp l0aa3h           ;0a90 c3 a3 0a

l0a93h:
    ;POKE &H7000+l3016h, 0
    ld bc,7000h         ;0a93 01 00 70
    ld hl,(l3016h)      ;0a96 2a 16 30
    add hl,bc           ;0a99 09
    ld (hl),00h         ;0a9a 36 00

    ;l3016h = l3016h + 1
    ld hl,(l3016h)      ;0a9c 2a 16 30
    inc hl              ;0a9f 23
    ld (l3016h),hl      ;0aa0 22 16 30

l0aa3h:
    ld bc,-256          ;0aa3 01 00 ff
    ld hl,(l3016h)      ;0aa6 2a 16 30
    add hl,bc           ;0aa9 09
    add hl,hl           ;0aaa 29
    jp c,l0a93h         ;0aab da 93 0a

    ;l3016h = 0
    ld hl,0000h         ;0aae 21 00 00
    ld (l3016h),hl      ;0ab1 22 16 30

    ;l301ch = l300ch - 1
    ld hl,(l300ch)      ;0ab4 2a 0c 30
    dec hl              ;0ab7 2b
    ld (l301ch),hl      ;0ab8 22 1c 30

    ;GOTO l0adch
    jp l0adch           ;0abb c3 dc 0a

l0abeh:
    ;REM Write absolute sector l300eh+l3016h with data at &H7000
    ;CALL mw_write(&H7000,l300eh+l3016h)
    ld hl,(l3016h)      ;0abe 2a 16 30
    ex de,hl            ;0ac1 eb
    ld hl,(l300eh)      ;0ac2 2a 0e 30
    add hl,de           ;0ac5 19
    ex de,hl            ;0ac6 eb
    ld bc,7000h         ;0ac7 01 00 70
    call mw_write       ;0aca cd 00 12

    ;GOSUB check_error
    call check_error

    ;PRINT ".";
    ld c,'.'            ;0ad0 0e 2e
    call print_char     ;0ad2 cd 19 02

    ;l3016h = l3016h + 1
    ld hl,(l3016h)      ;0ad5 2a 16 30
    inc hl              ;0ad8 23
    ld (l3016h),hl      ;0ad9 22 16 30

l0adch:
    ld hl,(l301ch)      ;0adc 2a 1c 30
    ld a,l              ;0adf 7d
    ex de,hl            ;0ae0 eb
    ld hl,(l3016h)      ;0ae1 2a 16 30
    sub l               ;0ae4 95
    ld a,d              ;0ae5 7a
    sbc a,h             ;0ae6 9c
    jp p,l0abeh         ;0ae7 f2 be 0a

l0aeah:
    ;END
    call end

l0aedh:
    db 0dh
    db "DRIVE ERROR #"

l0afbh:
    db 17h
    db "40 - header write error"

l0b13h:
    db 16h
    db "42 - header read error"

l0b2ah:
    db 14h
    db "44 - data read error"

l0b3fh:
    db 10h
    db "46 - write fault"

l0b50h:
    db 13h
    db "47 - disk not ready"

l0b64h:
    db 14h
    db "49 - illegal command"

l0b79h:
    db 17h
    db "xx - unknown error code"

l0b91h:
    db 01h
    db "0"

l0b93h:
    db 01h
    db "-"

l0b95h:
    db 1dh
    db "HardBox configuration program"

l0bb3h:
    db 13h
    db "For Mini-Winchester"

l0bc7h:
    db 13h
    db "--- ---------------"

l0bdbh:
    db 0ch
    db "Revision 2.1"

l0be8h:
    db 18h
    db "Drive sizes supported : "

l0c01h:
    db 1ch
    db "A.   3  Mbyte      (191 cyl)"

l0c1eh:
    db 1ch
    db "B.   6  Mbyte      (191 cyl)"

l0c3bh:
    db 1ch
    db "C.   12 Mbyte      (191 cyl)"

l0c58h:
    db 1ch
    db "D.   5  Mbyte      (320 cyl)"

l0c75h:
    db 1ch
    db "E.   10 Mbyte      (320 cyl)"

l0c92h:
    db 1ch
    db "F.   15 Mbyte      (320 cyl)"

l0cafh:
    db 19h
    db "Which drive type (A-F) ? "

l0cc9h:
    db 21h
    db "Configure entire drive as HardBox"

l0cebh:
    db 1eh
    db "or just the last half (E/H) ? "

l0d0ah:
    db 17h
    db "Please answer E or H : "

l0d22h:
    db 24h
    db "Do you wish to use the direct access"

l0d47h:
    db 27h
    db "commands B-W, B-R, U1, U2 etc. (Y/N) ? "

l0d6fh:
    db 24h
    db "Any number of kilobytes from zero to"

l0d94h:
    db 21h
    db "may be reserved for direct access"

l0db6h:
    db 1dh
    db "rather than sequential files."

l0dd4h:
    db 28h
    db "Alternatively for emulation of twin 8050"

l0dfdh:
    db 1eh
    db "floppies you may enter an 'E'."

l0e1ch:
    db 25h
    db "Amount of space to reserve for direct"

l0e42h:
    db 21h
    db "access commands (in kilobytes) ? "

l0e64h:
    db 25h
    db "You now need to specify the number of"

l0e8ah:
    db 25h
    db "apparent sectors per track and tracks"

l0eb0h:
    db 25h
    db "per drive when using direct access : "

l0ed6h:
    db 25h
    db "For example to emulate an 8050 unit :"

l0efch:
    db 19h
    db "   sectors per track = 29"

l0f16h:
    db 18h
    db "   tracks per drive = 77"

l0f2fh:
    db 1eh
    db "Number of sectors per track ? "

l0f4eh:
    db 1dh
    db "Number of tracks per drive ? "

l0f6ch:
    db 17h
    db "Please answer Y or N : "

l0f84h:
    db 18h
    db "Logical specifications :"

l0f9dh:
    db 1bh
    db "User area size :           "

l0fb9h:
    db 07h
    db " Kbytes"

l0fc1h:
    db 1bh
    db "Direct access size :       "

l0fddh:
    db 07h
    db " Kbytes"

l0fe5h:
    db 1bh
    db "Direct sectors per track : "

l1001h:
    db 1bh
    db "Direct tracks per drive :  "

l101dh:
    db 1bh
    db "Max number of files :      "

l1039h:
    db 19h
    db "Physical specifications :"

l1053h:
    db 1dh
    db "Sectors per track :        32"

l1071h:
    db 1bh
    db "Tracks per cylinder :      "

l108dh:
    db 1bh
    db "Total cylinders on drive : "

l10a9h:
    db 1bh
    db "Total kbyte capacity :     "

l10c5h:
    db 1bh
    db "First user cylinder :      "

l10e1h:
    db 1bh
    db "Number of user cylinders : "

l10fdh:
    db 1bh
    db "User area starts at :      "

l1119h:
    db 28h
    db "WARNING :  This command will destroy all"

l1142h:
    db 0bh
    db "data on the"

l114eh:
    db 13h
    db " second half of the"

l1162h:
    db 06h
    db " drive"

l1169h:
    db 11h
    db "Continue (Y/N) ? "

l117bh:
    db 22h
    db "Writing new configuration data ..."

l119eh:
    db 18h
    db "Formatting directory ..."

l11b7h:
    db 1eh
    db "clearing direct access BAM ..."

; Start of Unknown Library ==================================================

mw_read:
;Read a sector from the Konan David Junior II controller.
;
; BC = buffer address
; DE = sector address
;
    xor a               ;High byte from sector address is zero
    ld (var_3),a
    ld (var_1),de       ;Store sector address

    ld h,b              ;Save buffer pointer
    ld l,c
    push hl

    ld a,21h            ;A = 21h (Read Disk)
    call mw_comout      ;Send command
    call mw_send_addr   ;Send disk/track/sector sequence

    call mw_status      ;Read status
    pop hl
    ret nz              ;Status not OK?  Return

    ld a,41h            ;A = 41h (Read Buffer)
    call mw_comout      ;Send command

                        ;Transfer 256 bytes from David Junior II:
    ld b,00h            ;  Seed loop index to count 256 bytes
l11f5h:
    in a,(corvus)       ;  Read data byte from David Junior II
    ld (hl),a           ;  Store it in our buffer
    inc hl              ;  Increment buffer pointer
    ex (sp),hl          ;  Delay
    ex (sp),hl          ;  Delay
    djnz l11f5h         ;  Decrement B, loop until B=0

    jp mw_status        ;Read David Junior II status.

mw_write:
;Write a sector to the Konan David Junior II controller.
;
; BC = buffer address
; DE = sector address
;
    xor a               ;High byte from sector address is zero
    ld (var_3),a
    ld (var_1),de       ;Store sector address

    ld h,b              ;Put buffer address to HL
    ld l,c

    ld a,42h            ;A = 42h (Write Buffer)
    call mw_comout      ;Send command

                        ;Transfer 256 bytes to David Junior II:
    ld b,00h            ;  Seed loop index to count 256 bytes
l1211h:
    ld a,(hl)           ;  Read data byte our buffer
    out (corvus),a      ;  Write it to the David Junior II
    inc hl              ;  Increment buffer pointer
    ex (sp),hl          ;  Delay
    ex (sp),hl          ;  Delay
    djnz l1211h         ;  Decrement B, loop until B=0

    call mw_status      ;Read David Junior II status.  Is it OK?
    ret nz              ;No: return

    ld a,22h            ;A = 22h (Write Disk)
    call mw_comout      ;Send command
    call mw_send_addr   ;Send disk/track/sector sequence
    jp mw_status        ;Read status

mw_comout:
;Send the command in A to the Konan David Junior II controller.
;
    ld b,a              ;Save command
    xor a
    out (corvus),a      ;Clear David Junior II port
mw_rdy1:
    in a,(corvus)
    cp 0a0h
    jr nz,mw_rdy1       ;Wait for David Junior II to go ready
    ld a,b              ;Recall command
    out (corvus),a      ;Send command
mw_rdy2:
    in a,(corvus)
    cp 0a1h
    jr nz,mw_rdy2       ;Wait until the David Junior II has it
    ld a,0ffh
    out (corvus),a      ;Send execute code
    ld b,14h
mw_rdy3:
    nop
    djnz mw_rdy3        ;Delay loop
    ret

mw_status:
;Get status from the Konan David Junior II, return it in A.
;
    ld a,0ffh
    out (corvus),a      ;Transfer done
l1249h:
    in a,(corvus)
    inc a
    jr nz,l1249h        ;Wait for David Junior II to get out
                        ;  of internal DMA mode
    ld a,0feh
    out (corvus),a      ;Signal that we are ready for status
l1252h:
    in a,(corvus)
    rla
    jr c,l1252h         ;Wait for status

    in a,(corvus)       ;Read status byte
    bit 6,a             ;Bit 6 of David Junior status is set if error
                        ;  Z = opposite of bit 6 (Z=1 if OK, Z=0 if error)
    push af             ;Save status byte
    xor a
    out (corvus),a      ;Clear the port to acknowledge receiving the status
    pop af              ;Recall status byte
    ret

mw_send_addr:
;Send an 8-byte address to the David Junior II controller.
;
    xor a
    out (corvus),a      ;Send byte 0: unit number (always 0)

    ld hl,(var_1)
    ld a,(var_3)
    ld b,05h
l126ch:
    rra
    rr h
    rr l
    djnz l126ch         ;Decrement B, loop until B=0

    ld a,(l4033h)
    ld b,a
    and l
    out (corvus),a      ;Send byte 1: Head number (0..7)
l127ah:
    srl h
    rr l
    srl b
    jr nz,l127ah
    ld a,l
    out (corvus),a      ;Send byte 2: Track low (0..FF)
    ld a,h
    out (corvus),a      ;Send byte 3: Track high (0 or 1)
    ld a,(var_1)
    and 1fh
    out (corvus),a      ;Send byte 4: Sector
    xor a
    out (corvus),a      ;Send byte 5: Reserved
    out (corvus),a      ;Send byte 6: Reserved
    out (corvus),a      ;Send byte 7: Reserved
    ret

var_1:
    dw 0
var_3:
    db 0

; End of Unknown Library ====================================================

sub_129ah:              ;Library MUL
    xor a               ;129a af
    ld h,a              ;129b 67
    add a,b             ;129c 80
    jp m,l12a7h         ;129d fa a7 12
    or c                ;12a0 b1
    jp z,l12f2h         ;12a1 ca f2 12
    jp l12aeh           ;12a4 c3 ae 12

l12a7h:
    inc h               ;12a7 24
    cpl                 ;12a8 2f
    ld b,a              ;12a9 47
    ld a,c              ;12aa 79
    cpl                 ;12ab 2f
    ld c,a              ;12ac 4f
    inc bc              ;12ad 03
l12aeh:
    xor a               ;12ae af
    add a,d             ;12af 82
    jp m,l12bah         ;12b0 fa ba 12
    or e                ;12b3 b3
    jp z,l12f2h         ;12b4 ca f2 12
    jp l12c1h           ;12b7 c3 c1 12

l12bah:
    inc h               ;12ba 24
    cpl                 ;12bb 2f
    ld d,a              ;12bc 57
    ld a,e              ;12bd 7b
    cpl                 ;12be 2f
    ld e,a              ;12bf 5f
    inc de              ;12c0 13
l12c1h:
    push hl             ;12c1 e5
    ld a,c              ;12c2 79
    sub e               ;12c3 93
    ld a,b              ;12c4 78
    sbc a,d             ;12c5 9a
    jp p,l12ceh         ;12c6 f2 ce 12
    ld h,b              ;12c9 60
    ld l,c              ;12ca 69
    ex de,hl            ;12cb eb
    ld b,h              ;12cc 44
    ld c,l              ;12cd 4d
l12ceh:
    ld hl,0000h         ;12ce 21 00 00
    ex de,hl            ;12d1 eb
l12d2h:
    ld a,b              ;12d2 78
    or c                ;12d3 b1
    jp z,l12e7h         ;12d4 ca e7 12
    ld a,b              ;12d7 78
    rra                 ;12d8 1f
    ld b,a              ;12d9 47
    ld a,c              ;12da 79
    rra                 ;12db 1f
    ld c,a              ;12dc 4f
    jp nc,l12e3h        ;12dd d2 e3 12
    ex de,hl            ;12e0 eb
    add hl,de           ;12e1 19
    ex de,hl            ;12e2 eb
l12e3h:
    add hl,hl           ;12e3 29
    jp l12d2h           ;12e4 c3 d2 12

l12e7h:
    pop af              ;12e7 f1
    rra                 ;12e8 1f
    ret nc              ;12e9 d0
    ld a,d              ;12ea 7a
    cpl                 ;12eb 2f
    ld d,a              ;12ec 57
    ld a,e              ;12ed 7b
    cpl                 ;12ee 2f
    ld e,a              ;12ef 5f
    inc de              ;12f0 13
    ret                 ;12f1 c9
l12f2h:
    ld de,0000h         ;12f2 11 00 00
    ret                 ;12f5 c9

sub_12f6h:              ;Library BC=DIV / HL=MOD
    xor a               ;12f6 af
    ld h,b              ;12f7 60
    ld l,c              ;12f8 69
    ld b,a              ;12f9 47
    add a,d             ;12fa 82
    jp m,l1303h         ;12fb fa 03 13
    or e                ;12fe b3
    jp nz,l130bh        ;12ff c2 0b 13
    ret                 ;1302 c9

l1303h:
    inc b               ;1303 04
    ld a,d              ;1304 7a
    cpl                 ;1305 2f
    ld d,a              ;1306 57
    ld a,e              ;1307 7b
    cpl                 ;1308 2f
    ld e,a              ;1309 5f
    inc de              ;130a 13
l130bh:
    xor a               ;130b af
    add a,h             ;130c 84
    jp m,l1318h         ;130d fa 18 13
    or l                ;1310 b5
    jp nz,l1323h        ;1311 c2 23 13
    ld bc,0000h         ;1314 01 00 00
    ret                 ;1317 c9

l1318h:
    ld a,b              ;1318 78
    or 02h              ;1319 f6 02
    ld b,a              ;131b 47
    ld a,h              ;131c 7c
    cpl                 ;131d 2f
    ld h,a              ;131e 67
    ld a,l              ;131f 7d
    cpl                 ;1320 2f
    ld l,a              ;1321 6f
    inc hl              ;1322 23
l1323h:
    push bc             ;1323 c5
    ld a,01h            ;1324 3e 01
    push af             ;1326 f5
    ld bc,0000h         ;1327 01 00 00
    xor a               ;132a af
    add a,d             ;132b 82
    jp m,l133ch         ;132c fa 3c 13
    ex de,hl            ;132f eb
l1330h:
    pop af              ;1330 f1
    inc a               ;1331 3c
    push af             ;1332 f5
    add hl,hl           ;1333 29
    ld a,h              ;1334 7c
    cp 00h              ;1335 fe 00
    jp p,l1330h         ;1337 f2 30 13
    ex de,hl            ;133a eb
    xor a               ;133b af
l133ch:
    ld a,c              ;133c 79
    rla                 ;133d 17
    ld c,a              ;133e 4f
    ld a,b              ;133f 78
    rla                 ;1340 17
    ld b,a              ;1341 47
    ld a,l              ;1342 7d
    sub e               ;1343 93
    ld l,a              ;1344 6f
    ld a,h              ;1345 7c
    sbc a,d             ;1346 9a
    ld h,a              ;1347 67
    jp c,l134fh         ;1348 da 4f 13
    inc bc              ;134b 03
    jp l1350h           ;134c c3 50 13

l134fh:
    add hl,de           ;134f 19
l1350h:
    pop af              ;1350 f1
    dec a               ;1351 3d
    jp z,l1360h         ;1352 ca 60 13
    push af             ;1355 f5
    xor a               ;1356 af
    ld a,d              ;1357 7a
    rra                 ;1358 1f
    ld d,a              ;1359 57
    ld a,e              ;135a 7b
    rra                 ;135b 1f
    ld e,a              ;135c 5f
    jp l133ch           ;135d c3 3c 13

l1360h:
    xor a               ;1360 af
    ld a,d              ;1361 7a
    rra                 ;1362 1f
    ld d,a              ;1363 57
    ld a,e              ;1364 7b
    rra                 ;1365 1f
    ld e,a              ;1366 5f
    pop af              ;1367 f1
    push af             ;1368 f5
    rra                 ;1369 1f
    rra                 ;136a 1f
    jp nc,l1375h        ;136b d2 75 13
    ld a,h              ;136e 7c
    cpl                 ;136f 2f
    ld h,a              ;1370 67
    ld a,l              ;1371 7d
    cpl                 ;1372 2f
    ld l,a              ;1373 6f
    inc hl              ;1374 23
l1375h:
    pop af              ;1375 f1
    inc a               ;1376 3c
    rra                 ;1377 1f
    rra                 ;1378 1f
    ret nc              ;1379 d0
    ld a,b              ;137a 78
    cpl                 ;137b 2f
    ld b,a              ;137c 47
    ld a,c              ;137d 79
    cpl                 ;137e 2f
    ld c,a              ;137f 4f
    inc bc              ;1380 03
    ret                 ;1381 c9

sub_1382h:
    pop hl              ;1382 e1
    push bc             ;1383 c5
    push de             ;1384 d5
    ld a,08h            ;1385 3e 08
    add a,(hl)          ;1387 86
    ld e,a              ;1388 5f
    inc hl              ;1389 23
    xor a               ;138a af
    ld b,a              ;138b 47
    sub (hl)            ;138c 96
    jp z,l1391h         ;138d ca 91 13
    dec b               ;1390 05
l1391h:
    ld c,a              ;1391 4f
    ld a,e              ;1392 7b
    push hl             ;1393 e5
    ld hl,0000h         ;1394 21 00 00
    add hl,sp           ;1397 39
    ld d,h              ;1398 54
    ld e,l              ;1399 5d
    add hl,bc           ;139a 09
    ld sp,hl            ;139b f9
l139ch:
    or a                ;139c b7
    jp z,l13aah         ;139d ca aa 13
    ex de,hl            ;13a0 eb
    ld c,(hl)           ;13a1 4e
    ex de,hl            ;13a2 eb
    ld (hl),c           ;13a3 71
    inc hl              ;13a4 23
    inc de              ;13a5 13
    dec a               ;13a6 3d
    jp l139ch           ;13a7 c3 9c 13

l13aah:
    pop hl              ;13aa e1
    ld a,(hl)           ;13ab 7e
    inc hl              ;13ac 23
    ld c,(hl)           ;13ad 4e
    inc hl              ;13ae 23
    ld b,(hl)           ;13af 46
    inc hl              ;13b0 23
    push bc             ;13b1 c5
    ex (sp),hl          ;13b2 e3
l13b3h:
    or a                ;13b3 b7
    jp z,l13c1h         ;13b4 ca c1 13
    dec de              ;13b7 1b
    ld c,(hl)           ;13b8 4e
    ex de,hl            ;13b9 eb
    ld (hl),c           ;13ba 71
    ex de,hl            ;13bb eb
    inc hl              ;13bc 23
    dec a               ;13bd 3d
    jp l13b3h           ;13be c3 b3 13

l13c1h:
    pop hl              ;13c1 e1
    pop de              ;13c2 d1
    pop bc              ;13c3 c1
    jp (hl)             ;13c4 e9

sub_13c5h:
    ex (sp),hl          ;13c5 e3
    push af             ;13c6 f5
    ld a,(hl)           ;13c7 7e
    inc hl              ;13c8 23
    ld e,(hl)           ;13c9 5e
    inc hl              ;13ca 23
    ld d,(hl)           ;13cb 56
    ld hl,0006h         ;13cc 21 06 00
    ld b,h              ;13cf 44
    ld c,a              ;13d0 4f
    add hl,sp           ;13d1 39
    ex de,hl            ;13d2 eb
    add hl,bc           ;13d3 09
l13d4h:
    or a                ;13d4 b7
    jp z,l13e2h         ;13d5 ca e2 13
    dec hl              ;13d8 2b
    ex de,hl            ;13d9 eb
    ld c,(hl)           ;13da 4e
    ex de,hl            ;13db eb
    ld (hl),c           ;13dc 71
    inc de              ;13dd 13
    dec a               ;13de 3d
    jp l13d4h           ;13df c3 d4 13

l13e2h:
    ex de,hl            ;13e2 eb
    pop af              ;13e3 f1
    pop de              ;13e4 d1
    pop bc              ;13e5 c1
    ld sp,hl            ;13e6 f9
    push bc             ;13e7 c5
    ex de,hl            ;13e8 eb
    ret                 ;13e9 c9

    db 0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

l3000h:
    db 0
heads:
    db 0
l3002h:
    db 0
l3003h:
    db 0
l3004h:
    dw 0
cylinders:
    dw 0
l3008h:
    dw 0
l300ah:
    dw 0
l300ch:
    dw 0
l300eh:
    dw 0
l3010h:
    dw 0
l3012h:
    dw 0
l3014h:
    dw 0
l3016h:
    dw 0
l3018h:
    dw 0
l301ah:
    dw 0
l301ch:
    dw 0
l301eh:
    db 0
l301fh:
    db 0
l3020h:
    db 0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

l30a1h:
    db 0
l30a2h:
    db 0
l30a3h:
    dw 0
l30a5h:
    db 0
l30a6h:
    dw 0
l30a8h:
    dw 0
l30aah:
    dw 0
l30ach:
    dw 0
l30aeh:
    db 0
l30afh:
    db 0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
