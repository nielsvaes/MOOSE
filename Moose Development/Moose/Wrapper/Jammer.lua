DEV_LOCATION_GUESS_MULTI  = 2



JAMMER = {
    ClassName = "JAMMER",
    JamRate = 1
}

JAMMER.SKILL_INFO = {
    ["Average"] = {
        penalty = 2,
        recovery_time = 1.55
    },
    ["Good"] = {
        penalty = 8,
        recovery_time = 1.35
    },
    ["High"] = {
        penalty = 10,
        recovery_time = 1.2
    },
    ["Excellent"] = {
        penalty = 12,
        recovery_time = 0.9
    },
    ["Random"] = {
        penalty = math.random(2, 12),
        recovery_time = math.random(0.3,  0.9)
    }
}

JAMMER.RADAR_INFO = {
    --- EWRs
    ["1L13 EWR"] = {
        burn_through_range = 30,
        memory_time = 10,
        engage_distance = 0,
        track_distance = 100,
        weapon_identify_ability = 1,
        can_shoot_down_weapon = false
    },
    ["55G6 EWR"] = {
        burn_through_range = 30,
        memory_time = 10,
        engage_distance = 0,
        track_distance = 100,
        weapon_identify_ability = 1,
        can_shoot_down_weapon = false
    },

    --- Short range
    ["Dog Ear radar"] = {
        burn_through_range = 11,
        memory_time = 6,
        engage_distance = 0,
        track_distance = 19,
        weapon_identify_ability = 1,
        can_shoot_down_weapon = false
    },
    ["M48 Chaparral"] = {
        memory_time = 5,
        engage_distance = 4.5,
        track_distance = 5,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["M6 Linebacker"] = {
        burn_through_range = 3,
        memory_time = 6,
        engage_distance = 2.4,
        track_distance = 4.3,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Osa 9A33 ln"] = {  -- SA-8
        burn_through_range = 12,
        memory_time = 6,
        engage_distance = 5.45,
        track_distance = 16.18,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Tor 9A331"] = {   -- SA-15
        burn_through_range = 8,
        memory_time = 8,
        engage_distance = 6.5,
        track_distance = 13.5,
        weapon_identify_ability = 95,
        can_shoot_down_weapon = true
    },
    ["2S6 Tunguska"] = {   -- SA-19
        burn_through_range = 7,
        memory_time = 8,
        engage_distance = 4.28,
        track_distance = 9.76,
        weapon_identify_ability = 95,
        can_shoot_down_weapon = true
    },

    --- HAWK
    ["Hawk cwar"] = {
        memory_time = 8,
        engage_distance = 0,
        track_distance = 37.8,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Hawk ln"] = {
        memory_time = 0,
        engage_distance = 24.2,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Hawk sr"] = {
        burn_through_range = 30,
        memory_time = 8,
        engage_distance = 0,
        track_distance = 48.6,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Hawk tr"] = {
        burn_through_range = 26,
        memory_time = 8,
        engage_distance = 0,
        track_distance = 48.4,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- NASAMS
    ["NASAMS_Radar_MPQ64F1"] = {
        burn_through_range = 15,
        memory_time = 8,
        engage_distance = 8.1,
        track_distance = 27.3,
        weapon_identify_ability = 3,
        can_shoot_down_weapon = false
    },
    ["NASAMS_LN_C"] = {
        memory_time = 0,
        engage_distance = 8.1,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["NASAMS_LN_B"] = {
        memory_time = 0,
        engage_distance = 0,
        track_distance = 8.1,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- Patriot
    ["Patriot AMG"] = {
        memory_time = 0,
        engage_distance = 0,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Patriot ECS"] = {
        memory_time = 0,
        engage_distance = 0,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Patriot EPP"] = {
        memory_time = 0,
        engage_distance = 0,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Patriot str"] = {
        burn_through_range = 40,
        memory_time = 8,
        engage_distance = 0,
        track_distance = 105,
        weapon_identify_ability = 3,
        view_angle = 110,
        can_shoot_down_weapon = false
    },

    --- Rapier
    ["rapier_fsa_blindfire_radar"] = {
        burn_through_range = 9,
        memory_time = 5,
        engage_distance = 3.6,
        track_distance = 16.3,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["rapier_fsa_launcher"] = {
        memory_time = 0,
        engage_distance = 3.6,
        track_distance = 16.3,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["rapier_fsa_optical_tracker_unit"] = {
        memory_time = 5,
        engage_distance = 0,
        track_distance = 11,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- Roland
    ["Roland ADS"] = {
        memory_time = 5,
        engage_distance = 4.29,
        track_distance = 6.4,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Roland Radar"] = {
        burn_through_range = 9,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 18.9,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- HQ-7
    ["HQ-7_STR_SP"] = {
        burn_through_range = 11,
        memory_time = 5,
        engage_distance = 6.5,
        track_distance = 16.1,
        weapon_identify_ability = 3,
        can_shoot_down_weapon = false
    },
    ["HQ-7_LN_SP"] = {
        memory_time = 5,
        engage_distance = 6.5,
        track_distance = 16.1,
        weapon_identify_ability = 3,
        can_shoot_down_weapon = false
    },


    --- SA-2
    ["SNR_75V"] = {
        burn_through_range = 22,
        memory_time = 10,
        engage_distance = 0,
        track_distance = 54,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["S_75M_Volhov"] = {
        memory_time = 10,
        engage_distance = 23,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["p-19 s-125 sr"] = {
        burn_through_range = 26,
        memory_time = 8,
        engage_distance = 0,
        track_distance = 86,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- SA-3
    ["5p73 s-125 ln"] = {
        memory_time = 0,
        engage_distance = 9.7,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["snr s-125 tr"] = {
        burn_through_range = 21,
        memory_time = 10,
        engage_distance = 0,
        track_distance = 54,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- SA-5
    ["S-200_Launcher"] = {
        memory_time = 0,
        engage_distance = 136,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["RPC_5N62V"] = {   -- TR
        burn_through_range = 38,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 216,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["RLS_19J6"] = {   -- TR
        burn_through_range = 31,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 81,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- SA-6
    ["Kub 1S91 str"] = {
        burn_through_range = 16,
        memory_time = 6,
        engage_distance = 11,
        track_distance = 28,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    ["Kub 2P25 ln"] = {
        memory_time = 0,
        engage_distance = 13,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- SA-10
    ["S-300PS 64H6E sr"] = {
        burn_through_range = 26,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 85.7,
        weapon_identify_ability = 98,
        can_shoot_down_weapon = false
    },
    ["S-300PS 40B6MD sr"] = {
        burn_through_range = 16,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 32.1,
        weapon_identify_ability = 98,
        can_shoot_down_weapon = false
    },
    ["S-300PS 40B6M tr"] = {
        burn_through_range = 28,
        memory_time = 5,
        engage_distance = 64.7,
        track_distance = 85,
        weapon_identify_ability = 95,
        can_shoot_down_weapon = false
    },
    ["S-300PS 5P85D ln"] = {
        memory_time = 0,
        engage_distance = 64.7,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = true
    },
    ["S-300PS 5P85C ln"] = {
        memory_time = 0,
        engage_distance = 64.7,
        track_distance = 0,
        weapon_identify_ability = 95,
        can_shoot_down_weapon = true
    },

    --- SA-11
    ["SA-11 Buk SR 9S18M1"] = {
        burn_through_range = 25,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 53.5,
        weapon_identify_ability = 85,
        can_shoot_down_weapon = false
    },
    ["SA-11 Buk LN 9A310M1"] = {
        burn_through_range = 13,
        memory_time = 5,
        engage_distance = 19.2,
        track_distance = 26.6,
        weapon_identify_ability = 85,
        can_shoot_down_weapon = false
    },
}

function JAMMER:FindByName(unit_name, target_coalition_name)
    self = BASE:Inherit(self, UNIT:FindByName(unit_name))
    if self == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end

    self.target_units = SET_UNIT:New()
                                :FilterCoalitions(string.lower(target_coalition_name))
                                :FilterStart()

    self.__detect_range        = UTILS.NMToMeters(50)
    self.__barrage_range       = UTILS.NMToMeters(25)
    self.__initial_major_axis  = UTILS.NMToMeters(10)
    self.__initial_minor_axis  = UTILS.NMToMeters(4)
    self.__min_major_axis      = UTILS.NMToMeters(2)
    self.__min_minor_axis      = UTILS.NMToMeters(0.5)
    self.__total_strength      = 100


    self.__num_jamming_pods    = 1
    self.__power               = 100 * self.__num_jamming_pods

    self.__types_to_jam        = {}
    self.__spot_jam_pos        = {x=999999, y=999999}
    self.__spot_jam_radius     = UTILS.NMToMeters(2)
    self.__passive_collect_glf = GAMELOOPFUNCTION:New(self.PassiveDetect, { self}, -1, UTILS.UniqueName(self:GetName() .. "_detect"), 1/3):Add()
    self.__spot_jam_glf        = nil

    self.info_dict = {}
    self.center_jam_coordinates = {}

    self.tmp_mark_ids = {}

    return self
end

function JAMMER:SetDetectRange(value)
    self.__detect_range = UTILS.NMToMeters(value)
end

function JAMMER:SetInitialMajorAxis(value)
    self.__initial_major_axis = UTILS.NMToMeters(value)
end

function JAMMER:SetInitialMinorAxis(value)
    self.__initial_minor_axis = UTILS.NMToMeters(value)
end

function JAMMER:PassiveDetect()
    local targets = {}

    self.target_units:ForEachUnit(
        function(target_unit)
            local target_pos = target_unit:GetVec2()
            if UTILS.IsInRadius(target_pos, self:GetVec2(), self.__detect_range) and target_unit:GetRadar() and self:HasLineOfSight(target_unit:GetVec3()) then
                self:UpdateRadarUnitInfo(target_unit)
                self:GuessLocation(target_unit)
            end
        end
    )

    return targets
end

function JAMMER:UpdateRadarUnitInfo(radar_unit)
    if not table.contains_key(self.info_dict, radar_unit) then
        local initial_heading = UTILS.HdgTo(self:GetVec3(), radar_unit:GetVec3())
        self.info_dict[radar_unit] = {
            actual_pos = radar_unit:GetVec2(),
            guessed_pos = {x=999999, y=999999},
            final_guessed_pos = nil,
            scan_headings = { initial_heading, initial_heading },
            times_scanned = 1,
            oval = OVAL:New(radar_unit:GetVec2(),
                            self.__initial_major_axis,
                            self.__initial_minor_axis,
                            UTILS.HdgTo(self:GetVec3(), radar_unit:GetVec3())),
            circle = CIRCLE:New(radar_unit:GetVec2(), self.__min_minor_axis),
            turn_off_on_jam = nil,
        }
        return
    end

    self.info_dict[radar_unit].scan_headings[1] = self.info_dict[radar_unit].scan_headings[2]
    self.info_dict[radar_unit].scan_headings[2] = UTILS.HdgTo(self:GetVec3(), radar_unit:GetVec3())
    self.info_dict[radar_unit].times_scanned    = self.info_dict[radar_unit].times_scanned + 1
    self.info_dict[radar_unit].oval:SetAngle(self.info_dict[radar_unit].scan_headings[2])
end

function JAMMER:GuessLocation(unit)
    local unit_info = self.info_dict[unit]

    -- we don't have a extremely good position yet, so continue trying to refine
    if unit_info.oval:GetMajorAxis() > self.__min_major_axis and unit_info.oval:GetMinorAxis() > self.__min_minor_axis then
        local previous = unit_info.scan_headings[1]
        local new = unit_info.scan_headings[2]
        if new < previous then
            new = new + 360
        end

        local diff = (360 - (new - previous)) % 360

        local major_axis_decrease = diff * 40 * DEV_LOCATION_GUESS_MULTI
        local minor_axis_decrease = diff * 18 * DEV_LOCATION_GUESS_MULTI

        unit_info.oval:SetMajorAxis(UTILS.Clamp(unit_info.oval:GetMajorAxis() - major_axis_decrease, self.__min_major_axis, 9999999))
        unit_info.oval:SetMinorAxis(UTILS.Clamp(unit_info.oval:GetMinorAxis() - minor_axis_decrease, self.__min_minor_axis, 9999999))

        unit_info.guessed_pos = unit_info.oval:GetRandomVec2()
    else
        -- we were able to refine the location enough to get a pretty accurate location
        unit_info.guessed_pos = unit_info.oval:GetRandomVec2()
    end
end

function JAMMER:PossibleToJamUnit(unit, jamming_location, jamming_types, radius)
    local is_radar_unit = false
    if unit:HasAttribute("SAM TR") or unit:HasAttribute("SAM TR") or unit:HasAttribute("EWR") then
        is_radar_unit = true
    else
        return false
    end

    local is_in_jam_radius          = UTILS.IsInRadius(unit:GetVec2(), jamming_location, radius)
    local has_line_of_sight         = self:HasLineOfSight(unit:GetVec3())
    local type_targeted             = table.contains(jamming_types, unit:GetTypeName())
    local not_in_burn_through_range = not UTILS.IsInSphere(unit:GetVec3(), self:GetVec3(), UTILS.NMToMeters(JAMMER.RADAR_INFO[unit:GetTypeName()].burn_through_range))

    --self:I(is_in_jam_radius)
    --self:I(has_radar)
    --self:I(has_line_of_sight)
    --self:I(type_targeted)
    --self:I(not_in_burn_through_range)

    if is_in_jam_radius and is_radar_unit and has_line_of_sight and type_targeted and not_in_burn_through_range then
        return true
    end
    -- if any of these checks is false, the unit can not be jammed
    return false
end

function JAMMER:AttemptJam(unit, jam_percentage)
    local turn_off = self.info_dict[unit].turn_off_on_jam or 100 --UTILS.PercentageChance(50 + JAMMER.SKILL_INFO[unit:GetSkill()].penalty)
    BASE:I("Attempting jam of: " .. unit:GetName())
    if UTILS.PercentageChance(jam_percentage) then
        if turn_off then
            self.info_dict[unit].turn_off = true
            unit:EnableEmission(false)
            unit:OptionROEWeaponFree()
        else
            unit:EnableEmission(true)
            unit:OptionROEHoldFire()
        end
        JAMMER_MANAGER:Get():UpdateJammed(unit, self, turn_off, JAMMER.SKILL_INFO[unit:GetSkill()].recovery_time)
    else
        self:I("Couldn't be jammed")
    end
end

function JAMMER:__SpotJam()
    local effectiveness = self.__power - (3 * #self.__types_to_jam)

    self.target_units:ForEachUnit(
        function(target_unit)
            if self:PossibleToJamUnit(target_unit, self.__spot_jam_pos, self.__types_to_jam, self.__spot_jam_radius) then
                if not UTILS.IsInRadius(self.__spot_jam_pos, target_unit:GetVec2(), self.__spot_jam_radius / 2) then
                    effectiveness = effectiveness - 10
                end
                effectiveness = effectiveness - JAMMER.SKILL_INFO[target_unit:GetSkill()].penalty

                self:AttemptJam(target_unit, effectiveness)
            end
        end
    )
end

function JAMMER:StartSpotJamming(vec2, types, radius_in_NM)
    if vec2   ~= nil then self:SetSpotJamVec2(vec2) end
    if types  ~= nil then self.__types_to_jam = types end
    if radius_in_NM ~= nil then self:SetSpotJamRadius(radius_in_NM) end

    self:StopSpotJamming()
    self.__spot_jam_glf = GAMELOOPFUNCTION:New(self.__SpotJam, {self}, -1, nil, JAMMER.JamRate, true):Add()
end

function JAMMER:StopSpotJamming()
    GAMELOOP:Get():Remove(self.__spot_jam_glf)
end

function JAMMER:AddTypeToJam(radar_type_name)
    table.insert_unique(self.__types_to_jam, radar_type_name)
end

function JAMMER:SetSpotJamVec2(vec2)
    self.__spot_jam_pos = vec2
end

function JAMMER:SetSpotJamRadius(radius_in_NM)
    self.__spot_jam_radius = UTILS.NMToMeters(radius_in_NM)
end

function JAMMER:Orbit(coord)
    local task = self:TaskOrbit(coord, self:GetCoordinate().y, self:GetVelocityMPS())
    self:SetTask(task)
end

function JAMMER:HasLineOfSight(tgt_vec3)
    tgt_vec3.y = tgt_vec3.y + 5
    if land.isVisible(self:GetVec3(), tgt_vec3) then
        return true
    end
    return false
end

function JAMMER:DebugDraw()
    self:RemoveDebugDraw()

    -- draw radar locations
    for unit, unit_info in pairs(self.info_dict) do
        unit_info.oval.Angle = UTILS.HdgTo(unit:GetVec3(), self:GetVec3())
        unit_info.oval:Draw()

        table.add(self.tmp_mark_ids, COORDINATE:NewFromVec2(unit_info.guessed_pos):CircleToAll(300, -1, {0, 0, 1}, 1, {0, 0, 1}))
    end
end

function JAMMER:RemoveDebugDraw()
    for unit, unit_info in pairs(self.info_dict) do
        unit_info.oval:RemoveDraw()
    end

    for _, mark_id in pairs(self.tmp_mark_ids) do
        UTILS.RemoveMark(mark_id)
    end
end

--function JAMMER:NoiseBarrage()
--
--end
--
--function JAMMER:JamLocation(vec2, radius)
--
--end
--
--function JAMMER:JamLocations(vec2_locations)
--
--end

--function JAMMER:BarrageJam(vec2, radar_types, range)
--    local strength_per_radar = self.__total_strength / #radar_types
--
--    self.target_units:ForEachUnit(
--        function(target_unit)
--            local target_pos = target_unit:GetVec2()
--            if  UTILS.IsInRadius(target_pos, self:GetVec2(), self.__barrage_range) and
--                target_unit:GetRadar() and self:HasLineOfSight(target_pos)         and
--                table.contains(radar_types, target_unit:GetTypeName())                 and
--                not UTILS.IsInRadius(target_pos, self:GetVec2(), JAMMER.RADAR_INFO[target_unit.GetTypeName()].burn_through_range) then
--                    self:I("JAMJAM!")
--            end
--        end
--    )
--end





--
--
--
--
--JAMMING_POD = {
--    ClassName = "JAMMINGPOD"
--}
--
--function JAMMING_POD:New()
--    self = BASE:Inherit(self, BASE:New())
--
--    self.aim_point = {x=0, y=0}
--
--    return self
--end
--
--function JAMMING_POD:Aim(vec2, radius)
--
--end
--




















