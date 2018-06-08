--[[
	A lazy loader for pacs
	functions:
		p3.ApplyPac(entity_what, string_name)						::		nil
		p3.RemovePac(entity_what, string_name)						::		nil
		p3.PlayAnimation(entity_what, string_name)					::		nil
		p3.HaltAnimation(entity_what, string_name)					::		nil
		p3.OnceAnimation(entity_what string_name, number_length)	::		nil

]]

print("Hello from sv_pac3.lua!")
local log = srequire("sh_log")
local p3 = {}

for _,v in pairs({
	"ss_requestpac", --Sent by client to server to ask for a pac
	"ss_givepac", --Sent by server to client in response to requestpac

	"ss_applypac", --Sent by server to tell clients to apply a pac to an ent
	"ss_removepac", --Sent by server to tell clients to remove a pac from an ent

	"ss_requestall", --Sent by client to server when a client joins, asking for all pacs

	"ss_animplay", --Sent by server to client to tell them to animate someone
	"ss_animhalt", --Sent by server to client to tell them to stop animateing
	"ss_animsequ" --Same as animplay, but contains the duration of the animation to play. (no animhalt needed)
}) do
	util.AddNetworkString(v)
end

local cache_max_size = 10
local pac_cache = {}
local pachashes = {}
local appliedpacs = {}
local path = GM.FolderName

net.Receive("ss_requestall",function(ln,ply)
	for some_ent,tbl_of_pacs in pairs(appliedpacs) do
		for pac_name,has in pairs(tbl_of_pacs) do
			net.Start("ss_applypac")
			net.WriteString(pac_name)
			net.WriteEntity(some_ent)
			net.WriteUInt(pachashes[pac_name],32)
			net.Send(ply)
		end
	end
end)

net.Receive("ss_requestpac",function(ln,ply)
	local pac_name = net.ReadString()
	if pac_cache[pac_name] == nil then
		if #pac_cache > cache_max_size then -- random replacement
			pac_cache[table.Random(pac_cache)] = nil
		end
		local filename = string.format("%s/data/pacs/%s.pac",path,pac_name)
		local tfile = file.Find(filename, "LUA")
		assert(tfile ~= nil,"Client " .. ply:Nick() .. " requested pac " .. pac_name .. " but it could not be found!")
		pac_cache[pac_name] = file.Read(filename,"LUA")
	end
	local pac_compressed = util.Compress(pac_cache[pac_name])
	net.Start("ss_givepac")
	net.WriteString(pac_name)
	net.WriteUInt(#pac_compressed,32)
	net.WriteData(pac_compressed,#pac_compressed)
	net.Send(ply)
end)

--If the server has pac installed, restrict player's from putting on their own pacs
hook.Add("PrePACConfigApply", "stoppacs", function(ply, outfit_data)
	if not ply:IsAdmin() then
		return false, "You don't have permission to do that!"
	end
end)


local function loadhashes()
	local files,_ = file.Find(string.format("%s/data/pacs/*",path),"LUA")
	for _,v in ipairs(files) do
		local filetext = file.Read(string.format("%s/data/pacs/%s",path,v),"LUA")
		local filehash = util.CRC(filetext)
		pachashes[string.StripExtension(v)] = tonumber(filehash)
	end
	log.print("info","Loaded hashes for " .. #files .. " PACs")
end
loadhashes()


function p3.ApplyPac(ent,pac_name)
	appliedpacs[ent] = appliedpacs[ent] or {}
	appliedpacs[ent][pac_name] = true
	net.Start("ss_applypac")
	net.WriteString(pac_name)
	net.WriteEntity(ent)
	net.WriteUInt(pachashes[pac_name],32)
	net.Broadcast()
end

concommand.Add("ss_dev_applypacto",function(ply,cmd,args)
	p3.ApplyPac(ply:GetEyeTrace().Entity,args[1])
end)

function p3.RemovePac(ent,pac_name)
	assert(appliedpacs[ent][pac_name],string.format("Entity %s does not have pac %q on right now!",tostring(ent),pac_name))
	appliedpacs[ent][pac_name] = nil
	net.Start("ss_removepac")
	net.WriteString(pac_name)
	net.Broadcast()
end

function p3.PlayAnimation(who,seqname)
	net.Start("ss_animplay")
	net.WriteEntity(who)
	net.WriteString(seqname)
	net.Broadcast()
end

function p3.HaltAnimation(who,seqname)
	net.Start("ss_animhalt")
	net.WriteEntity(who)
	net.WriteString(seqname)
	net.Broadcast()
end

function p3.OnceAnimation(who,seqname,length)
	net.Start("ss_animsequ")
	net.WriteEntity(who)
	net.WriteString(seqname)
	net.WriteUInt(length,32)
	net.Broadcast()
end

function p3.GetEntPacs(ent)
	return appliedpacs[ent]
end

return p3
