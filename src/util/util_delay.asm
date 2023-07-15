;-------------------------------------------------------------------------------
; This routine waits for a period of time before returning.  Use the pre-defined
; constants to set the delay counter before calling.
; Parameters:
;   RC - delay counter
; Returns: 
;   (RC is consumed)
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc

            proc    util_delay
            
delay:      dec     rc            ; count down
            lbrnz   rc, delay     ; spin until count is exhausted 

            return
              
            endp
