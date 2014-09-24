;SoftBox CP/M 2.2 BIOS
;Revision 8/9/81
;
;This is a disassembly of two original 2716 EPROMs from a SoftBox,
;labeled "375" (IC3) and "376" (IC4).
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
drvtype:  equ  0044h    ;  Drive type (from dtypes table)

                        ;Alternate copy of disk position (??):
x_drive:  equ  0045h    ;  Drive number (0=A, 1=B, 2=C, etc.)
x_track:  equ  0046h    ;  Track number (only 1 byte)
x_sector: equ  0047h    ;  Sector number

                        ;Alternate copy of disk position (??):
sec_cnt:  equ  0048h    ;  Counts down sectors, related to y_* (TODO how?)
y_drive:  equ  0049h    ;  Drive number (0=A, 1=B, 2=C, etc.)
y_track:  equ  004ah    ;  Track number (only 1 byte)
y_sector: equ  004bh    ;  Sector number

wrt_pend: equ  004ch    ;CBM DOS buffer state (1=write is pending, 0=none)
dos_trk:  equ  004dh    ;CBM DOS track number
dos_sec:  equ  004eh    ;CBM DOS sector number
dos_err:  equ  004fh    ;Last CBM DOS error code saved by ieee_u1_or_u2
tries:    equ  0050h    ;Counter used to retry drive faults in ieee_u1_or_u2
list_tmp: equ  0051h    ;Stores the last character sent to the LIST routine
dma:      equ  0052h    ;DMA buffer area address
hl_tmp:   equ  0055h    ;Temporary storage for HL reg used in ieee_u1_or_u2
trk_3040: equ  0057h    ;Temporary CBM DOS track number for CBM 3040/4040
trk_8050: equ  0058h    ;Temporary CBM DOS track number for CBM 8050
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
dtypes:   equ 0ea70h    ;Disk drive types:
dtype_ab: equ dtypes+0  ;  A:, B:    00h = CBM 3040/4040
dtype_cd: equ dtypes+1  ;  C:, D:    01h = CBM 8050
dtype_ef: equ dtypes+2  ;  E:, F:    02h = Corvus 10MB
dtype_gh: equ dtypes+3  ;  G:, H:    03h = Corvus 20MB
dtype_ij: equ dtypes+4  ;  I:, J:    04h = Corvus 5MB
dtype_kl: equ dtypes+5  ;  L:, K:   0ffh = No device
dtype_mn: equ dtypes+6  ;  M:, N:
dtype_op: equ dtypes+7  ;  O:, P:

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
    db cr,lf,"60K PET CP/M vers. 2.2"
    db cr,lf,"(c) 1981 Keith Frewin"
    db cr,lf,"Revision 8/9/81"
    db 00h

wboot:
;Warm start
;
    ld c,16h            ;C = 22 pages to load: D400-E9FF
    ld sp,0100h         ;Initialize stack pointer
    ld a,(dtypes)       ;A = drive type of CP/M drive number 0 (A:)
    call tstdrv_corv    ;Is it a Corvus hard drive?
    jr c,wboot_corvus   ;  Yes: jump to warm boot from Corvus

wboot_ieee:             ;Reload the system from an IEEE-488 drive:
    xor a               ;  A = CP/M drive number 0 (A:)
    call dskdev         ;  D = its IEEE-488 primary address
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
    push bc
    ld hl,0000h         ;HL = 0
    ld (track),hl       ;Track = 0

    xor a               ;A = 0
    ld (sector),a       ;Sector = 0
    ld c,a              ;C = CP/M drive number 0 (A:)

    call seldsk         ;Select CP/M drive number 0 (A:)
    pop bc
    ld hl,ccp_base      ;HL = base address of CP/M system

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
    ld (trk_3040),a     ;for CBM 3040/4040 = 0
    ld (trk_8050),a     ;for CBM 8050 = 0
    ld (sec_cnt),a      ;sec_cnt = 0
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

                        ;Save the drive type:
    ld a,c              ;  A = drive type (returned by tstdrv in C)
    ld (drvtype),a      ;  Save it in drvtype

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
    ld a,(drvtype)      ;  A = CP/M drive type
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
corv_init:
    ld a,0ffh           ;f2c4 3e ff   3e ff   > .
    out (18h),a         ;f2c6 d3 18   d3 18   . .
    ld b,0ffh           ;f2c8 06 ff   06 ff   . .
lf2cah:
    djnz lf2cah         ;f2ca 10 fe   10 fe   . .
    in a,(16h)          ;f2cc db 16   db 16   . .
    and 20h             ;f2ce e6 20   e6 20   .
    jr nz,corv_init     ;f2d0 20 f2   20 f2     .
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
    call puts           ;f30f cd f1 fc   cd f1 fc    . . .
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
    db cr,lf,bell,"*** HARD DISK ERROR ***",cr,lf,00h
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
    ld hl,loading       ;f41b 21 1b f5   21 1b f5    ! . .
    call puts           ;f41e cd f1 fc   cd f1 fc    . . .
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
    call corv_load_cpm  ;f440 cd f4 f0   cd f4 f0    . . .
    jr runcpm           ;f443 18 23   18 23   . #
lf445h:
    call unlisten       ;f445 cd a6 fa   cd a6 fa    . . .
    ld de,080fh         ;f448 11 0f 08   11 0f 08    . . .
    ld c,02h            ;f44b 0e 02   0e 02   . .
    ld hl,lf56ch        ;f44d 21 6c f5   21 6c f5    ! l .
    call open           ;f450 cd b5 fa   cd b5 fa    . . .
    ld d,08h            ;f453 16 08   16 08   . .
    ld c,1ch            ;f455 0e 1c   0e 1c   . .
    call ieee_load_cpm  ;f457 cd 2e f5   cd 2e f5    . . .
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
    call puts           ;f50b cd f1 fc   cd f1 fc    . . .
    call const          ;f50e cd 15 fb   cd 15 fb    . . .
    inc a               ;f511 3c   3c  <
    call z,conin        ;f512 cc f7 fa   cc f7 fa    . . .
    ld hl,0d400h        ;f515 21 00 d4   21 00 d4    ! . .
    jp start_ccp        ;f518 c3 1e f1   c3 1e f1    . . .

loading:
    db cr,lf,"Loading CP/M ...",0

ieee_load_cpm:
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
    ld hl,bdos_err_on   ;f618 21 a8 f7   21 a8 f7    ! . .
    call puts           ;f61b cd f1 fc   cd f1 fc    . . .
    ld a,(0045h)        ;f61e 3a 45 00   3a 45 00    : E .
    add a,41h           ;f621 c6 41   c6 41   . A
    ld c,a              ;f623 4f   4f  O
    call conout         ;f624 cd 27 fb   cd 27 fb    . ' .
    ld hl,colon_space   ;f627 21 a5 f7   21 a5 f7    ! . .
    call puts           ;f62a cd f1 fc   cd f1 fc    . . .
    ld a,(004fh)        ;f62d 3a 4f 00   3a 4f 00    : O .
    ld hl,cbm_err_26    ;f630 21 c0 f6   21 c0 f6    ! . .
    cp 1ah              ;f633 fe 1a   fe 1a   . .
    jr z,lf684h         ;f635 28 4d   28 4d   ( M
    ld hl,cbm_err_25    ;f637 21 d5 f6   21 d5 f6    ! . .
    cp 19h              ;f63a fe 19   fe 19   . .
    jr z,lf684h         ;f63c 28 46   28 46   ( F
    ld hl,cbm_err_28    ;f63e 21 e8 f6   21 e8 f6    ! . .
    cp 1ch              ;f641 fe 1c   fe 1c   . .
    jr z,lf684h         ;f643 28 3f   28 3f   ( ?
    ld hl,cbm_err_20    ;f645 21 f8 f6   21 f8 f6    ! . .
    cp 14h              ;f648 fe 14   fe 14   . .
    jr z,lf684h         ;f64a 28 38   28 38   ( 8
    ld hl,cbm_err_21    ;f64c 21 07 f7   21 07 f7    ! . .
    cp 15h              ;f64f fe 15   fe 15   . .
    jr z,lf684h         ;f651 28 31   28 31   ( 1
    cp 4ah              ;f653 fe 4a   fe 4a   . J
    jr z,lf684h         ;f655 28 2d   28 2d   ( -
    ld hl,cbm_err_22    ;f657 21 16 f7   21 16 f7    ! . .
    cp 16h              ;f65a fe 16   fe 16   . .
    jr z,lf684h         ;f65c 28 26   28 26   ( &
    ld hl,cbm_err_23    ;f65e 21 29 f7   21 29 f7    ! ) .
    cp 17h              ;f661 fe 17   fe 17   . .
    jr z,lf684h         ;f663 28 1f   28 1f   ( .
    ld hl,cbm_err_27    ;f665 21 40 f7   21 40 f7    ! @ .
    cp 1bh              ;f668 fe 1b   fe 1b   . .
    jr z,lf684h         ;f66a 28 18   28 18   ( .
    ld hl,cbm_err_24    ;f66c 21 59 f7   21 59 f7    ! Y .
    cp 18h              ;f66f fe 18   fe 18   . .
    jr z,lf684h         ;f671 28 11   28 11   ( .
    ld hl,cbm_err_70    ;f673 21 80 f7   21 80 f7    ! . .
    cp 46h              ;f676 fe 46   fe 46   . F
    jr z,lf684h         ;f678 28 0a   28 0a   ( .
    ld hl,cbm_err_73    ;f67a 21 94 f7   21 94 f7    ! . .
    cp 49h              ;f67d fe 49   fe 49   . I
    jr z,lf684h         ;f67f 28 03   28 03   ( .
    ld hl,cbm_err_xx    ;f681 21 6d f7   21 6d f7    ! m .
lf684h:
    call puts           ;f684 cd f1 fc   cd f1 fc    . . .
lf687h:
    call conin          ;f687 cd f7 fa   cd f7 fa    . . .
    cp 03h              ;f68a fe 03   fe 03   . .
    jp z,0000h          ;f68c ca 00 00   ca 00 00    . . .
    cp 3fh              ;f68f fe 3f   fe 3f   . ?
    jr nz,lf6aah        ;f691 20 17   20 17     .
    ld hl,0f7c1h        ;f693 21 c1 f7   21 c1 f7    ! . .
    call puts           ;f696 cd f1 fc   cd f1 fc    . . .
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

cbm_err_26:
    db "Disk write protected",0

cbm_err_25:
    db "Write verify error",0

cbm_err_28:
    db "Long data block",0

cbm_err_20:
    db "Missing header",0

cbm_err_21:
    db "Disk not ready",0

cbm_err_22:
    db "Missing data block",0

cbm_err_23:
    db "Checksum error in data",0

cbm_err_27:
    db "Checksum error in header",0

cbm_err_24:
    db "Byte decoding error",0

cbm_err_xx:
    db "Unknown error code",0

cbm_err_70:
    db "Commodore DOS bug !",0

cbm_err_73:
    db "Wrong DOS format",0

colon_space:
    db ": ",0

bdos_err_on:
    db cr,lf,"BDOS err on ",0

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
    jp c,0f703h         ;f8b5 da 03 f7   da 03 f7    . . .
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
    jr nz,0fa82h        ;fa4e 20 32   20 32     2
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

    jr c,release_atn    ;If an error occurred during wrieee       ,
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
    push af             ;fa77 f5   f5  .
    in a,(15h)          ;fa78 db 15   db 15   . .
    and 0feh            ;fa7a e6 fe   e6 fe   . .
    out (15h),a         ;fa7c d3 15   d3 15   . .
    pop af              ;fa7e f1   f1  .
    ret                 ;fa7f c9   c9  .

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
    ld a,(0003h)        ;faf7 3a 03 00   3a 03 00    : . .
    rra                 ;fafa 1f   1f  .
    jp nc,ser_in        ;fafb d2 d6 fb   d2 d6 fb    . . .
    in a,(15h)          ;fafe db 15   db 15   . .
    or 04h              ;fb00 f6 04   f6 04   . .
    out (15h),a         ;fb02 d3 15   d3 15   . .
    ld a,02h            ;fb04 3e 02   3e 02   > .
    call cbm_srq        ;fb06 cd df fb   cd df fb    . . .
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
    jp nc,ser_rx_status ;fb19 d2 c3 fb   d2 c3 fb    . . .
    ld a,01h            ;fb1c 3e 01   3e 01   > .
    call cbm_srq        ;fb1e cd df fb   cd df fb    . . .
    ld a,00h            ;fb21 3e 00   3e 00   > .
    ret nc              ;fb23 d0   d0  .
    ld a,0ffh           ;fb24 3e ff   3e ff   > .
    ret                 ;fb26 c9   c9  .

conout:
    ld a,(0003h)        ;fb27 3a 03 00   3a 03 00    : . .
    rra                 ;fb2a 1f   1f  .
    jp nc,ser_out       ;fb2b d2 cb fb   d2 cb fb    . . .
    ld a,(005ah)        ;fb2e 3a 5a 00   3a 5a 00    : Z .
    or a                ;fb31 b7   b7  .
    jp nz,lfb7ch        ;fb32 c2 7c fb   c2 7c fb    . | .
    ld a,c              ;fb35 79   79  y
    rla                 ;fb36 17   17  .
    jr c,conout_cbm     ;fb37 38 34   38 34   8 4
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
    jr c,conout_cbm     ;fb59 38 12   38 12   8 .
lfb5bh:
    ld hl,0ea80h        ;fb5b 21 80 ea   21 80 ea    ! . .
lfb5eh:
    ld a,(hl)           ;fb5e 7e   7e  ~
    inc hl              ;fb5f 23   23  #
    or a                ;fb60 b7   b7  .
    jr z,conout_cbm     ;fb61 28 0a   28 0a   ( .
    cp c                ;fb63 b9   b9  .
    ld a,(hl)           ;fb64 7e   7e  ~
    inc hl              ;fb65 23   23  #
    jr nz,lfb5eh        ;fb66 20 f6   20 f6     .
    cp 1bh              ;fb68 fe 1b   fe 1b   . .
    jr z,lfb76h         ;fb6a 28 0a   28 0a   ( .
    ld c,a              ;fb6c 4f   4f  O
conout_cbm:
    ld a,04h            ;fb6d 3e 04   3e 04   > .
    call cbm_srq        ;fb6f cd df fb   cd df fb    . . .
    ld a,c              ;fb72 79   79  y
    jp cbm_put_byte     ;fb73 c3 e5 fd   c3 e5 fd    . . .
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
    jr z,move_send      ;fb90 28 03   28 03   ( .
    ld a,e              ;fb92 7b   7b  {
    ld e,d              ;fb93 5a   5a  Z
    ld d,a              ;fb94 57   57  W

move_send:
    ld a,(0003h)        ;fb95 3a 03 00   3a 03 00    : . .
    and 03h             ;fb98 e6 03   e6 03   . .
    cp 01h              ;fb9a fe 01   fe 01   . .
    ret nz              ;fb9c c0   c0  .
    push de             ;fb9d d5   d5  .
    ld c,1bh            ;fb9e 0e 1b   0e 1b   . .
    call conout_cbm     ;fba0 cd 6d fb   cd 6d fb    . m .
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
    call conout_cbm     ;fbb3 cd 6d fb   cd 6d fb    . m .
    pop af              ;fbb6 f1   f1  .
    ld hl,0ea6ah        ;fbb7 21 6a ea   21 6a ea    ! j .
    sub (hl)            ;fbba 96   96  .
    and 1fh             ;fbbb e6 1f   e6 1f   . .
    or 20h              ;fbbd f6 20   f6 20   .
    ld c,a              ;fbbf 4f   4f  O
    jp conout_cbm       ;fbc0 c3 6d fb   c3 6d fb    . m .

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
    ld a,(0003h)        ;fc07 3a 03 00   3a 03 00    : . .
    and 0c0h            ;fc0a e6 c0   e6 c0   . .
    jp z,ser_out        ;fc0c ca cb fb   ca cb fb    . . .
    jp p,conout_cbm     ;fc0f f2 6d fb   f2 6d fb    . m .
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
    call delay_1ms      ;fc2c cd ee fa   cd ee fa    . . .
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
    call delay_1ms      ;fc44 cd ee fa   cd ee fa    . . .
    ld a,8dh            ;fc47 3e 8d   3e 8d   > .
    call wrieee         ;fc49 cd a6 fd   cd a6 fd    . . .
lfc4ch:
    ld a,11h            ;fc4c 3e 11   3e 11   > .
    call delay_1ms      ;fc4e cd ee fa   cd ee fa    . . .
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
    call delay_1ms      ;fc68 cd ee fa   cd ee fa    . . .
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
    call delay_1ms      ;fc95 cd ee fa   cd ee fa    . . .
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
    jp z,ser_out        ;fcc4 ca cb fb   ca cb fb    . . .
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
    jp z,ser_in         ;fcdc ca d6 fb   ca d6 fb    . . .
    ld de,(0ea62h)      ;fcdf ed 5b 62 ea   ed 5b 62 ea     . [ b .
    ld e,0ffh           ;fce3 1e ff   1e ff   . .
    call talk           ;fce5 cd 5d fa   cd 5d fa    . ] .
    call rdieee         ;fce8 cd 1c fe   cd 1c fe    . . .
    push af             ;fceb f5   f5  .
    call untalk         ;fcec cd 80 fa   cd 80 fa    . . .
    pop af              ;fcef f1   f1  .
    ret                 ;fcf0 c9   c9  .

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
    call wrieee         ;Send low byte of address
    ld a,h
    jp wrieee           ;Send high byte

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
