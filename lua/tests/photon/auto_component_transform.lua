-- Scale applied on spawn uses EnableMatrix. A lua refresh used to call
-- SetModelScale on the same entity without clearing that matrix, so saving a
-- vehicle file compounded the size. ApplyModelScale resets both transforms
-- first, so applying the same value twice must leave the model unchanged.
--
-- Sprite facing reads the stored Euler's .y (and then subtracts 90 from .r).
-- Matrix:GetAngles() can re-express the same rotation with a flipped yaw, which
-- is why ComposeAutoLightAngle stays in authored Euler space so a component
-- that has been pitched or rolled on a vehicle keeps its sprites with the model.

local function NewEnt()
	local ent = ents.Create("prop_physics")
	ent:SetModel("models/error.mdl")
	ent:Spawn()
	return ent
end

local function expectAngle(got, p, y, r)
	expect(got.p).to.equal(p)
	expect(got.y).to.equal(y)
	expect(got.r).to.equal(r)
end

return {
	groupName = "EMVU auto-component transform",

	cases = {
		{
			name = "A NotLegacy mount at yaw 90 keeps a local-zero light at yaw 90",
			func = function()
				local ang = EMVU.Helper.ComposeAutoLightAngle(
					{ NotLegacy = true },
					Angle(0, 0, 0),
					Angle(0, 90, 0)
				)
				expectAngle(ang, 0, 90, 0)
			end
		},
		{
			name = "A NotLegacy mount adds its yaw onto a local light yaw",
			func = function()
				local ang = EMVU.Helper.ComposeAutoLightAngle(
					{ NotLegacy = true },
					Angle(0, 45, 0),
					Angle(0, 90, 0)
				)
				expectAngle(ang, 0, 135, 0)
			end
		},
		{
			name = "A rolled mount keeps its roll on a local-zero light so the sprite follows the model",
			func = function()
				local ang = EMVU.Helper.ComposeAutoLightAngle(
					{ NotLegacy = true },
					Angle(0, 0, 0),
					Angle(0, -6, 10)
				)
				expectAngle(ang, 0, -6, 10)
			end
		},
		{
			name = "A mirrored-style mount keeps its authored yaw instead of a GetAngles remapping",
			func = function()
				local ang = EMVU.Helper.ComposeAutoLightAngle(
					{ NotLegacy = true },
					Angle(0, 0, 0),
					Angle(180, -31, 163)
				)
				expectAngle(ang, 180, -31, 163)
			end
		},
		{
			name = "A legacy mount subtracts 90 yaw so a 90-degree placement faces with the model",
			func = function()
				local ang = EMVU.Helper.ComposeAutoLightAngle(
					{},
					Angle(0, 28, 0),
					Angle(0, 90, 0)
				)
				expectAngle(ang, 0, 28, 0)
			end
		},
		{
			name = "ForwardTranslation remaps local pitch and roll before adding the mount",
			func = function()
				local ang = EMVU.Helper.ComposeAutoLightAngle(
					{ NotLegacy = true, ForwardTranslation = true },
					Angle(10, 90, 0),
					Angle(0, 0, 0)
				)
				expectAngle(ang, 0, 90, 10)
			end
		},
		{
			name = "Applying the same numeric scale twice does not compound",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent

				EMVU.Helper.ApplyModelScale(ent, 1.5)
				local afterFirst = ent:GetModelScale()
				EMVU.Helper.ApplyModelScale(ent, 1.5)

				expect(ent:GetModelScale()).to.equal(afterFirst)
			end
		},
		{
			name = "A nil scale resets a previously scaled model to 1",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent

				EMVU.Helper.ApplyModelScale(ent, 2)
				EMVU.Helper.ApplyModelScale(ent, nil)

				expect(ent:GetModelScale()).to.equal(1)
			end
		},
		{
			name = "Changing scale replaces the previous value instead of multiplying it",
			func = function(state)
				local ent = NewEnt()
				state.ent = ent

				EMVU.Helper.ApplyModelScale(ent, 2)
				EMVU.Helper.ApplyModelScale(ent, 0.5)

				-- Clientside the scale lives on the render matrix and
				-- GetModelScale stays 1 after the reset. The server path is
				-- SetModelScale, which is what we can observe here.
				if SERVER then
					expect(ent:GetModelScale()).to.equal(0.5)
				else
					expect(ent:GetModelScale()).to.equal(1)
				end
			end
		},
	},

	afterEach = function(state)
		if IsValid(state.ent) then state.ent:Remove() end
		state.ent = nil
	end,
}
