; z80dasm 1.1.3
; command line: z80dasm --labels --origin=61440 1983-06-09.bin

usart:    equ 08h       ;8251 USART (IC15)
usart_db: equ usart+0   ;  Data Buffer
usart_st: equ usart+1   ;  Status Register

baud_gen: equ 0ch       ;COM8116 Baud Rate Generator (IC14)
                        ;  D7-D4: TD-TA
                        ;  D3-D0: RD-RA

ppi1:     equ 10h       ;8255 PPI #1 (IC17)
ppi1_pa:  equ ppi1+0    ;  Port A: IEEE-488 Data In
ppi1_pb:  equ ppi1+1    ;  Port B: IEEE-488 Data Out
ppi1_pc:  equ ppi1+2    ;  Port C: DIP Switches
ppi1_cr:  equ ppi1+3    ;  Control Register

ppi2:     equ 14h       ;8255 PPI #2 (IC16)
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

corvus:   equ 18h       ;Corvus data bus

jp_warm:  equ 0000h     ;Jump to BDOS warm start (3 byte instruction)
iobyte:   equ 0003h     ;CP/M I/O Mapping
                        ;
                        ;                  List    Punch   Reader  Console
                        ;  Device          LST:    PUN:    RDR:    CON:
                        ;  Bit Positions   7,6     5,4     3,2     1,0
                        ;
                        ;  Dec   Binary
                        ;   0      00      TTY:    TTY:    TTY:    TTY:
                        ;   1      01      CRT:    PTP:    PTR:    CRT:
                        ;   2      10      LPT:    UP1:    UR1:    BAT:
                        ;   3      11      UL1:    UP2:    UR2:    UC1:
                        ;
                        ;  TTY:    TeleTYpe                    (RS-232 port)
                        ;  CRT:    Cathode Ray Tube           (CBM computer)
                        ;  BAT:    BATch (RDR=in, LST=out)
                        ;  UC1:    User defined Console
                        ;  LPT:    Line PrinTer                (CBM printer)
                        ;  UL1:    User-def. List            (ASCII printer)
                        ;  PTR:    Paper Tape Reader          (Other device)
                        ;  UR1:    User-def. Reader 1
                        ;  UR2:    User-def. Reader 2
                        ;  PTP:    Paper Tape Punch           (Other device)
                        ;  UP1:    User-def. Punch 1
                        ;  UP2:    User-def. Punch 2

cdisk:    equ  0004h    ;Current drive and user number
                        ;  Bits 7-4: Current user number
                        ;  Bits 3-0: Current drive number (0=A,1=B,etc.)

jp_sysc:  equ  0005h    ;Jump to BDOS system call (3 byte instruction)
track:    equ  0041h    ;Track number
sector:   equ  0043h    ;Sector number
drive:    equ  0044h    ;Drive number (0=A, 1=B, 2=C, etc.)
dos_err:  equ  004fh    ;Last error code returned from CBM DOS
dma:      equ  0052h    ;DMA buffer area address
move_cnt: equ  005ah    ;Counts down bytes to consume in a cursor move seq
dma_buf:  equ  0080h    ;Default DMA buffer area (128 bytes) for disk I/O
ccp_base: equ 0d400h    ;Start of CCP area
dirsize:  equ 0d8b2h    ;CCP directory width: 0=1 col, 1=2 cols, 3=4 cols
syscall:  equ 0dc06h    ;BDOS system call
b_warm:   equ 0ea03h    ;BDOS warm boot
dirsave:  equ 0ea40h    ;Saves the original value of DIRSIZE after boot
jiffies:  equ 0ea41h    ;CBM clock data: Jiffies (counts up to 50 or 60)
secs:     equ 0ea42h    ;CBM clock data: Seconds
mins:     equ 0ea43h    ;CBM clock data: Minutes
hours:    equ 0ea44h    ;CBM clock data: Hours
jiffy2:   equ 0ea45h    ;CBM clock data: Jiffy counter (MSB)
jiffy1:   equ 0ea46h    ;CBM clock data: Jiffy counter
jiffy0:   equ 0ea47h    ;CBM clock data: Jiffy counter (LSB)
iosetup:  equ 0ea60h    ;Byte that is written to IOBYTE
lpt_dev:  equ 0ea61h    ;CBM printer (LPT:) IEEE-488 primary address
ptr_dev:  equ 0ea62h    ;Paper Tape Reader (PTR:) IEEE-488 primary address
ptp_dev:  equ 0ea63h    ;Paper Tape Punch (PTP:) IEEE-488 primary address
ser_mode: equ 0ea64h    ;Byte that is written to 8251 USART mode register
ser_baud: equ 0ea65h    ;Byte that is written to COM8116 baud rate generator
ul1_dev:  equ 0ea66h    ;ASCII printer (UL1:) IEEE-488 primary address
termtype: equ 0ea67h    ;Terminal type:
                        ;  0=ADM3A, 1=HZ1500, 2=TV912
                        ;  Bit 7 is set if uppercase graphics mode
leadin:   equ 0ea68h    ;Terminal command lead-in: 1bh=escape, 7eh=tilde
xy_order: equ 0ea69h    ;X,Y order when sending move-to: 0=X first, 1=Y first
y_offset: equ 0ea6ah    ;Offset added to Y when sending move-to sequence
x_offset: equ 0ea6bh    ;Offset added to X when sending move-to sequence
lptype:   equ 0ea6dh    ;CBM printer (LPT:) type: 0=3022, 3032, 4022, 4023
                        ;                         1=8026, 8027 (daisywheel)
                        ;                         2=8024

dtypes:   equ 0ea70h    ;Disk drive types:
dtype_ab: equ dtypes+0  ;  A:, B:    00h = CBM 3040/4040
dtype_cd: equ dtypes+1  ;  C:, D:    01h = CBM 8050
dtype_ef: equ dtypes+2  ;  E:, F:    02h = Corvus 10MB
dtype_gh: equ dtypes+3  ;  G:, H:    03h = Corvus 20MB
dtype_ij: equ dtypes+4  ;  I:, J:    04h = Corvus 5MB
dtype_kl: equ dtypes+5  ;  L:, K:    05h = Corvus 5MB*
dtype_mn: equ dtypes+6  ;  M:, N:    06h = CBM 8250
dtype_op: equ dtypes+7  ;  O:, P:    07h = Undefined
                        ;           0ffh = No device

ddevs:    equ 0ea78h    ;Disk drive device addresses:
ddev_ab:  equ ddevs+0   ;  A:, B:
ddev_cd:  equ ddevs+1   ;  C:, D:    For CBM floppy drives, the number
ddev_ef:  equ ddevs+2   ;  E:, F:    is an IEEE-488 device primary address.
ddev_gh:  equ ddevs+3   ;  G:, H:
ddev_ij:  equ ddevs+4   ;  I:, J:    For Corvus hard drives, the number
ddev_kl:  equ ddevs+5   ;  L:, K:    is an ID on a Corvus unit.
ddev_mn:  equ ddevs+6   ;  M:, N:
ddev_op:  equ ddevs+7   ;  O:, P:

scrtab:   equ 0ea80h    ;64 byte buffer for tab stops
dos_msg:  equ 0eac0h    ;Last error message returned from CBM DOS

    org 0f000h

lf000h:
    jp boot          ;f000  Cold start
    jp wboot         ;f003  Warm start
    jp const         ;f006  Console status
    jp conin         ;f009  Console input
    jp conout        ;f00c  Console output
    jp list          ;f00f  List (printer) output
    jp punch         ;f012  Punch (paper tape) output
    jp reader        ;f015  Reader (paper tape) input
    jp home          ;f018  Move to track 0 on selected disk
    jp seldsk        ;f01b  Select disk drive
    jp settrk        ;f01e  Set track number
    jp setsec        ;f021  Set sector number
    jp setdma        ;f024  Set DMA address
    jp read          ;f027  Read selected sector
    jp write         ;f02a  Write selected sector
    jp listst        ;f02d  List (printer) status
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
    ld sp,0100h
    xor a
    call sub_f245h
    jr c,lf0e6h
    xor a
    call e_faadh
    ld c,16h
    call sub_f651h
    jr lf0ebh
lf0e6h:
    ld b,2ch
    call sub_f0fch
lf0ebh:
    ld a,(dirsave)      ;Get original CCP directory width
    ld (dirsize),a      ;Restore it

    ld hl,ccp_base+3
    jr z,init_and_jp_hl
    xor a
    call e_fac4h
    jr wboot
sub_f0fch:
    ld hl,ccp_base
    ld c,00h
    push hl
    push bc
    ld hl,0000h
    ld (track),hl
    xor a
    ld (sector),a
    ld (0048h),a
    ld (0051h),a
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
    ld hl,0043h
    inc (hl)
    pop bc
    pop hl
    or a
    ret nz
    ld de,dma_buf
    add hl,de
    djnz lf11dh
    ret

init_and_jp_hl:
;Initialize low memory locations as required by CP/M and
;then jump to the address in HL.
;
    push hl             ;Save address
    ld bc,dma_buf
    call setdma         ;Initialize DMA pointer

    ld a,0c3h           ;0c3h = JP
    ld (jp_warm),a
    ld hl,b_warm        ;Install BDOS warm boot jump
    ld (jp_warm+1),hl   ;  0000h JP 0ea03h

    ld (jp_sysc),a
    ld hl,syscall       ;Install BDOS system call jump
    ld (jp_sysc+1),hl   ;  0005h JP 0dc06h

    ld hl,cdisk
    ld a,(hl)           ;A = current user and disk
    and 0fh             ;Mask off user nybble leaving A = current disk
    call e_f224h

    jr c,lf15ch
    ld (hl),00h
lf15ch:
    ld c,(hl)
    xor a               ;A=0
    ld (0048h),a
    ld (0051h),a
    dec a               ;A=0ffh
    ld (drive),a
    pop hl              ;Recall address
    jp (hl)             ;  and jump to it

home:
;Set the CP/M track to 0.
;
    ld bc,0000h         ;Fall through into settrk

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
;
;Called with E=0 or 0FFFFh:
;  If bit 0 of E is 0, the disk will be logged in as new.
;  If bit 0 of E is 1, the disk has already been logged in.
;
;Returns the address of a Disk Parameter Header in HL.  If the
;disk could not be selected, HL = 0.
;
    ld a,c
    call e_f224h
    ld hl,0000h         ;HL = error code
    ret nc              ;Return if drive is invalid

    ld (0040h),a
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,0eb00h
    add hl,de
    push hl
    ld l,c
    ld h,00h
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,seldsk_table
    add hl,bc
    ex de,hl
    pop hl
    push hl
    ld bc,000ah
    add hl,bc
    ld (hl),e
    inc hl
    ld (hl),d
    ld a,(0040h)
    call sub_f245h
    call c,sub_f2ffh
    pop hl
    ret

seldsk_table:
    db 20h, 00h, 04h, 0fh, 01h, 4ch,  00h, 3fh
    db 00h, 80h, 00h, 10h, 00h, 00h,  00h, 00h
    db 20h, 00h, 04h, 0fh, 01h, 0f8h, 00h, 3fh
    db 00h, 80h, 00h, 10h, 00h, 00h,  00h, 00h
    db 40h, 00h, 06h, 3fh, 03h, 4ch,  02h, 0ffh
    db 00h, 80h, 00h, 00h, 00h, 02h,  00h, 00h
    db 40h, 00h, 06h, 3fh, 03h, 4ch,  02h, 0ffh
    db 00h, 80h, 00h, 00h, 00h, 02h,  00h, 00h
    db 40h, 00h, 06h, 3fh, 03h, 0b8h, 02h, 0ffh
    db 00h, 80h, 00h, 00h, 00h, 02h,  00h, 00h
    db 40h, 00h, 06h, 3fh, 03h, 59h,  01h, 0ffh
    db 00h, 80h, 00h, 00h, 00h, 02h,  00h, 00h
    db 20h, 00h, 05h, 1fh, 03h, 0fch, 00h, 07fh
    db 00h, 80h, 00h, 20h, 00h, 00h,  00h, 00h

sectran:
    ld l,c
    ld h,b
    ret

e_f224h:
    cp 10h              ;Valid drives are 0 (A:) through 00fh (P:)
    ret nc              ;Return if drive is greater than P:
    push hl
    push af
    or a
    rra
    ld c,a
    ld b,00h
    ld hl,dtypes
    add hl,bc           ;HL = pointer to drive in dtypes table
    ld c,(hl)           ;C = drive type
    ld a,c              ;A = C
    cp 04h
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
    cp 06h
    ret nc
    cp 02h
    ccf
    ret

read:
    ld a,(0040h)
    call sub_f245h
    jp c,lf315h
    call sub_f6b9h
    ld a,01h
    call nz,sub_f2d8h
    ld a,(sector)
    rrca
    call sub_f2e5h
    xor a
    ld (0048h),a
    ret

write:
    push bc
    ld a,(0040h)
    call sub_f245h
    pop bc
    jp c,lf342h
    ld a,c
    push af
    cp 02h
    call z,lf691h
    ld hl,0048h
    ld a,(hl)
    or a
    jr z,lf2b1h
    dec (hl)
    ld a,(0040h)
    ld hl,0049h
    cp (hl)
    jr nz,lf2b1h
    ld a,(track)
    ld hl,004ah
    cp (hl)
    jr nz,lf2b1h
    ld a,(0042h)
    inc hl
    cp (hl)
    jr nz,lf2b1h
    ld a,(sector)
    ld hl,004ch
    cp (hl)
    jr nz,lf2b1h
    inc (hl)
    call sub_f6b9h
    jr lf2bdh
lf2b1h:
    xor a
    ld (0048h),a
    call sub_f6b9h
    ld a,00h
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
    ld a,01h
    ld (0051h),a
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
    ld a,00h
    jr lf2ebh
sub_f2e9h:
    ld a,01h
lf2ebh:
    ld hl,0ef00h
    ld de,(dma)
    ld bc,dma_buf
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
    and 20h
    jr nz,sub_f2ffh
    call sub_f38fh
    cp 8fh
    jr nz,sub_f2ffh
    ret
lf315h:
    call sub_f3a5h
    push af
    ld a,12h
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
    ld b,80h
lf334h:
    in a,(ppi2_pc)
    and 10h             ;Mask off all but bit 4 (Corvus READY)
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
    ld a,13h
    call sub_f39ah
    pop af
    call sub_f39ah
    ld a,l
    call sub_f39ah
    ld a,h
    call sub_f39ah
    ld b,80h
    ld hl,(dma)
lf35ch:
    in a,(ppi2_pc)
    and 10h             ;Mask off all but bit 4 (Corvus READY)
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
    xor 10h
    and 30h
    jr nz,sub_f37bh
    ld b,19h
lf385h:
    djnz lf385h
    in a,(ppi2_pc)
    xor 10h
    and 30h
    jr nz,sub_f37bh
sub_f38fh:
    in a,(ppi2_pc)
    and 10h             ;Mask off all but bit 4 (Corvus READY)
    jr z,sub_f38fh      ;Wait until Corvus READY=high
    in a,(corvus)
    bit 7,a
    ret
sub_f39ah:
    push af
lf39bh:
    in a,(ppi2_pc)
    and 10h
    jr z,lf39bh
    pop af
    out (corvus),a
    ret
sub_f3a5h:
    ld hl,(track)
    ld a,00h
    ld b,06h
lf3ach:
    add hl,hl
    rla
    djnz lf3ach
    push af
    ld a,(sector)
    or l
    ld l,a
    ld de,941ch
    ld a,(0040h)
    call e_f224h
    ld a,c
    cp 05h
    jr nz,lf3c7h
    ld de,577ah
lf3c7h:
    ld a,(0040h)
    and 01h
    jr nz,lf3d1h
    ld de,005ch
lf3d1h:
    pop af
    add hl,de
    adc a,00h
    add a,a
    add a,a
    add a,a
    add a,a
    push hl
    push af
    ld a,(0040h)
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
    and 0fh
    cp 0ah
    jr c,lf413h
    add a,07h
lf413h:
    add a,30h
    ld c,a
    jp conout

boot:
    ld sp,0100h         ;Initialize stack pointer
    ld a,99h
    out (ppi1_cr),a
    ld a,98h
    out (ppi2_cr),a
    xor a               ;A=0
    out (ppi1_pb),a     ;Clear IEEE data out
    out (ppi2_pb),a     ;Clear IEEE control out

    ld c,02h
    ld hl,0000h         ;RAM start address
    ld de,lf000h        ;RAM end address + 1
lf431h:
    ld (hl),l
    inc hl
    ld a,h
    and 0fh
    or l
    jr nz,lf43fh

    in a,(ppi2_pc)
    xor 04h
    out (ppi2_pc),a     ;Invert "Ready" LED

lf43fh:
    dec de
    ld a,e
    or d
    jr nz,lf431h

    ld hl,0000h         ;RAM start address
    ld de,lf000h        ;RAM end address + 1
lf44ah:
    ld a,(hl)
    cp l
    jr nz,help_me
    cpl
    ld (hl),a
    inc hl
    ld a,h
    and 0fh
    or l
    jr nz,lf45dh

    in a,(ppi2_pc)
    xor 04h
    out (ppi2_pc),a     ;Invert "Ready" LED
lf45dh:
    dec de
    ld a,e
    or d
    jr nz,lf44ah

    ld hl,0000h         ;RAM start address
    ld de,lf000h        ;RAM end address + 1
lf468h:
    ld a,(hl)
    cpl
    cp l
    jr nz,help_me
    inc hl
    ld a,h
    and 0fh
    or l
    jr nz,lf47ah

    in a,(ppi2_pc)
    xor 04h
    out (ppi2_pc),a     ;Invert "Ready" LED
lf47ah:
    dec de
    ld a,e
    or d
    jr nz,lf468h

    ld hl,lf000h        ;ROM start address
    ld bc,0ffdh         ;Number of code bytes in the ROM
    call calc_checksum  ;Calculate ROM checksum

    ld c,03h
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

    ld a,04h
    out (ppi2_pc),a     ;Turn on "Ready" LED

    ld de,lffffh
lf4a4h:
    dec de
    ld a,e
    or d
    jr nz,lf4a4h        ;Delay loop

    djnz lf492h

    ld b,03h
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
    or 80h              ;Turn on bit 7 (IFC out)
    out (ppi2_pb),a     ;IFC=?

    xor a               ;A=0
    ld (iobyte),a       ;IOBYTE=0 (CON:=TTY:, the RS-232 port)
    ld (cdisk),a        ;CDISK=0 (User=0, Drive=A:)
    ld (0054h),a
    ld (0059h),a
    ld (move_cnt),a
    ld (scrtab),a
    out (ppi2_pc),a     ;Turn on LEDs

    ld bc,03e8h
    call e_fb86h

    ld a,1bh
    ld (leadin),a       ;Terminal lead-in = 01bh (escape)

    xor a               ;8251 USART initialization sequence
    out (usart_st),a
    nop
    out (usart_st),a
    nop
    out (usart_st),a

    ld a,40h            ;Reset
    out (usart_st),a

    ld a,7ah            ;Set mode
                        ;  Bit 7: S2   0 = 1 stop bit
                        ;  Bit 6: S1   1
                        ;  Bit 5: EP   1 = Even parity
                        ;  Bit 4: PEN  1
                        ;  Bit 3: L2   1 = 7 bit character
                        ;  Bit 2: L1   0
                        ;  Bit 1: B2   1 = 16X baud rate factor
                        ;  Bit 0: B1   0
    out (usart_st),a

    ld a,37h            ;Set command
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
                        ;  0ffh = 19200 baud
                        ;  0eeh =  9600 baud
                        ;  0cch =  4800 buad
                        ;  0aah =  2400 baud
                        ;  077h =  1200 baud
                        ;  055h =   300 baud
                        ;  022h =   110 baud
    out (baud_gen),a    ;Set baud rate to 9600 baud

    in a,(ppi2_pa)      ;IEEE-488 control lines in
    cpl                 ;Invert byte
    and 40h             ;Mask off all but bit 6 (REN in)
    jr nz,lf52bh

    ld a,01h
    ld (iobyte),a      ;IOBYTE=1 (CON:=CRT:, the CBM computer)

wait_for_atn:
;Wait until the CBM computer addresses the SoftBox.  The SoftBox
;must stay off the bus until a program on the CBM side wakes it up
;by sending attention to its address (57).  At that point, the CBM
;must start waiting for SRQs and the SoftBox can take over the bus.
;
    in a,(ppi2_pa)      ;Read IEEE-488 control lines
    cpl                 ;Invert byte
    and 03h             ;Mask off all but bit 1 (ATN), bit 2 (DAV)
    in a,(ppi1_pa)      ;Read IEEE-488 data byte
    jr nz,wait_for_atn  ;Wait until ATN=? and DAV=?
    cp 39h
    jr nz,wait_for_atn  ;Wait until data byte = 57 (SoftBox address)

    in a,(ppi2_pa)      ;Read IEEE-488 control lines
    cpl                 ;Invert byte
    and 02h             ;Mask off all but bit 1 (DAV in)
    jr nz,wait_for_atn  ;Loop until DAV=?

lf524h:
    in a,(ppi2_pa)      ;Read IEEE-488 control lines
    cpl                 ;Invert byte
    and 02h             ;Mask off all but bit 1 (DAV in)
    jr z,lf524h         ;Wait until DAV=?

lf52bh:
    ld hl,loading
    call puts           ;Write "Loading CP/M ..."
    ld de,080fh
    call e_fb31h
    ld bc,0007h
    call e_fb86h

    in a,(ppi2_pa)      ;Read IEEE-488 control lines
    cpl                 ;Invert byte
    and 04h             ;Mask off all but bit 3 (NDAC)
    jr z,lf555h         ;Wait for NDAC=?

    ld a,02h
    ld (dtypes),a
    ld a,01h
    ld (ddevs),a
    ld b,38h
    call sub_f0fch
    jr e_f578h
lf555h:
    call e_fb47h
    ld de,080fh
    ld c,02h            ;2 bytes in string
    ld hl,dos_i0_0      ;"I0"
    call e_fb56h
    ld d,08h
    ld c,1ch
    call sub_f651h
    jp nz,lf52bh
    ld de,0802h
    ld c,02h            ;2 bytes in string
    ld hl,dos_num2      ;"#2"
    call e_fb56h
e_f578h:
    ld sp,0100h
    xor a
    push af
    ld ix,0eb00h
    ld hl,0ec00h
    ld de,dtypes
lf587h:
    ld a,(de)
    or a
    jp m,lf5d5h
    cp 02h
    ld bc,004ah
    jr z,lf5beh
    cp 03h
    jr z,lf5beh
    cp 04h
    ld bc,0058h
    jr z,lf5beh
    push af
    ld a,10h
    ld (0058h),a
    pop af
    cp 06h
    jp nz,lf5afh
    ld a,20h
    ld (0058h),a
lf5afh:
    ld (ix+00ch),l
    ld (ix+00dh),h
    ld a,(0058h)
    ld b,00h
    ld c,a
    add hl,bc
    rla
    ld c,a
lf5beh:
    ld (ix+00eh),l
    ld (ix+00fh),h
    add hl,bc
    ld (ix+08h),80h
    ld (ix+09h),0eeh
    ld (ix+00h),00h
    ld (ix+01h),00h
lf5d5h:
    ld bc,0010h
    add ix,bc
    pop af
    inc a
    push af
    or a
    rra
    jr c,lf587h
    inc de
    cp 08h
    jr nz,lf587h
    pop af

    ld a,(dirsize)      ;Get CCP directory width
    ld (dirsave),a      ;Save it

    ld a,(iobyte)       ;Get current IOBYTE
    and 01h             ;Mask off all but bit 0 (low bit of CON:)
    ld b,a              ;Save current CON: assignment (TTY: or CRT:) in B

    ld a,(iosetup)      ;Get user defaults for IOBYTE
    and 0fch            ;Clear CON: bits
    or b                ;Merge current CON: assignment with defaults
    ld (iobyte),a       ;Update IOBYTE with defaults

    xor a               ;8251 USART initialization sequence
    out (usart_st),a
    nop
    out (usart_st),a
    nop
    out (usart_st),a

    ld a,40h            ;Reset
    out (usart_st),a

    ld a,(ser_mode)
    out (usart_st),a    ;Set mode

    ld a,37h            ;Set command
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

    call cbm_clear      ;Clear CBM screen (no-op if console is RS-232)

    ld a,(iobyte)
    rra
    jr nc,lf62bh        ;Jump if console is CBM Computer (CON: = CRT:)

    ld a,(termtype)     ;Get terminal type
    rla                 ;Rotate uppercase graphics flag into carry
    jr nc,lf62bh        ;Jump if lowercase mode

    ld c,15h            ;015h = Go to uppercase mode
    call conout

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
    ld hl,filename      ;"0:CP/M"
    ld c,06h            ;6 characters
    ld e,00h
    call e_fb56h
    pop de
    push de
    call sub_f9bfh
    pop de
    ld e,00h
    pop bc
    or a
    ret nz
    push de
    call e_faf9h
    ld hl,ccp_base
    ld b,00h
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

dos_num2:
    db "#2"

filename:
    db "0:CP/M"

dos_i0_0:
    db "I0"

lf691h:
    push bc
    call sub_f245h
    pop bc
    or a
    cp 06h
    jp z,lf6a1h
    ld a,10h
    jp lf6a3h
lf6a1h:
    ld a,20h
lf6a3h:
    ld (0048h),a
    ld a,(0040h)
    ld (0049h),a
    ld hl,(track)
    ld (004ah),hl
    ld a,(sector)
    ld (004ch),a
    ret
sub_f6b9h:
    ld a,(0040h)
    ld hl,0044h
    xor (hl)
    ld b,a
    ld a,(track)
    ld hl,0045h
    xor (hl)
    or b
    ld b,a
    ld a,(0042h)
    inc hl
    xor (hl)
    or b
    ld b,a
    ld a,(sector)
    rra
    ld hl,0047h
    xor (hl)
    or b
    ret z
    ld hl,0051h
    ld a,(hl)
    ld (hl),00h
    or a
    call nz,sub_f2dfh
    ld a,(0040h)
    ld (drive),a
    ld hl,(track)
    ld (0045h),hl
    ld a,(sector)
    or a
    rra
    ld (0047h),a
    or 0ffh
    ret
lf6fch:
    ld (0055h),hl
    call sub_f8dah
lf702h:
    ld a,03h
    ld (0050h),a
lf707h:
    ld a,(drive)
    call e_fabch
    ld hl,(0055h)
    ld c,05h
    call e_ff1fh
    ld a,(drive)
    and 01h
    add a,30h
    call e_fe62h
    ld a,(004dh)
    call e_f9a3h
    ld a,(004eh)
    call e_f9a3h
    call e_ff09h
    call e_fb47h
    ld a,(drive)
    call e_f9bch
    cp 16h
    jr nz,lf73fh
    ex af,af'
    or a
    ret z
    ex af,af'
lf73fh:
    ld (dos_err),a      ;A=last error code returned from CBM DOS
    or a                ;Set flags
    ret z               ;Return if error code = 0 (OK)

    ld hl,0050h
    dec (hl)
    jr z,lf752h
    ld a,(drive)
    call e_fac4h
    jr lf707h
lf752h:
    ld hl,bdos_err_on
    call puts           ;Write "BDOS err on " to console out

    ld a,(drive)        ;Get current drive number
    add a,41h           ;Convert it to ASCII (0=A, 1=B, 2=C, etc)
    ld c,a
    call conout         ;Write drive letter to console out

    ld hl,colon_space
    call puts           ;Write ": " to console out

    ld hl,cbm_dos_errs  ;HL = pointer to CBM DOS error table
    call puts_dos_error ;Display an error message
lf76dh:
    call conin          ;Wait for a key to be pressed

    cp 03h              ;Control-C pressed?
    jp z,jp_warm        ;  Yes: Jump to BDOS warm start

    cp 3fh              ;Question mark ("?") pressed?
    jr nz,lf790h        ;  No: Jump over printing CBM DOS error msg

    ld hl,newline
    call puts           ;Write a newline to console out

    ld hl,dos_msg       ;HL = pointer to CBM DOS error message
                        ;     like "23,READ ERROR,45,27,0",0d
lf782h:
    ld a,(hl)           ;Get a char from CBM DOS error message
    cp 0dh
    jr z,lf76dh         ;Jump if end of CBM DOS error message reached

    ld c,a
    push hl
    call conout         ;Write char from CBM DOS error msg to console out
    pop hl
    inc hl              ;Increment to next char
    jr lf782h           ;Loop to continue printing the error msg

lf790h:
    ld a,(drive)
    call e_fac4h
    ld a,(dos_err)
    cp 1ah              ;Error = Write protect on?
    jp z,lf702h
    cp 15h              ;Error = Drive not ready?
    jp z,lf702h
    ld a,00h
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
    db "U1 2 "

lf8d2h:
    db "U2 2 "

newline:
    db 0dh,0ah,00h

sub_f8dah:
    ld a,(drive)
    call e_f224h
    ld a,c
    or a
    ld ix,0057h
    ld hl,lf957h
    ld e,10h
    jr z,lf8f9h
    ld e,25h
    ld hl,lf96bh
    cp 01h
    jr z,lf8f9h
    ld hl,lf97fh
lf8f9h:
    push de
    push hl
    ld (ix+00h),00h
    ld hl,(0045h)
    ld h,00h
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,(0047h)
    ld d,00h
    add hl,de
    ld b,h
    ld c,l
    pop hl
lf912h:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    scf
    sbc hl,bc
    ex de,hl
    jp nc,lf923h
    inc hl
    inc hl
    inc hl
    jp lf912h
lf923h:
    dec hl
    dec hl
    ld a,(hl)
    ld (ix+00h),a
    dec hl
    ld a,(hl)
    dec hl
    dec hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld h,b
    ld l,c
    or a
    sbc hl,de
    ld b,00h
    ld c,a
lf938h:
    ld a,l
    or a
    sbc hl,bc
    jp c,lf945h
    inc (ix+00h)
    jp lf938h
lf945h:
    ld (004eh),a
    ld a,(ix+00h)
    ld (004dh),a
    pop de
    cp e
    ret c
    add a,03h
    ld (004dh),a
    ret
lf957h:
    nop
    nop
    dec d
    ld bc,013bh
    inc de
    djnz $-81
    ld bc,1612h
    add hl,de
    ld (bc),a
    ld de,0f1ch
    daa
    nop
    nop
lf96bh:
    nop
    nop
    dec e
    ld bc,0414h
    dec de
    dec h
    adc a,(hl)
    dec b
    add hl,de
    inc sp
    and c
    ld b,17h
    ld a,0fh
    daa
    nop
    nop
lf97fh:
    nop
    nop
    dec e
    ld bc,0414h
    dec de
    dec h
    adc a,(hl)
    dec b
    add hl,de
    inc sp
    and c
    ld b,17h
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
    call nz,170eh
    adc a,e
    rrca
    daa
    nop
    nop
e_f9a3h:
    push af
    ld a,20h
    call e_fe62h
    pop af
    ld e,2fh
lf9ach:
    sub 0ah
    inc e
    jr nc,lf9ach
    add a,3ah
    push af
    ld a,e
    call e_fe62h
    pop af
    jp e_fe62h
e_f9bch:
    call e_faadh
sub_f9bfh:
    ld e,0fh
    call e_faf9h
    ld hl,dos_msg
lf9c7h:
    call cbm_get_byte
    ld (hl),a
    sub 30h
    jr c,lf9c7h
    cp 0ah
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
    sub 30h
    add a,b
    push af
    ld c,3ch
lf9e5h:
    call cbm_get_byte
    dec c
    jp m,lf9eeh
    ld (hl),a
    inc hl
lf9eeh:
    cp 0dh
    jr nz,lf9e5h
    call e_fb21h
    pop af
    ret
lf9f7h:
    push hl
    ld hl,dos_mw        ;"M-W",00h,13h,01h
    ld c,06h            ;6 bytes in string
    ld a,(drive)        ;A = CP/M drive number
    call e_fabch        ;? write to device ?
    call e_ff1fh
    pop hl

    ld a,(hl)
    push hl
    call e_ff0bh
    call e_fb47h

    ld hl,dos_bp        ;"B-P 2 1"
    ld c,07h            ;7 bytes in string
    ld a,(drive)
    call e_fabch
    call e_ff1fh

    call e_ff09h
    call e_fb47h
    ld a,(drive)
    call e_faadh
    ld e,02h
    call e_fb31h
    pop hl

    inc hl
    ld c,0ffh
    call e_ff1fh
    call e_fb47h
    ld hl,lf8d2h
    jp lf6fch
lfa3eh:
    push hl
    ld hl,lf8cdh
    call lf6fch

    ld hl,dos_mr        ;"M-R",00h,13h
    ld c,05h            ;5 bytes in string
    ld a,(drive)
    call e_fabch
    call e_ff1fh

    call e_ff09h
    call e_fb47h
    ld a,(drive)
    call e_faadh
    ld e,0fh
    call e_faf9h
    call cbm_get_byte
    pop hl
    ld (hl),a
    push hl
    call e_fb21h
    ld a,(drive)
    call e_fabch

    ld hl,dos_bp        ;"B-P 2 1"
    ld c,07h            ;7 bytes in string
    call e_ff1fh

    call e_ff09h
    call e_fb47h
    ld a,(drive)
    call e_f9bch
    cp 46h
    jr z,lfaa4h
    ld a,(drive)
    call e_faadh
    ld e,02h
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
    ld d,00h
    ld hl,ddevs
    add hl,de
    ld d,(hl)
    pop af
    pop hl
    ret
e_fabch:
    call e_faadh
    ld e,0fh
    jp e_fb31h
e_fac4h:
    call e_faadh
    ld e,0fh
    push de

    ld c,02h            ;2 bytes in string
    ld hl,dos_i0        ;"I0"
    rra
    jr nc,lfad5h
    ld hl,dos_i1        ;"I1"

lfad5h:
    call e_fb56h
    pop de
    ld e,02h
    ld c,02h            ;2 bytes in string
    ld hl,dos_num2      ;"#2"
    jp e_fb56h

dos_i0:
    db "I0"

dos_i1:
    db "I1"

dos_bp:
    db "B-P 2 1"

dos_mw:
    db "M-W",00h,13h,01h

dos_mr:
    db "M-R",00h,13h

e_faf9h:
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a
    ld a,40h
    or d
    call e_fe62h
    jr c,lfb13h
    ld a,e
    or 60h
    call p,e_fe62h
    in a,(ppi2_pb)
    or 0ch
    out (ppi2_pb),a
lfb13h:
    push af
    in a,(ppi2_pb)
    and 0feh
    out (ppi2_pb),a
    ld a,19h
lfb1ch:
    dec a
    jr nz,lfb1ch
    pop af
    ret
e_fb21h:
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a
    in a,(ppi2_pb)
    and 0f3h
    out (ppi2_pb),a
    ld a,5fh
    jr e_fb49h
e_fb31h:
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a
    ld a,20h
    or d
    call e_fe62h
    jr c,lfb13h
    ld a,e
    or 60h
    call p,e_fe62h
    jr lfb13h
e_fb47h:
    ld a,3fh
e_fb49h:
    push af
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a
    pop af
    call e_fe62h
    jr lfb13h
e_fb56h:
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a
    ld a,d
    or 20h
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
    or 01h
    out (ppi2_pb),a
    ld a,d
    or 20h
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
    add a,00h
    djnz lfb92h
    pop bc
    ret

conin:
;Console input
;Blocks until a key is available, then returns the key in A.
;
    ld a,(iobyte)
    rra
    jp nc,ser_in        ;Jump out if console is RS-232 port (CON: = TTY:)

    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    or 04h              ;Turn on bit 2 (NDAC)
    out (ppi2_pb),a     ;NDAC=?

    ld a,02h            ;Command 02h = Wait for a key and send it
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
    ld a,(iobyte)
    rra
    jp nc,ser_rx_status ;Jump out if console is RS-232 port (CON: = TTY:)

    ld a,01h            ;Command 01h = Key available?
    call cbm_srq
    ld a,00h
    ret nc              ;Return with A=0 if no key
    ld a,0ffh
    ret                 ;Return with A=0ffh if a key is available

conout:
;Console output.
;C = character to write to the screen
;
    ld a,(iobyte)
    rra
    jp nc,ser_out       ;Jump out if console is RS-232 port (CON: = TTY:)

    ld a,(move_cnt)
    or a
    jp nz,lfc1dh        ;Jump if already in a move-to sequence

    ld a,c
    rla
    jr c,conout_cbm     ;Jump if bit 7 of C is set

    ld a,(leadin)
    cp c
    jr nz,lfbe6h        ;Jump if the character is not the lead-in

    ld a,01h
    ld (0059h),a        ;Set 0059h = 1 if character is the lead-in
    ret                 ;  and return

lfbe6h:
    ld a,(0059h)
    or a
    jp z,lfbf3h         ;Jump if 0059h = 0

    xor a               ;A = 0
    ld (0059h),a        ;Set 0059h = 0

    set 7,c
lfbf3h:
    ld a,c              ;A = C
    cp 20h
    jr c,lfbfch

    cp 7bh
    jr c,conout_cbm

lfbfch:
    ld hl,scrtab        ;HL = scrtab
lfbffh:
    ld a,(hl)
    inc hl
    or a
    jr z,conout_cbm
    cp c
    ld a,(hl)
    inc hl
    jr nz,lfbffh

    cp 1bh
    jr z,lfc17h
    ld c,a

conout_cbm:
;Put the character in C on the CBM screen
;
    ld a,04h            ;Command 04h = Write to the terminal screen
    call cbm_srq
    ld a,c              ;A=C
    jp cbm_send_byte    ;Jump out to send byte in A

lfc17h:
    ld a,02h
    ld (move_cnt),a
    ret

lfc1dh:
    dec a               ;A = A - 1
    ld (move_cnt),a     ;Store A in 005ah
    jr z,lfc28h         ;Jump if no more bytes to consume

    ld a,c
    ld (005bh),a        ;Remember C in 005bh
    ret

lfc28h:
;No more bytes to consume
;C contains one position (X or Y)
;
    ld a,(005bh)        ;A = contains other position (X or Y)
    ld d,a              ;D = A
    ld e,c              ;E = C

    ld a,(xy_order)     ;xy_order: 0=Y first, 1=X first
    or a
    jr z,lfc36h         ;Jump if positions don't need to be swapped

    ld a,e
    ld e,d
    ld d,a              ;Swap D and E

lfc36h:
;Send move-to sequence
;
    ld a,(iobyte)
    and 03h             ;Mask off all but bits 1 and 0
    cp 01h              ;Compare to 1 (CON: = CRT:)
    ret nz              ;Return if console is not CBM computer (CRT:)

    push de
    ld c,1bh            ;1bh = LSI ADM-3A command to start move-to sequence
    call conout_cbm     ;Send start of move-to
    pop de

    push de
    ld a,e
    ld hl,x_offset
    sub (hl)
    cp 60h
    jr c,lfc51h
    sub 60h
lfc51h:
    add a,20h
    ld c,a
    call conout_cbm     ;Send X-position byte for move-to

    pop af
    ld hl,y_offset
    sub (hl)
    and 1fh
    or 20h
    ld c,a
    jp conout_cbm       ;Send Y-position byte for move-to

ser_rx_status:
;RS-232 serial port receive status
;Returns A=0 if no byte is ready, A=0FFh if one is.
;
    in a,(usart_st)     ;Read USART status register
    and 02h             ;Mask off all but RxRDY bit
    ret z               ;Return A=0 if no byte
    or 0ffh
    ret                 ;Return A=FF if a byte is ready

ser_out:
;RS-232 serial port output
;C = byte to write to the port
;
    in a,(usart_st)     ;Read USART status register
    cpl                 ;Invert it
    and 84h             ;Mask off all but bits 7 (DSR) and 2 (TxEMPTY)
    jr nz,ser_out       ;Wait until DSR=1 and TxEMPTY=1

    ld a,c
    out (usart_db),a    ;Write data byte
    ret

ser_in:
;RS-232 serial port input
;Blocks until a byte is available, then returns it in A.
;
    in a,(usart_st)     ;Read USART status register
    and 02h             ;Mask off all but bit 1 (RxRDY)
    jr z,ser_in         ;Wait until a byte is available

    in a,(usart_db)     ;Read data byte
    ret

cbm_srq:
;Send a Service Request (SRQ) to the CBM computer.
;
;A = command to send, one of:
;  20h = Transfer bytes from the SoftBox to CBM memory
;  10h = Transfer bytes from CBM memory to the SoftBox
;  08h = Jump to a subroutine in CBM memory
;  04h = Write to the terminal screen
;  02h = Wait for a key and send it
;  01h = Key available?
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
    or 20h
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

    ld a,00h
    out (ppi1_pb),a     ;Release IEEE data lines

lfca1h:
    in a,(ppi1_pa)      ;A = Read IEEE data byte
    or a                ;Set flags
    jr nz,lfca1h        ;Wait for IEEE data bus to go to zero

    pop af
    ret

list:
;List (printer) output.
;C = character to write to the printer
;
    ld a,(iobyte)
    and 0c0h            ;Mask off all but buts 6 and 7
    jp z,ser_out        ;Jump out if List is RS-232 port (LST: = TTY:)
    jp p,conout_cbm     ;Jump out if List is CBM computer (LST: = CRT:)

    ld e,0ffh
    and 40h             ;Mask off all but bit 6
    jr z,lfcc3h         ;Jump if List is CBM printer (LST: = LPT:)

                        ;List must be ASCII printer (LST: = UL1:)
    ld a,(ul1_dev)
    ld d,a
    call e_fb31h
    jp lfd8ch
lfcc3h:
    ld a,(lpt_dev)
    ld d,a
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a
    ld a,(lptype)
    ld b,a
    or a
    call z,sub_fb8fh
    call e_fb31h
    bit 0,b
    jr nz,lfd29h
    ld hl,0ea6eh
    ld a,(hl)
    ld (hl),c
    cp 0ah
    jr z,lfcf8h
    cp 0dh
    jr nz,lfd04h
    ld a,c
    cp 0ah
    jr z,lfd04h
    ld a,b
    or a
    call z,sub_fb8fh
    ld a,8dh
    call e_fe62h
lfcf8h:
    bit 1,b
    jr nz,lfd04h
    call sub_fb8fh
    ld a,11h
    call e_fe62h
lfd04h:
    ld a,c
    cp 5fh
    jr nz,lfd0bh
    ld a,0a4h
lfd0bh:
    cp 0dh
    jr z,lfd20h
    cp 0ah
    jr nz,lfd15h
    ld a,0dh
lfd15h:
    call sub_fd6bh
    bit 1,b
    call z,sub_fb8fh
    call e_fe62h
lfd20h:
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a
    jp e_fb47h
lfd29h:
    ld a,c
    call sub_fd6bh
    call e_fe62h
    jp e_fb47h

listst:
;List (printer) status
;
;Returns A=0 if no character is ready, A=0FFh if one is.
;
    ld a,(iobyte)
    and 0c0h
    jr z,ser_tx_status  ;Jump out if List is RS-232 port (LST: = TTY:)

    rla
    ld a,0ffh
    ret nc

    ld a,(iobyte)
    and 40h             ;Mask off all but bit 6
    ld a,(lpt_dev)
    jr z,lfd4bh         ;Jump if List is CBM printer (LST: = LPT:)

                        ;List must be ASCII printer (LST: = UL1:)
    ld a,(ul1_dev)
lfd4bh:
    ld d,a
    ld e,0ffh
    call e_fb31h
    call sub_fb8fh
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 08h             ;Mask off all except bit 3 (NRFD in)
    push af
    call e_fb47h
    pop af
    ret z
    dec a
    ret

ser_tx_status:
;RS-232 serial port transmit status
;Returns A=0 if not ready, A=0FFh if ready
;
    in a,(usart_st)     ;Read USART status register
    cpl                 ;Invert it
    and 84h             ;Mask off all but bits 7 (DSR) and 2 (TxEMPTY)
    ld a,0ffh
    ret z               ;Return A=0FFh if ready to transmit
    inc a
    ret                 ;Return A=0 if not ready

sub_fd6bh:
    cp 41h
    ret c
    cp 60h
    jr c,lfd78h
    cp 7bh
    ret nc
    xor 20h
    ret
lfd78h:
    xor 80h
    ret

punch:
;Punch (paper tape) output
;C = character to write to the punch
;
    ld a,(iobyte)
    and 30h
    jp z,ser_out        ;Jump out if Punch is RS-232 port (PUN: = TTY:)

                        ;Punch must be Other Device (PUN: = PTP:)
    ld a,(ptp_dev)
    ld d,a
    ld e,0ffh
    call e_fb31h
lfd8ch:
    ld a,c
    call e_fe62h
    jp e_fb47h

reader:
;Reader (paper tape) input
;Blocks until a byte is available, then returns it in A.
;
    ld a,(iobyte)
    and 0ch
    jp z,ser_in         ;Jump out if Reader is RS-232 port (RDR: = TTY:)

                        ;Punch must be Other Device (PUN: = PTR:)
    ld a,(ptr_dev)
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
    ld a,(iobyte)
    rra
    ret nc              ;Do nothing if console is RS-232 (CRT: = TTY:)

    ld c,1ah            ;01ah = Lear Siegler ADM-3A clear screen code
    jp conout_cbm

cbm_jsr:
;Jump to a subroutine in CBM memory
;
;HL = Subroutine address on CBM
;
    ld a,08h            ;Command 08h = Jump to a subroutine in CBM memory
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
    ld a,10h            ;Command 10h = Transfer from CBM to SoftBox
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
    or 04h
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
    ld a,20h            ;Command 20h = Transfer from SoftBox to CBM
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
    ld e,00h
    ld (jiffies),de
    ld (mins),hl
    ld de,0014h         ;CBM start address
    ld hl,jiffies       ;SoftBox start address
    ld bc,0004h         ;4 bytes to transfer
    jp cbm_poke         ;Transfer from SoftBox to CBM

cbm_clr_jiff:
;Clear the CBM jiffy counter
;
    xor a               ;A=0
    ld (jiffy2),a       ;Clear jiffy counter values
    ld (jiffy1),a
    ld (jiffy0),a
    ld hl,jiffy2        ;SoftBox start address
    ld de,0018h         ;CBM start address
    ld bc,0003h         ;3 bytes to transfer
    jp cbm_poke         ;Transfer from SoftBox to CBM

cbm_get_time:
;Read the CBM clocks (both RTC and jiffy counter)
    ld bc,0007h         ;7 bytes to transfer
    ld hl,jiffies       ;SoftBox start address
    ld de,0014h         ;CBM start address
    call cbm_peek       ;Transfer from CBM to SoftBox
    ld de,(jiffies)
    ld hl,(mins)
    ld a,(jiffy2)
    ld bc,(jiffy1)
    ret

e_fe62h:
    push af
lfe63h:
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 08h             ;Mask off all except bit 3 (NRFD in)
    jr z,lfe63h         ;Wait until NRFD=?

    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 04h             ;Mask off all except bit 2 (NDAC in)
    jr nz,lfe9eh        ;Jump if NDAC=?

    pop af
    out (ppi1_pb),a     ;Write byte to IEEE-488 data lines

    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    or 02h              ;Turn on bit 1 (DAV)
    out (ppi2_pb),a     ;DAV=?

lfe7ah:
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 04h             ;Mask off all except bit 2 (NDAC in)
    jr z,lfe7ah         ;Wait until NDAC=?

    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    and 0fdh            ;Turn off bit 1 (DAV)
    out (ppi2_pb),a     ;DAV=?

    xor a               ;A=0
    out (ppi1_pb),a     ;Release IEEE-488 data lines

lfe8ah:
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 04h             ;Mask off all except bit 2 (NDAC in)
    jr nz,lfe8ah        ;Wait until NDAC=?

    ex (sp),hl          ;Waste time
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl

    in a,(ppi2_pa)     ;Read IEEE-488 control lines in
    cpl                ;Mask off all except bit 2 (NDAC in)
    and 04h            ;Mask off all except bit 2 (NDAC in)
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
    and 08h             ;Mask off all except bit 3 (NRFD in)
    jr z,lfea3h         ;Wait until NRFD=?

    in a,(ppi2_pb)
    or 02h              ;Turn on bit 2 (NDAC out)
    out (ppi2_pb),a     ;NDAC=?

lfeb0h:
    in a,(ppi2_pa)
    cpl                 ;Invert A
    and 04h             ;Mask off all except bit 2 (NDAC in)
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
    and 02h
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
    and 02h             ;Mask off all except bit 1 (DAV in)
    jr nz,lfedeh        ;Wait until DAV=?

lfee5h:
    in a,(ppi1_pa)      ;Read byte from IEEE data bus
    push af             ;Put it on the stack

    in a,(ppi2_pa)
    ld (0ea6ch),a       ;TODO What is 0ea6ch?

    in a,(ppi2_pb)
    or 08h              ;Turn on bit 3 (NRFD out)
    out (ppi2_pb),a     ;NRFD=?

    in a,(ppi2_pb)
    and 0fbh            ;Turn off bit 2 (NDAC out)
    out (ppi2_pb),a     ;NDAC=?

lfef9h:
    in a,(ppi2_pa)
    cpl                 ;Invert A
    and 02h             ;Mask off all except bit 1 (DAV in)
    jr z,lfef9h         ;Wait until DAV=?

    in a,(ppi2_pb)
    or 04h              ;Turn on bit 2 (NDAC out)
    out (ppi2_pb),a     ;NDAC=?

    pop af              ;Pop the IEEE data byte off the stack
    or a                ;Set flags
    ret

e_ff09h:
    ld a,0dh
e_ff0bh:
    push af
    in a,(ppi2_pb)      ;Read state of IEEE-488 control lines out
    or 10h              ;Turn on bit 4 (EOI)
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
    db 91h, 0ffh

lffffh:
    db 0ffh
