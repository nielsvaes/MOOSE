do
    CIRCLE = {
        ClassName = "CIRCLE",
        CenterVec2 = nil,
        Radius = nil,
        CenterCoordinate = nil,
        Name = nil
    }

    function CIRCLE:Find(line_name)
        local self = BASE:Inherit(self, BASE:New())

        for _, layer in pairs(env.mission.drawings.layers) do
            for _, object in pairs(layer["objects"]) do
                if string.find(object["name"], line_name) then
                    if object["polygonMode"] == "circle" then
                        self.Name = object["name"]
                        self.CenterVec2 = {x = object["mapX"], y = object["mapY"]}
                        self.Radius = object["radius"]
                        self.CenterCoordinate = COORDINATE:NewFromVec2(self.CenterVec2)
                    end
                end
            end
        end

        return self
    end

    function CIRCLE:GetCenterVec2()
        return self.CenterVec2
    end

    function CIRCLE:GetCenterCoordinate()
        return self.CenterCoordinate
    end

    function CIRCLE:GetRadius()
        return self.Radius
    end
end
