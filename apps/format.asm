; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --output=format.asm format.com

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point
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
dskdev:        equ 0f054h ;BIOS Get device address for a CP/M drive number
diskcmd:       equ 0f057h ;Open the command channel on IEEE-488 device
dsksta:        equ 0f05ah ;Read the error channel of an IEEE-488 device
open:          equ 0f05dh ;BIOS Open a file on an IEEE-488 device
close:         equ 0f060h ;Close an open file on an IEEE-488 device
runcpm:        equ 0f075h ;Perform system init and then run CP/M
idrive:        equ 0f078h ;Initialize an IEEE-488 disk drive

cread:         equ 01h    ;Console Input
cwrite:        equ 02h    ;Console Output
cwritestr:     equ 09h    ;Output String
creadstr:      equ 0ah    ;Buffered Console Input

    org 0100h

    jp start
    nop                 ;0103 00
    nop                 ;0104 00
    nop                 ;0105 00
    nop                 ;0106 00
    nop                 ;0107 00
    nop                 ;0108 00
    nop                 ;0109 00
l010ah:
    nop                 ;010a 00
    nop                 ;010b 00
l010ch:
    nop                 ;010c 00
    nop                 ;010d 00
l010eh:
    nop                 ;010e 00
    nop                 ;010f 00
l0110h:
    nop                 ;0110 00
    nop                 ;0111 00
l0112h:
    nop                 ;0112 00
    nop                 ;0113 00
l0114h:
    nop                 ;0114 00
    nop                 ;0115 00
    nop                 ;0116 00
    nop                 ;0117 00
    nop                 ;0118 00
    nop                 ;0119 00
    nop                 ;011a 00
    ld (hl),a           ;011b 77
    dec hl              ;011c 2b
    ld a,b              ;011d 78

start:
    ld hl,main
    jp jp_to_hl         ;Perform JP (main)

    push af             ;0124 f5
    inc b               ;0125 04
    nop                 ;0126 00
    nop                 ;0127 00
    rst 30h             ;0128 f7
    inc b               ;0129 04
    inc bc              ;012a 03
    ld bc,l0114h        ;012b 01 14 01
    nop                 ;012e 00
    nop                 ;012f 00
    ld e,01h            ;0130 1e 01

main:
;Print the welcome banner.
;
    call nop_1
    call nop_2
    ld hl,empty_string
    call print          ;Print newline

    call nop_2
    ld hl,empty_string
    call print          ;Print newline

    call nop_2
    ld hl,format_prog
    call print          ;Print "Disk formatting program"

    call nop_2
    ld hl,for_pet_cpm   ;Print "For PET CP/M "
    call print

    call nop_2
    ld hl,dashes
    call print          ;Print "=== === ===="

next_disk:
;Prompt for a drive letter.  If no letter is entered,
;warm start back to CP/M.
;
    call nop_2
    ld hl,empty_string
    call print          ;Print newline

    call nop_2
    ld hl,on_which_drv
    call print          ;Print "Format disk on which drive"

    call nop_2
    ld hl,a_to_p
    call print_         ;Print "(A to P, or RETURN to reboot) ? "

    call sub_02f5h

    call nop_2
    ld hl,empty_string
    call print          ;Print newline

    ld hl,(l010ah)
    ld a,h
    or l
    jp nz,check_letter  ;Jump to check drive if a letter was entered
    call jp_to_warm     ;No letter: jump to CP/M warm start (never returns)

check_letter:
;Check that the letter is in the range of valid letters (A-P).
;
    ld de,0ffbfh
    ld hl,(l010ah)
    add hl,de
    ld (l010ch),hl
    ld hl,(l010ch)
    add hl,hl
    sbc a,a
    ld h,a
    ld l,a
    push hl
    ld hl,(l010ch)
    ld de,0fff0h
    ld a,h
    rla
    jp c,l01b3h
    add hl,de
    add hl,hl
l01b3h:
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
    jp z,check_type

    call nop_2
    ld hl,doesnt_exist
    call print          ;Print "Drive doesn't exist !"

    jp next_disk        ;Loop back to beginning ("Format disk in which...")

check_type:
;Check that a drive has been configured at the drive letter entered.
;
    ld hl,(l010ch)
    ld (l010eh),hl
    ld hl,l010eh
    call dtype
    ld hl,(l010eh)
    ld de,0ff80h
    ld a,h
    rla
    jp c,l01e8h
    add hl,de
    add hl,hl
l01e8h:
    jp c,floppy_or_hard

    call nop_2
    ld hl,not_in_sys
    call print          ;Print "Drive not in system"

    jp next_disk        ;Loop back to beginning ("Format disk in which...")

floppy_or_hard:
;Determine if the drive to be formatted is a CBM floppy drive
;or a Corvus hard drive.
;
    ld hl,(l010eh)
    ld de,0fffeh
    ld a,h
    rla
    jp c,l0204h
    add hl,de
    add hl,hl
l0204h:
    sbc a,a
    ld h,a
    ld l,a
    push hl
    ld hl,(l010eh)
    ld de,0fff6h
    ld a,h
    rla
    jp c,l0215h
    add hl,de
    add hl,hl
l0215h:
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
    jp nz,prompt_floppy ;Jump if the drive is a CBM floppy drive.

                        ;Drive must be a Corvus hard disk.
                        ;Prompt for confirmation to format the hard disk.

    call nop_2
    ld hl,0007h
    call sub_087bh
    call print_

    ld hl,data_on_hd
    call print_         ;Print "Data on hard disk "

    ld hl,(l010ah)
    call sub_087bh
    call print_

    ld hl,will_be_eras
    call print          ;Print ": will be erased"

    call nop_2
    ld hl,proceed_yn
    call print_         ;Print "Proceed (Y/N) ? "

    call sub_02f5h
    ld hl,(l010ah)
    ld de,0ffa7h
    add hl,de
    ld a,h
    or l
    jp z,format_hard
    call jp_to_warm     ;Jump to CP/M warm start (never returns)

format_hard:
;Perform the Corvus hard disk format.
;
    call nop_2
    ld hl,empty_string
    call print          ;Print newline

    call nop_2
    ld hl,formatting_hd
    call print          ;Print "Formatting hard disk"

    ld hl,l010ch
    call cform
    jp format_done

prompt_floppy:
;Prompt for confirmation to format the floppy disk.
;
    call nop_2
    ld hl,disk_on_drv
    call print_         ;Print "Disk on drive "

    ld hl,(l010ah)
    call sub_087bh
    call print_

    ld hl,be_formatted
    call print          ;Print ": is to be formatted"

    call nop_2
    ld hl,press_return
    call print_         ;Print "Press RETURN to continue, ^C to abort : "

    call sub_02f5h
    ld hl,(l010ah)
    ld a,h
    or l
    jp z,format_floppy
    call jp_to_warm     ;Jump to CP/M warm start (never returns)

format_floppy:
;Perform the CBM floppy disk format.
;
    call nop_2
    ld hl,empty_string
    call print          ;Print newline

    call nop_2
    ld hl,formatting
    call print          ;Print "Formatting..."

    ld hl,l010ch
    call format

    ld hl,l0110h
    call dskerr
                        ;Fall through into format_done

format_done:
;Formatting complete (either hard disk or floppy disk).
;Check if an error occurred and then loop back.
;
    call nop_2
    ld hl,empty_string
    call print          ;Print newline

    ld hl,(l0110h)
    ld a,h
    or l
    jp nz,format_failed ;Jump if format failed

    call nop_2
    ld hl,complete
    call print          ;Print "Format Complete"

    jp next_disk        ;Loop back to beginning ("Format disk in which...")

format_failed:
    call nop_2
    ld hl,bad_disk
    call print          ;Print "Do not use diskette - try again..."

    jp next_disk        ;Loop back to beginning ("Format disk in which...")

    call jp_to_warm     ;Jump to CP/M warm start (never returns)

sub_02f5h:
    ld hl,0080h
    ld (l0112h),hl
    ld hl,(l0112h)
    ld (hl),50h
    call buffin
    ld hl,(l0112h)
    inc hl
    ld l,(hl)
    ld h,00h
    ld a,h
    or l
    jp nz,l0318h
    ld hl,0000h
    ld (l010ah),hl
    jp l0323h
l0318h:
    ld hl,(l0112h)
    inc hl
    inc hl
    ld l,(hl)
    ld h,00h
    ld (l010ah),hl
l0323h:
    ld hl,(l010ah)
    ld de,0ff9fh
    ld a,h
    rla
    jp c,l0330h
    add hl,de
    add hl,hl
l0330h:
    ccf
    sbc a,a
    ld h,a
    ld l,a
    push hl
    ld hl,(l010ah)
    ld de,0ff85h
    ld a,h
    rla
    jp c,l0342h
    add hl,de
    add hl,hl
l0342h:
    sbc a,a
    ld h,a
    ld l,a
    pop de
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a
    ld a,h
    or l
    jp z,nop_3
    ld de,0ffe0h
    ld hl,(l010ah)
    add hl,de
    ld (l010ah),hl

nop_3:
;Do nothing and return
    ret
    call jp_to_warm

bad_disk:
    db 22h, 62h, 03h
    db "Do not use diskette - try again..."
complete:
    db 0fh, 87h, 03h
    db "Format complete"
formatting:
    db 0dh, 099h, 03h
    db "Formatting..."
press_return:
    db 28h, 0a9h, 03h
    db "Press RETURN to continue, ^C to abort : "
be_formatted:
    db 14h, 0d4h, 03h
    db ": is to be formatted"
disk_on_drv:
    db 0eh, 0ebh, 03h
    db "Disk on drive "
formatting_hd:
    db 14h,0fch, 03h
    db "Formatting hard disk"
proceed_yn:
    db 10h, 13h, 04h
    db "Proceed (Y/N) ? "
will_be_eras:
    db 10h, 26h, 04h
    db ": will be erased"
data_on_hd:
    db 12h, 39h, 04h
    db "Data on hard disk "
not_in_sys:
    db 13h, 4eh, 04h
    db "Drive not in system"
doesnt_exist:
    db 15h, 64h, 04h
    db "Drive doesn't exist !"
a_to_p:
    db 20h, 7ch, 04h
    db "(A to P, or RETURN to reboot) ? "
on_which_drv:
    db 1ah, 9fh, 04h
    db "Format disk on which drive"
dashes:
    db 0ch, 0bch, 04h
    db "=== === ===="
for_pet_cpm:
    db 0dh, 0cbh, 04h
    db "For PET CP/M "
format_prog:
    db 17h, 0dbh, 04h
    db "Disk formatting program"
empty_string:
    db 00h, 0f5h, 04h
    db 00h, 00h, 00h

; Start of LOADSAVE.REL =====================================================

buffin:
;Buffered Console Input.  Caller must store buffer size at 80h.  On
;return, 81h will contain the number of data bytes and the data
;will start at 82h.
    ld c,creadstr
    ld de,0080h
    jp bdos

exsys:
;Execute a new CP/M system.  The buffer at 4000h contains a new
;CP/M system image (7168 bytes = CCP + BDOS + BIOS config + BIOS storage).
;Copy the new system into place and then jump to the BIOS to start it.
    ld bc,1c00h
    ld hl,4000h
    ld de,0d400h
    ldir
    jp runcpm

rdsys:
;Read the "CP/M" and "K" files from an IEEE-488 drive into memory.
    ld a,(hl)
    ld (l083ch),a
    call dskdev
    ld e,00h
    push de
    call sub_0635h
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    ld hl,4000h
    ld bc,1c00h
    pop de
    or a
    ret nz
    push de
    call talk
l0531h:
    call rdieee
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l0531h
    call untalk
    pop de
    push de
    call close
    pop de
    push de
    call sub_0647h
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    ld hl,6000h
    ld bc,0800h
    pop de
    or a
    ret nz
    push de
    call talk
l055eh:
    call rdieee
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l055eh
    call untalk
    pop de
    call close
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    ret

cread_:
;Read CP/M image from a Corvus drive.
    ld c,(hl)
    call seldsk
    ld de,4000h
    ld bc,0000h
cread2:
    call settrk
    push bc
    ld bc,0000h
cread1:
    call setsec
    push bc
    push de
    call read
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
    call seldsk
    ld hl,4000h
    ld bc,0000h
cwrit2:
    call settrk
    push bc
    ld bc,0000h
cwrit1:
    call setsec
    push bc
    ld bc,0080h
    ld de,0080h
    ldir
    push hl
    call write
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
    jp l07d1h

dtype:
;Get the drive type for a CP/M drive number.
    ld a,(hl)
    call tstdrv
    ld (hl),c
    inc hl
    ld (hl),00h
    ret

idisk:
;Initialize an IEEE-488 disk drive.
    ld a,(hl)
    jp idrive

dskerr:
;Check the last CBM DOS error.  The drive is not queried; this
;only reads the last error code saved in @L2.  The error code is
;returned to the caller by storing at in the address at HL.
    ld a,(l083dh)
    ld (hl),a
    inc hl
    xor a
    ld (hl),a
    ld a,(l083dh)
    or a
    ret z
    ld de,l0622h
    ld c,cwritestr
    call bdos
    ld hl,0eac0h
l060bh:
    ld e,(hl)
    push hl
    ld c,cwrite
    call bdos
    pop hl
    inc hl
    ld a,(hl)
    cp 0dh
    jr nz,l060bh
    ld de,l0632h
    ld c,cwritestr
    call bdos
    ret
l0622h:
    dec c
    ld a,(bc)
    db "Disk error : $"
l0632h:
    db 0dh,0ah,"$"

sub_0635h:
;Open "CP/M" file on an IEEE-488 drive
    ld c,06h
    ld hl,l082ah
    ld a,(l083ch)
    rra
    jp nc,open
    ld hl,l0830h
    jp open

sub_0647h:
;Open "K" file on an IEEE-488 drive
    ld c,03h
    ld hl,l0836h
    ld a,(l083ch)
    rra
    jp nc,open
    ld hl,l0839h
    jp open

savesy:
;Read the CP/M system image from an IEEE-488 drive.
    ld a,(hl)
    ld (l083ch),a
    call dskdev
    push de
    ld e,0fh
    ld hl,l0821h+1
    ld a,(l083ch)
    rra
    jr nc,l066fh
    ld hl,0826h
l066fh:
    ld c,04h
    call open
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    pop de
    cp 01h
    ret nz
    ld e,01h
    push de
    call sub_0647h
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    pop de
    or a
    ret nz
    push de
    call listen
    ld hl,6000h
    ld bc,0800h
l069dh:
    ld a,(hl)
    call wrieee
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l069dh
    call unlisten
    pop de
    push de
    call close
    pop de
    push de
    call sub_0635h
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    pop de
    or a
    ret nz
    push de
    call listen
    ld hl,4000h
    ld bc,1c00h
l06cah:
    ld a,(hl)
    call wrieee
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,l06cah
    call unlisten
    pop de
    call close
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    ret

format:
;Format an IEEE-488 drive for SoftBox use.
    ld a,(hl)
    ld (l083ch),a
    call dskdev
    ld a,(l083ch)
    and 01h
    add a,30h
    ld (l07fdh+1),a
    ld e,0fh
    ld c,14h
    ld hl,l07fdh
    call open
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    or a
    ret nz
    ld a,(l083ch)
    call idrive
    ld hl,4000h
    ld de,4001h
    ld bc,00ffh
    ld (hl),0e5h
    ldir
    ld a,07h
    ld (l0821h),a
    ld a,01h
    ld (l0820h),a
l0728h:
;Clear the CP/M directory by filling it with E5 ("unused").
    call sub_073eh
    ld a,(l083ch)
    call dsksta
    ld (l083dh),a
    or a
    ret nz
    ld hl,l0821h
    dec (hl)
    jp p,l0728h
    ret
sub_073eh:
;Write a sector to an IEEE-488 drive.
    ld hl,l0818h
    ld c,06h
    ld a,(l083ch)
    call diskcmd
    call ieeemsg
    ld a,(4000h)
    call wreoi
    call unlisten
    ld hl,l0811h
    ld c,07h
    ld a,(l083ch)
    call diskcmd
    call ieeemsg
    call creoi
    call unlisten
    ld a,(l083ch)
    call dskdev
    ld e,02h
    call listen
    ld hl,4001h
    ld c,0ffh
    call ieeemsg
    call unlisten
    ld a,(l083ch)
    call diskcmd
    ld hl,l07f8h
    ld c,05h
    call ieeemsg
    ld a,(l083ch)
    and 01h
    add a,30h
    call wrieee
    ld a,(l0820h)
    call ieeenum
    ld a,(l0821h)
    call ieeenum
    call creoi
    jp unlisten

cform:
;Format a Corvus drive for Softbox use.
    ld c,(hl)
    call seldsk
    ld hl,0080h
l07b0h:
    ld (hl),0e5h
    inc l
    jr nz,l07b0h
    ld bc,0002h
    call settrk
    ld bc,0000h
l07beh:
    push bc
    call setsec
    call write
    pop bc
    or a
    jp nz,l07d1h
    inc bc
    ld a,c
    cp 40h
    jr nz,l07beh
    ret
l07d1h:
;Display "Hit any key to abort" message, wait for a key, and then return.
    ld de,l07deh
    ld c,cwritestr
    call bdos
    ld c,01h
    jp bdos

l07deh:
    db 0dh,0ah,"Hit any key to abort : $"
l07f8h:
    db "U2 2 "
l07fdh:
    db "N0:CP/M V2.2 DISK,XX"
l0811h:
    db "B-P 2 1"
l0818h:
    db "M-W",00h,13h,01h
    db "#2"
l0820h:
    db 0c9h
l0821h:
    db 0cdh
    db "S0:*"
    db "S1:*"
l082ah:
    db "0:CP/M"
l0830h:
    db "1:CP/M"
l0836h:
    db "0:K"
l0839h:
    db "1:K"

; End of LOADSAVE.REL =======================================================

l083ch:
    pop hl              ;083c e1
l083dh:
    pop de              ;083d d1
l083eh:
    inc hl              ;083e 23
    ld a,(hl)           ;083f 7e
    dec hl              ;0840 2b
l0841h:
    ret nc              ;0841 d0
l0842h:
    call 203eh          ;0842 cd 3e 20
    call print_char     ;0845 cd 8b 09
    ret                 ;0848 c9

print_eol:
;Print end of line (CR+LF)
    ld a,0ah
    call print_char
    ld a,0dh
    call print_char
    ret

    ld a,02h            ;0854 3e 02
    ld (l083eh),a       ;0856 32 3e 08
    ld a,l              ;0859 7d
    call sub_086bh      ;085a cd 6b 08
    ld (l0841h),a       ;085d 32 41 08
    ld a,l              ;0860 7d
    call sub_086fh      ;0861 cd 6f 08
    ld (l0842h),a       ;0864 32 42 08
    ld hl,l083eh        ;0867 21 3e 08
    ret                 ;086a c9

sub_086bh:
    rrca                ;086b 0f
    rrca                ;086c 0f
    rrca                ;086d 0f
    rrca                ;086e 0f
sub_086fh:
    and 0fh             ;086f e6 0f
    cp 0ah              ;0871 fe 0a
    jp m,l0878h         ;0873 fa 78 08
    add a,07h           ;0876 c6 07
l0878h:
    add a,30h           ;0878 c6 30
    ret                 ;087a c9

sub_087bh:
    ld a,01h            ;087b 3e 01
    ld (l083eh),a       ;087d 32 3e 08
    ld a,l              ;0880 7d
    ld (l0841h),a       ;0881 32 41 08
    ld hl,l083eh        ;0884 21 3e 08
    ret                 ;0887 c9

print:
;Print string in HL followed by CR+LF
;Implements BASIC command: PRINT"foo"
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    jp z,print_eol      ;If length = 0, jump to print CR+LF only.
    call print_str      ;Print the string
    jp print_eol        ;Jump out to print CR+LF

print_:
;Print string in HL but do not send CR+LF
;Implements BASIC command: PRINT"foo";
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    ret z               ;If length = 0, return (nothing to do).
    call print_str      ;Print the string
    ret

    ld a,(hl)           ;089a 7e
    or a                ;089b b7
    jp z,l0842h+1       ;089c ca 43 08
    call print_str      ;089f cd a5 08
    jp l0842h+1         ;08a2 c3 43 08

print_str:
;Print string of length A at pointer HL.
;
    ld b,a              ;B = A
    inc hl              ;Skip string length byte
    inc hl              ;Skip ? byte
    inc hl              ;Skip ? byte
l08a9h:
    ld a,(hl)           ;Read char from string
    call print_char     ;Print it
    dec b               ;Decrement number of chars remaining
    inc hl              ;Increment pointer
    jp nz,l08a9h        ;Loop until all chars have been printed
    ret

    ld a,(bc)
    ld c,a
    jp bdos
    ex de,hl            ;08b8 eb
    pop hl              ;08b9 e1
    ld c,(hl)           ;08ba 4e
    inc hl              ;08bb 23
    ld b,(hl)           ;08bc 46
    jp l08c6h           ;08bd c3 c6 08
    ld b,h              ;08c0 44
    ld c,l              ;08c1 4d
    pop hl              ;08c2 e1
    ld e,(hl)           ;08c3 5e
    inc hl              ;08c4 23
    ld d,(hl)           ;08c5 56
l08c6h:
    inc hl              ;08c6 23
    push hl             ;08c7 e5
    jp l08ceh           ;08c8 c3 ce 08
    ex de,hl            ;08cb eb
    ld b,h              ;08cc 44
    ld c,l              ;08cd 4d
l08ceh:
    ld a,d              ;08ce 7a
    cpl                 ;08cf 2f
    ld d,a              ;08d0 57
    ld a,e              ;08d1 7b
    cpl                 ;08d2 2f
    ld e,a              ;08d3 5f
    inc de              ;08d4 13
    ld hl,0000h         ;08d5 21 00 00
    ld a,11h            ;08d8 3e 11
l08dah:
    push hl             ;08da e5
    add hl,de           ;08db 19
    jp nc,l08e0h        ;08dc d2 e0 08
    ex (sp),hl          ;08df e3
l08e0h:
    pop hl              ;08e0 e1
    push af             ;08e1 f5
    ld a,c              ;08e2 79
    rla                 ;08e3 17
    ld c,a              ;08e4 4f
    ld a,b              ;08e5 78
    rla                 ;08e6 17
    ld b,a              ;08e7 47
    ld a,l              ;08e8 7d
    rla                 ;08e9 17
    ld l,a              ;08ea 6f
    ld a,h              ;08eb 7c
    rla                 ;08ec 17
    ld h,a              ;08ed 67
    pop af              ;08ee f1
    dec a               ;08ef 3d
    jp nz,l08dah        ;08f0 c2 da 08
    ld l,c              ;08f3 69
    ld h,b              ;08f4 60
    ret                 ;08f5 c9
    ld b,h              ;08f6 44
    ld c,l              ;08f7 4d
    pop hl              ;08f8 e1
    ld e,(hl)           ;08f9 5e
    inc hl              ;08fa 23
    ld d,(hl)           ;08fb 56
    inc hl              ;08fc 23
    push hl             ;08fd e5
    ld l,c              ;08fe 69
    ld h,b              ;08ff 60
    ld a,h              ;0900 7c
    or l                ;0901 b5
    ret z               ;0902 c8
    ex de,hl            ;0903 eb
    ld a,h              ;0904 7c
    or l                ;0905 b5
    ret z               ;0906 c8
    ld b,h              ;0907 44
    ld c,l              ;0908 4d
    ld hl,0000h         ;0909 21 00 00
    ld a,10h            ;090c 3e 10
l090eh:
    add hl,hl           ;090e 29
    ex de,hl            ;090f eb
    add hl,hl           ;0910 29
    ex de,hl            ;0911 eb
    jp nc,l0916h        ;0912 d2 16 09
    add hl,bc           ;0915 09
l0916h:
    dec a               ;0916 3d
    jp nz,l090eh        ;0917 c2 0e 09
    ret                 ;091a c9
    call sub_0932h      ;091b cd 32 09
    ld a,20h            ;091e 3e 20
    call print_char     ;0920 cd 8b 09
    ret                 ;0923 c9
    call sub_0932h      ;0924 cd 32 09
    ld a,0ah            ;0927 3e 0a
    call print_char     ;0929 cd 8b 09
    ld a,0dh            ;092c 3e 0d
    call print_char     ;092e cd 8b 09
    ret                 ;0931 c9
sub_0932h:
    push hl             ;0932 e5
    ld a,h              ;0933 7c
    and 80h             ;0934 e6 80
    jp z,l0945h         ;0936 ca 45 09
    ld a,l              ;0939 7d
    cpl                 ;093a 2f
    ld l,a              ;093b 6f
    ld a,h              ;093c 7c
    cpl                 ;093d 2f
    ld h,a              ;093e 67
    inc hl              ;093f 23
    ld a,2dh            ;0940 3e 2d
    call print_char     ;0942 cd 8b 09
l0945h:
    ld c,30h            ;0945 0e 30
    ld de,2710h         ;0947 11 10 27
    call sub_0967h      ;094a cd 67 09
    ld de,disk_on_drv   ;094d 11 e8 03
    call sub_0967h      ;0950 cd 67 09
    ld de,0064h         ;0953 11 64 00
    call sub_0967h      ;0956 cd 67 09
    ld de,000ah         ;0959 11 0a 00
    call sub_0967h      ;095c cd 67 09
    ld de,0001h         ;095f 11 01 00
    call sub_0967h      ;0962 cd 67 09
    pop hl              ;0965 e1
    ret                 ;0966 c9
sub_0967h:
    call sub_0979h      ;0967 cd 79 09
    jp c,l0971h         ;096a da 71 09
    inc c               ;096d 0c
    jp sub_0967h        ;096e c3 67 09
l0971h:
    ld a,c              ;0971 79
    call print_char     ;0972 cd 8b 09
    add hl,de           ;0975 19
    ld c,30h            ;0976 0e 30
    ret                 ;0978 c9
sub_0979h:
    ld a,l              ;0979 7d
    sub e               ;097a 93
    ld l,a              ;097b 6f
    ld a,h              ;097c 7c
    sbc a,d             ;097d 9a
    ld h,a              ;097e 67
    ret                 ;097f c9

jp_to_warm:
;Jump to CP/M warm start
    jp warm

jp_to_hl:
;Jump to the address in HL
    jp (hl)

nop_1:
;Do nothing and return
    ret                 ;0984 c9
    ld hl,0fffeh        ;0985 21 fe ff
    jp l099ah           ;0988 c3 9a 09

print_char:
;Write the char in A to the console
    push hl
    push de
    push bc
    push af
    ld c,cwrite
    ld e,a
    call bdos
    pop af
    pop bc
    pop de
    pop hl

nop_2:
;Do nothing and return
    ret                 ;0999 c9

l099ah:
    push de             ;099a d5
    push bc             ;099b c5
    push hl             ;099c e5
    ld c,cread          ;099d 0e 01
    call bdos           ;099f cd 05 00
    pop hl              ;09a2 e1
    ld (hl),a           ;09a3 77
    inc hl              ;09a4 23
    ld (hl),00h         ;09a5 36 00
    pop bc              ;09a7 c1
    pop de              ;09a8 d1
    ret                 ;09a9 c9

    ld a,(hl)           ;09aa 7e
    jp print_char       ;09ab c3 8b 09
l09aeh:
    cp 04h              ;09ae fe 04
l09b0h:
    jp c,0d33eh         ;09b0 da 3e d3
    ld (l09aeh),a       ;09b3 32 ae 09
    ld a,l              ;09b6 7d
    ld (l09aeh+1),a     ;09b7 32 af 09
    ld a,0c9h           ;09ba 3e c9
    ld (l09b0h),a       ;09bc 32 b0 09
    ld a,e              ;09bf 7b
    jp l09aeh           ;09c0 c3 ae 09
    ld a,0dbh           ;09c3 3e db
    ld (l09aeh),a       ;09c5 32 ae 09
    ld a,l              ;09c8 7d
    ld (l09aeh+1),a     ;09c9 32 af 09
    ld a,0c9h           ;09cc 3e c9
l09ceh:
    ld (l09b0h),a       ;09ce 32 b0 09
    call l09aeh         ;09d1 cd ae 09
l09d4h:
    ld h,00h            ;09d4 26 00
    ld l,a              ;09d6 6f
    ret                 ;09d7 c9
    push af             ;09d8 f5
    ld a,0c0h           ;09d9 3e c0
    jr nc,l09ceh        ;09db 30 f1
    ret                 ;09dd c9

    push af             ;09de f5
    ld a,40h            ;09df 3e 40
    jr nc,l09d4h        ;09e1 30 f1
    ret                 ;09e3 c9
    ei                  ;09e4 fb
    ret                 ;09e5 c9
    di                  ;09e6 f3
    ret                 ;09e7 c9

    ld a,c              ;09e8 79
    add hl,bc           ;09e9 09
    jp c,l0971h         ;09ea da 71 09
    inc c               ;09ed 0c
    jp sub_0967h        ;09ee c3 67 09
    ld a,c              ;09f1 79
    call print_char     ;09f2 cd 8b 09
    add hl,de           ;09f5 19
    ld c,30h            ;09f6 0e 30
    ret                 ;09f8 c9

    ld a,l              ;09f9 7d
    sub e               ;09fa 93
    ld l,a              ;09fb 6f
    ld a,h              ;09fc 7c
    sbc a,d             ;09fd 9a
    ld h,a              ;09fe 67
    ret                 ;09ff c9
