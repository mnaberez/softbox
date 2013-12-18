; z80dasm 1.1.3
; command line: z80dasm --origin=256 --labels --address newsys.com

warm:          equ  0000h ;Warm start entry point

    org 0100h

    jp start            ;0100 c3 ee 02
    nop                 ;0103 00
    nop                 ;0104 00
    nop                 ;0105 00
    nop                 ;0106 00
    nop                 ;0107 00
    nop                 ;0108 00
    nop                 ;0109 00

; Start of BASIC variables ==================================================

mini:
    dw 0                ;Mini-Winchester flag: 1=MW, 0=Corvus
iobyte:
    dw 0                ;Value to be stored in the CP/M IOBYTE

drv:
;Array of 10 integers
    dw  0000h,  0000h,  0000h,  0000h,  0000h,  0000h,  7700h,  782bh
    dw 0caa7h,  2910h,  2bd1h

diskdev:
;Array of 10 integers
    dw  2b72h,  3d73h,  07c2h, 0c129h, 0fb11h,  19ffh,  77f1h,  003eh
    dw  7723h, 0a72bh

    db 0c0h, 0c3h

autoload:
;Array of 120 integers
    dw  2761h, 0fe7eh,  3701h, 0d5c0h,  11e5h,  0005h,  5e19h,  5623h
    dw 0fe1ah, 0c2ebh,  2945h,  1a13h,  07feh,  45cah,  2129h,  0004h
    dw  7e19h, 0d1e1h, 0c9a7h, 0d1e1h, 0c937h,  71cdh, 0d62eh, 0a7e7h
    dw 0cdc0h,  2730h, 0c9afh,  71cdh, 0fe2eh, 0c89fh,  9dfeh,  7ec9h
    dw  01feh, 0c037h, 0ebd5h,  0521h,  1900h,  237eh,  6f66h, 0fe7eh
    dw 0caedh,  2981h, 0ebfeh, 0c237h,  2981h,  7e23h, 0ee2bh, 0d607h
    dw  7e01h, 0d1ebh,  1ac9h,  7d77h,  4412h,  2313h,  771ah,  1278h
    dw 0c923h, 0cacdh, 0e72eh, 0f5c9h, 0cdebh,  273dh, 0cdf1h,  48beh
    dw  84c3h, 0e529h,  21d5h, 0ffd8h, 0eb39h, 0c32ah,  1916h, 0d13fh
    dw 0d0e1h,  053eh, 0c2c3h,  3a1fh,  12c4h,  01d6h, 0c6c2h,  3229h
    dw  12b6h,  023eh, 0c432h,  3a12h,  12c4h,  0006h,  02feh, 0d2cah
    dw  0629h, 0c520h, 0fdcdh, 0ca4ch,  2a4ah, 0e3f2h, 0f129h,  80f6h
    dw 0cdf5h,  4ce2h, 0c43ah, 0fe12h, 0ca02h,  2a2ch,  21f5h,  12bbh
    dw  6bcdh, 0cd4dh,  1f5eh, 0fbd2h, 0cd29h,  4e86h,  0721h, 0e52ah
    dw  57cdh, 0e14eh, 0c3c1h,  2a48h,  2ac1h,  12b5h,  78e5h,  04feh

    db 0cah, 1bh

scrtab:
;Array of 64 integers
    dw 0cd2ah,  4ea8h, 0eacdh, 0c34dh,  2a27h,  7ccdh,  214eh,  12bbh
    dw  2ecdh, 0cd4dh,  4d7dh, 0a7e1h,  48c2h, 0f12ah,  40f6h,  5df5h
    dw  1b54h, 0a37dh,  7c5fh, 0b3a2h,  48c2h,  062ah,  0510h, 0d229h
    dw  2a3eh, 0b0f1h,  10f6h, 0f1f5h, 0f1c9h, 0c9afh,  71cdh, 0fe2eh
    dw 0cce5h,  2730h,  2ec3h,  3e23h, 0cd34h,  2abah,  3ec3h,  1130h
    dw  1222h, 0d579h, 0c23dh,  2a64h,  50cdh,  1420h,  6fcdh, 0c92fh
    dw  7e23h, 0fe2bh, 0c207h,  2a8ch,  8778h,  83f2h,  782ah,  08f6h
    dw 0c947h,  50cdh,  0420h,  053eh, 0cecdh,  782bh,  08e6h,  9bcah

    db 2ah, 0cdh

bias:
    dw 2050h            ;Offset used to calculate start of buffer that
                        ;  stores the CP/M system data

loader:
    dw 3e04h            ;Start address of the buffer that holds the
                        ;  "loader" (terminal program "K" for the PET)

rr:
    dw 0c307h           ;First char of user input from any prompt,
                        ;  also used to store CP/M drive number
dt:
    dw 2bceh            ;Drive type (from dtypes table)
ee:
    dw 0e678h           ;Last error code from CBM DOS

dirsize:
    dw 47bfh            ;CCP directory width: 0=1 col, 1=2 cols, 3=4 cols
lpt:
    dw 20e6h            ;CBM printer (LPT:) IEEE-488 primary address
rdr:
    dw 0a9cah           ;Paper Tape Reader (PTR:) IEEE-488 primary address
pun:
    dw 3e2ah            ;Paper Tape Punch (PTP:) IEEE-488 primary address
uu:
    dw 0c304h           ;Byte that is written to 8251 USART mode register
baud:
    dw 2bceh            ;Byte that is written to COM8116 baud rate generator
ul1:
    dw 0e678h           ;ASCII printer (UL1:) IEEE-488 primary address
termtype:
    dw 0c804h           ;Terminal type: 0=ADM3A, 1=HZ1500, 2=TV912
                        ;  Bit 7 of low byte is set if uppercase mode
leadin:
    dw 7e23h            ;Terminal command lead-in: 1bh=escape, 7eh=tilde
order:
    dw 0fe2bh           ;X,Y order when sending move-to: 0=Y first, 1=X first
rowoff:
    dw 0c004h           ;Offset added to Y when sending move-to sequence
coloff:
    dw 053eh            ;Offset added to X when sending move-to sequence

l02d0h:
    dw 0cec3h

clock:
    dw 3e2bh            ;Frequency of PET system interrupt in Hz (50 or 60)
lptype:
    dw 0158h            ;CBM printer (LPT:) type: 0=3022, 3023, 4022, 4023
                        ;                         1=8026, 8027 (daisywheel)
                        ;                         2=8024
u1:
    dw 0007h            ;Temp variable used compare 8251 stop bits setting
nn:
    dw 16cdh            ;Integer parsed from user input
r1:
    dw 7327h            ;Temp variable that holds a copy of R
                        ;  (first char of user input)
dd:
    dw 7223h            ;CP/M drive number of current drive
l02deh:
    dw 0c32bh

buf:
    dw 275dh            ;Address of buffer used in readline

; End of BASIC variables ====================================================

l02e2h:
    push de             ;02e2 d5
    ld d,a              ;02e3 57
    add a,a             ;02e4 87
    add a,d             ;02e5 82
    ld hl,2adbh         ;02e6 21 db 2a
    call 48beh          ;02e9 cd be 48
    ld e,(hl)           ;02ec 5e
    inc hl              ;02ed 23

start:
    ld hl,main          ;02ee 21 02 03
    jp ini              ;02f1 c3 27 2d

    sbc a,a             ;02f4 9f
    jr z,$-14           ;02f5 28 f0
    inc d               ;02f7 14
    and c               ;02f8 a1
    jr z,l02feh         ;02f9 28 03
    ld bc,l02e2h        ;02fb 01 e2 02
l02feh:
    nop                 ;02fe 00
    nop                 ;02ff 00
    xor 02h             ;0300 ee 02

main:
    call n5_0           ;0302 cd 28 2d

    ;MINI = 0
    ld hl,0000h
    ld (mini),hl

    ;IOBYTE = 0
    ld hl,0000h
    ld (iobyte),hl

    ;BIAS = &H0C00
    ld hl,0c00h
    ld (bias),hl

    ;LOADER = &H6002
    ld hl,6002h
    ld (loader),hl

l031dh:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;"CP/M  Reconfiguration"
    call pr0a
    ld hl,cpm_reconfig
    call pv2d

    ;PRINT "----  ---------------"
    call pr0a
    ld hl,dashes_3
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;IF MINI <> 1 THEN GOTO l0359h
    ld hl,(mini)
    ld de,0ffffh
    add hl,de
    ld a,h
    or l
    jp nz,l0359h

    ;PRINT "Mini-winchester version"
    call pr0a
    ld hl,mw_version
    call pv2d

l0359h:
    ;PRINT "Revision 3   --   19 February 1982"
    call pr0a
    ld hl,rev_3_feb_1982
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Source drive (A to P) ? ";
    call pr0a
    ld hl,source_drv_a_p
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=0 THEN GOTO l0430h
    ld hl,(rr)
    ld a,h
    or l
    jp z,l0430h

    ;IF (R<&H41) or (R>&H50) THEN GOTO l031dh
    ld hl,(rr)
    ld de,0ffbfh
    ld a,h
    rla
    jp c,l0395h
    add hl,de
    add hl,hl
l0395h:
    sbc a,a
    ld h,a
    ld l,a
    push hl
    ld hl,(rr)
    ld de,0ffafh
    ld a,h
    rla
    jp c,l03a6h
    add hl,de
    add hl,hl
l03a6h:
    ccf
    sbc a,a
    ld h,a
    ld l,a
    pop de
    ld a,h
    or d
    ld h,a
    ld a,l
    or e
    ld l,a
    ld a,h
    or l
    jp nz,l031dh

    ;R = R - &H41
    ld de,0ffbfh
    ld hl,(rr)
    add hl,de
    ld (rr),hl

    ;DT = R
    ld hl,(rr)
    ld (dt),hl

    ;CALL DTYPE (DT)
    ld hl,dt
    call dtype

    ;IF DT > 128 THEN GOTO l031dh
    ld hl,(dt)
    ld de,0ff7fh
    ld a,h
    rla
    jp c,l03d9h
    add hl,de
    add hl,hl
l03d9h:
    jp nc,l031dh

    ld hl,(dt)          ;03dc 2a b4 02
    ld de,0fffeh        ;03df 11 fe ff
    ld a,h              ;03e2 7c
    rla                 ;03e3 17
    jp c,l03e9h         ;03e4 da e9 03
    add hl,de           ;03e7 19
l03e8h:
    add hl,hl           ;03e8 29
l03e9h:
    ccf                 ;03e9 3f
    sbc a,a             ;03ea 9f
    ld h,a              ;03eb 67
    ld l,a              ;03ec 6f
    push hl             ;03ed e5
    ld hl,(dt)          ;03ee 2a b4 02
    ld de,0fff6h        ;03f1 11 f6 ff
    ld a,h              ;03f4 7c
    rla                 ;03f5 17
    jp c,l03fbh         ;03f6 da fb 03
    add hl,de           ;03f9 19
    add hl,hl           ;03fa 29
l03fbh:
    sbc a,a             ;03fb 9f
    ld h,a              ;03fc 67
    ld l,a              ;03fd 6f
    pop de              ;03fe d1
    ld a,h              ;03ff 7c
    and d               ;0400 a2
    ld h,a              ;0401 67
    ld a,l              ;0402 7d
    and e               ;0403 a3
    ld l,a              ;0404 6f
    ld a,h              ;0405 7c
    or l                ;0406 b5
    jp z,l0413h         ;0407 ca 13 04

    ;CALL CREAD(R)
    ld hl,rr
    call cread_

    ;GOTO l0430h
    jp l0430h

l0413h:
    ;CALL IDISK(R)
    ld hl,rr
    call idisk

    ;CALL RDSYS(R)
    ld hl,rr
    call rdsys

    ;CALL DSKERR (E)
    ld hl,ee
    call dskerr

    ;IF E = 0 THEN GOTO l0430h
    ld hl,(ee)
    ld a,h
    or l
    jp z,l0430h

    ;END
    call end

l0430h:
    ;DIRSIZE = PEEK (BIAS+&H38B2)
    ld de,38b2h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (dirsize),hl

    ;IOBYTE = PEEK (BIAS+&H4A60)
    ld de,4a60h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (iobyte),hl

    ;LPT = PEEK (BIAS+&H4A61)
    ld de,4a61h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (lpt),hl

    ;RDR = PEEK (BIAS+&H4A62)
    ld de,4a62h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (rdr),hl

    ;PUN = PEEK (BIAS+&H4A63)
    ld de,4a63h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (pun),hl

    ;U = PEEK (BIAS+&H4A64)
    ld de,4a64h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (uu),hl

    ;BAUD = PEEK (BIAS+&H4A65)
    ld de,4a65h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (baud),hl

    ;UL1 = PEEK (BIAS+&H4A66)
    ld de,4a66h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (ul1),hl

    ;TERMTYPE = PEEK (BIAS+&H4A67)
    ld de,4a67h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (termtype),hl

    ;LEADIN = PEEK (BIAS+&H4A68)
    ld de,4a68h         ;04a5 11 68 4a
    ld hl,(bias)        ;04a8 2a ae 02
    add hl,de           ;04ab 19
    ld l,(hl)           ;04ac 6e
    ld h,00h            ;04ad 26 00
    ld (leadin),hl      ;04af 22 c8 02

    ;ORDER = PEEK (BIAS+&H4A69)
    ld de,4a69h         ;04b2 11 69 4a
    ld hl,(bias)        ;04b5 2a ae 02
    add hl,de           ;04b8 19
    ld l,(hl)           ;04b9 6e
    ld h,00h            ;04ba 26 00
    ld (order),hl       ;04bc 22 ca 02

    ;ROWOFF = PEEK (BIAS+&H4A6A)
    ld de,4a6ah         ;04bf 11 6a 4a
    ld hl,(bias)        ;04c2 2a ae 02
    add hl,de           ;04c5 19
    ld l,(hl)           ;04c6 6e
    ld h,00h            ;04c7 26 00
    ld (rowoff),hl      ;04c9 22 cc 02

    ;COLOFF = PEEK (BIAS+&H4A6B)
    ld de,4a6bh         ;04cc 11 6b 4a
    ld hl,(bias)        ;04cf 2a ae 02
    add hl,de           ;04d2 19
    ld l,(hl)           ;04d3 6e
    ld h,00h            ;04d4 26 00
    ld (coloff),hl      ;04d6 22 ce 02

    ld hl,0000h         ;04d9 21 00 00
    jp l0517h           ;04dc c3 17 05
l04dfh:
    ld hl,(bias)        ;04df 2a ae 02
    ex de,hl            ;04e2 eb
    ld hl,(l02d0h)      ;04e3 2a d0 02
    add hl,de           ;04e6 19
    ld de,4a70h         ;04e7 11 70 4a
    push hl             ;04ea e5
    add hl,de           ;04eb 19
    ld l,(hl)           ;04ec 6e
    ld h,00h            ;04ed 26 00
    push hl             ;04ef e5
    ld hl,(l02d0h)      ;04f0 2a d0 02
    add hl,hl           ;04f3 29
    ld (02eah),hl       ;04f4 22 ea 02
    ld de,drv           ;04f7 11 0e 01
    add hl,de           ;04fa 19
    pop de              ;04fb d1
    ld (hl),e           ;04fc 73
    inc hl              ;04fd 23
    ld (hl),d           ;04fe 72
    ld de,4a78h         ;04ff 11 78 4a
    pop hl              ;0502 e1
    add hl,de           ;0503 19
    ld l,(hl)           ;0504 6e
    ld h,00h            ;0505 26 00
    push hl             ;0507 e5
    ld hl,(02eah)       ;0508 2a ea 02
    ld de,diskdev       ;050b 11 24 01
    add hl,de           ;050e 19
    pop de              ;050f d1
    ld (hl),e           ;0510 73
    inc hl              ;0511 23
    ld (hl),d           ;0512 72
    ld hl,(l02d0h)      ;0513 2a d0 02
    inc hl              ;0516 23
l0517h:
    ld (l02d0h),hl      ;0517 22 d0 02
    ld hl,(l02d0h)      ;051a 2a d0 02
    ld de,0fff8h        ;051d 11 f8 ff
    ld a,h              ;0520 7c
    rla                 ;0521 17
    jp c,l0527h         ;0522 da 27 05
    add hl,de           ;0525 19
    add hl,hl           ;0526 29
l0527h:
    jp c,l04dfh         ;0527 da df 04
    ld hl,0000h         ;052a 21 00 00
    jp l0550h           ;052d c3 50 05
l0530h:
    ld hl,(bias)        ;0530 2a ae 02
    ex de,hl            ;0533 eb
    ld hl,(l02d0h)      ;0534 2a d0 02
    add hl,de           ;0537 19
    ld de,3407h         ;0538 11 07 34
    add hl,de           ;053b 19
    ld l,(hl)           ;053c 6e
    ld h,00h            ;053d 26 00
    push hl             ;053f e5
    ld hl,(l02d0h)      ;0540 2a d0 02
    add hl,hl           ;0543 29
    ld de,autoload      ;0544 11 3a 01
    add hl,de           ;0547 19
    pop de              ;0548 d1
    ld (hl),e           ;0549 73
    inc hl              ;054a 23
    ld (hl),d           ;054b 72
    ld hl,(l02d0h)      ;054c 2a d0 02
    inc hl              ;054f 23
l0550h:
    ld (l02d0h),hl      ;0550 22 d0 02
    ld hl,(l02d0h)      ;0553 2a d0 02
    ld de,0ffafh        ;0556 11 af ff
    ld a,h              ;0559 7c
    rla                 ;055a 17
    jp c,l0560h         ;055b da 60 05
    add hl,de           ;055e 19
    add hl,hl           ;055f 29
l0560h:
    jp c,l0530h         ;0560 da 30 05
    ld hl,0000h         ;0563 21 00 00
    jp l0589h           ;0566 c3 89 05
l0569h:
    ld hl,(bias)        ;0569 2a ae 02
    ex de,hl            ;056c eb
    ld hl,(l02d0h)      ;056d 2a d0 02
    add hl,de           ;0570 19
    ld de,4a80h         ;0571 11 80 4a
    add hl,de           ;0574 19
    ld l,(hl)           ;0575 6e
    ld h,00h            ;0576 26 00
    push hl             ;0578 e5
    ld hl,(l02d0h)      ;0579 2a d0 02
    add hl,hl           ;057c 29
    ld de,scrtab        ;057d 11 2c 02
    add hl,de           ;0580 19
    pop de              ;0581 d1
    ld (hl),e           ;0582 73
    inc hl              ;0583 23
    ld (hl),d           ;0584 72
    ld hl,(l02d0h)      ;0585 2a d0 02
    inc hl              ;0588 23
l0589h:
    ld (l02d0h),hl      ;0589 22 d0 02
    ld hl,(l02d0h)      ;058c 2a d0 02
    ld de,0ffc0h        ;058f 11 c0 ff
    ld a,h              ;0592 7c
    rla                 ;0593 17
    jp c,l0599h         ;0594 da 99 05
    add hl,de           ;0597 19
    add hl,hl           ;0598 29
l0599h:
    jp c,l0569h         ;0599 da 69 05

    ;POKE LOADER+3, CLOCK
    ld hl,(loader)
    inc hl
    inc hl
    inc hl
    ld l,(hl)
    ld h,00h
    ld (clock),hl

    ;POKE BIAS+&H4A6D, LPTYPE
    ld de,4a6dh
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,00h
    ld (lptype),hl

l05b5h:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "CP/M  Re-configuration"
    call pr0a
    ld hl,cpm_reconfig_2
    call pv2d

    ;PRINT "----  ----------------"
    call pr0a
    ld hl,dashes_4
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "A - Autoload command"
    call pr0a
    ld hl,a_autoload
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "D - Disk drive assignment"
    call pr0a
    ld hl,d_drv_asgn
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "I - I/O assignment"
    call pr0a
    ld hl,i_io_asgn
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "P - PET terminal parameters"
    call pr0a
    ld hl,p_pet_term
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "R - RS232 characteristics"
    call pr0a
    ld hl,r_rs232
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "S - Save new system"
    call pr0a
    ld hl,s_save
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "E - Execute new system"
    call pr0a
    ld hl,e_execute
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Q - Quit this program"
    call pr0a
    ld hl,q_quit
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Please enter the appropriate letter : "
    call pr0a
    ld hl,pls_letter
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=&H52 THEN GOTO l06deh
    ld hl,(rr)
    ld de,0-'R'
    add hl,de
    ld a,h
    or l
    jp z,l06deh

    ;IF R<>&H51 THEN GOTO l0693h
    ld hl,(rr)
    ld de,0-'Q'
    add hl,de
    ld a,h
    or l
    jp nz,l0693h

    ;END
    call end

l0693h:
    ;IF R=&H49 THEN GOTO l0a7bh
    ld hl,(rr)
    ld de,0-'I'
    add hl,de
    ld a,h
    or l
    jp z,l0a7bh

    ;IF R=&H44 THEN GOTO l0eadh
    ld hl,(rr)
    ld de,0-'D'
    add hl,de
    ld a,h
    or l
    jp z,l0eadh

    ;IF R=&H41 THEN GOTO l1362h
    ld hl,(rr)
    ld de,0-'A'
    add hl,de
    ld a,h
    or l
    jp z,l1362h

    ;IF R=&H45 THEN GOTO l1494h
    ld hl,(rr)
    ld de,0-'E'
    add hl,de
    ld a,h
    or l
    jp z,l1494h

    ;IF R=&H53 THEN GOTO l1494h
    ld hl,(rr)
    ld de,0-'S'
    add hl,de
    ld a,h
    or l
    jp z,l1668h
    ld hl,(rr)

    ;IF R=&H50 THEN GOTO l1743h
    ld de,0-'P'
    add hl,de
    ld a,h
    or l
    jp z,l1743h

    ;GOTO l05b5h
    jp l05b5h

l06deh:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "           RS232 Characteristics"
    call pr0a
    ld hl,rs232_chrs
    call pv2d

    ;PRINT "           ----- ---------------"
    call pr0a
    ld hl,dashes_5
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT " 1.  Character size :          ";
    call pr0a
    ld hl,rs232_1_chr
    call pv1d

    call pr0a           ;0705 cd 3d 2d
    ld hl,(uu)          ;0708 2a c0 02
    ld a,l              ;070b 7d
    and 0ch             ;070c e6 0c
    ld l,a              ;070e 6f
    ld a,h              ;070f 7c
    and 00h             ;0710 e6 00
    ld h,a              ;0712 67
    call idva           ;0713 cd 64 2c
    inc b               ;0716 04
    nop                 ;0717 00
    ld de,0035h         ;0718 11 35 00
    add hl,de           ;071b 19
    call chr            ;071c cd 24 2c
    call pv2d           ;071f cd 31 2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;" 2.  Number of stop bits :     ";
    call pr0a
    ld hl,rs232_2_stop
    call pv1d

    ;U1 = U AND &HC0
    ld hl,(uu)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (u1),hl

    ld hl,(u1)          ;0742 2a d6 02
    ld a,h              ;0745 7c
    or l                ;0746 b5
    jp nz,l0753h        ;0747 c2 53 07

    ;PRINT "undefined"
    call pr0a
    ld hl,undefined
    call pv2d

l0753h:
    ld hl,(u1)          ;0753 2a d6 02
    ld de,0ffc0h        ;0756 11 c0 ff
    add hl,de           ;0759 19
    ld a,h              ;075a 7c
    or l                ;075b b5
    jp nz,l0768h        ;075c c2 68 07

    ;PRINT "1"
    call pr0a
    ld hl,one
    call pv2d

l0768h:
    ld hl,(u1)          ;0768 2a d6 02
    ld de,0ff80h        ;076b 11 80 ff
    add hl,de           ;076e 19
    ld a,h              ;076f 7c
    or l                ;0770 b5
    jp nz,l077dh        ;0771 c2 7d 07

    ;PRINT "1.5"
    call pr0a
    ld hl,one_dot_five
    call pv2d

l077dh:
    ld hl,(u1)          ;077d 2a d6 02
    ld de,0ff40h        ;0780 11 40 ff
    add hl,de           ;0783 19
    ld a,h              ;0784 7c
    or l                ;0785 b5
    jp nz,l0792h        ;0786 c2 92 07

    ;PRINT "2"
    call pr0a
    ld hl,two
    call pv2d

l0792h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT " 3.  Parity :                  ";
    call pr0a
    ld hl,rs232_3_par
    call pv1d

    ld hl,(uu)          ;07a4 2a c0 02
    ld a,l              ;07a7 7d
    and 10h             ;07a8 e6 10
    ld l,a              ;07aa 6f
    ld a,h              ;07ab 7c
    and 00h             ;07ac e6 00
    ld h,a              ;07ae 67
    ld a,h              ;07af 7c
    or l                ;07b0 b5
    jp nz,l07bdh        ;07b1 c2 bd 07

    ;PRINT "none"
    call pr0a
    ld hl,none
    call pv2d

l07bdh:
    ld hl,(uu)          ;07bd 2a c0 02
    ld a,l              ;07c0 7d
    and 30h             ;07c1 e6 30
    ld l,a              ;07c3 6f
    ld a,h              ;07c4 7c
    and 00h             ;07c5 e6 00
    ld h,a              ;07c7 67
    ld de,0ffd0h        ;07c8 11 d0 ff
    add hl,de           ;07cb 19
    ld a,h              ;07cc 7c
    or l                ;07cd b5
    jp nz,l07dah        ;07ce c2 da 07

    ;PRINT "even"
    call pr0a
    ld hl,even
    call pv2d

l07dah:
    ld hl,(uu)          ;07da 2a c0 02
    ld a,l              ;07dd 7d
    and 30h             ;07de e6 30
    ld l,a              ;07e0 6f
    ld a,h              ;07e1 7c
    and 00h             ;07e2 e6 00
    ld h,a              ;07e4 67
    ld de,0fff0h        ;07e5 11 f0 ff
    add hl,de           ;07e8 19
    ld a,h              ;07e9 7c
    or l                ;07ea b5
    jp nz,l07f7h        ;07eb c2 f7 07

    ;PRINT "odd"
    call pr0a
    ld hl,odd
    call pv2d

l07f7h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

l0800h:
    ;PRINT " 4.  Baud rate :               "
    call pr0a
    ld hl,rs232_4_baud
    call pv1d

    ld hl,(baud)        ;0809 2a c2 02
    ld de,0ffdeh        ;080c 11 de ff
    add hl,de           ;080f 19
    ld a,h              ;0810 7c
    or l                ;0811 b5
    jp nz,l081eh        ;0812 c2 1e 08

    ;PRINT "110"
    call pr0a
    ld hl,baud_110
    call pv2d

l081eh:
    ld hl,(baud)        ;081e 2a c2 02
    ld de,0ffabh        ;0821 11 ab ff
    add hl,de           ;0824 19
    ld a,h              ;0825 7c
    or l                ;0826 b5
    jp nz,l0833h        ;0827 c2 33 08

    ;PRINT "300"
    call pr0a
    ld hl,baud_300
    call pv2d

l0833h:
    ld hl,(baud)        ;0833 2a c2 02
    ld de,0ff89h        ;0836 11 89 ff
    add hl,de           ;0839 19
    ld a,h              ;083a 7c
    or l                ;083b b5
    jp nz,l0848h        ;083c c2 48 08

    ;PRINT "1200"
    call pr0a
    ld hl,baud_1200
    call pv2d

l0848h:
    ld hl,(baud)        ;0848 2a c2 02
    ld de,0ff12h        ;084b 11 12 ff
    add hl,de           ;084e 19
    ld a,h              ;084f 7c
    or l                ;0850 b5
    jp nz,l085dh        ;0851 c2 5d 08

    ;PRINT "9600"
    call pr0a
    ld hl,baud_9600
    call pv2d

l085dh:
    ld hl,(baud)        ;085d 2a c2 02
    ld de,0ff01h        ;0860 11 01 ff
    add hl,de           ;0863 19
    ld a,h              ;0864 7c
    or l                ;0865 b5
    jp nz,l0872h        ;0866 c2 72 08

    ;PRINT "19200"
    call pr0a
    ld hl,baud_19200
    call pv2d

l0872h:
    ld hl,(baud)        ;0872 2a c2 02
    ld de,0ff34h        ;0875 11 34 ff
    add hl,de           ;0878 19
    ld a,h              ;0879 7c
    or l                ;087a b5
    jp nz,l0887h        ;087b c2 87 08

    ;PRINT "4800"
    call pr0a
    ld hl,baud_4800
    call pv2d

l0887h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which characteristic (1-4) ? "
    call pr0a
    ld hl,alter_chr_1_4
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=&H31 THEN GOTO l08d7h
    ld hl,(rr)
    ld de,0-'1'
    add hl,de
    ld a,h
    or l
    jp z,l08d7h

    ;IF R=0 THEN GOTO l05b5h
    ld hl,(rr)
    ld a,h
    or l
    jp z,l05b5h

    ;IF R=&H32 THEN GOTO l0930h
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp z,l0930h

    ;IF R=&H33 THEN GOTO l0983h
    ld hl,(rr)
    ld de,0-'3'
    add hl,de
    ld a,h
    or l
    jp z,l0983h

    ;IF R=&H34 THEN GOTO l09e8h
    ld hl,(rr)
    ld de,0-'4'
    add hl,de
    ld a,h
    or l
    jp z,l09e8h

    ;GOTO l06deh
    jp l06deh

l08d7h:
    ;PRINT "New character length (5 to 8) ? "
    call pr0a
    ld hl,new_char_len
    call pv1d

    ;GOSUB readline
    call readline

    ld de,0ffcbh        ;08e3 11 cb ff
    ld hl,(rr)          ;08e6 2a b2 02
    add hl,de           ;08e9 19
    ld (rr),hl          ;08ea 22 b2 02
    ld hl,(rr)          ;08ed 2a b2 02
    add hl,hl           ;08f0 29
    ccf                 ;08f1 3f
    sbc a,a             ;08f2 9f
    ld h,a              ;08f3 67
    ld l,a              ;08f4 6f
    push hl             ;08f5 e5
    ld hl,(rr)          ;08f6 2a b2 02
    ld de,0fffch        ;08f9 11 fc ff
    ld a,h              ;08fc 7c
    rla                 ;08fd 17
    jp c,l0903h         ;08fe da 03 09
    add hl,de           ;0901 19
    add hl,hl           ;0902 29
l0903h:
    sbc a,a             ;0903 9f
    ld h,a              ;0904 67
    ld l,a              ;0905 6f
    pop de              ;0906 d1
    ld a,h              ;0907 7c
    and d               ;0908 a2
    ld h,a              ;0909 67
    ld a,l              ;090a 7d
    and e               ;090b a3
    ld l,a              ;090c 6f
    ld a,h              ;090d 7c
    or l                ;090e b5
    jp z,l092dh         ;090f ca 2d 09
    ld hl,(uu)          ;0912 2a c0 02
    ld a,l              ;0915 7d
    and 0f3h            ;0916 e6 f3
    ld l,a              ;0918 6f
    ld a,h              ;0919 7c
    and 00h             ;091a e6 00
    ld h,a              ;091c 67
    push hl             ;091d e5
    ld hl,(rr)          ;091e 2a b2 02
    add hl,hl           ;0921 29
    add hl,hl           ;0922 29
    pop de              ;0923 d1
    ld a,h              ;0924 7c
    or d                ;0925 b2
    ld h,a              ;0926 67
    ld a,l              ;0927 7d
    or e                ;0928 b3
    ld l,a              ;0929 6f
    ld (uu),hl          ;092a 22 c0 02
l092dh:
    jp l06deh           ;092d c3 de 06
l0930h:
    ;PRINT "Number of stop bits (1 or 2)  ? ";
    call pr0a
    ld hl,num_stop_bits
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H31 THEN GOTO l095eh
    ld hl,(rr)
    ld de,0-'1'
    add hl,de
    ld a,h
    or l
    jp nz,l095eh

    ld hl,(uu)          ;0948 2a c0 02
    ld a,l              ;094b 7d
    and 3fh             ;094c e6 3f
    ld l,a              ;094e 6f
    ld a,h              ;094f 7c
    and 00h             ;0950 e6 00
    ld h,a              ;0952 67
    ld a,l              ;0953 7d
    or 40h              ;0954 f6 40
    ld l,a              ;0956 6f
    ld a,h              ;0957 7c
    or 00h              ;0958 f6 00
    ld h,a              ;095a 67
    ld (uu),hl          ;095b 22 c0 02

l095eh:
    ;IF R<>&H32 THEN GOTO l0980h
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp nz,l0980h

    ld hl,(uu)          ;096a 2a c0 02
    ld a,l              ;096d 7d
    and 3fh             ;096e e6 3f
    ld l,a              ;0970 6f
    ld a,h              ;0971 7c
    and 00h             ;0972 e6 00
    ld h,a              ;0974 67
    ld a,l              ;0975 7d
    or 0c0h             ;0976 f6 c0
    ld l,a              ;0978 6f
    ld a,h              ;0979 7c
    or 00h              ;097a f6 00
    ld h,a              ;097c 67
    ld (uu),hl          ;097d 22 c0 02
l0980h:
    jp l06deh           ;0980 c3 de 06
l0983h:
    ;PRINT "O(dd), E(ven) or N(o parity) ? ";
    call pr0a
    ld hl,odd_even_none
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H4F THEN GOTO l09b1h
    ld hl,(rr)
    ld de,0-'O'
    add hl,de
    ld a,h
    or l
    jp nz,l09b1h

    ld hl,(uu)          ;099b 2a c0 02
    ld a,l              ;099e 7d
    and 0cfh            ;099f e6 cf
    ld l,a              ;09a1 6f
    ld a,h              ;09a2 7c
    and 00h             ;09a3 e6 00
    ld h,a              ;09a5 67
    ld a,l              ;09a6 7d
    or 10h              ;09a7 f6 10
    ld l,a              ;09a9 6f
    ld a,h              ;09aa 7c
    or 00h              ;09ab f6 00
    ld h,a              ;09ad 67
    ld (uu),hl          ;09ae 22 c0 02

l09b1h:
    ;IF R <> &H45 THEN GOTO l09cbh
    ld hl,(rr)
    ld de,0-'E'
    add hl,de
    ld a,h
    or l
    jp nz,l09cbh

    ld hl,(uu)          ;09bd 2a c0 02
    ld a,l              ;09c0 7d
    or 30h              ;09c1 f6 30
    ld l,a              ;09c3 6f
    ld a,h              ;09c4 7c
    or 00h              ;09c5 f6 00
    ld h,a              ;09c7 67
    ld (uu),hl          ;09c8 22 c0 02

l09cbh:
    ;IF R <> &H4E THEN GOTO l09e5h
    ld hl,(rr)
    ld de,0-'N'
    add hl,de
    ld a,h
    or l
    jp nz,l09e5h

    ld hl,(uu)          ;09d7 2a c0 02
    ld a,l              ;09da 7d
    and 0efh            ;09db e6 ef
    ld l,a              ;09dd 6f
    ld a,h              ;09de 7c
    and 00h             ;09df e6 00
    ld h,a              ;09e1 67
    ld (uu),hl          ;09e2 22 c0 02

l09e5h:
    ;GOTO l06deh
    jp l06deh

l09e8h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "110, 300, 1200, 4800, 9600 or"
    call pr0a
    ld hl,ask_bauds
    call pv2d

    ;PRINT "19200 baud ? ";
    call pr0a
    ld hl,ask_19200
    call pv1d

    ;GOSUB readline
    call readline

    ;IF N <> 110 THEN GOTO l0a1bh
    ld hl,(nn)
    ld de,0-110
    add hl,de
    ld a,h
    or l
    jp nz,l0a1bh

    ;POKE BAUD, &H22
    ld hl,0022h
    ld (baud),hl

    ;GOTO l0a2dh
    jp l0a2dh

l0a1bh:
    ;IF N <> 300 THEN GOTO l0a2dh
    ld hl,(nn)
    ld de,0-300
    add hl,de
    ld a,h
    or l
    jp nz,l0a2dh

    ;POKE BAUD, &H55
    ld hl,0055h
    ld (baud),hl

l0a2dh:
    ;IF N <> 1200 THEN GOTO l0a54h
    ld hl,(nn)
    ld de,0-1200
    add hl,de
    ld a,h
    or l
    jp nz,l0a42h

    ;POKE BAUD, &H77
    ld hl,0077h
    ld (baud),hl

    ;GOTO l0a54h
    jp l0a54h

l0a42h:
    ;IF N <> 9600 THEN GOTO l0a54h
    ld hl,(nn)
    ld de,0-9600
    add hl,de
    ld a,h
    or l
    jp nz,l0a54h

    ;POKE BAUD, &HEE
    ld hl,00eeh
    ld (baud),hl

l0a54h:
    ;IF N <> 4800 THEN GOTO l0a66h
    ld hl,(nn)
    ld de,0-4800
    add hl,de
    ld a,h
    or l
    jp nz,l0a66h

    ;POKE BAUD, &HCC
    ld hl,00cch
    ld (baud),hl

l0a66h:
    ;IF N <> 19200 THEN GOTO l0a78h
    ld hl,(nn)
    ld de,0-19200
    add hl,de
    ld a,h
    or l
    jp nz,l0a78h

    ;POKE BAUD, &HFF
    ld hl,00ffh
    ld (baud),hl

l0a78h:
    ;GOTO l06deh
    jp l06deh

l0a7bh:
    call clear_screen   ;0a7b cd bd 1b

    ;PRINT "             I/O device assignment"
    call pr0a
    ld hl,io_dev_asgn
    call pv2d

    ;PRINT "             --- ------ ----------"
    call pr0a
    ld hl,dashes_6
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "1.  Pet printer device # :    "; LPT
    call pr0a
    ld hl,io_lpt_device
    call pv1d
    ld hl,(lpt)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "2.  ASCII printer device # :  "; UL1
    call pr0a
    ld hl,io_ul1_device
    call pv1d
    ld hl,(ul1)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3.  Reader device # :         "; RDR
    call pr0a
    ld hl,io_rdr_device
    call pv1d
    ld hl,(rdr)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "4.  Punch device # :          "; PUN
    call pr0a
    ld hl,io_pun_device
    call pv1d
    ld hl,(pun)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "5.  Default LST: device :     ";
    call pr0a
    ld hl,io_lst_device
    call pv1d

    ;IF (IOBYTE AND &HC0) <> 0 THEN GOTO l0b1bh
    ld hl,(iobyte)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l0b1bh

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

l0b1bh:
    ;IF (IOBYTE AND &HC0) <> &H40 THEN GOTO l0b38h
    ld hl,(iobyte)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-&H40
    add hl,de
    ld a,h
    or l
    jp nz,l0b38h

    ;PRINT "CRT:"
    call pr0a
    ld hl,crt
    call pv2d

l0b38h:
    ;IF (IOBYTE AND &HC0) <> &H80 THEN GOTO l0b55h
    ld hl,(iobyte)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-&H80
    add hl,de
    ld a,h
    or l
    jp nz,l0b55h

    ;PRINT "LPT:"
    call pr0a
    ld hl,lpt_colon
    call pv2d

l0b55h:
    ;IF (IOBYTE AND &HC) <> &HC0 THEN GOTO l0b72h
    ld hl,(iobyte)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-&HC0
    add hl,de
    ld a,h
    or l
    jp nz,l0b72h

    ;PRINT "UL1:"
    call pr0a
    ld hl,ul1_colon
    call pv2d

l0b72h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "6.  Default RDR: device :     ";
    call pr0a
    ld hl,default_rdr
    call pv1d

    ;IF (IOBYTE AND &H0C) <> 0 THEN GOTO l0ba0h
    ld hl,(iobyte)
    ld a,l
    and 0ch
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l0ba0h

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

    ;GOTO l0ba9h
    jp l0ba9h

l0ba0h:
    ;PRINT "PTR:"
    call pr0a
    ld hl,ptr
    call pv2d

l0ba9h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "7.  Default PUN: device :     ";
    call pr0a
    ld hl,default_pun
    call pv1d

    ;IF (IOBYTE AND &H30) <> 0 THEN GOTO l0bd7h
    ld hl,(iobyte)
    ld a,l
    and 30h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l0bd7h

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

    ;GOTO l0be0h
    jp l0be0h

l0bd7h:
    ;PRINT "PTP:"
    call pr0a
    ld hl,ptp
    call pv2d

l0be0h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "8.  PET printer type :        ";
    call pr0a
    ld hl,pet_prtr_type
    call pv1d

    ld hl,(lptype)      ;0bf2 2a d4 02
    ld a,h              ;0bf5 7c
    or l                ;0bf6 b5
    jp nz,l0c03h        ;0bf7 c2 03 0c

    ;PRINT "3022/4022"
    call pr0a
    ld hl,cbm_3022_2
    call pv2d

l0c03h:
    ld hl,(lptype)      ;0c03 2a d4 02
    ld de,0ffffh        ;0c06 11 ff ff
    add hl,de           ;0c09 19
    ld a,h              ;0c0a 7c
    or l                ;0c0b b5
    jp nz,l0c18h        ;0c0c c2 18 0c

    ;PRINT "8026/8027"
    call pr0a
    ld hl,daisywheel_2
    call pv2d

l0c18h:
    ld hl,(lptype)      ;0c18 2a d4 02
    ld de,0fffeh        ;0c1b 11 fe ff
    add hl,de           ;0c1e 19
    ld a,h              ;0c1f 7c
    or l                ;0c20 b5
    jp nz,l0c2dh        ;0c21 c2 2d 0c

    ;PRINT "8024"
    call pr0a
    ld hl,cbm8024_2
    call pv2d

l0c2dh:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which (1-8) ? ";
    call pr0a
    ld hl,alter_which_1_8
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=0 THEN GOTO l05b5h
    ld hl,(rr)
    ld a,h
    or l
    jp z,l05b5h

    ;IF R=&H36 THEN GOTO l0da5h
    ld hl,(rr)
    ld de,0-'6'
    add hl,de
    ld a,h
    or l
    jp z,l0da5h

    ;IF R=&H37 THEN GOTO l0df0h
    ld hl,(rr)
    ld de,0-'7'
    add hl,de
    ld a,h
    or l
    jp z,l0df0h

    ;IF R=&H35 THEN GOTO l0ce0h
    ld hl,(rr)
    ld de,0-'5'
    add hl,de
    ld a,h
    or l
    jp z,l0ce0h

    ;IF R=&H38 THEN GOTO l0e3bh
    ld hl,(rr)
    ld de,0-'8'
    add hl,de
    ld a,h
    or l
    jp z,l0e3bh

    ;R1 = R
    ld hl,(rr)
    ld (r1),hl

    ;PRINT "New device # ? "
    call pr0a
    ld hl,new_dev_num
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R1 <> &H31 THEN GOTO l0ca7h
    ld hl,(r1)
    ld de,0-"1"
    add hl,de
    ld a,h
    or l
    jp nz,l0ca7h

    ;LPT = N
    ld hl,(nn)
    ld (lpt),hl

l0ca7h:
    ;IF R1 <> &H32 THEN GOTO l0cb9h
    ld hl,(r1)
    ld de,0-"2"
    add hl,de
    ld a,h
    or l
    jp nz,l0cb9h

    ;UL1 = N
    ld hl,(nn)
    ld (ul1),hl

l0cb9h:
    ;IF R1 <> &H33 THEN GOTO l0ccbh
    ld hl,(r1)
    ld de,0-'3'
    add hl,de
    ld a,h
    or l
    jp nz,l0ccbh

    ;RDR = N
    ld hl,(nn)
    ld (rdr),hl

l0ccbh:
    ;IF R1 <> &H34 THEN GOTO l0cddh
    ld hl,(r1)
    ld de,0-'4'
    add hl,de
    ld a,h
    or l
    jp nz,l0cddh

    ;PUN = N
    ld hl,(nn)
    ld (pun),hl

l0cddh:
    ;GOTO l0a7bh
    jp l0a7bh

l0ce0h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "T(TY:) --  RS232 printer"
    call pr0a
    ld hl,tty_rs232
    call pv2d

    ;PRINT "C(RT:) --  PET screen"
    call pr0a
    ld hl,crt_pet_scrn
    call pv2d

    ;PRINT "L(PT:) --  PET IEEE printer"
    call pr0a
    ld hl,lpt_pet
    call pv2d

    ;PRINT "U(L1:) --  ASCII IEEE printer"
    call pr0a
    ld hl,ul1_ascii
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Which list device (T, C, L or U) ? "
    call pr0a
    ld hl,which_list_dev
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H54 THEN GOTO l0d3ch
    ld hl,(rr)
    ld de,0-'T'
    add hl,de
    ld a,h
    or l
    jp nz,l0d3ch

    ;IOBYTE = (IOBYTE AND &H3F)
    ld hl,(iobyte)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (iobyte),hl

l0d3ch:
    ;IF R<>&H43 THEN GOTO l0d5eh
    ld hl,(rr)
    ld de,0-'C'
    add hl,de
    ld a,h
    or l
    jp nz,l0d5eh

    ;IOBYTE = (IOBYTE AND &H3F) OR &H40
    ld hl,(iobyte)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 40h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0d5eh:
    ;IF R<>&H4C THEN GOTO l0d80h
    ld hl,(rr)
    ld de,0-'L'
    add hl,de
    ld a,h
    or l
    jp nz,l0d80h

    ;IOBYTE = (IOBYTE AND &H3F) OR &H80
    ld hl,(iobyte)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 80h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0d80h:
    ;IF R<>&H55 THEN GOTO l0da2h
    ld hl,(rr)
    ld de,0-'U'
    add hl,de
    ld a,h
    or l
    jp nz,l0da2h

    ;IOBYTE = (IOBYTE AND &H3F) OR &HC0
    ld hl,(iobyte)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 0c0h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0da2h:
    ;GOTO l0a7bh
    jp l0a7bh

l0da5h:
    ;PRINT "T(TY:) or P(TR:) ? "
    call pr0a
    ld hl,tty_or_ptr
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H54 THEN GOTO l0dcbh
    ld hl,(rr)
    ld de,0-'T'
    add hl,de
    ld a,h
    or l
    jp nz,l0dcbh

    ;IOBYTE = (IOBYTE AND &H3F)
    ld hl,(iobyte)
    ld a,l
    and 0f3h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (iobyte),hl

l0dcbh:
    ;IF R<>&H50 THEN GOTO l0dcbh
    ld hl,(rr)          ;0dcb 2a b2 02
    ld de,0-'P'        ;0dce 11 b0 ff
    add hl,de           ;0dd1 19
    ld a,h              ;0dd2 7c
    or l                ;0dd3 b5
    jp nz,l0dedh        ;0dd4 c2 ed 0d

    ;IOBYTE = (IOBYTE AND &HF3) OR &H04
    ld hl,(iobyte)
    ld a,l
    and 0f3h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 04h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0dedh:
    jp l0a7bh           ;0ded c3 7b 0a

l0df0h:
    ;PRINT "T(TY:) or P(TP:) ? ";
    call pr0a
    ld hl,tty_or_ptp
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H54 THEN GOTO l0e16h
    ld hl,(rr)
    ld de,0-'T'
    add hl,de
    ld a,h
    or l
    jp nz,l0e16h

    ;IOBYTE = (IOBYTE AND &HCF)
    ld hl,(iobyte)
    ld a,l
    and 0cfh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (iobyte),hl

l0e16h:
    ;IF R<>&H50 THEN GOTO l0e38h
    ld hl,(rr)
    ld de,0-'P'
    add hl,de
    ld a,h
    or l
    jp nz,l0e38h

    ;IOBYTE = (IOBYTE AND &HCF) OR &H10
    ld hl,(iobyte)
    ld a,l
    and 0cfh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 10h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0e38h:
    jp l0a7bh           ;0e38 c3 7b 0a

l0e3bh:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3 = 3022, 3023, 4022 or 4023"
    call pr0a
    ld hl,cbm3022
    call pv2d

    ;PRINT "8 = 8024"
    call pr0a
    ld hl,cbm8024
    call pv2d

    ;PRINT "D = 8026 or 8027 (daisywheel)"
    call pr0a
    ld hl,daisywheel
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Which type of printer (3, 8 or D) ? ";
    call pr0a
    ld hl,which_printer
    call pv1d

    ;IF R<>&H33 THEN GOTO l0e86h
    call readline
    ld hl,(rr)
    ld de,0-'3'
    add hl,de
    ld a,h
    or l
    jp nz,l0e86h

    ;LPTYPE = 0
    ld hl,0000h
    ld (lptype),hl

l0e86h:
    ;IF R<>&H38 THEN GOTO l0e98h
    ld hl,(rr)
    ld de,0-'8'
    add hl,de
    ld a,h
    or l
    jp nz,l0e98h

    ;LPTYPE = 2
    ld hl,0002h
    ld (lptype),hl

l0e98h:
    ;IF R<>&H44 THEN GOTO l0eaah
    ld hl,(rr)
    ld de,0-'D'
    add hl,de
    ld a,h
    or l
    jp nz,l0eaah

    ;LPTYPE = 1
    ld hl,0001h
    ld (lptype),hl

l0eaah:
    ;GOTO l0a7bh
    jp l0a7bh

l0eadh:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "            Disk drive assignment"
    call pr0a
    ld hl,drv_assgnmt
    call pv2d

    ;PRINT "            ---- ----- ----------"
    call pr0a
    ld hl,dashes_2
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "A, B :     ";
    call pr0a
    ld hl,drives_a_b
    call pv1d

    ;D = 0
    ld hl,0000h
    ld (dd),hl

    call sub_119ah      ;0eda cd 9a 11

    ;PRINT "C, D :     "
    call pr0a
    ld hl,drives_c_d
    call pv1d

    ;D = 1
    ld hl,0001h
    ld (dd),hl

    call sub_119ah      ;0eec cd 9a 11

    ;PRINT "E, F :     ";
    call pr0a
    ld hl,drives_e_f
    call pv1d

    ;D = 2
    ld hl,0002h
    ld (dd),hl

    call sub_119ah      ;0efe cd 9a 11

    ;PRINT "G, H :     ";
    call pr0a
    ld hl,drives_g_h
    call pv1d

    ;D = 3
    ld hl,0003h
    ld (dd),hl

    call sub_119ah      ;0f10 cd 9a 11

    ;PRINT "I, J :     ";
    call pr0a
    ld hl,drives_i_j
    call pv1d

    ;D = 4
    ld hl,0004h
    ld (dd),hl

    call sub_119ah      ;0f22 cd 9a 11

    ;PRINT "K, L :     ";
    call pr0a
    ld hl,drives_k_l
    call pv1d

    ;D = 5
    ld hl,0005h
    ld (dd),hl

    call sub_119ah      ;0f34 cd 9a 11

    ;PRINT "M, N :     ";
    call pr0a
    ld hl,drives_m_n
    call pv1d

    ;D = 6
    ld hl,0006h
    ld (dd),hl

    call sub_119ah      ;0f46 cd 9a 11

    ;"O, P :     ";
    call pr0a
    ld hl,drives_o_p
    call pv1d

    ;D = 7
    ld hl,0007h
    ld (dd),hl

    call sub_119ah      ;0f58 cd 9a 11

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which drive pair (A to O) ? ";
    call pr0a
    ld hl,alter_which_pair
    call pv1d

    ;GOSUB readline
    call readline       ;0f6d cd ca 1b

    ;IF R=0 THEN GOTO l05b5h
    ld hl,(rr)
    ld a,h
    or l
    jp z,l05b5h

    ld hl,(rr)          ;0f78 2a b2 02
    ld de,0ffbfh        ;0f7b 11 bf ff
    ld a,h              ;0f7e 7c
    rla                 ;0f7f 17
    jp c,l0f85h         ;0f80 da 85 0f
    add hl,de           ;0f83 19
    add hl,hl           ;0f84 29
l0f85h:
    sbc a,a             ;0f85 9f
    ld h,a              ;0f86 67
    ld l,a              ;0f87 6f
    push hl             ;0f88 e5
    ld hl,(rr)          ;0f89 2a b2 02
    ld de,0ffafh        ;0f8c 11 af ff
    ld a,h              ;0f8f 7c
    rla                 ;0f90 17
    jp c,l0f96h         ;0f91 da 96 0f
    add hl,de           ;0f94 19
    add hl,hl           ;0f95 29
l0f96h:
    ccf                 ;0f96 3f
    sbc a,a             ;0f97 9f
    ld h,a              ;0f98 67
    ld l,a              ;0f99 6f
    pop de              ;0f9a d1
    ld a,h              ;0f9b 7c
    or d                ;0f9c b2
    ld h,a              ;0f9d 67
    ld a,l              ;0f9e 7d
    or e                ;0f9f b3
    ld l,a              ;0fa0 6f
    ld a,h              ;0fa1 7c
    or l                ;0fa2 b5
    jp nz,l0eadh        ;0fa3 c2 ad 0e
    ld de,0ffbfh        ;0fa6 11 bf ff
    ld hl,(rr)          ;0fa9 2a b2 02
    add hl,de           ;0fac 19
    call idva           ;0fad cd 64 2c
    ld (bc),a           ;0fb0 02
    nop                 ;0fb1 00
    ld (dd),hl          ;0fb2 22 dc 02

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3(040), 8(050), h(ard) or u(nused) ? "
    call pr0a
    ld hl,cbm_hard_unused
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H33 THEN GOTO l0fe7h
    ld hl,(rr)
    ld de,0-'3'         ;3(040)
    add hl,de
    ld a,h
    or l
    jp nz,l0fe7h

    ld hl,(dd)          ;0fd6 2a dc 02
    add hl,hl           ;0fd9 29
    ld de,drv           ;0fda 11 0e 01
    add hl,de           ;0fdd 19
    ld de,0000h         ;0fde 11 00 00
    ld (hl),e           ;0fe1 73
    inc hl              ;0fe2 23
    ld (hl),d           ;0fe3 72
    jp l109fh           ;0fe4 c3 9f 10

l0fe7h:
    ;IF R <> &H38 THEN GOTO l1004h
    ld hl,(rr)
    ld de,0-'8'         ;8(050)
    add hl,de
    ld a,h
    or l
    jp nz,l1004h

    ;POKE DRV(D), 1
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,0001h
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l1004h:
    ;IF R <> &H54 THEN GOTO l1021h
    ld hl,(rr)
    ld de,0-'U'         ;u(nused)
    add hl,de
    ld a,h
    or l
    jp nz,l1021h

    ;POKE DRV(D), 255
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,00ffh
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l0eadh
    jp l0eadh

l1021h:
    ;IF R <> &H47 THEN GOTO l0eadh  ' h(ard)
    ld hl,(rr)
    ld de,0-'H'         ;(h)ard
    add hl,de
    ld a,h
    or l
    jp nz,l0eadh

    ;IF MINI = 1 THEN GOTO l10fbh
    ld hl,(mini)
    ld de,0-1
    add hl,de
    ld a,h
    or l
    jp z,l10fbh

    ;PRINT "5, 10 or 20 Mbyte drive ? ";
    call pr0a
    ld hl,drv_5_10_20
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H35 THEN GOTO l1062h
    ld hl,(rr)
    ld de,0-'5'         ;5 Mbyte
    add hl,de
    ld a,h
    or l
    jp nz,l1062h

    ;POKE DRV(D), 4
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,0004h
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l1062h:
    ;IF R <> &H31 THEN GOTO l107fh
    ld hl,(rr)
    ld de,0-'1'         ;10 Mbyte
    add hl,de
    ld a,h
    or l
    jp nz,l107fh

    ;POKE DRV(D), 2
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,0002h
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l107fh:
    ;IF R <> &H32 THEN GOTO l109ch
    ld hl,(rr)
    ld de,0-'2'         ;20 Mbyte
    add hl,de
    ld a,h
    or l
    jp nz,l109ch

    ;POKE DRV(D), 3
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,0003h
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l109ch:
    ;GOTO l0eadh
    jp l0eadh

l109fh:
    ;PRINT "Device number for drive ? ";
    call pr0a
    ld hl,dev_num_for_drv
    call pv1d

    call readline       ;10a8 cd ca 1b
    ld hl,(dd)          ;10ab 2a dc 02
    add hl,hl           ;10ae 29
    ld de,diskdev       ;10af 11 24 01
    add hl,de           ;10b2 19
    push hl             ;10b3 e5
    ld hl,(nn)          ;10b4 2a d8 02
    ex de,hl            ;10b7 eb
    pop hl              ;10b8 e1
    ld (hl),e           ;10b9 73
    inc hl              ;10ba 23
    ld (hl),d           ;10bb 72
    ld hl,(dd)          ;10bc 2a dc 02
    add hl,hl           ;10bf 29
    ld de,drv           ;10c0 11 0e 01
    add hl,de           ;10c3 19
    ld e,(hl)           ;10c4 5e
    inc hl              ;10c5 23
    ld d,(hl)           ;10c6 56
    push de             ;10c7 d5
    pop hl              ;10c8 e1
    ld de,0fffch        ;10c9 11 fc ff
    add hl,de           ;10cc 19
    ld a,h              ;10cd 7c
    or l                ;10ce b5
    jp nz,l0eadh        ;10cf c2 ad 0e

    ;PRINT "Configure as 1 or 2 CP/M drives ? ";
    call pr0a
    ld hl,config_as_1_or_2
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H32 THEN GOTO l10f8h
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp nz,l10f8h

    ld hl,(dd)          ;10ea 2a dc 02
    add hl,hl           ;10ed 29
    ld de,drv           ;10ee 11 0e 01
    add hl,de           ;10f1 19
    ld de,0005h         ;10f2 11 05 00
    ld (hl),e           ;10f5 73
    inc hl              ;10f6 23
    ld (hl),d           ;10f7 72
l10f8h:
    jp l0eadh           ;10f8 c3 ad 0e

l10fbh:
    ;PRINT "3, 6 or 12 Mbyte drive ? ";
    call pr0a
    ld hl,drv_3_6_12
    call pv1d

    ;GOSUB readline
    call readline

    ld hl,(nn)          ;1107 2a d8 02
    ld de,0fffdh        ;110a 11 fd ff
    add hl,de           ;110d 19
    ld a,h              ;110e 7c
    or l                ;110f b5
    jp nz,l1124h        ;1110 c2 24 11
    ld hl,(dd)          ;1113 2a dc 02
    add hl,hl           ;1116 29
    ld de,drv           ;1117 11 0e 01
    add hl,de           ;111a 19
    ld de,0002h         ;111b 11 02 00
    ld (hl),e           ;111e 73
    inc hl              ;111f 23
    ld (hl),d           ;1120 72
    jp l1161h           ;1121 c3 61 11
l1124h:
    ld hl,(nn)          ;1124 2a d8 02
    ld de,0fffah        ;1127 11 fa ff
    add hl,de           ;112a 19
    ld a,h              ;112b 7c
    or l                ;112c b5
    jp nz,l1141h        ;112d c2 41 11
    ld hl,(dd)          ;1130 2a dc 02
    add hl,hl           ;1133 29
    ld de,drv           ;1134 11 0e 01
    add hl,de           ;1137 19
    ld de,0003h         ;1138 11 03 00
    ld (hl),e           ;113b 73
    inc hl              ;113c 23
    ld (hl),d           ;113d 72
    jp l1161h           ;113e c3 61 11
l1141h:
    ld hl,(nn)          ;1141 2a d8 02
    ld de,0fff4h        ;1144 11 f4 ff
    add hl,de           ;1147 19
    ld a,h              ;1148 7c
    or l                ;1149 b5
    jp nz,l115eh        ;114a c2 5e 11
    ld hl,(dd)          ;114d 2a dc 02
    add hl,hl           ;1150 29
    ld de,drv           ;1151 11 0e 01
    add hl,de           ;1154 19
    ld de,0004h         ;1155 11 04 00
    ld (hl),e           ;1158 73
    inc hl              ;1159 23
    ld (hl),d           ;115a 72
    jp l1161h           ;115b c3 61 11
l115eh:
    jp l0eadh           ;115e c3 ad 0e
l1161h:
    ;PRINT "Use the ENTIRE drive for CP/M,  or just"
    call pr0a
    ld hl,use_entire_drv
    call pv2d

    ;PRINT "use the FIRST HALF (E/H)  ? ";
    call pr0a
    ld hl,use_first_half
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H48 THEN GOTO l1197h
    ld hl,(rr)
    ld de,0-'H'
    add hl,de
    ld a,h
    or l
    jp nz,l1197h

    ld hl,(dd)          ;1182 2a dc 02
    add hl,hl           ;1185 29
    ld de,drv           ;1186 11 0e 01
    add hl,de           ;1189 19
    push hl             ;118a e5
    ld e,(hl)           ;118b 5e
    inc hl              ;118c 23
    ld d,(hl)           ;118d 56
    ex de,hl            ;118e eb
    inc hl              ;118f 23
    inc hl              ;1190 23
    inc hl              ;1191 23
    ex de,hl            ;1192 eb
    pop hl              ;1193 e1
    ld (hl),e           ;1194 73
    inc hl              ;1195 23
    ld (hl),d           ;1196 72
l1197h:
    jp l0eadh           ;1197 c3 ad 0e
sub_119ah:
    ld hl,(dd)          ;119a 2a dc 02
    add hl,hl           ;119d 29
    ld de,drv           ;119e 11 0e 01
    add hl,de           ;11a1 19
    ld e,(hl)           ;11a2 5e
    inc hl              ;11a3 23
    ld d,(hl)           ;11a4 56
    ex de,hl            ;11a5 eb
    ld a,h              ;11a6 7c
    or l                ;11a7 b5
    jp nz,l11b7h        ;11a8 c2 b7 11

    ;PRINT "3040/4040  ";
    call pr0a
    ld hl,cbm_3040
    call pv1d

    jp l1285h           ;11b4 c3 85 12
l11b7h:
    ld hl,(dd)          ;11b7 2a dc 02
    add hl,hl           ;11ba 29
    ld de,drv           ;11bb 11 0e 01
    add hl,de           ;11be 19
    ld e,(hl)           ;11bf 5e
    inc hl              ;11c0 23
    ld d,(hl)           ;11c1 56
    push de             ;11c2 d5
    pop hl              ;11c3 e1
    ld de,0ffffh        ;11c4 11 ff ff
    add hl,de           ;11c7 19
    ld a,h              ;11c8 7c
    or l                ;11c9 b5
    jp nz,l11d9h        ;11ca c2 d9 11

    ;PRINT "8050       ";
    call pr0a
    ld hl,cbm_8050
    call pv1d

    jp l1285h           ;11d6 c3 85 12
l11d9h:
    ld hl,(dd)          ;11d9 2a dc 02
    add hl,hl           ;11dc 29
    ld de,drv           ;11dd 11 0e 01
    add hl,de           ;11e0 19
    ld e,(hl)           ;11e1 5e
    inc hl              ;11e2 23
    ld d,(hl)           ;11e3 56
    push de             ;11e4 d5
    pop hl              ;11e5 e1
    ld de,0ff7fh        ;11e6 11 7f ff
    ld a,h              ;11e9 7c
    rla                 ;11ea 17
    jp c,l11f0h         ;11eb da f0 11
    add hl,de           ;11ee 19
    add hl,hl           ;11ef 29
l11f0h:
    jp c,l11fdh         ;11f0 da fd 11

    ;PRINT "not used"
    call pr0a
    ld hl,not_used
    call pv2d

    ret                 ;11fc c9
l11fdh:
    ;IF MINI = 1 THEN GOTO l129eh
    ld hl,(mini)
    ld de,0ffffh
    add hl,de
    ld a,h
    or l
    jp z,l129eh

    ;IF DRV (D) = 2 THEN GOTO l1228h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0fffeh
    add hl,de
    ld a,h
    or l
    jp nz,l1228h

    ;PRINT "Corvus 10Mb"
    call pr0a
    ld hl,cor_10mb
    call pv1d

l1228h:
    ld hl,(dd)          ;1228 2a dc 02
    add hl,hl           ;122b 29
    ld de,drv           ;122c 11 0e 01
    add hl,de           ;122f 19
    ld e,(hl)           ;1230 5e
    inc hl              ;1231 23
    ld d,(hl)           ;1232 56
    push de             ;1233 d5
    pop hl              ;1234 e1
    ld de,0fffdh        ;1235 11 fd ff
    add hl,de           ;1238 19
    ld a,h              ;1239 7c
    or l                ;123a b5
    jp nz,l1247h        ;123b c2 47 12

    ;PRINT "Corvus 20Mb"
    call pr0a
    ld hl,cor_20mb
    call pv1d

l1247h:
    ld hl,(dd)          ;1247 2a dc 02
    add hl,hl           ;124a 29
    ld de,drv           ;124b 11 0e 01
    add hl,de           ;124e 19
    ld e,(hl)           ;124f 5e
    inc hl              ;1250 23
    ld d,(hl)           ;1251 56
    push de             ;1252 d5
    pop hl              ;1253 e1
    ld de,0fffch        ;1254 11 fc ff
    add hl,de           ;1257 19
    ld a,h              ;1258 7c
    or l                ;1259 b5
    jp nz,l1266h        ;125a c2 66 12

    ;PRINT "Corvus 5Mb ";
    call pr0a
    ld hl,cor_5mb
    call pv1d

l1266h:
    ld hl,(dd)          ;1266 2a dc 02
    add hl,hl           ;1269 29
    ld de,drv           ;126a 11 0e 01
    add hl,de           ;126d 19
    ld e,(hl)           ;126e 5e
    inc hl              ;126f 23
    ld d,(hl)           ;1270 56
    push de             ;1271 d5
    pop hl              ;1272 e1
    ld de,0fffbh        ;1273 11 fb ff
    add hl,de           ;1276 19
    ld a,h              ;1277 7c
    or l                ;1278 b5
    jp nz,l1285h        ;1279 c2 85 12

    ;PRINT "Corvus 5Mb*";
    call pr0a
    ld hl,cor_5mb_star
    call pv1d

l1285h:
    ;PRINT"   Device #";
    call pr0a
    ld hl,device_num
    call pv0d

    ld hl,(dd)          ;128e 2a dc 02
    add hl,hl           ;1291 29
    ld de,diskdev       ;1292 11 24 01
    add hl,de           ;1295 19
    ld e,(hl)           ;1296 5e
    inc hl              ;1297 23
    ld d,(hl)           ;1298 56
    ex de,hl            ;1299 eb
    call pv2c           ;129a cd c8 2c
    ret                 ;129d c9

l129eh:
    ;PRINT "Winchester    ";
    call pr0a
    ld hl,winchester
    call pv1d

    ld hl,(dd)          ;12a7 2a dc 02
    add hl,hl           ;12aa 29
    ld de,drv           ;12ab 11 0e 01
    add hl,de           ;12ae 19
    ld e,(hl)           ;12af 5e
    inc hl              ;12b0 23
    ld d,(hl)           ;12b1 56
    push de             ;12b2 d5
    pop hl              ;12b3 e1
    ld de,0fffeh        ;12b4 11 fe ff
    add hl,de           ;12b7 19
    ld a,h              ;12b8 7c
    or l                ;12b9 b5
    jp nz,l12c6h        ;12ba c2 c6 12

    call pr0a           ;12bd cd 3d 2d
    ld hl,mw_3mb        ;12c0 21 b9 1f
    call pv2d           ;12c3 cd 31 2c

l12c6h:
    ld hl,(dd)          ;12c6 2a dc 02
    add hl,hl           ;12c9 29
    ld de,drv           ;12ca 11 0e 01
    add hl,de           ;12cd 19
    ld e,(hl)           ;12ce 5e
    inc hl              ;12cf 23
    ld d,(hl)           ;12d0 56
    push de             ;12d1 d5
    pop hl              ;12d2 e1
    ld de,0fffdh        ;12d3 11 fd ff
    add hl,de           ;12d6 19
    ld a,h              ;12d7 7c
    or l                ;12d8 b5
    jp nz,l12e5h        ;12d9 c2 e5 12
    call pr0a           ;12dc cd 3d 2d
    ld hl,mw_6mb        ;12df 21 af 1f
    call pv2d           ;12e2 cd 31 2c
l12e5h:
    ld hl,(dd)          ;12e5 2a dc 02
    add hl,hl           ;12e8 29
    ld de,drv           ;12e9 11 0e 01
    add hl,de           ;12ec 19
    ld e,(hl)           ;12ed 5e
    inc hl              ;12ee 23
    ld d,(hl)           ;12ef 56
    push de             ;12f0 d5
    pop hl              ;12f1 e1
    ld de,0fffch        ;12f2 11 fc ff
    add hl,de           ;12f5 19
    ld a,h              ;12f6 7c
    or l                ;12f7 b5
    jp nz,l1304h        ;12f8 c2 04 13
    call pr0a           ;12fb cd 3d 2d
    ld hl,mw_12mb       ;12fe 21 9f 1f
    call pv2d           ;1301 cd 31 2c
l1304h:
    ld hl,(dd)          ;1304 2a dc 02
    add hl,hl           ;1307 29
    ld de,drv           ;1308 11 0e 01
    add hl,de           ;130b 19
    ld e,(hl)           ;130c 5e
    inc hl              ;130d 23
    ld d,(hl)           ;130e 56
    push de             ;130f d5
    pop hl              ;1310 e1
    ld de,0fffbh        ;1311 11 fb ff
    add hl,de           ;1314 19
    ld a,h              ;1315 7c
    or l                ;1316 b5
    jp nz,l1323h        ;1317 c2 23 13

    ;PRINT "3 Mbyte     "
    call pr0a
    ld hl,mw_3mb_half
    call pv2d

l1323h:
    ld hl,(dd)          ;1323 2a dc 02
    add hl,hl           ;1326 29
    ld de,drv           ;1327 11 0e 01
    add hl,de           ;132a 19
    ld e,(hl)           ;132b 5e
    inc hl              ;132c 23
    ld d,(hl)           ;132d 56
    push de             ;132e d5
    pop hl              ;132f e1
    ld de,0fffah        ;1330 11 fa ff
    add hl,de           ;1333 19
    ld a,h              ;1334 7c
    or l                ;1335 b5
    jp nz,l1342h        ;1336 c2 42 13

    ;PRINT "6 Mbyte (half)"
    call pr0a
    ld hl,mw_6mb_half
    call pv2d

l1342h:
    ld hl,(dd)          ;1342 2a dc 02
    add hl,hl           ;1345 29
    ld de,drv           ;1346 11 0e 01
    add hl,de           ;1349 19
    ld e,(hl)           ;134a 5e
    inc hl              ;134b 23
    ld d,(hl)           ;134c 56
    push de             ;134d d5
    pop hl              ;134e e1
    ld de,0fff9h        ;134f 11 f9 ff
    add hl,de           ;1352 19
    ld a,h              ;1353 7c
    or l                ;1354 b5
    jp nz,l1361h        ;1355 c2 61 13

    ;PRINT "12Mbyte (half)"
    call pr0a
    ld hl,mw_12mb_half
    call pv2d

l1361h:
    ret                 ;1361 c9

l1362h:
    ;GOSUB clear_screen
    call clear_screen

    ;IF AUTOLOAD(0) <> 0 THEN GOTO l1379h
    ld hl,(autoload)
    ld a,h
    or l
    jp nz,l1379h

    ;PRINT "No current autoload command"
    call pr0a
    ld hl,no_aload_cmd
    call pv2d

    jp l13bfh           ;1376 c3 bf 13
l1379h:
    ;PRINT "Current autoload command is :"
    call pr0a
    ld hl,cur_aload_is
    call pv2d

    ld hl,(autoload)    ;1382 2a 3a 01
    ld (l02deh),hl      ;1385 22 de 02
    ld hl,0001h         ;1388 21 01 00
    jp l13a7h           ;138b c3 a7 13
l138eh:
    call pr0a           ;138e cd 3d 2d
    ld hl,(l02d0h)      ;1391 2a d0 02
    add hl,hl           ;1394 29
    ld de,autoload      ;1395 11 3a 01
    add hl,de           ;1398 19
    ld e,(hl)           ;1399 5e
    inc hl              ;139a 23
    ld d,(hl)           ;139b 56
    ex de,hl            ;139c eb
    call chr            ;139d cd 24 2c
    call pv1d           ;13a0 cd 3c 2c
    ld hl,(l02d0h)      ;13a3 2a d0 02
    inc hl              ;13a6 23
l13a7h:
    ld (l02d0h),hl      ;13a7 22 d0 02
    ld hl,(l02d0h)      ;13aa 2a d0 02
    ex de,hl            ;13ad eb
    ld hl,(l02deh)      ;13ae 2a de 02
    ld a,d              ;13b1 7a
    xor h               ;13b2 ac
    ld a,h              ;13b3 7c
    jp m,l13bbh         ;13b4 fa bb 13
    ld a,l              ;13b7 7d
    sub e               ;13b8 93
    ld a,h              ;13b9 7c
    sbc a,d             ;13ba 9a
l13bbh:
    rla                 ;13bb 17
    jp nc,l138eh        ;13bc d2 8e 13
l13bfh:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "New autoload command (Y/N) ? ";
    call pr0a
    ld hl,new_aload_yn
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H59 THEN GOTO l05b5h
    ld hl,(rr)
    ld de,0-'Y'
    add hl,de
    ld a,h
    or l
    jp nz,l05b5h

    ;PRINT "Please enter the new command : "
    call pr0a
    ld hl,new_command
    call pv2d

    ;GOSUB readline
    call readline

    ld hl,(buf)         ;13ec 2a e0 02
    inc hl              ;13ef 23
    ld l,(hl)           ;13f0 6e
    ld h,00h            ;13f1 26 00
    ld (autoload),hl    ;13f3 22 3a 01
    ld hl,0001h         ;13f6 21 01 00
    jp l145ah           ;13f9 c3 5a 14
l13fch:
    ld hl,(buf)         ;13fc 2a e0 02
    ex de,hl            ;13ff eb
    ld hl,(l02d0h)      ;1400 2a d0 02
    add hl,de           ;1403 19
    inc hl              ;1404 23
    ld l,(hl)           ;1405 6e
    ld h,00h            ;1406 26 00
    push hl             ;1408 e5
    ld hl,(l02d0h)      ;1409 2a d0 02
    add hl,hl           ;140c 29
    ld de,autoload      ;140d 11 3a 01
    add hl,de           ;1410 19
    pop de              ;1411 d1
    ld (hl),e           ;1412 73
    inc hl              ;1413 23
    ld (hl),d           ;1414 72
    ld hl,(l02d0h)      ;1415 2a d0 02
    add hl,hl           ;1418 29
    ld de,autoload      ;1419 11 3a 01
    add hl,de           ;141c 19
    ld e,(hl)           ;141d 5e
    inc hl              ;141e 23
    ld d,(hl)           ;141f 56
    push de             ;1420 d5
    pop hl              ;1421 e1
    push hl             ;1422 e5
    ld de,0ff9fh        ;1423 11 9f ff
    ld a,h              ;1426 7c
    rla                 ;1427 17
    jp c,l142dh         ;1428 da 2d 14
    add hl,de           ;142b 19
    add hl,hl           ;142c 29
l142dh:
    ccf                 ;142d 3f
    sbc a,a             ;142e 9f
    ld h,a              ;142f 67
    ld l,a              ;1430 6f
    ld (02eah),hl       ;1431 22 ea 02
    pop hl              ;1434 e1
    ld de,0ff85h        ;1435 11 85 ff
    ld a,h              ;1438 7c
    rla                 ;1439 17
    jp c,l143fh         ;143a da 3f 14
    add hl,de           ;143d 19
    add hl,hl           ;143e 29
l143fh:
    sbc a,a             ;143f 9f
    ld h,a              ;1440 67
    ld l,a              ;1441 6f
    push hl             ;1442 e5
    ld hl,(02eah)       ;1443 2a ea 02
    ex de,hl            ;1446 eb
    pop hl              ;1447 e1
    ld a,h              ;1448 7c
    and d               ;1449 a2
    ld h,a              ;144a 67
    ld a,l              ;144b 7d
    and e               ;144c a3
    ld l,a              ;144d 6f
    ld a,h              ;144e 7c
    or l                ;144f b5
    jp z,l1456h         ;1450 ca 56 14
    call sub_147eh      ;1453 cd 7e 14
l1456h:
    ld hl,(l02d0h)      ;1456 2a d0 02
    inc hl              ;1459 23
l145ah:
    ld (l02d0h),hl      ;145a 22 d0 02
    ld hl,(l02d0h)      ;145d 2a d0 02
    ld de,0ffafh        ;1460 11 af ff
    ld a,h              ;1463 7c
    rla                 ;1464 17
    jp c,l146ah         ;1465 da 6a 14
    add hl,de           ;1468 19
    add hl,hl           ;1469 29
l146ah:
    jp c,l13fch         ;146a da fc 13
    ld hl,(autoload)    ;146d 2a 3a 01
    add hl,hl           ;1470 29
    ld de,autoload+2    ;1471 11 3c 01
    add hl,de           ;1474 19
    ld de,0000h         ;1475 11 00 00
    ld (hl),e           ;1478 73
    inc hl              ;1479 23
    ld (hl),d           ;147a 72
    jp l05b5h           ;147b c3 b5 05
sub_147eh:
    ld hl,(l02d0h)      ;147e 2a d0 02
    add hl,hl           ;1481 29
    ld de,autoload      ;1482 11 3a 01
    add hl,de           ;1485 19
    push hl             ;1486 e5
    ld e,(hl)           ;1487 5e
    inc hl              ;1488 23
    ld d,(hl)           ;1489 56
    ld hl,0ffe0h        ;148a 21 e0 ff
    add hl,de           ;148d 19
    ex de,hl            ;148e eb
    pop hl              ;148f e1
    ld (hl),e           ;1490 73
    inc hl              ;1491 23
    ld (hl),d           ;1492 72
    ret                 ;1493 c9
l1494h:
    call sub_149ah      ;1494 cd 9a 14
    call exsys          ;1497 cd a9 28
sub_149ah:
    ld hl,0000h         ;149a 21 00 00
    jp l14dah           ;149d c3 da 14
l14a0h:
    ld hl,(l02d0h)      ;14a0 2a d0 02
    add hl,hl           ;14a3 29
    ld de,drv           ;14a4 11 0e 01
    add hl,de           ;14a7 19
    ld e,(hl)           ;14a8 5e
    inc hl              ;14a9 23
    ld d,(hl)           ;14aa 56
    ex de,hl            ;14ab eb
    push hl             ;14ac e5
    ld hl,(bias)        ;14ad 2a ae 02
    ex de,hl            ;14b0 eb
    ld hl,(l02d0h)      ;14b1 2a d0 02
    add hl,de           ;14b4 19
    ld de,4a70h         ;14b5 11 70 4a
    add hl,de           ;14b8 19
    pop de              ;14b9 d1
    ld (hl),e           ;14ba 73
    ld hl,(l02d0h)      ;14bb 2a d0 02
    add hl,hl           ;14be 29
    ld de,diskdev       ;14bf 11 24 01
    add hl,de           ;14c2 19
    ld e,(hl)           ;14c3 5e
    inc hl              ;14c4 23
    ld d,(hl)           ;14c5 56
    ex de,hl            ;14c6 eb
    push hl             ;14c7 e5
    ld hl,(bias)        ;14c8 2a ae 02
    ex de,hl            ;14cb eb
    ld hl,(l02d0h)      ;14cc 2a d0 02
    add hl,de           ;14cf 19
    ld de,4a78h         ;14d0 11 78 4a
    add hl,de           ;14d3 19
    pop de              ;14d4 d1
    ld (hl),e           ;14d5 73
    ld hl,(l02d0h)      ;14d6 2a d0 02
    inc hl              ;14d9 23
l14dah:
    ld (l02d0h),hl      ;14da 22 d0 02
    ld hl,(l02d0h)      ;14dd 2a d0 02
    ld de,0fff8h        ;14e0 11 f8 ff
    ld a,h              ;14e3 7c
    rla                 ;14e4 17
    jp c,l14eah         ;14e5 da ea 14
    add hl,de           ;14e8 19
    add hl,hl           ;14e9 29
l14eah:
    jp c,l14a0h         ;14ea da a0 14
    jp l1525h           ;14ed c3 25 15
    sbc a,(hl)          ;14f0 9e
    jr z,l1513h         ;14f1 28 20
    ld l,h              ;14f3 6c
    ld l,c              ;14f4 69
    ld l,(hl)           ;14f5 6e
    ld h,l              ;14f6 65
    jr nz,l152fh        ;14f7 20 36
    dec (hl)            ;14f9 35
    inc (hl)            ;14fa 34
    jr nc,l151dh        ;14fb 30 20
    dec hl              ;14fd 2b
    dec hl              ;14fe 2b
    dec hl              ;14ff 2b
    dec hl              ;1500 2b
    dec hl              ;1501 2b
    dec hl              ;1502 2b
    dec hl              ;1503 2b
    dec hl              ;1504 2b
    dec hl              ;1505 2b
    dec hl              ;1506 2b
    dec hl              ;1507 2b
    dec hl              ;1508 2b
    dec hl              ;1509 2b
    dec hl              ;150a 2b
    dec hl              ;150b 2b
    dec hl              ;150c 2b
    dec hl              ;150d 2b
    dec hl              ;150e 2b
    dec hl              ;150f 2b
    dec hl              ;1510 2b
    dec hl              ;1511 2b
    dec hl              ;1512 2b
l1513h:
    dec hl              ;1513 2b
    dec hl              ;1514 2b
    dec hl              ;1515 2b
    dec hl              ;1516 2b
    dec hl              ;1517 2b
    dec hl              ;1518 2b
    dec hl              ;1519 2b
    dec hl              ;151a 2b
    dec hl              ;151b 2b
    dec hl              ;151c 2b
l151dh:
    dec hl              ;151d 2b
    dec hl              ;151e 2b
    dec hl              ;151f 2b
    dec hl              ;1520 2b
    dec hl              ;1521 2b
    dec hl              ;1522 2b
    dec hl              ;1523 2b
    nop                 ;1524 00
l1525h:
    ld hl,(iobyte)      ;1525 2a 0c 01
    ld de,4a60h         ;1528 11 60 4a
    push hl             ;152b e5
    ld hl,(bias)        ;152c 2a ae 02
l152fh:
    add hl,de           ;152f 19
    pop de              ;1530 d1
    ld (hl),e           ;1531 73
    ld hl,(lpt)         ;1532 2a ba 02
    ld de,4a61h         ;1535 11 61 4a
    push hl             ;1538 e5
    ld hl,(bias)        ;1539 2a ae 02
    add hl,de           ;153c 19
    pop de              ;153d d1
    ld (hl),e           ;153e 73
    ld hl,(rdr)         ;153f 2a bc 02
    ld de,4a62h         ;1542 11 62 4a
    push hl             ;1545 e5
    ld hl,(bias)        ;1546 2a ae 02
    add hl,de           ;1549 19
    pop de              ;154a d1
    ld (hl),e           ;154b 73
    ld hl,(pun)         ;154c 2a be 02
    ld de,4a63h         ;154f 11 63 4a
    push hl             ;1552 e5
    ld hl,(bias)        ;1553 2a ae 02
    add hl,de           ;1556 19
    pop de              ;1557 d1
    ld (hl),e           ;1558 73
    ld hl,(uu)          ;1559 2a c0 02
    ld a,l              ;155c 7d
    and 0fch            ;155d e6 fc
    ld l,a              ;155f 6f
    ld a,h              ;1560 7c
    and 00h             ;1561 e6 00
    ld h,a              ;1563 67
    ld a,l              ;1564 7d
    or 02h              ;1565 f6 02
    ld l,a              ;1567 6f
    ld a,h              ;1568 7c
    or 00h              ;1569 f6 00
    ld h,a              ;156b 67
    ld de,4a64h         ;156c 11 64 4a
    push hl             ;156f e5
    ld hl,(bias)        ;1570 2a ae 02
    add hl,de           ;1573 19
    pop de              ;1574 d1
    ld (hl),e           ;1575 73
    ld hl,(baud)        ;1576 2a c2 02
    ld de,4a65h         ;1579 11 65 4a
    push hl             ;157c e5
    ld hl,(bias)        ;157d 2a ae 02
    add hl,de           ;1580 19
    pop de              ;1581 d1
    ld (hl),e           ;1582 73
    ld hl,(ul1)         ;1583 2a c4 02
    ld de,4a66h         ;1586 11 66 4a
    push hl             ;1589 e5
    ld hl,(bias)        ;158a 2a ae 02
    add hl,de           ;158d 19
    pop de              ;158e d1
    ld (hl),e           ;158f 73
    ld hl,(termtype)    ;1590 2a c6 02
    ld de,4a67h         ;1593 11 67 4a
    push hl             ;1596 e5
    ld hl,(bias)        ;1597 2a ae 02
    add hl,de           ;159a 19
    pop de              ;159b d1
    ld (hl),e           ;159c 73
    ld hl,(lptype)      ;159d 2a d4 02
    ld de,4a6dh         ;15a0 11 6d 4a
    push hl             ;15a3 e5
    ld hl,(bias)        ;15a4 2a ae 02
    add hl,de           ;15a7 19
    pop de              ;15a8 d1
    ld (hl),e           ;15a9 73
    ld hl,(dirsize)     ;15aa 2a b8 02
    ld de,38b2h         ;15ad 11 b2 38
    push hl             ;15b0 e5
    ld hl,(bias)        ;15b1 2a ae 02
    add hl,de           ;15b4 19
    pop de              ;15b5 d1
    ld (hl),e           ;15b6 73
    ld hl,0000h         ;15b7 21 00 00
    jp l15dch           ;15ba c3 dc 15
l15bdh:
    ld hl,(l02d0h)      ;15bd 2a d0 02
    add hl,hl           ;15c0 29
    ld de,autoload      ;15c1 11 3a 01
    add hl,de           ;15c4 19
    ld e,(hl)           ;15c5 5e
    inc hl              ;15c6 23
    ld d,(hl)           ;15c7 56
    ex de,hl            ;15c8 eb
    push hl             ;15c9 e5
    ld hl,(bias)        ;15ca 2a ae 02
    ex de,hl            ;15cd eb
    ld hl,(l02d0h)      ;15ce 2a d0 02
    add hl,de           ;15d1 19
    ld de,3407h         ;15d2 11 07 34
    add hl,de           ;15d5 19
    pop de              ;15d6 d1
    ld (hl),e           ;15d7 73
    ld hl,(l02d0h)      ;15d8 2a d0 02
    inc hl              ;15db 23
l15dch:
    ld (l02d0h),hl      ;15dc 22 d0 02
    ld hl,(l02d0h)      ;15df 2a d0 02
    ld de,0ffafh        ;15e2 11 af ff
    ld a,h              ;15e5 7c
    rla                 ;15e6 17
    jp c,l15ech         ;15e7 da ec 15
    add hl,de           ;15ea 19
    add hl,hl           ;15eb 29
l15ech:
    jp c,l15bdh         ;15ec da bd 15
    ld hl,(leadin)      ;15ef 2a c8 02
    ld de,4a68h         ;15f2 11 68 4a
    push hl             ;15f5 e5
    ld hl,(bias)        ;15f6 2a ae 02
    add hl,de           ;15f9 19
    pop de              ;15fa d1
    ld (hl),e           ;15fb 73
    ld hl,(order)       ;15fc 2a ca 02
    ld de,4a69h         ;15ff 11 69 4a
    push hl             ;1602 e5
    ld hl,(bias)        ;1603 2a ae 02
    add hl,de           ;1606 19
    pop de              ;1607 d1
    ld (hl),e           ;1608 73
    ld hl,(rowoff)      ;1609 2a cc 02
    ld de,4a6ah         ;160c 11 6a 4a
    push hl             ;160f e5
    ld hl,(bias)        ;1610 2a ae 02
    add hl,de           ;1613 19
    pop de              ;1614 d1
    ld (hl),e           ;1615 73
    ld hl,(coloff)      ;1616 2a ce 02
    ld de,4a6bh         ;1619 11 6b 4a
    push hl             ;161c e5
    ld hl,(bias)        ;161d 2a ae 02
    add hl,de           ;1620 19
    pop de              ;1621 d1
    ld (hl),e           ;1622 73
    ld hl,0000h         ;1623 21 00 00
    jp l1648h           ;1626 c3 48 16
l1629h:
    ld hl,(l02d0h)      ;1629 2a d0 02
    add hl,hl           ;162c 29
    ld de,scrtab        ;162d 11 2c 02
    add hl,de           ;1630 19
    ld e,(hl)           ;1631 5e
    inc hl              ;1632 23
    ld d,(hl)           ;1633 56
    ex de,hl            ;1634 eb
    push hl             ;1635 e5
    ld hl,(bias)        ;1636 2a ae 02
    ex de,hl            ;1639 eb
    ld hl,(l02d0h)      ;163a 2a d0 02
    add hl,de           ;163d 19
    ld de,4a80h         ;163e 11 80 4a
    add hl,de           ;1641 19
    pop de              ;1642 d1
    ld (hl),e           ;1643 73
    ld hl,(l02d0h)      ;1644 2a d0 02
    inc hl              ;1647 23
l1648h:
    ld (l02d0h),hl      ;1648 22 d0 02
    ld hl,(l02d0h)      ;164b 2a d0 02
    ld de,0ffc0h        ;164e 11 c0 ff
    ld a,h              ;1651 7c
    rla                 ;1652 17
    jp c,l1658h         ;1653 da 58 16
    add hl,de           ;1656 19
    add hl,hl           ;1657 29
l1658h:
    jp c,l1629h         ;1658 da 29 16

    ;CLOCK = PEEK (LOADER+3)
    ld hl,(clock)       ;165b 2a d2 02
    push hl             ;165e e5
    ld hl,(loader)      ;165f 2a b0 02
    inc hl              ;1662 23
    inc hl              ;1663 23
    inc hl              ;1664 23
    pop de              ;1665 d1
    ld (hl),e           ;1666 73

    ;RETURN
    ret

l1668h:
    ;PRINT "Save on which drive (A to P) ? "
    call pr0a
    ld hl,save_on_which
    call pv1d

    call readline       ;1671 cd ca 1b
    ld hl,(rr)          ;1674 2a b2 02
    ld de,0ffbfh        ;1677 11 bf ff
    ld a,h              ;167a 7c
    rla                 ;167b 17
    jp c,l1681h         ;167c da 81 16
    add hl,de           ;167f 19
    add hl,hl           ;1680 29
l1681h:
    sbc a,a             ;1681 9f
    ld h,a              ;1682 67
    ld l,a              ;1683 6f
    push hl             ;1684 e5
    ld hl,(rr)          ;1685 2a b2 02
    ld de,0ffafh        ;1688 11 af ff
    ld a,h              ;168b 7c
    rla                 ;168c 17
    jp c,l1692h         ;168d da 92 16
    add hl,de           ;1690 19
    add hl,hl           ;1691 29
l1692h:
    ccf                 ;1692 3f
    sbc a,a             ;1693 9f
    ld h,a              ;1694 67
    ld l,a              ;1695 6f
    pop de              ;1696 d1
    ld a,h              ;1697 7c
    or d                ;1698 b2
    ld h,a              ;1699 67
    ld a,l              ;169a 7d
    or e                ;169b b3
    ld l,a              ;169c 6f
    ld a,h              ;169d 7c
    or l                ;169e b5
    jp nz,l05b5h        ;169f c2 b5 05
    ld de,0ffbfh        ;16a2 11 bf ff
    ld hl,(rr)          ;16a5 2a b2 02
    add hl,de           ;16a8 19
    ld (dd),hl          ;16a9 22 dc 02
    ld hl,(dd)          ;16ac 2a dc 02
    ld (dt),hl          ;16af 22 b4 02
    ld hl,dt            ;16b2 21 b4 02
    call dtype          ;16b5 cd 90 29
    ld hl,(dt)          ;16b8 2a b4 02
    ld de,0ff80h        ;16bb 11 80 ff
    ld a,h              ;16be 7c
    rla                 ;16bf 17
    jp c,l16c5h         ;16c0 da c5 16
l16c3h:
    add hl,de           ;16c3 19
    add hl,hl           ;16c4 29
l16c5h:
    jp c,l16d4h         ;16c5 da d4 16

    ;PRINT "Drive not in system"
    call pr0a
    ld hl,no_drive
    call pv2d

    jp l1668h           ;16d1 c3 68 16
l16d4h:
    call sub_149ah      ;16d4 cd 9a 14
    ld hl,(dt)          ;16d7 2a b4 02
    ld de,0fffeh        ;16da 11 fe ff
    ld a,h              ;16dd 7c
    rla                 ;16de 17
    jp c,l16e4h         ;16df da e4 16
    add hl,de           ;16e2 19
    add hl,hl           ;16e3 29
l16e4h:
    ccf                 ;16e4 3f
    sbc a,a             ;16e5 9f
    ld h,a              ;16e6 67
    ld l,a              ;16e7 6f
    push hl             ;16e8 e5
    ld hl,(dt)          ;16e9 2a b4 02
    ld de,0fff6h        ;16ec 11 f6 ff
    ld a,h              ;16ef 7c
    rla                 ;16f0 17
    jp c,l16f6h         ;16f1 da f6 16
    add hl,de           ;16f4 19
    add hl,hl           ;16f5 29
l16f6h:
    sbc a,a             ;16f6 9f
    ld h,a              ;16f7 67
    ld l,a              ;16f8 6f
    pop de              ;16f9 d1
    ld a,h              ;16fa 7c
    and d               ;16fb a2
    ld h,a              ;16fc 67
    ld a,l              ;16fd 7d
    and e               ;16fe a3
    ld l,a              ;16ff 6f
    ld a,h              ;1700 7c
    or l                ;1701 b5
    jp z,l170eh         ;1702 ca 0e 17
    ld hl,dd            ;1705 21 dc 02
    call cwrite_        ;1708 cd 56 29
    jp l05b5h           ;170b c3 b5 05
l170eh:
    ld hl,dd            ;170e 21 dc 02
    call idisk          ;1711 cd 99 29
    ld hl,dd            ;1714 21 dc 02
    call savesy         ;1717 cd 02 2a
    ld hl,ee            ;171a 21 b6 02
    call dskerr         ;171d cd 9d 29
    ld hl,(ee)          ;1720 2a b6 02
    ld a,h              ;1723 7c
    or l                ;1724 b5
    jp z,l05b5h         ;1725 ca b5 05

    ;PRINT "Re-try (Y/N) ? ";
    call pr0a
    ld hl,retry_yn
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=&H59 THEN GOTO l170eh
    ld hl,(rr)
    ld de,0-'Y'
    add hl,de
    ld a,h
    or l
    jp z,l170eh

    ;GOTO l05b5h
    jp l05b5h

l1743h:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "      Pet terminal parameters"
    call pr0a
    ld hl,pet_params
    call pv2d

    ;PRINT "      --- -------- ----------"
    call pr0a
    ld hl,dashes
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "1.  Columns in DIR listing :   "
    call pr0a
    ld hl,cols_in_dir
    call pv1d

    ;IF DIRSIZE <> 0 THEN GOTO l177eh
    ld hl,(dirsize)
    ld a,h
    or l
    jp nz,l177eh

    ;PRINT "1"
    call pr0a
    ld hl,one
    call pv2d

    ;GOTO l179fh
    jp l179fh

l177eh:
    ld hl,(dirsize)     ;177e 2a b8 02
    ld de,0ffffh        ;1781 11 ff ff
    add hl,de           ;1784 19
    ld a,h              ;1785 7c
    or l                ;1786 b5
    jp nz,l1796h        ;1787 c2 96 17

    ;PRINT "2"
    call pr0a
    ld hl,two
    call pv2d

    jp l179fh           ;1793 c3 9f 17
l1796h:
    ;PRINT "4"
    call pr0a
    ld hl,four
    call pv2d

l179fh:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "2.  CRT in upper case mode :   ";
    call pr0a
    ld hl,crt_in_upper
    call pv1d

    ;IF (TERMTYPE AND &H80) = 0 THEN GOTO l17cdh
    ld hl,(termtype)
    ld a,l
    and 80h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp z,l17cdh

    ;PRINT "yes"
    call pr0a
    ld hl,yes
    call pv2d

    ;GOTO l17d6h
    jp l17d6h

l17cdh:
    ;PRINT "no"
    call pr0a
    ld hl,no
    call pv2d

l17d6h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3.  CRT terminal emulation :   ";
    call pr0a
    ld hl,crt_term_emu
    call pv1d

    ;IF (TERMTYPE AND &H7F) <> 0 THEN GOTO l1804h
    ld hl,(termtype)
    ld a,l
    and 7fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l1804h

    ;PRINT "ADM3A"
    call pr0a
    ld hl,adm3a
    call pv2d

    ;GOTO l1871h
    jp l1871h

l1804h:
    ;IF (TERMTYPE AND &H7F) <> 2 THEN GOTO l1824h
    ld hl,(termtype)
    ld a,l
    and 7fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-2
    add hl,de
    ld a,h
    or l
    jp nz,l1824h

    ;PRINT "TV912"
    call pr0a
    ld hl,tv912
    call pv2d

    ;GOTO l1871h
    jp l1871h

l1824h:
    ;IF (TERMTYPE AND &H7F) <> 1 THEN GOTO l1844h
    ld hl,(termtype)
    ld a,l
    and 7fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-1
    add hl,de
    ld a,h
    or l
    jp nz,l1844h

    ;PRINT "HZ1500"
    call pr0a
    ld hl,hz1500
    call pv2d

    ;GOTO l1871h
    jp l1847h

l1844h:
    ;GOTO l1871h
    jp l1871h

l1847h:
    ;IF LEADIN <> &H1B THEN GOTO l185ch
    ld hl,(leadin)
    ld de,0-1bh
    add hl,de
    ld a,h
    or l
    jp nz,l185ch

    ;PRINT "                   (Lead-in = ESCAPE)"
    call pr0a
    ld hl,leadin_esc
    call pv2d

l185ch:
    ;IF LEADIN <> &H7E THEN GOTO l1871h
    ld hl,(leadin)
    ld de,0-'~'
    add hl,de
    ld a,h
    or l
    jp nz,l1871h

    ;PRINT "<tab><tab>     (Lead-in = TILDE)"
    call pr0a
    ld hl,leadin_tilde
    call pv2d

l1871h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "4.  Clock frequency (Hz) :     "; CLOCK
    call pr0a
    ld hl,clock_freq
    call pv1d
    ld hl,(clock)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which (1-4) ? ";
    call pr0a
    ld hl,alter_which_1_4
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R = 0 THEN GOTO l05b5h
    ld hl,(rr)
    ld a,h
    or l
    jp z,l05b5h

    ;IF R = &H31 THEN GOTO l18eah
    ld hl,(rr)
    ld de,0-'1'
    add hl,de
    ld a,h
    or l
    jp z,l18eah

    ;IF R <> &H32 THEN GOTO l18cfh
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp nz,l18cfh

    ld hl,(termtype)    ;18be 2a c6 02
    ld a,l              ;18c1 7d
    xor 80h             ;18c2 ee 80
    ld l,a              ;18c4 6f
    ld a,h              ;18c5 7c
    xor 00h             ;18c6 ee 00
    ld h,a              ;18c8 67
    ld (termtype),hl    ;18c9 22 c6 02
    jp l1743h           ;18cc c3 43 17

l18cfh:
    ;IF R = &H33 THEN GOTO l192fh
    ld hl,(rr)
    ld de,0-'3'
    add hl,de
    ld a,h
    or l
    jp z,l194ch

    ;IF R = &H34 THEN GOTO l192fh
    ld hl,(rr)
    ld de,0-'4'
    add hl,de
    ld a,h
    or l
    jp z,l192fh

    ;GOTO l1743h
    jp l1743h

l18eah:
    ;PRINT "Number of columns (1, 2 or 4) ? ";
    call pr0a
    ld hl,num_of_cols
    call pv1d

    call readline       ;18f3 cd ca 1b
    ld hl,(rr)          ;18f6 2a b2 02
    ld de,0ffcfh        ;18f9 11 cf ff
    add hl,de           ;18fc 19
    ld a,h              ;18fd 7c
    or l                ;18fe b5
    jp nz,l1908h        ;18ff c2 08 19
    ld hl,0000h         ;1902 21 00 00
    ld (dirsize),hl     ;1905 22 b8 02
l1908h:
    ld hl,(rr)          ;1908 2a b2 02
    ld de,0ffceh        ;190b 11 ce ff
    add hl,de           ;190e 19
    ld a,h              ;190f 7c
    or l                ;1910 b5
    jp nz,l191ah        ;1911 c2 1a 19
    ld hl,0001h         ;1914 21 01 00
    ld (dirsize),hl     ;1917 22 b8 02
l191ah:
    ld hl,(rr)          ;191a 2a b2 02
    ld de,0ffcch        ;191d 11 cc ff
    add hl,de           ;1920 19
    ld a,h              ;1921 7c
    or l                ;1922 b5
    jp nz,l192ch        ;1923 c2 2c 19
    ld hl,0003h         ;1926 21 03 00
    ld (dirsize),hl     ;1929 22 b8 02
l192ch:
    jp l1743h           ;192c c3 43 17
l192fh:
    ;PRINT "New clock frequency ? "
    call pr0a
    ld hl,new_clock
    call pv1d

    call readline       ;1938 cd ca 1b
    ld hl,(rr)          ;193b 2a b2 02
    ld a,h              ;193e 7c
    or l                ;193f b5
    jp z,l1949h         ;1940 ca 49 19
    ld hl,(nn)          ;1943 2a d8 02
    ld (clock),hl       ;1946 22 d2 02
l1949h:
    jp l1743h           ;1949 c3 43 17
l194ch:
    ;PRINT "Screen type (ADM3A, HZ1500, TV912) ? ";
    call pr0a
    ld hl,screen_type
    call pv1d

    call readline       ;1955 cd ca 1b
    ld hl,(rr)          ;1958 2a b2 02
    ld de,0ffbfh        ;195b 11 bf ff
    add hl,de           ;195e 19
    ld a,h              ;195f 7c
    or l                ;1960 b5
    jp nz,l1975h        ;1961 c2 75 19
    ld hl,(termtype)    ;1964 2a c6 02
    ld a,l              ;1967 7d
    and 80h             ;1968 e6 80
    ld l,a              ;196a 6f
    ld a,h              ;196b 7c
    and 00h             ;196c e6 00
    ld h,a              ;196e 67
    ld (termtype),hl    ;196f 22 c6 02
    jp l1aa6h           ;1972 c3 a6 1a
l1975h:
    ld hl,(rr)          ;1975 2a b2 02
    ld de,0ffach        ;1978 11 ac ff
    add hl,de           ;197b 19
    ld a,h              ;197c 7c
    or l                ;197d b5
    jp nz,l199ah        ;197e c2 9a 19
    ld hl,(termtype)    ;1981 2a c6 02
    ld a,l              ;1984 7d
    and 80h             ;1985 e6 80
    ld l,a              ;1987 6f
    ld a,h              ;1988 7c
    and 00h             ;1989 e6 00
    ld h,a              ;198b 67
    ld a,l              ;198c 7d
    or 02h              ;198d f6 02
    ld l,a              ;198f 6f
    ld a,h              ;1990 7c
    or 00h              ;1991 f6 00
    ld h,a              ;1993 67
    ld (termtype),hl    ;1994 22 c6 02
    jp l1aa6h           ;1997 c3 a6 1a
l199ah:
    ld hl,(rr)          ;199a 2a b2 02
    ld de,0ffb8h        ;199d 11 b8 ff
    add hl,de           ;19a0 19
    ld a,h              ;19a1 7c
    or l                ;19a2 b5
    jp nz,l1743h        ;19a3 c2 43 17

    ;PRINT "Lead-in code E(scape) or T(ilde) ? ";
    call pr0a
    ld hl,esc_or_tilde
    call pv1d

    call readline       ;19af cd ca 1b
    ld hl,(rr)          ;19b2 2a b2 02
    ld de,0ffbbh        ;19b5 11 bb ff
    add hl,de           ;19b8 19
    ld a,h              ;19b9 7c
    or l                ;19ba b5
    jp nz,l19c7h        ;19bb c2 c7 19
    ld hl,001bh         ;19be 21 1b 00
    ld (leadin),hl      ;19c1 22 c8 02
    jp l19dfh           ;19c4 c3 df 19
l19c7h:
    ld hl,(rr)          ;19c7 2a b2 02
    ld de,0ffach        ;19ca 11 ac ff
    add hl,de           ;19cd 19
    ld a,h              ;19ce 7c
    or l                ;19cf b5
    jp nz,l19dch        ;19d0 c2 dc 19
    ld hl,007eh         ;19d3 21 7e 00
    ld (leadin),hl      ;19d6 22 c8 02
    jp l19dfh           ;19d9 c3 df 19
l19dch:
    jp l1743h           ;19dc c3 43 17

l19dfh:
    ;TERMTYPE = (TERMTYPE AND &H80) OR 1
    ld hl,(termtype)
    ld a,l
    and 80h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 01h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (termtype),hl

    ;ROWOFF = 0 : COLOFF = 0
    ld hl,0000h
    ld (rowoff),hl
    ld (coloff),hl

    ;ORDER = 1
    ld hl,0001h
    ld (order),hl

    ;SCRTAB(0) = &H8B
    ld hl,008bh
    ld (scrtab+0),hl

    ;SCRTAB(1) = &H0B
    ld hl,000bh
    ld (scrtab+2),hl

    ;SCRTAB(2) = &H8C
    ld hl,008ch
    ld (scrtab+4),hl

    ;SCRTAB(3) = &H0C
    ld hl,000ch
    ld (scrtab+6),hl

    ;SCRTAB(4) = &H8F
    ld hl,008fh
    ld (scrtab+8),hl

    ;SCRTAB(5) = &H13
    ld hl,0013h
    ld (scrtab+10),hl

    ;SCRTAB(6) = &H91
    ld hl,0091h
    ld (scrtab+12),hl

    ;SCRTAB(7) = &H1B
    ld hl,001bh
    ld (scrtab+14),hl

    ;SCRTAB(8) = &H92
    ld hl,0092h
    ld (scrtab+16),hl

    ;SCRTAB(9) = &H1E
    ld hl,001eh
    ld (scrtab+18),hl

    ;SCRTAB(10) = &H93
    ld hl,0093h
    ld (scrtab+20),hl

    ;SCRTAB(11) = &H12
    ld hl,0012h
    ld (scrtab+22),hl

    ;SCRTAB(12) = &H97
    ld hl,0097h
    ld (scrtab+24),hl

    ;SCRTAB(13) = &H14
    ld hl,0014h
    ld (scrtab+26),hl

    ;SCRTAB(14) = &H98
    ld hl,0098h
    ld (scrtab+28),hl

    ;SCRTAB(15) = &H14
    ld hl,0014h
    ld (scrtab+30),hl

    ;SCRTAB(16) = &H9A
    ld hl,009ah
    ld (scrtab+32),hl

    ;SCRTAB(17) = &H11
    ld hl,0011h
    ld (scrtab+34),hl

    ;SCRTAB(18) = &H9C
    ld hl,009ch
    ld (scrtab+36),hl

    ;SCRTAB(19) = &H1A
    ld hl,001ah
    ld (scrtab+38),hl

    ;SCRTAB(20) = &H9D
    ld hl,009dh
    ld (scrtab+40),hl

    ;SCRTAB(21) = &H1A
    ld hl,001ah
    ld (scrtab+42),hl

    ;SCRTAB(22) = &H99
    ld hl,0099h
    ld (scrtab+44),hl

    ;SCRTAB(23) = &H00
    ld hl,0000h
    ld (scrtab+46),hl

    ;SCRTAB(24) = &H9F
    ld hl,009fh
    ld (scrtab+48),hl

    ;SCRTAB(25) = &H00 : SCRTAB(26) = &H00
    ld hl,0000h
    ld (scrtab+50),hl
    ld (scrtab+52),hl

    ;GOTO l1743h
    jp l1743h

l1aa6h:
    ;LEADIN = &H1B
    ld hl,001bh
    ld (leadin),hl

    ;ROWOFF = &H20 : COLOFF = &H20
    ld hl,0020h
    ld (rowoff),hl
    ld (coloff),hl

    ;ORDER = 0
    ld hl,0000h
    ld (order),hl

    ;SCRTAB(0) = &HB1
    ld hl,00b1h
    ld (scrtab+0),hl

    ;SCRTAB(1) = &H04
    ld hl,0004h
    ld (scrtab+2),hl

    ;SCRTAB(2) = &HB2
    ld hl,00b2h
    ld (scrtab+4),hl

    ;SCRTAB(3) = &H05
    ld hl,0005h
    ld (scrtab+6),hl

    ;SCRTAB(4) = &HB3
    ld hl,00b3h
    ld (scrtab+8),hl

    ;SCRTAB(5) = &H06
    ld hl,0006h
    ld (scrtab+10),hl

    ;SCRTAB(6) = &HEA
    ld hl,00eah
    ld (scrtab+12),hl

    ;SCRTAB(7) = &H0E
    ld hl,000eh
    ld (scrtab+14),hl

    ;SCRTAB(8) = &HEB
    ld hl,00ebh
    ld (scrtab+16),hl

    ;SCRTAB(9) = &H0F
    ld hl,000fh
    ld (scrtab+18),hl

    ;SCRTAB(10) = &HD1
    ld hl,00d1h
    ld (scrtab+20),hl

    ;SCRTAB(11) = &H1C
    ld hl,001ch
    ld (scrtab+22),hl

    ;SCRTAB(12) = &HD7
    ld hl,00d7h
    ld (scrtab+24),hl

    ;SCRTAB(13) = &H1D
    ld hl,001dh
    ld (scrtab+26),hl

    ;SCRTAB(14) = &HC5
    ld hl,00c5h
    ld (scrtab+28),hl

    ;SCRTAB(15) = &H11
    ld hl,0011h
    ld (scrtab+30),hl

    ;SCRTAB(16) = &HD2
    ld hl,00d2h
    ld (scrtab+32),hl

    ;SCRTAB(17) = &H12
    ld hl,0012h
    ld (scrtab+34),hl

    ;SCRTAB(18) = &HD4
    ld hl,00d4h
    ld (scrtab+36),hl

    ;SCRTAB(19) = &H13
    ld hl,0013h
    ld (scrtab+38),hl

    ;SCRTAB(20) = &HF4
    ld hl,00f4h
    ld (scrtab+40),hl

    ;SCRTAB(21) = &H13
    ld hl,0013h
    ld (scrtab+42),hl

    ;SCRTAB(22) = &HD9
    ld hl,00d9h
    ld (scrtab+44),hl

    ;SCRTAB(23) = &H14
    ld hl,0014h
    ld (scrtab+46),hl

    ;SCRTAB(24) = &HF9
    ld hl,00f9h
    ld (scrtab+48),hl

    ;SCRTAB(25) = &H14
    ld hl,0014h
    ld (scrtab+50),hl

    ;SCRTAB(26) = &HAB
    ld hl,00abh
    ld (scrtab+52),hl

    ;SCRTAB(27) = &H1A
    ld hl,001ah
    ld (scrtab+54),hl

    ;SCRTAB(28) = &HAA
    ld hl,00aah
    ld (scrtab+56),hl

    ;SCRTAB(29) = &H1A
    ld hl,001ah
    ld (scrtab+58),hl

    ;SCRTAB(30) = &HBA
    ld hl,00bah
    ld (scrtab+60),hl

    ;SCRTAB(31) = &H1A
    ld hl,001ah
    ld (scrtab+62),hl

    ;SCRTAB(32) = &HBB
    ld hl,00bbh
    ld (scrtab+64),hl

    ;SCRTAB(33) = &H1A
    ld hl,001ah
    ld (scrtab+66),hl

    ;SCRTAB(34) = &HDA
    ld hl,00dah
    ld (scrtab+68),hl

    ;SCRTAB(35) = &H1A
    ld hl,001ah
    ld (scrtab+70),hl

    ;SCRTAB(36) = &HBD
    ld hl,00bdh
    ld (scrtab+72),hl

    ;SCRTAB(37) = &H1B
    ld hl,001bh
    ld (scrtab+74),hl

    ;SCRTAB(38) = &HA8
    ld hl,00a8h
    ld (scrtab+76),hl

    ;SCRTAB(39) = &H00
    ld hl,0000h
    ld (scrtab+78),hl

    ;SCRTAB(40) = &HA9
    ld hl,00a9h
    ld (scrtab+80),hl

    ;SCRTAB(41) = &H00 : SCRTAB(42) = &H00
    ld hl,0000h
    ld (scrtab+82),hl
    ld (scrtab+84),hl

    ;GOTO l1743h
    jp l1743h

clear_screen:
    ;PRINT CHR$(26)
    call pr0a
    ld hl,001ah
    call chr
    call pv2d

    ;RETURN
    ret

readline:
    ;BUF = &H80
    ld hl,0080h
    ld (buf),hl

    ;POKE BUF, 80
    ld hl,(buf)
    ld (hl),50h

    ;CALL BUFFIN
    call buffin

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;IF PEEK (BUF+1) = 0 THEN R = 0 : RETURN
    ld hl,(buf)
    inc hl
    ld l,(hl)
    ld h,00h
    ld a,h
    or l
    jp nz,l1bf4h
    ld hl,0000h
    ld (rr),hl
    ret

l1bf4h:
    ld hl,(buf)         ;1bf4 2a e0 02
    inc hl              ;1bf7 23
    inc hl              ;1bf8 23
    ld l,(hl)           ;1bf9 6e
    ld h,00h            ;1bfa 26 00
    ld (rr),hl          ;1bfc 22 b2 02
    ld hl,(rr)          ;1bff 2a b2 02
    ld de,0ff9fh        ;1c02 11 9f ff
    ld a,h              ;1c05 7c
    rla                 ;1c06 17
    jp c,l1c0ch         ;1c07 da 0c 1c
    add hl,de           ;1c0a 19
    add hl,hl           ;1c0b 29
l1c0ch:
    ccf                 ;1c0c 3f
    sbc a,a             ;1c0d 9f
    ld h,a              ;1c0e 67
    ld l,a              ;1c0f 6f
    push hl             ;1c10 e5
    ld hl,(rr)          ;1c11 2a b2 02
    ld de,0ff85h        ;1c14 11 85 ff
    ld a,h              ;1c17 7c
    rla                 ;1c18 17
    jp c,l1c1eh         ;1c19 da 1e 1c
    add hl,de           ;1c1c 19
    add hl,hl           ;1c1d 29
l1c1eh:
    sbc a,a             ;1c1e 9f
    ld h,a              ;1c1f 67
    ld l,a              ;1c20 6f
    pop de              ;1c21 d1
    ld a,h              ;1c22 7c
    and d               ;1c23 a2
    ld h,a              ;1c24 67
    ld a,l              ;1c25 7d
    and e               ;1c26 a3
    ld l,a              ;1c27 6f
    ld a,h              ;1c28 7c
    or l                ;1c29 b5
    jp z,l1c37h         ;1c2a ca 37 1c
    ld de,0ffe0h        ;1c2d 11 e0 ff
    ld hl,(rr)          ;1c30 2a b2 02
    add hl,de           ;1c33 19
    ld (rr),hl          ;1c34 22 b2 02
l1c37h:
    ld hl,0000h         ;1c37 21 00 00
    ld (nn),hl          ;1c3a 22 d8 02
    ld hl,0002h         ;1c3d 21 02 00
    ld (l02d0h),hl      ;1c40 22 d0 02
l1c43h:
    ld hl,(buf)         ;1c43 2a e0 02
    ex de,hl            ;1c46 eb
    ld hl,(l02d0h)      ;1c47 2a d0 02
    add hl,de           ;1c4a 19
    ld l,(hl)           ;1c4b 6e
    ld h,00h            ;1c4c 26 00
    push hl             ;1c4e e5
    ld de,0ffd0h        ;1c4f 11 d0 ff
    ld a,h              ;1c52 7c
    rla                 ;1c53 17
    jp c,l1c59h         ;1c54 da 59 1c
    add hl,de           ;1c57 19
    add hl,hl           ;1c58 29
l1c59h:
    ccf                 ;1c59 3f
    sbc a,a             ;1c5a 9f
    ld h,a              ;1c5b 67
    ld l,a              ;1c5c 6f
    ld (02eah),hl       ;1c5d 22 ea 02
    pop hl              ;1c60 e1
    ld de,0ffc6h        ;1c61 11 c6 ff
    ld a,h              ;1c64 7c
    rla                 ;1c65 17
    jp c,l1c6bh         ;1c66 da 6b 1c
    add hl,de           ;1c69 19
    add hl,hl           ;1c6a 29
l1c6bh:
    sbc a,a             ;1c6b 9f
    ld h,a              ;1c6c 67
    ld l,a              ;1c6d 6f
    push hl             ;1c6e e5
    ld hl,(02eah)       ;1c6f 2a ea 02
    ex de,hl            ;1c72 eb
    pop hl              ;1c73 e1
    ld a,h              ;1c74 7c
    and d               ;1c75 a2
    ld h,a              ;1c76 67
    ld a,l              ;1c77 7d
    and e               ;1c78 a3
    ld l,a              ;1c79 6f
    push hl             ;1c7a e5
    ld hl,(buf)         ;1c7b 2a e0 02
    inc hl              ;1c7e 23
    ld l,(hl)           ;1c7f 6e
    ld h,00h            ;1c80 26 00
    push hl             ;1c82 e5
    ld hl,(l02d0h)      ;1c83 2a d0 02
    dec hl              ;1c86 2b
    dec hl              ;1c87 2b
    pop de              ;1c88 d1
    ld a,d              ;1c89 7a
    xor h               ;1c8a ac
    ld a,h              ;1c8b 7c
    jp m,l1c93h         ;1c8c fa 93 1c
    ld a,l              ;1c8f 7d
    sub e               ;1c90 93
    ld a,h              ;1c91 7c
    sbc a,d             ;1c92 9a
l1c93h:
    rla                 ;1c93 17
    sbc a,a             ;1c94 9f
    ld h,a              ;1c95 67
    ld l,a              ;1c96 6f
    pop de              ;1c97 d1
    ld a,h              ;1c98 7c
    and d               ;1c99 a2
    ld h,a              ;1c9a 67
    ld a,l              ;1c9b 7d
    and e               ;1c9c a3
    ld l,a              ;1c9d 6f
    ld a,h              ;1c9e 7c
    or l                ;1c9f b5
    jp z,l1ccah         ;1ca0 ca ca 1c
    ld hl,(nn)          ;1ca3 2a d8 02
    call imug           ;1ca6 cd 9a 2c
    ld a,(bc)           ;1ca9 0a
    nop                 ;1caa 00
    push hl             ;1cab e5
    ld hl,(buf)         ;1cac 2a e0 02
    ex de,hl            ;1caf eb
    ld hl,(l02d0h)      ;1cb0 2a d0 02
    add hl,de           ;1cb3 19
    ld l,(hl)           ;1cb4 6e
    ld h,00h            ;1cb5 26 00
    pop de              ;1cb7 d1
    add hl,de           ;1cb8 19
    ld de,0ffd0h        ;1cb9 11 d0 ff
    add hl,de           ;1cbc 19
    ld (nn),hl          ;1cbd 22 d8 02
    ld hl,(l02d0h)      ;1cc0 2a d0 02
    inc hl              ;1cc3 23
    ld (l02d0h),hl      ;1cc4 22 d0 02
    jp l1c43h           ;1cc7 c3 43 1c
l1ccah:
    ret                 ;1cca c9
    call end            ;1ccb cd 24 2d

esc_or_tilde:
    db 23h
    dw esc_or_tilde+3
    db "Lead-in code E(scape) or T(ilde) ? "

screen_type:
    db 25h
    dw screen_type+3
    db "Screen type (ADM3A, HZ1500, TV912) ? "

new_clock:
    db 16h
    dw new_clock+3
    db "New clock frequency ? "

num_of_cols:
    db 20h
    dw num_of_cols+3
    db "Number of columns (1, 2 or 4) ? "

alter_which_1_4:
    db 14h
    dw alter_which_1_4+3
    db "Alter which (1-4) ? "

clock_freq:
    db 1fh
    dw clock_freq+3
    db "4.  Clock frequency (Hz) :     "

leadin_tilde:
    db 18h
    dw leadin_tilde+3
    db 09h,09h,"     (Lead-in = TILDE)"

leadin_esc:
    db 25h
    dw leadin_esc+3
    db "                   (Lead-in = ESCAPE)"

hz1500:
    db 06h
    dw hz1500+3
    db "HZ1500"

tv912:
    db 05h
    dw tv912+3
    db "TV912"

adm3a:
    db 05h
    dw adm3a+3
    db "ADM3A"

crt_term_emu:
    db 1fh
    dw crt_term_emu+3
    db "3.  CRT terminal emulation :   "

no:
    db 02h
    dw no+3
    db "no"

yes:
    db 03h
    dw yes+3
    db "yes"

crt_in_upper:
    db 1fh
    dw crt_in_upper+3
    db "2.  CRT in upper case mode :   "

four:
    db 01h
    dw four+3
    db "4"

cols_in_dir:
    db 1fh
    dw cols_in_dir+3
    db "1.  Columns in DIR listing :   "

dashes:
    db 1dh
    dw dashes+3
    db "      --- -------- ----------"

pet_params:
    db 1dh
    dw pet_params+3
    db "      Pet terminal parameters"

retry_yn:
    db 0fh
    dw retry_yn+3
    db "Re-try (Y/N) ? "

no_drive:
    db 13h
    dw no_drive+3
    db "Drive not in system"

save_on_which:
    db 1fh
    dw save_on_which+3
    db "Save on which drive (A to P) ? "

new_command:
    db 1fh
    dw new_command+3
    db "Please enter the new command : "

new_aload_yn:
    db 1dh
    dw new_aload_yn+3
    db "New autoload command (Y/N) ? "

cur_aload_is:
    db 1dh
    dw cur_aload_is+3
    db "Current autoload command is :"

no_aload_cmd:
    db 1bh
    dw no_aload_cmd+3
    db "No current autoload command"

mw_12mb_half:
    db 0eh
    dw mw_12mb_half+3
    db "12Mbyte (half)"

mw_6mb_half:
    db 0eh
    dw mw_6mb_half+3
    db "6 Mbyte (half)"

mw_3mb_half:
    db 0eh
    dw mw_3mb_half+3
    db "3 Mbyte (half)"

mw_12mb:
    db 0dh
    dw mw_12mb+3
    db "12 Mbyte     "

mw_6mb:
    db 07h
    dw mw_6mb+3
    db "6 Mbyte"

mw_3mb:
    db 0ch
    dw mw_3mb+3
    db "3 Mbyte     "

winchester:
    db 0eh
    dw winchester+3
    db "Winchester    "

device_num:
    db 0bh
    dw device_num+3
    db "   Device #"

cor_5mb_star:
    db 0bh
    dw cor_5mb_star+3
    db "Corvus 5Mb*"

cor_5mb:
    db 0bh
    dw cor_5mb+3
    db "Corvus 5Mb "

cor_20mb:
    db 0bh
    dw cor_20mb+3
    db "Corvus 20Mb"

cor_10mb:
    db 0bh
    dw cor_10mb+3
    db "Corvus 10Mb"

not_used:
    db 08h
    dw not_used+3
    db "not used"

cbm_8050:
    db 0bh
    dw cbm_8050+3
    db "8050       "

cbm_3040:
    db 0bh
    dw cbm_3040+3
    db "3040/4040  "

use_first_half:
    db 1ch
    dw use_first_half+3
    db "use the FIRST HALF (E/H)  ? "

use_entire_drv:
    db 27h
    dw use_entire_drv+3
    db "Use the ENTIRE drive for CP/M,  or just"

drv_3_6_12:
    db 19h
    dw drv_3_6_12+3
    db "3, 6 or 12 Mbyte drive ? "

config_as_1_or_2:
    db 22h
    dw config_as_1_or_2+3
    db "Configure as 1 or 2 CP/M drives ? "

dev_num_for_drv:
    db 1ah
    dw dev_num_for_drv+3
    db "Device number for drive ? "

drv_5_10_20:
    db 1ah
    dw drv_5_10_20+3
    db "5, 10 or 20 Mbyte drive ? "

cbm_hard_unused:
    db 25h
    dw cbm_hard_unused+3
    db "3(040), 8(050), h(ard) or u(nused) ? "

alter_which_pair:
    db 22h
    dw alter_which_pair+3
    db "Alter which drive pair (A to O) ? "

drives_o_p:
    db 0bh
    dw drives_o_p+3
    db "O, P :     "

drives_m_n:
    db 0bh
    dw drives_m_n+3
    db "M, N :     "

drives_k_l:
    db 0bh
    dw drives_k_l+3
    db "K, L :     "

drives_i_j:
    db 0bh
    dw drives_i_j+3
    db "I, J :     "

drives_g_h:
    db 0bh
    dw drives_g_h+3
    db "G, H :     "

drives_e_f:
    db 0bh
    dw drives_e_f+3
    db "E, F :     "

drives_c_d:
    db 0bh
    dw drives_c_d+3
    db "C, D :     "

drives_a_b:
    db 0bh
    dw drives_a_b+3
    db "A, B :     "

dashes_2:
    db 21h
    dw dashes_2+3
    db "            ---- ----- ----------"

drv_assgnmt:
    db 21h
    dw drv_assgnmt+3
    db "            Disk drive assignment"

which_printer:
    db 24h
    dw which_printer+3
    db "Which type of printer (3, 8 or D) ? "

daisywheel:
    db 1dh
    dw daisywheel+3
    db "D = 8026 or 8027 (daisywheel)"

cbm8024:
    db 08h
    dw cbm8024+3
    db "8 = 8024"

cbm3022:
    db 1ch
    dw cbm3022+3
    db "3 = 3022, 3023, 4022 or 4023"

tty_or_ptp:
    db 13h
    dw tty_or_ptp+3
    db "T(TY:) or P(TP:) ? "

tty_or_ptr:
    db 13h
    dw tty_or_ptr+3
    db "T(TY:) or P(TR:) ? "

which_list_dev:
    db 23h
    dw which_list_dev+3
    db "Which list device (T, C, L or U) ? "

ul1_ascii:
    db 1dh
    dw ul1_ascii+3
    db "U(L1:) --  ASCII IEEE printer"

lpt_pet:
    db 1bh
    dw lpt_pet+3
    db "L(PT:) --  PET IEEE printer"

crt_pet_scrn:
    db 15h
    dw crt_pet_scrn+3
    db "C(RT:) --  PET screen"

tty_rs232:
    db 18h
    dw tty_rs232+3
    db "T(TY:) --  RS232 printer"

new_dev_num:
    db 0fh
    dw new_dev_num+3
    db "New device # ? "

alter_which_1_8:
    db 14h
    dw alter_which_1_8+3
    db "Alter which (1-8) ? "

cbm8024_2:
    db 04h
    dw cbm8024_2+3
    db "8024"

daisywheel_2:
    db 09h
    dw daisywheel_2+3
    db "8026/8027"

cbm_3022_2:
    db 09h
    dw cbm_3022_2+3
    db "3022/4022"

pet_prtr_type:
    db 1eh
    dw pet_prtr_type+3
    db "8.  PET printer type :        "

ptp:
    db 04h
    dw ptp+3
    db "PTP:"

default_pun:
    db 1eh
    dw default_pun+3
    db "7.  Default PUN: device :     "

ptr:
    db 04h
    dw ptr+3
    db "PTR:"

default_rdr:
    db 1eh
    dw default_rdr+3
    db "6.  Default RDR: device :     "

ul1_colon:
    db 04h
    dw ul1_colon+3
    db "UL1:"

lpt_colon:
    db 04h
    dw lpt_colon+3
    db "LPT:"

crt:
    db 04h
    dw crt+3
    db "CRT:"

tty:
    db 04h
    dw tty+3
    db "TTY:"

io_lst_device:
    db 1eh
    dw io_lst_device+3
    db "5.  Default LST: device :     "

io_pun_device:
    db 1eh
    dw io_pun_device+3
    db "4.  Punch device # :          "

io_rdr_device:
    db 1eh
    dw io_rdr_device+3
    db "3.  Reader device # :         "

io_ul1_device:
    db 1eh
    dw io_ul1_device+3
    db "2.  ASCII printer device # :  "

io_lpt_device:
    db 1eh
    dw io_lpt_device+3
    db "1.  Pet printer device # :    "

dashes_6:
    db 22h
    dw dashes_6+3
    db "             --- ------ ----------"

io_dev_asgn:
    db 22h
    dw io_dev_asgn+3
    db "             I/O device assignment"

ask_19200:
    db 0dh
    dw ask_19200+3
    db "19200 baud ? "

ask_bauds:
    db 1dh
    dw ask_bauds+3
    db "110, 300, 1200, 4800, 9600 or"

odd_even_none:
    db 1fh
    dw odd_even_none+3
    db "O(dd), E(ven) or N(o parity) ? "

num_stop_bits:
    db 20h
    dw num_stop_bits+3
    db "Number of stop bits (1 or 2)  ? "

new_char_len:
    db 20h
    dw new_char_len+3
    db "New character length (5 to 8) ? "

alter_chr_1_4:
    db 23h
    dw alter_chr_1_4  +3
    db "Alter which characteristic (1-4) ? "

baud_4800:
    db 04h
    dw baud_4800+3
    db "4800"

baud_19200:
    db 05h
    dw baud_19200+3
    db "19200"

baud_9600:
    db 04h
    dw baud_9600+3
    db "9600"

baud_1200:
    db 04h
    dw baud_1200+3
    db "1200"

baud_300:
    db 03h
    dw baud_300+3
    db "300"

baud_110:
    db 03h
    dw baud_110+3
    db "110"

rs232_4_baud:
    db 1fh
    dw rs232_4_baud+3
    db " 4.  Baud rate :               "

odd:
    db 03h
    dw odd+3
    db "odd"

even:
    db 04h
    dw even+3
    db "even"

none:
    db 04h
    dw none+3
    db "none"

rs232_3_par:
    db 1fh
    dw rs232_3_par+3
    db " 3.  Parity :                  "

two:
    db 01h
    dw two+3
    db "2"

one_dot_five:
    db 03h
    dw one_dot_five+3
    db "1.5"

one:
    db 01h
    dw one+3
    db "1"

undefined:
    db 09h
    dw undefined+3
    db "undefined"

rs232_2_stop:
    db 1fh
    dw rs232_2_stop+3
    db " 2.  Number of stop bits :     "

rs232_1_chr:
    db 1fh
    dw rs232_1_chr+3
    db " 1.  Character size :          "

dashes_5:
    db 20h
    dw dashes_5+3
    db "           ----- ---------------"

rs232_chrs:
    db 20h
    dw rs232_chrs+3
    db "           RS232 Characteristics"

pls_letter:
    db 26h
    dw pls_letter+3
    db "Please enter the appropriate letter : "

q_quit:
    db 15h
    dw q_quit+3
    db "Q - Quit this program"

e_execute:
    db 16h
    dw e_execute+3
    db "E - Execute new system"

s_save:
    db 13h
    dw s_save+3
    db "S - Save new system"

r_rs232:
    db 19h
    dw r_rs232+3
    db "R - RS232 characteristics"

p_pet_term:
    db 1bh
    dw p_pet_term+3
    db "P - PET terminal parameters"

i_io_asgn:
    db 12h
    dw i_io_asgn+3
    db "I - I/O assignment"

d_drv_asgn:
    db 19h
    dw d_drv_asgn+3
    db "D - Disk drive assignment"

a_autoload:
    db 14h
    dw a_autoload+3
    db "A - Autoload command"

dashes_4:
    db 16h
    dw dashes_4+3
    db "----  ----------------"

cpm_reconfig_2:
    db 16h
    dw cpm_reconfig_2+3
    db "CP/M  Re-configuration"

source_drv_a_p:
    db 18h
    dw source_drv_a_p+3
    db "Source drive (A to P) ? "

rev_3_feb_1982:
    db 22h
    dw rev_3_feb_1982+3
    db "Revision 3   --   19 February 1982"

mw_version:
    db 17h
    dw mw_version+3
    db "Mini-winchester version"

dashes_3:
    db 15h
    dw dashes_3+3
    db "----  ---------------"

cpm_reconfig:
    db 15h
    dw cpm_reconfig+3
    db "CP/M  Reconfiguration"

empty_string:
    db 00h
    dw empty_string+3
    db 0cdh,"$-",01h,00h,00h

; Start of LOADSAVE.REL =====================================================

buffin:
;Buffered Console Input.  Caller must store buffer size at 80h.  On
;return, 81h will contain the number of data bytes and the data
;will start at 82h.
    ld c,0ah
    ld de,0080h
    jp 0005h

exsys:
;Execute a new CP/M system.  The buffer at 4000h contains a new
;CP/M system image (7168 bytes = CCP + BDOS + BIOS config + BIOS storage).
;Copy the new system into place and then jump to the BIOS to start it.
    ld bc,1c00h
    ld hl,4000h
    ld de,0d400h
    ldir
    jp 0f075h

rdsys:
;Read the "CP/M" and "K" files from an IEEE-488 drive into memory.
    ld a,(hl)
    ld (l2be5h),a
    call 0f054h
    ld e,00h
    push de
    call sub_29deh
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    ld hl,4000h
    ld bc,1c00h
    pop de
    or a
    ret nz
    push de
    call 0f039h
l28dah:
    call 0f03fh
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l28dah
    call 0f03ch
    pop de
    push de
    call 0f060h
    pop de
    push de
    call sub_29f0h
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    ld hl,6000h
    ld bc,l0800h
    pop de
    or a
    ret nz
    push de
    call 0f039h
l2907h:
    call 0f03fh
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2907h
    call 0f03ch
    pop de
    call 0f060h
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    ret

cread_:
;Read CP/M image from a Corvus drive.
    ld c,(hl)
    call 0f01bh
    ld de,4000h
    ld bc,0000h
cread2:
    call 0f01eh
    push bc
    ld bc,0000h
cread1:
    call 0f021h
    push bc
    push de
    call 0f027h
    or a
    jr nz,cwrit3
    pop de
    ld bc,0080h
    ld hl,0080h
l2945h:
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
;Write CP/M image to a Corvus drive.
    ld c,(hl)
    call 0f01bh
    ld hl,4000h
    ld bc,0000h
cwrit2:
    call 0f01eh
    push bc
    ld bc,0000h
cwrit1:
    call 0f021h
    push bc
    ld bc,0080h
    ld de,0080h
    ldir
    push hl
    call 0f02ah
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
l2984h:
    ld a,c
    cp 02h
    jr nz,cwrit2
    ret
cwrit3:
    pop hl
    pop hl
    pop hl
    jp l2b7ah

dtype:
;Get the drive type for a CP/M drive number.
    ld a,(hl)
    call 0f051h
    ld (hl),c
    inc hl
    ld (hl),00h
    ret

idisk:
;Initialize an IEEE-488 disk drive.
    ld a,(hl)
    jp 0f078h

dskerr:
    ld a,(l2be6h)
    ld (hl),a
    inc hl
    xor a
    ld (hl),a
    ld a,(l2be6h)
    or a
    ret z
    ld de,l29cbh
    ld c,09h
    call 0005h
    ld hl,0eac0h
l29b4h:
    ld e,(hl)
    push hl
    ld c,02h
    call 0005h
    pop hl
    inc hl
    ld a,(hl)
    cp 0dh
    jr nz,l29b4h
    ld de,l29dbh
    ld c,09h
    call 0005h
    ret
l29cbh:
    dec c
    ld a,(bc)
    db "Disk error : $"
l29dbh:
    db 0dh,0ah,"$"

sub_29deh:
;Open "CP/M" file on an IEEE-488 drive
    ld c,06h
    ld hl,l2bd3h
l29e3h:
    ld a,(l2be5h)
    rra
    jp nc,0f05dh
    ld hl,l2bd9h
    jp 0f05dh

sub_29f0h:
;Open "K" file on an IEEE-488 drive
    ld c,03h
    ld hl,l2bdfh
    ld a,(l2be5h)
    rra
    jp nc,0f05dh
    ld hl,l2be2h
l29ffh:
    jp 0f05dh

savesy:
;Read the CP/M system image from an IEEE-488 drive.
    ld a,(hl)
    ld (l2be5h),a
    call 0f054h
    push de
    ld e,0fh
    ld hl,l2bcbh
    ld a,(l2be5h)
    rra
l2a13h:
    jr nc,l2a18h
    ld hl,2bcfh
l2a18h:
    ld c,04h
    call 0f05dh
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    pop de
l2a27h:
    cp 01h
    ret nz
    ld e,01h
l2a2ch:
    push de
    call sub_29f0h
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    pop de
    or a
    ret nz
    push de
    call 0f033h
    ld hl,6000h
    ld bc,l0800h
l2a46h:
    ld a,(hl)
    call 0f042h
l2a4ah:
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2a46h
    call 0f036h
    pop de
    push de
    call 0f060h
    pop de
    push de
    call sub_29deh
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    pop de
    or a
    ret nz
    push de
    call 0f033h
    ld hl,4000h
    ld bc,1c00h
l2a73h:
    ld a,(hl)
    call 0f042h
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2a73h
    call 0f036h
    pop de
    call 0f060h
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    ret
    ld a,(hl)
    ld (l2be5h),a
    call 0f054h
    ld a,(l2be5h)
    and 01h
    add a,30h
    ld (l2ba6h+1),a
    ld e,0fh
    ld c,14h
    ld hl,2ba6h
    call 0f05dh
l2aa9h:
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    or a
    ret nz
    ld a,(l2be5h)
    call 0f078h
sub_2abah:
    ld hl,4000h
    ld de,4001h
    ld bc,00ffh
    ld (hl),0e5h
    ldir
    ld a,07h
    ld (l2bcah),a
    ld a,01h
    ld (l2bc9h),a
l2ad1h:
    call sub_2ae7h
    ld a,(l2be5h)
    call 0f05ah
    ld (l2be6h),a
    or a
    ret nz
    ld hl,l2bcah
    dec (hl)
    jp p,l2ad1h
    ret
sub_2ae7h:
    ld hl,l2bc1h
    ld c,06h
    ld a,(l2be5h)
    call 0f057h
    call 0f04bh
    ld a,(4000h)
    call 0f045h
    call 0f036h
    ld hl,l2bbah
    ld c,07h
    ld a,(l2be5h)
    call 0f057h
    call 0f04bh
    call 0f048h
    call 0f036h
    ld a,(l2be5h)
    call 0f054h
    ld e,02h
    call 0f033h
    ld hl,4001h
    ld c,0ffh
    call 0f04bh
    call 0f036h
    ld a,(l2be5h)
    call 0f057h
    ld hl,l2ba1h
    ld c,05h
    call 0f04bh
    ld a,(l2be5h)
    and 01h
    add a,30h
    call 0f042h
    ld a,(l2bc9h)
    call 0f04eh
    ld a,(l2bcah)
    call 0f04eh
    call 0f048h
    jp 0f036h
    ld c,(hl)
    call 0f01bh
    ld hl,0080h
l2b59h:
    ld (hl),0e5h
    inc l
    jr nz,l2b59h
    ld bc,0002h
    call 0f01eh
    ld bc,0000h
l2b67h:
    push bc
    call 0f021h
    call 0f02ah
    pop bc
    or a
    jp nz,l2b7ah
    inc bc
    ld a,c
    cp 40h
    jr nz,l2b67h
    ret
l2b7ah:
    ld de,l2b87h
    ld c,09h
    call 0005h
    ld c,01h
    jp 0005h

l2b87h:
    db 0dh,0ah,"Hit any key to abort : $"
l2ba1h:
    db "U2 2 "
l2ba6h:
    db "N0:CP/M V2.2 DISK,XX"
l2bbah:
    db "B-P 2 1"
l2bc1h:
    db "M-W",00h,13h,01h
    db "#2"

l2bc9h:
    db 53h
l2bcah:
    db 3ah

l2bcbh:
    db "S0:*"
    db "S1:*"
l2bd3h:
    db "0:CP/M"
l2bd9h:
    db "1:CP/M"
l2bdfh:
    db "0:K"
l2be2h:
    db "1:K"

l2be5h:
    db 2dh
l2be6h:
    db 54h

; End of LOADSAVE.REL =======================================================

; Start of KLIB.REL =========================================================

; XSTRIN --------------------------------------------------------------------

tmp:
;Temporary string
    db 0feh             ;header: string length
    dw 0ca64h           ;header: start address of string
    db 0d6h, 53h        ;string data (not at start address ??)

print_spc:
;Print a space
    ld a,' '
    call conout
    ret

print_eol:
    ld a,0ah
    call conout
    ld a,0dh
    call conout
    ret

hex:
;XSTRIN: HEX
;Make a temporary string (length 2 bytes) with the hexadecimal
;representation of the byte in HL and return a pointer to it in HL.
;Implements BASIC function: HEX$(x)
;
    ld a,02h            ;A = 2 bytes in string
    ld (tmp),a          ;Store length in temp string header
    ld a,l              ;A = L
    call xstrin_3       ;Convert high nibble in A to ASCII
    ld (tmp+3),a        ;Save it as first char of string
    ld a,l              ;A = L
    call xstrin_4       ;Convert low nibble in A to ASCII
    ld (tmp+4),a        ;Save it as second char of string
    ld hl,tmp           ;HL = address of the string
    ret

xstrin_3:
    rrca
    rrca
    rrca
    rrca
xstrin_4:
    and 0fh
    cp 0ah
    jp m,xstrin_5
    add a,07h
xstrin_5:
    add a,30h
    ret

chr:
;XSTRIN: CHR
;Make a temporary string from the char in L and
;return a pointer to it in HL.
;Implements BASIC function: CHR$(x)
;
    ld a,01h            ;A = 1 byte in string
    ld (tmp),a          ;Store length in temp string header
    ld a,l              ;A = L
    ld (tmp+3),a        ;Store A as the temp string data
    ld hl,tmp           ;HL = address of the string
    ret

pv2d:
;XSTRIN: PV2D
;Print string in HL followed by CR+LF
;Implements BASIC command: PRINT"foo"
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    jp z,print_eol      ;If length = 0, jump to print CR+LF only.
    call print_str      ;Print the string
    jp print_eol        ;Jump out to print CR+LF

pv1d:
;XSTRIN: PV1D
;Print string in HL but do not send CR+LF
;Implements BASIC command: PRINT"foo";
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    ret z               ;If length = 0, return (nothing to do).
    call print_str      ;Print the string
    ret

pv0d:
;XSTRIN: PV0D
;Print string in HL followed by a space
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    jp z,print_spc      ;If length = 0, jump out print a space only.
    call print_str      ;Print the string
    jp print_spc        ;Jump out to print a space

print_str:
;Print string of length A at pointer HL.
;
    ld b,a              ;B = A
    inc hl              ;Skip string length byte
    inc hl              ;Skip string start address low byte
    inc hl              ;Skip string start address high byte
l2c52h:
    ld a,(hl)           ;Read char from string
    call conout         ;Print it
    dec b               ;Decrement number of chars remaining
    inc hl              ;Increment pointer
    jp nz,l2c52h        ;Loop until all chars have been printed
    ret

; DIV1 ----------------------------------------------------------------------

idvd:
;DIV1: $IDVD
    ex de,hl
    pop hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    jp l2c6ah

idva:
;DIV1: $IDVA
    ld b,h
    ld c,l
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
l2c6ah:
    inc hl
    push hl
    jp l2c72h

idvb:
;DIV1: $IDVB
    ex de,hl

idve:
;DIV1: $IDVE
    ld b,h
    ld c,l
l2c72h:
    ld a,d
    cpl
    ld d,a
    ld a,e
    cpl
    ld e,a
    inc de
    ld hl,0000h
    ld a,11h
l2c7eh:
    push hl
    add hl,de
    jp nc,l2c84h
    ex (sp),hl
l2c84h:
    pop hl
    push af
    ld a,c
    rla
    ld c,a
    ld a,b
    rla
    ld b,a
    ld a,l
    rla
    ld l,a
    ld a,h
    rla
    ld h,a
    pop af
    dec a
    jp nz,l2c7eh
    ld l,c
    ld h,b
    ret

; MUL1 ----------------------------------------------------------------------

imug:
;MUL1: IMUG
    ld b,h
    ld c,l
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    ld l,c
    ld h,b

imuh:
;MUL1: IMUH
    ld a,h
    or l
    ret z
    ex de,hl
    ld a,h
    or l
    ret z
    ld b,h
    ld c,l
    ld hl,0000h
    ld a,10h
l2cb2h:
    add hl,hl
    ex de,hl
    add hl,hl
    ex de,hl
    jp nc,l2cbah
    add hl,bc
l2cbah:
    dec a
    jp nz,l2cb2h
    ret

; N16 -----------------------------------------------------------------------

pv0c:
pv1c:
;N16: PV0C and PV1C
    call sub_2cd6h
    ld a,20h
    call conout
    ret

pv2c:
;N16: PV2C
    call sub_2cd6h
    ld a,0ah
    call conout
    ld a,0dh
    call conout
    ret

sub_2cd6h:
    push hl
    ld a,h
    and 80h
    jp z,l2ce9h
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    inc hl
    ld a,2dh
    call conout
l2ce9h:
    ld c,30h
    ld de,2710h
    call sub_2d0bh
    ld de,l03e8h
    call sub_2d0bh
    ld de,0064h
    call sub_2d0bh
    ld de,000ah
    call sub_2d0bh
    ld de,0001h
    call sub_2d0bh
    pop hl
    ret

sub_2d0bh:
    call sub_2d1dh
    jp c,l2d15h
    inc c
    jp sub_2d0bh

l2d15h:
    ld a,c
    call conout
    add hl,de
    ld c,30h
    ret

sub_2d1dh:
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    ld h,a
    ret

; XXXLIB --------------------------------------------------------------------

end:
;XXXLIB: $END
;Jump to CP/M warm start
;Implements BASIC command: END
    jp warm

ini:
;XXXLIB: INI
;Jump to the address in HL
    jp (hl)

n5_0:
;XXXLIB: $5.0
;Do nothing and return
    ret

; CPMIO ---------------------------------------------------------------------

charin:
;CPMIO: CHARIN
    ld hl,0fffeh
    jp conin

conout:
;CPMIO: CONOUT
;Write the char in A to the console
    push hl
    push de
    push bc
    push af
    ld c,02h
    ld e,a
    call 0005h
    pop af
    pop bc
    pop de
    pop hl

pr0a:
;CPMIO: $PR0A
;Do nothing and return
    ret

conin:
;CPMIO: CONIN
    push de
    push bc
    push hl
    ld c,01h
    call 0005h
    pop hl
    ld (hl),a
    inc hl
    ld (hl),00h
    pop bc
    pop de
    ret

char:
;CPMIO: CHAR
    ld a,(hl)
    jp conout

;TODO: Unknown code below ---------------------------------------------------

    call conout         ;2d52 cd 2f 2d
    ret                 ;2d55 c9
    push hl             ;2d56 e5
    ld a,h              ;2d57 7c
    and 80h             ;2d58 e6 80
    jp z,l2ce9h         ;2d5a ca e9 2c
    ld a,l              ;2d5d 7d
    cpl                 ;2d5e 2f
    ld l,a              ;2d5f 6f
    ld a,h              ;2d60 7c
    cpl                 ;2d61 2f
    ld h,a              ;2d62 67
    inc hl              ;2d63 23
    ld a,2dh            ;2d64 3e 2d
    call conout         ;2d66 cd 2f 2d
    ld c,30h            ;2d69 0e 30
    ld de,2710h         ;2d6b 11 10 27
    call sub_2d0bh      ;2d6e cd 0b 2d
    ld de,l03e8h        ;2d71 11 e8 03
    call sub_2d0bh      ;2d74 cd 0b 2d
    ld de,0064h         ;2d77 11 64 00
    call sub_2d0bh      ;2d7a cd 0b 2d
    ld de,000ah         ;2d7d 11 0a 00

; End of KLIB.REL ===========================================================
