[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS relay_set_on.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS relay_set_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS relay_get_state.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS relay_get_version.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS relay_avail.asm

type relay_set_on.prg relay_set_off.prg relay_get_state.prg > relay.lib
type relay_get_version.prg relay_avail.prg >> relay.lib
