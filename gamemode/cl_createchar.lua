--[[
	Client display for creating character
]]

local d = include("cl_ui_distances.lua")
local s = GM.cl_state
local is_creating = false

net.Receive("ma_create",function()
	print("creating character")
	is_creating = true
	s.inmenu = true
	print("s.inmenu = ", s.inmenu)
end)

local selections = {
	{
		name = "Light",
		weapons = {
			"Shotgun",
			"Bolter",
			"Duel Glocks"
		},
		description = "The light class has plenty of room for external modules. They move quicker than other classes but are much weaker, and die easily without a medic nearby."
	},
	{
		name = "Medium",
		weapons = {
			"Tesla Cannon",
			"Sniper Rifle",
			"Assult Rifle",
		},
		description = "The medium class in an all-round solid fighter. With enough room for healing modules but also enough firepower to hold their own when teammates are not around. Reccomended for new players."
	},
	{
		name = "Heavy",
		weapons = {
			"Ion Cannon",
			"Minigun",
			"Grenade Launcher"
		},
		description = "The heavy class is what you're looking for when everything in view abosolutely MUST be obliterated. Their inability to equip healing modules and slow movement designate them to nuker roles."
	}
}

local scrw, scrh = ScrW(), ScrH()

local charpanel = Material("ui/charsel_icon.png")
local charbuttonup = Material("ui/charsel_button_up.png")
local charbuttondown = Material("ui/charsel_button_down.png")
local selected_class = false
local selected_weapon = false
local selected_modules = false
print("adding hook to render char panel")

local function display_characters()
	local full_width = (3 * d.charsel_icon_width) + (2 * d.common_padding)
	local sx = (scrw / 2) - (full_width / 2)
	surface.SetMaterial(charpanel)
	for k,v in pairs(selections) do
		local tsx = sx + ((k - 1) * d.charsel_icon_width) + ((k-1) * d.common_padding)
		local sy = d.ui_padding
		surface.DrawTexturedRect(
			tsx,sy,
			d.charsel_icon_width, d.charsel_icon_height
		)
	end

	for k,v in pairs(selections) do
		surface.SetMaterial(charbuttonup)
		local tsx = sx + ((k - 1) * d.charsel_icon_width) + ((k-1) * d.common_padding)
		local sy = d.ui_padding + d.charsel_icon_g_height
		surface.DrawTexturedRect(
			tsx,sy,
			d.charsel_button_width, d.charsel_button_height
		)
	end

end

hook.Add("HUDPaint","render_char_creation",function()
	if not is_creating then return end
	surface.SetDrawColor( 255, 255, 255, 255 )
	if not selected_class then
		display_characters()
	elseif not selected_weapon then
		
	elseif not selected_modules then
		
	end

end)
