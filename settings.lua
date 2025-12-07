dofile_once("data/scripts/lib/mod_settings.lua")

---@

local mod_id = "parallel_parity"
mod_settings_version = 1

local function get_setting_id(name)
	return mod_id .. "." .. name
end

local is_ingame = #ModGetActiveModIDs() > 0

local languages = { --translation keys
	["English"] = "en",
	["русский"] = "ru",
	["Português (Brasil)"] = "ptbr",
	["Español"] = "eses",
	["Deutsch"] = "de",
	["Français"] = "frfr",
	["Italiano"] = "it",
	["Polska"] = "pl",
	["简体中文"] = "zhcn",
	["日本語"] = "jp",
	["한국어"] = "ko",
}

local current_language = languages[GameTextGetTranslatedOrNot("$current_language")]

--global table so mods can add their own settings
ParallelParity_Settings = {
	custom_setting_types = {}
}
local ps = ParallelParity_Settings

--To add translations, add them below the same way English (en) languages have been added.
--Translation Keys can be seen in the `languages` table above
ps.translation_strings = {
	mod_ingame_warning = {
		en = "Warning! Options for other mods will not show up here!",
		en_desc = "Due to fundamental limitations with the Modding API, mods cannot interact with one another until the game begins.\nPlease enter a run if you wish to see settings related to other mods\nNOTE:\nTHIS MOD IS VERY NEW AND THUS DOES NOT CURRENTLY HAVE MANY MOD COMPATIBILITY OPTIONS",
	},
	general = {
		en = "General",
		en_desc = "Miscellaneous grouping of pixel scenes that don't fit any other category or earn their own",
		ptbr = "Geral",
		ptbr_desc = "Grupo diverso de \"cenas de pixels\" que não se encaixam em qualquer outra categoria ou que não ganham sua propria categoria",
	},
	visuals = {
		en = "Visuals",
		en_desc = "Mostly cleans up visual pixel-scenes and backgrounds that are not meaningfully gameplay-altering\nThe criteria for this group is decided at my own discretion",
		ptbr = "Visuais",
		ptbr_desc = "Dá uma limpeza em cenas de pixels visuais e backgrounds que não alteram significamente a jogabilidade\nOs critérios para este grupo são definidos a meu critério",
	},
	return_rifts = {
		en = "Return Rifts",
		en_desc = "When a Portal teleports Minä back to the main world, spawns a rift that allows them to return",
	},
	ng_plus = {
		en = "New Game+",
		en_desc = "Should changes also apply to New Game+ iterations\nWarning! This feature is incomplete and is thus somewhat experimental, but should be functional!",
	},
	mods = {
		en = "Mods",
		en_desc = "Content added by various mods",
		mod_compat_restart = {
			en = "Restart to apply settings!",
			en_desc = "It is highly recommended you restart your game to apply compatibility settings changes!\nSorry about the inconvenience, mod settings are inherently limited and things like this are necessary for this to work :(",
		},
		no_mods_detected = {
			en = "No mod settings found!",
			en_desc = "Sorgy, nothing here",
		},
	},
	spliced_pixel_scenes = {
		en = "Spliced Pixel Scenes",
		en_desc = "Pixel Scenes that are larger than a single chunk (512x512 area)\nExcept when they're not. Blame Nolla.",
		ptbr = "Cenas de Pixels Emendadas",
		ptbr_desc = "Cenas de Pixels que são maiores que um único chunk (área de 512x512)\nExceto quando não são. Culpa da Nolla.",
		lava_lake = {
			en = "Lava Lake",
			en_desc = "The large Lava Lake to the right of Mines. This includes the bottom of the pit underneath",
			ptbr = "Lago de Lava",
			ptbr_desc = "O grande Lago de Lava à direita das Minas. Isso inclui o buraco embaixo dele",
			ORB = {
				en = "Spawn Orb",
				en_desc = "Should the Lava Lake Orb spawn in Parallel Worlds",
				ptbr = "Gerar Orbe",
				ptbr_desc = "O Orbe do Lago de Lava deve aparecer em Mundos Paralelos?",
			}
		},
		desert_skull = {
			en = "Desert Skull",
			en_desc = "The giant deer skull located in the Desert",
			ptbr = "Crânio do Deserto",
			ptbr_desc = "O gigante crânio de veado localizada no Deserto",
		},
		kolmi_arena = {
			en = "Kolmisilmä Arena",
			en_desc = "The final boss arena after the Temple of the Art including the Holy Mountain just before it",
			ptbr = "Arena de Kolmisilmä",
			ptbr_desc = "A arena do chefão final após o Templo da Arte, incluindo a Montanha Sagrada antes dela",
			KOLMI = {
				en = "Spawn Kolmisilmä",
				en_desc = "Should the final boss spawn in Parallel Worlds\nThis is highly advised against, I do not know the ramifications of spawning more than one final boss.",
				ptbr = "Gerar Kolmisilmä",
				ptbr_desc = "O chefão final deve aparecer em Mundos Paralelos?\nÉ altamente desaconcelhável habilitar esta opção, eu não sei quais são as ramificações de gerar mais de um chefão final.",
			},
		},
		tree = {
			en = "Tree",
			en_desc = "The large tree to the left of the player spawn",
			ptbr = "Árvore",
			ptbr_desc = "A grande árvore à esquerda da área inicial",
			GREED = {
				en = "Curse of Greed",
				en_desc = "Should Curse of Greed spawn in Parallel Worlds",
				ptbr = "Maldição da Ganância",
				ptbr_desc = "A Maldição da Ganância deve aparecer em Mundos Parelelos?",
			},
		},
		dark_cave = {
			en = "Dark Cave",
			en_desc = "The flooded cavern to the left of Mines",
			ptbr = "Caverna Escura",
			ptbr_desc = "A caverna inundada à esquerda das Minas",
			HP = {
				en = "HP Pickups",
				en_desc = "Should the HP pickups spawn in Parallel Worlds",
				ptbr = "PV Máximo Extras",
				ptbr_desc = "Os PV Máximo Extras devem aparecers em Mundos Paralelos?",
			},
		},
		mountain_lake = {
			en = "Mountain Lake",
			en_desc = "The lake between the mountain and the desert, on the surface above the Lava Lake",
			ptbr = "Lago da Montanha",
			ptbr_desc = "O lago entre a montanha e o deserto, na superfície, acima do Lago de Lava",
		},
		lake_island = {
			en = "Lake Island",
			en_desc = "The island that spawns on top of the lake",
			ptbr = "Ilha do Lago",
			ptbr_desc = "A ilha que aparece acima do Lago",
			FIRE_ESSENCE = {
				en = "Fire Essence",
				en_desc = "Should the Fire Essence under the statue spawn in Parallel Worlds",
				ptbr = "Essência do Fogo",
				ptbr_desc = "A Essência do Fogo deve aparecer embaixo da estátua em Mundos Parelelos?",
			},
			BOSS = {
				en = "Tapion vasalli",
				en_desc = "Should the Lake Island Boss spawn in Parallel Worlds",
				ptbr = "Tapion vasalli",
				ptbr_desc = "O chefão da Ilha do Lago deve aparecer em Mundos Paralelos?",
			},
		},
		moons = {
			en = "Moons",
			en_desc = "The moons located in The Work (Sky) and The Work (Hell)",
			ptbr = "Luas",
			ptbr_desc = "As luas localizadas em Obra (Céu) e Obra (Inferno)",
		},
		gourd_room = {
			en = "Gourd Room",
			en_desc = "The Gourd Room in the left Extremely Dense Rock wall in Cloudscape",
			ptbr = "Sala das Cabaças",
			ptbr_desc = "A Sala das Cabaças na parede de rocha extremamente densa à esquerda da Núbigena",
			GOURDS = {
				en = "Spawn Gourds",
				en_desc = "Should Gourds from The Gourd Room(tm) spawn in Parallel Worlds",
				ptbr = "Gerar Cabaças",
				ptbr_desc = "As Cabaças da Sala das Cabaças(tm) devem aparecer em Mundos Paralelos?",
			}
		},
		meat_skull = {
			en = "Limatoukka Skull",
			en_desc = "The giant skull that spawns Tiny at the bottom of the desert cavern under Powerplant/Meat Lair",
			ptbr = "Crânio de Limatoukka",
			ptbr_desc = "O crânio gigante que faz Limatoukka aparecer no fundo da caverna do deserto, embaixo da Usina/Reino da Carne",
		},
	},
	other_pixel_scenes = {
		en = "Other Pixel Scenes",
		en_desc = "Regular Pixel Scene stuff",
		ptbr = "Outras Cenas de Pixels",
		ptbr_desc = "Coisas comuns de Cenas de Pixels",
		hidden = {
			en = "Hidden",
			en_desc = "The background messages hidden throughout the world",
			ptbr = "Escondidas",
			ptbr_desc = "As mensagens escondidas por todo o mundo",
		},
		fungal_altars = {
			en = "Fungal Altars",
			en_desc = "The Fungal Altars and related objects",
			ptbr = "Altares Fúngicos",
			ptbr_desc = "Os Altares Fúngicos e objetos relacionados a eles",
		},
		fishing_hut = {
			en = "Fishing Hut",
			en_desc = "The Fishing Hut on the right of the Lake",
			ptbr = "Cabana de Pesca",
			ptbr_desc = "A Cabana de Pesca à direita do Lago",
			BUNKERS = {
				en = "Bunkers",
				en_desc = "The Underwater Bunkers located under the Fishing Hut",
				ptbr = "Bunkers",
				ptbr_desc = "Os Bunkers Subaquáticos localizados embaixo da Cabana de Pesca",
			}
		},
		pyramid_boss = {
			en = "Kolmisilmän koipi",
			en_desc = "The Boss located in the Pyramid",
			ptbr = "Kolmisilmän koipi",
			ptbr_desc = "O chefão localizado na Pirâmide",
		},
		leviathan = {
			en = "Syväolento",
			en_desc = "The Leviathan of the Lake",
			ptbr = "Syväolento",
			ptbr_desc = "O Leviatã do Lago",
		},
		avarice_diamond = {
			en = "Avarice Diamond",
			en_desc = "The diamond structure at the top of the Tower on the left",
			ptbr = "Diamante da Avareza",
			ptbr_desc = "A estrutura em formato de diamante no topo da Torre, à esquerda",
		},
		essence_eaters = {
			en = "Essence Eaters",
			en_desc = "The Essence Eaters found in the Snowy Wastes and Desert",
			ptbr = "Papa-essências",
			ptbr_desc = "Os Papa-essências encontrados no Ermo Nevado e no Deserto",
		},
		music_machines = {
			en = "Music Machines",
			en_desc = "The Music Machines\n\nWarning! Spawn positions will be relative to Main World regardless if other pixel scenes are also looped.\nMountain Lake machine will spawn in the ground, Tree machine will spawn very high up, etc.",
			ptbr = "Máquinas de Música",
			ptbr_desc = "As Máquinas de Música\n\nAviso! As posições de spawn serão relativas ao Mundo Principal independetemente de outras cenas de pixels serem repetidas.\nA máquina do Lago da Montanha irá aparecer dentro do chão, a máquina da Árvore irá aparecer bem no alto, etc.",
		},
		evil_eye = {
			en = "Paha Silmä",
			en_desc = "The Evil Eye located to the left of the Tree",
			ptbr = "Paha Silmä",
			ptbr_desc = "O Olho do Mau localizado à esquerda da Árvore",
		},
	},
	portals = {
		en = "Parallel Portals",
		en_desc = "Controls whether portals keep you in your current world or send you back to the Main World",
		ptbr = "Portais Paralelos",
		ptbr_desc = "Controla se os portais mantêm você no mundo atual ou o enviam de volta ao Mundo Principal",
		general = {
			en = "General",
			en_desc = "General portals that don't fall under the other categories",
			ptbr = "Geral",
			ptbr_desc = "Portais que não se enquadram nas outras categorias",
		},
		holy_mountain = {
			en = "Holy Mountain",
			en_desc = "The \"Portal Deeper\" that leads into Holy Mountain\nFinal Portal will likely dump you into lava if Kolmisilmä Arena is disabled",
			ptbr = "Montanha Sagrada",
			ptbr_desc = "O \"Portal para as profundezas\" que leva à Montanha Sagrada\nO Portal Final provavelmente jogará você na lava se a Arena de Kolmisilmä estiver desativada",
		},
		fast_travel = {
			en = "To Portal Room",
			en_desc = "The portal leading to the fast travel room created by Syväolento (Leviathan)\n(Fast Travel portals are already Parallel-World Local)",
			ptbr = "Sala dos Portais", --@Absent Friend i made a mistake about the fast travel room! please correct translations here o/
			ptbr_desc = "A sala de portais de viagem rápida, bem como o portal que leva a ela, criado por Syväolento (Leviatã)",
		},
		tower_entrance = {
			en = "Tower Entrance",
			en_desc = "Does not include Tower Exit, which is part of Return Portal",
			ptbr = "Entrada da Torre",
			ptbr_desc = "Não inclui Saída da Torre, que faz parte do Portal de Retorno",
		},
		mountain = {
			en = "Return Portal",
			en_desc = "Portal leading to the mountain\nThis includes the one summoned by the Musical Curiosity and the Tower Exit",
			ptbr = "Portal de Retorno",
			ptbr_desc = "O portal que leva à Montanha\nIsso inclui os que são invocados pela Curiosidade Musical e a Saída da Torre",
		},
		skull_island = {
			en = "Desert-Lake Portals",
			en_desc = "The Desert Skull and Island Statue portals",
			ptbr = "Portais Deserto-Lago",
			ptbr_desc = "Os portais do Crânio do Deserto e da Estátua da Ilha",
		},
		summon = {
			en = "Egg of Technology",
			en_desc = "The portals for the Egg of Technology where the End of Everything spell can be found\nThis also does additional modifications to the jungle biome to make the statues and portal spot work\nin Parallel Worlds",
			ptbr = "Ovo da Tecnologia",
			ptbr_desc = "Os portais para o Ovo da Tecnologia onde o feitiço \"O fim de tudo\" pode ser encontrado\nIsso também faz modificações adicionais ao bioma \"Selva Subterrânea\" para fazer\nas estátuas e o portal funcionarem em Mundos Paralelos",
		},
	},
	reset = {
		en = "[Reset]",
		en_desc = "Resets all settings to default values",
	}
}

--Brazilian Portuguese translations by Absent Friend


ps.mod_compat_settings = {
	{
		id = "mod_compat_restart",
		type = "note",
	},
}

--translations are separated for translators' convenience
ps.settings = {
	{
		id = "mod_ingame_warning",
		type = "note",
		render_condition = not is_ingame,
		c = {
			r = .9,
			g = .65,
			b = .65,
		},
		icon = "data/ui_gfx/inventory/icon_warning.png",
		icon_offset_x = -3,
		icon_offset_y = -3,
		text_offset_x = -3,
	},
	{
		id = "general",
		value_default = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "visuals",
		value_default = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "return_rifts",
		value_default = false,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "ng_plus",
		value_default = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "mods",
		not_path = true,
		type = "group",
		items = ps.mod_compat_settings,
		render_condition = is_ingame,
		collapsed = false,
	},
	{
		id = "spliced_pixel_scenes",
		not_path = true,
		type = "group",
		collapsed = is_ingame,
		items = {
			{
				id = "lava_lake",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "ORB",
						value_default = false,
						requires = { id = "parallel_parity.lava_lake", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "desert_skull",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "kolmi_arena",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "KOLMI",
						value_default = false,
						requires = { id = "parallel_parity.kolmi_arena", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "tree",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "GREED",
						value_default = false,
						requires = { id = "parallel_parity.tree", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "dark_cave",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "HP",
						value_default = true,
						requires = { id = "parallel_parity.dark_cave", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "mountain_lake",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "lake_island",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "FIRE_ESSENCE",
						value_default = true,
						requires = { id = "parallel_parity.lake_island", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
					{
						id = "BOSS",
						value_default = false,
						requires = { id = "parallel_parity.lake_island", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "moons",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "gourd_room",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "GOURDS",
						value_default = true,
						requires = { id = "parallel_parity.gourd_room", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "meat_skull",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
	{
		id = "other_pixel_scenes",
		not_path = true,
		type = "group",
		collapsed = is_ingame,
		items = {
			{
				id = "hidden",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "fungal_altars",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "fishing_hut",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "BUNKERS",
						value_default = true,
						requires = { id = "parallel_parity.fishing_hut", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "pyramid_boss",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "leviathan",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "avarice_diamond",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "essence_eaters",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "music_machines",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "evil_eye",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
	{
		id = "portals",
		type = "group",
		collapsed = is_ingame,
		items = {
			{
				id = "general",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "holy_mountain",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "fast_travel",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "tower_entrance",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "mountain",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "skull_island",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "summon",
				value_default = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
	{
		id = "reset",
		type = "reset_button",
	},
}



-- some of this code is p nasty tbh, flee all ye of weak heart 'n' all, may rewrite this entirely in the future

function ModSettingsGuiCount()
	return 1
end

function ModSettingsUpdate(init_scope)
	current_language = languages[GameTextGetTranslatedOrNot("$current_language")]

	if is_ingame then
		if #ps.mod_compat_settings == 1 then
			table.insert(ps.mod_compat_settings, {
				id = "no_mods_detected",
				type = "note",
				c = {
					r = .5,
					g = .65,
					b = .9,
				}
			})
		end

		local function add_modded_translation(setting, translation_path)
			if setting.translations then
				translation_path[setting.id] = setting.translations
			else
				translation_path[setting.id] = translation_path[setting.id] or {}
			end

			if setting.items then
				for _, item in ipairs(setting.items) do
					add_modded_translation(item, translation_path[setting.id])
				end
			end
			if setting.dependents then
				for _, dependent in ipairs(setting.dependents) do
					add_modded_translation(dependent, translation_path[setting.id])
				end
			end
		end

		for _, mod_group in ipairs(ps.mod_compat_settings) do
			if mod_group.type == "group" and not mod_group.c then
				mod_group.c = {
					r = .2,
					g = .6,
					b = .2,
				}
			end
			add_modded_translation(mod_group, ps.translation_strings.mods)
		end
	end

	local dummy_gui = GuiCreate()
	local function update_translations(input_settings, input_translations, path, recursion)
		recursion = recursion or 0
		path = path or ""
		input_settings = input_settings or ps.settings
		input_translations = input_translations or ps.translation_strings
		for key, setting in pairs(input_settings) do

			setting.path = mod_id .. "." .. path .. setting.id
			setting.type = setting.type or type(setting.value_default)
			setting.text_offset_x = setting.text_offset_x or 0

			if input_translations[setting.id] then
				setting.name = input_translations[setting.id][current_language] or input_translations[setting.id].en or setting.id
				if input_translations[setting.id].en_desc and not input_translations[setting.id][current_language] then --if there is english translation but no other translation
					setting.description = input_translations[setting.id].en_desc .. string.format("\n(Missing %s translation)", GameTextGetTranslatedOrNot("$current_language"))
				else
					setting.description = input_translations[setting.id][current_language .. "_desc"]
				end
			else
				setting.name = setting.id
			end

			if setting.description then
				setting._description_lines = {}
				for line in string.gmatch(setting.description, '([^\n]+)') do
					setting._description_lines[#setting._description_lines+1] = line
				end
			end


			setting.w,setting.h = GuiGetTextDimensions(dummy_gui, setting.name or "")
			setting.desc_w,setting.desc_h = GuiGetTextDimensions(dummy_gui, setting.description or "")
			if setting.icon then setting.icon_w,setting.icon_h = GuiGetImageDimensions(dummy_gui, setting.icon) end

			if setting.items then
				update_translations(setting.items, input_translations[setting.id], path .. (not setting.not_path and (setting.id .. ".") or ""), recursion + 1)
			elseif setting.dependents then
				update_translations(setting.dependents, input_translations[setting.id], path .. (not setting.not_path and (setting.id .. ".") or ""), recursion + 1)
			end
		end
	end
	update_translations()
	GuiDestroy(dummy_gui)

	local function set_defaults(setting)
		if setting.type == "group" then
			for i, item in ipairs(setting.items) do
				set_defaults(item)
			end
		else
			if setting.value_default ~= nil and ModSettingGet(setting.path) == nil then
				ModSettingSet(setting.path, setting.value_default)
			end
			if setting.dependents then
				set_defaults(setting.dependents)
				for i, item in ipairs(setting.dependents) do
					set_defaults(item)
				end
			end
		end
	end
	local function save_setting(setting)
		if setting.items == "group" then
			for i, item in ipairs(setting.items) do
				save_setting(item)
			end
		elseif setting.id ~= nil and setting.scope ~= nil and setting.scope >= init_scope then
			local next_value = ModSettingGetNextValue(setting.path)
			if next_value ~= nil then
				ModSettingSet(setting.path, next_value)
			end
			if setting.dependents then
				for i, item in ipairs(setting.dependents) do
					save_setting(item)
				end
			end
		end
	end
	for i, setting in ipairs(ps.settings) do
		set_defaults(setting)
		save_setting(setting)
	end
	ModSettingSet(get_setting_id("_version"), mod_settings_version)
end


local function reset_settings_to_default(group)
	for _, setting in ipairs(group) do
		if setting.value_default ~= nil then
			ModSettingSet(setting.path, setting.value_default)
		end

		if setting.items then
			reset_settings_to_default(setting.items)
		end
		if setting.dependents then
			reset_settings_to_default(setting.dependents)
		end
	end
end

----Rendering:
local max_id = 0
local function create_id()
	max_id = max_id + 1
	return max_id
end

---Draws a tooltip at desired position
---@param gui gui
---@param setting table pass entire setting rather than raw text to take advantage of prebaked description string size
---@param x number
---@param y number
---@param sprite string? custom 9piece sprite
local function DrawTooltip(gui, setting, x, y, sprite)
	local text_size = {setting.desc_w, setting.desc_h}
	sprite = sprite or "data/ui_gfx/decorations/9piece0_gray.png"
	GuiLayoutBeginLayer(gui)
	GuiZSetForNextWidget(gui, -200)
	GuiImageNinePiece(gui, create_id(), x, y, text_size[1]+10, text_size[2]+2, 1, sprite)
	for i,line in ipairs(setting._description_lines) do
		GuiZSetForNextWidget(gui, -210)
		GuiText(gui, x + 5, y + 1 + (i-1)*13, line)
	end --GuiText doesnt work by itself ig, newlines put next on the same line for some reason? idk.
	GuiLayoutEndLayer(gui)
end

---Create boolean setting
---@param gui gui
---@param x_offset number indentation as a result of child settings
---@param setting table setting data
---@param c number[] colour data
local function BoolSetting(gui, x_offset, setting, c)
	c = c or {
		r = 1,
		g = 1,
		b = 1,
	}
	local is_disabled
	if setting.requires and not ModSettingGet(setting.requires.id) == setting.requires.value then
		is_disabled = true
	end

	local value = ModSettingGet(setting.path)

	GuiText(gui, x_offset, 0, "")
	local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
	GuiImageNinePiece(gui, create_id(), x, y, 19+setting.w, setting.h, 0)
	local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

	local clicked, rclicked, highlighted
	if guiPrev[3] then
		highlighted = true
		if InputIsMouseButtonJustDown(1) then clicked = true end
		if InputIsMouseButtonJustDown(2) then rclicked = true end
		if (clicked or rclicked) and is_disabled then
			GamePlaySound("ui", "ui/button_denied", 0, 0)
			clicked = false
			rclicked = false
		end
		c = {
			r = 1,
			g = 1,
			b = .7,
		}
	end

	if is_disabled then --dim if disabled
		c = {
			r = c.r * .5,
			g = c.g * .5,
			b = c.b * .5,
		}
	end


	GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
	GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
	GuiText(gui, x_offset + 19, 0, setting.name)

	if highlighted and setting.description then DrawTooltip(gui, setting, x, y+12) end
	GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)

	local toggle_icon = ""
	if is_disabled then toggle_icon = "(X)"
	else toggle_icon = value == true and "(*)" or "(  )" end
	GuiText(gui, x_offset, 0, toggle_icon)

	if clicked then
		GamePlaySound("ui", "ui/button_click", 0, 0)
		ModSettingSet(setting.path, not value)
		print(setting.path)
	end
	if rclicked then
		GamePlaySound("ui", "ui/button_click", 0, 0)
		ModSettingSet(setting.path, setting.value_default)
	end
end

--mod settings code partially nabbed from Anvil of Destiny, thanks Horscht o/
function ModSettingsGui(gui, in_main_menu)

	local function RenderModSettingsGui(gui, in_main_menu, _settings, offset, parent_is_disabled, recursion)
		recursion = recursion or 0
		offset = offset or 0
		_settings = _settings or ps.settings



		for _, setting in ipairs(_settings) do
			if setting.render_condition ~= false then
				local setting_is_disabled = parent_is_disabled or (setting.requires and not ModSettingGet(setting.requires.id) == setting.requires.value)
				if setting.type == "group" then
					local c = setting.c and {
						r = setting.c.r,
						g = setting.c.g,
						b = setting.c.b,
					} or {
						r = .4,
						g = .4,
						b = .75,
					}

					local collapse_icon
					if setting.collapsed then
						collapse_icon = "data/ui_gfx/button_fold_open.png"
					else
						collapse_icon = "data/ui_gfx/button_fold_close.png"
					end
					if setting_is_disabled then
						c.r = c.r * .5
						c.g = c.g * .5
						c.b = c.b * .5
					end

					GuiText(gui, offset, 0, "")
					local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)

					--GuiOptionsAddForNextWidget(gui, GUI_OPTION.ForceFocusable)
					GuiImageNinePiece(gui, create_id(), x, y, setting.w, setting.h, 0)
					if ({GuiGetPreviousWidgetInfo(gui)})[3] then --check if element was clicked
						c.r = math.min((c.r * 1.2)+.05, 1)
						c.g = math.min((c.g * 1.2)+.05, 1)
						c.b = math.min((c.b * 1.2)+.05, 1)
						if InputIsMouseButtonJustDown(1) then
							GamePlaySound("ui", "ui/button_click", 0, 0)
							setting.collapsed = not setting.collapsed
						end
					end

					GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiImage(gui, create_id(), offset, 0, collapse_icon, 1, 1, 1)


					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, offset+10, 0, setting.name)
					if setting.description then
						GuiTooltip(gui, setting.description, "")
					end

					--i think recursion just works here
					if setting.collapsed ~= true then RenderModSettingsGui(gui, in_main_menu, setting.items, offset + 15, setting_is_disabled, recursion) end
				elseif setting.type == "boolean" then
					BoolSetting(gui, offset, setting, {
						r = .7^recursion,
						g = .7^recursion,
						b = .7^recursion,
					})

				elseif setting.type == "note" then
					local c = setting.c and {
						r = setting.c.r,
						g = setting.c.g,
						b = setting.c.b,
					} or {
						r = .7,
						g = .7,
						b = .7,
					}

					GuiText(gui, offset, 0, "")
					local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)

					--GuiOptionsAddForNextWidget(gui, GUI_OPTION.ForceFocusable)
					GuiImageNinePiece(gui, create_id(), x, y, setting.w+(setting.icon_w or 0)+(setting.text_offset_x or 0), setting.h, 0)
					local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

					if guiPrev[3] and setting.description then
						c.r = math.min((c.r * 1.2)+.05, 1)
						c.g = math.min((c.g * 1.2)+.05, 1)
						c.b = math.min((c.b * 1.2)+.05, 1)
						DrawTooltip(gui, setting, x, y+12)
					end

					if setting.icon then
						GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
						GuiImage(gui, create_id(), (setting.icon_offset_x or 0) + offset, setting.icon_offset_y or 0, setting.icon, 1, 1, 1)
					end
					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, (setting.icon_w or 0) + setting.text_offset_x + offset, 0, setting.name)
				elseif setting.type == "reset_button" then
					GuiText(gui, 0, 0, "")
					local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
					GuiImageNinePiece(gui, create_id(), x, y, setting.w, setting.h, 0)
					local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

					local c = {
						r = 1,
						g = 1,
						b = 1,
					}
					if guiPrev[3] then
						c.g = .7
						c.b = .7
						GuiTooltip(gui, setting.description, "")
						if InputIsMouseButtonJustUp(1) then
							GamePlaySound("ui", "ui/button_click", 0, 0)
							reset_settings_to_default(ps.settings)
						end
					end

					--GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, (setting.icon_w or 0) + setting.text_offset_x, 0, setting.name)
				elseif ps.custom_setting_types[setting.type] then
					ps.custom_setting_types[setting.type](gui, offset, setting)
				end

				if setting.dependents then
					RenderModSettingsGui(gui, in_main_menu, setting.dependents, offset + 15, setting_is_disabled, recursion + 1)
				end
			end
		end
	end

	RenderModSettingsGui(gui, in_main_menu)
end