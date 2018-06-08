
local function init_db()
	local dat = sql.Query("CREATE TABLE IF NOT EXISTS ma_players (steam_id TEXT, inventory TEXT);")
	print("data",dat)
end

hook.Add("Initalize","init_db",init_db)
util.AddNetworkString("ma_create")
local function create_player_character(ply)
	net.Start("ma_create")
	net.Send(ply)
end

local function load_player(ply)
	local id = ply:SteamID64()
	print(id,type(id))
	--string.format will not save you from sqli
	local data = sql.Query(string.format("SELECT * FROM ma_players WHERE steam_id = %q;",id))
	if data == nil then
		print("creating player record")
		ply.creating = true
		
	end
	print("data:",data)
end

local function save_player(ply)
	local id = ply:SteamID64()
	print(id,type(id))
	local data = sql.Query(string.format("UPDATE ma_players (inventory) WITH "))
end

local function delete_player(ply)
	local data = sql.Query(string.format("DELETE FROM ma_players WHERE steam_id = %q;",ply:SteamID64()))
end

hook.Add("PlayerInitialSpawn","spawn_in",load_player)

concommand.Add("ma_force_reload",function(ply,cmd,args)
	load_player(ply)
end)

concommand.Add("ma_make_database",function(ply,cmd,args)
	init_db()
end)

concommand.Add("ma_delete_me",function(ply,cmd,args)
	delete_player(ply)
end)

concommand.Add("ma_force_create_char",function(ply,cmd,args)
	create_player_character(ply)
end)
