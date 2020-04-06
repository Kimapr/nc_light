-- LUALOCALS < ---------------------------------------------------------
local ItemStack, math, minetest, nodecore, pairs, setmetatable, vector
		= ItemStack, math, minetest, nodecore, pairs, setmetatable, vector
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
local checkdirs = {
	{x = 1, y = 0, z = 0},
	{x = -1, y = 0, z = 0},
	{x = 0, y = 0, z = 1},
	{x = 0, y = 0, z = -1},
	{x = 0, y = 1, z = 0}
}
----------------------------------------
nodecore.lantern_life_base = 120
nodecore.max_lantern_fuel = 8

----------------------------------------
----------EMPTY LANTERN----------
minetest.register_node(modname .. ":lantern_empty", {
	description = "Lantern",
		tiles = {
		"nc_lode_tempered.png",
		"nc_lode_tempered.png",
		"nc_light_lantern_side.png",
		"nc_light_lantern_side.png",
		"nc_light_lantern_front.png",
		"nc_light_lantern_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, -0.4375, 0.3125}, -- Baseplate
			{-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, -- Fuelbox
			{-0.1875, -0.125, -0.1875, 0.1875, 0.25, 0.1875}, -- Mantle
			{-0.25, 0.25, -0.25, 0.25, 0.3125, 0.25}, -- Topplate
			{-0.1875, 0.25, -0.1875, 0.1875, 0.375, 0.1875}, -- Topplate2
			{-0.125, 0.3125, -0.0625, 0.125, 0.5, 0.0625}, -- Handle
		}
	},
		sunlight_propagates = true,
--		light_source = light,
		groups = {
			stack_as_node = 1,
			snappy = 1,
			lantern = 1,
			lantern_off =1
		},
		stack_max = 1,
		sounds = nodecore.sounds("nc_lode_annealed"),
	})

----------------------------------------
------------Lantern Crafting------------
nodecore.register_craft({
		label = "assemble lantern",
		nodes = {
			{match = {groups = {chisel = true}}, replace = "air"},
			{y = -1, match = "nc_optics:glass", replace = "air"},
			{y = -2, match = {groups = {metal_block = true}}, replace = modname .. ":lantern_empty"},
		}
	})

----------------------------------------
-----------FUELED LANTERN OFF-----------
local function lantern (fuel) -- Kimapr: deleted these redundant arguments (fuel, burn, energy, light, refill)

local burn = fuel-1
local aburns = burn == 0 and "empty" or burn -- nodename suffix after burn
local light = fuel + 6

minetest.register_node(modname .. ":lantern_" .. fuel, {
	description = "Lantern",
		tiles = {
		"nc_lode_tempered.png",
		"nc_lode_tempered.png",
		"nc_light_lantern_side.png^nc_light_fuel_" .. fuel .. ".png",
		"nc_light_lantern_side.png^nc_light_fuel_" .. fuel .. ".png",
		"nc_light_lantern_front.png^nc_light_fuel_" .. fuel .. ".png",
		"nc_light_lantern_front.png^nc_light_fuel_" .. fuel .. ".png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, -0.4375, 0.3125}, -- Baseplate
			{-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, -- Fuelbox
			{-0.1875, -0.125, -0.1875, 0.1875, 0.25, 0.1875}, -- Mantle
			{-0.25, 0.25, -0.25, 0.25, 0.3125, 0.25}, -- Topplate
			{-0.1875, 0.25, -0.1875, 0.1875, 0.375, 0.1875}, -- Topplate2
			{-0.125, 0.3125, -0.0625, 0.125, 0.5, 0.0625}, -- Handle
		}
	},
		sunlight_propagates = true,
--		light_source = light,
		groups = {
			falling = 1,
			flammable = 1,
			stack_as_node = 1,
			snappy = 1,
			lantern_off = 1,
			lantern = 1
		},
		stack_max = 1,
		sounds = nodecore.sounds("nc_lode_annealed"),
		on_ignite = function(pos, node)
			minetest.set_node(pos, {name = modname .. ":lantern_lit_" .. fuel})
			minetest.sound_play("nc_fire_ignite", {gain = 1, pos = pos})
			return true
			end
	})

----------------------------------------
-----------FUELED LANTERN LIT-----------
minetest.register_node(modname .. ":lantern_lit_" .. fuel, {
	description = "Lantern",
		tiles = {
		"nc_lode_tempered.png",
		"nc_lode_tempered.png",
		"nc_light_lantern_side.png^nc_light_fuel_" .. fuel .. ".png^nc_light_lamplight.png",
		"nc_light_lantern_side.png^nc_light_fuel_" .. fuel .. ".png^nc_light_lamplight.png",
		"nc_light_lantern_front.png^nc_light_fuel_" .. fuel .. ".png^nc_light_lamplight.png",
		"nc_light_lantern_front.png^nc_light_fuel_" .. fuel .. ".png^nc_light_lamplight.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, -0.4375, 0.3125}, -- Baseplate
			{-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}, -- Fuelbox
			{-0.1875, -0.125, -0.1875, 0.1875, 0.25, 0.1875}, -- Mantle
			{-0.25, 0.25, -0.25, 0.25, 0.3125, 0.25}, -- Topplate
			{-0.1875, 0.25, -0.1875, 0.1875, 0.375, 0.1875}, -- Topplate2
			{-0.125, 0.3125, -0.0625, 0.125, 0.5, 0.0625}, -- Handle
		}
	},
		sunlight_propagates = true,
		light_source = light,
		groups = {
			falling = 1,
			stack_as_node = 1,
			snappy = 1,
			lantern_lit = 1,
			lantern = 1
		},
		stack_max = 1,
		sounds = nodecore.sounds("nc_lode_annealed")
	})

----------------------------------------
------------Fuel Consumption------------
-----Placed-----
nodecore.register_abm({
		label = "Lantern Fuel Use",
		interval = 10,
		chance = 1,
		nodenames = {modname .. ":lantern_lit_" .. fuel},
		action = function(pos)
			minetest.sound_play("nc_fire_flamy", {gain = 0.4, pos = pos})
			return minetest.set_node(pos, {name = modname .. ":lantern_lit_" .. aburns})
		end
	})
-- Kimapr: merged two ABMs into one

-----Carried-----
nodecore.register_aism({
				label = "Held Fuel Use",
				interval = 10,
				chance = 1,
				itemnames = {modname .. ":lantern_lit_" .. fuel},
				action = function(stack, data)
						if data.player and (data.list ~= "main"
								or data.slot ~= data.player:get_wield_index()) then return end
						minetest.sound_play("nc_fire_flamy", {gain = 0.4, pos = data.pos})
						stack:set_name(modname .. ":lantern_lit_" .. aburns)
						return stack
				end
		})
		
-- Kimapr: merged two AISMs into one

----------------------------------------
-------------Lantern Refill-------------

nodecore.register_craft({
		label = "refill lantern",
		action = "pummel",
		wield = {name = "nc_fire:lump_coal"},
		after = function(pos, data)
			local ref = minetest.get_player_by_name(data.pname)
			local wield = ref:get_wielded_item()
			wield:take_item(1)
			ref:set_wielded_item(wield)
		end,
		nodes = {
				{match = modname .. ":lantern_"..aburns, replace = modname .. ":lantern_"..fuel}
			}
	})

----------------------------------------
------------Lantern Ambiance------------
nodecore.register_ambiance({
		label = "Flame Ambiance",
		nodenames = {"nc_light:lantern_lit_" ..fuel},
		interval = 1,
		chance = 2,
		sound_name = "nc_fire_flamy",
		sound_gain = 0.1
	})

----------------------------------------
--------------WHEN WIELDED--------------
local litgroup = {}
minetest.after(0, function()
		for k, v in pairs(minetest.registered_items) do
			if v.groups.lantern_lit then
				litgroup[k] = true
			end
		end
	end)
local function islit(stack)
	return stack and litgroup[stack:get_name()]
end

local function snuffinv(player, inv, i)
	minetest.sound_play("nc_fire_snuff", {object = player, gain = 0.5})
	inv:set_stack("main", i, {modname .. ":lantern_" .. fuel})
end

local bright = nodecore.dynamic_light_node(light)
local dim = nodecore.dynamic_light_node(light - 2)

local ambtimers = {}
minetest.register_globalstep(function()
		local now = nodecore.gametime
		for _, player in pairs(minetest.get_connected_players()) do
			local inv = player:get_inventory()
			local ppos = player:get_pos()

			-- Snuff all lanterns if doused in water.
			local hpos = vector.add(ppos, {x = 0, y = 1, z = 0})
			local head = minetest.get_node(hpos).name
			if minetest.get_item_group(head, "water") > 0 then
				for i = 1, inv:get_size("main") do
					local stack = inv:get_stack("main", i)
					if islit(stack) then snuffinv(player, inv, i) end
				end
			elseif islit(player:get_wielded_item()) then
				-- Wield light
				local name = player:get_player_name()
				nodecore.dynamic_light_add(hpos, bright, 0.5)

				-- Wield ambiance
				local t = ambtimers[name] or 0
				if t <= now then
					ambtimers[name] = now + 1
					minetest.sound_play("nc_fire_flamy",
						{object = player, gain = 0.1})
				end
			else
				-- Dimmer non-wielded carry light
				for i = 1, inv:get_size("main") do
					if islit(inv:get_stack("main", i)) then
						nodecore.dynamic_light_add(hpos, dim, 0.5)
					end
				end
			end
		end
	end)

-- Apply wield light to entities as well.
local function entlight(self, ...)
	local stack = ItemStack(self.node and self.node.name or self.itemstring or "")
	if not islit(stack) then return ... end
	nodecore.dynamic_light_add(self.object:get_pos(), bright, 0.5)
	return ...
end
for _, name in pairs({"item", "falling_node"}) do
	local def = minetest.registered_entities["__builtin:" .. name]
	local ndef = {
		on_step = function(self, ...)
			return entlight(self, def.on_step(self, ...))
		end
	}
	setmetatable(ndef, def)
	minetest.register_entity(":__builtin:" .. name, ndef)
end

end

--Lantern-Fuel-Burn-Energy-Light-Refill--
for n=1,nodecore.max_lantern_fuel do
	lantern(n)
end
