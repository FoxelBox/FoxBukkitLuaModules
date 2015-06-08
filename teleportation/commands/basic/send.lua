local Command = require("Command")
local Permission = require("Permission")

local Location = bindClass("org.bukkit.Location")

Command:register{
	name = "send",
	action = {
		format = "%s teleported %s to %s",
		isProperty = false
	},
	arguments = {
		{
			name = "from_target",
			type = "players",
			required = true,
			immunityRequirement = Permission.Immunity.GREATER
		},
		{
			name = "to_target",
			type = "player",
			required = true,
			flagsForbidden = "c",
			immunityRequirement = Permission.Immunity.GREATER_OR_EQUAL
		},
		{
			name = "x",
			type = "number",
			required = true,
			flagsRequired = "c"
		},
		{
			name = "yz",
			type = "number",
			required = true,
			flagsRequired = "c"
		},
		{
			name = "z",
			type = "number",
			required = false,
			default = false,
			flagsRequired = "c"
		}
	},
	run = function(self, ply, args, flags)
		if flags:contains("c") then
			local world = ply:getWorld()
			
			local x = args.x
			local z = args.z or args.yz

			local y = args.z and args.yz or world:getHighestBlockYAt(x, z)
			
			local location = luajava.new(Location, world, x, y, z)
			for _, ply in next, args.from_target do
				ply:teleport(location)
			end
			self:sendActionReply(ply, args.from_target, {
				format = "%s teleported %s to %d %d %d"
			}, x, y, z)
			return
		end
		for _, ply in next, args.from_target do
			ply:teleport(args.to_target.__entity)
		end
		self:sendActionReply(ply, args.from_target, {}, args.to_target)
	end
}
