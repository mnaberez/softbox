; z80dasm 1.1.3
; command line: z80dasm --labels --address read.com

    org 0100h

    ld hl,0068h         ;0100 21 68 00
    ld c,15h            ;0103 0e 15
l0105h:
    ld (hl),00h         ;0105 36 00
    inc hl              ;0107 23
    dec c               ;0108 0d
    jp nz,l0105h        ;0109 c2 05 01
    ld de,005dh         ;010c 11 5d 00
    ld a,(de)           ;010f 1a
    cp 20h              ;0110 fe 20
    ret z               ;0112 c8
    ld c,0bh            ;0113 0e 0b
l0115h:
    ld a,(de)           ;0115 1a
    inc de              ;0116 13
    cp 3fh              ;0117 fe 3f
    ret z               ;0119 c8
    dec c               ;011a 0d
    jp nz,l0115h        ;011b c2 15 01
    ld de,005ch         ;011e 11 5c 00
    ld c,13h            ;0121 0e 13
    call 0005h          ;0123 cd 05 00
    ld de,005ch         ;0126 11 5c 00
    ld c,16h            ;0129 0e 16
    call 0005h          ;012b cd 05 00
    inc a               ;012e 3c
    jp z,l0183h         ;012f ca 83 01
    ld de,l01a5h        ;0132 11 a5 01
    ld c,09h            ;0135 0e 09
    call 0005h          ;0137 cd 05 00
l013ah:
    call sub_01f7h      ;013a cd f7 01
    cp 7fh              ;013d fe 7f
    jp nz,l013ah        ;013f c2 3a 01
l0142h:
    call sub_01f7h      ;0142 cd f7 01
    cp 7fh              ;0145 fe 7f
    jp z,l0142h         ;0147 ca 42 01
    di                  ;014a f3
    inc hl              ;014b 23
    jp z,l0196h         ;014c ca 96 01
    cp 3ah              ;014f fe 3a
    jp nz,l018eh        ;0151 c2 8e 01
    ld hl,0080h         ;0154 21 80 00
    ld b,00h            ;0157 06 00
l0159h:
    push hl             ;0159 e5
    push bc             ;015a c5
    call sub_01deh      ;015b cd de 01
    pop bc              ;015e c1
    pop hl              ;015f e1
    ld (hl),a           ;0160 77
    add a,b             ;0161 80
    ld b,a              ;0162 47
    inc l               ;0163 2c
    jp nz,l0159h        ;0164 c2 59 01
    push bc             ;0167 c5
    call sub_01deh      ;0168 cd de 01
    pop bc              ;016b c1
    add a,b             ;016c 80
    jp nz,l018eh        ;016d c2 8e 01
    ld e,2eh            ;0170 1e 2e
    ld c,02h            ;0172 0e 02
    call 0005h          ;0174 cd 05 00
    ld de,005ch         ;0177 11 5c 00
    ld c,15h            ;017a 0e 15
    call 0005h          ;017c cd 05 00
    or a                ;017f b7
    jp z,l0142h         ;0180 ca 42 01
l0183h:
    ld de,l01bah        ;0183 11 ba 01
    ld c,09h            ;0186 0e 09
    call 0005h          ;0188 cd 05 00
    jp l019eh           ;018b c3 9e 01
l018eh:
    ld de,l01cdh        ;018e 11 cd 01
    ld c,09h            ;0191 0e 09
    call 0005h          ;0193 cd 05 00
l0196h:
    ld de,005ch         ;0196 11 5c 00
    ld c,10h            ;0199 0e 10
    call 0005h          ;019b cd 05 00
l019eh:
    ld a,37h            ;019e 3e 37
    out (09h),a         ;01a0 d3 09
    jp 0000h            ;01a2 c3 00 00
l01a5h:
    dec c               ;01a5 0d
    ld a,(bc)           ;01a6 0a
    ld d,d              ;01a7 52
    ld h,l              ;01a8 65
    ld h,c              ;01a9 61
    ld h,h              ;01aa 64
    ld a,c              ;01ab 79
    jr nz,$+118         ;01ac 20 74
    ld l,a              ;01ae 6f
    jr nz,$+116         ;01af 20 72
    ld h,l              ;01b1 65
    ld h,e              ;01b2 63
    ld h,l              ;01b3 65
    ld l,c              ;01b4 69
    halt                ;01b5 76
    ld h,l              ;01b6 65
    dec c               ;01b7 0d
    ld a,(bc)           ;01b8 0a
    inc h               ;01b9 24
l01bah:
    dec c               ;01ba 0d
    ld a,(bc)           ;01bb 0a
    ld b,h              ;01bc 44
    ld l,c              ;01bd 69
    ld (hl),e           ;01be 73
    ld l,e              ;01bf 6b
    jr nz,$+121         ;01c0 20 77
    ld (hl),d           ;01c2 72
    ld l,c              ;01c3 69
    ld (hl),h           ;01c4 74
    ld h,l              ;01c5 65
    jr nz,$+103         ;01c6 20 65
    ld (hl),d           ;01c8 72
    ld (hl),d           ;01c9 72
    ld l,a              ;01ca 6f
    ld (hl),d           ;01cb 72
    inc h               ;01cc 24
l01cdh:
    dec c               ;01cd 0d
    ld a,(bc)           ;01ce 0a
    ld b,e              ;01cf 43
    ld l,b              ;01d0 68
    ld h,l              ;01d1 65
    ld h,e              ;01d2 63
    ld l,e              ;01d3 6b
    ld (hl),e           ;01d4 73
    ld (hl),l           ;01d5 75
    ld l,l              ;01d6 6d
    jr nz,$+103         ;01d7 20 65
    ld (hl),d           ;01d9 72
    ld (hl),d           ;01da 72
    ld l,a              ;01db 6f
    ld (hl),d           ;01dc 72
    inc h               ;01dd 24
sub_01deh:
    call sub_01ech      ;01de cd ec 01
    add a,a             ;01e1 87
    add a,a             ;01e2 87
    add a,a             ;01e3 87
    add a,a             ;01e4 87
    push af             ;01e5 f5
    call sub_01ech      ;01e6 cd ec 01
    pop bc              ;01e9 c1
    add a,b             ;01ea 80
    ret                 ;01eb c9
sub_01ech:
    call sub_01f7h      ;01ec cd f7 01
    sub 30h             ;01ef d6 30
    cp 0ah              ;01f1 fe 0a
    ret c               ;01f3 d8
    sub 07h             ;01f4 d6 07
    ret                 ;01f6 c9
sub_01f7h:
    call 0f006h         ;01f7 cd 06 f0
    or a                ;01fa b7
    jp z,l0206h         ;01fb ca 06 02
    call 0f009h         ;01fe cd 09 f0
    cp 03h              ;0201 fe 03
    jp z,l0196h         ;0203 ca 96 01
l0206h:
    ld a,37h            ;0206 3e 37
    out (09h),a         ;0208 d3 09
l020ah:
    in a,(09h)          ;020a db 09
    and 02h             ;020c e6 02
    jp z,l020ah         ;020e ca 0a 02
    ld a,17h            ;0211 3e 17
    out (09h),a         ;0213 d3 09
    in a,(08h)          ;0215 db 08
    and 7fh             ;0217 e6 7f
    ret                 ;0219 c9
