[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS memtest.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS memdump.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS memset.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS twist.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS keypad.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcdchar.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcdscroll.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcdtext.asm

[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS bicolor.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS bichar.asm


[Your_Path]\Link02\link02 -e -s memtest.prg -l ..\lib\i2c.lib -l ..\lib\mem.lib
[Your_Path]\Link02\link02 -e -s memdump.prg -l ..\lib\i2c.lib -l ..\lib\mem.lib
[Your_Path]\Link02\link02 -e -s memset.prg -l ..\lib\i2c.lib -l ..\lib\mem.lib

[Your_Path]\Link02\link02 -e -s twist.prg -l ..\lib\i2c.lib -l  ..\lib\util.lib -l ..\lib\twist.lib

[Your_Path]\Link02\link02 -e -s keypad.prg -l ..\lib\i2c.lib -l ..\lib\util.lib -l ..\lib\keypad.lib

[Your_Path]\Link02\link02 -e -s lcdchar.prg -l ..\lib\i2c.lib -l ..\lib\util.lib -l ..\lib\lcd.lib
[Your_Path]\Link02\link02 -e -s lcdscroll.prg -l ..\lib\i2c.lib -l ..\lib\util.lib -l ..\lib\lcd.lib
[Your_Path]\Link02\link02 -e -s lcdtext.prg -l ..\lib\i2c.lib -l ..\lib\util.lib -l ..\lib\lcd.lib

[Your_Path]\Link02\link02 -e -s bicolor.prg -l ..\lib\i2c.lib -l ..\lib\util.lib -l ..\lib\mtrx.lib
[Your_Path]\Link02\link02 -e -s bichar.prg -l ..\lib\i2c.lib -l ..\lib\util.lib -l ..\lib\mtrx.lib
