; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels time.com

    org 0100h

    ld hl,0080h         ;0100
    ld c,(hl)           ;0103
    call sub_0168h      ;0104
    jp nc,l0135h        ;0107
    ld de,l01b3h        ;010a
    ld c,09h            ;010d
    call 0005h          ;010f
    call 0f072h         ;0112
    ld a,h              ;0115
    call sub_0197h      ;0116
    push hl             ;0119
    push de             ;011a
    ld e,3ah            ;011b
    ld c,02h            ;011d
    call 0005h          ;011f
    pop de              ;0122
    pop hl              ;0123
    ld a,l              ;0124
    call sub_0197h      ;0125
    push de             ;0128
    ld e,3ah            ;0129
    ld c,02h            ;012b
    call 0005h          ;012d
    pop hl              ;0130
    ld a,d              ;0131
    jp sub_0197h        ;0132
l0135h:
    ld d,a              ;0135
    call sub_0168h      ;0136
    jp c,l015dh         ;0139
    ld e,a              ;013c
    push de             ;013d
    call sub_0168h      ;013e
    jp c,l015dh         ;0141
    ld d,a              ;0144
    push de             ;0145
    ld de,l01bdh        ;0146
    ld c,09h            ;0149
    call 0005h          ;014b
    ld c,01h            ;014e
    call 0005h          ;0150
    cp 03h              ;0153
    jp z,0000h          ;0155
    pop de              ;0158
    pop hl              ;0159
    jp 0f06fh           ;015a
l015dh:
    ld de,l01dbh        ;015d
    ld c,09h            ;0160
    call 0005h          ;0162
    jp 0000h            ;0165
sub_0168h:
    inc hl              ;0168
    ld a,(hl)           ;0169
    dec c               ;016a
    scf                 ;016b
    ret m               ;016c
    sub 30h             ;016d
    jp c,sub_0168h      ;016f
    cp 0ah              ;0172
    jp nc,sub_0168h     ;0174
    ld b,a              ;0177
    inc hl              ;0178
    dec c               ;0179
    jp m,l0192h         ;017a
    ld a,(hl)           ;017d
    sub 30h             ;017e
    jp c,l0192h         ;0180
    cp 0ah              ;0183
    jp nc,l0192h        ;0185
    push af             ;0188
    ld a,b              ;0189
    add a,a             ;018a
    add a,a             ;018b
    add a,b             ;018c
    add a,a             ;018d
    ld b,a              ;018e
    pop af              ;018f
    add a,b             ;0190
    ret                 ;0191
l0192h:
    ld a,b              ;0192
    dec hl              ;0193
    inc c               ;0194
    or a                ;0195
    ret                 ;0196
sub_0197h:
    push de             ;0197
    push hl             ;0198
    ld e,2fh            ;0199
l019bh:
    inc e               ;019b
    sub 0ah             ;019c
    jp p,l019bh         ;019e
    add a,3ah           ;01a1
    push af             ;01a3
    ld c,02h            ;01a4
    call 0005h          ;01a6
    pop af              ;01a9
    ld e,a              ;01aa
    ld c,02h            ;01ab
    call 0005h          ;01ad
    pop hl              ;01b0
    pop de              ;01b1
    ret                 ;01b2

l01b3h:
    db "Time is  $"
l01bdh:
    db "Hit any key to start clock : $"
l01dbh:
    db "Syntax error$"

    add hl,bc           ;01e8
    ld c,(hl)           ;01e9
    call 0786h          ;01ea
    ld hl,1d84h         ;01ed
    inc (hl)            ;01f0
    jp nz,08cch         ;01f1
    ld hl,1cdeh         ;01f4
    ld (hl),00h         ;01f7
    ld bc,014ah         ;01f9
    nop                 ;01fc
    call nz,1ce5h       ;01fd
