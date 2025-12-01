function interacting(entity_who_interacted, entity_interacted, interactable_name)
	local entity_id = GetUpdatedEntityID()
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
	if not (target_x and target_y) then print("ERR - NO RIFT COORDINATES IDENTIFIED") return end

	local teleport_comp = EntityGetFirstComponent(entity_id, "TeleportComponent")
	if not teleport_comp then return end
	ComponentSetValue2(teleport_comp, "target", target_x, target_y)
	EntityAddComponent2(entity_id, "LifetimeComponent", {
		lifetime = 60
	})
end