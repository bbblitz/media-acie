--[[
	Movement code
]]

local iscommander
if CLIENT then
	local s = include("cl_state.lua")
	iscommander = s.iscommander
else
	iscommander = false
end

hook.Add("Move","overhead_move",function(ply,mv)
	if iscommander then
		-- TODO: RTS code
	else
		mv:SetMoveAngles(Angle(0,0,0))
	end
end)
