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
    jp 232eh            ;0270 c3 2e 23
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
    call 2050h          ;0284 cd 50 20
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
    call 2050h          ;029e cd 50 20
    inc b               ;02a1 04
    ld a,05h            ;02a2 3e 05
    call 2bceh          ;02a4 cd ce 2b
    ld a,b              ;02a7 78
    and 08h             ;02a8 e6 08
    jp z,2a9bh          ;02aa ca 9b 2a
    call 2050h          ;02ad cd 50 20
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
    call 2716h          ;02d8 cd 16 27
    ld (hl),e           ;02db 73
l02dch:
    inc hl              ;02dc 23
    ld (hl),d           ;02dd 72
l02deh:
    dec hl              ;02de 2b
    jp 275dh            ;02df c3 5d 27
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
    call clear_screen   ;031d cd bd 1b

    call pr0a           ;0320 cd 3d 2d
    ld hl,empty_string  ;0323 21 98 28
    call pv2d           ;0326 cd 31 2c

    call pr0a           ;0329 cd 3d 2d
    ld hl,cpm_reconfig  ;032c 21 80 28
    call pv2d           ;032f cd 31 2c

    call pr0a           ;0332 cd 3d 2d
    ld hl,dashes_3      ;0335 21 68 28
    call pv2d           ;0338 cd 31 2c

    call pr0a           ;033b cd 3d 2d
    ld hl,empty_string  ;033e 21 98 28
    call pv2d           ;0341 cd 31 2c

    ld hl,(l010ah)      ;0344 2a 0a 01
    ld de,0ffffh        ;0347 11 ff ff
    add hl,de           ;034a 19
    ld a,h              ;034b 7c
    or l                ;034c b5
    jp nz,l0359h        ;034d c2 59 03

    call pr0a           ;0350 cd 3d 2d
    ld hl,mw_version    ;0353 21 4e 28
    call pv2d           ;0356 cd 31 2c

l0359h:
    call pr0a           ;0359 cd 3d 2d
    ld hl,rev_3_feb_1982 ;035c 21 29 28
    call pv2d           ;035f cd 31 2c

    call pr0a           ;0362 cd 3d 2d
    ld hl,empty_string  ;0365 21 98 28
    call pv2d           ;0368 cd 31 2c
    call pr0a           ;036b cd 3d 2d
    ld hl,empty_string  ;036e 21 98 28
    call pv2d           ;0371 cd 31 2c
    call pr0a           ;0374 cd 3d 2d
    ld hl,source_drv_a_p ;0377 21 0e 28
    call pv1d           ;037a cd 3c 2c
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
    call dtype          ;03c9 cd 90 29
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
    call cread_         ;040d cd 22 29
    jp l0430h           ;0410 c3 30 04
l0413h:
    ld hl,02b2h         ;0413 21 b2 02
    call idisk          ;0416 cd 99 29
    ld hl,02b2h         ;0419 21 b2 02
    call rdsys          ;041c cd b7 28
    ld hl,l02b6h        ;041f 21 b6 02
    call dskerr         ;0422 cd 9d 29
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
    call clear_screen   ;05b5 cd bd 1b
    call pr0a           ;05b8 cd 3d 2d
    ld hl,empty_string  ;05bb 21 98 28
    call pv2d           ;05be cd 31 2c
    call pr0a           ;05c1 cd 3d 2d
    ld hl,cpm_reconfig_2 ;05c4 21 f5 27
    call pv2d           ;05c7 cd 31 2c
    call pr0a           ;05ca cd 3d 2d
    ld hl,dashes_4      ;05cd 21 dc 27
    call pv2d           ;05d0 cd 31 2c
    call pr0a           ;05d3 cd 3d 2d
    ld hl,empty_string  ;05d6 21 98 28
    call pv2d           ;05d9 cd 31 2c
    call pr0a           ;05dc cd 3d 2d
    ld hl,a_autoload    ;05df 21 c5 27
    call pv2d           ;05e2 cd 31 2c
    call pr0a           ;05e5 cd 3d 2d
    ld hl,empty_string  ;05e8 21 98 28
    call pv2d           ;05eb cd 31 2c
    call pr0a           ;05ee cd 3d 2d
    ld hl,d_drv_asgn    ;05f1 21 a9 27
    call pv2d           ;05f4 cd 31 2c
    call pr0a           ;05f7 cd 3d 2d
    ld hl,empty_string  ;05fa 21 98 28
    call pv2d           ;05fd cd 31 2c
    call pr0a           ;0600 cd 3d 2d
    ld hl,i_io_asgn     ;0603 21 94 27
    call pv2d           ;0606 cd 31 2c
    call pr0a           ;0609 cd 3d 2d
    ld hl,empty_string  ;060c 21 98 28
    call pv2d           ;060f cd 31 2c
    call pr0a           ;0612 cd 3d 2d
    ld hl,p_pet_term    ;0615 21 76 27
    call pv2d           ;0618 cd 31 2c
    call pr0a           ;061b cd 3d 2d
    ld hl,empty_string  ;061e 21 98 28
    call pv2d           ;0621 cd 31 2c
    call pr0a           ;0624 cd 3d 2d
    ld hl,r_rs232       ;0627 21 5a 27
    call pv2d           ;062a cd 31 2c
    call pr0a           ;062d cd 3d 2d
    ld hl,empty_string  ;0630 21 98 28
    call pv2d           ;0633 cd 31 2c
    call pr0a           ;0636 cd 3d 2d
    ld hl,s_save        ;0639 21 44 27
    call pv2d           ;063c cd 31 2c
    call pr0a           ;063f cd 3d 2d
    ld hl,empty_string  ;0642 21 98 28
    call pv2d           ;0645 cd 31 2c
    call pr0a           ;0648 cd 3d 2d
    ld hl,e_execute     ;064b 21 2b 27
    call pv2d           ;064e cd 31 2c
    call pr0a           ;0651 cd 3d 2d
    ld hl,empty_string  ;0654 21 98 28
    call pv2d           ;0657 cd 31 2c
    call pr0a           ;065a cd 3d 2d
    ld hl,q_quit        ;065d 21 13 27
    call pv2d           ;0660 cd 31 2c
    call pr0a           ;0663 cd 3d 2d
    ld hl,empty_string  ;0666 21 98 28
    call pv2d           ;0669 cd 31 2c
    call pr0a           ;066c cd 3d 2d
    ld hl,pls_letter    ;066f 21 ea 26
    call pv1d           ;0672 cd 3c 2c
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
    call clear_screen   ;06de cd bd 1b
    call pr0a           ;06e1 cd 3d 2d
    ld hl,rs232_chrs    ;06e4 21 c7 26
    call pv2d           ;06e7 cd 31 2c
    call pr0a           ;06ea cd 3d 2d
    ld hl,dashes_5      ;06ed 21 a4 26
    call pv2d           ;06f0 cd 31 2c
    call pr0a           ;06f3 cd 3d 2d
    ld hl,empty_string  ;06f6 21 98 28
    call pv2d           ;06f9 cd 31 2c
    call pr0a           ;06fc cd 3d 2d
    ld hl,rs232_1_chr   ;06ff 21 82 26
    call pv1d           ;0702 cd 3c 2c
    call pr0a           ;0705 cd 3d 2d
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
    call chr            ;071c cd 24 2c
    call pv2d           ;071f cd 31 2c
    call pr0a           ;0722 cd 3d 2d
    ld hl,empty_string  ;0725 21 98 28
    call pv2d           ;0728 cd 31 2c
    call pr0a           ;072b cd 3d 2d
    ld hl,rs232_2_stop  ;072e 21 60 26
    call pv1d           ;0731 cd 3c 2c
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
    call pr0a           ;074a cd 3d 2d
    ld hl,undefined     ;074d 21 54 26
    call pv2d           ;0750 cd 31 2c
l0753h:
    ld hl,(02d6h)       ;0753 2a d6 02
    ld de,0ffc0h        ;0756 11 c0 ff
    add hl,de           ;0759 19
    ld a,h              ;075a 7c
    or l                ;075b b5
    jp nz,l0768h        ;075c c2 68 07
    call pr0a           ;075f cd 3d 2d
    ld hl,one           ;0762 21 50 26
    call pv2d           ;0765 cd 31 2c
l0768h:
    ld hl,(02d6h)       ;0768 2a d6 02
    ld de,0ff80h        ;076b 11 80 ff
    add hl,de           ;076e 19
    ld a,h              ;076f 7c
    or l                ;0770 b5
    jp nz,l077dh        ;0771 c2 7d 07
    call pr0a           ;0774 cd 3d 2d
    ld hl,one_dot_five  ;0777 21 4a 26
    call pv2d           ;077a cd 31 2c
l077dh:
    ld hl,(02d6h)       ;077d 2a d6 02
    ld de,0ff40h        ;0780 11 40 ff
    add hl,de           ;0783 19
    ld a,h              ;0784 7c
    or l                ;0785 b5
    jp nz,l0792h        ;0786 c2 92 07
    call pr0a           ;0789 cd 3d 2d
    ld hl,two           ;078c 21 46 26
    call pv2d           ;078f cd 31 2c
l0792h:
    call pr0a           ;0792 cd 3d 2d
    ld hl,empty_string  ;0795 21 98 28
    call pv2d           ;0798 cd 31 2c
    call pr0a           ;079b cd 3d 2d
    ld hl,rs232_3_par   ;079e 21 24 26
    call pv1d           ;07a1 cd 3c 2c
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
    call pr0a           ;07b4 cd 3d 2d
    ld hl,none          ;07b7 21 1d 26
    call pv2d           ;07ba cd 31 2c
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
    call pr0a           ;07d1 cd 3d 2d
    ld hl,even          ;07d4 21 16 26
    call pv2d           ;07d7 cd 31 2c
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
    call pr0a           ;07ee cd 3d 2d
    ld hl,odd           ;07f1 21 10 26
    call pv2d           ;07f4 cd 31 2c
l07f7h:
    call pr0a           ;07f7 cd 3d 2d
    ld hl,empty_string  ;07fa 21 98 28
    call pv2d           ;07fd cd 31 2c
l0800h:
    call pr0a           ;0800 cd 3d 2d
    ld hl,rs232_4_baud  ;0803 21 ee 25
    call pv1d           ;0806 cd 3c 2c
    ld hl,(02c2h)       ;0809 2a c2 02
    ld de,0ffdeh        ;080c 11 de ff
    add hl,de           ;080f 19
    ld a,h              ;0810 7c
    or l                ;0811 b5
    jp nz,l081eh        ;0812 c2 1e 08
    call pr0a           ;0815 cd 3d 2d
    ld hl,baud_110      ;0818 21 e8 25
    call pv2d           ;081b cd 31 2c
l081eh:
    ld hl,(02c2h)       ;081e 2a c2 02
    ld de,0ffabh        ;0821 11 ab ff
    add hl,de           ;0824 19
    ld a,h              ;0825 7c
    or l                ;0826 b5
    jp nz,l0833h        ;0827 c2 33 08
    call pr0a           ;082a cd 3d 2d
    ld hl,baud_300      ;082d 21 e2 25
    call pv2d           ;0830 cd 31 2c
l0833h:
    ld hl,(02c2h)       ;0833 2a c2 02
    ld de,0ff89h        ;0836 11 89 ff
    add hl,de           ;0839 19
    ld a,h              ;083a 7c
    or l                ;083b b5
    jp nz,l0848h        ;083c c2 48 08
    call pr0a           ;083f cd 3d 2d
    ld hl,baud_1200     ;0842 21 db 25
    call pv2d           ;0845 cd 31 2c
l0848h:
    ld hl,(02c2h)       ;0848 2a c2 02
    ld de,0ff12h        ;084b 11 12 ff
    add hl,de           ;084e 19
    ld a,h              ;084f 7c
    or l                ;0850 b5
    jp nz,l085dh        ;0851 c2 5d 08
    call pr0a           ;0854 cd 3d 2d
    ld hl,baud_9600     ;0857 21 d4 25
    call pv2d           ;085a cd 31 2c
l085dh:
    ld hl,(02c2h)       ;085d 2a c2 02
    ld de,0ff01h        ;0860 11 01 ff
    add hl,de           ;0863 19
    ld a,h              ;0864 7c
    or l                ;0865 b5
    jp nz,l0872h        ;0866 c2 72 08
    call pr0a           ;0869 cd 3d 2d
    ld hl,baud_19200    ;086c 21 cc 25
    call pv2d           ;086f cd 31 2c
l0872h:
    ld hl,(02c2h)       ;0872 2a c2 02
    ld de,0ff34h        ;0875 11 34 ff
    add hl,de           ;0878 19
    ld a,h              ;0879 7c
    or l                ;087a b5
    jp nz,l0887h        ;087b c2 87 08
    call pr0a           ;087e cd 3d 2d
    ld hl,baud_4800     ;0881 21 c5 25
    call pv2d           ;0884 cd 31 2c
l0887h:
    call pr0a           ;0887 cd 3d 2d
    ld hl,empty_string  ;088a 21 98 28
    call pv2d           ;088d cd 31 2c
    call pr0a           ;0890 cd 3d 2d
    ld hl,alter_chr_1_4 ;0893 21 9f 25
    call pv1d           ;0896 cd 3c 2c
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
    call pr0a           ;08d7 cd 3d 2d
    ld hl,new_char_len  ;08da 21 7c 25
    call pv1d           ;08dd cd 3c 2c
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
    call pr0a           ;0930 cd 3d 2d
    ld hl,num_stop_bits ;0933 21 59 25
    call pv1d           ;0936 cd 3c 2c
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
    call pr0a           ;0983 cd 3d 2d
    ld hl,odd_even_none  ;0986 21 37 25
    call pv1d           ;0989 cd 3c 2c
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
    call pr0a           ;09e8 cd 3d 2d
    ld hl,empty_string  ;09eb 21 98 28
    call pv2d           ;09ee cd 31 2c
    call pr0a           ;09f1 cd 3d 2d
    ld hl,ask_bauds     ;09f4 21 17 25
    call pv2d           ;09f7 cd 31 2c
    call pr0a           ;09fa cd 3d 2d
    ld hl,ask_19200     ;09fd 21 07 25
    call pv1d           ;0a00 cd 3c 2c
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
    call clear_screen   ;0a7b cd bd 1b
    call pr0a           ;0a7e cd 3d 2d
    ld hl,io_dev_asgn   ;0a81 21 e2 24
    call pv2d           ;0a84 cd 31 2c
    call pr0a           ;0a87 cd 3d 2d
    ld hl,dashes_6      ;0a8a 21 bd 24
    call pv2d           ;0a8d cd 31 2c
    call pr0a           ;0a90 cd 3d 2d
    ld hl,empty_string  ;0a93 21 98 28
    call pv2d           ;0a96 cd 31 2c
    call pr0a           ;0a99 cd 3d 2d
    ld hl,io_lpt_device ;0a9c 21 9c 24
    call pv1d           ;0a9f cd 3c 2c
    ld hl,(l02bah)      ;0aa2 2a ba 02
    call sub_2cc8h      ;0aa5 cd c8 2c
    call pr0a           ;0aa8 cd 3d 2d
    ld hl,empty_string  ;0aab 21 98 28
    call pv2d           ;0aae cd 31 2c
    call pr0a           ;0ab1 cd 3d 2d
    ld hl,io_ul1_device ;0ab4 21 7b 24
    call pv1d           ;0ab7 cd 3c 2c
    ld hl,(l02c4h)      ;0aba 2a c4 02
    call sub_2cc8h      ;0abd cd c8 2c
    call pr0a           ;0ac0 cd 3d 2d
    ld hl,empty_string  ;0ac3 21 98 28
    call pv2d           ;0ac6 cd 31 2c
    call pr0a           ;0ac9 cd 3d 2d
    ld hl,io_rdr_device ;0acc 21 5a 24
    call pv1d           ;0acf cd 3c 2c
    ld hl,(l02bch)      ;0ad2 2a bc 02
    call sub_2cc8h      ;0ad5 cd c8 2c
    call pr0a           ;0ad8 cd 3d 2d
    ld hl,empty_string  ;0adb 21 98 28
    call pv2d           ;0ade cd 31 2c
    call pr0a           ;0ae1 cd 3d 2d
    ld hl,io_pun_device ;0ae4 21 39 24
    call pv1d           ;0ae7 cd 3c 2c
    ld hl,(l02bch+2)    ;0aea 2a be 02
    call sub_2cc8h      ;0aed cd c8 2c
    call pr0a           ;0af0 cd 3d 2d
    ld hl,empty_string  ;0af3 21 98 28
    call pv2d           ;0af6 cd 31 2c
    call pr0a           ;0af9 cd 3d 2d
    ld hl,io_lst_device ;0afc 21 18 24
    call pv1d           ;0aff cd 3c 2c
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
    call pr0a           ;0b12 cd 3d 2d
    ld hl,tty           ;0b15 21 11 24
    call pv2d           ;0b18 cd 31 2c
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
    call pr0a           ;0b2f cd 3d 2d
    ld hl,crt           ;0b32 21 0a 24
    call pv2d           ;0b35 cd 31 2c
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
    call pr0a           ;0b4c cd 3d 2d
    ld hl,lpt           ;0b4f 21 03 24
    call pv2d           ;0b52 cd 31 2c
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
    call pr0a           ;0b69 cd 3d 2d
    ld hl,ul1           ;0b6c 21 fc 23
    call pv2d           ;0b6f cd 31 2c
l0b72h:
    call pr0a           ;0b72 cd 3d 2d
    ld hl,empty_string  ;0b75 21 98 28
    call pv2d           ;0b78 cd 31 2c
    call pr0a           ;0b7b cd 3d 2d
    ld hl,default_rdr   ;0b7e 21 db 23
    call pv1d           ;0b81 cd 3c 2c
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
    call pr0a           ;0b94 cd 3d 2d
    ld hl,tty           ;0b97 21 11 24
    call pv2d           ;0b9a cd 31 2c
    jp l0ba9h           ;0b9d c3 a9 0b
l0ba0h:
    call pr0a           ;0ba0 cd 3d 2d
    ld hl,ptr           ;0ba3 21 d4 23
    call pv2d           ;0ba6 cd 31 2c
l0ba9h:
    call pr0a           ;0ba9 cd 3d 2d
    ld hl,empty_string  ;0bac 21 98 28
    call pv2d           ;0baf cd 31 2c
    call pr0a           ;0bb2 cd 3d 2d
    ld hl,default_pun   ;0bb5 21 b3 23
    call pv1d           ;0bb8 cd 3c 2c
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
    call pr0a           ;0bcb cd 3d 2d
    ld hl,tty           ;0bce 21 11 24
    call pv2d           ;0bd1 cd 31 2c
    jp l0be0h           ;0bd4 c3 e0 0b
l0bd7h:
    call pr0a           ;0bd7 cd 3d 2d
    ld hl,ptp           ;0bda 21 ac 23
    call pv2d           ;0bdd cd 31 2c
l0be0h:
    call pr0a           ;0be0 cd 3d 2d
    ld hl,empty_string  ;0be3 21 98 28
    call pv2d           ;0be6 cd 31 2c
    call pr0a           ;0be9 cd 3d 2d
    ld hl,pet_prtr_type ;0bec 21 8b 23
    call pv1d           ;0bef cd 3c 2c
    ld hl,(02d4h)       ;0bf2 2a d4 02
    ld a,h              ;0bf5 7c
    or l                ;0bf6 b5
    jp nz,l0c03h        ;0bf7 c2 03 0c
    call pr0a           ;0bfa cd 3d 2d
    ld hl,cbm_3022_2    ;0bfd 21 7f 23
l0c00h:
    call pv2d           ;0c00 cd 31 2c
l0c03h:
    ld hl,(02d4h)       ;0c03 2a d4 02
    ld de,0ffffh        ;0c06 11 ff ff
    add hl,de           ;0c09 19
    ld a,h              ;0c0a 7c
    or l                ;0c0b b5
    jp nz,l0c18h        ;0c0c c2 18 0c
    call pr0a           ;0c0f cd 3d 2d
    ld hl,daisywheel_2  ;0c12 21 73 23
    call pv2d           ;0c15 cd 31 2c
l0c18h:
    ld hl,(02d4h)       ;0c18 2a d4 02
    ld de,0fffeh        ;0c1b 11 fe ff
    add hl,de           ;0c1e 19
    ld a,h              ;0c1f 7c
    or l                ;0c20 b5
    jp nz,l0c2dh        ;0c21 c2 2d 0c
    call pr0a           ;0c24 cd 3d 2d
    ld hl,cbm8024_2     ;0c27 21 6c 23
    call pv2d           ;0c2a cd 31 2c
l0c2dh:
    call pr0a           ;0c2d cd 3d 2d
    ld hl,empty_string  ;0c30 21 98 28
    call pv2d           ;0c33 cd 31 2c
    call pr0a           ;0c36 cd 3d 2d
    ld hl,empty_string  ;0c39 21 98 28
    call pv2d           ;0c3c cd 31 2c
    call pr0a           ;0c3f cd 3d 2d
    ld hl,alter_which_1_8 ;0c42 21 55 23
    call pv1d           ;0c45 cd 3c 2c
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
    call pr0a           ;0c89 cd 3d 2d
    ld hl,new_dev_num   ;0c8c 21 43 23
    call pv1d           ;0c8f cd 3c 2c
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
    call pr0a           ;0ce0 cd 3d 2d
    ld hl,empty_string  ;0ce3 21 98 28
    call pv2d           ;0ce6 cd 31 2c
    call pr0a           ;0ce9 cd 3d 2d
    ld hl,tty_rs232     ;0cec 21 28 23
    call pv2d           ;0cef cd 31 2c
    call pr0a           ;0cf2 cd 3d 2d
    ld hl,crt_pet_scrn  ;0cf5 21 10 23
    call pv2d           ;0cf8 cd 31 2c
    call pr0a           ;0cfb cd 3d 2d
    ld hl,lpt_pet       ;0cfe 21 f2 22
    call pv2d           ;0d01 cd 31 2c
    call pr0a           ;0d04 cd 3d 2d
    ld hl,ul1_ascii     ;0d07 21 d2 22
    call pv2d           ;0d0a cd 31 2c
    call pr0a           ;0d0d cd 3d 2d
    ld hl,empty_string  ;0d10 21 98 28
    call pv2d           ;0d13 cd 31 2c
    call pr0a           ;0d16 cd 3d 2d
    ld hl,which_list_dev ;0d19 21 ac 22
    call pv1d           ;0d1c cd 3c 2c
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
    call pr0a           ;0da5 cd 3d 2d
    ld hl,tty_or_ptr    ;0da8 21 96 22
    call pv1d           ;0dab cd 3c 2c
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
    call pr0a           ;0df0 cd 3d 2d
    ld hl,tty_or_ptp    ;0df3 21 80 22
    call pv1d           ;0df6 cd 3c 2c
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
    call pr0a           ;0e3b cd 3d 2d
    ld hl,empty_string  ;0e3e 21 98 28
    call pv2d           ;0e41 cd 31 2c
    call pr0a           ;0e44 cd 3d 2d
    ld hl,cbm3022        ;0e47 21 61 22
    call pv2d           ;0e4a cd 31 2c
    call pr0a           ;0e4d cd 3d 2d
    ld hl,cbm8024        ;0e50 21 56 22
    call pv2d           ;0e53 cd 31 2c
    call pr0a           ;0e56 cd 3d 2d
    ld hl,daisywheel    ;0e59 21 36 22
    call pv2d           ;0e5c cd 31 2c
    call pr0a           ;0e5f cd 3d 2d
    ld hl,empty_string  ;0e62 21 98 28
    call pv2d           ;0e65 cd 31 2c
    call pr0a           ;0e68 cd 3d 2d
    ld hl,which_printer ;0e6b 21 0f 22
    call pv1d           ;0e6e cd 3c 2c
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
    call clear_screen   ;0ead cd bd 1b
    call pr0a           ;0eb0 cd 3d 2d
    ld hl,drv_assgnmt   ;0eb3 21 eb 21
    call pv2d           ;0eb6 cd 31 2c
    call pr0a           ;0eb9 cd 3d 2d
    ld hl,dashes_2      ;0ebc 21 c7 21
    call pv2d           ;0ebf cd 31 2c
    call pr0a           ;0ec2 cd 3d 2d
    ld hl,empty_string  ;0ec5 21 98 28
    call pv2d           ;0ec8 cd 31 2c
    call pr0a           ;0ecb cd 3d 2d
    ld hl,drives_a_b    ;0ece 21 b9 21
    call pv1d           ;0ed1 cd 3c 2c
    ld hl,0000h         ;0ed4 21 00 00
    ld (l02dch),hl      ;0ed7 22 dc 02
    call sub_119ah      ;0eda cd 9a 11
    call pr0a           ;0edd cd 3d 2d
    ld hl,drives_c_d    ;0ee0 21 ab 21
    call pv1d           ;0ee3 cd 3c 2c
    ld hl,0001h         ;0ee6 21 01 00
    ld (l02dch),hl      ;0ee9 22 dc 02
    call sub_119ah      ;0eec cd 9a 11
    call pr0a           ;0eef cd 3d 2d
    ld hl,drives_e_f    ;0ef2 21 9d 21
    call pv1d           ;0ef5 cd 3c 2c
    ld hl,0002h         ;0ef8 21 02 00
    ld (l02dch),hl      ;0efb 22 dc 02
    call sub_119ah      ;0efe cd 9a 11
    call pr0a           ;0f01 cd 3d 2d
    ld hl,drives_g_h    ;0f04 21 8f 21
    call pv1d           ;0f07 cd 3c 2c
    ld hl,0003h         ;0f0a 21 03 00
    ld (l02dch),hl      ;0f0d 22 dc 02
    call sub_119ah      ;0f10 cd 9a 11
    call pr0a           ;0f13 cd 3d 2d
    ld hl,drives_i_j    ;0f16 21 81 21
    call pv1d           ;0f19 cd 3c 2c
    ld hl,0004h         ;0f1c 21 04 00
    ld (l02dch),hl      ;0f1f 22 dc 02
    call sub_119ah      ;0f22 cd 9a 11
    call pr0a           ;0f25 cd 3d 2d
    ld hl,drives_k_l    ;0f28 21 73 21
    call pv1d           ;0f2b cd 3c 2c
    ld hl,0005h         ;0f2e 21 05 00
    ld (l02dch),hl      ;0f31 22 dc 02
    call sub_119ah      ;0f34 cd 9a 11
    call pr0a           ;0f37 cd 3d 2d
    ld hl,drives_m_n    ;0f3a 21 65 21
    call pv1d           ;0f3d cd 3c 2c
    ld hl,0006h         ;0f40 21 06 00
    ld (l02dch),hl      ;0f43 22 dc 02
    call sub_119ah      ;0f46 cd 9a 11
    call pr0a           ;0f49 cd 3d 2d
    ld hl,drives_o_p    ;0f4c 21 57 21
    call pv1d           ;0f4f cd 3c 2c
    ld hl,0007h         ;0f52 21 07 00
    ld (l02dch),hl      ;0f55 22 dc 02
    call sub_119ah      ;0f58 cd 9a 11
    call pr0a           ;0f5b cd 3d 2d
    ld hl,empty_string  ;0f5e 21 98 28
    call pv2d           ;0f61 cd 31 2c
    call pr0a           ;0f64 cd 3d 2d
    ld hl,alter_which_pair ;0f67 21 32 21
    call pv1d           ;0f6a cd 3c 2c
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
    call pr0a           ;0fb5 cd 3d 2d
    ld hl,empty_string  ;0fb8 21 98 28
    call pv2d           ;0fbb cd 31 2c
    call pr0a           ;0fbe cd 3d 2d
    ld hl,cbm_hard_unused ;0fc1 21 0a 21
    call pv1d           ;0fc4 cd 3c 2c
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
    call pr0a           ;1039 cd 3d 2d
    ld hl,drv_5_10_20   ;103c 21 ed 20
    call pv1d           ;103f cd 3c 2c
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
    call pr0a           ;109f cd 3d 2d
    ld hl,dev_num_for_drv ;10a2 21 d0 20
    call pv1d           ;10a5 cd 3c 2c
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
    call pr0a           ;10d2 cd 3d 2d
    ld hl,config_as_1_or_2 ;10d5 21 ab 20
    call pv1d           ;10d8 cd 3c 2c
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
    call pr0a           ;10fb cd 3d 2d
    ld hl,drv_3_6_12    ;10fe 21 8f 20
    call pv1d           ;1101 cd 3c 2c
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
    call pr0a           ;1161 cd 3d 2d
    ld hl,use_entire_drv ;1164 21 65 20
    call pv2d           ;1167 cd 31 2c
    call pr0a           ;116a cd 3d 2d
    ld hl,use_first_half ;116d 21 46 20
    call pv1d           ;1170 cd 3c 2c
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
    call pr0a           ;11ab cd 3d 2d
    ld hl,cbm_3040      ;11ae 21 38 20
    call pv1d           ;11b1 cd 3c 2c
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
    call pr0a           ;11cd cd 3d 2d
    ld hl,cbm_8050      ;11d0 21 2a 20
    call pv1d           ;11d3 cd 3c 2c
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
    call pr0a           ;11f3 cd 3d 2d
    ld hl,not_used      ;11f6 21 1f 20
    call pv2d           ;11f9 cd 31 2c
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
    call pr0a           ;121f cd 3d 2d
l1222h:
    ld hl,cor_10mb      ;1222 21 11 20
    call pv1d           ;1225 cd 3c 2c
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
    call pr0a           ;123e cd 3d 2d
    ld hl,cor_20mb      ;1241 21 03 20
    call pv1d           ;1244 cd 3c 2c
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
    call pr0a           ;125d cd 3d 2d
    ld hl,cor_5mb       ;1260 21 f5 1f
    call pv1d           ;1263 cd 3c 2c
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
    call pr0a           ;127c cd 3d 2d
    ld hl,cor_5mb_star  ;127f 21 e7 1f
    call pv1d           ;1282 cd 3c 2c
l1285h:
    call pr0a           ;1285 cd 3d 2d
    ld hl,device_num    ;1288 21 d9 1f
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
    call pr0a           ;129e cd 3d 2d
    ld hl,winchester    ;12a1 21 c8 1f
    call pv1d           ;12a4 cd 3c 2c
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
    call pr0a           ;131a cd 3d 2d
    ld hl,mw_3mb_half   ;131d 21 8e 1f
    call pv2d           ;1320 cd 31 2c
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
    call pr0a           ;1339 cd 3d 2d
    ld hl,mw_6mb_half   ;133c 21 7d 1f
    call pv2d           ;133f cd 31 2c
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
    call pr0a           ;1358 cd 3d 2d
    ld hl,mw_12mb_half  ;135b 21 6c 1f
    call pv2d           ;135e cd 31 2c
l1361h:
    ret                 ;1361 c9
l1362h:
    call clear_screen   ;1362 cd bd 1b
    ld hl,(013ah)       ;1365 2a 3a 01
    ld a,h              ;1368 7c
    or l                ;1369 b5
    jp nz,l1379h        ;136a c2 79 13
    call pr0a           ;136d cd 3d 2d
    ld hl,no_aload_cmd  ;1370 21 4e 1f
    call pv2d           ;1373 cd 31 2c
    jp l13bfh           ;1376 c3 bf 13
l1379h:
    call pr0a           ;1379 cd 3d 2d
    ld hl,cur_aload_is  ;137c 21 2e 1f
    call pv2d           ;137f cd 31 2c
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
    call pr0a           ;13bf cd 3d 2d
    ld hl,empty_string  ;13c2 21 98 28
    call pv2d           ;13c5 cd 31 2c
    call pr0a           ;13c8 cd 3d 2d
    ld hl,new_aload_yn  ;13cb 21 0e 1f
    call pv1d           ;13ce cd 3c 2c
    call sub_1bcah      ;13d1 cd ca 1b
    ld hl,(02b2h)       ;13d4 2a b2 02
    ld de,0ffa7h        ;13d7 11 a7 ff
    add hl,de           ;13da 19
    ld a,h              ;13db 7c
    or l                ;13dc b5
    jp nz,l05b5h        ;13dd c2 b5 05
    call pr0a           ;13e0 cd 3d 2d
    ld hl,new_command   ;13e3 21 ec 1e
    call pv2d           ;13e6 cd 31 2c
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
    call pr0a           ;1668 cd 3d 2d
    ld hl,save_on_which ;166b 21 ca 1e
    call pv1d           ;166e cd 3c 2c
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
    call dtype          ;16b5 cd 90 29
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
    call pr0a           ;16c8 cd 3d 2d
    ld hl,no_drive      ;16cb 21 b4 1e
    call pv2d           ;16ce cd 31 2c
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
    call cwrite_        ;1708 cd 56 29
    jp l05b5h           ;170b c3 b5 05
l170eh:
    ld hl,l02dch        ;170e 21 dc 02
    call idisk          ;1711 cd 99 29
    ld hl,l02dch        ;1714 21 dc 02
    call savesy         ;1717 cd 02 2a
    ld hl,l02b6h        ;171a 21 b6 02
    call dskerr         ;171d cd 9d 29
    ld hl,(l02b6h)      ;1720 2a b6 02
    ld a,h              ;1723 7c
    or l                ;1724 b5
    jp z,l05b5h         ;1725 ca b5 05
    call pr0a           ;1728 cd 3d 2d
    ld hl,retry_yn      ;172b 21 a2 1e
    call pv1d           ;172e cd 3c 2c
    call sub_1bcah      ;1731 cd ca 1b
    ld hl,(02b2h)       ;1734 2a b2 02
    ld de,0ffa7h        ;1737 11 a7 ff
    add hl,de           ;173a 19
    ld a,h              ;173b 7c
    or l                ;173c b5
    jp z,l170eh         ;173d ca 0e 17
    jp l05b5h           ;1740 c3 b5 05
l1743h:
    call clear_screen   ;1743 cd bd 1b
    call pr0a           ;1746 cd 3d 2d
    ld hl,pet_params    ;1749 21 82 1e
    call pv2d           ;174c cd 31 2c
    call pr0a           ;174f cd 3d 2d
    ld hl,dashes        ;1752 21 62 1e
    call pv2d           ;1755 cd 31 2c
    call pr0a           ;1758 cd 3d 2d
    ld hl,empty_string  ;175b 21 98 28
    call pv2d           ;175e cd 31 2c
    call pr0a           ;1761 cd 3d 2d
    ld hl,cols_in_dir   ;1764 21 40 1e
    call pv1d           ;1767 cd 3c 2c
    ld hl,(02b8h)       ;176a 2a b8 02
    ld a,h              ;176d 7c
    or l                ;176e b5
    jp nz,l177eh        ;176f c2 7e 17
    call pr0a           ;1772 cd 3d 2d
    ld hl,one           ;1775 21 50 26
    call pv2d           ;1778 cd 31 2c
    jp l179fh           ;177b c3 9f 17
l177eh:
    ld hl,(02b8h)       ;177e 2a b8 02
    ld de,0ffffh        ;1781 11 ff ff
    add hl,de           ;1784 19
    ld a,h              ;1785 7c
    or l                ;1786 b5
    jp nz,l1796h        ;1787 c2 96 17
    call pr0a           ;178a cd 3d 2d
    ld hl,two           ;178d 21 46 26
    call pv2d           ;1790 cd 31 2c
    jp l179fh           ;1793 c3 9f 17
l1796h:
    call pr0a           ;1796 cd 3d 2d
    ld hl,four          ;1799 21 3c 1e
    call pv2d           ;179c cd 31 2c
l179fh:
    call pr0a           ;179f cd 3d 2d
    ld hl,empty_string  ;17a2 21 98 28
    call pv2d           ;17a5 cd 31 2c
    call pr0a           ;17a8 cd 3d 2d
    ld hl,crt_in_upper  ;17ab 21 1a 1e
    call pv1d           ;17ae cd 3c 2c
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
    call pr0a           ;17c1 cd 3d 2d
    ld hl,yes           ;17c4 21 14 1e
    call pv2d           ;17c7 cd 31 2c
    jp l17d6h           ;17ca c3 d6 17
l17cdh:
    call pr0a           ;17cd cd 3d 2d
    ld hl,no            ;17d0 21 0f 1e
    call pv2d           ;17d3 cd 31 2c
l17d6h:
    call pr0a           ;17d6 cd 3d 2d
    ld hl,empty_string  ;17d9 21 98 28
    call pv2d           ;17dc cd 31 2c
    call pr0a           ;17df cd 3d 2d
    ld hl,crt_term_emu  ;17e2 21 ed 1d
    call pv1d           ;17e5 cd 3c 2c
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
    call pr0a           ;17f8 cd 3d 2d
    ld hl,adm3a         ;17fb 21 e5 1d
    call pv2d           ;17fe cd 31 2c
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
    call pr0a           ;1818 cd 3d 2d
    ld hl,tv912         ;181b 21 dd 1d
    call pv2d           ;181e cd 31 2c
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
    call pr0a           ;1838 cd 3d 2d
    ld hl,hz1500        ;183b 21 d4 1d
    call pv2d           ;183e cd 31 2c
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
    call pr0a           ;1853 cd 3d 2d
    ld hl,leadin_esc    ;1856 21 ac 1d
    call pv2d           ;1859 cd 31 2c
l185ch:
    ld hl,(l02c8h)      ;185c 2a c8 02
    ld de,0ff82h        ;185f 11 82 ff
    add hl,de           ;1862 19
    ld a,h              ;1863 7c
    or l                ;1864 b5
    jp nz,l1871h        ;1865 c2 71 18
    call pr0a           ;1868 cd 3d 2d
    ld hl,leadin_tilde  ;186b 21 91 1d
    call pv2d           ;186e cd 31 2c
l1871h:
    call pr0a           ;1871 cd 3d 2d
    ld hl,empty_string  ;1874 21 98 28
    call pv2d           ;1877 cd 31 2c
    call pr0a           ;187a cd 3d 2d
    ld hl,clock_freq    ;187d 21 6f 1d
    call pv1d           ;1880 cd 3c 2c
    ld hl,(l02d0h+2)    ;1883 2a d2 02
    call sub_2cc8h      ;1886 cd c8 2c
    call pr0a           ;1889 cd 3d 2d
    ld hl,empty_string  ;188c 21 98 28
    call pv2d           ;188f cd 31 2c
    call pr0a           ;1892 cd 3d 2d
    ld hl,alter_which_1_4 ;1895 21 58 1d
    call pv1d           ;1898 cd 3c 2c
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
    call pr0a           ;18ea cd 3d 2d
    ld hl,num_of_cols   ;18ed 21 35 1d
    call pv1d           ;18f0 cd 3c 2c
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
    call pr0a           ;192f cd 3d 2d
    ld hl,new_clock     ;1932 21 1c 1d
    call pv1d           ;1935 cd 3c 2c
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
    call pr0a           ;194c cd 3d 2d
    ld hl,screen_type   ;194f 21 f4 1c
    call pv1d           ;1952 cd 3c 2c
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
    call pr0a           ;19a6 cd 3d 2d
    ld hl,esc_or_tilde  ;19a9 21 ce 1c
    call pv1d           ;19ac cd 3c 2c
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

clear_screen:
    call pr0a
    ld hl,001ah
    call chr
    call pv2d
    ret

sub_1bcah:
    ld hl,0080h         ;1bca 21 80 00
    ld (02e0h),hl       ;1bcd 22 e0 02
    ld hl,(02e0h)       ;1bd0 2a e0 02
    ld (hl),50h         ;1bd3 36 50
    call buffin         ;1bd5 cd a1 28

    call pr0a           ;1bd8 cd 3d 2d
    ld hl,empty_string  ;1bdb 21 98 28
    call pv2d           ;1bde cd 31 2c

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

ul1:
    db 04h
    dw ul1+3
    db "UL1:"

lpt:
    db 04h
    dw lpt+3
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
    ld c,0ah            ;28a1 0e 0a
    ld de,0080h         ;28a3 11 80 00
    jp 0005h            ;28a6 c3 05 00

exsys:
;Execute a new CP/M system.  The buffer at 4000h contains a new
;CP/M system image (7168 bytes = CCP + BDOS + BIOS config + BIOS storage).
;Copy the new system into place and then jump to the BIOS to start it.
    ld bc,1c00h         ;28a9 01 00 1c
    ld hl,4000h         ;28ac 21 00 40
    ld de,0d400h        ;28af 11 00 d4
    ldir                ;28b2 ed b0
    jp 0f075h           ;28b4 c3 75 f0

rdsys:
;Read the "CP/M" and "K" files from an IEEE-488 drive into memory.
    ld a,(hl)           ;28b7 7e
    ld (l2be5h),a       ;28b8 32 e5 2b
    call 0f054h         ;28bb cd 54 f0
    ld e,00h            ;28be 1e 00
    push de             ;28c0 d5
    call sub_29deh      ;28c1 cd de 29
    ld a,(l2be5h)       ;28c4 3a e5 2b
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

cread_:
;Read CP/M image from a Corvus drive.
    ld c,(hl)           ;2922 4e
    call 0f01bh         ;2923 cd 1b f0
    ld de,4000h         ;2926 11 00 40
    ld bc,0000h         ;2929 01 00 00
cread2:
    call 0f01eh         ;292c cd 1e f0
    push bc             ;292f c5
    ld bc,0000h         ;2930 01 00 00
cread1:
    call 0f021h         ;2933 cd 21 f0
    push bc             ;2936 c5
    push de             ;2937 d5
    call 0f027h         ;2938 cd 27 f0
    or a                ;293b b7
    jr nz,cwrit3        ;293c 20 4c
    pop de              ;293e d1
    ld bc,0080h         ;293f 01 80 00
    ld hl,0080h         ;2942 21 80 00
l2945h:
    ldir                ;2945 ed b0
    pop bc              ;2947 c1
    inc c               ;2948 0c
    ld a,c              ;2949 79
    cp 40h              ;294a fe 40
    jr nz,cread1        ;294c 20 e5
    pop bc              ;294e c1
    inc c               ;294f 0c
    ld a,c              ;2950 79
    cp 02h              ;2951 fe 02
    jr nz,cread2        ;2953 20 d7
    ret                 ;2955 c9

cwrite_:
;Write CP/M image to a Corvus drive.
    ld c,(hl)           ;2956 4e
    call 0f01bh         ;2957 cd 1b f0
    ld hl,4000h         ;295a 21 00 40
    ld bc,0000h         ;295d 01 00 00
cwrit2:
    call 0f01eh         ;2960 cd 1e f0
    push bc             ;2963 c5
    ld bc,0000h         ;2964 01 00 00
cwrit1:
    call 0f021h         ;2967 cd 21 f0
    push bc             ;296a c5
    ld bc,0080h         ;296b 01 80 00
    ld de,0080h         ;296e 11 80 00
    ldir                ;2971 ed b0
    push hl             ;2973 e5
    call 0f02ah         ;2974 cd 2a f0
    or a                ;2977 b7
    jr nz,cwrit3        ;2978 20 10
    pop hl              ;297a e1
    pop bc              ;297b c1
    inc c               ;297c 0c
    ld a,c              ;297d 79
    cp 40h              ;297e fe 40
    jr nz,cwrit1        ;2980 20 e5
    pop bc              ;2982 c1
    inc c               ;2983 0c
l2984h:
    ld a,c              ;2984 79
    cp 02h              ;2985 fe 02
    jr nz,cwrit2        ;2987 20 d7
    ret                 ;2989 c9
cwrit3:
    pop hl              ;298a e1
    pop hl              ;298b e1
    pop hl              ;298c e1
    jp l2b7ah           ;298d c3 7a 2b

dtype:
;Get the drive type for a CP/M drive number.
    ld a,(hl)           ;2990 7e
    call 0f051h         ;2991 cd 51 f0
    ld (hl),c           ;2994 71
    inc hl              ;2995 23
    ld (hl),00h         ;2996 36 00
    ret                 ;2998 c9

idisk:
;Initialize an IEEE-488 disk drive.
    ld a,(hl)           ;2999 7e
    jp 0f078h           ;299a c3 78 f0

dskerr:
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
;Open "CP/M" file on an IEEE-488 drive
    ld c,06h            ;29de 0e 06
    ld hl,l2bd3h        ;29e0 21 d3 2b
l29e3h:
    ld a,(l2be5h)       ;29e3 3a e5 2b
    rra                 ;29e6 1f
    jp nc,0f05dh        ;29e7 d2 5d f0
    ld hl,l2bd9h        ;29ea 21 d9 2b
    jp 0f05dh           ;29ed c3 5d f0

sub_29f0h:
;Open "K" file on an IEEE-488 drive
    ld c,03h            ;29f0 0e 03
    ld hl,l2bdfh        ;29f2 21 df 2b
    ld a,(l2be5h)       ;29f5 3a e5 2b
    rra                 ;29f8 1f
    jp nc,0f05dh        ;29f9 d2 5d f0
    ld hl,l2be2h        ;29fc 21 e2 2b
l29ffh:
    jp 0f05dh           ;29ff c3 5d f0

savesy:
;Read the CP/M system image from an IEEE-488 drive.
    ld a,(hl)           ;2a02 7e
    ld (l2be5h),a       ;2a03 32 e5 2b
    call 0f054h         ;2a06 cd 54 f0
    push de             ;2a09 d5
    ld e,0fh            ;2a0a 1e 0f
    ld hl,l2bcbh        ;2a0c 21 cb 2b
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
    ld (l2ba6h+1),a     ;2a9c 32 a7 2b
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

l2be7h:
    cp 64h              ;2be7 fe 64
    jp z,53d6h          ;2be9 ca d6 53
l2bech:
    ld a,20h            ;2bec 3e 20
    call sub_2d2fh      ;2bee cd 2f 2d
    ret                 ;2bf1 c9
l2bf2h:
    ld a,0ah            ;2bf2 3e 0a
    call sub_2d2fh      ;2bf4 cd 2f 2d
    ld a,0dh            ;2bf7 3e 0d
    call sub_2d2fh      ;2bf9 cd 2f 2d
    ret                 ;2bfc c9
    ld a,02h            ;2bfd 3e 02
    ld (l2be7h),a       ;2bff 32 e7 2b
    ld a,l              ;2c02 7d
    call sub_2c14h      ;2c03 cd 14 2c
    ld (2beah),a        ;2c06 32 ea 2b
    ld a,l              ;2c09 7d
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

chr:
;Make a temporary string from the char in L and
;return a pointer to it in HL.
;Implements BASIC function: CHR$(x)
;
    ld a,01h            ;2c24 3e 01
    ld (l2be7h),a       ;2c26 32 e7 2b
    ld a,l              ;2c29 7d
    ld (2beah),a        ;2c2a 32 ea 2b
    ld hl,l2be7h        ;2c2d 21 e7 2b
    ret                 ;2c30 c9

pv2d:
;Print string in HL followed by CR+LF
;Implements BASIC command: PRINT"foo"
;
    ld a,(hl)           ;2c31 7e
    or a                ;2c32 b7
    jp z,l2bf2h         ;2c33 ca f2 2b
    call sub_2c4eh      ;2c36 cd 4e 2c
    jp l2bf2h           ;2c39 c3 f2 2b

pv1d:
;Print string in HL but do not send CR+LF
;Implements BASIC command: PRINT"foo";
;
    ld a,(hl)           ;2c3c 7e
    or a                ;2c3d b7
    ret z               ;2c3e c8
    call sub_2c4eh      ;2c3f cd 4e 2c
    ret                 ;2c42 c9

sub_2c43h:
    ld a,(hl)           ;2c43 7e
    or a                ;2c44 b7
    jp z,l2bech         ;2c45 ca ec 2b
    call sub_2c4eh      ;2c48 cd 4e 2c
    jp l2bech           ;2c4b c3 ec 2b
sub_2c4eh:
    ld b,a              ;2c4e 47
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
    ld de,2710h         ;2ceb 11 10 27
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

pr0a:
;Do nothing and return
    ret

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
    ld de,2710h         ;2d6b 11 10 27
    call sub_2d0bh      ;2d6e cd 0b 2d
    ld de,l03e8h        ;2d71 11 e8 03
    call sub_2d0bh      ;2d74 cd 0b 2d
    ld de,0064h         ;2d77 11 64 00
    call sub_2d0bh      ;2d7a cd 0b 2d
    ld de,000ah         ;2d7d 11 0a 00
