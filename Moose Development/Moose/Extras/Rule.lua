RULE = {
    ClassName = "RULE"
}

RULE.TYPE = {
    ONCE = "once",
    CONTINUOUS = "continous",
    TOGGLE = "toggle",
    MULTIPLE = "multiple"
}

function RULE:New(name, type, f_condition, f_action, ...)
    local self = BASE:Inherit(self, BASE:New())
    self.name = name
    self.type = type or RULE.TYPE.CONTINUOUS
    self.id = string.format("%05d", math.random(1, 10000))
    self.f_condition = f_condition or function()  end
    self.dev_condition = function()   end
    self.f_action = f_action or function()  end
    self.f_action_args = {...}
    self.is_active = false
    self.delay = 0
    self.times_per_second = 1
    self.__previous_active = self.is_active
    return self
end

function RULE:SetCondition(c)
    self.f_condition = c
end

function RULE:SetDevCondition(c)
    self.dev_condition = c
end

function RULE:SetAction(f, ...)
    self.f_action_args = {...}
    self.f_action = f
end

function RULE:SetDelay(value)
    self.delay = value
end

function RULE:SetTimesPerSecond(value)
    self.times_per_second = value
end

function RULE:Add()
    RULE_MANAGER:Get():Add(self)
    return self
end

function RULE:IsTrue()
    return self.f_condition() or self.dev_condition()
end

function RULE:__Exec()
    BASE:ScheduleOnce(self.delay, function()
        self:I("Executing: " .. self.name)
        self.f_action(unpack(self.f_action_args))

        if self.type == RULE.TYPE.TOGGLE then
            self:SetActive(true)
        end
    end)
end

function RULE:GetName()
    return self.name
end

function RULE:GetType()
    return self.type
end

function RULE:GetDelay()
    return self.delay
end

function RULE:GetTimesPerSecond()
    return self.times_per_second
end

function RULE:SetActive(value)
    self.is_active = value
    if self.is_active ~= self.__previous_active then
        self:I(self.name .. " is toggled to: " .. tostring(self.is_active))
        self.__previous_active = self.is_active
    end
end



RULE_MANAGER = {
    ClassName = "RULE_MANAGER"
}

function RULE_MANAGER:Get()
    if _G["rule_manager"] == nil then
        local self = BASE:Inherit(self, BASE:New())

        self.rules = {}
        _G["rule_manager"] = self
        self:I("Making RULE_MANAGER")

        self.glf = GAMELOOPFUNCTION:New(self.CheckRules, {self}, -1, "rule_manager"):Add()
    end
    return _G["rule_manager"]
end

function RULE_MANAGER:TestAllRules()
    self:I("\n\n------------------- RULE TESTING-------------------")
    for _, rule in pairs(self.rules) do
        local test_table = {
            ["dev_condition"] = rule.dev_condition,
            ["f_condition  "] = rule.f_condition,
            ["f_action     "] = rule.f_action
        }


        for name, func in pairs(test_table) do
            local succeeded, return_value = pcall(func)
            if not succeeded then
                return_value = "ERROR: " .. tostring(return_value)
            end
            self:I(string.format("%s: %s [%s] - [%s]", rule:GetName(), name, tostring(succeeded), tostring(return_value)))
        end
    end
    self:I("\n\n------------------- RULE TESTING-------------------\n\n")
end

function RULE_MANAGER:Add(rule)
    self:I("Adding: " .. rule:GetName())
    local pos = #self.rules + 1
    table.insert(self.rules, pos, rule)

    local times_per_second = 99999
    for _, r in pairs(self.rules) do
        if r.times_per_second < times_per_second then
            times_per_second = r.times_per_second
        end
    end

    self.glf:SetTimesPerSecond(times_per_second)
    self:I(#self.rules)
end

function RULE_MANAGER:Remove(rule)
    self:I("Removing: " .. rule:GetName())
    table.remove_by_value(self.rules, rule)
    self:I(#self.rules)
end

function RULE_MANAGER:RemoveByID(id)
    for _, rule in pairs(self.rules) do
        if rule.id == id then
            self:I("Found the function to remove: " .. id)
            return self:Remove(rule)
        end
    end
end

function RULE_MANAGER:GetByID(id)
    for _, rule in pairs(self.rules) do
        if rule.id == id then
            self:I("Found the function: " .. id)
            return rule
        end
    end
end

function RULE_MANAGER:RemoveByName(name)
    for _, rule in pairs(self.rules) do
        if rule.name == name then
            self:I("Found the function to remove: " .. name)
            return self:Remove(rule)
        end
    end
end

function RULE_MANAGER:GetByName(name)
    for _, rule in pairs(self.rules) do
        if rule.name == name then
            self:I("Found the function: " .. name)
            return rule
        end
    end
end

function RULE_MANAGER:CheckRules()
    for _, rule in pairs(self.rules) do
        if rule:GetType() == RULE.TYPE.TOGGLE then
            if rule:IsTrue() then
                if rule.is_active == false then
                    rule:__Exec()
                end
            else
                rule:SetActive(false)
            end
        elseif rule:GetType() == RULE.TYPE.ONCE then
            if rule:IsTrue() then
                rule:__Exec()
                self:Remove(rule)
            end
        elseif rule:GetType() == RULE.TYPE.CONTINUOUS then
            if rule:IsTrue() then
                rule:__Exec()
            end
        end
    end
end

function RULE_MANAGER:GetAllRules()
    return self.rules
end

function RULE_MANAGER:GetAllRulesInfoDict()
    local info_dict = {}
    for _, rule in spairs(self.rules) do
        info_dict[rule.id] = {
            name = rule.name,
            rule = rule,
            type = rule.type
        }
    end
    return info_dict
end

function RULE_MANAGER:GetAllRulesOfType(rule_type)
    local rules = {}
    for _, rule in spairs(self.rules) do
        if rule.type == rule_type then
            table.insert(self.rules, #self.rules + 1, rule)
        end
    end
    return rules
end

