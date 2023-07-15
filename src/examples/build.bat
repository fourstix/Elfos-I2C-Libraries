[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS scanner.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7clock.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7print.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS led7clear.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alclear.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS altest.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS alprint.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS relayOn.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS relayOff.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS relay.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lm75a.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS sht31.asm

[Your_Path]\Link02\link02 -e -s scanner.prg -l ..\lib\i2c.lib

[Your_Path]\Link02\link02 -e -s led7clock.prg -l ..\lib\i2c.lib -l ..\lib\led7.lib
[Your_Path]\Link02\link02 -e -s led7print.prg -l ..\lib\i2c.lib -l ..\lib\led7.lib
[Your_Path]\Link02\link02 -e -s led7clear.prg -l ..\lib\i2c.lib -l ..\lib\led7.lib

[Your_Path]\Link02\link02 -e -s alclear.prg -l ..\lib\i2c.lib -l ..\lib\alnum.lib
[Your_Path]\Link02\link02 -e -s altest.prg -l ..\lib\i2c.lib -l ..\lib\alnum.lib
[Your_Path]\Link02\link02 -e -s alprint.prg -l ..\lib\i2c.lib -l ..\lib\alnum.lib

[Your_Path]\Link02\link02 -e -s relayOn.prg -l ..\lib\i2c.lib -l ..\lib\relay.lib
[Your_Path]\Link02\link02 -e -s relayOff.prg -l ..\lib\i2c.lib -l ..\lib\relay.lib
[Your_Path]\Link02\link02 -e -s relay.prg -l ..\lib\i2c.lib -l ..\lib\relay.lib

[Your_Path]\Link02\link02 -e -s lm75a.prg -l ..\lib\i2c.lib -l ..\lib\lm75a.lib -l ..\lib\util.lib

[Your_Path]\Link02\link02 -e -s joystick.prg -l ..\lib\i2c.lib -l ..\lib\joystick.lib

[Your_Path]\Link02\link02 -e -s sht31.prg -l ..\lib\i2c.lib -l ..\lib\sht31.lib -l ..\lib\util.lib
