; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels backup.com

args:           equ  0080h  ;Command line arguments passed from CCP
dos_msg:        equ 0eac0h    ;Last error message returned from CBM DOS
get_ddev:       equ 0f054h  ;BIOS Get device address for a CP/M drive number
ieee_read_err:  equ 0f05ah  ;BIOS Read error channel of an IEEE-488 device
ieee_open:      equ 0f05dh  ;BIOS Open a file on an IEEE-488 device

    org 0100h           ;CP/M TPA

    ld hl,args          ;0100
    ld c,(hl)           ;0103
l0104h:
    inc hl              ;0104
    ld a,(hl)           ;0105
    cp ' '              ;0106
    jp nz,l0112h        ;0108
    dec c               ;010b
    jp z,bad_syntax     ;010c
    jp l0104h           ;010f

l0112h:
    dec c               ;0112
    dec c               ;0113
    dec c               ;0114
    jp nz,bad_syntax    ;0115
    and 5fh             ;0118
    sub 41h             ;011a
    jp c,bad_syntax     ;011c
    cp 10h              ;011f
    jp nc,bad_syntax    ;0121
    ld b,a              ;0124
    inc hl              ;0125
    ld a,(hl)           ;0126
    cp 3dh              ;0127
    jp nz,bad_syntax    ;0129
    inc hl              ;012c
    ld a,(hl)           ;012d
    and 5fh             ;012e
    sub 41h             ;0130
    jp c,bad_syntax     ;0132
    cp 10h              ;0135
    jp nc,bad_syntax    ;0137
    cp b                ;013a
    jp z,bad_syntax     ;013b
    xor 01h             ;013e
    cp b                ;0140
    jp nz,l0254h        ;0141
    push af             ;0144
    ld de,disk_on_drive ;0145
    ld c,09h            ;0148
    call 0005h          ;014a
    pop af              ;014d
    push af             ;014e
    add a,41h           ;014f
    ld e,a              ;0151
    ld c,02h            ;0152
    call 0005h          ;0154
    ld de,will_be_erasd ;0157
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
    ld hl,dos_d1_to_d0  ;0172
    rra                 ;0175
    jp c,l017ch         ;0176
    ld hl,dos_d0_to_d1  ;0179
l017ch:
    ld c,04h            ;017c
    call ieee_open      ;017e
    pop af              ;0181
    call ieee_read_err  ;0182
    jp nz,l025ch        ;0185
    ld de,copy_complete ;0188
    ld c,09h            ;018b
    jp 0005h            ;018d

copy_complete:
    db 0dh,0ah,"Copy complete$"
syntax_err:
    db 0dh,0ah,"Syntax error$"
not_same_unit:
    db 0dh,0ah,"Drives must be on the same unit !$"
disk_error:
    db 0dh,0ah,"Disk error : $"
disk_on_drive:
    db 0dh,0ah,"Disk on drive $"
will_be_erasd:
    db ": will be erased.",0dh,0ah
    db "Press RETURN to continue,",0dh,0ah
    db "Press the SPACE BAR to abort : $"

dos_d1_to_d0:
    db "D1=0"
dos_d0_to_d1:
    db "D0=1"

bad_syntax:
    ld de,syntax_err    ;024a
    ld c,09h            ;024d
    jp 0005h            ;024f

l0252h:
    pop af              ;0252
    ret                 ;0253

l0254h:
    ld de,not_same_unit ;0254
    ld c,09h            ;0257
    jp 0005h            ;0259

l025ch:
    ld de,disk_error    ;025c
    ld c,09h            ;025f
    call 0005h          ;0261
    ld hl,dos_msg       ;0264
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
    nop                 ;027a
    nop                 ;027b
    nop                 ;027c
    nop                 ;027d
    nop                 ;027e
    nop                 ;027f
