; home.asm

; PURPOSE       To set the cursor position coordinates at
;               home position.

;include <k.incl>

; EXTERNAL DEFINITION
        xdef home

home    equ *
        lda #$00        ; Place zero in
        sta currow      ; the row and
        sta curcol      ; column pointers
        rts             ; and return
