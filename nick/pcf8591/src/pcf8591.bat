../../asm02 -L -D1802MINIPLUS pcf8591_avail.asm
../../asm02 -L -D1802MINIPLUS pcf8591_read.asm
../../asm02 -L -D1802MINIPLUS pcf8591_off.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_s0.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_s1.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_s2.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_s3.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_d30.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_d31.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_d32.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_md0.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_md1.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_md2.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_d0.asm
../../asm02 -L -D1802MINIPLUS pcf8591_init_d1.asm



cat pcf8591_avail.prg pcf8591_read.prg pcf8591_off.prg pcf8591_init_s0.prg pcf8591_init_s1.prg > pcf8591.lib
cat pcf8591_init_s2.prg pcf8591_init_s3.prg pcf8591_init_d30.prg pcf8591_init_d31.prg pcf8591_init_d32.prg >> pcf8591.lib
cat pcf8591_init_md0.prg pcf8591_init_md1.prg pcf8591_init_md2.prg pcf8591_init_d0.prg pcf8591_init_d1.prg >> pcf8591.lib

cp pcf8591.lib ../pcf8591.lib

