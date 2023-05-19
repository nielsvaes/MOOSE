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

    return self
end

function PATROL_AREA:AddGroup(group)
    table.insert(self.groups, group)
end

function PATROL_AREA:RemoveGroup(group)
    table.remove_by_value(self.groups, group)
end

function PATROL_AREA:DestroyAllGroups()
    for _, group in pairs(self.groups) do
        group:Destroy()
    end
end

function PATROL_AREA:Start()
    self:Stop()
    self.schedule_id = BASE:ScheduleRepeat(
        0.1,
        self.update_time,
        math.random(0, 1),
        999999,
        function()
            for _, group in pairs(self.groups) do
                if group ~= nil and group:IsAlive() then
                    if UTILS.PercentageChance(20) then
                        BASE:ScheduleOnce(math.random(5, 10), function() group:RouteStop() end)
                    end
                    group:RouteToVec2(self:GetRandomVec2(), 1.2)
                end
            end
        end
    )
end

function PATROL_AREA:Stop()
    if self.schedule_id ~= nil then
        SCHEDULER:Stop(self.schedule_id)
        SCHEDULER:Remove(self.schedule_id)
    end
end

function PATROL_AREA:SetUpdateTime(update_time)
    self:Stop()
    self.update_time = update_time
    self:Start()
end
