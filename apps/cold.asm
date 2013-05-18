;COLD.COM
;  Cold start the SoftBox and CBM computer
;
;The "UJ" command will be sent to IEEE-488 device 8, the CBM
;computer instructed to jump to its reset vector, and then
;the SoftBox will cold start.
;
;Usage:
;  "COLD"
;

boot:          equ 0f000h ;BIOS Cold start
ieee_listen:   equ 0f033h ;BIOS Send LISTEN to an IEEE-488 device
ieee_unlisten: equ 0f036h ;BIOS Send UNLISTEN to all IEEE-488 devices
ieee_eoi_cr:   equ 0f048h ;BIOS Send carriage return to IEEE-488 dev with EOI
ieee_put_str:  equ 0f04bh ;BIOS Send string to the current IEEE-488 device
execute:       equ 0f066h ;BIOS Execute a subroutine in CBM memory
peek:          equ 0f06ch ;BIOS Transfer bytes from CBM memory to the SoftBox

    org 0100h           ;CP/M TPA

                        ;Get address of CBM cold start routine:
    ld bc,0002h         ;  BC = 2 bytes to transfer
    ld de,0fffch        ;  DE = start address on CBM (6502 reset vector)
    ld hl,cbm_cold      ;  HL = start address on SoftBox
    call peek           ;  Transfer bytes from CBM to SoftBox

                        ;Send reset command to drive 8:
    ld de,080fh         ;  D = IEEE-488 primary address 8
                        ;  E = IEEE-488 secondary address 15 (command)
    call ieee_listen    ;  Send LISTEN
    ld hl,dos_uj        ;  HL = address of "UJ" string
    ld c,02h            ;  C = 2 bytes in string
    call ieee_put_str   ;  Send the string
    call ieee_eoi_cr    ;  Send carriage return with EOI
    call ieee_unlisten  ;  Send UNLISTEN

                        ;Reset CBM computer and SoftBox:
    ld hl,(cbm_cold)    ;  HL = address of CBM cold start routine
    call execute        ;  Execute cold start routine on CBM
    jp boot             ;  Cold start SoftBox

dos_uj:
    db "UJ"             ;CBM DOS reset command

cbm_cold:
    dw 0                ;Stores address of CBM cold start routine
