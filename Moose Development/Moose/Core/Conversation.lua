--- assert(loadfile("C:/git/honu/missions/mission_01/sounds/sounds_data.lua"))()
---
---
--- convo = CONVERSATION:New("intercom", nil, nil,
---                          CCMISSION.VOICE.removing_safety_pins, 5,
---                          CCMISSION.VOICE.safety_pins_removed, 3)
--- convo:Play()
---
--- con = CONVERSATION:New(CCMISSION.RADIOS.PLAYER, 127.00, nil,
---                        CCMISSION.VOICE.dagger11_requesting_taxi_to_runway, 0.6,
---                        CCMISSION.VOICE.taxi_runway_approved, 0)
--- con:Play()

CONVERSATION = {
    ClassName = "CONVERSATION"
}

function CONVERSATION:New(frequency, mod, ...)
    self = BASE:Inherit(self, BASE:New())
    self.frequency = frequency
    self.mod = mod or radio.modulation.AM
    self.args = {...}
    self.lines = {}
    self.pauses = {}
    self.radios = {}
    self.total_length = 0

    for _, arg in spairs(self.args) do
        if type(arg) == "number" then
            self.pauses[#self.pauses + 1] = arg
        elseif arg.len ~= nil then
            self.lines[#self.lines + 1] = arg
        elseif arg.ClassName == "RADIO" then
            self.radios[#self.radios + 1] = arg
        end
    end

    self.pauses[#self.pauses] = 0.25
    if (#self.pauses ~= #self.lines) or (#self.radios ~= #self.lines) then
        self:E("Lines, pauses and radios aren't the same length!")
        self:E(self.lines)
        self:E(self.pauses)
        self:E(self.radios)
    end
    return self
end

function CONVERSATION:Play(initial_delay)
    initial_delay = initial_delay or 0
    local pause = initial_delay

    for i=1, #self.lines do
        local file = self.lines[i].file
        local subtitle = self.lines[i].sub
        local length = self.lines[i].len

        if self.frequency == nil then
            self:ScheduleOnce(pause, trigger.action.outSound, file)
        else
            self:ScheduleOnce(pause, function()
                self.radios[i]:NewUnitTransmission(file, subtitle, length + 5, self.frequency, self.mod, false)
                self.radios[i]:Broadcast()
            end)
        end
        pause = pause + length + self.pauses[i]
    end
    self.total_length = pause
    return self
end

function CONVERSATION:AddLine(line, radio, pause)
    self.lines[#self.lines + 1] = line
    self.pauses[#self.pauses + 1] = pause
    self.radios[#self.radios + 1] = radio

end


function CONVERSATION:Length()
    return self.total_length
end
