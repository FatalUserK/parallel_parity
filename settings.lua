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
    spliced_pixel_scenes = {
        en = "Spliced Pixel Scenes",
        en_desc = "Pixel Scenes that are larger than a single chunk (512x512 area)",
        lavalake2 = {
            en = "Lava Lake",
            en_desc = "Should the Lava Lake to the East of Mines generate in Parallel Worlds",
            ORB = {
                en = "Spawn Orb",
                en_desc = "Dictates whether or not the Lava Lake orb spawns in Parallel Worlds"
            }
        },
        skull_in_desert = {
            en = "Desert Skull",
        },
        boss_arena = {
            en = "Kolmisilmä Arena",
        },
        tree = {
            en = "Tree",
        },
        watercave = {
            en = "Dark Cave",
        },
        mountain_lake = {
            en = "Mountain Lake",
        },
        lake_statue = {
            en = "Lake Island",
        },
        moons = {
            en = "Moons",
        },
        lavalake_pit_bottom = {
            en = "Pit Bottom",
        },
        gourd_room = {
            en = "Gourd Room",
        },
        skull = {
            en = "Limatoukka Skull",
        },
    },
}

local path_ignore = {
    spliced_pixel_scenes = true
}

local settings = {
    {
        id = "spliced_pixel_scenes",
        type = "group",
        items = {
            {
                id = "lavalake2",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
                dependents = {
                    {
                        id = "ORB",
                        value_default = false,
                        requires = { id = "lavalake2", value = true },
                        scope = MOD_SETTING_SCOPE_NEW_GAME,
                    },
                }
            },
            {
                id = "skull_in_desert",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "boss_arena",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "tree",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "watercave",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "mountain_lake",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "lake_statue",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "moons",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "lavalake_pit_bottom",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "gourd_room",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "skull",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
        },
    },
    {
        id = "Other Pixel Scenes",
        items = {

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

        if input_translations[setting.id] then
            setting.label = input_translations[setting.id][current_language] or input_translations[setting.id].en or setting.id
            if input_translations[setting.id].en_desc and not input_translations[setting.id][current_language] then --if there is english translation but no other translation
                setting.description = input_translations[setting.id].en_desc .. string.format("\n(Missing %s translation)", GameTextGetTranslatedOrNot("$current_language"))
            else
                setting.description = input_translations[setting.id][current_language .. "_desc"] or nil
            end
            print(tostring(setting.label) .. ": " .. tostring(setting.path))
        end

        if setting.items then
            update_translations(setting.items, input_translations[setting.id], path .. (not path_ignore[setting.id] and (setting.id .. ".") or ""))
        elseif setting.dependents then
            update_translations(setting.dependents, input_translations[setting.id], path .. (not path_ignore[setting.id] and (setting.id .. ".") or ""))
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
            if setting.value_default ~= nil then
                ModSettingSetNextValue(setting.path, setting.value_default, true)
                print(("Setting Check A\n  Name: %s\n  Path: [%s]\n  Applied Value: %s"):format(setting.label, setting.path, ModSettingGet(setting.path)))
            end
            if setting.dependents then
                for i, item in ipairs(setting.dependents) do
                    set_defaults(setting.dependents)
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
                print(("Setting Check B\n  Name: %s\n  Path: [%s]\n  Applied Value: %s"):format(setting.label, setting.path, ModSettingGet(setting.path)))
            end
            if setting.dependents then
                for i, item in ipairs(setting.dependents) do
                    save_setting(setting.dependents)
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
function ModSettingsGui( gui, in_main_menu, _settings, offset)
    offset = offset or 0
    _settings = _settings or settings
    local id = 0
    local function get_id()
        id = id + 1
        return id
    end

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
        if not setting.requires or (setting.requires and (ModSettingGetNextValue(get_setting_id(setting.requires.id)) == setting.requires.value)) then
            if setting.type == "group" then
                GuiOptionsAddForNextWidget(gui, GUI_OPTION.DrawSemiTransparent)
                GuiText(gui, offset, 0, setting.label)
                if setting.description then
                    GuiTooltip(gui, setting.description, "")
                end

                ModSettingsGui(gui, in_main_menu, setting.items, offset + 15) --i think recursion just works here
            else
                if type(setting.value_default) == "boolean" then
                    local next_value = ModSettingGetNextValue(setting.path)

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
                    GuiText(gui, offset + setting_offset + 1, 0, next_value == true and "(*)" or "(  )")

                    if clicked then
                        GamePlaySound("ui", "ui/button_click", 0, 0)
                        ModSettingSetNextValue(setting.path, not next_value, false)
                        print(("Setting Check C\n  Name: %s\n  Path: [%s]\n  Applied Value: %s"):format(setting.label, setting.path, ModSettingGet(setting.path)))
                    end
                    if rclicked then
                        GamePlaySound("ui", "ui/button_click", 0, 0)
                        ModSettingSetNextValue(setting.path, setting.value_default, false)
                        print(("Setting Check D\n  Name: %s\n  Path: [%s]\n  Applied Value: %s"):format(setting.label, setting.path, ModSettingGet(setting.path)))
                    end
                elseif type(setting.value_default) == "number" then
                    local next_value = ModSettingGetNextValue(setting.path)
                    local new_value = GuiSlider(gui, get_id(), offset, 0, setting.label .. " ", next_value, setting.value_min, setting.value_max, setting.value_default, setting.value_display_multiplier or 1, setting.value_display_formatting or " $0", 80)
                    if new_value ~= next_value then
                        ModSettingSetNextValue(setting.path, new_value, false)
                        print(("Setting Check E\n  Name: %s\n  Path: [%s]\n  Applied Value: %s"):format(setting.label, setting.path, ModSettingGet(setting.path)))
                    end
                end

                if setting.dependents then
                    ModSettingsGui(gui, in_main_menu, setting.dependents, offset + 10)
                end
            end
        end
    end
end