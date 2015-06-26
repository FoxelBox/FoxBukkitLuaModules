local Command = require("Command")
local Permission = require("Permission")

local GameMode = bindClass("org.bukkit.GameMode")

Command:register{
	name = "gamemode",
	aliases = {"gm"}, 
	action = {
		format = "%s set %s gamemode to %s",
		isProperty = true,
		broadcast = true
	},
	arguments = {
		{
			name = "gamemode",
			type = "enum",
			enum = GameMode,
			aliases = {
				c = GameMode.CREATIVE,
				s = GameMode.SURVIVAL,
				a = GameMode.ADVENTURE,
				spec = GameMode.SPECTATOR
			},
			enumIdFunction = GameMode.getByValue
		},
		{
			name = "target",
			type = "player",
			defaultSelf = true,
			required = false,
			immunityRequirement = Permission.Immunity.GREATER
		}
	},
	run = function(self, ply, args, flags)
		if not ply:hasPermission(self.permission .. "." .. args.gamemode:name():lower()) then
			ply:sendError("Permission denied")
			return
		end
		args.target:setGameMode(args.gamemode)
		self:sendActionReply(ply, args.target, {
			silent = flags:contains("s")
		}, args.gamemode:name())
	end
}
