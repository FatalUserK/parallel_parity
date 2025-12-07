local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

local x_offset = GetParallelWorldPosition(x, y)
if x_offset == 0 then return end

local tele_comps = EntityGetComponentIncludingDisabled(entity_id, "TeleportComponent")
if tele_comps == nil then return end

local map_width = BiomeMapGetSize() * 512
local half_width = map_width * .5
for _, value in ipairs(tele_comps) do
	local target = {ComponentGetValue2(value, "target")}
	ComponentSetValue2(value, "target", ((target[1] + half_width) % map_width)-half_width + (x_offset * map_width), target[2])
	--modulate position to main world, then add current PW as offset, in case more than one source is trying to localise the portal destination.
end