; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address cold.com

    org 00100h

    ld bc,00002h        ;0100
    ld de,0fffch        ;0103
    ld hl,0012bh        ;0106
    call 0f06ch         ;0109
    ld de,0080fh        ;010c
    call 0f033h         ;010f
    ld hl,00129h        ;0112
    ld c,002h           ;0115
    call 0f04bh         ;0117
    call 0f048h         ;011a
    call 0f036h         ;011d
    ld hl,(0012bh)      ;0120
    call 0f066h         ;0123
    jp 0f000h           ;0126
    ld d,l              ;0129
    ld c,d              ;012a
