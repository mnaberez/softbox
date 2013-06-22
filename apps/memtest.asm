;MEMTEST.COM
;  Perform a RAM test on the SoftBox's internal memory
;
;The test will run continuously, printing one line to the
;console on each iteration.  Pressing any key will end
;the test and return to the CP/M prompt.
;
;Usage:
;  "MEMTEST"
;

warm:       equ  0000h  ;Warm start entry point
const:      equ 0f006h  ;BIOS Console status
conin:      equ 0f009h  ;BIOS Console input
conout:     equ 0f00ch  ;BIOS Console output

lf:         equ 0ah     ;Line Feed
cr:         equ 0dh     ;Carriage Return

    org 0100h

l0100h:
    ld sp,l0100h        ;0100  31 00 01
    ld hl,0000h         ;0103  21 00 00
    ld (002ah),hl       ;0106  22 2a 00
    ld (0020h),hl       ;0109  22 20 00
    ld (0022h),hl       ;010c  22 22 00
    ld (0028h),hl       ;010f  22 28 00
    xor a               ;0112  af
    ld (0024h),a        ;0113  32 24 00
    ld a,0feh           ;0116  3e fe
    ld (0025h),a        ;0118  32 25 00
    ld hl,0ffffh        ;011b  21 ff ff
    ld (0026h),hl       ;011e  22 26 00
    ld hl,testing_msg   ;0121  21 00 00
    call puts           ;0124  cd 00 00
    ld hl,0600h         ;0127  21 00 06
    ld (002ch),hl       ;012a  22 2c 00
    ld de,0ea00h        ;012d  11 00 ea
l0130h:
    ld c,01h            ;0130  0e 01
l0132h:
    ld b,01h            ;0132  06 01
l0134h:
    ld hl,(002ch)       ;0134  2a 2c 00
    call sub_0300h      ;0137  cd 00 00
    or a                ;013a  b7
    jp nz,l01f6h        ;013b  c2 00 00
    push bc             ;013e  c5
l013fh:
    call sub_023ch      ;013f  cd 00 00
    ld (hl),a           ;0142  77
    inc hl              ;0143  23
    ld a,l              ;0144  7d
    cp e                ;0145  bb
    jr nz,l013fh        ;0146  20 f7
    ld a,h              ;0148  7c
    cp d                ;0149  ba
    jr nz,l013fh        ;014a  20 f3
    pop bc              ;014c  c1
    djnz l0134h         ;014d  10 e5
    ld b,01h            ;014f  06 01
l0151h:
    ld hl,(002ch)       ;0151  2a 2c 00
    call sub_0300h      ;0154  cd 00 00
    or a                ;0157  b7
    jp nz,l01f6h        ;0158  c2 00 00
    push bc             ;015b  c5
l015ch:
    call sub_023ch      ;015c  cd 00 00
    ld b,a              ;015f  47
    ld a,(hl)           ;0160  7e
    cp b                ;0161  b8
    jr z,l016ah         ;0162  28 00
    ld (hl),b           ;0164  70
    call sub_01ffh      ;0165  cd 00 00
    jr l017eh           ;0168  18 00
l016ah:
    sub (hl)            ;016a  96
    add a,(hl)          ;016b  86
    sub (hl)            ;016c  96
    add a,(hl)          ;016d  86
    sub (hl)            ;016e  96
    add a,(hl)          ;016f  86
    sub (hl)            ;0170  96
    add a,(hl)          ;0171  86
    sub (hl)            ;0172  96
    add a,(hl)          ;0173  86
    sub (hl)            ;0174  96
    add a,(hl)          ;0175  86
    sub (hl)            ;0176  96
    add a,(hl)          ;0177  86
    sub (hl)            ;0178  96
    add a,(hl)          ;0179  86
    cp b                ;017a  b8
    call nz,sub_01ffh   ;017b  c4 00 00
l017eh:
    inc hl              ;017e  23
    ld a,l              ;017f  7d
    cp e                ;0180  bb
    jr nz,l015ch        ;0181  20 d9
    ld a,h              ;0183  7c
    cp d                ;0184  ba
    jr nz,l015ch        ;0185  20 d5
    pop bc              ;0187  c1
    djnz l0151h         ;0188  10 c7
    push bc             ;018a  c5
    ld hl,pass_msg      ;018b  21 00 00
    call puts           ;018e  cd 00 00
    ld hl,(002ah)       ;0191  2a 2a 00
    inc hl              ;0194  23
    ld (002ah),hl       ;0195  22 2a 00
    call sub_0293h      ;0198  cd 00 00
    ld hl,err_msg       ;019b  21 00 00
    call puts           ;019e  cd 00 00
    ld hl,(0022h)       ;01a1  2a 22 00
    call sub_0293h      ;01a4  cd 00 00
    ld hl,(0020h)       ;01a7  2a 20 00
    call sub_0293h      ;01aa  cd 00 00
    ld ix,0020h         ;01ad  dd 21 20 00
    ld a,(ix+00h)       ;01b1  dd 7e 00
    or (ix+01h)         ;01b4  dd b6 01
    or (ix+02h)         ;01b7  dd b6 02
    or (ix+03h)         ;01ba  dd b6 03
    jr z,l01e1h         ;01bd  28 00
    ld a,' '            ;01bf  3e 20
    call put_char       ;01c1  cd 00 00
    ld hl,(0026h)       ;01c4  2a 26 00
    call sub_0293h      ;01c7  cd 00 00
    ld a,'-'            ;01ca  3e 2d
    call put_char       ;01cc  cd 00 00
    ld hl,(0028h)       ;01cf  2a 28 00
    call sub_0293h      ;01d2  cd 00 00
    ld hl,bit_msg       ;01d5  21 00 00
    call puts           ;01d8  cd 00 00
    ld a,(0024h)        ;01db  3a 24 00
    call sub_0298h      ;01de  cd 00 00
l01e1h:
    call newline        ;01e1  cd 00 00
    pop bc              ;01e4  c1
    inc c               ;01e5  0c
    ld a,c              ;01e6  79
    cp 0bh              ;01e7  fe 0b
    jp nz,l0132h        ;01e9  c2 32 01
    ld a,(0025h)        ;01ec  3a 25 00
    rrca                ;01ef  0f
    ld (0025h),a        ;01f0  32 25 00
    jp l0130h           ;01f3  c3 30 01
l01f6h:
    ld hl,break_msg     ;01f6  21 00 00
    call puts           ;01f9  cd 00 00
    jp warm             ;01fc  c3 00 00
sub_01ffh:
    push bc             ;01ff  c5
    push de             ;0200  d5
    push hl             ;0201  e5
    xor b               ;0202  a8
    ld hl,0024h         ;0203  21 24 00
    or (hl)             ;0206  b6
    ld (hl),a           ;0207  77
    ld hl,(0020h)       ;0208  2a 20 00
    inc hl              ;020b  23
    ld (0020h),hl       ;020c  22 20 00
    ld a,h              ;020f  7c
    or l                ;0210  b5
    jr nz,l021ah        ;0211  20 00
    ld hl,(0022h)       ;0213  2a 22 00
    inc hl              ;0216  23
    ld (0022h),hl       ;0217  22 22 00
l021ah:
    pop de              ;021a  d1
    push de             ;021b  d5
    ld a,(0026h)        ;021c  3a 26 00
    sub e               ;021f  93
    ld a,(0027h)        ;0220  3a 27 00
    sbc a,d             ;0223  9a
    jr c,l022ah         ;0224  38 00
    ld (0026h),de       ;0226  ed 53 26 00
l022ah:
    ld a,(0028h)        ;022a  3a 28 00
    sub e               ;022d  93
    ld a,(0029h)        ;022e  3a 29 00
    sbc a,d             ;0231  9a
    jr nc,l0238h        ;0232  30 00
    ld (0028h),de       ;0234  ed 53 28 00
l0238h:
    pop hl              ;0238  e1
    pop de              ;0239  d1
    pop bc              ;023a  c1
    ret                 ;023b  c9
sub_023ch:
    push hl             ;023c  e5
    ld b,00h            ;023d  06 00
    ld hl,l0244h        ;023f  21 00 00
    add hl,bc           ;0242  09
    add hl,bc           ;0243  09
l0244h:
    ex (sp),hl          ;0244  e3
    ret                 ;0245  c9

    jr l025ah           ;0246  18 00
    jr l0268h           ;0248  18 00
    jr l026ah           ;024a  18 00
    jr l026dh           ;024c  18 00
    jr l0270h           ;024e  18 00
    jr l0265h           ;0250  18 00
    jr l0273h           ;0252  18 00
    jr l0263h           ;0254  18 00
    jr l027eh           ;0256  18 00
    jr l028bh           ;0258  18 00
l025ah:
    ld a,l              ;025a  7d
    rrca                ;025b  0f
    rrca                ;025c  0f
    rrca                ;025d  0f
    xor h               ;025e  ac
    and 01h             ;025f  e6 01
    jr z,l0265h         ;0261  28 00
l0263h:
    xor a               ;0263  af
    ret                 ;0264  c9
l0265h:
    ld a,0ffh           ;0265  3e ff
    ret                 ;0267  c9
l0268h:
    ld a,l              ;0268  7d
    ret                 ;0269  c9
l026ah:
    ld a,0aah           ;026a  3e aa
    ret                 ;026c  c9
l026dh:
    ld a,l              ;026d  7d
    cpl                 ;026e  2f
    ret                 ;026f  c9
l0270h:
    ld a,55h            ;0270  3e 55
    ret                 ;0272  c9
l0273h:
    ld a,l              ;0273  7d
    rrca                ;0274  0f
    rrca                ;0275  0f
    rrca                ;0276  0f
    xor h               ;0277  ac
    and 01h             ;0278  e6 01
    jr z,l0263h         ;027a  28 e7
    jr l0265h           ;027c  18 e7
l027eh:
    ld a,l              ;027e  7d
    rra                 ;027f  1f
    jr c,l0286h         ;0280  38 00
    ld a,(0025h)        ;0282  3a 25 00
    ret                 ;0285  c9
l0286h:
    ld a,(0025h)        ;0286  3a 25 00
    cpl                 ;0289  2f
    ret                 ;028a  c9
l028bh:
    ld a,l              ;028b  7d
    rra                 ;028c  1f
    jr nc,l0286h        ;028d  30 f7
    ld a,(0025h)        ;028f  3a 25 00
    ret                 ;0292  c9
sub_0293h:
    ld a,h              ;0293  7c
    call sub_0298h      ;0294  cd 00 00
    ld a,l              ;0297  7d
sub_0298h:
    push af             ;0298  f5
    rrca                ;0299  0f
    rrca                ;029a  0f
    rrca                ;029b  0f
    rrca                ;029c  0f
    call sub_02a1h      ;029d  cd 00 00
    pop af              ;02a0  f1
sub_02a1h:
    and 0fh             ;02a1  e6 0f
    cp 0ah              ;02a3  fe 0a
    jr c,l02a9h         ;02a5  38 00
    add a,07h           ;02a7  c6 07
l02a9h:
    add a,30h           ;02a9  c6 30
    jp put_char         ;02ab  c3 00 00

puts:
;Write a null-terminated string to console out
;
;HL = Pointer to the string
;
    ld a,(hl)           ;Get the byte at pointer HL
    or a                ;Set flags
    ret z               ;Return if byte is 0
    call put_char       ;Send the char to console out
    inc hl              ;Increment HL pointer
    jr puts             ;Loop to handle the next byte

newline:
;Write carriage return and line feed to console out
;
    ld a,cr
    call put_char       ;Write carriage return
    ld a,lf
    call put_char       ;Write line feed
    ret

testing_msg:
    db cr,lf,"Testing CP/M Box memory",cr,lf,00h
break_msg:
    db "Break...",00h
pass_msg:
    db "Pass=",00h
err_msg:
    db " Err=",00h
bit_msg:
    db " Bit ",00h

l02f9h:
    call sub_0300h      ;02f9  cd 00 00
    or a                ;02fc  b7
    jr z,l02f9h         ;02fd  28 fa
    ret                 ;02ff  c9

sub_0300h:
    push hl             ;0300  e5
    push bc             ;0301  c5
    push de             ;0302  d5
    call const          ;0303  cd 06 f0
    or a                ;0306  b7
    call nz,conin       ;0307  c4 09 f0
    pop de              ;030a  d1
    pop bc              ;030b  c1
    pop hl              ;030c  e1
    ret                 ;030d  c9

put_char:
;Write the char in A to console out, preserving most registers.
;
    push bc
    push hl
    push de
    push af
    ld c,a              ;C = A
    call conout         ;Write C to console out
    pop af
    pop de
    pop hl
    pop bc
    ret
