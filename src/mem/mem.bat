[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mem_avail.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mem_read_data.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mem_write_data.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mem_set_data.asm


type mem_avail.prg mem_read_data.prg mem_write_data.prg mem_set_data.prg > mem.lib

copy mem.lib ..\lib\mem.lib
