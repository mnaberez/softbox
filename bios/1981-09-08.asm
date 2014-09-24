; z80dasm 1.1.3
; command line: z80dasm --labels --source --origin=61440 1981-09-08.bin
ctrl_c:   equ 03h       ;Control-C
bell:     equ 07h       ;Bell
lf:       equ 0ah       ;Line Feed
cr:       equ 0dh       ;Carriage Return
ucase:    equ 15h       ;Uppercase Mode
cls:      equ 1ah       ;Clear Screen
esc:      equ 1bh       ;Escape

ifc:      equ 10000000b ;IFC
ren:      equ 01000000b ;REN
srq:      equ 00100000b ;SRQ
eoi:      equ 00010000b ;EOI
nrfd:     equ 00001000b ;NRFD
ndac:     equ 00000100b ;NDAC
dav:      equ 00000010b ;DAV
atn:      equ 00000001b ;ATN

dirc:     equ 00100000b ;Corvus DIRC
ready:    equ 00010000b ;Corvus READY
ledrdy:   equ 00000100b ;LED "Ready"
ledb:     equ 00000010b ;LED "B"
leda:     equ 00000001b ;LED "A"

    org 0f000h

    jp boot             ;f000 c3 a5 f3   c3 a5 f3    . . .
    jp wboot            ;f003 c3 c8 f0   c3 c8 f0    . . .
    jp const            ;f006 c3 15 fb   c3 15 fb    . . .
    jp conin            ;f009 c3 f7 fa   c3 f7 fa    . . .
    jp conout           ;f00c c3 27 fb   c3 27 fb    . ' .
    jp list             ;f00f c3 07 fc   c3 07 fc    . . .
    jp punch            ;f012 c3 bf fc   c3 bf fc    . . .
    jp reader           ;f015 c3 d7 fc   c3 d7 fc    . . .
    jp home             ;f018 c3 5a f1   c3 5a f1    . Z .
    jp seldsk           ;f01b c3 6c f1   c3 6c f1    . l .
    jp settrk           ;f01e c3 5d f1   c3 5d f1    . ] .
    jp setsec           ;f021 c3 62 f1   c3 62 f1    . b .
    jp setdma           ;f024 c3 67 f1   c3 67 f1    . g .
    jp read             ;f027 c3 20 f2   c3 20 f2    .   .
    jp write            ;f02a c3 3d f2   c3 3d f2    . = .
    jp listst           ;f02d c3 77 fc   c3 77 fc    . w .
    jp sectran          ;f030 c3 f5 f1   c3 f5 f1    . . .

    jp listen           ;f033 c3 90 fa   c3 90 fa    . . .
    jp unlisten         ;f036 c3 a6 fa   c3 a6 fa    . . .
    jp talk             ;f039 c3 5d fa   c3 5d fa    . ] .
    jp untalk           ;f03c c3 80 fa   c3 80 fa    . . .
    jp rdieee           ;f03f c3 1c fe   c3 1c fe    . . .
    jp wrieee           ;f042 c3 a6 fd   c3 a6 fd    . . .
    jp wreoi            ;f045 c3 4f fe   c3 4f fe    . O .
    jp creoi            ;f048 c3 4d fe   c3 4d fe    . M .
    jp ieeemsg          ;f04b c3 63 fe   c3 63 fe    . c .
    jp ieeenum          ;f04e c3 07 f9   c3 07 f9    . . .
    jp tstdrv           ;f051 c3 f8 f1   c3 f8 f1    . . .
    jp dskdev           ;f054 c3 11 fa   c3 11 fa    . . .
    jp diskcmd          ;f057 c3 20 fa   c3 20 fa    .   .
    jp disksta          ;f05a c3 20 f9   c3 20 f9    .   .
    jp open             ;f05d c3 b5 fa   c3 b5 fa    . . .
    jp close            ;f060 c3 d1 fa   c3 d1 fa    . . .
    jp clear            ;f063 c3 fd fc   c3 fd fc    . . .
    jp execute          ;f066 c3 07 fd   c3 07 fd    . . .
    jp poke             ;f069 c3 40 fd   c3 40 fd    . @ .
    jp peek             ;f06c c3 14 fd   c3 14 fd    . . .
    jp settime          ;f06f c3 60 fd   c3 60 fd    . ` .
    jp gettime          ;f072 c3 8b fd   c3 8b fd    . . .
    jp runcpm           ;f075 c3 68 f4   c3 68 f4    . h .
    jp idrive           ;f078 c3 28 fa   c3 28 fa    . ( .
    jp wratn            ;f07b c3 a8 fa   c3 a8 fa    . . .
    jp rdimm            ;f07e c3 05 fe   c3 05 fe    . . .
    jp resclk           ;f081 c3 75 fd   c3 75 fd    . u .
    jp delay            ;f084 c3 e5 fa   c3 e5 fa    . . .

signon:
;    db cr,lf,"60K SoftBox CP/M vers. 2.2"
    db cr,lf,"60K PET CP/M vers. 2.2"
    db cr,lf,"(c) 1981 Keith Frewin"
    db cr,lf,"Revision 8/9/81"
    db 00h

wboot:
    ld c,16h            ;f0c8 0e 16   0e 16   . .
    ld sp,0100h         ;f0ca 31 00 01   31 00 01    1 . .
    ld a,(0ea70h)       ;f0cd 3a 70 ea   3a 70 ea    : p .
    call tstdrv_corv    ;f0d0 cd 19 f2   cd 19 f2    . . .
    jr c,wboot_corvus   ;f0d3 38 09   38 09   8 .

wboot_ieee:
    xor a               ;f0d5 af   af  .
    call dskdev         ;f0d6 cd 11 fa   cd 11 fa    . . .
    call sub_f52eh      ;f0d9 cd 2e f5   cd 2e f5    . . .
    jr lf0e3h           ;f0dc 18 05   18 05   . .

wboot_corvus:
    ld b,2ch            ;f0de 06 2c   06 2c   . ,
    call sub_f0f4h      ;f0e0 cd f4 f0   cd f4 f0    . . .
lf0e3h:
    ld a,(0ea40h)       ;f0e3 3a 40 ea   3a 40 ea    : @ .
    ld (0d8b2h),a       ;f0e6 32 b2 d8   32 b2 d8    2 . .
    ld hl,0d403h        ;f0e9 21 03 d4   21 03 d4    ! . .
    jr z,lf11eh         ;f0ec 28 30   28 30   ( 0
    xor a               ;f0ee af   af  .
    call idrive         ;f0ef cd 28 fa   cd 28 fa    . ( .
    jr wboot            ;f0f2 18 d4   18 d4   . .
sub_f0f4h:
    push bc             ;f0f4 c5   c5  .
    ld hl,0000h         ;f0f5 21 00 00   21 00 00    ! . .
lf0f8h:
    ld (0041h),hl       ;f0f8 22 41 00   22 41 00    " A .
    xor a               ;f0fb af   af  .
    ld (0043h),a        ;f0fc 32 43 00   32 43 00    2 C .
    ld c,a              ;f0ff 4f   4f  O
    call seldsk         ;f100 cd 6c f1   cd 6c f1    . l .
    pop bc              ;f103 c1   c1  .
    ld hl,0d400h        ;f104 21 00 d4   21 00 d4    ! . .
lf107h:
    ld (0052h),hl       ;f107 22 52 00   22 52 00    " R .
    push hl             ;f10a e5   e5  .
    push bc             ;f10b c5   c5  .
    call read           ;f10c cd 20 f2   cd 20 f2    .   .
    ld hl,0043h         ;f10f 21 43 00   21 43 00    ! C .
    inc (hl)            ;f112 34   34  4
    pop bc              ;f113 c1   c1  .
    pop hl              ;f114 e1   e1  .
    or a                ;f115 b7   b7  .
    ret nz              ;f116 c0   c0  .
    ld de,0080h         ;f117 11 80 00   11 80 00    . . .
    add hl,de           ;f11a 19   19  .
    djnz lf107h         ;f11b 10 ea   10 ea   . .
    ret                 ;f11d c9   c9  .
lf11eh:
    push hl             ;f11e e5   e5  .
    ld bc,0080h         ;f11f 01 80 00   01 80 00    . . .
    call setdma         ;f122 cd 67 f1   cd 67 f1    . g .
    ld a,0c3h           ;f125 3e c3   3e c3   > .
    ld (0000h),a        ;f127 32 00 00   32 00 00    2 . .
    ld hl,0ea03h        ;f12a 21 03 ea   21 03 ea    ! . .
    ld (0001h),hl       ;f12d 22 01 00   22 01 00    " . .
    ld (0005h),a        ;f130 32 05 00   32 05 00    2 . .
    ld hl,0dc06h        ;f133 21 06 dc   21 06 dc    ! . .
    ld (0006h),hl       ;f136 22 06 00   22 06 00    " . .
    ld hl,0004h         ;f139 21 04 00   21 04 00    ! . .
    ld a,(hl)           ;f13c 7e   7e  ~
    and 0fh             ;f13d e6 0f   e6 0f   . .
    call tstdrv         ;f13f cd f8 f1   cd f8 f1    . . .
    jr c,lf146h         ;f142 38 02   38 02   8 .
    ld (hl),00h         ;f144 36 00   36 00   6 .
lf146h:
    ld c,(hl)           ;f146 4e   4e  N
    xor a               ;f147 af   af  .
    ld (0057h),a        ;f148 32 57 00   32 57 00    2 W .
    ld (0058h),a        ;f14b 32 58 00   32 58 00    2 X .
    ld (0048h),a        ;f14e 32 48 00   32 48 00    2 H .
    ld (004ch),a        ;f151 32 4c 00   32 4c 00    2 L .
    dec a               ;f154 3d   3d  =
    ld (0045h),a        ;f155 32 45 00   32 45 00    2 E .
    pop hl              ;f158 e1   e1  .
    jp (hl)             ;f159 e9   e9  .
home:
    ld bc,0000h         ;f15a 01 00 00   01 00 00    . . .
settrk:
    ld (0041h),bc       ;f15d ed 43 41 00   ed 43 41 00     . C A .
    ret                 ;f161 c9   c9  .
setsec:
    ld a,c              ;f162 79   79  y
    ld (0043h),a        ;f163 32 43 00   32 43 00    2 C .
    ret                 ;f166 c9   c9  .
setdma:
    ld (0052h),bc       ;f167 ed 43 52 00   ed 43 52 00     . C R .
    ret                 ;f16b c9   c9  .
seldsk:
    ld a,c              ;f16c 79   79  y
    call tstdrv         ;f16d cd f8 f1   cd f8 f1    . . .
    ld hl,0000h         ;f170 21 00 00   21 00 00    ! . .
    ret nc              ;f173 d0   d0  .
    ld (0040h),a        ;f174 32 40 00   32 40 00    2 @ .
    ld l,a              ;f177 6f   6f  o
    add hl,hl           ;f178 29   29  )
    add hl,hl           ;f179 29   29  )
    add hl,hl           ;f17a 29   29  )
    add hl,hl           ;f17b 29   29  )
    ld de,0eb00h        ;f17c 11 00 eb   11 00 eb    . . .
    add hl,de           ;f17f 19   19  .
    push hl             ;f180 e5   e5  .
    ld a,c              ;f181 79   79  y
    ld (0044h),a        ;f182 32 44 00   32 44 00    2 D .
    ld l,c              ;f185 69   69  i
    ld h,00h            ;f186 26 00   26 00   & .
    add hl,hl           ;f188 29   29  )
    add hl,hl           ;f189 29   29  )
    add hl,hl           ;f18a 29   29  )
    add hl,hl           ;f18b 29   29  )
    ld bc,lf1a5h        ;f18c 01 a5 f1   01 a5 f1    . . .
    add hl,bc           ;f18f 09   09  .
    ex de,hl            ;f190 eb   eb  .
    pop hl              ;f191 e1   e1  .
    push hl             ;f192 e5   e5  .
    ld bc,000ah         ;f193 01 0a 00   01 0a 00    . . .
    add hl,bc           ;f196 09   09  .
    ld (hl),e           ;f197 73   73  s
    inc hl              ;f198 23   23  #
    ld (hl),d           ;f199 72   72  r
    ld a,(0044h)        ;f19a 3a 44 00   3a 44 00    : D .
    call tstdrv_corv    ;f19d cd 19 f2   cd 19 f2    . . .
    call c,sub_f2c4h    ;f1a0 dc c4 f2   dc c4 f2    . . .
    pop hl              ;f1a3 e1   e1  .
    ret                 ;f1a4 c9   c9  .
lf1a5h:
    jr nz,lf1a7h        ;f1a5 20 00   20 00     .
lf1a7h:
    inc b               ;f1a7 04   04  .
    rrca                ;f1a8 0f   0f  .
    ld bc,004ch         ;f1a9 01 4c 00   01 4c 00    . L .
    ccf                 ;f1ac 3f   3f  ?
    nop                 ;f1ad 00   00  .
    add a,b             ;f1ae 80   80  .
    nop                 ;f1af 00   00  .
    djnz lf1b2h         ;f1b0 10 00   10 00   . .
lf1b2h:
    nop                 ;f1b2 00   00  .
    nop                 ;f1b3 00   00  .
    nop                 ;f1b4 00   00  .
    jr nz,lf1b7h        ;f1b5 20 00   20 00     .
lf1b7h:
    inc b               ;f1b7 04   04  .
    rrca                ;f1b8 0f   0f  .
    ld bc,00f8h         ;f1b9 01 f8 00   01 f8 00    . . .
    ccf                 ;f1bc 3f   3f  ?
    nop                 ;f1bd 00   00  .
    add a,b             ;f1be 80   80  .
    nop                 ;f1bf 00   00  .
    djnz lf1c2h         ;f1c0 10 00   10 00   . .
lf1c2h:
    nop                 ;f1c2 00   00  .
    nop                 ;f1c3 00   00  .
    nop                 ;f1c4 00   00  .
    ld b,b              ;f1c5 40   40  @
    nop                 ;f1c6 00   00  .
    ld b,3fh            ;f1c7 06 3f   06 3f   . ?
    inc bc              ;f1c9 03   03  .
    ld c,h              ;f1ca 4c   4c  L
    ld (bc),a           ;f1cb 02   02  .
    rst 38h             ;f1cc ff   ff  .
    nop                 ;f1cd 00   00  .
    add a,b             ;f1ce 80   80  .
    nop                 ;f1cf 00   00  .
    nop                 ;f1d0 00   00  .
    nop                 ;f1d1 00   00  .
    ld (bc),a           ;f1d2 02   02  .
    nop                 ;f1d3 00   00  .
    nop                 ;f1d4 00   00  .
    ld b,b              ;f1d5 40   40  @
    nop                 ;f1d6 00   00  .
    ld b,3fh            ;f1d7 06 3f   06 3f   . ?
    inc bc              ;f1d9 03   03  .
    ld c,h              ;f1da 4c   4c  L
    ld (bc),a           ;f1db 02   02  .
    rst 38h             ;f1dc ff   ff  .
    nop                 ;f1dd 00   00  .
    add a,b             ;f1de 80   80  .
    nop                 ;f1df 00   00  .
    nop                 ;f1e0 00   00  .
    nop                 ;f1e1 00   00  .
    ld (bc),a           ;f1e2 02   02  .
    nop                 ;f1e3 00   00  .
    nop                 ;f1e4 00   00  .
    ld b,b              ;f1e5 40   40  @
    nop                 ;f1e6 00   00  .
    ld b,3fh            ;f1e7 06 3f   06 3f   . ?
    inc bc              ;f1e9 03   03  .
    cp b                ;f1ea b8   b8  .
    ld (bc),a           ;f1eb 02   02  .
    rst 38h             ;f1ec ff   ff  .
    nop                 ;f1ed 00   00  .
    add a,b             ;f1ee 80   80  .
    nop                 ;f1ef 00   00  .
    nop                 ;f1f0 00   00  .
    nop                 ;f1f1 00   00  .
    ld (bc),a           ;f1f2 02   02  .
    nop                 ;f1f3 00   00  .
    nop                 ;f1f4 00   00  .
sectran:
    ld l,c              ;f1f5 69   69  i
    ld h,b              ;f1f6 60   60  `
    ret                 ;f1f7 c9   c9  .
tstdrv:
    cp 10h              ;f1f8 fe 10   fe 10   . .
    ret nc              ;f1fa d0   d0  .
    push hl             ;f1fb e5   e5  .
    push af             ;f1fc f5   f5  .
    or a                ;f1fd b7   b7  .
    rra                 ;f1fe 1f   1f  .
    ld c,a              ;f1ff 4f   4f  O
    ld b,00h            ;f200 06 00   06 00   . .
    ld hl,0ea70h        ;f202 21 70 ea   21 70 ea    ! p .
    add hl,bc           ;f205 09   09  .
    ld c,(hl)           ;f206 4e   4e  N
    ld a,c              ;f207 79   79  y
    cp 04h              ;f208 fe 04   fe 04   . .
    pop hl              ;f20a e1   e1  .
    ld a,h              ;f20b 7c   7c  |
    jr nz,lf212h        ;f20c 20 04   20 04     .
    bit 0,a             ;f20e cb 47   cb 47   . G
    jr lf214h           ;f210 18 02   18 02   . .
lf212h:
    bit 7,c             ;f212 cb 79   cb 79   . y
lf214h:
    pop hl              ;f214 e1   e1  .
    scf                 ;f215 37   37  7
    ret z               ;f216 c8   c8  .
    or a                ;f217 b7   b7  .
    ret                 ;f218 c9   c9  .
tstdrv_corv:
    cp 06h              ;f219 fe 06   fe 06   . .
    ret nc              ;f21b d0   d0  .
    cp 02h              ;f21c fe 02   fe 02   . .
    ccf                 ;f21e 3f   3f  ?
    ret                 ;f21f c9   c9  .
read:
    ld a,(0044h)        ;f220 3a 44 00   3a 44 00    : D .
    call tstdrv_corv    ;f223 cd 19 f2   cd 19 f2    . . .
    jp c,lf2d5h         ;f226 da d5 f2   da d5 f2    . . .
    call sub_f586h      ;f229 cd 86 f5   cd 86 f5    . . .
    ld a,01h            ;f22c 3e 01   3e 01   > .
    call nz,sub_f29dh   ;f22e c4 9d f2   c4 9d f2    . . .
    ld a,(0043h)        ;f231 3a 43 00   3a 43 00    : C .
    rrca                ;f234 0f   0f  .
    call sub_f2aah      ;f235 cd aa f2   cd aa f2    . . .
    xor a               ;f238 af   af  .
    ld (0048h),a        ;f239 32 48 00   32 48 00    2 H .
    ret                 ;f23c c9   c9  .
write:
    ld a,(0044h)        ;f23d 3a 44 00   3a 44 00    : D .
    call tstdrv_corv    ;f240 cd 19 f2   cd 19 f2    . . .
    jp c,lf2f2h         ;f243 da f2 f2   da f2 f2    . . .
    ld a,c              ;f246 79   79  y
    push af             ;f247 f5   f5  .
    cp 02h              ;f248 fe 02   fe 02   . .
    call z,0f56eh       ;f24a cc 6e f5   cc 6e f5    . n .
    ld hl,0048h         ;f24d 21 48 00   21 48 00    ! H .
    ld a,(hl)           ;f250 7e   7e  ~
    or a                ;f251 b7   b7  .
    jr z,lf276h         ;f252 28 22   28 22   ( "
    dec (hl)            ;f254 35   35  5
    ld a,(0040h)        ;f255 3a 40 00   3a 40 00    : @ .
    ld hl,0049h         ;f258 21 49 00   21 49 00    ! I .
    cp (hl)             ;f25b be   be  .
    jr nz,lf276h        ;f25c 20 18   20 18     .
    ld a,(0041h)        ;f25e 3a 41 00   3a 41 00    : A .
    ld hl,004ah         ;f261 21 4a 00   21 4a 00    ! J .
    cp (hl)             ;f264 be   be  .
    jr nz,lf276h        ;f265 20 0f   20 0f     .
    ld a,(0043h)        ;f267 3a 43 00   3a 43 00    : C .
    ld hl,004bh         ;f26a 21 4b 00   21 4b 00    ! K .
    cp (hl)             ;f26d be   be  .
    jr nz,lf276h        ;f26e 20 06   20 06     .
    inc (hl)            ;f270 34   34  4
    call sub_f586h      ;f271 cd 86 f5   cd 86 f5    . . .
    jr lf282h           ;f274 18 0c   18 0c   . .
lf276h:
    xor a               ;f276 af   af  .
    ld (0048h),a        ;f277 32 48 00   32 48 00    2 H .
    call sub_f586h      ;f27a cd 86 f5   cd 86 f5    . . .
    ld a,00h            ;f27d 3e 00   3e 00   > .
    call nz,sub_f29dh   ;f27f c4 9d f2   c4 9d f2    . . .
lf282h:
    ld a,(0043h)        ;f282 3a 43 00   3a 43 00    : C .
    rrca                ;f285 0f   0f  .
    call sub_f2aeh      ;f286 cd ae f2   cd ae f2    . . .
    pop af              ;f289 f1   f1  .
    dec a               ;f28a 3d   3d  =
    jr nz,lf296h        ;f28b 20 09   20 09     .
    ld a,(004fh)        ;f28d 3a 4f 00   3a 4f 00    : O .
    or a                ;f290 b7   b7  .
    call z,sub_f2a4h    ;f291 cc a4 f2   cc a4 f2    . . .
    xor a               ;f294 af   af  .
    ret                 ;f295 c9   c9  .
lf296h:
    ld a,01h            ;f296 3e 01   3e 01   > .
    ld (004ch),a        ;f298 32 4c 00   32 4c 00    2 L .
    xor a               ;f29b af   af  .
    ret                 ;f29c c9   c9  .
sub_f29dh:
    ld hl,0ef00h        ;f29d 21 00 ef   21 00 ef    ! . .
    ex af,af'           ;f2a0 08   08  .
    jp lf9a2h           ;f2a1 c3 a2 f9   c3 a2 f9    . . .
sub_f2a4h:
    ld hl,0ef00h        ;f2a4 21 00 ef   21 00 ef    ! . .
    jp lf95bh           ;f2a7 c3 5b f9   c3 5b f9    . [ .
sub_f2aah:
    ld a,00h            ;f2aa 3e 00   3e 00   > .
    jr lf2b0h           ;f2ac 18 02   18 02   . .
sub_f2aeh:
    ld a,01h            ;f2ae 3e 01   3e 01   > .
lf2b0h:
    ld hl,0ef00h        ;f2b0 21 00 ef   21 00 ef    ! . .
    ld de,(0052h)       ;f2b3 ed 5b 52 00   ed 5b 52 00     . [ R .
    ld bc,0080h         ;f2b7 01 80 00   01 80 00    . . .
    jr nc,lf2bdh        ;f2ba 30 01   30 01   0 .
    add hl,bc           ;f2bc 09   09  .
lf2bdh:
    or a                ;f2bd b7   b7  .
    jr z,lf2c1h         ;f2be 28 01   28 01   ( .
    ex de,hl            ;f2c0 eb   eb  .
lf2c1h:
    ldir                ;f2c1 ed b0   ed b0   . .
    ret                 ;f2c3 c9   c9  .
sub_f2c4h:
    ld a,0ffh           ;f2c4 3e ff   3e ff   > .
    out (18h),a         ;f2c6 d3 18   d3 18   . .
    ld b,0ffh           ;f2c8 06 ff   06 ff   . .
lf2cah:
    djnz lf2cah         ;f2ca 10 fe   10 fe   . .
    in a,(16h)          ;f2cc db 16   db 16   . .
    and 20h             ;f2ce e6 20   e6 20   .
    jr nz,sub_f2c4h     ;f2d0 20 f2   20 f2     .
    jp lf320h           ;f2d2 c3 20 f3   c3 20 f3    .   .
lf2d5h:
    ld a,12h            ;f2d5 3e 12   3e 12   > .
    call sub_f336h      ;f2d7 cd 36 f3   cd 36 f3    . 6 .
    ld hl,(0052h)       ;f2da 2a 52 00   2a 52 00    * R .
    call sub_f316h      ;f2dd cd 16 f3   cd 16 f3    . . .
    jr nz,lf30ch        ;f2e0 20 2a   20 2a     *
    ld b,80h            ;f2e2 06 80   06 80   . .
lf2e4h:
    in a,(16h)          ;f2e4 db 16   db 16   . .
    and 10h             ;f2e6 e6 10   e6 10   . .
    jr z,lf2e4h         ;f2e8 28 fa   28 fa   ( .
    in a,(18h)          ;f2ea db 18   db 18   . .
    ld (hl),a           ;f2ec 77   77  w
    inc hl              ;f2ed 23   23  #
    djnz lf2e4h         ;f2ee 10 f4   10 f4   . .
    xor a               ;f2f0 af   af  .
    ret                 ;f2f1 c9   c9  .
lf2f2h:
    ld a,13h            ;f2f2 3e 13   3e 13   > .
    call sub_f336h      ;f2f4 cd 36 f3   cd 36 f3    . 6 .
    ld b,80h            ;f2f7 06 80   06 80   . .
    ld hl,(0052h)       ;f2f9 2a 52 00   2a 52 00    * R .
lf2fch:
    in a,(16h)          ;f2fc db 16   db 16   . .
    and 10h             ;f2fe e6 10   e6 10   . .
    jr z,lf2fch         ;f300 28 fa   28 fa   ( .
    ld a,(hl)           ;f302 7e   7e  ~
    out (18h),a         ;f303 d3 18   d3 18   . .
    inc hl              ;f305 23   23  #
    djnz lf2fch         ;f306 10 f4   10 f4   . .
    call sub_f316h      ;f308 cd 16 f3   cd 16 f3    . . .
    ret z               ;f30b c8   c8  .
lf30ch:
    ld hl,lf382h        ;f30c 21 82 f3   21 82 f3    ! . .
    call sub_fcf1h      ;f30f cd f1 fc   cd f1 fc    . . .
    ld a,01h            ;f312 3e 01   3e 01   > .
    or a                ;f314 b7   b7  .
    ret                 ;f315 c9   c9  .
sub_f316h:
    in a,(16h)          ;f316 db 16   db 16   . .
    and 20h             ;f318 e6 20   e6 20   .
    jr nz,sub_f316h     ;f31a 20 fa   20 fa     .
    ld b,0ah            ;f31c 06 0a   06 0a   . .
lf31eh:
    djnz lf31eh         ;f31e 10 fe   10 fe   . .
lf320h:
    in a,(16h)          ;f320 db 16   db 16   . .
    and 10h             ;f322 e6 10   e6 10   . .
    jr z,lf320h         ;f324 28 fa   28 fa   ( .
    in a,(18h)          ;f326 db 18   db 18   . .
    and 80h             ;f328 e6 80   e6 80   . .
    ret                 ;f32a c9   c9  .
sub_f32bh:
    ld b,a              ;f32b 47   47  G
lf32ch:
    in a,(16h)          ;f32c db 16   db 16   . .
    and 10h             ;f32e e6 10   e6 10   . .
    jr z,lf32ch         ;f330 28 fa   28 fa   ( .
    ld a,b              ;f332 78   78  x
    out (18h),a         ;f333 d3 18   d3 18   . .
    ret                 ;f335 c9   c9  .
sub_f336h:
    call sub_f32bh      ;f336 cd 2b f3   cd 2b f3    . + .
    ld hl,(0041h)       ;f339 2a 41 00   2a 41 00    * A .
    ld a,00h            ;f33c 3e 00   3e 00   > .
    ld b,06h            ;f33e 06 06   06 06   . .
lf340h:
    add hl,hl           ;f340 29   29  )
    rla                 ;f341 17   17  .
    djnz lf340h         ;f342 10 fc   10 fc   . .
    ld b,a              ;f344 47   47  G
    ld a,(0043h)        ;f345 3a 43 00   3a 43 00    : C .
    or l                ;f348 b5   b5  .
    ld l,a              ;f349 6f   6f  o
    ld ix,0f39ch        ;f34a dd 21 9c f3   dd 21 9c f3     . ! . .
    ld a,(0040h)        ;f34e 3a 40 00   3a 40 00    : @ .
    and 01h             ;f351 e6 01   e6 01   . .
lf353h:
    inc ix              ;f353 dd 23   dd 23   . #
    inc ix              ;f355 dd 23   dd 23   . #
    inc ix              ;f357 dd 23   dd 23   . #
    dec a               ;f359 3d   3d  =
    jp p,lf353h         ;f35a f2 53 f3   f2 53 f3    . S .
    ld e,(ix+00h)       ;f35d dd 5e 00   dd 5e 00    . ^ .
    ld d,(ix+01h)       ;f360 dd 56 01   dd 56 01    . V .
    add hl,de           ;f363 19   19  .
    ld a,(ix+02h)       ;f364 dd 7e 02   dd 7e 02    . ~ .
    adc a,b             ;f367 88   88  .
    add a,a             ;f368 87   87  .
    add a,a             ;f369 87   87  .
    add a,a             ;f36a 87   87  .
    add a,a             ;f36b 87   87  .
    push hl             ;f36c e5   e5  .
    push af             ;f36d f5   f5  .
    ld a,(0040h)        ;f36e 3a 40 00   3a 40 00    : @ .
    call dskdev         ;f371 cd 11 fa   cd 11 fa    . . .
    pop af              ;f374 f1   f1  .
    pop hl              ;f375 e1   e1  .
    add a,d             ;f376 82   82  .
    call sub_f32bh      ;f377 cd 2b f3   cd 2b f3    . + .
    ld a,l              ;f37a 7d   7d  }
    call sub_f32bh      ;f37b cd 2b f3   cd 2b f3    . + .
    ld a,h              ;f37e 7c   7c  |
    jp sub_f32bh        ;f37f c3 2b f3   c3 2b f3    . + .
lf382h:
    dec c               ;f382 0d   0d  .
    ld a,(bc)           ;f383 0a   0a  .
    rlca                ;f384 07   07  .
    ld hl,(2a2ah)       ;f385 2a 2a 2a   2a 2a 2a    * * *
    jr nz,$+74          ;f388 20 48   20 48     H
    ld b,c              ;f38a 41   41  A
    ld d,d              ;f38b 52   52  R
    ld b,h              ;f38c 44   44  D
    jr nz,$+70          ;f38d 20 44   20 44     D
    ld c,c              ;f38f 49   49  I
    ld d,e              ;f390 53   53  S
    ld c,e              ;f391 4b   4b  K
    jr nz,$+71          ;f392 20 45   20 45     E
    ld d,d              ;f394 52   52  R
    ld d,d              ;f395 52   52  R
    ld c,a              ;f396 4f   4f  O
    ld d,d              ;f397 52   52  R
    jr nz,$+44          ;f398 20 2a   20 2a     *
    ld hl,(0d2ah)       ;f39a 2a 2a 0d   2a 2a 0d    * * .
    ld a,(bc)           ;f39d 0a   0a  .
    nop                 ;f39e 00   00  .
    ld e,h              ;f39f 5c   5c  \
    nop                 ;f3a0 00   00  .
    nop                 ;f3a1 00   00  .
    inc e               ;f3a2 1c   1c  .
    sub h               ;f3a3 94   94  .
    nop                 ;f3a4 00   00  .
boot:
    ld sp,0100h         ;f3a5 31 00 01   31 00 01    1 . .
    ld a,99h            ;f3a8 3e 99   3e 99   > .
    out (13h),a         ;f3aa d3 13   d3 13   . .
    ld a,98h            ;f3ac 3e 98   3e 98   > .
    out (17h),a         ;f3ae d3 17   d3 17   . .
    xor a               ;f3b0 af   af  .
    out (11h),a         ;f3b1 d3 11   d3 11   . .
    out (15h),a         ;f3b3 d3 15   d3 15   . .
    in a,(15h)          ;f3b5 db 15   db 15   . .
    or 80h              ;f3b7 f6 80   f6 80   . .
    out (15h),a         ;f3b9 d3 15   d3 15   . .
    ld bc,0fa0h         ;f3bb 01 a0 0f   01 a0 0f    . . .
    call delay          ;f3be cd e5 fa   cd e5 fa    . . .
    xor a               ;f3c1 af   af  .
    ld (0003h),a        ;f3c2 32 03 00   32 03 00    2 . .
    ld (0004h),a        ;f3c5 32 04 00   32 04 00    2 . .
    ld (0054h),a        ;f3c8 32 54 00   32 54 00    2 T .
    ld (0059h),a        ;f3cb 32 59 00   32 59 00    2 Y .
    ld (005ah),a        ;f3ce 32 5a 00   32 5a 00    2 Z .
    ld (0ea80h),a       ;f3d1 32 80 ea   32 80 ea    2 . .
    ld a,0ffh           ;f3d4 3e ff   3e ff   > .
    ld a,1bh            ;f3d6 3e 1b   3e 1b   > .
    ld (0ea68h),a       ;f3d8 32 68 ea   32 68 ea    2 h .
    xor a               ;f3db af   af  .
    out (09h),a         ;f3dc d3 09   d3 09   . .
    nop                 ;f3de 00   00  .
    out (09h),a         ;f3df d3 09   d3 09   . .
    nop                 ;f3e1 00   00  .
    out (09h),a         ;f3e2 d3 09   d3 09   . .
    ld a,40h            ;f3e4 3e 40   3e 40   > @
    out (09h),a         ;f3e6 d3 09   d3 09   . .
    ld a,7ah            ;f3e8 3e 7a   3e 7a   > z
    out (09h),a         ;f3ea d3 09   d3 09   . .
    ld a,37h            ;f3ec 3e 37   3e 37   > 7
    out (09h),a         ;f3ee d3 09   d3 09   . .
    ld a,0eeh           ;f3f0 3e ee   3e ee   > .
    out (0ch),a         ;f3f2 d3 0c   d3 0c   . .
    in a,(14h)          ;f3f4 db 14   db 14   . .
    cpl                 ;f3f6 2f   2f  /
    and 40h             ;f3f7 e6 40   e6 40   . @
    jr nz,lf41bh        ;f3f9 20 20   20 20
    ld a,01h            ;f3fb 3e 01   3e 01   > .
    ld (0003h),a        ;f3fd 32 03 00   32 03 00    2 . .
lf400h:
    in a,(14h)          ;f400 db 14   db 14   . .
    cpl                 ;f402 2f   2f  /
    and 03h             ;f403 e6 03   e6 03   . .
    in a,(10h)          ;f405 db 10   db 10   . .
    jr nz,lf400h        ;f407 20 f7   20 f7     .
    cp 39h              ;f409 fe 39   fe 39   . 9
    jr nz,lf400h        ;f40b 20 f3   20 f3     .
    in a,(14h)          ;f40d db 14   db 14   . .
    cpl                 ;f40f 2f   2f  /
    and 02h             ;f410 e6 02   e6 02   . .
    jr nz,lf400h        ;f412 20 ec   20 ec     .
lf414h:
    in a,(14h)          ;f414 db 14   db 14   . .
    cpl                 ;f416 2f   2f  /
    and 02h             ;f417 e6 02   e6 02   . .
    jr z,lf414h         ;f419 28 f9   28 f9   ( .
lf41bh:
    ld hl,lf51bh        ;f41b 21 1b f5   21 1b f5    ! . .
    call sub_fcf1h      ;f41e cd f1 fc   cd f1 fc    . . .
    ld de,080fh         ;f421 11 0f 08   11 0f 08    . . .
    call listen         ;f424 cd 90 fa   cd 90 fa    . . .
    ld bc,0007h         ;f427 01 07 00   01 07 00    . . .
    call delay          ;f42a cd e5 fa   cd e5 fa    . . .
    in a,(14h)          ;f42d db 14   db 14   . .
    cpl                 ;f42f 2f   2f  /
    and 04h             ;f430 e6 04   e6 04   . .
    jr z,lf445h         ;f432 28 11   28 11   ( .
    ld a,02h            ;f434 3e 02   3e 02   > .
    ld (0ea70h),a       ;f436 32 70 ea   32 70 ea    2 p .
    ld a,01h            ;f439 3e 01   3e 01   > .
    ld (0ea78h),a       ;f43b 32 78 ea   32 78 ea    2 x .
    ld b,38h            ;f43e 06 38   06 38   . 8
    call sub_f0f4h      ;f440 cd f4 f0   cd f4 f0    . . .
    jr runcpm           ;f443 18 23   18 23   . #
lf445h:
    call unlisten       ;f445 cd a6 fa   cd a6 fa    . . .
    ld de,080fh         ;f448 11 0f 08   11 0f 08    . . .
    ld c,02h            ;f44b 0e 02   0e 02   . .
    ld hl,lf56ch        ;f44d 21 6c f5   21 6c f5    ! l .
    call open           ;f450 cd b5 fa   cd b5 fa    . . .
    ld d,08h            ;f453 16 08   16 08   . .
    ld c,1ch            ;f455 0e 1c   0e 1c   . .
    call sub_f52eh      ;f457 cd 2e f5   cd 2e f5    . . .
    jp nz,lf41bh        ;f45a c2 1b f4   c2 1b f4    . . .
    ld de,0802h         ;f45d 11 02 08   11 02 08    . . .
    ld c,02h            ;f460 0e 02   0e 02   . .
    ld hl,lf564h        ;f462 21 64 f5   21 64 f5    ! d .
    call open           ;f465 cd b5 fa   cd b5 fa    . . .
runcpm:
    ld sp,0100h         ;f468 31 00 01   31 00 01    1 . .
    xor a               ;f46b af   af  .
    push af             ;f46c f5   f5  .
    ld ix,0eb00h        ;f46d dd 21 00 eb   dd 21 00 eb     . ! . .
    ld hl,0ec00h        ;f471 21 00 ec   21 00 ec    ! . .
    ld de,0ea70h        ;f474 11 70 ea   11 70 ea    . p .
lf477h:
    ld a,(de)           ;f477 1a   1a  .
    or a                ;f478 b7   b7  .
    jp m,lf4b2h         ;f479 fa b2 f4   fa b2 f4    . . .
    cp 02h              ;f47c fe 02   fe 02   . .
    ld bc,004ah         ;f47e 01 4a 00   01 4a 00    . J .
    jr z,lf49bh         ;f481 28 18   28 18   ( .
    cp 03h              ;f483 fe 03   fe 03   . .
    jr z,lf49bh         ;f485 28 14   28 14   ( .
    cp 04h              ;f487 fe 04   fe 04   . .
    ld bc,0058h         ;f489 01 58 00   01 58 00    . X .
    jr z,lf49bh         ;f48c 28 0d   28 0d   ( .
    ld (ix+0ch),l       ;f48e dd 75 0c   dd 75 0c    . u .
    ld (ix+0dh),h       ;f491 dd 74 0d   dd 74 0d    . t .
    ld bc,0010h         ;f494 01 10 00   01 10 00    . . .
    add hl,bc           ;f497 09   09  .
    ld bc,0020h         ;f498 01 20 00   01 20 00    .   .
lf49bh:
    ld (ix+0eh),l       ;f49b dd 75 0e   dd 75 0e    . u .
    ld (ix+0fh),h       ;f49e dd 74 0f   dd 74 0f    . t .
    add hl,bc           ;f4a1 09   09  .
    ld (ix+08h),080h    ;f4a2 dd 36 08 80   dd 36 08 80     . 6 . .
    ld (ix+09h),0eeh    ;f4a6 dd 36 09 ee   dd 36 09 ee     . 6 . .
    ld (ix+00h),000h    ;f4aa dd 36 00 00   dd 36 00 00     . 6 . .
    ld (ix+01h),000h    ;f4ae dd 36 01 00   dd 36 01 00     . 6 . .
lf4b2h:
    ld bc,0010h         ;f4b2 01 10 00   01 10 00    . . .
    add ix,bc           ;f4b5 dd 09   dd 09   . .
    pop af              ;f4b7 f1   f1  .
    inc a               ;f4b8 3c   3c  <
    push af             ;f4b9 f5   f5  .
    or a                ;f4ba b7   b7  .
    rra                 ;f4bb 1f   1f  .
    jr c,lf477h         ;f4bc 38 b9   38 b9   8 .
    inc de              ;f4be 13   13  .
    cp 08h              ;f4bf fe 08   fe 08   . .
    jr nz,lf477h        ;f4c1 20 b4   20 b4     .
    pop af              ;f4c3 f1   f1  .
    ld a,(0d8b2h)       ;f4c4 3a b2 d8   3a b2 d8    : . .
    ld (0ea40h),a       ;f4c7 32 40 ea   32 40 ea    2 @ .
    ld a,(0003h)        ;f4ca 3a 03 00   3a 03 00    : . .
    and 01h             ;f4cd e6 01   e6 01   . .
    ld b,a              ;f4cf 47   47  G
    ld a,(0ea60h)       ;f4d0 3a 60 ea   3a 60 ea    : ` .
    and 0fch            ;f4d3 e6 fc   e6 fc   . .
    or b                ;f4d5 b0   b0  .
    ld (0003h),a        ;f4d6 32 03 00   32 03 00    2 . .
    xor a               ;f4d9 af   af  .
    out (09h),a         ;f4da d3 09   d3 09   . .
    nop                 ;f4dc 00   00  .
    out (09h),a         ;f4dd d3 09   d3 09   . .
    nop                 ;f4df 00   00  .
    out (09h),a         ;f4e0 d3 09   d3 09   . .
    ld a,40h            ;f4e2 3e 40   3e 40   > @
    out (09h),a         ;f4e4 d3 09   d3 09   . .
    ld a,(0ea64h)       ;f4e6 3a 64 ea   3a 64 ea    : d .
    out (09h),a         ;f4e9 d3 09   d3 09   . .
    ld a,37h            ;f4eb 3e 37   3e 37   > 7
    out (09h),a         ;f4ed d3 09   d3 09   . .
    ld a,(0ea65h)       ;f4ef 3a 65 ea   3a 65 ea    : e .
    out (0ch),a         ;f4f2 d3 0c   d3 0c   . .
    call clear          ;f4f4 cd fd fc   cd fd fc    . . .
    ld a,(0003h)        ;f4f7 3a 03 00   3a 03 00    : . .
    rra                 ;f4fa 1f   1f  .
    jr nc,lf508h        ;f4fb 30 0b   30 0b   0 .
    ld a,(0ea67h)       ;f4fd 3a 67 ea   3a 67 ea    : g .
    rla                 ;f500 17   17  .
    jr nc,lf508h        ;f501 30 05   30 05   0 .
    ld c,15h            ;f503 0e 15   0e 15   . .
    call conout         ;f505 cd 27 fb   cd 27 fb    . ' .
lf508h:
    ld hl,signon        ;f508 21 87 f0   21 87 f0    ! . .
    call sub_fcf1h      ;f50b cd f1 fc   cd f1 fc    . . .
    call const          ;f50e cd 15 fb   cd 15 fb    . . .
    inc a               ;f511 3c   3c  <
    call z,conin        ;f512 cc f7 fa   cc f7 fa    . . .
    ld hl,0d400h        ;f515 21 00 d4   21 00 d4    ! . .
    jp lf11eh           ;f518 c3 1e f1   c3 1e f1    . . .
lf51bh:
    dec c               ;f51b 0d   0d  .
    ld a,(bc)           ;f51c 0a   0a  .
    ld c,h              ;f51d 4c   4c  L
    ld l,a              ;f51e 6f   6f  o
    ld h,c              ;f51f 61   61  a
    ld h,h              ;f520 64   64  d
    ld l,c              ;f521 69   69  i
    ld l,(hl)           ;f522 6e   6e  n
    ld h,a              ;f523 67   67  g
    jr nz,lf569h        ;f524 20 43   20 43     C
    ld d,b              ;f526 50   50  P
    cpl                 ;f527 2f   2f  /
    ld c,l              ;f528 4d   4d  M
    jr nz,$+48          ;f529 20 2e   20 2e     .
    ld l,2eh            ;f52b 2e 2e   2e 2e   . .
    nop                 ;f52d 00   00  .
sub_f52eh:
    push bc             ;f52e c5   c5  .
    push de             ;f52f d5   d5  .
    ld hl,0f566h        ;f530 21 66 f5   21 66 f5    ! f .
    ld c,06h            ;f533 0e 06   0e 06   . .
    ld e,00h            ;f535 1e 00   1e 00   . .
    call open           ;f537 cd b5 fa   cd b5 fa    . . .
    pop de              ;f53a d1   d1  .
    push de             ;f53b d5   d5  .
    call sub_f923h      ;f53c cd 23 f9   cd 23 f9    . # .
    pop de              ;f53f d1   d1  .
    ld e,00h            ;f540 1e 00   1e 00   . .
    pop bc              ;f542 c1   c1  .
    or a                ;f543 b7   b7  .
    ret nz              ;f544 c0   c0  .
    push de             ;f545 d5   d5  .
    call talk           ;f546 cd 5d fa   cd 5d fa    . ] .
    ld hl,0d400h        ;f549 21 00 d4   21 00 d4    ! . .
    ld b,00h            ;f54c 06 00   06 00   . .
lf54eh:
    call rdieee         ;f54e cd 1c fe   cd 1c fe    . . .
    ld (hl),a           ;f551 77   77  w
    inc hl              ;f552 23   23  #
    djnz lf54eh         ;f553 10 f9   10 f9   . .
    dec c               ;f555 0d   0d  .
    jr nz,lf54eh        ;f556 20 f6   20 f6     .
    call untalk         ;f558 cd 80 fa   cd 80 fa    . . .
    pop de              ;f55b d1   d1  .
    push de             ;f55c d5   d5  .
    call close          ;f55d cd d1 fa   cd d1 fa    . . .
    pop de              ;f560 d1   d1  .
    jp sub_f923h        ;f561 c3 23 f9   c3 23 f9    . # .
lf564h:
    inc hl              ;f564 23   23  #
    ld (3a30h),a        ;f565 32 30 3a   32 30 3a    2 0 :
    ld b,e              ;f568 43   43  C
lf569h:
    ld d,b              ;f569 50   50  P
    cpl                 ;f56a 2f   2f  /
    ld c,l              ;f56b 4d   4d  M
lf56ch:
    ld c,c              ;f56c 49   49  I
    jr nc,$+64          ;f56d 30 3e   30 3e   0 >
    djnz $+52           ;f56f 10 32   10 32   . 2
    ld c,b              ;f571 48   48  H
    nop                 ;f572 00   00  .
    ld a,(0040h)        ;f573 3a 40 00   3a 40 00    : @ .
    ld (0049h),a        ;f576 32 49 00   32 49 00    2 I .
    ld a,(0041h)        ;f579 3a 41 00   3a 41 00    : A .
    ld (004ah),a        ;f57c 32 4a 00   32 4a 00    2 J .
    ld a,(0043h)        ;f57f 3a 43 00   3a 43 00    : C .
    ld (004bh),a        ;f582 32 4b 00   32 4b 00    2 K .
    ret                 ;f585 c9   c9  .
sub_f586h:
    ld a,(0040h)        ;f586 3a 40 00   3a 40 00    : @ .
    ld hl,0045h         ;f589 21 45 00   21 45 00    ! E .
    xor (hl)            ;f58c ae   ae  .
    ld b,a              ;f58d 47   47  G
    ld a,(0041h)        ;f58e 3a 41 00   3a 41 00    : A .
    ld hl,0046h         ;f591 21 46 00   21 46 00    ! F .
    xor (hl)            ;f594 ae   ae  .
    or b                ;f595 b0   b0  .
    ld b,a              ;f596 47   47  G
    ld a,(0043h)        ;f597 3a 43 00   3a 43 00    : C .
    rra                 ;f59a 1f   1f  .
    ld hl,0047h         ;f59b 21 47 00   21 47 00    ! G .
    xor (hl)            ;f59e ae   ae  .
    or b                ;f59f b0   b0  .
    ret z               ;f5a0 c8   c8  .
    ld hl,004ch         ;f5a1 21 4c 00   21 4c 00    ! L .
    ld a,(hl)           ;f5a4 7e   7e  ~
    ld (hl),00h         ;f5a5 36 00   36 00   6 .
    or a                ;f5a7 b7   b7  .
    call nz,sub_f2a4h   ;f5a8 c4 a4 f2   c4 a4 f2    . . .
    ld a,(0040h)        ;f5ab 3a 40 00   3a 40 00    : @ .
    ld (0045h),a        ;f5ae 32 45 00   32 45 00    2 E .
    ld a,(0041h)        ;f5b1 3a 41 00   3a 41 00    : A .
    ld (0046h),a        ;f5b4 32 46 00   32 46 00    2 F .
    ld a,(0043h)        ;f5b7 3a 43 00   3a 43 00    : C .
    or a                ;f5ba b7   b7  .
    rra                 ;f5bb 1f   1f  .
    ld (0047h),a        ;f5bc 32 47 00   32 47 00    2 G .
    or 0ffh             ;f5bf f6 ff   f6 ff   . .
    ret                 ;f5c1 c9   c9  .
lf5c2h:
    ld (0055h),hl       ;f5c2 22 55 00   22 55 00    " U .
    call sub_f7c4h      ;f5c5 cd c4 f7   cd c4 f7    . . .
lf5c8h:
    ld a,03h            ;f5c8 3e 03   3e 03   > .
    ld (0050h),a        ;f5ca 32 50 00   32 50 00    2 P .
lf5cdh:
    ld a,(0045h)        ;f5cd 3a 45 00   3a 45 00    : E .
    call diskcmd        ;f5d0 cd 20 fa   cd 20 fa    .   .
    ld hl,(0055h)       ;f5d3 2a 55 00   2a 55 00    * U .
    ld c,05h            ;f5d6 0e 05   0e 05   . .
    call ieeemsg        ;f5d8 cd 63 fe   cd 63 fe    . c .
    ld a,(0045h)        ;f5db 3a 45 00   3a 45 00    : E .
    and 01h             ;f5de e6 01   e6 01   . .
    add a,30h           ;f5e0 c6 30   c6 30   . 0
    call wrieee         ;f5e2 cd a6 fd   cd a6 fd    . . .
    ld a,(004dh)        ;f5e5 3a 4d 00   3a 4d 00    : M .
    call ieeenum        ;f5e8 cd 07 f9   cd 07 f9    . . .
    ld a,(004eh)        ;f5eb 3a 4e 00   3a 4e 00    : N .
    call ieeenum        ;f5ee cd 07 f9   cd 07 f9    . . .
    call creoi          ;f5f1 cd 4d fe   cd 4d fe    . M .
    call unlisten       ;f5f4 cd a6 fa   cd a6 fa    . . .
    ld a,(0045h)        ;f5f7 3a 45 00   3a 45 00    : E .
    call disksta        ;f5fa cd 20 f9   cd 20 f9    .   .
    cp 16h              ;f5fd fe 16   fe 16   . .
    jr nz,lf605h        ;f5ff 20 04   20 04     .
    ex af,af'           ;f601 08   08  .
    or a                ;f602 b7   b7  .
    ret z               ;f603 c8   c8  .
    ex af,af'           ;f604 08   08  .
lf605h:
    ld (004fh),a        ;f605 32 4f 00   32 4f 00    2 O .
    or a                ;f608 b7   b7  .
    ret z               ;f609 c8   c8  .
    ld hl,0050h         ;f60a 21 50 00   21 50 00    ! P .
    dec (hl)            ;f60d 35   35  5
    jr z,lf618h         ;f60e 28 08   28 08   ( .
    ld a,(0045h)        ;f610 3a 45 00   3a 45 00    : E .
    call idrive         ;f613 cd 28 fa   cd 28 fa    . ( .
    jr lf5cdh           ;f616 18 b5   18 b5   . .
lf618h:
    ld hl,lf7a8h        ;f618 21 a8 f7   21 a8 f7    ! . .
    call sub_fcf1h      ;f61b cd f1 fc   cd f1 fc    . . .
    ld a,(0045h)        ;f61e 3a 45 00   3a 45 00    : E .
    add a,41h           ;f621 c6 41   c6 41   . A
    ld c,a              ;f623 4f   4f  O
    call conout         ;f624 cd 27 fb   cd 27 fb    . ' .
    ld hl,lf7a5h        ;f627 21 a5 f7   21 a5 f7    ! . .
    call sub_fcf1h      ;f62a cd f1 fc   cd f1 fc    . . .
    ld a,(004fh)        ;f62d 3a 4f 00   3a 4f 00    : O .
    ld hl,lf6c0h        ;f630 21 c0 f6   21 c0 f6    ! . .
    cp 1ah              ;f633 fe 1a   fe 1a   . .
    jr z,lf684h         ;f635 28 4d   28 4d   ( M
    ld hl,lf6d5h        ;f637 21 d5 f6   21 d5 f6    ! . .
    cp 19h              ;f63a fe 19   fe 19   . .
    jr z,lf684h         ;f63c 28 46   28 46   ( F
    ld hl,lf6e8h        ;f63e 21 e8 f6   21 e8 f6    ! . .
    cp 1ch              ;f641 fe 1c   fe 1c   . .
    jr z,lf684h         ;f643 28 3f   28 3f   ( ?
    ld hl,lf6f8h        ;f645 21 f8 f6   21 f8 f6    ! . .
    cp 14h              ;f648 fe 14   fe 14   . .
    jr z,lf684h         ;f64a 28 38   28 38   ( 8
    ld hl,lf707h        ;f64c 21 07 f7   21 07 f7    ! . .
    cp 15h              ;f64f fe 15   fe 15   . .
    jr z,lf684h         ;f651 28 31   28 31   ( 1
    cp 4ah              ;f653 fe 4a   fe 4a   . J
    jr z,lf684h         ;f655 28 2d   28 2d   ( -
    ld hl,lf716h        ;f657 21 16 f7   21 16 f7    ! . .
    cp 16h              ;f65a fe 16   fe 16   . .
    jr z,lf684h         ;f65c 28 26   28 26   ( &
    ld hl,lf729h        ;f65e 21 29 f7   21 29 f7    ! ) .
    cp 17h              ;f661 fe 17   fe 17   . .
    jr z,lf684h         ;f663 28 1f   28 1f   ( .
    ld hl,lf740h        ;f665 21 40 f7   21 40 f7    ! @ .
    cp 1bh              ;f668 fe 1b   fe 1b   . .
    jr z,lf684h         ;f66a 28 18   28 18   ( .
    ld hl,lf759h        ;f66c 21 59 f7   21 59 f7    ! Y .
    cp 18h              ;f66f fe 18   fe 18   . .
    jr z,lf684h         ;f671 28 11   28 11   ( .
    ld hl,lf780h        ;f673 21 80 f7   21 80 f7    ! . .
    cp 46h              ;f676 fe 46   fe 46   . F
    jr z,lf684h         ;f678 28 0a   28 0a   ( .
    ld hl,lf794h        ;f67a 21 94 f7   21 94 f7    ! . .
    cp 49h              ;f67d fe 49   fe 49   . I
    jr z,lf684h         ;f67f 28 03   28 03   ( .
    ld hl,lf76dh        ;f681 21 6d f7   21 6d f7    ! m .
lf684h:
    call sub_fcf1h      ;f684 cd f1 fc   cd f1 fc    . . .
lf687h:
    call conin          ;f687 cd f7 fa   cd f7 fa    . . .
    cp 03h              ;f68a fe 03   fe 03   . .
    jp z,0000h          ;f68c ca 00 00   ca 00 00    . . .
    cp 3fh              ;f68f fe 3f   fe 3f   . ?
    jr nz,lf6aah        ;f691 20 17   20 17     .
    ld hl,0f7c1h        ;f693 21 c1 f7   21 c1 f7    ! . .
    call sub_fcf1h      ;f696 cd f1 fc   cd f1 fc    . . .
    ld hl,0eac0h        ;f699 21 c0 ea   21 c0 ea    ! . .
lf69ch:
    ld a,(hl)           ;f69c 7e   7e  ~
    cp 0dh              ;f69d fe 0d   fe 0d   . .
    jr z,lf687h         ;f69f 28 e6   28 e6   ( .
    ld c,a              ;f6a1 4f   4f  O
    push hl             ;f6a2 e5   e5  .
    call conout         ;f6a3 cd 27 fb   cd 27 fb    . ' .
    pop hl              ;f6a6 e1   e1  .
    inc hl              ;f6a7 23   23  #
    jr lf69ch           ;f6a8 18 f2   18 f2   . .
lf6aah:
    ld a,(0045h)        ;f6aa 3a 45 00   3a 45 00    : E .
    call idrive         ;f6ad cd 28 fa   cd 28 fa    . ( .
    ld a,(004fh)        ;f6b0 3a 4f 00   3a 4f 00    : O .
    cp 1ah              ;f6b3 fe 1a   fe 1a   . .
    jp z,lf5c8h         ;f6b5 ca c8 f5   ca c8 f5    . . .
    cp 15h              ;f6b8 fe 15   fe 15   . .
    jp z,lf5c8h         ;f6ba ca c8 f5   ca c8 f5    . . .
    ld a,00h            ;f6bd 3e 00   3e 00   > .
    ret                 ;f6bf c9   c9  .
lf6c0h:
    ld b,h              ;f6c0 44   44  D
    ld l,c              ;f6c1 69   69  i
    ld (hl),e           ;f6c2 73   73  s
    ld l,e              ;f6c3 6b   6b  k
    jr nz,lf73dh        ;f6c4 20 77   20 77     w
    ld (hl),d           ;f6c6 72   72  r
    ld l,c              ;f6c7 69   69  i
    ld (hl),h           ;f6c8 74   74  t
    ld h,l              ;f6c9 65   65  e
    jr nz,lf73ch        ;f6ca 20 70   20 70     p
    ld (hl),d           ;f6cc 72   72  r
    ld l,a              ;f6cd 6f   6f  o
    ld (hl),h           ;f6ce 74   74  t
    ld h,l              ;f6cf 65   65  e
    ld h,e              ;f6d0 63   63  c
    ld (hl),h           ;f6d1 74   74  t
    ld h,l              ;f6d2 65   65  e
    ld h,h              ;f6d3 64   64  d
    nop                 ;f6d4 00   00  .
lf6d5h:
    ld d,a              ;f6d5 57   57  W
    ld (hl),d           ;f6d6 72   72  r
    ld l,c              ;f6d7 69   69  i
    ld (hl),h           ;f6d8 74   74  t
    ld h,l              ;f6d9 65   65  e
    jr nz,$+120         ;f6da 20 76   20 76     v
    ld h,l              ;f6dc 65   65  e
    ld (hl),d           ;f6dd 72   72  r
    ld l,c              ;f6de 69   69  i
    ld h,(hl)           ;f6df 66   66  f
    ld a,c              ;f6e0 79   79  y
    jr nz,lf748h        ;f6e1 20 65   20 65     e
    ld (hl),d           ;f6e3 72   72  r
    ld (hl),d           ;f6e4 72   72  r
    ld l,a              ;f6e5 6f   6f  o
    ld (hl),d           ;f6e6 72   72  r
    nop                 ;f6e7 00   00  .
lf6e8h:
    ld c,h              ;f6e8 4c   4c  L
    ld l,a              ;f6e9 6f   6f  o
    ld l,(hl)           ;f6ea 6e   6e  n
    ld h,a              ;f6eb 67   67  g
    jr nz,$+102         ;f6ec 20 64   20 64     d
    ld h,c              ;f6ee 61   61  a
    ld (hl),h           ;f6ef 74   74  t
    ld h,c              ;f6f0 61   61  a
    jr nz,lf755h        ;f6f1 20 62   20 62     b
    ld l,h              ;f6f3 6c   6c  l
    ld l,a              ;f6f4 6f   6f  o
    ld h,e              ;f6f5 63   63  c
    ld l,e              ;f6f6 6b   6b  k
    nop                 ;f6f7 00   00  .
lf6f8h:
    ld c,l              ;f6f8 4d   4d  M
    ld l,c              ;f6f9 69   69  i
    ld (hl),e           ;f6fa 73   73  s
    ld (hl),e           ;f6fb 73   73  s
    ld l,c              ;f6fc 69   69  i
    ld l,(hl)           ;f6fd 6e   6e  n
    ld h,a              ;f6fe 67   67  g
    jr nz,lf769h        ;f6ff 20 68   20 68     h
    ld h,l              ;f701 65   65  e
    ld h,c              ;f702 61   61  a
lf703h:
    ld h,h              ;f703 64   64  d
    ld h,l              ;f704 65   65  e
    ld (hl),d           ;f705 72   72  r
    nop                 ;f706 00   00  .
lf707h:
    ld b,h              ;f707 44   44  D
    ld l,c              ;f708 69   69  i
    ld (hl),e           ;f709 73   73  s
    ld l,e              ;f70a 6b   6b  k
    jr nz,$+112         ;f70b 20 6e   20 6e     n
    ld l,a              ;f70d 6f   6f  o
    ld (hl),h           ;f70e 74   74  t
    jr nz,lf783h        ;f70f 20 72   20 72     r
    ld h,l              ;f711 65   65  e
    ld h,c              ;f712 61   61  a
    ld h,h              ;f713 64   64  d
    ld a,c              ;f714 79   79  y
    nop                 ;f715 00   00  .
lf716h:
    ld c,l              ;f716 4d   4d  M
    ld l,c              ;f717 69   69  i
    ld (hl),e           ;f718 73   73  s
    ld (hl),e           ;f719 73   73  s
    ld l,c              ;f71a 69   69  i
    ld l,(hl)           ;f71b 6e   6e  n
    ld h,a              ;f71c 67   67  g
    jr nz,lf783h        ;f71d 20 64   20 64     d
    ld h,c              ;f71f 61   61  a
    ld (hl),h           ;f720 74   74  t
    ld h,c              ;f721 61   61  a
    jr nz,lf786h        ;f722 20 62   20 62     b
    ld l,h              ;f724 6c   6c  l
    ld l,a              ;f725 6f   6f  o
    ld h,e              ;f726 63   63  c
    ld l,e              ;f727 6b   6b  k
    nop                 ;f728 00   00  .
lf729h:
    ld b,e              ;f729 43   43  C
    ld l,b              ;f72a 68   68  h
    ld h,l              ;f72b 65   65  e
    ld h,e              ;f72c 63   63  c
    ld l,e              ;f72d 6b   6b  k
    ld (hl),e           ;f72e 73   73  s
    ld (hl),l           ;f72f 75   75  u
    ld l,l              ;f730 6d   6d  m
    jr nz,lf798h        ;f731 20 65   20 65     e
    ld (hl),d           ;f733 72   72  r
    ld (hl),d           ;f734 72   72  r
    ld l,a              ;f735 6f   6f  o
    ld (hl),d           ;f736 72   72  r
    jr nz,lf7a2h        ;f737 20 69   20 69     i
    ld l,(hl)           ;f739 6e   6e  n
    jr nz,lf7a0h        ;f73a 20 64   20 64     d
lf73ch:
    ld h,c              ;f73c 61   61  a
lf73dh:
    ld (hl),h           ;f73d 74   74  t
    ld h,c              ;f73e 61   61  a
    nop                 ;f73f 00   00  .
lf740h:
    ld b,e              ;f740 43   43  C
    ld l,b              ;f741 68   68  h
    ld h,l              ;f742 65   65  e
    ld h,e              ;f743 63   63  c
    ld l,e              ;f744 6b   6b  k
    ld (hl),e           ;f745 73   73  s
    ld (hl),l           ;f746 75   75  u
    ld l,l              ;f747 6d   6d  m
lf748h:
    jr nz,$+103         ;f748 20 65   20 65     e
    ld (hl),d           ;f74a 72   72  r
    ld (hl),d           ;f74b 72   72  r
    ld l,a              ;f74c 6f   6f  o
    ld (hl),d           ;f74d 72   72  r
    jr nz,$+107         ;f74e 20 69   20 69     i
    ld l,(hl)           ;f750 6e   6e  n
    jr nz,lf7bbh        ;f751 20 68   20 68     h
    ld h,l              ;f753 65   65  e
    ld h,c              ;f754 61   61  a
lf755h:
    ld h,h              ;f755 64   64  d
    ld h,l              ;f756 65   65  e
    ld (hl),d           ;f757 72   72  r
    nop                 ;f758 00   00  .
lf759h:
    ld b,d              ;f759 42   42  B
    ld a,c              ;f75a 79   79  y
    ld (hl),h           ;f75b 74   74  t
    ld h,l              ;f75c 65   65  e
    jr nz,lf7c3h        ;f75d 20 64   20 64     d
    ld h,l              ;f75f 65   65  e
    ld h,e              ;f760 63   63  c
    ld l,a              ;f761 6f   6f  o
    ld h,h              ;f762 64   64  d
    ld l,c              ;f763 69   69  i
    ld l,(hl)           ;f764 6e   6e  n
    ld h,a              ;f765 67   67  g
    jr nz,$+103         ;f766 20 65   20 65     e
    ld (hl),d           ;f768 72   72  r
lf769h:
    ld (hl),d           ;f769 72   72  r
    ld l,a              ;f76a 6f   6f  o
    ld (hl),d           ;f76b 72   72  r
    nop                 ;f76c 00   00  .
lf76dh:
    ld d,l              ;f76d 55   55  U
    ld l,(hl)           ;f76e 6e   6e  n
    ld l,e              ;f76f 6b   6b  k
    ld l,(hl)           ;f770 6e   6e  n
    ld l,a              ;f771 6f   6f  o
    ld (hl),a           ;f772 77   77  w
    ld l,(hl)           ;f773 6e   6e  n
    jr nz,lf7dbh        ;f774 20 65   20 65     e
    ld (hl),d           ;f776 72   72  r
    ld (hl),d           ;f777 72   72  r
    ld l,a              ;f778 6f   6f  o
    ld (hl),d           ;f779 72   72  r
    jr nz,$+101         ;f77a 20 63   20 63     c
    ld l,a              ;f77c 6f   6f  o
    ld h,h              ;f77d 64   64  d
    ld h,l              ;f77e 65   65  e
    nop                 ;f77f 00   00  .
lf780h:
    ld b,e              ;f780 43   43  C
    ld l,a              ;f781 6f   6f  o
    ld l,l              ;f782 6d   6d  m
lf783h:
    ld l,l              ;f783 6d   6d  m
    ld l,a              ;f784 6f   6f  o
    ld h,h              ;f785 64   64  d
lf786h:
    ld l,a              ;f786 6f   6f  o
    ld (hl),d           ;f787 72   72  r
    ld h,l              ;f788 65   65  e
    jr nz,$+70          ;f789 20 44   20 44     D
    ld c,a              ;f78b 4f   4f  O
    ld d,e              ;f78c 53   53  S
    jr nz,lf7f1h        ;f78d 20 62   20 62     b
    ld (hl),l           ;f78f 75   75  u
    ld h,a              ;f790 67   67  g
    jr nz,lf7b4h        ;f791 20 21   20 21     !
    nop                 ;f793 00   00  .
lf794h:
    ld d,a              ;f794 57   57  W
    ld (hl),d           ;f795 72   72  r
    ld l,a              ;f796 6f   6f  o
    ld l,(hl)           ;f797 6e   6e  n
lf798h:
    ld h,a              ;f798 67   67  g
    jr nz,$+70          ;f799 20 44   20 44     D
    ld c,a              ;f79b 4f   4f  O
    ld d,e              ;f79c 53   53  S
    jr nz,lf805h        ;f79d 20 66   20 66     f
    ld l,a              ;f79f 6f   6f  o
lf7a0h:
    ld (hl),d           ;f7a0 72   72  r
    ld l,l              ;f7a1 6d   6d  m
lf7a2h:
    ld h,c              ;f7a2 61   61  a
    ld (hl),h           ;f7a3 74   74  t
    nop                 ;f7a4 00   00  .
lf7a5h:
    ld a,(0020h)        ;f7a5 3a 20 00   3a 20 00    :   .
lf7a8h:
    dec c               ;f7a8 0d   0d  .
    ld a,(bc)           ;f7a9 0a   0a  .
    ld b,d              ;f7aa 42   42  B
    ld b,h              ;f7ab 44   44  D
    ld c,a              ;f7ac 4f   4f  O
    ld d,e              ;f7ad 53   53  S
    jr nz,lf815h        ;f7ae 20 65   20 65     e
    ld (hl),d           ;f7b0 72   72  r
    ld (hl),d           ;f7b1 72   72  r
    jr nz,lf823h        ;f7b2 20 6f   20 6f     o
lf7b4h:
    ld l,(hl)           ;f7b4 6e   6e  n
    jr nz,lf7b7h        ;f7b5 20 00   20 00     .
lf7b7h:
    ld d,l              ;f7b7 55   55  U
    ld sp,3220h         ;f7b8 31 20 32   31 20 32    1   2
lf7bbh:
    jr nz,$+87          ;f7bb 20 55   20 55     U
    ld (3220h),a        ;f7bd 32 20 32   32 20 32    2   2
    jr nz,$+15          ;f7c0 20 0d   20 0d     .
    ld a,(bc)           ;f7c2 0a   0a  .
lf7c3h:
    nop                 ;f7c3 00   00  .
sub_f7c4h:
    ld a,(0045h)        ;f7c4 3a 45 00   3a 45 00    : E .
    call tstdrv         ;f7c7 cd f8 f1   cd f8 f1    . . .
    ld a,c              ;f7ca 79   79  y
    or a                ;f7cb b7   b7  .
    ld ix,0057h         ;f7cc dd 21 57 00   dd 21 57 00     . ! W .
    ld bc,lf82fh        ;f7d0 01 2f f8   01 2f f8    . / .
    ld e,10h            ;f7d3 1e 10   1e 10   . .
    jr z,lf7e0h         ;f7d5 28 09   28 09   ( .
    ld ix,0058h         ;f7d7 dd 21 58 00   dd 21 58 00     . ! X .
lf7dbh:
    ld bc,lf871h        ;f7db 01 71 f8   01 71 f8    . q .
    ld e,25h            ;f7de 1e 25   1e 25   . %
lf7e0h:
    push de             ;f7e0 d5   d5  .
    ld hl,(0046h)       ;f7e1 2a 46 00   2a 46 00    * F .
    ld h,00h            ;f7e4 26 00   26 00   & .
    add hl,hl           ;f7e6 29   29  )
    add hl,hl           ;f7e7 29   29  )
    add hl,hl           ;f7e8 29   29  )
    add hl,hl           ;f7e9 29   29  )
    ld de,(0047h)       ;f7ea ed 5b 47 00   ed 5b 47 00     . [ G .
    ld d,00h            ;f7ee 16 00   16 00   . .
    add hl,de           ;f7f0 19   19  .
lf7f1h:
    ex de,hl            ;f7f1 eb   eb  .
    ld l,(ix+00h)       ;f7f2 dd 6e 00   dd 6e 00    . n .
    ld h,00h            ;f7f5 26 00   26 00   & .
    add hl,hl           ;f7f7 29   29  )
    add hl,bc           ;f7f8 09   09  .
lf7f9h:
    ld a,e              ;f7f9 7b   7b  {
    sub (hl)            ;f7fa 96   96  .
    inc hl              ;f7fb 23   23  #
    ld a,d              ;f7fc 7a   7a  z
    sbc a,(hl)          ;f7fd 9e   9e  .
    jr nc,lf808h        ;f7fe 30 08   30 08   0 .
    dec (ix+00h)        ;f800 dd 35 00   dd 35 00    . 5 .
    dec hl              ;f803 2b   2b  +
    dec hl              ;f804 2b   2b  +
lf805h:
    dec hl              ;f805 2b   2b  +
    jr lf7f9h           ;f806 18 f1   18 f1   . .
lf808h:
    inc hl              ;f808 23   23  #
    ld a,e              ;f809 7b   7b  {
    cp (hl)             ;f80a be   be  .
    inc hl              ;f80b 23   23  #
    ld a,d              ;f80c 7a   7a  z
    sbc a,(hl)          ;f80d 9e   9e  .
    jr c,lf815h         ;f80e 38 05   38 05   8 .
    inc (ix+00h)        ;f810 dd 34 00   dd 34 00    . 4 .
    jr lf808h           ;f813 18 f3   18 f3   . .
lf815h:
    inc (ix+00h)        ;f815 dd 34 00   dd 34 00    . 4 .
    dec hl              ;f818 2b   2b  +
    dec hl              ;f819 2b   2b  +
    dec hl              ;f81a 2b   2b  +
    ld a,e              ;f81b 7b   7b  {
    sub (hl)            ;f81c 96   96  .
    ld (004eh),a        ;f81d 32 4e 00   32 4e 00    2 N .
    ld a,(ix+00h)       ;f820 dd 7e 00   dd 7e 00    . ~ .
lf823h:
    ld (004dh),a        ;f823 32 4d 00   32 4d 00    2 M .
    pop de              ;f826 d1   d1  .
    cp e                ;f827 bb   bb  .
    ret c               ;f828 d8   d8  .
    add a,03h           ;f829 c6 03   c6 03   . .
    ld (004dh),a        ;f82b 32 4d 00   32 4d 00    2 M .
    ret                 ;f82e c9   c9  .
lf82fh:
    nop                 ;f82f 00   00  .
    nop                 ;f830 00   00  .
    dec d               ;f831 15   15  .
    nop                 ;f832 00   00  .
    ld hl,(3f00h)       ;f833 2a 00 3f   2a 00 3f    * . ?
    nop                 ;f836 00   00  .
    ld d,h              ;f837 54   54  T
    nop                 ;f838 00   00  .
    ld l,c              ;f839 69   69  i
    nop                 ;f83a 00   00  .
    ld a,(hl)           ;f83b 7e   7e  ~
    nop                 ;f83c 00   00  .
    sub e               ;f83d 93   93  .
    nop                 ;f83e 00   00  .
    xor b               ;f83f a8   a8  .
    nop                 ;f840 00   00  .
    cp l                ;f841 bd   bd  .
    nop                 ;f842 00   00  .
    jp nc,0e700h        ;f843 d2 00 e7   d2 00 e7    . . .
    nop                 ;f846 00   00  .
    call m,1100h        ;f847 fc 00 11   fc 00 11    . . .
    ld bc,0126h         ;f84a 01 26 01   01 26 01    . & .
    dec sp              ;f84d 3b   3b
    ld bc,014eh         ;f84e 01 4e 01   01 4e 01    . N .
    ld h,c              ;f851 61   61  a
    ld bc,0174h         ;f852 01 74 01   01 74 01    . t .
    add a,a             ;f855 87   87  .
    ld bc,019ah         ;f856 01 9a 01   01 9a 01    . . .
    xor l               ;f859 ad   ad  .
    ld bc,01bfh         ;f85a 01 bf 01   01 bf 01    . . .
    pop de              ;f85d d1   d1  .
    ld bc,01e3h         ;f85e 01 e3 01   01 e3 01    . . .
    push af             ;f861 f5   f5  .
    ld bc,0207h         ;f862 01 07 02   01 07 02    . . .
    add hl,de           ;f865 19   19  .
    ld (bc),a           ;f866 02   02  .
    ld hl,(3b02h)       ;f867 2a 02 3b   2a 02 3b    * .
    ld (bc),a           ;f86a 02   02  .
    ld c,h              ;f86b 4c   4c  L
    ld (bc),a           ;f86c 02   02  .
    ld e,l              ;f86d 5d   5d  ]
    ld (bc),a           ;f86e 02   02  .
    rst 38h             ;f86f ff   ff  .
    rst 38h             ;f870 ff   ff  .
lf871h:
    nop                 ;f871 00   00  .
    nop                 ;f872 00   00  .
    dec e               ;f873 1d   1d  .
    nop                 ;f874 00   00  .
    ld a,(5700h)        ;f875 3a 00 57   3a 00 57    : . W
    nop                 ;f878 00   00  .
    ld (hl),h           ;f879 74   74  t
    nop                 ;f87a 00   00  .
    sub c               ;f87b 91   91  .
    nop                 ;f87c 00   00  .
    xor (hl)            ;f87d ae   ae  .
    nop                 ;f87e 00   00  .
    rlc b               ;f87f cb 00   cb 00   . .
    ret pe              ;f881 e8   e8  .
    nop                 ;f882 00   00  .
    dec b               ;f883 05   05  .
    ld bc,0122h         ;f884 01 22 01   01 22 01    . " .
    ccf                 ;f887 3f   3f  ?
    ld bc,015ch         ;f888 01 5c 01   01 5c 01    . \ .
    ld a,c              ;f88b 79   79  y
    ld bc,0196h         ;f88c 01 96 01   01 96 01    . . .
    or e                ;f88f b3   b3  .
    ld bc,01d0h         ;f890 01 d0 01   01 d0 01    . . .
    defb 0edh           ;next byte illegal after ed
    ld bc,020ah         ;f894 01 0a 02   01 0a 02    . . .
    daa                 ;f897 27   27  '
    ld (bc),a           ;f898 02   02  .
    ld b,h              ;f899 44   44  D
    ld (bc),a           ;f89a 02   02  .
    ld h,c              ;f89b 61   61  a
    ld (bc),a           ;f89c 02   02  .
    ld a,(hl)           ;f89d 7e   7e  ~
    ld (bc),a           ;f89e 02   02  .
    sbc a,e             ;f89f 9b   9b  .
    ld (bc),a           ;f8a0 02   02  .
    cp b                ;f8a1 b8   b8  .
    ld (bc),a           ;f8a2 02   02  .
    push de             ;f8a3 d5   d5  .
    ld (bc),a           ;f8a4 02   02  .
    jp p,0f02h          ;f8a5 f2 02 0f   f2 02 0f    . . .
    inc bc              ;f8a8 03   03  .
    inc l               ;f8a9 2c   2c  ,
    inc bc              ;f8aa 03   03  .
    ld c,c              ;f8ab 49   49  I
    inc bc              ;f8ac 03   03  .
    ld h,(hl)           ;f8ad 66   66  f
    inc bc              ;f8ae 03   03  .
    add a,e             ;f8af 83   83  .
    inc bc              ;f8b0 03   03  .
    and b               ;f8b1 a0   a0  .
    inc bc              ;f8b2 03   03  .
    cp l                ;f8b3 bd   bd  .
    inc bc              ;f8b4 03   03  .
    jp c,lf703h         ;f8b5 da 03 f7   da 03 f7    . . .
    inc bc              ;f8b8 03   03  .
    inc d               ;f8b9 14   14  .
    inc b               ;f8ba 04   04  .
    cpl                 ;f8bb 2f   2f  /
    inc b               ;f8bc 04   04  .
    ld c,d              ;f8bd 4a   4a  J
    inc b               ;f8be 04   04  .
    ld h,l              ;f8bf 65   65  e
    inc b               ;f8c0 04   04  .
    add a,b             ;f8c1 80   80  .
    inc b               ;f8c2 04   04  .
    sbc a,e             ;f8c3 9b   9b  .
    inc b               ;f8c4 04   04  .
    or (hl)             ;f8c5 b6   b6  .
    inc b               ;f8c6 04   04  .
    pop de              ;f8c7 d1   d1  .
    inc b               ;f8c8 04   04  .
    call pe,0704h       ;f8c9 ec 04 07   ec 04 07    . . .
    dec b               ;f8cc 05   05  .
    ld (3d05h),hl       ;f8cd 22 05 3d   22 05 3d    " . =
    dec b               ;f8d0 05   05  .
    ld e,b              ;f8d1 58   58  X
    dec b               ;f8d2 05   05  .
    ld (hl),e           ;f8d3 73   73  s
    dec b               ;f8d4 05   05  .
    adc a,(hl)          ;f8d5 8e   8e  .
    dec b               ;f8d6 05   05  .
    and a               ;f8d7 a7   a7  .
    dec b               ;f8d8 05   05  .
    ret nz              ;f8d9 c0   c0  .
    dec b               ;f8da 05   05  .
    exx                 ;f8db d9   d9  .
    dec b               ;f8dc 05   05  .
    jp p,0b05h          ;f8dd f2 05 0b   f2 05 0b    . . .
    ld b,24h            ;f8e0 06 24   06 24   . $
    ld b,3dh            ;f8e2 06 3d   06 3d   . =
    ld b,56h            ;f8e4 06 56   06 56   . V
    ld b,6fh            ;f8e6 06 6f   06 6f   . o
    ld b,88h            ;f8e8 06 88   06 88   . .
    ld b,0a1h           ;f8ea 06 a1   06 a1   . .
    ld b,0b8h           ;f8ec 06 b8   06 b8   . .
    ld b,0cfh           ;f8ee 06 cf   06 cf   . .
    ld b,0e6h           ;f8f0 06 e6   06 e6   . .
    ld b,0fdh           ;f8f2 06 fd   06 fd   . .
    ld b,14h            ;f8f4 06 14   06 14   . .
    rlca                ;f8f6 07   07  .
    dec hl              ;f8f7 2b   2b  +
    rlca                ;f8f8 07   07  .
    ld b,d              ;f8f9 42   42  B
    rlca                ;f8fa 07   07  .
    ld e,c              ;f8fb 59   59  Y
    rlca                ;f8fc 07   07  .
    ld (hl),b           ;f8fd 70   70  p
    rlca                ;f8fe 07   07  .
    add a,a             ;f8ff 87   87  .
    rlca                ;f900 07   07  .
    sbc a,(hl)          ;f901 9e   9e  .
    rlca                ;f902 07   07  .
    or l                ;f903 b5   b5  .
    rlca                ;f904 07   07  .
    rst 38h             ;f905 ff   ff  .
    rst 38h             ;f906 ff   ff  .
ieeenum:
    push af             ;f907 f5   f5  .
    ld a,20h            ;f908 3e 20   3e 20   >
    call wrieee         ;f90a cd a6 fd   cd a6 fd    . . .
    pop af              ;f90d f1   f1  .
    ld e,2fh            ;f90e 1e 2f   1e 2f   . /
lf910h:
    sub 0ah             ;f910 d6 0a   d6 0a   . .
    inc e               ;f912 1c   1c  .
    jr nc,lf910h        ;f913 30 fb   30 fb   0 .
    add a,3ah           ;f915 c6 3a   c6 3a   . :
    push af             ;f917 f5   f5  .
    ld a,e              ;f918 7b   7b  {
    call wrieee         ;f919 cd a6 fd   cd a6 fd    . . .
    pop af              ;f91c f1   f1  .
    jp wrieee           ;f91d c3 a6 fd   c3 a6 fd    . . .
disksta:
    call dskdev         ;f920 cd 11 fa   cd 11 fa    . . .
sub_f923h:
    ld e,0fh            ;f923 1e 0f   1e 0f   . .
    call talk           ;f925 cd 5d fa   cd 5d fa    . ] .
    ld hl,0eac0h        ;f928 21 c0 ea   21 c0 ea    ! . .
lf92bh:
    call rdieee         ;f92b cd 1c fe   cd 1c fe    . . .
    ld (hl),a           ;f92e 77   77  w
    sub 30h             ;f92f d6 30   d6 30   . 0
    jr c,lf92bh         ;f931 38 f8   38 f8   8 .
    cp 0ah              ;f933 fe 0a   fe 0a   . .
    jr nc,lf92bh        ;f935 30 f4   30 f4   0 .
    inc hl              ;f937 23   23  #
    ld b,a              ;f938 47   47  G
    add a,a             ;f939 87   87  .
    add a,a             ;f93a 87   87  .
    add a,b             ;f93b 80   80  .
    add a,a             ;f93c 87   87  .
    ld b,a              ;f93d 47   47  G
    call rdieee         ;f93e cd 1c fe   cd 1c fe    . . .
    ld (hl),a           ;f941 77   77  w
    inc hl              ;f942 23   23  #
    sub 30h             ;f943 d6 30   d6 30   . 0
    add a,b             ;f945 80   80  .
    push af             ;f946 f5   f5  .
    ld c,3ch            ;f947 0e 3c   0e 3c   . <
lf949h:
    call rdieee         ;f949 cd 1c fe   cd 1c fe    . . .
    dec c               ;f94c 0d   0d  .
    jp m,lf952h         ;f94d fa 52 f9   fa 52 f9    . R .
    ld (hl),a           ;f950 77   77  w
    inc hl              ;f951 23   23  #
lf952h:
    cp 0dh              ;f952 fe 0d   fe 0d   . .
    jr nz,lf949h        ;f954 20 f3   20 f3     .
    call untalk         ;f956 cd 80 fa   cd 80 fa    . . .
    pop af              ;f959 f1   f1  .
    ret                 ;f95a c9   c9  .
lf95bh:
    push hl             ;f95b e5   e5  .
    ld hl,lfa52h        ;f95c 21 52 fa   21 52 fa    ! R .
    ld c,06h            ;f95f 0e 06   0e 06   . .
    ld a,(0045h)        ;f961 3a 45 00   3a 45 00    : E .
    call diskcmd        ;f964 cd 20 fa   cd 20 fa    .   .
    call ieeemsg        ;f967 cd 63 fe   cd 63 fe    . c .
    pop hl              ;f96a e1   e1  .
    ld a,(hl)           ;f96b 7e   7e  ~
    push hl             ;f96c e5   e5  .
    call wreoi          ;f96d cd 4f fe   cd 4f fe    . O .
    call unlisten       ;f970 cd a6 fa   cd a6 fa    . . .
    ld hl,0fa4bh        ;f973 21 4b fa   21 4b fa    ! K .
    ld c,07h            ;f976 0e 07   0e 07   . .
    ld a,(0045h)        ;f978 3a 45 00   3a 45 00    : E .
    call diskcmd        ;f97b cd 20 fa   cd 20 fa    .   .
    call ieeemsg        ;f97e cd 63 fe   cd 63 fe    . c .
    call creoi          ;f981 cd 4d fe   cd 4d fe    . M .
    call unlisten       ;f984 cd a6 fa   cd a6 fa    . . .
    ld a,(0045h)        ;f987 3a 45 00   3a 45 00    : E .
    call dskdev         ;f98a cd 11 fa   cd 11 fa    . . .
    ld e,02h            ;f98d 1e 02   1e 02   . .
    call listen         ;f98f cd 90 fa   cd 90 fa    . . .
    pop hl              ;f992 e1   e1  .
    inc hl              ;f993 23   23  #
    ld c,0ffh           ;f994 0e ff   0e ff   . .
    call ieeemsg        ;f996 cd 63 fe   cd 63 fe    . c .
    call unlisten       ;f999 cd a6 fa   cd a6 fa    . . .
    ld hl,lf7bbh+1      ;f99c 21 bc f7   21 bc f7    ! . .
    jp lf5c2h           ;f99f c3 c2 f5   c3 c2 f5    . . .
lf9a2h:
    push hl             ;f9a2 e5   e5  .
    ld hl,lf7b7h        ;f9a3 21 b7 f7   21 b7 f7    ! . .
    call lf5c2h         ;f9a6 cd c2 f5   cd c2 f5    . . .
    ld hl,0fa58h        ;f9a9 21 58 fa   21 58 fa    ! X .
    ld c,05h            ;f9ac 0e 05   0e 05   . .
    ld a,(0045h)        ;f9ae 3a 45 00   3a 45 00    : E .
    call diskcmd        ;f9b1 cd 20 fa   cd 20 fa    .   .
    call ieeemsg        ;f9b4 cd 63 fe   cd 63 fe    . c .
    call creoi          ;f9b7 cd 4d fe   cd 4d fe    . M .
    call unlisten       ;f9ba cd a6 fa   cd a6 fa    . . .
    ld a,(0045h)        ;f9bd 3a 45 00   3a 45 00    : E .
    call dskdev         ;f9c0 cd 11 fa   cd 11 fa    . . .
    ld e,0fh            ;f9c3 1e 0f   1e 0f   . .
    call talk           ;f9c5 cd 5d fa   cd 5d fa    . ] .
    call rdieee         ;f9c8 cd 1c fe   cd 1c fe    . . .
    pop hl              ;f9cb e1   e1  .
    ld (hl),a           ;f9cc 77   77  w
    push hl             ;f9cd e5   e5  .
    call untalk         ;f9ce cd 80 fa   cd 80 fa    . . .
    ld a,(0045h)        ;f9d1 3a 45 00   3a 45 00    : E .
    call diskcmd        ;f9d4 cd 20 fa   cd 20 fa    .   .
    ld hl,0fa4bh        ;f9d7 21 4b fa   21 4b fa    ! K .
    ld c,07h            ;f9da 0e 07   0e 07   . .
    call ieeemsg        ;f9dc cd 63 fe   cd 63 fe    . c .
    call creoi          ;f9df cd 4d fe   cd 4d fe    . M .
    call unlisten       ;f9e2 cd a6 fa   cd a6 fa    . . .
    ld a,(0045h)        ;f9e5 3a 45 00   3a 45 00    : E .
    call disksta        ;f9e8 cd 20 f9   cd 20 f9    .   .
    cp 46h              ;f9eb fe 46   fe 46   . F
    jr z,lfa08h         ;f9ed 28 19   28 19   ( .
    ld a,(0045h)        ;f9ef 3a 45 00   3a 45 00    : E .
    call dskdev         ;f9f2 cd 11 fa   cd 11 fa    . . .
    ld e,02h            ;f9f5 1e 02   1e 02   . .
    call talk           ;f9f7 cd 5d fa   cd 5d fa    . ] .
    pop de              ;f9fa d1   d1  .
    inc de              ;f9fb 13   13  .
    ld b,0ffh           ;f9fc 06 ff   06 ff   . .
lf9feh:
    call rdieee         ;f9fe cd 1c fe   cd 1c fe    . . .
    ld (de),a           ;fa01 12   12  .
    inc de              ;fa02 13   13  .
    djnz lf9feh         ;fa03 10 f9   10 f9   . .
    jp untalk           ;fa05 c3 80 fa   c3 80 fa    . . .
lfa08h:
    ld a,(0045h)        ;fa08 3a 45 00   3a 45 00    : E .
    call idrive         ;fa0b cd 28 fa   cd 28 fa    . ( .
    pop hl              ;fa0e e1   e1  .
    jr lf9a2h           ;fa0f 18 91   18 91   . .
dskdev:
    push hl             ;fa11 e5   e5  .
    push af             ;fa12 f5   f5  .
    or a                ;fa13 b7   b7  .
    rra                 ;fa14 1f   1f  .
    ld e,a              ;fa15 5f   5f  _
    ld d,00h            ;fa16 16 00   16 00   . .
    ld hl,0ea78h        ;fa18 21 78 ea   21 78 ea    ! x .
    add hl,de           ;fa1b 19   19  .
    ld d,(hl)           ;fa1c 56   56  V
    pop af              ;fa1d f1   f1  .
    pop hl              ;fa1e e1   e1  .
    ret                 ;fa1f c9   c9  .
diskcmd:
    call dskdev         ;fa20 cd 11 fa   cd 11 fa    . . .
    ld e,0fh            ;fa23 1e 0f   1e 0f   . .
    jp listen           ;fa25 c3 90 fa   c3 90 fa    . . .
idrive:
    call dskdev         ;fa28 cd 11 fa   cd 11 fa    . . .
    ld e,0fh            ;fa2b 1e 0f   1e 0f   . .
    push de             ;fa2d d5   d5  .
    ld c,02h            ;fa2e 0e 02   0e 02   . .
    ld hl,lfa47h        ;fa30 21 47 fa   21 47 fa    ! G .
    rra                 ;fa33 1f   1f  .
    jr nc,lfa39h        ;fa34 30 03   30 03   0 .
    ld hl,0fa49h        ;fa36 21 49 fa   21 49 fa    ! I .
lfa39h:
    call open           ;fa39 cd b5 fa   cd b5 fa    . . .
    pop de              ;fa3c d1   d1  .
    ld e,02h            ;fa3d 1e 02   1e 02   . .
    ld c,02h            ;fa3f 0e 02   0e 02   . .
    ld hl,lf564h        ;fa41 21 64 f5   21 64 f5    ! d .
    jp open             ;fa44 c3 b5 fa   c3 b5 fa    . . .
lfa47h:
    ld c,c              ;fa47 49   49  I
    jr nc,$+75          ;fa48 30 49   30 49   0 I
    ld sp,2d42h         ;fa4a 31 42 2d   31 42 2d    1 B -
    ld d,b              ;fa4d 50   50  P
    jr nz,lfa82h        ;fa4e 20 32   20 32     2
    jr nz,$+51          ;fa50 20 31   20 31     1
lfa52h:
    ld c,l              ;fa52 4d   4d  M
    dec l               ;fa53 2d   2d  -
    ld d,a              ;fa54 57   57  W
    nop                 ;fa55 00   00  .
    inc de              ;fa56 13   13  .
    ld bc,2d4dh         ;fa57 01 4d 2d   01 4d 2d    . M -
    ld d,d              ;fa5a 52   52  R
    nop                 ;fa5b 00   00  .
    inc de              ;fa5c 13   13  .
talk:
    in a,(15h)          ;fa5d db 15   db 15   . .
    or 01h              ;fa5f f6 01   f6 01   . .
    out (15h),a         ;fa61 d3 15   d3 15   . .
    ld a,40h            ;fa63 3e 40   3e 40   > @
    or d                ;fa65 b2   b2  .
    call wrieee         ;fa66 cd a6 fd   cd a6 fd    . . .
    jr c,lfa77h         ;fa69 38 0c   38 0c   8 .
    ld a,e              ;fa6b 7b   7b  {
    or 60h              ;fa6c f6 60   f6 60   . `
    call p,wrieee       ;fa6e f4 a6 fd   f4 a6 fd    . . .
    in a,(15h)          ;fa71 db 15   db 15   . .
    or 0ch              ;fa73 f6 0c   f6 0c   . .
    out (15h),a         ;fa75 d3 15   d3 15   . .
lfa77h:
    push af             ;fa77 f5   f5  .
    in a,(15h)          ;fa78 db 15   db 15   . .
    and 0feh            ;fa7a e6 fe   e6 fe   . .
    out (15h),a         ;fa7c d3 15   d3 15   . .
    pop af              ;fa7e f1   f1  .
    ret                 ;fa7f c9   c9  .
untalk:
    in a,(15h)          ;fa80 db 15   db 15   . .
lfa82h:
    or 01h              ;fa82 f6 01   f6 01   . .
    out (15h),a         ;fa84 d3 15   d3 15   . .
    in a,(15h)          ;fa86 db 15   db 15   . .
    and 0f3h            ;fa88 e6 f3   e6 f3   . .
    out (15h),a         ;fa8a d3 15   d3 15   . .
    ld a,5fh            ;fa8c 3e 5f   3e 5f   > _
    jr wratn            ;fa8e 18 18   18 18   . .
listen:
    in a,(15h)          ;fa90 db 15   db 15   . .
    or 01h              ;fa92 f6 01   f6 01   . .
    out (15h),a         ;fa94 d3 15   d3 15   . .
    ld a,20h            ;fa96 3e 20   3e 20   >
    or d                ;fa98 b2   b2  .
    call wrieee         ;fa99 cd a6 fd   cd a6 fd    . . .
    jr c,lfa77h         ;fa9c 38 d9   38 d9   8 .
    ld a,e              ;fa9e 7b   7b  {
    or 60h              ;fa9f f6 60   f6 60   . `
    call p,wrieee       ;faa1 f4 a6 fd   f4 a6 fd    . . .
    jr lfa77h           ;faa4 18 d1   18 d1   . .
unlisten:
    ld a,3fh            ;faa6 3e 3f   3e 3f   > ?
wratn:
    push af             ;faa8 f5   f5  .
    in a,(15h)          ;faa9 db 15   db 15   . .
    or 01h              ;faab f6 01   f6 01   . .
    out (15h),a         ;faad d3 15   d3 15   . .
    pop af              ;faaf f1   f1  .
    call wrieee         ;fab0 cd a6 fd   cd a6 fd    . . .
    jr lfa77h           ;fab3 18 c2   18 c2   . .
open:
    in a,(15h)          ;fab5 db 15   db 15   . .
    or 01h              ;fab7 f6 01   f6 01   . .
    out (15h),a         ;fab9 d3 15   d3 15   . .
    ld a,d              ;fabb 7a   7a  z
    or 20h              ;fabc f6 20   f6 20   .
    call wrieee         ;fabe cd a6 fd   cd a6 fd    . . .
    ld a,e              ;fac1 7b   7b  {
    or 0f0h             ;fac2 f6 f0   f6 f0   . .
    call wratn          ;fac4 cd a8 fa   cd a8 fa    . . .
    dec c               ;fac7 0d   0d  .
    call nz,ieeemsg     ;fac8 c4 63 fe   c4 63 fe    . c .
    ld a,(hl)           ;facb 7e   7e  ~
    call wreoi          ;facc cd 4f fe   cd 4f fe    . O .
    jr unlisten         ;facf 18 d5   18 d5   . .
close:
    in a,(15h)          ;fad1 db 15   db 15   . .
    or 01h              ;fad3 f6 01   f6 01   . .
    out (15h),a         ;fad5 d3 15   d3 15   . .
    ld a,d              ;fad7 7a   7a  z
    or 20h              ;fad8 f6 20   f6 20   .
    call wrieee         ;fada cd a6 fd   cd a6 fd    . . .
    ld a,e              ;fadd 7b   7b  {
    or 0e0h             ;fade f6 e0   f6 e0   . .
    call wrieee         ;fae0 cd a6 fd   cd a6 fd    . . .
    jr unlisten         ;fae3 18 c1   18 c1   . .
delay:
    call sub_faeeh      ;fae5 cd ee fa   cd ee fa    . . .
    dec bc              ;fae8 0b   0b  .
    ld a,b              ;fae9 78   78  x
    or c                ;faea b1   b1  .
    jr nz,delay         ;faeb 20 f8   20 f8     .
    ret                 ;faed c9   c9  .
sub_faeeh:
    push bc             ;faee c5   c5  .
    ld b,0c8h           ;faef 06 c8   06 c8   . .
lfaf1h:
    add a,00h           ;faf1 c6 00   c6 00   . .
    djnz lfaf1h         ;faf3 10 fc   10 fc   . .
    pop bc              ;faf5 c1   c1  .
    ret                 ;faf6 c9   c9  .
conin:
    ld a,(0003h)        ;faf7 3a 03 00   3a 03 00    : . .
    rra                 ;fafa 1f   1f  .
    jp nc,lfbd6h        ;fafb d2 d6 fb   d2 d6 fb    . . .
    in a,(15h)          ;fafe db 15   db 15   . .
    or 04h              ;fb00 f6 04   f6 04   . .
    out (15h),a         ;fb02 d3 15   d3 15   . .
    ld a,02h            ;fb04 3e 02   3e 02   > .
    call sub_fbdfh      ;fb06 cd df fb   cd df fb    . . .
    call rdieee         ;fb09 cd 1c fe   cd 1c fe    . . .
    push af             ;fb0c f5   f5  .
    in a,(15h)          ;fb0d db 15   db 15   . .
    and 0f3h            ;fb0f e6 f3   e6 f3   . .
    out (15h),a         ;fb11 d3 15   d3 15   . .
    pop af              ;fb13 f1   f1  .
    ret                 ;fb14 c9   c9  .
const:
    ld a,(0003h)        ;fb15 3a 03 00   3a 03 00    : . .
    rra                 ;fb18 1f   1f  .
    jp nc,lfbc3h        ;fb19 d2 c3 fb   d2 c3 fb    . . .
    ld a,01h            ;fb1c 3e 01   3e 01   > .
    call sub_fbdfh      ;fb1e cd df fb   cd df fb    . . .
    ld a,00h            ;fb21 3e 00   3e 00   > .
    ret nc              ;fb23 d0   d0  .
    ld a,0ffh           ;fb24 3e ff   3e ff   > .
    ret                 ;fb26 c9   c9  .
conout:
    ld a,(0003h)        ;fb27 3a 03 00   3a 03 00    : . .
    rra                 ;fb2a 1f   1f  .
    jp nc,lfbcbh        ;fb2b d2 cb fb   d2 cb fb    . . .
    ld a,(005ah)        ;fb2e 3a 5a 00   3a 5a 00    : Z .
    or a                ;fb31 b7   b7  .
    jp nz,lfb7ch        ;fb32 c2 7c fb   c2 7c fb    . | .
    ld a,c              ;fb35 79   79  y
    rla                 ;fb36 17   17  .
    jr c,lfb6dh         ;fb37 38 34   38 34   8 4
    ld a,(0ea68h)       ;fb39 3a 68 ea   3a 68 ea    : h .
    cp c                ;fb3c b9   b9  .
    jr nz,lfb45h        ;fb3d 20 06   20 06     .
    ld a,01h            ;fb3f 3e 01   3e 01   > .
    ld (0059h),a        ;fb41 32 59 00   32 59 00    2 Y .
    ret                 ;fb44 c9   c9  .
lfb45h:
    ld a,(0059h)        ;fb45 3a 59 00   3a 59 00    : Y .
    or a                ;fb48 b7   b7  .
    jp z,lfb52h         ;fb49 ca 52 fb   ca 52 fb    . R .
    xor a               ;fb4c af   af  .
    ld (0059h),a        ;fb4d 32 59 00   32 59 00    2 Y .
    set 7,c             ;fb50 cb f9   cb f9   . .
lfb52h:
    ld a,c              ;fb52 79   79  y
    cp 20h              ;fb53 fe 20   fe 20   .
    jr c,lfb5bh         ;fb55 38 04   38 04   8 .
    cp 7bh              ;fb57 fe 7b   fe 7b   . {
    jr c,lfb6dh         ;fb59 38 12   38 12   8 .
lfb5bh:
    ld hl,0ea80h        ;fb5b 21 80 ea   21 80 ea    ! . .
lfb5eh:
    ld a,(hl)           ;fb5e 7e   7e  ~
    inc hl              ;fb5f 23   23  #
    or a                ;fb60 b7   b7  .
    jr z,lfb6dh         ;fb61 28 0a   28 0a   ( .
    cp c                ;fb63 b9   b9  .
    ld a,(hl)           ;fb64 7e   7e  ~
    inc hl              ;fb65 23   23  #
    jr nz,lfb5eh        ;fb66 20 f6   20 f6     .
    cp 1bh              ;fb68 fe 1b   fe 1b   . .
    jr z,lfb76h         ;fb6a 28 0a   28 0a   ( .
    ld c,a              ;fb6c 4f   4f  O
lfb6dh:
    ld a,04h            ;fb6d 3e 04   3e 04   > .
    call sub_fbdfh      ;fb6f cd df fb   cd df fb    . . .
    ld a,c              ;fb72 79   79  y
    jp lfde5h           ;fb73 c3 e5 fd   c3 e5 fd    . . .
lfb76h:
    ld a,02h            ;fb76 3e 02   3e 02   > .
    ld (005ah),a        ;fb78 32 5a 00   32 5a 00    2 Z .
    ret                 ;fb7b c9   c9  .
lfb7ch:
    dec a               ;fb7c 3d   3d  =
    ld (005ah),a        ;fb7d 32 5a 00   32 5a 00    2 Z .
    jr z,lfb87h         ;fb80 28 05   28 05   ( .
    ld a,c              ;fb82 79   79  y
    ld (005bh),a        ;fb83 32 5b 00   32 5b 00    2 [ .
    ret                 ;fb86 c9   c9  .
lfb87h:
    ld a,(005bh)        ;fb87 3a 5b 00   3a 5b 00    : [ .
    ld d,a              ;fb8a 57   57  W
    ld e,c              ;fb8b 59   59  Y
    ld a,(0ea69h)       ;fb8c 3a 69 ea   3a 69 ea    : i .
    or a                ;fb8f b7   b7  .
    jr z,lfb95h         ;fb90 28 03   28 03   ( .
    ld a,e              ;fb92 7b   7b  {
    ld e,d              ;fb93 5a   5a  Z
    ld d,a              ;fb94 57   57  W
lfb95h:
    ld a,(0003h)        ;fb95 3a 03 00   3a 03 00    : . .
    and 03h             ;fb98 e6 03   e6 03   . .
    cp 01h              ;fb9a fe 01   fe 01   . .
    ret nz              ;fb9c c0   c0  .
    push de             ;fb9d d5   d5  .
    ld c,1bh            ;fb9e 0e 1b   0e 1b   . .
    call lfb6dh         ;fba0 cd 6d fb   cd 6d fb    . m .
    pop de              ;fba3 d1   d1  .
    push de             ;fba4 d5   d5  .
    ld a,e              ;fba5 7b   7b  {
    ld hl,0ea6bh        ;fba6 21 6b ea   21 6b ea    ! k .
    sub (hl)            ;fba9 96   96  .
    cp 60h              ;fbaa fe 60   fe 60   . `
    jr c,lfbb0h         ;fbac 38 02   38 02   8 .
    sub 60h             ;fbae d6 60   d6 60   . `
lfbb0h:
    add a,20h           ;fbb0 c6 20   c6 20   .
    ld c,a              ;fbb2 4f   4f  O
    call lfb6dh         ;fbb3 cd 6d fb   cd 6d fb    . m .
    pop af              ;fbb6 f1   f1  .
    ld hl,0ea6ah        ;fbb7 21 6a ea   21 6a ea    ! j .
    sub (hl)            ;fbba 96   96  .
    and 1fh             ;fbbb e6 1f   e6 1f   . .
    or 20h              ;fbbd f6 20   f6 20   .
    ld c,a              ;fbbf 4f   4f  O
    jp lfb6dh           ;fbc0 c3 6d fb   c3 6d fb    . m .
lfbc3h:
    in a,(09h)          ;fbc3 db 09   db 09   . .
    and 02h             ;fbc5 e6 02   e6 02   . .
    ret z               ;fbc7 c8   c8  .
    or 0ffh             ;fbc8 f6 ff   f6 ff   . .
    ret                 ;fbca c9   c9  .
lfbcbh:
    in a,(09h)          ;fbcb db 09   db 09   . .
    cpl                 ;fbcd 2f   2f  /
    and 84h             ;fbce e6 84   e6 84   . .
    jr nz,lfbcbh        ;fbd0 20 f9   20 f9     .
    ld a,c              ;fbd2 79   79  y
    out (08h),a         ;fbd3 d3 08   d3 08   . .
    ret                 ;fbd5 c9   c9  .
lfbd6h:
    in a,(09h)          ;fbd6 db 09   db 09   . .
    and 02h             ;fbd8 e6 02   e6 02   . .
    jr z,lfbd6h         ;fbda 28 fa   28 fa   ( .
    in a,(08h)          ;fbdc db 08   db 08   . .
    ret                 ;fbde c9   c9  .
sub_fbdfh:
    push af             ;fbdf f5   f5  .
lfbe0h:
    in a,(10h)          ;fbe0 db 10   db 10   . .
    or a                ;fbe2 b7   b7  .
    jr nz,lfbe0h        ;fbe3 20 fb   20 fb     .
    pop af              ;fbe5 f1   f1  .
    out (11h),a         ;fbe6 d3 11   d3 11   . .
    in a,(15h)          ;fbe8 db 15   db 15   . .
    or 20h              ;fbea f6 20   f6 20   .
    out (15h),a         ;fbec d3 15   d3 15   . .
    in a,(15h)          ;fbee db 15   db 15   . .
    and 0dfh            ;fbf0 e6 df   e6 df   . .
    out (15h),a         ;fbf2 d3 15   d3 15   . .
lfbf4h:
    in a,(10h)          ;fbf4 db 10   db 10   . .
    and 0c0h            ;fbf6 e6 c0   e6 c0   . .
    jr z,lfbf4h         ;fbf8 28 fa   28 fa   ( .
    rla                 ;fbfa 17   17  .
    push af             ;fbfb f5   f5  .
    ld a,00h            ;fbfc 3e 00   3e 00   > .
    out (11h),a         ;fbfe d3 11   d3 11   . .
lfc00h:
    in a,(10h)          ;fc00 db 10   db 10   . .
    or a                ;fc02 b7   b7  .
    jr nz,lfc00h        ;fc03 20 fb   20 fb     .
    pop af              ;fc05 f1   f1  .
    ret                 ;fc06 c9   c9  .
list:
    ld a,(0003h)        ;fc07 3a 03 00   3a 03 00    : . .
    and 0c0h            ;fc0a e6 c0   e6 c0   . .
    jp z,lfbcbh         ;fc0c ca cb fb   ca cb fb    . . .
    jp p,lfb6dh         ;fc0f f2 6d fb   f2 6d fb    . m .
    ld e,0ffh           ;fc12 1e ff   1e ff   . .
    and 40h             ;fc14 e6 40   e6 40   . @
    jr z,lfc22h         ;fc16 28 0a   28 0a   ( .
    ld a,(0ea66h)       ;fc18 3a 66 ea   3a 66 ea    : f .
    ld d,a              ;fc1b 57   57  W
    call listen         ;fc1c cd 90 fa   cd 90 fa    . . .
    jp lfcd0h           ;fc1f c3 d0 fc   c3 d0 fc    . . .
lfc22h:
    ld a,(0ea61h)       ;fc22 3a 61 ea   3a 61 ea    : a .
    ld d,a              ;fc25 57   57  W
    in a,(15h)          ;fc26 db 15   db 15   . .
    or 01h              ;fc28 f6 01   f6 01   . .
    out (15h),a         ;fc2a d3 15   d3 15   . .
    call sub_faeeh      ;fc2c cd ee fa   cd ee fa    . . .
    call listen         ;fc2f cd 90 fa   cd 90 fa    . . .
    ld hl,0051h         ;fc32 21 51 00   21 51 00    ! Q .
    ld a,(hl)           ;fc35 7e   7e  ~
    ld (hl),c           ;fc36 71   71  q
    cp 0ah              ;fc37 fe 0a   fe 0a   . .
    jr z,lfc4ch         ;fc39 28 11   28 11   ( .
    cp 0dh              ;fc3b fe 0d   fe 0d   . .
    jr nz,lfc54h        ;fc3d 20 15   20 15     .
    ld a,c              ;fc3f 79   79  y
    cp 0ah              ;fc40 fe 0a   fe 0a   . .
    jr z,lfc54h         ;fc42 28 10   28 10   ( .
    call sub_faeeh      ;fc44 cd ee fa   cd ee fa    . . .
    ld a,8dh            ;fc47 3e 8d   3e 8d   > .
    call wrieee         ;fc49 cd a6 fd   cd a6 fd    . . .
lfc4ch:
    ld a,11h            ;fc4c 3e 11   3e 11   > .
    call sub_faeeh      ;fc4e cd ee fa   cd ee fa    . . .
    call wrieee         ;fc51 cd a6 fd   cd a6 fd    . . .
lfc54h:
    ld a,c              ;fc54 79   79  y
    cp 5fh              ;fc55 fe 5f   fe 5f   . _
    jr nz,lfc5bh        ;fc57 20 02   20 02     .
    ld a,0a4h           ;fc59 3e a4   3e a4   > .
lfc5bh:
    cp 0dh              ;fc5b fe 0d   fe 0d   . .
    jr z,lfc6eh         ;fc5d 28 0f   28 0f   ( .
    cp 0ah              ;fc5f fe 0a   fe 0a   . .
    jr nz,lfc65h        ;fc61 20 02   20 02     .
    ld a,0dh            ;fc63 3e 0d   3e 0d   > .
lfc65h:
    call sub_fcafh      ;fc65 cd af fc   cd af fc    . . .
    call sub_faeeh      ;fc68 cd ee fa   cd ee fa    . . .
    call wrieee         ;fc6b cd a6 fd   cd a6 fd    . . .
lfc6eh:
    in a,(15h)          ;fc6e db 15   db 15   . .
    or 01h              ;fc70 f6 01   f6 01   . .
    out (15h),a         ;fc72 d3 15   d3 15   . .
    jp unlisten         ;fc74 c3 a6 fa   c3 a6 fa    . . .
listst:
    ld a,(0003h)        ;fc77 3a 03 00   3a 03 00    : . .
    and 0c0h            ;fc7a e6 c0   e6 c0   . .
    jr z,lfca5h         ;fc7c 28 27   28 27   ( '
    rla                 ;fc7e 17   17  .
    ld a,0ffh           ;fc7f 3e ff   3e ff   > .
    ret nc              ;fc81 d0   d0  .
    ld a,(0003h)        ;fc82 3a 03 00   3a 03 00    : . .
    and 40h             ;fc85 e6 40   e6 40   . @
    ld a,(0ea61h)       ;fc87 3a 61 ea   3a 61 ea    : a .
    jr z,lfc8fh         ;fc8a 28 03   28 03   ( .
    ld a,(0ea66h)       ;fc8c 3a 66 ea   3a 66 ea    : f .
lfc8fh:
    ld d,a              ;fc8f 57   57  W
    ld e,0ffh           ;fc90 1e ff   1e ff   . .
    call listen         ;fc92 cd 90 fa   cd 90 fa    . . .
    call sub_faeeh      ;fc95 cd ee fa   cd ee fa    . . .
    in a,(14h)          ;fc98 db 14   db 14   . .
    cpl                 ;fc9a 2f   2f  /
    and 08h             ;fc9b e6 08   e6 08   . .
    push af             ;fc9d f5   f5  .
    call unlisten       ;fc9e cd a6 fa   cd a6 fa    . . .
    pop af              ;fca1 f1   f1  .
    ret z               ;fca2 c8   c8  .
    dec a               ;fca3 3d   3d  =
    ret                 ;fca4 c9   c9  .
lfca5h:
    in a,(09h)          ;fca5 db 09   db 09   . .
    cpl                 ;fca7 2f   2f  /
    and 84h             ;fca8 e6 84   e6 84   . .
    ld a,0ffh           ;fcaa 3e ff   3e ff   > .
    ret z               ;fcac c8   c8  .
    inc a               ;fcad 3c   3c  <
    ret                 ;fcae c9   c9  .
sub_fcafh:
    cp 41h              ;fcaf fe 41   fe 41   . A
    ret c               ;fcb1 d8   d8  .
    cp 60h              ;fcb2 fe 60   fe 60   . `
    jr c,lfcbch         ;fcb4 38 06   38 06   8 .
    cp 7bh              ;fcb6 fe 7b   fe 7b   . {
    ret nc              ;fcb8 d0   d0  .
    xor 20h             ;fcb9 ee 20   ee 20   .
    ret                 ;fcbb c9   c9  .
lfcbch:
    xor 80h             ;fcbc ee 80   ee 80   . .
    ret                 ;fcbe c9   c9  .
punch:
    ld a,(0003h)        ;fcbf 3a 03 00   3a 03 00    : . .
    and 30h             ;fcc2 e6 30   e6 30   . 0
    jp z,lfbcbh         ;fcc4 ca cb fb   ca cb fb    . . .
    ld de,(0ea63h)      ;fcc7 ed 5b 63 ea   ed 5b 63 ea     . [ c .
    ld e,0ffh           ;fccb 1e ff   1e ff   . .
    call listen         ;fccd cd 90 fa   cd 90 fa    . . .
lfcd0h:
    ld a,c              ;fcd0 79   79  y
    call wrieee         ;fcd1 cd a6 fd   cd a6 fd    . . .
    jp unlisten         ;fcd4 c3 a6 fa   c3 a6 fa    . . .
reader:
    ld a,(0003h)        ;fcd7 3a 03 00   3a 03 00    : . .
    and 0ch             ;fcda e6 0c   e6 0c   . .
    jp z,lfbd6h         ;fcdc ca d6 fb   ca d6 fb    . . .
    ld de,(0ea62h)      ;fcdf ed 5b 62 ea   ed 5b 62 ea     . [ b .
    ld e,0ffh           ;fce3 1e ff   1e ff   . .
    call talk           ;fce5 cd 5d fa   cd 5d fa    . ] .
    call rdieee         ;fce8 cd 1c fe   cd 1c fe    . . .
    push af             ;fceb f5   f5  .
    call untalk         ;fcec cd 80 fa   cd 80 fa    . . .
    pop af              ;fcef f1   f1  .
    ret                 ;fcf0 c9   c9  .
sub_fcf1h:
    ld a,(hl)           ;fcf1 7e   7e  ~
    or a                ;fcf2 b7   b7  .
    ret z               ;fcf3 c8   c8  .
    push hl             ;fcf4 e5   e5  .
    ld c,a              ;fcf5 4f   4f  O
    call conout         ;fcf6 cd 27 fb   cd 27 fb    . ' .
    pop hl              ;fcf9 e1   e1  .
    inc hl              ;fcfa 23   23  #
    jr sub_fcf1h        ;fcfb 18 f4   18 f4   . .
clear:
    ld a,(0003h)        ;fcfd 3a 03 00   3a 03 00    : . .
    rra                 ;fd00 1f   1f  .
    ret nc              ;fd01 d0   d0  .
    ld c,1ah            ;fd02 0e 1a   0e 1a   . .
    jp lfb6dh           ;fd04 c3 6d fb   c3 6d fb    . m .
execute:
    ld a,08h            ;fd07 3e 08   3e 08   > .
    call sub_fbdfh      ;fd09 cd df fb   cd df fb    . . .
    ld a,l              ;fd0c 7d   7d  }
    call wrieee         ;fd0d cd a6 fd   cd a6 fd    . . .
    ld a,h              ;fd10 7c   7c  |
    jp wrieee           ;fd11 c3 a6 fd   c3 a6 fd    . . .
peek:
    ld a,10h            ;fd14 3e 10   3e 10   > .
    call sub_fbdfh      ;fd16 cd df fb   cd df fb    . . .
    ld a,c              ;fd19 79   79  y
    call lfde5h         ;fd1a cd e5 fd   cd e5 fd    . . .
    ld a,b              ;fd1d 78   78  x
    call lfde5h         ;fd1e cd e5 fd   cd e5 fd    . . .
    ld a,e              ;fd21 7b   7b  {
    call lfde5h         ;fd22 cd e5 fd   cd e5 fd    . . .
    ld a,d              ;fd25 7a   7a  z
    call lfde5h         ;fd26 cd e5 fd   cd e5 fd    . . .
    in a,(15h)          ;fd29 db 15   db 15   . .
    or 04h              ;fd2b f6 04   f6 04   . .
    out (15h),a         ;fd2d d3 15   d3 15   . .
lfd2fh:
    call rdieee         ;fd2f cd 1c fe   cd 1c fe    . . .
    ld (hl),a           ;fd32 77   77  w
    inc hl              ;fd33 23   23  #
    dec bc              ;fd34 0b   0b  .
    ld a,b              ;fd35 78   78  x
    or c                ;fd36 b1   b1  .
    jr nz,lfd2fh        ;fd37 20 f6   20 f6     .
    in a,(15h)          ;fd39 db 15   db 15   . .
    and 0f3h            ;fd3b e6 f3   e6 f3   . .
    out (15h),a         ;fd3d d3 15   d3 15   . .
    ret                 ;fd3f c9   c9  .
poke:
    ld a,20h            ;fd40 3e 20   3e 20   >
    call sub_fbdfh      ;fd42 cd df fb   cd df fb    . . .
    ld a,c              ;fd45 79   79  y
    call lfde5h         ;fd46 cd e5 fd   cd e5 fd    . . .
    ld a,b              ;fd49 78   78  x
    call lfde5h         ;fd4a cd e5 fd   cd e5 fd    . . .
    ld a,e              ;fd4d 7b   7b  {
    call lfde5h         ;fd4e cd e5 fd   cd e5 fd    . . .
    ld a,d              ;fd51 7a   7a  z
    call lfde5h         ;fd52 cd e5 fd   cd e5 fd    . . .
lfd55h:
    ld a,(hl)           ;fd55 7e   7e  ~
    call lfde5h         ;fd56 cd e5 fd   cd e5 fd    . . .
    inc hl              ;fd59 23   23  #
    dec bc              ;fd5a 0b   0b  .
    ld a,b              ;fd5b 78   78  x
    or c                ;fd5c b1   b1  .
    jr nz,lfd55h        ;fd5d 20 f6   20 f6     .
    ret                 ;fd5f c9   c9  .
settime:
    ld e,00h            ;fd60 1e 00   1e 00   . .
    ld (0ea41h),de      ;fd62 ed 53 41 ea   ed 53 41 ea     . S A .
    ld (0ea43h),hl      ;fd66 22 43 ea   22 43 ea    " C .
    ld de,0014h         ;fd69 11 14 00   11 14 00    . . .
    ld hl,0ea41h        ;fd6c 21 41 ea   21 41 ea    ! A .
    ld bc,0004h         ;fd6f 01 04 00   01 04 00    . . .
    jp poke             ;fd72 c3 40 fd   c3 40 fd    . @ .
resclk:
    xor a               ;fd75 af   af  .
    ld (0ea45h),a       ;fd76 32 45 ea   32 45 ea    2 E .
    ld (0ea46h),a       ;fd79 32 46 ea   32 46 ea    2 F .
    ld (0ea47h),a       ;fd7c 32 47 ea   32 47 ea    2 G .
    ld hl,0ea45h        ;fd7f 21 45 ea   21 45 ea    ! E .
    ld de,0018h         ;fd82 11 18 00   11 18 00    . . .
    ld bc,0003h         ;fd85 01 03 00   01 03 00    . . .
    jp poke             ;fd88 c3 40 fd   c3 40 fd    . @ .
gettime:
    ld bc,0007h         ;fd8b 01 07 00   01 07 00    . . .
    ld hl,0ea41h        ;fd8e 21 41 ea   21 41 ea    ! A .
    ld de,0014h         ;fd91 11 14 00   11 14 00    . . .
    call peek           ;fd94 cd 14 fd   cd 14 fd    . . .
    ld de,(0ea41h)      ;fd97 ed 5b 41 ea   ed 5b 41 ea     . [ A .
    ld hl,(0ea43h)      ;fd9b 2a 43 ea   2a 43 ea    * C .
    ld a,(0ea45h)       ;fd9e 3a 45 ea   3a 45 ea    : E .
    ld bc,(0ea46h)      ;fda1 ed 4b 46 ea   ed 4b 46 ea     . K F .
    ret                 ;fda5 c9   c9  .
wrieee:
    push af             ;fda6 f5   f5  .
lfda7h:
    in a,(14h)          ;fda7 db 14   db 14   . .
    cpl                 ;fda9 2f   2f  /
    and 08h             ;fdaa e6 08   e6 08   . .
    jr z,lfda7h         ;fdac 28 f9   28 f9   ( .
    in a,(14h)          ;fdae db 14   db 14   . .
    cpl                 ;fdb0 2f   2f  /
    and 04h             ;fdb1 e6 04   e6 04   . .
    jr nz,lfde2h        ;fdb3 20 2d   20 2d     -
    pop af              ;fdb5 f1   f1  .
    out (11h),a         ;fdb6 d3 11   d3 11   . .
    in a,(15h)          ;fdb8 db 15   db 15   . .
    or 02h              ;fdba f6 02   f6 02   . .
    out (15h),a         ;fdbc d3 15   d3 15   . .
lfdbeh:
    in a,(14h)          ;fdbe db 14   db 14   . .
    cpl                 ;fdc0 2f   2f  /
    and 04h             ;fdc1 e6 04   e6 04   . .
    jr z,lfdbeh         ;fdc3 28 f9   28 f9   ( .
    in a,(15h)          ;fdc5 db 15   db 15   . .
    and 0fdh            ;fdc7 e6 fd   e6 fd   . .
    out (15h),a         ;fdc9 d3 15   d3 15   . .
    xor a               ;fdcb af   af  .
    out (11h),a         ;fdcc d3 11   d3 11   . .
lfdceh:
    in a,(14h)          ;fdce db 14   db 14   . .
    cpl                 ;fdd0 2f   2f  /
    and 04h             ;fdd1 e6 04   e6 04   . .
    jr nz,lfdceh        ;fdd3 20 f9   20 f9     .
    ex (sp),hl          ;fdd5 e3   e3  .
    ex (sp),hl          ;fdd6 e3   e3  .
    ex (sp),hl          ;fdd7 e3   e3  .
    ex (sp),hl          ;fdd8 e3   e3  .
    in a,(14h)          ;fdd9 db 14   db 14   . .
    cpl                 ;fddb 2f   2f  /
    and 04h             ;fddc e6 04   e6 04   . .
    jr nz,lfdceh        ;fdde 20 ee   20 ee     .
    or a                ;fde0 b7   b7  .
    ret                 ;fde1 c9   c9  .
lfde2h:
    pop af              ;fde2 f1   f1  .
    scf                 ;fde3 37   37  7
    ret                 ;fde4 c9   c9  .
lfde5h:
    out (11h),a         ;fde5 d3 11   d3 11   . .
lfde7h:
    in a,(14h)          ;fde7 db 14   db 14   . .
    cpl                 ;fde9 2f   2f  /
    and 08h             ;fdea e6 08   e6 08   . .
    jr z,lfde7h         ;fdec 28 f9   28 f9   ( .
    in a,(15h)          ;fdee db 15   db 15   . .
    or 02h              ;fdf0 f6 02   f6 02   . .
    out (15h),a         ;fdf2 d3 15   d3 15   . .
lfdf4h:
    in a,(14h)          ;fdf4 db 14   db 14   . .
    cpl                 ;fdf6 2f   2f  /
    and 04h             ;fdf7 e6 04   e6 04   . .
    jr z,lfdf4h         ;fdf9 28 f9   28 f9   ( .
    in a,(15h)          ;fdfb db 15   db 15   . .
    and 0fdh            ;fdfd e6 fd   e6 fd   . .
    out (15h),a         ;fdff d3 15   d3 15   . .
    xor a               ;fe01 af   af  .
    out (11h),a         ;fe02 d3 11   d3 11   . .
    ret                 ;fe04 c9   c9  .
rdimm:
    in a,(15h)          ;fe05 db 15   db 15   . .
    and 0f7h            ;fe07 e6 f7   e6 f7   . .
    out (15h),a         ;fe09 d3 15   d3 15   . .
lfe0bh:
    in a,(14h)          ;fe0b db 14   db 14   . .
    cpl                 ;fe0d 2f   2f  /
    and 02h             ;fe0e e6 02   e6 02   . .
    jr z,lfe29h         ;fe10 28 17   28 17   ( .
    call sub_faeeh      ;fe12 cd ee fa   cd ee fa    . . .
    dec bc              ;fe15 0b   0b  .
    ld a,b              ;fe16 78   78  x
    or c                ;fe17 b1   b1  .
    jr nz,lfe0bh        ;fe18 20 f1   20 f1     .
    scf                 ;fe1a 37   37  7
    ret                 ;fe1b c9   c9  .
rdieee:
    in a,(15h)          ;fe1c db 15   db 15   . .
    and 0f7h            ;fe1e e6 f7   e6 f7   . .
    out (15h),a         ;fe20 d3 15   d3 15   . .
lfe22h:
    in a,(14h)          ;fe22 db 14   db 14   . .
    cpl                 ;fe24 2f   2f  /
    and 02h             ;fe25 e6 02   e6 02   . .
    jr nz,lfe22h        ;fe27 20 f9   20 f9     .
lfe29h:
    in a,(10h)          ;fe29 db 10   db 10   . .
    push af             ;fe2b f5   f5  .
    in a,(14h)          ;fe2c db 14   db 14   . .
    ld (0ea6ch),a       ;fe2e 32 6c ea   32 6c ea    2 l .
    in a,(15h)          ;fe31 db 15   db 15   . .
    or 08h              ;fe33 f6 08   f6 08   . .
    out (15h),a         ;fe35 d3 15   d3 15   . .
    in a,(15h)          ;fe37 db 15   db 15   . .
    and 0fbh            ;fe39 e6 fb   e6 fb   . .
    out (15h),a         ;fe3b d3 15   d3 15   . .
lfe3dh:
    in a,(14h)          ;fe3d db 14   db 14   . .
    cpl                 ;fe3f 2f   2f  /
    and 02h             ;fe40 e6 02   e6 02   . .
    jr z,lfe3dh         ;fe42 28 f9   28 f9   ( .
    in a,(15h)          ;fe44 db 15   db 15   . .
    or 04h              ;fe46 f6 04   f6 04   . .
    out (15h),a         ;fe48 d3 15   d3 15   . .
    pop af              ;fe4a f1   f1  .
    or a                ;fe4b b7   b7  .
    ret                 ;fe4c c9   c9  .
creoi:
    ld a,0dh            ;fe4d 3e 0d   3e 0d   > .
wreoi:
    push af             ;fe4f f5   f5  .
    in a,(15h)          ;fe50 db 15   db 15   . .
    or 10h              ;fe52 f6 10   f6 10   . .
    out (15h),a         ;fe54 d3 15   d3 15   . .
    pop af              ;fe56 f1   f1  .
    call wrieee         ;fe57 cd a6 fd   cd a6 fd    . . .
    push af             ;fe5a f5   f5  .
    in a,(15h)          ;fe5b db 15   db 15   . .
    and 0efh            ;fe5d e6 ef   e6 ef   . .
    out (15h),a         ;fe5f d3 15   d3 15   . .
    pop af              ;fe61 f1   f1  .
    ret                 ;fe62 c9   c9  .
ieeemsg:
    ld a,(hl)           ;fe63 7e   7e  ~
    inc hl              ;fe64 23   23  #
    call wrieee         ;fe65 cd a6 fd   cd a6 fd    . . .
    dec c               ;fe68 0d   0d  .
    jr nz,ieeemsg       ;fe69 20 f8   20 f8     .
    ret                 ;fe6b c9   c9  .
    inc hl              ;fe6c 23   23  #
    ld (hl),a           ;fe6d 77   77  w
    call 36edh          ;fe6e cd ed 36   cd ed 36    . . 6
    pop de              ;fe71 d1   d1  .
    jp z,3763h          ;fe72 ca 63 37   ca 63 37    . c 7
    ld (hl),e           ;fe75 73   73  s
    inc hl              ;fe76 23   23  #
    ld (hl),d           ;fe77 72   72  r
    jp 3768h            ;fe78 c3 68 37   c3 68 37    . h 7
    ex de,hl            ;fe7b eb   eb  .
    ld (3ca6h),hl       ;fe7c 22 a6 3c   22 a6 3c    " . <
    ex de,hl            ;fe7f eb   eb  .
    ld hl,(3ca6h)       ;fe80 2a a6 3c   2a a6 3c    * . <
    push de             ;fe83 d5   d5  .
    ex de,hl            ;fe84 eb   eb  .
    call 36e4h          ;fe85 cd e4 36   cd e4 36    . . 6
    pop de              ;fe88 d1   d1  .
    ld (hl),e           ;fe89 73   73  s
    inc hl              ;fe8a 23   23  #
    ld (hl),d           ;fe8b 72   72  r
    ld a,e              ;fe8c 7b   7b  {
    or 04h              ;fe8d f6 04   f6 04   . .
    ld e,a              ;fe8f 5f   5f  _
    ret                 ;fe90 c9   c9  .
    push de             ;fe91 d5   d5  .
    push af             ;fe92 f5   f5  .
    ld hl,(3ca8h)       ;fe93 2a a8 3c   2a a8 3c    * . <
    ex de,hl            ;fe96 eb   eb  .
    ld a,e              ;fe97 7b   7b  {
    and 1fh             ;fe98 e6 1f   e6 1f   . .
    call z,36f8h        ;fe9a cc f8 36   cc f8 36    . . 6
    ld hl,(3ca0h)       ;fe9d 2a a0 3c   2a a0 3c    * . <
    add hl,de           ;fea0 19   19  .
    pop af              ;fea1 f1   f1  .
    push af             ;fea2 f5   f5  .
    ld (hl),a           ;fea3 77   77  w
    ld a,e              ;fea4 7b   7b  {
    and 1fh             ;fea5 e6 1f   e6 1f   . .
    cp 1fh              ;fea7 fe 1f   fe 1f   . .
    jp z,3795h          ;fea9 ca 95 37   ca 95 37    . . 7
    inc de              ;feac 13   13  .
    call z,379fh        ;fead cc 9f 37   cc 9f 37    . . 7
    ex de,hl            ;feb0 eb   eb  .
    ld (3ca8h),hl       ;feb1 22 a8 3c   22 a8 3c    " . <
    pop af              ;feb4 f1   f1  .
    pop de              ;feb5 d1   d1  .
    ret                 ;feb6 c9   c9  .
    ld a,e              ;feb7 7b   7b  {
    and 0e0h            ;feb8 e6 e0   e6 e0   . .
    ld e,a              ;feba 5f   5f  _
    call 36edh          ;febb cd ed 36   cd ed 36    . . 6
    ld a,d              ;febe 7a   7a  z
    or e                ;febf b3   b3  .
    jp z,36f8h          ;fec0 ca f8 36   ca f8 36    . . 6
    inc de              ;fec3 13   13  .
    inc de              ;fec4 13   13  .
    inc de              ;fec5 13   13  .
    inc de              ;fec6 13   13  .
    ret                 ;fec7 c9   c9  .
    push de             ;fec8 d5   d5  .
    ex de,hl            ;fec9 eb   eb  .
    ld hl,(3ca0h)       ;feca 2a a0 3c   2a a0 3c    * . <
    ex de,hl            ;fecd eb   eb  .
    ld a,l              ;fece 7d   7d  }
    and 1fh             ;fecf e6 1f   e6 1f   . .
    jp nz,37c0h         ;fed1 c2 c0 37   c2 c0 37    . . 7
    ld a,l              ;fed4 7d   7d  }
    or 04h              ;fed5 f6 04   f6 04   . .
    ld l,a              ;fed7 6f   6f  o
    ex de,hl            ;fed8 eb   eb  .
    add hl,de           ;fed9 19   19  .
    ld a,(hl)           ;feda 7e   7e  ~
    ex de,hl            ;fedb eb   eb  .
    pop de              ;fedc d1   d1  .
    ret                 ;fedd c9   c9  .
    call 37b0h          ;fede cd b0 37   cd b0 37    . . 7
    push af             ;fee1 f5   f5  .
    push de             ;fee2 d5   d5  .
    ex de,hl            ;fee3 eb   eb  .
    ld a,e              ;fee4 7b   7b  {
    and 1fh             ;fee5 e6 1f   e6 1f   . .
    cp 1fh              ;fee7 fe 1f   fe 1f   . .
    jp z,37d5h          ;fee9 ca d5 37   ca d5 37    . . 7
    inc de              ;feec 13   13  .
    call z,379fh        ;feed cc 9f 37   cc 9f 37    . . 7
    ex de,hl            ;fef0 eb   eb  .
    pop de              ;fef1 d1   d1  .
    pop af              ;fef2 f1   f1  .
    ret                 ;fef3 c9   c9  .
    ex de,hl            ;fef4 eb   eb  .
    ld a,e              ;fef5 7b   7b  {
    and 0e0h            ;fef6 e6 e0   e6 e0   . .
    ld e,a              ;fef8 5f   5f  _
    push de             ;fef9 d5   d5  .
    call 36edh          ;fefa cd ed 36   cd ed 36    . . 6
    ld a,e              ;fefd 7b   7b  {
    or d                ;fefe b2   b2  .
    pop bc              ;feff c1   c1  .
    ret z               ;ff00 c8   c8  .
    xor a               ;ff01 af   af  .
    ld (hl),a           ;ff02 77   77  w
    inc hl              ;ff03 23   23  #
    ld (hl),a           ;ff04 77   77  w
    ld hl,(3ca0h)       ;ff05 2a a0 3c   2a a0 3c    * . <
    add hl,de           ;ff08 19   19  .
    ld (hl),e           ;ff09 73   73  s
    inc hl              ;ff0a 23   23  #
    ld (hl),d           ;ff0b 72   72  r
    push bc             ;ff0c c5   c5  .
    call 36d2h          ;ff0d cd d2 36   cd d2 36    . . 6
    pop bc              ;ff10 c1   c1  .
    ld hl,(3ca6h)       ;ff11 2a a6 3c   2a a6 3c    * . <
    ex de,hl            ;ff14 eb   eb  .
    call 36e4h          ;ff15 cd e4 36   cd e4 36    . . 6
    ld (hl),c           ;ff18 71   71  q
    inc hl              ;ff19 23   23  #
    ld (hl),b           ;ff1a 70   70  p
    ret                 ;ff1b c9   c9  .
    ld hl,(3ca8h)       ;ff1c 2a a8 3c   2a a8 3c    * . <
    push de             ;ff1f d5   d5  .
    ex de,hl            ;ff20 eb   eb  .
    ld a,e              ;ff21 7b   7b  {
    and 1fh             ;ff22 e6 1f   e6 1f   . .
    dec de              ;ff24 1b   1b  .
    cp 04h              ;ff25 fe 04   fe 04   . .
    call z,381fh        ;ff27 cc 1f 38   cc 1f 38    . . 8
    ld hl,(3ca0h)       ;ff2a 2a a0 3c   2a a0 3c    * . <
    ex de,hl            ;ff2d eb   eb  .
    ld (3ca8h),hl       ;ff2e 22 a8 3c   22 a8 3c    " . <
    ex de,hl            ;ff31 eb   eb  .
    add hl,de           ;ff32 19   19  .
    ld a,(hl)           ;ff33 7e   7e  ~
    ex de,hl            ;ff34 eb   eb  .
    pop de              ;ff35 d1   d1  .
    ret                 ;ff36 c9   c9  .
    ld a,e              ;ff37 7b   7b  {
    and 0e0h            ;ff38 e6 e0   e6 e0   . .
    ld e,a              ;ff3a 5f   5f  _
    call 36e4h          ;ff3b cd e4 36   cd e4 36    . . 6
    ld a,e              ;ff3e 7b   7b  {
    or 1fh              ;ff3f f6 1f   f6 1f   . .
    ld e,a              ;ff41 5f   5f  _
    ret                 ;ff42 c9   c9  .
    push de             ;ff43 d5   d5  .
    push af             ;ff44 f5   f5  .
    ex de,hl            ;ff45 eb   eb  .
    ld a,e              ;ff46 7b   7b  {
    and 1fh             ;ff47 e6 1f   e6 1f   . .
    cp 1fh              ;ff49 fe 1f   fe 1f   . .
    jp z,3837h          ;ff4b ca 37 38   ca 37 38    . 7 8
    inc de              ;ff4e 13   13  .
    call z,379fh        ;ff4f cc 9f 37   cc 9f 37    . . 7
    ex de,hl            ;ff52 eb   eb  .
    pop af              ;ff53 f1   f1  .
    pop de              ;ff54 d1   d1  .
    ret                 ;ff55 c9   c9  .
    ld hl,(3ca2h)       ;ff56 2a a2 3c   2a a2 3c    * . <
    ex de,hl            ;ff59 eb   eb  .
    ld hl,(3c7bh)       ;ff5a 2a 7b 3c   2a 7b 3c    * { <
    ld a,(3c7dh)        ;ff5d 3a 7d 3c   3a 7d 3c    : } <
    or a                ;ff60 b7   b7  .
    jp nz,3850h         ;ff61 c2 50 38   c2 50 38    . P 8
    ld hl,(3cach)       ;ff64 2a ac 3c   2a ac 3c    * . <
    dec h               ;ff67 25   25  %
    call 369eh          ;ff68 cd 9e 36   cd 9e 36    . . 6
    jp c,0d65h          ;ff6b da 65 0d   da 65 0d    . e .
    ld a,d              ;ff6e 7a   7a  z
    or a                ;ff6f b7   b7  .
    jp z,0d65h          ;ff70 ca 65 0d   ca 65 0d    . e .
    rra                 ;ff73 1f   1f  .
    ld d,a              ;ff74 57   57  W
    ld a,e              ;ff75 7b   7b  {
    rra                 ;ff76 1f   1f  .
    ld e,a              ;ff77 5f   5f  _
    push de             ;ff78 d5   d5  .
    ld hl,(3ca0h)       ;ff79 2a a0 3c   2a a0 3c    * . <
    ex de,hl            ;ff7c eb   eb  .
    ld hl,(3ca2h)       ;ff7d 2a a2 3c   2a a2 3c    * . <
    call 369eh          ;ff80 cd 9e 36   cd 9e 36    . . 6
    ld b,d              ;ff83 42   42  B
    ld c,e              ;ff84 4b   4b  K
    pop de              ;ff85 d1   d1  .
    ld hl,(3ca2h)       ;ff86 2a a2 3c   2a a2 3c    * . <
    ex de,hl            ;ff89 eb   eb  .
    add hl,de           ;ff8a 19   19  .
    ld (3ca2h),hl       ;ff8b 22 a2 3c   22 a2 3c    " . <
    ld a,b              ;ff8e 78   78  x
    or c                ;ff8f b1   b1  .
    jp z,3883h          ;ff90 ca 83 38   ca 83 38    . . 8
    dec hl              ;ff93 2b   2b  +
    dec de              ;ff94 1b   1b  .
    ld a,(de)           ;ff95 1a   1a  .
    ld (hl),a           ;ff96 77   77  w
    dec bc              ;ff97 0b   0b  .
    jp 3876h            ;ff98 c3 76 38   c3 76 38    . v 8
    ld (3ca0h),hl       ;ff9b 22 a0 3c   22 a0 3c    " . <
    ret                 ;ff9e c9   c9  .
    call 388dh          ;ff9f cd 8d 38   cd 8d 38    . . 8
    jp 370dh            ;ffa2 c3 0d 37   c3 0d 37    . . 7
    push de             ;ffa5 d5   d5  .
    ld hl,(3a70h)       ;ffa6 2a 70 3a   2a 70 3a    * p :
    ex de,hl            ;ffa9 eb   eb  .
    ld hl,(3ca0h)       ;ffaa 2a a0 3c   2a a0 3c    * . <
    call 369eh          ;ffad cd 9e 36   cd 9e 36    . . 6
    jp c,0d65h          ;ffb0 da 65 0d   da 65 0d    . e .
    ld a,d              ;ffb3 7a   7a  z
    cp 03h              ;ffb4 fe 03   fe 03   . .
    jp c,0d65h          ;ffb6 da 65 0d   da 65 0d    . e .
    rra                 ;ffb9 1f   1f  .
    ld d,a              ;ffba 57   57  W
    ld a,e              ;ffbb 7b   7b  {
    rra                 ;ffbc 1f   1f  .
    ld e,a              ;ffbd 5f   5f  _
    pop hl              ;ffbe e1   e1  .
    push bc             ;ffbf c5   c5  .
    push hl             ;ffc0 e5   e5  .
    ld hl,(3ca0h)       ;ffc1 2a a0 3c   2a a0 3c    * . <
    ex de,hl            ;ffc4 eb   eb  .
    ex (sp),hl          ;ffc5 e3   e3  .
    call 369eh          ;ffc6 cd 9e 36   cd 9e 36    . . 6
    ld b,d              ;ffc9 42   42  B
    ld c,e              ;ffca 4b   4b  K
    pop de              ;ffcb d1   d1  .
    ld hl,(3ca0h)       ;ffcc 2a a0 3c   2a a0 3c    * . <
    push hl             ;ffcf e5   e5  .
    ld hl,(3a70h)       ;ffd0 2a 70 3a   2a 70 3a    * p :
    add hl,de           ;ffd3 19   19  .
    push hl             ;ffd4 e5   e5  .
    ld (3ca0h),hl       ;ffd5 22 a0 3c   22 a0 3c    " . <
    add hl,bc           ;ffd8 09   09  .
    ld (3ca2h),hl       ;ffd9 22 a2 3c   22 a2 3c    " . <
    pop hl              ;ffdc e1   e1  .
    pop de              ;ffdd d1   d1  .
    ld a,b              ;ffde 78   78  x
    or c                ;ffdf b1   b1  .
    jp z,38d3h          ;ffe0 ca d3 38   ca d3 38    . . 8
    dec bc              ;ffe3 0b   0b  .
    ld a,(de)           ;ffe4 1a   1a  .
    ld (hl),a           ;ffe5 77   77  w
    inc hl              ;ffe6 23   23  #
    inc de              ;ffe7 13   13  .
    jp 38c6h            ;ffe8 c3 c6 38   c3 c6 38    . . 8
    pop bc              ;ffeb c1   c1  .
    ret                 ;ffec c9   c9  .
    ld (3bdbh),a        ;ffed 32 db 3b   32 db 3b    2 .
    ld (3bdch),a        ;fff0 32 dc 3b   32 dc 3b    2 .
    ld c,a              ;fff3 4f   4f  O
    ld b,1eh            ;fff4 06 1e   06 1e   . .
    ld e,(hl)           ;fff6 5e   5e  ^
    inc hl              ;fff7 23   23  #
    ld d,(hl)           ;fff8 56   56  V
    inc hl              ;fff9 23   23  #
    push hl             ;fffa e5   e5  .
    push bc             ;fffb c5   c5  .
    call 00f5h          ;fffc cd f5 00   cd f5 00    . . .
    ld h,c              ;ffff 61   61  a
