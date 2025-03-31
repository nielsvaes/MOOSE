local function set_tanker_altitude(group, altitude_in_feet)
    if type(altitude_in_feet == string) then
        altitude_in_feet = tonumber(altitude_in_feet)
    end

    local tanker = GROUP:FindByName(group)

    tanker:I(tanker:GetCoordinate())
    local p1 = COORDINATE:NewFromVec2(tanker:GetTaskRoute()[1])
    local p2 = COORDINATE:NewFromVec2(tanker:GetTaskRoute()[2])

    local altitude_in_meters = UTILS.FeetToMeters(altitude_in_feet)
    local speed_mps = tanker:GetVelocityMPS()

    local task = tanker:TaskOrbit(p1, altitude_in_meters, speed_mps, p2)
    tanker:PushTask(task)
    local tanker_task = tanker:EnRouteTaskTanker()
    tanker:PushTask(tanker_task)
    message_to_all("Tanker (" .. tanker:GetName() .. ") altitude set to " .. math.ceil(tostring(UTILS.MetersToFeet(altitude_in_meters))) .. " feet at " .. tostring(UTILS.MpsToKnots(speed_mps)))
    tanker:I("Tanker altitude set to " .. math.ceil(tostring(UTILS.MetersToFeet(altitude_in_meters))))
end

local function set_tanker_speed(group_name, ias_speed)
    if type(ias_speed == string) then
        ias_speed = tonumber(ias_speed)
    end

    local tanker = GROUP:FindByName(group_name)

    tanker:I(tanker:GetCoordinate())
    local p1 = COORDINATE:NewFromVec2(tanker:GetTaskRoute()[1])
    local p2 = COORDINATE:NewFromVec2(tanker:GetTaskRoute()[2])

    local altitude_in_meters = tanker:GetCoordinate()["y"]
    local speed = UTILS.KnotsToAltKIAS(ias_speed, UTILS.MetersToFeet(altitude_in_meters))

    local task = tanker:TaskOrbit(p1, altitude_in_meters, UTILS.KnotsToMps(speed), p2)
    tanker:PushTask(task)
    local tanker_task = tanker:EnRouteTaskTanker()
    tanker:PushTask(tanker_task)
    message_to_all("Tanker (" .. tanker:GetName() .. ") IAS speed at " .. math.ceil(tostring(UTILS.MetersToFeet(altitude_in_meters))) .. " feet set to " .. tostring(ias_speed), 20)
    tanker:I("Tanker speed set to " .. tostring(ias_speed))
end

local function make_tanker_speed_menu(toplevel_menu, tanker_name, coa)
    for a = 1, 4 do
        local first_digit_menu = MENU_COALITION:New(
                coa,
                tostring(a),
                toplevel_menu
        )
        for b = 0, 9 do
            local second_digit_menu = MENU_COALITION:New(
                    coa,
                    tostring(a) .. tostring(b),
                    first_digit_menu
            )
            for c = 0, 9 do
                local pick_speed_cmd = MENU_COALITION_COMMAND:New(
                        coa,
                        tostring(a) .. tostring(b) .. tostring(c),
                        second_digit_menu,
                        set_tanker_speed,
                        tanker_name, tostring(a) .. tostring(b) .. tostring(c)
                )
            end
        end
    end
end

local function make_tanker_altitude_menu(toplevel_menu, tanker_name, coa)
    for a = 1, 3 do
        local first_digit_menu = MENU_COALITION:New(
                coa,
                tostring(a),
                toplevel_menu
        )

        for b = 0, 9 do
            local second_digit_menu = MENU_COALITION:New(
                    coa,
                    tostring(a) .. tostring(b),
                    first_digit_menu
            )

            for c = 0, 900, 100 do
                if c == 0 then
                    c = "000"
                end
                local pick_altitude_cmd = MENU_COALITION_COMMAND:New(
                        coa,
                        tostring(a) .. tostring(b) .. tostring(c),
                        second_digit_menu,
                        set_tanker_altitude,
                        tanker_name,
                        tostring(a) .. tostring(b) .. tostring(c)
                )
            end
        end
    end
end

local blue_tanker_menu = MENU_COALITION:New(
        coalition.side.BLUE,
        "Tankers"
)

local red_tanker_menu = MENU_COALITION:New(
        coalition.side.RED,
        "Tankers"
)


for _, group in pairs(SET_GROUP:New():FilterCategoryAirplane():FilterOnce():GetSetObjects()) do
    if group:GetTypeName() == "KC135MPRS" or group:GetTypeName() == "KC-135" then
        local group_name = group:GetName()
        local group_coalition = group:GetCoalition()
        local callsign = group:GetCallsign()
        
        local tanker_menu = blue_tanker_menu
        
        if group_coalition == coalition.side.RED then
            tanker_menu = red_tanker_menu
        end
        
        local specific_tanker_menu = MENU_COALITION:New(
                group_coalition,
                callsign,
                tanker_menu
        )

        local speed_menu = MENU_COALITION:New(
                group_coalition,
                "Speed",
                specific_tanker_menu
        )

        local altitude_menu = MENU_COALITION:New(
                group_coalition,
                "Altitude",
                specific_tanker_menu
        )

        make_tanker_speed_menu(speed_menu, group_name, group_coalition)
        make_tanker_altitude_menu(altitude_menu, group_name, group_coalition)        
    end
end

