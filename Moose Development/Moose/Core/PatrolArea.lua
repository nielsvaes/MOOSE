--- Usage:
--- patrol_area = PATROL_AREA:New("mock_village_01")
--- for u=1, math.random(80, 120) do
---     local temp_tbl = {}
---     for _=1, math.random(1, 2) do
---         table.add(temp_tbl, CCGROUND_UNITS.INFANTRY.InfantryAKIns)
---     end
---
---     local grp
---     local unit_tbl = CCMISSIONDB:Get():CreateUnitsTable("compound_unit", temp_tbl)
---     local grp_tbl = CCMISSIONDB:Get():CreateGroupTable("compund_group", unit_tbl)
---     grp_tbl["hiddenOnMFD"] = true
---     grp = CCMISSIONDB:Get():Add(grp_tbl, Group.Category.GROUND, country.id.CJTF_RED, coalition.side.RED)
---     local spawned_group = SPAWN:NewWithAlias(grp:GetName(), UTILS.UniqueName(grp:GetName()))
---                                :InitRandomizeUnits(true, 1, 0.5)
---                                :SpawnFromVec2(patrol_area:GetRandomVec2())
---
---     patrol_area:AddGroup(spawned_group)
---     table.add(patrols, spawned_group)
--- end

PATROL_AREA = {
    ClassName = "PATROL_AREA",
}

function PATROL_AREA:New(name, points, groups, update_time)
    if name ~= nil then
        self = BASE:Inherit(self, POLYGON:FindOnMap(name))
    else
        self = BASE:Inherit(self, POLYGON:New(points))
    end

    self.groups = groups or {}
    self.update_time = update_time or 60
    self.schedule_id = nil
    self.walk_speed = 1.2
    self.debug_draw_on = false
    self.debug_mark_ids = {}

    self.glf = GAMELOOPFUNCTION:New(self.PickNewLocation, {self}, -1, UTILS.UniqueName(), 1/self.update_time, true)
    return self
end

function PATROL_AREA:AddGroup(group)
    self.groups[group] = {
        vec2 = {},
        speed = self.walk_speed
    }
    --table.insert(self.groups, group)
end

function PATROL_AREA:RemoveGroup(group)
    table.remove_by_value(self.groups, group)
end

function PATROL_AREA:DestroyAllGroups()
    for _, group in pairs(self.groups) do
        group:Destroy()
    end
end

function PATROL_AREA:PickNewLocation()
    for group, group_data in pairs(self.groups) do
        if group ~= nil and group:IsAlive() then
            if UTILS.PercentageChance(20) then
                BASE:ScheduleOnce(math.random(5, 10), function() group:RouteStop() end)
            end
            local new_pos = self:GetRandomVec2()
            group:RouteToVec2(new_pos, self.walk_speed)
            self.groups[group].vec2 = {new_pos}
            self:__Draw()
        end
    end
end

function PATROL_AREA:Start()
    self.glf:Add()
    self.glf:Exec()
end

function PATROL_AREA:Stop()
    GAMELOOP:Get():Remove(self.glf)
end

function PATROL_AREA:UpdateSpeed(value, force)
    force = force or false
    self.walk_speed = value

    if force then
        self:Stop()
        self:Start()
    end
end

function PATROL_AREA:SetUpdateTime(update_time)
    self:Stop()
    self.update_time = update_time
    self:Start()
end

function PATROL_AREA:DebugDraw()
    self.debug_draw_on = true
    self:__Draw()
end

function PATROL_AREA:RemoveDebugDraw()
    self:RemoveDraw()
    self.debug_draw_on = false
end

function PATROL_AREA:__Draw()
    self:RemoveDebugDraw()
    if self.debug_draw_on then
        self:Draw()
        for group, group_data in pairs(self.groups) do
            table.add(self.debug_mark_ids, COORDINATE:NewFromVec2(group_data.vec2):CircleToAll(50, -1, {0, 0, 1}, 1, {0, 0, 1}))
            table.add(self.debug_mark_ids, LINE:Draw(group:GetVec2(), group_data.vec2))
        end
    end
end

