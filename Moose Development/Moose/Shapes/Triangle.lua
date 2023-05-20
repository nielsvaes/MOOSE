TRIANGLE = {
    ClassName = "TRIANGLE",
    Points = {},
    Coords = {},
    SurfaceArea = 0
}

function TRIANGLE:New(p1, p2, p3)
    local self = BASE:Inherit(self, SHAPE_BASE:New())
    self.Points = {p1, p2, p3}

    local center_x = (p1.x + p2.x + p3.x) / 3
    local center_y = (p1.y + p2.y + p3.y) / 3
    self.CenterVec2 = {x=center_x, y=center_y}

    for _, pt in pairs({p1, p2, p3}) do
        table.add(self.Coords, COORDINATE:NewFromVec2(pt))
    end

    self.SurfaceArea = math.abs((p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y)) * 0.5

    self.MarkIDs = {}
    return self
end

function TRIANGLE:ContainsPoint(pt, points)
    points = points or self.Points

    local function sign(p1, p2, p3)
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
    end

    local d1 = sign(pt, self.Points[1], self.Points[2])
    local d2 = sign(pt, self.Points[2], self.Points[3])
    local d3 = sign(pt, self.Points[3], self.Points[1])

    local has_neg = (d1 < 0) or (d2 < 0) or (d3 < 0)
    local has_pos = (d1 > 0) or (d2 > 0) or (d3 > 0)

    return not (has_neg and has_pos)    
end

function TRIANGLE:GetRandomVec2(points)
    points = points or self.Points
    local pt = {math.random(), math.random()}
    table.sort(pt)
    local s = pt[1]
    local t = pt[2] - pt[1]
    local u = 1 - pt[2]

    return {x = s * points[1].x + t * points[2].x + u * points[3].x,
            y = s * points[1].y + t * points[2].y + u * points[3].y}
end

function TRIANGLE:Draw()
        print("drawing triangle")
    table.add(self.MarkIDs, self.Coords[1]:LineToAll(self.Coords[2]))
    table.add(self.MarkIDs, self.Coords[2]:LineToAll(self.Coords[3]))
    table.add(self.MarkIDs, self.Coords[3]:LineToAll(self.Coords[1]))
end

function TRIANGLE:RemoveDraw()

    for _, mark_id in pairs(self.MarkIDs) do
        UTILS.RemoveMark(mark_id)
    end
end
