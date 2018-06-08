--[[
	Provide overhead and mouse
]]
local s = GM.cl_state
local fun = include("fun.lua")

gui.EnableScreenClicker(true)

local function weapon_hook(down, mousecode, aimvector)
	if s.inmenu then return end
	print("Weapon hook called, down:", down, "mousecode:", mousecode, "should be", MOUSE_LEFT)
	if mousecode == MOUSE_LEFT then
		local wep = LocalPlayer():GetActiveWeapon()
		print("canattack", wep:CanPrimaryAttack())
		if wep:IsScripted() then
			net.Start("ma_use_weapon")
			net.WriteBool(down and wep:CanPrimaryAttack())
			net.SendToServer()
			if wep:CanPrimaryAttack() and down then
					wep:PrimaryAttack()
			end
		end
		--print("mouse left")
	end
end
local weapon_down = fun.bindleft(weapon_hook,true)
local weapon_up = fun.bindleft(weapon_hook,false)

hook.Add( "GUIMousePressed", "keypress_gui", weapon_down)
hook.Add("GUIMouseReleased", "keypress_gui_up", weapon_up)

local scrh = ScrH()
local scrw = ScrW()
--Assume screen width/height don't change

net.Receive("set_weapon_dist",function()
	mouse_view_mult = net.ReadFloat()
end)

hook.Add( "CalcView", "overhead_view", function(ply,pos,angles,fov)
	local view = {}
	local oadd = Vector(0,0,0)
	if not s.inmenu then
		local x,y = gui.MousePos()
		local xperc = ((scrw / 2) - x) * 2
		local yperc = ((scrh / 2) - y) * 2
		local xoff = xperc * s.weaponrange
		local yoff = yperc * s.weaponrange
		local vec = gui.ScreenToVector(x,y)
		--print("screentovec:", vec)
		LocalPlayer():SetEyeAngles(vec:Angle() + Angle(-45,0,0))
		oadd = Vector(yoff,xoff,0)
	end
	view.origin = pos + Vector(0,0,200) + oadd
	view.angles = Angle(90,0,0)
	view.fov = fov
	view.drawviewer = true

	local ortho_scale = 300
		--[[
	view.ortho = {
		ortho_scale,
		ortho_scale,
		ortho_scale,
		ortho_scale
	}
	]]
	view.ortho = {
		left = -ortho_scale,
		right = ortho_scale,
		top = -ortho_scale,
		bottom = ortho_scale
	}


	return view
end)
