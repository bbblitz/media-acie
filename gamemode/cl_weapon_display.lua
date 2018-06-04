--[[
	Display weapon bar
]]

local s = include("cl_state.lua")
local d = include("cl_ui_distances.lua")

local mstart = Material("ui/magazine_start.png")
local mmid = Material("ui/magazine_mid.png")
local mend = Material("ui/magazine_end.png")
hook.Add("HUDPaint","draw_ammo",function(name)
	surface.SetMaterial(mstart)
	surface.DrawTexturedRect(
		profile_startx, profile_starty,
		d.profile_chunk_abswidth, d.profile_chunk_absheight
	)
end)
