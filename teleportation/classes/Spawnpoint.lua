local Player = require('Player')
local Event = require('Event')

local spawnpoints = require('Persister'):get('spawnpoints')

Spawnpoint = {
	getGroupSpawn = function(self, group)
		return spawnpoints[group] or spawnpoints.default
	end,

	getPlayerSpawn = function(self, ply, group, noBedSpawn)
		if not group then
			group = ply:getGroup() or "guest"
		end
		local spawn
		if not noBedSpawn then
			spawn = ply:getBedSpawnLocation()
		end
		return spawn or self:getGroupSpawn(group) or ply:getWorld():getSpawnLocation()
	end,

	setGroupSpawn = function(self, group, location)
		spawnpoints[group] = location
	end,

	getSpawnpoints = function(self)
		return spawnpoints
	end
}

Event:register{
	class = "org.bukkit.event.player.PlayerRespawnEvent",
	priority = Event.Priority.NORMAL,
	ignoreCancelled = true,
	run = function(self, event)
		event:setRespawnLocation(Player:extend(event:getPlayer()):getSpawn())
	end
}

Event:registerReadOnlyPlayerJoin(function(ply)
	local hasPlayedBefore = ply.hasPlayedBefore
	if type(hasPlayedBefore) ~= "boolean" then
		hasPlayedBefore = hasPlayedBefore(ply)
	end
	if not hasPlayedBefore then
		ply:teleportToSpawn()
	end
end)

Player:addExtensions{
	getSpawn = function(self)
		return Spawnpoint:getPlayerSpawn(self)
	end,
	teleportToSpawn = function(self)
		return self:teleport(self:getSpawn())
	end
}

return Spawnpoint