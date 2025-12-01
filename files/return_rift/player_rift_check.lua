function teleported(from_x, from_y, to_x, to_y, is_portal)
	--check if using portal from parallel world to main world
	if is_portal and (GetParallelWorldPosition(from_x, from_y) ~= 0) and (GetParallelWorldPosition(to_x, to_y) == 0) then
		local rift = EntityLoad("mods/parallel_parity/files/return_rift/return_rift.xml", to_x, to_y)
		EntityAddComponent2(rift, "VariableStorageComponent", {
			name = "target_x",
			value_float = from_x,
		})
		EntityAddComponent2(rift, "VariableStorageComponent", {
			name = "target_y",
			value_float = from_y,
		})
	end
end