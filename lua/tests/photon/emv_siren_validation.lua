return {
	groupName = "EMVU.ValidateSiren",

	cases = {
		{
			name = "A siren with Name, Category and a Set of valid tones is valid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav", Icon = "wail"}
					}
				})

				expect(valid).to.beTrue()
				expect(err).to.beNil()
			end
		},
		{
			name = "A siren missing Name is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Category = "Examples",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav"}
					}
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A siren missing Category is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav"}
					}
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A siren missing Set is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples"
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A siren with an empty Set is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples",
					Set = {}
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A siren with a tone missing Sound is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples",
					Set = {
						{Name = "WAIL"}
					}
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A siren with a tone missing Name is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples",
					Set = {
						{Sound = "emv/sirens/example/example.wav"}
					}
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A siren with valid Horn, Manual and Volume fields is valid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav"}
					},
					Horn = "emv/sirens/example/horn.wav",
					Manual = "emv/sirens/example/manual.wav",
					Volume = 90
				})

				expect(valid).to.beTrue()
				expect(err).to.beNil()
			end
		},
		{
			name = "A siren with a non-string Horn is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav"}
					},
					Horn = 123
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A siren with a non-string Manual is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav"}
					},
					Manual = 123
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		},
		{
			name = "A siren with a non-number Volume is invalid",
			func = function(state)
				local valid, err = EMVU.ValidateSiren({
					Name = "Example Siren",
					Category = "Examples",
					Set = {
						{Name = "WAIL", Sound = "emv/sirens/example/example.wav"}
					},
					Volume = "loud"
				})

				expect(valid).to.beFalse()
				expect(err).to.beA("string")
			end
		}
	}
}
