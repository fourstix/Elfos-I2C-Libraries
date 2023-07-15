[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_avail.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_clear_status.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_read_status.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_init.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_set_heater.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_get_heater.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_read_data.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_data_buf.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_temperature_c.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_temperature_f.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_humidity.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_dewpoint_c.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_dewpoint_f.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_ready.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31_reset.asm


type sht31_avail.prg sht31_clear_status.prg sht31_read_status.prg sht31_init.prg > sht31.lib
type sht31_set_heater.prg sht31_get_heater.prg sht31_read_data.prg >> sht31.lib
type sht31_data_buf.prg sht31_temperature_c.prg sht31_temperature_f.prg >> sht31.lib
type sht31_humidity.prg sht31_dewpoint_c.prg sht31_dewpoint_f.prg >> sht31.lib
type sht31_ready.prg sht31_reset.prg >> sht31.lib
