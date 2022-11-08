do
    POLYGON = {
        ClassName = "POLYGON",
        Points = {},
        Coords = {},
        Name = nil
    }

    function POLYGON:Find(line_name)
        local self = BASE:Inherit(self, BASE:New())

        for _, layer in pairs(env.mission.drawings.layers) do
            for _, object in pairs(layer["objects"]) do
                if string.find(object["name"], line_name) then
                    if (object["primitiveType"] == "Line" and object["closed"] == true) or (object["polygonMode"] == "free") then
                        self.Name = object["name"]
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

        return self
    end

    function POLYGON:GetName()
        return self.Name
    end

    function POLYGON:GetCentroid()
        local function sum(t)
            local total = 0
            for _, value in pairs(t) do
                total = total + value
            end
            return total
        end

        local x_values = {}
        local y_values = {}
        local length = table.length(self.Points)

        for _, point in pairs(self.Points) do
            table.insert(x_values, point.x)
            table.insert(y_values, point.y)
        end
        
        local x = sum(x_values) / length
        local y = sum(y_values) / length

        return {
                ["x"] = x,
                ["y"] = y
               }
    end

    function POLYGON:Coordinates()
        return self.Coords
    end

    function POLYGON:GetStartCoordinate()
        return self.Coords[1]
    end

    function POLYGON:GetEndCoordinate()
        return self.Coords[#self.Coords]
    end

    function POLYGON:GetStartPoint()
        return self.Points[1]
    end

    function POLYGON:GetEndPoint()
        return self.Points[#self.Points]
    end

    function POLYGON:GetPoints()
        return self.Points
    end

    function POLYGON:ContainsPoint(point)
        local odd = false
        local i = 0
        local j = #self.Points - 1
    
        while i < #self.Points - 1 do
            i = i + 1
            if(((self.Points[i].y >= point.y ) ~= (self.Points[j].y >= point.y)) and
                (point.x <= (self.Points[j].x - self.Points[i].x) * (point.y - self.Points[i].y) / (self.Points[j].y - self.Points[i].y) + self.Points[i].x)
            )
            then
                odd = not odd
            end
            j = i
        end
        return odd
    end
end
