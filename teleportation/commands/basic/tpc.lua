local Command = require("Command")
local Permission = require("Permission")
local Locationstack = require("Locationstack")
require("Chat")
require("Player")

local Location = bindClass("org.bukkit.Location")

Command:register{
	name = "tpc",
	action = {
		format = "%s teleported %s to %d %d %d",
		isProperty = false
	},
	permissionOther = false,
	arguments = {
		{
			name = "x",
			type = "number",
			required = true
		},
		{
			name = "yz",
			type = "number",
			required = true
		},
		{
			name = "z",
			type = "number",
			required = false,
			default = false
		}
	},
	run = function(self, ply, args, flags)
		local world = ply:getWorld()
		
		local x = args.x
		local z = args.z or args.yz

		local y = args.z and args.yz or world:getHighestBlockYAt(x, z)
		
		local location = luajava.new(Location, world, x, y, z)
		Locationstack:add(ply)
		ply:teleport(location)
		self:sendActionReply(ply, ply, {}, x, y, z)
	end
}
