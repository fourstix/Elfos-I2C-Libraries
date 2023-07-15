[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_get_horizontal.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_get_vertical.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_get_version.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_get_x_byte.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_get_y_byte.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_get_xy_position.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_avail.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_button_state.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS joystick_button_pressed.asm


type joystick_get_horizontal.prg joystick_get_vertical.prg joystick_get_version.prg > joystick.lib
type joystick_get_x_byte.prg joystick_get_y_byte.prg joystick_get_xy_position.prg >> joystick.lib
type joystick_avail.prg joystick_button_state.prg joystick_button_pressed.prg >> joystick.lib
