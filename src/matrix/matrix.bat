[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_write_disp.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_clear.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_init.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_brightness.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_blink_rate.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_blink_off.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_display_buf.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_avail.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_pixel.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_check_bounds.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_draw_pixel.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_adj_bounds.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_bitmap.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_draw_bitmap.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_check_overlap.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_ascii_font.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_char.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_draw_char.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_print_char.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_scroll_left.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_print_hstr.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_scroll_up.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_print_vstr.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_h_line.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_v_line.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_rect.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_block.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_draw_rect.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_fill_rect.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_s_line.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_steep_flag.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS gfx_write_line.asm
[Your_Path]\Asm02\asm02 -L -D1802MINIPLUS mtrx_draw_line.asm


type mtrx_write_disp.prg mtrx_init.prg mtrx_clear.prg > mtrx.lib
type mtrx_brightness.prg mtrx_blink_rate.prg mtrx_blink_off.prg >> mtrx.lib
type mtrx_display_buf.prg mtrx_avail.prg gfx_check_bounds.prg >> mtrx.lib
type gfx_write_pixel.prg mtrx_draw_pixel.prg gfx_adj_bounds.prg >> mtrx.lib
type gfx_write_bitmap.prg mtrx_draw_bitmap.prg gfx_check_overlap.prg >> mtrx.lib
type gfx_ascii_font.prg gfx_write_char.prg mtrx_draw_char.prg >> mtrx.lib
type mtrx_print_char.prg gfx_scroll_left.prg mtrx_print_hstr.prg >> mtrx.lib
type gfx_scroll_up.prg mtrx_print_vstr.prg gfx_write_h_line.prg >> mtrx.lib
type gfx_write_v_line.prg gfx_write_rect.prg gfx_write_block.prg >> mtrx.lib
type mtrx_draw_rect.prg mtrx_fill_rect.prg gfx_write_s_line.prg >> mtrx.lib
type gfx_write_line.prg gfx_steep_flag.prg mtrx_draw_line.prg >> mtrx.lib

copy mtrx.lib ..\lib\mtrx.lib
