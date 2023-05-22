
do
    WEAPON_MANAGER = {
        ClassName = "WEAPON_MANAGER"
    }

    function WEAPON_MANAGER:Get()
        if _G["weapon_manager"] == nil then
            self = BASE:Inherit(self, BASE:New())

            self.weapon_parameter_update_rate = 30
            self.weapons = {}

            self:HandleEvent(EVENTS.Shot)
            self:HandleEvent(EVENTS.ShootingStart)
            self:HandleEvent(EVENTS.ShootingEnd)

            self.update_weapons_glf = GAMELOOPFUNCTION:New(self.UpdateWeapons, {self}, -1, "weapons_manager_glf", 60):Add()
            _G["weapon_manager"] = self
            self:I("Making new WEAPON_MANAGER")
        end
        return _G["weapon_manager"]
    end

    function WEAPON_MANAGER:UpdateWeapons()
        local to_remove = {}
        for _, ccweapon in pairs(self.weapons) do
            if not ccweapon:IsAlive() then -- get data from last instance before it exploded
                self:I("Weapon[" .. ccweapon.id .. "] is no longer alive")
                ccweapon.has_impacted = true
                ccweapon.impact_coordinate = ccweapon:GetLastCoordinate()
                ccweapon.impact_coordinate_terrain = COORDINATE:NewFromVec2(ccweapon.impact_coordinate:GetVec2())
                ccweapon.impact_angle = ccweapon:GetImpactAngle()

                table.add(to_remove, ccweapon)

                self:I(ccweapon.impact_coordinate_terrain:GetVec2())
                self:I(ccweapon.release_coordinate:GetVec2())

                IMPACT_AREA_MANAGER:Get():WeaponImpact(ccweapon)
            end
        end

        for _, ccweapon in pairs(to_remove) do
            self:RemoveWeapon(ccweapon)
            GAMELOOP:Get():RemoveByID(ccweapon:GetID())
        end
    end

    function WEAPON_MANAGER:RemoveWeapon(ccweapon)
        table.remove_by_value(self.weapons, ccweapon)
        self:I(#self.weapons)
    end

    function WEAPON_MANAGER:GetImpactedWeapons()
        local return_list = {}
        for _, ccweapon in pairs(self.weapons) do
            if ccweapon.has_impacted then
                table.insert(return_list, #return_list + 1, ccweapon)
            end
        end
        return return_list
    end

    function WEAPON_MANAGER:GetNonImpactedWeapons()
        local return_list = {}
        for _, ccweapon in pairs(self.weapons) do
            if not ccweapon.has_impacted then
                table.insert(return_list, #return_list + 1, ccweapon)
            end
        end
        return return_list
    end

    function WEAPON_MANAGER:ClearAll()
        self.weapons = {}
    end

    function WEAPON_MANAGER:SetWeaponParameterUpdateRate(rate)
        self.weapon_parameter_update_rate = rate
    end

    function WEAPON_MANAGER:OnEventShot(event_data)
        self:I("Weapon launch detected")
        local unit = event_data.IniUnit
        local weapon_dcs_object = event_data.weapon
        local heading = unit:GetHeading()
        local tickrate = self.weapon_parameter_update_rate
        if event_data.IniPlayerName ~= nil then tickrate = 60 end

        local ccweapon = CCWEAPON:New(weapon_dcs_object)
        ccweapon.fired_by = unit
        ccweapon.release_heading = heading
        ccweapon.release_altitude = unit:GetAltitude()
        ccweapon.release_coordinate =  ccweapon:GetCoordinate()
        ccweapon.release_pitch = unit:GetPitch()
        ccweapon.impact_coordinate = nil
        ccweapon.impact_coordinate_terrain = nil
        self:I("Weapon type: " .. ccweapon:GetType())

        self:I("Making GLF for weapon")
        GAMELOOPFUNCTION:New( function() ccweapon:UpdateAll() end, {}, -1, ccweapon:GetID())
                        :SetTimesPerSecond(tickrate)
                        :SetExitFunction(function() return not ccweapon:IsAlive()  end)
                        :Add()

        table.insert(self.weapons, ccweapon)
    end
end
