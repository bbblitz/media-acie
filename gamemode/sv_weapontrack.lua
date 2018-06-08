util.AddNetworkString("ma_use_weapon")
print("Hello from sv_weapontrack.lua")
local fireing = {}

local function fire_once(ply)
	print("Should fire once")
	local wep = ply:GetActiveWeapon()
	if wep:IsScripted() and wep:CanPrimaryAttack() then
		wep:PrimaryAttack()
	end
end

local function fire_auto(ply,down)
	print("Should fire auto")
	fireing[ply] = down
end

net.Receive("ma_use_weapon",function(ln,ply)
	local wep = ply:GetActiveWeapon()
	if wep.Primary.Automatic then
		fire_auto(ply,net.ReadBool())
	elseif net.ReadBool() then
		fire_once(ply)
	end
end)

hook.Add("Tick","fire_weapons",function()
	for k,v in pairs(fireing) do
		if k:IsValid() and v then
			local wep = k:GetActiveWeapon()
			if wep:IsScripted() and wep:CanPrimaryAttack() then
				wep:PrimaryAttack()
			end
		else
			fireing[k] = nil
		end
	end
end)
