;SoftBox CP/M 2.2 BIOS
;Revision 09-June-1983
;
;This is a disassembly of two original 2716 EPROMs from a SoftBox,
;labeled "389" (IC3) and "390" (IC4).
;
;SoftBox Memory Map:
;  F800-FFFF  BIOS ROM High (IC4)   2048
;  F000-F7FF  BIOS ROM Low (IC3)    2048
;  EA80-EFFF  BIOS Working Storage  1408
;  EA00-EA7F  BIOS Configuration     128
;  DC00-E9FF  BDOS                  3584
;  D400-DBFF  CCP                   2048
;  0100-D3FF  TPA                  54016
;  0000-00FF  Low Storage            256
;

usart:    equ 08h       ;8251 USART (IC15)
usart_db: equ usart+0   ;  Data Buffer
usart_st: equ usart+1   ;  Status Register

baud_gen: equ 0ch       ;COM8116 Baud Rate Generator (IC14)
                        ;  D7-D4: TD-TA
                        ;  D3-D0: RD-RA

ppi1:     equ 10h       ;8255 PPI #1 (IC17)
ppi1_pa:  equ ppi1+0    ;  Port A: IEEE-488 Data In
ppi1_pb:  equ ppi1+1    ;  Port B: IEEE-488 Data Out
ppi1_pc:  equ ppi1+2    ;  Port C: DIP Switches (Unused)
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
                        ;    PC5 Corvus DIRC in
                        ;    PC4 Corvus READY in
                        ;    PC3 Unused
                        ;    PC2 LED "Ready" out
                        ;    PC1 LED "B" out
                        ;    PC0 LED "A" out
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

                        ;Latest disk position set by BDOS:
drive:    equ  0040h    ;  Drive number (0=A, 1=B, 2=C, etc.)
track:    equ  0041h    ;  Track number (2 bytes)
sector:   equ  0043h    ;  Sector number

                        ;Alternate copy of disk position (??):
x_drive:  equ  0044h    ;  Drive number (0=A, 1=B, 2=C, etc.)
x_track:  equ  0045h    ;  Track number (2 bytes)
x_sector: equ  0047h    ;  Sector number

                        ;Alternate copy of disk position (??):
sec_cnt:  equ  0048h    ;  Counts down sectors, related to y_* (TODO how?)
y_drive:  equ  0049h    ;  Drive number (0=A, 1=B, 2=C, etc.)
y_track:  equ  004ah    ;  Track number (2 bytes)
y_sector: equ  004ch    ;  Sector number

dos_trk:  equ  004dh    ;CBM DOS track number
dos_sec:  equ  004eh    ;CBM DOS sector number
dos_err:  equ  004fh    ;Last CBM DOS error code saved by ieee_u1_or_u2
tries:    equ  0050h    ;Counter used to retry drive faults in ieee_u1_or_u2
wrt_pend: equ  0051h    ;CBM DOS buffer state (1=write is pending, 0=none)
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
xy_order: equ 0ea69h    ;X,Y order when sending move-to: 0=Y first, 1=X first
y_offset: equ 0ea6ah    ;Offset added to Y when sending move-to sequence
x_offset: equ 0ea6bh    ;Offset added to X when sending move-to sequence
eoisav:   equ 0ea6ch    ;Stores ppi2_pa IEEE-488 control lines after get byte
                        ;  This allows a program to check for EOI after it
                        ;  calls rdieee or rdimm.
lptype:   equ 0ea6dh    ;CBM printer (LPT:) type: 0=3022, 3023, 4022, 4023
                        ;                         1=8026, 8027 (daisywheel)
                        ;                         2=8024
list_tmp: equ 0ea6eh    ;Stores the last character sent to the LIST routine
dtypes:   equ 0ea70h    ;Disk drive types:
dtype_ab: equ dtypes+0  ;  A:, B:    00h = CBM 3040/4040
dtype_cd: equ dtypes+1  ;  C:, D:    01h = CBM 8050
dtype_ef: equ dtypes+2  ;  E:, F:    02h = Corvus 10MB
dtype_gh: equ dtypes+3  ;  G:, H:    03h = Corvus 20MB
dtype_ij: equ dtypes+4  ;  I:, J:    04h = Corvus 5MB (as 1 CP/M drive)
dtype_kl: equ dtypes+5  ;  L:, K:    05h = Corvus 5MB (as 2 CP/M drives)
dtype_mn: equ dtypes+6  ;  M:, N:    06h = CBM 8250 (Broken, see ieeenum)
dtype_op: equ dtypes+7  ;  O:, P:   0ffh = No device

ddevs:    equ 0ea78h    ;Disk drive device addresses:
ddev_ab:  equ ddevs+0   ;  A:, B:
ddev_cd:  equ ddevs+1   ;  C:, D:    For CBM floppy drives, the number
ddev_ef:  equ ddevs+2   ;  E:, F:    is an IEEE-488 primary address.
ddev_gh:  equ ddevs+3   ;  G:, H:
ddev_ij:  equ ddevs+4   ;  I:, J:    For Corvus hard drives, the number
ddev_kl:  equ ddevs+5   ;  L:, K:    is an ID on a Corvus unit.
ddev_mn:  equ ddevs+6   ;  M:, N:
ddev_op:  equ ddevs+7   ;  O:, P:

scrtab:   equ 0ea80h    ;64 byte table for terminal character translation
errbuf:   equ 0eac0h    ;Last error message returned from CBM DOS
dph_base: equ 0eb00h    ;CP/M Disk Parameter Headers (DPH)
dos_buf:  equ 0ef00h    ;256 byte buffer for CBM DOS sector data

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

lf000h:
;Standard CP/M 2.2 BIOS entry points
;
    jp boot             ;f000  Cold start
    jp wboot            ;f003  Warm start
    jp const            ;f006  Console status
    jp conin            ;f009  Console input
    jp conout           ;f00c  Console output
    jp list             ;f00f  List (printer) output
    jp punch            ;f012  Punch (paper tape) output
    jp reader           ;f015  Reader (paper tape) input
    jp home             ;f018  Move to track 0 on selected disk
    jp seldsk           ;f01b  Select disk drive
    jp settrk           ;f01e  Set track number
    jp setsec           ;f021  Set sector number
    jp setdma           ;f024  Set DMA address
    jp read             ;f027  Read selected sector
    jp write            ;f02a  Write selected sector
    jp listst           ;f02d  List (printer) status
    jp sectran          ;f030  Sector translation for skewing

lf033h:
;SoftBox-specific entry points
;
    jp listen           ;f033  Send LISTEN to an IEEE-488 device
    jp unlisten         ;f036  Send UNLISTEN to all IEEE-488 devices
    jp talk             ;f039  Send TALK to an IEEE-488 device
    jp untalk           ;f03c  Send UNTALK to all IEEE-488 devices
    jp rdieee           ;f03f  Read byte from an IEEE-488 device
    jp wrieee           ;f042  Send byte to an IEEE-488 device
    jp wreoi            ;f045  Send byte to IEEE-488 device with EOI asserted
    jp creoi            ;f048  Send carriage return to IEEE-488 dev with EOI
    jp ieeemsg          ;f04b  Send string to the current IEEE-488 device
    jp ieeenum          ;f04e  Send number as decimal string to IEEE-488 dev
    jp tstdrv           ;f051  Get drive type for a CP/M drive number
    jp dskdev           ;f054  Get device address for a CP/M drive number
    jp diskcmd          ;f057  Open the command channel on IEEE-488 device
    jp disksta          ;f05a  Read the error channel of an IEEE-488 device
    jp open             ;f05d  Open a file on an IEEE-488 device
    jp close            ;f060  Close an open file on an IEEE-488 device
    jp clear            ;f063  Clear the CBM screen
    jp execute          ;f066  Execute a subroutine in CBM memory
    jp poke             ;f069  Transfer bytes from the SoftBox to CBM memory
    jp peek             ;f06c  Transfer bytes from CBM memory to the SoftBox
    jp settime          ;f06f  Set the time on the CBM real time clock
    jp gettime          ;f072  Read the CBM clocks (both RTC and jiffies)
    jp runcpm           ;f075  Perform system init and then run CP/M
    jp idrive           ;f078  Initialize an IEEE-488 disk drive
    jp wratn            ;f07b  Send byte to IEEE-488 device with ATN asserted
    jp rdimm            ;f07e  Read byte from IEEE-488 device with timeout
    jp resclk           ;f081  Reset the CBM jiffy clock (not RTC)
    jp delay            ;f084  Programmable millisecond delay

signon:
    db cr,lf,"60K SoftBox CP/M vers. 2.2"
    db cr,lf,"(c) 1982 Keith Frewin"
    db cr,lf,"Revision 09-June-1983"
    db 00h

wboot:
;Warm start
;
    ld sp,0100h         ;Initialize stack pointer
    xor a               ;A = CP/M drive number 0 (A:)
    call tstdrv_corv    ;Is it a Corvus hard drive?
    jr c,wboot_corvus   ;  Yes: jump to warm boot from Corvus

wboot_ieee:             ;Reload the system from an IEEE-488 drive:
    xor a               ;  A = CP/M drive number 0 (A:)
    call dskdev         ;  D = its IEEE-488 primary address
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
    call idrive         ;    Initialize disk drive
    jr wboot            ;    Jump to do warm start over again

corv_load_cpm:
;Load the CP/M system from a Corvus hard drive.
;
;B = number of 128-byte sectors to load
;
;Returns an error code in A (0=OK)
;
    ld hl,ccp_base      ;HL = base address of CP/M system
    ld c,00h            ;C = CP/M drive number 0 (A:)
    push hl
    push bc

    ld hl,0000h         ;HL = 0
    ld (track),hl       ;Track = 0

    xor a               ;A = 0
    ld (sector),a       ;Sector = 0
    ld (sec_cnt),a      ;sec_cnt = 0
    ld (wrt_pend),a     ;No write pending for CBM DOS

    call seldsk         ;Select CP/M drive number 0 (A:)
    ld a,0ffh
    ld (x_drive),a      ;TODO x_drive?

    pop bc
    pop hl

corv_load_loop:
    ld (dma),hl         ;Set DMA buffer address to HL.  Instead of the usual
                        ;  DMA buffer, data from the next sector read will
                        ;  be loaded into the CP/M system area.
    push hl
    push bc
    call read           ;Read a 128-byte sector into the CP/M system area
                        ;A = error code (0=OK)

    ld hl,sector        ;HL = address that stores the current sector
    inc (hl)            ;Increment to the next sector
    pop bc
    pop hl

    or a                ;Set flags from error code
    ret nz              ;Return if not OK

    ld de,0080h         ;DE = 128 bytes were read
    add hl,de           ;Advance HL pointer: HL = HL + 128

    djnz corv_load_loop ;Decrement B, loop until all sectors are read
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
    and 0fh             ;Mask off user nibble leaving A = current disk

    call tstdrv         ;Drive number valid?
    jr c,ccp1           ;  Yes: keep it
    ld (hl),00h         ;   No: reset drive number to 0 (A:)

ccp1:
    ld c,(hl)           ;C = pass current drive number to CCP
    xor a               ;A=0
    ld (sec_cnt),a      ;sec_cnt=0
    ld (wrt_pend),a     ;No write pending for CBM DOS
    dec a               ;A=0ffh
    ld (x_drive),a
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
;Called with DE=0 or 0FFFFh:
;  If bit 0 of E is 0, the disk will be logged in as new.
;  If bit 0 of E is 1, the disk has already been logged in.
;
;Returns the address of a DPH (Disk Parameter Header) in HL.  If the
;disk could not be selected, HL = 0.
;
                        ;Check if requested drive is valid:
    ld a,c              ;  A = requested drive number
    call tstdrv         ;  Check if drive number is valid
    ld hl,0000h         ;  HL = error code
    ret nc              ;  Return if drive is invalid

                        ;Calculate pointer to a Disk Parameter Header (DPH):
    ld (drive),a        ;  Save requested CP/M drive number
    ld l,a              ;  HL = A * 8
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,dph_base
    add hl,de           ;  HL = dph_base + HL
    push hl

                        ;Calculate pointer to a Disk Parameter Block (DPB):
    ld l,c              ;  C = requested drive number
    ld h,00h            ;  HL = C * 8
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,dpb_base
    add hl,bc           ;  HL = dpb_base + HL

                        ;Load both pointers:
    ex de,hl            ;  DE = pointer to a DPB
    pop hl              ;  HL = pointer to a DPH
    push hl
                        ;Install pointer to the DPB in the DPH:
    ld bc,000ah         ;
    add hl,bc           ;  DPH + 0ah = E (DPB low byte)
    ld (hl),e
    inc hl              ;  DPH + 0bh = D (DPB high byte)
    ld (hl),d

                        ;Special handling if requested drive is a Corvus:
    ld a,(drive)        ;  A = CP/M drive number
    call tstdrv_corv    ;  Is it a Corvus hard drive?
    call c,corv_init    ;    Yes: initialize the Corvus controller

    pop hl              ;HL = address of the DPH
    ret

dpb_base:
;Disk Parameter Block (DPB) tables.  One DPB for each drive type:
;

dpb_0_cbm_3040:
;Commodore 2040/3040/4040 floppy drive
;
    dw 0020h            ;SPT  Number of 128-byte records per track
    db 04h              ;BSH  Block shift
    db 0fh              ;BLM  Block mask
    db 01h              ;EXM  Extent mask
    dw 004ch            ;DSM  Number of blocks on disk - 1
    dw 003fh            ;DRM  Number of directory entries - 1
    db 80h              ;AL0  Directory allocation bitmap, first byte
    db 00h              ;AL1  Directory allocation bitmap, second byte
    dw 0010h            ;CKS  Checksum vector size
    dw 0000h            ;OFF  Offset: number of reserved tracks
    db 00h              ;     Unused

dpb_1_cbm_8050:
;Commodore 8050 floppy drive
;
    dw 0020h            ;SPT  Number of 128-byte records per track
    db 04h              ;BSH  Block shift
    db 0fh              ;BLM  Block mask
    db 01h              ;EXM  Extent mask
    dw 00f8h            ;DSM  Number of blocks on disk - 1
    dw 003fh            ;DRM  Number of directory entries - 1
    db 80h              ;AL0  Directory allocation bitmap, first byte
    db 00h              ;AL1  Directory allocation bitmap, second byte
    dw 0010h            ;CKS  Checksum vector size
    dw 0000h            ;OFF  Offset: number of reserved tracks
    db 00h              ;     Unused

dpb_2_corvus_10mb:
;Corvus 10MB hard drive
;
    dw 0040h            ;SPT  Number of 128-byte records per track
    db 06h              ;BSH  Block shift
    db 3fh              ;BLM  Block mask
    db 03h              ;EXM  Extent mask
    dw 024ch            ;DSM  Number of blocks on disk - 1
    dw 00ffh            ;DRM  Number of directory entries - 1
    db 80h              ;AL0  Directory allocation bitmap, first byte
    db 00h              ;AL1  Directory allocation bitmap, second byte
    dw 0000h            ;CKS  Checksum vector size
    dw 0002h            ;OFF  Offset: number of reserved tracks
    db 00h              ;     Unused

dpb_3_corvus_20mb:
;Corvus 20MB hard drive
;
    dw 0040h            ;SPT  Number of 128-byte records per track
    db 06h              ;BSH  Block shift
    db 3fh              ;BLM  Block mask
    db 03h              ;EXM  Extent mask
    dw 024ch            ;DSM  Number of blocks on disk - 1
    dw 00ffh            ;DRM  Number of directory entries - 1
    db 80h              ;AL0  Directory allocation bitmap, first byte
    db 00h              ;AL1  Directory allocation bitmap, second byte
    dw 0000h            ;CKS  Checksum vector size
    dw 0002h            ;OFF  Offset: number of reserved tracks
    db 00h              ;     Unused

dpb_4_corvus_5mb_1:
;Corvus 5MB hard drive (as 1 CP/M drive)
;
    dw 0040h            ;SPT  Number of 128-byte records per track
    db 06h              ;BSH  Block shift
    db 3fh              ;BLM  Block mask
    db 03h              ;EXM  Extent mask
    dw 02b8h            ;DSM  Number of blocks on disk - 1
    dw 00ffh            ;DRM  Number of directory entries - 1
    db 80h              ;AL0  Directory allocation bitmap, first byte
    db 00h              ;AL1  Directory allocation bitmap, second byte
    dw 0000h            ;CKS  Checksum vector size
    dw 0002h            ;OFF  Offset: number of reserved tracks
    db 00h              ;     Unused

dbp_5_corvus_5mb_2:
;Corvus 5MB hard drive (as 2 CP/M drives)
;
    dw 0040h            ;SPT  Number of 128-byte records per track
    db 06h              ;BSH  Block shift
    db 3fh              ;BLM  Block mask
    db 03h              ;EXM  Extent mask
    dw 0159h            ;DSM  Number of blocks on disk - 1
    dw 00ffh            ;DRM  Number of directory entries - 1
    db 80h              ;AL0  Directory allocation bitmap, first byte
    db 00h              ;AL1  Directory allocation bitmap, second byte
    dw 0000h            ;CKS  Checksum vector size
    dw 0002h            ;OFF  Offset: number of reserved tracks
    db 00h              ;     Unused

dbp_6_cbm_8250:
;Commodore 8250 floppy drive
;
    dw 0020h            ;SPT  Number of 128-byte records per track
    db 05h              ;BSH  Block shift
    db 1fh              ;BLM  Block mask
    db 03h              ;EXM  Extent mask
    dw 00fch            ;DSM  Number of blocks on disk - 1
    dw 007fh            ;DRM  Number of directory entries - 1
    db 80h              ;AL0  Directory allocation bitmap, first byte
    db 00h              ;AL1  Directory allocation bitmap, second byte
    dw 0020h            ;CKS  Checksum vector size
    dw 0000h            ;OFF  Offset: number of reserved tracks
    db 00h              ;     Unused

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

tstdrv:
;Get the drive type for a CP/M drive number from the dtypes table
;
;A = CP/M drive number
;
;Returns drive type in C.  Preserves drive number in A.
;
;Sets carry flag is drive is valid, clears it otherwise.
;
    cp 10h              ;Valid drives are 0 (A:) through 0Fh (P:)
    ret nc              ;Return with carry clear if drive is greater than P:

    push hl             ;Save original HL
    push af             ;Save A (CP/M drive number)

                        ;Find index of this drive in the dtypes table:
    or a                ;  Clear carry flag
    rra                 ;  A = index into dtypes table for this drive
                        ;      Dividing the CP/M drive number by 2 finds its
                        ;      index in the ddevs or dtypes tables.  There
                        ;      are 16 possible CP/M drives, which the SoftBox
                        ;      maps to 8 units (each unit may provide up to
                        ;      2 drives).  Bit 0 of the CP/M drive number
                        ;      indicates which drive in the unit's pair.

                        ;Calculate address of drive in dtypes table:
    ld c,a              ;  C = index of this drive in dtypes table
    ld b,00h            ;  B = 0
    ld hl,dtypes        ;  HL = address of dtypes table
    add hl,bc           ;  HL = HL + BC (address of this drive in dtypes)

                        ;Load drive type into C:
    ld c,(hl)           ;  C = drive type
    ld a,c              ;  A = C

    cp 04h              ;Drive type 4?
                        ;  (4 = Corvus 5MB as 1 CP/M drive)

                        ;Load drive number back into A:
    pop hl              ;  H = CP/M drive number
    ld a,h              ;  A = H

    jr nz,tst1          ;If drive type is not 4:
                        ;  Jump over check specific to type 4

                        ;If drive type is 4:
    bit 0,a             ;  Z flag = opposite of bit 0 in drive number
                        ;  For drive type 4 (Corvus 5MB as 1 CP/M drive),
                        ;    only the first drive in each pair is valid.
    jr tst2             ;  Jump over drive type check

tst1:                   ;If drive type is not 4:
    bit 7,c             ;  Z flag = opposite of bit 7 of drive type
                        ;  If bit 7 of the drive type is set, it indicates
                        ;    no drive is installed.

tst2:
    pop hl              ;Recall original HL

                        ;If Z flag is clear:
    scf                 ;  Set carry flag to indicate drive is valid
    ret z               ;  and return

                        ;If Z flag is set:
    or a                ;  Clear carry flag to indicate drive is not valid
    ret                 ;  and return

tstdrv_corv:
;Get the drive type for a CP/M drive number from the dtypes table
;and check if it is a Corvus hard drive.
;
;A = CP/M drive number
;
;Returns the drive type in C and A.
;
;Sets the carry flag if the CP/M drive number is valid and if
;it corresponds to a Corvus hard drive.  Clears it otherwise.
;
    call tstdrv         ;C = drive type
    ret nc              ;Return with no carry if drive number is invalid

    ld a,c              ;A = drive type
    or a
                        ;Corvus drive types are: 2, 3, 4, 5
                        ;Return with carry set if the drive type is one
                        ;of those, otherwise return with carry clear:
                        ;
                        ;  Check if drive type is >= 6:
    cp 06h              ;    Set carry if A < 6, clear carry if A >= 6
    ret nc              ;    Return if no carry
                        ;
                        ;  Check if drive type is < 2:
    cp 02h              ;    Set carry if A < 2, clear carry if A >= 2
    ccf                 ;    Invert the carry flag
    ret

read:
;Read the currently set track and sector at the current DMA address.
;Returns A=0 for OK, 1 for unrecoverable error, 0FFh if media changed.
;
    ld a,(drive)        ;A = CP/M drive number
    call tstdrv_corv    ;Is it a Corvus hard drive?
    jp c,corv_read_sec  ;  Yes: jump to Corvus read sector

    call sub_rw

    ld a,01h            ;Flag: if a CBM DOS error 22 occurs, retry it.
    call nz,ieee_read_sec
    ld a,(sector)
    rrca
    call copy_to_dma
    xor a               ;A=0
    ld (sec_cnt),a      ;sec_cnt=0
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
    ld a,(drive)        ;A = CP/M drive number
    call tstdrv_corv    ;Is it a Corvus hard drive?
    pop bc
    jp c,corv_writ_sec  ;  Yes: jump to Corvus write sector

    ld a,c              ;A = deblocking code in C
    push af             ;Save it on the stack

    cp 02h              ;Deblocking code = 2?
    call z,deblock_2    ;  Yes: call deblock_2, which sets sec_cnt nonzero,
                        ;         sets y_drive/y_track/y_sector to be
                        ;         drive/track/sector, then returns here.

                        ;Compare sector countdown value to zero:
    ld hl,sec_cnt       ;  HL = address of sector countdown
    ld a,(hl)           ;  A = value of sector countdown
    or a
    jr z,wr1            ;  Jump if A=0

    dec (hl)            ;Decrement sector countdown

                        ;Compare CP/M drive number:
    ld a,(drive)        ;  A = CP/M drive number
    ld hl,y_drive       ;  HL = address of y_drive
    cp (hl)
    jr nz,wr1           ;  Jump if drive != y_drive

                        ;Compare CP/M track number (low byte):
    ld a,(track)        ;  A = CP/M track number (low)
    ld hl,y_track       ;  HL = address of y_track
    cp (hl)
    jr nz,wr1           ;  Jump if track != y_track

                        ;Compare CP/M track number (high byte):
    ld a,(track+1)      ;  A = CP/M track number (high)
    inc hl              ;  HL = address of y_track+1
    cp (hl)
    jr nz,wr1           ;  Jump if track+1 != y_track+1

                        ;Compare CP/M sector number:
    ld a,(sector)       ;  A = CP/M sector number
    ld hl,y_sector      ;  HL = address of y_sector
    cp (hl)
    jr nz,wr1           ;  Jump if sector != y_sector

    inc (hl)            ;Increment y_sector

    call sub_rw
    jr wr2

wr1:
;Entered if (sec_cnt)=0 or if drive/track/sector != y_drive/y_track/y_sector
;
    xor a               ;A=0
    ld (sec_cnt),a      ;sec_cnt=0
    call sub_rw
    ld a,00h            ;Flag: if a CBM DOS error 22 occurs, ignore it.
    call nz,ieee_read_sec
                           ;Fall through into wr2

wr2:
;Entered if (sec_cnt)>0 or if drive/track/sector = y_drive/y_track/y_sector
;
    ld a,(sector)       ;A = CP/M sector number
    rrca                ;Rotate bit 0 of CP/M sector into the carry flag
                        ;  The carry flag selects which half of the 256-byte
                        ;  CBM DOS buffer will receive the contents of
                        ;  the 128-byte CP/M DMA buffer
    call copy_from_dma  ;Copy from CP/M DMA buffer into CBM DOS buffer
                        ;  (dma_buf -> dos_buf)

    pop af              ;A = deblocking code
    dec a               ;Decrement deblocking code to test it
    jr nz,wr3           ;Jump if deblocking code was 0 or 2
                        ;  (write can be deferred)

                        ;Write must be immediate

    ld a,(dos_err)      ;A = last error code from CBM DOS (0=OK)
    or a
    call z,ieee_writ_sec  ;Write the CBM DOS sector if OK

    xor a               ;Return A=0 (OK)
    ret

wr3:
;Entered if write can be deferred
;
    ld a,01h
    ld (wrt_pend),a     ;Set flag to indicate a write is pending for CBM DOS

    xor a               ;Return with A=0 (OK)
    ret

ieee_read_sec:
;Read a sector from CBM DOS into the dos_buf buffer.
;
;A = flag for how to handle a CBM DOS read error 22 (no data block)
;       If A=0, error 22 will be ignored.
;       If A=1, error 22 will be handled like any other error.
;
    ld hl,dos_buf       ;HL = address of CBM DOS buffer area
    ex af,af'           ;Save A in A' to be used in ieee_u1_or_u2
    jp ieee_read_sec_hl ;Read a CBM sector into buffer at HL

ieee_writ_sec:
;Write a sector from the dos_buf out to CBM DOS.
;
    ld hl,dos_buf       ;HL = address of CBM DOS buffer area
    jp ieee_writ_sec_hl ;Read a CBM sector into buffer at HL

copy_to_dma:
;Copy from dos_buf to dma_buf
;
    ld a,00h            ;A=0: dos_buf -> dma_buf
    jr copy_dos_dma

copy_from_dma:
;Copy from dma_buf to dos_buf
;
    ld a,01h            ;A=1: dma_buf -> dos_buf
                        ;Fall through into copy_dos_dma

copy_dos_dma:
;Copy a 128-byte CP/M sector between the CBM DOS buffer (dos_buf)
;and the CP/M DMA buffer (dma_buf).
;
;A selects direction of copy:
;  A=0: dos_buf -> dma_buf
;  A=1: dma_buf -> dos_buf
;
;Carry flag selects which half of the 256-byte CBM DOS buffer:
;  Carry clear: first half
;  Carry set:   second half
;
    ld hl,dos_buf       ;HL = pointer to CBM DOS buffer
    ld de,(dma)         ;DE = pointer to DMA buffer
    ld bc,0080h         ;BC = 128 bytes to copy

    jr nc,cp1           ;If carry is clear, jump to keep HL pointing
                        ;  at the first half of the CBM DOS buffer

    add hl,bc           ;If carry is set, add 0080h to HL to point
                        ;  at the second half of the CBM DOS buffer
cp1:
    or a
    jr z,cp2            ;If A = 0, keep HL and DE so that the copy
                        ;  direction is CBM DOS buffer -> DMA buffer

    ex de,hl            ;If A != 0, exchange HL and DE so that the copy
                        ;  direction is DMA buffer -> CBM DOS buffer
cp2:
    ldir                ;Copy BC bytes from (HL) to (DE)
    ret

corv_init:
;Initialize the Corvus hard drive controller
;
    ld a,0ffh           ;0ffh = byte that is an invalid command
    out (corvus),a      ;Send it to the controller

    ld b,0ffh
cinit1:
    djnz cinit1         ;Delay loop

    in a,(ppi2_pc)
    and dirc
    jr nz,corv_init     ;Loop until Corvus DIRC=low
    call corv_wait_read ;Wait until Corvus READY=high, then read byte

    cp 8fh              ;Response should be 8fh (Illegal Command)
    jr nz,corv_init     ;Loop until the expected response is received
    ret

corv_read_sec:
;Read a sector from a Corvus hard drive into the DMA buffer.
;
;Returns error code in A: 0=OK, 0ffh=Error.
;
    call corv_find_dadr ;A,H,L = Corvus DADR ("Disk Address")

    push af
    ld a,12h            ;12h = Read sector (128 bytes)
    call corv_put_byte  ;Send command byte
    pop af

    call corv_put_byte  ;Send A (DADR byte 0)
    ld a,l
    call corv_put_byte  ;Send L (DADR byte 1)
    ld a,h
    call corv_put_byte  ;Send H (DADR byte 2)

    ld hl,(dma)         ;HL = start address of DMA buffer area

    call corv_read_err  ;A = Corvus error code
    jr nz,corv_ret_err  ;Jump if error code is not OK

    ld b,80h            ;B = 128 bytes to read
crds1:
    in a,(ppi2_pc)
    and ready
    jr z,crds1          ;Wait until Corvus READY=high
    in a,(corvus)       ;Read data byte from Corvus
    ld (hl),a           ;Store it in the buffer
    inc hl              ;Increment to next position in DMA buffer
    djnz crds1          ;Decrement B, loop until all bytes read

corv_ret_ok:
;Return to the caller with A=0 (OK status) indicating
;that the last Corvus operation succeeded.
;
    xor a               ;A=0 (OK)
    ret

corv_writ_sec:
;Write a sector from the DMA buffer to a Corvus hard drive.
;
;Returns error code in A: 0=OK, 0ffh=Error.
;
    call corv_find_dadr ;A,H,L = Corvus DADR ("Disk Address")

    push af
    ld a,13h            ;13h = Write sector (128 bytes)
    call corv_put_byte  ;Send command byte
    pop af

    call corv_put_byte  ;Send A (DADR byte 0)
    ld a,l
    call corv_put_byte  ;Send L (DADR byte 1)
    ld a,h
    call corv_put_byte  ;Send H (DADR byte 2)

    ld b,80h            ;B = 128 bytes to write
    ld hl,(dma)         ;HL = start address of DMA buffer area
cwrs1:
    in a,(ppi2_pc)
    and ready           ;Mask off all but bit 4 (Corvus READY)
    jr z,cwrs1          ;Wait until Corvus READY=high
    ld a,(hl)           ;Read data byte from DMA buffer
    out (corvus),a      ;Send it to the Corvus
    inc hl              ;Increment to next position in DMA buffer
    djnz cwrs1          ;Decrement B, loop until all bytes written

    call corv_read_err  ;A = Corvus error
    jr z,corv_ret_ok    ;Jump if error code is OK

corv_ret_err:
;Return to the caller with A=0FFh (error status) indicating
;that the last Corvus operation failed.
;
    ld hl,corv_fault    ;HL = address of "*** HARD DISK ERROR" string
    push af
    call puts           ;Write fault message to console out
    pop af
    call put_hex_byte   ;Write Corvus error code to console out
    and 0ffh            ;A=0FFh (Error)
    ret

corv_read_err:
;Read the error code from a Corvus hard drive.
;
;Returns the error code in A (0=OK) and also changes
;the Z flag: Z=1 if OK, Z=0 if error.
;
;The upper 3 bits of the error code are flags:
;
;  Bit 7: Set if any fatal error has occurred.  Most utility programs
;         from Corvus will not show the error unless bit 7 is set.
;
;  Bit 6: Set if an error occurred on a re-read (verification)
;         following a disk write.
;
;  Bit 5: Set if there was a recoverable error (as in a retry
;         of a read or write).
;
;The lower 5 bits of the error code are reserved for the code itself
;but only the lower 4 bits are actually used:
;
;  00 Disk Header Fault         10 Drive Not Acknowledged
;  01 Seek Timeout              11 Acknowledge Stuck Active
;  02 Seek Fault                12 Timeout
;  03 Seek Error                13 Fault
;  04 Header CRC Error          14 CRC
;  05 Re-zero (Head) Fault      15 Seek
;  06 Re-zero Timeout           16 Verification
;  07 Drive Not On Line         17 Drive Speed Error
;  08 Write Fault               18 Drive Illegal Address Error
;  09 (Unused)                  19 Drive R/W Fault Error
;  0A Read Data Fault           1A Drive Servo Error
;  0B Data CRC Error            1B Drive Guard Band
;  0C Sector Locate Error       1C Drive PLO (Phase Lockout) Error
;  0D Write Protected           1D Drive R/W Unsafe
;  0E Illegal Sector Address    1E (Unused)
;  0F Illegal Command           1F (Unused)
;
    in a,(ppi2_pc)
    xor ready           ;Flip bit 4 (Corvus READY)
    and ready+dirc      ;Mask off all except bits 4 (READY) and 5 (DIRC)
    jr nz,corv_read_err

    ld b,19h
crde1:
    djnz crde1          ;Delay loop

    in a,(ppi2_pc)
    xor ready           ;Flip bit 4 (Corvus READY)
    and ready+dirc      ;Mask off all except bits 4 (READY) and 5 (DIRC)
    jr nz,corv_read_err
                        ;Fall through into corv_wait_read

corv_wait_read:
;Wait until Corvus READY=high, then read a data byte from the Corvus.
;
;Returns the data byte in A and sets the Z flag: Z=1 if OK, Z=0 if error.
;
    in a,(ppi2_pc)
    and ready           ;Mask off all but bit 4 (Corvus READY)
    jr z,corv_wait_read ;Wait until Corvus READY=high
    in a,(corvus)
    bit 7,a             ;Bit 7 of Corvus error byte is set if fatal error
                        ;Z = opposite of bit 7 (Z=1 if OK, Z=0 if error)
    ret

corv_put_byte:
;Send a byte to the Corvus hard drive.  Waits until the Corvus
;is ready to accept the byte, sends it, then returns immediately.
;
;A = byte to send
;
    push af
corpb1:
    in a,(ppi2_pc)
    and ready           ;Mask off all except bit 4 (Corvus READY)
    jr z,corpb1         ;Wait until Corvus READY=high
    pop af
    out (corvus),a      ;Put byte on Corvus data bus
    ret

corv_find_dadr:
;Find the Corvus DADR ("Disk Address") for the current
;CP/M drive, track and sector.
;
;Sectors on Corvus hard drives are not addressed by physical track
;and sector.  Instead, they are addressed as a single large
;logical sector space.
;
;The DADR is 3 bytes (24 bits), consisting of a 4-bit Corvus unit ID
;and a 20-bit logical sector address.
;
;Returns:
;  A = DADR byte 0 "D"
;        Upper nibble: Bits 16-19 of the logical sector address
;        Lower nibble: Corvus unit ID (1 to 15)
;
;  L = DADR byte 1 "LSB"
;        Bits 0-7 of the logical sector address
;
;  H = DADR byte 2 "MSB"
;        Bits 8-15 of the logical sector address
;
    ld hl,(track)       ;HL = CP/M current track

    ld a,00h
    ld b,06h
dadr1:
    add hl,hl
    rla
    djnz dadr1          ;Decrement B, loop until B=0

    push af
    ld a,(sector)       ;A = CP/M current sector
    or l
    ld l,a

                        ;Find offset for second half of drive:
    ld de,941ch         ;  DE = logical sector offset for the second half
                        ;       of a Corvus hard drive
                        ;
    ld a,(drive)        ;  A = CP/M drive number
    call tstdrv         ;  C = its drive type
    ld a,c              ;  A = C
                        ;
    cp 05h              ;  Drive type = 5 (Corvus 5MB as 2 CP/M drives)?
    jr nz,dadr2         ;    No:  Keep current second half offset
    ld de,577ah         ;    Yes: Change to smaller second half offset

dadr2:                  ;Select offset for first or second drive half:
    ld a,(drive)        ;  A = CP/M drive number
    and 01h             ;  Is it the first drive in drive pair (e.g. A:/B:)?
    jr nz,dadr3         ;    No:  jump to keep offset for second half
    ld de,005ch         ;    Yes: change to offset for first half

dadr3:
    pop af

    add hl,de
    adc a,00h

                        ;Set upper nibble of A to high bits of Corvus sector:
    add a,a             ;
    add a,a             ;  Multiply by 16 to shift the
    add a,a             ;    lower nibble into the upper nibble
    add a,a             ;

                        ;Set lower nibble of A to the Corvus unit ID:
    push hl             ;
    push af             ;
    ld a,(drive)        ;  A = CP/M drive number
    call dskdev         ;  D = its Corvus unit ID
    pop af              ;
    pop hl              ;
    add a,d             ;  A lower nibble = Corvus unit ID
    ret

corv_fault:
    db cr,lf,bell,"*** HARD DISK ERROR ***  ",00h

put_hex_byte:
;Write the byte in A to console out as a two digit hex number.
;
    push af             ;Preserve A
    rra                 ;Rotate high nibble into low
    rra
    rra
    rra
    call put_hex_nib    ;Write it to console out
    pop af              ;Recall A for the low nibble
                        ;Fall through to write it to console out

put_hex_nib:
;Write the low nibble in A to console out as a one digit hex number.
;
    and 0fh             ;Mask off high nibble
    cp 0ah              ;Convert low nibble to ASCII char
    jr c,nib1
    add a,07h
nib1:
    add a,30h
    ld c,a
    jp conout           ;Write char to console out and return.

boot:
;Cold start
;
    ld sp,0100h         ;Initialize stack pointer

    ld a,10011001b      ;Set PPI #1 control
                        ;  Bit 7: IO   1 = I/O mode (not BSR)
                        ;  Bit 6: GA1  0 = Group A as Mode 1 (Simple I/O)
                        ;  Bit 5: GA0  0
                        ;  Bit 4: PA   1 = Group A, Port A as Input
                        ;  Bit 3: PCu  1 = Group A, Port C upper as Input
                        ;  Bit 2: GB   0 = Group B as Mode 1 (Simple I/O)
                        ;  Bit 1: PB   0 = Group B, Port B as Output
                        ;  Bit 0: PCl  1 = Group B, Port C lower as Input
    out (ppi1_cr),a

    ld a,10011000b      ;Set PPI #2 control
                        ;  Bit 7: IO   1 = I/O mode (not BSR)
                        ;  Bit 6: GA1  0 = Group A as Mode 1 (Simple I/O)
                        ;  Bit 5: GA0  0
                        ;  Bit 4: PA   1 = Group A, Port A as Input
                        ;  Bit 3: PCu  1 = Group A, Port C upper as Input
                        ;  Bit 2: GB   0 = Group B as Mode 1 (Simple I/O)
                        ;  Bit 1: PB   0 = Group B, Port B as Output
                        ;  Bit 0: PCl  0 = Group B, Port C lower as Output
    out (ppi2_cr),a

    xor a               ;A=0
    out (ppi1_pb),a     ;Clear IEEE data out
    out (ppi2_pb),a     ;Clear IEEE control out

    ld c,02h            ;C = 2 blinks for RAM failure
    ld hl,0000h         ;RAM start address
    ld de,lf000h        ;RAM end address + 1
boot1:
    ld (hl),l
    inc hl
    ld a,h
    and 0fh
    or l
    jr nz,boot2

    in a,(ppi2_pc)
    xor ledrdy
    out (ppi2_pc),a     ;Invert "Ready" LED

boot2:
    dec de
    ld a,e
    or d
    jr nz,boot1

    ld hl,0000h         ;RAM start address
    ld de,lf000h        ;RAM end address + 1
boot3:
    ld a,(hl)
    cp l
    jr nz,test_failed
    cpl
    ld (hl),a
    inc hl
    ld a,h
    and 0fh
    or l
    jr nz,boot4

    in a,(ppi2_pc)
    xor ledrdy
    out (ppi2_pc),a     ;Invert "Ready" LED
boot4:
    dec de
    ld a,e
    or d
    jr nz,boot3

    ld hl,0000h         ;RAM start address
    ld de,lf000h        ;RAM end address + 1
boot5:
    ld a,(hl)
    cpl
    cp l
    jr nz,test_failed
    inc hl
    ld a,h
    and 0fh
    or l
    jr nz,boot6

    in a,(ppi2_pc)
    xor ledrdy
    out (ppi2_pc),a     ;Invert "Ready" LED
boot6:
    dec de
    ld a,e
    or d
    jr nz,boot5

    ld hl,lf000h        ;ROM start address
    ld bc,0ffdh         ;Number of code bytes in the ROM
    call calc_checksum  ;Calculate ROM checksum

    ld c,03h            ;C = 3 blinks for ROM failure
    ld hl,checksum      ;HL = address of checksum byte in ROM
    cp (hl)             ;Any difference from the calculated value?
    jp z,test_passed    ;  No: ROM check passed

test_failed:
;Self-test failed.  Blink the LED forever.
;
;C = Number of blinks (2=RAM failed, 3=ROM failed)
;
    ld b,c

fail1:
    xor a
    out (ppi2_pc),a     ;Invert "Ready" LED

    ld de,0ffffh
fail2:
    dec de
    ld a,e
    or d
    jr nz,fail2         ;Delay loop

    ld a,ledrdy
    out (ppi2_pc),a     ;Turn off "Ready" LED, turn on "A" and "B" LEDs

    ld de,0ffffh
fail3:
    dec de
    ld a,e
    or d
    jr nz,fail3         ;Delay loop

    djnz fail1          ;Decrement B, loop until B=0

    ld b,03h
    ld de,0ffffh
fail4:
    dec de
    ld a,e
    or d
    jr nz,fail4         ;Delay loop
    djnz fail4          ;Decrement B, loop until B=0

    jr test_failed

calc_checksum:
;Calculate the ROM checksum.
;
;HL = start address of ROM
;BC = number of bytes to process
;
;Returns the checksum in A.
;
    xor a               ;A=0
sum1:
    add a,(hl)          ;Add byte at pointer to A
    rrca
    ld d,a              ;Save A in D
    inc hl              ;Increment pointer
    dec bc              ;Decrement byte counter
    ld a,b
    or c                ;Test if byte counter is zero
    ld a,d              ;Recall A from D
    jr nz,sum1          ;Loop if more bytes remaining
    ret

test_passed:
;Self-test passed.  Continue normal startup.
;
    in a,(ppi2_pb)
    or ifc
    out (ppi2_pb),a     ;IFC_OUT=low

    xor a               ;A=0
    ld (iobyte),a       ;IOBYTE=0 (CON:=TTY:, the RS-232 port)
    ld (cdisk),a        ;CDISK=0 (User=0, Drive=A:)
    ld (0054h),a
    ld (leadrcvd),a     ;Last char received was not the lead-in
    ld (move_cnt),a     ;Not in a cursor move-to sequence
    ld (scrtab),a       ;Disable terminal character translation
    out (ppi2_pc),a     ;Turn on all LEDs

    ld bc,03e8h
    call delay          ;Wait 1 second

    ld a,esc
    ld (leadin),a       ;Terminal lead-in = escape

    xor a               ;8251 USART initialization sequence
    out (usart_st),a
    nop
    out (usart_st),a
    nop
    out (usart_st),a

    ld a,40h            ;Reset
    out (usart_st),a

    ld a,01111010b      ;Set mode
                        ;  Bit 7: S2   0 = 1 stop bit
                        ;  Bit 6: S1   1
                        ;  Bit 5: EP   1 = Even parity
                        ;  Bit 4: PEN  1
                        ;  Bit 3: L2   1 = 7 bit character
                        ;  Bit 2: L1   0
                        ;  Bit 1: B2   1 = 16X baud rate factor
                        ;  Bit 0: B1   0
    out (usart_st),a

    ld a,00110111b      ;Set command
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
                        ;   77h =  1200 baud
                        ;   55h =   300 baud
                        ;   22h =   110 baud
    out (baud_gen),a    ;Set baud rate to 9600 baud

                        ;Detect if a CBM computer is on the IEEE-488 bus:
    in a,(ppi2_pa)      ;  IEEE-488 control lines in
    cpl                 ;  Invert byte
    and ren             ;  Mask off all but bit 6 (REN in)
    jr nz,try_load_cpm  ;  Jump if REN=high (a CBM holds REN=low)

                        ;CBM computer detected.  Set console in IOBYTE:
    ld a,01h            ;
    ld (iobyte),a       ;  IOBYTE=1 (CON:=CRT:, the CBM computer)

wait_for_atn:
;Wait until the CBM computer addresses the SoftBox.  The SoftBox
;must stay off the bus until a program on the CBM side wakes it up
;by sending attention to its address (57).  At that point, the CBM
;must start waiting for SRQs and the SoftBox can take over the bus.
;
    in a,(ppi2_pa)
    cpl
    and atn+dav
    in a,(ppi1_pa)
    jr nz,wait_for_atn  ;Wait until ATN_IN=low and DAV_IN=low

    cp 39h
    jr nz,wait_for_atn  ;Wait until data byte = 57 (SoftBox address)

    in a,(ppi2_pa)
    cpl
    and dav
    jr nz,wait_for_atn  ;Wait until DAV_IN=low

atn1:
    in a,(ppi2_pa)
    cpl
    and dav
    jr z,atn1           ;Wait until DAV_IN=high

try_load_cpm:
;Try to load the CP/M system and then run it.
;
;If an IEEE-488 drive responds on primary address 8, try to load
;CP/M from it.  If the drive is not present, try to load from
;a Corvus hard drive on ID 1.
;
;Loops forever until CP/M is successfully loaded, then
;jumps to run CP/M.
;
    ld hl,loading
    call puts           ;Write "Loading CP/M ..." to console out

    ld de,080fh         ;D = IEEE-488 primary address 8
                        ;E = IEEE-488 secondary address 15
    call listen         ;Send LISTEN

    ld bc,0007h         ;Wait 7 ms to allow IEEE-488 device 8
    call delay          ;  time to respond to LISTEN

    in a,(ppi2_pa)
    cpl
    and ndac            ;If NDAC_IN=low, it means device 8 is present.
    jr z,try_load_ieee  ;  Jump to load CP/M from it.

try_load_corvus:
    ld a,02h            ;Load CP/M from Corvus hard drive:
    ld (dtypes),a       ;  Drive A: type = 2 (Corvus 10MB)
    ld a,01h
    ld (ddevs),a        ;  Drive A: address = 1 (Corvus ID 1)
    ld b,38h            ;  B = 56 sectors to load: D400-EFFF
    call corv_load_cpm  ;  Load CP/M from Corvus drive (A = Corvus error)
    jr runcpm           ;Jump to run CP/M

try_load_ieee:
    call unlisten       ;Send UNLISTEN.  Device 8 should still be
                        ;  listening from when we tested it above.

    ld de,080fh         ;D = IEEE-488 primary address 8
                        ;E = IEEE-488 secondary address 15
    ld c,02h            ;2 bytes in string
    ld hl,dos_i0_0      ;"I0"
    call open

    ld d,08h            ;D = IEEE-488 primary address 8
    ld c,1ch            ;C = 28 pages to load: D400-EFFF
    call ieee_load_cpm  ;Load CP/M from image file (A = CBM DOS error)
    jp nz,try_load_cpm

    ld de,0802h         ;D = IEEE-488 primary address 8
                        ;E = IEEE-488 secondary address 2
    ld c,02h            ;2 bytes in string
    ld hl,dos_num2      ;"#2"
    call open           ;Open the channel
                        ;Fall through to run CP/M

runcpm:
;Perform system init and then run CP/M
;
;Initializes data at 0eb00h (DPH), initialize USART, displays
;the SoftBox signon, then jumps to start the CCP.
;
    ld sp,0100h         ;Initialize stack pointer
    xor a
    push af
    ld ix,dph_base      ;IX = destination address to write to (?)
    ld hl,0ec00h        ;HL = source address to read from (?)
    ld de,dtypes        ;DE = pointer to drive types

run1:
    ld a,(de)           ;A = drive type
    or a
    jp m,run3           ;Jump if bit 7 is set (indicates no device)

    cp 02h              ;02h = Corvus 10MB
    ld bc,004ah
    jr z,run2

    cp 03h              ;03h = Corvus 20MB
    jr z,run2

    cp 04h              ;04h = Corvus 5MB (as 1 CP/M drive)
    ld bc,0058h
    jr z,run2

    push af
    ld a,10h
    ld (0058h),a
    pop af
    cp 06h              ;06h = CBM 8250
    jp nz,run5

    ld a,20h
    ld (0058h),a        ;Store 20h in 0058h for CBM 8250 only
                        ;  TODO: see note about 0058h in deblock_2

run5:
;Build the DPH for the current drive
;
    ld (ix+0ch),l       ;CSV: address of the directory checksum vector
    ld (ix+0dh),h       ;     for this drive

    ld a,(0058h)
    ld b,00h
    ld c,a
    add hl,bc

    rla
    ld c,a

run2:
    ld (ix+0eh),l       ;ALV: address of the allocation vector
    ld (ix+0fh),h       ;     for this drive

    add hl,bc

    ld (ix+08h),80h     ;DIRBUF: address of 128-byte directory buffer
    ld (ix+09h),0eeh    ;        shared for all drives

    ld (ix+00h),00h     ;XLT: address of sector translation table
    ld (ix+01h),00h     ;     (address of zero indicates no translation)

run3:
;Increment to the next drive
;
    ld bc,0010h
    add ix,bc           ;IX = IX + 10h

    pop af
    inc a
    push af
    or a
    rra
    jr c,run1

    inc de
    cp 08h              ;Last drive?
    jr nz,run1          ;  No: continue until all 8 are done
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

    call clear          ;Clear CBM screen (no-op if console is RS-232)

    ld a,(iobyte)
    rra
    jr nc,run4          ;Jump if console is CBM Computer (CON: = CRT:)

    ld a,(termtype)     ;Get terminal type
    rla                 ;Rotate uppercase graphics flag into carry
    jr nc,run4          ;Jump if lowercase mode

    ld c,ucase          ;Go to uppercase mode
    call conout

run4:
    ld hl,signon
    call puts           ;Write "60K SoftBox CP/M" signon to console out

    call const          ;Check if a key is waiting (0=key, 0ffh=no key)
    inc a
    call z,conin        ;Get a key if one is waiting

    ld hl,ccp_base      ;HL = address that starts CCP with initial command
    jp start_ccp        ;Start CCP via HL

loading:
    db cr,lf,"Loading CP/M ...",0

ieee_load_cpm:
;Load the CP/M system from an IEEE-488 disk drive.
;
;The CP/M image is a CBM DOS program file called "CP/M" on the SoftBox
;boot disk.  The file is 7168 bytes total.  During cold start, the entire
;file is loaded into memory from D400-EFFF (28 pages).  During warm start,
;only D400-E9FF (22 pages) is reloaded from the file.
;
;D = IEEE-488 primary address of CBM disk drive
;C = number of 256-byte pages to load from the image file
;
;Returns the CBM DOS error code in A (0=OK)
;
    push bc
    push de
    ld hl,filename      ;HL = pointer to "0:CP/M" string
    ld c,06h            ;C = 6 bytes in string
    ld e,00h            ;E = IEEE-488 secondary address 0
    call open           ;Send LOAD and filename
    pop de
    push de
    call ieee_rd_err_d  ;A = CBM DOS error code
    pop de
    ld e,00h
    pop bc
    or a
    ret nz              ;Return if CBM DOS error is not 0 (OK)

    push de
    call talk           ;Send TALK
    ld hl,ccp_base      ;HL = base address of CP/M system
                        ;C = number of pages to load (1 page = 256 bytes),
                        ;      which is set by the caller
    ld b,00h            ;B = counts down bytes within each page
ilc1:
    call rdieee         ;Get byte from CP/M image file
    ld (hl),a           ;Store it in memory
    inc hl              ;Increment memory pointer
    djnz ilc1           ;Decrement B and loop until current page is done
    dec c               ;Decrement C
    jr nz,ilc1          ;Loop until all pages are done
    call untalk         ;Send UNTALK
    pop de

    push de
    call close          ;Close the file
    pop de
    jp ieee_rd_err_d    ;Jump out to read CBM DOS error channel.  It will
                        ;  return to the caller.

dos_num2:
    db "#2"

filename:
    db "0:CP/M"

dos_i0_0:
    db "I0"

deblock_2:
;Called only from write, and only if deblocking code = 2
;  (2 = Write can be deferred, no pre-read is necessary)
;
;TODO: sec_cnt decreases as y_sector increases.  Find out what
;      exactly this is doing and why.
;
    push bc
    call tstdrv_corv    ;Carry flag = set if drive type is Corvus
                        ;A = drive type
    pop bc
    or a                ;Clear carry flag

    cp 06h              ;Drive type = 06h (CBM 8250)?
    jp z,db1            ;  Yes: jump over to set A=20h
    ld a,10h            ;  No: A=10h
    jp db2
db1:
    ld a,20h
db2:
    ld (sec_cnt),a      ;Store A in sec_cnt (sector countdown)
                        ;  For CBM 8250, A=20h
                        ;  For all other drives, A=10h

                        ;TODO: What are these values?  In the DPBs, the
                        ;Checksum Vector Size is 10h for 3040/4040
                        ;and 20h for 8250.  Is this related?

    ld a,(drive)
    ld (y_drive),a      ;y_drive = drive

    ld hl,(track)
    ld (y_track),hl     ;y_track = track

    ld a,(sector)
    ld (y_sector),a     ;y_sector = sector
    ret

sub_rw:
;Called from read and write
;
    ld a,(drive)        ;A = CP/M drive number

    ld hl,x_drive       ;HL = address of x_drive
    xor (hl)            ;x_drive = 0

    ld b,a              ;B = CP/M drive number

    ld a,(track)        ;A = CP/M track number low byte

    ld hl,x_track       ;HL = address of x_track
    xor (hl)            ;x_track = 0

    or b

    ld b,a              ;B = CP/M track number low byte
    ld a,(track+1)      ;A = CP/M track number high byte

    inc hl              ;HL = x_track+1
    xor (hl)            ;x_track+1 = 0

    or b
    ld b,a

    ld a,(sector)
    rra

    ld hl,x_sector      ;HL = addresses of x_sector
    xor (hl)            ;x_sector = 0

    or b
    ret z

    ld hl,wrt_pend
    ld a,(hl)           ;A = CBM DOS write pending flag
    ld (hl),00h         ;Reset the flag
    or a
    call nz,ieee_writ_sec ;Perform the write if one is pending

    ld a,(drive)
    ld (x_drive),a      ;x_drive = drive

    ld hl,(track)
    ld (x_track),hl     ;x_track = track

    ld a,(sector)
    or a
    rra
    ld (x_sector),a
    or 0ffh
    ret

ieee_u1_or_u2:
;Perform a CBM DOS block read or block write.
;
;HL = pointer to string, either "U1 2 " (Block Read)
;       or "U1 2 " (Block Write)
;
    ld (hl_tmp),hl      ;Preserve HL
    call find_trk_sec   ;Update dos_trk and dos_sec
blk1:
    ld a,03h
    ld (tries),a        ;3 tries
blk2:
    ld a,(x_drive)      ;A = CP/M drive number
    call diskcmd        ;Open the command channel

    ld hl,(hl_tmp)      ;Recall HL (pointer to "U1 2 " or "U2 2 ")
    ld c,05h            ;5 bytes in string
    call ieeemsg        ;Send the string

    ld a,(x_drive)      ;A = CP/M drive number
    and 01h             ;Mask off all except bit 0
    add a,30h           ;Convert to ASCII
    call wrieee         ;Send CBM drive number (either "0" or "1")

    ld a,(dos_trk)
    call ieeenum        ;Send the CBM DOS track

    ld a,(dos_sec)
    call ieeenum        ;Send the CBM DOS sector

    call creoi          ;Send carriage return with EOI
    call unlisten       ;Send UNLISTEN

    ld a,(x_drive)      ;A = CP/M drive number
    call disksta        ;Read the error channel
    cp 16h              ;Is it 22 Read Error (no data block)?
    jr nz,blk3          ;  No: jump to blk3 to handle error

                        ;The error is 22 Read Error.  This error is a
                        ;special case.  If A'=0, it will be ignored.
                        ;If A'=1, it will be retried like any other error.

    ex af,af'           ;A=retry error 22 flag, A'=CBM DOS error code
    or a
    ret z               ;Return with A=0 if the flag is 0
    ex af,af'           ;A=CBM DOS error code, A'=retry error 22 flag

blk3:
    ld (dos_err),a      ;Save A as last error code returned from CBM DOS
    or a                ;Set flags
    ret z               ;Return if error code = 0 (OK)

    ld hl,tries
    dec (hl)            ;Decrement tries
    jr z,blk4           ;Give up if number of tries exceeded

    ld a,(x_drive)      ;A = CP/M drive number
    call idrive         ;Initialize the disk drive
    jr blk2             ;Try again

blk4:
    ld hl,bdos_err_on
    call puts           ;Write "BDOS err on " to console out

    ld a,(x_drive)      ;Get current drive number
    add a,41h           ;Convert it to ASCII (0=A, 1=B, 2=C, etc)
    ld c,a
    call conout         ;Write drive letter to console out

    ld hl,colon_space
    call puts           ;Write ": " to console out

    ld hl,cbm_dos_errs  ;HL = pointer to CBM DOS error table
    call put_dos_error  ;Display an error message

blk6:
    call conin          ;Wait for a key to be pressed

    cp ctrl_c           ;Control-C pressed?
    jp z,jp_warm        ;  Yes: Jump to BDOS warm start

    cp '?'              ;Question mark pressed?
    jr nz,blk8          ;  No: Jump over printing CBM DOS error msg

    ld hl,newline
    call puts           ;Write a newline to console out

    ld hl,errbuf        ;HL = pointer to CBM DOS error message
                        ;     like "23,READ ERROR,45,27,0",0Dh
blk7:
    ld a,(hl)           ;Get a char from CBM DOS error message
    cp cr
    jr z,blk6           ;Jump if end of CBM DOS error message reached

    ld c,a
    push hl
    call conout         ;Write char from CBM DOS error msg to console out
    pop hl
    inc hl              ;Increment to next char
    jr blk7             ;Loop to continue printing the error msg

blk8:
    ld a,(x_drive)      ;A = CP/M drive number
    call idrive         ;Initialize the disk drive
    ld a,(dos_err)
    cp 1ah
    jp z,blk1           ;Try again if error is write protect on
    cp 15h
    jp z,blk1           ;Try again if error is drive not ready
    ld a,00h
    ret

put_dos_error:
;Write a description of a CBM DOS error to console out.
;HL = pointer to cbm_dos_errs table
;
    ld a,(dos_err)      ;A=last error code returned from CBM DOS
    cp (hl)             ;Compare it to current error code in table
    ld a,(hl)           ;A = current error code in table

    inc hl              ;Increment HL to point to first byte in string
    jp z,puts           ;If error code matched, jump out to print string

    inc a               ;Increment A to check it for 0FFh (end of table)
    jp z,puts           ;If A=0FFh, jump out to print "Unknown error code"

err1:                   ;Move to the next error in the table:
    ld a,(hl)           ;  A = read a byte from the current error string
    inc hl              ;  Increment pointer
    or a                ;  Set flags
    jr nz,err1          ;  Loop until the end of the string

    jr put_dos_error    ;Loop to check the next error in the table

cbm_dos_errs:
;      Hex SoftBox Error Message          Dec  CBM DOS Error Description
;      --- ---------------------          ---  -------------------------
    db 1ah,"Disk write protected",0       ;26  Write Protect On
    db 19h,"Write verify error",0         ;25  Write Error (write-verify)
    db 1ch,"Long data block",0            ;28  Write Error (long data block)
    db 14h,"Missing header",0             ;20  Read Error (no block header)
    db 15h,"Disk not ready",0             ;21  Read Error (no sync char)
    db 4ah,"Disk not ready",0             ;74  Drive Not Ready
    db 16h,"Missing data block",0         ;22  Read Error (no data block)
    db 17h,"Checksum error in data",0     ;23  Read Error (data checksum)
    db 1bh,"Checksum error in header",0   ;27  Read Error (header checksum)
    db 18h,"Byte decoding error",0        ;24  Read Error (byte decoding)
    db 46h,"Commodore DOS bug !",0        ;70  No Channel
    db 49h,"Wrong DOS format",0           ;73  DOS Mismatch
    db 0ffh,"Unknown error code",0

colon_space:
    db ": ",0

bdos_err_on:
    db cr,lf,"BDOS err on ",0

dos_u1_2:
    db "U1 2 "

dos_u2_2:
    db "U2 2 "

newline:
    db cr,lf,0

find_trk_sec:
;Find the CBM DOS track and sector for the current CP/M track and sector.
;
;  Inputs:
;    x_drive:      equ 0044h   CP/M drive number
;    x_track:      equ 0045h   CP/M track
;    x_sector:     equ 0047h   CP/M sector
;
;  Outputs:
;    dos_trk:      equ 004dh   CBM track
;    dos_sec:      equ 004eh   CBM sector
;
;  Testing:
;    Set x_drive = 0
;    Set dtype for drive 0 (0ea70h): 0=3040/4040, 1=8050, 6=8250
;    Set x_track and x_sector with CP/M track and sector.
;    Call find_trk_sec.
;    Read dos_trk and dos_sec for CBM DOS track and sector.
;
    ld a,(x_drive)
    call tstdrv         ;C = drive type
    ld a,c              ;A = C
    or a
    ld ix,0057h         ;IX = 0057h (TODO what is 0057h?)

    ld hl,ts_cbm3040    ;HL = table for CBM 3040
    ld e,10h            ;E = 16 (first reserved track on CBM 3040/4040)
    jr z,fts1           ;Jump if drive type = 0 (CBM 3040/4040)

    ld e,25h            ;E = 37 (first reserved track on CBM 8050 and 8250)
    ld hl,ts_cbm8050    ;HL = table for CBM 8050
    cp 01h
    jr z,fts1           ;Jump if drive type = 1 (CBM 8050)

    ld hl,ts_cbm8250    ;HL = table for CBM 8250
fts1:
    ;HL = drive specific table
    ;E = 16 for 3040/4040
    ;E = 37 for both 8050 and 8250

    push de
    push hl
    ld (ix+00h),00h     ;0057h = 0
    ld hl,(x_track)     ;HL = CP/M track number
    ld h,00h            ;H = 0

    add hl,hl           ;HL = CP/M track * 8
    add hl,hl
    add hl,hl
    add hl,hl

    ld de,(x_sector)    ;DE = CP/M sector number
    ld d,00h            ;D = 0
    add hl,de           ;HL = HL + DE

    ld b,h              ;BC = HL
    ld c,l
    pop hl

fts2:
    ;HL = drive specific table
    ;BC = (CP/M track * 8) + (CP/M sector)

    ld e,(hl)           ;E = value at HL
    inc hl              ;HL=HL+1
    ld d,(hl)           ;D = value at HL

    ;DE = value from drive specific table

    ex de,hl
    scf
    sbc hl,bc
    ex de,hl

    ;  DE = value from table - ((CP/M track * 8) + (CP/M sector))

    jp nc,fts3           ;Jump to next routine if no carry
    inc hl              ;Move forward in table
    inc hl
    inc hl
    jp fts2              ;Do it over with new table position

fts3:
    dec hl              ;HL=HL-2
    dec hl
    ld a,(hl)           ;A = value from table at HL
    ld (ix+00h),a       ;0057h = value

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
fts4:
    ld a,l
    or a
    sbc hl,bc
    jp c,fts5
    inc (ix+00h)        ;Increment 0057h
    jp fts4
fts5:
    ld (dos_sec),a      ;Save A as the sector

    ld a,(ix+00h)       ;A = value at 0057h
    ld (dos_trk),a      ;Save it as the track

    pop de              ;Recall DE.  E contains the first reserved track:
                        ;  E = 16 for 3040/4040
                        ;  E = 37 for both 8050 and 8250
    cp e                ;If computed track is < the first reserved track,
    ret c               ;  return with the track as-is.
    add a,03h           ;Increment to skip over the 3 reserved tracks
    ld (dos_trk),a      ;Save the updated track number
    ret

ts_cbm3040:
    db 00h,00h,15h,01h,3bh,01h,13h,10h,0adh,01h,12h,16h
    db 19h,02h,11h,1ch,0fh,27h,00h,00h

ts_cbm8050:
    db 00h,00h,1dh,01h,14h,04h,1bh,25h,8eh,05h,19h,33h,0a1h
    db 06h,17h,3eh,0fh,27h,00h,00h

ts_cbm8250:
    db 00h,00h,1dh,01h,14h,04h,1bh,25h,8eh,05h,19h,33h,0a1h
    db 06h,17h,3eh,0cch,07h,1dh,4bh,37h,0ch,1bh,72h,0b1h,0dh
    db 19h,80h,0c4h,0eh,17h,8bh,0fh,27h,00h,00h

ieeenum:
;Send a number as decimal string to IEEE-488 device
;A = number (e.g. A=2ah sends " 42")
;
;TODO: This routine is used to send track numbers for CBM DOS commands but
;      it can only send 2 digits.  It needs to be fixed to send 3 digits
;      because the 8250 has 154 tracks.  It has been confirmed that
;      reading tracks 100+ does not work with a real CBM 8250.
;
    push af
    ld a,' '
    call wrieee         ;Send space character
    pop af
    ld e,'0'-1
num1:
    sub 0ah
    inc e
    jr nc,num1
    add a,3ah
    push af
    ld a,e
    call wrieee         ;Send the first digit
    pop af
    jp wrieee           ;Jump out to send the second digit
                        ;  and it will return to the caller.

disksta:
;Read the error channel of an IEEE-488 device
;A = CP/M drive number
;
;Returns the CBM DOS error code in A (0=OK)
;
    call dskdev         ;D = IEEE-488 primary address
                        ;Fall through into ieee_rd_err_d

ieee_rd_err_d:
;Read the error channel of an IEEE-488 device
;D = IEEE-488 primary address
;
;Returns the CBM DOS error code in A (0=OK)
;
    ld e,0fh
    call talk
    ld hl,errbuf
rderr1:
    call rdieee
    ld (hl),a
    sub 30h
    jr c,rderr1
    cp 0ah
    jr nc,rderr1
    inc hl
    ld b,a
    add a,a
    add a,a
    add a,b
    add a,a
    ld b,a
    call rdieee
    ld (hl),a
    inc hl
    sub 30h
    add a,b
    push af
    ld c,3ch
rderr2:
    call rdieee
    dec c
    jp m,rderr3
    ld (hl),a
    inc hl
rderr3:
    cp cr
    jr nz,rderr2
    call untalk
    pop af
    ret

ieee_writ_sec_hl:
;Write a sector to the CBM disk drive from buffer at HL.
;
    push hl
                        ;Send memory-write (M-W) command:
    ld hl,dos_mw        ;  HL = pointer to "M-W",00h,13h,01h
    ld c,06h            ;  C = 6 bytes in string
    ld a,(x_drive)      ;  A = CP/M drive number
    call diskcmd        ;  Open command channel
    call ieeemsg        ;  Send the command
    pop hl

                        ;Send first byte of sector to M-W:
    ld a,(hl)           ;  Get first byte
    push hl
    call wreoi          ;  Send it for M-W
    call unlisten       ;  Send UNLISTEN

                        ;Move pointer to second byte of buffer:
    ld hl,dos_bp        ;  HL = pointer "B-P 2 1" (Buffer-Pointer) string
    ld c,07h            ;  C = 7 bytes in string
    ld a,(x_drive)      ;  A = CP/M drive number
    call diskcmd        ;  Open command channel
    call ieeemsg        ;  Send B-P command
    call creoi          ;  Send carriage return with EOI
    call unlisten       ;  Send UNLISTEN

                        ;Send remaining 255 bytes of block:
    ld a,(x_drive)      ;  A = CP/M drive number
    call dskdev         ;  D = its IEEE-488 primary address
    ld e,02h            ;  E = IEEE-488 secondary address 2
    call listen         ;  Send LISTEN
    pop hl
    inc hl
    ld c,0ffh           ;  255 bytes to send
    call ieeemsg        ;  Send the bytes
    call unlisten       ;  Send UNLISTEN

                        ;Perform block write (U2):
    ld hl,dos_u2_2      ;  HL = pointer to "U2 2 " string (Block Write)
    jp ieee_u1_or_u2    ;  Jump out to perform the block write.  It will
                        ;    return to the caller.

ieee_read_sec_hl:
;Read a sector from a CBM disk drive into buffer at HL.
;
;There is special handling for a CBM DOS error 22 depending on the
;contents of A'.  See ieee_read_sec and ieee_u1_or_u2.
;
    push hl
                        ;Perform block read (U1):
    ld hl,dos_u1_2      ;  HL = pointer to "U1 2 " string
    call ieee_u1_or_u2  ;  Call to perform the block read

                        ;Send memory read (M-R) command:
    ld hl,dos_mr        ;  HL = pointer to "M-R",00h,13h string
    ld c,05h            ;  C = 5 bytes in string
    ld a,(x_drive)      ;  A = CP/M drive number
    call diskcmd        ;  Open command channel
    call ieeemsg        ;  Send M-R command
    call creoi          ;  Send carriage return with EOI
    call unlisten       ;  Send UNLISTEN

                        ;Read first byte of sector from M-R:
    ld a,(x_drive)      ;  A = CP/M drive number
    call dskdev         ;  D = its IEEE-488 primary address
    ld e,0fh            ;  E = Command channel number (15)
    call talk           ;  Send TALK
    call rdieee         ;  Read the byte returned by M-R
    pop hl
    ld (hl),a           ;  Save as first byte of sector
    push hl
    call untalk         ;  Send UNTALK

                        ;Move pointer to second byte of buffer:
    ld a,(x_drive)      ;  A = CP/M drive number
    call diskcmd        ;  Open command channel
    ld hl,dos_bp        ;  HL = pointer to "B-P 2 1" (Buffer-Pointer)
    ld c,07h            ;  C = 7 bytes in string
    call ieeemsg        ;  Send B-P command
    call creoi          ;  Send carriage return with EOI
    call unlisten       ;  Send UNLISTEN

                        ;Check for CBM DOS bug:
    ld a,(x_drive)      ;  A = CP/M drive number
    call disksta        ;  Read CBM DOS error channel
    cp 46h              ;  Error code = 70 No Channel?
    jr z,read_sec_retry ;    Yes: CBM DOS bug, jump to retry

                        ;Read remaining 255 bytes of block:
    ld a,(x_drive)      ;  A = CP/M drive number
    call dskdev         ;  D = its IEEE-488 primary address
    ld e,02h            ;  E = IEEE-488 secondary address 2
    call talk           ;  Send TALK
    pop de
    inc de
    ld b,0ffh           ;  255 bytes to read
read_sec_loop:
    call rdieee         ;  Read byte
    ld (de),a           ;  Store it
    inc de
    djnz read_sec_loop  ;  Decrement B, loop until all bytes read
    jp untalk           ;  Send UNTALK and return to caller

read_sec_retry:
    ld a,(x_drive)      ;A = CP/M drive number
    call idrive         ;Initialize the CBM disk drive
    pop hl              ;Recall original HL
    jr ieee_read_sec_hl ;Try again

dskdev:
;Get the device address for a CP/M drive number from the ddevs table
;
;A = CP/M drive number (0=A:, 1=B:, ...)
;
;Returns either an IEEE-488 primary address or a Corvus ID in D.
;
    push hl
    push af
                        ;Find index of this drive in the ddevs table:
    or a                ;  Clear carry flag
    rra                 ;  A = index into ddevs table for this drive
                        ;      Dividing the CP/M drive number by 2 finds its
                        ;      index in the ddevs or dtypes tables.  There
                        ;      are 16 possible CP/M drives, which the SoftBox
                        ;      maps to 8 units (each unit may provide up to
                        ;      2 drives).  Bit 0 of the CP/M drive number
                        ;      indicates which drive in the unit's pair.

                        ;Calculate address of this drive in ddevs table:
    ld e,a              ;  E = index of this drive in ddevs table
    ld d,00h            ;  D = 0
    ld hl,ddevs         ;  HL = base address of ddevs table
    add hl,de           ;  HL = HL + DE (address of this drive in ddevs)

    ld d,(hl)           ;D = device number of this drive
                        ;    (IEEE-488 primary address or Corvus ID)
    pop af
    pop hl
    ret

diskcmd:
;Open command channel on IEEE-488
;A = CP/M drive number (0=A:, 1=B:, ...)
;HL = pointer to string
;C = number of bytes in string
;
    call dskdev         ;D = IEEE-488 primary address
    ld e,0fh            ;E = IEEE-488 secondary address 15 (command channel)
    jp listen

idrive:
;Initialize an IEEE-488 disk drive
;A = CP/M drive number (0=A:, 1=B:, ...)
;
    call dskdev         ;D = IEEE-488 primary address
    ld e,0fh            ;E = IEEE-488 secondary address 15 (command channel)
    push de

    ld c,02h            ;C = 2 bytes in string
    ld hl,dos_i0        ;HL = pointer to "I0" string for CBM DOS drive 0

    rra                 ;Rotate bit 0 of CP/M drive number into carry flag
                        ;  For CBM dual drive units, bit 0 of the CP/M drive
                        ;  number indicates either drive 0 (bit 0 clear)
                        ;  or drive 1 (bit 0 set).

    jr nc,idrv1         ;Jump to keep "I0" string if CBM drive 0

    ld hl,dos_i1        ;HL = pointer to "I1" string for CBM drive 1
idrv1:
    call open
    pop de
    ld e,02h            ;E = IEEE-488 secondary address 2
    ld c,02h            ;C = 2 bytes in string
    ld hl,dos_num2      ;HL = pointer to "#2"
    jp open

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

talk:
;Send TALK to an IEEE-488 device
;D = primary address
;E = secondary address (0ffh if none)
;
    in a,(ppi2_pb)
    or atn
    out (ppi2_pb),a     ;ATN_OUT=low

                        ;Send primary address:
    ld a,40h            ;  High nibble (4) = Talk Address Group
    or d                ;  Low nibble (D) = primary address
    call wrieee         ;Send the byte

    jr c,release_atn    ;If an error occurred during wrieee,
                        ;  jump out to release ATN.

                        ;Send secondary address if any:
    ld a,e              ;  Low nibble (E) = secondary address
    or 60h              ;  High nibble (6) = Secondary Command Group
    call p,wrieee       ;Send the byte only if bit 7 is clear

    in a,(ppi2_pb)
    or ndac+nrfd
    out (ppi2_pb),a     ;NDAC_OUT=low, NRFD_OUT=low
                        ;Fall through into release_atn

release_atn:
;Set ATN_OUT=high then wait a short time
;
    push af
    in a,(ppi2_pb)
    and 255-atn
    out (ppi2_pb),a     ;ATN_OUT=high
    ld a,19h
relatn1:
    dec a
    jr nz,relatn1       ;Delay loop
    pop af
    ret

untalk:
;Send UNTALK to all IEEE-488 devices.
;
    in a,(ppi2_pb)
    or atn
    out (ppi2_pb),a     ;ATN_OUT=low

    in a,(ppi2_pb)
    and 255-ndac-nrfd
    out (ppi2_pb),a     ;NDAC_OUT=high, NRFD_OUT=high

    ld a,5fh            ;5fh = UNTALK
    jr wratn

listen:
;Send LISTEN to an IEEE-488 device
;D = primary address
;E = secondary address (0ffh if none)
;
    in a,(ppi2_pb)
    or atn
    out (ppi2_pb),a     ;ATN_OUT=low

                        ;Send primary address:
    ld a,20h            ;  High nibble (2) = Listen Address Group
    or d                ;  Low nibble (D) = primary address
    call wrieee

    jr c,release_atn    ;If an error occurred during wrieee       ,
                        ;  jump out to release ATN_OUT.

                        ;Send secondary address if any:
    ld a,e              ;  Low nibble (E) = secondary address
    or 60h              ;  High nibble (6) = Secondary Command Group
    call p,wrieee       ;Send the byte only if bit 7 is clear

    jr release_atn      ;Jump out to release ATN

unlisten:
;Send UNLISTEN to all IEEE-488 devices.
;
    ld a,3fh            ;3fh = UNLISTEN
                        ;Fall through into wratn

wratn:
;Send a byte to an IEEE-488 device with ATN asserted
;ATN_OUT=low, put byte, ATN_OUT=high, wait
;
    push af

    in a,(ppi2_pb)
    or atn
    out (ppi2_pb),a     ;ATN_OUT=low

    pop af
    call wrieee         ;Send the byte
    jr release_atn      ;Jump out to release ATN

open:
;Open a file on an IEEE-488 device.
;
;D = primary address
;E = file number
;C = number of bytes in filename
;HL = pointer to filename
;
    in a,(ppi2_pb)
    or atn
    out (ppi2_pb),a     ;ATN_OUT=low

    ld a,d              ;Low nibble (D) = primary address
    or 20h              ;High nibble (2) = Listen Address Group
    call wrieee

    ld a,e              ;Low nibble (E)
    or 0f0h             ;High nibble (0Fh) = Secondary Command Group
                        ;                    OPEN"file" and SAVE only
    call wratn

    dec c
    call nz,ieeemsg     ;Send string except for last char

    ld a,(hl)
    call wreoi          ;Send the last char with EOI asserted

    jr unlisten         ;Send UNLISTEN

close:
;Close an open file on an IEEE-488 device.
;
;D = primary address
;E = file number
;
    in a,(ppi2_pb)
    or atn
    out (ppi2_pb),a     ;ATN_OUT=low

    ld a,d              ;Low nibble (D) = primary address
    or 20h              ;High nibble (2) = Listen Address Group
    call wrieee

    ld a,e              ;Low nibble (E) = file number
    or 0e0h             ;High nibble (0Eh) = CLOSE
    call wrieee

    jr unlisten         ;Send UNLISTEN

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
ms1:
    add a,00h           ;A=A+0
    djnz ms1            ;Decrement B, loop until B=0
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
    or ndac
    out (ppi2_pb),a     ;NDAC_OUT=low

    ld a,02h            ;Command 02h = Wait for a key and send it
    call cbm_srq
    call rdieee

    push af
    in a,(ppi2_pb)
    and 255-ndac-nrfd
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

    ld a,01h            ;Command 01h = Check if a key has been pressed
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
    jp z,conout_range   ;  jump to check char range

    xor a
    ld (leadrcvd),a     ;Clear the lead-in received flag
    set 7,c             ;Set bit 7 of the char

conout_range:
;Check if the character is in the range the needs translation
;before sending it to the CBM.
;
    ld a,c              ;A = C

    cp 20h              ;Is A < 20h?
    jr c,conout_tr      ;  Yes: jump to conout_tr

    cp 7bh              ;Is A < 7bh?
    jr c,conout_cbm     ;  Yes: jump to conout_cbm

conout_tr:
;Translate the character before sending it to the CBM.
;Entered if C < 20h or C >= 7bh.
;
;The table at scrtab contains pairs of bytes in the form:
;  from,to,from,to,from,to,...
;
;If the character CP/M sends to the console is a "from" byte, it will
;be replaced with the corresponding "to" byte before it is sent to
;the CBM.  A "from" byte of 0 indicates the end of the table.
;
    ld hl,scrtab        ;HL = scrtab
conout_tr_loop:
    ld a,(hl)           ;A = "from" byte
    inc hl              ;HL=HL+1
    or a                ;Byte = 0 (end of table)?
    jr z,conout_cbm     ;  Yes: no change, jump to conout_cbm

    cp c                ;Found the char in the table?
    ld a,(hl)           ;A = "to" byte
    inc hl              ;HL=HL+1 (move to next pair in table)
    jr nz,conout_tr_loop  ;If char was not found, continue in the table

    cp esc              ;Replacement char = ESC (start cursor move-to)?
    jr z,move_start     ;  Yes: Jump to start move-to sequence
    ld c,a              ;   No: Replace the char with the one from the table
                        ;         and fall through to send it to the console

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
    ld c,esc            ;LSI ADM-3A command to start move-to sequence
    call conout_cbm     ;Send start of move-to
    pop de

    push de
    ld a,e
    ld hl,x_offset
    sub (hl)
    cp 60h
    jr c,movsnd1
    sub 60h
movsnd1:
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
;  01h = Check if a key has been pressed
;  02h = Wait for a key and send it
;  04h = Write to the terminal screen
;  08h = Jump to a subroutine in CBM memory
;  10h = Transfer bytes from CBM memory to the SoftBox
;  20h = Transfer bytes from the SoftBox to CBM memory
;
;This routine queries the CBM keyboard status each time it is called.
;The carry flag will be set if a key is available, clear if not.
;
    push af
srq1:
    in a,(ppi1_pa)
    or a
    jr nz,srq1          ;Wait for IEEE data bus to be released

    pop af
    out (ppi1_pb),a     ;Write data byte to IEEE data bus

    in a,(ppi2_pb)
    or srq
    out (ppi2_pb),a     ;SRQ_OUT=low

    in a,(ppi2_pb)
    and 255-srq
    out (ppi2_pb),a     ;SRQ_OUT=high

srq2:
    in a,(ppi1_pa)      ;Read IEEE data byte
    and 0c0h            ;Mask off all except bits 6 and 7
    jr z,srq2           ;Wait until CBM changes one of those bits

    rla                 ;Rotate bit 7 (key available status) into carry flag
    push af             ;Push flags to save carry

    ld a,00h
    out (ppi1_pb),a     ;Release IEEE data lines

srq3:
    in a,(ppi1_pa)
    or a
    jr nz,srq3          ;Wait for IEEE data bus to be released

    pop af              ;Pop flags to restore carry
    ret

list:
;List (printer) output.
;C = character to write to the printer
;
    ld a,(iobyte)
    and 0c0h            ;Mask off all but buts 6 and 7
    jp z,ser_out        ;Jump out if List is RS-232 port (LST: = TTY:)
    jp p,conout_cbm     ;Jump out if List is CBM computer (LST: = CRT:)

    ld e,0ffh           ;E = no IEEE-488 secondary address

    and 40h             ;Mask off all but bit 6
    jr z,list_lpt       ;Jump if List is CBM printer (LST: = LPT:)

list_ul1:
;List to an ASCII printer (LST: = UL1:)
;
    ld a,(ul1_dev)
    ld d,a              ;D = IEEE-488 primary address of UL1:
    call listen         ;Send LISTEN
    jp ieee_unl_byte    ;Jump out to send byte, UNLISTEN, then return.

list_lpt:
;List to a CBM printer (LST: = LPT:)
;
;Converts ASCII to equivalent PETSCII.  Converts line endings
;if needed and sets lowercase mode after each new line if needed.
;
    ld a,(lpt_dev)
    ld d,a              ;D = IEEE-488 primary address of LPT:

    in a,(ppi2_pb)
    or atn
    out (ppi2_pb),a     ;ATN_OUT=low

    ld a,(lptype)       ;A = lptype
    ld b,a              ;B = lptype
    or a
    call z,delay_1ms    ;Wait 1ms if lptype = 0 (3022, 3023, 4022, 4023)

    call listen         ;Send LISTEN

    bit 0,b             ;Is it lptype = 1 (8026)?
    jr nz,list_lpt_8026 ;  Yes: Jump to handle that printer separately

    ld hl,list_tmp      ;HL = address holding the last char sent to LIST
    ld a,(hl)           ;A = last character
    ld (hl),c           ;Update the last char for the next time around.

    cp lf               ;Was the last character a Line Feed?
    jr z,list_lpt_lower ;  Yes: jump to put the printer back to lowercase,
                        ;       then send this char.
                        ;   No: continue to check for CR.

    cp cr               ;Was the last character a Carriage Return?
    jr nz,list_lpt_undr ;   No: jump to send this char as-is.
                        ;  Yes: continue to check for CR followed by LF.

    ld a,c              ;A = C (this character)
    cp lf               ;Last char was a CR.  Is this char a Line Feed?
    jr z,list_lpt_undr  ;  Yes: jump to send the LF as-is.
                        ;   No: continue to send 8Dh to the printer.

    ld a,b              ;A = lptype
    or a                ;Is it lptype = 0 (3022, 4022)?
    call z,delay_1ms    ;  Yes: Wait 1ms before sending the char

    ld a,8dh            ;8dh = PETSCII Shift Carriage Return
                        ;        (Carriage return without line feed)
    call wrieee         ;Send it to the printer

list_lpt_lower:
;Set the printer to lowercase mode if needed.  Commodore printers
;that have uppercase/lowercase mode will default to uppercase mode
;and reset back to uppercase mode after every carriage return.
;
    bit 1,b             ;Is it lptype = 2 (8024)?
    jr nz,list_lpt_undr ;  Yes: jump over, do not need to set lowercase
                        ;                   mode on the 8024.

    call delay_1ms      ;Wait 1ms
    ld a,11h            ;11h = PETSCII Cursor Down
                        ;        (Go to lowercase mode)
    call wrieee         ;Send it to the printer

list_lpt_undr:
;Convert an ASCII underscore to its equivalent PETSCII graphic char.
;
    ld a,c              ;A = C (ASCII char to print)

    cp '_'              ;Is the char an underscore?
    jr nz,list_lpt_crlf ;  No:  Leave it alone
    ld a,0a4h           ;  Yes: Change it to 0a4h (PETSCII underscore)

list_lpt_crlf:
;Convert Carriage Return and Line Feed.
;
    cp cr               ;Is it a Carriage Return?
    jr z,list_lpt_unlsn ;  Yes: Jump to send nothing, then UNLISTEN

    cp lf               ;Is it a Line Feed?
    jr nz,list_lpt_char ;  No:  Jump to send it as-is
    ld a,cr             ;  Yes: Change it to a Carriage Return

list_lpt_char:
;Convert the character from ASCII to PETSCII, send it to the
;printer, then fall through to send UNLISTEN and return.
;
    call ascii_to_pet   ;A = equivalent char in PETSCII

    bit 1,b             ;Is it lptype = 0 (3022)?
    call z,delay_1ms    ;  Yes: Wait 1ms before sending the char

    call wrieee         ;Send the PETSCII char to the printer
                        ;Fall through into list_lpt_unlsn

list_lpt_unlsn:
;Send UNLISTEN to the printer and return.
;
    in a,(ppi2_pb)
    or atn
    out (ppi2_pb),a     ;ATN_OUT=low
    jp unlisten         ;Jump out to send UNLISTEN,
                        ;  it will return to the caller.

list_lpt_8026:
;List routine for Commodore 8026 (Olympia ESW 103) only.  This
;printer is unlike the others because it accepts PETSCII characters
;with CRLF line endings.
;
    ld a,c              ;A = char to print in ASCII
    call ascii_to_pet   ;A = its equivalent in PETSCII
    call wrieee         ;Send the PETSCII char to the printer
    jp unlisten         ;Jump out to send UNLISTEN,
                        ;  it will return to the caller.

listst:
;List (printer) status
;
;Returns A=0 (not ready) or A=0FFh (ready).
;
    ld a,(iobyte)
    and 0c0h
    jr z,ser_tx_status  ;Jump out if List is RS-232 port (LST: = TTY:)

    rla
    ld a,0ffh           ;A=0FFh (indicates ready)
    ret nc              ;Return if List is Console (LST: = CRT:)

    ld a,(iobyte)
    and 40h             ;Mask off all except bit 6
    ld a,(lpt_dev)      ;A = IEEE-488 primary address of LPT:
    jr z,listst_ieee    ;Jump to keep A if CBM printer (LST: = LPT:)

                        ;List must be ASCII printer (LST: = UL1:)
    ld a,(ul1_dev)      ;A = IEEE-488 primary address of UL1:

listst_ieee:
    ld d,a              ;D = IEEE-488 primary address of LPT: or UL1:
    ld e,0ffh           ;E = no IEEE-488 secondary address
    call listen
    call delay_1ms

    in a,(ppi2_pa)      ;Read IEEE-488 control lines in
    cpl                 ;Invert byte
    and nrfd            ;Mask off all except bit 3 (NRFD in)

    push af
    call unlisten
    pop af

    ret z               ;Return with 0 if NRFD_IN=low
    dec a
    ret                 ;Return with 0FFh if NRFD_IN=high

ser_tx_status:
;RS-232 serial port transmit status
;Returns A=0 (not ready) or A=0FFh (ready).
;
    in a,(usart_st)     ;Read USART status register
    cpl                 ;Invert it
    and 84h             ;Mask off all but bits 7 (DSR) and 2 (TxEMPTY)
    ld a,0ffh
    ret z               ;Return A=0FFh if ready to transmit
    inc a
    ret                 ;Return A=0 if not ready

ascii_to_pet:
;Convert an ASCII char to its equivalent PETSCII char.
;A = ASCII char
;Returns the PETSCII equivalent in A.
;
                        ;00-40h (Numbers, Punctuation, Control Codes)
    cp 41h              ;  Is A < 41h?
    ret c               ;    Yes: return with A unchanged

                        ;41h-59h (Uppercase letters)
    cp 60h              ;  Is A < 60h?
    jr c,ascii_upper    ;    Yes: jump to convert it

                        ;7bh-ffh (Braces, Pipe, Extended Characters)
    cp 7bh              ;  Is A >= 7bh?
    ret nc              ;    Yes: return with A unchanged

                        ;60h-7ah (Backtick, Lowercase Letters)
    xor 20h             ;  Flip bit 5 to convert to lowercase ASCII char
    ret                 ;    to PETSCII equivalent and return

ascii_upper:
    xor 80h             ;Flip bit 7 to convert uppercase ASCII char
    ret                 ;  to PETSCII equivalent and return

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
    call listen         ;Send LISTEN
                        ;Fall through into ieee_unl_byte

ieee_unl_byte:
;Send the byte in A to IEEE-488 device then send UNLISTEN.
;
    ld a,c              ;C = byte to send to IEEE-488 device
    call wrieee
    jp unlisten

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
    call talk
    call rdieee         ;A = byte read from IEEE-488 device
    push af
    call untalk
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

clear:
;Clear the CBM screen
;
    ld a,(iobyte)
    rra
    ret nc              ;Do nothing if console is RS-232 (CRT: = TTY:)

    ld c,cls            ;Lear Siegler ADM-3A clear screen code
    jp conout_cbm

execute:
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

peek:
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
    or ndac
    out (ppi2_pb),a     ;NDAC_OUT=low

peek_loop:
    call rdieee         ;Read a byte from the CBM
    ld (hl),a           ;Store it at the pointer
    inc hl              ;Increment pointer
    dec bc              ;Decrement bytes remaining to transfer
    ld a,b
    or c
    jr nz,peek_loop     ;Loop until no bytes are remaining

    in a,(ppi2_pb)
    and 255-nrfd-ndac
    out (ppi2_pb),a     ;NRFD_OUT=high, NDAC_OUT=high
    ret

poke:
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

poke_loop:
    ld a,(hl)           ;Read byte at pointer
    call cbm_put_byte   ;Send it to the CBM
    inc hl              ;Increment pointer
    dec bc              ;Decrement bytes remaining to transfer
    ld a,b
    or c
    jr nz,poke_loop     ;Loop until no bytes are remaining
    ret

settime:
;Set the time on the CBM real time clock
;
;H = Hours
;L = Minutes
;D = Seconds
;E = Jiffies (ignored: E is always reset to 0)
;
    ld e,00h            ;E = 0 to reset jiffies

    ld (jiffies),de     ;Store E in jiffies
                        ;Store D in secs
    ld (mins),hl        ;Store L in mins
                        ;Store H in hours

    ld de,0014h         ;DE = CBM start address
    ld hl,jiffies       ;HL = SoftBox start address
    ld bc,0004h         ;BC = 4 bytes to transfer
    jp poke             ;Transfer from SoftBox to CBM

resclk:
;Reset the CBM jiffy clock
;
    xor a               ;A=0
    ld (jiffy2),a       ;Clear jiffy counter values
    ld (jiffy1),a
    ld (jiffy0),a
    ld hl,jiffy2        ;HL = SoftBox start address
    ld de,0018h         ;DE = CBM start address
    ld bc,0003h         ;BC = 3 bytes to transfer
    jp poke             ;Transfer from SoftBox to CBM

gettime:
;Read the CBM clocks (both RTC and jiffy counter)
;
;Returns RTC values in H,L,D,E:
;  H = Hours
;  L = Minutes
;  D = Seconds
;  E = Jiffies (counts up to 50 or 60)
;
;Returns jiffy counter values in A,B,C:
;  A = Jiffy0 (MSB)
;  B = Jiffy1
;  C = Jiffy2 (LSB)
;
    ld bc,0007h         ;BC = 7 bytes to transfer
    ld hl,jiffies       ;HL = SoftBox start address
    ld de,0014h         ;DE = CBM start address
    call peek           ;Transfer from CBM to SoftBox

    ld de,(jiffies)     ;E = jiffies
                        ;D = secs
    ld hl,(mins)        ;L = mins
                        ;H = hours
    ld a,(jiffy2)       ;A = jiffy2 (MSB)
    ld bc,(jiffy1)      ;B = jiffy1
                        ;C = jiffy0 (LSB)
    ret

wrieee:
;Send a byte to an IEEE-488 device
;
;A = byte to send
;
;Returns carry flag set if an error occurred, clear if OK.
;
    push af             ;Push data byte
wri1:
    in a,(ppi2_pa)
    cpl
    and nrfd
    jr z,wri1           ;Wait until NRFD_IN=high

    in a,(ppi2_pa)
    cpl
    and ndac
    jr nz,wri4          ;Jump to error if NDAC_IN=high

    pop af              ;Push data byte
    out (ppi1_pb),a     ;Write byte to IEEE-488 data lines

    in a,(ppi2_pb)
    or dav
    out (ppi2_pb),a     ;DAV_OUT=low

wri2:
    in a,(ppi2_pa)
    cpl
    and ndac
    jr z,wri2           ;Wait until NDAC_IN=high

    in a,(ppi2_pb)
    and 255-dav
    out (ppi2_pb),a     ;DAV_OUT=high

    xor a
    out (ppi1_pb),a     ;Release IEEE-488 data lines

wri3:
    in a,(ppi2_pa)
    cpl
    and ndac
    jr nz,wri3          ;Wait until NDAC_IN=low

    ex (sp),hl          ;Waste time
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl

    in a,(ppi2_pa)
    cpl
    and ndac
    jr nz,wri3          ;Wait until NDAC_IN=low

    or a                ;Clear carry flag to indicate OK
    ret

wri4:
    pop af              ;Pop data byte
    scf                 ;Set carry flag to indicate error
    ret

cbm_put_byte:
;Send a single byte to the CBM
;
;A = byte to send
;
    out (ppi1_pb),a     ;Put byte on IEEE data bus

cpb1:
    in a,(ppi2_pa)
    cpl
    and nrfd
    jr z,cpb1           ;Wait until NRFD_IN=high

    in a,(ppi2_pb)
    or dav
    out (ppi2_pb),a     ;DAV_OUT=low

cpb2:
    in a,(ppi2_pa)
    cpl
    and ndac
    jr z,cpb2           ;Wait until NDAC_IN=high

    in a,(ppi2_pb)
    and 255-dav
    out (ppi2_pb),a     ;DAV_OUT=high

    xor a
    out (ppi1_pb),a     ;Release IEEE-488 data lines
    ret

rdimm:
;Read a byte from IEEE-488 device with timeout
;BC = number milliseconds before timeout
;
;Returns carry flag set if a timeout occurred.
;Returns the byte in A.
;Stores ppi2_pa in eoisav so EOI state can be checked later.
;
    in a,(ppi2_pb)
    and 255-nrfd
    out (ppi2_pb),a     ;NRFD_OUT=high
rdm1:
    in a,(ppi2_pa)
    cpl
    and dav
    jr z,ieee_dav_get   ;Jump out to read the byte if DAV_IN=low
    call delay_1ms
    dec bc              ;Decrement BC
    ld a,b
    or c
    jr nz,rdm1          ;Loop until BC=0
    scf
    ret

rdieee:
;Read a byte from the current IEEE-488 device
;No timeout; waits forever for DAV_IN=low.
;
;Returns the byte in A.
;Stores ppi2_pa in eoisav so EOI state can be checked later.
;
    in a,(ppi2_pb)
    and 255-nrfd
    out (ppi2_pb),a     ;NRFD_OUT=high
rdi1:
    in a,(ppi2_pa)
    cpl
    and dav
    jr nz,rdi1          ;Wait until DAV_IN=low
                        ;Fall through to read the byte

ieee_dav_get:
;Read a byte from the current IEEE-488 device.  The caller
;must wait for DAV_IN=low before calling this routine.
;
;This routine is not called from a BIOS entry point.  It is only
;used internally to implement rdieee and rdimm.
;
;Returns the byte in A.
;Stores ppi2_pa in eoisav so EOI state can be checked later.
;
    in a,(ppi1_pa)      ;Read byte from IEEE data bus
    push af             ;Push it on the stack

    in a,(ppi2_pa)      ;Read state of IEEE-488 control lines in
    ld (eoisav),a       ;Save it so EOI state can be checked later

    in a,(ppi2_pb)
    or nrfd
    out (ppi2_pb),a     ;NRFD_OUT=low

    in a,(ppi2_pb)
    and 255-ndac
    out (ppi2_pb),a     ;NDAC_OUT=high

idg1:
    in a,(ppi2_pa)
    cpl
    and dav
    jr z,idg1           ;Wait until DAV_IN=high

    in a,(ppi2_pb)
    or ndac
    out (ppi2_pb),a     ;NDAC_OUT=low

    pop af              ;Pop the IEEE data byte off the stack
    or a                ;Set flags
    ret

creoi:
;Send a carriage return to IEEE-488 device with EOI
;
    ld a,cr             ;A = carriage return
                        ;Fall through into wreoi

wreoi:
;Send the byte in A to IEEE-488 device with EOI asserted
;
    push af
    in a,(ppi2_pb)
    or eoi
    out (ppi2_pb),a     ;EOI_OUT=low

    pop af
    call wrieee         ;Send the byte
    push af

    in a,(ppi2_pb)
    and 255-eoi
    out (ppi2_pb),a     ;EOI_OUT=high

    pop af
    ret

ieeemsg:
;Send a string to the current IEEE-488 device
;HL = pointer to string
;C = number of bytes in string
;
    ld a,(hl)           ;A = get first char from string
    inc hl              ;Increment pointer to next char in string
    call wrieee         ;Send byte in A to IEEE-488 device
    dec c               ;Decrement number of chars remaining to send
    jr nz,ieeemsg       ;If any chars remain, jump out to ieeemsg to
                        ;  send them.  It will return to the caller.
    ret

filler:
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

checksum:
    db 91h

lfffeh:
    db 0ffh, 0ffh
