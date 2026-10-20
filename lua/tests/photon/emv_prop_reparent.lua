-- Photon_SetupEMVProps skips definitions with no model (hideaways, wig-wags,
-- `true` placeholders) when it builds emv.EMVProps, but Photon_ScanEMVProps and
-- Photon_UpdateEMVProps read the definition list from EMVU.Helper:GetProps by
-- the prop's position in EMVProps. Every prop listed after a model-less entry
-- is then moved to a neighbouring definition's position.
--
-- The code lives in cl_emv_meta.lua, which only the client loads. Its methods
-- are installed on whatever EMVU:MakeEMV is handed, so the suite compiles the
-- file, hands it a table stand-in vehicle, stubs ClientsideModel (the engine
-- boundary) and EMVU.Helper:GetProps (the definition source), and reads back
-- what the stand-in props were told to do.

local MODEL = "models/props_junk/PopCan01a.mdl"

local propMethods = {}

function propMethods:IsValid() return true end
function propMethods:GetParent() return self.parent end

function propMethods:SetParent(parent, attachment)
	self.parent = parent
	self.attachment = attachment
end

function propMethods:SetPos(pos) self.pos = pos end
function propMethods:SetAngles(ang) self.ang = ang end
function propMethods:SetModelScale(scale) self.modelScale = scale end
function propMethods:EnableMatrix(_, mat) self.matrix = mat end

local propMeta = {
	__index = function(self, key)
		if propMethods[key] then return propMethods[key] end
		if not tostring(key):match("^%u") then return nil end
		return function() end
	end
}

local function NewProp()
	return setmetatable({}, propMeta)
end

-- An offset local-to-world transform, so a position that was never transformed
-- cannot match the expected literal.
local WORLD_OFFSET = Vector(100, 0, 0)
local ANGLE_OFFSET = Angle(0, 90, 0)

local attachments = { A_att = 7, B_att = 9 }

local function NewVehicle()
	local veh = {}
	function veh:IsValid() return true end
	function veh:IsVehicle() return true end
	function veh:IsEMV() return true end
	function veh:LocalToWorld(v) return v + WORLD_OFFSET end
	function veh:LocalToWorldAngles(a) return a + ANGLE_OFFSET end
	function veh:LookupAttachment(name) return attachments[name] or 0 end
	return veh
end

-- Compiles cl_emv_meta.lua on the server and returns the function that undoes
-- it. The file installs a global, hooks on the server's own events and replaces
-- EMVU.MakeEMV, none of which the server uses.
local function LoadClientMeta()
	local before = {}
	for event, hooks in pairs(hook.GetTable()) do
		before[event] = {}
		for name in pairs(hooks) do before[event][name] = true end
	end

	local saved = {
		MakeEMV = EMVU.MakeEMV,
		DebugInfo = EMVU.DebugInfo,
		Calculations = EMVU.Calculations,
		lightModels = _G.photonLightModels,
	}

	local chunk = CompileFile("autorun/photon/cl_emv_meta.lua")
	assert(chunk, "cl_emv_meta.lua did not compile")
	chunk()

	return function()
		for event, hooks in pairs(hook.GetTable()) do
			for name in pairs(hooks) do
				if not (before[event] and before[event][name]) then hook.Remove(event, name) end
			end
		end
		EMVU.MakeEMV = saved.MakeEMV
		EMVU.DebugInfo = saved.DebugInfo
		EMVU.Calculations = saved.Calculations
		_G.photonLightModels = saved.lightModels
	end
end

-- `stub` is passed in because GLuaTest injects it into each case's environment only.
-- Builds a vehicle whose definition list is `defs`, runs MakeEMV so
-- Photon_SetupEMVProps builds EMVProps, and returns the vehicle. The props are
-- then detached, as they are when the vehicle leaves and re-enters the PVS, and
-- their recorded state is cleared so only what the next call does is observed.
local function SpawnWithDefs(state, stub, defs)
	state.restoreMeta = LoadClientMeta()

	stub(_G, "ClientsideModel").with(function()
		return NewProp()
	end)
	stub(EMVU.Helper, "GetProps").returns(defs)
	stub(EMVU.Helper, "GetVectors").returns({})
	stub(EMVU.Helper, "GetPatterns").returns({})

	local veh = NewVehicle()
	EMVU:MakeEMV(veh, "gluatest_reparent")

	-- Photon_ELPresetOption and Photon_SelectionString are SimpleNet accessors;
	-- hold them steady so the scan reaches the re-parent step.
	veh.Photon_ELPresetOption = function() return 0 end
	veh.Photon_SelectionString = function() return "" end
	veh.LastPresetOption = 0
	veh.LastSelectionString = ""

	for _, prop in ipairs(veh.EMVProps) do
		prop.parent = false
		prop.pos, prop.ang, prop.attachment = false, false, false
		prop.matrix, prop.modelScale = false, false
	end
	return veh
end

local A_POS, A_ANG = Vector(10, 20, 30), Angle(1, 2, 3)
local B_POS, B_ANG = Vector(-40, -50, -60), Angle(4, 5, 6)
local C_POS, C_ANG = Vector(7, 8, 9), Angle(7, 8, 9)

-- The wig-wag / hideaway style entries: a definition with a position and no model.
local function ModelessAt(pos, ang) return { Pos = pos, Ang = ang } end

local function ExpectAt(expect, prop, pos, ang)
	expect(prop.pos).to.equal(pos + WORLD_OFFSET)
	expect(prop.ang).to.equal(ang + ANGLE_OFFSET)
end

return {
	groupName = "EMV prop re-parenting",

	beforeEach = function(state)
		state.hadDebug, state.hadExpress = rawget(_G, "PHOTON_DEBUG"), rawget(_G, "PHOTON_EXPRESS")
	end,

	afterEach = function(state)
		_G.PHOTON_DEBUG, _G.PHOTON_EXPRESS = state.hadDebug, state.hadExpress
		if state.restoreMeta then state.restoreMeta() end
	end,

	cases = {
		{
			name = "A re-parented prop returns to its own Pos and Ang when a model-less component is listed before it",
			func = function(state)
				local veh = SpawnWithDefs(state, stub, {
					ModelessAt(B_POS, B_ANG),
					{ Model = MODEL, Pos = A_POS, Ang = A_ANG },
				})
				expect(#veh.EMVProps).to.equal(1)

				veh:Photon_ScanEMVProps()

				ExpectAt(expect, veh.EMVProps[1], A_POS, A_ANG)
			end
		},
		{
			name = "A re-parented prop is attached to its own AttachmentMerge when a model-less component is listed before it",
			func = function(state)
				local veh = SpawnWithDefs(state, stub, {
					{ Pos = B_POS, Ang = B_ANG, AttachmentMerge = "B_att" },
					{ Model = MODEL, Pos = A_POS, Ang = A_ANG, AttachmentMerge = "A_att" },
				})

				veh:Photon_ScanEMVProps()

				expect(veh.EMVProps[1].attachment).to.equal(attachments.A_att)
			end
		},
		{
			name = "A placeholder component listed before a prop does not break its re-parenting",
			func = function(state)
				local veh = SpawnWithDefs(state, stub, {
					true,
					{ Model = MODEL, Pos = A_POS, Ang = A_ANG },
				})

				expect(function() veh:Photon_ScanEMVProps() end).to.succeed()
				ExpectAt(expect, veh.EMVProps[1], A_POS, A_ANG)
			end
		},
		{
			name = "Every prop returns to its own position when model-less components are interleaved between props",
			func = function(state)
				local veh = SpawnWithDefs(state, stub, {
					ModelessAt(Vector(1, 1, 1), Angle(1, 1, 1)),
					{ Model = MODEL, Pos = A_POS, Ang = A_ANG },
					true,
					ModelessAt(Vector(2, 2, 2), Angle(2, 2, 2)),
					{ Model = MODEL, Pos = B_POS, Ang = B_ANG },
					{ Model = MODEL, Pos = C_POS, Ang = C_ANG },
				})
				expect(#veh.EMVProps).to.equal(3)

				veh:Photon_ScanEMVProps()

				ExpectAt(expect, veh.EMVProps[1], A_POS, A_ANG)
				ExpectAt(expect, veh.EMVProps[2], B_POS, B_ANG)
				ExpectAt(expect, veh.EMVProps[3], C_POS, C_ANG)
			end
		},
		{
			name = "Under PHOTON_DEBUG a prop's scale comes from its own definition when a model-less component is listed before it",
			func = function(state)
				local veh = SpawnWithDefs(state, stub, {
					{ Pos = B_POS, Ang = B_ANG, Scale = 5 },
					{ Model = MODEL, Pos = A_POS, Ang = A_ANG, Scale = 3 },
				})
				_G.PHOTON_DEBUG = true

				veh:Photon_ScanEMVProps()

				expect(veh.EMVProps[1].modelScale).to.equal(3)
			end
		},
		{
			name = "Under PHOTON_EXPRESS a prop's vector scale comes from its own definition when a model-less component is listed before it",
			func = function(state)
				local veh = SpawnWithDefs(state, stub, {
					{ Pos = B_POS, Ang = B_ANG, Scale = Vector(5, 5, 5) },
					{ Model = MODEL, Pos = A_POS, Ang = A_ANG, Scale = Vector(2, 3, 4) },
				})
				_G.PHOTON_EXPRESS = true

				veh:Photon_ScanEMVProps()

				expect(veh.EMVProps[1].matrix:GetScale()).to.equal(Vector(2, 3, 4))
			end
		},
		{
			name = "Photon_UpdateEMVProps puts a prop at its own Pos and Ang when a model-less component is listed before it",
			func = function(state)
				local veh = SpawnWithDefs(state, stub, {
					ModelessAt(B_POS, B_ANG),
					{ Model = MODEL, Pos = A_POS, Ang = A_ANG },
				})

				veh:Photon_UpdateEMVProps()

				ExpectAt(expect, veh.EMVProps[1], A_POS, A_ANG)
			end
		},
		{
			name = "Regression guard: with no model-less components every prop returns to its own position and scale",
			func = function(state)
				local veh = SpawnWithDefs(state, stub, {
					{ Model = MODEL, Pos = A_POS, Ang = A_ANG, Scale = 3 },
					{ Model = MODEL, Pos = B_POS, Ang = B_ANG, Scale = 4 },
				})
				_G.PHOTON_DEBUG = true

				veh:Photon_ScanEMVProps()

				ExpectAt(expect, veh.EMVProps[1], A_POS, A_ANG)
				ExpectAt(expect, veh.EMVProps[2], B_POS, B_ANG)
				expect(veh.EMVProps[1].modelScale).to.equal(3)
				expect(veh.EMVProps[2].modelScale).to.equal(4)
			end
		},
	}
}
