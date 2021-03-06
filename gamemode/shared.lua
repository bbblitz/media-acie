DeriveGamemode( "sandbox" )
if not redefined_print then 
	redefined_print = true
	local oldprint = print
	function print(...)
		local args = {...}
		local newargs = {}
		if SERVER then
			newargs[1] = "[SERVER]"
		else
			newargs[1] = "[CLIENT]"
		end
		for k,v in pairs(args) do
			newargs[k+1] = tostring(v)
		end
		oldprint(unpack(newargs))
	end
end

include("sh_movement.lua")
print("Shared loaded")
