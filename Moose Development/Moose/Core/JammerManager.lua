
JAMMER_MANAGER = {
    ClassName = "JAMMER_MANAGER"
}

function JAMMER_MANAGER:Get(force)
    force = force or false
    if _G["jammer_manager"] == nil or force then
        self = BASE:Inherit(self, BASE:New())

        self.unit_info = {}
        self.jtu_info = {}

        _G["jammer_manager"] = self
        self:I("Making new JAMMER_MANAGER")
        self.check_glf = GAMELOOPFUNCTION:New(self.CheckJammedJTU, {self}, -1, "jammer_manager_check_glf", JAMMER.JamRate):Add()
    end
    return _G["jammer_manager"]
end

function JAMMER_MANAGER:UpdateJammedJTU(jtu, jammer)
    local name = jtu:GetName()

    -- storing the JTU with its name, because multiple jammers might targeting the same DCS unit
    if not table.contains(self.jtu_info, name) then
        self.jtu_info[name] = {
            active_at = timer.getTime() + jtu.recovery_time,
            jammers = {jammer}
        }
    end

    table.insert_unique(self.jtu_info[name].jammers, jammer)
    self.jtu_info[name].active_at = self.jtu_info[name].active_at + jtu.recovery_time

    self:I(name .. " is now jammed")
end

function JAMMER_MANAGER:CheckJammedJTU()
    local time = timer.getTime()
    local tmp_table = {}
    for jtu_name, jtu_info in pairs(self.jtu_info) do
        print(jtu_name .. " will be active in " .. tostring(jtu_info.active_at - time))
        if time > jtu_info.active_at then
            local unit = UNIT:FindByName(jtu_name)
            unit:EnableEmission(true)
            unit:OptionROEWeaponFree()
            self:I(jtu_name .. " is no longer jammed")
        else
            tmp_table[jtu_name] = jtu_info
        end
    end

    self.jtu_info = tmp_table
end
--
--function JAMMER_MANAGER:UpdateJammed(unit, jammer, turned_off, recovery_time)
--    if not table.contains_key(self.unit_info, unit) then
--        self.unit_info[unit] = {
--            jammers = { jammer },
--            active_at = timer.getTime() + recovery_time,
--            turned_off = turned_off,
--        }
--    end
--    table.insert_unique(self.unit_info[unit].jammers, jammer)
--    self.unit_info[unit].cooldown_active = true
--    self.unit_info[unit].active_at = self.unit_info[unit].active_at + recovery_time
--    self.unit_info[unit].turned_off = turned_off
--    self:I(unit:GetName() .. " is now jammed")
--end
--
--function JAMMER_MANAGER:CheckJammed()
--    local time = timer.getTime()
--    local tmp_table = {}
--    local to_del = {}
--    for unit, unit_info in pairs(self.unit_info) do
--        self:I(unit:GetName() .. " will be unjammed in " .. tostring(unit_info.active_at - time))
--        if time > unit_info.active_at then
--            unit:EnableEmission(true)
--            unit:OptionROEWeaponFree()
--            self:I(unit:GetName())
--            self:I("no longer jammed")
--        else
--            tmp_table[unit] = unit_info
--        end
--    end
--
--    self.unit_info = tmp_table
--end

