local Command = require("Command")
local Permission = require("Permission")
local Locationstack = require("Locationstack")

local Location = bindClass("org.bukkit.Location")

Command:register{
	name = "tp",
	action = {
		format = "%s teleported to %s",
		isProperty = false
	},
	arguments = {
		{
			name = "target",
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
			Locationstack:add(ply)
			ply:teleport(location)
			self:sendActionReply(ply, ply, {
				format = "%s teleported %s to %d %d %d"
			}, x, y, z)
			return
		end
		ply:teleport(args.target.__entity)
		self:sendActionReply(ply, args.target, {
			silentToTarget = flags:contains("s")
		})
	end
}
