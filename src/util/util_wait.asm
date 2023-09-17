;-------------------------------------------------------------------------------
; This routine waits up to a period of time for input (port 4) to be pressed. 
; Use the pre-defined constants to set the delay counter before calling. This
; function returns immediately when input is pressed. Check DF after the function
; returns to determine if input (port 4) was pressed.
;
; Parameters:
;   RC - delay counter
; Returns: 
;   DF = 1 if input was pressed (break)
;   DF = 0 if input was not pressed (timeout)
;   (RC is consumed)
;-------------------------------------------------------------------------------

#include ../include/ops.inc
#include ../include/bios.inc

; guarantee short branches stay within the same page
.link       .align  para

            proc    util_wait
            
wait:       bn4     w_cont      ; continue only if input not pressed
            b4      $           ; wait for input to be released
            stc                 ; Set DF if break
            lbr     w_exit
w_cont:     dec     rc          ; count down
            lbrnz   rc, wait    ; spin until count is exhausted 
            clc                 ; clear DF if timeout
w_exit:     return
            endp
