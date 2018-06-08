local s = {}

s.name = "Assult Rifle"

-- Upgradeable
s.starting_clip = 20
s.starting_fire_speed = 0.2
s.starting_dammage = 20

-- Non-upgradeable
s.ammo = "Bullet"

s.max_clip = 100
s.max_fire_speed = 0.05
s.max_dammage = 100

s.clip_upgrade_step = 5
s.fire_speed_upgrade_step = -0.025
s.dammage_upgrade_step = 10

s.clip = s.starting_clip
s.fire_speed = s.starting_fire_speed
s.dammage = s.starting_dammage

s.fields_to_save = {"Clip","FireSpeed","BulletDammage"}

--Just numbers, that's pretty easy
function s.serialize(self)
	local tosave = {}
	for k,v in pairs(self.fields_to_save) do
		tosave[v] = self[v]
	end
	return util.TableToJSON(tosave)
end

function s.deserialize(self,data)
	local tbl = util.JSONToTable(data)
	for k,v in pairs(tbl) do
		self[k] = v
	end
end

function s.fire(ply)
	
end

return s
