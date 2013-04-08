; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels backup.com

    org 00100h

    ld hl,00080h        ;0100
    ld c,(hl)           ;0103
l0104h:
    inc hl              ;0104
    ld a,(hl)           ;0105
    cp 020h             ;0106
    jp nz,l0112h        ;0108
    dec c               ;010b
    jp z,0024ah         ;010c
    jp l0104h           ;010f
l0112h:
    dec c               ;0112
    dec c               ;0113
    dec c               ;0114
    jp nz,0024ah        ;0115
    and 05fh            ;0118
    sub 041h            ;011a
    jp c,0024ah         ;011c
    cp 010h             ;011f
    jp nc,0024ah        ;0121
    ld b,a              ;0124
    inc hl              ;0125
    ld a,(hl)           ;0126
    cp 03dh             ;0127
    jp nz,0024ah        ;0129
    inc hl              ;012c
    ld a,(hl)           ;012d
    and 05fh            ;012e
    sub 041h            ;0130
    jp c,0024ah         ;0132
    cp 010h             ;0135
    jp nc,0024ah        ;0137
    cp b                ;013a
    jp z,0024ah         ;013b
    xor 001h            ;013e
    cp b                ;0140
    jp nz,l0254h        ;0141
    push af             ;0144
    ld de,l01e3h        ;0145
    ld c,009h           ;0148
    call 00005h         ;014a
    pop af              ;014d
    push af             ;014e
    add a,041h          ;014f
    ld e,a              ;0151
    ld c,002h           ;0152
    call 00005h         ;0154
    ld de,l01f4h        ;0157
    ld c,009h           ;015a
    call 00005h         ;015c
    ld c,001h           ;015f
    call 00005h         ;0161
    cp 00dh             ;0164
    jp nz,l0252h        ;0166
    pop af              ;0169
    push af             ;016a
    call 0f054h         ;016b
    ld e,00fh           ;016e
    pop af              ;0170
    push af             ;0171
    ld hl,l0242h        ;0172
    rra                 ;0175
    jp c,l017ch         ;0176
    ld hl,l0246h        ;0179
l017ch:
    ld c,004h           ;017c
    call 0f05dh         ;017e
    pop af              ;0181
    call 0f05ah         ;0182
    jp nz,l025ch        ;0185
    ld de,l0190h        ;0188
    ld c,009h           ;018b
    jp 00005h           ;018d
l0190h:
    dec c               ;0190
    ld a,(bc)           ;0191
    ld b,e              ;0192
    ld l,a              ;0193
    ld (hl),b           ;0194
    ld a,c              ;0195
    jr nz,$+101         ;0196
    ld l,a              ;0198
    ld l,l              ;0199
    ld (hl),b           ;019a
    ld l,h              ;019b
    ld h,l              ;019c
    ld (hl),h           ;019d
    ld h,l              ;019e
    inc h               ;019f
    dec c               ;01a0
    ld a,(bc)           ;01a1
    ld d,e              ;01a2
    ld a,c              ;01a3
    ld l,(hl)           ;01a4
    ld (hl),h           ;01a5
    ld h,c              ;01a6
    ld a,b              ;01a7
    jr nz,l020fh        ;01a8
    ld (hl),d           ;01aa
    ld (hl),d           ;01ab
    ld l,a              ;01ac
    ld (hl),d           ;01ad
    inc h               ;01ae
l01afh:
    dec c               ;01af
    ld a,(bc)           ;01b0
    ld b,h              ;01b1
    ld (hl),d           ;01b2
    ld l,c              ;01b3
    halt                ;01b4
    ld h,l              ;01b5
    ld (hl),e           ;01b6
    jr nz,l0226h        ;01b7
    ld (hl),l           ;01b9
    ld (hl),e           ;01ba
    ld (hl),h           ;01bb
    jr nz,l0220h        ;01bc
    ld h,l              ;01be
    jr nz,l0230h        ;01bf
    ld l,(hl)           ;01c1
    jr nz,l0238h        ;01c2
    ld l,b              ;01c4
    ld h,l              ;01c5
    jr nz,l023bh        ;01c6
    ld h,c              ;01c8
    ld l,l              ;01c9
    ld h,l              ;01ca
    jr nz,l0242h        ;01cb
    ld l,(hl)           ;01cd
    ld l,c              ;01ce
    ld (hl),h           ;01cf
    jr nz,$+35          ;01d0
    inc h               ;01d2
l01d3h:
    dec c               ;01d3
    ld a,(bc)           ;01d4
    ld b,h              ;01d5
    ld l,c              ;01d6
    ld (hl),e           ;01d7
    ld l,e              ;01d8
    jr nz,l0240h        ;01d9
    ld (hl),d           ;01db
    ld (hl),d           ;01dc
    ld l,a              ;01dd
    ld (hl),d           ;01de
    jr nz,l021bh        ;01df
    jr nz,l0207h        ;01e1
l01e3h:
    dec c               ;01e3
    ld a,(bc)           ;01e4
    ld b,h              ;01e5
    ld l,c              ;01e6
    ld (hl),e           ;01e7
    ld l,e              ;01e8
    jr nz,$+113         ;01e9
    ld l,(hl)           ;01eb
    jr nz,l0252h        ;01ec
    ld (hl),d           ;01ee
    ld l,c              ;01ef
    halt                ;01f0
    ld h,l              ;01f1
    jr nz,l0218h        ;01f2
l01f4h:
    ld a,(07720h)       ;01f4
    ld l,c              ;01f7
    ld l,h              ;01f8
    ld l,h              ;01f9
    jr nz,$+100         ;01fa
    ld h,l              ;01fc
    jr nz,l0264h        ;01fd
    ld (hl),d           ;01ff
    ld h,c              ;0200
    ld (hl),e           ;0201
    ld h,l              ;0202
    ld h,h              ;0203
    ld l,00dh           ;0204
    ld a,(bc)           ;0206
l0207h:
    ld d,b              ;0207
    ld (hl),d           ;0208
    ld h,l              ;0209
    ld (hl),e           ;020a
    ld (hl),e           ;020b
    jr nz,$+84          ;020c
    ld b,l              ;020e
l020fh:
    ld d,h              ;020f
    ld d,l              ;0210
    ld d,d              ;0211
    ld c,(hl)           ;0212
    jr nz,$+118         ;0213
    ld l,a              ;0215
    jr nz,l027bh        ;0216
l0218h:
    ld l,a              ;0218
    ld l,(hl)           ;0219
    ld (hl),h           ;021a
l021bh:
    ld l,c              ;021b
    ld l,(hl)           ;021c
    ld (hl),l           ;021d
    ld h,l              ;021e
    inc l               ;021f
l0220h:
    dec c               ;0220
    ld a,(bc)           ;0221
    ld d,b              ;0222
    ld (hl),d           ;0223
    ld h,l              ;0224
    ld (hl),e           ;0225
l0226h:
    ld (hl),e           ;0226
    jr nz,$+118         ;0227
    ld l,b              ;0229
    ld h,l              ;022a
    jr nz,$+85          ;022b
    ld d,b              ;022d
    ld b,c              ;022e
    ld b,e              ;022f
l0230h:
    ld b,l              ;0230
    jr nz,$+68          ;0231
    ld b,c              ;0233
    ld d,d              ;0234
    jr nz,$+118         ;0235
    ld l,a              ;0237
l0238h:
    jr nz,$+99          ;0238
    ld h,d              ;023a
l023bh:
    ld l,a              ;023b
    ld (hl),d           ;023c
    ld (hl),h           ;023d
    jr nz,l027ah        ;023e
l0240h:
    jr nz,$+38          ;0240
l0242h:
    ld b,h              ;0242
    ld sp,0303dh        ;0243
l0246h:
    ld b,h              ;0246
    jr nc,$+63          ;0247
    ld sp,0a011h        ;0249
    ld bc,0090eh        ;024c
    jp 00005h           ;024f
l0252h:
    pop af              ;0252
    ret                 ;0253
l0254h:
    ld de,l01afh        ;0254
    ld c,009h           ;0257
    jp 00005h           ;0259
l025ch:
    ld de,l01d3h        ;025c
    ld c,009h           ;025f
    call 00005h         ;0261
l0264h:
    ld hl,0eac0h        ;0264
l0267h:
    ld a,(hl)           ;0267
    cp 00dh             ;0268
    ret z               ;026a
    push hl             ;026b
    ld e,a              ;026c
    ld c,002h           ;026d
    call 00005h         ;026f
    pop hl              ;0272
    inc hl              ;0273
    jp l0267h           ;0274
    nop                 ;0277
    nop                 ;0278
    nop                 ;0279
l027ah:
    nop                 ;027a
l027bh:
    nop                 ;027b
    nop                 ;027c
    nop                 ;027d
    nop                 ;027e
    nop                 ;027f
