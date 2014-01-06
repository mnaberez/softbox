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
tab:           equ 09h    ;Tab
lf:            equ 0ah    ;Line Feed
cr:            equ 0dh    ;Carriage Return
cls:           equ 1ah    ;Clear Screen

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
    ld a,(cbmdos_sector);011e 3a 23 24
    or a                ;0121 b7
    jp z,l0162h         ;0122 ca 62 01

    ;PRINT "Disk error :  ";
    ld bc,disk_error
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
    ;PRINT
    call print_eol

l0162h:
    ld a,(cbmdos_sector);0162 3a 23 24
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
    ld bc,zero
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
    ;buff_size = 80
    ld hl,buff_size
    ld (hl),50h

    ld de,buffer        ;021b 11 24 24
    ld c,creadstr       ;021e 0e 0a
    call bdos           ;BDOS entry point

    ;N = 0
    ld hl,0000h
    ld (nn),hl

    ;l24cah = 0
    ld (l24cah),hl      ;0229 22 ca 24

    ;IF buff_len <> 0 THEN GOTO l023bh
    ld a,(buff_len)     ;022c 3a 25 24
    or a                ;022f b7
    jp nz,l023bh        ;0230 c2 3b 02

    ;R = 13
    ld hl,rr
    ld (hl),cr

    ;GOTO l02ffh
    jp l02ffh

l023bh:
    ;l3013h = 1
    ;l3015h = buff_len
    ld hl,l3013h        ;023b 21 13 30
    ld (hl),01h         ;023e 36 01
    ld a,(buff_len)     ;0240 3a 25 24
    inc hl              ;0243 23
    inc hl              ;0244 23
    ld (hl),a           ;0245 77

    ;GOTO l02efh
    jp l02efh

l0249h:
    ;l3014h = buff_data(l3013h-1)
    ld a,(l3013h)       ;0249 3a 13 30
    ld l,a              ;024c 6f
    rla                 ;024d 17
    sbc a,a             ;024e 9f
    ld bc,buff_data-1   ;024f 01 25 24
    ld h,a              ;0252 67
    add hl,bc           ;0253 09
    ld a,(hl)           ;0254 7e
    ld (l3014h),a       ;0255 32 14 30

    ;l2476h(l3013h) = l3014h
    ;IF l3014h < &H61 OR l3014h >= &H7B THEN GOTO l0278h
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

    ;l3014h = l3014h - &H20
    ld hl,l3014h
    ld a,(hl)
    add a,0e0h
    ld (hl),a

l0278h:
    ;buff_data(l3013h-1) = l3014h
    ld a,(l3013h)       ;0278 3a 13 30
    ld l,a              ;027b 6f
    rla                 ;027c 17
    sbc a,a             ;027d 9f
    ld bc,buff_data-1   ;027e 01 25 24
    ld h,a              ;0281 67
    add hl,bc           ;0282 09
    ld a,(l3014h)       ;0283 3a 14 30
    ld (hl),a           ;0286 77

    ;l3014h = l3014h - &H30
    ;IF l3014h < 0 OR l3014h >= 10 THEN GOTO l02c5h
    ld hl,l3014h        ;0287 21 14 30
    ld a,(hl)           ;028a 7e
    add a,0d0h          ;028b c6 d0
    ld (hl),a           ;028d 77
    or a                ;028e b7
    jp m,l02c5h         ;028f fa c5 02
    cp 10               ;0292 fe 0a
    jp p,l02c5h         ;0294 f2 c5 02

    ;N = l3014h + N * 10
    ld hl,(nn)          ;0297 2a c8 24
    ld b,h              ;029a 44
    ld c,l              ;029b 4d
    ld de,10            ;029c 11 0a 00
    call sub_24cdh      ;029f cd cd 24 (Library MUL)
    ld a,(l3014h)       ;02a2 3a 14 30
    ld l,a              ;02a5 6f
    rla                 ;02a6 17
    sbc a,a             ;02a7 9f
    ld h,a              ;02a8 67
    add hl,de           ;02a9 19
    ld (nn),hl          ;02aa 22 c8 24

    ;l24cah = l3014h + l24cah * 16
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
    ;l3014h = l3014h - 7
    ;IF l3014h < 10 OR l3014h >= 16 THEN GOTO l02ebh
    ld hl,l3014h        ;02c5 21 14 30
    ld a,(hl)           ;02c8 7e
    add a,-7            ;02c9 c6 f9
    ld (hl),a           ;02cb 77
    cp 10               ;02cc fe 0a
    jp m,l02ebh         ;02ce fa eb 02
    cp 16               ;02d1 fe 10
    jp p,l02ebh         ;02d3 f2 eb 02

    ;l24cah = l3014h + l24cah * 16
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
    ;l3013h = l3013h + 1
    ld hl,l3013h        ;02eb 21 13 30
    inc (hl)            ;02ee 34

l02efh:
    ;IF l3015h > l3013h THEN GOTO l0249h
    ld a,(l3015h)       ;02ef 3a 15 30
    ld hl,l3013h        ;02f2 21 13 30
    cp (hl)             ;02f5 be
    jp p,l0249h         ;02f6 f2 49 02

    ;R = buff_data(0)
    ld a,(buff_data)    ;02f9 3a 26 24
    ld (rr),a           ;02fc 32 cc 24

l02ffh:
    ret                 ;02ff c9

clear_screen:
    ;PRINT CHR$(26); ' Clear screen
    ld c,cls
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
    ld bc,drv_a_3mb
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "B.   6  Mbyte      (191 cyl)"
    ld bc,drv_b_6mb
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "C.   12 Mbyte      (191 cyl)"
    ld bc,drv_c_12mb
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "D.   5  Mbyte      (320 cyl)"
    ld bc,drv_d_5mb
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "E.   10 Mbyte      (320 cyl)"
    ld bc,drv_e_10mb
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "F.   15 Mbyte      (320 cyl)"
    ld bc,drv_f_15mb
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Z.   User supplied Head & Cyl count"
    ld bc,drv_z_other
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Which drive type (A-F or Z) ? ";
    ld bc,which_type
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

    ;REM User selected 'Z' for arbitrary heads/cylinders

ask_drv_heads:
    ;PRINT "Enter the number of Heads : ";
    ld bc,num_heads
    call print_str

    ;GOSUB readline
    call readline

    ;REM TODO: This is a bug.  There should be a "call print_eol" here.
    ;REM The next prompt will be written over the current line.

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
    ld bc,num_cylinders
    call print_str

    ;GOSUB readline
    call readline

    ;REM TODO: This is a bug.  There should be a "call print_eol" here.
    ;REM The next prompt will be written over the current line.

    ;cylinders = N
    ld hl,(nn)
    ld (cylinders),hl

    ;GOTO l0483h
    jp l0483h

bad_drv_type:
    ;GOTO ask_drv_type
    jp ask_drv_type

l0483h:
    ;POKE &H5670+D, (heads/2)+1 ' Store drive type
    ;REM 2 heads => drive type 2
    ;REM 4 heads => drive type 3
    ;REM 6 heads => drive type 4
    ;REM 8 heads => drive type 5
    ld a,(heads)
    or a
    rra
    inc a
    ld c,a
    ld a,(dd)
    ld l,a
    rla
    sbc a,a
    ld de,5670h
    ld h,a
    add hl,de
    ld (hl),c

ask_sbox_conf:
    ;PRINT "Use the ENTIRE drive for CP/M"
    ld bc,use_entire
    call print_str_eol

    ;PRINT "or just the first HALF (E/H) ? ";
    ld bc,or_first_half
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
    ld bc,physical_unit
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
    ld bc,start_surfaces
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
    ld bc,offset_for_sur
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
    ld bc,drv_assgnmt
    call print_str_eol

    ;PRINT "---- ----- -----------"
    ld bc,drv_dashes
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
    ld bc,drv_comma
    call print_str

    ;PRINT CHR$(D*2+&H42);      ' Second letter in drive pair
    ld a,(dd)
    add a,a
    add a,'B'
    ld c,a
    call print_char

    ;PRINT ":      ";
    ld bc,drv_colon
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
    ld bc,spaces_paren
    call print_str

    ;PRINT DEEK(&H5648+unit*2);  ' Total cylinders
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
    ld bc,spaces_head
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
    ld bc,head_dash
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
    ld bc,cyls_1_dash
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

    ;PRINT " used)";
    ld bc,used_paren
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
    ld bc,alter_which_pair
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
    ld bc,flop_hard_unused
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
    ld bc,what_drive_type
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
    ld bc,what_hard_drive
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
    ld bc,no_aload_cmd
    call print_str_eol

    ;PRINT
    call print_eol

    ;GOTO ask_autoload
    jp ask_autoload

l09adh:
    ;PRINT "Current autoload command is : "
    ld bc,cur_aload_cmd
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
    ld bc,new_aload_yn
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
    ld bc,pls_enter_aload
    call print_str_eol

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ld a,(buff_len)       ;0a00 3a 25 24
    ld (4007h),a        ;0a03 32 07 40
    ld hl,aindex        ;0a06 21 1e 30
    ld (hl),01h         ;0a09 36 01
    ld a,(buff_len)       ;0a0b 3a 25 24
    inc hl              ;0a0e 23
    ld (hl),a           ;0a0f 77
    jp l0a30h           ;0a10 c3 30 0a

l0a13h:
    ;POKE &H4007+AINDEX, buff_len(l301e)
    ld a,(aindex)       ;0a13 3a 1e 30
    ld l,a              ;0a16 6f
    rla                 ;0a17 17
    sbc a,a             ;0a18 9f
    ld bc,buff_len        ;0a19 01 25 24
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
    ld a,(buff_len)       ;0a3a 3a 25 24
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
    ld bc,save_on_which
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
    ld bc,drv_not_in_sys
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
    ld bc,retry_yn
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
    ld bc,cpm_reconfig
    call print_str_eol

    ;PRINT "---- ---------------"
    ld bc,cpm_dashes
    call print_str_eol

    ;PRINT
    call print_eol

    ;IF 1=1 THEN GOTO l0b13h
    ld a,01h
    cp 01h
    jp nz,l0b13h

    ;PRINT "Mini-Winchester version"
    ld bc,mw_version
    call print_str_eol

l0b13h:
    ;PRINT "Revision C2.2  --   9 March 1984"
    ld bc,rev_c22
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Source drive (A - P) ? ";
    ld bc,source_drive
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
    jp start            ;0ba2 c3 f1 0a
l0ba5h:
    jp l0babh           ;0ba5 c3 ab 0b
l0ba8h:
    jp start            ;0ba8 c3 f1 0a

l0babh:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call print_eol

    ;PRINT "CP/M Reconfiguration"
    ld bc,cpm_reconfig_2
    call print_str_eol

    ;PRINT "---- ---------------"
    ld bc,cpm_dashes_2
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "A = Autoload command"
    ld bc,a_autoload
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "D = Disk Drive Assignment"
    ld bc,d_disk_drv
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "I = I/O Assignment"
    ld bc,i_io_asgn
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "P = Pet Terminal Parameters"
    ld bc,p_pet_term
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "R = RS232 Characteristics"
    ld bc,r_rs232_chrs
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "S = Save New System"
    ld bc,s_save_sys
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "E = Execute New System"
    ld bc,e_exec_sys
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Q = Quit This Program"
    ld bc,q_quit
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Please enter the appropriate letter: ";
    ld bc,please_enter
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

disk_error:
    db 0eh
    db "Disk error :  "

zero:
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

drv_a_3mb:
    db 1ch
    db "A.   3  Mbyte      (191 cyl)"

drv_b_6mb:
    db 1ch
    db "B.   6  Mbyte      (191 cyl)"

drv_c_12mb:
    db 1ch
    db "C.   12 Mbyte      (191 cyl)"

drv_d_5mb:
    db 1ch
    db "D.   5  Mbyte      (320 cyl)"

drv_e_10mb:
    db 1ch
    db "E.   10 Mbyte      (320 cyl)"

drv_f_15mb:
    db 1ch
    db "F.   15 Mbyte      (320 cyl)"

drv_z_other:
    db 23h
    db "Z.   User supplied Head & Cyl count"

which_type:
    db 1eh
    db "Which drive type (A-F or Z) ? "

num_heads:
    db 1ch
    db "Enter the number of Heads : "

l0dffh:
    db 14h
    db "Must be 2, 4, 6 or 8"

num_cylinders:
    db 20h
    db "Enter the number of Cylinders : "

use_entire:
    db 1dh
    db "Use the ENTIRE drive for CP/M"

or_first_half:
    db 1fh
    db "or just the first HALF (E/H) ? "

physical_unit:
    db 1bh
    db "Physical unit # (0 or 1) ? "

start_surfaces:
    db 22h
    db "Start surface #'s from 0  (Y/N) ? "

offset_for_sur:
    db 19h
    db "Offset for surface #'s ? "

drv_assgnmt:
    db 16h
    db "Disk Drive Assignment."

drv_dashes:
    db 16h
    db "---- ----- -----------"

drv_comma:
    db 02h
    db ", "

drv_colon:
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

spaces_paren:
    db 0ch
    db "           ("

cyl_comma:
    db 07h
    db " cyl,  "

mbyte_drive:
    db 0dh
    db " Mbyte drive,"

spaces_head:
    db 10h
    db "           Head "

head_dash:
    db 01h
    db "-"

cyls_1_dash:
    db 09h
    db "  Cyls 1-"

used_paren:
    db 06h
    db " used)"

alter_which_pair:
    db 22h
    db "Alter which drive pair (A to O) ? "

flop_hard_unused:
    db 22h
    db "F(loppy),  H(ard) or  U(nused)  ? "

what_drive_type:
    db 25h
    db "Type (A=3040/4040, B=8050, C=8250) ? "

what_hard_drive:
    db 1bh
    db "5, 10, or 20 Mbyte drive ? "

no_aload_cmd:
    db 1bh
    db "No current autoload command"

cur_aload_cmd:
    db 1eh
    db "Current autoload command is : "

new_aload_yn:
    db 1eh
    db "New autoload command  (Y/N) ? "

pls_enter_aload:
    db 1fh
    db "Please enter the new command : "

save_on_which:
    db 1eh
    db "Save on which drive (A - P) ? "

drv_not_in_sys:
    db 13h
    db "Drive not in system"

retry_yn:
    db 0eh
    db "Retry (Y/N) ? "

cpm_reconfig:
    db 14h
    db "CP/M Reconfiguration"

cpm_dashes:
    db 14h
    db "---- ---------------"

mw_version:
    db 17h
    db "Mini-Winchester version"

rev_c22:
    db 20h
    db "Revision C2.2  --   9 March 1984"

source_drive:
    db 17h
    db "Source drive (A - P) ? "

cpm_reconfig_2:
    db 14h
    db "CP/M Reconfiguration"

cpm_dashes_2:
    db 14h
    db "---- ---------------"

a_autoload:
    db 14h
    db "A = Autoload command"

d_disk_drv:
    db 19h
    db "D = Disk Drive Assignment"

i_io_asgn:
    db 12h
    db "I = I/O Assignment"

p_pet_term:
    db 1bh
    db "P = Pet Terminal Parameters"

r_rs232_chrs:
    db 19h
    db "R = RS232 Characteristics"

s_save_sys:
    db 13h
    db "S = Save New System"

e_exec_sys:
    db 16h
    db "E = Execute New System"

q_quit:
    db 15h
    db "Q = Quit This Program"

please_enter:
    db 25h
    db "Please enter the appropriate letter: "

l12a6h:
    ;GOTO l13eeh
    jp l13eeh

ask_char_size:
    ;PRINT "New charater length (5 to 8) ? ";
    ld bc,new_char_len
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;N = R - (&H30 + 5)
    ld a,(rr)           ;12b5 3a cc 24
    ld l,a              ;12b8 6f
    rla                 ;12b9 17
    sbc a,a             ;12ba 9f
    ld bc,'5'           ;12bb 01 cb ff
    ld h,a              ;12be 67
    add hl,bc           ;12bf 09
    ld (nn),hl          ;12c0 22 c8 24

    ;IF N < 0 THEN GOTO l12ech
    ld hl,(nn)          ;12c3 2a c8 24
    add hl,hl           ;12c6 29
    jp c,l12ech         ;12c7 da ec 12

    ;IF (N-4) >= 0 THEN GOTO l12ech
    ld bc,-4            ;12ca 01 fc ff
    ld hl,(nn)          ;12cd 2a c8 24
    add hl,bc           ;12d0 09
    add hl,hl           ;12d1 29
    jp nc,l12ech        ;12d2 d2 ec 12

    ;POKE &H5664, PEEK(&H5664) AND &HF3 OR (N SHL 2)
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
    ;RETURN
    ret                 ;12ec c9

ask_stop_bits:
    ;PRINT "Number of stop bits (1 or 2) ? ";
    ld bc,num_stop_bits
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
    ld bc,odd_even_none
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
    ld bc,ask_bauds
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

    ;POKE &H5665, &H22
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

    ;POKE &H5665, &H55
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

    ;POKE &H5665, &H77
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

    ;POKE &H5665, &HCC
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

    ;POKE &H5665, &HEE
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

    ;POKE &H5665, &HFF
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
    ld bc,rs232_chrs
    call print_str_eol

    ;PRINT "----- ----------------"
    ld bc,rs232_dashes
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 1.  Character size :<tab><tab>";
    ld bc,rs232_1_chr
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
    ld bc,rs232_2_stop
    call print_str

    ;stoptmp = PEEK(&H5664) AND &HC0
    ld a,(5664h)
    and 0c0h
    ld (stoptmp),a

    ;IF stoptmp <> &H40 THEN GOTO l1441h
    cp 40h
    jp nz,l1441h

    ;REM 1 stop bit

    ;<HL = pointer to "1">
    ld hl,stops_1

    ;GOTO l1460h
    jp l1460h

l1441h:
    ;IF stoptmp <> &H80 THEN GOTO l144fh
    ld a,(stoptmp)
    cp 80h
    jp nz,l144fh

    ;REM 1.5 stop bits

    ;<HL = pointer to "1.5">
    ld hl,stops_1_5

    ;GOTO l1460h
    jp l1460h

l144fh:
    ;IF stoptmp <> &HC0 THEN GOTO l145dh
    ld a,(stoptmp)
    cp 0c0h
    jp nz,l145dh

    ;REM 2 stop bits

    ;<HL = pointer to "2">
    ld hl,stops_2

    ;GOTO l1460h
    jp l1460h

l145dh:
    ;<HL = pointer to "undefined">
    ld hl,stops_undef

l1460h:
    ;PRINT <string at HL>
    ld b,h
    ld c,l
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 3.  Parity :<tab><tab><tab>";
    ld bc,rs232_3_par
    call print_str

    ;IF (PEEK(&H5664) AND &H10) THEN GOTO l147ch
    ld a,(5664h)
    and 10h
    jp nz,l147ch

    ;REM Parity is none.

    ;<HL = pointer to "none">
    ld hl,parity_none

    ;GOTO l149fh
    jp l149fh

l147ch:
    ;IF (PEEK(&H5664) AND &H30) <> &H30 THEN GOTO l148ch
    ld a,(5664h)
    and 30h
    cp 30h
    jp nz,l148ch

    ;REM Parity is even.

    ;<HL = pointer to "even">
    ld hl,parity_even

    ;GOTO l149fh
    jp l149fh

l148ch:
    ;IF (PEEK(&H5664) AND &30H) <> &H10 THEN GOTO l149ch
    ld a,(5664h)
    and 30h
    cp 10h
    jp nz,l149ch

    ;REM Parity is odd.

    ;<HL = pointer to "odd ">
    ld hl,parity_odd

    ;GOTO l149fh
    jp l149fh

l149ch:
    ;REM Parity is unknown.

    ;<HL = pointer to "    ">
    ld hl,parity_blank

l149fh:
    ;PRINT <string at HL>
    ld b,h
    ld c,l
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 4.  Baud rate :<tab><tab>";
    ld bc,rs232_4_baud
    call print_str

    ;IF PEEK(&H5665) <> &H22 THEN GOTO l14bbh
    ld a,(5665h)
    cp 22h
    jp nz,l14bbh

    ;REM Baud is 110

    ;<HL = pointer to "110  ">
    ld hl,baud_110

    ;GOTO l1504h
    jp l1504h

l14bbh:
    ;IF PEEK(&H5665) <> &H55 THEN GOTO l14c9h
    ld a,(5665h)
    cp 55h
    jp nz,l14c9h

    ;REM Baud is 300

    ;<HL = pointer to "300  ">
    ld hl,baud_300

    ;GOTO l1504h
    jp l1504h

l14c9h:
    ;IF PEEK(&H5665) <> &H77 THEN GOTO l14d7h
    ld a,(5665h)
    cp 77h
    jp nz,l14d7h

    ;REM Baud is 1200

    ;<HL = pointer to "1200 ">
    ld hl,baud_1200

    ;GOTO l1504h
    jp l1504h

l14d7h:
    ;IF PEEK(&H5665) <> &HCC THEN GOTO l14e5h
    ld a,(5665h)
    cp 0cch
    jp nz,l14e5h

    ;REM Baud is 4800

    ;<HL = pointer to "4800 ">
    ld hl,baud_4800

    ;GOTO l1504h
    jp l1504h

l14e5h:
    ;IF PEEK(&H5665) <> &HEE THEN GOTO l14f3h
    ld a,(5665h)
    cp 0eeh
    jp nz,l14f3h

    ;REM Baud is 9600

    ;<HL = pointer to "9600 ">
    ld hl,baud_9600

    ;GOTO l1504h
    jp l1504h

l14f3h:
    ;IF PEEK(&H5665) <> &HFF THEN GOTO l1501h
    ld a,(5665h)
    cp 0ffh
    jp nz,l1501h

    ;REM Baud is 19200

    ;<HL = pointer to "19200">
    ld hl,baud_19200

    ;GOTO l1504h
    jp l1504h

l1501h:
    ;REM Baud is unknown

    ;<HL = pointer to "     ">
    ld hl,baud_blank

l1504h:
    ;PRINT <string at HL>
    ld b,h
    ld c,l
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Alter which characteristic ? ";
    ld bc,alter_which
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF N <> 0 THEN GOTO l1521h
    ld hl,(nn)
    ld a,l
    or h
    jp nz,l1521h

    ;REM User did not enter a number

    ;RETURN
    ret

l1521h:
    ;IF N <> 1 THEN GOTO l1530h
    ld hl,(nn)
    dec hl
    ld a,h
    or l
    jp nz,l1530h

    ;REM User selected 1 for Character size

    ;GOSUB ask_char_size
    call ask_char_size

    ;GOTO l1560h
    jp l1560h

l1530h:
    ;IF N) <> 2 THEN GOTO l1540h
    ld hl,(nn)
    dec hl
    dec hl
    ld a,h
    or l
    jp nz,l1540h

    ;REM User selected 2 for Stop bits

    ;GOSUB ask_stop_bits
    call ask_stop_bits

    ;GOTO l1560h
    jp l1560h

l1540h:
    ;IF N <> 3 THEN GOTO l1551h
    ld hl,(nn)
    dec hl
    dec hl
    dec hl
    ld a,h
    or l
    jp nz,l1551h

    ;REM User selected 3 for Parity

    ;GOSUB ask_parity
    call ask_parity

    ;GOTO l1560h
    jp l1560h

l1551h:
    ;IF N <> 4 THEN GOTO l1560h
    ld bc,-4
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l1560h

    ;REM User selected 4 for Baud rate

    ;GOSUB ask_baud_rate
    call ask_baud_rate

l1560h:
    ;GOTO l13eeh
    jp l13eeh

    ;RETURN
    ret

sub_1564h:
    jp l1697h           ;1564 c3 97 16

sub_1567h:
    ;PRINT
    call print_eol

    ;PRINT "T(TY: -- RS232 printer"
    ld bc,tty_rs232
    call print_str_eol

    ;PRINT "C(RT: -- PET screen"
    ld bc,crt_pet_scrn
    call print_str_eol

    ;PRINT "L(PT: -- PET IEEE printer"
    ld bc,lpt_pet
    call print_str_eol

    ;PRINT "U(L1: -- ASCII IEEE printer"
    ld bc,ul1_ascii
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Which list device (T, C, L or U) ? ";
    ld bc,which_list_dev
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
    ld bc,tty_or_ptr
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
    ld bc,tty_or_ptp
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H54 THEN GOTO l1632h
    ld a,(rr)
    cp 'T'
    jp nz,l1632h

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

    ;PRINT "3 = 3022 or 3023 or 4022 or 4023"
    ld bc,for_cbm3032
    call print_str_eol

    ;PRINT "8 = 8024"
    ld bc,for_cbm8024
    call print_str_eol

    ;PRINT "D = 8026 or 8027 (Daisywheel)"
    ld bc,for_dwheel
    call print_str_eol
    call print_eol

    ;PRINT "Which type of printer (3, 8, or D) ? ";
    ld bc,which_printer
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
    ld bc,io_dev_asgn
    call print_str_eol

    ;PRINT "--- ------ -----------"
    ld bc,io_dashes
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 1.  PET Printer device # :<tab>";
    ld bc,io_lpt_device
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
    ld bc,io_ul1_device
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
    ld bc,io_rdr_device
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
    ld bc,io_pun_device
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
    ld bc,io_lst_device
    call print_str

    ;IF (PEEK(&H5660) AND &HC0) <> 0 THEN GOTO l171ch
    ld a,(5660h)
    and 0c0h
    jp nz,l171ch

    ;REM Default LST: device is TTY:

    ;<HL = pointer to "TTY:">
    ld hl,lst_tty

    ;GOTO l173fh
    jp l173fh

l171ch:
    ;IF (PEEK(&H5660) AND &HC0) <> &H40 THEN GOTO l172ch
    ld a,(5660h)
    and 0c0h
    cp 40h
    jp nz,l172ch

    ;REM Default LST: device is CRT:

    ;<HL = pointer to "CRT:">
    ld hl,lst_crt

    ;GOTO l173fh
    jp l173fh

l172ch:
    ;IF (PEEK(&H5660) AND &HC0) <> &H80 THEN GOTO l173ch
    ld a,(5660h)
    and 0c0h
    cp 80h
    jp nz,l173ch

    ;REM Default LST: device is LPT:

    ;<HL = pointer to "LPT:">
    ld hl,lst_lpt

    ;GOTO l173fh
    jp l173fh

l173ch:
    ;REM Default LST: device is unknown

    ;<HL = pointer to "   :">
    ld hl,lst_blank

l173fh:
    ;PRINT <string at HL>
    ld b,h
    ld c,l
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 6.  Default RDR: device :<tab>";
    ld bc,io_default_rdr
    call print_str

    ;IF (PEEK(&H5660) AND &H0C) <> 0 THEN GOTO l175bh
    ld a,(5660h)
    and 0ch
    jp nz,l175bh

    ;REM Default RDR: device is TTY:

    ;<HL = pointer to "TTY:">
    ld hl,rdr_tty

    ;GOTO l175eh
    jp l175eh

l175bh:
    ;REM Default RDR: device is PTR:

    ;<HL = pointer to "PTR:">
    ld hl,rdr_ptr

l175eh:
    ;PRINT <string at HL>
    ld b,h
    ld c,l
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 7.  Default PUN: device :<tab>";
    ld bc,io_default_pun
    call print_str

    ;IF (PEEK(&H5660) AND &H30) <> 0 THEN GOTO l177ah
    ld a,(5660h)
    and 30h
    jp nz,l177ah

    ;REM Default PUN: device is TTY:

    ;<HL = pointer to "TTY:">
    ld hl,pun_tty

    ;GOTO l177dh
    jp l177dh

l177ah:
    ;REM Default PUN: device is PTP:

    ;<HL = pointer to "PTP:">
    ld hl,pun_ptp

l177dh:
    ;PRINT <string at HL>
    ld b,h
    ld c,l
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT " 8.  PET Printer type :   <tab>";
    ld bc,io_pet_prntr
    call print_str

    ;IF PEEK(&H566D) <> 0 THEN GOTO l1798h
    ld a,(566dh)
    or a
    jp nz,l1798h

    ;REM PET Printer type is 3022/4022

    ;<HL = pointer to "3022/4022">
    ld hl,prntr_for_cbm3032

    ;GOTO l17b7h
    jp l17b7h

l1798h:
    ;IF PEEK(&H566D) <> 1 THEN GOTO l17a6h
    ld a,(566dh)
    cp 01h
    jp nz,l17a6h

    ;REM PET Printer type is 8026/8027 (Daisywheel)

    ;<HL = pointer to "8026/8027">
    ld hl,prntr_dwheel

    ;GOTO l17b7h
    jp l17b7h

l17a6h:
    ;IF (PEEK&H566D) <> 2 THEN GOTO l17b4h
    ld a,(566dh)
    cp 02h
    jp nz,l17b4h

    ;REM PET Printer type is 8024

    ;<HL = pointer to "8024">
    ld hl,prntr_cbm8024

    ;GOTO l17b7h
    jp l17b7h

l17b4h:
    ;REM PET Printer type is unknown

    ;<HL = pointer to "    ">
    ld hl,prntr_blank

l17b7h:
    ;PRINT <string at HL>
    ld b,h
    ld c,l
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Alter which characteristic (1-8) ? ";
    ld bc,alter_which_1_8
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
    ;IF N <> 5 THEN GOTO l17e9h
    ld bc,-5
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l17e9h

    ;REM User selected 5. Default LST: device

    ;GOSUB sub_1567h
    call sub_1567h

    ;GOTO l1872h
    jp l1872h

l17e9h:
    ;IF N <> 6 THEN GOTO l15e1h
    ld bc,-6
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l17fbh

    ;REM User selected 6. Default RDR: device

    ;GOSUB sub_15e1h
    call sub_15e1h

    ;GOTO l1872h
    jp l1872h

l17fbh:
    ;IF N <> 7 THEN GOTO l180dh
    ld bc,-7
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l180dh

    ;REM User selected 7. Default PUN: device

    ;GOSUB sub_1613h
    call sub_1613h

    ;GOTO l1872h
    jp l1872h

l180dh:
    ;IF N <> 8 THEN GOTO l180dh
    ld bc,-8
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l181fh

    ;REM User selected 8. PET Printer type

    ;GOSUB sub_1645h
    call sub_1645h

    ;GOTO l1872h
    jp l1872h

l181fh:
    ;REM User selected 1-4 (device numbers)

    ;iochoice = N
    ld a,(nn)
    ld (iochoice),a

    ;PRINT "New device # ? ";
    ld bc,new_dev_num
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF iochoice <> 1 THEN GOTO l1842h
    ld a,(iochoice)
    cp 01h
    jp nz,l1842h

    ;REM User selected 1. PET printer device #

    ;POKE &H5661, N
    ld a,(nn)
    ld (5661h),a

    ;GOTO l1872h
    jp l1872h

l1842h:
    ;IF iochoice <> 2 THEN GOTO l1853h
    ld a,(iochoice)
    cp 02h
    jp nz,l1853h

    ;REM User selected 2. ASCII list device #

    ;POKE &H5666, N
    ld a,(nn)
    ld (5666h),a

    ;GOTO l1872h
    jp l1872h

l1853h:
    ;IF iochoice <> 3 THEN GOTO l1853h
    ld a,(iochoice)
    cp 03h
    jp nz,l1864h

    ;REM User selected 3. Reader device #

    ;POKE &H5662, N
    ld a,(nn)
    ld (5662h),a

    ;GOTO l1872h
    jp l1872h

l1864h:
    ;IF iochoice <> 4 THEN GOTO l1872h
    ld a,(iochoice)
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
    ld bc,num_of_cols
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
    ;IF (N-4) <> 0 THEN GOTO l18b9h
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
    ld bc,screen_type
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H41 THEN GOTO l18e2h
    ld a,(rr)
    cp 'A'
    jp nz,l18e2h

    ;REM User selected 'A' for A(DM3A)

    ;POKE &H5667, PEEK(&H5667) AND &H80 ' Set TERMTYPE
    ld a,(5667h)
    and 80h
    ld (5667h),a

    ;GOTO l18f4h
    jp l18f4h

l18e2h:
    ;IF R <> &H54 THEN GOTO l18f4h
    ld a,(rr)
    cp 'T'
    jp nz,l18f4h

    ;REM User selected 'T' for T(V912)

    ;POKE &H5667, PEEK(&H5667) AND &H80 OR &H02 ' Set TERMTYPE
    ld a,(5667h)
    and 80h
    or 02h
    ld (5667h),a

l18f4h:
    ;IF H <> &H48 THEN GOTO hz1500
    ld a,(rr)
    cp 'H'
    jp nz,hz1500

    ;REM User selected 'H' for H(Z1500)

ask_leadin:
    ;PRINT "Lead-in code E(scape) or T(ilde) ? ";
    ld bc,esc_or_tilde
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H45 THEN GOTO l1918h
    ld a,(rr)
    cp 'E'
    jp nz,l1918h

    ;REM User selected 'E' for Escape lead-in

    ;POKE &H5668, &H1b : REM LEADIN = &H1B
    ld hl,5668h
    ld (hl),1bh

    ;GOTO adm_or_tv
    jp adm_or_tv

l1918h:
    ;IF R <> &H54 THEN GOTO bad_leadin
    ld a,(rr)
    cp 'T'
    jp nz,bad_leadin

    ;REM User selected 'T' for Tilde lead-in

    ;POKE &H5668, &H7e : REM LEADIN = &H7e
    ld hl,5668h
    ld (hl),7eh

    ;GOTO adm_or_tv
    jp adm_or_tv

bad_leadin:
    ;GOTO ask_leadin
    jp ask_leadin

adm_or_tv:
    ;REM Terminal settings for LSI ADM-3A and TeleVideo TV-912

    ;POKE &H5667, PEEK(&H5667) AND &H80 OR &H01 ' Set TERMTYPE
    ld a,(5667h)
    and 80h
    or 01h
    ld (5667h),a

    ;POKE &H566A, &H00 : REM ROWOFF = &H00
    ld hl,566ah
    ld (hl),00h

    ;POKE &H566B, &H00 : REM COLOFF = &H00
    inc hl
    ld (hl),00h

    ;POKE &H5669, &H01 : REM ORDER = &H01
    dec hl
    dec hl
    ld (hl),01h

    ;POKE &H5680, &H8B : REM SCRTAB(0) = &H8B
    ld hl,5680h
    ld (hl),8bh

    ;POKE &H5681, &H0B : REM SCRTAB(1) = &H0B
    inc hl
    ld (hl),0bh

    ;POKE &H5682, &H8C : REM SCRTAB(2) = &H8C
    inc hl
    ld (hl),8ch

    ;POKE &H5683, &H0C : REM SCRTAB(3) = &H0C
    inc hl
    ld (hl),0ch

    ;POKE &H5684, &H8F : REM SCRTAB(4) = &H8F
    inc hl
    ld (hl),8fh

    ;POKE &H5685, &H13 : REM SCRTAB(5) = &H13
    inc hl
    ld (hl),13h

    ;POKE &H5686, &H91 : REM SCRTAB(6) = &H91
    inc hl
    ld (hl),91h

    ;POKE &H5687, &H1B : REM SCRTAB(7) = &H1B
    inc hl
    ld (hl),1bh

    ;POKE &H5688, &H92 : REM SCRTAB(8) = &H92
    inc hl
    ld (hl),92h

    ;POKE &H5689, &H1E : REM SCRTAB(9) = &H1E
    inc hl
    ld (hl),1eh

    ;POKE &H568A, &H93 : REM SCRTAB(10) = &H93
    inc hl
    ld (hl),93h

    ;POKE &H568B, &H12 : REM SCRTAB(11) = &H12
    inc hl
    ld (hl),12h

    ;POKE &H568C, &H97 : REM SCRTAB(12) = &H97
    inc hl
    ld (hl),97h

    ;POKE &H568D, &H14 : REM SCRTAB(13) = &H14
    inc hl
    ld (hl),14h

    ;POKE &H568E, &H98 : REM SCRTAB(14) = &H98
    inc hl
    ld (hl),98h

    ;POKE &H568F, &H14 : REM SCRTAB(15) = &H14
    inc hl
    ld (hl),14h

    ;POKE &H5690, &H9A : REM SCRTAB(16) = &H9A
    inc hl
    ld (hl),9ah

    ;POKE &H5691, &H11 : REM SCRTAB(17) = &H11
    inc hl
    ld (hl),11h

    ;POKE &H5692, &H9C : REM SCRTAB(18) = &H9C
    inc hl
    ld (hl),9ch

    ;POKE &H5693, &H1A : REM SCRTAB(19) = &H1A
    inc hl
    ld (hl),1ah

    ;POKE &H5694, &H9D : REM SCRTAB(20) = &H9D
    inc hl
    ld (hl),9dh

    ;POKE &H5695, &H1A : REM SCRTAB(21) = &H1A
    inc hl
    ld (hl),1ah

    ;POKE &H5696, &H99 : REM SCRTAB(22) = &H99
    inc hl
    ld (hl),99h

    ;POKE &H5697, &H00 : REM SCRTAB(23) = &H00
    inc hl
    ld (hl),00h

    ;POKE &H5698, &H9F : REM SCRTAB(24) = &H9F
    inc hl
    ld (hl),9fh

    ;POKE &H5699, &H00 : REM SCRTAB(25) = &H00
    inc hl
    ld (hl),00h

    ;POKE &H569A, &H00 : REM SCRTAB(26) = &H00
    inc hl
    ld (hl),00h

    ;GOTO l1a2ah
    jp l1a2ah

hz1500:
    ;REM Terminal settings for Hazeltine HZ-1500

    ;POKE &H5668, &H1B : REM LEADIN = &H1B
    ld hl,5668h
    ld (hl),1bh

    ;POKE &H566A, &H20 : REM ROWOFF = &H20
    inc hl
    inc hl
    ld (hl),20h

    ;POKE &H566B, &H20 : REM COLOFF = &H20
    inc hl
    ld (hl),20h

    ;POKE &H5669, &H00 : REM ORDER = &H00
    dec hl
    dec hl
    ld (hl),00h

    ;POKE &H5680, &H0B1 : REM SCRTAB(0) = &H0B1
    ld hl,5680h
    ld (hl),0b1h

    ;POKE &H5681, &H04 : REM SCRTAB(1) = &H04
    inc hl
    ld (hl),04h

    ;POKE &H5682, &H0B2 : REM SCRTAB(2) = &H0B2
    inc hl
    ld (hl),0b2h

    ;POKE &H5683, &H05 : REM SCRTAB(3) = &H05
    inc hl
    ld (hl),05h

    ;POKE &H5684, &H0B3 : REM SCRTAB(4) = &H0B3
    inc hl
    ld (hl),0b3h

    ;POKE &H5685, &H06 : REM SCRTAB(5) = &H06
    inc hl
    ld (hl),06h

    ;POKE &H5686, &H0EA : REM SCRTAB(6) = &H0EA
    inc hl
    ld (hl),0eah

    ;POKE &H5687, &H0E : REM SCRTAB(7) = &H0E
    inc hl
    ld (hl),0eh

    ;POKE &H5688, &H0EB : REM SCRTAB(8) = &H0EB
    inc hl
    ld (hl),0ebh

    ;POKE &H5689, &H0F : REM SCRTAB(9) = &H0F
    inc hl
    ld (hl),0fh

    ;POKE &H568A, &H0D1 : REM SCRTAB(10) = &H0D1
    inc hl
    ld (hl),0d1h

    ;POKE &H568B, &H1C : REM SCRTAB(11) = &H1C
    inc hl
    ld (hl),1ch

    ;POKE &H568C, &H0D7 : REM SCRTAB(12) = &H0D7
    inc hl
    ld (hl),0d7h

    ;POKE &H568D, &H1D : REM SCRTAB(13) = &H1D
    inc hl
    ld (hl),1dh

    ;POKE &H568E, &H0C5 : REM SCRTAB(14) = &H0C5
    inc hl
    ld (hl),0c5h

    ;POKE &H568F, &H11 : REM SCRTAB(15) = &H11
    inc hl
    ld (hl),11h

    ;POKE &H5690, &H0D2 : REM SCRTAB(16) = &H0D2
    inc hl
    ld (hl),0d2h

    ;POKE &H5691, &H12 : REM SCRTAB(17) = &H12
    inc hl
    ld (hl),12h

    ;POKE &H5692, &H0D4 : REM SCRTAB(18) = &H0D4
    inc hl
    ld (hl),0d4h

    ;POKE &H5693, &H13 : REM SCRTAB(19) = &H13
    inc hl
    ld (hl),13h

    ;POKE &H5694, &H0F4 : REM SCRTAB(20) = &H0F4
    inc hl
    ld (hl),0f4h

    ;POKE &H5695, &H13 : REM SCRTAB(21) = &H13
    inc hl
    ld (hl),13h

    ;POKE &H5696, &H0D9 : REM SCRTAB(22) = &H0D9
    inc hl
    ld (hl),0d9h

    ;POKE &H5697, &H14 : REM SCRTAB(23) = &H14
    inc hl
    ld (hl),14h

    ;POKE &H5698, &H0F9 : REM SCRTAB(24) = &H0F9
    inc hl
    ld (hl),0f9h

    ;POKE &H5699, &H14 : REM SCRTAB(25) = &H14
    inc hl
    ld (hl),14h

    ;POKE &H569A, &H0AB : REM SCRTAB(26) = &H0AB
    inc hl
    ld (hl),0abh

    ;POKE &H569B, &H1A : REM SCRTAB(27) = &H1A
    inc hl
    ld (hl),1ah

    ;POKE &H569C, &H0AA : REM SCRTAB(28) = &H0AA
    inc hl
    ld (hl),0aah

    ;POKE &H569D, &H1A : REM SCRTAB(29) = &H1A
    inc hl
    ld (hl),1ah

    ;POKE &H569E, &H0BA : REM SCRTAB(30) = &H0BA
    inc hl
    ld (hl),0bah

    ;POKE &H569F, &H1A : REM SCRTAB(31) = &H1A
    inc hl
    ld (hl),1ah

    ;POKE &H56A0, &H0BB : REM SCRTAB(32) = &H0BB
    inc hl
    ld (hl),0bbh

    ;POKE &H56A1, &H1A : REM SCRTAB(33) = &H1A
    inc hl
    ld (hl),1ah

    ;POKE &H56A2, &H0DA : REM SCRTAB(34) = &H0DA
    inc hl
    ld (hl),0dah

    ;POKE &H56A3, &H1A : REM SCRTAB(35) = &H1A
    inc hl
    ld (hl),1ah

    ;POKE &H56A4, &H0BD : REM SCRTAB(36) = &H0BD
    inc hl
    ld (hl),0bdh

    ;POKE &H56A5, &H1B : REM SCRTAB(37) = &H1B
    inc hl
    ld (hl),1bh

    ;POKE &H56A6, &H0A8 : REM SCRTAB(38) = &H0A8
    inc hl
    ld (hl),0a8h

    ;POKE &H56A7, &H00 : REM SCRTAB(39) = &H00
    inc hl
    ld (hl),00h

    ;POKE &H56A8, &H0A9 : REM SCRTAB(40) = &H0A9
    inc hl
    ld (hl),0a9h

    ;POKE &H56A9, &H00 : REM SCRTAB(41) = &H00
    inc hl
    ld (hl),00h

    ;POKE &H56AA, &H00 : REM SCRTAB(42) = &H00
    inc hl
    ld (hl),00h

l1a2ah:
    ;RETURN
    ret

sub_1a2bh:
    ;PRINT "New clock frequency ? ";
    ld bc,new_clock
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

    ;PRINT "Pet terminal parameters"
    ld bc,pet_params
    call print_str_eol

    ;PRINT "--- -------- ----------"
    ld bc,pet_dashes
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "1.  Columns in DIR listing :  ";
    ld bc,cols_in_dir
    call print_str

    ld a,(44b2h)        ;1a61 3a b2 44
    or a                ;1a64 b7
    jp nz,l1a6eh        ;1a65 c2 6e 1a
    ld hl,cols_1        ;1a68 21 67 20
    jp l1a7fh           ;1a6b c3 7f 1a
l1a6eh:
    ld a,(44b2h)        ;1a6e 3a b2 44
    cp 01h              ;1a71 fe 01
    jp nz,l1a7ch        ;1a73 c2 7c 1a
    ld hl,cols_2        ;1a76 21 69 20
    jp l1a7fh           ;1a79 c3 7f 1a
l1a7ch:
    ld hl,cols_4        ;1a7c 21 6b 20
l1a7fh:
    ld b,h              ;1a7f 44
    ld c,l              ;1a80 4d
    call print_str_eol  ;1a81 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT "2.  CRT in upper case mode :  ";
    ld bc,crt_in_upper
    call print_str

    ld a,(5667h)        ;1a8d 3a 67 56
    and 80h             ;1a90 e6 80
    jp z,l1a9bh         ;1a92 ca 9b 1a
    ld hl,upper_yes     ;1a95 21 8c 20
    jp l1a9eh           ;1a98 c3 9e 1a
l1a9bh:
    ld hl,upper_no      ;1a9b 21 90 20
l1a9eh:
    ld b,h              ;1a9e 44
    ld c,l              ;1a9f 4d
    call print_str_eol  ;1aa0 cd a9 01

    ;PRINT
    call print_eol

    ;PRINT "3.  CRT terminal emulation :  ";
    ld bc,crt_term_emu
    call print_str

    ld a,(5667h)        ;1aac 3a 67 56
    and 7fh             ;1aaf e6 7f
    jp nz,l1abah        ;1ab1 c2 ba 1a
    ld hl,emu_adm3a     ;1ab4 21 b2 20
    jp l1af9h           ;1ab7 c3 f9 1a
l1abah:
    ld a,(5667h)        ;1aba 3a 67 56
    and 7fh             ;1abd e6 7f
    cp 02h              ;1abf fe 02
    jp nz,l1acah        ;1ac1 c2 ca 1a
    ld hl,emu_tv912     ;1ac4 21 b8 20
    jp l1af9h           ;1ac7 c3 f9 1a
l1acah:
    ld a,(5667h)        ;1aca 3a 67 56
    and 7fh             ;1acd e6 7f
    cp 01h              ;1acf fe 01
    jp nz,l1af6h        ;1ad1 c2 f6 1a
    ld a,(5668h)        ;1ad4 3a 68 56
    cp 1bh              ;1ad7 fe 1b
    jp nz,l1ae2h        ;1ad9 c2 e2 1a
    ld hl,emu_hz_esc    ;1adc 21 be 20
    jp l1af3h           ;1adf c3 f3 1a
l1ae2h:
    ld a,(5668h)        ;1ae2 3a 68 56
    cp 7eh              ;1ae5 fe 7e
    jp nz,l1af0h        ;1ae7 c2 f0 1a
    ld hl,emu_hz_tilde  ;1aea 21 da 20
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
    ld bc,clock_freq
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
    ld bc,alter_which_1_4
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
    ;IF N <> 1 THEN GOTO l1b3ch
    ld hl,(nn)
    dec hl
    ld a,h
    or l
    jp nz,l1b3ch

    ;REM User selected 1. Columns in DIR listing

    ;GOSUB sub_1879h
    call sub_1879h

    ;GOTO l1b6ch
    jp l1b6ch

l1b3ch:
    ;IF N <> 2 THEN GOTO l1b4ch
    ld hl,(nn)
    dec hl
    dec hl
    ld a,h
    or l
    jp nz,l1b4ch

    ;REM User selected 2. CRT in uppercase mode

    ;GOSUB sub_18bah
    call sub_18bah

    ;GOTO l1b6ch
    jp l1b6ch

l1b4ch:
    ;IF N <> 3 THEN GOTO l1b5dh
    ld hl,(nn)
    dec hl
    dec hl
    dec hl
    ld a,h
    or l
    jp nz,l1b5dh

    ;REM User selected 3. CRT terminal emulation

    ;GOSUB sub_18c3h
    call sub_18c3h

    ;GOTO l1b6ch
    jp l1b6ch

l1b5dh:
    ;IF N <> 4 THEN GOTO l1b6ch
    ld bc,-4
    ld hl,(nn)
    add hl,bc
    ld a,h
    or l
    jp nz,l1b6ch

    ;REM User selected 4. Clock frequency

    ;GOSUB sub_1a2bh
    call sub_1a2bh

l1b6ch:
    ;GOTO l1a46h
    jp l1a46h

    ;RETURN
    ret

new_char_len:
    db 1fh
    db "New charater length (5 to 8) ? "

num_stop_bits:
    db 1fh
    db "Number of stop bits (1 or 2) ? "

odd_even_none:
    db 20h
    db "O(dd), E(ven), or N(o) parity ? "

ask_bauds:
    db 2ch
    db "110, 300, 1200, 4800, 9600, or 19200 baud ? "

rs232_chrs:
    db 16h
    db "RS232 Characteristics."

rs232_dashes:
    db 16h
    db "----- ----------------"

rs232_1_chr:
    db 17h
    db " 1.  Character size :",tab,tab

rs232_2_stop:
    db 1bh
    db " 2.  Number of stop bits :",tab

stops_1:
    db 01h
    db "1"

stops_1_5:
    db 03h
    db "1.5"

stops_2:
    db 01h
    db "2"

stops_undef:
    db 09h
    db "undefined"

rs232_3_par:
    db 10h
    db " 3.  Parity :",tab,tab,tab

parity_none:
    db 04h
    db "none"

parity_even:
    db 04h
    db "even"

parity_odd:
    db 04h
    db "odd "

parity_blank:
    db 04h
    db "    "

rs232_4_baud:
    db 12h
    db " 4.  Baud rate :",tab,tab

baud_110:
    db 05h
    db "110  "

baud_300:
    db 05h
    db "300  "

baud_1200:
    db 05h
    db "1200 "

baud_4800:
    db 05h
    db "4800 "

baud_9600:
    db 05h
    db "9600 "

baud_19200:
    db 05h
    db "19200"

baud_blank:
    db 05h
    db "     "

alter_which:
    db 1dh
    db "Alter which characteristic ? "

tty_rs232:
    db 16h
    db "T(TY: -- RS232 printer"

crt_pet_scrn:
    db 13h
    db "C(RT: -- PET screen"

lpt_pet:
    db 19h
    db "L(PT: -- PET IEEE printer"

ul1_ascii:
    db 1bh
    db "U(L1: -- ASCII IEEE printer"

which_list_dev:
    db 23h
    db "Which list device (T, C, L or U) ? "

tty_or_ptr:
    db 13h
    db "T(TY:) or P(TR:) ? "

tty_or_ptp:
    db 13h
    db "T(TY:) or P(TP:) ? "

for_cbm3032:
    db 20h
    db "3 = 3022 or 3023 or 4022 or 4023"

for_cbm8024:
    db 08h
    db "8 = 8024"

for_dwheel:
    db 1dh
    db "D = 8026 or 8027 (Daisywheel)"

which_printer:
    db 25h
    db "Which type of printer (3, 8, or D) ? "

io_dev_asgn:
    db 16h
    db "I/O Device Assignment."

io_dashes:
    db 16h
    db "--- ------ -----------"

io_lpt_device:
    db 1ch
    db " 1.  PET Printer device # :",tab

io_ul1_device:
    db 1bh
    db " 2.  ASCII list device # :",tab

io_rdr_device:
    db 18h
    db " 3.  Reader device # :",tab,tab

io_pun_device:
    db 17h
    db " 4.  Punch device # :",tab,tab

io_lst_device:
    db 1bh
    db " 5.  Default LST: device :",tab

lst_tty:
    db 04h
    db "TTY:"

lst_crt:
    db 04h
    db "CRT:"

lst_lpt:
    db 04h
    db "LPT:"

lst_blank:
    db 04h
    db "   :"

io_default_rdr:
    db 1bh
    db " 6.  Default RDR: device :",tab

rdr_tty:
    db 04h
    db "TTY:"

rdr_ptr:
    db 04h
    db "PTR:"

io_default_pun:
    db 1bh
    db " 7.  Default PUN: device :",tab

pun_tty:
    db 04h
    db "TTY:"

pun_ptp:
    db 04h
    db "PTP:"

io_pet_prntr:
    db 1bh
    db " 8.  PET Printer type :   ",tab

prntr_for_cbm3032:
    db 09h
    db "3022/4022"

prntr_dwheel:
    db 09h
    db "8026/8027"

prntr_cbm8024:
    db 04h
    db "8024"

prntr_blank:
    db 04h
    db "    "

alter_which_1_8:
    db 23h
    db "Alter which characteristic (1-8) ? "

new_dev_num:
    db 0fh
    db "New device # ? "

num_of_cols:
    db 20h
    db "Number of columns (1, 2 or 4) ? "

screen_type:
    db 2ch
    db "Screen type A(DM3A), H(Z1500), or T(V912) ? "

esc_or_tilde:
    db 23h
    db "Lead-in code E(scape) or T(ilde) ? "

new_clock:
    db 16h
    db "New clock frequency ? "

pet_params:
    db 17h
    db "Pet terminal parameters"

pet_dashes:
    db 17h
    db "--- -------- ----------"

cols_in_dir:
    db 1eh
    db "1.  Columns in DIR listing :  "

cols_1:
    db 01h
    db "1"

cols_2:
    db 01h
    db "2"

cols_4:
    db 01
    db "4"

crt_in_upper:
    db 1eh
    db "2.  CRT in upper case mode :  "

upper_yes:
    db 03h
    db "Yes"

upper_no:
    db 02h
    db "No"

crt_term_emu:
    db 1eh
    db "3.  CRT terminal emulation :  "

emu_adm3a:
    db 05h
    db "ADM3A"

emu_tv912:
    db 05h
    db "TV912"

emu_hz_esc:
    db 1bh
    db "HZ1500",tab,tab,tab,"(Lead-in = ESCAPE)"

emu_hz_tilde:
    db 1ah
    db "HZ1500",tab,tab,tab,"(Lead-in = TILDE)"

l20f5h:
    db 06h
    db "      "

l20fch:
    db 06h
    db "      "

clock_freq:
    db 1eh
    db "4.  Clock frequency (Hz) :    "

alter_which_1_4:
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
    ld (cbmdos_track),a
    call dskdev         ;Get device address for a CP/M drive number
    ld e,00h
    push de
    call open_cpm
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
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
    call open_k
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
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
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
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

open_cpm:
;Open "CP/M" file on an IEEE-488 drive
    ld c,l2410h_len
    ld hl,l2410h        ;"0:CP/M"
    ld a,(cbmdos_track)
    rra
    jp nc,open          ;Open a file on an IEEE-488 device
    ld hl,l2416h        ;"1:CP/M"
    jp open             ;Open a file on an IEEE-488 device

open_k:
;Open "K" file on an IEEE-488 drive
    ld c,l241ch_len
    ld hl,l241ch        ;"0:K"
    ld a,(cbmdos_track)
    rra
    jp nc,open          ;Open a file on an IEEE-488 device
    ld hl,l241fh        ;"1:K"
    jp open             ;Open a file on an IEEE-488 device

savesy:
;Read the CP/M system image from an IEEE-488 drive.
    ld a,c
    ld (cbmdos_track),a
    call dskdev         ;Get device address for a CP/M drive number
    push de
    ld e,0fh
    ld hl,l2408h        ;"S0:*"
    ld a,(cbmdos_track)
    rra
    jr nc,l2256h
    ld hl,l240ch        ;"S1:*"
l2256h:
    ld c,l2408h_len
    call open           ;Open a file on an IEEE-488 device
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
    pop de
    cp 01h
    ret nz
    ld e,01h
    push de
    call open_k
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
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
    call open_cpm
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
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
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
    ret

format:
;Format an IEEE-488 drive for SoftBox use.
    ld a,c
    ld (cbmdos_track),a
    call dskdev         ;Get device address for a CP/M drive number
    ld a,(cbmdos_track)
    and 01h
    add a,'0'
    ld (l23e3h+1),a
    ld e,0fh
    ld c,l23e3h_len
    ld hl,l23e3h        ;"N0:CP/M V2.2 DISK,XX"
    call open           ;Open a file on an IEEE-488 device
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
    or a
    ret nz
    ld a,(cbmdos_track)
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
    ld a,(cbmdos_track)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (cbmdos_sector),a
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
    ld a,(cbmdos_track)
    call diskcmd        ;Open the command channel on IEEE-488 device
    call ieeemsg        ;Send string to the current IEEE-488 device
    ld a,(4000h)
    call wreoi          ;Send byte to IEEE-488 device with EOI asserted
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld hl,l23f7h        ;"B-P 2 1"
    ld c,l23f7h_len
    ld a,(cbmdos_track)
    call diskcmd        ;Open the command channel on IEEE-488 device
    call ieeemsg        ;Send string to the current IEEE-488 device
    call creoi          ;Send carriage return to IEEE-488 dev with EOI
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld a,(cbmdos_track)
    call dskdev         ;Get device address for a CP/M drive number
    ld e,02h
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,4001h
    ld c,0ffh
    call ieeemsg        ;Send string to the current IEEE-488 device
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld a,(cbmdos_track)
    call diskcmd        ;Open the command channel on IEEE-488 device
    ld hl,l23deh        ;"U2 2 "
    ld c,l23deh_len
    call ieeemsg        ;Send string to the current IEEE-488 device
    ld a,(cbmdos_track)
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

cbmdos_track:
    db 0                ;CBM DOS track number
cbmdos_sector:
    db 0                ;CBM DOS sector number

; End of LOADSAV2.REL =======================================================

buffer:                 ;User input buffer struct
buff_size:
    db 0                ;  Buffer size (contain 128) as byte
buff_len:
    db 0                ;  Used buffer length as byte
buff_data:              ;  80 bytes input buffer
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

l2476h:
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0

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

stoptmp:
    db 0                ;Temporarily holds USART mode for showing stop bits
iochoice:
    db 0                ;Temporarily holds menu selection for I/O assignments

    db 0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
