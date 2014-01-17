; scankybrd.asm

; PURPOSE:      To scan the keyboard and make the ascii characters.
;               Returns with zero flag set if no key pressed.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef scankybrd

        xdef key        ; holds the key value
        xdef delay      ; first delay (number of interrupts) for repeat keys
        xdef repeat     ; number of interrupts between repeat keys
        xdef keyold     ; last key pressed, used for repeat key processing
        xdef buff       ; tab setting buffer

scankybrd equ *
        lda key
        sta keytemp             ; save last value of key,  may have been
                                ;   changed externally for repeated keys.
        ldx #0                  ; initialize the key table index
        stx shift               ;            the shift key flag
        stx control             ;            the control key flag
        stx $E810               ; start with the first row of keys
        lda #$FF
        sta key                 ; set an undefined key value in key
        lda #$0A
        sta rowkount            ; and scan 10 rows

        loop
           ldy #8
           loop                 ; debounce routine ?
              lda $E812
              cmp $E812
           until eq
           loop
              guess
                  lsr                   ; shift right bit into carry
                  pha                   ; and save remainder
                quif cs                 ; test carry (ie was a key pressed)
                  lda scrsz             ; test screen size
                  cmp #80               ; and retrieve the key value
                  if eq                 ; from the appropriate table.
                      lda keys80,x
                  else
                      lda keys40,x
                  endif
                  cmp #1                ; is it a shift key?
                  beq L1                ; if it is increment shift flag
                  bcc L2                ; if <1  control key, incr. control
                  sta key               ; otherwise save key value in key
                quif cs
L1                inc shift
                quif ne
L2                inc control
              endguess
              pla                       ; retrieve the saved left part of $E812
              inx                       ; increment the key table index
              dey                       ; decrement the counter
           until eq
           inc $E810                    ; go for the next row of keys
           dec rowkount
        until eq

        lda key
        cmp #$FF                ; was a new key pressed
        beq L3
        cmp keytemp             ; this will have been changed by the repeat
        beq L3                  ; key routine to force repeat key.

; NUMERIC KEYS WHICH SHIFT TO SPECIAL CHARACTERS
; (These keys are indicated by setting high bit in the table)
        guess
            cmp #0              ; test whether the high bit is set
          quif pl
            and #$7F            ; if hi bit is set, remove it
            ldy shift           ; and test for shift
          quif eq
            eor #$10            ; turn off bit 4 on shifted character
            rts
        endguess

; ALPHABETIC KEYS
        guess
            cmp #$40            ; quif A < $40
          quif cc
            cmp #$60            ; quif A >= $60
          quif cs
            ldy control
            if ne               ; if control key on
                and #$1F        ; then mask of higher bits
L3              rts             ; and return
            endif
            cmp #$40            ; now just look at A <= key <= Z
          quif eq               ; quif key = @
            cmp #$5B
          quif cs               ; quif key >= [
            ldy shift
          quif ne               ; quit if shift key pressed
            pha                 ; if not, save A and check
            lda $E84C           ; if graphics mode has been set
            lsr
            lsr
            pla
          quif cc               ; if it has, dont make lower case
            ora #$20            ; otherwise shift up to lower case ascii
            rts                 ; and return
        endguess

; SPECIAL SHIFTED CHARACTERS
        ldy shift               ; was shift key pressed?
        beq L4

        guess
            ldx #$0B            ; change to $0B (cursor up)
            cmp #$0A            ;      from $0A (line feed or cursor down)
          quif eq
            ldx #$08            ; change to $08 (back space)
            cmp #$0C            ;      from $0C (cursor left key)
          quif eq
            ldx #$1A
            cmp #$1E
          quif eq
            pha                 ; check for graphics mode
            lda $E84C
            lsr
            lsr
            pla
            bcs L4              ; branch if not set
            ora #$80            ; else set high bit for shifted graphics
            rts
        endguess
        txa
        rts

L4      cmp #$00
        rts


keys40  fcb $21, $23, $25, $26, $28, $5F, $1E, $0C      ; 40 col screen
        fcb $22, $24, $27, $5C, $29, $FF, $0A, $7F
        fcb $51, $45, $54, $55, $4F, $5E, $37, $39
        fcb $57, $52, $59, $49, $50, $FF, $38, $2F
        fcb $41, $44, $47, $4A, $4C, $FF, $34, $36
        fcb $53, $46, $48, $4B, $3A, $FF, $35, $2A
        fcb $5A, $43, $42, $4D, $3B, $0D, $31, $33
        fcb $58, $56, $4E, $2C, $3F, $FF, $32, $2B
        fcb $01, $40, $5D, $FF, $3E, $01, $30, $2D
        fcb $00, $5B, $20, $3C, $1B, $ff, $2E, $3D

keys80  fcb $B2, $B5, $B8, $AD, $38, $0C, $FF, $FF      ; 80 col screen
        fcb $B1, $B4, $B7, $30, $37, $5E, $FF, $39
        fcb $1B, $53, $46, $48, $5D, $4B, $BB, $35
        fcb $41, $44, $47, $4A, $0D, $4C, $40, $36
        fcb $09, $57, $52, $59, $5C, $49, $50, $7F
        fcb $51, $45, $54, $55, $0A, $4F, $5B, $34
        fcb $01, $43, $42, $AE, $2E, $FF, $01, $33
        fcb $5A, $56, $4E, $AC, $30, $FF, $FF, $32
        fcb $00, $58, $20, $4D, $1E, $FF, $AF, $31
        fcb $5F, $B3, $B6, $B9, $FF, $BA, $FF, $FF

key         rmb 1       ; holds the key value
keytemp     rmb 1       ; temporarily holds previous key value
rowkount    rmb 1       ; row counter for key scan
shift       rmb 1       ; shifted key flag
control     rmb 1       ; control key flag
delay       rmb 1       ; no. interrupts to start of key repeats
repeat      rmb 1       ; number of interrupts to next repeat
keyold      rmb 1       ; value of last key - used in repeat key processing

buff        rmb 80      ; tab setting buffer
