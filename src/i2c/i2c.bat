[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_write_byte.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_read_byte.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_wrbuf.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_rdbuf.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_rdreg.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_clear.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_avail.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_scan.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_init.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_wraddr.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS i2c_rdaddr.asm


type i2c_write_byte.prg i2c_read_byte.prg i2c_wrbuf.prg i2c_rdbuf.prg > i2c.lib
type i2c_rdreg.prg i2c_clear.prg i2c_avail.prg i2c_scan.prg i2c_init.prg >> i2c.lib
type i2c_wraddr.prg i2c_rdaddr.prg >> i2c.lib

copy i2c.lib ..\lib\i2c.lib
