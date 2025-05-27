dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/lib/mod_settings.lua")

local mod_id = "parallel_parity"
mod_settings_version = 1

local function get_setting_id(name)
    return mod_id .. "." .. name
end

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


--To add translations, add them below the same way English (en) languages have been added.
--Translation Keys can be seen in the languages table above
local translation_strings = {
    general = {
        en = "General",
        en_desc = "Miscellaneous grouping of pixel scenes that don't fit any other category or earn their own"
    },
    visuals = {
        en = "Visuals",
        en_desc = "Mostly cleans up visual pixel-scenes and backgrounds that are not meaningfully gameplay-altering\nThe criteria for this group is decided at my own discretion"
    },
    spliced_pixel_scenes = {
        en = "Spliced Pixel Scenes",
        en_desc = "Pixel Scenes that are larger than a single chunk (512x512 area)\nExcept when they're not. Blame Nolla",
        lava_lake = {
            en = "Lava Lake",
            en_desc = "The large Lava Lake to the right of Mines, this includes the bottom of the pit underneath",
            ORB = {
                en = "Spawn Orb",
                en_desc = "Should the Lava Lake Orb spawns in Parallel Worlds"
            }
        },
        desert_skull = {
            en = "Desert Skull",
            en_desc = "The giant deer skull located in the Desert",
        },
        kolmi_arena = {
            en = "Kolmisilmä Arena",
            en_desc = "The final boss arena after the Temple of the Art including the Holy Mountain just before it",
            KOLMI = {
                en = "Spawn Kolmisilmä",
                en_desc = "Should the final boss spawns in Parallel Worlds\nThis is highly advised against, I do not know the rammifications of spawning more than one finaly boss, but I can't imagine they would be good."
            },
        },
        tree = {
            en = "Tree",
            en_desc = "The large tree to the left of the player spawn",
            GREED = {
                en = "Curse of Greed",
                en_desc = "Should Curse of Greed spawns in Parallel Worlds"
            },
        },
        dark_cave = {
            en = "Dark Cave",
            en_desc = "The flooded cavern to the left of Mines",
            HP = {
                en = "HP Pickups",
                en_desc = "Should the HP pickups spawn in Parallel Worlds",
            },
        },
        mountain_lake = {
            en = "Mountain Lake",
            en_desc = "The lake between the mountain and the desert, on the surface above the Lava Lake",
        },
        lake_island = {
            en = "Lake Island",
            en_desc = "The island that spawns on top of the lake",
            FIRE_ESSENCE = {
                en = "Fire Essence",
                en_desc = "Should the Fire Essence under the statue spawn in Parallel Worlds",
            },
            BOSS = {
                en = "Tapion vasalli",
                en_desc = "Should the Lake Island Boss spawn in Parallel Worlds",
            },
        },
        moons = {
            en = "Moons",
            en_desc = "The moons located in The Work (Sky) and The Work (Hell)",
        },
        gourd_room = {
            en = "Gourd Room",
            en_desc = "The Gourd Room in the left EDR wall in The Work (Sky)",
            GOURDS = {
                en = "Spawn Gourds",
                en_desc = "Should Gourds from The Gourd Room(tm) spawn in Parallel Worlds",
            }
        },
        meat_skull = {
            en = "Limatoukka Skull",
            en_desc = "The giant skull that spawns Tiny at the bottom of the desert cavern under Powerplant/Meat Lair",
        },
    },
    other_pixel_scenes = {
        en = "Other Pixel Scenes",
        en_desc = "Regular Pixel Scene stuff",
        hidden = {
            en = "Hidden",
            en_desc = "Refers to background messages hidden throughout the world",
        },
        fungal_altars = {
            en = "Fungal Altars",
            en_desc = "Refers to Fungal Altars and related objects",
        },
        fishing_hut = {
            en = "Fishing Hut",
            en_desc = "Refers to the Fishing Hut on the right of the Lake",
            BUNKERS = {
                en = "Bunkers",
                en_desc = "Refers to the underwater Bunkers located under the Fishing Hut"
            }
        },
        pyramid_boss = {
            en = "Kolmisilmän koipi",
            en_desc = "Refers to the Boss located in the Pyramid",
        },
        leviathan = {
            en = "Syväolento",
            en_desc = "Refers to the Leviathan of the Lake",
        },
        avarice_diamond = {
            en = "Avarice Diamond",
            en_desc = "Refers to the diamond structure at the top of the Tower on the left",
        },
        essence_eaters = {
            en = "Essence Eaters",
            en_desc = "Refers to the Essence Eaters found in the Snowy Wastes and Desert",
        },
        music_machines = {
            en = "Music Machines",
            en_desc = "Refers to the Music Machines\n\nWarning! Spawn positions will be relative to Main World regardless of if other pixel scenes are also looped.\nMountain Lake machine will spawn in the ground, Tree machine will spawn very high up, etc",
        },
        evil_eye = {
            en = "Paha Silmä",
            en_desc = "Refers to the Evil Eye located to the left of the Tree",
        },
    }
}

local settings = {
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
        id = "spliced_pixel_scenes",
        type = "group",
        items = {
            {
                id = "lava_lake",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
                dependents = {
                    {
                        id = "ORB",
                        value_default = false,
                        requires = { id = "lava_lake", value = true },
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
                        requires = { id = "kolmi_arena", value = true },
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
                        requires = { id = "tree", value = true },
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
                        requires = { id = "dark_cave", value = true },
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
                        requires = { id = "lake_island", value = true },
                        scope = MOD_SETTING_SCOPE_NEW_GAME,
                    },
                    {
                        id = "BOSS",
                        value_default = false,
                        requires = { id = "lake_island", value = true },
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
                        requires = { id = "gourd_room", value = true },
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
        type = "group",
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
                        requires = { id = "fishing_hut", value = true },
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
        id = "Portals",
        items = {

        },
    }
}

function ModSettingsGuiCount()
    return 1
end

local function update_translations(input_settings, input_translations, path)
    path = path or ""
    input_settings = input_settings or settings
    input_translations = input_translations or translation_strings
    for key, setting in pairs(input_settings) do

        setting.path = mod_id .. "." .. path .. setting.id
        print(setting.path)

        if input_translations[setting.id] then
            setting.label = input_translations[setting.id][current_language] or input_translations[setting.id].en or setting.id
            print("label: " .. setting.label .. "\n")
            if input_translations[setting.id].en_desc and not input_translations[setting.id][current_language] then --if there is english translation but no other translation
                setting.description = input_translations[setting.id].en_desc .. string.format("\n(Missing %s translation)", GameTextGetTranslatedOrNot("$current_language"))
            else
                setting.description = input_translations[setting.id][current_language .. "_desc"] or nil
            end
            --print(tostring(setting.label) .. ": " .. tostring(setting.path))
        end

        if setting.items then
            update_translations(setting.items, input_translations[setting.id], path .. (not settings.items and (setting.id .. ".") or ""))
        elseif setting.dependents then
            update_translations(setting.dependents, input_translations[setting.id], path .. (not settings.items and (setting.id .. ".") or ""))
        end
    end
end

function ModSettingsUpdate(init_scope)
    current_language = languages[GameTextGetTranslatedOrNot("$current_language")]
    update_translations()

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
        if setting.type == "group" then
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
    for i, setting in ipairs(settings) do
        set_defaults(setting)
        save_setting(setting)
    end
    ModSettingSet(get_setting_id("_version"), mod_settings_version)
end

--mod settings code partially nabbed from Anvil of Destiny, thanks Horscht o/
function ModSettingsGui(gui, in_main_menu)
    local id = 0
    local function get_id()
        id = id + 1
        return id
    end

    local function RenderModSettingsGui(gui, in_main_menu, _settings, offset)
        offset = offset or 0
        _settings = _settings or settings

        local setting_offset = 0
        for i = 1, #_settings, 1 do
            local _len = GuiGetTextDimensions(gui, _settings[i].label or "", 1)
            _settings[i].length = _len
            if type(_settings[i].value_default == "boolean") and _len > setting_offset then
                setting_offset = _len
            end
        end

        for i, setting in ipairs(_settings) do
            offset = offset + (setting.offset or 0)
            if not setting.requires or (setting.requires and (ModSettingGet(get_setting_id(setting.requires.id)) == setting.requires.value)) then
                if setting.type == "group" then
                    GuiOptionsAddForNextWidget(gui, GUI_OPTION.DrawSemiTransparent)
                    GuiText(gui, offset, 0, setting.label)
                    if setting.description then
                        GuiTooltip(gui, setting.description, "")
                    end

                    RenderModSettingsGui(gui, in_main_menu, setting.items, offset + 15) --i think recursion just works here
                else
                    if type(setting.value_default) == "boolean" then
                        local value = ModSettingGet(setting.path)

                        GuiText(gui, offset, 0, "")
                        local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
                        local _, h = GuiGetTextDimensions(gui, setting.label)
                        --GuiOptionsAddForNextWidget(gui, GUI_OPTION.ForceFocusable)
                        GuiImageNinePiece(gui, get_id(), x, y, setting_offset + 5, h, 0)
                        local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

                        local clicked, rclicked, highlighted
                        if guiPrev[3] then
                            highlighted = true
                            if setting.description then
                                GuiTooltip(gui, setting.description, "")
                            end
                            if InputIsMouseButtonJustDown(1) then clicked = true end
                            if InputIsMouseButtonJustDown(2) then rclicked = true end
                        end


                        if highlighted then GuiColorSetForNextWidget(gui, 1, 1, 0.7 , 1) end
                        GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
                        GuiText(gui, offset, 0, setting.label)

                        if highlighted then GuiColorSetForNextWidget(gui, 1, 1, 0.7 , 1) end
                        GuiText(gui, offset + setting_offset + 1, 0, value == true and "(*)" or "(  )")

                        if clicked then
                            GamePlaySound("ui", "ui/button_click", 0, 0)
                            ModSettingSet(setting.path, not value)
                            --ModSettingSetNextValue(setting.path, not next_value, false)
                            --print(("Setting Check C\n  Name: %s\n  Path: [%s]\n  Applied Value: %s"):format(setting.label, setting.path, ModSettingGet(setting.path)))
                        end
                        if rclicked then
                            GamePlaySound("ui", "ui/button_click", 0, 0)
                            ModSettingSet(setting.path, not value)
                        end
                    elseif type(setting.value_default) == "number" then
                        local next_value = ModSettingGet(setting.path)
                        local new_value = GuiSlider(gui, get_id(), offset, 0, setting.label .. " ", next_value, setting.value_min, setting.value_max, setting.value_default, setting.value_display_multiplier or 1, setting.value_display_formatting or " $0", 80)
                        if new_value ~= next_value then
                            ModSettingSet(setting.path, not next_value)
                        end
                    end

                    if setting.dependents then
                        print("Rendering children: "..setting.id)
                        RenderModSettingsGui(gui, in_main_menu, setting.dependents, offset + 15)
                    end
                end
            end
        end
    end

    RenderModSettingsGui(gui, in_main_menu)
end