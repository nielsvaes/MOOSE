
do
    CCWEAPON = {
        ClassName = "CCWEAPON"
    }

    function CCWEAPON:New(dcs_object)
        self = BASE:Inherit(self, BASE:New())
        self.dcs_object = dcs_object
        self.fired_by = nil
        self.release_heading = nil
        self.release_altitude = nil
        self.release_coordinate = nil
        self.last_coordinate = nil
        self.impact_coordinate = nil
        self.impact_coordinate_terrain = nil
        self.has_impacted = false

        return self
    end

    function CCWEAPON:GetCoordinate()
        if not self:IsAlive() then
            self:E("Can't get coordinate because weapon no longer exists!")
            return
        end
        self.last_coordinate = COORDINATE:NewFromVec3(self.dcs_object:getPoint())
        return self.last_coordinate
    end

    function CCWEAPON:IsAlive()
        return self.dcs_object:isExist()
    end

    function CCWEAPON:GetLastCoordinate()
        return self.last_coordinate
    end
end

