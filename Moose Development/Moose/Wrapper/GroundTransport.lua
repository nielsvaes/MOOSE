GROUND_TRANSPORT = {
    ClassName = "GROUND_TRANSPORT",
}

GROUND_TRANSPORT.PASSENGERS = {
    ins = {CCGROUND_UNITS.INFANTRY.InfantryAKIns},
    sol = {CCGROUND_UNITS.INFANTRY.InfantryAK, CCGROUND_UNITS.INFANTRY.ParatrooperRPG16},
    iaa = {CCGROUND_UNITS.INFANTRY.InfantryAKIns, CCGROUND_UNITS.INFANTRY.InfantryAKIns, CCGROUND_UNITS.INFANTRY.InfantryAKIns, CCGROUND_UNITS.INFANTRY.InfantryAKIns, CCGROUND_UNITS.ANTIAIR.SA8}, -- lazy way to force only 1/5 carry AA
    saa = {CCGROUND_UNITS.INFANTRY.InfantryAK, CCGROUND_UNITS.INFANTRY.InfantryAKIns, CCGROUND_UNITS.INFANTRY.ParatrooperRPG16}, CCGROUND_UNITS.ANTIAIR.SA8,
}

GROUND_TRANSPORT.PASSENGERS.ACTIONS = {
    RUN,


}

-- 1 -> 0, less is better
GROUND_TRANSPORT.ARMOR_RATING = {
    light = 0.75,
    medium = 0.35,
    heavy = 0.15,
    invincible = 0
}

GROUND_TRANSPORT.METADATA = {
    UNDEFINED = {
        pass = 4,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.8,
        length = 4.2,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light
    },
    ---------------------------------------------------------


    [CCGROUND_UNITS.UNARMED.GAZ3307] = {
        pass = 18,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.GAZ3308] = {
        pass = 18,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.GAZ66] = {
        pass = 2,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.KAMAZTruck]= {
        pass = 22,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.KrAZ6322] = {
        pass = 2,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.M818] = {
        pass = 26,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.Ural375] = {
        pass = 2,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.Ural375PBU] = {
        pass = 6,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.Ural432031] = {
        pass = 18,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.Ural4320APA5D] = {
        pass = 4,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.Ural4320T] = {
        pass = 16,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.ZIL131KUNG] = {
        pass = 10,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.ZIL135] = {
        pass = 3,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.ZiL131APA80] = {
        pass = 3,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.LAZBus] = {
        pass = 38,
        exit_left = true,
        exit_right = false,
        exit_back = false,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.LiAZBus] = {
        pass = 32,
        exit_left = true,
        exit_right = false,
        exit_back = false,
        width = 2.4,
        length = 6.5,
        armor = GROUND_TRANSPORT.ARMOR_RATING.light

    },
    [CCGROUND_UNITS.UNARMED.Hummer] = {
        pass = 4,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.8,
        length = 4.2,
        armor = GROUND_TRANSPORT.ARMOR_RATING.medium
    },


    --------------------------------------------------
    [CCGROUND_UNITS.ARMOR.TPZ] = {
        pass = 20,
        exit_left = false,
        exit_right = false,
        exit_back = true,
        width = 2.8,
        length = 6,
        armor = GROUND_TRANSPORT.ARMOR_RATING.heavy
    },

    [CCGROUND_UNITS.ARMOR.AAV7] = {
        pass = 25,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.8,
        length = 4.2,
        armor = GROUND_TRANSPORT.ARMOR_RATING.heavy
    },
    [CCGROUND_UNITS.ARMOR.BTR80] = {
        pass = 10,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.8,
        length = 4.2,
        armor = GROUND_TRANSPORT.ARMOR_RATING.heavy
    },
    [CCGROUND_UNITS.ARMOR.BTR_D] = {
        pass = 13,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.8,
        length = 4.2,
        armor = GROUND_TRANSPORT.ARMOR_RATING.heavy
    },
    [CCGROUND_UNITS.ARMOR.M113] = {
        pass = 11,
        exit_left = true,
        exit_right = true,
        exit_back = true,
        width = 2.8,
        length = 4.2,
        armor = GROUND_TRANSPORT.ARMOR_RATING.medium
    },
}

function GROUND_TRANSPORT:FindByName(unit_name, meta_data)
    self = BASE:Inherit(self, UNIT:FindByName(unit_name))
    if self == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end

    self.base_name = string.match(unit_name, "(.*)__")
    self.meta_data = self:__EnsureMetaData(meta_data)
    self.passenger_groups = {}
    self.time_between_hit_checks = 0.85
    self.hit_time_last_checked = timer.getTime()

    self:GeneratePassengers()
    self:HandleEvent(EVENTS.Hit)
    self:HandleEvent(EVENTS.Dead)



    return self
end

function GROUND_TRANSPORT:GeneratePassengers()
    local passenger_table = GROUND_TRANSPORT.PASSENGERS[self.meta_data["type"]]
    local max_group_size = self.meta_data["grp_size"]
    local max = self.meta_data["max"]
    self:I("Max passengers: " .. tostring(max))
    self:I(max)

    local fill = self.meta_data["fill"]
    if fill == -1 or fill == nil then fill = math.random(1, max) end
    if fill > max then fill = max end
    self:I("Filling " .. tostring(fill) .. " seats")

    while fill > 0 do
        self:I(tostring(fill) .. " remaining")
        if max_group_size > fill then
            max_group_size = fill
        end

        local group_size = math.random(1, max_group_size)
        local random_type = passenger_table[math.random(1, #passenger_table)]
        local unit_table = CCMISSIONDB:Get():GenerateGroundUnits(random_type, self.base_name .. "_pass", group_size)
        local grp_table  = CCMISSIONDB:Get():GenerateGroundGroup(UTILS.UniqueName(self.base_name .. "_grp"), unit_table)
        local moose_grp  = CCMISSIONDB:Get():Add(grp_table, Group.Category.GROUND, self:GetCountry(), self:GetCoalition())
        table.insert(self.passenger_groups, moose_grp)
        fill = fill - group_size
        self:I("Added " .. tostring(#unit_table) .. " units")
    end
end

function GROUND_TRANSPORT:__EnsureMetaData(meta_data)
    local meta_data_template = UTILS.DeepCopy(GROUND_TRANSPORT.METADATA[self:GetTypeName()] or UTILS.DeepCopy(GROUND_TRANSPORT.METADATA.UNDEFINED))
    meta_data_template.fill = -1
    meta_data_template.max = GROUND_TRANSPORT.METADATA[self:GetTypeName()]["pass"]
    meta_data_template.type = "ins"
    meta_data_template.grp_size = 7
    meta_data_template.run_pct = 50
    meta_data_template.stop_pct = 100

    if type(meta_data) == table then
        return meta_data
    end

    if meta_data == nil then
        meta_data = string.match(self:GetName(), "__(.*})")
        if meta_data == nil then
            return meta_data_template
        end

        meta_data = loadstring("return " .. meta_data)() or {}
        for _, var_name in pairs({"fill", "max", "type", "grp_size", "run_pct", "stop_pct"}) do
            self:I("Checking " .. var_name)
            if meta_data[var_name] == nil then
                self:I(tostring(var_name) .. " was nil in the meta data, using the template to set this value")
                meta_data[var_name] = meta_data_template[var_name]
            end
            self:I("value set to " .. tostring(meta_data[var_name]))
        end
        self:I(meta_data)
        meta_data = table.merge(meta_data, GROUND_TRANSPORT.METADATA[self:GetTypeName()])
        self:I(meta_data)
        return meta_data
    end
end

function GROUND_TRANSPORT:Stop()
    self:RouteStop()
    self:OptionROE(ENUMS.ROE.WeaponHold)
    self:OptionAlarmStateGreen()
end

function GROUND_TRANSPORT:Disembark(num_groups, side_string, time_between_groups, initial_delay)
    if not self:IsAlive() then
        self:E("Can't disembark passengers because I'm not alive: " .. self:GetName())
    end

    local location = {
        ["left"]  = self.GetLeftSideCoordinate ,
        ["right"] = self.GetRightSideCoordinate,
        ["front"] = self.GetFrontSideCoordinate,
        ["back"]  = self.GetBackSideCoordinate ,
    }

    time_between_groups = time_between_groups or 2
    initial_delay = initial_delay or math.random(3, 7)
    side_string = side_string or "right"
    num_groups = num_groups or math.random(1, #self.passenger_groups)
    if num_groups == "all" then num_groups = #self.passenger_groups end

    local disembarked_groups = {}

    local function disembark()
        local group = table.remove(self.passenger_groups, 1)
        self:I(group:GetName() .. " getting out")

        local spawned_group = SPAWN:NewWithAlias(group:GetName(), UTILS.UniqueName(group:GetName()))
                                   :InitRandomizeUnits(true, 1, 0.5)
                                   :SpawnFromVec2(location[side_string](self):GetVec2())
        self:I(spawned_group:GetName())

        self:I("remaining units in vehicle: " .. tostring(#self:GetPassengerUnits()))
        
        if UTILS.PercentageChance(self.meta_data.run_pct) then
            self:I("We're running!")
            local random_distance = math.random(50, 300)
            local random_heading = math.random(0, 360)
            self:I(random_distance)
            self:I(random_heading)

            local run_to_point = self:GetCoordinate():Translate(random_distance, random_heading):GetVec2()
            local run_task = spawned_group:TaskRouteToVec2(run_to_point)
            --spawned_group:PushTask(run_task, 0.75)
        end

        disembarked_groups[#disembarked_groups + 1] = spawned_group
    end

    if #self.passenger_groups >= 1 then
        local timer = TIMER:New(disembark)
        timer:SetMaxFunctionCalls(num_groups)
        timer:Start(nil, time_between_groups)
    end

    return disembarked_groups
end

function GROUND_TRANSPORT:GetMaxSeats()
    return self.meta_data["max"]
end

function GROUND_TRANSPORT:GetPassengerType()
    return GROUND_TRANSPORT.PASSENGERS[self.meta_data["type"]]
end

function GROUND_TRANSPORT:GetGroupSize()
    return self.meta_data["grp_size"]
end

function GROUND_TRANSPORT:GetPassengerGroups()
    return self.passenger_groups
end

function GROUND_TRANSPORT:GetPassengerUnits()
    local all_units = {}
    for _, group in pairs(self.passenger_groups) do
        for _, unit in pairs(group:GetUnits()) do
            all_units[#all_units + 1] = unit
        end
    end
    return all_units
end

function GROUND_TRANSPORT:GetNumEmptySeats()
    local total_units = 0
    for _, group in pairs(self.passenger_groups) do
        total_units = total_units + #group:GetUnits()
    end
    return self:GetMaxSeats() - total_units
end

function GROUND_TRANSPORT:GetNumOccupiedSeats()
    local total_units = 0
    for _, group in pairs(self.passenger_groups) do
        total_units = total_units + #group:GetUnits()
    end
    return total_units
end

function GROUND_TRANSPORT:Load(group)
    table.insert(self.passenger_groups, group)
end

function GROUND_TRANSPORT:GetRightSideCoordinate(pos_offset, heading_offset)
    heading_offset = heading_offset or math.random(-3, 3)

    local width = self.meta_data.width
    pos_offset = pos_offset or math.random(1, 1.5)
    return self:GetCoordinate():Translate(width + pos_offset, self:GetHeading() + 90 + heading_offset)
end

function GROUND_TRANSPORT:GetLeftSideCoordinate(pos_offset, heading_offset)
    heading_offset = heading_offset or math.random(-3, 3)

    local width = self.meta_data.width
    pos_offset = pos_offset or math.random(1, 1.5)
    return self:GetCoordinate():Translate(width + pos_offset, self:GetHeading() + 270 + heading_offset)
end

function GROUND_TRANSPORT:GetBackSideCoordinate(pos_offset, heading_offset)
    heading_offset = heading_offset or math.random(-3, 3)

    local length = self.meta_data.length
    pos_offset = pos_offset or math.random(1, 1.5)
    return self:GetCoordinate():Translate(length + pos_offset, self:GetHeading() + 180 + heading_offset)
end

function GROUND_TRANSPORT:GetFrontSideCoordinate(pos_offset, heading_offset)
    heading_offset = heading_offset or math.random(-3, 3)

    local length = self.meta_data.length
    pos_offset = pos_offset or math.random(1, 1.5)
    return self:GetCoordinate():Translate(length + pos_offset, self:GetHeading() + heading_offset)
end

function GROUND_TRANSPORT:OnEventHit(event_data)
    if not self:IsAlive() then
        return
    end

    -- don't check every bullet
    if timer.getTime() < self.hit_time_last_checked + self.time_between_hit_checks then
        return
    end

    local units = self:GetPassengerUnits()
    if #units == 0 then
        self:Stop()
        return
    end

    local armor_rating = GROUND_TRANSPORT.METADATA[self:GetTypeName()]["armor"]
    local driver_hit = UTILS.PercentageChance(math.random(0, 50 * armor_rating))

    if UTILS.PercentageChance(self.meta_data.stop_pct) or driver_hit then
        self:Stop()
        self:Disembark()
    end

    local chance_units_hit = math.random(0, 75) * armor_rating
    if UTILS.PercentageChance(chance_units_hit) then
        self:I("Units hit!")
        self:I("Current units left: " .. tostring(#units))
        local num_to_kill = math.random(0, math.floor(#units / 3)) -- leaving 0 to simulate just getting hurt
        self:I("We're gonna kill': " .. tostring(num_to_kill))
        for _=1, num_to_kill do
            units[math.random(1, #units)]:Destroy()
            units = self:GetPassengerUnits()
        end
    end
    self.hit_time_last_checked = timer.getTime()
end

function GROUND_TRANSPORT:OnEventDead(event_data)
    self:I("dead event!")
    self:GetController()
end
