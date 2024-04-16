
UAV = {
    ClassName = "UAV",
    Forever = 99999
}

--- magic numbers
UAV.FOV = {
    NARROW = 217,
    WIDE = 155
}

function UAV:FindByName(unit_name)
    local self = BASE:Inherit(self, UNIT:FindByName(unit_name))
    if self == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end

    self.previously_detected_units = {}
    self.currently_detected_units = {}
    self.currently_lased_unit = nil
    self.currently_lased_coordinate_index = 0
    self.view_coordinate = nil
    self.scan_speed = 2000
    self.FOV = UAV.FOV.WIDE
    self.zoom_level = 1
    self.laser_code = 1688
    self.coordinate_list = {}

    self.all_units = SET_UNIT:New():FilterStart()

    return self
end

function UAV:StartLasingCoordinate(coor, laser_code)
    self:StopLasing()
    laser_code = laser_code or self.laser_code
    self.laser_code = laser_code
    self.currently_lased_unit = nil
    self:LaseCoordinate(coor, laser_code, UAV.Forever)
    self:I("Lasing: ")
    self:I(coor)
end

function UAV:StartLasingUnit(unit, laser_code, force)
    force = force or false
    self:StopLasing()

    laser_code = laser_code or self.laser_code
    self.laser_code = laser_code

    if table.contains(self.currently_detected_units, unit) or force then
        if force then
            self:LookAt(unit:GetCoordinate())
        end

        if self:GetCoordinate():IsLOS(unit:GetCoordinate()) then
            self:I("lasing unit: " .. unit:GetName())
            local id = self:GetName() .. "_lookat_glf"
            GAMELOOP:Get():RemoveByID(id)
            local lookat_glf = GAMELOOPFUNCTION:New(function()  return self:LookAt(unit:GetCoordinate()) end,{}, -1, id)
                                               :SetTimesPerSecond(1)
            GAMELOOP:Get():Add(lookat_glf)
            self:LaseUnit(unit, self.laser_code, UAV.Forever)
            self.currently_lased_unit = unit
        else
            self:I("I don't have a line of sight to " .. unit:GetName())
        end

    else
        self:I(unit:GetName() .. " is not in my currently detected units")
    end
end

function UAV:StopLasing()
    self:LaseOff()
    self.currently_lased_unit = nil
end

function UAV:LaseNextTarget()
    local current_index = table.index_of(self.currently_detected_units, self.currently_lased_unit) or 1
    local new_index = current_index + 1
    if new_index > #self.currently_detected_units then new_index = 1 end -- wrap

    self:StartLasingUnit(self.currently_detected_units[new_index])
end

function UAV:GetCurrentlyLasedUnit()
    return self.currently_lased_unit
end

function UAV:AddCoordinateToList(coor)
    table.insert(self.coordinate_list, coor)
end

function UAV:LaseNextCoordinate()
    if #self.coordinate_list == 0 then return end
    local new_index = self.currently_lased_coordinate_index + 1
    if new_index > #self.coordinate_list then new_index = 1 end

    self:StartLasingCoordinate(self.coordinate_list[new_index])
end

function UAV:SetLaserCode(value)
    self.laser_code = value
end

function UAV:GetLaserCode()
    return self.laser_code
end

function UAV:ToggleFOV()
    if self.FOV == UAV.FOV.NARROW then
        self.FOV = UAV.FOV.WIDE
    else
        self.FOV = UAV.FOV.NARROW
    end
end

function UAV:SetFOV(FOV)
    self.FOV = FOV
end

function UAV:GetFOV()
    return self.FOV
end

function UAV:SetZoomLevel(value)
    if value < 1 then value = 1 end
    if value > 9 then value = 9 end
    self.zoom_level = value
end

function UAV:GetZoomLevel()
    return self.zoom_level
end

function UAV:LookAt(coor)
    self.view_coordinate = coor
    UTILS.MessageToAll("x: " .. tostring(coor:GetVec2().x) .. ", y: " .. tostring(coor:GetVec2().x), 1, true)
end

function UAV:TranslateViewCoordinate(distance, bearing)
    self.view_coordinate:Translate(distance, bearing)
end

function UAV:MoveTo(coord)
    local task = self:TaskOrbit(coord, self:GetCoordinate().y, self:GetVelocityMPS())
    --local task = self:RouteToVec2(coord:GetVec2(), self:GetVelocityMPS())
    self:SetTask(task)
    BASE:I(task)
end

function UAV:GetViewRadius()
    --- Some absolute magic fuckery going on with the numbers, but it kind of falls
    --- within in the ballpark of what's realistic
    local view_angle = self:GetViewAngle()
    local multiplier = 90 / view_angle

    local diameter = (self:GetAltitude(true)  / self.FOV) / self.zoom_level
    local view_radius = (diameter / 2) * multiplier
    BASE:I("View radius: " .. tostring(view_radius))
    return view_radius
end

function UAV:GetViewAngle()
    return UTILS.VecAngle(self:GetCoordinate():GetVec3(), self.view_coordinate:GetVec3())
end

function UAV:GetDistanceToViewCoordinate()
    return self:GetCoordinate():Get3DDistance(self.view_coordinate)
end

function UAV:GetScanTime()
    --- More magic numbers
    local scan_time = self:GetViewRadius() / self.scan_speed
    BASE:I("scan time: " .. tostring(scan_time))
    return scan_time
end

function UAV:ScanArea(certainty)
    certainty = certainty or 1
    self:ScheduleOnce(self:GetScanTime(), self.__Scan, self)
    return math.pi * (self:GetViewRadius() ^ 2)
end

function UAV:BuildRadioMenu()
    self:RemoveMenu()

    self.root_menu = MENU_COALITION:New(
        self:GetCoalition(),
        self:GetName() .. " - Drone menu"
    )

    self.target_menu = MENU_COALITION:New(
        self:GetCoalition(),
        "Targets",
         self.root_menu
    )

    local i = 1
    while i <= #self.currently_detected_units do
        for j = i, math.min(i + 10 - 1, #self.currently_detected_units) do
            BASE:I(tostring(j))
            MENU_COALITION_COMMAND:New(
                self:GetCoalition(),
                self.currently_detected_units[j]:GetTypeName(),
                self.target_menu,
                function()
                    BASE:I(self.currently_detected_units[j]:GetTypeName())
                end
            )
        end
        BASE:I("Done with inner loop")
        i = i + 10
    end
end

function UAV:RemoveMenu()
    if self.root_menu ~= nil then
        self.root_menu:Remove()
    end
end

----- This just doesn't seem to do anything at all
--function UAV:Attack(unit)
--    unit = unit or self.currently_lased_unit
--    self:KnowUnit(unit, true, true)
--    local task = self:TaskAttackUnit(unit)
--    self:PushTask(task)
--end

function UAV:__Scan(...)
    BASE:I("Scanning...")
    for _, unit in pairs(self.all_units:GetSetObjects()) do
        if UTILS.IsInRadius(unit:GetVec2(), self.view_coordinate:GetVec2(), self:GetViewRadius()) then
            self:I(unit:GetName())
            table.insert_unique(self.currently_detected_units, unit)
        end
    end
end
