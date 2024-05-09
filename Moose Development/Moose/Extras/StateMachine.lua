MIZSTATE = {
    ClassName = "MIZSTATE"
}

function MIZSTATE:New(name, time, help_text)
    local self = BASE:Inherit(self, BASE)
    self.name = name
    self.time = time
    self.help_text = help_text
    self.expired = false

    return self
end




MIZSTATEMACHINE = {
    ClassName = "MIZSTATEMACHINE",
}

function MIZSTATEMACHINE:New()
    local self = BASE:Inherit(self, BASE)
    self.states = {}
    self.active_state = nil
    self.root_menu = nil

    self.check_start_time = timer.getAbsTime()
    dev_message(tostring(self.check_start_time))

    self.glf = GAMELOOPFUNCTION:New(self.Check, {self}, -1, nil, 1)
    self.glf:Add()

    return self
end

function MIZSTATEMACHINE:Check()
    if self.active_state and timer.getAbsTime() > self.check_start_time + self.active_state.time then
        self.active_state.expired = true

        self.root_menu = MENU_COALITION:New(
            coalition.side.BLUE,
            "Miz State Tracker"
        )

        MENU_COALITION_COMMAND:New(
            coalition.side.BLUE,
            "Move to next mission state",
            self.root_menu,
            function()
                self:NextState()
            end
        )

        self:I("Timer for state expired: " .. self.active_state.name)
    end
end

function MIZSTATEMACHINE:AddState(miz_state)
    table.add(self.states, miz_state)
end

function MIZSTATEMACHINE:SwitchTo(state_name)
    for _, miz_state in pairs(self.states) do
        if miz_state.name == state_name then
            self:SetActiveState(miz_state)
        end
    end
end

function MIZSTATEMACHINE:NextState()
    if self.active_state == nil then
        self:SetActiveState(self.states[1])
        return
    end

    for index, miz_state in pairs(self.states) do
        if self.active_state.name == miz_state.name and index + 1 <= #self.states then
            self:SetActiveState(self.states[index + 1])
        end
    end
end

function MIZSTATEMACHINE:SetActiveState(miz_state)
    MESSAGE:New("", 1, nil, true):ToAll()
    self.check_start_time = timer.getAbsTime()

    if self.active_state then
        self.active_state.expired = false
    end

    if self.root_menu then
        self.root_menu:Remove()
    end

    self.active_state = miz_state
    self:I("Moved to active state: " .. self.active_state.name)
end
