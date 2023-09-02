
LINE = {
    ClassName = "LINE",
    Points = {},
    Coords = {},
}

function LINE:FindOnMap(line_name)
    local self = BASE:Inherit(self, SHAPE_BASE:FindOnMap(line_name))

    for _, layer in pairs(env.mission.drawings.layers) do
        for _, object in pairs(layer["objects"]) do
            if object["name"] == line_name then
                if object["primitiveType"] == "Line" then
                    for _, point in UTILS.spairs(object["points"]) do
                        local p = {x = object["mapX"] + point["x"],
                                   y = object["mapY"] + point["y"] }
                        local coord = COORDINATE:NewFromVec2(p)
                        table.insert(self.Points, p)
                        table.insert(self.Coords, coord)
                    end
                end
            end
        end
    end

    self:I(#self.Points)
    if #self.Points == 0 then
        return nil
    end

    self.MarkIDs = {}

    return self
end

function LINE:Find(shape_name)
    return _DATABASE:FindShape(shape_name)
end

function LINE:New(...)
    local self = BASE:Inherit(self, SHAPE_BASE:New())
    self.Points = {...}
    self:I(self.Points)
    for _, point in spairs(self.Points) do
        table.insert(self.Coords, COORDINATE:NewFromVec2(point))
    end
    return self
end

function LINE:Coordinates()
    return self.Coords
end

function LINE:GetStartCoordinate()
    return self.Coords[1]
end

function LINE:GetEndCoordinate()
    return self.Coords[#self.Coords]
end

function LINE:GetStartPoint()
    return self.Points[1]
end

function LINE:GetEndPoint()
    return self.Points[#self.Points]
end

function LINE:GetLength()
    local total_length = 0
        for i=1, #self.Points - 1 do
        local x1, y1 = self.Points[i]["x"], self.Points[i]["y"]
        local x2, y2 = self.Points[i+1]["x"], self.Points[i+1]["y"]
        local segment_length = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
        total_length = total_length + segment_length
    end
    return total_length
end

function LINE:GetRandomPoint(points)
    points = points or self.Points
    local rand = math.random() -- 0->1

    local random_x = points[1].x + rand * (points[2].x - points[1].x)
    local random_y = points[1].y + rand * (points[2].y - points[1].y)

    return { x= random_x, y= random_y }
end

function LINE:GetPointsInbetween(amount, start_point, end_point)
    start_point = start_point or self:GetStartPoint()
    end_point = end_point or self:GetEndPoint()

    local points = {}

    local difference = { x = end_point.x - start_point.x, y = end_point.y - start_point.y }
    local divided = { x = difference.x / amount, y = difference.y / amount }

    for j=0, amount do
        local part_pos = {x = divided.x * j, y = divided.y * j}
        -- add part_pos vector to the start point so the new point is placed along in the line
        local point = {x = start_point.x + part_pos.x, y = start_point.y + part_pos.y}
        table.insert(points, point)
    end
    return points
end

function LINE:GetPointsBetweenAsSineWave(amount, start_point, end_point, frequency, phase, amplitude)
    amount = amount or 20
    start_point = start_point or self:GetStartPoint()
    end_point = end_point or self:GetEndPoint()
    frequency = frequency or 1   -- number of cycles per unit of x
    phase = phase or 0           -- offset in radians
    amplitude = amplitude or 100 -- maximum height of the wave

    local points = {}

    -- Returns the y-coordinate of the sine wave at x
    local function sine_wave(x)
        return amplitude * math.sin(2 * math.pi * frequency * (x - start_point.x) + phase)
    end

    -- Plot x-amount of points on the sine wave between point_01 and point_02
    local x = start_point.x
    local step = (end_point.x - start_point.x) / 20
    for _=1, amount do
        local y = sine_wave(x)
        x = x + step
        table.add(points, {x=x, y=y})
    end
    return points
end

function LINE:GetBoundingBox()
    local min_x, min_y, max_x, max_y = self.Points[1].x, self.Points[1].y, self.Points[2].x, self.Points[2].y

    for i = 2, #self.Points do
        local x, y = self.Points[i].x, self.Points[i].y

        if x < min_x then
            min_x = x
        end
        if y < min_y then
            min_y = y
        end
        if x > max_x then
            max_x = x
        end
        if y > max_y then
            max_y = y
        end
    end
    return {
        {x=min_x, y=min_x}, {x=max_x, y=min_y}, {x=max_x, y=max_y}, {x=min_x, y=max_y}
    }
end

function LINE:Draw(points)
    points = points or self.Points
    table.add(self.MarkIDs, self.Coords[1]:LineToAll(self.Coords[2], -1, {0, 1, 0}))
end

function LINE:RemoveDraw()
    for _, mark_id in pairs(self.MarkIDs) do
        UTILS.RemoveMark(mark_id)
    end
end
