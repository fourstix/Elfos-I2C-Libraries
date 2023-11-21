../../asm02 -L -D1802MINIPLUS blinkm_avail.asm
../../asm02 -L -D1802MINIPLUS blinkm_goto_c.asm
../../asm02 -L -D1802MINIPLUS blinkm_fade_c.asm
../../asm02 -L -D1802MINIPLUS blinkm_fade_h.asm
../../asm02 -L -D1802MINIPLUS blinkm_get_adr.asm
../../asm02 -L -D1802MINIPLUS blinkm_set_adr.asm
../../asm02 -L -D1802MINIPLUS blinkm_get_ver.asm
../../asm02 -L -D1802MINIPLUS blinkm_get_rgb.asm
../../asm02 -L -D1802MINIPLUS blinkm_play_s.asm
../../asm02 -L -D1802MINIPLUS blinkm_stop_s.asm
../../asm02 -L -D1802MINIPLUS blinkm_set_fs.asm
../../asm02 -L -D1802MINIPLUS blinkm_set_ta.asm



cat blinkm_avail.prg blinkm_goto_c.prg blinkm_fade_c.prg blinkm_fade_h.prg blinkm_play_s.prg > blinkm.lib
cat blinkm_stop_s.prg blinkm_set_fs.prg blinkm_set_ta.prg blinkm_set_adr.prg blinkm_get_adr.prg >> blinkm.lib
cat blinkm_get_ver.prg blinkm_get_rgb.prg >> blinkm.lib

cp blinkm.lib ../blinkm.lib
