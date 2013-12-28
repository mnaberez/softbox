;This is a disassembly of the HardBox code payload inside mwdos291.com.

ppi1:     equ 10h       ;8255 PPI #1 (IC17)
ppi1_pa:  equ ppi1+0    ;  Port A: IEEE-488 Data In
ppi1_pb:  equ ppi1+1    ;  Port B: IEEE-488 Data Out
ppi1_pc:  equ ppi1+2    ;  Port C: DIP Switches
ppi1_cr:  equ ppi1+3    ;  Control Register

ppi2:     equ 14h       ;8255 PPI #2 (IC16)
ppi2_pa:  equ ppi2+0    ;  Port A:
                        ;    PA7 IEEE-488 IFC in (unused)
                        ;    PA6 IEEE-488 REN in (unused)
                        ;    PA5 IEEE-488 SRQ in (unused)
                        ;    PA4 IEEE-488 EOI in
                        ;    PA3 IEEE-488 NRFD in
                        ;    PA2 IEEE-488 NDAC in
                        ;    PA1 IEEE-488 DAV in
                        ;    PA0 IEEE-488 ATN in
ppi2_pb:  equ ppi2+1    ;  Port B:
                        ;    PB7 IEEE-488 ATNA out (because LK3 is open)
                        ;    PB6 IEEE-488 REN out (unused)
                        ;    PB5 IEEE-488 SRQ out (unused)
                        ;    PB4 IEEE-488 EOI out
                        ;    PB3 IEEE-488 NRFD out
                        ;    PB2 IEEE-488 NDAC out
                        ;    PB1 IEEE-488 DAV out
                        ;    PB0 IEEE-488 ATN out (unused)
ppi2_pc:  equ ppi2+2    ;  Port C:
                        ;    PC7 Unused
                        ;    PC6 Unused
                        ;    PC5 Corvus DIRC
                        ;    PC4 Corvus READY
                        ;    PC3 Unused
                        ;    PC2 LED "Ready"
                        ;    PC1 LED "B"
                        ;    PC0 LED "A"
ppi2_cr:  equ ppi2+3    ;  Control Register

corvus:   equ 18h       ;Corvus data bus

atna:     equ 10000000b ;ATNA (With installed IC37 this isn't IFC, leave LK3 open!)
ren:      equ 01000000b ;REN (unused)
srq:      equ 00100000b ;SRQ (unused)
eoi:      equ 00010000b ;EOI
nrfd:     equ 00001000b ;NRFD
ndac:     equ 00000100b ;NDAC
dav:      equ 00000010b ;DAV
atn:      equ 00000001b ;ATN

    org 0100h

    jp reset            ;0100 c3 00 02
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

    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db "HARD DISK       ",07h,60h,00h
    db 08h              ;IEEE-488 primary address
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0

reset:
    xor a               ;0200 af
    out (ppi1_pb),a     ;0201 d3 11
    ld a,80h            ;0203 3e 80
    out (ppi2_pb),a     ;0205 d3 15
    ld a,(0136h)        ;0207 3a 36 01
    ld (2000h),a        ;020a 32 00 20

init_user:
    ld sp,4a93h

                        ;Clear memory from 2004h .. 4a13h
    ld hl,2004h         ;HL=2004h
    ld de,2005h         ;DE=2005h
    ld bc,2a0eh         ;BC=2a0eh
    ld (hl),00h
    ldir                ;Copy BC bytes from (HL) to (DE)

    xor a               ;021d af
    ld (2002h),a        ;021e 32 02 20

    ld a,01h            ;0221 3e 01
    ld (460ch),a        ;0223 32 0c 46

    ld hl,2bf5h         ;0226 21 f5 2b
    ld (2af3h),hl       ;0229 22 f3 2a
    ld hl,l0103h        ;022c 21 03 01
    ld de,2004h         ;022f 11 04 20
    ld bc,0020h         ;0232 01 20 00
    ldir                ;0235 ed b0
    ld hl,0123h         ;0237 21 23 01
    ld de,203eh         ;023a 11 3e 20
    ld bc,0010h         ;023d 01 10 00
    ldir                ;0240 ed b0
    call error_ok       ;0242 cd d8 05
    call sub_192dh      ;0245 cd 2d 19
    ld hl,(200bh)       ;0248 2a 0b 20
    ld (202ah),hl       ;024b 22 2a 20
    ld a,(2009h)        ;024e 3a 09 20
    ld e,a              ;0251 5f
    ld d,00h            ;0252 16 00
    add hl,de           ;0254 19
    ld (202fh),hl       ;0255 22 2f 20
    ld hl,(200dh)       ;0258 2a 0d 20
    ld a,h              ;025b 7c
    ld b,09h            ;025c 06 09
    call hl_shr_b       ;025e cd 7a 1a
    inc hl              ;0261 23
    ld (2039h),hl       ;0262 22 39 20
    ld hl,(200bh)       ;0265 2a 0b 20
    ld b,05h            ;0268 06 05
    call hl_shr_b       ;026a cd 7a 1a
    inc hl              ;026d 23
    ex de,hl            ;026e eb
    ld hl,(202ah)       ;026f 2a 2a 20
    ld b,03h            ;0272 06 03
    call hl_shr_b       ;0274 cd 7a 1a
    inc hl              ;0277 23
    add hl,de           ;0278 19
    ex de,hl            ;0279 eb
    ld hl,(202fh)       ;027a 2a 2f 20
    ld b,02h            ;027d 06 02
    call hl_shr_b       ;027f cd 7a 1a
    inc hl              ;0282 23
    add hl,de           ;0283 19
    ld de,(200dh)       ;0284 ed 5b 0d 20
    add hl,de           ;0288 19
    ld de,(2039h)       ;0289 ed 5b 39 20
    add hl,de           ;028d 19
    ex de,hl            ;028e eb
    ld hl,(2008h)       ;028f 2a 08 20
    scf                 ;0292 37
    sbc hl,de           ;0293 ed 52
    srl h               ;0295 cb 3c
    rr l                ;0297 cb 1d
    ld (2034h),hl       ;0299 22 34 20
    ld hl,(2005h)       ;029c 2a 05 20
    ld a,(2007h)        ;029f 3a 07 20
    ld de,0004h         ;02a2 11 04 00
    add hl,de           ;02a5 19
    adc a,00h           ;02a6 ce 00
    ld (2024h),hl       ;02a8 22 24 20
    ld (2026h),a        ;02ab 32 26 20
    ex de,hl            ;02ae eb
    ld hl,(200bh)       ;02af 2a 0b 20
    ld b,03h            ;02b2 06 03
    call hl_shr_b       ;02b4 cd 7a 1a
    inc hl              ;02b7 23
    add hl,de           ;02b8 19
    adc a,00h           ;02b9 ce 00
    ld (2027h),hl       ;02bb 22 27 20
    ld (2029h),a        ;02be 32 29 20
    ld de,(202ah)       ;02c1 ed 5b 2a 20
    srl d               ;02c5 cb 3a
    rr e                ;02c7 cb 1b
    inc de              ;02c9 13
    add hl,de           ;02ca 19
    adc a,00h           ;02cb ce 00
    ld (202ch),hl       ;02cd 22 2c 20
    ld (202eh),a        ;02d0 32 2e 20
    ld de,(202fh)       ;02d3 ed 5b 2f 20
    add hl,de           ;02d7 19
    adc a,00h           ;02d8 ce 00
    ld (2031h),hl       ;02da 22 31 20
    ld (2033h),a        ;02dd 32 33 20
    ld de,(2034h)       ;02e0 ed 5b 34 20
    ld b,08h            ;02e4 06 08
l02e6h:
    add hl,de           ;02e6 19
    adc a,00h           ;02e7 ce 00
    djnz l02e6h         ;02e9 10 fb
    ld (203bh),hl       ;02eb 22 3b 20
    ld (203dh),a        ;02ee 32 3d 20
    ex de,hl            ;02f1 eb
    ld hl,(2039h)       ;02f2 2a 39 20
    add hl,hl           ;02f5 29
    add hl,hl           ;02f6 29
    add hl,de           ;02f7 19
    adc a,00h           ;02f8 ce 00
    ld (2036h),hl       ;02fa 22 36 20
    ld (2038h),a        ;02fd 32 38 20
    ld a,0fh            ;0300 3e 0f
    ld (2ae7h),a        ;0302 32 e7 2a
    call sub_1689h      ;0305 cd 89 16
    ld hl,0000h         ;0308 21 00 00
    ld (2d68h),hl       ;030b 22 68 2d
l030eh:
    call dir_get_next   ;030e cd a6 15
    jr c,l0336h         ;0311 38 23
    bit 7,(ix+01h)      ;0313 dd cb 01 7e
    jr nz,l030eh        ;0317 20 f5
    call loc1_read_sec  ;0319 cd be 18
    ld b,40h            ;031c 06 40
    ld ix,(2aeeh)       ;031e dd 2a ee 2a
l0322h:
    ld l,(ix+00h)       ;0322 dd 6e 00
    ld h,(ix+01h)       ;0325 dd 66 01
    ld de,2057h         ;0328 11 57 20
    call sub_1733h      ;032b cd 33 17
    inc ix              ;032e dd 23
    inc ix              ;0330 dd 23
    djnz l0322h         ;0332 10 ee
    jr l030eh           ;0334 18 d8
l0336h:
    ld de,0000h         ;0336 11 00 00
    ld hl,2057h         ;0339 21 57 20
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
    call loc2_writ_sec  ;0347 cd b5 17
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
    ld a,(202fh)        ;0366 3a 2f 20
    cp e                ;0369 bb
    jr nz,l0372h        ;036a 20 06
    ld a,(2030h)        ;036c 3a 30 20
    cp d                ;036f ba
    jr z,l0376h         ;0370 28 04
l0372h:
    djnz l0340h         ;0372 10 cc
    jr l033ch           ;0374 18 c6
l0376h:
    xor a               ;0376 af
    out (ppi2_pc),a     ;0377 d3 16
    out (ppi1_pb),a     ;0379 d3 11
    in a,(ppi2_pb)      ;037b db 15
    and 00h             ;037d e6 00
    out (ppi2_pb),a     ;037f d3 15
l0381h:
    in a,(ppi2_pa)      ;0381 db 14
    and 01h             ;0383 e6 01
    jr z,l0381h         ;0385 28 fa
l0387h:
    in a,(ppi2_pb)      ;0387 db 15
    or 84h              ;0389 f6 84
    out (ppi2_pb),a     ;038b d3 15
    in a,(ppi2_pb)      ;038d db 15
    and 0f7h            ;038f e6 f7
    out (ppi2_pb),a     ;0391 d3 15
l0393h:
    in a,(ppi2_pa)      ;0393 db 14
    and 02h             ;0395 e6 02
    jr nz,l03a2h        ;0397 20 09
    in a,(ppi2_pa)      ;0399 db 14
    and 01h             ;039b e6 01
    jr nz,l0393h        ;039d 20 f4
    jp do_write         ;039f c3 15 04

l03a2h:
;After detection an ATN=low, now is DAV=low.  So we must read the
;primary address (TALK or LISTEN).
;
    ld hl,2af0h

    in a,(ppi2_pb)
    or nrfd
    out (ppi2_pb),a     ;NRFD_OUT=low

    in a,(ppi1_pa)
    ld c,a

    in a,(ppi2_pb)
    and 255-ndac
    out (ppi2_pb),a     ;NDAC_OUT=high

    ld a,(2000h)        ;Generate LISTEN address
    or 20h
    cp c
    jr z,do_listn       ;If found LISTEN execute do_listn

    xor 60h             ;Generate TALK address
    cp c
    jr z,do_talk        ;If found TALK execute do_talk

    ld a,c
    cp 3fh              ;3Fh=UNLISTEN
    jr z,do_unlst       ;If found UNLISTEN execute do_unlst

    cp 5fh              ;5Fh=UNTALK
    jr z,do_untlk       ;If found UNTALK execute do_untlk

    and 60h
    cp 60h              ;Is the byte a SA, OPEN or CLOSE?
    jr nz,l03dah        ;  NO: finish this data cyclus and skip data

    ld a,c              ;We store the channel number as SA
    ld (2ae7h),a        ;(sa)=C

    and 0f0h
    cp 0e0h             ;Is this byte a CLOSE?
    jr z,sa_close       ;  YES: process a close

l03dah:
    in a,(ppi2_pa)
    and dav
    jr nz,l03dah        ;Wait until DAV_IN=high

    jr l0387h

do_listn:
    set 2,(hl)          ;Set marker for LISTEN is active
    xor a               ;A=0
    ld (2ae7h),a
    jr l03dah

do_talk:
    set 1,(hl)          ;Set marker for TALK is active
    xor a               ;A=0
    ld (2ae7h),a
    jr l03dah

do_unlst:
    res 2,(hl)          ;Clear marker for LISTEN is active
    jr l03dah

do_untlk:
    res 1,(hl)          ;Clear marker for TALK is active
    jr l03dah

sa_close:
    ld (hl),00h         ;Clear all marker for LISTEN and TALK active
    ld a,c
    and 0fh
    ld (2ae7h),a
    push af
    cp 02h
    call nc,error_ok
    pop af
    cp 0fh              ;Is Control Channel?
    push af
    call z,sub_0932h
    pop af
    call nz,sub_08e7h
    jr l03dah

do_write:
    in a,(ppi2_pb)      ;0415 db 15
    and 7fh             ;0417 e6 7f
    out (ppi2_pb),a     ;0419 d3 15
    ld a,(2af0h)        ;041b 3a f0 2a
sub_041eh:
    or a                ;041e b7
    jp z,l0376h         ;041f ca 76 03
    bit 2,a             ;0422 cb 57
    jr nz,do_read       ;0424 20 2f
    in a,(ppi2_pb)      ;0426 db 15
    and 0fbh            ;0428 e6 fb
    out (ppi2_pb),a     ;042a d3 15
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
do_read:
    ld a,(2ae7h)        ;0455 3a e7 2a
    or a                ;0458 b7
    jp z,l0376h         ;0459 ca 76 03
    push af             ;045c f5
    and 0fh             ;045d e6 0f
    ld (2ae7h),a        ;045f 32 e7 2a
    cp 02h              ;0462 fe 02
    call nc,error_ok    ;0464 d4 d8 05
    pop af              ;0467 f1
    jp p,l049bh         ;0468 f2 9b 04
    ld hl,2c75h         ;046b 21 75 2c
    ld b,7fh            ;046e 06 7f
l0470h:
    call rdieee         ;0470 cd c1 04
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
    jp nz,do_open       ;048a c2 bb 06
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
    call rdieee         ;04a6 cd c1 04
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
rdieee:
    in a,(ppi2_pa)      ;04c1 db 14
    and 01h             ;04c3 e6 01
    jr nz,l0506h        ;04c5 20 3f
    in a,(ppi2_pb)      ;04c7 db 15
    and 0f7h            ;04c9 e6 f7
    out (ppi2_pb),a     ;04cb d3 15
l04cdh:
    in a,(ppi2_pa)      ;04cd db 14
    and 01h             ;04cf e6 01
    jr nz,l0506h        ;04d1 20 33
    in a,(ppi2_pa)      ;04d3 db 14
    and 02h             ;04d5 e6 02
    jr z,l04cdh         ;04d7 28 f4
    in a,(ppi1_pa)      ;04d9 db 10
    push af             ;04db f5
    xor a               ;04dc af
    ld (456fh),a        ;04dd 32 6f 45
    in a,(ppi2_pa)      ;04e0 db 14
    and 10h             ;04e2 e6 10
    jr z,l04ebh         ;04e4 28 05
    ld a,01h            ;04e6 3e 01
    ld (456fh),a        ;04e8 32 6f 45
l04ebh:
    in a,(ppi2_pb)      ;04eb db 15
    or 08h              ;04ed f6 08
    out (ppi2_pb),a     ;04ef d3 15
    in a,(ppi2_pb)      ;04f1 db 15
    and 0fbh            ;04f3 e6 fb
    out (ppi2_pb),a     ;04f5 d3 15
l04f7h:
    in a,(ppi2_pa)      ;04f7 db 14
    and 02h             ;04f9 e6 02
    jr nz,l04f7h        ;04fb 20 fa
    in a,(ppi2_pb)      ;04fd db 15
    or 04h              ;04ff f6 04
    out (ppi2_pb),a     ;0501 d3 15
    pop af              ;0503 f1
    or a                ;0504 b7
    ret                 ;0505 c9
l0506h:
    scf                 ;0506 37
    ret                 ;0507 c9
wreoi:
    push af             ;0508 f5
    in a,(ppi2_pb)      ;0509 db 15
    or 10h              ;050b f6 10
    out (ppi2_pb),a     ;050d d3 15
    pop af              ;050f f1
sub_0510h:
    call wrieee         ;0510 cd 19 05
    ret c               ;0513 d8
    call sub_055ah      ;0514 cd 5a 05
    or a                ;0517 b7
    ret                 ;0518 c9
wrieee:
    push af             ;0519 f5
l051ah:
    in a,(ppi2_pa)      ;051a db 14
    and 01h             ;051c e6 01
    jr nz,l0557h        ;051e 20 37
    in a,(ppi2_pa)      ;0520 db 14
    and 08h             ;0522 e6 08
    jr nz,l051ah        ;0524 20 f4
    in a,(ppi2_pa)      ;0526 db 14
    and 01h             ;0528 e6 01
    jr nz,l0557h        ;052a 20 2b
    in a,(ppi2_pa)      ;052c db 14
    and 04h             ;052e e6 04
    jr z,l0557h         ;0530 28 25
    pop af              ;0532 f1
    out (ppi1_pb),a     ;0533 d3 11
    in a,(ppi2_pb)      ;0535 db 15
    or 02h              ;0537 f6 02
    out (ppi2_pb),a     ;0539 d3 15
l053bh:
    in a,(ppi2_pa)      ;053b db 14
    and 08h             ;053d e6 08
    jr nz,l0555h        ;053f 20 14
    in a,(ppi2_pa)      ;0541 db 14
    and 04h             ;0543 e6 04
    jr nz,l053bh        ;0545 20 f4
    in a,(ppi2_pa)      ;0547 db 14
    and 08h             ;0549 e6 08
    jr nz,l0555h        ;054b 20 08
    in a,(ppi2_pb)      ;054d db 15
    and 0fdh            ;054f e6 fd
    out (ppi2_pb),a     ;0551 d3 15
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
    in a,(ppi2_pa)      ;055a db 14
    and 04h             ;055c e6 04
    jr nz,sub_055ah     ;055e 20 fa
    in a,(ppi2_pb)      ;0560 db 15
    and 0edh            ;0562 e6 ed
    out (ppi2_pb),a     ;0564 d3 15
    xor a               ;0566 af
    out (ppi1_pb),a     ;0567 d3 11
    ret                 ;0569 c9
l056ah:
    call error_ok       ;056a cd d8 05
    ld de,cmd_char      ;056d 11 99 05
    ld hl,2bf5h         ;0570 21 f5 2b
    ld (2af3h),hl       ;0573 22 f3 2a
    ld b,12h            ;0576 06 12
    ld ix,05abh         ;0578 dd 21 ab 05
l057ch:
    ld a,(de)           ;057c 1a
    cp (hl)             ;057d be
    jr z,cmd_found      ;057e 28 0c
    inc de              ;0580 13
    inc ix              ;0581 dd 23
    inc ix              ;0583 dd 23
    djnz l057ch         ;0585 10 f5
    ld a,1fh            ;0587 3e 1f
    jp error            ;0589 c3 cf 05

cmd_found:
    ld l,(ix+00h)
    ld h,(ix+01h)       ;HL=(IX)
    call do_cmd
    jp l0376h

do_cmd:
    jp (hl)

cmd_char:
    db "NSDIRGHW-VLT!PBUAC"

cmd_addr:
    dw cmd_new          ;"N": New Drive Name
    dw cmd_del          ;"S": Scratch Files
    dw cmd_drv          ;"D": Set Default Drive Number
    dw cmd_ini          ;"I": Initialize
    dw cmd_ren          ;"R": Rename File
    dw cmd_flg          ;"G": Set Global
    dw cmd_flg          ;"H": Set Hide a File
    dw cmd_flg          ;"W": Set Write Protect
    dw cmd_flg          ;"-": Reset (Global | Hide a File | Write Protect)
    dw cmd_vfy          ;"V": Validate
    dw cmd_lgn          ;"L": Login
    dw l0ca9h           ;"T": Transfer Files
    dw l0ef1h           ;"!"
    dw cmd_pos          ;"P": Record Position
    dw cmd_blk          ;"B": Block commands
    dw cmd_usr          ;"U": User commands
    dw cmd_abs          ;"A": Absolute commands
    dw cmd_cpy          ;"C": Copy and Concat

error:
    call error_out      ;Write the error msg defined in A into status buffer
    ld sp,4a93h
    jp l0376h

error_ok:
;Writes the error message "OK" into the status buffer
;
    call clrerrts       ;05d8 cd 4c 06

error_out:
;Writes the error message defined in A into the status buffer
;
;        A = Error Code
; (errtrk) = Error Track
; (errsec) = Error Sector
;
    ld (2050h),a
    ld hl,error_txt     ;Get address of error code/text table
l05e1h:
    bit 7,(hl)          ;Is this a valid error code (less than 128)
    jr nz,l05f0h        ;  NO: We reached the end of the error list, UNKNOWN ERROR CODE
    cp (hl)             ;Is this the wanted error code
    jr z,l05f0h         ;  YES: We reached the correct position
    inc hl              ;Now begin to skip the error text
l05e9h:
    bit 7,(hl)          ;Is the end of this error text reached
    inc hl
    jr z,l05e9h         ;  NO: loop
    jr l05e1h           ;  YES: Check the next error text

l05f0h:
    ex de,hl
    inc de
    push de
    ld hl,2cf5h         ;HL=stabuf
    ld de,0000h         ;DEA=(errcod)
    call put_number      ;Put a number into buffer

    ld (hl),","         ;Put comma into buffer
    inc hl

    pop de
l0600h:
    ld a,(de)           ;Get the character from error text
    and 01111111b       ;Mask off the highest bit (end marker bit)
    ld (hl),a           ;Store it into buffer

    cp 20h              ;Is this an error token?
    jr nc,l0623h        ;  NO: leave unchanged

    push de
    ld de,1baah         ;Get address of error token table
    ld b,a              ;B=error token

l060dh:
    dec b               ;Decrement error token
    jr z,l0617h         ;Is error token found? YES: Put the token into buffer

l0610h:
    ld a,(de)           ;Get the character from error token
    inc de
    rla                 ;Is highest bit set (end marker bit)?
    jr nc,l0610h        ;  NO: get next character
    jr l060dh           ;  YES: Check next error token

l0617h:
    ld a,(de)           ;Get the character from error token
    and 01111111b       ;Mask off the highest bit (end marker bit)
    ld (hl),a           ;Store it into buffer
    ld a,(de)           ;Get last character from error token
    inc hl
    inc de
    rla                 ;Is highest bit set (end marker bit)?
    jr nc,l0617h        ;  NO: get next character
    pop de
    dec hl

l0623h:
    ld a,(de)           ;Get last character from error text
    rla                 ;Is highest bit set (end marker bit)?
    inc hl
    inc de
    jr nc,l0600h        ;  NO: get next character

    ld (hl),","         ;Put comma into buffer
    inc hl

    ld a,(2051h)
    ld de,(2052h)       ;DEA=(errtrk)
    call put_number     ;Put a number into buffer

    ld (hl),2ch         ;Put comma into buffer
    inc hl

    ld a,(2054h)
    ld de,(2055h)       ;DEA=(errsec)
    call put_number     ;Put a number into buffer

    ld (hl),0dh         ;Put cr into buffer
    ld hl,2cf5h         ;When we start writing to control channel, we take it from status buffer (stabuf)
    ld (2af1h),hl       ;(staptr)=stabuf
    ret

clrerrts:
;clear error track and sector number
;
    xor a
    ld (2051h),a
    ld (2052h),a
    ld (2053h),a        ;errtrk=0

    ld (2054h),a
    ld (2055h),a
    ld (2056h),a        ;errtrk=0
    ret

put_number:
;Put a number into buffer
;
;Input DEA: Number
;Input HL: Buffer address
;
    ld ix,l06a9h
    ld b,06h            ;B=06h (Maximum 6 digits)
    ld iy,460fh
    res 0,(iy+00h)
    push hl
    ex de,hl
l0670h:
    ld e,(ix+01h)
    ld d,(ix+02h)
    ld c,2fh
l0678h:
    inc c
    sub (ix+00h)
    sbc hl,de
    jr nc,l0678h
    add a,(ix+00h)
    adc hl,de
    ld e,a
    ld a,c
    cp 30h
    jr nz,l0696h
    bit 0,(iy+00h)
    jr nz,l0696h
    ld a,b
    cp 02h
    jr nz,l069eh
l0696h:
    set 0,(iy+00h)
    ex (sp),hl
    ld (hl),c
    inc hl
    ex (sp),hl
l069eh:
    ld a,e
    inc ix
    inc ix
    inc ix
    djnz l0670h
    pop hl
    ret

l06a9h:
    db 0a0h,86h,01h     ;100000
    db 10h,27h,00h      ;10000

l06afh:
    db 0e8h,03h,00h     ;1000
    db 64h,00h,00h      ;100
    db 0ah,00h,00h      ;10
    db 01h,00h,00h      ;1

do_open:
    call error_ok
    call sub_1689h
    bit 7,(iy+28h)
    call nz,sub_08e7h
    ld iy,(2ae8h)
    ld (iy+28h),000h
    ld (iy+27h),000h
    ld (iy+26h),0ffh    ;No valid Allocation 1 index number
    ld hl,2c75h         ;HL=getbuf

l06dbh:
    ld a,(hl)
    cp "$"
    jp z,open_dir
    cp "#"
    jp z,open_chn
    cp "@"
    jr nz,l06f1h
    set 5,(iy+28h)      ;Set marker for "Command Access"
    inc hl
    jr l06dbh

l06f1h:
    call get_filename
    ld (iy+00h),000h
    ld a,(2ae7h)
    cp 02h
    jr nc,l0707h
    ld (iy+00h),002h
    set 0,(iy+28h)      ;Set marker for file type
l0707h:
    ld a,(hl)
    cp 0dh
    jr z,l0763h
    cp ","
    inc hl
    jr nz,l0707h
    ld a,(hl)
    ld b,00h
    cp "S"              ;check for "SEQ"
sub_0716h:
    jr z,l0748h
    ld b,01h
    cp "U"              ;check for "USR"
    jr z,l0748h
    ld b,02h
    cp "P"              ;check for "PRG"
    jr z,l0748h
    cp "W"              ;Write
    jr z,l075dh
    cp "A"              ;Append
    jr z,l0757h
    cp "R"              ;check for "REL"
    jr nz,l0737h
    inc hl
    ld a,(hl)
    cp "E"
    jr nz,l0707h
    inc hl
l0737h:
    cp "L"              ;(Record) Length
    jr nz,l0707h
    ld b,03h
    inc hl
    ld a,(hl)
    cp ","
    jr nz,l0748h
    inc hl
    ld a,(hl)
    ld (iy+15h),a       ;Save detected record length

l0748h:
    ld a,(iy+00h)       ;Get file attributes
    and 11111100b
    or b
    ld (iy+00h),a       ;Save detected file type

    set 0,(iy+28h)      ;Set marker for file type
    jr l0707h

l0757h:
    set 4,(iy+28h)      ;Set marker for "Append"
    jr l0707h

l075dh:
    set 3,(iy+28h)      ;Set marker for "Write"
    jr l0707h

l0763h:
    ld a,(2ae7h)
    cp 02h              ;Is (sa) >= 2
    jr nc,l0775h        ;  YES: No changes (can be read and write)

    res 3,(iy+28h)      ;Reset marker for "Write"
    or a                ;Is (sa) equal 0
    jr z,l0775h         ;  YES: This is a read channel

    set 3,(iy+28h)      ;Set marker for "Write"

l0775h:
    bit 3,(iy+28h)      ;Is marker for "Write" set?
    jp z,l0810h         ;  YES: do write
                        ;  NO: do read
l077ch:
    call check_wild
    ld a,21h            ;"SYNTAX ERROR(INVALID FILENAME)"
    jp c,error          ;If invalid filename, SYNTAX ERROR(INVALID FILENAME)

    ld hl,2d45h
    ld a,(2d67h)
    call find_first
    ld iy,(2ae8h)
    jr c,l07aah
    bit 5,(iy+28h)      ;Is marker for command access set
    ld a,3fh            ;"FILE EXISTS"
    jp z,error

    bit 6,(ix+00h)      ;is marker for "Write Protect" set?
    ld a,1ah            ;"WRITE PROTECTED"
    jp nz,error         ;07a2 c2 cf 05
    call sub_16e3h      ;07a5 cd e3 16
    jr l07adh           ;07a8 18 03
l07aah:
    call find_free      ;07aa cd 86 15
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
    call dir_writ_sec   ;080a cd 89 17
    jp l0376h           ;080d c3 76 03
l0810h:
    ld hl,2d45h         ;0810 21 45 2d
    ld a,(2d67h)        ;0813 3a 67 2d
    call find_first     ;0816 cd 3d 15
    ld iy,(2ae8h)       ;0819 fd 2a e8 2a
    jr nc,l082eh        ;081d 30 0f
    ld a,(iy+00h)       ;081f fd 7e 00
    and 03h             ;0822 e6 03
    cp 03h              ;0824 fe 03
    jp z,l077ch         ;0826 ca 7c 07
    ld a,3eh            ;0829 3e 3e
    jp error            ;082b c3 cf 05
l082eh:
    bit 0,(iy+28h)      ;082e fd cb 28 46
    jr z,l0852h         ;0832 28 1e
    ld a,(iy+00h)       ;0834 fd 7e 00
    xor (ix+00h)        ;0837 dd ae 00
    and 03h             ;083a e6 03
    jr z,l0852h         ;083c 28 14
    ld hl,2d45h         ;083e 21 45 2d
    ld a,(2d67h)        ;0841 3a 67 2d
    call find_next      ;0844 cd 44 15
    ld iy,(2ae8h)       ;0847 fd 2a e8 2a
    jr nc,l082eh        ;084b 30 e1
    ld a,40h            ;084d 3e 40
    jp error            ;084f c3 cf 05
l0852h:
    call loc1_read_sec  ;0852 cd be 18
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

open_chn:
    set 7,(iy+28h)
    set 6,(iy+28h)      ;Set marker for "Channel Access"
    ld (iy+20h),000h
    jp l0376h

sub_08e7h:
    call sub_1689h      ;08e7 cd 89 16
    bit 7,(iy+28h)      ;08ea fd cb 28 7e
    ret z               ;08ee c8
    res 7,(iy+28h)      ;08ef fd cb 28 be
    call sub_0bcah      ;08f3 cd ca 0b
    bit 7,(iy+27h)      ;08f6 fd cb 27 7e
    call nz,fil_writ_sec ;08fa c4 eb 17
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
    jp dir_writ_sec     ;092f c3 89 17
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
    jp nc,error         ;0978 d2 cf 05
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
    in a,(ppi2_pb)      ;0999 db 15
    or 10h              ;099b f6 10
    out (ppi2_pb),a     ;099d d3 15
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
    call wrieee         ;09b8 cd 19 05
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
    call wreoi          ;09db cd 08 05
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
    call wreoi          ;0a05 cd 08 05
    jp c,l0376h         ;0a08 da 76 03
    ld (iy+20h),000h    ;0a0b fd 36 20 00
    jr l09e9h           ;0a0f 18 d8
l0a11h:
    ld hl,(45f0h)       ;0a11 2a f0 45
    ld a,(45f2h)        ;0a14 3a f2 45
    cp l                ;0a17 bd
    jr z,l0a3fh         ;0a18 28 25
    ld a,(hl)           ;0a1a 7e
    call wrieee         ;0a1b cd 19 05
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
    call wreoi          ;0a40 cd 08 05
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
    call rdieee         ;0a7c cd c1 04
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
    call fil_writ_sec   ;0aa6 cd eb 17
    res 7,(iy+27h)      ;0aa9 fd cb 27 be
    jr l0a6fh           ;0aad 18 c0
l0aafh:
    call rdieee         ;0aaf cd c1 04
    jp c,l0376h         ;0ab2 da 76 03
    push af             ;0ab5 f5
    call error_ok       ;0ab6 cd d8 05
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
    call fil_writ_sec   ;0b1b cd eb 17
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
    call rdieee         ;0b5b cd c1 04
    jr nc,l0b66h        ;0b5e 30 06
    call fil_writ_sec   ;0b60 cd eb 17
    jp l0376h           ;0b63 c3 76 03
l0b66h:
    ld c,a              ;0b66 4f
    ld a,(iy+25h)       ;0b67 fd 7e 25
    or a                ;0b6a b7
    ld a,c              ;0b6b 79
    push af             ;0b6c f5
    push iy             ;0b6d fd e5
    ld a,33h            ;0b6f 3e 33
    call z,error_out    ;0b71 cc db 05
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
    call fil_writ_sec   ;0ba5 cd eb 17
    call sub_0bcah      ;0ba8 cd ca 0b
    call sub_10b0h      ;0bab cd b0 10
    call c,sub_17e0h    ;0bae dc e0 17
    ld hl,(2aech)       ;0bb1 2a ec 2a
    ret                 ;0bb4 c9
l0bb5h:
    call rdieee         ;0bb5 cd c1 04
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
    call hl_shr_b       ;0be2 cd 7a 1a
    ld a,l              ;0be5 7d
    and 7fh             ;0be6 e6 7f
    ld (2d6ah),a        ;0be8 32 6a 2d
    ld b,07h            ;0beb 06 07
    call hl_shr_b       ;0bed cd 7a 1a
    ld a,l              ;0bf0 7d
    ld (2d6dh),a        ;0bf1 32 6d 2d
    ret                 ;0bf4 c9

cmd_del:
;command for scratch files "S"
;
    call find_drvlet    ;0bf5 cd 25 16
l0bf8h:
    call get_filename   ;0bf8 cd e3 15
    push hl             ;0bfb e5
    ld a,0fh            ;0bfc 3e 0f
    ld (2ae7h),a        ;0bfe 32 e7 2a
    call sub_1689h      ;0c01 cd 89 16
    ld a,(2d67h)        ;0c04 3a 67 2d
    ld c,a              ;0c07 4f
    ld hl,2d45h         ;0c08 21 45 2d
    call find_first     ;0c0b cd 3d 15
    jr c,l0c38h         ;0c0e 38 28
l0c10h:
    bit 6,(ix+00h)      ;0c10 dd cb 00 76
    jr nz,l0c2ch        ;0c14 20 16
    bit 7,(ix+00h)      ;0c16 dd cb 00 7e
    jr nz,l0c2ch        ;0c1a 20 10
    ld hl,2051h         ;0c1c 21 51 20
    inc (hl)            ;0c1f 34
    ld (ix+01h),0ffh    ;0c20 dd 36 01 ff
    push de             ;0c24 d5
    call sub_16e3h      ;0c25 cd e3 16
    pop de              ;0c28 d1
    call dir_writ_sec   ;0c29 cd 89 17
l0c2ch:
    ld hl,2d45h         ;0c2c 21 45 2d
    ld a,(2d67h)        ;0c2f 3a 67 2d
    ld c,a              ;0c32 4f
    call find_next      ;0c33 cd 44 15
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
    jp error_out        ;0c45 c3 db 05

cmd_flg:
;Command set or reset a flag (Global, Hide a File, Write Protect)
;
    call find_drvlet    ;0c48 cd 25 16
    call get_filename   ;0c4b cd e3 15
    ld a,(2d67h)        ;0c4e 3a 67 2d
    ld hl,2d45h         ;0c51 21 45 2d
    call find_first     ;0c54 cd 3d 15
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
    call dir_writ_sec   ;0c9b cd 89 17
    ld hl,2d45h         ;0c9e 21 45 2d
    ld a,(2d67h)        ;0ca1 3a 67 2d
    call find_next      ;0ca4 cd 44 15
    jr l0c57h           ;0ca7 18 ae
l0ca9h:
    call find_drvlet    ;0ca9 cd 25 16
    call get_filename   ;0cac cd e3 15
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
    call find_first     ;0cc6 cd 3d 15
l0cc9h:
    pop bc              ;0cc9 c1
    ret c               ;0cca d8
    ld (ix+01h),c       ;0ccb dd 71 01
    push bc             ;0cce c5
    call dir_writ_sec   ;0ccf cd 89 17
    ld a,(2d67h)        ;0cd2 3a 67 2d
    ld hl,2d45h         ;0cd5 21 45 2d
    call find_next      ;0cd8 cd 44 15
    jr l0cc9h           ;0cdb 18 ec
l0cddh:
    ld a,1eh            ;0cdd 3e 1e
    jp error            ;0cdf c3 cf 05

cmd_cpy:
;command for copy and concat "C"
;
    call find_drvlet    ;0ce2 cd 25 16
    call get_filename   ;0ce5 cd e3 15
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
    call check_wild     ;0d13 cd 3b 16
    ld a,21h            ;0d16 3e 21
    jp c,error          ;0d18 da cf 05
    pop hl              ;0d1b e1
    ld a,(hl)           ;0d1c 7e
    cp 3dh              ;0d1d fe 3d
    ld a,1eh            ;0d1f 3e 1e
    jp nz,error         ;0d21 c2 cf 05
    inc hl              ;0d24 23
    call get_filename   ;0d25 cd e3 15
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
    call find_first     ;0d4b cd 3d 15
    ld a,3eh            ;0d4e 3e 3e
    jp c,error          ;0d50 da cf 05
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
    call find_first     ;0d8e cd 3d 15
    ld a,3fh            ;0d91 3e 3f
    jp nc,error         ;0d93 d2 cf 05
    call find_free      ;0d96 cd 86 15
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
    call find_first     ;0dc3 cd 3d 15
    ld a,3eh            ;0dc6 3e 3e
    jp c,error          ;0dc8 da cf 05
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
    call loc1_read_sec  ;0df7 cd be 18
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
    call loc2_writ_sec  ;0e0a cd b5 17
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
    ld de,(2031h)       ;0e33 ed 5b 31 20
    ld a,(2033h)        ;0e37 3a 33 20
    add hl,de           ;0e3a 19
    add a,b             ;0e3b 80
    ex de,hl            ;0e3c eb
    ld hl,2004h         ;0e3d 21 04 20
    ld b,(hl)           ;0e40 46
    ld hl,4710h         ;0e41 21 10 47
    call corv_read_sec  ;0e44 cd 82 19
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
    call fil_writ_sec   ;0e85 cd eb 17
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
    call get_filename   ;0eb0 cd e3 15
    push hl             ;0eb3 e5
    ld hl,2d45h         ;0eb4 21 45 2d
    ld a,(2d67h)        ;0eb7 3a 67 2d
    call find_first     ;0eba cd 3d 15
    jp nc,l0ddbh        ;0ebd d2 db 0d
    ld a,3eh            ;0ec0 3e 3e
    jp error            ;0ec2 c3 cf 05
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

cmd_lgn:
;command for login "L"
;
    ld a,1fh            ;0eec 3e 1f
    jp error            ;0eee c3 cf 05
l0ef1h:
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
    jp error            ;0f0b c3 cf 05
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
    call get_numeric    ;0f36 cd 4d 16
    jr c,l0f3fh         ;0f39 38 04
    ld (2000h),a        ;0f3b 32 00 20
    ret                 ;0f3e c9
l0f3fh:
    ld a,1eh            ;0f3f 3e 1e
    jp error            ;0f41 c3 cf 05
    ld a,(2002h)        ;0f44 3a 02 20
    ld (2051h),a        ;0f47 32 51 20
    ld a,59h            ;0f4a 3e 59
    jp error            ;0f4c c3 cf 05
    ld a,02h            ;0f4f 3e 02
    ld (2051h),a        ;0f51 32 51 20
    ld a,04h            ;0f54 3e 04
    ld (2054h),a        ;0f56 32 54 20
    ld a,63h            ;0f59 3e 63
    jp error            ;0f5b c3 cf 05
    call get_numeric    ;0f5e cd 4d 16
    and 0fh             ;0f61 e6 0f
    ld d,a              ;0f63 57
    ld e,00h            ;0f64 1e 00
    ld hl,5000h         ;0f66 21 00 50
    add hl,de           ;0f69 19
    jp (hl)             ;0f6a e9

cmd_drv:
    call find_drvlet    ;0f6b cd 25 16
    ld a,(hl)           ;0f6e 7e
    call sub_1682h      ;0f6f cd 82 16
    jr nc,l0f7ah        ;0f72 30 06
    sub 30h             ;0f74 d6 30
    ld (204fh),a        ;0f76 32 4f 20
    ret                 ;0f79 c9
l0f7ah:
    ld a,1eh            ;0f7a 3e 1e
    jp error            ;0f7c c3 cf 05

cmd_ini:
    ret                 ;0f7f c9

cmd_vfy:
    ld hl,0000h         ;0f80 21 00 00
    ld (2d68h),hl       ;0f83 22 68 2d
l0f86h:
    call dir_get_next   ;0f86 cd a6 15
    jr c,l0f9ah         ;0f89 38 0f
    bit 7,(ix+00h)      ;0f8b dd cb 00 7e
    jr z,l0f86h         ;0f8f 28 f5
    ld (ix+01h),0ffh    ;0f91 dd 36 01 ff
    call dir_writ_sec   ;0f95 cd 89 17
    jr l0f86h           ;0f98 18 ec
l0f9ah:
    ld a,(2002h)        ;0f9a 3a 02 20
    jp init_user       ;0f9d c3 0d 02

cmd_ren:
    call find_drvlet    ;0fa0 cd 25 16
    call get_filename   ;0fa3 cd e3 15
    ld a,(2d67h)        ;0fa6 3a 67 2d
    push af             ;0fa9 f5
    push hl             ;0faa e5
    call check_wild     ;0fab cd 3b 16
    ld a,21h            ;0fae 3e 21
    jp c,error          ;0fb0 da cf 05
    ld hl,2d45h         ;0fb3 21 45 2d
    ld de,2d56h         ;0fb6 11 56 2d
    ld bc,0010h         ;0fb9 01 10 00
    ldir                ;0fbc ed b0
    pop hl              ;0fbe e1
    ld a,(hl)           ;0fbf 7e
    cp 3dh              ;0fc0 fe 3d
    ld a,1eh            ;0fc2 3e 1e
    jp nz,error         ;0fc4 c2 cf 05
    inc hl              ;0fc7 23
    call get_filename   ;0fc8 cd e3 15
    call check_wild     ;0fcb cd 3b 16
    ld a,21h            ;0fce 3e 21
    jp c,error          ;0fd0 da cf 05
    pop af              ;0fd3 f1
    push af             ;0fd4 f5
    ld hl,2d56h         ;0fd5 21 56 2d
    call find_first     ;0fd8 cd 3d 15
    ld a,3fh            ;0fdb 3e 3f
    jp nc,error         ;0fdd d2 cf 05
    pop af              ;0fe0 f1
    ld hl,2d45h         ;0fe1 21 45 2d
    call find_first     ;0fe4 cd 3d 15
    ld a,3eh            ;0fe7 3e 3e
    jp c,error          ;0fe9 da cf 05
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
    jp dir_writ_sec     ;0fff c3 89 17

cmd_new:
    call find_drvlet    ;1002 cd 25 16
    call get_filename   ;1005 cd e3 15
    ld a,(hl)           ;1008 7e
    cp 2ch              ;1009 fe 2c
    ld a,1eh            ;100b 3e 1e
    jp nz,error         ;100d c2 cf 05
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

cmd_pos:
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
    jp error            ;10ad c3 cf 05
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

cmd_blk:
    ld hl,2bf5h         ;10d0 21 f5 2b
l10d3h:
    ld a,(hl)           ;10d3 7e
    inc hl              ;10d4 23
    cp 0dh              ;10d5 fe 0d
    jr z,l1106h         ;10d7 28 2d
    cp 2dh              ;10d9 fe 2d
    jr nz,l10d3h        ;10db 20 f6
l10ddh:
    ld a,(hl)
    inc hl
    cp 0dh
    jr z,l1106h
    cp "A"
    jp c,l10ddh
    cp "Z"+1
    jp nc,l10ddh
    cp "W"              ;Check for "B-W": Block Write
    jp z,blk_wr
    cp "R"              ;Check for "B-R": Block Read
    jp z,blk_rd
    cp "A"              ;Check for "B-A": Block Allocate
    jp z,blk_use
    cp "F"              ;Check for "B-F": Block Free
    jp z,blk_fre
    cp "P"              ;Check for "B-P": Buffer Pointer
    jp z,blk_ptr
l1106h:
    ld a,1eh            ;"SYNTAX ERROR"
    jp error

blk_wr:
;command for block write "B-W"
;
    call sub_1226h
    push af
    push hl

    ld a,(iy+20h)       ;Get the block pointer for this channel
    dec a               ;Decrement it
    ld hl,(2aech)       ;Get buffer address
    ld (hl),a           ;Store the block pointer minus 1 at the
                        ;  first byte into the buffer
    pop hl
    pop af
    jp corv_writ_sec    ;Write a sector (256 bytes)

blk_rd:
    call sub_1226h      ;111d cd 26 12
    call corv_read_sec      ;1120 cd 82 19
    ld hl,(2aech)       ;1123 2a ec 2a
    ld a,(hl)           ;1126 7e
    ld (iy+25h),a       ;1127 fd 77 25
    ld (iy+20h),001h    ;112a fd 36 20 01
    ret                 ;112e c9
blk_ptr:
    call get_chan       ;112f cd d5 12
    jr c,l1106h         ;1132 38 d2
    call get_numeric    ;1134 cd 4d 16
    ld (iy+20h),a       ;1137 fd 77 20
    ret                 ;113a c9
blk_fre:
    call get_bam_bit    ;113b cd cf 11
    and 7fh             ;113e e6 7f
    jr l1149h           ;1140 18 07
blk_use:
    call get_bam_bit    ;1142 cd cf 11
    jr c,l1153h         ;1145 38 0c
    or 80h              ;1147 f6 80
l1149h:
    rrca                ;1149 0f
    djnz l1149h         ;114a 10 fd
    ld (hl),a           ;114c 77
    call sub_1955h      ;114d cd 55 19
    jp error_ok         ;1150 c3 d8 05
l1153h:
    inc b               ;1153 04
l1154h:
    push af             ;1154 f5
    ld ix,2054h         ;1155 dd 21 54 20
    inc (ix+00h)        ;1159 dd 34 00
    jr nz,l1166h        ;115c 20 08
    inc (ix+01h)        ;115e dd 34 01
    jr nz,l1166h        ;1161 20 03
    inc (ix+02h)        ;1163 dd 34 02
l1166h:
    ld a,(2011h)        ;1166 3a 11 20
    cp (ix+00h)         ;1169 dd be 00
    jr nz,l11b1h        ;116c 20 43
    ld a,(2012h)        ;116e 3a 12 20
    cp (ix+01h)         ;1171 dd be 01
    jr nz,l11b1h        ;1174 20 3b
    ld a,(2013h)        ;1176 3a 13 20
    cp (ix+02h)         ;1179 dd be 02
    jr nz,l11b1h        ;117c 20 33
    ld (ix+00h),000h    ;117e dd 36 00 00
    ld (ix+01h),000h    ;1182 dd 36 01 00
    ld (ix+02h),000h    ;1186 dd 36 02 00
    ld ix,2051h         ;118a dd 21 51 20
    inc (ix+00h)        ;118e dd 34 00
    jr nz,l1196h        ;1191 20 03
    inc (ix+01h)        ;1193 dd 34 01
l1196h:
    ld a,(200fh)        ;1196 3a 0f 20
    sub (ix+00h)        ;1199 dd 96 00
    ld a,(2010h)        ;119c 3a 10 20
    sbc a,(ix+01h)      ;119f dd 9e 01
    jr nc,l11b1h        ;11a2 30 0d
    ld (ix+00h),000h    ;11a4 dd 36 00 00
    ld (ix+01h),000h    ;11a8 dd 36 01 00
    ld a,41h            ;11ac 3e 41
    jp error            ;11ae c3 cf 05
l11b1h:
    pop af              ;11b1 f1
    djnz l11c7h         ;11b2 10 13
    inc hl              ;11b4 23
    ld a,l              ;11b5 7d
    cp 10h              ;11b6 fe 10
    jr nz,l11c4h        ;11b8 20 0a
    ld hl,204eh         ;11ba 21 4e 20
    inc (hl)            ;11bd 34
    call bam_read_sec   ;11be cd 4f 19
    ld hl,4910h         ;11c1 21 10 49
l11c4h:
    ld a,(hl)           ;11c4 7e
    ld b,08h            ;11c5 06 08
l11c7h:
    rrca                ;11c7 0f
    jr c,l1154h         ;11c8 38 8a
    ld a,41h            ;11ca 3e 41
    jp error            ;11cc c3 cf 05
get_bam_bit:
    call get_ts         ;11cf cd 45 12
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
    ld (204eh),a        ;11df 32 4e 20
    call bam_read_sec   ;11e2 cd 4f 19
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

cmd_usr:
    ld hl,2bf6h         ;11fb 21 f6 2b
    ld a,(hl)           ;11fe 7e
    inc hl              ;11ff 23
    and 0fh             ;1200 e6 0f
    cp 01h              ;1202 fe 01
    jr z,cmd_u1         ;1204 28 0c
    cp 02h              ;1206 fe 02
    jr z,cmd_u2         ;1208 28 16
    cp 0ah              ;120a fe 0a
    jp z,reset          ;120c ca 00 02
    jp l1106h           ;120f c3 06 11
cmd_u1:
    call sub_1226h      ;1212 cd 26 12
    ld (iy+25h),0ffh    ;1215 fd 36 25 ff
    ld (iy+20h),000h    ;1219 fd 36 20 00
    jp corv_read_sec    ;121d c3 82 19
cmd_u2:
    call sub_1226h      ;1220 cd 26 12
    jp corv_writ_sec    ;1223 c3 b3 19
sub_1226h:
    call get_chan       ;1226 cd d5 12
    ld a,1eh            ;1229 3e 1e
    jp c,error          ;122b da cf 05
    call get_ts         ;122e cd 45 12
    call clrerrts       ;1231 cd 4c 06
    ld hl,(2036h)       ;1234 2a 36 20
    ld a,(2038h)        ;1237 3a 38 20
    add hl,de           ;123a 19
    adc a,b             ;123b 88
    ex de,hl            ;123c eb
    ld hl,2004h         ;123d 21 04 20
    ld b,(hl)           ;1240 46
    ld hl,(2aech)       ;1241 2a ec 2a
    ret                 ;1244 c9
get_ts:
    call get_numeric    ;1245 cd 4d 16
    jp c,l12d0h         ;1248 da d0 12
    ld de,(200fh)       ;124b ed 5b 0f 20
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
    call get_numeric    ;125d cd 4d 16
    jr c,l12d0h         ;1260 38 6e
    inc d               ;1262 14
    dec d               ;1263 15
    jr nz,l12cbh        ;1264 20 65
    ld d,e              ;1266 53
    ld e,a              ;1267 5f
    ld (2051h),de       ;1268 ed 53 51 20
    dec de              ;126c 1b
    ld bc,(200fh)       ;126d ed 4b 0f 20
    ld a,e              ;1271 7b
    sub c               ;1272 91
    ld a,d              ;1273 7a
    sbc a,b             ;1274 98
    jr nc,l12cbh        ;1275 30 54
    ex (sp),hl          ;1277 e3
    add hl,de           ;1278 19
    ex de,hl            ;1279 eb
    ld ix,(2011h)       ;127a dd 2a 11 20
    ld bc,(2013h)       ;127e ed 4b 13 20
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
    call get_numeric    ;1297 cd 4d 16
    jr c,l12d0h         ;129a 38 34
    ld (2054h),a        ;129c 32 54 20
    ld (2055h),de       ;129f ed 53 55 20
    ld b,a              ;12a3 47
    ld hl,2011h         ;12a4 21 11 20
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
    ld hl,(200dh)       ;12b9 2a 0d 20
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
    jp error            ;12cd c3 cf 05
l12d0h:
    ld a,1eh            ;12d0 3e 1e
    jp error            ;12d2 c3 cf 05
get_chan:
    call get_numeric    ;12d5 cd 4d 16
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

cmd_abs:
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
    jp z,abs_wr         ;1310 ca 1d 13
    cp 52h              ;1313 fe 52
    jp z,abs_rd         ;1315 ca 2c 13
l1318h:
    ld a,1eh            ;1318 3e 1e
    jp error            ;131a c3 cf 05
abs_wr:
    ld a,(2002h)        ;131d 3a 02 20
    or a                ;1320 b7
    ld a,5ch            ;1321 3e 5c
    jp nz,error         ;1323 c2 cf 05
    call sub_134dh      ;1326 cd 4d 13
    jp corv_writ_sec    ;1329 c3 b3 19
abs_rd:
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
    ld a,(2002h)        ;1340 3a 02 20
    or a                ;1343 b7
    ld a,5ch            ;1344 3e 5c
    jp nz,error         ;1346 c2 cf 05
l1349h:
    pop af              ;1349 f1
    jp corv_read_sec    ;134a c3 82 19
sub_134dh:
    call get_chan       ;134d cd d5 12
    ld a,1eh            ;1350 3e 1e
    jp c,error          ;1352 da cf 05
    call get_numeric    ;1355 cd 4d 16
    push af             ;1358 f5
    call get_numeric    ;1359 cd 4d 16
    push de             ;135c d5
    ld d,e              ;135d 53
    ld e,a              ;135e 5f
    pop af              ;135f f1
    pop bc              ;1360 c1
    ld hl,(2aech)       ;1361 2a ec 2a
    ret                 ;1364 c9
open_dir:
    set 2,(iy+28h)      ;1365 fd cb 28 d6
    set 7,(iy+28h)      ;1369 fd cb 28 fe
    ld hl,2c76h         ;136d 21 76 2c
    call get_filename   ;1370 cd e3 15
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
    ld a,(2002h)        ;13d8 3a 02 20
    push de             ;13db d5
    ld de,0000h         ;13dc 11 00 00
    call put_number     ;13df cd 60 06
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
    call find_next      ;1415 cd 44 15
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
    ld hl,203eh         ;14f3 21 3e 20
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
    db 20h

find_first:
;Find the first result from directory
;Returns carry set if file is not found, clear if found.
;
;See find_next
;
    ld de,0000h
    ld (2d68h),de       ;(dirnum)=0
                        ;Fall through into find_next

find_next:
    ld c,a              ;1544 4f
    ld (4608h),hl       ;1545 22 08 46
l1548h:
    push bc             ;1548 c5
    call dir_get_next      ;1549 cd a6 15
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
find_free:
    ld hl,0000h         ;1586 21 00 00
    ld (2d68h),hl       ;1589 22 68 2d
l158ch:
    call dir_get_next   ;158c cd a6 15
    bit 7,(ix+01h)      ;158f dd cb 01 7e
    ret nz              ;1593 c0
    inc de              ;1594 13
    ld a,(200bh)        ;1595 3a 0b 20
    cp e                ;1598 bb
    jr nz,l158ch        ;1599 20 f1
    ld a,(200ch)        ;159b 3a 0c 20
    cp d                ;159e ba
    jr nz,l158ch        ;159f 20 eb
    ld a,48h            ;15a1 3e 48
    jp error            ;15a3 c3 cf 05
dir_get_next:
    ld a,(460ch)        ;15a6 3a 0c 46
    or a                ;15a9 b7
    ld a,54h            ;15aa 3e 54
    jp z,error          ;15ac ca cf 05
    ld hl,(2d68h)       ;15af 2a 68 2d
    ld e,l              ;15b2 5d
    ld d,h              ;15b3 54
    inc hl              ;15b4 23
    ld (2d68h),hl       ;15b5 22 68 2d
    ld a,(200bh)        ;15b8 3a 0b 20
    cp e                ;15bb bb
    jr nz,l15c4h        ;15bc 20 06
    ld a,(200ch)        ;15be 3a 0c 20
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
get_filename:
    ld a,(204fh)        ;15e3 3a 4f 20
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
    jp error            ;161c c3 cf 05
l161fh:
    xor a               ;161f af
    ld (de),a           ;1620 12
    inc de              ;1621 13
    djnz l161fh         ;1622 10 fb
    ret                 ;1624 c9
find_drvlet:
    ld hl,2bf5h         ;1625 21 f5 2b
l1628h:
    ld a,(hl)           ;1628 7e
    cp 0dh              ;1629 fe 0d
    ld a,22h            ;162b 3e 22
    jp z,error          ;162d ca cf 05
    ld a,(hl)           ;1630 7e
    cp 30h              ;1631 fe 30
    jr c,l1638h         ;1633 38 03
    cp 3ah              ;1635 fe 3a
    ret c               ;1637 d8
l1638h:
    inc hl              ;1638 23
    jr l1628h           ;1639 18 ed
check_wild:
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
get_numeric:
    ld a,(hl)           ;164d 7e
    inc hl              ;164e 23
    cp 0dh              ;164f fe 0d
    scf                 ;1651 37
    ret z               ;1652 c8
    call sub_1682h      ;1653 cd 82 16
    jr nc,get_numeric   ;1656 30 f5
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
    jp error            ;16e0 c3 cf 05
sub_16e3h:
    push ix             ;16e3 dd e5
    push iy             ;16e5 fd e5
    push hl             ;16e7 e5
    push de             ;16e8 d5
    push bc             ;16e9 c5
    call sub_1973h      ;16ea cd 73 19
    call loc1_read_sec  ;16ed cd be 18
    ld b,40h            ;16f0 06 40
    ld ix,(2aeeh)       ;16f2 dd 2a ee 2a
l16f6h:
    ld e,(ix+00h)       ;16f6 dd 5e 00
    ld d,(ix+01h)       ;16f9 dd 56 01
    bit 7,d             ;16fc cb 7a
    jr nz,l1725h        ;16fe 20 25
    push bc             ;1700 c5
    push de             ;1701 d5
    call loc2_writ_sec  ;1702 cd b5 17
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
    ld de,2057h         ;171e 11 57 20
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
    call hl_shr_b       ;174b cd 7a 1a
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
    ld de,(2034h)       ;1760 ed 5b 34 20
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
    call corv_read_sec  ;1783 cd 82 19
    pop hl              ;1786 e1
    pop de              ;1787 d1
    ret                 ;1788 c9
dir_writ_sec:
    push de             ;1789 d5
    push hl             ;178a e5
    call sub_1973h      ;178b cd 73 19
    call sub_1797h      ;178e cd 97 17
    call corv_writ_sec  ;1791 cd b3 19
    pop hl              ;1794 e1
    pop de              ;1795 d1
    ret                 ;1796 c9
sub_1797h:
    ld a,(2004h)        ;1797 3a 04 20
    ld b,a              ;179a 47
    srl d               ;179b cb 3a
    rr e                ;179d cb 1b
    srl d               ;179f cb 3a
    rr e                ;17a1 cb 1b
    srl d               ;17a3 cb 3a
    rr e                ;17a5 cb 1b
    ld hl,(2024h)       ;17a7 2a 24 20
    add hl,de           ;17aa 19
    ex de,hl            ;17ab eb
    ld a,(2026h)        ;17ac 3a 26 20
    adc a,00h           ;17af ce 00
    ld hl,2af5h         ;17b1 21 f5 2a
    ret                 ;17b4 c9
loc2_writ_sec:
    push de             ;17b5 d5
    push hl             ;17b6 e5
    call sub_17ceh      ;17b7 cd ce 17
    call corv_read_sec  ;17ba cd 82 19
    pop de              ;17bd d1
    pop hl              ;17be e1
    ret                 ;17bf c9
sub_17c0h:
    push de             ;17c0 d5
    push hl             ;17c1 e5
    call sub_1973h      ;17c2 cd 73 19
    call sub_17ceh      ;17c5 cd ce 17
    call corv_writ_sec  ;17c8 cd b3 19
    pop de              ;17cb d1
    pop hl              ;17cc e1
    ret                 ;17cd c9
sub_17ceh:
    ld a,(2004h)        ;17ce 3a 04 20
    ld b,a              ;17d1 47
    ld hl,(202ch)       ;17d2 2a 2c 20
    ld a,(202eh)        ;17d5 3a 2e 20
    add hl,de           ;17d8 19
    ex de,hl            ;17d9 eb
    adc a,00h           ;17da ce 00
    ld hl,(2aeah)       ;17dc 2a ea 2a
    ret                 ;17df c9
sub_17e0h:
    push de             ;17e0 d5
    push hl             ;17e1 e5
    call sub_17f6h      ;17e2 cd f6 17
    call corv_read_sec  ;17e5 cd 82 19
    pop hl              ;17e8 e1
    pop de              ;17e9 d1
    ret                 ;17ea c9
fil_writ_sec:
    push de             ;17eb d5
    push hl             ;17ec e5
    call sub_17f6h      ;17ed cd f6 17
    call corv_writ_sec  ;17f0 cd b3 19
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
    call nz,loc2_writ_sec ;181e c4 b5 17
    pop af              ;1821 f1
    jr nz,l1847h        ;1822 20 23
    ld de,2057h         ;1824 11 57 20
    ld bc,(202fh)       ;1827 ed 4b 2f 20
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
    ld bc,(2034h)       ;1863 ed 4b 34 20
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
    ld de,(2031h)       ;18a7 ed 5b 31 20
    add hl,de           ;18ab 19
    ex de,hl            ;18ac eb
    ld b,a              ;18ad 47
    ld a,(2033h)        ;18ae 3a 33 20
    adc a,b             ;18b1 88
    ld hl,2004h         ;18b2 21 04 20
    ld b,(hl)           ;18b5 46
    ld hl,(2aech)       ;18b6 2a ec 2a
    pop iy              ;18b9 fd e1
    pop ix              ;18bb dd e1
    ret                 ;18bd c9
loc1_read_sec:
    push hl             ;18be e5
    push de             ;18bf d5
    push bc             ;18c0 c5
    srl d               ;18c1 cb 3a
    rr e                ;18c3 cb 1b
    push af             ;18c5 f5
    ld hl,(2027h)       ;18c6 2a 27 20
    ld a,(2029h)        ;18c9 3a 29 20
    add hl,de           ;18cc 19
    adc a,00h           ;18cd ce 00
    ex de,hl            ;18cf eb
    ld hl,2004h         ;18d0 21 04 20
    ld b,(hl)           ;18d3 46
    ld hl,4710h         ;18d4 21 10 47
    call corv_read_sec  ;18d7 cd 82 19
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
    ld hl,(2027h)       ;18f9 2a 27 20
    ld a,(2029h)        ;18fc 3a 29 20
    add hl,de           ;18ff 19
    adc a,00h           ;1900 ce 00
    ex de,hl            ;1902 eb
    ld hl,2004h         ;1903 21 04 20
    ld b,(hl)           ;1906 46
    ld hl,4710h         ;1907 21 10 47
    push af             ;190a f5
    push de             ;190b d5
    push bc             ;190c c5
    call corv_read_sec  ;190d cd 82 19
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
    call corv_writ_sec  ;1926 cd b3 19
    pop bc              ;1929 c1
    pop de              ;192a d1
    pop hl              ;192b e1
    ret                 ;192c c9
sub_192dh:
    ld a,(2004h)        ;192d 3a 04 20
    ld b,a              ;1930 47
    ld de,(2005h)       ;1931 ed 5b 05 20
    ld a,(2007h)        ;1935 3a 07 20
    ld hl,4610h         ;1938 21 10 46
    jp corv_read_sec    ;193b c3 82 19
l193eh:
    ld a,(2004h)        ;193e 3a 04 20
    ld b,a              ;1941 47
    ld de,(2005h)       ;1942 ed 5b 05 20
    ld a,(2007h)        ;1946 3a 07 20
    ld hl,4610h         ;1949 21 10 46
    jp corv_writ_sec    ;194c c3 b3 19
bam_read_sec:
    call sub_195bh      ;194f cd 5b 19
    jp corv_read_sec    ;1952 c3 82 19
sub_1955h:
    call sub_195bh      ;1955 cd 5b 19
    jp corv_writ_sec    ;1958 c3 b3 19
sub_195bh:
    ld de,(204eh)       ;195b ed 5b 4e 20
    ld d,00h            ;195f 16 00
    ld hl,(203bh)       ;1961 2a 3b 20
    ld a,(203dh)        ;1964 3a 3d 20
    add hl,de           ;1967 19
    adc a,00h           ;1968 ce 00
    ex de,hl            ;196a eb
    ld hl,2004h         ;196b 21 04 20
    ld b,(hl)           ;196e 46
    ld hl,4910h         ;196f 21 10 49
    ret                 ;1972 c9
sub_1973h:
    ld a,(200ah)        ;1973 3a 0a 20
    or a                ;1976 b7
    ret z               ;1977 c8
    ld a,(2002h)        ;1978 3a 02 20
    or a                ;197b b7
    ret z               ;197c c8
    ld a,5ch            ;197d 3e 5c
    jp error            ;197f c3 cf 05
corv_read_sec:
    ld (4a10h),de       ;1982 ed 53 10 4a
    ld (4a12h),a        ;1986 32 12 4a
    push hl             ;1989 e5
    ld a,21h            ;198a 3e 21
    call corv_send_cmd  ;198c cd f0 19
    call sub_1a29h      ;198f cd 29 1a
    call sub_1a0dh      ;1992 cd 0d 1a
    pop hl              ;1995 e1
    jr nz,l19dfh        ;1996 20 47
    ld a,41h            ;1998 3e 41
    call corv_send_cmd  ;199a cd f0 19
    ld b,00h            ;199d 06 00
l199fh:
    in a,(corvus)       ;199f db 18
    ld (hl),a           ;19a1 77
    inc hl              ;19a2 23
    ex (sp),hl          ;19a3 e3
    ex (sp),hl          ;19a4 e3
    djnz l199fh         ;19a5 10 f8
    call sub_1a0dh      ;19a7 cd 0d 1a
    ret z               ;19aa c8
    ld (2051h),a        ;19ab 32 51 20
    ld a,16h            ;19ae 3e 16
    jp l19dfh           ;19b0 c3 df 19

corv_writ_sec:
;Write a sector (256 bytes) to the Corvus hard drive
;
;  B = Drive Number
;ADE = Sector address (20 bit address)
; HL = DMA buffer address
;
    ld (4a10h),de       ;19b3 ed 53 10 4a
    ld (4a12h),a        ;19b7 32 12 4a
    ld a,42h            ;19ba 3e 42
    call corv_send_cmd  ;19bc cd f0 19
    ld b,00h            ;19bf 06 00
l19c1h:
    ld a,(hl)           ;19c1 7e
    out (corvus),a      ;19c2 d3 18
    inc hl              ;19c4 23
    ex (sp),hl          ;19c5 e3
    ex (sp),hl          ;19c6 e3
    djnz l19c1h         ;19c7 10 f8
    call sub_1a0dh      ;19c9 cd 0d 1a
    jr nz,l19dfh        ;19cc 20 11
    ld a,22h            ;19ce 3e 22
    call corv_send_cmd  ;19d0 cd f0 19
    call sub_1a29h      ;19d3 cd 29 1a
    call sub_1a0dh      ;19d6 cd 0d 1a
    ret z               ;19d9 c8
    ld (2051h),a        ;19da 32 51 20
    ld a,19h            ;19dd 3e 19
l19dfh:
    push af             ;19df f5
    ld hl,(4a10h)       ;19e0 2a 10 4a
    ld (2054h),hl       ;19e3 22 54 20
    ld a,(4a12h)        ;19e6 3a 12 4a
    ld (2056h),a        ;19e9 32 56 20
    pop af              ;19ec f1
    jp error_out        ;19ed c3 db 05
corv_send_cmd:
    ld b,a              ;19f0 47
    xor a               ;19f1 af
    out (corvus),a      ;19f2 d3 18
l19f4h:
    in a,(corvus)       ;19f4 db 18
    cp 0a0h             ;19f6 fe a0
    jr nz,l19f4h        ;19f8 20 fa
    ld a,b              ;19fa 78
    out (corvus),a      ;19fb d3 18
l19fdh:
    in a,(corvus)       ;19fd db 18
    cp 0a1h             ;19ff fe a1
    jr nz,l19fdh        ;1a01 20 fa
    ld a,0ffh           ;1a03 3e ff
    out (corvus),a      ;1a05 d3 18
    ld b,14h            ;1a07 06 14
l1a09h:
    nop                 ;1a09 00
    djnz l1a09h         ;1a0a 10 fd
    ret                 ;1a0c c9
sub_1a0dh:
    ld a,0ffh           ;1a0d 3e ff
    out (corvus),a      ;1a0f d3 18
l1a11h:
    in a,(corvus)       ;1a11 db 18
    inc a               ;1a13 3c
    jr nz,l1a11h        ;1a14 20 fb
    ld a,0feh           ;1a16 3e fe
    out (corvus),a      ;1a18 d3 18
l1a1ah:
    in a,(corvus)       ;1a1a db 18
    rla                 ;1a1c 17
    jr c,l1a1ah         ;1a1d 38 fb
    in a,(corvus)       ;1a1f db 18
    bit 6,a             ;1a21 cb 77
    push af             ;1a23 f5
    xor a               ;1a24 af
    out (corvus),a      ;1a25 d3 18
    pop af              ;1a27 f1
    ret                 ;1a28 c9
sub_1a29h:
    xor a               ;1a29 af
    out (corvus),a      ;1a2a d3 18
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
    out (corvus),a      ;1a5f d3 18
    ld hl,(0134h)       ;1a61 2a 34 01
    add hl,de           ;1a64 19
    ld a,l              ;1a65 7d
    out (corvus),a      ;1a66 d3 18
    ld a,h              ;1a68 7c
    out (corvus),a      ;1a69 d3 18
    ld a,(4a10h)        ;1a6b 3a 10 4a
    and 1fh             ;1a6e e6 1f
    out (corvus),a      ;1a70 d3 18
    xor a               ;1a72 af
    out (corvus),a      ;1a73 d3 18
    out (corvus),a      ;1a75 d3 18
    out (corvus),a      ;1a77 d3 18
    ret                 ;1a79 c9

hl_shr_b:
;Shift B times HL right, so HL is divided by 2^B
;
    srl h
    rr l
    djnz hl_shr_b
    ret

error_txt:
    db 0                ;"OK"
    db " O", 80h+'K'

    db 01h              ;"FILES SCRATCHED"
    db 01h,"S SCRATCHE",80h+'D'

    db 16h              ;"READ ERROR"
    db 07h,83h

    db 19h              ;"WRITE ERROR"
    db 02h,83h

    db 1ah              ;"WRITE PROTECTED"
    db 02h," PROTECTE",80h+'D'
    db 1eh,04h

    db 83h              ;"SYNTAX ERROR"
    db 1fh,04h

    db 03h               ;"SYNTAX ERROR (INVALID COMMAND)"
    db " (",05h," ",06h,80h+")"

    db 20h              ;"SYNTAX ERROR (LONG LINE)"
    db 04h,03h," (LONG LINE",80h+")"

    db 21h              ;"SYNTAX ERROR(INVALID FILENAME)"
    db 04h,03h,"(",05h," ",01h,08h,80h+")"

    db 22h              ;"SYNTAX ERROR(NO FILENAME)"
    db 04h,03h,28h,"NO ",01h,08h,80h+")"

    db 32h              ;"RECORD NOT PRESENT"
    db 09h,0bh," PRESEN",80h+"T"

    db 33h              ;"OVERFLOW IN RECORD"
    db "OVERFLOW IN ",89h

    db 34h              ;"FILE TOO LARGE"
    db 01h," TOO LARG",80h+"E"

    db 3ch              ;"WRITE FILE OPEN"
    db 02h," ", 01h,8ah

    db 3dh              ;"FILE NOT OPEN"
    db 01h,0bh,8ah

    db 3eh              ;"FILE NOT FOUND"
    db 01h,0bh," FOUN",80h+"D"

    db 3fh              ;"FILE EXISTS"
    db 01h," EXIST",80h+"S"

    db 40h              ;"FILE TYPE MISMATCH"
    db 01h," TYPE MISMATC",80h+"H"

    db 41h              ;"NO BLOCK"
    db "NO BLOC",80h+"K"

    db 42h              ;"ILLEGAL TRACK OR SECTOR"
    db "ILLEGAL TRACK OR SECTO",80h+"R"

    db 48h              ;"DISK FULL"
    db "DISK FUL",80h+"L"

    db 54h              ;"DRIVE NOT CONFIGURED"
    db 0eh,0bh," CONFIGURE",80h+"D"

    db 59h              ;"USER #"
    db 0ch," ",80h+"#"

    db 5ah              ;"INVALID USER NAME"
    db 05h," ",0ch," ",88h

    db 5bh              ;"PASSWORD INCORRECT"
    db "PASSWORD INCORREC",80h+"T"

    db 5ch              ;"PRIVILEGED COMMAND"
    db "PRIVILEGED ",86h

    db 63h              ;"SMALL SYSTEMS HARDBOX VERSION #"
    db "SMALL SYSTEMS HARDBOX",8dh

    db 0ffh             ;"UNKNOWN ERROR CODE"
    db "UNKNOWN",03h," COD",80h+"E"

    db "FIL",80h+"E"    ;01h: "FILE"
    db "WRIT",80h+"E"   ;02h: "WRITE"
    db " ERRO",80h+"R"  ;03h: " ERROR"
    db "SYNTA",80h+"X"  ;04h: "SYNTAX"
    db "INVALI",80h+"D" ;05h: "INVALID"
    db "COMMAN",80h+"D" ;06h: "COMMAND"
    db "REA",80h+"D"    ;07h: "READ"
    db "NAM",80h+"E"    ;08h: "NAME"
    db "RECOR",80h+"D"  ;09h: "RECORD"
    db " OPE",80h+"N"   ;0ah: " OPEN"
    db " NO",80h+"T"    ;0bh: " NOT"
    db "USE",80h+"R"    ;0ch: "USER"
    db " VERSION ",80h+"#" ;0dh: " VERSION #"
    db "DRIV",80h+"E"   ;0eh: " DRIVE"
    db "CORVU",80h+"S"  ;0fh: "CORVUS"

    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
