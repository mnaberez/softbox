;NEWSYS.COM
;  Configure SoftBox settings on the MW-1000.
;
;This program was not written in assembly language.  It was written
;in a high level language but the compiler is unknown.  This is a
;disassembly of the compiled program.
;

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point
ccp_base:      equ 0d400h ;Start of CCP area
errbuf:        equ 0eac0h ;Last error message returned from CBM DOS
seldsk:        equ 0f01bh ;Select disk drive
settrk:        equ 0f01eh ;Set track number
setsec:        equ 0f021h ;Set sector number
read:          equ 0f027h ;Read selected sector
write:         equ 0f02ah ;Write selected sector
listen:        equ 0f033h ;Send LISTEN to an IEEE-488 device
unlisten:      equ 0f036h ;Send UNLISTEN to all IEEE-488 devices
talk:          equ 0f039h ;Send TALK to an IEEE-488 device
untalk:        equ 0f03ch ;Send UNTALK to all IEEE-488 devices
rdieee:        equ 0f03fh ;Read byte from an IEEE-488 device
wrieee:        equ 0f042h ;Send byte to an IEEE-488 device
wreoi:         equ 0f045h ;Send byte to IEEE-488 device with EOI asserted
creoi:         equ 0f048h ;Send carriage return to IEEE-488 dev with EOI
ieeemsg:       equ 0f04bh ;Send string to the current IEEE-488 device
ieeenum:       equ 0f04eh ;Send number as decimal string to IEEE-488 dev
tstdrv:        equ 0f051h ;Get drive type for a CP/M drive number
dskdev:        equ 0f054h ;Get device address for a CP/M drive number
diskcmd:       equ 0f057h ;Open the command channel on IEEE-488 device
dsksta:        equ 0f05ah ;Read the error channel of an IEEE-488 device
open:          equ 0f05dh ;Open a file on an IEEE-488 device
close:         equ 0f060h ;Close an open file on an IEEE-488 device
runcpm:        equ 0f075h ;Perform system init and then run CP/M
idrive:        equ 0f078h ;Initialize an IEEE-488 disk drive

cread:         equ 01h    ;Console Input
cwrite:        equ 02h    ;Console Output
cwritestr:     equ 09h    ;Output String
creadstr:      equ 0ah    ;Buffered Console Input

bell:          equ 07h    ;Bell
lf:            equ 0ah    ;Line Feed
cr:            equ 0dh    ;Carriage Return

    org 0100h

    jp start

sub_0103h:
    ld hl,l3006h        ;0103 21 06 30
    ld (hl),c           ;0106 71
    ld a,(l3006h)       ;0107 3a 06 30
    call tstdrv         ;Get drive type for a CP/M drive number
    ld a,c              ;010d 79
    ret                 ;010e c9

    ld a,00h            ;010f 3e 00
    ret                 ;0111 c9
    ret                 ;0112 c9

sub_0113h:
    ld hl,l3007h        ;0113 21 07 30
    ld (hl),c           ;0116 71
    ld a,(l3007h)       ;0117 3a 07 30
    call idrive         ;Initialize an IEEE-488 disk drive
    ret                 ;011d c9

sub_011eh:
    ld a,(l2423h)       ;011e 3a 23 24
    or a                ;0121 b7
    jp z,l0162h         ;0122 ca 62 01

    ;PRINT "Disk error :  ";
    ld bc,l0c84h
    call print_str

    ld hl,l3008h        ;012b 21 08 30
    ld (hl),00h         ;012e 36 00
    jp l0157h           ;0130 c3 57 01

l0133h:
    ld a,(l3008h)       ;0133 3a 08 30
    ld l,a              ;0136 6f
    rla                 ;0137 17
    sbc a,a             ;0138 9f
    ld bc,errbuf        ;0139 01 c0 ea
    ld h,a              ;013c 67
    add hl,bc           ;013d 09
    ld c,(hl)           ;013e 4e
    call print_char     ;013f cd 6b 01
    ld a,(l3008h)       ;0142 3a 08 30
    ld l,a              ;0145 6f
    rla                 ;0146 17
    sbc a,a             ;0147 9f
    ld bc,errbuf        ;0148 01 c0 ea
    ld h,a              ;014b 67
    add hl,bc           ;014c 09
    ld a,(hl)           ;014d 7e
    cp cr               ;014e fe 0d
    jp z,l015fh         ;0150 ca 5f 01
    ld hl,l3008h        ;0153 21 08 30
    inc (hl)            ;0156 34
l0157h:
    ld a,(l3008h)       ;0157 3a 08 30
    cp 40h              ;015a fe 40
    jp m,l0133h         ;015c fa 33 01
l015fh:
    call print_eol      ;015f cd 79 01
l0162h:
    ld a,(l2423h)       ;0162 3a 23 24
    ret                 ;0165 c9
    ret                 ;0166 c9

end:
;Jump to CP/M warm start
;Implements END command
    jp warm             ;Warm start entry point
    ret

print_char:
;Print character in C
    ld hl,l3009h
    ld (hl),c
    ld c,cwrite
    ld a,(l3009h)
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
    ld hl,l300ah+1
    ld (hl),b
    dec hl
    ld (hl),c
    ld hl,(l300ah)
    ld a,(hl)
    ld (l300ch),a
l0191h:
    ld hl,(l300ah)
    inc hl
    ld (l300ah),hl
    ld hl,(l300ah)
    ld c,(hl)
    call print_char
    ld hl,l300ch
    dec (hl)
    ld a,(hl)
    or a
    jp nz,l0191h
    ret

print_str_eol:
;Print string at BC followed by CR+LF
    ld hl,l300dh+1
    ld (hl),b
    dec hl
    ld (hl),c
    ld hl,(l300dh)
    ld b,h
    ld c,l
    call print_str
    call print_eol
    ret

sub_01bbh:
    call sub_25b5h      ;01bb cd b5 25
    db 00h, 02h
    dw l300fh
    ld hl,l300fh+1      ;01c2 21 10 30
    ld (hl),b           ;01c5 70
    dec hl              ;01c6 2b
    ld (hl),c           ;01c7 71
    ld hl,(l300fh)      ;01c8 2a 0f 30
    ld a,l              ;01cb 7d
    or h                ;01cc b4
    jp z,l01f0h         ;01cd ca f0 01
    ld hl,(l300fh)      ;01d0 2a 0f 30
    ld b,h              ;01d3 44
    ld c,l              ;01d4 4d
    ld de,10            ;01d5 11 0a 00
    call sub_2529h      ;01d8 cd 29 25 (Library DIV)
    call sub_01bbh      ;01db cd bb 01
    ld hl,(l300fh)      ;01de 2a 0f 30
    ld b,h              ;01e1 44
    ld c,l              ;01e2 4d
    ld de,10            ;01e3 11 0a 00
    call sub_2529h      ;01e6 cd 29 25 (Library DIV)
    ld a,l              ;01e9 7d
    add a,'0'           ;01ea c6 30
    ld c,a              ;01ec 4f
    call print_char     ;01ed cd 6b 01
l01f0h:
    call sub_25f8h      ;01f0 cd f8 25
    db 02h
    dw l300fh

print_int:
    ld hl,l3011h+1      ;01f6 21 12 30
    ld (hl),b           ;01f9 70
    dec hl              ;01fa 2b
    ld (hl),c           ;01fb 71
    ld hl,(l3011h)      ;01fc 2a 11 30
    ld a,l              ;01ff 7d
    or h                ;0200 b4
    jp nz,l020dh        ;0201 c2 0d 02

    ;PRINT "0";
    ld bc,l0c93h
    call print_str

    jp l0215h           ;020a c3 15 02

l020dh:
    ld hl,(l3011h)      ;020d 2a 11 30
    ld b,h              ;0210 44
    ld c,l              ;0211 4d
    call sub_01bbh      ;0212 cd bb 01
l0215h:
    ret                 ;0215 c9

readline:
    ld hl,l2424h        ;0216 21 24 24
    ld (hl),50h         ;0219 36 50
    ld de,l2424h        ;021b 11 24 24
    ld c,creadstr       ;021e 0e 0a
    call bdos           ;BDOS entry point
    ld hl,0000h         ;0223 21 00 00
    ld (nn),hl          ;0226 22 c8 24
    ld (l24cah),hl      ;0229 22 ca 24
    ld a,(l2425h)       ;022c 3a 25 24
    or a                ;022f b7
    jp nz,l023bh        ;0230 c2 3b 02
    ld hl,rr            ;0233 21 cc 24
    ld (hl),cr          ;0236 36 0d
    jp l02ffh           ;0238 c3 ff 02

l023bh:
    ld hl,l3013h        ;023b 21 13 30
    ld (hl),01h         ;023e 36 01
    ld a,(l2425h)       ;0240 3a 25 24
    inc hl              ;0243 23
    inc hl              ;0244 23
    ld (hl),a           ;0245 77
    jp l02efh           ;0246 c3 ef 02

l0249h:
    ld a,(l3013h)       ;0249 3a 13 30
    ld l,a              ;024c 6f
    rla                 ;024d 17
    sbc a,a             ;024e 9f
    ld bc,l2425h        ;024f 01 25 24
    ld h,a              ;0252 67
    add hl,bc           ;0253 09
    ld a,(hl)           ;0254 7e
    ld (l3014h),a       ;0255 32 14 30
    ld a,(l3013h)       ;0258 3a 13 30
    ld l,a              ;025b 6f
    rla                 ;025c 17
    sbc a,a             ;025d 9f
    ld bc,l2476h        ;025e 01 76 24
    ld h,a              ;0261 67
    add hl,bc           ;0262 09
    ld a,(l3014h)       ;0263 3a 14 30
    ld (hl),a           ;0266 77
    cp 'a'              ;0267 fe 61
    jp m,l0278h         ;0269 fa 78 02
    cp 'z'+1            ;026c fe 7b
    jp p,l0278h         ;026e f2 78 02
    ld hl,l3014h        ;0271 21 14 30
    ld a,(hl)           ;0274 7e
    add a,0e0h          ;0275 c6 e0
    ld (hl),a           ;0277 77
l0278h:
    ld a,(l3013h)       ;0278 3a 13 30
    ld l,a              ;027b 6f
    rla                 ;027c 17
    sbc a,a             ;027d 9f
    ld bc,l2425h        ;027e 01 25 24
    ld h,a              ;0281 67
    add hl,bc           ;0282 09
    ld a,(l3014h)       ;0283 3a 14 30
    ld (hl),a           ;0286 77
    ld hl,l3014h        ;0287 21 14 30
    ld a,(hl)           ;028a 7e
    add a,0d0h          ;028b c6 d0
    ld (hl),a           ;028d 77
    or a                ;028e b7
    jp m,l02c5h         ;028f fa c5 02
    cp 0ah              ;0292 fe 0a
    jp p,l02c5h         ;0294 f2 c5 02
    ld hl,(nn)          ;0297 2a c8 24
    ld b,h              ;029a 44
    ld c,l              ;029b 4d
    ld de,000ah         ;029c 11 0a 00
    call sub_24cdh      ;029f cd cd 24 (Library MUL)
    ld a,(l3014h)       ;02a2 3a 14 30
    ld l,a              ;02a5 6f
    rla                 ;02a6 17
    sbc a,a             ;02a7 9f
    ld h,a              ;02a8 67
    add hl,de           ;02a9 19
    ld (nn),hl          ;02aa 22 c8 24
    ld c,04h            ;02ad 0e 04
    ld hl,(l24cah)      ;02af 2a ca 24
    jp l02b6h           ;02b2 c3 b6 02

l02b5h:
    add hl,hl           ;02b5 29
l02b6h:
    dec c               ;02b6 0d
    jp p,l02b5h         ;02b7 f2 b5 02
    ld a,(l3014h)       ;02ba 3a 14 30
    ld c,a              ;02bd 4f
    rla                 ;02be 17
    sbc a,a             ;02bf 9f
    ld b,a              ;02c0 47
    add hl,bc           ;02c1 09
    ld (l24cah),hl      ;02c2 22 ca 24
l02c5h:
    ld hl,l3014h        ;02c5 21 14 30
    ld a,(hl)           ;02c8 7e
    add a,0f9h          ;02c9 c6 f9
    ld (hl),a           ;02cb 77
    cp 0ah              ;02cc fe 0a
    jp m,l02ebh         ;02ce fa eb 02
    cp 10h              ;02d1 fe 10
    jp p,l02ebh         ;02d3 f2 eb 02
    ld c,04h            ;02d6 0e 04
    ld hl,(l24cah)      ;02d8 2a ca 24
    jp l02dfh           ;02db c3 df 02

l02deh:
    add hl,hl           ;02de 29
l02dfh:
    dec c               ;02df 0d
    jp p,l02deh         ;02e0 f2 de 02
    ld c,a              ;02e3 4f
    rla                 ;02e4 17
    sbc a,a             ;02e5 9f
    ld b,a              ;02e6 47
    add hl,bc           ;02e7 09
    ld (l24cah),hl      ;02e8 22 ca 24
l02ebh:
    ld hl,l3013h        ;02eb 21 13 30
    inc (hl)            ;02ee 34
l02efh:
    ld a,(l3015h)       ;02ef 3a 15 30
    ld hl,l3013h        ;02f2 21 13 30
    cp (hl)             ;02f5 be
    jp p,l0249h         ;02f6 f2 49 02
    ld a,(l2426h)       ;02f9 3a 26 24
    ld (rr),a           ;02fc 32 cc 24
l02ffh:
    ret                 ;02ff c9

clear_screen:
    ;PRINT CHR$(26) ' Clear screen
    ld c,1ah
    call print_char

    ;RETURN
    ret

sub_0306h:
    jp l05edh           ;0306 c3 ed 05

ask_drv_dev:
    ;REM Ask the device number for a floppy or hard drive

    ;PRINT "Device number for drive ? ";
    ld bc,l0c95h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;POKE &H5678+D, N ' Store device number
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5678h
    ld h,a
    add hl,bc
    ld a,(nn)
    ld (hl),a

    ;IF PEEK(&H5670+D) <> 4 THEN GOTO drv_dev_done
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld a,(hl)
    cp 04h              ;Drive type = 4 (Corvus 5 MB)?
    jp nz,drv_dev_done  ;  No: jump to drv_dev_done

    ;REM Drive type is Corvus 5 MB
    ;REM This hard drive is special because it is the only one
    ;REM that can be configured as either 1 or 2 CP/M drives.

    ;PRINT "Configure as 1 or 2 CP/M drives ? ";
    ld bc,l0cb0h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF N <> 2 THEN GOTO drv_dev_done ' Leave as drive type 4
    ld hl,(nn)
    dec hl
    dec hl
    ld a,h
    or l
    jp nz,drv_dev_done

    ;REM User selected 2 CP/M drives

    ;POKE &H5670+D, 5 ' Change drive type from 4 to 5
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld (hl),05h         ;Drive type 5 = Corvus 5 MB as 2 CP/M drives

drv_dev_done:
    ;RETURN
    ret

ask_drv_type:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "Winchester sizes supported : "
    ld bc,l0cd3h
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "A.   3  Mbyte      (191 cyl)"
    ld bc,l0cf1h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "B.   6  Mbyte      (191 cyl)"
    ld bc,l0d0eh
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "C.   12 Mbyte      (191 cyl)"
    ld bc,l0d2bh
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "D.   5  Mbyte      (320 cyl)"
    ld bc,l0d48h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "E.   10 Mbyte      (320 cyl)"
    ld bc,l0d65h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "F.   15 Mbyte      (320 cyl)"
    ld bc,l0d82h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Z.   User supplied Head & Cyl count"
    ld bc,l0d9fh
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Which drive type (A-F or Z) ? ";
    ld bc,l0dc3h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

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

    ;GOTO l0483h
    jp l0483h

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

    ;GOTO l0483h
    jp l0483h

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

    ;GOTO l0483h
    jp l0483h

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

    ;GOTO l0483h
    jp l0483h

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

    ;GOTO l0483h
    jp l0483h

is_drv_type_f:
    ;IF R <> &H46H THEN GOTO is_drv_type_z
    ld a,(rr)
    cp 'F'              ;Is it 'F': 15 Mbyte (320 cyl)?
    jp nz,is_drv_type_z ;  No: jump to check for 'Z'

    ;REM User selected 'F' for 15 Mbyte (320 cyl)

    ;heads = 6
    ld hl,heads
    ld (hl),6

    ;cylinders = 320
    ld hl,320
    ld (cylinders),hl

    ;GOTO l0483h
    jp l0483h

is_drv_type_z:
    ;IF R <> &H5A THEN GOTO bad_drv_type
    ld a,(rr)
    cp 'Z'              ;Is it 'Z': User supplied Head & Cyl count?
    jp nz,bad_drv_type  ;  No: bad drive type entered

ask_drv_heads:
    ;PRINT "Enter the number of Heads : ";
    ld bc,l0de2h
    call print_str

    ;REM User selected 'Z' for arbitrary heads/cylinders

    ;GOSUB readline
    call readline

    ;heads = N
    ld a,(nn)
    ld (heads),a

    ;IF heads = 2 THEN GOTO ask_drv_cyl
    cp 2
    jp z,ask_drv_cyl

    ;IF heads = 4 THEN GOTO ask_drv_cyl
    cp 4
    jp z,ask_drv_cyl

    ;IF heads = 6 THEN GOTO ask_drv_cyl
    cp 6
    jp z,ask_drv_cyl

    ;IF heads = 8 THEN GOTO ask_drv_cyl
    cp 8
    jp z,ask_drv_cyl

    ;PRINT "Must be 2, 4, 6 or 8"
    ld bc,l0dffh
    call print_str_eol

    ;GOTO ask_drv_heads
    jp ask_drv_heads

ask_drv_cyl:
    ;PRINT "Enter the number of Cylinders : ";
    ld bc,l0e14h
    call print_str

    ;GOSUB readline
    call readline

    ;cylinders = N
    ld hl,(nn)
    ld (cylinders),hl

    ;GOTO l0483h
    jp l0483h

bad_drv_type:
    ;GOTO ask_drv_type
    jp ask_drv_type

l0483h:
    ;TODO this disassembly may be wrong.  5670h is the drive type.
    ;if heads=2, then (2/2)-1=0, but 0 is cbm 3040/4040.
    ;TODO: wrong negation, check it again!
    ;
    ;POKE &H5670+D, (heads/2)+1
    ;REM 2 heads => type 2, 4 heads => type 3, 6 heads => type 4 and 8 heads => type 5
    ld a,(heads)        ;0483 3a 17 30
    or a                ;0486 b7
    rra                 ;0487 1f
    inc a               ;0488 3c
    ld c,a              ;0489 4f
    ld a,(dd)           ;048a 3a 16 30
    ld l,a              ;048d 6f
    rla                 ;048e 17
    sbc a,a             ;048f 9f
    ld de,5670h         ;0490 11 70 56
    ld h,a              ;0493 67
    add hl,de           ;0494 19
    ld (hl),c           ;0495 71

ask_sbox_conf:
    ;PRINT "Use the ENTIRE drive for CP/M"
    ld bc,l0e35h
    call print_str_eol

    ;PRINT "or just the first HALF (E/H) ? ";
    ld bc,l0e53h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H48 THEN GOTO not_half_sbox
    ld a,(rr)
    cp 'H'              ;Is it 'H': use first half only for CP/M?
    jp nz,not_half_sbox ;  No: jump to not_half_sbox

    ;REM User selected 'H' for use first half for CP/M

    ;lastcyl = cylinders / 2
    ld hl,(cylinders)
    or a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld (lastcyl),hl

    ;GOTO got_sbox_conf
    jp got_sbox_conf

not_half_sbox:
    ;IF R <> &H45 THEN GOTO bad_sbox_conf
    ld a,(rr)
    cp 'E'              ;Is it 'E': use entire drive for CP/M?
    jp nz,bad_sbox_conf ;  No: jump to bad_hbox_conf

    ;REM User selected 'E' for use entire drive for CP/M

    ;lastcyl = cylinders
    ld hl,(cylinders)
    ld (lastcyl),hl

    ;GOTO got_sbox_conf
    jp got_sbox_conf

bad_sbox_conf:
    ;GOTO ask_sbox_conf ' Bad input
    jp ask_sbox_conf

got_sbox_conf:
    ;POKE &H5805, lastcyl*heads/2
    ld a,(heads)        ;04d4 3a 17 30
    ld l,a              ;04d7 6f
    rla                 ;04d8 17
    sbc a,a             ;04d9 9f
    ld h,a              ;04da 67
    or a                ;04db b7
    ld a,h              ;04dc 7c
    rra                 ;04dd 1f
    ld h,a              ;04de 67
    ld a,l              ;04df 7d
    rra                 ;04e0 1f
    ld l,a              ;04e1 6f
    push hl             ;04e2 e5
    ld hl,(lastcyl)     ;04e3 2a 1c 30
    ld b,h              ;04e6 44
    ld c,l              ;04e7 4d
    pop hl              ;04e8 e1
    ex de,hl            ;04e9 eb
    call sub_24cdh      ;04ea cd cd 24 (Library MUL)
    dec de              ;04ed 1b
    ex de,hl            ;04ee eb
    ld (5805h),hl       ;04ef 22 05 58

    ld bc,-256          ;04f2 01 00 ff
    ld hl,(5805h)       ;04f5 2a 05 58
    add hl,bc           ;04f8 09
    add hl,hl           ;04f9 29
    jp c,l0505h         ;04fa da 05 05

    ;POKE &H5804, 3
    ld hl,5804h         ;04fd 21 04 58
    ld (hl),03h         ;0500 36 03

    ;GOTO l050ah
    jp l050ah           ;0502 c3 0a 05

l0505h:
    ld hl,5804h         ;0505 21 04 58
    ld (hl),07h         ;0508 36 07
l050ah:
    ld hl,0040h         ;050a 21 40 00
    ld (5800h),hl       ;050d 22 00 58
    ld hl,5802h         ;0510 21 02 58
    ld (hl),06h         ;0513 36 06
    inc hl              ;0515 23
    ld (hl),3fh         ;0516 36 3f
    ld hl,00ffh         ;0518 21 ff 00
    ld (5807h),hl       ;051b 22 07 58
    ld hl,5809h         ;051e 21 09 58
    ld (hl),80h         ;0521 36 80
    inc hl              ;0523 23
    ld (hl),00h         ;0524 36 00
    ld hl,0000h         ;0526 21 00 00
    ld (580bh),hl       ;0529 22 0b 58
    inc hl              ;052c 23
    inc hl              ;052d 23
    ld (580dh),hl       ;052e 22 0d 58

ask_unit:
    ;PRINT "Physical unit # (0 or 1) ? ";
    ld bc,l0e73h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF (R < &H30) OR (R > &H31) THEN GOTO bad_unit
    ld a,(rr)
    cp '0'
    jp m,bad_unit
    cp '1'+1
    jp p,bad_unit

    ;REM User entered either '0' or '1'

    ;UNIT = R - &H30
    ld a,(rr)
    add a,-'0'          ;Convert ASCII to number
    ld (unit),a

    ;GOTO l0558h
    jp l0558h

bad_unit:
    ;GOTO ask_unit
    jp ask_unit

l0558h:
    ;PRINT "Start surface #'s from 0  (Y/N) ? ";
    ld bc,l0e8fh
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H59 THEN GOTO bad_sbox_conf
    ld a,(rr)
    cp 'Y'
    jp nz,l0574h

    ;REM User selected 'Y' for start surface #'s from 0

    ;firsthead = 0
    ld hl,firsthead
    ld (hl),00h

    ;GOTO l05a6h
    jp l05a6h

l0574h:
    ;IF R <> &H4E THEN GOTO l05a3h
    ld a,(rr)
    cp 'N'
    jp nz,l05a3h

    ;REM User selected 'N' for do not start surface #'s at 0

    ;PRINT "Offset for surface #'s ? ";
    ld bc,l0eb2h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ld hl,(nn)          ;0588 2a c8 24
    add hl,hl           ;058b 29
    jp c,l0558h         ;058c da 58 05
    ld bc,0fff0h        ;058f 01 f0 ff
    ld hl,(nn)          ;0592 2a c8 24
    add hl,bc           ;0595 09
    add hl,hl           ;0596 29
    jp nc,l0558h        ;0597 d2 58 05
    ld a,(nn)           ;059a 3a c8 24
    ld (firsthead),a    ;059d 32 19 30
    jp l05a6h           ;05a0 c3 a6 05
l05a3h:
    jp ask_sbox_conf    ;05a3 c3 96 04
l05a6h:
    ld c,04h            ;05a6 0e 04
    ld a,(firsthead)    ;05a8 3a 19 30
    jp l05afh           ;05ab c3 af 05
l05aeh:
    add a,a             ;05ae 87
l05afh:
    dec c               ;05af 0d
    jp p,l05aeh         ;05b0 f2 ae 05
    ld hl,unit          ;05b3 21 18 30
    add a,(hl)          ;05b6 86
    dec hl              ;05b7 2b
    dec hl              ;05b8 2b
    ld c,a              ;05b9 4f
    ld a,(hl)           ;05ba 7e
    ld l,a              ;05bb 6f
    rla                 ;05bc 17
    sbc a,a             ;05bd 9f
    ld de,5678h         ;05be 11 78 56
    ld h,a              ;05c1 67
    add hl,de           ;05c2 19
    ld (hl),c           ;05c3 71
    ld a,(unit)         ;05c4 3a 18 30
    ld l,a              ;05c7 6f
    rla                 ;05c8 17
    sbc a,a             ;05c9 9f
    ld h,a              ;05ca 67
    add hl,hl           ;05cb 29
    ld bc,5648h         ;05cc 01 48 56
    add hl,bc           ;05cf 09
    ex de,hl            ;05d0 eb
    ld hl,(cylinders)   ;05d1 2a 1a 30
    ex de,hl            ;05d4 eb
    ld (hl),e           ;05d5 73
    inc hl              ;05d6 23
    ld (hl),d           ;05d7 72
    ld a,(unit)         ;05d8 3a 18 30
    ld l,a              ;05db 6f
    rla                 ;05dc 17
    sbc a,a             ;05dd 9f
    ld h,a              ;05de 67
    add hl,hl           ;05df 29
    ld bc,564ch         ;05e0 01 4c 56
    add hl,bc           ;05e3 09
    ex de,hl            ;05e4 eb
    ld hl,(lastcyl)     ;05e5 2a 1c 30
    ex de,hl            ;05e8 eb
    ld (hl),e           ;05e9 73
    inc hl              ;05ea 23
    ld (hl),d           ;05eb 72
    ret                 ;05ec c9

l05edh:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "Disk Drive Assignment."
    ld bc,l0ecch
    call print_str_eol

    ;PRINT "---- ----- -----------"
    ld bc,l0ee3h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;D = 0 ' Loop index for drives (0-7)
    ld hl,dd
    ld (hl),00h

    ;GOTO l085eh
    jp l085eh

l060ah:
    ;REM Print drive letter pair (e.g. "A, B")
    ;PRINT CHR$(D*2+&H41);      ' First letter in drive pair
    ld a,(dd)
    add a,a
    add a,'A'
    ld c,a
    call print_char

    ;PRINT ", ";                ' Comma between letters in pair
    ld bc,l0efah
    call print_str

    ;PRINT CHR$(D*2+&H42);      ' Second letter in drive pair
    ld a,(dd)
    add a,a
    add a,'B'
    ld c,a
    call print_char

    ;PRINT ":      ";
    ld bc,l0efdh
    call print_str

    ;IF PEEK(&H5670+D) <> 0 THEN GOTO l0657h
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld a,(hl)
    or a                ;Is it drive type 0 (CBM 3040/4040)?
    jp nz,l0657h        ;  No: jump to l0657h

    ;REM Drive type is CBM 3040/4040

    ;PRINT "3040/4040  Device # ";
    ld bc,cbm3040
    call print_str

    ;PRINT PEEK(&H5678+D);      ' Print device number
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5678h
    ld h,a
    add hl,bc
    ld a,(hl)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int

    ;GOTO l0857h
    jp l0857h

l0657h:
    ;IF PEEK(&H5670) <> 1 THEN GOTO l0685h
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld a,(hl)
    cp 01h              ;Is it drive type 1 (CBM 8050)?
    jp nz,l0685h        ;  No: jump to l0685h

    ;REM Drive type is CBM 8050

    ;PRINT "8050       Device # ";
    ld bc,cbm8050
    call print_str

    ;PRINT PEEK(&H5678+D);      ' Print device number
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5678h
    ld h,a
    add hl,bc
    ld a,(hl)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int

    ;GOTO l0857h
    jp l0857h

l0685h:
    ;IF PEEK(&H5670+D) <> 6 THEN GOTO l06b3h
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld a,(hl)
    cp 06h              ;Is it drive type 6 (CBM 8250)?
    jp nz,l06b3h        ;  No: jump to l06b3h

    ;REM Drive type is CBM 8250

    ;PRINT "8250       Device # ";
    ld bc,cbm_8250
    call print_str

    ;PRINT PEEK(&H5678+D);      ' Print device number
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5678h
    ld h,a
    add hl,bc
    ld a,(hl)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int

    ;GOTO l0857h
    jp l0857h

l06b3h:
    ;TODO this disassembly may be wrong.  the drive type is "not used"
    ;when bit 7 is set.
    ;
    ;IF PEEK(&H5670+D) >= 0 THEN GOTO l06cch
    ld a,(dd)           ;06b3 3a 16 30
    ld l,a              ;06b6 6f
    rla                 ;06b7 17
    sbc a,a             ;06b8 9f
    ld bc,5670h         ;06b9 01 70 56
    ld h,a              ;06bc 67
    add hl,bc           ;06bd 09
    ld a,(hl)           ;06be 7e
    or a                ;06bf b7
    jp p,l06cch         ;06c0 f2 cc 06

    ;REM Drive type is Not Used

    ;PRINT "Not used  ";
    ld bc,not_used
    call print_str

    ;GOTO l0857h
    jp l0857h

l06cch:
    ;IF 1=1 THEN GOTO l075ah
    ld a,01h
    cp 01h
    jp z,l075ah

    ;REM Drive type is a Corvus hard drive

    ;PRINT "Corvus     ";
    ld bc,corvus_space
    call print_str

    ;IF PEEK(&H5670h+D) <> 2 THEN GOTO l06f0h
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld a,(hl)
    cp 02h              ;Is it drive type 2 (Corvus 10 MB)?
    jp nz,l06f0h        ;  No: jump to l06f0h

    ;REM Drive type is Corvus 10 MB

    ld hl,size_10mb

    ;GOTO l0738h
    jp l0738h

l06f0h:
    ;IF PEEK(&H5670h+D) <> 3 THEN GOTO l06f0h
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld a,(hl)
    cp 03h              ;Is it drive type 3 (Corvus 20 MB)?
    jp nz,l0707h        ;  No: jump to l0707h

    ;REM Drive type is Corvus 20 MB

    ld hl,size_20mb

    ;GOTO l0738h
    jp l0738h

l0707h:
    ;IF PEEK(&H5670h+D) <> 4 THEN GOTO l06f0h
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld a,(hl)
    cp 04h              ;Is it drive type 4 (Corvus 5 MB)?
    jp nz,l071eh        ;  No: jump to l071eh

    ;REM Drive type is Corvus 5 MB

    ld hl,size_5mb

    ;GOTO l0738h
    jp l0738h

l071eh:
    ;IF PEEK(&H5670h+D) <> 5 THEN GOTO l06f0h
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld a,(hl)
    cp 05h              ;Is it drive type 5 (Corvus 5 MB as 2 CP/M drives)?
    jp nz,l0735h        ;  No: jump to l0735h

    ;REM Drive type is Corvus 5 MB (as 2 CP/M drives)

    ld hl,size_5mb_as_2

    ;GOTO l0738h
    jp l0738h

l0735h:
    ld hl,l0f73h        ;0735 21 73 0f

l0738h:
    ld b,h              ;0738 44
    ld c,l              ;0739 4d
    call print_str      ;073a cd 84 01

    ;PRINT "Device # ";
    ld bc,device_num
    call print_str

    ;PRINT PEEK(&H5678+D);      ' Print device number
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5678h
    ld h,a
    add hl,bc
    ld a,(hl)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int

    ;GOTO l0857h
    jp l0857h

l075ah:
    ;REM The system is a Mini-Winchester (Konan David Jr) not Corvus

    ;unit = 1 AND PEEK(&H5678+D)
    ld a,(dd)           ;075a 3a 16 30
    ld l,a              ;075d 6f
    rla                 ;075e 17
    sbc a,a             ;075f 9f
    ld bc,5678h         ;0760 01 78 56
    ld h,a              ;0763 67
    add hl,bc           ;0764 09
    ld a,(hl)           ;0765 7e
    and 01h             ;0766 e6 01
    ld (unit),a         ;0768 32 18 30

    ld a,(dd)           ;076b 3a 16 30
    ld l,a              ;076e 6f
    rla                 ;076f 17
    sbc a,a             ;0770 9f
    ld bc,5678h         ;0771 01 78 56
    ld h,a              ;0774 67
    add hl,bc           ;0775 09
    ld c,(hl)           ;0776 4e
    ld l,c              ;0777 69
    ld c,04h            ;0778 0e 04
    ld h,00h            ;077a 26 00
    jp l0780h           ;077c c3 80 07

l077fh:
    add hl,hl           ;077f 29
l0780h:
    dec c               ;0780 0d
    jp p,l077fh         ;0781 f2 7f 07
    ex de,hl            ;0784 eb
    ld hl,firsthead     ;0785 21 19 30
    ld (hl),d           ;0788 72
    dec hl              ;0789 2b
    dec hl              ;078a 2b
    dec hl              ;078b 2b
    ld a,(hl)           ;078c 7e
    ld l,a              ;078d 6f
    rla                 ;078e 17
    sbc a,a             ;078f 9f
    ld bc,5670h         ;0790 01 70 56
    ld h,a              ;0793 67
    add hl,bc           ;0794 09
    ld a,(hl)           ;0795 7e
    dec a               ;0796 3d
    add a,a             ;0797 87
    ld (heads),a        ;0798 32 17 30

    ;REM Print summary of Mini-Winchester drive in this format:
    ;REM   Winchester Unit # 0
    ;REM   (320 cyl,  10 Mbyte drive,
    ;REM   Head 0-3  Cyls 1-320 used)

    ;PRINT "Winchester Unit # ";
    ld bc,win_unit_num
    call print_str

    ;PRINT unit                 ' Konan David Jr drive unit # (0 or 1)
    ld a,(unit)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int
    call print_eol

    ;PRINT "           (";
    ld bc,l0f97h
    call print_str

    ;PRINT DEEK(&H5648+unit*2)  ' Total cylinders
    ld a,(unit)         ;07b5 3a 18 30
    ld l,a              ;07b8 6f
    rla                 ;07b9 17
    sbc a,a             ;07ba 9f
    ld h,a              ;07bb 67
    add hl,hl           ;07bc 29
    ld bc,5648h         ;07bd 01 48 56
    add hl,bc           ;07c0 09
    ld c,(hl)           ;07c1 4e
    inc hl              ;07c2 23
    ld b,(hl)           ;07c3 46
    call print_int      ;07c4 cd f6 01

    ;PRINT " cyl,  ";
    ld bc,cyl_comma
    call print_str

    ;TODO decompile me          ' Total drive size in megabytes
    ld a,(heads)        ;07cd 3a 17 30
    ld l,a              ;07d0 6f
    rla                 ;07d1 17
    sbc a,a             ;07d2 9f
    ld h,a              ;07d3 67
    ld a,(unit)         ;07d4 3a 18 30
    ld c,a              ;07d7 4f
    rla                 ;07d8 17
    sbc a,a             ;07d9 9f
    ld b,h              ;07da 44
    ld h,a              ;07db 67
    ld e,l              ;07dc 5d
    ld l,c              ;07dd 69
    add hl,hl           ;07de 29
    ld d,b              ;07df 50
    ld bc,5648h         ;07e0 01 48 56
    add hl,bc           ;07e3 09
    ld b,d              ;07e4 42
    ld c,e              ;07e5 4b
    ld e,(hl)           ;07e6 5e
    inc hl              ;07e7 23
    ld d,(hl)           ;07e8 56
    call sub_24cdh      ;07e9 cd cd 24 (Library MUL)
    ld b,07h            ;07ec 06 07
    jp l07f8h           ;07ee c3 f8 07
l07f1h:
    or a                ;07f1 b7
    ld a,d              ;07f2 7a
    rra                 ;07f3 1f
    ld d,a              ;07f4 57
    ld a,e              ;07f5 7b
    rra                 ;07f6 1f
    ld e,a              ;07f7 5f
l07f8h:
    dec b               ;07f8 05
    jp p,l07f1h         ;07f9 f2 f1 07
    ld b,d              ;07fc 42
    ld c,e              ;07fd 4b
    call print_int      ;07fe cd f6 01

    ;PRINT " Mbyte drive,"
    ld bc,mbyte_drive
    call print_str
    call print_eol

    ;PRINT "           Head ";
    ld bc,l0fbah
    call print_str

    ;PRINT firsthead;           ' First head that MW-1000 will use
    ld a,(firsthead)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int

    ;PRINT "-";
    ld bc,l0fcbh
    call print_str

    ;PRINT firsthead+heads-1;   ' Last head that MW-1000 will use
    ld a,(firsthead)    ;0821 3a 19 30
    ld l,a              ;0824 6f
    rla                 ;0825 17
    sbc a,a             ;0826 9f
    ld h,a              ;0827 67
    ld a,(heads)        ;0828 3a 17 30
    ld c,a              ;082b 4f
    rla                 ;082c 17
    sbc a,a             ;082d 9f
    ld b,a              ;082e 47
    dec bc              ;082f 0b
    add hl,bc           ;0830 09
    ld b,h              ;0831 44
    ld c,l              ;0832 4d
    call print_int      ;0833 cd f6 01

    ;PRINT "  Cyls 1-";         ' First cylinder MW-1000 will use (always 1)
    ld bc,l0fcdh
    call print_str

    ;PRINT DEEK(&H564c+unit*2); ' Last cylinder MW-1000 will use
    ld a,(unit)         ;083c 3a 18 30
    ld l,a              ;083f 6f
    rla                 ;0840 17
    sbc a,a             ;0841 9f
    ld h,a              ;0842 67
    add hl,hl           ;0843 29
    ld bc,564ch         ;0844 01 4c 56
    add hl,bc           ;0847 09
    ld c,(hl)           ;0848 4e
    inc hl              ;0849 23
    ld b,(hl)           ;084a 46
    call print_int      ;084b cd f6 01

    ;PRINT " used)"
    ld bc,l0fd7h
    call print_str

    ;PRINT
    call print_eol

l0857h:
    ;PRINT
    call print_eol

    ;dd = dd + 1 ' Increment index to next drive
    ld hl,dd
    inc (hl)

l085eh:
    ;IF dd < 8 THEN GOTO l060ah ' Loop until all 8 drives are printed
    ld a,(dd)
    cp 08h
    jp m,l060ah

    ;PRINT
    call print_eol

    ;PRINT "Alter which drive pair (A to O) ? ";
    ld bc,l0fdeh
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H0D THEN GOTO ask_flop_hard
    ld a,(rr)
    cp cr
    jp nz,ask_flop_hard

    ;REM User pressed return without entering a letter

    ;RETURN
    ret

ask_flop_hard:
    ;IF (R < &H41) OR (R > &H50) THEN GOTO l0993h ' Bad input
    ld a,(rr)
    cp 'A'
    jp m,l0993h
    cp 'P'+1
    jp p,l0993h

    ;D = R - &H41 ' Convert ASCII to drive index
    add a,-'A'
    or a
    rra
    ld (dd),a

    ;PRINT "F(loppy),  H(ard) or  U(nused)  ? ";
    ld bc,l1001h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H46 THEN GOTO l0909h
    ld a,(rr)
    cp 'F'
    jp nz,l0909h

    ;REM User selected 'F' for Floppy drive

ask_flop_type:
    ;PRINT "Type (A=3040/4040, B=8050, C=8250) ? ";
    ld bc,l1024h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H41 THEN GOTO l08cdh
    ld a,(rr)
    cp 'A'
    jp nz,l08cdh

    ;REM User selected 'A' for 3040/4040

    ;POKE &H5670+D, 0 ' Store drive type 0 (CBM 3040/4040)
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld (hl),00h

    ;GOSUB ask_drv_dev
    call ask_drv_dev

    ;GOTO l0906h
    jp l0906h

l08cdh:
    ;IF R <> &H42 THEN GOTO l08e8h
    ld a,(rr)
    cp 'B'
    jp nz,l08e8h

    ;REM User selected 'B' for 8050

    ;POKE &H5670+D, 1 ' Store drive type 1 (CBM 8050)
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld (hl),01h

    ;GOSUB ask_drv_dev
    call ask_drv_dev

    ;GOTO l0906h
    jp l0906h

l08e8h:
    ;IF R <> &H43 THEN GOTO l0903h
    ld a,(rr)
    cp 'C'
    jp nz,l0903h

    ;REM User selected 'C' for 8250

    ;POKE &H5670h+D, 6 ' Store drive type 6 (CBM 8250)
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld (hl),06h

    ;GOSUB ask_drv_dev
    call ask_drv_dev

    ;GOTO l0906h
    jp l0906h

l0903h:
    ;GOTO ask_flop_type
    jp ask_flop_type

l0906h:
    ;GOTO l091eh
    jp l091eh

l0909h:
    ;IF R <> &H55 THEN GOTO l091eh
    ld a,(rr)
    cp 'U'
    jp nz,l091eh

    ;REM User selected 'U' for Unused

    ;POKE &H5670+D, 255 ' Store drive type 255 (Not Used)
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld (hl),0ffh

l091eh:
    ;IF R <> &H59 THEN GOTO l0993h
    ld a,(rr)
    cp 'H'
    jp nz,l0993h

    ;REM User selected 'H' for Hard drive

    ;REM Jump if the system is a Mini-Winchester (Konan David Jr)
    ;IF 1=1 THEN GOTO l0990h
    ld a,01h
    cp 01h
    jp z,l0990h

    ;REM The system is not a Mini-Winchester, it's for Corvus.

    ;PRINT "5, 10, or 20 Mbyte drive ? ";
    ld bc,l104ah
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF N <> 5 THEN GOTO l0955h
    ld bc,-5
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l0955h

    ;REM User entered 5 MB

    ;POKE &H5670+D, 4 ' Store drive type 4 (Corvus 5 MB)
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld (hl),04h

    ;GOTO l098ah
    jp l098ah

l0955h:
    ;IF N <> 10 THEN GOTO l0971h
    ld bc,-10
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l0971h

    ;REM User entered 10 MB

    ;POKE &H5670+D, 2 ' Store drive type 2 (Corvus 10 MB)
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld (hl),02h

    ;GOTO l098ah
    jp l098ah

l0971h:
    ;IF N <> 20 THEN GOTO l098ah
    ld bc,-20
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l098ah

    ;REM User entered 10 MB

    ;POKE &H5670+D, 3 ' Store drive type 3 (Corvus 20 MB)
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld bc,5670h
    ld h,a
    add hl,bc
    ld (hl),03h

l098ah:
    ;GOSUB ask_drv_dev
    call ask_drv_dev

    ;GOTO l0993h
    jp l0993h

l0990h:
    ;GOSUB ask_drv_type
    call ask_drv_type

l0993h:
    jp l05edh           ;0993 c3 ed 05
    ret                 ;0996 c9

sub_0997h:
    ;GOSUB clear_screen
    call clear_screen

    ;IF PEEK(&H4007) <> 0 THEN GOTO l09adh
    ld a,(4007h)
    or a
    jp nz,l09adh

    ;PRINT "No current autoload command"
    ld bc,l1066h
    call print_str_eol

    ;PRINT
    call print_eol

    ;GOTO ask_autoload
    jp ask_autoload

l09adh:
    ;PRINT "Current autoload command is : "
    ld bc,l1082h
    call print_str_eol

    ;AINDEX = 1
    ld hl,aindex
    ld (hl),01h

    ;ASIZE = PEEK(&H4007) ' Number of bytes in autoload command
    ld a,(4007h)
    inc hl
    ld (hl),a

    ;GOTO l09d3h
    jp l09d3h

l09c0h:
    ;PRINT CHR$(PEEK(&H4007+AINDEX));
    ld a,(aindex)
    ld l,a
    rla
    sbc a,a
    ld bc,4007h
    ld h,a
    add hl,bc
    ld c,(hl)
    call print_char

    ;AINDEX = AINDEX + 1
    ld hl,aindex
    inc (hl)

l09d3h:
    ;IF ASIZE >= AINDEX THEN GOTO l09c0h
    ld a,(asize)
    ld hl,aindex
    cp (hl)
    jp p,l09c0h

ask_autoload:
    ;PRINT
    call print_eol

    ;PRINT "New autoload command  (Y/N) ? ";
    ld bc,l10a1h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H59 THEN GOTO l0a48h
    ld a,(rr)
    cp 'Y'
    jp nz,l0a48h

    ;PRINT "Please enter the new command : "
    ld bc,l10c0h
    call print_str_eol

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ld a,(l2425h)       ;0a00 3a 25 24
    ld (4007h),a        ;0a03 32 07 40
    ld hl,aindex        ;0a06 21 1e 30
    ld (hl),01h         ;0a09 36 01
    ld a,(l2425h)       ;0a0b 3a 25 24
    inc hl              ;0a0e 23
    ld (hl),a           ;0a0f 77
    jp l0a30h           ;0a10 c3 30 0a

l0a13h:
    ;POKE &H4007+AINDEX, l2425h(l301e)
    ld a,(aindex)       ;0a13 3a 1e 30
    ld l,a              ;0a16 6f
    rla                 ;0a17 17
    sbc a,a             ;0a18 9f
    ld bc,l2425h        ;0a19 01 25 24
    ld h,a              ;0a1c 67
    add hl,bc           ;0a1d 09
    ld a,(aindex)       ;0a1e 3a 1e 30
    ld c,a              ;0a21 4f
    rla                 ;0a22 17
    sbc a,a             ;0a23 9f
    ld de,4007h         ;0a24 11 07 40
    ld b,(hl)           ;0a27 46
    ld h,a              ;0a28 67
    ld l,c              ;0a29 69
    add hl,de           ;0a2a 19
    ld (hl),b           ;0a2b 70

    ;AINDEX = AINDEX + 1
    ld hl,aindex        ;0a2c 21 1e 30
    inc (hl)            ;0a2f 34

l0a30h:
    ;IF ASIZE >= AINDEX THEN GOTO l0a13h
    ld a,(asize)
    ld hl,aindex
    cp (hl)
    jp p,l0a13h

    ;POKE &H4007+l2425+1, 0
    ld a,(l2425h)       ;0a3a 3a 25 24
    ld l,a              ;0a3d 6f
    rla                 ;0a3e 17
    sbc a,a             ;0a3f 9f
    ld h,a              ;0a40 67
    inc hl              ;0a41 23
    ld bc,4007h         ;0a42 01 07 40
    add hl,bc           ;0a45 09
    ld (hl),00h         ;0a46 36 00

l0a48h:
    ret                 ;0a48 c9

sub_0a49h:
    call 2137h          ;0a49 cd 37 21
    ret                 ;0a4c c9

l0a4dh:
    ;PRINT "Save on which drive (A - P) ? ";
    ld bc,l10e0h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ld a,(rr)           ;0a59 3a cc 24
    cp 'A'              ;0a5c fe 41
    jp p,l0a66h         ;0a5e f2 66 0a
    cp 'P'+1            ;0a61 fe 51
    jp p,l0af0h         ;0a63 f2 f0 0a
l0a66h:
    ld a,(rr)           ;0a66 3a cc 24
    ld l,a              ;0a69 6f
    rla                 ;0a6a 17
    sbc a,a             ;0a6b 9f
    ld bc,-'A'          ;0a6c 01 bf ff
    ld h,a              ;0a6f 67
    add hl,bc           ;0a70 09
    ld (l3002h),hl      ;0a71 22 02 30
    ld hl,(l3002h)      ;0a74 2a 02 30
    add hl,hl           ;0a77 29
    jp c,l0a86h         ;0a78 da 86 0a
    ld bc,-16           ;0a7b 01 f0 ff
    ld hl,(l3002h)      ;0a7e 2a 02 30
    add hl,bc           ;0a81 09
    add hl,hl           ;0a82 29
    jp c,l0a87h         ;0a83 da 87 0a
l0a86h:
    ret                 ;0a86 c9
l0a87h:
    ld hl,l3002h        ;0a87 21 02 30
    ld c,(hl)           ;0a8a 4e
    call sub_0103h      ;0a8b cd 03 01
    ld l,a              ;0a8e 6f
    rla                 ;0a8f 17
    sbc a,a             ;0a90 9f
    ld h,a              ;0a91 67
    ld (l3020h),hl      ;0a92 22 20 30
    ld bc,-128          ;0a95 01 80 ff
    ld hl,(l3020h)      ;0a98 2a 20 30
    add hl,bc           ;0a9b 09
    add hl,hl           ;0a9c 29
    jp c,l0aa9h         ;0a9d da a9 0a

    ;PRINT "Drive not in system"
    ld bc,l10ffh
    call print_str_eol

    jp l0a4dh           ;0aa6 c3 4d 0a

l0aa9h:
    ld hl,(l3020h)      ;0aa9 2a 20 30
    dec hl              ;0aac 2b
    dec hl              ;0aad 2b
    add hl,hl           ;0aae 29
    jp c,l0ac7h         ;0aaf da c7 0a
    ld bc,-6            ;0ab2 01 fa ff
    ld hl,(l3020h)      ;0ab5 2a 20 30
    add hl,bc           ;0ab8 09
    add hl,hl           ;0ab9 29
    jp nc,l0ac7h        ;0aba d2 c7 0a
    ld hl,l3002h        ;0abd 21 02 30
    ld c,(hl)           ;0ac0 4e
    call cwrite_        ;0ac1 cd e3 21
    jp l0af0h           ;0ac4 c3 f0 0a

l0ac7h:
    ld hl,l3002h        ;0ac7 21 02 30
    ld c,(hl)           ;0aca 4e
    call sub_0113h      ;0acb cd 13 01
    ld hl,l3002h        ;0ace 21 02 30
    ld c,(hl)           ;0ad1 4e
    call savesy         ;0ad2 cd 40 22
    call sub_011eh      ;0ad5 cd 1e 01
    or a                ;0ad8 b7
    jp z,l0af0h         ;0ad9 ca f0 0a

    ;PRINT "Retry (Y/N) ? ";
    ld bc,l1113h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R = &H59 THEN GOTO l0ac7h
    ld a,(rr)
    cp 'Y'
    jp z,l0ac7h

l0af0h:
    ;RETURN
    ret

start:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call print_eol

    ;PRINT "CP/M Reconfiguration"
    ld bc,l1122h
    call print_str_eol

    ;PRINT "---- ---------------"
    ld bc,l1137h
    call print_str_eol

    ;PRINT
    call print_eol

    ;IF 1=1 THEN GOTO l0b13h
    ld a,01h
    cp 01h
    jp nz,l0b13h

    ;PRINT "Mini-Winchester version"
    ld bc,l114ch
    call print_str_eol

l0b13h:
    ;PRINT "Revision C2.2  --   9 March 1984"
    ld bc,l1164h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Source drive (A - P) ? ";
    ld bc,l1185h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R = &H0D THEN GOTO start
    ld a,(rr)
    cp cr
    jp z,start

    ;IF R = &H5F THEN GOTO l0babh
    cp '_'
    jp z,l0babh

    cp 'A'              ;0b38 fe 41
    jp p,l0b42h         ;0b3a f2 42 0b
    cp 'P'+1            ;0b3d fe 51
    jp p,l0ba8h         ;0b3f f2 a8 0b

l0b42h:
    ld a,(rr)           ;0b42 3a cc 24
    ld l,a              ;0b45 6f
    rla                 ;0b46 17
    sbc a,a             ;0b47 9f
    ld bc,-'A'          ;0b48 01 bf ff
    ld h,a              ;0b4b 67
    add hl,bc           ;0b4c 09
    ld (l3002h),hl      ;0b4d 22 02 30
    ld hl,l3002h        ;0b50 21 02 30
    ld c,(hl)           ;0b53 4e
    call sub_0103h      ;0b54 cd 03 01
    ld l,a              ;0b57 6f
    rla                 ;0b58 17
    sbc a,a             ;0b59 9f
    ld h,a              ;0b5a 67
    ld (l3004h),hl      ;0b5b 22 04 30
    ld bc,-129          ;0b5e 01 7f ff
    ld hl,(l3004h)      ;0b61 2a 04 30
    add hl,bc           ;0b64 09
    add hl,hl           ;0b65 29
    jp nc,l0ba2h        ;0b66 d2 a2 0b
    ld hl,(l3004h)      ;0b69 2a 04 30
    dec hl              ;0b6c 2b
    dec hl              ;0b6d 2b
    add hl,hl           ;0b6e 29
    jp c,l0b87h         ;0b6f da 87 0b
    ld bc,-6            ;0b72 01 fa ff
    ld hl,(l3004h)      ;0b75 2a 04 30
    add hl,bc           ;0b78 09
    add hl,hl           ;0b79 29
    jp nc,l0b87h        ;0b7a d2 87 0b
    ld hl,l3002h        ;0b7d 21 02 30
    ld c,(hl)           ;0b80 4e
    call cread_         ;0b81 cd b0 21
    jp l0b9fh           ;0b84 c3 9f 0b
l0b87h:
    ld hl,l3002h        ;0b87 21 02 30
    ld c,(hl)           ;0b8a 4e
    call sub_0113h      ;0b8b cd 13 01
    ld hl,l3002h        ;0b8e 21 02 30
    ld c,(hl)           ;0b91 4e
    call rdsys          ;0b92 cd 45 21
    call sub_011eh      ;0b95 cd 1e 01
    or a                ;0b98 b7
    jp z,l0b9fh         ;0b99 ca 9f 0b
    call end            ;0b9c cd 67 01
l0b9fh:
    jp l0ba5h           ;0b9f c3 a5 0b
l0ba2h:
    jp start           ;0ba2 c3 f1 0a
l0ba5h:
    jp l0babh           ;0ba5 c3 ab 0b
l0ba8h:
    jp start           ;0ba8 c3 f1 0a

l0babh:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call print_eol

    ;PRINT "CP/M Reconfiguration"
    ld bc,l119dh
    call print_str_eol

    ;PRINT "---- ---------------"
    ld bc,l11b2h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "A = Autoload command"
    ld bc,l11c7h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "D = Disk Drive Assignment"
    ld bc,l11dch
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "I = I/O Assignment"
    ld bc,l11f6h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "P = Pet Terminal Parameters"
    ld bc,l1209h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "R = RS232 Characteristics"
    ld bc,l1225h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "S = Save New System"
    ld bc,l123fh
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "E = Execute New System"
    ld bc,l1253h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Q = Quit This Program"
    ld bc,l126ah
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Please enter the appropriate letter: ";
    ld bc,l1280h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H41 THEN GOTO l0c22h
    ld a,(rr)
    cp 'A'
    jp nz,l0c22h

    ;REM User selected 'A' for Autoload command

    ;GOSUB sub_0997h
    call sub_0997h

    ;GOTO l0c81h
    jp l0c81h

l0c22h:
    ;IF R <> &H44 THEN GOTO l0c30h
    ld a,(rr)
    cp 'D'
    jp nz,l0c30h

    ;REM User selected 'D' for Disk Drive Assignment

    ;GOSUB sub_0306h
    call sub_0306h

    ;GOTO l0c81h
    jp l0c81h

l0c30h:
    ;IF R <> &H49 THEN GOTO l0c3eh
    ld a,(rr)
    cp 'I'
    jp nz,l0c3eh

    ;REM User selected 'I' for I/O Assignment

    ;GOSUB sub_1564h
    call sub_1564h

    ;GOTO l0c81h
    jp l0c81h

l0c3eh:
    ;IF R <> &H50 THEN GOTO l0c4ch
    ld a,(rr)
    cp 'P'
    jp nz,l0c4ch

    ;REM User selected 'P' for Pet Terminal Parameters

    ;GOSUB sub_1876h
    call sub_1876h

    ;GOTO l0c81h
    jp l0c81h

l0c4ch:
    ;IF R <> &H52 THEN GOTO l0c5ah
    ld a,(rr)
    cp 'R'
    jp nz,l0c5ah

    ;REM User selected 'R' for RS232 Characteristics

    ;GOSUB l12a6h
    call l12a6h

    ;GOTO l0c81h
    jp l0c81h

l0c5ah:
    ;IF R <> &H53 THEN GOTO l0c68h
    ld a,(rr)
    cp 'S'
    jp nz,l0c68h

    ;REM User selected 'S' for Save New System

    ;GOSUB l0a4dh
    call l0a4dh

    ;GOSUB l0c81h
    jp l0c81h

l0c68h:
    ;IF R <> &H45 THEN GOTO l0c76h
    ld a,(rr)
    cp 'E'
    jp nz,l0c76h

    ;REM User selected 'E' for Execute New System

    ;GOSUB sub_0a49h
    call sub_0a49h

    ;GOTO l0c81h
    jp l0c81h

l0c76h:
    ;IF R <> &H51 THEN GOTO l0c81h
    ld a,(rr)
    cp 'Q'
    jp nz,l0c81h

    ;REM User selected 'Q' for Quit This Program

    ;END
    call end

l0c81h:
    ;GOTO l0babh
    jp l0babh

l0c84h:
    db 0eh
    db "Disk error :  "

l0c93h:
    db 01h
    db "0"

l0c95h:
    db 1ah
    db "Device number for drive ? "

l0cb0h:
    db 22h
    db "Configure as 1 or 2 CP/M drives ? "

l0cd3h:
    db 1dh
    db "Winchester sizes supported : "

l0cf1h:
    db 1ch
    db "A.   3  Mbyte      (191 cyl)"

l0d0eh:
    db 1ch
    db "B.   6  Mbyte      (191 cyl)"

l0d2bh:
    db 1ch
    db "C.   12 Mbyte      (191 cyl)"

l0d48h:
    db 1ch
    db "D.   5  Mbyte      (320 cyl)"

l0d65h:
    db 1ch
    db "E.   10 Mbyte      (320 cyl)"

l0d82h:
    db 1ch
    db "F.   15 Mbyte      (320 cyl)"

l0d9fh:
    db 23h
    db "Z.   User supplied Head & Cyl count"

l0dc3h:
    db 1eh
    db "Which drive type (A-F or Z) ? "

l0de2h:
    db 1ch
    db "Enter the number of Heads : "

l0dffh:
    db 14h
    db "Must be 2, 4, 6 or 8"

l0e14h:
    db 20h
    db "Enter the number of Cylinders : "

l0e35h:
    db 1dh
    db "Use the ENTIRE drive for CP/M"

l0e53h:
    db 1fh
    db "or just the first HALF (E/H) ? "

l0e73h:
    db 1bh
    db "Physical unit # (0 or 1) ? "

l0e8fh:
    db 22h
    db "Start surface #'s from 0  (Y/N) ? "

l0eb2h:
    db 19h
    db "Offset for surface #'s ? "

l0ecch:
    db 16h
    db "Disk Drive Assignment."

l0ee3h:
    db 16h
    db "---- ----- -----------"

l0efah:
    db 02h
    db ", "

l0efdh:
    db 07h
    db ":      "

cbm3040:
    db 14h
    db "3040/4040  Device # "

cbm8050:
    db 14h
    db "8050       Device # "

cbm_8250:
    db 14h
    db "8250       Device # "

not_used:
    db 0ah
    db "Not used  "

corvus_space:
    db 0bh
    db "Corvus     "

size_10mb:
    db 05h
    db "10Mb "

size_20mb:
    db 05h
    db "20Mb "

size_5mb:
    db 05h
    db "5Mb  "

size_5mb_as_2:
    db 05h
    db "5Mb* "

l0f73h:
    db 06h
    db "      "

device_num:
    db 09h
    db "Device # "

win_unit_num:
    db 12h
    db "Winchester Unit # "

l0f97h:
    db 0ch
    db "           ("

cyl_comma:
    db 07h
    db " cyl,  "

mbyte_drive:
    db 0dh
    db " Mbyte drive,"

l0fbah:
    db 10h
    db "           Head "

l0fcbh:
    db 01h
    db "-"

l0fcdh:
    db 09h
    db "  Cyls 1-"

l0fd7h:
    db 06h
    db " used)"

l0fdeh:
    db 22h
    db "Alter which drive pair (A to O) ? "

l1001h:
    db 22h
    db "F(loppy),  H(ard) or  U(nused)  ? "

l1024h:
    db 25h
    db "Type (A=3040/4040, B=8050, C=8250) ? "

l104ah:
    db 1bh
    db "5, 10, or 20 Mbyte drive ? "

l1066h:
    db 1bh
    db "No current autoload command"

l1082h:
    db 1eh
    db "Current autoload command is : "

l10a1h:
    db 1eh
    db "New autoload command  (Y/N) ? "

l10c0h:
    db 1fh
    db "Please enter the new command : "

l10e0h:
    db 1eh
    db "Save on which drive (A - P) ? "

l10ffh:
    db 13h
    db "Drive not in system"

l1113h:
    db 0eh
    db "Retry (Y/N) ? "

l1122h:
    db 14h
    db "CP/M Reconfiguration"

l1137h:
    db 14h
    db "---- ---------------"

l114ch:
    db 17h
    db "Mini-Winchester version"

l1164h:
    db 20h
    db "Revision C2.2  --   9 March 1984"

l1185h:
    db 17h
    db "Source drive (A - P) ? "

l119dh:
    db 14h
    db "CP/M Reconfiguration"

l11b2h:
    db 14h
    db "---- ---------------"

l11c7h:
    db 14h
    db "A = Autoload command"

l11dch:
    db 19h
    db "D = Disk Drive Assignment"

l11f6h:
    db 12h
    db "I = I/O Assignment"

l1209h:
    db 1bh
    db "P = Pet Terminal Parameters"

l1225h:
    db 19h
    db "R = RS232 Characteristics"

l123fh:
    db 13h
    db "S = Save New System"

l1253h:
    db 16h
    db "E = Execute New System"

l126ah:
    db 15h
    db "Q = Quit This Program"

l1280h:
    db 25h
    db "Please enter the appropriate letter: "

l12a6h:
    ;GOTO l13eeh
    jp l13eeh

ask_char_size:
    ;PRINT "New charater length (5 to 8) ? ";
    ld bc,l1b70h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;N = R - 53
    ld a,(rr)           ;12b5 3a cc 24
    ld l,a              ;12b8 6f
    rla                 ;12b9 17
    sbc a,a             ;12ba 9f
    ld bc,-53           ;12bb 01 cb ff
    ld h,a              ;12be 67
    add hl,bc           ;12bf 09
    ld (nn),hl          ;12c0 22 c8 24

    ld hl,(nn)          ;12c3 2a c8 24
    add hl,hl           ;12c6 29
    jp c,l12ech         ;12c7 da ec 12

    ld bc,-4            ;12ca 01 fc ff
    ld hl,(nn)          ;12cd 2a c8 24
    add hl,bc           ;12d0 09
    add hl,hl           ;12d1 29
    jp nc,l12ech        ;12d2 d2 ec 12

    ld a,(5664h)        ;12d5 3a 64 56
    and 0f3h            ;12d8 e6 f3
    ld b,02h            ;12da 06 02
    ld c,a              ;12dc 4f
    ld a,(nn)           ;12dd 3a c8 24
    jp l12e4h           ;12e0 c3 e4 12
l12e3h:
    add a,a             ;12e3 87
l12e4h:
    dec b               ;12e4 05
    jp p,l12e3h         ;12e5 f2 e3 12
    or c                ;12e8 b1
    ld (5664h),a        ;12e9 32 64 56
l12ech:
    ret                 ;12ec c9

ask_stop_bits:
    ;PRINT "Number of stop bits (1 or 2) ? ";
    ld bc,l1b90h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF N <> 1 THEN GOTO l130fh
    ld hl,(nn)
    dec hl
    ld a,h
    or l
    jp nz,l130fh

    ;REM User selected 1 stop bit

    ;POKE &H5664, (PEEK(&H5664) AND &H3F) OR &H40
    ld a,(5664h)
    and 3fh
    or 40h
    ld (5664h),a

    ;GOTO l1323h
    jp l1323h

l130fh:
    ;IF N <> 2 THEN GOTO l1323h
    ld hl,(nn)
    dec hl
    dec hl
    ld a,h
    or l
    jp nz,l1323h

    ;REM User selected 2 stop bits

    ;POKE &H5664, (PEEK(&H5664) AND &H3F) OR &HC0
    ld a,(5664h)
    and 3fh
    or 0c0h
    ld (5664h),a

l1323h:
    ;RETURN
    ret

ask_parity:
    ;PRINT "O(dd), E(ven), or N(o) parity ? ";
    ld bc,l1bb0h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H4F THEN GOTO l1345h
    ld a,(rr)
    cp 'O'
    jp nz,l1345h

    ;POKE &H5664, (PEEK(&H5664) AND &HCF) OR &H10
    ld a,(5664h)
    and 0cfh
    or 10h
    ld (5664h),a

    ;GOTO l1368h
    jp l1368h

l1345h:
    ;IF R <> &H45 THEN GOTO l1358h
    ld a,(rr)
    cp 'E'
    jp nz,l1358h

    ;POKE &H5664, PEEK(&H5664) OR &H30
    ld a,(5664h)
    or 30h
    ld (5664h),a

    ;GOTO l1368h
    jp l1368h

l1358h:
    ;IF R <> &H4E THEN GOTO l1368h
    ld a,(rr)
    cp 'N'
    jp nz,l1368h

    ;POKE &H5664, PEEK(5664h) AND &HEF
    ld a,(5664h)
    and 0efh
    ld (5664h),a

l1368h:
    ;RETURN
    ret

ask_baud_rate:
    ;PRINT
    call print_eol

    ;PRINT "110, 300, 1200, 4800, 9600, or 19200 baud ? ";
    ld bc,l1bd1h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF N <> 110 THEN GOTO l138ch
    ld bc,-110
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l138ch

    ;REM User selected 110 baud

    ;POKE &H5665h, &H22
    ld hl,5665h
    ld (hl),22h

    ;GOTO l13edh
    jp l13edh

l138ch:
    ;IF N <> 300 THEN GOTO l13a0h
    ld bc,-300
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l13a0h

    ;REM User selected 300 baud

    ;POKE &H5665h, &H55
    ld hl,5665h
    ld (hl),55h

    ;GOTO l13edh
    jp l13edh

l13a0h:
    ;IF N <> 1200 THEN GOTO l13b4h
    ld bc,-1200
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l13b4h

    ;POKE &H5665h, &H77
    ld hl,5665h
    ld (hl),77h

    ;GOTO l13edh
    jp l13edh

l13b4h:
    ;IF N <> 4800 THEN GOTO l13c8h
    ld bc,-4800
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l13c8h

    ;POKE &H5665h, &HCC
    ld hl,5665h
    ld (hl),0cch

    ;GOTO l13edh
    jp l13edh

l13c8h:
    ;IF N <> 9600 THEN GOTO l13dch
    ld bc,-9600
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l13dch

    ;POKE &H5665h, &HEE
    ld hl,5665h
    ld (hl),0eeh

    ;GOTO l13edh
    jp l13edh

l13dch:
    ;IF N <> 19200 THEN GOTO l13edh
    ld bc,-19200
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l13edh

    ;POKE &H5665h, &HFF
    ld hl,5665h
    ld (hl),0ffh

l13edh:
    ;RETURN
    ret

l13eeh:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call print_eol

    ;PRINT "RS232 Characteristics."
    ld bc,l1bfeh
    call print_str_eol

    ;PRINT "----- ----------------"
    ld bc,l1c15h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 1.  Character size :<tab><tab>";
    ld bc,l1c2ch
    call print_str

    ;PRINT CHR$(&H35+((PEEK(&H6554) AND &H0C) SHR 2));
    ld a,(5664h)        ;1409 3a 64 56
    and 0ch             ;140c e6 0c
    ld l,a              ;140e 6f
    ld c,06h            ;140f 0e 06
    ld h,00h            ;1411 26 00
    jp l1417h           ;1413 c3 17 14
l1416h:
    add hl,hl           ;1416 29
l1417h:
    dec c               ;1417 0d
    jp p,l1416h         ;1418 f2 16 14
    ld a,h              ;141b 7c
    add a,'5'           ;141c c6 35
    ld c,a              ;141e 4f
    call print_char     ;141f cd 6b 01

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT " 2.  Number of stop bits :<tab>";
    ld bc,l1c44h
    call print_str

    ;IF (PEEK(&H5664) AND &H40) <> &H40 THEN GOTO l1441h
    ld a,(5664h)
    and 0c0h
    ld (l3028h),a
    cp 40h
    jp nz,l1441h

    ld hl,l1c60h        ;143b 21 60 1c
    jp l1460h           ;143e c3 60 14

l1441h:
    ld a,(l3028h)       ;1441 3a 28 30
    cp 80h              ;1444 fe 80
    jp nz,l144fh        ;1446 c2 4f 14
    ld hl,l1c62h        ;1449 21 62 1c
    jp l1460h           ;144c c3 60 14

l144fh:
    ld a,(l3028h)       ;144f 3a 28 30
    cp 0c0h             ;1452 fe c0
    jp nz,l145dh        ;1454 c2 5d 14
    ld hl,l1c66h        ;1457 21 66 1c
    jp l1460h           ;145a c3 60 14

l145dh:
    ld hl,l1c68h        ;145d 21 68 1c
l1460h:
    ld b,h              ;1460 44
    ld c,l              ;1461 4d
    call print_str_eol  ;1462 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT " 3.  Parity :<tab><tab><tab>";
    ld bc,l1c72h
    call print_str

    ld a,(5664h)        ;146e 3a 64 56
    and 10h             ;1471 e6 10
    jp nz,l147ch        ;1473 c2 7c 14
    ld hl,l1c83h        ;1476 21 83 1c
    jp l149fh           ;1479 c3 9f 14

l147ch:
    ld a,(5664h)        ;147c 3a 64 56
    and 30h             ;147f e6 30
    cp 30h              ;1481 fe 30
    jp nz,l148ch        ;1483 c2 8c 14
    ld hl,l1c88h        ;1486 21 88 1c
    jp l149fh           ;1489 c3 9f 14

l148ch:
    ld a,(5664h)        ;148c 3a 64 56
    and 30h             ;148f e6 30
    cp 10h              ;1491 fe 10
    jp nz,l149ch        ;1493 c2 9c 14
    ld hl,l1c8dh        ;1496 21 8d 1c
    jp l149fh           ;1499 c3 9f 14

l149ch:
    ld hl,l1c92h        ;149c 21 92 1c
l149fh:
    ld b,h              ;149f 44
    ld c,l              ;14a0 4d
    call print_str_eol  ;14a1 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT " 4.  Baud rate :<tab><tab>";
    ld bc,l1c97h
    call print_str

    ld a,(5665h)        ;14ad 3a 65 56
    cp 22h              ;14b0 fe 22
    jp nz,l14bbh        ;14b2 c2 bb 14
    ld hl,l1caah        ;14b5 21 aa 1c
    jp l1504h           ;14b8 c3 04 15

l14bbh:
    ld a,(5665h)        ;14bb 3a 65 56
    cp 55h              ;14be fe 55
    jp nz,l14c9h        ;14c0 c2 c9 14
    ld hl,l1cb0h        ;14c3 21 b0 1c
    jp l1504h           ;14c6 c3 04 15

l14c9h:
    ld a,(5665h)        ;14c9 3a 65 56
    cp 77h              ;14cc fe 77
    jp nz,l14d7h        ;14ce c2 d7 14
    ld hl,l1cb6h        ;14d1 21 b6 1c
    jp l1504h           ;14d4 c3 04 15

l14d7h:
    ld a,(5665h)        ;14d7 3a 65 56
    cp 0cch             ;14da fe cc
    jp nz,l14e5h        ;14dc c2 e5 14
    ld hl,l1cbch        ;14df 21 bc 1c
    jp l1504h           ;14e2 c3 04 15

l14e5h:
    ld a,(5665h)        ;14e5 3a 65 56
    cp 0eeh             ;14e8 fe ee
    jp nz,l14f3h        ;14ea c2 f3 14
    ld hl,l1cc2h        ;14ed 21 c2 1c
    jp l1504h           ;14f0 c3 04 15

l14f3h:
    ld a,(5665h)        ;14f3 3a 65 56
    cp 0ffh             ;14f6 fe ff
    jp nz,l1501h        ;14f8 c2 01 15
    ld hl,l1cc8h        ;14fb 21 c8 1c
    jp l1504h           ;14fe c3 04 15

l1501h:
    ld hl,l1cceh        ;1501 21 ce 1c
l1504h:
    ld b,h              ;1504 44
    ld c,l              ;1505 4d
    call print_str_eol  ;1506 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT "Alter which characteristic ? ";
    ld bc,l1cd4h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF N <> 0 THEN GOTO l1521h
    ld hl,(nn)          ;1518 2a c8 24
    ld a,l              ;151b 7d
    or h                ;151c b4
    jp nz,l1521h        ;151d c2 21 15

    ret                 ;1520 c9

l1521h:
    ;IF (N-1) <> 0 THEN GOTO l1530h
    ld hl,(nn)          ;1521 2a c8 24
    dec hl              ;1524 2b
    ld a,h              ;1525 7c
    or l                ;1526 b5
    jp nz,l1530h        ;1527 c2 30 15

    call ask_char_size  ;152a cd a9 12
    jp l1560h           ;152d c3 60 15

l1530h:
    ;IF (N-2) <> 0 THEN GOTO l1540h
    ld hl,(nn)          ;1530 2a c8 24
    dec hl              ;1533 2b
    dec hl              ;1534 2b
    ld a,h              ;1535 7c
    or l                ;1536 b5
    jp nz,l1540h        ;1537 c2 40 15

    call ask_stop_bits  ;153a cd ed 12
    jp l1560h           ;153d c3 60 15

l1540h:
    ;IF (N-3) <> 0 THEN GOTO l1551h
    ld hl,(nn)          ;1540 2a c8 24
    dec hl              ;1543 2b
    dec hl              ;1544 2b
    dec hl              ;1545 2b
    ld a,h              ;1546 7c
    or l                ;1547 b5
    jp nz,l1551h        ;1548 c2 51 15

    call ask_parity     ;154b cd 24 13
    jp l1560h           ;154e c3 60 15

l1551h:
    ;IF (N-4) <> 0 THEN GOTO l1560h
    ld bc,-4            ;1551 01 fc ff
    ld hl,(nn)          ;1554 2a c8 24
    add hl,bc           ;1557 09
    ld a,h              ;1558 7c
    or l                ;1559 b5
    jp nz,l1560h        ;155a c2 60 15

    call ask_baud_rate  ;155d cd 69 13

l1560h:
    ;GOTO l13eeh
    jp l13eeh           ;1560 c3 ee 13

    ret                 ;1563 c9

sub_1564h:
    jp l1697h           ;1564 c3 97 16

sub_1567h:
    ;PRINT
    call print_eol

    ;PRINT "T(TY: -- RS232 printer";
    ld bc,l1cf2h
    call print_str_eol

    ;PRINT "C(RT: -- PET screen";
    ld bc,l1d09h
    call print_str_eol

    ;PRINT "L(PT: -- PET IEEE printer";
    ld bc,l1d1dh
    call print_str_eol

    ;PRINT "U(L1: -- ASCII IEEE printer"
    ld bc,l1d37h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Which list device (T, C, L or U) ? ";
    ld bc,l1d53h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H54 THEN GOTO l15a4h
    ld a,(rr)
    cp 'T'
    jp nz,l15a4h

    ;REM User selected 'T' for T(TY: -- RS232 printer

    ;POKE &H5660, PEEK(&H5660) AND &H3F
    ld a,(5660h)
    and 3fh
    ld (5660h),a

    ;GOTO l15e0h
    jp l15e0h

l15a4h:
    ;IF R <> &H43 THEN GOTO l15b9h
    ld a,(rr)
    cp 'C'
    jp nz,l15b9h

    ;REM User selected 'C' for C(RT: -- PET screen

    ;POKE &H5660, (PEEK(&H5660) AND &H3F) OR &H40
    ld a,(5660h)
    and 3fh
    or 40h
    ld (5660h),a

    ;GOTO l15e0h
    jp l15e0h

l15b9h:
    ;IF R <> &H4C THEN GOTO l15ceh
    ld a,(rr)
    cp 'L'
    jp nz,l15ceh

    ;REM User selected 'L' for L(PT: -- PET IEEE printer

    ;POKE &H5660, (PEEK(&H5660) AND &H3F) OR &H80
    ld a,(5660h)
    and 3fh
    or 80h
    ld (5660h),a

    ;GOTO l15e0h
    jp l15e0h

l15ceh:
    ;IF R <> &H55 THEN GOTO l15e0h
    ld a,(rr)
    cp 'U'
    jp nz,l15e0h

    ;REM User selected 'U' for U(L1: -- ASCII IEEE printer

    ;POKE &H5660, (PEEK(&H5660) AND &H3F) OR &HC0
    ld a,(5660h)
    and 3fh
    or 0c0h
    ld (5660h),a

l15e0h:
    ;RETURN
    ret

sub_15e1h:
    ;PRINT "T(TY:) or P(TR:) ? ";
    ld bc,l1d77h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H54 THEN GOTO l1600h
    ld a,(rr)
    cp 'T'
    jp nz,l1600h

    ;REM User selected 'T' for T(TY:)

    ;POKE &H5660, PEEK(&H5660) AND &HF3
    ld a,(5660h)
    and 0f3h
    ld (5660h),a

    ;GOTO l1612h
    jp l1612h

l1600h:
    ;IF R <> &H50 THEN GOTO l1612h
    ld a,(rr)
    cp 'P'
    jp nz,l1612h

    ;REM User selected 'P' for P(TR:)

    ;POKE &H5660, (PEEK(&H5660) AND &HF3) OR &H04
    ld a,(5660h)
    and 0f3h
    or 04h
    ld (5660h),a

l1612h:
    ;RETURN
    ret

sub_1613h:
    ;PRINT "T(TY:) or P(TP:) ? ";
    ld bc,l1d8bh
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H54 THEN GOTO l1632h
    ld a,(rr)           ;161f 3a cc 24
    cp 'T'              ;1622 fe 54
    jp nz,l1632h        ;1624 c2 32 16

    ;POKE &H5660, PEEK(&H5660) AND &HCF
    ld a,(5660h)
    and 0cfh
    ld (5660h),a

    ;GOTO l1644h
    jp l1644h

l1632h:
    ;IF R <> &H50 THEN GOTO l1644h
    ld a,(rr)
    cp 'P'
    jp nz,l1644h

    ;POKE &H5660, (PEEK(&H5660) AND &HCF) OR &H10
    ld a,(5660h)
    and 0cfh
    or 10h
    ld (5660h),a

l1644h:
    ;RETURN
    ret

sub_1645h:
    ;PRINT
    call print_eol

    ;PRINT "3 = 3022 or 3023 or 4022 or 4023";
    ld bc,l1d9fh
    call print_str_eol

    ;PRINT "8 = 8024";
    ld bc,l1dc0h
    call print_str_eol

    ;PRINT "D = 8026 or 8027 (Daisywheel)"
    ld bc,l1dc9h
    call print_str_eol
    call print_eol

    ;PRINT "Which type of printer (3, 8, or D) ? ";
    ld bc,l1de7h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H33 THEN GOTO l1679h
    ld a,(rr)
    cp '3'
    jp nz,l1679h

    ;POKE &H566D, 0
    ld hl,566dh
    ld (hl),00h

    ;GOTO l1696h
    jp l1696h

l1679h:
    ;IF R <> &H38 THEN GOTO l1689h
    ld a,(rr)
    cp '8'
    jp nz,l1689h

    ;POKE &H566D, 2
    ld hl,566dh
    ld (hl),02h

    ;GOTO l1696h
    jp l1696h

l1689h:
    ;IF R <> &H44 THEN GOTO l1696h
    ld a,(rr)
    cp 'D'
    jp nz,l1696h

    ;POKE &H566D, 1
    ld hl,566dh
    ld (hl),01h

l1696h:
    ;RETURN
    ret

l1697h:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call print_eol

    ;PRINT "I/O Device Assignment."
    ld bc,l1e0dh
    call print_str_eol

    ;PRINT "--- ------ -----------"
    ld bc,l1e24h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 1.  PET Printer device # :<tab>";
    ld bc,l1e3bh
    call print_str

    ;PRINT PEEK(&H5661)
    ld a,(5661h)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT " 2.  ASCII list device # :<tab>";
    ld bc,l1e58h
    call print_str

    ;PRINT PEEK(&H5666)
    ld a,(5666h)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT " 3.  Reader device # :<tab><tab>";
    ld bc,l1e74h
    call print_str

    ;PRINT PEEK(&H5662)
    ld a,(5662h)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT " 4.  Punch device # :<tab><tab>";
    ld bc,l1e8dh
    call print_str

    ;PRINT PEEK(&H5663)
    ld a,(5663h)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT " 5.  Default LST: device :<tab>";
    ld bc,l1ea5h
    call print_str

    ld a,(5660h)        ;170e 3a 60 56
    and 0c0h            ;1711 e6 c0
    jp nz,l171ch        ;1713 c2 1c 17
    ld hl,l1ec1h        ;1716 21 c1 1e
    jp l173fh           ;1719 c3 3f 17
l171ch:
    ld a,(5660h)        ;171c 3a 60 56
    and 0c0h            ;171f e6 c0
    cp 40h              ;1721 fe 40
    jp nz,l172ch        ;1723 c2 2c 17
    ld hl,l1ec6h        ;1726 21 c6 1e
    jp l173fh           ;1729 c3 3f 17
l172ch:
    ld a,(5660h)        ;172c 3a 60 56
    and 0c0h            ;172f e6 c0
    cp 80h              ;1731 fe 80
    jp nz,l173ch        ;1733 c2 3c 17
    ld hl,l1ecbh        ;1736 21 cb 1e
    jp l173fh           ;1739 c3 3f 17
l173ch:
    ld hl,l1ed0h        ;173c 21 d0 1e
l173fh:
    ld b,h              ;173f 44
    ld c,l              ;1740 4d
    call print_str_eol  ;1741 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT " 6.  Default RDR: device :<tab>";
    ld bc,l1ed5h
    call print_str

    ld a,(5660h)        ;174d 3a 60 56
    and 0ch             ;1750 e6 0c
    jp nz,l175bh        ;1752 c2 5b 17
    ld hl,l1ef1h        ;1755 21 f1 1e
    jp l175eh           ;1758 c3 5e 17
l175bh:
    ld hl,l1ef6h        ;175b 21 f6 1e
l175eh:
    ld b,h              ;175e 44
    ld c,l              ;175f 4d
    call print_str_eol  ;1760 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT " 7.  Default PUN: device :<tab>";
    ld bc,l1efbh
    call print_str

    ld a,(5660h)        ;176c 3a 60 56
    and 30h             ;176f e6 30
    jp nz,l177ah        ;1771 c2 7a 17
    ld hl,l1f17h        ;1774 21 17 1f
    jp l177dh           ;1777 c3 7d 17
l177ah:
    ld hl,l1f1ch        ;177a 21 1c 1f
l177dh:
    ld b,h              ;177d 44
    ld c,l              ;177e 4d
    call print_str_eol  ;177f cd a9 01

    ;PRINT
    call print_eol

    ;PRINT " 8.  PET Printer type :   <tab>";
    ld bc,l1f21h
    call print_str

    ld a,(566dh)        ;178b 3a 6d 56
    or a                ;178e b7
    jp nz,l1798h        ;178f c2 98 17
    ld hl,l1f3dh        ;1792 21 3d 1f
    jp l17b7h           ;1795 c3 b7 17
l1798h:
    ld a,(566dh)        ;1798 3a 6d 56
    cp 01h              ;179b fe 01
    jp nz,l17a6h        ;179d c2 a6 17
    ld hl,l1f47h        ;17a0 21 47 1f
    jp l17b7h           ;17a3 c3 b7 17
l17a6h:
    ld a,(566dh)        ;17a6 3a 6d 56
    cp 02h              ;17a9 fe 02
    jp nz,l17b4h        ;17ab c2 b4 17
    ld hl,l1f51h        ;17ae 21 51 1f
    jp l17b7h           ;17b1 c3 b7 17
l17b4h:
    ld hl,l1f56h        ;17b4 21 56 1f
l17b7h:
    ld b,h              ;17b7 44
    ld c,l              ;17b8 4d
    call print_str_eol  ;17b9 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Alter which characteristic (1-8) ? ";
    ld bc,l1f5bh
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H0D THEN GOTO l17d7h
    ld a,(rr)
    cp cr
    jp nz,l17d7h

    ;RETURN
    ret

l17d7h:
    ;IF (N-5) <> 0 THEN GOTO l17e9h
    ld bc,-5            ;17d7 01 fb ff
    ld hl,(nn)          ;17da 2a c8 24
    add hl,bc           ;17dd 09
    ld a,h              ;17de 7c
    or l                ;17df b5
    jp nz,l17e9h        ;17e0 c2 e9 17

    call sub_1567h      ;17e3 cd 67 15
    jp l1872h           ;17e6 c3 72 18

l17e9h:
    ;IF (N-6) <> 0 THEN GOTO l15e1h
    ld bc,-6            ;17e9 01 fa ff
    ld hl,(nn)          ;17ec 2a c8 24
    add hl,bc           ;17ef 09
    ld a,h              ;17f0 7c
    or l                ;17f1 b5
    jp nz,l17fbh        ;17f2 c2 fb 17

    call sub_15e1h      ;17f5 cd e1 15
    jp l1872h           ;17f8 c3 72 18

l17fbh:
    ;IF (N-7) <> 0 THEN GOTO l180dh
    ld bc,-7            ;17fb 01 f9 ff
    ld hl,(nn)          ;17fe 2a c8 24
    add hl,bc           ;1801 09
    ld a,h              ;1802 7c
    or l                ;1803 b5
    jp nz,l180dh        ;1804 c2 0d 18

    call sub_1613h      ;1807 cd 13 16
    jp l1872h           ;180a c3 72 18

l180dh:
    ;IF (N-8) <> 0 THEN GOTO l180dh
    ld bc,-8            ;180d 01 f8 ff
    ld hl,(nn)          ;1810 2a c8 24
    add hl,bc           ;1813 09
    ld a,h              ;1814 7c
    or l                ;1815 b5
    jp nz,l181fh        ;1816 c2 1f 18

    call sub_1645h      ;1819 cd 45 16
    jp l1872h           ;181c c3 72 18

l181fh:
    ;l3029h = N
    ld a,(nn)           ;181f 3a c8 24
    ld (l3029h),a       ;1822 32 29 30

    ;PRINT "New device # ? ";
    ld bc,l1f7fh
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF l3029h <> 1 THEN GOTO l1842h
    ld a,(l3029h)
    cp 01h
    jp nz,l1842h

    ;REM User selected 1. PET printer device #

    ;POKE &H5661, N
    ld a,(nn)
    ld (5661h),a

    ;GOTO l1872h
    jp l1872h

l1842h:
    ;IF l3029h <> 2 THEN GOTO l1853h
    ld a,(l3029h)
    cp 02h
    jp nz,l1853h

    ;REM User selected 2. ASCII list device #

    ;POKE &H5666, N
    ld a,(nn)
    ld (5666h),a

    ;GOTO l1872h
    jp l1872h

l1853h:
    ;IF l3029h <> 3 THEN GOTO l1853h
    ld a,(l3029h)
    cp 03h
    jp nz,l1864h

    ;REM User selected 3. Reader device #

    ;POKE &H5662, N
    ld a,(nn)
    ld (5662h),a

    ;GOTO l1872h
    jp l1872h

l1864h:
    ;IF l3029h <> 4 THEN GOTO l1872h
    ld a,(l3029h)
    cp 04h
    jp nz,l1872h

    ;REM User selected 4.  Punch device #

    ;POKE &H5663, N
    ld a,(nn)
    ld (5663h),a

l1872h:
    ;GOTO l1697h
    jp l1697h

    ;RETURN
    ret

sub_1876h:
    ;GOTO l1a46h
    jp l1a46h

sub_1879h:
    ;PRINT "Number of columns (1, 2 or 4) ? ";
    ld bc,l1f8fh
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF (N-1) <> 0 THEN GOTO l1896h
    ld hl,(nn)
    dec hl
    ld a,h
    or l
    jp nz,l1896h

    ;POKE &H44b2, 0
    ld hl,44b2h         ;188e 21 b2 44
    ld (hl),00h         ;1891 36 00

    ;GOTO l18b9h
    jp l18b9h

l1896h:
    ;IF (N-2) <> 0 THEN GOTO l18a8h
    ld hl,(nn)
    dec hl
    dec hl
    ld a,h
    or l
    jp nz,l18a8h

    ;POKE &H44b2, 1
    ld hl,44b2h         ;18a0 21 b2 44
    ld (hl),01h         ;18a3 36 01

    ;GOTO l18b9h
    jp l18b9h

l18a8h:
    ;IF (N-3) <> 0 THEN GOTO l18b9h
    ld bc,-4
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l18b9h

    ;POKE &H44b2, 3
    ld hl,44b2h         ;18b4 21 b2 44
    ld (hl),03h         ;18b7 36 03

l18b9h:
    ;RETURN
    ret

sub_18bah:
    ld a,(5667h)        ;18ba 3a 67 56
    xor 80h             ;18bd ee 80
    ld (5667h),a        ;18bf 32 67 56
    ret                 ;18c2 c9

sub_18c3h:
    ;PRINT "Screen type A(DM3A), H(Z1500), or T(V912) ? ";
    ld bc,l1fb0h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H41 THEN GOTO l18e2h
    ld a,(rr)
    cp 'A'
    jp nz,l18e2h

    ;POKE &H5667, PEEK(&H5667) AND &H80
    ld a,(5667h)        ;18d7 3a 67 56
    and 80h             ;18da e6 80
    ld (5667h),a        ;18dc 32 67 56

    ;GOTO l18f4h
    jp l18f4h           ;18df c3 f4 18

l18e2h:
    ;IF R <> &H54 THEN GOTO l18f4h
    ld a,(rr)
    cp 'T'
    jp nz,l18f4h

    ;POKE &H5667, PEEK(&H5667) AND &H80 OR &H02
    ld a,(5667h)        ;18ea 3a 67 56
    and 80h             ;18ed e6 80
    or 02h              ;18ef f6 02
    ld (5667h),a        ;18f1 32 67 56

l18f4h:
    ;IF H <> &H48 THEN GOTO l1997h
    ld a,(rr)
    cp 'H'
    jp nz,l1997h

l18fch:
    ;PRINT "Lead-in code E(scape) or T(ilde) ? ";
    ld bc,l1fddh
    call print_str

    ;PRINT
    call readline

    ;GOSUB readline
    call print_eol

    ;IF R <> &H45 THEN GOTO l1918h
    ld a,(rr)
    cp 'E'
    jp nz,l1918h

    ;POKE &H5668, &H1b
    ld hl,5668h         ;1910 21 68 56
    ld (hl),1bh         ;1913 36 1b

    ;GOTO l192bh
    jp l192bh           ;1915 c3 2b 19

l1918h:
    ;IF R <> &H54 THEN GOTO l1928h
    ld a,(rr)
    cp 'T'
    jp nz,l1928h

    ;POKE &H5668, &H7e
    ld hl,5668h         ;1920 21 68 56
    ld (hl),7eh         ;1923 36 7e

    ;GOTO l192bh
    jp l192bh           ;1925 c3 2b 19

l1928h:
    ;GOTO l18fch
    jp l18fch           ;1928 c3 fc 18

l192bh:
    ;POKE &H5667, PEEK(&H5667) AND &H80 OR &H01
    ld a,(5667h)        ;192b 3a 67 56
    and 80h             ;192e e6 80
    or 01h              ;1930 f6 01
    ld (5667h),a        ;1932 32 67 56

    ld hl,566ah         ;1935 21 6a 56
    ld (hl),00h         ;1938 36 00
    inc hl              ;193a 23
    ld (hl),00h         ;193b 36 00
    dec hl              ;193d 2b
    dec hl              ;193e 2b
    ld (hl),01h         ;193f 36 01
    ld hl,5680h         ;1941 21 80 56
    ld (hl),8bh         ;1944 36 8b
    inc hl              ;1946 23
    ld (hl),0bh         ;1947 36 0b
    inc hl              ;1949 23
    ld (hl),8ch         ;194a 36 8c
    inc hl              ;194c 23
    ld (hl),0ch         ;194d 36 0c
    inc hl              ;194f 23
    ld (hl),8fh         ;1950 36 8f
    inc hl              ;1952 23
    ld (hl),13h         ;1953 36 13
    inc hl              ;1955 23
    ld (hl),91h         ;1956 36 91
    inc hl              ;1958 23
    ld (hl),1bh         ;1959 36 1b
    inc hl              ;195b 23
    ld (hl),92h         ;195c 36 92
    inc hl              ;195e 23
    ld (hl),1eh         ;195f 36 1e
    inc hl              ;1961 23
    ld (hl),93h         ;1962 36 93
    inc hl              ;1964 23
    ld (hl),12h         ;1965 36 12
    inc hl              ;1967 23
    ld (hl),97h         ;1968 36 97
    inc hl              ;196a 23
    ld (hl),14h         ;196b 36 14
    inc hl              ;196d 23
    ld (hl),98h         ;196e 36 98
    inc hl              ;1970 23
    ld (hl),14h         ;1971 36 14
    inc hl              ;1973 23
    ld (hl),9ah         ;1974 36 9a
    inc hl              ;1976 23
    ld (hl),11h         ;1977 36 11
    inc hl              ;1979 23
    ld (hl),9ch         ;197a 36 9c
    inc hl              ;197c 23
    ld (hl),1ah         ;197d 36 1a
    inc hl              ;197f 23
    ld (hl),9dh         ;1980 36 9d
    inc hl              ;1982 23
    ld (hl),1ah         ;1983 36 1a
    inc hl              ;1985 23
    ld (hl),99h         ;1986 36 99
    inc hl              ;1988 23
    ld (hl),00h         ;1989 36 00
    inc hl              ;198b 23
    ld (hl),9fh         ;198c 36 9f
    inc hl              ;198e 23
    ld (hl),00h         ;198f 36 00
    inc hl              ;1991 23
    ld (hl),00h         ;1992 36 00
    jp l1a2ah           ;1994 c3 2a 1a

l1997h:
    ld hl,5668h         ;1997 21 68 56
    ld (hl),1bh         ;199a 36 1b
    inc hl              ;199c 23
    inc hl              ;199d 23
    ld (hl),20h         ;199e 36 20
    inc hl              ;19a0 23
    ld (hl),20h         ;19a1 36 20
    dec hl              ;19a3 2b
    dec hl              ;19a4 2b
    ld (hl),00h         ;19a5 36 00
    ld hl,5680h         ;19a7 21 80 56
    ld (hl),0b1h        ;19aa 36 b1
    inc hl              ;19ac 23
    ld (hl),04h         ;19ad 36 04
    inc hl              ;19af 23
    ld (hl),0b2h        ;19b0 36 b2
    inc hl              ;19b2 23
    ld (hl),05h         ;19b3 36 05
    inc hl              ;19b5 23
    ld (hl),0b3h        ;19b6 36 b3
    inc hl              ;19b8 23
    ld (hl),06h         ;19b9 36 06
    inc hl              ;19bb 23
    ld (hl),0eah        ;19bc 36 ea
    inc hl              ;19be 23
    ld (hl),0eh         ;19bf 36 0e
    inc hl              ;19c1 23
    ld (hl),0ebh        ;19c2 36 eb
    inc hl              ;19c4 23
    ld (hl),0fh         ;19c5 36 0f
    inc hl              ;19c7 23
    ld (hl),0d1h        ;19c8 36 d1
    inc hl              ;19ca 23
    ld (hl),1ch         ;19cb 36 1c
    inc hl              ;19cd 23
    ld (hl),0d7h        ;19ce 36 d7
    inc hl              ;19d0 23
    ld (hl),1dh         ;19d1 36 1d
    inc hl              ;19d3 23
    ld (hl),0c5h        ;19d4 36 c5
    inc hl              ;19d6 23
    ld (hl),11h         ;19d7 36 11
    inc hl              ;19d9 23
    ld (hl),0d2h        ;19da 36 d2
    inc hl              ;19dc 23
    ld (hl),12h         ;19dd 36 12
    inc hl              ;19df 23
    ld (hl),0d4h        ;19e0 36 d4
    inc hl              ;19e2 23
    ld (hl),13h         ;19e3 36 13
    inc hl              ;19e5 23
    ld (hl),0f4h        ;19e6 36 f4
    inc hl              ;19e8 23
    ld (hl),13h         ;19e9 36 13
    inc hl              ;19eb 23
    ld (hl),0d9h        ;19ec 36 d9
    inc hl              ;19ee 23
    ld (hl),14h         ;19ef 36 14
    inc hl              ;19f1 23
    ld (hl),0f9h        ;19f2 36 f9
    inc hl              ;19f4 23
    ld (hl),14h         ;19f5 36 14
    inc hl              ;19f7 23
    ld (hl),0abh        ;19f8 36 ab
    inc hl              ;19fa 23
    ld (hl),1ah         ;19fb 36 1a
    inc hl              ;19fd 23
    ld (hl),0aah        ;19fe 36 aa
    inc hl              ;1a00 23
    ld (hl),1ah         ;1a01 36 1a
    inc hl              ;1a03 23
    ld (hl),0bah        ;1a04 36 ba
    inc hl              ;1a06 23
    ld (hl),1ah         ;1a07 36 1a
    inc hl              ;1a09 23
    ld (hl),0bbh        ;1a0a 36 bb
    inc hl              ;1a0c 23
    ld (hl),1ah         ;1a0d 36 1a
    inc hl              ;1a0f 23
    ld (hl),0dah        ;1a10 36 da
    inc hl              ;1a12 23
    ld (hl),1ah         ;1a13 36 1a
    inc hl              ;1a15 23
    ld (hl),0bdh        ;1a16 36 bd
    inc hl              ;1a18 23
    ld (hl),1bh         ;1a19 36 1b
    inc hl              ;1a1b 23
    ld (hl),0a8h        ;1a1c 36 a8
    inc hl              ;1a1e 23
    ld (hl),00h         ;1a1f 36 00
    inc hl              ;1a21 23
    ld (hl),0a9h        ;1a22 36 a9
    inc hl              ;1a24 23
    ld (hl),00h         ;1a25 36 00
    inc hl              ;1a27 23
    ld (hl),00h         ;1a28 36 00
l1a2ah:
    ret                 ;1a2a c9

sub_1a2bh:
    ;PRINT "New clock frequency ? ";
    ld bc,l2001h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF N <> 0 THEN GOTO l1a45h
    ld hl,(nn)          ;1a37 2a c8 24
    ld a,l              ;1a3a 7d
    or h                ;1a3b b4
    jp z,l1a45h         ;1a3c ca 45 1a

    ;POKE &H6005, N
    ld a,(nn)           ;1a3f 3a c8 24
    ld (6005h),a        ;1a42 32 05 60

l1a45h:
    ret                 ;1a45 c9

l1a46h:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call print_eol

    ;PRINT "Pet terminal parameters";
    ld bc,l2018h
    call print_str_eol

    ;PRINT "--- -------- ----------"
    ld bc,l2030h
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "1.  Columns in DIR listing :  ";
    ld bc,l2048h
    call print_str

    ld a,(44b2h)        ;1a61 3a b2 44
    or a                ;1a64 b7
    jp nz,l1a6eh        ;1a65 c2 6e 1a
    ld hl,l2067h        ;1a68 21 67 20
    jp l1a7fh           ;1a6b c3 7f 1a
l1a6eh:
    ld a,(44b2h)        ;1a6e 3a b2 44
    cp 01h              ;1a71 fe 01
    jp nz,l1a7ch        ;1a73 c2 7c 1a
    ld hl,l2067h+2      ;1a76 21 69 20
    jp l1a7fh           ;1a79 c3 7f 1a
l1a7ch:
    ld hl,206bh         ;1a7c 21 6b 20
l1a7fh:
    ld b,h              ;1a7f 44
    ld c,l              ;1a80 4d
    call print_str_eol  ;1a81 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT "2.  CRT in upper case mode :  ";
    ld bc,l206dh
    call print_str

    ld a,(5667h)        ;1a8d 3a 67 56
    and 80h             ;1a90 e6 80
    jp z,l1a9bh         ;1a92 ca 9b 1a
    ld hl,l208ch        ;1a95 21 8c 20
    jp l1a9eh           ;1a98 c3 9e 1a
l1a9bh:
    ld hl,l2090h        ;1a9b 21 90 20
l1a9eh:
    ld b,h              ;1a9e 44
    ld c,l              ;1a9f 4d
    call print_str_eol  ;1aa0 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT "3.  CRT terminal emulation :  ";
    ld bc,l2093h
    call print_str

    ld a,(5667h)        ;1aac 3a 67 56
    and 7fh             ;1aaf e6 7f
    jp nz,l1abah        ;1ab1 c2 ba 1a
    ld hl,l20b2h        ;1ab4 21 b2 20
    jp l1af9h           ;1ab7 c3 f9 1a
l1abah:
    ld a,(5667h)        ;1aba 3a 67 56
    and 7fh             ;1abd e6 7f
    cp 02h              ;1abf fe 02
    jp nz,l1acah        ;1ac1 c2 ca 1a
    ld hl,l20b8h        ;1ac4 21 b8 20
    jp l1af9h           ;1ac7 c3 f9 1a
l1acah:
    ld a,(5667h)        ;1aca 3a 67 56
    and 7fh             ;1acd e6 7f
    cp 01h              ;1acf fe 01
    jp nz,l1af6h        ;1ad1 c2 f6 1a
    ld a,(5668h)        ;1ad4 3a 68 56
    cp 1bh              ;1ad7 fe 1b
    jp nz,l1ae2h        ;1ad9 c2 e2 1a
    ld hl,l20beh        ;1adc 21 be 20
    jp l1af3h           ;1adf c3 f3 1a
l1ae2h:
    ld a,(5668h)        ;1ae2 3a 68 56
    cp 7eh              ;1ae5 fe 7e
    jp nz,l1af0h        ;1ae7 c2 f0 1a
    ld hl,l20dah        ;1aea 21 da 20
    jp l1af3h           ;1aed c3 f3 1a
l1af0h:
    ld hl,l20f5h        ;1af0 21 f5 20
l1af3h:
    jp l1af9h           ;1af3 c3 f9 1a
l1af6h:
    ld hl,l20fch        ;1af6 21 fc 20
l1af9h:
    ld b,h              ;1af9 44
    ld c,l              ;1afa 4d
    call print_str_eol  ;1afb cd a9 01

    ;PRINT
    call print_eol

    ;PRINT "4.  Clock frequency (Hz) :    ";
    ld bc,l2103h
    call print_str

    ;PRINT PEEK(&H6005)
    ld a,(6005h)
    ld l,a
    rla
    sbc a,a
    ld b,a
    ld c,l
    call print_int
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Alter which (1-4) ? ";
    ld bc,l2122h
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H0D THEN GOTO l1b2dh
    ld a,(rr)
    cp cr
    jp nz,l1b2dh

    ;RETURN
    ret

l1b2dh:
    ;IF (N-1) <> 0 THEN GOTO l1b3ch
    ld hl,(nn)          ;1b2d 2a c8 24
    dec hl              ;1b30 2b
    ld a,h              ;1b31 7c
    or l                ;1b32 b5
    jp nz,l1b3ch        ;1b33 c2 3c 1b

    call sub_1879h      ;1b36 cd 79 18

    jp l1b6ch           ;1b39 c3 6c 1b

l1b3ch:
    ;IF (N-2) <> 0 THEN GOTO l1b4ch
    ld hl,(nn)          ;1b3c 2a c8 24
    dec hl              ;1b3f 2b
    dec hl              ;1b40 2b
    ld a,h              ;1b41 7c
    or l                ;1b42 b5
    jp nz,l1b4ch        ;1b43 c2 4c 1b

    call sub_18bah      ;1b46 cd ba 18

    jp l1b6ch           ;1b49 c3 6c 1b

l1b4ch:
    ;IF (N-3) <> 0 THEN GOTO l1b5dh
    ld hl,(nn)          ;1b4c 2a c8 24
    dec hl              ;1b4f 2b
    dec hl              ;1b50 2b
    dec hl              ;1b51 2b
    ld a,h              ;1b52 7c
    or l                ;1b53 b5
    jp nz,l1b5dh        ;1b54 c2 5d 1b

    call sub_18c3h      ;1b57 cd c3 18

    jp l1b6ch           ;1b5a c3 6c 1b

l1b5dh:
    ;IF (N-4) <> 0 THEN GOTO l1b6ch
    ld bc,-4            ;1b5d 01 fc ff
    ld hl,(nn)          ;1b60 2a c8 24
    add hl,bc           ;1b63 09
    ld a,h              ;1b64 7c
    or l                ;1b65 b5
    jp nz,l1b6ch        ;1b66 c2 6c 1b

    call sub_1a2bh      ;1b69 cd 2b 1a

l1b6ch:
    jp l1a46h           ;1b6c c3 46 1a

    ret                 ;1b6f c9

l1b70h:
    db 1fh
    db "New charater length (5 to 8) ? "

l1b90h:
    db 1fh
    db "Number of stop bits (1 or 2) ? "

l1bb0h:
    db 20h
    db "O(dd), E(ven), or N(o) parity ? "

l1bd1h:
    db 2ch
    db "110, 300, 1200, 4800, 9600, or 19200 baud ? "

l1bfeh:
    db 16h
    db "RS232 Characteristics."

l1c15h:
    db 16h
    db "----- ----------------"

l1c2ch:
    db 17h
    db " 1.  Character size :",09h,09h

l1c44h:
    db 1bh
    db " 2.  Number of stop bits :",09h

l1c60h:
    db 01h
    db "1"

l1c62h:
    db 03h
    db "1.5"

l1c66h:
    db 01h
    db "2"

l1c68h:
    db 09h
    db "undefined"

l1c72h:
    db 10h
    db " 3.  Parity :",09h,09h,09h

l1c83h:
    db 04h
    db "none"

l1c88h:
    db 04h
    db "even"

l1c8dh:
    db 04h
    db "odd "

l1c92h:
    db 04h
    db "    "

l1c97h:
    db 12h
    db " 4.  Baud rate :",09h,09h

l1caah:
    db 05h
    db "110  "

l1cb0h:
    db 05h
    db "300  "

l1cb6h:
    db 05h
    db "1200 "

l1cbch:
    db 05h
    db "4800 "

l1cc2h:
    db 05h
    db "9600 "

l1cc8h:
    db 05h
    db "19200"

l1cceh:
    db 05h
    db "     "

l1cd4h:
    db 1dh
    db "Alter which characteristic ? "

l1cf2h:
    db 16h
    db "T(TY: -- RS232 printer"

l1d09h:
    db 13h
    db "C(RT: -- PET screen"

l1d1dh:
    db 19h
    db "L(PT: -- PET IEEE printer"

l1d37h:
    db 1bh
    db "U(L1: -- ASCII IEEE printer"

l1d53h:
    db 23h
    db "Which list device (T, C, L or U) ? "

l1d77h:
    db 13h
    db "T(TY:) or P(TR:) ? "

l1d8bh:
    db 13h
    db "T(TY:) or P(TP:) ? "

l1d9fh:
    db 20h
    db "3 = 3022 or 3023 or 4022 or 4023"

l1dc0h:
    db 08h
    db "8 = 8024"

l1dc9h:
    db 1dh
    db "D = 8026 or 8027 (Daisywheel)"

l1de7h:
    db 25h
    db "Which type of printer (3, 8, or D) ? "

l1e0dh:
    db 16h
    db "I/O Device Assignment."

l1e24h:
    db 16h
    db "--- ------ -----------"

l1e3bh:
    db 1ch
    db " 1.  PET Printer device # :",09h

l1e58h:
    db 1bh
    db " 2.  ASCII list device # :",09h

l1e74h:
    db 18h
    db " 3.  Reader device # :",09h,09h

l1e8dh:
    db 17h
    db " 4.  Punch device # :",09h,09h

l1ea5h:
    db 1bh
    db " 5.  Default LST: device :",09h

l1ec1h:
    db 04h
    db "TTY:"

l1ec6h:
    db 04h
    db "CRT:"

l1ecbh:
    db 04h
    db "LPT:"

l1ed0h:
    db 04h
    db "   :"

l1ed5h:
    db 1bh
    db " 6.  Default RDR: device :",09h

l1ef1h:
    db 04h
    db "TTY:"

l1ef6h:
    db 04h
    db "PTR:"

l1efbh:
    db 1bh
    db " 7.  Default PUN: device :",09h

l1f17h:
    db 04h
    db "TTY:"

l1f1ch:
    db 04h
    db "PTP:"

l1f21h:
    db 1bh
    db " 8.  PET Printer type :   ",09h

l1f3dh:
    db 09h
    db "3022/4022"

l1f47h:
    db 09h
    db "8026/8027"

l1f51h:
    db 04h
    db "8024"

l1f56h:
    db 04h
    db "    "

l1f5bh:
    db 23h
    db "Alter which characteristic (1-8) ? "

l1f7fh:
    db 0fh
    db "New device # ? "

l1f8fh:
    db 20h
    db "Number of columns (1, 2 or 4) ? "

l1fb0h:
    db 2ch
    db "Screen type A(DM3A), H(Z1500), or T(V912) ? "

l1fddh:
    db 23h
    db "Lead-in code E(scape) or T(ilde) ? "

l2001h:
    db 16h
    db "New clock frequency ? "

l2018h:
    db 17h
    db "Pet terminal parameters"

l2030h:
    db 17h
    db "--- -------- ----------"

l2048h:
    db 1eh
    db "1.  Columns in DIR listing :  "


l2067h:
    db 01h
    db "1"

    db 01h
    db "2"

    db 01
    db "4"

l206dh:
    db 1eh
    db "2.  CRT in upper case mode :  "

l208ch:
    db 03h
    db "Yes"

l2090h:
    db 02h
    db "No"

l2093h:
    db 1eh
    db "3.  CRT terminal emulation :  "

l20b2h:
    db 05h
    db "ADM3A"

l20b8h:
    db 05h
    db "TV912"

l20beh:
    db 1bh
    db "HZ1500",09h,09h,09h,"(Lead-in = ESCAPE)"

l20dah:
    db 1ah
    db "HZ1500",09h,09h,09h,"(Lead-in = TILDE)"

l20f5h:
    db 06h
    db "      "

l20fch:
    db 06h
    db "      "

l2103h:
    db 1eh
    db "4.  Clock frequency (Hz) :    "

l2122h:
    db 14h
    db "Alter which (1-4) ? "

; Start of LOADSAV2.REL =====================================================

exsys:
;Execute a new CP/M system.  The buffer at 4000h contains a new
;CP/M system image (7168 bytes = CCP + BDOS + BIOS config + BIOS storage).
;Copy the new system into place and then jump to the BIOS to start it.
    ld bc,1c00h
    ld hl,4000h
    ld de,ccp_base
    ldir
    jp runcpm           ;Perform system init and then run CP/M

rdsys:
;Read the "CP/M" and "K" files from an IEEE-488 drive into memory.
    ld a,c
    ld (l2422h),a
    call dskdev         ;Get device address for a CP/M drive number
    ld e,00h
    push de
    call sub_221ch
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    ld hl,4000h
    ld bc,1c00h
    pop de
    or a
    ret nz
    push de
    call talk           ;Send TALK to an IEEE-488 device
l2168h:
    call rdieee         ;Read byte from an IEEE-488 device
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2168h
    call untalk         ;Send UNTALK to all IEEE-488 devices
    pop de
    push de
    call close          ;Close an open file on an IEEE-488 device
    pop de
    push de
    call sub_222eh
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    ld hl,6000h
    ld bc,0800h
    pop de
    or a
    ret nz
    push de
    call talk           ;Send TALK to an IEEE-488 device
l2195h:
    call rdieee         ;Read byte from an IEEE-488 device
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2195h
    call untalk         ;Send UNTALK to all IEEE-488 devices
    pop de
    call close          ;Close an open file on an IEEE-488 device
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    ret

cread_:
;Read CP/M image from a hard drive.
    call seldsk         ;Select disk drive
    ld de,4000h
    ld bc,0000h
cread2:
    call settrk         ;Set track number
    push bc
    ld bc,0000h
cread1:
    call setsec         ;Set sector number
    push bc
    push de
    call read           ;Read selected sector
    or a
    jr nz,cwrit3
    pop de
    ld bc,0080h
    ld hl,0080h
    ldir
    pop bc
    inc c
    ld a,c
    cp 40h
    jr nz,cread1
    pop bc
    inc c
    ld a,c
    cp 02h
    jr nz,cread2
    ret

cwrite_:
;Write CP/M image to a hard drive.
    call seldsk         ;Select disk drive
    ld hl,4000h
    ld bc,0000h
cwrit2:
    call settrk         ;Set track number
    push bc
    ld bc,0000h
cwrit1:
    call setsec         ;Set sector number
    push bc
    ld bc,0080h
    ld de,0080h
    ldir
    push hl
    call write          ;Write selected sector
    or a
    jr nz,cwrit3
    pop hl
    pop bc
    inc c
    ld a,c
    cp 40h
    jr nz,cwrit1
    pop bc
    inc c
    ld a,c
    cp 02h
    jr nz,cwrit2
    ret
cwrit3:
    pop hl
    pop hl
    pop hl
    jp l23b7h

sub_221ch:
;Open "CP/M" file on an IEEE-488 drive
    ld c,l2410h_len
    ld hl,l2410h        ;"0:CP/M"
    ld a,(l2422h)
    rra
    jp nc,open          ;Open a file on an IEEE-488 device
    ld hl,l2416h        ;"1:CP/M"
    jp open             ;Open a file on an IEEE-488 device

sub_222eh:
;Open "K" file on an IEEE-488 drive
    ld c,l241ch_len
    ld hl,l241ch        ;"0:K"
    ld a,(l2422h)
    rra
    jp nc,open          ;Open a file on an IEEE-488 device
    ld hl,l241fh        ;"1:K"
    jp open             ;Open a file on an IEEE-488 device

savesy:
;Read the CP/M system image from an IEEE-488 drive.
    ld a,c
    ld (l2422h),a
    call dskdev         ;Get device address for a CP/M drive number
    push de
    ld e,0fh
    ld hl,l2408h        ;"S0:*"
    ld a,(l2422h)
    rra
    jr nc,l2256h
    ld hl,l240ch        ;"S1:*"
l2256h:
    ld c,l2408h_len
    call open           ;Open a file on an IEEE-488 device
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    pop de
    cp 01h
    ret nz
    ld e,01h
    push de
    call sub_222eh
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    pop de
    or a
    ret nz
    push de
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,6000h
    ld bc,0800h
l2284h:
    ld a,(hl)
    call wrieee         ;Send byte to an IEEE-488 device
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2284h
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    pop de
    push de
    call close          ;Close an open file on an IEEE-488 device
    pop de
    push de
    call sub_221ch
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    pop de
    or a
    ret nz
    push de
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,4000h
    ld bc,1c00h
l22b1h:
    ld a,(hl)
    call wrieee         ;Send byte to an IEEE-488 device
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l22b1h
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    pop de
    call close          ;Close an open file on an IEEE-488 device
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    ret

format:
;Format an IEEE-488 drive for SoftBox use.
    ld a,c
    ld (l2422h),a
    call dskdev         ;Get device address for a CP/M drive number
    ld a,(l2422h)
    and 01h
    add a,'0'
    ld (l23e3h+1),a
    ld e,0fh
    ld c,l23e3h_len
    ld hl,l23e3h        ;"N0:CP/M V2.2 DISK,XX"
    call open           ;Open a file on an IEEE-488 device
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    or a
    ret nz
    ld a,(l2422h)
    call idrive         ;Initialize an IEEE-488 disk drive
    ld hl,4000h
    ld de,4001h
    ld bc,00ffh
    ld (hl),0e5h
    ldir
    ld a,0fh
    ld (l2407h),a
    ld a,01h
    ld (l2406h),a
l230fh:
;Clear the CP/M directory by filling it with E5 ("unused").
    call sub_2325h
    ld a,(l2422h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l2423h),a
    or a
    ret nz
    ld hl,l2407h
    dec (hl)
    jp p,l230fh
    ret

sub_2325h:
;Write a sector to an IEEE-488 drive.
    ld hl,l23feh        ;"M-W",00h,13h,01h
    ld c,l23feh_len
    ld a,(l2422h)
    call diskcmd        ;Open the command channel on IEEE-488 device
    call ieeemsg        ;Send string to the current IEEE-488 device
    ld a,(4000h)
    call wreoi          ;Send byte to IEEE-488 device with EOI asserted
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld hl,l23f7h        ;"B-P 2 1"
    ld c,l23f7h_len
    ld a,(l2422h)
    call diskcmd        ;Open the command channel on IEEE-488 device
    call ieeemsg        ;Send string to the current IEEE-488 device
    call creoi          ;Send carriage return to IEEE-488 dev with EOI
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld a,(l2422h)
    call dskdev         ;Get device address for a CP/M drive number
    ld e,02h
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,4001h
    ld c,0ffh
    call ieeemsg        ;Send string to the current IEEE-488 device
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld a,(l2422h)
    call diskcmd        ;Open the command channel on IEEE-488 device
    ld hl,l23deh        ;"U2 2 "
    ld c,l23deh_len
    call ieeemsg        ;Send string to the current IEEE-488 device
    ld a,(l2422h)
    and 01h
    add a,'0'
    call wrieee         ;Send byte to an IEEE-488 device
    ld a,(l2406h)
    call ieeenum        ;Send number as decimal string to IEEE-488 dev
    ld a,(l2407h)
    call ieeenum        ;Send number as decimal string to IEEE-488 dev
    call creoi          ;Send carriage return to IEEE-488 dev with EOI
    jp unlisten         ;Send UNLISTEN to all IEEE-488 devices

cform:
;Format a hard drive for Softbox use.
    call seldsk         ;Select disk drive
    ld hl,0080h
l2396h:
    ld (hl),0e5h
    inc l
    jr nz,l2396h
    ld bc,0002h
    call settrk         ;Set track number
    ld bc,0000h
l23a4h:
    push bc
    call setsec         ;Set sector number
    call write          ;Write selected sector
    pop bc
    or a
    jp nz,l23b7h
    inc bc
    ld a,c
    cp 40h
    jr nz,l23a4h
    ret

l23b7h:
;Display "Hit any key to abort" message, wait for a key, and then return.
    ld de,l23c4h        ;cr,lf,"Hit any key to abort : $"
    ld c,cwritestr
    call bdos           ;BDOS entry point
    ld c,cread
    jp bdos             ;BDOS entry point

l23c4h:
    db cr,lf,"Hit any key to abort : $"

l23deh:
    db "U2 2 "
l23deh_len: equ $-l23deh

l23e3h:
    db "N0:CP/M V2.2 DISK,XX"
l23e3h_len: equ $-l23e3h

l23f7h:
    db "B-P 2 1"
l23f7h_len: equ $-l23f7h

l23feh:
    db "M-W",00h,13h,01h
l23feh_len: equ $-l23feh

l2404h:                 ;unused !!!
    db "#2"

l2406h:
    db 0
l2407h:
    db 0

l2408h:
    db "S0:*"
l2408h_len: equ $-l2408h

l240ch:
    db "S1:*"

l2410h:
    db "0:CP/M"
l2410h_len: equ $-l2410h

l2416h:
    db "1:CP/M"

l241ch:
    db "0:K"
l241ch_len: equ $-l241ch

l241fh:
    db "1:K"

l2422h:
    db 0
l2423h:
    db 0

; End of LOADSAV2.REL =======================================================

l2424h:
    db 0
l2425h:
    nop                 ;2425 00
l2426h:
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
l2476h:
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
nn:
    dw 0                ;Integer parsed from user input
l24cah:
    dw 0
rr:
    db 0                ;First char of user input from any prompt

sub_24cdh:              ;Library MUL
    xor a               ;24cd af
    ld h,a              ;24ce 67
    add a,b             ;24cf 80
    jp m,l24dah         ;24d0 fa da 24
    or c                ;24d3 b1
    jp z,l2525h         ;24d4 ca 25 25
    jp l24e1h           ;24d7 c3 e1 24
l24dah:
    inc h               ;24da 24
    cpl                 ;24db 2f
    ld b,a              ;24dc 47
    ld a,c              ;24dd 79
    cpl                 ;24de 2f
    ld c,a              ;24df 4f
    inc bc              ;24e0 03
l24e1h:
    xor a               ;24e1 af
    add a,d             ;24e2 82
    jp m,l24edh         ;24e3 fa ed 24
    or e                ;24e6 b3
    jp z,l2525h         ;24e7 ca 25 25
    jp l24f4h           ;24ea c3 f4 24

l24edh:
    inc h               ;24ed 24
    cpl                 ;24ee 2f
    ld d,a              ;24ef 57
    ld a,e              ;24f0 7b
    cpl                 ;24f1 2f
    ld e,a              ;24f2 5f
    inc de              ;24f3 13
l24f4h:
    push hl             ;24f4 e5
    ld a,c              ;24f5 79
    sub e               ;24f6 93
    ld a,b              ;24f7 78
    sbc a,d             ;24f8 9a
    jp p,l2501h         ;24f9 f2 01 25
    ld h,b              ;24fc 60
    ld l,c              ;24fd 69
    ex de,hl            ;24fe eb
    ld b,h              ;24ff 44
    ld c,l              ;2500 4d
l2501h:
    ld hl,0000h         ;2501 21 00 00
    ex de,hl            ;2504 eb
l2505h:
    ld a,b              ;2505 78
    or c                ;2506 b1
    jp z,l251ah         ;2507 ca 1a 25
    ld a,b              ;250a 78
    rra                 ;250b 1f
    ld b,a              ;250c 47
    ld a,c              ;250d 79
    rra                 ;250e 1f
    ld c,a              ;250f 4f
    jp nc,l2516h        ;2510 d2 16 25
    ex de,hl            ;2513 eb
    add hl,de           ;2514 19
    ex de,hl            ;2515 eb
l2516h:
    add hl,hl           ;2516 29
    jp l2505h           ;2517 c3 05 25

l251ah:
    pop af              ;251a f1
    rra                 ;251b 1f
    ret nc              ;251c d0
    ld a,d              ;251d 7a
    cpl                 ;251e 2f
    ld d,a              ;251f 57
    ld a,e              ;2520 7b
    cpl                 ;2521 2f
    ld e,a              ;2522 5f
    inc de              ;2523 13
    ret                 ;2524 c9

l2525h:
    ld de,0000h         ;2525 11 00 00
    ret                 ;2528 c9

sub_2529h:              ;Library BD=DIV / HL=MOD
    xor a               ;2529 af
    ld h,b              ;252a 60
    ld l,c              ;252b 69
    ld b,a              ;252c 47
    add a,d             ;252d 82
    jp m,l2536h         ;252e fa 36 25
    or e                ;2531 b3
    jp nz,l253eh        ;2532 c2 3e 25
    ret                 ;2535 c9

l2536h:
    inc b               ;2536 04
    ld a,d              ;2537 7a
    cpl                 ;2538 2f
    ld d,a              ;2539 57
    ld a,e              ;253a 7b
    cpl                 ;253b 2f
    ld e,a              ;253c 5f
    inc de              ;253d 13
l253eh:
    xor a               ;253e af
    add a,h             ;253f 84
    jp m,l254bh         ;2540 fa 4b 25
    or l                ;2543 b5
    jp nz,l2556h        ;2544 c2 56 25
    ld bc,0000h         ;2547 01 00 00
    ret                 ;254a c9

l254bh:
    ld a,b              ;254b 78
    or 02h              ;254c f6 02
    ld b,a              ;254e 47
    ld a,h              ;254f 7c
    cpl                 ;2550 2f
    ld h,a              ;2551 67
    ld a,l              ;2552 7d
    cpl                 ;2553 2f
    ld l,a              ;2554 6f
    inc hl              ;2555 23
l2556h:
    push bc             ;2556 c5
    ld a,01h            ;2557 3e 01
    push af             ;2559 f5
    ld bc,0000h         ;255a 01 00 00
    xor a               ;255d af
    add a,d             ;255e 82
    jp m,l256fh         ;255f fa 6f 25
    ex de,hl            ;2562 eb
l2563h:
    pop af              ;2563 f1
    inc a               ;2564 3c
    push af             ;2565 f5
    add hl,hl           ;2566 29
    ld a,h              ;2567 7c
    cp 00h              ;2568 fe 00
    jp p,l2563h         ;256a f2 63 25
    ex de,hl            ;256d eb
    xor a               ;256e af
l256fh:
    ld a,c              ;256f 79
    rla                 ;2570 17
    ld c,a              ;2571 4f
    ld a,b              ;2572 78
    rla                 ;2573 17
    ld b,a              ;2574 47
    ld a,l              ;2575 7d
    sub e               ;2576 93
    ld l,a              ;2577 6f
    ld a,h              ;2578 7c
    sbc a,d             ;2579 9a
    ld h,a              ;257a 67
    jp c,l2582h         ;257b da 82 25
    inc bc              ;257e 03
    jp l2583h           ;257f c3 83 25

l2582h:
    add hl,de           ;2582 19
l2583h:
    pop af              ;2583 f1
    dec a               ;2584 3d
    jp z,l2593h         ;2585 ca 93 25
    push af             ;2588 f5
    xor a               ;2589 af
    ld a,d              ;258a 7a
    rra                 ;258b 1f
    ld d,a              ;258c 57
    ld a,e              ;258d 7b
    rra                 ;258e 1f
    ld e,a              ;258f 5f
    jp l256fh           ;2590 c3 6f 25

l2593h:
    xor a               ;2593 af
    ld a,d              ;2594 7a
    rra                 ;2595 1f
    ld d,a              ;2596 57
    ld a,e              ;2597 7b
    rra                 ;2598 1f
    ld e,a              ;2599 5f
    pop af              ;259a f1
    push af             ;259b f5
    rra                 ;259c 1f
    rra                 ;259d 1f
    jp nc,l25a8h        ;259e d2 a8 25
    ld a,h              ;25a1 7c
    cpl                 ;25a2 2f
    ld h,a              ;25a3 67
    ld a,l              ;25a4 7d
    cpl                 ;25a5 2f
    ld l,a              ;25a6 6f
    inc hl              ;25a7 23
l25a8h:
    pop af              ;25a8 f1
    inc a               ;25a9 3c
    rra                 ;25aa 1f
    rra                 ;25ab 1f
    ret nc              ;25ac d0
    ld a,b              ;25ad 78
    cpl                 ;25ae 2f
    ld b,a              ;25af 47
    ld a,c              ;25b0 79
    cpl                 ;25b1 2f
    ld c,a              ;25b2 4f
    inc bc              ;25b3 03
    ret                 ;25b4 c9

sub_25b5h:
    pop hl              ;25b5 e1
    push bc             ;25b6 c5
    push de             ;25b7 d5
    ld a,08h            ;25b8 3e 08
    add a,(hl)          ;25ba 86
    ld e,a              ;25bb 5f
    inc hl              ;25bc 23
    xor a               ;25bd af
    ld b,a              ;25be 47
    sub (hl)            ;25bf 96
    jp z,l25c4h         ;25c0 ca c4 25
    dec b               ;25c3 05
l25c4h:
    ld c,a              ;25c4 4f
    ld a,e              ;25c5 7b
    push hl             ;25c6 e5
    ld hl,0000h         ;25c7 21 00 00
    add hl,sp           ;25ca 39
    ld d,h              ;25cb 54
    ld e,l              ;25cc 5d
    add hl,bc           ;25cd 09
    ld sp,hl            ;25ce f9
l25cfh:
    or a                ;25cf b7
    jp z,l25ddh         ;25d0 ca dd 25
    ex de,hl            ;25d3 eb
    ld c,(hl)           ;25d4 4e
    ex de,hl            ;25d5 eb
    ld (hl),c           ;25d6 71
    inc hl              ;25d7 23
    inc de              ;25d8 13
    dec a               ;25d9 3d
    jp l25cfh           ;25da c3 cf 25

l25ddh:
    pop hl              ;25dd e1
    ld a,(hl)           ;25de 7e
    inc hl              ;25df 23
    ld c,(hl)           ;25e0 4e
    inc hl              ;25e1 23
    ld b,(hl)           ;25e2 46
    inc hl              ;25e3 23
    push bc             ;25e4 c5
    ex (sp),hl          ;25e5 e3
l25e6h:
    or a                ;25e6 b7
    jp z,l25f4h         ;25e7 ca f4 25
    dec de              ;25ea 1b
    ld c,(hl)           ;25eb 4e
    ex de,hl            ;25ec eb
    ld (hl),c           ;25ed 71
    ex de,hl            ;25ee eb
    inc hl              ;25ef 23
    dec a               ;25f0 3d
    jp l25e6h           ;25f1 c3 e6 25
l25f4h:
    pop hl              ;25f4 e1
    pop de              ;25f5 d1
    pop bc              ;25f6 c1
    jp (hl)             ;25f7 e9

sub_25f8h:
    ex (sp),hl          ;25f8 e3
    push af             ;25f9 f5
    ld a,(hl)           ;25fa 7e
    inc hl              ;25fb 23
    ld e,(hl)           ;25fc 5e
    inc hl              ;25fd 23
    ld d,(hl)           ;25fe 56
    ld hl,0006h         ;25ff 21 06 00
    ld b,h              ;2602 44
    ld c,a              ;2603 4f
    add hl,sp           ;2604 39
    ex de,hl            ;2605 eb
    add hl,bc           ;2606 09
l2607h:
    or a                ;2607 b7
    jp z,l2615h         ;2608 ca 15 26
    dec hl              ;260b 2b
    ex de,hl            ;260c eb
    ld c,(hl)           ;260d 4e
    ex de,hl            ;260e eb
    ld (hl),c           ;260f 71
    inc de              ;2610 13
    dec a               ;2611 3d
    jp l2607h           ;2612 c3 07 26
l2615h:
    ex de,hl            ;2615 eb
    pop af              ;2616 f1
    pop de              ;2617 d1
    pop bc              ;2618 c1
    ld sp,hl            ;2619 f9
    push bc             ;261a c5
    ex de,hl            ;261b eb
    ret                 ;261c c9

    db 0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0

l3002h:
    dw 0
l3004h:
    dw 0
l3006h:
    db 0
l3007h:
    db 0
l3008h:
    db 0
l3009h:
    db 0
l300ah:
    dw 0
l300ch:
    db 0
l300dh:
    dw 0
l300fh:
    dw 0
l3011h:
    dw 0
l3013h:
    db 0
l3014h:
    db 0
l3015h:
    db 0
dd:
    db 0                ;Loop index for drives (0-7)
heads:
    db 0                ;Total number of heads on a hard drive
unit:
    db 0                ;Unit number (0 or 1) of a hard drive
firsthead:
    db 0                ;First head that will be used on a hard drive
cylinders:
    dw 0                ;Total number of cylinders on a hard drive
lastcyl:
    dw 0                ;Last cylinder number that will be used for CP/M
aindex:
    db 0                ;Loop index for autoload command
asize:
    db 0                ;Size of autoload command
l3020h:
    dw 0

    db 0,0,0,0,0,0

l3028h:
    db 0
l3029h:
    db 0

    db 0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
