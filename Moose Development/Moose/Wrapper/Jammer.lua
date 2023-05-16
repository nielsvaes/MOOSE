
DEV_LOCATION_GUESS_MULTI  = 2

JAMMER = {
    ClassName = "JAMMER",
    JamRate = 1/2,
    RootMenuBlue = nil,
    RootMenuRed = nil,
}

function JAMMER:FindByName(unit_name, target_coalition_name, own_coalition_name)
    self = BASE:Inherit(self, UNIT:FindByName(unit_name))
    if self == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end

    self.targets = {}
    self.passive_detected_targets = {}
    self.group_filter_obj    = SET_GROUP:New()
                                        :FilterCoalitions(string.lower(target_coalition_name))
                                        :FilterCategories({"ground", "plane", "ship"})
                                        :FilterActive()

    self.detect_range        = UTILS.NMToMeters(50)
    self.initial_major_axis  = UTILS.NMToMeters(10)
    self.initial_minor_axis  = UTILS.NMToMeters(4)
    self.min_major_axis      = UTILS.NMToMeters(2)
    self.min_minor_axis      = UTILS.NMToMeters(0.5)

    self.num_jamming_pods    = 1
    self.power               = 100 * self.num_jamming_pods

    self.is_jamming          = false

    self.types_to_jam        = {}
    self.spot_jam_pos        = {x=999999, y=999999}
    self.spot_jam_radius     = UTILS.NMToMeters(2)
    self.max_spot_jam_radius = UTILS.NMToMeters(30)

    self.own_pos_radius      = UTILS.NMToMeters(30)
    self.max_own_pos_radius  = UTILS.NMToMeters(30)

    self.find_targets_glf    = GAMELOOPFUNCTION:New(self.FindTargets, {self}, -1, UTILS.UniqueName(self:GetName() .. "_ find"), 1/5, true):Add()
    self.passive_detect_glf  = GAMELOOPFUNCTION:New(self.PassiveDetect, {self}, -1, UTILS.UniqueName(self:GetName() .. "_detect"), 1/3):Add()
    self.spot_jam_glf        = nil

    self.own_coalition       = UTILS.GetCoalitionEnumValue(own_coalition_name)

    self.tmp_pd_mark_ids     = {}



    return self
end


---Finds all possible radars on the map and turns them into JAMMER_TARGET_UNITS.
---Only checks units IF the group has any radars in it, no need to check every tank or infantry
---@return nil
-- Test: check if this still works with dynamically added groups
-- Test: no idea what getAttribute does, maybe it already loops over every unit and maybe it's more performant to check every unit anyway?
function JAMMER:FindTargets()
    for _, group in pairs(self.group_filter_obj:FilterOnce():GetSetObjects()) do
        if group:HasAttribute("SAM TR") or group:HasAttribute("SAM SR") or group:HasAttribute("EWR") then
            for _, unit in pairs(group:GetUnits()) do
                if unit:HasAttribute("SAM TR") or unit:HasAttribute("SAM SR") or unit:HasAttribute("EWR") then
                    local jtu = JAMMER_TARGET_UNIT:New(unit:GetName(), self)
                    table.insert_unique(self.targets, jtu)
                end
            end
        end
    end
end

function JAMMER:PassiveDetect()
    for _, jtu in pairs(self.targets) do
        if UTILS.IsInRadius(jtu:GetVec2(), self:GetVec2(), self.detect_range) and jtu:GetRadar() and self:HasLineOfSight(jtu:GetVec3()) then
            table.insert_unique(self.passive_detected_targets, jtu)
        end
    end
end

function JAMMER:TriangulateTarget(jtu)
    local heading = UTILS.HdgTo(self:GetVec3(), jtu:GetVec3())

    if jtu.first_triangulation_try then
        jtu.first_triangulation_try = false
        jtu.initial_headings = {heading, heading}
        jtu.scan_headings = jtu.initial_headings
        jtu.oval:SetMajorAxis(self.initial_major_axis)
        jtu.oval:SetMinorAxis(self.initial_minor_axis)
        jtu.oval:SetAngle(heading)
        return
    end

    jtu.scan_headings[1] = jtu.scan_headings[2]
    jtu.scan_headings[2] = heading
    jtu.oval:SetAngle(heading)

    if (jtu.oval:GetMajorAxis() > self.min_major_axis and jtu.oval:GetMinorAxis() > self.min_major_axis) and not jtu.triangulated then
        local previous = jtu.scan_headings[1]
        local new      = jtu.scan_headings[2]
        if new < previous then
            new = new + 360
        end

        local diff = (360 - (new - previous)) % 360

        local major_axis_decrease = diff * 40 * DEV_LOCATION_GUESS_MULTI
        local minor_axis_decrease = diff * 18 * DEV_LOCATION_GUESS_MULTI

        jtu.oval:SetMajorAxis(UTILS.Clamp(jtu.oval:GetMajorAxis() - major_axis_decrease, self.min_major_axis, 9999999))
        jtu.oval:SetMinorAxis(UTILS.Clamp(jtu.oval:GetMinorAxis() - minor_axis_decrease, self.min_minor_axis, 9999999))

        jtu.guessed_pos = jtu.oval:GetRandomVec2()

    else
        if not jtu.triangulated then
            jtu.guessed_pos = CIRCLE:New(jtu:GetVec2(), jtu.oval:GetMinorAxis()):GetRandomVec2()
            jtu.triangulated = true
        end
    end
end

function JAMMER:TriangulatePassiveDetectedTargets()
    for _, jtu in pairs(self.passive_detected_targets) do
        self:TriangulateTarget(jtu)
    end
end

function JAMMER:PossibleToJam(jtu, jamming_location, jamming_types, radius)
    local in_radius            = UTILS.IsInRadius(jtu:GetVec2(), jamming_location, radius)
    local has_los              = self:HasLineOfSight(jtu:GetVec3())
    local type_targeted        = table.contains(jamming_types, jtu:GetTypeName())
    local outside_burn_through = not UTILS.IsInSphere(jtu:GetVec3(), self:GetVec3(), UTILS.NMToMeters(jtu.burn_through_range))

    if in_radius and has_los and type_targeted and outside_burn_through then
        return true
    end
    return false
end

function JAMMER:AttemptJam(jtu, jam_effectiveness)
    print(string.format("Attempting to jam %s: %d", jtu:GetName(), jam_effectiveness))
    if UTILS.PercentageChance(jam_effectiveness) then
        if jtu.shutdown_on_jam then
            jtu:EnableEmission(false)
            jtu:OptionROEWeaponFree()
        else
            jtu:EnableEmission(true)
            jtu:OptionROEHoldFire()
        end

        JAMMER_MANAGER:Get():UpdateJammedJTU(jtu, self)
    end
end

function JAMMER:SetDetectRange(value)
    self.detect_range = UTILS.NMToMeters(value)
end

function JAMMER:SetInitialMajorAxis(value)
    self.initial_major_axis = UTILS.NMToMeters(value)
end

function JAMMER:SetInitialMinorAxis(value)
    self.initial_minor_axis = UTILS.NMToMeters(value)
end

function JAMMER:__SpotJam()
    local radius_penalty = UTILS.RemapValue(self.spot_jam_radius, 0, self.max_spot_jam_radius, 0, 120)

    for _, jtu in pairs(self.targets) do
        local effectiveness = self.power - (5 * #self.types_to_jam) - radius_penalty

        if self:PossibleToJam(jtu, self.spot_jam_pos, self.types_to_jam, self.spot_jam_radius) then
            if not UTILS.IsInRadius(self.spot_jam_pos, jtu:GetVec2(), self.spot_jam_radius / 3) then
                effectiveness = effectiveness - 20
            end
            effectiveness = UTILS.Clamp(effectiveness - jtu.penalty, 0, 100)
            self:AttemptJam(jtu, effectiveness)
        end
    end
end

function JAMMER:StartSpotJamming(vec2, types, radius_in_NM)
    JAMMER:StopAllJamming()

    if vec2         ~= nil then self:SetSpotJamVec2(vec2) end
    if types        ~= nil then self.types_to_jam = types end
    if radius_in_NM ~= nil then self:SetSpotJamRadius(radius_in_NM) end

    self.spot_jam_glf = GAMELOOPFUNCTION:New(self.__SpotJam, {self}, -1, nil, JAMMER.JamRate, true):Add()
end

function JAMMER:StopSpotJamming()
    GAMELOOP:Get():Remove(self.spot_jam_glf)
end

function JAMMER:SetSpotJamVec2(vec2)
    self.spot_jam_pos = vec2
end

function JAMMER:SetSpotJamRadius(radius_in_NM)
    self.spot_jam_radius = UTILS.Clamp(UTILS.NMToMeters(radius_in_NM), 0, self.max_spot_jam_radius)
end

function JAMMER:StopAllJamming()
    self:StopSpotJamming()
end

function JAMMER:Orbit(coord)
    local task = self:TaskOrbit(coord, self:GetCoordinate().y, self:GetVelocityMPS())
    self:SetTask(task)
end

function JAMMER:AddTypeToJam(radar_type_name)
    table.insert_unique(self.types_to_jam, radar_type_name)
end

function JAMMER:HasLineOfSight(tgt_vec3)
    tgt_vec3.y = tgt_vec3.y + 5
    if land.isVisible(self:GetVec3(), tgt_vec3) then
        return true
    end
    return false
end

function JAMMER:DebugDrawPassiveDetectedTargets(show_ellipse, show_guessed_pos)
    self:RemoveDebugDrawPassiveDetectedTargets()

    for _, jtu in pairs(self.passive_detected_targets) do
        if show_ellipse then
            jtu.oval:Draw()
        end

        if show_guessed_pos then
            table.add(self.tmp_pd_mark_ids, COORDINATE:NewFromVec2(jtu.guessed_pos):CircleToAll(300, -1, {0, 0, 1}, 1, {0, 0, 1}))
        end
    end
end

function JAMMER:RemoveDebugDrawPassiveDetectedTargets()
    print("Removing drawings!")
    for _, jtu in pairs(self.passive_detected_targets) do
        jtu.oval:RemoveDraw()
    end

    for _, mark_id in pairs(self.tmp_pd_mark_ids) do
        UTILS.RemoveMark(mark_id)
    end
end



--
--JAMMER.SKILL_INFO = {
--    ["Average"] = {
--        penalty = 2,
--        recovery_time = 4,
--        lucky_chance = 2,
--        needed_hits = 1,
--    },
--    ["Good"] = {
--        penalty = 8,
--        recovery_time = 3.1,
--        lucky_chance = 3,
--        needed_hits = 1,
--    },
--    ["High"] = {
--        penalty = 10,
--        recovery_time = 2.7,
--        lucky_chance = 4,
--        needed_hits = 2,
--    },
--    ["Excellent"] = {
--        penalty = 12,
--        recovery_time = 0.7,
--        lucky_chance = 5,
--        needed_hits = 3,
--    },
--}
--JAMMER.SKILL_INFO["Random"] = {
--        penalty = math.random(JAMMER.SKILL_INFO["Average"].penalty, JAMMER.SKILL_INFO["Excellent"].penalty),
--        recovery_time = math.random(JAMMER.SKILL_INFO["Average"].recovery_time, JAMMER.SKILL_INFO["Excellent"].recovery_time)
--    }
--
--JAMMER.RADAR_INFO = {
--    --- EWRs
--    ["1L13 EWR"] = {
--        burn_through_range = 30,
--        memory_time = 10,
--        engage_distance = 0,
--        track_distance = 100,
--        weapon_identify_ability = 1,
--        can_shoot_down_weapon = false
--    },
--    ["55G6 EWR"] = {
--        burn_through_range = 30,
--        memory_time = 10,
--        engage_distance = 0,
--        track_distance = 100,
--        weapon_identify_ability = 1,
--        can_shoot_down_weapon = false
--    },
--
--    --- Short range
--    ["Dog Ear radar"] = {
--        burn_through_range = 11,
--        memory_time = 6,
--        engage_distance = 0,
--        track_distance = 19,
--        weapon_identify_ability = 1,
--        can_shoot_down_weapon = false
--    },
--    ["M48 Chaparral"] = {
--        memory_time = 5,
--        engage_distance = 4.5,
--        track_distance = 5,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["M6 Linebacker"] = {
--        burn_through_range = 3,
--        memory_time = 6,
--        engage_distance = 2.4,
--        track_distance = 4.3,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Osa 9A33 ln"] = {  -- SA-8
--        burn_through_range = 12,
--        memory_time = 6,
--        engage_distance = 5.45,
--        track_distance = 16.18,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Tor 9A331"] = {   -- SA-15
--        burn_through_range = 8,
--        memory_time = 8,
--        engage_distance = 6.5,
--        track_distance = 13.5,
--        weapon_identify_ability = 95,
--        can_shoot_down_weapon = true
--    },
--    ["2S6 Tunguska"] = {   -- SA-19
--        burn_through_range = 7,
--        memory_time = 8,
--        engage_distance = 4.28,
--        track_distance = 9.76,
--        weapon_identify_ability = 95,
--        can_shoot_down_weapon = true
--    },
--
--    --- HAWK
--    ["Hawk cwar"] = {
--        memory_time = 8,
--        engage_distance = 0,
--        track_distance = 37.8,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Hawk ln"] = {
--        memory_time = 0,
--        engage_distance = 24.2,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Hawk sr"] = {
--        burn_through_range = 30,
--        memory_time = 8,
--        engage_distance = 0,
--        track_distance = 48.6,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Hawk tr"] = {
--        burn_through_range = 26,
--        memory_time = 8,
--        engage_distance = 0,
--        track_distance = 48.4,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    --- NASAMS
--    ["NASAMS_Radar_MPQ64F1"] = {
--        burn_through_range = 15,
--        memory_time = 8,
--        engage_distance = 8.1,
--        track_distance = 27.3,
--        weapon_identify_ability = 3,
--        can_shoot_down_weapon = false
--    },
--    ["NASAMS_LN_C"] = {
--        memory_time = 0,
--        engage_distance = 8.1,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["NASAMS_LN_B"] = {
--        memory_time = 0,
--        engage_distance = 0,
--        track_distance = 8.1,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    --- Patriot
--    ["Patriot AMG"] = {
--        memory_time = 0,
--        engage_distance = 0,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Patriot ECS"] = {
--        memory_time = 0,
--        engage_distance = 0,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Patriot EPP"] = {
--        memory_time = 0,
--        engage_distance = 0,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Patriot str"] = {
--        burn_through_range = 40,
--        memory_time = 8,
--        engage_distance = 0,
--        track_distance = 105,
--        weapon_identify_ability = 3,
--        view_angle = 110,
--        can_shoot_down_weapon = false
--    },
--
--    --- Rapier
--    ["rapier_fsa_blindfire_radar"] = {
--        burn_through_range = 9,
--        memory_time = 5,
--        engage_distance = 3.6,
--        track_distance = 16.3,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["rapier_fsa_launcher"] = {
--        memory_time = 0,
--        engage_distance = 3.6,
--        track_distance = 16.3,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["rapier_fsa_optical_tracker_unit"] = {
--        memory_time = 5,
--        engage_distance = 0,
--        track_distance = 11,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    --- Roland
--    ["Roland ADS"] = {
--        memory_time = 5,
--        engage_distance = 4.29,
--        track_distance = 6.4,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["Roland Radar"] = {
--        burn_through_range = 9,
--        memory_time = 5,
--        engage_distance = 0,
--        track_distance = 18.9,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    --- HQ-7
--    ["HQ-7_STR_SP"] = {
--        burn_through_range = 11,
--        memory_time = 5,
--        engage_distance = 6.5,
--        track_distance = 16.1,
--        weapon_identify_ability = 3,
--        can_shoot_down_weapon = false
--    },
--    ["HQ-7_LN_SP"] = {
--        memory_time = 5,
--        engage_distance = 6.5,
--        track_distance = 16.1,
--        weapon_identify_ability = 3,
--        can_shoot_down_weapon = false
--    },
--
--
--    --- SA-2
--    ["SNR_75V"] = {
--        burn_through_range = 22,
--        memory_time = 10,
--        engage_distance = 0,
--        track_distance = 54,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["S_75M_Volhov"] = {
--        memory_time = 10,
--        engage_distance = 23,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["p-19 s-125 sr"] = {
--        burn_through_range = 26,
--        memory_time = 8,
--        engage_distance = 0,
--        track_distance = 86,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    --- SA-3
--    ["5p73 s-125 ln"] = {
--        memory_time = 0,
--        engage_distance = 9.7,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["snr s-125 tr"] = {
--        burn_through_range = 21,
--        memory_time = 10,
--        engage_distance = 0,
--        track_distance = 54,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    --- SA-5
--    ["S-200_Launcher"] = {
--        memory_time = 0,
--        engage_distance = 136,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["RPC_5N62V"] = {   -- TR
--        burn_through_range = 38,
--        memory_time = 5,
--        engage_distance = 0,
--        track_distance = 216,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--    ["RLS_19J6"] = {   -- TR
--        burn_through_range = 31,
--        memory_time = 5,
--        engage_distance = 0,
--        track_distance = 81,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    --- SA-6
--    ["Kub 1S91 str"] = {
--        burn_through_range = 16,
--        memory_time = 6,
--        engage_distance = 11,
--        track_distance = 28,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    ["Kub 2P25 ln"] = {
--        memory_time = 0,
--        engage_distance = 13,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = false
--    },
--
--    --- SA-10
--    ["S-300PS 64H6E sr"] = {
--        burn_through_range = 26,
--        memory_time = 5,
--        engage_distance = 0,
--        track_distance = 85.7,
--        weapon_identify_ability = 98,
--        can_shoot_down_weapon = false
--    },
--    ["S-300PS 40B6MD sr"] = {
--        burn_through_range = 16,
--        memory_time = 5,
--        engage_distance = 0,
--        track_distance = 32.1,
--        weapon_identify_ability = 98,
--        can_shoot_down_weapon = false
--    },
--    ["S-300PS 40B6M tr"] = {
--        burn_through_range = 28,
--        memory_time = 5,
--        engage_distance = 64.7,
--        track_distance = 85,
--        weapon_identify_ability = 95,
--        can_shoot_down_weapon = false
--    },
--    ["S-300PS 5P85D ln"] = {
--        memory_time = 0,
--        engage_distance = 64.7,
--        track_distance = 0,
--        weapon_identify_ability = 0,
--        can_shoot_down_weapon = true
--    },
--    ["S-300PS 5P85C ln"] = {
--        memory_time = 0,
--        engage_distance = 64.7,
--        track_distance = 0,
--        weapon_identify_ability = 95,
--        can_shoot_down_weapon = true
--    },
--
--    --- SA-11
--    ["SA-11 Buk SR 9S18M1"] = {
--        burn_through_range = 25,
--        memory_time = 5,
--        engage_distance = 0,
--        track_distance = 53.5,
--        weapon_identify_ability = 85,
--        can_shoot_down_weapon = false
--    },
--    ["SA-11 Buk LN 9A310M1"] = {
--        burn_through_range = 13,
--        memory_time = 5,
--        engage_distance = 19.2,
--        track_distance = 26.6,
--        weapon_identify_ability = 85,
--        can_shoot_down_weapon = false
--    },
--}
--




--function JAMMER:SpotJam()
--    local remapped = UTILS.RemapValue(self.spot_jam_radius, 0, self.max_spot_jam_radius, 0, 120)
--    BASE:I("remapped: " .. tostring(remapped))
--    local effectiveness = self.power - (5 * #self.types_to_jam) - remapped
--
--    self.target_unit_set:ForEachUnit(
--        function(moose_unit)
--            if self:PossibleToJamUnit(moose_unit, self.spot_jam_pos, self.types_to_jam, self.spot_jam_radius) then
--                if not UTILS.IsInRadius(self.spot_jam_pos, moose_unit:GetVec2(), self.spot_jam_radius / 3) then
--                    effectiveness = effectiveness - 20
--                end
--                effectiveness = effectiveness - JAMMER.SKILL_INFO[moose_unit:GetSkill()].penalty
--
--                effectiveness = UTILS.Clamp(effectiveness, 0, 100)
--                BASE:I("effectiveness: " .. tostring(effectiveness))
--                self:AttemptJam(moose_unit, effectiveness)
--            end
--        end
--    )
--end

--function JAMMER:PassiveDetect()
--    local targets = {}
--
--    self.target_unit_set:ForEachUnit(
--        function(target_unit)
--            local target_pos = target_unit:GetVec2()
--            if UTILS.IsInRadius(target_pos, self:GetVec2(), self.detect_range) and target_unit:GetRadar() and self:HasLineOfSight(target_unit:GetVec3()) then
--                self:UpdateRadarUnitInfo(target_unit)
--                self:GuessLocation(target_unit)
--            end
--        end
--    )
--
--    return targets
--end
--
--function JAMMER:SetUpRadioMenu()
--    if self.own_coalition == coalition.side.BLUE then
--        JAMMER.RootMenuBlue =  MENU_COALITION:New(
--            self.own_coalition,
--            "Jammers"
--        )
--        self.root_menu = JAMMER.RootMenuBlue
--
--    elseif self.own_coalition == coalition.side.RED then
--        JAMMER.RootMenuRed =  MENU_COALITION:New(
--            self.own_coalition,
--            "Jammers"
--        )
--        self.root_menu = JAMMER.RootMenuRed
--
--    end
--
--    self.radio_menu = MENU_COALITION:New(
--                        self.own_coalition,
--                        self:GetName() .. " Menu",
--                        self.root_menu
--                      )
--    self.targets_menu = MENU_COALITION:New(
--                          self.own_coalition,
--                          "Targets",
--                          self.radio_menu
--                        )
--
--    self.start_cmd = MENU_COALITION_COMMAND:New(
--                          self.own_coalition,
--                          "Start jamming targets",
--                          self.radio_menu,
--                          function()
--                              MessageToAll("JamJamJam!")
--                          end
--                        )
--    self.stop_cmd = MENU_COALITION_COMMAND:New(
--                          self.own_coalition,
--                          "Stop jamming",
--                          self.radio_menu,
--                          function()
--                              MessageToAll("stopStopStop!")
--                          end
--                        )
--
--end
--
--function JAMMER:UpdateRadarUnitInfo(radar_unit)
--    if not table.contains_key(self.info_dict, radar_unit) then
--        local initial_heading = UTILS.HdgTo(self:GetVec3(), radar_unit:GetVec3())
--        -- pass this to the JAMMER_TARGET_UNIT
--
--        self.info_dict[radar_unit] = {
--            actual_pos = radar_unit:GetVec2(),
--            guessed_pos = {x=999999, y=999999},
--            final_guessed_pos = nil,
--            scan_headings = { initial_heading, initial_heading },
--            times_hit = 1,
--            oval = OVAL:New(radar_unit:GetVec2(),
--                            self.initial_major_axis,
--                            self.initial_minor_axis,
--                            UTILS.HdgTo(self:GetVec3(), radar_unit:GetVec3())),
--            circle = CIRCLE:New(radar_unit:GetVec2(), self.min_minor_axis),
--            turn_off_on_jam = nil,
--            vulnerable_at = 1,
--            radio_menu = MENU_COALITION:New(
--                            self.own_coalition,
--                            string.format("%s (%s)", radar_unit:GetTypeName(), radar_unit:GetName()),
--                            self.targets_menu
--                        ),
--
--        }
--        MENU_COALITION_COMMAND:New(
--                                self.own_coalition,
--                                string.format("Add %s to types to jam", radar_unit:GetTypeName()),
--                                self.info_dict[radar_unit].radio_menu,
--                                function()
--                                    table.insert_unique(self.types_to_jam, radar_unit:GetTypeName())
--                                end
--
--            )
--        return
--    end
--
--    self.info_dict[radar_unit].scan_headings[1] = self.info_dict[radar_unit].scan_headings[2]
--    self.info_dict[radar_unit].scan_headings[2] = UTILS.HdgTo(self:GetVec3(), radar_unit:GetVec3())
--    self.info_dict[radar_unit].times_scanned    = self.info_dict[radar_unit].times_scanned + 1
--    self.info_dict[radar_unit].oval:SetAngle(self.info_dict[radar_unit].scan_headings[2])
--end
--
--function JAMMER:GuessLocation(unit)
--    local unit_info = self.info_dict[unit]
--
--    -- we don't have a extremely good position yet, so continue trying to refine
--    if unit_info.oval:GetMajorAxis() > self.min_major_axis and unit_info.oval:GetMinorAxis() > self.min_minor_axis then
--        local previous = unit_info.scan_headings[1]
--        local new = unit_info.scan_headings[2]
--        if new < previous then
--            new = new + 360
--        end
--
--        local diff = (360 - (new - previous)) % 360
--
--        local major_axis_decrease = diff * 40 * DEV_LOCATION_GUESS_MULTI
--        local minor_axis_decrease = diff * 18 * DEV_LOCATION_GUESS_MULTI
--
--        unit_info.oval:SetMajorAxis(UTILS.Clamp(unit_info.oval:GetMajorAxis() - major_axis_decrease, self.min_major_axis, 9999999))
--        unit_info.oval:SetMinorAxis(UTILS.Clamp(unit_info.oval:GetMinorAxis() - minor_axis_decrease, self.min_minor_axis, 9999999))
--
--        unit_info.guessed_pos = unit_info.oval:GetRandomVec2()
--    else
--        -- we were able to refine the location enough to get a pretty accurate location
--        unit_info.guessed_pos = unit_info.oval:GetRandomVec2()
--    end
--end
--
--function JAMMER:PossibleToJamUnit(unit, jamming_location, jamming_types, radius)
--    local is_radar_unit = false
--    if unit:HasAttribute("SAM TR") or unit:HasAttribute("SAM TR") or unit:HasAttribute("EWR") then
--        is_radar_unit = true
--    else
--        return false
--    end
--
--    --self:I(unit)
--    --self:I(self.info_dict[unit])
--    --
--    --if timer.getTime() < self.info_dict[unit].vulnerable_at then
--    --    self:I(unit:GetName() .. " is immune!")
--    --    return false
--    --else
--    --    self:I(unit:GetName() .. " vulnerable")
--    --    self.info_dict[unit].vulnerable_at = 0
--    --end
--    --
--    --if UTILS.PercentageChance(JAMMER.SKILL_INFO[unit:GetSkill()].lucky_chance) then
--    --    self.info_dict[unit].vulnerable_at = timer.getTime() + JAMMER.SKILL_INFO[unit:GetSkill()].lucky_chance * 10
--    --end
--
--    local is_in_jam_radius          = UTILS.IsInRadius(unit:GetVec2(), jamming_location, radius)
--    local has_line_of_sight         = self:HasLineOfSight(unit:GetVec3())
--    local type_targeted             = table.contains(jamming_types, unit:GetTypeName())
--    local not_in_burn_through_range = not UTILS.IsInSphere(unit:GetVec3(), self:GetVec3(), UTILS.NMToMeters(JAMMER.RADAR_INFO[unit:GetTypeName()].burn_through_range))
--
--    --self:I(is_in_jam_radius)
--    --self:I(has_radar)
--    --self:I(has_line_of_sight)
--    --self:I(type_targeted)
--    --self:I(not_in_burn_through_range)
--
--    if is_in_jam_radius and is_radar_unit and has_line_of_sight and type_targeted and not_in_burn_through_range then
--        return true
--    end
--    -- if any of these checks is false, the unit can not be jammed
--    return false
--end
--
--function JAMMER:AttemptJam(unit, jam_percentage)
--    local turn_off = UTILS.PercentageChance(50 + JAMMER.SKILL_INFO[unit:GetSkill()].penalty)
--    BASE:I("Attempting jam of: " .. unit:GetName())
--    if UTILS.PercentageChance(jam_percentage) then
--        if turn_off then
--            self.info_dict[unit].turn_off = true
--            unit:EnableEmission(false)
--            unit:OptionROEWeaponFree()
--        else
--            unit:EnableEmission(true)
--            unit:OptionROEHoldFire()
--        end
--        JAMMER_MANAGER:Get():UpdateJammed(unit, self, turn_off, JAMMER.SKILL_INFO[unit:GetSkill()].recovery_time)
--    else
--        self:I("Couldn't be jammed")
--    end
--end

--function JAMMER:RemoveAllMenus()
--    JAMMER.RootMenuBlue:Remove()
--
--end
--
--function JAMMER:ResetRadioMenu()
--    self:RemoveAllMenus()
--    self:SetUpRadioMenu()
--end
--
--
--function JAMMER:__OwnPositionJamming()
--    local effectiveness = self.power - (3 * #self.types_to_jam)
--
--    self.target_unit_set:ForEachUnit(
--        function(target_unit)
--            if self:PossibleToJamUnit(target_unit, self.spot_jam_pos, self.types_to_jam, self.spot_jam_radius) then
--                if not UTILS.IsInRadius(self.spot_jam_pos, target_unit:GetVec2(), self.spot_jam_radius / 2) then
--                    effectiveness = effectiveness - 10
--                end
--                effectiveness = effectiveness - JAMMER.SKILL_INFO[target_unit:GetSkill()].penalty
--
--                self:AttemptJam(target_unit, effectiveness)
--            end
--        end
--    )
--end

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
--    local strength_per_radar = self.total_strength / #radar_types
--
--    self.target_unit_set:ForEachUnit(
--        function(target_unit)
--            local target_pos = target_unit:GetVec2()
--            if  UTILS.IsInRadius(target_pos, self:GetVec2(), self.barrage_range) and
--                target_unit:GetRadar() and self:HasLineOfSight(target_pos)         and
--                table.contains(radar_types, target_unit:GetTypeName())                 and
--                not UTILS.IsInRadius(target_pos, self:GetVec2(), JAMMER.RADAR_INFO[target_unit.GetTypeName()].burn_through_range) then
--                    self:I("JAMJAM!")
--            end
--        end
--    )
--end

--function JAMMER:DebugDraw()
--    self:RemoveDebugDraw()
--
--    -- draw radar locations
--    for unit, unit_info in pairs(self.info_dict) do
--        unit_info.oval.Angle = UTILS.HdgTo(unit:GetVec3(), self:GetVec3())
--        unit_info.oval:Draw()
--
--        table.add(self.tmp_mark_ids, COORDINATE:NewFromVec2(unit_info.guessed_pos):CircleToAll(300, -1, {0, 0, 1}, 1, {0, 0, 1}))
--    end
--end
--
--function JAMMER:RemoveDebugDraw()
--    for unit, unit_info in pairs(self.info_dict) do
--        unit_info.oval:RemoveDraw()
--    end
--
--    for _, mark_id in pairs(self.tmp_mark_ids) do
--        UTILS.RemoveMark(mark_id)
--    end
--end
--













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




















