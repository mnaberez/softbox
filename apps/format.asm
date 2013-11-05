; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --output=format.asm format.com

    org 0100h

    jp l011eh           ;0100 c3 1e 01
    nop                 ;0103 00
    nop                 ;0104 00
    nop                 ;0105 00
    nop                 ;0106 00
    nop                 ;0107 00
    nop                 ;0108 00
    nop                 ;0109 00
l010ah:
    nop                 ;010a 00
    nop                 ;010b 00
l010ch:
    nop                 ;010c 00
    nop                 ;010d 00
l010eh:
    nop                 ;010e 00
    nop                 ;010f 00
l0110h:
    nop                 ;0110 00
    nop                 ;0111 00
l0112h:
    nop                 ;0112 00
    nop                 ;0113 00
l0114h:
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
l011eh:
    ld hl,l0132h        ;011e 21 32 01
    jp l0983h           ;0121 c3 83 09
    push af             ;0124 f5
    inc b               ;0125 04
    nop                 ;0126 00
    nop                 ;0127 00
    rst 30h             ;0128 f7
    inc b               ;0129 04
    inc bc              ;012a 03
    ld bc,l0114h        ;012b 01 14 01
    nop                 ;012e 00
    nop                 ;012f 00
    ld e,01h            ;0130 1e 01
l0132h:
    call sub_0984h      ;0132 cd 84 09
    call sub_0999h      ;0135 cd 99 09
    ld hl,l04f2h        ;0138 21 f2 04
    call sub_0888h      ;013b cd 88 08
    call sub_0999h      ;013e cd 99 09
    ld hl,l04f2h        ;0141 21 f2 04
    call sub_0888h      ;0144 cd 88 08
    call sub_0999h      ;0147 cd 99 09
    ld hl,l04d8h        ;014a 21 d8 04
    call sub_0888h      ;014d cd 88 08
    call sub_0999h      ;0150 cd 99 09
    ld hl,l04c8h        ;0153 21 c8 04
    call sub_0888h      ;0156 cd 88 08
    call sub_0999h      ;0159 cd 99 09
    ld hl,l04b9h        ;015c 21 b9 04
    call sub_0888h      ;015f cd 88 08
l0162h:
    call sub_0999h      ;0162 cd 99 09
    ld hl,l04f2h        ;0165 21 f2 04
    call sub_0888h      ;0168 cd 88 08
    call sub_0999h      ;016b cd 99 09
    ld hl,l049ch        ;016e 21 9c 04
    call sub_0888h      ;0171 cd 88 08
    call sub_0999h      ;0174 cd 99 09
    ld hl,l0479h        ;0177 21 79 04
    call sub_0893h      ;017a cd 93 08
    call sub_02f5h      ;017d cd f5 02
    call sub_0999h      ;0180 cd 99 09
    ld hl,l04f2h        ;0183 21 f2 04
    call sub_0888h      ;0186 cd 88 08
    ld hl,(l010ah)      ;0189 2a 0a 01
    ld a,h              ;018c 7c
    or l                ;018d b5
    jp nz,l0194h        ;018e c2 94 01
    call sub_0980h      ;0191 cd 80 09
l0194h:
    ld de,0ffbfh        ;0194 11 bf ff
    ld hl,(l010ah)      ;0197 2a 0a 01
    add hl,de           ;019a 19
    ld (l010ch),hl      ;019b 22 0c 01
    ld hl,(l010ch)      ;019e 2a 0c 01
    add hl,hl           ;01a1 29
    sbc a,a             ;01a2 9f
    ld h,a              ;01a3 67
    ld l,a              ;01a4 6f
    push hl             ;01a5 e5
    ld hl,(l010ch)      ;01a6 2a 0c 01
    ld de,0fff0h        ;01a9 11 f0 ff
    ld a,h              ;01ac 7c
    rla                 ;01ad 17
    jp c,l01b3h         ;01ae da b3 01
    add hl,de           ;01b1 19
    add hl,hl           ;01b2 29
l01b3h:
    ccf                 ;01b3 3f
    sbc a,a             ;01b4 9f
    ld h,a              ;01b5 67
    ld l,a              ;01b6 6f
    pop de              ;01b7 d1
    ld a,h              ;01b8 7c
    or d                ;01b9 b2
    ld h,a              ;01ba 67
    ld a,l              ;01bb 7d
    or e                ;01bc b3
    ld l,a              ;01bd 6f
    ld a,h              ;01be 7c
    or l                ;01bf b5
    jp z,l01cfh         ;01c0 ca cf 01
    call sub_0999h      ;01c3 cd 99 09
    ld hl,l0461h        ;01c6 21 61 04
    call sub_0888h      ;01c9 cd 88 08
    jp l0162h           ;01cc c3 62 01
l01cfh:
    ld hl,(l010ch)      ;01cf 2a 0c 01
    ld (l010eh),hl      ;01d2 22 0e 01
    ld hl,l010eh        ;01d5 21 0e 01
    call sub_05e7h      ;01d8 cd e7 05
    ld hl,(l010eh)      ;01db 2a 0e 01
    ld de,0ff80h        ;01de 11 80 ff
    ld a,h              ;01e1 7c
    rla                 ;01e2 17
    jp c,l01e8h         ;01e3 da e8 01
    add hl,de           ;01e6 19
    add hl,hl           ;01e7 29
l01e8h:
    jp c,l01f7h         ;01e8 da f7 01
    call sub_0999h      ;01eb cd 99 09
    ld hl,l044bh        ;01ee 21 4b 04
    call sub_0888h      ;01f1 cd 88 08
    jp l0162h           ;01f4 c3 62 01
l01f7h:
    ld hl,(l010eh)      ;01f7 2a 0e 01
    ld de,0fffeh        ;01fa 11 fe ff
    ld a,h              ;01fd 7c
    rla                 ;01fe 17
    jp c,l0204h         ;01ff da 04 02
    add hl,de           ;0202 19
    add hl,hl           ;0203 29
l0204h:
    sbc a,a             ;0204 9f
    ld h,a              ;0205 67
    ld l,a              ;0206 6f
    push hl             ;0207 e5
    ld hl,(l010eh)      ;0208 2a 0e 01
    ld de,0fff6h        ;020b 11 f6 ff
    ld a,h              ;020e 7c
    rla                 ;020f 17
    jp c,l0215h         ;0210 da 15 02
    add hl,de           ;0213 19
    add hl,hl           ;0214 29
l0215h:
    ccf                 ;0215 3f
    sbc a,a             ;0216 9f
    ld h,a              ;0217 67
    ld l,a              ;0218 6f
    pop de              ;0219 d1
    ld a,h              ;021a 7c
    or d                ;021b b2
    ld h,a              ;021c 67
    ld a,l              ;021d 7d
    or e                ;021e b3
    ld l,a              ;021f 6f
    ld a,h              ;0220 7c
    or l                ;0221 b5
    jp nz,l027ch        ;0222 c2 7c 02
    call sub_0999h      ;0225 cd 99 09
    ld hl,0007h         ;0228 21 07 00
    call sub_087bh      ;022b cd 7b 08
    call sub_0893h      ;022e cd 93 08
    ld hl,l0436h        ;0231 21 36 04
    call sub_0893h      ;0234 cd 93 08
    ld hl,(l010ah)      ;0237 2a 0a 01
    call sub_087bh      ;023a cd 7b 08
    call sub_0893h      ;023d cd 93 08
    ld hl,l0423h        ;0240 21 23 04
    call sub_0888h      ;0243 cd 88 08
    call sub_0999h      ;0246 cd 99 09
    ld hl,l0410h        ;0249 21 10 04
    call sub_0893h      ;024c cd 93 08
    call sub_02f5h      ;024f cd f5 02
    ld hl,(l010ah)      ;0252 2a 0a 01
    ld de,0ffa7h        ;0255 11 a7 ff
    add hl,de           ;0258 19
    ld a,h              ;0259 7c
    or l                ;025a b5
    jp z,l0261h         ;025b ca 61 02
    call sub_0980h      ;025e cd 80 09
l0261h:
    call sub_0999h      ;0261 cd 99 09
    ld hl,l04f2h        ;0264 21 f2 04
    call sub_0888h      ;0267 cd 88 08
    call sub_0999h      ;026a cd 99 09
    ld hl,l03f9h        ;026d 21 f9 03
    call sub_0888h      ;0270 cd 88 08
    ld hl,l010ch        ;0273 21 0c 01
    call sub_07a9h      ;0276 cd a9 07
    jp l02c9h           ;0279 c3 c9 02
l027ch:
    call sub_0999h      ;027c cd 99 09
    ld hl,l03e8h        ;027f 21 e8 03
    call sub_0893h      ;0282 cd 93 08
    ld hl,(l010ah)      ;0285 2a 0a 01
    call sub_087bh      ;0288 cd 7b 08
    call sub_0893h      ;028b cd 93 08
    ld hl,l03d1h        ;028e 21 d1 03
    call sub_0888h      ;0291 cd 88 08
    call sub_0999h      ;0294 cd 99 09
    ld hl,l03a6h        ;0297 21 a6 03
    call sub_0893h      ;029a cd 93 08
    call sub_02f5h      ;029d cd f5 02
    ld hl,(l010ah)      ;02a0 2a 0a 01
    ld a,h              ;02a3 7c
    or l                ;02a4 b5
    jp z,l02abh         ;02a5 ca ab 02
    call sub_0980h      ;02a8 cd 80 09
l02abh:
    call sub_0999h      ;02ab cd 99 09
    ld hl,l04f2h        ;02ae 21 f2 04
    call sub_0888h      ;02b1 cd 88 08
    call sub_0999h      ;02b4 cd 99 09
    ld hl,l0396h        ;02b7 21 96 03
    call sub_0888h      ;02ba cd 88 08
    ld hl,l010ch        ;02bd 21 0c 01
    call sub_06e5h      ;02c0 cd e5 06
    ld hl,l0110h        ;02c3 21 10 01
    call sub_05f4h      ;02c6 cd f4 05
l02c9h:
    call sub_0999h      ;02c9 cd 99 09
    ld hl,l04f2h        ;02cc 21 f2 04
    call sub_0888h      ;02cf cd 88 08
    ld hl,(l0110h)      ;02d2 2a 10 01
    ld a,h              ;02d5 7c
    or l                ;02d6 b5
    jp nz,l02e6h        ;02d7 c2 e6 02
    call sub_0999h      ;02da cd 99 09
    ld hl,l0384h        ;02dd 21 84 03
    call sub_0888h      ;02e0 cd 88 08
    jp l0162h           ;02e3 c3 62 01
l02e6h:
    call sub_0999h      ;02e6 cd 99 09
    ld hl,l035fh        ;02e9 21 5f 03
    call sub_0888h      ;02ec cd 88 08
    jp l0162h           ;02ef c3 62 01
    call sub_0980h      ;02f2 cd 80 09
sub_02f5h:
    ld hl,0080h         ;02f5 21 80 00
    ld (l0112h),hl      ;02f8 22 12 01
    ld hl,(l0112h)      ;02fb 2a 12 01
    ld (hl),50h         ;02fe 36 50
    call sub_04f8h      ;0300 cd f8 04
    ld hl,(l0112h)      ;0303 2a 12 01
    inc hl              ;0306 23
    ld l,(hl)           ;0307 6e
    ld h,00h            ;0308 26 00
    ld a,h              ;030a 7c
    or l                ;030b b5
    jp nz,l0318h        ;030c c2 18 03
    ld hl,0000h         ;030f 21 00 00
    ld (l010ah),hl      ;0312 22 0a 01
    jp l0323h           ;0315 c3 23 03
l0318h:
    ld hl,(l0112h)      ;0318 2a 12 01
    inc hl              ;031b 23
    inc hl              ;031c 23
    ld l,(hl)           ;031d 6e
    ld h,00h            ;031e 26 00
    ld (l010ah),hl      ;0320 22 0a 01
l0323h:
    ld hl,(l010ah)      ;0323 2a 0a 01
    ld de,0ff9fh        ;0326 11 9f ff
    ld a,h              ;0329 7c
    rla                 ;032a 17
    jp c,l0330h         ;032b da 30 03
    add hl,de           ;032e 19
    add hl,hl           ;032f 29
l0330h:
    ccf                 ;0330 3f
    sbc a,a             ;0331 9f
    ld h,a              ;0332 67
    ld l,a              ;0333 6f
    push hl             ;0334 e5
    ld hl,(l010ah)      ;0335 2a 0a 01
    ld de,0ff85h        ;0338 11 85 ff
    ld a,h              ;033b 7c
    rla                 ;033c 17
    jp c,l0342h         ;033d da 42 03
    add hl,de           ;0340 19
    add hl,hl           ;0341 29
l0342h:
    sbc a,a             ;0342 9f
    ld h,a              ;0343 67
    ld l,a              ;0344 6f
    pop de              ;0345 d1
    ld a,h              ;0346 7c
    and d               ;0347 a2
    ld h,a              ;0348 67
    ld a,l              ;0349 7d
    and e               ;034a a3
    ld l,a              ;034b 6f
    ld a,h              ;034c 7c
    or l                ;034d b5
    jp z,l035bh         ;034e ca 5b 03
    ld de,0ffe0h        ;0351 11 e0 ff
    ld hl,(l010ah)      ;0354 2a 0a 01
    add hl,de           ;0357 19
    ld (l010ah),hl      ;0358 22 0a 01
l035bh:
    ret                 ;035b c9
    call sub_0980h      ;035c cd 80 09
l035fh:
    db 22h, 62h, 03h
    db "Do not use diskette - try again..."
l0384h:
    db 0fh, 87h, 03h
    db "Format complete"
l0396h:
    db 0dh, 099h, 03h
    db "Formatting..."
l03a6h:
    db 28h, 0a9h, 03h
    db "Press RETURN to continue, ^C to abort : "
l03d1h:
    db 14h, 0d4h, 03h
    db ": is to be formatted"
l03e8h:
    db 0eh, 0ebh, 03h
    db "Disk on drive "
l03f9h:
    db 14h,0fch, 03h
    db "Formatting hard disk"
l0410h:
    db 10h, 13h, 04h
    db "Proceed (Y/N) ? "
l0423h:
    db 10h, 26h, 04h
    db ": will be erased"
l0436h:
    db 12h, 39h, 04h
    db "Data on hard disk "
l044bh:
    db 13h, 4eh, 04h
    db "Drive not in system"
l0461h:
    db 15h, 64h, 04h
    db "Drive doesn't exist !"
l0479h:
    db 20h, 7ch, 04h
    db "(A to P, or RETURN to reboot) ? "
l049ch:
    db 1ah, 9fh, 04h
    db "Format disk on which drive"
l04b9h:
    db 0ch, 0bch, 04h
    db "=== === ===="
l04c8h:
    db 0dh, 0cbh, 04h
    db "For PET CP/M "
l04d8h:
    db 17h, 0dbh, 04h
    db "Disk formatting program"
l04f2h:
    nop                 ;04f2 00
    push af             ;04f3 f5
    inc b               ;04f4 04
    nop                 ;04f5 00
    nop                 ;04f6 00
    nop                 ;04f7 00

; LOADSAVE.REL code below ==================================================

sub_04f8h:
    ld c,0ah            ;04f8 0e 0a
    ld de,0080h         ;04fa 11 80 00
    jp 0005h            ;04fd c3 05 00
    ld bc,1c00h         ;0500 01 00 1c
    ld hl,4000h         ;0503 21 00 40
    ld de,0d400h        ;0506 11 00 d4
    ldir                ;0509 ed b0
    jp 0f075h           ;050b c3 75 f0
    ld a,(hl)           ;050e 7e
    ld (l083ch),a       ;050f 32 3c 08
    call 0f054h         ;0512 cd 54 f0
    ld e,00h            ;0515 1e 00
    push de             ;0517 d5
    call sub_0635h      ;0518 cd 35 06
    ld a,(l083ch)       ;051b 3a 3c 08
    call 0f05ah         ;051e cd 5a f0
    ld (l083dh),a       ;0521 32 3d 08
    ld hl,4000h         ;0524 21 00 40
    ld bc,1c00h         ;0527 01 00 1c
    pop de              ;052a d1
    or a                ;052b b7
    ret nz              ;052c c0
    push de             ;052d d5
    call 0f039h         ;052e cd 39 f0
l0531h:
    call 0f03fh         ;0531 cd 3f f0
    ld (hl),a           ;0534 77
    inc hl              ;0535 23
    dec bc              ;0536 0b
    ld a,b              ;0537 78
    or c                ;0538 b1
    jr nz,l0531h        ;0539 20 f6
    call 0f03ch         ;053b cd 3c f0
    pop de              ;053e d1
    push de             ;053f d5
    call 0f060h         ;0540 cd 60 f0
    pop de              ;0543 d1
    push de             ;0544 d5
    call sub_0647h      ;0545 cd 47 06
    ld a,(l083ch)       ;0548 3a 3c 08
    call 0f05ah         ;054b cd 5a f0
    ld (l083dh),a       ;054e 32 3d 08
    ld hl,6000h         ;0551 21 00 60
    ld bc,0800h         ;0554 01 00 08
    pop de              ;0557 d1
    or a                ;0558 b7
    ret nz              ;0559 c0
    push de             ;055a d5
    call 0f039h         ;055b cd 39 f0
l055eh:
    call 0f03fh         ;055e cd 3f f0
    ld (hl),a           ;0561 77
    inc hl              ;0562 23
    dec bc              ;0563 0b
    ld a,b              ;0564 78
    or c                ;0565 b1
    jr nz,l055eh        ;0566 20 f6
    call 0f03ch         ;0568 cd 3c f0
    pop de              ;056b d1
    call 0f060h         ;056c cd 60 f0
    ld a,(l083ch)       ;056f 3a 3c 08
    call 0f05ah         ;0572 cd 5a f0
    ld (l083dh),a       ;0575 32 3d 08
    ret                 ;0578 c9
    ld c,(hl)           ;0579 4e
    call 0f01bh         ;057a cd 1b f0
    ld de,4000h         ;057d 11 00 40
    ld bc,0000h         ;0580 01 00 00
l0583h:
    call 0f01eh         ;0583 cd 1e f0
    push bc             ;0586 c5
    ld bc,0000h         ;0587 01 00 00
l058ah:
    call 0f021h         ;058a cd 21 f0
    push bc             ;058d c5
    push de             ;058e d5
    call 0f027h         ;058f cd 27 f0
    or a                ;0592 b7
    jr nz,l05e1h        ;0593 20 4c
    pop de              ;0595 d1
    ld bc,0080h         ;0596 01 80 00
    ld hl,0080h         ;0599 21 80 00
    ldir                ;059c ed b0
    pop bc              ;059e c1
    inc c               ;059f 0c
    ld a,c              ;05a0 79
    cp 40h              ;05a1 fe 40
    jr nz,l058ah        ;05a3 20 e5
    pop bc              ;05a5 c1
    inc c               ;05a6 0c
    ld a,c              ;05a7 79
    cp 02h              ;05a8 fe 02
    jr nz,l0583h        ;05aa 20 d7
    ret                 ;05ac c9
    ld c,(hl)           ;05ad 4e
    call 0f01bh         ;05ae cd 1b f0
    ld hl,4000h         ;05b1 21 00 40
    ld bc,0000h         ;05b4 01 00 00
l05b7h:
    call 0f01eh         ;05b7 cd 1e f0
    push bc             ;05ba c5
    ld bc,0000h         ;05bb 01 00 00
l05beh:
    call 0f021h         ;05be cd 21 f0
    push bc             ;05c1 c5
    ld bc,0080h         ;05c2 01 80 00
    ld de,0080h         ;05c5 11 80 00
    ldir                ;05c8 ed b0
    push hl             ;05ca e5
    call 0f02ah         ;05cb cd 2a f0
    or a                ;05ce b7
    jr nz,l05e1h        ;05cf 20 10
    pop hl              ;05d1 e1
    pop bc              ;05d2 c1
    inc c               ;05d3 0c
    ld a,c              ;05d4 79
    cp 40h              ;05d5 fe 40
    jr nz,l05beh        ;05d7 20 e5
    pop bc              ;05d9 c1
    inc c               ;05da 0c
    ld a,c              ;05db 79
    cp 02h              ;05dc fe 02
    jr nz,l05b7h        ;05de 20 d7
    ret                 ;05e0 c9
l05e1h:
    pop hl              ;05e1 e1
    pop hl              ;05e2 e1
    pop hl              ;05e3 e1
    jp l07d1h           ;05e4 c3 d1 07
sub_05e7h:
    ld a,(hl)           ;05e7 7e
    call 0f051h         ;05e8 cd 51 f0
    ld (hl),c           ;05eb 71
    inc hl              ;05ec 23
    ld (hl),00h         ;05ed 36 00
    ret                 ;05ef c9
    ld a,(hl)           ;05f0 7e
    jp 0f078h           ;05f1 c3 78 f0
sub_05f4h:
    ld a,(l083dh)       ;05f4 3a 3d 08
    ld (hl),a           ;05f7 77
    inc hl              ;05f8 23
    xor a               ;05f9 af
    ld (hl),a           ;05fa 77
    ld a,(l083dh)       ;05fb 3a 3d 08
    or a                ;05fe b7
    ret z               ;05ff c8
    ld de,l0622h        ;0600 11 22 06
    ld c,09h            ;0603 0e 09
    call 0005h          ;0605 cd 05 00
    ld hl,0eac0h        ;0608 21 c0 ea
l060bh:
    ld e,(hl)           ;060b 5e
    push hl             ;060c e5
    ld c,02h            ;060d 0e 02
    call 0005h          ;060f cd 05 00
    pop hl              ;0612 e1
    inc hl              ;0613 23
    ld a,(hl)           ;0614 7e
    cp 0dh              ;0615 fe 0d
    jr nz,l060bh        ;0617 20 f2
    ld de,l0632h        ;0619 11 32 06
    ld c,09h            ;061c 0e 09
    call 0005h          ;061e cd 05 00
    ret                 ;0621 c9
l0622h:
    dec c               ;0622 0d
    ld a,(bc)           ;0623 0a
    db "Disk error : $"
l0632h:
    dec c               ;0632 0d
    ld a,(bc)           ;0633 0a
    inc h               ;0634 24
sub_0635h:
    ld c,06h            ;0635 0e 06
    ld hl,l082ah        ;0637 21 2a 08
    ld a,(l083ch)       ;063a 3a 3c 08
    rra                 ;063d 1f
    jp nc,0f05dh        ;063e d2 5d f0
    ld hl,l0830h        ;0641 21 30 08
    jp 0f05dh           ;0644 c3 5d f0
sub_0647h:
    ld c,03h            ;0647 0e 03
    ld hl,l0836h        ;0649 21 36 08
    ld a,(l083ch)       ;064c 3a 3c 08
    rra                 ;064f 1f
    jp nc,0f05dh        ;0650 d2 5d f0
    ld hl,l0839h        ;0653 21 39 08
    jp 0f05dh           ;0656 c3 5d f0
    ld a,(hl)           ;0659 7e
    ld (l083ch),a       ;065a 32 3c 08
    call 0f054h         ;065d cd 54 f0
    push de             ;0660 d5
    ld e,0fh            ;0661 1e 0f
    ld hl,l0821h+1      ;0663 21 22 08
    ld a,(l083ch)       ;0666 3a 3c 08
    rra                 ;0669 1f
    jr nc,l066fh        ;066a 30 03
    ld hl,0826h         ;066c 21 26 08
l066fh:
    ld c,04h            ;066f 0e 04
    call 0f05dh         ;0671 cd 5d f0
    ld a,(l083ch)       ;0674 3a 3c 08
    call 0f05ah         ;0677 cd 5a f0
    ld (l083dh),a       ;067a 32 3d 08
    pop de              ;067d d1
    cp 01h              ;067e fe 01
    ret nz              ;0680 c0
    ld e,01h            ;0681 1e 01
    push de             ;0683 d5
    call sub_0647h      ;0684 cd 47 06
    ld a,(l083ch)       ;0687 3a 3c 08
    call 0f05ah         ;068a cd 5a f0
    ld (l083dh),a       ;068d 32 3d 08
    pop de              ;0690 d1
    or a                ;0691 b7
    ret nz              ;0692 c0
    push de             ;0693 d5
    call 0f033h         ;0694 cd 33 f0
    ld hl,6000h         ;0697 21 00 60
    ld bc,0800h         ;069a 01 00 08
l069dh:
    ld a,(hl)           ;069d 7e
    call 0f042h         ;069e cd 42 f0
    inc hl              ;06a1 23
    dec bc              ;06a2 0b
    ld a,b              ;06a3 78
    or c                ;06a4 b1
    jr nz,l069dh        ;06a5 20 f6
    call 0f036h         ;06a7 cd 36 f0
    pop de              ;06aa d1
    push de             ;06ab d5
    call 0f060h         ;06ac cd 60 f0
    pop de              ;06af d1
    push de             ;06b0 d5
    call sub_0635h      ;06b1 cd 35 06
    ld a,(l083ch)       ;06b4 3a 3c 08
    call 0f05ah         ;06b7 cd 5a f0
    ld (l083dh),a       ;06ba 32 3d 08
    pop de              ;06bd d1
    or a                ;06be b7
    ret nz              ;06bf c0
    push de             ;06c0 d5
    call 0f033h         ;06c1 cd 33 f0
    ld hl,4000h         ;06c4 21 00 40
    ld bc,1c00h         ;06c7 01 00 1c
l06cah:
    ld a,(hl)           ;06ca 7e
    call 0f042h         ;06cb cd 42 f0
    inc hl              ;06ce 23
    dec bc              ;06cf 0b
    ld a,b              ;06d0 78
    or c                ;06d1 b1
    jr nz,l06cah        ;06d2 20 f6
    call 0f036h         ;06d4 cd 36 f0
    pop de              ;06d7 d1
    call 0f060h         ;06d8 cd 60 f0
    ld a,(l083ch)       ;06db 3a 3c 08
    call 0f05ah         ;06de cd 5a f0
    ld (l083dh),a       ;06e1 32 3d 08
    ret                 ;06e4 c9
sub_06e5h:
    ld a,(hl)           ;06e5 7e
    ld (l083ch),a       ;06e6 32 3c 08
    call 0f054h         ;06e9 cd 54 f0
    ld a,(l083ch)       ;06ec 3a 3c 08
    and 01h             ;06ef e6 01
    add a,30h           ;06f1 c6 30
    ld (l07fdh+1),a     ;06f3 32 fe 07
    ld e,0fh            ;06f6 1e 0f
    ld c,14h            ;06f8 0e 14
    ld hl,l07fdh        ;06fa 21 fd 07
    call 0f05dh         ;06fd cd 5d f0
    ld a,(l083ch)       ;0700 3a 3c 08
    call 0f05ah         ;0703 cd 5a f0
    ld (l083dh),a       ;0706 32 3d 08
    or a                ;0709 b7
    ret nz              ;070a c0
    ld a,(l083ch)       ;070b 3a 3c 08
    call 0f078h         ;070e cd 78 f0
    ld hl,4000h         ;0711 21 00 40
    ld de,4001h         ;0714 11 01 40
    ld bc,00ffh         ;0717 01 ff 00
    ld (hl),0e5h        ;071a 36 e5
    ldir                ;071c ed b0
    ld a,07h            ;071e 3e 07
    ld (l0821h),a       ;0720 32 21 08
    ld a,01h            ;0723 3e 01
    ld (l0820h),a       ;0725 32 20 08
l0728h:
    call sub_073eh      ;0728 cd 3e 07
    ld a,(l083ch)       ;072b 3a 3c 08
    call 0f05ah         ;072e cd 5a f0
    ld (l083dh),a       ;0731 32 3d 08
    or a                ;0734 b7
    ret nz              ;0735 c0
    ld hl,l0821h        ;0736 21 21 08
    dec (hl)            ;0739 35
    jp p,l0728h         ;073a f2 28 07
    ret                 ;073d c9
sub_073eh:
    ld hl,l0818h        ;073e 21 18 08
    ld c,06h            ;0741 0e 06
    ld a,(l083ch)       ;0743 3a 3c 08
    call 0f057h         ;0746 cd 57 f0
    call 0f04bh         ;0749 cd 4b f0
    ld a,(4000h)        ;074c 3a 00 40
    call 0f045h         ;074f cd 45 f0
    call 0f036h         ;0752 cd 36 f0
    ld hl,l0811h        ;0755 21 11 08
    ld c,07h            ;0758 0e 07
    ld a,(l083ch)       ;075a 3a 3c 08
    call 0f057h         ;075d cd 57 f0
    call 0f04bh         ;0760 cd 4b f0
    call 0f048h         ;0763 cd 48 f0
    call 0f036h         ;0766 cd 36 f0
    ld a,(l083ch)       ;0769 3a 3c 08
    call 0f054h         ;076c cd 54 f0
    ld e,02h            ;076f 1e 02
    call 0f033h         ;0771 cd 33 f0
    ld hl,4001h         ;0774 21 01 40
    ld c,0ffh           ;0777 0e ff
    call 0f04bh         ;0779 cd 4b f0
    call 0f036h         ;077c cd 36 f0
    ld a,(l083ch)       ;077f 3a 3c 08
    call 0f057h         ;0782 cd 57 f0
    ld hl,l07f8h        ;0785 21 f8 07
    ld c,05h            ;0788 0e 05
    call 0f04bh         ;078a cd 4b f0
    ld a,(l083ch)       ;078d 3a 3c 08
    and 01h             ;0790 e6 01
    add a,30h           ;0792 c6 30
    call 0f042h         ;0794 cd 42 f0
    ld a,(l0820h)       ;0797 3a 20 08
    call 0f04eh         ;079a cd 4e f0
    ld a,(l0821h)       ;079d 3a 21 08
    call 0f04eh         ;07a0 cd 4e f0
    call 0f048h         ;07a3 cd 48 f0
    jp 0f036h           ;07a6 c3 36 f0
sub_07a9h:
    ld c,(hl)           ;07a9 4e
    call 0f01bh         ;07aa cd 1b f0
    ld hl,0080h         ;07ad 21 80 00
l07b0h:
    ld (hl),0e5h        ;07b0 36 e5
    inc l               ;07b2 2c
    jr nz,l07b0h        ;07b3 20 fb
    ld bc,0002h         ;07b5 01 02 00
    call 0f01eh         ;07b8 cd 1e f0
    ld bc,0000h         ;07bb 01 00 00
l07beh:
    push bc             ;07be c5
    call 0f021h         ;07bf cd 21 f0
    call 0f02ah         ;07c2 cd 2a f0
    pop bc              ;07c5 c1
    or a                ;07c6 b7
    jp nz,l07d1h        ;07c7 c2 d1 07
    inc bc              ;07ca 03
    ld a,c              ;07cb 79
    cp 40h              ;07cc fe 40
    jr nz,l07beh        ;07ce 20 ee
    ret                 ;07d0 c9
l07d1h:
    ld de,l07deh        ;07d1 11 de 07
    ld c,09h            ;07d4 0e 09
    call 0005h          ;07d6 cd 05 00
    ld c,01h            ;07d9 0e 01
    jp 0005h            ;07db c3 05 00
l07deh:
    dec c               ;07de 0d
    ld a,(bc)           ;07df 0a
    db "Hit any key to abort : $"
l07f8h:
    db "U2 2 "
l07fdh:
    db "N0:CP/M V2.2 DISK,XX"
l0811h:
    db "B-P 2 1"
l0818h:
    db "M-W",00h,13h,01h
    db "#2"
l0820h:
    ret                 ;0820 c9
l0821h:
    call 3053h          ;0821 cd 53 30
    ld a,(532ah)        ;0824 3a 2a 53
    ld sp,2a3ah         ;0827 31 3a 2a
l082ah:
    jr nc,$+60          ;082a 30 3a
    ld b,e              ;082c 43
    ld d,b              ;082d 50
    cpl                 ;082e 2f
    ld c,l              ;082f 4d
l0830h:
    ld sp,433ah         ;0830 31 3a 43
    ld d,b              ;0833 50
    cpl                 ;0834 2f
    ld c,l              ;0835 4d
l0836h:
    jr nc,$+60          ;0836 30 3a
    ld c,e              ;0838 4b
l0839h:
    ld sp,4b3ah         ;0839 31 3a 4b
l083ch:
    pop hl              ;083c e1
l083dh:
    pop de              ;083d d1
l083eh:
    inc hl              ;083e 23
    ld a,(hl)           ;083f 7e
    dec hl              ;0840 2b
l0841h:
    ret nc              ;0841 d0
l0842h:
    call 203eh          ;0842 cd 3e 20
    call sub_098bh      ;0845 cd 8b 09
    ret                 ;0848 c9
l0849h:
    ld a,0ah            ;0849 3e 0a
    call sub_098bh      ;084b cd 8b 09
    ld a,0dh            ;084e 3e 0d
    call sub_098bh      ;0850 cd 8b 09
    ret                 ;0853 c9
    ld a,02h            ;0854 3e 02
    ld (l083eh),a       ;0856 32 3e 08
    ld a,l              ;0859 7d
    call sub_086bh      ;085a cd 6b 08
    ld (l0841h),a       ;085d 32 41 08
    ld a,l              ;0860 7d
    call sub_086fh      ;0861 cd 6f 08
    ld (l0842h),a       ;0864 32 42 08
    ld hl,l083eh        ;0867 21 3e 08
    ret                 ;086a c9
sub_086bh:
    rrca                ;086b 0f
    rrca                ;086c 0f
    rrca                ;086d 0f
    rrca                ;086e 0f
sub_086fh:
    and 0fh             ;086f e6 0f
    cp 0ah              ;0871 fe 0a
    jp m,l0878h         ;0873 fa 78 08
    add a,07h           ;0876 c6 07
l0878h:
    add a,30h           ;0878 c6 30
    ret                 ;087a c9
sub_087bh:
    ld a,01h            ;087b 3e 01
    ld (l083eh),a       ;087d 32 3e 08
    ld a,l              ;0880 7d
    ld (l0841h),a       ;0881 32 41 08
    ld hl,l083eh        ;0884 21 3e 08
    ret                 ;0887 c9
sub_0888h:
    ld a,(hl)           ;0888 7e
    or a                ;0889 b7
    jp z,l0849h         ;088a ca 49 08
    call sub_08a5h      ;088d cd a5 08
    jp l0849h           ;0890 c3 49 08
sub_0893h:
    ld a,(hl)           ;0893 7e
    or a                ;0894 b7
    ret z               ;0895 c8
    call sub_08a5h      ;0896 cd a5 08
    ret                 ;0899 c9
    ld a,(hl)           ;089a 7e
    or a                ;089b b7
    jp z,l0842h+1       ;089c ca 43 08
    call sub_08a5h      ;089f cd a5 08
    jp l0842h+1         ;08a2 c3 43 08
sub_08a5h:
    ld b,a              ;08a5 47
    inc hl              ;08a6 23
    inc hl              ;08a7 23
    inc hl              ;08a8 23
l08a9h:
    ld a,(hl)           ;08a9 7e
    call sub_098bh      ;08aa cd 8b 09
    dec b               ;08ad 05
    inc hl              ;08ae 23
    jp nz,l08a9h        ;08af c2 a9 08
    ret                 ;08b2 c9
    ld a,(bc)           ;08b3 0a
    ld c,a              ;08b4 4f
    jp 0005h            ;08b5 c3 05 00
    ex de,hl            ;08b8 eb
    pop hl              ;08b9 e1
    ld c,(hl)           ;08ba 4e
    inc hl              ;08bb 23
    ld b,(hl)           ;08bc 46
    jp l08c6h           ;08bd c3 c6 08
    ld b,h              ;08c0 44
    ld c,l              ;08c1 4d
    pop hl              ;08c2 e1
    ld e,(hl)           ;08c3 5e
    inc hl              ;08c4 23
    ld d,(hl)           ;08c5 56
l08c6h:
    inc hl              ;08c6 23
    push hl             ;08c7 e5
    jp l08ceh           ;08c8 c3 ce 08
    ex de,hl            ;08cb eb
    ld b,h              ;08cc 44
    ld c,l              ;08cd 4d
l08ceh:
    ld a,d              ;08ce 7a
    cpl                 ;08cf 2f
    ld d,a              ;08d0 57
    ld a,e              ;08d1 7b
    cpl                 ;08d2 2f
    ld e,a              ;08d3 5f
    inc de              ;08d4 13
    ld hl,0000h         ;08d5 21 00 00
    ld a,11h            ;08d8 3e 11
l08dah:
    push hl             ;08da e5
    add hl,de           ;08db 19
    jp nc,l08e0h        ;08dc d2 e0 08
    ex (sp),hl          ;08df e3
l08e0h:
    pop hl              ;08e0 e1
    push af             ;08e1 f5
    ld a,c              ;08e2 79
    rla                 ;08e3 17
    ld c,a              ;08e4 4f
    ld a,b              ;08e5 78
    rla                 ;08e6 17
    ld b,a              ;08e7 47
    ld a,l              ;08e8 7d
    rla                 ;08e9 17
    ld l,a              ;08ea 6f
    ld a,h              ;08eb 7c
    rla                 ;08ec 17
    ld h,a              ;08ed 67
    pop af              ;08ee f1
    dec a               ;08ef 3d
    jp nz,l08dah        ;08f0 c2 da 08
    ld l,c              ;08f3 69
    ld h,b              ;08f4 60
    ret                 ;08f5 c9
    ld b,h              ;08f6 44
    ld c,l              ;08f7 4d
    pop hl              ;08f8 e1
    ld e,(hl)           ;08f9 5e
    inc hl              ;08fa 23
    ld d,(hl)           ;08fb 56
    inc hl              ;08fc 23
    push hl             ;08fd e5
    ld l,c              ;08fe 69
    ld h,b              ;08ff 60
    ld a,h              ;0900 7c
    or l                ;0901 b5
    ret z               ;0902 c8
    ex de,hl            ;0903 eb
    ld a,h              ;0904 7c
    or l                ;0905 b5
    ret z               ;0906 c8
    ld b,h              ;0907 44
    ld c,l              ;0908 4d
    ld hl,0000h         ;0909 21 00 00
    ld a,10h            ;090c 3e 10
l090eh:
    add hl,hl           ;090e 29
    ex de,hl            ;090f eb
    add hl,hl           ;0910 29
    ex de,hl            ;0911 eb
    jp nc,l0916h        ;0912 d2 16 09
    add hl,bc           ;0915 09
l0916h:
    dec a               ;0916 3d
    jp nz,l090eh        ;0917 c2 0e 09
    ret                 ;091a c9
    call sub_0932h      ;091b cd 32 09
    ld a,20h            ;091e 3e 20
    call sub_098bh      ;0920 cd 8b 09
    ret                 ;0923 c9
    call sub_0932h      ;0924 cd 32 09
    ld a,0ah            ;0927 3e 0a
    call sub_098bh      ;0929 cd 8b 09
    ld a,0dh            ;092c 3e 0d
    call sub_098bh      ;092e cd 8b 09
    ret                 ;0931 c9
sub_0932h:
    push hl             ;0932 e5
    ld a,h              ;0933 7c
    and 80h             ;0934 e6 80
    jp z,l0945h         ;0936 ca 45 09
    ld a,l              ;0939 7d
    cpl                 ;093a 2f
    ld l,a              ;093b 6f
    ld a,h              ;093c 7c
    cpl                 ;093d 2f
    ld h,a              ;093e 67
    inc hl              ;093f 23
    ld a,2dh            ;0940 3e 2d
    call sub_098bh      ;0942 cd 8b 09
l0945h:
    ld c,30h            ;0945 0e 30
    ld de,2710h         ;0947 11 10 27
    call sub_0967h      ;094a cd 67 09
    ld de,l03e8h        ;094d 11 e8 03
    call sub_0967h      ;0950 cd 67 09
    ld de,0064h         ;0953 11 64 00
    call sub_0967h      ;0956 cd 67 09
    ld de,000ah         ;0959 11 0a 00
    call sub_0967h      ;095c cd 67 09
    ld de,0001h         ;095f 11 01 00
    call sub_0967h      ;0962 cd 67 09
    pop hl              ;0965 e1
    ret                 ;0966 c9
sub_0967h:
    call sub_0979h      ;0967 cd 79 09
    jp c,l0971h         ;096a da 71 09
    inc c               ;096d 0c
    jp sub_0967h        ;096e c3 67 09
l0971h:
    ld a,c              ;0971 79
    call sub_098bh      ;0972 cd 8b 09
    add hl,de           ;0975 19
    ld c,30h            ;0976 0e 30
    ret                 ;0978 c9
sub_0979h:
    ld a,l              ;0979 7d
    sub e               ;097a 93
    ld l,a              ;097b 6f
    ld a,h              ;097c 7c
    sbc a,d             ;097d 9a
    ld h,a              ;097e 67
    ret                 ;097f c9
sub_0980h:
    jp 0000h            ;0980 c3 00 00
l0983h:
    jp (hl)             ;0983 e9
sub_0984h:
    ret                 ;0984 c9
    ld hl,0fffeh        ;0985 21 fe ff
    jp l099ah           ;0988 c3 9a 09
sub_098bh:
    push hl             ;098b e5
    push de             ;098c d5
    push bc             ;098d c5
    push af             ;098e f5
    ld c,02h            ;098f 0e 02
    ld e,a              ;0991 5f
    call 0005h          ;0992 cd 05 00
    pop af              ;0995 f1
    pop bc              ;0996 c1
    pop de              ;0997 d1
    pop hl              ;0998 e1
sub_0999h:
    ret                 ;0999 c9
l099ah:
    push de             ;099a d5
    push bc             ;099b c5
    push hl             ;099c e5
    ld c,01h            ;099d 0e 01
    call 0005h          ;099f cd 05 00
    pop hl              ;09a2 e1
    ld (hl),a           ;09a3 77
    inc hl              ;09a4 23
    ld (hl),00h         ;09a5 36 00
    pop bc              ;09a7 c1
    pop de              ;09a8 d1
    ret                 ;09a9 c9
    ld a,(hl)           ;09aa 7e
    jp sub_098bh        ;09ab c3 8b 09
l09aeh:
    cp 04h              ;09ae fe 04
l09b0h:
    jp c,0d33eh         ;09b0 da 3e d3
    ld (l09aeh),a       ;09b3 32 ae 09
    ld a,l              ;09b6 7d
    ld (l09aeh+1),a     ;09b7 32 af 09
    ld a,0c9h           ;09ba 3e c9
    ld (l09b0h),a       ;09bc 32 b0 09
    ld a,e              ;09bf 7b
    jp l09aeh           ;09c0 c3 ae 09
    ld a,0dbh           ;09c3 3e db
    ld (l09aeh),a       ;09c5 32 ae 09
    ld a,l              ;09c8 7d
    ld (l09aeh+1),a     ;09c9 32 af 09
    ld a,0c9h           ;09cc 3e c9
l09ceh:
    ld (l09b0h),a       ;09ce 32 b0 09
    call l09aeh         ;09d1 cd ae 09
l09d4h:
    ld h,00h            ;09d4 26 00
    ld l,a              ;09d6 6f
    ret                 ;09d7 c9
    push af             ;09d8 f5
    ld a,0c0h           ;09d9 3e c0
    jr nc,l09ceh        ;09db 30 f1
    ret                 ;09dd c9
    push af             ;09de f5
    ld a,40h            ;09df 3e 40
    jr nc,l09d4h        ;09e1 30 f1
    ret                 ;09e3 c9
    ei                  ;09e4 fb
    ret                 ;09e5 c9
    di                  ;09e6 f3
    ret                 ;09e7 c9
    ld a,c              ;09e8 79
    add hl,bc           ;09e9 09
    jp c,l0971h         ;09ea da 71 09
    inc c               ;09ed 0c
    jp sub_0967h        ;09ee c3 67 09
    ld a,c              ;09f1 79
    call sub_098bh      ;09f2 cd 8b 09
    add hl,de           ;09f5 19
    ld c,30h            ;09f6 0e 30
    ret                 ;09f8 c9
    ld a,l              ;09f9 7d
    sub e               ;09fa 93
    ld l,a              ;09fb 6f
    ld a,h              ;09fc 7c
    sbc a,d             ;09fd 9a
    ld h,a              ;09fe 67
    ret                 ;09ff c9
