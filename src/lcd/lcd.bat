[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_avail.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_reset.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_send_byte.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_send_cmd.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_send_data.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_init.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_clear.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_home.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_create_char.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_print_char.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_print_str.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_print_nstr.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_position.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_blink_on.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_blink_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_cursor_on.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_cursor_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_update.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_display_on.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_display_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_default.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_backlight_on.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_backlight_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_entry_mode.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_auto_on.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_auto_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_left_to_right.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_right_to_left.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_scroll_left.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS lcd_scroll_right.asm


type lcd_avail.prg lcd_reset.prg lcd_send_byte.prg > lcd.lib
type lcd_send_cmd.prg lcd_send_data.prg lcd_init.prg >> lcd.lib
type lcd_clear.prg lcd_home.prg lcd_create_char.prg >> lcd.lib
type lcd_print_char.prg lcd_print_str.prg lcd_print_nstr.prg >> lcd.lib
type lcd_position.prg lcd_blink_on.prg lcd_blink_off.prg >> lcd.lib
type lcd_cursor_on.prg lcd_cursor_off.prg lcd_update.prg >> lcd.lib
type lcd_display_on.prg lcd_display_off.prg lcd_default.prg >> lcd.lib
type lcd_backlight_on.prg lcd_backlight_off.prg lcd_entry_mode.prg >> lcd.lib
type lcd_auto_on.prg lcd_auto_off.prg lcd_left_to_right.prg >> lcd.lib
type lcd_right_to_left.prg lcd_scroll_left.prg lcd_scroll_right.prg >> lcd.lib


copy lcd.lib ..\lib\lcd.lib
