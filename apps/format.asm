;FORMAT.COM
;  Format a disk for use with SoftBox CP/M.
;
;Both CBM floppy drives and Corvus hard drives are supported.  For a CBM
;floppy, the disk may be unformatted because the program will first format it
;with CBM DOS before writing the CP/M filesystem.  For a Corvus hard drive,
;the drive must already have been prepared using the Corvus diagnostics.
;
;Usage: "FORMAT"  Accepts no arguments.  The program will prompt for
;                 a drive letter and confirmation.
;
;This is a disassembly of a compiled BASIC program.  FORMAT.COM was
;originally written in Microsoft BASIC (MBASIC).  It was then compiled
;with Microsoft BASIC Compiler (BASCOM) and linked with the SoftBox
;support library LOADSAVE.REL using Microsoft Link-80 (L80).
;

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point
dma_buf:       equ  0080h ;Default DMA buffer area (128 bytes) for disk I/O
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

bell:          equ 07h    ;Bell
lf:            equ 0ah    ;Line Feed
cr:            equ 0dh    ;Carriage Return

    org 0100h

    jp start

unused_1:
    nop                 ;0103 00
    nop                 ;0104 00
    nop                 ;0105 00
    nop                 ;0106 00
    nop                 ;0107 00
    nop                 ;0108 00
    nop                 ;0109 00

first_char:
    dw 0                ;First char of user input from any prompt
drv_num:
    dw 0                ;CP/M source drive number (0=A:, 1=B:, ...)
drv_typ:
    dw 0                ;Drive type (from dtypes table)
cbm_err:
    dw 0                ;Last error code from CBM DOS
buf_addr:
    dw 0                ;Address of buffer used in get_char

unused_2:
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

unused_3:
    push af             ;0124 f5
    inc b               ;0125 04
    nop                 ;0126 00
    nop                 ;0127 00
    rst 30h             ;0128 f7
    inc b               ;0129 04
    inc bc              ;012a 03
    ld bc,unused_2      ;012b 01 14 01
    nop                 ;012e 00
    nop                 ;012f 00
    ld e,01h            ;0130 1e 01

main:
;Print the welcome banner.
;
    call nop_1
    call pr0a
    ld hl,empty_string
    call pv2d           ;Print newline

    call pr0a
    ld hl,empty_string
    call pv2d           ;Print newline

    call pr0a
    ld hl,format_prog
    call pv2d           ;Print "Disk formatting program"

    call pr0a
    ld hl,for_pet_cpm   ;Print "For PET CP/M "
    call pv2d

    call pr0a
    ld hl,dashes
    call pv2d           ;Print "=== === ===="

next_disk:
;Prompt for a drive letter.  If no letter is entered,
;warm start back to CP/M.
;
    call pr0a
    ld hl,empty_string
    call pv2d           ;Print newline

    call pr0a
    ld hl,on_which_drv
    call pv2d           ;Print "Format disk on which drive"

    call pr0a
    ld hl,a_to_p
    call pv1d           ;Print "(A to P, or RETURN to reboot) ? "

    call get_char       ;Get a character from the user

    call pr0a
    ld hl,empty_string
    call pv2d           ;Print newline

    ld hl,(first_char)
    ld a,h
    or l
    jp nz,check_letter  ;Jump to check drive if a letter was entered
    call end            ;No letter: call END to warm start (never returns)

check_letter:
;Check that the letter is in the range of valid letters (A-P).
;
                        ;Convert ASCII char from input to CP/M drive number:
    ld de,0-"A"         ;  DE = 0ffbfh (0 - 41h)
    ld hl,(first_char)  ;  HL = first char from user input
    add hl,de           ;  HL = HL + DE
    ld (drv_num),hl     ;  Store HL in drv_num
    ld hl,(drv_num)     ;  HL = Read value back from drv_num

    add hl,hl
    sbc a,a
    ld h,a
    ld l,a
    push hl
    ld hl,(drv_num)
    ld de,0fff0h
    ld a,h
    rla
    jp c,l01b3h
    add hl,de
    add hl,hl
l01b3h:
    ccf                 ;Clear carry flag
    sbc a,a             ;Sets A=0, carry flag stays cleared
    ld h,a              ;H = 0
    ld l,a              ;L = 0

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

    call pr0a
    ld hl,doesnt_exist
    call pv2d           ;Print "Drive doesn't exist !"

    jp next_disk        ;Loop back to beginning ("Format disk in which...")

check_type:
;Check that a drive has been configured at the drive letter entered.
;
    ld hl,(drv_num)     ;HL = CP/M drive number
    ld (drv_typ),hl     ;Store drive number in drv_type to pass it to dtype

    ld hl,drv_typ       ;HL = address of drv_type
    call dtype          ;Get drive type for CP/M drive number
                        ;  Before the call, drv_type holds a drive number
                        ;  After the call, drv_type holds its drive type

    ld hl,(drv_typ)     ;HL = drive type returned by dtype
    ld de,0ff80h

    ld a,h
    rla
    jp c,l01e8h

    add hl,de
    add hl,hl
l01e8h:
    jp c,floppy_or_hard

    call pr0a
    ld hl,not_in_sys
    call pv2d           ;Print "Drive not in system"

    jp next_disk        ;Loop back to beginning ("Format disk in which...")

floppy_or_hard:
;Determine if the drive to be formatted is a CBM floppy drive
;or a Corvus hard drive.
;
    ld hl,(drv_typ)
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
    ld hl,(drv_typ)
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

    call pr0a
    ld hl,bell
    call chr            ;Temp string = bell character
    call pv1d           ;Print temp string

    ld hl,data_on_hd
    call pv1d           ;Print "Data on hard disk "

    ld hl,(first_char)
    call chr            ;Temp string = drive letter
    call pv1d           ;Print temp string

    ld hl,will_be_eras
    call pv2d           ;Print ": will be erased"

    call pr0a
    ld hl,proceed_yn
    call pv1d           ;Print "Proceed (Y/N) ? "

    call get_char       ;Get a character from the user

                        ;Jump to format if char is "Y":
    ld hl,(first_char)  ;  HL = char typed by user ("Y" = 59h)
    ld de,0-"Y"         ;  DE = 0ffa7h (0 - 59h)
    add hl,de           ;  HL = HL + DE
    ld a,h              ;
    or l                ;  Is the result zero?
    jp z,format_hard    ;    Yes: jump to format

    call end            ;Call END to warm start (never returns)

format_hard:
;Perform the Corvus hard disk format.
;
    call pr0a
    ld hl,empty_string
    call pv2d           ;Print newline

    call pr0a
    ld hl,formatting_hd
    call pv2d           ;Print "Formatting hard disk"

    ld hl,drv_num       ;HL = address of CP/M drive number of Corvus
    call cform          ;Format the Corvus hard disk
    jp format_done

prompt_floppy:
;Prompt for confirmation to format the floppy disk.
;
    call pr0a
    ld hl,disk_on_drv
    call pv1d           ;Print "Disk on drive "

    ld hl,(first_char)
    call chr            ;Temp string = drive letter
    call pv1d           ;Print temp string

    ld hl,be_formatted
    call pv2d           ;Print ": is to be formatted"

    call pr0a
    ld hl,press_return
    call pv1d           ;Print "Press RETURN to continue, ^C to abort : "

    call get_char       ;Get a character from the user

    ld hl,(first_char)
    ld a,h
    or l
    jp z,format_floppy
    call end            ;Call END to warm start (never returns)

format_floppy:
;Perform the CBM floppy disk format.
;
    call pr0a
    ld hl,empty_string
    call pv2d           ;Print newline

    call pr0a
    ld hl,formatting
    call pv2d           ;Print "Formatting..."

    ld hl,drv_num       ;HL = address of CP/M drive number of CBM floppy
    call format         ;Format the CBM floppy disk

    ld hl,cbm_err       ;HL = address to receive CBM DOS error code
    call dskerr         ;Check CBM DOS error

                        ;Fall through into format_done

format_done:
;Formatting complete (either hard disk or floppy disk).
;Check if an error occurred and then loop back.
;
    call pr0a
    ld hl,empty_string
    call pv2d           ;Print newline

                        ;Handle CBM DOS error:
    ld hl,(cbm_err)     ;  HL = last error code from CBM DOS
    ld a,h              ;
    or l                ;  Error code = 0 (OK)?
    jp nz,format_failed ;    No: jump to format failed

    call pr0a
    ld hl,complete
    call pv2d           ;Print "Format complete"

    jp next_disk        ;Loop back to beginning ("Format disk in which...")

format_failed:
    call pr0a
    ld hl,bad_disk
    call pv2d           ;Print "Do not use diskette - try again..."

    jp next_disk        ;Loop back to beginning ("Format disk in which...")

    call end            ;Call END to warm start (never returns)

get_char:
;Get a line of input from the user and save the first character
;in first_char.  If the char is alphabetic, it will be normalized
;to uppercase.  If nothing was entered, first_char will be zero.
;
    ld hl,dma_buf       ;HL = address of CP/M default DMA buffer area
    ld (buf_addr),hl    ;Store it in buf_addr

    ld hl,(buf_addr)    ;HL = address of buffer area
    ld (hl),50h         ;Store buffer size (80 bytes) in buf_addr+0

    call buffin         ;Perform buffered console input via BDOS call
                        ;  0Ah (CREADSTR).

    ld hl,(buf_addr)    ;HL = address of CP/M DMA buffer area
    inc hl              ;Increment HL so it points to buf_addr+1
    ld l,(hl)           ;L = number of valid chars in buffer

    ld h,00h
    ld a,h
    or l                ;Is there any data in the buffer?
    jp nz,l0318h        ;  Yes: jump to l0318h

                        ;Nothing was entered, store 0 in first_char:
    ld hl,0000h         ;  HL = 0
    ld (first_char),hl  ;  Store HL in first_char
    jp l0323h           ;  Jump to l0323h

l0318h:
;A character was entered.  Store it in first_char.
;
    ld hl,(buf_addr)    ;HL = buf_addr + 2 (first char in the buffer)
    inc hl
    inc hl

    ld l,(hl)           ;Store the first char in the buffer in first_char
    ld h,00h
    ld (first_char),hl

l0323h:
;Normalize first_char to uppercase.
;
;If (first_char >= 61h) and (first_char <= 7Ah) then
;  first_char = first_char - 20h
;
    ld hl,(first_char)  ;HL = first char from user input (or zero if none)
    ld de,0-"a"         ;DE = 0ff9fh (0 - 61h)
    ld a,h
    rla
    jp c,l0330h
    add hl,de
    add hl,hl
l0330h:
    ccf                 ;Clear carry flag
    sbc a,a             ;Sets A=0, carry stays the same
    ld h,a              ;H = 0
    ld l,a              ;L = 0
    push hl             ;Push 0000h onto stack

    ld hl,(first_char)  ;HL = first char from user input (or zero if none)
    ld de,0-"z"-1       ;DE = 0ff85h (0 - 7Bh)
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

    ld a,h              ;H = H & D
    and d
    ld h,a

    ld a,l              ;L = L & E
    and e
    ld l,a

    ld a,h              ;Jump to l035bh if HL = 0
    or l
    jp z,l035bh
                        ;Convert lowercase char to uppercase:
    ld de,0-20h         ;  DE = 0ffe0h
    ld hl,(first_char)  ;  HL = first char from input
    add hl,de           ;  Add 20h to convert char to uppercase
    ld (first_char),hl  ;  Save normalized char
l035bh:
    ret

unused_30:
    call end

bad_disk:
    db 22h
    dw bad_disk+3
    db "Do not use diskette - try again..."

complete:
    db 0fh
    dw complete+3
    db "Format complete"

formatting:
    db 0dh
    dw formatting+3
    db "Formatting..."

press_return:
    db 28h
    dw press_return+3
    db "Press RETURN to continue, ^C to abort : "

be_formatted:
    db 14h
    dw be_formatted+3
    db ": is to be formatted"

disk_on_drv:
    db 0eh
    dw disk_on_drv+3
    db "Disk on drive "

formatting_hd:
    db 14h
    dw formatting_hd+3
    db "Formatting hard disk"

proceed_yn:
    db 10h
    dw proceed_yn+3
    db "Proceed (Y/N) ? "

will_be_eras:
    db 10h
    dw will_be_eras+3
    db ": will be erased"

data_on_hd:
    db 12h
    dw data_on_hd+3
    db "Data on hard disk "

not_in_sys:
    db 13h
    dw not_in_sys+3
    db "Drive not in system"

doesnt_exist:
    db 15h
    dw doesnt_exist+3
    db "Drive doesn't exist !"

a_to_p:
    db 20h
    dw a_to_p+3
    db "(A to P, or RETURN to reboot) ? "

on_which_drv:
    db 1ah
    dw on_which_drv+3
    db "Format disk on which drive"

dashes:
    db 0ch
    dw dashes+3
    db "=== === ===="

for_pet_cpm:
    db 0dh
    dw for_pet_cpm+3
    db "For PET CP/M "

format_prog:
    db 17h
    dw format_prog+3
    db "Disk formatting program"

empty_string:
    db 00h
    dw empty_string+3
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
    cp cr
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
    db cr,lf,"$"

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
    db cr,lf,"Hit any key to abort : $"
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

l083ch:
    db 0e1h
l083dh:
    db 0d1h

; End of LOADSAVE.REL =======================================================

tmp:
;Temporary string
    db 23h              ;header: string length
    dw 2b7eh            ;header: start address of string
    db 0d0h, 0cdh       ;string data (not at start address ??)

unused_4:
    ld a,' '
    call print_char
    ret

print_eol:
;Print end of line (CR+LF)
    ld a,lf
    call print_char
    ld a,cr
    call print_char
    ret

unused_5:
    ld a,02h
    ld (tmp),a
    ld a,l
    call unused_6
    ld (tmp+3),a
    ld a,l
    call unused_7
    ld (tmp+4),a
    ld hl,tmp
    ret

unused_6:
    rrca
    rrca
    rrca
    rrca
unused_7:
    and 0fh
    cp 0ah
    jp m,unused_8
    add a,07h
unused_8:
    add a,30h
    ret

chr:
;Make a temporary string from the char in L and
;return a pointer to it in HL.
;Implements BASIC function: CHR$(x)
;
    ld a,01h            ;A = 1 byte in string
    ld (tmp),a          ;Store length in temp string header
    ld a,l              ;A = L
    ld (tmp+3),a        ;Store A as the temp string data
    ld hl,tmp           ;HL = address of the string
    ret

pv2d:
;Print string in HL followed by CR+LF
;Implements BASIC command: PRINT"foo"
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    jp z,print_eol      ;If length = 0, jump to print CR+LF only.
    call print_str      ;Print the string
    jp print_eol        ;Jump out to print CR+LF

pv1d:
;Print string in HL but do not send CR+LF
;Implements BASIC command: PRINT"foo";
;
    ld a,(hl)           ;Get the length of the string
    or a                ;Set flags
    ret z               ;If length = 0, return (nothing to do).
    call print_str      ;Print the string
    ret

unused_29:
    ld a,(hl)
    or a
    jp z,unused_4
    call print_str
    jp unused_4

print_str:
;Print string of length A at pointer HL.
;
    ld b,a              ;B = A
    inc hl              ;Skip string length byte
    inc hl              ;Skip string start address low byte
    inc hl              ;Skip string start address high byte
l08a9h:
    ld a,(hl)           ;Read char from string
    call print_char     ;Print it
    dec b               ;Decrement number of chars remaining
    inc hl              ;Increment pointer
    jp nz,l08a9h        ;Loop until all chars have been printed
    ret

unused_9:
    ld a,(bc)
    ld c,a
    jp bdos
    ex de,hl
    pop hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    jp unused_10
    ld b,h
    ld c,l
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
unused_10:
    inc hl
    push hl
    jp unused_11
    ex de,hl
    ld b,h
    ld c,l
unused_11:
    ld a,d
    cpl
    ld d,a
    ld a,e
    cpl
    ld e,a
    inc de
    ld hl,0000h
    ld a,11h
unused_12:
    push hl
    add hl,de
    jp nc,unused_13
    ex (sp),hl
unused_13:
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
    jp nz,unused_12
    ld l,c
    ld h,b
    ret
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
unused_14:
    add hl,hl
    ex de,hl
    add hl,hl
    ex de,hl
    jp nc,unused_15
    add hl,bc
unused_15:
    dec a
    jp nz,unused_14
    ret
    call unused_16
    ld a,20h
    call print_char
    ret
    call unused_16
    ld a,lf
    call print_char
    ld a,cr
    call print_char
    ret

unused_16:
    push hl
    ld a,h
    and 80h
    jp z,unused_17
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    inc hl
    ld a,2dh
    call print_char
unused_17:
    ld c,30h
    ld de,2710h
    call unused_18
    ld de,03e8h
    call unused_18
    ld de,0064h
    call unused_18
    ld de,000ah
    call unused_18
    ld de,0001h
    call unused_18
    pop hl
    ret

unused_18:
    call unused_20
    jp c,unused_19
    inc c
    jp unused_18

unused_19:
    ld a,c
    call print_char
    add hl,de
    ld c,30h
    ret

unused_20:
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    ld h,a
    ret

end:
;Jump to CP/M warm start
;Implements BASIC command: END
    jp warm

jp_to_hl:
;Jump to the address in HL
    jp (hl)

nop_1:
;Do nothing and return
    ret

unused_31:
    ld hl,0fffeh
    jp unused_21

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

pr0a:
;Do nothing and return
    ret

unused_21:
    push de
    push bc
    push hl
    ld c,cread
    call bdos
    pop hl
    ld (hl),a
    inc hl
    ld (hl),00h
    pop bc
    pop de
    ret

    ld a,(hl)
    jp print_char
unused_22:
    cp 04h
unused_23:
    jp c,0d33eh
    ld (unused_22),a
    ld a,l
    ld (unused_22+1),a
    ld a,0c9h
    ld (unused_23),a
    ld a,e
    jp unused_22
    ld a,0dbh
    ld (unused_22),a
    ld a,l
    ld (unused_22+1),a
    ld a,0c9h
unused_24:
    ld (unused_23),a
    call unused_22
unused_25:
    ld h,00h
    ld l,a
    ret
    push af
    ld a,0c0h
    jr nc,unused_24
    ret

unused_26:
    push af
    ld a,40h
    jr nc,unused_25
    ret
    ei
    ret
    di
    ret

unused_27:
    ld a,c
    add hl,bc
    jp c,unused_19
    inc c
    jp unused_18
    ld a,c
    call print_char
    add hl,de
    ld c,30h
    ret

unused_28:
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    ld h,a
    ret
