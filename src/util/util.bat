[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS util_full_mult16.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS util_write_10x.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS util_c_to_f.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS util_delay.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS util_wait.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS util_debug.asm



type util_full_mult16.prg util_write_10x.prg util_c_to_f.prg > util.lib
type util_delay.prg util_wait.prg util_debug.prg >> util.lib

copy util.lib ..\lib\util.lib
