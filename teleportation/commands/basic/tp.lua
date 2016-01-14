local Command = require("Command")
local Permission = require("Permission")
local Locationstack = require("Locationstack")
local Chat = require("Chat")
local Player = require("Player")

local bukkitServer = require("Server"):getBukkitServer()

local Event = require("Event")
Event:register{
	class = "org.bukkit.event.player.PlayerQuitEvent",
	priority = Event.Priority.MONITOR,
	ignoreCancelled = true,
	run = function(self, event)
		local ply = Player:extend(event:getPlayer())
		ply.logoutLocation = ply:getLocation()
	end
}

local Location = bindClass("org.bukkit.Location")

Command:register{
	name = "tp",
	action = {
		format = "%s teleported to %s%s",
		isProperty = false
	},
	permissionOther = false,
	arguments = {
		{
			name = "target",
			type = "player",
			required = true,
			flagsForbidden = "o",
			immunityRequirement = Permission.Immunity.GREATER_OR_EQUAL
		},
		{
			name = "name",
			typoe = "string",
			required = true,
			flagsRequired = "o"
		}
	},
	run = function(self, ply, args, flags)
		if flags:contains("o") then
			if not ply:hasPermission(self.permission .. ".offline") then
				ply:sendError("Permission denied")
				return
			end

			local offlineUUID = Chat:getPlayerUUID(args.name)
			if not offlineUUID then
				ply:sendError("Player not found")
				return
			end

			if not ply:fitsImmunityRequirement(offlineUUID, Permission.Immunity.GREATER_OR_EQUAL) then
				ply:sendError("Permission denied for target")
				return
			end

			local offlinePlayer = Player:extend(bukkitServer:getOfflinePlayer(offlineUUID))
			if not offlinePlayer.logoutLocation then
				ply:sendError("Logout location not yet tracked")
				return
			end

			Locationstack:add(ply)
			ply:teleport(offlinePlayer.logoutLocation)
			self:sendActionReply(ply, offlinePlayer, {
				silentToTarget = true
			}, " (last logout location)")
			return
		end

		Locationstack:add(ply)
		ply:teleport(args.target)
		
		local silent = (flags:contains("s") and ply:hasPermission(self.permission .. ".silent")) or not args.target:canSee(ply)
		self:sendActionReply(ply, args.target, {
			silentToTarget = silent
		}, silent and " (silent)" or "")
	end
}
