
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/minus.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/0.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/1.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/2.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/3.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/4.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/5.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/6.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/7.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/8.png")
GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/9.png")

local gui = GuiCreate()
local function get_char_width(id)
    return GuiGetImageDimensions(gui, "mods/parallel_parity/files/pw_counter/"..id..".png")
end

local pw_chars = {
	["0"] = { get_char_width("0"), "mods/parallel_parity/files/pw_counter/0.png"},
	["1"] = { get_char_width("1"), "mods/parallel_parity/files/pw_counter/1.png"},
	["2"] = { get_char_width("2"), "mods/parallel_parity/files/pw_counter/2.png"},
	["3"] = { get_char_width("3"), "mods/parallel_parity/files/pw_counter/3.png"},
	["4"] = { get_char_width("4"), "mods/parallel_parity/files/pw_counter/4.png"},
	["5"] = { get_char_width("5"), "mods/parallel_parity/files/pw_counter/5.png"},
	["6"] = { get_char_width("6"), "mods/parallel_parity/files/pw_counter/6.png"},
	["7"] = { get_char_width("7"), "mods/parallel_parity/files/pw_counter/7.png"},
	["8"] = { get_char_width("8"), "mods/parallel_parity/files/pw_counter/8.png"},
	["9"] = { get_char_width("9"), "mods/parallel_parity/files/pw_counter/9.png"},
	["-"] = { get_char_width("minus"), "mods/parallel_parity/files/pw_counter/minus.png"},
	[","] = { get_char_width("comma"), "mods/parallel_parity/files/pw_counter/minus.png"},
	["θ"] = { get_char_width("theta"), "mods/parallel_parity/files/pw_counter/theta.png"},
	["("] = { get_char_width("open_bracket"), "mods/parallel_parity/files/pw_counter/open_bracket.png"},
	[")"] = { get_char_width("close_bracket"), "mods/parallel_parity/files/pw_counter/close_bracket.png"},
}

local function standard(x, y, mi_x, mi_y)
    print(x)
    print(y)
    print(mi_x)
    print(mi_y)
    local pwx,pwy = GetParallelWorldPosition(x, y)
    local pw_str = tostring(pwx)

	local pw_str_len = 0
	for char in string.gmatch(pw_str, ".") do
		local curr_char = pw_chars[char] or pw_chars["-"]
		pw_str_len = pw_str_len + curr_char[1]
	end
	local pw_str_x_origin = (pw_str_len * -.5) + mi_x + 9 --halve and make negative plus mi_x plus arbitrary offset
	local pw_str_x_offset = 0
	for char in string.gmatch(pw_str, ".") do
		local curr_char = pw_chars[char] or pw_chars["-"]
		GameCreateSpriteForXFrames(curr_char[2], pw_str_x_origin + pw_str_x_offset, mi_y - 92, true, 0, 0, 1, true )
		pw_str_x_offset = pw_str_x_offset + curr_char[1]
	end
end

local funcs = {
    default = standard

}

local coordinate_display = ModSettingGet("parallel_parity.vertical.pw_coordinate_display")
if coordinate_display == "none" then
    return standard
elseif coordinate_display == "grid" then
    return cartesian
else
    local angle_type = ModSettingGet("parallel_parity.vertical.pw_coordinate_display.angle_format")
end

return standard