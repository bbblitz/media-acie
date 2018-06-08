--[[
	Holds all the weapons
]]

local r = include("sh_registry.lua")

local req_fields = {
	name = "string",
	serialize = "function",
	deserialize = "function",
	fire = "function",
}

local wreg = create_registry(req_fields,"weapon","name")

wreg.register(include("sh_weapon_ar.lua"))
