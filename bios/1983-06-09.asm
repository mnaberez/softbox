; z80dasm 1.1.3
; command line: z80dasm --labels --origin=61440 1983-06-09.bin

usart:    equ 008h      ;8251 USART (IC15)
usart_db: equ usart+0   ;  Data Buffer
usart_st: equ usart+1   ;  Status Register

baud_gen: equ 00ch      ;COM8116 Baud Rate Generator (IC14)
                        ;  D7-D4: TD-TA
                        ;  D3-D0: RD-RA

ppi1:     equ 010h      ;8255 PPI #1 (IC17)
ppi1_pa:  equ ppi1+0    ;  Port A: IEEE-488 Data In
ppi1_pb:  equ ppi1+1    ;  Port B: IEEE-488 Data Out
ppi1_pc:  equ ppi1+2    ;  Port C: DIP Switches
ppi1_cr:  equ ppi1+3    ;  Control Register

ppi2:     equ 014h      ;8255 PPI #2 (IC16)
ppi2_pa:  equ ppi2+0    ;  Port A:
                        ;    PA7 IEEE-488 IFC in
                        ;    PA6 IEEE-488 REN in
                        ;    PA5 IEEE-488 SRQ in
                        ;    PA4 IEEE-488 EOI in
                        ;    PA3 IEEE-488 NRFD in
                        ;    PA2 IEEE-488 NDAC in
                        ;    PA1 IEEE-488 DAV in
                        ;    PA0 IEEE-488 ATN in
ppi2_pb:  equ ppi2+1    ;  Port B:
                        ;    PB7 IEEE-488 IFC out
                        ;    PB6 IEEE-488 REN out
                        ;    PB5 IEEE-488 SRQ out
                        ;    PB4 IEEE-488 EOI out
                        ;    PB3 IEEE-488 NRFD out
                        ;    PB2 IEEE-488 NDAC out
                        ;    PB1 IEEE-488 DAV out
                        ;    PB0 IEEE-488 ATN out
ppi2_pc:  equ ppi2+2    ;  Port C:
                        ;    PC7 Unused
                        ;    PC6 Unused
                        ;    PC5 Corvus ACTIVE
                        ;    PC4 Corvus READY
                        ;    PC3 Unused
                        ;    PC2 LED "Ready"
                        ;    PC1 LED "B"
                        ;    PC0 LED "A"
ppi2_cr:  equ ppi2+3    ;  Control Register

corvus:   equ 018h      ;Corvus data bus

ser_cfg: equ 00003h     ;RS-232 serial configuration
                        ;  Bit 0: 0=CBM as terminal, 1=RS232 as terminal
track:    equ 00041h    ;Track number
sector:   equ 00043h    ;Sector number
drive:    equ 00044h    ;Drive number (0=A, 1=B, 2=C, etc.)
dos_err:  equ 0004fh    ;Last error code returned from CBM DOS
dma:      equ 00052h    ;DMA address
ccp_base: equ 0d400h    ;Start of CCP area
ser_mode: equ 0ea64h    ;Byte that is written to 8251 USART mode register
ser_baud: equ 0ea65h    ;Byte that is written to COM8116 baud rate generator

    org 0f000h

lf000h:
    jp boot          ;f000  Cold start
    jp wboot         ;f003  Warm start
    jp const         ;f006  Console status
    jp conin         ;f009  Console input
    jp conout        ;f00c  Console output
    jp list          ;f00f  Printer (List) output
    jp punch         ;f012  Paper tape punch output
    jp reader        ;f015  Paper tape reader input
    jp home          ;f018  Move to track 0 on selected disk
    jp seldsk        ;f01b  Select disk drive
    jp settrk        ;f01e  Set track number
    jp setsec        ;f021  Set sector number
    jp setdma        ;f024  Set DMA address
    jp read          ;f027  Read selected sector
    jp write         ;f02a  Write selected sector
    jp listst        ;f02d  Printer (List) status
    jp sectran       ;f030  Sector translation for skewing
    jp e_fb31h       ;f033
    jp e_fb47h       ;f036
    jp e_faf9h       ;f039
    jp e_fb21h       ;f03c
    jp cbm_get_byte  ;f03f  Read a single byte from the CBM
    jp e_fe62h       ;f042
    jp e_ff0bh       ;f045
    jp e_ff09h       ;f048
    jp e_ff1fh       ;f04b
    jp e_f9a3h       ;f04e
    jp e_f224h       ;f051
    jp e_faadh       ;f054
    jp e_fabch       ;f057
    jp e_f9bch       ;f05a
    jp e_fb56h       ;f05d
    jp e_fb72h       ;f060
    jp cbm_clear     ;f063  Clear the CBM screen
    jp cbm_jsr       ;f066  Jump to a subroutine in CBM memory
    jp cbm_poke      ;f069  Transfer bytes from the SoftBox to CBM memory
    jp cbm_peek      ;f06c  Transfer bytes from CBM memory to the SoftBox
    jp cbm_set_time  ;f06f  Set the time on the CBM real time clock
    jp cbm_get_time  ;f072  Read the CBM clocks (both RTC and jiffy counter)
    jp e_f578h       ;f075
    jp e_fac4h       ;f078
    jp e_fb49h       ;f07b
    jp e_fec1h       ;f07e
    jp cbm_clr_jiff  ;f081  Clear the CBM jiffy counter
    jp e_fb86h       ;f084

banner:
    db 0dh,0ah,"60K SoftBox CP/M vers. 2.2"
    db 0dh,0ah,"(c) 1982 Keith Frewin"
    db 0dh,0ah,"Revision 09-June-1983"
    db 00h

wboot:
    ld sp,00100h
    xor a
    call sub_f245h
lf0d9h:
    jr c,lf0e6h
lf0dbh:
    xor a
    call e_faadh
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
    ld hl,ccp_base+3
    jr z,init_and_jp_hl
lf0f6h:
    xor a
    call e_fac4h
lf0fah:
    jr wboot
sub_f0fch:
    ld hl,ccp_base
    ld c,000h
    push hl
    push bc
    ld hl,00000h
    ld (track),hl
    xor a
lf10ah:
    ld (sector),a
    ld (00048h),a
    ld (00051h),a
    call seldsk
    ld a,0ffh
    ld (drive),a
    pop bc
    pop hl
lf11dh:
    ld (dma),hl
    push hl
    push bc
    call read
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

init_and_jp_hl:
;Initialize low memory locations as required by CP/M and
;then jump to the address in HL.
;
    push hl             ;Save address
    ld bc,00080h
    call setdma         ;Initialize DMA pointer

    ld a,0c3h           ;0c3h = JP
    ld (00000h),a
    ld hl,0ea03h        ;Install warm boot jump
    ld (00001h),hl      ;  00000h JP 0ea03h

    ld (00005h),a
    ld hl,0dc06h        ;Install BDOS system call jump
    ld (00006h),hl      ;  00005h JP 0dc06h

    ld hl,00004h        ;TODO IOBYTE?
    ld a,(hl)
    and 00fh
    call e_f224h
    jr c,lf15ch
    ld (hl),000h
lf15ch:
    ld c,(hl)
    xor a                ;A=0
    ld (00048h),a
    ld (00051h),a
    dec a                ;A=0ffh
    ld (drive),a
    pop hl               ;Recall address
    jp (hl)              ;  and jump to it

home:
;Set the CP/M track to 0.
;
    ld bc,00000h        ;Fall through into settrk

settrk:
;Set the CP/M track to BC.
;
    ld (track),bc
    ret

setsec:
;Set the CP/M sector to BC.
;
    ld a,c
    ld (sector),a
    ret

setdma:
;The next disk operation will read data from, or write data to,
;the file buffer address given in BC.
;
    ld (dma),bc
    ret

seldsk:
;Select the disk drive in C (0=A:, 1=B:, ...).
;Returns the address of a Disk Parameter Header in HL.
;
    ld a,c
    call e_f224h
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
sectran:
    ld l,c
    ld h,b
    ret
e_f224h:
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
    call e_f224h
    ret nc
    ld a,c
    or a
    cp 006h
    ret nc
    cp 002h
    ccf
    ret

read:
    ld a,(00040h)
    call sub_f245h
    jp c,lf315h
    call sub_f6b9h
    ld a,001h
    call nz,sub_f2d8h
    ld a,(sector)
    rrca
    call sub_f2e5h
    xor a
    ld (00048h),a
    ret

write:
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
    ld a,(track)
    ld hl,0004ah
    cp (hl)
    jr nz,lf2b1h
    ld a,(00042h)
    inc hl
    cp (hl)
    jr nz,lf2b1h
    ld a,(sector)
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
    ld a,(sector)
    rrca
    call sub_f2e9h
    pop af
    dec a
    jr nz,lf2d1h
    ld a,(dos_err)
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
    ld de,(dma)
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
    out (corvus),a
    ld b,0ffh
lf305h:
    djnz lf305h
    in a,(ppi2_pc)
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
    ld hl,(dma)
    call sub_f37bh
    jr nz,lf36dh
    ld b,080h
lf334h:
    in a,(ppi2_pc)
    and 010h            ;Mask off all but bit 4 (Corvus READY)
    jr z,lf334h         ;Wait until Corvus READY=high

    in a,(corvus)
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
    ld hl,(dma)
lf35ch:
    in a,(ppi2_pc)
    and 010h            ;Mask off all but bit 4 (Corvus READY)
    jr z,lf35ch         ;Wait until Corvus READY=high

    ld a,(hl)
    out (corvus),a
    inc hl
    djnz lf35ch
    call sub_f37bh
    jr z,lf340h
lf36dh:
    ld hl,lf3e5h
    push af
    call puts
    pop af
    call sub_f402h
    and 0ffh
    ret
sub_f37bh:
    in a,(ppi2_pc)
    xor 010h
    and 030h
    jr nz,sub_f37bh
    ld b,019h
lf385h:
    djnz lf385h
    in a,(ppi2_pc)
    xor 010h
    and 030h
    jr nz,sub_f37bh
sub_f38fh:
    in a,(ppi2_pc)
    and 010h            ;Mask off all but bit 4 (Corvus READY)
    jr z,sub_f38fh      ;Wait until Corvus READY=high
    in a,(corvus)
    bit 7,a
    ret
sub_f39ah:
    push af
lf39bh:
    in a,(ppi2_pc)
    and 010h
    jr z,lf39bh
    pop af
    out (corvus),a
    ret
sub_f3a5h:
    ld hl,(track)
    ld a,000h
    ld b,006h
lf3ach:
    add hl,hl
    rla
    djnz lf3ach
    push af
    ld a,(sector)
    or l
    ld l,a
    ld de,0941ch
    ld a,(00040h)
    call e_f224h
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
    call e_faadh
    pop af
    pop hl
    add a,d
    ret
lf3e5h:
    db 0dh,0ah,07h,"*** HARD DISK ERROR ***  ",00h
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
    jp conout

boot:
    ld sp,00100h        ;Initialize stack pointer
    ld a,099h
    out (ppi1_cr),a
    ld a,098h
    out (ppi2_cr),a
    xor a               ;A=0
    out (ppi1_pb),a     ;Clear IEEE data out
lf427h:
    out (ppi2_pb),a     ;Clear IEEE control out

    ld c,002h
    ld hl,00000h        ;RAM start address
    ld de,lf000h        ;RAM end address + 1
lf431h:
    ld (hl),l
    inc hl
    ld a,h
    and 00fh
lf436h:
    or l
    jr nz,lf43fh

    in a,(ppi2_pc)
    xor 004h
    out (ppi2_pc),a     ;Invert "Ready" LED

lf43fh:
    dec de
    ld a,e
    or d
    jr nz,lf431h

    ld hl,00000h        ;RAM start address
    ld de,lf000h        ;RAM end address + 1
lf44ah:
    ld a,(hl)
    cp l
    jr nz,help_me
    cpl
    ld (hl),a
    inc hl
    ld a,h
    and 00fh
    or l
    jr nz,lf45dh

    in a,(ppi2_pc)
    xor 004h
    out (ppi2_pc),a     ;Invert "Ready" LED
lf45dh:
    dec de
    ld a,e
    or d
    jr nz,lf44ah

    ld hl,00000h        ;RAM start address
    ld de,lf000h        ;RAM end address + 1
lf468h:
    ld a,(hl)
    cpl
    cp l
    jr nz,help_me
    inc hl
    ld a,h
    and 00fh
    or l
    jr nz,lf47ah

    in a,(ppi2_pc)
    xor 004h
    out (ppi2_pc),a     ;Invert "Ready" LED
lf47ah:
    dec de
    ld a,e
    or d
    jr nz,lf468h

    ld hl,lf000h        ;ROM start address
    ld bc,00ffdh        ;Number of code bytes in the ROM
    call calc_checksum  ;Calculate ROM checksum

    ld c,003h
    ld hl,checksum      ;Load checksum in ROM
    cp (hl)             ;Any difference from the calculated value?
    jp z,lf4c5h         ;  No: ROM check passed

help_me:
;Self-test failed.  Blink the LED forever.
;
    ld b,c
lf492h:
    xor a
    out (ppi2_pc),a     ;Invert "Ready" LED

    ld de,lffffh
lf498h:
    dec de
    ld a,e
    or d
    jr nz,lf498h        ;Delay loop

    ld a,004h
    out (ppi2_pc),a     ;Turn on "Ready" LED

    ld de,lffffh
lf4a4h:
    dec de
    ld a,e
    or d
    jr nz,lf4a4h        ;Delay loop

    djnz lf492h

    ld b,003h
    ld de,lffffh
lf4b0h:
    dec de
    ld a,e
    or d
    jr nz,lf4b0h        ;Delay loop

    djnz lf4b0h
    jr help_me

calc_checksum:
    xor a               ;A=0
lf4bah:
    add a,(hl)          ;Add byte at pointer to A
    rrca
    ld d,a              ;Save A in D
    inc hl              ;Increment pointer
    dec bc              ;Decrement byte counter
    ld a,b
    or c                ;Test if byte counter is zero
    ld a,d              ;Recall A from D
    jr nz,lf4bah        ;Loop if more bytes remaining
    ret

lf4c5h:
    in a,(ppi2_pb)
    or 080h             ;Turn on bit 7 (IFC out)
    out (ppi2_pb),a     ;IFC=?

    xor a               ;A=0
    ld (ser_cfg),a      ;Initialize variables
    ld (00004h),a
    ld (00054h),a
    ld (00059h),a
    ld (0005ah),a
    ld (0ea80h),a
    out (ppi2_pc),a     ;Turn off LEDs

    ld bc,003e8h
    call e_fb86h

    ld a,01bh
    ld (0ea68h),a

    xor a               ;8251 USART initialization sequence
    out (usart_st),a
    nop
    out (usart_st),a
    nop
    out (usart_st),a

    ld a,040h           ;Reset
    out (usart_st),a

    ld a,07ah           ;Set mode
                        ;  Bit 7: S2   0 = 1 stop bit
                        ;  Bit 6: S1   1
                        ;  Bit 5: EP   1 = Even parity
                        ;  Bit 4: PEN  1
                        ;  Bit 3: L2   1 = 7 bit character
                        ;  Bit 2: L1   0
                        ;  Bit 1: B2   1 = 16X baud rate factor
                        ;  Bit 0: B1   0
    out (usart_st),a

    ld a,037h           ;Set command
                        ;  Bit 7: EH   0 = Normal (not hunt mode)
                        ;  Bit 6: IR   0 = Normal (not internal reset)
                        ;  Bit 5: RTS  1 = RTS output = 0
                        ;  Bit 4: ER   1 = Reset error flag
                        ;  Bit 3: SBRK 0 = Normal (not send break)
                        ;  Bit 2: RxE  1 = Receive enable
                        ;  Bit 1: DTR  1 = DTR output = 0
                        ;  Bit 0: TxE  1 = Transmit enable
    out (usart_st),a

    ld a,0eeh           ;Baud rate:
                        ;  0eeh = 9600 baud
                        ;  0cch = 4800 buad
                        ;  0aah = 2400 baud
                        ;  077h = 1200 baud
                        ;  055h =  300 baud
    out (baud_gen),a    ;Set baud rate to 9600 baud

    in a,(ppi2_pa)      ;IEEE-488 control lines in
    cpl                 ;Invert byte
    and 040h            ;Mask off all but bit 6 (REN in)
    jr nz,lf52bh

    ld a,001h
    ld (ser_cfg),a      ;1 = RS-232 standalone mode

wait_for_atn:
;Wait until the CBM computer addresses the SoftBox.  The SoftBox
;must stay off the bus until a program on the CBM side wakes it up
;by sending attention to its address (57).  At that point, the CBM
;must start waiting for SRQs and the SoftBox can take over the bus.
;
    in a,(ppi2_pa)      ;Read IEEE-488 control lines
    cpl                 ;Invert byte
    and 003h            ;Mask off all but bit 1 (ATN), bit 2 (DAV)
    in a,(ppi1_pa)      ;Read IEEE-488 data byte
    jr nz,wait_for_atn  ;Wait until ATN=? and DAV=?
    cp 039h
    jr nz,wait_for_atn  ;Wait until data byte = 57 (SoftBox address)

    in a,(ppi2_pa)      ;Read IEEE-488 control lines
    cpl                 ;Invert byte
    and 002h            ;Mask off all but bit 1 (DAV in)
    jr nz,wait_for_atn  ;Loop until DAV=?

lf524h:
    in a,(ppi2_pa)      ;Read IEEE-488 control lines
    cpl                 ;Invert byte
    and 002h            ;Mask off all but bit 1 (DAV in)
    jr z,lf524h         ;Wait until DAV=?

lf52bh:
    ld hl,loading
    call puts           ;Write "Loading CP/M ..."
    ld de,0080fh
    call e_fb31h
    ld bc,00007h
    call e_fb86h

    in a,(ppi2_pa)      ;Read IEEE-488 control lines
    cpl                 ;Invert byte
    and 004h            ;Mask off all but bit 3 (NDAC)
    jr z,lf555h         ;Wait for NDAC=?

    ld a,002h
    ld (0ea70h),a
    ld a,001h
    ld (0ea78h),a
    ld b,038h
    call sub_f0fch
    jr e_f578h
lf555h:
    call e_fb47h
    ld de,0080fh
    ld c,002h
    ld hl,lf68fh
    call e_fb56h
    ld d,008h
    ld c,01ch
    call sub_f651h
    jp nz,lf52bh
    ld de,00802h
    ld c,002h
    ld hl,lf687h
    call e_fb56h
e_f578h:
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
    ld a,(ser_cfg)
    and 001h
    ld b,a
    ld a,(0ea60h)
    and 0fch
    or b
    ld (ser_cfg),a

    xor a               ;8251 USART initialization sequence
    out (usart_st),a
    nop
    out (usart_st),a
    nop
    out (usart_st),a

    ld a,040h           ;Reset
    out (usart_st),a

    ld a,(ser_mode)
    out (usart_st),a    ;Set mode

    ld a,037h           ;Set command
                        ;  Bit 7: EH   0 = Normal (not hunt mode)
                        ;  Bit 6: IR   0 = Normal (not internal reset)
                        ;  Bit 5: RTS  1 = RTS output = 0
                        ;  Bit 4: ER   1 = Reset error flag
                        ;  Bit 3: SBRK 0 = Normal (not send break)
                        ;  Bit 2: RxE  1 = Receive enable
                        ;  Bit 1: DTR  1 = DTR output = 0
                        ;  Bit 0: TxE  1 = Transmit enable
    out (usart_st),a

    ld a,(ser_baud)
    out (baud_gen),a    ;Set baud rate

    call cbm_clear      ;Clear CBM screen (no-op for RS-232 standalone mode)

    ld a,(ser_cfg)
    rra
    jr nc,lf62bh        ;Jump if not in RS-232 standalone mode

    ld a,(0ea67h)       ;TODO: terminal capability?
    rla
    jr nc,lf62bh

    ld c,015h
    call conout         ;Clear screen for RS-232 standalone mode

lf62bh:
    ld hl,banner
    call puts           ;Display "60K SoftBox CP/M" banner
    call const          ;Returns 00=key waiting, FF=no key
    inc a
    call z,conin        ;Get a key if one is waiting
    ld hl,ccp_base
    jp init_and_jp_hl   ;Jump to start CCP

loading:
    db 0dh,0ah,"Loading CP/M ...",00h

sub_f651h:
    push bc
    push de
    ld hl,0f689h
    ld c,006h
    ld e,000h
    call e_fb56h
    pop de
    push de
    call sub_f9bfh
    pop de
    ld e,000h
    pop bc
    or a
    ret nz
    push de
    call e_faf9h
    ld hl,ccp_base
    ld b,000h
lf671h:
    call cbm_get_byte
    ld (hl),a
    inc hl
    djnz lf671h
    dec c
    jr nz,lf671h
    call e_fb21h
    pop de
    push de
    call e_fb72h
    pop de
    jp sub_f9bfh

lf687h:
    db "#2"
lf68ch:
    db "0:CP/M"
lf68fh:
    db "I0"

    push bc
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
    ld hl,(track)
    ld (0004ah),hl
    ld a,(sector)
    ld (0004ch),a
    ret
sub_f6b9h:
    ld a,(00040h)
    ld hl,00044h
    xor (hl)
    ld b,a
    ld a,(track)
    ld hl,00045h
    xor (hl)
    or b
    ld b,a
    ld a,(00042h)
    inc hl
    xor (hl)
    or b
    ld b,a
    ld a,(sector)
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
    ld (drive),a
    ld hl,(track)
    ld (00045h),hl
    ld a,(sector)
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
    ld a,(drive)
    call e_fabch
    ld hl,(00055h)
    ld c,005h
    call e_ff1fh
    ld a,(drive)
    and 001h
    add a,030h
    call e_fe62h
    ld a,(0004dh)
    call e_f9a3h
    ld a,(0004eh)
    call e_f9a3h
    call e_ff09h
    call e_fb47h
    ld a,(drive)
    call e_f9bch
    cp 016h
    jr nz,lf73fh
    ex af,af'
    or a
    ret z
    ex af,af'
lf73fh:
    ld (dos_err),a
    or a
    ret z
    ld hl,00050h
    dec (hl)
    jr z,lf752h
    ld a,(drive)
    call e_fac4h
    jr lf707h
lf752h:
    ld hl,bdos_err_on
    call puts           ;Display "BDOS err on "

    ld a,(drive)        ;Get current drive number
    add a,041h          ;Convert it to ASCII (0=A, 1=B, 2=C, etc)
    ld c,a
    call conout         ;Display drive letter

    ld hl,colon_space
    call puts           ;Display ": "

    ld hl,cbm_dos_errs  ;HL = pointer to CBM DOS error table
    call puts_dos_error ;Display an error message
lf76dh:
    call conin          ;Wait for a key to be pressed
    cp 003h
    jp z,00000h
    cp 03fh
    jr nz,lf790h
    ld hl,lf8d6h+1
    call puts
    ld hl,0eac0h
lf782h:
    ld a,(hl)
    cp 00dh
    jr z,lf76dh
    ld c,a
    push hl
    call conout
    pop hl
    inc hl
    jr lf782h
lf790h:
    ld a,(drive)
    call e_fac4h
    ld a,(dos_err)
    cp 01ah
    jp z,lf702h
    cp 015h
    jp z,lf702h
    ld a,000h
    ret

puts_dos_error:
;Write a description of a CBM DOS error to console out.
;HL be loaded with the address of cbm_dos_errs when calling.
;
    ld a,(dos_err)       ;A=last error code returned from CBM DOS
    cp (hl)
    ld a,(hl)
    inc hl
    jp z,puts
    inc a
    jp z,puts
lf7b3h:
    ld a,(hl)
    inc hl
    or a
    jr nz,lf7b3h
    jr puts_dos_error

cbm_dos_errs:
    db 1ah,"Disk write protected",00h
    db 19h,"Write verify error",00h
    db 1ch,"Long data block",00h
    db 14h,"Missing header",00h
    db 15h,"Disk not ready",00h
    db 4ah,"Disk not ready",00h
    db 16h,"Missing data block",00h
    db 17h,"Checksum error in data",00h
    db 1bh,"Checksum error in header",00h
    db 18h,"Byte decoding error",00h
    db 46h,"Commodore DOS bug !",00h
    db 49h,"Wrong DOS format",00h
    db 0ffh,"Unknown error code",00h

colon_space:
    db ": ",00h

bdos_err_on:
    db 0dh,0ah,"BDOS err on ",00h

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
    ld a,(drive)
    call e_f224h
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
e_f9a3h:
    push af
    ld a,020h
    call e_fe62h
    pop af
    ld e,02fh
lf9ach:
    sub 00ah
    inc e
    jr nc,lf9ach
    add a,03ah
    push af
    ld a,e
    call e_fe62h
    pop af
    jp e_fe62h
e_f9bch:
    call e_faadh
sub_f9bfh:
    ld e,00fh
    call e_faf9h
    ld hl,0eac0h
lf9c7h:
    call cbm_get_byte
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
    call cbm_get_byte
    ld (hl),a
    inc hl
    sub 030h
    add a,b
    push af
    ld c,03ch
lf9e5h:
    call cbm_get_byte
    dec c
    jp m,lf9eeh
    ld (hl),a
    inc hl
lf9eeh:
    cp 00dh
    jr nz,lf9e5h
    call e_fb21h
    pop af
    ret
lf9f7h:
    push hl
    ld hl,dos_cmds_3    ;"M-W",00h,013h,01h
    ld c,006h           ;6 bytes in string
    ld a,(drive)        ;CP/M drive number
    call e_fabch        ;? write to device ?
    call e_ff1fh
    pop hl

    ld a,(hl)
    push hl
    call e_ff0bh
    call e_fb47h

    ld hl,dos_cmds_2    ;"B-P 2 1"
    ld c,007h           ;7 bytes in string
    ld a,(drive)
    call e_fabch
    call e_ff1fh

    call e_ff09h
    call e_fb47h
    ld a,(drive)
    call e_faadh
    ld e,002h
    call e_fb31h
    pop hl

    inc hl
    ld c,0ffh
    call e_ff1fh
    call e_fb47h
    ld hl,0f8d2h
    jp lf6fch
lfa3eh:
    push hl
    ld hl,lf8cdh
    call lf6fch

    ld hl,dos_cmds_4    ;"M-R",00h,013h
    ld c,005h           ;5 bytes in string
    ld a,(drive)
    call e_fabch
    call e_ff1fh

    call e_ff09h
    call e_fb47h
    ld a,(drive)
    call e_faadh
    ld e,00fh
    call e_faf9h
    call cbm_get_byte
    pop hl
    ld (hl),a
    push hl
    call e_fb21h
    ld a,(drive)
    call e_fabch

    ld hl,0fae7h        ;"B-P 2 1"
    ld c,007h           ;7 bytes in string
    call e_ff1fh

    call e_ff09h
    call e_fb47h
    ld a,(drive)
    call e_f9bch
    cp 046h
    jr z,lfaa4h
    ld a,(drive)
    call e_faadh
    ld e,002h
    call e_faf9h
    pop de
    inc de
    ld b,0ffh
lfa9ah:
    call cbm_get_byte
    ld (de),a
    inc de
    djnz lfa9ah
    jp e_fb21h
lfaa4h:
    ld a,(drive)
    call e_fac4h
    pop hl
    jr lfa3eh
e_faadh:
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
e_fabch:
    call e_faadh
    ld e,00fh
    jp e_fb31h
e_fac4h:
    call e_faadh
    ld e,00fh
    push de

    ld c,002h           ;2 bytes in string
    ld hl,dos_cmds_0    ;"I0"
    rra
    jr nc,lfad5h
    ld hl,dos_cmds_1    ;"I1"

lfad5h:
    call e_fb56h
    pop de
    ld e,002h
    ld c,002h
    ld hl,lf687h
    jp e_fb56h

dos_cmds_0:
    db "I0"

dos_cmds_1:
    db "I1"

dos_cmds_2:
    db "B-P 2 1"

dos_cmds_3:
    db "M-W",00h,013h,01h

dos_cmds_4:
    db "M-R",00h,013h

e_faf9h:
    in a,(ppi2_pb)
    or 001h
    out (ppi2_pb),a
    ld a,040h
    or d
    call e_fe62h
    jr c,lfb13h
    ld a,e
    or 060h
    call p,e_fe62h
    in a,(ppi2_pb)
    or 00ch
    out (ppi2_pb),a
lfb13h:
    push af
    in a,(ppi2_pb)
    and 0feh
    out (ppi2_pb),a
    ld a,019h
lfb1ch:
    dec a
    jr nz,lfb1ch
lfb1fh:
    pop af
    ret
e_fb21h:
    in a,(ppi2_pb)
    or 001h
    out (ppi2_pb),a
    in a,(ppi2_pb)
    and 0f3h
    out (ppi2_pb),a
    ld a,05fh
lfb2fh:
    jr e_fb49h
e_fb31h:
    in a,(ppi2_pb)
    or 001h
    out (ppi2_pb),a
    ld a,020h
    or d
    call e_fe62h
    jr c,lfb13h
    ld a,e
    or 060h
    call p,e_fe62h
    jr lfb13h
e_fb47h:
    ld a,03fh
e_fb49h:
    push af
    in a,(ppi2_pb)
    or 001h
    out (ppi2_pb),a
    pop af
    call e_fe62h
    jr lfb13h
e_fb56h:
    in a,(ppi2_pb)
    or 001h
    out (ppi2_pb),a
    ld a,d
    or 020h
    call e_fe62h
    ld a,e
    or 0f0h
    call e_fb49h
    dec c
    call nz,e_ff1fh
    ld a,(hl)
    call e_ff0bh
    jr e_fb47h
e_fb72h:
    in a,(ppi2_pb)
    or 001h
    out (ppi2_pb),a
    ld a,d
    or 020h
    call e_fe62h
    ld a,e
    or 0e0h
    call e_fe62h
    jr e_fb47h
e_fb86h:
    call sub_fb8fh
    dec bc
    ld a,b
    or c
    jr nz,e_fb86h
    ret
sub_fb8fh:
    push bc
    ld b,0c8h
lfb92h:
    add a,000h
    djnz lfb92h
    pop bc
    ret

conin:
;Console input
;Blocks until a key is available, then returns the key in A.
;
    ld a,(ser_cfg)
    rra
    jp nc,ser_in        ;Jump out if RS-232 standalone mode

    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    or 004h             ;Turn on bit 2 (NDAC)
    out (ppi2_pb),a     ;NDAC=?

    ld a,002h           ;Command 002h = Wait for a key and send it
    call cbm_srq
    call cbm_get_byte

    push af
    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    and 0f3h            ;Clear bits 2 (NDAC) and 3 (NRFD)
    out (ppi2_pb),a     ;NDAC=?, NRFD=?
    pop af
    ret

const:
;Console status
;
;Returns A=0 if no character is ready, A=0FFh if one is.
;
    ld a,(ser_cfg)
    rra
    jp nc,ser_status    ;Jump out if RS-232 standalone mode

    ld a,001h           ;Command 001h = Key available?
    call cbm_srq
    ld a,000h
    ret nc              ;Return with A=0 if no key
    ld a,0ffh
    ret                 ;Return with A=0ffh if a key is available

conout:
;Console output.
;C = character to write to the screen
;
    ld a,(ser_cfg)
    rra
    jp nc,ser_out      ;Jump out if RS-232 standalone mode

    ld a,(0005ah)
    or a
    jp nz,lfc1dh
    ld a,c
    rla
    jr c,cbm_conout

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
    jr c,cbm_conout
lfbfch:
    ld hl,0ea80h
lfbffh:
    ld a,(hl)
    inc hl
    or a
    jr z,cbm_conout
    cp c
    ld a,(hl)
    inc hl
    jr nz,lfbffh
    cp 01bh
    jr z,lfc17h
    ld c,a

cbm_conout:
;Put the character in C on the CBM screen
;
    ld a,004h           ;Command 004h = Write to the terminal screen
    call cbm_srq
    ld a,c              ;A=C
    jp cbm_send_byte    ;Jump out to send byte in A

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
    ld a,(ser_cfg)
    and 003h
    cp 001h
    ret nz
    push de
    ld c,01bh
    call cbm_conout
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
    call cbm_conout
    pop af
    ld hl,0ea6ah
    sub (hl)
    and 01fh
    or 020h
    ld c,a
    jp cbm_conout

ser_status:
;RS-232 serial port receive status
;Returns A=0 if no byte is ready, A=0FFh if one is.
;
    in a,(usart_st)     ;Read USART status register
    and 002h            ;Mask off all but RxRDY bit
    ret z               ;Return A=0 if no byte
    or 0ffh
    ret                 ;Return A=FF if a byte is ready

ser_out:
;RS-232 serial port output
;C = byte to write to the port
;
    in a,(usart_st)     ;Read USART status register
    cpl                 ;Invert it
    and 084h            ;Mask off all but bits 7 (DSR) and 2 (TxEMPTY)
    jr nz,ser_out       ;Wait until DSR=1 and TxEMPTY=1

    ld a,c
    out (usart_db),a    ;Write data byte
    ret

ser_in:
;RS-232 serial port input
;Blocks until a byte is available, then returns it in A.
;
    in a,(usart_st)     ;Read USART status register
    and 002h            ;Mask off all but bit 1 (RxRDY)
    jr z,ser_in         ;Wait until a byte is available

    in a,(usart_db)     ;Read data byte
    ret

cbm_srq:
;Send a Service Request (SRQ) to the CBM computer.
;
;A = command to send, one of:
;  020h = Transfer bytes from the SoftBox to CBM memory
;  010h = Transfer bytes from CBM memory to the SoftBox
;  008h = Jump to a subroutine in CBM memory
;  004h = Write to the terminal screen
;  002h = Wait for a key and send it
;  001h = Key available?
;
;This routine queries the CBM keyboard status each time it is called.
;The Carry flag will be set if a key is available, clear if not.
;
    push af
lfc81h:
    in a,(ppi1_pa)      ;A = Read IC17 8255 Port A (IEEE data in)
    or a                ;Set flags
    jr nz,lfc81h        ;Wait for IEEE data bus to go to zero

    pop af
    out (ppi1_pb),a     ;Write data byte to IC17 8255 Port B (IEEE data out)

    in a,(ppi2_pb)
    or 020h
    out (ppi2_pb),a     ;Set SRQ high (?)

    in a,(ppi2_pb)
    and 0dfh
    out (ppi2_pb),a     ;Set SRQ low (?)

lfc95h:
    in a,(ppi1_pa)      ;A = Read IEEE data byte
    and 0c0h            ;Mask off all but bits 6 and 7
    jr z,lfc95h         ;Wait until CBM changes one of those bits

    rla                 ;Rotate bit 7 (key available status) into Carry flag
    push af             ;Push data IEEE data byte read from CBM

    ld a,000h
    out (ppi1_pb),a     ;Release IEEE data lines

lfca1h:
    in a,(ppi1_pa)      ;A = Read IEEE data byte
    or a                ;Set flags
    jr nz,lfca1h        ;Wait for IEEE data bus to go to zero
    pop af
    ret

list:
    ld a,(ser_cfg)
    and 0c0h
    jp z,ser_out
    jp p,cbm_conout
    ld e,0ffh
    and 040h
    jr z,lfcc3h
    ld a,(0ea66h)
    ld d,a
    call e_fb31h
    jp lfd8ch
lfcc3h:
    ld a,(0ea61h)
    ld d,a
    in a,(ppi2_pb)
    or 001h
    out (ppi2_pb),a
    ld a,(0ea6dh)
    ld b,a
    or a
    call z,sub_fb8fh
    call e_fb31h
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
    call e_fe62h
lfcf8h:
    bit 1,b
    jr nz,lfd04h
    call sub_fb8fh
    ld a,011h
    call e_fe62h
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
    call e_fe62h
lfd20h:
    in a,(ppi2_pb)
    or 001h
    out (ppi2_pb),a
    jp e_fb47h
lfd29h:
    ld a,c
    call sub_fd6bh
    call e_fe62h
    jp e_fb47h
listst:
    ld a,(ser_cfg)
    and 0c0h
    jr z,lfd61h
    rla
    ld a,0ffh
    ret nc
    ld a,(ser_cfg)
    and 040h
    ld a,(0ea61h)
    jr z,lfd4bh
    ld a,(0ea66h)
lfd4bh:
    ld d,a
    ld e,0ffh
    call e_fb31h
    call sub_fb8fh
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 008h            ;Mask off all except bit 3 (NRFD in)
    push af
    call e_fb47h
    pop af
    ret z
    dec a
    ret
lfd61h:
    in a,(usart_st)     ;Read USART status register
    cpl                 ;Invert it
    and 084h            ;Mask off all but bits 7 (DSR) and 2 (TxEMPTY)
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
punch:
    ld a,(ser_cfg)
    and 030h
    jp z,ser_out
    ld a,(0ea63h)
    ld d,a
    ld e,0ffh
    call e_fb31h
lfd8ch:
    ld a,c
    call e_fe62h
    jp e_fb47h
reader:
    ld a,(ser_cfg)
    and 00ch
    jp z,ser_in
    ld a,(0ea62h)
    ld d,a
    ld e,0ffh
    call e_faf9h
    call cbm_get_byte
    push af
    call e_fb21h
    pop af
    ret

puts:
;Write a null-terminated string to console out
;
;HL = Pointer to the string
;
    ld a,(hl)           ;Get the byte at pointer HL
    or a
    ret z               ;Return if byte is 0
    push hl             ;Save HL pointer
    ld c,a
    call conout         ;Send byte to console out
    pop hl              ;Recall HL pointer
    inc hl              ;Increment HL pointer
    jr puts             ;Loop to handle the next byte

cbm_clear:
;Clear the CBM screen
;
    ld a,(ser_cfg)
    rra
    ret nc              ;Do nothing and return if RS-232 standalone mode

    ld c,01ah           ;1A = Lear Siegler ADM-3A clear screen code
    jp cbm_conout

cbm_jsr:
;Jump to a subroutine in CBM memory
;
;HL = Subroutine address on CBM
;
    ld a,008h           ;Command 008h = Jump to a subroutine in CBM memory
    call cbm_srq
    ld a,l
    call cbm_send_byte  ;Send low byte of address
    ld a,h
    jp cbm_send_byte    ;Send high byte

cbm_peek:
;Transfer bytes from CBM memory to the SoftBox
;
;DE = Start address on CBM
;HL = Start address on SoftBox
;BC = Number of bytes to transfer
;
    ld a,010h           ;Command 010h = Transfer from CBM to SoftBox
    call cbm_srq
    ld a,c
    call cbm_send_byte  ;Send low byte of byte counter
    ld a,b
    call cbm_send_byte  ;Send high byte
    ld a,e
    call cbm_send_byte  ;Send low byte of CBM start address
    ld a,d
    call cbm_send_byte  ;Send high byte

    in a,(ppi2_pb)
    or 004h
    out (ppi2_pb),a     ;NDAC=?

cbm_peek_loop:
    call cbm_get_byte   ;Read a byte from the CBM
    ld (hl),a           ;Store it at the pointer
    inc hl              ;Increment pointer
    dec bc              ;Decrement bytes remaining to transfer
    ld a,b
    or c
    jr nz,cbm_peek_loop ;Loop until no bytes are remaining

    in a,(ppi2_pb)
    and 0f3h
    out (ppi2_pb),a     ;NDAC=?, NRFD=?
    ret

cbm_poke:
;Transfer bytes from the SoftBox to CBM memory
;
;DE = Start address on CBM
;HL = Start address on SoftBox
;BC = Number of bytes to transfer
;
    ld a,020h           ;Command 020h = Transfer from SoftBox to CBM
    call cbm_srq
    ld a,c
    call cbm_send_byte  ;Send low byte of byte counter
    ld a,b
    call cbm_send_byte  ;Send high byte
    ld a,e
    call cbm_send_byte  ;Send low byte of CBM start address
    ld a,d
    call cbm_send_byte  ;Send high byte
cbm_poke_loop:
    ld a,(hl)           ;Read byte at pointer
    call cbm_send_byte  ;Send it to the CBM
    inc hl              ;Increment pointer
    dec bc              ;Decrement bytes remaining to transfer
    ld a,b
    or c
    jr nz,cbm_poke_loop ;Loop until no bytes are remaining
    ret

cbm_set_time:
;Set the time on the CBM real time clock
    ld e,000h
    ld (0ea41h),de
    ld (0ea43h),hl
    ld de,00014h        ;CBM start address
    ld hl,0ea41h        ;SoftBox start address
    ld bc,00004h        ;4 bytes to transfer
    jp cbm_poke         ;Transfer from SoftBox to CBM

cbm_clr_jiff:
;Clear the CBM jiffy counter
;
    xor a               ;A=0
    ld (0ea45h),a       ;Clear jiffy counter values
    ld (0ea46h),a
    ld (0ea47h),a
    ld hl,0ea45h        ;SoftBox start address
    ld de,00018h        ;CBM start address
    ld bc,00003h        ;3 bytes to transfer
    jp cbm_poke         ;Transfer from SoftBox to CBM

cbm_get_time:
;Read the CBM clocks (both RTC and jiffy counter)
    ld bc,00007h        ;7 bytes to transfer
    ld hl,0ea41h        ;SoftBox start address
    ld de,00014h        ;CBM start address
    call cbm_peek       ;Transfer from CBM to SoftBox
    ld de,(0ea41h)
    ld hl,(0ea43h)
    ld a,(0ea45h)
    ld bc,(0ea46h)
    ret

e_fe62h:
    push af
lfe63h:
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 008h            ;Mask off all except bit 3 (NRFD in)
    jr z,lfe63h         ;Wait until NRFD=?

    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 004h            ;Mask off all except bit 2 (NDAC in)
    jr nz,lfe9eh        ;Jump if NDAC=?

    pop af
    out (ppi1_pb),a     ;Write byte to IEEE-488 data lines

    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    or 002h             ;Turn on bit 1 (DAV)
    out (ppi2_pb),a     ;DAV=?

lfe7ah:
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 004h            ;Mask off all except bit 2 (NDAC in)
    jr z,lfe7ah         ;Wait until NDAC=?

    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    and 0fdh            ;Turn off bit 1 (DAV)
    out (ppi2_pb),a     ;DAV=?

    xor a               ;A=0
    out (ppi1_pb),a     ;Release IEEE-488 data lines

lfe8ah:
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 004h            ;Mask off all except bit 2 (NDAC in)
    jr nz,lfe8ah        ;Wait until NDAC=?

    ex (sp),hl          ;Waste time
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl

    in a,(ppi2_pa)     ;Read IEEE-488 control lines in
    cpl                ;Mask off all except bit 2 (NDAC in)
    and 004h           ;Mask off all except bit 2 (NDAC in)
    jr nz,lfe8ah       ;Wait until NDAC=?

    or a               ;Set flags
    ret

lfe9eh:
    pop af
    scf
    ret

cbm_send_byte:
;Send a single byte to the CBM
;
    out (ppi1_pb),a     ;Put byte on IEEE data bus

lfea3h:
    in a,(ppi2_pa)
    cpl                 ;Invert A
    and 008h            ;Mask off all except bit 3 (NRFD in)
    jr z,lfea3h         ;Wait until NRFD=?

    in a,(ppi2_pb)
    or 002h             ;Turn on bit 2 (NDAC out)
    out (ppi2_pb),a     ;NDAC=?

lfeb0h:
    in a,(ppi2_pa)
    cpl                 ;Invert A
    and 004h            ;Mask off all except bit 2 (NDAC in)
    jr z,lfeb0h         ;Wait until NDAC=?

    in a,(ppi2_pb)
    and 0fdh            ;Turn off bit 2 (NDAC out)
    out (ppi2_pb),a     ;NDAC=?

    xor a               ;A=0
    out (ppi1_pb),a     ;Release IEEE-488 data lines
    ret

e_fec1h:
    in a,(ppi2_pb)
    and 0f7h
    out (ppi2_pb),a
lfec7h:
    in a,(ppi2_pa)
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

cbm_get_byte:
;Read a single byte from the CBM
    in a,(ppi2_pb)
    and 0f7h            ;Turn off bit 3 (NRFD out)
    out (ppi2_pb),a     ;NRFD=?

lfedeh:
    in a,(ppi2_pa)
    cpl                 ;Invert A
    and 002h            ;Mask off all except bit 1 (DAV in)
    jr nz,lfedeh        ;Wait until DAV=?

lfee5h:
    in a,(ppi1_pa)      ;Read byte from IEEE data bus
    push af             ;Put it on the stack

    in a,(ppi2_pa)
    ld (0ea6ch),a       ;TODO What is 0ea6ch?

    in a,(ppi2_pb)
    or 008h             ;Turn on bit 3 (NRFD out)
    out (ppi2_pb),a     ;NRFD=?

    in a,(ppi2_pb)
    and 0fbh            ;Turn off bit 2 (NDAC out)
    out (ppi2_pb),a     ;NDAC=?

lfef9h:
    in a,(ppi2_pa)
    cpl                 ;Invert A
    and 002h            ;Mask off all except bit 1 (DAV in)
    jr z,lfef9h         ;Wait until DAV=?

    in a,(ppi2_pb)
    or 004h             ;Turn on bit 2 (NDAC out)
    out (ppi2_pb),a     ;NDAC=?

    pop af              ;Pop the IEEE data byte off the stack
    or a                ;Set flags
    ret

e_ff09h:
    ld a,00dh
e_ff0bh:
    push af
    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    or 010h             ;Turn on bit 4 (EOI)
    out (ppi2_pb),a     ;EOI=?

    pop af
    call e_fe62h
    push af

    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    and 0efh            ;Turn off bit 5 (EOI)
    out (ppi2_pb),a     ;EOI=?

    pop af
    ret

e_ff1fh:
    ld a,(hl)
    inc hl
    call e_fe62h
    dec c
    jr nz,e_ff1fh
    ret

filler:
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
    db 00h,00h,00h

checksum:
    db 091h, 0ffh

lffffh:
    db 0ffh
