
local ret = {}

local sf = string.format
function ret.create_registry(required_fields,name,index)
	
	--Make sure index is in required_fields
	local findex = false
	for k,v in pairs(required_fields) do
		if k == index then
			finxed = true
			break
		end
	end
	assert(findex,sf("Tried to create a %s registry with a %q field as index, but %q was not in the required_fields",name,index,index))
	
	local reg = {} --What we will eventually return
	local prototypes = {} --The prototypes for this registry
	function reg.register(tbl)
		for k,v in pairs(required_fields) do
			assert(tbl[k] ~= nil,sf("Tried to register a %s without a %q field",name,k))
			assert(type(tbl[k]) == v, sf("Tried to reigster a %s with a %q field that was a %q, should have been a %q",name,k,type(tbl[k]),v))
			assert(prototypes[tbl[index]] == nil, sf("Tried to register 2 %s of the same type: %s",name,tbl[index]))
		end
	end
	
	function reg.create(iname)
		assert(prototypes[iname],sf("Could not find a %s by %s",name,iname))
		local r = {}
		setmetatable(r,{__index = prototypes[iname]})
		return r
	end
end
