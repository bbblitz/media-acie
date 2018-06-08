--[[
	Utilities
]]
local ret = {}

function ret.bindleft(func,...)
	local iargs = {...}
	return function(...)
		local xargs = {...}
		local args = {}
		for k,v in ipairs(iargs) do
			args[#args + 1] = v
		end
		for k,v in ipairs(xargs) do
			args[#args + 1] = v
		end
		return func(unpack(args))
	end
end

return ret
