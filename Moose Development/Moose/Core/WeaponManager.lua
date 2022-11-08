
do
    WEAPONMANAGER = {
        ClassName = "WEAPONMANAGER"
    }

    function WEAPONMANAGER:New()
        self = BASE:Inherit(self, BASE:New())

        self.weapons = {}

        self:HandleEvent(EVENTS.Shot)
        self:HandleEvent(EVENTS.ShootingStart)
        self:HandleEvent(EVENTS.ShootingEnd)

        return self
    end

    function WEAPONMANAGER:UpdateWeapons(_)
        for _, ccweapon in pairs(self.weapons) do
            ccweapon:GetCoordinate() -- actually fucking set the coordinate

            if not ccweapon:IsAlive() and not ccweapon.has_impacted then -- only update weapon one time after it has impacted
                self:I("Weapon[" .. ccweapon.id .. "] is no longer alive")
                ccweapon.has_impacted = true
                ccweapon.impact_coordinate = ccweapon:GetLastCoordinate()
                ccweapon.impact_coordinate_terrain = COORDINATE:NewFromVec2(ccweapon.impact_coordinate:GetVec2())

                self:I("Removing weapon[" .. ccweapon.id .. "]")
                self:RemoveWeapon(ccweapon)

                self:I("Informing ImpactAreaManager of weapon["  .. ccweapon.id .. "] impact")
                IMPACT_AREA_MANAGER:Get():WeaponImpactedAt(ccweapon.impact_coordinate_terrain:GetVec2())
            end
        end
    end

    function WEAPONMANAGER:RemoveWeapon(ccweapon)
        table.remove_by_value(self.weapons, ccweapon)
    end

    function WEAPONMANAGER:GetImpactedWeapons()
        local return_list = {}
        for _, ccweapon in pairs(self.weapons) do
            if ccweapon.has_impacted then
                table.insert(return_list, #return_list + 1, ccweapon)
            end
        end
        return return_list
    end

    function WEAPONMANAGER:GetNonImpactedWeapons()
        local return_list = {}
        for _, ccweapon in pairs(self.weapons) do
            if not ccweapon.has_impacted then
                table.insert(return_list, #return_list + 1, ccweapon)
            end
        end
        return return_list
    end

    function WEAPONMANAGER:ClearAll()
        self.weapons = {}
    end

    function WEAPONMANAGER:OnEventShot(event_data)
        local player_name = event_data.IniPlayerName
        if player_name == nil then
            return
        end

        self:I("Weapon launch detected")
        local player_unit = event_data.IniUnit
        local weapon_dcs_object = event_data.weapon
        local heading = player_unit:GetHeading()

        local ccweapon = CCWEAPON:New(weapon_dcs_object)
        ccweapon.fired_by = player_unit
        ccweapon.release_heading = heading
        ccweapon.release_altitude = UTILS.MetersToFeet(player_unit:GetAltitude())
        ccweapon.release_coordinate =  ccweapon:GetCoordinate()
        ccweapon.impact_coordinate = nil
        ccweapon.impact_coordinate_terrain = nil

        table.insert(self.weapons, ccweapon)
    end
end
