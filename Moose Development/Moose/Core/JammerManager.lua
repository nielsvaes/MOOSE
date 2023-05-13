
JAMMER_MANAGER = {
    ClassName = "JAMMER_MANAGER"
}

function JAMMER_MANAGER:Get(force)
    force = force or false
    if _G["jammer_manager"] == nil or force then
        self = BASE:Inherit(self, BASE:New())

        self.unit_info = {}

        _G["jammer_manager"] = self
        self:I("Making new JAMMER_MANAGER")
        self.check_glf = GAMELOOPFUNCTION:New(self.CheckJammed, {self}, -1, nil, JAMMER.JamRate):Add()
    end
    return _G["jammer_manager"]
end

function JAMMER_MANAGER:UpdateJammed(unit, jammer, turned_off, recovery_time)
    if not table.contains_key(self.unit_info, unit) then
        self.unit_info[unit] = {
            jammers = { jammer },
            cooldown_active = true,
            active_at = timer.getTime() + recovery_time,
            turned_off = turned_off,
            --timer = TIMER:New()
        }
    end
    table.insert_unique(self.unit_info[unit].jammers, jammer)
    self.unit_info[unit].cooldown_active = true
    self.unit_info[unit].active_at = self.unit_info[unit].active_at + recovery_time
    self.unit_info[unit].turned_off = turned_off
    self:I(unit:GetName() .. " is now jammed")
end

function JAMMER_MANAGER:CheckJammed()
    local time = timer.getTime()
    local tmp_table = {}
    local to_del = {}
    for unit, unit_info in pairs(self.unit_info) do
        self:I(unit:GetName() .. " will be unjammed in " .. tostring(unit_info.active_at - time))
        if time > unit_info.active_at then
            unit:EnableEmission(true)
            unit:OptionROEWeaponFree()
            self:I(unit:GetName())
            self:I("no longer jammed")
            table.add(to_del, unit)
        else
            tmp_table[unit] = unit_info
        end
    end

    self.unit_info = tmp_table
end

