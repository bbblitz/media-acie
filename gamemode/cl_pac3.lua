--[[
	A lazy loader for PAC's
]]
local log = srequire("sh_log")

timer.Simple(1,function()
	net.Start("ss_requestall")
	net.SendToServer()
end)

net.Receive("ss_animplay",function()
	local who = net.ReadEntity()
	local seq = net.ReadString()
	who:SetLuaAnimation(seq)
end)

net.Receive("ss_animhalt",function()
	local who = net.ReadEntity()
	local seq = net.ReadString()
	who:StopLuaAnimation(seq)
end)

net.Receive("ss_animsequ",function()
	local who = net.ReadEntity()
	local seq = net.ReadString()
	local len = net.ReadUInt(32)
	who:SetLuaAnimation(seq)
	timer.Simple(len,function()
		who:StopLuaAnimation(seq)
	end)
end)

net.Receive("ss_givepac",function()
	local pac_name = net.ReadString()
	local pac_data = util.Decompress(net.ReadData(net.ReadUInt(32)))
	file.Write(string.format("sanityfalling_client/pacs/%s.txt",pac_name),pac_data)
end)

local function applypac(item,pac_name)
	local pac_filename = string.format("sanityfalling_client/pacs/%s.txt",pac_name)
	local pac_file = file.Read(pac_filename,"DATA")
	assert(pac_file,"Failed to open file " .. pac_filename)
	local pac_tbl = CompileString("return {" .. pac_file .. "}",pac_filename)()
	assert(pac_tbl,"Failed to compile " .. pac_name)
	if item.AttachPACPart == nil then
		pac.SetupENT(item)
	end
	if item.AttachPACPart then
		item:AttachPACPart(pac_tbl)
	end
end

local function removepac(ent,pac_name)
	assert(ent.RemovePACPart,"This entity is not set up to have pacs!")
	local pac_filename = string.format("sanityfalling_client/pacs/%s.txt",pac_name)
	local pac_tbl = CompileString("{" .. file.Read(pac_filename,"DATA") .. "}",pac_filename)()
	ent:RemovePACPart(pac_tbl)
end

net.Receive("ss_applypac",function()
	local pac_name = net.ReadString()
	local ent_to_apply = net.ReadEntity()
	local pac_hash = net.ReadUInt(32)
	if not file.Exists(string.format("sanityfalling_client/pacs/%s.txt",pac_name),"DATA") then
		--We don't have this pac, request it from the server
		log.print("debug","Tryied to apply " .. pac_name .. ": miss")
		net.Start("ss_requestpac")
		net.WriteString(pac_name)
		net.SendToServer()
		print("Requestig pac")
		timer.Simple(3,function()
			applypac(ent_to_apply,pac_name)
		end)
		return
	end
	local local_pac = file.Read(string.format("sanityfalling_client/pacs/%s.txt",pac_name),"DATA")
	local local_pac_hash = util.CRC(local_pac)
	if tonumber(local_pac_hash) ~= pac_hash then
		--Our version of this pac is old, and needs to be updated!
		net.Start("ss_requestpac")
		net.WriteString(pac_name)
		net.SendToServer()
		log.print("debug","Tryied to apply " .. pac_name .. ": old")
		timer.Simple(3,function()
			applypac(ent_to_apply,pac_name)
		end)
		return
	end
	log.print("debug","Tryied to apply " .. pac_name .. ": hit")
	applypac(ent_to_apply,pac_name)
end)

net.Receive("removepac",function()
	local pac_name = net.ReadString()
	local ent = net.ReadEntity()
	removepac(pac_name,ent)
end)
