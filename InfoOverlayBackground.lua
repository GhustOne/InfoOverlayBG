--Made by GhostOne
--thanks to kektram for teaching me lua

if GhostsInfoOverlayBG == true then
	menu.notify("Script Already Loaded", "Ghost's InfoOverlayBG", 3, 255)
	return HANDLER_POP
end

--locals
local featTable = {}
local GfeatSettings = {
	BGon = true,
	floatx =  0.5,
	floaty = 0.5,
	floatwidth = 0.1,
	floatheight = 0.1,
	intr =  0,
	intg = 0,
	intb = 0,
	inta = 255,
	textSize = 0.2,
	textOffSetX = 0.0,
	textOffSetY = 0.0,
	intrTxt = 0,
	intgTxt = 255,
	intbTxt = 255,
	intaTxt = 255,
	fontTxt = 0,
	txtOutline = false,
	drawHeaderTxt = true,
	intrHeader = 255,
	intgHeader = 255,
	intbHeader = 255,
	intaHeader = 255,
	headerOffSetWidth = 0.0,
	headerOffSetHeight = 0.0,
	headerOffSetY = 0.0,
	headerOffSetX = 0.0,
	textInput = "header"
}
local path = utils.get_appdata_path("PopstarDevs", "").."\\2Take1Menu\\scripts\\"
local filename = "GhostsInfoOverlayBG.ini"

--functions
local function checkifpathexists()
	if not utils.file_exists(path..filename) then
		local file = io.open(path..filename, "w+")
		file:close()
	end
end
checkifpathexists()

local function saveSettings()
	checkifpathexists()
	local file = io.open(path..filename, "w+")
	if file then
		for feat, value in pairs(GfeatSettings) do
			file:write(feat..":"..tostring(value).."\n")
		end
		file:flush()
		file:close()
	end
	menu.notify("Saved Successfully", "Ghost's InfoOverlayBG", 3, 0x00ff00)
end

local function writefixOldSettings(table)
	local file = io.open(path..filename, "w+")
	local timer = utils.time_ms() + 1000
	while not file and timer > utils.time_ms() do
		system.wait(0)
	end
	if file then
		for i = 1, #table do
			file:write(table[i].."\n")
		end
	end
	file:flush()
	file:close()
end

local function fixOldSettings()
	if utils.file_exists(path..filename) then
		local file = io.open(path..filename, "r")
		local fixTable = {}
		if file then
			while true do
				str = file:read("*l")
				if str == nil then
					break
				end
				fixTable[#fixTable + 1] = str
			end
			if fixTable[9] then
				if fixTable[1]:match("^%d%.%d*") then
					fixTable[1] = "floatx:"..fixTable[1]
				end
				if fixTable[2]:match("^%d%.%d*") then
					fixTable[2] = "floaty:"..fixTable[2]
				end
				if fixTable[3]:match("^%d%.%d*") then
					fixTable[3] = "floatwidth:"..fixTable[3]
				end
				if fixTable[4]:match("^%d%.%d*") then
					fixTable[4] = "floatheight:"..fixTable[4]
				end
				if fixTable[5]:match("^%d") then
					fixTable[5] = "intr:"..fixTable[5]
				end
				if fixTable[6]:match("^%d") then
					fixTable[6] = "intg:"..fixTable[6]
				end
				if fixTable[7]:match("^%d") then
					fixTable[7] = "intb:"..fixTable[7]
				end
				if fixTable[8]:match("^%d") then
					fixTable[8] = "inta:"..fixTable[8]
				end
				if fixTable[9]:match("^%a*$") then
					fixTable[9] = "BGon:"..fixTable[9]
					menu.notify("old settings migrated successfully.", "Ghost's InfoOverlayBG", 3, 0x00ff00)
				end
			end
		end
		file:flush()
		file:close()
		writefixOldSettings(fixTable)
	end
end
fixOldSettings()

local function readSettings()
	checkifpathexists()
	local file = io.open(path..filename, "r")
	local timer = utils.time_ms() + 1000
	while not file and timer > utils.time_ms() do
		system.wait(0)
	end
	if file then
		for k, v in pairs(GfeatSettings) do
			str = file:read("*l")
			if str == nil then
				break
			end
			nameOfFeat, valueOfFeat = str:match("^(.*):(.*)$")
			if valueOfFeat then
				if type(GfeatSettings[nameOfFeat]) == "boolean" then
					if valueOfFeat == "true" then
						GfeatSettings[nameOfFeat] = true
					elseif valueOfFeat == "false" then
						GfeatSettings[nameOfFeat] = false
					end
				end
				if type(GfeatSettings[nameOfFeat]) == "number" then
					GfeatSettings[nameOfFeat] = tonumber(valueOfFeat)
				end
				if type(GfeatSettings[nameOfFeat]) == "string" then
					GfeatSettings[nameOfFeat] = valueOfFeat
				end
			end
		end
		file:flush()
		file:close()
	end
end
readSettings()

local gInfoBG = menu.add_feature("Ghost's Info Overlay BG", "parent", 0).id

--gInfoBG features
menu.add_feature("Save Settings", "action", gInfoBG, function()
	saveSettings()
end)

featTable.BGon = menu.add_feature("Background", "toggle", gInfoBG, function(f)
	GfeatSettings["BGon"] = f.on
	while f.on do
		local floatheightHeaderCal = featTable.floatheight.value * 0.6023809523809524
		local textSizeCal0 = featTable.textSize.value * 0.03
		local textSizeCal1 = featTable.textSize.value * 0.042
		ui.draw_rect(featTable.floatx.value, featTable.floaty.value, featTable.floatwidth.value, featTable.floatheight.value, featTable.intr.value, featTable.intg.value, featTable.intb.value, featTable.inta.value)
		if GfeatSettings["drawHeaderTxt"] == true then
			ui.draw_rect(featTable.floatx.value + featTable.headerOffSetX.value, featTable.floaty.value - floatheightHeaderCal + featTable.headerOffSetY.value, featTable.floatwidth.value + featTable.headerOffSetWidth.value, featTable.floatheight.value * 0.2 + featTable.headerOffSetHeight.value, featTable.intrHeader.value, featTable.intgHeader.value, featTable.intbHeader.value, featTable.intaHeader.value)
			ui.set_text_scale(featTable.textSize.value)
			ui.set_text_color(GfeatSettings["intrTxt"], GfeatSettings["intgTxt"], GfeatSettings["intbTxt"], GfeatSettings["intaTxt"])
			ui.set_text_right_justify(false)
			ui.set_text_outline(GfeatSettings["txtOutline"])
			ui.set_text_font(GfeatSettings["fontTxt"])
			ui.draw_text(GfeatSettings["textInput"], v2(featTable.floatx.value + featTable.textOffSetX.value, featTable.floaty.value - floatheightHeaderCal - textSizeCal1 + featTable.textOffSetY.value))
		end
		system.wait(0)
	end
	GfeatSettings["BGon"] = f.on
end)
featTable.BGon.on = GfeatSettings["BGon"]

--gHeader
local gHeader = menu.add_feature("Header", "parent", gInfoBG).id
local gHeaderText = menu.add_feature("Text", "parent", gHeader).id

featTable.floatx = menu.add_feature("X", "autoaction_value_f", gInfoBG, function(f)
	GfeatSettings["floatx"] = f.value
end)
featTable.floatx.min = 0
featTable.floatx.max = 1
featTable.floatx.mod = 0.01
featTable.floatx.value = GfeatSettings["floatx"]

featTable.floaty = menu.add_feature("Y", "autoaction_value_f", gInfoBG, function(f)
	GfeatSettings["floaty"] = f.value
end)
featTable.floaty.min = 0
featTable.floaty.max = 1
featTable.floaty.mod = 0.01
featTable.floaty.value = GfeatSettings["floaty"]

featTable.floatwidth = menu.add_feature("Width", "autoaction_value_f", gInfoBG, function(f)
	GfeatSettings["floatwidth"] = f.value
end)
featTable.floatwidth.min = 0
featTable.floatwidth.max = 1
featTable.floatwidth.mod = 0.01
featTable.floatwidth.value = GfeatSettings["floatwidth"]

featTable.floatheight = menu.add_feature("Height", "autoaction_value_f", gInfoBG, function(f)
	GfeatSettings["floatheight"] = f.value
end)
featTable.floatheight.min = 0
featTable.floatheight.max = 1
featTable.floatheight.mod = 0.01
featTable.floatheight.value = GfeatSettings["floatheight"]

featTable.intr = menu.add_feature("Red", "autoaction_value_i", gInfoBG, function(f)
	GfeatSettings["intr"] = f.value
end)
featTable.intr.min = 0
featTable.intr.max = 255
featTable.intr.mod = 5
featTable.intr.value = GfeatSettings["intr"]

featTable.intg = menu.add_feature("Green", "autoaction_value_i", gInfoBG, function(f)
	GfeatSettings["intg"] = f.value
end)
featTable.intg.min = 0
featTable.intg.max = 255
featTable.intg.mod = 5
featTable.intg.value = GfeatSettings["intg"]

featTable.intb = menu.add_feature("Blue", "autoaction_value_i", gInfoBG, function(f)
	GfeatSettings["intb"] = f.value
end)
featTable.intb.min = 0
featTable.intb.max = 255
featTable.intb.mod = 5
featTable.intb.value = GfeatSettings["intb"]

featTable.inta = menu.add_feature("Alpha", "autoaction_value_i", gInfoBG, function(f)
	GfeatSettings["inta"] = f.value
end)
featTable.inta.min = 0
featTable.inta.max = 255
featTable.inta.mod = 5
featTable.inta.value = GfeatSettings["inta"]

--gHeaderText features
menu.add_feature("Header text", "action", gHeaderText, function(f)
	inputStatus, GfeatSettings["textInput"] = input.get("Header Text", "", 128, 0)
	while inputStatus == 1 do
		inputStatus, GfeatSettings["textInput"] = input.get("Header Text", "", 128, 0)
		system.wait(0)
	end
end)

featTable.textSize = menu.add_feature("Header text size", "autoaction_value_f", gHeaderText, function(f)
	GfeatSettings["textSize"] = f.value
end)
featTable.textSize.min = 0
featTable.textSize.max = 2
featTable.textSize.mod = 0.01
featTable.textSize.value = GfeatSettings["textSize"]

featTable.textOffSetX = menu.add_feature("Header text offset X", "autoaction_value_f", gHeaderText, function(f)
	GfeatSettings["textOffSetX"] = f.value
end)
featTable.textOffSetX.min = -1
featTable.textOffSetX.max = 1
featTable.textOffSetX.mod = 0.0025
featTable.textOffSetX.value = GfeatSettings["textOffSetX"]

featTable.textOffSetY = menu.add_feature("Header text offset Y", "autoaction_value_f", gHeaderText, function(f)
	GfeatSettings["textOffSetY"] = f.value
end)
featTable.textOffSetY.min = -1
featTable.textOffSetY.max = 1
featTable.textOffSetY.mod = 0.0025
featTable.textOffSetY.value = GfeatSettings["textOffSetY"]

featTable.intrTxt = menu.add_feature("Text Red", "autoaction_value_i", gHeaderText, function(f)
	GfeatSettings["intrTxt"] = f.value
end)
featTable.intrTxt.min = 0
featTable.intrTxt.max = 255
featTable.intrTxt.mod = 5
featTable.intrTxt.value = GfeatSettings["intrTxt"]

featTable.intgTxt = menu.add_feature("Text Green", "autoaction_value_i", gHeaderText, function(f)
	GfeatSettings["intgTxt"] = f.value
end)
featTable.intgTxt.min = 0
featTable.intgTxt.max = 255
featTable.intgTxt.mod = 5
featTable.intgTxt.value = GfeatSettings["intgTxt"]

featTable.intbTxt = menu.add_feature("Text Blue", "autoaction_value_i", gHeaderText, function(f)
	GfeatSettings["intbTxt"] = f.value
end)
featTable.intbTxt.min = 0
featTable.intbTxt.max = 255
featTable.intbTxt.mod = 5
featTable.intbTxt.value = GfeatSettings["intbTxt"]

featTable.intaTxt = menu.add_feature("Text Alpha", "autoaction_value_i", gHeaderText, function(f)
	GfeatSettings["intaTxt"] = f.value
end)
featTable.intaTxt.min = 0
featTable.intaTxt.max = 255
featTable.intaTxt.mod = 5
featTable.intaTxt.value = GfeatSettings["intaTxt"]

featTable.fontTxt = menu.add_feature("Font", "autoaction_value_i", gHeaderText, function(f)
	GfeatSettings["fontTxt"] = f.value
end)
featTable.fontTxt.min = 0
featTable.fontTxt.max = 8
featTable.fontTxt.mod = 1
featTable.fontTxt.value = GfeatSettings["fontTxt"]

featTable.txtOutline = menu.add_feature("Outline", "toggle", gHeaderText, function(f)
	GfeatSettings["txtOutline"] = f.on
end)
featTable.txtOutline.on = GfeatSettings["txtOutline"]
--end of text settings

--gHeader features
featTable.intrHeader = menu.add_feature("Header Red", "autoaction_value_i", gHeader, function(f)
	GfeatSettings["intrHeader"] = f.value
end)
featTable.intrHeader.min = 0
featTable.intrHeader.max = 255
featTable.intrHeader.mod = 5
featTable.intrHeader.value = GfeatSettings["intrHeader"]

featTable.intgHeader = menu.add_feature("Header Green", "autoaction_value_i", gHeader, function(f)
	GfeatSettings["intgHeader"] = f.value
end)
featTable.intgHeader.min = 0
featTable.intgHeader.max = 255
featTable.intgHeader.mod = 5
featTable.intgHeader.value = GfeatSettings["intgHeader"]

featTable.intbHeader = menu.add_feature("Header Blue", "autoaction_value_i", gHeader, function(f)
	GfeatSettings["intbHeader"] = f.value
end)
featTable.intbHeader.min = 0
featTable.intbHeader.max = 255
featTable.intbHeader.mod = 5
featTable.intbHeader.value = GfeatSettings["intbHeader"]

featTable.intaHeader = menu.add_feature("Header Alpha", "autoaction_value_i", gHeader, function(f)
	GfeatSettings["intaHeader"] = f.value
end)
featTable.intaHeader.min = 0
featTable.intaHeader.max = 255
featTable.intaHeader.mod = 5
featTable.intaHeader.value = GfeatSettings["intaHeader"]

featTable.headerOffSetX = menu.add_feature("Header offset X", "autoaction_value_f", gHeader, function(f)
	GfeatSettings["headerOffSetX"] = f.value
end)
featTable.headerOffSetX.min = -1
featTable.headerOffSetX.max = 1
featTable.headerOffSetX.mod = 0.0025
featTable.headerOffSetX.value = GfeatSettings["headerOffSetX"]

featTable.headerOffSetY = menu.add_feature("Header offset Y", "autoaction_value_f", gHeader, function(f)
	GfeatSettings["headerOffSetY"] = f.value
end)
featTable.headerOffSetY.min = -1
featTable.headerOffSetY.max = 1
featTable.headerOffSetY.mod = 0.0025
featTable.headerOffSetY.value = GfeatSettings["headerOffSetY"]

featTable.headerOffSetWidth = menu.add_feature("Header width offset", "autoaction_value_f", gHeader, function(f)
	GfeatSettings["headerOffSetWidth"] = f.value
end)
featTable.headerOffSetWidth.min = -0.5
featTable.headerOffSetWidth.max = 1
featTable.headerOffSetWidth.mod = 0.005
featTable.headerOffSetWidth.value = GfeatSettings["headerOffSetWidth"]

featTable.headerOffSetHeight = menu.add_feature("Header height offset", "autoaction_value_f", gHeader, function(f)
	GfeatSettings["headerOffSetHeight"] = f.value
end)
featTable.headerOffSetHeight.min = -0.5
featTable.headerOffSetHeight.max = 1
featTable.headerOffSetHeight.mod = 0.005
featTable.headerOffSetHeight.value = GfeatSettings["headerOffSetHeight"]

featTable.drawHeaderTxt = menu.add_feature("Draw Header and Text", "toggle", gHeader, function(f)
	GfeatSettings["drawHeaderTxt"] = f.on
end)
featTable.drawHeaderTxt.on = GfeatSettings["drawHeaderTxt"]
--end of header settings


GhostsInfoOverlayBG = true
menu.notify("Loaded Successfully", "Ghost's InfoOverlayBG", 2, 0x00ff00)