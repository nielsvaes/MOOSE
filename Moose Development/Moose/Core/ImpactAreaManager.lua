do
    IMPACT_AREA_MANAGER = {
        ClassName = "IMPACT_AREA_MANAGER"
    }

    function IMPACT_AREA_MANAGER:Get()
        if _G["impact_area_manager"] == nil then
            self = BASE:Inherit(self, BASE:New())
            self.areas = {}
            _G["impact_area_manager"] = self
        end

        return _G["impact_area_manager"]
    end

    function IMPACT_AREA_MANAGER:Add(impact_area)
        table.insert(self.areas, impact_area)
    end

    function IMPACT_AREA_MANAGER:WeaponImpactedAt(impact_point)
        for _, impact_area in pairs(self.areas) do
            if impact_area:ContainsPoint(impact_point) then
                BASE:I("Found an area where the bomb fell: " .. impact_area:GetName())
                impact_area:ExecImpactFunction()
            end
        end
    end

end
