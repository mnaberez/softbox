;NEWSYS.COM
;  Configure SoftBox settings.
;
;Usage: "NEWSYS"
;
;This program was not written in assembly language.  It was written
;in MBASIC and compiled with BASCOM.  This is a disassembly of
;the compiled program.
;

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point
dma_buf:       equ  0080h ;Default DMA buffer area (128 bytes) for disk I/O
ccp_base:      equ 0d400h ;Start of CCP area
errbuf:        equ 0eac0h ;Last error message returned from CBM DOS
seldsk:        equ 0f01bh ;Select disk drive
settrk:        equ 0f01eh ;Set track number
setsec:        equ 0f021h ;Set sector number
read:          equ 0f027h ;Read selected sector
write:         equ 0f02ah ;Write selected sector
listen:        equ 0f033h ;Send LISTEN to an IEEE-488 device
unlisten:      equ 0f036h ;Send UNLISTEN to all IEEE-488 devices
talk:          equ 0f039h ;Send TALK to an IEEE-488 device
untalk:        equ 0f03ch ;Send UNTALK to all IEEE-488 devices
rdieee:        equ 0f03fh ;Read byte from an IEEE-488 device
wrieee:        equ 0f042h ;Send byte to an IEEE-488 device
wreoi:         equ 0f045h ;Send byte to IEEE-488 device with EOI asserted
creoi:         equ 0f048h ;Send carriage return to IEEE-488 dev with EOI
ieeemsg:       equ 0f04bh ;Send string to the current IEEE-488 device
ieeenum:       equ 0f04eh ;Send number as decimal string to IEEE-488 dev
tstdrv:        equ 0f051h ;Get drive type for a CP/M drive number
dskdev:        equ 0f054h ;Get device address for a CP/M drive number
diskcmd:       equ 0f057h ;Open the command channel on IEEE-488 device
dsksta:        equ 0f05ah ;Read the error channel of an IEEE-488 device
open:          equ 0f05dh ;Open a file on an IEEE-488 device
close:         equ 0f060h ;Close an open file on an IEEE-488 device
runcpm:        equ 0f075h ;Perform system init and then run CP/M
idrive:        equ 0f078h ;Initialize an IEEE-488 disk drive

cread:         equ 01h    ;Console Input
cwrite:        equ 02h    ;Console Output
cwritestr:     equ 09h    ;Output String
creadstr:      equ 0ah    ;Buffered Console Input

tab:           equ 09h    ;Tab
lf:            equ 0ah    ;Line Feed
cr:            equ 0dh    ;Carriage Return
cls:           equ 1ah    ;Clear Screen

    org 0100h

    jp start

    db 0,0,0,0,0,0,0

; Start of BASIC variables ==================================================

mini:
    dw 0                ;Mini-Winchester flag: 1=MW, 0=Corvus
iobyte:
    dw 0                ;Value to be stored in the CP/M IOBYTE

drv:
;Array of 11 integers (from 0 to 10)
    dw  0000h,  0000h,  0000h,  0000h,  0000h,  0000h,  7700h,  782bh
    dw 0caa7h,  2910h,  2bd1h

diskdev:
;Array of 11 integers (from 0 to 10)
    dw  2b72h,  3d73h,  07c2h, 0c129h, 0fb11h,  19ffh,  77f1h,  003eh
    dw  7723h, 0a72bh, 0c3c0h

autoload:
;Array of 121 integers (from 0 to 120)
    dw  2761h, 0fe7eh,  3701h, 0d5c0h,  11e5h,  0005h,  5e19h,  5623h
    dw 0fe1ah, 0c2ebh,  2945h,  1a13h,  07feh,  45cah,  2129h,  0004h
    dw  7e19h, 0d1e1h, 0c9a7h, 0d1e1h, 0c937h,  71cdh, 0d62eh, 0a7e7h
    dw 0cdc0h,  2730h, 0c9afh,  71cdh, 0fe2eh, 0c89fh,  9dfeh,  7ec9h
    dw  01feh, 0c037h, 0ebd5h,  0521h,  1900h,  237eh,  6f66h, 0fe7eh
    dw 0caedh,  2981h, 0ebfeh, 0c237h,  2981h,  7e23h, 0ee2bh, 0d607h
    dw  7e01h, 0d1ebh,  1ac9h,  7d77h,  4412h,  2313h,  771ah,  1278h
    dw 0c923h, 0cacdh, 0e72eh, 0f5c9h, 0cdebh,  273dh, 0cdf1h,  48beh
    dw  84c3h, 0e529h,  21d5h, 0ffd8h, 0eb39h, 0c32ah,  1916h, 0d13fh
    dw 0d0e1h,  053eh, 0c2c3h,  3a1fh,  12c4h,  01d6h, 0c6c2h,  3229h
    dw  12b6h,  023eh, 0c432h,  3a12h,  12c4h,  0006h,  02feh, 0d2cah
    dw  0629h, 0c520h, 0fdcdh, 0ca4ch,  2a4ah, 0e3f2h, 0f129h,  80f6h
    dw 0cdf5h,  4ce2h, 0c43ah, 0fe12h, 0ca02h,  2a2ch,  21f5h,  12bbh
    dw  6bcdh, 0cd4dh,  1f5eh, 0fbd2h, 0cd29h,  4e86h,  0721h, 0e52ah
    dw  57cdh, 0e14eh, 0c3c1h,  2a48h,  2ac1h,  12b5h,  78e5h,  04feh
    dw  1bcah

scrtab:
;Array of 65 integers (from 0 to 64)
    dw 0cd2ah,  4ea8h, 0eacdh, 0c34dh,  2a27h,  7ccdh,  214eh,  12bbh
    dw  2ecdh, 0cd4dh,  4d7dh, 0a7e1h,  48c2h, 0f12ah,  40f6h,  5df5h
    dw  1b54h, 0a37dh,  7c5fh, 0b3a2h,  48c2h,  062ah,  0510h, 0d229h
    dw  2a3eh, 0b0f1h,  10f6h, 0f1f5h, 0f1c9h, 0c9afh,  71cdh, 0fe2eh
    dw 0cce5h,  2730h,  2ec3h,  3e23h, 0cd34h,  2abah,  3ec3h,  1130h
    dw  1222h, 0d579h, 0c23dh,  2a64h,  50cdh,  1420h,  6fcdh, 0c92fh
    dw  7e23h, 0fe2bh, 0c207h,  2a8ch,  8778h,  83f2h,  782ah,  08f6h
    dw 0c947h,  50cdh,  0420h,  053eh, 0cecdh,  782bh,  08e6h,  9bcah
    dw 0cd2ah

bias:
    dw 2050h            ;Offset used to calculate start of buffer that
                        ;  stores the CP/M system data

loader:
    dw 3e04h            ;Start address of the buffer that holds the
                        ;  "loader" (terminal program "K" for the PET)

rr:
    dw 0c307h           ;First char of user input from any prompt,
                        ;  also used to store CP/M drive number
dt:
    dw 2bceh            ;Drive type (from dtypes table)
ee:
    dw 0e678h           ;Last error code from CBM DOS

dirsize:
    dw 47bfh            ;CCP directory width: 0=1 col, 1=2 cols, 3=4 cols
lpt:
    dw 20e6h            ;CBM printer (LPT:) IEEE-488 primary address
rdr:
    dw 0a9cah           ;Paper Tape Reader (PTR:) IEEE-488 primary address
pun:
    dw 3e2ah            ;Paper Tape Punch (PTP:) IEEE-488 primary address
uu:
    dw 0c304h           ;Byte that is written to 8251 USART mode register
baud:
    dw 2bceh            ;Byte that is written to COM8116 baud rate generator
ul1:
    dw 0e678h           ;ASCII printer (UL1:) IEEE-488 primary address
termtype:
    dw 0c804h           ;Terminal type: 0=ADM3A, 1=HZ1500, 2=TV912
                        ;  Bit 7 of low byte is set if uppercase mode
leadin:
    dw 7e23h            ;Terminal command lead-in: 1bh=escape, 7eh=tilde
order:
    dw 0fe2bh           ;X,Y order when sending move-to: 0=Y first, 1=X first
rowoff:
    dw 0c004h           ;Offset added to Y when sending move-to sequence
coloff:
    dw 053eh            ;Offset added to X when sending move-to sequence
jj:
    dw 0cec3h           ;Loop index
clock:
    dw 3e2bh            ;Frequency of PET system interrupt in Hz (50 or 60)
lptype:
    dw 0158h            ;CBM printer (LPT:) type: 0=3022, 3023, 4022, 4023
                        ;                         1=8026, 8027 (daisywheel)
                        ;                         2=8024
u1:
    dw 0007h            ;Temp variable used compare 8251 stop bits setting
nn:
    dw 16cdh            ;Integer parsed from user input
r1:
    dw 7327h            ;Temp variable that holds a copy of R
                        ;  (first char of user input)
dd:
    dw 7223h            ;CP/M drive number of current drive
l02deh:
    dw 0c32bh

buf:
    dw 275dh            ;Address of buffer used in readline

; End of BASIC variables ====================================================

    dw  57d5h
    dw  8287h
    dw 0db21h
    dw 0cd2ah

l02eah:
    dw  48beh           ;Temporary used for complex expression

    dw  235eh

start:
    ld hl,main          ;02ee 21 02 03
    jp ini              ;02f1 c3 27 2d

    db  9fh, 28h,0f0h, 14h,0a1h, 28h, 03h, 01h
    db 0e2h, 02h, 00h, 00h,0eeh, 02h

main:
    call n5_0           ;0302 cd 28 2d

    ;MINI = 0
    ld hl,0
    ld (mini),hl

    ;IOBYTE = 0
    ld hl,0
    ld (iobyte),hl

    ;BIAS = &H0C00
    ld hl,0c00h
    ld (bias),hl

    ;LOADER = &H6002
    ld hl,6002h
    ld (loader),hl

l031dh:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "CP/M  Reconfiguration"
    call pr0a
    ld hl,cpm_reconfig
    call pv2d

    ;PRINT "----  ---------------"
    call pr0a
    ld hl,dashes_3
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;IF MINI <> 1 THEN GOTO l0359h
    ld hl,(mini)
    ld de,-1
    add hl,de
    ld a,h
    or l
    jp nz,l0359h

    ;PRINT "Mini-winchester version"
    call pr0a
    ld hl,mw_version
    call pv2d

l0359h:
    ;PRINT "Revision 3   --   19 February 1982"
    call pr0a
    ld hl,rev_3_feb_1982
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Source drive (A to P) ? ";
    call pr0a
    ld hl,source_drv_a_p
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=0 THEN GOTO l0430h
    ld hl,(rr)
    ld a,h
    or l
    jp z,l0430h

    ;IF (R<&H41) or (R>&H50) THEN GOTO l031dh
    ld hl,(rr)
    ld de,0-'A'
    ld a,h
    rla
    jp c,l0395h
    add hl,de
    add hl,hl
l0395h:
    sbc a,a
    ld h,a
    ld l,a
    push hl
    ld hl,(rr)
    ld de,0-('P'+1)
    ld a,h
    rla
    jp c,l03a6h
    add hl,de
    add hl,hl
l03a6h:
    ccf
    sbc a,a
    ld h,a
    ld l,a
    pop de
    ld a,h
    or d
    ld h,a
    ld a,l
    or e
    ld l,a
    ld a,h
    or l
    jp nz,l031dh

    ;R = R - &H41
    ld de,0-'A'
    ld hl,(rr)
    add hl,de
    ld (rr),hl

    ;DT = R
    ld hl,(rr)
    ld (dt),hl

    ;CALL DTYPE (DT)
    ld hl,dt
    call dtype

    ;IF DT > 128 THEN GOTO l031dh 'Unassigned drive

    ld hl,(dt)
    ld de,-129
    ld a,h
    rla
    jp c,l03d9h
    add hl,de
    add hl,hl
l03d9h:
    jp nc,l031dh

    ;IF (DT>=2) AND (DT <=9) THEN CALL CREAD(R): GOTO 300 ' Corvus drive
    ld hl,(dt)          ;HL=(dt)
    ld de,-2            ;DE=-2
    ld a,h
    rla
    jp c,l03e9h
    add hl,de
    add hl,hl
l03e9h:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    push hl             ;Save value
    ld hl,(dt)          ;HL=(dt)
    ld de,-10
    ld a,h
    rla
    jp c,l03fbh
    add hl,de
    add hl,hl
l03fbh:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    pop de              ;Restore value
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    ld a,h
    or l
    jp z,l0413h         ;IF HL = 0 THEN GOTO l0413h

    ;CALL CREAD(R)
    ld hl,rr
    call cread_

    ;GOTO l0430h
    jp l0430h

l0413h:
    ;CALL IDISK(R)
    ld hl,rr
    call idisk

    ;CALL RDSYS(R)
    ld hl,rr
    call rdsys

    ;CALL DSKERR (E)
    ld hl,ee
    call dskerr

    ;IF E = 0 THEN GOTO l0430h
    ld hl,(ee)
    ld a,h
    or l
    jp z,l0430h

    ;END
    call end

l0430h:
    ;DIRSIZE = PEEK (BIAS+&H38B2)
    ld de,38b2h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (dirsize),hl

    ;IOBYTE = PEEK (BIAS+&H4A60)
    ld de,4a60h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (iobyte),hl

    ;LPT = PEEK (BIAS+&H4A61)
    ld de,4a61h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (lpt),hl

    ;RDR = PEEK (BIAS+&H4A62)
    ld de,4a62h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (rdr),hl

    ;PUN = PEEK (BIAS+&H4A63)
    ld de,4a63h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (pun),hl

    ;U = PEEK (BIAS+&H4A64)
    ld de,4a64h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (uu),hl

    ;BAUD = PEEK (BIAS+&H4A65)
    ld de,4a65h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (baud),hl

    ;UL1 = PEEK (BIAS+&H4A66)
    ld de,4a66h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (ul1),hl

    ;TERMTYPE = PEEK (BIAS+&H4A67)
    ld de,4a67h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (termtype),hl

    ;LEADIN = PEEK (BIAS+&H4A68)
    ld de,4a68h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (leadin),hl

    ;ORDER = PEEK (BIAS+&H4A69)
    ld de,4a69h
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (order),hl

    ;ROWOFF = PEEK (BIAS+&H4A6A)
    ld de,4a6ah
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (rowoff),hl

    ;COLOFF = PEEK (BIAS+&H4A6B)
    ld de,4a6bh
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (coloff),hl

    ;FOR J = 0 TO 7
    ld hl,0
    jp l0517h

l04dfh:
    ;DRV(J)=PEEK (BIAS+&H4A70+J)
    ld hl,(bias)
    ex de,hl
    ld hl,(jj)
    add hl,de           ;HL=bias+jj
    ld de,4a70h         ;DE=4a70h
    push hl             ;Save value
    add hl,de           ;HL=HL+DE
    ld l,(hl)
    ld h,0              ;HL=(HL)
    push hl             ;Save value
    ld hl,(jj)
    add hl,hl           ;HL=jj*2
    ld (l02eah),hl      ;(l02eah)=HL
    ld de,drv
    add hl,de           ;HL=HL+drv
    pop de              ;Restore value
    ld (hl),e
    inc hl
    ld (hl),d           ;(HL)=DE

    ;DISKDEV(J)=PEEK(BIAS+&H4A78+J)
    ld de,4a78h         ;DE=4a78h
    pop hl              ;Restore value
    add hl,de           ;HL=HL+DE
    ld l,(hl)
    ld h,0              ;HL=(HL)
    push hl             ;Save value
    ld hl,(l02eah)      ;HL=(l02eah)
    ld de,diskdev
    add hl,de           ;HL=HL+diskdev
    pop de              ;Resrore value
    ld (hl),e
    inc hl
    ld (hl),d           ;(HL)=DE

    ;NEXT
    ld hl,(jj)          ;0513 2a d0 02
    inc hl              ;0516 23
l0517h:
    ld (jj),hl
    ld hl,(jj)
    ld de,-8
    ld a,h
    rla
    jp c,l0527h
    add hl,de
    add hl,hl
l0527h:
    jp c,l04dfh

    ;FOR J=0 TO 80
    ld hl,0
    jp l0550h

l0530h:
    ;AUTOLOAD (J)=PEEK (BIAS+&H3407+J)
    ld hl,(bias)
    ex de,hl
    ld hl,(jj)
    add hl,de
    ld de,3407h
    add hl,de           ;HL=bias+jj+3407h
    ld l,(hl)
    ld h,0              ;HL=(HL)
    push hl             ;Save value
    ld hl,(jj)
    add hl,hl
    ld de,autoload
    add hl,de           ;HL=jj*2+autoload
    pop de              ;Restore value
    ld (hl),e
    inc hl
    ld (hl),d           ;(HL)=DE

    ;NEXT
    ld hl,(jj)
    inc hl
l0550h:
    ld (jj),hl
    ld hl,(jj)
    ld de,-81
    ld a,h
    rla
    jp c,l0560h
    add hl,de
    add hl,hl
l0560h:
    jp c,l0530h

    ;FOR J=0 TO 63
    ld hl,0
    jp l0589h

l0569h:
    ;SCRTAB (J) = PEEK (BIAS+&H4A80+J)
    ld hl,(bias)
    ex de,hl
    ld hl,(jj)
    add hl,de
    ld de,4a80h
    add hl,de           ;HL=bias+jj+4a80h
    ld l,(hl)
    ld h,0              ;HL=(HL)
    push hl             ;Save value
    ld hl,(jj)
    add hl,hl
    ld de,scrtab
    add hl,de           ;HL=jj*2+scrtab
    pop de              ;Restore value
    ld (hl),e
    inc hl
    ld (hl),d           ;(HL)=DE

    ;NEXT
    ld hl,(jj)
    inc hl
l0589h:
    ld (jj),hl
    ld hl,(jj)
    ld de,-64
    ld a,h
    rla
    jp c,l0599h
    add hl,de
    add hl,hl
l0599h:
    jp c,l0569h

    ;CLOCK=PEEK (LOADER+3)
    ld hl,(loader)
    inc hl
    inc hl
    inc hl
    ld l,(hl)
    ld h,0
    ld (clock),hl

    ;LPTYPE = PEEK (BIAS+&H4A6D)
    ld de,4a6dh
    ld hl,(bias)
    add hl,de
    ld l,(hl)
    ld h,0
    ld (lptype),hl

main_menu:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "CP/M  Re-configuration"
    call pr0a
    ld hl,cpm_reconfig_2
    call pv2d

    ;PRINT "----  ----------------"
    call pr0a
    ld hl,dashes_4
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "A - Autoload command"
    call pr0a
    ld hl,a_autoload
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "D - Disk drive assignment"
    call pr0a
    ld hl,d_drv_asgn
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "I - I/O assignment"
    call pr0a
    ld hl,i_io_asgn
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "P - PET terminal parameters"
    call pr0a
    ld hl,p_pet_term
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "R - RS232 characteristics"
    call pr0a
    ld hl,r_rs232
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "S - Save new system"
    call pr0a
    ld hl,s_save
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "E - Execute new system"
    call pr0a
    ld hl,e_execute
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Q - Quit this program"
    call pr0a
    ld hl,q_quit
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Please enter the appropriate letter : "
    call pr0a
    ld hl,pls_letter
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=&H52 THEN GOTO rs232_menu
    ld hl,(rr)
    ld de,0-'R'
    add hl,de
    ld a,h
    or l
    jp z,rs232_menu

    ;IF R<>&H51 THEN GOTO l0693h
    ld hl,(rr)
    ld de,0-'Q'
    add hl,de
    ld a,h
    or l
    jp nz,l0693h

    ;END
    call end

l0693h:
    ;IF R=&H49 THEN GOTO io_menu
    ld hl,(rr)
    ld de,0-'I'
    add hl,de
    ld a,h
    or l
    jp z,io_menu

    ;IF R=&H44 THEN GOTO drive_menu
    ld hl,(rr)
    ld de,0-'D'
    add hl,de
    ld a,h
    or l
    jp z,drive_menu

    ;IF R=&H41 THEN GOTO autoload_menu
    ld hl,(rr)
    ld de,0-'A'
    add hl,de
    ld a,h
    or l
    jp z,autoload_menu

    ;IF R=&H45 THEN GOTO exec_or_save
    ld hl,(rr)
    ld de,0-'E'
    add hl,de
    ld a,h
    or l
    jp z,exec_or_save

    ;IF R=&H53 THEN GOTO exec_or_save
    ld hl,(rr)
    ld de,0-'S'
    add hl,de
    ld a,h
    or l
    jp z,l1668h
    ld hl,(rr)

    ;IF R=&H50 THEN GOTO pet_menu
    ld de,0-'P'
    add hl,de
    ld a,h
    or l
    jp z,pet_menu

    ;GOTO main_menu
    jp main_menu

rs232_menu:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "           RS232 Characteristics"
    call pr0a
    ld hl,rs232_chrs
    call pv2d

    ;PRINT "           ----- ---------------"
    call pr0a
    ld hl,dashes_5
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT " 1.  Character size :          ";
    call pr0a
    ld hl,rs232_1_chr
    call pv1d

    ;PRINT CHR$((U AND 12)\4 + &H35)
    call pr0a
    ld hl,(uu)          ;HL=(uu)
    ld a,l
    and 0ch
    ld l,a
    ld a,h
    and 00h
    ld h,a              ;HL=HL and 000ch
    call idva           ;HL=HL/4
    dw 4
    ld de,'5'
    add hl,de           ;HL=HL+35h
    call chr
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;" 2.  Number of stop bits :     ";
    call pr0a
    ld hl,rs232_2_stop
    call pv1d

    ;U1 = U AND &HC0
    ld hl,(uu)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (u1),hl

    ;IF U1 <> 0 THEN GOTO l0753h
    ld hl,(u1)
    ld a,h
    or l
    jp nz,l0753h

    ;PRINT "undefined"
    call pr0a
    ld hl,undefined
    call pv2d

l0753h:
    ;IF U1 <> &H40 THEN GOTO l0768h
    ld hl,(u1)
    ld de,0-40h
    add hl,de
    ld a,h
    or l
    jp nz,l0768h

    ;PRINT "1"
    call pr0a
    ld hl,one
    call pv2d

l0768h:
    ;IF U1 <> &H80 THEN GOTO l077dh
    ld hl,(u1)
    ld de,0-80h
    add hl,de
    ld a,h
    or l
    jp nz,l077dh

    ;PRINT "1.5"
    call pr0a
    ld hl,one_dot_five
    call pv2d

l077dh:
    ;IF U1 <> &HC0 THEN GOTO l0792h
    ld hl,(u1)
    ld de,0-0c0h
    add hl,de
    ld a,h
    or l
    jp nz,l0792h

    ;PRINT "2"
    call pr0a
    ld hl,two
    call pv2d

l0792h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT " 3.  Parity :                  ";
    call pr0a
    ld hl,rs232_3_par
    call pv1d

    ;IF (U AND &H10) <> 0 THEN GOTO l07bdh
    ld hl,(uu)
    ld a,l
    and 10h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l07bdh

    ;PRINT "none"
    call pr0a
    ld hl,none
    call pv2d

l07bdh:
    ;IF (U AND &H30) <> &H30 THEN GOTO l07dah
    ld hl,(uu)
    ld a,l
    and 30h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-30h
    add hl,de
    ld a,h
    or l
    jp nz,l07dah

    ;PRINT "even"
    call pr0a
    ld hl,even
    call pv2d

l07dah:
    ;IF (U AND &H30) <> &H10 THEN GOTO l07f7h
    ld hl,(uu)
    ld a,l
    and 30h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-10h
    add hl,de
    ld a,h
    or l
    jp nz,l07f7h

    ;PRINT "odd"
    call pr0a
    ld hl,odd
    call pv2d

l07f7h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

l0800h:
    ;PRINT " 4.  Baud rate :               "
    call pr0a
    ld hl,rs232_4_baud
    call pv1d

    ;IF BAUD <> &H22 THEN GOTO l081eh
    ld hl,(baud)
    ld de,0-22h
    add hl,de
    ld a,h
    or l
    jp nz,l081eh

    ;PRINT "110"
    call pr0a
    ld hl,baud_110
    call pv2d

l081eh:
    ;IF BAUD <> &H55 THEN GOTO l0833h
    ld hl,(baud)
    ld de,0-55h
    add hl,de
    ld a,h
    or l
    jp nz,l0833h

    ;PRINT "300"
    call pr0a
    ld hl,baud_300
    call pv2d

l0833h:
    ;IF BAUD <> &H77 THEN GOTO l0848h
    ld hl,(baud)
    ld de,0-77h
    add hl,de
    ld a,h
    or l
    jp nz,l0848h

    ;PRINT "1200"
    call pr0a
    ld hl,baud_1200
    call pv2d

l0848h:
    ;IF BAUD <> &HEE THEN GOTO l085dh
    ld hl,(baud)
    ld de,0-0eeh
    add hl,de
    ld a,h
    or l
    jp nz,l085dh

    ;PRINT "9600"
    call pr0a
    ld hl,baud_9600
    call pv2d

l085dh:
    ;IF BAUD <> &HFF THEN GOTO l0872h
    ld hl,(baud)
    ld de,0-0ffh
    add hl,de
    ld a,h
    or l
    jp nz,l0872h

    ;PRINT "19200"
    call pr0a
    ld hl,baud_19200
    call pv2d

l0872h:
    ;IF BAUD <> &HCC THEN GOTO l0887h
    ld hl,(baud)
    ld de,0-0cch
    add hl,de
    ld a,h
    or l
    jp nz,l0887h

    ;PRINT "4800"
    call pr0a
    ld hl,baud_4800
    call pv2d

l0887h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which characteristic (1-4) ? "
    call pr0a
    ld hl,alter_chr_1_4
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=&H31 THEN GOTO l08d7h
    ld hl,(rr)
    ld de,0-'1'
    add hl,de
    ld a,h
    or l
    jp z,l08d7h

    ;IF R=0 THEN GOTO main_menu
    ld hl,(rr)
    ld a,h
    or l
    jp z,main_menu

    ;IF R=&H32 THEN GOTO l0930h
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp z,l0930h

    ;IF R=&H33 THEN GOTO l0983h
    ld hl,(rr)
    ld de,0-'3'
    add hl,de
    ld a,h
    or l
    jp z,l0983h

    ;IF R=&H34 THEN GOTO l09e8h
    ld hl,(rr)
    ld de,0-'4'
    add hl,de
    ld a,h
    or l
    jp z,l09e8h

    ;GOTO rs232_menu
    jp rs232_menu

l08d7h:
    ;PRINT "New character length (5 to 8) ? "
    call pr0a
    ld hl,new_char_len
    call pv1d

    ;GOSUB readline
    call readline

    ;R = R - &H35
    ld de,0-35h
    ld hl,(rr)
    add hl,de
    ld (rr),hl

    ;IF NOT((R>=0) AND (R<4)) THEN GOTO l092dh
    ld hl,(rr)
    add hl,hl           ;HL=(rr)*2
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=0
    push hl             ;Save value
    ld hl,(rr)          ;HL=(rr)
    ld de,-4            ;DE=-4
    ld a,h
    rla
    jp c,l0903h
    add hl,de
    add hl,hl
l0903h:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    pop de              ;Restore value
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    ld a,h
    or l
    jp z,l092dh         ;IF HL = 0 THEN GOTO l092dh

    ;U=(U AND &HF3) OR (R*4)
    ld hl,(uu)          ;HL=(uu)
    ld a,l
    and 0f3h
    ld l,a
    ld a,h
    and 00h
    ld h,a              ;HL=HL and 00f3h
    push hl             ;Save value
    ld hl,(rr)
    add hl,hl
    add hl,hl           ;HL=(rr)*4
    pop de              ;Restore value
    ld a,h
    or d
    ld h,a
    ld a,l
    or e
    ld l,a              ;HL=HL or DE
    ld (uu),hl          ;(uu)=HL

l092dh:
    ;GOTO rs232_menu
    jp rs232_menu

l0930h:
    ;PRINT "Number of stop bits (1 or 2)  ? ";
    call pr0a
    ld hl,num_stop_bits
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H31 THEN GOTO l095eh
    ld hl,(rr)
    ld de,0-'1'
    add hl,de
    ld a,h
    or l
    jp nz,l095eh

    ;U = (U AND &H3F) OR &H40
    ld hl,(uu)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 40h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (uu),hl

l095eh:
    ;IF R<>&H32 THEN GOTO l0980h
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp nz,l0980h

    ;U = (U AND &H3F) OR &HC0
    ld hl,(uu)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 0c0h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (uu),hl

l0980h:
    ;GOTO rs232_menu
    jp rs232_menu

l0983h:
    ;PRINT "O(dd), E(ven) or N(o parity) ? ";
    call pr0a
    ld hl,odd_even_none
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H4F THEN GOTO l09b1h
    ld hl,(rr)
    ld de,0-'O'
    add hl,de
    ld a,h
    or l
    jp nz,l09b1h

    ;U = (U AND &HCF) OR &H10
    ld hl,(uu)
    ld a,l
    and 0cfh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 10h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (uu),hl

l09b1h:
    ;IF R <> &H45 THEN GOTO l09cbh
    ld hl,(rr)
    ld de,0-'E'
    add hl,de
    ld a,h
    or l
    jp nz,l09cbh

    ;U = U OR &H30
    ld hl,(uu)
    ld a,l
    or 30h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (uu),hl

l09cbh:
    ;IF R <> &H4E THEN GOTO l09e5h
    ld hl,(rr)
    ld de,0-'N'
    add hl,de
    ld a,h
    or l
    jp nz,l09e5h

    ;U = U AND &HEF
    ld hl,(uu)
    ld a,l
    and 0efh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (uu),hl

l09e5h:
    ;GOTO rs232_menu
    jp rs232_menu

l09e8h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "110, 300, 1200, 4800, 9600 or"
    call pr0a
    ld hl,ask_bauds
    call pv2d

    ;PRINT "19200 baud ? ";
    call pr0a
    ld hl,ask_19200
    call pv1d

    ;GOSUB readline
    call readline

    ;IF N <> 110 THEN GOTO l0a1bh
    ld hl,(nn)
    ld de,0-110
    add hl,de
    ld a,h
    or l
    jp nz,l0a1bh

    ;BAUD = &H22
    ld hl,0022h
    ld (baud),hl

    ;GOTO l0a2dh
    jp l0a2dh

l0a1bh:
    ;IF N <> 300 THEN GOTO l0a2dh
    ld hl,(nn)
    ld de,0-300
    add hl,de
    ld a,h
    or l
    jp nz,l0a2dh

    ;BAUD = &H55
    ld hl,0055h
    ld (baud),hl

l0a2dh:
    ;IF N <> 1200 THEN GOTO l0a54h
    ld hl,(nn)
    ld de,0-1200
    add hl,de
    ld a,h
    or l
    jp nz,l0a42h

    ;BAUD = &H77
    ld hl,0077h
    ld (baud),hl

    ;GOTO l0a54h
    jp l0a54h

l0a42h:
    ;IF N <> 9600 THEN GOTO l0a54h
    ld hl,(nn)
    ld de,0-9600
    add hl,de
    ld a,h
    or l
    jp nz,l0a54h

    ;BAUD = &HEE
    ld hl,00eeh
    ld (baud),hl

l0a54h:
    ;IF N <> 4800 THEN GOTO l0a66h
    ld hl,(nn)
    ld de,0-4800
    add hl,de
    ld a,h
    or l
    jp nz,l0a66h

    ;BAUD = &HCC
    ld hl,00cch
    ld (baud),hl

l0a66h:
    ;IF N <> 19200 THEN GOTO l0a78h
    ld hl,(nn)
    ld de,0-19200
    add hl,de
    ld a,h
    or l
    jp nz,l0a78h

    ;BAUD = &HFF
    ld hl,00ffh
    ld (baud),hl

l0a78h:
    ;GOTO rs232_menu
    jp rs232_menu

io_menu:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "             I/O device assignment"
    call pr0a
    ld hl,io_dev_asgn
    call pv2d

    ;PRINT "             --- ------ ----------"
    call pr0a
    ld hl,dashes_6
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "1.  Pet printer device # :    "; LPT
    call pr0a
    ld hl,io_lpt_device
    call pv1d
    ld hl,(lpt)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "2.  ASCII printer device # :  "; UL1
    call pr0a
    ld hl,io_ul1_device
    call pv1d
    ld hl,(ul1)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3.  Reader device # :         "; RDR
    call pr0a
    ld hl,io_rdr_device
    call pv1d
    ld hl,(rdr)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "4.  Punch device # :          "; PUN
    call pr0a
    ld hl,io_pun_device
    call pv1d
    ld hl,(pun)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "5.  Default LST: device :     ";
    call pr0a
    ld hl,io_lst_device
    call pv1d

    ;IF (IOBYTE AND &HC0) <> 0 THEN GOTO l0b1bh
    ld hl,(iobyte)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l0b1bh

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

l0b1bh:
    ;IF (IOBYTE AND &HC0) <> &H40 THEN GOTO l0b38h
    ld hl,(iobyte)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-40h
    add hl,de
    ld a,h
    or l
    jp nz,l0b38h

    ;PRINT "CRT:"
    call pr0a
    ld hl,crt
    call pv2d

l0b38h:
    ;IF (IOBYTE AND &HC0) <> &H80 THEN GOTO l0b55h
    ld hl,(iobyte)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-80h
    add hl,de
    ld a,h
    or l
    jp nz,l0b55h

    ;PRINT "LPT:"
    call pr0a
    ld hl,lpt_colon
    call pv2d

l0b55h:
    ;IF (IOBYTE AND &HC0) <> &HC0 THEN GOTO l0b72h
    ld hl,(iobyte)
    ld a,l
    and 0c0h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-0c0h
    add hl,de
    ld a,h
    or l
    jp nz,l0b72h

    ;PRINT "UL1:"
    call pr0a
    ld hl,ul1_colon
    call pv2d

l0b72h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "6.  Default RDR: device :     ";
    call pr0a
    ld hl,default_rdr
    call pv1d

    ;IF (IOBYTE AND &H0C) <> 0 THEN GOTO l0ba0h
    ld hl,(iobyte)
    ld a,l
    and 0ch
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l0ba0h

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

    ;GOTO l0ba9h
    jp l0ba9h

l0ba0h:
    ;PRINT "PTR:"
    call pr0a
    ld hl,ptr
    call pv2d

l0ba9h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "7.  Default PUN: device :     ";
    call pr0a
    ld hl,default_pun
    call pv1d

    ;IF (IOBYTE AND &H30) <> 0 THEN GOTO l0bd7h
    ld hl,(iobyte)
    ld a,l
    and 30h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l0bd7h

    ;PRINT "TTY:"
    call pr0a
    ld hl,tty
    call pv2d

    ;GOTO l0be0h
    jp l0be0h

l0bd7h:
    ;PRINT "PTP:"
    call pr0a
    ld hl,ptp
    call pv2d

l0be0h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "8.  PET printer type :        ";
    call pr0a
    ld hl,pet_prtr_type
    call pv1d

    ;IF LPTYPE <> 0 THEN GOTO l0c03h
    ld hl,(lptype)
    ld a,h
    or l
    jp nz,l0c03h

    ;PRINT "3022/4022"
    call pr0a
    ld hl,cbm_3022_2
    call pv2d

l0c03h:
    ;IF LPTYPE <> 1 THEN GOTO l0c18h
    ld hl,(lptype)
    ld de,0-1
    add hl,de
    ld a,h
    or l
    jp nz,l0c18h

    ;PRINT "8026/8027"
    call pr0a
    ld hl,daisywheel_2
    call pv2d

l0c18h:
    ;IF LPTYPE <> 2 THEN GOTO l0c2dh
    ld hl,(lptype)
    ld de,0-2
    add hl,de
    ld a,h
    or l
    jp nz,l0c2dh

    ;PRINT "8024"
    call pr0a
    ld hl,cbm8024_2
    call pv2d

l0c2dh:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which (1-8) ? ";
    call pr0a
    ld hl,alter_which_1_8
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=0 THEN GOTO main_menu
    ld hl,(rr)
    ld a,h
    or l
    jp z,main_menu

    ;IF R=&H36 THEN GOTO l0da5h
    ld hl,(rr)
    ld de,0-'6'
    add hl,de
    ld a,h
    or l
    jp z,l0da5h

    ;IF R=&H37 THEN GOTO l0df0h
    ld hl,(rr)
    ld de,0-'7'
    add hl,de
    ld a,h
    or l
    jp z,l0df0h

    ;IF R=&H35 THEN GOTO l0ce0h
    ld hl,(rr)
    ld de,0-'5'
    add hl,de
    ld a,h
    or l
    jp z,l0ce0h

    ;IF R=&H38 THEN GOTO l0e3bh
    ld hl,(rr)
    ld de,0-'8'
    add hl,de
    ld a,h
    or l
    jp z,l0e3bh

    ;R1 = R
    ld hl,(rr)
    ld (r1),hl

    ;PRINT "New device # ? "
    call pr0a
    ld hl,new_dev_num
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R1 <> &H31 THEN GOTO l0ca7h
    ld hl,(r1)
    ld de,0-"1"
    add hl,de
    ld a,h
    or l
    jp nz,l0ca7h

    ;LPT = N
    ld hl,(nn)
    ld (lpt),hl

l0ca7h:
    ;IF R1 <> &H32 THEN GOTO l0cb9h
    ld hl,(r1)
    ld de,0-"2"
    add hl,de
    ld a,h
    or l
    jp nz,l0cb9h

    ;UL1 = N
    ld hl,(nn)
    ld (ul1),hl

l0cb9h:
    ;IF R1 <> &H33 THEN GOTO l0ccbh
    ld hl,(r1)
    ld de,0-'3'
    add hl,de
    ld a,h
    or l
    jp nz,l0ccbh

    ;RDR = N
    ld hl,(nn)
    ld (rdr),hl

l0ccbh:
    ;IF R1 <> &H34 THEN GOTO l0cddh
    ld hl,(r1)
    ld de,0-'4'
    add hl,de
    ld a,h
    or l
    jp nz,l0cddh

    ;PUN = N
    ld hl,(nn)
    ld (pun),hl

l0cddh:
    ;GOTO io_menu
    jp io_menu

l0ce0h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "T(TY:) --  RS232 printer"
    call pr0a
    ld hl,tty_rs232
    call pv2d

    ;PRINT "C(RT:) --  PET screen"
    call pr0a
    ld hl,crt_pet_scrn
    call pv2d

    ;PRINT "L(PT:) --  PET IEEE printer"
    call pr0a
    ld hl,lpt_pet
    call pv2d

    ;PRINT "U(L1:) --  ASCII IEEE printer"
    call pr0a
    ld hl,ul1_ascii
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Which list device (T, C, L or U) ? "
    call pr0a
    ld hl,which_list_dev
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H54 THEN GOTO l0d3ch
    ld hl,(rr)
    ld de,0-'T'
    add hl,de
    ld a,h
    or l
    jp nz,l0d3ch

    ;IOBYTE = (IOBYTE AND &H3F)
    ld hl,(iobyte)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (iobyte),hl

l0d3ch:
    ;IF R<>&H43 THEN GOTO l0d5eh
    ld hl,(rr)
    ld de,0-'C'
    add hl,de
    ld a,h
    or l
    jp nz,l0d5eh

    ;IOBYTE = (IOBYTE AND &H3F) OR &H40
    ld hl,(iobyte)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 40h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0d5eh:
    ;IF R<>&H4C THEN GOTO l0d80h
    ld hl,(rr)
    ld de,0-'L'
    add hl,de
    ld a,h
    or l
    jp nz,l0d80h

    ;IOBYTE = (IOBYTE AND &H3F) OR &H80
    ld hl,(iobyte)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 80h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0d80h:
    ;IF R<>&H55 THEN GOTO l0da2h
    ld hl,(rr)
    ld de,0-'U'
    add hl,de
    ld a,h
    or l
    jp nz,l0da2h

    ;IOBYTE = (IOBYTE AND &H3F) OR &HC0
    ld hl,(iobyte)
    ld a,l
    and 3fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 0c0h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0da2h:
    ;GOTO io_menu
    jp io_menu

l0da5h:
    ;PRINT "T(TY:) or P(TR:) ? "
    call pr0a
    ld hl,tty_or_ptr
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H54 THEN GOTO l0dcbh
    ld hl,(rr)
    ld de,0-'T'
    add hl,de
    ld a,h
    or l
    jp nz,l0dcbh

    ;IOBYTE = (IOBYTE AND &H3F)
    ld hl,(iobyte)
    ld a,l
    and 0f3h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (iobyte),hl

l0dcbh:
    ;IF R<>&H50 THEN GOTO l0dcbh
    ld hl,(rr)
    ld de,0-'P'
    add hl,de
    ld a,h
    or l
    jp nz,l0dedh

    ;IOBYTE = (IOBYTE AND &HF3) OR &H04
    ld hl,(iobyte)
    ld a,l
    and 0f3h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 04h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0dedh:
    jp io_menu           ;0ded c3 7b 0a

l0df0h:
    ;PRINT "T(TY:) or P(TP:) ? ";
    call pr0a
    ld hl,tty_or_ptp
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H54 THEN GOTO l0e16h
    ld hl,(rr)
    ld de,0-'T'
    add hl,de
    ld a,h
    or l
    jp nz,l0e16h

    ;IOBYTE = (IOBYTE AND &HCF)
    ld hl,(iobyte)
    ld a,l
    and 0cfh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (iobyte),hl

l0e16h:
    ;IF R<>&H50 THEN GOTO l0e38h
    ld hl,(rr)
    ld de,0-'P'
    add hl,de
    ld a,h
    or l
    jp nz,l0e38h

    ;IOBYTE = (IOBYTE AND &HCF) OR &H10
    ld hl,(iobyte)
    ld a,l
    and 0cfh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 10h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (iobyte),hl

l0e38h:
    ;GOTO io_menu
    jp io_menu

l0e3bh:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3 = 3022, 3023, 4022 or 4023"
    call pr0a
    ld hl,cbm3022
    call pv2d

    ;PRINT "8 = 8024"
    call pr0a
    ld hl,cbm8024
    call pv2d

    ;PRINT "D = 8026 or 8027 (daisywheel)"
    call pr0a
    ld hl,daisywheel
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Which type of printer (3, 8 or D) ? ";
    call pr0a
    ld hl,which_printer
    call pv1d

    ;IF R<>&H33 THEN GOTO l0e86h
    call readline
    ld hl,(rr)
    ld de,0-'3'
    add hl,de
    ld a,h
    or l
    jp nz,l0e86h

    ;LPTYPE = 0
    ld hl,0000h
    ld (lptype),hl

l0e86h:
    ;IF R<>&H38 THEN GOTO l0e98h
    ld hl,(rr)
    ld de,0-'8'
    add hl,de
    ld a,h
    or l
    jp nz,l0e98h

    ;LPTYPE = 2
    ld hl,0002h
    ld (lptype),hl

l0e98h:
    ;IF R<>&H44 THEN GOTO l0eaah
    ld hl,(rr)
    ld de,0-'D'
    add hl,de
    ld a,h
    or l
    jp nz,l0eaah

    ;LPTYPE = 1
    ld hl,0001h
    ld (lptype),hl

l0eaah:
    ;GOTO io_menu
    jp io_menu

drive_menu:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "            Disk drive assignment"
    call pr0a
    ld hl,drv_assgnmt
    call pv2d

    ;PRINT "            ---- ----- ----------"
    call pr0a
    ld hl,dashes_2
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "A, B :     ";
    call pr0a
    ld hl,drives_a_b
    call pv1d

    ;D = 0
    ld hl,0000h
    ld (dd),hl

    ;GOSUB sub_119ah
    call sub_119ah

    ;PRINT "C, D :     "
    call pr0a
    ld hl,drives_c_d
    call pv1d

    ;D = 1
    ld hl,0001h
    ld (dd),hl

    ;GOSUB sub_119ah
    call sub_119ah

    ;PRINT "E, F :     ";
    call pr0a
    ld hl,drives_e_f
    call pv1d

    ;D = 2
    ld hl,0002h
    ld (dd),hl

    ;GOSUB sub_119ah
    call sub_119ah

    ;PRINT "G, H :     ";
    call pr0a
    ld hl,drives_g_h
    call pv1d

    ;D = 3
    ld hl,0003h
    ld (dd),hl

    ;GOSUB sub_119ah
    call sub_119ah

    ;PRINT "I, J :     ";
    call pr0a
    ld hl,drives_i_j
    call pv1d

    ;D = 4
    ld hl,0004h
    ld (dd),hl

    ;GOSUB sub_119ah
    call sub_119ah

    ;PRINT "K, L :     ";
    call pr0a
    ld hl,drives_k_l
    call pv1d

    ;D = 5
    ld hl,0005h
    ld (dd),hl

    ;GOSUB sub_119ah
    call sub_119ah

    ;PRINT "M, N :     ";
    call pr0a
    ld hl,drives_m_n
    call pv1d

    ;D = 6
    ld hl,0006h
    ld (dd),hl

    ;GOSUB sub_119ah
    call sub_119ah

    ;"O, P :     ";
    call pr0a
    ld hl,drives_o_p
    call pv1d

    ;D = 7
    ld hl,0007h
    ld (dd),hl

    ;GOSUB sub_119ah
    call sub_119ah

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which drive pair (A to O) ? ";
    call pr0a
    ld hl,alter_which_pair
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=0 THEN GOTO main_menu
    ld hl,(rr)
    ld a,h
    or l
    jp z,main_menu

    ;IF (R < &H41) OR (R > &H50) THEN GOTO drive_menu
    ld hl,(rr)          ;HL=(rr)
    ld de,0-'A'         ;DE=-41h
    ld a,h
    rla
    jp c,l0f85h
    add hl,de
    add hl,hl
l0f85h:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    push hl             ;Save value
    ld hl,(rr)          ;HL=(rr)
    ld de,0-('P'+1)     ;-51h
    ld a,h
    rla
    jp c,l0f96h
    add hl,de
    add hl,hl
l0f96h:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    pop de              ;Restore value
    ld a,h
    or d
    ld h,a
    ld a,l
    or e
    ld l,a              ;HL=HL or DE
    ld a,h
    or l
    jp nz,drive_menu

    ;D=(R-&H41)\2
    ld de,0-'A'
    ld hl,(rr)
    add hl,de           ;HL=(rr)-41h
    call idva           ;HL=HL/2
    dw 2
    ld (dd),hl          ;(dd)=HL

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3(040), 8(050), h(ard) or u(nused) ? "
    call pr0a
    ld hl,cbm_hard_unused
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H33 THEN GOTO l0fe7h
    ld hl,(rr)
    ld de,0-'3'         ;3(040)
    add hl,de
    ld a,h
    or l
    jp nz,l0fe7h

    ;DRV(D) = 0  ' 3040
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,0
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l0fe7h:
    ;IF R <> &H38 THEN GOTO l1004h
    ld hl,(rr)
    ld de,0-'8'         ;8(050)
    add hl,de
    ld a,h
    or l
    jp nz,l1004h

    ;DRV(D) = 1  ' 8050
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,1
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l1004h:
    ;IF R <> &H55 THEN GOTO l1021h
    ld hl,(rr)
    ld de,0-'U'         ;u(nused)
    add hl,de
    ld a,h
    or l
    jp nz,l1021h

    ;DRV(D) = 255  ' unused
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,255
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO drive_menu
    jp drive_menu

l1021h:
    ;IF R <> &H48 THEN GOTO drive_menu  ' h(ard)
    ld hl,(rr)
    ld de,0-'H'         ;(h)ard
    add hl,de
    ld a,h
    or l
    jp nz,drive_menu

    ;IF MINI = 1 THEN GOTO l10fbh
    ld hl,(mini)
    ld de,0-1
    add hl,de
    ld a,h
    or l
    jp z,l10fbh

    ;PRINT "5, 10 or 20 Mbyte drive ? ";
    call pr0a
    ld hl,drv_5_10_20
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H35 THEN GOTO l1062h
    ld hl,(rr)
    ld de,0-'5'         ;5 Mbyte
    add hl,de
    ld a,h
    or l
    jp nz,l1062h

    ;DRV(D) = 4  ' Corvus 5 Mbyte
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,4
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l1062h:
    ;IF R <> &H31 THEN GOTO l107fh
    ld hl,(rr)
    ld de,0-'1'         ;10 Mbyte
    add hl,de
    ld a,h
    or l
    jp nz,l107fh

    ;DRV(D) = 2  ' Corvus 10 Mbyte
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,2
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l107fh:
    ;IF R <> &H32 THEN GOTO l109ch
    ld hl,(rr)
    ld de,0-'2'         ;20 Mbyte
    add hl,de
    ld a,h
    or l
    jp nz,l109ch

    ;DRV(D) = 3  ' Corvus 20 Mbyte
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,3
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l109fh
    jp l109fh

l109ch:
    ;GOTO drive_menu
    jp drive_menu

l109fh:
    ;PRINT "Device number for drive ? ";
    call pr0a
    ld hl,dev_num_for_drv
    call pv1d

    ;GOSUB readline
    call readline

    ;DISKDEV(D) = N
    ld hl,(dd)
    add hl,hl
    ld de,diskdev
    add hl,de
    push hl
    ld hl,(nn)
    ex de,hl
    pop hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl

    ;IF DRV(D) <> 4 THEN GOTO drive_menu
    ld de,0-4
    add hl,de
    ld a,h
    or l
    jp nz,drive_menu

    ;PRINT "Configure as 1 or 2 CP/M drives ? ";
    call pr0a
    ld hl,config_as_1_or_2
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H32 THEN GOTO l10f8h
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp nz,l10f8h

    ;DRV(D) = 5
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,5
    ld (hl),e
    inc hl
    ld (hl),d

l10f8h:
    ;GOTO drive_menu
    jp drive_menu

l10fbh:
    ;REM The system is a Mini-Winchester (Konan David Jr) not Corvus

    ;PRINT "3, 6 or 12 Mbyte drive ? ";
    call pr0a
    ld hl,drv_3_6_12
    call pv1d

    ;GOSUB readline
    call readline

    ;IF N <> 3 THEN GOTO l1124h
    ld hl,(nn)
    ld de,0-3
    add hl,de
    ld a,h
    or l
    jp nz,l1124h

    ;REM User selected 3 for MW-1000 3 Mbyte

    ;DRV(D) = 2 ' MW-1000 3 Mbyte
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,2
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l1161h
    jp l1161h

l1124h:
    ;IF N <> 6 THEN GOTO l1141h
    ld hl,(nn)
    ld de,0-6
    add hl,de
    ld a,h
    or l
    jp nz,l1141h

    ;REM User selected 6 for MW-1000 6 Mbyte

    ;DRV(D) = 3 ' MW-1000 6 Mbyte
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,3
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l1161h
    jp l1161h

l1141h:
    ;IF N <> 12 THEN GOTO l115eh
    ld hl,(nn)
    ld de,0-12
    add hl,de
    ld a,h
    or l
    jp nz,l115eh

    ;REM User selected 12 for MW-1000 12 Mbyte

    ;DRV(D) = 4 ' MW-1000 12 Mbyte
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld de,4
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO l1161h
    jp l1161h

l115eh:
    ;GOTO drive_menu
    jp drive_menu

l1161h:
    ;PRINT "Use the ENTIRE drive for CP/M,  or just"
    call pr0a
    ld hl,use_entire_drv
    call pv2d

    ;PRINT "use the FIRST HALF (E/H)  ? ";
    call pr0a
    ld hl,use_first_half
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H48 THEN GOTO l1197h
    ld hl,(rr)
    ld de,0-'H'
    add hl,de
    ld a,h
    or l
    jp nz,l1197h

    ;REM User selected 'H' for use first half for CP/M

    ;REM Add 3 to convert drive types from full to half:
    ;REM   type 2 (3 Mbyte full CP/M)  => type 5 (3 Mbyte half CP/M)
    ;REM   type 3 (6 Mbyte full CP/M)  => type 6 (6 Mbyte half CP/M)
    ;REM   type 4 (12 Mbyte full CP/M) => type 7 (12 Mbyte half CP/M)

    ;DRV(D) = DRV(D) + 3
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    push hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    inc hl
    inc hl
    inc hl
    ex de,hl
    pop hl
    ld (hl),e
    inc hl
    ld (hl),d

l1197h:
    ;GOTO drive_menu
    jp drive_menu

sub_119ah:
    ;IF DRV(D) <> 0 THEN GOTO l11b7h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld a,h
    or l
    jp nz,l11b7h

    ;PRINT "3040/4040  ";
    call pr0a
    ld hl,cbm_3040
    call pv1d

    ;GOTO l1285h
    jp l1285h

l11b7h:
    ;IF DRV(D) <> 1 THEN GOTO l11d9h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-1
    add hl,de
    ld a,h
    or l
    jp nz,l11d9h

    ;PRINT "8050       ";
    call pr0a
    ld hl,cbm_8050
    call pv1d

    ;GOTO l1285h
    jp l1285h

l11d9h:
    ;IF DRV(D) < 129 THEN GOTO l11fdh
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-129
    ld a,h
    rla
    jp c,l11f0h
    add hl,de
    add hl,hl
l11f0h:
    jp c,l11fdh

    ;PRINT "not used"
    call pr0a
    ld hl,not_used
    call pv2d

    ;RETURN
    ret

l11fdh:
    ;IF MINI = 1 THEN GOTO l129eh
    ld hl,(mini)
    ld de,0-1
    add hl,de
    ld a,h
    or l
    jp z,l129eh

    ;IF DRV(D) <> 2 THEN GOTO l1228h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-2
    add hl,de
    ld a,h
    or l
    jp nz,l1228h

    ;PRINT "Corvus 10Mb"
    call pr0a
    ld hl,cor_10mb
    call pv1d

l1228h:
    ;IF DRV(D) <> 3 THEN GOTO l1247h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-3
    add hl,de
    ld a,h
    or l
    jp nz,l1247h

    ;PRINT "Corvus 20Mb"
    call pr0a
    ld hl,cor_20mb
    call pv1d

l1247h:
    ;IF DRV(D) <> 4 THEN GOTO l1266h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-4
    add hl,de
    ld a,h
    or l
    jp nz,l1266h

    ;PRINT "Corvus 5Mb ";
    call pr0a
    ld hl,cor_5mb
    call pv1d

l1266h:
    ;IF DRV(D) <> 5 THEN GOTO l1285h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-5
    add hl,de
    ld a,h
    or l
    jp nz,l1285h

    ;PRINT "Corvus 5Mb*";
    call pr0a
    ld hl,cor_5mb_star
    call pv1d

l1285h:
    ;PRINT"   Device #", DISKDEV (D)
    call pr0a
    ld hl,device_num
    call pv0d
    ld hl,(dd)
    add hl,hl
    ld de,diskdev
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    call pv2c

    ;RETURN
    ret

l129eh:
    ;PRINT "Winchester    ";
    call pr0a
    ld hl,winchester
    call pv1d

    ;IF DRV(D) <> 2 THEN GOTO l12c6h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-2
    add hl,de
    ld a,h
    or l
    jp nz,l12c6h

    ;PRINT "3 Mbyte     "
    call pr0a
    ld hl,mw_3mb
    call pv2d

l12c6h:
    ;IF DRV(D) <> 3 THEN GOTO l12e5h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-3
    add hl,de
    ld a,h
    or l
    jp nz,l12e5h

    ;PRINT "6 Mbyte"
    call pr0a
    ld hl,mw_6mb
    call pv2d

l12e5h:
    ;IF DRV(D) <> 4 THEN GOTO l1304h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-4
    add hl,de
    ld a,h
    or l
    jp nz,l1304h

    ;PRINT "12 Mbyte     "
    call pr0a
    ld hl,mw_12mb
    call pv2d

l1304h:
    ;IF DRV(D) <> 5 THEN GOTO l1323h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-5
    add hl,de
    ld a,h
    or l
    jp nz,l1323h

    ;PRINT "3 Mbyte (half)"
    call pr0a
    ld hl,mw_3mb_half
    call pv2d

l1323h:
    ;IF DRV(D) <> 6 THEN GOTO l1342h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-6
    add hl,de
    ld a,h
    or l
    jp nz,l1342h

    ;PRINT "6 Mbyte (half)"
    call pr0a
    ld hl,mw_6mb_half
    call pv2d

l1342h:
    ;IF DRV(D) <> 7 THEN GOTO l1361h
    ld hl,(dd)
    add hl,hl
    ld de,drv
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl
    ld de,0-7
    add hl,de
    ld a,h
    or l
    jp nz,l1361h

    ;PRINT "12Mbyte (half)"
    call pr0a
    ld hl,mw_12mb_half
    call pv2d

l1361h:
    ;RETURN
    ret

autoload_menu:
    ;GOSUB clear_screen
    call clear_screen

    ;IF AUTOLOAD(0) <> 0 THEN GOTO l1379h
    ld hl,(autoload)
    ld a,h
    or l
    jp nz,l1379h

    ;PRINT "No current autoload command"
    call pr0a
    ld hl,no_aload_cmd
    call pv2d

    ;GOTO l13bfh
    jp l13bfh

l1379h:
    ;PRINT "Current autoload command is :"
    call pr0a
    ld hl,cur_aload_is
    call pv2d

    ;FOR J=1 TO AUTOLOAD(0)
    ld hl,(autoload)
    ld (l02deh),hl
    ld hl,1
    jp l13a7h

l138eh:
    ;PRINT CHR$(AUTOLOAD(J));
    call pr0a
    ld hl,(jj)
    add hl,hl
    ld de,autoload
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    call chr
    call pv1d

    ;NEXT
    ld hl,(jj)
    inc hl
l13a7h:
    ld (jj),hl
    ld hl,(jj)
    ex de,hl
    ld hl,(l02deh)
    ld a,d
    xor h
    ld a,h
    jp m,l13bbh
    ld a,l
    sub e
    ld a,h
    sbc a,d
l13bbh:
    rla
    jp nc,l138eh

l13bfh:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "New autoload command (Y/N) ? ";
    call pr0a
    ld hl,new_aload_yn
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R<>&H59 THEN GOTO main_menu
    ld hl,(rr)
    ld de,0-'Y'
    add hl,de
    ld a,h
    or l
    jp nz,main_menu

    ;PRINT "Please enter the new command : "
    call pr0a
    ld hl,new_command
    call pv2d

    ;GOSUB readline
    call readline

    ;AUTOLOAD(0) = PEEK(BUF+1)
    ld hl,(buf)
    inc hl
    ld l,(hl)
    ld h,0
    ld (autoload),hl

    ;FOR J = 1 TO 80
    ld hl,1
    jp l145ah

l13fch:
    ;AUTOLOAD(J) = PEEK(BUF+1+J)
    ld hl,(buf)
    ex de,hl
    ld hl,(jj)
    add hl,de
    inc hl              ;HL=buf+jj+1
    ld l,(hl)
    ld h,0              ;HL=PEEK(HL)
    push hl             ;Save value
    ld hl,(jj)
    add hl,hl
    ld de,autoload
    add hl,de           ;HL=jj*2+autoload
    pop de              ;Restore value
    ld (hl),e
    inc hl
    ld (hl),d           ;(HL)=DE

    ;IF NOT((AUTOLOAD(J) >= &H61) AND (AUTOLOAD(J) <= &H7A)) THEN GOTO l1456h
    ld hl,(jj)
    add hl,hl
    ld de,autoload
    add hl,de           ;HL=jj*2+autoload
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop hl              ;HL=(HL)
    push hl             ;Save HL for second expression part
    ld de,0-'a'         ;DE=-61h
    ld a,h
    rla
    jp c,l142dh
    add hl,de
    add hl,hl
l142dh:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    ld (l02eah),hl      ;(l02eah)=HL
    pop hl              ;Restore HL from first expression part
    ld de,0-('z'+1)     ;DE=-7bh
    ld a,h
    rla
    jp c,l143fh
    add hl,de
    add hl,hl
l143fh:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    push hl             ;Save HL
    ld hl,(l02eah)
    ex de,hl            ;DE=(l02eah)
    pop hl              ;Restore HL
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a               ;HL=HL and DE
    ld a,h
    or l
    jp z,l1456h          ;If HL=0 GOTO l1456h

    ;GOSUB sub_147eh ' Map to upper case
    call sub_147eh

l1456h:
    ;NEXT
    ld hl,(jj)
    inc hl
l145ah:
    ld (jj),hl
    ld hl,(jj)
    ld de,-81
    ld a,h
    rla
    jp c,l146ah
    add hl,de
    add hl,hl
l146ah:
    jp c,l13fch

    ;AUTOLOAD(AUTOLOAD(0)+1)=0
    ld hl,(autoload)
    add hl,hl
    ld de,autoload+2
    add hl,de
    ld de,0
    ld (hl),e
    inc hl
    ld (hl),d

    ;GOTO main_menu
    jp main_menu

sub_147eh:
    ;AUTOLOAD(J) = AUTOLOAD(J) - &H20
    ld hl,(jj)
    add hl,hl
    ld de,autoload
    add hl,de           ;HL=jj*2+autoload
    push hl             ;Save Address for saving data
    ld e,(hl)
    inc hl
    ld d,(hl)           ;DE=(HL)
    ld hl,0-('a'-'A')   ;HL=-20h
    add hl,de
    ex de,hl            ;DE=DE-HL
    pop hl              ;Restore Address
    ld (hl),e
    inc hl
    ld (hl),d           ;(HL)=DE

    ;RETURN
    ret

exec_or_save:
    ;GOSUB sub_149ah ' Poke back the configuration data
    call sub_149ah

    ;CALL EXSYS '(NEVER RETURNS)
    call exsys

sub_149ah:
    ;FOR J = 0 TO 7
    ld hl,0
    jp l14dah

l14a0h:
    ;POKE &H4A70+BIAS+J, DRV(J)
    ld hl,(jj)
    add hl,hl
    ld de,drv
    add hl,de           ;HL=jj*2+drv
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl            ;HL=(HL)
    push hl             ;Save Value
    ld hl,(bias)
    ex de,hl
    ld hl,(jj)
    add hl,de
    ld de,4a70h
    add hl,de           ;HL=bias+jj+4a70h
    pop de              ;Restore Value
    ld (hl),e           ;(HL)=E

    ;POKE &H4A78+BIAS+J, DISKDEV(J)
    ld hl,(jj)
    add hl,hl
    ld de,diskdev
    add hl,de           ;HL=jj*2+diskdev
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl            ;HL=(HL)
    push hl             ;Save Value
    ld hl,(bias)
    ex de,hl
    ld hl,(jj)
    add hl,de
    ld de,4a78h
    add hl,de           ;HL=bias+jj+4a78h
    pop de              ;Restore Value
    ld (hl),e           ;(HL)=E

    ;NEXT
    ld hl,(jj)
    inc hl
l14dah:
    ld (jj),hl
    ld hl,(jj)
    ld de,-8
    ld a,h
    rla
    jp c,l14eah
    add hl,de
    add hl,hl
l14eah:
    jp c,l14a0h

    ;GOTO l1525h
    jp l1525h

    db 9eh,28h

data_line:
    db " line 6540 +++++++++++++++++++++++++++++++++++++++",0

l1525h:
    ;POKE BIAS+&H4A60, IOBYTE
    ld hl,(iobyte)
    ld de,4a60h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A61, LPT
    ld hl,(lpt)
    ld de,4a61h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A62, RDR
    ld hl,(rdr)
    ld de,4a62h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A63, PUN
    ld hl,(pun)
    ld de,4a63h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A64, (U AND &HFC) OR 2  ' USART - set async. mode
    ld hl,(uu)          ;HL=(uu)
    ld a,l
    and 0fch
    ld l,a
    ld a,h
    and 0
    ld h,a              ;HL=HL and 00fch
    ld a,l
    or 2
    ld l,a
    ld a,h
    or 0
    ld h,a              ;HL=HL or 2
    ld de,4a64h
    push hl             ;Save value
    ld hl,(bias)
    add hl,de           ;HL=4a64h+bias
    pop de              ;Restore value
    ld (hl),e           ;(HL)=E

    ;POKE BIAS+&H4A65, BAUD
    ld hl,(baud)
    ld de,4a65h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A66, UL1
    ld hl,(ul1)
    ld de,4a66h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A67, TERMTYPE
    ld hl,(termtype)
    ld de,4a67h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A6D, LPTYPE
    ld hl,(lptype)
    ld de,4a6dh
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H38B2, DIRSIZE
    ld hl,(dirsize)
    ld de,38b2h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;FOR J = 0 TO 80
    ld hl,0
    jp l15dch

l15bdh:
    ;POKE BIAS+&H3407+J,AUTOLOAD(J)
    ld hl,(jj)
    add hl,hl
    ld de,autoload
    add hl,de           ;HL=jj*2+autoload
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl            ;HL=(HL)
    push hl             ;Save value
    ld hl,(bias)
    ex de,hl
    ld hl,(jj)
    add hl,de
    ld de,3407h
    add hl,de           ;HL=bias+jj+3407h
    pop de              ;Restore value
    ld (hl),e           ;(HL)=E

    ;NEXT
    ld hl,(jj)
    inc hl
l15dch:
    ld (jj),hl
    ld hl,(jj)
    ld de,-81
    ld a,h
    rla
    jp c,l15ech
    add hl,de
    add hl,hl
l15ech:
    jp c,l15bdh

    ;POKE BIAS+&H4A68, LEADIN
    ld hl,(leadin)
    ld de,4a68h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A69, ORDER
    ld hl,(order)
    ld de,4a69h
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A6A, ROWOFF
    ld hl,(rowoff)
    ld de,4a6ah
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;POKE BIAS+&H4A6B, COLOFF
    ld hl,(coloff)
    ld de,4a6bh
    push hl
    ld hl,(bias)
    add hl,de
    pop de
    ld (hl),e

    ;FOR J = 0 TO 63
    ld hl,0
    jp l1648h

l1629h:
    ;POKE BIAS+&H4A80+J, SCRTAB(J)
    ld hl,(jj)
    add hl,hl
    ld de,scrtab
    add hl,de           ;HL=jj*2+scrtab
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl            ;HL=(HL)
    push hl             ;Save value
    ld hl,(bias)
    ex de,hl
    ld hl,(jj)
    add hl,de
    ld de,4a80h
    add hl,de           ;HL=bias+jj+4a80h
    pop de              ;Restore value
    ld (hl),e           ;(HL)=E

    ;NEXT
    ld hl,(jj)
    inc hl
l1648h:
    ld (jj),hl
    ld hl,(jj)
    ld de,-64
    ld a,h
    rla
    jp c,l1658h
    add hl,de
    add hl,hl
l1658h:
    jp c,l1629h

    ;POKE LOADER+3, CLOCK
    ld hl,(clock)
    push hl
    ld hl,(loader)
    inc hl
    inc hl
    inc hl
    pop de
    ld (hl),e

    ;RETURN
    ret

l1668h:
    ;PRINT "Save on which drive (A to P) ? "
    call pr0a
    ld hl,save_on_which
    call pv1d

    ;GOSUB readline
    call readline

    ;IF (R < &H41) OR (R > &H50) THEN main_menu
    ld hl,(rr)          ;HL=(rr)
    ld de,0-'A'         ;DE=-41h
    ld a,h
    rla
    jp c,l1681h
    add hl,de
    add hl,hl
l1681h:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    push hl             ;Save HL for second expression part
    ld hl,(rr)          ;HL=(rr)
    ld de,0-('P'+1)     ;DE=-51h
    ld a,h
    rla
    jp c,l1692h
    add hl,de
    add hl,hl
l1692h:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    pop de              ;Restore HL from first expression part
    ld a,h
    or d
    ld h,a
    ld a,l
    or e
    ld l,a              ;HL=HL or DE
    ld a,h
    or l
    jp nz,main_menu     ;IF HL <> 0 THEN GOTO main_menu

    ;D = R - &H41
    ld de,0-'A'
    ld hl,(rr)
    add hl,de
    ld (dd),hl

    ;DT = D
    ld hl,(dd)
    ld (dt),hl

    ;CALL DTYPE (DT)
    ld hl,dt
    call dtype

    ;IF NOT(DT > 127) THEN GOTO l16d4h
    ld hl,(dt)
    ld de,0-(127+1)
    ld a,h
    rla
    jp c,l16c5h
    add hl,de
    add hl,hl
l16c5h:
    jp c,l16d4h

    ;PRINT "Drive not in system"
    call pr0a
    ld hl,no_drive
    call pv2d

    ;GOTO l1668h
    jp l1668h

l16d4h:
    ;GOSUB sub_149ah
    call sub_149ah

    ;IF NOT((DT >= 2) AND (DT <= 9)) THEN GOTO l170eh
    ld hl,(dt)          ;HL=(dt)
    ld de,-2            ;DE=-2
    ld a,h
    rla
    jp c,l16e4h
    add hl,de
    add hl,hl
l16e4h:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    push hl             ;Save HL for second expression part
    ld hl,(dt)          ;HL=(dt)
    ld de,-10
    ld a,h
    rla
    jp c,l16f6h
    add hl,de
    add hl,hl
l16f6h:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    pop de              ;Restore HL from first expression part
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    ld a,h
    or l
    jp z,l170eh         ;IF HL = 0 THEN GOTO l170eh

    ;CALL CWRITE (D)
    ld hl,dd
    call cwrite_

    ;GOTO main_menu
    jp main_menu

l170eh:
    ;CALL IDISK (D)
    ld hl,dd
    call idisk

    ;CALL SAVESY (D)
    ld hl,dd
    call savesy

    ;CALL DSKERR (E)
    ld hl,ee
    call dskerr

    ;IF E = 0 THEN GOTO main_menu
    ld hl,(ee)
    ld a,h
    or l
    jp z,main_menu

    ;PRINT "Re-try (Y/N) ? ";
    call pr0a
    ld hl,retry_yn
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R=&H59 THEN GOTO l170eh
    ld hl,(rr)
    ld de,0-'Y'
    add hl,de
    ld a,h
    or l
    jp z,l170eh

    ;GOTO main_menu
    jp main_menu

pet_menu:
    ;GOSUB clear_screen
    call clear_screen

    ;PRINT "      Pet terminal parameters"
    call pr0a
    ld hl,pet_params
    call pv2d

    ;PRINT "      --- -------- ----------"
    call pr0a
    ld hl,dashes
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "1.  Columns in DIR listing :   "
    call pr0a
    ld hl,cols_in_dir
    call pv1d

    ;IF DIRSIZE <> 0 THEN GOTO l177eh
    ld hl,(dirsize)
    ld a,h
    or l
    jp nz,l177eh

    ;PRINT "1"
    call pr0a
    ld hl,one
    call pv2d

    ;GOTO l179fh
    jp l179fh

l177eh:
    ;IF DIRSIZE <> 1 THEN GOTO l1796h
    ld hl,(dirsize)
    ld de,0-1
    add hl,de
    ld a,h
    or l
    jp nz,l1796h

    ;PRINT "2"
    call pr0a
    ld hl,two
    call pv2d

    ;GOTO l179fh
    jp l179fh

l1796h:
    ;PRINT "4"
    call pr0a
    ld hl,four
    call pv2d

l179fh:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "2.  CRT in upper case mode :   ";
    call pr0a
    ld hl,crt_in_upper
    call pv1d

    ;IF (TERMTYPE AND &H80) = 0 THEN GOTO l17cdh
    ld hl,(termtype)
    ld a,l
    and 80h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp z,l17cdh

    ;PRINT "yes"
    call pr0a
    ld hl,yes
    call pv2d

    ;GOTO l17d6h
    jp l17d6h

l17cdh:
    ;PRINT "no"
    call pr0a
    ld hl,no
    call pv2d

l17d6h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "3.  CRT terminal emulation :   ";
    call pr0a
    ld hl,crt_term_emu
    call pv1d

    ;IF (TERMTYPE AND &H7F) <> 0 THEN GOTO l1804h
    ld hl,(termtype)
    ld a,l
    and 7fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,l1804h

    ;PRINT "ADM3A"
    call pr0a
    ld hl,adm3a
    call pv2d

    ;GOTO l1871h
    jp l1871h

l1804h:
    ;IF (TERMTYPE AND &H7F) <> 2 THEN GOTO l1824h
    ld hl,(termtype)
    ld a,l
    and 7fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-2
    add hl,de
    ld a,h
    or l
    jp nz,l1824h

    ;PRINT "TV912"
    call pr0a
    ld hl,tv912
    call pv2d

    ;GOTO l1871h
    jp l1871h

l1824h:
    ;IF (TERMTYPE AND &H7F) <> 1 THEN GOTO l1844h
    ld hl,(termtype)
    ld a,l
    and 7fh
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld de,0-1
    add hl,de
    ld a,h
    or l
    jp nz,l1844h

    ;PRINT "HZ1500"
    call pr0a
    ld hl,hz1500
    call pv2d

    ;GOTO l1871h
    jp l1847h

l1844h:
    ;GOTO l1871h
    jp l1871h

l1847h:
    ;IF LEADIN <> &H1B THEN GOTO l185ch
    ld hl,(leadin)
    ld de,0-1bh
    add hl,de
    ld a,h
    or l
    jp nz,l185ch

    ;PRINT "                   (Lead-in = ESCAPE)"
    call pr0a
    ld hl,leadin_esc
    call pv2d

l185ch:
    ;IF LEADIN <> &H7E THEN GOTO l1871h
    ld hl,(leadin)
    ld de,0-'~'
    add hl,de
    ld a,h
    or l
    jp nz,l1871h

    ;PRINT "<tab><tab>     (Lead-in = TILDE)"
    call pr0a
    ld hl,leadin_tilde
    call pv2d

l1871h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "4.  Clock frequency (Hz) :     "; CLOCK
    call pr0a
    ld hl,clock_freq
    call pv1d
    ld hl,(clock)
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Alter which (1-4) ? ";
    call pr0a
    ld hl,alter_which_1_4
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R = 0 THEN GOTO main_menu
    ld hl,(rr)
    ld a,h
    or l
    jp z,main_menu

    ;IF R = &H31 THEN GOTO l18eah
    ld hl,(rr)
    ld de,0-'1'
    add hl,de
    ld a,h
    or l
    jp z,l18eah

    ;IF R <> &H32 THEN GOTO l18cfh
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp nz,l18cfh

    ;TERMTYPE = (TERMTYPE XOR &H80)
    ld hl,(termtype)
    ld a,l
    xor 80h
    ld l,a
    ld a,h
    xor 00h
    ld h,a
    ld (termtype),hl

    ;GOTO pet_menu
    jp pet_menu

l18cfh:
    ;IF R = &H33 THEN GOTO l192fh
    ld hl,(rr)
    ld de,0-'3'
    add hl,de
    ld a,h
    or l
    jp z,l194ch

    ;IF R = &H34 THEN GOTO l192fh
    ld hl,(rr)
    ld de,0-'4'
    add hl,de
    ld a,h
    or l
    jp z,l192fh

    ;GOTO pet_menu
    jp pet_menu

l18eah:
    ;PRINT "Number of columns (1, 2 or 4) ? ";
    call pr0a
    ld hl,num_of_cols
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H31 THEN GOTO l1908h
    ld hl,(rr)
    ld de,0-'1'
    add hl,de
    ld a,h
    or l
    jp nz,l1908h

    ;DIRSIZE = 0
    ld hl,1-1
    ld (dirsize),hl

l1908h:
    ;IF R <> &H32 THEN GOTO l191ah
    ld hl,(rr)
    ld de,0-'2'
    add hl,de
    ld a,h
    or l
    jp nz,l191ah

    ;DIRSIZE = 1
    ld hl,2-1
    ld (dirsize),hl

l191ah:
    ;IF R <> &H34 THEN GOTO l192ch
    ld hl,(rr)
    ld de,0-'4'
    add hl,de
    ld a,h
    or l
    jp nz,l192ch

    ;DIRSIZE = 3
    ld hl,4-1
    ld (dirsize),hl

l192ch:
    ;GOTO pet_menu
    jp pet_menu

l192fh:
    ;PRINT "New clock frequency ? "
    call pr0a
    ld hl,new_clock
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R = 0 THEN GOTO l1949h
    ld hl,(rr)
    ld a,h
    or l
    jp z,l1949h

    ;CLOCK = N
    ld hl,(nn)
    ld (clock),hl

l1949h:
    ;GOTO pet_menu
    jp pet_menu

l194ch:
    ;PRINT "Screen type (ADM3A, HZ1500, TV912) ? ";
    call pr0a
    ld hl,screen_type
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H41 THEN GOTO l1975h
    ld hl,(rr)
    ld de,0-'A'
    add hl,de
    ld a,h
    or l
    jp nz,l1975h

    ;TERMTYPE = (TERMTYPE AND &H80)
    ld hl,(termtype)
    ld a,l
    and 80h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld (termtype),hl

    ;GOTO l1aa6h
    jp l1aa6h

l1975h:
    ;IF R <> &H54 THEN GOTO l199ah
    ld hl,(rr)
    ld de,0-'T'
    add hl,de
    ld a,h
    or l
    jp nz,l199ah

    ;TERMTYPE = (TERMTYPE AND &H80) OR 2
    ld hl,(termtype)
    ld a,l
    and 80h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 02h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (termtype),hl

    ;GOTO l1aa6h
    jp l1aa6h

l199ah:
    ;IF R <> &H48 THEN GOTO pet_menu
    ld hl,(rr)
    ld de,0-'H'
    add hl,de
    ld a,h
    or l
    jp nz,pet_menu

    ;PRINT "Lead-in code E(scape) or T(ilde) ? ";
    call pr0a
    ld hl,esc_or_tilde
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> &H45 THEN GOTO l19c7h
    ld hl,(rr)
    ld de,0-'E'
    add hl,de
    ld a,h
    or l
    jp nz,l19c7h

    ;LEADIN = &H1B
    ld hl,1bh
    ld (leadin),hl

    ;GOTO l19dfh
    jp l19dfh

l19c7h:
    ;IF R <> &H54 THEN GOTO l19dch
    ld hl,(rr)
    ld de,0-'T'
    add hl,de
    ld a,h
    or l
    jp nz,l19dch

    ;LEADIN = &H7E
    ld hl,7eh
    ld (leadin),hl

    ;GOTO l19dfh
    jp l19dfh

l19dch:
    ;GOTO pet_menu
    jp pet_menu

l19dfh:
    ;TERMTYPE = (TERMTYPE AND &H80) OR 1
    ld hl,(termtype)
    ld a,l
    and 80h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,l
    or 01h
    ld l,a
    ld a,h
    or 00h
    ld h,a
    ld (termtype),hl

    ;ROWOFF = 0 : COLOFF = 0
    ld hl,0
    ld (rowoff),hl
    ld (coloff),hl

    ;ORDER = 1
    ld hl,1
    ld (order),hl

    ;SCRTAB(0) = &H8B
    ld hl,8bh
    ld (scrtab+0),hl

    ;SCRTAB(1) = &H0B
    ld hl,0bh
    ld (scrtab+2),hl

    ;SCRTAB(2) = &H8C
    ld hl,8ch
    ld (scrtab+4),hl

    ;SCRTAB(3) = &H0C
    ld hl,0ch
    ld (scrtab+6),hl

    ;SCRTAB(4) = &H8F
    ld hl,8fh
    ld (scrtab+8),hl

    ;SCRTAB(5) = &H13
    ld hl,13h
    ld (scrtab+10),hl

    ;SCRTAB(6) = &H91
    ld hl,91h
    ld (scrtab+12),hl

    ;SCRTAB(7) = &H1B
    ld hl,1bh
    ld (scrtab+14),hl

    ;SCRTAB(8) = &H92
    ld hl,92h
    ld (scrtab+16),hl

    ;SCRTAB(9) = &H1E
    ld hl,1eh
    ld (scrtab+18),hl

    ;SCRTAB(10) = &H93
    ld hl,93h
    ld (scrtab+20),hl

    ;SCRTAB(11) = &H12
    ld hl,12h
    ld (scrtab+22),hl

    ;SCRTAB(12) = &H97
    ld hl,97h
    ld (scrtab+24),hl

    ;SCRTAB(13) = &H14
    ld hl,14h
    ld (scrtab+26),hl

    ;SCRTAB(14) = &H98
    ld hl,98h
    ld (scrtab+28),hl

    ;SCRTAB(15) = &H14
    ld hl,14h
    ld (scrtab+30),hl

    ;SCRTAB(16) = &H9A
    ld hl,9ah
    ld (scrtab+32),hl

    ;SCRTAB(17) = &H11
    ld hl,11h
    ld (scrtab+34),hl

    ;SCRTAB(18) = &H9C
    ld hl,9ch
    ld (scrtab+36),hl

    ;SCRTAB(19) = &H1A
    ld hl,1ah
    ld (scrtab+38),hl

    ;SCRTAB(20) = &H9D
    ld hl,9dh
    ld (scrtab+40),hl

    ;SCRTAB(21) = &H1A
    ld hl,1ah
    ld (scrtab+42),hl

    ;SCRTAB(22) = &H99
    ld hl,99h
    ld (scrtab+44),hl

    ;SCRTAB(23) = &H00
    ld hl,00h
    ld (scrtab+46),hl

    ;SCRTAB(24) = &H9F
    ld hl,9fh
    ld (scrtab+48),hl

    ;SCRTAB(25) = &H00
    ld hl,00h
    ld (scrtab+50),hl

    ;SCRTAB(26) = &H00
    ld (scrtab+52),hl

    ;GOTO pet_menu
    jp pet_menu

l1aa6h:
    ;LEADIN = &H1B
    ld hl,1bh
    ld (leadin),hl

    ;ROWOFF = &H20 : COLOFF = &H20
    ld hl,20h
    ld (rowoff),hl
    ld (coloff),hl

    ;ORDER = 0
    ld hl,00h
    ld (order),hl

    ;SCRTAB(0) = &HB1
    ld hl,0b1h
    ld (scrtab+0),hl

    ;SCRTAB(1) = &H04
    ld hl,04h
    ld (scrtab+2),hl

    ;SCRTAB(2) = &HB2
    ld hl,0b2h
    ld (scrtab+4),hl

    ;SCRTAB(3) = &H05
    ld hl,05h
    ld (scrtab+6),hl

    ;SCRTAB(4) = &HB3
    ld hl,0b3h
    ld (scrtab+8),hl

    ;SCRTAB(5) = &H06
    ld hl,06h
    ld (scrtab+10),hl

    ;SCRTAB(6) = &HEA
    ld hl,0eah
    ld (scrtab+12),hl

    ;SCRTAB(7) = &H0E
    ld hl,0eh
    ld (scrtab+14),hl

    ;SCRTAB(8) = &HEB
    ld hl,0ebh
    ld (scrtab+16),hl

    ;SCRTAB(9) = &H0F
    ld hl,0fh
    ld (scrtab+18),hl

    ;SCRTAB(10) = &HD1
    ld hl,0d1h
    ld (scrtab+20),hl

    ;SCRTAB(11) = &H1C
    ld hl,1ch
    ld (scrtab+22),hl

    ;SCRTAB(12) = &HD7
    ld hl,0d7h
    ld (scrtab+24),hl

    ;SCRTAB(13) = &H1D
    ld hl,1dh
    ld (scrtab+26),hl

    ;SCRTAB(14) = &HC5
    ld hl,0c5h
    ld (scrtab+28),hl

    ;SCRTAB(15) = &H11
    ld hl,11h
    ld (scrtab+30),hl

    ;SCRTAB(16) = &HD2
    ld hl,0d2h
    ld (scrtab+32),hl

    ;SCRTAB(17) = &H12
    ld hl,12h
    ld (scrtab+34),hl

    ;SCRTAB(18) = &HD4
    ld hl,0d4h
    ld (scrtab+36),hl

    ;SCRTAB(19) = &H13
    ld hl,13h
    ld (scrtab+38),hl

    ;SCRTAB(20) = &HF4
    ld hl,0f4h
    ld (scrtab+40),hl

    ;SCRTAB(21) = &H13
    ld hl,13h
    ld (scrtab+42),hl

    ;SCRTAB(22) = &HD9
    ld hl,0d9h
    ld (scrtab+44),hl

    ;SCRTAB(23) = &H14
    ld hl,14h
    ld (scrtab+46),hl

    ;SCRTAB(24) = &HF9
    ld hl,0f9h
    ld (scrtab+48),hl

    ;SCRTAB(25) = &H14
    ld hl,14h
    ld (scrtab+50),hl

    ;SCRTAB(26) = &HAB
    ld hl,0abh
    ld (scrtab+52),hl

    ;SCRTAB(27) = &H1A
    ld hl,1ah
    ld (scrtab+54),hl

    ;SCRTAB(28) = &HAA
    ld hl,0aah
    ld (scrtab+56),hl

    ;SCRTAB(29) = &H1A
    ld hl,1ah
    ld (scrtab+58),hl

    ;SCRTAB(30) = &HBA
    ld hl,0bah
    ld (scrtab+60),hl

    ;SCRTAB(31) = &H1A
    ld hl,1ah
    ld (scrtab+62),hl

    ;SCRTAB(32) = &HBB
    ld hl,0bbh
    ld (scrtab+64),hl

    ;SCRTAB(33) = &H1A
    ld hl,1ah
    ld (scrtab+66),hl

    ;SCRTAB(34) = &HDA
    ld hl,0dah
    ld (scrtab+68),hl

    ;SCRTAB(35) = &H1A
    ld hl,1ah
    ld (scrtab+70),hl

    ;SCRTAB(36) = &HBD
    ld hl,0bdh
    ld (scrtab+72),hl

    ;SCRTAB(37) = &H1B
    ld hl,1bh
    ld (scrtab+74),hl

    ;SCRTAB(38) = &HA8
    ld hl,0a8h
    ld (scrtab+76),hl

    ;SCRTAB(39) = &H00
    ld hl,00h
    ld (scrtab+78),hl

    ;SCRTAB(40) = &HA9
    ld hl,0a9h
    ld (scrtab+80),hl

    ;SCRTAB(41) = &H00
    ld hl,00h
    ld (scrtab+82),hl

    ;SCRTAB(42) = &H00
    ld (scrtab+84),hl

    ;GOTO pet_menu
    jp pet_menu

clear_screen:
    ;PRINT CHR$(26)
    call pr0a
    ld hl,cls
    call chr
    call pv2d

    ;RETURN
    ret

readline:
    ;BUF = &H80
    ld hl,80h
    ld (buf),hl

    ;POKE BUF, 80
    ld hl,(buf)
    ld (hl),80

    ;CALL BUFFIN
    call buffin

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;IF PEEK (BUF+1) <> 0 GOTO l1bf4h 'blank line
    ld hl,(buf)
    inc hl
    ld l,(hl)
    ld h,0
    ld a,h
    or l
    jp nz,l1bf4h

    ;R = 0
    ld hl,0
    ld (rr),hl

    ;RETURN
    ret

l1bf4h:
    ;R = PEEK (BUF+2) ' single character reply
    ld hl,(buf)
    inc hl
    inc hl
    ld l,(hl)
    ld h,0
    ld (rr),hl

    ;IF NOT((R >= &H61) AND (R<= &H7A)) THEN GOTO l1c37h
    ld hl,(rr)          ;HL=(rr)
    ld de,0-'a'         ;DE=-61h
    ld a,h
    rla
    jp c,l1c0ch
    add hl,de
    add hl,hl
l1c0ch:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    push hl             ;Save value
    ld hl,(rr)          ;HL=(rr)
    ld de,0-('z'+1)     ;DE=-7bh
    ld a,h
    rla
    jp c,l1c1eh
    add hl,de
    add hl,hl
l1c1eh:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    pop de              ;Restore value
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    ld a,h
    or l
    jp z,l1c37h         ;IF HL = 0 THEN GOTO l1c37h

    ;R = R - &H20
    ld de,0-('a'-'A')
    ld hl,(rr)
    add hl,de
    ld (rr),hl

l1c37h:
    ;N = 0
    ld hl,0
    ld (nn),hl

    ;J = 2
    ld hl,2
    ld (jj),hl

l1c43h:
    ;WHILE (PEEK(BUF+J) >= &H30) AND (PEEK (BUF+J) <= &H39) AND (J-2<PEEK (BUF+1))
    ld hl,(buf)
    ex de,hl
    ld hl,(jj)
    add hl,de           ;HL=buf+jj
    ld l,(hl)
    ld h,0              ;HL=(HL)
    push hl             ;Save value
    ld de,0-'0'         ;DE=-30h
    ld a,h
    rla
    jp c,l1c59h
    add hl,de
    add hl,hl
l1c59h:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    ld (l02eah),hl      ;(l02eah)=HL
    pop hl              ;Restore value
    ld de,0-('9'+1)     ;DE=-3ah
    ld a,h
    rla
    jp c,l1c6bh
    add hl,de
    add hl,hl
l1c6bh:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    push hl             ;Save value
    ld hl,(l02eah)
    ex de,hl            ;DE=(l02eah)
    pop hl              ;Restore value
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    push hl             ;Save value
    ld hl,(buf)
    inc hl              ;HL=buf+1
    ld l,(hl)
    ld h,0              ;HL=(HL)
    push hl             ;Save value
    ld hl,(jj)
    dec hl
    dec hl              ;HL=jj-2
    pop de              ;Restore value
    ld a,d
    xor h
    ld a,h
    jp m,l1c93h
    ld a,l
    sub e
    ld a,h
    sbc a,d
l1c93h:
    rla
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    pop de              ;Restore value
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    ld a,h
    or l
    jp z,l1ccah         ;IF HL = 0 THEN GOTO l1ccah

    ;N=N*10+(PEEK(BUF+J)-&H30)
    ld hl,(nn)          ;HL=(rr)
    call imug           ;HL=HL*10
    dw 10
    push hl             ;Save value
    ld hl,(buf)
    ex de,hl
    ld hl,(jj)
    add hl,de           ;HL=buf+jj
    ld l,(hl)
    ld h,0              ;HL=(HL)
    pop de              ;Restore value
    add hl,de
    ld de,0-'0'         ;DE=-30h
    add hl,de           ;HL=HL+DE-30h
    ld (nn),hl          ;(nn)=HL

    ;J = J + 1
    ld hl,(jj)
    inc hl
    ld (jj),hl

    ;WEND
    jp l1c43h           ;1cc7 c3 43 1c

l1ccah:
    ;RETURN
    ret

    ;END
    call end

esc_or_tilde:
    db 23h
    dw esc_or_tilde+3
    db "Lead-in code E(scape) or T(ilde) ? "

screen_type:
    db 25h
    dw screen_type+3
    db "Screen type (ADM3A, HZ1500, TV912) ? "

new_clock:
    db 16h
    dw new_clock+3
    db "New clock frequency ? "

num_of_cols:
    db 20h
    dw num_of_cols+3
    db "Number of columns (1, 2 or 4) ? "

alter_which_1_4:
    db 14h
    dw alter_which_1_4+3
    db "Alter which (1-4) ? "

clock_freq:
    db 1fh
    dw clock_freq+3
    db "4.  Clock frequency (Hz) :     "

leadin_tilde:
    db 18h
    dw leadin_tilde+3
    db tab,tab,"     (Lead-in = TILDE)"

leadin_esc:
    db 25h
    dw leadin_esc+3
    db "                   (Lead-in = ESCAPE)"

hz1500:
    db 06h
    dw hz1500+3
    db "HZ1500"

tv912:
    db 05h
    dw tv912+3
    db "TV912"

adm3a:
    db 05h
    dw adm3a+3
    db "ADM3A"

crt_term_emu:
    db 1fh
    dw crt_term_emu+3
    db "3.  CRT terminal emulation :   "

no:
    db 02h
    dw no+3
    db "no"

yes:
    db 03h
    dw yes+3
    db "yes"

crt_in_upper:
    db 1fh
    dw crt_in_upper+3
    db "2.  CRT in upper case mode :   "

four:
    db 01h
    dw four+3
    db "4"

cols_in_dir:
    db 1fh
    dw cols_in_dir+3
    db "1.  Columns in DIR listing :   "

dashes:
    db 1dh
    dw dashes+3
    db "      --- -------- ----------"

pet_params:
    db 1dh
    dw pet_params+3
    db "      Pet terminal parameters"

retry_yn:
    db 0fh
    dw retry_yn+3
    db "Re-try (Y/N) ? "

no_drive:
    db 13h
    dw no_drive+3
    db "Drive not in system"

save_on_which:
    db 1fh
    dw save_on_which+3
    db "Save on which drive (A to P) ? "

new_command:
    db 1fh
    dw new_command+3
    db "Please enter the new command : "

new_aload_yn:
    db 1dh
    dw new_aload_yn+3
    db "New autoload command (Y/N) ? "

cur_aload_is:
    db 1dh
    dw cur_aload_is+3
    db "Current autoload command is :"

no_aload_cmd:
    db 1bh
    dw no_aload_cmd+3
    db "No current autoload command"

mw_12mb_half:
    db 0eh
    dw mw_12mb_half+3
    db "12Mbyte (half)"

mw_6mb_half:
    db 0eh
    dw mw_6mb_half+3
    db "6 Mbyte (half)"

mw_3mb_half:
    db 0eh
    dw mw_3mb_half+3
    db "3 Mbyte (half)"

mw_12mb:
    db 0dh
    dw mw_12mb+3
    db "12 Mbyte     "

mw_6mb:
    db 07h
    dw mw_6mb+3
    db "6 Mbyte"

mw_3mb:
    db 0ch
    dw mw_3mb+3
    db "3 Mbyte     "

winchester:
    db 0eh
    dw winchester+3
    db "Winchester    "

device_num:
    db 0bh
    dw device_num+3
    db "   Device #"

cor_5mb_star:
    db 0bh
    dw cor_5mb_star+3
    db "Corvus 5Mb*"

cor_5mb:
    db 0bh
    dw cor_5mb+3
    db "Corvus 5Mb "

cor_20mb:
    db 0bh
    dw cor_20mb+3
    db "Corvus 20Mb"

cor_10mb:
    db 0bh
    dw cor_10mb+3
    db "Corvus 10Mb"

not_used:
    db 08h
    dw not_used+3
    db "not used"

cbm_8050:
    db 0bh
    dw cbm_8050+3
    db "8050       "

cbm_3040:
    db 0bh
    dw cbm_3040+3
    db "3040/4040  "

use_first_half:
    db 1ch
    dw use_first_half+3
    db "use the FIRST HALF (E/H)  ? "

use_entire_drv:
    db 27h
    dw use_entire_drv+3
    db "Use the ENTIRE drive for CP/M,  or just"

drv_3_6_12:
    db 19h
    dw drv_3_6_12+3
    db "3, 6 or 12 Mbyte drive ? "

config_as_1_or_2:
    db 22h
    dw config_as_1_or_2+3
    db "Configure as 1 or 2 CP/M drives ? "

dev_num_for_drv:
    db 1ah
    dw dev_num_for_drv+3
    db "Device number for drive ? "

drv_5_10_20:
    db 1ah
    dw drv_5_10_20+3
    db "5, 10 or 20 Mbyte drive ? "

cbm_hard_unused:
    db 25h
    dw cbm_hard_unused+3
    db "3(040), 8(050), h(ard) or u(nused) ? "

alter_which_pair:
    db 22h
    dw alter_which_pair+3
    db "Alter which drive pair (A to O) ? "

drives_o_p:
    db 0bh
    dw drives_o_p+3
    db "O, P :     "

drives_m_n:
    db 0bh
    dw drives_m_n+3
    db "M, N :     "

drives_k_l:
    db 0bh
    dw drives_k_l+3
    db "K, L :     "

drives_i_j:
    db 0bh
    dw drives_i_j+3
    db "I, J :     "

drives_g_h:
    db 0bh
    dw drives_g_h+3
    db "G, H :     "

drives_e_f:
    db 0bh
    dw drives_e_f+3
    db "E, F :     "

drives_c_d:
    db 0bh
    dw drives_c_d+3
    db "C, D :     "

drives_a_b:
    db 0bh
    dw drives_a_b+3
    db "A, B :     "

dashes_2:
    db 21h
    dw dashes_2+3
    db "            ---- ----- ----------"

drv_assgnmt:
    db 21h
    dw drv_assgnmt+3
    db "            Disk drive assignment"

which_printer:
    db 24h
    dw which_printer+3
    db "Which type of printer (3, 8 or D) ? "

daisywheel:
    db 1dh
    dw daisywheel+3
    db "D = 8026 or 8027 (daisywheel)"

cbm8024:
    db 08h
    dw cbm8024+3
    db "8 = 8024"

cbm3022:
    db 1ch
    dw cbm3022+3
    db "3 = 3022, 3023, 4022 or 4023"

tty_or_ptp:
    db 13h
    dw tty_or_ptp+3
    db "T(TY:) or P(TP:) ? "

tty_or_ptr:
    db 13h
    dw tty_or_ptr+3
    db "T(TY:) or P(TR:) ? "

which_list_dev:
    db 23h
    dw which_list_dev+3
    db "Which list device (T, C, L or U) ? "

ul1_ascii:
    db 1dh
    dw ul1_ascii+3
    db "U(L1:) --  ASCII IEEE printer"

lpt_pet:
    db 1bh
    dw lpt_pet+3
    db "L(PT:) --  PET IEEE printer"

crt_pet_scrn:
    db 15h
    dw crt_pet_scrn+3
    db "C(RT:) --  PET screen"

tty_rs232:
    db 18h
    dw tty_rs232+3
    db "T(TY:) --  RS232 printer"

new_dev_num:
    db 0fh
    dw new_dev_num+3
    db "New device # ? "

alter_which_1_8:
    db 14h
    dw alter_which_1_8+3
    db "Alter which (1-8) ? "

cbm8024_2:
    db 04h
    dw cbm8024_2+3
    db "8024"

daisywheel_2:
    db 09h
    dw daisywheel_2+3
    db "8026/8027"

cbm_3022_2:
    db 09h
    dw cbm_3022_2+3
    db "3022/4022"

pet_prtr_type:
    db 1eh
    dw pet_prtr_type+3
    db "8.  PET printer type :        "

ptp:
    db 04h
    dw ptp+3
    db "PTP:"

default_pun:
    db 1eh
    dw default_pun+3
    db "7.  Default PUN: device :     "

ptr:
    db 04h
    dw ptr+3
    db "PTR:"

default_rdr:
    db 1eh
    dw default_rdr+3
    db "6.  Default RDR: device :     "

ul1_colon:
    db 04h
    dw ul1_colon+3
    db "UL1:"

lpt_colon:
    db 04h
    dw lpt_colon+3
    db "LPT:"

crt:
    db 04h
    dw crt+3
    db "CRT:"

tty:
    db 04h
    dw tty+3
    db "TTY:"

io_lst_device:
    db 1eh
    dw io_lst_device+3
    db "5.  Default LST: device :     "

io_pun_device:
    db 1eh
    dw io_pun_device+3
    db "4.  Punch device # :          "

io_rdr_device:
    db 1eh
    dw io_rdr_device+3
    db "3.  Reader device # :         "

io_ul1_device:
    db 1eh
    dw io_ul1_device+3
    db "2.  ASCII printer device # :  "

io_lpt_device:
    db 1eh
    dw io_lpt_device+3
    db "1.  Pet printer device # :    "

dashes_6:
    db 22h
    dw dashes_6+3
    db "             --- ------ ----------"

io_dev_asgn:
    db 22h
    dw io_dev_asgn+3
    db "             I/O device assignment"

ask_19200:
    db 0dh
    dw ask_19200+3
    db "19200 baud ? "

ask_bauds:
    db 1dh
    dw ask_bauds+3
    db "110, 300, 1200, 4800, 9600 or"

odd_even_none:
    db 1fh
    dw odd_even_none+3
    db "O(dd), E(ven) or N(o parity) ? "

num_stop_bits:
    db 20h
    dw num_stop_bits+3
    db "Number of stop bits (1 or 2)  ? "

new_char_len:
    db 20h
    dw new_char_len+3
    db "New character length (5 to 8) ? "

alter_chr_1_4:
    db 23h
    dw alter_chr_1_4  +3
    db "Alter which characteristic (1-4) ? "

baud_4800:
    db 04h
    dw baud_4800+3
    db "4800"

baud_19200:
    db 05h
    dw baud_19200+3
    db "19200"

baud_9600:
    db 04h
    dw baud_9600+3
    db "9600"

baud_1200:
    db 04h
    dw baud_1200+3
    db "1200"

baud_300:
    db 03h
    dw baud_300+3
    db "300"

baud_110:
    db 03h
    dw baud_110+3
    db "110"

rs232_4_baud:
    db 1fh
    dw rs232_4_baud+3
    db " 4.  Baud rate :               "

odd:
    db 03h
    dw odd+3
    db "odd"

even:
    db 04h
    dw even+3
    db "even"

none:
    db 04h
    dw none+3
    db "none"

rs232_3_par:
    db 1fh
    dw rs232_3_par+3
    db " 3.  Parity :                  "

two:
    db 01h
    dw two+3
    db "2"

one_dot_five:
    db 03h
    dw one_dot_five+3
    db "1.5"

one:
    db 01h
    dw one+3
    db "1"

undefined:
    db 09h
    dw undefined+3
    db "undefined"

rs232_2_stop:
    db 1fh
    dw rs232_2_stop+3
    db " 2.  Number of stop bits :     "

rs232_1_chr:
    db 1fh
    dw rs232_1_chr+3
    db " 1.  Character size :          "

dashes_5:
    db 20h
    dw dashes_5+3
    db "           ----- ---------------"

rs232_chrs:
    db 20h
    dw rs232_chrs+3
    db "           RS232 Characteristics"

pls_letter:
    db 26h
    dw pls_letter+3
    db "Please enter the appropriate letter : "

q_quit:
    db 15h
    dw q_quit+3
    db "Q - Quit this program"

e_execute:
    db 16h
    dw e_execute+3
    db "E - Execute new system"

s_save:
    db 13h
    dw s_save+3
    db "S - Save new system"

r_rs232:
    db 19h
    dw r_rs232+3
    db "R - RS232 characteristics"

p_pet_term:
    db 1bh
    dw p_pet_term+3
    db "P - PET terminal parameters"

i_io_asgn:
    db 12h
    dw i_io_asgn+3
    db "I - I/O assignment"

d_drv_asgn:
    db 19h
    dw d_drv_asgn+3
    db "D - Disk drive assignment"

a_autoload:
    db 14h
    dw a_autoload+3
    db "A - Autoload command"

dashes_4:
    db 16h
    dw dashes_4+3
    db "----  ----------------"

cpm_reconfig_2:
    db 16h
    dw cpm_reconfig_2+3
    db "CP/M  Re-configuration"

source_drv_a_p:
    db 18h
    dw source_drv_a_p+3
    db "Source drive (A to P) ? "

rev_3_feb_1982:
    db 22h
    dw rev_3_feb_1982+3
    db "Revision 3   --   19 February 1982"

mw_version:
    db 17h
    dw mw_version+3
    db "Mini-winchester version"

dashes_3:
    db 15h
    dw dashes_3+3
    db "----  ---------------"

cpm_reconfig:
    db 15h
    dw cpm_reconfig+3
    db "CP/M  Reconfiguration"

empty_string:
    db 00h
    dw empty_string+3

    db 0cdh,24h,2dh,01h,00h,00h

; Start of LOADSAVE.REL =====================================================

buffin:
;Buffered Console Input.  Caller must store buffer size at 80h.  On
;return, 81h will contain the number of data bytes and the data
;will start at 82h.
    ld c,creadstr       ;Buffered Console Input
    ld de,dma_buf
    jp bdos             ;BDOS entry point

exsys:
;Execute a new CP/M system.  The buffer at 4000h contains a new
;CP/M system image (7168 bytes = CCP + BDOS + BIOS config + BIOS storage).
;Copy the new system into place and then jump to the BIOS to start it.
    ld bc,1c00h
    ld hl,4000h
    ld de,ccp_base
    ldir
    jp runcpm           ;Perform system init and then run CP/M

rdsys:
;Read the "CP/M" and "K" files from an IEEE-488 drive into memory.
    ld a,(hl)
    ld (cpm_drive),a

    call dskdev         ;Get device address for a CP/M drive number
    ld e,00h
    push de

    call sub_29deh
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    ld hl,4000h
    ld bc,1c00h
    pop de
    or a
    ret nz
    push de
    call talk           ;Send TALK to an IEEE-488 device
l28dah:
    call rdieee         ;Read byte from an IEEE-488 device
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l28dah
    call untalk         ;Send UNTALK to all IEEE-488 devices
    pop de
    push de
    call close          ;Close an open file on an IEEE-488 device
    pop de
    push de
    call sub_29f0h
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    ld hl,6000h
    ld bc,l0800h
    pop de
    or a
    ret nz
    push de
    call talk           ;Send TALK to an IEEE-488 device
l2907h:
    call rdieee         ;Read byte from an IEEE-488 device
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2907h
    call untalk         ;Send UNTALK to all IEEE-488 devices
    pop de
    call close          ;Close an open file on an IEEE-488 device
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    ret

cread_:
;Read CP/M image from a Corvus drive.
    ld c,(hl)
    call seldsk         ;Select disk drive
    ld de,4000h
    ld bc,0000h
cread2:
    call settrk         ;Set track number
    push bc
    ld bc,0000h
cread1:
    call setsec         ;Set sector number
    push bc
    push de
    call read           ;Read selected sector
    or a
    jr nz,cwrit3
    pop de
    ld bc,0080h
    ld hl,0080h
    ldir
    pop bc
    inc c
    ld a,c
    cp 40h
    jr nz,cread1
    pop bc
    inc c
    ld a,c
    cp 02h
    jr nz,cread2
    ret

cwrite_:
;Write CP/M image to a Corvus drive.
    ld c,(hl)
    call seldsk         ;Select disk drive
    ld hl,4000h
    ld bc,0000h
cwrit2:
    call settrk         ;Set track number
    push bc
    ld bc,0000h
cwrit1:
    call setsec         ;Set sector number
    push bc
    ld bc,0080h
    ld de,0080h
    ldir
    push hl
    call write          ;Write selected sector
    or a
    jr nz,cwrit3
    pop hl
    pop bc
    inc c
    ld a,c
    cp 40h
    jr nz,cwrit1
    pop bc
    inc c
    ld a,c
    cp 02h
    jr nz,cwrit2
    ret
cwrit3:
    pop hl
    pop hl
    pop hl
    jp l2b7ah

dtype:
;Get the drive type for a CP/M drive number.
    ld a,(hl)
    call tstdrv         ;Get drive type for a CP/M drive number
    ld (hl),c
    inc hl
    ld (hl),00h
    ret

idisk:
;Initialize an IEEE-488 disk drive.
    ld a,(hl)
    jp idrive           ;Initialize an IEEE-488 disk drive

dskerr:
    ld a,(dos_err)
    ld (hl),a
    inc hl
    xor a
    ld (hl),a
    ld a,(dos_err)
    or a
    ret z
    ld de,disk_error    ;cr,lf,"Disk error : "
    ld c,cwritestr      ;Output String
    call bdos           ;BDOS entry point
    ld hl,errbuf
l29b4h:
    ld e,(hl)
    push hl
    ld c,cwrite         ;Console Output
    call bdos           ;BDOS entry pointt
    pop hl
    inc hl
    ld a,(hl)
    cp cr
    jr nz,l29b4h
    ld de,cr_lf         ;cr,lf
    ld c,cwritestr      ;Output String
    call bdos           ;BDOS entry point
    ret

disk_error:
    db cr,lf,"Disk error : $"

cr_lf:
    db cr,lf,"$"

sub_29deh:
;Open "CP/M" file on an IEEE-488 drive
    ld c,l2bd3h_len
    ld hl,l2bd3h        ;"0:CP/M"
    ld a,(cpm_drive)
    rra
    jp nc,open          ;Open a file on an IEEE-488 device
    ld hl,l2bd9h        ;"1:CP/M"
    jp open             ;Open a file on an IEEE-488 device

sub_29f0h:
;Open "K" file on an IEEE-488 drive
    ld c,l2bdfh_len
    ld hl,l2bdfh        ;"0:K"
    ld a,(cpm_drive)
    rra
    jp nc,open          ;Open a file on an IEEE-488 device
    ld hl,l2be2h        ;"1:K"
    jp open             ;Open a file on an IEEE-488 device

savesy:
;Read the CP/M system image from an IEEE-488 drive.
    ld a,(hl)
    ld (cpm_drive),a
    call dskdev         ;Get device address for a CP/M drive number
    push de
    ld e,0fh
    ld hl,l2bcbh        ;"S0:*"
    ld a,(cpm_drive)
    rra
    jr nc,l2a18h
    ld hl,l2bcfh        ;"S1:*"
l2a18h:
    ld c,l2bcbh_len
    call open           ;Open a file on an IEEE-488 device
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    pop de
    cp 01h
    ret nz
    ld e,01h
    push de
    call sub_29f0h
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    pop de
    or a
    ret nz
    push de
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,6000h
    ld bc,l0800h
l2a46h:
    ld a,(hl)
    call wrieee         ;Send byte to an IEEE-488 device
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2a46h
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    pop de
    push de
    call close          ;Close an open file on an IEEE-488 device
    pop de
    push de
    call sub_29deh
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    pop de
    or a
    ret nz
    push de
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,4000h
    ld bc,1c00h
l2a73h:
    ld a,(hl)
    call wrieee         ;Send byte to an IEEE-488 device
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l2a73h
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    pop de
    call close          ;Close an open file on an IEEE-488 device
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    ret

format:                 ;(TODO: Unused?)
;Format an IEEE-488 drive for SoftBox use.
    ld a,(hl)
    ld (cpm_drive),a
    call dskdev         ;Get device address for a CP/M drive number
    ld a,(cpm_drive)
    and 01h
    add a,'0'
    ld (l2ba6h+1),a     ;Store cbm drive number into command string
    ld e,0fh            ;Secondary address is 15 (command channel)
    ld c,l2ba6h_len
    ld hl,l2ba6h        ;"N0:CP/M V2.2 DISK,XX"
    call open           ;Open a file on an IEEE-488 device
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    or a
    ret nz              ;If error occured, return
    ld a,(cpm_drive)
    call idrive         ;Initialize an IEEE-488 disk drive
    ld hl,4000h
    ld de,4000h+1
    ld bc,00ffh
    ld (hl),0e5h
    ldir                ;Fill all 256 bytes (4000h to 40ffh) with 0e5h
    ld a,7              ;Start with sector 7 (cbmdos format)
    ld (cbmdos_sector),a
    ld a,1              ;Write only in track 1 (cbmdos format)
    ld (cbmdos_track),a
l2ad1h:
;Clear the CP/M directory by filling it with E5 ("unused").
    call sub_2ae7h
    ld a,(cpm_drive)
    call dsksta         ;Read the error channel of an IEEE-488 device
    ld (dos_err),a
    or a
    ret nz              ;If error occured, return
    ld hl,cbmdos_sector
    dec (hl)            ;Decrement the current sector (cbmdos format)
    jp p,l2ad1h         ;Loop until all sectors (15 .. 0) done
    ret

sub_2ae7h:
;Write a sector to an IEEE-488 drive.
    ld hl,l2bc1h        ;"M-W",00h,13h,01h
    ld c,l2bc1h_len
    ld a,(cpm_drive)
    call diskcmd        ;Open the command channel on IEEE-488 device
    call ieeemsg        ;Send string to the current IEEE-488 device
    ld a,(4000h)
    call wreoi          ;Send byte to IEEE-488 device with EOI asserted
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld hl,l2bbah        ;"B-P 2 1"
    ld c,l2bbah_len
    ld a,(cpm_drive)
    call diskcmd        ;Open the command channel on IEEE-488 device
    call ieeemsg        ;Send string to the current IEEE-488 device
    call creoi          ;Send carriage return to IEEE-488 dev with EOI
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld a,(cpm_drive)
    call dskdev         ;Get device address for a CP/M drive number
    ld e,02h
    call listen         ;Send LISTEN to an IEEE-488 device
    ld hl,4000h+1
    ld c,0ffh
    call ieeemsg        ;Send string to the current IEEE-488 device
    call unlisten       ;Send UNLISTEN to all IEEE-488 devices
    ld a,(cpm_drive)
    call diskcmd        ;Open the command channel on IEEE-488 device
    ld hl,l2ba1h        ;"U2 2 "
    ld c,l2ba1h_len
    call ieeemsg        ;Send string to the current IEEE-488 device
    ld a,(cpm_drive)
    and 01h
    add a,'0'           ;Get cbm drive number
    call wrieee         ;Send byte to an IEEE-488 device
    ld a,(cbmdos_track) ;Get track number (cbmdos format)
    call ieeenum        ;Send number as decimal string to IEEE-488 dev
    ld a,(cbmdos_sector);Get sector number (cbmdos format)
    call ieeenum        ;Send number as decimal string to IEEE-488 dev
    call creoi          ;Send carriage return to IEEE-488 dev with EOI
    jp unlisten         ;Send UNLISTEN to all IEEE-488 devices

cform:                  ;(TODO: Unused?)
;Format a hard drive for Softbox use.
    ld c,(hl)
    call seldsk         ;Select disk drive
    ld hl,dma_buf
l2b59h:
    ld (hl),0e5h
    inc l
    jr nz,l2b59h        ;Fill all 128 bytes (0080h to 00ffh) with 0e5h
    ld bc,2             ;Write into cpm track number 2
    call settrk         ;Set track number
    ld bc,0             ;Start with cpm sector number 0
l2b67h:
    push bc
    call setsec         ;Set sector number
    call write          ;Write selected sector
    pop bc
    or a
    jp nz,l2b7ah        ;If error occured, skip
    inc bc              ;Increment sector number (cpm)
    ld a,c
    cp 40h
    jr nz,l2b67h        ;Loop until all sectors (0 .. 63) done
                        ;This includes track number 3 with 32 sectors, too
    ret

l2b7ah:
;Display "Hit any key to abort" message, wait for a key, and then return.
    ld de,l2b87h        ;cr,lf,"Hit any key to abort : $"
    ld c,cwritestr      ;Output String
    call bdos           ;BDOS entry point
    ld c,cread          ;Console Input
    jp bdos             ;BDOS entry point

l2b87h:
    db cr,lf,"Hit any key to abort : $"

l2ba1h:
    db "U2 2 "
l2ba1h_len: equ $-l2ba1h

l2ba6h:
    db "N0:CP/M V2.2 DISK,XX"
l2ba6h_len: equ $-l2ba6h

l2bbah:
    db "B-P 2 1"
l2bbah_len: equ $-l2bbah

l2bc1h:
    db "M-W",00h,13h,01h
l2bc1h_len: equ $-l2bc1h

l2bc7h:                 ;unused !!!
    db "#2"

cbmdos_track:
    db 53h              ;Track number for cbmdos format
cbmdos_sector:
    db 3ah              ;Sector number for cbmdos format

l2bcbh:
    db "S0:*"
l2bcbh_len: equ $-l2bcbh

l2bcfh:
    db "S1:*"

l2bd3h:
    db "0:CP/M"
l2bd3h_len: equ $-l2bd3h

l2bd9h:
    db "1:CP/M"

l2bdfh:
    db "0:K"
l2bdfh_len: equ $-l2bdfh

l2be2h:
    db "1:K"

cpm_drive:
    db 2dh              ;Current CP/M drive number
dos_err:
    db 54h              ;Last CBM DOS error code

; End of LOADSAVE.REL =======================================================

; Start of KLIB.REL =========================================================

; XSTRIN --------------------------------------------------------------------

tmp:
;Temporary string
    db 0feh             ;header: string length
    dw 0ca64h           ;header: start address of string
    db 0d6h, 53h        ;string data (not at start address ??)

print_spc:
;Print a space
    ld a,' '
    call conout
    ret

print_eol:
    ld a,lf
    call conout
    ld a,cr
    call conout
    ret

hex:
;XSTRIN: HEX
;Make a temporary string (length 2 bytes) with the hexadecimal
;representation of the byte in HL and return a pointer to it in HL.
;Implements BASIC function: HEX$(x)
;
    ld a,2              ;A = 2 bytes in string
    ld (tmp),a          ;Store length in temp string header
    ld a,l              ;A = L
    call xstrin_3       ;Convert high nibble in A to ASCII
    ld (tmp+3),a        ;Save it as first char of string
    ld a,l              ;A = L
    call xstrin_4       ;Convert low nibble in A to ASCII
    ld (tmp+4),a        ;Save it as second char of string
    ld hl,tmp           ;HL = address of the string
    ret

xstrin_3:
    rrca
    rrca
    rrca
    rrca
xstrin_4:
    and 0fh
    cp 0ah
    jp m,xstrin_5
    add a,07h
xstrin_5:
    add a,30h
    ret

chr:
;XSTRIN: CHR
;Make a temporary string from the char in L and
;return a pointer to it in HL.
;Implements BASIC function: CHR$(x)
;
    ld a,1              ;A = 1 byte in string
    ld (tmp),a          ;Store length in temp string header
    ld a,l              ;A = L
    ld (tmp+3),a        ;Store A as the temp string data
    ld hl,tmp           ;HL = address of the string
    ret

pv2d:
;XSTRIN: PV2D
;Print string in HL followed by CR+LF
;Implements BASIC command: PRINT"foo"
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    jp z,print_eol      ;If length = 0, jump to print CR+LF only.
    call print_str      ;Print the string
    jp print_eol        ;Jump out to print CR+LF

pv1d:
;XSTRIN: PV1D
;Print string in HL but do not send CR+LF
;Implements BASIC command: PRINT"foo";
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    ret z               ;If length = 0, return (nothing to do).
    call print_str      ;Print the string
    ret

pv0d:
;XSTRIN: PV0D
;Print string in HL followed by a space
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    jp z,print_spc      ;If length = 0, jump out print a space only.
    call print_str      ;Print the string
    jp print_spc        ;Jump out to print a space

print_str:
;Print string of length A at pointer HL.
;
    ld b,a              ;B = A
    inc hl              ;Skip string length byte
    inc hl              ;Skip string start address low byte
    inc hl              ;Skip string start address high byte
l2c52h:
    ld a,(hl)           ;Read char from string
    call conout         ;Print it
    dec b               ;Decrement number of chars remaining
    inc hl              ;Increment pointer
    jp nz,l2c52h        ;Loop until all chars have been printed
    ret

; DIV1 ----------------------------------------------------------------------

idvd:
;DIV1: $IDVD
    ex de,hl
    pop hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    jp l2c6ah

idva:
;DIV1: $IDVA
    ld b,h
    ld c,l
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
l2c6ah:
    inc hl
    push hl
    jp l2c72h

idvb:
;DIV1: $IDVB
    ex de,hl

idve:
;DIV1: $IDVE
    ld b,h
    ld c,l
l2c72h:
    ld a,d
    cpl
    ld d,a
    ld a,e
    cpl
    ld e,a
    inc de
    ld hl,0000h
    ld a,11h
l2c7eh:
    push hl
    add hl,de
    jp nc,l2c84h
    ex (sp),hl
l2c84h:
    pop hl
    push af
    ld a,c
    rla
    ld c,a
    ld a,b
    rla
    ld b,a
    ld a,l
    rla
    ld l,a
    ld a,h
    rla
    ld h,a
    pop af
    dec a
    jp nz,l2c7eh
    ld l,c
    ld h,b
    ret

; MUL1 ----------------------------------------------------------------------

imug:
;MUL1: IMUG
    ld b,h
    ld c,l
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    ld l,c
    ld h,b

imuh:
;MUL1: IMUH
    ld a,h
    or l
    ret z
    ex de,hl
    ld a,h
    or l
    ret z
    ld b,h
    ld c,l
    ld hl,0000h
    ld a,10h
l2cb2h:
    add hl,hl
    ex de,hl
    add hl,hl
    ex de,hl
    jp nc,l2cbah
    add hl,bc
l2cbah:
    dec a
    jp nz,l2cb2h
    ret

; N16 -----------------------------------------------------------------------

pv0c:
pv1c:
;N16: PV0C and PV1C
    call sub_2cd6h
    ld a,' '
    call conout
    ret

pv2c:
;N16: PV2C
    call sub_2cd6h
    ld a,lf
    call conout
    ld a,cr
    call conout
    ret

sub_2cd6h:
    push hl
    ld a,h
    and 80h
    jp z,l2ce9h
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    inc hl
    ld a,'-'
    call conout
l2ce9h:
    ld c,'0'
    ld de,10000
    call sub_2d0bh
    ld de,1000
    call sub_2d0bh
    ld de,100
    call sub_2d0bh
    ld de,10
    call sub_2d0bh
    ld de,1
    call sub_2d0bh
    pop hl
    ret

sub_2d0bh:
    call sub_2d1dh
    jp c,l2d15h
    inc c
    jp sub_2d0bh

l2d15h:
    ld a,c
    call conout
    add hl,de
    ld c,30h
    ret

sub_2d1dh:
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    ld h,a
    ret

; XXXLIB --------------------------------------------------------------------

end:
;XXXLIB: $END
;Jump to CP/M warm start
;Implements BASIC command: END
    jp warm             ;Warm start entry point

ini:
;XXXLIB: INI
;Jump to the address in HL
    jp (hl)

n5_0:
;XXXLIB: $5.0
;Do nothing and return
    ret

; CPMIO ---------------------------------------------------------------------

charin:
;CPMIO: CHARIN
    ld hl,0fffeh
    jp conin

conout:
;CPMIO: CONOUT
;Write the char in A to the console
    push hl
    push de
    push bc
    push af
    ld c,cwrite         ;Console Output
    ld e,a
    call bdos           ;BDOS entry point
    pop af
    pop bc
    pop de
    pop hl

pr0a:
;CPMIO: $PR0A
;Do nothing and return
    ret

conin:
;CPMIO: CONIN
    push de
    push bc
    push hl
    ld c,cread          ;Console Input
    call bdos           ;BDOS entry point
    pop hl
    ld (hl),a
    inc hl
    ld (hl),00h
    pop bc
    pop de
    ret

char:
;CPMIO: CHAR
    ld a,(hl)
    jp conout

;TODO: Unknown code below ---------------------------------------------------

    call conout         ;2d52 cd 2f 2d
    ret                 ;2d55 c9
    push hl             ;2d56 e5
    ld a,h              ;2d57 7c
    and 80h             ;2d58 e6 80
    jp z,l2ce9h         ;2d5a ca e9 2c
    ld a,l              ;2d5d 7d
    cpl                 ;2d5e 2f
    ld l,a              ;2d5f 6f
    ld a,h              ;2d60 7c
    cpl                 ;2d61 2f
    ld h,a              ;2d62 67
    inc hl              ;2d63 23
    ld a,'-'            ;2d64 3e 2d
    call conout         ;2d66 cd 2f 2d
    ld c,'0'            ;2d69 0e 30
    ld de,10000         ;2d6b 11 10 27
    call sub_2d0bh      ;2d6e cd 0b 2d
    ld de,1000          ;2d71 11 e8 03
    call sub_2d0bh      ;2d74 cd 0b 2d
    ld de,100           ;2d77 11 64 00
    call sub_2d0bh      ;2d7a cd 0b 2d
    ld de,10            ;2d7d 11 0a 00

; End of KLIB.REL ===========================================================
