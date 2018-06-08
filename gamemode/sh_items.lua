
local r = include("sh_registry.lua")

local required_fields = {
	name = "string",
	serialize = "function",
	deserialize = "function"
}

local ireg = r.create_registry(required_fields,"item","name")
