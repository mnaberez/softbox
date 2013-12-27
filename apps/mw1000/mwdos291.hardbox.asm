;This is a disassembly of the HardBox code payload inside mwdos291.com.

    org 0100h

    jp l0200h           ;0100 c3 00 02
l0103h:
    ld bc,0000h         ;0103 01 00 00
    nop                 ;0106 00
    ret nz              ;0107 c0
    rla                 ;0108 17
    nop                 ;0109 00
    ret po              ;010a e0
    inc bc              ;010b 03
    ld sp,hl            ;010c f9
    inc bc              ;010d 03
    ld c,l              ;010e 4d
    nop                 ;010f 00
    dec e               ;0110 1d
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
    nop                 ;011b 00
    nop                 ;011c 00
    nop                 ;011d 00
    nop                 ;011e 00
    nop                 ;011f 00
    nop                 ;0120 00
    nop                 ;0121 00
    nop                 ;0122 00
l0123h:
    ld c,b              ;0123 48
    ld b,c              ;0124 41
    ld d,d              ;0125 52
    ld b,h              ;0126 44
    jr nz,l016dh        ;0127 20 44
    ld c,c              ;0129 49
    ld d,e              ;012a 53
    ld c,e              ;012b 4b
    jr nz,l014eh        ;012c 20 20
    jr nz,l0150h        ;012e 20 20
    jr nz,l0152h        ;0130 20 20
    jr nz,l013bh        ;0132 20 07
l0134h:
    ld h,b              ;0134 60
    nop                 ;0135 00
l0136h:
    ex af,af'           ;0136 08
    nop                 ;0137 00
    nop                 ;0138 00
    nop                 ;0139 00
    nop                 ;013a 00
l013bh:
    nop                 ;013b 00
    nop                 ;013c 00
    nop                 ;013d 00
    nop                 ;013e 00
sub_013fh:
    nop                 ;013f 00
    nop                 ;0140 00
    nop                 ;0141 00
    nop                 ;0142 00
    nop                 ;0143 00
    nop                 ;0144 00
    nop                 ;0145 00
    nop                 ;0146 00
    nop                 ;0147 00
    nop                 ;0148 00
    nop                 ;0149 00
    nop                 ;014a 00
    nop                 ;014b 00
    nop                 ;014c 00
    nop                 ;014d 00
l014eh:
    nop                 ;014e 00
    nop                 ;014f 00
l0150h:
    nop                 ;0150 00
    nop                 ;0151 00
l0152h:
    nop                 ;0152 00
    nop                 ;0153 00
    nop                 ;0154 00
    nop                 ;0155 00
    nop                 ;0156 00
    nop                 ;0157 00
    nop                 ;0158 00
    nop                 ;0159 00
    nop                 ;015a 00
    nop                 ;015b 00
    nop                 ;015c 00
    nop                 ;015d 00
    nop                 ;015e 00
    nop                 ;015f 00
    nop                 ;0160 00
    nop                 ;0161 00
    nop                 ;0162 00
    nop                 ;0163 00
    nop                 ;0164 00
    nop                 ;0165 00
    nop                 ;0166 00
    nop                 ;0167 00
    nop                 ;0168 00
    nop                 ;0169 00
    nop                 ;016a 00
    nop                 ;016b 00
    nop                 ;016c 00
l016dh:
    nop                 ;016d 00
    nop                 ;016e 00
    nop                 ;016f 00
    nop                 ;0170 00
    nop                 ;0171 00
    nop                 ;0172 00
    nop                 ;0173 00
    nop                 ;0174 00
    nop                 ;0175 00
    nop                 ;0176 00
    nop                 ;0177 00
    nop                 ;0178 00
    nop                 ;0179 00
    nop                 ;017a 00
    nop                 ;017b 00
    nop                 ;017c 00
    nop                 ;017d 00
    nop                 ;017e 00
    nop                 ;017f 00
    nop                 ;0180 00
    nop                 ;0181 00
    nop                 ;0182 00
    nop                 ;0183 00
    nop                 ;0184 00
    nop                 ;0185 00
    nop                 ;0186 00
    nop                 ;0187 00
    nop                 ;0188 00
    nop                 ;0189 00
    nop                 ;018a 00
    nop                 ;018b 00
    nop                 ;018c 00
    nop                 ;018d 00
    nop                 ;018e 00
    nop                 ;018f 00
    nop                 ;0190 00
    nop                 ;0191 00
    nop                 ;0192 00
    nop                 ;0193 00
    nop                 ;0194 00
    nop                 ;0195 00
    nop                 ;0196 00
    nop                 ;0197 00
    nop                 ;0198 00
    nop                 ;0199 00
    nop                 ;019a 00
    nop                 ;019b 00
    nop                 ;019c 00
    nop                 ;019d 00
    nop                 ;019e 00
    nop                 ;019f 00
    nop                 ;01a0 00
    nop                 ;01a1 00
    nop                 ;01a2 00
    nop                 ;01a3 00
    nop                 ;01a4 00
    nop                 ;01a5 00
    nop                 ;01a6 00
    nop                 ;01a7 00
    nop                 ;01a8 00
    nop                 ;01a9 00
    nop                 ;01aa 00
    nop                 ;01ab 00
    nop                 ;01ac 00
    nop                 ;01ad 00
    nop                 ;01ae 00
    nop                 ;01af 00
    nop                 ;01b0 00
    nop                 ;01b1 00
    nop                 ;01b2 00
    nop                 ;01b3 00
    nop                 ;01b4 00
    nop                 ;01b5 00
    nop                 ;01b6 00
    nop                 ;01b7 00
    nop                 ;01b8 00
    nop                 ;01b9 00
    nop                 ;01ba 00
    nop                 ;01bb 00
    nop                 ;01bc 00
    nop                 ;01bd 00
    nop                 ;01be 00
    nop                 ;01bf 00
    nop                 ;01c0 00
    nop                 ;01c1 00
    nop                 ;01c2 00
    nop                 ;01c3 00
    nop                 ;01c4 00
    nop                 ;01c5 00
    nop                 ;01c6 00
    nop                 ;01c7 00
    nop                 ;01c8 00
    nop                 ;01c9 00
    nop                 ;01ca 00
    nop                 ;01cb 00
    nop                 ;01cc 00
    nop                 ;01cd 00
    nop                 ;01ce 00
    nop                 ;01cf 00
    nop                 ;01d0 00
    nop                 ;01d1 00
    nop                 ;01d2 00
    nop                 ;01d3 00
    nop                 ;01d4 00
    nop                 ;01d5 00
    nop                 ;01d6 00
    nop                 ;01d7 00
    nop                 ;01d8 00
    nop                 ;01d9 00
    nop                 ;01da 00
    nop                 ;01db 00
    nop                 ;01dc 00
    nop                 ;01dd 00
    nop                 ;01de 00
    nop                 ;01df 00
    nop                 ;01e0 00
    nop                 ;01e1 00
    nop                 ;01e2 00
    nop                 ;01e3 00
    nop                 ;01e4 00
    nop                 ;01e5 00
    nop                 ;01e6 00
    nop                 ;01e7 00
    nop                 ;01e8 00
    nop                 ;01e9 00
    nop                 ;01ea 00
    nop                 ;01eb 00
    nop                 ;01ec 00
    nop                 ;01ed 00
    nop                 ;01ee 00
    nop                 ;01ef 00
    nop                 ;01f0 00
    nop                 ;01f1 00
    nop                 ;01f2 00
    nop                 ;01f3 00
    nop                 ;01f4 00
    nop                 ;01f5 00
    nop                 ;01f6 00
    nop                 ;01f7 00
    nop                 ;01f8 00
    nop                 ;01f9 00
    nop                 ;01fa 00
    nop                 ;01fb 00
    nop                 ;01fc 00
    nop                 ;01fd 00
    nop                 ;01fe 00
    nop                 ;01ff 00
l0200h:
    xor a               ;0200 af
    out (11h),a         ;0201 d3 11
    ld a,80h            ;0203 3e 80
    out (15h),a         ;0205 d3 15
    ld a,(l0136h)       ;0207 3a 36 01
    ld (l2000h),a       ;020a 32 00 20
l020dh:
    ld sp,4a93h         ;020d 31 93 4a
    ld hl,l2004h        ;0210 21 04 20
    ld de,l2005h        ;0213 11 05 20
    ld bc,2a0eh         ;0216 01 0e 2a
    ld (hl),00h         ;0219 36 00
    ldir                ;021b ed b0
    xor a               ;021d af
    ld (l2002h),a       ;021e 32 02 20
    ld a,01h            ;0221 3e 01
    ld (460ch),a        ;0223 32 0c 46
    ld hl,2bf5h         ;0226 21 f5 2b
    ld (2af3h),hl       ;0229 22 f3 2a
    ld hl,l0103h        ;022c 21 03 01
    ld de,l2004h        ;022f 11 04 20
    ld bc,0020h         ;0232 01 20 00
    ldir                ;0235 ed b0
    ld hl,l0123h        ;0237 21 23 01
    ld de,l203eh        ;023a 11 3e 20
    ld bc,0010h         ;023d 01 10 00
    ldir                ;0240 ed b0
    call sub_05d8h      ;0242 cd d8 05
    call sub_192dh      ;0245 cd 2d 19
    ld hl,(l200bh)      ;0248 2a 0b 20
    ld (l202ah),hl      ;024b 22 2a 20
    ld a,(l2009h)       ;024e 3a 09 20
    ld e,a              ;0251 5f
    ld d,00h            ;0252 16 00
    add hl,de           ;0254 19
    ld (l202fh),hl      ;0255 22 2f 20
    ld hl,(l200dh)      ;0258 2a 0d 20
    ld a,h              ;025b 7c
    ld b,09h            ;025c 06 09
    call sub_1a7ah      ;025e cd 7a 1a
    inc hl              ;0261 23
    ld (l2039h),hl      ;0262 22 39 20
    ld hl,(l200bh)      ;0265 2a 0b 20
    ld b,05h            ;0268 06 05
    call sub_1a7ah      ;026a cd 7a 1a
    inc hl              ;026d 23
    ex de,hl            ;026e eb
    ld hl,(l202ah)      ;026f 2a 2a 20
    ld b,03h            ;0272 06 03
    call sub_1a7ah      ;0274 cd 7a 1a
    inc hl              ;0277 23
    add hl,de           ;0278 19
    ex de,hl            ;0279 eb
    ld hl,(l202fh)      ;027a 2a 2f 20
    ld b,02h            ;027d 06 02
    call sub_1a7ah      ;027f cd 7a 1a
    inc hl              ;0282 23
    add hl,de           ;0283 19
    ld de,(l200dh)      ;0284 ed 5b 0d 20
    add hl,de           ;0288 19
    ld de,(l2039h)      ;0289 ed 5b 39 20
    add hl,de           ;028d 19
    ex de,hl            ;028e eb
    ld hl,(l2008h)      ;028f 2a 08 20
    scf                 ;0292 37
    sbc hl,de           ;0293 ed 52
    srl h               ;0295 cb 3c
    rr l                ;0297 cb 1d
    ld (l2034h),hl      ;0299 22 34 20
    ld hl,(l2005h)      ;029c 2a 05 20
    ld a,(l2007h)       ;029f 3a 07 20
    ld de,0004h         ;02a2 11 04 00
    add hl,de           ;02a5 19
    adc a,00h           ;02a6 ce 00
    ld (l2024h),hl      ;02a8 22 24 20
    ld (l2026h),a       ;02ab 32 26 20
    ex de,hl            ;02ae eb
    ld hl,(l200bh)      ;02af 2a 0b 20
    ld b,03h            ;02b2 06 03
    call sub_1a7ah      ;02b4 cd 7a 1a
    inc hl              ;02b7 23
    add hl,de           ;02b8 19
    adc a,00h           ;02b9 ce 00
    ld (l2027h),hl      ;02bb 22 27 20
    ld (l2029h),a       ;02be 32 29 20
    ld de,(l202ah)      ;02c1 ed 5b 2a 20
    srl d               ;02c5 cb 3a
    rr e                ;02c7 cb 1b
    inc de              ;02c9 13
    add hl,de           ;02ca 19
    adc a,00h           ;02cb ce 00
    ld (l202ch),hl      ;02cd 22 2c 20
    ld (l202eh),a       ;02d0 32 2e 20
    ld de,(l202fh)      ;02d3 ed 5b 2f 20
    add hl,de           ;02d7 19
    adc a,00h           ;02d8 ce 00
    ld (l2031h),hl      ;02da 22 31 20
    ld (l2033h),a       ;02dd 32 33 20
    ld de,(l2034h)      ;02e0 ed 5b 34 20
    ld b,08h            ;02e4 06 08
l02e6h:
    add hl,de           ;02e6 19
    adc a,00h           ;02e7 ce 00
    djnz l02e6h         ;02e9 10 fb
    ld (l203bh),hl      ;02eb 22 3b 20
    ld (l203dh),a       ;02ee 32 3d 20
    ex de,hl            ;02f1 eb
    ld hl,(l2039h)      ;02f2 2a 39 20
    add hl,hl           ;02f5 29
    add hl,hl           ;02f6 29
    add hl,de           ;02f7 19
    adc a,00h           ;02f8 ce 00
    ld (l2036h),hl      ;02fa 22 36 20
    ld (l2038h),a       ;02fd 32 38 20
    ld a,0fh            ;0300 3e 0f
    ld (2ae7h),a        ;0302 32 e7 2a
    call sub_1689h      ;0305 cd 89 16
    ld hl,0000h         ;0308 21 00 00
    ld (2d68h),hl       ;030b 22 68 2d
l030eh:
    call sub_15a6h      ;030e cd a6 15
    jr c,l0336h         ;0311 38 23
    bit 7,(ix+01h)      ;0313 dd cb 01 7e
    jr nz,l030eh        ;0317 20 f5
    call sub_18beh      ;0319 cd be 18
    ld b,40h            ;031c 06 40
    ld ix,(2aeeh)       ;031e dd 2a ee 2a
l0322h:
    ld l,(ix+00h)       ;0322 dd 6e 00
    ld h,(ix+01h)       ;0325 dd 66 01
    ld de,l2057h        ;0328 11 57 20
    call sub_1733h      ;032b cd 33 17
    inc ix              ;032e dd 23
    inc ix              ;0330 dd 23
    djnz l0322h         ;0332 10 ee
    jr l030eh           ;0334 18 d8
l0336h:
    ld de,0000h         ;0336 11 00 00
    ld hl,l2057h        ;0339 21 57 20
l033ch:
    ld b,08h            ;033c 06 08
    ld c,(hl)           ;033e 4e
    inc hl              ;033f 23
l0340h:
    rr c                ;0340 cb 19
    jr nc,l0365h        ;0342 30 21
    push bc             ;0344 c5
    push hl             ;0345 e5
    push de             ;0346 d5
    call sub_17b5h      ;0347 cd b5 17
    ld b,80h            ;034a 06 80
    ld ix,(2aeah)       ;034c dd 2a ea 2a
l0350h:
    ld l,(ix+00h)       ;0350 dd 6e 00
    ld h,(ix+01h)       ;0353 dd 66 01
    inc ix              ;0356 dd 23
    inc ix              ;0358 dd 23
    ld de,2457h         ;035a 11 57 24
    call sub_1733h      ;035d cd 33 17
    djnz l0350h         ;0360 10 ee
    pop de              ;0362 d1
    pop hl              ;0363 e1
    pop bc              ;0364 c1
l0365h:
    inc de              ;0365 13
    ld a,(l202fh)       ;0366 3a 2f 20
    cp e                ;0369 bb
    jr nz,l0372h        ;036a 20 06
    ld a,(l2030h)       ;036c 3a 30 20
    cp d                ;036f ba
    jr z,l0376h         ;0370 28 04
l0372h:
    djnz l0340h         ;0372 10 cc
    jr l033ch           ;0374 18 c6
l0376h:
    xor a               ;0376 af
    out (16h),a         ;0377 d3 16
    out (11h),a         ;0379 d3 11
    in a,(15h)          ;037b db 15
    and 00h             ;037d e6 00
    out (15h),a         ;037f d3 15
l0381h:
    in a,(14h)          ;0381 db 14
    and 01h             ;0383 e6 01
    jr z,l0381h         ;0385 28 fa
l0387h:
    in a,(15h)          ;0387 db 15
    or 84h              ;0389 f6 84
    out (15h),a         ;038b d3 15
    in a,(15h)          ;038d db 15
    and 0f7h            ;038f e6 f7
    out (15h),a         ;0391 d3 15
l0393h:
    in a,(14h)          ;0393 db 14
    and 02h             ;0395 e6 02
    jr nz,l03a2h        ;0397 20 09
    in a,(14h)          ;0399 db 14
    and 01h             ;039b e6 01
    jr nz,l0393h        ;039d 20 f4
    jp l0415h           ;039f c3 15 04
l03a2h:
    ld hl,2af0h         ;03a2 21 f0 2a
    in a,(15h)          ;03a5 db 15
    or 08h              ;03a7 f6 08
    out (15h),a         ;03a9 d3 15
    in a,(10h)          ;03ab db 10
    ld c,a              ;03ad 4f
    in a,(15h)          ;03ae db 15
    and 0fbh            ;03b0 e6 fb
    out (15h),a         ;03b2 d3 15
    ld a,(l2000h)       ;03b4 3a 00 20
    or 20h              ;03b7 f6 20
    cp c                ;03b9 b9
    jr z,l03e2h         ;03ba 28 26
    xor 60h             ;03bc ee 60
    cp c                ;03be b9
    jr z,l03eah         ;03bf 28 29
    ld a,c              ;03c1 79
    cp 3fh              ;03c2 fe 3f
    jr z,l03f2h         ;03c4 28 2c
    cp 5fh              ;03c6 fe 5f
    jr z,l03f6h         ;03c8 28 2c
    and 60h             ;03ca e6 60
    cp 60h              ;03cc fe 60
    jr nz,l03dah        ;03ce 20 0a
    ld a,c              ;03d0 79
    ld (2ae7h),a        ;03d1 32 e7 2a
    and 0f0h            ;03d4 e6 f0
    cp 0e0h             ;03d6 fe e0
    jr z,l03fah         ;03d8 28 20
l03dah:
    in a,(14h)          ;03da db 14
    and 02h             ;03dc e6 02
    jr nz,l03dah        ;03de 20 fa
    jr l0387h           ;03e0 18 a5
l03e2h:
    set 2,(hl)          ;03e2 cb d6
    xor a               ;03e4 af
    ld (2ae7h),a        ;03e5 32 e7 2a
    jr l03dah           ;03e8 18 f0
l03eah:
    set 1,(hl)          ;03ea cb ce
    xor a               ;03ec af
    ld (2ae7h),a        ;03ed 32 e7 2a
    jr l03dah           ;03f0 18 e8
l03f2h:
    res 2,(hl)          ;03f2 cb 96
    jr l03dah           ;03f4 18 e4
l03f6h:
    res 1,(hl)          ;03f6 cb 8e
    jr l03dah           ;03f8 18 e0
l03fah:
    ld (hl),00h         ;03fa 36 00
    ld a,c              ;03fc 79
    and 0fh             ;03fd e6 0f
    ld (2ae7h),a        ;03ff 32 e7 2a
    push af             ;0402 f5
    cp 02h              ;0403 fe 02
    call nc,sub_05d8h   ;0405 d4 d8 05
    pop af              ;0408 f1
    cp 0fh              ;0409 fe 0f
    push af             ;040b f5
    call z,sub_0932h    ;040c cc 32 09
    pop af              ;040f f1
    call nz,sub_08e7h   ;0410 c4 e7 08
    jr l03dah           ;0413 18 c5
l0415h:
    in a,(15h)          ;0415 db 15
    and 7fh             ;0417 e6 7f
    out (15h),a         ;0419 d3 15
    ld a,(2af0h)        ;041b 3a f0 2a
sub_041eh:
    or a                ;041e b7
    jp z,l0376h         ;041f ca 76 03
    bit 2,a             ;0422 cb 57
    jr nz,l0455h        ;0424 20 2f
    in a,(15h)          ;0426 db 15
    and 0fbh            ;0428 e6 fb
    out (15h),a         ;042a d3 15
    ld a,(2ae7h)        ;042c 3a e7 2a
    or a                ;042f b7
    jp z,l0376h         ;0430 ca 76 03
    and 0fh             ;0433 e6 0f
    ld (2ae7h),a        ;0435 32 e7 2a
    cp 0fh              ;0438 fe 0f
    jp nz,l0941h        ;043a c2 41 09
l043dh:
    ld hl,(2af1h)       ;043d 2a f1 2a
    ld a,(hl)           ;0440 7e
    call sub_0510h      ;0441 cd 10 05
    jp c,l0376h         ;0444 da 76 03
    ld a,(hl)           ;0447 7e
    inc hl              ;0448 23
    cp 0dh              ;0449 fe 0d
    jr nz,l0450h        ;044b 20 03
    ld hl,2cf5h         ;044d 21 f5 2c
l0450h:
    ld (2af1h),hl       ;0450 22 f1 2a
    jr l043dh           ;0453 18 e8
l0455h:
    ld a,(2ae7h)        ;0455 3a e7 2a
    or a                ;0458 b7
    jp z,l0376h         ;0459 ca 76 03
    push af             ;045c f5
    and 0fh             ;045d e6 0f
    ld (2ae7h),a        ;045f 32 e7 2a
    cp 02h              ;0462 fe 02
    call nc,sub_05d8h   ;0464 d4 d8 05
    pop af              ;0467 f1
    jp p,l049bh         ;0468 f2 9b 04
    ld hl,2c75h         ;046b 21 75 2c
    ld b,7fh            ;046e 06 7f
l0470h:
    call sub_04c1h      ;0470 cd c1 04
    jp c,l0376h         ;0473 da 76 03
    bit 7,b             ;0476 cb 78
    jr nz,l047dh        ;0478 20 03
    ld (hl),a           ;047a 77
    inc hl              ;047b 23
    dec b               ;047c 05
l047dh:
    ld a,(456fh)        ;047d 3a 6f 45
    or a                ;0480 b7
    jr z,l0470h         ;0481 28 ed
    ld (hl),0dh         ;0483 36 0d
    ld a,(2ae7h)        ;0485 3a e7 2a
    cp 0fh              ;0488 fe 0f
    jp nz,l06bbh        ;048a c2 bb 06
    ld hl,2c75h         ;048d 21 75 2c
    ld de,2bf5h         ;0490 11 f5 2b
    ld bc,0080h         ;0493 01 80 00
    ldir                ;0496 ed b0
    jp l056ah           ;0498 c3 6a 05
l049bh:
    ld a,(2ae7h)        ;049b 3a e7 2a
    cp 0fh              ;049e fe 0f
    jp nz,l0a48h        ;04a0 c2 48 0a
    ld hl,(2af3h)       ;04a3 2a f3 2a
l04a6h:
    call sub_04c1h      ;04a6 cd c1 04
    jp c,l0376h         ;04a9 da 76 03
    ld (hl),a           ;04ac 77
    ld a,l              ;04ad 7d
    cp 74h              ;04ae fe 74
    jr z,l04b6h         ;04b0 28 04
    inc hl              ;04b2 23
    ld (2af3h),hl       ;04b3 22 f3 2a
l04b6h:
    ld a,(456fh)        ;04b6 3a 6f 45
    or a                ;04b9 b7
    jr z,l04a6h         ;04ba 28 ea
    ld (hl),0dh         ;04bc 36 0d
    jp l056ah           ;04be c3 6a 05
sub_04c1h:
    in a,(14h)          ;04c1 db 14
    and 01h             ;04c3 e6 01
    jr nz,l0506h        ;04c5 20 3f
    in a,(15h)          ;04c7 db 15
    and 0f7h            ;04c9 e6 f7
    out (15h),a         ;04cb d3 15
l04cdh:
    in a,(14h)          ;04cd db 14
    and 01h             ;04cf e6 01
    jr nz,l0506h        ;04d1 20 33
    in a,(14h)          ;04d3 db 14
    and 02h             ;04d5 e6 02
    jr z,l04cdh         ;04d7 28 f4
    in a,(10h)          ;04d9 db 10
    push af             ;04db f5
    xor a               ;04dc af
    ld (456fh),a        ;04dd 32 6f 45
    in a,(14h)          ;04e0 db 14
    and 10h             ;04e2 e6 10
    jr z,l04ebh         ;04e4 28 05
    ld a,01h            ;04e6 3e 01
    ld (456fh),a        ;04e8 32 6f 45
l04ebh:
    in a,(15h)          ;04eb db 15
    or 08h              ;04ed f6 08
    out (15h),a         ;04ef d3 15
    in a,(15h)          ;04f1 db 15
    and 0fbh            ;04f3 e6 fb
    out (15h),a         ;04f5 d3 15
l04f7h:
    in a,(14h)          ;04f7 db 14
    and 02h             ;04f9 e6 02
    jr nz,l04f7h        ;04fb 20 fa
    in a,(15h)          ;04fd db 15
    or 04h              ;04ff f6 04
    out (15h),a         ;0501 d3 15
    pop af              ;0503 f1
    or a                ;0504 b7
    ret                 ;0505 c9
l0506h:
    scf                 ;0506 37
    ret                 ;0507 c9
sub_0508h:
    push af             ;0508 f5
    in a,(15h)          ;0509 db 15
    or 10h              ;050b f6 10
    out (15h),a         ;050d d3 15
    pop af              ;050f f1
sub_0510h:
    call sub_0519h      ;0510 cd 19 05
    ret c               ;0513 d8
    call sub_055ah      ;0514 cd 5a 05
    or a                ;0517 b7
    ret                 ;0518 c9
sub_0519h:
    push af             ;0519 f5
l051ah:
    in a,(14h)          ;051a db 14
    and 01h             ;051c e6 01
    jr nz,l0557h        ;051e 20 37
    in a,(14h)          ;0520 db 14
    and 08h             ;0522 e6 08
    jr nz,l051ah        ;0524 20 f4
    in a,(14h)          ;0526 db 14
    and 01h             ;0528 e6 01
    jr nz,l0557h        ;052a 20 2b
    in a,(14h)          ;052c db 14
    and 04h             ;052e e6 04
    jr z,l0557h         ;0530 28 25
    pop af              ;0532 f1
    out (11h),a         ;0533 d3 11
    in a,(15h)          ;0535 db 15
    or 02h              ;0537 f6 02
    out (15h),a         ;0539 d3 15
l053bh:
    in a,(14h)          ;053b db 14
    and 08h             ;053d e6 08
    jr nz,l0555h        ;053f 20 14
    in a,(14h)          ;0541 db 14
    and 04h             ;0543 e6 04
    jr nz,l053bh        ;0545 20 f4
    in a,(14h)          ;0547 db 14
    and 08h             ;0549 e6 08
    jr nz,l0555h        ;054b 20 08
    in a,(15h)          ;054d db 15
    and 0fdh            ;054f e6 fd
    out (15h),a         ;0551 d3 15
    scf                 ;0553 37
    ret                 ;0554 c9
l0555h:
    or a                ;0555 b7
    ret                 ;0556 c9
l0557h:
    pop af              ;0557 f1
    scf                 ;0558 37
    ret                 ;0559 c9
sub_055ah:
    in a,(14h)          ;055a db 14
    and 04h             ;055c e6 04
    jr nz,sub_055ah     ;055e 20 fa
    in a,(15h)          ;0560 db 15
    and 0edh            ;0562 e6 ed
    out (15h),a         ;0564 d3 15
    xor a               ;0566 af
    out (11h),a         ;0567 d3 11
    ret                 ;0569 c9
l056ah:
    call sub_05d8h      ;056a cd d8 05
    ld de,l0599h        ;056d 11 99 05
    ld hl,2bf5h         ;0570 21 f5 2b
    ld (2af3h),hl       ;0573 22 f3 2a
    ld b,12h            ;0576 06 12
    ld ix,l05abh        ;0578 dd 21 ab 05
l057ch:
    ld a,(de)           ;057c 1a
    cp (hl)             ;057d be
    jr z,l058ch         ;057e 28 0c
    inc de              ;0580 13
    inc ix              ;0581 dd 23
    inc ix              ;0583 dd 23
    djnz l057ch         ;0585 10 f5
    ld a,1fh            ;0587 3e 1f
    jp 05cfh            ;0589 c3 cf 05
l058ch:
    ld l,(ix+00h)       ;058c dd 6e 00
    ld h,(ix+01h)       ;058f dd 66 01
    call sub_0598h      ;0592 cd 98 05
    jp l0376h           ;0595 c3 76 03
sub_0598h:
    jp (hl)             ;0598 e9
l0599h:
    ld c,(hl)           ;0599 4e
    ld d,e              ;059a 53
    ld b,h              ;059b 44
    ld c,c              ;059c 49
    ld d,d              ;059d 52
    ld b,a              ;059e 47
    ld c,b              ;059f 48
    ld d,a              ;05a0 57
    dec l               ;05a1 2d
    ld d,(hl)           ;05a2 56
l05a3h:
    ld c,h              ;05a3 4c
    ld d,h              ;05a4 54
    ld hl,4250h         ;05a5 21 50 42
    ld d,l              ;05a8 55
    ld b,c              ;05a9 41
    ld b,e              ;05aa 43
l05abh:
    ld (bc),a           ;05ab 02
    djnz l05a3h         ;05ac 10 f5
    dec bc              ;05ae 0b
    ld l,e              ;05af 6b
    rrca                ;05b0 0f
    ld a,a              ;05b1 7f
    rrca                ;05b2 0f
    and b               ;05b3 a0
    rrca                ;05b4 0f
    ld c,b              ;05b5 48
    inc c               ;05b6 0c
    ld c,b              ;05b7 48
    inc c               ;05b8 0c
    ld c,b              ;05b9 48
    inc c               ;05ba 0c
    ld c,b              ;05bb 48
    inc c               ;05bc 0c
    add a,b             ;05bd 80
    rrca                ;05be 0f
    call pe,0a90eh      ;05bf ec 0e a9
    inc c               ;05c2 0c
    pop af              ;05c3 f1
    ld c,3fh            ;05c4 0e 3f
    djnz sub_0598h      ;05c6 10 d0
    djnz $-3            ;05c8 10 fb
    ld de,l12f1h        ;05ca 11 f1 12
    jp po,0cd0ch        ;05cd e2 0c cd
    in a,(05h)          ;05d0 db 05
    ld sp,4a93h         ;05d2 31 93 4a
    jp l0376h           ;05d5 c3 76 03
sub_05d8h:
    call sub_064ch      ;05d8 cd 4c 06
sub_05dbh:
    ld (l2050h),a       ;05db 32 50 20
    ld hl,l1a81h        ;05de 21 81 1a
l05e1h:
    bit 7,(hl)          ;05e1 cb 7e
    jr nz,l05f0h        ;05e3 20 0b
    cp (hl)             ;05e5 be
    jr z,l05f0h         ;05e6 28 08
    inc hl              ;05e8 23
l05e9h:
    bit 7,(hl)          ;05e9 cb 7e
    inc hl              ;05eb 23
    jr z,l05e9h         ;05ec 28 fb
    jr l05e1h           ;05ee 18 f1
l05f0h:
    ex de,hl            ;05f0 eb
    inc de              ;05f1 13
    push de             ;05f2 d5
    ld hl,2cf5h         ;05f3 21 f5 2c
    ld de,0000h         ;05f6 11 00 00
    call sub_0660h      ;05f9 cd 60 06
    ld (hl),2ch         ;05fc 36 2c
    inc hl              ;05fe 23
    pop de              ;05ff d1
l0600h:
    ld a,(de)           ;0600 1a
    and 7fh             ;0601 e6 7f
    ld (hl),a           ;0603 77
    cp 20h              ;0604 fe 20
    jr nc,l0623h        ;0606 30 1b
    push de             ;0608 d5
    ld de,l1baah        ;0609 11 aa 1b
    ld b,a              ;060c 47
l060dh:
    dec b               ;060d 05
    jr z,l0617h         ;060e 28 07
l0610h:
    ld a,(de)           ;0610 1a
    inc de              ;0611 13
    rla                 ;0612 17
    jr nc,l0610h        ;0613 30 fb
    jr l060dh           ;0615 18 f6
l0617h:
    ld a,(de)           ;0617 1a
    and 7fh             ;0618 e6 7f
    ld (hl),a           ;061a 77
    ld a,(de)           ;061b 1a
    inc hl              ;061c 23
    inc de              ;061d 13
    rla                 ;061e 17
    jr nc,l0617h        ;061f 30 f6
    pop de              ;0621 d1
    dec hl              ;0622 2b
l0623h:
    ld a,(de)           ;0623 1a
    rla                 ;0624 17
    inc hl              ;0625 23
    inc de              ;0626 13
    jr nc,l0600h        ;0627 30 d7
    ld (hl),2ch         ;0629 36 2c
    inc hl              ;062b 23
    ld a,(l2051h)       ;062c 3a 51 20
    ld de,(l2052h)      ;062f ed 5b 52 20
    call sub_0660h      ;0633 cd 60 06
    ld (hl),2ch         ;0636 36 2c
    inc hl              ;0638 23
    ld a,(l2054h)       ;0639 3a 54 20
    ld de,(l2055h)      ;063c ed 5b 55 20
    call sub_0660h      ;0640 cd 60 06
    ld (hl),0dh         ;0643 36 0d
    ld hl,2cf5h         ;0645 21 f5 2c
    ld (2af1h),hl       ;0648 22 f1 2a
    ret                 ;064b c9
sub_064ch:
    xor a               ;064c af
    ld (l2051h),a       ;064d 32 51 20
    ld (l2052h),a       ;0650 32 52 20
    ld (l2053h),a       ;0653 32 53 20
    ld (l2054h),a       ;0656 32 54 20
    ld (l2055h),a       ;0659 32 55 20
    ld (l2056h),a       ;065c 32 56 20
    ret                 ;065f c9
sub_0660h:
    ld ix,l06a9h        ;0660 dd 21 a9 06
    ld b,06h            ;0664 06 06
    ld iy,460fh         ;0666 fd 21 0f 46
    res 0,(iy+00h)      ;066a fd cb 00 86
    push hl             ;066e e5
    ex de,hl            ;066f eb
l0670h:
    ld e,(ix+01h)       ;0670 dd 5e 01
    ld d,(ix+02h)       ;0673 dd 56 02
    ld c,2fh            ;0676 0e 2f
l0678h:
    inc c               ;0678 0c
    sub (ix+00h)        ;0679 dd 96 00
    sbc hl,de           ;067c ed 52
    jr nc,l0678h        ;067e 30 f8
    add a,(ix+00h)      ;0680 dd 86 00
    adc hl,de           ;0683 ed 5a
    ld e,a              ;0685 5f
    ld a,c              ;0686 79
    cp 30h              ;0687 fe 30
    jr nz,l0696h        ;0689 20 0b
    bit 0,(iy+00h)      ;068b fd cb 00 46
    jr nz,l0696h        ;068f 20 05
    ld a,b              ;0691 78
    cp 02h              ;0692 fe 02
    jr nz,l069eh        ;0694 20 08
l0696h:
    set 0,(iy+00h)      ;0696 fd cb 00 c6
    ex (sp),hl          ;069a e3
    ld (hl),c           ;069b 71
    inc hl              ;069c 23
    ex (sp),hl          ;069d e3
l069eh:
    ld a,e              ;069e 7b
    inc ix              ;069f dd 23
    inc ix              ;06a1 dd 23
    inc ix              ;06a3 dd 23
    djnz l0670h         ;06a5 10 c9
    pop hl              ;06a7 e1
    ret                 ;06a8 c9
l06a9h:
    and b               ;06a9 a0
    add a,(hl)          ;06aa 86
    ld bc,2710h         ;06ab 01 10 27
    nop                 ;06ae 00
l06afh:
    ret pe              ;06af e8
    inc bc              ;06b0 03
    nop                 ;06b1 00
    ld h,h              ;06b2 64
    nop                 ;06b3 00
    nop                 ;06b4 00
    ld a,(bc)           ;06b5 0a
    nop                 ;06b6 00
    nop                 ;06b7 00
    ld bc,0000h         ;06b8 01 00 00
l06bbh:
    call sub_05d8h      ;06bb cd d8 05
    call sub_1689h      ;06be cd 89 16
    bit 7,(iy+28h)      ;06c1 fd cb 28 7e
    call nz,sub_08e7h   ;06c5 c4 e7 08
    ld iy,(2ae8h)       ;06c8 fd 2a e8 2a
    ld (iy+28h),000h    ;06cc fd 36 28 00
    ld (iy+27h),000h    ;06d0 fd 36 27 00
    ld (iy+26h),0ffh    ;06d4 fd 36 26 ff
    ld hl,2c75h         ;06d8 21 75 2c
l06dbh:
    ld a,(hl)           ;06db 7e
    cp 24h              ;06dc fe 24
    jp z,l1365h         ;06de ca 65 13
    cp 23h              ;06e1 fe 23
    jp z,l08d8h         ;06e3 ca d8 08
    cp 40h              ;06e6 fe 40
    jr nz,l06f1h        ;06e8 20 07
    set 5,(iy+28h)      ;06ea fd cb 28 ee
    inc hl              ;06ee 23
    jr l06dbh           ;06ef 18 ea
l06f1h:
    call sub_15e3h      ;06f1 cd e3 15
    ld (iy+00h),000h    ;06f4 fd 36 00 00
    ld a,(2ae7h)        ;06f8 3a e7 2a
    cp 02h              ;06fb fe 02
    jr nc,l0707h        ;06fd 30 08
    ld (iy+00h),002h    ;06ff fd 36 00 02
    set 0,(iy+28h)      ;0703 fd cb 28 c6
l0707h:
    ld a,(hl)           ;0707 7e
    cp 0dh              ;0708 fe 0d
    jr z,l0763h         ;070a 28 57
    cp 2ch              ;070c fe 2c
    inc hl              ;070e 23
    jr nz,l0707h        ;070f 20 f6
    ld a,(hl)           ;0711 7e
    ld b,00h            ;0712 06 00
    cp 53h              ;0714 fe 53
sub_0716h:
    jr z,l0748h         ;0716 28 30
    ld b,01h            ;0718 06 01
    cp 55h              ;071a fe 55
    jr z,l0748h         ;071c 28 2a
    ld b,02h            ;071e 06 02
    cp 50h              ;0720 fe 50
    jr z,l0748h         ;0722 28 24
    cp 57h              ;0724 fe 57
    jr z,l075dh         ;0726 28 35
    cp 41h              ;0728 fe 41
    jr z,l0757h         ;072a 28 2b
    cp 52h              ;072c fe 52
    jr nz,l0737h        ;072e 20 07
    inc hl              ;0730 23
    ld a,(hl)           ;0731 7e
    cp 45h              ;0732 fe 45
    jr nz,l0707h        ;0734 20 d1
    inc hl              ;0736 23
l0737h:
    cp 4ch              ;0737 fe 4c
    jr nz,l0707h        ;0739 20 cc
    ld b,03h            ;073b 06 03
    inc hl              ;073d 23
    ld a,(hl)           ;073e 7e
    cp 2ch              ;073f fe 2c
    jr nz,l0748h        ;0741 20 05
    inc hl              ;0743 23
    ld a,(hl)           ;0744 7e
    ld (iy+15h),a       ;0745 fd 77 15
l0748h:
    ld a,(iy+00h)       ;0748 fd 7e 00
    and 0fch            ;074b e6 fc
    or b                ;074d b0
    ld (iy+00h),a       ;074e fd 77 00
    set 0,(iy+28h)      ;0751 fd cb 28 c6
    jr l0707h           ;0755 18 b0
l0757h:
    set 4,(iy+28h)      ;0757 fd cb 28 e6
    jr l0707h           ;075b 18 aa
l075dh:
    set 3,(iy+28h)      ;075d fd cb 28 de
    jr l0707h           ;0761 18 a4
l0763h:
    ld a,(2ae7h)        ;0763 3a e7 2a
    cp 02h              ;0766 fe 02
    jr nc,l0775h        ;0768 30 0b
    res 3,(iy+28h)      ;076a fd cb 28 9e
    or a                ;076e b7
    jr z,l0775h         ;076f 28 04
    set 3,(iy+28h)      ;0771 fd cb 28 de
l0775h:
    bit 3,(iy+28h)      ;0775 fd cb 28 5e
    jp z,l0810h         ;0779 ca 10 08
l077ch:
    call sub_163bh      ;077c cd 3b 16
    ld a,21h            ;077f 3e 21
    jp c,05cfh          ;0781 da cf 05
    ld hl,2d45h         ;0784 21 45 2d
    ld a,(2d67h)        ;0787 3a 67 2d
    call 153dh          ;078a cd 3d 15
    ld iy,(2ae8h)       ;078d fd 2a e8 2a
    jr c,l07aah         ;0791 38 17
    bit 5,(iy+28h)      ;0793 fd cb 28 6e
    ld a,3fh            ;0797 3e 3f
    jp z,05cfh          ;0799 ca cf 05
    bit 6,(ix+00h)      ;079c dd cb 00 76
    ld a,1ah            ;07a0 3e 1a
    jp nz,05cfh         ;07a2 c2 cf 05
    call sub_16e3h      ;07a5 cd e3 16
    jr l07adh           ;07a8 18 03
l07aah:
    call sub_1586h      ;07aa cd 86 15
l07adh:
    push de             ;07ad d5
    push ix             ;07ae dd e5
    ld a,(2d67h)        ;07b0 3a 67 2d
    ld (iy+01h),a       ;07b3 fd 77 01
    ld (iy+23h),e       ;07b6 fd 73 23
    ld (iy+24h),d       ;07b9 fd 72 24
    set 7,(iy+00h)      ;07bc fd cb 00 fe
    set 7,(iy+28h)      ;07c0 fd cb 28 fe
    ld b,03h            ;07c4 06 03
    ld a,(iy+15h)       ;07c6 fd 7e 15
    ld (iy+25h),a       ;07c9 fd 77 25
    or a                ;07cc b7
    jr nz,l07d7h        ;07cd 20 08
    ld (iy+15h),0feh    ;07cf fd 36 15 fe
    ld (iy+25h),0feh    ;07d3 fd 36 25 fe
l07d7h:
    ld (iy+12h),0ffh    ;07d7 fd 36 12 ff
    ld (iy+20h),000h    ;07db fd 36 20 00
    inc iy              ;07df fd 23
    djnz l07d7h         ;07e1 10 f4
    ld hl,(2aeeh)       ;07e3 2a ee 2a
    ld b,80h            ;07e6 06 80
l07e8h:
    ld (hl),0ffh        ;07e8 36 ff
    inc hl              ;07ea 23
    djnz l07e8h         ;07eb 10 fb
    call sub_18eeh      ;07ed cd ee 18
    ld hl,(2ae8h)       ;07f0 2a e8 2a
    ld de,0002h         ;07f3 11 02 00
    add hl,de           ;07f6 19
    ex de,hl            ;07f7 eb
    ld hl,2d45h         ;07f8 21 45 2d
    ld bc,0010h         ;07fb 01 10 00
    ldir                ;07fe ed b0
    ld hl,(2ae8h)       ;0800 2a e8 2a
    pop de              ;0803 d1
    ld bc,0020h         ;0804 01 20 00
    ldir                ;0807 ed b0
    pop de              ;0809 d1
    call sub_1789h      ;080a cd 89 17
    jp l0376h           ;080d c3 76 03
l0810h:
    ld hl,2d45h         ;0810 21 45 2d
    ld a,(2d67h)        ;0813 3a 67 2d
    call 153dh          ;0816 cd 3d 15
    ld iy,(2ae8h)       ;0819 fd 2a e8 2a
    jr nc,l082eh        ;081d 30 0f
    ld a,(iy+00h)       ;081f fd 7e 00
    and 03h             ;0822 e6 03
    cp 03h              ;0824 fe 03
    jp z,l077ch         ;0826 ca 7c 07
    ld a,3eh            ;0829 3e 3e
    jp 05cfh            ;082b c3 cf 05
l082eh:
    bit 0,(iy+28h)      ;082e fd cb 28 46
    jr z,l0852h         ;0832 28 1e
    ld a,(iy+00h)       ;0834 fd 7e 00
    xor (ix+00h)        ;0837 dd ae 00
    and 03h             ;083a e6 03
    jr z,l0852h         ;083c 28 14
    ld hl,2d45h         ;083e 21 45 2d
    ld a,(2d67h)        ;0841 3a 67 2d
    call sub_1544h      ;0844 cd 44 15
    ld iy,(2ae8h)       ;0847 fd 2a e8 2a
    jr nc,l082eh        ;084b 30 e1
    ld a,40h            ;084d 3e 40
    jp 05cfh            ;084f c3 cf 05
l0852h:
    call sub_18beh      ;0852 cd be 18
    ld (iy+23h),e       ;0855 fd 73 23
    ld (iy+24h),d       ;0858 fd 72 24
    ld (iy+20h),000h    ;085b fd 36 20 00
    ld (iy+21h),000h    ;085f fd 36 21 00
    ld (iy+22h),000h    ;0863 fd 36 22 00
    set 7,(iy+28h)      ;0867 fd cb 28 fe
    ld b,20h            ;086b 06 20
l086dh:
    ld a,(ix+00h)       ;086d dd 7e 00
    ld (iy+00h),a       ;0870 fd 77 00
    inc ix              ;0873 dd 23
    inc iy              ;0875 fd 23
    djnz l086dh         ;0877 10 f4
    ld iy,(2ae8h)       ;0879 fd 2a e8 2a
    ld a,(iy+15h)       ;087d fd 7e 15
    ld (iy+25h),a       ;0880 fd 77 25
    bit 4,(iy+28h)      ;0883 fd cb 28 66
    jr nz,l08b3h        ;0887 20 2a
    ld a,(iy+12h)       ;0889 fd 7e 12
    and (iy+13h)        ;088c fd a6 13
    and (iy+14h)        ;088f fd a6 14
    inc a               ;0892 3c
    jr nz,l08aah        ;0893 20 15
    ld a,(iy+00h)       ;0895 fd 7e 00
    and 03h             ;0898 e6 03
    cp 03h              ;089a fe 03
    jr z,l08b0h         ;089c 28 12
    xor a               ;089e af
    ld (iy+12h),a       ;089f fd 77 12
    ld (iy+13h),a       ;08a2 fd 77 13
    ld (iy+14h),a       ;08a5 fd 77 14
    jr l08b0h           ;08a8 18 06
l08aah:
    call sub_0bcah      ;08aa cd ca 0b
    call sub_17e0h      ;08ad cd e0 17
l08b0h:
    jp l0376h           ;08b0 c3 76 03
l08b3h:
    ld a,(iy+12h)       ;08b3 fd 7e 12
    add a,01h           ;08b6 c6 01
    ld (iy+20h),a       ;08b8 fd 77 20
    ld a,(iy+13h)       ;08bb fd 7e 13
    adc a,00h           ;08be ce 00
    ld (iy+21h),a       ;08c0 fd 77 21
    ld a,(iy+14h)       ;08c3 fd 7e 14
    adc a,00h           ;08c6 ce 00
    ld (iy+22h),a       ;08c8 fd 77 22
    call sub_0bcah      ;08cb cd ca 0b
    ld a,(2d6bh)        ;08ce 3a 6b 2d
    or a                ;08d1 b7
    call nz,sub_17e0h   ;08d2 c4 e0 17
    jp l0376h           ;08d5 c3 76 03
l08d8h:
    set 7,(iy+28h)      ;08d8 fd cb 28 fe
    set 6,(iy+28h)      ;08dc fd cb 28 f6
    ld (iy+20h),000h    ;08e0 fd 36 20 00
    jp l0376h           ;08e4 c3 76 03
sub_08e7h:
    call sub_1689h      ;08e7 cd 89 16
    bit 7,(iy+28h)      ;08ea fd cb 28 7e
    ret z               ;08ee c8
    res 7,(iy+28h)      ;08ef fd cb 28 be
    call sub_0bcah      ;08f3 cd ca 0b
    bit 7,(iy+27h)      ;08f6 fd cb 27 7e
    call nz,sub_17ebh   ;08fa c4 eb 17
    bit 4,(iy+27h)      ;08fd fd cb 27 66
    jr nz,l0908h        ;0901 20 05
    bit 7,(iy+00h)      ;0903 fd cb 00 7e
    ret z               ;0907 c8
l0908h:
    ld e,(iy+23h)       ;0908 fd 5e 23
    ld d,(iy+24h)       ;090b fd 56 24
    push de             ;090e d5
    call sub_177eh      ;090f cd 7e 17
    res 7,(iy+00h)      ;0912 fd cb 00 be
    ld bc,0020h         ;0916 01 20 00
    ld a,e              ;0919 7b
    and 07h             ;091a e6 07
    add a,a             ;091c 87
    add a,a             ;091d 87
    add a,a             ;091e 87
    add a,a             ;091f 87
    add a,a             ;0920 87
    ld e,a              ;0921 5f
    ld d,00h            ;0922 16 00
    ld hl,2af5h         ;0924 21 f5 2a
    add hl,de           ;0927 19
    ex de,hl            ;0928 eb
    ld hl,(2ae8h)       ;0929 2a e8 2a
    ldir                ;092c ed b0
    pop de              ;092e d1
    jp sub_1789h        ;092f c3 89 17
sub_0932h:
    xor a               ;0932 af
l0933h:
    ld (2ae7h),a        ;0933 32 e7 2a
    push af             ;0936 f5
    call sub_08e7h      ;0937 cd e7 08
    pop af              ;093a f1
    inc a               ;093b 3c
    cp 0fh              ;093c fe 0f
    jr nz,l0933h        ;093e 20 f3
    ret                 ;0940 c9
l0941h:
    call sub_1689h      ;0941 cd 89 16
    bit 7,(iy+28h)      ;0944 fd cb 28 7e
    jp z,l0376h         ;0948 ca 76 03
    bit 6,(iy+28h)      ;094b fd cb 28 76
    jp nz,l09e9h        ;094f c2 e9 09
    bit 4,(iy+28h)      ;0952 fd cb 28 66
    jp nz,l0376h        ;0956 c2 76 03
    bit 3,(iy+28h)      ;0959 fd cb 28 5e
    jp nz,l0376h        ;095d c2 76 03
    bit 2,(iy+28h)      ;0960 fd cb 28 56
    jp nz,l0a11h        ;0964 c2 11 0a
    call sub_0bcah      ;0967 cd ca 0b
    ld a,(iy+00h)       ;096a fd 7e 00
    and 03h             ;096d e6 03
    cp 03h              ;096f fe 03
    jr nz,l097bh        ;0971 20 08
    call sub_10b0h      ;0973 cd b0 10
    ld a,32h            ;0976 3e 32
    jp nc,05cfh         ;0978 d2 cf 05
l097bh:
    ld a,(2d6bh)        ;097b 3a 6b 2d
    ld e,a              ;097e 5f
    ld d,00h            ;097f 16 00
    ld hl,(2aech)       ;0981 2a ec 2a
    add hl,de           ;0984 19
l0985h:
    ld a,(iy+00h)       ;0985 fd 7e 00
    and 03h             ;0988 e6 03
    cp 03h              ;098a fe 03
    jr nz,l099fh        ;098c 20 11
    dec (iy+25h)        ;098e fd 35 25
    jr nz,l099fh        ;0991 20 0c
    ld a,(iy+15h)       ;0993 fd 7e 15
    ld (iy+25h),a       ;0996 fd 77 25
    in a,(15h)          ;0999 db 15
    or 10h              ;099b f6 10
    out (15h),a         ;099d d3 15
l099fh:
    ld a,(iy+20h)       ;099f fd 7e 20
    cp (iy+12h)         ;09a2 fd be 12
    jr nz,l09b7h        ;09a5 20 10
    ld a,(iy+21h)       ;09a7 fd 7e 21
    cp (iy+13h)         ;09aa fd be 13
    jr nz,l09b7h        ;09ad 20 08
    ld a,(iy+22h)       ;09af fd 7e 22
    cp (iy+14h)         ;09b2 fd be 14
    jr z,l09dah         ;09b5 28 23
l09b7h:
    ld a,(hl)           ;09b7 7e
    call sub_0519h      ;09b8 cd 19 05
    jp c,l09e3h         ;09bb da e3 09
    inc hl              ;09be 23
    inc (iy+20h)        ;09bf fd 34 20
    jr nz,l09d5h        ;09c2 20 11
    inc (iy+21h)        ;09c4 fd 34 21
    jr nz,l09cch        ;09c7 20 03
    inc (iy+22h)        ;09c9 fd 34 22
l09cch:
    call sub_0bcah      ;09cc cd ca 0b
    call sub_17e0h      ;09cf cd e0 17
    ld hl,(2aech)       ;09d2 2a ec 2a
l09d5h:
    call sub_055ah      ;09d5 cd 5a 05
    jr l0985h           ;09d8 18 ab
l09dah:
    ld a,(hl)           ;09da 7e
    call sub_0508h      ;09db cd 08 05
    jp c,l0376h         ;09de da 76 03
    jr l09dah           ;09e1 18 f7
l09e3h:
    inc (iy+25h)        ;09e3 fd 34 25
    jp l0376h           ;09e6 c3 76 03
l09e9h:
    ld hl,(2aech)       ;09e9 2a ec 2a
    ld c,(iy+20h)       ;09ec fd 4e 20
    ld b,00h            ;09ef 06 00
    add hl,bc           ;09f1 09
    ld a,(iy+25h)       ;09f2 fd 7e 25
    cp c                ;09f5 b9
    jr z,l0a04h         ;09f6 28 0c
    ld a,(hl)           ;09f8 7e
    call sub_0510h      ;09f9 cd 10 05
    jp c,l0376h         ;09fc da 76 03
    inc (iy+20h)        ;09ff fd 34 20
    jr l09e9h           ;0a02 18 e5
l0a04h:
    ld a,(hl)           ;0a04 7e
    call sub_0508h      ;0a05 cd 08 05
    jp c,l0376h         ;0a08 da 76 03
    ld (iy+20h),000h    ;0a0b fd 36 20 00
    jr l09e9h           ;0a0f 18 d8
l0a11h:
    ld hl,(45f0h)       ;0a11 2a f0 45
    ld a,(45f2h)        ;0a14 3a f2 45
    cp l                ;0a17 bd
    jr z,l0a3fh         ;0a18 28 25
    ld a,(hl)           ;0a1a 7e
    call sub_0519h      ;0a1b cd 19 05
    jp c,l0376h         ;0a1e da 76 03
    inc hl              ;0a21 23
    ld (45f0h),hl       ;0a22 22 f0 45
    ld a,(45f2h)        ;0a25 3a f2 45
    cp l                ;0a28 bd
    jr z,l0a30h         ;0a29 28 05
    call sub_055ah      ;0a2b cd 5a 05
    jr l0a11h           ;0a2e 18 e1
l0a30h:
    ld hl,(45f4h)       ;0a30 2a f4 45
    ld a,l              ;0a33 7d
    or h                ;0a34 b4
    push af             ;0a35 f5
    call nz,sub_140fh   ;0a36 c4 0f 14
    call sub_055ah      ;0a39 cd 5a 05
    pop af              ;0a3c f1
    jr nz,l0a11h        ;0a3d 20 d2
l0a3fh:
    xor a               ;0a3f af
    call sub_0508h      ;0a40 cd 08 05
    jr nc,l0a3fh        ;0a43 30 fa
    jp l0376h           ;0a45 c3 76 03
l0a48h:
    call sub_1689h      ;0a48 cd 89 16
    bit 7,(iy+28h)      ;0a4b fd cb 28 7e
    jp z,l0376h         ;0a4f ca 76 03
    bit 6,(iy+28h)      ;0a52 fd cb 28 76
    jp nz,l0bb5h        ;0a56 c2 b5 0b
    ld a,(iy+00h)       ;0a59 fd 7e 00
    and 03h             ;0a5c e6 03
    cp 03h              ;0a5e fe 03
    jr z,l0aafh         ;0a60 28 4d
    bit 3,(iy+28h)      ;0a62 fd cb 28 5e
    jr nz,l0a6fh        ;0a66 20 07
    bit 4,(iy+28h)      ;0a68 fd cb 28 66
    jp z,l0376h         ;0a6c ca 76 03
l0a6fh:
    call sub_0bcah      ;0a6f cd ca 0b
    ld a,(2d6bh)        ;0a72 3a 6b 2d
    ld e,a              ;0a75 5f
    ld d,00h            ;0a76 16 00
    ld hl,(2aech)       ;0a78 2a ec 2a
    add hl,de           ;0a7b 19
l0a7ch:
    call sub_04c1h      ;0a7c cd c1 04
    jp c,l0376h         ;0a7f da 76 03
    ld (hl),a           ;0a82 77
    set 7,(iy+27h)      ;0a83 fd cb 27 fe
    set 4,(iy+27h)      ;0a87 fd cb 27 e6
    inc hl              ;0a8b 23
    inc (iy+12h)        ;0a8c fd 34 12
    jr nz,l0a99h        ;0a8f 20 08
    inc (iy+13h)        ;0a91 fd 34 13
    jr nz,l0a99h        ;0a94 20 03
    inc (iy+14h)        ;0a96 fd 34 14
l0a99h:
    inc (iy+20h)        ;0a99 fd 34 20
    jr nz,l0a7ch        ;0a9c 20 de
    inc (iy+21h)        ;0a9e fd 34 21
    jr nz,l0aa6h        ;0aa1 20 03
    inc (iy+22h)        ;0aa3 fd 34 22
l0aa6h:
    call sub_17ebh      ;0aa6 cd eb 17
    res 7,(iy+27h)      ;0aa9 fd cb 27 be
    jr l0a6fh           ;0aad 18 c0
l0aafh:
    call sub_04c1h      ;0aaf cd c1 04
    jp c,l0376h         ;0ab2 da 76 03
    push af             ;0ab5 f5
    call sub_05d8h      ;0ab6 cd d8 05
    call sub_0bcah      ;0ab9 cd ca 0b
    call sub_10b0h      ;0abc cd b0 10
    jp c,l0b4bh         ;0abf da 4b 0b
    ld l,(iy+20h)       ;0ac2 fd 6e 20
    ld h,(iy+21h)       ;0ac5 fd 66 21
    ld a,(iy+22h)       ;0ac8 fd 7e 22
    push af             ;0acb f5
    push hl             ;0acc e5
    ld a,(iy+12h)       ;0acd fd 7e 12
    add a,01h           ;0ad0 c6 01
    ld (iy+20h),a       ;0ad2 fd 77 20
    ld a,(iy+13h)       ;0ad5 fd 7e 13
    adc a,00h           ;0ad8 ce 00
    ld (iy+21h),a       ;0ada fd 77 21
    ld a,(iy+14h)       ;0add fd 7e 14
    adc a,00h           ;0ae0 ce 00
    ld (iy+22h),a       ;0ae2 fd 77 22
    call sub_0bcah      ;0ae5 cd ca 0b
    call sub_17e0h      ;0ae8 cd e0 17
    ld c,(iy+20h)       ;0aeb fd 4e 20
    ld b,00h            ;0aee 06 00
    ld hl,(2aech)       ;0af0 2a ec 2a
    add hl,bc           ;0af3 09
l0af4h:
    pop de              ;0af4 d1
    pop bc              ;0af5 c1
    push bc             ;0af6 c5
    push de             ;0af7 d5
    ld a,(iy+20h)       ;0af8 fd 7e 20
    cp e                ;0afb bb
    ld a,(iy+21h)       ;0afc fd 7e 21
    sbc a,d             ;0aff 9a
    ld a,(iy+22h)       ;0b00 fd 7e 22
    sbc a,b             ;0b03 98
    jr nc,l0b2bh        ;0b04 30 25
    ld a,0ffh           ;0b06 3e ff
    ld b,(iy+15h)       ;0b08 fd 46 15
l0b0bh:
    ld (hl),a           ;0b0b 77
    inc hl              ;0b0c 23
    inc (iy+20h)        ;0b0d fd 34 20
    jr nz,l0b25h        ;0b10 20 13
    inc (iy+21h)        ;0b12 fd 34 21
    jr nz,l0b1ah        ;0b15 20 03
    inc (iy+22h)        ;0b17 fd 34 22
l0b1ah:
    push bc             ;0b1a c5
    call sub_17ebh      ;0b1b cd eb 17
    call sub_0bcah      ;0b1e cd ca 0b
    pop bc              ;0b21 c1
    ld hl,(2aech)       ;0b22 2a ec 2a
l0b25h:
    ld a,0dh            ;0b25 3e 0d
    djnz l0b0bh         ;0b27 10 e2
    jr l0af4h           ;0b29 18 c9
l0b2bh:
    pop hl              ;0b2b e1
    pop hl              ;0b2c e1
    ld a,(iy+15h)       ;0b2d fd 7e 15
    dec a               ;0b30 3d
    add a,(iy+20h)      ;0b31 fd 86 20
    ld (iy+12h),a       ;0b34 fd 77 12
    ld a,(iy+21h)       ;0b37 fd 7e 21
    adc a,00h           ;0b3a ce 00
    ld (iy+13h),a       ;0b3c fd 77 13
    ld a,(iy+22h)       ;0b3f fd 7e 22
    adc a,00h           ;0b42 ce 00
    ld (iy+14h),a       ;0b44 fd 77 14
    set 4,(iy+27h)      ;0b47 fd cb 27 e6
l0b4bh:
    call sub_0bcah      ;0b4b cd ca 0b
    ld bc,(2d6bh)       ;0b4e ed 4b 6b 2d
    ld b,00h            ;0b52 06 00
    ld hl,(2aech)       ;0b54 2a ec 2a
    add hl,bc           ;0b57 09
    pop af              ;0b58 f1
    jr l0b66h           ;0b59 18 0b
l0b5bh:
    call sub_04c1h      ;0b5b cd c1 04
    jr nc,l0b66h        ;0b5e 30 06
    call sub_17ebh      ;0b60 cd eb 17
    jp l0376h           ;0b63 c3 76 03
l0b66h:
    ld c,a              ;0b66 4f
    ld a,(iy+25h)       ;0b67 fd 7e 25
    or a                ;0b6a b7
    ld a,c              ;0b6b 79
    push af             ;0b6c f5
    push iy             ;0b6d fd e5
    ld a,33h            ;0b6f 3e 33
    call z,sub_05dbh    ;0b71 cc db 05
    pop iy              ;0b74 fd e1
    pop af              ;0b76 f1
    call nz,sub_0b94h   ;0b77 c4 94 0b
    ld a,(456fh)        ;0b7a 3a 6f 45
    or a                ;0b7d b7
    jr z,l0b5bh         ;0b7e 28 db
l0b80h:
    ld a,(iy+25h)       ;0b80 fd 7e 25
    or a                ;0b83 b7
    jr z,l0b8ch         ;0b84 28 06
    xor a               ;0b86 af
    call sub_0b94h      ;0b87 cd 94 0b
    jr l0b80h           ;0b8a 18 f4
l0b8ch:
    ld a,(iy+15h)       ;0b8c fd 7e 15
    ld (iy+25h),a       ;0b8f fd 77 25
    jr l0b5bh           ;0b92 18 c7
sub_0b94h:
    ld (hl),a           ;0b94 77
    dec (iy+25h)        ;0b95 fd 35 25
    inc hl              ;0b98 23
    inc (iy+20h)        ;0b99 fd 34 20
    ret nz              ;0b9c c0
    inc (iy+21h)        ;0b9d fd 34 21
    jr nz,l0ba5h        ;0ba0 20 03
    inc (iy+22h)        ;0ba2 fd 34 22
l0ba5h:
    call sub_17ebh      ;0ba5 cd eb 17
    call sub_0bcah      ;0ba8 cd ca 0b
    call sub_10b0h      ;0bab cd b0 10
    call c,sub_17e0h    ;0bae dc e0 17
    ld hl,(2aech)       ;0bb1 2a ec 2a
    ret                 ;0bb4 c9
l0bb5h:
    call sub_04c1h      ;0bb5 cd c1 04
    jp c,l0376h         ;0bb8 da 76 03
    ld hl,(2aech)       ;0bbb 2a ec 2a
    ld c,(iy+20h)       ;0bbe fd 4e 20
    inc (iy+20h)        ;0bc1 fd 34 20
    ld b,00h            ;0bc4 06 00
    add hl,bc           ;0bc6 09
    ld (hl),a           ;0bc7 77
    jr l0bb5h           ;0bc8 18 eb
sub_0bcah:
    ld iy,(2ae8h)       ;0bca fd 2a e8 2a
    ld a,(iy+20h)       ;0bce fd 7e 20
    ld (2d6bh),a        ;0bd1 32 6b 2d
    ld l,(iy+21h)       ;0bd4 fd 6e 21
    ld h,(iy+22h)       ;0bd7 fd 66 22
    ld a,l              ;0bda 7d
    and 07h             ;0bdb e6 07
    ld (2d6ch),a        ;0bdd 32 6c 2d
    ld b,03h            ;0be0 06 03
    call sub_1a7ah      ;0be2 cd 7a 1a
    ld a,l              ;0be5 7d
    and 7fh             ;0be6 e6 7f
    ld (2d6ah),a        ;0be8 32 6a 2d
    ld b,07h            ;0beb 06 07
    call sub_1a7ah      ;0bed cd 7a 1a
    ld a,l              ;0bf0 7d
    ld (2d6dh),a        ;0bf1 32 6d 2d
    ret                 ;0bf4 c9
    call sub_1625h      ;0bf5 cd 25 16
l0bf8h:
    call sub_15e3h      ;0bf8 cd e3 15
    push hl             ;0bfb e5
    ld a,0fh            ;0bfc 3e 0f
    ld (2ae7h),a        ;0bfe 32 e7 2a
    call sub_1689h      ;0c01 cd 89 16
    ld a,(2d67h)        ;0c04 3a 67 2d
    ld c,a              ;0c07 4f
    ld hl,2d45h         ;0c08 21 45 2d
    call 153dh          ;0c0b cd 3d 15
    jr c,l0c38h         ;0c0e 38 28
l0c10h:
    bit 6,(ix+00h)      ;0c10 dd cb 00 76
    jr nz,l0c2ch        ;0c14 20 16
    bit 7,(ix+00h)      ;0c16 dd cb 00 7e
    jr nz,l0c2ch        ;0c1a 20 10
    ld hl,l2051h        ;0c1c 21 51 20
    inc (hl)            ;0c1f 34
    ld (ix+01h),0ffh    ;0c20 dd 36 01 ff
    push de             ;0c24 d5
    call sub_16e3h      ;0c25 cd e3 16
    pop de              ;0c28 d1
    call sub_1789h      ;0c29 cd 89 17
l0c2ch:
    ld hl,2d45h         ;0c2c 21 45 2d
    ld a,(2d67h)        ;0c2f 3a 67 2d
    ld c,a              ;0c32 4f
    call sub_1544h      ;0c33 cd 44 15
    jr nc,l0c10h        ;0c36 30 d8
l0c38h:
    pop hl              ;0c38 e1
l0c39h:
    ld a,(hl)           ;0c39 7e
    inc hl              ;0c3a 23
    cp 2ch              ;0c3b fe 2c
    jr z,l0bf8h         ;0c3d 28 b9
    cp 0dh              ;0c3f fe 0d
    jr nz,l0c39h        ;0c41 20 f6
    ld a,01h            ;0c43 3e 01
    jp sub_05dbh        ;0c45 c3 db 05
    call sub_1625h      ;0c48 cd 25 16
    call sub_15e3h      ;0c4b cd e3 15
    ld a,(2d67h)        ;0c4e 3a 67 2d
    ld hl,2d45h         ;0c51 21 45 2d
    call 153dh          ;0c54 cd 3d 15
l0c57h:
    ret c               ;0c57 d8
    ld hl,2bf5h         ;0c58 21 f5 2b
l0c5bh:
    ld a,(hl)           ;0c5b 7e
    inc hl              ;0c5c 23
    cp 0dh              ;0c5d fe 0d
    ret z               ;0c5f c8
    cp 2dh              ;0c60 fe 2d
    jr z,l0c82h         ;0c62 28 1e
    cp 48h              ;0c64 fe 48
    jr nz,l0c6eh        ;0c66 20 06
    set 5,(ix+00h)      ;0c68 dd cb 00 ee
    jr l0c9bh           ;0c6c 18 2d
l0c6eh:
    cp 57h              ;0c6e fe 57
    jr nz,l0c78h        ;0c70 20 06
    set 6,(ix+00h)      ;0c72 dd cb 00 f6
    jr l0c9bh           ;0c76 18 23
l0c78h:
    cp 47h              ;0c78 fe 47
    jr nz,l0c5bh        ;0c7a 20 df
    set 4,(ix+00h)      ;0c7c dd cb 00 e6
    jr l0c9bh           ;0c80 18 19
l0c82h:
    ld a,(hl)           ;0c82 7e
    cp 48h              ;0c83 fe 48
    jr nz,l0c8bh        ;0c85 20 04
    res 5,(ix+00h)      ;0c87 dd cb 00 ae
l0c8bh:
    cp 57h              ;0c8b fe 57
    jr nz,l0c93h        ;0c8d 20 04
    res 6,(ix+00h)      ;0c8f dd cb 00 b6
l0c93h:
    cp 47h              ;0c93 fe 47
    jr nz,l0c9bh        ;0c95 20 04
    res 4,(ix+00h)      ;0c97 dd cb 00 a6
l0c9bh:
    call sub_1789h      ;0c9b cd 89 17
    ld hl,2d45h         ;0c9e 21 45 2d
    ld a,(2d67h)        ;0ca1 3a 67 2d
    call sub_1544h      ;0ca4 cd 44 15
    jr l0c57h           ;0ca7 18 ae
    call sub_1625h      ;0ca9 cd 25 16
    call sub_15e3h      ;0cac cd e3 15
    ld a,(hl)           ;0caf 7e
    inc hl              ;0cb0 23
    cp 2ch              ;0cb1 fe 2c
    jr nz,l0cddh        ;0cb3 20 28
    ld a,(hl)           ;0cb5 7e
    sub 30h             ;0cb6 d6 30
    jr c,l0cddh         ;0cb8 38 23
    cp 0ah              ;0cba fe 0a
    jr nc,l0cddh        ;0cbc 30 1f
    ld c,a              ;0cbe 4f
    push bc             ;0cbf c5
    ld a,(2d67h)        ;0cc0 3a 67 2d
    ld hl,2d45h         ;0cc3 21 45 2d
    call 153dh          ;0cc6 cd 3d 15
l0cc9h:
    pop bc              ;0cc9 c1
    ret c               ;0cca d8
    ld (ix+01h),c       ;0ccb dd 71 01
    push bc             ;0cce c5
    call sub_1789h      ;0ccf cd 89 17
    ld a,(2d67h)        ;0cd2 3a 67 2d
    ld hl,2d45h         ;0cd5 21 45 2d
    call sub_1544h      ;0cd8 cd 44 15
    jr l0cc9h           ;0cdb 18 ec
l0cddh:
    ld a,1eh            ;0cdd 3e 1e
    jp 05cfh            ;0cdf c3 cf 05
    call sub_1625h      ;0ce2 cd 25 16
    call sub_15e3h      ;0ce5 cd e3 15
    push hl             ;0ce8 e5
    ld a,0fh            ;0ce9 3e 0f
    ld (2ae7h),a        ;0ceb 32 e7 2a
    call sub_1689h      ;0cee cd 89 16
    ld a,(2d67h)        ;0cf1 3a 67 2d
    ld (iy+01h),a       ;0cf4 fd 77 01
    ld (iy+28h),000h    ;0cf7 fd 36 28 00
    ld (iy+27h),000h    ;0cfb fd 36 27 00
    ld (iy+26h),0ffh    ;0cff fd 36 26 ff
    ld hl,(2ae8h)       ;0d03 2a e8 2a
    ld de,0002h         ;0d06 11 02 00
    add hl,de           ;0d09 19
    ex de,hl            ;0d0a eb
    ld hl,2d45h         ;0d0b 21 45 2d
    ld bc,0010h         ;0d0e 01 10 00
    ldir                ;0d11 ed b0
    call sub_163bh      ;0d13 cd 3b 16
    ld a,21h            ;0d16 3e 21
    jp c,05cfh          ;0d18 da cf 05
    pop hl              ;0d1b e1
    ld a,(hl)           ;0d1c 7e
    cp 3dh              ;0d1d fe 3d
    ld a,1eh            ;0d1f 3e 1e
    jp nz,05cfh         ;0d21 c2 cf 05
    inc hl              ;0d24 23
    call sub_15e3h      ;0d25 cd e3 15
    push hl             ;0d28 e5
    ld a,(2d67h)        ;0d29 3a 67 2d
    cp (iy+01h)         ;0d2c fd be 01
    jr nz,l0d84h        ;0d2f 20 53
    ld b,10h            ;0d31 06 10
    ld hl,(2ae8h)       ;0d33 2a e8 2a
    ld de,0002h         ;0d36 11 02 00
    add hl,de           ;0d39 19
    ld de,2d45h         ;0d3a 11 45 2d
l0d3dh:
    ld a,(de)           ;0d3d 1a
    cp (hl)             ;0d3e be
    jr nz,l0d84h        ;0d3f 20 43
    inc hl              ;0d41 23
    inc de              ;0d42 13
    djnz l0d3dh         ;0d43 10 f8
    ld a,(2d67h)        ;0d45 3a 67 2d
    ld hl,2d45h         ;0d48 21 45 2d
    call 153dh          ;0d4b cd 3d 15
    ld a,3eh            ;0d4e 3e 3e
    jp c,05cfh          ;0d50 da cf 05
    ld iy,(2ae8h)       ;0d53 fd 2a e8 2a
    ld (iy+23h),e       ;0d57 fd 73 23
    ld (iy+24h),d       ;0d5a fd 72 24
    push ix             ;0d5d dd e5
    pop hl              ;0d5f e1
    ld de,(2ae8h)       ;0d60 ed 5b e8 2a
    ld bc,0020h         ;0d64 01 20 00
    ldir                ;0d67 ed b0
    ld a,(iy+12h)       ;0d69 fd 7e 12
    add a,01h           ;0d6c c6 01
    ld (iy+20h),a       ;0d6e fd 77 20
    ld a,(iy+13h)       ;0d71 fd 7e 13
    adc a,00h           ;0d74 ce 00
    ld (iy+21h),a       ;0d76 fd 77 21
    ld a,(iy+14h)       ;0d79 fd 7e 14
    adc a,00h           ;0d7c ce 00
    ld (iy+22h),a       ;0d7e fd 77 22
    jp l0ea5h           ;0d81 c3 a5 0e
l0d84h:
    ld hl,(2ae8h)       ;0d84 2a e8 2a
    ld de,0002h         ;0d87 11 02 00
    add hl,de           ;0d8a 19
    ld a,(iy+01h)       ;0d8b fd 7e 01
    call 153dh          ;0d8e cd 3d 15
    ld a,3fh            ;0d91 3e 3f
    jp nc,05cfh         ;0d93 d2 cf 05
    call sub_1586h      ;0d96 cd 86 15
    ld iy,(2ae8h)       ;0d99 fd 2a e8 2a
    ld (iy+23h),e       ;0d9d fd 73 23
    ld (iy+24h),d       ;0da0 fd 72 24
    set 5,(iy+27h)      ;0da3 fd cb 27 ee
    ld (iy+20h),000h    ;0da7 fd 36 20 00
    ld (iy+21h),000h    ;0dab fd 36 21 00
    ld (iy+22h),000h    ;0daf fd 36 22 00
    ld hl,(2aeeh)       ;0db3 2a ee 2a
    ld b,80h            ;0db6 06 80
l0db8h:
    ld (hl),0ffh        ;0db8 36 ff
    inc hl              ;0dba 23
    djnz l0db8h         ;0dbb 10 fb
    ld a,(2d67h)        ;0dbd 3a 67 2d
    ld hl,2d45h         ;0dc0 21 45 2d
    call 153dh          ;0dc3 cd 3d 15
    ld a,3eh            ;0dc6 3e 3e
    jp c,05cfh          ;0dc8 da cf 05
    ld iy,(2ae8h)       ;0dcb fd 2a e8 2a
    ld a,(ix+00h)       ;0dcf dd 7e 00
    ld (iy+00h),a       ;0dd2 fd 77 00
    ld a,(ix+15h)       ;0dd5 dd 7e 15
    ld (iy+15h),a       ;0dd8 fd 77 15
l0ddbh:
    ld (460dh),de       ;0ddb ed 53 0d 46
    ld bc,0ffffh        ;0ddf 01 ff ff
l0de2h:
    inc bc              ;0de2 03
    push bc             ;0de3 c5
    ld a,b              ;0de4 78
    and 03h             ;0de5 e6 03
    or c                ;0de7 b1
    jr nz,l0e0dh        ;0de8 20 23
    ld hl,4810h         ;0dea 21 10 48
    ld (2aeeh),hl       ;0ded 22 ee 2a
    ld (2aeah),hl       ;0df0 22 ea 2a
    ld de,(460dh)       ;0df3 ed 5b 0d 46
    call sub_18beh      ;0df7 cd be 18
    ld hl,4810h         ;0dfa 21 10 48
    pop bc              ;0dfd c1
    push bc             ;0dfe c5
    srl b               ;0dff cb 38
    ld e,b              ;0e01 58
    res 0,e             ;0e02 cb 83
    ld d,00h            ;0e04 16 00
    add hl,de           ;0e06 19
    ld e,(hl)           ;0e07 5e
    inc hl              ;0e08 23
    ld d,(hl)           ;0e09 56
    call sub_17b5h      ;0e0a cd b5 17
l0e0dh:
    pop de              ;0e0d d1
    push de             ;0e0e d5
    rr d                ;0e0f cb 1a
    rr e                ;0e11 cb 1b
    rr d                ;0e13 cb 1a
    rr e                ;0e15 cb 1b
    res 0,e             ;0e17 cb 83
    ld d,00h            ;0e19 16 00
    ld hl,4810h         ;0e1b 21 10 48
    add hl,de           ;0e1e 19
    ld e,(hl)           ;0e1f 5e
    inc hl              ;0e20 23
    ld d,(hl)           ;0e21 56
    ex de,hl            ;0e22 eb
    pop bc              ;0e23 c1
    push bc             ;0e24 c5
    ld a,c              ;0e25 79
    and 07h             ;0e26 e6 07
    ld e,a              ;0e28 5f
    xor a               ;0e29 af
    ld d,a              ;0e2a 57
    add hl,hl           ;0e2b 29
    adc a,a             ;0e2c 8f
    add hl,hl           ;0e2d 29
    adc a,a             ;0e2e 8f
    add hl,hl           ;0e2f 29
    adc a,a             ;0e30 8f
    add hl,de           ;0e31 19
    ld b,a              ;0e32 47
    ld de,(l2031h)      ;0e33 ed 5b 31 20
    ld a,(l2033h)       ;0e37 3a 33 20
    add hl,de           ;0e3a 19
    add a,b             ;0e3b 80
    ex de,hl            ;0e3c eb
    ld hl,l2004h        ;0e3d 21 04 20
    ld b,(hl)           ;0e40 46
    ld hl,4710h         ;0e41 21 10 47
    call sub_1982h      ;0e44 cd 82 19
    call sub_1689h      ;0e47 cd 89 16
    call sub_0bcah      ;0e4a cd ca 0b
    ld b,00h            ;0e4d 06 00
    pop de              ;0e4f d1
    push de             ;0e50 d5
    ld a,(ix+13h)       ;0e51 dd 7e 13
sub_0e54h:
    cp e                ;0e54 bb
    jr nz,l0e61h        ;0e55 20 0a
    ld a,(ix+14h)       ;0e57 dd 7e 14
    cp d                ;0e5a ba
    jr nz,l0e61h        ;0e5b 20 04
    ld b,(ix+12h)       ;0e5d dd 46 12
    inc b               ;0e60 04
l0e61h:
    ld a,(2d6bh)        ;0e61 3a 6b 2d
    ld e,a              ;0e64 5f
    ld d,00h            ;0e65 16 00
    ld hl,(2aech)       ;0e67 2a ec 2a
    add hl,de           ;0e6a 19
    ld de,4710h         ;0e6b 11 10 47
l0e6eh:
    ld a,(de)           ;0e6e 1a
    ld (hl),a           ;0e6f 77
    set 7,(iy+27h)      ;0e70 fd cb 27 fe
    inc hl              ;0e74 23
    inc de              ;0e75 13
    inc (iy+20h)        ;0e76 fd 34 20
    jr nz,l0e94h        ;0e79 20 19
    inc (iy+21h)        ;0e7b fd 34 21
    jr nz,l0e83h        ;0e7e 20 03
    inc (iy+22h)        ;0e80 fd 34 22
l0e83h:
    push bc             ;0e83 c5
    push de             ;0e84 d5
    call sub_17ebh      ;0e85 cd eb 17
    res 7,(iy+27h)      ;0e88 fd cb 27 be
    call sub_0bcah      ;0e8c cd ca 0b
    ld hl,(2aech)       ;0e8f 2a ec 2a
    pop de              ;0e92 d1
    pop bc              ;0e93 c1
l0e94h:
    djnz l0e6eh         ;0e94 10 d8
    pop bc              ;0e96 c1
    ld a,(ix+13h)       ;0e97 dd 7e 13
    cp c                ;0e9a b9
    jp nz,l0de2h        ;0e9b c2 e2 0d
    ld a,(ix+14h)       ;0e9e dd 7e 14
    cp b                ;0ea1 b8
    jp nz,l0de2h        ;0ea2 c2 e2 0d
l0ea5h:
    pop hl              ;0ea5 e1
l0ea6h:
    ld a,(hl)           ;0ea6 7e
    inc hl              ;0ea7 23
    cp 0dh              ;0ea8 fe 0d
    jr z,l0ec5h         ;0eaa 28 19
    cp 2ch              ;0eac fe 2c
    jr nz,l0ea6h        ;0eae 20 f6
    call sub_15e3h      ;0eb0 cd e3 15
    push hl             ;0eb3 e5
    ld hl,2d45h         ;0eb4 21 45 2d
    ld a,(2d67h)        ;0eb7 3a 67 2d
    call 153dh          ;0eba cd 3d 15
    jp nc,l0ddbh        ;0ebd d2 db 0d
    ld a,3eh            ;0ec0 3e 3e
    jp 05cfh            ;0ec2 c3 cf 05
l0ec5h:
    ld iy,(2ae8h)       ;0ec5 fd 2a e8 2a
    ld a,(iy+20h)       ;0ec9 fd 7e 20
    sub 01h             ;0ecc d6 01
    ld (iy+12h),a       ;0ece fd 77 12
    ld a,(iy+21h)       ;0ed1 fd 7e 21
    sbc a,00h           ;0ed4 de 00
    ld (iy+13h),a       ;0ed6 fd 77 13
    ld a,(iy+22h)       ;0ed9 fd 7e 22
    sbc a,00h           ;0edc de 00
    ld (iy+14h),a       ;0ede fd 77 14
    set 7,(iy+28h)      ;0ee1 fd cb 28 fe
    set 7,(iy+00h)      ;0ee5 fd cb 00 fe
    jp sub_08e7h        ;0ee9 c3 e7 08
    ld a,1fh            ;0eec 3e 1f
    jp 05cfh            ;0eee c3 cf 05
    ld hl,2bf6h         ;0ef1 21 f6 2b
    ld a,(hl)           ;0ef4 7e
    inc hl              ;0ef5 23
    ld ix,l0f19h        ;0ef6 dd 21 19 0f
    ld b,04h            ;0efa 06 04
l0efch:
    cp (ix+00h)         ;0efc dd be 00
    jr z,l0f0eh         ;0eff 28 0d
    inc ix              ;0f01 dd 23
    inc ix              ;0f03 dd 23
    inc ix              ;0f05 dd 23
    djnz l0efch         ;0f07 10 f3
    ld a,1fh            ;0f09 3e 1f
    jp 05cfh            ;0f0b c3 cf 05
l0f0eh:
    ld e,(ix+01h)       ;0f0e dd 5e 01
    ld d,(ix+02h)       ;0f11 dd 56 02
    push de             ;0f14 d5
    pop iy              ;0f15 fd e1
    jp (iy)             ;0f17 fd e9
l0f19h:
    ld b,h              ;0f19 44
    ld (hl),0fh         ;0f1a 36 0f
    ld c,b              ;0f1c 48
    ld c,a              ;0f1d 4f
    rrca                ;0f1e 0f
    ld c,(hl)           ;0f1f 4e
    ld b,h              ;0f20 44
    rrca                ;0f21 0f
    ld b,l              ;0f22 45
    ld e,(hl)           ;0f23 5e
    rrca                ;0f24 0f
    ld hl,2bf5h         ;0f25 21 f5 2b
l0f28h:
    ld a,(hl)           ;0f28 7e
    cp 0dh              ;0f29 fe 0d
    scf                 ;0f2b 37
    ret z               ;0f2c c8
    inc hl              ;0f2d 23
    cp 3dh              ;0f2e fe 3d
    ret z               ;0f30 c8
    cp 3ah              ;0f31 fe 3a
    ret z               ;0f33 c8
    jr l0f28h           ;0f34 18 f2
    call sub_164dh      ;0f36 cd 4d 16
    jr c,l0f3fh         ;0f39 38 04
    ld (l2000h),a       ;0f3b 32 00 20
    ret                 ;0f3e c9
l0f3fh:
    ld a,1eh            ;0f3f 3e 1e
    jp 05cfh            ;0f41 c3 cf 05
    ld a,(l2002h)       ;0f44 3a 02 20
    ld (l2051h),a       ;0f47 32 51 20
    ld a,59h            ;0f4a 3e 59
    jp 05cfh            ;0f4c c3 cf 05
    ld a,02h            ;0f4f 3e 02
    ld (l2051h),a       ;0f51 32 51 20
    ld a,04h            ;0f54 3e 04
    ld (l2054h),a       ;0f56 32 54 20
    ld a,63h            ;0f59 3e 63
    jp 05cfh            ;0f5b c3 cf 05
    call sub_164dh      ;0f5e cd 4d 16
    and 0fh             ;0f61 e6 0f
    ld d,a              ;0f63 57
    ld e,00h            ;0f64 1e 00
    ld hl,5000h         ;0f66 21 00 50
    add hl,de           ;0f69 19
    jp (hl)             ;0f6a e9
    call sub_1625h      ;0f6b cd 25 16
    ld a,(hl)           ;0f6e 7e
    call sub_1682h      ;0f6f cd 82 16
    jr nc,l0f7ah        ;0f72 30 06
    sub 30h             ;0f74 d6 30
    ld (l204fh),a       ;0f76 32 4f 20
    ret                 ;0f79 c9
l0f7ah:
    ld a,1eh            ;0f7a 3e 1e
    jp 05cfh            ;0f7c c3 cf 05
    ret                 ;0f7f c9
    ld hl,0000h         ;0f80 21 00 00
    ld (2d68h),hl       ;0f83 22 68 2d
l0f86h:
    call sub_15a6h      ;0f86 cd a6 15
    jr c,l0f9ah         ;0f89 38 0f
    bit 7,(ix+00h)      ;0f8b dd cb 00 7e
    jr z,l0f86h         ;0f8f 28 f5
    ld (ix+01h),0ffh    ;0f91 dd 36 01 ff
    call sub_1789h      ;0f95 cd 89 17
    jr l0f86h           ;0f98 18 ec
l0f9ah:
    ld a,(l2002h)       ;0f9a 3a 02 20
    jp l020dh           ;0f9d c3 0d 02
    call sub_1625h      ;0fa0 cd 25 16
    call sub_15e3h      ;0fa3 cd e3 15
    ld a,(2d67h)        ;0fa6 3a 67 2d
    push af             ;0fa9 f5
    push hl             ;0faa e5
    call sub_163bh      ;0fab cd 3b 16
    ld a,21h            ;0fae 3e 21
    jp c,05cfh          ;0fb0 da cf 05
    ld hl,2d45h         ;0fb3 21 45 2d
    ld de,2d56h         ;0fb6 11 56 2d
    ld bc,0010h         ;0fb9 01 10 00
    ldir                ;0fbc ed b0
    pop hl              ;0fbe e1
    ld a,(hl)           ;0fbf 7e
    cp 3dh              ;0fc0 fe 3d
    ld a,1eh            ;0fc2 3e 1e
    jp nz,05cfh         ;0fc4 c2 cf 05
    inc hl              ;0fc7 23
    call sub_15e3h      ;0fc8 cd e3 15
    call sub_163bh      ;0fcb cd 3b 16
    ld a,21h            ;0fce 3e 21
    jp c,05cfh          ;0fd0 da cf 05
    pop af              ;0fd3 f1
    push af             ;0fd4 f5
    ld hl,2d56h         ;0fd5 21 56 2d
    call 153dh          ;0fd8 cd 3d 15
    ld a,3fh            ;0fdb 3e 3f
    jp nc,05cfh         ;0fdd d2 cf 05
    pop af              ;0fe0 f1
    ld hl,2d45h         ;0fe1 21 45 2d
    call 153dh          ;0fe4 cd 3d 15
    ld a,3eh            ;0fe7 3e 3e
    jp c,05cfh          ;0fe9 da cf 05
    bit 7,(ix+00h)      ;0fec dd cb 00 7e
    ret nz              ;0ff0 c0
    ld hl,2d56h         ;0ff1 21 56 2d
    ld b,10h            ;0ff4 06 10
l0ff6h:
    ld a,(hl)           ;0ff6 7e
    ld (ix+02h),a       ;0ff7 dd 77 02
    inc hl              ;0ffa 23
    inc ix              ;0ffb dd 23
    djnz l0ff6h         ;0ffd 10 f7
    jp sub_1789h        ;0fff c3 89 17
    call sub_1625h      ;1002 cd 25 16
    call sub_15e3h      ;1005 cd e3 15
    ld a,(hl)           ;1008 7e
    cp 2ch              ;1009 fe 2c
    ld a,1eh            ;100b 3e 1e
    jp nz,05cfh         ;100d c2 cf 05
    inc hl              ;1010 23
    ex de,hl            ;1011 eb
    ld hl,(2d67h)       ;1012 2a 67 2d
    ld h,00h            ;1015 26 00
    add hl,hl           ;1017 29
    push hl             ;1018 e5
    ld bc,46b0h         ;1019 01 b0 46
    add hl,bc           ;101c 09
    ex de,hl            ;101d eb
    ld bc,0002h         ;101e 01 02 00
    ldir                ;1021 ed b0
    pop hl              ;1023 e1
    add hl,hl           ;1024 29
    add hl,hl           ;1025 29
    add hl,hl           ;1026 29
    ld bc,4610h         ;1027 01 10 46
    add hl,bc           ;102a 09
    ex de,hl            ;102b eb
    ld hl,2d45h         ;102c 21 45 2d
    ld bc,0010h         ;102f 01 10 00
l1032h:
    ld a,(hl)           ;1032 7e
    or a                ;1033 b7
    jr nz,l1038h        ;1034 20 02
    ld (hl),20h         ;1036 36 20
l1038h:
    ldi                 ;1038 ed a0
    jp po,l193eh        ;103a e2 3e 19
    jr l1032h           ;103d 18 f3
    ld a,(2bf6h)        ;103f 3a f6 2b
    and 0fh             ;1042 e6 0f
    ld (2ae7h),a        ;1044 32 e7 2a
    call sub_1689h      ;1047 cd 89 16
    bit 7,(iy+28h)      ;104a fd cb 28 7e
    ret z               ;104e c8
    ld a,(iy+00h)       ;104f fd 7e 00
    and 03h             ;1052 e6 03
    cp 03h              ;1054 fe 03
    ret nz              ;1056 c0
    call sub_0bcah      ;1057 cd ca 0b
    ld a,(2bf9h)        ;105a 3a f9 2b
    dec a               ;105d 3d
    cp (iy+15h)         ;105e fd be 15
    jr c,l106ah         ;1061 38 07
    ld a,(iy+15h)       ;1063 fd 7e 15
    dec a               ;1066 3d
    ld (2bf9h),a        ;1067 32 f9 2b
l106ah:
    ld c,(iy+15h)       ;106a fd 4e 15
    ld de,(2bf7h)       ;106d ed 5b f7 2b
    ld a,d              ;1071 7a
    or e                ;1072 b3
    jr z,l1076h         ;1073 28 01
    dec de              ;1075 1b
l1076h:
    ld hl,0000h         ;1076 21 00 00
    xor a               ;1079 af
    ld b,08h            ;107a 06 08
l107ch:
    add hl,hl           ;107c 29
    adc a,a             ;107d 8f
    rl c                ;107e cb 11
    jr nc,l1085h        ;1080 30 03
    add hl,de           ;1082 19
    adc a,00h           ;1083 ce 00
l1085h:
    djnz l107ch         ;1085 10 f5
    ld de,(2bf9h)       ;1087 ed 5b f9 2b
    ld d,00h            ;108b 16 00
    dec de              ;108d 1b
    add hl,de           ;108e 19
    adc a,00h           ;108f ce 00
    ld (iy+20h),l       ;1091 fd 75 20
    ld l,a              ;1094 6f
    ld a,(iy+15h)       ;1095 fd 7e 15
    sub e               ;1098 93
    ld (iy+25h),a       ;1099 fd 77 25
    ld (iy+21h),h       ;109c fd 74 21
    ld (iy+22h),l       ;109f fd 75 22
    call sub_0bcah      ;10a2 cd ca 0b
    call sub_10b0h      ;10a5 cd b0 10
    jp c,sub_17e0h      ;10a8 da e0 17
    ld a,32h            ;10ab 3e 32
    jp 05cfh            ;10ad c3 cf 05
sub_10b0h:
    push bc             ;10b0 c5
    push hl             ;10b1 e5
    ld l,(iy+12h)       ;10b2 fd 6e 12
    ld h,(iy+13h)       ;10b5 fd 66 13
    ld b,(iy+14h)       ;10b8 fd 46 14
    inc hl              ;10bb 23
    ld a,h              ;10bc 7c
    or l                ;10bd b5
    jr nz,l10c1h        ;10be 20 01
    inc b               ;10c0 04
l10c1h:
    ld a,(iy+20h)       ;10c1 fd 7e 20
    cp l                ;10c4 bd
    ld a,(iy+21h)       ;10c5 fd 7e 21
    sbc a,h             ;10c8 9c
    ld a,(iy+22h)       ;10c9 fd 7e 22
    sbc a,b             ;10cc 98
    pop hl              ;10cd e1
    pop bc              ;10ce c1
    ret                 ;10cf c9
    ld hl,2bf5h         ;10d0 21 f5 2b
l10d3h:
    ld a,(hl)           ;10d3 7e
    inc hl              ;10d4 23
    cp 0dh              ;10d5 fe 0d
    jr z,l1106h         ;10d7 28 2d
    cp 2dh              ;10d9 fe 2d
    jr nz,l10d3h        ;10db 20 f6
l10ddh:
    ld a,(hl)           ;10dd 7e
    inc hl              ;10de 23
    cp 0dh              ;10df fe 0d
    jr z,l1106h         ;10e1 28 23
    cp 41h              ;10e3 fe 41
    jp c,l10ddh         ;10e5 da dd 10
    cp 5bh              ;10e8 fe 5b
    jp nc,l10ddh        ;10ea d2 dd 10
    cp 57h              ;10ed fe 57
    jp z,l110bh         ;10ef ca 0b 11
    cp 52h              ;10f2 fe 52
    jp z,l111dh         ;10f4 ca 1d 11
    cp 41h              ;10f7 fe 41
    jp z,l1142h         ;10f9 ca 42 11
    cp 46h              ;10fc fe 46
    jp z,l113bh         ;10fe ca 3b 11
    cp 50h              ;1101 fe 50
    jp z,l112fh         ;1103 ca 2f 11
l1106h:
    ld a,1eh            ;1106 3e 1e
    jp 05cfh            ;1108 c3 cf 05
l110bh:
    call sub_1226h      ;110b cd 26 12
    push af             ;110e f5
    push hl             ;110f e5
    ld a,(iy+20h)       ;1110 fd 7e 20
    dec a               ;1113 3d
    ld hl,(2aech)       ;1114 2a ec 2a
    ld (hl),a           ;1117 77
    pop hl              ;1118 e1
    pop af              ;1119 f1
    jp l19b3h           ;111a c3 b3 19
l111dh:
    call sub_1226h      ;111d cd 26 12
    call sub_1982h      ;1120 cd 82 19
    ld hl,(2aech)       ;1123 2a ec 2a
    ld a,(hl)           ;1126 7e
    ld (iy+25h),a       ;1127 fd 77 25
    ld (iy+20h),001h    ;112a fd 36 20 01
    ret                 ;112e c9
l112fh:
    call sub_12d5h      ;112f cd d5 12
    jr c,l1106h         ;1132 38 d2
    call sub_164dh      ;1134 cd 4d 16
    ld (iy+20h),a       ;1137 fd 77 20
    ret                 ;113a c9
l113bh:
    call sub_11cfh      ;113b cd cf 11
    and 7fh             ;113e e6 7f
    jr l1149h           ;1140 18 07
l1142h:
    call sub_11cfh      ;1142 cd cf 11
    jr c,l1153h         ;1145 38 0c
    or 80h              ;1147 f6 80
l1149h:
    rrca                ;1149 0f
    djnz l1149h         ;114a 10 fd
    ld (hl),a           ;114c 77
    call sub_1955h      ;114d cd 55 19
    jp sub_05d8h        ;1150 c3 d8 05
l1153h:
    inc b               ;1153 04
l1154h:
    push af             ;1154 f5
    ld ix,l2054h        ;1155 dd 21 54 20
    inc (ix+00h)        ;1159 dd 34 00
    jr nz,l1166h        ;115c 20 08
    inc (ix+01h)        ;115e dd 34 01
    jr nz,l1166h        ;1161 20 03
    inc (ix+02h)        ;1163 dd 34 02
l1166h:
    ld a,(l2011h)       ;1166 3a 11 20
    cp (ix+00h)         ;1169 dd be 00
    jr nz,l11b1h        ;116c 20 43
    ld a,(l2012h)       ;116e 3a 12 20
    cp (ix+01h)         ;1171 dd be 01
    jr nz,l11b1h        ;1174 20 3b
    ld a,(l2013h)       ;1176 3a 13 20
    cp (ix+02h)         ;1179 dd be 02
    jr nz,l11b1h        ;117c 20 33
    ld (ix+00h),000h    ;117e dd 36 00 00
    ld (ix+01h),000h    ;1182 dd 36 01 00
    ld (ix+02h),000h    ;1186 dd 36 02 00
    ld ix,l2051h        ;118a dd 21 51 20
    inc (ix+00h)        ;118e dd 34 00
    jr nz,l1196h        ;1191 20 03
    inc (ix+01h)        ;1193 dd 34 01
l1196h:
    ld a,(l200fh)       ;1196 3a 0f 20
    sub (ix+00h)        ;1199 dd 96 00
    ld a,(l2010h)       ;119c 3a 10 20
    sbc a,(ix+01h)      ;119f dd 9e 01
    jr nc,l11b1h        ;11a2 30 0d
    ld (ix+00h),000h    ;11a4 dd 36 00 00
    ld (ix+01h),000h    ;11a8 dd 36 01 00
    ld a,41h            ;11ac 3e 41
    jp 05cfh            ;11ae c3 cf 05
l11b1h:
    pop af              ;11b1 f1
    djnz l11c7h         ;11b2 10 13
    inc hl              ;11b4 23
    ld a,l              ;11b5 7d
    cp 10h              ;11b6 fe 10
    jr nz,l11c4h        ;11b8 20 0a
    ld hl,l204eh        ;11ba 21 4e 20
    inc (hl)            ;11bd 34
    call sub_194fh      ;11be cd 4f 19
    ld hl,4910h         ;11c1 21 10 49
l11c4h:
    ld a,(hl)           ;11c4 7e
    ld b,08h            ;11c5 06 08
l11c7h:
    rrca                ;11c7 0f
    jr c,l1154h         ;11c8 38 8a
    ld a,41h            ;11ca 3e 41
    jp 05cfh            ;11cc c3 cf 05
sub_11cfh:
    call sub_1245h      ;11cf cd 45 12
    ld a,b              ;11d2 78
    ld b,03h            ;11d3 06 03
    push de             ;11d5 d5
l11d6h:
    rra                 ;11d6 1f
    rr d                ;11d7 cb 1a
    rr e                ;11d9 cb 1b
    djnz l11d6h         ;11db 10 f9
    push de             ;11dd d5
    ld a,d              ;11de 7a
    ld (l204eh),a       ;11df 32 4e 20
    call sub_194fh      ;11e2 cd 4f 19
    pop de              ;11e5 d1
    ld d,00h            ;11e6 16 00
    ld hl,4910h         ;11e8 21 10 49
    add hl,de           ;11eb 19
    pop bc              ;11ec c1
    ld a,c              ;11ed 79
    and 07h             ;11ee e6 07
    ld c,a              ;11f0 4f
    xor 07h             ;11f1 ee 07
    ld b,a              ;11f3 47
    ld a,(hl)           ;11f4 7e
l11f5h:
    rrca                ;11f5 0f
    dec c               ;11f6 0d
    jp p,l11f5h         ;11f7 f2 f5 11
    ret                 ;11fa c9
    ld hl,2bf6h         ;11fb 21 f6 2b
    ld a,(hl)           ;11fe 7e
    inc hl              ;11ff 23
    and 0fh             ;1200 e6 0f
    cp 01h              ;1202 fe 01
    jr z,l1212h         ;1204 28 0c
    cp 02h              ;1206 fe 02
    jr z,l1220h         ;1208 28 16
    cp 0ah              ;120a fe 0a
    jp z,l0200h         ;120c ca 00 02
    jp l1106h           ;120f c3 06 11
l1212h:
    call sub_1226h      ;1212 cd 26 12
    ld (iy+25h),0ffh    ;1215 fd 36 25 ff
    ld (iy+20h),000h    ;1219 fd 36 20 00
    jp sub_1982h        ;121d c3 82 19
l1220h:
    call sub_1226h      ;1220 cd 26 12
    jp l19b3h           ;1223 c3 b3 19
sub_1226h:
    call sub_12d5h      ;1226 cd d5 12
    ld a,1eh            ;1229 3e 1e
    jp c,05cfh          ;122b da cf 05
    call sub_1245h      ;122e cd 45 12
    call sub_064ch      ;1231 cd 4c 06
    ld hl,(l2036h)      ;1234 2a 36 20
    ld a,(l2038h)       ;1237 3a 38 20
    add hl,de           ;123a 19
    adc a,b             ;123b 88
    ex de,hl            ;123c eb
    ld hl,l2004h        ;123d 21 04 20
    ld b,(hl)           ;1240 46
    ld hl,(2aech)       ;1241 2a ec 2a
    ret                 ;1244 c9
sub_1245h:
    call sub_164dh      ;1245 cd 4d 16
    jp c,l12d0h         ;1248 da d0 12
    ld de,(l200fh)      ;124b ed 5b 0f 20
    push hl             ;124f e5
    ld hl,0000h         ;1250 21 00 00
    ld b,08h            ;1253 06 08
    add hl,hl           ;1255 29
l1256h:
    rla                 ;1256 17
    jr nc,l125ah        ;1257 30 01
    add hl,de           ;1259 19
l125ah:
    djnz l1256h         ;125a 10 fa
    ex (sp),hl          ;125c e3
    call sub_164dh      ;125d cd 4d 16
    jr c,l12d0h         ;1260 38 6e
    inc d               ;1262 14
    dec d               ;1263 15
    jr nz,l12cbh        ;1264 20 65
    ld d,e              ;1266 53
    ld e,a              ;1267 5f
    ld (l2051h),de      ;1268 ed 53 51 20
    dec de              ;126c 1b
    ld bc,(l200fh)      ;126d ed 4b 0f 20
    ld a,e              ;1271 7b
    sub c               ;1272 91
    ld a,d              ;1273 7a
    sbc a,b             ;1274 98
    jr nc,l12cbh        ;1275 30 54
    ex (sp),hl          ;1277 e3
    add hl,de           ;1278 19
    ex de,hl            ;1279 eb
    ld ix,(l2011h)      ;127a dd 2a 11 20
    ld bc,(l2013h)      ;127e ed 4b 13 20
    ld b,18h            ;1282 06 18
    xor a               ;1284 af
    ld hl,0000h         ;1285 21 00 00
l1288h:
    add hl,hl           ;1288 29
    adc a,a             ;1289 8f
    add ix,ix           ;128a dd 29
    rl c                ;128c cb 11
    jr nc,l1293h        ;128e 30 03
    add hl,de           ;1290 19
    adc a,00h           ;1291 ce 00
l1293h:
    djnz l1288h         ;1293 10 f3
    ex (sp),hl          ;1295 e3
    push af             ;1296 f5
    call sub_164dh      ;1297 cd 4d 16
    jr c,l12d0h         ;129a 38 34
    ld (l2054h),a       ;129c 32 54 20
    ld (l2055h),de      ;129f ed 53 55 20
    ld b,a              ;12a3 47
    ld hl,l2011h        ;12a4 21 11 20
    cp (hl)             ;12a7 be
    inc hl              ;12a8 23
    ld a,e              ;12a9 7b
    sbc a,(hl)          ;12aa 9e
    inc hl              ;12ab 23
    ld a,d              ;12ac 7a
    sbc a,(hl)          ;12ad 9e
    jr nc,l12cbh        ;12ae 30 1b
    ld a,d              ;12b0 7a
    ld d,e              ;12b1 53
    ld e,b              ;12b2 58
    pop bc              ;12b3 c1
    pop hl              ;12b4 e1
    add hl,de           ;12b5 19
    adc a,b             ;12b6 88
    ex de,hl            ;12b7 eb
    ld b,a              ;12b8 47
    ld hl,(l200dh)      ;12b9 2a 0d 20
    ld c,00h            ;12bc 0e 00
    add hl,hl           ;12be 29
    rl c                ;12bf cb 11
    add hl,hl           ;12c1 29
    rl c                ;12c2 cb 11
    ld a,e              ;12c4 7b
    sub l               ;12c5 95
    ld a,d              ;12c6 7a
    sbc a,h             ;12c7 9c
    ld a,b              ;12c8 78
    sbc a,c             ;12c9 99
    ret c               ;12ca d8
l12cbh:
    ld a,42h            ;12cb 3e 42
    jp 05cfh            ;12cd c3 cf 05
l12d0h:
    ld a,1eh            ;12d0 3e 1e
    jp 05cfh            ;12d2 c3 cf 05
sub_12d5h:
    call sub_164dh      ;12d5 cd 4d 16
    ret c               ;12d8 d8
    push af             ;12d9 f5
    and 0f0h            ;12da e6 f0
    or e                ;12dc b3
    or d                ;12dd b2
    scf                 ;12de 37
    ret nz              ;12df c0
    pop af              ;12e0 f1
    ld (2ae7h),a        ;12e1 32 e7 2a
    push hl             ;12e4 e5
    call sub_1689h      ;12e5 cd 89 16
    pop hl              ;12e8 e1
    bit 6,(iy+28h)      ;12e9 fd cb 28 76
    scf                 ;12ed 37
    ret z               ;12ee c8
    or a                ;12ef b7
    ret                 ;12f0 c9
l12f1h:
    ld hl,2bf5h         ;12f1 21 f5 2b
l12f4h:
    ld a,(hl)           ;12f4 7e
    inc hl              ;12f5 23
    cp 0dh              ;12f6 fe 0d
    jr z,l1318h         ;12f8 28 1e
    cp 2dh              ;12fa fe 2d
    jr nz,l12f4h        ;12fc 20 f6
l12feh:
    ld a,(hl)           ;12fe 7e
    inc hl              ;12ff 23
    cp 0dh              ;1300 fe 0d
    jr z,l1318h         ;1302 28 14
    cp 41h              ;1304 fe 41
    jp c,l12feh         ;1306 da fe 12
    cp 5bh              ;1309 fe 5b
    jp nc,l12feh        ;130b d2 fe 12
    cp 57h              ;130e fe 57
    jp z,l131dh         ;1310 ca 1d 13
    cp 52h              ;1313 fe 52
    jp z,l132ch         ;1315 ca 2c 13
l1318h:
    ld a,1eh            ;1318 3e 1e
    jp 05cfh            ;131a c3 cf 05
l131dh:
    ld a,(l2002h)       ;131d 3a 02 20
    or a                ;1320 b7
    ld a,5ch            ;1321 3e 5c
    jp nz,05cfh         ;1323 c2 cf 05
    call sub_134dh      ;1326 cd 4d 13
    jp l19b3h           ;1329 c3 b3 19
l132ch:
    call sub_134dh      ;132c cd 4d 13
    ld (iy+20h),000h    ;132f fd 36 20 00
    ld (iy+25h),0ffh    ;1333 fd 36 25 ff
    push af             ;1337 f5
    or d                ;1338 b2
    jr nz,l1340h        ;1339 20 05
    ld a,e              ;133b 7b
    cp 0ch              ;133c fe 0c
    jr c,l1349h         ;133e 38 09
l1340h:
    ld a,(l2002h)       ;1340 3a 02 20
    or a                ;1343 b7
    ld a,5ch            ;1344 3e 5c
    jp nz,05cfh         ;1346 c2 cf 05
l1349h:
    pop af              ;1349 f1
    jp sub_1982h        ;134a c3 82 19
sub_134dh:
    call sub_12d5h      ;134d cd d5 12
    ld a,1eh            ;1350 3e 1e
    jp c,05cfh          ;1352 da cf 05
    call sub_164dh      ;1355 cd 4d 16
    push af             ;1358 f5
    call sub_164dh      ;1359 cd 4d 16
    push de             ;135c d5
    ld d,e              ;135d 53
    ld e,a              ;135e 5f
    pop af              ;135f f1
    pop bc              ;1360 c1
    ld hl,(2aech)       ;1361 2a ec 2a
    ret                 ;1364 c9
l1365h:
    set 2,(iy+28h)      ;1365 fd cb 28 d6
    set 7,(iy+28h)      ;1369 fd cb 28 fe
    ld hl,2c76h         ;136d 21 76 2c
    call sub_15e3h      ;1370 cd e3 15
l1373h:
    ld a,(hl)           ;1373 7e
    inc hl              ;1374 23
    cp 48h              ;1375 fe 48
    jr z,l137dh         ;1377 28 04
    cp 0dh              ;1379 fe 0d
    jr nz,l1373h        ;137b 20 f6
l137dh:
    ld (2d6eh),a        ;137d 32 6e 2d
    ld hl,2d45h         ;1380 21 45 2d
    ld de,45f7h         ;1383 11 f7 45
    ld bc,0010h         ;1386 01 10 00
    ldir                ;1389 ed b0
    ld a,(2d67h)        ;138b 3a 67 2d
    ld (45f6h),a        ;138e 32 f6 45
    ld e,a              ;1391 5f
    ld d,00h            ;1392 16 00
    ld hl,4570h         ;1394 21 70 45
    ld (45f0h),hl       ;1397 22 f0 45
    ld (hl),01h         ;139a 36 01
    inc hl              ;139c 23
    ld (hl),04h         ;139d 36 04
    inc hl              ;139f 23
    inc hl              ;13a0 23
    inc hl              ;13a1 23
    ld (hl),e           ;13a2 73
    inc hl              ;13a3 23
    ld (hl),00h         ;13a4 36 00
    inc hl              ;13a6 23
    ld (hl),12h         ;13a7 36 12
    inc hl              ;13a9 23
    ld (hl),22h         ;13aa 36 22
    inc hl              ;13ac 23
    push de             ;13ad d5
    ex de,hl            ;13ae eb
    add hl,hl           ;13af 29
    add hl,hl           ;13b0 29
    add hl,hl           ;13b1 29
    add hl,hl           ;13b2 29
    ld bc,4610h         ;13b3 01 10 46
    add hl,bc           ;13b6 09
    ld bc,0010h         ;13b7 01 10 00
    ldir                ;13ba ed b0
    ex de,hl            ;13bc eb
    ld (hl),22h         ;13bd 36 22
    inc hl              ;13bf 23
    ld (hl),20h         ;13c0 36 20
    inc hl              ;13c2 23
    ex de,hl            ;13c3 eb
    ld hl,46b0h         ;13c4 21 b0 46
    pop bc              ;13c7 c1
    add hl,bc           ;13c8 09
    add hl,bc           ;13c9 09
    ld bc,0002h         ;13ca 01 02 00
    ldir                ;13cd ed b0
    ld hl,l152eh        ;13cf 21 2e 15
    ld bc,0001h         ;13d2 01 01 00
    ldir                ;13d5 ed b0
    ex de,hl            ;13d7 eb
    ld a,(l2002h)       ;13d8 3a 02 20
    push de             ;13db d5
    ld de,0000h         ;13dc 11 00 00
    call sub_0660h      ;13df cd 60 06
    pop de              ;13e2 d1
    ld (hl),00h         ;13e3 36 00
    inc hl              ;13e5 23
    ld (45f2h),hl       ;13e6 22 f2 45
    ld de,0401h         ;13e9 11 01 04
    add hl,de           ;13ec 19
    ld de,4572h         ;13ed 11 72 45
    or a                ;13f0 b7
    sbc hl,de           ;13f1 ed 52
    ld (4572h),hl       ;13f3 22 72 45
    ld (45f4h),hl       ;13f6 22 f4 45
    ld hl,0000h         ;13f9 21 00 00
    ld (2d68h),hl       ;13fc 22 68 2d
    ld hl,45f7h         ;13ff 21 f7 45
    ld a,(hl)           ;1402 7e
    or a                ;1403 b7
    jp nz,l0376h        ;1404 c2 76 03
    ld (hl),2ah         ;1407 36 2a
    inc hl              ;1409 23
    ld (hl),00h         ;140a 36 00
    jp l0376h           ;140c c3 76 03
sub_140fh:
    ld hl,45f7h         ;140f 21 f7 45
    ld a,(45f6h)        ;1412 3a f6 45
    call sub_1544h      ;1415 cd 44 15
    jp c,l14dch         ;1418 da dc 14
    bit 5,(ix+00h)      ;141b dd cb 00 6e
    jr z,l1429h         ;141f 28 08
    ld a,(2d6eh)        ;1421 3a 6e 2d
    cp 48h              ;1424 fe 48
    jp nz,sub_140fh     ;1426 c2 0f 14
l1429h:
    ld hl,4570h         ;1429 21 70 45
    ld (45f0h),hl       ;142c 22 f0 45
    inc hl              ;142f 23
    inc hl              ;1430 23
    ld e,(ix+13h)       ;1431 dd 5e 13
    ld d,(ix+14h)       ;1434 dd 56 14
    inc de              ;1437 13
    ld (hl),e           ;1438 73
    inc hl              ;1439 23
    ld (hl),d           ;143a 72
    inc hl              ;143b 23
    ld b,03h            ;143c 06 03
    ld iy,l06afh        ;143e fd 21 af 06
l1442h:
    ld a,e              ;1442 7b
    cp (iy+00h)         ;1443 fd be 00
    ld a,d              ;1446 7a
    sbc a,(iy+01h)      ;1447 fd 9e 01
    jr nc,l1457h        ;144a 30 0b
    ld (hl),20h         ;144c 36 20
    inc hl              ;144e 23
    inc iy              ;144f fd 23
    inc iy              ;1451 fd 23
    inc iy              ;1453 fd 23
    djnz l1442h         ;1455 10 eb
l1457h:
    ld (hl),22h         ;1457 36 22
    inc hl              ;1459 23
    push ix             ;145a dd e5
    ld b,10h            ;145c 06 10
l145eh:
    ld a,(ix+02h)       ;145e dd 7e 02
    or a                ;1461 b7
    jr z,l146ah         ;1462 28 06
    ld (hl),a           ;1464 77
    inc hl              ;1465 23
    inc ix              ;1466 dd 23
    djnz l145eh         ;1468 10 f4
l146ah:
    ld (hl),22h         ;146a 36 22
    inc hl              ;146c 23
    ld a,b              ;146d 78
    or a                ;146e b7
    jr z,l1476h         ;146f 28 05
l1471h:
    ld (hl),20h         ;1471 36 20
    inc hl              ;1473 23
    djnz l1471h         ;1474 10 fb
l1476h:
    pop ix              ;1476 dd e1
    ld (hl),20h         ;1478 36 20
    bit 7,(ix+00h)      ;147a dd cb 00 7e
    jr z,l1482h         ;147e 28 02
    ld (hl),2ah         ;1480 36 2a
l1482h:
    inc hl              ;1482 23
    ex de,hl            ;1483 eb
    ld a,(ix+00h)       ;1484 dd 7e 00
    and 03h             ;1487 e6 03
    ld b,a              ;1489 47
    add a,a             ;148a 87
    add a,b             ;148b 80
    ld c,a              ;148c 4f
    ld b,00h            ;148d 06 00
    ld hl,l1522h        ;148f 21 22 15
    add hl,bc           ;1492 09
    ld bc,0003h         ;1493 01 03 00
    ldir                ;1496 ed b0
    ex de,hl            ;1498 eb
    ld (hl),20h         ;1499 36 20
    inc hl              ;149b 23
    ld (hl),2dh         ;149c 36 2d
    bit 6,(ix+00h)      ;149e dd cb 00 76
    jr z,l14a6h         ;14a2 28 02
    ld (hl),57h         ;14a4 36 57
l14a6h:
    inc hl              ;14a6 23
    ld (hl),2dh         ;14a7 36 2d
    bit 4,(ix+00h)      ;14a9 dd cb 00 66
    jr z,l14b1h         ;14ad 28 02
    ld (hl),47h         ;14af 36 47
l14b1h:
    ld a,(2d6eh)        ;14b1 3a 6e 2d
    cp 48h              ;14b4 fe 48
    jr nz,l14c3h        ;14b6 20 0b
    inc hl              ;14b8 23
    ld (hl),2dh         ;14b9 36 2d
    bit 5,(ix+00h)      ;14bb dd cb 00 6e
    jr z,l14c3h         ;14bf 28 02
    ld (hl),48h         ;14c1 36 48
l14c3h:
    inc hl              ;14c3 23
    ld (hl),00h         ;14c4 36 00
    inc hl              ;14c6 23
    ld (45f2h),hl       ;14c7 22 f2 45
    ld de,4570h         ;14ca 11 70 45
    or a                ;14cd b7
    sbc hl,de           ;14ce ed 52
    ld de,(45f4h)       ;14d0 ed 5b f4 45
    add hl,de           ;14d4 19
    ld (4570h),hl       ;14d5 22 70 45
    ld (45f4h),hl       ;14d8 22 f4 45
    ret                 ;14db c9
l14dch:
    call sub_175ch      ;14dc cd 5c 17
    ld (4572h),hl       ;14df 22 72 45
    ld hl,4570h         ;14e2 21 70 45
    ld (45f0h),hl       ;14e5 22 f0 45
    ld de,4574h         ;14e8 11 74 45
    ld hl,l152eh+1      ;14eb 21 2f 15
    ld bc,000eh         ;14ee 01 0e 00
    ldir                ;14f1 ed b0
    ld hl,l203eh        ;14f3 21 3e 20
    ld b,10h            ;14f6 06 10
l14f8h:
    ld a,(hl)           ;14f8 7e
    or a                ;14f9 b7
    jr z,l1501h         ;14fa 28 05
    ld (de),a           ;14fc 12
    inc hl              ;14fd 23
    inc de              ;14fe 13
    djnz l14f8h         ;14ff 10 f7
l1501h:
    xor a               ;1501 af
    ld (de),a           ;1502 12
    inc de              ;1503 13
    ld (de),a           ;1504 12
    inc de              ;1505 13
    ld (de),a           ;1506 12
    inc de              ;1507 13
    ld (45f2h),de       ;1508 ed 53 f2 45
    dec de              ;150c 1b
    dec de              ;150d 1b
    ld hl,(45f4h)       ;150e 2a f4 45
    add hl,de           ;1511 19
    ld bc,4570h         ;1512 01 70 45
    or a                ;1515 b7
    sbc hl,bc           ;1516 ed 42
    ld (4570h),hl       ;1518 22 70 45
    ld hl,0000h         ;151b 21 00 00
    ld (45f4h),hl       ;151e 22 f4 45
    ret                 ;1521 c9
l1522h:
    ld d,e              ;1522 53
    ld b,l              ;1523 45
    ld d,c              ;1524 51
    ld d,l              ;1525 55
    ld d,e              ;1526 53
    ld d,d              ;1527 52
    ld d,b              ;1528 50
    ld d,d              ;1529 52
    ld b,a              ;152a 47
    ld d,d              ;152b 52
    ld b,l              ;152c 45
    ld c,h              ;152d 4c
l152eh:
    jr nz,$+68          ;152e 20 42
    ld c,h              ;1530 4c
    ld c,a              ;1531 4f
    ld b,e              ;1532 43
    ld c,e              ;1533 4b
    ld d,e              ;1534 53
    jr nz,$+72          ;1535 20 46
    ld d,d              ;1537 52
    ld b,l              ;1538 45
    ld b,l              ;1539 45
    jr nz,$+60          ;153a 20 3a
    jr nz,l154fh        ;153c 20 11
    nop                 ;153e 00
    nop                 ;153f 00
    ld (2d68h),de       ;1540 ed 53 68 2d
sub_1544h:
    ld c,a              ;1544 4f
    ld (4608h),hl       ;1545 22 08 46
l1548h:
    push bc             ;1548 c5
    call sub_15a6h      ;1549 cd a6 15
    ld hl,(4608h)       ;154c 2a 08 46
l154fh:
    pop bc              ;154f c1
    ret c               ;1550 d8
    push ix             ;1551 dd e5
    pop iy              ;1553 fd e1
    bit 7,(iy+01h)      ;1555 fd cb 01 7e
    jr nz,l1548h        ;1559 20 ed
    bit 4,(iy+00h)      ;155b fd cb 00 66
    jr nz,l1567h        ;155f 20 06
    ld a,(iy+01h)       ;1561 fd 7e 01
    cp c                ;1564 b9
    jr nz,l1548h        ;1565 20 e1
l1567h:
    ld b,10h            ;1567 06 10
l1569h:
    ld a,(hl)           ;1569 7e
    cp 2ah              ;156a fe 2a
    ret z               ;156c c8
    cp 3fh              ;156d fe 3f
    jr nz,l1579h        ;156f 20 08
    ld a,(iy+02h)       ;1571 fd 7e 02
    or a                ;1574 b7
    jr z,l1548h         ;1575 28 d1
    jr l157eh           ;1577 18 05
l1579h:
    cp (iy+02h)         ;1579 fd be 02
    jr nz,l1548h        ;157c 20 ca
l157eh:
    inc hl              ;157e 23
    inc iy              ;157f fd 23
    or a                ;1581 b7
    ret z               ;1582 c8
    djnz l1569h         ;1583 10 e4
    ret                 ;1585 c9
sub_1586h:
    ld hl,0000h         ;1586 21 00 00
    ld (2d68h),hl       ;1589 22 68 2d
l158ch:
    call sub_15a6h      ;158c cd a6 15
    bit 7,(ix+01h)      ;158f dd cb 01 7e
    ret nz              ;1593 c0
    inc de              ;1594 13
    ld a,(l200bh)       ;1595 3a 0b 20
    cp e                ;1598 bb
    jr nz,l158ch        ;1599 20 f1
    ld a,(l200ch)       ;159b 3a 0c 20
    cp d                ;159e ba
    jr nz,l158ch        ;159f 20 eb
    ld a,48h            ;15a1 3e 48
    jp 05cfh            ;15a3 c3 cf 05
sub_15a6h:
    ld a,(460ch)        ;15a6 3a 0c 46
    or a                ;15a9 b7
    ld a,54h            ;15aa 3e 54
    jp z,05cfh          ;15ac ca cf 05
    ld hl,(2d68h)       ;15af 2a 68 2d
    ld e,l              ;15b2 5d
    ld d,h              ;15b3 54
    inc hl              ;15b4 23
    ld (2d68h),hl       ;15b5 22 68 2d
    ld a,(l200bh)       ;15b8 3a 0b 20
    cp e                ;15bb bb
    jr nz,l15c4h        ;15bc 20 06
    ld a,(l200ch)       ;15be 3a 0c 20
    cp d                ;15c1 ba
    scf                 ;15c2 37
    ret z               ;15c3 c8
l15c4h:
    ld a,e              ;15c4 7b
    and 03h             ;15c5 e6 03
    jr nz,l15cch        ;15c7 20 03
    call sub_177eh      ;15c9 cd 7e 17
l15cch:
    ld ix,2af5h         ;15cc dd 21 f5 2a
    ld a,e              ;15d0 7b
    and 07h             ;15d1 e6 07
    rrca                ;15d3 0f
    rrca                ;15d4 0f
    rrca                ;15d5 0f
    ld c,a              ;15d6 4f
    ld b,00h            ;15d7 06 00
    add ix,bc           ;15d9 dd 09
    ld a,(ix+01h)       ;15db dd 7e 01
    xor 0e5h            ;15de ee e5
    ret nz              ;15e0 c0
    scf                 ;15e1 37
    ret                 ;15e2 c9
sub_15e3h:
    ld a,(l204fh)       ;15e3 3a 4f 20
    ld (2d67h),a        ;15e6 32 67 2d
    ld a,(hl)           ;15e9 7e
    ld e,a              ;15ea 5f
    call sub_1682h      ;15eb cd 82 16
    jr nc,l1603h        ;15ee 30 13
    inc hl              ;15f0 23
    ld a,(hl)           ;15f1 7e
    dec hl              ;15f2 2b
    cp 0dh              ;15f3 fe 0d
    jr z,l15fch         ;15f5 28 05
    cp 3ah              ;15f7 fe 3a
    jr nz,l1603h        ;15f9 20 08
    inc hl              ;15fb 23
l15fch:
    inc hl              ;15fc 23
    ld a,e              ;15fd 7b
    sub 30h             ;15fe d6 30
    ld (2d67h),a        ;1600 32 67 2d
l1603h:
    ld b,11h            ;1603 06 11
    ld de,2d45h         ;1605 11 45 2d
l1608h:
    ld a,(hl)           ;1608 7e
    ld (de),a           ;1609 12
    cp 0dh              ;160a fe 0d
    jr z,l161fh         ;160c 28 11
    cp 2ch              ;160e fe 2c
    jr z,l161fh         ;1610 28 0d
    cp 3dh              ;1612 fe 3d
    jr z,l161fh         ;1614 28 09
    inc hl              ;1616 23
    inc de              ;1617 13
    djnz l1608h         ;1618 10 ee
    ld a,1fh            ;161a 3e 1f
    jp 05cfh            ;161c c3 cf 05
l161fh:
    xor a               ;161f af
    ld (de),a           ;1620 12
    inc de              ;1621 13
    djnz l161fh         ;1622 10 fb
    ret                 ;1624 c9
sub_1625h:
    ld hl,2bf5h         ;1625 21 f5 2b
l1628h:
    ld a,(hl)           ;1628 7e
    cp 0dh              ;1629 fe 0d
    ld a,22h            ;162b 3e 22
    jp z,05cfh          ;162d ca cf 05
    ld a,(hl)           ;1630 7e
    cp 30h              ;1631 fe 30
    jr c,l1638h         ;1633 38 03
    cp 3ah              ;1635 fe 3a
    ret c               ;1637 d8
l1638h:
    inc hl              ;1638 23
    jr l1628h           ;1639 18 ed
sub_163bh:
    ld b,10h            ;163b 06 10
    ld hl,2d45h         ;163d 21 45 2d
l1640h:
    ld a,(hl)           ;1640 7e
    cp 3fh              ;1641 fe 3f
    scf                 ;1643 37
    ret z               ;1644 c8
    cp 2ah              ;1645 fe 2a
    scf                 ;1647 37
    ret z               ;1648 c8
    djnz l1640h         ;1649 10 f5
    or a                ;164b b7
    ret                 ;164c c9
sub_164dh:
    ld a,(hl)           ;164d 7e
    inc hl              ;164e 23
    cp 0dh              ;164f fe 0d
    scf                 ;1651 37
    ret z               ;1652 c8
    call sub_1682h      ;1653 cd 82 16
    jr nc,sub_164dh     ;1656 30 f5
    ld de,0000h         ;1658 11 00 00
    ld b,00h            ;165b 06 00
    dec hl              ;165d 2b
l165eh:
    push hl             ;165e e5
    ld h,d              ;165f 62
    ld l,e              ;1660 6b
    ld a,b              ;1661 78
    add a,a             ;1662 87
    adc hl,hl           ;1663 ed 6a
    add a,a             ;1665 87
    adc hl,hl           ;1666 ed 6a
    add a,b             ;1668 80
    adc hl,de           ;1669 ed 5a
    add a,a             ;166b 87
    adc hl,hl           ;166c ed 6a
    ex de,hl            ;166e eb
    pop hl              ;166f e1
    ld b,a              ;1670 47
    ld a,(hl)           ;1671 7e
    sub 30h             ;1672 d6 30
    add a,b             ;1674 80
    ld b,a              ;1675 47
    jr nc,l1679h        ;1676 30 01
    inc de              ;1678 13
l1679h:
    inc hl              ;1679 23
    ld a,(hl)           ;167a 7e
    call sub_1682h      ;167b cd 82 16
    jr c,l165eh         ;167e 38 de
    ld a,b              ;1680 78
    ret                 ;1681 c9
sub_1682h:
    cp 30h              ;1682 fe 30
    ccf                 ;1684 3f
    ret nc              ;1685 d0
    cp 3ah              ;1686 fe 3a
    ret                 ;1688 c9
sub_1689h:
    ld a,(2ae7h)        ;1689 3a e7 2a
    ld d,a              ;168c 57
    ld e,00h            ;168d 1e 00
    ld hl,2d6fh         ;168f 21 6f 2d
    add hl,de           ;1692 19
    ld (2aeah),hl       ;1693 22 ea 2a
    ld hl,5000h         ;1696 21 00 50
    add hl,de           ;1699 19
    ld (2aech),hl       ;169a 22 ec 2a
    ld hl,3d6fh         ;169d 21 6f 3d
    srl d               ;16a0 cb 3a
    rr e                ;16a2 cb 1b
    add hl,de           ;16a4 19
    ld (2aeeh),hl       ;16a5 22 ee 2a
    ld iy,2857h         ;16a8 fd 21 57 28
    ld de,0029h         ;16ac 11 29 00
l16afh:
    ld (2ae8h),iy       ;16af fd 22 e8 2a
    dec a               ;16b3 3d
    or a                ;16b4 b7
    ret m               ;16b5 f8
    add iy,de           ;16b6 fd 19
    jr l16afh           ;16b8 18 f5
sub_16bah:
    push de             ;16ba d5
    push bc             ;16bb c5
    call sub_1973h      ;16bc cd 73 19
    ld hl,0000h         ;16bf 21 00 00
l16c2h:
    ld a,(de)           ;16c2 1a
    ld b,08h            ;16c3 06 08
l16c5h:
    rra                 ;16c5 1f
    jr nc,l16ceh        ;16c6 30 06
    inc hl              ;16c8 23
    djnz l16c5h         ;16c9 10 fa
    inc de              ;16cb 13
    jr l16c2h           ;16cc 18 f4
l16ceh:
    scf                 ;16ce 37
l16cfh:
    rra                 ;16cf 1f
    djnz l16cfh         ;16d0 10 fd
    pop bc              ;16d2 c1
    push hl             ;16d3 e5
    or a                ;16d4 b7
    sbc hl,bc           ;16d5 ed 42
    jp nc,l16deh        ;16d7 d2 de 16
    pop hl              ;16da e1
    ld (de),a           ;16db 12
    pop de              ;16dc d1
    ret                 ;16dd c9
l16deh:
    ld a,48h            ;16de 3e 48
    jp 05cfh            ;16e0 c3 cf 05
sub_16e3h:
    push ix             ;16e3 dd e5
    push iy             ;16e5 fd e5
    push hl             ;16e7 e5
    push de             ;16e8 d5
    push bc             ;16e9 c5
    call sub_1973h      ;16ea cd 73 19
    call sub_18beh      ;16ed cd be 18
    ld b,40h            ;16f0 06 40
    ld ix,(2aeeh)       ;16f2 dd 2a ee 2a
l16f6h:
    ld e,(ix+00h)       ;16f6 dd 5e 00
    ld d,(ix+01h)       ;16f9 dd 56 01
    bit 7,d             ;16fc cb 7a
    jr nz,l1725h        ;16fe 20 25
    push bc             ;1700 c5
    push de             ;1701 d5
    call sub_17b5h      ;1702 cd b5 17
    ld b,80h            ;1705 06 80
    ld iy,(2aeah)       ;1707 fd 2a ea 2a
l170bh:
    ld l,(iy+00h)       ;170b fd 6e 00
    ld h,(iy+01h)       ;170e fd 66 01
    ld de,2457h         ;1711 11 57 24
    call sub_173ch      ;1714 cd 3c 17
    inc iy              ;1717 fd 23
    inc iy              ;1719 fd 23
    djnz l170bh         ;171b 10 ee
    pop hl              ;171d e1
    ld de,l2057h        ;171e 11 57 20
    call sub_173ch      ;1721 cd 3c 17
    pop bc              ;1724 c1
l1725h:
    inc ix              ;1725 dd 23
    inc ix              ;1727 dd 23
    djnz l16f6h         ;1729 10 cb
    pop bc              ;172b c1
    pop de              ;172c d1
    pop hl              ;172d e1
    pop iy              ;172e fd e1
    pop ix              ;1730 dd e1
    ret                 ;1732 c9
sub_1733h:
    bit 7,h             ;1733 cb 7c
    ret nz              ;1735 c0
    call sub_1746h      ;1736 cd 46 17
    or (hl)             ;1739 b6
    ld (hl),a           ;173a 77
    ret                 ;173b c9
sub_173ch:
    bit 7,h             ;173c cb 7c
    ret nz              ;173e c0
    call sub_1746h      ;173f cd 46 17
    cpl                 ;1742 2f
    and (hl)            ;1743 a6
    ld (hl),a           ;1744 77
    ret                 ;1745 c9
sub_1746h:
    push bc             ;1746 c5
    ld a,l              ;1747 7d
    push af             ;1748 f5
    ld b,03h            ;1749 06 03
    call sub_1a7ah      ;174b cd 7a 1a
    add hl,de           ;174e 19
    pop af              ;174f f1
    and 07h             ;1750 e6 07
    ld b,a              ;1752 47
    ld a,01h            ;1753 3e 01
    jr z,l175ah         ;1755 28 03
l1757h:
    rla                 ;1757 17
    djnz l1757h         ;1758 10 fd
l175ah:
    pop bc              ;175a c1
    ret                 ;175b c9
sub_175ch:
    ld ix,2457h         ;175c dd 21 57 24
    ld de,(l2034h)      ;1760 ed 5b 34 20
    ld hl,0000h         ;1764 21 00 00
l1767h:
    ld b,08h            ;1767 06 08
    ld c,(ix+00h)       ;1769 dd 4e 00
    inc ix              ;176c dd 23
l176eh:
    rr c                ;176e cb 19
    jr c,l1773h         ;1770 38 01
    inc hl              ;1772 23
l1773h:
    dec de              ;1773 1b
    ld a,d              ;1774 7a
    or e                ;1775 b3
    jr z,l177ch         ;1776 28 04
    djnz l176eh         ;1778 10 f4
    jr l1767h           ;177a 18 eb
l177ch:
    add hl,hl           ;177c 29
    ret                 ;177d c9
sub_177eh:
    push de             ;177e d5
    push hl             ;177f e5
    call sub_1797h      ;1780 cd 97 17
    call sub_1982h      ;1783 cd 82 19
    pop hl              ;1786 e1
    pop de              ;1787 d1
    ret                 ;1788 c9
sub_1789h:
    push de             ;1789 d5
    push hl             ;178a e5
    call sub_1973h      ;178b cd 73 19
    call sub_1797h      ;178e cd 97 17
    call l19b3h         ;1791 cd b3 19
    pop hl              ;1794 e1
    pop de              ;1795 d1
    ret                 ;1796 c9
sub_1797h:
    ld a,(l2004h)       ;1797 3a 04 20
    ld b,a              ;179a 47
    srl d               ;179b cb 3a
    rr e                ;179d cb 1b
    srl d               ;179f cb 3a
    rr e                ;17a1 cb 1b
    srl d               ;17a3 cb 3a
    rr e                ;17a5 cb 1b
    ld hl,(l2024h)      ;17a7 2a 24 20
    add hl,de           ;17aa 19
    ex de,hl            ;17ab eb
    ld a,(l2026h)       ;17ac 3a 26 20
    adc a,00h           ;17af ce 00
    ld hl,2af5h         ;17b1 21 f5 2a
    ret                 ;17b4 c9
sub_17b5h:
    push de             ;17b5 d5
    push hl             ;17b6 e5
    call sub_17ceh      ;17b7 cd ce 17
    call sub_1982h      ;17ba cd 82 19
    pop de              ;17bd d1
    pop hl              ;17be e1
    ret                 ;17bf c9
sub_17c0h:
    push de             ;17c0 d5
    push hl             ;17c1 e5
    call sub_1973h      ;17c2 cd 73 19
    call sub_17ceh      ;17c5 cd ce 17
    call l19b3h         ;17c8 cd b3 19
    pop de              ;17cb d1
    pop hl              ;17cc e1
    ret                 ;17cd c9
sub_17ceh:
    ld a,(l2004h)       ;17ce 3a 04 20
    ld b,a              ;17d1 47
    ld hl,(l202ch)      ;17d2 2a 2c 20
    ld a,(l202eh)       ;17d5 3a 2e 20
    add hl,de           ;17d8 19
    ex de,hl            ;17d9 eb
    adc a,00h           ;17da ce 00
    ld hl,(2aeah)       ;17dc 2a ea 2a
    ret                 ;17df c9
sub_17e0h:
    push de             ;17e0 d5
    push hl             ;17e1 e5
    call sub_17f6h      ;17e2 cd f6 17
    call sub_1982h      ;17e5 cd 82 19
    pop hl              ;17e8 e1
    pop de              ;17e9 d1
    ret                 ;17ea c9
sub_17ebh:
    push de             ;17eb d5
    push hl             ;17ec e5
    call sub_17f6h      ;17ed cd f6 17
    call l19b3h         ;17f0 cd b3 19
    pop hl              ;17f3 e1
    pop de              ;17f4 d1
    ret                 ;17f5 c9
sub_17f6h:
    push ix             ;17f6 dd e5
    push iy             ;17f8 fd e5
    ld a,(2d6dh)        ;17fa 3a 6d 2d
    ld iy,(2ae8h)       ;17fd fd 2a e8 2a
    cp (iy+26h)         ;1801 fd be 26
    jr z,l1847h         ;1804 28 41
    ld (iy+26h),a       ;1806 fd 77 26
    ld c,a              ;1809 4f
    ld b,00h            ;180a 06 00
    ld ix,(2aeeh)       ;180c dd 2a ee 2a
    add ix,bc           ;1810 dd 09
    add ix,bc           ;1812 dd 09
    ld e,(ix+00h)       ;1814 dd 5e 00
    ld d,(ix+01h)       ;1817 dd 56 01
    ld a,e              ;181a 7b
    and d               ;181b a2
    inc a               ;181c 3c
    push af             ;181d f5
    call nz,sub_17b5h   ;181e c4 b5 17
    pop af              ;1821 f1
    jr nz,l1847h        ;1822 20 23
    ld de,l2057h        ;1824 11 57 20
    ld bc,(l202fh)      ;1827 ed 4b 2f 20
    call sub_16bah      ;182b cd ba 16
    ld (ix+00h),l       ;182e dd 75 00
    ld (ix+01h),h       ;1831 dd 74 01
    ld hl,(2aeah)       ;1834 2a ea 2a
    ld b,00h            ;1837 06 00
l1839h:
    ld (hl),0ffh        ;1839 36 ff
    inc hl              ;183b 23
    djnz l1839h         ;183c 10 fb
    ld e,(iy+23h)       ;183e fd 5e 23
    ld d,(iy+24h)       ;1841 fd 56 24
    call sub_18eeh      ;1844 cd ee 18
l1847h:
    ld a,(2d6ah)        ;1847 3a 6a 2d
    ld c,a              ;184a 4f
    ld b,00h            ;184b 06 00
    ld ix,(2aeah)       ;184d dd 2a ea 2a
    add ix,bc           ;1851 dd 09
    add ix,bc           ;1853 dd 09
    ld l,(ix+00h)       ;1855 dd 6e 00
    ld h,(ix+01h)       ;1858 dd 66 01
    ld a,l              ;185b 7d
    and h               ;185c a4
    inc a               ;185d 3c
    jr nz,l1886h        ;185e 20 26
    ld de,2457h         ;1860 11 57 24
    ld bc,(l2034h)      ;1863 ed 4b 34 20
    call sub_16bah      ;1867 cd ba 16
    ld (ix+00h),l       ;186a dd 75 00
    ld (ix+01h),h       ;186d dd 74 01
    ld c,(iy+26h)       ;1870 fd 4e 26
    ld b,00h            ;1873 06 00
    ld ix,(2aeeh)       ;1875 dd 2a ee 2a
    add ix,bc           ;1879 dd 09
    add ix,bc           ;187b dd 09
    ld e,(ix+00h)       ;187d dd 5e 00
    ld d,(ix+01h)       ;1880 dd 56 01
    call sub_17c0h      ;1883 cd c0 17
l1886h:
    ld ix,(2aeah)       ;1886 dd 2a ea 2a
    ld a,(2d6ah)        ;188a 3a 6a 2d
    add a,a             ;188d 87
    ld e,a              ;188e 5f
    ld d,00h            ;188f 16 00
    add ix,de           ;1891 dd 19
    ld l,(ix+00h)       ;1893 dd 6e 00
    ld h,(ix+01h)       ;1896 dd 66 01
    xor a               ;1899 af
    ld b,03h            ;189a 06 03
l189ch:
    add hl,hl           ;189c 29
    adc a,a             ;189d 8f
    djnz l189ch         ;189e 10 fc
    ld de,(2d6ch)       ;18a0 ed 5b 6c 2d
    ld d,00h            ;18a4 16 00
    add hl,de           ;18a6 19
    ld de,(l2031h)      ;18a7 ed 5b 31 20
    add hl,de           ;18ab 19
    ex de,hl            ;18ac eb
    ld b,a              ;18ad 47
    ld a,(l2033h)       ;18ae 3a 33 20
    adc a,b             ;18b1 88
    ld hl,l2004h        ;18b2 21 04 20
    ld b,(hl)           ;18b5 46
    ld hl,(2aech)       ;18b6 2a ec 2a
    pop iy              ;18b9 fd e1
    pop ix              ;18bb dd e1
    ret                 ;18bd c9
sub_18beh:
    push hl             ;18be e5
    push de             ;18bf d5
    push bc             ;18c0 c5
    srl d               ;18c1 cb 3a
    rr e                ;18c3 cb 1b
    push af             ;18c5 f5
    ld hl,(l2027h)      ;18c6 2a 27 20
    ld a,(l2029h)       ;18c9 3a 29 20
    add hl,de           ;18cc 19
    adc a,00h           ;18cd ce 00
    ex de,hl            ;18cf eb
    ld hl,l2004h        ;18d0 21 04 20
    ld b,(hl)           ;18d3 46
    ld hl,4710h         ;18d4 21 10 47
    call sub_1982h      ;18d7 cd 82 19
    pop af              ;18da f1
    ld hl,4710h         ;18db 21 10 47
    ld bc,0080h         ;18de 01 80 00
    jr nc,l18e4h        ;18e1 30 01
    add hl,bc           ;18e3 09
l18e4h:
    ld de,(2aeeh)       ;18e4 ed 5b ee 2a
    ldir                ;18e8 ed b0
    pop bc              ;18ea c1
    pop de              ;18eb d1
    pop hl              ;18ec e1
    ret                 ;18ed c9
sub_18eeh:
    push hl             ;18ee e5
    push de             ;18ef d5
    push bc             ;18f0 c5
    call sub_1973h      ;18f1 cd 73 19
    srl d               ;18f4 cb 3a
    rr e                ;18f6 cb 1b
    ex af,af'           ;18f8 08
    ld hl,(l2027h)      ;18f9 2a 27 20
    ld a,(l2029h)       ;18fc 3a 29 20
    add hl,de           ;18ff 19
    adc a,00h           ;1900 ce 00
    ex de,hl            ;1902 eb
    ld hl,l2004h        ;1903 21 04 20
    ld b,(hl)           ;1906 46
    ld hl,4710h         ;1907 21 10 47
    push af             ;190a f5
    push de             ;190b d5
    push bc             ;190c c5
    call sub_1982h      ;190d cd 82 19
    ex af,af'           ;1910 08
    ld hl,4710h         ;1911 21 10 47
    ld bc,0080h         ;1914 01 80 00
    jr nc,l191ah        ;1917 30 01
    add hl,bc           ;1919 09
l191ah:
    ex de,hl            ;191a eb
    ld hl,(2aeeh)       ;191b 2a ee 2a
    ldir                ;191e ed b0
    pop bc              ;1920 c1
    pop de              ;1921 d1
    pop af              ;1922 f1
    ld hl,4710h         ;1923 21 10 47
    call l19b3h         ;1926 cd b3 19
    pop bc              ;1929 c1
    pop de              ;192a d1
    pop hl              ;192b e1
    ret                 ;192c c9
sub_192dh:
    ld a,(l2004h)       ;192d 3a 04 20
    ld b,a              ;1930 47
    ld de,(l2005h)      ;1931 ed 5b 05 20
    ld a,(l2007h)       ;1935 3a 07 20
    ld hl,4610h         ;1938 21 10 46
    jp sub_1982h        ;193b c3 82 19
l193eh:
    ld a,(l2004h)       ;193e 3a 04 20
    ld b,a              ;1941 47
    ld de,(l2005h)      ;1942 ed 5b 05 20
    ld a,(l2007h)       ;1946 3a 07 20
    ld hl,4610h         ;1949 21 10 46
    jp l19b3h           ;194c c3 b3 19
sub_194fh:
    call sub_195bh      ;194f cd 5b 19
    jp sub_1982h        ;1952 c3 82 19
sub_1955h:
    call sub_195bh      ;1955 cd 5b 19
    jp l19b3h           ;1958 c3 b3 19
sub_195bh:
    ld de,(l204eh)      ;195b ed 5b 4e 20
    ld d,00h            ;195f 16 00
    ld hl,(l203bh)      ;1961 2a 3b 20
    ld a,(l203dh)       ;1964 3a 3d 20
    add hl,de           ;1967 19
    adc a,00h           ;1968 ce 00
    ex de,hl            ;196a eb
    ld hl,l2004h        ;196b 21 04 20
    ld b,(hl)           ;196e 46
    ld hl,4910h         ;196f 21 10 49
    ret                 ;1972 c9
sub_1973h:
    ld a,(l200ah)       ;1973 3a 0a 20
    or a                ;1976 b7
    ret z               ;1977 c8
    ld a,(l2002h)       ;1978 3a 02 20
    or a                ;197b b7
    ret z               ;197c c8
    ld a,5ch            ;197d 3e 5c
    jp 05cfh            ;197f c3 cf 05
sub_1982h:
    ld (4a10h),de       ;1982 ed 53 10 4a
    ld (4a12h),a        ;1986 32 12 4a
    push hl             ;1989 e5
    ld a,21h            ;198a 3e 21
    call sub_19f0h      ;198c cd f0 19
    call sub_1a29h      ;198f cd 29 1a
    call sub_1a0dh      ;1992 cd 0d 1a
    pop hl              ;1995 e1
    jr nz,l19dfh        ;1996 20 47
    ld a,41h            ;1998 3e 41
    call sub_19f0h      ;199a cd f0 19
    ld b,00h            ;199d 06 00
l199fh:
    in a,(18h)          ;199f db 18
    ld (hl),a           ;19a1 77
    inc hl              ;19a2 23
    ex (sp),hl          ;19a3 e3
    ex (sp),hl          ;19a4 e3
    djnz l199fh         ;19a5 10 f8
    call sub_1a0dh      ;19a7 cd 0d 1a
    ret z               ;19aa c8
    ld (l2051h),a       ;19ab 32 51 20
    ld a,16h            ;19ae 3e 16
    jp l19dfh           ;19b0 c3 df 19
l19b3h:
    ld (4a10h),de       ;19b3 ed 53 10 4a
    ld (4a12h),a        ;19b7 32 12 4a
    ld a,42h            ;19ba 3e 42
    call sub_19f0h      ;19bc cd f0 19
    ld b,00h            ;19bf 06 00
l19c1h:
    ld a,(hl)           ;19c1 7e
    out (18h),a         ;19c2 d3 18
    inc hl              ;19c4 23
    ex (sp),hl          ;19c5 e3
    ex (sp),hl          ;19c6 e3
    djnz l19c1h         ;19c7 10 f8
    call sub_1a0dh      ;19c9 cd 0d 1a
    jr nz,l19dfh        ;19cc 20 11
    ld a,22h            ;19ce 3e 22
    call sub_19f0h      ;19d0 cd f0 19
    call sub_1a29h      ;19d3 cd 29 1a
    call sub_1a0dh      ;19d6 cd 0d 1a
    ret z               ;19d9 c8
    ld (l2051h),a       ;19da 32 51 20
    ld a,19h            ;19dd 3e 19
l19dfh:
    push af             ;19df f5
    ld hl,(4a10h)       ;19e0 2a 10 4a
    ld (l2054h),hl      ;19e3 22 54 20
    ld a,(4a12h)        ;19e6 3a 12 4a
    ld (l2056h),a       ;19e9 32 56 20
    pop af              ;19ec f1
    jp sub_05dbh        ;19ed c3 db 05
sub_19f0h:
    ld b,a              ;19f0 47
    xor a               ;19f1 af
    out (18h),a         ;19f2 d3 18
l19f4h:
    in a,(18h)          ;19f4 db 18
    cp 0a0h             ;19f6 fe a0
    jr nz,l19f4h        ;19f8 20 fa
    ld a,b              ;19fa 78
    out (18h),a         ;19fb d3 18
l19fdh:
    in a,(18h)          ;19fd db 18
    cp 0a1h             ;19ff fe a1
    jr nz,l19fdh        ;1a01 20 fa
    ld a,0ffh           ;1a03 3e ff
    out (18h),a         ;1a05 d3 18
    ld b,14h            ;1a07 06 14
l1a09h:
    nop                 ;1a09 00
    djnz l1a09h         ;1a0a 10 fd
    ret                 ;1a0c c9
sub_1a0dh:
    ld a,0ffh           ;1a0d 3e ff
    out (18h),a         ;1a0f d3 18
l1a11h:
    in a,(18h)          ;1a11 db 18
    inc a               ;1a13 3c
    jr nz,l1a11h        ;1a14 20 fb
    ld a,0feh           ;1a16 3e fe
    out (18h),a         ;1a18 d3 18
l1a1ah:
    in a,(18h)          ;1a1a db 18
    rla                 ;1a1c 17
    jr c,l1a1ah         ;1a1d 38 fb
    in a,(18h)          ;1a1f db 18
    bit 6,a             ;1a21 cb 77
    push af             ;1a23 f5
    xor a               ;1a24 af
    out (18h),a         ;1a25 d3 18
    pop af              ;1a27 f1
    ret                 ;1a28 c9
sub_1a29h:
    xor a               ;1a29 af
    out (18h),a         ;1a2a d3 18
    ld hl,(4a10h)       ;1a2c 2a 10 4a
    ld a,(4a12h)        ;1a2f 3a 12 4a
    ld b,05h            ;1a32 06 05
l1a34h:
    rra                 ;1a34 1f
    rr h                ;1a35 cb 1c
    rr l                ;1a37 cb 1d
    djnz l1a34h         ;1a39 10 f9
    ld a,(0133h)        ;1a3b 3a 33 01
    inc a               ;1a3e 3c
    add a,a             ;1a3f 87
    add a,a             ;1a40 87
    add a,a             ;1a41 87
    add a,a             ;1a42 87
    ld b,a              ;1a43 47
    ld c,00h            ;1a44 0e 00
    ld de,0000h         ;1a46 11 00 00
    ld a,0dh            ;1a49 3e 0d
l1a4bh:
    ex de,hl            ;1a4b eb
    add hl,hl           ;1a4c 29
    ex de,hl            ;1a4d eb
    or a                ;1a4e b7
    sbc hl,bc           ;1a4f ed 42
    jr nc,l1a56h        ;1a51 30 03
    add hl,bc           ;1a53 09
    jr l1a57h           ;1a54 18 01
l1a56h:
    inc de              ;1a56 13
l1a57h:
    srl b               ;1a57 cb 38
    rr c                ;1a59 cb 19
    dec a               ;1a5b 3d
    jr nz,l1a4bh        ;1a5c 20 ed
    ld a,l              ;1a5e 7d
    out (18h),a         ;1a5f d3 18
    ld hl,(l0134h)      ;1a61 2a 34 01
    add hl,de           ;1a64 19
    ld a,l              ;1a65 7d
    out (18h),a         ;1a66 d3 18
    ld a,h              ;1a68 7c
    out (18h),a         ;1a69 d3 18
    ld a,(4a10h)        ;1a6b 3a 10 4a
    and 1fh             ;1a6e e6 1f
    out (18h),a         ;1a70 d3 18
    xor a               ;1a72 af
    out (18h),a         ;1a73 d3 18
    out (18h),a         ;1a75 d3 18
    out (18h),a         ;1a77 d3 18
    ret                 ;1a79 c9
sub_1a7ah:
    srl h               ;1a7a cb 3c
    rr l                ;1a7c cb 1d
    djnz sub_1a7ah      ;1a7e 10 fa
    ret                 ;1a80 c9
l1a81h:
    nop                 ;1a81 00
    jr nz,$+81          ;1a82 20 4f
    rlc c               ;1a84 cb 01
    ld bc,l2053h        ;1a86 01 53 20
    ld d,e              ;1a89 53
    ld b,e              ;1a8a 43
    ld d,d              ;1a8b 52
    ld b,c              ;1a8c 41
    ld d,h              ;1a8d 54
    ld b,e              ;1a8e 43
    ld c,b              ;1a8f 48
    ld b,l              ;1a90 45
    call nz,sub_0716h   ;1a91 c4 16 07
    add a,e             ;1a94 83
    add hl,de           ;1a95 19
    ld (bc),a           ;1a96 02
    add a,e             ;1a97 83
    ld a,(de)           ;1a98 1a
    ld (bc),a           ;1a99 02
    jr nz,l1aech        ;1a9a 20 50
    ld d,d              ;1a9c 52
    ld c,a              ;1a9d 4f
    ld d,h              ;1a9e 54
    ld b,l              ;1a9f 45
    ld b,e              ;1aa0 43
    ld d,h              ;1aa1 54
    ld b,l              ;1aa2 45
    call nz,sub_041eh   ;1aa3 c4 1e 04
    add a,e             ;1aa6 83
    rra                 ;1aa7 1f
    inc b               ;1aa8 04
    inc bc              ;1aa9 03
    jr nz,$+42          ;1aaa 20 28
    dec b               ;1aac 05
    jr nz,l1ab5h        ;1aad 20 06
    xor c               ;1aaf a9
    jr nz,l1ab6h        ;1ab0 20 04
    inc bc              ;1ab2 03
    jr nz,$+42          ;1ab3 20 28
l1ab5h:
    ld c,h              ;1ab5 4c
l1ab6h:
    ld c,a              ;1ab6 4f
    ld c,(hl)           ;1ab7 4e
    ld b,a              ;1ab8 47
    jr nz,l1b07h        ;1ab9 20 4c
    ld c,c              ;1abb 49
    ld c,(hl)           ;1abc 4e
    ld b,l              ;1abd 45
    xor c               ;1abe a9
    ld hl,0304h         ;1abf 21 04 03
    jr z,$+7            ;1ac2 28 05
    jr nz,l1ac7h        ;1ac4 20 01
    ex af,af'           ;1ac6 08
l1ac7h:
    xor c               ;1ac7 a9
    ld (0304h),hl       ;1ac8 22 04 03
    jr z,l1b1bh         ;1acb 28 4e
    ld c,a              ;1acd 4f
    jr nz,l1ad1h        ;1ace 20 01
    ex af,af'           ;1ad0 08
l1ad1h:
    xor c               ;1ad1 a9
    ld (0b09h),a        ;1ad2 32 09 0b
    jr nz,l1b27h        ;1ad5 20 50
    ld d,d              ;1ad7 52
    ld b,l              ;1ad8 45
    ld d,e              ;1ad9 53
    ld b,l              ;1ada 45
    ld c,(hl)           ;1adb 4e
    call nc,4f33h       ;1adc d4 33 4f
    ld d,(hl)           ;1adf 56
    ld b,l              ;1ae0 45
    ld d,d              ;1ae1 52
    ld b,(hl)           ;1ae2 46
    ld c,h              ;1ae3 4c
    ld c,a              ;1ae4 4f
    ld d,a              ;1ae5 57
    jr nz,l1b31h        ;1ae6 20 49
    ld c,(hl)           ;1ae8 4e
    jr nz,$-117         ;1ae9 20 89
    inc (hl)            ;1aeb 34
l1aech:
    ld bc,5420h         ;1aec 01 20 54
    ld c,a              ;1aef 4f
    ld c,a              ;1af0 4f
    jr nz,l1b3fh        ;1af1 20 4c
    ld b,c              ;1af3 41
    ld d,d              ;1af4 52
    ld b,a              ;1af5 47
    push bc             ;1af6 c5
    inc a               ;1af7 3c
    ld (bc),a           ;1af8 02
    jr nz,l1afch        ;1af9 20 01
    adc a,d             ;1afb 8a
l1afch:
    dec a               ;1afc 3d
    ld bc,8a0bh         ;1afd 01 0b 8a
    ld a,01h            ;1b00 3e 01
l1b02h:
    dec bc              ;1b02 0b
    jr nz,l1b4bh        ;1b03 20 46
    ld c,a              ;1b05 4f
    ld d,l              ;1b06 55
l1b07h:
    ld c,(hl)           ;1b07 4e
    call nz,sub_013fh   ;1b08 c4 3f 01
l1b0bh:
    jr nz,l1b52h        ;1b0b 20 45
    ld e,b              ;1b0d 58
    ld c,c              ;1b0e 49
    ld d,e              ;1b0f 53
    ld d,h              ;1b10 54
    out (40h),a         ;1b11 d3 40
    ld bc,5420h         ;1b13 01 20 54
    ld e,c              ;1b16 59
    ld d,b              ;1b17 50
    ld b,l              ;1b18 45
    jr nz,l1b68h        ;1b19 20 4d
l1b1bh:
    ld c,c              ;1b1b 49
    ld d,e              ;1b1c 53
    ld c,l              ;1b1d 4d
    ld b,c              ;1b1e 41
    ld d,h              ;1b1f 54
    ld b,e              ;1b20 43
    ret z               ;1b21 c8
    ld b,c              ;1b22 41
    ld c,(hl)           ;1b23 4e
    ld c,a              ;1b24 4f
    jr nz,l1b69h        ;1b25 20 42
l1b27h:
    ld c,h              ;1b27 4c
    ld c,a              ;1b28 4f
    ld b,e              ;1b29 43
    bit 0,d             ;1b2a cb 42
    ld c,c              ;1b2c 49
    ld c,h              ;1b2d 4c
    ld c,h              ;1b2e 4c
    ld b,l              ;1b2f 45
    ld b,a              ;1b30 47
l1b31h:
    ld b,c              ;1b31 41
    ld c,h              ;1b32 4c
    jr nz,l1b89h        ;1b33 20 54
    ld d,d              ;1b35 52
    ld b,c              ;1b36 41
    ld b,e              ;1b37 43
    ld c,e              ;1b38 4b
    jr nz,l1b8ah        ;1b39 20 4f
    ld d,d              ;1b3b 52
    jr nz,l1b91h        ;1b3c 20 53
    ld b,l              ;1b3e 45
l1b3fh:
    ld b,e              ;1b3f 43
    ld d,h              ;1b40 54
    ld c,a              ;1b41 4f
    jp nc,4448h         ;1b42 d2 48 44
    ld c,c              ;1b45 49
    ld d,e              ;1b46 53
    ld c,e              ;1b47 4b
    jr nz,l1b90h        ;1b48 20 46
    ld d,l              ;1b4a 55
l1b4bh:
    ld c,h              ;1b4b 4c
    call z,sub_0e54h    ;1b4c cc 54 0e
    dec bc              ;1b4f 0b
    jr nz,l1b95h        ;1b50 20 43
l1b52h:
    ld c,a              ;1b52 4f
    ld c,(hl)           ;1b53 4e
    ld b,(hl)           ;1b54 46
    ld c,c              ;1b55 49
    ld b,a              ;1b56 47
    ld d,l              ;1b57 55
    ld d,d              ;1b58 52
    ld b,l              ;1b59 45
    call nz,0c59h       ;1b5a c4 59 0c
    jr nz,l1b02h        ;1b5d 20 a3
    ld e,d              ;1b5f 5a
    dec b               ;1b60 05
    jr nz,$+14          ;1b61 20 0c
    jr nz,$-118         ;1b63 20 88
    ld e,e              ;1b65 5b
    ld d,b              ;1b66 50
    ld b,c              ;1b67 41
l1b68h:
    ld d,e              ;1b68 53
l1b69h:
    ld d,e              ;1b69 53
    ld d,a              ;1b6a 57
    ld c,a              ;1b6b 4f
    ld d,d              ;1b6c 52
    ld b,h              ;1b6d 44
    jr nz,$+75          ;1b6e 20 49
    ld c,(hl)           ;1b70 4e
    ld b,e              ;1b71 43
    ld c,a              ;1b72 4f
    ld d,d              ;1b73 52
    ld d,d              ;1b74 52
    ld b,l              ;1b75 45
    ld b,e              ;1b76 43
    call nc,505ch       ;1b77 d4 5c 50
    ld d,d              ;1b7a 52
    ld c,c              ;1b7b 49
    ld d,(hl)           ;1b7c 56
    ld c,c              ;1b7d 49
    ld c,h              ;1b7e 4c
    ld b,l              ;1b7f 45
    ld b,a              ;1b80 47
    ld b,l              ;1b81 45
    ld b,h              ;1b82 44
    jr nz,l1b0bh        ;1b83 20 86
    ld h,e              ;1b85 63
    ld d,e              ;1b86 53
    ld c,l              ;1b87 4d
    ld b,c              ;1b88 41
l1b89h:
    ld c,h              ;1b89 4c
l1b8ah:
    ld c,h              ;1b8a 4c
    jr nz,$+85          ;1b8b 20 53
    ld e,c              ;1b8d 59
    ld d,e              ;1b8e 53
    ld d,h              ;1b8f 54
l1b90h:
    ld b,l              ;1b90 45
l1b91h:
    ld c,l              ;1b91 4d
    ld d,e              ;1b92 53
    jr nz,l1bddh        ;1b93 20 48
l1b95h:
    ld b,c              ;1b95 41
    ld d,d              ;1b96 52
    ld b,h              ;1b97 44
    ld b,d              ;1b98 42
    ld c,a              ;1b99 4f
    ld e,b              ;1b9a 58
    adc a,l             ;1b9b 8d
    rst 38h             ;1b9c ff
    ld d,l              ;1b9d 55
    ld c,(hl)           ;1b9e 4e
    ld c,e              ;1b9f 4b
    ld c,(hl)           ;1ba0 4e
    ld c,a              ;1ba1 4f
    ld d,a              ;1ba2 57
    ld c,(hl)           ;1ba3 4e
    inc bc              ;1ba4 03
    jr nz,l1beah        ;1ba5 20 43
    ld c,a              ;1ba7 4f
    ld b,h              ;1ba8 44
    push bc             ;1ba9 c5
l1baah:
    ld b,(hl)           ;1baa 46
    ld c,c              ;1bab 49
    ld c,h              ;1bac 4c
    push bc             ;1bad c5
    ld d,a              ;1bae 57
    ld d,d              ;1baf 52
    ld c,c              ;1bb0 49
    ld d,h              ;1bb1 54
    push bc             ;1bb2 c5
    jr nz,l1bfah        ;1bb3 20 45
    ld d,d              ;1bb5 52
    ld d,d              ;1bb6 52
    ld c,a              ;1bb7 4f
    jp nc,5953h         ;1bb8 d2 53 59
    ld c,(hl)           ;1bbb 4e
    ld d,h              ;1bbc 54
    ld b,c              ;1bbd 41
    ret c               ;1bbe d8
    ld c,c              ;1bbf 49
    ld c,(hl)           ;1bc0 4e
    ld d,(hl)           ;1bc1 56
    ld b,c              ;1bc2 41
    ld c,h              ;1bc3 4c
    ld c,c              ;1bc4 49
    call nz,4f43h       ;1bc5 c4 43 4f
    ld c,l              ;1bc8 4d
    ld c,l              ;1bc9 4d
    ld b,c              ;1bca 41
    ld c,(hl)           ;1bcb 4e
    call nz,4552h       ;1bcc c4 52 45
    ld b,c              ;1bcf 41
    call nz,414eh       ;1bd0 c4 4e 41
    ld c,l              ;1bd3 4d
    push bc             ;1bd4 c5
    ld d,d              ;1bd5 52
    ld b,l              ;1bd6 45
    ld b,e              ;1bd7 43
    ld c,a              ;1bd8 4f
    ld d,d              ;1bd9 52
    call nz,4f20h       ;1bda c4 20 4f
l1bddh:
    ld d,b              ;1bdd 50
    ld b,l              ;1bde 45
    adc a,20h           ;1bdf ce 20
    ld c,(hl)           ;1be1 4e
    ld c,a              ;1be2 4f
    call nc,5355h       ;1be3 d4 55 53
    ld b,l              ;1be6 45
    jp nc,5620h         ;1be7 d2 20 56
l1beah:
    ld b,l              ;1bea 45
    ld d,d              ;1beb 52
    ld d,e              ;1bec 53
    ld c,c              ;1bed 49
    ld c,a              ;1bee 4f
    ld c,(hl)           ;1bef 4e
    jr nz,l1b95h        ;1bf0 20 a3
    ld b,h              ;1bf2 44
    ld d,d              ;1bf3 52
    ld c,c              ;1bf4 49
    ld d,(hl)           ;1bf5 56
    push bc             ;1bf6 c5
    ld b,e              ;1bf7 43
    ld c,a              ;1bf8 4f
    ld d,d              ;1bf9 52
l1bfah:
    ld d,(hl)           ;1bfa 56
    ld d,l              ;1bfb 55
    out (00h),a         ;1bfc d3 00
    nop                 ;1bfe 00
    nop                 ;1bff 00
    nop                 ;1c00 00
    nop                 ;1c01 00
    nop                 ;1c02 00
    nop                 ;1c03 00
    nop                 ;1c04 00
    nop                 ;1c05 00
    nop                 ;1c06 00
    nop                 ;1c07 00
    nop                 ;1c08 00
    nop                 ;1c09 00
    nop                 ;1c0a 00
    nop                 ;1c0b 00
    nop                 ;1c0c 00
    nop                 ;1c0d 00
    nop                 ;1c0e 00
    nop                 ;1c0f 00
    nop                 ;1c10 00
    nop                 ;1c11 00
    nop                 ;1c12 00
    nop                 ;1c13 00
    nop                 ;1c14 00
    nop                 ;1c15 00
    nop                 ;1c16 00
    nop                 ;1c17 00
    nop                 ;1c18 00
    nop                 ;1c19 00
    nop                 ;1c1a 00
    nop                 ;1c1b 00
    nop                 ;1c1c 00
    nop                 ;1c1d 00
    nop                 ;1c1e 00
    nop                 ;1c1f 00
    nop                 ;1c20 00
    nop                 ;1c21 00
    nop                 ;1c22 00
    nop                 ;1c23 00
    nop                 ;1c24 00
    nop                 ;1c25 00
    nop                 ;1c26 00
    nop                 ;1c27 00
    nop                 ;1c28 00
    nop                 ;1c29 00
    nop                 ;1c2a 00
    nop                 ;1c2b 00
    nop                 ;1c2c 00
    nop                 ;1c2d 00
    nop                 ;1c2e 00
    nop                 ;1c2f 00
    nop                 ;1c30 00
    nop                 ;1c31 00
    nop                 ;1c32 00
    nop                 ;1c33 00
    nop                 ;1c34 00
    nop                 ;1c35 00
    nop                 ;1c36 00
    nop                 ;1c37 00
    nop                 ;1c38 00
    nop                 ;1c39 00
    nop                 ;1c3a 00
    nop                 ;1c3b 00
    nop                 ;1c3c 00
    nop                 ;1c3d 00
    nop                 ;1c3e 00
    nop                 ;1c3f 00
    nop                 ;1c40 00
    nop                 ;1c41 00
    nop                 ;1c42 00
    nop                 ;1c43 00
    nop                 ;1c44 00
    nop                 ;1c45 00
    nop                 ;1c46 00
    nop                 ;1c47 00
    nop                 ;1c48 00
    nop                 ;1c49 00
    nop                 ;1c4a 00
    nop                 ;1c4b 00
    nop                 ;1c4c 00
    nop                 ;1c4d 00
    nop                 ;1c4e 00
    nop                 ;1c4f 00
    nop                 ;1c50 00
    nop                 ;1c51 00
    nop                 ;1c52 00
    nop                 ;1c53 00
    nop                 ;1c54 00
    nop                 ;1c55 00
    nop                 ;1c56 00
    nop                 ;1c57 00
    nop                 ;1c58 00
    nop                 ;1c59 00
    nop                 ;1c5a 00
    nop                 ;1c5b 00
    nop                 ;1c5c 00
    nop                 ;1c5d 00
    nop                 ;1c5e 00
    nop                 ;1c5f 00
    nop                 ;1c60 00
    nop                 ;1c61 00
    nop                 ;1c62 00
    nop                 ;1c63 00
    nop                 ;1c64 00
    nop                 ;1c65 00
    nop                 ;1c66 00
    nop                 ;1c67 00
    nop                 ;1c68 00
    nop                 ;1c69 00
    nop                 ;1c6a 00
    nop                 ;1c6b 00
    nop                 ;1c6c 00
    nop                 ;1c6d 00
    nop                 ;1c6e 00
    nop                 ;1c6f 00
    nop                 ;1c70 00
    nop                 ;1c71 00
    nop                 ;1c72 00
    nop                 ;1c73 00
    nop                 ;1c74 00
    nop                 ;1c75 00
    nop                 ;1c76 00
    nop                 ;1c77 00
    nop                 ;1c78 00
    nop                 ;1c79 00
    nop                 ;1c7a 00
    nop                 ;1c7b 00
    nop                 ;1c7c 00
    nop                 ;1c7d 00
    nop                 ;1c7e 00
    nop                 ;1c7f 00
    nop                 ;1c80 00
    nop                 ;1c81 00
    nop                 ;1c82 00
    nop                 ;1c83 00
    nop                 ;1c84 00
    nop                 ;1c85 00
    nop                 ;1c86 00
    nop                 ;1c87 00
    nop                 ;1c88 00
    nop                 ;1c89 00
    nop                 ;1c8a 00
    nop                 ;1c8b 00
    nop                 ;1c8c 00
    nop                 ;1c8d 00
    nop                 ;1c8e 00
    nop                 ;1c8f 00
    nop                 ;1c90 00
    nop                 ;1c91 00
    nop                 ;1c92 00
    nop                 ;1c93 00
    nop                 ;1c94 00
    nop                 ;1c95 00
    nop                 ;1c96 00
    nop                 ;1c97 00
    nop                 ;1c98 00
    nop                 ;1c99 00
    nop                 ;1c9a 00
    nop                 ;1c9b 00
    nop                 ;1c9c 00
    nop                 ;1c9d 00
    nop                 ;1c9e 00
    nop                 ;1c9f 00
    nop                 ;1ca0 00
    nop                 ;1ca1 00
    nop                 ;1ca2 00
    nop                 ;1ca3 00
    nop                 ;1ca4 00
    nop                 ;1ca5 00
    nop                 ;1ca6 00
    nop                 ;1ca7 00
    nop                 ;1ca8 00
    nop                 ;1ca9 00
    nop                 ;1caa 00
    nop                 ;1cab 00
    nop                 ;1cac 00
    nop                 ;1cad 00
    nop                 ;1cae 00
    nop                 ;1caf 00
    nop                 ;1cb0 00
    nop                 ;1cb1 00
    nop                 ;1cb2 00
    nop                 ;1cb3 00
    nop                 ;1cb4 00
    nop                 ;1cb5 00
    nop                 ;1cb6 00
    nop                 ;1cb7 00
    nop                 ;1cb8 00
    nop                 ;1cb9 00
    nop                 ;1cba 00
    nop                 ;1cbb 00
    nop                 ;1cbc 00
    nop                 ;1cbd 00
    nop                 ;1cbe 00
    nop                 ;1cbf 00
    nop                 ;1cc0 00
    nop                 ;1cc1 00
    nop                 ;1cc2 00
    nop                 ;1cc3 00
    nop                 ;1cc4 00
    nop                 ;1cc5 00
    nop                 ;1cc6 00
    nop                 ;1cc7 00
    nop                 ;1cc8 00
    nop                 ;1cc9 00
    nop                 ;1cca 00
    nop                 ;1ccb 00
    nop                 ;1ccc 00
    nop                 ;1ccd 00
    nop                 ;1cce 00
    nop                 ;1ccf 00
    nop                 ;1cd0 00
    nop                 ;1cd1 00
    nop                 ;1cd2 00
    nop                 ;1cd3 00
    nop                 ;1cd4 00
    nop                 ;1cd5 00
    nop                 ;1cd6 00
    nop                 ;1cd7 00
    nop                 ;1cd8 00
    nop                 ;1cd9 00
    nop                 ;1cda 00
    nop                 ;1cdb 00
    nop                 ;1cdc 00
    nop                 ;1cdd 00
    nop                 ;1cde 00
    nop                 ;1cdf 00
    nop                 ;1ce0 00
    nop                 ;1ce1 00
    nop                 ;1ce2 00
    nop                 ;1ce3 00
    nop                 ;1ce4 00
    nop                 ;1ce5 00
    nop                 ;1ce6 00
    nop                 ;1ce7 00
    nop                 ;1ce8 00
    nop                 ;1ce9 00
    nop                 ;1cea 00
    nop                 ;1ceb 00
    nop                 ;1cec 00
    nop                 ;1ced 00
    nop                 ;1cee 00
    nop                 ;1cef 00
    nop                 ;1cf0 00
    nop                 ;1cf1 00
    nop                 ;1cf2 00
    nop                 ;1cf3 00
    nop                 ;1cf4 00
    nop                 ;1cf5 00
    nop                 ;1cf6 00
    nop                 ;1cf7 00
    nop                 ;1cf8 00
    nop                 ;1cf9 00
    nop                 ;1cfa 00
    nop                 ;1cfb 00
    nop                 ;1cfc 00
    nop                 ;1cfd 00
    nop                 ;1cfe 00
    nop                 ;1cff 00
    nop                 ;1d00 00
    nop                 ;1d01 00
    nop                 ;1d02 00
    nop                 ;1d03 00
    nop                 ;1d04 00
    nop                 ;1d05 00
    nop                 ;1d06 00
    nop                 ;1d07 00
    nop                 ;1d08 00
    nop                 ;1d09 00
    nop                 ;1d0a 00
    nop                 ;1d0b 00
    nop                 ;1d0c 00
    nop                 ;1d0d 00
    nop                 ;1d0e 00
    nop                 ;1d0f 00
    nop                 ;1d10 00
    nop                 ;1d11 00
    nop                 ;1d12 00
    nop                 ;1d13 00
    nop                 ;1d14 00
    nop                 ;1d15 00
    nop                 ;1d16 00
    nop                 ;1d17 00
    nop                 ;1d18 00
    nop                 ;1d19 00
    nop                 ;1d1a 00
    nop                 ;1d1b 00
    nop                 ;1d1c 00
    nop                 ;1d1d 00
    nop                 ;1d1e 00
    nop                 ;1d1f 00
    nop                 ;1d20 00
    nop                 ;1d21 00
    nop                 ;1d22 00
    nop                 ;1d23 00
    nop                 ;1d24 00
    nop                 ;1d25 00
    nop                 ;1d26 00
    nop                 ;1d27 00
    nop                 ;1d28 00
    nop                 ;1d29 00
    nop                 ;1d2a 00
    nop                 ;1d2b 00
    nop                 ;1d2c 00
    nop                 ;1d2d 00
    nop                 ;1d2e 00
    nop                 ;1d2f 00
    nop                 ;1d30 00
    nop                 ;1d31 00
    nop                 ;1d32 00
    nop                 ;1d33 00
    nop                 ;1d34 00
    nop                 ;1d35 00
    nop                 ;1d36 00
    nop                 ;1d37 00
    nop                 ;1d38 00
    nop                 ;1d39 00
    nop                 ;1d3a 00
    nop                 ;1d3b 00
    nop                 ;1d3c 00
    nop                 ;1d3d 00
    nop                 ;1d3e 00
    nop                 ;1d3f 00
    nop                 ;1d40 00
    nop                 ;1d41 00
    nop                 ;1d42 00
    nop                 ;1d43 00
    nop                 ;1d44 00
    nop                 ;1d45 00
    nop                 ;1d46 00
    nop                 ;1d47 00
    nop                 ;1d48 00
    nop                 ;1d49 00
    nop                 ;1d4a 00
    nop                 ;1d4b 00
    nop                 ;1d4c 00
    nop                 ;1d4d 00
    nop                 ;1d4e 00
    nop                 ;1d4f 00
    nop                 ;1d50 00
    nop                 ;1d51 00
    nop                 ;1d52 00
    nop                 ;1d53 00
    nop                 ;1d54 00
    nop                 ;1d55 00
    nop                 ;1d56 00
    nop                 ;1d57 00
    nop                 ;1d58 00
    nop                 ;1d59 00
    nop                 ;1d5a 00
    nop                 ;1d5b 00
    nop                 ;1d5c 00
    nop                 ;1d5d 00
    nop                 ;1d5e 00
    nop                 ;1d5f 00
    nop                 ;1d60 00
    nop                 ;1d61 00
    nop                 ;1d62 00
    nop                 ;1d63 00
    nop                 ;1d64 00
    nop                 ;1d65 00
    nop                 ;1d66 00
    nop                 ;1d67 00
    nop                 ;1d68 00
    nop                 ;1d69 00
    nop                 ;1d6a 00
    nop                 ;1d6b 00
    nop                 ;1d6c 00
    nop                 ;1d6d 00
    nop                 ;1d6e 00
    nop                 ;1d6f 00
    nop                 ;1d70 00
    nop                 ;1d71 00
    nop                 ;1d72 00
    nop                 ;1d73 00
    nop                 ;1d74 00
    nop                 ;1d75 00
    nop                 ;1d76 00
    nop                 ;1d77 00
    nop                 ;1d78 00
    nop                 ;1d79 00
    nop                 ;1d7a 00
    nop                 ;1d7b 00
    nop                 ;1d7c 00
    nop                 ;1d7d 00
    nop                 ;1d7e 00
    nop                 ;1d7f 00
    nop                 ;1d80 00
    nop                 ;1d81 00
    nop                 ;1d82 00
    nop                 ;1d83 00
    nop                 ;1d84 00
    nop                 ;1d85 00
    nop                 ;1d86 00
    nop                 ;1d87 00
    nop                 ;1d88 00
    nop                 ;1d89 00
    nop                 ;1d8a 00
    nop                 ;1d8b 00
    nop                 ;1d8c 00
    nop                 ;1d8d 00
    nop                 ;1d8e 00
    nop                 ;1d8f 00
    nop                 ;1d90 00
    nop                 ;1d91 00
    nop                 ;1d92 00
    nop                 ;1d93 00
    nop                 ;1d94 00
    nop                 ;1d95 00
    nop                 ;1d96 00
    nop                 ;1d97 00
    nop                 ;1d98 00
    nop                 ;1d99 00
    nop                 ;1d9a 00
    nop                 ;1d9b 00
    nop                 ;1d9c 00
    nop                 ;1d9d 00
    nop                 ;1d9e 00
    nop                 ;1d9f 00
    nop                 ;1da0 00
    nop                 ;1da1 00
    nop                 ;1da2 00
    nop                 ;1da3 00
    nop                 ;1da4 00
    nop                 ;1da5 00
    nop                 ;1da6 00
    nop                 ;1da7 00
    nop                 ;1da8 00
    nop                 ;1da9 00
    nop                 ;1daa 00
    nop                 ;1dab 00
    nop                 ;1dac 00
    nop                 ;1dad 00
    nop                 ;1dae 00
    nop                 ;1daf 00
    nop                 ;1db0 00
    nop                 ;1db1 00
    nop                 ;1db2 00
    nop                 ;1db3 00
    nop                 ;1db4 00
    nop                 ;1db5 00
    nop                 ;1db6 00
    nop                 ;1db7 00
    nop                 ;1db8 00
    nop                 ;1db9 00
    nop                 ;1dba 00
    nop                 ;1dbb 00
    nop                 ;1dbc 00
    nop                 ;1dbd 00
    nop                 ;1dbe 00
    nop                 ;1dbf 00
    nop                 ;1dc0 00
    nop                 ;1dc1 00
    nop                 ;1dc2 00
    nop                 ;1dc3 00
    nop                 ;1dc4 00
    nop                 ;1dc5 00
    nop                 ;1dc6 00
    nop                 ;1dc7 00
    nop                 ;1dc8 00
    nop                 ;1dc9 00
    nop                 ;1dca 00
    nop                 ;1dcb 00
    nop                 ;1dcc 00
    nop                 ;1dcd 00
    nop                 ;1dce 00
    nop                 ;1dcf 00
    nop                 ;1dd0 00
    nop                 ;1dd1 00
    nop                 ;1dd2 00
    nop                 ;1dd3 00
    nop                 ;1dd4 00
    nop                 ;1dd5 00
    nop                 ;1dd6 00
    nop                 ;1dd7 00
    nop                 ;1dd8 00
    nop                 ;1dd9 00
    nop                 ;1dda 00
    nop                 ;1ddb 00
    nop                 ;1ddc 00
    nop                 ;1ddd 00
    nop                 ;1dde 00
    nop                 ;1ddf 00
    nop                 ;1de0 00
    nop                 ;1de1 00
    nop                 ;1de2 00
    nop                 ;1de3 00
    nop                 ;1de4 00
    nop                 ;1de5 00
    nop                 ;1de6 00
    nop                 ;1de7 00
    nop                 ;1de8 00
    nop                 ;1de9 00
    nop                 ;1dea 00
    nop                 ;1deb 00
    nop                 ;1dec 00
    nop                 ;1ded 00
    nop                 ;1dee 00
    nop                 ;1def 00
    nop                 ;1df0 00
    nop                 ;1df1 00
    nop                 ;1df2 00
    nop                 ;1df3 00
    nop                 ;1df4 00
    nop                 ;1df5 00
    nop                 ;1df6 00
    nop                 ;1df7 00
    nop                 ;1df8 00
    nop                 ;1df9 00
    nop                 ;1dfa 00
    nop                 ;1dfb 00
    nop                 ;1dfc 00
    nop                 ;1dfd 00
    nop                 ;1dfe 00
    nop                 ;1dff 00
    nop                 ;1e00 00
    nop                 ;1e01 00
    nop                 ;1e02 00
    nop                 ;1e03 00
    nop                 ;1e04 00
    nop                 ;1e05 00
    nop                 ;1e06 00
    nop                 ;1e07 00
    nop                 ;1e08 00
    nop                 ;1e09 00
    nop                 ;1e0a 00
    nop                 ;1e0b 00
    nop                 ;1e0c 00
    nop                 ;1e0d 00
    nop                 ;1e0e 00
    nop                 ;1e0f 00
    nop                 ;1e10 00
    nop                 ;1e11 00
    nop                 ;1e12 00
    nop                 ;1e13 00
    nop                 ;1e14 00
    nop                 ;1e15 00
    nop                 ;1e16 00
    nop                 ;1e17 00
    nop                 ;1e18 00
    nop                 ;1e19 00
    nop                 ;1e1a 00
    nop                 ;1e1b 00
    nop                 ;1e1c 00
    nop                 ;1e1d 00
    nop                 ;1e1e 00
    nop                 ;1e1f 00
    nop                 ;1e20 00
    nop                 ;1e21 00
    nop                 ;1e22 00
    nop                 ;1e23 00
    nop                 ;1e24 00
    nop                 ;1e25 00
    nop                 ;1e26 00
    nop                 ;1e27 00
    nop                 ;1e28 00
    nop                 ;1e29 00
    nop                 ;1e2a 00
    nop                 ;1e2b 00
    nop                 ;1e2c 00
    nop                 ;1e2d 00
    nop                 ;1e2e 00
    nop                 ;1e2f 00
    nop                 ;1e30 00
    nop                 ;1e31 00
    nop                 ;1e32 00
    nop                 ;1e33 00
    nop                 ;1e34 00
    nop                 ;1e35 00
    nop                 ;1e36 00
    nop                 ;1e37 00
    nop                 ;1e38 00
    nop                 ;1e39 00
    nop                 ;1e3a 00
    nop                 ;1e3b 00
    nop                 ;1e3c 00
    nop                 ;1e3d 00
    nop                 ;1e3e 00
    nop                 ;1e3f 00
    nop                 ;1e40 00
    nop                 ;1e41 00
    nop                 ;1e42 00
    nop                 ;1e43 00
    nop                 ;1e44 00
    nop                 ;1e45 00
    nop                 ;1e46 00
    nop                 ;1e47 00
    nop                 ;1e48 00
    nop                 ;1e49 00
    nop                 ;1e4a 00
    nop                 ;1e4b 00
    nop                 ;1e4c 00
    nop                 ;1e4d 00
    nop                 ;1e4e 00
    nop                 ;1e4f 00
    nop                 ;1e50 00
    nop                 ;1e51 00
    nop                 ;1e52 00
    nop                 ;1e53 00
    nop                 ;1e54 00
    nop                 ;1e55 00
    nop                 ;1e56 00
    nop                 ;1e57 00
    nop                 ;1e58 00
    nop                 ;1e59 00
    nop                 ;1e5a 00
    nop                 ;1e5b 00
    nop                 ;1e5c 00
    nop                 ;1e5d 00
    nop                 ;1e5e 00
    nop                 ;1e5f 00
    nop                 ;1e60 00
    nop                 ;1e61 00
    nop                 ;1e62 00
    nop                 ;1e63 00
    nop                 ;1e64 00
    nop                 ;1e65 00
    nop                 ;1e66 00
    nop                 ;1e67 00
    nop                 ;1e68 00
    nop                 ;1e69 00
    nop                 ;1e6a 00
    nop                 ;1e6b 00
    nop                 ;1e6c 00
    nop                 ;1e6d 00
    nop                 ;1e6e 00
    nop                 ;1e6f 00
    nop                 ;1e70 00
    nop                 ;1e71 00
    nop                 ;1e72 00
    nop                 ;1e73 00
    nop                 ;1e74 00
    nop                 ;1e75 00
    nop                 ;1e76 00
    nop                 ;1e77 00
    nop                 ;1e78 00
    nop                 ;1e79 00
    nop                 ;1e7a 00
    nop                 ;1e7b 00
    nop                 ;1e7c 00
    nop                 ;1e7d 00
    nop                 ;1e7e 00
    nop                 ;1e7f 00
    nop                 ;1e80 00
    nop                 ;1e81 00
    nop                 ;1e82 00
    nop                 ;1e83 00
    nop                 ;1e84 00
    nop                 ;1e85 00
    nop                 ;1e86 00
    nop                 ;1e87 00
    nop                 ;1e88 00
    nop                 ;1e89 00
    nop                 ;1e8a 00
    nop                 ;1e8b 00
    nop                 ;1e8c 00
    nop                 ;1e8d 00
    nop                 ;1e8e 00
    nop                 ;1e8f 00
    nop                 ;1e90 00
    nop                 ;1e91 00
    nop                 ;1e92 00
    nop                 ;1e93 00
    nop                 ;1e94 00
    nop                 ;1e95 00
    nop                 ;1e96 00
    nop                 ;1e97 00
    nop                 ;1e98 00
    nop                 ;1e99 00
    nop                 ;1e9a 00
    nop                 ;1e9b 00
    nop                 ;1e9c 00
    nop                 ;1e9d 00
    nop                 ;1e9e 00
    nop                 ;1e9f 00
    nop                 ;1ea0 00
    nop                 ;1ea1 00
    nop                 ;1ea2 00
    nop                 ;1ea3 00
    nop                 ;1ea4 00
    nop                 ;1ea5 00
    nop                 ;1ea6 00
    nop                 ;1ea7 00
    nop                 ;1ea8 00
    nop                 ;1ea9 00
    nop                 ;1eaa 00
    nop                 ;1eab 00
    nop                 ;1eac 00
    nop                 ;1ead 00
    nop                 ;1eae 00
    nop                 ;1eaf 00
    nop                 ;1eb0 00
    nop                 ;1eb1 00
    nop                 ;1eb2 00
    nop                 ;1eb3 00
    nop                 ;1eb4 00
    nop                 ;1eb5 00
    nop                 ;1eb6 00
    nop                 ;1eb7 00
    nop                 ;1eb8 00
    nop                 ;1eb9 00
    nop                 ;1eba 00
    nop                 ;1ebb 00
    nop                 ;1ebc 00
    nop                 ;1ebd 00
    nop                 ;1ebe 00
    nop                 ;1ebf 00
    nop                 ;1ec0 00
    nop                 ;1ec1 00
    nop                 ;1ec2 00
    nop                 ;1ec3 00
    nop                 ;1ec4 00
    nop                 ;1ec5 00
    nop                 ;1ec6 00
    nop                 ;1ec7 00
    nop                 ;1ec8 00
    nop                 ;1ec9 00
    nop                 ;1eca 00
    nop                 ;1ecb 00
    nop                 ;1ecc 00
    nop                 ;1ecd 00
    nop                 ;1ece 00
    nop                 ;1ecf 00
    nop                 ;1ed0 00
    nop                 ;1ed1 00
    nop                 ;1ed2 00
    nop                 ;1ed3 00
    nop                 ;1ed4 00
    nop                 ;1ed5 00
    nop                 ;1ed6 00
    nop                 ;1ed7 00
    nop                 ;1ed8 00
    nop                 ;1ed9 00
    nop                 ;1eda 00
    nop                 ;1edb 00
    nop                 ;1edc 00
    nop                 ;1edd 00
    nop                 ;1ede 00
    nop                 ;1edf 00
    nop                 ;1ee0 00
    nop                 ;1ee1 00
    nop                 ;1ee2 00
    nop                 ;1ee3 00
    nop                 ;1ee4 00
    nop                 ;1ee5 00
    nop                 ;1ee6 00
    nop                 ;1ee7 00
    nop                 ;1ee8 00
    nop                 ;1ee9 00
    nop                 ;1eea 00
    nop                 ;1eeb 00
    nop                 ;1eec 00
    nop                 ;1eed 00
    nop                 ;1eee 00
    nop                 ;1eef 00
    nop                 ;1ef0 00
    nop                 ;1ef1 00
    nop                 ;1ef2 00
    nop                 ;1ef3 00
    nop                 ;1ef4 00
    nop                 ;1ef5 00
    nop                 ;1ef6 00
    nop                 ;1ef7 00
    nop                 ;1ef8 00
    nop                 ;1ef9 00
    nop                 ;1efa 00
    nop                 ;1efb 00
    nop                 ;1efc 00
    nop                 ;1efd 00
    nop                 ;1efe 00
    nop                 ;1eff 00
    nop                 ;1f00 00
    nop                 ;1f01 00
    nop                 ;1f02 00
    nop                 ;1f03 00
    nop                 ;1f04 00
    nop                 ;1f05 00
    nop                 ;1f06 00
    nop                 ;1f07 00
    nop                 ;1f08 00
    nop                 ;1f09 00
    nop                 ;1f0a 00
    nop                 ;1f0b 00
    nop                 ;1f0c 00
    nop                 ;1f0d 00
    nop                 ;1f0e 00
    nop                 ;1f0f 00
    nop                 ;1f10 00
    nop                 ;1f11 00
    nop                 ;1f12 00
    nop                 ;1f13 00
    nop                 ;1f14 00
    nop                 ;1f15 00
    nop                 ;1f16 00
    nop                 ;1f17 00
    nop                 ;1f18 00
    nop                 ;1f19 00
    nop                 ;1f1a 00
    nop                 ;1f1b 00
    nop                 ;1f1c 00
    nop                 ;1f1d 00
    nop                 ;1f1e 00
    nop                 ;1f1f 00
    nop                 ;1f20 00
    nop                 ;1f21 00
    nop                 ;1f22 00
    nop                 ;1f23 00
    nop                 ;1f24 00
    nop                 ;1f25 00
    nop                 ;1f26 00
    nop                 ;1f27 00
    nop                 ;1f28 00
    nop                 ;1f29 00
    nop                 ;1f2a 00
    nop                 ;1f2b 00
    nop                 ;1f2c 00
    nop                 ;1f2d 00
    nop                 ;1f2e 00
    nop                 ;1f2f 00
    nop                 ;1f30 00
    nop                 ;1f31 00
    nop                 ;1f32 00
    nop                 ;1f33 00
    nop                 ;1f34 00
    nop                 ;1f35 00
    nop                 ;1f36 00
    nop                 ;1f37 00
    nop                 ;1f38 00
    nop                 ;1f39 00
    nop                 ;1f3a 00
    nop                 ;1f3b 00
    nop                 ;1f3c 00
    nop                 ;1f3d 00
    nop                 ;1f3e 00
    nop                 ;1f3f 00
    nop                 ;1f40 00
    nop                 ;1f41 00
    nop                 ;1f42 00
    nop                 ;1f43 00
    nop                 ;1f44 00
    nop                 ;1f45 00
    nop                 ;1f46 00
    nop                 ;1f47 00
    nop                 ;1f48 00
    nop                 ;1f49 00
    nop                 ;1f4a 00
    nop                 ;1f4b 00
    nop                 ;1f4c 00
    nop                 ;1f4d 00
    nop                 ;1f4e 00
    nop                 ;1f4f 00
    nop                 ;1f50 00
    nop                 ;1f51 00
    nop                 ;1f52 00
    nop                 ;1f53 00
    nop                 ;1f54 00
    nop                 ;1f55 00
    nop                 ;1f56 00
    nop                 ;1f57 00
    nop                 ;1f58 00
    nop                 ;1f59 00
    nop                 ;1f5a 00
    nop                 ;1f5b 00
    nop                 ;1f5c 00
    nop                 ;1f5d 00
    nop                 ;1f5e 00
    nop                 ;1f5f 00
    nop                 ;1f60 00
    nop                 ;1f61 00
    nop                 ;1f62 00
    nop                 ;1f63 00
    nop                 ;1f64 00
    nop                 ;1f65 00
    nop                 ;1f66 00
    nop                 ;1f67 00
    nop                 ;1f68 00
    nop                 ;1f69 00
    nop                 ;1f6a 00
    nop                 ;1f6b 00
    nop                 ;1f6c 00
    nop                 ;1f6d 00
    nop                 ;1f6e 00
    nop                 ;1f6f 00
    nop                 ;1f70 00
    nop                 ;1f71 00
    nop                 ;1f72 00
    nop                 ;1f73 00
    nop                 ;1f74 00
    nop                 ;1f75 00
    nop                 ;1f76 00
    nop                 ;1f77 00
    nop                 ;1f78 00
    nop                 ;1f79 00
    nop                 ;1f7a 00
    nop                 ;1f7b 00
    nop                 ;1f7c 00
    nop                 ;1f7d 00
    nop                 ;1f7e 00
    nop                 ;1f7f 00
    nop                 ;1f80 00
    nop                 ;1f81 00
    nop                 ;1f82 00
    nop                 ;1f83 00
    nop                 ;1f84 00
    nop                 ;1f85 00
    nop                 ;1f86 00
    nop                 ;1f87 00
    nop                 ;1f88 00
    nop                 ;1f89 00
    nop                 ;1f8a 00
    nop                 ;1f8b 00
    nop                 ;1f8c 00
    nop                 ;1f8d 00
    nop                 ;1f8e 00
    nop                 ;1f8f 00
    nop                 ;1f90 00
    nop                 ;1f91 00
    nop                 ;1f92 00
    nop                 ;1f93 00
    nop                 ;1f94 00
    nop                 ;1f95 00
    nop                 ;1f96 00
    nop                 ;1f97 00
    nop                 ;1f98 00
    nop                 ;1f99 00
    nop                 ;1f9a 00
    nop                 ;1f9b 00
    nop                 ;1f9c 00
    nop                 ;1f9d 00
    nop                 ;1f9e 00
    nop                 ;1f9f 00
    nop                 ;1fa0 00
    nop                 ;1fa1 00
    nop                 ;1fa2 00
    nop                 ;1fa3 00
    nop                 ;1fa4 00
    nop                 ;1fa5 00
    nop                 ;1fa6 00
    nop                 ;1fa7 00
    nop                 ;1fa8 00
    nop                 ;1fa9 00
    nop                 ;1faa 00
    nop                 ;1fab 00
    nop                 ;1fac 00
    nop                 ;1fad 00
    nop                 ;1fae 00
    nop                 ;1faf 00
    nop                 ;1fb0 00
    nop                 ;1fb1 00
    nop                 ;1fb2 00
    nop                 ;1fb3 00
    nop                 ;1fb4 00
    nop                 ;1fb5 00
    nop                 ;1fb6 00
    nop                 ;1fb7 00
    nop                 ;1fb8 00
    nop                 ;1fb9 00
    nop                 ;1fba 00
    nop                 ;1fbb 00
    nop                 ;1fbc 00
    nop                 ;1fbd 00
    nop                 ;1fbe 00
    nop                 ;1fbf 00
    nop                 ;1fc0 00
    nop                 ;1fc1 00
    nop                 ;1fc2 00
    nop                 ;1fc3 00
    nop                 ;1fc4 00
    nop                 ;1fc5 00
    nop                 ;1fc6 00
    nop                 ;1fc7 00
    nop                 ;1fc8 00
    nop                 ;1fc9 00
    nop                 ;1fca 00
    nop                 ;1fcb 00
    nop                 ;1fcc 00
    nop                 ;1fcd 00
    nop                 ;1fce 00
    nop                 ;1fcf 00
    nop                 ;1fd0 00
    nop                 ;1fd1 00
    nop                 ;1fd2 00
    nop                 ;1fd3 00
    nop                 ;1fd4 00
    nop                 ;1fd5 00
    nop                 ;1fd6 00
    nop                 ;1fd7 00
    nop                 ;1fd8 00
    nop                 ;1fd9 00
    nop                 ;1fda 00
    nop                 ;1fdb 00
    nop                 ;1fdc 00
    nop                 ;1fdd 00
    nop                 ;1fde 00
    nop                 ;1fdf 00
    nop                 ;1fe0 00
    nop                 ;1fe1 00
    nop                 ;1fe2 00
    nop                 ;1fe3 00
    nop                 ;1fe4 00
    nop                 ;1fe5 00
    nop                 ;1fe6 00
    nop                 ;1fe7 00
    nop                 ;1fe8 00
    nop                 ;1fe9 00
    nop                 ;1fea 00
    nop                 ;1feb 00
    nop                 ;1fec 00
    nop                 ;1fed 00
    nop                 ;1fee 00
    nop                 ;1fef 00
    nop                 ;1ff0 00
    nop                 ;1ff1 00
    nop                 ;1ff2 00
    nop                 ;1ff3 00
    nop                 ;1ff4 00
    nop                 ;1ff5 00
    nop                 ;1ff6 00
    nop                 ;1ff7 00
    nop                 ;1ff8 00
    nop                 ;1ff9 00
    nop                 ;1ffa 00
    nop                 ;1ffb 00
    nop                 ;1ffc 00
    nop                 ;1ffd 00
    nop                 ;1ffe 00
    nop                 ;1fff 00
l2000h:
    nop                 ;2000 00
    nop                 ;2001 00
l2002h:
    nop                 ;2002 00
    nop                 ;2003 00
l2004h:
    nop                 ;2004 00
l2005h:
    nop                 ;2005 00
    nop                 ;2006 00
l2007h:
    nop                 ;2007 00
l2008h:
    nop                 ;2008 00
l2009h:
    nop                 ;2009 00
l200ah:
    nop                 ;200a 00
l200bh:
    nop                 ;200b 00
l200ch:
    nop                 ;200c 00
l200dh:
    nop                 ;200d 00
    nop                 ;200e 00
l200fh:
    nop                 ;200f 00
l2010h:
    nop                 ;2010 00
l2011h:
    nop                 ;2011 00
l2012h:
    nop                 ;2012 00
l2013h:
    nop                 ;2013 00
    nop                 ;2014 00
    nop                 ;2015 00
    nop                 ;2016 00
    nop                 ;2017 00
    nop                 ;2018 00
    nop                 ;2019 00
    nop                 ;201a 00
    nop                 ;201b 00
    nop                 ;201c 00
    nop                 ;201d 00
    nop                 ;201e 00
    nop                 ;201f 00
    nop                 ;2020 00
    nop                 ;2021 00
    nop                 ;2022 00
    nop                 ;2023 00
l2024h:
    nop                 ;2024 00
    nop                 ;2025 00
l2026h:
    nop                 ;2026 00
l2027h:
    nop                 ;2027 00
    nop                 ;2028 00
l2029h:
    nop                 ;2029 00
l202ah:
    nop                 ;202a 00
    nop                 ;202b 00
l202ch:
    nop                 ;202c 00
    nop                 ;202d 00
l202eh:
    nop                 ;202e 00
l202fh:
    nop                 ;202f 00
l2030h:
    nop                 ;2030 00
l2031h:
    nop                 ;2031 00
    nop                 ;2032 00
l2033h:
    nop                 ;2033 00
l2034h:
    nop                 ;2034 00
    nop                 ;2035 00
l2036h:
    nop                 ;2036 00
    nop                 ;2037 00
l2038h:
    nop                 ;2038 00
l2039h:
    nop                 ;2039 00
    nop                 ;203a 00
l203bh:
    nop                 ;203b 00
    nop                 ;203c 00
l203dh:
    nop                 ;203d 00
l203eh:
    nop                 ;203e 00
    nop                 ;203f 00
    nop                 ;2040 00
    nop                 ;2041 00
    nop                 ;2042 00
    nop                 ;2043 00
    nop                 ;2044 00
    nop                 ;2045 00
    nop                 ;2046 00
    nop                 ;2047 00
    nop                 ;2048 00
    nop                 ;2049 00
    nop                 ;204a 00
    nop                 ;204b 00
    nop                 ;204c 00
    nop                 ;204d 00
l204eh:
    nop                 ;204e 00
l204fh:
    nop                 ;204f 00
l2050h:
    nop                 ;2050 00
l2051h:
    nop                 ;2051 00
l2052h:
    nop                 ;2052 00
l2053h:
    nop                 ;2053 00
l2054h:
    nop                 ;2054 00
l2055h:
    nop                 ;2055 00
l2056h:
    nop                 ;2056 00
l2057h:
    nop                 ;2057 00
    nop                 ;2058 00
    nop                 ;2059 00
    nop                 ;205a 00
    nop                 ;205b 00
    nop                 ;205c 00
    nop                 ;205d 00
    nop                 ;205e 00
    nop                 ;205f 00
    nop                 ;2060 00
    nop                 ;2061 00
    nop                 ;2062 00
    nop                 ;2063 00
    nop                 ;2064 00
    nop                 ;2065 00
    nop                 ;2066 00
    nop                 ;2067 00
    nop                 ;2068 00
    nop                 ;2069 00
    nop                 ;206a 00
    nop                 ;206b 00
    nop                 ;206c 00
    nop                 ;206d 00
    nop                 ;206e 00
    nop                 ;206f 00
    nop                 ;2070 00
    nop                 ;2071 00
    nop                 ;2072 00
    nop                 ;2073 00
    nop                 ;2074 00
    nop                 ;2075 00
    nop                 ;2076 00
    nop                 ;2077 00
    nop                 ;2078 00
    nop                 ;2079 00
    nop                 ;207a 00
    nop                 ;207b 00
    nop                 ;207c 00
    nop                 ;207d 00
    nop                 ;207e 00
    nop                 ;207f 00
    nop                 ;2080 00
    nop                 ;2081 00
    nop                 ;2082 00
    nop                 ;2083 00
    nop                 ;2084 00
    nop                 ;2085 00
    nop                 ;2086 00
    nop                 ;2087 00
    nop                 ;2088 00
    nop                 ;2089 00
    nop                 ;208a 00
    nop                 ;208b 00
    nop                 ;208c 00
    nop                 ;208d 00
    nop                 ;208e 00
    nop                 ;208f 00
    nop                 ;2090 00
    nop                 ;2091 00
    nop                 ;2092 00
    nop                 ;2093 00
    nop                 ;2094 00
    nop                 ;2095 00
    nop                 ;2096 00
    nop                 ;2097 00
    nop                 ;2098 00
    nop                 ;2099 00
    nop                 ;209a 00
    nop                 ;209b 00
    nop                 ;209c 00
    nop                 ;209d 00
    nop                 ;209e 00
    nop                 ;209f 00
    nop                 ;20a0 00
    nop                 ;20a1 00
    nop                 ;20a2 00
    nop                 ;20a3 00
    nop                 ;20a4 00
    nop                 ;20a5 00
    nop                 ;20a6 00
    nop                 ;20a7 00
    nop                 ;20a8 00
    nop                 ;20a9 00
    nop                 ;20aa 00
    nop                 ;20ab 00
    nop                 ;20ac 00
    nop                 ;20ad 00
    nop                 ;20ae 00
    nop                 ;20af 00
    nop                 ;20b0 00
    nop                 ;20b1 00
    nop                 ;20b2 00
    nop                 ;20b3 00
    nop                 ;20b4 00
    nop                 ;20b5 00
    nop                 ;20b6 00
    nop                 ;20b7 00
    nop                 ;20b8 00
    nop                 ;20b9 00
    nop                 ;20ba 00
    nop                 ;20bb 00
    nop                 ;20bc 00
    nop                 ;20bd 00
    nop                 ;20be 00
    nop                 ;20bf 00
    nop                 ;20c0 00
    nop                 ;20c1 00
    nop                 ;20c2 00
    nop                 ;20c3 00
    nop                 ;20c4 00
    nop                 ;20c5 00
    nop                 ;20c6 00
    nop                 ;20c7 00
    nop                 ;20c8 00
    nop                 ;20c9 00
    nop                 ;20ca 00
    nop                 ;20cb 00
    nop                 ;20cc 00
    nop                 ;20cd 00
    nop                 ;20ce 00
    nop                 ;20cf 00
    nop                 ;20d0 00
    nop                 ;20d1 00
    nop                 ;20d2 00
    nop                 ;20d3 00
    nop                 ;20d4 00
    nop                 ;20d5 00
    nop                 ;20d6 00
    nop                 ;20d7 00
    nop                 ;20d8 00
    nop                 ;20d9 00
    nop                 ;20da 00
    nop                 ;20db 00
    nop                 ;20dc 00
    nop                 ;20dd 00
    nop                 ;20de 00
    nop                 ;20df 00
    nop                 ;20e0 00
    nop                 ;20e1 00
    nop                 ;20e2 00
    nop                 ;20e3 00
    nop                 ;20e4 00
    nop                 ;20e5 00
    nop                 ;20e6 00
    nop                 ;20e7 00
    nop                 ;20e8 00
    nop                 ;20e9 00
    nop                 ;20ea 00
    nop                 ;20eb 00
    nop                 ;20ec 00
    nop                 ;20ed 00
    nop                 ;20ee 00
    nop                 ;20ef 00
    nop                 ;20f0 00
    nop                 ;20f1 00
    nop                 ;20f2 00
    nop                 ;20f3 00
    nop                 ;20f4 00
    nop                 ;20f5 00
    nop                 ;20f6 00
    nop                 ;20f7 00
    nop                 ;20f8 00
    nop                 ;20f9 00
    nop                 ;20fa 00
    nop                 ;20fb 00
    nop                 ;20fc 00
    nop                 ;20fd 00
    nop                 ;20fe 00
    nop                 ;20ff 00
    nop                 ;2100 00
    nop                 ;2101 00
    nop                 ;2102 00
    nop                 ;2103 00
    nop                 ;2104 00
    nop                 ;2105 00
    nop                 ;2106 00
    nop                 ;2107 00
    nop                 ;2108 00
    nop                 ;2109 00
    nop                 ;210a 00
    nop                 ;210b 00
    nop                 ;210c 00
    nop                 ;210d 00
    nop                 ;210e 00
    nop                 ;210f 00
    nop                 ;2110 00
    nop                 ;2111 00
    nop                 ;2112 00
    nop                 ;2113 00
    nop                 ;2114 00
    nop                 ;2115 00
    nop                 ;2116 00
    nop                 ;2117 00
    nop                 ;2118 00
    nop                 ;2119 00
    nop                 ;211a 00
    nop                 ;211b 00
    nop                 ;211c 00
    nop                 ;211d 00
    nop                 ;211e 00
    nop                 ;211f 00
    nop                 ;2120 00
    nop                 ;2121 00
    nop                 ;2122 00
    nop                 ;2123 00
    nop                 ;2124 00
    nop                 ;2125 00
    nop                 ;2126 00
    nop                 ;2127 00
    nop                 ;2128 00
    nop                 ;2129 00
    nop                 ;212a 00
    nop                 ;212b 00
    nop                 ;212c 00
    nop                 ;212d 00
    nop                 ;212e 00
    nop                 ;212f 00
    nop                 ;2130 00
    nop                 ;2131 00
    nop                 ;2132 00
    nop                 ;2133 00
    nop                 ;2134 00
    nop                 ;2135 00
    nop                 ;2136 00
    nop                 ;2137 00
    nop                 ;2138 00
    nop                 ;2139 00
    nop                 ;213a 00
    nop                 ;213b 00
    nop                 ;213c 00
    nop                 ;213d 00
    nop                 ;213e 00
    nop                 ;213f 00
    nop                 ;2140 00
    nop                 ;2141 00
    nop                 ;2142 00
    nop                 ;2143 00
    nop                 ;2144 00
    nop                 ;2145 00
    nop                 ;2146 00
    nop                 ;2147 00
    nop                 ;2148 00
    nop                 ;2149 00
    nop                 ;214a 00
    nop                 ;214b 00
    nop                 ;214c 00
    nop                 ;214d 00
    nop                 ;214e 00
    nop                 ;214f 00
    nop                 ;2150 00
    nop                 ;2151 00
    nop                 ;2152 00
    nop                 ;2153 00
    nop                 ;2154 00
    nop                 ;2155 00
    nop                 ;2156 00
    nop                 ;2157 00
    nop                 ;2158 00
    nop                 ;2159 00
    nop                 ;215a 00
    nop                 ;215b 00
    nop                 ;215c 00
    nop                 ;215d 00
    nop                 ;215e 00
    nop                 ;215f 00
    nop                 ;2160 00
    nop                 ;2161 00
    nop                 ;2162 00
    nop                 ;2163 00
    nop                 ;2164 00
    nop                 ;2165 00
    nop                 ;2166 00
    nop                 ;2167 00
    nop                 ;2168 00
    nop                 ;2169 00
    nop                 ;216a 00
    nop                 ;216b 00
    nop                 ;216c 00
    nop                 ;216d 00
    nop                 ;216e 00
    nop                 ;216f 00
    nop                 ;2170 00
    nop                 ;2171 00
    nop                 ;2172 00
    nop                 ;2173 00
    nop                 ;2174 00
    nop                 ;2175 00
    nop                 ;2176 00
    nop                 ;2177 00
    nop                 ;2178 00
    nop                 ;2179 00
    nop                 ;217a 00
    nop                 ;217b 00
    nop                 ;217c 00
    nop                 ;217d 00
    nop                 ;217e 00
    nop                 ;217f 00
    nop                 ;2180 00
    nop                 ;2181 00
    nop                 ;2182 00
    nop                 ;2183 00
    nop                 ;2184 00
    nop                 ;2185 00
    nop                 ;2186 00
    nop                 ;2187 00
    nop                 ;2188 00
    nop                 ;2189 00
    nop                 ;218a 00
    nop                 ;218b 00
    nop                 ;218c 00
    nop                 ;218d 00
    nop                 ;218e 00
    nop                 ;218f 00
    nop                 ;2190 00
    nop                 ;2191 00
    nop                 ;2192 00
    nop                 ;2193 00
    nop                 ;2194 00
    nop                 ;2195 00
    nop                 ;2196 00
    nop                 ;2197 00
    nop                 ;2198 00
    nop                 ;2199 00
    nop                 ;219a 00
    nop                 ;219b 00
    nop                 ;219c 00
    nop                 ;219d 00
    nop                 ;219e 00
    nop                 ;219f 00
    nop                 ;21a0 00
    nop                 ;21a1 00
    nop                 ;21a2 00
    nop                 ;21a3 00
    nop                 ;21a4 00
    nop                 ;21a5 00
    nop                 ;21a6 00
    nop                 ;21a7 00
    nop                 ;21a8 00
    nop                 ;21a9 00
    nop                 ;21aa 00
    nop                 ;21ab 00
    nop                 ;21ac 00
    nop                 ;21ad 00
    nop                 ;21ae 00
    nop                 ;21af 00
    nop                 ;21b0 00
    nop                 ;21b1 00
    nop                 ;21b2 00
    nop                 ;21b3 00
    nop                 ;21b4 00
    nop                 ;21b5 00
    nop                 ;21b6 00
    nop                 ;21b7 00
    nop                 ;21b8 00
    nop                 ;21b9 00
    nop                 ;21ba 00
    nop                 ;21bb 00
    nop                 ;21bc 00
    nop                 ;21bd 00
    nop                 ;21be 00
    nop                 ;21bf 00
    nop                 ;21c0 00
    nop                 ;21c1 00
    nop                 ;21c2 00
    nop                 ;21c3 00
    nop                 ;21c4 00
    nop                 ;21c5 00
    nop                 ;21c6 00
    nop                 ;21c7 00
    nop                 ;21c8 00
    nop                 ;21c9 00
    nop                 ;21ca 00
    nop                 ;21cb 00
    nop                 ;21cc 00
    nop                 ;21cd 00
    nop                 ;21ce 00
    nop                 ;21cf 00
    nop                 ;21d0 00
    nop                 ;21d1 00
    nop                 ;21d2 00
    nop                 ;21d3 00
    nop                 ;21d4 00
    nop                 ;21d5 00
    nop                 ;21d6 00
    nop                 ;21d7 00
    nop                 ;21d8 00
    nop                 ;21d9 00
    nop                 ;21da 00
    nop                 ;21db 00
    nop                 ;21dc 00
    nop                 ;21dd 00
    nop                 ;21de 00
    nop                 ;21df 00
    nop                 ;21e0 00
    nop                 ;21e1 00
    nop                 ;21e2 00
    nop                 ;21e3 00
    nop                 ;21e4 00
    nop                 ;21e5 00
    nop                 ;21e6 00
    nop                 ;21e7 00
    nop                 ;21e8 00
    nop                 ;21e9 00
    nop                 ;21ea 00
    nop                 ;21eb 00
    nop                 ;21ec 00
    nop                 ;21ed 00
    nop                 ;21ee 00
    nop                 ;21ef 00
    nop                 ;21f0 00
    nop                 ;21f1 00
    nop                 ;21f2 00
    nop                 ;21f3 00
    nop                 ;21f4 00
    nop                 ;21f5 00
    nop                 ;21f6 00
    nop                 ;21f7 00
    nop                 ;21f8 00
    nop                 ;21f9 00
    nop                 ;21fa 00
    nop                 ;21fb 00
    nop                 ;21fc 00
    nop                 ;21fd 00
    nop                 ;21fe 00
    nop                 ;21ff 00
