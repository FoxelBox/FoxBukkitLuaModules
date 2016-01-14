local Player = require('Player')
local Event = require('Event')

local spawnpoints = require('Persister'):get('spawnpoints')

Spawnpoint = {
	getGroupSpawn = function(self, group, world)
		local worldName = (world and world:getName():lower()) or "world"
		local worldSpawn = spawnpoints[worldName]
		if worldSpawn then
			return worldSpawn[group and group:lower() or "default"] or worldSpawn.default
		end
	end,

	getPlayerSpawn = function(self, ply, group, noBedSpawn, world)
		if not group then
			group = ply:getGroup() or "guest"
		end
		if not world then
			world = ply:getWorld()
		end
		group = group:lower()
		local spawn
		if not noBedSpawn then
			spawn = ply:getBedSpawnLocation()
		end
		return spawn or self:getGroupSpawn(group, world) or world:getSpawnLocation()
	end,

	setGroupSpawn = function(self, group, world, location)
		local worldName = world:getName():lower()
		local worldSpawn = spawnpoints[worldName]
		if not worldSpawn then
			worldSpawn = {}
		end
		worldSpawn[group:lower()] = location
		spawnpoints[worldName] = worldSpawn
	end,

	getSpawnpoints = function(self, world)
		if world then
			return spawnpoints[world:getName():lower()] or {}
		end
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