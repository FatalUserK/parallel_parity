local start = GameGetRealWorldTimeSinceStarted()

--global thingy so other mods can do stuff
ParallelParity = {
	default_map_path = "data/biome_impl/biome_map.png",
	default_pixel_scenes_path = "data/biome/_pixel_scenes.xml",
	settings = {},
	force_true = false, --use this to force enable everything for testing purposes
	logging = false,
}

local par = ParallelParity
local force_true = par.force_true

---@type nxml
local nxml = dofile_once("mods/parallel_parity/files/nxml.lua")
nxml.error_handler = function() end
--#endregion


--convenient functions
--#region

local function escape(str) return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1") end

string.modify = function(s, pattern, repl)
	return s:gsub(escape(pattern), repl)
end

local function dump(o) --handy func i stole that prints an entire table
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		if type(o) == "string" then o = '"' .. o .. '"' end
		return tostring(o)
	end
end

local function log(s)
	if par.logging then print(tostring(s)) end
end

local biome_scripts = {}
--get biomescript from biomexml. note: maybe merge with MapGetBiomeScript() at some point
local function GetBiomeScript(biomepath, generate)
	local biomexml = nxml.parse(ModTextFileGetContent(biomepath))

	if not biome_scripts[biomepath] then
		local toplogy = biomexml and biomexml:first_of("Topology")
		if toplogy then
			local script = toplogy.attr.lua_script
			if generate and script == nil then
				local filename
				for str in string.gmatch(biomepath, "([^".."/".."]+)") do --i stole the gmatch string i still dont get string patterns 😭
					filename = str
				end
				local generated_script_path = ("mods/parallel_parity/files/biomescripts/") .. filename:sub(1, -4) .. "lua"
				ModTextFileSetContent(generated_script_path, "") --yknow itd be really funny if i could just append empty nothingness and have that work without needing to make an entire script
				toplogy.attr.lua_script = generated_script_path
			end
			biome_scripts[biomepath] = toplogy.attr.lua_script
		end
	end

	return biome_scripts[biomepath]
end

--get biomescript from chunk coordinate
local function MapGetBiomeScript(biome_map, chunk_pos_x, chunk_pos_y)
	local mdata = par.cached_maps[biome_map]

	local map_pos_x = (chunk_pos_x + (mdata.w * .5))

	local map_pos_y = chunk_pos_y + 14
	map_pos_y = math.max(map_pos_y, 0)
	map_pos_y = math.min(map_pos_y, mdata.h - 1)

	local abgr_int = ModImageGetPixel(mdata.map, map_pos_x, map_pos_y) --get pixel colour as ABGR integer
	local hex = ("%02x%02x%02x"):format(bit.band(abgr_int, 0xFF), bit.band(bit.rshift(abgr_int, 8), 0xFF), bit.band(bit.rshift(abgr_int, 16), 0xFF)) --convert it to something sane
	if hex == "000000" then return nil end
	return GetBiomeScript(par.biomelist[hex], true)
end
--#endregion

function OnModPreInit() --do misc stuff on mod preinit so other mods can append without mod load order issues
	dofile_once("mods/parallel_parity/settings.lua") --do this to initialise and set default values for newly-appended mod settings
	ModSettingsUpdate(1, true) --second parameter indicates this is run from init, do this to skip Gui*() calls from crashing the game

	dofile_once("mods/parallel_parity/data.lua") --initialise data, we do it like this so mods can append their own or make changes


	--automatically cache important map data
	par.cached_maps = {}
	for _, biome_maps in pairs(par.worlds) do
		for _, biome_map in ipairs(biome_maps) do
			if not par.cached_maps[biome_map] then
				par.cached_maps[biome_map] = {}
				par.cached_maps[biome_map].map, par.cached_maps[biome_map].w, par.cached_maps[biome_map].h = ModImageMakeEditable(biome_map, 0, 0)
			end
		end
	end

	ModTextFileSetContent("data/translations/common.csv",
		(ModTextFileGetContent("data/translations/common.csv") .. "\n" ..
		ModTextFileGetContent("mods/parallel_parity/standard.csv") .. "\n")
			:gsub("\r", "")
			:gsub("\n\n+", "\n"
		)
	)

	--special behaviour
	--#region

	--EoE Summoned Portal location and related hints in Underground Jungle
	if par.settings.portal_summon then
		local summon_portal_biomes = {
			"data/scripts/biomes/rainforest.lua",
			"data/scripts/biomes/fungicave.lua",
		}

		for _, path in ipairs(summon_portal_biomes) do --statues and portal spot
			ModTextFileSetContent(path, ModTextFileGetContent(path
				):modify(
					"function init(x, y, w, h)",
					"function init(x, y, w, h)\n	local pw_offset = GetParallelWorldPosition(x, 0) * BiomeMapGetSize() * 512"
				):modify(
					"local function is_inside_tile(pos_x, pos_y)",
					"local function is_inside_tile(pos_x, pos_y)\n		pos_x = pos_x + pw_offset"
				):modify(
					"EntityLoad( \"data/entities/misc/summon_portal_target.xml\", portal_x, portal_y )",
					"EntityLoad( \"data/entities/misc/summon_portal_target.xml\", portal_x + pw_offset, portal_y )"
				):modify(
					"local function spawn_statue(statue_num, spawn_x, spawn_y, ray_dir_x, ray_dir_y)",
					"local function spawn_statue(statue_num, spawn_x, spawn_y, ray_dir_x, ray_dir_y)\n		spawn_x = spawn_x + pw_offset"
				)
			)
		end


		local get_portal_position_targets = {
			"data/scripts/buildings/teleport_robot_egg_return.lua",
			"data/scripts/projectiles/summon_portal_position_check.lua",
		}

		for _, path in ipairs(get_portal_position_targets) do
			ModTextFileSetContent(path, ModTextFileGetContent(path):modify("local portal_x, portal_y = get_portal_position()",
	[[local portal_x, portal_y = get_portal_position()
	do
		local x,y = EntityGetTransform(GetUpdatedEntityID())
		portal_x = portal_x + (GetParallelWorldPosition(x,y) * BiomeMapGetSize() * 512)
	end]]))
		end
	end
	--#endregion


	--Special Main-World Localisation

	for path, biome in pairs(par.localise) do
		for _, targets in ipairs(biome) do
			for _, code in ipairs(targets) do
				ModTextFileSetContent(path, ModTextFileGetContent(path):modify(code, "if GetParallelWorldPosition(x, y) == 0 then " .. code .. " end;"))
			end
		end
	end


	-- Parallel Portals

	for path, value in pairs(par.portals) do
		if value then
			for portal in nxml.edit_file(path) do
				portal:add_child(nxml.new_element("LuaComponent", {
					script_source_file = "mods/parallel_parity/files/parallel_portals.lua",
					execute_on_added = true,
					remove_after_executed = true,
				}))
			end
		end
	end

	if par.settings.return_rifts then dofile("mods/parallel_parity/files/return_rift/return_rifts_init.lua") end
end


function OnMagicNumbersAndWorldSeedInitialized()
	par.biomelist = {} --list of every biome
	local biomelist_xml = nxml.parse(ModTextFileGetContent("data/biome/_biomes_all.xml")) --create hex-indexed table for all biomes that exist
	if biomelist_xml then
		for elem in biomelist_xml:each_child() do par.biomelist[(elem.attr.color):lower():sub(3,-1)] = elem.attr.biome_filename end
	else
		print("could not find \"data/biome/_biomes_all.xml\", fuck.")
	end


	--Scraper
	--#region
	local biome_appends = {}
	for pixel_scenes_path, biome_maps in pairs(par.worlds) do
		local pixel_scenes_xml = nxml.parse(ModTextFileGetContent(pixel_scenes_path))

		local ps_data = {
			spliced = pixel_scenes_xml:first_of("PixelSceneFiles"),
			backgrounds = pixel_scenes_xml:first_of("BackgroundImages"),
			scenes = pixel_scenes_xml:first_of("mBufferedPixelScenes"),
		}

		local remove_list = { --create remove list to cull target objects outside the world boundry
			--spliced = {}, dont check for spliced ones cuz vanilla doesnt do this and i dont wanna have to think about this until some maniac actually does this
			backgrounds = {},
			scenes = {},
		}

		for sps in ps_data.spliced:each_child() do
			local sps_filepath = ""
			for i = 1, #sps.content, 1 do
				sps_filepath = sps_filepath .. sps.content[i] --get the filepath to the spliced pixel scene xml by building it from the content, idk nolla is weird.
			end

			if par.spliced_pixel_scenes[sps_filepath] then --check if pixel scene is flagged
				if ModDoesFileExist(sps_filepath) then
					local sps_xml = nxml.parse(ModTextFileGetContent(sps_filepath))
					if sps_xml and sps_xml.children[1] then --this should generally just be one singular mBufferedPixelScenes component. if theres more than one child in the file then i feel i cant really be blamed for the lunacy of other modders
						for chunk in sps_xml.children[1]:each_child() do
							local chunk_pos_x = math.floor(chunk.attr.pos_x * 0.001953125) --i heard somewhere multiplication is more efficient than dividing so i hope thats true
							local chunk_pos_y = math.floor(chunk.attr.pos_y * 0.001953125)

							for _, biome_map in ipairs(biome_maps) do
								local biomescript = MapGetBiomeScript(biome_map, chunk_pos_x, chunk_pos_y)

								if biomescript ~= nil then --definitely SHOULD NOT be nil
									local map_scene_index = pixel_scenes_path .. "|" .. par.cached_maps[biome_map].w .. "|" .. par.cached_maps[biome_map].h

									local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y --hehe chunky
									--ng plus support code is temporary, I eventually wanna add special handling that predicts future permutations of the NG+ biome map and appends pixel scenes accordingly- even if its a bit overkill, it seems like good tech to have in my back-pocket
									-- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
									local skip_scraping = false
									if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
										if par.settings.ng_plus then
											for _, ng_script in ipairs(par.ng_plus_biomescripts) do
												if ng_script ~= biomescript then
													biome_appends[ng_script] = biome_appends[ng_script] or {}
													biome_appends[ng_script][map_scene_index] = biome_appends[ng_script][map_scene_index] or {scenes = {}, entities = {}}

													local biome_scene_index = biome_appends[ng_script][map_scene_index]
													biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
													biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
														materials = chunk.attr.material_filename,
														gfx = chunk.attr.colors_filename,
														background = chunk.attr.background_filename,
														offset_x = chunk.attr.pos_x - (chunk_pos_x * 512),
														offset_y = chunk.attr.pos_y - (chunk_pos_y * 512),
													}
												end
											end
										else
											skip_scraping = true --do this cuz I HATE NG+ WHY DO I NEED TO DO SO MUCH STUPID STUFF JUST TO ACCOUNT FOR IT AAAAAAAAAAAAAAAA
										end
									end--]]-- NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
									if not skip_scraping then
										biome_appends[biomescript] = biome_appends[biomescript] or {} --make sure biomescript table exists
										biome_appends[biomescript][map_scene_index] = biome_appends[biomescript][map_scene_index] or {scenes = {}, entities = {}} --make sure biomemap table exists

										local biome_scene_index = biome_appends[biomescript][map_scene_index] --shorten to local val so less indexing is required
										biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {} --make sure scene chunk table exists
										biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = { --add to scene chunk table
											materials = chunk.attr.material_filename,
											gfx = chunk.attr.colors_filename,
											background = chunk.attr.background_filename,
											offset_x = chunk.attr.pos_x - (chunk_pos_x * 512),
											offset_y = chunk.attr.pos_y - (chunk_pos_y * 512),
										}
									end
								end
							end
						end
					end
				end
			end
		end

		for bg in ps_data.backgrounds:each_child() do
			if par.pixel_scenes[bg.attr.filename] then
				local chunk_pos_x = math.floor(bg.attr.x * 0.001953125)
				local chunk_pos_y = math.floor(bg.attr.y * 0.001953125)

				for _, biome_map in ipairs(biome_maps) do
					local biomescript = MapGetBiomeScript(biome_map, chunk_pos_x, chunk_pos_y)

					if biomescript ~= nil then
						local map_scene_index = pixel_scenes_path .. "|" .. par.cached_maps[biome_map].w .. "|" .. par.cached_maps[biome_map].h

						local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y

						-- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
						local skip_scraping = false
						if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
							if par.settings.ng_plus then
								for _, ng_script in ipairs(par.ng_plus_biomescripts) do
									if ng_script ~= biomescript then
										biome_appends[ng_script] = biome_appends[ng_script] or {}
										biome_appends[ng_script][map_scene_index] = biome_appends[ng_script][map_scene_index] or {scenes = {}, entities = {}}

										local biome_scene_index = biome_appends[ng_script][map_scene_index]
										biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
										biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
											materials = "",
											gfx = "",
											background = bg.attr.filename, --is background scene so other attributes are unnecessary
											offset_x = bg.attr.x - (chunk_pos_x * 512),
											offset_y = bg.attr.y - (chunk_pos_y * 512),
										}
									end
								end
							else
								skip_scraping = true
							end
						end--]]-- NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
						if not skip_scraping then
							biome_appends[biomescript] = biome_appends[biomescript] or {}
							biome_appends[biomescript][map_scene_index] = biome_appends[biomescript][map_scene_index] or {scenes = {}, entities = {}}

							local biome_scene_index = biome_appends[biomescript][map_scene_index]
							biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
							biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
								materials = "",
								gfx = "",
								background = bg.attr.filename, --is background scene so other attributes are unnecessary
								offset_x = bg.attr.x - (chunk_pos_x * 512),
								offset_y = bg.attr.y - (chunk_pos_y * 512),
							}
						end
					else
						remove_list.backgrounds[#remove_list.backgrounds+1] = bg
					end
				end
			end
		end

		for elem in ps_data.scenes:each_child() do


			local file_name = "?"
			for _, value in ipairs({"just_load_an_entity", "material_filename", "colors_filename", "background_filename"}) do
				if elem.attr[value] ~= nil then
					file_name = elem.attr[value] or "false"
					break
				end
			end
			if par.pixel_scenes[elem.attr.just_load_an_entity]
					or par.pixel_scenes[elem.attr.material_filename]
					or par.pixel_scenes[elem.attr.colors_filename]
					or par.pixel_scenes[elem.attr.background_filename]
				then

				local chunk_pos_x = math.floor(elem.attr.pos_x * 0.001953125)
				local chunk_pos_y = math.floor(elem.attr.pos_y * 0.001953125)

				for _, biome_map in ipairs(biome_maps) do
					local biomescript = MapGetBiomeScript(biome_map,chunk_pos_x, chunk_pos_y)

					if biomescript ~= nil then
						local map_scene_index = pixel_scenes_path .. "|" .. par.cached_maps[biome_map].w .. "|" .. par.cached_maps[biome_map].h

						local chunk_key = chunk_pos_x .. "_" .. chunk_pos_y
						-- [[ NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
						local skip_scraping = false
						if biome_map == "data/biome_impl/biome_map_newgame_plus.png" then
							if par.settings.ng_plus then
								for _, ng_script in ipairs(par.ng_plus_biomescripts) do
									if ng_script ~= biomescript then
										biome_appends[ng_script] = biome_appends[ng_script] or {}
										biome_appends[ng_script][map_scene_index] = biome_appends[ng_script][map_scene_index] or {scenes = {}, entities = {}}
										local biome_scene_index = biome_appends[ng_script][map_scene_index]
										if elem.attr.just_load_an_entity then
											biome_scene_index.entities[chunk_key] = biome_scene_index.entities[chunk_key] or {}
											biome_scene_index.entities[chunk_key][#biome_scene_index.entities[chunk_key] + 1] = {
												path = elem.attr.just_load_an_entity,
												offset_x = elem.attr.pos_x - (chunk_pos_x * 512),
												offset_y = elem.attr.pos_y - (chunk_pos_y * 512),
											}
										else
											biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
											biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
												materials = elem.attr.material_filename,
												gfx = elem.attr.colors_filename,
												background = elem.attr.background_filename,
												offset_x = elem.attr.pos_x - (chunk_pos_x * 512),
												offset_y = elem.attr.pos_y - (chunk_pos_y * 512),
											}
										end
									end
								end
							else
								skip_scraping = true
							end
						end--]]-- NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT NG+ SUPPORT
						if not skip_scraping then
							biome_appends[biomescript] = biome_appends[biomescript] or {}
							biome_appends[biomescript][map_scene_index] = biome_appends[biomescript][map_scene_index] or {scenes = {}, entities = {}}
							local biome_scene_index = biome_appends[biomescript][map_scene_index]
							if elem.attr.just_load_an_entity then
								biome_scene_index.entities[chunk_key] = biome_scene_index.entities[chunk_key] or {}
								biome_scene_index.entities[chunk_key][#biome_scene_index.entities[chunk_key] + 1] = {
									path = elem.attr.just_load_an_entity,
									offset_x = elem.attr.pos_x - (chunk_pos_x * 512),
									offset_y = elem.attr.pos_y - (chunk_pos_y * 512),
								}
							else
								biome_scene_index.scenes[chunk_key] = biome_scene_index.scenes[chunk_key] or {}
								biome_scene_index.scenes[chunk_key][#biome_scene_index.scenes[chunk_key] + 1] = {
									materials = elem.attr.material_filename,
									gfx = elem.attr.colors_filename,
									background = elem.attr.background_filename,
									offset_x = elem.attr.pos_x - (chunk_pos_x * 512),
									offset_y = elem.attr.pos_y - (chunk_pos_y * 512),
								}
							end
						end
					else
						remove_list.scenes[#remove_list.scenes+1] = elem
					end
				end
			end
		end

		for target, remove in pairs(remove_list) do
			for _, scene in ipairs(remove) do
				ps_data[target]:remove_child(scene) --remove spliced pixel scenes from file
			end
		end
		ModTextFileSetContent(pixel_scenes_path, tostring(pixel_scenes_xml)) --apply changes to file
	end
	--#endregion


	--Compiler
	--#region
	for script_path, biome in pairs(biome_appends) do
		local table_insert = ""
		for map_index, chunk_index in pairs(biome) do
			table_insert = table_insert .. "	[\"" .. map_index .. "\"] = {\n		scenes = {\n"
			for key, chunk in pairs(chunk_index.scenes) do
				table_insert = table_insert .. "			[\"".. key .."\"] = {\n"
				for _, scene in ipairs(chunk) do
					log(scene.materials)
					if scene.materials == "" then scene.materials = "mods/parallel_parity/files/nil_materials.png" end
					table_insert = table_insert .. ([[				{
						materials = "%s",
						gfx = "%s",
						background = "%s",
						offset_x = "%s",
						offset_y = "%s",
					},
	]]):format(scene.materials, scene.gfx, scene.background, scene.offset_x, scene.offset_y)
				end
				table_insert = table_insert .. "			},\n"
			end
			table_insert = table_insert .. "		},\n"

			table_insert = table_insert .. "		entities = {\n"
			for key, chunk in pairs(chunk_index.entities) do
				--do break end
				table_insert = table_insert .. "			[\"".. key .."\"] = {\n"
				for _, entity in ipairs(chunk) do
					table_insert = table_insert .. ([[				{
						path = "%s",
						offset_x = "%s",
						offset_y = "%s",
					},
	]]):format(entity.path, entity.offset_x, entity.offset_y)
				end
				table_insert = table_insert .. "			},\n"
			end
			table_insert = table_insert .. "		},\n	},\n"
		end
		local append_path = "mods/parallel_parity/generated/biome_appends/" .. script_path
		ModTextFileSetContent(append_path, ModTextFileGetContent("mods/parallel_parity/files/template_append.lua"):modify("--PARALLEL APPEND HERE!", table_insert):modify("FILENAMEHERE", script_path))
		ModLuaFileAppend(script_path, append_path)

		local script = ModTextFileGetContent(script_path)
		if not script:find("--RSF DOCUMENTED") then ModTextFileSetContent(script_path, ModTextFileGetContent("mods/parallel_parity/files/rsf_script_prepend.lua") .. script) end
	end
	--#endregion
end