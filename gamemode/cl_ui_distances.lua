local ret = {
	ui_padding = 32,
	
	profile_chunk_width = 84,
	profile_chunk_height = 64,
	profile_chunk_abswidth = 128,
	profile_chunk_absheight = 64,
	profile_hpbar_yoff = 4,
	
	profile_bar_empty_width = 8,
	profile_bar_empty_height = 16,
	profile_bar_filled_width=8,
	profile_bar_filled_height=12,
	profile_bar_filled_yoff = 2,
	profile_bar_end_red_width = 32,
	profile_bar_end_red_height = 32,
	profile_bar_end_red_offy = 2,
	
	weapon_mid_width=44,
	weapon_start_width=54,
	weapon_end_width=58,
	weapon_height=40,
	
	bar_fat_height=64,
	bar_fat_mid_width=32,
	
	minimap_width=128,
	minimap_height=128,
	minimap_radius = 98,
	
	minimap_zombie_width=33,
	minimap_zombie_height=34,
	minimap_zombie_abswidth=32,
	minimap_zombie_absheight=64,
	
	capture_vial_start_width = 24,
	capture_vial_hight=20,
	capture_vial_end_width = 25,
	capture_vial_mid_width=23,
	capture_vial_bar_width=8,
	capture_vial_bar_heigth=14,
	
	common_padding = 32,
	
	charsel_icon_width = 128,
	charsel_icon_g_width = 128,
	charsel_icon_height = 256,
	charsel_icon_g_height = 192,
	charsel_button_height = 64,
	charsel_button_width = 128,
	charsel_button_g_width = 128,
	charsel_button_g_height = 24,
}

for k,v in pairs(ret) do
	ret[k] = v * 1.5
end

return ret
