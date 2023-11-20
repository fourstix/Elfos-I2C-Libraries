[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_init.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_avail.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_buffer.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_update.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_clear.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_brightness.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_blink_rate.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_blink_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_write_pixel.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_scroll_left.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_print_hstr.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_scroll_up.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_print_vstr.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_display.asm

type mtrx_init.prg mtrx_avail.prg mtrx_buffer.prg mtrx_update.prg > mtrx.lib
type mtrx_clear.prg mtrx_brightness.prg mtrx_blink_rate.prg >> mtrx.lib
type mtrx_blink_off.prg mtrx_write_pixel.prg mtrx_scroll_left.prg >> mtrx.lib
type mtrx_print_hstr.prg mtrx_scroll_up.prg mtrx_print_vstr.prg >> mtrx.lib 
type gfx_display.prg >> mtrx.lib


copy mtrx.lib ..\lib\mtrx.lib
