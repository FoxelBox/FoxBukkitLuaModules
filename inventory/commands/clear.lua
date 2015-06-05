local Command = require("Command")

Command:register{
	name = "clear",
	run = function(self, ply, args, flags)
		local inventory = ply:getInventory()
		if flags:contains("a") then
			inventory:clear()
		else
			for i = 9, 35 do
				inventory:clear(i)
			end
		end
		ply:sendReply("Inventory cleared")
	end
}
