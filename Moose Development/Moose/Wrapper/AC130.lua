
AC130 = {
    ClassName = "AC130",
    Forever = 99999
}

--- magic numbers
AC130.FOV = {
    NARROW = 217,
    WIDE = 155
}

AC130.WEAPONS = {
    M102 = {
        WARHEAD = 15,
        FIRETIMER = 7.5,
    },
    GAU23 = {
        WARHEAD = 6,
        FIRETIMER = 3
    },
    GAU12 = {
        WARHEAD = 0.3,
        FIRETIMER = 0.03
    },
}

function AC130:FindByName(unit_name)
    self = BASE:Inherit(self, UNIT:FindByName(unit_name))
    if self == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end

    return self
end

function AC130:StartLasingCoordinate(coor, laser_code)
    self:StopLasing()
    laser_code = laser_code or self.laser_code
    self.laser_code = laser_code
    self.currently_lased_unit = nil
    self:LaseCoordinate(coor, laser_code, AC130.Forever)
    self:I("Lasing: ")
    self:I(coor)
end

function AC130:StartLasingUnit(unit, laser_code, force)
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
            self:LaseUnit(unit, self.laser_code, AC130.Forever)
            self.currently_lased_unit = unit
        else
            self:I("I don't have a line of sight to " .. unit:GetName())
        end

    else
        self:I(unit:GetName() .. " is not in my currently detected units")
    end
end

function AC130:StopLasing()
    self:LaseOff()
    self.currently_lased_unit = nil
end

function AC130:LaseNextTarget()
    local current_index = table.index_of(self.currently_detected_units, self.currently_lased_unit) or 1
    local new_index = current_index + 1
    if new_index > #self.currently_detected_units then new_index = 1 end -- wrap

    self:StartLasingUnit(self.currently_detected_units[new_index])
end

function AC130:GetCurrentlyLasedUnit()
    return self.currently_lased_unit
end

function AC130:AddCoordinateToList(coor)
    table.insert(self.coordinate_list, coor)
end

function AC130:LaseNextCoordinate()
    if #self.coordinate_list == 0 then return end
    local new_index = self.currently_lased_coordinate_index + 1
    if new_index > #self.coordinate_list then new_index = 1 end

    self:StartLasingCoordinate(self.coordinate_list[new_index])
end

function AC130:SetLaserCode(value)
    self.laser_code = value
end

function AC130:GetLaserCode()
    return self.laser_code
end

function AC130:ToggleFOV()
    if self.FOV == AC130.FOV.NARROW then
        self.FOV = AC130.FOV.WIDE
    else
        self.FOV = AC130.FOV.NARROW
    end
end

function AC130:SetFOV(FOV)
    self.FOV = FOV
end

function AC130:GetFOV()
    return self.FOV
end

function AC130:SetZoomLevel(value)
    if value < 1 then value = 1 end
    if value > 9 then value = 9 end
    self.zoom_level = value
end

function AC130:GetZoomLevel()
    return self.zoom_level
end

function AC130:LookAt(coor)
    self.view_coordinate = coor
    MessageToAll("x: " .. tostring(coor:GetVec2().x) .. ", y: " .. tostring(coor:GetVec2().x), 1, true)
end

function AC130:TranslateViewCoordinate(distance, bearing)
    self.view_coordinate:Translate(distance, bearing)
end

function AC130:MoveTo(coord)
    local task = self:TaskOrbit(coord, self:GetCoordinate().y, self:GetVelocityMPS())
    --local task = self:RouteToVec2(coord:GetVec2(), self:GetVelocityMPS())
    self:SetTask(task)
    BASE:I(task)
end

function AC130:GetViewRadius()
    --- Some absolute magic fuckery going on with the numbers, but it kind of falls
    --- within in the ballpark of what's realistic
    local view_angle = self:GetViewAngle()
    local multiplier = 90 / view_angle

    local diameter = (self:GetAltitude(true)  / self.FOV) / self.zoom_level
    return (diameter / 2) * multiplier
end

function AC130:GetViewAngle()
    return UTILS.VecAngleFromTo(self:GetCoordinate():GetVec3(), self.view_coordinate:GetVec3())
end

function AC130:GetDistanceToViewCoordinate()
    return self:GetCoordinate():Get3DDistance(self.view_coordinate)
end

function AC130:GetScanTime()
    --- More magic numbers
    return self:GetViewRadius() / 20
end

function AC130:ScanArea(certainty)
    certainty = certainty or 1
    self:ScheduleOnce(self:GetScanTime(), self.__Scan, self)
    return math.pi * (self:GetViewRadius() ^ 2)
end


function AC130:__Attack(weapon_table, target, num_shots)
    local coords = {}
    if target.ClassName == "UNIT" then
        -- find moving vector, generate random points along this vector
        coords = { target.GetCoordinate()}
    elseif target.ClassName == "LINE" then
        local points = target:GetPointsInbetween(num_shots)
        BASE:I(points)
        for _, p in pairs(points) do
            table.add(coords, COORDINATE:NewFromVec2(p))
        end

    elseif target.ClassName == "COORDINATE" then
        for _=1, num_shots do
            local c = target:GetRandomCoordinateInRadius(10, 0.5)
            table.add(coords, c)
        end
    end

    local explosion_index = 1
    local timer = TIMER:New(
        function()
            coords[explosion_index]:Explosion(weapon_table.WARHEAD)
            explosion_index = explosion_index + 1
        end
    )

    timer:SetMaxFunctionCalls(num_shots)
    timer:Start(nil, weapon_table.FIRETIMER)
end



--- This just doesn't seem to do anything at all
function AC130:Attack(unit)
    unit = unit or self.currently_lased_unit
    self:KnowUnit(unit, true, true)
    local task = self:TaskAttackUnit(unit)
    self:PushTask(task)
end



function AC130:__Scan(...)
    for _, unit in pairs(CCMISSION.ALL_UNITS:GetSetObjects()) do
        if UTILS.IsInRadius(unit:GetVec2(), self.view_coordinate:GetVec2(), self:GetViewRadius()) then
            self:I(unit:GetName())
            table.insert_unique(self.currently_detected_units, unit)
        end
    end
end
