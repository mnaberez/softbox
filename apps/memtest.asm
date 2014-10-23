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

passes:     equ  002ah  ;Number of iterations run (2 bytes)
cur_addr:   equ  002ch  ;Current address of RAM under test (2 bytes)

lf:         equ 0ah     ;Line Feed
cr:         equ 0dh     ;Carriage Return

    org 0100h

    ld sp,0100h         ;Initialize stack pointer

    ld hl,0000h
    ld (passes),hl
    ld (0020h),hl
    ld (0022h),hl
    ld (0028h),hl

    xor a
    ld (0024h),a

    ld a,0feh
    ld (0025h),a

    ld hl,0ffffh
    ld (0026h),hl

    ld hl,testing_msg   ;HL = address of "Testing CP/M Box memory..."
    call puts           ;Write string to console out

    ld hl,0600h         ;HL = start address of RAM to test
    ld (cur_addr),hl    ;Store it as current address

    ld de,0ea00h        ;DE = end of RAM + 1 (?)

l0130h:
    ld c,01h
l0132h:
    ld b,01h
l0134h:
    ld hl,(cur_addr)    ;HL = current address to test
    call check_key      ;Check if a key has been pressed
    or a                ;Key pressed?
    jp nz,exit          ;  Yes: return to CP/M
    push bc

l013fh:
    call sub_023ch
    ld (hl),a
    inc hl
    ld a,l
    cp e
    jr nz,l013fh
    ld a,h
    cp d
    jr nz,l013fh
    pop bc
    djnz l0134h
    ld b,01h

l0151h:
    ld hl,(cur_addr)    ;HL = current address to test
    call check_key      ;Check if a key has been pressed
    or a                ;Key pressed?
    jp nz,exit          ;  Yes: return to CP/M
    push bc

l015ch:
    call sub_023ch
    ld b,a
    ld a,(hl)
    cp b
    jr z,l016ah
    ld (hl),b
    call sub_01ffh
    jr l017eh
l016ah:
    sub (hl)
    add a,(hl)
    sub (hl)
    add a,(hl)
    sub (hl)
    add a,(hl)
    sub (hl)
    add a,(hl)
    sub (hl)
    add a,(hl)
    sub (hl)
    add a,(hl)
    sub (hl)
    add a,(hl)
    sub (hl)
    add a,(hl)
    cp b
    call nz,sub_01ffh
l017eh:
    inc hl
    ld a,l
    cp e
    jr nz,l015ch
    ld a,h
    cp d
    jr nz,l015ch
    pop bc
    djnz l0151h
    push bc

                        ;"Pass=002a Err=00220020 0026-0028 Bit 24"

    ld hl,pass_msg      ;HL = address of "Pass=" string
    call puts           ;Write string to console out

    ld hl,(passes)      ;HL = number of passes run
    inc hl              ;Increment to next pass
    ld (passes),hl      ;Store passes
    call put_hex_word   ;Write number of passes to console out

    ld hl,err_msg       ;HL = address of " Err=" string
    call puts           ;Write string to console out

    ld hl,(0022h)
    call put_hex_word   ;Write First word after "Err="

    ld hl,(0020h)
    call put_hex_word   ;Write Second word after "Err="

    ld ix,0020h
    ld a,(ix+00h)
    or (ix+01h)
    or (ix+02h)
    or (ix+03h)
    jr z,l01e1h

    ld a,' '            ;A = space character
    call putc           ;Write character to console out

    ld hl,(0026h)
    call put_hex_word

    ld a,'-'            ;A = dash character
    call putc           ;Write character to console out

    ld hl,(0028h)
    call put_hex_word

    ld hl,bit_msg       ;HL = address of " Bit " string
    call puts           ;Write string to console out

    ld a,(0024h)
    call put_hex_byte

l01e1h:
    call newline        ;Write newline to console out

    pop bc
    inc c
    ld a,c
    cp 0bh
    jp nz,l0132h
    ld a,(0025h)
    rrca
    ld (0025h),a
    jp l0130h

exit:
;Return to CP/M
    ld hl,break_msg     ;HL = address of "Break..."
    call puts           ;Write string to console out
    jp warm             ;Warm start

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

put_hex_word:
;Write the word in HL to console out as a four digit hex number.
;
    ld a,h              ;A = H
    call put_hex_byte   ;Write byte to console out
    ld a,l              ;A = L
                        ;Fall through to put_hex_byte

put_hex_byte:
;Write the byte in A to console out as a two digit hex number.
;
    push af             ;Preserve A
    rrca                ;Rotate high nibble into low
    rrca
    rrca
    rrca
    call put_hex_nib    ;Write it to console out
    pop af              ;Recall A for the low nibble
                        ;Fall through to write it to console out

put_hex_nib:
;Write the low nibble in A to console out as a one digit hex number.
;
    and 0fh             ;Mask off high nibble
    cp 0ah              ;Convert low nibble to ASCII char
    jr c,l02a9h
    add a,07h
l02a9h:
    add a,30h
    jp putc             ;Write char to console out and return.

puts:
;Write a null-terminated string to console out
;
;HL = Pointer to the string
;
    ld a,(hl)           ;Get the byte at pointer HL
    or a                ;Set flags
    ret z               ;Return if byte is 0
    call putc           ;Send the char to console out
    inc hl              ;Increment HL pointer
    jr puts             ;Loop to handle the next byte

newline:
;Write carriage return and line feed to console out
;
    ld a,cr
    call putc           ;Write carriage return
    ld a,lf
    call putc           ;Write line feed
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

get_key:
;Blocking keyboard input.  Wait for a key to be pressed
;and then return it in A.
;
    call check_key      ;Check for a key
    or a                ;Key pressed?
    jr z,get_key        ;  No: loop
    ret                 ;Return with the key in A

check_key:
;Non-blocking keyboard input.  Check if a key has been pressed
;and return it in A.  If no has been pressed, returns A=0.
;
    push hl
    push bc
    push de
    call const          ;Get console status
    or a                ;Key pressed?
    call nz,conin       ;  Yes: read the key
    pop de
    pop bc
    pop hl
    ret

putc:
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
