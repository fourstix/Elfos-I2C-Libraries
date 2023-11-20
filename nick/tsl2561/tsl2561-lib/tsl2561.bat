../../asm02 -L -D1802MINIPLUS tsl2561_avail.asm
../../asm02 -L -D1802MINIPLUS tsl2561_power_off.asm
../../asm02 -L -D1802MINIPLUS tsl2561_power_on.asm
../../asm02 -L -D1802MINIPLUS tsl2561_read_c0.asm
../../asm02 -L -D1802MINIPLUS tsl2561_read_c1.asm
../../asm02 -L -D1802MINIPLUS tsl2561_set_tng.asm

cat tsl2561_avail.prg tsl2561_power_off.prg tsl2561_power_on.prg > tsl2561.lib
cat tsl2561_read_c0.prg tsl2561_read_c1.prg tsl2561_set_tng.prg >> tsl2561.lib

cp tsl2561.lib ../tsl2561.lib
