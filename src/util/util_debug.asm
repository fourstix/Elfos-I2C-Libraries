;-------------------------------------------------------------------------------
; util_dbug - a routine to print the values in the registers r7-rd, rf, D and DF
;
; Copyright 2023 by Gaston Williams
;-------------------------------------------------------------------------------
#include    ../include/bios.inc
#include    ../include/kernel.inc
#include    ../include/ops.inc
  
;-------------------------------------------------------
; Name: util_debug
;
; Show the values in the registers r7-rd, rf, D and DF
;-------------------------------------------------------
            proc    util_debug
            plo     re
            pushd               ; save D and DF for return
            push    rf          ; save buffer pointer
            push    rd          ; save value register            
            
            push    rd          ; save rd to print
            push    rf          ; save rf to print
            
            ldi     $80         ; set msb = 1 in case DF = 1
            lsdf                ; check DF flag, skip clear if DF = 1
            ldi     $00         ; clear msb if DF = 0
            shlc                ; shift left, preserving DF, lsb = DF
            stxd                ; save DF byte on stack
            
            glo     re          ; get D to print
            plo     rd         
            load    rf, d_hex 
            call    f_hexout2   ; print D byte into string
            
            irx                 ; restore DF byte from stack
            ldx
            plo     rd          
            load   rf, df_hex   
            call   f_hexout2    ; print DF byte into string
            
            pop     rf          ; restore rf to print
            
            copy    rf, rd      ; print rf
            load    rf, rf_h
            call    f_hexout4   ; into debug string
            
            pop     rd          ; restore rd value
            load    rf, rd_h    ; to print
            call    f_hexout4   ; into debug string
            
            load    rf, r7_h    ; print value of R7
            copy    r7, rd    
            call    f_hexout4   ; into debug string
            
            load    rf, r8_h    ; print value of R8
            copy    r8, rd    
            call    f_hexout4   ; into debug string

            load    rf, r9_h    ; print value of R9
            copy    r9, rd    
            call    f_hexout4   ; into debug string
            
            load    rf, ra_h    ; print value of RA
            copy    ra, rd    
            call    f_hexout4   ; into debug string

            load    rf, rb_h    ; print value of RB
            copy    rb, rd    
            call    f_hexout4   ; into debug string
            
            load    rf, rc_h    ; print value of RC
            copy    rc, rd    
            call    f_hexout4   ; into debug string
            
            ;------ print out the debug string
            load    rf, debug_str     
            call    o_msg         
            
clip_exit:  pop     rd          ; restore value register
            pop     rf          ; restore buffer register
            popd                ; restore D and DF
            return
            
debug_str:  db 'R7: '
r7_h:       db  0,0,0,0
            db ' R8: '
r8_h:       db  0,0,0,0
            db ' R9: '     
r9_h:       db  0,0,0,0
            db ' RA: '     
ra_h:       db  0,0,0,0,10,13
            db 'RB: '     
rb_h:       db  0,0,0,0
            db ' RC: '     
rc_h:       db  0,0,0,0
            db ' RD: '     
rd_h:       db  0,0,0,0
            db ' RF: '     
rf_h:       db  0,0,0,0,10,13
            db 'D: '
d_hex:      db  0,0
            db ' DF: '
df_hex:     db 0,0,10,13,0            
            endp
