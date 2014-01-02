; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --output=newsys.asm newsys.com

    org 0100h

    jp l0af1h           ;0100 c3 f1 0a
sub_0103h:
    ld hl,l3006h        ;0103 21 06 30
    ld (hl),c           ;0106 71
    ld a,(l3006h)       ;0107 3a 06 30
    call 0f051h         ;010a cd 51 f0
    ld a,c              ;010d 79
    ret                 ;010e c9
    ld a,00h            ;010f 3e 00
    ret                 ;0111 c9
    ret                 ;0112 c9
sub_0113h:
    ld hl,l3007h        ;0113 21 07 30
    ld (hl),c           ;0116 71
    ld a,(l3007h)       ;0117 3a 07 30
    call 0f078h         ;011a cd 78 f0
    ret                 ;011d c9
sub_011eh:
    ld a,(l2423h)       ;011e 3a 23 24
    or a                ;0121 b7
    jp z,l0162h         ;0122 ca 62 01
    ld bc,l0c84h        ;0125 01 84 0c
    call sub_0184h      ;0128 cd 84 01
    ld hl,l3008h        ;012b 21 08 30
    ld (hl),00h         ;012e 36 00
    jp l0157h           ;0130 c3 57 01
l0133h:
    ld a,(l3008h)       ;0133 3a 08 30
    ld l,a              ;0136 6f
    rla                 ;0137 17
    sbc a,a             ;0138 9f
    ld bc,0eac0h        ;0139 01 c0 ea
    ld h,a              ;013c 67
    add hl,bc           ;013d 09
    ld c,(hl)           ;013e 4e
    call sub_016bh      ;013f cd 6b 01
    ld a,(l3008h)       ;0142 3a 08 30
    ld l,a              ;0145 6f
    rla                 ;0146 17
    sbc a,a             ;0147 9f
    ld bc,0eac0h        ;0148 01 c0 ea
    ld h,a              ;014b 67
    add hl,bc           ;014c 09
    ld a,(hl)           ;014d 7e
    cp 0dh              ;014e fe 0d
    jp z,l015fh         ;0150 ca 5f 01
    ld hl,l3008h        ;0153 21 08 30
    inc (hl)            ;0156 34
l0157h:
    ld a,(l3008h)       ;0157 3a 08 30
    cp 40h              ;015a fe 40
    jp m,l0133h         ;015c fa 33 01
l015fh:
    call sub_0179h      ;015f cd 79 01
l0162h:
    ld a,(l2423h)       ;0162 3a 23 24
    ret                 ;0165 c9
    ret                 ;0166 c9
sub_0167h:
    jp 0000h            ;0167 c3 00 00
    ret                 ;016a c9
sub_016bh:
    ld hl,l3009h        ;016b 21 09 30
    ld (hl),c           ;016e 71
    ld c,02h            ;016f 0e 02
    ld a,(l3009h)       ;0171 3a 09 30
    ld e,a              ;0174 5f
    call 0005h          ;0175 cd 05 00
    ret                 ;0178 c9
sub_0179h:
    ld c,0dh            ;0179 0e 0d
    call sub_016bh      ;017b cd 6b 01
    ld c,0ah            ;017e 0e 0a
    call sub_016bh      ;0180 cd 6b 01
    ret                 ;0183 c9
sub_0184h:
    ld hl,l300bh        ;0184 21 0b 30
    ld (hl),b           ;0187 70
    dec hl              ;0188 2b
    ld (hl),c           ;0189 71
    ld hl,(l300ah)      ;018a 2a 0a 30
    ld a,(hl)           ;018d 7e
    ld (l300ch),a       ;018e 32 0c 30
l0191h:
    ld hl,(l300ah)      ;0191 2a 0a 30
    inc hl              ;0194 23
    ld (l300ah),hl      ;0195 22 0a 30
    ld hl,(l300ah)      ;0198 2a 0a 30
    ld c,(hl)           ;019b 4e
    call sub_016bh      ;019c cd 6b 01
    ld hl,l300ch        ;019f 21 0c 30
    dec (hl)            ;01a2 35
    ld a,(hl)           ;01a3 7e
    or a                ;01a4 b7
    jp nz,l0191h        ;01a5 c2 91 01
    ret                 ;01a8 c9
sub_01a9h:
    ld hl,l300eh        ;01a9 21 0e 30
    ld (hl),b           ;01ac 70
    dec hl              ;01ad 2b
    ld (hl),c           ;01ae 71
    ld hl,(l300dh)      ;01af 2a 0d 30
    ld b,h              ;01b2 44
    ld c,l              ;01b3 4d
    call sub_0184h      ;01b4 cd 84 01
    call sub_0179h      ;01b7 cd 79 01
    ret                 ;01ba c9
sub_01bbh:
    call sub_25b5h      ;01bb cd b5 25
    nop                 ;01be 00
    ld (bc),a           ;01bf 02
    rrca                ;01c0 0f
    jr nc,$+35          ;01c1 30 21
    djnz l01f5h         ;01c3 10 30
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
    ld de,000ah         ;01d5 11 0a 00
    call sub_2529h      ;01d8 cd 29 25
    call sub_01bbh      ;01db cd bb 01
    ld hl,(l300fh)      ;01de 2a 0f 30
    ld b,h              ;01e1 44
    ld c,l              ;01e2 4d
    ld de,000ah         ;01e3 11 0a 00
    call sub_2529h      ;01e6 cd 29 25
    ld a,l              ;01e9 7d
    add a,30h           ;01ea c6 30
    ld c,a              ;01ec 4f
    call sub_016bh      ;01ed cd 6b 01
l01f0h:
    call sub_25f8h      ;01f0 cd f8 25
    ld (bc),a           ;01f3 02
    rrca                ;01f4 0f
l01f5h:
    jr nc,$+35          ;01f5 30 21
    ld (de),a           ;01f7 12
    jr nc,$+114         ;01f8 30 70
    dec hl              ;01fa 2b
    ld (hl),c           ;01fb 71
    ld hl,(l3011h)      ;01fc 2a 11 30
    ld a,l              ;01ff 7d
    or h                ;0200 b4
    jp nz,l020dh        ;0201 c2 0d 02
    ld bc,l0c93h        ;0204 01 93 0c
    call sub_0184h      ;0207 cd 84 01
    jp l0215h           ;020a c3 15 02
l020dh:
    ld hl,(l3011h)      ;020d 2a 11 30
    ld b,h              ;0210 44
    ld c,l              ;0211 4d
    call sub_01bbh      ;0212 cd bb 01
l0215h:
    ret                 ;0215 c9
sub_0216h:
    ld hl,l2424h        ;0216 21 24 24
    ld (hl),50h         ;0219 36 50
    ld de,l2424h        ;021b 11 24 24
    ld c,0ah            ;021e 0e 0a
    call 0005h          ;0220 cd 05 00
    ld hl,0000h         ;0223 21 00 00
    ld (l24c8h),hl      ;0226 22 c8 24
    ld (l24cah),hl      ;0229 22 ca 24
    ld a,(l2425h)       ;022c 3a 25 24
    or a                ;022f b7
    jp nz,l023bh        ;0230 c2 3b 02
    ld hl,l24cch        ;0233 21 cc 24
    ld (hl),0dh         ;0236 36 0d
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
    cp 61h              ;0267 fe 61
    jp m,l0278h         ;0269 fa 78 02
    cp 7bh              ;026c fe 7b
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
    ld hl,(l24c8h)      ;0297 2a c8 24
    ld b,h              ;029a 44
    ld c,l              ;029b 4d
    ld de,000ah         ;029c 11 0a 00
    call sub_24cdh      ;029f cd cd 24
    ld a,(l3014h)       ;02a2 3a 14 30
    ld l,a              ;02a5 6f
    rla                 ;02a6 17
    sbc a,a             ;02a7 9f
    ld h,a              ;02a8 67
    add hl,de           ;02a9 19
    ld (l24c8h),hl      ;02aa 22 c8 24
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
    ld (l24cch),a       ;02fc 32 cc 24
l02ffh:
    ret                 ;02ff c9
sub_0300h:
    ld c,1ah            ;0300 0e 1a
    call sub_016bh      ;0302 cd 6b 01
    ret                 ;0305 c9
sub_0306h:
    jp l05edh           ;0306 c3 ed 05
sub_0309h:
    ld bc,l0c93h+2      ;0309 01 95 0c
    call sub_0184h      ;030c cd 84 01
    call sub_0216h      ;030f cd 16 02
    call sub_0179h      ;0312 cd 79 01
    ld a,(l3016h)       ;0315 3a 16 30
    ld l,a              ;0318 6f
    rla                 ;0319 17
    sbc a,a             ;031a 9f
    ld bc,5678h         ;031b 01 78 56
    ld h,a              ;031e 67
    add hl,bc           ;031f 09
    ld a,(l24c8h)       ;0320 3a c8 24
    ld (hl),a           ;0323 77
    ld a,(l3016h)       ;0324 3a 16 30
    ld l,a              ;0327 6f
    rla                 ;0328 17
    sbc a,a             ;0329 9f
    ld bc,5670h         ;032a 01 70 56
    ld h,a              ;032d 67
    add hl,bc           ;032e 09
    ld a,(hl)           ;032f 7e
    cp 04h              ;0330 fe 04
    jp nz,l0358h        ;0332 c2 58 03
    ld bc,0cb0h         ;0335 01 b0 0c
    call sub_0184h      ;0338 cd 84 01
    call sub_0216h      ;033b cd 16 02
    call sub_0179h      ;033e cd 79 01
    ld hl,(l24c8h)      ;0341 2a c8 24
    dec hl              ;0344 2b
    dec hl              ;0345 2b
    ld a,h              ;0346 7c
    or l                ;0347 b5
    jp nz,l0358h        ;0348 c2 58 03
    ld a,(l3016h)       ;034b 3a 16 30
    ld l,a              ;034e 6f
    rla                 ;034f 17
    sbc a,a             ;0350 9f
    ld bc,5670h         ;0351 01 70 56
    ld h,a              ;0354 67
    add hl,bc           ;0355 09
    ld (hl),05h         ;0356 36 05
l0358h:
    ret                 ;0358 c9
l0359h:
    call sub_0300h      ;0359 cd 00 03
    ld bc,0cd3h         ;035c 01 d3 0c
    call sub_0184h      ;035f cd 84 01
    call sub_0179h      ;0362 cd 79 01
    call sub_0179h      ;0365 cd 79 01
    ld bc,0cf1h         ;0368 01 f1 0c
    call sub_01a9h      ;036b cd a9 01
    call sub_0179h      ;036e cd 79 01
    ld bc,l0d0eh        ;0371 01 0e 0d
    call sub_01a9h      ;0374 cd a9 01
    call sub_0179h      ;0377 cd 79 01
    ld bc,l0d2bh        ;037a 01 2b 0d
    call sub_01a9h      ;037d cd a9 01
    call sub_0179h      ;0380 cd 79 01
    ld bc,l0d48h        ;0383 01 48 0d
    call sub_01a9h      ;0386 cd a9 01
    call sub_0179h      ;0389 cd 79 01
    ld bc,l0d65h        ;038c 01 65 0d
    call sub_01a9h      ;038f cd a9 01
    call sub_0179h      ;0392 cd 79 01
    ld bc,l0d82h        ;0395 01 82 0d
    call sub_01a9h      ;0398 cd a9 01
    call sub_0179h      ;039b cd 79 01
    ld bc,l0d9fh        ;039e 01 9f 0d
    call sub_01a9h      ;03a1 cd a9 01
    call sub_0179h      ;03a4 cd 79 01
    call sub_0179h      ;03a7 cd 79 01
    ld bc,l0dc3h        ;03aa 01 c3 0d
    call sub_0184h      ;03ad cd 84 01
    call sub_0216h      ;03b0 cd 16 02
    call sub_0179h      ;03b3 cd 79 01
    ld a,(l24cch)       ;03b6 3a cc 24
    cp 41h              ;03b9 fe 41
    jp nz,l03cch        ;03bb c2 cc 03
    ld hl,l3017h        ;03be 21 17 30
    ld (hl),02h         ;03c1 36 02
    ld hl,00bfh         ;03c3 21 bf 00
    ld (l301ah),hl      ;03c6 22 1a 30
    jp l0483h           ;03c9 c3 83 04
l03cch:
    ld a,(l24cch)       ;03cc 3a cc 24
    cp 42h              ;03cf fe 42
    jp nz,l03e2h        ;03d1 c2 e2 03
    ld hl,l3017h        ;03d4 21 17 30
    ld (hl),04h         ;03d7 36 04
    ld hl,00bfh         ;03d9 21 bf 00
    ld (l301ah),hl      ;03dc 22 1a 30
    jp l0483h           ;03df c3 83 04
l03e2h:
    ld a,(l24cch)       ;03e2 3a cc 24
    cp 43h              ;03e5 fe 43
    jp nz,l03f8h        ;03e7 c2 f8 03
    ld hl,l3017h        ;03ea 21 17 30
    ld (hl),08h         ;03ed 36 08
    ld hl,00bfh         ;03ef 21 bf 00
    ld (l301ah),hl      ;03f2 22 1a 30
    jp l0483h           ;03f5 c3 83 04
l03f8h:
    ld a,(l24cch)       ;03f8 3a cc 24
    cp 44h              ;03fb fe 44
    jp nz,l040eh        ;03fd c2 0e 04
    ld hl,l3017h        ;0400 21 17 30
    ld (hl),02h         ;0403 36 02
    ld hl,0140h         ;0405 21 40 01
    ld (l301ah),hl      ;0408 22 1a 30
    jp l0483h           ;040b c3 83 04
l040eh:
    ld a,(l24cch)       ;040e 3a cc 24
    cp 45h              ;0411 fe 45
    jp nz,l0424h        ;0413 c2 24 04
    ld hl,l3017h        ;0416 21 17 30
    ld (hl),04h         ;0419 36 04
    ld hl,0140h         ;041b 21 40 01
    ld (l301ah),hl      ;041e 22 1a 30
    jp l0483h           ;0421 c3 83 04
l0424h:
    ld a,(l24cch)       ;0424 3a cc 24
    cp 46h              ;0427 fe 46
    jp nz,l043ah        ;0429 c2 3a 04
    ld hl,l3017h        ;042c 21 17 30
    ld (hl),06h         ;042f 36 06
    ld hl,0140h         ;0431 21 40 01
l0434h:
    ld (l301ah),hl      ;0434 22 1a 30
l0437h:
    jp l0483h           ;0437 c3 83 04
l043ah:
    ld a,(l24cch)       ;043a 3a cc 24
    cp 5ah              ;043d fe 5a
    jp nz,l0480h        ;043f c2 80 04
l0442h:
    ld bc,0de2h         ;0442 01 e2 0d
    call sub_0184h      ;0445 cd 84 01
    call sub_0216h      ;0448 cd 16 02
    ld a,(l24c8h)       ;044b 3a c8 24
    ld (l3017h),a       ;044e 32 17 30
    cp 02h              ;0451 fe 02
    jp z,l046eh         ;0453 ca 6e 04
    cp 04h              ;0456 fe 04
    jp z,l046eh         ;0458 ca 6e 04
    cp 06h              ;045b fe 06
    jp z,l046eh         ;045d ca 6e 04
    cp 08h              ;0460 fe 08
    jp z,l046eh         ;0462 ca 6e 04
    ld bc,0dffh         ;0465 01 ff 0d
    call sub_01a9h      ;0468 cd a9 01
    jp l0442h           ;046b c3 42 04
l046eh:
    ld bc,l0e14h        ;046e 01 14 0e
    call sub_0184h      ;0471 cd 84 01
    call sub_0216h      ;0474 cd 16 02
    ld hl,(l24c8h)      ;0477 2a c8 24
    ld (l301ah),hl      ;047a 22 1a 30
    jp l0483h           ;047d c3 83 04
l0480h:
    jp l0359h           ;0480 c3 59 03
l0483h:
    ld a,(l3017h)       ;0483 3a 17 30
    or a                ;0486 b7
    rra                 ;0487 1f
    inc a               ;0488 3c
    ld c,a              ;0489 4f
    ld a,(l3016h)       ;048a 3a 16 30
    ld l,a              ;048d 6f
    rla                 ;048e 17
    sbc a,a             ;048f 9f
    ld de,5670h         ;0490 11 70 56
    ld h,a              ;0493 67
    add hl,de           ;0494 19
    ld (hl),c           ;0495 71
l0496h:
    ld bc,0e35h         ;0496 01 35 0e
    call sub_01a9h      ;0499 cd a9 01
    ld bc,l0e53h        ;049c 01 53 0e
    call sub_0184h      ;049f cd 84 01
    call sub_0216h      ;04a2 cd 16 02
    call sub_0179h      ;04a5 cd 79 01
    ld a,(l24cch)       ;04a8 3a cc 24
    cp 48h              ;04ab fe 48
    jp nz,l04c0h        ;04ad c2 c0 04
    ld hl,(l301ah)      ;04b0 2a 1a 30
    or a                ;04b3 b7
    ld a,h              ;04b4 7c
    rra                 ;04b5 1f
    ld h,a              ;04b6 67
    ld a,l              ;04b7 7d
    rra                 ;04b8 1f
    ld l,a              ;04b9 6f
    ld (l301ch),hl      ;04ba 22 1c 30
    jp l04d4h           ;04bd c3 d4 04
l04c0h:
    ld a,(l24cch)       ;04c0 3a cc 24
    cp 45h              ;04c3 fe 45
    jp nz,l04d1h        ;04c5 c2 d1 04
    ld hl,(l301ah)      ;04c8 2a 1a 30
    ld (l301ch),hl      ;04cb 22 1c 30
    jp l04d4h           ;04ce c3 d4 04
l04d1h:
    jp l0496h           ;04d1 c3 96 04
l04d4h:
    ld a,(l3017h)       ;04d4 3a 17 30
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
    ld hl,(l301ch)      ;04e3 2a 1c 30
    ld b,h              ;04e6 44
    ld c,l              ;04e7 4d
    pop hl              ;04e8 e1
    ex de,hl            ;04e9 eb
    call sub_24cdh      ;04ea cd cd 24
    dec de              ;04ed 1b
    ex de,hl            ;04ee eb
    ld (5805h),hl       ;04ef 22 05 58
    ld bc,0ff00h        ;04f2 01 00 ff
    ld hl,(5805h)       ;04f5 2a 05 58
    add hl,bc           ;04f8 09
    add hl,hl           ;04f9 29
    jp c,l0505h         ;04fa da 05 05
    ld hl,5804h         ;04fd 21 04 58
    ld (hl),03h         ;0500 36 03
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
l0531h:
    ld bc,0e73h         ;0531 01 73 0e
    call sub_0184h      ;0534 cd 84 01
    call sub_0216h      ;0537 cd 16 02
    call sub_0179h      ;053a cd 79 01
    ld a,(l24cch)       ;053d 3a cc 24
    cp 30h              ;0540 fe 30
    jp m,l0555h         ;0542 fa 55 05
    cp 32h              ;0545 fe 32
    jp p,l0555h         ;0547 f2 55 05
    ld a,(l24cch)       ;054a 3a cc 24
    add a,0d0h          ;054d c6 d0
    ld (l3018h),a       ;054f 32 18 30
    jp l0558h           ;0552 c3 58 05
l0555h:
    jp l0531h           ;0555 c3 31 05
l0558h:
    ld bc,0e8fh         ;0558 01 8f 0e
    call sub_0184h      ;055b cd 84 01
    call sub_0216h      ;055e cd 16 02
    call sub_0179h      ;0561 cd 79 01
    ld a,(l24cch)       ;0564 3a cc 24
    cp 59h              ;0567 fe 59
    jp nz,l0574h        ;0569 c2 74 05
    ld hl,l3019h        ;056c 21 19 30
    ld (hl),00h         ;056f 36 00
    jp l05a6h           ;0571 c3 a6 05
l0574h:
    ld a,(l24cch)       ;0574 3a cc 24
    cp 4eh              ;0577 fe 4e
    jp nz,l05a3h        ;0579 c2 a3 05
    ld bc,0eb2h         ;057c 01 b2 0e
    call sub_0184h      ;057f cd 84 01
    call sub_0216h      ;0582 cd 16 02
    call sub_0179h      ;0585 cd 79 01
    ld hl,(l24c8h)      ;0588 2a c8 24
    add hl,hl           ;058b 29
    jp c,l0558h         ;058c da 58 05
    ld bc,0fff0h        ;058f 01 f0 ff
    ld hl,(l24c8h)      ;0592 2a c8 24
    add hl,bc           ;0595 09
    add hl,hl           ;0596 29
    jp nc,l0558h        ;0597 d2 58 05
    ld a,(l24c8h)       ;059a 3a c8 24
    ld (l3019h),a       ;059d 32 19 30
    jp l05a6h           ;05a0 c3 a6 05
l05a3h:
    jp l0496h           ;05a3 c3 96 04
l05a6h:
    ld c,04h            ;05a6 0e 04
    ld a,(l3019h)       ;05a8 3a 19 30
    jp l05afh           ;05ab c3 af 05
l05aeh:
    add a,a             ;05ae 87
l05afh:
    dec c               ;05af 0d
    jp p,l05aeh         ;05b0 f2 ae 05
    ld hl,l3018h        ;05b3 21 18 30
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
    ld a,(l3018h)       ;05c4 3a 18 30
    ld l,a              ;05c7 6f
    rla                 ;05c8 17
    sbc a,a             ;05c9 9f
    ld h,a              ;05ca 67
    add hl,hl           ;05cb 29
    ld bc,5648h         ;05cc 01 48 56
    add hl,bc           ;05cf 09
    ex de,hl            ;05d0 eb
    ld hl,(l301ah)      ;05d1 2a 1a 30
    ex de,hl            ;05d4 eb
    ld (hl),e           ;05d5 73
    inc hl              ;05d6 23
    ld (hl),d           ;05d7 72
    ld a,(l3018h)       ;05d8 3a 18 30
    ld l,a              ;05db 6f
    rla                 ;05dc 17
    sbc a,a             ;05dd 9f
    ld h,a              ;05de 67
    add hl,hl           ;05df 29
    ld bc,564ch         ;05e0 01 4c 56
    add hl,bc           ;05e3 09
    ex de,hl            ;05e4 eb
    ld hl,(l301ch)      ;05e5 2a 1c 30
    ex de,hl            ;05e8 eb
    ld (hl),e           ;05e9 73
    inc hl              ;05ea 23
    ld (hl),d           ;05eb 72
    ret                 ;05ec c9
l05edh:
    call sub_0300h      ;05ed cd 00 03
    ld bc,0ecch         ;05f0 01 cc 0e
    call sub_01a9h      ;05f3 cd a9 01
    ld bc,0ee3h         ;05f6 01 e3 0e
    call sub_01a9h      ;05f9 cd a9 01
    call sub_0179h      ;05fc cd 79 01
    call sub_0179h      ;05ff cd 79 01
    ld hl,l3016h        ;0602 21 16 30
    ld (hl),00h         ;0605 36 00
    jp l085eh           ;0607 c3 5e 08
l060ah:
    ld a,(l3016h)       ;060a 3a 16 30
    add a,a             ;060d 87
    add a,41h           ;060e c6 41
    ld c,a              ;0610 4f
    call sub_016bh      ;0611 cd 6b 01
    ld bc,l0efah        ;0614 01 fa 0e
    call sub_0184h      ;0617 cd 84 01
    ld a,(l3016h)       ;061a 3a 16 30
    add a,a             ;061d 87
    add a,42h           ;061e c6 42
l0620h:
    ld c,a              ;0620 4f
    call sub_016bh      ;0621 cd 6b 01
    ld bc,0efdh         ;0624 01 fd 0e
    call sub_0184h      ;0627 cd 84 01
    ld a,(l3016h)       ;062a 3a 16 30
    ld l,a              ;062d 6f
    rla                 ;062e 17
    sbc a,a             ;062f 9f
    ld bc,5670h         ;0630 01 70 56
    ld h,a              ;0633 67
    add hl,bc           ;0634 09
    ld a,(hl)           ;0635 7e
    or a                ;0636 b7
    jp nz,l0657h        ;0637 c2 57 06
    ld bc,l0f05h        ;063a 01 05 0f
    call sub_0184h      ;063d cd 84 01
    ld a,(l3016h)       ;0640 3a 16 30
    ld l,a              ;0643 6f
    rla                 ;0644 17
    sbc a,a             ;0645 9f
    ld bc,5678h         ;0646 01 78 56
    ld h,a              ;0649 67
    add hl,bc           ;064a 09
    ld a,(hl)           ;064b 7e
    ld l,a              ;064c 6f
    rla                 ;064d 17
    sbc a,a             ;064e 9f
    ld b,a              ;064f 47
    ld c,l              ;0650 4d
    call l01f5h+1       ;0651 cd f6 01
    jp l0857h           ;0654 c3 57 08
l0657h:
    ld a,(l3016h)       ;0657 3a 16 30
    ld l,a              ;065a 6f
    rla                 ;065b 17
    sbc a,a             ;065c 9f
    ld bc,5670h         ;065d 01 70 56
    ld h,a              ;0660 67
    add hl,bc           ;0661 09
    ld a,(hl)           ;0662 7e
    cp 01h              ;0663 fe 01
    jp nz,l0685h        ;0665 c2 85 06
    ld bc,0f1ah         ;0668 01 1a 0f
    call sub_0184h      ;066b cd 84 01
    ld a,(l3016h)       ;066e 3a 16 30
    ld l,a              ;0671 6f
    rla                 ;0672 17
    sbc a,a             ;0673 9f
    ld bc,5678h         ;0674 01 78 56
    ld h,a              ;0677 67
    add hl,bc           ;0678 09
    ld a,(hl)           ;0679 7e
    ld l,a              ;067a 6f
    rla                 ;067b 17
    sbc a,a             ;067c 9f
    ld b,a              ;067d 47
    ld c,l              ;067e 4d
    call l01f5h+1       ;067f cd f6 01
    jp l0857h           ;0682 c3 57 08
l0685h:
    ld a,(l3016h)       ;0685 3a 16 30
    ld l,a              ;0688 6f
    rla                 ;0689 17
    sbc a,a             ;068a 9f
    ld bc,5670h         ;068b 01 70 56
    ld h,a              ;068e 67
    add hl,bc           ;068f 09
    ld a,(hl)           ;0690 7e
    cp 06h              ;0691 fe 06
    jp nz,l06b3h        ;0693 c2 b3 06
    ld bc,0f2fh         ;0696 01 2f 0f
    call sub_0184h      ;0699 cd 84 01
    ld a,(l3016h)       ;069c 3a 16 30
    ld l,a              ;069f 6f
    rla                 ;06a0 17
    sbc a,a             ;06a1 9f
    ld bc,5678h         ;06a2 01 78 56
    ld h,a              ;06a5 67
    add hl,bc           ;06a6 09
    ld a,(hl)           ;06a7 7e
    ld l,a              ;06a8 6f
    rla                 ;06a9 17
    sbc a,a             ;06aa 9f
    ld b,a              ;06ab 47
    ld c,l              ;06ac 4d
    call l01f5h+1       ;06ad cd f6 01
    jp l0857h           ;06b0 c3 57 08
l06b3h:
    ld a,(l3016h)       ;06b3 3a 16 30
    ld l,a              ;06b6 6f
    rla                 ;06b7 17
    sbc a,a             ;06b8 9f
    ld bc,5670h         ;06b9 01 70 56
    ld h,a              ;06bc 67
    add hl,bc           ;06bd 09
    ld a,(hl)           ;06be 7e
    or a                ;06bf b7
    jp p,l06cch         ;06c0 f2 cc 06
    ld bc,0f44h         ;06c3 01 44 0f
    call sub_0184h      ;06c6 cd 84 01
    jp l0857h           ;06c9 c3 57 08
l06cch:
    ld a,01h            ;06cc 3e 01
    cp 01h              ;06ce fe 01
    jp z,l075ah         ;06d0 ca 5a 07
    ld bc,l0f4fh        ;06d3 01 4f 0f
    call sub_0184h      ;06d6 cd 84 01
    ld a,(l3016h)       ;06d9 3a 16 30
    ld l,a              ;06dc 6f
    rla                 ;06dd 17
    sbc a,a             ;06de 9f
    ld bc,5670h         ;06df 01 70 56
    ld h,a              ;06e2 67
    add hl,bc           ;06e3 09
    ld a,(hl)           ;06e4 7e
    cp 02h              ;06e5 fe 02
    jp nz,l06f0h        ;06e7 c2 f0 06
    ld hl,0f5bh         ;06ea 21 5b 0f
    jp l0738h           ;06ed c3 38 07
l06f0h:
    ld a,(l3016h)       ;06f0 3a 16 30
    ld l,a              ;06f3 6f
    rla                 ;06f4 17
    sbc a,a             ;06f5 9f
    ld bc,5670h         ;06f6 01 70 56
    ld h,a              ;06f9 67
    add hl,bc           ;06fa 09
    ld a,(hl)           ;06fb 7e
    cp 03h              ;06fc fe 03
    jp nz,l0707h        ;06fe c2 07 07
    ld hl,0f61h         ;0701 21 61 0f
    jp l0738h           ;0704 c3 38 07
l0707h:
    ld a,(l3016h)       ;0707 3a 16 30
    ld l,a              ;070a 6f
    rla                 ;070b 17
    sbc a,a             ;070c 9f
    ld bc,5670h         ;070d 01 70 56
    ld h,a              ;0710 67
    add hl,bc           ;0711 09
    ld a,(hl)           ;0712 7e
    cp 04h              ;0713 fe 04
    jp nz,l071eh        ;0715 c2 1e 07
    ld hl,0f67h         ;0718 21 67 0f
    jp l0738h           ;071b c3 38 07
l071eh:
    ld a,(l3016h)       ;071e 3a 16 30
    ld l,a              ;0721 6f
    rla                 ;0722 17
    sbc a,a             ;0723 9f
    ld bc,5670h         ;0724 01 70 56
    ld h,a              ;0727 67
    add hl,bc           ;0728 09
    ld a,(hl)           ;0729 7e
    cp 05h              ;072a fe 05
    jp nz,l0735h        ;072c c2 35 07
    ld hl,l0f6dh        ;072f 21 6d 0f
    jp l0738h           ;0732 c3 38 07
l0735h:
    ld hl,0f73h         ;0735 21 73 0f
l0738h:
    ld b,h              ;0738 44
    ld c,l              ;0739 4d
    call sub_0184h      ;073a cd 84 01
    ld bc,l0f7ah        ;073d 01 7a 0f
    call sub_0184h      ;0740 cd 84 01
    ld a,(l3016h)       ;0743 3a 16 30
    ld l,a              ;0746 6f
    rla                 ;0747 17
    sbc a,a             ;0748 9f
    ld bc,5678h         ;0749 01 78 56
    ld h,a              ;074c 67
    add hl,bc           ;074d 09
    ld a,(hl)           ;074e 7e
    ld l,a              ;074f 6f
    rla                 ;0750 17
    sbc a,a             ;0751 9f
    ld b,a              ;0752 47
    ld c,l              ;0753 4d
    call l01f5h+1       ;0754 cd f6 01
    jp l0857h           ;0757 c3 57 08
l075ah:
    ld a,(l3016h)       ;075a 3a 16 30
    ld l,a              ;075d 6f
    rla                 ;075e 17
    sbc a,a             ;075f 9f
    ld bc,5678h         ;0760 01 78 56
    ld h,a              ;0763 67
    add hl,bc           ;0764 09
    ld a,(hl)           ;0765 7e
    and 01h             ;0766 e6 01
    ld (l3018h),a       ;0768 32 18 30
    ld a,(l3016h)       ;076b 3a 16 30
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
    ld hl,l3019h        ;0785 21 19 30
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
    ld (l3017h),a       ;0798 32 17 30
    ld bc,0f84h         ;079b 01 84 0f
    call sub_0184h      ;079e cd 84 01
    ld a,(l3018h)       ;07a1 3a 18 30
    ld l,a              ;07a4 6f
    rla                 ;07a5 17
    sbc a,a             ;07a6 9f
    ld b,a              ;07a7 47
    ld c,l              ;07a8 4d
    call l01f5h+1       ;07a9 cd f6 01
    call sub_0179h      ;07ac cd 79 01
    ld bc,0f97h         ;07af 01 97 0f
    call sub_0184h      ;07b2 cd 84 01
    ld a,(l3018h)       ;07b5 3a 18 30
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
    call l01f5h+1       ;07c4 cd f6 01
    ld bc,l0fa4h        ;07c7 01 a4 0f
    call sub_0184h      ;07ca cd 84 01
    ld a,(l3017h)       ;07cd 3a 17 30
    ld l,a              ;07d0 6f
    rla                 ;07d1 17
    sbc a,a             ;07d2 9f
    ld h,a              ;07d3 67
    ld a,(l3018h)       ;07d4 3a 18 30
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
    call sub_24cdh      ;07e9 cd cd 24
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
    call l01f5h+1       ;07fe cd f6 01
    ld bc,l0fach        ;0801 01 ac 0f
    call sub_0184h      ;0804 cd 84 01
    call sub_0179h      ;0807 cd 79 01
    ld bc,l0fbah        ;080a 01 ba 0f
    call sub_0184h      ;080d cd 84 01
    ld a,(l3019h)       ;0810 3a 19 30
    ld l,a              ;0813 6f
    rla                 ;0814 17
    sbc a,a             ;0815 9f
    ld b,a              ;0816 47
    ld c,l              ;0817 4d
    call l01f5h+1       ;0818 cd f6 01
    ld bc,0fcbh         ;081b 01 cb 0f
    call sub_0184h      ;081e cd 84 01
    ld a,(l3019h)       ;0821 3a 19 30
    ld l,a              ;0824 6f
    rla                 ;0825 17
    sbc a,a             ;0826 9f
    ld h,a              ;0827 67
    ld a,(l3017h)       ;0828 3a 17 30
    ld c,a              ;082b 4f
    rla                 ;082c 17
    sbc a,a             ;082d 9f
    ld b,a              ;082e 47
    dec bc              ;082f 0b
    add hl,bc           ;0830 09
    ld b,h              ;0831 44
    ld c,l              ;0832 4d
    call l01f5h+1       ;0833 cd f6 01
    ld bc,l0fcdh        ;0836 01 cd 0f
    call sub_0184h      ;0839 cd 84 01
    ld a,(l3018h)       ;083c 3a 18 30
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
    call l01f5h+1       ;084b cd f6 01
    ld bc,l0fd7h        ;084e 01 d7 0f
    call sub_0184h      ;0851 cd 84 01
    call sub_0179h      ;0854 cd 79 01
l0857h:
    call sub_0179h      ;0857 cd 79 01
    ld hl,l3016h        ;085a 21 16 30
    inc (hl)            ;085d 34
l085eh:
    ld a,(l3016h)       ;085e 3a 16 30
    cp 08h              ;0861 fe 08
    jp m,l060ah         ;0863 fa 0a 06
    call sub_0179h      ;0866 cd 79 01
    ld bc,l0fdeh        ;0869 01 de 0f
    call sub_0184h      ;086c cd 84 01
    call sub_0216h      ;086f cd 16 02
    call sub_0179h      ;0872 cd 79 01
    ld a,(l24cch)       ;0875 3a cc 24
    cp 0dh              ;0878 fe 0d
    jp nz,l087eh        ;087a c2 7e 08
    ret                 ;087d c9
l087eh:
    ld a,(l24cch)       ;087e 3a cc 24
    cp 41h              ;0881 fe 41
    jp m,l0993h         ;0883 fa 93 09
    cp 51h              ;0886 fe 51
    jp p,l0993h         ;0888 f2 93 09
    add a,0bfh          ;088b c6 bf
    or a                ;088d b7
    rra                 ;088e 1f
    ld (l3016h),a       ;088f 32 16 30
    ld bc,1001h         ;0892 01 01 10
    call sub_0184h      ;0895 cd 84 01
    call sub_0216h      ;0898 cd 16 02
    call sub_0179h      ;089b cd 79 01
    ld a,(l24cch)       ;089e 3a cc 24
    cp 46h              ;08a1 fe 46
    jp nz,l0909h        ;08a3 c2 09 09
l08a6h:
    ld bc,1024h         ;08a6 01 24 10
    call sub_0184h      ;08a9 cd 84 01
    call sub_0216h      ;08ac cd 16 02
    call sub_0179h      ;08af cd 79 01
    ld a,(l24cch)       ;08b2 3a cc 24
    cp 41h              ;08b5 fe 41
    jp nz,l08cdh        ;08b7 c2 cd 08
    ld a,(l3016h)       ;08ba 3a 16 30
    ld l,a              ;08bd 6f
    rla                 ;08be 17
    sbc a,a             ;08bf 9f
    ld bc,5670h         ;08c0 01 70 56
    ld h,a              ;08c3 67
    add hl,bc           ;08c4 09
    ld (hl),00h         ;08c5 36 00
    call sub_0309h      ;08c7 cd 09 03
    jp l0906h           ;08ca c3 06 09
l08cdh:
    ld a,(l24cch)       ;08cd 3a cc 24
    cp 42h              ;08d0 fe 42
    jp nz,l08e8h        ;08d2 c2 e8 08
    ld a,(l3016h)       ;08d5 3a 16 30
    ld l,a              ;08d8 6f
    rla                 ;08d9 17
    sbc a,a             ;08da 9f
    ld bc,5670h         ;08db 01 70 56
    ld h,a              ;08de 67
    add hl,bc           ;08df 09
    ld (hl),01h         ;08e0 36 01
    call sub_0309h      ;08e2 cd 09 03
    jp l0906h           ;08e5 c3 06 09
l08e8h:
    ld a,(l24cch)       ;08e8 3a cc 24
    cp 43h              ;08eb fe 43
    jp nz,l0903h        ;08ed c2 03 09
    ld a,(l3016h)       ;08f0 3a 16 30
    ld l,a              ;08f3 6f
    rla                 ;08f4 17
    sbc a,a             ;08f5 9f
    ld bc,5670h         ;08f6 01 70 56
    ld h,a              ;08f9 67
    add hl,bc           ;08fa 09
    ld (hl),06h         ;08fb 36 06
    call sub_0309h      ;08fd cd 09 03
    jp l0906h           ;0900 c3 06 09
l0903h:
    jp l08a6h           ;0903 c3 a6 08
l0906h:
    jp l091eh           ;0906 c3 1e 09
l0909h:
    ld a,(l24cch)       ;0909 3a cc 24
    cp 55h              ;090c fe 55
    jp nz,l091eh        ;090e c2 1e 09
    ld a,(l3016h)       ;0911 3a 16 30
    ld l,a              ;0914 6f
    rla                 ;0915 17
    sbc a,a             ;0916 9f
    ld bc,5670h         ;0917 01 70 56
    ld h,a              ;091a 67
    add hl,bc           ;091b 09
    ld (hl),0ffh        ;091c 36 ff
l091eh:
    ld a,(l24cch)       ;091e 3a cc 24
    cp 48h              ;0921 fe 48
    jp nz,l0993h        ;0923 c2 93 09
    ld a,01h            ;0926 3e 01
    cp 01h              ;0928 fe 01
    jp z,l0990h         ;092a ca 90 09
    ld bc,104ah         ;092d 01 4a 10
    call sub_0184h      ;0930 cd 84 01
    call sub_0216h      ;0933 cd 16 02
    call sub_0179h      ;0936 cd 79 01
    ld bc,0fffbh        ;0939 01 fb ff
    ld hl,(l24c8h)      ;093c 2a c8 24
    add hl,bc           ;093f 09
    ld a,h              ;0940 7c
    or l                ;0941 b5
    jp nz,l0955h        ;0942 c2 55 09
    ld a,(l3016h)       ;0945 3a 16 30
    ld l,a              ;0948 6f
    rla                 ;0949 17
    sbc a,a             ;094a 9f
    ld bc,5670h         ;094b 01 70 56
    ld h,a              ;094e 67
    add hl,bc           ;094f 09
    ld (hl),04h         ;0950 36 04
    jp l098ah           ;0952 c3 8a 09
l0955h:
    ld bc,0fff6h        ;0955 01 f6 ff
    ld hl,(l24c8h)      ;0958 2a c8 24
    add hl,bc           ;095b 09
    ld a,h              ;095c 7c
    or l                ;095d b5
    jp nz,l0971h        ;095e c2 71 09
    ld a,(l3016h)       ;0961 3a 16 30
    ld l,a              ;0964 6f
    rla                 ;0965 17
    sbc a,a             ;0966 9f
    ld bc,5670h         ;0967 01 70 56
    ld h,a              ;096a 67
    add hl,bc           ;096b 09
    ld (hl),02h         ;096c 36 02
    jp l098ah           ;096e c3 8a 09
l0971h:
    ld bc,0ffech        ;0971 01 ec ff
    ld hl,(l24c8h)      ;0974 2a c8 24
    add hl,bc           ;0977 09
    ld a,h              ;0978 7c
    or l                ;0979 b5
    jp nz,l098ah        ;097a c2 8a 09
    ld a,(l3016h)       ;097d 3a 16 30
    ld l,a              ;0980 6f
    rla                 ;0981 17
    sbc a,a             ;0982 9f
    ld bc,5670h         ;0983 01 70 56
    ld h,a              ;0986 67
    add hl,bc           ;0987 09
    ld (hl),03h         ;0988 36 03
l098ah:
    call sub_0309h      ;098a cd 09 03
    jp l0993h           ;098d c3 93 09
l0990h:
    call l0359h         ;0990 cd 59 03
l0993h:
    jp l05edh           ;0993 c3 ed 05
    ret                 ;0996 c9
sub_0997h:
    call sub_0300h      ;0997 cd 00 03
    ld a,(4007h)        ;099a 3a 07 40
    or a                ;099d b7
    jp nz,l09adh        ;099e c2 ad 09
    ld bc,1066h         ;09a1 01 66 10
    call sub_01a9h      ;09a4 cd a9 01
    call sub_0179h      ;09a7 cd 79 01
    jp l09ddh           ;09aa c3 dd 09
l09adh:
    ld bc,l1082h        ;09ad 01 82 10
    call sub_01a9h      ;09b0 cd a9 01
    ld hl,l301eh        ;09b3 21 1e 30
    ld (hl),01h         ;09b6 36 01
    ld a,(4007h)        ;09b8 3a 07 40
    inc hl              ;09bb 23
    ld (hl),a           ;09bc 77
    jp l09d3h           ;09bd c3 d3 09
l09c0h:
    ld a,(l301eh)       ;09c0 3a 1e 30
    ld l,a              ;09c3 6f
    rla                 ;09c4 17
    sbc a,a             ;09c5 9f
    ld bc,4007h         ;09c6 01 07 40
    ld h,a              ;09c9 67
    add hl,bc           ;09ca 09
    ld c,(hl)           ;09cb 4e
    call sub_016bh      ;09cc cd 6b 01
    ld hl,l301eh        ;09cf 21 1e 30
    inc (hl)            ;09d2 34
l09d3h:
    ld a,(l301fh)       ;09d3 3a 1f 30
    ld hl,l301eh        ;09d6 21 1e 30
    cp (hl)             ;09d9 be
    jp p,l09c0h         ;09da f2 c0 09
l09ddh:
    call sub_0179h      ;09dd cd 79 01
    ld bc,10a1h         ;09e0 01 a1 10
    call sub_0184h      ;09e3 cd 84 01
    call sub_0216h      ;09e6 cd 16 02
    call sub_0179h      ;09e9 cd 79 01
    ld a,(l24cch)       ;09ec 3a cc 24
    cp 59h              ;09ef fe 59
    jp nz,l0a48h        ;09f1 c2 48 0a
    ld bc,10c0h         ;09f4 01 c0 10
    call sub_01a9h      ;09f7 cd a9 01
    call sub_0216h      ;09fa cd 16 02
    call sub_0179h      ;09fd cd 79 01
    ld a,(l2425h)       ;0a00 3a 25 24
    ld (4007h),a        ;0a03 32 07 40
    ld hl,l301eh        ;0a06 21 1e 30
    ld (hl),01h         ;0a09 36 01
    ld a,(l2425h)       ;0a0b 3a 25 24
    inc hl              ;0a0e 23
    ld (hl),a           ;0a0f 77
    jp l0a30h           ;0a10 c3 30 0a
l0a13h:
    ld a,(l301eh)       ;0a13 3a 1e 30
    ld l,a              ;0a16 6f
    rla                 ;0a17 17
    sbc a,a             ;0a18 9f
    ld bc,l2425h        ;0a19 01 25 24
    ld h,a              ;0a1c 67
    add hl,bc           ;0a1d 09
    ld a,(l301eh)       ;0a1e 3a 1e 30
    ld c,a              ;0a21 4f
    rla                 ;0a22 17
    sbc a,a             ;0a23 9f
    ld de,4007h         ;0a24 11 07 40
    ld b,(hl)           ;0a27 46
    ld h,a              ;0a28 67
    ld l,c              ;0a29 69
    add hl,de           ;0a2a 19
    ld (hl),b           ;0a2b 70
    ld hl,l301eh        ;0a2c 21 1e 30
    inc (hl)            ;0a2f 34
l0a30h:
    ld a,(l301fh)       ;0a30 3a 1f 30
    ld hl,l301eh        ;0a33 21 1e 30
    cp (hl)             ;0a36 be
    jp p,l0a13h         ;0a37 f2 13 0a
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
    ld bc,10e0h         ;0a4d 01 e0 10
    call sub_0184h      ;0a50 cd 84 01
    call sub_0216h      ;0a53 cd 16 02
    call sub_0179h      ;0a56 cd 79 01
    ld a,(l24cch)       ;0a59 3a cc 24
    cp 41h              ;0a5c fe 41
    jp p,l0a66h         ;0a5e f2 66 0a
    cp 51h              ;0a61 fe 51
    jp p,l0af0h         ;0a63 f2 f0 0a
l0a66h:
    ld a,(l24cch)       ;0a66 3a cc 24
    ld l,a              ;0a69 6f
    rla                 ;0a6a 17
    sbc a,a             ;0a6b 9f
    ld bc,0ffbfh        ;0a6c 01 bf ff
    ld h,a              ;0a6f 67
    add hl,bc           ;0a70 09
    ld (l3002h),hl      ;0a71 22 02 30
    ld hl,(l3002h)      ;0a74 2a 02 30
    add hl,hl           ;0a77 29
    jp c,l0a86h         ;0a78 da 86 0a
    ld bc,0fff0h        ;0a7b 01 f0 ff
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
    ld bc,0ff80h        ;0a95 01 80 ff
    ld hl,(l3020h)      ;0a98 2a 20 30
    add hl,bc           ;0a9b 09
    add hl,hl           ;0a9c 29
    jp c,l0aa9h         ;0a9d da a9 0a
    ld bc,10ffh         ;0aa0 01 ff 10
    call sub_01a9h      ;0aa3 cd a9 01
    jp l0a4dh           ;0aa6 c3 4d 0a
l0aa9h:
    ld hl,(l3020h)      ;0aa9 2a 20 30
    dec hl              ;0aac 2b
    dec hl              ;0aad 2b
    add hl,hl           ;0aae 29
    jp c,l0ac7h         ;0aaf da c7 0a
    ld bc,0fffah        ;0ab2 01 fa ff
    ld hl,(l3020h)      ;0ab5 2a 20 30
    add hl,bc           ;0ab8 09
    add hl,hl           ;0ab9 29
    jp nc,l0ac7h        ;0aba d2 c7 0a
    ld hl,l3002h        ;0abd 21 02 30
    ld c,(hl)           ;0ac0 4e
    call sub_21e3h      ;0ac1 cd e3 21
    jp l0af0h           ;0ac4 c3 f0 0a
l0ac7h:
    ld hl,l3002h        ;0ac7 21 02 30
    ld c,(hl)           ;0aca 4e
    call sub_0113h      ;0acb cd 13 01
    ld hl,l3002h        ;0ace 21 02 30
    ld c,(hl)           ;0ad1 4e
    call sub_2240h      ;0ad2 cd 40 22
    call sub_011eh      ;0ad5 cd 1e 01
    or a                ;0ad8 b7
    jp z,l0af0h         ;0ad9 ca f0 0a
    ld bc,l1113h        ;0adc 01 13 11
    call sub_0184h      ;0adf cd 84 01
    call sub_0216h      ;0ae2 cd 16 02
    call sub_0179h      ;0ae5 cd 79 01
    ld a,(l24cch)       ;0ae8 3a cc 24
    cp 59h              ;0aeb fe 59
    jp z,l0ac7h         ;0aed ca c7 0a
l0af0h:
    ret                 ;0af0 c9
l0af1h:
    call sub_0300h      ;0af1 cd 00 03
    call sub_0179h      ;0af4 cd 79 01
    ld bc,1122h         ;0af7 01 22 11
    call sub_01a9h      ;0afa cd a9 01
    ld bc,l1137h        ;0afd 01 37 11
    call sub_01a9h      ;0b00 cd a9 01
    call sub_0179h      ;0b03 cd 79 01
    ld a,01h            ;0b06 3e 01
    cp 01h              ;0b08 fe 01
    jp nz,l0b13h        ;0b0a c2 13 0b
    ld bc,l114ch        ;0b0d 01 4c 11
    call sub_01a9h      ;0b10 cd a9 01
l0b13h:
    ld bc,l1164h        ;0b13 01 64 11
    call sub_01a9h      ;0b16 cd a9 01
    call sub_0179h      ;0b19 cd 79 01
    call sub_0179h      ;0b1c cd 79 01
    ld bc,l1185h        ;0b1f 01 85 11
    call sub_0184h      ;0b22 cd 84 01
    call sub_0216h      ;0b25 cd 16 02
    call sub_0179h      ;0b28 cd 79 01
    ld a,(l24cch)       ;0b2b 3a cc 24
    cp 0dh              ;0b2e fe 0d
    jp z,l0af1h         ;0b30 ca f1 0a
    cp 5fh              ;0b33 fe 5f
    jp z,l0babh         ;0b35 ca ab 0b
    cp 41h              ;0b38 fe 41
    jp p,l0b42h         ;0b3a f2 42 0b
    cp 51h              ;0b3d fe 51
    jp p,l0ba8h         ;0b3f f2 a8 0b
l0b42h:
    ld a,(l24cch)       ;0b42 3a cc 24
    ld l,a              ;0b45 6f
    rla                 ;0b46 17
    sbc a,a             ;0b47 9f
    ld bc,0ffbfh        ;0b48 01 bf ff
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
    ld bc,0ff7fh        ;0b5e 01 7f ff
    ld hl,(l3004h)      ;0b61 2a 04 30
    add hl,bc           ;0b64 09
    add hl,hl           ;0b65 29
    jp nc,l0ba2h        ;0b66 d2 a2 0b
    ld hl,(l3004h)      ;0b69 2a 04 30
    dec hl              ;0b6c 2b
    dec hl              ;0b6d 2b
    add hl,hl           ;0b6e 29
    jp c,l0b87h         ;0b6f da 87 0b
    ld bc,0fffah        ;0b72 01 fa ff
    ld hl,(l3004h)      ;0b75 2a 04 30
    add hl,bc           ;0b78 09
    add hl,hl           ;0b79 29
    jp nc,l0b87h        ;0b7a d2 87 0b
    ld hl,l3002h        ;0b7d 21 02 30
    ld c,(hl)           ;0b80 4e
    call sub_21b0h      ;0b81 cd b0 21
    jp l0b9fh           ;0b84 c3 9f 0b
l0b87h:
    ld hl,l3002h        ;0b87 21 02 30
    ld c,(hl)           ;0b8a 4e
    call sub_0113h      ;0b8b cd 13 01
    ld hl,l3002h        ;0b8e 21 02 30
    ld c,(hl)           ;0b91 4e
    call sub_2145h      ;0b92 cd 45 21
    call sub_011eh      ;0b95 cd 1e 01
    or a                ;0b98 b7
    jp z,l0b9fh         ;0b99 ca 9f 0b
    call sub_0167h      ;0b9c cd 67 01
l0b9fh:
    jp l0ba5h           ;0b9f c3 a5 0b
l0ba2h:
    jp l0af1h           ;0ba2 c3 f1 0a
l0ba5h:
    jp l0babh           ;0ba5 c3 ab 0b
l0ba8h:
    jp l0af1h           ;0ba8 c3 f1 0a
l0babh:
    call sub_0300h      ;0bab cd 00 03
    call sub_0179h      ;0bae cd 79 01
    ld bc,119dh         ;0bb1 01 9d 11
    call sub_01a9h      ;0bb4 cd a9 01
    ld bc,l11b2h        ;0bb7 01 b2 11
    call sub_01a9h      ;0bba cd a9 01
    call sub_0179h      ;0bbd cd 79 01
    ld bc,l11c7h        ;0bc0 01 c7 11
    call sub_01a9h      ;0bc3 cd a9 01
    call sub_0179h      ;0bc6 cd 79 01
    ld bc,l11dch        ;0bc9 01 dc 11
    call sub_01a9h      ;0bcc cd a9 01
    call sub_0179h      ;0bcf cd 79 01
    ld bc,l11f6h        ;0bd2 01 f6 11
    call sub_01a9h      ;0bd5 cd a9 01
    call sub_0179h      ;0bd8 cd 79 01
    ld bc,l1209h        ;0bdb 01 09 12
    call sub_01a9h      ;0bde cd a9 01
    call sub_0179h      ;0be1 cd 79 01
    ld bc,l1225h        ;0be4 01 25 12
    call sub_01a9h      ;0be7 cd a9 01
    call sub_0179h      ;0bea cd 79 01
    ld bc,l123fh        ;0bed 01 3f 12
    call sub_01a9h      ;0bf0 cd a9 01
    call sub_0179h      ;0bf3 cd 79 01
    ld bc,l1253h        ;0bf6 01 53 12
    call sub_01a9h      ;0bf9 cd a9 01
    call sub_0179h      ;0bfc cd 79 01
    ld bc,l126ah        ;0bff 01 6a 12
    call sub_01a9h      ;0c02 cd a9 01
    call sub_0179h      ;0c05 cd 79 01
    ld bc,l1280h        ;0c08 01 80 12
    call sub_0184h      ;0c0b cd 84 01
    call sub_0216h      ;0c0e cd 16 02
    call sub_0179h      ;0c11 cd 79 01
    ld a,(l24cch)       ;0c14 3a cc 24
    cp 41h              ;0c17 fe 41
    jp nz,l0c22h        ;0c19 c2 22 0c
    call sub_0997h      ;0c1c cd 97 09
    jp l0c81h           ;0c1f c3 81 0c
l0c22h:
    ld a,(l24cch)       ;0c22 3a cc 24
    cp 44h              ;0c25 fe 44
    jp nz,l0c30h        ;0c27 c2 30 0c
    call sub_0306h      ;0c2a cd 06 03
    jp l0c81h           ;0c2d c3 81 0c
l0c30h:
    ld a,(l24cch)       ;0c30 3a cc 24
    cp 49h              ;0c33 fe 49
    jp nz,l0c3eh        ;0c35 c2 3e 0c
    call sub_1564h      ;0c38 cd 64 15
    jp l0c81h           ;0c3b c3 81 0c
l0c3eh:
    ld a,(l24cch)       ;0c3e 3a cc 24
    cp 50h              ;0c41 fe 50
    jp nz,l0c4ch        ;0c43 c2 4c 0c
    call sub_1876h      ;0c46 cd 76 18
    jp l0c81h           ;0c49 c3 81 0c
l0c4ch:
    ld a,(l24cch)       ;0c4c 3a cc 24
    cp 52h              ;0c4f fe 52
    jp nz,l0c5ah        ;0c51 c2 5a 0c
    call 12a6h          ;0c54 cd a6 12
    jp l0c81h           ;0c57 c3 81 0c
l0c5ah:
    ld a,(l24cch)       ;0c5a 3a cc 24
    cp 53h              ;0c5d fe 53
    jp nz,l0c68h        ;0c5f c2 68 0c
    call l0a4dh         ;0c62 cd 4d 0a
    jp l0c81h           ;0c65 c3 81 0c
l0c68h:
    ld a,(l24cch)       ;0c68 3a cc 24
    cp 45h              ;0c6b fe 45
    jp nz,l0c76h        ;0c6d c2 76 0c
    call sub_0a49h      ;0c70 cd 49 0a
    jp l0c81h           ;0c73 c3 81 0c
l0c76h:
    ld a,(l24cch)       ;0c76 3a cc 24
    cp 51h              ;0c79 fe 51
    jp nz,l0c81h        ;0c7b c2 81 0c
    call sub_0167h      ;0c7e cd 67 01
l0c81h:
    jp l0babh           ;0c81 c3 ab 0b

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

l0f05h:
    db 14h
    db "3040/4040  Device # "

l0f1ah:
    db 14h
    db "8050       Device # "

l0f2fh:
    db 14h
    db "8250       Device # "

l0f44h:
    db 0ah
    db "Not used  "

l0f4fh:
    db 0bh
    db "Corvus     "

l0f5bh:
    db 05h
    db "10Mb "

l0f61h:
    db 05h
    db "20Mb "

l0f67h:
    db 05h
    db "5Mb  "

l0f6dh:
    db 05h
    db "5Mb* "

l0f73h:
    db 06h
    db "      "

l0f7ah:
    db 09h
    db "Device # "

l0f84h:
    db 12h
    db "Winchester Unit # "

l0f97h:
    db 0ch
    db "           ("

l0fa4h:
    db 07h
    db " cyl,  "

l0fach:
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

    db 0c3h
    xor 13h             ;12a7 ee 13
sub_12a9h:
    ld bc,l1b70h        ;12a9 01 70 1b
    call sub_0184h      ;12ac cd 84 01
l12afh:
    call sub_0216h      ;12af cd 16 02
    call sub_0179h      ;12b2 cd 79 01
    ld a,(l24cch)       ;12b5 3a cc 24
l12b8h:
    ld l,a              ;12b8 6f
    rla                 ;12b9 17
    sbc a,a             ;12ba 9f
    ld bc,0ffcbh        ;12bb 01 cb ff
    ld h,a              ;12be 67
    add hl,bc           ;12bf 09
    ld (l24c8h),hl      ;12c0 22 c8 24
    ld hl,(l24c8h)      ;12c3 2a c8 24
    add hl,hl           ;12c6 29
    jp c,l12ech         ;12c7 da ec 12
l12cah:
    ld bc,0fffch        ;12ca 01 fc ff
    ld hl,(l24c8h)      ;12cd 2a c8 24
    add hl,bc           ;12d0 09
    add hl,hl           ;12d1 29
    jp nc,l12ech        ;12d2 d2 ec 12
    ld a,(5664h)        ;12d5 3a 64 56
    and 0f3h            ;12d8 e6 f3
    ld b,02h            ;12da 06 02
    ld c,a              ;12dc 4f
    ld a,(l24c8h)       ;12dd 3a c8 24
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
sub_12edh:
    ld bc,1b90h         ;12ed 01 90 1b
    call sub_0184h      ;12f0 cd 84 01
    call sub_0216h      ;12f3 cd 16 02
    call sub_0179h      ;12f6 cd 79 01
    ld hl,(l24c8h)      ;12f9 2a c8 24
    dec hl              ;12fc 2b
    ld a,h              ;12fd 7c
    or l                ;12fe b5
    jp nz,l130fh        ;12ff c2 0f 13
    ld a,(5664h)        ;1302 3a 64 56
    and 3fh             ;1305 e6 3f
    or 40h              ;1307 f6 40
    ld (5664h),a        ;1309 32 64 56
    jp l1323h           ;130c c3 23 13
l130fh:
    ld hl,(l24c8h)      ;130f 2a c8 24
    dec hl              ;1312 2b
    dec hl              ;1313 2b
    ld a,h              ;1314 7c
    or l                ;1315 b5
    jp nz,l1323h        ;1316 c2 23 13
    ld a,(5664h)        ;1319 3a 64 56
    and 3fh             ;131c e6 3f
    or 0c0h             ;131e f6 c0
    ld (5664h),a        ;1320 32 64 56
l1323h:
    ret                 ;1323 c9
sub_1324h:
    ld bc,1bb0h         ;1324 01 b0 1b
    call sub_0184h      ;1327 cd 84 01
    call sub_0216h      ;132a cd 16 02
    call sub_0179h      ;132d cd 79 01
    ld a,(l24cch)       ;1330 3a cc 24
    cp 4fh              ;1333 fe 4f
    jp nz,l1345h        ;1335 c2 45 13
    ld a,(5664h)        ;1338 3a 64 56
    and 0cfh            ;133b e6 cf
    or 10h              ;133d f6 10
    ld (5664h),a        ;133f 32 64 56
    jp l1368h           ;1342 c3 68 13
l1345h:
    ld a,(l24cch)       ;1345 3a cc 24
    cp 45h              ;1348 fe 45
    jp nz,l1358h        ;134a c2 58 13
    ld a,(5664h)        ;134d 3a 64 56
    or 30h              ;1350 f6 30
    ld (5664h),a        ;1352 32 64 56
    jp l1368h           ;1355 c3 68 13
l1358h:
    ld a,(l24cch)       ;1358 3a cc 24
    cp 4eh              ;135b fe 4e
    jp nz,l1368h        ;135d c2 68 13
    ld a,(5664h)        ;1360 3a 64 56
    and 0efh            ;1363 e6 ef
    ld (5664h),a        ;1365 32 64 56
l1368h:
    ret                 ;1368 c9
sub_1369h:
    call sub_0179h      ;1369 cd 79 01
    ld bc,1bd1h         ;136c 01 d1 1b
    call sub_0184h      ;136f cd 84 01
    call sub_0216h      ;1372 cd 16 02
    call sub_0179h      ;1375 cd 79 01
    ld bc,0ff92h        ;1378 01 92 ff
    ld hl,(l24c8h)      ;137b 2a c8 24
    add hl,bc           ;137e 09
    ld a,h              ;137f 7c
    or l                ;1380 b5
    jp nz,l138ch        ;1381 c2 8c 13
    ld hl,5665h         ;1384 21 65 56
    ld (hl),22h         ;1387 36 22
    jp l13edh           ;1389 c3 ed 13
l138ch:
    ld bc,0fed4h        ;138c 01 d4 fe
    ld hl,(l24c8h)      ;138f 2a c8 24
    add hl,bc           ;1392 09
    ld a,h              ;1393 7c
    or l                ;1394 b5
    jp nz,l13a0h        ;1395 c2 a0 13
    ld hl,5665h         ;1398 21 65 56
    ld (hl),55h         ;139b 36 55
    jp l13edh           ;139d c3 ed 13
l13a0h:
    ld bc,0fb50h        ;13a0 01 50 fb
    ld hl,(l24c8h)      ;13a3 2a c8 24
    add hl,bc           ;13a6 09
    ld a,h              ;13a7 7c
    or l                ;13a8 b5
    jp nz,l13b4h        ;13a9 c2 b4 13
    ld hl,5665h         ;13ac 21 65 56
    ld (hl),77h         ;13af 36 77
    jp l13edh           ;13b1 c3 ed 13
l13b4h:
    ld bc,0ed40h        ;13b4 01 40 ed
    ld hl,(l24c8h)      ;13b7 2a c8 24
    add hl,bc           ;13ba 09
    ld a,h              ;13bb 7c
    or l                ;13bc b5
    jp nz,l13c8h        ;13bd c2 c8 13
    ld hl,5665h         ;13c0 21 65 56
    ld (hl),0cch        ;13c3 36 cc
    jp l13edh           ;13c5 c3 ed 13
l13c8h:
    ld bc,0da80h        ;13c8 01 80 da
    ld hl,(l24c8h)      ;13cb 2a c8 24
    add hl,bc           ;13ce 09
    ld a,h              ;13cf 7c
    or l                ;13d0 b5
    jp nz,l13dch        ;13d1 c2 dc 13
    ld hl,5665h         ;13d4 21 65 56
    ld (hl),0eeh        ;13d7 36 ee
    jp l13edh           ;13d9 c3 ed 13
l13dch:
    ld bc,0b500h        ;13dc 01 00 b5
    ld hl,(l24c8h)      ;13df 2a c8 24
    add hl,bc           ;13e2 09
    ld a,h              ;13e3 7c
    or l                ;13e4 b5
    jp nz,l13edh        ;13e5 c2 ed 13
    ld hl,5665h         ;13e8 21 65 56
    ld (hl),0ffh        ;13eb 36 ff
l13edh:
    ret                 ;13ed c9
l13eeh:
    call sub_0300h      ;13ee cd 00 03
    call sub_0179h      ;13f1 cd 79 01
    ld bc,1bfeh         ;13f4 01 fe 1b
    call sub_01a9h      ;13f7 cd a9 01
    ld bc,1c15h         ;13fa 01 15 1c
    call sub_01a9h      ;13fd cd a9 01
    call sub_0179h      ;1400 cd 79 01
    ld bc,l1c2ch        ;1403 01 2c 1c
    call sub_0184h      ;1406 cd 84 01
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
    add a,35h           ;141c c6 35
    ld c,a              ;141e 4f
    call sub_016bh      ;141f cd 6b 01
    call sub_0179h      ;1422 cd 79 01
    call sub_0179h      ;1425 cd 79 01
    ld bc,l1c44h        ;1428 01 44 1c
    call sub_0184h      ;142b cd 84 01
    ld a,(5664h)        ;142e 3a 64 56
    and 0c0h            ;1431 e6 c0
    ld (l3028h),a       ;1433 32 28 30
    cp 40h              ;1436 fe 40
    jp nz,l1441h        ;1438 c2 41 14
    ld hl,l1c60h        ;143b 21 60 1c
    jp l1460h           ;143e c3 60 14
l1441h:
    ld a,(l3028h)       ;1441 3a 28 30
    cp 80h              ;1444 fe 80
    jp nz,l144fh        ;1446 c2 4f 14
    ld hl,l1c60h+2      ;1449 21 62 1c
    jp l1460h           ;144c c3 60 14
l144fh:
    ld a,(l3028h)       ;144f 3a 28 30
    cp 0c0h             ;1452 fe c0
    jp nz,l145dh        ;1454 c2 5d 14
    ld hl,l1c66h        ;1457 21 66 1c
    jp l1460h           ;145a c3 60 14
l145dh:
    ld hl,l1c66h+2      ;145d 21 68 1c
l1460h:
    ld b,h              ;1460 44
    ld c,l              ;1461 4d
    call sub_01a9h      ;1462 cd a9 01
    call sub_0179h      ;1465 cd 79 01
    ld bc,l1c72h        ;1468 01 72 1c
    call sub_0184h      ;146b cd 84 01
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
    ld hl,1c92h         ;149c 21 92 1c
l149fh:
    ld b,h              ;149f 44
    ld c,l              ;14a0 4d
    call sub_01a9h      ;14a1 cd a9 01
    call sub_0179h      ;14a4 cd 79 01
    ld bc,l1c97h        ;14a7 01 97 1c
    call sub_0184h      ;14aa cd 84 01
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
    call sub_01a9h      ;1506 cd a9 01
    call sub_0179h      ;1509 cd 79 01
    ld bc,1cd4h         ;150c 01 d4 1c
    call sub_0184h      ;150f cd 84 01
    call sub_0216h      ;1512 cd 16 02
    call sub_0179h      ;1515 cd 79 01
    ld hl,(l24c8h)      ;1518 2a c8 24
    ld a,l              ;151b 7d
    or h                ;151c b4
    jp nz,l1521h        ;151d c2 21 15
    ret                 ;1520 c9
l1521h:
    ld hl,(l24c8h)      ;1521 2a c8 24
    dec hl              ;1524 2b
    ld a,h              ;1525 7c
    or l                ;1526 b5
    jp nz,l1530h        ;1527 c2 30 15
    call sub_12a9h      ;152a cd a9 12
    jp l1560h           ;152d c3 60 15
l1530h:
    ld hl,(l24c8h)      ;1530 2a c8 24
    dec hl              ;1533 2b
    dec hl              ;1534 2b
    ld a,h              ;1535 7c
    or l                ;1536 b5
    jp nz,l1540h        ;1537 c2 40 15
    call sub_12edh      ;153a cd ed 12
    jp l1560h           ;153d c3 60 15
l1540h:
    ld hl,(l24c8h)      ;1540 2a c8 24
    dec hl              ;1543 2b
    dec hl              ;1544 2b
    dec hl              ;1545 2b
    ld a,h              ;1546 7c
    or l                ;1547 b5
    jp nz,l1551h        ;1548 c2 51 15
    call sub_1324h      ;154b cd 24 13
    jp l1560h           ;154e c3 60 15
l1551h:
    ld bc,0fffch        ;1551 01 fc ff
    ld hl,(l24c8h)      ;1554 2a c8 24
    add hl,bc           ;1557 09
    ld a,h              ;1558 7c
    or l                ;1559 b5
    jp nz,l1560h        ;155a c2 60 15
    call sub_1369h      ;155d cd 69 13
l1560h:
    jp l13eeh           ;1560 c3 ee 13
    ret                 ;1563 c9
sub_1564h:
    jp l1697h           ;1564 c3 97 16
sub_1567h:
    call sub_0179h      ;1567 cd 79 01
    ld bc,1cf2h         ;156a 01 f2 1c
    call sub_01a9h      ;156d cd a9 01
    ld bc,l1d09h        ;1570 01 09 1d
    call sub_01a9h      ;1573 cd a9 01
    ld bc,l1d1dh        ;1576 01 1d 1d
    call sub_01a9h      ;1579 cd a9 01
    ld bc,l1d37h        ;157c 01 37 1d
    call sub_01a9h      ;157f cd a9 01
    call sub_0179h      ;1582 cd 79 01
    ld bc,l1d53h        ;1585 01 53 1d
    call sub_0184h      ;1588 cd 84 01
    call sub_0216h      ;158b cd 16 02
    call sub_0179h      ;158e cd 79 01
    ld a,(l24cch)       ;1591 3a cc 24
    cp 54h              ;1594 fe 54
    jp nz,l15a4h        ;1596 c2 a4 15
    ld a,(5660h)        ;1599 3a 60 56
    and 3fh             ;159c e6 3f
    ld (5660h),a        ;159e 32 60 56
    jp l15e0h           ;15a1 c3 e0 15
l15a4h:
    ld a,(l24cch)       ;15a4 3a cc 24
    cp 43h              ;15a7 fe 43
    jp nz,l15b9h        ;15a9 c2 b9 15
    ld a,(5660h)        ;15ac 3a 60 56
    and 3fh             ;15af e6 3f
    or 40h              ;15b1 f6 40
    ld (5660h),a        ;15b3 32 60 56
    jp l15e0h           ;15b6 c3 e0 15
l15b9h:
    ld a,(l24cch)       ;15b9 3a cc 24
    cp 4ch              ;15bc fe 4c
    jp nz,l15ceh        ;15be c2 ce 15
    ld a,(5660h)        ;15c1 3a 60 56
    and 3fh             ;15c4 e6 3f
    or 80h              ;15c6 f6 80
    ld (5660h),a        ;15c8 32 60 56
    jp l15e0h           ;15cb c3 e0 15
l15ceh:
    ld a,(l24cch)       ;15ce 3a cc 24
    cp 55h              ;15d1 fe 55
    jp nz,l15e0h        ;15d3 c2 e0 15
    ld a,(5660h)        ;15d6 3a 60 56
    and 3fh             ;15d9 e6 3f
    or 0c0h             ;15db f6 c0
    ld (5660h),a        ;15dd 32 60 56
l15e0h:
    ret                 ;15e0 c9
sub_15e1h:
    ld bc,1d77h         ;15e1 01 77 1d
    call sub_0184h      ;15e4 cd 84 01
    call sub_0216h      ;15e7 cd 16 02
    call sub_0179h      ;15ea cd 79 01
    ld a,(l24cch)       ;15ed 3a cc 24
    cp 54h              ;15f0 fe 54
    jp nz,l1600h        ;15f2 c2 00 16
    ld a,(5660h)        ;15f5 3a 60 56
    and 0f3h            ;15f8 e6 f3
    ld (5660h),a        ;15fa 32 60 56
    jp l1612h           ;15fd c3 12 16
l1600h:
    ld a,(l24cch)       ;1600 3a cc 24
    cp 50h              ;1603 fe 50
    jp nz,l1612h        ;1605 c2 12 16
    ld a,(5660h)        ;1608 3a 60 56
    and 0f3h            ;160b e6 f3
    or 04h              ;160d f6 04
    ld (5660h),a        ;160f 32 60 56
l1612h:
    ret                 ;1612 c9
sub_1613h:
    ld bc,1d8bh         ;1613 01 8b 1d
    call sub_0184h      ;1616 cd 84 01
    call sub_0216h      ;1619 cd 16 02
    call sub_0179h      ;161c cd 79 01
    ld a,(l24cch)       ;161f 3a cc 24
    cp 54h              ;1622 fe 54
    jp nz,l1632h        ;1624 c2 32 16
    ld a,(5660h)        ;1627 3a 60 56
    and 0cfh            ;162a e6 cf
    ld (5660h),a        ;162c 32 60 56
    jp l1644h           ;162f c3 44 16
l1632h:
    ld a,(l24cch)       ;1632 3a cc 24
    cp 50h              ;1635 fe 50
    jp nz,l1644h        ;1637 c2 44 16
    ld a,(5660h)        ;163a 3a 60 56
    and 0cfh            ;163d e6 cf
    or 10h              ;163f f6 10
    ld (5660h),a        ;1641 32 60 56
l1644h:
    ret                 ;1644 c9
sub_1645h:
    call sub_0179h      ;1645 cd 79 01
    ld bc,1d9fh         ;1648 01 9f 1d
    call sub_01a9h      ;164b cd a9 01
    ld bc,l1dc0h        ;164e 01 c0 1d
    call sub_01a9h      ;1651 cd a9 01
    ld bc,l1dc9h        ;1654 01 c9 1d
    call sub_01a9h      ;1657 cd a9 01
    call sub_0179h      ;165a cd 79 01
    ld bc,l1de7h        ;165d 01 e7 1d
    call sub_0184h      ;1660 cd 84 01
    call sub_0216h      ;1663 cd 16 02
    call sub_0179h      ;1666 cd 79 01
    ld a,(l24cch)       ;1669 3a cc 24
    cp 33h              ;166c fe 33
    jp nz,l1679h        ;166e c2 79 16
    ld hl,566dh         ;1671 21 6d 56
    ld (hl),00h         ;1674 36 00
    jp l1696h           ;1676 c3 96 16
l1679h:
    ld a,(l24cch)       ;1679 3a cc 24
    cp 38h              ;167c fe 38
    jp nz,l1689h        ;167e c2 89 16
    ld hl,566dh         ;1681 21 6d 56
    ld (hl),02h         ;1684 36 02
    jp l1696h           ;1686 c3 96 16
l1689h:
    ld a,(l24cch)       ;1689 3a cc 24
    cp 44h              ;168c fe 44
    jp nz,l1696h        ;168e c2 96 16
    ld hl,566dh         ;1691 21 6d 56
    ld (hl),01h         ;1694 36 01
l1696h:
    ret                 ;1696 c9
l1697h:
    call sub_0300h      ;1697 cd 00 03
    call sub_0179h      ;169a cd 79 01
    ld bc,1e0dh         ;169d 01 0d 1e
    call sub_01a9h      ;16a0 cd a9 01
    ld bc,1e24h         ;16a3 01 24 1e
    call sub_01a9h      ;16a6 cd a9 01
    call sub_0179h      ;16a9 cd 79 01
    ld bc,l1e3bh        ;16ac 01 3b 1e
    call sub_0184h      ;16af cd 84 01
    ld a,(5661h)        ;16b2 3a 61 56
    ld l,a              ;16b5 6f
    rla                 ;16b6 17
    sbc a,a             ;16b7 9f
    ld b,a              ;16b8 47
    ld c,l              ;16b9 4d
    call l01f5h+1       ;16ba cd f6 01
    call sub_0179h      ;16bd cd 79 01
    call sub_0179h      ;16c0 cd 79 01
    ld bc,l1e58h        ;16c3 01 58 1e
    call sub_0184h      ;16c6 cd 84 01
    ld a,(5666h)        ;16c9 3a 66 56
    ld l,a              ;16cc 6f
    rla                 ;16cd 17
    sbc a,a             ;16ce 9f
    ld b,a              ;16cf 47
    ld c,l              ;16d0 4d
    call l01f5h+1       ;16d1 cd f6 01
    call sub_0179h      ;16d4 cd 79 01
    call sub_0179h      ;16d7 cd 79 01
    ld bc,l1e74h        ;16da 01 74 1e
    call sub_0184h      ;16dd cd 84 01
    ld a,(5662h)        ;16e0 3a 62 56
    ld l,a              ;16e3 6f
    rla                 ;16e4 17
    sbc a,a             ;16e5 9f
    ld b,a              ;16e6 47
    ld c,l              ;16e7 4d
    call l01f5h+1       ;16e8 cd f6 01
    call sub_0179h      ;16eb cd 79 01
    call sub_0179h      ;16ee cd 79 01
    ld bc,l1e8dh        ;16f1 01 8d 1e
    call sub_0184h      ;16f4 cd 84 01
    ld a,(5663h)        ;16f7 3a 63 56
    ld l,a              ;16fa 6f
    rla                 ;16fb 17
    sbc a,a             ;16fc 9f
    ld b,a              ;16fd 47
    ld c,l              ;16fe 4d
    call l01f5h+1       ;16ff cd f6 01
    call sub_0179h      ;1702 cd 79 01
    call sub_0179h      ;1705 cd 79 01
    ld bc,l1ea5h        ;1708 01 a5 1e
    call sub_0184h      ;170b cd 84 01
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
    ld hl,1ec6h         ;1726 21 c6 1e
    jp l173fh           ;1729 c3 3f 17
l172ch:
    ld a,(5660h)        ;172c 3a 60 56
    and 0c0h            ;172f e6 c0
    cp 80h              ;1731 fe 80
    jp nz,l173ch        ;1733 c2 3c 17
    ld hl,1ecbh         ;1736 21 cb 1e
    jp l173fh           ;1739 c3 3f 17
l173ch:
    ld hl,1ed0h         ;173c 21 d0 1e
l173fh:
    ld b,h              ;173f 44
    ld c,l              ;1740 4d
    call sub_01a9h      ;1741 cd a9 01
    call sub_0179h      ;1744 cd 79 01
    ld bc,1ed5h         ;1747 01 d5 1e
    call sub_0184h      ;174a cd 84 01
    ld a,(5660h)        ;174d 3a 60 56
    and 0ch             ;1750 e6 0c
    jp nz,l175bh        ;1752 c2 5b 17
    ld hl,l1ef1h        ;1755 21 f1 1e
    jp l175eh           ;1758 c3 5e 17
l175bh:
    ld hl,1ef6h         ;175b 21 f6 1e
l175eh:
    ld b,h              ;175e 44
    ld c,l              ;175f 4d
    call sub_01a9h      ;1760 cd a9 01
    call sub_0179h      ;1763 cd 79 01
    ld bc,1efbh         ;1766 01 fb 1e
    call sub_0184h      ;1769 cd 84 01
    ld a,(5660h)        ;176c 3a 60 56
    and 30h             ;176f e6 30
    jp nz,l177ah        ;1771 c2 7a 17
    ld hl,l1f17h        ;1774 21 17 1f
    jp l177dh           ;1777 c3 7d 17
l177ah:
    ld hl,1f1ch         ;177a 21 1c 1f
l177dh:
    ld b,h              ;177d 44
    ld c,l              ;177e 4d
    call sub_01a9h      ;177f cd a9 01
    call sub_0179h      ;1782 cd 79 01
    ld bc,1f21h         ;1785 01 21 1f
    call sub_0184h      ;1788 cd 84 01
    ld a,(566dh)        ;178b 3a 6d 56
    or a                ;178e b7
    jp nz,l1798h        ;178f c2 98 17
    ld hl,l1f3dh        ;1792 21 3d 1f
    jp l17b7h           ;1795 c3 b7 17
l1798h:
    ld a,(566dh)        ;1798 3a 6d 56
    cp 01h              ;179b fe 01
    jp nz,l17a6h        ;179d c2 a6 17
    ld hl,1f47h         ;17a0 21 47 1f
    jp l17b7h           ;17a3 c3 b7 17
l17a6h:
    ld a,(566dh)        ;17a6 3a 6d 56
    cp 02h              ;17a9 fe 02
    jp nz,l17b4h        ;17ab c2 b4 17
    ld hl,1f51h         ;17ae 21 51 1f
    jp l17b7h           ;17b1 c3 b7 17
l17b4h:
    ld hl,1f56h         ;17b4 21 56 1f
l17b7h:
    ld b,h              ;17b7 44
    ld c,l              ;17b8 4d
    call sub_01a9h      ;17b9 cd a9 01
    call sub_0179h      ;17bc cd 79 01
    call sub_0179h      ;17bf cd 79 01
    ld bc,l1f5bh        ;17c2 01 5b 1f
    call sub_0184h      ;17c5 cd 84 01
    call sub_0216h      ;17c8 cd 16 02
    call sub_0179h      ;17cb cd 79 01
    ld a,(l24cch)       ;17ce 3a cc 24
    cp 0dh              ;17d1 fe 0d
    jp nz,l17d7h        ;17d3 c2 d7 17
    ret                 ;17d6 c9
l17d7h:
    ld bc,0fffbh        ;17d7 01 fb ff
    ld hl,(l24c8h)      ;17da 2a c8 24
    add hl,bc           ;17dd 09
    ld a,h              ;17de 7c
    or l                ;17df b5
    jp nz,l17e9h        ;17e0 c2 e9 17
    call sub_1567h      ;17e3 cd 67 15
    jp l1872h           ;17e6 c3 72 18
l17e9h:
    ld bc,0fffah        ;17e9 01 fa ff
    ld hl,(l24c8h)      ;17ec 2a c8 24
    add hl,bc           ;17ef 09
    ld a,h              ;17f0 7c
    or l                ;17f1 b5
    jp nz,l17fbh        ;17f2 c2 fb 17
    call sub_15e1h      ;17f5 cd e1 15
    jp l1872h           ;17f8 c3 72 18
l17fbh:
    ld bc,0fff9h        ;17fb 01 f9 ff
    ld hl,(l24c8h)      ;17fe 2a c8 24
    add hl,bc           ;1801 09
    ld a,h              ;1802 7c
    or l                ;1803 b5
    jp nz,l180dh        ;1804 c2 0d 18
    call sub_1613h      ;1807 cd 13 16
    jp l1872h           ;180a c3 72 18
l180dh:
    ld bc,0fff8h        ;180d 01 f8 ff
    ld hl,(l24c8h)      ;1810 2a c8 24
    add hl,bc           ;1813 09
    ld a,h              ;1814 7c
    or l                ;1815 b5
    jp nz,l181fh        ;1816 c2 1f 18
    call sub_1645h      ;1819 cd 45 16
    jp l1872h           ;181c c3 72 18
l181fh:
    ld a,(l24c8h)       ;181f 3a c8 24
    ld (l3029h),a       ;1822 32 29 30
    ld bc,1f7fh         ;1825 01 7f 1f
    call sub_0184h      ;1828 cd 84 01
    call sub_0216h      ;182b cd 16 02
    call sub_0179h      ;182e cd 79 01
    ld a,(l3029h)       ;1831 3a 29 30
    cp 01h              ;1834 fe 01
    jp nz,l1842h        ;1836 c2 42 18
    ld a,(l24c8h)       ;1839 3a c8 24
    ld (5661h),a        ;183c 32 61 56
    jp l1872h           ;183f c3 72 18
l1842h:
    ld a,(l3029h)       ;1842 3a 29 30
    cp 02h              ;1845 fe 02
    jp nz,l1853h        ;1847 c2 53 18
    ld a,(l24c8h)       ;184a 3a c8 24
    ld (5666h),a        ;184d 32 66 56
    jp l1872h           ;1850 c3 72 18
l1853h:
    ld a,(l3029h)       ;1853 3a 29 30
    cp 03h              ;1856 fe 03
    jp nz,l1864h        ;1858 c2 64 18
    ld a,(l24c8h)       ;185b 3a c8 24
    ld (5662h),a        ;185e 32 62 56
    jp l1872h           ;1861 c3 72 18
l1864h:
    ld a,(l3029h)       ;1864 3a 29 30
    cp 04h              ;1867 fe 04
    jp nz,l1872h        ;1869 c2 72 18
    ld a,(l24c8h)       ;186c 3a c8 24
    ld (5663h),a        ;186f 32 63 56
l1872h:
    jp l1697h           ;1872 c3 97 16
    ret                 ;1875 c9
sub_1876h:
    jp l1a46h           ;1876 c3 46 1a
sub_1879h:
    ld bc,1f8fh         ;1879 01 8f 1f
    call sub_0184h      ;187c cd 84 01
    call sub_0216h      ;187f cd 16 02
    call sub_0179h      ;1882 cd 79 01
    ld hl,(l24c8h)      ;1885 2a c8 24
    dec hl              ;1888 2b
    ld a,h              ;1889 7c
    or l                ;188a b5
    jp nz,l1896h        ;188b c2 96 18
    ld hl,44b2h         ;188e 21 b2 44
    ld (hl),00h         ;1891 36 00
    jp l18b9h           ;1893 c3 b9 18
l1896h:
    ld hl,(l24c8h)      ;1896 2a c8 24
    dec hl              ;1899 2b
    dec hl              ;189a 2b
    ld a,h              ;189b 7c
    or l                ;189c b5
    jp nz,l18a8h        ;189d c2 a8 18
    ld hl,44b2h         ;18a0 21 b2 44
    ld (hl),01h         ;18a3 36 01
    jp l18b9h           ;18a5 c3 b9 18
l18a8h:
    ld bc,0fffch        ;18a8 01 fc ff
    ld hl,(l24c8h)      ;18ab 2a c8 24
    add hl,bc           ;18ae 09
    ld a,h              ;18af 7c
    or l                ;18b0 b5
    jp nz,l18b9h        ;18b1 c2 b9 18
    ld hl,44b2h         ;18b4 21 b2 44
    ld (hl),03h         ;18b7 36 03
l18b9h:
    ret                 ;18b9 c9
sub_18bah:
    ld a,(5667h)        ;18ba 3a 67 56
    xor 80h             ;18bd ee 80
    ld (5667h),a        ;18bf 32 67 56
    ret                 ;18c2 c9
sub_18c3h:
    ld bc,1fb0h         ;18c3 01 b0 1f
    call sub_0184h      ;18c6 cd 84 01
    call sub_0216h      ;18c9 cd 16 02
    call sub_0179h      ;18cc cd 79 01
    ld a,(l24cch)       ;18cf 3a cc 24
    cp 41h              ;18d2 fe 41
    jp nz,l18e2h        ;18d4 c2 e2 18
    ld a,(5667h)        ;18d7 3a 67 56
    and 80h             ;18da e6 80
    ld (5667h),a        ;18dc 32 67 56
    jp l18f4h           ;18df c3 f4 18
l18e2h:
    ld a,(l24cch)       ;18e2 3a cc 24
    cp 54h              ;18e5 fe 54
    jp nz,l18f4h        ;18e7 c2 f4 18
    ld a,(5667h)        ;18ea 3a 67 56
    and 80h             ;18ed e6 80
    or 02h              ;18ef f6 02
    ld (5667h),a        ;18f1 32 67 56
l18f4h:
    ld a,(l24cch)       ;18f4 3a cc 24
    cp 48h              ;18f7 fe 48
    jp nz,l1997h        ;18f9 c2 97 19
l18fch:
    ld bc,1fddh         ;18fc 01 dd 1f
    call sub_0184h      ;18ff cd 84 01
    call sub_0216h      ;1902 cd 16 02
    call sub_0179h      ;1905 cd 79 01
    ld a,(l24cch)       ;1908 3a cc 24
    cp 45h              ;190b fe 45
    jp nz,l1918h        ;190d c2 18 19
    ld hl,5668h         ;1910 21 68 56
    ld (hl),1bh         ;1913 36 1b
    jp l192bh           ;1915 c3 2b 19
l1918h:
    ld a,(l24cch)       ;1918 3a cc 24
    cp 54h              ;191b fe 54
    jp nz,l1928h        ;191d c2 28 19
    ld hl,5668h         ;1920 21 68 56
    ld (hl),7eh         ;1923 36 7e
    jp l192bh           ;1925 c3 2b 19
l1928h:
    jp l18fch           ;1928 c3 fc 18
l192bh:
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
    ld bc,2001h         ;1a2b 01 01 20
    call sub_0184h      ;1a2e cd 84 01
    call sub_0216h      ;1a31 cd 16 02
    call sub_0179h      ;1a34 cd 79 01
    ld hl,(l24c8h)      ;1a37 2a c8 24
    ld a,l              ;1a3a 7d
    or h                ;1a3b b4
    jp z,l1a45h         ;1a3c ca 45 1a
    ld a,(l24c8h)       ;1a3f 3a c8 24
    ld (6005h),a        ;1a42 32 05 60
l1a45h:
    ret                 ;1a45 c9
l1a46h:
    call sub_0300h      ;1a46 cd 00 03
    call sub_0179h      ;1a49 cd 79 01
    ld bc,2018h         ;1a4c 01 18 20
    call sub_01a9h      ;1a4f cd a9 01
    ld bc,l2030h        ;1a52 01 30 20
    call sub_01a9h      ;1a55 cd a9 01
    call sub_0179h      ;1a58 cd 79 01
    ld bc,l2048h        ;1a5b 01 48 20
    call sub_0184h      ;1a5e cd 84 01
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
    call sub_01a9h      ;1a81 cd a9 01
    call sub_0179h      ;1a84 cd 79 01
    ld bc,l206dh        ;1a87 01 6d 20
    call sub_0184h      ;1a8a cd 84 01
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
    call sub_01a9h      ;1aa0 cd a9 01
    call sub_0179h      ;1aa3 cd 79 01
    ld bc,l2093h        ;1aa6 01 93 20
    call sub_0184h      ;1aa9 cd 84 01
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
    ld hl,20beh         ;1adc 21 be 20
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
    ld hl,20fch         ;1af6 21 fc 20
l1af9h:
    ld b,h              ;1af9 44
    ld c,l              ;1afa 4d
    call sub_01a9h      ;1afb cd a9 01
    call sub_0179h      ;1afe cd 79 01
    ld bc,l2103h        ;1b01 01 03 21
    call sub_0184h      ;1b04 cd 84 01
    ld a,(6005h)        ;1b07 3a 05 60
    ld l,a              ;1b0a 6f
    rla                 ;1b0b 17
    sbc a,a             ;1b0c 9f
    ld b,a              ;1b0d 47
    ld c,l              ;1b0e 4d
    call l01f5h+1       ;1b0f cd f6 01
    call sub_0179h      ;1b12 cd 79 01
    call sub_0179h      ;1b15 cd 79 01
    ld bc,l2122h        ;1b18 01 22 21
    call sub_0184h      ;1b1b cd 84 01
    call sub_0216h      ;1b1e cd 16 02
    call sub_0179h      ;1b21 cd 79 01
    ld a,(l24cch)       ;1b24 3a cc 24
    cp 0dh              ;1b27 fe 0d
    jp nz,l1b2dh        ;1b29 c2 2d 1b
    ret                 ;1b2c c9
l1b2dh:
    ld hl,(l24c8h)      ;1b2d 2a c8 24
    dec hl              ;1b30 2b
    ld a,h              ;1b31 7c
l1b32h:
    or l                ;1b32 b5
    jp nz,l1b3ch        ;1b33 c2 3c 1b
    call sub_1879h      ;1b36 cd 79 18
    jp l1b6ch           ;1b39 c3 6c 1b
l1b3ch:
    ld hl,(l24c8h)      ;1b3c 2a c8 24
    dec hl              ;1b3f 2b
    dec hl              ;1b40 2b
    ld a,h              ;1b41 7c
    or l                ;1b42 b5
    jp nz,l1b4ch        ;1b43 c2 4c 1b
    call sub_18bah      ;1b46 cd ba 18
    jp l1b6ch           ;1b49 c3 6c 1b
l1b4ch:
    ld hl,(l24c8h)      ;1b4c 2a c8 24
    dec hl              ;1b4f 2b
    dec hl              ;1b50 2b
    dec hl              ;1b51 2b
    ld a,h              ;1b52 7c
    or l                ;1b53 b5
    jp nz,l1b5dh        ;1b54 c2 5d 1b
    call sub_18c3h      ;1b57 cd c3 18
    jp l1b6ch           ;1b5a c3 6c 1b
l1b5dh:
    ld bc,0fffch        ;1b5d 01 fc ff
    ld hl,(l24c8h)      ;1b60 2a c8 24
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

    db 01h
    nop                 ;2138 00
l2139h:
    inc e               ;2139 1c
    ld hl,4000h         ;213a 21 00 40
    ld de,0d400h        ;213d 11 00 d4
l2140h:
    ldir                ;2140 ed b0
l2142h:
    jp 0f075h           ;2142 c3 75 f0
sub_2145h:
    ld a,c              ;2145 79
    ld (l2422h),a       ;2146 32 22 24
    call 0f054h         ;2149 cd 54 f0
l214ch:
    ld e,00h            ;214c 1e 00
    push de             ;214e d5
    call sub_221ch      ;214f cd 1c 22
    ld a,(l2422h)       ;2152 3a 22 24
    call 0f05ah         ;2155 cd 5a f0
l2158h:
    ld (l2423h),a       ;2158 32 23 24
    ld hl,4000h         ;215b 21 00 40
    ld bc,1c00h         ;215e 01 00 1c
    pop de              ;2161 d1
    or a                ;2162 b7
    ret nz              ;2163 c0
    push de             ;2164 d5
    call 0f039h         ;2165 cd 39 f0
l2168h:
    call 0f03fh         ;2168 cd 3f f0
    ld (hl),a           ;216b 77
    inc hl              ;216c 23
    dec bc              ;216d 0b
    ld a,b              ;216e 78
    or c                ;216f b1
    jr nz,l2168h        ;2170 20 f6
    call 0f03ch         ;2172 cd 3c f0
l2175h:
    pop de              ;2175 d1
    push de             ;2176 d5
    call 0f060h         ;2177 cd 60 f0
    pop de              ;217a d1
    push de             ;217b d5
    call sub_222eh      ;217c cd 2e 22
    ld a,(l2422h)       ;217f 3a 22 24
    call 0f05ah         ;2182 cd 5a f0
    ld (l2423h),a       ;2185 32 23 24
    ld hl,6000h         ;2188 21 00 60
    ld bc,0800h         ;218b 01 00 08
    pop de              ;218e d1
    or a                ;218f b7
    ret nz              ;2190 c0
    push de             ;2191 d5
    call 0f039h         ;2192 cd 39 f0
l2195h:
    call 0f03fh         ;2195 cd 3f f0
    ld (hl),a           ;2198 77
    inc hl              ;2199 23
    dec bc              ;219a 0b
    ld a,b              ;219b 78
    or c                ;219c b1
    jr nz,l2195h        ;219d 20 f6
    call 0f03ch         ;219f cd 3c f0
    pop de              ;21a2 d1
    call 0f060h         ;21a3 cd 60 f0
    ld a,(l2422h)       ;21a6 3a 22 24
    call 0f05ah         ;21a9 cd 5a f0
    ld (l2423h),a       ;21ac 32 23 24
    ret                 ;21af c9
sub_21b0h:
    call 0f01bh         ;21b0 cd 1b f0
    ld de,4000h         ;21b3 11 00 40
    ld bc,0000h         ;21b6 01 00 00
l21b9h:
    call 0f01eh         ;21b9 cd 1e f0
    push bc             ;21bc c5
    ld bc,0000h         ;21bd 01 00 00
l21c0h:
    call 0f021h         ;21c0 cd 21 f0
    push bc             ;21c3 c5
    push de             ;21c4 d5
    call 0f027h         ;21c5 cd 27 f0
    or a                ;21c8 b7
    jr nz,l2216h        ;21c9 20 4b
    pop de              ;21cb d1
    ld bc,0080h         ;21cc 01 80 00
    ld hl,0080h         ;21cf 21 80 00
    ldir                ;21d2 ed b0
    pop bc              ;21d4 c1
    inc c               ;21d5 0c
    ld a,c              ;21d6 79
    cp 40h              ;21d7 fe 40
    jr nz,l21c0h        ;21d9 20 e5
    pop bc              ;21db c1
    inc c               ;21dc 0c
    ld a,c              ;21dd 79
    cp 02h              ;21de fe 02
    jr nz,l21b9h        ;21e0 20 d7
    ret                 ;21e2 c9
sub_21e3h:
    call 0f01bh         ;21e3 cd 1b f0
    ld hl,4000h         ;21e6 21 00 40
    ld bc,0000h         ;21e9 01 00 00
l21ech:
    call 0f01eh         ;21ec cd 1e f0
    push bc             ;21ef c5
    ld bc,0000h         ;21f0 01 00 00
l21f3h:
    call 0f021h         ;21f3 cd 21 f0
    push bc             ;21f6 c5
    ld bc,0080h         ;21f7 01 80 00
    ld de,0080h         ;21fa 11 80 00
    ldir                ;21fd ed b0
    push hl             ;21ff e5
    call 0f02ah         ;2200 cd 2a f0
    or a                ;2203 b7
    jr nz,l2216h        ;2204 20 10
    pop hl              ;2206 e1
    pop bc              ;2207 c1
    inc c               ;2208 0c
    ld a,c              ;2209 79
    cp 40h              ;220a fe 40
    jr nz,l21f3h        ;220c 20 e5
    pop bc              ;220e c1
    inc c               ;220f 0c
    ld a,c              ;2210 79
    cp 02h              ;2211 fe 02
    jr nz,l21ech        ;2213 20 d7
    ret                 ;2215 c9
l2216h:
    pop hl              ;2216 e1
    pop hl              ;2217 e1
    pop hl              ;2218 e1
    jp l23b7h           ;2219 c3 b7 23
sub_221ch:
    ld c,06h            ;221c 0e 06
    ld hl,2410h         ;221e 21 10 24
    ld a,(l2422h)       ;2221 3a 22 24
    rra                 ;2224 1f
    jp nc,0f05dh        ;2225 d2 5d f0
    ld hl,l2416h        ;2228 21 16 24
    jp 0f05dh           ;222b c3 5d f0
sub_222eh:
    ld c,03h            ;222e 0e 03
    ld hl,l241ch        ;2230 21 1c 24
    ld a,(l2422h)       ;2233 3a 22 24
    rra                 ;2236 1f
    jp nc,0f05dh        ;2237 d2 5d f0
    ld hl,l241fh        ;223a 21 1f 24
    jp 0f05dh           ;223d c3 5d f0
sub_2240h:
    ld a,c              ;2240 79
    ld (l2422h),a       ;2241 32 22 24
    call 0f054h         ;2244 cd 54 f0
    push de             ;2247 d5
    ld e,0fh            ;2248 1e 0f
    ld hl,l2408h        ;224a 21 08 24
    ld a,(l2422h)       ;224d 3a 22 24
    rra                 ;2250 1f
    jr nc,l2256h        ;2251 30 03
    ld hl,240ch         ;2253 21 0c 24
l2256h:
    ld c,04h            ;2256 0e 04
    call 0f05dh         ;2258 cd 5d f0
    ld a,(l2422h)       ;225b 3a 22 24
    call 0f05ah         ;225e cd 5a f0
    ld (l2423h),a       ;2261 32 23 24
    pop de              ;2264 d1
    cp 01h              ;2265 fe 01
    ret nz              ;2267 c0
    ld e,01h            ;2268 1e 01
    push de             ;226a d5
    call sub_222eh      ;226b cd 2e 22
    ld a,(l2422h)       ;226e 3a 22 24
    call 0f05ah         ;2271 cd 5a f0
    ld (l2423h),a       ;2274 32 23 24
    pop de              ;2277 d1
    or a                ;2278 b7
    ret nz              ;2279 c0
    push de             ;227a d5
    call 0f033h         ;227b cd 33 f0
    ld hl,6000h         ;227e 21 00 60
    ld bc,0800h         ;2281 01 00 08
l2284h:
    ld a,(hl)           ;2284 7e
    call 0f042h         ;2285 cd 42 f0
    inc hl              ;2288 23
    dec bc              ;2289 0b
    ld a,b              ;228a 78
    or c                ;228b b1
    jr nz,l2284h        ;228c 20 f6
    call 0f036h         ;228e cd 36 f0
    pop de              ;2291 d1
    push de             ;2292 d5
    call 0f060h         ;2293 cd 60 f0
    pop de              ;2296 d1
    push de             ;2297 d5
    call sub_221ch      ;2298 cd 1c 22
    ld a,(l2422h)       ;229b 3a 22 24
    call 0f05ah         ;229e cd 5a f0
    ld (l2423h),a       ;22a1 32 23 24
    pop de              ;22a4 d1
    or a                ;22a5 b7
    ret nz              ;22a6 c0
    push de             ;22a7 d5
    call 0f033h         ;22a8 cd 33 f0
    ld hl,4000h         ;22ab 21 00 40
    ld bc,1c00h         ;22ae 01 00 1c
l22b1h:
    ld a,(hl)           ;22b1 7e
    call 0f042h         ;22b2 cd 42 f0
    inc hl              ;22b5 23
    dec bc              ;22b6 0b
    ld a,b              ;22b7 78
    or c                ;22b8 b1
    jr nz,l22b1h        ;22b9 20 f6
    call 0f036h         ;22bb cd 36 f0
    pop de              ;22be d1
    call 0f060h         ;22bf cd 60 f0
    ld a,(l2422h)       ;22c2 3a 22 24
    call 0f05ah         ;22c5 cd 5a f0
    ld (l2423h),a       ;22c8 32 23 24
    ret                 ;22cb c9
    ld a,c              ;22cc 79
    ld (l2422h),a       ;22cd 32 22 24
    call 0f054h         ;22d0 cd 54 f0
    ld a,(l2422h)       ;22d3 3a 22 24
    and 01h             ;22d6 e6 01
    add a,30h           ;22d8 c6 30
    ld (l23e4h),a       ;22da 32 e4 23
    ld e,0fh            ;22dd 1e 0f
    ld c,14h            ;22df 0e 14
    ld hl,23e3h         ;22e1 21 e3 23
    call 0f05dh         ;22e4 cd 5d f0
    ld a,(l2422h)       ;22e7 3a 22 24
    call 0f05ah         ;22ea cd 5a f0
    ld (l2423h),a       ;22ed 32 23 24
    or a                ;22f0 b7
    ret nz              ;22f1 c0
    ld a,(l2422h)       ;22f2 3a 22 24
    call 0f078h         ;22f5 cd 78 f0
    ld hl,4000h         ;22f8 21 00 40
    ld de,4001h         ;22fb 11 01 40
    ld bc,00ffh         ;22fe 01 ff 00
    ld (hl),0e5h        ;2301 36 e5
    ldir                ;2303 ed b0
    ld a,0fh            ;2305 3e 0f
    ld (l2407h),a       ;2307 32 07 24
    ld a,01h            ;230a 3e 01
    ld (l2406h),a       ;230c 32 06 24
l230fh:
    call sub_2325h      ;230f cd 25 23
    ld a,(l2422h)       ;2312 3a 22 24
    call 0f05ah         ;2315 cd 5a f0
    ld (l2423h),a       ;2318 32 23 24
    or a                ;231b b7
    ret nz              ;231c c0
    ld hl,l2407h        ;231d 21 07 24
    dec (hl)            ;2320 35
    jp p,l230fh         ;2321 f2 0f 23
    ret                 ;2324 c9
sub_2325h:
    ld hl,l23feh        ;2325 21 fe 23
    ld c,06h            ;2328 0e 06
    ld a,(l2422h)       ;232a 3a 22 24
    call 0f057h         ;232d cd 57 f0
    call 0f04bh         ;2330 cd 4b f0
    ld a,(4000h)        ;2333 3a 00 40
    call 0f045h         ;2336 cd 45 f0
    call 0f036h         ;2339 cd 36 f0
    ld hl,l23f7h        ;233c 21 f7 23
    ld c,07h            ;233f 0e 07
    ld a,(l2422h)       ;2341 3a 22 24
    call 0f057h         ;2344 cd 57 f0
    call 0f04bh         ;2347 cd 4b f0
    call 0f048h         ;234a cd 48 f0
    call 0f036h         ;234d cd 36 f0
    ld a,(l2422h)       ;2350 3a 22 24
    call 0f054h         ;2353 cd 54 f0
    ld e,02h            ;2356 1e 02
    call 0f033h         ;2358 cd 33 f0
    ld hl,4001h         ;235b 21 01 40
    ld c,0ffh           ;235e 0e ff
    call 0f04bh         ;2360 cd 4b f0
    call 0f036h         ;2363 cd 36 f0
    ld a,(l2422h)       ;2366 3a 22 24
    call 0f057h         ;2369 cd 57 f0
    ld hl,l23deh        ;236c 21 de 23
    ld c,05h            ;236f 0e 05
    call 0f04bh         ;2371 cd 4b f0
    ld a,(l2422h)       ;2374 3a 22 24
    and 01h             ;2377 e6 01
    add a,30h           ;2379 c6 30
    call 0f042h         ;237b cd 42 f0
    ld a,(l2406h)       ;237e 3a 06 24
    call 0f04eh         ;2381 cd 4e f0
    ld a,(l2407h)       ;2384 3a 07 24
    call 0f04eh         ;2387 cd 4e f0
    call 0f048h         ;238a cd 48 f0
    jp 0f036h           ;238d c3 36 f0
    call 0f01bh         ;2390 cd 1b f0
    ld hl,0080h         ;2393 21 80 00
l2396h:
    ld (hl),0e5h        ;2396 36 e5
    inc l               ;2398 2c
    jr nz,l2396h        ;2399 20 fb
    ld bc,0002h         ;239b 01 02 00
    call 0f01eh         ;239e cd 1e f0
    ld bc,0000h         ;23a1 01 00 00
l23a4h:
    push bc             ;23a4 c5
    call 0f021h         ;23a5 cd 21 f0
    call 0f02ah         ;23a8 cd 2a f0
    pop bc              ;23ab c1
    or a                ;23ac b7
    jp nz,l23b7h        ;23ad c2 b7 23
    inc bc              ;23b0 03
    ld a,c              ;23b1 79
    cp 40h              ;23b2 fe 40
    jr nz,l23a4h        ;23b4 20 ee
    ret                 ;23b6 c9
l23b7h:
    ld de,l23c4h        ;23b7 11 c4 23
    ld c,09h            ;23ba 0e 09
    call 0005h          ;23bc cd 05 00
    ld c,01h            ;23bf 0e 01
    jp 0005h            ;23c1 c3 05 00
l23c4h:
    dec c               ;23c4 0d
    ld a,(bc)           ;23c5 0a
    ld c,b              ;23c6 48
    ld l,c              ;23c7 69
    ld (hl),h           ;23c8 74
    jr nz,l242ch        ;23c9 20 61
    ld l,(hl)           ;23cb 6e
    ld a,c              ;23cc 79
    jr nz,l243ah        ;23cd 20 6b
    ld h,l              ;23cf 65
    ld a,c              ;23d0 79
    jr nz,l2447h        ;23d1 20 74
    ld l,a              ;23d3 6f
    jr nz,l2437h        ;23d4 20 61
    ld h,d              ;23d6 62
    ld l,a              ;23d7 6f
    ld (hl),d           ;23d8 72
    ld (hl),h           ;23d9 74
    jr nz,l2416h        ;23da 20 3a
    jr nz,l2402h        ;23dc 20 24
l23deh:
    ld d,l              ;23de 55
    ld (3220h),a        ;23df 32 20 32
    jr nz,l2432h        ;23e2 20 4e
l23e4h:
    jr nc,$+60          ;23e4 30 3a
    ld b,e              ;23e6 43
    ld d,b              ;23e7 50
    cpl                 ;23e8 2f
    ld c,l              ;23e9 4d
    jr nz,l2442h        ;23ea 20 56
    ld (322eh),a        ;23ec 32 2e 32
    jr nz,l2435h        ;23ef 20 44
    ld c,c              ;23f1 49
    ld d,e              ;23f2 53
    ld c,e              ;23f3 4b
    inc l               ;23f4 2c
    ld e,b              ;23f5 58
    ld e,b              ;23f6 58
l23f7h:
    ld b,d              ;23f7 42
    dec l               ;23f8 2d
    ld d,b              ;23f9 50
    jr nz,l242eh        ;23fa 20 32
    jr nz,l242fh        ;23fc 20 31
l23feh:
    ld c,l              ;23fe 4d
    dec l               ;23ff 2d
    ld d,a              ;2400 57
    nop                 ;2401 00
l2402h:
    inc de              ;2402 13
    ld bc,3223h         ;2403 01 23 32
l2406h:
    nop                 ;2406 00
l2407h:
    nop                 ;2407 00
l2408h:
    ld d,e              ;2408 53
    jr nc,l2445h        ;2409 30 3a
    ld hl,(3153h)       ;240b 2a 53 31
    ld a,(l302ah)       ;240e 3a 2a 30
    ld a,(5043h)        ;2411 3a 43 50
    cpl                 ;2414 2f
    ld c,l              ;2415 4d
l2416h:
    ld sp,433ah         ;2416 31 3a 43
    ld d,b              ;2419 50
    cpl                 ;241a 2f
    ld c,l              ;241b 4d
l241ch:
    jr nc,l2458h        ;241c 30 3a
    ld c,e              ;241e 4b
l241fh:
    ld sp,4b3ah         ;241f 31 3a 4b
l2422h:
    nop                 ;2422 00
l2423h:
    nop                 ;2423 00
l2424h:
    nop                 ;2424 00
l2425h:
    nop                 ;2425 00
l2426h:
    nop                 ;2426 00
    nop                 ;2427 00
    nop                 ;2428 00
    nop                 ;2429 00
    nop                 ;242a 00
    nop                 ;242b 00
l242ch:
    nop                 ;242c 00
    nop                 ;242d 00
l242eh:
    nop                 ;242e 00
l242fh:
    nop                 ;242f 00
    nop                 ;2430 00
    nop                 ;2431 00
l2432h:
    nop                 ;2432 00
    nop                 ;2433 00
    nop                 ;2434 00
l2435h:
    nop                 ;2435 00
    nop                 ;2436 00
l2437h:
    nop                 ;2437 00
    nop                 ;2438 00
    nop                 ;2439 00
l243ah:
    nop                 ;243a 00
    nop                 ;243b 00
    nop                 ;243c 00
    nop                 ;243d 00
    nop                 ;243e 00
    nop                 ;243f 00
    nop                 ;2440 00
    nop                 ;2441 00
l2442h:
    nop                 ;2442 00
    nop                 ;2443 00
    nop                 ;2444 00
l2445h:
    nop                 ;2445 00
    nop                 ;2446 00
l2447h:
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
l2458h:
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
l24c8h:
    nop                 ;24c8 00
    nop                 ;24c9 00
l24cah:
    nop                 ;24ca 00
    nop                 ;24cb 00
l24cch:
    nop                 ;24cc 00
sub_24cdh:
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
sub_2529h:
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
l2932h:
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
l2d20h:
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
    nop                 ;3000 00
    nop                 ;3001 00
l3002h:
    nop                 ;3002 00
    nop                 ;3003 00
l3004h:
    nop                 ;3004 00
    nop                 ;3005 00
l3006h:
    nop                 ;3006 00
l3007h:
    nop                 ;3007 00
l3008h:
    nop                 ;3008 00
l3009h:
    nop                 ;3009 00
l300ah:
    nop                 ;300a 00
l300bh:
    nop                 ;300b 00
l300ch:
    nop                 ;300c 00
l300dh:
    nop                 ;300d 00
l300eh:
    nop                 ;300e 00
l300fh:
    nop                 ;300f 00
    nop                 ;3010 00
l3011h:
    nop                 ;3011 00
    nop                 ;3012 00
l3013h:
    nop                 ;3013 00
l3014h:
    nop                 ;3014 00
l3015h:
    nop                 ;3015 00
l3016h:
    nop                 ;3016 00
l3017h:
    nop                 ;3017 00
l3018h:
    nop                 ;3018 00
l3019h:
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
l3028h:
    nop                 ;3028 00
l3029h:
    nop                 ;3029 00
l302ah:
    nop                 ;302a 00
    nop                 ;302b 00
    nop                 ;302c 00
    nop                 ;302d 00
    nop                 ;302e 00
    nop                 ;302f 00
l3030h:
    nop                 ;3030 00
l3031h:
    nop                 ;3031 00
l3032h:
    nop                 ;3032 00
    nop                 ;3033 00
    nop                 ;3034 00
l3035h:
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