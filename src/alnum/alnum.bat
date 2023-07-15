[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_write_disp.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_clear.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_init.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_set_brightness.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_set_blink_rate.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_set_blink_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_write_char.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_write_segment.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_blank_disp.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_chars.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_buffers.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_write_colon.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_write_decimal.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alnum_avail.asm


type alnum_write_disp.prg alnum_init.prg alnum_clear.prg alnum_set_brightness.prg alnum_set_blink_rate.prg > alnum.lib
type alnum_set_blink_off.prg alnum_write_char.prg alnum_write_segment.prg alnum_blank_disp.prg >> alnum.lib
type alnum_chars.prg alnum_buffers.prg alnum_write_colon.prg  alnum_write_decimal.prg alnum_avail.prg >> alnum.lib
