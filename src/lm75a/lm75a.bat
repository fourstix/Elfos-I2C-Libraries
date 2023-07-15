[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lm75a_temperature_c.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lm75a_temperature_f.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lm75a_temperature_raw.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lm75a_avail.asm

type lm75a_temperature_c.prg lm75a_temperature_f.prg lm75a_temperature_raw.prg lm75a_avail.prg > lm75a.lib
