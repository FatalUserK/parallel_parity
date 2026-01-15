local world_entity = GameGetWorldStateEntity()
local world_comp = EntityGetFirstComponentIncludingDisabled(GameGetWorldStateEntity(), "WorldStateComponent")
if world_comp then
	if ComponentGetValue2(world_comp, "mods_have_been_active_during_this_run") == true then
		EntityKill(GetUpdatedEntityID())
		return
	end --twitch_has_been_active_during_this_run
end

local year,month,day = GameGetDateAndTimeLocal()

--[[ spoof dates by uncommenting stuff at the bottom
local spoof_date = {
	year = 2025,
	month = 12,
	day = 15,
	hour = 7,
	minute = 49,
	second = 57,
	jussi = false,
	mammi = true,
}
TimeLocal = spoof_date --]]


-- fun fact, leap years are every 4 years UNLESS it is a century year that isnt divisble by 400 (so 2000 was a leap year, but 2100 wont be)
local is_leap_year
if year % 4 == 0 then
	if year % 100 == 0 then
		if year % 400 == 0 then
			is_leap_year = true
		else
			is_leap_year = false
		end
	else
		is_leap_year = true
	end
else
	is_leap_year = false
end

local month_lengths = {
	31,
	is_leap_year and 29 or 28,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31,
}

local day_of_year = 0
for i = 1, month - 1 do
	day_of_year = day_of_year + month_lengths[i]
end
day_of_year = day_of_year + day

local void_calendar = {
	normal = "11001111010011110010100101011001000011111100110011010111010001010110001101110101010101011001111000110010111011000101100011010100001000001110101110111111001101100000001111101110100011101001110000000101100110110101101110010001110110110101110000111111011111000010111000000001100001000011100000011111110000011110010111100110101001110100100111100010011111111010001001000",
	leap =   "11001111010011110010100101011000000111111001100110101110100001010110001101110101010101011011111000110010111011000101100011010100001000001110101110111110001101100000001111101110100011101001110000000101100110110101101110010001110110110101110000111111011111000010111000000001110001000011100000011111110000011110010111100110101001110100100",
}
local void_day
if is_leap_year then
	if day_of_year <= 335 then
		void_day = void_calendar.leap:sub(day_of_year, day_of_year)
	else
		void_day = tostring(Random(0,1))
	end
else
	void_day = void_calendar.normal:sub(day_of_year, day_of_year)
end

local cauldron_material = not (void_day == "0") and "void_liquid" or "air"
print(cauldron_material)

local x,y = EntityGetTransform(GetUpdatedEntityID())
LoadPixelScene("mods/parallel_parity/files/cauldron/materials.png",
	"mods/parallel_parity/files/cauldron/gfx.png",
	x, y,
	"mods/parallel_parity/files/cauldron/background.png",
	true, nil, {["FFFF0000"] = cauldron_material}, nil, true
)