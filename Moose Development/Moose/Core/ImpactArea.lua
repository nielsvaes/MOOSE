do
    IMPACT_AREA = {
        ClassName = "IMPACT_AREA",
        TYPE = {
            SHAPE = "SHAPE",
            ZONE = "ZONE",
            UNDEFINED = "UNDEFINED"
        }
    }

    function IMPACT_AREA:New(area, type, impact_function, impact_function_args, name)
        self = BASE:Inherit(self, BASE:New())
        self.f = impact_function
        self.args = impact_function_args
        self.type = type
        self.area = area
        self.name = name or area:GetName()

        return self
    end

    function IMPACT_AREA:ContainsPoint(point)
        if self.type == IMPACT_AREA.TYPE.ZONE then
            return UTILS.IsInRadius(point, self.area:GetVec2(), self.area:GetRadius())
        else
            return self.area:ContainsPoint(point)
        end
    end

    function IMPACT_AREA:ExecImpactFunction()
        return self.f(unpack(self.args))
    end

    function IMPACT_AREA:GetName()
        return self.name
    end
end



