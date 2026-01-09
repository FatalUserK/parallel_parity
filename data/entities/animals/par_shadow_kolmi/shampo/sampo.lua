local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)
local name


if EntityGetName(entity_id) == "shampo" then
	local orb_count = GameGetOrbCountThisRun()
	if orb_count <33 then
		orb_count = math.min(orb_count, 13)
	else
		orb_count = 33
	end

	name = GameTextGet("$par_shampo", GameTextGetTranslatedOrNot("$item_mcguffin_" .. orb_count))

	local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")
	if item_comp then
		ComponentSetValue2(item_comp, "item_name", name)
	end

	local ui_comp = EntityGetFirstComponent(entity_id, "UIInfoComponent")
	if ui_comp then
		ComponentSetValue2(ui_comp, "name", name)
	end
end


function init()
	SetRandomSeed(x,y)
	if Random(1, 100) == 100 then
		EntitySetName(entity_id, "shampo_funny")
		name = "$par_shampo_funny"

		if Random(1, 10000) == 10000 then
			EntitySetName(entity_id, "shampoo")
			name = "$par_shampoo"

			local sprite_comp = EntityGetFirstComponent(entity_id, "SpriteComponent")
			if sprite_comp then
				ComponentSetValue2(sprite_comp, "rect_animation", "shampoo")
			end
		end


		local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")
		if item_comp then
			ComponentSetValue2(item_comp, "item_name", name)
		end

		local ui_comp = EntityGetFirstComponent(entity_id, "UIInfoComponent")
		if ui_comp then
			ComponentSetValue2(ui_comp, "name", name)
		end
	end
end




function item_pickup(_, taker)
	--check for player in case of some bs like a diff entity picking it up (eg fairmod bs)
	if EntityHasTag(taker, "player_unit") or EntityHasTag(taker, "player_polymorphed") then
		local ui_comp = EntityGetFirstComponent(entity_id, "UIInfoComponent")
		if ui_comp then
			GamePrint(GameTextGet("$par_shampo_pickup", GameTextGetTranslatedOrNot(ComponentGetValue2(ui_comp, "name"))))
		end
	end



	GameTriggerMusicFadeOutAndDequeueAll(10.0)
	GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/rune/destroy", x, y)
	GameTriggerMusicEvent("music/boss_arena/battle", false, x, y)
	SetRandomSeed(x, y)

	if EntityGetName(entity_id) ~= "shampoo" then
		EntityLoad("data/entities/animals/par_shadow_kolmi/shampo/shampo_effect.xml", x, y)
	else
		EntityLoad("data/entities/animals/par_shadow_kolmi/shampo/shampoo_effect.xml", x, y)
	end

	local entities = {}
	for _, value in ipairs(EntityGetInRadiusWithTag(x, y, 500, "sampo_or_boss")) do
		if EntityGetName(value) == "$animal_par_shadow_kolmi" then
			entities[#entities+1] = value
		end
	end
	if  #entities == 0  then
		print_error("shadow_kolmi - couldn't find sampo")
		return
	end

	local reference = EntityGetClosestWithTag(x, y, "reference")
	if reference == 0 then
		print_error("shadow_kolmi - couldn't find reference")
		return
	end

	x,y = EntityGetTransform(reference)

	for _,shadow_kolmi in ipairs(entities) do
		EntitySetComponentsWithTagEnabled(shadow_kolmi, "disabled_at_start", true)
		EntitySetComponentsWithTagEnabled(shadow_kolmi, "enabled_at_start", false)
		PhysicsSetStatic(shadow_kolmi, false)

		if EntityHasTag(shadow_kolmi, "boss_centipede") then
			EntityAddTag(shadow_kolmi, "boss_centipede_active")

			local child_entities = EntityGetAllChildren(shadow_kolmi)
			local child_to_remove

			if child_entities then
				for _,child_id in ipairs(child_entities) do
					if EntityHasTag(child_id, "protection") then
						child_to_remove = child_id
					end
				end
			end

			if child_to_remove then
				EntityKill(child_to_remove)
			end
		end
	end

	EntityLoad("data/entities/animals/boss_centipede/loose_lavaceiling.xml", x-235, y-73)
	EntityLoad("data/entities/animals/boss_centipede/loose_lavaceiling.xml", x+264, y-50)
	EntityLoad("data/entities/animals/boss_centipede/loose_lavabridge.xml", x-235, y+282)
	EntityLoad("data/entities/animals/boss_centipede/loose_lavabridge.xml", x+257, y+262)

	EntityKill(entity_id)
end