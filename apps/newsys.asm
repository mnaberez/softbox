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
l010eh:
    nop                 ;010e 00
    nop                 ;010f 00
    nop                 ;0110 00
    nop                 ;0111 00
    nop                 ;0112 00
    nop                 ;0113 00

; End of BASIC variables ====================================================

    nop                 ;0114 00
    nop                 ;0115 00
    nop                 ;0116 00
    nop                 ;0117 00
    nop                 ;0118 00
    nop                 ;0119 00
    nop                 ;011a 00
    ld (hl),a           ;011b 77
    dec hl              ;011c 2b
    ld a,b              ;011d 78
    and a               ;011e a7
    jp z,2910h          ;011f ca 10 29
    pop de              ;0122 d1
    dec hl              ;0123 2b
l0124h:
    ld (hl),d           ;0124 72
    dec hl              ;0125 2b
    ld (hl),e           ;0126 73
    dec a               ;0127 3d
    jp nz,l2907h        ;0128 c2 07 29
    pop bc              ;012b c1
    ld de,0fffbh        ;012c 11 fb ff
    add hl,de           ;012f 19
    pop af              ;0130 f1
    ld (hl),a           ;0131 77
    ld a,00h            ;0132 3e 00
    inc hl              ;0134 23
    ld (hl),a           ;0135 77
    dec hl              ;0136 2b
    and a               ;0137 a7
    ret nz              ;0138 c0
    jp 2761h            ;0139 c3 61 27
l013ch:
    ld a,(hl)           ;013c 7e
    cp 01h              ;013d fe 01
    scf                 ;013f 37
    ret nz              ;0140 c0
    push de             ;0141 d5
    push hl             ;0142 e5
    ld de,0005h         ;0143 11 05 00
    add hl,de           ;0146 19
    ld e,(hl)           ;0147 5e
    inc hl              ;0148 23
    ld d,(hl)           ;0149 56
    ld a,(de)           ;014a 1a
    cp 0ebh             ;014b fe eb
    jp nz,l2945h        ;014d c2 45 29
    inc de              ;0150 13
    ld a,(de)           ;0151 1a
    cp 07h              ;0152 fe 07
    jp z,l2945h         ;0154 ca 45 29
    ld hl,0004h         ;0157 21 04 00
    add hl,de           ;015a 19
    ld a,(hl)           ;015b 7e
    pop hl              ;015c e1
    pop de              ;015d d1
    and a               ;015e a7
    ret                 ;015f c9
    pop hl              ;0160 e1
    pop de              ;0161 d1
    scf                 ;0162 37
    ret                 ;0163 c9
    call 2e71h          ;0164 cd 71 2e
    sub 0e7h            ;0167 d6 e7
    and a               ;0169 a7
    ret nz              ;016a c0
    call 2730h          ;016b cd 30 27
    xor a               ;016e af
    ret                 ;016f c9
    call 2e71h          ;0170 cd 71 2e
    cp 9fh              ;0173 fe 9f
    ret z               ;0175 c8
    cp 9dh              ;0176 fe 9d
    ret                 ;0178 c9
    ld a,(hl)           ;0179 7e
    cp 01h              ;017a fe 01
    scf                 ;017c 37
    ret nz              ;017d c0
    push de             ;017e d5
    ex de,hl            ;017f eb
    ld hl,0005h         ;0180 21 05 00
    add hl,de           ;0183 19
    ld a,(hl)           ;0184 7e
    inc hl              ;0185 23
    ld h,(hl)           ;0186 66
    ld l,a              ;0187 6f
    ld a,(hl)           ;0188 7e
    cp 0edh             ;0189 fe ed
    jp z,2981h          ;018b ca 81 29
    cp 0ebh             ;018e fe eb
    scf                 ;0190 37
    jp nz,2981h         ;0191 c2 81 29
    inc hl              ;0194 23
    ld a,(hl)           ;0195 7e
    dec hl              ;0196 2b
    xor 07h             ;0197 ee 07
    sub 01h             ;0199 d6 01
    ld a,(hl)           ;019b 7e
    ex de,hl            ;019c eb
    pop de              ;019d d1
    ret                 ;019e c9
    ld a,(de)           ;019f 1a
    ld (hl),a           ;01a0 77
    ld a,l              ;01a1 7d
    ld (de),a           ;01a2 12
    ld b,h              ;01a3 44
    inc de              ;01a4 13
    inc hl              ;01a5 23
    ld a,(de)           ;01a6 1a
    ld (hl),a           ;01a7 77
    ld a,b              ;01a8 78
    ld (de),a           ;01a9 12
    inc hl              ;01aa 23
    ret                 ;01ab c9
    call 2ecah          ;01ac cd ca 2e
    rst 20h             ;01af e7
    ret                 ;01b0 c9
    push af             ;01b1 f5
    ex de,hl            ;01b2 eb
    call 273dh          ;01b3 cd 3d 27
    pop af              ;01b6 f1
    call 48beh          ;01b7 cd be 48
    jp l2984h           ;01ba c3 84 29
    push hl             ;01bd e5
    push de             ;01be d5
    ld hl,0ffd8h        ;01bf 21 d8 ff
    add hl,sp           ;01c2 39
    ex de,hl            ;01c3 eb
    ld hl,(l16c3h)      ;01c4 2a c3 16
    add hl,de           ;01c7 19
    ccf                 ;01c8 3f
    pop de              ;01c9 d1
    pop hl              ;01ca e1
    ret nc              ;01cb d0
    ld a,05h            ;01cc 3e 05
    jp 1fc2h            ;01ce c3 c2 1f
    ld a,(12c4h)        ;01d1 3a c4 12
    sub 01h             ;01d4 d6 01
    jp nz,29c6h         ;01d6 c2 c6 29
    ld (12b6h),a        ;01d9 32 b6 12
    ld a,02h            ;01dc 3e 02
    ld (12c4h),a        ;01de 32 c4 12
    ld a,(12c4h)        ;01e1 3a c4 12
    ld b,00h            ;01e4 06 00
    cp 02h              ;01e6 fe 02
    jp z,29d2h          ;01e8 ca d2 29
    ld b,20h            ;01eb 06 20
    push bc             ;01ed c5
    call 4cfdh          ;01ee cd fd 4c
    jp z,l2a4ah         ;01f1 ca 4a 2a
    jp p,l29e3h         ;01f4 f2 e3 29
    pop af              ;01f7 f1
    or 80h              ;01f8 f6 80
    push af             ;01fa f5
    call 4ce2h          ;01fb cd e2 4c
    ld a,(12c4h)        ;01fe 3a c4 12
    cp 02h              ;0201 fe 02
    jp z,l2a2ch         ;0203 ca 2c 2a
    push af             ;0206 f5
    ld hl,12bbh         ;0207 21 bb 12
    call 4d6bh          ;020a cd 6b 4d
    call 1f5eh          ;020d cd 5e 1f
    jp nc,29fbh         ;0210 d2 fb 29
    call 4e86h          ;0213 cd 86 4e
    ld hl,2a07h         ;0216 21 07 2a
    push hl             ;0219 e5
    call 4e57h          ;021a cd 57 4e
    pop hl              ;021d e1
    pop bc              ;021e c1
    jp 2a48h            ;021f c3 48 2a
    pop bc              ;0222 c1
    ld hl,(12b5h)       ;0223 2a b5 12
    push hl             ;0226 e5
    ld a,b              ;0227 78
    cp 04h              ;0228 fe 04
    dw 1bcah            ;022a

; Start of BASIC variables ==================================================

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
mode:
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

; End of BASIC variables ====================================================

l02d0h:
    dw 0cec3h
clock:
    dw 3e2bh
lptype:
    dw 0158h
    dw 0007h
l02d8h:
    call 2716h          ;02d8 cd 16 27
    ld (hl),e           ;02db 73
l02dch:
    inc hl              ;02dc 23
    ld (hl),d           ;02dd 72
l02deh:
    db 2bh
    db 0c3h
buf:
    db 5dh, 27h
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
    ld (mode),hl

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
    ld de,l010eh        ;04f7 11 0e 01
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
    ld de,l0124h        ;050b 11 24 01
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
    ld de,013ah         ;0544 11 3a 01
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
    call clear_screen   ;05b5 cd bd 1b

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

    call readline       ;0675 cd ca 1b
    ld hl,(rr)          ;0678 2a b2 02
    ld de,0ffaeh        ;067b 11 ae ff
    add hl,de           ;067e 19
    ld a,h              ;067f 7c
    or l                ;0680 b5
    jp z,l06deh         ;0681 ca de 06
    ld hl,(rr)          ;0684 2a b2 02
    ld de,0ffafh        ;0687 11 af ff
    add hl,de           ;068a 19
    ld a,h              ;068b 7c
    or l                ;068c b5
    jp nz,l0693h        ;068d c2 93 06
    call end            ;0690 cd 24 2d
l0693h:
    ld hl,(rr)          ;0693 2a b2 02
    ld de,0ffb7h        ;0696 11 b7 ff
    add hl,de           ;0699 19
    ld a,h              ;069a 7c
    or l                ;069b b5
    jp z,l0a7bh         ;069c ca 7b 0a
    ld hl,(rr)          ;069f 2a b2 02
    ld de,0ffbch        ;06a2 11 bc ff
    add hl,de           ;06a5 19
    ld a,h              ;06a6 7c
    or l                ;06a7 b5
    jp z,l0eadh         ;06a8 ca ad 0e
    ld hl,(rr)          ;06ab 2a b2 02
    ld de,0ffbfh        ;06ae 11 bf ff
    add hl,de           ;06b1 19
    ld a,h              ;06b2 7c
    or l                ;06b3 b5
    jp z,l1362h         ;06b4 ca 62 13
    ld hl,(rr)          ;06b7 2a b2 02
    ld de,0ffbbh        ;06ba 11 bb ff
    add hl,de           ;06bd 19
    ld a,h              ;06be 7c
    or l                ;06bf b5
    jp z,l1494h         ;06c0 ca 94 14
    ld hl,(rr)          ;06c3 2a b2 02
    ld de,0ffadh        ;06c6 11 ad ff
    add hl,de           ;06c9 19
    ld a,h              ;06ca 7c
    or l                ;06cb b5
    jp z,l1668h         ;06cc ca 68 16
    ld hl,(rr)          ;06cf 2a b2 02
    ld de,0ffb0h        ;06d2 11 b0 ff
    add hl,de           ;06d5 19
    ld a,h              ;06d6 7c
    or l                ;06d7 b5
    jp z,l1743h         ;06d8 ca 43 17
    jp l05b5h           ;06db c3 b5 05
l06deh:
    call clear_screen   ;06de cd bd 1b

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
    ld hl,(mode)        ;0708 2a c0 02
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

    ld hl,(mode)        ;0734 2a c0 02
    ld a,l              ;0737 7d
    and 0c0h            ;0738 e6 c0
    ld l,a              ;073a 6f
    ld a,h              ;073b 7c
    and 00h             ;073c e6 00
    ld h,a              ;073e 67
    ld (02d6h),hl       ;073f 22 d6 02
    ld hl,(02d6h)       ;0742 2a d6 02
    ld a,h              ;0745 7c
    or l                ;0746 b5
    jp nz,l0753h        ;0747 c2 53 07

    ;PRINT "undefined"
    call pr0a
    ld hl,undefined
    call pv2d

l0753h:
    ld hl,(02d6h)       ;0753 2a d6 02
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
    ld hl,(02d6h)       ;0768 2a d6 02
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
    ld hl,(02d6h)       ;077d 2a d6 02
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

    ld hl,(mode)        ;07a4 2a c0 02
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
    ld hl,(mode)        ;07bd 2a c0 02
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
    ld hl,(mode)        ;07da 2a c0 02
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

    call readline       ;0899 cd ca 1b
    ld hl,(rr)          ;089c 2a b2 02
    ld de,0ffcfh        ;089f 11 cf ff
    add hl,de           ;08a2 19
    ld a,h              ;08a3 7c
    or l                ;08a4 b5
    jp z,l08d7h         ;08a5 ca d7 08
    ld hl,(rr)          ;08a8 2a b2 02
    ld a,h              ;08ab 7c
    or l                ;08ac b5
    jp z,l05b5h         ;08ad ca b5 05
    ld hl,(rr)          ;08b0 2a b2 02
    ld de,0ffceh        ;08b3 11 ce ff
    add hl,de           ;08b6 19
    ld a,h              ;08b7 7c
    or l                ;08b8 b5
    jp z,l0930h         ;08b9 ca 30 09
    ld hl,(rr)          ;08bc 2a b2 02
    ld de,0ffcdh        ;08bf 11 cd ff
    add hl,de           ;08c2 19
    ld a,h              ;08c3 7c
    or l                ;08c4 b5
    jp z,l0983h         ;08c5 ca 83 09
    ld hl,(rr)          ;08c8 2a b2 02
    ld de,0ffcch        ;08cb 11 cc ff
    add hl,de           ;08ce 19
    ld a,h              ;08cf 7c
    or l                ;08d0 b5
    jp z,l09e8h         ;08d1 ca e8 09
    jp l06deh           ;08d4 c3 de 06
l08d7h:
    ;PRINT "New character length (5 to 8) ? "
    call pr0a
    ld hl,new_char_len
    call pv1d

    call readline       ;08e0 cd ca 1b
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
    ld hl,(mode)        ;0912 2a c0 02
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
    ld (mode),hl        ;092a 22 c0 02
l092dh:
    jp l06deh           ;092d c3 de 06
l0930h:
    ;PRINT "Number of stop bits (1 or 2)  ? ";
    call pr0a
    ld hl,num_stop_bits
    call pv1d

    call readline       ;0939 cd ca 1b
    ld hl,(rr)          ;093c 2a b2 02
    ld de,0ffcfh        ;093f 11 cf ff
    add hl,de           ;0942 19
    ld a,h              ;0943 7c
    or l                ;0944 b5
    jp nz,l095eh        ;0945 c2 5e 09
    ld hl,(mode)        ;0948 2a c0 02
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
    ld (mode),hl        ;095b 22 c0 02
l095eh:
    ld hl,(rr)          ;095e 2a b2 02
    ld de,0ffceh        ;0961 11 ce ff
    add hl,de           ;0964 19
    ld a,h              ;0965 7c
    or l                ;0966 b5
    jp nz,l0980h        ;0967 c2 80 09
    ld hl,(mode)        ;096a 2a c0 02
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
    ld (mode),hl        ;097d 22 c0 02
l0980h:
    jp l06deh           ;0980 c3 de 06
l0983h:
    ;PRINT "O(dd), E(ven) or N(o parity) ? ";
    call pr0a
    ld hl,odd_even_none
    call pv1d

    call readline       ;098c cd ca 1b
    ld hl,(rr)          ;098f 2a b2 02
    ld de,0ffb1h        ;0992 11 b1 ff
    add hl,de           ;0995 19
    ld a,h              ;0996 7c
    or l                ;0997 b5
    jp nz,l09b1h        ;0998 c2 b1 09
    ld hl,(mode)        ;099b 2a c0 02
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
    ld (mode),hl        ;09ae 22 c0 02
l09b1h:
    ld hl,(rr)          ;09b1 2a b2 02
    ld de,0ffbbh        ;09b4 11 bb ff
    add hl,de           ;09b7 19
    ld a,h              ;09b8 7c
    or l                ;09b9 b5
    jp nz,l09cbh        ;09ba c2 cb 09
    ld hl,(mode)        ;09bd 2a c0 02
    ld a,l              ;09c0 7d
    or 30h              ;09c1 f6 30
    ld l,a              ;09c3 6f
    ld a,h              ;09c4 7c
    or 00h              ;09c5 f6 00
    ld h,a              ;09c7 67
    ld (mode),hl        ;09c8 22 c0 02
l09cbh:
    ld hl,(rr)          ;09cb 2a b2 02
    ld de,0ffb2h        ;09ce 11 b2 ff
    add hl,de           ;09d1 19
    ld a,h              ;09d2 7c
    or l                ;09d3 b5
    jp nz,l09e5h        ;09d4 c2 e5 09
    ld hl,(mode)        ;09d7 2a c0 02
    ld a,l              ;09da 7d
    and 0efh            ;09db e6 ef
    ld l,a              ;09dd 6f
    ld a,h              ;09de 7c
    and 00h             ;09df e6 00
    ld h,a              ;09e1 67
    ld (mode),hl        ;09e2 22 c0 02
l09e5h:
    jp l06deh           ;09e5 c3 de 06
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

    call readline       ;0a03 cd ca 1b
    ld hl,(l02d8h)      ;0a06 2a d8 02
    ld de,0ff92h        ;0a09 11 92 ff
    add hl,de           ;0a0c 19
    ld a,h              ;0a0d 7c
    or l                ;0a0e b5
    jp nz,l0a1bh        ;0a0f c2 1b 0a
    ld hl,0022h         ;0a12 21 22 00
    ld (baud),hl        ;0a15 22 c2 02
    jp l0a2dh           ;0a18 c3 2d 0a
l0a1bh:
    ld hl,(l02d8h)      ;0a1b 2a d8 02
    ld de,0fed4h        ;0a1e 11 d4 fe
    add hl,de           ;0a21 19
    ld a,h              ;0a22 7c
    or l                ;0a23 b5
    jp nz,l0a2dh        ;0a24 c2 2d 0a
    ld hl,0055h         ;0a27 21 55 00
    ld (baud),hl        ;0a2a 22 c2 02
l0a2dh:
    ld hl,(l02d8h)      ;0a2d 2a d8 02
    ld de,0fb50h        ;0a30 11 50 fb
    add hl,de           ;0a33 19
    ld a,h              ;0a34 7c
    or l                ;0a35 b5
    jp nz,l0a42h        ;0a36 c2 42 0a
    ld hl,0077h         ;0a39 21 77 00
    ld (baud),hl        ;0a3c 22 c2 02
    jp l0a54h           ;0a3f c3 54 0a
l0a42h:
    ld hl,(l02d8h)      ;0a42 2a d8 02
    ld de,0da80h        ;0a45 11 80 da
    add hl,de           ;0a48 19
    ld a,h              ;0a49 7c
    or l                ;0a4a b5
    jp nz,l0a54h        ;0a4b c2 54 0a
    ld hl,00eeh         ;0a4e 21 ee 00
    ld (baud),hl        ;0a51 22 c2 02
l0a54h:
    ld hl,(l02d8h)      ;0a54 2a d8 02
    ld de,0ed40h        ;0a57 11 40 ed
    add hl,de           ;0a5a 19
    ld a,h              ;0a5b 7c
    or l                ;0a5c b5
    jp nz,l0a66h        ;0a5d c2 66 0a
    ld hl,00cch         ;0a60 21 cc 00
    ld (baud),hl        ;0a63 22 c2 02
l0a66h:
    ld hl,(l02d8h)      ;0a66 2a d8 02
    ld de,0b500h        ;0a69 11 00 b5
    add hl,de           ;0a6c 19
    ld a,h              ;0a6d 7c
    or l                ;0a6e b5
    jp nz,l0a78h        ;0a6f c2 78 0a
    ld hl,00ffh         ;0a72 21 ff 00
    ld (baud),hl        ;0a75 22 c2 02
l0a78h:
    jp l06deh           ;0a78 c3 de 06
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

    ld hl,(iobyte)      ;0b02 2a 0c 01
    ld a,l              ;0b05 7d
    and 0c0h            ;0b06 e6 c0
    ld l,a              ;0b08 6f
    ld a,h              ;0b09 7c
    and 00h             ;0b0a e6 00
    ld h,a              ;0b0c 67
    ld a,h              ;0b0d 7c
    or l                ;0b0e b5
    jp nz,l0b1bh        ;0b0f c2 1b 0b

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

l0b1bh:
    ld hl,(iobyte)      ;0b1b 2a 0c 01
    ld a,l              ;0b1e 7d
    and 0c0h            ;0b1f e6 c0
    ld l,a              ;0b21 6f
    ld a,h              ;0b22 7c
    and 00h             ;0b23 e6 00
    ld h,a              ;0b25 67
    ld de,0ffc0h        ;0b26 11 c0 ff
    add hl,de           ;0b29 19
    ld a,h              ;0b2a 7c
    or l                ;0b2b b5
    jp nz,l0b38h        ;0b2c c2 38 0b

    ;PRINT "CRT:"
    call pr0a
    ld hl,crt
    call pv2d

l0b38h:
    ld hl,(iobyte)      ;0b38 2a 0c 01
    ld a,l              ;0b3b 7d
    and 0c0h            ;0b3c e6 c0
    ld l,a              ;0b3e 6f
    ld a,h              ;0b3f 7c
    and 00h             ;0b40 e6 00
    ld h,a              ;0b42 67
    ld de,0ff80h        ;0b43 11 80 ff
    add hl,de           ;0b46 19
    ld a,h              ;0b47 7c
    or l                ;0b48 b5
    jp nz,l0b55h        ;0b49 c2 55 0b

    ;PRINT "LPT:"
    call pr0a
    ld hl,lpt_colon
    call pv2d

l0b55h:
    ld hl,(iobyte)      ;0b55 2a 0c 01
    ld a,l              ;0b58 7d
    and 0c0h            ;0b59 e6 c0
    ld l,a              ;0b5b 6f
    ld a,h              ;0b5c 7c
    and 00h             ;0b5d e6 00
    ld h,a              ;0b5f 67
    ld de,0ff40h        ;0b60 11 40 ff
    add hl,de           ;0b63 19
    ld a,h              ;0b64 7c
    or l                ;0b65 b5
    jp nz,l0b72h        ;0b66 c2 72 0b

    ;PRINT "UL1:"
    call pr0a           ;0b69 cd 3d 2d
    ld hl,ul1_colon     ;0b6c 21 fc 23
    call pv2d           ;0b6f cd 31 2c

l0b72h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "6.  Default RDR: device :     ";
    call pr0a
    ld hl,default_rdr
    call pv1d

    ld hl,(iobyte)      ;0b84 2a 0c 01
    ld a,l              ;0b87 7d
    and 0ch             ;0b88 e6 0c
    ld l,a              ;0b8a 6f
    ld a,h              ;0b8b 7c
    and 00h             ;0b8c e6 00
    ld h,a              ;0b8e 67
    ld a,h              ;0b8f 7c
    or l                ;0b90 b5
    jp nz,l0ba0h        ;0b91 c2 a0 0b

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

    jp l0ba9h           ;0b9d c3 a9 0b
l0ba0h:
    call pr0a           ;0ba0 cd 3d 2d
    ld hl,ptr           ;0ba3 21 d4 23
    call pv2d           ;0ba6 cd 31 2c
l0ba9h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "7.  Default PUN: device :     ";
    call pr0a
    ld hl,default_pun
    call pv1d

    ld hl,(iobyte)      ;0bbb 2a 0c 01
    ld a,l              ;0bbe 7d
    and 30h             ;0bbf e6 30
    ld l,a              ;0bc1 6f
    ld a,h              ;0bc2 7c
    and 00h             ;0bc3 e6 00
    ld h,a              ;0bc5 67
    ld a,h              ;0bc6 7c
    or l                ;0bc7 b5
    jp nz,l0bd7h        ;0bc8 c2 d7 0b

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

    jp l0be0h           ;0bd4 c3 e0 0b

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

    call readline       ;0c48 cd ca 1b
    ld hl,(rr)          ;0c4b 2a b2 02
    ld a,h              ;0c4e 7c
    or l                ;0c4f b5
    jp z,l05b5h         ;0c50 ca b5 05
    ld hl,(rr)          ;0c53 2a b2 02
    ld de,0ffcah        ;0c56 11 ca ff
    add hl,de           ;0c59 19
    ld a,h              ;0c5a 7c
    or l                ;0c5b b5
    jp z,l0da5h         ;0c5c ca a5 0d
    ld hl,(rr)          ;0c5f 2a b2 02
    ld de,0ffc9h        ;0c62 11 c9 ff
    add hl,de           ;0c65 19
    ld a,h              ;0c66 7c
    or l                ;0c67 b5
    jp z,l0df0h         ;0c68 ca f0 0d
    ld hl,(rr)          ;0c6b 2a b2 02
    ld de,0ffcbh        ;0c6e 11 cb ff
    add hl,de           ;0c71 19
    ld a,h              ;0c72 7c
    or l                ;0c73 b5
    jp z,l0ce0h         ;0c74 ca e0 0c
    ld hl,(rr)          ;0c77 2a b2 02
    ld de,0ffc8h        ;0c7a 11 c8 ff
    add hl,de           ;0c7d 19
    ld a,h              ;0c7e 7c
    or l                ;0c7f b5
    jp z,l0e3bh         ;0c80 ca 3b 0e
    ld hl,(rr)          ;0c83 2a b2 02
    ld (l02d8h+2),hl    ;0c86 22 da 02

    ;PRINT "New device # ? "
    call pr0a
    ld hl,new_dev_num
    call pv1d

    call readline       ;0c92 cd ca 1b
    ld hl,(l02d8h+2)    ;0c95 2a da 02
    ld de,0ffcfh        ;0c98 11 cf ff
    add hl,de           ;0c9b 19
    ld a,h              ;0c9c 7c
    or l                ;0c9d b5
    jp nz,l0ca7h        ;0c9e c2 a7 0c
    ld hl,(l02d8h)      ;0ca1 2a d8 02
    ld (lpt),hl         ;0ca4 22 ba 02
l0ca7h:
    ld hl,(l02d8h+2)    ;0ca7 2a da 02
    ld de,0ffceh        ;0caa 11 ce ff
    add hl,de           ;0cad 19
    ld a,h              ;0cae 7c
    or l                ;0caf b5
    jp nz,l0cb9h        ;0cb0 c2 b9 0c
    ld hl,(l02d8h)      ;0cb3 2a d8 02
    ld (ul1),hl         ;0cb6 22 c4 02
l0cb9h:
    ld hl,(l02d8h+2)    ;0cb9 2a da 02
    ld de,0ffcdh        ;0cbc 11 cd ff
    add hl,de           ;0cbf 19
    ld a,h              ;0cc0 7c
    or l                ;0cc1 b5
    jp nz,l0ccbh        ;0cc2 c2 cb 0c
    ld hl,(l02d8h)      ;0cc5 2a d8 02
    ld (rdr),hl         ;0cc8 22 bc 02
l0ccbh:
    ld hl,(l02d8h+2)    ;0ccb 2a da 02
    ld de,0ffcch        ;0cce 11 cc ff
    add hl,de           ;0cd1 19
    ld a,h              ;0cd2 7c
    or l                ;0cd3 b5
    jp nz,l0cddh        ;0cd4 c2 dd 0c
    ld hl,(l02d8h)      ;0cd7 2a d8 02
    ld (pun),hl         ;0cda 22 be 02
l0cddh:
    jp l0a7bh           ;0cdd c3 7b 0a
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

    call readline       ;0d1f cd ca 1b
    ld hl,(rr)          ;0d22 2a b2 02
    ld de,0ffach        ;0d25 11 ac ff
    add hl,de           ;0d28 19
    ld a,h              ;0d29 7c
    or l                ;0d2a b5
    jp nz,l0d3ch        ;0d2b c2 3c 0d
    ld hl,(iobyte)      ;0d2e 2a 0c 01
    ld a,l              ;0d31 7d
    and 3fh             ;0d32 e6 3f
    ld l,a              ;0d34 6f
    ld a,h              ;0d35 7c
    and 00h             ;0d36 e6 00
    ld h,a              ;0d38 67
    ld (iobyte),hl      ;0d39 22 0c 01
l0d3ch:
    ld hl,(rr)          ;0d3c 2a b2 02
    ld de,0ffbdh        ;0d3f 11 bd ff
    add hl,de           ;0d42 19
    ld a,h              ;0d43 7c
    or l                ;0d44 b5
    jp nz,l0d5eh        ;0d45 c2 5e 0d
    ld hl,(iobyte)      ;0d48 2a 0c 01
    ld a,l              ;0d4b 7d
    and 3fh             ;0d4c e6 3f
    ld l,a              ;0d4e 6f
    ld a,h              ;0d4f 7c
    and 00h             ;0d50 e6 00
    ld h,a              ;0d52 67
    ld a,l              ;0d53 7d
    or 40h              ;0d54 f6 40
    ld l,a              ;0d56 6f
    ld a,h              ;0d57 7c
    or 00h              ;0d58 f6 00
    ld h,a              ;0d5a 67
    ld (iobyte),hl      ;0d5b 22 0c 01
l0d5eh:
    ld hl,(rr)          ;0d5e 2a b2 02
    ld de,0ffb4h        ;0d61 11 b4 ff
    add hl,de           ;0d64 19
    ld a,h              ;0d65 7c
    or l                ;0d66 b5
    jp nz,l0d80h        ;0d67 c2 80 0d
    ld hl,(iobyte)      ;0d6a 2a 0c 01
    ld a,l              ;0d6d 7d
    and 3fh             ;0d6e e6 3f
    ld l,a              ;0d70 6f
    ld a,h              ;0d71 7c
    and 00h             ;0d72 e6 00
    ld h,a              ;0d74 67
    ld a,l              ;0d75 7d
    or 80h              ;0d76 f6 80
    ld l,a              ;0d78 6f
    ld a,h              ;0d79 7c
    or 00h              ;0d7a f6 00
    ld h,a              ;0d7c 67
    ld (iobyte),hl      ;0d7d 22 0c 01
l0d80h:
    ld hl,(rr)          ;0d80 2a b2 02
    ld de,0ffabh        ;0d83 11 ab ff
    add hl,de           ;0d86 19
    ld a,h              ;0d87 7c
    or l                ;0d88 b5
    jp nz,l0da2h        ;0d89 c2 a2 0d
    ld hl,(iobyte)      ;0d8c 2a 0c 01
    ld a,l              ;0d8f 7d
    and 3fh             ;0d90 e6 3f
    ld l,a              ;0d92 6f
    ld a,h              ;0d93 7c
    and 00h             ;0d94 e6 00
    ld h,a              ;0d96 67
    ld a,l              ;0d97 7d
    or 0c0h             ;0d98 f6 c0
    ld l,a              ;0d9a 6f
    ld a,h              ;0d9b 7c
    or 00h              ;0d9c f6 00
    ld h,a              ;0d9e 67
    ld (iobyte),hl      ;0d9f 22 0c 01
l0da2h:
    jp l0a7bh           ;0da2 c3 7b 0a
l0da5h:
    ;PRINT "T(TY:) or P(TR:) ? "
    call pr0a
    ld hl,tty_or_ptr
    call pv1d

    call readline       ;0dae cd ca 1b
    ld hl,(rr)          ;0db1 2a b2 02
    ld de,0ffach        ;0db4 11 ac ff
    add hl,de           ;0db7 19
    ld a,h              ;0db8 7c
    or l                ;0db9 b5
    jp nz,l0dcbh        ;0dba c2 cb 0d
    ld hl,(iobyte)      ;0dbd 2a 0c 01
    ld a,l              ;0dc0 7d
    and 0f3h            ;0dc1 e6 f3
    ld l,a              ;0dc3 6f
    ld a,h              ;0dc4 7c
    and 00h             ;0dc5 e6 00
    ld h,a              ;0dc7 67
    ld (iobyte),hl      ;0dc8 22 0c 01
l0dcbh:
    ld hl,(rr)          ;0dcb 2a b2 02
    ld de,0ffb0h        ;0dce 11 b0 ff
    add hl,de           ;0dd1 19
    ld a,h              ;0dd2 7c
    or l                ;0dd3 b5
    jp nz,l0dedh        ;0dd4 c2 ed 0d
    ld hl,(iobyte)      ;0dd7 2a 0c 01
    ld a,l              ;0dda 7d
    and 0f3h            ;0ddb e6 f3
    ld l,a              ;0ddd 6f
    ld a,h              ;0dde 7c
    and 00h             ;0ddf e6 00
    ld h,a              ;0de1 67
    ld a,l              ;0de2 7d
    or 04h              ;0de3 f6 04
    ld l,a              ;0de5 6f
    ld a,h              ;0de6 7c
    or 00h              ;0de7 f6 00
    ld h,a              ;0de9 67
    ld (iobyte),hl      ;0dea 22 0c 01
l0dedh:
    jp l0a7bh           ;0ded c3 7b 0a
l0df0h:
    ;PRINT "T(TY:) or P(TP:) ? ";
    call pr0a
    ld hl,tty_or_ptp
    call pv1d

    call readline       ;0df9 cd ca 1b
    ld hl,(rr)          ;0dfc 2a b2 02
    ld de,0ffach        ;0dff 11 ac ff
    add hl,de           ;0e02 19
    ld a,h              ;0e03 7c
    or l                ;0e04 b5
    jp nz,l0e16h        ;0e05 c2 16 0e
    ld hl,(iobyte)      ;0e08 2a 0c 01
    ld a,l              ;0e0b 7d
    and 0cfh            ;0e0c e6 cf
    ld l,a              ;0e0e 6f
    ld a,h              ;0e0f 7c
    and 00h             ;0e10 e6 00
    ld h,a              ;0e12 67
    ld (iobyte),hl      ;0e13 22 0c 01
l0e16h:
    ld hl,(rr)          ;0e16 2a b2 02
    ld de,0ffb0h        ;0e19 11 b0 ff
    add hl,de           ;0e1c 19
    ld a,h              ;0e1d 7c
    or l                ;0e1e b5
    jp nz,l0e38h        ;0e1f c2 38 0e
    ld hl,(iobyte)      ;0e22 2a 0c 01
    ld a,l              ;0e25 7d
    and 0cfh            ;0e26 e6 cf
    ld l,a              ;0e28 6f
    ld a,h              ;0e29 7c
    and 00h             ;0e2a e6 00
    ld h,a              ;0e2c 67
    ld a,l              ;0e2d 7d
    or 10h              ;0e2e f6 10
    ld l,a              ;0e30 6f
    ld a,h              ;0e31 7c
    or 00h              ;0e32 f6 00
    ld h,a              ;0e34 67
    ld (iobyte),hl      ;0e35 22 0c 01
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

    call readline       ;0e71 cd ca 1b
    ld hl,(rr)          ;0e74 2a b2 02
    ld de,0ffcdh        ;0e77 11 cd ff
    add hl,de           ;0e7a 19
    ld a,h              ;0e7b 7c
    or l                ;0e7c b5
    jp nz,l0e86h        ;0e7d c2 86 0e
    ld hl,0000h         ;0e80 21 00 00
    ld (lptype),hl       ;0e83 22 d4 02
l0e86h:
    ld hl,(rr)          ;0e86 2a b2 02
    ld de,0ffc8h        ;0e89 11 c8 ff
    add hl,de           ;0e8c 19
    ld a,h              ;0e8d 7c
    or l                ;0e8e b5
    jp nz,l0e98h        ;0e8f c2 98 0e
    ld hl,0002h         ;0e92 21 02 00
    ld (lptype),hl      ;0e95 22 d4 02
l0e98h:
    ld hl,(rr)          ;0e98 2a b2 02
    ld de,0ffbch        ;0e9b 11 bc ff
    add hl,de           ;0e9e 19
    ld a,h              ;0e9f 7c
    or l                ;0ea0 b5
    jp nz,l0eaah        ;0ea1 c2 aa 0e
    ld hl,0001h         ;0ea4 21 01 00
    ld (lptype),hl      ;0ea7 22 d4 02
l0eaah:
    jp l0a7bh           ;0eaa c3 7b 0a
l0eadh:
    call clear_screen   ;0ead cd bd 1b

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

    ld hl,0000h         ;0ed4 21 00 00
    ld (l02dch),hl      ;0ed7 22 dc 02
    call sub_119ah      ;0eda cd 9a 11

    ;PRINT "C, D :     "
    call pr0a
    ld hl,drives_c_d
    call pv1d

    ld hl,0001h         ;0ee6 21 01 00
    ld (l02dch),hl      ;0ee9 22 dc 02
    call sub_119ah      ;0eec cd 9a 11

    ;PRINT "E, F :     ";
    call pr0a
    ld hl,drives_e_f
    call pv1d

    ld hl,0002h         ;0ef8 21 02 00
    ld (l02dch),hl      ;0efb 22 dc 02
    call sub_119ah      ;0efe cd 9a 11

    ;PRINT "G, H :     ";
    call pr0a
    ld hl,drives_g_h
    call pv1d

    ld hl,0003h         ;0f0a 21 03 00
    ld (l02dch),hl      ;0f0d 22 dc 02
    call sub_119ah      ;0f10 cd 9a 11

    ;PRINT "I, J :     ";
    call pr0a
    ld hl,drives_i_j
    call pv1d

    ld hl,0004h         ;0f1c 21 04 00
    ld (l02dch),hl      ;0f1f 22 dc 02
    call sub_119ah      ;0f22 cd 9a 11

    ;PRINT "K, L :     ";
    call pr0a
    ld hl,drives_k_l
    call pv1d

    ld hl,0005h         ;0f2e 21 05 00
    ld (l02dch),hl      ;0f31 22 dc 02
    call sub_119ah      ;0f34 cd 9a 11

    ;PRINT "M, N :     ";
    call pr0a
    ld hl,drives_m_n
    call pv1d

    ld hl,0006h         ;0f40 21 06 00
    ld (l02dch),hl      ;0f43 22 dc 02
    call sub_119ah      ;0f46 cd 9a 11

    ;"O, P :     ";
    call pr0a
    ld hl,drives_o_p
    call pv1d

    ld hl,0007h         ;0f52 21 07 00
    ld (l02dch),hl      ;0f55 22 dc 02
    call sub_119ah      ;0f58 cd 9a 11

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which drive pair (A to O) ? ";
    call pr0a
    ld hl,alter_which_pair
    call pv1d

    call readline       ;0f6d cd ca 1b
    ld hl,(rr)          ;0f70 2a b2 02
    ld a,h              ;0f73 7c
    or l                ;0f74 b5
    jp z,l05b5h         ;0f75 ca b5 05
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
    ld (l02dch),hl      ;0fb2 22 dc 02

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3(040), 8(050), h(ard) or u(nused) ? "
    call pr0a
    ld hl,cbm_hard_unused
    call pv1d

    call readline       ;0fc7 cd ca 1b
    ld hl,(rr)          ;0fca 2a b2 02
    ld de,0ffcdh        ;0fcd 11 cd ff
    add hl,de           ;0fd0 19
    ld a,h              ;0fd1 7c
    or l                ;0fd2 b5
    jp nz,l0fe7h        ;0fd3 c2 e7 0f
    ld hl,(l02dch)      ;0fd6 2a dc 02
    add hl,hl           ;0fd9 29
    ld de,l010eh        ;0fda 11 0e 01
    add hl,de           ;0fdd 19
    ld de,0000h         ;0fde 11 00 00
    ld (hl),e           ;0fe1 73
    inc hl              ;0fe2 23
    ld (hl),d           ;0fe3 72
    jp l109fh           ;0fe4 c3 9f 10
l0fe7h:
    ld hl,(rr)          ;0fe7 2a b2 02
    ld de,0ffc8h        ;0fea 11 c8 ff
    add hl,de           ;0fed 19
    ld a,h              ;0fee 7c
    or l                ;0fef b5
    jp nz,l1004h        ;0ff0 c2 04 10
    ld hl,(l02dch)      ;0ff3 2a dc 02
    add hl,hl           ;0ff6 29
    ld de,l010eh        ;0ff7 11 0e 01
    add hl,de           ;0ffa 19
    ld de,0001h         ;0ffb 11 01 00
    ld (hl),e           ;0ffe 73
    inc hl              ;0fff 23
    ld (hl),d           ;1000 72
    jp l109fh           ;1001 c3 9f 10
l1004h:
    ld hl,(rr)          ;1004 2a b2 02
    ld de,0ffabh        ;1007 11 ab ff
    add hl,de           ;100a 19
    ld a,h              ;100b 7c
    or l                ;100c b5
    jp nz,l1021h        ;100d c2 21 10
    ld hl,(l02dch)      ;1010 2a dc 02
    add hl,hl           ;1013 29
    ld de,l010eh        ;1014 11 0e 01
    add hl,de           ;1017 19
    ld de,00ffh         ;1018 11 ff 00
    ld (hl),e           ;101b 73
    inc hl              ;101c 23
    ld (hl),d           ;101d 72
    jp l0eadh           ;101e c3 ad 0e
l1021h:
    ld hl,(rr)          ;1021 2a b2 02
    ld de,0ffb8h        ;1024 11 b8 ff
    add hl,de           ;1027 19
    ld a,h              ;1028 7c
    or l                ;1029 b5
    jp nz,l0eadh        ;102a c2 ad 0e
    ld hl,(mini)        ;102d 2a 0a 01
    ld de,0ffffh        ;1030 11 ff ff
    add hl,de           ;1033 19
    ld a,h              ;1034 7c
    or l                ;1035 b5
    jp z,l10fbh         ;1036 ca fb 10

    ;PRINT "5, 10 or 20 Mbyte drive ? ";
    call pr0a
    ld hl,drv_5_10_20
    call pv1d

    call readline       ;1042 cd ca 1b
    ld hl,(rr)          ;1045 2a b2 02
    ld de,0ffcbh        ;1048 11 cb ff
    add hl,de           ;104b 19
    ld a,h              ;104c 7c
    or l                ;104d b5
    jp nz,l1062h        ;104e c2 62 10
    ld hl,(l02dch)      ;1051 2a dc 02
    add hl,hl           ;1054 29
    ld de,l010eh        ;1055 11 0e 01
    add hl,de           ;1058 19
    ld de,0004h         ;1059 11 04 00
    ld (hl),e           ;105c 73
    inc hl              ;105d 23
    ld (hl),d           ;105e 72
    jp l109fh           ;105f c3 9f 10
l1062h:
    ld hl,(rr)          ;1062 2a b2 02
    ld de,0ffcfh        ;1065 11 cf ff
    add hl,de           ;1068 19
    ld a,h              ;1069 7c
    or l                ;106a b5
    jp nz,l107fh        ;106b c2 7f 10
    ld hl,(l02dch)      ;106e 2a dc 02
    add hl,hl           ;1071 29
    ld de,l010eh        ;1072 11 0e 01
    add hl,de           ;1075 19
    ld de,0002h         ;1076 11 02 00
    ld (hl),e           ;1079 73
    inc hl              ;107a 23
    ld (hl),d           ;107b 72
    jp l109fh           ;107c c3 9f 10
l107fh:
    ld hl,(rr)          ;107f 2a b2 02
    ld de,0ffceh        ;1082 11 ce ff
    add hl,de           ;1085 19
    ld a,h              ;1086 7c
    or l                ;1087 b5
    jp nz,l109ch        ;1088 c2 9c 10
    ld hl,(l02dch)      ;108b 2a dc 02
    add hl,hl           ;108e 29
    ld de,l010eh        ;108f 11 0e 01
    add hl,de           ;1092 19
    ld de,0003h         ;1093 11 03 00
    ld (hl),e           ;1096 73
    inc hl              ;1097 23
    ld (hl),d           ;1098 72
    jp l109fh           ;1099 c3 9f 10
l109ch:
    jp l0eadh           ;109c c3 ad 0e
l109fh:
    ;PRINT "Device number for drive ? ";
    call pr0a
    ld hl,dev_num_for_drv
    call pv1d

    call readline       ;10a8 cd ca 1b
    ld hl,(l02dch)      ;10ab 2a dc 02
    add hl,hl           ;10ae 29
    ld de,l0124h        ;10af 11 24 01
    add hl,de           ;10b2 19
    push hl             ;10b3 e5
    ld hl,(l02d8h)      ;10b4 2a d8 02
    ex de,hl            ;10b7 eb
    pop hl              ;10b8 e1
    ld (hl),e           ;10b9 73
    inc hl              ;10ba 23
    ld (hl),d           ;10bb 72
    ld hl,(l02dch)      ;10bc 2a dc 02
    add hl,hl           ;10bf 29
    ld de,l010eh        ;10c0 11 0e 01
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

    call readline       ;10db cd ca 1b
    ld hl,(rr)          ;10de 2a b2 02
    ld de,0ffceh        ;10e1 11 ce ff
    add hl,de           ;10e4 19
    ld a,h              ;10e5 7c
    or l                ;10e6 b5
    jp nz,l10f8h        ;10e7 c2 f8 10
    ld hl,(l02dch)      ;10ea 2a dc 02
    add hl,hl           ;10ed 29
    ld de,l010eh        ;10ee 11 0e 01
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

    call readline       ;1104 cd ca 1b
    ld hl,(l02d8h)      ;1107 2a d8 02
    ld de,0fffdh        ;110a 11 fd ff
    add hl,de           ;110d 19
    ld a,h              ;110e 7c
    or l                ;110f b5
    jp nz,l1124h        ;1110 c2 24 11
    ld hl,(l02dch)      ;1113 2a dc 02
    add hl,hl           ;1116 29
    ld de,l010eh        ;1117 11 0e 01
    add hl,de           ;111a 19
    ld de,0002h         ;111b 11 02 00
    ld (hl),e           ;111e 73
    inc hl              ;111f 23
    ld (hl),d           ;1120 72
    jp l1161h           ;1121 c3 61 11
l1124h:
    ld hl,(l02d8h)      ;1124 2a d8 02
    ld de,0fffah        ;1127 11 fa ff
    add hl,de           ;112a 19
    ld a,h              ;112b 7c
    or l                ;112c b5
    jp nz,l1141h        ;112d c2 41 11
    ld hl,(l02dch)      ;1130 2a dc 02
    add hl,hl           ;1133 29
    ld de,l010eh        ;1134 11 0e 01
    add hl,de           ;1137 19
    ld de,0003h         ;1138 11 03 00
    ld (hl),e           ;113b 73
    inc hl              ;113c 23
    ld (hl),d           ;113d 72
    jp l1161h           ;113e c3 61 11
l1141h:
    ld hl,(l02d8h)      ;1141 2a d8 02
    ld de,0fff4h        ;1144 11 f4 ff
    add hl,de           ;1147 19
    ld a,h              ;1148 7c
    or l                ;1149 b5
    jp nz,l115eh        ;114a c2 5e 11
    ld hl,(l02dch)      ;114d 2a dc 02
    add hl,hl           ;1150 29
    ld de,l010eh        ;1151 11 0e 01
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

    call readline       ;1173 cd ca 1b
    ld hl,(rr)          ;1176 2a b2 02
    ld de,0ffb8h        ;1179 11 b8 ff
    add hl,de           ;117c 19
    ld a,h              ;117d 7c
    or l                ;117e b5
    jp nz,l1197h        ;117f c2 97 11
    ld hl,(l02dch)      ;1182 2a dc 02
    add hl,hl           ;1185 29
    ld de,l010eh        ;1186 11 0e 01
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
    ld hl,(l02dch)      ;119a 2a dc 02
    add hl,hl           ;119d 29
    ld de,l010eh        ;119e 11 0e 01
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
    ld hl,(l02dch)      ;11b7 2a dc 02
    add hl,hl           ;11ba 29
    ld de,l010eh        ;11bb 11 0e 01
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
    ld hl,(l02dch)      ;11d9 2a dc 02
    add hl,hl           ;11dc 29
    ld de,l010eh        ;11dd 11 0e 01
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
    ld hl,(l02dch)
    add hl,hl
    ld de,l010eh
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
    ld hl,(l02dch)      ;1228 2a dc 02
    add hl,hl           ;122b 29
    ld de,l010eh        ;122c 11 0e 01
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
    ld hl,(l02dch)      ;1247 2a dc 02
    add hl,hl           ;124a 29
    ld de,l010eh        ;124b 11 0e 01
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
    ld hl,(l02dch)      ;1266 2a dc 02
    add hl,hl           ;1269 29
    ld de,l010eh        ;126a 11 0e 01
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

    ld hl,(l02dch)      ;128e 2a dc 02
    add hl,hl           ;1291 29
    ld de,l0124h        ;1292 11 24 01
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

    ld hl,(l02dch)      ;12a7 2a dc 02
    add hl,hl           ;12aa 29
    ld de,l010eh        ;12ab 11 0e 01
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
    ld hl,(l02dch)      ;12c6 2a dc 02
    add hl,hl           ;12c9 29
    ld de,l010eh        ;12ca 11 0e 01
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
    ld hl,(l02dch)      ;12e5 2a dc 02
    add hl,hl           ;12e8 29
    ld de,l010eh        ;12e9 11 0e 01
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
    ld hl,(l02dch)      ;1304 2a dc 02
    add hl,hl           ;1307 29
    ld de,l010eh        ;1308 11 0e 01
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
    ld hl,(l02dch)      ;1323 2a dc 02
    add hl,hl           ;1326 29
    ld de,l010eh        ;1327 11 0e 01
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
    ld hl,(l02dch)      ;1342 2a dc 02
    add hl,hl           ;1345 29
    ld de,l010eh        ;1346 11 0e 01
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
    call clear_screen   ;1362 cd bd 1b
    ld hl,(013ah)       ;1365 2a 3a 01
    ld a,h              ;1368 7c
    or l                ;1369 b5
    jp nz,l1379h        ;136a c2 79 13

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

    ld hl,(013ah)       ;1382 2a 3a 01
    ld (l02deh),hl      ;1385 22 de 02
    ld hl,0001h         ;1388 21 01 00
    jp l13a7h           ;138b c3 a7 13
l138eh:
    call pr0a           ;138e cd 3d 2d
    ld hl,(l02d0h)      ;1391 2a d0 02
    add hl,hl           ;1394 29
    ld de,013ah         ;1395 11 3a 01
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

    call readline       ;13d1 cd ca 1b
    ld hl,(rr)          ;13d4 2a b2 02
    ld de,0ffa7h        ;13d7 11 a7 ff
    add hl,de           ;13da 19
    ld a,h              ;13db 7c
    or l                ;13dc b5
    jp nz,l05b5h        ;13dd c2 b5 05

    ;PRINT "Please enter the new command : "
    call pr0a
    ld hl,new_command
    call pv2d

    call readline       ;13e9 cd ca 1b
    ld hl,(buf)         ;13ec 2a e0 02
    inc hl              ;13ef 23
    ld l,(hl)           ;13f0 6e
    ld h,00h            ;13f1 26 00
    ld (013ah),hl       ;13f3 22 3a 01
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
    ld de,013ah         ;140d 11 3a 01
    add hl,de           ;1410 19
    pop de              ;1411 d1
    ld (hl),e           ;1412 73
    inc hl              ;1413 23
    ld (hl),d           ;1414 72
    ld hl,(l02d0h)      ;1415 2a d0 02
    add hl,hl           ;1418 29
    ld de,013ah         ;1419 11 3a 01
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
    ld hl,(013ah)       ;146d 2a 3a 01
    add hl,hl           ;1470 29
    ld de,l013ch        ;1471 11 3c 01
    add hl,de           ;1474 19
    ld de,0000h         ;1475 11 00 00
    ld (hl),e           ;1478 73
    inc hl              ;1479 23
    ld (hl),d           ;147a 72
    jp l05b5h           ;147b c3 b5 05
sub_147eh:
    ld hl,(l02d0h)      ;147e 2a d0 02
    add hl,hl           ;1481 29
    ld de,013ah         ;1482 11 3a 01
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
    ld de,l010eh        ;14a4 11 0e 01
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
    ld de,l0124h        ;14bf 11 24 01
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
    ld hl,(mode)        ;1559 2a c0 02
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
    ld de,013ah         ;15c1 11 3a 01
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
    ld (l02dch),hl      ;16a9 22 dc 02
    ld hl,(l02dch)      ;16ac 2a dc 02
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
    ld hl,l02dch        ;1705 21 dc 02
    call cwrite_        ;1708 cd 56 29
    jp l05b5h           ;170b c3 b5 05
l170eh:
    ld hl,l02dch        ;170e 21 dc 02
    call idisk          ;1711 cd 99 29
    ld hl,l02dch        ;1714 21 dc 02
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

    call readline       ;1731 cd ca 1b
    ld hl,(rr)          ;1734 2a b2 02
    ld de,0ffa7h        ;1737 11 a7 ff
    add hl,de           ;173a 19
    ld a,h              ;173b 7c
    or l                ;173c b5
    jp z,l170eh         ;173d ca 0e 17
    jp l05b5h           ;1740 c3 b5 05
l1743h:
    call clear_screen   ;1743 cd bd 1b

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
    ld hl,(termtype)
    ld a,l
    and 7fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0fffeh
    add hl,de
    ld a,h
    or l
    jp nz,l1824h

    ;PRINT "TV912"
    call pr0a
    ld hl,tv912
    call pv2d

    jp l1871h           ;1821 c3 71 18
l1824h:
    ld hl,(termtype)    ;1824 2a c6 02
    ld a,l              ;1827 7d
    and 7fh             ;1828 e6 7f
    ld l,a              ;182a 6f
    ld a,h              ;182b 7c
    and 00h             ;182c e6 00
    ld h,a              ;182e 67
    ld de,0ffffh        ;182f 11 ff ff
    add hl,de           ;1832 19
    ld a,h              ;1833 7c
    or l                ;1834 b5
    jp nz,l1844h        ;1835 c2 44 18

    ;PRINT "HZ1500"
    call pr0a
    ld hl,hz1500
    call pv2d

    jp l1847h           ;1841 c3 47 18
l1844h:
    jp l1871h           ;1844 c3 71 18
l1847h:
    ld hl,(leadin)      ;1847 2a c8 02
    ld de,0ffe5h        ;184a 11 e5 ff
    add hl,de           ;184d 19
    ld a,h              ;184e 7c
    or l                ;184f b5
    jp nz,l185ch        ;1850 c2 5c 18

    ;PRINT "                   (Lead-in = ESCAPE)"
    call pr0a
    ld hl,leadin_esc
    call pv2d

l185ch:
    ld hl,(leadin)      ;185c 2a c8 02
    ld de,0ff82h        ;185f 11 82 ff
    add hl,de           ;1862 19
    ld a,h              ;1863 7c
    or l                ;1864 b5
    jp nz,l1871h        ;1865 c2 71 18

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

    call readline       ;189b cd ca 1b
    ld hl,(rr)          ;189e 2a b2 02
    ld a,h              ;18a1 7c
    or l                ;18a2 b5
    jp z,l05b5h         ;18a3 ca b5 05
    ld hl,(rr)          ;18a6 2a b2 02
    ld de,0ffcfh        ;18a9 11 cf ff
    add hl,de           ;18ac 19
    ld a,h              ;18ad 7c
    or l                ;18ae b5
    jp z,l18eah         ;18af ca ea 18
    ld hl,(rr)          ;18b2 2a b2 02
    ld de,0ffceh        ;18b5 11 ce ff
    add hl,de           ;18b8 19
    ld a,h              ;18b9 7c
    or l                ;18ba b5
    jp nz,l18cfh        ;18bb c2 cf 18
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
    ld hl,(rr)          ;18cf 2a b2 02
    ld de,0ffcdh        ;18d2 11 cd ff
    add hl,de           ;18d5 19
    ld a,h              ;18d6 7c
    or l                ;18d7 b5
    jp z,l194ch         ;18d8 ca 4c 19
    ld hl,(rr)          ;18db 2a b2 02
    ld de,0ffcch        ;18de 11 cc ff
    add hl,de           ;18e1 19
    ld a,h              ;18e2 7c
    or l                ;18e3 b5
    jp z,l192fh         ;18e4 ca 2f 19
    jp l1743h           ;18e7 c3 43 17
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
    ld hl,(l02d8h)      ;1943 2a d8 02
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
    call pr0a           ;1bd8 cd 3d 2d
    ld hl,empty_string  ;1bdb 21 98 28
    call pv2d           ;1bde cd 31 2c

    ld hl,(buf)         ;1be1 2a e0 02
    inc hl              ;1be4 23
    ld l,(hl)           ;1be5 6e
    ld h,00h            ;1be6 26 00
    ld a,h              ;1be8 7c
    or l                ;1be9 b5
    jp nz,l1bf4h        ;1bea c2 f4 1b
    ld hl,0000h         ;1bed 21 00 00
    ld (rr),hl          ;1bf0 22 b2 02
    ret                 ;1bf3 c9
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
    ld (l02d8h),hl      ;1c3a 22 d8 02
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
    ld hl,(l02d8h)      ;1ca3 2a d8 02
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
    ld (l02d8h),hl      ;1cbd 22 d8 02
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
