[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS keypad_avail.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS keypad_get_version.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS keypad_update.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS keypad_get_key.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS keypad_get_time.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS keypad_read_key.asm

type keypad_avail.prg keypad_get_version.prg keypad_update.prg > keypad.lib
type keypad_get_key.prg keypad_get_time.prg keypad_read_key.prg>> keypad.lib

copy keypad.lib ..\lib\keypad.lib
