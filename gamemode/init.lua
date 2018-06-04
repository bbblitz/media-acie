AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_health_display.lua")
AddCSLuaFile("cl_ui_distances.lua")
AddCSLuaFile("cl_camera.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_movement.lua")
AddCSLuaFile("cl_minimap.lua")
AddCSLuaFile("cl_ui_colors.lua")
AddCSLuaFile("cl_state.lua")
include("shared.lua")

--Profile bar things
for _,sides in pairs({"mid","start"}) do
	for _,colors in pairs({"blue","red","empty"}) do
		local path = string.format("materials/ui/profile_bar_chunk_%s_%s.png",sides,colors)
		resource.AddFile(path)
	end
end
for _,color in pairs({"red","blue"}) do
	resource.AddFile("materials/ui/profile_bar_end_" .. color .. ".png")
end
resource.AddFile("materials/ui/profile_chunk.png")

--Minimap
resource.AddFile("materials/ui/minimap.png")


print("init loaded")

include("server/disable_sandbox.lua")
