

To append setting simply do the following
```lua
---Your init.lua:
ModLuaFileAppend("mods/parallel_parity/settings.lua", "mods/modid/path/to/your/append.lua")


---append.lua
ParallelParity_Settings.translation_strings["modid_obliteration_altar"]

--for custom settings handling, add your own type like so:
ParallelParity_Settings.custom_setting_types["totally_bogus_setting"] = function(gui, offset, setting)
	--render shit
end
--let me know if you need access to any specific variables (though I can't imagine this hook will be overly used lmao)
```