STROBE_UNIT = {
    ClassName = "STROBE_UNIT",
}

function STROBE_UNIT:FindByName(unit_name)
    self = BASE:Inherit(self, UNIT:FindByName(unit_name))
    if self == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end
    self.strobe_active = false
    self.on_time = 0.08
    self.burst_interval = 0.5
    self.visible_chance = 85
    return self
end

function STROBE_UNIT:StartStrobe(bursts)
    self.strobe_active = true
    bursts = bursts or 2

    self:__Strobe(bursts)
end

function STROBE_UNIT:StopStrobe()
    self.strobe_active = false
    self:LaseOff()
end

function STROBE_UNIT:__Strobe(bursts)
    if self.strobe_active then
        self:LaseOff()
        for index = 1, bursts do
            if UTILS.PercentageChance(self.visible_chance) then
                BASE:ScheduleOnce((self.on_time + self.burst_interval) * index, self.LaseUnit, self, self, 1688, self.on_time)
            end
        end

        local wait_time = 2 * bursts * (self.on_time + self.burst_interval)
        BASE:ScheduleOnce(wait_time, self.__Strobe, self, bursts)
    end
end
