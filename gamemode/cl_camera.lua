--[[
	Provide overhead and mouse
]]
local s = include("cl_state.lua")

gui.EnableScreenClicker(true)

local scrh = ScrH()
local scrw = ScrW()
--Assume screen width/height don't change

net.Receive("set_weapon_dist",function()
	mouse_view_mult = net.ReadFloat()
end)

hook.Add( "CalcView", "overhead_view", function(ply,pos,angles,fov)
	local x,y = gui.MousePos()
	local xperc = ((scrw / 2) - x) * 2
	local yperc = ((scrh / 2) - y) * 2
	local xoff = xperc * s.weaponrange
	local yoff = yperc * s.weaponrange
	local vec = gui.ScreenToVector(x,y)
	LocalPlayer():SetEyeAngles(vec:Angle())
	
	local view = {}

	view.origin = pos + Vector(0,0,200) + Vector(yoff,xoff,0)
	view.angles = Angle(90,0,0)
	view.fov = fov
	view.drawviewer = true

	return view
end)
