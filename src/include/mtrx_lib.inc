;-------------------------------------------------------------------------------
; Public Matrix Library Routines
;-------------------------------------------------------------------------------

            extrn   mtrx_init
            extrn   mtrx_avail
            extrn   mtrx_clear
            extrn   mtrx_update
            extrn   mtrx_blink_rate
            extrn   mtrx_blink_off
            extrn   mtrx_brightness
            extrn   mtrx_print_vstr
            extrn   mtrx_print_hstr
            
;-------------------------------------------------------------------------------
; LED matrix display size
;-------------------------------------------------------------------------------

#define MTRX_HEIGHT     8
#define MTRX_WIDTH      8

;-------------------------------------------------------------------------------
; LED matrix display colors
;-------------------------------------------------------------------------------

#define LED_ON     1
#define LED_OFF    0
#define LED_RED    1
#define LED_YELLOW 2
#define LED_GREEN  3
            
