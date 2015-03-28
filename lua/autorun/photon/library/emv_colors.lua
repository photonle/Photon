AddCSLuaFile()

EMVU.Colors = {
	BLUE = {
		src = Color( 255, 255, 255, 255 ),
		med = Color( 0, 225, 255, 245 ),
		glw = Color( 0, 0, 255, 255 ),
		blm = Color( 0, 0, 255, 50 ),
		amb = Color( 0, 0, 255, 5 ),
		flr = Color( 0, 8, 64, 255 ),
		dim = Color( 128, 225, 255, 255 ),
		raw = Color( 0, 0, 255, 255 ),
	},
	-- BLUE = {
	-- 	src = Color( 245, 255, 255, 255 ),
	-- 	med = Color( 0, 100, 255, 255 ),
	-- 	glw = Color( 0, 125, 255, 200 ),
	-- 	blm = Color( 0, 75, 255, 50 ),
	-- 	amb = Color( 0, 0, 255, 5 ),
	-- },
	RED = {
		src = Color( 255, 255, 240, 255 ),
		med = Color( 255, 190, 0, 220 ),
		glw = Color( 255, 24, 0, 120 ),
		blm = Color( 255, 10, 0, 70 ),
		amb = Color( 255, 0, 0, 5 ),
		flr = Color( 64, 8, 0, 255 ),
		dim = Color( 255, 128, 64, 255 ),
		raw = Color( 255, 0, 0, 255 )
	},
	D_RED = { -- dark red, designed to not appear as bright as its red brother, used primarily for brake and tail lights
		src = Color( 255, 128, 128, 255 ),
		med = Color( 255, 200, 0, 255 ),
		glw = Color( 255, 64, 0, 200 ),
		blm = Color( 255, 32, 0, 50 ),
		amb = Color( 255, 16, 0, 5 ),
		raw = Color( 255, 64, 0, 128 )
	},
	DODGE_RED = {
		src = Color( 0, 0, 0, 255 ),
		med = Color( 24, 0, 0, 255 ),
		glw = Color( 255, 96, 0, 100 ),
		blm = Color( 255, 32, 0, 0 ),
		amb = Color( 255, 16, 0, 1 ),
		raw = Color( 255, 64, 0, 128 )
	},
	AMBER = {
		src = Color( 255, 255, 255, 255 ),
		med = Color( 255, 255, 0, 200 ),
		glw = Color( 255, 128, 0, 128 ),
		blm = Color( 255, 255, 0, 10 ),
		amb = Color( 200, 255, 0, 2 ),
		flr = Color( 24, 24, 0, 255 ),
		dim = Color( 255, 245, 100, 255 ),
		raw = Color( 128, 64, 0, 255 )
	},
	D_AMBER = { -- dark amber, does not look good
		src = Color( 255, 255, 0, 255 ),
		med = Color( 0, 255, 0, 200 ),
		glw = Color( 0, 175, 0, 150 ),
		blm = Color( 0, 255, 0, 10 ),
		amb = Color( 200, 255, 0, 2 ),
	},
	GREEN = {
		src = Color( 255, 255, 255, 255 ),
		med = Color( 0, 255, 0, 200 ),
		glw = Color( 150, 255, 0, 150 ),
		blm = Color( 0, 255, 0, 10 ),
		amb = Color( 0, 255, 0, 2 ),
	},
	WHITE = { -- led
		src = Color( 200, 200, 255, 255 ),
		med = Color( 225, 225, 255, 255 ),
		glw = Color( 160, 160, 200, 48 ),
		blm = Color( 200, 255, 210, 5 ),
		amb = Color( 255, 255, 210, 2 ),
		flr = Color( 16, 16, 255, 255 ),
		raw = Color( 16, 128, 255, 128 ),
	},
	S_WHITE = { -- soft white (incandascent)
		src = Color( 255, 255, 255, 255 ),
		med = Color( 255, 255, 235, 255 ),
		glw = Color( 255, 215, 200, 64 ),
		blm = Color( 255, 255, 255, 5 ),
		amb = Color( 255, 255, 255, 1 ),
		flr = Color( 0, 64, 96, 255 ),
		dim = Color( 255, 255, 200, 255 ),
		raw = Color( 255, 255, 255, 1 ),
		raw = Color( 16, 200, 255, 128 ),
	},
	C_WHITE = { -- cool white (halogen)
		src = Color( 205, 225, 255, 255 ),
		med = Color( 200, 200, 255, 150 ),
		glw = Color( 180, 180, 255, 200 ),
		blm = Color( 160, 160, 255, 10 ),
		amb = Color( 128, 128, 255, 2 ),
		flr = Color( 0, 16, 255, 255 ),
		raw = Color( 0, 0, 255, 128 ),

	},
}