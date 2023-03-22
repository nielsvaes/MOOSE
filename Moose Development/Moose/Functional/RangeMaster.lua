RANGE_MASTER = {
    ClassName = "CCRANGEWEAPONTRACKER",
}

function RANGE_MASTER:New(range_shape, impact_areas, strafe_targets)
    self = BASE:Inherit(self, EVENTHANDLER:New())

    self.range_shape = range_shape
    self.impact_areas = impact_areas or {}
    self.strafe_zones = strafe_targets or {}
    self.player_gun_ammo = {}

    self:HandleEvent(EVENTS.ShootingStart)
    self:HandleEvent(EVENTS.ShootingEnd)

    return self
end

function RANGE_MASTER:GetGunAmmoCount(player_unit)
    for _, weapon_type in pairs(player_unit:GetAmmo()) do
        if weapon_type.desc.warhead.explosiveMass < 2 then
            return weapon_type.count
        end
    end
end

function RANGE_MASTER:OnEventShootingStart(event_data)
    local player_unit = event_data.IniUnit
    local player_name = event_data.IniPlayerName
    if player_name == nil or not self.range_shape:ContainsPoint(player_unit:GetVec2())then
        return
    end

    self.player_gun_ammo[player_unit] = {
        count = self:GetGunAmmoCount(player_unit),
        expended = 0
    }
end

function RANGE_MASTER:OnEventShootingEnd(event_data)
    local player_unit = event_data.IniUnit
    local player_name = event_data.IniPlayerName
    if player_name == nil or not self.range_shape:ContainsPoint(player_unit:GetVec2())then
        return
    end

    local previous_ammo_count = self.player_gun_ammo[player_unit].count
    local expended_rounds = previous_ammo_count - self:GetGunAmmoCount(player_unit)

    self.player_gun_ammo[player_unit] = {
        count = self:GetGunAmmoCount(player_unit),
        expended = expended_rounds
    }
end


