local Command = require("Command")
local Event = require("Event")

local PotionEffectType = bindClass("org.bukkit.potion.PotionEffectType")
local PotionEffect = bindClass("org.bukkit.potion.PotionEffect")

local function makePermanentPotionEffect(type, amp)	
	return luajava.new(PotionEffect, type, 2147483647, amp or 0)
end

Event:registerReadOnlyPlayerJoin(function(ply)
	if ply._effects then
		for type, factor in next, ply._effects do
			if factor and factor > 0 then
				ply:addPotionEffect(makePermanentPotionEffect(type, factor), true)
			else
				ply:removePotionEffect(type)
			end
		end
	end
end)

local function makePotionEffectCommand(name, type)
	return Command:register{
		name = name,
		action = {
			format = "%s set potion effect %s to %d",
			isProperty = true
		},
		arguments = {
			{
				name = "factor",
				type = "number",
				required = false,
				default = false,
				aliases = {
					off = 0,
					on = 1
				}
			}
		},
		run = function(self, ply, args)
			local factor = args.factor
			if not ply._effects then
				ply._effects = {}
			end
			if factor == false then
				factor = ply._effects[type]
				if not factor then
					factor = 1
				else
					factor = -factor
				end
			end
			ply._effects[type] = factor
			if factor > 0 then
				ply:addPotionEffect(makePermanentPotionEffect(type, factor), true)
				self:sendActionReply(ply, nil, {}, type:getName(), factor)
			else
				ply:removePotionEffect(type)
				self:sendActionReply(ply, nil, {
					format = "%s disabled potion effect %s"
				}, type:getName())
			end
		end
	}
end

makePotionEffectCommand("fullbright", PotionEffectType.NIGHT_VISION)
makePotionEffectCommand("speed", PotionEffectType.SPEED)

Command:register{
		name = "potion",
		action = {
			format = "%s set potion effect %s to %d",
			isProperty = true
		},
		arguments = {
			{
				name = "type",
				type = "enum",
				enum = PotionEffectType
			},
			{
				name = "factor",
				type = "number",
				required = false,
				default = false,
				aliases = {
					off = 0,
					on = 1
				}
			}
		},
		run = function(self, ply, args)
			local factor = args.factor
			local type = args.type

			if not ply._effects then
				ply._effects = {}
			end
			if factor == false then
				factor = ply._effects[type]
				if not factor then
					factor = 1
				else
					factor = -factor
				end
			end
			ply._effects[type] = factor
			if factor > 0 then
				ply:addPotionEffect(makePermanentPotionEffect(type, factor), true)
				self:sendActionReply(ply, nil, {}, type:getName(), factor)
			else
				ply:removePotionEffect(type)
				self:sendActionReply(ply, nil, {
					format = "%s disabled potion effect %s"
				}, type:getName())
			end
		end
	}