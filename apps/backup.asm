; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels backup.com

args:           equ  0080h  ;Command line arguments passed from CCP
get_ddev:       equ 0f054h  ;BIOS Get device address for a CP/M drive number
ieee_read_err:  equ 0f05ah  ;BIOS Read error channel of an IEEE-488 device
ieee_open:      equ 0f05dh  ;BIOS Open a file on an IEEE-488 device

    org 0100h           ;CP/M TPA

    ld hl,0080h         ;0100
    ld c,(hl)           ;0103
l0104h:
    inc hl              ;0104
    ld a,(hl)           ;0105
    cp ' '              ;0106
    jp nz,l0112h        ;0108
    dec c               ;010b
    jp z,024ah          ;010c
    jp l0104h           ;010f

l0112h:
    dec c               ;0112
    dec c               ;0113
    dec c               ;0114
    jp nz,024ah         ;0115
    and 5fh             ;0118
    sub 41h             ;011a
    jp c,024ah          ;011c
    cp 10h              ;011f
    jp nc,024ah         ;0121
    ld b,a              ;0124
    inc hl              ;0125
    ld a,(hl)           ;0126
    cp 3dh              ;0127
    jp nz,024ah         ;0129
    inc hl              ;012c
    ld a,(hl)           ;012d
    and 5fh             ;012e
    sub 41h             ;0130
    jp c,024ah          ;0132
    cp 10h              ;0135
    jp nc,024ah         ;0137
    cp b                ;013a
    jp z,024ah          ;013b
    xor 01h             ;013e
    cp b                ;0140
    jp nz,l0254h        ;0141
    push af             ;0144
    ld de,l01e3h        ;0145
    ld c,09h            ;0148
    call 0005h          ;014a
    pop af              ;014d
    push af             ;014e
    add a,41h           ;014f
    ld e,a              ;0151
    ld c,02h            ;0152
    call 0005h          ;0154
    ld de,l01f4h        ;0157
    ld c,09h            ;015a
    call 0005h          ;015c
    ld c,01h            ;015f
    call 0005h          ;0161
    cp 0dh              ;0164
    jp nz,l0252h        ;0166
    pop af              ;0169
    push af             ;016a
    call get_ddev       ;016b
    ld e,0fh            ;016e
    pop af              ;0170
    push af             ;0171
    ld hl,l0242h        ;0172
    rra                 ;0175
    jp c,l017ch         ;0176
    ld hl,l0246h        ;0179
l017ch:
    ld c,04h            ;017c
    call ieee_open      ;017e
    pop af              ;0181
    call ieee_read_err  ;0182
    jp nz,l025ch        ;0185
    ld de,l0190h        ;0188
    ld c,09h            ;018b
    jp 0005h            ;018d
l0190h:
    db 0dh,0ah,"Copy complete$"
    db 0dh,0ah,"Syntax error$"
l01afh:
    db 0dh,0ah,"Drives must be on the same unit !$"
l01d3h:
    db 0dh,0ah,"Disk error : $"
l01e3h:
    db 0dh,0ah,"Disk on drive $"
l01f4h:
    db ": will be erased.",0dh,0ah
l0207h:
    db "Press RETURN to continue,",0dh,0ah
    db "Press the SPACE BAR to abort : $"

l0242h:
    db "D1=0"
l0246h:
    ld b,h              ;0246
    jr nc,$+63          ;0247
    ld sp,0a011h        ;0249
    ld bc,090eh         ;024c
    jp 0005h            ;024f
l0252h:
    pop af              ;0252
    ret                 ;0253
l0254h:
    ld de,l01afh        ;0254
    ld c,09h            ;0257
    jp 0005h            ;0259
l025ch:
    ld de,l01d3h        ;025c
    ld c,09h            ;025f
    call 0005h          ;0261
l0264h:
    ld hl,0eac0h        ;0264
l0267h:
    ld a,(hl)           ;0267
    cp 0dh              ;0268
    ret z               ;026a
    push hl             ;026b
    ld e,a              ;026c
    ld c,02h            ;026d
    call 0005h          ;026f
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
