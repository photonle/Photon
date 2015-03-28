AddCSLuaFile()
EMV_DEBUG = false

local A = "AMBER"
local DA = "D_AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local SW = "S_WHITE"

local PI = {}

PI.Positions = {
	{ Vector(0,-114,51.3), Angle(0,0,-30), "brake_light" }, --  1

	{ Vector(-30.4,-112,46), Angle(0,-10,-20), "tail_light" }, --  4
	{ Vector(30.4,-112,46), Angle(0,10,-20), "tail_light" }, --  5

	{ Vector(-30.4,-112,46), Angle(0,-10,-20), "tail_light" }, --  4
	{ Vector(30.4,-112,46), Angle(0,10,-20), "tail_light" }, --  5

	{ Vector(-35.5,-109,43.2), Angle(0,-10,-20), "tail_light_s" }, --  6
	{ Vector(35.5,-109,43.2), Angle(0,10,-20), "tail_light_s" }, --  7

	{ Vector(-38.6,93.6,33.6), Angle(0,70,30), "front_side_l" }, --  8
	{ Vector(38.6,93.6,33.6), Angle(0,110,-30), "front_side_r" }, --  9

	{ Vector(-33.4,101,32.5), Angle(0,30,0), "head_low" }, --  10
	{ Vector(33.4,101,32.5), Angle(0,-30,0), "head_low" }, --  11

	{ Vector(-28,106,31.5), Angle(0,30,0), "head_high" }, --  12
	{ Vector(28,106,31.5), Angle(0,-30,0), "head_high" }, --  13

	{ Vector(-32,-114,40), Angle(0,-20,-15), "reverse" }, --  14
	{ Vector(32,-114,40), Angle(0,20,-15), "reverse" }, --  15

	{ Vector(-25.1,109.6,30.2), Angle(40,46,29), "front_turn" }, --  16
	{ Vector(25.1,109.6,30.2), Angle(-40,-46,29), "front_turn" }, --  17
}

PI.Meta = {
	brake_light = {
		AngleOffset = 90,
		W = 10,
		H = 6,
		Sprite = "sprites/emv/emv_whelen_src_side",
		Scale = 1,
		WMult = 3 -- width multiplier
	},
	tail_light = {
		AngleOffset = 90,
		W = 14,
		H = 14,
		Sprite = "sprites/emv/circular_src",
		Scale = 1,
	},
	tail_light_s = {
		AngleOffset = 90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/circular_src",
		Scale = .6,
	},
	front_side_r = {
		AngleOffset = -240,
		W = 3,
		H = 3.5,
		Sprite = "sprites/emv/impala_front_side",
		Scale = 1,
	},
	front_side_l = {
		AngleOffset = -115,
		W = 3,
		H = 3.5,
		Sprite = "sprites/emv/impala_front_side",
		Scale = 1,
	},
	head_low = {
		AngleOffset = -90,
		W = 12,
		H = 10,
		Sprite = "sprites/emv/circular_src",
		Scale = 1.25,
		VisRadius = 16,
	},
	head_high = {
		AngleOffset = -90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/circular_src",
		Scale = 2,
		VisRadius = 16,
	},
	reverse = {
		AngleOffset = 90,
		W = 12,
		H = 12,
		Sprite = "sprites/emv/impala_reverse",
		Scale = 1,
	},
	front_turn = {
		AngleOffset = -90,
		W = 3.4,
		H = 3,
		Sprite = "sprites/emv/light_circle",
		Scale = 1.8
	},
}

PI.States = {}

PI.States.Headlights = {}

PI.States.Brakes = {
	{1, DR, .75}, {2, DR, .75}, {3, DR, .75}
}

PI.States.Blink_Left = {
	{ 16, A }, { 4, DR, 2 }
}

PI.States.Blink_Right = {
	{ 17, A }, { 5, DR, 2 }
}

PI.States.Reverse = {
	{14, SW, 1}, {15, SW, 1},
}

PI.States.Running = {
	{4, DR, .25}, {5, DR, .25}, {6, DR, .1}, {7, DR, .1}, {8, A, .9}, {9, A, .9}, {10, SW, 1}, {11, SW, 1}, 
}

--Photon:OverwriteIndex("NYPD Impala", PI)
Photon.VehicleLibrary["lw_impala"] = PI
