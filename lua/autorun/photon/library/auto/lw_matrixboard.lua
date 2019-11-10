AddCSLuaFile()

local rows = 6
local cols = 39

local letterCoords = {}
letterCoords.A = {{1, 7}, {1, 6}, {1, 5}, {1, 4}, {1, 3}, {1, 2}, {2, 1}, {2, 5}, {3, 1}, {3, 5}, {4, 2}, {4, 3}, {4, 4}, {4, 5}, {4, 6}, {4, 7}}
letterCoords.B = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 1}, {2, 4}, {2, 7}, {3, 1}, {3, 4}, {3, 7}, {4, 2}, {4, 3}, {4, 5}, {4, 6}}
letterCoords.C = {{1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {2, 1}, {2, 7}, {3, 1}, {3, 7}, {4, 2}, {4, 6}}
letterCoords.D = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 1}, {2, 7}, {3, 1}, {3, 7}, {4, 2}, {4, 3}, {4, 4}, {4, 5}, {4, 6}}
letterCoords.E = {{1, 1}, {2, 1}, {3, 1}, {1, 2}, {1, 3}, {1, 4}, {2, 4}, {3, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 7}, {3, 7}}
letterCoords.F = {{1, 1}, {2, 1}, {3, 1}, {1, 2}, {1, 3}, {1, 4}, {2, 4}, {3, 4}, {1, 5}, {1, 6}, {1, 7}}
letterCoords.G = {{1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {2, 1}, {2, 7}, {3, 1}, {3, 7}, {4, 2}, {4, 6}, {4, 5}, {4, 4}, {3, 4}}
letterCoords.H = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 4}, {3, 1}, {3, 2}, {3, 3}, {3, 4}, {3, 5}, {3, 6}, {3, 7}}
letterCoords.I = {{1, 1}, {2, 1}, {3, 1}, {2, 2}, {2, 3}, {2, 4}, {2, 5}, {2, 6}, {2, 7}, {1, 7}, {3, 7}}
letterCoords.J = {{1, 8 - 3}, {1, 8 - 2}, {2, 8 - 1}, {3, 8 - 2}, {3, 8 - 3}, {3, 8 - 4}, {3, 8 - 5}, {3, 8 - 6}, {3, 8 - 7}, {2, 8 - 7}, {4, 8 - 7}}
letterCoords.K = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 3}, {2, 5}, {3, 2}, {3, 6}, {4, 1}, {4, 7}}
letterCoords.L = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 7}, {3, 7}}
letterCoords.M = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 2}, {3, 3}, {4, 2}, {5, 1}, {5, 2}, {5, 3}, {5, 4}, {5, 5}, {5, 6}, {5, 7}}
letterCoords.N = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 3}, {3, 4}, {4, 5}, {5, 1}, {5, 2}, {5, 3}, {5, 4}, {5, 5}, {5, 6}, {5, 7}}
letterCoords.O = {{1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {2, 1}, {2, 7}, {3, 2}, {3, 3}, {3, 4}, {3, 5}, {3, 6}}
letterCoords.P = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 1}, {2, 4}, {3, 1}, {3, 2}, {3, 3}, {3, 4}}
letterCoords.Q = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {2, 1}, {2, 4}, {3, 1}, {3, 2}, {3, 3}, {3, 4}, {3, 5}, {3, 6}, {3, 7},}
letterCoords.R = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 1}, {2, 4}, {3, 1}, {3, 2}, {3, 3}, {3, 4}, {2, 5}, {3, 6}, {3, 7}}
letterCoords.S = {{1, 7}, {2, 7}, {3, 6}, {3, 5}, {2, 4}, {1, 3}, {1, 2}, {2, 1}, {3, 1}}
letterCoords.T = {{1, 1}, {2, 1}, {3, 1}, {2, 2}, {2, 3}, {2, 4}, {2, 5}, {2, 6}, {2, 7}}
letterCoords.U = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {1, 6}, {2, 7}, {3, 7}, {4, 1}, {4, 2}, {4, 3}, {4, 4}, {4, 5}, {4, 6}}
letterCoords.V = {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}, {2, 6}, {3, 7}, {4, 6}, {5, 5}, {5, 4}, {5, 3}, {5, 2}, {5, 1}}
letterCoords.W = {{1, 8 - 1}, {1, 8 - 2}, {1, 8 - 3}, {1, 8 - 4}, {1, 8 - 5}, {1, 8 - 6}, {1, 8 - 7}, {2, 8 - 2}, {3, 8 - 3}, {4, 8 - 2}, {5, 8 - 1}, {5, 8 - 2}, {5, 8 - 3}, {5, 8 - 4}, {5, 8 - 5}, {5, 8 - 6}, {5, 8 - 7}}
letterCoords.X = {{1, 1}, {1, 2}, {1, 7}, {1, 6}, {2, 3}, {2, 5}, {3, 4}, {4, 3}, {4, 5}, {5, 1}, {5, 2}, {5, 6}, {5, 7}}
letterCoords.Y = {{1, 1}, {3, 1}, {1, 2}, {3, 2}, {1, 3}, {3, 3}, {2, 4}, {2, 5}, {2, 6}, {2, 7}}
letterCoords.Z = {{1, 1}, {2, 1}, {3, 1}, {3, 2}, {3, 3}, {2, 4}, {1, 5}, {1, 6}, {1, 7}, {2, 7}, {3, 7}}
letterCoords["<"] = {{1, 4}, {2, 3}, {2, 4}, {2, 5}, {3, 2}, {3, 3}, {3, 4}, {3, 5}, {3, 6}, {4, 1}, {4, 2}, {4, 3}, {4, 4}, {4, 5}, {4, 6}, {4, 7}}
letterCoords[">"] = {{5 - 1, 4}, {5 - 2, 3}, {5 - 2, 4}, {5 - 2, 5}, {5 - 3, 2}, {5 - 3, 3}, {5 - 3, 4}, {5 - 3, 5}, {5 - 3, 6}, {5 - 4, 1}, {5 - 4, 2}, {5 - 4, 3}, {5 - 4, 4}, {5 - 4, 5}, {5 - 4, 6}, {5 - 4, 7}}
letterCoords["-"] = {{1, 3}, {1, 4}, {1, 5}}

local function letterToCoords(letter) return table.Copy(letterCoords[letter]) end
local function letterToGrid(letter, x)
	if letter == ' ' then return {width = 0} end
	if letter == '|' then return {width = 1} end

	if not x then x = 0 end
	local width = 0

	local nodes = letterToCoords(letter)
	if not nodes then return false end

	local out = {}
	for _, node in ipairs(nodes) do
		width = math.max(node[1], width)
		node[1] = node[1] + x
		node[2] = node[2] - 1
		if node[1] <= (cols + 1) and node[2] <= rows then
			table.insert(out, node)
		end
	end
	out.width = width

	return out
end
local function wordToGrid(word, x, gap)
	if not x then x = 0 end
	if not gap then gap = 1 end

	local coords = {}
	for i = 1, #word do
		local nodes = letterToGrid(word[i], x)
		if nodes then
			x = x + nodes.width + gap
			nodes.width = nil
			table.Add(coords, nodes)
		end
	end

	return coords
end

local A = "AMBER"
local function wordToSection(word, gap)
	local coords = wordToGrid(word, x, gap, max)
	for id, coord in ipairs(coords) do
		coords[id] = {(coord[2] * (cols + 1)) + coord[1], A}
	end

	return coords
end


local name = "LW Matrixboard"
local COMPONENT = {}
COMPONENT.Model = "models/lonewolfie/arrowboardmed.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.ColorInput = 0
COMPONENT.Category = "Interior"
COMPONENT.DefaultColors = {}

COMPONENT.Meta = {
	main = {
		AngleOffset = 90,
		W = 1.3,
		H = 0.7,
		Sprite = "sprites/emv/circular_src",
		Scale = 0.2,
	},
}

COMPONENT.Positions = {}
for row = 0, rows do
	for col = 0, cols do
		table.insert(COMPONENT.Positions, {Vector(1.315, -15 + (col * 0.928), 6.3 - (row * 0.53)), Angle(0, 90, 0), "main"})
	end
end

COMPONENT.Sections = {["auto_internet_arrowboardmed"] = {{}}}

for i = 1, #COMPONENT.Positions do
	COMPONENT.Sections.auto_internet_arrowboardmed[1][i] = {i, A}
end

COMPONENT.Sections.auto_internet_arrowboardmed[2] = wordToSection("KEEP  CLEAR")
COMPONENT.Sections.auto_internet_arrowboardmed[3] = wordToSection("            PASS")
COMPONENT.Sections.auto_internet_arrowboardmed[4] = wordToSection("<------||P|A|S|S||------>", 0)
for i = 0, 36 do
	COMPONENT.Sections.auto_internet_arrowboardmed[5 + i] = wordToSection(string.rep('-', i) .. ">", 0)
	COMPONENT.Sections.auto_internet_arrowboardmed[42 + i] = wordToSection(string.rep('|', 36 - i) .. "<" .. string.rep('-', i), 0)
end
COMPONENT.Sections.auto_internet_arrowboardmed[79] = wordToSection("       NO PASS")


COMPONENT.Patterns = {
	["auto_internet_arrowboardmed"] = {
		code1 = {2},
		code2 = {0},
		code3 = {0},
		alert = {0},
		right = {5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41},
		left = {42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78},
		diverge = {3,3,3,3,3,3,4,4,4,4,4,4},
		stop = {79}
	}
}

COMPONENT.Modes = {
	Primary = {
		M1 = {["auto_internet_arrowboardmed"] = "code1"},
		M2 = {["auto_internet_arrowboardmed"] = "code2"},
		M3 = {["auto_internet_arrowboardmed"] = "code3"},
	},
	Auxiliary = {
		L = {["auto_internet_arrowboardmed"] = "left"},
		R = {["auto_internet_arrowboardmed"] = "right"},
		D = {["auto_internet_arrowboardmed"] = "diverge"},
		S = {["auto_internet_arrowboardmed"] = "stop"},
	},
	Illumination = {}
}

EMVU:AddAutoComponent(COMPONENT, name)