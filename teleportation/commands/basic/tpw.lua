local Command = require("Command")
local Spawnpoint = require("Spawnpoint")
local Player = require("Player")
local Event = require("Event")

local bukkitServer = require("Server"):getBukkitServer()

local WORLD_ALIASES = {
	survival = "world",
	default = "world",
	s = "world",

	c = "creative"
}

Event:register{
	class = "org.bukkit.event.player.PlayerTeleportEvent",
	priority = Event.Priority.MONITOR,
	ignoreCancelled = true,
	run = function(self, event)
		local ply = Player:extend(event:getPlayer())
		local oldWorld = event:getFrom():getWorld()
		local newWorld = event:getTo():getWorld()
		if oldWorld:equals(newWorld) then
			return
		end
		local lastWorldLocations = ply.lastWorldLocations or {}
		lastWorldLocations[oldWorld:getName():lower()] = event:getFrom()
		ply.lastWorldLocations = lastWorldLocations
	end
}

Command:register{
	name = "tpw",
	action = {
		format = "%s teleported %s to world %s",
		isProperty = false
	},
	permissionOther = false,
	arguments = {
		{
			name = "world",
			type = "string",
			required = true
		}
	},
	run = function(self, ply, args, flags)
		local worldName = args.world:lower()

		if WORLD_ALIASES[worldName] then
			worldName = WORLD_ALIASES[worldName]
		end
		
		local newWorld = bukkitServer:getWorld(worldName)
		if not newWorld then
			ply:sendError("Could not find world by name")
			return
		end

		if ply:getWorld():equals(newWorld) then
			ply:sendError("You cannot tp to the world you are currently in")
			return
		end

		local newWorldName = newWorld:getName():lower()

		if not ply:hasPermission("foxbukkit.teleportation.tpw.world." .. newWorldName) then
			ply:sendError("You cannot tp to that world")
			return			
		end

		local newLocation
		if ply.lastWorldLocations and ply.lastWorldLocations[newWorldName] then
			newLocation = ply.lastWorldLocations[newWorldName]
		else
			newLocation = Spawnpoint:getPlayerSpawn(ply, nil, false, newWorld)
		end

		ply:teleport(newLocation)
		
		self:sendActionReply(ply, ply, {}, newWorld:getName())
	end
}
