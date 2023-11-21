../../asm02 -L -D1802MINIPLUS mcp23017_avail.asm
../../asm02 -L -D1802MINIPLUS mcp23017_init.asm
../../asm02 -L -D1802MINIPLUS mcp23017_in.asm
../../asm02 -L -D1802MINIPLUS mcp23017_out.asm
../../asm02 -L -D1802MINIPLUS mcp23017_read.asm
../../asm02 -L -D1802MINIPLUS mcp23017_get_pin.asm
../../asm02 -L -D1802MINIPLUS mcp23017_set_pin.asm


cat mcp23017_avail.prg mcp23017_init.prg mcp23017_in.prg > mcp23017.lib
cat mcp23017_out.prg mcp23017_read.prg mcp23017_get_pin.prg mcp23017_set_pin.prg >> mcp23017.lib


cp mcp23017.lib ../mcp23017.lib
