---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Nisse.
--- DateTime: 1/24/2022 5:45 PM
---

DOGFIGHTER = {
    ClassName = "DOGFIGHTER",
    spawn_distance = 5,
    fights_on_distance = 0.85,
    specific_group_menus = {},
    specific_unit_menus = {},
    specific_unit_settings = {},
    unit_enemy_pairs = {},
    uhf_frequencies = {},
    unit_frequencies = {},
    fights_on = "fights_on.ogg",
    name_prefix = "DOGFIGHT__",
    spacing_degree_offset = 2
}

function DOGFIGHTER:New()
    self = BASE:Inherit(self, BASE:New())
    self.uhf_frequencies = UTILS.GenerateUHFrequencies()

    --self:HandleEvent(EVENTS.Takeoff)
    --self:HandleEvent(EVENTS.Land)
    --self:HandleEvent(EVENTS.Dead)
    --self:HandleEvent(EVENTS.Crash)
    --self:HandleEvent(EVENTS.PilotDead)
    --self:HandleEvent(EVENTS.Ejection)
    --self:HandleEvent(EVENTS.PlayerLeaveUnit)
    self:HandleEvent(EVENTS.PlayerEnterAircraft)

    self.scheduler = SCHEDULER:New(
            nil,
            function()
                self:CanGoHot()
            end,
            {},
            0.1,
            0.1
    )
    
    return self
end

function DOGFIGHTER:BroadcastFightsOn(unit, frequency)
    trigger.action.radioTransmission("l10n/DEFAULT/fights_on.ogg", unit:GetVec3(), 0, false, frequency * 1000000, 1000, nil)
    dev_message("fight's on")
end

function DOGFIGHTER:CanGoHot()
    local to_remove = {}

    for _, unit_enemy_pair in pairs(self.unit_enemy_pairs) do
        local unit = unit_enemy_pair[1]
        local enemy_group = unit_enemy_pair[2]

        if enemy_group ~= nil and unit ~= nil then
            local distance = UTILS.MetersToNM(unit:GetCoordinate():Get3DDistance(enemy_group:GetCoordinate()))
            if distance < self.fights_on_distance then
                self:BroadcastFightsOn(enemy_group:GetUnit(1), self.unit_frequencies[unit:GetPlayerName()])

                enemy_group:OptionROEWeaponFree()
                local task = enemy_group:EnRouteTaskEngageTargetsInZone(enemy_group:GetVec2(), 40000)
                enemy_group:PushTask(task)
                table.insert(to_remove, unit_enemy_pair)
            end
        end
    end

    for _, each in pairs(to_remove) do
        table.remove_by_value(self.unit_enemy_pairs, each)
    end
end

function DOGFIGHTER:SpawnBandit(unit, prefix)
    local possible_enemies = SET_GROUP:New()
                                      :FilterPrefixes(prefix)
                                      :FilterOnce()
                                      :GetSetNames()

    local player_name = unit:GetPlayerName()
    local player_coordinates = unit:GetCoord()
    local player_altitude = player_coordinates:GetVec3().y
    local player_heading = unit:GetHeading()
    local enemy_group_name = table.random(possible_enemies)
    local skill = self.specific_unit_settings[player_name]["skill"] or "Random"

    local num_enemy_groups = self.specific_unit_settings[player_name]["num_enemy_groups"] or 1
    local half_count = math.floor(num_enemy_groups / 2)

    for i=1, num_enemy_groups do
        local offset_index = i - 1 - half_count
        local enemy_heading = (360 + ((player_heading - 180) % 360)) % 360
        local enemy_coordinates = player_coordinates:Translate(UTILS.NMToMeters(self.spawn_distance), (360 + ((player_heading + (offset_index * self.spacing_degree_offset)) % 360)) % 360, true, false):SetAltitude(player_altitude, true)
        local enemy_waypoint = enemy_coordinates:Translate(UTILS.NMToMeters(self.spawn_distance * 2), enemy_heading, true, false):SetAltitude(player_altitude, true)
        local enemy_speed = math.random(800, 1200)
        local enemy_route = {}
        enemy_route[1] = enemy_coordinates:WaypointAirTurningPoint("BARO", enemy_speed, {}, "Current")
        enemy_route[2] = enemy_waypoint:WaypointAirTurningPoint("BARO", enemy_speed, {}, "WP1")

        local enemy = SPAWN:NewWithAlias(enemy_group_name, UTILS.UniqueName(self.name_prefix .. player_name))
                           :InitGroupHeading(enemy_heading)
                           :InitSkill(skill)
                           :SpawnFromVec3(enemy_coordinates:GetVec3())

        enemy:Route(enemy_route, 0.5)
        local task = enemy:EnRouteTaskCAP()
        -- delaying otherwise the task is being set before the group is recognized in the mission
        delay(0.1,
        function()
            enemy:PushTask(task)
            enemy:OptionROEHoldFire()
        end
        )

        table.insert(self.unit_enemy_pairs, { unit, enemy })
    end
    
    dev_message("Spawning " .. tostring(num_enemy_groups) .. " groups for " .. player_name .. ", skill " .. skill)
end

function DOGFIGHTER:BuildMenuStructure(moose_unit)
    -- Destroy any existing menus
    dev_message("making menu")
    self:DeleteRadioMenu(moose_unit)

    local moose_group = moose_unit:GetGroup()
    local player_name = moose_unit:GetPlayerName()
    local player_frequency = table.random(self.uhf_frequencies) / 1000000
    self.unit_frequencies[player_name] = player_frequency

    local group_menu = MENU_GROUP:New(moose_group, "DOGFIGHT")
    self.specific_group_menus[moose_group] = group_menu

    for group, specific_group_menu in pairs(self.specific_group_menus) do
        if group:GetName() == moose_group:GetName() then
            local unit_menu = MENU_GROUP:New(
                group, 
                player_name .. " ( UHF: " .. tostring(player_frequency) .. "MHz)", 
                specific_group_menu
            )
            
            self.specific_unit_menus[player_name] = unit_menu
            self:MakeSettingsMenu(moose_unit)
            self:MakeSpawnMenu(moose_unit)
        end
    end
end

function DOGFIGHTER:MakeSettingsMenu(moose_unit)
    local player_name = moose_unit:GetPlayerName()
    local unit_root_menu = self.specific_unit_menus[player_name]
    local moose_group = moose_unit:GetGroup()

    self.specific_unit_settings[player_name] = {}

    local settings_menu = MENU_GROUP:New(
        moose_group,
        "Settings",
        unit_root_menu
    )

    local skill_menu = MENU_GROUP:New(
        moose_group,
        "Skill level",
        settings_menu
    )
    
    for _, skill_level in pairs {"Rookie", "Trained", "Veteran", "Ace", "Random"} do
        MENU_GROUP_COMMAND:New(
            moose_group,
            skill_level,
            skill_menu,
            function()
                self.specific_unit_settings[player_name]["skill"] = skill_level
            end
        )
    end

    local num_groups = MENU_GROUP:New(
        moose_group,
        "Number of enemy groups",
        settings_menu
    )

    for num=1, 5 do
        MENU_GROUP_COMMAND:New(
        moose_group,
        tostring(num),
        num_groups,
        function()
            self.specific_unit_settings[player_name]["num_enemy_groups"] = num
        end
        )
    end    
end

function DOGFIGHTER:MakeSpawnMenu(moose_unit)
    local player_name = moose_unit:GetPlayerName()
    local moose_group = moose_unit:GetGroup()
    
    for _player_name, unit_specific_menu in pairs(self.specific_unit_menus) do
        if _player_name == player_name then
            MENU_GROUP_COMMAND:New(moose_group, "Spawn enemy bandit GUNS", unit_specific_menu, self.SpawnBandit, self, moose_unit, "dogfight_guns")
            MENU_GROUP_COMMAND:New(moose_group, "Spawn enemy bandit MISSILES", unit_specific_menu, self.SpawnBandit, self, moose_unit, "dogfight_missiles")
            MENU_GROUP_COMMAND:New(moose_group, "Spawn enemy bandit EITHER", unit_specific_menu, self.SpawnBandit, self, moose_unit, "dogfight")
            MENU_GROUP_COMMAND:New(moose_group, "Delete my bandits", unit_specific_menu, self.DeleteBandits, self, player_name)
        end
    end    
end

function DOGFIGHTER:DeleteRadioMenu(moose_unit)
    for unit_name, menu in pairs(self.specific_unit_menus) do
        if unit_name == moose_unit:GetPlayerName() then
            menu:Remove()
        end
    end    
end

function DOGFIGHTER:DeleteBandits(player_name)
    local possible_enemies = SET_GROUP:New()
                                      :FilterPrefixes(self.name_prefix .. player_name)
                                      :FilterOnce()
                                      :GetSetObjects()

    for _, each in pairs(possible_enemies) do
        each:Destroy()
    end
end

function DOGFIGHTER:OnEventPlayerEnterAircraft(event_data)
    local moose_unit = event_data.IniUnit
    if moose_unit:GetCategoryName() == "Airplane" then
        self:BuildMenuStructure(moose_unit)
    end
end
