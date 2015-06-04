local Command = require("Command")

local PotionEffectType = luajava.bindClass("org.bukkit.potion.PotionEffectType")
local PotionEffect = luajava.bindClass("org.bukkit.potion.PotionEffect")

local function makePermanentPotionEffect(type, amp)	
	return luajava.new(PotionEffect, type, 2147483647, amp or 0)
end

Command:register{
	name = "fullbright", 
	run = function(self, ply, args)
		ply.fullbright = not ply.fullbright
		if ply.fullbright then
			ply:addPotionEffect(makePermanentPotionEffect(PotionEffectType.NIGHT_VISION), true)
		else
			ply:removePotionEffect(PotionEffectType.NIGHT_VISION)
		end
	end
}

Command:register{
	name = "speed",
	arguments = {
		{
			name = "factor",
			type = "number",
			required = false
		}
	},
	run = function(self, ply, args)
		local speed = args.factor
		if speed > 1 then
			ply:addPotionEffect(makePermanentPotionEffect(PotionEffectType.SPEED, speed - 1), true)
		else
			ply:removePotionEffect(PotionEffectType.SPEED)
		end
	end
}
