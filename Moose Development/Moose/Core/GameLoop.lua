GAMELOOPFUNCTION = {
    ClassName = "GAMELOOPFUNCTION"
}

function GAMELOOPFUNCTION:New(func, args, times_to_call, id, times_per_second, execute_on_creation)
    self = BASE:Inherit(self, BASE:New())
    self.f = func
    self.args = args or {}
    self.times_to_call = times_to_call or -1
    self.id = id or string.format("%05d", math.random(1, 10000))
    self.times_called = 0
    self.times_per_second = times_per_second or 30
    self.return_value = nil
    self.has_completed = false
    self.exit_condition_function = function() return false  end
    self.exit_condition_function_args = {}

    execute_on_creation = execute_on_creation or false
    if execute_on_creation then
        self.return_value = self.f(unpack(self.args))
    end

    return self
end

function GAMELOOPFUNCTION:SetExitFunction(exit_condition_function)
    self.exit_condition_function = exit_condition_function
end

function GAMELOOPFUNCTION:CanExec()
    if self.has_completed then
        self:I("Function has been marked completed")
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
        self.has_completed = self.exit_condition_function(unpack(self.exit_condition_function_args))
        return self.return_value
    end
end

function GAMELOOPFUNCTION:GetReturnValue()
    return self.return_value
end

function GAMELOOPFUNCTION:HasCompleted()
    return self.has_completed
end

function GAMELOOPFUNCTION:SetHasCompleted(value)
    self.has_completed = value
end

function GAMELOOPFUNCTION:GetTimesPerSecond()
    return self.times_per_second
end

function GAMELOOPFUNCTION:SetTimesPerSecond(value)
    self.times_per_second = value
    return self
end

function GAMELOOPFUNCTION:GetID()
    return self.id
end

function GAMELOOPFUNCTION:Add()
    GAMELOOP:Get():Add(self)
    return self
end

GAMELOOP = {
    ClassName = "GAMELOOP"
}


function GAMELOOP:Get()
    if _G["game_loop"] == nil then
        self = BASE:Inherit(self, BASE:New())
        self.times_per_second = 60
        self.time_per_tick = 1 / self.times_per_second
        self.total_tick_count = 0
        self.gameloopfunctions = {}
        self.timer = TIMER:New(self.Execute, self)
        self.name = "Nissagirl!"

        _G["game_loop"] = self
    end

    return _G["game_loop"]
end

function GAMELOOP:Execute()
    local i=1
    while i <= #self.gameloopfunctions do                                       -- more performant than a pair loop
        local gameloopfunction = self.gameloopfunctions[i]
        local glf_return_value
        local errored

        if gameloopfunction:HasCompleted() then
            gameloopfunction:I("I have been completed, GAMELOOP is removing me from the list")
            self:Remove(gameloopfunction)
        else
            if math.fmod(self.total_tick_count, self.times_per_second / gameloopfunction:GetTimesPerSecond()) == 0 then
                if gameloopfunction:CanExec() then
                    errored, glf_return_value = pcall(gameloopfunction:Exec())
                    if errored then
                        self:I(string.format("%s has encountered an error", gameloopfunction:GetID()))
                        self:I(glf_return_value)
                    end
                end
            end
        end
        i = i + 1
    end
    self.total_tick_count = self.total_tick_count + 1
end

function GAMELOOP:Add(gameloopfunction, position)
    if gameloopfunction:GetTimesPerSecond() > self.times_per_second then
        self:I(string.format("%s tick per seconds was set to %d, max allowed by GAMELOOP is %d", gameloopfunction:GetID(), gameloopfunction:GetTimesPerSecond(), self.times_per_second))
        gameloopfunction:SetTimesPersecond(self.times_per_second)
    end
    local was_running = self.timer.isrunning
    self:Stop()
    position = position or #self.gameloopfunctions + 1
    table.insert(self.gameloopfunctions, position, gameloopfunction)
    if was_running then
        self:Start()
    end
    self:I("Added " .. gameloopfunction:GetID() .. ", tickrate: " .. tostring(gameloopfunction:GetTimesPerSecond()))
end

function GAMELOOP:Remove(func)
    local was_running = self.timer.isrunning
    self:Stop()
    table.remove_by_value(self.gameloopfunctions, func)

    self:I(tostring(#self.gameloopfunctions) .. " loaded")
    if was_running then
        self:Start()
    end
end

function GAMELOOP:RemoveByID(id)
    for _, func in pairs(self.gameloopfunctions) do
        if func.id == id then
            self:I("Found the function to remove: " .. id)
            return self:Remove(func)
        end
    end
end

function GAMELOOP:Start()
    self:I(tostring(#self.gameloopfunctions) .. " functions loaded")
    self.timer:Start(nil, self.time_per_tick)
    return self
end

function GAMELOOP:Stop()
    --self:I("Stopping!")
    self.timer:Stop()
end

function GAMELOOP:UpdateTickRate(value)
    self:Stop()
    self:I("****** UPDATING TICK RATE!")
    self.times_per_second = value
    self.time_per_tick = 1 / value
    self:Start()
end

function GAMELOOP:GetTimesPerSecond()
    return self.times_per_second
end

function GAMELOOP:GetTimePerTick()
    return self.time_per_tick
end

function GAMELOOP:ClearAll()
    self.gameloopfunctions = {}
end

function GAMELOOP:GetTotalTickCount()
    return self.total_tick_count
end

function GAMELOOP:Reset(restart)
    restart = restart or false
    self:Stop()
    self:ClearAll()
    self.timer = TIMER:New(self.Execute, self)
    self.total_tick_count = 0
    if restart then
        self:Start()
    end
end

function GAMELOOP:Restart()
    self:Stop()
    self.timer = TIMER:New(self.Execute, self)
    self.total_tick_count = 0
    self:Start()
end
