OBJECTIVE_MANAGER = {
    ClassName = "OBJECTIVE_MANAGER",
    SpawnedObjects = {},
}

function OBJECTIVE_MANAGER:New(json_file_path, indexing_zone_search_prefix, indexing_zone_random_refix)
    local self = BASE:Inherit(self, BASE:New())
    if not string.contains(package.path, ";.\\Scripts\\?.lua") then
        package.path = package.path ..  ";.\\Scripts\\?.lua"
    end
    local JSON = require("json")


    if UTILS.FileExists(json_file_path) then
        self.json_file_path = json_file_path
        self.objectives_info_table = UTILS.ReadJSON(json_file_path)
    else
        self.objectives_info_table = JSON:decode(json_file_path)
    end
    BASE:I(self.json_file_path)
    BASE:I("^^^^^^^^^^^^^^^^^^^^^^^ self.json_file_path ^^^^^^^^^^^^^^^^^^^^^^")

    self.objective_spawn_info = {}
    self.ID = 1

    self.indexing_zone_search_prefix = indexing_zone_search_prefix or "obj_"
    self.indexing_zone_random_prefix = indexing_zone_random_refix or "random"

    return self
end

function OBJECTIVE_MANAGER:IndexObjectives()
    local info_dict = UTILS.ReadJSON(self.json_file_path)
    local objective_zones = SET_ZONE:New():FilterPrefixes(self.indexing_zone_search_prefix):FilterOnce():GetSetObjects()
    local random_zones = SET_ZONE:New():FilterPrefixes(self.indexing_zone_random_prefix):FilterOnce():GetSetObjects()

    for _, objective_zone in pairs(objective_zones) do
        local objective_zone_name = objective_zone:GetName()
        local properties = UTILS.GetZoneProperties(objective_zone_name)
        if table.length(properties) > 0 and properties["name"] ~= nil and tonumber(properties["include"]) == 1 then
            BASE:I(properties["name"])
            -- get name, id and description from properties
            local objective_table = properties
            objective_table["global_x"] = objective_zone:GetVec2().x
            objective_table["global_y"] = objective_zone:GetVec2().y
            objective_table["statics"] = {}
            objective_table["groups"] = {}
            objective_table["random_zones"] = {}

            local statics = SET_STATIC:New():FilterZones({ objective_zone }):FilterOnce():GetSetObjects()
            local groups = SET_GROUP:New():FilterZones({ objective_zone }):FilterOnce():GetSetObjects()
            BASE:I(groups)

            -- save statics
            for _, static in pairs(statics) do
                if static:GetID() ~= nil then
                    local has_been_added = false
                    local static_unit_table = table.find_key_value_pair(env.mission.coalition, "unitId", tonumber(static:GetDCSObject():getID()))
                    local new_x = static_unit_table["x"] - objective_table["global_x"]
                    local new_y = static_unit_table["y"] - objective_table["global_y"]

                    static_unit_table["x"] = new_x
                    static_unit_table["y"] = new_y

                    for _, random_zone in pairs(random_zones) do
                        local zone_name = random_zone:GetName()
                        if UTILS.IsInRadius(random_zone:GetVec2(), objective_zone:GetVec2(), objective_zone:GetRadius()) then

                            local zone_poly = POLYGON:FromZone(zone_name)
                            if objective_table["random_zones"][zone_name] == nil then
                                objective_table["random_zones"][zone_name] = UTILS.GetZoneProperties(zone_name)
                                objective_table["random_zones"][zone_name]["statics"] = {}
                                objective_table["random_zones"][zone_name]["groups"] = {}
                            end

                            if zone_poly:ContainsPoint(static:GetVec2()) then
                                table.add(objective_table["random_zones"][zone_name]["statics"], static_unit_table)
                                has_been_added = true
                            end
                        end
                    end
                    if not has_been_added then
                        table.add(objective_table["statics"], static_unit_table)
                    end
                end
            end

            -- save groups
            for _, group in pairs(groups) do
                if group:GetID() ~= nil then
                    BASE:I("Searching for: ")
                    BASE:I(tostring(group:GetID()))
                    local has_been_added = false
                    local group_tables = table.find_key_value_pair(env.mission.coalition, "groupId", tonumber(group:GetID()), true, true)
                    for _, group_table in pairs({group_tables}) do
                        self:I("group table")
                        self:I(group_table)
                        local continue = true
                        if group_table["x"] ~= nil and continue then
                            local group_x = group_table["x"] - objective_table["global_x"]
                            local group_y = group_table["y"] - objective_table["global_y"]

                            group_table["x"] = group_x
                            group_table["y"] = group_y
                            continue = false

                            for _, unit_table in pairs(group_table["units"]) do
                                local unit_x = unit_table["x"] - objective_table["global_x"]
                                local unit_y = unit_table["y"] - objective_table["global_y"]

                                unit_table["x"] = unit_x
                                unit_table["y"] = unit_y
                            end

                            for _, route_point in pairs(group_table["route"]["points"]) do
                                local route_pt_x = route_point["x"] - objective_table["global_x"]
                                local route_pt_y = route_point["y"] - objective_table["global_y"]

                                route_point["x"] = route_pt_x
                                route_point["y"] = route_pt_y
                            end

                            for _, unit_table in pairs(group_table["units"]) do
                                if unit_table["callsign"] ~= nil then
                                    unit_table["callsign"] = {
                                        ["name"] = "whatever"
                                    }
                                end
                                BASE:I(unit_table)
                            end

                            for _, random_zone in pairs(random_zones) do
                                local zone_name = random_zone:GetName()
                                if UTILS.IsInRadius(random_zone:GetVec2(), objective_zone:GetVec2(), objective_zone:GetRadius()) then
                                    local zone_poly = POLYGON:FromZone(zone_name)
                                    if objective_table["random_zones"][zone_name] == nil then
                                        objective_table["random_zones"][zone_name] = UTILS.GetZoneProperties(zone_name)
                                        objective_table["random_zones"][zone_name]["statics"] = {}
                                        objective_table["random_zones"][zone_name]["groups"] = {}
                                    end
                                    if zone_poly:ContainsPoint(group:GetVec2()) then
                                        table.add(objective_table["random_zones"][zone_name]["groups"], group_table)
                                        has_been_added = true
                                    end
                                end
                            end
                            if not has_been_added then
                                table.add(objective_table["groups"], group_table)
                            end

                        end
                    end
                end
            end

            -- assign to global table
            info_dict[objective_table["name"]] = UTILS.DeepCopy(objective_table)
        end
    end

    BASE:I(info_dict)
    UTILS.WriteJSON(info_dict, self.json_file_path)
    BASE:I("JSON written")
end

function OBJECTIVE_MANAGER:SpawnObjective(objective_name, id, vec2_pos, rotation, country, extra_data)
    if id == nil then id = tostring(self:GetNewID()) end
    rotation = rotation or math.random(0, 360)
    extra_data = extra_data or {}

    local spawned_objects = {}
    local objective_table = UTILS.DeepCopy(self.objectives_info_table[objective_name])

    if objective_table == nil then
        MESSAGE:New(string.format("ERROR: There is no objective with the name [%s]", objective_name)):ToAll()
        return
    end

    if objective_table["keep_position"] == "1" then
        BASE:I(string.format("Spawning %s at the location it was saved", objective_table["name"]))
        vec2_pos = { x = objective_table["global_x"], y = objective_table["global_y"] }
        rotation = 0
    end

    -- Statics
    for _, static_table in pairs(objective_table["statics"]) do
        local static = self:__LoadStatic(static_table, vec2_pos, rotation, country)
        table.insert_unique(spawned_objects, static)
    end

    -- Groups
    for _, group_table in pairs(objective_table["groups"]) do
        local spawned_group = self:__LoadGroup(group_table, vec2_pos, rotation, country, extra_data)
        table.insert_unique(spawned_objects, spawned_group)
    end

    -- Randoms
    for _, random_zone_table in pairs(objective_table["random_zones"]) do
        local chance = math.random(random_zone_table["min"] or 0, random_zone_table["max"] or 100)
        for _, random_group_table in pairs(random_zone_table["groups"] or {}) do
            if UTILS.PercentageChance(chance) then
                local random_spawned_group = self:__LoadGroup(random_group_table, vec2_pos, rotation, country, extra_data)
                table.insert_unique(spawned_objects, random_spawned_group)
            end
        end
        for _, random_static_table in pairs(random_zone_table["statics"] or {}) do
            if UTILS.PercentageChance(chance) then
                local random_static = self:__LoadStatic(random_static_table, vec2_pos, rotation, country)
                table.insert_unique(spawned_objects, random_static)
            end
        end
    end

    self.objective_spawn_info[id] = {
        objects = spawned_objects,
    }

    return spawned_objects
end

function OBJECTIVE_MANAGER:__LoadStatic(static_table, vec2_pos, rotation, country)
    local rotated = UTILS.RotatePointAroundPivot({ x = static_table.x, y = static_table.y }, { x = 0, y = 0 }, rotation)
    static_table.x = rotated.x + vec2_pos.x
    static_table.y = rotated.y + vec2_pos.y
    static_table.name = UTILS.UniqueName(static_table.name)

    local static = SPAWNSTATIC:NewFromType(static_table.type, static_table.category, country)
                              :InitNamePrefix(UTILS.UniqueName(static_table.name))
                              :InitShape(static_table.shape_name or "")
                              :SpawnFromPointVec2(POINT_VEC2:NewFromVec2({ x = static_table.x, y = static_table.y }), rotation + UTILS.ToDegree(static_table.heading))
    return static
end

function OBJECTIVE_MANAGER:__LoadGroup(group_table, vec2_pos, rotation, country, extra_data)
    local group_rotated = UTILS.RotatePointAroundPivot({ x = group_table.x, y = group_table.y }, { x = 0, y = 0 }, rotation)
    group_rotated = UTILS.Vec2Add(group_rotated, vec2_pos)
    --group_table["visible"] = true
    --group_table["hidden"]  = false
    group_table["CountryID"] = country
    group_table["lateActivation"] = true
    table.merge(group_table, extra_data)

    for _, unit_table in pairs(group_table["units"]) do
        local unit_rotated = UTILS.RotatePointAroundPivot({ x = unit_table.x, y = unit_table.y }, { x = 0, y = 0 }, rotation)
        unit_table.x = unit_rotated.x + vec2_pos.x
        unit_table.y = unit_rotated.y + vec2_pos.y
        unit_table.heading = UTILS.ToRadian(rotation) + unit_table.heading
        unit_table["callsign"] = {
            [1] = 3,
            [2] = 1,
            [3] = 1,
            ["name"] = "Uzi11",
        }
    end

    for _, route_point in pairs(group_table["route"]["points"]) do
        local route_point_rotated = UTILS.RotatePointAroundPivot({ x = route_point.x, y = route_point.y }, { x = 0, y = 0 }, rotation)
        route_point.x = route_point_rotated.x + vec2_pos.x
        route_point.y = route_point_rotated.y + vec2_pos.y
    end

    local grp = CCMISSIONDB:Get():Add(group_table)
    local spawned_group = SPAWN:NewWithAlias(grp:GetName(), UTILS.UniqueName(grp:GetName()))
                               :SpawnFromVec2(group_rotated)
    BASE:I("this is spawned group")
    BASE:I(spawned_group:GetName())
    return spawned_group
end

function OBJECTIVE_MANAGER:DestroyObjective(id)
    --id = tostring(id)
    if table.contains_key(self.objective_spawn_info, id) then
        for _, object in pairs(self.objective_spawn_info[id].objects) do
            object:Destroy()
        end
    end
    self.objective_spawn_info[id] = nil
end

function OBJECTIVE_MANAGER:GetIDs()
    for id, each in pairs(self.objective_spawn_info) do
        BASE:I(id)
    end
end

function OBJECTIVE_MANAGER:DestroyAllObjectives()
    for id, each in pairs(self.objective_spawn_info) do
        self:DestroyObjective(id)
    end
end

function OBJECTIVE_MANAGER:EnsureJSON()
    OBJECTIVE_MANAGER.INFO_DICT = {}
    if UTILS.FileExists(OBJECTIVE_MANAGER.JSON_FILE_PATH) then
        BASE:I(".json exists, using data")
        info_dict = UTILS.ReadJSON(OBJECTIVE_MANAGER.JSON_FILE_PATH)
    else
        lfs.mkdir("C:/coconutcockpit/")
    end
end

function OBJECTIVE_MANAGER:GetNewID()
    self.ID = self.ID + 1
    return self.ID
end


