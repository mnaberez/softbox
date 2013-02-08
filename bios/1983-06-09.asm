; z80dasm 1.1.3
; command line: z80dasm --labels --origin=61440 1983-06-09.bin

    org 0f000h

lf000h:
    jp lf419h
    jp lf0d2h
    jp lfbb6h
    jp lfb98h
    jp lfbc8h
    jp lfca8h
    jp lfd7bh
    jp lfd93h
    jp lf16ah
    jp lf17ch
    jp lf16dh
    jp lf172h
    jp lf177h
    jp lf252h
    jp lf26fh
    jp lfd33h
    jp lf221h
    jp lfb31h
    jp lfb47h
    jp lfaf9h
    jp lfb21h
    jp lfed8h
    jp lfe62h
    jp lff0bh
    jp lff09h
    jp lff1fh
    jp lf9a3h
    jp lf224h
    jp lfaadh
    jp lfabch
    jp lf9bch
    jp lfb56h
    jp lfb72h
    jp lfdb9h
    jp lfdc3h
    jp lfdfch
    jp lfdd0h
    jp lfe1ch
    jp lfe47h
    jp lf578h
    jp lfac4h
    jp lfb49h
    jp lfec1h
    jp lfe31h
    jp lfb86h
lf087h:
    db 0dh,0ah,"60K SoftBox CP/M vers. 2.2"
    db 0dh,0ah,"(c) 1982 Keith Frewin"
    db 0dh,0ah,"Revision 09-June-1983"
    db 00h
lf0d2h:
    ld sp,00100h
    xor a
    call sub_f245h
lf0d9h:
    jr c,lf0e6h
lf0dbh:
    xor a
    call lfaadh
lf0dfh:
    ld c,016h
lf0e1h:
    call sub_f651h
    jr lf0ebh
lf0e6h:
    ld b,02ch
    call sub_f0fch
lf0ebh:
    ld a,(0ea40h)
    ld (0d8b2h),a
    ld hl,0d403h
    jr z,lf134h
lf0f6h:
    xor a
    call lfac4h
lf0fah:
    jr lf0d2h
sub_f0fch:
    ld hl,0d400h
    ld c,000h
    push hl
    push bc
    ld hl,00000h
    ld (00041h),hl
    xor a
lf10ah:
    ld (00043h),a
    ld (00048h),a
    ld (00051h),a
    call lf17ch
    ld a,0ffh
    ld (00044h),a
    pop bc
    pop hl
lf11dh:
    ld (00052h),hl
    push hl
    push bc
    call lf252h
    ld hl,00043h
    inc (hl)
    pop bc
    pop hl
    or a
    ret nz
    ld de,00080h
    add hl,de
    djnz lf11dh
    ret
lf134h:
    push hl
    ld bc,00080h
    call lf177h
    ld a,0c3h
    ld (00000h),a
    ld hl,0ea03h
    ld (00001h),hl
    ld (00005h),a
    ld hl,0dc06h
    ld (00006h),hl
    ld hl,00004h
    ld a,(hl)
    and 00fh
    call lf224h
    jr c,lf15ch
    ld (hl),000h
lf15ch:
    ld c,(hl)
    xor a
    ld (00048h),a
    ld (00051h),a
    dec a
    ld (00044h),a
    pop hl
    jp (hl)
lf16ah:
    ld bc,00000h
lf16dh:
    ld (00041h),bc
    ret
lf172h:
    ld a,c
    ld (00043h),a
    ret
lf177h:
    ld (00052h),bc
    ret
lf17ch:
    ld a,c
    call lf224h
    ld hl,00000h
    ret nc
    ld (00040h),a
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,0eb00h
    add hl,de
    push hl
    ld l,c
    ld h,000h
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,lf1b1h
    add hl,bc
    ex de,hl
    pop hl
    push hl
    ld bc,0000ah
    add hl,bc
    ld (hl),e
    inc hl
    ld (hl),d
    ld a,(00040h)
    call sub_f245h
    call c,sub_f2ffh
    pop hl
    ret
lf1b1h:
    jr nz,lf1b3h
lf1b3h:
    inc b
    rrca
    ld bc,0004ch
    ccf
    nop
    add a,b
    nop
    djnz lf1beh
lf1beh:
    nop
    nop
    nop
    jr nz,lf1c3h
lf1c3h:
    inc b
    rrca
    ld bc,000f8h
    ccf
    nop
    add a,b
    nop
    djnz lf1ceh
lf1ceh:
    nop
    nop
    nop
    ld b,b
    nop
    ld b,03fh
    inc bc
    ld c,h
    ld (bc),a
    rst 38h
    nop
    add a,b
    nop
    nop
    nop
    ld (bc),a
    nop
    nop
    ld b,b
    nop
    ld b,03fh
    inc bc
    ld c,h
    ld (bc),a
    rst 38h
    nop
    add a,b
    nop
    nop
    nop
    ld (bc),a
    nop
    nop
    ld b,b
    nop
    ld b,03fh
    inc bc
    cp b
    ld (bc),a
    rst 38h
    nop
    add a,b
    nop
    nop
    nop
    ld (bc),a
    nop
    nop
    ld b,b
    nop
    ld b,03fh
    inc bc
    ld e,c
    ld bc,000ffh
    add a,b
    nop
    nop
    nop
    ld (bc),a
    nop
    nop
    jr nz,lf213h
lf213h:
    dec b
    rra
    inc bc
    call m,07f00h
    nop
    add a,b
    nop
    jr nz,lf21eh
lf21eh:
    nop
    nop
    nop
lf221h:
    ld l,c
    ld h,b
    ret
lf224h:
    cp 010h
    ret nc
    push hl
    push af
    or a
    rra
    ld c,a
    ld b,000h
    ld hl,0ea70h
    add hl,bc
    ld c,(hl)
    ld a,c
    cp 004h
    pop hl
    ld a,h
    jr nz,lf23eh
    bit 0,a
    jr lf240h
lf23eh:
    bit 7,c
lf240h:
    pop hl
    scf
    ret z
    or a
    ret
sub_f245h:
    call lf224h
    ret nc
    ld a,c
    or a
    cp 006h
    ret nc
    cp 002h
    ccf
    ret
lf252h:
    ld a,(00040h)
    call sub_f245h
    jp c,lf315h
    call sub_f6b9h
    ld a,001h
    call nz,sub_f2d8h
    ld a,(00043h)
    rrca
    call sub_f2e5h
    xor a
    ld (00048h),a
    ret
lf26fh:
    push bc
    ld a,(00040h)
    call sub_f245h
    pop bc
    jp c,lf342h
    ld a,c
    push af
    cp 002h
    call z,0f691h
    ld hl,00048h
    ld a,(hl)
    or a
    jr z,lf2b1h
    dec (hl)
    ld a,(00040h)
    ld hl,00049h
    cp (hl)
    jr nz,lf2b1h
    ld a,(00041h)
    ld hl,0004ah
    cp (hl)
    jr nz,lf2b1h
    ld a,(00042h)
    inc hl
    cp (hl)
    jr nz,lf2b1h
    ld a,(00043h)
    ld hl,0004ch
    cp (hl)
    jr nz,lf2b1h
    inc (hl)
    call sub_f6b9h
    jr lf2bdh
lf2b1h:
    xor a
    ld (00048h),a
    call sub_f6b9h
    ld a,000h
    call nz,sub_f2d8h
lf2bdh:
    ld a,(00043h)
    rrca
    call sub_f2e9h
    pop af
    dec a
    jr nz,lf2d1h
    ld a,(0004fh)
    or a
    call z,sub_f2dfh
    xor a
    ret
lf2d1h:
    ld a,001h
    ld (00051h),a
    xor a
    ret
sub_f2d8h:
    ld hl,0ef00h
    ex af,af'
    jp lfa3eh
sub_f2dfh:
    ld hl,0ef00h
    jp lf9f7h
sub_f2e5h:
    ld a,000h
    jr lf2ebh
sub_f2e9h:
    ld a,001h
lf2ebh:
    ld hl,0ef00h
    ld de,(00052h)
    ld bc,00080h
    jr nc,lf2f8h
    add hl,bc
lf2f8h:
    or a
    jr z,lf2fch
    ex de,hl
lf2fch:
    ldir
    ret
sub_f2ffh:
    ld a,0ffh
    out (018h),a
    ld b,0ffh
lf305h:
    djnz lf305h
    in a,(016h)
    and 020h
    jr nz,sub_f2ffh
    call sub_f38fh
    cp 08fh
    jr nz,sub_f2ffh
    ret
lf315h:
    call sub_f3a5h
    push af
    ld a,012h
    call sub_f39ah
    pop af
    call sub_f39ah
    ld a,l
    call sub_f39ah
    ld a,h
    call sub_f39ah
    ld hl,(00052h)
    call sub_f37bh
    jr nz,lf36dh
    ld b,080h
lf334h:
    in a,(016h)
    and 010h
    jr z,lf334h
    in a,(018h)
    ld (hl),a
    inc hl
    djnz lf334h
lf340h:
    xor a
    ret
lf342h:
    call sub_f3a5h
    push af
    ld a,013h
    call sub_f39ah
    pop af
    call sub_f39ah
    ld a,l
    call sub_f39ah
    ld a,h
    call sub_f39ah
    ld b,080h
    ld hl,(00052h)
lf35ch:
    in a,(016h)
    and 010h
    jr z,lf35ch
    ld a,(hl)
    out (018h),a
    inc hl
    djnz lf35ch
    call sub_f37bh
    jr z,lf340h
lf36dh:
    ld hl,lf3e5h
    push af
    call sub_fdadh
    pop af
    call sub_f402h
    and 0ffh
    ret
sub_f37bh:
    in a,(016h)
    xor 010h
    and 030h
    jr nz,sub_f37bh
    ld b,019h
lf385h:
    djnz lf385h
    in a,(016h)
    xor 010h
    and 030h
    jr nz,sub_f37bh
sub_f38fh:
    in a,(016h)
    and 010h
    jr z,sub_f38fh
    in a,(018h)
    bit 7,a
    ret
sub_f39ah:
    push af
lf39bh:
    in a,(016h)
    and 010h
    jr z,lf39bh
    pop af
    out (018h),a
    ret
sub_f3a5h:
    ld hl,(00041h)
    ld a,000h
    ld b,006h
lf3ach:
    add hl,hl
    rla
    djnz lf3ach
    push af
    ld a,(00043h)
    or l
    ld l,a
    ld de,0941ch
    ld a,(00040h)
    call lf224h
    ld a,c
    cp 005h
    jr nz,lf3c7h
    ld de,0577ah
lf3c7h:
    ld a,(00040h)
    and 001h
    jr nz,lf3d1h
    ld de,0005ch
lf3d1h:
    pop af
    add hl,de
    adc a,000h
    add a,a
    add a,a
    add a,a
    add a,a
    push hl
    push af
    ld a,(00040h)
    call lfaadh
    pop af
    pop hl
    add a,d
    ret
lf3e5h:
    dec c
    ld a,(bc)
    rlca
    ld hl,(02a2ah)
    jr nz,$+74
    ld b,c
    ld d,d
    ld b,h
    jr nz,lf436h
    ld c,c
    ld d,e
    ld c,e
    jr nz,$+71
    ld d,d
    ld d,d
    ld c,a
    ld d,d
    jr nz,lf427h
    ld hl,(0202ah)
    jr nz,sub_f402h
sub_f402h:
    push af
    rra
    rra
    rra
    rra
    call sub_f40bh
    pop af
sub_f40bh:
    and 00fh
    cp 00ah
    jr c,lf413h
    add a,007h
lf413h:
    add a,030h
    ld c,a
    jp lfbc8h
lf419h:
    ld sp,00100h
    ld a,099h
    out (013h),a
    ld a,098h
    out (017h),a
    xor a
    out (011h),a
lf427h:
    out (015h),a
    ld c,002h
    ld hl,00000h
    ld de,lf000h
lf431h:
    ld (hl),l
    inc hl
    ld a,h
    and 00fh
lf436h:
    or l
    jr nz,lf43fh
    in a,(016h)
    xor 004h
    out (016h),a
lf43fh:
    dec de
    ld a,e
    or d
    jr nz,lf431h
    ld hl,00000h
    ld de,lf000h
lf44ah:
    ld a,(hl)
    cp l
    jr nz,lf491h
    cpl
    ld (hl),a
    inc hl
    ld a,h
    and 00fh
    or l
    jr nz,lf45dh
    in a,(016h)
    xor 004h
    out (016h),a
lf45dh:
    dec de
    ld a,e
    or d
    jr nz,lf44ah
    ld hl,00000h
    ld de,lf000h
lf468h:
    ld a,(hl)
    cpl
    cp l
    jr nz,lf491h
    inc hl
    ld a,h
    and 00fh
    or l
    jr nz,lf47ah
    in a,(016h)
    xor 004h
    out (016h),a
lf47ah:
    dec de
    ld a,e
    or d
    jr nz,lf468h
    ld hl,lf000h
    ld bc,00ffdh
    call sub_f4b9h
    ld c,003h
    ld hl,lfffdh
    cp (hl)
    jp z,lf4c5h
lf491h:
    ld b,c
lf492h:
    xor a
    out (016h),a
    ld de,lffffh
lf498h:
    dec de
    ld a,e
    or d
    jr nz,lf498h
    ld a,004h
    out (016h),a
    ld de,lffffh
lf4a4h:
    dec de
    ld a,e
    or d
    jr nz,lf4a4h
    djnz lf492h
    ld b,003h
    ld de,lffffh
lf4b0h:
    dec de
    ld a,e
    or d
    jr nz,lf4b0h
    djnz lf4b0h
    jr lf491h
sub_f4b9h:
    xor a
lf4bah:
    add a,(hl)
    rrca
    ld d,a
    inc hl
    dec bc
    ld a,b
    or c
    ld a,d
    jr nz,lf4bah
    ret
lf4c5h:
    in a,(015h)
    or 080h
    out (015h),a
    xor a
    ld (00003h),a
    ld (00004h),a
    ld (00054h),a
    ld (00059h),a
    ld (0005ah),a
    ld (0ea80h),a
    out (016h),a
    ld bc,003e8h
    call lfb86h
    ld a,01bh
    ld (0ea68h),a
    xor a
    out (009h),a
    nop
    out (009h),a
    nop
    out (009h),a
    ld a,040h
    out (009h),a
    ld a,07ah
    out (009h),a
    ld a,037h
    out (009h),a
    ld a,0eeh
    out (00ch),a
    in a,(014h)
    cpl
    and 040h
    jr nz,lf52bh
    ld a,001h
    ld (00003h),a
lf510h:
    in a,(014h)
    cpl
    and 003h
    in a,(010h)
    jr nz,lf510h
    cp 039h
    jr nz,lf510h
    in a,(014h)
    cpl
    and 002h
    jr nz,lf510h
lf524h:
    in a,(014h)
    cpl
    and 002h
    jr z,lf524h
lf52bh:
    ld hl,lf63eh
    call sub_fdadh
    ld de,0080fh
    call lfb31h
    ld bc,00007h
    call lfb86h
    in a,(014h)
    cpl
    and 004h
    jr z,lf555h
    ld a,002h
    ld (0ea70h),a
    ld a,001h
    ld (0ea78h),a
    ld b,038h
    call sub_f0fch
    jr lf578h
lf555h:
    call lfb47h
    ld de,0080fh
    ld c,002h
    ld hl,lf68fh
    call lfb56h
    ld d,008h
    ld c,01ch
    call sub_f651h
    jp nz,lf52bh
    ld de,00802h
    ld c,002h
    ld hl,lf687h
    call lfb56h
lf578h:
    ld sp,00100h
    xor a
    push af
    ld ix,0eb00h
    ld hl,0ec00h
    ld de,0ea70h
lf587h:
    ld a,(de)
    or a
    jp m,lf5d5h
    cp 002h
    ld bc,0004ah
    jr z,lf5beh
    cp 003h
    jr z,lf5beh
    cp 004h
    ld bc,00058h
    jr z,lf5beh
    push af
    ld a,010h
    ld (00058h),a
    pop af
    cp 006h
    jp nz,lf5afh
    ld a,020h
    ld (00058h),a
lf5afh:
    ld (ix+00ch),l
    ld (ix+00dh),h
    ld a,(00058h)
    ld b,000h
    ld c,a
    add hl,bc
    rla
    ld c,a
lf5beh:
    ld (ix+00eh),l
    ld (ix+00fh),h
    add hl,bc
    ld (ix+008h),080h
    ld (ix+009h),0eeh
    ld (ix+000h),000h
    ld (ix+001h),000h
lf5d5h:
    ld bc,00010h
    add ix,bc
    pop af
    inc a
    push af
    or a
    rra
    jr c,lf587h
    inc de
    cp 008h
    jr nz,lf587h
    pop af
    ld a,(0d8b2h)
    ld (0ea40h),a
    ld a,(00003h)
    and 001h
    ld b,a
    ld a,(0ea60h)
    and 0fch
    or b
    ld (00003h),a
    xor a
    out (009h),a
    nop
    out (009h),a
    nop
    out (009h),a
    ld a,040h
    out (009h),a
    ld a,(0ea64h)
    out (009h),a
    ld a,037h
    out (009h),a
    ld a,(0ea65h)
    out (00ch),a
    call lfdb9h
    ld a,(00003h)
    rra
    jr nc,lf62bh
    ld a,(0ea67h)
    rla
    jr nc,lf62bh
    ld c,015h
    call lfbc8h
lf62bh:
    ld hl,lf087h
    call sub_fdadh
    call lfbb6h
    inc a
    call z,lfb98h
    ld hl,0d400h
    jp lf134h
lf63eh:
    dec c
    ld a,(bc)
    ld c,h
    ld l,a
    ld h,c
    ld h,h
    ld l,c
    ld l,(hl)
    ld h,a
    jr nz,lf68ch
    ld d,b
    cpl
    ld c,l
    jr nz,$+48
    ld l,02eh
    nop
sub_f651h:
    push bc
    push de
    ld hl,0f689h
    ld c,006h
    ld e,000h
    call lfb56h
    pop de
    push de
    call sub_f9bfh
    pop de
    ld e,000h
    pop bc
    or a
    ret nz
    push de
    call lfaf9h
    ld hl,0d400h
    ld b,000h
lf671h:
    call lfed8h
    ld (hl),a
    inc hl
    djnz lf671h
    dec c
    jr nz,lf671h
    call lfb21h
    pop de
    push de
    call lfb72h
    pop de
    jp sub_f9bfh
lf687h:
    inc hl
    ld (03a30h),a
    ld b,e
lf68ch:
    ld d,b
    cpl
    ld c,l
lf68fh:
    ld c,c
    jr nc,$-57
    call sub_f245h
    pop bc
    or a
    cp 006h
    jp z,lf6a1h
    ld a,010h
    jp lf6a3h
lf6a1h:
    ld a,020h
lf6a3h:
    ld (00048h),a
    ld a,(00040h)
    ld (00049h),a
    ld hl,(00041h)
    ld (0004ah),hl
    ld a,(00043h)
    ld (0004ch),a
    ret
sub_f6b9h:
    ld a,(00040h)
    ld hl,00044h
    xor (hl)
    ld b,a
    ld a,(00041h)
    ld hl,00045h
    xor (hl)
    or b
    ld b,a
    ld a,(00042h)
    inc hl
    xor (hl)
    or b
    ld b,a
    ld a,(00043h)
    rra
    ld hl,00047h
    xor (hl)
    or b
    ret z
    ld hl,00051h
    ld a,(hl)
    ld (hl),000h
    or a
    call nz,sub_f2dfh
    ld a,(00040h)
    ld (00044h),a
    ld hl,(00041h)
    ld (00045h),hl
    ld a,(00043h)
    or a
    rra
    ld (00047h),a
    or 0ffh
    ret
lf6fch:
    ld (00055h),hl
    call sub_f8dah
lf702h:
    ld a,003h
    ld (00050h),a
lf707h:
    ld a,(00044h)
    call lfabch
    ld hl,(00055h)
    ld c,005h
    call lff1fh
    ld a,(00044h)
    and 001h
    add a,030h
    call lfe62h
    ld a,(0004dh)
    call lf9a3h
    ld a,(0004eh)
    call lf9a3h
    call lff09h
    call lfb47h
    ld a,(00044h)
    call lf9bch
    cp 016h
    jr nz,lf73fh
    ex af,af'
    or a
    ret z
    ex af,af'
lf73fh:
    ld (0004fh),a
    or a
    ret z
    ld hl,00050h
    dec (hl)
    jr z,lf752h
    ld a,(00044h)
    call lfac4h
    jr lf707h
lf752h:
    ld hl,lf8beh
    call sub_fdadh
    ld a,(00044h)
    add a,041h
    ld c,a
    call lfbc8h
    ld hl,lf8bbh
    call sub_fdadh
    ld hl,lf7bah
    call sub_f7a6h
lf76dh:
    call lfb98h
    cp 003h
    jp z,00000h
    cp 03fh
    jr nz,lf790h
    ld hl,lf8d6h+1
    call sub_fdadh
    ld hl,0eac0h
lf782h:
    ld a,(hl)
    cp 00dh
    jr z,lf76dh
    ld c,a
    push hl
    call lfbc8h
    pop hl
    inc hl
    jr lf782h
lf790h:
    ld a,(00044h)
    call lfac4h
    ld a,(0004fh)
    cp 01ah
    jp z,lf702h
    cp 015h
    jp z,lf702h
    ld a,000h
    ret
sub_f7a6h:
    ld a,(0004fh)
    cp (hl)
    ld a,(hl)
    inc hl
    jp z,sub_fdadh
    inc a
    jp z,sub_fdadh
lf7b3h:
    ld a,(hl)
    inc hl
    or a
    jr nz,lf7b3h
    jr sub_f7a6h
lf7bah:
    ld a,(de)
    ld b,h
    ld l,c
    ld (hl),e
    ld l,e
    jr nz,lf838h
    ld (hl),d
    ld l,c
    ld (hl),h
    ld h,l
    jr nz,lf837h
    ld (hl),d
    ld l,a
    ld (hl),h
    ld h,l
    ld h,e
    ld (hl),h
    ld h,l
    ld h,h
    nop
    add hl,de
    ld d,a
    ld (hl),d
    ld l,c
    ld (hl),h
    ld h,l
    jr nz,lf84eh
    ld h,l
    ld (hl),d
    ld l,c
    ld h,(hl)
    ld a,c
    jr nz,lf844h
    ld (hl),d
    ld (hl),d
    ld l,a
    ld (hl),d
    nop
    inc e
    ld c,h
    ld l,a
    ld l,(hl)
    ld h,a
    jr nz,lf84fh
    ld h,c
    ld (hl),h
    ld h,c
    jr nz,lf852h
    ld l,h
    ld l,a
    ld h,e
    ld l,e
    nop
    inc d
    ld c,l
    ld l,c
    ld (hl),e
    ld (hl),e
    ld l,c
    ld l,(hl)
    ld h,a
    jr nz,lf867h
    ld h,l
    ld h,c
    ld h,h
    ld h,l
    ld (hl),d
    nop
    dec d
    ld b,h
    ld l,c
    ld (hl),e
    ld l,e
    jr nz,$+112
    ld l,a
    ld (hl),h
    jr nz,lf882h
    ld h,l
    ld h,c
    ld h,h
    ld a,c
    nop
    ld c,d
    ld b,h
    ld l,c
    ld (hl),e
    ld l,e
    jr nz,lf88ah
    ld l,a
    ld (hl),h
    jr nz,lf892h
    ld h,l
    ld h,c
    ld h,h
    ld a,c
    nop
    ld d,04dh
    ld l,c
    ld (hl),e
    ld (hl),e
    ld l,c
    ld l,(hl)
    ld h,a
    jr nz,$+102
    ld h,c
    ld (hl),h
    ld h,c
    jr nz,lf896h
    ld l,h
    ld l,a
    ld h,e
lf837h:
    ld l,e
lf838h:
    nop
    rla
    ld b,e
    ld l,b
    ld h,l
    ld h,e
    ld l,e
    ld (hl),e
    ld (hl),l
    ld l,l
    jr nz,lf8a9h
lf844h:
    ld (hl),d
    ld (hl),d
    ld l,a
    ld (hl),d
    jr nz,lf8b3h
    ld l,(hl)
    jr nz,lf8b1h
    ld h,c
lf84eh:
    ld (hl),h
lf84fh:
    ld h,c
    nop
    dec de
lf852h:
    ld b,e
    ld l,b
    ld h,l
    ld h,e
    ld l,e
    ld (hl),e
    ld (hl),l
    ld l,l
    jr nz,lf8c1h
    ld (hl),d
    ld (hl),d
    ld l,a
    ld (hl),d
    jr nz,lf8cbh
    ld l,(hl)
    jr nz,lf8cdh
    ld h,l
    ld h,c
lf867h:
    ld h,h
    ld h,l
    ld (hl),d
    nop
    jr lf8afh
    ld a,c
    ld (hl),h
    ld h,l
    jr nz,lf8d6h
    ld h,l
    ld h,e
    ld l,a
    ld h,h
    ld l,c
    ld l,(hl)
    ld h,a
    jr nz,lf8e0h
    ld (hl),d
    ld (hl),d
    ld l,a
    ld (hl),d
    nop
    ld b,(hl)
    ld b,e
lf882h:
    ld l,a
    ld l,l
    ld l,l
    ld l,a
    ld h,h
    ld l,a
    ld (hl),d
    ld h,l
lf88ah:
    jr nz,$+70
    ld c,a
    ld d,e
    jr nz,lf8f2h
    ld (hl),l
    ld h,a
lf892h:
    jr nz,lf8b5h
    nop
    ld c,c
lf896h:
    ld d,a
    ld (hl),d
    ld l,a
    ld l,(hl)
    ld h,a
    jr nz,lf8e1h
    ld c,a
    ld d,e
    jr nz,lf907h
    ld l,a
    ld (hl),d
    ld l,l
    ld h,c
    ld (hl),h
    nop
    rst 38h
    ld d,l
lf8a9h:
    ld l,(hl)
    ld l,e
    ld l,(hl)
    ld l,a
    ld (hl),a
    ld l,(hl)
lf8afh:
    jr nz,lf916h
lf8b1h:
    ld (hl),d
    ld (hl),d
lf8b3h:
    ld l,a
    ld (hl),d
lf8b5h:
    jr nz,lf91ah
    ld l,a
    ld h,h
    ld h,l
    nop
lf8bbh:
    ld a,(00020h)
lf8beh:
    dec c
    ld a,(bc)
    ld b,d
lf8c1h:
    ld b,h
    ld c,a
    ld d,e
    jr nz,lf92bh
    ld (hl),d
    ld (hl),d
    jr nz,lf939h
    ld l,(hl)
lf8cbh:
    jr nz,lf8cdh
lf8cdh:
    ld d,l
    ld sp,03220h
    jr nz,$+87
    ld (03220h),a
lf8d6h:
    jr nz,$+15
    ld a,(bc)
    nop
sub_f8dah:
    ld a,(00044h)
    call lf224h
lf8e0h:
    ld a,c
lf8e1h:
    or a
    ld ix,00057h
    ld hl,lf957h
    ld e,010h
    jr z,lf8f9h
    ld e,025h
    ld hl,lf96bh
lf8f2h:
    cp 001h
    jr z,lf8f9h
    ld hl,lf97fh
lf8f9h:
    push de
    push hl
    ld (ix+000h),000h
    ld hl,(00045h)
    ld h,000h
    add hl,hl
    add hl,hl
    add hl,hl
lf907h:
    add hl,hl
    ld de,(00047h)
    ld d,000h
    add hl,de
    ld b,h
    ld c,l
    pop hl
lf912h:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
lf916h:
    scf
    sbc hl,bc
    ex de,hl
lf91ah:
    jp nc,lf923h
    inc hl
    inc hl
    inc hl
    jp lf912h
lf923h:
    dec hl
    dec hl
    ld a,(hl)
    ld (ix+000h),a
    dec hl
    ld a,(hl)
lf92bh:
    dec hl
    dec hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld h,b
    ld l,c
    or a
    sbc hl,de
    ld b,000h
    ld c,a
lf938h:
    ld a,l
lf939h:
    or a
    sbc hl,bc
    jp c,lf945h
    inc (ix+000h)
    jp lf938h
lf945h:
    ld (0004eh),a
    ld a,(ix+000h)
    ld (0004dh),a
    pop de
    cp e
    ret c
    add a,003h
    ld (0004dh),a
    ret
lf957h:
    nop
    nop
    dec d
    ld bc,0013bh
    inc de
    djnz $-81
    ld bc,01612h
    add hl,de
    ld (bc),a
    ld de,00f1ch
    daa
    nop
    nop
lf96bh:
    nop
    nop
    dec e
    ld bc,00414h
    dec de
    dec h
    adc a,(hl)
    dec b
    add hl,de
    inc sp
    and c
    ld b,017h
    ld a,00fh
    daa
    nop
    nop
lf97fh:
    nop
    nop
    dec e
    ld bc,00414h
    dec de
    dec h
    adc a,(hl)
    dec b
    add hl,de
    inc sp
    and c
    ld b,017h
    ld a,0cch
    rlca
    dec e
    ld c,e
    scf
    inc c
    dec de
    ld (hl),d
    or c
    dec c
    add hl,de
    add a,b
    call nz,0170eh
    adc a,e
    rrca
    daa
    nop
    nop
lf9a3h:
    push af
    ld a,020h
    call lfe62h
    pop af
    ld e,02fh
lf9ach:
    sub 00ah
    inc e
    jr nc,lf9ach
    add a,03ah
    push af
    ld a,e
    call lfe62h
    pop af
    jp lfe62h
lf9bch:
    call lfaadh
sub_f9bfh:
    ld e,00fh
    call lfaf9h
    ld hl,0eac0h
lf9c7h:
    call lfed8h
    ld (hl),a
    sub 030h
    jr c,lf9c7h
    cp 00ah
    jr nc,lf9c7h
    inc hl
    ld b,a
    add a,a
    add a,a
    add a,b
    add a,a
    ld b,a
    call lfed8h
    ld (hl),a
    inc hl
    sub 030h
    add a,b
    push af
    ld c,03ch
lf9e5h:
    call lfed8h
    dec c
    jp m,lf9eeh
    ld (hl),a
    inc hl
lf9eeh:
    cp 00dh
    jr nz,lf9e5h
    call lfb21h
    pop af
    ret
lf9f7h:
    push hl
    ld hl,lfaeeh
    ld c,006h
    ld a,(00044h)
    call lfabch
    call lff1fh
    pop hl
    ld a,(hl)
    push hl
    call lff0bh
    call lfb47h
    ld hl,0fae7h
    ld c,007h
    ld a,(00044h)
    call lfabch
    call lff1fh
    call lff09h
    call lfb47h
    ld a,(00044h)
    call lfaadh
    ld e,002h
    call lfb31h
    pop hl
    inc hl
    ld c,0ffh
    call lff1fh
    call lfb47h
    ld hl,0f8d2h
    jp lf6fch
lfa3eh:
    push hl
    ld hl,lf8cdh
    call lf6fch
    ld hl,0faf4h
    ld c,005h
    ld a,(00044h)
    call lfabch
    call lff1fh
    call lff09h
    call lfb47h
    ld a,(00044h)
    call lfaadh
    ld e,00fh
    call lfaf9h
    call lfed8h
    pop hl
    ld (hl),a
    push hl
    call lfb21h
    ld a,(00044h)
    call lfabch
    ld hl,0fae7h
    ld c,007h
    call lff1fh
    call lff09h
    call lfb47h
    ld a,(00044h)
    call lf9bch
    cp 046h
    jr z,lfaa4h
    ld a,(00044h)
    call lfaadh
    ld e,002h
    call lfaf9h
    pop de
    inc de
    ld b,0ffh
lfa9ah:
    call lfed8h
    ld (de),a
    inc de
    djnz lfa9ah
    jp lfb21h
lfaa4h:
    ld a,(00044h)
    call lfac4h
    pop hl
    jr lfa3eh
lfaadh:
    push hl
    push af
    or a
    rra
    ld e,a
    ld d,000h
    ld hl,0ea78h
    add hl,de
    ld d,(hl)
    pop af
    pop hl
    ret
lfabch:
    call lfaadh
    ld e,00fh
    jp lfb31h
lfac4h:
    call lfaadh
    ld e,00fh
    push de
    ld c,002h
    ld hl,lfae3h
    rra
    jr nc,lfad5h
    ld hl,0fae5h
lfad5h:
    call lfb56h
    pop de
    ld e,002h
    ld c,002h
    ld hl,lf687h
    jp lfb56h
lfae3h:
    ld c,c
    jr nc,lfb2fh
    ld sp,02d42h
    ld d,b
    jr nz,$+52
    jr nz,lfb1fh
lfaeeh:
    ld c,l
    dec l
    ld d,a
    nop
    inc de
    ld bc,02d4dh
    ld d,d
    nop
    inc de
lfaf9h:
    in a,(015h)
    or 001h
    out (015h),a
    ld a,040h
    or d
    call lfe62h
    jr c,lfb13h
    ld a,e
    or 060h
    call p,lfe62h
    in a,(015h)
    or 00ch
    out (015h),a
lfb13h:
    push af
    in a,(015h)
    and 0feh
    out (015h),a
    ld a,019h
lfb1ch:
    dec a
    jr nz,lfb1ch
lfb1fh:
    pop af
    ret
lfb21h:
    in a,(015h)
    or 001h
    out (015h),a
    in a,(015h)
    and 0f3h
    out (015h),a
    ld a,05fh
lfb2fh:
    jr lfb49h
lfb31h:
    in a,(015h)
    or 001h
    out (015h),a
    ld a,020h
    or d
    call lfe62h
    jr c,lfb13h
    ld a,e
    or 060h
    call p,lfe62h
    jr lfb13h
lfb47h:
    ld a,03fh
lfb49h:
    push af
    in a,(015h)
    or 001h
    out (015h),a
    pop af
    call lfe62h
    jr lfb13h
lfb56h:
    in a,(015h)
    or 001h
    out (015h),a
    ld a,d
    or 020h
    call lfe62h
    ld a,e
    or 0f0h
    call lfb49h
    dec c
    call nz,lff1fh
    ld a,(hl)
    call lff0bh
    jr lfb47h
lfb72h:
    in a,(015h)
    or 001h
    out (015h),a
    ld a,d
    or 020h
    call lfe62h
    ld a,e
    or 0e0h
    call lfe62h
    jr lfb47h
lfb86h:
    call sub_fb8fh
    dec bc
    ld a,b
    or c
    jr nz,lfb86h
    ret
sub_fb8fh:
    push bc
    ld b,0c8h
lfb92h:
    add a,000h
    djnz lfb92h
    pop bc
    ret
lfb98h:
    ld a,(00003h)
    rra
    jp nc,lfc77h
    in a,(015h)
    or 004h
    out (015h),a
    ld a,002h
    call sub_fc80h
    call lfed8h
    push af
    in a,(015h)
    and 0f3h
    out (015h),a
    pop af
    ret
lfbb6h:
    ld a,(00003h)
    rra
    jp nc,lfc64h
    ld a,001h
    call sub_fc80h
    ld a,000h
    ret nc
    ld a,0ffh
    ret
lfbc8h:
    ld a,(00003h)
    rra
    jp nc,lfc6ch
    ld a,(0005ah)
    or a
    jp nz,lfc1dh
    ld a,c
    rla
    jr c,lfc0eh
    ld a,(0ea68h)
    cp c
    jr nz,lfbe6h
    ld a,001h
    ld (00059h),a
    ret
lfbe6h:
    ld a,(00059h)
    or a
    jp z,lfbf3h
    xor a
    ld (00059h),a
    set 7,c
lfbf3h:
    ld a,c
    cp 020h
    jr c,lfbfch
    cp 07bh
    jr c,lfc0eh
lfbfch:
    ld hl,0ea80h
lfbffh:
    ld a,(hl)
    inc hl
    or a
    jr z,lfc0eh
    cp c
    ld a,(hl)
    inc hl
    jr nz,lfbffh
    cp 01bh
    jr z,lfc17h
    ld c,a
lfc0eh:
    ld a,004h
    call sub_fc80h
    ld a,c
    jp lfea1h
lfc17h:
    ld a,002h
    ld (0005ah),a
    ret
lfc1dh:
    dec a
    ld (0005ah),a
    jr z,lfc28h
    ld a,c
    ld (0005bh),a
    ret
lfc28h:
    ld a,(0005bh)
    ld d,a
    ld e,c
    ld a,(0ea69h)
    or a
    jr z,lfc36h
    ld a,e
    ld e,d
    ld d,a
lfc36h:
    ld a,(00003h)
    and 003h
    cp 001h
    ret nz
    push de
    ld c,01bh
    call lfc0eh
    pop de
    push de
    ld a,e
    ld hl,0ea6bh
    sub (hl)
    cp 060h
    jr c,lfc51h
    sub 060h
lfc51h:
    add a,020h
    ld c,a
    call lfc0eh
    pop af
    ld hl,0ea6ah
    sub (hl)
    and 01fh
    or 020h
    ld c,a
    jp lfc0eh
lfc64h:
    in a,(009h)
    and 002h
    ret z
    or 0ffh
    ret
lfc6ch:
    in a,(009h)
    cpl
    and 084h
    jr nz,lfc6ch
    ld a,c
    out (008h),a
    ret
lfc77h:
    in a,(009h)
    and 002h
    jr z,lfc77h
    in a,(008h)
    ret
sub_fc80h:
    push af
lfc81h:
    in a,(010h)
    or a
    jr nz,lfc81h
    pop af
    out (011h),a
    in a,(015h)
    or 020h
    out (015h),a
    in a,(015h)
    and 0dfh
    out (015h),a
lfc95h:
    in a,(010h)
    and 0c0h
    jr z,lfc95h
    rla
    push af
    ld a,000h
    out (011h),a
lfca1h:
    in a,(010h)
    or a
    jr nz,lfca1h
    pop af
    ret
lfca8h:
    ld a,(00003h)
    and 0c0h
    jp z,lfc6ch
    jp p,lfc0eh
    ld e,0ffh
    and 040h
    jr z,lfcc3h
    ld a,(0ea66h)
    ld d,a
    call lfb31h
    jp lfd8ch
lfcc3h:
    ld a,(0ea61h)
    ld d,a
    in a,(015h)
    or 001h
    out (015h),a
    ld a,(0ea6dh)
    ld b,a
    or a
    call z,sub_fb8fh
    call lfb31h
    bit 0,b
    jr nz,lfd29h
    ld hl,0ea6eh
    ld a,(hl)
    ld (hl),c
    cp 00ah
    jr z,lfcf8h
    cp 00dh
    jr nz,lfd04h
    ld a,c
    cp 00ah
    jr z,lfd04h
    ld a,b
    or a
    call z,sub_fb8fh
    ld a,08dh
    call lfe62h
lfcf8h:
    bit 1,b
    jr nz,lfd04h
    call sub_fb8fh
    ld a,011h
    call lfe62h
lfd04h:
    ld a,c
    cp 05fh
    jr nz,lfd0bh
    ld a,0a4h
lfd0bh:
    cp 00dh
    jr z,lfd20h
    cp 00ah
    jr nz,lfd15h
    ld a,00dh
lfd15h:
    call sub_fd6bh
    bit 1,b
    call z,sub_fb8fh
    call lfe62h
lfd20h:
    in a,(015h)
    or 001h
    out (015h),a
    jp lfb47h
lfd29h:
    ld a,c
    call sub_fd6bh
    call lfe62h
    jp lfb47h
lfd33h:
    ld a,(00003h)
    and 0c0h
    jr z,lfd61h
    rla
    ld a,0ffh
    ret nc
    ld a,(00003h)
    and 040h
    ld a,(0ea61h)
    jr z,lfd4bh
    ld a,(0ea66h)
lfd4bh:
    ld d,a
    ld e,0ffh
    call lfb31h
    call sub_fb8fh
    in a,(014h)
    cpl
    and 008h
    push af
    call lfb47h
    pop af
    ret z
    dec a
    ret
lfd61h:
    in a,(009h)
    cpl
    and 084h
    ld a,0ffh
    ret z
    inc a
    ret
sub_fd6bh:
    cp 041h
    ret c
    cp 060h
    jr c,lfd78h
    cp 07bh
    ret nc
    xor 020h
    ret
lfd78h:
    xor 080h
    ret
lfd7bh:
    ld a,(00003h)
    and 030h
    jp z,lfc6ch
    ld a,(0ea63h)
    ld d,a
    ld e,0ffh
    call lfb31h
lfd8ch:
    ld a,c
    call lfe62h
    jp lfb47h
lfd93h:
    ld a,(00003h)
    and 00ch
    jp z,lfc77h
    ld a,(0ea62h)
    ld d,a
    ld e,0ffh
    call lfaf9h
    call lfed8h
    push af
    call lfb21h
    pop af
    ret
sub_fdadh:
    ld a,(hl)
    or a
    ret z
    push hl
    ld c,a
    call lfbc8h
    pop hl
    inc hl
    jr sub_fdadh
lfdb9h:
    ld a,(00003h)
    rra
    ret nc
    ld c,01ah
    jp lfc0eh
lfdc3h:
    ld a,008h
    call sub_fc80h
    ld a,l
    call lfea1h
    ld a,h
    jp lfea1h
lfdd0h:
    ld a,010h
    call sub_fc80h
    ld a,c
    call lfea1h
    ld a,b
    call lfea1h
    ld a,e
    call lfea1h
    ld a,d
    call lfea1h
    in a,(015h)
    or 004h
    out (015h),a
lfdebh:
    call lfed8h
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,lfdebh
    in a,(015h)
    and 0f3h
    out (015h),a
    ret
lfdfch:
    ld a,020h
    call sub_fc80h
    ld a,c
    call lfea1h
    ld a,b
    call lfea1h
    ld a,e
    call lfea1h
    ld a,d
    call lfea1h
lfe11h:
    ld a,(hl)
    call lfea1h
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,lfe11h
    ret
lfe1ch:
    ld e,000h
    ld (0ea41h),de
    ld (0ea43h),hl
    ld de,00014h
    ld hl,0ea41h
    ld bc,00004h
    jp lfdfch
lfe31h:
    xor a
    ld (0ea45h),a
    ld (0ea46h),a
    ld (0ea47h),a
    ld hl,0ea45h
    ld de,00018h
    ld bc,00003h
    jp lfdfch
lfe47h:
    ld bc,00007h
    ld hl,0ea41h
    ld de,00014h
    call lfdd0h
    ld de,(0ea41h)
    ld hl,(0ea43h)
    ld a,(0ea45h)
    ld bc,(0ea46h)
    ret
lfe62h:
    push af
lfe63h:
    in a,(014h)
    cpl
    and 008h
    jr z,lfe63h
    in a,(014h)
    cpl
    and 004h
    jr nz,lfe9eh
    pop af
    out (011h),a
    in a,(015h)
    or 002h
    out (015h),a
lfe7ah:
    in a,(014h)
    cpl
    and 004h
    jr z,lfe7ah
    in a,(015h)
    and 0fdh
    out (015h),a
    xor a
    out (011h),a
lfe8ah:
    in a,(014h)
    cpl
    and 004h
    jr nz,lfe8ah
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl
    in a,(014h)
    cpl
    and 004h
    jr nz,lfe8ah
    or a
    ret
lfe9eh:
    pop af
    scf
    ret
lfea1h:
    out (011h),a
lfea3h:
    in a,(014h)
    cpl
    and 008h
    jr z,lfea3h
    in a,(015h)
    or 002h
    out (015h),a
lfeb0h:
    in a,(014h)
    cpl
    and 004h
    jr z,lfeb0h
    in a,(015h)
    and 0fdh
    out (015h),a
    xor a
    out (011h),a
    ret
lfec1h:
    in a,(015h)
    and 0f7h
    out (015h),a
lfec7h:
    in a,(014h)
    cpl
    and 002h
    jr z,lfee5h
    call sub_fb8fh
    dec bc
    ld a,b
    or c
    jr nz,lfec7h
    scf
    ret
lfed8h:
    in a,(015h)
    and 0f7h
    out (015h),a
lfedeh:
    in a,(014h)
    cpl
    and 002h
    jr nz,lfedeh
lfee5h:
    in a,(010h)
    push af
    in a,(014h)
    ld (0ea6ch),a
    in a,(015h)
    or 008h
    out (015h),a
    in a,(015h)
    and 0fbh
    out (015h),a
lfef9h:
    in a,(014h)
    cpl
    and 002h
    jr z,lfef9h
    in a,(015h)
    or 004h
    out (015h),a
    pop af
    or a
    ret
lff09h:
    ld a,00dh
lff0bh:
    push af
    in a,(015h)
    or 010h
    out (015h),a
    pop af
    call lfe62h
    push af
    in a,(015h)
    and 0efh
    out (015h),a
    pop af
    ret
lff1fh:
    ld a,(hl)
    inc hl
    call lfe62h
    dec c
    jr nz,lff1fh
    ret
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lfffdh:
    sub c
    rst 38h
lffffh:
    rst 38h
