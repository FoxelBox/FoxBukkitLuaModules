local Command = require("Command")
local Permission = require("Permission")

local next = next

Command:register{
	name = "clear",
	action = {
		format = "%s cleared %s inventory",
		isProperty = true
	},
	arguments = {
		{
			name = "target",
			type = "players",
			required = false,
			defaultSelf = true,
			immunityRequirement = Permission.Immunity.GREATER
		}
	},
	run = function(self, ply, args, flags)
		local clearAll = flags:contains("a")
		for _, target in next, args.target do
			local inventory = target:getInventory()
			if clearAll then
				inventory:clear()
			else
				for i = 9, 35 do
					inventory:clear(i)
				end
			end
		end
		self:sendActionReply(ply, args.target, {})
	end
}
