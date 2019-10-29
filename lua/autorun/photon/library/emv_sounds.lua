AddCSLuaFile()

-- These are the sounds the client hears
EMVU.Sounds = {}
EMVU.Sounds.On = "emv/ui/emv_on.wav"
EMVU.Sounds.Off = "emv/ui/emv_off.wav"
EMVU.Sounds.Toggle = "emv/ui/emv_on.wav"
EMVU.Sounds.Error = "emv/ui/emv_error.wav"
EMVU.Sounds.Add = "emv/ui/emv_add.wav"
EMVU.Sounds.Blackout = "emv/ui/emv_blackout.wav"
EMVU.Sounds.Tick = "emv/ui/emv_tick.wav"
EMVU.Sounds.Tock = "emv/ui/emv_tock.wav"
EMVU.Sounds.SignalOn = "emv/ui/emv_signal_on.wav"
EMVU.Sounds.SignalOff = "emv/ui/emv_signal_off.wav"
EMVU.Sounds.Down = "emv/ui/emv_chirp_down.wav"
EMVU.Sounds.Up = "emv/ui/emv_chirp_up.wav"

--- Play a toggling sound.
-- @bool state Current sound state.
-- @string a On state sound.
-- @string b Off state sound.
function EMVU.Sounds:Sound(state, a, b)
	surface.PlaySound(state and a or b)
end

--- Play the tocks.
-- @bool state Current sound state.
function EMVU.Sounds:Tocks(state)
	self:Sound(state, self.Tick, self.Tock)
end

--- Play signalling sound.
-- @bool state Current sound state.
function EMVU.Sounds:Signal(state)
	self:Sound(state, self.SignalOn, self.SignalOff)
end

--- Play panel button sound.
-- @bool state Current sound state.
function EMVU.Sounds:Panel(state)
	self:Sound(state, self.Up, self.Down)
end