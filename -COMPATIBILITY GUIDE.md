To append pixel scenes or portals, do the following:
```lua
----Your init.lua:
ModLuaFileAppend("mods/parallel_parity/data.lua", "mods/modid/path/to/your/append.lua")
```

and then
```lua
----append.lua
local par = Parallel_Parity --i recommend doing this just for readability and whatnot, allows you to use `par.` instead of `Parallel_Parity.` for everything

par.settings.mymodid = { --i would recommend creating your own space here to avoid name clashes
	big_pixel_scene = ModSettingGet("parallel_parity.mymodid.my_big_awesome_spliced_pixel_scene")
} --setting path will be parallel_parity.(your settings path by ID separated by '.')

--feel free to browse `mods/parallel_parity/data.lua` to see how i structure and connect the data used for the mod



-- you can add groups of pixel scenes like this
local my_pixel_scenes = {
	["mods/modid/path/to/your/pixel_scene_materials.png"] =	par.settings.general,
	["mods/modid/path/to/your/tree_addition.png"] =			par.settings.tree,
}
for key,value in pairs(my_pixel_scenes) do
	par.pixel_scenes[key] = value
end

--or add single ones like this
par.spliced_pixel_scenes["mods/modid/path/to/your/spliced/pixel_scene.xml"] = par.settings.mymodid.big_pixel_scene,
--here we also use the setting space we grabbed earlier (though you will need to append settings.lua for this to work!)


--portals put here will have their output destination localised to the current world
par.portals["mods/modid/path/to/your/portal.xml"] = par.settings.general


--there are localisation options that gsubs string code to make it only run in PWs, but the structure is kinda...
par.localise["data/scripts/biomes/lake_statue.lua"] = {
	par.settings.lake_island and not par.settings.island_boss and {
		[[EntityLoad( "data/entities/animals/boss_spirit/spawner.xml", x, y )]],
	} or nil,
	par.settings.lake_island and not par.settings.fire_essence and {
		[[EntityLoad( "data/entities/items/pickup/essence_fire.xml", x, y )]],
	} or nil,
},
--yeah its very messy, this is mostly to deal with vanilla code- i would suggest just writing in your own localisation code, but this is exposed in case you wish to use it anyway
```

To append settings simply do the following
```lua
---Your init.lua:
ModLuaFileAppend("mods/parallel_parity/settings.lua", "mods/modid/path/to/your/append.lua")


---append.lua
table.insert(ParallelParity_Settings.mod_compat_settings, {
	id = "mymodid",--this does not need to be a group, this can be just a top-level toggle or something 
	type = "group", --though please dont pollute by adding multiple top-level, just use "group" if you're going to have more than one setting
	translations = {
		en = "My Mod",
		ru = "i dont speak russian.",
	},
	items = {
		{
			id = "mod_stuff_note",
			type = "note",
			translations = {
				en = "Custom Pixel Scenes!",
				en_desc = "These are my custom pixel scenes!"
				--if you provide a description for the current language like this, a tooltip will be displayed, otherwise there will be no tooltip.
				--unless there is an english description, in which case it will display that and note that it is not translated into the current language
			},
		},
		{
			id = "my_big_awesome_spliced_pixel_scene",
			value_default = true, --if type is nil and default value is bool, it will assume its a boolean setting
			translations = {
				en = "Big Awesome Pixel Scene",
				en_desc = "Should my Big Awesome Spliced Pixel Scene spawn in Parallel Worlds?",
				ru = "i dont speak russian",
				ru_desc = "i still dont speak russian.",
			},
			c = {
				r = .2,
				g = .2,
				b = .9,
			}, --this controls the colour of the setting, this will make it blue
		},
	},
})

--take a look at `mods/parallel_parity/settins.lua` for a more in-depth understanding of values you can apply to customise settings
```
List of translation keys used in the file:
```lua
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
```

and for those who for some reason wish to do more in the settings menu, you can add custom settings data to run your own render functions like so:
```lua
ParallelParity_Settings.custom_setting_types["totally_bogus_setting"] = function(gui, offset, setting)
	--render shit
end
--let me know if you need access to any specific variables (though I can't imagine this hook will be overly used lmao)
```
