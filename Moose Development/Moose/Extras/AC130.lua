
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
        NAME = "M102",
        WARHEAD = 15,
        FIRETIMER = 10,
        TRAVEL_TIME = 12,
        TRAVEL_TIME_DIVIDER = 1750,
        Y = 0,
        ERROR_IN_FEET = 15
    },
    BOFORS = {
        NAME = "Bofors",
        WARHEAD = 6,
        FIRETIMER = 0.5,
        TRAVEL_TIME = 10,
        TRAVEL_TIME_DIVIDER = 2100,
        Y = 3,
        ERROR_IN_FEET = 25
    },
    GAU12 = {
        NAME = "GAU12",
        WARHEAD = 3,
        FIRETIMER = 0.0035,
        TRAVEL_TIME = 9,
        TRAVEL_TIME_DIVIDER = 3000,
        Y = 10,
        ERROR_IN_FEET = 35
    },
}

function AC130:FindByName(unit_name)
    local self = BASE:Inherit(self, UAV:FindByName(unit_name))
    if self == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end

    return self
end

function AC130:Attack(weapon_table, target, num_shots, use_line, line_length, respect_weapon_travel_time)
    BASE:I("Firing... ")
    respect_weapon_travel_time = respect_weapon_travel_time or false

    local travel_time = 0
    if respect_weapon_travel_time then
        travel_time = UTILS.MetersToFeet(self:GetAltitude(true)) / weapon_table.TRAVEL_TIME_DIVIDER
    end
    local heading = 0
    local target_coordinate
    local projectile_impact_coordinates = {}
    use_line = use_line or false
    line_length = line_length or 20


    if target.ClassName == "COORDINATE" then
        target_coordinate = target
    elseif target.ClassName == "UNIT" then
        heading = target:GetHeading()
        target_coordinate = target:GetCoordinate()
    end

    if use_line then
        local line = LINE:NewFromCircle(target_coordinate:GetVec2(), line_length / 2, heading)
        local points = line:GetPointsInbetween(num_shots)
        for _, p in pairs(points) do
            local impact_coord = COORDINATE:NewFromVec2(p):Translate(math.random(0, UTILS.FeetToMeters(weapon_table.ERROR_IN_FEET)), math.random(0, 360))
            impact_coord.y = impact_coord.y - weapon_table.Y
            table.add(projectile_impact_coordinates, impact_coord)
        end
    else
        for _=1, num_shots do
            local impact_coord = target_coordinate:Translate(math.random(0, UTILS.FeetToMeters(weapon_table.ERROR_IN_FEET)), math.random(0, 360))
            impact_coord.y = impact_coord.y - weapon_table.Y
            table.add(projectile_impact_coordinates, impact_coord)
        end
    end

    if weapon_table.NAME == "GAU12" then
        local center = math.floor(#projectile_impact_coordinates / 2)
        local range = 10

        local num_elements = math.max(math.floor(#projectile_impact_coordinates / 15), 1)
        local start_index = math.max(center - range, 1)
        local end_index = math.min(center + range, #projectile_impact_coordinates)

        for _=1, num_elements do
            local random_index = math.random(start_index, end_index)
            projectile_impact_coordinates[random_index].y = target_coordinate.y
        end
    end

    BASE:I("Rounds impacting in " .. tostring(travel_time) .. " seconds")
    local explosion_index = 1
    local timer = TIMER:New(
        function()
            projectile_impact_coordinates[explosion_index]:Explosion(weapon_table.WARHEAD)
            explosion_index = explosion_index + 1
        end
    )

    timer:SetMaxFunctionCalls(num_shots)
    timer:Start(travel_time, weapon_table.FIRETIMER)
end

function AC130:__Scan(...)
    for _, unit in pairs(CCMISSION.ALL_UNITS:GetSetObjects()) do
        if UTILS.IsInRadius(unit:GetVec2(), self.view_coordinate:GetVec2(), self:GetViewRadius()) then
            self:I(unit:GetName())
            table.insert_unique(self.currently_detected_units, unit)
        end
    end
end
