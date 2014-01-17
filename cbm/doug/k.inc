; k.incl
;
; Parameters common to the subroutines used in the
; SOFTBOX terminal emulation program 'k'.
;
; ZERO PAGE EQUATES
        crblink equ $01         ; cursor blink count register
        scraddr equ $02         ; address of start of current line
        curcol  equ $04         ; holds cursor column number
        currow  equ $05         ; holds cursor row number
        curflg  equ $06         ; cursor on/off flag
        curchar equ $07         ; current character under cursor
        nchar   equ $08         ; number of characters in keyboard buffer
        scrsz   equ $09         ; screen size (number of columns per line)
        rvrsflg equ $0A         ; reverse flag
      curposflg equ $0B         ; flag for cursor positioning
        curflgs equ $0C         ; old value of curflg
        T1      equ $0D         ; indirect address location $0D & $0E
        T2      equ $0F         ; indirect address location $0F & $10
        nbytes  equ $11         ; 2 byte integer, no. of bytes in block transfer
        mask    equ $13         ; bit 7 mask
        jif     equ $14         ; number of jiffies
        secs    equ $15         ; number of seconds
        min     equ $16         ; number of minutes
        hrs     equ $17         ; number of hours
        nints   equ $18         ; number of interrupts, 3 bytes
        intvctr equ $90         ; location of interupt vector

; OTHER EQUATES
        keybuf  equ $026F       ; start of the keyboard input buffer

; SPECIAL CLOCK FREQUENCY
        freq    equ $0403       ; This position is the first line number of
                                ; the BASIC starter program.  This line
                                ; number is modified when the CP/M 'newsys'
                                ; program is run to set a new clock frequency.

; FIXED PARAMETERS
        blank   equ $20         ; blank character
        screen  equ $8000       ; screen origin
        bufsize equ 80          ; length of tabs buffer
        keybufsize equ 80       ; length of keyboard buffer

; NUMBER OF LINES IN THE SCREEN
        nlines  equ 24          ; This sets the number of screen lines
                                ; to 25.  For many CP/M programs, an
                                ; implicit assumption is one of a 24
                                ; line screen and these will not run
                                ; properly with a 25 line screen.  To
                                ; change the number of lines to 24 (or
                                ; fewer) change this parameter and
                                ; assemble the following subroutines
                                ;    putchar.asm
                                ;    clreos.asm
                                ;    scrollup.asm
                                ;    setcur.asm
                                ;    insrtln.asm

; REPEATING KEY PARAMETERS
                                ; If these parameters are changed, only one
                                ; routine 'inthndlr' needs to be re-assembled
                                ; and re-linked.
        ndelay  equ 16          ; Number of interrupts before a continuously
                                ; pressed key will begin to repeat.
        nrepeat equ 4           ; Number of interrupts between repeats of a key.
        ncurs   equ 2           ; Number of interrupts between cursor flashes
                                ; while a key is being repeated. This should
                                ; be half the value of nrepeat to work in
                                ; harmony.
