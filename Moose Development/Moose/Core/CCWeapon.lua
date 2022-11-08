
do
    CCWEAPON = {
        ClassName = "CCWEAPON"
    }

    function CCWEAPON:New(dcs_object)
        self = BASE:Inherit(self, BASE:New())
        self.dcs_object = dcs_object
        self.id = tostring(dcs_object.id_)
        self.fired_by = nil
        self.release_heading = nil
        self.release_altitude = nil
        self.release_coordinate = nil
        self.last_heading = nil
        self.last_velocity = nil
        self.type = self.dcs_object:getTypeName()
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

    function CCWEAPON:GetHeading()
        if not self:IsAlive() then
            self:E("Can't get coordinate because weapon no longer exists!")
            return
        end
        self.last_heading = UTILS.VecHdg(self.dcs_object:getVelocity())
        return self.last_heading
    end

    function CCWEAPON:GetVelocity()
        if not self:IsAlive() then
            self:E("Can't get coordinate because weapon no longer exists!")
            return
        end
        self.last_velocity = self.dcs_object:getVelocity()
        return self.last_velocity
    end

    function CCWEAPON:IsAlive()
        return self.dcs_object:isExist()
    end

    function CCWEAPON:GetLastCoordinate()
        return self.last_coordinate
    end

    function CCWEAPON:GetLastHeading()
        return self.last_heading
    end

    function CCWEAPON:GetLastVelocity()
        return self.last_velocity
    end

    function CCWEAPON:GetType()
        return self.type
    end

    function CCWEAPON:GetID()
        return self.id
    end
end

