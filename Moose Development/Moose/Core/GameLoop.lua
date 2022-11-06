GAMELOOPFUNCTION = {
    ClassName = "GAMELOOPFUNCTION"
}

function GAMELOOPFUNCTION:New(func, args, times_to_call, execute_on_creation)
    self = BASE:Inherit(self, BASE:New())
    self.f = func
    self.args = args
    self.times_to_call = times_to_call or -1
    self.times_called = 0
    self.return_value = nil
    self.has_completed = false
    self.exit_function = nil


    execute_on_creation = execute_on_creation or false
    if execute_on_creation then
        self.return_value = self.f(unpack(self.args))
    end

    return self
end

function GAMELOOPFUNCTION:SetExitFunction(exit_function)
    self.exit_function = exit_function
end

function GAMELOOPFUNCTION:CanExec()
    if self.has_completed then
        return false
    elseif self.times_to_call == -1 then
        return true
    elseif self.times_called <= self.times_to_call then
        return true
    else
        self:I("Called maximum amount of times")
        self.has_completed = true
        return false
    end
end

function GAMELOOPFUNCTION:Exec(force)
    force = force or false

    if force or self:CanExec() then
        self.return_value = self.f(unpack(self.args))
        self.times_called = self.times_called + 1
        self.has_completed = self.exit_function()
        return self.return_value
    end
end

function GAMELOOPFUNCTION:GetReturnValue()
    return self.return_value
end

function GAMELOOPFUNCTION:HasCompleted()
    return self.has_completed
end



GAMELOOP = {
    ClassName = "GAMELOOP"
}

function GAMELOOP:New(tickrate)
    self = BASE:Inherit(self, BASE:New())
    self.tickrate = tickrate or 0.03 -- 0.03 -> 30hz
    self.gameloopfunctions = {}
    self.timer = nil
    self.is_running = false

    return self
end

function GAMELOOP:Execute()
    local i=1
    while i <= #self.gameloopfunctions do
        local gameloopfunction = self.gameloopfunctions[i]

        if gameloopfunction:HasCompleted() then
            gameloopfunction:I("I have been completed, GAMELOOP is removing me from the list")
            table.remove(self.gameloopfunctions, i)
        else
            if gameloopfunction:CanExec() then
                gameloopfunction:Exec()
            end
        end
        i = i + 1
    end
end

function GAMELOOP:Add(gameloopfunction, position)
    local was_running = self.is_running
    self:Stop()
    position = position or #self.gameloopfunctions + 1
    table.insert(self.gameloopfunctions, position, gameloopfunction)
    if was_running then
        self:Start()
    end
end

function GAMELOOP:Remove(func)
    self:Stop()

    local return_value = self.gameloopfunctions[func]:GetReturnValue()
    table.remove_key(self.gameloopfunctions, func)

    self:I(tostring(#self.gameloopfunctions) .. " loaded")

    self:Start()

    return return_value
end

function GAMELOOP:Start()
    if not self.is_running then
        self:I("Starting loop, " .. tostring(#self.gameloopfunctions) .. " functions loaded")
        self.timer = self.timer or TIMER:New(self.Execute, self)
        self.timer:Start(nil, self.tickrate)
    end

    self.is_running = true
    return self
end

function GAMELOOP:Stop()
    self:I("Stopping!")
    self.timer:Stop()
    self.is_running = false
end

function GAMELOOP:UpdateTickRate(value)
    self.tickrate = value
    self:Stop()
    self:Start()
end

function GAMELOOP:ClearAll()
    self.gameloopfunctions = {}
end

function GAMELOOP:Reset()
    self:ClearAll()
    self:Stop()
end
