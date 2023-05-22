CIRCLE = {
    ClassName = "CIRCLE",
    Radius = nil,
}

function CIRCLE:FindOnMap(shape_name)
    self = BASE:Inherit(self, SHAPE_BASE:FindOnMap(shape_name))
    for _, layer in pairs(env.mission.drawings.layers) do
        for _, object in pairs(layer["objects"]) do
            if string.find(object["name"], shape_name) then
                if object["polygonMode"] == "circle" then
                    self.Radius = object["radius"]
                end
            end
        end
    end

    return self
end

function CIRCLE:Find(shape_name)
    return _DATABASE:FindShape(shape_name)
end

function CIRCLE:New(vec2, radius)
    self = BASE:Inherit(self, SHAPE_BASE:New())
    self.CenterVec2 = vec2
    self.Radius = radius
    return self
end

function CIRCLE:GetRadius()
    return self.Radius
end

function CIRCLE:ContainsPoint(point)
    if ((point.x - self.CenterVec2.x) ^ 2 + (point.y - self.CenterVec2.y) ^ 2) ^ 0.5 <= self.Radius then
        return true
    end
    return false
end

function CIRCLE:PointInSector(point, sector_start, sector_end, center, radius)
    center = center or self.CenterVec2
    radius = radius or self.Radius

    local function are_clockwise(v1, v2)
        return -v1.x * v2.y + v1.y * v2.x > 0
    end

    local function is_in_radius(rp)
        return rp.x * rp.x + rp.y * rp.y <= radius ^ 2
    end

    local rel_pt = {
        x = point.x - center.x,
        y = point.y - center.y
    }

    local rel_sector_start = {
        x = sector_start.x - center.x,
        y = sector_start.y - center.y,
    }

    local rel_sector_end = {
        x = sector_end.x - center.x,
        y = sector_end.y - center.y,
    }

    return not are_clockwise(rel_sector_start, rel_pt) and
           are_clockwise(rel_sector_end, rel_pt) and
           is_in_radius(rel_pt, radius)
end

function CIRCLE:UnitInSector(unit_name, sector_start, sector_end, center, radius)
    center = center or self.CenterVec2
    radius = radius or self.Radius

    if self:PointInSector(UNIT:FindByName(unit_name):GetVec2(), sector_start, sector_end, center, radius) then
        return true
    end
    return false
end

function CIRCLE:AnyOfGroupInSector(group_name, sector_start, sector_end, center, radius)
    center = center or self.CenterVec2
    radius = radius or self.Radius

    for _, unit in pairs(GROUP:FindByName(group_name):GetUnits()) do
        if self:PointInSector(unit:GetVec2(), sector_start, sector_end, center, radius) then
            return true
        end
    end
    return false
end

function CIRCLE:AllOfGroupInSector(group_name, sector_start, sector_end, center, radius)
    center = center or self.CenterVec2
    radius = radius or self.Radius

    for _, unit in pairs(GROUP:FindByName(group_name):GetUnits()) do
        if not self:PointInSector(unit:GetVec2(), sector_start, sector_end, center, radius) then
            return false
        end
    end
    return true
end

function CIRCLE:UnitInRadius(unit_name, center, radius)
    center = center or self.CenterVec2
    radius = radius or self.Radius

    if UTILS.IsInRadius(center, UNIT:FindByName(unit_name):GetVec2(), radius) then
        return true
    end
    return false
end

function CIRCLE:AnyOfGroupInRadius(group_name, center, radius)
    center = center or self.CenterVec2
    radius = radius or self.Radius

    for _, unit in pairs(GROUP:FindByName(group_name):GetUnits()) do
        if UTILS.IsInRadius(center, unit:GetVec2(), radius) then
            return true
        end
    end
    return false
end

function CIRCLE:AllOfGroupInRadius(group_name, center, radius)
    center = center or self.CenterVec2
    radius = radius or self.Radius

    for _, unit in pairs(GROUP:FindByName(group_name):GetUnits()) do
        if not UTILS.IsInRadius(center, unit:GetVec2(), radius) then
            return false
        end
    end
    return true
end

function CIRCLE:GetRandomVec2()
    local angle = math.random() * 2 * math.pi

    local rx = math.random(0, self.Radius) * math.cos(angle) + self.CenterVec2.x
    local ry = math.random(0, self.Radius) * math.sin(angle) + self.CenterVec2.y

    return {x=rx, y=ry}
end

function CIRCLE:GetRandomVec2OnBorder()
    local angle = math.random() * 2 * math.pi

    local rx = self.Radius * math.cos(angle) + self.CenterVec2.x
    local ry = self.Radius * math.sin(angle) + self.CenterVec2.y

    return {x=rx, y=ry}
end

function CIRCLE:GetBoundingBox()
    local min_x = self.CenterVec2.x - self.Radius
    local min_y = self.CenterVec2.y - self.Radius
    local max_x = self.CenterVec2.x + self.Radius
    local max_y = self.CenterVec2.y + self.Radius

    return {
        {x=min_x, y=min_x}, {x=max_x, y=min_y}, {x=max_x, y=max_y}, {x=min_x, y=max_y}
    }
end

