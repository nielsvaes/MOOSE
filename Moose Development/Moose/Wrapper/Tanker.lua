
TANKER = {
    ClassName = "TANKER",
    Infinite = 9999999
}

function TANKER:FindByName(unit_name)
    -- inheriting from UNIT:FindByName() just hard crashes DCS...?
    self = BASE:Inherit(self, BASE:New())
    self.unit = UNIT:FindByName(unit_name)
    self.group = self.unit:GetGroup()
    if self.unit == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end

    self:I({self.group:GetTaskRoute()[1], self.group:GetTaskRoute()[2]})

    self.remaining_fuel = 202800
    self.transfer_rate = 50
    self.__start_tick_count = 0
    self.max_fuel_allowed = self.Infinite
    self.menu_commands = {}
    self.unit_fuel_given_info_dict = {}
    self.seconds_between_refuels = 30 * 60
    self.timer = nil
    self.next_waypoint = self:GetWaypointInSight()
    self.previous_waypoint = nil
    self.turn_announced = true

    GAMELOOPFUNCTION:New(self.UpdateNextWaypoint, {self}, -1, nil, 1, true):Add()

    self.root_menu = nil
    self.fuel_amount_menu = nil
    self.speed_menu = nil
    self.altitude_menu = nil

    self:HandleEvent(EVENTS.Refueling,     self._RefuelingStart)
    self:HandleEvent(EVENTS.RefuelingStop)
    self:HandleEvent(EVENTS.Hit)
    self:I("Tanker created!")

    return self
end

function TANKER:GetRemainingFuel()
    return self.remaining_fuel
end

function TANKER:SetMaxFuelAllowed(value)
    self.max_fuel_allowed = value
end

function TANKER:MoveTo(coord)
    local task = self:TaskOrbit(coord, self:GetCoordinate().y, self:GetVelocityMPS())
    --local task = self:RouteToVec2(coord:GetVec2(), self:GetVelocityMPS())
    self.unit:SetTask(task)
    BASE:I(task)
end

-- TODO: Needs some work
function TANKER:GetWaypointInSight()
    -- We're assuming a racetrack orbit for a tanker
    local route = {self.group:GetTaskRoute()[1], self.group:GetTaskRoute()[2]}
    local heading = self.unit:GetHeading()
    BASE:I(heading)
    local vec2 = self.unit:GetVec2()

    local alpha_start = math.rad(heading - 45)
    local start_x = self.Infinite * math.cos(UTILS.ClampAngle(alpha_start)) + vec2.x
    local start_y = self.Infinite * math.sin(UTILS.ClampAngle(alpha_start)) + vec2.y


    local alpha_end = math.rad(heading + 45)
    local end_x = self.Infinite * math.cos(UTILS.ClampAngle(alpha_end)) + vec2.x
    local end_y = self.Infinite * math.sin(UTILS.ClampAngle(alpha_end)) + vec2.y



    --local end_x   = math.cos(math.rad(UTILS.ClampAngle(heading + 20))) * self.Infinite
    --local end_y   = math.sin(math.rad(UTILS.ClampAngle(heading + 20))) * self.Infinite

    self:I("vec 2")
    self:I(vec2)
    self:I("start")
    self:I({x=start_x, y=start_y})
    self:I("end")
    self:I({x=end_x, y=end_y})


    for index, pt in pairs(route) do
        if CIRCLE:PointInSector(pt, {x=start_x, y=start_y}, {x=end_x, y=end_y}, vec2, self.Infinite) then
            self:I({x=route[index].x, y=route[index].y})
            return route[index]
        end
    end
end

function TANKER:UpdateNextWaypoint()
    self.next_waypoint = self:GetWaypointInSight()
    local distance
    if self.next_waypoint ~= nil then
        local unit_vec2 = self.unit:GetVec2()
        distance = ((unit_vec2.x - self.next_waypoint.x) ^ 2 + (unit_vec2.y - self.next_waypoint.y) ^ 2) ^ 0.5
    else
        distance = self.Infinite
    end

    if distance < UTILS.NMToMeters(0.5) and self.next_waypoint ~= self.previous_waypoint and self.next_waypoint ~= nil then
        BASE:I("Turn coming up in half a mile!")
        self.previous_waypoint = self.next_waypoint
    else
        self:I(UTILS.MetersToNM(distance))
    end
end

function TANKER:GetName()
    return self.unit:GetName()
end

function TANKER:GetMaxAllowedConnectedTime()
    return self.max_fuel_allowed / self.transfer_rate
end

function TANKER:GetFuelGivenInfoDict()
    return self.unit_fuel_given_info_dict
end

function TANKER:Update(unit_name)
    if not table.contains_key(self.unit_fuel_given_info_dict, unit_name) then
        self:I("I have no record of this unit, creating: " .. unit_name)
        self.unit_fuel_given_info_dict[unit_name] = {
            fuel_time = timer.getTime(),
            fuel_given = 0
        }
    end

    self.remaining_fuel = self.remaining_fuel - self.transfer_rate
    local total_fuel_given = self.unit_fuel_given_info_dict[unit_name].fuel_given + self.transfer_rate
    self:I("fuel given: " .. tostring(total_fuel_given))

    self.unit_fuel_given_info_dict[unit_name].fuel_time = timer.getAbsTime()
    self.unit_fuel_given_info_dict[unit_name].fuel_given = total_fuel_given

    if total_fuel_given >= self.max_fuel_allowed then
        DevMessageToAll("Alright, you should have received all the fuel you requested " .. tostring(self.max_fuel_allowed))
        self:I("Alright, you should have received all the fuel you requested!")
        self.timer:Stop()
    end
end

function TANKER:PopCurrentTask()
    self.unit:PopCurrentTask()
end

function TANKER:SetSpeed(ias_speed)
    if type(ias_speed == string) then
        ias_speed = tonumber(ias_speed)
    end

    self.group:I(self.group:GetCoordinate())
    local p1 = COORDINATE:NewFromVec2(self.group:GetTaskRoute()[1])
    local p2 = COORDINATE:NewFromVec2(self.group:GetTaskRoute()[2])

    local altitude_in_meters = self.group:GetCoordinate()["y"]
    local speed = UTILS.KnotsToAltKIAS(ias_speed, UTILS.MetersToFeet(altitude_in_meters))

    local orbit_task = self.group:TaskOrbit(p1, altitude_in_meters, UTILS.KnotsToMps(speed), p2)
    self.group:PushTask(orbit_task)
    local tanker_task = self.group:EnRouteTaskTanker()
    self.group:PushTask(tanker_task)
    MessageToAll("Tanker (" .. self.group:GetName() .. ") IAS speed at " .. math.ceil(tostring(UTILS.MetersToFeet(altitude_in_meters))) .. " feet set to " .. tostring(ias_speed), 20)
    self.group:I("Tanker speed set to " .. tostring(ias_speed))
end

function TANKER:SetAltitude(altitude_in_feet)
    if type(altitude_in_feet == string) then
        altitude_in_feet = tonumber(altitude_in_feet)
    end

    self.group:I(self.group:GetCoordinate())
    local p1 = COORDINATE:NewFromVec2(self.group:GetTaskRoute()[1])
    local p2 = COORDINATE:NewFromVec2(self.group:GetTaskRoute()[2])

    local altitude_in_meters = UTILS.FeetToMeters(altitude_in_feet)
    local speed_mps = self.group:GetVelocityMPS()

    local orbit_task = self.group:TaskOrbit(p1, altitude_in_meters, speed_mps, p2)
    self.group:PushTask(orbit_task)
    local tanker_task = self.group:EnRouteTaskTanker()
    self.group:PushTask(tanker_task)
    MessageToAll("Tanker (" .. self.group:GetName() .. ") altitude set to " .. math.ceil(tostring(UTILS.MetersToFeet(altitude_in_meters))) .. " feet at " .. tostring(UTILS.MpsToKnots(speed_mps)))
    self.group:I("Tanker altitude set to " .. math.ceil(tostring(UTILS.MetersToFeet(altitude_in_meters))))
end

function TANKER:MakeMenus(parent_menu)
    self.root_menu = MENU_COALITION:New(
        coalition.side.BLUE,
        self.unit:GetName() .. " Tanker Menu",
        parent_menu
    )

    self.fuel_amount_menu = MENU_COALITION:New(
        coalition.side.BLUE,
        "How many pounds of fuel are you going to take?",
        self.root_menu
    )

    self.speed_menu = MENU_COALITION:New(
        coalition.side.BLUE,
        "Request IAS at the current ASL altitude",
        self.root_menu
    )

    self.altitude_menu = MENU_COALITION:New(
        coalition.side.BLUE,
        "Request ASL altitude",
        self.root_menu
    )

    for _, amount in pairs({ "2000", "3000", "4000", "5000", "6000", "7000", "8000", "Top off"}) do
        MENU_COALITION_COMMAND:New(
            coalition.side.BLUE,
            amount,
            self.fuel_amount_menu,
            function()
                if amount == "Top off" then
                    amount = self.Infinite
                end
                self.max_fuel_allowed = amount
            end
        )
    end

    local speed_data = { {2, 3, 4}, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9} }
    UTILS.NestedMenu(speed_data,
                     1,
                     self.speed_menu,
                     coalition.side.BLUE,
                     nil,
                     true,
                     function(speed) self:SetSpeed(speed) end)


    local altitude_data = { {0, 1, 2, 3}, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, {"000", 100, 200, 300, 400, 500, 600, 700, 800, 900} }
    UTILS.NestedMenu(altitude_data,
                     1,
                     self.altitude_menu,
                     coalition.side.BLUE,
                     nil,
                     true,
                     function(altitude) self:SetAltitude(altitude) end)
end

function TANKER:ClearRootMenu()
    self.root_menu:Remove()
    self.max_fuel_allowed = self.Infinite
end

function TANKER:ClearFuelMenu()
    self.fuel_amount_menu:Remove()
    self.max_fuel_allowed = self.Infinite
end

function TANKER:ClearSpeedMenu()
    self.speed_menu:Remove()
end

function TANKER:ClearAltitudeMenu()
    self.altitude_menu:Remove()
end

function TANKER:_RefuelingStart(event_data)
    self:I(event_data)
    self:I(event_data.IniUnit:GetName() .. " started refueling")
    self.timer = TIMER:New(self.Update, self, event_data.IniUnit:GetName())
    self.timer:Start(nil, 1)
end

function TANKER:OnEventRefuelingStop(event_data)
    self.timer:Stop()
    self.timer = nil
    self:I("Refueling stop called")
end

function TANKER:OnEventHit(event_data)
    self:I("I'm hit!!")
    self:I(event_data)
end
