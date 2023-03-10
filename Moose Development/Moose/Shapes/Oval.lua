OVAL = {
    ClassName = "OVAL",
    MajorAxis = nil,
    MinorAxis = nil
}

function OVAL:FindOnMap(shape_name)
    self = BASE:Inherit(self, SHAPE_BASE:FindOnMap(shape_name))
    for _, layer in pairs(env.mission.drawings.layers) do
        for _, object in pairs(layer["objects"]) do
            if string.find(object["name"], shape_name) then
                if object["polygonMode"] == "oval" then
                    self.MajorAxis = object["r1"]
                    self.MinorAxis = object["r2"]
                end
            end
        end
    end

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

function OVAL:ContainsPoint(point)
    return ((point.x - self.CenterVec2.x) ^ 2) / self.MajorAxis ^ 2 + ((point.y - self.CenterVec2.y) ^ 2) / self.MinorAxis ^ 2 <= 1
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

