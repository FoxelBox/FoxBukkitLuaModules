local Command = require("Command")
local Spawnpoint = require("Spawnpoint")

local Location = bindClass("org.bukkit.Location")
local bukkitServer = require("Server"):getBukkitServer()

local Event = require("Event")
--[[Event:register{
	class = "org.bukkit.event.player.PlayerChangedWorldEvent",
	priority = Event.Priority.LOW,
	ignoreCancelled = true,
	run = function(self, event)
		local ply = Player:extend(event:getPlayer())
		local oldWorld = event:getFrom()
		local newWorld = ply:getWorld()
		if oldWorld:equals(newWorld) then
			return
		end
	end
}]]

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
		local world = ply:getWorld()
		
		local newWorld = bukkitServer:getWorld(args.world)
		if not newWorld then
			ply:sendError("Could not find world by name")
			return
		end

		if world:equals(newWorld) then
			ply:sendError("You cannot tp to the world you are currently in")
			return
		end

		local newWorldName = newWorld:getName():lower()

		local newLocation
		if ply.lastWorldLocations and ply.lastWorldLocations[newWorldName] then
			newLocation = ply.lastWorldLocations[newWorldName]
		else
			newLocation = Spawnpoint:getPlayerSpawn(ply, nil, false, newWorld)
		end
		
		self:sendActionReply(ply, ply, {}, newWorld:getName())
	end
}