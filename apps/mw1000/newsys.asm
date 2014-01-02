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
    ld bc,l0cf0h+1      ;0368 01 f1 0c
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
    ld bc,l0dfeh+1      ;0465 01 ff 0d
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
    ld bc,l0e8eh+1      ;0558 01 8f 0e
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
    ld bc,l0eb1h+1      ;057c 01 b2 0e
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
    ld hl,l0f66h+1      ;0718 21 67 0f
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
    ld bc,l0f96h+1      ;07af 01 97 0f
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
    ld bc,l10dfh+1      ;0a4d 01 e0 10
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
    ld bc,l10feh+1      ;0aa0 01 ff 10
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
    ld c,44h            ;0c84 0e 44
    ld l,c              ;0c86 69
    ld (hl),e           ;0c87 73
    ld l,e              ;0c88 6b
    jr nz,l0cf0h        ;0c89 20 65
    ld (hl),d           ;0c8b 72
    ld (hl),d           ;0c8c 72
    ld l,a              ;0c8d 6f
    ld (hl),d           ;0c8e 72
    jr nz,l0ccbh        ;0c8f 20 3a
    jr nz,l0cb3h        ;0c91 20 20
l0c93h:
    ld bc,1a30h         ;0c93 01 30 1a
    ld b,h              ;0c96 44
    ld h,l              ;0c97 65
    halt                ;0c98 76
    ld l,c              ;0c99 69
    ld h,e              ;0c9a 63
    ld h,l              ;0c9b 65
    jr nz,l0d0ch        ;0c9c 20 6e
    ld (hl),l           ;0c9e 75
    ld l,l              ;0c9f 6d
    ld h,d              ;0ca0 62
    ld h,l              ;0ca1 65
    ld (hl),d           ;0ca2 72
    jr nz,l0d0bh        ;0ca3 20 66
    ld l,a              ;0ca5 6f
    ld (hl),d           ;0ca6 72
    jr nz,l0d0dh        ;0ca7 20 64
    ld (hl),d           ;0ca9 72
    ld l,c              ;0caa 69
    halt                ;0cab 76
    ld h,l              ;0cac 65
    jr nz,l0ceeh        ;0cad 20 3f
    jr nz,$+36          ;0caf 20 22
    ld b,e              ;0cb1 43
    ld l,a              ;0cb2 6f
l0cb3h:
    ld l,(hl)           ;0cb3 6e
    ld h,(hl)           ;0cb4 66
    ld l,c              ;0cb5 69
    ld h,a              ;0cb6 67
    ld (hl),l           ;0cb7 75
    ld (hl),d           ;0cb8 72
    ld h,l              ;0cb9 65
    jr nz,$+99          ;0cba 20 61
    ld (hl),e           ;0cbc 73
    jr nz,l0cf0h        ;0cbd 20 31
    jr nz,$+113         ;0cbf 20 6f
    ld (hl),d           ;0cc1 72
    jr nz,$+52          ;0cc2 20 32
    jr nz,$+69          ;0cc4 20 43
    ld d,b              ;0cc6 50
    cpl                 ;0cc7 2f
    ld c,l              ;0cc8 4d
    jr nz,l0d2fh        ;0cc9 20 64
l0ccbh:
    ld (hl),d           ;0ccb 72
    ld l,c              ;0ccc 69
    halt                ;0ccd 76
    ld h,l              ;0cce 65
    ld (hl),e           ;0ccf 73
    jr nz,$+65          ;0cd0 20 3f
    jr nz,$+31          ;0cd2 20 1d
    ld d,a              ;0cd4 57
    ld l,c              ;0cd5 69
    ld l,(hl)           ;0cd6 6e
    ld h,e              ;0cd7 63
    ld l,b              ;0cd8 68
    ld h,l              ;0cd9 65
    ld (hl),e           ;0cda 73
    ld (hl),h           ;0cdb 74
    ld h,l              ;0cdc 65
    ld (hl),d           ;0cdd 72
    jr nz,l0d53h        ;0cde 20 73
    ld l,c              ;0ce0 69
    ld a,d              ;0ce1 7a
    ld h,l              ;0ce2 65
    ld (hl),e           ;0ce3 73
    jr nz,$+117         ;0ce4 20 73
    ld (hl),l           ;0ce6 75
    ld (hl),b           ;0ce7 70
    ld (hl),b           ;0ce8 70
    ld l,a              ;0ce9 6f
    ld (hl),d           ;0cea 72
    ld (hl),h           ;0ceb 74
    ld h,l              ;0cec 65
    ld h,h              ;0ced 64
l0ceeh:
    jr nz,l0d2ah        ;0cee 20 3a
l0cf0h:
    jr nz,l0d0eh        ;0cf0 20 1c
    ld b,c              ;0cf2 41
    ld l,20h            ;0cf3 2e 20
    jr nz,$+34          ;0cf5 20 20
    inc sp              ;0cf7 33
    jr nz,l0d1ah        ;0cf8 20 20
    ld c,l              ;0cfa 4d
    ld h,d              ;0cfb 62
    ld a,c              ;0cfc 79
    ld (hl),h           ;0cfd 74
    ld h,l              ;0cfe 65
    jr nz,$+34          ;0cff 20 20
    jr nz,$+34          ;0d01 20 20
    jr nz,l0d25h        ;0d03 20 20
    jr z,l0d38h         ;0d05 28 31
    add hl,sp           ;0d07 39
    ld sp,6320h         ;0d08 31 20 63
l0d0bh:
    ld a,c              ;0d0b 79
l0d0ch:
    ld l,h              ;0d0c 6c
l0d0dh:
    add hl,hl           ;0d0d 29
l0d0eh:
    inc e               ;0d0e 1c
    ld b,d              ;0d0f 42
    ld l,20h            ;0d10 2e 20
    jr nz,l0d34h        ;0d12 20 20
    ld (hl),20h         ;0d14 36 20
    jr nz,l0d65h        ;0d16 20 4d
    ld h,d              ;0d18 62
    ld a,c              ;0d19 79
l0d1ah:
    ld (hl),h           ;0d1a 74
    ld h,l              ;0d1b 65
    jr nz,$+34          ;0d1c 20 20
    jr nz,$+34          ;0d1e 20 20
    jr nz,l0d42h        ;0d20 20 20
    jr z,l0d55h         ;0d22 28 31
    add hl,sp           ;0d24 39
l0d25h:
    ld sp,6320h         ;0d25 31 20 63
    ld a,c              ;0d28 79
    ld l,h              ;0d29 6c
l0d2ah:
    add hl,hl           ;0d2a 29
l0d2bh:
    inc e               ;0d2b 1c
    ld b,e              ;0d2c 43
    ld l,20h            ;0d2d 2e 20
l0d2fh:
    jr nz,l0d51h        ;0d2f 20 20
    ld sp,l2032h        ;0d31 31 32 20
l0d34h:
    ld c,l              ;0d34 4d
    ld h,d              ;0d35 62
    ld a,c              ;0d36 79
    ld (hl),h           ;0d37 74
l0d38h:
    ld h,l              ;0d38 65
    jr nz,$+34          ;0d39 20 20
    jr nz,$+34          ;0d3b 20 20
    jr nz,$+34          ;0d3d 20 20
    jr z,l0d72h         ;0d3f 28 31
    add hl,sp           ;0d41 39
l0d42h:
    ld sp,6320h         ;0d42 31 20 63
    ld a,c              ;0d45 79
    ld l,h              ;0d46 6c
    add hl,hl           ;0d47 29
l0d48h:
    inc e               ;0d48 1c
    ld b,h              ;0d49 44
    ld l,20h            ;0d4a 2e 20
    jr nz,l0d6eh        ;0d4c 20 20
    dec (hl)            ;0d4e 35
    jr nz,l0d71h        ;0d4f 20 20
l0d51h:
    ld c,l              ;0d51 4d
    ld h,d              ;0d52 62
l0d53h:
    ld a,c              ;0d53 79
    ld (hl),h           ;0d54 74
l0d55h:
    ld h,l              ;0d55 65
    jr nz,$+34          ;0d56 20 20
    jr nz,$+34          ;0d58 20 20
    jr nz,$+34          ;0d5a 20 20
    jr z,$+53           ;0d5c 28 33
    ld (l2030h),a       ;0d5e 32 30 20
    ld h,e              ;0d61 63
    ld a,c              ;0d62 79
    ld l,h              ;0d63 6c
    add hl,hl           ;0d64 29
l0d65h:
    inc e               ;0d65 1c
    ld b,l              ;0d66 45
    ld l,20h            ;0d67 2e 20
    jr nz,l0d8bh        ;0d69 20 20
    ld sp,l2030h        ;0d6b 31 30 20
l0d6eh:
    ld c,l              ;0d6e 4d
    ld h,d              ;0d6f 62
    ld a,c              ;0d70 79
l0d71h:
    ld (hl),h           ;0d71 74
l0d72h:
    ld h,l              ;0d72 65
    jr nz,$+34          ;0d73 20 20
    jr nz,$+34          ;0d75 20 20
    jr nz,$+34          ;0d77 20 20
    jr z,l0daeh         ;0d79 28 33
    ld (l2030h),a       ;0d7b 32 30 20
    ld h,e              ;0d7e 63
    ld a,c              ;0d7f 79
    ld l,h              ;0d80 6c
    add hl,hl           ;0d81 29
l0d82h:
    inc e               ;0d82 1c
    ld b,(hl)           ;0d83 46
    ld l,20h            ;0d84 2e 20
    jr nz,l0da8h        ;0d86 20 20
    ld sp,2035h         ;0d88 31 35 20
l0d8bh:
    ld c,l              ;0d8b 4d
    ld h,d              ;0d8c 62
    ld a,c              ;0d8d 79
    ld (hl),h           ;0d8e 74
    ld h,l              ;0d8f 65
    jr nz,l0db2h        ;0d90 20 20
    jr nz,l0db4h        ;0d92 20 20
    jr nz,l0db6h        ;0d94 20 20
    jr z,l0dcbh         ;0d96 28 33
    ld (l2030h),a       ;0d98 32 30 20
    ld h,e              ;0d9b 63
    ld a,c              ;0d9c 79
    ld l,h              ;0d9d 6c
    add hl,hl           ;0d9e 29
l0d9fh:
    inc hl              ;0d9f 23
    ld e,d              ;0da0 5a
    ld l,20h            ;0da1 2e 20
    jr nz,l0dc5h        ;0da3 20 20
    ld d,l              ;0da5 55
    ld (hl),e           ;0da6 73
    ld h,l              ;0da7 65
l0da8h:
    ld (hl),d           ;0da8 72
    jr nz,l0e1eh        ;0da9 20 73
    ld (hl),l           ;0dab 75
    ld (hl),b           ;0dac 70
    ld (hl),b           ;0dad 70
l0daeh:
    ld l,h              ;0dae 6c
    ld l,c              ;0daf 69
    ld h,l              ;0db0 65
    ld h,h              ;0db1 64
l0db2h:
    jr nz,l0dfch        ;0db2 20 48
l0db4h:
    ld h,l              ;0db4 65
    ld h,c              ;0db5 61
l0db6h:
    ld h,h              ;0db6 64
    jr nz,l0ddfh        ;0db7 20 26
    jr nz,l0dfeh        ;0db9 20 43
    ld a,c              ;0dbb 79
    ld l,h              ;0dbc 6c
    jr nz,l0e22h        ;0dbd 20 63
    ld l,a              ;0dbf 6f
    ld (hl),l           ;0dc0 75
    ld l,(hl)           ;0dc1 6e
    ld (hl),h           ;0dc2 74
l0dc3h:
    ld e,57h            ;0dc3 1e 57
l0dc5h:
    ld l,b              ;0dc5 68
    ld l,c              ;0dc6 69
    ld h,e              ;0dc7 63
    ld l,b              ;0dc8 68
    jr nz,l0e2fh        ;0dc9 20 64
l0dcbh:
    ld (hl),d           ;0dcb 72
    ld l,c              ;0dcc 69
    halt                ;0dcd 76
    ld h,l              ;0dce 65
    jr nz,$+118         ;0dcf 20 74
    ld a,c              ;0dd1 79
    ld (hl),b           ;0dd2 70
    ld h,l              ;0dd3 65
    jr nz,l0dfeh        ;0dd4 20 28
    ld b,c              ;0dd6 41
    dec l               ;0dd7 2d
    ld b,(hl)           ;0dd8 46
    jr nz,l0e4ah        ;0dd9 20 6f
    ld (hl),d           ;0ddb 72
    jr nz,l0e38h        ;0ddc 20 5a
    add hl,hl           ;0dde 29
l0ddfh:
    jr nz,l0e20h        ;0ddf 20 3f
    jr nz,$+30          ;0de1 20 1c
    ld b,l              ;0de3 45
    ld l,(hl)           ;0de4 6e
    ld (hl),h           ;0de5 74
    ld h,l              ;0de6 65
    ld (hl),d           ;0de7 72
    jr nz,l0e5eh        ;0de8 20 74
    ld l,b              ;0dea 68
    ld h,l              ;0deb 65
    jr nz,$+112         ;0dec 20 6e
    ld (hl),l           ;0dee 75
    ld l,l              ;0def 6d
    ld h,d              ;0df0 62
    ld h,l              ;0df1 65
    ld (hl),d           ;0df2 72
    jr nz,l0e64h        ;0df3 20 6f
    ld h,(hl)           ;0df5 66
    jr nz,l0e40h        ;0df6 20 48
    ld h,l              ;0df8 65
    ld h,c              ;0df9 61
    ld h,h              ;0dfa 64
    ld (hl),e           ;0dfb 73
l0dfch:
    jr nz,l0e38h        ;0dfc 20 3a
l0dfeh:
    jr nz,l0e14h        ;0dfe 20 14
    ld c,l              ;0e00 4d
    ld (hl),l           ;0e01 75
    ld (hl),e           ;0e02 73
    ld (hl),h           ;0e03 74
    jr nz,l0e68h        ;0e04 20 62
    ld h,l              ;0e06 65
    jr nz,l0e3bh        ;0e07 20 32
    inc l               ;0e09 2c
    jr nz,l0e40h        ;0e0a 20 34
    inc l               ;0e0c 2c
    jr nz,$+56          ;0e0d 20 36
    jr nz,l0e80h        ;0e0f 20 6f
    ld (hl),d           ;0e11 72
    jr nz,l0e4ch        ;0e12 20 38
l0e14h:
    jr nz,l0e5bh        ;0e14 20 45
    ld l,(hl)           ;0e16 6e
    ld (hl),h           ;0e17 74
    ld h,l              ;0e18 65
    ld (hl),d           ;0e19 72
    jr nz,l0e90h        ;0e1a 20 74
    ld l,b              ;0e1c 68
    ld h,l              ;0e1d 65
l0e1eh:
    jr nz,l0e8eh        ;0e1e 20 6e
l0e20h:
    ld (hl),l           ;0e20 75
    ld l,l              ;0e21 6d
l0e22h:
    ld h,d              ;0e22 62
    ld h,l              ;0e23 65
    ld (hl),d           ;0e24 72
    jr nz,$+113         ;0e25 20 6f
    ld h,(hl)           ;0e27 66
    jr nz,l0e6dh        ;0e28 20 43
    ld a,c              ;0e2a 79
    ld l,h              ;0e2b 6c
    ld l,c              ;0e2c 69
    ld l,(hl)           ;0e2d 6e
    ld h,h              ;0e2e 64
l0e2fh:
    ld h,l              ;0e2f 65
    ld (hl),d           ;0e30 72
    ld (hl),e           ;0e31 73
    jr nz,l0e6eh        ;0e32 20 3a
    jr nz,l0e53h        ;0e34 20 1d
    ld d,l              ;0e36 55
    ld (hl),e           ;0e37 73
l0e38h:
    ld h,l              ;0e38 65
    jr nz,l0eafh        ;0e39 20 74
l0e3bh:
    ld l,b              ;0e3b 68
    ld h,l              ;0e3c 65
    jr nz,$+71          ;0e3d 20 45
    ld c,(hl)           ;0e3f 4e
l0e40h:
    ld d,h              ;0e40 54
    ld c,c              ;0e41 49
    ld d,d              ;0e42 52
    ld b,l              ;0e43 45
    jr nz,l0eaah        ;0e44 20 64
    ld (hl),d           ;0e46 72
    ld l,c              ;0e47 69
    halt                ;0e48 76
    ld h,l              ;0e49 65
l0e4ah:
    jr nz,$+104         ;0e4a 20 66
l0e4ch:
    ld l,a              ;0e4c 6f
    ld (hl),d           ;0e4d 72
    jr nz,l0e93h        ;0e4e 20 43
    ld d,b              ;0e50 50
    cpl                 ;0e51 2f
    ld c,l              ;0e52 4d
l0e53h:
    rra                 ;0e53 1f
    ld l,a              ;0e54 6f
    ld (hl),d           ;0e55 72
    jr nz,l0ec2h        ;0e56 20 6a
    ld (hl),l           ;0e58 75
    ld (hl),e           ;0e59 73
    ld (hl),h           ;0e5a 74
l0e5bh:
    jr nz,l0ed1h        ;0e5b 20 74
    ld l,b              ;0e5d 68
l0e5eh:
    ld h,l              ;0e5e 65
    jr nz,l0ec7h        ;0e5f 20 66
    ld l,c              ;0e61 69
    ld (hl),d           ;0e62 72
    ld (hl),e           ;0e63 73
l0e64h:
    ld (hl),h           ;0e64 74
    jr nz,l0eafh        ;0e65 20 48
    ld b,c              ;0e67 41
l0e68h:
    ld c,h              ;0e68 4c
    ld b,(hl)           ;0e69 46
    jr nz,l0e94h        ;0e6a 20 28
    ld b,l              ;0e6c 45
l0e6dh:
    cpl                 ;0e6d 2f
l0e6eh:
    ld c,b              ;0e6e 48
    add hl,hl           ;0e6f 29
    jr nz,l0eb1h        ;0e70 20 3f
    jr nz,$+29          ;0e72 20 1b
    ld d,b              ;0e74 50
    ld l,b              ;0e75 68
    ld a,c              ;0e76 79
    ld (hl),e           ;0e77 73
    ld l,c              ;0e78 69
    ld h,e              ;0e79 63
    ld h,c              ;0e7a 61
    ld l,h              ;0e7b 6c
    jr nz,l0ef3h        ;0e7c 20 75
    ld l,(hl)           ;0e7e 6e
    ld l,c              ;0e7f 69
l0e80h:
    ld (hl),h           ;0e80 74
    jr nz,l0ea6h        ;0e81 20 23
    jr nz,l0eadh        ;0e83 20 28
    jr nc,$+34          ;0e85 30 20
    ld l,a              ;0e87 6f
    ld (hl),d           ;0e88 72
    jr nz,l0ebch        ;0e89 20 31
    add hl,hl           ;0e8b 29
    jr nz,l0ecdh        ;0e8c 20 3f
l0e8eh:
    jr nz,$+36          ;0e8e 20 22
l0e90h:
    ld d,e              ;0e90 53
    ld (hl),h           ;0e91 74
    ld h,c              ;0e92 61
l0e93h:
    ld (hl),d           ;0e93 72
l0e94h:
    ld (hl),h           ;0e94 74
    jr nz,$+117         ;0e95 20 73
    ld (hl),l           ;0e97 75
    ld (hl),d           ;0e98 72
    ld h,(hl)           ;0e99 66
    ld h,c              ;0e9a 61
    ld h,e              ;0e9b 63
    ld h,l              ;0e9c 65
    jr nz,l0ec2h        ;0e9d 20 23
    daa                 ;0e9f 27
    ld (hl),e           ;0ea0 73
    jr nz,l0f09h        ;0ea1 20 66
    ld (hl),d           ;0ea3 72
    ld l,a              ;0ea4 6f
    ld l,l              ;0ea5 6d
l0ea6h:
    jr nz,$+50          ;0ea6 20 30
    jr nz,$+34          ;0ea8 20 20
l0eaah:
    jr z,l0f05h         ;0eaa 28 59
    cpl                 ;0eac 2f
l0eadh:
    ld c,(hl)           ;0ead 4e
    add hl,hl           ;0eae 29
l0eafh:
    jr nz,l0ef0h        ;0eaf 20 3f
l0eb1h:
    jr nz,$+27          ;0eb1 20 19
    ld c,a              ;0eb3 4f
    ld h,(hl)           ;0eb4 66
    ld h,(hl)           ;0eb5 66
    ld (hl),e           ;0eb6 73
    ld h,l              ;0eb7 65
    ld (hl),h           ;0eb8 74
    jr nz,$+104         ;0eb9 20 66
    ld l,a              ;0ebb 6f
l0ebch:
    ld (hl),d           ;0ebc 72
    jr nz,l0f32h        ;0ebd 20 73
    ld (hl),l           ;0ebf 75
    ld (hl),d           ;0ec0 72
    ld h,(hl)           ;0ec1 66
l0ec2h:
    ld h,c              ;0ec2 61
    ld h,e              ;0ec3 63
    ld h,l              ;0ec4 65
    jr nz,l0eeah        ;0ec5 20 23
l0ec7h:
    daa                 ;0ec7 27
    ld (hl),e           ;0ec8 73
    jr nz,$+65          ;0ec9 20 3f
    jr nz,$+24          ;0ecb 20 16
l0ecdh:
    ld b,h              ;0ecd 44
    ld l,c              ;0ece 69
    ld (hl),e           ;0ecf 73
    ld l,e              ;0ed0 6b
l0ed1h:
    jr nz,l0f17h        ;0ed1 20 44
    ld (hl),d           ;0ed3 72
    ld l,c              ;0ed4 69
    halt                ;0ed5 76
    ld h,l              ;0ed6 65
    jr nz,$+67          ;0ed7 20 41
    ld (hl),e           ;0ed9 73
    ld (hl),e           ;0eda 73
    ld l,c              ;0edb 69
    ld h,a              ;0edc 67
    ld l,(hl)           ;0edd 6e
    ld l,l              ;0ede 6d
    ld h,l              ;0edf 65
    ld l,(hl)           ;0ee0 6e
    ld (hl),h           ;0ee1 74
    ld l,16h            ;0ee2 2e 16
    dec l               ;0ee4 2d
    dec l               ;0ee5 2d
    dec l               ;0ee6 2d
    dec l               ;0ee7 2d
    jr nz,l0f17h        ;0ee8 20 2d
l0eeah:
    dec l               ;0eea 2d
    dec l               ;0eeb 2d
    dec l               ;0eec 2d
    dec l               ;0eed 2d
    jr nz,l0f1dh        ;0eee 20 2d
l0ef0h:
    dec l               ;0ef0 2d
    dec l               ;0ef1 2d
    dec l               ;0ef2 2d
l0ef3h:
    dec l               ;0ef3 2d
    dec l               ;0ef4 2d
    dec l               ;0ef5 2d
    dec l               ;0ef6 2d
    dec l               ;0ef7 2d
    dec l               ;0ef8 2d
    dec l               ;0ef9 2d
l0efah:
    ld (bc),a           ;0efa 02
    inc l               ;0efb 2c
    jr nz,l0f05h        ;0efc 20 07
    ld a,(l2020h)       ;0efe 3a 20 20
    jr nz,$+34          ;0f01 20 20
    jr nz,$+34          ;0f03 20 20
l0f05h:
    inc d               ;0f05 14
    inc sp              ;0f06 33
    jr nc,l0f3dh        ;0f07 30 34
l0f09h:
    jr nc,$+49          ;0f09 30 2f
    inc (hl)            ;0f0b 34
    jr nc,$+54          ;0f0c 30 34
    jr nc,l0f30h        ;0f0e 30 20
    jr nz,l0f56h        ;0f10 20 44
    ld h,l              ;0f12 65
    halt                ;0f13 76
    ld l,c              ;0f14 69
    ld h,e              ;0f15 63
    ld h,l              ;0f16 65
l0f17h:
    jr nz,l0f3ch        ;0f17 20 23
    jr nz,$+22          ;0f19 20 14
    jr c,l0f4dh         ;0f1b 38 30
l0f1dh:
    dec (hl)            ;0f1d 35
    jr nc,l0f40h        ;0f1e 30 20
    jr nz,$+34          ;0f20 20 20
    jr nz,$+34          ;0f22 20 20
    jr nz,l0f46h        ;0f24 20 20
    ld b,h              ;0f26 44
    ld h,l              ;0f27 65
    halt                ;0f28 76
    ld l,c              ;0f29 69
    ld h,e              ;0f2a 63
    ld h,l              ;0f2b 65
    jr nz,l0f51h        ;0f2c 20 23
    jr nz,$+22          ;0f2e 20 14
l0f30h:
    jr c,$+52           ;0f30 38 32
l0f32h:
    dec (hl)            ;0f32 35
    jr nc,l0f55h        ;0f33 30 20
    jr nz,$+34          ;0f35 20 20
    jr nz,$+34          ;0f37 20 20
    jr nz,$+34          ;0f39 20 20
    ld b,h              ;0f3b 44
l0f3ch:
    ld h,l              ;0f3c 65
l0f3dh:
    halt                ;0f3d 76
    ld l,c              ;0f3e 69
    ld h,e              ;0f3f 63
l0f40h:
    ld h,l              ;0f40 65
    jr nz,l0f66h        ;0f41 20 23
    jr nz,l0f4fh        ;0f43 20 0a
    ld c,(hl)           ;0f45 4e
l0f46h:
    ld l,a              ;0f46 6f
    ld (hl),h           ;0f47 74
    jr nz,$+119         ;0f48 20 75
    ld (hl),e           ;0f4a 73
    ld h,l              ;0f4b 65
    ld h,h              ;0f4c 64
l0f4dh:
    jr nz,l0f6fh        ;0f4d 20 20
l0f4fh:
    dec bc              ;0f4f 0b
    ld b,e              ;0f50 43
l0f51h:
    ld l,a              ;0f51 6f
    ld (hl),d           ;0f52 72
    halt                ;0f53 76
    ld (hl),l           ;0f54 75
l0f55h:
    ld (hl),e           ;0f55 73
l0f56h:
    jr nz,l0f78h        ;0f56 20 20
    jr nz,l0f7ah        ;0f58 20 20
    jr nz,$+7           ;0f5a 20 05
    ld sp,4d30h         ;0f5c 31 30 4d
    ld h,d              ;0f5f 62
    jr nz,$+7           ;0f60 20 05
    ld (4d30h),a        ;0f62 32 30 4d
    ld h,d              ;0f65 62
l0f66h:
    jr nz,l0f6dh        ;0f66 20 05
    dec (hl)            ;0f68 35
    ld c,l              ;0f69 4d
    ld h,d              ;0f6a 62
    jr nz,l0f8dh        ;0f6b 20 20
l0f6dh:
    dec b               ;0f6d 05
    dec (hl)            ;0f6e 35
l0f6fh:
    ld c,l              ;0f6f 4d
    ld h,d              ;0f70 62
    ld hl,(l0620h)      ;0f71 2a 20 06
    jr nz,l0f96h        ;0f74 20 20
    jr nz,l0f98h        ;0f76 20 20
l0f78h:
    jr nz,l0f9ah        ;0f78 20 20
l0f7ah:
    add hl,bc           ;0f7a 09
    ld b,h              ;0f7b 44
    ld h,l              ;0f7c 65
    halt                ;0f7d 76
    ld l,c              ;0f7e 69
    ld h,e              ;0f7f 63
    ld h,l              ;0f80 65
    jr nz,$+37          ;0f81 20 23
    jr nz,$+20          ;0f83 20 12
    ld d,a              ;0f85 57
    ld l,c              ;0f86 69
    ld l,(hl)           ;0f87 6e
    ld h,e              ;0f88 63
    ld l,b              ;0f89 68
    ld h,l              ;0f8a 65
    ld (hl),e           ;0f8b 73
    ld (hl),h           ;0f8c 74
l0f8dh:
    ld h,l              ;0f8d 65
    ld (hl),d           ;0f8e 72
    jr nz,l0fe6h        ;0f8f 20 55
    ld l,(hl)           ;0f91 6e
    ld l,c              ;0f92 69
    ld (hl),h           ;0f93 74
    jr nz,l0fb9h        ;0f94 20 23
l0f96h:
    jr nz,l0fa4h        ;0f96 20 0c
l0f98h:
    jr nz,l0fbah        ;0f98 20 20
l0f9ah:
    jr nz,l0fbch        ;0f9a 20 20
    jr nz,l0fbeh        ;0f9c 20 20
    jr nz,l0fc0h        ;0f9e 20 20
    jr nz,l0fc2h        ;0fa0 20 20
    jr nz,l0fcch        ;0fa2 20 28
l0fa4h:
    rlca                ;0fa4 07
    jr nz,l100ah        ;0fa5 20 63
    ld a,c              ;0fa7 79
    ld l,h              ;0fa8 6c
    inc l               ;0fa9 2c
    jr nz,l0fcch        ;0faa 20 20
l0fach:
    dec c               ;0fac 0d
    jr nz,$+79          ;0fad 20 4d
    ld h,d              ;0faf 62
    ld a,c              ;0fb0 79
    ld (hl),h           ;0fb1 74
    ld h,l              ;0fb2 65
    jr nz,l1019h        ;0fb3 20 64
    ld (hl),d           ;0fb5 72
    ld l,c              ;0fb6 69
    halt                ;0fb7 76
    ld h,l              ;0fb8 65
l0fb9h:
    inc l               ;0fb9 2c
l0fbah:
    djnz l0fdch         ;0fba 10 20
l0fbch:
    jr nz,l0fdeh        ;0fbc 20 20
l0fbeh:
    jr nz,$+34          ;0fbe 20 20
l0fc0h:
    jr nz,l0fe2h        ;0fc0 20 20
l0fc2h:
    jr nz,l0fe4h        ;0fc2 20 20
    jr nz,l0fe6h        ;0fc4 20 20
    ld c,b              ;0fc6 48
    ld h,l              ;0fc7 65
    ld h,c              ;0fc8 61
    ld h,h              ;0fc9 64
    jr nz,l0fcdh        ;0fca 20 01
l0fcch:
    dec l               ;0fcc 2d
l0fcdh:
    add hl,bc           ;0fcd 09
    jr nz,l0ff0h        ;0fce 20 20
    ld b,e              ;0fd0 43
    ld a,c              ;0fd1 79
    ld l,h              ;0fd2 6c
    ld (hl),e           ;0fd3 73
    jr nz,l1007h        ;0fd4 20 31
    dec l               ;0fd6 2d
l0fd7h:
    ld b,20h            ;0fd7 06 20
    ld (hl),l           ;0fd9 75
    ld (hl),e           ;0fda 73
    ld h,l              ;0fdb 65
l0fdch:
    ld h,h              ;0fdc 64
    add hl,hl           ;0fdd 29
l0fdeh:
    ld (6c41h),hl       ;0fde 22 41 6c
    ld (hl),h           ;0fe1 74
l0fe2h:
    ld h,l              ;0fe2 65
    ld (hl),d           ;0fe3 72
l0fe4h:
    jr nz,l105dh        ;0fe4 20 77
l0fe6h:
    ld l,b              ;0fe6 68
    ld l,c              ;0fe7 69
    ld h,e              ;0fe8 63
    ld l,b              ;0fe9 68
    jr nz,$+102         ;0fea 20 64
    ld (hl),d           ;0fec 72
    ld l,c              ;0fed 69
    halt                ;0fee 76
    ld h,l              ;0fef 65
l0ff0h:
    jr nz,l1062h        ;0ff0 20 70
    ld h,c              ;0ff2 61
    ld l,c              ;0ff3 69
    ld (hl),d           ;0ff4 72
    jr nz,l101fh        ;0ff5 20 28
    ld b,c              ;0ff7 41
    jr nz,l106eh        ;0ff8 20 74
    ld l,a              ;0ffa 6f
    jr nz,l104ch        ;0ffb 20 4f
    add hl,hl           ;0ffd 29
    jr nz,l103fh        ;0ffe 20 3f
    jr nz,$+36          ;1000 20 22
    ld b,(hl)           ;1002 46
    jr z,l1071h         ;1003 28 6c
    ld l,a              ;1005 6f
    ld (hl),b           ;1006 70
l1007h:
    ld (hl),b           ;1007 70
    ld a,c              ;1008 79
    add hl,hl           ;1009 29
l100ah:
    inc l               ;100a 2c
    jr nz,l102dh        ;100b 20 20
    ld c,b              ;100d 48
    jr z,l1071h         ;100e 28 61
    ld (hl),d           ;1010 72
    ld h,h              ;1011 64
    add hl,hl           ;1012 29
    jr nz,l1084h        ;1013 20 6f
    ld (hl),d           ;1015 72
    jr nz,$+34          ;1016 20 20
    ld d,l              ;1018 55
l1019h:
    jr z,l1089h         ;1019 28 6e
    ld (hl),l           ;101b 75
    ld (hl),e           ;101c 73
    ld h,l              ;101d 65
    ld h,h              ;101e 64
l101fh:
    add hl,hl           ;101f 29
    jr nz,l1042h        ;1020 20 20
    ccf                 ;1022 3f
    jr nz,$+39          ;1023 20 25
    ld d,h              ;1025 54
    ld a,c              ;1026 79
    ld (hl),b           ;1027 70
    ld h,l              ;1028 65
    jr nz,l1053h        ;1029 20 28
    ld b,c              ;102b 41
    dec a               ;102c 3d
l102dh:
    inc sp              ;102d 33
    jr nc,$+54          ;102e 30 34
    jr nc,l1061h        ;1030 30 2f
    inc (hl)            ;1032 34
    jr nc,l1069h        ;1033 30 34
    jr nc,l1063h        ;1035 30 2c
    jr nz,$+68          ;1037 20 42
    dec a               ;1039 3d
    jr c,l106ch         ;103a 38 30
    dec (hl)            ;103c 35
    jr nc,l106bh        ;103d 30 2c
l103fh:
    jr nz,l1084h        ;103f 20 43
    dec a               ;1041 3d
l1042h:
    jr c,l1076h         ;1042 38 32
    dec (hl)            ;1044 35
    jr nc,l1070h        ;1045 30 29
    jr nz,l1088h        ;1047 20 3f
    jr nz,$+29          ;1049 20 1b
    dec (hl)            ;104b 35
l104ch:
    inc l               ;104c 2c
    jr nz,l1080h        ;104d 20 31
    jr nc,l107dh        ;104f 30 2c
    jr nz,l10c2h        ;1051 20 6f
l1053h:
    ld (hl),d           ;1053 72
    jr nz,l1088h        ;1054 20 32
    jr nc,l1078h        ;1056 30 20
    ld c,l              ;1058 4d
    ld h,d              ;1059 62
    ld a,c              ;105a 79
    ld (hl),h           ;105b 74
    ld h,l              ;105c 65
l105dh:
    jr nz,l10c3h        ;105d 20 64
    ld (hl),d           ;105f 72
    ld l,c              ;1060 69
l1061h:
    halt                ;1061 76
l1062h:
    ld h,l              ;1062 65
l1063h:
    jr nz,l10a4h        ;1063 20 3f
    jr nz,l1082h        ;1065 20 1b
    ld c,(hl)           ;1067 4e
    ld l,a              ;1068 6f
l1069h:
    jr nz,$+101         ;1069 20 63
l106bh:
    ld (hl),l           ;106b 75
l106ch:
    ld (hl),d           ;106c 72
    ld (hl),d           ;106d 72
l106eh:
    ld h,l              ;106e 65
    ld l,(hl)           ;106f 6e
l1070h:
    ld (hl),h           ;1070 74
l1071h:
    jr nz,l10d4h        ;1071 20 61
    ld (hl),l           ;1073 75
    ld (hl),h           ;1074 74
    ld l,a              ;1075 6f
l1076h:
    ld l,h              ;1076 6c
    ld l,a              ;1077 6f
l1078h:
    ld h,c              ;1078 61
    ld h,h              ;1079 64
    jr nz,l10dfh        ;107a 20 63
    ld l,a              ;107c 6f
l107dh:
    ld l,l              ;107d 6d
    ld l,l              ;107e 6d
    ld h,c              ;107f 61
l1080h:
    ld l,(hl)           ;1080 6e
    ld h,h              ;1081 64
l1082h:
    ld e,43h            ;1082 1e 43
l1084h:
    ld (hl),l           ;1084 75
    ld (hl),d           ;1085 72
    ld (hl),d           ;1086 72
    ld h,l              ;1087 65
l1088h:
    ld l,(hl)           ;1088 6e
l1089h:
    ld (hl),h           ;1089 74
    jr nz,l10edh        ;108a 20 61
    ld (hl),l           ;108c 75
    ld (hl),h           ;108d 74
    ld l,a              ;108e 6f
    ld l,h              ;108f 6c
    ld l,a              ;1090 6f
    ld h,c              ;1091 61
    ld h,h              ;1092 64
    jr nz,$+101         ;1093 20 63
    ld l,a              ;1095 6f
    ld l,l              ;1096 6d
    ld l,l              ;1097 6d
    ld h,c              ;1098 61
    ld l,(hl)           ;1099 6e
    ld h,h              ;109a 64
    jr nz,$+107         ;109b 20 69
    ld (hl),e           ;109d 73
    jr nz,l10dah        ;109e 20 3a
    jr nz,$+32          ;10a0 20 1e
    ld c,(hl)           ;10a2 4e
    ld h,l              ;10a3 65
l10a4h:
    ld (hl),a           ;10a4 77
    jr nz,l1108h        ;10a5 20 61
    ld (hl),l           ;10a7 75
    ld (hl),h           ;10a8 74
    ld l,a              ;10a9 6f
    ld l,h              ;10aa 6c
    ld l,a              ;10ab 6f
    ld h,c              ;10ac 61
    ld h,h              ;10ad 64
    jr nz,l1113h        ;10ae 20 63
    ld l,a              ;10b0 6f
    ld l,l              ;10b1 6d
    ld l,l              ;10b2 6d
    ld h,c              ;10b3 61
    ld l,(hl)           ;10b4 6e
    ld h,h              ;10b5 64
    jr nz,l10d8h        ;10b6 20 20
    jr z,l1113h         ;10b8 28 59
    cpl                 ;10ba 2f
    ld c,(hl)           ;10bb 4e
    add hl,hl           ;10bc 29
    jr nz,l10feh        ;10bd 20 3f
    jr nz,$+33          ;10bf 20 1f
    ld d,b              ;10c1 50
l10c2h:
    ld l,h              ;10c2 6c
l10c3h:
    ld h,l              ;10c3 65
    ld h,c              ;10c4 61
    ld (hl),e           ;10c5 73
    ld h,l              ;10c6 65
    jr nz,l112eh        ;10c7 20 65
    ld l,(hl)           ;10c9 6e
    ld (hl),h           ;10ca 74
    ld h,l              ;10cb 65
    ld (hl),d           ;10cc 72
    jr nz,l1143h        ;10cd 20 74
    ld l,b              ;10cf 68
    ld h,l              ;10d0 65
    jr nz,l1141h        ;10d1 20 6e
    ld h,l              ;10d3 65
l10d4h:
    ld (hl),a           ;10d4 77
    jr nz,l113ah        ;10d5 20 63
    ld l,a              ;10d7 6f
l10d8h:
    ld l,l              ;10d8 6d
    ld l,l              ;10d9 6d
l10dah:
    ld h,c              ;10da 61
    ld l,(hl)           ;10db 6e
    ld h,h              ;10dc 64
    jr nz,l1119h        ;10dd 20 3a
l10dfh:
    jr nz,$+32          ;10df 20 1e
    ld d,e              ;10e1 53
    ld h,c              ;10e2 61
    halt                ;10e3 76
    ld h,l              ;10e4 65
    jr nz,l1156h        ;10e5 20 6f
    ld l,(hl)           ;10e7 6e
    jr nz,l1161h        ;10e8 20 77
    ld l,b              ;10ea 68
    ld l,c              ;10eb 69
    ld h,e              ;10ec 63
l10edh:
    ld l,b              ;10ed 68
    jr nz,l1154h        ;10ee 20 64
    ld (hl),d           ;10f0 72
    ld l,c              ;10f1 69
    halt                ;10f2 76
    ld h,l              ;10f3 65
    jr nz,l111eh        ;10f4 20 28
    ld b,c              ;10f6 41
    jr nz,l1126h        ;10f7 20 2d
    jr nz,l114bh        ;10f9 20 50
    add hl,hl           ;10fb 29
    jr nz,$+65          ;10fc 20 3f
l10feh:
    jr nz,l1113h        ;10fe 20 13
    ld b,h              ;1100 44
    ld (hl),d           ;1101 72
    ld l,c              ;1102 69
    halt                ;1103 76
    ld h,l              ;1104 65
    jr nz,l1175h        ;1105 20 6e
    ld l,a              ;1107 6f
l1108h:
    ld (hl),h           ;1108 74
    jr nz,l1174h        ;1109 20 69
    ld l,(hl)           ;110b 6e
    jr nz,$+117         ;110c 20 73
    ld a,c              ;110e 79
    ld (hl),e           ;110f 73
    ld (hl),h           ;1110 74
    ld h,l              ;1111 65
    ld l,l              ;1112 6d
l1113h:
    ld c,52h            ;1113 0e 52
    ld h,l              ;1115 65
    ld (hl),h           ;1116 74
    ld (hl),d           ;1117 72
    ld a,c              ;1118 79
l1119h:
    jr nz,l1143h        ;1119 20 28
    ld e,c              ;111b 59
    cpl                 ;111c 2f
    ld c,(hl)           ;111d 4e
l111eh:
    add hl,hl           ;111e 29
    jr nz,l1160h        ;111f 20 3f
    jr nz,l1137h        ;1121 20 14
    ld b,e              ;1123 43
    ld d,b              ;1124 50
    cpl                 ;1125 2f
l1126h:
    ld c,l              ;1126 4d
    jr nz,$+84          ;1127 20 52
    ld h,l              ;1129 65
    ld h,e              ;112a 63
    ld l,a              ;112b 6f
    ld l,(hl)           ;112c 6e
    ld h,(hl)           ;112d 66
l112eh:
    ld l,c              ;112e 69
    ld h,a              ;112f 67
    ld (hl),l           ;1130 75
    ld (hl),d           ;1131 72
    ld h,c              ;1132 61
    ld (hl),h           ;1133 74
    ld l,c              ;1134 69
    ld l,a              ;1135 6f
    ld l,(hl)           ;1136 6e
l1137h:
    inc d               ;1137 14
    dec l               ;1138 2d
    dec l               ;1139 2d
l113ah:
    dec l               ;113a 2d
    dec l               ;113b 2d
    jr nz,l116bh        ;113c 20 2d
    dec l               ;113e 2d
    dec l               ;113f 2d
    dec l               ;1140 2d
l1141h:
    dec l               ;1141 2d
    dec l               ;1142 2d
l1143h:
    dec l               ;1143 2d
    dec l               ;1144 2d
    dec l               ;1145 2d
    dec l               ;1146 2d
    dec l               ;1147 2d
    dec l               ;1148 2d
    dec l               ;1149 2d
    dec l               ;114a 2d
l114bh:
    dec l               ;114b 2d
l114ch:
    rla                 ;114c 17
    ld c,l              ;114d 4d
    ld l,c              ;114e 69
    ld l,(hl)           ;114f 6e
    ld l,c              ;1150 69
    dec l               ;1151 2d
    ld d,a              ;1152 57
    ld l,c              ;1153 69
l1154h:
    ld l,(hl)           ;1154 6e
    ld h,e              ;1155 63
l1156h:
    ld l,b              ;1156 68
    ld h,l              ;1157 65
    ld (hl),e           ;1158 73
    ld (hl),h           ;1159 74
    ld h,l              ;115a 65
    ld (hl),d           ;115b 72
    jr nz,l11d4h        ;115c 20 76
    ld h,l              ;115e 65
    ld (hl),d           ;115f 72
l1160h:
    ld (hl),e           ;1160 73
l1161h:
    ld l,c              ;1161 69
    ld l,a              ;1162 6f
    ld l,(hl)           ;1163 6e
l1164h:
    jr nz,$+84          ;1164 20 52
    ld h,l              ;1166 65
    halt                ;1167 76
    ld l,c              ;1168 69
    ld (hl),e           ;1169 73
    ld l,c              ;116a 69
l116bh:
    ld l,a              ;116b 6f
    ld l,(hl)           ;116c 6e
    jr nz,l11b2h        ;116d 20 43
    ld (322eh),a        ;116f 32 2e 32
    jr nz,l1194h        ;1172 20 20
l1174h:
    dec l               ;1174 2d
l1175h:
    dec l               ;1175 2d
    jr nz,$+34          ;1176 20 20
    jr nz,l11b3h        ;1178 20 39
    jr nz,l11c9h        ;117a 20 4d
    ld h,c              ;117c 61
    ld (hl),d           ;117d 72
    ld h,e              ;117e 63
    ld l,b              ;117f 68
    jr nz,l11b3h        ;1180 20 31
    add hl,sp           ;1182 39
    jr c,l11b9h         ;1183 38 34
l1185h:
    rla                 ;1185 17
    ld d,e              ;1186 53
    ld l,a              ;1187 6f
    ld (hl),l           ;1188 75
    ld (hl),d           ;1189 72
    ld h,e              ;118a 63
    ld h,l              ;118b 65
    jr nz,l11f2h        ;118c 20 64
    ld (hl),d           ;118e 72
    ld l,c              ;118f 69
    halt                ;1190 76
    ld h,l              ;1191 65
    jr nz,l11bch        ;1192 20 28
l1194h:
    ld b,c              ;1194 41
    jr nz,l11c4h        ;1195 20 2d
    jr nz,l11e9h        ;1197 20 50
    add hl,hl           ;1199 29
    jr nz,l11dbh        ;119a 20 3f
    jr nz,l11b2h        ;119c 20 14
    ld b,e              ;119e 43
    ld d,b              ;119f 50
    cpl                 ;11a0 2f
    ld c,l              ;11a1 4d
    jr nz,l11f6h        ;11a2 20 52
    ld h,l              ;11a4 65
    ld h,e              ;11a5 63
    ld l,a              ;11a6 6f
    ld l,(hl)           ;11a7 6e
    ld h,(hl)           ;11a8 66
    ld l,c              ;11a9 69
    ld h,a              ;11aa 67
    ld (hl),l           ;11ab 75
    ld (hl),d           ;11ac 72
    ld h,c              ;11ad 61
    ld (hl),h           ;11ae 74
    ld l,c              ;11af 69
    ld l,a              ;11b0 6f
    ld l,(hl)           ;11b1 6e
l11b2h:
    inc d               ;11b2 14
l11b3h:
    dec l               ;11b3 2d
    dec l               ;11b4 2d
    dec l               ;11b5 2d
    dec l               ;11b6 2d
    jr nz,$+47          ;11b7 20 2d
l11b9h:
    dec l               ;11b9 2d
    dec l               ;11ba 2d
    dec l               ;11bb 2d
l11bch:
    dec l               ;11bc 2d
    dec l               ;11bd 2d
    dec l               ;11be 2d
    dec l               ;11bf 2d
    dec l               ;11c0 2d
    dec l               ;11c1 2d
    dec l               ;11c2 2d
    dec l               ;11c3 2d
l11c4h:
    dec l               ;11c4 2d
    dec l               ;11c5 2d
    dec l               ;11c6 2d
l11c7h:
    inc d               ;11c7 14
    ld b,c              ;11c8 41
l11c9h:
    jr nz,l1208h        ;11c9 20 3d
    jr nz,$+67          ;11cb 20 41
    ld (hl),l           ;11cd 75
    ld (hl),h           ;11ce 74
    ld l,a              ;11cf 6f
    ld l,h              ;11d0 6c
    ld l,a              ;11d1 6f
    ld h,c              ;11d2 61
    ld h,h              ;11d3 64
l11d4h:
    jr nz,l1239h        ;11d4 20 63
    ld l,a              ;11d6 6f
    ld l,l              ;11d7 6d
    ld l,l              ;11d8 6d
    ld h,c              ;11d9 61
    ld l,(hl)           ;11da 6e
l11dbh:
    ld h,h              ;11db 64
l11dch:
    add hl,de           ;11dc 19
    ld b,h              ;11dd 44
    jr nz,l121dh        ;11de 20 3d
    jr nz,l1226h        ;11e0 20 44
    ld l,c              ;11e2 69
    ld (hl),e           ;11e3 73
    ld l,e              ;11e4 6b
    jr nz,l122bh        ;11e5 20 44
    ld (hl),d           ;11e7 72
    ld l,c              ;11e8 69
l11e9h:
    halt                ;11e9 76
    ld h,l              ;11ea 65
    jr nz,$+67          ;11eb 20 41
    ld (hl),e           ;11ed 73
    ld (hl),e           ;11ee 73
    ld l,c              ;11ef 69
    ld h,a              ;11f0 67
    ld l,(hl)           ;11f1 6e
l11f2h:
    ld l,l              ;11f2 6d
    ld h,l              ;11f3 65
    ld l,(hl)           ;11f4 6e
    ld (hl),h           ;11f5 74
l11f6h:
    ld (de),a           ;11f6 12
    ld c,c              ;11f7 49
    jr nz,l1237h        ;11f8 20 3d
    jr nz,l1245h        ;11fa 20 49
    cpl                 ;11fc 2f
    ld c,a              ;11fd 4f
    jr nz,l1241h        ;11fe 20 41
    ld (hl),e           ;1200 73
    ld (hl),e           ;1201 73
    ld l,c              ;1202 69
    ld h,a              ;1203 67
    ld l,(hl)           ;1204 6e
    ld l,l              ;1205 6d
    ld h,l              ;1206 65
    ld l,(hl)           ;1207 6e
l1208h:
    ld (hl),h           ;1208 74
l1209h:
    dec de              ;1209 1b
    ld d,b              ;120a 50
    jr nz,l124ah        ;120b 20 3d
    jr nz,l125fh        ;120d 20 50
    ld h,l              ;120f 65
    ld (hl),h           ;1210 74
    jr nz,l1267h        ;1211 20 54
    ld h,l              ;1213 65
    ld (hl),d           ;1214 72
    ld l,l              ;1215 6d
    ld l,c              ;1216 69
    ld l,(hl)           ;1217 6e
    ld h,c              ;1218 61
    ld l,h              ;1219 6c
    jr nz,l126ch        ;121a 20 50
    ld h,c              ;121c 61
l121dh:
    ld (hl),d           ;121d 72
    ld h,c              ;121e 61
    ld l,l              ;121f 6d
    ld h,l              ;1220 65
    ld (hl),h           ;1221 74
    ld h,l              ;1222 65
    ld (hl),d           ;1223 72
    ld (hl),e           ;1224 73
l1225h:
    add hl,de           ;1225 19
l1226h:
    ld d,d              ;1226 52
    jr nz,l1266h        ;1227 20 3d
    jr nz,l127dh        ;1229 20 52
l122bh:
    ld d,e              ;122b 53
    ld (3233h),a        ;122c 32 33 32
    jr nz,$+69          ;122f 20 43
    ld l,b              ;1231 68
    ld h,c              ;1232 61
    ld (hl),d           ;1233 72
    ld h,c              ;1234 61
    ld h,e              ;1235 63
    ld (hl),h           ;1236 74
l1237h:
    ld h,l              ;1237 65
    ld (hl),d           ;1238 72
l1239h:
    ld l,c              ;1239 69
    ld (hl),e           ;123a 73
    ld (hl),h           ;123b 74
    ld l,c              ;123c 69
    ld h,e              ;123d 63
    ld (hl),e           ;123e 73
l123fh:
    inc de              ;123f 13
    ld d,e              ;1240 53
l1241h:
    jr nz,l1280h        ;1241 20 3d
    jr nz,l1298h        ;1243 20 53
l1245h:
    ld h,c              ;1245 61
    halt                ;1246 76
    ld h,l              ;1247 65
    jr nz,l1298h        ;1248 20 4e
l124ah:
    ld h,l              ;124a 65
    ld (hl),a           ;124b 77
    jr nz,l12a1h        ;124c 20 53
    ld a,c              ;124e 79
    ld (hl),e           ;124f 73
    ld (hl),h           ;1250 74
    ld h,l              ;1251 65
    ld l,l              ;1252 6d
l1253h:
    ld d,45h            ;1253 16 45
    jr nz,l1294h        ;1255 20 3d
    jr nz,$+71          ;1257 20 45
    ld a,b              ;1259 78
    ld h,l              ;125a 65
    ld h,e              ;125b 63
    ld (hl),l           ;125c 75
    ld (hl),h           ;125d 74
    ld h,l              ;125e 65
l125fh:
    jr nz,l12afh        ;125f 20 4e
    ld h,l              ;1261 65
    ld (hl),a           ;1262 77
    jr nz,l12b8h        ;1263 20 53
    ld a,c              ;1265 79
l1266h:
    ld (hl),e           ;1266 73
l1267h:
    ld (hl),h           ;1267 74
    ld h,l              ;1268 65
    ld l,l              ;1269 6d
l126ah:
    dec d               ;126a 15
    ld d,c              ;126b 51
l126ch:
    jr nz,$+63          ;126c 20 3d
    jr nz,$+83          ;126e 20 51
    ld (hl),l           ;1270 75
    ld l,c              ;1271 69
    ld (hl),h           ;1272 74
    jr nz,$+86          ;1273 20 54
    ld l,b              ;1275 68
    ld l,c              ;1276 69
    ld (hl),e           ;1277 73
    jr nz,l12cah        ;1278 20 50
    ld (hl),d           ;127a 72
    ld l,a              ;127b 6f
    ld h,a              ;127c 67
l127dh:
    ld (hl),d           ;127d 72
    ld h,c              ;127e 61
    ld l,l              ;127f 6d
l1280h:
    dec h               ;1280 25
    ld d,b              ;1281 50
    ld l,h              ;1282 6c
    ld h,l              ;1283 65
    ld h,c              ;1284 61
    ld (hl),e           ;1285 73
    ld h,l              ;1286 65
    jr nz,$+103         ;1287 20 65
    ld l,(hl)           ;1289 6e
    ld (hl),h           ;128a 74
    ld h,l              ;128b 65
    ld (hl),d           ;128c 72
    jr nz,$+118         ;128d 20 74
    ld l,b              ;128f 68
    ld h,l              ;1290 65
    jr nz,$+99          ;1291 20 61
    ld (hl),b           ;1293 70
l1294h:
    ld (hl),b           ;1294 70
    ld (hl),d           ;1295 72
    ld l,a              ;1296 6f
    ld (hl),b           ;1297 70
l1298h:
    ld (hl),d           ;1298 72
    ld l,c              ;1299 69
    ld h,c              ;129a 61
    ld (hl),h           ;129b 74
    ld h,l              ;129c 65
    jr nz,$+110         ;129d 20 6c
    ld h,l              ;129f 65
    ld (hl),h           ;12a0 74
l12a1h:
    ld (hl),h           ;12a1 74
    ld h,l              ;12a2 65
    ld (hl),d           ;12a3 72
    ld a,(0c320h)       ;12a4 3a 20 c3
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
    ld bc,l1bfdh+1      ;13f4 01 fe 1b
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
    ld bc,l1cf1h+1      ;156a 01 f2 1c
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
    ld hl,l1ec5h+1      ;1726 21 c6 1e
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
    ld bc,l1efah+1      ;1766 01 fb 1e
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
    ld hl,l1f46h+1      ;17a0 21 47 1f
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
    ld bc,l1fafh+1      ;18c3 01 b0 1f
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
    ld hl,l206ah+1      ;1a7c 21 6b 20
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
    rra                 ;1b70 1f
    ld c,(hl)           ;1b71 4e
    ld h,l              ;1b72 65
    ld (hl),a           ;1b73 77
    jr nz,$+101         ;1b74 20 63
    ld l,b              ;1b76 68
    ld h,c              ;1b77 61
    ld (hl),d           ;1b78 72
    ld h,c              ;1b79 61
    ld (hl),h           ;1b7a 74
    ld h,l              ;1b7b 65
    ld (hl),d           ;1b7c 72
    jr nz,l1bebh        ;1b7d 20 6c
    ld h,l              ;1b7f 65
    ld l,(hl)           ;1b80 6e
    ld h,a              ;1b81 67
    ld (hl),h           ;1b82 74
    ld l,b              ;1b83 68
    jr nz,$+42          ;1b84 20 28
    dec (hl)            ;1b86 35
    jr nz,l1bfdh        ;1b87 20 74
    ld l,a              ;1b89 6f
    jr nz,l1bc4h        ;1b8a 20 38
    add hl,hl           ;1b8c 29
    jr nz,l1bceh        ;1b8d 20 3f
    jr nz,$+33          ;1b8f 20 1f
    ld c,(hl)           ;1b91 4e
    ld (hl),l           ;1b92 75
    ld l,l              ;1b93 6d
    ld h,d              ;1b94 62
    ld h,l              ;1b95 65
    ld (hl),d           ;1b96 72
    jr nz,l1c08h        ;1b97 20 6f
    ld h,(hl)           ;1b99 66
    jr nz,l1c0fh        ;1b9a 20 73
    ld (hl),h           ;1b9c 74
    ld l,a              ;1b9d 6f
    ld (hl),b           ;1b9e 70
    jr nz,$+100         ;1b9f 20 62
    ld l,c              ;1ba1 69
    ld (hl),h           ;1ba2 74
    ld (hl),e           ;1ba3 73
    jr nz,l1bceh        ;1ba4 20 28
    ld sp,6f20h         ;1ba6 31 20 6f
    ld (hl),d           ;1ba9 72
    jr nz,$+52          ;1baa 20 32
    add hl,hl           ;1bac 29
    jr nz,$+65          ;1bad 20 3f
    jr nz,$+34          ;1baf 20 20
    ld c,a              ;1bb1 4f
    jr z,l1c18h         ;1bb2 28 64
    ld h,h              ;1bb4 64
    add hl,hl           ;1bb5 29
    inc l               ;1bb6 2c
    jr nz,$+71          ;1bb7 20 45
    jr z,l1c31h         ;1bb9 28 76
    ld h,l              ;1bbb 65
    ld l,(hl)           ;1bbc 6e
    add hl,hl           ;1bbd 29
    inc l               ;1bbe 2c
    jr nz,$+113         ;1bbf 20 6f
    ld (hl),d           ;1bc1 72
    jr nz,l1c12h        ;1bc2 20 4e
l1bc4h:
    jr z,l1c35h         ;1bc4 28 6f
    add hl,hl           ;1bc6 29
    jr nz,l1c39h        ;1bc7 20 70
    ld h,c              ;1bc9 61
    ld (hl),d           ;1bca 72
    ld l,c              ;1bcb 69
    ld (hl),h           ;1bcc 74
    ld a,c              ;1bcd 79
l1bceh:
    jr nz,l1c0fh        ;1bce 20 3f
    jr nz,$+46          ;1bd0 20 2c
    ld sp,l3031h        ;1bd2 31 31 30
    inc l               ;1bd5 2c
    jr nz,l1c0bh        ;1bd6 20 33
    jr nc,l1c0ah        ;1bd8 30 30
    inc l               ;1bda 2c
    jr nz,l1c0eh        ;1bdb 20 31
    ld (l3030h),a       ;1bdd 32 30 30
    inc l               ;1be0 2c
    jr nz,l1c17h        ;1be1 20 34
    jr c,$+50           ;1be3 38 30
    jr nc,l1c13h        ;1be5 30 2c
    jr nz,l1c22h        ;1be7 20 39
    ld (hl),30h         ;1be9 36 30
l1bebh:
    jr nc,l1c19h        ;1beb 30 2c
    jr nz,$+113         ;1bed 20 6f
    ld (hl),d           ;1bef 72
    jr nz,l1c23h        ;1bf0 20 31
    add hl,sp           ;1bf2 39
    ld (l3030h),a       ;1bf3 32 30 30
    jr nz,l1c5ah        ;1bf6 20 62
    ld h,c              ;1bf8 61
    ld (hl),l           ;1bf9 75
    ld h,h              ;1bfa 64
    jr nz,$+65          ;1bfb 20 3f
l1bfdh:
    jr nz,$+24          ;1bfd 20 16
    ld d,d              ;1bff 52
l1c00h:
    ld d,e              ;1c00 53
    ld (3233h),a        ;1c01 32 33 32
    jr nz,l1c49h        ;1c04 20 43
    ld l,b              ;1c06 68
    ld h,c              ;1c07 61
l1c08h:
    ld (hl),d           ;1c08 72
    ld h,c              ;1c09 61
l1c0ah:
    ld h,e              ;1c0a 63
l1c0bh:
    ld (hl),h           ;1c0b 74
    ld h,l              ;1c0c 65
    ld (hl),d           ;1c0d 72
l1c0eh:
    ld l,c              ;1c0e 69
l1c0fh:
    ld (hl),e           ;1c0f 73
    ld (hl),h           ;1c10 74
    ld l,c              ;1c11 69
l1c12h:
    ld h,e              ;1c12 63
l1c13h:
    ld (hl),e           ;1c13 73
    ld l,16h            ;1c14 2e 16
    dec l               ;1c16 2d
l1c17h:
    dec l               ;1c17 2d
l1c18h:
    dec l               ;1c18 2d
l1c19h:
    dec l               ;1c19 2d
    dec l               ;1c1a 2d
    jr nz,$+47          ;1c1b 20 2d
    dec l               ;1c1d 2d
    dec l               ;1c1e 2d
    dec l               ;1c1f 2d
    dec l               ;1c20 2d
    dec l               ;1c21 2d
l1c22h:
    dec l               ;1c22 2d
l1c23h:
    dec l               ;1c23 2d
    dec l               ;1c24 2d
    dec l               ;1c25 2d
    dec l               ;1c26 2d
    dec l               ;1c27 2d
    dec l               ;1c28 2d
    dec l               ;1c29 2d
    dec l               ;1c2a 2d
    dec l               ;1c2b 2d
l1c2ch:
    rla                 ;1c2c 17
    jr nz,l1c60h        ;1c2d 20 31
    ld l,20h            ;1c2f 2e 20
l1c31h:
    jr nz,$+69          ;1c31 20 43
    ld l,b              ;1c33 68
    ld h,c              ;1c34 61
l1c35h:
    ld (hl),d           ;1c35 72
    ld h,c              ;1c36 61
    ld h,e              ;1c37 63
    ld (hl),h           ;1c38 74
l1c39h:
    ld h,l              ;1c39 65
    ld (hl),d           ;1c3a 72
    jr nz,l1cb0h        ;1c3b 20 73
    ld l,c              ;1c3d 69
    ld a,d              ;1c3e 7a
    ld h,l              ;1c3f 65
    jr nz,l1c7ch        ;1c40 20 3a
    add hl,bc           ;1c42 09
    add hl,bc           ;1c43 09
l1c44h:
    dec de              ;1c44 1b
    jr nz,l1c79h        ;1c45 20 32
    ld l,20h            ;1c47 2e 20
l1c49h:
    jr nz,$+80          ;1c49 20 4e
    ld (hl),l           ;1c4b 75
    ld l,l              ;1c4c 6d
    ld h,d              ;1c4d 62
    ld h,l              ;1c4e 65
    ld (hl),d           ;1c4f 72
    jr nz,$+113         ;1c50 20 6f
    ld h,(hl)           ;1c52 66
    jr nz,l1cc8h        ;1c53 20 73
    ld (hl),h           ;1c55 74
    ld l,a              ;1c56 6f
    ld (hl),b           ;1c57 70
    jr nz,l1cbch        ;1c58 20 62
l1c5ah:
    ld l,c              ;1c5a 69
    ld (hl),h           ;1c5b 74
    ld (hl),e           ;1c5c 73
    jr nz,$+60          ;1c5d 20 3a
    add hl,bc           ;1c5f 09
l1c60h:
    ld bc,0331h         ;1c60 01 31 03
    ld sp,352eh         ;1c63 31 2e 35
l1c66h:
    ld bc,0932h         ;1c66 01 32 09
    ld (hl),l           ;1c69 75
    ld l,(hl)           ;1c6a 6e
    ld h,h              ;1c6b 64
    ld h,l              ;1c6c 65
    ld h,(hl)           ;1c6d 66
    ld l,c              ;1c6e 69
    ld l,(hl)           ;1c6f 6e
    ld h,l              ;1c70 65
    ld h,h              ;1c71 64
l1c72h:
    djnz $+34           ;1c72 10 20
    inc sp              ;1c74 33
    ld l,20h            ;1c75 2e 20
    jr nz,l1cc9h        ;1c77 20 50
l1c79h:
    ld h,c              ;1c79 61
    ld (hl),d           ;1c7a 72
    ld l,c              ;1c7b 69
l1c7ch:
    ld (hl),h           ;1c7c 74
    ld a,c              ;1c7d 79
    jr nz,l1cbah        ;1c7e 20 3a
    add hl,bc           ;1c80 09
    add hl,bc           ;1c81 09
    add hl,bc           ;1c82 09
l1c83h:
    inc b               ;1c83 04
    ld l,(hl)           ;1c84 6e
    ld l,a              ;1c85 6f
    ld l,(hl)           ;1c86 6e
    ld h,l              ;1c87 65
l1c88h:
    inc b               ;1c88 04
    ld h,l              ;1c89 65
    halt                ;1c8a 76
    ld h,l              ;1c8b 65
    ld l,(hl)           ;1c8c 6e
l1c8dh:
    inc b               ;1c8d 04
    ld l,a              ;1c8e 6f
    ld h,h              ;1c8f 64
    ld h,h              ;1c90 64
    jr nz,l1c97h        ;1c91 20 04
    jr nz,$+34          ;1c93 20 20
    jr nz,l1cb7h        ;1c95 20 20
l1c97h:
    ld (de),a           ;1c97 12
    jr nz,l1cceh        ;1c98 20 34
    ld l,20h            ;1c9a 2e 20
    jr nz,l1ce0h        ;1c9c 20 42
    ld h,c              ;1c9e 61
    ld (hl),l           ;1c9f 75
    ld h,h              ;1ca0 64
    jr nz,l1d15h        ;1ca1 20 72
    ld h,c              ;1ca3 61
    ld (hl),h           ;1ca4 74
    ld h,l              ;1ca5 65
    jr nz,l1ce2h        ;1ca6 20 3a
    add hl,bc           ;1ca8 09
    add hl,bc           ;1ca9 09
l1caah:
    dec b               ;1caa 05
    ld sp,l3031h        ;1cab 31 31 30
    jr nz,$+34          ;1cae 20 20
l1cb0h:
    dec b               ;1cb0 05
    inc sp              ;1cb1 33
    jr nc,l1ce4h        ;1cb2 30 30
    jr nz,l1cd6h        ;1cb4 20 20
l1cb6h:
    dec b               ;1cb6 05
l1cb7h:
    ld sp,l3032h        ;1cb7 31 32 30
l1cbah:
    jr nc,l1cdch        ;1cba 30 20
l1cbch:
    dec b               ;1cbc 05
    inc (hl)            ;1cbd 34
    jr c,$+50           ;1cbe 38 30
    jr nc,l1ce2h        ;1cc0 30 20
l1cc2h:
    dec b               ;1cc2 05
    add hl,sp           ;1cc3 39
    ld (hl),30h         ;1cc4 36 30
    jr nc,l1ce8h        ;1cc6 30 20
l1cc8h:
    dec b               ;1cc8 05
l1cc9h:
    ld sp,3239h         ;1cc9 31 39 32
    jr nc,l1cfeh        ;1ccc 30 30
l1cceh:
    dec b               ;1cce 05
    jr nz,l1cf1h        ;1ccf 20 20
    jr nz,l1cf3h        ;1cd1 20 20
    jr nz,$+31          ;1cd3 20 1d
    ld b,c              ;1cd5 41
l1cd6h:
    ld l,h              ;1cd6 6c
    ld (hl),h           ;1cd7 74
    ld h,l              ;1cd8 65
    ld (hl),d           ;1cd9 72
    jr nz,l1d53h        ;1cda 20 77
l1cdch:
    ld l,b              ;1cdc 68
    ld l,c              ;1cdd 69
    ld h,e              ;1cde 63
    ld l,b              ;1cdf 68
l1ce0h:
    jr nz,l1d45h        ;1ce0 20 63
l1ce2h:
    ld l,b              ;1ce2 68
    ld h,c              ;1ce3 61
l1ce4h:
    ld (hl),d           ;1ce4 72
    ld h,c              ;1ce5 61
    ld h,e              ;1ce6 63
    ld (hl),h           ;1ce7 74
l1ce8h:
    ld h,l              ;1ce8 65
    ld (hl),d           ;1ce9 72
    ld l,c              ;1cea 69
    ld (hl),e           ;1ceb 73
    ld (hl),h           ;1cec 74
    ld l,c              ;1ced 69
    ld h,e              ;1cee 63
    jr nz,$+65          ;1cef 20 3f
l1cf1h:
    jr nz,l1d09h        ;1cf1 20 16
l1cf3h:
    ld d,h              ;1cf3 54
    jr z,l1d4ah         ;1cf4 28 54
    ld e,c              ;1cf6 59
    ld a,(l2d20h)       ;1cf7 3a 20 2d
    dec l               ;1cfa 2d
    jr nz,l1d4fh        ;1cfb 20 52
    ld d,e              ;1cfd 53
l1cfeh:
    ld (3233h),a        ;1cfe 32 33 32
    jr nz,l1d73h        ;1d01 20 70
    ld (hl),d           ;1d03 72
    ld l,c              ;1d04 69
    ld l,(hl)           ;1d05 6e
    ld (hl),h           ;1d06 74
    ld h,l              ;1d07 65
    ld (hl),d           ;1d08 72
l1d09h:
    inc de              ;1d09 13
    ld b,e              ;1d0a 43
    jr z,$+84           ;1d0b 28 52
    ld d,h              ;1d0d 54
    ld a,(l2d20h)       ;1d0e 3a 20 2d
    dec l               ;1d11 2d
    jr nz,l1d64h        ;1d12 20 50
    ld b,l              ;1d14 45
l1d15h:
    ld d,h              ;1d15 54
    jr nz,$+117         ;1d16 20 73
    ld h,e              ;1d18 63
    ld (hl),d           ;1d19 72
    ld h,l              ;1d1a 65
    ld h,l              ;1d1b 65
    ld l,(hl)           ;1d1c 6e
l1d1dh:
    add hl,de           ;1d1d 19
    ld c,h              ;1d1e 4c
    jr z,l1d71h         ;1d1f 28 50
    ld d,h              ;1d21 54
    ld a,(l2d20h)       ;1d22 3a 20 2d
    dec l               ;1d25 2d
    jr nz,l1d78h        ;1d26 20 50
    ld b,l              ;1d28 45
    ld d,h              ;1d29 54
    jr nz,$+75          ;1d2a 20 49
    ld b,l              ;1d2c 45
    ld b,l              ;1d2d 45
    ld b,l              ;1d2e 45
    jr nz,l1da1h        ;1d2f 20 70
    ld (hl),d           ;1d31 72
    ld l,c              ;1d32 69
    ld l,(hl)           ;1d33 6e
    ld (hl),h           ;1d34 74
    ld h,l              ;1d35 65
    ld (hl),d           ;1d36 72
l1d37h:
    dec de              ;1d37 1b
    ld d,l              ;1d38 55
    jr z,$+78           ;1d39 28 4c
    ld sp,l203ah        ;1d3b 31 3a 20
    dec l               ;1d3e 2d
    dec l               ;1d3f 2d
    jr nz,l1d83h        ;1d40 20 41
    ld d,e              ;1d42 53
    ld b,e              ;1d43 43
    ld c,c              ;1d44 49
l1d45h:
    ld c,c              ;1d45 49
    jr nz,$+75          ;1d46 20 49
    ld b,l              ;1d48 45
    ld b,l              ;1d49 45
l1d4ah:
    ld b,l              ;1d4a 45
    jr nz,l1dbdh        ;1d4b 20 70
    ld (hl),d           ;1d4d 72
    ld l,c              ;1d4e 69
l1d4fh:
    ld l,(hl)           ;1d4f 6e
    ld (hl),h           ;1d50 74
    ld h,l              ;1d51 65
    ld (hl),d           ;1d52 72
l1d53h:
    inc hl              ;1d53 23
    ld d,a              ;1d54 57
    ld l,b              ;1d55 68
    ld l,c              ;1d56 69
    ld h,e              ;1d57 63
    ld l,b              ;1d58 68
    jr nz,$+110         ;1d59 20 6c
    ld l,c              ;1d5b 69
    ld (hl),e           ;1d5c 73
    ld (hl),h           ;1d5d 74
    jr nz,l1dc4h        ;1d5e 20 64
    ld h,l              ;1d60 65
    halt                ;1d61 76
    ld l,c              ;1d62 69
    ld h,e              ;1d63 63
l1d64h:
    ld h,l              ;1d64 65
    jr nz,l1d8fh        ;1d65 20 28
    ld d,h              ;1d67 54
    inc l               ;1d68 2c
    jr nz,$+69          ;1d69 20 43
    inc l               ;1d6b 2c
    jr nz,l1dbah        ;1d6c 20 4c
    jr nz,l1ddfh        ;1d6e 20 6f
    ld (hl),d           ;1d70 72
l1d71h:
    jr nz,l1dc8h        ;1d71 20 55
l1d73h:
    add hl,hl           ;1d73 29
    jr nz,l1db5h        ;1d74 20 3f
    jr nz,$+21          ;1d76 20 13
l1d78h:
    ld d,h              ;1d78 54
    jr z,l1dcfh         ;1d79 28 54
    ld e,c              ;1d7b 59
    ld a,(l2029h)       ;1d7c 3a 29 20
    ld l,a              ;1d7f 6f
    ld (hl),d           ;1d80 72
    jr nz,l1dd3h        ;1d81 20 50
l1d83h:
    jr z,l1dd9h         ;1d83 28 54
    ld d,d              ;1d85 52
    ld a,(l2029h)       ;1d86 3a 29 20
    ccf                 ;1d89 3f
    jr nz,$+21          ;1d8a 20 13
    ld d,h              ;1d8c 54
    jr z,l1de3h         ;1d8d 28 54
l1d8fh:
    ld e,c              ;1d8f 59
    ld a,(l2029h)       ;1d90 3a 29 20
    ld l,a              ;1d93 6f
    ld (hl),d           ;1d94 72
    jr nz,l1de7h        ;1d95 20 50
    jr z,l1dedh         ;1d97 28 54
    ld d,b              ;1d99 50
    ld a,(l2029h)       ;1d9a 3a 29 20
    ccf                 ;1d9d 3f
    jr nz,l1dc0h        ;1d9e 20 20
    inc sp              ;1da0 33
l1da1h:
    jr nz,l1de0h        ;1da1 20 3d
    jr nz,$+53          ;1da3 20 33
    jr nc,l1dd9h        ;1da5 30 32
    ld (6f20h),a        ;1da7 32 20 6f
    ld (hl),d           ;1daa 72
    jr nz,l1de0h        ;1dab 20 33
    jr nc,l1de1h        ;1dad 30 32
    inc sp              ;1daf 33
    jr nz,l1e21h        ;1db0 20 6f
    ld (hl),d           ;1db2 72
    jr nz,l1de9h        ;1db3 20 34
l1db5h:
    jr nc,l1de9h        ;1db5 30 32
    ld (6f20h),a        ;1db7 32 20 6f
l1dbah:
    ld (hl),d           ;1dba 72
    jr nz,l1df1h        ;1dbb 20 34
l1dbdh:
    jr nc,l1df1h        ;1dbd 30 32
    inc sp              ;1dbf 33
l1dc0h:
    ex af,af'           ;1dc0 08
    jr c,l1de3h         ;1dc1 38 20
    dec a               ;1dc3 3d
l1dc4h:
    jr nz,$+58          ;1dc4 20 38
    jr nc,l1dfah        ;1dc6 30 32
l1dc8h:
    inc (hl)            ;1dc8 34
l1dc9h:
    dec e               ;1dc9 1d
    ld b,h              ;1dca 44
    jr nz,l1e0ah        ;1dcb 20 3d
    jr nz,l1e07h        ;1dcd 20 38
l1dcfh:
    jr nc,l1e03h        ;1dcf 30 32
    ld (hl),20h         ;1dd1 36 20
l1dd3h:
    ld l,a              ;1dd3 6f
    ld (hl),d           ;1dd4 72
    jr nz,l1e0fh        ;1dd5 20 38
    jr nc,$+52          ;1dd7 30 32
l1dd9h:
    scf                 ;1dd9 37
    jr nz,l1e04h        ;1dda 20 28
    ld b,h              ;1ddc 44
    ld h,c              ;1ddd 61
    ld l,c              ;1dde 69
l1ddfh:
    ld (hl),e           ;1ddf 73
l1de0h:
    ld a,c              ;1de0 79
l1de1h:
    ld (hl),a           ;1de1 77
    ld l,b              ;1de2 68
l1de3h:
    ld h,l              ;1de3 65
    ld h,l              ;1de4 65
    ld l,h              ;1de5 6c
    add hl,hl           ;1de6 29
l1de7h:
    dec h               ;1de7 25
    ld d,a              ;1de8 57
l1de9h:
    ld l,b              ;1de9 68
    ld l,c              ;1dea 69
    ld h,e              ;1deb 63
    ld l,b              ;1dec 68
l1dedh:
    jr nz,l1e63h        ;1ded 20 74
    ld a,c              ;1def 79
    ld (hl),b           ;1df0 70
l1df1h:
    ld h,l              ;1df1 65
    jr nz,l1e63h        ;1df2 20 6f
    ld h,(hl)           ;1df4 66
    jr nz,l1e67h        ;1df5 20 70
    ld (hl),d           ;1df7 72
    ld l,c              ;1df8 69
    ld l,(hl)           ;1df9 6e
l1dfah:
    ld (hl),h           ;1dfa 74
    ld h,l              ;1dfb 65
    ld (hl),d           ;1dfc 72
    jr nz,l1e27h        ;1dfd 20 28
    inc sp              ;1dff 33
    inc l               ;1e00 2c
    jr nz,l1e3bh        ;1e01 20 38
l1e03h:
    inc l               ;1e03 2c
l1e04h:
    jr nz,$+113         ;1e04 20 6f
    ld (hl),d           ;1e06 72
l1e07h:
    jr nz,$+70          ;1e07 20 44
    add hl,hl           ;1e09 29
l1e0ah:
    jr nz,l1e4bh        ;1e0a 20 3f
    jr nz,$+24          ;1e0c 20 16
    ld c,c              ;1e0e 49
l1e0fh:
    cpl                 ;1e0f 2f
    ld c,a              ;1e10 4f
    jr nz,l1e57h        ;1e11 20 44
    ld h,l              ;1e13 65
    halt                ;1e14 76
    ld l,c              ;1e15 69
    ld h,e              ;1e16 63
    ld h,l              ;1e17 65
    jr nz,l1e5bh        ;1e18 20 41
    ld (hl),e           ;1e1a 73
    ld (hl),e           ;1e1b 73
    ld l,c              ;1e1c 69
    ld h,a              ;1e1d 67
    ld l,(hl)           ;1e1e 6e
    ld l,l              ;1e1f 6d
    ld h,l              ;1e20 65
l1e21h:
    ld l,(hl)           ;1e21 6e
    ld (hl),h           ;1e22 74
    ld l,16h            ;1e23 2e 16
    dec l               ;1e25 2d
    dec l               ;1e26 2d
l1e27h:
    dec l               ;1e27 2d
    jr nz,l1e57h        ;1e28 20 2d
    dec l               ;1e2a 2d
    dec l               ;1e2b 2d
    dec l               ;1e2c 2d
    dec l               ;1e2d 2d
    dec l               ;1e2e 2d
    jr nz,$+47          ;1e2f 20 2d
    dec l               ;1e31 2d
    dec l               ;1e32 2d
    dec l               ;1e33 2d
    dec l               ;1e34 2d
    dec l               ;1e35 2d
    dec l               ;1e36 2d
    dec l               ;1e37 2d
    dec l               ;1e38 2d
    dec l               ;1e39 2d
    dec l               ;1e3a 2d
l1e3bh:
    inc e               ;1e3b 1c
    jr nz,l1e6fh        ;1e3c 20 31
    ld l,20h            ;1e3e 2e 20
    jr nz,l1e92h        ;1e40 20 50
    ld b,l              ;1e42 45
    ld d,h              ;1e43 54
    jr nz,l1e96h        ;1e44 20 50
    ld (hl),d           ;1e46 72
    ld l,c              ;1e47 69
    ld l,(hl)           ;1e48 6e
    ld (hl),h           ;1e49 74
    ld h,l              ;1e4a 65
l1e4bh:
    ld (hl),d           ;1e4b 72
    jr nz,l1eb2h        ;1e4c 20 64
    ld h,l              ;1e4e 65
    halt                ;1e4f 76
    ld l,c              ;1e50 69
    ld h,e              ;1e51 63
    ld h,l              ;1e52 65
    jr nz,$+37          ;1e53 20 23
    jr nz,$+60          ;1e55 20 3a
l1e57h:
    add hl,bc           ;1e57 09
l1e58h:
    dec de              ;1e58 1b
    jr nz,l1e8dh        ;1e59 20 32
l1e5bh:
    ld l,20h            ;1e5b 2e 20
    jr nz,$+67          ;1e5d 20 41
    ld d,e              ;1e5f 53
    ld b,e              ;1e60 43
    ld c,c              ;1e61 49
    ld c,c              ;1e62 49
l1e63h:
    jr nz,$+110         ;1e63 20 6c
    ld l,c              ;1e65 69
    ld (hl),e           ;1e66 73
l1e67h:
    ld (hl),h           ;1e67 74
    jr nz,l1eceh        ;1e68 20 64
    ld h,l              ;1e6a 65
    halt                ;1e6b 76
    ld l,c              ;1e6c 69
    ld h,e              ;1e6d 63
    ld h,l              ;1e6e 65
l1e6fh:
    jr nz,l1e94h        ;1e6f 20 23
    jr nz,l1eadh        ;1e71 20 3a
    add hl,bc           ;1e73 09
l1e74h:
    jr l1e96h           ;1e74 18 20
    inc sp              ;1e76 33
    ld l,20h            ;1e77 2e 20
    jr nz,l1ecdh        ;1e79 20 52
    ld h,l              ;1e7b 65
    ld h,c              ;1e7c 61
    ld h,h              ;1e7d 64
    ld h,l              ;1e7e 65
    ld (hl),d           ;1e7f 72
    jr nz,l1ee6h        ;1e80 20 64
    ld h,l              ;1e82 65
    halt                ;1e83 76
    ld l,c              ;1e84 69
    ld h,e              ;1e85 63
    ld h,l              ;1e86 65
    jr nz,l1each        ;1e87 20 23
    jr nz,l1ec5h        ;1e89 20 3a
    add hl,bc           ;1e8b 09
    add hl,bc           ;1e8c 09
l1e8dh:
    rla                 ;1e8d 17
    jr nz,l1ec4h        ;1e8e 20 34
    ld l,20h            ;1e90 2e 20
l1e92h:
    jr nz,l1ee4h        ;1e92 20 50
l1e94h:
    ld (hl),l           ;1e94 75
    ld l,(hl)           ;1e95 6e
l1e96h:
    ld h,e              ;1e96 63
    ld l,b              ;1e97 68
    jr nz,l1efeh        ;1e98 20 64
    ld h,l              ;1e9a 65
    halt                ;1e9b 76
    ld l,c              ;1e9c 69
    ld h,e              ;1e9d 63
    ld h,l              ;1e9e 65
    jr nz,l1ec4h        ;1e9f 20 23
    jr nz,l1eddh        ;1ea1 20 3a
    add hl,bc           ;1ea3 09
    add hl,bc           ;1ea4 09
l1ea5h:
    dec de              ;1ea5 1b
    jr nz,l1eddh        ;1ea6 20 35
    ld l,20h            ;1ea8 2e 20
    jr nz,l1ef0h        ;1eaa 20 44
l1each:
    ld h,l              ;1eac 65
l1eadh:
    ld h,(hl)           ;1ead 66
    ld h,c              ;1eae 61
    ld (hl),l           ;1eaf 75
    ld l,h              ;1eb0 6c
    ld (hl),h           ;1eb1 74
l1eb2h:
    jr nz,l1f00h        ;1eb2 20 4c
    ld d,e              ;1eb4 53
    ld d,h              ;1eb5 54
    ld a,(6420h)        ;1eb6 3a 20 64
    ld h,l              ;1eb9 65
    halt                ;1eba 76
    ld l,c              ;1ebb 69
    ld h,e              ;1ebc 63
    ld h,l              ;1ebd 65
    jr nz,l1efah        ;1ebe 20 3a
    add hl,bc           ;1ec0 09
l1ec1h:
    inc b               ;1ec1 04
    ld d,h              ;1ec2 54
    ld d,h              ;1ec3 54
l1ec4h:
    ld e,c              ;1ec4 59
l1ec5h:
    ld a,(4304h)        ;1ec5 3a 04 43
    ld d,d              ;1ec8 52
    ld d,h              ;1ec9 54
    ld a,(4c04h)        ;1eca 3a 04 4c
l1ecdh:
    ld d,b              ;1ecd 50
l1eceh:
    ld d,h              ;1ece 54
    ld a,(l2004h)       ;1ecf 3a 04 20
    jr nz,l1ef4h        ;1ed2 20 20
    ld a,(l201bh)       ;1ed4 3a 1b 20
    ld (hl),2eh         ;1ed7 36 2e
    jr nz,$+34          ;1ed9 20 20
    ld b,h              ;1edb 44
    ld h,l              ;1edc 65
l1eddh:
    ld h,(hl)           ;1edd 66
    ld h,c              ;1ede 61
    ld (hl),l           ;1edf 75
    ld l,h              ;1ee0 6c
    ld (hl),h           ;1ee1 74
    jr nz,l1f36h        ;1ee2 20 52
l1ee4h:
    ld b,h              ;1ee4 44
    ld d,d              ;1ee5 52
l1ee6h:
    ld a,(6420h)        ;1ee6 3a 20 64
    ld h,l              ;1ee9 65
    halt                ;1eea 76
    ld l,c              ;1eeb 69
    ld h,e              ;1eec 63
    ld h,l              ;1eed 65
    jr nz,l1f2ah        ;1eee 20 3a
l1ef0h:
    add hl,bc           ;1ef0 09
l1ef1h:
    inc b               ;1ef1 04
    ld d,h              ;1ef2 54
    ld d,h              ;1ef3 54
l1ef4h:
    ld e,c              ;1ef4 59
    ld a,(5004h)        ;1ef5 3a 04 50
    ld d,h              ;1ef8 54
    ld d,d              ;1ef9 52
l1efah:
    ld a,(l201bh)       ;1efa 3a 1b 20
    scf                 ;1efd 37
l1efeh:
    ld l,20h            ;1efe 2e 20
l1f00h:
    jr nz,l1f46h        ;1f00 20 44
    ld h,l              ;1f02 65
    ld h,(hl)           ;1f03 66
    ld h,c              ;1f04 61
    ld (hl),l           ;1f05 75
    ld l,h              ;1f06 6c
    ld (hl),h           ;1f07 74
    jr nz,$+82          ;1f08 20 50
    ld d,l              ;1f0a 55
    ld c,(hl)           ;1f0b 4e
    ld a,(6420h)        ;1f0c 3a 20 64
    ld h,l              ;1f0f 65
    halt                ;1f10 76
    ld l,c              ;1f11 69
    ld h,e              ;1f12 63
    ld h,l              ;1f13 65
    jr nz,$+60          ;1f14 20 3a
    add hl,bc           ;1f16 09
l1f17h:
    inc b               ;1f17 04
    ld d,h              ;1f18 54
    ld d,h              ;1f19 54
    ld e,c              ;1f1a 59
    ld a,(5004h)        ;1f1b 3a 04 50
    ld d,h              ;1f1e 54
    ld d,b              ;1f1f 50
    ld a,(l201bh)       ;1f20 3a 1b 20
    jr c,$+48           ;1f23 38 2e
    jr nz,$+34          ;1f25 20 20
    ld d,b              ;1f27 50
    ld b,l              ;1f28 45
    ld d,h              ;1f29 54
l1f2ah:
    jr nz,l1f7ch        ;1f2a 20 50
    ld (hl),d           ;1f2c 72
    ld l,c              ;1f2d 69
    ld l,(hl)           ;1f2e 6e
    ld (hl),h           ;1f2f 74
    ld h,l              ;1f30 65
    ld (hl),d           ;1f31 72
    jr nz,$+118         ;1f32 20 74
    ld a,c              ;1f34 79
    ld (hl),b           ;1f35 70
l1f36h:
    ld h,l              ;1f36 65
    jr nz,l1f73h        ;1f37 20 3a
    jr nz,l1f5bh        ;1f39 20 20
    jr nz,l1f46h        ;1f3b 20 09
l1f3dh:
    add hl,bc           ;1f3d 09
    inc sp              ;1f3e 33
    jr nc,l1f73h        ;1f3f 30 32
    ld (342fh),a        ;1f41 32 2f 34
    jr nc,l1f78h        ;1f44 30 32
l1f46h:
    ld (3809h),a        ;1f46 32 09 38
    jr nc,$+52          ;1f49 30 32
    ld (hl),2fh         ;1f4b 36 2f
    jr c,$+50           ;1f4d 38 30
    ld (l0437h),a       ;1f4f 32 37 04
    jr c,$+50           ;1f52 38 30
    ld (l0434h),a       ;1f54 32 34 04
    jr nz,$+34          ;1f57 20 20
    jr nz,l1f7bh        ;1f59 20 20
l1f5bh:
    inc hl              ;1f5b 23
    ld b,c              ;1f5c 41
    ld l,h              ;1f5d 6c
    ld (hl),h           ;1f5e 74
    ld h,l              ;1f5f 65
    ld (hl),d           ;1f60 72
    jr nz,l1fdah        ;1f61 20 77
    ld l,b              ;1f63 68
    ld l,c              ;1f64 69
    ld h,e              ;1f65 63
    ld l,b              ;1f66 68
    jr nz,l1fcch        ;1f67 20 63
    ld l,b              ;1f69 68
    ld h,c              ;1f6a 61
    ld (hl),d           ;1f6b 72
    ld h,c              ;1f6c 61
    ld h,e              ;1f6d 63
    ld (hl),h           ;1f6e 74
    ld h,l              ;1f6f 65
    ld (hl),d           ;1f70 72
    ld l,c              ;1f71 69
    ld (hl),e           ;1f72 73
l1f73h:
    ld (hl),h           ;1f73 74
    ld l,c              ;1f74 69
    ld h,e              ;1f75 63
    jr nz,l1fa0h        ;1f76 20 28
l1f78h:
    ld sp,382dh         ;1f78 31 2d 38
l1f7bh:
    add hl,hl           ;1f7b 29
l1f7ch:
    jr nz,$+65          ;1f7c 20 3f
    jr nz,$+17          ;1f7e 20 0f
    ld c,(hl)           ;1f80 4e
    ld h,l              ;1f81 65
    ld (hl),a           ;1f82 77
    jr nz,l1fe9h        ;1f83 20 64
    ld h,l              ;1f85 65
    halt                ;1f86 76
    ld l,c              ;1f87 69
    ld h,e              ;1f88 63
    ld h,l              ;1f89 65
    jr nz,l1fafh        ;1f8a 20 23
    jr nz,$+65          ;1f8c 20 3f
    jr nz,$+34          ;1f8e 20 20
    ld c,(hl)           ;1f90 4e
    ld (hl),l           ;1f91 75
    ld l,l              ;1f92 6d
    ld h,d              ;1f93 62
    ld h,l              ;1f94 65
    ld (hl),d           ;1f95 72
    jr nz,l2007h        ;1f96 20 6f
    ld h,(hl)           ;1f98 66
    jr nz,l1ffeh        ;1f99 20 63
    ld l,a              ;1f9b 6f
    ld l,h              ;1f9c 6c
    ld (hl),l           ;1f9d 75
    ld l,l              ;1f9e 6d
    ld l,(hl)           ;1f9f 6e
l1fa0h:
    ld (hl),e           ;1fa0 73
    jr nz,$+42          ;1fa1 20 28
    ld sp,l202ch        ;1fa3 31 2c 20
    ld (6f20h),a        ;1fa6 32 20 6f
    ld (hl),d           ;1fa9 72
    jr nz,l1fe0h        ;1faa 20 34
    add hl,hl           ;1fac 29
    jr nz,l1feeh        ;1fad 20 3f
l1fafh:
    jr nz,$+46          ;1faf 20 2c
    ld d,e              ;1fb1 53
    ld h,e              ;1fb2 63
    ld (hl),d           ;1fb3 72
    ld h,l              ;1fb4 65
    ld h,l              ;1fb5 65
    ld l,(hl)           ;1fb6 6e
    jr nz,l202dh        ;1fb7 20 74
    ld a,c              ;1fb9 79
    ld (hl),b           ;1fba 70
    ld h,l              ;1fbb 65
    jr nz,$+67          ;1fbc 20 41
    jr z,l2004h         ;1fbe 28 44
    ld c,l              ;1fc0 4d
    inc sp              ;1fc1 33
    ld b,c              ;1fc2 41
    add hl,hl           ;1fc3 29
    inc l               ;1fc4 2c
    jr nz,l200fh        ;1fc5 20 48
    jr z,l2023h         ;1fc7 28 5a
    ld sp,l3035h        ;1fc9 31 35 30
l1fcch:
    jr nc,$+43          ;1fcc 30 29
    inc l               ;1fce 2c
    jr nz,l2040h        ;1fcf 20 6f
    ld (hl),d           ;1fd1 72
    jr nz,l2028h        ;1fd2 20 54
    jr z,l202ch         ;1fd4 28 56
    add hl,sp           ;1fd6 39
    ld sp,l2932h        ;1fd7 31 32 29
l1fdah:
    jr nz,l201bh        ;1fda 20 3f
    jr nz,$+37          ;1fdc 20 23
    ld c,h              ;1fde 4c
    ld h,l              ;1fdf 65
l1fe0h:
    ld h,c              ;1fe0 61
    ld h,h              ;1fe1 64
    dec l               ;1fe2 2d
    ld l,c              ;1fe3 69
    ld l,(hl)           ;1fe4 6e
    jr nz,l204ah        ;1fe5 20 63
    ld l,a              ;1fe7 6f
    ld h,h              ;1fe8 64
l1fe9h:
    ld h,l              ;1fe9 65
    jr nz,l2031h        ;1fea 20 45
    jr z,l2061h         ;1fec 28 73
l1feeh:
    ld h,e              ;1fee 63
    ld h,c              ;1fef 61
    ld (hl),b           ;1ff0 70
    ld h,l              ;1ff1 65
    add hl,hl           ;1ff2 29
    jr nz,$+113         ;1ff3 20 6f
    ld (hl),d           ;1ff5 72
    jr nz,l204ch        ;1ff6 20 54
    jr z,l2063h         ;1ff8 28 69
    ld l,h              ;1ffa 6c
    ld h,h              ;1ffb 64
    ld h,l              ;1ffc 65
    add hl,hl           ;1ffd 29
l1ffeh:
    jr nz,l203fh        ;1ffe 20 3f
    jr nz,$+24          ;2000 20 16
    ld c,(hl)           ;2002 4e
    ld h,l              ;2003 65
l2004h:
    ld (hl),a           ;2004 77
    jr nz,l206ah        ;2005 20 63
l2007h:
    ld l,h              ;2007 6c
    ld l,a              ;2008 6f
    ld h,e              ;2009 63
    ld l,e              ;200a 6b
    jr nz,l2073h        ;200b 20 66
    ld (hl),d           ;200d 72
    ld h,l              ;200e 65
l200fh:
    ld (hl),c           ;200f 71
    ld (hl),l           ;2010 75
    ld h,l              ;2011 65
    ld l,(hl)           ;2012 6e
    ld h,e              ;2013 63
    ld a,c              ;2014 79
    jr nz,l2056h        ;2015 20 3f
    jr nz,l2030h        ;2017 20 17
    ld d,b              ;2019 50
    ld h,l              ;201a 65
l201bh:
    ld (hl),h           ;201b 74
    jr nz,l2092h        ;201c 20 74
    ld h,l              ;201e 65
    ld (hl),d           ;201f 72
l2020h:
    ld l,l              ;2020 6d
    ld l,c              ;2021 69
    ld l,(hl)           ;2022 6e
l2023h:
    ld h,c              ;2023 61
    ld l,h              ;2024 6c
    jr nz,l2097h        ;2025 20 70
    ld h,c              ;2027 61
l2028h:
    ld (hl),d           ;2028 72
l2029h:
    ld h,c              ;2029 61
    ld l,l              ;202a 6d
    ld h,l              ;202b 65
l202ch:
    ld (hl),h           ;202c 74
l202dh:
    ld h,l              ;202d 65
    ld (hl),d           ;202e 72
    ld (hl),e           ;202f 73
l2030h:
    rla                 ;2030 17
l2031h:
    dec l               ;2031 2d
l2032h:
    dec l               ;2032 2d
    dec l               ;2033 2d
    jr nz,l2063h        ;2034 20 2d
    dec l               ;2036 2d
    dec l               ;2037 2d
    dec l               ;2038 2d
    dec l               ;2039 2d
l203ah:
    dec l               ;203a 2d
    dec l               ;203b 2d
    dec l               ;203c 2d
    jr nz,$+47          ;203d 20 2d
l203fh:
    dec l               ;203f 2d
l2040h:
    dec l               ;2040 2d
    dec l               ;2041 2d
    dec l               ;2042 2d
    dec l               ;2043 2d
    dec l               ;2044 2d
    dec l               ;2045 2d
    dec l               ;2046 2d
    dec l               ;2047 2d
l2048h:
    ld e,31h            ;2048 1e 31
l204ah:
    ld l,20h            ;204a 2e 20
l204ch:
    jr nz,l2091h        ;204c 20 43
    ld l,a              ;204e 6f
    ld l,h              ;204f 6c
    ld (hl),l           ;2050 75
    ld l,l              ;2051 6d
    ld l,(hl)           ;2052 6e
    ld (hl),e           ;2053 73
    jr nz,l20bfh        ;2054 20 69
l2056h:
    ld l,(hl)           ;2056 6e
    jr nz,l209dh        ;2057 20 44
    ld c,c              ;2059 49
    ld d,d              ;205a 52
    jr nz,$+110         ;205b 20 6c
    ld l,c              ;205d 69
    ld (hl),e           ;205e 73
    ld (hl),h           ;205f 74
    ld l,c              ;2060 69
l2061h:
    ld l,(hl)           ;2061 6e
    ld h,a              ;2062 67
l2063h:
    jr nz,l209fh        ;2063 20 3a
    jr nz,l2087h        ;2065 20 20
l2067h:
    ld bc,0131h         ;2067 01 31 01
l206ah:
    ld (3401h),a        ;206a 32 01 34
l206dh:
    ld e,32h            ;206d 1e 32
    ld l,20h            ;206f 2e 20
    jr nz,l20b6h        ;2071 20 43
l2073h:
    ld d,d              ;2073 52
    ld d,h              ;2074 54
    jr nz,l20e0h        ;2075 20 69
    ld l,(hl)           ;2077 6e
    jr nz,$+119         ;2078 20 75
    ld (hl),b           ;207a 70
    ld (hl),b           ;207b 70
    ld h,l              ;207c 65
    ld (hl),d           ;207d 72
    jr nz,l20e3h        ;207e 20 63
    ld h,c              ;2080 61
    ld (hl),e           ;2081 73
    ld h,l              ;2082 65
    jr nz,l20f2h        ;2083 20 6d
    ld l,a              ;2085 6f
    ld h,h              ;2086 64
l2087h:
    ld h,l              ;2087 65
    jr nz,l20c4h        ;2088 20 3a
    jr nz,l20ach        ;208a 20 20
l208ch:
    inc bc              ;208c 03
    ld e,c              ;208d 59
    ld h,l              ;208e 65
    ld (hl),e           ;208f 73
l2090h:
    ld (bc),a           ;2090 02
l2091h:
    ld c,(hl)           ;2091 4e
l2092h:
    ld l,a              ;2092 6f
l2093h:
    ld e,33h            ;2093 1e 33
    ld l,20h            ;2095 2e 20
l2097h:
    jr nz,l20dch        ;2097 20 43
    ld d,d              ;2099 52
    ld d,h              ;209a 54
    jr nz,l2111h        ;209b 20 74
l209dh:
    ld h,l              ;209d 65
    ld (hl),d           ;209e 72
l209fh:
    ld l,l              ;209f 6d
    ld l,c              ;20a0 69
    ld l,(hl)           ;20a1 6e
    ld h,c              ;20a2 61
    ld l,h              ;20a3 6c
    jr nz,l210bh        ;20a4 20 65
    ld l,l              ;20a6 6d
    ld (hl),l           ;20a7 75
    ld l,h              ;20a8 6c
    ld h,c              ;20a9 61
    ld (hl),h           ;20aa 74
    ld l,c              ;20ab 69
l20ach:
    ld l,a              ;20ac 6f
    ld l,(hl)           ;20ad 6e
    jr nz,l20eah        ;20ae 20 3a
    jr nz,l20d2h        ;20b0 20 20
l20b2h:
    dec b               ;20b2 05
    ld b,c              ;20b3 41
    ld b,h              ;20b4 44
    ld c,l              ;20b5 4d
l20b6h:
    inc sp              ;20b6 33
    ld b,c              ;20b7 41
l20b8h:
    dec b               ;20b8 05
    ld d,h              ;20b9 54
    ld d,(hl)           ;20ba 56
    add hl,sp           ;20bb 39
    ld sp,l1b32h        ;20bc 31 32 1b
l20bfh:
    ld c,b              ;20bf 48
    ld e,d              ;20c0 5a
    ld sp,l3035h        ;20c1 31 35 30
l20c4h:
    jr nc,l20cfh        ;20c4 30 09
    add hl,bc           ;20c6 09
    add hl,bc           ;20c7 09
    jr z,l2116h         ;20c8 28 4c
    ld h,l              ;20ca 65
    ld h,c              ;20cb 61
    ld h,h              ;20cc 64
    dec l               ;20cd 2d
    ld l,c              ;20ce 69
l20cfh:
    ld l,(hl)           ;20cf 6e
    jr nz,l210fh        ;20d0 20 3d
l20d2h:
    jr nz,l2119h        ;20d2 20 45
    ld d,e              ;20d4 53
    ld b,e              ;20d5 43
    ld b,c              ;20d6 41
    ld d,b              ;20d7 50
    ld b,l              ;20d8 45
    add hl,hl           ;20d9 29
l20dah:
    ld a,(de)           ;20da 1a
    ld c,b              ;20db 48
l20dch:
    ld e,d              ;20dc 5a
    ld sp,l3035h        ;20dd 31 35 30
l20e0h:
    jr nc,l20ebh        ;20e0 30 09
    add hl,bc           ;20e2 09
l20e3h:
    add hl,bc           ;20e3 09
    jr z,$+78           ;20e4 28 4c
    ld h,l              ;20e6 65
    ld h,c              ;20e7 61
    ld h,h              ;20e8 64
    dec l               ;20e9 2d
l20eah:
    ld l,c              ;20ea 69
l20ebh:
    ld l,(hl)           ;20eb 6e
    jr nz,l212bh        ;20ec 20 3d
    jr nz,$+86          ;20ee 20 54
    ld c,c              ;20f0 49
    ld c,h              ;20f1 4c
l20f2h:
    ld b,h              ;20f2 44
    ld b,l              ;20f3 45
    add hl,hl           ;20f4 29
l20f5h:
    ld b,20h            ;20f5 06 20
    jr nz,l2119h        ;20f7 20 20
    jr nz,l211bh        ;20f9 20 20
    jr nz,l2103h        ;20fb 20 06
    jr nz,$+34          ;20fd 20 20
    jr nz,$+34          ;20ff 20 20
    jr nz,l2123h        ;2101 20 20
l2103h:
    ld e,34h            ;2103 1e 34
    ld l,20h            ;2105 2e 20
    jr nz,l214ch        ;2107 20 43
    ld l,h              ;2109 6c
    ld l,a              ;210a 6f
l210bh:
    ld h,e              ;210b 63
    ld l,e              ;210c 6b
    jr nz,l2175h        ;210d 20 66
l210fh:
    ld (hl),d           ;210f 72
    ld h,l              ;2110 65
l2111h:
    ld (hl),c           ;2111 71
    ld (hl),l           ;2112 75
    ld h,l              ;2113 65
    ld l,(hl)           ;2114 6e
    ld h,e              ;2115 63
l2116h:
    ld a,c              ;2116 79
    jr nz,$+42          ;2117 20 28
l2119h:
    ld c,b              ;2119 48
    ld a,d              ;211a 7a
l211bh:
    add hl,hl           ;211b 29
    jr nz,l2158h        ;211c 20 3a
    jr nz,l2140h        ;211e 20 20
    jr nz,l2142h        ;2120 20 20
l2122h:
    inc d               ;2122 14
l2123h:
    ld b,c              ;2123 41
    ld l,h              ;2124 6c
    ld (hl),h           ;2125 74
    ld h,l              ;2126 65
    ld (hl),d           ;2127 72
    jr nz,$+121         ;2128 20 77
    ld l,b              ;212a 68
l212bh:
    ld l,c              ;212b 69
    ld h,e              ;212c 63
    ld l,b              ;212d 68
    jr nz,l2158h        ;212e 20 28
    ld sp,342dh         ;2130 31 2d 34
    add hl,hl           ;2133 29
    jr nz,l2175h        ;2134 20 3f
    jr nz,l2139h        ;2136 20 01
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
    ld bc,l1c00h        ;215e 01 00 1c
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
    ld bc,l1c00h        ;22ae 01 00 1c
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
