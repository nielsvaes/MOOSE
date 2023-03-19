
OBJECTIVE_MANAGER = {
    ClassName = "OBJECTIVE_MANAGER",
    json_file_path = "C:/coconutcockpit/objectives.json",
    SpawnedObjects = {}
}

function OBJECTIVE_MANAGER:Get(force)
    force = force or false
    if _G["objective_manager"] == nil or force then
        self = BASE:Inherit(self, BASE:New())

        self.weapon_parameter_update_rate = 30
        self.weapons = {}

        self.json_file_path = "C:/coconutcockpit/objectives.json"
        self.objective_spawn_info = {}

        _G["objective_manager"] = self
        self:I("Making new OBJECTIVE_MANAGER")
    end
    return _G["objective_manager"]
end


function OBJECTIVE_MANAGER:SpawnObjective(objective_id, vec2_pos, rotation, country)
    objective_id = tostring(objective_id)
    local json_data = UTILS.ReadJSON(self.json_file_path)
    local spawned_objects = {}
    local objective_table = json_data[objective_id]

    -- Statics
    for _, static_template in pairs(objective_table["statics"]) do
        local rotated = UTILS.RotatePointAroundPivot({ x=static_template.x, y=static_template.y}, { x=0, y=0}, rotation)
        static_template.x = rotated.x + vec2_pos.x
        static_template.y = rotated.y + vec2_pos.y
        static_template.name = UTILS.UniqueName(static_template.name)

        local static = SPAWNSTATIC:NewFromType(static_template.type, static_template.category, country)
                                  :InitNamePrefix(UTILS.UniqueName(objective_table.name))
                                  :InitShape(static_template.shape_type or "")
                                  :SpawnFromPointVec2(POINT_VEC2:NewFromVec2({x=static_template.x, y=static_template.y }), rotation + UTILS.ToDegree(static_template.heading))
        table.insert_unique(spawned_objects, static)
    end

    -- Groups
    for _, group_table in pairs(objective_table["groups"]) do
        local spawned_group = self:__LOAD_GROUP(group_table, vec2_pos, rotation, country)

        table.insert_unique(spawned_objects, spawned_group)

    end

    self.objective_spawn_info[objective_table.name] = spawned_objects
end



function OBJECTIVE_MANAGER:__LOAD_GROUP(group_table, vec2_pos, rotation, country)
    local group_rotated = UTILS.RotatePointAroundPivot({ x=group_table.x, y=group_table.y}, {x=0, y=0}, rotation)
    group_rotated = UTILS.Vec2Add(group_rotated, vec2_pos)
    --group_table["visible"] = true
    --group_table["hidden"]  = false
    group_table["CountryID"] = country
    group_table["lateActivation"] = true

    for _, unit_table in pairs(group_table["units"]) do
        local unit_rotated = UTILS.RotatePointAroundPivot({ x=unit_table.x, y= unit_table.y}, { x=0, y=0}, rotation)
        unit_table.x = unit_rotated.x + vec2_pos.x
        unit_table.y = unit_rotated.y + vec2_pos.y
        unit_table.heading = UTILS.ToRadian(rotation) + unit_table.heading
    end

    for _, route_point in pairs(group_table["route"]["points"]) do
        local route_point_rotated = UTILS.RotatePointAroundPivot({ x= route_point.x, y= route_point.y}, { x=0, y=0}, rotation)
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



function OBJECTIVE_MANAGER:DestroyObjective(objective_name)
    for _, spawned_object in pairs(self.objective_spawn_info[objective_name] or {}) do
        self:I(spawned_object:GetName())
        spawned_object:Destroy()
    end
    self.objective_spawn_info[objective_name] = nil
end


function OBJECTIVE_MANAGER:EnsureJSON()
    OBJECTIVE_MANAGER.INFO_DICT = {}
    if UTILS.FileExists(OBJECTIVE_MANAGER.JSON_FILE_PATH) then
        BASE:I(".json exists, using data")
        INFO_DICT = UTILS.ReadJSON(OBJECTIVE_MANAGER.JSON_FILE_PATH)
    else
        lfs.mkdir("C:/coconutcockpit/")
    end
end


