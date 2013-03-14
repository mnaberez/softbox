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
track:    equ  0041h    ;Track number (2 bytes)
sector:   equ  0043h    ;Sector number
drive:    equ  0044h    ;Drive number (0=A, 1=B, 2=C, etc.)
dos_trk:  equ  004dh    ;CBM DOS track number
dos_sec:  equ  004eh    ;CBM DOS sector number
dos_err:  equ  004fh    ;Last error code returned from CBM DOS
tries:    equ  0050h    ;Counter used to retry drive faults in ieee_u1_or_u2
dma:      equ  0052h    ;DMA buffer area address
hl_tmp:   equ  0055h    ;Temporary storage for HL reg used in ieee_u1_or_u2
leadrcvd: equ  0059h    ;Lead-in received flag: 1=last char was lead-in
move_cnt: equ  005ah    ;Counts down bytes to consume in a cursor move seq
move_tmp: equ  005bh    ;Holds first byte received (X or Y pos) in move seq
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
ieeestat: equ 0ea6ch    ;Temp byte stores IEEE-488 control lines input state
lptype:   equ 0ea6dh    ;CBM printer (LPT:) type: 0=3022, 3032, 4022, 4023
                        ;                         1=8026, 8027 (daisywheel)
                        ;                         2=8024
list_tmp: equ 0ea6eh    ;Temporary storage byte used by LIST routine (2 bytes)
dtypes:   equ 0ea70h    ;Disk drive types:
dtype_ab: equ dtypes+0  ;  A:, B:    00h = CBM 3040/4040
dtype_cd: equ dtypes+1  ;  C:, D:    01h = CBM 8050
dtype_ef: equ dtypes+2  ;  E:, F:    02h = Corvus 10MB
dtype_gh: equ dtypes+3  ;  G:, H:    03h = Corvus 20MB
dtype_ij: equ dtypes+4  ;  I:, J:    04h = Corvus 5MB (as 1 CP/M drive)
dtype_kl: equ dtypes+5  ;  L:, K:    05h = Corvus 5MB (as 2 CP/M drives)
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
dos_buf:  equ 0ef00h    ;256 byte buffer for CBM DOS sector data

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
    jp ieee_listen   ;f033  Send LISTEN to an IEEE-488 device
    jp ieee_unlisten ;f036  Send UNLISTEN to all IEEE-488 devices
    jp ieee_talk     ;f039  Send TALK to an IEEE-488 device
    jp ieee_untalk   ;f03c  Send UNTALK to all IEEE-488 devices
    jp ieee_get_byte ;f03f  Read a byte from an IEEE-488 device
    jp ieee_put_byte ;f042  Send a byte to an IEEE-488 device
    jp ieee_eoi_byte ;f045  Send a byte to IEEE-488 device with EOI asserted
    jp ieee_eoi_cr   ;f048  Send a carriage return to IEEE-488 dev with EOI
    jp ieee_put_str  ;f04b  Send a string to the current IEEE-488 device
    jp ieee_put_itoa ;f04e  Send a number as decimal string to IEEE-488 dev
    jp e_f224h       ;f051
    jp ieee_find_dev ;f054  Find the IEEE-488 device number for a CP/M drive
    jp ieee_lisn_cmd ;f057  Open the command channel on IEEE-488 device
    jp ieee_read_err ;f05a  Read the error channel of an IEEE-488 device
    jp ieee_open     ;f05d  Open a file on an IEEE-488 device.
    jp ieee_close    ;f060  Close an open file on an IEEE-488 device.
    jp cbm_clear     ;f063  Clear the CBM screen
    jp cbm_jsr       ;f066  Jump to a subroutine in CBM memory
    jp cbm_poke      ;f069  Transfer bytes from the SoftBox to CBM memory
    jp cbm_peek      ;f06c  Transfer bytes from CBM memory to the SoftBox
    jp cbm_set_time  ;f06f  Set the time on the CBM real time clock
    jp cbm_get_time  ;f072  Read the CBM clocks (both RTC and jiffy counter)
    jp e_f578h       ;f075
    jp ieee_init_drv ;f078  Initialize an IEEE-488 disk drive
    jp ieee_atn_byte ;f07b  Send a byte to IEEE-488 device with ATN asserted
    jp ieee_get_tmo  ;f07e  Read a byte from IEEE-488 device with timeout
    jp cbm_clr_jiff  ;f081  Clear the CBM jiffy counter
    jp delay         ;f084  Programmable millisecond delay

banner:
    db 0dh,0ah,"60K SoftBox CP/M vers. 2.2"
    db 0dh,0ah,"(c) 1982 Keith Frewin"
    db 0dh,0ah,"Revision 09-June-1983"
    db 00h

wboot:
;Warm start
;
    ld sp,0100h         ;Initialize stack pointer
    xor a               ;A = CP/M drive number 0 (A:)
    call sub_f245h
    jr c,wboot_corvus

wboot_ieee:             ;Reload the system from an IEEE-488 drive:
    xor a               ;  A = CP/M drive number 0 (A:)
    call ieee_find_dev  ;  D = its IEEE-488 primary address
    ld c,16h            ;  C = 22 pages to load: D400-E9FF
    call ieee_load_cpm  ;  Load CP/M from image file (A = CBM DOS error)
    jr wboot_start_ccp

wboot_corvus:           ;Reload the system from a Corvus drive:
    ld b,2ch            ;  B = 44 sectors to load: D400-E9FF
    call corv_load_cpm  ;  Load CP/M from Corvus drive (A = Corvus error)

wboot_start_ccp:        ;System reload finished, now start the CCP:
    ld a,(dirsave)      ;  Get original CCP directory width
    ld (dirsize),a      ;  Restore it
    ld hl,ccp_base+3    ;  HL = address that clears the initial command,
                        ;       then starts the CCP

                        ;  If system reload succeeded:
    jr z,start_ccp      ;    Jump to start CCP via HL

                        ;  If system reload failed:
    xor a               ;    A = CP/M drive number 0 (A:)
    call ieee_init_drv  ;    Initialize disk drive
    jr wboot            ;    Jump to do warm start over again

corv_load_cpm:
;Load the CP/M system from a Corvus hard drive.
;
;B = number of 128-byte sectors to load
;
;Returns an error code in A (0=OK)
;
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
    ld hl,sector
    inc (hl)
    pop bc
    pop hl
    or a
    ret nz
    ld de,dma_buf
    add hl,de
    djnz lf11dh
    ret

start_ccp:
;Initialize low memory locations as required by CP/M and
;then jump to the address in HL to start the CCP.
;
    push hl             ;Save CCP entry address
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

    call e_f224h        ;Drive number valid?
    jr c,lf15ch         ;  Yes: keep it
    ld (hl),00h         ;  No: reset drive number to 0 (A:)

lf15ch:
    ld c,(hl)           ;C = pass current drive number to CCP
    xor a               ;A=0
    ld (0048h),a
    ld (0051h),a
    dec a               ;A=0ffh
    ld (drive),a
    pop hl              ;Recall CCP entry address
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
;Translate a logical sector number into a physical sector number
;to take account of skewing.
;
;Called with BC=logical sector number and DE=address of translation table.
;Returns a physical sector number in HL.
;
    ld l,c              ;HL=BC
    ld h,b
    ret

e_f224h:
;A = CP/M drive number
;
    cp 10h              ;Valid drives are 0 (A:) through 00fh (P:)
    ret nc              ;Return if drive is greater than P:
    push hl
    push af
    or a
    rra                 ;Rotate bit 0 of drive number into carry

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
;A = CP/M drive number
;Returns carry flag set if Corvus drive
;
    call e_f224h
    ret nc              ;Return if drive number is invalid

    ld a,c              ;A = drive type
    or a
    cp 06h
    ret nc              ;Return if drive number is >= 6

    cp 02h
    ccf
    ret

read:
;Read the currently set track and sector at the current DMA address.
;Returns A=0 for OK, 1 for unrecoverable error, 0FFh if media changed.
;
    ld a,(0040h)
    call sub_f245h
    jp c,corv_read_sec

    call sub_f6b9h
    ld a,01h
    call nz,ieee_read_sec
    ld a,(sector)
    rrca
    call sub_f2e5h
    xor a
    ld (0048h),a
    ret

write:
;Write the currently set track and sector.
;
;Called with deblocking code in C:
;  C=0 - Write can be deferred
;  C=1 - Write must be immediate
;  C=2 - Write can be deferred, no pre-read is necessary.
;
;Returns A=0 for OK, 1 for unrecoverable error,
;  2 if disc is readonly, 0FFh if media changed.
;
    push bc
    ld a,(0040h)
    call sub_f245h
    pop bc
    jp c,corv_writ_sec
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
    call nz,ieee_read_sec
lf2bdh:
    ld a,(sector)
    rrca
    call sub_f2e9h
    pop af
    dec a
    jr nz,lf2d1h
    ld a,(dos_err)
    or a
    call z,ieee_writ_sec
    xor a
    ret
lf2d1h:
    ld a,01h
    ld (0051h),a
    xor a
    ret

ieee_read_sec:
;Read a sector from CBM DOS into the dos_buf buffer.
;
    ld hl,dos_buf
    ex af,af'
    jp ieee_read_sec_hl

ieee_writ_sec:
;Write a sector from the dos_buf out to CBM DOS.
;
    ld hl,dos_buf
    jp ieee_writ_sec_hl

sub_f2e5h:
    ld a,00h
    jr lf2ebh
sub_f2e9h:
    ld a,01h
lf2ebh:
    ld hl,dos_buf
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
    djnz lf305h         ;Delay loop

    in a,(ppi2_pc)
    and 20h
    jr nz,sub_f2ffh     ;Wait until Corvus ACTIVE=low
    call sub_f38fh
    cp 8fh
    jr nz,sub_f2ffh
    ret

corv_read_sec:
;Read a sector from a Corvus hard drive into the DMA buffer.
;
;Returns error code in A: 0=OK, 0ffh=Error.
;
    call sub_f3a5h
    push af
    ld a,12h            ;12h = Read Sector (128 bytes)
    call corv_put_byte  ;Send command byte

    pop af
    call corv_put_byte  ;Send A
    ld a,l
    call corv_put_byte  ;Send L
    ld a,h
    call corv_put_byte  ;Send H

    ld hl,(dma)         ;HL = start address of DMA buffer area

    call corv_read_err  ;A = Corvus error code
    jr nz,corv_ret_err  ;Jump if error code is not OK

    ld b,80h            ;B = 128 bytes to read
lf334h:
    in a,(ppi2_pc)
    and 10h
    jr z,lf334h         ;Wait until Corvus READY=high
    in a,(corvus)       ;Read data byte from Corvus
    ld (hl),a           ;Store it in the buffer
    inc hl              ;Increment to next position in DMA buffer
    djnz lf334h         ;Decrement B, loop until all bytes read

corv_ret_ok:
;Return to the caller with an OK status in A indicating
;that the last Corvus operation succeeded.
;
    xor a               ;A=0 (OK)
    ret

corv_writ_sec:
;Write a sector from the DMA buffer to a Corvus hard drive.
;
;Returns error code in A: 0=OK, 0ffh=Error.
;
    call sub_f3a5h
    push af
    ld a,13h            ;13h = Write sector (128 bytes)
    call corv_put_byte  ;Send command byte

    pop af
    call corv_put_byte  ;Send A
    ld a,l
    call corv_put_byte  ;Send L
    ld a,h
    call corv_put_byte  ;Send H

    ld b,80h            ;B = 128 bytes to write
    ld hl,(dma)         ;HL = start address of DMA buffer area
lf35ch:
    in a,(ppi2_pc)
    and 10h             ;Mask off all but bit 4 (Corvus READY)
    jr z,lf35ch         ;Wait until Corvus READY=high
    ld a,(hl)           ;Read data byte from DMA buffer
    out (corvus),a      ;Send it to the Corvus
    inc hl              ;Increment to next position in DMA buffer
    djnz lf35ch         ;Decrement B, loop until all bytes written

    call corv_read_err  ;A = Corvus error
    jr z,corv_ret_ok    ;Jump if error code is OK

corv_ret_err:
;Return to the caller with an Error status in A indicating
;that the last Corvus operation failed.
;
    ld hl,corvus_msg
    push af
    call puts           ;Write "*** HARD DISK ERROR " to console out
    pop af
    call puts_hex_byte  ;Write Corvus error code to console out
    and 0ffh            ;A=0FFh (Error)
    ret

corv_read_err:
;Read the error code from a Corvus hard drive.
;
;Returns the error code in A (0=OK) and also changes
;the Z flag: Z=1 if OK, Z=0 if error.
;
    in a,(ppi2_pc)
    xor 10h
    and 30h
    jr nz,corv_read_err

    ld b,19h
lf385h:
    djnz lf385h         ;Delay loop

    in a,(ppi2_pc)
    xor 10h
    and 30h
    jr nz,corv_read_err
sub_f38fh:
    in a,(ppi2_pc)
    and 10h             ;Mask off all but bit 4 (Corvus READY)
    jr z,sub_f38fh      ;Wait until Corvus READY=high
    in a,(corvus)
    bit 7,a             ;Z flag = 1 if OK, 0 if error.
    ret

corv_put_byte:
;Send a byte to the Corvus hard drive.  Waits until the Corvus
;is ready to accept the byte, sends it, then returns immediately.
;
;A = byte to send
;
    push af
lf39bh:
    in a,(ppi2_pc)
    and 10h
    jr z,lf39bh         ;Wait until Corvus READY=high
    pop af
    out (corvus),a      ;Put byte on Corvus data bus
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
    call ieee_find_dev
    pop af
    pop hl
    add a,d
    ret

corvus_msg:
    db 0dh,0ah,07h,"*** HARD DISK ERROR ***  ",00h

puts_hex_byte:
;Write the byte in A to console out as a two digit hex number.
;
    push af             ;Preserve A
    rra                 ;Rotate high nybble into low
    rra
    rra
    rra
    call sub_f40bh      ;Write it to console out
    pop af              ;Recall A for the low nybble
                        ;Fall through to write it to console out
sub_f40bh:
    and 0fh             ;Mask off high nybble
    cp 0ah              ;Convert low nybble to ASCII char
    jr c,lf413h
    add a,07h
lf413h:
    add a,30h
    ld c,a
    jp conout           ;Write char to console out and return.

boot:
;Cold start
;
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
    or 80h
    out (ppi2_pb),a     ;IFC_OUT=low

    xor a               ;A=0
    ld (iobyte),a       ;IOBYTE=0 (CON:=TTY:, the RS-232 port)
    ld (cdisk),a        ;CDISK=0 (User=0, Drive=A:)
    ld (0054h),a
    ld (leadrcvd),a     ;Last char received was not the lead-in
    ld (move_cnt),a     ;Not in a move-to sequence
    ld (scrtab),a
    out (ppi2_pc),a     ;Turn on LEDs

    ld bc,03e8h
    call delay          ;Wait 1 second

    ld a,1bh
    ld (leadin),a       ;Terminal lead-in = 1bh (escape)

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
    ld (iobyte),a       ;IOBYTE=1 (CON:=CRT:, the CBM computer)

wait_for_atn:
;Wait until the CBM computer addresses the SoftBox.  The SoftBox
;must stay off the bus until a program on the CBM side wakes it up
;by sending attention to its address (57).  At that point, the CBM
;must start waiting for SRQs and the SoftBox can take over the bus.
;
    in a,(ppi2_pa)
    cpl
    and 03h
    in a,(ppi1_pa)
    jr nz,wait_for_atn  ;Wait until ATN_IN=low and DAV_IN=low

    cp 39h
    jr nz,wait_for_atn  ;Wait until data byte = 57 (SoftBox address)

    in a,(ppi2_pa)
    cpl
    and 02h
    jr nz,wait_for_atn  ;Wait until DAV_IN=low

lf524h:
    in a,(ppi2_pa)
    cpl
    and 02h
    jr z,lf524h         ;Wait until DAV_IN=high

lf52bh:
    ld hl,loading
    call puts           ;Write "Loading CP/M ..." to console out

    ld de,080fh         ;D = IEEE-488 primary address 8
                        ;E = IEEE-488 secondary address 15
    call ieee_listen    ;Send LISTEN

    ld bc,0007h         ;Wait 7 ms to allow IEEE-488 device 8
    call delay          ;  time to respond to LISTEN

    in a,(ppi2_pa)
    cpl
    and 04h             ;If NDAC_IN=low, it means device 8 is present.
    jr z,lf555h         ;  Jump to load CP/M from it.

    ld a,02h            ;Boot CP/M from Corvus hard drive:
    ld (dtypes),a       ;  Drive A: type = 2 (Corvus 10MB)
    ld a,01h
    ld (ddevs),a        ;  Drive A: address = 1 (Corvus ID 1)
    ld b,38h            ;  B = 56 sectors to load: D400-EFFF
    call corv_load_cpm  ;  Load CP/M from Corvus drive (A = Corvus error)
    jr e_f578h

lf555h:
    call ieee_unlisten  ;Send UNLISTEN.  Device 8 should still be
                        ;  listening from when we tested it above.

    ld de,080fh         ;D = IEEE-488 primary address 8
                        ;E = IEEE-488 secondary address 15
    ld c,02h            ;2 bytes in string
    ld hl,dos_i0_0      ;"I0"
    call ieee_open

    ld d,08h            ;D = IEEE-488 primary address 8
    ld c,1ch            ;C = 28 pages to load: D400-EFFF
    call ieee_load_cpm  ;Load CP/M from image file (A = CBM DOS error)
    jp nz,lf52bh

    ld de,0802h         ;D = IEEE-488 primary address 8
                        ;E = IEEE-488 secondary address 2
    ld c,02h            ;2 bytes in string
    ld hl,dos_num2      ;"#2"
    call ieee_open

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
    ld (ix+0ch),l
    ld (ix+0dh),h
    ld a,(0058h)
    ld b,00h
    ld c,a
    add hl,bc
    rla
    ld c,a
lf5beh:
    ld (ix+0eh),l
    ld (ix+0fh),h
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
    call puts           ;Write "60K SoftBox CP/M" banner to console out

    call const          ;Check if a key is waiting (0=key, 0ffh=no key)
    inc a
    call z,conin        ;Get a key if one is waiting

    ld hl,ccp_base      ;HL = address that starts CCP with initial command
    jp start_ccp        ;Start CCP via HL

loading:
    db 0dh,0ah,"Loading CP/M ...",00h

ieee_load_cpm:
;Load the CP/M system from an IEEE-488 disk drive.
;
;D = IEEE-488 primary address of CBM disk drive
;C = number of 256-byte pages to load from the image file
;
;Returns the CBM DOS error code in A (0=OK)
;
;SoftBox Memory Map:
;  F800-FFFF  BIOS ROM High (IC4)   2048
;  F000-F7FF  BIOS ROM Low (IC3)    2048
;  EA80-EFFF  BIOS Working Storage  1408 -+
;  EA00-EA7F  BIOS Configuration     128  | CP/M
;  DC00-E9FF  BDOS                  3584  | image file
;  D400-DBFF  CCP                   2048 -+
;  0100-D3FF  TPA                  54016
;  0000-00FF  Low Storage            256
;
;The CP/M image is a CBM DOS program file called "CP/M" on the SoftBox
;boot disk.  The file is 7168 bytes total.  During cold start, the entire
;file is loaded into memory from D400-EFFF (28 pages).  During warm start,
;only D400-E9FF (22 pages) is reloaded from the file.
;
    push bc
    push de
    ld hl,filename      ;"0:CP/M"
    ld c,06h            ;6 characters
    ld e,00h            ;0 = Secondary address
    call ieee_open      ;Send LOAD and filename
    pop de
    push de
    call ieee_rd_err_d  ;A = CBM DOS error code
    pop de
    ld e,00h
    pop bc
    or a
    ret nz              ;Return if CBM DOS error is not 0 (OK)

    push de
    call ieee_talk      ;Send TALK
    ld hl,ccp_base      ;HL = base address of CP/M system
                        ;C = number of pages to load (1 page = 256 bytes),
                        ;      which is set by the caller
    ld b,00h            ;B = counts down bytes within each page
lf671h:
    call ieee_get_byte  ;Get byte from CP/M image file
    ld (hl),a           ;Store it in memory
    inc hl              ;Increment memory pointer
    djnz lf671h         ;Decrement B and loop until current page is done
    dec c               ;Decrement C
    jr nz,lf671h        ;Loop until all pages are done
    call ieee_untalk    ;Send UNTALK
    pop de

    push de
    call ieee_close     ;Close the file
    pop de
    jp ieee_rd_err_d    ;Jump out to read CBM DOS error channel.  It will
                        ;  return to the caller.

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
    ld hl,drive
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
    call nz,ieee_writ_sec
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

ieee_u1_or_u2:
;Perform a CBM DOS block read or block write.
;
;HL = pointer to string, either "U1 2 " (Block Read)
;       or "U1 2 " (Block Write)
;
    ld (hl_tmp),hl      ;Preserve HL
    call sub_f8dah
lf702h:
    ld a,03h
    ld (tries),a        ;3 tries
lf707h:
    ld a,(drive)        ;A = CP/M drive number
    call ieee_lisn_cmd  ;Open the command channel

    ld hl,(hl_tmp)      ;Recall HL (pointer to "U1 2 " or "U2 2 ")
    ld c,05h            ;5 bytes in string
    call ieee_put_str   ;Send the string

    ld a,(drive)        ;A = CP/M drive number
    and 01h             ;Mask off all except bit 0
    add a,30h           ;Convert to ASCII
    call ieee_put_byte  ;Send CBM drive number (either "0" or "1")

    ld a,(dos_trk)
    call ieee_put_itoa  ;Send the CBM DOS track

    ld a,(dos_sec)
    call ieee_put_itoa  ;Send the CBM DOS sector

    call ieee_eoi_cr    ;Send carriage return with EOI
    call ieee_unlisten  ;Send UNLISTEN

    ld a,(drive)        ;A = CP/M drive number
    call ieee_read_err  ;Read the error channel
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

    ld hl,tries
    dec (hl)            ;Decrement tries
    jr z,lf752h         ;Give up number of tries exceeded

    ld a,(drive)        ;A = CP/M drive number
    call ieee_init_drv  ;Initialize the disk drive
    jr lf707h           ;Try again

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
    ld a,(drive)        ;A = CP/M drive number
    call ieee_init_drv  ;Initialize the disk drive
    ld a,(dos_err)
    cp 1ah
    jp z,lf702h         ;Try again if error is write protect on
    cp 15h
    jp z,lf702h         ;Try again if error is drive not ready
    ld a,00h
    ret

puts_dos_error:
;Write a description of a CBM DOS error to console out.
;HL = pointer to cbm_dos_errs table
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
;      Hex SoftBox Error Message          Dec  CBM DOS Error Description
;      --- ---------------------          ---  -------------------------
    db 1ah,"Disk write protected",00h     ;26  Write Protect On
    db 19h,"Write verify error",00h       ;25  Write Error (write-verify)
    db 1ch,"Long data block",00h          ;28  Write Error (long data block)
    db 14h,"Missing header",00h           ;20  Read Error (no block header)
    db 15h,"Disk not ready",00h           ;21  Read Error (no sync char)
    db 4ah,"Disk not ready",00h           ;74  Drive Not Ready
    db 16h,"Missing data block",00h       ;22  Read Error (no data block)
    db 17h,"Checksum error in data",00h   ;23  Read Error (data checksum)
    db 1bh,"Checksum error in header",00h ;27  Read Error (header checksum)
    db 18h,"Byte decoding error",00h      ;24  Read Error (byte decoding)
    db 46h,"Commodore DOS bug !",00h      ;70  No Channel
    db 49h,"Wrong DOS format",00h         ;73  DOS Mismatch
    db 0ffh,"Unknown error code",00h

colon_space:
    db ": ",00h

bdos_err_on:
    db 0dh,0ah,"BDOS err on ",00h

dos_u1_2:
    db "U1 2 "

dos_u2_2:
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
    ld (dos_sec),a
    ld a,(ix+00h)
    ld (dos_trk),a
    pop de
    cp e
    ret c
    add a,03h
    ld (dos_trk),a
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

ieee_put_itoa:
;Send a number as decimal string to IEEE-488 device
;A = number (e.g. A=2ah sends " 42")
;
    push af
    ld a,20h
    call ieee_put_byte
    pop af
    ld e,2fh
lf9ach:
    sub 0ah
    inc e
    jr nc,lf9ach
    add a,3ah
    push af
    ld a,e
    call ieee_put_byte
    pop af
    jp ieee_put_byte

ieee_read_err:
;Read the error channel of an IEEE-488 device
;A = CP/M drive number
;
    call ieee_find_dev  ;D = IEEE-488 primary address
                        ;Fall through into ieee_rd_err_d

ieee_rd_err_d:
;Read the error channel of an IEEE-488 device
;D = IEEE-488 primary address
;
    ld e,0fh
    call ieee_talk
    ld hl,dos_msg
lf9c7h:
    call ieee_get_byte
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
    call ieee_get_byte
    ld (hl),a
    inc hl
    sub 30h
    add a,b
    push af
    ld c,3ch
lf9e5h:
    call ieee_get_byte
    dec c
    jp m,lf9eeh
    ld (hl),a
    inc hl
lf9eeh:
    cp 0dh
    jr nz,lf9e5h
    call ieee_untalk
    pop af
    ret

ieee_writ_sec_hl:
;Write a sector to the CBM disk drive from buffer at HL.
;
    push hl
                        ;Send memory-write (M-W) command:
    ld hl,dos_mw        ;  HL = pointer to "M-W",00h,13h,01h
    ld c,06h            ;  6 bytes in string
    ld a,(drive)        ;  A = CP/M drive number
    call ieee_lisn_cmd  ;  Open command channel
    call ieee_put_str   ;  Send the command
    pop hl

                        ;Send first byte of sector to M-W:
    ld a,(hl)           ;  Get first byte
    push hl
    call ieee_eoi_byte  ;  Send it for M-W
    call ieee_unlisten  ;  Send UNLISTEN

                        ;Move pointer to second byte of buffer:
    ld hl,dos_bp        ;  "B-P 2 1" (Buffer-Pointer)
    ld c,07h            ;  7 bytes in string
    ld a,(drive)        ;  A = CP/M drive number
    call ieee_lisn_cmd  ;  Open command channel
    call ieee_put_str   ;  Send B-P command
    call ieee_eoi_cr    ;  Send carriage return with EOI
    call ieee_unlisten  ;  Send UNLISTEN

                        ;Send remaining 255 bytes of block:
    ld a,(drive)        ;  A = CP/M drive number
    call ieee_find_dev  ;  D = its IEEE-488 device number
    ld e,02h            ;  E = file #2
    call ieee_listen    ;  Send LISTEN
    pop hl
    inc hl
    ld c,0ffh           ;  255 bytes to send
    call ieee_put_str   ;  Send the bytes
    call ieee_unlisten  ;  Send UNLISTEN

                        ;Perform block write (U2):
    ld hl,dos_u2_2      ;  HL = pointer to "U2 2 " string (Block Write)
    jp ieee_u1_or_u2    ;  Jump out to perform the block write.  It will
                        ;    return to the caller.

ieee_read_sec_hl:
;Read a sector from a CBM disk drive into buffer at HL.
;
    push hl
                        ;Perform block read (U1):
    ld hl,dos_u1_2      ;  HL = pointer to "U1 2 " string
    call ieee_u1_or_u2  ;  Call to perform the block read

                        ;Send memory read (M-R) command:
    ld hl,dos_mr        ;  HL = pointer to "M-R",00h,13h
    ld c,05h            ;  5 bytes in string
    ld a,(drive)        ;  A = CP/M drive number
    call ieee_lisn_cmd  ;  Open command channel
    call ieee_put_str   ;  Send M-R command
    call ieee_eoi_cr    ;  Send carriage return with EOI
    call ieee_unlisten  ;  Send UNLISTEN

                        ;Read first byte of sector from M-R:
    ld a,(drive)        ;  A = CP/M drive number
    call ieee_find_dev  ;  D = its IEEE-488 device number
    ld e,0fh            ;  E = Command channel number (15)
    call ieee_talk      ;  Send TALK
    call ieee_get_byte  ;  Read the byte returned by M-R
    pop hl
    ld (hl),a           ;  Save as first byte of sector
    push hl
    call ieee_untalk    ;  Send UNTALK

                        ;Move pointer to second byte of buffer:
    ld a,(drive)        ;  A = CP/M drive number
    call ieee_lisn_cmd  ;  Open command channel
    ld hl,dos_bp        ;  "B-P 2 1" (Buffer-Pointer)
    ld c,07h            ;  7 bytes in string
    call ieee_put_str   ;  Send B-P command
    call ieee_eoi_cr    ;  Send carriage return with EOI
    call ieee_unlisten  ;  Send UNLISTEN

                        ;Check for CBM DOS bug:
    ld a,(drive)        ;  A = CP/M drive number
    call ieee_read_err  ;  Read CBM DOS error channel
    cp 46h              ;  Error code = 70 No Channel?
    jr z,read_sec_retry ;    Yes: CBM DOS bug, jump to retry

                        ;Read remaining 255 bytes of block:
    ld a,(drive)        ;  A = CP/M drive number
    call ieee_find_dev  ;  D = its IEEE-488 device number
    ld e,02h            ;  E = file #2
    call ieee_talk      ;  Send TALK
    pop de
    inc de
    ld b,0ffh           ;  255 bytes to read
read_sec_loop:
    call ieee_get_byte  ;  Read byte
    ld (de),a           ;  Store it
    inc de
    djnz read_sec_loop  ;  Decrement B, loop until all bytes read
    jp ieee_untalk      ;  Send UNTALK and return to caller

read_sec_retry:
    ld a,(drive)        ;A = CP/M drive number
    call ieee_init_drv  ;Initialize the CBM disk drive
    pop hl              ;Recall original HL
    jr ieee_read_sec_hl ;Try again

ieee_find_dev:
;Find the IEEE-488 device number for a CP/M drive
;A = CP/M drive number (0=A:, 1=B:, ...)
;Returns IEEE-488 device number in D
;
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

ieee_lisn_cmd:
;Open command channel on IEEE-488
;A = CP/M drive number (0=A:, 1=B:, ...)
;HL = pointer to string
;C = number of bytes in string
;
    call ieee_find_dev
    ld e,0fh
    jp ieee_listen

ieee_init_drv:
;Initialize an IEEE-488 disk drive
;A = CP/M drive number (0=A:, 1=B:, ...)
;
    call ieee_find_dev  ;D = IEEE-488 device number
    ld e,0fh            ;0fh = Command channel
    push de

    ld c,02h            ;2 bytes in string
    ld hl,dos_i0        ;"I0"
    rra
    jr nc,lfad5h
    ld hl,dos_i1        ;"I1"
lfad5h:
    call ieee_open
    pop de
    ld e,02h            ;E = Secondary address 2
    ld c,02h            ;C = 2 bytes in string
    ld hl,dos_num2      ;"#2"
    jp ieee_open

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

ieee_talk:
;Send TALK to an IEEE-488 device
;D = primary address
;E = secondary address (0ffh if none)
;
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a     ;ATN_OUT=low

                        ;Send primary address:
    ld a,40h            ;  High nybble (4) = Talk Address Group
    or d                ;  Low nybble (D) = primary address
    call ieee_put_byte

    jr c,atn_out_high

                        ;Send secondary address if any:
    ld a,e              ;  Low nybble (E) = secondary address
    or 60h              ;  High nybble (6) = Secondary Command Group
    call p,ieee_put_byte

    in a,(ppi2_pb)
    or 0ch
    out (ppi2_pb),a     ;NDAC_OUT=low, NRFD_OUT=low
                        ;Fall through into atn_out_high

atn_out_high:
;ATN_OUT=high then wait a short time
;
    push af
    in a,(ppi2_pb)
    and 0feh
    out (ppi2_pb),a     ;ATN_OUT=high
    ld a,19h
lfb1ch:
    dec a
    jr nz,lfb1ch        ;Delay loop
    pop af
    ret

ieee_untalk:
;Send UNTALK to all IEEE-488 devices.
;
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a     ;ATN_OUT=low

    in a,(ppi2_pb)
    and 0f3h
    out (ppi2_pb),a     ;NDAC_OUT=high, NRFD_OUT=high

    ld a,5fh            ;5fh = UNTALK
    jr ieee_atn_byte

ieee_listen:
;Send LISTEN to an IEEE-488 device
;D = primary address
;E = secondary address (0ffh if none)
;
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a     ;ATN_OUT=low

                        ;Send primary address:
    ld a,20h            ;  High nybble (2) = Listen Address Group
    or d                ;  Low nybble (D) = primary address
    call ieee_put_byte

    jr c,atn_out_high

                        ;Send secondary address if any:
    ld a,e              ;  Low nybble (E) = secondary address
    or 60h              ;  High nybble (6) = Secondary Command Group
    call p,ieee_put_byte
    jr atn_out_high

ieee_unlisten:
;Send UNLISTEN to all IEEE-488 devices.
;
    ld a,3fh            ;3fh = UNLISTEN
                        ;Fall through into ieee_atn_byte

ieee_atn_byte:
;Send a byte to an IEEE-488 device with ATN asserted
;ATN_OUT=low, put byte, ATN_OUT=high, wait
;
    push af
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a     ;ATN_OUT=low
    pop af
    call ieee_put_byte
    jr atn_out_high

ieee_open:
;Open a file on an IEEE-488 device.
;
;D = primary address
;E = file number
;C = number of bytes in filename
;HL = pointer to filename
;
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a     ;ATN_OUT=low

    ld a,d              ;Low nybble (D) = primary address
    or 20h              ;High nybble (2) = Listen Address Group
    call ieee_put_byte

    ld a,e              ;Low nybble (E)
    or 0f0h             ;High nybble (0Fh) = Secondary Command Group
                        ;                    OPEN"file" and SAVE only
    call ieee_atn_byte

    dec c
    call nz,ieee_put_str ;Send string except for last char

    ld a,(hl)
    call ieee_eoi_byte  ;Send the last char with EOI asserted

    jr ieee_unlisten    ;Send UNLISTEN

ieee_close:
;Close an open file on an IEEE-488 device.
;
;D = primary address
;E = file number
;
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a     ;ATN_OUT=low

    ld a,d              ;Low nybble (D) = primary address
    or 20h              ;High nybble (2) = Listen Address Group
    call ieee_put_byte

    ld a,e              ;Low nybble (E) = file number
    or 0e0h             ;High nybble (0Eh) = CLOSE
    call ieee_put_byte

    jr ieee_unlisten    ;Send UNLISTEN

delay:
;Programmable millisecond delay
;BC = number of milliseconds to wait
;
    call delay_1ms
    dec bc              ;Decrement BC
    ld a,b
    or c
    jr nz,delay         ;Loop until BC=0
    ret

delay_1ms:
;Wait for 1 millisecond
;
    push bc             ;Preserve BC
    ld b,0c8h           ;B=0c8h
lfb92h:
    add a,00h           ;A=A+0
    djnz lfb92h         ;Decrement B, loop until B=0
    pop bc              ;Restore BC
    ret

conin:
;Console input
;Blocks until a key is available, then returns the key in A.
;
    ld a,(iobyte)
    rra
    jp nc,ser_in        ;Jump out if console is RS-232 port (CON: = TTY:)

    in a,(ppi2_pb)
    or 04h
    out (ppi2_pb),a     ;NDAC_OUT=low

    ld a,02h            ;Command 02h = Wait for a key and send it
    call cbm_srq
    call ieee_get_byte

    push af
    in a,(ppi2_pb)
    and 0f3h
    out (ppi2_pb),a     ;NDAC_OUT=high, NRFD_OUT=high
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
    rra                 ;If the console is the RS-232 port (CON: = TTY:),
    jp nc,ser_out       ;  jump out to send the char directly to the port

    ld a,(move_cnt)
    or a                ;If handling a move-to sequence, jump to consume
    jp nz,move_consume  ;  the next byte in the sequence.

    ld a,c
    rla                 ;If bit 7 of the char is set,
    jr c,conout_cbm     ;  jump out to send it directly to the CBM screen.

    ld a,(leadin)
    cp c                ;If the char is not the lead-in code,
    jr nz,conout_char   ;  jump to handle it.

    ld a,01h
    ld (leadrcvd),a     ;If the char is the lead-in code,
    ret                 ;  set a flag and return.

conout_char:
    ld a,(leadrcvd)
    or a                ;If the last char received was not the lead-in
    jp z,lfbf3h         ;  jump

    xor a
    ld (leadrcvd),a     ;Clear the lead-in received flag
    set 7,c             ;Set bit 7 of the char

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

    cp 1bh              ;1bh = LSI ADM-3A command to start move-to sequence
    jr z,move_start     ;Jump to start move-to sequence

    ld c,a

conout_cbm:
;Put the character in C on the CBM screen
;
    ld a,04h            ;Command 04h = Write to the terminal screen
    call cbm_srq
    ld a,c              ;A=C
    jp cbm_put_byte     ;Jump out to send byte in A

move_start:
;Start a cursor move sequence.  The next two bytes received will be
;the X and Y positions.
;
    ld a,02h            ;2 more bytes to consume (X and Y positions)
    ld (move_cnt),a
    ret

move_consume:
;Consume the next byte in a cursor move position.  When both X and
;Y position bytes have been received, jump to do the move.
;
;A = current value of MOVE_CNT
;C = byte received
;
    dec a               ;Decrement bytes remaining to consume
    ld (move_cnt),a
    jr z,move_prep_xy   ;Jump if no more bytes to consume

    ld a,c
    ld (move_tmp),a     ;Remember C in MOVE_TMP
    ret

move_prep_xy:
;Prepare to send the move-to sequence.  Both X and Y position bytes
;have been received.  Swap them in necessary, then send the move-to
;sequence to the CBM.
;
;C = one position (X or Y), other position is in MOVE_TMP
;
    ld a,(move_tmp)     ;A = contains other position (X or Y)
    ld d,a              ;D = A
    ld e,c              ;E = C

    ld a,(xy_order)     ;xy_order: 0=Y first, 1=X first
    or a
    jr z,move_send      ;Jump if positions don't need to be swapped

    ld a,e
    ld e,d
    ld d,a              ;Swap D and E
                        ;Fall through into MOVE_SEND

move_send:
;Send move-to sequence
;D = X-position, E = Y-position
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
    jp conout_cbm       ;Jump out to send Y-position byte for move-to

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
    in a,(ppi1_pa)
    or a
    jr nz,lfc81h        ;Wait for IEEE data bus to be released

    pop af
    out (ppi1_pb),a     ;Write data byte to IEEE data bus

    in a,(ppi2_pb)
    or 20h
    out (ppi2_pb),a     ;SRQ_OUT=low

    in a,(ppi2_pb)
    and 0dfh
    out (ppi2_pb),a     ;SRQ_OUT=high

lfc95h:
    in a,(ppi1_pa)      ;Read IEEE data byte
    and 0c0h            ;Mask off all except bits 6 and 7
    jr z,lfc95h         ;Wait until CBM changes one of those bits

    rla                 ;Rotate bit 7 (key available status) into Carry flag
    push af             ;Push data IEEE data byte read from CBM

    ld a,00h
    out (ppi1_pb),a     ;Release IEEE data lines

lfca1h:
    in a,(ppi1_pa)
    or a
    jr nz,lfca1h        ;Wait for IEEE data bus to be released

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
    call ieee_listen
    jp lfd8ch
lfcc3h:
    ld a,(lpt_dev)
    ld d,a
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a     ;ATN_OUT=low
    ld a,(lptype)
    ld b,a
    or a
    call z,delay_1ms
    call ieee_listen
    bit 0,b
    jr nz,lfd29h
    ld hl,list_tmp      ;TODO Where is the initial value of list_tmp set?
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
    call z,delay_1ms
    ld a,8dh
    call ieee_put_byte
lfcf8h:
    bit 1,b
    jr nz,lfd04h
    call delay_1ms
    ld a,11h
    call ieee_put_byte
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
    call z,delay_1ms
    call ieee_put_byte
lfd20h:
    in a,(ppi2_pb)
    or 01h
    out (ppi2_pb),a     ;ATN_OUT=low
    jp ieee_unlisten
lfd29h:
    ld a,c
    call sub_fd6bh
    call ieee_put_byte
    jp ieee_unlisten

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
    call ieee_listen
    call delay_1ms
    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and 08h             ;Mask off all except bit 3 (NRFD in)
    push af
    call ieee_unlisten
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
    ld d,a              ;D = IEEE-488 primary address for PTP:
    ld e,0ffh           ;E = no IEEE-488 secondary address
    call ieee_listen
lfd8ch:
    ld a,c              ;C = byte to send to IEEE-488 device
    call ieee_put_byte
    jp ieee_unlisten

reader:
;Reader (paper tape) input
;Blocks until a byte is available, then returns it in A.
;
    ld a,(iobyte)
    and 0ch
    jp z,ser_in         ;Jump out if Reader is RS-232 port (RDR: = TTY:)

                        ;Reader must be Other Device (RDR: = PTR:)
    ld a,(ptr_dev)
    ld d,a              ;D = IEEE-488 primary address for PTR:
    ld e,0ffh           ;E = no IEEE-488 secondary address
    call ieee_talk
    call ieee_get_byte  ;A = byte read from IEEE-488 device
    push af
    call ieee_untalk
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
    call cbm_put_byte   ;Send low byte of address
    ld a,h
    jp cbm_put_byte     ;Send high byte

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
    call cbm_put_byte   ;Send low byte of byte counter
    ld a,b
    call cbm_put_byte   ;Send high byte
    ld a,e
    call cbm_put_byte   ;Send low byte of CBM start address
    ld a,d
    call cbm_put_byte   ;Send high byte

    in a,(ppi2_pb)
    or 04h
    out (ppi2_pb),a     ;NDAC_OUT=low

cbm_peek_loop:
    call ieee_get_byte  ;Read a byte from the CBM
    ld (hl),a           ;Store it at the pointer
    inc hl              ;Increment pointer
    dec bc              ;Decrement bytes remaining to transfer
    ld a,b
    or c
    jr nz,cbm_peek_loop ;Loop until no bytes are remaining

    in a,(ppi2_pb)
    and 0f3h
    out (ppi2_pb),a     ;NRFD_OUT=high, NDAC_OUT=high
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
    call cbm_put_byte   ;Send low byte of byte counter
    ld a,b
    call cbm_put_byte   ;Send high byte
    ld a,e
    call cbm_put_byte   ;Send low byte of CBM start address
    ld a,d
    call cbm_put_byte   ;Send high byte
cbm_poke_loop:
    ld a,(hl)           ;Read byte at pointer
    call cbm_put_byte   ;Send it to the CBM
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

ieee_put_byte:
    push af
lfe63h:
    in a,(ppi2_pa)
    cpl
    and 08h
    jr z,lfe63h         ;Wait until NRFD_IN=high

    in a,(ppi2_pa)
    cpl
    and 04h
    jr nz,lfe9eh        ;Jump if NDAC_IN=high

    pop af
    out (ppi1_pb),a     ;Write byte to IEEE-488 data lines

    in a,(ppi2_pb)
    or 02h
    out (ppi2_pb),a     ;DAV_OUT=low

lfe7ah:
    in a,(ppi2_pa)
    cpl
    and 04h
    jr z,lfe7ah         ;Wait until NDAC_IN=high

    in a,(ppi2_pb)
    and 0fdh
    out (ppi2_pb),a     ;DAV_OUT=high

    xor a
    out (ppi1_pb),a     ;Release IEEE-488 data lines

lfe8ah:
    in a,(ppi2_pa)
    cpl
    and 04h
    jr nz,lfe8ah        ;Wait until NDAC_IN=low

    ex (sp),hl          ;Waste time
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl

    in a,(ppi2_pa)
    cpl
    and 04h
    jr nz,lfe8ah        ;Wait until NDAC_IN=low

    or a                ;Set flags
    ret

lfe9eh:
    pop af
    scf
    ret

cbm_put_byte:
;Send a single byte to the CBM
;
    out (ppi1_pb),a     ;Put byte on IEEE data bus

lfea3h:
    in a,(ppi2_pa)
    cpl
    and 08h
    jr z,lfea3h         ;Wait until NRFD_IN=high

    in a,(ppi2_pb)
    or 02h
    out (ppi2_pb),a     ;DAV_OUT=low

lfeb0h:
    in a,(ppi2_pa)
    cpl
    and 04h
    jr z,lfeb0h         ;Wait until NDAC_IN=high

    in a,(ppi2_pb)
    and 0fdh
    out (ppi2_pb),a     ;DAV_OUT=high

    xor a
    out (ppi1_pb),a     ;Release IEEE-488 data lines
    ret

ieee_get_tmo:
;Read a byte from IEEE-488 device with timeout
;BC = number milliseconds before timeout
;
    in a,(ppi2_pb)
    and 0f7h
    out (ppi2_pb),a     ;NRFD_OUT=high
lfec7h:
    in a,(ppi2_pa)
    cpl
    and 02h
    jr z,lfee5h         ;Jump out if DAV_IN=low
    call delay_1ms
    dec bc              ;Decrement BC
    ld a,b
    or c
    jr nz,lfec7h        ;Loop until BC=0
    scf
    ret

ieee_get_byte:
;Read a byte from the current IEEE-488 device
;
    in a,(ppi2_pb)
    and 0f7h
    out (ppi2_pb),a     ;NRFD_OUT=high

lfedeh:
    in a,(ppi2_pa)
    cpl
    and 02h
    jr nz,lfedeh        ;Wait until DAV_IN=low

lfee5h:
    in a,(ppi1_pa)      ;Read byte from IEEE data bus
    push af             ;Push it on the stack

    in a,(ppi2_pa)      ;Read state of IEEE-488 control lines in
    ld (ieeestat),a     ;TODO 0ea6ch Is this used?

    in a,(ppi2_pb)
    or 08h
    out (ppi2_pb),a     ;NRFD_OUT=low

    in a,(ppi2_pb)
    and 0fbh
    out (ppi2_pb),a     ;NDAC_OUT=high

lfef9h:
    in a,(ppi2_pa)
    cpl
    and 02h
    jr z,lfef9h         ;Wait until DAV_IN=high

    in a,(ppi2_pb)
    or 04h
    out (ppi2_pb),a     ;NDAC_OUT=low

    pop af              ;Pop the IEEE data byte off the stack
    or a                ;Set flags
    ret

ieee_eoi_cr:
;Send a carriage return to IEEE-488 device with EOI
;
    ld a,0dh

ieee_eoi_byte:
;Send a byte to IEEE-488 device with EOI asserted
;
    push af
    in a,(ppi2_pb)
    or 10h
    out (ppi2_pb),a     ;EOI_OUT=low

    pop af
    call ieee_put_byte
    push af

    in a,(ppi2_pb)
    and 0efh
    out (ppi2_pb),a     ;EOI_OUT=high

    pop af
    ret

ieee_put_str:
;Send a string to the current IEEE-488 device
;HL = pointer to string
;C = number of bytes in string
;
    ld a,(hl)
    inc hl
    call ieee_put_byte
    dec c
    jr nz,ieee_put_str
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
