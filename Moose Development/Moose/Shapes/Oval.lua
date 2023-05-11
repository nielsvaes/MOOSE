OVAL = {
    ClassName = "OVAL",
    MajorAxis = nil,
    MinorAxis = nil,
    Angle = 0
}

function OVAL:FindOnMap(shape_name)
    self = BASE:Inherit(self, SHAPE_BASE:FindOnMap(shape_name))
    for _, layer in pairs(env.mission.drawings.layers) do
        for _, object in pairs(layer["objects"]) do
            if string.find(object["name"], shape_name) then
                if object["polygonMode"] == "oval" then
                    self.MajorAxis = object["r1"]
                    self.MinorAxis = object["r2"]
                    self.Angle = object["angle"]
                end
            end
        end
    end

    return self
end

function OVAL:New(vec2, major_axis, minor_axis, angle)
    self = BASE:Inherit(self, SHAPE_BASE:New())
    self.CenterVec2 = vec2
    self.MajorAxis = major_axis
    self.MinorAxis = minor_axis
    self.Angle = angle or 0

    return self
end

function OVAL:Find(shape_name)
    return _DATABASE:FindShape(shape_name)
end

function OVAL:GetMajorAxis()
    return self.MajorAxis
end

function OVAL:GetMinorAxis()
    return self.MinorAxis
end

function OVAL:GetAngle()
    return self.Angle
end

function OVAL:SetMajorAxis(value)
    self.MajorAxis = value
end

function OVAL:SetMinorAxis(value)
    self.MinorAxis = value
end

function OVAL:SetAngle(value)
    self.Angle = value
end

function OVAL:ContainsPoint(point)
    local cos, sin = math.cos, math.sin
    local dx = point.x - self.CenterVec2.x
    local dy = point.y - self.CenterVec2.y
    local rx = dx * cos(self.Angle) + dy * sin(self.Angle)
    local ry = -dx * sin(self.Angle) + dy * cos(self.Angle)
    return rx * rx / (self.MajorAxis * self.MajorAxis) + ry * ry / (self.MinorAxis * self.MinorAxis) <= 1
end


function OVAL:GetRandomVec2()
    local theta = math.rad(self.Angle)

    local random_point = math.sqrt(math.random())  --> uniformly
    --local random_point = math.random()  --> more clumped around center
    local phi = math.random() * 2 * math.pi
    local x_c = random_point * math.cos(phi)
    local y_c = random_point * math.sin(phi)
    local x_e = x_c * self.MajorAxis
    local y_e = y_c * self.MinorAxis
    local rx = (x_e * math.cos(theta) - y_e * math.sin(theta)) + self.CenterVec2.x
    local ry = (x_e * math.sin(theta) + y_e * math.cos(theta)) + self.CenterVec2.y

    return {x=rx, y=ry}
end

function OVAL:GetBoundingBox()
    local min_x = self.CenterVec2.x - self.MajorAxis
    local min_y = self.CenterVec2.y - self.MinorAxis
    local max_x = self.CenterVec2.x + self.MajorAxis
    local max_y = self.CenterVec2.y + self.MinorAxis
    return {
        {x=min_x, y=min_x}, {x=max_x, y=min_y}, {x=max_x, y=max_y}, {x=min_x, y=max_y}
    }
end

function OVAL:Draw(angle)
    angle = angle or self.Angle
    local coor = self:GetCenterCoordinate()

    table.add(self.MarkIDs, coor:CircleToAll(self.MajorAxis))
    table.add(self.MarkIDs, coor:CircleToAll(self.MinorAxis))
    table.add(self.MarkIDs, coor:LineToAll(coor:Translate(self.MajorAxis, self.Angle)))

    local pt_1 = coor:Translate(self.MajorAxis, self.Angle)
    local pt_2 = coor:Translate(self.MinorAxis, self.Angle - 90)
    local pt_3 = coor:Translate(self.MajorAxis, self.Angle - 180)
    local pt_4 = coor:Translate(self.MinorAxis, self.Angle - 270)
    table.add(self.MarkIDs, pt_1:QuadToAll(pt_2, pt_3, pt_4), -1, {0, 1, 0}, 1, {0, 1, 0})
end

function OVAL:RemoveDraw()
    for _, mark_id in pairs(self.MarkIDs) do
        UTILS.RemoveMark(mark_id)
    end
end


