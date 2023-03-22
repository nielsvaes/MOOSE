STRAFE_AREA = {
    ClassName = "STRAFE_AREA",
}

function STRAFE_AREA:New(area, targets, heading)
    self = BASE:Inherit(self, EVENTHANDLER:New())
    
    self.area = area
    self.targets = targets
    self.player_data = {}
    self.heading = heading

    self:HandleEvent(EVENTS.Hit)
    self:HandleEvent(EVENTS.ShootingStart)
    self:HandleEvent(EVENTS.ShootingEnd)

    self:I("Strafe area created")
    return self
end 

function STRAFE_AREA:GetGunAmmoCount(player_unit)
    local ammo = player_unit:GetAmmo()
    if ammo ~= nil then
        for _, weapon_type in pairs(player_unit:GetAmmo()) do
            if weapon_type.desc.warhead.explosiveMass < 2 then
                return weapon_type.count
            end
        end
    end
    return 0
end

function STRAFE_AREA:PlayerInZone(player_unit)
    if self.area:ContainsPoint(player_unit:GetVec2()) then
        return true
    end
    return false
end


function STRAFE_AREA:__EnsureUnitInfo(player_unit)
    if not table.contains_key(self.player_data, player_unit) then
        self.player_data[player_unit] = {}
    end
end

function STRAFE_AREA:OnEventShootingStart(event_data)
    local player_unit = event_data.IniUnit
    
    if not self:PlayerInZone(player_unit) then
        BASE:I(player_unit:GetName() .. " is not in the zone")
        return
    end
    
    self:__EnsureUnitInfo(player_unit)

    self.player_data[player_unit]["count"] = self:GetGunAmmoCount(player_unit)
    self.player_data[player_unit]["expended"] = 0
    self.player_data[player_unit]["heading"] = player_unit:GetHeading()
    self.player_data[player_unit]["altitude"] = UTILS.MetersToFeet(player_unit:GetAltitude(true))
end

function STRAFE_AREA:OnEventShootingEnd(event_data)
    local player_unit = event_data.IniUnit
    
    if not self:PlayerInZone(player_unit) then
        return
    end

    local previous_ammo_count = self.player_data[player_unit]["count"]
    local expended_rounds = previous_ammo_count - self:GetGunAmmoCount(player_unit)

    self.player_data[event_data.IniUnit]["count"]    = self:GetGunAmmoCount(player_unit)
    self.player_data[event_data.IniUnit]["expended"] = expended_rounds

    BASE:ScheduleOnce(15, function()
        self:ShowHitData(player_unit)
    end)
end

function STRAFE_AREA:OnEventHit(event_data)
    local player_unit = event_data.IniUnit
    
    if not self:PlayerInZone(player_unit) then
        return
    end
    if self.player_data[player_unit]["hits"] == nil then
        self.player_data[player_unit]["hits"] = 1
    end

    self.player_data[player_unit]["hits"] = self.player_data[player_unit]["hits"] + 1
    MessageToAll(tostring(self.player_data[player_unit]["hits"]))
end

function STRAFE_AREA:ShowHitData(player_unit)
    local expended = self.player_data[player_unit]["expended"]
    local hits     = self.player_data[player_unit]["hits"]
    local heading  = self.player_data[player_unit]["heading"]
    local altitude  = self.player_data[player_unit]["altitude"]
    local pct = (100 / expended) * hits

    local overall = "Pass"
    local heading_rating = "(Pass)"
    if not UTILS.AngleBetween(heading, self.heading - 15, self.heading + 15) then
        heading_rating = "(Fail)"
        overall = "Fail"
    end

    local altitude_rating = "(Pass)"
    if altitude < 3000 then
        altitude_rating = "(Fail)"
        overall = "Fail"
    end

    local pct_rating = "(Pass)"
    if pct < 5 then
        pct_rating = "(Fail)"
        overall = "Fail"
    end

    local msg = string.format("%s\n", player_unit:GetPlayerName())
    msg = msg .. string.format("Heading: %d %s\n", heading, heading_rating)
    msg = msg .. string.format("Altitude: %d ft AGL %s\n", altitude, altitude_rating)
    msg = msg .. string.format("Shot: %d\n", expended)
    msg = msg .. string.format("Hits: %d\n", hits)
    msg = msg .. string.format("Percentage: %d %s\n", pct, pct_rating)
    msg = msg .. "_______________\n"
    msg = msg .. string.format("Overall: %s", overall)
    MessageToAll(msg, 20)

    self.player_data[player_unit]["count"] = self:GetGunAmmoCount(player_unit)
    self.player_data[player_unit]["expended"] = 0
    self.player_data[player_unit]["hits"] = 0
    self.player_data[player_unit]["heading"] = 0
    self.player_data[player_unit]["altitude"] = 0
end
