-- todo - change the color of the sampo
local entity_id = GetUpdatedEntityID()
local orb_count = math.min(GameGetOrbCountThisRun(), 33)

local name = GameTextGet("$par_shampo", GameTextGetTranslatedOrNot("$item_mcguffin_" .. orb_count))


local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")
if item_comp then
	ComponentSetValue2(item_comp, "item_name", name)
end

local ui_comp = EntityGetFirstComponent(entity_id, "UIInfoComponent")
if ui_comp then
	ComponentSetValue2(ui_comp, "name", name)
end