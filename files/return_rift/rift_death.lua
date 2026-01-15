local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)
local existing_pec = EntityGetFirstComponent(entity_id, "ParticleEmitterComponent", "enabled_in_hand")

GameScreenshake(15)
GamePlaySound("animals", "animals/failed_alchemist_b_orb/destroy", x, y)
local death_entity = EntityCreateNew()
EntitySetTransform(death_entity, x, y)

if existing_pec then
	local current_radius = ComponentGetValue2(existing_pec, "area_circle_radius")
	local outer_density = 2 * math.pi * current_radius
	local pec = EntityAddComponent2(death_entity, "ParticleEmitterComponent", {
		emitted_material_name = "spark_red",
		count_min = outer_density,
		count_max = outer_density,
		lifetime_min = 1,
		lifetime_max = 5,
		render_on_grid = true,
		airflow_force = 0.3,
		airflow_time = 0.01,
		airflow_scale = 0.05,
		emit_cosmetic_particles = true,
		emission_interval_min_frames = 0,
		emission_interval_max_frames = 0,
	})
	ComponentSetValue2(pec, "area_circle_radius", current_radius, current_radius)
	ComponentSetValue2(pec, "gravity", 0, 0)
end

EntityAddComponent2(death_entity, "LifetimeComponent", {
	lifetime = 3
})