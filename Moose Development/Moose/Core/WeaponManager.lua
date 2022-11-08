
do
    WEAPONMANAGER = {
        ClassName = "WEAPONMANAGER"
    }

    function WEAPONMANAGER:New()
        self = BASE:Inherit(self, BASE:New())

        self.weapons = {}
        --self.missiles = {}

        self:HandleEvent(EVENTS.Shot)
        self:HandleEvent(EVENTS.ShootingStart)
        self:HandleEvent(EVENTS.ShootingEnd)

        return self
    end

    function WEAPONMANAGER:UpdateWeapons(_)
        for _, ccweapon in pairs(self.weapons) do
            if not ccweapon:IsAlive() and not ccweapon.has_impacted then -- only update weapon one time after it has impacted
                MessageToAll("Weapon is no longer alive")
                ccweapon.has_impacted = true
                ccweapon.impact_coordinate = ccweapon:GetLastCoordinate()
                ccweapon.impact_coordinate_terrain = COORDINATE:NewFromVec2(ccweapon.impact_coordinate:GetVec2())

                MessageToAll("Removing weapon")
                self:I(self.weapons)
                self:RemoveWeapon(ccweapon)
                self:I(self.weapons)

                MessageToAll("Informing ImpactAreaManager")
                CCMISSION.IMPACT_AREA_MANAGER:WeaponImpactedAt(ccweapon.impact_coordinate:GetVec2())
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


        --if not UTILS.IsInRadius(COORDINATE:NewFromVec3(weapon_dcs_object:getPoint()):GetVec2(),
        --                                               self.centroid_coord:GetVec2(),
        --                                               UTILS.NMToMeters(self.perimeter_distance_from_centroid)) then
        --    MessageToAll("Release not in bombing range area")
        --    return
        --end
        --
        --local weapon_timer = TIMER:New(self.UpdateWeaponPosition, self, weapon_dcs_object)
        --weapon_timer:SetMaxFunctionCalls(3000) -- don't think there's a weapon that won't impact within 5 minutes
        --weapon_timer:Start(nil, 0.1)
        --
        --table.insert_unique(self.weapon_data, weapon_dcs_object)
        --self.weapon_data[weapon_dcs_object] = {
        --    fired_by = player_unit,
        --    release_heading = heading,
        --    release_altitude = UTILS.MetersToFeet(player_unit:GetAltitude()),
        --    release_point =  weapon_dcs_object:getPoint(),
        --    position = weapon_dcs_object:getPoint(),
        --    timer = weapon_timer,
        --    has_impacted = false,
        --    target = nil,
        --    foul = false
        --}

        --self:BroadcastMessage(self.AUDIOFILES[1])

    end
end
