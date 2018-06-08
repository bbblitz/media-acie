AddCSLuaFile("hands.lua")

SWEP.ViewModel				= ""--"models/error.mdl"
SWEP.WorldModel				= ""--"models/error.mdl"

SWEP.HoldType 				= "normal"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"

SWEP.Secondary.Clipsize    	= -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:DrawShadow(false)
	self:SetNoDraw(true)

	--[[
	if (CLIENT) then
		self.MOB = ClientsideModel("error.mdl")
		self.MOB:SetNoDraw(true)
		self.MOB:DrawShadow(false)
	end
	]]
end

function SWEP:Tick()
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local owner = self:GetOwner()
	if owner.ma_weapon then
		owner.ma_weapon:primary_fire(owner)
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	--Make sure we have an equipment inventory
	if not self.Owner then return end
	if not self.Owner.data then return end
	if not self.Owner.data.inventories then return end
	if not self.Owner.data.inventories[1] then return end
	local eqpd = self.Owner.data.inventories[1]

	--Get the weapon we want to fire, and fire it!
	local weapon = eqpd:Get({"Right Hand"}) or eqpd:Get({"Dual"})
	if not weapon then
		self:DefaultPickup()
	elseif weapon.onClick ~= nil then
		weapon:onClick(self.Owner)
	end --Make sure we have a weapon
end

hook.Add("PlayerSpawn","give_hands",function(ply)
	ply:Give("hands")
end)
