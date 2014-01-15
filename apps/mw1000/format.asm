;FORMAT.COM
;  Format a disk for use with SoftBox CP/M (MW-1000 version).
;
;Both CBM floppy drives and MW-1000 hard drives are supported.  For a CBM
;floppy, the disk may be unformatted because the program will first format it
;with CBM DOS before writing the CP/M filesystem.  For an MW-1000 hard drive,
;the drive must already have been low-level formatted using MWFORMAT.COM.
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

dtype:
;Get the drive type for a CP/M drive number.
;
;C = CP/M drive number
;
;Returns the drive type in A.
;
    ld hl,dtype_tmp     ;HL = address of temporary variable
    ld (hl),c           ;Save the CP/M drive number in the temp var
    ld a,(dtype_tmp)    ;A = CP/M drive number

    call tstdrv         ;Get drive type for a CP/M drive number (BIOS)
    ld a,c              ;A = drive type
    ret

    ld a,00h            ;010f 3e 00
    ret                 ;0111 c9
    ret                 ;0112 c9

idisk:
;Initialize an IEEE-488 disk drive.
;
;C = CP/M drive number
;
    ld hl,idisk_tmp     ;HL = address of temporary variable
    ld (hl),c           ;Save the CP/M drive number in the temp var
    ld a,(idisk_tmp)    ;A = CP/M drive number

    call idrive         ;Initialize an IEEE-488 disk drive (BIOS)
    ret

dskerr:
;Check the last CBM DOS error code.  If an error occurred,
;print it from the buffer before returning.
;
;Returns the CBM DOS error code in A.
;
    ;IF dos_err = 0 THEN GOTO dskerr_ret
    ld a,(dos_err)
    or a
    jp z,dskerr_ret

    ;PRINT "Disk error :  ";
    ld bc,disk_error
    call print_str

    ;eindex = 0
    ld hl,eindex
    ld (hl),00h

    ;GOTO dskerr_next
    jp dskerr_next

dskerr_char:
    ;PRINT errbuf(eindex);
    ld a,(eindex)
    ld l,a
    rla
    sbc a,a
    ld bc,errbuf
    ld h,a
    add hl,bc
    ld c,(hl)
    call print_char

    ;IF errbuf(eindex) = &H0D THEN GOTO dskerr_eol  ' End of error message
    ld a,(eindex)
    ld l,a
    rla
    sbc a,a
    ld bc,errbuf
    ld h,a
    add hl,bc
    ld a,(hl)
    cp cr
    jp z,dskerr_eol

    ;eindex = eindex + 1
    ld hl,eindex
    inc (hl)

dskerr_next:
    ;IF eindex < 64 THEN GOTO dskerr_char  ' Loop until end of message buffer
    ld a,(eindex)
    cp 64
    jp m,dskerr_char

dskerr_eol:
    ;PRINT
    call print_eol

dskerr_ret:
    ;RETURN dos_err
    ld a,(dos_err)
    ret

    ret                 ;0166 c9

end:
;Jump to CP/M warm start
;Implements END command
    jp warm             ;Warm start entry point
    ret

print_char:
;Print character in C
    ld hl,l30adh
    ld (hl),c
    ld c,cwrite
    ld a,(l30adh)
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
    ld hl,l30aeh+1
    ld (hl),b
    dec hl
    ld (hl),c
    ld hl,(l30aeh)
    ld a,(hl)
    ld (l30b0h),a
l0191h:
    ld hl,(l30aeh)
    inc hl
    ld (l30aeh),hl
    ld hl,(l30aeh)
    ld c,(hl)
    call print_char
    ld hl,l30b0h
    dec (hl)
    ld a,(hl)
    or a
    jp nz,l0191h
    ret

print_str_eol:
;Print string at BC followed by CR+LF
    ld hl,l30b1h+1
    ld (hl),b
    dec hl
    ld (hl),c
    ld hl,(l30b1h)
    ld b,h
    ld c,l
    call print_str
    call print_eol
    ret

sub_01bbh:
    call sub_0a46h      ;01bb cd 46 0a
    db 00h, 02h
    dw l30b3h
    ld hl,30b3h+1       ;01c2 21 b4 30
    ld (hl),b           ;01c5 70
    dec hl              ;01c6 2b
    ld (hl),c           ;01c7 71
    ld hl,(l30b3h)      ;01c8 2a b3 30
    ld a,l              ;01cb 7d
    or h                ;01cc b4
    jp z,l01f0h         ;01cd ca f0 01
    ld hl,(l30b3h)      ;01d0 2a b3 30
    ld b,h              ;01d3 44
    ld c,l              ;01d4 4d
    ld de,10            ;01d5 11 0a 00
    call sub_09bah      ;01d8 cd ba 09 (Library DIV)
    call sub_01bbh      ;01db cd bb 01
    ld hl,(l30b3h)      ;01de 2a b3 30
    ld b,h              ;01e1 44
    ld c,l              ;01e2 4d
    ld de,10            ;01e3 11 0a 00
    call sub_09bah      ;01e6 cd ba 09 (Library DIV)
    ld a,l              ;01e9 7d
    add a,'0'           ;01ea c6 30
    ld c,a              ;01ec 4f
    call print_char     ;01ed cd 6b 01
l01f0h:
    call sub_0a89h      ;01f0 cd 89 0a
    db 02h
    dw l30b3h

print_int:
    ld hl,l30b5h+1      ;01f6 21 b6 30
    ld (hl),b           ;01f9 70
    dec hl              ;01fa 2b
    ld (hl),c           ;01fb 71
    ld hl,(l30b5h)      ;01fc 2a b5 30
    ld a,l              ;01ff 7d
    or h                ;0200 b4
    jp nz,l020dh        ;0201 c2 0d 02

    ;PRINT "0";
    ld bc,zero
    call print_str

    jp l0215h           ;020a c3 15 02
l020dh:
    ld hl,(l30b5h)      ;020d 2a b5 30
    ld b,h              ;0210 44
    ld c,l              ;0211 4d
    call sub_01bbh      ;0212 cd bb 01
l0215h:
    ret                 ;0215 c9

readline:
    ;buff_size = 80
    ld hl,buff_size
    ld (hl),50h

    ld de,buffer        ;021b 11 08 30
    ld c,creadstr       ;021e 0e 0a
    call bdos           ;BDOS entry point

    ;N = 0
    ;H = 0
    ld hl,0000h
    ld (nn),hl
    ld (hh),hl

    ;IF buff_len <> 0 THEN GOTO l023bh
    ld a,(buff_len)     ;022c 3a 09 30
    or a                ;022f b7
    jp nz,l023bh        ;0230 c2 3b 02

    ;R = &H0D
    ld hl,rr
    ld (hl),cr

    ;GOTO l02ffh
    jp l02ffh           ;0238 c3 ff 02

l023bh:
    ;l30b7h = 1
    ;l30b9h = buff_len
    ld hl,l30b7h        ;023b 21 b7 30
    ld (hl),01h         ;023e 36 01
    ld a,(buff_len)     ;0240 3a 09 30
    inc hl              ;0243 23
    inc hl              ;0244 23
    ld (hl),a           ;0245 77

    ;GOTO l02efh
    jp l02efh

l0249h:
    ;l30b8h = buff_data(l30b7h-1)
    ld a,(l30b7h)       ;0249 3a b7 30
    ld l,a              ;024c 6f
    rla                 ;024d 17
    sbc a,a             ;024e 9f
    ld bc,buff_data-1   ;024f 01 09 30
    ld h,a              ;0252 67
    add hl,bc           ;0253 09
    ld a,(hl)           ;0254 7e
    ld (l30b8h),a       ;0255 32 b8 30

    ;l3059h(l30b7h) = l30b8h
    ;IF l30b8h < &H61 OR l30b8h > &H7A THEN GOTO l0278h
    ld a,(l30b7h)       ;0258 3a b7 30
    ld l,a              ;025b 6f
    rla                 ;025c 17
    sbc a,a             ;025d 9f
    ld bc,l3059h        ;025e 01 59 30
    ld h,a              ;0261 67
    add hl,bc           ;0262 09
    ld a,(l30b8h)       ;0263 3a b8 30
    ld (hl),a           ;0266 77
    cp 'a'              ;0267 fe 61
    jp m,l0278h         ;0269 fa 78 02
    cp 'z'+1            ;026c fe 7b
    jp p,l0278h         ;026e f2 78 02

    ;l30b8h = l30b8h - &H20
    ld hl,l30b8h        ;0271 21 b8 30
    ld a,(hl)           ;0274 7e
    add a,0-('a'-'A')   ;0275 c6 e0
    ld (hl),a           ;0277 77

l0278h:
    ;buff_data(l30b7h-1) = l30b8h
    ld a,(l30b7h)       ;0278 3a b7 30
    ld l,a              ;027b 6f
    rla                 ;027c 17
    sbc a,a             ;027d 9f
    ld bc,buff_data-1   ;027e 01 09 30
    ld h,a              ;0281 67
    add hl,bc           ;0282 09
    ld a,(l30b8h)       ;0283 3a b8 30
    ld (hl),a           ;0286 77

    ;l30b8h = l30b8h - &H30
    ;IF l30b8h < 0 OR l30b8h > 9 THEN GOTO l02c5h
    ld hl,l30b8h        ;0287 21 b8 30
    ld a,(hl)           ;028a 7e
    add a,0-'0'         ;028b c6 d0
    ld (hl),a           ;028d 77
    or a                ;028e b7
    jp m,l02c5h         ;028f fa c5 02
    cp 9+1              ;0292 fe 0a
    jp p,l02c5h         ;0294 f2 c5 02

    ;N = l30b8h + N * 10
    ld hl,(nn)          ;0297 2a 04 30
    ld b,h              ;029a 44
    ld c,l              ;029b 4d
    ld de,10            ;029c 11 0a 00
    call sub_095eh      ;029f cd 5e 09 (Library MUL)
    ld a,(l30b8h)       ;02a2 3a b8 30
    ld l,a              ;02a5 6f
    rla                 ;02a6 17
    sbc a,a             ;02a7 9f
    ld h,a              ;02a8 67
    add hl,de           ;02a9 19
    ld (nn),hl          ;02aa 22 04 30

    ;H = l30b8h + H * 16
    ld c,04h            ;02ad 0e 04
    ld hl,(hh)          ;02af 2a 06 30
    jp l02b6h           ;02b2 c3 b6 02
l02b5h:
    add hl,hl           ;02b5 29
l02b6h:
    dec c               ;02b6 0d
    jp p,l02b5h         ;02b7 f2 b5 02
    ld a,(l30b8h)       ;02ba 3a b8 30
    ld c,a              ;02bd 4f
    rla                 ;02be 17
    sbc a,a             ;02bf 9f
    ld b,a              ;02c0 47
    add hl,bc           ;02c1 09
    ld (hh),hl          ;02c2 22 06 30

l02c5h:
    ;REM Check for hexadecimal digits A - F
    ;l30b8h = l30b8h - 7
    ;IF l30b8h < 10 OR l30b8h > 15 THEN GOTO l02ebh
    ld hl,l30b8h        ;02c5 21 b8 30
    ld a,(hl)           ;02c8 7e
    add a,0-('A'-'9'-1) ;02c9 c6 f9
    ld (hl),a           ;02cb 77
    cp 10               ;02cc fe 0a
    jp m,l02ebh         ;02ce fa eb 02
    cp 15+1             ;02d1 fe 10
    jp p,l02ebh         ;02d3 f2 eb 02

    ;H = l30b8h + H * 16
    ld c,04h            ;02d6 0e 04
    ld hl,(hh)          ;02d8 2a 06 30
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
    ld (hh),hl          ;02e8 22 06 30

l02ebh:
    ;l30b7h = l30b7h + 1
    ld hl,l30b7h        ;02eb 21 b7 30
    inc (hl)            ;02ee 34

l02efh:
    ;IF l30b9h > l30b7h THEN GOTO l0249h
    ld a,(l30b9h)       ;02ef 3a b9 30
    ld hl,l30b7h        ;02f2 21 b7 30
    cp (hl)             ;02f5 be
    jp p,l0249h         ;02f6 f2 49 02

    ;R = buff_data(0)
    ld a,(buff_data)    ;02f9 3a 0a 30
    ld (rr),a           ;02fc 32 03 30

l02ffh:
    ret                 ;02ff c9

start:
    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Disk formatting program"
    ld bc,format_prog
    call print_str_eol

    ;PRINT "For Softbox CP/M"
    ld bc,for_softbox
    call print_str_eol

    ;PRINT "=== ======= ===="
    ld bc,dashes
    call print_str_eol

    ;PRINT
    call print_eol

    ;PRINT "Revision 2.2  9-Mar-1984"
    ld bc,revision
    call print_str_eol

l0321h:
    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Format disk on which drive"
    ld bc,on_which_drv
    call print_str_eol

    ;PRINT "(A to P, or RETURN to reboot) ? ";
    ld bc,a_to_p
    call print_str

    ;GOSUB readline
    call readline

    ;PRINT
    call print_eol

    ;IF R <> &H0D THEN GOTO l0344h
    ld a,(rr)
    cp cr
    jp nz,l0344h

    ;END
    call end            ;Never returns

l0344h:
    ;D = R - &H41
    ;IF D >= 0 AND D <= 15 THEN GOTO l035eh
    ld a,(rr)           ;0344 3a 03 30
    add a,0-'A'         ;0347 c6 bf
    ld (dd),a           ;0349 32 00 30
    or a                ;034c b7
    jp m,l0355h         ;034d fa 55 03
    cp 15+1             ;0350 fe 10
    jp m,l035eh         ;0352 fa 5e 03

l0355h:
    ;PRINT "Drive doesn't exist !"
    ld bc,doesnt_exist
    call print_str_eol

    ;GOTO l0321h
    jp l0321h

l035eh:
    ;drv_typ = DTYPE(D)
    ;IF drv_typ < 128 THEN GOTO l0376h
    ld hl,dd            ;035e 21 00 30
    ld c,(hl)           ;0361 4e
    call dtype          ;0362 cd 03 01
    ld (drv_typ),a      ;0365 32 01 30
    and 80h             ;0368 e6 80
    jp z,l0376h         ;036a ca 76 03

    ;PRINT "Drive not in system"
    ld bc,not_in_sys
    call print_str_eol

    ;GOTO l0321h
    jp l0321h

l0376h:
    ;IF drv_typ < 2 OR drv_typ > 5 THEN GOTO l03c7h
    ld a,(drv_typ)
    cp 2
    jp m,l03c7h
    cp 5+1
    jp p,l03c7h

    ;PRINT CHR$(7) ' Bell
    ld c,bell
    call print_char

    ;PRINT "Data on hard disk ";
    ld bc,data_on_hd
    call print_str

    ;PRINT CHR$(D + &H41);
    ld a,(dd)
    add a,'A'           ;Convert to CP/M drive letter
    ld c,a
    call print_char

    ;PRINT ": will be erased"
    ld bc,will_be_eras
    call print_str_eol

    ;PRINT "Proceed (Y/N) ? ";
    ld bc,proceed_yn
    call print_str

    ;GOSUB readline
    call readline

    ;IF R = &H59 THEN GOTO l03b1h
    ld a,(rr)
    cp 'Y'
    jp z,l03b1h

    ;END
    call end            ;Never returns

l03b1h:
    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Formatting..."
    ld bc,formatting_hd
    call print_str_eol

    ;CALL cform(D)
    ld hl,dd            ;03bd 21 00 30
    ld c,(hl)           ;03c0 4e
    call cform          ;03c1 cd 21 08

    ;GOTO l0419h
    jp l0419h

l03c7h:
    ;PRINT "Disk on drive ";
    ld bc,disk_on_drv
    call print_str

    ;PRINT CHR$(D + &H41);
    ld a,(dd)
    add a,'A'           ;Convert to CP/M drive letter
    ld c,a
    call print_char

    ;PRINT ": is to be formatted"
    ld bc,be_formatted
    call print_str_eol

    ;PRINT "Press RETURN to continue, ^C to abort : ";
    ld bc,press_return
    call print_str

    ;GOSUB readline
    call readline

    ;IF R = &H0D THEN GOTO l03f0h
    ld a,(rr)
    cp cr
    jp z,l03f0h

    ;END
    call end            ;Never returns

l03f0h:
    ;PRINT
    call print_eol

    ;PRINT "Formatting..."
    ld bc,formatting
    call print_str

    ;CALL format(D)
    ld hl,dd            ;03f9 21 00 30
    ld c,(hl)           ;03fc 4e
    call format         ;03fd cd 5d 07

    ;PRINT
    call print_eol      ;0400 cd 79 01

    ;IF CALL dskerr() <> 0 THEN GOTO l0413h
    call dskerr         ;0403 cd 1e 01
    or a                ;0406 b7
    jp nz,l0413h        ;0407 c2 13 04

    ;PRINT "Format complete"
    ld bc,complete
    call print_str_eol

    ;GOTO l0419h
    jp l0419h

l0413h:
    ;REM An error occurred from CBM DOS.  The error has already
    ;REM been printed to the screen by dskerr.

    ;PRINT "Do not use diskette - try again..."
    ld bc,bad_disk
    call print_str_eol

l0419h:
    ;GOTO l0321h
    jp l0321h

disk_error:
    db disk_error_len
    db "Disk error :  "
disk_error_len: equ $-disk_error-1

zero:
    db zero_len
    db "0"
zero_len: equ $-zero-1

format_prog:
    db format_prog_len
    db "Disk formatting program"
format_prog_len: equ $-format_prog-1

for_softbox:
    db for_softbox_len
    db "For Softbox CP/M"
for_softbox_len: equ $-for_softbox-1

dashes:
    db dashes_len
    db "=== ======= ===="
dashes_len: equ $-dashes-1

revision:
    db revision_len
    db "Revision 2.2  9-Mar-1984"
revision_len: equ $-revision-1

on_which_drv:
    db on_which_drv_len
    db "Format disk on which drive"
on_which_drv_len: equ $-on_which_drv-1

a_to_p:
    db a_to_p_len
    db "(A to P, or RETURN to reboot) ? "
a_to_p_len: equ $-a_to_p-1

doesnt_exist:
    db doesnt_exist_len
    db "Drive doesn't exist !"
doesnt_exist_len: equ $-doesnt_exist-1

not_in_sys:
    db not_in_sys_len
    db "Drive not in system"
not_in_sys_len: equ $-not_in_sys-1

data_on_hd:
    db data_on_hd_len
    db "Data on hard disk "
data_on_hd_len: equ $-data_on_hd-1

will_be_eras:
    db will_be_eras_len
    db ": will be erased"
will_be_eras_len: $-will_be_eras-1

proceed_yn:
    db proceed_yn_len
    db "Proceed (Y/N) ? "
proceed_yn_len: equ $-proceed_yn-1

formatting_hd:
    db formatting_hd_len
    db "Formatting hard disk directory"
formatting_hd_len: equ $-formatting_hd-1

disk_on_drv:
    db disk_on_drv_len
    db "Disk on drive "
disk_on_drv_len: equ $-disk_on_drv-1

be_formatted:
    db be_formatted_len
    db ": is to be formatted"
be_formatted_len: equ $-be_formatted-1

press_return:
    db press_return_len
    db "Press RETURN to continue, ^C to abort : "
press_return_len: equ $-press_return-1

formatting:
    db formatting_len
    db "Formatting..."
formatting_len: equ $-formatting-1

complete:
    db complete_len
    db "Format complete"
complete_len: equ $-complete-1

bad_disk:
    db bad_disk_len
    db "Do not use diskette - try again..."
bad_disk_len: equ $-bad_disk-1

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
    ld (l08b3h),a
    call dskdev         ;Get device address for a CP/M drive number
    ld e,00h
    push de
    call sub_06adh
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
    ld hl,4000h
    ld bc,1c00h
    pop de
    or a
    ret nz
    push de
    call talk           ;Send TALK to an IEEE-488 device
l05f9h:
    call rdieee         ;Read byte from an IEEE-488 device
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l05f9h
    call untalk         ;Send UNTALK to all IEEE-488 devices
    pop de
    push de
    call close          ;Close an open file on an IEEE-488 device
    pop de
    push de
    call sub_06bfh
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
    ld hl,6000h
    ld bc,0800h
    pop de
    or a
    ret nz
    push de
    call talk           ;Send TALK to an IEEE-488 device
l0626h:
    call rdieee         ;Read byte from an IEEE-488 device
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l0626h
    call untalk         ;Send UNTALK to all IEEE-488 devices
    pop de
    call close          ;Close an open file on an IEEE-488 device
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
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
    jp l0848h

sub_06adh:
;Open "CP/M" file on an IEEE-488 drive
    ld c,l08a1h_len
    ld hl,l08a1h        ;"0:CP/M"
    ld a,(l08b3h)
    rra
    jp nc,open          ;Open a file on an IEEE-488 device
    ld hl,l08a7h        ;"1:CP/M"
    jp open             ;Open a file on an IEEE-488 device

sub_06bfh:
;Open "K" file on an IEEE-488 drive
    ld c,l08adh_len
    ld hl,l08adh        ;"0:K"
    ld a,(l08b3h)
    rra
    jp nc,open          ;Open a file on an IEEE-488 device
    ld hl,l08b0h        ;"1:K"
    jp open             ;Open a file on an IEEE-488 device

savesy:
;Read the CP/M system image from an IEEE-488 drive.
    ld a,c
    ld (l08b3h),a
    call dskdev         ;Get device address for a CP/M drive number
    push de
    ld e,0fh
    ld hl,l0899h        ;"S0:*"
    ld a,(l08b3h)
    rra
    jr nc,l06e7h
    ld hl,l089dh        ;"S1:*"
l06e7h:
    ld c,l0899h_len
    call open           ;Open a file on an IEEE-488 device
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
    pop de
    cp 01h
    ret nz
    ld e,01h
    push de
    call sub_06bfh
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
    pop de
    or a
    ret nz
    push de
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,6000h
    ld bc,0800h
l0715h:
    ld a,(hl)
    call wrieee         ;Send byte to an IEEE-488 device
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l0715h
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    pop de
    push de
    call close          ;Close an open file on an IEEE-488 device
    pop de
    push de
    call sub_06adh
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
    pop de
    or a
    ret nz
    push de
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,4000h
    ld bc,1c00h
l0742h:
    ld a,(hl)
    call wrieee         ;Send byte to an IEEE-488 device
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l0742h
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    pop de
    call close          ;Close an open file on an IEEE-488 device
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
    ret

format:
;Format an IEEE-488 drive for SoftBox use.
    ld a,c
    ld (l08b3h),a
    call dskdev         ;Get device address for a CP/M drive number
    ld a,(l08b3h)
    and 01h
    add a,'0'
    ld (l0874h+1),a
    ld e,0fh
    ld c,l0874h_len
    ld hl,l0874h        ;"N0:CP/M V2.2 DISK,XX"
    call open           ;Open a file on an IEEE-488 device
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
    or a
    ret nz
    ld a,(l08b3h)
    call idrive         ;Initialize an IEEE-488 disk drive
    ld hl,4000h
    ld de,4001h
    ld bc,00ffh
    ld (hl),0e5h
    ldir
    ld a,0fh
    ld (l0898h),a
    ld a,01h
    ld (l0897h),a
l07a0h:
;Clear the CP/M directory by filling it with E5 ("unused").
    call sub_07b6h
    ld a,(l08b3h)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (l08b4h),a
    or a
    ret nz
    ld hl,l0898h
    dec (hl)
    jp p,l07a0h
    ret

sub_07b6h:
;Write a sector to an IEEE-488 drive.
    ld hl,l088fh        ;"M-W",00h,13h,01h
    ld c,l088fh_len
    ld a,(l08b3h)
    call diskcmd        ;Open the command channel on IEEE-488 device
    call ieeemsg        ;Send string to the current IEEE-488 device
    ld a,(4000h)
    call wreoi          ;Send byte to IEEE-488 device with EOI asserted
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld hl,l0888h        ;"B-P 2 1"
    ld c,l0888h_len
    ld a,(l08b3h)
    call diskcmd        ;Open the command channel on IEEE-488 device
    call ieeemsg        ;Send string to the current IEEE-488 device
    call creoi          ;Send carriage return to IEEE-488 dev with EOI
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld a,(l08b3h)
    call dskdev         ;Get device address for a CP/M drive number
    ld e,02h
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,4001h
    ld c,0ffh
    call ieeemsg        ;Send string to the current IEEE-488 device
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld a,(l08b3h)
    call diskcmd        ;Open the command channel on IEEE-488 device
    ld hl,l086fh        ;"U2 2 "
    ld c,l086fh_len
    call ieeemsg        ;Send string to the current IEEE-488 device
    ld a,(l08b3h)
    and 01h
    add a,'0'
    call wrieee         ;Send byte to an IEEE-488 device
    ld a,(l0897h)
    call ieeenum        ;Send number as decimal string to IEEE-488 dev
    ld a,(l0898h)
    call ieeenum        ;Send number as decimal string to IEEE-488 dev
    call creoi          ;Send carriage return to IEEE-488 dev with EOI
    jp unlisten         ;Send UNLISTEN to all IEEE-488 devices

cform:
;Format a hard drive for Softbox use.
    call seldsk         ;Select disk drive
    ld hl,0080h
l0827h:
    ld (hl),0e5h
    inc l
    jr nz,l0827h
    ld bc,0002h
    call settrk         ;Set track number
    ld bc,0000h
l0835h:
    push bc
    call setsec         ;Set sector number
    call write          ;Write selected sector
    pop bc
    or a
    jp nz,l0848h
    inc bc
    ld a,c
    cp 40h
    jr nz,l0835h
    ret

l0848h:
;Display "Hit any key to abort" message, wait for a key, and then return.
    ld de,l0855h        ;cr,lf,"Hit any key to abort : $"
    ld c,cwritestr
    call bdos           ;BDOS entry point
    ld c,cread
    jp bdos             ;BDOS entry point

l0855h:
    db cr,lf,"Hit any key to abort : $"

l086fh:
    db "U2 2 "
l086fh_len: equ $-l086fh

l0874h:
    db "N0:CP/M V2.2 DISK,XX"
l0874h_len: equ $-l0874h

l0888h:
    db "B-P 2 1"
l0888h_len: equ $-l0888h

l088fh:
    db "M-W",00h,13h,01h
l088fh_len: equ $-l088fh

l0895h:                 ;unused !!!
    db "#2"

l0897h:
    db 0
l0898h:
    db 0

l0899h:
    db "S0:*"
l0899h_len: equ $-l0899h

l089dh:
    db "S1:*"

l08a1h:
    db "0:CP/M"
l08a1h_len: equ $-l08a1h

l08a7h:
    db "1:CP/M"

l08adh:
    db "0:K"
l08adh_len: equ $-l08adh

l08b0h:
    db "1:K"

l08b3h:
    db 0
l08b4h:
    db 0

; End of LOADSAV2.REL =======================================================

    db 0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0

sub_095eh:              ;Library MUL
    xor a               ;095e af
    ld h,a              ;095f 67
    add a,b             ;0960 80
    jp m,l096bh         ;0961 fa 6b 09
    or c                ;0964 b1
    jp z,l09b6h         ;0965 ca b6 09
    jp l0972h           ;0968 c3 72 09
l096bh:
    inc h               ;096b 24
    cpl                 ;096c 2f
    ld b,a              ;096d 47
    ld a,c              ;096e 79
    cpl                 ;096f 2f
    ld c,a              ;0970 4f
    inc bc              ;0971 03
l0972h:
    xor a               ;0972 af
    add a,d             ;0973 82
    jp m,l097eh         ;0974 fa 7e 09
    or e                ;0977 b3
    jp z,l09b6h         ;0978 ca b6 09
    jp l0985h           ;097b c3 85 09
l097eh:
    inc h               ;097e 24
    cpl                 ;097f 2f
    ld d,a              ;0980 57
    ld a,e              ;0981 7b
    cpl                 ;0982 2f
    ld e,a              ;0983 5f
    inc de              ;0984 13
l0985h:
    push hl             ;0985 e5
    ld a,c              ;0986 79
    sub e               ;0987 93
    ld a,b              ;0988 78
    sbc a,d             ;0989 9a
    jp p,l0992h         ;098a f2 92 09
    ld h,b              ;098d 60
    ld l,c              ;098e 69
    ex de,hl            ;098f eb
    ld b,h              ;0990 44
    ld c,l              ;0991 4d
l0992h:
    ld hl,0000h         ;0992 21 00 00
    ex de,hl            ;0995 eb
l0996h:
    ld a,b              ;0996 78
    or c                ;0997 b1
    jp z,l09abh         ;0998 ca ab 09
    ld a,b              ;099b 78
    rra                 ;099c 1f
    ld b,a              ;099d 47
    ld a,c              ;099e 79
    rra                 ;099f 1f
    ld c,a              ;09a0 4f
    jp nc,l09a7h        ;09a1 d2 a7 09
    ex de,hl            ;09a4 eb
    add hl,de           ;09a5 19
    ex de,hl            ;09a6 eb
l09a7h:
    add hl,hl           ;09a7 29
    jp l0996h           ;09a8 c3 96 09
l09abh:
    pop af              ;09ab f1
    rra                 ;09ac 1f
    ret nc              ;09ad d0
    ld a,d              ;09ae 7a
    cpl                 ;09af 2f
    ld d,a              ;09b0 57
    ld a,e              ;09b1 7b
    cpl                 ;09b2 2f
    ld e,a              ;09b3 5f
    inc de              ;09b4 13
    ret                 ;09b5 c9
l09b6h:
    ld de,0000h         ;09b6 11 00 00
    ret                 ;09b9 c9

sub_09bah:              ;Library BC=DIV / HL=MOD
    xor a               ;09ba af
    ld h,b              ;09bb 60
    ld l,c              ;09bc 69
    ld b,a              ;09bd 47
    add a,d             ;09be 82
    jp m,l09c7h         ;09bf fa c7 09
    or e                ;09c2 b3
    jp nz,l09cfh        ;09c3 c2 cf 09
    ret                 ;09c6 c9
l09c7h:
    inc b               ;09c7 04
    ld a,d              ;09c8 7a
    cpl                 ;09c9 2f
    ld d,a              ;09ca 57
    ld a,e              ;09cb 7b
    cpl                 ;09cc 2f
    ld e,a              ;09cd 5f
    inc de              ;09ce 13
l09cfh:
    xor a               ;09cf af
    add a,h             ;09d0 84
    jp m,l09dch         ;09d1 fa dc 09
    or l                ;09d4 b5
    jp nz,l09e7h        ;09d5 c2 e7 09
    ld bc,0000h         ;09d8 01 00 00
    ret                 ;09db c9
l09dch:
    ld a,b              ;09dc 78
    or 02h              ;09dd f6 02
    ld b,a              ;09df 47
    ld a,h              ;09e0 7c
    cpl                 ;09e1 2f
    ld h,a              ;09e2 67
    ld a,l              ;09e3 7d
    cpl                 ;09e4 2f
    ld l,a              ;09e5 6f
    inc hl              ;09e6 23
l09e7h:
    push bc             ;09e7 c5
    ld a,01h            ;09e8 3e 01
    push af             ;09ea f5
    ld bc,0000h         ;09eb 01 00 00
    xor a               ;09ee af
    add a,d             ;09ef 82
    jp m,l0a00h         ;09f0 fa 00 0a
    ex de,hl            ;09f3 eb
l09f4h:
    pop af              ;09f4 f1
    inc a               ;09f5 3c
    push af             ;09f6 f5
    add hl,hl           ;09f7 29
    ld a,h              ;09f8 7c
    cp 00h              ;09f9 fe 00
    jp p,l09f4h         ;09fb f2 f4 09
    ex de,hl            ;09fe eb
    xor a               ;09ff af
l0a00h:
    ld a,c              ;0a00 79
    rla                 ;0a01 17
    ld c,a              ;0a02 4f
    ld a,b              ;0a03 78
    rla                 ;0a04 17
    ld b,a              ;0a05 47
    ld a,l              ;0a06 7d
    sub e               ;0a07 93
    ld l,a              ;0a08 6f
    ld a,h              ;0a09 7c
    sbc a,d             ;0a0a 9a
    ld h,a              ;0a0b 67
    jp c,l0a13h         ;0a0c da 13 0a
    inc bc              ;0a0f 03
    jp l0a14h           ;0a10 c3 14 0a
l0a13h:
    add hl,de           ;0a13 19
l0a14h:
    pop af              ;0a14 f1
    dec a               ;0a15 3d
    jp z,l0a24h         ;0a16 ca 24 0a
    push af             ;0a19 f5
    xor a               ;0a1a af
    ld a,d              ;0a1b 7a
    rra                 ;0a1c 1f
    ld d,a              ;0a1d 57
    ld a,e              ;0a1e 7b
    rra                 ;0a1f 1f
    ld e,a              ;0a20 5f
    jp l0a00h           ;0a21 c3 00 0a
l0a24h:
    xor a               ;0a24 af
    ld a,d              ;0a25 7a
    rra                 ;0a26 1f
    ld d,a              ;0a27 57
    ld a,e              ;0a28 7b
    rra                 ;0a29 1f
    ld e,a              ;0a2a 5f
    pop af              ;0a2b f1
    push af             ;0a2c f5
    rra                 ;0a2d 1f
    rra                 ;0a2e 1f
    jp nc,l0a39h        ;0a2f d2 39 0a
    ld a,h              ;0a32 7c
    cpl                 ;0a33 2f
    ld h,a              ;0a34 67
    ld a,l              ;0a35 7d
    cpl                 ;0a36 2f
    ld l,a              ;0a37 6f
    inc hl              ;0a38 23
l0a39h:
    pop af              ;0a39 f1
    inc a               ;0a3a 3c
    rra                 ;0a3b 1f
    rra                 ;0a3c 1f
    ret nc              ;0a3d d0
    ld a,b              ;0a3e 78
    cpl                 ;0a3f 2f
    ld b,a              ;0a40 47
    ld a,c              ;0a41 79
    cpl                 ;0a42 2f
    ld c,a              ;0a43 4f
    inc bc              ;0a44 03
    ret                 ;0a45 c9
sub_0a46h:
    pop hl              ;0a46 e1
    push bc             ;0a47 c5
    push de             ;0a48 d5
    ld a,08h            ;0a49 3e 08
    add a,(hl)          ;0a4b 86
    ld e,a              ;0a4c 5f
    inc hl              ;0a4d 23
    xor a               ;0a4e af
    ld b,a              ;0a4f 47
    sub (hl)            ;0a50 96
    jp z,l0a55h         ;0a51 ca 55 0a
    dec b               ;0a54 05
l0a55h:
    ld c,a              ;0a55 4f
    ld a,e              ;0a56 7b
    push hl             ;0a57 e5
    ld hl,0000h         ;0a58 21 00 00
    add hl,sp           ;0a5b 39
    ld d,h              ;0a5c 54
    ld e,l              ;0a5d 5d
    add hl,bc           ;0a5e 09
    ld sp,hl            ;0a5f f9
l0a60h:
    or a                ;0a60 b7
    jp z,l0a6eh         ;0a61 ca 6e 0a
    ex de,hl            ;0a64 eb
    ld c,(hl)           ;0a65 4e
    ex de,hl            ;0a66 eb
    ld (hl),c           ;0a67 71
    inc hl              ;0a68 23
    inc de              ;0a69 13
    dec a               ;0a6a 3d
    jp l0a60h           ;0a6b c3 60 0a
l0a6eh:
    pop hl              ;0a6e e1
    ld a,(hl)           ;0a6f 7e
    inc hl              ;0a70 23
    ld c,(hl)           ;0a71 4e
    inc hl              ;0a72 23
    ld b,(hl)           ;0a73 46
    inc hl              ;0a74 23
    push bc             ;0a75 c5
    ex (sp),hl          ;0a76 e3
l0a77h:
    or a                ;0a77 b7
    jp z,l0a85h         ;0a78 ca 85 0a
    dec de              ;0a7b 1b
    ld c,(hl)           ;0a7c 4e
    ex de,hl            ;0a7d eb
    ld (hl),c           ;0a7e 71
    ex de,hl            ;0a7f eb
    inc hl              ;0a80 23
    dec a               ;0a81 3d
    jp l0a77h           ;0a82 c3 77 0a
l0a85h:
    pop hl              ;0a85 e1
    pop de              ;0a86 d1
    pop bc              ;0a87 c1
    jp (hl)             ;0a88 e9
sub_0a89h:
    ex (sp),hl          ;0a89 e3
    push af             ;0a8a f5
    ld a,(hl)           ;0a8b 7e
    inc hl              ;0a8c 23
    ld e,(hl)           ;0a8d 5e
    inc hl              ;0a8e 23
    ld d,(hl)           ;0a8f 56
    ld hl,0006h         ;0a90 21 06 00
    ld b,h              ;0a93 44
    ld c,a              ;0a94 4f
    add hl,sp           ;0a95 39
    ex de,hl            ;0a96 eb
    add hl,bc           ;0a97 09
l0a98h:
    or a                ;0a98 b7
    jp z,l0aa6h         ;0a99 ca a6 0a
    dec hl              ;0a9c 2b
    ex de,hl            ;0a9d eb
    ld c,(hl)           ;0a9e 4e
    ex de,hl            ;0a9f eb
    ld (hl),c           ;0aa0 71
    inc de              ;0aa1 13
    dec a               ;0aa2 3d
    jp l0a98h           ;0aa3 c3 98 0a
l0aa6h:
    ex de,hl            ;0aa6 eb
    pop af              ;0aa7 f1
    pop de              ;0aa8 d1
    pop bc              ;0aa9 c1
    ld sp,hl            ;0aaa f9
    push bc             ;0aab c5
    ex de,hl            ;0aac eb
    ret                 ;0aad c9

    db 0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

dd:
    db 0                ;CP/M source drive number (0=A:, 1=B:, ...)
drv_typ:
    db 0                ;Drive type (from dtypes table)
dos_err:
    db 0                ;Last CBM DOS error code
rr:
    db 0                ;First char of user input from any prompt
nn:
    dw 0                ;Integer parsed from user input
hh:
    dw 0                ;Hexadecimal value parsed from user input

buffer:                 ;User input buffer struct
buff_size:
    db 0                ;  Buffer size (contain 128) as byte
buff_len:
    db 0                ;  Used buffer length as byte
buff_data:              ;  80 bytes input buffer
                        ;TODO: Why are only 79 bytes reserved?
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

l3059h:
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0

dtype_tmp:
    db 0                ;Temporarily holds CP/M drive number in dtype routine
idisk_tmp:
    db 0                ;Temporairly holds CP/M drive number in idisk routine
eindex:
    db 0                ;Loop index for CBM DOS error message used in dskerr
l30adh:
    db 0
l30aeh:
    dw 0
l30b0h:
    db 0
l30b1h:
    dw 0
l30b3h:
    dw 0
l30b5h:
    dw 0
l30b7h:
    db 0
l30b8h:
    db 0
l30b9h:
    db 0

    db 0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
