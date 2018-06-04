local d = include("cl_ui_distances.lua")
local s = include("cl_state.lua")

print("Hello from ui health display")
hook.Add("HUDShouldDraw","hide_health",function(name)
	if name == "CHudHealth" then
		return false
	end
end)

local srcw = ScrW()
local scrh = ScrH()
--Assume screen width/height does not change

--Profile chunk
local profile_startx = 0 + d.ui_padding
local profile_starty = scrh - d.ui_padding - d.profile_chunk_height

--Hp start location
local hpbarstartx = 0 + d.ui_padding + d.profile_chunk_width
local hpbarstarty = scrh - d.ui_padding - d.profile_chunk_height + d.profile_hpbar_yoff


local hpbarbacktex = 0
local profile = Material("ui/profile_chunk.png")
local emptymat = Material( "ui/profile_bar_chunk_mid_empty.png" )
local emptystart = Material( "ui/profile_bar_chunk_start_empty.png" )
local redstart = Material( "ui/profile_bar_chunk_start_red.png" )
local redmat = Material( "ui/profile_bar_chunk_mid_red.png" )
local hpend = Material("ui/profile_bar_end_red.png")
hook.Add("HUDPaint","draw_health",function(name)
	if s.iscommander then return end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.SetMaterial(profile)
	surface.DrawTexturedRect(
		profile_startx, profile_starty,
		d.profile_chunk_abswidth, d.profile_chunk_absheight
	)
	
	surface.SetMaterial(emptystart)
	surface.DrawTexturedRect(
		hpbarstartx,hpbarstarty,
		d.profile_bar_empty_width, d.profile_bar_empty_height
	)
	
	surface.SetMaterial( emptymat	) -- If you use Material, cache it!
	for i = 1, s.maxhealth - 1 do
		surface.DrawTexturedRect(
			hpbarstartx + (d.profile_bar_empty_width * i), hpbarstarty,
			d.profile_bar_empty_width, d.profile_bar_empty_height
		)
	end
	
	surface.SetMaterial(hpend)
	surface.DrawTexturedRect(
		hpbarstartx + (d.profile_bar_empty_width * s.maxhealth), profile_starty + d.profile_bar_end_red_offy,
		d.profile_bar_end_red_width, d.profile_bar_end_red_height
	)
	
	if s.health >= 1 then
		surface.SetMaterial(redstart)
		surface.DrawTexturedRect(
			hpbarstartx, hpbarstarty + d.profile_bar_filled_yoff,
			d.profile_bar_filled_width,d.profile_bar_filled_height
		)
	end
	for i = 1, s.health - 1 do
		surface.DrawTexturedRect(
			hpbarstartx + (d.profile_bar_empty_width * i), hpbarstarty + d.profile_bar_filled_yoff,
			d.profile_bar_filled_width,d.profile_bar_filled_height
		)
	end

end)
