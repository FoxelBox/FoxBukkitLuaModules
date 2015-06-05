local Player = require('Player')

local spawnpoints = {}

Spawnpoint = {
	getGroupSpawn = function(self, group)
		return spawnpoints[group] or spawnpoints.default
	end,

	getPlayerSpawn = function(self, ply, group, noBedSpawn)
		if not group then
			group = ply:getGroup() or "guest"
		end
		local spawn = self:getGroupSpawn(group)
		if not noBedSpawn and not spawn then
			spawn = ply:getBedSpawnLocation()
		end
		return spawn or ply:getWorld():getSpawnLocation()
	end,

	setGroupSpawn = function(self, group, location)
		spawnpoints[group] = location
	end,

	getSpawnpoints = function(self)
		return spawnpoints
	end
}

Player:addExtensions{
	getSpawn = function(self)
		return Spawnpoint:getPlayerSpawn(self)
	end
}

return Spawnpoint