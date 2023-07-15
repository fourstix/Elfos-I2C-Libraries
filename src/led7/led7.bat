[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_write_disp.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_clear.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_init.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_set_brightness.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_set_blink_rate.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_set_blink_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_write_digit.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_write_blank.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_write_colon.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_blank_disp.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_digits.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_buffers.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_tobcd.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_write_dp.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7_avail.asm


type led7_write_disp.prg led7_init.prg led7_clear.prg led7_set_brightness.prg led7_set_blink_rate.prg > led7.lib
type led7_set_blink_off.prg led7_write_digit.prg led7_write_blank.prg led7_write_colon.prg >> led7.lib
type led7_blank_disp.prg led7_digits.prg led7_buffers.prg led7_tobcd.prg led7_write_dp.prg led7_avail.prg >> led7.lib
