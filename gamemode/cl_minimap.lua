--[[
	Minimaps should display:
	Overhead view
	Friendlies
	Markers
	Known enemies
]]

local d = include("cl_ui_distances.lua")
local c = include("cl_ui_colors.lua")
local s = include("cl_state.lua")

local minimap = Material("ui/minimap.png")

local scrw = ScrW()
local scrh = ScrH()

local display = {
	npc_zombie = {
		Material("ui/minimap_zombie.png"),
		d.minimap_zombie_width,
		d.minimap_zombie_height,
		d.minimap_zombie_abswidth,
		d.minimap_zombie_absheight,
	}
}

local minimap_range = 1000
local minimap_radius = (d.minimap_radius) / 2
hook.Add("HUDPaint","draw_minimap",function(name)
	if s.iscommander then return end
	local mmx = scrw - d.ui_padding - d.minimap_width
	surface.SetMaterial(minimap)
	surface.DrawTexturedRect(
		mmx,d.ui_padding,
		d.minimap_width, d.minimap_height
	)
	
	local minimap_center_x = mmx + (d.minimap_width / 2)
	local minimap_center_y = d.ui_padding + (d.minimap_height / 2)
	
	local lp = LocalPlayer()
	local lpp = lp:GetPos()
	for entname,enticon in pairs(display) do
		local found = ents.FindByClass(entname)
		for _,e in pairs(found) do
			local ep = e:GetPos()
			if ep:Distance(lpp) < minimap_range then
				local dir = lpp - ep
				local dotx = (dir.y / minimap_range) * minimap_radius
				local doty = (dir.x / minimap_range) * minimap_radius
				local icon_center_x = enticon[2] / 2
				local icon_center_y = enticon[3] / 2
				surface.SetMaterial(enticon[1])
				surface.DrawTexturedRect(
					minimap_center_x + dotx - icon_center_x, minimap_center_y + doty - icon_center_y,
					enticon[4], enticon[5]
				)
			end
		end
	end
end)
