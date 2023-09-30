SHAPE_BASE = {
    ClassName = "SHAPE_BASE",
    Name = "",
    CenterVec2 = nil,
    Points = {},
    Coords = {},
    MarkIDs = {}
}

function SHAPE_BASE:New()
    self = BASE:Inherit(self, BASE:New())
    return self
end

function SHAPE_BASE:FindOnMap(shape_name)
    self = BASE:Inherit(self, BASE:New())

    local found = false

    for _, layer in pairs(env.mission.drawings.layers) do
        for _, object in pairs(layer["objects"]) do
            if string.find(object["name"], shape_name, 1, true) then
                self.Name = object["name"]
                self.CenterVec2 = { x = object["mapX"], y = object["mapY"] }
                found = true
            end
        end
    end
    if not found then
        self:E("Can't find a shape with name " .. shape_name)
    end
    return self
end

function SHAPE_BASE:Offset(new_vec2)
    local offset_vec2 = UTILS.Vec2Subtract(new_vec2, self.CenterVec2)
    self.CenterVec2 = new_vec2
    if self.ClassName == "POLYGON" then
        for _, point in pairs(self.Points) do
            point.x = point.x + offset_vec2.x
            point.y = point.y + offset_vec2.y
        end
    end
end

function SHAPE_BASE:GetName()
    return self.Name
end

function SHAPE_BASE:GetCenterVec2()
    return self.CenterVec2
end

function SHAPE_BASE:GetCenterCoordinate()
    return COORDINATE:NewFromVec2(self.CenterVec2)
end

function SHAPE_BASE:GetCoordinate()
    return self:GetCenterCoordinate()
end

function SHAPE_BASE:ContainsPoint(_)
    self:E("This needs to be set in the derived class")
end

function SHAPE_BASE:ContainsUnit(unit_name)
    local unit = UNIT:FindByName(unit_name)

    if unit == nil or not unit:IsAlive() then
        return false
    end

    if self:ContainsPoint(unit:GetVec2()) then
        return true
    end
    return false
end

function SHAPE_BASE:ContainsAnyOfGroup(group_name)
    local group = GROUP:FindByName(group_name)

    if group == nil or not group:IsAlive() then
        return false
    end

    for _, unit in pairs(group:GetUnits()) do
        if self:ContainsPoint(unit:GetVec2()) then
            return true
        end
    end
    return false
end

function SHAPE_BASE:ContainsAllOfGroup(group_name)
    local group = GROUP:FindByName(group_name)

    if group == nil or not group:IsAlive() then
        return false
    end

    for _, unit in pairs(group:GetUnits()) do
        if not self:ContainsPoint(unit:GetVec2()) then
            return false
        end
    end
    return true
end
