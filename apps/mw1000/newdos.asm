;NEWDOS.COM
;  Configure HardBox settings on the MW-1000.
;
;This program was not written in assembly language.  It was written
;in CORAL 66 and compiled with RCC80 from Micro Focus Ltd.  This is a
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
cls:           equ 1ah    ;Clear Screen

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
    ld bc,drive_err_n
    call print_str

    ;IF l3000h <> &H40 THEN GOTO is_err_42h
    ld a,(l3000h)
    cp 40h
    jp nz,is_err_42h

    ;PRINT "40 - header write error";
    ld bc,e40_head_writ
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_42h:
    ;IF l3000h <> &H42 THEN GOTO is_err_44h
    ld a,(l3000h)
    cp 42h
    jp nz,is_err_44h

    ;PRINT "42 - header read error";
    ld bc,e42_head_read
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_44h:
    ;IF l3000h <> &H44 THEN GOTO is_err_46h
    ld a,(l3000h)
    cp 44h
    jp nz,is_err_46h

    ;PRINT "44 - data read error";
    ld bc,e44_data_read
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_46h:
    ;IF l3000h <> &H46 THEN GOTO is_err_47h
    ld a,(l3000h)
    cp 46h
    jp nz,is_err_47h

    ;PRINT "46 - write fault";
    ld bc,e46_writ_flt
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_47h:
    ;IF l3000h <> &H47 THEN GOTO is_err_49h
    ld a,(l3000h)
    cp 47h
    jp nz,is_err_49h

    ;PRINT "47 - disk not ready";
    ld bc,e47_not_ready
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_49h:
    ;IF l3000h <> &H49 THEN GOTO unknown_err
    ld a,(l3000h)
    cp 49h
    jp nz,unknown_err

    ;PRINT "49 - illegal command";
    ld bc,e49_illegal
    call print_str

    ;GOTO got_error_done
    jp got_error_done

unknown_err:
    ;PRINT "xx - unknown error code";
    ld bc,exx_unknown
    call print_str

got_error_done:
    ;PRINT
    call print_eol

    ;RETURN
    ret

readline:
    ;buff_size = 128
    ld hl,buff_size
    ld (hl),80h

    ld de,buffer        ;018b 11 1e 30
    ld c,creadstr       ;018e 0e 0a
    call bdos           ;BDOS entry point

    ;PRINT
    call print_eol

    ;N = 0
    ld hl,0000h
    ld (nn),hl

    ;IF buff_len <> 0 THEN GOTO l01abh
    ld a,(buff_len)     ;019c 3a 1f 30
    or a                ;019f b7
    jp nz,l01abh        ;01a0 c2 ab 01

    ;R = 0
    ld hl,rr
    ld (hl),00h

    ;GOTO l0218h
    jp l0218h

l01abh:
    ;R = buff_data(0)
    ;IF R < &H61 OR R > &H7A THEN GOTO l01c2h
    ld a,(buff_data)    ;01ab 3a 20 30
    ld (rr),a           ;01ae 32 02 30
    cp 'a'              ;01b1 fe 61
    jp m,l01c2h         ;01b3 fa c2 01
    cp 'z'+1            ;01b6 fe 7b
    jp p,l01c2h         ;01b8 f2 c2 01

    ;R = R - &H20
    ld hl,rr
    ld a,(hl)
    add a,0-('a'-'A')
    ld (hl),a

l01c2h:
    ;l30a1h = 0
    ld hl,l30a1h        ;01c2 21 a1 30
    ld (hl),00h         ;01c5 36 00

l01c7h:
    ;IF buff_data(l30a1h) < &H30 OR buff_data(l30a1h) > &H39 THEN GOTO l0218h
    ld a,(l30a1h)       ;01c7 3a a1 30
    ld l,a              ;01ca 6f
    rla                 ;01cb 17
    sbc a,a             ;01cc 9f
    ld bc,buff_data     ;01cd 01 20 30
    ld h,a              ;01d0 67
    add hl,bc           ;01d1 09
    ld a,(hl)           ;01d2 7e
    cp '0'              ;01d3 fe 30
    jp m,l0218h         ;01d5 fa 18 02
    ld a,(l30a1h)       ;01d8 3a a1 30
    ld l,a              ;01db 6f
    rla                 ;01dc 17
    sbc a,a             ;01dd 9f
    ld bc,buff_data     ;01de 01 20 30
    ld h,a              ;01e1 67
    add hl,bc           ;01e2 09
    ld a,(hl)           ;01e3 7e
    cp 1+'9'            ;01e4 fe 3a
    jp p,l0218h         ;01e6 f2 18 02

    ;N = buff_data(l30a1h) - &H30 + N * 10
    ld hl,(nn)          ;01e9 2a 04 30
    ld b,h              ;01ec 44
    ld c,l              ;01ed 4d
    ld de,10            ;01ee 11 0a 00
    call sub_129ah      ;01f1 cd 9a 12 (Library MUL)
    ld a,(l30a1h)       ;01f4 3a a1 30
    ld l,a              ;01f7 6f
    rla                 ;01f8 17
    sbc a,a             ;01f9 9f
    ld bc,buff_data     ;01fa 01 20 30
    ld h,a              ;01fd 67
    add hl,bc           ;01fe 09
    ld a,(hl)           ;01ff 7e
    ld l,a              ;0200 6f
    rla                 ;0201 17
    sbc a,a             ;0202 9f
    ld bc,0-'0'         ;0203 01 d0 ff
    ld h,a              ;0206 67
    add hl,bc           ;0207 09
    add hl,de           ;0208 19
    ld (nn),hl          ;0209 22 04 30

    ;l30a1h = l30a1h + 1
    ld hl,l30a1h        ;020c 21 a1 30
    inc (hl)            ;020f 34

    ;IF l30a1h < buff_len THEN GOTO l01c7h
    ld a,(hl)           ;0210 7e
    ld hl,buff_len      ;0211 21 1f 30
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
    call bdos           ;BDOS entry point
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
;Print decimal value (base 10) at BC
;
    ;TODO
    call sub_1382h      ;0257 cd 82 13
    db 00h, 02h
    dw l30a6h

    ;l30a6h = <para>
    ld hl,l30a6h+1      ;025e 21 a7 30
    ld (hl),b           ;0261 70
    dec hl              ;0262 2b
    ld (hl),c           ;0263 71

    ;IF l30a6h = 0 THEN GOTO l028ch
    ld hl,(l30a6h)      ;0264 2a a6 30
    ld a,l              ;0267 7d
    or h                ;0268 b4
    jp z,l028ch         ;0269 ca 8c 02

    ;CALL sub_0257h(l30a6h / 10)
    ld hl,(l30a6h)      ;026c 2a a6 30
    ld b,h              ;026f 44
    ld c,l              ;0270 4d
    ld de,10            ;0271 11 0a 00
    call sub_12f6h      ;0274 cd f6 12 (Library DIV)
    call sub_0257h      ;0277 cd 57 02

    ;PRINT CHR$(&H30 + l30a6h MOD 10);
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
    ;TODO
    call sub_13c5h      ;028c cd c5 13
    db 02h
    dw l30a6h

print_int:
;Print unsigned integer (16 bit) at BC
;
    ;l30a8h = <para>
    ld hl,l30a8h+1      ;0292 21 a9 30
    ld (hl),b           ;0295 70
    dec hl              ;0296 2b
    ld (hl),c           ;0297 71

    ;IF l30a8h <> 0 THEN GOTO l02a9h
    ld hl,(l30a8h)      ;0298 2a a8 30
    ld a,l              ;029b 7d
    or h                ;029c b4
    jp nz,l02a9h        ;029d c2 a9 02

    ;PRINT "0";
    ld bc,zero
    call print_str

    ;GOTO l02b1h
    jp l02b1h           ;02a6 c3 b1 02

l02a9h:
    ;CALL sub_0257h(l30a8h)
    ld hl,(l30a8h)      ;02a9 2a a8 30
    ld b,h              ;02ac 44
    ld c,l              ;02ad 4d
    call sub_0257h      ;02ae cd 57 02

l02b1h:
    ;RETURN
    ret                 ;02b1 c9

sub_02b2h:
;Print signed integer (16 bit) at BC
;
    ;l30aah = <para>
    ld hl,l30aah+1      ;02b2 21 ab 30
    ld (hl),b           ;02b5 70
    dec hl              ;02b6 2b
    ld (hl),c           ;02b7 71

    ;IF l30aah >= 0 THEN GOTO l02d5h
    ld hl,(l30aah)      ;02b8 2a aa 30
    add hl,hl           ;02bb 29
    jp nc,l02d5h        ;02bc d2 d5 02

    ;PRINT "-";
    ld bc,dash
    call print_str

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
    ;PRINT l30aah;
    ld hl,(l30aah)      ;02d5 2a aa 30
    ld b,h              ;02d8 44
    ld c,l              ;02d9 4d
    call print_int      ;02da cd 92 02

    ;RETURN
    ret                 ;02dd c9

sub_02deh:
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
    add a,0+'A'-10      ;0309 c6 37
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

    ;l30aeh = l30aeh + 1
    ld hl,l30aeh        ;0327 21 ae 30
    inc (hl)            ;032a 34

l032bh:
    ;IF l30aeh < 5 THEN GOTO l02ebh
    ld a,(l30aeh)       ;032b 3a ae 30
    cp 05h              ;032e fe 05
    jp m,l02ebh         ;0330 fa eb 02

    ;RETURN
    ret                 ;0333 c9

start:
    ld hl,(0006h)       ;0334 2a 06 00
    ld sp,hl            ;0337 f9

ask_drv_type:
    ;PRINT CHR$(26); ' Clear screen
    ld c,cls
    call print_char

    ;PRINT "HardBox configuration program"
    ld bc,config_prog
    call print_str
    call print_eol

    ;PRINT "For Mini-Winchester"
    ld bc,for_winchester
    call print_str
    call print_eol

    ;PRINT "--- ---------------"
    ld bc,dashes
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Revision 2.1"
    ld bc,rev_21
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Drive sizes supported : "
    ld bc,drive_sizes
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "A.   3  Mbyte      (191 cyl)"
    ld bc,drv_a_3mb
    call print_str
    call print_eol

    ;PRINT "B.   6  Mbyte      (191 cyl)"
    ld bc,drv_b_6mb
    call print_str
    call print_eol

    ;PRINT "C.   12 Mbyte      (191 cyl)"
    ld bc,drv_c_12mb
    call print_str
    call print_eol

    ;PRINT "D.   5  Mbyte      (320 cyl)"
    ld bc,drv_d_5mb
    call print_str
    call print_eol

    ;PRINT "E.   10 Mbyte      (320 cyl)"
    ld bc,drv_e_10mb
    call print_str
    call print_eol

    ;PRINT "F.   15 Mbyte      (320 cyl)"
    ld bc,drv_f_15mb
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Which drive type (A-F) ? ";
    ld bc,which_type
    call print_str

    ;GOSUB readline
    call readline

    ;IF R <> &H41 THEN GOTO is_drv_type_b
    ld a,(rr)
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
    ;IF R <> &H42 THEN GOTO is_drv_type_c
    ld a,(rr)
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
    ;IF R <> &H43 THEN GOTO is_drv_type_d
    ld a,(rr)
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
    ;IF R <> &H44 THEN GOTO is_drv_type_e
    ld a,(rr)
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
    ;IF R <> &H45 THEN GOTO is_drv_type_f
    ld a,(rr)
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
    ;IF R <> &H46 THEN GOTO bad_drv_type
    ld a,(rr)
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
    ld bc,config_entire
    call print_str
    call print_eol

    ;PRINT "or just the last half (E/H) ? ";
    ld bc,or_last_half
    call print_str

    ;GOSUB readline
    call readline

    ;IF R <> &H48 THEN GOTO not_half_hbox
    ld a,(rr)
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
    ;IF R <> &H45 THEN GOTO bad_hbox_conf
    ld a,(rr)
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
    ;PRINT "Please answer E or H : ";
    ld bc,pls_eh
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
    ld bc,use_direct_access
    call print_str
    call print_eol

    ;PRINT "commands B-W, B-R, U1, U2 etc. (Y/N) ? ";
    ld bc,commands_yn
    call print_str

    ;GOSUB readline
    call readline

    ;l400ch = 0 : l4010h = 0 : l400eh = 0
    ld hl,0000h         ;04d0 21 00 00
    ld (l400ch),hl      ;direct access size = 0
    ld (l4010h),hl      ;sectors per track = 0
    ld (l400eh),hl      ;tracks per drive = 0

    ;IF R <> &H4E THEN GOTO l04f0h
    ld a,(rr)
    cp 'N'
    jp nz,l04f0h

    ;REM User selected 'N' for no direct access

    ld (l400ch),hl      ;04e4 22 0c 40
    ld (l4010h),hl      ;04e7 22 10 40
    ld (l400eh),hl      ;04ea 22 0e 40

    ;GOTO l05dfh
    jp l05dfh

l04f0h:
    ;IF R <> &H59 THEN GOTO l05d6h
    ld a,(rr)
    cp 'Y'
    jp nz,l05d6h

    ;REM User selected 'Y' for use direct access

l04f8h:
    ;PRINT CHR$(26);
    ld c,cls
    call print_char

    ;PRINT "Any number of kilobytes from zero to"
    ld bc,num_kb_from_zero
    call print_str
    call print_eol

    ;PRINT l4007h-10;
    ld bc,0fff6h        ;0506 01 f6 ff
    ld hl,(l4007h)      ;0509 2a 07 40
    add hl,bc           ;050c 09
    ld b,h              ;050d 44
    ld c,l              ;050e 4d
    call print_int      ;050f cd 92 02

    ;PRINT "may be reserved for direct access"
    ld bc,res_direct_access
    call print_str
    call print_eol

    ;PRINT "rather than sequential files."
    ld bc,rather_seq_files
    call print_str
    call print_eol

    ;PRINT "Alternatively for emulation of twin 8050"
    ld bc,emu_twin_8050
    call print_str
    call print_eol

    ;PRINT "floppies you may enter an 'E'."
    ld bc,floppies_enter_e
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Amount of space to reserve for direct"
    ld bc,space_to_res
    call print_str
    call print_eol

    ;PRINT "access commands (in kilobytes) ? ";
    ld bc,access_cmd_kb
    call print_str

    ;GOSUB readline
    call readline

    ;IF R <> &H45 THEN GOTO l0568h
    ld a,(rr)
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

    ;l400ch = N
    ld hl,(nn)          ;0568 2a 04 30
    ld (l400ch),hl      ;056b 22 0c 40

    ;IF &H400C = 0 THEN GOTO l04f8h
    ld hl,(l400ch)
    ld a,l
    or h
    jp z,l04f8h

    ;PRINT "You now need to specify the number of"
    ld bc,specify_num_of
    call print_str
    call print_eol

    ;PRINT "apparent sectors per track and tracks"
    ld bc,sec_p_trk_a_trk
    call print_str
    call print_eol

    ;PRINT "per drive when using direct access : "
    ld bc,p_drv_direct_access
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "For example to emulate an 8050 unit :"
    ld bc,example_emu_8050
    call print_str
    call print_eol

    ;PRINT "   sectors per track = 29"
    ld bc,sec_p_trk_29
    call print_str
    call print_eol

    ;PRINT "   tracks per drive = 77"
    ld bc,trk_p_drv_77
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Number of sectors per track ? ";
    ld bc,num_sec_p_trk
    call print_str

    ;GOSUB readline
    call readline

    ;l4010h = N
    ld hl,(nn)          ;05bb 2a 04 30
    ld (l4010h),hl      ;05be 22 10 40

    ;PRINT
    call print_eol

    ;PRINT "Number of tracks per drive ? ";
    ld bc,num_trk_p_drv
    call print_str

    ;GOSUB readline
    call readline

    ;l400eh = N
    ld hl,(nn)          ;05cd 2a 04 30
    ld (l400eh),hl      ;05d0 22 0e 40

l05d3h:
    jp l05dfh           ;05d3 c3 df 05

l05d6h:
    ;PRINT "Please answer Y or N : ";
    ld bc,pls_yn
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
    ld c,cls
    call print_char

    ;PRINT "Logical specifications :"
    ld bc,logical_spec
    call print_str
    call print_eol

    ;PRINT "User area size :           ";
    ld bc,user_area_size
    call print_str

    ;PRINT l4007h;
    ld hl,(l4007h)      ;0692 2a 07 40
    ld b,h              ;0695 44
    ld c,l              ;0696 4d
    call print_int      ;0697 cd 92 02

    ;PRINT " Kbytes"
    ld bc,kbytes_1
    call print_str
    call print_eol

    ;PRINT "Direct access size :       ";
    ld bc,direct_access_size
    call print_str

    ;PRINT l400ch;
    ld hl,(l400ch)      ;06a9 2a 0c 40
    ld b,h              ;06ac 44
    ld c,l              ;06ad 4d
    call print_int      ;06ae cd 92 02

    ;PRINT " Kbytes"
    ld bc,kbytes_2
    call print_str
    call print_eol

    ;PRINT "Direct sectors per track : ";
    ld bc,direct_sec_p_trk
    call print_str

    ;PRINT l4010h
    ld hl,(l4010h)       ;06c0 2a 10 40
    ld b,h              ;06c3 44
    ld c,l              ;06c4 4d
    call print_int      ;06c5 cd 92 02
    call print_eol      ;06c8 cd 27 02

    ;PRINT "Direct tracks per drive :  ";
    ld bc,direct_trk_p_drv        ;06cb 01 01 10
    call print_str      ;06ce cd 32 02

    ;PRINT l400eh
    ld hl,(l400eh)      ;06d1 2a 0e 40
    ld b,h              ;06d4 44
    ld c,l              ;06d5 4d
    call print_int      ;06d6 cd 92 02
    call print_eol

    ;PRINT "Max number of files :      ";
    ld bc,max_num_files        ;06dc 01 1d 10
    call print_str      ;06df cd 32 02

    ;PRINT l400ah
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
    ld bc,physical_spec
    call print_str
    call print_eol

    ;PRINT "Sectors per track :        32"
    ld bc,sec_p_trk_32
    call print_str
    call print_eol

    ;PRINT "Tracks per cylinder :      ";
    ld bc,trk_p_drv_n
    call print_str

    ;PRINT heads
    ld a,(heads)        ;070b 3a 01 30
    ld l,a              ;070e 6f
    rla                 ;070f 17
    sbc a,a             ;0710 9f
    ld b,a              ;0711 47
    ld c,l              ;0712 4d
    call print_int      ;0713 cd 92 02
    call print_eol

    ;PRINT "Total cylinders on drive : ";
    ld bc,cyl_o_drv_n
    call print_str

    ;PRINT cylinders
    ld hl,(cylinders)   ;071f 2a 06 30
    ld b,h              ;0722 44
    ld c,l              ;0723 4d
    call print_int      ;0724 cd 92 02
    call print_eol

    ;PRINT "Total kbyte capacity :     ";
    ld bc,capacity_n_kb
    call print_str

    ;PRINT heads*cylinders*8
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

    ;PRINT "First user cylinder :      ";
    ld bc,first_usr_cyl_n
    call print_str

    ;PRINT l4034h
    ld hl,(l4034h)      ;0754 2a 34 40
    ld b,h              ;0757 44
    ld c,l              ;0758 4d
    call print_int      ;0759 cd 92 02
    call print_eol

    ;PRINT "Number of user cylinders : ";
    ld bc,num_usr_cyl_n
    call print_str

    ;PRINT cylinders-l4034h
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

    ;PRINT "User area starts at :      ";
    ld bc,usr_area_starts_n
    call print_str

    ;PRINT l301ah
    ld hl,(l301ah)      ;077f 2a 1a 30
    ld b,h              ;0782 44
    ld c,l              ;0783 4d
    call print_int      ;0784 cd 92 02
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "WARNING :  This command will destroy all"
    ld bc,warning_destroy
    call print_str
    call print_eol

    ;PRINT "data on the";
    ld bc,data_on_the
    call print_str

    ;IF l3003h <> 1 THEN GOTO l07aah
    ld a,(l3003h)
    cp 01h
    jp nz,l07aah

    ;PRINT " second half of the";
    ld bc,second_half_of_the
    call print_str

l07aah:
    ;PRINT " drive"
    ld bc,drive
    call print_str
    call print_eol

l07b3h:
    ;PRINT
    call print_eol

    ;PRINT "Continue (Y/N) ? ";
    ld bc,continue_yn
    call print_str

    ;GOSUB readline
    call readline

    ;IF R <> &H4E THEN GOTO l07cah
    ld a,(rr)
    cp 'N'
    jp nz,l07cah

    ;END
    call end

l07cah:
    ;IF R <> &H59 THEN GOTO l07b3h
    ld a,(rr)
    cp 'Y'
    jp nz,l07b3h

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Writing new configuration data ..."
    ld bc,write_conf_data
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
    ld bc,formatting_dir
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

    ;POKE l3018h+0+&H7000,&H48 (???)
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

    ;POKE l3018h+5+&H7000,&H4F (???)
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

    ;POKE l1318h+0+&H7000,&H4B
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
    ld bc,clearing_bam
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

drive_err_n:
    db drive_err_n_len
    db "DRIVE ERROR #"
drive_err_n_len: equ $-drive_err_n-1

e40_head_writ:
    db e40_head_writ_len
    db "40 - header write error"
e40_head_writ_len: equ $-e40_head_writ-1

e42_head_read:
    db e42_head_read_len
    db "42 - header read error"
e42_head_read_len: equ $-e42_head_read-1

e44_data_read:
    db e44_data_read_len
    db "44 - data read error"
e44_data_read_len: equ $-e44_data_read-1

e46_writ_flt:
    db e46_writ_flt_len
    db "46 - write fault"
e46_writ_flt_len: equ $-e46_writ_flt-1

e47_not_ready:
    db e47_not_ready_len
    db "47 - disk not ready"
e47_not_ready_len: equ $-e47_not_ready-1

e49_illegal:
    db e49_illegal_len
    db "49 - illegal command"
e49_illegal_len: equ $-e49_illegal-1

exx_unknown:
    db exx_unknown_len
    db "xx - unknown error code"
exx_unknown_len: equ $-exx_unknown-1

zero:
    db zero_len
    db "0"
zero_len: equ $-zero-1

dash:
    db dash_len
    db "-"
dash_len: equ $-dash-1

config_prog:
    db config_prog_len
    db "HardBox configuration program"
config_prog_len: equ $-config_prog-1

for_winchester:
    db for_winchester_len
    db "For Mini-Winchester"
for_winchester_len: equ $-for_winchester-1

dashes:
    db dashes_len
    db "--- ---------------"
dashes_len: equ $-dashes-1

rev_21:
    db rev_21_len
    db "Revision 2.1"
rev_21_len: equ $-rev_21-1

drive_sizes:
    db drive_sizes_len
    db "Drive sizes supported : "
drive_sizes_len: equ $-drive_sizes-1

drv_a_3mb:
    db drv_a_3mb_len
    db "A.   3  Mbyte      (191 cyl)"
drv_a_3mb_len: equ $-drv_a_3mb-1

drv_b_6mb:
    db drv_b_6mb_len
    db "B.   6  Mbyte      (191 cyl)"
drv_b_6mb_len: equ $-drv_b_6mb-1

drv_c_12mb:
    db drv_c_12mb_len
    db "C.   12 Mbyte      (191 cyl)"
drv_c_12mb_len: equ $-drv_c_12mb-1

drv_d_5mb:
    db drv_d_5mb_len
    db "D.   5  Mbyte      (320 cyl)"
drv_d_5mb_len: equ $-drv_d_5mb-1

drv_e_10mb:
    db drv_e_10mb_len
    db "E.   10 Mbyte      (320 cyl)"
drv_e_10mb_len: equ $-drv_e_10mb-1

drv_f_15mb:
    db drv_f_15mb_len
    db "F.   15 Mbyte      (320 cyl)"
drv_f_15mb_len: equ $-drv_f_15mb-1

which_type:
    db which_type_len
    db "Which drive type (A-F) ? "
which_type_len: equ $-which_type-1

config_entire:
    db config_entire_len
    db "Configure entire drive as HardBox"
config_entire_len: equ $-config_entire-1

or_last_half:
    db or_last_half_len
    db "or just the last half (E/H) ? "
or_last_half_len: equ $-or_last_half-1

pls_eh:
    db pls_eh_len
    db "Please answer E or H : "
pls_eh_len: equ $-pls_eh-1

use_direct_access:
    db use_direct_access_len
    db "Do you wish to use the direct access"
use_direct_access_len: equ $-use_direct_access-1

commands_yn:
    db commands_yn_len
    db "commands B-W, B-R, U1, U2 etc. (Y/N) ? "
commands_yn_len: equ $-commands_yn-1

num_kb_from_zero:
    db num_kb_from_zero_len
    db "Any number of kilobytes from zero to"
num_kb_from_zero_len: equ $-num_kb_from_zero-1

res_direct_access:
    db res_direct_access_len
    db "may be reserved for direct access"
res_direct_access_len: equ $-res_direct_access-1

rather_seq_files:
    db rather_seq_files_len
    db "rather than sequential files."
rather_seq_files_len: equ $-rather_seq_files-1

emu_twin_8050:
    db emu_twin_8050_len
    db "Alternatively for emulation of twin 8050"
emu_twin_8050_len: equ $-emu_twin_8050-1

floppies_enter_e:
    db floppies_enter_e_len
    db "floppies you may enter an 'E'."
floppies_enter_e_len: equ $-floppies_enter_e-1

space_to_res:
    db space_to_res_len
    db "Amount of space to reserve for direct"
space_to_res_len: equ $-space_to_res-1

access_cmd_kb:
    db access_cmd_kb_len
    db "access commands (in kilobytes) ? "
access_cmd_kb_len: equ $-access_cmd_kb-1

specify_num_of:
    db specify_num_of_len
    db "You now need to specify the number of"
specify_num_of_len: equ $-specify_num_of-1

sec_p_trk_a_trk:
    db sec_p_trk_a_trk_len
    db "apparent sectors per track and tracks"
sec_p_trk_a_trk_len: equ $-sec_p_trk_a_trk-1

p_drv_direct_access:
    db p_drv_direct_access_len
    db "per drive when using direct access : "
p_drv_direct_access_len: equ $-p_drv_direct_access-1

example_emu_8050:
    db example_emu_8050_len
    db "For example to emulate an 8050 unit :"
example_emu_8050_len: equ $-example_emu_8050-1

sec_p_trk_29:
    db sec_p_trk_29_len
    db "   sectors per track = 29"
sec_p_trk_29_len: equ $-sec_p_trk_29-1

trk_p_drv_77:
    db trk_p_drv_77_len
    db "   tracks per drive = 77"
trk_p_drv_77_len: equ $-trk_p_drv_77-1

num_sec_p_trk:
    db num_sec_p_trk_len
    db "Number of sectors per track ? "
num_sec_p_trk_len: equ $-num_sec_p_trk-1

num_trk_p_drv:
    db num_trk_p_drv_len
    db "Number of tracks per drive ? "
num_trk_p_drv_len: equ $-num_trk_p_drv-1

pls_yn:
    db pls_yn_len
    db "Please answer Y or N : "
pls_yn_len: equ $-pls_yn-1

logical_spec:
    db logical_spec_len
    db "Logical specifications :"
logical_spec_len: equ $-logical_spec-1

user_area_size:
    db user_area_size_len
    db "User area size :           "
user_area_size_len: equ $-user_area_size-1

kbytes_1:
    db kbytes_1_len
    db " Kbytes"
kbytes_1_len: equ $-kbytes_1-1

direct_access_size:
    db direct_access_size_len
    db "Direct access size :       "
direct_access_size_len: equ $-direct_access_size-1

kbytes_2:
    db kbytes_2_len
    db " Kbytes"
kbytes_2_len: equ $-kbytes_2-1

direct_sec_p_trk:
    db direct_sec_p_trk_len
    db "Direct sectors per track : "
direct_sec_p_trk_len: equ $-direct_sec_p_trk-1

direct_trk_p_drv:
    db direct_trk_p_drv_len
    db "Direct tracks per drive :  "
direct_trk_p_drv_len: equ $-direct_trk_p_drv-1

max_num_files:
    db max_num_files_len
    db "Max number of files :      "
max_num_files_len: equ $-max_num_files-1

physical_spec:
    db physical_spec_len
    db "Physical specifications :"
physical_spec_len: equ $-physical_spec-1

sec_p_trk_32:
    db sec_p_trk_32_len
    db "Sectors per track :        32"
sec_p_trk_32_len: equ $-sec_p_trk_32-1

trk_p_drv_n:
    db trk_p_drv_n_len
    db "Tracks per cylinder :      "
trk_p_drv_n_len: equ $-trk_p_drv_n-1

cyl_o_drv_n:
    db cyl_o_drv_n_len
    db "Total cylinders on drive : "
cyl_o_drv_n_len: equ $-cyl_o_drv_n-1

capacity_n_kb:
    db capacity_n_kb_len
    db "Total kbyte capacity :     "
capacity_n_kb_len: equ $-capacity_n_kb-1

first_usr_cyl_n:
    db first_usr_cyl_n_len
    db "First user cylinder :      "
first_usr_cyl_n_len: equ $-first_usr_cyl_n-1

num_usr_cyl_n:
    db num_usr_cyl_n_len
    db "Number of user cylinders : "
num_usr_cyl_n_len: equ $-num_usr_cyl_n-1

usr_area_starts_n:
    db usr_area_starts_n_len
    db "User area starts at :      "
usr_area_starts_n_len: equ $-usr_area_starts_n-1

warning_destroy:
    db warning_destroy_len
    db "WARNING :  This command will destroy all"
warning_destroy_len: equ $-warning_destroy-1

data_on_the:
    db data_on_the_len
    db "data on the"
data_on_the_len: equ $-data_on_the-1

second_half_of_the:
    db second_half_of_the_len
    db " second half of the"
second_half_of_the_len: equ $-second_half_of_the-1

drive:
    db drive_len
    db " drive"
drive_len: equ $-drive-1

continue_yn:
    db continue_yn_len
    db "Continue (Y/N) ? "
continue_yn_len: equ $-continue_yn-1

write_conf_data:
    db write_conf_data_len
    db "Writing new configuration data ..."
write_conf_data_len: equ $-write_conf_data-1

formatting_dir:
    db formatting_dir_len
    db "Formatting directory ..."
formatting_dir_len: equ $-formatting_dir-1

clearing_bam:
    db clearing_bam_len
    db "clearing direct access BAM ..."
clearing_bam_len: equ $-clearing_bam-1

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
rr:
    db 0                ;First char of user input from any prompt
l3003h:
    db 0
nn:
    dw 0                ;Integer parsed from user input
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

buffer:                 ;User input buffer struct
buff_size:
    db 0                ;  Buffer size (contain 128) as byte
buff_len:
    db 0                ;  Used buffer length as byte
buff_data:              ;  128 bytes input buffer
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0

l30a1h:
    db 0                ;TODO Used by readline
l30a2h:
    db 0                ;TODO Used by print_char
l30a3h:
    dw 0                ;TODO Used by print_str
l30a5h:
    db 0                ;TODO Used by print_str
l30a6h:
    dw 0                ;TODO Used by sub_0257h
l30a8h:
    dw 0                ;TODO Used by print_int
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
