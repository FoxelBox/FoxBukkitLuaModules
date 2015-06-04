local Command = require("Command")
local Permission = require("Permission")

local Material = luajava.bindClass("org.bukkit.Material")
local ItemStack = luajava.bindClass("org.bukkit.inventory.ItemStack")

local function sendReplyTo(cmd, ply, target, itemStack)
	ply:sendReply(cmd:referTo(target, ply):ucfirst() .. " gave " .. cmd:referTo(ply, target, true) .. " " .. itemStack:getAmount() .. " of " .. itemStack:getType():name() .. ":" .. itemStack:getDurability())
end

Command:register{
	name = "give",
	aliases = {"i", "item"},
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
		if args.target ~= ply then
			sendReplyTo(self, args.target, args.target, itemStack)
		end
		sendReplyTo(self, ply, args.target, itemStack)
	end
}
