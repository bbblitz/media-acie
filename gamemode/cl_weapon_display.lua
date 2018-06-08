--[[
	Display weapon bar
]]

local s = GM.cl_state
local d = include("cl_ui_distances.lua")

local mstart = Material("ui/magazine_start.png")
local mmid = Material("ui/magazine_mid.png")
local mend = Material("ui/magazine_end.png")

local scrw = ScrW() 
local scrh = ScrH()

hook.Add("HUDPaint","draw_ammo",function(name)
	surface.SetDrawColor( 255, 255, 255, 255 )
	local ma = s.magsize
	
	local end_x = scrw - d.ui_padding - d.weapon_end_width
	local end_y = scrh - d.ui_padding - d.weapon_height
	local start_x = scrw - d.ui_padding - (math.ceil((ma / 5) - 2) * d.weapon_mid_width) - d.weapon_start_width - d.weapon_end_width
	local start_y = scrh - d.ui_padding - d.weapon_height
	surface.SetMaterial(mstart)
	surface.DrawTexturedRect(
		start_x, start_y,
		d.weapon_start_width, d.weapon_height
	)
	surface.SetMaterial(mend)
	surface.DrawTexturedRect(
		end_x, end_y,
		d.weapon_end_width, d.weapon_height
	)
	surface.SetMaterial(mmid)
	for i = start_x + d.weapon_start_width, end_x - 1, d.weapon_mid_width do
		surface.DrawTexturedRect(
			i, end_y,
			d.weapon_mid_width, d.weapon_height
		)
	end
end)

print("Hello from weapon display.lua")
