


RED_FLAG_AIR_MANAGER = {
    ClassName = "RED_FLAG_AIR_MANAGER"
}

function RED_FLAG_AIR_MANAGER:Get()
    if _G["red_flag_air_manager"] == nil then
        self = BASE:Inherit(self, BASE:New())

        self.blue_players = {}
        self.red_players = {}

        _G["red_flag_air_manager"] = self
        self:I("Making new RED_FLAG_AIR_MANAGER")
    end
    return _G["red_flag_air_manager"]
end

function RED_FLAG_AIR_MANAGER:RegisterPlayer(unit_name)
    local player = RED_FLAG_PLAYER:FindByName(unit_name)
    if player:GetCoalitionName() == "blue" then
        table.insert_unique(self.blue_players, player)
    else
        table.insert_unique(self.red_players, player)
    end
end

function RED_FLAG_AIR_MANAGER:GetPlayer(unit_name)
    for _, player in pairs(table.combine(self.red_players, self.blue_players)) do
        if player:GetName() == unit_name then
            return player
        end
    end
end

function RED_FLAG_AIR_MANAGER:GetBluePlayers()
    return self.blue_players
end

function RED_FLAG_AIR_MANAGER:GetRedPlayers()
    return self.red_players
end

function RED_FLAG_AIR_MANAGER:GetAllPlayers()
    return table.combine(self.red_players, self.blue_players)
end
