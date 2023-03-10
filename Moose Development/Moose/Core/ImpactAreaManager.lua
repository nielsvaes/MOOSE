do
    IMPACT_AREA_MANAGER = {
        ClassName = "IMPACT_AREA_MANAGER"
    }

    function IMPACT_AREA_MANAGER:Get()
        if _G["impact_area_manager"] == nil then
            self = BASE:Inherit(self, BASE:New())
            self.areas = {}
            _G["impact_area_manager"] = self
            self:I("Making new IMPACT_AREA_MANAGER")
        end

        return _G["impact_area_manager"]
    end

    function IMPACT_AREA_MANAGER:Add(impact_area)
        self:I("Adding: " .. impact_area:GetName())
        table.insert(self.areas, impact_area)
    end

    function IMPACT_AREA_MANAGER:Remove(impact_area)
        self:I("Removing: " .. impact_area:GetName())
        table.remove_by_value(self.areas, impact_area)
    end

    function IMPACT_AREA_MANAGER:AreaAtIndex(index)
        return self.areas[index]
    end

    function IMPACT_AREA_MANAGER:FindImpactAreaByName(name)
        for _, impact_area in pairs(self.areas) do
            if impact_area:GetName() == name then
                return impact_area
            end
        end
    end

    function IMPACT_AREA_MANAGER:WeaponImpact(ccweapon)
        self:I("Searching areas for impact")
        for _, impact_area in pairs(self.areas) do
            self:I("checking areas at height: " .. tostring(ccweapon.impact_coordinate:GetVec3().y) )
            if impact_area:ContainsPoint(ccweapon.impact_coordinate:GetVec2(), ccweapon.impact_coordinate:GetVec3().y) then
                if impact_area.delete_after_impact then
                    self:Remove(impact_area)
                end
                return impact_area:ExecImpactFunction(ccweapon)
            end
        end
        self:I("Weapon didn't fall in any of my areas")
    end

end
