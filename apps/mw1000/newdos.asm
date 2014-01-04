; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --output=newdos.asm newdos.com


l4000h: equ 4000h       ;opcode "jp" (1 Byte)
l4001h: equ 4001h       ;jump address (2 Bytes)

                        ;here starts the user area
l4003h: equ 4003h       ;Physical drive number (1 .. 4, 1 Byte)
l4004h: equ 4004h       ;Starting sector number on drive (An Absolute Sector Number, 3 Bytes)
l4007h: equ 4007h       ;User area size in kilobytes, there are 4 blocks (2 Bytes)
l4009h: equ 4009h       ;Type of user area (Single user or Multi-user) (1 Byte)
l400ah: equ 400ah       ;Maximum numbers of files allowed (2 Bytes)
l400ch: equ 400ch       ;direct access size (2 Bytes)
l400eh: equ 400eh       ;tracks per drive (2 Bytes)
l4010h: equ 4010h       ;sectors per track (3 Bytes)
l4023h: equ 4023h       ;user name (16 Bytes)

                        ;here starts the global area
l4033h: equ 4033h       ;Max. head number (1 Byte)
l4034h: equ 4034h       ;First cylinder number using for HardBox (2 Bytes)
l4036h: equ 4036h       ;IEEE-488 primary address (1 Byte)

    org 0100h

    jp start

end:
;Exit back to CP/M.
    jp 0000h            ;Jump to CP/M warm start
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
    ld c,0ah            ;018e 0e 0a
    call 0005h          ;0190 cd 05 00
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
    ld c,02h
    ld a,(l30a2h)
    ld e,a
    call 0005h
    ret

print_eol:
;Print end of line (CR+LF)
    ld c,0dh
    call print_char
    ld c,0ah
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
    ld de,000ah         ;0271 11 0a 00
    call sub_12f6h      ;0274 cd f6 12 (Library DIV)
    call sub_0257h      ;0277 cd 57 02
    ld hl,(l30a6h)      ;027a 2a a6 30
    ld b,h              ;027d 44
    ld c,l              ;027e 4d
    ld de,000ah         ;027f 11 0a 00
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

    ld hl,l30adh        ;02de 21 ad 30
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

    ;heads = 2
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

    ;REM User selected 'E' for 15 Mbyte (320 cyl)

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

    ;CALL mw_write(&H20,&H4000):CALL check_error
    ld de,0020h         ;07e1 11 20 00
    ld bc,4000h         ;07e4 01 00 40
    call mw_write       ;07e7 cd 00 12
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
    ld bc,0fff6h        ;08fe 01 f6 ff
    ld hl,(l3016h)      ;0901 2a 16 30
    add hl,bc           ;0904 09
    add hl,hl           ;0905 29
    jp c,l07ffh         ;0906 da ff 07

    ;CALL mw_write(&H7000,l301ah):CALL check_error
    ld hl,(l301ah)      ;0909 2a 1a 30
    ex de,hl            ;090c eb
    ld bc,7000h         ;090d 01 00 70
    call mw_write      ;0910 cd 00 12
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
    ld bc,0ff00h        ;092f 01 00 ff
    ld hl,(l3016h)      ;0932 2a 16 30
    add hl,bc           ;0935 09
    add hl,hl           ;0936 29
    jp c,l091fh         ;0937 da 1f 09
    ld c,02h            ;093a 0e 02
    ld hl,(l400ah)      ;093c 2a 0a 40
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
    ;CALL mw_write(&H7000,l3016h+l301ah+4):CALL check_error
    ld bc,0004h         ;095f 01 04 00
    ld hl,(l301ah)      ;0962 2a 1a 30
    add hl,bc           ;0965 09
    ex de,hl            ;0966 eb
    ld hl,(l3016h)      ;0967 2a 16 30
    add hl,de           ;096a 19
    ex de,hl            ;096b eb
    ld bc,7000h         ;096c 01 00 70
    call mw_write      ;096f cd 00 12
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
    ld bc,0fffch        ;0a39 01 fc ff
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
    ld hl,0000h         ;0a8a 21 00 00
    ld (l3016h),hl      ;0a8d 22 16 30
    jp l0aa3h           ;0a90 c3 a3 0a
l0a93h:
    ld bc,7000h         ;0a93 01 00 70
    ld hl,(l3016h)      ;0a96 2a 16 30
    add hl,bc           ;0a99 09
    ld (hl),00h         ;0a9a 36 00
    ld hl,(l3016h)      ;0a9c 2a 16 30
    inc hl              ;0a9f 23
    ld (l3016h),hl      ;0aa0 22 16 30
l0aa3h:
    ld bc,0ff00h        ;0aa3 01 00 ff
    ld hl,(l3016h)      ;0aa6 2a 16 30
    add hl,bc           ;0aa9 09
    add hl,hl           ;0aaa 29
    jp c,l0a93h         ;0aab da 93 0a
    ld hl,0000h         ;0aae 21 00 00
    ld (l3016h),hl      ;0ab1 22 16 30
    ld hl,(l300ch)      ;0ab4 2a 0c 30
    dec hl              ;0ab7 2b
    ld (l301ch),hl      ;0ab8 22 1c 30
    jp l0adch           ;0abb c3 dc 0a

l0abeh:
    ;CALL mw_write(&H7000,l300eh+l3016h):CALL check_error
    ld hl,(l3016h)      ;0abe 2a 16 30
    ex de,hl            ;0ac1 eb
    ld hl,(l300eh)      ;0ac2 2a 0e 30
    add hl,de           ;0ac5 19
    ex de,hl            ;0ac6 eb
    ld bc,7000h         ;0ac7 01 00 70
    call mw_write       ;0aca cd 00 12
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
    xor a               ;11d6 af
    ld (l1299h),a       ;11d7 32 99 12
    ld (l1297h),de      ;11da ed 53 97 12
    ld h,b              ;11de 60
    ld l,c              ;11df 69
    push hl             ;11e0 e5
    ld a,21h            ;11e1 3e 21
    call mw_sub_1228h   ;11e3 cd 28 12
    call mw_sub_1261h      ;11e6 cd 61 12
    call mw_sub_1245h   ;11e9 cd 45 12
    pop hl              ;11ec e1
    ret nz              ;11ed c0
    ld a,41h            ;11ee 3e 41
    call mw_sub_1228h   ;11f0 cd 28 12
    ld b,00h            ;11f3 06 00
l11f5h:
    in a,(18h)          ;11f5 db 18
    ld (hl),a           ;11f7 77
    inc hl              ;11f8 23
    ex (sp),hl          ;11f9 e3
    ex (sp),hl          ;11fa e3
    djnz l11f5h         ;11fb 10 f8
    jp mw_sub_1245h     ;11fd c3 45 12

mw_write:
    xor a               ;1200 af
    ld (l1299h),a       ;1201 32 99 12
    ld (l1297h),de      ;1204 ed 53 97 12
    ld h,b              ;1208 60
    ld l,c              ;1209 69
    ld a,42h            ;120a 3e 42
    call mw_sub_1228h   ;120c cd 28 12
    ld b,00h            ;120f 06 00
l1211h:
    ld a,(hl)           ;1211 7e
    out (18h),a         ;1212 d3 18
    inc hl              ;1214 23
    ex (sp),hl          ;1215 e3
    ex (sp),hl          ;1216 e3
    djnz l1211h         ;1217 10 f8
    call mw_sub_1245h   ;1219 cd 45 12
    ret nz              ;121c c0
    ld a,22h            ;121d 3e 22
    call mw_sub_1228h   ;121f cd 28 12
    call mw_sub_1261h      ;1222 cd 61 12
    jp mw_sub_1245h     ;1225 c3 45 12

mw_sub_1228h:
    ld b,a              ;1228 47
    xor a               ;1229 af
    out (18h),a         ;122a d3 18
l122ch:
    in a,(18h)          ;122c db 18
    cp 0a0h             ;122e fe a0
    jr nz,l122ch        ;1230 20 fa
    ld a,b              ;1232 78
    out (18h),a         ;1233 d3 18
l1235h:
    in a,(18h)          ;1235 db 18
    cp 0a1h             ;1237 fe a1
    jr nz,l1235h        ;1239 20 fa
    ld a,0ffh           ;123b 3e ff
    out (18h),a         ;123d d3 18
    ld b,14h            ;123f 06 14
l1241h:
    nop                 ;1241 00
    djnz l1241h         ;1242 10 fd
    ret                 ;1244 c9

mw_sub_1245h:
    ld a,0ffh           ;1245 3e ff
    out (18h),a         ;1247 d3 18
l1249h:
    in a,(18h)          ;1249 db 18
    inc a               ;124b 3c
    jr nz,l1249h        ;124c 20 fb
    ld a,0feh           ;124e 3e fe
    out (18h),a         ;1250 d3 18
l1252h:
    in a,(18h)          ;1252 db 18
    rla                 ;1254 17
    jr c,l1252h         ;1255 38 fb
    in a,(18h)          ;1257 db 18
    bit 6,a             ;1259 cb 77
    push af             ;125b f5
    xor a               ;125c af
    out (18h),a         ;125d d3 18
    pop af              ;125f f1
    ret                 ;1260 c9

mw_sub_1261h:
    xor a               ;1261 af
    out (18h),a         ;1262 d3 18
    ld hl,(l1297h)      ;1264 2a 97 12
    ld a,(l1299h)       ;1267 3a 99 12
    ld b,05h            ;126a 06 05
l126ch:
    rra                 ;126c 1f
    rr h                ;126d cb 1c
    rr l                ;126f cb 1d
    djnz l126ch         ;1271 10 f9
    ld a,(l4033h)       ;1273 3a 33 40
    ld b,a              ;1276 47
    and l               ;1277 a5
    out (18h),a         ;1278 d3 18
l127ah:
    srl h               ;127a cb 3c
    rr l                ;127c cb 1d
    srl b               ;127e cb 38
    jr nz,l127ah        ;1280 20 f8
    ld a,l              ;1282 7d
    out (18h),a         ;1283 d3 18
    ld a,h              ;1285 7c
    out (18h),a         ;1286 d3 18
    ld a,(l1297h)       ;1288 3a 97 12
    and 1fh             ;128b e6 1f
    out (18h),a         ;128d d3 18
    xor a               ;128f af
    out (18h),a         ;1290 d3 18
    out (18h),a         ;1292 d3 18
    out (18h),a         ;1294 d3 18
    ret                 ;1296 c9

l1297h:
    nop                 ;1297 00
    nop                 ;1298 00
l1299h:
    nop                 ;1299 00

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
    nop                 ;13ea 00
    nop                 ;13eb 00
    nop                 ;13ec 00
    nop                 ;13ed 00
    nop                 ;13ee 00
    nop                 ;13ef 00
    nop                 ;13f0 00
    nop                 ;13f1 00
    nop                 ;13f2 00
    nop                 ;13f3 00
    nop                 ;13f4 00
    nop                 ;13f5 00
    nop                 ;13f6 00
    nop                 ;13f7 00
    nop                 ;13f8 00
    nop                 ;13f9 00
    nop                 ;13fa 00
    nop                 ;13fb 00
    nop                 ;13fc 00
    nop                 ;13fd 00
    nop                 ;13fe 00
    nop                 ;13ff 00
    nop                 ;1400 00
    nop                 ;1401 00
    nop                 ;1402 00
    nop                 ;1403 00
    nop                 ;1404 00
    nop                 ;1405 00
    nop                 ;1406 00
    nop                 ;1407 00
    nop                 ;1408 00
    nop                 ;1409 00
    nop                 ;140a 00
    nop                 ;140b 00
    nop                 ;140c 00
    nop                 ;140d 00
    nop                 ;140e 00
    nop                 ;140f 00
    nop                 ;1410 00
    nop                 ;1411 00
    nop                 ;1412 00
    nop                 ;1413 00
    nop                 ;1414 00
    nop                 ;1415 00
    nop                 ;1416 00
    nop                 ;1417 00
    nop                 ;1418 00
    nop                 ;1419 00
    nop                 ;141a 00
    nop                 ;141b 00
    nop                 ;141c 00
    nop                 ;141d 00
    nop                 ;141e 00
    nop                 ;141f 00
    nop                 ;1420 00
    nop                 ;1421 00
    nop                 ;1422 00
    nop                 ;1423 00
    nop                 ;1424 00
    nop                 ;1425 00
    nop                 ;1426 00
    nop                 ;1427 00
    nop                 ;1428 00
    nop                 ;1429 00
    nop                 ;142a 00
    nop                 ;142b 00
    nop                 ;142c 00
    nop                 ;142d 00
    nop                 ;142e 00
    nop                 ;142f 00
    nop                 ;1430 00
    nop                 ;1431 00
    nop                 ;1432 00
    nop                 ;1433 00
    nop                 ;1434 00
    nop                 ;1435 00
    nop                 ;1436 00
    nop                 ;1437 00
    nop                 ;1438 00
    nop                 ;1439 00
    nop                 ;143a 00
    nop                 ;143b 00
    nop                 ;143c 00
    nop                 ;143d 00
    nop                 ;143e 00
    nop                 ;143f 00
    nop                 ;1440 00
    nop                 ;1441 00
    nop                 ;1442 00
    nop                 ;1443 00
    nop                 ;1444 00
    nop                 ;1445 00
    nop                 ;1446 00
    nop                 ;1447 00
    nop                 ;1448 00
    nop                 ;1449 00
    nop                 ;144a 00
    nop                 ;144b 00
    nop                 ;144c 00
    nop                 ;144d 00
    nop                 ;144e 00
    nop                 ;144f 00
    nop                 ;1450 00
    nop                 ;1451 00
    nop                 ;1452 00
    nop                 ;1453 00
    nop                 ;1454 00
    nop                 ;1455 00
    nop                 ;1456 00
    nop                 ;1457 00
    nop                 ;1458 00
    nop                 ;1459 00
    nop                 ;145a 00
    nop                 ;145b 00
    nop                 ;145c 00
    nop                 ;145d 00
    nop                 ;145e 00
    nop                 ;145f 00
    nop                 ;1460 00
    nop                 ;1461 00
    nop                 ;1462 00
    nop                 ;1463 00
    nop                 ;1464 00
    nop                 ;1465 00
    nop                 ;1466 00
    nop                 ;1467 00
    nop                 ;1468 00
    nop                 ;1469 00
    nop                 ;146a 00
    nop                 ;146b 00
    nop                 ;146c 00
    nop                 ;146d 00
    nop                 ;146e 00
    nop                 ;146f 00
    nop                 ;1470 00
    nop                 ;1471 00
    nop                 ;1472 00
    nop                 ;1473 00
    nop                 ;1474 00
    nop                 ;1475 00
    nop                 ;1476 00
    nop                 ;1477 00
    nop                 ;1478 00
    nop                 ;1479 00
    nop                 ;147a 00
    nop                 ;147b 00
    nop                 ;147c 00
    nop                 ;147d 00
    nop                 ;147e 00
    nop                 ;147f 00
    nop                 ;1480 00
    nop                 ;1481 00
    nop                 ;1482 00
    nop                 ;1483 00
    nop                 ;1484 00
    nop                 ;1485 00
    nop                 ;1486 00
    nop                 ;1487 00
    nop                 ;1488 00
    nop                 ;1489 00
    nop                 ;148a 00
    nop                 ;148b 00
    nop                 ;148c 00
    nop                 ;148d 00
    nop                 ;148e 00
    nop                 ;148f 00
    nop                 ;1490 00
    nop                 ;1491 00
    nop                 ;1492 00
    nop                 ;1493 00
    nop                 ;1494 00
    nop                 ;1495 00
    nop                 ;1496 00
    nop                 ;1497 00
    nop                 ;1498 00
    nop                 ;1499 00
    nop                 ;149a 00
    nop                 ;149b 00
    nop                 ;149c 00
    nop                 ;149d 00
    nop                 ;149e 00
    nop                 ;149f 00
    nop                 ;14a0 00
    nop                 ;14a1 00
    nop                 ;14a2 00
    nop                 ;14a3 00
    nop                 ;14a4 00
    nop                 ;14a5 00
    nop                 ;14a6 00
    nop                 ;14a7 00
    nop                 ;14a8 00
    nop                 ;14a9 00
    nop                 ;14aa 00
    nop                 ;14ab 00
    nop                 ;14ac 00
    nop                 ;14ad 00
    nop                 ;14ae 00
    nop                 ;14af 00
    nop                 ;14b0 00
    nop                 ;14b1 00
    nop                 ;14b2 00
    nop                 ;14b3 00
    nop                 ;14b4 00
    nop                 ;14b5 00
    nop                 ;14b6 00
    nop                 ;14b7 00
    nop                 ;14b8 00
    nop                 ;14b9 00
    nop                 ;14ba 00
    nop                 ;14bb 00
    nop                 ;14bc 00
    nop                 ;14bd 00
    nop                 ;14be 00
    nop                 ;14bf 00
    nop                 ;14c0 00
    nop                 ;14c1 00
    nop                 ;14c2 00
    nop                 ;14c3 00
    nop                 ;14c4 00
    nop                 ;14c5 00
    nop                 ;14c6 00
    nop                 ;14c7 00
    nop                 ;14c8 00
    nop                 ;14c9 00
    nop                 ;14ca 00
    nop                 ;14cb 00
    nop                 ;14cc 00
    nop                 ;14cd 00
    nop                 ;14ce 00
    nop                 ;14cf 00
    nop                 ;14d0 00
    nop                 ;14d1 00
    nop                 ;14d2 00
    nop                 ;14d3 00
    nop                 ;14d4 00
    nop                 ;14d5 00
    nop                 ;14d6 00
    nop                 ;14d7 00
    nop                 ;14d8 00
    nop                 ;14d9 00
    nop                 ;14da 00
    nop                 ;14db 00
    nop                 ;14dc 00
    nop                 ;14dd 00
    nop                 ;14de 00
    nop                 ;14df 00
    nop                 ;14e0 00
    nop                 ;14e1 00
    nop                 ;14e2 00
    nop                 ;14e3 00
    nop                 ;14e4 00
    nop                 ;14e5 00
    nop                 ;14e6 00
    nop                 ;14e7 00
    nop                 ;14e8 00
    nop                 ;14e9 00
    nop                 ;14ea 00
    nop                 ;14eb 00
    nop                 ;14ec 00
    nop                 ;14ed 00
    nop                 ;14ee 00
    nop                 ;14ef 00
    nop                 ;14f0 00
    nop                 ;14f1 00
    nop                 ;14f2 00
    nop                 ;14f3 00
    nop                 ;14f4 00
    nop                 ;14f5 00
    nop                 ;14f6 00
    nop                 ;14f7 00
    nop                 ;14f8 00
    nop                 ;14f9 00
    nop                 ;14fa 00
    nop                 ;14fb 00
    nop                 ;14fc 00
    nop                 ;14fd 00
    nop                 ;14fe 00
    nop                 ;14ff 00
    nop                 ;1500 00
    nop                 ;1501 00
    nop                 ;1502 00
    nop                 ;1503 00
    nop                 ;1504 00
    nop                 ;1505 00
    nop                 ;1506 00
    nop                 ;1507 00
    nop                 ;1508 00
    nop                 ;1509 00
    nop                 ;150a 00
    nop                 ;150b 00
    nop                 ;150c 00
    nop                 ;150d 00
    nop                 ;150e 00
    nop                 ;150f 00
    nop                 ;1510 00
    nop                 ;1511 00
    nop                 ;1512 00
    nop                 ;1513 00
    nop                 ;1514 00
    nop                 ;1515 00
    nop                 ;1516 00
    nop                 ;1517 00
    nop                 ;1518 00
    nop                 ;1519 00
    nop                 ;151a 00
    nop                 ;151b 00
    nop                 ;151c 00
    nop                 ;151d 00
    nop                 ;151e 00
    nop                 ;151f 00
    nop                 ;1520 00
    nop                 ;1521 00
    nop                 ;1522 00
    nop                 ;1523 00
    nop                 ;1524 00
    nop                 ;1525 00
    nop                 ;1526 00
    nop                 ;1527 00
    nop                 ;1528 00
    nop                 ;1529 00
    nop                 ;152a 00
    nop                 ;152b 00
    nop                 ;152c 00
    nop                 ;152d 00
    nop                 ;152e 00
    nop                 ;152f 00
    nop                 ;1530 00
    nop                 ;1531 00
    nop                 ;1532 00
    nop                 ;1533 00
    nop                 ;1534 00
    nop                 ;1535 00
    nop                 ;1536 00
    nop                 ;1537 00
    nop                 ;1538 00
    nop                 ;1539 00
    nop                 ;153a 00
    nop                 ;153b 00
    nop                 ;153c 00
    nop                 ;153d 00
    nop                 ;153e 00
    nop                 ;153f 00
    nop                 ;1540 00
    nop                 ;1541 00
    nop                 ;1542 00
    nop                 ;1543 00
    nop                 ;1544 00
    nop                 ;1545 00
    nop                 ;1546 00
    nop                 ;1547 00
    nop                 ;1548 00
    nop                 ;1549 00
    nop                 ;154a 00
    nop                 ;154b 00
    nop                 ;154c 00
    nop                 ;154d 00
    nop                 ;154e 00
    nop                 ;154f 00
    nop                 ;1550 00
    nop                 ;1551 00
    nop                 ;1552 00
    nop                 ;1553 00
    nop                 ;1554 00
    nop                 ;1555 00
    nop                 ;1556 00
    nop                 ;1557 00
    nop                 ;1558 00
    nop                 ;1559 00
    nop                 ;155a 00
    nop                 ;155b 00
    nop                 ;155c 00
    nop                 ;155d 00
    nop                 ;155e 00
    nop                 ;155f 00
    nop                 ;1560 00
    nop                 ;1561 00
    nop                 ;1562 00
    nop                 ;1563 00
    nop                 ;1564 00
    nop                 ;1565 00
    nop                 ;1566 00
    nop                 ;1567 00
    nop                 ;1568 00
    nop                 ;1569 00
    nop                 ;156a 00
    nop                 ;156b 00
    nop                 ;156c 00
    nop                 ;156d 00
    nop                 ;156e 00
    nop                 ;156f 00
    nop                 ;1570 00
    nop                 ;1571 00
    nop                 ;1572 00
    nop                 ;1573 00
    nop                 ;1574 00
    nop                 ;1575 00
    nop                 ;1576 00
    nop                 ;1577 00
    nop                 ;1578 00
    nop                 ;1579 00
    nop                 ;157a 00
    nop                 ;157b 00
    nop                 ;157c 00
    nop                 ;157d 00
    nop                 ;157e 00
    nop                 ;157f 00
    nop                 ;1580 00
    nop                 ;1581 00
    nop                 ;1582 00
    nop                 ;1583 00
    nop                 ;1584 00
    nop                 ;1585 00
    nop                 ;1586 00
    nop                 ;1587 00
    nop                 ;1588 00
    nop                 ;1589 00
    nop                 ;158a 00
    nop                 ;158b 00
    nop                 ;158c 00
    nop                 ;158d 00
    nop                 ;158e 00
    nop                 ;158f 00
    nop                 ;1590 00
    nop                 ;1591 00
    nop                 ;1592 00
    nop                 ;1593 00
    nop                 ;1594 00
    nop                 ;1595 00
    nop                 ;1596 00
    nop                 ;1597 00
    nop                 ;1598 00
    nop                 ;1599 00
    nop                 ;159a 00
    nop                 ;159b 00
    nop                 ;159c 00
    nop                 ;159d 00
    nop                 ;159e 00
    nop                 ;159f 00
    nop                 ;15a0 00
    nop                 ;15a1 00
    nop                 ;15a2 00
    nop                 ;15a3 00
    nop                 ;15a4 00
    nop                 ;15a5 00
    nop                 ;15a6 00
    nop                 ;15a7 00
    nop                 ;15a8 00
    nop                 ;15a9 00
    nop                 ;15aa 00
    nop                 ;15ab 00
    nop                 ;15ac 00
    nop                 ;15ad 00
    nop                 ;15ae 00
    nop                 ;15af 00
    nop                 ;15b0 00
    nop                 ;15b1 00
    nop                 ;15b2 00
    nop                 ;15b3 00
    nop                 ;15b4 00
    nop                 ;15b5 00
    nop                 ;15b6 00
    nop                 ;15b7 00
    nop                 ;15b8 00
    nop                 ;15b9 00
    nop                 ;15ba 00
    nop                 ;15bb 00
    nop                 ;15bc 00
    nop                 ;15bd 00
    nop                 ;15be 00
    nop                 ;15bf 00
    nop                 ;15c0 00
    nop                 ;15c1 00
    nop                 ;15c2 00
    nop                 ;15c3 00
    nop                 ;15c4 00
    nop                 ;15c5 00
    nop                 ;15c6 00
    nop                 ;15c7 00
    nop                 ;15c8 00
    nop                 ;15c9 00
    nop                 ;15ca 00
    nop                 ;15cb 00
    nop                 ;15cc 00
    nop                 ;15cd 00
    nop                 ;15ce 00
    nop                 ;15cf 00
    nop                 ;15d0 00
    nop                 ;15d1 00
    nop                 ;15d2 00
    nop                 ;15d3 00
    nop                 ;15d4 00
    nop                 ;15d5 00
    nop                 ;15d6 00
    nop                 ;15d7 00
    nop                 ;15d8 00
    nop                 ;15d9 00
    nop                 ;15da 00
    nop                 ;15db 00
    nop                 ;15dc 00
    nop                 ;15dd 00
    nop                 ;15de 00
    nop                 ;15df 00
    nop                 ;15e0 00
    nop                 ;15e1 00
    nop                 ;15e2 00
    nop                 ;15e3 00
    nop                 ;15e4 00
    nop                 ;15e5 00
    nop                 ;15e6 00
    nop                 ;15e7 00
    nop                 ;15e8 00
    nop                 ;15e9 00
    nop                 ;15ea 00
    nop                 ;15eb 00
    nop                 ;15ec 00
    nop                 ;15ed 00
    nop                 ;15ee 00
    nop                 ;15ef 00
    nop                 ;15f0 00
    nop                 ;15f1 00
    nop                 ;15f2 00
    nop                 ;15f3 00
    nop                 ;15f4 00
    nop                 ;15f5 00
    nop                 ;15f6 00
    nop                 ;15f7 00
    nop                 ;15f8 00
    nop                 ;15f9 00
    nop                 ;15fa 00
    nop                 ;15fb 00
    nop                 ;15fc 00
    nop                 ;15fd 00
    nop                 ;15fe 00
    nop                 ;15ff 00
    nop                 ;1600 00
    nop                 ;1601 00
    nop                 ;1602 00
    nop                 ;1603 00
    nop                 ;1604 00
    nop                 ;1605 00
    nop                 ;1606 00
    nop                 ;1607 00
    nop                 ;1608 00
    nop                 ;1609 00
    nop                 ;160a 00
    nop                 ;160b 00
    nop                 ;160c 00
    nop                 ;160d 00
    nop                 ;160e 00
    nop                 ;160f 00
    nop                 ;1610 00
    nop                 ;1611 00
    nop                 ;1612 00
    nop                 ;1613 00
    nop                 ;1614 00
    nop                 ;1615 00
    nop                 ;1616 00
    nop                 ;1617 00
    nop                 ;1618 00
    nop                 ;1619 00
    nop                 ;161a 00
    nop                 ;161b 00
    nop                 ;161c 00
    nop                 ;161d 00
    nop                 ;161e 00
    nop                 ;161f 00
    nop                 ;1620 00
    nop                 ;1621 00
    nop                 ;1622 00
    nop                 ;1623 00
    nop                 ;1624 00
    nop                 ;1625 00
    nop                 ;1626 00
    nop                 ;1627 00
    nop                 ;1628 00
    nop                 ;1629 00
    nop                 ;162a 00
    nop                 ;162b 00
    nop                 ;162c 00
    nop                 ;162d 00
    nop                 ;162e 00
    nop                 ;162f 00
    nop                 ;1630 00
    nop                 ;1631 00
    nop                 ;1632 00
    nop                 ;1633 00
    nop                 ;1634 00
    nop                 ;1635 00
    nop                 ;1636 00
    nop                 ;1637 00
    nop                 ;1638 00
    nop                 ;1639 00
    nop                 ;163a 00
    nop                 ;163b 00
    nop                 ;163c 00
    nop                 ;163d 00
    nop                 ;163e 00
    nop                 ;163f 00
    nop                 ;1640 00
    nop                 ;1641 00
    nop                 ;1642 00
    nop                 ;1643 00
    nop                 ;1644 00
    nop                 ;1645 00
    nop                 ;1646 00
    nop                 ;1647 00
    nop                 ;1648 00
    nop                 ;1649 00
    nop                 ;164a 00
    nop                 ;164b 00
    nop                 ;164c 00
    nop                 ;164d 00
    nop                 ;164e 00
    nop                 ;164f 00
    nop                 ;1650 00
    nop                 ;1651 00
    nop                 ;1652 00
    nop                 ;1653 00
    nop                 ;1654 00
    nop                 ;1655 00
    nop                 ;1656 00
    nop                 ;1657 00
    nop                 ;1658 00
    nop                 ;1659 00
    nop                 ;165a 00
    nop                 ;165b 00
    nop                 ;165c 00
    nop                 ;165d 00
    nop                 ;165e 00
    nop                 ;165f 00
    nop                 ;1660 00
    nop                 ;1661 00
    nop                 ;1662 00
    nop                 ;1663 00
    nop                 ;1664 00
    nop                 ;1665 00
    nop                 ;1666 00
    nop                 ;1667 00
    nop                 ;1668 00
    nop                 ;1669 00
    nop                 ;166a 00
    nop                 ;166b 00
    nop                 ;166c 00
    nop                 ;166d 00
    nop                 ;166e 00
    nop                 ;166f 00
    nop                 ;1670 00
    nop                 ;1671 00
    nop                 ;1672 00
    nop                 ;1673 00
    nop                 ;1674 00
    nop                 ;1675 00
    nop                 ;1676 00
    nop                 ;1677 00
    nop                 ;1678 00
    nop                 ;1679 00
    nop                 ;167a 00
    nop                 ;167b 00
    nop                 ;167c 00
    nop                 ;167d 00
    nop                 ;167e 00
    nop                 ;167f 00
    nop                 ;1680 00
    nop                 ;1681 00
    nop                 ;1682 00
    nop                 ;1683 00
    nop                 ;1684 00
    nop                 ;1685 00
    nop                 ;1686 00
    nop                 ;1687 00
    nop                 ;1688 00
    nop                 ;1689 00
    nop                 ;168a 00
    nop                 ;168b 00
    nop                 ;168c 00
    nop                 ;168d 00
    nop                 ;168e 00
    nop                 ;168f 00
    nop                 ;1690 00
    nop                 ;1691 00
    nop                 ;1692 00
    nop                 ;1693 00
    nop                 ;1694 00
    nop                 ;1695 00
    nop                 ;1696 00
    nop                 ;1697 00
    nop                 ;1698 00
    nop                 ;1699 00
    nop                 ;169a 00
    nop                 ;169b 00
    nop                 ;169c 00
    nop                 ;169d 00
    nop                 ;169e 00
    nop                 ;169f 00
    nop                 ;16a0 00
    nop                 ;16a1 00
    nop                 ;16a2 00
    nop                 ;16a3 00
    nop                 ;16a4 00
    nop                 ;16a5 00
    nop                 ;16a6 00
    nop                 ;16a7 00
    nop                 ;16a8 00
    nop                 ;16a9 00
    nop                 ;16aa 00
    nop                 ;16ab 00
    nop                 ;16ac 00
    nop                 ;16ad 00
    nop                 ;16ae 00
    nop                 ;16af 00
    nop                 ;16b0 00
    nop                 ;16b1 00
    nop                 ;16b2 00
    nop                 ;16b3 00
    nop                 ;16b4 00
    nop                 ;16b5 00
    nop                 ;16b6 00
    nop                 ;16b7 00
    nop                 ;16b8 00
    nop                 ;16b9 00
    nop                 ;16ba 00
    nop                 ;16bb 00
    nop                 ;16bc 00
    nop                 ;16bd 00
    nop                 ;16be 00
    nop                 ;16bf 00
    nop                 ;16c0 00
    nop                 ;16c1 00
    nop                 ;16c2 00
    nop                 ;16c3 00
    nop                 ;16c4 00
    nop                 ;16c5 00
    nop                 ;16c6 00
    nop                 ;16c7 00
    nop                 ;16c8 00
    nop                 ;16c9 00
    nop                 ;16ca 00
    nop                 ;16cb 00
    nop                 ;16cc 00
    nop                 ;16cd 00
    nop                 ;16ce 00
    nop                 ;16cf 00
    nop                 ;16d0 00
    nop                 ;16d1 00
    nop                 ;16d2 00
    nop                 ;16d3 00
    nop                 ;16d4 00
    nop                 ;16d5 00
    nop                 ;16d6 00
    nop                 ;16d7 00
    nop                 ;16d8 00
    nop                 ;16d9 00
    nop                 ;16da 00
    nop                 ;16db 00
    nop                 ;16dc 00
    nop                 ;16dd 00
    nop                 ;16de 00
    nop                 ;16df 00
    nop                 ;16e0 00
    nop                 ;16e1 00
    nop                 ;16e2 00
    nop                 ;16e3 00
    nop                 ;16e4 00
    nop                 ;16e5 00
    nop                 ;16e6 00
    nop                 ;16e7 00
    nop                 ;16e8 00
    nop                 ;16e9 00
    nop                 ;16ea 00
    nop                 ;16eb 00
    nop                 ;16ec 00
    nop                 ;16ed 00
    nop                 ;16ee 00
    nop                 ;16ef 00
    nop                 ;16f0 00
    nop                 ;16f1 00
    nop                 ;16f2 00
    nop                 ;16f3 00
    nop                 ;16f4 00
    nop                 ;16f5 00
    nop                 ;16f6 00
    nop                 ;16f7 00
    nop                 ;16f8 00
    nop                 ;16f9 00
    nop                 ;16fa 00
    nop                 ;16fb 00
    nop                 ;16fc 00
    nop                 ;16fd 00
    nop                 ;16fe 00
    nop                 ;16ff 00
    nop                 ;1700 00
    nop                 ;1701 00
    nop                 ;1702 00
    nop                 ;1703 00
    nop                 ;1704 00
    nop                 ;1705 00
    nop                 ;1706 00
    nop                 ;1707 00
    nop                 ;1708 00
    nop                 ;1709 00
    nop                 ;170a 00
    nop                 ;170b 00
    nop                 ;170c 00
    nop                 ;170d 00
    nop                 ;170e 00
    nop                 ;170f 00
    nop                 ;1710 00
    nop                 ;1711 00
    nop                 ;1712 00
    nop                 ;1713 00
    nop                 ;1714 00
    nop                 ;1715 00
    nop                 ;1716 00
    nop                 ;1717 00
    nop                 ;1718 00
    nop                 ;1719 00
    nop                 ;171a 00
    nop                 ;171b 00
    nop                 ;171c 00
    nop                 ;171d 00
    nop                 ;171e 00
    nop                 ;171f 00
    nop                 ;1720 00
    nop                 ;1721 00
    nop                 ;1722 00
    nop                 ;1723 00
    nop                 ;1724 00
    nop                 ;1725 00
    nop                 ;1726 00
    nop                 ;1727 00
    nop                 ;1728 00
    nop                 ;1729 00
    nop                 ;172a 00
    nop                 ;172b 00
    nop                 ;172c 00
    nop                 ;172d 00
    nop                 ;172e 00
    nop                 ;172f 00
    nop                 ;1730 00
    nop                 ;1731 00
    nop                 ;1732 00
    nop                 ;1733 00
    nop                 ;1734 00
    nop                 ;1735 00
    nop                 ;1736 00
    nop                 ;1737 00
    nop                 ;1738 00
    nop                 ;1739 00
    nop                 ;173a 00
    nop                 ;173b 00
    nop                 ;173c 00
    nop                 ;173d 00
    nop                 ;173e 00
    nop                 ;173f 00
    nop                 ;1740 00
    nop                 ;1741 00
    nop                 ;1742 00
    nop                 ;1743 00
    nop                 ;1744 00
    nop                 ;1745 00
    nop                 ;1746 00
    nop                 ;1747 00
    nop                 ;1748 00
    nop                 ;1749 00
    nop                 ;174a 00
    nop                 ;174b 00
    nop                 ;174c 00
    nop                 ;174d 00
    nop                 ;174e 00
    nop                 ;174f 00
    nop                 ;1750 00
    nop                 ;1751 00
    nop                 ;1752 00
    nop                 ;1753 00
    nop                 ;1754 00
    nop                 ;1755 00
    nop                 ;1756 00
    nop                 ;1757 00
    nop                 ;1758 00
    nop                 ;1759 00
    nop                 ;175a 00
    nop                 ;175b 00
    nop                 ;175c 00
    nop                 ;175d 00
    nop                 ;175e 00
    nop                 ;175f 00
    nop                 ;1760 00
    nop                 ;1761 00
    nop                 ;1762 00
    nop                 ;1763 00
    nop                 ;1764 00
    nop                 ;1765 00
    nop                 ;1766 00
    nop                 ;1767 00
    nop                 ;1768 00
    nop                 ;1769 00
    nop                 ;176a 00
    nop                 ;176b 00
    nop                 ;176c 00
    nop                 ;176d 00
    nop                 ;176e 00
    nop                 ;176f 00
    nop                 ;1770 00
    nop                 ;1771 00
    nop                 ;1772 00
    nop                 ;1773 00
    nop                 ;1774 00
    nop                 ;1775 00
    nop                 ;1776 00
    nop                 ;1777 00
    nop                 ;1778 00
    nop                 ;1779 00
    nop                 ;177a 00
    nop                 ;177b 00
    nop                 ;177c 00
    nop                 ;177d 00
    nop                 ;177e 00
    nop                 ;177f 00
    nop                 ;1780 00
    nop                 ;1781 00
    nop                 ;1782 00
    nop                 ;1783 00
    nop                 ;1784 00
    nop                 ;1785 00
    nop                 ;1786 00
    nop                 ;1787 00
    nop                 ;1788 00
    nop                 ;1789 00
    nop                 ;178a 00
    nop                 ;178b 00
    nop                 ;178c 00
    nop                 ;178d 00
    nop                 ;178e 00
    nop                 ;178f 00
    nop                 ;1790 00
    nop                 ;1791 00
    nop                 ;1792 00
    nop                 ;1793 00
    nop                 ;1794 00
    nop                 ;1795 00
    nop                 ;1796 00
    nop                 ;1797 00
    nop                 ;1798 00
    nop                 ;1799 00
    nop                 ;179a 00
    nop                 ;179b 00
    nop                 ;179c 00
    nop                 ;179d 00
    nop                 ;179e 00
    nop                 ;179f 00
    nop                 ;17a0 00
    nop                 ;17a1 00
    nop                 ;17a2 00
    nop                 ;17a3 00
    nop                 ;17a4 00
    nop                 ;17a5 00
    nop                 ;17a6 00
    nop                 ;17a7 00
    nop                 ;17a8 00
    nop                 ;17a9 00
    nop                 ;17aa 00
    nop                 ;17ab 00
    nop                 ;17ac 00
    nop                 ;17ad 00
    nop                 ;17ae 00
    nop                 ;17af 00
    nop                 ;17b0 00
    nop                 ;17b1 00
    nop                 ;17b2 00
    nop                 ;17b3 00
    nop                 ;17b4 00
    nop                 ;17b5 00
    nop                 ;17b6 00
    nop                 ;17b7 00
    nop                 ;17b8 00
    nop                 ;17b9 00
    nop                 ;17ba 00
    nop                 ;17bb 00
    nop                 ;17bc 00
    nop                 ;17bd 00
    nop                 ;17be 00
    nop                 ;17bf 00
    nop                 ;17c0 00
    nop                 ;17c1 00
    nop                 ;17c2 00
    nop                 ;17c3 00
    nop                 ;17c4 00
    nop                 ;17c5 00
    nop                 ;17c6 00
    nop                 ;17c7 00
    nop                 ;17c8 00
    nop                 ;17c9 00
    nop                 ;17ca 00
    nop                 ;17cb 00
    nop                 ;17cc 00
    nop                 ;17cd 00
    nop                 ;17ce 00
    nop                 ;17cf 00
    nop                 ;17d0 00
    nop                 ;17d1 00
    nop                 ;17d2 00
    nop                 ;17d3 00
    nop                 ;17d4 00
    nop                 ;17d5 00
    nop                 ;17d6 00
    nop                 ;17d7 00
    nop                 ;17d8 00
    nop                 ;17d9 00
    nop                 ;17da 00
    nop                 ;17db 00
    nop                 ;17dc 00
    nop                 ;17dd 00
    nop                 ;17de 00
    nop                 ;17df 00
    nop                 ;17e0 00
    nop                 ;17e1 00
    nop                 ;17e2 00
    nop                 ;17e3 00
    nop                 ;17e4 00
    nop                 ;17e5 00
    nop                 ;17e6 00
    nop                 ;17e7 00
    nop                 ;17e8 00
    nop                 ;17e9 00
    nop                 ;17ea 00
    nop                 ;17eb 00
    nop                 ;17ec 00
    nop                 ;17ed 00
    nop                 ;17ee 00
    nop                 ;17ef 00
    nop                 ;17f0 00
    nop                 ;17f1 00
    nop                 ;17f2 00
    nop                 ;17f3 00
    nop                 ;17f4 00
    nop                 ;17f5 00
    nop                 ;17f6 00
    nop                 ;17f7 00
    nop                 ;17f8 00
    nop                 ;17f9 00
    nop                 ;17fa 00
    nop                 ;17fb 00
    nop                 ;17fc 00
    nop                 ;17fd 00
    nop                 ;17fe 00
    nop                 ;17ff 00
    nop                 ;1800 00
    nop                 ;1801 00
    nop                 ;1802 00
    nop                 ;1803 00
    nop                 ;1804 00
    nop                 ;1805 00
    nop                 ;1806 00
    nop                 ;1807 00
    nop                 ;1808 00
    nop                 ;1809 00
    nop                 ;180a 00
    nop                 ;180b 00
    nop                 ;180c 00
    nop                 ;180d 00
    nop                 ;180e 00
    nop                 ;180f 00
    nop                 ;1810 00
    nop                 ;1811 00
    nop                 ;1812 00
    nop                 ;1813 00
    nop                 ;1814 00
    nop                 ;1815 00
    nop                 ;1816 00
    nop                 ;1817 00
    nop                 ;1818 00
    nop                 ;1819 00
    nop                 ;181a 00
    nop                 ;181b 00
    nop                 ;181c 00
    nop                 ;181d 00
    nop                 ;181e 00
    nop                 ;181f 00
    nop                 ;1820 00
    nop                 ;1821 00
    nop                 ;1822 00
    nop                 ;1823 00
    nop                 ;1824 00
    nop                 ;1825 00
    nop                 ;1826 00
    nop                 ;1827 00
    nop                 ;1828 00
    nop                 ;1829 00
    nop                 ;182a 00
    nop                 ;182b 00
    nop                 ;182c 00
    nop                 ;182d 00
    nop                 ;182e 00
    nop                 ;182f 00
    nop                 ;1830 00
    nop                 ;1831 00
    nop                 ;1832 00
    nop                 ;1833 00
    nop                 ;1834 00
    nop                 ;1835 00
    nop                 ;1836 00
    nop                 ;1837 00
    nop                 ;1838 00
    nop                 ;1839 00
    nop                 ;183a 00
    nop                 ;183b 00
    nop                 ;183c 00
    nop                 ;183d 00
    nop                 ;183e 00
    nop                 ;183f 00
    nop                 ;1840 00
    nop                 ;1841 00
    nop                 ;1842 00
    nop                 ;1843 00
    nop                 ;1844 00
    nop                 ;1845 00
    nop                 ;1846 00
    nop                 ;1847 00
    nop                 ;1848 00
    nop                 ;1849 00
    nop                 ;184a 00
    nop                 ;184b 00
    nop                 ;184c 00
    nop                 ;184d 00
    nop                 ;184e 00
    nop                 ;184f 00
    nop                 ;1850 00
    nop                 ;1851 00
    nop                 ;1852 00
    nop                 ;1853 00
    nop                 ;1854 00
    nop                 ;1855 00
    nop                 ;1856 00
    nop                 ;1857 00
    nop                 ;1858 00
    nop                 ;1859 00
    nop                 ;185a 00
    nop                 ;185b 00
    nop                 ;185c 00
    nop                 ;185d 00
    nop                 ;185e 00
    nop                 ;185f 00
    nop                 ;1860 00
    nop                 ;1861 00
    nop                 ;1862 00
    nop                 ;1863 00
    nop                 ;1864 00
    nop                 ;1865 00
    nop                 ;1866 00
    nop                 ;1867 00
    nop                 ;1868 00
    nop                 ;1869 00
    nop                 ;186a 00
    nop                 ;186b 00
    nop                 ;186c 00
    nop                 ;186d 00
    nop                 ;186e 00
    nop                 ;186f 00
    nop                 ;1870 00
    nop                 ;1871 00
    nop                 ;1872 00
    nop                 ;1873 00
    nop                 ;1874 00
    nop                 ;1875 00
    nop                 ;1876 00
    nop                 ;1877 00
    nop                 ;1878 00
    nop                 ;1879 00
    nop                 ;187a 00
    nop                 ;187b 00
    nop                 ;187c 00
    nop                 ;187d 00
    nop                 ;187e 00
    nop                 ;187f 00
    nop                 ;1880 00
    nop                 ;1881 00
    nop                 ;1882 00
    nop                 ;1883 00
    nop                 ;1884 00
    nop                 ;1885 00
    nop                 ;1886 00
    nop                 ;1887 00
    nop                 ;1888 00
    nop                 ;1889 00
    nop                 ;188a 00
    nop                 ;188b 00
    nop                 ;188c 00
    nop                 ;188d 00
    nop                 ;188e 00
    nop                 ;188f 00
    nop                 ;1890 00
    nop                 ;1891 00
    nop                 ;1892 00
    nop                 ;1893 00
    nop                 ;1894 00
    nop                 ;1895 00
    nop                 ;1896 00
    nop                 ;1897 00
    nop                 ;1898 00
    nop                 ;1899 00
    nop                 ;189a 00
    nop                 ;189b 00
    nop                 ;189c 00
    nop                 ;189d 00
    nop                 ;189e 00
    nop                 ;189f 00
    nop                 ;18a0 00
    nop                 ;18a1 00
    nop                 ;18a2 00
    nop                 ;18a3 00
    nop                 ;18a4 00
    nop                 ;18a5 00
    nop                 ;18a6 00
    nop                 ;18a7 00
    nop                 ;18a8 00
    nop                 ;18a9 00
    nop                 ;18aa 00
    nop                 ;18ab 00
    nop                 ;18ac 00
    nop                 ;18ad 00
    nop                 ;18ae 00
    nop                 ;18af 00
    nop                 ;18b0 00
    nop                 ;18b1 00
    nop                 ;18b2 00
    nop                 ;18b3 00
    nop                 ;18b4 00
    nop                 ;18b5 00
    nop                 ;18b6 00
    nop                 ;18b7 00
    nop                 ;18b8 00
    nop                 ;18b9 00
    nop                 ;18ba 00
    nop                 ;18bb 00
    nop                 ;18bc 00
    nop                 ;18bd 00
    nop                 ;18be 00
    nop                 ;18bf 00
    nop                 ;18c0 00
    nop                 ;18c1 00
    nop                 ;18c2 00
    nop                 ;18c3 00
    nop                 ;18c4 00
    nop                 ;18c5 00
    nop                 ;18c6 00
    nop                 ;18c7 00
    nop                 ;18c8 00
    nop                 ;18c9 00
    nop                 ;18ca 00
    nop                 ;18cb 00
    nop                 ;18cc 00
    nop                 ;18cd 00
    nop                 ;18ce 00
    nop                 ;18cf 00
    nop                 ;18d0 00
    nop                 ;18d1 00
    nop                 ;18d2 00
    nop                 ;18d3 00
    nop                 ;18d4 00
    nop                 ;18d5 00
    nop                 ;18d6 00
    nop                 ;18d7 00
    nop                 ;18d8 00
    nop                 ;18d9 00
    nop                 ;18da 00
    nop                 ;18db 00
    nop                 ;18dc 00
    nop                 ;18dd 00
    nop                 ;18de 00
    nop                 ;18df 00
    nop                 ;18e0 00
    nop                 ;18e1 00
    nop                 ;18e2 00
    nop                 ;18e3 00
    nop                 ;18e4 00
    nop                 ;18e5 00
    nop                 ;18e6 00
    nop                 ;18e7 00
    nop                 ;18e8 00
    nop                 ;18e9 00
    nop                 ;18ea 00
    nop                 ;18eb 00
    nop                 ;18ec 00
    nop                 ;18ed 00
    nop                 ;18ee 00
    nop                 ;18ef 00
    nop                 ;18f0 00
    nop                 ;18f1 00
    nop                 ;18f2 00
    nop                 ;18f3 00
    nop                 ;18f4 00
    nop                 ;18f5 00
    nop                 ;18f6 00
    nop                 ;18f7 00
    nop                 ;18f8 00
    nop                 ;18f9 00
    nop                 ;18fa 00
    nop                 ;18fb 00
    nop                 ;18fc 00
    nop                 ;18fd 00
    nop                 ;18fe 00
    nop                 ;18ff 00
    nop                 ;1900 00
    nop                 ;1901 00
    nop                 ;1902 00
    nop                 ;1903 00
    nop                 ;1904 00
    nop                 ;1905 00
    nop                 ;1906 00
    nop                 ;1907 00
    nop                 ;1908 00
    nop                 ;1909 00
    nop                 ;190a 00
    nop                 ;190b 00
    nop                 ;190c 00
    nop                 ;190d 00
    nop                 ;190e 00
    nop                 ;190f 00
    nop                 ;1910 00
    nop                 ;1911 00
    nop                 ;1912 00
    nop                 ;1913 00
    nop                 ;1914 00
    nop                 ;1915 00
    nop                 ;1916 00
    nop                 ;1917 00
    nop                 ;1918 00
    nop                 ;1919 00
    nop                 ;191a 00
    nop                 ;191b 00
    nop                 ;191c 00
    nop                 ;191d 00
    nop                 ;191e 00
    nop                 ;191f 00
    nop                 ;1920 00
    nop                 ;1921 00
    nop                 ;1922 00
    nop                 ;1923 00
    nop                 ;1924 00
    nop                 ;1925 00
    nop                 ;1926 00
    nop                 ;1927 00
    nop                 ;1928 00
    nop                 ;1929 00
    nop                 ;192a 00
    nop                 ;192b 00
    nop                 ;192c 00
    nop                 ;192d 00
    nop                 ;192e 00
    nop                 ;192f 00
    nop                 ;1930 00
    nop                 ;1931 00
    nop                 ;1932 00
    nop                 ;1933 00
    nop                 ;1934 00
    nop                 ;1935 00
    nop                 ;1936 00
    nop                 ;1937 00
    nop                 ;1938 00
    nop                 ;1939 00
    nop                 ;193a 00
    nop                 ;193b 00
    nop                 ;193c 00
    nop                 ;193d 00
    nop                 ;193e 00
    nop                 ;193f 00
    nop                 ;1940 00
    nop                 ;1941 00
    nop                 ;1942 00
    nop                 ;1943 00
    nop                 ;1944 00
    nop                 ;1945 00
    nop                 ;1946 00
    nop                 ;1947 00
    nop                 ;1948 00
    nop                 ;1949 00
    nop                 ;194a 00
    nop                 ;194b 00
    nop                 ;194c 00
    nop                 ;194d 00
    nop                 ;194e 00
    nop                 ;194f 00
    nop                 ;1950 00
    nop                 ;1951 00
    nop                 ;1952 00
    nop                 ;1953 00
    nop                 ;1954 00
    nop                 ;1955 00
    nop                 ;1956 00
    nop                 ;1957 00
    nop                 ;1958 00
    nop                 ;1959 00
    nop                 ;195a 00
    nop                 ;195b 00
    nop                 ;195c 00
    nop                 ;195d 00
    nop                 ;195e 00
    nop                 ;195f 00
    nop                 ;1960 00
    nop                 ;1961 00
    nop                 ;1962 00
    nop                 ;1963 00
    nop                 ;1964 00
    nop                 ;1965 00
    nop                 ;1966 00
    nop                 ;1967 00
    nop                 ;1968 00
    nop                 ;1969 00
    nop                 ;196a 00
    nop                 ;196b 00
    nop                 ;196c 00
    nop                 ;196d 00
    nop                 ;196e 00
    nop                 ;196f 00
    nop                 ;1970 00
    nop                 ;1971 00
    nop                 ;1972 00
    nop                 ;1973 00
    nop                 ;1974 00
    nop                 ;1975 00
    nop                 ;1976 00
    nop                 ;1977 00
    nop                 ;1978 00
    nop                 ;1979 00
    nop                 ;197a 00
    nop                 ;197b 00
    nop                 ;197c 00
    nop                 ;197d 00
    nop                 ;197e 00
    nop                 ;197f 00
    nop                 ;1980 00
    nop                 ;1981 00
    nop                 ;1982 00
    nop                 ;1983 00
    nop                 ;1984 00
    nop                 ;1985 00
    nop                 ;1986 00
    nop                 ;1987 00
    nop                 ;1988 00
    nop                 ;1989 00
    nop                 ;198a 00
    nop                 ;198b 00
    nop                 ;198c 00
    nop                 ;198d 00
    nop                 ;198e 00
    nop                 ;198f 00
    nop                 ;1990 00
    nop                 ;1991 00
    nop                 ;1992 00
    nop                 ;1993 00
    nop                 ;1994 00
    nop                 ;1995 00
    nop                 ;1996 00
    nop                 ;1997 00
    nop                 ;1998 00
    nop                 ;1999 00
    nop                 ;199a 00
    nop                 ;199b 00
    nop                 ;199c 00
    nop                 ;199d 00
    nop                 ;199e 00
    nop                 ;199f 00
    nop                 ;19a0 00
    nop                 ;19a1 00
    nop                 ;19a2 00
    nop                 ;19a3 00
    nop                 ;19a4 00
    nop                 ;19a5 00
    nop                 ;19a6 00
    nop                 ;19a7 00
    nop                 ;19a8 00
    nop                 ;19a9 00
    nop                 ;19aa 00
    nop                 ;19ab 00
    nop                 ;19ac 00
    nop                 ;19ad 00
    nop                 ;19ae 00
    nop                 ;19af 00
    nop                 ;19b0 00
    nop                 ;19b1 00
    nop                 ;19b2 00
    nop                 ;19b3 00
    nop                 ;19b4 00
    nop                 ;19b5 00
    nop                 ;19b6 00
    nop                 ;19b7 00
    nop                 ;19b8 00
    nop                 ;19b9 00
    nop                 ;19ba 00
    nop                 ;19bb 00
    nop                 ;19bc 00
    nop                 ;19bd 00
    nop                 ;19be 00
    nop                 ;19bf 00
    nop                 ;19c0 00
    nop                 ;19c1 00
    nop                 ;19c2 00
    nop                 ;19c3 00
    nop                 ;19c4 00
    nop                 ;19c5 00
    nop                 ;19c6 00
    nop                 ;19c7 00
    nop                 ;19c8 00
    nop                 ;19c9 00
    nop                 ;19ca 00
    nop                 ;19cb 00
    nop                 ;19cc 00
    nop                 ;19cd 00
    nop                 ;19ce 00
    nop                 ;19cf 00
    nop                 ;19d0 00
    nop                 ;19d1 00
    nop                 ;19d2 00
    nop                 ;19d3 00
    nop                 ;19d4 00
    nop                 ;19d5 00
    nop                 ;19d6 00
    nop                 ;19d7 00
    nop                 ;19d8 00
    nop                 ;19d9 00
    nop                 ;19da 00
    nop                 ;19db 00
    nop                 ;19dc 00
    nop                 ;19dd 00
    nop                 ;19de 00
    nop                 ;19df 00
    nop                 ;19e0 00
    nop                 ;19e1 00
    nop                 ;19e2 00
    nop                 ;19e3 00
    nop                 ;19e4 00
    nop                 ;19e5 00
    nop                 ;19e6 00
    nop                 ;19e7 00
    nop                 ;19e8 00
    nop                 ;19e9 00
    nop                 ;19ea 00
    nop                 ;19eb 00
    nop                 ;19ec 00
    nop                 ;19ed 00
    nop                 ;19ee 00
    nop                 ;19ef 00
    nop                 ;19f0 00
    nop                 ;19f1 00
    nop                 ;19f2 00
    nop                 ;19f3 00
    nop                 ;19f4 00
    nop                 ;19f5 00
    nop                 ;19f6 00
    nop                 ;19f7 00
    nop                 ;19f8 00
    nop                 ;19f9 00
    nop                 ;19fa 00
    nop                 ;19fb 00
    nop                 ;19fc 00
    nop                 ;19fd 00
    nop                 ;19fe 00
    nop                 ;19ff 00
    nop                 ;1a00 00
    nop                 ;1a01 00
    nop                 ;1a02 00
    nop                 ;1a03 00
    nop                 ;1a04 00
    nop                 ;1a05 00
    nop                 ;1a06 00
    nop                 ;1a07 00
    nop                 ;1a08 00
    nop                 ;1a09 00
    nop                 ;1a0a 00
    nop                 ;1a0b 00
    nop                 ;1a0c 00
    nop                 ;1a0d 00
    nop                 ;1a0e 00
    nop                 ;1a0f 00
    nop                 ;1a10 00
    nop                 ;1a11 00
    nop                 ;1a12 00
    nop                 ;1a13 00
    nop                 ;1a14 00
    nop                 ;1a15 00
    nop                 ;1a16 00
    nop                 ;1a17 00
    nop                 ;1a18 00
    nop                 ;1a19 00
    nop                 ;1a1a 00
    nop                 ;1a1b 00
    nop                 ;1a1c 00
    nop                 ;1a1d 00
    nop                 ;1a1e 00
    nop                 ;1a1f 00
    nop                 ;1a20 00
    nop                 ;1a21 00
    nop                 ;1a22 00
    nop                 ;1a23 00
    nop                 ;1a24 00
    nop                 ;1a25 00
    nop                 ;1a26 00
    nop                 ;1a27 00
    nop                 ;1a28 00
    nop                 ;1a29 00
    nop                 ;1a2a 00
    nop                 ;1a2b 00
    nop                 ;1a2c 00
    nop                 ;1a2d 00
    nop                 ;1a2e 00
    nop                 ;1a2f 00
    nop                 ;1a30 00
    nop                 ;1a31 00
    nop                 ;1a32 00
    nop                 ;1a33 00
    nop                 ;1a34 00
    nop                 ;1a35 00
    nop                 ;1a36 00
    nop                 ;1a37 00
    nop                 ;1a38 00
    nop                 ;1a39 00
    nop                 ;1a3a 00
    nop                 ;1a3b 00
    nop                 ;1a3c 00
    nop                 ;1a3d 00
    nop                 ;1a3e 00
    nop                 ;1a3f 00
    nop                 ;1a40 00
    nop                 ;1a41 00
    nop                 ;1a42 00
    nop                 ;1a43 00
    nop                 ;1a44 00
    nop                 ;1a45 00
    nop                 ;1a46 00
    nop                 ;1a47 00
    nop                 ;1a48 00
    nop                 ;1a49 00
    nop                 ;1a4a 00
    nop                 ;1a4b 00
    nop                 ;1a4c 00
    nop                 ;1a4d 00
    nop                 ;1a4e 00
    nop                 ;1a4f 00
    nop                 ;1a50 00
    nop                 ;1a51 00
    nop                 ;1a52 00
    nop                 ;1a53 00
    nop                 ;1a54 00
    nop                 ;1a55 00
    nop                 ;1a56 00
    nop                 ;1a57 00
    nop                 ;1a58 00
    nop                 ;1a59 00
    nop                 ;1a5a 00
    nop                 ;1a5b 00
    nop                 ;1a5c 00
    nop                 ;1a5d 00
    nop                 ;1a5e 00
    nop                 ;1a5f 00
    nop                 ;1a60 00
    nop                 ;1a61 00
    nop                 ;1a62 00
    nop                 ;1a63 00
    nop                 ;1a64 00
    nop                 ;1a65 00
    nop                 ;1a66 00
    nop                 ;1a67 00
    nop                 ;1a68 00
    nop                 ;1a69 00
    nop                 ;1a6a 00
    nop                 ;1a6b 00
    nop                 ;1a6c 00
    nop                 ;1a6d 00
    nop                 ;1a6e 00
    nop                 ;1a6f 00
    nop                 ;1a70 00
    nop                 ;1a71 00
    nop                 ;1a72 00
    nop                 ;1a73 00
    nop                 ;1a74 00
    nop                 ;1a75 00
    nop                 ;1a76 00
    nop                 ;1a77 00
    nop                 ;1a78 00
    nop                 ;1a79 00
    nop                 ;1a7a 00
    nop                 ;1a7b 00
    nop                 ;1a7c 00
    nop                 ;1a7d 00
    nop                 ;1a7e 00
    nop                 ;1a7f 00
    nop                 ;1a80 00
    nop                 ;1a81 00
    nop                 ;1a82 00
    nop                 ;1a83 00
    nop                 ;1a84 00
    nop                 ;1a85 00
    nop                 ;1a86 00
    nop                 ;1a87 00
    nop                 ;1a88 00
    nop                 ;1a89 00
    nop                 ;1a8a 00
    nop                 ;1a8b 00
    nop                 ;1a8c 00
    nop                 ;1a8d 00
    nop                 ;1a8e 00
    nop                 ;1a8f 00
    nop                 ;1a90 00
    nop                 ;1a91 00
    nop                 ;1a92 00
    nop                 ;1a93 00
    nop                 ;1a94 00
    nop                 ;1a95 00
    nop                 ;1a96 00
    nop                 ;1a97 00
    nop                 ;1a98 00
    nop                 ;1a99 00
    nop                 ;1a9a 00
    nop                 ;1a9b 00
    nop                 ;1a9c 00
    nop                 ;1a9d 00
    nop                 ;1a9e 00
    nop                 ;1a9f 00
    nop                 ;1aa0 00
    nop                 ;1aa1 00
    nop                 ;1aa2 00
    nop                 ;1aa3 00
    nop                 ;1aa4 00
    nop                 ;1aa5 00
    nop                 ;1aa6 00
    nop                 ;1aa7 00
    nop                 ;1aa8 00
    nop                 ;1aa9 00
    nop                 ;1aaa 00
    nop                 ;1aab 00
    nop                 ;1aac 00
    nop                 ;1aad 00
    nop                 ;1aae 00
    nop                 ;1aaf 00
    nop                 ;1ab0 00
    nop                 ;1ab1 00
    nop                 ;1ab2 00
    nop                 ;1ab3 00
    nop                 ;1ab4 00
    nop                 ;1ab5 00
    nop                 ;1ab6 00
    nop                 ;1ab7 00
    nop                 ;1ab8 00
    nop                 ;1ab9 00
    nop                 ;1aba 00
    nop                 ;1abb 00
    nop                 ;1abc 00
    nop                 ;1abd 00
    nop                 ;1abe 00
    nop                 ;1abf 00
    nop                 ;1ac0 00
    nop                 ;1ac1 00
    nop                 ;1ac2 00
    nop                 ;1ac3 00
    nop                 ;1ac4 00
    nop                 ;1ac5 00
    nop                 ;1ac6 00
    nop                 ;1ac7 00
    nop                 ;1ac8 00
    nop                 ;1ac9 00
    nop                 ;1aca 00
    nop                 ;1acb 00
    nop                 ;1acc 00
    nop                 ;1acd 00
    nop                 ;1ace 00
    nop                 ;1acf 00
    nop                 ;1ad0 00
    nop                 ;1ad1 00
    nop                 ;1ad2 00
    nop                 ;1ad3 00
    nop                 ;1ad4 00
    nop                 ;1ad5 00
    nop                 ;1ad6 00
    nop                 ;1ad7 00
    nop                 ;1ad8 00
    nop                 ;1ad9 00
    nop                 ;1ada 00
    nop                 ;1adb 00
    nop                 ;1adc 00
    nop                 ;1add 00
    nop                 ;1ade 00
    nop                 ;1adf 00
    nop                 ;1ae0 00
    nop                 ;1ae1 00
    nop                 ;1ae2 00
    nop                 ;1ae3 00
    nop                 ;1ae4 00
    nop                 ;1ae5 00
    nop                 ;1ae6 00
    nop                 ;1ae7 00
    nop                 ;1ae8 00
    nop                 ;1ae9 00
    nop                 ;1aea 00
    nop                 ;1aeb 00
    nop                 ;1aec 00
    nop                 ;1aed 00
    nop                 ;1aee 00
    nop                 ;1aef 00
    nop                 ;1af0 00
    nop                 ;1af1 00
    nop                 ;1af2 00
    nop                 ;1af3 00
    nop                 ;1af4 00
    nop                 ;1af5 00
    nop                 ;1af6 00
    nop                 ;1af7 00
    nop                 ;1af8 00
    nop                 ;1af9 00
    nop                 ;1afa 00
    nop                 ;1afb 00
    nop                 ;1afc 00
    nop                 ;1afd 00
    nop                 ;1afe 00
    nop                 ;1aff 00
    nop                 ;1b00 00
    nop                 ;1b01 00
    nop                 ;1b02 00
    nop                 ;1b03 00
    nop                 ;1b04 00
    nop                 ;1b05 00
    nop                 ;1b06 00
    nop                 ;1b07 00
    nop                 ;1b08 00
    nop                 ;1b09 00
    nop                 ;1b0a 00
    nop                 ;1b0b 00
    nop                 ;1b0c 00
    nop                 ;1b0d 00
    nop                 ;1b0e 00
    nop                 ;1b0f 00
    nop                 ;1b10 00
    nop                 ;1b11 00
    nop                 ;1b12 00
    nop                 ;1b13 00
    nop                 ;1b14 00
    nop                 ;1b15 00
    nop                 ;1b16 00
    nop                 ;1b17 00
    nop                 ;1b18 00
    nop                 ;1b19 00
    nop                 ;1b1a 00
    nop                 ;1b1b 00
    nop                 ;1b1c 00
    nop                 ;1b1d 00
    nop                 ;1b1e 00
    nop                 ;1b1f 00
    nop                 ;1b20 00
    nop                 ;1b21 00
    nop                 ;1b22 00
    nop                 ;1b23 00
    nop                 ;1b24 00
    nop                 ;1b25 00
    nop                 ;1b26 00
    nop                 ;1b27 00
    nop                 ;1b28 00
    nop                 ;1b29 00
    nop                 ;1b2a 00
    nop                 ;1b2b 00
    nop                 ;1b2c 00
    nop                 ;1b2d 00
    nop                 ;1b2e 00
    nop                 ;1b2f 00
    nop                 ;1b30 00
    nop                 ;1b31 00
    nop                 ;1b32 00
    nop                 ;1b33 00
    nop                 ;1b34 00
    nop                 ;1b35 00
    nop                 ;1b36 00
    nop                 ;1b37 00
    nop                 ;1b38 00
    nop                 ;1b39 00
    nop                 ;1b3a 00
    nop                 ;1b3b 00
    nop                 ;1b3c 00
    nop                 ;1b3d 00
    nop                 ;1b3e 00
    nop                 ;1b3f 00
    nop                 ;1b40 00
    nop                 ;1b41 00
    nop                 ;1b42 00
    nop                 ;1b43 00
    nop                 ;1b44 00
    nop                 ;1b45 00
    nop                 ;1b46 00
    nop                 ;1b47 00
    nop                 ;1b48 00
    nop                 ;1b49 00
    nop                 ;1b4a 00
    nop                 ;1b4b 00
    nop                 ;1b4c 00
    nop                 ;1b4d 00
    nop                 ;1b4e 00
    nop                 ;1b4f 00
    nop                 ;1b50 00
    nop                 ;1b51 00
    nop                 ;1b52 00
    nop                 ;1b53 00
    nop                 ;1b54 00
    nop                 ;1b55 00
    nop                 ;1b56 00
    nop                 ;1b57 00
    nop                 ;1b58 00
    nop                 ;1b59 00
    nop                 ;1b5a 00
    nop                 ;1b5b 00
    nop                 ;1b5c 00
    nop                 ;1b5d 00
    nop                 ;1b5e 00
    nop                 ;1b5f 00
    nop                 ;1b60 00
    nop                 ;1b61 00
    nop                 ;1b62 00
    nop                 ;1b63 00
    nop                 ;1b64 00
    nop                 ;1b65 00
    nop                 ;1b66 00
    nop                 ;1b67 00
    nop                 ;1b68 00
    nop                 ;1b69 00
    nop                 ;1b6a 00
    nop                 ;1b6b 00
    nop                 ;1b6c 00
    nop                 ;1b6d 00
    nop                 ;1b6e 00
    nop                 ;1b6f 00
    nop                 ;1b70 00
    nop                 ;1b71 00
    nop                 ;1b72 00
    nop                 ;1b73 00
    nop                 ;1b74 00
    nop                 ;1b75 00
    nop                 ;1b76 00
    nop                 ;1b77 00
    nop                 ;1b78 00
    nop                 ;1b79 00
    nop                 ;1b7a 00
    nop                 ;1b7b 00
    nop                 ;1b7c 00
    nop                 ;1b7d 00
    nop                 ;1b7e 00
    nop                 ;1b7f 00
    nop                 ;1b80 00
    nop                 ;1b81 00
    nop                 ;1b82 00
    nop                 ;1b83 00
    nop                 ;1b84 00
    nop                 ;1b85 00
    nop                 ;1b86 00
    nop                 ;1b87 00
    nop                 ;1b88 00
    nop                 ;1b89 00
    nop                 ;1b8a 00
    nop                 ;1b8b 00
    nop                 ;1b8c 00
    nop                 ;1b8d 00
    nop                 ;1b8e 00
    nop                 ;1b8f 00
    nop                 ;1b90 00
    nop                 ;1b91 00
    nop                 ;1b92 00
    nop                 ;1b93 00
    nop                 ;1b94 00
    nop                 ;1b95 00
    nop                 ;1b96 00
    nop                 ;1b97 00
    nop                 ;1b98 00
    nop                 ;1b99 00
    nop                 ;1b9a 00
    nop                 ;1b9b 00
    nop                 ;1b9c 00
    nop                 ;1b9d 00
    nop                 ;1b9e 00
    nop                 ;1b9f 00
    nop                 ;1ba0 00
    nop                 ;1ba1 00
    nop                 ;1ba2 00
    nop                 ;1ba3 00
    nop                 ;1ba4 00
    nop                 ;1ba5 00
    nop                 ;1ba6 00
    nop                 ;1ba7 00
    nop                 ;1ba8 00
    nop                 ;1ba9 00
    nop                 ;1baa 00
    nop                 ;1bab 00
    nop                 ;1bac 00
    nop                 ;1bad 00
    nop                 ;1bae 00
    nop                 ;1baf 00
    nop                 ;1bb0 00
    nop                 ;1bb1 00
    nop                 ;1bb2 00
    nop                 ;1bb3 00
    nop                 ;1bb4 00
    nop                 ;1bb5 00
    nop                 ;1bb6 00
    nop                 ;1bb7 00
    nop                 ;1bb8 00
    nop                 ;1bb9 00
    nop                 ;1bba 00
    nop                 ;1bbb 00
    nop                 ;1bbc 00
    nop                 ;1bbd 00
    nop                 ;1bbe 00
    nop                 ;1bbf 00
    nop                 ;1bc0 00
    nop                 ;1bc1 00
    nop                 ;1bc2 00
    nop                 ;1bc3 00
    nop                 ;1bc4 00
    nop                 ;1bc5 00
    nop                 ;1bc6 00
    nop                 ;1bc7 00
    nop                 ;1bc8 00
    nop                 ;1bc9 00
    nop                 ;1bca 00
    nop                 ;1bcb 00
    nop                 ;1bcc 00
    nop                 ;1bcd 00
    nop                 ;1bce 00
    nop                 ;1bcf 00
    nop                 ;1bd0 00
    nop                 ;1bd1 00
    nop                 ;1bd2 00
    nop                 ;1bd3 00
    nop                 ;1bd4 00
    nop                 ;1bd5 00
    nop                 ;1bd6 00
    nop                 ;1bd7 00
    nop                 ;1bd8 00
    nop                 ;1bd9 00
    nop                 ;1bda 00
    nop                 ;1bdb 00
    nop                 ;1bdc 00
    nop                 ;1bdd 00
    nop                 ;1bde 00
    nop                 ;1bdf 00
    nop                 ;1be0 00
    nop                 ;1be1 00
    nop                 ;1be2 00
    nop                 ;1be3 00
    nop                 ;1be4 00
    nop                 ;1be5 00
    nop                 ;1be6 00
    nop                 ;1be7 00
    nop                 ;1be8 00
    nop                 ;1be9 00
    nop                 ;1bea 00
    nop                 ;1beb 00
    nop                 ;1bec 00
    nop                 ;1bed 00
    nop                 ;1bee 00
    nop                 ;1bef 00
    nop                 ;1bf0 00
    nop                 ;1bf1 00
    nop                 ;1bf2 00
    nop                 ;1bf3 00
    nop                 ;1bf4 00
    nop                 ;1bf5 00
    nop                 ;1bf6 00
    nop                 ;1bf7 00
    nop                 ;1bf8 00
    nop                 ;1bf9 00
    nop                 ;1bfa 00
    nop                 ;1bfb 00
    nop                 ;1bfc 00
    nop                 ;1bfd 00
    nop                 ;1bfe 00
    nop                 ;1bff 00
    nop                 ;1c00 00
    nop                 ;1c01 00
    nop                 ;1c02 00
    nop                 ;1c03 00
    nop                 ;1c04 00
    nop                 ;1c05 00
    nop                 ;1c06 00
    nop                 ;1c07 00
    nop                 ;1c08 00
    nop                 ;1c09 00
    nop                 ;1c0a 00
    nop                 ;1c0b 00
    nop                 ;1c0c 00
    nop                 ;1c0d 00
    nop                 ;1c0e 00
    nop                 ;1c0f 00
    nop                 ;1c10 00
    nop                 ;1c11 00
    nop                 ;1c12 00
    nop                 ;1c13 00
    nop                 ;1c14 00
    nop                 ;1c15 00
    nop                 ;1c16 00
    nop                 ;1c17 00
    nop                 ;1c18 00
    nop                 ;1c19 00
    nop                 ;1c1a 00
    nop                 ;1c1b 00
    nop                 ;1c1c 00
    nop                 ;1c1d 00
    nop                 ;1c1e 00
    nop                 ;1c1f 00
    nop                 ;1c20 00
    nop                 ;1c21 00
    nop                 ;1c22 00
    nop                 ;1c23 00
    nop                 ;1c24 00
    nop                 ;1c25 00
    nop                 ;1c26 00
    nop                 ;1c27 00
    nop                 ;1c28 00
    nop                 ;1c29 00
    nop                 ;1c2a 00
    nop                 ;1c2b 00
    nop                 ;1c2c 00
    nop                 ;1c2d 00
    nop                 ;1c2e 00
    nop                 ;1c2f 00
    nop                 ;1c30 00
    nop                 ;1c31 00
    nop                 ;1c32 00
    nop                 ;1c33 00
    nop                 ;1c34 00
    nop                 ;1c35 00
    nop                 ;1c36 00
    nop                 ;1c37 00
    nop                 ;1c38 00
    nop                 ;1c39 00
    nop                 ;1c3a 00
    nop                 ;1c3b 00
    nop                 ;1c3c 00
    nop                 ;1c3d 00
    nop                 ;1c3e 00
    nop                 ;1c3f 00
    nop                 ;1c40 00
    nop                 ;1c41 00
    nop                 ;1c42 00
    nop                 ;1c43 00
    nop                 ;1c44 00
    nop                 ;1c45 00
    nop                 ;1c46 00
    nop                 ;1c47 00
    nop                 ;1c48 00
    nop                 ;1c49 00
    nop                 ;1c4a 00
    nop                 ;1c4b 00
    nop                 ;1c4c 00
    nop                 ;1c4d 00
    nop                 ;1c4e 00
    nop                 ;1c4f 00
    nop                 ;1c50 00
    nop                 ;1c51 00
    nop                 ;1c52 00
    nop                 ;1c53 00
    nop                 ;1c54 00
    nop                 ;1c55 00
    nop                 ;1c56 00
    nop                 ;1c57 00
    nop                 ;1c58 00
    nop                 ;1c59 00
    nop                 ;1c5a 00
    nop                 ;1c5b 00
    nop                 ;1c5c 00
    nop                 ;1c5d 00
    nop                 ;1c5e 00
    nop                 ;1c5f 00
    nop                 ;1c60 00
    nop                 ;1c61 00
    nop                 ;1c62 00
    nop                 ;1c63 00
    nop                 ;1c64 00
    nop                 ;1c65 00
    nop                 ;1c66 00
    nop                 ;1c67 00
    nop                 ;1c68 00
    nop                 ;1c69 00
    nop                 ;1c6a 00
    nop                 ;1c6b 00
    nop                 ;1c6c 00
    nop                 ;1c6d 00
    nop                 ;1c6e 00
    nop                 ;1c6f 00
    nop                 ;1c70 00
    nop                 ;1c71 00
    nop                 ;1c72 00
    nop                 ;1c73 00
    nop                 ;1c74 00
    nop                 ;1c75 00
    nop                 ;1c76 00
    nop                 ;1c77 00
    nop                 ;1c78 00
    nop                 ;1c79 00
    nop                 ;1c7a 00
    nop                 ;1c7b 00
    nop                 ;1c7c 00
    nop                 ;1c7d 00
    nop                 ;1c7e 00
    nop                 ;1c7f 00
    nop                 ;1c80 00
    nop                 ;1c81 00
    nop                 ;1c82 00
    nop                 ;1c83 00
    nop                 ;1c84 00
    nop                 ;1c85 00
    nop                 ;1c86 00
    nop                 ;1c87 00
    nop                 ;1c88 00
    nop                 ;1c89 00
    nop                 ;1c8a 00
    nop                 ;1c8b 00
    nop                 ;1c8c 00
    nop                 ;1c8d 00
    nop                 ;1c8e 00
    nop                 ;1c8f 00
    nop                 ;1c90 00
    nop                 ;1c91 00
    nop                 ;1c92 00
    nop                 ;1c93 00
    nop                 ;1c94 00
    nop                 ;1c95 00
    nop                 ;1c96 00
    nop                 ;1c97 00
    nop                 ;1c98 00
    nop                 ;1c99 00
    nop                 ;1c9a 00
    nop                 ;1c9b 00
    nop                 ;1c9c 00
    nop                 ;1c9d 00
    nop                 ;1c9e 00
    nop                 ;1c9f 00
    nop                 ;1ca0 00
    nop                 ;1ca1 00
    nop                 ;1ca2 00
    nop                 ;1ca3 00
    nop                 ;1ca4 00
    nop                 ;1ca5 00
    nop                 ;1ca6 00
    nop                 ;1ca7 00
    nop                 ;1ca8 00
    nop                 ;1ca9 00
    nop                 ;1caa 00
    nop                 ;1cab 00
    nop                 ;1cac 00
    nop                 ;1cad 00
    nop                 ;1cae 00
    nop                 ;1caf 00
    nop                 ;1cb0 00
    nop                 ;1cb1 00
    nop                 ;1cb2 00
    nop                 ;1cb3 00
    nop                 ;1cb4 00
    nop                 ;1cb5 00
    nop                 ;1cb6 00
    nop                 ;1cb7 00
    nop                 ;1cb8 00
    nop                 ;1cb9 00
    nop                 ;1cba 00
    nop                 ;1cbb 00
    nop                 ;1cbc 00
    nop                 ;1cbd 00
    nop                 ;1cbe 00
    nop                 ;1cbf 00
    nop                 ;1cc0 00
    nop                 ;1cc1 00
    nop                 ;1cc2 00
    nop                 ;1cc3 00
    nop                 ;1cc4 00
    nop                 ;1cc5 00
    nop                 ;1cc6 00
    nop                 ;1cc7 00
    nop                 ;1cc8 00
    nop                 ;1cc9 00
    nop                 ;1cca 00
    nop                 ;1ccb 00
    nop                 ;1ccc 00
    nop                 ;1ccd 00
    nop                 ;1cce 00
    nop                 ;1ccf 00
    nop                 ;1cd0 00
    nop                 ;1cd1 00
    nop                 ;1cd2 00
    nop                 ;1cd3 00
    nop                 ;1cd4 00
    nop                 ;1cd5 00
    nop                 ;1cd6 00
    nop                 ;1cd7 00
    nop                 ;1cd8 00
    nop                 ;1cd9 00
    nop                 ;1cda 00
    nop                 ;1cdb 00
    nop                 ;1cdc 00
    nop                 ;1cdd 00
    nop                 ;1cde 00
    nop                 ;1cdf 00
    nop                 ;1ce0 00
    nop                 ;1ce1 00
    nop                 ;1ce2 00
    nop                 ;1ce3 00
    nop                 ;1ce4 00
    nop                 ;1ce5 00
    nop                 ;1ce6 00
    nop                 ;1ce7 00
    nop                 ;1ce8 00
    nop                 ;1ce9 00
    nop                 ;1cea 00
    nop                 ;1ceb 00
    nop                 ;1cec 00
    nop                 ;1ced 00
    nop                 ;1cee 00
    nop                 ;1cef 00
    nop                 ;1cf0 00
    nop                 ;1cf1 00
    nop                 ;1cf2 00
    nop                 ;1cf3 00
    nop                 ;1cf4 00
    nop                 ;1cf5 00
    nop                 ;1cf6 00
    nop                 ;1cf7 00
    nop                 ;1cf8 00
    nop                 ;1cf9 00
    nop                 ;1cfa 00
    nop                 ;1cfb 00
    nop                 ;1cfc 00
    nop                 ;1cfd 00
    nop                 ;1cfe 00
    nop                 ;1cff 00
    nop                 ;1d00 00
    nop                 ;1d01 00
    nop                 ;1d02 00
    nop                 ;1d03 00
    nop                 ;1d04 00
    nop                 ;1d05 00
    nop                 ;1d06 00
    nop                 ;1d07 00
    nop                 ;1d08 00
    nop                 ;1d09 00
    nop                 ;1d0a 00
    nop                 ;1d0b 00
    nop                 ;1d0c 00
    nop                 ;1d0d 00
    nop                 ;1d0e 00
    nop                 ;1d0f 00
    nop                 ;1d10 00
    nop                 ;1d11 00
    nop                 ;1d12 00
    nop                 ;1d13 00
    nop                 ;1d14 00
    nop                 ;1d15 00
    nop                 ;1d16 00
    nop                 ;1d17 00
    nop                 ;1d18 00
    nop                 ;1d19 00
    nop                 ;1d1a 00
    nop                 ;1d1b 00
    nop                 ;1d1c 00
    nop                 ;1d1d 00
    nop                 ;1d1e 00
    nop                 ;1d1f 00
    nop                 ;1d20 00
    nop                 ;1d21 00
    nop                 ;1d22 00
    nop                 ;1d23 00
    nop                 ;1d24 00
    nop                 ;1d25 00
    nop                 ;1d26 00
    nop                 ;1d27 00
    nop                 ;1d28 00
    nop                 ;1d29 00
    nop                 ;1d2a 00
    nop                 ;1d2b 00
    nop                 ;1d2c 00
    nop                 ;1d2d 00
    nop                 ;1d2e 00
    nop                 ;1d2f 00
    nop                 ;1d30 00
    nop                 ;1d31 00
    nop                 ;1d32 00
    nop                 ;1d33 00
    nop                 ;1d34 00
    nop                 ;1d35 00
    nop                 ;1d36 00
    nop                 ;1d37 00
    nop                 ;1d38 00
    nop                 ;1d39 00
    nop                 ;1d3a 00
    nop                 ;1d3b 00
    nop                 ;1d3c 00
    nop                 ;1d3d 00
    nop                 ;1d3e 00
    nop                 ;1d3f 00
    nop                 ;1d40 00
    nop                 ;1d41 00
    nop                 ;1d42 00
    nop                 ;1d43 00
    nop                 ;1d44 00
    nop                 ;1d45 00
    nop                 ;1d46 00
    nop                 ;1d47 00
    nop                 ;1d48 00
    nop                 ;1d49 00
    nop                 ;1d4a 00
    nop                 ;1d4b 00
    nop                 ;1d4c 00
    nop                 ;1d4d 00
    nop                 ;1d4e 00
    nop                 ;1d4f 00
    nop                 ;1d50 00
    nop                 ;1d51 00
    nop                 ;1d52 00
    nop                 ;1d53 00
    nop                 ;1d54 00
    nop                 ;1d55 00
    nop                 ;1d56 00
    nop                 ;1d57 00
    nop                 ;1d58 00
    nop                 ;1d59 00
    nop                 ;1d5a 00
    nop                 ;1d5b 00
    nop                 ;1d5c 00
    nop                 ;1d5d 00
    nop                 ;1d5e 00
    nop                 ;1d5f 00
    nop                 ;1d60 00
    nop                 ;1d61 00
    nop                 ;1d62 00
    nop                 ;1d63 00
    nop                 ;1d64 00
    nop                 ;1d65 00
    nop                 ;1d66 00
    nop                 ;1d67 00
    nop                 ;1d68 00
    nop                 ;1d69 00
    nop                 ;1d6a 00
    nop                 ;1d6b 00
    nop                 ;1d6c 00
    nop                 ;1d6d 00
    nop                 ;1d6e 00
    nop                 ;1d6f 00
    nop                 ;1d70 00
    nop                 ;1d71 00
    nop                 ;1d72 00
    nop                 ;1d73 00
    nop                 ;1d74 00
    nop                 ;1d75 00
    nop                 ;1d76 00
    nop                 ;1d77 00
    nop                 ;1d78 00
    nop                 ;1d79 00
    nop                 ;1d7a 00
    nop                 ;1d7b 00
    nop                 ;1d7c 00
    nop                 ;1d7d 00
    nop                 ;1d7e 00
    nop                 ;1d7f 00
    nop                 ;1d80 00
    nop                 ;1d81 00
    nop                 ;1d82 00
    nop                 ;1d83 00
    nop                 ;1d84 00
    nop                 ;1d85 00
    nop                 ;1d86 00
    nop                 ;1d87 00
    nop                 ;1d88 00
    nop                 ;1d89 00
    nop                 ;1d8a 00
    nop                 ;1d8b 00
    nop                 ;1d8c 00
    nop                 ;1d8d 00
    nop                 ;1d8e 00
    nop                 ;1d8f 00
    nop                 ;1d90 00
    nop                 ;1d91 00
    nop                 ;1d92 00
    nop                 ;1d93 00
    nop                 ;1d94 00
    nop                 ;1d95 00
    nop                 ;1d96 00
    nop                 ;1d97 00
    nop                 ;1d98 00
    nop                 ;1d99 00
    nop                 ;1d9a 00
    nop                 ;1d9b 00
    nop                 ;1d9c 00
    nop                 ;1d9d 00
    nop                 ;1d9e 00
    nop                 ;1d9f 00
    nop                 ;1da0 00
    nop                 ;1da1 00
    nop                 ;1da2 00
    nop                 ;1da3 00
    nop                 ;1da4 00
    nop                 ;1da5 00
    nop                 ;1da6 00
    nop                 ;1da7 00
    nop                 ;1da8 00
    nop                 ;1da9 00
    nop                 ;1daa 00
    nop                 ;1dab 00
    nop                 ;1dac 00
    nop                 ;1dad 00
    nop                 ;1dae 00
    nop                 ;1daf 00
    nop                 ;1db0 00
    nop                 ;1db1 00
    nop                 ;1db2 00
    nop                 ;1db3 00
    nop                 ;1db4 00
    nop                 ;1db5 00
    nop                 ;1db6 00
    nop                 ;1db7 00
    nop                 ;1db8 00
    nop                 ;1db9 00
    nop                 ;1dba 00
    nop                 ;1dbb 00
    nop                 ;1dbc 00
    nop                 ;1dbd 00
    nop                 ;1dbe 00
    nop                 ;1dbf 00
    nop                 ;1dc0 00
    nop                 ;1dc1 00
    nop                 ;1dc2 00
    nop                 ;1dc3 00
    nop                 ;1dc4 00
    nop                 ;1dc5 00
    nop                 ;1dc6 00
    nop                 ;1dc7 00
    nop                 ;1dc8 00
    nop                 ;1dc9 00
    nop                 ;1dca 00
    nop                 ;1dcb 00
    nop                 ;1dcc 00
    nop                 ;1dcd 00
    nop                 ;1dce 00
    nop                 ;1dcf 00
    nop                 ;1dd0 00
    nop                 ;1dd1 00
    nop                 ;1dd2 00
    nop                 ;1dd3 00
    nop                 ;1dd4 00
    nop                 ;1dd5 00
    nop                 ;1dd6 00
    nop                 ;1dd7 00
    nop                 ;1dd8 00
    nop                 ;1dd9 00
    nop                 ;1dda 00
    nop                 ;1ddb 00
    nop                 ;1ddc 00
    nop                 ;1ddd 00
    nop                 ;1dde 00
    nop                 ;1ddf 00
    nop                 ;1de0 00
    nop                 ;1de1 00
    nop                 ;1de2 00
    nop                 ;1de3 00
    nop                 ;1de4 00
    nop                 ;1de5 00
    nop                 ;1de6 00
    nop                 ;1de7 00
    nop                 ;1de8 00
    nop                 ;1de9 00
    nop                 ;1dea 00
    nop                 ;1deb 00
    nop                 ;1dec 00
    nop                 ;1ded 00
    nop                 ;1dee 00
    nop                 ;1def 00
    nop                 ;1df0 00
    nop                 ;1df1 00
    nop                 ;1df2 00
    nop                 ;1df3 00
    nop                 ;1df4 00
    nop                 ;1df5 00
    nop                 ;1df6 00
    nop                 ;1df7 00
    nop                 ;1df8 00
    nop                 ;1df9 00
    nop                 ;1dfa 00
    nop                 ;1dfb 00
    nop                 ;1dfc 00
    nop                 ;1dfd 00
    nop                 ;1dfe 00
    nop                 ;1dff 00
    nop                 ;1e00 00
    nop                 ;1e01 00
    nop                 ;1e02 00
    nop                 ;1e03 00
    nop                 ;1e04 00
    nop                 ;1e05 00
    nop                 ;1e06 00
    nop                 ;1e07 00
    nop                 ;1e08 00
    nop                 ;1e09 00
    nop                 ;1e0a 00
    nop                 ;1e0b 00
    nop                 ;1e0c 00
    nop                 ;1e0d 00
    nop                 ;1e0e 00
    nop                 ;1e0f 00
    nop                 ;1e10 00
    nop                 ;1e11 00
    nop                 ;1e12 00
    nop                 ;1e13 00
    nop                 ;1e14 00
    nop                 ;1e15 00
    nop                 ;1e16 00
    nop                 ;1e17 00
    nop                 ;1e18 00
    nop                 ;1e19 00
    nop                 ;1e1a 00
    nop                 ;1e1b 00
    nop                 ;1e1c 00
    nop                 ;1e1d 00
    nop                 ;1e1e 00
    nop                 ;1e1f 00
    nop                 ;1e20 00
    nop                 ;1e21 00
    nop                 ;1e22 00
    nop                 ;1e23 00
    nop                 ;1e24 00
    nop                 ;1e25 00
    nop                 ;1e26 00
    nop                 ;1e27 00
    nop                 ;1e28 00
    nop                 ;1e29 00
    nop                 ;1e2a 00
    nop                 ;1e2b 00
    nop                 ;1e2c 00
    nop                 ;1e2d 00
    nop                 ;1e2e 00
    nop                 ;1e2f 00
    nop                 ;1e30 00
    nop                 ;1e31 00
    nop                 ;1e32 00
    nop                 ;1e33 00
    nop                 ;1e34 00
    nop                 ;1e35 00
    nop                 ;1e36 00
    nop                 ;1e37 00
    nop                 ;1e38 00
    nop                 ;1e39 00
    nop                 ;1e3a 00
    nop                 ;1e3b 00
    nop                 ;1e3c 00
    nop                 ;1e3d 00
    nop                 ;1e3e 00
    nop                 ;1e3f 00
    nop                 ;1e40 00
    nop                 ;1e41 00
    nop                 ;1e42 00
    nop                 ;1e43 00
    nop                 ;1e44 00
    nop                 ;1e45 00
    nop                 ;1e46 00
    nop                 ;1e47 00
    nop                 ;1e48 00
    nop                 ;1e49 00
    nop                 ;1e4a 00
    nop                 ;1e4b 00
    nop                 ;1e4c 00
    nop                 ;1e4d 00
    nop                 ;1e4e 00
    nop                 ;1e4f 00
    nop                 ;1e50 00
    nop                 ;1e51 00
    nop                 ;1e52 00
    nop                 ;1e53 00
    nop                 ;1e54 00
    nop                 ;1e55 00
    nop                 ;1e56 00
    nop                 ;1e57 00
    nop                 ;1e58 00
    nop                 ;1e59 00
    nop                 ;1e5a 00
    nop                 ;1e5b 00
    nop                 ;1e5c 00
    nop                 ;1e5d 00
    nop                 ;1e5e 00
    nop                 ;1e5f 00
    nop                 ;1e60 00
    nop                 ;1e61 00
    nop                 ;1e62 00
    nop                 ;1e63 00
    nop                 ;1e64 00
    nop                 ;1e65 00
    nop                 ;1e66 00
    nop                 ;1e67 00
    nop                 ;1e68 00
    nop                 ;1e69 00
    nop                 ;1e6a 00
    nop                 ;1e6b 00
    nop                 ;1e6c 00
    nop                 ;1e6d 00
    nop                 ;1e6e 00
    nop                 ;1e6f 00
    nop                 ;1e70 00
    nop                 ;1e71 00
    nop                 ;1e72 00
    nop                 ;1e73 00
    nop                 ;1e74 00
    nop                 ;1e75 00
    nop                 ;1e76 00
    nop                 ;1e77 00
    nop                 ;1e78 00
    nop                 ;1e79 00
    nop                 ;1e7a 00
    nop                 ;1e7b 00
    nop                 ;1e7c 00
    nop                 ;1e7d 00
    nop                 ;1e7e 00
    nop                 ;1e7f 00
    nop                 ;1e80 00
    nop                 ;1e81 00
    nop                 ;1e82 00
    nop                 ;1e83 00
    nop                 ;1e84 00
    nop                 ;1e85 00
    nop                 ;1e86 00
    nop                 ;1e87 00
    nop                 ;1e88 00
    nop                 ;1e89 00
    nop                 ;1e8a 00
    nop                 ;1e8b 00
    nop                 ;1e8c 00
    nop                 ;1e8d 00
    nop                 ;1e8e 00
    nop                 ;1e8f 00
    nop                 ;1e90 00
    nop                 ;1e91 00
    nop                 ;1e92 00
    nop                 ;1e93 00
    nop                 ;1e94 00
    nop                 ;1e95 00
    nop                 ;1e96 00
    nop                 ;1e97 00
    nop                 ;1e98 00
    nop                 ;1e99 00
    nop                 ;1e9a 00
    nop                 ;1e9b 00
    nop                 ;1e9c 00
    nop                 ;1e9d 00
    nop                 ;1e9e 00
    nop                 ;1e9f 00
    nop                 ;1ea0 00
    nop                 ;1ea1 00
    nop                 ;1ea2 00
    nop                 ;1ea3 00
    nop                 ;1ea4 00
    nop                 ;1ea5 00
    nop                 ;1ea6 00
    nop                 ;1ea7 00
    nop                 ;1ea8 00
    nop                 ;1ea9 00
    nop                 ;1eaa 00
    nop                 ;1eab 00
    nop                 ;1eac 00
    nop                 ;1ead 00
    nop                 ;1eae 00
    nop                 ;1eaf 00
    nop                 ;1eb0 00
    nop                 ;1eb1 00
    nop                 ;1eb2 00
    nop                 ;1eb3 00
    nop                 ;1eb4 00
    nop                 ;1eb5 00
    nop                 ;1eb6 00
    nop                 ;1eb7 00
    nop                 ;1eb8 00
    nop                 ;1eb9 00
    nop                 ;1eba 00
    nop                 ;1ebb 00
    nop                 ;1ebc 00
    nop                 ;1ebd 00
    nop                 ;1ebe 00
    nop                 ;1ebf 00
    nop                 ;1ec0 00
    nop                 ;1ec1 00
    nop                 ;1ec2 00
    nop                 ;1ec3 00
    nop                 ;1ec4 00
    nop                 ;1ec5 00
    nop                 ;1ec6 00
    nop                 ;1ec7 00
    nop                 ;1ec8 00
    nop                 ;1ec9 00
    nop                 ;1eca 00
    nop                 ;1ecb 00
    nop                 ;1ecc 00
    nop                 ;1ecd 00
    nop                 ;1ece 00
    nop                 ;1ecf 00
    nop                 ;1ed0 00
    nop                 ;1ed1 00
    nop                 ;1ed2 00
    nop                 ;1ed3 00
    nop                 ;1ed4 00
    nop                 ;1ed5 00
    nop                 ;1ed6 00
    nop                 ;1ed7 00
    nop                 ;1ed8 00
    nop                 ;1ed9 00
    nop                 ;1eda 00
    nop                 ;1edb 00
    nop                 ;1edc 00
    nop                 ;1edd 00
    nop                 ;1ede 00
    nop                 ;1edf 00
    nop                 ;1ee0 00
    nop                 ;1ee1 00
    nop                 ;1ee2 00
    nop                 ;1ee3 00
    nop                 ;1ee4 00
    nop                 ;1ee5 00
    nop                 ;1ee6 00
    nop                 ;1ee7 00
    nop                 ;1ee8 00
    nop                 ;1ee9 00
    nop                 ;1eea 00
    nop                 ;1eeb 00
    nop                 ;1eec 00
    nop                 ;1eed 00
    nop                 ;1eee 00
    nop                 ;1eef 00
    nop                 ;1ef0 00
    nop                 ;1ef1 00
    nop                 ;1ef2 00
    nop                 ;1ef3 00
    nop                 ;1ef4 00
    nop                 ;1ef5 00
    nop                 ;1ef6 00
    nop                 ;1ef7 00
    nop                 ;1ef8 00
    nop                 ;1ef9 00
    nop                 ;1efa 00
    nop                 ;1efb 00
    nop                 ;1efc 00
    nop                 ;1efd 00
    nop                 ;1efe 00
    nop                 ;1eff 00
    nop                 ;1f00 00
    nop                 ;1f01 00
    nop                 ;1f02 00
    nop                 ;1f03 00
    nop                 ;1f04 00
    nop                 ;1f05 00
    nop                 ;1f06 00
    nop                 ;1f07 00
    nop                 ;1f08 00
    nop                 ;1f09 00
    nop                 ;1f0a 00
    nop                 ;1f0b 00
    nop                 ;1f0c 00
    nop                 ;1f0d 00
    nop                 ;1f0e 00
    nop                 ;1f0f 00
    nop                 ;1f10 00
    nop                 ;1f11 00
    nop                 ;1f12 00
    nop                 ;1f13 00
    nop                 ;1f14 00
    nop                 ;1f15 00
    nop                 ;1f16 00
    nop                 ;1f17 00
    nop                 ;1f18 00
    nop                 ;1f19 00
    nop                 ;1f1a 00
    nop                 ;1f1b 00
    nop                 ;1f1c 00
    nop                 ;1f1d 00
    nop                 ;1f1e 00
    nop                 ;1f1f 00
    nop                 ;1f20 00
    nop                 ;1f21 00
    nop                 ;1f22 00
    nop                 ;1f23 00
    nop                 ;1f24 00
    nop                 ;1f25 00
    nop                 ;1f26 00
    nop                 ;1f27 00
    nop                 ;1f28 00
    nop                 ;1f29 00
    nop                 ;1f2a 00
    nop                 ;1f2b 00
    nop                 ;1f2c 00
    nop                 ;1f2d 00
    nop                 ;1f2e 00
    nop                 ;1f2f 00
    nop                 ;1f30 00
    nop                 ;1f31 00
    nop                 ;1f32 00
    nop                 ;1f33 00
    nop                 ;1f34 00
    nop                 ;1f35 00
    nop                 ;1f36 00
    nop                 ;1f37 00
    nop                 ;1f38 00
    nop                 ;1f39 00
    nop                 ;1f3a 00
    nop                 ;1f3b 00
    nop                 ;1f3c 00
    nop                 ;1f3d 00
    nop                 ;1f3e 00
    nop                 ;1f3f 00
    nop                 ;1f40 00
    nop                 ;1f41 00
    nop                 ;1f42 00
    nop                 ;1f43 00
    nop                 ;1f44 00
    nop                 ;1f45 00
    nop                 ;1f46 00
    nop                 ;1f47 00
    nop                 ;1f48 00
    nop                 ;1f49 00
    nop                 ;1f4a 00
    nop                 ;1f4b 00
    nop                 ;1f4c 00
    nop                 ;1f4d 00
    nop                 ;1f4e 00
    nop                 ;1f4f 00
    nop                 ;1f50 00
    nop                 ;1f51 00
    nop                 ;1f52 00
    nop                 ;1f53 00
    nop                 ;1f54 00
    nop                 ;1f55 00
    nop                 ;1f56 00
    nop                 ;1f57 00
    nop                 ;1f58 00
    nop                 ;1f59 00
    nop                 ;1f5a 00
    nop                 ;1f5b 00
    nop                 ;1f5c 00
    nop                 ;1f5d 00
    nop                 ;1f5e 00
    nop                 ;1f5f 00
    nop                 ;1f60 00
    nop                 ;1f61 00
    nop                 ;1f62 00
    nop                 ;1f63 00
    nop                 ;1f64 00
    nop                 ;1f65 00
    nop                 ;1f66 00
    nop                 ;1f67 00
    nop                 ;1f68 00
    nop                 ;1f69 00
    nop                 ;1f6a 00
    nop                 ;1f6b 00
    nop                 ;1f6c 00
    nop                 ;1f6d 00
    nop                 ;1f6e 00
    nop                 ;1f6f 00
    nop                 ;1f70 00
    nop                 ;1f71 00
    nop                 ;1f72 00
    nop                 ;1f73 00
    nop                 ;1f74 00
    nop                 ;1f75 00
    nop                 ;1f76 00
    nop                 ;1f77 00
    nop                 ;1f78 00
    nop                 ;1f79 00
    nop                 ;1f7a 00
    nop                 ;1f7b 00
    nop                 ;1f7c 00
    nop                 ;1f7d 00
    nop                 ;1f7e 00
    nop                 ;1f7f 00
    nop                 ;1f80 00
    nop                 ;1f81 00
    nop                 ;1f82 00
    nop                 ;1f83 00
    nop                 ;1f84 00
    nop                 ;1f85 00
    nop                 ;1f86 00
    nop                 ;1f87 00
    nop                 ;1f88 00
    nop                 ;1f89 00
    nop                 ;1f8a 00
    nop                 ;1f8b 00
    nop                 ;1f8c 00
    nop                 ;1f8d 00
    nop                 ;1f8e 00
    nop                 ;1f8f 00
    nop                 ;1f90 00
    nop                 ;1f91 00
    nop                 ;1f92 00
    nop                 ;1f93 00
    nop                 ;1f94 00
    nop                 ;1f95 00
    nop                 ;1f96 00
    nop                 ;1f97 00
    nop                 ;1f98 00
    nop                 ;1f99 00
    nop                 ;1f9a 00
    nop                 ;1f9b 00
    nop                 ;1f9c 00
    nop                 ;1f9d 00
    nop                 ;1f9e 00
    nop                 ;1f9f 00
    nop                 ;1fa0 00
    nop                 ;1fa1 00
    nop                 ;1fa2 00
    nop                 ;1fa3 00
    nop                 ;1fa4 00
    nop                 ;1fa5 00
    nop                 ;1fa6 00
    nop                 ;1fa7 00
    nop                 ;1fa8 00
    nop                 ;1fa9 00
    nop                 ;1faa 00
    nop                 ;1fab 00
    nop                 ;1fac 00
    nop                 ;1fad 00
    nop                 ;1fae 00
    nop                 ;1faf 00
    nop                 ;1fb0 00
    nop                 ;1fb1 00
    nop                 ;1fb2 00
    nop                 ;1fb3 00
    nop                 ;1fb4 00
    nop                 ;1fb5 00
    nop                 ;1fb6 00
    nop                 ;1fb7 00
    nop                 ;1fb8 00
    nop                 ;1fb9 00
    nop                 ;1fba 00
    nop                 ;1fbb 00
    nop                 ;1fbc 00
    nop                 ;1fbd 00
    nop                 ;1fbe 00
    nop                 ;1fbf 00
    nop                 ;1fc0 00
    nop                 ;1fc1 00
    nop                 ;1fc2 00
    nop                 ;1fc3 00
    nop                 ;1fc4 00
    nop                 ;1fc5 00
    nop                 ;1fc6 00
    nop                 ;1fc7 00
    nop                 ;1fc8 00
    nop                 ;1fc9 00
    nop                 ;1fca 00
    nop                 ;1fcb 00
    nop                 ;1fcc 00
    nop                 ;1fcd 00
    nop                 ;1fce 00
    nop                 ;1fcf 00
    nop                 ;1fd0 00
    nop                 ;1fd1 00
    nop                 ;1fd2 00
    nop                 ;1fd3 00
    nop                 ;1fd4 00
    nop                 ;1fd5 00
    nop                 ;1fd6 00
    nop                 ;1fd7 00
    nop                 ;1fd8 00
    nop                 ;1fd9 00
    nop                 ;1fda 00
    nop                 ;1fdb 00
    nop                 ;1fdc 00
    nop                 ;1fdd 00
    nop                 ;1fde 00
    nop                 ;1fdf 00
    nop                 ;1fe0 00
    nop                 ;1fe1 00
    nop                 ;1fe2 00
    nop                 ;1fe3 00
    nop                 ;1fe4 00
    nop                 ;1fe5 00
    nop                 ;1fe6 00
    nop                 ;1fe7 00
    nop                 ;1fe8 00
    nop                 ;1fe9 00
    nop                 ;1fea 00
    nop                 ;1feb 00
    nop                 ;1fec 00
    nop                 ;1fed 00
    nop                 ;1fee 00
    nop                 ;1fef 00
    nop                 ;1ff0 00
    nop                 ;1ff1 00
    nop                 ;1ff2 00
    nop                 ;1ff3 00
    nop                 ;1ff4 00
    nop                 ;1ff5 00
    nop                 ;1ff6 00
    nop                 ;1ff7 00
    nop                 ;1ff8 00
    nop                 ;1ff9 00
    nop                 ;1ffa 00
    nop                 ;1ffb 00
    nop                 ;1ffc 00
    nop                 ;1ffd 00
    nop                 ;1ffe 00
    nop                 ;1fff 00
    nop                 ;2000 00
    nop                 ;2001 00
    nop                 ;2002 00
    nop                 ;2003 00
    nop                 ;2004 00
    nop                 ;2005 00
    nop                 ;2006 00
    nop                 ;2007 00
    nop                 ;2008 00
    nop                 ;2009 00
    nop                 ;200a 00
    nop                 ;200b 00
    nop                 ;200c 00
    nop                 ;200d 00
    nop                 ;200e 00
    nop                 ;200f 00
    nop                 ;2010 00
    nop                 ;2011 00
    nop                 ;2012 00
    nop                 ;2013 00
    nop                 ;2014 00
    nop                 ;2015 00
    nop                 ;2016 00
    nop                 ;2017 00
    nop                 ;2018 00
    nop                 ;2019 00
    nop                 ;201a 00
    nop                 ;201b 00
    nop                 ;201c 00
    nop                 ;201d 00
    nop                 ;201e 00
    nop                 ;201f 00
    nop                 ;2020 00
    nop                 ;2021 00
    nop                 ;2022 00
    nop                 ;2023 00
    nop                 ;2024 00
    nop                 ;2025 00
    nop                 ;2026 00
    nop                 ;2027 00
    nop                 ;2028 00
    nop                 ;2029 00
    nop                 ;202a 00
    nop                 ;202b 00
    nop                 ;202c 00
    nop                 ;202d 00
    nop                 ;202e 00
    nop                 ;202f 00
    nop                 ;2030 00
    nop                 ;2031 00
    nop                 ;2032 00
    nop                 ;2033 00
    nop                 ;2034 00
    nop                 ;2035 00
    nop                 ;2036 00
    nop                 ;2037 00
    nop                 ;2038 00
    nop                 ;2039 00
    nop                 ;203a 00
    nop                 ;203b 00
    nop                 ;203c 00
    nop                 ;203d 00
    nop                 ;203e 00
    nop                 ;203f 00
    nop                 ;2040 00
    nop                 ;2041 00
    nop                 ;2042 00
    nop                 ;2043 00
    nop                 ;2044 00
    nop                 ;2045 00
    nop                 ;2046 00
    nop                 ;2047 00
    nop                 ;2048 00
    nop                 ;2049 00
    nop                 ;204a 00
    nop                 ;204b 00
    nop                 ;204c 00
    nop                 ;204d 00
    nop                 ;204e 00
    nop                 ;204f 00
    nop                 ;2050 00
    nop                 ;2051 00
    nop                 ;2052 00
    nop                 ;2053 00
    nop                 ;2054 00
    nop                 ;2055 00
    nop                 ;2056 00
    nop                 ;2057 00
    nop                 ;2058 00
    nop                 ;2059 00
    nop                 ;205a 00
    nop                 ;205b 00
    nop                 ;205c 00
    nop                 ;205d 00
    nop                 ;205e 00
    nop                 ;205f 00
    nop                 ;2060 00
    nop                 ;2061 00
    nop                 ;2062 00
    nop                 ;2063 00
    nop                 ;2064 00
    nop                 ;2065 00
    nop                 ;2066 00
    nop                 ;2067 00
    nop                 ;2068 00
    nop                 ;2069 00
    nop                 ;206a 00
    nop                 ;206b 00
    nop                 ;206c 00
    nop                 ;206d 00
    nop                 ;206e 00
    nop                 ;206f 00
    nop                 ;2070 00
    nop                 ;2071 00
    nop                 ;2072 00
    nop                 ;2073 00
    nop                 ;2074 00
    nop                 ;2075 00
    nop                 ;2076 00
    nop                 ;2077 00
    nop                 ;2078 00
    nop                 ;2079 00
    nop                 ;207a 00
    nop                 ;207b 00
    nop                 ;207c 00
    nop                 ;207d 00
    nop                 ;207e 00
    nop                 ;207f 00
    nop                 ;2080 00
    nop                 ;2081 00
    nop                 ;2082 00
    nop                 ;2083 00
    nop                 ;2084 00
    nop                 ;2085 00
    nop                 ;2086 00
    nop                 ;2087 00
    nop                 ;2088 00
    nop                 ;2089 00
    nop                 ;208a 00
    nop                 ;208b 00
    nop                 ;208c 00
    nop                 ;208d 00
    nop                 ;208e 00
    nop                 ;208f 00
    nop                 ;2090 00
    nop                 ;2091 00
    nop                 ;2092 00
    nop                 ;2093 00
    nop                 ;2094 00
    nop                 ;2095 00
    nop                 ;2096 00
    nop                 ;2097 00
    nop                 ;2098 00
    nop                 ;2099 00
    nop                 ;209a 00
    nop                 ;209b 00
    nop                 ;209c 00
    nop                 ;209d 00
    nop                 ;209e 00
    nop                 ;209f 00
    nop                 ;20a0 00
    nop                 ;20a1 00
    nop                 ;20a2 00
    nop                 ;20a3 00
    nop                 ;20a4 00
    nop                 ;20a5 00
    nop                 ;20a6 00
    nop                 ;20a7 00
    nop                 ;20a8 00
    nop                 ;20a9 00
    nop                 ;20aa 00
    nop                 ;20ab 00
    nop                 ;20ac 00
    nop                 ;20ad 00
    nop                 ;20ae 00
    nop                 ;20af 00
    nop                 ;20b0 00
    nop                 ;20b1 00
    nop                 ;20b2 00
    nop                 ;20b3 00
    nop                 ;20b4 00
    nop                 ;20b5 00
    nop                 ;20b6 00
    nop                 ;20b7 00
    nop                 ;20b8 00
    nop                 ;20b9 00
    nop                 ;20ba 00
    nop                 ;20bb 00
    nop                 ;20bc 00
    nop                 ;20bd 00
    nop                 ;20be 00
    nop                 ;20bf 00
    nop                 ;20c0 00
    nop                 ;20c1 00
    nop                 ;20c2 00
    nop                 ;20c3 00
    nop                 ;20c4 00
    nop                 ;20c5 00
    nop                 ;20c6 00
    nop                 ;20c7 00
    nop                 ;20c8 00
    nop                 ;20c9 00
    nop                 ;20ca 00
    nop                 ;20cb 00
    nop                 ;20cc 00
    nop                 ;20cd 00
    nop                 ;20ce 00
    nop                 ;20cf 00
    nop                 ;20d0 00
    nop                 ;20d1 00
    nop                 ;20d2 00
    nop                 ;20d3 00
    nop                 ;20d4 00
    nop                 ;20d5 00
    nop                 ;20d6 00
    nop                 ;20d7 00
    nop                 ;20d8 00
    nop                 ;20d9 00
    nop                 ;20da 00
    nop                 ;20db 00
    nop                 ;20dc 00
    nop                 ;20dd 00
    nop                 ;20de 00
    nop                 ;20df 00
    nop                 ;20e0 00
    nop                 ;20e1 00
    nop                 ;20e2 00
    nop                 ;20e3 00
    nop                 ;20e4 00
    nop                 ;20e5 00
    nop                 ;20e6 00
    nop                 ;20e7 00
    nop                 ;20e8 00
    nop                 ;20e9 00
    nop                 ;20ea 00
    nop                 ;20eb 00
    nop                 ;20ec 00
    nop                 ;20ed 00
    nop                 ;20ee 00
    nop                 ;20ef 00
    nop                 ;20f0 00
    nop                 ;20f1 00
    nop                 ;20f2 00
    nop                 ;20f3 00
    nop                 ;20f4 00
    nop                 ;20f5 00
    nop                 ;20f6 00
    nop                 ;20f7 00
    nop                 ;20f8 00
    nop                 ;20f9 00
    nop                 ;20fa 00
    nop                 ;20fb 00
    nop                 ;20fc 00
    nop                 ;20fd 00
    nop                 ;20fe 00
    nop                 ;20ff 00
    nop                 ;2100 00
    nop                 ;2101 00
    nop                 ;2102 00
    nop                 ;2103 00
    nop                 ;2104 00
    nop                 ;2105 00
    nop                 ;2106 00
    nop                 ;2107 00
    nop                 ;2108 00
    nop                 ;2109 00
    nop                 ;210a 00
    nop                 ;210b 00
    nop                 ;210c 00
    nop                 ;210d 00
    nop                 ;210e 00
    nop                 ;210f 00
    nop                 ;2110 00
    nop                 ;2111 00
    nop                 ;2112 00
    nop                 ;2113 00
    nop                 ;2114 00
    nop                 ;2115 00
    nop                 ;2116 00
    nop                 ;2117 00
    nop                 ;2118 00
    nop                 ;2119 00
    nop                 ;211a 00
    nop                 ;211b 00
    nop                 ;211c 00
    nop                 ;211d 00
    nop                 ;211e 00
    nop                 ;211f 00
    nop                 ;2120 00
    nop                 ;2121 00
    nop                 ;2122 00
    nop                 ;2123 00
    nop                 ;2124 00
    nop                 ;2125 00
    nop                 ;2126 00
    nop                 ;2127 00
    nop                 ;2128 00
    nop                 ;2129 00
    nop                 ;212a 00
    nop                 ;212b 00
    nop                 ;212c 00
    nop                 ;212d 00
    nop                 ;212e 00
    nop                 ;212f 00
    nop                 ;2130 00
    nop                 ;2131 00
    nop                 ;2132 00
    nop                 ;2133 00
    nop                 ;2134 00
    nop                 ;2135 00
    nop                 ;2136 00
    nop                 ;2137 00
    nop                 ;2138 00
    nop                 ;2139 00
    nop                 ;213a 00
    nop                 ;213b 00
    nop                 ;213c 00
    nop                 ;213d 00
    nop                 ;213e 00
    nop                 ;213f 00
    nop                 ;2140 00
    nop                 ;2141 00
    nop                 ;2142 00
    nop                 ;2143 00
    nop                 ;2144 00
    nop                 ;2145 00
    nop                 ;2146 00
    nop                 ;2147 00
    nop                 ;2148 00
    nop                 ;2149 00
    nop                 ;214a 00
    nop                 ;214b 00
    nop                 ;214c 00
    nop                 ;214d 00
    nop                 ;214e 00
    nop                 ;214f 00
    nop                 ;2150 00
    nop                 ;2151 00
    nop                 ;2152 00
    nop                 ;2153 00
    nop                 ;2154 00
    nop                 ;2155 00
    nop                 ;2156 00
    nop                 ;2157 00
    nop                 ;2158 00
    nop                 ;2159 00
    nop                 ;215a 00
    nop                 ;215b 00
    nop                 ;215c 00
    nop                 ;215d 00
    nop                 ;215e 00
    nop                 ;215f 00
    nop                 ;2160 00
    nop                 ;2161 00
    nop                 ;2162 00
    nop                 ;2163 00
    nop                 ;2164 00
    nop                 ;2165 00
    nop                 ;2166 00
    nop                 ;2167 00
    nop                 ;2168 00
    nop                 ;2169 00
    nop                 ;216a 00
    nop                 ;216b 00
    nop                 ;216c 00
    nop                 ;216d 00
    nop                 ;216e 00
    nop                 ;216f 00
    nop                 ;2170 00
    nop                 ;2171 00
    nop                 ;2172 00
    nop                 ;2173 00
    nop                 ;2174 00
    nop                 ;2175 00
    nop                 ;2176 00
    nop                 ;2177 00
    nop                 ;2178 00
    nop                 ;2179 00
    nop                 ;217a 00
    nop                 ;217b 00
    nop                 ;217c 00
    nop                 ;217d 00
    nop                 ;217e 00
    nop                 ;217f 00
    nop                 ;2180 00
    nop                 ;2181 00
    nop                 ;2182 00
    nop                 ;2183 00
    nop                 ;2184 00
    nop                 ;2185 00
    nop                 ;2186 00
    nop                 ;2187 00
    nop                 ;2188 00
    nop                 ;2189 00
    nop                 ;218a 00
    nop                 ;218b 00
    nop                 ;218c 00
    nop                 ;218d 00
    nop                 ;218e 00
    nop                 ;218f 00
    nop                 ;2190 00
    nop                 ;2191 00
    nop                 ;2192 00
    nop                 ;2193 00
    nop                 ;2194 00
    nop                 ;2195 00
    nop                 ;2196 00
    nop                 ;2197 00
    nop                 ;2198 00
    nop                 ;2199 00
    nop                 ;219a 00
    nop                 ;219b 00
    nop                 ;219c 00
    nop                 ;219d 00
    nop                 ;219e 00
    nop                 ;219f 00
    nop                 ;21a0 00
    nop                 ;21a1 00
    nop                 ;21a2 00
    nop                 ;21a3 00
    nop                 ;21a4 00
    nop                 ;21a5 00
    nop                 ;21a6 00
    nop                 ;21a7 00
    nop                 ;21a8 00
    nop                 ;21a9 00
    nop                 ;21aa 00
    nop                 ;21ab 00
    nop                 ;21ac 00
    nop                 ;21ad 00
    nop                 ;21ae 00
    nop                 ;21af 00
    nop                 ;21b0 00
    nop                 ;21b1 00
    nop                 ;21b2 00
    nop                 ;21b3 00
    nop                 ;21b4 00
    nop                 ;21b5 00
    nop                 ;21b6 00
    nop                 ;21b7 00
    nop                 ;21b8 00
    nop                 ;21b9 00
    nop                 ;21ba 00
    nop                 ;21bb 00
    nop                 ;21bc 00
    nop                 ;21bd 00
    nop                 ;21be 00
    nop                 ;21bf 00
    nop                 ;21c0 00
    nop                 ;21c1 00
    nop                 ;21c2 00
    nop                 ;21c3 00
    nop                 ;21c4 00
    nop                 ;21c5 00
    nop                 ;21c6 00
    nop                 ;21c7 00
    nop                 ;21c8 00
    nop                 ;21c9 00
    nop                 ;21ca 00
    nop                 ;21cb 00
    nop                 ;21cc 00
    nop                 ;21cd 00
    nop                 ;21ce 00
    nop                 ;21cf 00
    nop                 ;21d0 00
    nop                 ;21d1 00
    nop                 ;21d2 00
    nop                 ;21d3 00
    nop                 ;21d4 00
    nop                 ;21d5 00
    nop                 ;21d6 00
    nop                 ;21d7 00
    nop                 ;21d8 00
    nop                 ;21d9 00
    nop                 ;21da 00
    nop                 ;21db 00
    nop                 ;21dc 00
    nop                 ;21dd 00
    nop                 ;21de 00
    nop                 ;21df 00
    nop                 ;21e0 00
    nop                 ;21e1 00
    nop                 ;21e2 00
    nop                 ;21e3 00
    nop                 ;21e4 00
    nop                 ;21e5 00
    nop                 ;21e6 00
    nop                 ;21e7 00
    nop                 ;21e8 00
    nop                 ;21e9 00
    nop                 ;21ea 00
    nop                 ;21eb 00
    nop                 ;21ec 00
    nop                 ;21ed 00
    nop                 ;21ee 00
    nop                 ;21ef 00
    nop                 ;21f0 00
    nop                 ;21f1 00
    nop                 ;21f2 00
    nop                 ;21f3 00
    nop                 ;21f4 00
    nop                 ;21f5 00
    nop                 ;21f6 00
    nop                 ;21f7 00
    nop                 ;21f8 00
    nop                 ;21f9 00
    nop                 ;21fa 00
    nop                 ;21fb 00
    nop                 ;21fc 00
    nop                 ;21fd 00
    nop                 ;21fe 00
    nop                 ;21ff 00
    nop                 ;2200 00
    nop                 ;2201 00
    nop                 ;2202 00
    nop                 ;2203 00
    nop                 ;2204 00
    nop                 ;2205 00
    nop                 ;2206 00
    nop                 ;2207 00
    nop                 ;2208 00
    nop                 ;2209 00
    nop                 ;220a 00
    nop                 ;220b 00
    nop                 ;220c 00
    nop                 ;220d 00
    nop                 ;220e 00
    nop                 ;220f 00
    nop                 ;2210 00
    nop                 ;2211 00
    nop                 ;2212 00
    nop                 ;2213 00
    nop                 ;2214 00
    nop                 ;2215 00
    nop                 ;2216 00
    nop                 ;2217 00
    nop                 ;2218 00
    nop                 ;2219 00
    nop                 ;221a 00
    nop                 ;221b 00
    nop                 ;221c 00
    nop                 ;221d 00
    nop                 ;221e 00
    nop                 ;221f 00
    nop                 ;2220 00
    nop                 ;2221 00
    nop                 ;2222 00
    nop                 ;2223 00
    nop                 ;2224 00
    nop                 ;2225 00
    nop                 ;2226 00
    nop                 ;2227 00
    nop                 ;2228 00
    nop                 ;2229 00
    nop                 ;222a 00
    nop                 ;222b 00
    nop                 ;222c 00
    nop                 ;222d 00
    nop                 ;222e 00
    nop                 ;222f 00
    nop                 ;2230 00
    nop                 ;2231 00
    nop                 ;2232 00
    nop                 ;2233 00
    nop                 ;2234 00
    nop                 ;2235 00
    nop                 ;2236 00
    nop                 ;2237 00
    nop                 ;2238 00
    nop                 ;2239 00
    nop                 ;223a 00
    nop                 ;223b 00
    nop                 ;223c 00
    nop                 ;223d 00
    nop                 ;223e 00
    nop                 ;223f 00
    nop                 ;2240 00
    nop                 ;2241 00
    nop                 ;2242 00
    nop                 ;2243 00
    nop                 ;2244 00
    nop                 ;2245 00
    nop                 ;2246 00
    nop                 ;2247 00
    nop                 ;2248 00
    nop                 ;2249 00
    nop                 ;224a 00
    nop                 ;224b 00
    nop                 ;224c 00
    nop                 ;224d 00
    nop                 ;224e 00
    nop                 ;224f 00
    nop                 ;2250 00
    nop                 ;2251 00
    nop                 ;2252 00
    nop                 ;2253 00
    nop                 ;2254 00
    nop                 ;2255 00
    nop                 ;2256 00
    nop                 ;2257 00
    nop                 ;2258 00
    nop                 ;2259 00
    nop                 ;225a 00
    nop                 ;225b 00
    nop                 ;225c 00
    nop                 ;225d 00
    nop                 ;225e 00
    nop                 ;225f 00
    nop                 ;2260 00
    nop                 ;2261 00
    nop                 ;2262 00
    nop                 ;2263 00
    nop                 ;2264 00
    nop                 ;2265 00
    nop                 ;2266 00
    nop                 ;2267 00
    nop                 ;2268 00
    nop                 ;2269 00
    nop                 ;226a 00
    nop                 ;226b 00
    nop                 ;226c 00
    nop                 ;226d 00
    nop                 ;226e 00
    nop                 ;226f 00
    nop                 ;2270 00
    nop                 ;2271 00
    nop                 ;2272 00
    nop                 ;2273 00
    nop                 ;2274 00
    nop                 ;2275 00
    nop                 ;2276 00
    nop                 ;2277 00
    nop                 ;2278 00
    nop                 ;2279 00
    nop                 ;227a 00
    nop                 ;227b 00
    nop                 ;227c 00
    nop                 ;227d 00
    nop                 ;227e 00
    nop                 ;227f 00
    nop                 ;2280 00
    nop                 ;2281 00
    nop                 ;2282 00
    nop                 ;2283 00
    nop                 ;2284 00
    nop                 ;2285 00
    nop                 ;2286 00
    nop                 ;2287 00
    nop                 ;2288 00
    nop                 ;2289 00
    nop                 ;228a 00
    nop                 ;228b 00
    nop                 ;228c 00
    nop                 ;228d 00
    nop                 ;228e 00
    nop                 ;228f 00
    nop                 ;2290 00
    nop                 ;2291 00
    nop                 ;2292 00
    nop                 ;2293 00
    nop                 ;2294 00
    nop                 ;2295 00
    nop                 ;2296 00
    nop                 ;2297 00
    nop                 ;2298 00
    nop                 ;2299 00
    nop                 ;229a 00
    nop                 ;229b 00
    nop                 ;229c 00
    nop                 ;229d 00
    nop                 ;229e 00
    nop                 ;229f 00
    nop                 ;22a0 00
    nop                 ;22a1 00
    nop                 ;22a2 00
    nop                 ;22a3 00
    nop                 ;22a4 00
    nop                 ;22a5 00
    nop                 ;22a6 00
    nop                 ;22a7 00
    nop                 ;22a8 00
    nop                 ;22a9 00
    nop                 ;22aa 00
    nop                 ;22ab 00
    nop                 ;22ac 00
    nop                 ;22ad 00
    nop                 ;22ae 00
    nop                 ;22af 00
    nop                 ;22b0 00
    nop                 ;22b1 00
    nop                 ;22b2 00
    nop                 ;22b3 00
    nop                 ;22b4 00
    nop                 ;22b5 00
    nop                 ;22b6 00
    nop                 ;22b7 00
    nop                 ;22b8 00
    nop                 ;22b9 00
    nop                 ;22ba 00
    nop                 ;22bb 00
    nop                 ;22bc 00
    nop                 ;22bd 00
    nop                 ;22be 00
    nop                 ;22bf 00
    nop                 ;22c0 00
    nop                 ;22c1 00
    nop                 ;22c2 00
    nop                 ;22c3 00
    nop                 ;22c4 00
    nop                 ;22c5 00
    nop                 ;22c6 00
    nop                 ;22c7 00
    nop                 ;22c8 00
    nop                 ;22c9 00
    nop                 ;22ca 00
    nop                 ;22cb 00
    nop                 ;22cc 00
    nop                 ;22cd 00
    nop                 ;22ce 00
    nop                 ;22cf 00
    nop                 ;22d0 00
    nop                 ;22d1 00
    nop                 ;22d2 00
    nop                 ;22d3 00
    nop                 ;22d4 00
    nop                 ;22d5 00
    nop                 ;22d6 00
    nop                 ;22d7 00
    nop                 ;22d8 00
    nop                 ;22d9 00
    nop                 ;22da 00
    nop                 ;22db 00
    nop                 ;22dc 00
    nop                 ;22dd 00
    nop                 ;22de 00
    nop                 ;22df 00
    nop                 ;22e0 00
    nop                 ;22e1 00
    nop                 ;22e2 00
    nop                 ;22e3 00
    nop                 ;22e4 00
    nop                 ;22e5 00
    nop                 ;22e6 00
    nop                 ;22e7 00
    nop                 ;22e8 00
    nop                 ;22e9 00
    nop                 ;22ea 00
    nop                 ;22eb 00
    nop                 ;22ec 00
    nop                 ;22ed 00
    nop                 ;22ee 00
    nop                 ;22ef 00
    nop                 ;22f0 00
    nop                 ;22f1 00
    nop                 ;22f2 00
    nop                 ;22f3 00
    nop                 ;22f4 00
    nop                 ;22f5 00
    nop                 ;22f6 00
    nop                 ;22f7 00
    nop                 ;22f8 00
    nop                 ;22f9 00
    nop                 ;22fa 00
    nop                 ;22fb 00
    nop                 ;22fc 00
    nop                 ;22fd 00
    nop                 ;22fe 00
    nop                 ;22ff 00
    nop                 ;2300 00
    nop                 ;2301 00
    nop                 ;2302 00
    nop                 ;2303 00
    nop                 ;2304 00
    nop                 ;2305 00
    nop                 ;2306 00
    nop                 ;2307 00
    nop                 ;2308 00
    nop                 ;2309 00
    nop                 ;230a 00
    nop                 ;230b 00
    nop                 ;230c 00
    nop                 ;230d 00
    nop                 ;230e 00
    nop                 ;230f 00
    nop                 ;2310 00
    nop                 ;2311 00
    nop                 ;2312 00
    nop                 ;2313 00
    nop                 ;2314 00
    nop                 ;2315 00
    nop                 ;2316 00
    nop                 ;2317 00
    nop                 ;2318 00
    nop                 ;2319 00
    nop                 ;231a 00
    nop                 ;231b 00
    nop                 ;231c 00
    nop                 ;231d 00
    nop                 ;231e 00
    nop                 ;231f 00
    nop                 ;2320 00
    nop                 ;2321 00
    nop                 ;2322 00
    nop                 ;2323 00
    nop                 ;2324 00
    nop                 ;2325 00
    nop                 ;2326 00
    nop                 ;2327 00
    nop                 ;2328 00
    nop                 ;2329 00
    nop                 ;232a 00
    nop                 ;232b 00
    nop                 ;232c 00
    nop                 ;232d 00
    nop                 ;232e 00
    nop                 ;232f 00
    nop                 ;2330 00
    nop                 ;2331 00
    nop                 ;2332 00
    nop                 ;2333 00
    nop                 ;2334 00
    nop                 ;2335 00
    nop                 ;2336 00
    nop                 ;2337 00
    nop                 ;2338 00
    nop                 ;2339 00
    nop                 ;233a 00
    nop                 ;233b 00
    nop                 ;233c 00
    nop                 ;233d 00
    nop                 ;233e 00
    nop                 ;233f 00
    nop                 ;2340 00
    nop                 ;2341 00
    nop                 ;2342 00
    nop                 ;2343 00
    nop                 ;2344 00
    nop                 ;2345 00
    nop                 ;2346 00
    nop                 ;2347 00
    nop                 ;2348 00
    nop                 ;2349 00
    nop                 ;234a 00
    nop                 ;234b 00
    nop                 ;234c 00
    nop                 ;234d 00
    nop                 ;234e 00
    nop                 ;234f 00
    nop                 ;2350 00
    nop                 ;2351 00
    nop                 ;2352 00
    nop                 ;2353 00
    nop                 ;2354 00
    nop                 ;2355 00
    nop                 ;2356 00
    nop                 ;2357 00
    nop                 ;2358 00
    nop                 ;2359 00
    nop                 ;235a 00
    nop                 ;235b 00
    nop                 ;235c 00
    nop                 ;235d 00
    nop                 ;235e 00
    nop                 ;235f 00
    nop                 ;2360 00
    nop                 ;2361 00
    nop                 ;2362 00
    nop                 ;2363 00
    nop                 ;2364 00
    nop                 ;2365 00
    nop                 ;2366 00
    nop                 ;2367 00
    nop                 ;2368 00
    nop                 ;2369 00
    nop                 ;236a 00
    nop                 ;236b 00
    nop                 ;236c 00
    nop                 ;236d 00
    nop                 ;236e 00
    nop                 ;236f 00
    nop                 ;2370 00
    nop                 ;2371 00
    nop                 ;2372 00
    nop                 ;2373 00
    nop                 ;2374 00
    nop                 ;2375 00
    nop                 ;2376 00
    nop                 ;2377 00
    nop                 ;2378 00
    nop                 ;2379 00
    nop                 ;237a 00
    nop                 ;237b 00
    nop                 ;237c 00
    nop                 ;237d 00
    nop                 ;237e 00
    nop                 ;237f 00
    nop                 ;2380 00
    nop                 ;2381 00
    nop                 ;2382 00
    nop                 ;2383 00
    nop                 ;2384 00
    nop                 ;2385 00
    nop                 ;2386 00
    nop                 ;2387 00
    nop                 ;2388 00
    nop                 ;2389 00
    nop                 ;238a 00
    nop                 ;238b 00
    nop                 ;238c 00
    nop                 ;238d 00
    nop                 ;238e 00
    nop                 ;238f 00
    nop                 ;2390 00
    nop                 ;2391 00
    nop                 ;2392 00
    nop                 ;2393 00
    nop                 ;2394 00
    nop                 ;2395 00
    nop                 ;2396 00
    nop                 ;2397 00
    nop                 ;2398 00
    nop                 ;2399 00
    nop                 ;239a 00
    nop                 ;239b 00
    nop                 ;239c 00
    nop                 ;239d 00
    nop                 ;239e 00
    nop                 ;239f 00
    nop                 ;23a0 00
    nop                 ;23a1 00
    nop                 ;23a2 00
    nop                 ;23a3 00
    nop                 ;23a4 00
    nop                 ;23a5 00
    nop                 ;23a6 00
    nop                 ;23a7 00
    nop                 ;23a8 00
    nop                 ;23a9 00
    nop                 ;23aa 00
    nop                 ;23ab 00
    nop                 ;23ac 00
    nop                 ;23ad 00
    nop                 ;23ae 00
    nop                 ;23af 00
    nop                 ;23b0 00
    nop                 ;23b1 00
    nop                 ;23b2 00
    nop                 ;23b3 00
    nop                 ;23b4 00
    nop                 ;23b5 00
    nop                 ;23b6 00
    nop                 ;23b7 00
    nop                 ;23b8 00
    nop                 ;23b9 00
    nop                 ;23ba 00
    nop                 ;23bb 00
    nop                 ;23bc 00
    nop                 ;23bd 00
    nop                 ;23be 00
    nop                 ;23bf 00
    nop                 ;23c0 00
    nop                 ;23c1 00
    nop                 ;23c2 00
    nop                 ;23c3 00
    nop                 ;23c4 00
    nop                 ;23c5 00
    nop                 ;23c6 00
    nop                 ;23c7 00
    nop                 ;23c8 00
    nop                 ;23c9 00
    nop                 ;23ca 00
    nop                 ;23cb 00
    nop                 ;23cc 00
    nop                 ;23cd 00
    nop                 ;23ce 00
    nop                 ;23cf 00
    nop                 ;23d0 00
    nop                 ;23d1 00
    nop                 ;23d2 00
    nop                 ;23d3 00
    nop                 ;23d4 00
    nop                 ;23d5 00
    nop                 ;23d6 00
    nop                 ;23d7 00
    nop                 ;23d8 00
    nop                 ;23d9 00
    nop                 ;23da 00
    nop                 ;23db 00
    nop                 ;23dc 00
    nop                 ;23dd 00
    nop                 ;23de 00
    nop                 ;23df 00
    nop                 ;23e0 00
    nop                 ;23e1 00
    nop                 ;23e2 00
    nop                 ;23e3 00
    nop                 ;23e4 00
    nop                 ;23e5 00
    nop                 ;23e6 00
    nop                 ;23e7 00
    nop                 ;23e8 00
    nop                 ;23e9 00
    nop                 ;23ea 00
    nop                 ;23eb 00
    nop                 ;23ec 00
    nop                 ;23ed 00
    nop                 ;23ee 00
    nop                 ;23ef 00
    nop                 ;23f0 00
    nop                 ;23f1 00
    nop                 ;23f2 00
    nop                 ;23f3 00
    nop                 ;23f4 00
    nop                 ;23f5 00
    nop                 ;23f6 00
    nop                 ;23f7 00
    nop                 ;23f8 00
    nop                 ;23f9 00
    nop                 ;23fa 00
    nop                 ;23fb 00
    nop                 ;23fc 00
    nop                 ;23fd 00
    nop                 ;23fe 00
    nop                 ;23ff 00
    nop                 ;2400 00
    nop                 ;2401 00
    nop                 ;2402 00
    nop                 ;2403 00
    nop                 ;2404 00
    nop                 ;2405 00
    nop                 ;2406 00
    nop                 ;2407 00
    nop                 ;2408 00
    nop                 ;2409 00
    nop                 ;240a 00
    nop                 ;240b 00
    nop                 ;240c 00
    nop                 ;240d 00
    nop                 ;240e 00
    nop                 ;240f 00
    nop                 ;2410 00
    nop                 ;2411 00
    nop                 ;2412 00
    nop                 ;2413 00
    nop                 ;2414 00
    nop                 ;2415 00
    nop                 ;2416 00
    nop                 ;2417 00
    nop                 ;2418 00
    nop                 ;2419 00
    nop                 ;241a 00
    nop                 ;241b 00
    nop                 ;241c 00
    nop                 ;241d 00
    nop                 ;241e 00
    nop                 ;241f 00
    nop                 ;2420 00
    nop                 ;2421 00
    nop                 ;2422 00
    nop                 ;2423 00
    nop                 ;2424 00
    nop                 ;2425 00
    nop                 ;2426 00
    nop                 ;2427 00
    nop                 ;2428 00
    nop                 ;2429 00
    nop                 ;242a 00
    nop                 ;242b 00
    nop                 ;242c 00
    nop                 ;242d 00
    nop                 ;242e 00
    nop                 ;242f 00
    nop                 ;2430 00
    nop                 ;2431 00
    nop                 ;2432 00
    nop                 ;2433 00
    nop                 ;2434 00
    nop                 ;2435 00
    nop                 ;2436 00
    nop                 ;2437 00
    nop                 ;2438 00
    nop                 ;2439 00
    nop                 ;243a 00
    nop                 ;243b 00
    nop                 ;243c 00
    nop                 ;243d 00
    nop                 ;243e 00
    nop                 ;243f 00
    nop                 ;2440 00
    nop                 ;2441 00
    nop                 ;2442 00
    nop                 ;2443 00
    nop                 ;2444 00
    nop                 ;2445 00
    nop                 ;2446 00
    nop                 ;2447 00
    nop                 ;2448 00
    nop                 ;2449 00
    nop                 ;244a 00
    nop                 ;244b 00
    nop                 ;244c 00
    nop                 ;244d 00
    nop                 ;244e 00
    nop                 ;244f 00
    nop                 ;2450 00
    nop                 ;2451 00
    nop                 ;2452 00
    nop                 ;2453 00
    nop                 ;2454 00
    nop                 ;2455 00
    nop                 ;2456 00
    nop                 ;2457 00
    nop                 ;2458 00
    nop                 ;2459 00
    nop                 ;245a 00
    nop                 ;245b 00
    nop                 ;245c 00
    nop                 ;245d 00
    nop                 ;245e 00
    nop                 ;245f 00
    nop                 ;2460 00
    nop                 ;2461 00
    nop                 ;2462 00
    nop                 ;2463 00
    nop                 ;2464 00
    nop                 ;2465 00
    nop                 ;2466 00
    nop                 ;2467 00
    nop                 ;2468 00
    nop                 ;2469 00
    nop                 ;246a 00
    nop                 ;246b 00
    nop                 ;246c 00
    nop                 ;246d 00
    nop                 ;246e 00
    nop                 ;246f 00
    nop                 ;2470 00
    nop                 ;2471 00
    nop                 ;2472 00
    nop                 ;2473 00
    nop                 ;2474 00
    nop                 ;2475 00
    nop                 ;2476 00
    nop                 ;2477 00
    nop                 ;2478 00
    nop                 ;2479 00
    nop                 ;247a 00
    nop                 ;247b 00
    nop                 ;247c 00
    nop                 ;247d 00
    nop                 ;247e 00
    nop                 ;247f 00
    nop                 ;2480 00
    nop                 ;2481 00
    nop                 ;2482 00
    nop                 ;2483 00
    nop                 ;2484 00
    nop                 ;2485 00
    nop                 ;2486 00
    nop                 ;2487 00
    nop                 ;2488 00
    nop                 ;2489 00
    nop                 ;248a 00
    nop                 ;248b 00
    nop                 ;248c 00
    nop                 ;248d 00
    nop                 ;248e 00
    nop                 ;248f 00
    nop                 ;2490 00
    nop                 ;2491 00
    nop                 ;2492 00
    nop                 ;2493 00
    nop                 ;2494 00
    nop                 ;2495 00
    nop                 ;2496 00
    nop                 ;2497 00
    nop                 ;2498 00
    nop                 ;2499 00
    nop                 ;249a 00
    nop                 ;249b 00
    nop                 ;249c 00
    nop                 ;249d 00
    nop                 ;249e 00
    nop                 ;249f 00
    nop                 ;24a0 00
    nop                 ;24a1 00
    nop                 ;24a2 00
    nop                 ;24a3 00
    nop                 ;24a4 00
    nop                 ;24a5 00
    nop                 ;24a6 00
    nop                 ;24a7 00
    nop                 ;24a8 00
    nop                 ;24a9 00
    nop                 ;24aa 00
    nop                 ;24ab 00
    nop                 ;24ac 00
    nop                 ;24ad 00
    nop                 ;24ae 00
    nop                 ;24af 00
    nop                 ;24b0 00
    nop                 ;24b1 00
    nop                 ;24b2 00
    nop                 ;24b3 00
    nop                 ;24b4 00
    nop                 ;24b5 00
    nop                 ;24b6 00
    nop                 ;24b7 00
    nop                 ;24b8 00
    nop                 ;24b9 00
    nop                 ;24ba 00
    nop                 ;24bb 00
    nop                 ;24bc 00
    nop                 ;24bd 00
    nop                 ;24be 00
    nop                 ;24bf 00
    nop                 ;24c0 00
    nop                 ;24c1 00
    nop                 ;24c2 00
    nop                 ;24c3 00
    nop                 ;24c4 00
    nop                 ;24c5 00
    nop                 ;24c6 00
    nop                 ;24c7 00
    nop                 ;24c8 00
    nop                 ;24c9 00
    nop                 ;24ca 00
    nop                 ;24cb 00
    nop                 ;24cc 00
    nop                 ;24cd 00
    nop                 ;24ce 00
    nop                 ;24cf 00
    nop                 ;24d0 00
    nop                 ;24d1 00
    nop                 ;24d2 00
    nop                 ;24d3 00
    nop                 ;24d4 00
    nop                 ;24d5 00
    nop                 ;24d6 00
    nop                 ;24d7 00
    nop                 ;24d8 00
    nop                 ;24d9 00
    nop                 ;24da 00
    nop                 ;24db 00
    nop                 ;24dc 00
    nop                 ;24dd 00
    nop                 ;24de 00
    nop                 ;24df 00
    nop                 ;24e0 00
    nop                 ;24e1 00
    nop                 ;24e2 00
    nop                 ;24e3 00
    nop                 ;24e4 00
    nop                 ;24e5 00
    nop                 ;24e6 00
    nop                 ;24e7 00
    nop                 ;24e8 00
    nop                 ;24e9 00
    nop                 ;24ea 00
    nop                 ;24eb 00
    nop                 ;24ec 00
    nop                 ;24ed 00
    nop                 ;24ee 00
    nop                 ;24ef 00
    nop                 ;24f0 00
    nop                 ;24f1 00
    nop                 ;24f2 00
    nop                 ;24f3 00
    nop                 ;24f4 00
    nop                 ;24f5 00
    nop                 ;24f6 00
    nop                 ;24f7 00
    nop                 ;24f8 00
    nop                 ;24f9 00
    nop                 ;24fa 00
    nop                 ;24fb 00
    nop                 ;24fc 00
    nop                 ;24fd 00
    nop                 ;24fe 00
    nop                 ;24ff 00
    nop                 ;2500 00
    nop                 ;2501 00
    nop                 ;2502 00
    nop                 ;2503 00
    nop                 ;2504 00
    nop                 ;2505 00
    nop                 ;2506 00
    nop                 ;2507 00
    nop                 ;2508 00
    nop                 ;2509 00
    nop                 ;250a 00
    nop                 ;250b 00
    nop                 ;250c 00
    nop                 ;250d 00
    nop                 ;250e 00
    nop                 ;250f 00
    nop                 ;2510 00
    nop                 ;2511 00
    nop                 ;2512 00
    nop                 ;2513 00
    nop                 ;2514 00
    nop                 ;2515 00
    nop                 ;2516 00
    nop                 ;2517 00
    nop                 ;2518 00
    nop                 ;2519 00
    nop                 ;251a 00
    nop                 ;251b 00
    nop                 ;251c 00
    nop                 ;251d 00
    nop                 ;251e 00
    nop                 ;251f 00
    nop                 ;2520 00
    nop                 ;2521 00
    nop                 ;2522 00
    nop                 ;2523 00
    nop                 ;2524 00
    nop                 ;2525 00
    nop                 ;2526 00
    nop                 ;2527 00
    nop                 ;2528 00
    nop                 ;2529 00
    nop                 ;252a 00
    nop                 ;252b 00
    nop                 ;252c 00
    nop                 ;252d 00
    nop                 ;252e 00
    nop                 ;252f 00
    nop                 ;2530 00
    nop                 ;2531 00
    nop                 ;2532 00
    nop                 ;2533 00
    nop                 ;2534 00
    nop                 ;2535 00
    nop                 ;2536 00
    nop                 ;2537 00
    nop                 ;2538 00
    nop                 ;2539 00
    nop                 ;253a 00
    nop                 ;253b 00
    nop                 ;253c 00
    nop                 ;253d 00
    nop                 ;253e 00
    nop                 ;253f 00
    nop                 ;2540 00
    nop                 ;2541 00
    nop                 ;2542 00
    nop                 ;2543 00
    nop                 ;2544 00
    nop                 ;2545 00
    nop                 ;2546 00
    nop                 ;2547 00
    nop                 ;2548 00
    nop                 ;2549 00
    nop                 ;254a 00
    nop                 ;254b 00
    nop                 ;254c 00
    nop                 ;254d 00
    nop                 ;254e 00
    nop                 ;254f 00
    nop                 ;2550 00
    nop                 ;2551 00
    nop                 ;2552 00
    nop                 ;2553 00
    nop                 ;2554 00
    nop                 ;2555 00
    nop                 ;2556 00
    nop                 ;2557 00
    nop                 ;2558 00
    nop                 ;2559 00
    nop                 ;255a 00
    nop                 ;255b 00
    nop                 ;255c 00
    nop                 ;255d 00
    nop                 ;255e 00
    nop                 ;255f 00
    nop                 ;2560 00
    nop                 ;2561 00
    nop                 ;2562 00
    nop                 ;2563 00
    nop                 ;2564 00
    nop                 ;2565 00
    nop                 ;2566 00
    nop                 ;2567 00
    nop                 ;2568 00
    nop                 ;2569 00
    nop                 ;256a 00
    nop                 ;256b 00
    nop                 ;256c 00
    nop                 ;256d 00
    nop                 ;256e 00
    nop                 ;256f 00
    nop                 ;2570 00
    nop                 ;2571 00
    nop                 ;2572 00
    nop                 ;2573 00
    nop                 ;2574 00
    nop                 ;2575 00
    nop                 ;2576 00
    nop                 ;2577 00
    nop                 ;2578 00
    nop                 ;2579 00
    nop                 ;257a 00
    nop                 ;257b 00
    nop                 ;257c 00
    nop                 ;257d 00
    nop                 ;257e 00
    nop                 ;257f 00
    nop                 ;2580 00
    nop                 ;2581 00
    nop                 ;2582 00
    nop                 ;2583 00
    nop                 ;2584 00
    nop                 ;2585 00
    nop                 ;2586 00
    nop                 ;2587 00
    nop                 ;2588 00
    nop                 ;2589 00
    nop                 ;258a 00
    nop                 ;258b 00
    nop                 ;258c 00
    nop                 ;258d 00
    nop                 ;258e 00
    nop                 ;258f 00
    nop                 ;2590 00
    nop                 ;2591 00
    nop                 ;2592 00
    nop                 ;2593 00
    nop                 ;2594 00
    nop                 ;2595 00
    nop                 ;2596 00
    nop                 ;2597 00
    nop                 ;2598 00
    nop                 ;2599 00
    nop                 ;259a 00
    nop                 ;259b 00
    nop                 ;259c 00
    nop                 ;259d 00
    nop                 ;259e 00
    nop                 ;259f 00
    nop                 ;25a0 00
    nop                 ;25a1 00
    nop                 ;25a2 00
    nop                 ;25a3 00
    nop                 ;25a4 00
    nop                 ;25a5 00
    nop                 ;25a6 00
    nop                 ;25a7 00
    nop                 ;25a8 00
    nop                 ;25a9 00
    nop                 ;25aa 00
    nop                 ;25ab 00
    nop                 ;25ac 00
    nop                 ;25ad 00
    nop                 ;25ae 00
    nop                 ;25af 00
    nop                 ;25b0 00
    nop                 ;25b1 00
    nop                 ;25b2 00
    nop                 ;25b3 00
    nop                 ;25b4 00
    nop                 ;25b5 00
    nop                 ;25b6 00
    nop                 ;25b7 00
    nop                 ;25b8 00
    nop                 ;25b9 00
    nop                 ;25ba 00
    nop                 ;25bb 00
    nop                 ;25bc 00
    nop                 ;25bd 00
    nop                 ;25be 00
    nop                 ;25bf 00
    nop                 ;25c0 00
    nop                 ;25c1 00
    nop                 ;25c2 00
    nop                 ;25c3 00
    nop                 ;25c4 00
    nop                 ;25c5 00
    nop                 ;25c6 00
    nop                 ;25c7 00
    nop                 ;25c8 00
    nop                 ;25c9 00
    nop                 ;25ca 00
    nop                 ;25cb 00
    nop                 ;25cc 00
    nop                 ;25cd 00
    nop                 ;25ce 00
    nop                 ;25cf 00
    nop                 ;25d0 00
    nop                 ;25d1 00
    nop                 ;25d2 00
    nop                 ;25d3 00
    nop                 ;25d4 00
    nop                 ;25d5 00
    nop                 ;25d6 00
    nop                 ;25d7 00
    nop                 ;25d8 00
    nop                 ;25d9 00
    nop                 ;25da 00
    nop                 ;25db 00
    nop                 ;25dc 00
    nop                 ;25dd 00
    nop                 ;25de 00
    nop                 ;25df 00
    nop                 ;25e0 00
    nop                 ;25e1 00
    nop                 ;25e2 00
    nop                 ;25e3 00
    nop                 ;25e4 00
    nop                 ;25e5 00
    nop                 ;25e6 00
    nop                 ;25e7 00
    nop                 ;25e8 00
    nop                 ;25e9 00
    nop                 ;25ea 00
    nop                 ;25eb 00
    nop                 ;25ec 00
    nop                 ;25ed 00
    nop                 ;25ee 00
    nop                 ;25ef 00
    nop                 ;25f0 00
    nop                 ;25f1 00
    nop                 ;25f2 00
    nop                 ;25f3 00
    nop                 ;25f4 00
    nop                 ;25f5 00
    nop                 ;25f6 00
    nop                 ;25f7 00
    nop                 ;25f8 00
    nop                 ;25f9 00
    nop                 ;25fa 00
    nop                 ;25fb 00
    nop                 ;25fc 00
    nop                 ;25fd 00
    nop                 ;25fe 00
    nop                 ;25ff 00
    nop                 ;2600 00
    nop                 ;2601 00
    nop                 ;2602 00
    nop                 ;2603 00
    nop                 ;2604 00
    nop                 ;2605 00
    nop                 ;2606 00
    nop                 ;2607 00
    nop                 ;2608 00
    nop                 ;2609 00
    nop                 ;260a 00
    nop                 ;260b 00
    nop                 ;260c 00
    nop                 ;260d 00
    nop                 ;260e 00
    nop                 ;260f 00
    nop                 ;2610 00
    nop                 ;2611 00
    nop                 ;2612 00
    nop                 ;2613 00
    nop                 ;2614 00
    nop                 ;2615 00
    nop                 ;2616 00
    nop                 ;2617 00
    nop                 ;2618 00
    nop                 ;2619 00
    nop                 ;261a 00
    nop                 ;261b 00
    nop                 ;261c 00
    nop                 ;261d 00
    nop                 ;261e 00
    nop                 ;261f 00
    nop                 ;2620 00
    nop                 ;2621 00
    nop                 ;2622 00
    nop                 ;2623 00
    nop                 ;2624 00
    nop                 ;2625 00
    nop                 ;2626 00
    nop                 ;2627 00
    nop                 ;2628 00
    nop                 ;2629 00
    nop                 ;262a 00
    nop                 ;262b 00
    nop                 ;262c 00
    nop                 ;262d 00
    nop                 ;262e 00
    nop                 ;262f 00
    nop                 ;2630 00
    nop                 ;2631 00
    nop                 ;2632 00
    nop                 ;2633 00
    nop                 ;2634 00
    nop                 ;2635 00
    nop                 ;2636 00
    nop                 ;2637 00
    nop                 ;2638 00
    nop                 ;2639 00
    nop                 ;263a 00
    nop                 ;263b 00
    nop                 ;263c 00
    nop                 ;263d 00
    nop                 ;263e 00
    nop                 ;263f 00
    nop                 ;2640 00
    nop                 ;2641 00
    nop                 ;2642 00
    nop                 ;2643 00
    nop                 ;2644 00
    nop                 ;2645 00
    nop                 ;2646 00
    nop                 ;2647 00
    nop                 ;2648 00
    nop                 ;2649 00
    nop                 ;264a 00
    nop                 ;264b 00
    nop                 ;264c 00
    nop                 ;264d 00
    nop                 ;264e 00
    nop                 ;264f 00
    nop                 ;2650 00
    nop                 ;2651 00
    nop                 ;2652 00
    nop                 ;2653 00
    nop                 ;2654 00
    nop                 ;2655 00
    nop                 ;2656 00
    nop                 ;2657 00
    nop                 ;2658 00
    nop                 ;2659 00
    nop                 ;265a 00
    nop                 ;265b 00
    nop                 ;265c 00
    nop                 ;265d 00
    nop                 ;265e 00
    nop                 ;265f 00
    nop                 ;2660 00
    nop                 ;2661 00
    nop                 ;2662 00
    nop                 ;2663 00
    nop                 ;2664 00
    nop                 ;2665 00
    nop                 ;2666 00
    nop                 ;2667 00
    nop                 ;2668 00
    nop                 ;2669 00
    nop                 ;266a 00
    nop                 ;266b 00
    nop                 ;266c 00
    nop                 ;266d 00
    nop                 ;266e 00
    nop                 ;266f 00
    nop                 ;2670 00
    nop                 ;2671 00
    nop                 ;2672 00
    nop                 ;2673 00
    nop                 ;2674 00
    nop                 ;2675 00
    nop                 ;2676 00
    nop                 ;2677 00
    nop                 ;2678 00
    nop                 ;2679 00
    nop                 ;267a 00
    nop                 ;267b 00
    nop                 ;267c 00
    nop                 ;267d 00
    nop                 ;267e 00
    nop                 ;267f 00
    nop                 ;2680 00
    nop                 ;2681 00
    nop                 ;2682 00
    nop                 ;2683 00
    nop                 ;2684 00
    nop                 ;2685 00
    nop                 ;2686 00
    nop                 ;2687 00
    nop                 ;2688 00
    nop                 ;2689 00
    nop                 ;268a 00
    nop                 ;268b 00
    nop                 ;268c 00
    nop                 ;268d 00
    nop                 ;268e 00
    nop                 ;268f 00
    nop                 ;2690 00
    nop                 ;2691 00
    nop                 ;2692 00
    nop                 ;2693 00
    nop                 ;2694 00
    nop                 ;2695 00
    nop                 ;2696 00
    nop                 ;2697 00
    nop                 ;2698 00
    nop                 ;2699 00
    nop                 ;269a 00
    nop                 ;269b 00
    nop                 ;269c 00
    nop                 ;269d 00
    nop                 ;269e 00
    nop                 ;269f 00
    nop                 ;26a0 00
    nop                 ;26a1 00
    nop                 ;26a2 00
    nop                 ;26a3 00
    nop                 ;26a4 00
    nop                 ;26a5 00
    nop                 ;26a6 00
    nop                 ;26a7 00
    nop                 ;26a8 00
    nop                 ;26a9 00
    nop                 ;26aa 00
    nop                 ;26ab 00
    nop                 ;26ac 00
    nop                 ;26ad 00
    nop                 ;26ae 00
    nop                 ;26af 00
    nop                 ;26b0 00
    nop                 ;26b1 00
    nop                 ;26b2 00
    nop                 ;26b3 00
    nop                 ;26b4 00
    nop                 ;26b5 00
    nop                 ;26b6 00
    nop                 ;26b7 00
    nop                 ;26b8 00
    nop                 ;26b9 00
    nop                 ;26ba 00
    nop                 ;26bb 00
    nop                 ;26bc 00
    nop                 ;26bd 00
    nop                 ;26be 00
    nop                 ;26bf 00
    nop                 ;26c0 00
    nop                 ;26c1 00
    nop                 ;26c2 00
    nop                 ;26c3 00
    nop                 ;26c4 00
    nop                 ;26c5 00
    nop                 ;26c6 00
    nop                 ;26c7 00
    nop                 ;26c8 00
    nop                 ;26c9 00
    nop                 ;26ca 00
    nop                 ;26cb 00
    nop                 ;26cc 00
    nop                 ;26cd 00
    nop                 ;26ce 00
    nop                 ;26cf 00
    nop                 ;26d0 00
    nop                 ;26d1 00
    nop                 ;26d2 00
    nop                 ;26d3 00
    nop                 ;26d4 00
    nop                 ;26d5 00
    nop                 ;26d6 00
    nop                 ;26d7 00
    nop                 ;26d8 00
    nop                 ;26d9 00
    nop                 ;26da 00
    nop                 ;26db 00
    nop                 ;26dc 00
    nop                 ;26dd 00
    nop                 ;26de 00
    nop                 ;26df 00
    nop                 ;26e0 00
    nop                 ;26e1 00
    nop                 ;26e2 00
    nop                 ;26e3 00
    nop                 ;26e4 00
    nop                 ;26e5 00
    nop                 ;26e6 00
    nop                 ;26e7 00
    nop                 ;26e8 00
    nop                 ;26e9 00
    nop                 ;26ea 00
    nop                 ;26eb 00
    nop                 ;26ec 00
    nop                 ;26ed 00
    nop                 ;26ee 00
    nop                 ;26ef 00
    nop                 ;26f0 00
    nop                 ;26f1 00
    nop                 ;26f2 00
    nop                 ;26f3 00
    nop                 ;26f4 00
    nop                 ;26f5 00
    nop                 ;26f6 00
    nop                 ;26f7 00
    nop                 ;26f8 00
    nop                 ;26f9 00
    nop                 ;26fa 00
    nop                 ;26fb 00
    nop                 ;26fc 00
    nop                 ;26fd 00
    nop                 ;26fe 00
    nop                 ;26ff 00
    nop                 ;2700 00
    nop                 ;2701 00
    nop                 ;2702 00
    nop                 ;2703 00
    nop                 ;2704 00
    nop                 ;2705 00
    nop                 ;2706 00
    nop                 ;2707 00
    nop                 ;2708 00
    nop                 ;2709 00
    nop                 ;270a 00
    nop                 ;270b 00
    nop                 ;270c 00
    nop                 ;270d 00
    nop                 ;270e 00
    nop                 ;270f 00
    nop                 ;2710 00
    nop                 ;2711 00
    nop                 ;2712 00
    nop                 ;2713 00
    nop                 ;2714 00
    nop                 ;2715 00
    nop                 ;2716 00
    nop                 ;2717 00
    nop                 ;2718 00
    nop                 ;2719 00
    nop                 ;271a 00
    nop                 ;271b 00
    nop                 ;271c 00
    nop                 ;271d 00
    nop                 ;271e 00
    nop                 ;271f 00
    nop                 ;2720 00
    nop                 ;2721 00
    nop                 ;2722 00
    nop                 ;2723 00
    nop                 ;2724 00
    nop                 ;2725 00
    nop                 ;2726 00
    nop                 ;2727 00
    nop                 ;2728 00
    nop                 ;2729 00
    nop                 ;272a 00
    nop                 ;272b 00
    nop                 ;272c 00
    nop                 ;272d 00
    nop                 ;272e 00
    nop                 ;272f 00
    nop                 ;2730 00
    nop                 ;2731 00
    nop                 ;2732 00
    nop                 ;2733 00
    nop                 ;2734 00
    nop                 ;2735 00
    nop                 ;2736 00
    nop                 ;2737 00
    nop                 ;2738 00
    nop                 ;2739 00
    nop                 ;273a 00
    nop                 ;273b 00
    nop                 ;273c 00
    nop                 ;273d 00
    nop                 ;273e 00
    nop                 ;273f 00
    nop                 ;2740 00
    nop                 ;2741 00
    nop                 ;2742 00
    nop                 ;2743 00
    nop                 ;2744 00
    nop                 ;2745 00
    nop                 ;2746 00
    nop                 ;2747 00
    nop                 ;2748 00
    nop                 ;2749 00
    nop                 ;274a 00
    nop                 ;274b 00
    nop                 ;274c 00
    nop                 ;274d 00
    nop                 ;274e 00
    nop                 ;274f 00
    nop                 ;2750 00
    nop                 ;2751 00
    nop                 ;2752 00
    nop                 ;2753 00
    nop                 ;2754 00
    nop                 ;2755 00
    nop                 ;2756 00
    nop                 ;2757 00
    nop                 ;2758 00
    nop                 ;2759 00
    nop                 ;275a 00
    nop                 ;275b 00
    nop                 ;275c 00
    nop                 ;275d 00
    nop                 ;275e 00
    nop                 ;275f 00
    nop                 ;2760 00
    nop                 ;2761 00
    nop                 ;2762 00
    nop                 ;2763 00
    nop                 ;2764 00
    nop                 ;2765 00
    nop                 ;2766 00
    nop                 ;2767 00
    nop                 ;2768 00
    nop                 ;2769 00
    nop                 ;276a 00
    nop                 ;276b 00
    nop                 ;276c 00
    nop                 ;276d 00
    nop                 ;276e 00
    nop                 ;276f 00
    nop                 ;2770 00
    nop                 ;2771 00
    nop                 ;2772 00
    nop                 ;2773 00
    nop                 ;2774 00
    nop                 ;2775 00
    nop                 ;2776 00
    nop                 ;2777 00
    nop                 ;2778 00
    nop                 ;2779 00
    nop                 ;277a 00
    nop                 ;277b 00
    nop                 ;277c 00
    nop                 ;277d 00
    nop                 ;277e 00
    nop                 ;277f 00
    nop                 ;2780 00
    nop                 ;2781 00
    nop                 ;2782 00
    nop                 ;2783 00
    nop                 ;2784 00
    nop                 ;2785 00
    nop                 ;2786 00
    nop                 ;2787 00
    nop                 ;2788 00
    nop                 ;2789 00
    nop                 ;278a 00
    nop                 ;278b 00
    nop                 ;278c 00
    nop                 ;278d 00
    nop                 ;278e 00
    nop                 ;278f 00
    nop                 ;2790 00
    nop                 ;2791 00
    nop                 ;2792 00
    nop                 ;2793 00
    nop                 ;2794 00
    nop                 ;2795 00
    nop                 ;2796 00
    nop                 ;2797 00
    nop                 ;2798 00
    nop                 ;2799 00
    nop                 ;279a 00
    nop                 ;279b 00
    nop                 ;279c 00
    nop                 ;279d 00
    nop                 ;279e 00
    nop                 ;279f 00
    nop                 ;27a0 00
    nop                 ;27a1 00
    nop                 ;27a2 00
    nop                 ;27a3 00
    nop                 ;27a4 00
    nop                 ;27a5 00
    nop                 ;27a6 00
    nop                 ;27a7 00
    nop                 ;27a8 00
    nop                 ;27a9 00
    nop                 ;27aa 00
    nop                 ;27ab 00
    nop                 ;27ac 00
    nop                 ;27ad 00
    nop                 ;27ae 00
    nop                 ;27af 00
    nop                 ;27b0 00
    nop                 ;27b1 00
    nop                 ;27b2 00
    nop                 ;27b3 00
    nop                 ;27b4 00
    nop                 ;27b5 00
    nop                 ;27b6 00
    nop                 ;27b7 00
    nop                 ;27b8 00
    nop                 ;27b9 00
    nop                 ;27ba 00
    nop                 ;27bb 00
    nop                 ;27bc 00
    nop                 ;27bd 00
    nop                 ;27be 00
    nop                 ;27bf 00
    nop                 ;27c0 00
    nop                 ;27c1 00
    nop                 ;27c2 00
    nop                 ;27c3 00
    nop                 ;27c4 00
    nop                 ;27c5 00
    nop                 ;27c6 00
    nop                 ;27c7 00
    nop                 ;27c8 00
    nop                 ;27c9 00
    nop                 ;27ca 00
    nop                 ;27cb 00
    nop                 ;27cc 00
    nop                 ;27cd 00
    nop                 ;27ce 00
    nop                 ;27cf 00
    nop                 ;27d0 00
    nop                 ;27d1 00
    nop                 ;27d2 00
    nop                 ;27d3 00
    nop                 ;27d4 00
    nop                 ;27d5 00
    nop                 ;27d6 00
    nop                 ;27d7 00
    nop                 ;27d8 00
    nop                 ;27d9 00
    nop                 ;27da 00
    nop                 ;27db 00
    nop                 ;27dc 00
    nop                 ;27dd 00
    nop                 ;27de 00
    nop                 ;27df 00
    nop                 ;27e0 00
    nop                 ;27e1 00
    nop                 ;27e2 00
    nop                 ;27e3 00
    nop                 ;27e4 00
    nop                 ;27e5 00
    nop                 ;27e6 00
    nop                 ;27e7 00
    nop                 ;27e8 00
    nop                 ;27e9 00
    nop                 ;27ea 00
    nop                 ;27eb 00
    nop                 ;27ec 00
    nop                 ;27ed 00
    nop                 ;27ee 00
    nop                 ;27ef 00
    nop                 ;27f0 00
    nop                 ;27f1 00
    nop                 ;27f2 00
    nop                 ;27f3 00
    nop                 ;27f4 00
    nop                 ;27f5 00
    nop                 ;27f6 00
    nop                 ;27f7 00
    nop                 ;27f8 00
    nop                 ;27f9 00
    nop                 ;27fa 00
    nop                 ;27fb 00
    nop                 ;27fc 00
    nop                 ;27fd 00
    nop                 ;27fe 00
    nop                 ;27ff 00
    nop                 ;2800 00
    nop                 ;2801 00
    nop                 ;2802 00
    nop                 ;2803 00
    nop                 ;2804 00
    nop                 ;2805 00
    nop                 ;2806 00
    nop                 ;2807 00
    nop                 ;2808 00
    nop                 ;2809 00
    nop                 ;280a 00
    nop                 ;280b 00
    nop                 ;280c 00
    nop                 ;280d 00
    nop                 ;280e 00
    nop                 ;280f 00
    nop                 ;2810 00
    nop                 ;2811 00
    nop                 ;2812 00
    nop                 ;2813 00
    nop                 ;2814 00
    nop                 ;2815 00
    nop                 ;2816 00
    nop                 ;2817 00
    nop                 ;2818 00
    nop                 ;2819 00
    nop                 ;281a 00
    nop                 ;281b 00
    nop                 ;281c 00
    nop                 ;281d 00
    nop                 ;281e 00
    nop                 ;281f 00
    nop                 ;2820 00
    nop                 ;2821 00
    nop                 ;2822 00
    nop                 ;2823 00
    nop                 ;2824 00
    nop                 ;2825 00
    nop                 ;2826 00
    nop                 ;2827 00
    nop                 ;2828 00
    nop                 ;2829 00
    nop                 ;282a 00
    nop                 ;282b 00
    nop                 ;282c 00
    nop                 ;282d 00
    nop                 ;282e 00
    nop                 ;282f 00
    nop                 ;2830 00
    nop                 ;2831 00
    nop                 ;2832 00
    nop                 ;2833 00
    nop                 ;2834 00
    nop                 ;2835 00
    nop                 ;2836 00
    nop                 ;2837 00
    nop                 ;2838 00
    nop                 ;2839 00
    nop                 ;283a 00
    nop                 ;283b 00
    nop                 ;283c 00
    nop                 ;283d 00
    nop                 ;283e 00
    nop                 ;283f 00
    nop                 ;2840 00
    nop                 ;2841 00
    nop                 ;2842 00
    nop                 ;2843 00
    nop                 ;2844 00
    nop                 ;2845 00
    nop                 ;2846 00
    nop                 ;2847 00
    nop                 ;2848 00
    nop                 ;2849 00
    nop                 ;284a 00
    nop                 ;284b 00
    nop                 ;284c 00
    nop                 ;284d 00
    nop                 ;284e 00
    nop                 ;284f 00
    nop                 ;2850 00
    nop                 ;2851 00
    nop                 ;2852 00
    nop                 ;2853 00
    nop                 ;2854 00
    nop                 ;2855 00
    nop                 ;2856 00
    nop                 ;2857 00
    nop                 ;2858 00
    nop                 ;2859 00
    nop                 ;285a 00
    nop                 ;285b 00
    nop                 ;285c 00
    nop                 ;285d 00
    nop                 ;285e 00
    nop                 ;285f 00
    nop                 ;2860 00
    nop                 ;2861 00
    nop                 ;2862 00
    nop                 ;2863 00
    nop                 ;2864 00
    nop                 ;2865 00
    nop                 ;2866 00
    nop                 ;2867 00
    nop                 ;2868 00
    nop                 ;2869 00
    nop                 ;286a 00
    nop                 ;286b 00
    nop                 ;286c 00
    nop                 ;286d 00
    nop                 ;286e 00
    nop                 ;286f 00
    nop                 ;2870 00
    nop                 ;2871 00
    nop                 ;2872 00
    nop                 ;2873 00
    nop                 ;2874 00
    nop                 ;2875 00
    nop                 ;2876 00
    nop                 ;2877 00
    nop                 ;2878 00
    nop                 ;2879 00
    nop                 ;287a 00
    nop                 ;287b 00
    nop                 ;287c 00
    nop                 ;287d 00
    nop                 ;287e 00
    nop                 ;287f 00
    nop                 ;2880 00
    nop                 ;2881 00
    nop                 ;2882 00
    nop                 ;2883 00
    nop                 ;2884 00
    nop                 ;2885 00
    nop                 ;2886 00
    nop                 ;2887 00
    nop                 ;2888 00
    nop                 ;2889 00
    nop                 ;288a 00
    nop                 ;288b 00
    nop                 ;288c 00
    nop                 ;288d 00
    nop                 ;288e 00
    nop                 ;288f 00
    nop                 ;2890 00
    nop                 ;2891 00
    nop                 ;2892 00
    nop                 ;2893 00
    nop                 ;2894 00
    nop                 ;2895 00
    nop                 ;2896 00
    nop                 ;2897 00
    nop                 ;2898 00
    nop                 ;2899 00
    nop                 ;289a 00
    nop                 ;289b 00
    nop                 ;289c 00
    nop                 ;289d 00
    nop                 ;289e 00
    nop                 ;289f 00
    nop                 ;28a0 00
    nop                 ;28a1 00
    nop                 ;28a2 00
    nop                 ;28a3 00
    nop                 ;28a4 00
    nop                 ;28a5 00
    nop                 ;28a6 00
    nop                 ;28a7 00
    nop                 ;28a8 00
    nop                 ;28a9 00
    nop                 ;28aa 00
    nop                 ;28ab 00
    nop                 ;28ac 00
    nop                 ;28ad 00
    nop                 ;28ae 00
    nop                 ;28af 00
    nop                 ;28b0 00
    nop                 ;28b1 00
    nop                 ;28b2 00
    nop                 ;28b3 00
    nop                 ;28b4 00
    nop                 ;28b5 00
    nop                 ;28b6 00
    nop                 ;28b7 00
    nop                 ;28b8 00
    nop                 ;28b9 00
    nop                 ;28ba 00
    nop                 ;28bb 00
    nop                 ;28bc 00
    nop                 ;28bd 00
    nop                 ;28be 00
    nop                 ;28bf 00
    nop                 ;28c0 00
    nop                 ;28c1 00
    nop                 ;28c2 00
    nop                 ;28c3 00
    nop                 ;28c4 00
    nop                 ;28c5 00
    nop                 ;28c6 00
    nop                 ;28c7 00
    nop                 ;28c8 00
    nop                 ;28c9 00
    nop                 ;28ca 00
    nop                 ;28cb 00
    nop                 ;28cc 00
    nop                 ;28cd 00
    nop                 ;28ce 00
    nop                 ;28cf 00
    nop                 ;28d0 00
    nop                 ;28d1 00
    nop                 ;28d2 00
    nop                 ;28d3 00
    nop                 ;28d4 00
    nop                 ;28d5 00
    nop                 ;28d6 00
    nop                 ;28d7 00
    nop                 ;28d8 00
    nop                 ;28d9 00
    nop                 ;28da 00
    nop                 ;28db 00
    nop                 ;28dc 00
    nop                 ;28dd 00
    nop                 ;28de 00
    nop                 ;28df 00
    nop                 ;28e0 00
    nop                 ;28e1 00
    nop                 ;28e2 00
    nop                 ;28e3 00
    nop                 ;28e4 00
    nop                 ;28e5 00
    nop                 ;28e6 00
    nop                 ;28e7 00
    nop                 ;28e8 00
    nop                 ;28e9 00
    nop                 ;28ea 00
    nop                 ;28eb 00
    nop                 ;28ec 00
    nop                 ;28ed 00
    nop                 ;28ee 00
    nop                 ;28ef 00
    nop                 ;28f0 00
    nop                 ;28f1 00
    nop                 ;28f2 00
    nop                 ;28f3 00
    nop                 ;28f4 00
    nop                 ;28f5 00
    nop                 ;28f6 00
    nop                 ;28f7 00
    nop                 ;28f8 00
    nop                 ;28f9 00
    nop                 ;28fa 00
    nop                 ;28fb 00
    nop                 ;28fc 00
    nop                 ;28fd 00
    nop                 ;28fe 00
    nop                 ;28ff 00
    nop                 ;2900 00
    nop                 ;2901 00
    nop                 ;2902 00
    nop                 ;2903 00
    nop                 ;2904 00
    nop                 ;2905 00
    nop                 ;2906 00
    nop                 ;2907 00
    nop                 ;2908 00
    nop                 ;2909 00
    nop                 ;290a 00
    nop                 ;290b 00
    nop                 ;290c 00
    nop                 ;290d 00
    nop                 ;290e 00
    nop                 ;290f 00
    nop                 ;2910 00
    nop                 ;2911 00
    nop                 ;2912 00
    nop                 ;2913 00
    nop                 ;2914 00
    nop                 ;2915 00
    nop                 ;2916 00
    nop                 ;2917 00
    nop                 ;2918 00
    nop                 ;2919 00
    nop                 ;291a 00
    nop                 ;291b 00
    nop                 ;291c 00
    nop                 ;291d 00
    nop                 ;291e 00
    nop                 ;291f 00
    nop                 ;2920 00
    nop                 ;2921 00
    nop                 ;2922 00
    nop                 ;2923 00
    nop                 ;2924 00
    nop                 ;2925 00
    nop                 ;2926 00
    nop                 ;2927 00
    nop                 ;2928 00
    nop                 ;2929 00
    nop                 ;292a 00
    nop                 ;292b 00
    nop                 ;292c 00
    nop                 ;292d 00
    nop                 ;292e 00
    nop                 ;292f 00
    nop                 ;2930 00
    nop                 ;2931 00
    nop                 ;2932 00
    nop                 ;2933 00
    nop                 ;2934 00
    nop                 ;2935 00
    nop                 ;2936 00
    nop                 ;2937 00
    nop                 ;2938 00
    nop                 ;2939 00
    nop                 ;293a 00
    nop                 ;293b 00
    nop                 ;293c 00
    nop                 ;293d 00
    nop                 ;293e 00
    nop                 ;293f 00
    nop                 ;2940 00
    nop                 ;2941 00
    nop                 ;2942 00
    nop                 ;2943 00
    nop                 ;2944 00
    nop                 ;2945 00
    nop                 ;2946 00
    nop                 ;2947 00
    nop                 ;2948 00
    nop                 ;2949 00
    nop                 ;294a 00
    nop                 ;294b 00
    nop                 ;294c 00
    nop                 ;294d 00
    nop                 ;294e 00
    nop                 ;294f 00
    nop                 ;2950 00
    nop                 ;2951 00
    nop                 ;2952 00
    nop                 ;2953 00
    nop                 ;2954 00
    nop                 ;2955 00
    nop                 ;2956 00
    nop                 ;2957 00
    nop                 ;2958 00
    nop                 ;2959 00
    nop                 ;295a 00
    nop                 ;295b 00
    nop                 ;295c 00
    nop                 ;295d 00
    nop                 ;295e 00
    nop                 ;295f 00
    nop                 ;2960 00
    nop                 ;2961 00
    nop                 ;2962 00
    nop                 ;2963 00
    nop                 ;2964 00
    nop                 ;2965 00
    nop                 ;2966 00
    nop                 ;2967 00
    nop                 ;2968 00
    nop                 ;2969 00
    nop                 ;296a 00
    nop                 ;296b 00
    nop                 ;296c 00
    nop                 ;296d 00
    nop                 ;296e 00
    nop                 ;296f 00
    nop                 ;2970 00
    nop                 ;2971 00
    nop                 ;2972 00
    nop                 ;2973 00
    nop                 ;2974 00
    nop                 ;2975 00
    nop                 ;2976 00
    nop                 ;2977 00
    nop                 ;2978 00
    nop                 ;2979 00
    nop                 ;297a 00
    nop                 ;297b 00
    nop                 ;297c 00
    nop                 ;297d 00
    nop                 ;297e 00
    nop                 ;297f 00
    nop                 ;2980 00
    nop                 ;2981 00
    nop                 ;2982 00
    nop                 ;2983 00
    nop                 ;2984 00
    nop                 ;2985 00
    nop                 ;2986 00
    nop                 ;2987 00
    nop                 ;2988 00
    nop                 ;2989 00
    nop                 ;298a 00
    nop                 ;298b 00
    nop                 ;298c 00
    nop                 ;298d 00
    nop                 ;298e 00
    nop                 ;298f 00
    nop                 ;2990 00
    nop                 ;2991 00
    nop                 ;2992 00
    nop                 ;2993 00
    nop                 ;2994 00
    nop                 ;2995 00
    nop                 ;2996 00
    nop                 ;2997 00
    nop                 ;2998 00
    nop                 ;2999 00
    nop                 ;299a 00
    nop                 ;299b 00
    nop                 ;299c 00
    nop                 ;299d 00
    nop                 ;299e 00
    nop                 ;299f 00
    nop                 ;29a0 00
    nop                 ;29a1 00
    nop                 ;29a2 00
    nop                 ;29a3 00
    nop                 ;29a4 00
    nop                 ;29a5 00
    nop                 ;29a6 00
    nop                 ;29a7 00
    nop                 ;29a8 00
    nop                 ;29a9 00
    nop                 ;29aa 00
    nop                 ;29ab 00
    nop                 ;29ac 00
    nop                 ;29ad 00
    nop                 ;29ae 00
    nop                 ;29af 00
    nop                 ;29b0 00
    nop                 ;29b1 00
    nop                 ;29b2 00
    nop                 ;29b3 00
    nop                 ;29b4 00
    nop                 ;29b5 00
    nop                 ;29b6 00
    nop                 ;29b7 00
    nop                 ;29b8 00
    nop                 ;29b9 00
    nop                 ;29ba 00
    nop                 ;29bb 00
    nop                 ;29bc 00
    nop                 ;29bd 00
    nop                 ;29be 00
    nop                 ;29bf 00
    nop                 ;29c0 00
    nop                 ;29c1 00
    nop                 ;29c2 00
    nop                 ;29c3 00
    nop                 ;29c4 00
    nop                 ;29c5 00
    nop                 ;29c6 00
    nop                 ;29c7 00
    nop                 ;29c8 00
    nop                 ;29c9 00
    nop                 ;29ca 00
    nop                 ;29cb 00
    nop                 ;29cc 00
    nop                 ;29cd 00
    nop                 ;29ce 00
    nop                 ;29cf 00
    nop                 ;29d0 00
    nop                 ;29d1 00
    nop                 ;29d2 00
    nop                 ;29d3 00
    nop                 ;29d4 00
    nop                 ;29d5 00
    nop                 ;29d6 00
    nop                 ;29d7 00
    nop                 ;29d8 00
    nop                 ;29d9 00
    nop                 ;29da 00
    nop                 ;29db 00
    nop                 ;29dc 00
    nop                 ;29dd 00
    nop                 ;29de 00
    nop                 ;29df 00
    nop                 ;29e0 00
    nop                 ;29e1 00
    nop                 ;29e2 00
    nop                 ;29e3 00
    nop                 ;29e4 00
    nop                 ;29e5 00
    nop                 ;29e6 00
    nop                 ;29e7 00
    nop                 ;29e8 00
    nop                 ;29e9 00
    nop                 ;29ea 00
    nop                 ;29eb 00
    nop                 ;29ec 00
    nop                 ;29ed 00
    nop                 ;29ee 00
    nop                 ;29ef 00
    nop                 ;29f0 00
    nop                 ;29f1 00
    nop                 ;29f2 00
    nop                 ;29f3 00
    nop                 ;29f4 00
    nop                 ;29f5 00
    nop                 ;29f6 00
    nop                 ;29f7 00
    nop                 ;29f8 00
    nop                 ;29f9 00
    nop                 ;29fa 00
    nop                 ;29fb 00
    nop                 ;29fc 00
    nop                 ;29fd 00
    nop                 ;29fe 00
    nop                 ;29ff 00
    nop                 ;2a00 00
    nop                 ;2a01 00
    nop                 ;2a02 00
    nop                 ;2a03 00
    nop                 ;2a04 00
    nop                 ;2a05 00
    nop                 ;2a06 00
    nop                 ;2a07 00
    nop                 ;2a08 00
    nop                 ;2a09 00
    nop                 ;2a0a 00
    nop                 ;2a0b 00
    nop                 ;2a0c 00
    nop                 ;2a0d 00
    nop                 ;2a0e 00
    nop                 ;2a0f 00
    nop                 ;2a10 00
    nop                 ;2a11 00
    nop                 ;2a12 00
    nop                 ;2a13 00
    nop                 ;2a14 00
    nop                 ;2a15 00
    nop                 ;2a16 00
    nop                 ;2a17 00
    nop                 ;2a18 00
    nop                 ;2a19 00
    nop                 ;2a1a 00
    nop                 ;2a1b 00
    nop                 ;2a1c 00
    nop                 ;2a1d 00
    nop                 ;2a1e 00
    nop                 ;2a1f 00
    nop                 ;2a20 00
    nop                 ;2a21 00
    nop                 ;2a22 00
    nop                 ;2a23 00
    nop                 ;2a24 00
    nop                 ;2a25 00
    nop                 ;2a26 00
    nop                 ;2a27 00
    nop                 ;2a28 00
    nop                 ;2a29 00
    nop                 ;2a2a 00
    nop                 ;2a2b 00
    nop                 ;2a2c 00
    nop                 ;2a2d 00
    nop                 ;2a2e 00
    nop                 ;2a2f 00
    nop                 ;2a30 00
    nop                 ;2a31 00
    nop                 ;2a32 00
    nop                 ;2a33 00
    nop                 ;2a34 00
    nop                 ;2a35 00
    nop                 ;2a36 00
    nop                 ;2a37 00
    nop                 ;2a38 00
    nop                 ;2a39 00
    nop                 ;2a3a 00
    nop                 ;2a3b 00
    nop                 ;2a3c 00
    nop                 ;2a3d 00
    nop                 ;2a3e 00
    nop                 ;2a3f 00
    nop                 ;2a40 00
    nop                 ;2a41 00
    nop                 ;2a42 00
    nop                 ;2a43 00
    nop                 ;2a44 00
    nop                 ;2a45 00
    nop                 ;2a46 00
    nop                 ;2a47 00
    nop                 ;2a48 00
    nop                 ;2a49 00
    nop                 ;2a4a 00
    nop                 ;2a4b 00
    nop                 ;2a4c 00
    nop                 ;2a4d 00
    nop                 ;2a4e 00
    nop                 ;2a4f 00
    nop                 ;2a50 00
    nop                 ;2a51 00
    nop                 ;2a52 00
    nop                 ;2a53 00
    nop                 ;2a54 00
    nop                 ;2a55 00
    nop                 ;2a56 00
    nop                 ;2a57 00
    nop                 ;2a58 00
    nop                 ;2a59 00
    nop                 ;2a5a 00
    nop                 ;2a5b 00
    nop                 ;2a5c 00
    nop                 ;2a5d 00
    nop                 ;2a5e 00
    nop                 ;2a5f 00
    nop                 ;2a60 00
    nop                 ;2a61 00
    nop                 ;2a62 00
    nop                 ;2a63 00
    nop                 ;2a64 00
    nop                 ;2a65 00
    nop                 ;2a66 00
    nop                 ;2a67 00
    nop                 ;2a68 00
    nop                 ;2a69 00
    nop                 ;2a6a 00
    nop                 ;2a6b 00
    nop                 ;2a6c 00
    nop                 ;2a6d 00
    nop                 ;2a6e 00
    nop                 ;2a6f 00
    nop                 ;2a70 00
    nop                 ;2a71 00
    nop                 ;2a72 00
    nop                 ;2a73 00
    nop                 ;2a74 00
    nop                 ;2a75 00
    nop                 ;2a76 00
    nop                 ;2a77 00
    nop                 ;2a78 00
    nop                 ;2a79 00
    nop                 ;2a7a 00
    nop                 ;2a7b 00
    nop                 ;2a7c 00
    nop                 ;2a7d 00
    nop                 ;2a7e 00
    nop                 ;2a7f 00
    nop                 ;2a80 00
    nop                 ;2a81 00
    nop                 ;2a82 00
    nop                 ;2a83 00
    nop                 ;2a84 00
    nop                 ;2a85 00
    nop                 ;2a86 00
    nop                 ;2a87 00
    nop                 ;2a88 00
    nop                 ;2a89 00
    nop                 ;2a8a 00
    nop                 ;2a8b 00
    nop                 ;2a8c 00
    nop                 ;2a8d 00
    nop                 ;2a8e 00
    nop                 ;2a8f 00
    nop                 ;2a90 00
    nop                 ;2a91 00
    nop                 ;2a92 00
    nop                 ;2a93 00
    nop                 ;2a94 00
    nop                 ;2a95 00
    nop                 ;2a96 00
    nop                 ;2a97 00
    nop                 ;2a98 00
    nop                 ;2a99 00
    nop                 ;2a9a 00
    nop                 ;2a9b 00
    nop                 ;2a9c 00
    nop                 ;2a9d 00
    nop                 ;2a9e 00
    nop                 ;2a9f 00
    nop                 ;2aa0 00
    nop                 ;2aa1 00
    nop                 ;2aa2 00
    nop                 ;2aa3 00
    nop                 ;2aa4 00
    nop                 ;2aa5 00
    nop                 ;2aa6 00
    nop                 ;2aa7 00
    nop                 ;2aa8 00
    nop                 ;2aa9 00
    nop                 ;2aaa 00
    nop                 ;2aab 00
    nop                 ;2aac 00
    nop                 ;2aad 00
    nop                 ;2aae 00
    nop                 ;2aaf 00
    nop                 ;2ab0 00
    nop                 ;2ab1 00
    nop                 ;2ab2 00
    nop                 ;2ab3 00
    nop                 ;2ab4 00
    nop                 ;2ab5 00
    nop                 ;2ab6 00
    nop                 ;2ab7 00
    nop                 ;2ab8 00
    nop                 ;2ab9 00
    nop                 ;2aba 00
    nop                 ;2abb 00
    nop                 ;2abc 00
    nop                 ;2abd 00
    nop                 ;2abe 00
    nop                 ;2abf 00
    nop                 ;2ac0 00
    nop                 ;2ac1 00
    nop                 ;2ac2 00
    nop                 ;2ac3 00
    nop                 ;2ac4 00
    nop                 ;2ac5 00
    nop                 ;2ac6 00
    nop                 ;2ac7 00
    nop                 ;2ac8 00
    nop                 ;2ac9 00
    nop                 ;2aca 00
    nop                 ;2acb 00
    nop                 ;2acc 00
    nop                 ;2acd 00
    nop                 ;2ace 00
    nop                 ;2acf 00
    nop                 ;2ad0 00
    nop                 ;2ad1 00
    nop                 ;2ad2 00
    nop                 ;2ad3 00
    nop                 ;2ad4 00
    nop                 ;2ad5 00
    nop                 ;2ad6 00
    nop                 ;2ad7 00
    nop                 ;2ad8 00
    nop                 ;2ad9 00
    nop                 ;2ada 00
    nop                 ;2adb 00
    nop                 ;2adc 00
    nop                 ;2add 00
    nop                 ;2ade 00
    nop                 ;2adf 00
    nop                 ;2ae0 00
    nop                 ;2ae1 00
    nop                 ;2ae2 00
    nop                 ;2ae3 00
    nop                 ;2ae4 00
    nop                 ;2ae5 00
    nop                 ;2ae6 00
    nop                 ;2ae7 00
    nop                 ;2ae8 00
    nop                 ;2ae9 00
    nop                 ;2aea 00
    nop                 ;2aeb 00
    nop                 ;2aec 00
    nop                 ;2aed 00
    nop                 ;2aee 00
    nop                 ;2aef 00
    nop                 ;2af0 00
    nop                 ;2af1 00
    nop                 ;2af2 00
    nop                 ;2af3 00
    nop                 ;2af4 00
    nop                 ;2af5 00
    nop                 ;2af6 00
    nop                 ;2af7 00
    nop                 ;2af8 00
    nop                 ;2af9 00
    nop                 ;2afa 00
    nop                 ;2afb 00
    nop                 ;2afc 00
    nop                 ;2afd 00
    nop                 ;2afe 00
    nop                 ;2aff 00
    nop                 ;2b00 00
    nop                 ;2b01 00
    nop                 ;2b02 00
    nop                 ;2b03 00
    nop                 ;2b04 00
    nop                 ;2b05 00
    nop                 ;2b06 00
    nop                 ;2b07 00
    nop                 ;2b08 00
    nop                 ;2b09 00
    nop                 ;2b0a 00
    nop                 ;2b0b 00
    nop                 ;2b0c 00
    nop                 ;2b0d 00
    nop                 ;2b0e 00
    nop                 ;2b0f 00
    nop                 ;2b10 00
    nop                 ;2b11 00
    nop                 ;2b12 00
    nop                 ;2b13 00
    nop                 ;2b14 00
    nop                 ;2b15 00
    nop                 ;2b16 00
    nop                 ;2b17 00
    nop                 ;2b18 00
    nop                 ;2b19 00
    nop                 ;2b1a 00
    nop                 ;2b1b 00
    nop                 ;2b1c 00
    nop                 ;2b1d 00
    nop                 ;2b1e 00
    nop                 ;2b1f 00
    nop                 ;2b20 00
    nop                 ;2b21 00
    nop                 ;2b22 00
    nop                 ;2b23 00
    nop                 ;2b24 00
    nop                 ;2b25 00
    nop                 ;2b26 00
    nop                 ;2b27 00
    nop                 ;2b28 00
    nop                 ;2b29 00
    nop                 ;2b2a 00
    nop                 ;2b2b 00
    nop                 ;2b2c 00
    nop                 ;2b2d 00
    nop                 ;2b2e 00
    nop                 ;2b2f 00
    nop                 ;2b30 00
    nop                 ;2b31 00
    nop                 ;2b32 00
    nop                 ;2b33 00
    nop                 ;2b34 00
    nop                 ;2b35 00
    nop                 ;2b36 00
    nop                 ;2b37 00
    nop                 ;2b38 00
    nop                 ;2b39 00
    nop                 ;2b3a 00
    nop                 ;2b3b 00
    nop                 ;2b3c 00
    nop                 ;2b3d 00
    nop                 ;2b3e 00
    nop                 ;2b3f 00
    nop                 ;2b40 00
    nop                 ;2b41 00
    nop                 ;2b42 00
    nop                 ;2b43 00
    nop                 ;2b44 00
    nop                 ;2b45 00
    nop                 ;2b46 00
    nop                 ;2b47 00
    nop                 ;2b48 00
    nop                 ;2b49 00
    nop                 ;2b4a 00
    nop                 ;2b4b 00
    nop                 ;2b4c 00
    nop                 ;2b4d 00
    nop                 ;2b4e 00
    nop                 ;2b4f 00
    nop                 ;2b50 00
    nop                 ;2b51 00
    nop                 ;2b52 00
    nop                 ;2b53 00
    nop                 ;2b54 00
    nop                 ;2b55 00
    nop                 ;2b56 00
    nop                 ;2b57 00
    nop                 ;2b58 00
    nop                 ;2b59 00
    nop                 ;2b5a 00
    nop                 ;2b5b 00
    nop                 ;2b5c 00
    nop                 ;2b5d 00
    nop                 ;2b5e 00
    nop                 ;2b5f 00
    nop                 ;2b60 00
    nop                 ;2b61 00
    nop                 ;2b62 00
    nop                 ;2b63 00
    nop                 ;2b64 00
    nop                 ;2b65 00
    nop                 ;2b66 00
    nop                 ;2b67 00
    nop                 ;2b68 00
    nop                 ;2b69 00
    nop                 ;2b6a 00
    nop                 ;2b6b 00
    nop                 ;2b6c 00
    nop                 ;2b6d 00
    nop                 ;2b6e 00
    nop                 ;2b6f 00
    nop                 ;2b70 00
    nop                 ;2b71 00
    nop                 ;2b72 00
    nop                 ;2b73 00
    nop                 ;2b74 00
    nop                 ;2b75 00
    nop                 ;2b76 00
    nop                 ;2b77 00
    nop                 ;2b78 00
    nop                 ;2b79 00
    nop                 ;2b7a 00
    nop                 ;2b7b 00
    nop                 ;2b7c 00
    nop                 ;2b7d 00
    nop                 ;2b7e 00
    nop                 ;2b7f 00
    nop                 ;2b80 00
    nop                 ;2b81 00
    nop                 ;2b82 00
    nop                 ;2b83 00
    nop                 ;2b84 00
    nop                 ;2b85 00
    nop                 ;2b86 00
    nop                 ;2b87 00
    nop                 ;2b88 00
    nop                 ;2b89 00
    nop                 ;2b8a 00
    nop                 ;2b8b 00
    nop                 ;2b8c 00
    nop                 ;2b8d 00
    nop                 ;2b8e 00
    nop                 ;2b8f 00
    nop                 ;2b90 00
    nop                 ;2b91 00
    nop                 ;2b92 00
    nop                 ;2b93 00
    nop                 ;2b94 00
    nop                 ;2b95 00
    nop                 ;2b96 00
    nop                 ;2b97 00
    nop                 ;2b98 00
    nop                 ;2b99 00
    nop                 ;2b9a 00
    nop                 ;2b9b 00
    nop                 ;2b9c 00
    nop                 ;2b9d 00
    nop                 ;2b9e 00
    nop                 ;2b9f 00
    nop                 ;2ba0 00
    nop                 ;2ba1 00
    nop                 ;2ba2 00
    nop                 ;2ba3 00
    nop                 ;2ba4 00
    nop                 ;2ba5 00
    nop                 ;2ba6 00
    nop                 ;2ba7 00
    nop                 ;2ba8 00
    nop                 ;2ba9 00
    nop                 ;2baa 00
    nop                 ;2bab 00
    nop                 ;2bac 00
    nop                 ;2bad 00
    nop                 ;2bae 00
    nop                 ;2baf 00
    nop                 ;2bb0 00
    nop                 ;2bb1 00
    nop                 ;2bb2 00
    nop                 ;2bb3 00
    nop                 ;2bb4 00
    nop                 ;2bb5 00
    nop                 ;2bb6 00
    nop                 ;2bb7 00
    nop                 ;2bb8 00
    nop                 ;2bb9 00
    nop                 ;2bba 00
    nop                 ;2bbb 00
    nop                 ;2bbc 00
    nop                 ;2bbd 00
    nop                 ;2bbe 00
    nop                 ;2bbf 00
    nop                 ;2bc0 00
    nop                 ;2bc1 00
    nop                 ;2bc2 00
    nop                 ;2bc3 00
    nop                 ;2bc4 00
    nop                 ;2bc5 00
    nop                 ;2bc6 00
    nop                 ;2bc7 00
    nop                 ;2bc8 00
    nop                 ;2bc9 00
    nop                 ;2bca 00
    nop                 ;2bcb 00
    nop                 ;2bcc 00
    nop                 ;2bcd 00
    nop                 ;2bce 00
    nop                 ;2bcf 00
    nop                 ;2bd0 00
    nop                 ;2bd1 00
    nop                 ;2bd2 00
    nop                 ;2bd3 00
    nop                 ;2bd4 00
    nop                 ;2bd5 00
    nop                 ;2bd6 00
    nop                 ;2bd7 00
    nop                 ;2bd8 00
    nop                 ;2bd9 00
    nop                 ;2bda 00
    nop                 ;2bdb 00
    nop                 ;2bdc 00
    nop                 ;2bdd 00
    nop                 ;2bde 00
    nop                 ;2bdf 00
    nop                 ;2be0 00
    nop                 ;2be1 00
    nop                 ;2be2 00
    nop                 ;2be3 00
    nop                 ;2be4 00
    nop                 ;2be5 00
    nop                 ;2be6 00
    nop                 ;2be7 00
    nop                 ;2be8 00
    nop                 ;2be9 00
    nop                 ;2bea 00
    nop                 ;2beb 00
    nop                 ;2bec 00
    nop                 ;2bed 00
    nop                 ;2bee 00
    nop                 ;2bef 00
    nop                 ;2bf0 00
    nop                 ;2bf1 00
    nop                 ;2bf2 00
    nop                 ;2bf3 00
    nop                 ;2bf4 00
    nop                 ;2bf5 00
    nop                 ;2bf6 00
    nop                 ;2bf7 00
    nop                 ;2bf8 00
    nop                 ;2bf9 00
    nop                 ;2bfa 00
    nop                 ;2bfb 00
    nop                 ;2bfc 00
    nop                 ;2bfd 00
    nop                 ;2bfe 00
    nop                 ;2bff 00
    nop                 ;2c00 00
    nop                 ;2c01 00
    nop                 ;2c02 00
    nop                 ;2c03 00
    nop                 ;2c04 00
    nop                 ;2c05 00
    nop                 ;2c06 00
    nop                 ;2c07 00
    nop                 ;2c08 00
    nop                 ;2c09 00
    nop                 ;2c0a 00
    nop                 ;2c0b 00
    nop                 ;2c0c 00
    nop                 ;2c0d 00
    nop                 ;2c0e 00
    nop                 ;2c0f 00
    nop                 ;2c10 00
    nop                 ;2c11 00
    nop                 ;2c12 00
    nop                 ;2c13 00
    nop                 ;2c14 00
    nop                 ;2c15 00
    nop                 ;2c16 00
    nop                 ;2c17 00
    nop                 ;2c18 00
    nop                 ;2c19 00
    nop                 ;2c1a 00
    nop                 ;2c1b 00
    nop                 ;2c1c 00
    nop                 ;2c1d 00
    nop                 ;2c1e 00
    nop                 ;2c1f 00
    nop                 ;2c20 00
    nop                 ;2c21 00
    nop                 ;2c22 00
    nop                 ;2c23 00
    nop                 ;2c24 00
    nop                 ;2c25 00
    nop                 ;2c26 00
    nop                 ;2c27 00
    nop                 ;2c28 00
    nop                 ;2c29 00
    nop                 ;2c2a 00
    nop                 ;2c2b 00
    nop                 ;2c2c 00
    nop                 ;2c2d 00
    nop                 ;2c2e 00
    nop                 ;2c2f 00
    nop                 ;2c30 00
    nop                 ;2c31 00
    nop                 ;2c32 00
    nop                 ;2c33 00
    nop                 ;2c34 00
    nop                 ;2c35 00
    nop                 ;2c36 00
    nop                 ;2c37 00
    nop                 ;2c38 00
    nop                 ;2c39 00
    nop                 ;2c3a 00
    nop                 ;2c3b 00
    nop                 ;2c3c 00
    nop                 ;2c3d 00
    nop                 ;2c3e 00
    nop                 ;2c3f 00
    nop                 ;2c40 00
    nop                 ;2c41 00
    nop                 ;2c42 00
    nop                 ;2c43 00
    nop                 ;2c44 00
    nop                 ;2c45 00
    nop                 ;2c46 00
    nop                 ;2c47 00
    nop                 ;2c48 00
    nop                 ;2c49 00
    nop                 ;2c4a 00
    nop                 ;2c4b 00
    nop                 ;2c4c 00
    nop                 ;2c4d 00
    nop                 ;2c4e 00
    nop                 ;2c4f 00
    nop                 ;2c50 00
    nop                 ;2c51 00
    nop                 ;2c52 00
    nop                 ;2c53 00
    nop                 ;2c54 00
    nop                 ;2c55 00
    nop                 ;2c56 00
    nop                 ;2c57 00
    nop                 ;2c58 00
    nop                 ;2c59 00
    nop                 ;2c5a 00
    nop                 ;2c5b 00
    nop                 ;2c5c 00
    nop                 ;2c5d 00
    nop                 ;2c5e 00
    nop                 ;2c5f 00
    nop                 ;2c60 00
    nop                 ;2c61 00
    nop                 ;2c62 00
    nop                 ;2c63 00
    nop                 ;2c64 00
    nop                 ;2c65 00
    nop                 ;2c66 00
    nop                 ;2c67 00
    nop                 ;2c68 00
    nop                 ;2c69 00
    nop                 ;2c6a 00
    nop                 ;2c6b 00
    nop                 ;2c6c 00
    nop                 ;2c6d 00
    nop                 ;2c6e 00
    nop                 ;2c6f 00
    nop                 ;2c70 00
    nop                 ;2c71 00
    nop                 ;2c72 00
    nop                 ;2c73 00
    nop                 ;2c74 00
    nop                 ;2c75 00
    nop                 ;2c76 00
    nop                 ;2c77 00
    nop                 ;2c78 00
    nop                 ;2c79 00
    nop                 ;2c7a 00
    nop                 ;2c7b 00
    nop                 ;2c7c 00
    nop                 ;2c7d 00
    nop                 ;2c7e 00
    nop                 ;2c7f 00
    nop                 ;2c80 00
    nop                 ;2c81 00
    nop                 ;2c82 00
    nop                 ;2c83 00
    nop                 ;2c84 00
    nop                 ;2c85 00
    nop                 ;2c86 00
    nop                 ;2c87 00
    nop                 ;2c88 00
    nop                 ;2c89 00
    nop                 ;2c8a 00
    nop                 ;2c8b 00
    nop                 ;2c8c 00
    nop                 ;2c8d 00
    nop                 ;2c8e 00
    nop                 ;2c8f 00
    nop                 ;2c90 00
    nop                 ;2c91 00
    nop                 ;2c92 00
    nop                 ;2c93 00
    nop                 ;2c94 00
    nop                 ;2c95 00
    nop                 ;2c96 00
    nop                 ;2c97 00
    nop                 ;2c98 00
    nop                 ;2c99 00
    nop                 ;2c9a 00
    nop                 ;2c9b 00
    nop                 ;2c9c 00
    nop                 ;2c9d 00
    nop                 ;2c9e 00
    nop                 ;2c9f 00
    nop                 ;2ca0 00
    nop                 ;2ca1 00
    nop                 ;2ca2 00
    nop                 ;2ca3 00
    nop                 ;2ca4 00
    nop                 ;2ca5 00
    nop                 ;2ca6 00
    nop                 ;2ca7 00
    nop                 ;2ca8 00
    nop                 ;2ca9 00
    nop                 ;2caa 00
    nop                 ;2cab 00
    nop                 ;2cac 00
    nop                 ;2cad 00
    nop                 ;2cae 00
    nop                 ;2caf 00
    nop                 ;2cb0 00
    nop                 ;2cb1 00
    nop                 ;2cb2 00
    nop                 ;2cb3 00
    nop                 ;2cb4 00
    nop                 ;2cb5 00
    nop                 ;2cb6 00
    nop                 ;2cb7 00
    nop                 ;2cb8 00
    nop                 ;2cb9 00
    nop                 ;2cba 00
    nop                 ;2cbb 00
    nop                 ;2cbc 00
    nop                 ;2cbd 00
    nop                 ;2cbe 00
    nop                 ;2cbf 00
    nop                 ;2cc0 00
    nop                 ;2cc1 00
    nop                 ;2cc2 00
    nop                 ;2cc3 00
    nop                 ;2cc4 00
    nop                 ;2cc5 00
    nop                 ;2cc6 00
    nop                 ;2cc7 00
    nop                 ;2cc8 00
    nop                 ;2cc9 00
    nop                 ;2cca 00
    nop                 ;2ccb 00
    nop                 ;2ccc 00
    nop                 ;2ccd 00
    nop                 ;2cce 00
    nop                 ;2ccf 00
    nop                 ;2cd0 00
    nop                 ;2cd1 00
    nop                 ;2cd2 00
    nop                 ;2cd3 00
    nop                 ;2cd4 00
    nop                 ;2cd5 00
    nop                 ;2cd6 00
    nop                 ;2cd7 00
    nop                 ;2cd8 00
    nop                 ;2cd9 00
    nop                 ;2cda 00
    nop                 ;2cdb 00
    nop                 ;2cdc 00
    nop                 ;2cdd 00
    nop                 ;2cde 00
    nop                 ;2cdf 00
    nop                 ;2ce0 00
    nop                 ;2ce1 00
    nop                 ;2ce2 00
    nop                 ;2ce3 00
    nop                 ;2ce4 00
    nop                 ;2ce5 00
    nop                 ;2ce6 00
    nop                 ;2ce7 00
    nop                 ;2ce8 00
    nop                 ;2ce9 00
    nop                 ;2cea 00
    nop                 ;2ceb 00
    nop                 ;2cec 00
    nop                 ;2ced 00
    nop                 ;2cee 00
    nop                 ;2cef 00
    nop                 ;2cf0 00
    nop                 ;2cf1 00
    nop                 ;2cf2 00
    nop                 ;2cf3 00
    nop                 ;2cf4 00
    nop                 ;2cf5 00
    nop                 ;2cf6 00
    nop                 ;2cf7 00
    nop                 ;2cf8 00
    nop                 ;2cf9 00
    nop                 ;2cfa 00
    nop                 ;2cfb 00
    nop                 ;2cfc 00
    nop                 ;2cfd 00
    nop                 ;2cfe 00
    nop                 ;2cff 00
    nop                 ;2d00 00
    nop                 ;2d01 00
    nop                 ;2d02 00
    nop                 ;2d03 00
    nop                 ;2d04 00
    nop                 ;2d05 00
    nop                 ;2d06 00
    nop                 ;2d07 00
    nop                 ;2d08 00
    nop                 ;2d09 00
    nop                 ;2d0a 00
    nop                 ;2d0b 00
    nop                 ;2d0c 00
    nop                 ;2d0d 00
    nop                 ;2d0e 00
    nop                 ;2d0f 00
    nop                 ;2d10 00
    nop                 ;2d11 00
    nop                 ;2d12 00
    nop                 ;2d13 00
    nop                 ;2d14 00
    nop                 ;2d15 00
    nop                 ;2d16 00
    nop                 ;2d17 00
    nop                 ;2d18 00
    nop                 ;2d19 00
    nop                 ;2d1a 00
    nop                 ;2d1b 00
    nop                 ;2d1c 00
    nop                 ;2d1d 00
    nop                 ;2d1e 00
    nop                 ;2d1f 00
    nop                 ;2d20 00
    nop                 ;2d21 00
    nop                 ;2d22 00
    nop                 ;2d23 00
    nop                 ;2d24 00
    nop                 ;2d25 00
    nop                 ;2d26 00
    nop                 ;2d27 00
    nop                 ;2d28 00
    nop                 ;2d29 00
    nop                 ;2d2a 00
    nop                 ;2d2b 00
    nop                 ;2d2c 00
    nop                 ;2d2d 00
    nop                 ;2d2e 00
    nop                 ;2d2f 00
    nop                 ;2d30 00
    nop                 ;2d31 00
    nop                 ;2d32 00
    nop                 ;2d33 00
    nop                 ;2d34 00
    nop                 ;2d35 00
    nop                 ;2d36 00
    nop                 ;2d37 00
    nop                 ;2d38 00
    nop                 ;2d39 00
    nop                 ;2d3a 00
    nop                 ;2d3b 00
    nop                 ;2d3c 00
    nop                 ;2d3d 00
    nop                 ;2d3e 00
    nop                 ;2d3f 00
    nop                 ;2d40 00
    nop                 ;2d41 00
    nop                 ;2d42 00
    nop                 ;2d43 00
    nop                 ;2d44 00
    nop                 ;2d45 00
    nop                 ;2d46 00
    nop                 ;2d47 00
    nop                 ;2d48 00
    nop                 ;2d49 00
    nop                 ;2d4a 00
    nop                 ;2d4b 00
    nop                 ;2d4c 00
    nop                 ;2d4d 00
    nop                 ;2d4e 00
    nop                 ;2d4f 00
    nop                 ;2d50 00
    nop                 ;2d51 00
    nop                 ;2d52 00
    nop                 ;2d53 00
    nop                 ;2d54 00
    nop                 ;2d55 00
    nop                 ;2d56 00
    nop                 ;2d57 00
    nop                 ;2d58 00
    nop                 ;2d59 00
    nop                 ;2d5a 00
    nop                 ;2d5b 00
    nop                 ;2d5c 00
    nop                 ;2d5d 00
    nop                 ;2d5e 00
    nop                 ;2d5f 00
    nop                 ;2d60 00
    nop                 ;2d61 00
    nop                 ;2d62 00
    nop                 ;2d63 00
    nop                 ;2d64 00
    nop                 ;2d65 00
    nop                 ;2d66 00
    nop                 ;2d67 00
    nop                 ;2d68 00
    nop                 ;2d69 00
    nop                 ;2d6a 00
    nop                 ;2d6b 00
    nop                 ;2d6c 00
    nop                 ;2d6d 00
    nop                 ;2d6e 00
    nop                 ;2d6f 00
    nop                 ;2d70 00
    nop                 ;2d71 00
    nop                 ;2d72 00
    nop                 ;2d73 00
    nop                 ;2d74 00
    nop                 ;2d75 00
    nop                 ;2d76 00
    nop                 ;2d77 00
    nop                 ;2d78 00
    nop                 ;2d79 00
    nop                 ;2d7a 00
    nop                 ;2d7b 00
    nop                 ;2d7c 00
    nop                 ;2d7d 00
    nop                 ;2d7e 00
    nop                 ;2d7f 00
    nop                 ;2d80 00
    nop                 ;2d81 00
    nop                 ;2d82 00
    nop                 ;2d83 00
    nop                 ;2d84 00
    nop                 ;2d85 00
    nop                 ;2d86 00
    nop                 ;2d87 00
    nop                 ;2d88 00
    nop                 ;2d89 00
    nop                 ;2d8a 00
    nop                 ;2d8b 00
    nop                 ;2d8c 00
    nop                 ;2d8d 00
    nop                 ;2d8e 00
    nop                 ;2d8f 00
    nop                 ;2d90 00
    nop                 ;2d91 00
    nop                 ;2d92 00
    nop                 ;2d93 00
    nop                 ;2d94 00
    nop                 ;2d95 00
    nop                 ;2d96 00
    nop                 ;2d97 00
    nop                 ;2d98 00
    nop                 ;2d99 00
    nop                 ;2d9a 00
    nop                 ;2d9b 00
    nop                 ;2d9c 00
    nop                 ;2d9d 00
    nop                 ;2d9e 00
    nop                 ;2d9f 00
    nop                 ;2da0 00
    nop                 ;2da1 00
    nop                 ;2da2 00
    nop                 ;2da3 00
    nop                 ;2da4 00
    nop                 ;2da5 00
    nop                 ;2da6 00
    nop                 ;2da7 00
    nop                 ;2da8 00
    nop                 ;2da9 00
    nop                 ;2daa 00
    nop                 ;2dab 00
    nop                 ;2dac 00
    nop                 ;2dad 00
    nop                 ;2dae 00
    nop                 ;2daf 00
    nop                 ;2db0 00
    nop                 ;2db1 00
    nop                 ;2db2 00
    nop                 ;2db3 00
    nop                 ;2db4 00
    nop                 ;2db5 00
    nop                 ;2db6 00
    nop                 ;2db7 00
    nop                 ;2db8 00
    nop                 ;2db9 00
    nop                 ;2dba 00
    nop                 ;2dbb 00
    nop                 ;2dbc 00
    nop                 ;2dbd 00
    nop                 ;2dbe 00
    nop                 ;2dbf 00
    nop                 ;2dc0 00
    nop                 ;2dc1 00
    nop                 ;2dc2 00
    nop                 ;2dc3 00
    nop                 ;2dc4 00
    nop                 ;2dc5 00
    nop                 ;2dc6 00
    nop                 ;2dc7 00
    nop                 ;2dc8 00
    nop                 ;2dc9 00
    nop                 ;2dca 00
    nop                 ;2dcb 00
    nop                 ;2dcc 00
    nop                 ;2dcd 00
    nop                 ;2dce 00
    nop                 ;2dcf 00
    nop                 ;2dd0 00
    nop                 ;2dd1 00
    nop                 ;2dd2 00
    nop                 ;2dd3 00
    nop                 ;2dd4 00
    nop                 ;2dd5 00
    nop                 ;2dd6 00
    nop                 ;2dd7 00
    nop                 ;2dd8 00
    nop                 ;2dd9 00
    nop                 ;2dda 00
    nop                 ;2ddb 00
    nop                 ;2ddc 00
    nop                 ;2ddd 00
    nop                 ;2dde 00
    nop                 ;2ddf 00
    nop                 ;2de0 00
    nop                 ;2de1 00
    nop                 ;2de2 00
    nop                 ;2de3 00
    nop                 ;2de4 00
    nop                 ;2de5 00
    nop                 ;2de6 00
    nop                 ;2de7 00
    nop                 ;2de8 00
    nop                 ;2de9 00
    nop                 ;2dea 00
    nop                 ;2deb 00
    nop                 ;2dec 00
    nop                 ;2ded 00
    nop                 ;2dee 00
    nop                 ;2def 00
    nop                 ;2df0 00
    nop                 ;2df1 00
    nop                 ;2df2 00
    nop                 ;2df3 00
    nop                 ;2df4 00
    nop                 ;2df5 00
    nop                 ;2df6 00
    nop                 ;2df7 00
    nop                 ;2df8 00
    nop                 ;2df9 00
    nop                 ;2dfa 00
    nop                 ;2dfb 00
    nop                 ;2dfc 00
    nop                 ;2dfd 00
    nop                 ;2dfe 00
    nop                 ;2dff 00
    nop                 ;2e00 00
    nop                 ;2e01 00
    nop                 ;2e02 00
    nop                 ;2e03 00
    nop                 ;2e04 00
    nop                 ;2e05 00
    nop                 ;2e06 00
    nop                 ;2e07 00
    nop                 ;2e08 00
    nop                 ;2e09 00
    nop                 ;2e0a 00
    nop                 ;2e0b 00
    nop                 ;2e0c 00
    nop                 ;2e0d 00
    nop                 ;2e0e 00
    nop                 ;2e0f 00
    nop                 ;2e10 00
    nop                 ;2e11 00
    nop                 ;2e12 00
    nop                 ;2e13 00
    nop                 ;2e14 00
    nop                 ;2e15 00
    nop                 ;2e16 00
    nop                 ;2e17 00
    nop                 ;2e18 00
    nop                 ;2e19 00
    nop                 ;2e1a 00
    nop                 ;2e1b 00
    nop                 ;2e1c 00
    nop                 ;2e1d 00
    nop                 ;2e1e 00
    nop                 ;2e1f 00
    nop                 ;2e20 00
    nop                 ;2e21 00
    nop                 ;2e22 00
    nop                 ;2e23 00
    nop                 ;2e24 00
    nop                 ;2e25 00
    nop                 ;2e26 00
    nop                 ;2e27 00
    nop                 ;2e28 00
    nop                 ;2e29 00
    nop                 ;2e2a 00
    nop                 ;2e2b 00
    nop                 ;2e2c 00
    nop                 ;2e2d 00
    nop                 ;2e2e 00
    nop                 ;2e2f 00
    nop                 ;2e30 00
    nop                 ;2e31 00
    nop                 ;2e32 00
    nop                 ;2e33 00
    nop                 ;2e34 00
    nop                 ;2e35 00
    nop                 ;2e36 00
    nop                 ;2e37 00
    nop                 ;2e38 00
    nop                 ;2e39 00
    nop                 ;2e3a 00
    nop                 ;2e3b 00
    nop                 ;2e3c 00
    nop                 ;2e3d 00
    nop                 ;2e3e 00
    nop                 ;2e3f 00
    nop                 ;2e40 00
    nop                 ;2e41 00
    nop                 ;2e42 00
    nop                 ;2e43 00
    nop                 ;2e44 00
    nop                 ;2e45 00
    nop                 ;2e46 00
    nop                 ;2e47 00
    nop                 ;2e48 00
    nop                 ;2e49 00
    nop                 ;2e4a 00
    nop                 ;2e4b 00
    nop                 ;2e4c 00
    nop                 ;2e4d 00
    nop                 ;2e4e 00
    nop                 ;2e4f 00
    nop                 ;2e50 00
    nop                 ;2e51 00
    nop                 ;2e52 00
    nop                 ;2e53 00
    nop                 ;2e54 00
    nop                 ;2e55 00
    nop                 ;2e56 00
    nop                 ;2e57 00
    nop                 ;2e58 00
    nop                 ;2e59 00
    nop                 ;2e5a 00
    nop                 ;2e5b 00
    nop                 ;2e5c 00
    nop                 ;2e5d 00
    nop                 ;2e5e 00
    nop                 ;2e5f 00
    nop                 ;2e60 00
    nop                 ;2e61 00
    nop                 ;2e62 00
    nop                 ;2e63 00
    nop                 ;2e64 00
    nop                 ;2e65 00
    nop                 ;2e66 00
    nop                 ;2e67 00
    nop                 ;2e68 00
    nop                 ;2e69 00
    nop                 ;2e6a 00
    nop                 ;2e6b 00
    nop                 ;2e6c 00
    nop                 ;2e6d 00
    nop                 ;2e6e 00
    nop                 ;2e6f 00
    nop                 ;2e70 00
    nop                 ;2e71 00
    nop                 ;2e72 00
    nop                 ;2e73 00
    nop                 ;2e74 00
    nop                 ;2e75 00
    nop                 ;2e76 00
    nop                 ;2e77 00
    nop                 ;2e78 00
    nop                 ;2e79 00
    nop                 ;2e7a 00
    nop                 ;2e7b 00
    nop                 ;2e7c 00
    nop                 ;2e7d 00
    nop                 ;2e7e 00
    nop                 ;2e7f 00
    nop                 ;2e80 00
    nop                 ;2e81 00
    nop                 ;2e82 00
    nop                 ;2e83 00
    nop                 ;2e84 00
    nop                 ;2e85 00
    nop                 ;2e86 00
    nop                 ;2e87 00
    nop                 ;2e88 00
    nop                 ;2e89 00
    nop                 ;2e8a 00
    nop                 ;2e8b 00
    nop                 ;2e8c 00
    nop                 ;2e8d 00
    nop                 ;2e8e 00
    nop                 ;2e8f 00
    nop                 ;2e90 00
    nop                 ;2e91 00
    nop                 ;2e92 00
    nop                 ;2e93 00
    nop                 ;2e94 00
    nop                 ;2e95 00
    nop                 ;2e96 00
    nop                 ;2e97 00
    nop                 ;2e98 00
    nop                 ;2e99 00
    nop                 ;2e9a 00
    nop                 ;2e9b 00
    nop                 ;2e9c 00
    nop                 ;2e9d 00
    nop                 ;2e9e 00
    nop                 ;2e9f 00
    nop                 ;2ea0 00
    nop                 ;2ea1 00
    nop                 ;2ea2 00
    nop                 ;2ea3 00
    nop                 ;2ea4 00
    nop                 ;2ea5 00
    nop                 ;2ea6 00
    nop                 ;2ea7 00
    nop                 ;2ea8 00
    nop                 ;2ea9 00
    nop                 ;2eaa 00
    nop                 ;2eab 00
    nop                 ;2eac 00
    nop                 ;2ead 00
    nop                 ;2eae 00
    nop                 ;2eaf 00
    nop                 ;2eb0 00
    nop                 ;2eb1 00
    nop                 ;2eb2 00
    nop                 ;2eb3 00
    nop                 ;2eb4 00
    nop                 ;2eb5 00
    nop                 ;2eb6 00
    nop                 ;2eb7 00
    nop                 ;2eb8 00
    nop                 ;2eb9 00
    nop                 ;2eba 00
    nop                 ;2ebb 00
    nop                 ;2ebc 00
    nop                 ;2ebd 00
    nop                 ;2ebe 00
    nop                 ;2ebf 00
    nop                 ;2ec0 00
    nop                 ;2ec1 00
    nop                 ;2ec2 00
    nop                 ;2ec3 00
    nop                 ;2ec4 00
    nop                 ;2ec5 00
    nop                 ;2ec6 00
    nop                 ;2ec7 00
    nop                 ;2ec8 00
    nop                 ;2ec9 00
    nop                 ;2eca 00
    nop                 ;2ecb 00
    nop                 ;2ecc 00
    nop                 ;2ecd 00
    nop                 ;2ece 00
    nop                 ;2ecf 00
    nop                 ;2ed0 00
    nop                 ;2ed1 00
    nop                 ;2ed2 00
    nop                 ;2ed3 00
    nop                 ;2ed4 00
    nop                 ;2ed5 00
    nop                 ;2ed6 00
    nop                 ;2ed7 00
    nop                 ;2ed8 00
    nop                 ;2ed9 00
    nop                 ;2eda 00
    nop                 ;2edb 00
    nop                 ;2edc 00
    nop                 ;2edd 00
    nop                 ;2ede 00
    nop                 ;2edf 00
    nop                 ;2ee0 00
    nop                 ;2ee1 00
    nop                 ;2ee2 00
    nop                 ;2ee3 00
    nop                 ;2ee4 00
    nop                 ;2ee5 00
    nop                 ;2ee6 00
    nop                 ;2ee7 00
    nop                 ;2ee8 00
    nop                 ;2ee9 00
    nop                 ;2eea 00
    nop                 ;2eeb 00
    nop                 ;2eec 00
    nop                 ;2eed 00
    nop                 ;2eee 00
    nop                 ;2eef 00
    nop                 ;2ef0 00
    nop                 ;2ef1 00
    nop                 ;2ef2 00
    nop                 ;2ef3 00
    nop                 ;2ef4 00
    nop                 ;2ef5 00
    nop                 ;2ef6 00
    nop                 ;2ef7 00
    nop                 ;2ef8 00
    nop                 ;2ef9 00
    nop                 ;2efa 00
    nop                 ;2efb 00
    nop                 ;2efc 00
    nop                 ;2efd 00
    nop                 ;2efe 00
    nop                 ;2eff 00
    nop                 ;2f00 00
    nop                 ;2f01 00
    nop                 ;2f02 00
    nop                 ;2f03 00
    nop                 ;2f04 00
    nop                 ;2f05 00
    nop                 ;2f06 00
    nop                 ;2f07 00
    nop                 ;2f08 00
    nop                 ;2f09 00
    nop                 ;2f0a 00
    nop                 ;2f0b 00
    nop                 ;2f0c 00
    nop                 ;2f0d 00
    nop                 ;2f0e 00
    nop                 ;2f0f 00
    nop                 ;2f10 00
    nop                 ;2f11 00
    nop                 ;2f12 00
    nop                 ;2f13 00
    nop                 ;2f14 00
    nop                 ;2f15 00
    nop                 ;2f16 00
    nop                 ;2f17 00
    nop                 ;2f18 00
    nop                 ;2f19 00
    nop                 ;2f1a 00
    nop                 ;2f1b 00
    nop                 ;2f1c 00
    nop                 ;2f1d 00
    nop                 ;2f1e 00
    nop                 ;2f1f 00
    nop                 ;2f20 00
    nop                 ;2f21 00
    nop                 ;2f22 00
    nop                 ;2f23 00
    nop                 ;2f24 00
    nop                 ;2f25 00
    nop                 ;2f26 00
    nop                 ;2f27 00
    nop                 ;2f28 00
    nop                 ;2f29 00
    nop                 ;2f2a 00
    nop                 ;2f2b 00
    nop                 ;2f2c 00
    nop                 ;2f2d 00
    nop                 ;2f2e 00
    nop                 ;2f2f 00
    nop                 ;2f30 00
    nop                 ;2f31 00
    nop                 ;2f32 00
    nop                 ;2f33 00
    nop                 ;2f34 00
    nop                 ;2f35 00
    nop                 ;2f36 00
    nop                 ;2f37 00
    nop                 ;2f38 00
    nop                 ;2f39 00
    nop                 ;2f3a 00
    nop                 ;2f3b 00
    nop                 ;2f3c 00
    nop                 ;2f3d 00
    nop                 ;2f3e 00
    nop                 ;2f3f 00
    nop                 ;2f40 00
    nop                 ;2f41 00
    nop                 ;2f42 00
    nop                 ;2f43 00
    nop                 ;2f44 00
    nop                 ;2f45 00
    nop                 ;2f46 00
    nop                 ;2f47 00
    nop                 ;2f48 00
    nop                 ;2f49 00
    nop                 ;2f4a 00
    nop                 ;2f4b 00
    nop                 ;2f4c 00
    nop                 ;2f4d 00
    nop                 ;2f4e 00
    nop                 ;2f4f 00
    nop                 ;2f50 00
    nop                 ;2f51 00
    nop                 ;2f52 00
    nop                 ;2f53 00
    nop                 ;2f54 00
    nop                 ;2f55 00
    nop                 ;2f56 00
    nop                 ;2f57 00
    nop                 ;2f58 00
    nop                 ;2f59 00
    nop                 ;2f5a 00
    nop                 ;2f5b 00
    nop                 ;2f5c 00
    nop                 ;2f5d 00
    nop                 ;2f5e 00
    nop                 ;2f5f 00
    nop                 ;2f60 00
    nop                 ;2f61 00
    nop                 ;2f62 00
    nop                 ;2f63 00
    nop                 ;2f64 00
    nop                 ;2f65 00
    nop                 ;2f66 00
    nop                 ;2f67 00
    nop                 ;2f68 00
    nop                 ;2f69 00
    nop                 ;2f6a 00
    nop                 ;2f6b 00
    nop                 ;2f6c 00
    nop                 ;2f6d 00
    nop                 ;2f6e 00
    nop                 ;2f6f 00
    nop                 ;2f70 00
    nop                 ;2f71 00
    nop                 ;2f72 00
    nop                 ;2f73 00
    nop                 ;2f74 00
    nop                 ;2f75 00
    nop                 ;2f76 00
    nop                 ;2f77 00
    nop                 ;2f78 00
    nop                 ;2f79 00
    nop                 ;2f7a 00
    nop                 ;2f7b 00
    nop                 ;2f7c 00
    nop                 ;2f7d 00
    nop                 ;2f7e 00
    nop                 ;2f7f 00
    nop                 ;2f80 00
    nop                 ;2f81 00
    nop                 ;2f82 00
    nop                 ;2f83 00
    nop                 ;2f84 00
    nop                 ;2f85 00
    nop                 ;2f86 00
    nop                 ;2f87 00
    nop                 ;2f88 00
    nop                 ;2f89 00
    nop                 ;2f8a 00
    nop                 ;2f8b 00
    nop                 ;2f8c 00
    nop                 ;2f8d 00
    nop                 ;2f8e 00
    nop                 ;2f8f 00
    nop                 ;2f90 00
    nop                 ;2f91 00
    nop                 ;2f92 00
    nop                 ;2f93 00
    nop                 ;2f94 00
    nop                 ;2f95 00
    nop                 ;2f96 00
    nop                 ;2f97 00
    nop                 ;2f98 00
    nop                 ;2f99 00
    nop                 ;2f9a 00
    nop                 ;2f9b 00
    nop                 ;2f9c 00
    nop                 ;2f9d 00
    nop                 ;2f9e 00
    nop                 ;2f9f 00
    nop                 ;2fa0 00
    nop                 ;2fa1 00
    nop                 ;2fa2 00
    nop                 ;2fa3 00
    nop                 ;2fa4 00
    nop                 ;2fa5 00
    nop                 ;2fa6 00
    nop                 ;2fa7 00
    nop                 ;2fa8 00
    nop                 ;2fa9 00
    nop                 ;2faa 00
    nop                 ;2fab 00
    nop                 ;2fac 00
    nop                 ;2fad 00
    nop                 ;2fae 00
    nop                 ;2faf 00
    nop                 ;2fb0 00
    nop                 ;2fb1 00
    nop                 ;2fb2 00
    nop                 ;2fb3 00
    nop                 ;2fb4 00
    nop                 ;2fb5 00
    nop                 ;2fb6 00
    nop                 ;2fb7 00
    nop                 ;2fb8 00
    nop                 ;2fb9 00
    nop                 ;2fba 00
    nop                 ;2fbb 00
    nop                 ;2fbc 00
    nop                 ;2fbd 00
    nop                 ;2fbe 00
    nop                 ;2fbf 00
    nop                 ;2fc0 00
    nop                 ;2fc1 00
    nop                 ;2fc2 00
    nop                 ;2fc3 00
    nop                 ;2fc4 00
    nop                 ;2fc5 00
    nop                 ;2fc6 00
    nop                 ;2fc7 00
    nop                 ;2fc8 00
    nop                 ;2fc9 00
    nop                 ;2fca 00
    nop                 ;2fcb 00
    nop                 ;2fcc 00
    nop                 ;2fcd 00
    nop                 ;2fce 00
    nop                 ;2fcf 00
    nop                 ;2fd0 00
    nop                 ;2fd1 00
    nop                 ;2fd2 00
    nop                 ;2fd3 00
    nop                 ;2fd4 00
    nop                 ;2fd5 00
    nop                 ;2fd6 00
    nop                 ;2fd7 00
    nop                 ;2fd8 00
    nop                 ;2fd9 00
    nop                 ;2fda 00
    nop                 ;2fdb 00
    nop                 ;2fdc 00
    nop                 ;2fdd 00
    nop                 ;2fde 00
    nop                 ;2fdf 00
    nop                 ;2fe0 00
    nop                 ;2fe1 00
    nop                 ;2fe2 00
    nop                 ;2fe3 00
    nop                 ;2fe4 00
    nop                 ;2fe5 00
    nop                 ;2fe6 00
    nop                 ;2fe7 00
    nop                 ;2fe8 00
    nop                 ;2fe9 00
    nop                 ;2fea 00
    nop                 ;2feb 00
    nop                 ;2fec 00
    nop                 ;2fed 00
    nop                 ;2fee 00
    nop                 ;2fef 00
    nop                 ;2ff0 00
    nop                 ;2ff1 00
    nop                 ;2ff2 00
    nop                 ;2ff3 00
    nop                 ;2ff4 00
    nop                 ;2ff5 00
    nop                 ;2ff6 00
    nop                 ;2ff7 00
    nop                 ;2ff8 00
    nop                 ;2ff9 00
    nop                 ;2ffa 00
    nop                 ;2ffb 00
    nop                 ;2ffc 00
    nop                 ;2ffd 00
    nop                 ;2ffe 00
    nop                 ;2fff 00
l3000h:
    nop                 ;3000 00
heads:
    nop                 ;3001 00
l3002h:
    nop                 ;3002 00
l3003h:
    nop                 ;3003 00
l3004h:
    nop                 ;3004 00
    nop                 ;3005 00
cylinders:
    nop                 ;3006 00
    nop                 ;3007 00
l3008h:
    nop                 ;3008 00
    nop                 ;3009 00
l300ah:
    nop                 ;300a 00
    nop                 ;300b 00
l300ch:
    nop                 ;300c 00
    nop                 ;300d 00
l300eh:
    nop                 ;300e 00
    nop                 ;300f 00
l3010h:
    nop                 ;3010 00
    nop                 ;3011 00
l3012h:
    nop                 ;3012 00
    nop                 ;3013 00
l3014h:
    nop                 ;3014 00
    nop                 ;3015 00
l3016h:
    nop                 ;3016 00
    nop                 ;3017 00
l3018h:
    nop                 ;3018 00
    nop                 ;3019 00
l301ah:
    nop                 ;301a 00
    nop                 ;301b 00
l301ch:
    nop                 ;301c 00
    nop                 ;301d 00
l301eh:
    nop                 ;301e 00
l301fh:
    nop                 ;301f 00
l3020h:
    nop                 ;3020 00
    nop                 ;3021 00
    nop                 ;3022 00
    nop                 ;3023 00
    nop                 ;3024 00
    nop                 ;3025 00
    nop                 ;3026 00
    nop                 ;3027 00
    nop                 ;3028 00
    nop                 ;3029 00
    nop                 ;302a 00
    nop                 ;302b 00
    nop                 ;302c 00
    nop                 ;302d 00
    nop                 ;302e 00
    nop                 ;302f 00
    nop                 ;3030 00
    nop                 ;3031 00
    nop                 ;3032 00
    nop                 ;3033 00
    nop                 ;3034 00
    nop                 ;3035 00
    nop                 ;3036 00
    nop                 ;3037 00
    nop                 ;3038 00
    nop                 ;3039 00
    nop                 ;303a 00
    nop                 ;303b 00
    nop                 ;303c 00
    nop                 ;303d 00
    nop                 ;303e 00
    nop                 ;303f 00
    nop                 ;3040 00
    nop                 ;3041 00
    nop                 ;3042 00
    nop                 ;3043 00
    nop                 ;3044 00
    nop                 ;3045 00
    nop                 ;3046 00
    nop                 ;3047 00
    nop                 ;3048 00
    nop                 ;3049 00
    nop                 ;304a 00
    nop                 ;304b 00
    nop                 ;304c 00
    nop                 ;304d 00
    nop                 ;304e 00
    nop                 ;304f 00
    nop                 ;3050 00
    nop                 ;3051 00
    nop                 ;3052 00
    nop                 ;3053 00
    nop                 ;3054 00
    nop                 ;3055 00
    nop                 ;3056 00
    nop                 ;3057 00
    nop                 ;3058 00
    nop                 ;3059 00
    nop                 ;305a 00
    nop                 ;305b 00
    nop                 ;305c 00
    nop                 ;305d 00
    nop                 ;305e 00
    nop                 ;305f 00
    nop                 ;3060 00
    nop                 ;3061 00
    nop                 ;3062 00
    nop                 ;3063 00
    nop                 ;3064 00
    nop                 ;3065 00
    nop                 ;3066 00
    nop                 ;3067 00
    nop                 ;3068 00
    nop                 ;3069 00
    nop                 ;306a 00
    nop                 ;306b 00
    nop                 ;306c 00
    nop                 ;306d 00
    nop                 ;306e 00
    nop                 ;306f 00
    nop                 ;3070 00
    nop                 ;3071 00
    nop                 ;3072 00
    nop                 ;3073 00
    nop                 ;3074 00
    nop                 ;3075 00
    nop                 ;3076 00
    nop                 ;3077 00
    nop                 ;3078 00
    nop                 ;3079 00
    nop                 ;307a 00
    nop                 ;307b 00
    nop                 ;307c 00
    nop                 ;307d 00
    nop                 ;307e 00
    nop                 ;307f 00
    nop                 ;3080 00
    nop                 ;3081 00
    nop                 ;3082 00
    nop                 ;3083 00
    nop                 ;3084 00
    nop                 ;3085 00
    nop                 ;3086 00
    nop                 ;3087 00
    nop                 ;3088 00
    nop                 ;3089 00
    nop                 ;308a 00
    nop                 ;308b 00
    nop                 ;308c 00
    nop                 ;308d 00
    nop                 ;308e 00
    nop                 ;308f 00
    nop                 ;3090 00
    nop                 ;3091 00
    nop                 ;3092 00
    nop                 ;3093 00
    nop                 ;3094 00
    nop                 ;3095 00
    nop                 ;3096 00
    nop                 ;3097 00
    nop                 ;3098 00
    nop                 ;3099 00
    nop                 ;309a 00
    nop                 ;309b 00
    nop                 ;309c 00
    nop                 ;309d 00
    nop                 ;309e 00
    nop                 ;309f 00
    nop                 ;30a0 00
l30a1h:
    nop                 ;30a1 00
l30a2h:
    nop                 ;30a2 00
l30a3h:
    nop                 ;30a3 00
    nop                 ;30a4 00
l30a5h:
    nop                 ;30a5 00
l30a6h:
    nop                 ;30a6 00
    nop                 ;30a7 00
l30a8h:
    nop                 ;30a8 00
    nop                 ;30a9 00
l30aah:
    nop                 ;30aa 00
    nop                 ;30ab 00
l30ach:
    nop                 ;30ac 00
l30adh:
    nop                 ;30ad 00
l30aeh:
    nop                 ;30ae 00
l30afh:
    nop                 ;30af 00
    nop                 ;30b0 00
    nop                 ;30b1 00
    nop                 ;30b2 00
    nop                 ;30b3 00
    nop                 ;30b4 00
    nop                 ;30b5 00
    nop                 ;30b6 00
    nop                 ;30b7 00
    nop                 ;30b8 00
    nop                 ;30b9 00
    nop                 ;30ba 00
    nop                 ;30bb 00
    nop                 ;30bc 00
    nop                 ;30bd 00
    nop                 ;30be 00
    nop                 ;30bf 00
    nop                 ;30c0 00
    nop                 ;30c1 00
    nop                 ;30c2 00
    nop                 ;30c3 00
    nop                 ;30c4 00
    nop                 ;30c5 00
    nop                 ;30c6 00
    nop                 ;30c7 00
    nop                 ;30c8 00
    nop                 ;30c9 00
    nop                 ;30ca 00
    nop                 ;30cb 00
    nop                 ;30cc 00
    nop                 ;30cd 00
    nop                 ;30ce 00
    nop                 ;30cf 00
    nop                 ;30d0 00
    nop                 ;30d1 00
    nop                 ;30d2 00
    nop                 ;30d3 00
    nop                 ;30d4 00
    nop                 ;30d5 00
    nop                 ;30d6 00
    nop                 ;30d7 00
    nop                 ;30d8 00
    nop                 ;30d9 00
    nop                 ;30da 00
    nop                 ;30db 00
    nop                 ;30dc 00
    nop                 ;30dd 00
    nop                 ;30de 00
    nop                 ;30df 00
    nop                 ;30e0 00
    nop                 ;30e1 00
    nop                 ;30e2 00
    nop                 ;30e3 00
    nop                 ;30e4 00
    nop                 ;30e5 00
    nop                 ;30e6 00
    nop                 ;30e7 00
    nop                 ;30e8 00
    nop                 ;30e9 00
    nop                 ;30ea 00
    nop                 ;30eb 00
    nop                 ;30ec 00
    nop                 ;30ed 00
    nop                 ;30ee 00
    nop                 ;30ef 00
    nop                 ;30f0 00
    nop                 ;30f1 00
    nop                 ;30f2 00
    nop                 ;30f3 00
    nop                 ;30f4 00
    nop                 ;30f5 00
    nop                 ;30f6 00
    nop                 ;30f7 00
    nop                 ;30f8 00
    nop                 ;30f9 00
    nop                 ;30fa 00
    nop                 ;30fb 00
    nop                 ;30fc 00
    nop                 ;30fd 00
    nop                 ;30fe 00
    nop                 ;30ff 00
