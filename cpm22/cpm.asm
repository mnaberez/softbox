; z80dasm 1.1.3
; command line: z80dasm --origin=54272 --address --labels --output=cpm.asm cpm.prg

    org 0d400h

ld400h:
    jp ld75ch           ;d400
    jp ld758h           ;d403
ld406h:
    ld a,a              ;d406
ld407h:
    db 0                ;d407
ld408h:
    db 0,0dh,0ah
    db "SET UPPER",0dh,0ah
    db "DIR",0dh,0ah
    db "SET LOWER",0dh,0ah
    db "STAT *.*",0dh,0ah
    db "SUBMIT GNASHER",0dh,0ah
    db 1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah
    db 1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah
    db 1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah
    db 0,0,0,0,0,0,0,0
    db "(c) Copyright 1981 Digital Research"
    db 0,0,0,0,0
ld488h:
    ex af,af'           ;d488
    call nc,0000h       ;d489
sub_d48ch:
    ld e,a              ;d48c
    ld c,02h            ;d48d
    jp 0005h            ;d48f
sub_d492h:
    push bc             ;d492
    call sub_d48ch      ;d493
    pop bc              ;d496
    ret                 ;d497
sub_d498h:
    ld a,0dh            ;d498
    call sub_d492h      ;d49a
    ld a,0ah            ;d49d
    jp sub_d492h        ;d49f
sub_d4a2h:
    ld a,20h            ;d4a2
    jp sub_d492h        ;d4a4
ld4a7h:
    push bc             ;d4a7
    call sub_d498h      ;d4a8
    pop hl              ;d4ab
ld4ach:
    ld a,(hl)           ;d4ac
    or a                ;d4ad
    ret z               ;d4ae
    inc hl              ;d4af
    push hl             ;d4b0
    call sub_d48ch      ;d4b1
    pop hl              ;d4b4
    jp ld4ach           ;d4b5
ld4b8h:
    ld c,0dh            ;d4b8
    jp 0005h            ;d4ba
sub_d4bdh:
    ld e,a              ;d4bd
    ld c,0eh            ;d4be
    jp 0005h            ;d4c0
ld4c3h:
    call 0005h          ;d4c3
    ld (ldbeeh),a       ;d4c6
    inc a               ;d4c9
    ret                 ;d4ca
ld4cbh:
    ld c,0fh            ;d4cb
    jp ld4c3h           ;d4cd
sub_d4d0h:
    xor a               ;d4d0
    ld (ldbedh),a       ;d4d1
    ld de,ldbcdh        ;d4d4
    jp ld4cbh           ;d4d7
sub_d4dah:
    ld c,10h            ;d4da
    jp ld4c3h           ;d4dc
ld4dfh:
    ld c,11h            ;d4df
    jp ld4c3h           ;d4e1
sub_d4e4h:
    ld c,12h            ;d4e4
    jp ld4c3h           ;d4e6
sub_d4e9h:
    ld de,ldbcdh        ;d4e9
    jp ld4dfh           ;d4ec
sub_d4efh:
    ld c,13h            ;d4ef
    jp 0005h            ;d4f1
ld4f4h:
    call 0005h          ;d4f4
    or a                ;d4f7
    ret                 ;d4f8
ld4f9h:
    ld c,14h            ;d4f9
    jp ld4f4h           ;d4fb
sub_d4feh:
    ld de,ldbcdh        ;d4fe
    jp ld4f9h           ;d501
sub_d504h:
    ld c,15h            ;d504
    jp ld4f4h           ;d506
sub_d509h:
    ld c,16h            ;d509
    jp ld4c3h           ;d50b
sub_d50eh:
    ld c,17h            ;d50e
    jp 0005h            ;d510
sub_d513h:
    ld e,0ffh           ;d513
sub_d515h:
    ld c,20h            ;d515
    jp 0005h            ;d517
sub_d51ah:
    call sub_d513h      ;d51a
    add a,a             ;d51d
    add a,a             ;d51e
    add a,a             ;d51f
    add a,a             ;d520
    ld hl,ldbefh        ;d521
    or (hl)             ;d524
    ld (0004h),a        ;d525
    ret                 ;d528
sub_d529h:
    ld a,(ldbefh)       ;d529
    ld (0004h),a        ;d52c
    ret                 ;d52f
sub_d530h:
    cp 61h              ;d530
    ret c               ;d532
    cp 7bh              ;d533
    ret nc              ;d535
    and 5fh             ;d536
    ret                 ;d538
sub_d539h:
    ld a,(ldbabh)       ;d539
    or a                ;d53c
    jp z,ld596h         ;d53d
    ld a,(ldbefh)       ;d540
    or a                ;d543
    ld a,00h            ;d544
    call nz,sub_d4bdh   ;d546
    ld de,ldbach        ;d549
    call ld4cbh         ;d54c
    jp z,ld596h         ;d54f
    ld a,(ldbbbh)       ;d552
    dec a               ;d555
    ld (ldbcch),a       ;d556
    ld de,ldbach        ;d559
    call ld4f9h         ;d55c
    jp nz,ld596h        ;d55f
    ld de,ld407h        ;d562
    ld hl,0080h         ;d565
    ld b,80h            ;d568
    call sub_d842h      ;d56a
    ld hl,ldbbah        ;d56d
    ld (hl),00h         ;d570
    inc hl              ;d572
    dec (hl)            ;d573
    ld de,ldbach        ;d574
    call sub_d4dah      ;d577
    jp z,ld596h         ;d57a
    ld a,(ldbefh)       ;d57d
    or a                ;d580
    call nz,sub_d4bdh   ;d581
    ld hl,ld408h        ;d584
    call ld4ach         ;d587
    call sub_d5c2h      ;d58a
    jp z,ld5a7h         ;d58d
    call sub_d5ddh      ;d590
    jp ld782h           ;d593
ld596h:
    call sub_d5ddh      ;d596
    call sub_d51ah      ;d599
    ld c,0ah            ;d59c
    ld de,ld406h        ;d59e
    call 0005h          ;d5a1
    call sub_d529h      ;d5a4
ld5a7h:
    ld hl,ld407h        ;d5a7
    ld b,(hl)           ;d5aa
ld5abh:
    inc hl              ;d5ab
    ld a,b              ;d5ac
    or a                ;d5ad
    jp z,ld5bah         ;d5ae
    ld a,(hl)           ;d5b1
    call sub_d530h      ;d5b2
    ld (hl),a           ;d5b5
    dec b               ;d5b6
    jp ld5abh           ;d5b7
ld5bah:
    ld (hl),a           ;d5ba
    ld hl,ld408h        ;d5bb
    ld (ld488h),hl      ;d5be
    ret                 ;d5c1
sub_d5c2h:
    ld c,0bh            ;d5c2
    call 0005h          ;d5c4
    or a                ;d5c7
    ret z               ;d5c8
    ld c,01h            ;d5c9
    call 0005h          ;d5cb
    or a                ;d5ce
    ret                 ;d5cf
sub_d5d0h:
    ld c,19h            ;d5d0
    jp 0005h            ;d5d2
sub_d5d5h:
    ld de,0080h         ;d5d5
sub_d5d8h:
    ld c,1ah            ;d5d8
    jp 0005h            ;d5da
sub_d5ddh:
    ld hl,ldbabh        ;d5dd
    ld a,(hl)           ;d5e0
    or a                ;d5e1
    ret z               ;d5e2
    ld (hl),00h         ;d5e3
    xor a               ;d5e5
    call sub_d4bdh      ;d5e6
    ld de,ldbach        ;d5e9
    call sub_d4efh      ;d5ec
    ld a,(ldbefh)       ;d5ef
    jp sub_d4bdh        ;d5f2
sub_d5f5h:
    ld de,ld728h        ;d5f5
    ld hl,ldc00h        ;d5f8
    ld b,06h            ;d5fb
ld5fdh:
    ld a,(de)           ;d5fd
    cp (hl)             ;d5fe
    jp nz,ld7cfh        ;d5ff
    inc de              ;d602
    inc hl              ;d603
    dec b               ;d604
    jp nz,ld5fdh        ;d605
    ret                 ;d608
ld609h:
    call sub_d498h      ;d609
    ld hl,(0d48ah)      ;d60c
ld60fh:
    ld a,(hl)           ;d60f
    cp 20h              ;d610
    jp z,ld622h         ;d612
    or a                ;d615
    jp z,ld622h         ;d616
    push hl             ;d619
    call sub_d48ch      ;d61a
    pop hl              ;d61d
    inc hl              ;d61e
    jp ld60fh           ;d61f
ld622h:
    ld a,3fh            ;d622
    call sub_d48ch      ;d624
    call sub_d498h      ;d627
    call sub_d5ddh      ;d62a
    jp ld782h           ;d62d
sub_d630h:
    ld a,(de)           ;d630
    or a                ;d631
    ret z               ;d632
    cp 20h              ;d633
    jp c,ld609h         ;d635
    ret z               ;d638
    cp 3dh              ;d639
    ret z               ;d63b
    cp 5fh              ;d63c
    ret z               ;d63e
    cp 2eh              ;d63f
    ret z               ;d641
    cp 3ah              ;d642
    ret z               ;d644
    cp 3bh              ;d645
    ret z               ;d647
    cp 3ch              ;d648
    ret z               ;d64a
    cp 3eh              ;d64b
    ret z               ;d64d
    ret                 ;d64e
ld64fh:
    ld a,(de)           ;d64f
    or a                ;d650
    ret z               ;d651
    cp 20h              ;d652
    ret nz              ;d654
    inc de              ;d655
    jp ld64fh           ;d656
sub_d659h:
    add a,l             ;d659
    ld l,a              ;d65a
    ret nc              ;d65b
    inc h               ;d65c
    ret                 ;d65d
sub_d65eh:
    ld a,00h            ;d65e
sub_d660h:
    ld hl,ldbcdh        ;d660
    call sub_d659h      ;d663
    push hl             ;d666
    push hl             ;d667
    xor a               ;d668
    ld (ldbf0h),a       ;d669
    ld hl,(ld488h)      ;d66c
    ex de,hl            ;d66f
    call ld64fh         ;d670
    ex de,hl            ;d673
    ld (0d48ah),hl      ;d674
    ex de,hl            ;d677
    pop hl              ;d678
    ld a,(de)           ;d679
    or a                ;d67a
    jp z,ld689h         ;d67b
    sbc a,40h           ;d67e
    ld b,a              ;d680
    inc de              ;d681
    ld a,(de)           ;d682
    cp 3ah              ;d683
    jp z,ld690h         ;d685
    dec de              ;d688
ld689h:
    ld a,(ldbefh)       ;d689
    ld (hl),a           ;d68c
    jp ld696h           ;d68d
ld690h:
    ld a,b              ;d690
    ld (ldbf0h),a       ;d691
    ld (hl),b           ;d694
    inc de              ;d695
ld696h:
    ld b,08h            ;d696
ld698h:
    call sub_d630h      ;d698
    jp z,ld6b9h         ;d69b
    inc hl              ;d69e
    cp 2ah              ;d69f
    jp nz,ld6a9h        ;d6a1
    ld (hl),3fh         ;d6a4
    jp ld6abh           ;d6a6
ld6a9h:
    ld (hl),a           ;d6a9
    inc de              ;d6aa
ld6abh:
    dec b               ;d6ab
    jp nz,ld698h        ;d6ac
ld6afh:
    call sub_d630h      ;d6af
    jp z,ld6c0h         ;d6b2
    inc de              ;d6b5
    jp ld6afh           ;d6b6
ld6b9h:
    inc hl              ;d6b9
    ld (hl),20h         ;d6ba
    dec b               ;d6bc
    jp nz,ld6b9h        ;d6bd
ld6c0h:
    ld b,03h            ;d6c0
    cp 2eh              ;d6c2
    jp nz,ld6e9h        ;d6c4
    inc de              ;d6c7
ld6c8h:
    call sub_d630h      ;d6c8
    jp z,ld6e9h         ;d6cb
    inc hl              ;d6ce
    cp 2ah              ;d6cf
    jp nz,ld6d9h        ;d6d1
    ld (hl),3fh         ;d6d4
    jp ld6dbh           ;d6d6
ld6d9h:
    ld (hl),a           ;d6d9
    inc de              ;d6da
ld6dbh:
    dec b               ;d6db
    jp nz,ld6c8h        ;d6dc
ld6dfh:
    call sub_d630h      ;d6df
    jp z,ld6f0h         ;d6e2
    inc de              ;d6e5
    jp ld6dfh           ;d6e6
ld6e9h:
    inc hl              ;d6e9
    ld (hl),20h         ;d6ea
    dec b               ;d6ec
    jp nz,ld6e9h        ;d6ed
ld6f0h:
    ld b,03h            ;d6f0
ld6f2h:
    inc hl              ;d6f2
    ld (hl),00h         ;d6f3
    dec b               ;d6f5
    jp nz,ld6f2h        ;d6f6
    ex de,hl            ;d6f9
    ld (ld488h),hl      ;d6fa
    pop hl              ;d6fd
    ld bc,000bh         ;d6fe
ld701h:
    inc hl              ;d701
    ld a,(hl)           ;d702
    cp 3fh              ;d703
    jp nz,ld709h        ;d705
ld708h:
    inc b               ;d708
ld709h:
    dec c               ;d709
    jp nz,ld701h        ;d70a
    ld a,b              ;d70d
    or a                ;d70e
    ret                 ;d70f
    db "DIR "
    db "ERA "
    db "TYPE"
    db "SAVE"
    db "REN "
    db "USER"
ld728h:
    ld e,e              ;d728
    ld d,01h            ;d729
    nop                 ;d72b
    rlca                ;d72c
    ld l,21h            ;d72d
    djnz ld708h         ;d72f
    ld c,00h            ;d731
ld733h:
    ld a,c              ;d733
    cp 06h              ;d734
    ret nc              ;d736
    ld de,ldbceh        ;d737
    ld b,04h            ;d73a
ld73ch:
    ld a,(de)           ;d73c
    cp (hl)             ;d73d
    jp nz,ld74fh        ;d73e
    inc de              ;d741
    inc hl              ;d742
    dec b               ;d743
    jp nz,ld73ch        ;d744
    ld a,(de)           ;d747
    cp 20h              ;d748
    jp nz,ld754h        ;d74a
    ld a,c              ;d74d
    ret                 ;d74e
ld74fh:
    inc hl              ;d74f
    dec b               ;d750
    jp nz,ld74fh        ;d751
ld754h:
    inc c               ;d754
    jp ld733h           ;d755
ld758h:
    xor a               ;d758
    ld (ld407h),a       ;d759
ld75ch:
    ld sp,ldbabh        ;d75c
    push bc             ;d75f
    ld a,c              ;d760
    rra                 ;d761
    rra                 ;d762
    rra                 ;d763
    rra                 ;d764
    and 0fh             ;d765
    ld e,a              ;d767
    call sub_d515h      ;d768
    call ld4b8h         ;d76b
    ld (ldbabh),a       ;d76e
    pop bc              ;d771
    ld a,c              ;d772
    and 0fh             ;d773
    ld (ldbefh),a       ;d775
    call sub_d4bdh      ;d778
    ld a,(ld407h)       ;d77b
    or a                ;d77e
    jp nz,ld798h        ;d77f
ld782h:
    ld sp,ldbabh        ;d782
    call sub_d498h      ;d785
    call sub_d5d0h      ;d788
    add a,41h           ;d78b
    call sub_d48ch      ;d78d
    ld a,3eh            ;d790
    call sub_d48ch      ;d792
    call sub_d539h      ;d795
ld798h:
    ld de,0080h         ;d798
    call sub_d5d8h      ;d79b
    call sub_d5d0h      ;d79e
    ld (ldbefh),a       ;d7a1
    call sub_d65eh      ;d7a4
    call nz,ld609h      ;d7a7
    ld a,(ldbf0h)       ;d7aa
    or a                ;d7ad
    jp nz,ldaa5h        ;d7ae
    call 0d72eh         ;d7b1
    ld hl,ld7c1h        ;d7b4
    ld e,a              ;d7b7
    ld d,00h            ;d7b8
    add hl,de           ;d7ba
    add hl,de           ;d7bb
    ld a,(hl)           ;d7bc
    inc hl              ;d7bd
    ld h,(hl)           ;d7be
    ld l,a              ;d7bf
    jp (hl)             ;d7c0
ld7c1h:
    ld (hl),a           ;d7c1
    ret c               ;d7c2
    rra                 ;d7c3
    exx                 ;d7c4
    ld e,l              ;d7c5
    exx                 ;d7c6
    xor l               ;d7c7
    exx                 ;d7c8
    djnz $-36           ;d7c9
    adc a,(hl)          ;d7cb
    jp c,ldaa5h         ;d7cc
ld7cfh:
    ld hl,76f3h         ;d7cf
    ld (ld400h),hl      ;d7d2
    ld hl,ld400h        ;d7d5
    jp (hl)             ;d7d8
sub_d7d9h:
    ld bc,ld7dfh        ;d7d9
    jp ld4a7h           ;d7dc
ld7dfh:
    db "READ ERROR",0
sub_d7eah:
    ld bc,ld7f0h        ;d7ea
    jp ld4a7h           ;d7ed
ld7f0h:
    db "NO FILE",0
sub_d7f8h:
    call sub_d65eh      ;d7f8
    ld a,(ldbf0h)       ;d7fb
    or a                ;d7fe
    jp nz,ld609h        ;d7ff
    ld hl,ldbceh        ;d802
    ld bc,000bh         ;d805
ld808h:
    ld a,(hl)           ;d808
    cp 20h              ;d809
    jp z,ld833h         ;d80b
    inc hl              ;d80e
    sub 30h             ;d80f
    cp 0ah              ;d811
    jp nc,ld609h        ;d813
    ld d,a              ;d816
    ld a,b              ;d817
    and 0e0h            ;d818
    jp nz,ld609h        ;d81a
    ld a,b              ;d81d
    rlca                ;d81e
    rlca                ;d81f
    rlca                ;d820
    add a,b             ;d821
    jp c,ld609h         ;d822
    add a,b             ;d825
    jp c,ld609h         ;d826
    add a,d             ;d829
    jp c,ld609h         ;d82a
    ld b,a              ;d82d
    dec c               ;d82e
    jp nz,ld808h        ;d82f
    ret                 ;d832
ld833h:
    ld a,(hl)           ;d833
    cp 20h              ;d834
    jp nz,ld609h        ;d836
    inc hl              ;d839
    dec c               ;d83a
    jp nz,ld833h        ;d83b
    ld a,b              ;d83e
    ret                 ;d83f
sub_d840h:
    ld b,03h            ;d840
sub_d842h:
    ld a,(hl)           ;d842
    ld (de),a           ;d843
    inc hl              ;d844
    inc de              ;d845
    dec b               ;d846
    jp nz,sub_d842h     ;d847
    ret                 ;d84a
sub_d84bh:
    ld hl,0080h         ;d84b
    add a,c             ;d84e
    call sub_d659h      ;d84f
    ld a,(hl)           ;d852
    ret                 ;d853
sub_d854h:
    xor a               ;d854
    ld (ldbcdh),a       ;d855
    ld a,(ldbf0h)       ;d858
    or a                ;d85b
    ret z               ;d85c
    dec a               ;d85d
    ld hl,ldbefh        ;d85e
    cp (hl)             ;d861
    ret z               ;d862
    jp sub_d4bdh        ;d863
sub_d866h:
    ld a,(ldbf0h)       ;d866
    or a                ;d869
    ret z               ;d86a
    dec a               ;d86b
    ld hl,ldbefh        ;d86c
    cp (hl)             ;d86f
    ret z               ;d870
    ld a,(ldbefh)       ;d871
    jp sub_d4bdh        ;d874
    call sub_d65eh      ;d877
    call sub_d854h      ;d87a
    ld hl,ldbceh        ;d87d
    ld a,(hl)           ;d880
    cp 20h              ;d881
    jp nz,ld88fh        ;d883
    ld b,0bh            ;d886
ld888h:
    ld (hl),3fh         ;d888
    inc hl              ;d88a
    dec b               ;d88b
    jp nz,ld888h        ;d88c
ld88fh:
    ld e,00h            ;d88f
    push de             ;d891
    call sub_d4e9h      ;d892
    call z,sub_d7eah    ;d895
ld898h:
    jp z,ld91bh         ;d898
    ld a,(ldbeeh)       ;d89b
    rrca                ;d89e
    rrca                ;d89f
    rrca                ;d8a0
    and 60h             ;d8a1
    ld c,a              ;d8a3
    ld a,0ah            ;d8a4
    call sub_d84bh      ;d8a6
    rla                 ;d8a9
    jp c,ld90fh         ;d8aa
    pop de              ;d8ad
    ld a,e              ;d8ae
    inc e               ;d8af
    push de             ;d8b0
    and 03h             ;d8b1
    push af             ;d8b3
    jp nz,ld8cch        ;d8b4
    call sub_d498h      ;d8b7
    push bc             ;d8ba
    call sub_d5d0h      ;d8bb
    pop bc              ;d8be
    add a,41h           ;d8bf
    call sub_d492h      ;d8c1
    ld a,3ah            ;d8c4
    call sub_d492h      ;d8c6
    jp ld8d4h           ;d8c9
ld8cch:
    call sub_d4a2h      ;d8cc
    ld a,3ah            ;d8cf
    call sub_d492h      ;d8d1
ld8d4h:
    call sub_d4a2h      ;d8d4
    ld b,01h            ;d8d7
ld8d9h:
    ld a,b              ;d8d9
    call sub_d84bh      ;d8da
    and 7fh             ;d8dd
    cp 20h              ;d8df
    jp nz,ld8f9h        ;d8e1
    pop af              ;d8e4
    push af             ;d8e5
    cp 03h              ;d8e6
    jp nz,ld8f7h        ;d8e8
    ld a,09h            ;d8eb
    call sub_d84bh      ;d8ed
    and 7fh             ;d8f0
    cp 20h              ;d8f2
    jp z,ld90eh         ;d8f4
ld8f7h:
    ld a,20h            ;d8f7
ld8f9h:
    call sub_d492h      ;d8f9
    inc b               ;d8fc
    ld a,b              ;d8fd
    cp 0ch              ;d8fe
    jp nc,ld90eh        ;d900
    cp 09h              ;d903
    jp nz,ld8d9h        ;d905
    call sub_d4a2h      ;d908
    jp ld8d9h           ;d90b
ld90eh:
    pop af              ;d90e
ld90fh:
    call sub_d5c2h      ;d90f
    jp nz,ld91bh        ;d912
    call sub_d4e4h      ;d915
    jp ld898h           ;d918
ld91bh:
    pop de              ;d91b
    jp ldb86h           ;d91c
    call sub_d65eh      ;d91f
    cp 0bh              ;d922
    jp nz,ld942h        ;d924
    ld bc,ld952h        ;d927
    call ld4a7h         ;d92a
    call sub_d539h      ;d92d
    ld hl,ld407h        ;d930
    dec (hl)            ;d933
    jp nz,ld782h        ;d934
    inc hl              ;d937
    ld a,(hl)           ;d938
    cp 59h              ;d939
    jp nz,ld782h        ;d93b
    inc hl              ;d93e
    ld (ld488h),hl      ;d93f
ld942h:
    call sub_d854h      ;d942
    ld de,ldbcdh        ;d945
    call sub_d4efh      ;d948
    inc a               ;d94b
    call z,sub_d7eah    ;d94c
    jp ldb86h           ;d94f
ld952h:
    db "ALL (Y/N)?",0
    call sub_d65eh      ;d95d
    jp nz,ld609h        ;d960
    call sub_d854h      ;d963
    call sub_d4d0h      ;d966
    jp z,ld9a7h         ;d969
    call sub_d498h      ;d96c
    ld hl,ldbf1h        ;d96f
    ld (hl),0ffh        ;d972
ld974h:
    ld hl,ldbf1h        ;d974
    ld a,(hl)           ;d977
    cp 80h              ;d978
    jp c,ld987h         ;d97a
    push hl             ;d97d
    call sub_d4feh      ;d97e
    pop hl              ;d981
    jp nz,ld9a0h        ;d982
    xor a               ;d985
    ld (hl),a           ;d986
ld987h:
    inc (hl)            ;d987
    ld hl,0080h         ;d988
    call sub_d659h      ;d98b
    ld a,(hl)           ;d98e
    cp 1ah              ;d98f
    jp z,ldb86h         ;d991
    call sub_d48ch      ;d994
    call sub_d5c2h      ;d997
    jp nz,ldb86h        ;d99a
    jp ld974h           ;d99d
ld9a0h:
    dec a               ;d9a0
    jp z,ldb86h         ;d9a1
    call sub_d7d9h      ;d9a4
ld9a7h:
    call sub_d866h      ;d9a7
    jp ld609h           ;d9aa
    call sub_d7f8h      ;d9ad
    push af             ;d9b0
    call sub_d65eh      ;d9b1
    jp nz,ld609h        ;d9b4
    call sub_d854h      ;d9b7
    ld de,ldbcdh        ;d9ba
    push de             ;d9bd
    call sub_d4efh      ;d9be
    pop de              ;d9c1
    call sub_d509h      ;d9c2
    jp z,ld9fbh         ;d9c5
    xor a               ;d9c8
    ld (ldbedh),a       ;d9c9
    pop af              ;d9cc
    ld l,a              ;d9cd
    ld h,00h            ;d9ce
    add hl,hl           ;d9d0
    ld de,0100h         ;d9d1
ld9d4h:
    ld a,h              ;d9d4
    or l                ;d9d5
    jp z,ld9f1h         ;d9d6
    dec hl              ;d9d9
    push hl             ;d9da
    ld hl,0080h         ;d9db
    add hl,de           ;d9de
    push hl             ;d9df
    call sub_d5d8h      ;d9e0
    ld de,ldbcdh        ;d9e3
    call sub_d504h      ;d9e6
    pop de              ;d9e9
    pop hl              ;d9ea
    jp nz,ld9fbh        ;d9eb
    jp ld9d4h           ;d9ee
ld9f1h:
    ld de,ldbcdh        ;d9f1
    call sub_d4dah      ;d9f4
    inc a               ;d9f7
    jp nz,lda01h        ;d9f8
ld9fbh:
    ld bc,lda07h        ;d9fb
    call ld4a7h         ;d9fe
lda01h:
    call sub_d5d5h      ;da01
    jp ldb86h           ;da04
lda07h:
    db "NO SPACE",0
    call sub_d65eh      ;da10
    jp nz,ld609h        ;da13
    ld a,(ldbf0h)       ;da16
    push af             ;da19
    call sub_d854h      ;da1a
    call sub_d4e9h      ;da1d
    jp nz,lda79h        ;da20
    ld hl,ldbcdh        ;da23
    ld de,ldbddh        ;da26
    ld b,10h            ;da29
    call sub_d842h      ;da2b
    ld hl,(ld488h)      ;da2e
    ex de,hl            ;da31
    call ld64fh         ;da32
    cp 3dh              ;da35
    jp z,lda3fh         ;da37
    cp 5fh              ;da3a
    jp nz,lda73h        ;da3c
lda3fh:
    ex de,hl            ;da3f
    inc hl              ;da40
    ld (ld488h),hl      ;da41
    call sub_d65eh      ;da44
    jp nz,lda73h        ;da47
    pop af              ;da4a
    ld b,a              ;da4b
    ld hl,ldbf0h        ;da4c
    ld a,(hl)           ;da4f
    or a                ;da50
    jp z,lda59h         ;da51
    cp b                ;da54
    ld (hl),b           ;da55
    jp nz,lda73h        ;da56
lda59h:
    ld (hl),b           ;da59
    xor a               ;da5a
    ld (ldbcdh),a       ;da5b
    call sub_d4e9h      ;da5e
    jp z,lda6dh         ;da61
    ld de,ldbcdh        ;da64
    call sub_d50eh      ;da67
    jp ldb86h           ;da6a
lda6dh:
    call sub_d7eah      ;da6d
    jp ldb86h           ;da70
lda73h:
    call sub_d866h      ;da73
    jp ld609h           ;da76
lda79h:
    ld bc,lda82h        ;da79
    call ld4a7h         ;da7c
    jp ldb86h           ;da7f
lda82h:
    db "FILE EXISTS",0
    call sub_d7f8h      ;da8e
    cp 10h              ;da91
    jp nc,ld609h        ;da93
    ld e,a              ;da96
    ld a,(ldbceh)       ;da97
    cp 20h              ;da9a
    jp z,ld609h         ;da9c
    call sub_d515h      ;da9f
    jp ldb89h           ;daa2
ldaa5h:
    call sub_d5f5h      ;daa5
    ld a,(ldbceh)       ;daa8
    cp 20h              ;daab
    jp nz,ldac4h        ;daad
    ld a,(ldbf0h)       ;dab0
    or a                ;dab3
    jp z,ldb89h         ;dab4
    dec a               ;dab7
    ld (ldbefh),a       ;dab8
    call sub_d529h      ;dabb
    call sub_d4bdh      ;dabe
    jp ldb89h           ;dac1
ldac4h:
    ld de,ldbd6h        ;dac4
    ld a,(de)           ;dac7
    cp 20h              ;dac8
    jp nz,ld609h        ;daca
    push de             ;dacd
    call sub_d854h      ;dace
    pop de              ;dad1
    ld hl,ldb83h        ;dad2
    call sub_d840h      ;dad5
    call sub_d4d0h      ;dad8
    jp z,ldb6bh         ;dadb
    ld hl,0100h         ;dade
ldae1h:
    push hl             ;dae1
    ex de,hl            ;dae2
    call sub_d5d8h      ;dae3
    ld de,ldbcdh        ;dae6
    call ld4f9h         ;dae9
    jp nz,ldb01h        ;daec
    pop hl              ;daef
    ld de,0080h         ;daf0
    add hl,de           ;daf3
    ld de,ld400h        ;daf4
    ld a,l              ;daf7
    sub e               ;daf8
    ld a,h              ;daf9
    sbc a,d             ;dafa
    jp nc,ldb71h        ;dafb
    jp ldae1h           ;dafe
ldb01h:
    pop hl              ;db01
    dec a               ;db02
    jp nz,ldb71h        ;db03
    call sub_d866h      ;db06
    call sub_d65eh      ;db09
    ld hl,ldbf0h        ;db0c
    push hl             ;db0f
    ld a,(hl)           ;db10
    ld (ldbcdh),a       ;db11
    ld a,10h            ;db14
    call sub_d660h      ;db16
    pop hl              ;db19
    ld a,(hl)           ;db1a
    ld (ldbddh),a       ;db1b
    xor a               ;db1e
    ld (ldbedh),a       ;db1f
    ld de,005ch         ;db22
    ld hl,ldbcdh        ;db25
    ld b,21h            ;db28
    call sub_d842h      ;db2a
    ld hl,ld408h        ;db2d
ldb30h:
    ld a,(hl)           ;db30
    or a                ;db31
    jp z,ldb3eh         ;db32
    cp 20h              ;db35
    jp z,ldb3eh         ;db37
    inc hl              ;db3a
    jp ldb30h           ;db3b
ldb3eh:
    ld b,00h            ;db3e
    ld de,0081h         ;db40
ldb43h:
    ld a,(hl)           ;db43
    ld (de),a           ;db44
    or a                ;db45
    jp z,ldb4fh         ;db46
    inc b               ;db49
    inc hl              ;db4a
    inc de              ;db4b
    jp ldb43h           ;db4c
ldb4fh:
    ld a,b              ;db4f
    ld (0080h),a        ;db50
    call sub_d498h      ;db53
    call sub_d5d5h      ;db56
    call sub_d51ah      ;db59
    call 0100h          ;db5c
    ld sp,ldbabh        ;db5f
    call sub_d529h      ;db62
    call sub_d4bdh      ;db65
    jp ld782h           ;db68
ldb6bh:
    call sub_d866h      ;db6b
    jp ld609h           ;db6e
ldb71h:
    ld bc,ldb7ah        ;db71
    call ld4a7h         ;db74
    jp ldb86h           ;db77
ldb7ah:
    db "BAD LOAD",0
ldb83h:
    ld b,e              ;db83
    ld c,a              ;db84
    ld c,l              ;db85
ldb86h:
    call sub_d866h      ;db86
ldb89h:
    call sub_d65eh      ;db89
    ld a,(ldbceh)       ;db8c
    sub 20h             ;db8f
    ld hl,ldbf0h        ;db91
    or (hl)             ;db94
    jp nz,ld609h        ;db95
    jp ld782h           ;db98
    nop                 ;db9b
    nop                 ;db9c
    nop                 ;db9d
    nop                 ;db9e
    nop                 ;db9f
    nop                 ;dba0
    nop                 ;dba1
    nop                 ;dba2
    nop                 ;dba3
    nop                 ;dba4
    nop                 ;dba5
    nop                 ;dba6
    nop                 ;dba7
    nop                 ;dba8
    nop                 ;dba9
    nop                 ;dbaa
ldbabh:
    nop                 ;dbab
ldbach:
    nop                 ;dbac
    db "$$$     SUB",0
    nop                 ;dbb9
ldbbah:
    nop                 ;dbba
ldbbbh:
    nop                 ;dbbb
    nop                 ;dbbc
    nop                 ;dbbd
    nop                 ;dbbe
    nop                 ;dbbf
    nop                 ;dbc0
    nop                 ;dbc1
    nop                 ;dbc2
    nop                 ;dbc3
    nop                 ;dbc4
    nop                 ;dbc5
    nop                 ;dbc6
    nop                 ;dbc7
    nop                 ;dbc8
    nop                 ;dbc9
    nop                 ;dbca
    nop                 ;dbcb
ldbcch:
    nop                 ;dbcc
ldbcdh:
    nop                 ;dbcd
ldbceh:
    nop                 ;dbce
    nop                 ;dbcf
    nop                 ;dbd0
    nop                 ;dbd1
    nop                 ;dbd2
    nop                 ;dbd3
    nop                 ;dbd4
    nop                 ;dbd5
ldbd6h:
    nop                 ;dbd6
    nop                 ;dbd7
    nop                 ;dbd8
    nop                 ;dbd9
    nop                 ;dbda
    nop                 ;dbdb
    nop                 ;dbdc
ldbddh:
    nop                 ;dbdd
    nop                 ;dbde
    nop                 ;dbdf
    nop                 ;dbe0
    nop                 ;dbe1
    nop                 ;dbe2
    nop                 ;dbe3
    nop                 ;dbe4
    nop                 ;dbe5
    nop                 ;dbe6
    nop                 ;dbe7
    nop                 ;dbe8
    nop                 ;dbe9
    nop                 ;dbea
    nop                 ;dbeb
    nop                 ;dbec
ldbedh:
    nop                 ;dbed
ldbeeh:
    nop                 ;dbee
ldbefh:
    nop                 ;dbef
ldbf0h:
    nop                 ;dbf0
ldbf1h:
    nop                 ;dbf1
    nop                 ;dbf2
    nop                 ;dbf3
    nop                 ;dbf4
    nop                 ;dbf5
    nop                 ;dbf6
    nop                 ;dbf7
    nop                 ;dbf8
    nop                 ;dbf9
    nop                 ;dbfa
    nop                 ;dbfb
    nop                 ;dbfc
    nop                 ;dbfd
    nop                 ;dbfe
    nop                 ;dbff
ldc00h:
    ld e,e              ;dc00
    ld d,01h            ;dc01
    nop                 ;dc03
    rlca                ;dc04
    ld l,0c3h           ;dc05
    ld de,0a4dch        ;dc07
    call c,sub_dca5h    ;dc0a
ldc0dh:
    xor e               ;dc0d
    call c,sub_dcb1h    ;dc0e
    ex de,hl            ;dc11
    ld (ldf43h),hl      ;dc12
    ex de,hl            ;dc15
    ld a,e              ;dc16
    ld (le9d6h),a       ;dc17
    ld hl,0000h         ;dc1a
    ld (ldf45h),hl      ;dc1d
    add hl,sp           ;dc20
    ld (ldf0fh),hl      ;dc21
    ld sp,ldf41h        ;dc24
    xor a               ;dc27
    ld (le9e0h),a       ;dc28
    ld (le9deh),a       ;dc2b
    ld hl,le974h        ;dc2e
    push hl             ;dc31
    ld a,c              ;dc32
    cp 29h              ;dc33
    ret nc              ;dc35
    ld c,e              ;dc36
    ld hl,ldc47h        ;dc37
    ld e,a              ;dc3a
    ld d,00h            ;dc3b
    add hl,de           ;dc3d
    add hl,de           ;dc3e
    ld e,(hl)           ;dc3f
    inc hl              ;dc40
    ld d,(hl)           ;dc41
    ld hl,(ldf43h)      ;dc42
    ex de,hl            ;dc45
    jp (hl)             ;dc46
ldc47h:
    inc bc              ;dc47
    jp pe,ldec8h        ;dc48
    sub b               ;dc4b
    defb 0ddh,0ceh,0deh ;illegal sequence
    ld (de),a           ;dc4f
    jp pe,lea0fh        ;dc50
    call nc,0eddeh      ;dc53
    sbc a,0f3h          ;dc56
    sbc a,0f8h          ;dc58
    sbc a,0e1h          ;dc5a
    defb 0ddh,0feh,0deh ;illegal sequence
    ld a,(hl)           ;dc5f
    ret pe              ;dc60
    add a,e             ;dc61
    ret pe              ;dc62
    ld b,l              ;dc63
    ret pe              ;dc64
    sbc a,h             ;dc65
    ret pe              ;dc66
    and l               ;dc67
    ret pe              ;dc68
    xor e               ;dc69
    ret pe              ;dc6a
    ret z               ;dc6b
    ret pe              ;dc6c
    rst 10h             ;dc6d
    ret pe              ;dc6e
    ret po              ;dc6f
    ret pe              ;dc70
    and 0e8h            ;dc71
    call pe,0f5e8h      ;dc73
    ret pe              ;dc76
    cp 0e8h             ;dc77
    inc b               ;dc79
    jp (hl)             ;dc7a
    ld a,(bc)           ;dc7b
    jp (hl)             ;dc7c
    ld de,2ce9h         ;dc7d
    pop hl              ;dc80
    rla                 ;dc81
    jp (hl)             ;dc82
    dec e               ;dc83
    jp (hl)             ;dc84
    ld h,0e9h           ;dc85
    dec l               ;dc87
    jp (hl)             ;dc88
    ld b,c              ;dc89
    jp (hl)             ;dc8a
    ld b,a              ;dc8b
    jp (hl)             ;dc8c
    ld c,l              ;dc8d
    jp (hl)             ;dc8e
    ld c,0e8h           ;dc8f
    ld d,e              ;dc91
    jp (hl)             ;dc92
    inc b               ;dc93
    rst 18h             ;dc94
    inc b               ;dc95
    rst 18h             ;dc96
    sbc a,e             ;dc97
    jp (hl)             ;dc98
    ld hl,ldccah        ;dc99
    call sub_dce5h      ;dc9c
    cp 03h              ;dc9f
    jp z,0000h          ;dca1
    ret                 ;dca4
sub_dca5h:
    ld hl,ldcd5h        ;dca5
    jp ldcb4h           ;dca8
    ld hl,0dce1h        ;dcab
    jp ldcb4h           ;dcae
sub_dcb1h:
    ld hl,ldcdch        ;dcb1
ldcb4h:
    call sub_dce5h      ;dcb4
    jp 0000h            ;dcb7
ldcbah:
    db "Bdos Err On  : $"
ldccah:
    db "Bad Sector$"
ldcd5h:
    db "Select$"
ldcdch:
    db "File R/O$"
sub_dce5h:
    push hl             ;dce5
    call sub_ddc9h      ;dce6
    ld a,(ldf42h)       ;dce9
    add a,41h           ;dcec
    ld (0dcc6h),a       ;dcee
    ld bc,ldcbah        ;dcf1
    call sub_ddd3h      ;dcf4
    pop bc              ;dcf7
    call sub_ddd3h      ;dcf8
sub_dcfbh:
    ld hl,ldf0eh        ;dcfb
    ld a,(hl)           ;dcfe
    ld (hl),00h         ;dcff
    or a                ;dd01
    ret nz              ;dd02
    jp lea09h           ;dd03
sub_dd06h:
    call sub_dcfbh      ;dd06
    call sub_dd14h      ;dd09
    ret c               ;dd0c
    push af             ;dd0d
    ld c,a              ;dd0e
    call sub_dd90h      ;dd0f
    pop af              ;dd12
    ret                 ;dd13
sub_dd14h:
    cp 0dh              ;dd14
    ret z               ;dd16
    cp 0ah              ;dd17
    ret z               ;dd19
    cp 09h              ;dd1a
    ret z               ;dd1c
    cp 08h              ;dd1d
    ret z               ;dd1f
    cp 20h              ;dd20
    ret                 ;dd22
sub_dd23h:
    ld a,(ldf0eh)       ;dd23
    or a                ;dd26
    jp nz,ldd45h        ;dd27
    call sub_ea06h      ;dd2a
    and 01h             ;dd2d
    ret z               ;dd2f
    call lea09h         ;dd30
    cp 13h              ;dd33
    jp nz,ldd42h        ;dd35
    call lea09h         ;dd38
    cp 03h              ;dd3b
    jp z,0000h          ;dd3d
    xor a               ;dd40
    ret                 ;dd41
ldd42h:
    ld (ldf0eh),a       ;dd42
ldd45h:
    ld a,01h            ;dd45
    ret                 ;dd47
sub_dd48h:
    ld a,(ldf0ah)       ;dd48
    or a                ;dd4b
    jp nz,ldd62h        ;dd4c
    push bc             ;dd4f
    call sub_dd23h      ;dd50
    pop bc              ;dd53
    push bc             ;dd54
    call sub_ea0ch      ;dd55
    pop bc              ;dd58
    push bc             ;dd59
    ld a,(ldf0dh)       ;dd5a
    or a                ;dd5d
    call nz,lea0fh      ;dd5e
    pop bc              ;dd61
ldd62h:
    ld a,c              ;dd62
    ld hl,ldf0ch        ;dd63
    cp 7fh              ;dd66
    ret z               ;dd68
    inc (hl)            ;dd69
    cp 20h              ;dd6a
    ret nc              ;dd6c
    dec (hl)            ;dd6d
    ld a,(hl)           ;dd6e
    or a                ;dd6f
    ret z               ;dd70
    ld a,c              ;dd71
    cp 08h              ;dd72
    jp nz,ldd79h        ;dd74
    dec (hl)            ;dd77
    ret                 ;dd78
ldd79h:
    cp 0ah              ;dd79
    ret nz              ;dd7b
    ld (hl),00h         ;dd7c
    ret                 ;dd7e
sub_dd7fh:
    ld a,c              ;dd7f
    call sub_dd14h      ;dd80
    jp nc,sub_dd90h     ;dd83
    push af             ;dd86
    ld c,5eh            ;dd87
    call sub_dd48h      ;dd89
    pop af              ;dd8c
    or 40h              ;dd8d
    ld c,a              ;dd8f
sub_dd90h:
    ld a,c              ;dd90
    cp 09h              ;dd91
    jp nz,sub_dd48h     ;dd93
ldd96h:
    ld c,20h            ;dd96
    call sub_dd48h      ;dd98
    ld a,(ldf0ch)       ;dd9b
    and 07h             ;dd9e
    jp nz,ldd96h        ;dda0
    ret                 ;dda3
sub_dda4h:
    call sub_ddach      ;dda4
    ld c,20h            ;dda7
    call sub_ea0ch      ;dda9
sub_ddach:
    ld c,08h            ;ddac
    jp sub_ea0ch        ;ddae
sub_ddb1h:
    ld c,23h            ;ddb1
    call sub_dd48h      ;ddb3
    call sub_ddc9h      ;ddb6
lddb9h:
    ld a,(ldf0ch)       ;ddb9
    ld hl,ldf0bh        ;ddbc
    cp (hl)             ;ddbf
    ret nc              ;ddc0
    ld c,20h            ;ddc1
    call sub_dd48h      ;ddc3
    jp lddb9h           ;ddc6
sub_ddc9h:
    ld c,0dh            ;ddc9
    call sub_dd48h      ;ddcb
    ld c,0ah            ;ddce
    jp sub_dd48h        ;ddd0
sub_ddd3h:
    ld a,(bc)           ;ddd3
    cp 24h              ;ddd4
    ret z               ;ddd6
    inc bc              ;ddd7
    push bc             ;ddd8
    ld c,a              ;ddd9
    call sub_dd90h      ;ddda
    pop bc              ;dddd
    jp sub_ddd3h        ;ddde
ldde1h:
    ld a,(ldf0ch)       ;dde1
    ld (ldf0bh),a       ;dde4
    ld hl,(ldf43h)      ;dde7
    ld c,(hl)           ;ddea
    inc hl              ;ddeb
    push hl             ;ddec
    ld b,00h            ;dded
lddefh:
    push bc             ;ddef
    push hl             ;ddf0
lddf1h:
    call sub_dcfbh      ;ddf1
    and 7fh             ;ddf4
    pop hl              ;ddf6
    pop bc              ;ddf7
    cp 0dh              ;ddf8
    jp z,ldec1h         ;ddfa
    cp 0ah              ;ddfd
    jp z,ldec1h         ;ddff
    cp 08h              ;de02
    jp nz,lde16h        ;de04
lde07h:
    ld a,b              ;de07
    or a                ;de08
    jp z,lddefh         ;de09
    dec b               ;de0c
    ld a,(ldf0ch)       ;de0d
    ld (ldf0ah),a       ;de10
    jp lde70h           ;de13
lde16h:
    cp 7fh              ;de16
    jp nz,lde26h        ;de18
    jp lde07h           ;de1b
    rst 28h             ;de1e
    ld a,(ix+05h)       ;de1f
    dec hl              ;de22
    jp ldea9h           ;de23
lde26h:
    cp 05h              ;de26
    jp nz,lde37h        ;de28
    push bc             ;de2b
    push hl             ;de2c
    call sub_ddc9h      ;de2d
    xor a               ;de30
    ld (ldf0bh),a       ;de31
    jp lddf1h           ;de34
lde37h:
    cp 10h              ;de37
    jp nz,lde48h        ;de39
    push hl             ;de3c
    ld hl,ldf0dh        ;de3d
    ld a,01h            ;de40
    sub (hl)            ;de42
    ld (hl),a           ;de43
    pop hl              ;de44
    jp lddefh           ;de45
lde48h:
    cp 18h              ;de48
    jp nz,lde5fh        ;de4a
lde4dh:
    pop hl              ;de4d
lde4eh:
    ld a,(ldf0bh)       ;de4e
    ld hl,ldf0ch        ;de51
    cp (hl)             ;de54
    jp nc,ldde1h        ;de55
    dec (hl)            ;de58
    call sub_dda4h      ;de59
    jp lde4eh           ;de5c
lde5fh:
    cp 15h              ;de5f
    jp nz,lde6bh        ;de61
    jp lde4dh           ;de64
    pop hl              ;de67
    jp ldde1h           ;de68
lde6bh:
    cp 12h              ;de6b
    jp nz,ldea6h        ;de6d
lde70h:
    push bc             ;de70
    call sub_ddb1h      ;de71
    pop bc              ;de74
    pop hl              ;de75
    push hl             ;de76
    push bc             ;de77
lde78h:
    ld a,b              ;de78
    or a                ;de79
    jp z,lde8ah         ;de7a
    inc hl              ;de7d
    ld c,(hl)           ;de7e
    dec b               ;de7f
    push bc             ;de80
    push hl             ;de81
    call sub_dd7fh      ;de82
    pop hl              ;de85
    pop bc              ;de86
    jp lde78h           ;de87
lde8ah:
    push hl             ;de8a
    ld a,(ldf0ah)       ;de8b
    or a                ;de8e
    jp z,lddf1h         ;de8f
    ld hl,ldf0ch        ;de92
    sub (hl)            ;de95
    ld (ldf0ah),a       ;de96
lde99h:
    call sub_dda4h      ;de99
    ld hl,ldf0ah        ;de9c
    dec (hl)            ;de9f
    jp nz,lde99h        ;dea0
    jp lddf1h           ;dea3
ldea6h:
    inc hl              ;dea6
    ld (hl),a           ;dea7
    inc b               ;dea8
ldea9h:
    push bc             ;dea9
    push hl             ;deaa
    ld c,a              ;deab
    call sub_dd7fh      ;deac
    pop hl              ;deaf
    pop bc              ;deb0
    ld a,(hl)           ;deb1
    cp 03h              ;deb2
    ld a,b              ;deb4
    jp nz,ldebdh        ;deb5
    cp 01h              ;deb8
    jp z,0000h          ;deba
ldebdh:
    cp c                ;debd
    jp c,lddefh         ;debe
ldec1h:
    pop hl              ;dec1
    ld (hl),b           ;dec2
    ld c,0dh            ;dec3
    jp sub_dd48h        ;dec5
ldec8h:
    call sub_dd06h      ;dec8
    jp ldf01h           ;decb
    call sub_ea15h      ;dece
    jp ldf01h           ;ded1
    ld a,c              ;ded4
    inc a               ;ded5
    jp z,ldee0h         ;ded6
    inc a               ;ded9
    jp z,sub_ea06h      ;deda
    jp sub_ea0ch        ;dedd
ldee0h:
    call sub_ea06h      ;dee0
    or a                ;dee3
    jp z,le991h         ;dee4
    call lea09h         ;dee7
    jp ldf01h           ;deea
    ld a,(0003h)        ;deed
    jp ldf01h           ;def0
    ld hl,0003h         ;def3
    ld (hl),c           ;def6
    ret                 ;def7
    ex de,hl            ;def8
    ld c,l              ;def9
    ld b,h              ;defa
    jp sub_ddd3h        ;defb
    call sub_dd23h      ;defe
ldf01h:
    ld (ldf45h),a       ;df01
    ret                 ;df04
sub_df05h:
    ld a,01h            ;df05
    jp ldf01h           ;df07
ldf0ah:
    nop                 ;df0a
ldf0bh:
    nop                 ;df0b
ldf0ch:
    nop                 ;df0c
ldf0dh:
    nop                 ;df0d
ldf0eh:
    nop                 ;df0e
ldf0fh:
    nop                 ;df0f
    nop                 ;df10
    nop                 ;df11
    nop                 ;df12
    nop                 ;df13
    nop                 ;df14
    nop                 ;df15
    nop                 ;df16
    nop                 ;df17
    nop                 ;df18
    nop                 ;df19
    nop                 ;df1a
    nop                 ;df1b
    nop                 ;df1c
    nop                 ;df1d
    nop                 ;df1e
    nop                 ;df1f
    nop                 ;df20
    nop                 ;df21
    nop                 ;df22
    nop                 ;df23
    nop                 ;df24
    nop                 ;df25
    nop                 ;df26
    nop                 ;df27
    nop                 ;df28
    nop                 ;df29
    nop                 ;df2a
    nop                 ;df2b
    nop                 ;df2c
    nop                 ;df2d
    nop                 ;df2e
    nop                 ;df2f
    nop                 ;df30
    nop                 ;df31
    nop                 ;df32
    nop                 ;df33
    nop                 ;df34
    nop                 ;df35
    nop                 ;df36
    nop                 ;df37
    nop                 ;df38
    nop                 ;df39
    nop                 ;df3a
    nop                 ;df3b
    nop                 ;df3c
    nop                 ;df3d
    nop                 ;df3e
    nop                 ;df3f
    nop                 ;df40
ldf41h:
    nop                 ;df41
ldf42h:
    nop                 ;df42
ldf43h:
    nop                 ;df43
    nop                 ;df44
ldf45h:
    nop                 ;df45
    nop                 ;df46
sub_df47h:
    ld hl,0dc0bh        ;df47
ldf4ah:
    ld e,(hl)           ;df4a
    inc hl              ;df4b
    ld d,(hl)           ;df4c
    ex de,hl            ;df4d
    jp (hl)             ;df4e
sub_df4fh:
    inc c               ;df4f
ldf50h:
    dec c               ;df50
    ret z               ;df51
    ld a,(de)           ;df52
    ld (hl),a           ;df53
    inc de              ;df54
    inc hl              ;df55
    jp ldf50h           ;df56
sub_df59h:
    ld a,(ldf42h)       ;df59
    ld c,a              ;df5c
    call sub_ea1bh      ;df5d
    ld a,h              ;df60
    or l                ;df61
    ret z               ;df62
    ld e,(hl)           ;df63
    inc hl              ;df64
    ld d,(hl)           ;df65
    inc hl              ;df66
    ld (le9b3h),hl      ;df67
    inc hl              ;df6a
    inc hl              ;df6b
    ld (le9b5h),hl      ;df6c
    inc hl              ;df6f
    inc hl              ;df70
    ld (le9b7h),hl      ;df71
    inc hl              ;df74
    inc hl              ;df75
    ex de,hl            ;df76
    ld (le9d0h),hl      ;df77
    ld hl,le9b9h        ;df7a
    ld c,08h            ;df7d
    call sub_df4fh      ;df7f
    ld hl,(le9bbh)      ;df82
    ex de,hl            ;df85
    ld hl,le9c1h        ;df86
    ld c,0fh            ;df89
    call sub_df4fh      ;df8b
    ld hl,(le9c6h)      ;df8e
    ld a,h              ;df91
    ld hl,le9ddh        ;df92
    ld (hl),0ffh        ;df95
    or a                ;df97
    jp z,ldf9dh         ;df98
    ld (hl),00h         ;df9b
ldf9dh:
    ld a,0ffh           ;df9d
    or a                ;df9f
    ret                 ;dfa0
sub_dfa1h:
    call sub_ea18h      ;dfa1
    xor a               ;dfa4
    ld hl,(le9b5h)      ;dfa5
    ld (hl),a           ;dfa8
    inc hl              ;dfa9
    ld (hl),a           ;dfaa
    ld hl,(le9b7h)      ;dfab
    ld (hl),a           ;dfae
    inc hl              ;dfaf
    ld (hl),a           ;dfb0
    ret                 ;dfb1
sub_dfb2h:
    call sub_ea27h      ;dfb2
    jp ldfbbh           ;dfb5
sub_dfb8h:
    call sub_ea2ah      ;dfb8
ldfbbh:
    or a                ;dfbb
    ret z               ;dfbc
    ld hl,0dc09h        ;dfbd
    jp ldf4ah           ;dfc0
sub_dfc3h:
    ld hl,(le9eah)      ;dfc3
    ld c,02h            ;dfc6
    call sub_e0eah      ;dfc8
    ld (le9e5h),hl      ;dfcb
    ld (le9ech),hl      ;dfce
sub_dfd1h:
    ld hl,le9e5h        ;dfd1
    ld c,(hl)           ;dfd4
    inc hl              ;dfd5
    ld b,(hl)           ;dfd6
    ld hl,(le9b7h)      ;dfd7
    ld e,(hl)           ;dfda
    inc hl              ;dfdb
    ld d,(hl)           ;dfdc
    ld hl,(le9b5h)      ;dfdd
    ld a,(hl)           ;dfe0
    inc hl              ;dfe1
    ld h,(hl)           ;dfe2
    ld l,a              ;dfe3
ldfe4h:
    ld a,c              ;dfe4
    sub e               ;dfe5
    ld a,b              ;dfe6
    sbc a,d             ;dfe7
    jp nc,ldffah        ;dfe8
    push hl             ;dfeb
    ld hl,(le9c1h)      ;dfec
    ld a,e              ;dfef
    sub l               ;dff0
    ld e,a              ;dff1
    ld a,d              ;dff2
    sbc a,h             ;dff3
    ld d,a              ;dff4
    pop hl              ;dff5
    dec hl              ;dff6
    jp ldfe4h           ;dff7
ldffah:
    push hl             ;dffa
    ld hl,(le9c1h)      ;dffb
    add hl,de           ;dffe
    jp c,le00fh         ;dfff
    ld a,c              ;e002
    sub l               ;e003
    ld a,b              ;e004
    sbc a,h             ;e005
    jp c,le00fh         ;e006
    ex de,hl            ;e009
    pop hl              ;e00a
    inc hl              ;e00b
    jp ldffah           ;e00c
le00fh:
    pop hl              ;e00f
    push bc             ;e010
    push de             ;e011
    push hl             ;e012
    ex de,hl            ;e013
    ld hl,(le9ceh)      ;e014
    add hl,de           ;e017
    ld b,h              ;e018
    ld c,l              ;e019
    call sub_ea1eh      ;e01a
    pop de              ;e01d
    ld hl,(le9b5h)      ;e01e
    ld (hl),e           ;e021
    inc hl              ;e022
    ld (hl),d           ;e023
    pop de              ;e024
    ld hl,(le9b7h)      ;e025
    ld (hl),e           ;e028
    inc hl              ;e029
    ld (hl),d           ;e02a
    pop bc              ;e02b
    ld a,c              ;e02c
    sub e               ;e02d
    ld c,a              ;e02e
    ld a,b              ;e02f
    sbc a,d             ;e030
    ld b,a              ;e031
    ld hl,(le9d0h)      ;e032
    ex de,hl            ;e035
    call sub_ea30h      ;e036
    ld c,l              ;e039
    ld b,h              ;e03a
    jp lea21h           ;e03b
sub_e03eh:
    ld hl,le9c3h        ;e03e
    ld c,(hl)           ;e041
    ld a,(le9e3h)       ;e042
le045h:
    or a                ;e045
    rra                 ;e046
    dec c               ;e047
    jp nz,le045h        ;e048
    ld b,a              ;e04b
    ld a,08h            ;e04c
    sub (hl)            ;e04e
    ld c,a              ;e04f
    ld a,(le9e2h)       ;e050
le053h:
    dec c               ;e053
    jp z,le05ch         ;e054
    or a                ;e057
    rla                 ;e058
    jp le053h           ;e059
le05ch:
    add a,b             ;e05c
    ret                 ;e05d
sub_e05eh:
    ld hl,(ldf43h)      ;e05e
    ld de,0010h         ;e061
    add hl,de           ;e064
    add hl,bc           ;e065
    ld a,(le9ddh)       ;e066
    or a                ;e069
    jp z,le071h         ;e06a
    ld l,(hl)           ;e06d
    ld h,00h            ;e06e
    ret                 ;e070
le071h:
    add hl,bc           ;e071
    ld e,(hl)           ;e072
    inc hl              ;e073
    ld d,(hl)           ;e074
    ex de,hl            ;e075
    ret                 ;e076
sub_e077h:
    call sub_e03eh      ;e077
    ld c,a              ;e07a
    ld b,00h            ;e07b
    call sub_e05eh      ;e07d
    ld (le9e5h),hl      ;e080
    ret                 ;e083
sub_e084h:
    ld hl,(le9e5h)      ;e084
    ld a,l              ;e087
    or h                ;e088
    ret                 ;e089
sub_e08ah:
    ld a,(le9c3h)       ;e08a
    ld hl,(le9e5h)      ;e08d
le090h:
    add hl,hl           ;e090
    dec a               ;e091
    jp nz,le090h        ;e092
    ld (le9e7h),hl      ;e095
    ld a,(le9c4h)       ;e098
    ld c,a              ;e09b
    ld a,(le9e3h)       ;e09c
    and c               ;e09f
    or l                ;e0a0
    ld l,a              ;e0a1
    ld (le9e5h),hl      ;e0a2
    ret                 ;e0a5
sub_e0a6h:
    ld hl,(ldf43h)      ;e0a6
    ld de,000ch         ;e0a9
    add hl,de           ;e0ac
    ret                 ;e0ad
sub_e0aeh:
    ld hl,(ldf43h)      ;e0ae
    ld de,000fh         ;e0b1
    add hl,de           ;e0b4
    ex de,hl            ;e0b5
    ld hl,0011h         ;e0b6
    add hl,de           ;e0b9
    ret                 ;e0ba
sub_e0bbh:
    call sub_e0aeh      ;e0bb
    ld a,(hl)           ;e0be
    ld (le9e3h),a       ;e0bf
    ex de,hl            ;e0c2
    ld a,(hl)           ;e0c3
    ld (le9e1h),a       ;e0c4
    call sub_e0a6h      ;e0c7
    ld a,(le9c5h)       ;e0ca
    and (hl)            ;e0cd
    ld (le9e2h),a       ;e0ce
    ret                 ;e0d1
le0d2h:
    call sub_e0aeh      ;e0d2
    ld a,(le9d5h)       ;e0d5
    cp 02h              ;e0d8
    jp nz,le0deh        ;e0da
    xor a               ;e0dd
le0deh:
    ld c,a              ;e0de
    ld a,(le9e3h)       ;e0df
    add a,c             ;e0e2
    ld (hl),a           ;e0e3
    ex de,hl            ;e0e4
    ld a,(le9e1h)       ;e0e5
    ld (hl),a           ;e0e8
    ret                 ;e0e9
sub_e0eah:
    inc c               ;e0ea
le0ebh:
    dec c               ;e0eb
    ret z               ;e0ec
    ld a,h              ;e0ed
    or a                ;e0ee
    rra                 ;e0ef
    ld h,a              ;e0f0
    ld a,l              ;e0f1
    rra                 ;e0f2
    ld l,a              ;e0f3
    jp le0ebh           ;e0f4
sub_e0f7h:
    ld c,80h            ;e0f7
    ld hl,(le9b9h)      ;e0f9
    xor a               ;e0fc
le0fdh:
    add a,(hl)          ;e0fd
    inc hl              ;e0fe
    dec c               ;e0ff
    jp nz,le0fdh        ;e100
    ret                 ;e103
sub_e104h:
    inc c               ;e104
le105h:
    dec c               ;e105
    ret z               ;e106
    add hl,hl           ;e107
    jp le105h           ;e108
sub_e10bh:
    push bc             ;e10b
    ld a,(ldf42h)       ;e10c
    ld c,a              ;e10f
    ld hl,0001h         ;e110
    call sub_e104h      ;e113
    pop bc              ;e116
    ld a,c              ;e117
    or l                ;e118
    ld l,a              ;e119
    ld a,b              ;e11a
    or h                ;e11b
    ld h,a              ;e11c
    ret                 ;e11d
sub_e11eh:
    ld hl,(le9adh)      ;e11e
    ld a,(ldf42h)       ;e121
    ld c,a              ;e124
    call sub_e0eah      ;e125
    ld a,l              ;e128
    and 01h             ;e129
    ret                 ;e12b
sub_e12ch:
    ld hl,le9adh        ;e12c
    ld c,(hl)           ;e12f
    inc hl              ;e130
    ld b,(hl)           ;e131
    call sub_e10bh      ;e132
    ld (le9adh),hl      ;e135
    ld hl,(le9c8h)      ;e138
    inc hl              ;e13b
    ex de,hl            ;e13c
    ld hl,(le9b3h)      ;e13d
    ld (hl),e           ;e140
    inc hl              ;e141
    ld (hl),d           ;e142
    ret                 ;e143
sub_e144h:
    call sub_e15eh      ;e144
sub_e147h:
    ld de,0009h         ;e147
    add hl,de           ;e14a
    ld a,(hl)           ;e14b
    rla                 ;e14c
    ret nc              ;e14d
    ld hl,0dc0fh        ;e14e
    jp ldf4ah           ;e151
sub_e154h:
    call sub_e11eh      ;e154
    ret z               ;e157
    ld hl,ldc0dh        ;e158
    jp ldf4ah           ;e15b
sub_e15eh:
    ld hl,(le9b9h)      ;e15e
    ld a,(le9e9h)       ;e161
sub_e164h:
    add a,l             ;e164
    ld l,a              ;e165
    ret nc              ;e166
    inc h               ;e167
    ret                 ;e168
sub_e169h:
    ld hl,(ldf43h)      ;e169
    ld de,000eh         ;e16c
    add hl,de           ;e16f
    ld a,(hl)           ;e170
    ret                 ;e171
sub_e172h:
    call sub_e169h      ;e172
    ld (hl),00h         ;e175
    ret                 ;e177
sub_e178h:
    call sub_e169h      ;e178
    or 80h              ;e17b
    ld (hl),a           ;e17d
    ret                 ;e17e
sub_e17fh:
    ld hl,(le9eah)      ;e17f
    ex de,hl            ;e182
    ld hl,(le9b3h)      ;e183
    ld a,e              ;e186
    sub (hl)            ;e187
    inc hl              ;e188
    ld a,d              ;e189
    sbc a,(hl)          ;e18a
    ret                 ;e18b
sub_e18ch:
    call sub_e17fh      ;e18c
    ret c               ;e18f
    inc de              ;e190
    ld (hl),d           ;e191
    dec hl              ;e192
    ld (hl),e           ;e193
    ret                 ;e194
sub_e195h:
    ld a,e              ;e195
    sub l               ;e196
    ld l,a              ;e197
    ld a,d              ;e198
    sbc a,h             ;e199
    ld h,a              ;e19a
    ret                 ;e19b
sub_e19ch:
    ld c,0ffh           ;e19c
le19eh:
    ld hl,(le9ech)      ;e19e
    ex de,hl            ;e1a1
    ld hl,(le9cch)      ;e1a2
    call sub_e195h      ;e1a5
    ret nc              ;e1a8
    push bc             ;e1a9
    call sub_e0f7h      ;e1aa
    ld hl,(le9bdh)      ;e1ad
    ex de,hl            ;e1b0
    ld hl,(le9ech)      ;e1b1
    add hl,de           ;e1b4
    pop bc              ;e1b5
    inc c               ;e1b6
    jp z,le1c4h         ;e1b7
    cp (hl)             ;e1ba
    ret z               ;e1bb
    call sub_e17fh      ;e1bc
    ret nc              ;e1bf
    call sub_e12ch      ;e1c0
    ret                 ;e1c3
le1c4h:
    ld (hl),a           ;e1c4
    ret                 ;e1c5
sub_e1c6h:
    call sub_e19ch      ;e1c6
    call sub_e1e0h      ;e1c9
    ld c,01h            ;e1cc
    call sub_dfb8h      ;e1ce
    jp le1dah           ;e1d1
sub_e1d4h:
    call sub_e1e0h      ;e1d4
    call sub_dfb2h      ;e1d7
le1dah:
    ld hl,le9b1h        ;e1da
    jp le1e3h           ;e1dd
sub_e1e0h:
    ld hl,le9b9h        ;e1e0
le1e3h:
    ld c,(hl)           ;e1e3
    inc hl              ;e1e4
    ld b,(hl)           ;e1e5
    jp lea24h           ;e1e6
le1e9h:
    ld hl,(le9b9h)      ;e1e9
    ex de,hl            ;e1ec
    ld hl,(le9b1h)      ;e1ed
    ld c,80h            ;e1f0
    jp sub_df4fh        ;e1f2
sub_e1f5h:
    ld hl,le9eah        ;e1f5
    ld a,(hl)           ;e1f8
    inc hl              ;e1f9
    cp (hl)             ;e1fa
    ret nz              ;e1fb
    inc a               ;e1fc
    ret                 ;e1fd
le1feh:
    ld hl,0ffffh        ;e1fe
    ld (le9eah),hl      ;e201
    ret                 ;e204
sub_e205h:
    ld hl,(le9c8h)      ;e205
    ex de,hl            ;e208
    ld hl,(le9eah)      ;e209
    inc hl              ;e20c
    ld (le9eah),hl      ;e20d
    call sub_e195h      ;e210
    jp nc,le219h        ;e213
    jp le1feh           ;e216
le219h:
    ld a,(le9eah)       ;e219
    and 03h             ;e21c
    ld b,05h            ;e21e
le220h:
    add a,a             ;e220
    dec b               ;e221
    jp nz,le220h        ;e222
    ld (le9e9h),a       ;e225
    or a                ;e228
    ret nz              ;e229
    push bc             ;e22a
    call sub_dfc3h      ;e22b
    call sub_e1d4h      ;e22e
    pop bc              ;e231
    jp le19eh           ;e232
sub_e235h:
    ld a,c              ;e235
    and 07h             ;e236
    inc a               ;e238
    ld e,a              ;e239
    ld d,a              ;e23a
    ld a,c              ;e23b
    rrca                ;e23c
    rrca                ;e23d
    rrca                ;e23e
    and 1fh             ;e23f
    ld c,a              ;e241
    ld a,b              ;e242
    add a,a             ;e243
    add a,a             ;e244
    add a,a             ;e245
    add a,a             ;e246
    add a,a             ;e247
    or c                ;e248
    ld c,a              ;e249
    ld a,b              ;e24a
    rrca                ;e24b
    rrca                ;e24c
    rrca                ;e24d
    and 1fh             ;e24e
    ld b,a              ;e250
    ld hl,(le9bfh)      ;e251
    add hl,bc           ;e254
    ld a,(hl)           ;e255
le256h:
    rlca                ;e256
    dec e               ;e257
    jp nz,le256h        ;e258
    ret                 ;e25b
sub_e25ch:
    push de             ;e25c
    call sub_e235h      ;e25d
    and 0feh            ;e260
    pop bc              ;e262
    or c                ;e263
le264h:
    rrca                ;e264
    dec d               ;e265
    jp nz,le264h        ;e266
    ld (hl),a           ;e269
    ret                 ;e26a
sub_e26bh:
    call sub_e15eh      ;e26b
    ld de,0010h         ;e26e
    add hl,de           ;e271
    push bc             ;e272
    ld c,11h            ;e273
le275h:
    pop de              ;e275
    dec c               ;e276
    ret z               ;e277
    push de             ;e278
    ld a,(le9ddh)       ;e279
    or a                ;e27c
    jp z,le288h         ;e27d
    push bc             ;e280
    push hl             ;e281
    ld c,(hl)           ;e282
    ld b,00h            ;e283
    jp le28eh           ;e285
le288h:
    dec c               ;e288
    push bc             ;e289
    ld c,(hl)           ;e28a
    inc hl              ;e28b
    ld b,(hl)           ;e28c
    push hl             ;e28d
le28eh:
    ld a,c              ;e28e
    or b                ;e28f
    jp z,le29dh         ;e290
    ld hl,(le9c6h)      ;e293
    ld a,l              ;e296
    sub c               ;e297
    ld a,h              ;e298
    sbc a,b             ;e299
    call nc,sub_e25ch   ;e29a
le29dh:
    pop hl              ;e29d
    inc hl              ;e29e
    pop bc              ;e29f
    jp le275h           ;e2a0
le2a3h:
    ld hl,(le9c6h)      ;e2a3
    ld c,03h            ;e2a6
    call sub_e0eah      ;e2a8
    inc hl              ;e2ab
    ld b,h              ;e2ac
    ld c,l              ;e2ad
    ld hl,(le9bfh)      ;e2ae
le2b1h:
    ld (hl),00h         ;e2b1
    inc hl              ;e2b3
    dec bc              ;e2b4
    ld a,b              ;e2b5
    or c                ;e2b6
    jp nz,le2b1h        ;e2b7
    ld hl,(le9cah)      ;e2ba
    ex de,hl            ;e2bd
    ld hl,(le9bfh)      ;e2be
    ld (hl),e           ;e2c1
    inc hl              ;e2c2
    ld (hl),d           ;e2c3
    call sub_dfa1h      ;e2c4
    ld hl,(le9b3h)      ;e2c7
    ld (hl),03h         ;e2ca
    inc hl              ;e2cc
    ld (hl),00h         ;e2cd
    call le1feh         ;e2cf
le2d2h:
    ld c,0ffh           ;e2d2
    call sub_e205h      ;e2d4
    call sub_e1f5h      ;e2d7
    ret z               ;e2da
    call sub_e15eh      ;e2db
    ld a,0e5h           ;e2de
    cp (hl)             ;e2e0
    jp z,le2d2h         ;e2e1
    ld a,(ldf41h)       ;e2e4
    cp (hl)             ;e2e7
    jp nz,le2f6h        ;e2e8
    inc hl              ;e2eb
    ld a,(hl)           ;e2ec
    sub 24h             ;e2ed
    jp nz,le2f6h        ;e2ef
    dec a               ;e2f2
    ld (ldf45h),a       ;e2f3
le2f6h:
    ld c,01h            ;e2f6
    call sub_e26bh      ;e2f8
    call sub_e18ch      ;e2fb
    jp le2d2h           ;e2fe
le301h:
    ld a,(le9d4h)       ;e301
    jp ldf01h           ;e304
sub_e307h:
    push bc             ;e307
    push af             ;e308
    ld a,(le9c5h)       ;e309
    cpl                 ;e30c
    ld b,a              ;e30d
    ld a,c              ;e30e
    and b               ;e30f
    ld c,a              ;e310
    pop af              ;e311
    and b               ;e312
    sub c               ;e313
    and 1fh             ;e314
    pop bc              ;e316
    ret                 ;e317
sub_e318h:
    ld a,0ffh           ;e318
    ld (le9d4h),a       ;e31a
    ld hl,le9d8h        ;e31d
    ld (hl),c           ;e320
    ld hl,(ldf43h)      ;e321
    ld (le9d9h),hl      ;e324
    call le1feh         ;e327
    call sub_dfa1h      ;e32a
le32dh:
    ld c,00h            ;e32d
    call sub_e205h      ;e32f
    call sub_e1f5h      ;e332
    jp z,le394h         ;e335
    ld hl,(le9d9h)      ;e338
    ex de,hl            ;e33b
    ld a,(de)           ;e33c
    cp 0e5h             ;e33d
    jp z,le34ah         ;e33f
    push de             ;e342
    call sub_e17fh      ;e343
    pop de              ;e346
    jp nc,le394h        ;e347
le34ah:
    call sub_e15eh      ;e34a
    ld a,(le9d8h)       ;e34d
    ld c,a              ;e350
    ld b,00h            ;e351
le353h:
    ld a,c              ;e353
    or a                ;e354
    jp z,le383h         ;e355
    ld a,(de)           ;e358
    cp 3fh              ;e359
    jp z,le37ch         ;e35b
    ld a,b              ;e35e
    cp 0dh              ;e35f
    jp z,le37ch         ;e361
    cp 0ch              ;e364
    ld a,(de)           ;e366
    jp z,le373h         ;e367
    sub (hl)            ;e36a
    and 7fh             ;e36b
    jp nz,le32dh        ;e36d
    jp le37ch           ;e370
le373h:
    push bc             ;e373
    ld c,(hl)           ;e374
    call sub_e307h      ;e375
    pop bc              ;e378
    jp nz,le32dh        ;e379
le37ch:
    inc de              ;e37c
    inc hl              ;e37d
    inc b               ;e37e
    dec c               ;e37f
    jp le353h           ;e380
le383h:
    ld a,(le9eah)       ;e383
    and 03h             ;e386
    ld (ldf45h),a       ;e388
    ld hl,le9d4h        ;e38b
    ld a,(hl)           ;e38e
    rla                 ;e38f
    ret nc              ;e390
    xor a               ;e391
    ld (hl),a           ;e392
    ret                 ;e393
le394h:
    call le1feh         ;e394
    ld a,0ffh           ;e397
    jp ldf01h           ;e399
sub_e39ch:
    call sub_e154h      ;e39c
    ld c,0ch            ;e39f
    call sub_e318h      ;e3a1
le3a4h:
    call sub_e1f5h      ;e3a4
    ret z               ;e3a7
    call sub_e144h      ;e3a8
    call sub_e15eh      ;e3ab
    ld (hl),0e5h        ;e3ae
    ld c,00h            ;e3b0
    call sub_e26bh      ;e3b2
    call sub_e1c6h      ;e3b5
    call le32dh         ;e3b8
    jp le3a4h           ;e3bb
sub_e3beh:
    ld d,b              ;e3be
    ld e,c              ;e3bf
le3c0h:
    ld a,c              ;e3c0
    or b                ;e3c1
    jp z,le3d1h         ;e3c2
    dec bc              ;e3c5
    push de             ;e3c6
    push bc             ;e3c7
    call sub_e235h      ;e3c8
    rra                 ;e3cb
    jp nc,le3ech        ;e3cc
    pop bc              ;e3cf
    pop de              ;e3d0
le3d1h:
    ld hl,(le9c6h)      ;e3d1
    ld a,e              ;e3d4
    sub l               ;e3d5
    ld a,d              ;e3d6
    sbc a,h             ;e3d7
    jp nc,le3f4h        ;e3d8
    inc de              ;e3db
    push bc             ;e3dc
    push de             ;e3dd
    ld b,d              ;e3de
    ld c,e              ;e3df
    call sub_e235h      ;e3e0
    rra                 ;e3e3
    jp nc,le3ech        ;e3e4
    pop de              ;e3e7
    pop bc              ;e3e8
    jp le3c0h           ;e3e9
le3ech:
    rla                 ;e3ec
    inc a               ;e3ed
    call le264h         ;e3ee
    pop hl              ;e3f1
    pop de              ;e3f2
    ret                 ;e3f3
le3f4h:
    ld a,c              ;e3f4
    or b                ;e3f5
    jp nz,le3c0h        ;e3f6
    ld hl,0000h         ;e3f9
    ret                 ;e3fc
sub_e3fdh:
    ld c,00h            ;e3fd
    ld e,20h            ;e3ff
sub_e401h:
    push de             ;e401
    ld b,00h            ;e402
    ld hl,(ldf43h)      ;e404
    add hl,bc           ;e407
    ex de,hl            ;e408
    call sub_e15eh      ;e409
    pop bc              ;e40c
    call sub_df4fh      ;e40d
le410h:
    call sub_dfc3h      ;e410
    jp sub_e1c6h        ;e413
sub_e416h:
    call sub_e154h      ;e416
    ld c,0ch            ;e419
    call sub_e318h      ;e41b
    ld hl,(ldf43h)      ;e41e
    ld a,(hl)           ;e421
    ld de,0010h         ;e422
    add hl,de           ;e425
    ld (hl),a           ;e426
le427h:
    call sub_e1f5h      ;e427
    ret z               ;e42a
    call sub_e144h      ;e42b
    ld c,10h            ;e42e
    ld e,0ch            ;e430
    call sub_e401h      ;e432
    call le32dh         ;e435
    jp le427h           ;e438
sub_e43bh:
    ld c,0ch            ;e43b
    call sub_e318h      ;e43d
le440h:
    call sub_e1f5h      ;e440
    ret z               ;e443
    ld c,00h            ;e444
    ld e,0ch            ;e446
    call sub_e401h      ;e448
    call le32dh         ;e44b
    jp le440h           ;e44e
sub_e451h:
    ld c,0fh            ;e451
    call sub_e318h      ;e453
    call sub_e1f5h      ;e456
    ret z               ;e459
sub_e45ah:
    call sub_e0a6h      ;e45a
    ld a,(hl)           ;e45d
    push af             ;e45e
    push hl             ;e45f
    call sub_e15eh      ;e460
    ex de,hl            ;e463
    ld hl,(ldf43h)      ;e464
    ld c,20h            ;e467
    push de             ;e469
    call sub_df4fh      ;e46a
    call sub_e178h      ;e46d
    pop de              ;e470
    ld hl,000ch         ;e471
    add hl,de           ;e474
    ld c,(hl)           ;e475
    ld hl,000fh         ;e476
    add hl,de           ;e479
    ld b,(hl)           ;e47a
    pop hl              ;e47b
    pop af              ;e47c
    ld (hl),a           ;e47d
    ld a,c              ;e47e
    cp (hl)             ;e47f
    ld a,b              ;e480
    jp z,le48bh         ;e481
    ld a,00h            ;e484
    jp c,le48bh         ;e486
    ld a,80h            ;e489
le48bh:
    ld hl,(ldf43h)      ;e48b
    ld de,000fh         ;e48e
    add hl,de           ;e491
    ld (hl),a           ;e492
    ret                 ;e493
sub_e494h:
    ld a,(hl)           ;e494
    inc hl              ;e495
    or (hl)             ;e496
    dec hl              ;e497
    ret nz              ;e498
    ld a,(de)           ;e499
    ld (hl),a           ;e49a
    inc de              ;e49b
    inc hl              ;e49c
    ld a,(de)           ;e49d
    ld (hl),a           ;e49e
    dec de              ;e49f
    dec hl              ;e4a0
    ret                 ;e4a1
sub_e4a2h:
    xor a               ;e4a2
    ld (ldf45h),a       ;e4a3
    ld (le9eah),a       ;e4a6
    ld (le9ebh),a       ;e4a9
    call sub_e11eh      ;e4ac
    ret nz              ;e4af
    call sub_e169h      ;e4b0
    and 80h             ;e4b3
    ret nz              ;e4b5
    ld c,0fh            ;e4b6
    call sub_e318h      ;e4b8
    call sub_e1f5h      ;e4bb
    ret z               ;e4be
    ld bc,0010h         ;e4bf
    call sub_e15eh      ;e4c2
    add hl,bc           ;e4c5
    ex de,hl            ;e4c6
    ld hl,(ldf43h)      ;e4c7
    add hl,bc           ;e4ca
    ld c,10h            ;e4cb
le4cdh:
    ld a,(le9ddh)       ;e4cd
    or a                ;e4d0
    jp z,le4e8h         ;e4d1
    ld a,(hl)           ;e4d4
    or a                ;e4d5
    ld a,(de)           ;e4d6
    jp nz,le4dbh        ;e4d7
    ld (hl),a           ;e4da
le4dbh:
    or a                ;e4db
    jp nz,le4e1h        ;e4dc
    ld a,(hl)           ;e4df
    ld (de),a           ;e4e0
le4e1h:
    cp (hl)             ;e4e1
    jp nz,le51fh        ;e4e2
    jp le4fdh           ;e4e5
le4e8h:
    call sub_e494h      ;e4e8
    ex de,hl            ;e4eb
    call sub_e494h      ;e4ec
    ex de,hl            ;e4ef
    ld a,(de)           ;e4f0
    cp (hl)             ;e4f1
    jp nz,le51fh        ;e4f2
    inc de              ;e4f5
    inc hl              ;e4f6
    ld a,(de)           ;e4f7
    cp (hl)             ;e4f8
    jp nz,le51fh        ;e4f9
    dec c               ;e4fc
le4fdh:
    inc de              ;e4fd
    inc hl              ;e4fe
    dec c               ;e4ff
    jp nz,le4cdh        ;e500
    ld bc,0ffech        ;e503
    add hl,bc           ;e506
    ex de,hl            ;e507
    add hl,bc           ;e508
    ld a,(de)           ;e509
    cp (hl)             ;e50a
    jp c,le517h         ;e50b
    ld (hl),a           ;e50e
    ld bc,0003h         ;e50f
    add hl,bc           ;e512
    ex de,hl            ;e513
    add hl,bc           ;e514
    ld a,(hl)           ;e515
    ld (de),a           ;e516
le517h:
    ld a,0ffh           ;e517
    ld (le9d2h),a       ;e519
    jp le410h           ;e51c
le51fh:
    ld hl,ldf45h        ;e51f
    dec (hl)            ;e522
    ret                 ;e523
sub_e524h:
    call sub_e154h      ;e524
    ld hl,(ldf43h)      ;e527
    push hl             ;e52a
    ld hl,le9ach        ;e52b
    ld (ldf43h),hl      ;e52e
    ld c,01h            ;e531
    call sub_e318h      ;e533
    call sub_e1f5h      ;e536
    pop hl              ;e539
    ld (ldf43h),hl      ;e53a
    ret z               ;e53d
    ex de,hl            ;e53e
    ld hl,000fh         ;e53f
    add hl,de           ;e542
    ld c,11h            ;e543
    xor a               ;e545
le546h:
    ld (hl),a           ;e546
    inc hl              ;e547
    dec c               ;e548
    jp nz,le546h        ;e549
    ld hl,000dh         ;e54c
    add hl,de           ;e54f
    ld (hl),a           ;e550
    call sub_e18ch      ;e551
    call sub_e3fdh      ;e554
    jp sub_e178h        ;e557
sub_e55ah:
    xor a               ;e55a
    ld (le9d2h),a       ;e55b
    call sub_e4a2h      ;e55e
    call sub_e1f5h      ;e561
    ret z               ;e564
    ld hl,(ldf43h)      ;e565
    ld bc,000ch         ;e568
    add hl,bc           ;e56b
    ld a,(hl)           ;e56c
    inc a               ;e56d
    and 1fh             ;e56e
    ld (hl),a           ;e570
    jp z,le583h         ;e571
    ld b,a              ;e574
    ld a,(le9c5h)       ;e575
    and b               ;e578
    ld hl,le9d2h        ;e579
    and (hl)            ;e57c
    jp z,le58eh         ;e57d
    jp le5ach           ;e580
le583h:
    ld bc,0002h         ;e583
    add hl,bc           ;e586
    inc (hl)            ;e587
    ld a,(hl)           ;e588
    and 0fh             ;e589
    jp z,le5b6h         ;e58b
le58eh:
    ld c,0fh            ;e58e
    call sub_e318h      ;e590
    call sub_e1f5h      ;e593
    jp nz,le5ach        ;e596
    ld a,(le9d3h)       ;e599
    inc a               ;e59c
    jp z,le5b6h         ;e59d
    call sub_e524h      ;e5a0
    call sub_e1f5h      ;e5a3
    jp z,le5b6h         ;e5a6
    jp le5afh           ;e5a9
le5ach:
    call sub_e45ah      ;e5ac
le5afh:
    call sub_e0bbh      ;e5af
    xor a               ;e5b2
    jp ldf01h           ;e5b3
le5b6h:
    call sub_df05h      ;e5b6
    jp sub_e178h        ;e5b9
le5bch:
    ld a,01h            ;e5bc
    ld (le9d5h),a       ;e5be
sub_e5c1h:
    ld a,0ffh           ;e5c1
    ld (le9d3h),a       ;e5c3
    call sub_e0bbh      ;e5c6
    ld a,(le9e3h)       ;e5c9
    ld hl,le9e1h        ;e5cc
    cp (hl)             ;e5cf
    jp c,le5e6h         ;e5d0
    cp 80h              ;e5d3
    jp nz,le5fbh        ;e5d5
    call sub_e55ah      ;e5d8
    xor a               ;e5db
    ld (le9e3h),a       ;e5dc
    ld a,(ldf45h)       ;e5df
    or a                ;e5e2
    jp nz,le5fbh        ;e5e3
le5e6h:
    call sub_e077h      ;e5e6
    call sub_e084h      ;e5e9
    jp z,le5fbh         ;e5ec
    call sub_e08ah      ;e5ef
    call sub_dfd1h      ;e5f2
    call sub_dfb2h      ;e5f5
    jp le0d2h           ;e5f8
le5fbh:
    jp sub_df05h        ;e5fb
le5feh:
    ld a,01h            ;e5fe
    ld (le9d5h),a       ;e600
sub_e603h:
    ld a,00h            ;e603
    ld (le9d3h),a       ;e605
    call sub_e154h      ;e608
    ld hl,(ldf43h)      ;e60b
    call sub_e147h      ;e60e
    call sub_e0bbh      ;e611
    ld a,(le9e3h)       ;e614
    cp 80h              ;e617
    jp nc,sub_df05h     ;e619
    call sub_e077h      ;e61c
    call sub_e084h      ;e61f
    ld c,00h            ;e622
    jp nz,le66eh        ;e624
    call sub_e03eh      ;e627
    ld (le9d7h),a       ;e62a
    ld bc,0000h         ;e62d
    or a                ;e630
    jp z,le63bh         ;e631
    ld c,a              ;e634
    dec bc              ;e635
    call sub_e05eh      ;e636
    ld b,h              ;e639
    ld c,l              ;e63a
le63bh:
    call sub_e3beh      ;e63b
    ld a,l              ;e63e
    or h                ;e63f
    jp nz,le648h        ;e640
    ld a,02h            ;e643
    jp ldf01h           ;e645
le648h:
    ld (le9e5h),hl      ;e648
    ex de,hl            ;e64b
    ld hl,(ldf43h)      ;e64c
    ld bc,0010h         ;e64f
    add hl,bc           ;e652
    ld a,(le9ddh)       ;e653
    or a                ;e656
    ld a,(le9d7h)       ;e657
    jp z,le664h         ;e65a
    call sub_e164h      ;e65d
    ld (hl),e           ;e660
    jp le66ch           ;e661
le664h:
    ld c,a              ;e664
    ld b,00h            ;e665
    add hl,bc           ;e667
    add hl,bc           ;e668
    ld (hl),e           ;e669
    inc hl              ;e66a
    ld (hl),d           ;e66b
le66ch:
    ld c,02h            ;e66c
le66eh:
    ld a,(ldf45h)       ;e66e
    or a                ;e671
    ret nz              ;e672
    push bc             ;e673
    call sub_e08ah      ;e674
    ld a,(le9d5h)       ;e677
    dec a               ;e67a
    dec a               ;e67b
    jp nz,le6bbh        ;e67c
    pop bc              ;e67f
    push bc             ;e680
    ld a,c              ;e681
    dec a               ;e682
    dec a               ;e683
    jp nz,le6bbh        ;e684
    push hl             ;e687
    ld hl,(le9b9h)      ;e688
    ld d,a              ;e68b
le68ch:
    ld (hl),a           ;e68c
    inc hl              ;e68d
    inc d               ;e68e
    jp p,le68ch         ;e68f
    call sub_e1e0h      ;e692
    ld hl,(le9e7h)      ;e695
    ld c,02h            ;e698
le69ah:
    ld (le9e5h),hl      ;e69a
    push bc             ;e69d
    call sub_dfd1h      ;e69e
    pop bc              ;e6a1
    call sub_dfb8h      ;e6a2
    ld hl,(le9e5h)      ;e6a5
    ld c,00h            ;e6a8
    ld a,(le9c4h)       ;e6aa
    ld b,a              ;e6ad
    and l               ;e6ae
    cp b                ;e6af
    inc hl              ;e6b0
    jp nz,le69ah        ;e6b1
    pop hl              ;e6b4
    ld (le9e5h),hl      ;e6b5
    call le1dah         ;e6b8
le6bbh:
    call sub_dfd1h      ;e6bb
    pop bc              ;e6be
    push bc             ;e6bf
    call sub_dfb8h      ;e6c0
    pop bc              ;e6c3
    ld a,(le9e3h)       ;e6c4
    ld hl,le9e1h        ;e6c7
    cp (hl)             ;e6ca
    jp c,le6d2h         ;e6cb
    ld (hl),a           ;e6ce
    inc (hl)            ;e6cf
    ld c,02h            ;e6d0
le6d2h:
    nop                 ;e6d2
    nop                 ;e6d3
    ld hl,0000h         ;e6d4
    push af             ;e6d7
    call sub_e169h      ;e6d8
    and 7fh             ;e6db
    ld (hl),a           ;e6dd
    pop af              ;e6de
    cp 7fh              ;e6df
    jp nz,le700h        ;e6e1
    ld a,(le9d5h)       ;e6e4
    cp 01h              ;e6e7
    jp nz,le700h        ;e6e9
    call le0d2h         ;e6ec
    call sub_e55ah      ;e6ef
    ld hl,ldf45h        ;e6f2
    ld a,(hl)           ;e6f5
    or a                ;e6f6
    jp nz,le6feh        ;e6f7
    dec a               ;e6fa
    ld (le9e3h),a       ;e6fb
le6feh:
    ld (hl),00h         ;e6fe
le700h:
    jp le0d2h           ;e700
sub_e703h:
    xor a               ;e703
    ld (le9d5h),a       ;e704
sub_e707h:
    push bc             ;e707
    ld hl,(ldf43h)      ;e708
    ex de,hl            ;e70b
    ld hl,0021h         ;e70c
    add hl,de           ;e70f
    ld a,(hl)           ;e710
    and 7fh             ;e711
    push af             ;e713
    ld a,(hl)           ;e714
    rla                 ;e715
    inc hl              ;e716
    ld a,(hl)           ;e717
    rla                 ;e718
    and 1fh             ;e719
    ld c,a              ;e71b
    ld a,(hl)           ;e71c
    rra                 ;e71d
    rra                 ;e71e
    rra                 ;e71f
    rra                 ;e720
    and 0fh             ;e721
    ld b,a              ;e723
    pop af              ;e724
    inc hl              ;e725
    ld l,(hl)           ;e726
    inc l               ;e727
    dec l               ;e728
    ld l,06h            ;e729
    jp nz,le78bh        ;e72b
    ld hl,0020h         ;e72e
    add hl,de           ;e731
    ld (hl),a           ;e732
    ld hl,000ch         ;e733
    add hl,de           ;e736
    ld a,c              ;e737
    sub (hl)            ;e738
    jp nz,le747h        ;e739
    ld hl,000eh         ;e73c
    add hl,de           ;e73f
    ld a,b              ;e740
    sub (hl)            ;e741
    and 7fh             ;e742
    jp z,le77fh         ;e744
le747h:
    push bc             ;e747
    push de             ;e748
    call sub_e4a2h      ;e749
    pop de              ;e74c
    pop bc              ;e74d
    ld l,03h            ;e74e
    ld a,(ldf45h)       ;e750
    inc a               ;e753
    jp z,le784h         ;e754
    ld hl,000ch         ;e757
    add hl,de           ;e75a
    ld (hl),c           ;e75b
    ld hl,000eh         ;e75c
    add hl,de           ;e75f
    ld (hl),b           ;e760
    call sub_e451h      ;e761
    ld a,(ldf45h)       ;e764
    inc a               ;e767
    jp nz,le77fh        ;e768
    pop bc              ;e76b
    push bc             ;e76c
    ld l,04h            ;e76d
    inc c               ;e76f
    jp z,le784h         ;e770
    call sub_e524h      ;e773
    ld l,05h            ;e776
    ld a,(ldf45h)       ;e778
    inc a               ;e77b
    jp z,le784h         ;e77c
le77fh:
    pop bc              ;e77f
    xor a               ;e780
    jp ldf01h           ;e781
le784h:
    push hl             ;e784
    call sub_e169h      ;e785
    ld (hl),0c0h        ;e788
    pop hl              ;e78a
le78bh:
    pop bc              ;e78b
    ld a,l              ;e78c
    ld (ldf45h),a       ;e78d
    jp sub_e178h        ;e790
le793h:
    ld c,0ffh           ;e793
    call sub_e703h      ;e795
    call z,sub_e5c1h    ;e798
    ret                 ;e79b
le79ch:
    ld c,00h            ;e79c
    call sub_e703h      ;e79e
    call z,sub_e603h    ;e7a1
    ret                 ;e7a4
sub_e7a5h:
    ex de,hl            ;e7a5
    add hl,de           ;e7a6
    ld c,(hl)           ;e7a7
    ld b,00h            ;e7a8
    ld hl,000ch         ;e7aa
    add hl,de           ;e7ad
    ld a,(hl)           ;e7ae
    rrca                ;e7af
    and 80h             ;e7b0
    add a,c             ;e7b2
    ld c,a              ;e7b3
    ld a,00h            ;e7b4
    adc a,b             ;e7b6
    ld b,a              ;e7b7
    ld a,(hl)           ;e7b8
    rrca                ;e7b9
    and 0fh             ;e7ba
    add a,b             ;e7bc
    ld b,a              ;e7bd
    ld hl,000eh         ;e7be
    add hl,de           ;e7c1
    ld a,(hl)           ;e7c2
    add a,a             ;e7c3
    add a,a             ;e7c4
    add a,a             ;e7c5
    add a,a             ;e7c6
    push af             ;e7c7
    add a,b             ;e7c8
    ld b,a              ;e7c9
    push af             ;e7ca
    pop hl              ;e7cb
    ld a,l              ;e7cc
    pop hl              ;e7cd
    or l                ;e7ce
    and 01h             ;e7cf
    ret                 ;e7d1
le7d2h:
    ld c,0ch            ;e7d2
    call sub_e318h      ;e7d4
    ld hl,(ldf43h)      ;e7d7
    ld de,0021h         ;e7da
    add hl,de           ;e7dd
    push hl             ;e7de
    ld (hl),d           ;e7df
    inc hl              ;e7e0
    ld (hl),d           ;e7e1
    inc hl              ;e7e2
    ld (hl),d           ;e7e3
le7e4h:
    call sub_e1f5h      ;e7e4
    jp z,le80ch         ;e7e7
    call sub_e15eh      ;e7ea
    ld de,000fh         ;e7ed
    call sub_e7a5h      ;e7f0
    pop hl              ;e7f3
    push hl             ;e7f4
    ld e,a              ;e7f5
    ld a,c              ;e7f6
    sub (hl)            ;e7f7
    inc hl              ;e7f8
    ld a,b              ;e7f9
    sbc a,(hl)          ;e7fa
    inc hl              ;e7fb
    ld a,e              ;e7fc
    sbc a,(hl)          ;e7fd
    jp c,le806h         ;e7fe
    ld (hl),e           ;e801
    dec hl              ;e802
    ld (hl),b           ;e803
    dec hl              ;e804
    ld (hl),c           ;e805
le806h:
    call le32dh         ;e806
    jp le7e4h           ;e809
le80ch:
    pop hl              ;e80c
    ret                 ;e80d
    ld hl,(ldf43h)      ;e80e
    ld de,0020h         ;e811
    call sub_e7a5h      ;e814
    ld hl,0021h         ;e817
    add hl,de           ;e81a
    ld (hl),c           ;e81b
    inc hl              ;e81c
    ld (hl),b           ;e81d
    inc hl              ;e81e
    ld (hl),a           ;e81f
    ret                 ;e820
le821h:
    ld hl,(le9afh)      ;e821
    ld a,(ldf42h)       ;e824
    ld c,a              ;e827
    call sub_e0eah      ;e828
    push hl             ;e82b
    ex de,hl            ;e82c
    call sub_df59h      ;e82d
    pop hl              ;e830
    call z,sub_df47h    ;e831
    ld a,l              ;e834
    rra                 ;e835
    ret c               ;e836
    ld hl,(le9afh)      ;e837
    ld c,l              ;e83a
    ld b,h              ;e83b
    call sub_e10bh      ;e83c
    ld (le9afh),hl      ;e83f
    jp le2a3h           ;e842
sub_e845h:
    ld a,(le9d6h)       ;e845
    ld hl,ldf42h        ;e848
    cp (hl)             ;e84b
    ret z               ;e84c
    ld (hl),a           ;e84d
    jp le821h           ;e84e
sub_e851h:
    ld a,0ffh           ;e851
    ld (le9deh),a       ;e853
    ld hl,(ldf43h)      ;e856
    ld a,(hl)           ;e859
    and 1fh             ;e85a
    dec a               ;e85c
    ld (le9d6h),a       ;e85d
    cp 1eh              ;e860
    jp nc,le875h        ;e862
    ld a,(ldf42h)       ;e865
    ld (le9dfh),a       ;e868
    ld a,(hl)           ;e86b
    ld (le9e0h),a       ;e86c
    and 0e0h            ;e86f
    ld (hl),a           ;e871
    call sub_e845h      ;e872
le875h:
    ld a,(ldf41h)       ;e875
    ld hl,(ldf43h)      ;e878
    or (hl)             ;e87b
    ld (hl),a           ;e87c
    ret                 ;e87d
    ld a,22h            ;e87e
    jp ldf01h           ;e880
    ld hl,0000h         ;e883
    ld (le9adh),hl      ;e886
    ld (le9afh),hl      ;e889
    xor a               ;e88c
    ld (ldf42h),a       ;e88d
    ld hl,0080h         ;e890
    ld (le9b1h),hl      ;e893
    call le1dah         ;e896
    jp le821h           ;e899
    call sub_e172h      ;e89c
    call sub_e851h      ;e89f
    jp sub_e451h        ;e8a2
    call sub_e851h      ;e8a5
    jp sub_e4a2h        ;e8a8
    ld c,00h            ;e8ab
    ex de,hl            ;e8ad
    ld a,(hl)           ;e8ae
    cp 3fh              ;e8af
    jp z,le8c2h         ;e8b1
    call sub_e0a6h      ;e8b4
    ld a,(hl)           ;e8b7
    cp 3fh              ;e8b8
    call nz,sub_e172h   ;e8ba
    call sub_e851h      ;e8bd
    ld c,0fh            ;e8c0
le8c2h:
    call sub_e318h      ;e8c2
    jp le1e9h           ;e8c5
    ld hl,(le9d9h)      ;e8c8
    ld (ldf43h),hl      ;e8cb
    call sub_e851h      ;e8ce
    call le32dh         ;e8d1
    jp le1e9h           ;e8d4
    call sub_e851h      ;e8d7
    call sub_e39ch      ;e8da
    jp le301h           ;e8dd
    call sub_e851h      ;e8e0
    jp le5bch           ;e8e3
    call sub_e851h      ;e8e6
    jp le5feh           ;e8e9
    call sub_e172h      ;e8ec
    call sub_e851h      ;e8ef
    jp sub_e524h        ;e8f2
    call sub_e851h      ;e8f5
    call sub_e416h      ;e8f8
    jp le301h           ;e8fb
    ld hl,(le9afh)      ;e8fe
    jp le929h           ;e901
    ld a,(ldf42h)       ;e904
    jp ldf01h           ;e907
    ex de,hl            ;e90a
    ld (le9b1h),hl      ;e90b
    jp le1dah           ;e90e
    ld hl,(le9bfh)      ;e911
    jp le929h           ;e914
    ld hl,(le9adh)      ;e917
    jp le929h           ;e91a
    call sub_e851h      ;e91d
    call sub_e43bh      ;e920
    jp le301h           ;e923
    ld hl,(le9bbh)      ;e926
le929h:
    ld (ldf45h),hl      ;e929
    ret                 ;e92c
    ld a,(le9d6h)       ;e92d
    cp 0ffh             ;e930
    jp nz,le93bh        ;e932
    ld a,(ldf41h)       ;e935
    jp ldf01h           ;e938
le93bh:
    and 1fh             ;e93b
    ld (ldf41h),a       ;e93d
    ret                 ;e940
    call sub_e851h      ;e941
    jp le793h           ;e944
    call sub_e851h      ;e947
    jp le79ch           ;e94a
    call sub_e851h      ;e94d
    jp le7d2h           ;e950
    ld hl,(ldf43h)      ;e953
    ld a,l              ;e956
    cpl                 ;e957
    ld e,a              ;e958
    ld a,h              ;e959
    cpl                 ;e95a
    ld hl,(le9afh)      ;e95b
    and h               ;e95e
    ld d,a              ;e95f
    ld a,l              ;e960
    and e               ;e961
    ld e,a              ;e962
    ld hl,(le9adh)      ;e963
    ex de,hl            ;e966
    ld (le9afh),hl      ;e967
    ld a,l              ;e96a
    and e               ;e96b
    ld l,a              ;e96c
    ld a,h              ;e96d
    and d               ;e96e
    ld h,a              ;e96f
    ld (le9adh),hl      ;e970
    ret                 ;e973
le974h:
    ld a,(le9deh)       ;e974
    or a                ;e977
    jp z,le991h         ;e978
    ld hl,(ldf43h)      ;e97b
    ld (hl),00h         ;e97e
    ld a,(le9e0h)       ;e980
    or a                ;e983
    jp z,le991h         ;e984
    ld (hl),a           ;e987
    ld a,(le9dfh)       ;e988
    ld (le9d6h),a       ;e98b
    call sub_e845h      ;e98e
le991h:
    ld hl,(ldf0fh)      ;e991
    ld sp,hl            ;e994
    ld hl,(ldf45h)      ;e995
    ld a,l              ;e998
    ld b,h              ;e999
    ret                 ;e99a
    call sub_e851h      ;e99b
    ld a,02h            ;e99e
    ld (le9d5h),a       ;e9a0
    ld c,00h            ;e9a3
    call sub_e707h      ;e9a5
    call z,sub_e603h    ;e9a8
    ret                 ;e9ab
le9ach:
    push hl             ;e9ac
le9adh:
    nop                 ;e9ad
    nop                 ;e9ae
le9afh:
    nop                 ;e9af
    nop                 ;e9b0
le9b1h:
    add a,b             ;e9b1
    nop                 ;e9b2
le9b3h:
    nop                 ;e9b3
    nop                 ;e9b4
le9b5h:
    nop                 ;e9b5
    nop                 ;e9b6
le9b7h:
    nop                 ;e9b7
    nop                 ;e9b8
le9b9h:
    nop                 ;e9b9
    nop                 ;e9ba
le9bbh:
    nop                 ;e9bb
    nop                 ;e9bc
le9bdh:
    nop                 ;e9bd
    nop                 ;e9be
le9bfh:
    nop                 ;e9bf
    nop                 ;e9c0
le9c1h:
    nop                 ;e9c1
    nop                 ;e9c2
le9c3h:
    nop                 ;e9c3
le9c4h:
    nop                 ;e9c4
le9c5h:
    nop                 ;e9c5
le9c6h:
    nop                 ;e9c6
    nop                 ;e9c7
le9c8h:
    nop                 ;e9c8
    nop                 ;e9c9
le9cah:
    nop                 ;e9ca
    nop                 ;e9cb
le9cch:
    nop                 ;e9cc
    nop                 ;e9cd
le9ceh:
    nop                 ;e9ce
    nop                 ;e9cf
le9d0h:
    nop                 ;e9d0
    nop                 ;e9d1
le9d2h:
    nop                 ;e9d2
le9d3h:
    nop                 ;e9d3
le9d4h:
    nop                 ;e9d4
le9d5h:
    nop                 ;e9d5
le9d6h:
    nop                 ;e9d6
le9d7h:
    nop                 ;e9d7
le9d8h:
    nop                 ;e9d8
le9d9h:
    nop                 ;e9d9
    nop                 ;e9da
    nop                 ;e9db
    nop                 ;e9dc
le9ddh:
    nop                 ;e9dd
le9deh:
    nop                 ;e9de
le9dfh:
    nop                 ;e9df
le9e0h:
    nop                 ;e9e0
le9e1h:
    nop                 ;e9e1
le9e2h:
    nop                 ;e9e2
le9e3h:
    nop                 ;e9e3
    nop                 ;e9e4
le9e5h:
    nop                 ;e9e5
    nop                 ;e9e6
le9e7h:
    nop                 ;e9e7
    nop                 ;e9e8
le9e9h:
    nop                 ;e9e9
le9eah:
    nop                 ;e9ea
le9ebh:
    nop                 ;e9eb
le9ech:
    nop                 ;e9ec
    nop                 ;e9ed
    nop                 ;e9ee
    nop                 ;e9ef
    nop                 ;e9f0
    nop                 ;e9f1
    nop                 ;e9f2
    nop                 ;e9f3
    nop                 ;e9f4
    nop                 ;e9f5
    nop                 ;e9f6
    nop                 ;e9f7
    nop                 ;e9f8
    nop                 ;e9f9
    nop                 ;e9fa
    nop                 ;e9fb
    nop                 ;e9fc
    nop                 ;e9fd
    nop                 ;e9fe
    nop                 ;e9ff
    jp 0f000h           ;ea00
    jp 0f003h           ;ea03
sub_ea06h:
    jp 0f006h           ;ea06
lea09h:
    jp 0f009h           ;ea09
sub_ea0ch:
    jp 0f00ch           ;ea0c
lea0fh:
    jp 0f00fh           ;ea0f
    jp 0f012h           ;ea12
sub_ea15h:
    jp 0f015h           ;ea15
sub_ea18h:
    jp 0f018h           ;ea18
sub_ea1bh:
    jp 0f01bh           ;ea1b
sub_ea1eh:
    jp 0f01eh           ;ea1e
lea21h:
    jp 0f021h           ;ea21
lea24h:
    jp 0f024h           ;ea24
sub_ea27h:
    jp 0f027h           ;ea27
sub_ea2ah:
    jp 0f02ah           ;ea2a
    jp 0f02dh           ;ea2d
sub_ea30h:
    jp 0f030h           ;ea30
    nop                 ;ea33
    nop                 ;ea34
    nop                 ;ea35
    nop                 ;ea36
    nop                 ;ea37
    nop                 ;ea38
    nop                 ;ea39
    nop                 ;ea3a
    nop                 ;ea3b
    nop                 ;ea3c
    nop                 ;ea3d
    nop                 ;ea3e
    nop                 ;ea3f

dirsave:
;ea40
;Saves the original value of DIRSIZE after boot
    db 0

jiffies:
;ea41
;CBM clock data: Jiffies (counts up to 50 or 60)
;
    db 0

secs:
;ea42
;CBM clock data: Seconds
;
    db 0

mins:
;ea43
;CBM clock data: Minutes
;
    db 0

hours:
;ea44
;CBM clock data: Hours
;
    db 0

jiffy2:
;ea45
;CBM clock data: Jiffy counter (MSB)
;
    db 0

jiffy1:
;ea46
;CBM clock data: Jiffy counter
;
    db 0

jiffy0:
;ea47
;CBM clock data: Jiffy counter (LSB)
;
    db 0

unused_ea48_ea5f:
;ea48-ea5f
;Not used by any known SoftBox BIOS
;
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

iosetup:
;ea60
;Byte that is written to IOBYTE
;
    db 0

lpt_dev:
;ea61
;CBM printer (LPT:) IEEE-488 primary address
;
    db 4

ptr_dev:
;ea62
;Paper Tape Reader (PTR:) IEEE-488 primary address
;
    db 6

ptp_dev:
;ea63
;Paper Tape Punch (PTP:) IEEE-488 primary address
;
    db 5

ser_mode:
;ea64
;Byte that is written to 8251 USART mode register
;
    db 7ah

ser_baud:
;ea65
;Byte that is written to COM8116 baud rate generator
;
    db 0eeh             ;9600 baud

ul1_dev:
;ea66
;ASCII printer (UL1:) IEEE-488 primary address
;
    db 4

termtype:
;ea67
;Terminal type: 0=ADM3A, 1=HZ1500, 2=TV912
;               Bit 7 is set if uppercase graphics mode
;
    db 2                ;TV912

leadin:
;ea68
;Terminal command lead-in: 1bh=escape, 7eh=tilde
;
    db 1bh              ;Escape for ADM-3A or TV912

xy_order:
;ea69
;X,Y order when sending move-to: 0=Y first, 1=X first
;
    db 0                ;Y-first for ADM-3A or TV912

y_offset:
;ea6a
;Offset added to Y when sending move-to sequence
;
    db 20h              ;Offset for ADM-3A or TV912

x_offset:
;ea6b
;Offset added to X when sending move-to sequence
;
    db 20h              ;Offset for ADM-3A or TV912

eoisav:
;ea6c
;Stores ppi2_pa IEEE-488 control lines after get byte
;
    db 0

lptype:
;ea6d
;CBM printer (LPT:) type
;
    db 0                ;CBM 3022

list_tmp:
;ea6e
;Stores the last character sent to the LIST routine
;
    db 0

unused_ea6f:
;ea6f
;Not used by any known SoftBox BIOS
;
    db 0

dtypes:
;ea70-ea77
;Disk drive types:

dtype_ab:
    db 1                ;A:, B: = CBM 8050
dtype_cd:
    db 2                ;C:, D: = Corvus 10MB
dtype_ef:
    db 0ffh             ;E:, F: = No device
dtype_gh:
    db 0ffh             ;G:, H: = No device
dtype_ij:
    db 0ffh             ;I:, J: = No device
dtype_kl:
    db 0ffh             ;K:, L: = No device
dtype_mn:
    db 0ffh             ;M:, N: = No device
dtype_op:
    db 0ffh             ;O:, P: = No device

ddevs:
;ea78-ea7f
;Disk drive device addresses:

ddev_ab:
    db 8                ;A:, B: = 8
ddev_cd:
    db 1                ;C:, D: = 1
ddev_ef:
    db 2                ;E:, F: = 2
ddev_gh:
    db 0                ;G:, H: = 0
ddev_ij:
    db 0                ;I:, J: = 0
ddev_kl:
    db 0                ;K:, L: = 0
ddev_mn:
    db 0                ;M:, N: = 0
ddev_op:
    db 0                ;O:, P: = 0

scrtab:
;ea80-eabf
;64 byte table for terminal character translation
;
;This is the table for Lear Siegler ADM-3A and TeleVideo 912
;
    db 31h+80h, 04h     ;31h -> 04h Set a TAB stop at current position
    db 32h+80h, 05h     ;32h -> 05h Clear TAB stop at current position
    db 33h+80h, 06h     ;33h -> 06h Clear all TAB stops
    db 6ah+80h, 0eh     ;6Ah -> 0Eh Reverse video on
    db 6bh+80h, 0fh     ;6Bh -> 0Fh Reverse video off
    db 51h+80h, 1ch     ;51h -> 1Ch Insert a space on current line
    db 57h+80h, 1dh     ;57h -> 1Dh Delete character at cursor
    db 45h+80h, 11h     ;45h -> 11h Insert a blank line
    db 52h+80h, 12h     ;52h -> 12h Scroll up one line
    db 54h+80h, 13h     ;54h -> 13h Clear to end of line
    db 74h+80h, 13h     ;74h -> 13h Clear to end of line
    db 59h+80h, 14h     ;59h -> 14h Clear to end of screen
    db 79h+80h, 14h     ;79h -> 14h Clear to end of screen
    db 2bh+80h, 1ah     ;2Bh -> 1Ah Clear screen
    db 2ah+80h, 1ah     ;2Ah -> 1Ah Clear screen
    db 3ah+80h, 1ah     ;3Ah -> 1Ah Clear screen
    db 3bh+80h, 1ah     ;3Bh -> 1Ah Clear screen
    db 5ah+80h, 1ah     ;5Ah -> 1Ah Clear screen
    db 3dh+80h, 1bh     ;3Dh -> 1Bh Move cursor to X,Y position
    db 28h+80h, 00h     ;28h -> 00h Null
    db 29h+80h, 00h     ;29h -> 00h Null
    db 00h              ;End of table

    ;Unused space at the end of the scrtab area
    db 05h, 0f2h, 0cdh, 20h, 0c3h, 30h, 0cah, 25h, 0e5h, 0ffh, 0ebh
    db 73h,  72h, 0d1h, 13h, 0fah, 25h,  50h, 01h,  39h,  21h

errbuf:
;eac0-eaff
;64 byte buffer for last error message returned from CBM DOS
;
    db 5ah,   19h, 0cdh,  7bh,  0bh, 0cdh, 0e9h,  0ah, 0feh,  22h
    db 0cah,  5ch,  24h, 0feh,  27h, 0c2h, 0d8h,  24h,  47h, 0cdh
    db 0dch,  0ah, 0cdh, 0dch,  0ah,  2ah, 0c1h,  37h,  2bh,  2bh
    db 0e5h, 0b8h,  0eh,  00h, 0cah,  7ch,  24h,  0ch, 0cdh, 0dch
    db  0ah, 0feh,  0dh, 0cah,  83h,  24h, 0b8h, 0c2h,  6fh,  24h
    db 0cdh, 09dh,  0ah, 0b8h, 0cah,  6fh,  24h, 0cdh, 0e9h,  0ah
    db 0cdh,  7bh,  0bh, 0feh

dbp_base:
;eb00-ebff
;Disk Parameter Blocks (DPB), 16 bytes for each drive A: to P:

dpb_a:
;eb00-eb0f
;
    dw 0000h            ;XLT: Address of sector translation table
    dw 2499h            ;Used as workspace by CP/M (3 words)
    dw 3bfeh
    dw 99cah
    dw 0b824h           ;DIRBUF: Address of 128-byte sector buffer
    dw 99cah            ;CSV: Address of the directory checksum vector
    dw 0fe24h           ;ALV: Address of the allocation vector
    dw 0e10dh           ;Unused

dpb_b:
;eb10-eb1f
;
    dw 0c122h           ;XLT: Address of sector translation table
    dw 0c237h           ;Used as workspace by CP/M (3 words)
    dw 24d8h
    dw 0fe79h
    dw 0da02h           ;DIRBUF: Address of 128-byte sector buffer
    dw 24d8h            ;CSV: Address of the directory checksum vector
    dw 0d6cdh           ;ALV: Address of the allocation vector
    dw 470ah            ;Unused

dpb_c:
;eb20-eb2f
;
    dw 0dccdh           ;XLT: Address of sector translation table
    dw 0cd0ah           ;Used as workspace by CP/M (3 words)
    dw 0adch
    dw 0bbc3h
    dw 0c524h           ;DIRBUF: Address of 128-byte sector buffer
    dw 0d3cdh           ;CSV: Address of the directory checksum vector
    dw 0c115h           ;ALV: Address of the allocation vector
    dw 0dccdh           ;Unused

dpb_d:
;eb30-eb3f
;
    dw 0fe0ah           ;XLT: Address of sector translation table
    dw 0c80dh           ;Used as workspace by CP/M (3 words)
    dw 0c2b8h
    dw 24b3h
    dw 0d6cdh           ;DIRBUF: Address of 128-byte sector buffer
    dw 0b80ah           ;CSV: Address of the directory checksum vector
    dw 0d2cah           ;ALV: Address of the allocation vector
    dw 0cd24h           ;Unused

dpb_e:
;eb40-eb4f
;
    dw 0a9dh            ;XLT: Address of sector translation table
    dw 2cfeh            ;Used as workspace by CP/M (3 words)
    dw 49cah
    dw 0c924h
    dw 0d3cdh           ;DIRBUF: Address of 128-byte sector buffer
    dw 0c315h           ;CSV: Address of the directory checksum vector
    dw 2449h            ;ALV: Address of the allocation vector
    dw 03cdh            ;Unused

dpb_f:
;eb50-eb5f
;
    dw 0f50fh           ;XLT: Address of sector translation table
    dw 243ah            ;Used as workspace by CP/M (3 words)
    dw 0b739h
    dw 13fah
    dw 0f117h           ;DIRBUF: Address of 128-byte sector buffer
    dw 0d3cdh           ;CSV: Address of the directory checksum vector
    dw 7915h            ;ALV: Address of the allocation vector
    dw 2cfeh            ;Unused

dpb_g:
;eb60-eb6f
;
    dw 49cah            ;XLT: Address of sector translation table
    dw 0c924h           ;Used as workspace by CP/M (3 words)
    dw 49cdh
    dw 0f51eh
    dw 0e678h           ;DIRBUF: Address of 128-byte sector buffer
    dw 0c483h           ;CSV: Address of the directory checksum vector
    dw 04aah            ;ALV: Address of the allocation vector
    dw 0c9f1h           ;Unused

dpb_h:
;eb70-eb7f
;
    dw 5acdh            ;XLT: Address of sector translation table
    dw 0cd19h           ;Used as workspace by CP/M (3 words)
    dw 0b7bh
    dw 22feh
    dw 0acah            ;DIRBUF: Address of 128-byte sector buffer
    dw 0fe25h           ;CSV: Address of the directory checksum vector
    dw 0c427h           ;ALV: Address of the allocation vector
    dw 0474h            ;Unused

dpb_i:
;eb80-eb8f
;
    dw 0cd4fh           ;XLT: Address of sector translation table
    dw 0adch            ;Used as workspace by CP/M (3 words)
    dw 0dfeh
    dw 47c8h
    dw 0d6cdh           ;DIRBUF: Address of 128-byte sector buffer
    dw 0b90ah           ;CSV: Address of the directory checksum vector
    dw 20cah            ;ALV: Address of the allocation vector
    dw 7825h            ;Unused

dpb_j:
;eb90-eb9f
;
    dw 0d3cdh           ;XLT: Address of sector translation table
    dw 0c315h           ;Used as workspace by CP/M (3 words)
    dw 250bh
    dw 0f3cdh
    dw 0cd0ah           ;DIRBUF: Address of 128-byte sector buffer
    dw 0ad6h            ;CSV: Address of the directory checksum vector
    dw 0cab9h           ;ALV: Address of the allocation vector
    dw 2539h            ;Unused

dpb_k:
;eba0-ebaf
;
    dw 0f678h           ;XLT: Address of sector translation table
    dw 0cd80h           ;Used as workspace by CP/M (3 words)
    dw 15d3h
    dw 9dcdh
    dw 0fe0ah           ;DIRBUF: Address of 128-byte sector buffer
    dw 0ca2ch           ;CSV: Address of the directory checksum vector
    dw 24fah            ;ALV: Address of the allocation vector
    dw 78c9h            ;Unused

dpb_l:
;ebb0-ebbf
;
    dw 0d3cdh           ;XLT: Address of sector translation table
    dw 7915h            ;Used as workspace by CP/M (3 words)
    dw 0f3cdh
    dw 0c30ah
    dw 2511h            ;DIRBUF: Address of 128-byte sector buffer
    dw 5acdh            ;CSV: Address of the directory checksum vector
    dw 0cd19h           ;ALV: Address of the allocation vector
    dw 2558h            ;Unused

dpb_m:
;ebc0-ebcf
;
    dw 24cdh            ;XLT: Address of sector translation table
    dw 2a24h            ;Used as workspace by CP/M (3 words)
    dw 384dh
    dw 3a19h
    dw 384ch            ;DIRBUF: Address of 128-byte sector buffer
    dw 0c347h           ;CSV: Address of the directory checksum vector
    dw 2371h            ;ALV: Address of the allocation vector
    dw 0eecdh           ;Unused

dpb_n:
;ebd0-ebdf
;
    dw 3a24h            ;XLT: Address of sector translation table
    dw 376ah            ;Used as workspace by CP/M (3 words)
    dw 0c0b7h
    dw 763ah
    dw 0fe38h           ;DIRBUF: Address of 128-byte sector buffer
    dw 0c055h           ;CSV: Address of the directory checksum vector
    dw 323ch            ;ALV: Address of the allocation vector
    dw 3876h            ;Unused

dpb_o:
;ebe0-ebef
;
    dw 0cdc9h           ;XLT: Address of sector translation table
    dw 195ah            ;Used as workspace by CP/M (3 words)
    dw 24cdh
    dw 0cd24h
    dw 1e49h            ;DIRBUF: Address of 128-byte sector buffer
    dw 35cdh            ;CSV: Address of the directory checksum vector
    dw 7916h            ;ALV: Address of the allocation vector
    dw 2cfeh            ;Unused

dpb_p:
;ebf0-ebff
;
    dw 6bcah            ;XLT: Address of sector translation table
    dw 0c925h           ;Used as workspace by CP/M (3 words)
    dw 713ah
    dw 3d37h
    dw 0a6fah           ;DIRBUF: Address of 128-byte sector buffer
    dw 4725h            ;CSV: Address of the directory checksum vector
    dw 7132h            ;ALV: Address of the allocation vector
    dw 3a37h            ;Unused

    db 72h, 37h         ;ec00
    dec a               ;ec02
    cp b                ;ec03
    jp nz,2594h         ;ec04
    ld (3772h),a        ;ec07
    ld a,(3772h)        ;ec0a
    sub b               ;ec0d
    sbc a,a             ;ec0e
    inc a               ;ec0f
    ld (37a6h),a        ;ec10
    call 25d3h          ;ec13
    ld (3773h),a        ;ec16
    jp 0af3h            ;ec19
    call 047ah          ;ec1c
    ret                 ;ec1f
    ld a,(3773h)        ;ec20
    or a                ;ec23
    call nz,047ah       ;ec24
    ld a,(3771h)        ;ec27
    or a                ;ec2a
    call z,047ah        ;ec2b
    ld hl,3772h         ;ec2e
    sub (hl)            ;ec31
    jp z,25cfh          ;ec32
    dec a               ;ec35
    jp nz,0af3h         ;ec36
    inc (hl)            ;ec39
    dec a               ;ec3a
    ld (37a6h),a        ;ec3b
    inc a               ;ec3e
    ld (3773h),a        ;ec3f
    jp 0af3h            ;ec42
    dec (hl)            ;ec45
    jp 25c5h            ;ec46
    ld a,(3771h)        ;ec49
    ld e,a              ;ec4c
    cp 32h              ;ec4d
    ld a,00h            ;ec4f
    ret nc              ;ec51
    ld d,a              ;ec52
    ld hl,3774h         ;ec53
    add hl,de           ;ec56
    scf                 ;ec57
    ld a,(hl)           ;ec58
    ret                 ;ec59
    push af             ;ec5a
    call 25d3h          ;ec5b
    ld de,3773h         ;ec5e
    jp nc,25f0h         ;ec61
    ld a,(de)           ;ec64
    ld (hl),a           ;ec65
    xor a               ;ec66
    ld (de),a           ;ec67
    ld hl,3771h         ;ec68
    inc (hl)            ;ec6b
    ld a,(37a6h)        ;ec6c
    or a                ;ec6f
    jp z,1713h          ;ec70
    pop af              ;ec73
    ld (37a6h),a        ;ec74
    ld hl,3772h         ;ec77
    or a                ;ec7a
    ret z               ;ec7b
    inc (hl)            ;ec7c
    ret                 ;ec7d
    call 265ah          ;ec7e
    ld a,d              ;ec81
    or e                ;ec82
    jp 25e4h            ;ec83
    call 265ah          ;ec86
    ld a,d              ;ec89
    or e                ;ec8a
    cpl                 ;ec8b
    jp z,25e4h          ;ec8c
    xor a               ;ec8f
    jp 25e4h            ;ec90
    ld a,(376ah)        ;ec93
    call 0af3h          ;ec96
    dec a               ;ec99
    jp 25e4h            ;ec9a
    ld a,(376ah)        ;ec9d
    call 0af3h          ;eca0
    or a                ;eca3
    jp 25e4h            ;eca4
    or 37h              ;eca7
    push af             ;eca9
    ld a,(37a6h)        ;ecaa
    or a                ;ecad
    jp z,2661h          ;ecae
    call 0b08h          ;ecb1
    call 0bd7h          ;ecb4
    jp nz,2649h         ;ecb7
    and 0a0h            ;ecba
    jp nz,2654h         ;ecbc
    call 0bc1h          ;ecbf
    jp z,2654h          ;ecc2
    pop af              ;ecc5
    sbc a,a             ;ecc6
    jp 25e4h            ;ecc7
    pop af              ;ecca
    ccf                 ;eccb
    sbc a,a             ;eccc
    jp 25e4h            ;eccd
    ld a,(37a6h)        ;ecd0
    or a                ;ecd3
    jp nz,2558h         ;ecd4
    pop bc              ;ecd7
    xor a               ;ecd8
    ld hl,0d34h         ;ecd9
    ld (37c1h),hl       ;ecdc
    jp 25e4h            ;ecdf
    or 37h              ;ece2
    push af             ;ece4
    call 0b7bh          ;ece5
    cp 3ch              ;ece8
    call nz,0474h       ;ecea
    call 0ad6h          ;eced
    or a                ;ecf0
    jp nz,268fh         ;ecf1
    call 0a9dh          ;ecf4
    call 0ad6h          ;ecf7
    cp 26h              ;ecfa
    jp nz,268fh         ;ecfc
    call 0a9dh          ;ecff
    jp 2677h            ;ed02
    ld hl,(37c1h)       ;ed05
    dec hl              ;ed08
    ld de,0000h         ;ed09
    inc hl              ;ed0c
    ld a,(hl)           ;ed0d
    cp 3eh              ;ed0e
    jp nz,269fh         ;ed10
    ld d,h              ;ed13
    ld e,l              ;ed14
    cp 0dh              ;ed15
    jp nz,2696h         ;ed17
    inc hl              ;ed1a
    push hl             ;ed1b
    ld hl,(37c1h)       ;ed1c
    ld a,d              ;ed1f
    or e                ;ed20
    call z,0474h        ;ed21
    ld a,(3876h)        ;ed24
    cp 20h              ;ed27
    jp nz,26c3h         ;ed29
    call 0d36h          ;ed2c
    pop hl              ;ed2f
    ld (37c1h),hl       ;ed30
    jp z,2654h          ;ed33
    jp 264fh            ;ed36
    pop hl              ;ed39
    jp 2661h            ;ed3a
    call 0b08h          ;ed3d
    ld c,a              ;ed40
    push bc             ;ed41
    call nz,0474h       ;ed42
    scf                 ;ed45
    call 0ca8h          ;ed46
    inc hl              ;ed49
    ld a,(hl)           ;ed4a
    or 40h              ;ed4b
    ld (hl),a           ;ed4d
    pop bc              ;ed4e
    and 20h             ;ed4f
    call z,04b0h        ;ed51
    ld a,(hl)           ;ed54
    and 80h             ;ed55
    call nz,048ch       ;ed57
    rra                 ;ed5a
    rra                 ;ed5b
    rra                 ;ed5c
    or (hl)             ;ed5d
    ld (hl),a           ;ed5e
    ld a,c              ;ed5f
    cp 2ch              ;ed60
    jp z,26c7h          ;ed62
    ret                 ;ed65
    ld de,3896h         ;ed66
    ld bc,4f00h         ;ed69
    jp 2700h            ;ed6c
    ld c,00h            ;ed6f
    ld de,38e6h         ;ed71
    ld b,3bh            ;ed74
    call 0b7bh          ;ed76
    ld hl,(37c1h)       ;ed79
    dec hl              ;ed7c
    ld a,(hl)           ;ed7d
    inc hl              ;ed7e
    cp 1ch              ;ed7f
    ld hl,2fe5h         ;ed81
    add a,l             ;ed84
    ld l,a              ;ed85
    ld a,0ffh           ;ed86
    adc a,h             ;ed88
    ld h,a              ;ed89
    ld a,e              ;ed8a
    cp c                ;ed8b
    jp nz,2117h         ;ed8c
    ld a,d              ;ed8f
    sub b               ;ed90
    jp nz,2117h         ;ed91
    pop hl              ;ed94
    inc a               ;ed95
    ret                 ;ed96
    inc sp              ;ed97
    inc sp              ;ed98
    jp 20f8h            ;ed99
    xor a               ;ed9c
    ret                 ;ed9d
    nop                 ;ed9e
    nop                 ;ed9f
    nop                 ;eda0
    nop                 ;eda1
    nop                 ;eda2
    nop                 ;eda3
    nop                 ;eda4
    nop                 ;eda5
    nop                 ;eda6
    nop                 ;eda7
    nop                 ;eda8
    nop                 ;eda9
    nop                 ;edaa
    nop                 ;edab
    nop                 ;edac
    nop                 ;edad
    nop                 ;edae
    nop                 ;edaf
    nop                 ;edb0
    nop                 ;edb1
    nop                 ;edb2
    nop                 ;edb3
    nop                 ;edb4
    nop                 ;edb5
    nop                 ;edb6
    nop                 ;edb7
    nop                 ;edb8
    nop                 ;edb9
    nop                 ;edba
    nop                 ;edbb
    nop                 ;edbc
    nop                 ;edbd
    nop                 ;edbe
    nop                 ;edbf
    nop                 ;edc0
    nop                 ;edc1
    nop                 ;edc2
    nop                 ;edc3
    nop                 ;edc4
    nop                 ;edc5
    nop                 ;edc6
    nop                 ;edc7
    nop                 ;edc8
    nop                 ;edc9
    nop                 ;edca
    nop                 ;edcb
    nop                 ;edcc
    nop                 ;edcd
    nop                 ;edce
    nop                 ;edcf
    nop                 ;edd0
    nop                 ;edd1
    nop                 ;edd2
    nop                 ;edd3
    nop                 ;edd4
    nop                 ;edd5
    nop                 ;edd6
    nop                 ;edd7
    nop                 ;edd8
    nop                 ;edd9
    nop                 ;edda
    nop                 ;eddb
    nop                 ;eddc
    nop                 ;eddd
    nop                 ;edde
    nop                 ;eddf
    nop                 ;ede0
    nop                 ;ede1
    nop                 ;ede2
    nop                 ;ede3
    nop                 ;ede4
    nop                 ;ede5
    nop                 ;ede6
    nop                 ;ede7
    nop                 ;ede8
    nop                 ;ede9
    nop                 ;edea
    nop                 ;edeb
    ld b,b              ;edec
    nop                 ;eded
    nop                 ;edee
    nop                 ;edef
    nop                 ;edf0
    nop                 ;edf1
    nop                 ;edf2
    nop                 ;edf3
    nop                 ;edf4
    nop                 ;edf5
    nop                 ;edf6
    nop                 ;edf7
    nop                 ;edf8
    nop                 ;edf9
    nop                 ;edfa
    nop                 ;edfb
    nop                 ;edfc
    nop                 ;edfd
    nop                 ;edfe
    nop                 ;edff
    nop                 ;ee00
    nop                 ;ee01
    nop                 ;ee02
    nop                 ;ee03
    nop                 ;ee04
    nop                 ;ee05
    nop                 ;ee06
    nop                 ;ee07
    nop                 ;ee08
    nop                 ;ee09
    nop                 ;ee0a
    nop                 ;ee0b
    nop                 ;ee0c
    nop                 ;ee0d
    nop                 ;ee0e
    nop                 ;ee0f
    nop                 ;ee10
    nop                 ;ee11
    nop                 ;ee12
    nop                 ;ee13
    nop                 ;ee14
    nop                 ;ee15
    nop                 ;ee16
    nop                 ;ee17
    nop                 ;ee18
    nop                 ;ee19
    nop                 ;ee1a
    nop                 ;ee1b
    nop                 ;ee1c
    nop                 ;ee1d
    nop                 ;ee1e
    nop                 ;ee1f
    nop                 ;ee20
    nop                 ;ee21
    nop                 ;ee22
    nop                 ;ee23
    nop                 ;ee24
    nop                 ;ee25
    nop                 ;ee26
    nop                 ;ee27
    nop                 ;ee28
    nop                 ;ee29
    nop                 ;ee2a
    nop                 ;ee2b
    nop                 ;ee2c
    nop                 ;ee2d
    nop                 ;ee2e
    nop                 ;ee2f
    nop                 ;ee30
    nop                 ;ee31
    nop                 ;ee32
    nop                 ;ee33
    nop                 ;ee34
    nop                 ;ee35
    nop                 ;ee36
    nop                 ;ee37
    nop                 ;ee38
    nop                 ;ee39
    nop                 ;ee3a
    nop                 ;ee3b
    nop                 ;ee3c
    nop                 ;ee3d
    nop                 ;ee3e
    nop                 ;ee3f
    nop                 ;ee40
    nop                 ;ee41
    nop                 ;ee42
    nop                 ;ee43
    nop                 ;ee44
    nop                 ;ee45
    nop                 ;ee46
    nop                 ;ee47
    nop                 ;ee48
    nop                 ;ee49
    nop                 ;ee4a
    nop                 ;ee4b
    nop                 ;ee4c
    nop                 ;ee4d
    nop                 ;ee4e
    nop                 ;ee4f
    nop                 ;ee50
    nop                 ;ee51
    nop                 ;ee52
    nop                 ;ee53
    nop                 ;ee54
    nop                 ;ee55
    nop                 ;ee56
    nop                 ;ee57
    nop                 ;ee58
    nop                 ;ee59
    nop                 ;ee5a
    nop                 ;ee5b
    nop                 ;ee5c
    nop                 ;ee5d
    nop                 ;ee5e
    nop                 ;ee5f
    nop                 ;ee60
    nop                 ;ee61
    nop                 ;ee62
    nop                 ;ee63
    nop                 ;ee64
    nop                 ;ee65
    nop                 ;ee66
    nop                 ;ee67
    nop                 ;ee68
    nop                 ;ee69
    nop                 ;ee6a
    nop                 ;ee6b
    nop                 ;ee6c
    nop                 ;ee6d
    nop                 ;ee6e
    nop                 ;ee6f
    nop                 ;ee70
    nop                 ;ee71
    nop                 ;ee72
    nop                 ;ee73
    nop                 ;ee74
    nop                 ;ee75
    nop                 ;ee76
    nop                 ;ee77
    nop                 ;ee78
    jr nz,0ee0bh        ;ee79
    nop                 ;ee7b
    ld b,d              ;ee7c
    nop                 ;ee7d
    nop                 ;ee7e
    nop                 ;ee7f
    nop                 ;ee80
    nop                 ;ee81
    nop                 ;ee82
    ld b,c              ;ee83
    ex af,af'           ;ee84
    add a,h             ;ee85
    sub b               ;ee86
    add a,c             ;ee87
    ex af,af'           ;ee88
    sub d               ;ee89
    ld c,c              ;ee8a
    add hl,bc           ;ee8b
    inc h               ;ee8c
    ld (bc),a           ;ee8d
    ld b,b              ;ee8e
    add a,h             ;ee8f
    ld bc,1208h         ;ee90
    inc h               ;ee93
    nop                 ;ee94
    ld (bc),a           ;ee95
    ex af,af'           ;ee96
    ld bc,4200h         ;ee97
    ex af,af'           ;ee9a
    djnz 0eea1h         ;ee9b
    inc h               ;ee9d
    db 10h, 80h         ;ee9e
    adc a,c             ;eea0
    ex af,af'           ;eea1
    ld b,b              ;eea2
    inc h               ;eea3
    inc h               ;eea4
    add a,d             ;eea5
    inc b               ;eea6
    sub b               ;eea7
    ld (bc),a           ;eea8
    ld (de),a           ;eea9
    ld (de),a           ;eeaa
    ld (de),a           ;eeab
    ld b,b              ;eeac
    ld hl,0824h         ;eead
    ld b,h              ;eeb0
    jr nz,0eec3h        ;eeb1
    adc a,c             ;eeb3
    add hl,bc           ;eeb4
    ex af,af'           ;eeb5
    adc a,c             ;eeb6
    ld (bc),a           ;eeb7
    ld de,4908h         ;eeb8
    add hl,bc           ;eebb
    inc h               ;eebc
    sub d               ;eebd
    ld c,c              ;eebe
    add hl,bc           ;eebf
    inc h               ;eec0
    inc h               ;eec1
    inc h               ;eec2
    sub b               ;eec3
    sub d               ;eec4
    inc h               ;eec5
    djnz 0eec9h         ;eec6
    add hl,bc           ;eec8
    ex af,af'           ;eec9
    ld b,d              ;eeca
    ld b,c              ;eecb
    ld de,2422h         ;eecc
    inc b               ;eecf
    sub b               ;eed0
    ex af,af'           ;eed1
    add hl,bc           ;eed2
    jr nz,0eedeh        ;eed3
    ex af,af'           ;eed5
    ld b,d              ;eed6
    ld bc,0211h         ;eed7
    ld c,b              ;eeda
    ld b,d              ;eedb
    inc b               ;eedc
    inc b               ;eedd
    add a,h             ;eede
    inc h               ;eedf
    add a,h             ;eee0
    inc b               ;eee1
    inc h               ;eee2
    jr nz,$+35          ;eee3
    ex af,af'           ;eee5
    djnz 0ee78h         ;eee6
    inc h               ;eee8
    inc h               ;eee9
    ld b,d              ;eeea
    djnz 0ee71h         ;eeeb
    inc h               ;eeed
    add a,c             ;eeee
    ld hl,2009h         ;eeef
    ld b,d              ;eef2
    ex af,af'           ;eef3
    ld hl,2409h         ;eef4
    inc h               ;eef7
    ld (0809h),hl       ;eef8
    add a,h             ;eefb
    ld (0912h),hl       ;eefc
    jr nz,0ef0eh        ;eeff
    ld a,(bc)           ;ef01

dos_buf:
;ef00-efff
;256 byte buffer for CBM DOS sector data
    db "60K PET CP/M vers. 2.2",0dh,0ah
    db "(c) 1981 Keith Frewin",0dh,0ah
    db "Revision 4/7/81"
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
