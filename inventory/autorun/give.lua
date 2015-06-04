local Command = require("Command")
local Permission = require("Permission")

local Material = luajava.bindClass("org.bukkit.Material")
local ItemStack = luajava.bindClass("org.bukkit.inventory.ItemStack")

Command:register{
	name = "give",
	aliases = {"i", "item"},
	action = {
		format = "%s gave %s %d of %s:%d",
		isProperty = false
	},
	arguments = {
		{
			name = "item",
			type = "enum",
			enum = Material,
			enumIdFunction = Material.getMaterial,
			enumNameFunction = Material.matchMaterial
		},
		{
			name = "amount",
			type = "number",
			required = false,
			default = 1
		},
		{
			name = "data",
			type = "number",
			required = false,
			default = 0
		},
		{
			name = "target",
			type = "player",
			defaultSelf = true,
			required = false,
			immunityRequirement = Permission.immunity.GREATER
		}
	},
	run = function(self, ply, args, flags)
		local itemStack = luajava.new(ItemStack, args.item, args.amount, args.data)
		args.target:getInventory():addItem({itemStack})
		self:sendActionReply(ply, args.target, itemStack:getAmount(), itemStack:getType():name(), itemStack:getDurability())
	end
}
