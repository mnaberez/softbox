; z80dasm 1.1.3
; command line: z80dasm --origin=256 --labels --address newsys.com

    org 0100h

    jp l02eeh           ;0100 c3 ee 02
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
    nop                 ;0110 00
    nop                 ;0111 00
    nop                 ;0112 00
    nop                 ;0113 00
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
    jp l2760h+1         ;0139 c3 61 27
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
    call sub_273dh      ;01b3 cd 3d 27
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
    jp l1fc2h           ;01ce c3 c2 1f
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
    call sub_1f5eh      ;020d cd 5e 1f
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
    jp z,2a1bh          ;022a ca 1b 2a
    call 4ea8h          ;022d cd a8 4e
l0230h:
    call 4deah          ;0230 cd ea 4d
    jp l2a27h           ;0233 c3 27 2a
l0236h:
    call 4e7ch          ;0236 cd 7c 4e
    ld hl,12bbh         ;0239 21 bb 12
l023ch:
    call 4d2eh          ;023c cd 2e 4d
    call 4d7dh          ;023f cd 7d 4d
l0242h:
    pop hl              ;0242 e1
    and a               ;0243 a7
l0244h:
    jp nz,2a48h         ;0244 c2 48 2a
    pop af              ;0247 f1
l0248h:
    or 40h              ;0248 f6 40
l024ah:
    push af             ;024a f5
    ld e,l              ;024b 5d
l024ch:
    ld d,h              ;024c 54
    dec de              ;024d 1b
l024eh:
    ld a,l              ;024e 7d
    and e               ;024f a3
l0250h:
    ld e,a              ;0250 5f
    ld a,h              ;0251 7c
l0252h:
    and d               ;0252 a2
    or e                ;0253 b3
l0254h:
    jp nz,2a48h         ;0254 c2 48 2a
    ld b,10h            ;0257 06 10
    dec b               ;0259 05
l025ah:
    add hl,hl           ;025a 29
    jp nc,2a3eh         ;025b d2 3e 2a
l025eh:
    pop af              ;025e f1
    or b                ;025f b0
l0260h:
    or 10h              ;0260 f6 10
l0262h:
    push af             ;0262 f5
    pop af              ;0263 f1
l0264h:
    ret                 ;0264 c9
    pop af              ;0265 f1
l0266h:
    xor a               ;0266 af
    ret                 ;0267 c9
l0268h:
    call 2e71h          ;0268 cd 71 2e
    cp 0e5h             ;026b fe e5
    call z,2730h        ;026d cc 30 27
l0270h:
    jp l232eh           ;0270 c3 2e 23
    ld a,34h            ;0273 3e 34
    call sub_2abah      ;0275 cd ba 2a
l0278h:
    jp 303eh            ;0278 c3 3e 30
    ld de,l1222h        ;027b 11 22 12
l027eh:
    ld a,c              ;027e 79
    push de             ;027f d5
l0280h:
    dec a               ;0280 3d
    jp nz,2a64h         ;0281 c2 64 2a
    call sub_2050h      ;0284 cd 50 20
    inc d               ;0287 14
    call 2f6fh          ;0288 cd 6f 2f
    ret                 ;028b c9
    inc hl              ;028c 23
    ld a,(hl)           ;028d 7e
    dec hl              ;028e 2b
    cp 07h              ;028f fe 07
    jp nz,2a8ch         ;0291 c2 8c 2a
    ld a,b              ;0294 78
    add a,a             ;0295 87
    jp p,2a83h          ;0296 f2 83 2a
    ld a,b              ;0299 78
    or 08h              ;029a f6 08
    ld b,a              ;029c 47
    ret                 ;029d c9
    call sub_2050h      ;029e cd 50 20
    inc b               ;02a1 04
    ld a,05h            ;02a2 3e 05
    call 2bceh          ;02a4 cd ce 2b
    ld a,b              ;02a7 78
    and 08h             ;02a8 e6 08
    jp z,2a9bh          ;02aa ca 9b 2a
    call sub_2050h      ;02ad cd 50 20
l02b0h:
    inc b               ;02b0 04
    ld a,07h            ;02b1 3e 07
    jp 2bceh            ;02b3 c3 ce 2b
l02b6h:
    ld a,b              ;02b6 78
    and 0bfh            ;02b7 e6 bf
    ld b,a              ;02b9 47
l02bah:
    and 20h             ;02ba e6 20
l02bch:
    jp z,l2aa9h         ;02bc ca a9 2a
    ld a,04h            ;02bf 3e 04
    jp 2bceh            ;02c1 c3 ce 2b
l02c4h:
    ld a,b              ;02c4 78
    and 04h             ;02c5 e6 04
    ret z               ;02c7 c8
l02c8h:
    inc hl              ;02c8 23
    ld a,(hl)           ;02c9 7e
l02cah:
    dec hl              ;02ca 2b
    cp 04h              ;02cb fe 04
    ret nz              ;02cd c0
l02ceh:
    ld a,05h            ;02ce 3e 05
l02d0h:
    jp 2bceh            ;02d0 c3 ce 2b
    ld a,58h            ;02d3 3e 58
    ld bc,0007h         ;02d5 01 07 00
l02d8h:
    call sub_2716h      ;02d8 cd 16 27
    ld (hl),e           ;02db 73
l02dch:
    inc hl              ;02dc 23
    ld (hl),d           ;02dd 72
l02deh:
    dec hl              ;02de 2b
    jp l275dh           ;02df c3 5d 27
l02e2h:
    push de             ;02e2 d5
    ld d,a              ;02e3 57
    add a,a             ;02e4 87
    add a,d             ;02e5 82
    ld hl,2adbh         ;02e6 21 db 2a
    call 48beh          ;02e9 cd be 48
    ld e,(hl)           ;02ec 5e
    inc hl              ;02ed 23
l02eeh:
    ld hl,l0302h        ;02ee 21 02 03
    jp l2d27h           ;02f1 c3 27 2d
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
l0302h:
    call sub_2d28h      ;0302 cd 28 2d
    ld hl,0000h         ;0305 21 00 00
    ld (l010ah),hl      ;0308 22 0a 01
    ld hl,0000h         ;030b 21 00 00
    ld (l010ch),hl      ;030e 22 0c 01
    ld hl,l0c00h        ;0311 21 00 0c
    ld (02aeh),hl       ;0314 22 ae 02
    ld hl,6002h         ;0317 21 02 60
    ld (l02b0h),hl      ;031a 22 b0 02
l031dh:
    call sub_1bbdh      ;031d cd bd 1b
    call sub_2d3dh      ;0320 cd 3d 2d
    ld hl,l2898h        ;0323 21 98 28
    call sub_2c31h      ;0326 cd 31 2c
    call sub_2d3dh      ;0329 cd 3d 2d
    ld hl,l2880h        ;032c 21 80 28
    call sub_2c31h      ;032f cd 31 2c
    call sub_2d3dh      ;0332 cd 3d 2d
    ld hl,l2868h        ;0335 21 68 28
    call sub_2c31h      ;0338 cd 31 2c
    call sub_2d3dh      ;033b cd 3d 2d
    ld hl,l2898h        ;033e 21 98 28
    call sub_2c31h      ;0341 cd 31 2c
    ld hl,(l010ah)      ;0344 2a 0a 01
    ld de,0ffffh        ;0347 11 ff ff
    add hl,de           ;034a 19
    ld a,h              ;034b 7c
    or l                ;034c b5
    jp nz,l0359h        ;034d c2 59 03
    call sub_2d3dh      ;0350 cd 3d 2d
    ld hl,l284eh        ;0353 21 4e 28
    call sub_2c31h      ;0356 cd 31 2c
l0359h:
    call sub_2d3dh      ;0359 cd 3d 2d
    ld hl,2829h         ;035c 21 29 28
    call sub_2c31h      ;035f cd 31 2c
    call sub_2d3dh      ;0362 cd 3d 2d
    ld hl,l2898h        ;0365 21 98 28
    call sub_2c31h      ;0368 cd 31 2c
    call sub_2d3dh      ;036b cd 3d 2d
    ld hl,l2898h        ;036e 21 98 28
    call sub_2c31h      ;0371 cd 31 2c
    call sub_2d3dh      ;0374 cd 3d 2d
    ld hl,l280eh        ;0377 21 0e 28
    call sub_2c3ch      ;037a cd 3c 2c
    call sub_1bcah      ;037d cd ca 1b
    ld hl,(02b2h)       ;0380 2a b2 02
    ld a,h              ;0383 7c
    or l                ;0384 b5
    jp z,l0430h         ;0385 ca 30 04
    ld hl,(02b2h)       ;0388 2a b2 02
    ld de,0ffbfh        ;038b 11 bf ff
    ld a,h              ;038e 7c
    rla                 ;038f 17
    jp c,l0395h         ;0390 da 95 03
    add hl,de           ;0393 19
    add hl,hl           ;0394 29
l0395h:
    sbc a,a             ;0395 9f
    ld h,a              ;0396 67
    ld l,a              ;0397 6f
    push hl             ;0398 e5
    ld hl,(02b2h)       ;0399 2a b2 02
    ld de,0ffafh        ;039c 11 af ff
    ld a,h              ;039f 7c
    rla                 ;03a0 17
    jp c,l03a6h         ;03a1 da a6 03
    add hl,de           ;03a4 19
    add hl,hl           ;03a5 29
l03a6h:
    ccf                 ;03a6 3f
    sbc a,a             ;03a7 9f
    ld h,a              ;03a8 67
    ld l,a              ;03a9 6f
    pop de              ;03aa d1
    ld a,h              ;03ab 7c
    or d                ;03ac b2
    ld h,a              ;03ad 67
    ld a,l              ;03ae 7d
    or e                ;03af b3
    ld l,a              ;03b0 6f
    ld a,h              ;03b1 7c
    or l                ;03b2 b5
    jp nz,l031dh        ;03b3 c2 1d 03
    ld de,0ffbfh        ;03b6 11 bf ff
    ld hl,(02b2h)       ;03b9 2a b2 02
    add hl,de           ;03bc 19
    ld (02b2h),hl       ;03bd 22 b2 02
    ld hl,(02b2h)       ;03c0 2a b2 02
    ld (02b4h),hl       ;03c3 22 b4 02
    ld hl,02b4h         ;03c6 21 b4 02
    call sub_2990h      ;03c9 cd 90 29
    ld hl,(02b4h)       ;03cc 2a b4 02
    ld de,0ff7fh        ;03cf 11 7f ff
    ld a,h              ;03d2 7c
    rla                 ;03d3 17
    jp c,l03d9h         ;03d4 da d9 03
    add hl,de           ;03d7 19
    add hl,hl           ;03d8 29
l03d9h:
    jp nc,l031dh        ;03d9 d2 1d 03
    ld hl,(02b4h)       ;03dc 2a b4 02
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
    ld hl,(02b4h)       ;03ee 2a b4 02
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
    ld hl,02b2h         ;040a 21 b2 02
    call sub_2922h      ;040d cd 22 29
    jp l0430h           ;0410 c3 30 04
l0413h:
    ld hl,02b2h         ;0413 21 b2 02
    call sub_2999h      ;0416 cd 99 29
    ld hl,02b2h         ;0419 21 b2 02
    call sub_28b7h      ;041c cd b7 28
    ld hl,l02b6h        ;041f 21 b6 02
    call sub_299dh      ;0422 cd 9d 29
    ld hl,(l02b6h)      ;0425 2a b6 02
    ld a,h              ;0428 7c
    or l                ;0429 b5
    jp z,l0430h         ;042a ca 30 04
    call sub_2d24h      ;042d cd 24 2d
l0430h:
    ld de,38b2h         ;0430 11 b2 38
    ld hl,(02aeh)       ;0433 2a ae 02
    add hl,de           ;0436 19
    ld l,(hl)           ;0437 6e
    ld h,00h            ;0438 26 00
l043ah:
    ld (02b8h),hl       ;043a 22 b8 02
    ld de,4a60h         ;043d 11 60 4a
    ld hl,(02aeh)       ;0440 2a ae 02
    add hl,de           ;0443 19
    ld l,(hl)           ;0444 6e
    ld h,00h            ;0445 26 00
    ld (l010ch),hl      ;0447 22 0c 01
    ld de,4a61h         ;044a 11 61 4a
    ld hl,(02aeh)       ;044d 2a ae 02
    add hl,de           ;0450 19
    ld l,(hl)           ;0451 6e
    ld h,00h            ;0452 26 00
    ld (l02bah),hl      ;0454 22 ba 02
    ld de,4a62h         ;0457 11 62 4a
    ld hl,(02aeh)       ;045a 2a ae 02
    add hl,de           ;045d 19
    ld l,(hl)           ;045e 6e
    ld h,00h            ;045f 26 00
    ld (l02bch),hl      ;0461 22 bc 02
    ld de,4a63h         ;0464 11 63 4a
    ld hl,(02aeh)       ;0467 2a ae 02
    add hl,de           ;046a 19
    ld l,(hl)           ;046b 6e
    ld h,00h            ;046c 26 00
    ld (l02bch+2),hl    ;046e 22 be 02
    ld de,4a64h         ;0471 11 64 4a
    ld hl,(02aeh)       ;0474 2a ae 02
    add hl,de           ;0477 19
    ld l,(hl)           ;0478 6e
    ld h,00h            ;0479 26 00
    ld (02c0h),hl       ;047b 22 c0 02
    ld de,4a65h         ;047e 11 65 4a
    ld hl,(02aeh)       ;0481 2a ae 02
    add hl,de           ;0484 19
    ld l,(hl)           ;0485 6e
    ld h,00h            ;0486 26 00
    ld (02c2h),hl       ;0488 22 c2 02
    ld de,4a66h         ;048b 11 66 4a
    ld hl,(02aeh)       ;048e 2a ae 02
    add hl,de           ;0491 19
    ld l,(hl)           ;0492 6e
    ld h,00h            ;0493 26 00
    ld (l02c4h),hl      ;0495 22 c4 02
    ld de,4a67h         ;0498 11 67 4a
    ld hl,(02aeh)       ;049b 2a ae 02
    add hl,de           ;049e 19
    ld l,(hl)           ;049f 6e
    ld h,00h            ;04a0 26 00
    ld (02c6h),hl       ;04a2 22 c6 02
    ld de,4a68h         ;04a5 11 68 4a
    ld hl,(02aeh)       ;04a8 2a ae 02
    add hl,de           ;04ab 19
    ld l,(hl)           ;04ac 6e
    ld h,00h            ;04ad 26 00
    ld (l02c8h),hl      ;04af 22 c8 02
    ld de,4a69h         ;04b2 11 69 4a
    ld hl,(02aeh)       ;04b5 2a ae 02
    add hl,de           ;04b8 19
    ld l,(hl)           ;04b9 6e
    ld h,00h            ;04ba 26 00
    ld (l02cah),hl      ;04bc 22 ca 02
    ld de,4a6ah         ;04bf 11 6a 4a
    ld hl,(02aeh)       ;04c2 2a ae 02
    add hl,de           ;04c5 19
    ld l,(hl)           ;04c6 6e
    ld h,00h            ;04c7 26 00
    ld (02cch),hl       ;04c9 22 cc 02
    ld de,4a6bh         ;04cc 11 6b 4a
    ld hl,(02aeh)       ;04cf 2a ae 02
    add hl,de           ;04d2 19
    ld l,(hl)           ;04d3 6e
    ld h,00h            ;04d4 26 00
    ld (l02ceh),hl      ;04d6 22 ce 02
    ld hl,0000h         ;04d9 21 00 00
    jp l0517h           ;04dc c3 17 05
l04dfh:
    ld hl,(02aeh)       ;04df 2a ae 02
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
    ld hl,(02aeh)       ;0530 2a ae 02
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
    ld hl,(02aeh)       ;0569 2a ae 02
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
    ld de,022ch         ;057d 11 2c 02
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
    ld hl,(l02b0h)      ;059c 2a b0 02
    inc hl              ;059f 23
    inc hl              ;05a0 23
    inc hl              ;05a1 23
    ld l,(hl)           ;05a2 6e
    ld h,00h            ;05a3 26 00
    ld (l02d0h+2),hl    ;05a5 22 d2 02
    ld de,4a6dh         ;05a8 11 6d 4a
    ld hl,(02aeh)       ;05ab 2a ae 02
    add hl,de           ;05ae 19
    ld l,(hl)           ;05af 6e
    ld h,00h            ;05b0 26 00
    ld (02d4h),hl       ;05b2 22 d4 02
l05b5h:
    call sub_1bbdh      ;05b5 cd bd 1b
    call sub_2d3dh      ;05b8 cd 3d 2d
    ld hl,l2898h        ;05bb 21 98 28
    call sub_2c31h      ;05be cd 31 2c
    call sub_2d3dh      ;05c1 cd 3d 2d
    ld hl,l27f5h        ;05c4 21 f5 27
    call sub_2c31h      ;05c7 cd 31 2c
    call sub_2d3dh      ;05ca cd 3d 2d
    ld hl,l27dch        ;05cd 21 dc 27
    call sub_2c31h      ;05d0 cd 31 2c
    call sub_2d3dh      ;05d3 cd 3d 2d
    ld hl,l2898h        ;05d6 21 98 28
    call sub_2c31h      ;05d9 cd 31 2c
    call sub_2d3dh      ;05dc cd 3d 2d
    ld hl,l27c5h        ;05df 21 c5 27
    call sub_2c31h      ;05e2 cd 31 2c
    call sub_2d3dh      ;05e5 cd 3d 2d
    ld hl,l2898h        ;05e8 21 98 28
    call sub_2c31h      ;05eb cd 31 2c
    call sub_2d3dh      ;05ee cd 3d 2d
    ld hl,l27a9h        ;05f1 21 a9 27
    call sub_2c31h      ;05f4 cd 31 2c
    call sub_2d3dh      ;05f7 cd 3d 2d
    ld hl,l2898h        ;05fa 21 98 28
    call sub_2c31h      ;05fd cd 31 2c
    call sub_2d3dh      ;0600 cd 3d 2d
    ld hl,l2794h        ;0603 21 94 27
    call sub_2c31h      ;0606 cd 31 2c
    call sub_2d3dh      ;0609 cd 3d 2d
    ld hl,l2898h        ;060c 21 98 28
    call sub_2c31h      ;060f cd 31 2c
    call sub_2d3dh      ;0612 cd 3d 2d
    ld hl,l2776h        ;0615 21 76 27
    call sub_2c31h      ;0618 cd 31 2c
    call sub_2d3dh      ;061b cd 3d 2d
    ld hl,l2898h        ;061e 21 98 28
    call sub_2c31h      ;0621 cd 31 2c
    call sub_2d3dh      ;0624 cd 3d 2d
    ld hl,l275ah        ;0627 21 5a 27
    call sub_2c31h      ;062a cd 31 2c
    call sub_2d3dh      ;062d cd 3d 2d
    ld hl,l2898h        ;0630 21 98 28
    call sub_2c31h      ;0633 cd 31 2c
    call sub_2d3dh      ;0636 cd 3d 2d
    ld hl,l2744h        ;0639 21 44 27
    call sub_2c31h      ;063c cd 31 2c
    call sub_2d3dh      ;063f cd 3d 2d
    ld hl,l2898h        ;0642 21 98 28
    call sub_2c31h      ;0645 cd 31 2c
    call sub_2d3dh      ;0648 cd 3d 2d
    ld hl,l272bh        ;064b 21 2b 27
    call sub_2c31h      ;064e cd 31 2c
    call sub_2d3dh      ;0651 cd 3d 2d
    ld hl,l2898h        ;0654 21 98 28
    call sub_2c31h      ;0657 cd 31 2c
    call sub_2d3dh      ;065a cd 3d 2d
    ld hl,2713h         ;065d 21 13 27
    call sub_2c31h      ;0660 cd 31 2c
    call sub_2d3dh      ;0663 cd 3d 2d
    ld hl,l2898h        ;0666 21 98 28
    call sub_2c31h      ;0669 cd 31 2c
    call sub_2d3dh      ;066c cd 3d 2d
    ld hl,l26eah        ;066f 21 ea 26
    call sub_2c3ch      ;0672 cd 3c 2c
    call sub_1bcah      ;0675 cd ca 1b
    ld hl,(02b2h)       ;0678 2a b2 02
    ld de,0ffaeh        ;067b 11 ae ff
    add hl,de           ;067e 19
    ld a,h              ;067f 7c
    or l                ;0680 b5
    jp z,l06deh         ;0681 ca de 06
    ld hl,(02b2h)       ;0684 2a b2 02
    ld de,0ffafh        ;0687 11 af ff
    add hl,de           ;068a 19
    ld a,h              ;068b 7c
    or l                ;068c b5
    jp nz,l0693h        ;068d c2 93 06
    call sub_2d24h      ;0690 cd 24 2d
l0693h:
    ld hl,(02b2h)       ;0693 2a b2 02
    ld de,0ffb7h        ;0696 11 b7 ff
    add hl,de           ;0699 19
    ld a,h              ;069a 7c
    or l                ;069b b5
    jp z,l0a7bh         ;069c ca 7b 0a
    ld hl,(02b2h)       ;069f 2a b2 02
    ld de,0ffbch        ;06a2 11 bc ff
    add hl,de           ;06a5 19
    ld a,h              ;06a6 7c
    or l                ;06a7 b5
    jp z,l0eadh         ;06a8 ca ad 0e
    ld hl,(02b2h)       ;06ab 2a b2 02
    ld de,0ffbfh        ;06ae 11 bf ff
    add hl,de           ;06b1 19
    ld a,h              ;06b2 7c
    or l                ;06b3 b5
    jp z,l1362h         ;06b4 ca 62 13
    ld hl,(02b2h)       ;06b7 2a b2 02
    ld de,0ffbbh        ;06ba 11 bb ff
    add hl,de           ;06bd 19
    ld a,h              ;06be 7c
    or l                ;06bf b5
    jp z,l1494h         ;06c0 ca 94 14
    ld hl,(02b2h)       ;06c3 2a b2 02
    ld de,0ffadh        ;06c6 11 ad ff
    add hl,de           ;06c9 19
    ld a,h              ;06ca 7c
    or l                ;06cb b5
    jp z,l1668h         ;06cc ca 68 16
    ld hl,(02b2h)       ;06cf 2a b2 02
    ld de,0ffb0h        ;06d2 11 b0 ff
    add hl,de           ;06d5 19
    ld a,h              ;06d6 7c
    or l                ;06d7 b5
    jp z,l1743h         ;06d8 ca 43 17
    jp l05b5h           ;06db c3 b5 05
l06deh:
    call sub_1bbdh      ;06de cd bd 1b
    call sub_2d3dh      ;06e1 cd 3d 2d
    ld hl,l26c7h        ;06e4 21 c7 26
    call sub_2c31h      ;06e7 cd 31 2c
    call sub_2d3dh      ;06ea cd 3d 2d
    ld hl,l26a4h        ;06ed 21 a4 26
    call sub_2c31h      ;06f0 cd 31 2c
    call sub_2d3dh      ;06f3 cd 3d 2d
    ld hl,l2898h        ;06f6 21 98 28
    call sub_2c31h      ;06f9 cd 31 2c
    call sub_2d3dh      ;06fc cd 3d 2d
    ld hl,2682h         ;06ff 21 82 26
    call sub_2c3ch      ;0702 cd 3c 2c
    call sub_2d3dh      ;0705 cd 3d 2d
    ld hl,(02c0h)       ;0708 2a c0 02
    ld a,l              ;070b 7d
    and 0ch             ;070c e6 0c
    ld l,a              ;070e 6f
    ld a,h              ;070f 7c
    and 00h             ;0710 e6 00
    ld h,a              ;0712 67
    call sub_2c64h      ;0713 cd 64 2c
    inc b               ;0716 04
    nop                 ;0717 00
    ld de,0035h         ;0718 11 35 00
    add hl,de           ;071b 19
    call sub_2c24h      ;071c cd 24 2c
    call sub_2c31h      ;071f cd 31 2c
    call sub_2d3dh      ;0722 cd 3d 2d
    ld hl,l2898h        ;0725 21 98 28
    call sub_2c31h      ;0728 cd 31 2c
    call sub_2d3dh      ;072b cd 3d 2d
    ld hl,l2660h        ;072e 21 60 26
    call sub_2c3ch      ;0731 cd 3c 2c
    ld hl,(02c0h)       ;0734 2a c0 02
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
    call sub_2d3dh      ;074a cd 3d 2d
    ld hl,l2653h+1      ;074d 21 54 26
    call sub_2c31h      ;0750 cd 31 2c
l0753h:
    ld hl,(02d6h)       ;0753 2a d6 02
    ld de,0ffc0h        ;0756 11 c0 ff
    add hl,de           ;0759 19
    ld a,h              ;075a 7c
    or l                ;075b b5
    jp nz,l0768h        ;075c c2 68 07
    call sub_2d3dh      ;075f cd 3d 2d
    ld hl,l2650h        ;0762 21 50 26
    call sub_2c31h      ;0765 cd 31 2c
l0768h:
    ld hl,(02d6h)       ;0768 2a d6 02
    ld de,0ff80h        ;076b 11 80 ff
    add hl,de           ;076e 19
    ld a,h              ;076f 7c
    or l                ;0770 b5
    jp nz,l077dh        ;0771 c2 7d 07
    call sub_2d3dh      ;0774 cd 3d 2d
    ld hl,l2649h+1      ;0777 21 4a 26
    call sub_2c31h      ;077a cd 31 2c
l077dh:
    ld hl,(02d6h)       ;077d 2a d6 02
    ld de,0ff40h        ;0780 11 40 ff
    add hl,de           ;0783 19
    ld a,h              ;0784 7c
    or l                ;0785 b5
    jp nz,l0792h        ;0786 c2 92 07
    call sub_2d3dh      ;0789 cd 3d 2d
    ld hl,l2646h        ;078c 21 46 26
    call sub_2c31h      ;078f cd 31 2c
l0792h:
    call sub_2d3dh      ;0792 cd 3d 2d
    ld hl,l2898h        ;0795 21 98 28
    call sub_2c31h      ;0798 cd 31 2c
    call sub_2d3dh      ;079b cd 3d 2d
    ld hl,l2624h        ;079e 21 24 26
    call sub_2c3ch      ;07a1 cd 3c 2c
    ld hl,(02c0h)       ;07a4 2a c0 02
    ld a,l              ;07a7 7d
    and 10h             ;07a8 e6 10
    ld l,a              ;07aa 6f
    ld a,h              ;07ab 7c
    and 00h             ;07ac e6 00
    ld h,a              ;07ae 67
    ld a,h              ;07af 7c
    or l                ;07b0 b5
    jp nz,l07bdh        ;07b1 c2 bd 07
    call sub_2d3dh      ;07b4 cd 3d 2d
    ld hl,l261dh        ;07b7 21 1d 26
    call sub_2c31h      ;07ba cd 31 2c
l07bdh:
    ld hl,(02c0h)       ;07bd 2a c0 02
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
    call sub_2d3dh      ;07d1 cd 3d 2d
    ld hl,l2616h        ;07d4 21 16 26
    call sub_2c31h      ;07d7 cd 31 2c
l07dah:
    ld hl,(02c0h)       ;07da 2a c0 02
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
    call sub_2d3dh      ;07ee cd 3d 2d
    ld hl,2610h         ;07f1 21 10 26
    call sub_2c31h      ;07f4 cd 31 2c
l07f7h:
    call sub_2d3dh      ;07f7 cd 3d 2d
    ld hl,l2898h        ;07fa 21 98 28
    call sub_2c31h      ;07fd cd 31 2c
l0800h:
    call sub_2d3dh      ;0800 cd 3d 2d
    ld hl,l25eeh        ;0803 21 ee 25
    call sub_2c3ch      ;0806 cd 3c 2c
    ld hl,(02c2h)       ;0809 2a c2 02
    ld de,0ffdeh        ;080c 11 de ff
    add hl,de           ;080f 19
    ld a,h              ;0810 7c
    or l                ;0811 b5
    jp nz,l081eh        ;0812 c2 1e 08
    call sub_2d3dh      ;0815 cd 3d 2d
    ld hl,l25e8h        ;0818 21 e8 25
    call sub_2c31h      ;081b cd 31 2c
l081eh:
    ld hl,(02c2h)       ;081e 2a c2 02
    ld de,0ffabh        ;0821 11 ab ff
    add hl,de           ;0824 19
    ld a,h              ;0825 7c
    or l                ;0826 b5
    jp nz,l0833h        ;0827 c2 33 08
    call sub_2d3dh      ;082a cd 3d 2d
    ld hl,25e2h         ;082d 21 e2 25
    call sub_2c31h      ;0830 cd 31 2c
l0833h:
    ld hl,(02c2h)       ;0833 2a c2 02
    ld de,0ff89h        ;0836 11 89 ff
    add hl,de           ;0839 19
    ld a,h              ;083a 7c
    or l                ;083b b5
    jp nz,l0848h        ;083c c2 48 08
    call sub_2d3dh      ;083f cd 3d 2d
    ld hl,l25dah+1      ;0842 21 db 25
    call sub_2c31h      ;0845 cd 31 2c
l0848h:
    ld hl,(02c2h)       ;0848 2a c2 02
    ld de,0ff12h        ;084b 11 12 ff
    add hl,de           ;084e 19
    ld a,h              ;084f 7c
    or l                ;0850 b5
    jp nz,l085dh        ;0851 c2 5d 08
    call sub_2d3dh      ;0854 cd 3d 2d
    ld hl,l25d4h        ;0857 21 d4 25
    call sub_2c31h      ;085a cd 31 2c
l085dh:
    ld hl,(02c2h)       ;085d 2a c2 02
    ld de,0ff01h        ;0860 11 01 ff
    add hl,de           ;0863 19
    ld a,h              ;0864 7c
    or l                ;0865 b5
    jp nz,l0872h        ;0866 c2 72 08
    call sub_2d3dh      ;0869 cd 3d 2d
    ld hl,25cch         ;086c 21 cc 25
    call sub_2c31h      ;086f cd 31 2c
l0872h:
    ld hl,(02c2h)       ;0872 2a c2 02
    ld de,0ff34h        ;0875 11 34 ff
    add hl,de           ;0878 19
    ld a,h              ;0879 7c
    or l                ;087a b5
    jp nz,l0887h        ;087b c2 87 08
    call sub_2d3dh      ;087e cd 3d 2d
    ld hl,25c5h         ;0881 21 c5 25
    call sub_2c31h      ;0884 cd 31 2c
l0887h:
    call sub_2d3dh      ;0887 cd 3d 2d
    ld hl,l2898h        ;088a 21 98 28
    call sub_2c31h      ;088d cd 31 2c
    call sub_2d3dh      ;0890 cd 3d 2d
    ld hl,259fh         ;0893 21 9f 25
    call sub_2c3ch      ;0896 cd 3c 2c
    call sub_1bcah      ;0899 cd ca 1b
    ld hl,(02b2h)       ;089c 2a b2 02
    ld de,0ffcfh        ;089f 11 cf ff
    add hl,de           ;08a2 19
    ld a,h              ;08a3 7c
    or l                ;08a4 b5
    jp z,l08d7h         ;08a5 ca d7 08
    ld hl,(02b2h)       ;08a8 2a b2 02
    ld a,h              ;08ab 7c
    or l                ;08ac b5
    jp z,l05b5h         ;08ad ca b5 05
    ld hl,(02b2h)       ;08b0 2a b2 02
    ld de,0ffceh        ;08b3 11 ce ff
    add hl,de           ;08b6 19
    ld a,h              ;08b7 7c
    or l                ;08b8 b5
    jp z,l0930h         ;08b9 ca 30 09
    ld hl,(02b2h)       ;08bc 2a b2 02
    ld de,0ffcdh        ;08bf 11 cd ff
    add hl,de           ;08c2 19
    ld a,h              ;08c3 7c
    or l                ;08c4 b5
    jp z,l0983h         ;08c5 ca 83 09
    ld hl,(02b2h)       ;08c8 2a b2 02
    ld de,0ffcch        ;08cb 11 cc ff
    add hl,de           ;08ce 19
    ld a,h              ;08cf 7c
    or l                ;08d0 b5
    jp z,l09e8h         ;08d1 ca e8 09
    jp l06deh           ;08d4 c3 de 06
l08d7h:
    call sub_2d3dh      ;08d7 cd 3d 2d
    ld hl,257ch         ;08da 21 7c 25
    call sub_2c3ch      ;08dd cd 3c 2c
    call sub_1bcah      ;08e0 cd ca 1b
    ld de,0ffcbh        ;08e3 11 cb ff
    ld hl,(02b2h)       ;08e6 2a b2 02
    add hl,de           ;08e9 19
    ld (02b2h),hl       ;08ea 22 b2 02
    ld hl,(02b2h)       ;08ed 2a b2 02
    add hl,hl           ;08f0 29
    ccf                 ;08f1 3f
    sbc a,a             ;08f2 9f
    ld h,a              ;08f3 67
    ld l,a              ;08f4 6f
    push hl             ;08f5 e5
    ld hl,(02b2h)       ;08f6 2a b2 02
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
    ld hl,(02c0h)       ;0912 2a c0 02
    ld a,l              ;0915 7d
    and 0f3h            ;0916 e6 f3
    ld l,a              ;0918 6f
    ld a,h              ;0919 7c
    and 00h             ;091a e6 00
    ld h,a              ;091c 67
    push hl             ;091d e5
    ld hl,(02b2h)       ;091e 2a b2 02
    add hl,hl           ;0921 29
    add hl,hl           ;0922 29
    pop de              ;0923 d1
    ld a,h              ;0924 7c
    or d                ;0925 b2
    ld h,a              ;0926 67
    ld a,l              ;0927 7d
    or e                ;0928 b3
    ld l,a              ;0929 6f
    ld (02c0h),hl       ;092a 22 c0 02
l092dh:
    jp l06deh           ;092d c3 de 06
l0930h:
    call sub_2d3dh      ;0930 cd 3d 2d
    ld hl,2559h         ;0933 21 59 25
    call sub_2c3ch      ;0936 cd 3c 2c
    call sub_1bcah      ;0939 cd ca 1b
    ld hl,(02b2h)       ;093c 2a b2 02
    ld de,0ffcfh        ;093f 11 cf ff
    add hl,de           ;0942 19
    ld a,h              ;0943 7c
    or l                ;0944 b5
    jp nz,l095eh        ;0945 c2 5e 09
    ld hl,(02c0h)       ;0948 2a c0 02
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
    ld (02c0h),hl       ;095b 22 c0 02
l095eh:
    ld hl,(02b2h)       ;095e 2a b2 02
    ld de,0ffceh        ;0961 11 ce ff
    add hl,de           ;0964 19
    ld a,h              ;0965 7c
    or l                ;0966 b5
    jp nz,l0980h        ;0967 c2 80 09
    ld hl,(02c0h)       ;096a 2a c0 02
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
    ld (02c0h),hl       ;097d 22 c0 02
l0980h:
    jp l06deh           ;0980 c3 de 06
l0983h:
    call sub_2d3dh      ;0983 cd 3d 2d
    ld hl,l2537h        ;0986 21 37 25
    call sub_2c3ch      ;0989 cd 3c 2c
    call sub_1bcah      ;098c cd ca 1b
    ld hl,(02b2h)       ;098f 2a b2 02
    ld de,0ffb1h        ;0992 11 b1 ff
    add hl,de           ;0995 19
    ld a,h              ;0996 7c
    or l                ;0997 b5
    jp nz,l09b1h        ;0998 c2 b1 09
    ld hl,(02c0h)       ;099b 2a c0 02
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
    ld (02c0h),hl       ;09ae 22 c0 02
l09b1h:
    ld hl,(02b2h)       ;09b1 2a b2 02
    ld de,0ffbbh        ;09b4 11 bb ff
    add hl,de           ;09b7 19
    ld a,h              ;09b8 7c
    or l                ;09b9 b5
    jp nz,l09cbh        ;09ba c2 cb 09
    ld hl,(02c0h)       ;09bd 2a c0 02
    ld a,l              ;09c0 7d
    or 30h              ;09c1 f6 30
    ld l,a              ;09c3 6f
    ld a,h              ;09c4 7c
    or 00h              ;09c5 f6 00
    ld h,a              ;09c7 67
    ld (02c0h),hl       ;09c8 22 c0 02
l09cbh:
    ld hl,(02b2h)       ;09cb 2a b2 02
    ld de,0ffb2h        ;09ce 11 b2 ff
    add hl,de           ;09d1 19
    ld a,h              ;09d2 7c
    or l                ;09d3 b5
    jp nz,l09e5h        ;09d4 c2 e5 09
    ld hl,(02c0h)       ;09d7 2a c0 02
    ld a,l              ;09da 7d
    and 0efh            ;09db e6 ef
    ld l,a              ;09dd 6f
    ld a,h              ;09de 7c
    and 00h             ;09df e6 00
    ld h,a              ;09e1 67
    ld (02c0h),hl       ;09e2 22 c0 02
l09e5h:
    jp l06deh           ;09e5 c3 de 06
l09e8h:
    call sub_2d3dh      ;09e8 cd 3d 2d
    ld hl,l2898h        ;09eb 21 98 28
    call sub_2c31h      ;09ee cd 31 2c
    call sub_2d3dh      ;09f1 cd 3d 2d
    ld hl,2517h         ;09f4 21 17 25
    call sub_2c31h      ;09f7 cd 31 2c
    call sub_2d3dh      ;09fa cd 3d 2d
    ld hl,l2507h        ;09fd 21 07 25
    call sub_2c3ch      ;0a00 cd 3c 2c
    call sub_1bcah      ;0a03 cd ca 1b
    ld hl,(l02d8h)      ;0a06 2a d8 02
    ld de,0ff92h        ;0a09 11 92 ff
    add hl,de           ;0a0c 19
    ld a,h              ;0a0d 7c
    or l                ;0a0e b5
    jp nz,l0a1bh        ;0a0f c2 1b 0a
    ld hl,0022h         ;0a12 21 22 00
    ld (02c2h),hl       ;0a15 22 c2 02
    jp l0a2dh           ;0a18 c3 2d 0a
l0a1bh:
    ld hl,(l02d8h)      ;0a1b 2a d8 02
    ld de,0fed4h        ;0a1e 11 d4 fe
    add hl,de           ;0a21 19
    ld a,h              ;0a22 7c
    or l                ;0a23 b5
    jp nz,l0a2dh        ;0a24 c2 2d 0a
    ld hl,0055h         ;0a27 21 55 00
    ld (02c2h),hl       ;0a2a 22 c2 02
l0a2dh:
    ld hl,(l02d8h)      ;0a2d 2a d8 02
    ld de,0fb50h        ;0a30 11 50 fb
    add hl,de           ;0a33 19
    ld a,h              ;0a34 7c
    or l                ;0a35 b5
    jp nz,l0a42h        ;0a36 c2 42 0a
    ld hl,0077h         ;0a39 21 77 00
    ld (02c2h),hl       ;0a3c 22 c2 02
    jp l0a54h           ;0a3f c3 54 0a
l0a42h:
    ld hl,(l02d8h)      ;0a42 2a d8 02
    ld de,0da80h        ;0a45 11 80 da
    add hl,de           ;0a48 19
    ld a,h              ;0a49 7c
    or l                ;0a4a b5
    jp nz,l0a54h        ;0a4b c2 54 0a
    ld hl,00eeh         ;0a4e 21 ee 00
    ld (02c2h),hl       ;0a51 22 c2 02
l0a54h:
    ld hl,(l02d8h)      ;0a54 2a d8 02
    ld de,0ed40h        ;0a57 11 40 ed
    add hl,de           ;0a5a 19
    ld a,h              ;0a5b 7c
    or l                ;0a5c b5
    jp nz,l0a66h        ;0a5d c2 66 0a
    ld hl,00cch         ;0a60 21 cc 00
    ld (02c2h),hl       ;0a63 22 c2 02
l0a66h:
    ld hl,(l02d8h)      ;0a66 2a d8 02
    ld de,0b500h        ;0a69 11 00 b5
    add hl,de           ;0a6c 19
    ld a,h              ;0a6d 7c
    or l                ;0a6e b5
    jp nz,l0a78h        ;0a6f c2 78 0a
    ld hl,00ffh         ;0a72 21 ff 00
    ld (02c2h),hl       ;0a75 22 c2 02
l0a78h:
    jp l06deh           ;0a78 c3 de 06
l0a7bh:
    call sub_1bbdh      ;0a7b cd bd 1b
    call sub_2d3dh      ;0a7e cd 3d 2d
    ld hl,l24e2h        ;0a81 21 e2 24
    call sub_2c31h      ;0a84 cd 31 2c
    call sub_2d3dh      ;0a87 cd 3d 2d
    ld hl,l24bdh        ;0a8a 21 bd 24
    call sub_2c31h      ;0a8d cd 31 2c
    call sub_2d3dh      ;0a90 cd 3d 2d
    ld hl,l2898h        ;0a93 21 98 28
    call sub_2c31h      ;0a96 cd 31 2c
    call sub_2d3dh      ;0a99 cd 3d 2d
    ld hl,l249ch        ;0a9c 21 9c 24
    call sub_2c3ch      ;0a9f cd 3c 2c
    ld hl,(l02bah)      ;0aa2 2a ba 02
    call sub_2cc8h      ;0aa5 cd c8 2c
    call sub_2d3dh      ;0aa8 cd 3d 2d
    ld hl,l2898h        ;0aab 21 98 28
    call sub_2c31h      ;0aae cd 31 2c
    call sub_2d3dh      ;0ab1 cd 3d 2d
    ld hl,l247ah+1      ;0ab4 21 7b 24
    call sub_2c3ch      ;0ab7 cd 3c 2c
    ld hl,(l02c4h)      ;0aba 2a c4 02
    call sub_2cc8h      ;0abd cd c8 2c
    call sub_2d3dh      ;0ac0 cd 3d 2d
    ld hl,l2898h        ;0ac3 21 98 28
    call sub_2c31h      ;0ac6 cd 31 2c
    call sub_2d3dh      ;0ac9 cd 3d 2d
    ld hl,l245ah        ;0acc 21 5a 24
    call sub_2c3ch      ;0acf cd 3c 2c
    ld hl,(l02bch)      ;0ad2 2a bc 02
    call sub_2cc8h      ;0ad5 cd c8 2c
    call sub_2d3dh      ;0ad8 cd 3d 2d
    ld hl,l2898h        ;0adb 21 98 28
    call sub_2c31h      ;0ade cd 31 2c
    call sub_2d3dh      ;0ae1 cd 3d 2d
    ld hl,2439h         ;0ae4 21 39 24
    call sub_2c3ch      ;0ae7 cd 3c 2c
    ld hl,(l02bch+2)    ;0aea 2a be 02
    call sub_2cc8h      ;0aed cd c8 2c
    call sub_2d3dh      ;0af0 cd 3d 2d
    ld hl,l2898h        ;0af3 21 98 28
    call sub_2c31h      ;0af6 cd 31 2c
    call sub_2d3dh      ;0af9 cd 3d 2d
    ld hl,2418h         ;0afc 21 18 24
    call sub_2c3ch      ;0aff cd 3c 2c
    ld hl,(l010ch)      ;0b02 2a 0c 01
    ld a,l              ;0b05 7d
    and 0c0h            ;0b06 e6 c0
    ld l,a              ;0b08 6f
    ld a,h              ;0b09 7c
    and 00h             ;0b0a e6 00
    ld h,a              ;0b0c 67
    ld a,h              ;0b0d 7c
    or l                ;0b0e b5
    jp nz,l0b1bh        ;0b0f c2 1b 0b
    call sub_2d3dh      ;0b12 cd 3d 2d
    ld hl,2411h         ;0b15 21 11 24
    call sub_2c31h      ;0b18 cd 31 2c
l0b1bh:
    ld hl,(l010ch)      ;0b1b 2a 0c 01
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
    call sub_2d3dh      ;0b2f cd 3d 2d
    ld hl,l2409h+1      ;0b32 21 0a 24
    call sub_2c31h      ;0b35 cd 31 2c
l0b38h:
    ld hl,(l010ch)      ;0b38 2a 0c 01
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
    call sub_2d3dh      ;0b4c cd 3d 2d
    ld hl,l2401h+2      ;0b4f 21 03 24
    call sub_2c31h      ;0b52 cd 31 2c
l0b55h:
    ld hl,(l010ch)      ;0b55 2a 0c 01
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
    call sub_2d3dh      ;0b69 cd 3d 2d
    ld hl,23fch         ;0b6c 21 fc 23
    call sub_2c31h      ;0b6f cd 31 2c
l0b72h:
    call sub_2d3dh      ;0b72 cd 3d 2d
    ld hl,l2898h        ;0b75 21 98 28
    call sub_2c31h      ;0b78 cd 31 2c
    call sub_2d3dh      ;0b7b cd 3d 2d
    ld hl,23dbh         ;0b7e 21 db 23
    call sub_2c3ch      ;0b81 cd 3c 2c
    ld hl,(l010ch)      ;0b84 2a 0c 01
    ld a,l              ;0b87 7d
    and 0ch             ;0b88 e6 0c
    ld l,a              ;0b8a 6f
    ld a,h              ;0b8b 7c
    and 00h             ;0b8c e6 00
    ld h,a              ;0b8e 67
    ld a,h              ;0b8f 7c
    or l                ;0b90 b5
    jp nz,l0ba0h        ;0b91 c2 a0 0b
    call sub_2d3dh      ;0b94 cd 3d 2d
    ld hl,2411h         ;0b97 21 11 24
    call sub_2c31h      ;0b9a cd 31 2c
    jp l0ba9h           ;0b9d c3 a9 0b
l0ba0h:
    call sub_2d3dh      ;0ba0 cd 3d 2d
    ld hl,23d4h         ;0ba3 21 d4 23
    call sub_2c31h      ;0ba6 cd 31 2c
l0ba9h:
    call sub_2d3dh      ;0ba9 cd 3d 2d
    ld hl,l2898h        ;0bac 21 98 28
    call sub_2c31h      ;0baf cd 31 2c
    call sub_2d3dh      ;0bb2 cd 3d 2d
    ld hl,l23b2h+1      ;0bb5 21 b3 23
    call sub_2c3ch      ;0bb8 cd 3c 2c
    ld hl,(l010ch)      ;0bbb 2a 0c 01
    ld a,l              ;0bbe 7d
    and 30h             ;0bbf e6 30
    ld l,a              ;0bc1 6f
    ld a,h              ;0bc2 7c
    and 00h             ;0bc3 e6 00
    ld h,a              ;0bc5 67
    ld a,h              ;0bc6 7c
    or l                ;0bc7 b5
    jp nz,l0bd7h        ;0bc8 c2 d7 0b
    call sub_2d3dh      ;0bcb cd 3d 2d
    ld hl,2411h         ;0bce 21 11 24
    call sub_2c31h      ;0bd1 cd 31 2c
    jp l0be0h           ;0bd4 c3 e0 0b
l0bd7h:
    call sub_2d3dh      ;0bd7 cd 3d 2d
    ld hl,l23ach        ;0bda 21 ac 23
    call sub_2c31h      ;0bdd cd 31 2c
l0be0h:
    call sub_2d3dh      ;0be0 cd 3d 2d
    ld hl,l2898h        ;0be3 21 98 28
    call sub_2c31h      ;0be6 cd 31 2c
    call sub_2d3dh      ;0be9 cd 3d 2d
    ld hl,238bh         ;0bec 21 8b 23
    call sub_2c3ch      ;0bef cd 3c 2c
    ld hl,(02d4h)       ;0bf2 2a d4 02
    ld a,h              ;0bf5 7c
    or l                ;0bf6 b5
    jp nz,l0c03h        ;0bf7 c2 03 0c
    call sub_2d3dh      ;0bfa cd 3d 2d
    ld hl,237fh         ;0bfd 21 7f 23
l0c00h:
    call sub_2c31h      ;0c00 cd 31 2c
l0c03h:
    ld hl,(02d4h)       ;0c03 2a d4 02
    ld de,0ffffh        ;0c06 11 ff ff
    add hl,de           ;0c09 19
    ld a,h              ;0c0a 7c
    or l                ;0c0b b5
    jp nz,l0c18h        ;0c0c c2 18 0c
    call sub_2d3dh      ;0c0f cd 3d 2d
    ld hl,l2371h+2      ;0c12 21 73 23
    call sub_2c31h      ;0c15 cd 31 2c
l0c18h:
    ld hl,(02d4h)       ;0c18 2a d4 02
    ld de,0fffeh        ;0c1b 11 fe ff
    add hl,de           ;0c1e 19
    ld a,h              ;0c1f 7c
    or l                ;0c20 b5
    jp nz,l0c2dh        ;0c21 c2 2d 0c
    call sub_2d3dh      ;0c24 cd 3d 2d
    ld hl,236ch         ;0c27 21 6c 23
    call sub_2c31h      ;0c2a cd 31 2c
l0c2dh:
    call sub_2d3dh      ;0c2d cd 3d 2d
    ld hl,l2898h        ;0c30 21 98 28
    call sub_2c31h      ;0c33 cd 31 2c
    call sub_2d3dh      ;0c36 cd 3d 2d
    ld hl,l2898h        ;0c39 21 98 28
    call sub_2c31h      ;0c3c cd 31 2c
    call sub_2d3dh      ;0c3f cd 3d 2d
    ld hl,2355h         ;0c42 21 55 23
    call sub_2c3ch      ;0c45 cd 3c 2c
    call sub_1bcah      ;0c48 cd ca 1b
    ld hl,(02b2h)       ;0c4b 2a b2 02
    ld a,h              ;0c4e 7c
    or l                ;0c4f b5
    jp z,l05b5h         ;0c50 ca b5 05
    ld hl,(02b2h)       ;0c53 2a b2 02
    ld de,0ffcah        ;0c56 11 ca ff
    add hl,de           ;0c59 19
    ld a,h              ;0c5a 7c
    or l                ;0c5b b5
    jp z,l0da5h         ;0c5c ca a5 0d
    ld hl,(02b2h)       ;0c5f 2a b2 02
    ld de,0ffc9h        ;0c62 11 c9 ff
    add hl,de           ;0c65 19
    ld a,h              ;0c66 7c
    or l                ;0c67 b5
    jp z,l0df0h         ;0c68 ca f0 0d
    ld hl,(02b2h)       ;0c6b 2a b2 02
    ld de,0ffcbh        ;0c6e 11 cb ff
    add hl,de           ;0c71 19
    ld a,h              ;0c72 7c
    or l                ;0c73 b5
    jp z,l0ce0h         ;0c74 ca e0 0c
    ld hl,(02b2h)       ;0c77 2a b2 02
    ld de,0ffc8h        ;0c7a 11 c8 ff
    add hl,de           ;0c7d 19
    ld a,h              ;0c7e 7c
    or l                ;0c7f b5
    jp z,l0e3bh         ;0c80 ca 3b 0e
    ld hl,(02b2h)       ;0c83 2a b2 02
    ld (l02d8h+2),hl    ;0c86 22 da 02
    call sub_2d3dh      ;0c89 cd 3d 2d
    ld hl,l2343h        ;0c8c 21 43 23
    call sub_2c3ch      ;0c8f cd 3c 2c
    call sub_1bcah      ;0c92 cd ca 1b
    ld hl,(l02d8h+2)    ;0c95 2a da 02
    ld de,0ffcfh        ;0c98 11 cf ff
    add hl,de           ;0c9b 19
    ld a,h              ;0c9c 7c
    or l                ;0c9d b5
    jp nz,l0ca7h        ;0c9e c2 a7 0c
    ld hl,(l02d8h)      ;0ca1 2a d8 02
    ld (l02bah),hl      ;0ca4 22 ba 02
l0ca7h:
    ld hl,(l02d8h+2)    ;0ca7 2a da 02
    ld de,0ffceh        ;0caa 11 ce ff
    add hl,de           ;0cad 19
    ld a,h              ;0cae 7c
    or l                ;0caf b5
    jp nz,l0cb9h        ;0cb0 c2 b9 0c
    ld hl,(l02d8h)      ;0cb3 2a d8 02
    ld (l02c4h),hl      ;0cb6 22 c4 02
l0cb9h:
    ld hl,(l02d8h+2)    ;0cb9 2a da 02
    ld de,0ffcdh        ;0cbc 11 cd ff
    add hl,de           ;0cbf 19
    ld a,h              ;0cc0 7c
    or l                ;0cc1 b5
    jp nz,l0ccbh        ;0cc2 c2 cb 0c
    ld hl,(l02d8h)      ;0cc5 2a d8 02
    ld (l02bch),hl      ;0cc8 22 bc 02
l0ccbh:
    ld hl,(l02d8h+2)    ;0ccb 2a da 02
    ld de,0ffcch        ;0cce 11 cc ff
    add hl,de           ;0cd1 19
    ld a,h              ;0cd2 7c
    or l                ;0cd3 b5
    jp nz,l0cddh        ;0cd4 c2 dd 0c
    ld hl,(l02d8h)      ;0cd7 2a d8 02
    ld (l02bch+2),hl    ;0cda 22 be 02
l0cddh:
    jp l0a7bh           ;0cdd c3 7b 0a
l0ce0h:
    call sub_2d3dh      ;0ce0 cd 3d 2d
    ld hl,l2898h        ;0ce3 21 98 28
    call sub_2c31h      ;0ce6 cd 31 2c
    call sub_2d3dh      ;0ce9 cd 3d 2d
    ld hl,l2328h        ;0cec 21 28 23
    call sub_2c31h      ;0cef cd 31 2c
    call sub_2d3dh      ;0cf2 cd 3d 2d
    ld hl,l2310h        ;0cf5 21 10 23
    call sub_2c31h      ;0cf8 cd 31 2c
    call sub_2d3dh      ;0cfb cd 3d 2d
    ld hl,l22f2h        ;0cfe 21 f2 22
    call sub_2c31h      ;0d01 cd 31 2c
l0d04h:
    call sub_2d3dh      ;0d04 cd 3d 2d
    ld hl,22d2h         ;0d07 21 d2 22
    call sub_2c31h      ;0d0a cd 31 2c
    call sub_2d3dh      ;0d0d cd 3d 2d
    ld hl,l2898h        ;0d10 21 98 28
    call sub_2c31h      ;0d13 cd 31 2c
    call sub_2d3dh      ;0d16 cd 3d 2d
    ld hl,22ach         ;0d19 21 ac 22
    call sub_2c3ch      ;0d1c cd 3c 2c
    call sub_1bcah      ;0d1f cd ca 1b
    ld hl,(02b2h)       ;0d22 2a b2 02
    ld de,0ffach        ;0d25 11 ac ff
    add hl,de           ;0d28 19
    ld a,h              ;0d29 7c
    or l                ;0d2a b5
    jp nz,l0d3ch        ;0d2b c2 3c 0d
    ld hl,(l010ch)      ;0d2e 2a 0c 01
    ld a,l              ;0d31 7d
    and 3fh             ;0d32 e6 3f
    ld l,a              ;0d34 6f
    ld a,h              ;0d35 7c
    and 00h             ;0d36 e6 00
    ld h,a              ;0d38 67
    ld (l010ch),hl      ;0d39 22 0c 01
l0d3ch:
    ld hl,(02b2h)       ;0d3c 2a b2 02
    ld de,0ffbdh        ;0d3f 11 bd ff
    add hl,de           ;0d42 19
    ld a,h              ;0d43 7c
    or l                ;0d44 b5
    jp nz,l0d5eh        ;0d45 c2 5e 0d
    ld hl,(l010ch)      ;0d48 2a 0c 01
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
    ld (l010ch),hl      ;0d5b 22 0c 01
l0d5eh:
    ld hl,(02b2h)       ;0d5e 2a b2 02
    ld de,0ffb4h        ;0d61 11 b4 ff
    add hl,de           ;0d64 19
    ld a,h              ;0d65 7c
    or l                ;0d66 b5
    jp nz,l0d80h        ;0d67 c2 80 0d
    ld hl,(l010ch)      ;0d6a 2a 0c 01
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
    ld (l010ch),hl      ;0d7d 22 0c 01
l0d80h:
    ld hl,(02b2h)       ;0d80 2a b2 02
    ld de,0ffabh        ;0d83 11 ab ff
    add hl,de           ;0d86 19
    ld a,h              ;0d87 7c
    or l                ;0d88 b5
    jp nz,l0da2h        ;0d89 c2 a2 0d
    ld hl,(l010ch)      ;0d8c 2a 0c 01
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
    ld (l010ch),hl      ;0d9f 22 0c 01
l0da2h:
    jp l0a7bh           ;0da2 c3 7b 0a
l0da5h:
    call sub_2d3dh      ;0da5 cd 3d 2d
    ld hl,2296h         ;0da8 21 96 22
    call sub_2c3ch      ;0dab cd 3c 2c
    call sub_1bcah      ;0dae cd ca 1b
    ld hl,(02b2h)       ;0db1 2a b2 02
    ld de,0ffach        ;0db4 11 ac ff
    add hl,de           ;0db7 19
    ld a,h              ;0db8 7c
    or l                ;0db9 b5
    jp nz,l0dcbh        ;0dba c2 cb 0d
    ld hl,(l010ch)      ;0dbd 2a 0c 01
    ld a,l              ;0dc0 7d
    and 0f3h            ;0dc1 e6 f3
    ld l,a              ;0dc3 6f
    ld a,h              ;0dc4 7c
    and 00h             ;0dc5 e6 00
    ld h,a              ;0dc7 67
    ld (l010ch),hl      ;0dc8 22 0c 01
l0dcbh:
    ld hl,(02b2h)       ;0dcb 2a b2 02
    ld de,0ffb0h        ;0dce 11 b0 ff
    add hl,de           ;0dd1 19
    ld a,h              ;0dd2 7c
    or l                ;0dd3 b5
    jp nz,l0dedh        ;0dd4 c2 ed 0d
    ld hl,(l010ch)      ;0dd7 2a 0c 01
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
    ld (l010ch),hl      ;0dea 22 0c 01
l0dedh:
    jp l0a7bh           ;0ded c3 7b 0a
l0df0h:
    call sub_2d3dh      ;0df0 cd 3d 2d
    ld hl,l2280h        ;0df3 21 80 22
    call sub_2c3ch      ;0df6 cd 3c 2c
    call sub_1bcah      ;0df9 cd ca 1b
    ld hl,(02b2h)       ;0dfc 2a b2 02
    ld de,0ffach        ;0dff 11 ac ff
    add hl,de           ;0e02 19
    ld a,h              ;0e03 7c
    or l                ;0e04 b5
    jp nz,l0e16h        ;0e05 c2 16 0e
    ld hl,(l010ch)      ;0e08 2a 0c 01
    ld a,l              ;0e0b 7d
    and 0cfh            ;0e0c e6 cf
    ld l,a              ;0e0e 6f
    ld a,h              ;0e0f 7c
    and 00h             ;0e10 e6 00
    ld h,a              ;0e12 67
    ld (l010ch),hl      ;0e13 22 0c 01
l0e16h:
    ld hl,(02b2h)       ;0e16 2a b2 02
    ld de,0ffb0h        ;0e19 11 b0 ff
    add hl,de           ;0e1c 19
    ld a,h              ;0e1d 7c
    or l                ;0e1e b5
    jp nz,l0e38h        ;0e1f c2 38 0e
    ld hl,(l010ch)      ;0e22 2a 0c 01
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
    ld (l010ch),hl      ;0e35 22 0c 01
l0e38h:
    jp l0a7bh           ;0e38 c3 7b 0a
l0e3bh:
    call sub_2d3dh      ;0e3b cd 3d 2d
    ld hl,l2898h        ;0e3e 21 98 28
    call sub_2c31h      ;0e41 cd 31 2c
    call sub_2d3dh      ;0e44 cd 3d 2d
    ld hl,l2261h        ;0e47 21 61 22
    call sub_2c31h      ;0e4a cd 31 2c
    call sub_2d3dh      ;0e4d cd 3d 2d
    ld hl,l2256h        ;0e50 21 56 22
    call sub_2c31h      ;0e53 cd 31 2c
    call sub_2d3dh      ;0e56 cd 3d 2d
    ld hl,2236h         ;0e59 21 36 22
    call sub_2c31h      ;0e5c cd 31 2c
    call sub_2d3dh      ;0e5f cd 3d 2d
    ld hl,l2898h        ;0e62 21 98 28
    call sub_2c31h      ;0e65 cd 31 2c
    call sub_2d3dh      ;0e68 cd 3d 2d
    ld hl,l220fh        ;0e6b 21 0f 22
    call sub_2c3ch      ;0e6e cd 3c 2c
    call sub_1bcah      ;0e71 cd ca 1b
    ld hl,(02b2h)       ;0e74 2a b2 02
    ld de,0ffcdh        ;0e77 11 cd ff
    add hl,de           ;0e7a 19
    ld a,h              ;0e7b 7c
    or l                ;0e7c b5
    jp nz,l0e86h        ;0e7d c2 86 0e
    ld hl,0000h         ;0e80 21 00 00
    ld (02d4h),hl       ;0e83 22 d4 02
l0e86h:
    ld hl,(02b2h)       ;0e86 2a b2 02
    ld de,0ffc8h        ;0e89 11 c8 ff
    add hl,de           ;0e8c 19
    ld a,h              ;0e8d 7c
    or l                ;0e8e b5
    jp nz,l0e98h        ;0e8f c2 98 0e
    ld hl,0002h         ;0e92 21 02 00
    ld (02d4h),hl       ;0e95 22 d4 02
l0e98h:
    ld hl,(02b2h)       ;0e98 2a b2 02
    ld de,0ffbch        ;0e9b 11 bc ff
    add hl,de           ;0e9e 19
    ld a,h              ;0e9f 7c
    or l                ;0ea0 b5
    jp nz,l0eaah        ;0ea1 c2 aa 0e
    ld hl,0001h         ;0ea4 21 01 00
    ld (02d4h),hl       ;0ea7 22 d4 02
l0eaah:
    jp l0a7bh           ;0eaa c3 7b 0a
l0eadh:
    call sub_1bbdh      ;0ead cd bd 1b
    call sub_2d3dh      ;0eb0 cd 3d 2d
    ld hl,l21ebh        ;0eb3 21 eb 21
    call sub_2c31h      ;0eb6 cd 31 2c
    call sub_2d3dh      ;0eb9 cd 3d 2d
    ld hl,l21c6h+1      ;0ebc 21 c7 21
    call sub_2c31h      ;0ebf cd 31 2c
    call sub_2d3dh      ;0ec2 cd 3d 2d
    ld hl,l2898h        ;0ec5 21 98 28
    call sub_2c31h      ;0ec8 cd 31 2c
    call sub_2d3dh      ;0ecb cd 3d 2d
    ld hl,l21b8h+1      ;0ece 21 b9 21
    call sub_2c3ch      ;0ed1 cd 3c 2c
    ld hl,0000h         ;0ed4 21 00 00
    ld (l02dch),hl      ;0ed7 22 dc 02
    call sub_119ah      ;0eda cd 9a 11
    call sub_2d3dh      ;0edd cd 3d 2d
    ld hl,21abh         ;0ee0 21 ab 21
    call sub_2c3ch      ;0ee3 cd 3c 2c
    ld hl,0001h         ;0ee6 21 01 00
    ld (l02dch),hl      ;0ee9 22 dc 02
    call sub_119ah      ;0eec cd 9a 11
    call sub_2d3dh      ;0eef cd 3d 2d
    ld hl,219dh         ;0ef2 21 9d 21
    call sub_2c3ch      ;0ef5 cd 3c 2c
    ld hl,0002h         ;0ef8 21 02 00
    ld (l02dch),hl      ;0efb 22 dc 02
    call sub_119ah      ;0efe cd 9a 11
    call sub_2d3dh      ;0f01 cd 3d 2d
    ld hl,218fh         ;0f04 21 8f 21
    call sub_2c3ch      ;0f07 cd 3c 2c
    ld hl,0003h         ;0f0a 21 03 00
    ld (l02dch),hl      ;0f0d 22 dc 02
    call sub_119ah      ;0f10 cd 9a 11
    call sub_2d3dh      ;0f13 cd 3d 2d
    ld hl,2181h         ;0f16 21 81 21
    call sub_2c3ch      ;0f19 cd 3c 2c
    ld hl,0004h         ;0f1c 21 04 00
    ld (l02dch),hl      ;0f1f 22 dc 02
    call sub_119ah      ;0f22 cd 9a 11
    call sub_2d3dh      ;0f25 cd 3d 2d
    ld hl,2173h         ;0f28 21 73 21
    call sub_2c3ch      ;0f2b cd 3c 2c
    ld hl,0005h         ;0f2e 21 05 00
    ld (l02dch),hl      ;0f31 22 dc 02
    call sub_119ah      ;0f34 cd 9a 11
    call sub_2d3dh      ;0f37 cd 3d 2d
    ld hl,2165h         ;0f3a 21 65 21
    call sub_2c3ch      ;0f3d cd 3c 2c
    ld hl,0006h         ;0f40 21 06 00
    ld (l02dch),hl      ;0f43 22 dc 02
    call sub_119ah      ;0f46 cd 9a 11
    call sub_2d3dh      ;0f49 cd 3d 2d
    ld hl,2157h         ;0f4c 21 57 21
    call sub_2c3ch      ;0f4f cd 3c 2c
    ld hl,0007h         ;0f52 21 07 00
    ld (l02dch),hl      ;0f55 22 dc 02
    call sub_119ah      ;0f58 cd 9a 11
    call sub_2d3dh      ;0f5b cd 3d 2d
    ld hl,l2898h        ;0f5e 21 98 28
    call sub_2c31h      ;0f61 cd 31 2c
    call sub_2d3dh      ;0f64 cd 3d 2d
    ld hl,2132h         ;0f67 21 32 21
    call sub_2c3ch      ;0f6a cd 3c 2c
    call sub_1bcah      ;0f6d cd ca 1b
    ld hl,(02b2h)       ;0f70 2a b2 02
    ld a,h              ;0f73 7c
    or l                ;0f74 b5
    jp z,l05b5h         ;0f75 ca b5 05
    ld hl,(02b2h)       ;0f78 2a b2 02
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
    ld hl,(02b2h)       ;0f89 2a b2 02
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
    ld hl,(02b2h)       ;0fa9 2a b2 02
    add hl,de           ;0fac 19
    call sub_2c64h      ;0fad cd 64 2c
    ld (bc),a           ;0fb0 02
    nop                 ;0fb1 00
    ld (l02dch),hl      ;0fb2 22 dc 02
    call sub_2d3dh      ;0fb5 cd 3d 2d
    ld hl,l2898h        ;0fb8 21 98 28
    call sub_2c31h      ;0fbb cd 31 2c
    call sub_2d3dh      ;0fbe cd 3d 2d
    ld hl,210ah         ;0fc1 21 0a 21
    call sub_2c3ch      ;0fc4 cd 3c 2c
    call sub_1bcah      ;0fc7 cd ca 1b
    ld hl,(02b2h)       ;0fca 2a b2 02
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
    ld hl,(02b2h)       ;0fe7 2a b2 02
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
    ld hl,(02b2h)       ;1004 2a b2 02
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
    ld hl,(02b2h)       ;1021 2a b2 02
    ld de,0ffb8h        ;1024 11 b8 ff
    add hl,de           ;1027 19
    ld a,h              ;1028 7c
    or l                ;1029 b5
    jp nz,l0eadh        ;102a c2 ad 0e
    ld hl,(l010ah)      ;102d 2a 0a 01
    ld de,0ffffh        ;1030 11 ff ff
    add hl,de           ;1033 19
    ld a,h              ;1034 7c
    or l                ;1035 b5
    jp z,l10fbh         ;1036 ca fb 10
    call sub_2d3dh      ;1039 cd 3d 2d
    ld hl,20edh         ;103c 21 ed 20
    call sub_2c3ch      ;103f cd 3c 2c
    call sub_1bcah      ;1042 cd ca 1b
    ld hl,(02b2h)       ;1045 2a b2 02
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
    ld hl,(02b2h)       ;1062 2a b2 02
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
    ld hl,(02b2h)       ;107f 2a b2 02
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
    call sub_2d3dh      ;109f cd 3d 2d
    ld hl,20d0h         ;10a2 21 d0 20
    call sub_2c3ch      ;10a5 cd 3c 2c
    call sub_1bcah      ;10a8 cd ca 1b
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
    call sub_2d3dh      ;10d2 cd 3d 2d
    ld hl,20abh         ;10d5 21 ab 20
    call sub_2c3ch      ;10d8 cd 3c 2c
    call sub_1bcah      ;10db cd ca 1b
    ld hl,(02b2h)       ;10de 2a b2 02
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
    call sub_2d3dh      ;10fb cd 3d 2d
    ld hl,l208fh        ;10fe 21 8f 20
    call sub_2c3ch      ;1101 cd 3c 2c
    call sub_1bcah      ;1104 cd ca 1b
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
    call sub_2d3dh      ;1161 cd 3d 2d
    ld hl,2065h         ;1164 21 65 20
    call sub_2c31h      ;1167 cd 31 2c
    call sub_2d3dh      ;116a cd 3d 2d
    ld hl,2046h         ;116d 21 46 20
    call sub_2c3ch      ;1170 cd 3c 2c
    call sub_1bcah      ;1173 cd ca 1b
    ld hl,(02b2h)       ;1176 2a b2 02
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
    call sub_2d3dh      ;11ab cd 3d 2d
    ld hl,l2038h        ;11ae 21 38 20
    call sub_2c3ch      ;11b1 cd 3c 2c
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
    call sub_2d3dh      ;11cd cd 3d 2d
    ld hl,l202ah        ;11d0 21 2a 20
    call sub_2c3ch      ;11d3 cd 3c 2c
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
    call sub_2d3dh      ;11f3 cd 3d 2d
    ld hl,l201fh        ;11f6 21 1f 20
    call sub_2c31h      ;11f9 cd 31 2c
    ret                 ;11fc c9
l11fdh:
    ld hl,(l010ah)      ;11fd 2a 0a 01
    ld de,0ffffh        ;1200 11 ff ff
    add hl,de           ;1203 19
    ld a,h              ;1204 7c
    or l                ;1205 b5
    jp z,l129eh         ;1206 ca 9e 12
    ld hl,(l02dch)      ;1209 2a dc 02
    add hl,hl           ;120c 29
    ld de,l010eh        ;120d 11 0e 01
    add hl,de           ;1210 19
    ld e,(hl)           ;1211 5e
    inc hl              ;1212 23
    ld d,(hl)           ;1213 56
    push de             ;1214 d5
    pop hl              ;1215 e1
    ld de,0fffeh        ;1216 11 fe ff
    add hl,de           ;1219 19
    ld a,h              ;121a 7c
    or l                ;121b b5
    jp nz,l1228h        ;121c c2 28 12
    call sub_2d3dh      ;121f cd 3d 2d
l1222h:
    ld hl,l2011h        ;1222 21 11 20
    call sub_2c3ch      ;1225 cd 3c 2c
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
    call sub_2d3dh      ;123e cd 3d 2d
    ld hl,2003h         ;1241 21 03 20
    call sub_2c3ch      ;1244 cd 3c 2c
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
    call sub_2d3dh      ;125d cd 3d 2d
    ld hl,1ff5h         ;1260 21 f5 1f
    call sub_2c3ch      ;1263 cd 3c 2c
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
    call sub_2d3dh      ;127c cd 3d 2d
    ld hl,l1fe7h        ;127f 21 e7 1f
    call sub_2c3ch      ;1282 cd 3c 2c
l1285h:
    call sub_2d3dh      ;1285 cd 3d 2d
    ld hl,l1fd9h        ;1288 21 d9 1f
    call sub_2c43h      ;128b cd 43 2c
    ld hl,(l02dch)      ;128e 2a dc 02
    add hl,hl           ;1291 29
    ld de,l0124h        ;1292 11 24 01
    add hl,de           ;1295 19
    ld e,(hl)           ;1296 5e
    inc hl              ;1297 23
    ld d,(hl)           ;1298 56
    ex de,hl            ;1299 eb
    call sub_2cc8h      ;129a cd c8 2c
    ret                 ;129d c9
l129eh:
    call sub_2d3dh      ;129e cd 3d 2d
    ld hl,1fc8h         ;12a1 21 c8 1f
    call sub_2c3ch      ;12a4 cd 3c 2c
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
    call sub_2d3dh      ;12bd cd 3d 2d
    ld hl,l1fb9h        ;12c0 21 b9 1f
    call sub_2c31h      ;12c3 cd 31 2c
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
    call sub_2d3dh      ;12dc cd 3d 2d
    ld hl,1fafh         ;12df 21 af 1f
    call sub_2c31h      ;12e2 cd 31 2c
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
    call sub_2d3dh      ;12fb cd 3d 2d
    ld hl,l1f9fh        ;12fe 21 9f 1f
    call sub_2c31h      ;1301 cd 31 2c
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
    call sub_2d3dh      ;131a cd 3d 2d
    ld hl,l1f8eh        ;131d 21 8e 1f
    call sub_2c31h      ;1320 cd 31 2c
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
    call sub_2d3dh      ;1339 cd 3d 2d
    ld hl,l1f7dh        ;133c 21 7d 1f
    call sub_2c31h      ;133f cd 31 2c
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
    call sub_2d3dh      ;1358 cd 3d 2d
    ld hl,l1f6ch        ;135b 21 6c 1f
    call sub_2c31h      ;135e cd 31 2c
l1361h:
    ret                 ;1361 c9
l1362h:
    call sub_1bbdh      ;1362 cd bd 1b
    ld hl,(013ah)       ;1365 2a 3a 01
    ld a,h              ;1368 7c
    or l                ;1369 b5
    jp nz,l1379h        ;136a c2 79 13
    call sub_2d3dh      ;136d cd 3d 2d
    ld hl,l1f4eh        ;1370 21 4e 1f
    call sub_2c31h      ;1373 cd 31 2c
    jp l13bfh           ;1376 c3 bf 13
l1379h:
    call sub_2d3dh      ;1379 cd 3d 2d
    ld hl,1f2eh         ;137c 21 2e 1f
    call sub_2c31h      ;137f cd 31 2c
    ld hl,(013ah)       ;1382 2a 3a 01
    ld (l02deh),hl      ;1385 22 de 02
    ld hl,0001h         ;1388 21 01 00
    jp l13a7h           ;138b c3 a7 13
l138eh:
    call sub_2d3dh      ;138e cd 3d 2d
    ld hl,(l02d0h)      ;1391 2a d0 02
    add hl,hl           ;1394 29
    ld de,013ah         ;1395 11 3a 01
    add hl,de           ;1398 19
    ld e,(hl)           ;1399 5e
    inc hl              ;139a 23
    ld d,(hl)           ;139b 56
    ex de,hl            ;139c eb
    call sub_2c24h      ;139d cd 24 2c
    call sub_2c3ch      ;13a0 cd 3c 2c
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
    call sub_2d3dh      ;13bf cd 3d 2d
    ld hl,l2898h        ;13c2 21 98 28
    call sub_2c31h      ;13c5 cd 31 2c
    call sub_2d3dh      ;13c8 cd 3d 2d
    ld hl,1f0eh         ;13cb 21 0e 1f
    call sub_2c3ch      ;13ce cd 3c 2c
    call sub_1bcah      ;13d1 cd ca 1b
    ld hl,(02b2h)       ;13d4 2a b2 02
    ld de,0ffa7h        ;13d7 11 a7 ff
    add hl,de           ;13da 19
    ld a,h              ;13db 7c
    or l                ;13dc b5
    jp nz,l05b5h        ;13dd c2 b5 05
    call sub_2d3dh      ;13e0 cd 3d 2d
    ld hl,1eech         ;13e3 21 ec 1e
    call sub_2c31h      ;13e6 cd 31 2c
    call sub_1bcah      ;13e9 cd ca 1b
    ld hl,(02e0h)       ;13ec 2a e0 02
    inc hl              ;13ef 23
    ld l,(hl)           ;13f0 6e
    ld h,00h            ;13f1 26 00
    ld (013ah),hl       ;13f3 22 3a 01
    ld hl,0001h         ;13f6 21 01 00
    jp l145ah           ;13f9 c3 5a 14
l13fch:
    ld hl,(02e0h)       ;13fc 2a e0 02
    ex de,hl            ;13ff eb
    ld hl,(l02d0h)      ;1400 2a d0 02
    add hl,de           ;1403 19
l1404h:
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
    call sub_28a9h      ;1497 cd a9 28
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
    ld hl,(02aeh)       ;14ad 2a ae 02
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
    ld hl,(02aeh)       ;14c8 2a ae 02
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
    ld hl,(l010ch)      ;1525 2a 0c 01
    ld de,4a60h         ;1528 11 60 4a
    push hl             ;152b e5
    ld hl,(02aeh)       ;152c 2a ae 02
l152fh:
    add hl,de           ;152f 19
    pop de              ;1530 d1
    ld (hl),e           ;1531 73
    ld hl,(l02bah)      ;1532 2a ba 02
    ld de,4a61h         ;1535 11 61 4a
    push hl             ;1538 e5
    ld hl,(02aeh)       ;1539 2a ae 02
    add hl,de           ;153c 19
    pop de              ;153d d1
    ld (hl),e           ;153e 73
    ld hl,(l02bch)      ;153f 2a bc 02
    ld de,4a62h         ;1542 11 62 4a
    push hl             ;1545 e5
    ld hl,(02aeh)       ;1546 2a ae 02
    add hl,de           ;1549 19
    pop de              ;154a d1
    ld (hl),e           ;154b 73
    ld hl,(l02bch+2)    ;154c 2a be 02
    ld de,4a63h         ;154f 11 63 4a
    push hl             ;1552 e5
    ld hl,(02aeh)       ;1553 2a ae 02
    add hl,de           ;1556 19
    pop de              ;1557 d1
    ld (hl),e           ;1558 73
    ld hl,(02c0h)       ;1559 2a c0 02
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
    ld hl,(02aeh)       ;1570 2a ae 02
    add hl,de           ;1573 19
    pop de              ;1574 d1
    ld (hl),e           ;1575 73
    ld hl,(02c2h)       ;1576 2a c2 02
    ld de,4a65h         ;1579 11 65 4a
    push hl             ;157c e5
    ld hl,(02aeh)       ;157d 2a ae 02
    add hl,de           ;1580 19
    pop de              ;1581 d1
    ld (hl),e           ;1582 73
    ld hl,(l02c4h)      ;1583 2a c4 02
    ld de,4a66h         ;1586 11 66 4a
    push hl             ;1589 e5
    ld hl,(02aeh)       ;158a 2a ae 02
    add hl,de           ;158d 19
    pop de              ;158e d1
    ld (hl),e           ;158f 73
    ld hl,(02c6h)       ;1590 2a c6 02
    ld de,4a67h         ;1593 11 67 4a
    push hl             ;1596 e5
    ld hl,(02aeh)       ;1597 2a ae 02
    add hl,de           ;159a 19
    pop de              ;159b d1
    ld (hl),e           ;159c 73
    ld hl,(02d4h)       ;159d 2a d4 02
    ld de,4a6dh         ;15a0 11 6d 4a
    push hl             ;15a3 e5
    ld hl,(02aeh)       ;15a4 2a ae 02
    add hl,de           ;15a7 19
    pop de              ;15a8 d1
    ld (hl),e           ;15a9 73
    ld hl,(02b8h)       ;15aa 2a b8 02
    ld de,38b2h         ;15ad 11 b2 38
    push hl             ;15b0 e5
    ld hl,(02aeh)       ;15b1 2a ae 02
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
    ld hl,(02aeh)       ;15ca 2a ae 02
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
    ld hl,(l02c8h)      ;15ef 2a c8 02
    ld de,4a68h         ;15f2 11 68 4a
    push hl             ;15f5 e5
    ld hl,(02aeh)       ;15f6 2a ae 02
    add hl,de           ;15f9 19
    pop de              ;15fa d1
    ld (hl),e           ;15fb 73
    ld hl,(l02cah)      ;15fc 2a ca 02
    ld de,4a69h         ;15ff 11 69 4a
    push hl             ;1602 e5
    ld hl,(02aeh)       ;1603 2a ae 02
    add hl,de           ;1606 19
    pop de              ;1607 d1
    ld (hl),e           ;1608 73
    ld hl,(02cch)       ;1609 2a cc 02
    ld de,4a6ah         ;160c 11 6a 4a
    push hl             ;160f e5
    ld hl,(02aeh)       ;1610 2a ae 02
    add hl,de           ;1613 19
    pop de              ;1614 d1
    ld (hl),e           ;1615 73
    ld hl,(l02ceh)      ;1616 2a ce 02
    ld de,4a6bh         ;1619 11 6b 4a
    push hl             ;161c e5
    ld hl,(02aeh)       ;161d 2a ae 02
    add hl,de           ;1620 19
    pop de              ;1621 d1
    ld (hl),e           ;1622 73
    ld hl,0000h         ;1623 21 00 00
    jp l1648h           ;1626 c3 48 16
l1629h:
    ld hl,(l02d0h)      ;1629 2a d0 02
    add hl,hl           ;162c 29
    ld de,022ch         ;162d 11 2c 02
    add hl,de           ;1630 19
    ld e,(hl)           ;1631 5e
    inc hl              ;1632 23
    ld d,(hl)           ;1633 56
    ex de,hl            ;1634 eb
    push hl             ;1635 e5
    ld hl,(02aeh)       ;1636 2a ae 02
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
    ld hl,(l02d0h+2)    ;165b 2a d2 02
    push hl             ;165e e5
    ld hl,(l02b0h)      ;165f 2a b0 02
    inc hl              ;1662 23
    inc hl              ;1663 23
    inc hl              ;1664 23
    pop de              ;1665 d1
    ld (hl),e           ;1666 73
    ret                 ;1667 c9
l1668h:
    call sub_2d3dh      ;1668 cd 3d 2d
    ld hl,l1ecah        ;166b 21 ca 1e
    call sub_2c3ch      ;166e cd 3c 2c
    call sub_1bcah      ;1671 cd ca 1b
    ld hl,(02b2h)       ;1674 2a b2 02
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
    ld hl,(02b2h)       ;1685 2a b2 02
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
    ld hl,(02b2h)       ;16a5 2a b2 02
    add hl,de           ;16a8 19
    ld (l02dch),hl      ;16a9 22 dc 02
    ld hl,(l02dch)      ;16ac 2a dc 02
    ld (02b4h),hl       ;16af 22 b4 02
    ld hl,02b4h         ;16b2 21 b4 02
    call sub_2990h      ;16b5 cd 90 29
    ld hl,(02b4h)       ;16b8 2a b4 02
    ld de,0ff80h        ;16bb 11 80 ff
    ld a,h              ;16be 7c
    rla                 ;16bf 17
    jp c,l16c5h         ;16c0 da c5 16
l16c3h:
    add hl,de           ;16c3 19
    add hl,hl           ;16c4 29
l16c5h:
    jp c,l16d4h         ;16c5 da d4 16
    call sub_2d3dh      ;16c8 cd 3d 2d
    ld hl,1eb4h         ;16cb 21 b4 1e
    call sub_2c31h      ;16ce cd 31 2c
    jp l1668h           ;16d1 c3 68 16
l16d4h:
    call sub_149ah      ;16d4 cd 9a 14
    ld hl,(02b4h)       ;16d7 2a b4 02
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
    ld hl,(02b4h)       ;16e9 2a b4 02
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
    call sub_2956h      ;1708 cd 56 29
    jp l05b5h           ;170b c3 b5 05
l170eh:
    ld hl,l02dch        ;170e 21 dc 02
    call sub_2999h      ;1711 cd 99 29
    ld hl,l02dch        ;1714 21 dc 02
    call sub_2a02h      ;1717 cd 02 2a
    ld hl,l02b6h        ;171a 21 b6 02
    call sub_299dh      ;171d cd 9d 29
    ld hl,(l02b6h)      ;1720 2a b6 02
    ld a,h              ;1723 7c
    or l                ;1724 b5
    jp z,l05b5h         ;1725 ca b5 05
    call sub_2d3dh      ;1728 cd 3d 2d
    ld hl,l1ea2h        ;172b 21 a2 1e
    call sub_2c3ch      ;172e cd 3c 2c
    call sub_1bcah      ;1731 cd ca 1b
    ld hl,(02b2h)       ;1734 2a b2 02
    ld de,0ffa7h        ;1737 11 a7 ff
    add hl,de           ;173a 19
    ld a,h              ;173b 7c
    or l                ;173c b5
    jp z,l170eh         ;173d ca 0e 17
    jp l05b5h           ;1740 c3 b5 05
l1743h:
    call sub_1bbdh      ;1743 cd bd 1b
    call sub_2d3dh      ;1746 cd 3d 2d
    ld hl,l1e82h        ;1749 21 82 1e
    call sub_2c31h      ;174c cd 31 2c
    call sub_2d3dh      ;174f cd 3d 2d
    ld hl,1e62h         ;1752 21 62 1e
    call sub_2c31h      ;1755 cd 31 2c
    call sub_2d3dh      ;1758 cd 3d 2d
    ld hl,l2898h        ;175b 21 98 28
    call sub_2c31h      ;175e cd 31 2c
    call sub_2d3dh      ;1761 cd 3d 2d
    ld hl,l1e40h        ;1764 21 40 1e
    call sub_2c3ch      ;1767 cd 3c 2c
    ld hl,(02b8h)       ;176a 2a b8 02
    ld a,h              ;176d 7c
    or l                ;176e b5
    jp nz,l177eh        ;176f c2 7e 17
    call sub_2d3dh      ;1772 cd 3d 2d
    ld hl,l2650h        ;1775 21 50 26
    call sub_2c31h      ;1778 cd 31 2c
    jp l179fh           ;177b c3 9f 17
l177eh:
    ld hl,(02b8h)       ;177e 2a b8 02
    ld de,0ffffh        ;1781 11 ff ff
    add hl,de           ;1784 19
    ld a,h              ;1785 7c
    or l                ;1786 b5
    jp nz,l1796h        ;1787 c2 96 17
    call sub_2d3dh      ;178a cd 3d 2d
    ld hl,l2646h        ;178d 21 46 26
    call sub_2c31h      ;1790 cd 31 2c
    jp l179fh           ;1793 c3 9f 17
l1796h:
    call sub_2d3dh      ;1796 cd 3d 2d
    ld hl,1e3ch         ;1799 21 3c 1e
    call sub_2c31h      ;179c cd 31 2c
l179fh:
    call sub_2d3dh      ;179f cd 3d 2d
    ld hl,l2898h        ;17a2 21 98 28
    call sub_2c31h      ;17a5 cd 31 2c
    call sub_2d3dh      ;17a8 cd 3d 2d
    ld hl,l1e1ah        ;17ab 21 1a 1e
    call sub_2c3ch      ;17ae cd 3c 2c
    ld hl,(02c6h)       ;17b1 2a c6 02
    ld a,l              ;17b4 7d
    and 80h             ;17b5 e6 80
    ld l,a              ;17b7 6f
    ld a,h              ;17b8 7c
    and 00h             ;17b9 e6 00
    ld h,a              ;17bb 67
    ld a,h              ;17bc 7c
    or l                ;17bd b5
    jp z,l17cdh         ;17be ca cd 17
    call sub_2d3dh      ;17c1 cd 3d 2d
    ld hl,l1e14h        ;17c4 21 14 1e
    call sub_2c31h      ;17c7 cd 31 2c
    jp l17d6h           ;17ca c3 d6 17
l17cdh:
    call sub_2d3dh      ;17cd cd 3d 2d
    ld hl,1e0fh         ;17d0 21 0f 1e
    call sub_2c31h      ;17d3 cd 31 2c
l17d6h:
    call sub_2d3dh      ;17d6 cd 3d 2d
    ld hl,l2898h        ;17d9 21 98 28
    call sub_2c31h      ;17dc cd 31 2c
    call sub_2d3dh      ;17df cd 3d 2d
    ld hl,l1dedh        ;17e2 21 ed 1d
    call sub_2c3ch      ;17e5 cd 3c 2c
    ld hl,(02c6h)       ;17e8 2a c6 02
    ld a,l              ;17eb 7d
    and 7fh             ;17ec e6 7f
    ld l,a              ;17ee 6f
    ld a,h              ;17ef 7c
    and 00h             ;17f0 e6 00
    ld h,a              ;17f2 67
    ld a,h              ;17f3 7c
    or l                ;17f4 b5
    jp nz,l1804h        ;17f5 c2 04 18
    call sub_2d3dh      ;17f8 cd 3d 2d
    ld hl,l1de3h+2      ;17fb 21 e5 1d
    call sub_2c31h      ;17fe cd 31 2c
    jp l1871h           ;1801 c3 71 18
l1804h:
    ld hl,(02c6h)       ;1804 2a c6 02
    ld a,l              ;1807 7d
    and 7fh             ;1808 e6 7f
    ld l,a              ;180a 6f
    ld a,h              ;180b 7c
    and 00h             ;180c e6 00
    ld h,a              ;180e 67
    ld de,0fffeh        ;180f 11 fe ff
    add hl,de           ;1812 19
    ld a,h              ;1813 7c
    or l                ;1814 b5
    jp nz,l1824h        ;1815 c2 24 18
    call sub_2d3dh      ;1818 cd 3d 2d
    ld hl,1dddh         ;181b 21 dd 1d
    call sub_2c31h      ;181e cd 31 2c
    jp l1871h           ;1821 c3 71 18
l1824h:
    ld hl,(02c6h)       ;1824 2a c6 02
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
    call sub_2d3dh      ;1838 cd 3d 2d
    ld hl,l1dd4h        ;183b 21 d4 1d
    call sub_2c31h      ;183e cd 31 2c
    jp l1847h           ;1841 c3 47 18
l1844h:
    jp l1871h           ;1844 c3 71 18
l1847h:
    ld hl,(l02c8h)      ;1847 2a c8 02
    ld de,0ffe5h        ;184a 11 e5 ff
    add hl,de           ;184d 19
    ld a,h              ;184e 7c
    or l                ;184f b5
    jp nz,l185ch        ;1850 c2 5c 18
    call sub_2d3dh      ;1853 cd 3d 2d
    ld hl,l1dach        ;1856 21 ac 1d
    call sub_2c31h      ;1859 cd 31 2c
l185ch:
    ld hl,(l02c8h)      ;185c 2a c8 02
    ld de,0ff82h        ;185f 11 82 ff
    add hl,de           ;1862 19
    ld a,h              ;1863 7c
    or l                ;1864 b5
    jp nz,l1871h        ;1865 c2 71 18
    call sub_2d3dh      ;1868 cd 3d 2d
    ld hl,l1d90h+1      ;186b 21 91 1d
    call sub_2c31h      ;186e cd 31 2c
l1871h:
    call sub_2d3dh      ;1871 cd 3d 2d
    ld hl,l2898h        ;1874 21 98 28
    call sub_2c31h      ;1877 cd 31 2c
    call sub_2d3dh      ;187a cd 3d 2d
    ld hl,1d6fh         ;187d 21 6f 1d
    call sub_2c3ch      ;1880 cd 3c 2c
    ld hl,(l02d0h+2)    ;1883 2a d2 02
    call sub_2cc8h      ;1886 cd c8 2c
    call sub_2d3dh      ;1889 cd 3d 2d
    ld hl,l2898h        ;188c 21 98 28
    call sub_2c31h      ;188f cd 31 2c
    call sub_2d3dh      ;1892 cd 3d 2d
    ld hl,l1d57h+1      ;1895 21 58 1d
    call sub_2c3ch      ;1898 cd 3c 2c
    call sub_1bcah      ;189b cd ca 1b
    ld hl,(02b2h)       ;189e 2a b2 02
    ld a,h              ;18a1 7c
    or l                ;18a2 b5
    jp z,l05b5h         ;18a3 ca b5 05
    ld hl,(02b2h)       ;18a6 2a b2 02
    ld de,0ffcfh        ;18a9 11 cf ff
    add hl,de           ;18ac 19
    ld a,h              ;18ad 7c
    or l                ;18ae b5
    jp z,l18eah         ;18af ca ea 18
    ld hl,(02b2h)       ;18b2 2a b2 02
    ld de,0ffceh        ;18b5 11 ce ff
    add hl,de           ;18b8 19
    ld a,h              ;18b9 7c
    or l                ;18ba b5
    jp nz,l18cfh        ;18bb c2 cf 18
    ld hl,(02c6h)       ;18be 2a c6 02
    ld a,l              ;18c1 7d
    xor 80h             ;18c2 ee 80
    ld l,a              ;18c4 6f
    ld a,h              ;18c5 7c
    xor 00h             ;18c6 ee 00
    ld h,a              ;18c8 67
    ld (02c6h),hl       ;18c9 22 c6 02
    jp l1743h           ;18cc c3 43 17
l18cfh:
    ld hl,(02b2h)       ;18cf 2a b2 02
    ld de,0ffcdh        ;18d2 11 cd ff
    add hl,de           ;18d5 19
    ld a,h              ;18d6 7c
    or l                ;18d7 b5
    jp z,l194ch         ;18d8 ca 4c 19
    ld hl,(02b2h)       ;18db 2a b2 02
    ld de,0ffcch        ;18de 11 cc ff
    add hl,de           ;18e1 19
    ld a,h              ;18e2 7c
    or l                ;18e3 b5
    jp z,l192fh         ;18e4 ca 2f 19
    jp l1743h           ;18e7 c3 43 17
l18eah:
    call sub_2d3dh      ;18ea cd 3d 2d
    ld hl,1d35h         ;18ed 21 35 1d
    call sub_2c3ch      ;18f0 cd 3c 2c
    call sub_1bcah      ;18f3 cd ca 1b
    ld hl,(02b2h)       ;18f6 2a b2 02
    ld de,0ffcfh        ;18f9 11 cf ff
    add hl,de           ;18fc 19
    ld a,h              ;18fd 7c
    or l                ;18fe b5
    jp nz,l1908h        ;18ff c2 08 19
    ld hl,0000h         ;1902 21 00 00
    ld (02b8h),hl       ;1905 22 b8 02
l1908h:
    ld hl,(02b2h)       ;1908 2a b2 02
    ld de,0ffceh        ;190b 11 ce ff
    add hl,de           ;190e 19
    ld a,h              ;190f 7c
    or l                ;1910 b5
    jp nz,l191ah        ;1911 c2 1a 19
    ld hl,0001h         ;1914 21 01 00
    ld (02b8h),hl       ;1917 22 b8 02
l191ah:
    ld hl,(02b2h)       ;191a 2a b2 02
    ld de,0ffcch        ;191d 11 cc ff
    add hl,de           ;1920 19
    ld a,h              ;1921 7c
    or l                ;1922 b5
    jp nz,l192ch        ;1923 c2 2c 19
    ld hl,0003h         ;1926 21 03 00
    ld (02b8h),hl       ;1929 22 b8 02
l192ch:
    jp l1743h           ;192c c3 43 17
l192fh:
    call sub_2d3dh      ;192f cd 3d 2d
    ld hl,1d1ch         ;1932 21 1c 1d
    call sub_2c3ch      ;1935 cd 3c 2c
    call sub_1bcah      ;1938 cd ca 1b
    ld hl,(02b2h)       ;193b 2a b2 02
    ld a,h              ;193e 7c
    or l                ;193f b5
    jp z,l1949h         ;1940 ca 49 19
    ld hl,(l02d8h)      ;1943 2a d8 02
    ld (l02d0h+2),hl    ;1946 22 d2 02
l1949h:
    jp l1743h           ;1949 c3 43 17
l194ch:
    call sub_2d3dh      ;194c cd 3d 2d
    ld hl,1cf4h         ;194f 21 f4 1c
    call sub_2c3ch      ;1952 cd 3c 2c
    call sub_1bcah      ;1955 cd ca 1b
    ld hl,(02b2h)       ;1958 2a b2 02
    ld de,0ffbfh        ;195b 11 bf ff
    add hl,de           ;195e 19
    ld a,h              ;195f 7c
    or l                ;1960 b5
    jp nz,l1975h        ;1961 c2 75 19
    ld hl,(02c6h)       ;1964 2a c6 02
    ld a,l              ;1967 7d
    and 80h             ;1968 e6 80
    ld l,a              ;196a 6f
    ld a,h              ;196b 7c
    and 00h             ;196c e6 00
    ld h,a              ;196e 67
    ld (02c6h),hl       ;196f 22 c6 02
    jp l1aa6h           ;1972 c3 a6 1a
l1975h:
    ld hl,(02b2h)       ;1975 2a b2 02
    ld de,0ffach        ;1978 11 ac ff
    add hl,de           ;197b 19
    ld a,h              ;197c 7c
    or l                ;197d b5
    jp nz,l199ah        ;197e c2 9a 19
    ld hl,(02c6h)       ;1981 2a c6 02
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
    ld (02c6h),hl       ;1994 22 c6 02
    jp l1aa6h           ;1997 c3 a6 1a
l199ah:
    ld hl,(02b2h)       ;199a 2a b2 02
    ld de,0ffb8h        ;199d 11 b8 ff
    add hl,de           ;19a0 19
    ld a,h              ;19a1 7c
    or l                ;19a2 b5
    jp nz,l1743h        ;19a3 c2 43 17
    call sub_2d3dh      ;19a6 cd 3d 2d
    ld hl,l1cceh        ;19a9 21 ce 1c
    call sub_2c3ch      ;19ac cd 3c 2c
    call sub_1bcah      ;19af cd ca 1b
    ld hl,(02b2h)       ;19b2 2a b2 02
    ld de,0ffbbh        ;19b5 11 bb ff
    add hl,de           ;19b8 19
    ld a,h              ;19b9 7c
    or l                ;19ba b5
    jp nz,l19c7h        ;19bb c2 c7 19
    ld hl,001bh         ;19be 21 1b 00
    ld (l02c8h),hl      ;19c1 22 c8 02
    jp l19dfh           ;19c4 c3 df 19
l19c7h:
    ld hl,(02b2h)       ;19c7 2a b2 02
    ld de,0ffach        ;19ca 11 ac ff
    add hl,de           ;19cd 19
    ld a,h              ;19ce 7c
    or l                ;19cf b5
    jp nz,l19dch        ;19d0 c2 dc 19
    ld hl,007eh         ;19d3 21 7e 00
    ld (l02c8h),hl      ;19d6 22 c8 02
    jp l19dfh           ;19d9 c3 df 19
l19dch:
    jp l1743h           ;19dc c3 43 17
l19dfh:
    ld hl,(02c6h)       ;19df 2a c6 02
    ld a,l              ;19e2 7d
    and 80h             ;19e3 e6 80
    ld l,a              ;19e5 6f
    ld a,h              ;19e6 7c
    and 00h             ;19e7 e6 00
    ld h,a              ;19e9 67
    ld a,l              ;19ea 7d
    or 01h              ;19eb f6 01
    ld l,a              ;19ed 6f
    ld a,h              ;19ee 7c
    or 00h              ;19ef f6 00
    ld h,a              ;19f1 67
    ld (02c6h),hl       ;19f2 22 c6 02
    ld hl,0000h         ;19f5 21 00 00
    ld (02cch),hl       ;19f8 22 cc 02
    ld (l02ceh),hl      ;19fb 22 ce 02
    ld hl,0001h         ;19fe 21 01 00
    ld (l02cah),hl      ;1a01 22 ca 02
    ld hl,008bh         ;1a04 21 8b 00
    ld (022ch),hl       ;1a07 22 2c 02
    ld hl,000bh         ;1a0a 21 0b 00
    ld (022eh),hl       ;1a0d 22 2e 02
    ld hl,008ch         ;1a10 21 8c 00
    ld (l0230h),hl      ;1a13 22 30 02
    ld hl,000ch         ;1a16 21 0c 00
    ld (l0230h+2),hl    ;1a19 22 32 02
    ld hl,008fh         ;1a1c 21 8f 00
    ld (0234h),hl       ;1a1f 22 34 02
    ld hl,0013h         ;1a22 21 13 00
    ld (l0236h),hl      ;1a25 22 36 02
    ld hl,0091h         ;1a28 21 91 00
    ld (l0236h+2),hl    ;1a2b 22 38 02
    ld hl,001bh         ;1a2e 21 1b 00
    ld (023ah),hl       ;1a31 22 3a 02
    ld hl,0092h         ;1a34 21 92 00
    ld (l023ch),hl      ;1a37 22 3c 02
    ld hl,001eh         ;1a3a 21 1e 00
    ld (l023ch+2),hl    ;1a3d 22 3e 02
    ld hl,0093h         ;1a40 21 93 00
    ld (0240h),hl       ;1a43 22 40 02
    ld hl,0012h         ;1a46 21 12 00
    ld (l0242h),hl      ;1a49 22 42 02
    ld hl,0097h         ;1a4c 21 97 00
    ld (l0244h),hl      ;1a4f 22 44 02
    ld hl,0014h         ;1a52 21 14 00
    ld (l0244h+2),hl    ;1a55 22 46 02
    ld hl,0098h         ;1a58 21 98 00
    ld (l0248h),hl      ;1a5b 22 48 02
    ld hl,0014h         ;1a5e 21 14 00
    ld (l024ah),hl      ;1a61 22 4a 02
    ld hl,009ah         ;1a64 21 9a 00
    ld (l024ch),hl      ;1a67 22 4c 02
    ld hl,0011h         ;1a6a 21 11 00
    ld (l024eh),hl      ;1a6d 22 4e 02
    ld hl,009ch         ;1a70 21 9c 00
    ld (l0250h),hl      ;1a73 22 50 02
    ld hl,001ah         ;1a76 21 1a 00
    ld (l0252h),hl      ;1a79 22 52 02
    ld hl,009dh         ;1a7c 21 9d 00
    ld (l0254h),hl      ;1a7f 22 54 02
    ld hl,001ah         ;1a82 21 1a 00
    ld (l0254h+2),hl    ;1a85 22 56 02
    ld hl,0099h         ;1a88 21 99 00
    ld (0258h),hl       ;1a8b 22 58 02
    ld hl,0000h         ;1a8e 21 00 00
    ld (l025ah),hl      ;1a91 22 5a 02
    ld hl,009fh         ;1a94 21 9f 00
    ld (025ch),hl       ;1a97 22 5c 02
    ld hl,0000h         ;1a9a 21 00 00
    ld (l025eh),hl      ;1a9d 22 5e 02
    ld (l0260h),hl      ;1aa0 22 60 02
    jp l1743h           ;1aa3 c3 43 17
l1aa6h:
    ld hl,001bh         ;1aa6 21 1b 00
    ld (l02c8h),hl      ;1aa9 22 c8 02
    ld hl,0020h         ;1aac 21 20 00
    ld (02cch),hl       ;1aaf 22 cc 02
    ld (l02ceh),hl      ;1ab2 22 ce 02
    ld hl,0000h         ;1ab5 21 00 00
    ld (l02cah),hl      ;1ab8 22 ca 02
    ld hl,00b1h         ;1abb 21 b1 00
    ld (022ch),hl       ;1abe 22 2c 02
    ld hl,0004h         ;1ac1 21 04 00
    ld (022eh),hl       ;1ac4 22 2e 02
    ld hl,00b2h         ;1ac7 21 b2 00
    ld (l0230h),hl      ;1aca 22 30 02
    ld hl,0005h         ;1acd 21 05 00
    ld (l0230h+2),hl    ;1ad0 22 32 02
    ld hl,00b3h         ;1ad3 21 b3 00
    ld (0234h),hl       ;1ad6 22 34 02
    ld hl,0006h         ;1ad9 21 06 00
    ld (l0236h),hl      ;1adc 22 36 02
    ld hl,00eah         ;1adf 21 ea 00
    ld (l0236h+2),hl    ;1ae2 22 38 02
    ld hl,000eh         ;1ae5 21 0e 00
    ld (023ah),hl       ;1ae8 22 3a 02
    ld hl,00ebh         ;1aeb 21 eb 00
    ld (l023ch),hl      ;1aee 22 3c 02
    ld hl,000fh         ;1af1 21 0f 00
    ld (l023ch+2),hl    ;1af4 22 3e 02
    ld hl,00d1h         ;1af7 21 d1 00
    ld (0240h),hl       ;1afa 22 40 02
    ld hl,001ch         ;1afd 21 1c 00
    ld (l0242h),hl      ;1b00 22 42 02
    ld hl,00d7h         ;1b03 21 d7 00
    ld (l0244h),hl      ;1b06 22 44 02
    ld hl,001dh         ;1b09 21 1d 00
    ld (l0244h+2),hl    ;1b0c 22 46 02
    ld hl,00c5h         ;1b0f 21 c5 00
    ld (l0248h),hl      ;1b12 22 48 02
    ld hl,0011h         ;1b15 21 11 00
    ld (l024ah),hl      ;1b18 22 4a 02
    ld hl,00d2h         ;1b1b 21 d2 00
l1b1eh:
    ld (l024ch),hl      ;1b1e 22 4c 02
    ld hl,0012h         ;1b21 21 12 00
    ld (l024eh),hl      ;1b24 22 4e 02
    ld hl,00d4h         ;1b27 21 d4 00
    ld (l0250h),hl      ;1b2a 22 50 02
    ld hl,0013h         ;1b2d 21 13 00
    ld (l0252h),hl      ;1b30 22 52 02
    ld hl,00f4h         ;1b33 21 f4 00
    ld (l0254h),hl      ;1b36 22 54 02
    ld hl,0013h         ;1b39 21 13 00
    ld (l0254h+2),hl    ;1b3c 22 56 02
    ld hl,00d9h         ;1b3f 21 d9 00
    ld (0258h),hl       ;1b42 22 58 02
    ld hl,0014h         ;1b45 21 14 00
    ld (l025ah),hl      ;1b48 22 5a 02
    ld hl,00f9h         ;1b4b 21 f9 00
    ld (025ch),hl       ;1b4e 22 5c 02
    ld hl,0014h         ;1b51 21 14 00
    ld (l025eh),hl      ;1b54 22 5e 02
    ld hl,00abh         ;1b57 21 ab 00
    ld (l0260h),hl      ;1b5a 22 60 02
    ld hl,001ah         ;1b5d 21 1a 00
    ld (l0262h),hl      ;1b60 22 62 02
    ld hl,00aah         ;1b63 21 aa 00
    ld (l0264h),hl      ;1b66 22 64 02
    ld hl,001ah         ;1b69 21 1a 00
    ld (l0266h),hl      ;1b6c 22 66 02
    ld hl,00bah         ;1b6f 21 ba 00
    ld (l0268h),hl      ;1b72 22 68 02
    ld hl,001ah         ;1b75 21 1a 00
    ld (l0268h+2),hl    ;1b78 22 6a 02
    ld hl,00bbh         ;1b7b 21 bb 00
    ld (026ch),hl       ;1b7e 22 6c 02
    ld hl,001ah         ;1b81 21 1a 00
    ld (026eh),hl       ;1b84 22 6e 02
    ld hl,00dah         ;1b87 21 da 00
    ld (l0270h),hl      ;1b8a 22 70 02
    ld hl,001ah         ;1b8d 21 1a 00
    ld (l0270h+2),hl    ;1b90 22 72 02
    ld hl,00bdh         ;1b93 21 bd 00
    ld (0274h),hl       ;1b96 22 74 02
    ld hl,001bh         ;1b99 21 1b 00
    ld (0276h),hl       ;1b9c 22 76 02
    ld hl,00a8h         ;1b9f 21 a8 00
    ld (l0278h),hl      ;1ba2 22 78 02
    ld hl,0000h         ;1ba5 21 00 00
    ld (l0278h+2),hl    ;1ba8 22 7a 02
    ld hl,00a9h         ;1bab 21 a9 00
    ld (027ch),hl       ;1bae 22 7c 02
    ld hl,0000h         ;1bb1 21 00 00
    ld (l027eh),hl      ;1bb4 22 7e 02
    ld (l0280h),hl      ;1bb7 22 80 02
    jp l1743h           ;1bba c3 43 17
sub_1bbdh:
    call sub_2d3dh      ;1bbd cd 3d 2d
    ld hl,001ah         ;1bc0 21 1a 00
    call sub_2c24h      ;1bc3 cd 24 2c
    call sub_2c31h      ;1bc6 cd 31 2c
    ret                 ;1bc9 c9
sub_1bcah:
    ld hl,0080h         ;1bca 21 80 00
    ld (02e0h),hl       ;1bcd 22 e0 02
    ld hl,(02e0h)       ;1bd0 2a e0 02
    ld (hl),50h         ;1bd3 36 50
    call sub_28a1h      ;1bd5 cd a1 28
    call sub_2d3dh      ;1bd8 cd 3d 2d
    ld hl,l2898h        ;1bdb 21 98 28
    call sub_2c31h      ;1bde cd 31 2c
    ld hl,(02e0h)       ;1be1 2a e0 02
    inc hl              ;1be4 23
    ld l,(hl)           ;1be5 6e
    ld h,00h            ;1be6 26 00
    ld a,h              ;1be8 7c
    or l                ;1be9 b5
    jp nz,l1bf4h        ;1bea c2 f4 1b
    ld hl,0000h         ;1bed 21 00 00
    ld (02b2h),hl       ;1bf0 22 b2 02
    ret                 ;1bf3 c9
l1bf4h:
    ld hl,(02e0h)       ;1bf4 2a e0 02
    inc hl              ;1bf7 23
    inc hl              ;1bf8 23
    ld l,(hl)           ;1bf9 6e
    ld h,00h            ;1bfa 26 00
    ld (02b2h),hl       ;1bfc 22 b2 02
    ld hl,(02b2h)       ;1bff 2a b2 02
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
    ld hl,(02b2h)       ;1c11 2a b2 02
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
    ld hl,(02b2h)       ;1c30 2a b2 02
    add hl,de           ;1c33 19
    ld (02b2h),hl       ;1c34 22 b2 02
l1c37h:
    ld hl,0000h         ;1c37 21 00 00
    ld (l02d8h),hl      ;1c3a 22 d8 02
    ld hl,0002h         ;1c3d 21 02 00
    ld (l02d0h),hl      ;1c40 22 d0 02
l1c43h:
    ld hl,(02e0h)       ;1c43 2a e0 02
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
    ld hl,(02e0h)       ;1c7b 2a e0 02
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
    call sub_2c9ah      ;1ca6 cd 9a 2c
    ld a,(bc)           ;1ca9 0a
    nop                 ;1caa 00
    push hl             ;1cab e5
    ld hl,(02e0h)       ;1cac 2a e0 02
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
    call sub_2d24h      ;1ccb cd 24 2d
l1cceh:
    inc hl              ;1cce 23
    pop de              ;1ccf d1
    inc e               ;1cd0 1c
    ld c,h              ;1cd1 4c
    ld h,l              ;1cd2 65
    ld h,c              ;1cd3 61
    ld h,h              ;1cd4 64
    dec l               ;1cd5 2d
    ld l,c              ;1cd6 69
    ld l,(hl)           ;1cd7 6e
    jr nz,l1d3dh        ;1cd8 20 63
    ld l,a              ;1cda 6f
    ld h,h              ;1cdb 64
    ld h,l              ;1cdc 65
    jr nz,l1d24h        ;1cdd 20 45
    jr z,l1d54h         ;1cdf 28 73
    ld h,e              ;1ce1 63
    ld h,c              ;1ce2 61
    ld (hl),b           ;1ce3 70
    ld h,l              ;1ce4 65
    add hl,hl           ;1ce5 29
    jr nz,l1d57h        ;1ce6 20 6f
    ld (hl),d           ;1ce8 72
    jr nz,$+86          ;1ce9 20 54
    jr z,$+107          ;1ceb 28 69
    ld l,h              ;1ced 6c
    ld h,h              ;1cee 64
    ld h,l              ;1cef 65
    add hl,hl           ;1cf0 29
    jr nz,l1d32h        ;1cf1 20 3f
    jr nz,$+39          ;1cf3 20 25
    rst 30h             ;1cf5 f7
    inc e               ;1cf6 1c
    ld d,e              ;1cf7 53
    ld h,e              ;1cf8 63
    ld (hl),d           ;1cf9 72
    ld h,l              ;1cfa 65
    ld h,l              ;1cfb 65
    ld l,(hl)           ;1cfc 6e
    jr nz,l1d73h        ;1cfd 20 74
    ld a,c              ;1cff 79
    ld (hl),b           ;1d00 70
    ld h,l              ;1d01 65
    jr nz,l1d2ch        ;1d02 20 28
    ld b,c              ;1d04 41
    ld b,h              ;1d05 44
    ld c,l              ;1d06 4d
    inc sp              ;1d07 33
    ld b,c              ;1d08 41
    inc l               ;1d09 2c
    jr nz,l1d54h        ;1d0a 20 48
    ld e,d              ;1d0c 5a
    ld sp,3035h         ;1d0d 31 35 30
    jr nc,l1d3eh        ;1d10 30 2c
    jr nz,l1d68h        ;1d12 20 54
    ld d,(hl)           ;1d14 56
    add hl,sp           ;1d15 39
    ld sp,2932h         ;1d16 31 32 29
    jr nz,l1d5ah        ;1d19 20 3f
    jr nz,$+24          ;1d1b 20 16
    rra                 ;1d1d 1f
    dec e               ;1d1e 1d
    ld c,(hl)           ;1d1f 4e
    ld h,l              ;1d20 65
    ld (hl),a           ;1d21 77
    jr nz,l1d87h        ;1d22 20 63
l1d24h:
    ld l,h              ;1d24 6c
    ld l,a              ;1d25 6f
    ld h,e              ;1d26 63
    ld l,e              ;1d27 6b
    jr nz,l1d90h        ;1d28 20 66
    ld (hl),d           ;1d2a 72
    ld h,l              ;1d2b 65
l1d2ch:
    ld (hl),c           ;1d2c 71
    ld (hl),l           ;1d2d 75
    ld h,l              ;1d2e 65
    ld l,(hl)           ;1d2f 6e
    ld h,e              ;1d30 63
    ld a,c              ;1d31 79
l1d32h:
    jr nz,l1d73h        ;1d32 20 3f
    jr nz,$+34          ;1d34 20 20
    jr c,l1d55h         ;1d36 38 1d
    ld c,(hl)           ;1d38 4e
    ld (hl),l           ;1d39 75
    ld l,l              ;1d3a 6d
    ld h,d              ;1d3b 62
    ld h,l              ;1d3c 65
l1d3dh:
    ld (hl),d           ;1d3d 72
l1d3eh:
    jr nz,l1dafh        ;1d3e 20 6f
    ld h,(hl)           ;1d40 66
    jr nz,$+101         ;1d41 20 63
    ld l,a              ;1d43 6f
    ld l,h              ;1d44 6c
    ld (hl),l           ;1d45 75
    ld l,l              ;1d46 6d
    ld l,(hl)           ;1d47 6e
    ld (hl),e           ;1d48 73
    jr nz,l1d73h        ;1d49 20 28
    ld sp,l202ch        ;1d4b 31 2c 20
    ld (6f20h),a        ;1d4e 32 20 6f
    ld (hl),d           ;1d51 72
    jr nz,l1d88h        ;1d52 20 34
l1d54h:
    add hl,hl           ;1d54 29
l1d55h:
    jr nz,l1d96h        ;1d55 20 3f
l1d57h:
    jr nz,$+22          ;1d57 20 14
    ld e,e              ;1d59 5b
l1d5ah:
    dec e               ;1d5a 1d
    ld b,c              ;1d5b 41
    ld l,h              ;1d5c 6c
    ld (hl),h           ;1d5d 74
    ld h,l              ;1d5e 65
    ld (hl),d           ;1d5f 72
    jr nz,l1dd9h        ;1d60 20 77
    ld l,b              ;1d62 68
    ld l,c              ;1d63 69
    ld h,e              ;1d64 63
    ld l,b              ;1d65 68
    jr nz,l1d90h        ;1d66 20 28
l1d68h:
    ld sp,342dh         ;1d68 31 2d 34
    add hl,hl           ;1d6b 29
    jr nz,l1dadh        ;1d6c 20 3f
    jr nz,$+33          ;1d6e 20 1f
    ld (hl),d           ;1d70 72
    dec e               ;1d71 1d
    inc (hl)            ;1d72 34
l1d73h:
    ld l,20h            ;1d73 2e 20
    jr nz,$+69          ;1d75 20 43
    ld l,h              ;1d77 6c
    ld l,a              ;1d78 6f
    ld h,e              ;1d79 63
    ld l,e              ;1d7a 6b
    jr nz,l1de3h        ;1d7b 20 66
    ld (hl),d           ;1d7d 72
    ld h,l              ;1d7e 65
    ld (hl),c           ;1d7f 71
    ld (hl),l           ;1d80 75
    ld h,l              ;1d81 65
    ld l,(hl)           ;1d82 6e
    ld h,e              ;1d83 63
    ld a,c              ;1d84 79
    jr nz,l1dafh        ;1d85 20 28
l1d87h:
    ld c,b              ;1d87 48
l1d88h:
    ld a,d              ;1d88 7a
    add hl,hl           ;1d89 29
    jr nz,l1dc6h        ;1d8a 20 3a
    jr nz,l1daeh        ;1d8c 20 20
    jr nz,$+34          ;1d8e 20 20
l1d90h:
    jr nz,l1daah        ;1d90 20 18
    sub h               ;1d92 94
    dec e               ;1d93 1d
    add hl,bc           ;1d94 09
    add hl,bc           ;1d95 09
l1d96h:
    jr nz,$+34          ;1d96 20 20
    jr nz,$+34          ;1d98 20 20
    jr nz,l1dc4h        ;1d9a 20 28
    ld c,h              ;1d9c 4c
    ld h,l              ;1d9d 65
    ld h,c              ;1d9e 61
    ld h,h              ;1d9f 64
    dec l               ;1da0 2d
    ld l,c              ;1da1 69
    ld l,(hl)           ;1da2 6e
    jr nz,l1de2h        ;1da3 20 3d
    jr nz,l1dfbh        ;1da5 20 54
    ld c,c              ;1da7 49
    ld c,h              ;1da8 4c
    ld b,h              ;1da9 44
l1daah:
    ld b,l              ;1daa 45
    add hl,hl           ;1dab 29
l1dach:
    dec h               ;1dac 25
l1dadh:
    xor a               ;1dad af
l1daeh:
    dec e               ;1dae 1d
l1dafh:
    jr nz,l1dd1h        ;1daf 20 20
    jr nz,l1dd3h        ;1db1 20 20
    jr nz,$+34          ;1db3 20 20
    jr nz,l1dd7h        ;1db5 20 20
    jr nz,l1dd9h        ;1db7 20 20
    jr nz,$+34          ;1db9 20 20
    jr nz,$+34          ;1dbb 20 20
    jr nz,l1ddfh        ;1dbd 20 20
    jr nz,l1de1h        ;1dbf 20 20
    jr nz,l1debh        ;1dc1 20 28
    ld c,h              ;1dc3 4c
l1dc4h:
    ld h,l              ;1dc4 65
    ld h,c              ;1dc5 61
l1dc6h:
    ld h,h              ;1dc6 64
    dec l               ;1dc7 2d
    ld l,c              ;1dc8 69
    ld l,(hl)           ;1dc9 6e
    jr nz,l1e09h        ;1dca 20 3d
    jr nz,l1e13h        ;1dcc 20 45
    ld d,e              ;1dce 53
    ld b,e              ;1dcf 43
    ld b,c              ;1dd0 41
l1dd1h:
    ld d,b              ;1dd1 50
    ld b,l              ;1dd2 45
l1dd3h:
    add hl,hl           ;1dd3 29
l1dd4h:
    ld b,0d7h           ;1dd4 06 d7
    dec e               ;1dd6 1d
l1dd7h:
    ld c,b              ;1dd7 48
    ld e,d              ;1dd8 5a
l1dd9h:
    ld sp,3035h         ;1dd9 31 35 30
    jr nc,l1de3h        ;1ddc 30 05
    ret po              ;1dde e0
l1ddfh:
    dec e               ;1ddf 1d
    ld d,h              ;1de0 54
l1de1h:
    ld d,(hl)           ;1de1 56
l1de2h:
    add hl,sp           ;1de2 39
l1de3h:
    ld sp,l0530h+2      ;1de3 31 32 05
    ret pe              ;1de6 e8
    dec e               ;1de7 1d
    ld b,c              ;1de8 41
    ld b,h              ;1de9 44
    ld c,l              ;1dea 4d
l1debh:
    inc sp              ;1deb 33
    ld b,c              ;1dec 41
l1dedh:
    rra                 ;1ded 1f
    ret p               ;1dee f0
    dec e               ;1def 1d
    inc sp              ;1df0 33
    ld l,20h            ;1df1 2e 20
    jr nz,$+69          ;1df3 20 43
    ld d,d              ;1df5 52
    ld d,h              ;1df6 54
    jr nz,l1e6dh        ;1df7 20 74
    ld h,l              ;1df9 65
    ld (hl),d           ;1dfa 72
l1dfbh:
    ld l,l              ;1dfb 6d
    ld l,c              ;1dfc 69
    ld l,(hl)           ;1dfd 6e
    ld h,c              ;1dfe 61
    ld l,h              ;1dff 6c
    jr nz,$+103         ;1e00 20 65
    ld l,l              ;1e02 6d
    ld (hl),l           ;1e03 75
    ld l,h              ;1e04 6c
    ld h,c              ;1e05 61
    ld (hl),h           ;1e06 74
    ld l,c              ;1e07 69
    ld l,a              ;1e08 6f
l1e09h:
    ld l,(hl)           ;1e09 6e
    jr nz,l1e46h        ;1e0a 20 3a
    jr nz,$+34          ;1e0c 20 20
    jr nz,$+4           ;1e0e 20 02
    ld (de),a           ;1e10 12
    ld e,6eh            ;1e11 1e 6e
l1e13h:
    ld l,a              ;1e13 6f
l1e14h:
    inc bc              ;1e14 03
    rla                 ;1e15 17
    ld e,79h            ;1e16 1e 79
    ld h,l              ;1e18 65
    ld (hl),e           ;1e19 73
l1e1ah:
    rra                 ;1e1a 1f
    dec e               ;1e1b 1d
    ld e,32h            ;1e1c 1e 32
    ld l,20h            ;1e1e 2e 20
    jr nz,$+69          ;1e20 20 43
    ld d,d              ;1e22 52
    ld d,h              ;1e23 54
    jr nz,$+107         ;1e24 20 69
    ld l,(hl)           ;1e26 6e
    jr nz,l1e9eh        ;1e27 20 75
    ld (hl),b           ;1e29 70
    ld (hl),b           ;1e2a 70
    ld h,l              ;1e2b 65
    ld (hl),d           ;1e2c 72
    jr nz,l1e92h        ;1e2d 20 63
    ld h,c              ;1e2f 61
    ld (hl),e           ;1e30 73
    ld h,l              ;1e31 65
    jr nz,l1ea1h        ;1e32 20 6d
    ld l,a              ;1e34 6f
    ld h,h              ;1e35 64
    ld h,l              ;1e36 65
    jr nz,l1e73h        ;1e37 20 3a
    jr nz,l1e5bh        ;1e39 20 20
    jr nz,l1e3eh        ;1e3b 20 01
    ccf                 ;1e3d 3f
l1e3eh:
    ld e,34h            ;1e3e 1e 34
l1e40h:
    rra                 ;1e40 1f
    ld b,e              ;1e41 43
    ld e,31h            ;1e42 1e 31
    ld l,20h            ;1e44 2e 20
l1e46h:
    jr nz,$+69          ;1e46 20 43
    ld l,a              ;1e48 6f
    ld l,h              ;1e49 6c
    ld (hl),l           ;1e4a 75
    ld l,l              ;1e4b 6d
    ld l,(hl)           ;1e4c 6e
    ld (hl),e           ;1e4d 73
    jr nz,l1eb9h        ;1e4e 20 69
    ld l,(hl)           ;1e50 6e
    jr nz,l1e97h        ;1e51 20 44
    ld c,c              ;1e53 49
    ld d,d              ;1e54 52
    jr nz,l1ec3h        ;1e55 20 6c
    ld l,c              ;1e57 69
    ld (hl),e           ;1e58 73
    ld (hl),h           ;1e59 74
    ld l,c              ;1e5a 69
l1e5bh:
    ld l,(hl)           ;1e5b 6e
    ld h,a              ;1e5c 67
    jr nz,l1e99h        ;1e5d 20 3a
    jr nz,l1e81h        ;1e5f 20 20
    jr nz,l1e80h        ;1e61 20 1d
    ld h,l              ;1e63 65
    ld e,20h            ;1e64 1e 20
    jr nz,l1e88h        ;1e66 20 20
    jr nz,l1e8ah        ;1e68 20 20
    jr nz,l1e99h        ;1e6a 20 2d
    dec l               ;1e6c 2d
l1e6dh:
    dec l               ;1e6d 2d
    jr nz,l1e9dh        ;1e6e 20 2d
    dec l               ;1e70 2d
    dec l               ;1e71 2d
    dec l               ;1e72 2d
l1e73h:
    dec l               ;1e73 2d
    dec l               ;1e74 2d
    dec l               ;1e75 2d
    dec l               ;1e76 2d
    jr nz,l1ea6h        ;1e77 20 2d
    dec l               ;1e79 2d
    dec l               ;1e7a 2d
    dec l               ;1e7b 2d
    dec l               ;1e7c 2d
    dec l               ;1e7d 2d
    dec l               ;1e7e 2d
    dec l               ;1e7f 2d
l1e80h:
    dec l               ;1e80 2d
l1e81h:
    dec l               ;1e81 2d
l1e82h:
    dec e               ;1e82 1d
    add a,l             ;1e83 85
    ld e,20h            ;1e84 1e 20
    jr nz,l1ea8h        ;1e86 20 20
l1e88h:
    jr nz,l1eaah        ;1e88 20 20
l1e8ah:
    jr nz,l1edch        ;1e8a 20 50
    ld h,l              ;1e8c 65
    ld (hl),h           ;1e8d 74
    jr nz,$+118         ;1e8e 20 74
    ld h,l              ;1e90 65
    ld (hl),d           ;1e91 72
l1e92h:
    ld l,l              ;1e92 6d
    ld l,c              ;1e93 69
    ld l,(hl)           ;1e94 6e
    ld h,c              ;1e95 61
    ld l,h              ;1e96 6c
l1e97h:
    jr nz,l1f09h        ;1e97 20 70
l1e99h:
    ld h,c              ;1e99 61
    ld (hl),d           ;1e9a 72
    ld h,c              ;1e9b 61
    ld l,l              ;1e9c 6d
l1e9dh:
    ld h,l              ;1e9d 65
l1e9eh:
    ld (hl),h           ;1e9e 74
    ld h,l              ;1e9f 65
    ld (hl),d           ;1ea0 72
l1ea1h:
    ld (hl),e           ;1ea1 73
l1ea2h:
    rrca                ;1ea2 0f
    and l               ;1ea3 a5
    ld e,52h            ;1ea4 1e 52
l1ea6h:
    ld h,l              ;1ea6 65
    dec l               ;1ea7 2d
l1ea8h:
    ld (hl),h           ;1ea8 74
    ld (hl),d           ;1ea9 72
l1eaah:
    ld a,c              ;1eaa 79
    jr nz,$+42          ;1eab 20 28
    ld e,c              ;1ead 59
    cpl                 ;1eae 2f
    ld c,(hl)           ;1eaf 4e
    add hl,hl           ;1eb0 29
    jr nz,l1ef2h        ;1eb1 20 3f
    jr nz,l1ec8h        ;1eb3 20 13
    or a                ;1eb5 b7
    ld e,44h            ;1eb6 1e 44
    ld (hl),d           ;1eb8 72
l1eb9h:
    ld l,c              ;1eb9 69
    halt                ;1eba 76
    ld h,l              ;1ebb 65
    jr nz,$+112         ;1ebc 20 6e
    ld l,a              ;1ebe 6f
    ld (hl),h           ;1ebf 74
    jr nz,l1f2bh        ;1ec0 20 69
    ld l,(hl)           ;1ec2 6e
l1ec3h:
    jr nz,l1f38h        ;1ec3 20 73
    ld a,c              ;1ec5 79
    ld (hl),e           ;1ec6 73
    ld (hl),h           ;1ec7 74
l1ec8h:
    ld h,l              ;1ec8 65
    ld l,l              ;1ec9 6d
l1ecah:
    rra                 ;1eca 1f
    call 531eh          ;1ecb cd 1e 53
    ld h,c              ;1ece 61
    halt                ;1ecf 76
    ld h,l              ;1ed0 65
    jr nz,$+113         ;1ed1 20 6f
    ld l,(hl)           ;1ed3 6e
    jr nz,$+121         ;1ed4 20 77
    ld l,b              ;1ed6 68
    ld l,c              ;1ed7 69
    ld h,e              ;1ed8 63
    ld l,b              ;1ed9 68
    jr nz,l1f40h        ;1eda 20 64
l1edch:
    ld (hl),d           ;1edc 72
    ld l,c              ;1edd 69
    halt                ;1ede 76
    ld h,l              ;1edf 65
    jr nz,l1f0ah        ;1ee0 20 28
    ld b,c              ;1ee2 41
    jr nz,l1f59h        ;1ee3 20 74
    ld l,a              ;1ee5 6f
    jr nz,l1f38h        ;1ee6 20 50
    add hl,hl           ;1ee8 29
    jr nz,l1f2ah        ;1ee9 20 3f
    jr nz,$+33          ;1eeb 20 1f
    rst 28h             ;1eed ef
    ld e,50h            ;1eee 1e 50
    ld l,h              ;1ef0 6c
    ld h,l              ;1ef1 65
l1ef2h:
    ld h,c              ;1ef2 61
    ld (hl),e           ;1ef3 73
    ld h,l              ;1ef4 65
    jr nz,$+103         ;1ef5 20 65
    ld l,(hl)           ;1ef7 6e
    ld (hl),h           ;1ef8 74
    ld h,l              ;1ef9 65
    ld (hl),d           ;1efa 72
    jr nz,$+118         ;1efb 20 74
    ld l,b              ;1efd 68
    ld h,l              ;1efe 65
    jr nz,l1f6fh        ;1eff 20 6e
    ld h,l              ;1f01 65
    ld (hl),a           ;1f02 77
    jr nz,l1f68h        ;1f03 20 63
    ld l,a              ;1f05 6f
    ld l,l              ;1f06 6d
    ld l,l              ;1f07 6d
    ld h,c              ;1f08 61
l1f09h:
    ld l,(hl)           ;1f09 6e
l1f0ah:
    ld h,h              ;1f0a 64
    jr nz,l1f47h        ;1f0b 20 3a
    jr nz,$+31          ;1f0d 20 1d
    ld de,4e1fh         ;1f0f 11 1f 4e
    ld h,l              ;1f12 65
    ld (hl),a           ;1f13 77
    jr nz,$+99          ;1f14 20 61
    ld (hl),l           ;1f16 75
    ld (hl),h           ;1f17 74
    ld l,a              ;1f18 6f
    ld l,h              ;1f19 6c
    ld l,a              ;1f1a 6f
    ld h,c              ;1f1b 61
    ld h,h              ;1f1c 64
    jr nz,l1f82h        ;1f1d 20 63
    ld l,a              ;1f1f 6f
    ld l,l              ;1f20 6d
    ld l,l              ;1f21 6d
    ld h,c              ;1f22 61
    ld l,(hl)           ;1f23 6e
    ld h,h              ;1f24 64
    jr nz,l1f4fh        ;1f25 20 28
    ld e,c              ;1f27 59
    cpl                 ;1f28 2f
    ld c,(hl)           ;1f29 4e
l1f2ah:
    add hl,hl           ;1f2a 29
l1f2bh:
    jr nz,l1f6ch        ;1f2b 20 3f
    jr nz,l1f4ch        ;1f2d 20 1d
    ld sp,431fh         ;1f2f 31 1f 43
    ld (hl),l           ;1f32 75
    ld (hl),d           ;1f33 72
    ld (hl),d           ;1f34 72
    ld h,l              ;1f35 65
    ld l,(hl)           ;1f36 6e
    ld (hl),h           ;1f37 74
l1f38h:
    jr nz,l1f9bh        ;1f38 20 61
    ld (hl),l           ;1f3a 75
    ld (hl),h           ;1f3b 74
    ld l,a              ;1f3c 6f
    ld l,h              ;1f3d 6c
    ld l,a              ;1f3e 6f
    ld h,c              ;1f3f 61
l1f40h:
    ld h,h              ;1f40 64
    jr nz,l1fa6h        ;1f41 20 63
    ld l,a              ;1f43 6f
    ld l,l              ;1f44 6d
    ld l,l              ;1f45 6d
    ld h,c              ;1f46 61
l1f47h:
    ld l,(hl)           ;1f47 6e
    ld h,h              ;1f48 64
    jr nz,l1fb4h        ;1f49 20 69
    ld (hl),e           ;1f4b 73
l1f4ch:
    jr nz,$+60          ;1f4c 20 3a
l1f4eh:
    dec de              ;1f4e 1b
l1f4fh:
    ld d,c              ;1f4f 51
    rra                 ;1f50 1f
    ld c,(hl)           ;1f51 4e
    ld l,a              ;1f52 6f
    jr nz,l1fb8h        ;1f53 20 63
    ld (hl),l           ;1f55 75
    ld (hl),d           ;1f56 72
    ld (hl),d           ;1f57 72
    ld h,l              ;1f58 65
l1f59h:
    ld l,(hl)           ;1f59 6e
    ld (hl),h           ;1f5a 74
    jr nz,$+99          ;1f5b 20 61
    ld (hl),l           ;1f5d 75
sub_1f5eh:
    ld (hl),h           ;1f5e 74
    ld l,a              ;1f5f 6f
    ld l,h              ;1f60 6c
    ld l,a              ;1f61 6f
    ld h,c              ;1f62 61
    ld h,h              ;1f63 64
    jr nz,l1fc9h        ;1f64 20 63
    ld l,a              ;1f66 6f
    ld l,l              ;1f67 6d
l1f68h:
    ld l,l              ;1f68 6d
    ld h,c              ;1f69 61
    ld l,(hl)           ;1f6a 6e
    ld h,h              ;1f6b 64
l1f6ch:
    ld c,6fh            ;1f6c 0e 6f
    rra                 ;1f6e 1f
l1f6fh:
    ld sp,4d32h         ;1f6f 31 32 4d
    ld h,d              ;1f72 62
    ld a,c              ;1f73 79
    ld (hl),h           ;1f74 74
    ld h,l              ;1f75 65
    jr nz,l1fa0h        ;1f76 20 28
    ld l,b              ;1f78 68
    ld h,c              ;1f79 61
    ld l,h              ;1f7a 6c
    ld h,(hl)           ;1f7b 66
    add hl,hl           ;1f7c 29
l1f7dh:
    ld c,80h            ;1f7d 0e 80
    rra                 ;1f7f 1f
    ld (hl),20h         ;1f80 36 20
l1f82h:
    ld c,l              ;1f82 4d
    ld h,d              ;1f83 62
    ld a,c              ;1f84 79
    ld (hl),h           ;1f85 74
    ld h,l              ;1f86 65
    jr nz,l1fb1h        ;1f87 20 28
    ld l,b              ;1f89 68
    ld h,c              ;1f8a 61
    ld l,h              ;1f8b 6c
    ld h,(hl)           ;1f8c 66
    add hl,hl           ;1f8d 29
l1f8eh:
    ld c,91h            ;1f8e 0e 91
    rra                 ;1f90 1f
    inc sp              ;1f91 33
    jr nz,l1fe1h        ;1f92 20 4d
    ld h,d              ;1f94 62
    ld a,c              ;1f95 79
    ld (hl),h           ;1f96 74
    ld h,l              ;1f97 65
    jr nz,l1fc2h        ;1f98 20 28
    ld l,b              ;1f9a 68
l1f9bh:
    ld h,c              ;1f9b 61
    ld l,h              ;1f9c 6c
    ld h,(hl)           ;1f9d 66
    add hl,hl           ;1f9e 29
l1f9fh:
    dec c               ;1f9f 0d
l1fa0h:
    and d               ;1fa0 a2
    rra                 ;1fa1 1f
    ld sp,l2032h        ;1fa2 31 32 20
    ld c,l              ;1fa5 4d
l1fa6h:
    ld h,d              ;1fa6 62
    ld a,c              ;1fa7 79
    ld (hl),h           ;1fa8 74
    ld h,l              ;1fa9 65
    jr nz,l1fcch        ;1faa 20 20
    jr nz,l1fceh        ;1fac 20 20
    jr nz,l1fb7h        ;1fae 20 07
    or d                ;1fb0 b2
l1fb1h:
    rra                 ;1fb1 1f
    ld (hl),20h         ;1fb2 36 20
l1fb4h:
    ld c,l              ;1fb4 4d
    ld h,d              ;1fb5 62
    ld a,c              ;1fb6 79
l1fb7h:
    ld (hl),h           ;1fb7 74
l1fb8h:
    ld h,l              ;1fb8 65
l1fb9h:
    inc c               ;1fb9 0c
    cp h                ;1fba bc
    rra                 ;1fbb 1f
    inc sp              ;1fbc 33
    jr nz,l200ch        ;1fbd 20 4d
    ld h,d              ;1fbf 62
    ld a,c              ;1fc0 79
    ld (hl),h           ;1fc1 74
l1fc2h:
    ld h,l              ;1fc2 65
    jr nz,l1fe5h        ;1fc3 20 20
    jr nz,l1fe7h        ;1fc5 20 20
    jr nz,l1fd7h        ;1fc7 20 0e
l1fc9h:
    rr a                ;1fc9 cb 1f
    ld d,a              ;1fcb 57
l1fcch:
    ld l,c              ;1fcc 69
    ld l,(hl)           ;1fcd 6e
l1fceh:
    ld h,e              ;1fce 63
    ld l,b              ;1fcf 68
    ld h,l              ;1fd0 65
    ld (hl),e           ;1fd1 73
    ld (hl),h           ;1fd2 74
    ld h,l              ;1fd3 65
    ld (hl),d           ;1fd4 72
    jr nz,l1ff7h        ;1fd5 20 20
l1fd7h:
    jr nz,l1ff9h        ;1fd7 20 20
l1fd9h:
    dec bc              ;1fd9 0b
    call c,l201fh       ;1fda dc 1f 20
    jr nz,$+34          ;1fdd 20 20
    ld b,h              ;1fdf 44
    ld h,l              ;1fe0 65
l1fe1h:
    halt                ;1fe1 76
    ld l,c              ;1fe2 69
    ld h,e              ;1fe3 63
    ld h,l              ;1fe4 65
l1fe5h:
    jr nz,l200ah        ;1fe5 20 23
l1fe7h:
    dec bc              ;1fe7 0b
    jp pe,431fh         ;1fe8 ea 1f 43
    ld l,a              ;1feb 6f
    ld (hl),d           ;1fec 72
    halt                ;1fed 76
    ld (hl),l           ;1fee 75
    ld (hl),e           ;1fef 73
    jr nz,l2027h        ;1ff0 20 35
    ld c,l              ;1ff2 4d
    ld h,d              ;1ff3 62
    ld hl,(0f80bh)      ;1ff4 2a 0b f8
l1ff7h:
    rra                 ;1ff7 1f
    ld b,e              ;1ff8 43
l1ff9h:
    ld l,a              ;1ff9 6f
    ld (hl),d           ;1ffa 72
    halt                ;1ffb 76
    ld (hl),l           ;1ffc 75
    ld (hl),e           ;1ffd 73
    jr nz,$+55          ;1ffe 20 35
    ld c,l              ;2000 4d
    ld h,d              ;2001 62
    jr nz,$+13          ;2002 20 0b
    ld b,20h            ;2004 06 20
    ld b,e              ;2006 43
    ld l,a              ;2007 6f
    ld (hl),d           ;2008 72
    halt                ;2009 76
l200ah:
    ld (hl),l           ;200a 75
    ld (hl),e           ;200b 73
l200ch:
    jr nz,l2040h        ;200c 20 32
    jr nc,l205dh        ;200e 30 4d
    ld h,d              ;2010 62
l2011h:
    dec bc              ;2011 0b
    inc d               ;2012 14
    jr nz,l2058h        ;2013 20 43
    ld l,a              ;2015 6f
    ld (hl),d           ;2016 72
    halt                ;2017 76
    ld (hl),l           ;2018 75
    ld (hl),e           ;2019 73
    jr nz,$+51          ;201a 20 31
    jr nc,l206bh        ;201c 30 4d
    ld h,d              ;201e 62
l201fh:
    ex af,af'           ;201f 08
    ld (6e20h),hl       ;2020 22 20 6e
    ld l,a              ;2023 6f
    ld (hl),h           ;2024 74
    jr nz,$+119         ;2025 20 75
l2027h:
    ld (hl),e           ;2027 73
    ld h,l              ;2028 65
l2029h:
    ld h,h              ;2029 64
l202ah:
    dec bc              ;202a 0b
    dec l               ;202b 2d
l202ch:
    jr nz,l2066h        ;202c 20 38
l202eh:
    jr nc,$+55          ;202e 30 35
    jr nc,l2052h        ;2030 30 20
l2032h:
    jr nz,l2054h        ;2032 20 20
    jr nz,l2056h        ;2034 20 20
    jr nz,l2058h        ;2036 20 20
l2038h:
    dec bc              ;2038 0b
    dec sp              ;2039 3b
    jr nz,l206fh        ;203a 20 33
    jr nc,l2072h        ;203c 30 34
    jr nc,l206fh        ;203e 30 2f
l2040h:
    inc (hl)            ;2040 34
    jr nc,$+54          ;2041 30 34
    jr nc,$+34          ;2043 30 20
    jr nz,l2063h        ;2045 20 1c
    ld c,c              ;2047 49
    jr nz,l20bfh        ;2048 20 75
    ld (hl),e           ;204a 73
    ld h,l              ;204b 65
    jr nz,$+118         ;204c 20 74
    ld l,b              ;204e 68
    ld h,l              ;204f 65
sub_2050h:
    jr nz,l2098h        ;2050 20 46
l2052h:
    ld c,c              ;2052 49
    ld d,d              ;2053 52
l2054h:
    ld d,e              ;2054 53
    ld d,h              ;2055 54
l2056h:
    jr nz,l20a0h        ;2056 20 48
l2058h:
    ld b,c              ;2058 41
    ld c,h              ;2059 4c
    ld b,(hl)           ;205a 46
    jr nz,l2085h        ;205b 20 28
l205dh:
    ld b,l              ;205d 45
    cpl                 ;205e 2f
    ld c,b              ;205f 48
    add hl,hl           ;2060 29
    jr nz,l2083h        ;2061 20 20
l2063h:
    ccf                 ;2063 3f
    jr nz,l208dh        ;2064 20 27
l2066h:
    ld l,b              ;2066 68
    jr nz,l20beh        ;2067 20 55
    ld (hl),e           ;2069 73
    ld h,l              ;206a 65
l206bh:
    jr nz,$+118         ;206b 20 74
    ld l,b              ;206d 68
    ld h,l              ;206e 65
l206fh:
    jr nz,l20b6h        ;206f 20 45
    ld c,(hl)           ;2071 4e
l2072h:
    ld d,h              ;2072 54
    ld c,c              ;2073 49
    ld d,d              ;2074 52
    ld b,l              ;2075 45
    jr nz,l20dch        ;2076 20 64
    ld (hl),d           ;2078 72
    ld l,c              ;2079 69
    halt                ;207a 76
    ld h,l              ;207b 65
    jr nz,l20e4h        ;207c 20 66
    ld l,a              ;207e 6f
    ld (hl),d           ;207f 72
    jr nz,l20c5h        ;2080 20 43
    ld d,b              ;2082 50
l2083h:
    cpl                 ;2083 2f
    ld c,l              ;2084 4d
l2085h:
    inc l               ;2085 2c
    jr nz,l20a8h        ;2086 20 20
    ld l,a              ;2088 6f
    ld (hl),d           ;2089 72
    jr nz,l20f6h        ;208a 20 6a
    ld (hl),l           ;208c 75
l208dh:
    ld (hl),e           ;208d 73
    ld (hl),h           ;208e 74
l208fh:
    add hl,de           ;208f 19
    sub d               ;2090 92
    jr nz,l20c6h        ;2091 20 33
    inc l               ;2093 2c
    jr nz,l20cch        ;2094 20 36
    jr nz,l2107h        ;2096 20 6f
l2098h:
    ld (hl),d           ;2098 72
    jr nz,l20cch        ;2099 20 31
    ld (4d20h),a        ;209b 32 20 4d
    ld h,d              ;209e 62
    ld a,c              ;209f 79
l20a0h:
    ld (hl),h           ;20a0 74
    ld h,l              ;20a1 65
    jr nz,$+102         ;20a2 20 64
    ld (hl),d           ;20a4 72
    ld l,c              ;20a5 69
    halt                ;20a6 76
    ld h,l              ;20a7 65
l20a8h:
    jr nz,l20e9h        ;20a8 20 3f
    jr nz,$+36          ;20aa 20 22
    xor (hl)            ;20ac ae
    jr nz,l20f2h        ;20ad 20 43
    ld l,a              ;20af 6f
    ld l,(hl)           ;20b0 6e
    ld h,(hl)           ;20b1 66
    ld l,c              ;20b2 69
    ld h,a              ;20b3 67
    ld (hl),l           ;20b4 75
    ld (hl),d           ;20b5 72
l20b6h:
    ld h,l              ;20b6 65
    jr nz,$+99          ;20b7 20 61
    ld (hl),e           ;20b9 73
    jr nz,$+51          ;20ba 20 31
    jr nz,l212dh        ;20bc 20 6f
l20beh:
    ld (hl),d           ;20be 72
l20bfh:
    jr nz,$+52          ;20bf 20 32
    jr nz,l2106h        ;20c1 20 43
    ld d,b              ;20c3 50
    cpl                 ;20c4 2f
l20c5h:
    ld c,l              ;20c5 4d
l20c6h:
    jr nz,l212ch        ;20c6 20 64
    ld (hl),d           ;20c8 72
    ld l,c              ;20c9 69
    halt                ;20ca 76
    ld h,l              ;20cb 65
l20cch:
    ld (hl),e           ;20cc 73
    jr nz,$+65          ;20cd 20 3f
    jr nz,$+28          ;20cf 20 1a
    out (20h),a         ;20d1 d3 20
    ld b,h              ;20d3 44
    ld h,l              ;20d4 65
    halt                ;20d5 76
    ld l,c              ;20d6 69
    ld h,e              ;20d7 63
    ld h,l              ;20d8 65
    jr nz,l2149h        ;20d9 20 6e
    ld (hl),l           ;20db 75
l20dch:
    ld l,l              ;20dc 6d
    ld h,d              ;20dd 62
    ld h,l              ;20de 65
    ld (hl),d           ;20df 72
    jr nz,l2148h        ;20e0 20 66
    ld l,a              ;20e2 6f
    ld (hl),d           ;20e3 72
l20e4h:
    jr nz,l214ah        ;20e4 20 64
    ld (hl),d           ;20e6 72
    ld l,c              ;20e7 69
    halt                ;20e8 76
l20e9h:
    ld h,l              ;20e9 65
    jr nz,l212bh        ;20ea 20 3f
    jr nz,$+28          ;20ec 20 1a
    ret p               ;20ee f0
    jr nz,l2126h        ;20ef 20 35
    inc l               ;20f1 2c
l20f2h:
    jr nz,l2125h        ;20f2 20 31
    jr nc,l2116h        ;20f4 30 20
l20f6h:
    ld l,a              ;20f6 6f
    ld (hl),d           ;20f7 72
    jr nz,l212ch        ;20f8 20 32
    jr nc,l211ch        ;20fa 30 20
    ld c,l              ;20fc 4d
    ld h,d              ;20fd 62
    ld a,c              ;20fe 79
    ld (hl),h           ;20ff 74
    ld h,l              ;2100 65
    jr nz,l2167h        ;2101 20 64
    ld (hl),d           ;2103 72
    ld l,c              ;2104 69
    halt                ;2105 76
l2106h:
    ld h,l              ;2106 65
l2107h:
    jr nz,l2148h        ;2107 20 3f
    jr nz,$+39          ;2109 20 25
    dec c               ;210b 0d
    ld hl,l2833h        ;210c 21 33 28
    jr nc,l2145h        ;210f 30 34
    jr nc,l213ch        ;2111 30 29
    inc l               ;2113 2c
    jr nz,l214eh        ;2114 20 38
l2116h:
    jr z,l2148h         ;2116 28 30
    dec (hl)            ;2118 35
    jr nc,l2144h        ;2119 30 29
    inc l               ;211b 2c
l211ch:
    jr nz,l2186h        ;211c 20 68
    jr z,$+99           ;211e 28 61
    ld (hl),d           ;2120 72
    ld h,h              ;2121 64
    add hl,hl           ;2122 29
    jr nz,l2194h        ;2123 20 6f
l2125h:
    ld (hl),d           ;2125 72
l2126h:
    jr nz,$+119         ;2126 20 75
    jr z,l2198h         ;2128 28 6e
    ld (hl),l           ;212a 75
l212bh:
    ld (hl),e           ;212b 73
l212ch:
    ld h,l              ;212c 65
l212dh:
    ld h,h              ;212d 64
    add hl,hl           ;212e 29
    jr nz,l2170h        ;212f 20 3f
    jr nz,$+36          ;2131 20 22
    dec (hl)            ;2133 35
    ld hl,6c41h         ;2134 21 41 6c
    ld (hl),h           ;2137 74
    ld h,l              ;2138 65
    ld (hl),d           ;2139 72
    jr nz,$+121         ;213a 20 77
l213ch:
    ld l,b              ;213c 68
    ld l,c              ;213d 69
    ld h,e              ;213e 63
    ld l,b              ;213f 68
    jr nz,l21a6h        ;2140 20 64
    ld (hl),d           ;2142 72
    ld l,c              ;2143 69
l2144h:
    halt                ;2144 76
l2145h:
    ld h,l              ;2145 65
    jr nz,l21b8h        ;2146 20 70
l2148h:
    ld h,c              ;2148 61
l2149h:
    ld l,c              ;2149 69
l214ah:
    ld (hl),d           ;214a 72
    jr nz,l2175h        ;214b 20 28
    ld b,c              ;214d 41
l214eh:
    jr nz,l21c4h        ;214e 20 74
    ld l,a              ;2150 6f
    jr nz,l21a2h        ;2151 20 4f
    add hl,hl           ;2153 29
    jr nz,$+65          ;2154 20 3f
    jr nz,$+13          ;2156 20 0b
    ld e,d              ;2158 5a
    ld hl,l2c4fh        ;2159 21 4f 2c
    jr nz,$+82          ;215c 20 50
    jr nz,l219ah        ;215e 20 3a
    jr nz,l2182h        ;2160 20 20
    jr nz,$+34          ;2162 20 20
    jr nz,$+13          ;2164 20 0b
    ld l,b              ;2166 68
l2167h:
    ld hl,l2c4bh+2      ;2167 21 4d 2c
    jr nz,l21bah        ;216a 20 4e
    jr nz,l21a8h        ;216c 20 3a
    jr nz,l2190h        ;216e 20 20
l2170h:
    jr nz,$+34          ;2170 20 20
    jr nz,$+13          ;2172 20 0b
    halt                ;2174 76
l2175h:
    ld hl,l2c4bh        ;2175 21 4b 2c
    jr nz,l21c6h        ;2178 20 4c
    jr nz,l21b6h        ;217a 20 3a
    jr nz,l219eh        ;217c 20 20
    jr nz,$+34          ;217e 20 20
    jr nz,$+13          ;2180 20 0b
l2182h:
    add a,h             ;2182 84
    ld hl,2c49h         ;2183 21 49 2c
l2186h:
    jr nz,$+76          ;2186 20 4a
    jr nz,l21c4h        ;2188 20 3a
    jr nz,l21ach        ;218a 20 20
    jr nz,$+34          ;218c 20 20
    jr nz,$+13          ;218e 20 0b
l2190h:
    sub d               ;2190 92
    ld hl,l2c45h+2      ;2191 21 47 2c
l2194h:
    jr nz,l21deh        ;2194 20 48
    jr nz,$+60          ;2196 20 3a
l2198h:
    jr nz,l21bah        ;2198 20 20
l219ah:
    jr nz,$+34          ;219a 20 20
    jr nz,$+13          ;219c 20 0b
l219eh:
    and b               ;219e a0
    ld hl,l2c45h        ;219f 21 45 2c
l21a2h:
    jr nz,l21eah        ;21a2 20 46
    jr nz,l21e0h        ;21a4 20 3a
l21a6h:
    jr nz,l21c8h        ;21a6 20 20
l21a8h:
    jr nz,$+34          ;21a8 20 20
    jr nz,$+13          ;21aa 20 0b
l21ach:
    xor (hl)            ;21ac ae
    ld hl,sub_2c43h     ;21ad 21 43 2c
    jr nz,l21f6h        ;21b0 20 44
    jr nz,l21eeh        ;21b2 20 3a
    jr nz,$+34          ;21b4 20 20
l21b6h:
    jr nz,l21d8h        ;21b6 20 20
l21b8h:
    jr nz,$+13          ;21b8 20 0b
l21bah:
    cp h                ;21ba bc
    ld hl,2c41h         ;21bb 21 41 2c
    jr nz,l2202h        ;21be 20 42
    jr nz,l21fch        ;21c0 20 3a
    jr nz,l21e4h        ;21c2 20 20
l21c4h:
    jr nz,l21e6h        ;21c4 20 20
l21c6h:
    jr nz,l21e9h        ;21c6 20 21
l21c8h:
    jp z,2021h          ;21c8 ca 21 20
    jr nz,$+34          ;21cb 20 20
    jr nz,$+34          ;21cd 20 20
    jr nz,$+34          ;21cf 20 20
    jr nz,$+34          ;21d1 20 20
    jr nz,$+34          ;21d3 20 20
    jr nz,l2204h        ;21d5 20 2d
    dec l               ;21d7 2d
l21d8h:
    dec l               ;21d8 2d
    dec l               ;21d9 2d
    jr nz,l2209h        ;21da 20 2d
    dec l               ;21dc 2d
    dec l               ;21dd 2d
l21deh:
    dec l               ;21de 2d
    dec l               ;21df 2d
l21e0h:
    jr nz,l220fh        ;21e0 20 2d
    dec l               ;21e2 2d
    dec l               ;21e3 2d
l21e4h:
    dec l               ;21e4 2d
    dec l               ;21e5 2d
l21e6h:
    dec l               ;21e6 2d
    dec l               ;21e7 2d
    dec l               ;21e8 2d
l21e9h:
    dec l               ;21e9 2d
l21eah:
    dec l               ;21ea 2d
l21ebh:
    ld hl,l21eeh        ;21eb 21 ee 21
l21eeh:
    jr nz,l2210h        ;21ee 20 20
    jr nz,$+34          ;21f0 20 20
    jr nz,l2214h        ;21f2 20 20
    jr nz,l2216h        ;21f4 20 20
l21f6h:
    jr nz,$+34          ;21f6 20 20
    jr nz,l221ah        ;21f8 20 20
    ld b,h              ;21fa 44
    ld l,c              ;21fb 69
l21fch:
    ld (hl),e           ;21fc 73
    ld l,e              ;21fd 6b
    jr nz,$+102         ;21fe 20 64
    ld (hl),d           ;2200 72
    ld l,c              ;2201 69
l2202h:
    halt                ;2202 76
    ld h,l              ;2203 65
l2204h:
    jr nz,l2267h        ;2204 20 61
    ld (hl),e           ;2206 73
    ld (hl),e           ;2207 73
    ld l,c              ;2208 69
l2209h:
    ld h,a              ;2209 67
    ld l,(hl)           ;220a 6e
    ld l,l              ;220b 6d
    ld h,l              ;220c 65
    ld l,(hl)           ;220d 6e
    ld (hl),h           ;220e 74
l220fh:
    inc h               ;220f 24
l2210h:
    ld (de),a           ;2210 12
    ld (6857h),hl       ;2211 22 57 68
l2214h:
    ld l,c              ;2214 69
    ld h,e              ;2215 63
l2216h:
    ld l,b              ;2216 68
    jr nz,$+118         ;2217 20 74
    ld a,c              ;2219 79
l221ah:
    ld (hl),b           ;221a 70
    ld h,l              ;221b 65
    jr nz,$+113         ;221c 20 6f
    ld h,(hl)           ;221e 66
    jr nz,l2291h        ;221f 20 70
    ld (hl),d           ;2221 72
    ld l,c              ;2222 69
    ld l,(hl)           ;2223 6e
    ld (hl),h           ;2224 74
    ld h,l              ;2225 65
    ld (hl),d           ;2226 72
    jr nz,l2251h        ;2227 20 28
    inc sp              ;2229 33
    inc l               ;222a 2c
    jr nz,$+58          ;222b 20 38
    jr nz,$+113         ;222d 20 6f
    ld (hl),d           ;222f 72
    jr nz,$+70          ;2230 20 44
    add hl,hl           ;2232 29
    jr nz,$+65          ;2233 20 3f
    jr nz,l2254h        ;2235 20 1d
    add hl,sp           ;2237 39
    ld (2044h),hl       ;2238 22 44 20
    dec a               ;223b 3d
    jr nz,$+58          ;223c 20 38
    jr nc,l2272h        ;223e 30 32
    ld (hl),20h         ;2240 36 20
    ld l,a              ;2242 6f
    ld (hl),d           ;2243 72
    jr nz,$+58          ;2244 20 38
    jr nc,l227ah        ;2246 30 32
    scf                 ;2248 37
    jr nz,l2273h        ;2249 20 28
    ld h,h              ;224b 64
    ld h,c              ;224c 61
    ld l,c              ;224d 69
    ld (hl),e           ;224e 73
    ld a,c              ;224f 79
    ld (hl),a           ;2250 77
l2251h:
    ld l,b              ;2251 68
    ld h,l              ;2252 65
    ld h,l              ;2253 65
l2254h:
    ld l,h              ;2254 6c
    add hl,hl           ;2255 29
l2256h:
    ex af,af'           ;2256 08
    ld e,c              ;2257 59
    ld (l2038h),hl      ;2258 22 38 20
    dec a               ;225b 3d
    jr nz,$+58          ;225c 20 38
    jr nc,$+52          ;225e 30 32
    inc (hl)            ;2260 34
l2261h:
    inc e               ;2261 1c
    ld h,h              ;2262 64
    ld (l2032h+1),hl    ;2263 22 33 20
    dec a               ;2266 3d
l2267h:
    jr nz,l229ch        ;2267 20 33
    jr nc,l229dh        ;2269 30 32
    ld (l202ch),a       ;226b 32 2c 20
    inc sp              ;226e 33
    jr nc,$+52          ;226f 30 32
    inc sp              ;2271 33
l2272h:
    inc l               ;2272 2c
l2273h:
    jr nz,$+54          ;2273 20 34
    jr nc,$+52          ;2275 30 32
    ld (6f20h),a        ;2277 32 20 6f
l227ah:
    ld (hl),d           ;227a 72
    jr nz,l22b1h        ;227b 20 34
    jr nc,l22b1h        ;227d 30 32
    inc sp              ;227f 33
l2280h:
    inc de              ;2280 13
    add a,e             ;2281 83
    ld (l2854h),hl      ;2282 22 54 28
    ld d,h              ;2285 54
    ld e,c              ;2286 59
    ld a,(l2029h)       ;2287 3a 29 20
    ld l,a              ;228a 6f
    ld (hl),d           ;228b 72
    jr nz,l22deh        ;228c 20 50
    jr z,l22e4h         ;228e 28 54
    ld d,b              ;2290 50
l2291h:
    ld a,(l2029h)       ;2291 3a 29 20
    ccf                 ;2294 3f
    jr nz,l22aah        ;2295 20 13
    sbc a,c             ;2297 99
    ld (l2854h),hl      ;2298 22 54 28
    ld d,h              ;229b 54
l229ch:
    ld e,c              ;229c 59
l229dh:
    ld a,(l2029h)       ;229d 3a 29 20
    ld l,a              ;22a0 6f
    ld (hl),d           ;22a1 72
    jr nz,l22f4h        ;22a2 20 50
    jr z,$+86           ;22a4 28 54
    ld d,d              ;22a6 52
    ld a,(l2029h)       ;22a7 3a 29 20
l22aah:
    ccf                 ;22aa 3f
    jr nz,$+37          ;22ab 20 23
    xor a               ;22ad af
    ld (6857h),hl       ;22ae 22 57 68
l22b1h:
    ld l,c              ;22b1 69
    ld h,e              ;22b2 63
    ld l,b              ;22b3 68
    jr nz,$+110         ;22b4 20 6c
    ld l,c              ;22b6 69
    ld (hl),e           ;22b7 73
    ld (hl),h           ;22b8 74
    jr nz,l231fh        ;22b9 20 64
    ld h,l              ;22bb 65
    halt                ;22bc 76
    ld l,c              ;22bd 69
    ld h,e              ;22be 63
    ld h,l              ;22bf 65
    jr nz,l22eah        ;22c0 20 28
    ld d,h              ;22c2 54
    inc l               ;22c3 2c
    jr nz,$+69          ;22c4 20 43
    inc l               ;22c6 2c
    jr nz,$+78          ;22c7 20 4c
    jr nz,$+113         ;22c9 20 6f
    ld (hl),d           ;22cb 72
    jr nz,l2323h        ;22cc 20 55
    add hl,hl           ;22ce 29
    jr nz,l2310h        ;22cf 20 3f
    jr nz,l22f0h        ;22d1 20 1d
    push de             ;22d3 d5
    ld (l2855h),hl      ;22d4 22 55 28
    ld c,h              ;22d7 4c
    ld sp,293ah         ;22d8 31 3a 29
    jr nz,l230ah        ;22db 20 2d
    dec l               ;22dd 2d
l22deh:
    jr nz,l2300h        ;22de 20 20
    ld b,c              ;22e0 41
    ld d,e              ;22e1 53
    ld b,e              ;22e2 43
    ld c,c              ;22e3 49
l22e4h:
    ld c,c              ;22e4 49
    jr nz,$+75          ;22e5 20 49
    ld b,l              ;22e7 45
    ld b,l              ;22e8 45
    ld b,l              ;22e9 45
l22eah:
    jr nz,l235ch        ;22ea 20 70
    ld (hl),d           ;22ec 72
    ld l,c              ;22ed 69
    ld l,(hl)           ;22ee 6e
    ld (hl),h           ;22ef 74
l22f0h:
    ld h,l              ;22f0 65
    ld (hl),d           ;22f1 72
l22f2h:
    dec de              ;22f2 1b
    push af             ;22f3 f5
l22f4h:
    ld (l284ch),hl      ;22f4 22 4c 28
    ld d,b              ;22f7 50
    ld d,h              ;22f8 54
    ld a,(l2029h)       ;22f9 3a 29 20
    dec l               ;22fc 2d
    dec l               ;22fd 2d
    jr nz,l2320h        ;22fe 20 20
l2300h:
    ld d,b              ;2300 50
    ld b,l              ;2301 45
    ld d,h              ;2302 54
    jr nz,l234eh        ;2303 20 49
    ld b,l              ;2305 45
    ld b,l              ;2306 45
    ld b,l              ;2307 45
    jr nz,$+114         ;2308 20 70
l230ah:
    ld (hl),d           ;230a 72
    ld l,c              ;230b 69
    ld l,(hl)           ;230c 6e
    ld (hl),h           ;230d 74
    ld h,l              ;230e 65
    ld (hl),d           ;230f 72
l2310h:
    dec d               ;2310 15
    inc de              ;2311 13
    inc hl              ;2312 23
    ld b,e              ;2313 43
    jr z,l2368h         ;2314 28 52
    ld d,h              ;2316 54
    ld a,(l2029h)       ;2317 3a 29 20
    dec l               ;231a 2d
    dec l               ;231b 2d
    jr nz,l233eh        ;231c 20 20
    ld d,b              ;231e 50
l231fh:
    ld b,l              ;231f 45
l2320h:
    ld d,h              ;2320 54
    jr nz,$+117         ;2321 20 73
l2323h:
    ld h,e              ;2323 63
    ld (hl),d           ;2324 72
    ld h,l              ;2325 65
    ld h,l              ;2326 65
    ld l,(hl)           ;2327 6e
l2328h:
    jr $+45             ;2328 18 2b
    inc hl              ;232a 23
    ld d,h              ;232b 54
    jr z,l2382h         ;232c 28 54
l232eh:
    ld e,c              ;232e 59
    ld a,(l2029h)       ;232f 3a 29 20
    dec l               ;2332 2d
    dec l               ;2333 2d
    jr nz,l2356h        ;2334 20 20
    ld d,d              ;2336 52
    ld d,e              ;2337 53
    ld (3233h),a        ;2338 32 33 32
    jr nz,l23adh        ;233b 20 70
    ld (hl),d           ;233d 72
l233eh:
    ld l,c              ;233e 69
    ld l,(hl)           ;233f 6e
    ld (hl),h           ;2340 74
    ld h,l              ;2341 65
    ld (hl),d           ;2342 72
l2343h:
    rrca                ;2343 0f
    ld b,(hl)           ;2344 46
    inc hl              ;2345 23
    ld c,(hl)           ;2346 4e
    ld h,l              ;2347 65
    ld (hl),a           ;2348 77
    jr nz,l23afh        ;2349 20 64
    ld h,l              ;234b 65
    halt                ;234c 76
    ld l,c              ;234d 69
l234eh:
    ld h,e              ;234e 63
    ld h,l              ;234f 65
    jr nz,l2375h        ;2350 20 23
    jr nz,l2393h        ;2352 20 3f
    jr nz,$+22          ;2354 20 14
l2356h:
    ld e,b              ;2356 58
    inc hl              ;2357 23
    ld b,c              ;2358 41
    ld l,h              ;2359 6c
    ld (hl),h           ;235a 74
    ld h,l              ;235b 65
l235ch:
    ld (hl),d           ;235c 72
    jr nz,l23d6h        ;235d 20 77
    ld l,b              ;235f 68
    ld l,c              ;2360 69
    ld h,e              ;2361 63
    ld l,b              ;2362 68
    jr nz,l238dh        ;2363 20 28
    ld sp,382dh         ;2365 31 2d 38
l2368h:
    add hl,hl           ;2368 29
    jr nz,l23aah        ;2369 20 3f
    jr nz,l2371h        ;236b 20 04
    ld l,a              ;236d 6f
    inc hl              ;236e 23
    jr c,l23a1h         ;236f 38 30
l2371h:
    ld (0934h),a        ;2371 32 34 09
    halt                ;2374 76
l2375h:
    inc hl              ;2375 23
    jr c,l23a8h         ;2376 38 30
    ld (2f36h),a        ;2378 32 36 2f
    jr c,l23adh         ;237b 38 30
    ld (0937h),a        ;237d 32 37 09
    add a,d             ;2380 82
    inc hl              ;2381 23
l2382h:
    inc sp              ;2382 33
    jr nc,l23b7h        ;2383 30 32
    ld (342fh),a        ;2385 32 2f 34
    jr nc,l23bch        ;2388 30 32
    ld (8e1eh),a        ;238a 32 1e 8e
l238dh:
    inc hl              ;238d 23
    jr c,l23beh         ;238e 38 2e
    jr nz,l23b2h        ;2390 20 20
    ld d,b              ;2392 50
l2393h:
    ld b,l              ;2393 45
    ld d,h              ;2394 54
    jr nz,l2407h        ;2395 20 70
    ld (hl),d           ;2397 72
    ld l,c              ;2398 69
    ld l,(hl)           ;2399 6e
    ld (hl),h           ;239a 74
    ld h,l              ;239b 65
    ld (hl),d           ;239c 72
    jr nz,l2413h        ;239d 20 74
    ld a,c              ;239f 79
    ld (hl),b           ;23a0 70
l23a1h:
    ld h,l              ;23a1 65
    jr nz,l23deh        ;23a2 20 3a
    jr nz,$+34          ;23a4 20 20
    jr nz,l23c8h        ;23a6 20 20
l23a8h:
    jr nz,l23cah        ;23a8 20 20
l23aah:
    jr nz,l23cch        ;23aa 20 20
l23ach:
    inc b               ;23ac 04
l23adh:
    xor a               ;23ad af
    inc hl              ;23ae 23
l23afh:
    ld d,b              ;23af 50
    ld d,h              ;23b0 54
    ld d,b              ;23b1 50
l23b2h:
    ld a,(0b61eh)       ;23b2 3a 1e b6
    inc hl              ;23b5 23
    scf                 ;23b6 37
l23b7h:
    ld l,20h            ;23b7 2e 20
    jr nz,l23ffh        ;23b9 20 44
    ld h,l              ;23bb 65
l23bch:
    ld h,(hl)           ;23bc 66
    ld h,c              ;23bd 61
l23beh:
    ld (hl),l           ;23be 75
    ld l,h              ;23bf 6c
    ld (hl),h           ;23c0 74
    jr nz,l2413h        ;23c1 20 50
    ld d,l              ;23c3 55
    ld c,(hl)           ;23c4 4e
    ld a,(6420h)        ;23c5 3a 20 64
l23c8h:
    ld h,l              ;23c8 65
    halt                ;23c9 76
l23cah:
    ld l,c              ;23ca 69
    ld h,e              ;23cb 63
l23cch:
    ld h,l              ;23cc 65
    jr nz,l2409h        ;23cd 20 3a
    jr nz,l23f1h        ;23cf 20 20
    jr nz,l23f3h        ;23d1 20 20
    jr nz,l23d9h        ;23d3 20 04
    rst 10h             ;23d5 d7
l23d6h:
    inc hl              ;23d6 23
    ld d,b              ;23d7 50
    ld d,h              ;23d8 54
l23d9h:
    ld d,d              ;23d9 52
    ld a,(0de1eh)       ;23da 3a 1e de
    inc hl              ;23dd 23
l23deh:
    ld (hl),2eh         ;23de 36 2e
    jr nz,$+34          ;23e0 20 20
    ld b,h              ;23e2 44
    ld h,l              ;23e3 65
    ld h,(hl)           ;23e4 66
    ld h,c              ;23e5 61
    ld (hl),l           ;23e6 75
    ld l,h              ;23e7 6c
    ld (hl),h           ;23e8 74
    jr nz,l243dh        ;23e9 20 52
    ld b,h              ;23eb 44
    ld d,d              ;23ec 52
    ld a,(6420h)        ;23ed 3a 20 64
    ld h,l              ;23f0 65
l23f1h:
    halt                ;23f1 76
    ld l,c              ;23f2 69
l23f3h:
    ld h,e              ;23f3 63
    ld h,l              ;23f4 65
    jr nz,l2431h        ;23f5 20 3a
    jr nz,$+34          ;23f7 20 20
    jr nz,l241bh        ;23f9 20 20
    jr nz,l2401h        ;23fb 20 04
    rst 38h             ;23fd ff
    inc hl              ;23fe 23
l23ffh:
    ld d,l              ;23ff 55
    ld c,h              ;2400 4c
l2401h:
    ld sp,l043ah        ;2401 31 3a 04
    ld b,24h            ;2404 06 24
    ld c,h              ;2406 4c
l2407h:
    ld d,b              ;2407 50
    ld d,h              ;2408 54
l2409h:
    ld a,(l0d04h)       ;2409 3a 04 0d
    inc h               ;240c 24
    ld b,e              ;240d 43
    ld d,d              ;240e 52
    ld d,h              ;240f 54
    ld a,(l1404h)       ;2410 3a 04 14
l2413h:
    inc h               ;2413 24
    ld d,h              ;2414 54
    ld d,h              ;2415 54
    ld e,c              ;2416 59
    ld a,(l1b1eh)       ;2417 3a 1e 1b
    inc h               ;241a 24
l241bh:
    dec (hl)            ;241b 35
    ld l,20h            ;241c 2e 20
    jr nz,l2464h        ;241e 20 44
    ld h,l              ;2420 65
    ld h,(hl)           ;2421 66
    ld h,c              ;2422 61
    ld (hl),l           ;2423 75
    ld l,h              ;2424 6c
    ld (hl),h           ;2425 74
    jr nz,l2474h        ;2426 20 4c
    ld d,e              ;2428 53
    ld d,h              ;2429 54
    ld a,(6420h)        ;242a 3a 20 64
    ld h,l              ;242d 65
    halt                ;242e 76
    ld l,c              ;242f 69
    ld h,e              ;2430 63
l2431h:
    ld h,l              ;2431 65
    jr nz,l246eh        ;2432 20 3a
    jr nz,l2456h        ;2434 20 20
    jr nz,l2458h        ;2436 20 20
    jr nz,l2458h        ;2438 20 1e
    inc a               ;243a 3c
    inc h               ;243b 24
    inc (hl)            ;243c 34
l243dh:
    ld l,20h            ;243d 2e 20
    jr nz,l2491h        ;243f 20 50
    ld (hl),l           ;2441 75
    ld l,(hl)           ;2442 6e
    ld h,e              ;2443 63
    ld l,b              ;2444 68
    jr nz,l24abh        ;2445 20 64
    ld h,l              ;2447 65
    halt                ;2448 76
    ld l,c              ;2449 69
    ld h,e              ;244a 63
    ld h,l              ;244b 65
    jr nz,$+37          ;244c 20 23
    jr nz,l248ah        ;244e 20 3a
    jr nz,l2472h        ;2450 20 20
    jr nz,l2474h        ;2452 20 20
    jr nz,l2476h        ;2454 20 20
l2456h:
    jr nz,l2478h        ;2456 20 20
l2458h:
    jr nz,l247ah        ;2458 20 20
l245ah:
    ld e,5dh            ;245a 1e 5d
    inc h               ;245c 24
    inc sp              ;245d 33
    ld l,20h            ;245e 2e 20
    jr nz,l24b4h        ;2460 20 52
    ld h,l              ;2462 65
    ld h,c              ;2463 61
l2464h:
    ld h,h              ;2464 64
    ld h,l              ;2465 65
    ld (hl),d           ;2466 72
    jr nz,$+102         ;2467 20 64
    ld h,l              ;2469 65
    halt                ;246a 76
    ld l,c              ;246b 69
    ld h,e              ;246c 63
    ld h,l              ;246d 65
l246eh:
    jr nz,l2493h        ;246e 20 23
    jr nz,l24ach        ;2470 20 3a
l2472h:
    jr nz,l2494h        ;2472 20 20
l2474h:
    jr nz,l2496h        ;2474 20 20
l2476h:
    jr nz,l2498h        ;2476 20 20
l2478h:
    jr nz,l249ah        ;2478 20 20
l247ah:
    jr nz,l249ah        ;247a 20 1e
    ld a,(hl)           ;247c 7e
    inc h               ;247d 24
    ld (l202eh),a       ;247e 32 2e 20
    jr nz,l24c4h        ;2481 20 41
    ld d,e              ;2483 53
    ld b,e              ;2484 43
    ld c,c              ;2485 49
    ld c,c              ;2486 49
    jr nz,l24f9h        ;2487 20 70
    ld (hl),d           ;2489 72
l248ah:
    ld l,c              ;248a 69
    ld l,(hl)           ;248b 6e
    ld (hl),h           ;248c 74
    ld h,l              ;248d 65
    ld (hl),d           ;248e 72
    jr nz,l24f5h        ;248f 20 64
l2491h:
    ld h,l              ;2491 65
    halt                ;2492 76
l2493h:
    ld l,c              ;2493 69
l2494h:
    ld h,e              ;2494 63
    ld h,l              ;2495 65
l2496h:
    jr nz,l24bbh        ;2496 20 23
l2498h:
    jr nz,l24d4h        ;2498 20 3a
l249ah:
    jr nz,$+34          ;249a 20 20
l249ch:
    ld e,9fh            ;249c 1e 9f
    inc h               ;249e 24
    ld sp,l202eh        ;249f 31 2e 20
    jr nz,l24f4h        ;24a2 20 50
    ld h,l              ;24a4 65
    ld (hl),h           ;24a5 74
    jr nz,l2518h        ;24a6 20 70
    ld (hl),d           ;24a8 72
    ld l,c              ;24a9 69
    ld l,(hl)           ;24aa 6e
l24abh:
    ld (hl),h           ;24ab 74
l24ach:
    ld h,l              ;24ac 65
    ld (hl),d           ;24ad 72
    jr nz,l2514h        ;24ae 20 64
    ld h,l              ;24b0 65
    halt                ;24b1 76
    ld l,c              ;24b2 69
    ld h,e              ;24b3 63
l24b4h:
    ld h,l              ;24b4 65
    jr nz,l24dah        ;24b5 20 23
    jr nz,l24f3h        ;24b7 20 3a
    jr nz,l24dbh        ;24b9 20 20
l24bbh:
    jr nz,l24ddh        ;24bb 20 20
l24bdh:
    ld (l24c0h),hl      ;24bd 22 c0 24
l24c0h:
    jr nz,l24e2h        ;24c0 20 20
    jr nz,$+34          ;24c2 20 20
l24c4h:
    jr nz,$+34          ;24c4 20 20
    jr nz,$+34          ;24c6 20 20
    jr nz,$+34          ;24c8 20 20
    jr nz,$+34          ;24ca 20 20
    jr nz,l24fbh        ;24cc 20 2d
    dec l               ;24ce 2d
    dec l               ;24cf 2d
    jr nz,l24ffh        ;24d0 20 2d
    dec l               ;24d2 2d
    dec l               ;24d3 2d
l24d4h:
    dec l               ;24d4 2d
    dec l               ;24d5 2d
    dec l               ;24d6 2d
    jr nz,l2506h        ;24d7 20 2d
    dec l               ;24d9 2d
l24dah:
    dec l               ;24da 2d
l24dbh:
    dec l               ;24db 2d
    dec l               ;24dc 2d
l24ddh:
    dec l               ;24dd 2d
    dec l               ;24de 2d
    dec l               ;24df 2d
    dec l               ;24e0 2d
    dec l               ;24e1 2d
l24e2h:
    ld (l24e5h),hl      ;24e2 22 e5 24
l24e5h:
    jr nz,l2507h        ;24e5 20 20
    jr nz,l2509h        ;24e7 20 20
    jr nz,$+34          ;24e9 20 20
    jr nz,l250dh        ;24eb 20 20
    jr nz,l250fh        ;24ed 20 20
    jr nz,l2511h        ;24ef 20 20
    jr nz,$+75          ;24f1 20 49
l24f3h:
    cpl                 ;24f3 2f
l24f4h:
    ld c,a              ;24f4 4f
l24f5h:
    jr nz,l255bh        ;24f5 20 64
    ld h,l              ;24f7 65
    halt                ;24f8 76
l24f9h:
    ld l,c              ;24f9 69
    ld h,e              ;24fa 63
l24fbh:
    ld h,l              ;24fb 65
    jr nz,l255fh        ;24fc 20 61
    ld (hl),e           ;24fe 73
l24ffh:
    ld (hl),e           ;24ff 73
    ld l,c              ;2500 69
    ld h,a              ;2501 67
    ld l,(hl)           ;2502 6e
    ld l,l              ;2503 6d
    ld h,l              ;2504 65
    ld l,(hl)           ;2505 6e
l2506h:
    ld (hl),h           ;2506 74
l2507h:
    dec c               ;2507 0d
    ld a,(bc)           ;2508 0a
l2509h:
    dec h               ;2509 25
    ld sp,3239h         ;250a 31 39 32
l250dh:
    jr nc,l253fh        ;250d 30 30
l250fh:
    jr nz,$+100         ;250f 20 62
l2511h:
    ld h,c              ;2511 61
    ld (hl),l           ;2512 75
    ld h,h              ;2513 64
l2514h:
    jr nz,l2555h        ;2514 20 3f
    jr nz,l2535h        ;2516 20 1d
l2518h:
    ld a,(de)           ;2518 1a
    dec h               ;2519 25
    ld sp,3031h         ;251a 31 31 30
    inc l               ;251d 2c
    jr nz,l2553h        ;251e 20 33
    jr nc,l2552h        ;2520 30 30
    inc l               ;2522 2c
    jr nz,l2556h        ;2523 20 31
    ld (3030h),a        ;2525 32 30 30
    inc l               ;2528 2c
    jr nz,l255fh        ;2529 20 34
    jr c,l255dh         ;252b 38 30
    jr nc,l255bh        ;252d 30 2c
    jr nz,l256ah        ;252f 20 39
    ld (hl),30h         ;2531 36 30
    jr nc,l2555h        ;2533 30 20
l2535h:
    ld l,a              ;2535 6f
    ld (hl),d           ;2536 72
l2537h:
    rra                 ;2537 1f
    ld a,(4f25h)        ;2538 3a 25 4f
    jr z,l25a1h         ;253b 28 64
    ld h,h              ;253d 64
    add hl,hl           ;253e 29
l253fh:
    inc l               ;253f 2c
    jr nz,l2587h        ;2540 20 45
    jr z,l25bah         ;2542 28 76
    ld h,l              ;2544 65
    ld l,(hl)           ;2545 6e
    add hl,hl           ;2546 29
    jr nz,l25b8h        ;2547 20 6f
    ld (hl),d           ;2549 72
    jr nz,$+80          ;254a 20 4e
    jr z,$+113          ;254c 28 6f
    jr nz,$+114         ;254e 20 70
    ld h,c              ;2550 61
    ld (hl),d           ;2551 72
l2552h:
    ld l,c              ;2552 69
l2553h:
    ld (hl),h           ;2553 74
    ld a,c              ;2554 79
l2555h:
    add hl,hl           ;2555 29
l2556h:
    jr nz,$+65          ;2556 20 3f
    jr nz,l257ah        ;2558 20 20
    ld e,h              ;255a 5c
l255bh:
    dec h               ;255b 25
    ld c,(hl)           ;255c 4e
l255dh:
    ld (hl),l           ;255d 75
    ld l,l              ;255e 6d
l255fh:
    ld h,d              ;255f 62
    ld h,l              ;2560 65
    ld (hl),d           ;2561 72
    jr nz,$+113         ;2562 20 6f
    ld h,(hl)           ;2564 66
    jr nz,l25dah        ;2565 20 73
    ld (hl),h           ;2567 74
    ld l,a              ;2568 6f
    ld (hl),b           ;2569 70
l256ah:
    jr nz,l25ceh        ;256a 20 62
    ld l,c              ;256c 69
    ld (hl),h           ;256d 74
    ld (hl),e           ;256e 73
    jr nz,l2599h        ;256f 20 28
    ld sp,6f20h         ;2571 31 20 6f
    ld (hl),d           ;2574 72
    jr nz,l25a9h        ;2575 20 32
    add hl,hl           ;2577 29
    jr nz,$+34          ;2578 20 20
l257ah:
    ccf                 ;257a 3f
    jr nz,$+34          ;257b 20 20
    ld a,a              ;257d 7f
    dec h               ;257e 25
    ld c,(hl)           ;257f 4e
    ld h,l              ;2580 65
    ld (hl),a           ;2581 77
    jr nz,$+101         ;2582 20 63
    ld l,b              ;2584 68
    ld h,c              ;2585 61
    ld (hl),d           ;2586 72
l2587h:
    ld h,c              ;2587 61
    ld h,e              ;2588 63
    ld (hl),h           ;2589 74
    ld h,l              ;258a 65
    ld (hl),d           ;258b 72
    jr nz,l25fah        ;258c 20 6c
    ld h,l              ;258e 65
    ld l,(hl)           ;258f 6e
    ld h,a              ;2590 67
    ld (hl),h           ;2591 74
    ld l,b              ;2592 68
    jr nz,$+42          ;2593 20 28
    dec (hl)            ;2595 35
    jr nz,$+118         ;2596 20 74
    ld l,a              ;2598 6f
l2599h:
    jr nz,$+58          ;2599 20 38
    add hl,hl           ;259b 29
    jr nz,$+65          ;259c 20 3f
    jr nz,$+37          ;259e 20 23
    and d               ;25a0 a2
l25a1h:
    dec h               ;25a1 25
    ld b,c              ;25a2 41
    ld l,h              ;25a3 6c
    ld (hl),h           ;25a4 74
    ld h,l              ;25a5 65
    ld (hl),d           ;25a6 72
    jr nz,l2620h        ;25a7 20 77
l25a9h:
    ld l,b              ;25a9 68
    ld l,c              ;25aa 69
    ld h,e              ;25ab 63
    ld l,b              ;25ac 68
    jr nz,l2612h        ;25ad 20 63
    ld l,b              ;25af 68
    ld h,c              ;25b0 61
    ld (hl),d           ;25b1 72
    ld h,c              ;25b2 61
    ld h,e              ;25b3 63
    ld (hl),h           ;25b4 74
    ld h,l              ;25b5 65
    ld (hl),d           ;25b6 72
    ld l,c              ;25b7 69
l25b8h:
    ld (hl),e           ;25b8 73
    ld (hl),h           ;25b9 74
l25bah:
    ld l,c              ;25ba 69
    ld h,e              ;25bb 63
    jr nz,l25e6h        ;25bc 20 28
    ld sp,342dh         ;25be 31 2d 34
    add hl,hl           ;25c1 29
    jr nz,l2603h        ;25c2 20 3f
    jr nz,$+6           ;25c4 20 04
    ret z               ;25c6 c8
    dec h               ;25c7 25
    inc (hl)            ;25c8 34
    jr c,$+50           ;25c9 38 30
    jr nc,l25d2h        ;25cb 30 05
    rst 8               ;25cd cf
l25ceh:
    dec h               ;25ce 25
    ld sp,3239h         ;25cf 31 39 32
l25d2h:
    jr nc,$+50          ;25d2 30 30
l25d4h:
    inc b               ;25d4 04
    rst 10h             ;25d5 d7
    dec h               ;25d6 25
    add hl,sp           ;25d7 39
    ld (hl),30h         ;25d8 36 30
l25dah:
    jr nc,$+6           ;25da 30 04
    sbc a,25h           ;25dc de 25
    ld sp,3032h         ;25de 31 32 30
    jr nc,l25e6h        ;25e1 30 03
    push hl             ;25e3 e5
    dec h               ;25e4 25
    inc sp              ;25e5 33
l25e6h:
    jr nc,l2618h        ;25e6 30 30
l25e8h:
    inc bc              ;25e8 03
    ex de,hl            ;25e9 eb
    dec h               ;25ea 25
    ld sp,3031h         ;25eb 31 31 30
l25eeh:
    rra                 ;25ee 1f
    pop af              ;25ef f1
    dec h               ;25f0 25
    jr nz,$+54          ;25f1 20 34
    ld l,20h            ;25f3 2e 20
    jr nz,$+68          ;25f5 20 42
    ld h,c              ;25f7 61
    ld (hl),l           ;25f8 75
    ld h,h              ;25f9 64
l25fah:
    jr nz,l266eh        ;25fa 20 72
    ld h,c              ;25fc 61
    ld (hl),h           ;25fd 74
    ld h,l              ;25fe 65
    jr nz,$+60          ;25ff 20 3a
    jr nz,l2623h        ;2601 20 20
l2603h:
    jr nz,l2625h        ;2603 20 20
    jr nz,$+34          ;2605 20 20
    jr nz,l2629h        ;2607 20 20
    jr nz,l262bh        ;2609 20 20
    jr nz,l262dh        ;260b 20 20
    jr nz,l262fh        ;260d 20 20
    jr nz,l2614h        ;260f 20 03
    inc de              ;2611 13
l2612h:
    ld h,6fh            ;2612 26 6f
l2614h:
    ld h,h              ;2614 64
    ld h,h              ;2615 64
l2616h:
    inc b               ;2616 04
    add hl,de           ;2617 19
l2618h:
    ld h,65h            ;2618 26 65
    halt                ;261a 76
    ld h,l              ;261b 65
    ld l,(hl)           ;261c 6e
l261dh:
    inc b               ;261d 04
    jr nz,l2646h        ;261e 20 26
l2620h:
    ld l,(hl)           ;2620 6e
    ld l,a              ;2621 6f
    ld l,(hl)           ;2622 6e
l2623h:
    ld h,l              ;2623 65
l2624h:
    rra                 ;2624 1f
l2625h:
    daa                 ;2625 27
    ld h,20h            ;2626 26 20
    inc sp              ;2628 33
l2629h:
    ld l,20h            ;2629 2e 20
l262bh:
    jr nz,l267dh        ;262b 20 50
l262dh:
    ld h,c              ;262d 61
    ld (hl),d           ;262e 72
l262fh:
    ld l,c              ;262f 69
    ld (hl),h           ;2630 74
    ld a,c              ;2631 79
    jr nz,l266eh        ;2632 20 3a
    jr nz,l2656h        ;2634 20 20
    jr nz,l2658h        ;2636 20 20
    jr nz,l265ah        ;2638 20 20
    jr nz,l265ch        ;263a 20 20
    jr nz,l265eh        ;263c 20 20
    jr nz,l2660h        ;263e 20 20
    jr nz,l2662h        ;2640 20 20
    jr nz,l2664h        ;2642 20 20
    jr nz,$+34          ;2644 20 20
l2646h:
    ld bc,l2649h        ;2646 01 49 26
l2649h:
    ld (4d03h),a        ;2649 32 03 4d
    ld h,31h            ;264c 26 31
    ld l,35h            ;264e 2e 35
l2650h:
    ld bc,l2653h        ;2650 01 53 26
l2653h:
    ld sp,5709h         ;2653 31 09 57
l2656h:
    ld h,75h            ;2656 26 75
l2658h:
    ld l,(hl)           ;2658 6e
    ld h,h              ;2659 64
l265ah:
    ld h,l              ;265a 65
    ld h,(hl)           ;265b 66
l265ch:
    ld l,c              ;265c 69
    ld l,(hl)           ;265d 6e
l265eh:
    ld h,l              ;265e 65
    ld h,h              ;265f 64
l2660h:
    rra                 ;2660 1f
    ld h,e              ;2661 63
l2662h:
    ld h,20h            ;2662 26 20
l2664h:
    ld (l202eh),a       ;2664 32 2e 20
    jr nz,l26b7h        ;2667 20 4e
    ld (hl),l           ;2669 75
    ld l,l              ;266a 6d
    ld h,d              ;266b 62
    ld h,l              ;266c 65
    ld (hl),d           ;266d 72
l266eh:
    jr nz,l26dfh        ;266e 20 6f
    ld h,(hl)           ;2670 66
    jr nz,l26e6h        ;2671 20 73
    ld (hl),h           ;2673 74
    ld l,a              ;2674 6f
    ld (hl),b           ;2675 70
    jr nz,l26dah        ;2676 20 62
    ld l,c              ;2678 69
    ld (hl),h           ;2679 74
    ld (hl),e           ;267a 73
    jr nz,l26b7h        ;267b 20 3a
l267dh:
    jr nz,$+34          ;267d 20 20
    jr nz,$+34          ;267f 20 20
    jr nz,l26a2h        ;2681 20 1f
    add a,l             ;2683 85
    ld h,20h            ;2684 26 20
    ld sp,l202eh        ;2686 31 2e 20
    jr nz,$+69          ;2689 20 43
    ld l,b              ;268b 68
    ld h,c              ;268c 61
    ld (hl),d           ;268d 72
    ld h,c              ;268e 61
    ld h,e              ;268f 63
    ld (hl),h           ;2690 74
    ld h,l              ;2691 65
    ld (hl),d           ;2692 72
l2693h:
    jr nz,l2708h        ;2693 20 73
    ld l,c              ;2695 69
    ld a,d              ;2696 7a
    ld h,l              ;2697 65
    jr nz,$+60          ;2698 20 3a
    jr nz,l26bch        ;269a 20 20
    jr nz,l26beh        ;269c 20 20
    jr nz,l26c0h        ;269e 20 20
    jr nz,l26c2h        ;26a0 20 20
l26a2h:
    jr nz,l26c4h        ;26a2 20 20
l26a4h:
    jr nz,$-87          ;26a4 20 a7
    ld h,20h            ;26a6 26 20
    jr nz,$+34          ;26a8 20 20
    jr nz,$+34          ;26aa 20 20
    jr nz,$+34          ;26ac 20 20
    jr nz,$+34          ;26ae 20 20
    jr nz,$+34          ;26b0 20 20
    dec l               ;26b2 2d
    dec l               ;26b3 2d
    dec l               ;26b4 2d
    dec l               ;26b5 2d
    dec l               ;26b6 2d
l26b7h:
    jr nz,l26e6h        ;26b7 20 2d
    dec l               ;26b9 2d
    dec l               ;26ba 2d
    dec l               ;26bb 2d
l26bch:
    dec l               ;26bc 2d
    dec l               ;26bd 2d
l26beh:
    dec l               ;26be 2d
    dec l               ;26bf 2d
l26c0h:
    dec l               ;26c0 2d
    dec l               ;26c1 2d
l26c2h:
    dec l               ;26c2 2d
    dec l               ;26c3 2d
l26c4h:
    dec l               ;26c4 2d
    dec l               ;26c5 2d
    dec l               ;26c6 2d
l26c7h:
    jr nz,l2693h        ;26c7 20 ca
    ld h,20h            ;26c9 26 20
    jr nz,$+34          ;26cb 20 20
    jr nz,l26efh        ;26cd 20 20
    jr nz,l26f1h        ;26cf 20 20
    jr nz,l26f3h        ;26d1 20 20
    jr nz,l26f5h        ;26d3 20 20
    ld d,d              ;26d5 52
    ld d,e              ;26d6 53
    ld (3233h),a        ;26d7 32 33 32
l26dah:
    jr nz,$+69          ;26da 20 43
    ld l,b              ;26dc 68
    ld h,c              ;26dd 61
    ld (hl),d           ;26de 72
l26dfh:
    ld h,c              ;26df 61
    ld h,e              ;26e0 63
    ld (hl),h           ;26e1 74
    ld h,l              ;26e2 65
    ld (hl),d           ;26e3 72
    ld l,c              ;26e4 69
    ld (hl),e           ;26e5 73
l26e6h:
    ld (hl),h           ;26e6 74
    ld l,c              ;26e7 69
    ld h,e              ;26e8 63
    ld (hl),e           ;26e9 73
l26eah:
    ld h,0edh           ;26ea 26 ed
    ld h,50h            ;26ec 26 50
    ld l,h              ;26ee 6c
l26efh:
    ld h,l              ;26ef 65
    ld h,c              ;26f0 61
l26f1h:
    ld (hl),e           ;26f1 73
    ld h,l              ;26f2 65
l26f3h:
    jr nz,l275ah        ;26f3 20 65
l26f5h:
    ld l,(hl)           ;26f5 6e
    ld (hl),h           ;26f6 74
    ld h,l              ;26f7 65
    ld (hl),d           ;26f8 72
    jr nz,l276fh        ;26f9 20 74
    ld l,b              ;26fb 68
    ld h,l              ;26fc 65
    jr nz,l2760h        ;26fd 20 61
    ld (hl),b           ;26ff 70
    ld (hl),b           ;2700 70
    ld (hl),d           ;2701 72
    ld l,a              ;2702 6f
    ld (hl),b           ;2703 70
    ld (hl),d           ;2704 72
    ld l,c              ;2705 69
    ld h,c              ;2706 61
    ld (hl),h           ;2707 74
l2708h:
    ld h,l              ;2708 65
    jr nz,l2777h        ;2709 20 6c
    ld h,l              ;270b 65
    ld (hl),h           ;270c 74
    ld (hl),h           ;270d 74
    ld h,l              ;270e 65
    ld (hl),d           ;270f 72
l2710h:
    jr nz,l274ch        ;2710 20 3a
    jr nz,l2729h        ;2712 20 15
    ld d,27h            ;2714 16 27
sub_2716h:
    ld d,c              ;2716 51
    jr nz,l2746h        ;2717 20 2d
    jr nz,l276ch        ;2719 20 51
    ld (hl),l           ;271b 75
    ld l,c              ;271c 69
    ld (hl),h           ;271d 74
    jr nz,l2794h        ;271e 20 74
    ld l,b              ;2720 68
    ld l,c              ;2721 69
    ld (hl),e           ;2722 73
    jr nz,l2795h        ;2723 20 70
    ld (hl),d           ;2725 72
    ld l,a              ;2726 6f
    ld h,a              ;2727 67
    ld (hl),d           ;2728 72
l2729h:
    ld h,c              ;2729 61
    ld l,l              ;272a 6d
l272bh:
    ld d,2eh            ;272b 16 2e
    daa                 ;272d 27
    ld b,l              ;272e 45
    jr nz,l275eh        ;272f 20 2d
    jr nz,l2778h        ;2731 20 45
    ld a,b              ;2733 78
    ld h,l              ;2734 65
    ld h,e              ;2735 63
    ld (hl),l           ;2736 75
    ld (hl),h           ;2737 74
    ld h,l              ;2738 65
    jr nz,l27a9h        ;2739 20 6e
    ld h,l              ;273b 65
    ld (hl),a           ;273c 77
sub_273dh:
    jr nz,l27b2h        ;273d 20 73
    ld a,c              ;273f 79
    ld (hl),e           ;2740 73
    ld (hl),h           ;2741 74
    ld h,l              ;2742 65
    ld l,l              ;2743 6d
l2744h:
    inc de              ;2744 13
    ld b,a              ;2745 47
l2746h:
    daa                 ;2746 27
    ld d,e              ;2747 53
    jr nz,l2777h        ;2748 20 2d
    jr nz,$+85          ;274a 20 53
l274ch:
    ld h,c              ;274c 61
    halt                ;274d 76
    ld h,l              ;274e 65
    jr nz,l27bfh        ;274f 20 6e
    ld h,l              ;2751 65
    ld (hl),a           ;2752 77
    jr nz,l27c8h        ;2753 20 73
    ld a,c              ;2755 79
    ld (hl),e           ;2756 73
    ld (hl),h           ;2757 74
    ld h,l              ;2758 65
    ld l,l              ;2759 6d
l275ah:
    add hl,de           ;275a 19
    ld e,l              ;275b 5d
    daa                 ;275c 27
l275dh:
    ld d,d              ;275d 52
l275eh:
    jr nz,l278dh        ;275e 20 2d
l2760h:
    jr nz,l27b4h        ;2760 20 52
    ld d,e              ;2762 53
    ld (3233h),a        ;2763 32 33 32
    jr nz,l27cbh        ;2766 20 63
    ld l,b              ;2768 68
    ld h,c              ;2769 61
    ld (hl),d           ;276a 72
    ld h,c              ;276b 61
l276ch:
    ld h,e              ;276c 63
    ld (hl),h           ;276d 74
    ld h,l              ;276e 65
l276fh:
    ld (hl),d           ;276f 72
    ld l,c              ;2770 69
    ld (hl),e           ;2771 73
    ld (hl),h           ;2772 74
    ld l,c              ;2773 69
    ld h,e              ;2774 63
    ld (hl),e           ;2775 73
l2776h:
    dec de              ;2776 1b
l2777h:
    ld a,c              ;2777 79
l2778h:
    daa                 ;2778 27
    ld d,b              ;2779 50
    jr nz,l27a9h        ;277a 20 2d
    jr nz,l27ceh        ;277c 20 50
    ld b,l              ;277e 45
    ld d,h              ;277f 54
    jr nz,$+118         ;2780 20 74
    ld h,l              ;2782 65
    ld (hl),d           ;2783 72
    ld l,l              ;2784 6d
    ld l,c              ;2785 69
    ld l,(hl)           ;2786 6e
    ld h,c              ;2787 61
    ld l,h              ;2788 6c
    jr nz,l27fbh        ;2789 20 70
    ld h,c              ;278b 61
    ld (hl),d           ;278c 72
l278dh:
    ld h,c              ;278d 61
    ld l,l              ;278e 6d
    ld h,l              ;278f 65
    ld (hl),h           ;2790 74
    ld h,l              ;2791 65
    ld (hl),d           ;2792 72
    ld (hl),e           ;2793 73
l2794h:
    ld (de),a           ;2794 12
l2795h:
    sub a               ;2795 97
    daa                 ;2796 27
    ld c,c              ;2797 49
    jr nz,l27c7h        ;2798 20 2d
    jr nz,l27e5h        ;279a 20 49
    cpl                 ;279c 2f
    ld c,a              ;279d 4f
    jr nz,l2801h        ;279e 20 61
    ld (hl),e           ;27a0 73
    ld (hl),e           ;27a1 73
    ld l,c              ;27a2 69
    ld h,a              ;27a3 67
    ld l,(hl)           ;27a4 6e
    ld l,l              ;27a5 6d
    ld h,l              ;27a6 65
    ld l,(hl)           ;27a7 6e
    ld (hl),h           ;27a8 74
l27a9h:
    add hl,de           ;27a9 19
    xor h               ;27aa ac
    daa                 ;27ab 27
    ld b,h              ;27ac 44
    jr nz,l27dch        ;27ad 20 2d
    jr nz,l27f5h        ;27af 20 44
    ld l,c              ;27b1 69
l27b2h:
    ld (hl),e           ;27b2 73
    ld l,e              ;27b3 6b
l27b4h:
    jr nz,l281ah        ;27b4 20 64
    ld (hl),d           ;27b6 72
    ld l,c              ;27b7 69
    halt                ;27b8 76
    ld h,l              ;27b9 65
    jr nz,l281dh        ;27ba 20 61
    ld (hl),e           ;27bc 73
    ld (hl),e           ;27bd 73
    ld l,c              ;27be 69
l27bfh:
    ld h,a              ;27bf 67
    ld l,(hl)           ;27c0 6e
    ld l,l              ;27c1 6d
    ld h,l              ;27c2 65
    ld l,(hl)           ;27c3 6e
    ld (hl),h           ;27c4 74
l27c5h:
    inc d               ;27c5 14
    ret z               ;27c6 c8
l27c7h:
    daa                 ;27c7 27
l27c8h:
    ld b,c              ;27c8 41
    jr nz,l27f8h        ;27c9 20 2d
l27cbh:
    jr nz,l280eh        ;27cb 20 41
    ld (hl),l           ;27cd 75
l27ceh:
    ld (hl),h           ;27ce 74
    ld l,a              ;27cf 6f
    ld l,h              ;27d0 6c
    ld l,a              ;27d1 6f
    ld h,c              ;27d2 61
    ld h,h              ;27d3 64
    jr nz,$+101         ;27d4 20 63
    ld l,a              ;27d6 6f
    ld l,l              ;27d7 6d
    ld l,l              ;27d8 6d
    ld h,c              ;27d9 61
    ld l,(hl)           ;27da 6e
    ld h,h              ;27db 64
l27dch:
    ld d,0dfh           ;27dc 16 df
    daa                 ;27de 27
    dec l               ;27df 2d
    dec l               ;27e0 2d
    dec l               ;27e1 2d
    dec l               ;27e2 2d
    jr nz,l2805h        ;27e3 20 20
l27e5h:
    dec l               ;27e5 2d
    dec l               ;27e6 2d
    dec l               ;27e7 2d
    dec l               ;27e8 2d
    dec l               ;27e9 2d
    dec l               ;27ea 2d
    dec l               ;27eb 2d
    dec l               ;27ec 2d
    dec l               ;27ed 2d
    dec l               ;27ee 2d
    dec l               ;27ef 2d
    dec l               ;27f0 2d
    dec l               ;27f1 2d
    dec l               ;27f2 2d
    dec l               ;27f3 2d
    dec l               ;27f4 2d
l27f5h:
    ld d,0f8h           ;27f5 16 f8
    daa                 ;27f7 27
l27f8h:
    ld b,e              ;27f8 43
    ld d,b              ;27f9 50
    cpl                 ;27fa 2f
l27fbh:
    ld c,l              ;27fb 4d
    jr nz,$+34          ;27fc 20 20
    ld d,d              ;27fe 52
    ld h,l              ;27ff 65
    dec l               ;2800 2d
l2801h:
    ld h,e              ;2801 63
    ld l,a              ;2802 6f
    ld l,(hl)           ;2803 6e
    ld h,(hl)           ;2804 66
l2805h:
    ld l,c              ;2805 69
    ld h,a              ;2806 67
    ld (hl),l           ;2807 75
    ld (hl),d           ;2808 72
    ld h,c              ;2809 61
    ld (hl),h           ;280a 74
    ld l,c              ;280b 69
    ld l,a              ;280c 6f
    ld l,(hl)           ;280d 6e
l280eh:
    jr $+19             ;280e 18 11
    jr z,l2865h         ;2810 28 53
    ld l,a              ;2812 6f
    ld (hl),l           ;2813 75
    ld (hl),d           ;2814 72
    ld h,e              ;2815 63
    ld h,l              ;2816 65
    jr nz,l287dh        ;2817 20 64
    ld (hl),d           ;2819 72
l281ah:
    ld l,c              ;281a 69
    halt                ;281b 76
    ld h,l              ;281c 65
l281dh:
    jr nz,l2847h        ;281d 20 28
    ld b,c              ;281f 41
    jr nz,l2896h        ;2820 20 74
    ld l,a              ;2822 6f
    jr nz,l2875h        ;2823 20 50
    add hl,hl           ;2825 29
    jr nz,l2867h        ;2826 20 3f
    jr nz,l284ch        ;2828 20 22
    inc l               ;282a 2c
    jr z,l287fh         ;282b 28 52
    ld h,l              ;282d 65
    halt                ;282e 76
    ld l,c              ;282f 69
    ld (hl),e           ;2830 73
    ld l,c              ;2831 69
    ld l,a              ;2832 6f
l2833h:
    ld l,(hl)           ;2833 6e
    jr nz,l2869h        ;2834 20 33
    jr nz,l2858h        ;2836 20 20
    jr nz,l2867h        ;2838 20 2d
    dec l               ;283a 2d
    jr nz,l285dh        ;283b 20 20
    jr nz,$+51          ;283d 20 31
    add hl,sp           ;283f 39
    jr nz,$+72          ;2840 20 46
    ld h,l              ;2842 65
    ld h,d              ;2843 62
    ld (hl),d           ;2844 72
    ld (hl),l           ;2845 75
    ld h,c              ;2846 61
l2847h:
    ld (hl),d           ;2847 72
    ld a,c              ;2848 79
    jr nz,l287ch        ;2849 20 31
    add hl,sp           ;284b 39
l284ch:
    jr c,l2880h         ;284c 38 32
l284eh:
    rla                 ;284e 17
    ld d,c              ;284f 51
    jr z,$+79           ;2850 28 4d
    ld l,c              ;2852 69
    ld l,(hl)           ;2853 6e
l2854h:
    ld l,c              ;2854 69
l2855h:
    dec l               ;2855 2d
    ld (hl),a           ;2856 77
    ld l,c              ;2857 69
l2858h:
    ld l,(hl)           ;2858 6e
    ld h,e              ;2859 63
    ld l,b              ;285a 68
    ld h,l              ;285b 65
    ld (hl),e           ;285c 73
l285dh:
    ld (hl),h           ;285d 74
    ld h,l              ;285e 65
    ld (hl),d           ;285f 72
    jr nz,$+120         ;2860 20 76
    ld h,l              ;2862 65
    ld (hl),d           ;2863 72
    ld (hl),e           ;2864 73
l2865h:
    ld l,c              ;2865 69
    ld l,a              ;2866 6f
l2867h:
    ld l,(hl)           ;2867 6e
l2868h:
    dec d               ;2868 15
l2869h:
    ld l,e              ;2869 6b
    jr z,l2899h         ;286a 28 2d
    dec l               ;286c 2d
    dec l               ;286d 2d
    dec l               ;286e 2d
    jr nz,l2891h        ;286f 20 20
    dec l               ;2871 2d
    dec l               ;2872 2d
    dec l               ;2873 2d
    dec l               ;2874 2d
l2875h:
    dec l               ;2875 2d
    dec l               ;2876 2d
    dec l               ;2877 2d
    dec l               ;2878 2d
    dec l               ;2879 2d
    dec l               ;287a 2d
    dec l               ;287b 2d
l287ch:
    dec l               ;287c 2d
l287dh:
    dec l               ;287d 2d
    dec l               ;287e 2d
l287fh:
    dec l               ;287f 2d
l2880h:
    dec d               ;2880 15
    add a,e             ;2881 83
    jr z,l28c7h         ;2882 28 43
    ld d,b              ;2884 50
    cpl                 ;2885 2f
    ld c,l              ;2886 4d
    jr nz,sub_28a9h     ;2887 20 20
    ld d,d              ;2889 52
    ld h,l              ;288a 65
    ld h,e              ;288b 63
    ld l,a              ;288c 6f
    ld l,(hl)           ;288d 6e
    ld h,(hl)           ;288e 66
    ld l,c              ;288f 69
    ld h,a              ;2890 67
l2891h:
    ld (hl),l           ;2891 75
    ld (hl),d           ;2892 72
    ld h,c              ;2893 61
    ld (hl),h           ;2894 74
    ld l,c              ;2895 69
l2896h:
    ld l,a              ;2896 6f
    ld l,(hl)           ;2897 6e
l2898h:
    nop                 ;2898 00
l2899h:
    sbc a,e             ;2899 9b
    jr z,l2869h         ;289a 28 cd
    inc h               ;289c 24
    dec l               ;289d 2d
    ld bc,0000h         ;289e 01 00 00
sub_28a1h:
    ld c,0ah            ;28a1 0e 0a
    ld de,0080h         ;28a3 11 80 00
    jp 0005h            ;28a6 c3 05 00
sub_28a9h:
    ld bc,1c00h         ;28a9 01 00 1c
    ld hl,4000h         ;28ac 21 00 40
    ld de,0d400h        ;28af 11 00 d4
    ldir                ;28b2 ed b0
    jp 0f075h           ;28b4 c3 75 f0
sub_28b7h:
    ld a,(hl)           ;28b7 7e
    ld (l2be5h),a       ;28b8 32 e5 2b
    call 0f054h         ;28bb cd 54 f0
    ld e,00h            ;28be 1e 00
    push de             ;28c0 d5
    call sub_29deh      ;28c1 cd de 29
    ld a,(l2be5h)       ;28c4 3a e5 2b
l28c7h:
    call 0f05ah         ;28c7 cd 5a f0
    ld (l2be6h),a       ;28ca 32 e6 2b
    ld hl,4000h         ;28cd 21 00 40
    ld bc,1c00h         ;28d0 01 00 1c
    pop de              ;28d3 d1
    or a                ;28d4 b7
    ret nz              ;28d5 c0
    push de             ;28d6 d5
    call 0f039h         ;28d7 cd 39 f0
l28dah:
    call 0f03fh         ;28da cd 3f f0
    ld (hl),a           ;28dd 77
    inc hl              ;28de 23
    dec bc              ;28df 0b
    ld a,b              ;28e0 78
    or c                ;28e1 b1
    jr nz,l28dah        ;28e2 20 f6
    call 0f03ch         ;28e4 cd 3c f0
    pop de              ;28e7 d1
    push de             ;28e8 d5
    call 0f060h         ;28e9 cd 60 f0
    pop de              ;28ec d1
    push de             ;28ed d5
    call sub_29f0h      ;28ee cd f0 29
    ld a,(l2be5h)       ;28f1 3a e5 2b
    call 0f05ah         ;28f4 cd 5a f0
    ld (l2be6h),a       ;28f7 32 e6 2b
    ld hl,6000h         ;28fa 21 00 60
    ld bc,l0800h        ;28fd 01 00 08
    pop de              ;2900 d1
    or a                ;2901 b7
    ret nz              ;2902 c0
    push de             ;2903 d5
    call 0f039h         ;2904 cd 39 f0
l2907h:
    call 0f03fh         ;2907 cd 3f f0
    ld (hl),a           ;290a 77
    inc hl              ;290b 23
    dec bc              ;290c 0b
    ld a,b              ;290d 78
    or c                ;290e b1
    jr nz,l2907h        ;290f 20 f6
    call 0f03ch         ;2911 cd 3c f0
    pop de              ;2914 d1
    call 0f060h         ;2915 cd 60 f0
    ld a,(l2be5h)       ;2918 3a e5 2b
    call 0f05ah         ;291b cd 5a f0
    ld (l2be6h),a       ;291e 32 e6 2b
    ret                 ;2921 c9
sub_2922h:
    ld c,(hl)           ;2922 4e
    call 0f01bh         ;2923 cd 1b f0
    ld de,4000h         ;2926 11 00 40
    ld bc,0000h         ;2929 01 00 00
l292ch:
    call 0f01eh         ;292c cd 1e f0
    push bc             ;292f c5
    ld bc,0000h         ;2930 01 00 00
l2933h:
    call 0f021h         ;2933 cd 21 f0
    push bc             ;2936 c5
    push de             ;2937 d5
    call 0f027h         ;2938 cd 27 f0
    or a                ;293b b7
    jr nz,l298ah        ;293c 20 4c
    pop de              ;293e d1
    ld bc,0080h         ;293f 01 80 00
    ld hl,0080h         ;2942 21 80 00
l2945h:
    ldir                ;2945 ed b0
    pop bc              ;2947 c1
    inc c               ;2948 0c
    ld a,c              ;2949 79
    cp 40h              ;294a fe 40
    jr nz,l2933h        ;294c 20 e5
    pop bc              ;294e c1
    inc c               ;294f 0c
    ld a,c              ;2950 79
    cp 02h              ;2951 fe 02
    jr nz,l292ch        ;2953 20 d7
    ret                 ;2955 c9
sub_2956h:
    ld c,(hl)           ;2956 4e
    call 0f01bh         ;2957 cd 1b f0
    ld hl,4000h         ;295a 21 00 40
    ld bc,0000h         ;295d 01 00 00
l2960h:
    call 0f01eh         ;2960 cd 1e f0
    push bc             ;2963 c5
    ld bc,0000h         ;2964 01 00 00
l2967h:
    call 0f021h         ;2967 cd 21 f0
    push bc             ;296a c5
    ld bc,0080h         ;296b 01 80 00
    ld de,0080h         ;296e 11 80 00
    ldir                ;2971 ed b0
    push hl             ;2973 e5
    call 0f02ah         ;2974 cd 2a f0
    or a                ;2977 b7
    jr nz,l298ah        ;2978 20 10
    pop hl              ;297a e1
    pop bc              ;297b c1
    inc c               ;297c 0c
    ld a,c              ;297d 79
    cp 40h              ;297e fe 40
    jr nz,l2967h        ;2980 20 e5
    pop bc              ;2982 c1
    inc c               ;2983 0c
l2984h:
    ld a,c              ;2984 79
    cp 02h              ;2985 fe 02
    jr nz,l2960h        ;2987 20 d7
    ret                 ;2989 c9
l298ah:
    pop hl              ;298a e1
    pop hl              ;298b e1
    pop hl              ;298c e1
    jp l2b7ah           ;298d c3 7a 2b
sub_2990h:
    ld a,(hl)           ;2990 7e
    call 0f051h         ;2991 cd 51 f0
    ld (hl),c           ;2994 71
    inc hl              ;2995 23
    ld (hl),00h         ;2996 36 00
    ret                 ;2998 c9
sub_2999h:
    ld a,(hl)           ;2999 7e
    jp 0f078h           ;299a c3 78 f0
sub_299dh:
    ld a,(l2be6h)       ;299d 3a e6 2b
    ld (hl),a           ;29a0 77
    inc hl              ;29a1 23
    xor a               ;29a2 af
    ld (hl),a           ;29a3 77
    ld a,(l2be6h)       ;29a4 3a e6 2b
    or a                ;29a7 b7
    ret z               ;29a8 c8
    ld de,l29cbh        ;29a9 11 cb 29
    ld c,09h            ;29ac 0e 09
    call 0005h          ;29ae cd 05 00
    ld hl,0eac0h        ;29b1 21 c0 ea
l29b4h:
    ld e,(hl)           ;29b4 5e
    push hl             ;29b5 e5
    ld c,02h            ;29b6 0e 02
    call 0005h          ;29b8 cd 05 00
    pop hl              ;29bb e1
    inc hl              ;29bc 23
    ld a,(hl)           ;29bd 7e
    cp 0dh              ;29be fe 0d
    jr nz,l29b4h        ;29c0 20 f2
    ld de,l29dbh        ;29c2 11 db 29
    ld c,09h            ;29c5 0e 09
    call 0005h          ;29c7 cd 05 00
    ret                 ;29ca c9
l29cbh:
    dec c               ;29cb 0d
    ld a,(bc)           ;29cc 0a
    ld b,h              ;29cd 44
    ld l,c              ;29ce 69
    ld (hl),e           ;29cf 73
    ld l,e              ;29d0 6b
    jr nz,$+103         ;29d1 20 65
    ld (hl),d           ;29d3 72
    ld (hl),d           ;29d4 72
    ld l,a              ;29d5 6f
    ld (hl),d           ;29d6 72
    jr nz,l2a13h        ;29d7 20 3a
    jr nz,l29ffh        ;29d9 20 24
l29dbh:
    dec c               ;29db 0d
    ld a,(bc)           ;29dc 0a
    inc h               ;29dd 24
sub_29deh:
    ld c,06h            ;29de 0e 06
    ld hl,l2bd3h        ;29e0 21 d3 2b
l29e3h:
    ld a,(l2be5h)       ;29e3 3a e5 2b
    rra                 ;29e6 1f
    jp nc,0f05dh        ;29e7 d2 5d f0
    ld hl,l2bd9h        ;29ea 21 d9 2b
    jp 0f05dh           ;29ed c3 5d f0
sub_29f0h:
    ld c,03h            ;29f0 0e 03
    ld hl,l2bdfh        ;29f2 21 df 2b
    ld a,(l2be5h)       ;29f5 3a e5 2b
    rra                 ;29f8 1f
    jp nc,0f05dh        ;29f9 d2 5d f0
    ld hl,l2be2h        ;29fc 21 e2 2b
l29ffh:
    jp 0f05dh           ;29ff c3 5d f0
sub_2a02h:
    ld a,(hl)           ;2a02 7e
    ld (l2be5h),a       ;2a03 32 e5 2b
    call 0f054h         ;2a06 cd 54 f0
    push de             ;2a09 d5
    ld e,0fh            ;2a0a 1e 0f
    ld hl,l2bcah+1      ;2a0c 21 cb 2b
    ld a,(l2be5h)       ;2a0f 3a e5 2b
    rra                 ;2a12 1f
l2a13h:
    jr nc,l2a18h        ;2a13 30 03
    ld hl,2bcfh         ;2a15 21 cf 2b
l2a18h:
    ld c,04h            ;2a18 0e 04
    call 0f05dh         ;2a1a cd 5d f0
    ld a,(l2be5h)       ;2a1d 3a e5 2b
    call 0f05ah         ;2a20 cd 5a f0
    ld (l2be6h),a       ;2a23 32 e6 2b
    pop de              ;2a26 d1
l2a27h:
    cp 01h              ;2a27 fe 01
    ret nz              ;2a29 c0
    ld e,01h            ;2a2a 1e 01
l2a2ch:
    push de             ;2a2c d5
    call sub_29f0h      ;2a2d cd f0 29
    ld a,(l2be5h)       ;2a30 3a e5 2b
    call 0f05ah         ;2a33 cd 5a f0
    ld (l2be6h),a       ;2a36 32 e6 2b
    pop de              ;2a39 d1
l2a3ah:
    or a                ;2a3a b7
    ret nz              ;2a3b c0
    push de             ;2a3c d5
    call 0f033h         ;2a3d cd 33 f0
    ld hl,6000h         ;2a40 21 00 60
    ld bc,l0800h        ;2a43 01 00 08
l2a46h:
    ld a,(hl)           ;2a46 7e
    call 0f042h         ;2a47 cd 42 f0
l2a4ah:
    inc hl              ;2a4a 23
    dec bc              ;2a4b 0b
    ld a,b              ;2a4c 78
    or c                ;2a4d b1
    jr nz,l2a46h        ;2a4e 20 f6
    call 0f036h         ;2a50 cd 36 f0
    pop de              ;2a53 d1
    push de             ;2a54 d5
    call 0f060h         ;2a55 cd 60 f0
    pop de              ;2a58 d1
    push de             ;2a59 d5
    call sub_29deh      ;2a5a cd de 29
    ld a,(l2be5h)       ;2a5d 3a e5 2b
    call 0f05ah         ;2a60 cd 5a f0
    ld (l2be6h),a       ;2a63 32 e6 2b
    pop de              ;2a66 d1
    or a                ;2a67 b7
    ret nz              ;2a68 c0
    push de             ;2a69 d5
    call 0f033h         ;2a6a cd 33 f0
    ld hl,4000h         ;2a6d 21 00 40
    ld bc,1c00h         ;2a70 01 00 1c
l2a73h:
    ld a,(hl)           ;2a73 7e
    call 0f042h         ;2a74 cd 42 f0
    inc hl              ;2a77 23
    dec bc              ;2a78 0b
    ld a,b              ;2a79 78
    or c                ;2a7a b1
    jr nz,l2a73h        ;2a7b 20 f6
    call 0f036h         ;2a7d cd 36 f0
    pop de              ;2a80 d1
    call 0f060h         ;2a81 cd 60 f0
    ld a,(l2be5h)       ;2a84 3a e5 2b
    call 0f05ah         ;2a87 cd 5a f0
    ld (l2be6h),a       ;2a8a 32 e6 2b
    ret                 ;2a8d c9
    ld a,(hl)           ;2a8e 7e
    ld (l2be5h),a       ;2a8f 32 e5 2b
    call 0f054h         ;2a92 cd 54 f0
    ld a,(l2be5h)       ;2a95 3a e5 2b
    and 01h             ;2a98 e6 01
    add a,30h           ;2a9a c6 30
    ld (l2ba7h),a       ;2a9c 32 a7 2b
    ld e,0fh            ;2a9f 1e 0f
    ld c,14h            ;2aa1 0e 14
    ld hl,2ba6h         ;2aa3 21 a6 2b
    call 0f05dh         ;2aa6 cd 5d f0
l2aa9h:
    ld a,(l2be5h)       ;2aa9 3a e5 2b
    call 0f05ah         ;2aac cd 5a f0
    ld (l2be6h),a       ;2aaf 32 e6 2b
    or a                ;2ab2 b7
    ret nz              ;2ab3 c0
    ld a,(l2be5h)       ;2ab4 3a e5 2b
    call 0f078h         ;2ab7 cd 78 f0
sub_2abah:
    ld hl,4000h         ;2aba 21 00 40
    ld de,4001h         ;2abd 11 01 40
    ld bc,00ffh         ;2ac0 01 ff 00
    ld (hl),0e5h        ;2ac3 36 e5
    ldir                ;2ac5 ed b0
    ld a,07h            ;2ac7 3e 07
    ld (l2bcah),a       ;2ac9 32 ca 2b
    ld a,01h            ;2acc 3e 01
    ld (l2bc9h),a       ;2ace 32 c9 2b
l2ad1h:
    call sub_2ae7h      ;2ad1 cd e7 2a
    ld a,(l2be5h)       ;2ad4 3a e5 2b
    call 0f05ah         ;2ad7 cd 5a f0
    ld (l2be6h),a       ;2ada 32 e6 2b
    or a                ;2add b7
    ret nz              ;2ade c0
    ld hl,l2bcah        ;2adf 21 ca 2b
    dec (hl)            ;2ae2 35
    jp p,l2ad1h         ;2ae3 f2 d1 2a
    ret                 ;2ae6 c9
sub_2ae7h:
    ld hl,l2bc1h        ;2ae7 21 c1 2b
    ld c,06h            ;2aea 0e 06
    ld a,(l2be5h)       ;2aec 3a e5 2b
    call 0f057h         ;2aef cd 57 f0
    call 0f04bh         ;2af2 cd 4b f0
    ld a,(4000h)        ;2af5 3a 00 40
    call 0f045h         ;2af8 cd 45 f0
    call 0f036h         ;2afb cd 36 f0
    ld hl,l2bbah        ;2afe 21 ba 2b
    ld c,07h            ;2b01 0e 07
    ld a,(l2be5h)       ;2b03 3a e5 2b
    call 0f057h         ;2b06 cd 57 f0
    call 0f04bh         ;2b09 cd 4b f0
    call 0f048h         ;2b0c cd 48 f0
    call 0f036h         ;2b0f cd 36 f0
    ld a,(l2be5h)       ;2b12 3a e5 2b
    call 0f054h         ;2b15 cd 54 f0
    ld e,02h            ;2b18 1e 02
    call 0f033h         ;2b1a cd 33 f0
    ld hl,4001h         ;2b1d 21 01 40
    ld c,0ffh           ;2b20 0e ff
    call 0f04bh         ;2b22 cd 4b f0
    call 0f036h         ;2b25 cd 36 f0
    ld a,(l2be5h)       ;2b28 3a e5 2b
    call 0f057h         ;2b2b cd 57 f0
    ld hl,l2ba1h        ;2b2e 21 a1 2b
    ld c,05h            ;2b31 0e 05
    call 0f04bh         ;2b33 cd 4b f0
    ld a,(l2be5h)       ;2b36 3a e5 2b
    and 01h             ;2b39 e6 01
    add a,30h           ;2b3b c6 30
    call 0f042h         ;2b3d cd 42 f0
    ld a,(l2bc9h)       ;2b40 3a c9 2b
    call 0f04eh         ;2b43 cd 4e f0
    ld a,(l2bcah)       ;2b46 3a ca 2b
    call 0f04eh         ;2b49 cd 4e f0
    call 0f048h         ;2b4c cd 48 f0
    jp 0f036h           ;2b4f c3 36 f0
    ld c,(hl)           ;2b52 4e
    call 0f01bh         ;2b53 cd 1b f0
    ld hl,0080h         ;2b56 21 80 00
l2b59h:
    ld (hl),0e5h        ;2b59 36 e5
    inc l               ;2b5b 2c
    jr nz,l2b59h        ;2b5c 20 fb
    ld bc,0002h         ;2b5e 01 02 00
    call 0f01eh         ;2b61 cd 1e f0
    ld bc,0000h         ;2b64 01 00 00
l2b67h:
    push bc             ;2b67 c5
    call 0f021h         ;2b68 cd 21 f0
    call 0f02ah         ;2b6b cd 2a f0
    pop bc              ;2b6e c1
    or a                ;2b6f b7
    jp nz,l2b7ah        ;2b70 c2 7a 2b
    inc bc              ;2b73 03
    ld a,c              ;2b74 79
    cp 40h              ;2b75 fe 40
    jr nz,l2b67h        ;2b77 20 ee
    ret                 ;2b79 c9
l2b7ah:
    ld de,l2b87h        ;2b7a 11 87 2b
    ld c,09h            ;2b7d 0e 09
    call 0005h          ;2b7f cd 05 00
    ld c,01h            ;2b82 0e 01
    jp 0005h            ;2b84 c3 05 00
l2b87h:
    dec c               ;2b87 0d
    ld a,(bc)           ;2b88 0a
    ld c,b              ;2b89 48
    ld l,c              ;2b8a 69
    ld (hl),h           ;2b8b 74
    jr nz,$+99          ;2b8c 20 61
    ld l,(hl)           ;2b8e 6e
    ld a,c              ;2b8f 79
    jr nz,l2bfdh        ;2b90 20 6b
    ld h,l              ;2b92 65
    ld a,c              ;2b93 79
    jr nz,l2c0ah        ;2b94 20 74
    ld l,a              ;2b96 6f
    jr nz,$+99          ;2b97 20 61
    ld h,d              ;2b99 62
    ld l,a              ;2b9a 6f
    ld (hl),d           ;2b9b 72
    ld (hl),h           ;2b9c 74
    jr nz,l2bd9h        ;2b9d 20 3a
    jr nz,l2bc5h        ;2b9f 20 24
l2ba1h:
    ld d,l              ;2ba1 55
    ld (3220h),a        ;2ba2 32 20 32
    jr nz,$+80          ;2ba5 20 4e
l2ba7h:
    jr nc,$+60          ;2ba7 30 3a
    ld b,e              ;2ba9 43
    ld d,b              ;2baa 50
    cpl                 ;2bab 2f
    ld c,l              ;2bac 4d
    jr nz,$+88          ;2bad 20 56
    ld (322eh),a        ;2baf 32 2e 32
    jr nz,$+70          ;2bb2 20 44
    ld c,c              ;2bb4 49
    ld d,e              ;2bb5 53
    ld c,e              ;2bb6 4b
    inc l               ;2bb7 2c
    ld e,b              ;2bb8 58
    ld e,b              ;2bb9 58
l2bbah:
    ld b,d              ;2bba 42
    dec l               ;2bbb 2d
    ld d,b              ;2bbc 50
    jr nz,l2bf1h        ;2bbd 20 32
    jr nz,l2bf2h        ;2bbf 20 31
l2bc1h:
    ld c,l              ;2bc1 4d
    dec l               ;2bc2 2d
    ld d,a              ;2bc3 57
    nop                 ;2bc4 00
l2bc5h:
    inc de              ;2bc5 13
    ld bc,3223h         ;2bc6 01 23 32
l2bc9h:
    ld d,e              ;2bc9 53
l2bcah:
    ld a,(3053h)        ;2bca 3a 53 30
    ld a,(532ah)        ;2bcd 3a 2a 53
    ld sp,l2a3ah        ;2bd0 31 3a 2a
l2bd3h:
    jr nc,$+60          ;2bd3 30 3a
    ld b,e              ;2bd5 43
    ld d,b              ;2bd6 50
    cpl                 ;2bd7 2f
    ld c,l              ;2bd8 4d
l2bd9h:
    ld sp,433ah         ;2bd9 31 3a 43
    ld d,b              ;2bdc 50
    cpl                 ;2bdd 2f
    ld c,l              ;2bde 4d
l2bdfh:
    jr nc,$+60          ;2bdf 30 3a
    ld c,e              ;2be1 4b
l2be2h:
    ld sp,4b3ah         ;2be2 31 3a 4b
l2be5h:
    dec l               ;2be5 2d
l2be6h:
    ld d,h              ;2be6 54
l2be7h:
    cp 64h              ;2be7 fe 64
    jp z,53d6h          ;2be9 ca d6 53
l2bech:
    ld a,20h            ;2bec 3e 20
    call sub_2d2fh      ;2bee cd 2f 2d
l2bf1h:
    ret                 ;2bf1 c9
l2bf2h:
    ld a,0ah            ;2bf2 3e 0a
    call sub_2d2fh      ;2bf4 cd 2f 2d
    ld a,0dh            ;2bf7 3e 0d
    call sub_2d2fh      ;2bf9 cd 2f 2d
    ret                 ;2bfc c9
l2bfdh:
    ld a,02h            ;2bfd 3e 02
    ld (l2be7h),a       ;2bff 32 e7 2b
    ld a,l              ;2c02 7d
    call sub_2c14h      ;2c03 cd 14 2c
    ld (2beah),a        ;2c06 32 ea 2b
    ld a,l              ;2c09 7d
l2c0ah:
    call sub_2c18h      ;2c0a cd 18 2c
    ld (2bebh),a        ;2c0d 32 eb 2b
    ld hl,l2be7h        ;2c10 21 e7 2b
    ret                 ;2c13 c9
sub_2c14h:
    rrca                ;2c14 0f
    rrca                ;2c15 0f
    rrca                ;2c16 0f
    rrca                ;2c17 0f
sub_2c18h:
    and 0fh             ;2c18 e6 0f
    cp 0ah              ;2c1a fe 0a
    jp m,l2c21h         ;2c1c fa 21 2c
    add a,07h           ;2c1f c6 07
l2c21h:
    add a,30h           ;2c21 c6 30
    ret                 ;2c23 c9
sub_2c24h:
    ld a,01h            ;2c24 3e 01
    ld (l2be7h),a       ;2c26 32 e7 2b
    ld a,l              ;2c29 7d
    ld (2beah),a        ;2c2a 32 ea 2b
    ld hl,l2be7h        ;2c2d 21 e7 2b
    ret                 ;2c30 c9
sub_2c31h:
    ld a,(hl)           ;2c31 7e
    or a                ;2c32 b7
    jp z,l2bf2h         ;2c33 ca f2 2b
    call sub_2c4eh      ;2c36 cd 4e 2c
    jp l2bf2h           ;2c39 c3 f2 2b
sub_2c3ch:
    ld a,(hl)           ;2c3c 7e
    or a                ;2c3d b7
    ret z               ;2c3e c8
    call sub_2c4eh      ;2c3f cd 4e 2c
    ret                 ;2c42 c9
sub_2c43h:
    ld a,(hl)           ;2c43 7e
    or a                ;2c44 b7
l2c45h:
    jp z,l2bech         ;2c45 ca ec 2b
    call sub_2c4eh      ;2c48 cd 4e 2c
l2c4bh:
    jp l2bech           ;2c4b c3 ec 2b
sub_2c4eh:
    ld b,a              ;2c4e 47
l2c4fh:
    inc hl              ;2c4f 23
    inc hl              ;2c50 23
    inc hl              ;2c51 23
l2c52h:
    ld a,(hl)           ;2c52 7e
    call sub_2d2fh      ;2c53 cd 2f 2d
    dec b               ;2c56 05
    inc hl              ;2c57 23
    jp nz,l2c52h        ;2c58 c2 52 2c
    ret                 ;2c5b c9
    ex de,hl            ;2c5c eb
    pop hl              ;2c5d e1
    ld c,(hl)           ;2c5e 4e
    inc hl              ;2c5f 23
    ld b,(hl)           ;2c60 46
    jp l2c6ah           ;2c61 c3 6a 2c
sub_2c64h:
    ld b,h              ;2c64 44
    ld c,l              ;2c65 4d
    pop hl              ;2c66 e1
    ld e,(hl)           ;2c67 5e
    inc hl              ;2c68 23
    ld d,(hl)           ;2c69 56
l2c6ah:
    inc hl              ;2c6a 23
    push hl             ;2c6b e5
    jp l2c72h           ;2c6c c3 72 2c
    ex de,hl            ;2c6f eb
    ld b,h              ;2c70 44
    ld c,l              ;2c71 4d
l2c72h:
    ld a,d              ;2c72 7a
    cpl                 ;2c73 2f
    ld d,a              ;2c74 57
    ld a,e              ;2c75 7b
    cpl                 ;2c76 2f
    ld e,a              ;2c77 5f
    inc de              ;2c78 13
    ld hl,0000h         ;2c79 21 00 00
    ld a,11h            ;2c7c 3e 11
l2c7eh:
    push hl             ;2c7e e5
    add hl,de           ;2c7f 19
    jp nc,l2c84h        ;2c80 d2 84 2c
    ex (sp),hl          ;2c83 e3
l2c84h:
    pop hl              ;2c84 e1
    push af             ;2c85 f5
    ld a,c              ;2c86 79
    rla                 ;2c87 17
    ld c,a              ;2c88 4f
    ld a,b              ;2c89 78
    rla                 ;2c8a 17
    ld b,a              ;2c8b 47
    ld a,l              ;2c8c 7d
    rla                 ;2c8d 17
    ld l,a              ;2c8e 6f
    ld a,h              ;2c8f 7c
    rla                 ;2c90 17
    ld h,a              ;2c91 67
    pop af              ;2c92 f1
    dec a               ;2c93 3d
    jp nz,l2c7eh        ;2c94 c2 7e 2c
    ld l,c              ;2c97 69
    ld h,b              ;2c98 60
    ret                 ;2c99 c9
sub_2c9ah:
    ld b,h              ;2c9a 44
    ld c,l              ;2c9b 4d
    pop hl              ;2c9c e1
    ld e,(hl)           ;2c9d 5e
    inc hl              ;2c9e 23
    ld d,(hl)           ;2c9f 56
    inc hl              ;2ca0 23
    push hl             ;2ca1 e5
    ld l,c              ;2ca2 69
    ld h,b              ;2ca3 60
    ld a,h              ;2ca4 7c
    or l                ;2ca5 b5
    ret z               ;2ca6 c8
    ex de,hl            ;2ca7 eb
    ld a,h              ;2ca8 7c
    or l                ;2ca9 b5
    ret z               ;2caa c8
    ld b,h              ;2cab 44
    ld c,l              ;2cac 4d
    ld hl,0000h         ;2cad 21 00 00
    ld a,10h            ;2cb0 3e 10
l2cb2h:
    add hl,hl           ;2cb2 29
    ex de,hl            ;2cb3 eb
    add hl,hl           ;2cb4 29
    ex de,hl            ;2cb5 eb
    jp nc,l2cbah        ;2cb6 d2 ba 2c
    add hl,bc           ;2cb9 09
l2cbah:
    dec a               ;2cba 3d
    jp nz,l2cb2h        ;2cbb c2 b2 2c
    ret                 ;2cbe c9
    call sub_2cd6h      ;2cbf cd d6 2c
    ld a,20h            ;2cc2 3e 20
    call sub_2d2fh      ;2cc4 cd 2f 2d
    ret                 ;2cc7 c9
sub_2cc8h:
    call sub_2cd6h      ;2cc8 cd d6 2c
    ld a,0ah            ;2ccb 3e 0a
    call sub_2d2fh      ;2ccd cd 2f 2d
    ld a,0dh            ;2cd0 3e 0d
    call sub_2d2fh      ;2cd2 cd 2f 2d
    ret                 ;2cd5 c9
sub_2cd6h:
    push hl             ;2cd6 e5
    ld a,h              ;2cd7 7c
    and 80h             ;2cd8 e6 80
    jp z,l2ce9h         ;2cda ca e9 2c
    ld a,l              ;2cdd 7d
    cpl                 ;2cde 2f
    ld l,a              ;2cdf 6f
    ld a,h              ;2ce0 7c
    cpl                 ;2ce1 2f
    ld h,a              ;2ce2 67
    inc hl              ;2ce3 23
    ld a,2dh            ;2ce4 3e 2d
    call sub_2d2fh      ;2ce6 cd 2f 2d
l2ce9h:
    ld c,30h            ;2ce9 0e 30
    ld de,l2710h        ;2ceb 11 10 27
    call sub_2d0bh      ;2cee cd 0b 2d
    ld de,l03e8h        ;2cf1 11 e8 03
    call sub_2d0bh      ;2cf4 cd 0b 2d
    ld de,0064h         ;2cf7 11 64 00
    call sub_2d0bh      ;2cfa cd 0b 2d
    ld de,000ah         ;2cfd 11 0a 00
    call sub_2d0bh      ;2d00 cd 0b 2d
    ld de,0001h         ;2d03 11 01 00
    call sub_2d0bh      ;2d06 cd 0b 2d
    pop hl              ;2d09 e1
    ret                 ;2d0a c9
sub_2d0bh:
    call sub_2d1dh      ;2d0b cd 1d 2d
    jp c,l2d15h         ;2d0e da 15 2d
    inc c               ;2d11 0c
    jp sub_2d0bh        ;2d12 c3 0b 2d
l2d15h:
    ld a,c              ;2d15 79
    call sub_2d2fh      ;2d16 cd 2f 2d
    add hl,de           ;2d19 19
    ld c,30h            ;2d1a 0e 30
    ret                 ;2d1c c9
sub_2d1dh:
    ld a,l              ;2d1d 7d
    sub e               ;2d1e 93
    ld l,a              ;2d1f 6f
    ld a,h              ;2d20 7c
    sbc a,d             ;2d21 9a
    ld h,a              ;2d22 67
    ret                 ;2d23 c9
sub_2d24h:
    jp 0000h            ;2d24 c3 00 00
l2d27h:
    jp (hl)             ;2d27 e9
sub_2d28h:
    ret                 ;2d28 c9
    ld hl,0fffeh        ;2d29 21 fe ff
    jp l2d3eh           ;2d2c c3 3e 2d
sub_2d2fh:
    push hl             ;2d2f e5
    push de             ;2d30 d5
    push bc             ;2d31 c5
    push af             ;2d32 f5
    ld c,02h            ;2d33 0e 02
    ld e,a              ;2d35 5f
    call 0005h          ;2d36 cd 05 00
    pop af              ;2d39 f1
    pop bc              ;2d3a c1
    pop de              ;2d3b d1
    pop hl              ;2d3c e1
sub_2d3dh:
    ret                 ;2d3d c9
l2d3eh:
    push de             ;2d3e d5
    push bc             ;2d3f c5
    push hl             ;2d40 e5
    ld c,01h            ;2d41 0e 01
    call 0005h          ;2d43 cd 05 00
    pop hl              ;2d46 e1
    ld (hl),a           ;2d47 77
    inc hl              ;2d48 23
    ld (hl),00h         ;2d49 36 00
    pop bc              ;2d4b c1
    pop de              ;2d4c d1
    ret                 ;2d4d c9
    ld a,(hl)           ;2d4e 7e
    jp sub_2d2fh        ;2d4f c3 2f 2d
    call sub_2d2fh      ;2d52 cd 2f 2d
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
    call sub_2d2fh      ;2d66 cd 2f 2d
    ld c,30h            ;2d69 0e 30
    ld de,l2710h        ;2d6b 11 10 27
    call sub_2d0bh      ;2d6e cd 0b 2d
    ld de,l03e8h        ;2d71 11 e8 03
    call sub_2d0bh      ;2d74 cd 0b 2d
    ld de,0064h         ;2d77 11 64 00
    call sub_2d0bh      ;2d7a cd 0b 2d
    ld de,000ah         ;2d7d 11 0a 00
