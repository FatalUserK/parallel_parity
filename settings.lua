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
            ["ORB.is_local"] = {
                en = "Spawn Orb",
                en_desc = "Dictates whether or not the Lava\nLake orb spawns in Parallel Worlds"
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
                        id = "ORB.is_local",
                        value_default = true,
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

local function update_translations(input_settings, input_translations)
    input_settings = input_settings or settings
    input_translations = input_translations or translation_strings
    for key, setting in pairs(input_settings) do
        if input_translations[setting.id] then
            setting.label = input_translations[setting.id][current_language] or input_translations[setting.id].en or setting.id
            if input_translations[setting.id].en_desc and not input_translations[setting.id][current_language] then --if there is english translation but no other translation
                setting.description = input_translations[setting.id].en_desc .. string.format("\n(Missing %s translation)", GameTextGetTranslatedOrNot("$current_language"))
            else
                setting.description = input_translations[setting.id][current_language .. "_desc"] or nil
            end
        end

        if setting.items then
            update_translations(setting.items, input_translations[setting.id])
        elseif setting.dependents then
            update_translations(setting.dependents, input_translations[setting.id])
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
                ModSettingSetNextValue(get_setting_id(setting.id), setting.value_default, true)
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
            local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
            if next_value ~= nil then
                ModSettingSet(get_setting_id(setting.id), next_value)
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


--mod settings code nabbed from Anvil of Destiny, thanks Horscht o/
function ModSettingsGui( gui, in_main_menu, _settings, offset)
    offset = offset or 0
    _settings = _settings or settings
    local id = 0
    local function get_id()
        id = id + 1
        return id
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
                    local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
                    local text = ("%s [%s]"):format(setting.label, next_value and "*" or "  ")
                    local clicked, right_clicked = GuiButton(gui, offset, 0, text, get_id())
                    if setting.description then
                        GuiTooltip(gui, setting.description, "")
                    end
                    if clicked then
                        ModSettingSetNextValue(get_setting_id(setting.id), not next_value, false)
                    end
                    if right_clicked then
                        ModSettingSetNextValue(get_setting_id(setting.id), setting.value_default, false)
                    end
                elseif type(setting.value_default) == "number" then
                    local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
                    local new_value = GuiSlider(gui, get_id(), offset, 0, setting.label .. " ", next_value, setting.value_min, setting.value_max, setting.value_default, setting.value_display_multiplier or 1, setting.value_display_formatting or " $0", 80)
                    if new_value ~= next_value then
                        ModSettingSetNextValue(get_setting_id(setting.id), new_value, false)
                    end
                end

                if setting.dependents then
                    ModSettingsGui(gui, in_main_menu, setting.dependents, offset + 10)
                end
            end
        end
    end
end