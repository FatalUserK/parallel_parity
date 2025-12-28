local entity_id = GetUpdatedEntityID()
local teleport_comp = EntityGetFirstComponent(entity_id, "TeleportComponent")
if not teleport_comp then return end

local lifetime = 1800
local radius_offset = 30
local radius = 150
local particle_outer_density = .07
local particle_inner_density = .01
local particle_inwards_vel = -200

function init()
	EntityAddComponent2(entity_id, "LifetimeComponent", {
		lifetime = lifetime
	})
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local from_x, from_y = EntityGetTransform(entity_who_interacted)
	EntityLoad("data/entities/particles/teleportation_source.xml", from_x, from_y)

	local target_x = from_x
	local target_y = from_y
	local variable_storage_comps = EntityGetComponent(entity_interacted, "VariableStorageComponent")
	if variable_storage_comps ~= nil then
		for i, comp in ipairs(variable_storage_comps) do
			local name = ComponentGetValue2(comp, "name")
			if name == "target_x" then
				target_x = ComponentGetValue2(comp, "value_float")
			elseif name == "target_y" then
				target_y = ComponentGetValue2(comp, "value_float")
			end
		end
	end
	if not (target_x and target_y) then return end

	ComponentSetValue2(teleport_comp, "target", target_x + 25, target_y)
	EntityAddComponent2(entity_id, "LifetimeComponent", {
		lifetime = 30
	})
	EntityAddComponent2(entity_id, "HitboxComponent", {
		aabb_min_x = -35,
		aabb_min_y = -35,
		aabb_max_x = 35,
		aabb_max_y = 35,
	})

	GamePrint("$par_rift_return")
end

local lifetime_comp = EntityGetFirstComponent(entity_id, "LifetimeComponent")
if not lifetime_comp then return end
local current_frame =  GameGetFrameNum()
local remaining_lifetime = ComponentGetValue2(lifetime_comp, "kill_frame") - current_frame
local relative_remaining_lifetime = remaining_lifetime/lifetime

local particle_comps = EntityGetComponent(entity_id, "ParticleEmitterComponent", "enabled_in_hand") or {}
if #particle_comps ~= 2 then return end

local current_radius = radius * relative_remaining_lifetime + radius_offset
local x,y = EntityGetTransform(entity_id)

if #EntityGetInRadiusWithTag(x, y, current_radius, "player_unit") + #EntityGetInRadiusWithTag(x, y, current_radius, "player_polymorphed") == 0 then
	EntityKill(entity_id)
	return
end

local current_outer_density = (2 * math.pi * current_radius) * particle_outer_density
ComponentSetValue2(particle_comps[1], "area_circle_radius", current_radius, current_radius)
ComponentSetValue2(particle_comps[1], "count_min", current_outer_density * .75)
ComponentSetValue2(particle_comps[1], "count_max", current_outer_density * 1.5)

local current_inner_density = (2 * math.pi * current_radius) * particle_inner_density
ComponentSetValue2(particle_comps[2], "area_circle_radius", current_radius, current_radius)
ComponentSetValue2(particle_comps[2], "count_min", current_inner_density * .75)
ComponentSetValue2(particle_comps[2], "count_max", current_inner_density * 1.5)
ComponentSetValue2(particle_comps[2], "velocity_always_away_from_center", particle_inwards_vel * relative_remaining_lifetime *.75)