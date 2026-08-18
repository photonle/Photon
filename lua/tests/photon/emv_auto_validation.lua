return {
	groupName = "EMVU.ValidateAutoComponent",

	cases = {
		{
			name = "A component with all required fields is valid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = {
						{ Vector(0, 0, 0), Angle(0, 0, 0), "example" }
					},
					Modes = { Primary = {} }
				})

				expect(valid).to.beTrue()
				expect(err).to.beNil()
			end
		},
		{
			name = "A component with a Base is exempt from the other required fields",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Inherited Component",
					Base = "Example Component"
				})

				expect(valid).to.beTrue()
				expect(err).to.beNil()
			end
		},
		{
			name = "A component missing Name is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = { Primary = {} }
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A component missing Meta is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Sections = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = { Primary = {} }
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A component missing Sections is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Meta = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = { Primary = {} }
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A component missing Patterns is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Meta = {},
					Sections = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = { Primary = {} }
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A component missing Positions is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Meta = {},
					Sections = {},
					Patterns = {},
					Modes = { Primary = {} }
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A component with empty light-pattern tables is valid, since empty tables don't error",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Prop Component",
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = {},
					Modes = { Primary = {} }
				})

				expect(valid).to.beTrue()
				expect(err).to.beNil()
			end
		},
		{
			name = "A component missing Modes is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } }
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A component missing Modes.Primary is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = {}
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A component with valid Model, Category and Skin fields is valid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Model = "models/example/example.mdl",
					Category = "Lightbar",
					Skin = 0,
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = { Primary = {} }
				})

				expect(valid).to.beTrue()
				expect(err).to.beNil()
			end
		},
		{
			name = "A component without a Model is valid, since not all components have a physical model",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Hidden Component",
					Category = "Hidden",
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = { Primary = {} }
				})

				expect(valid).to.beTrue()
				expect(err).to.beNil()
			end
		},
		{
			name = "A component with a non-string Model is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Model = 123,
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = { Primary = {} }
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A component with a non-number Skin is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateAutoComponent({
					Name = "Example Component",
					Skin = "zero",
					Meta = {},
					Sections = {},
					Patterns = {},
					Positions = { { Vector(0, 0, 0), Angle(0, 0, 0), "example" } },
					Modes = { Primary = {} }
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		}
	}
}
