;These values use bit 7 of the output port as SDA, and bit 6 of
;the output port as SCL.
SDA_HIGH:   equ     07fh            ; Mask to set SDA high (output bit is LOW)
SDA_LOW:    equ     080h            ; Mask to set SDA low (output bit is HIGH)
SCL_HIGH:   equ     0bfh            ; Mask to set SCL high (output bit is LOW)
SCL_LOW:    equ     040h            ; Mask to set SCL low (output bit is HIGH)
