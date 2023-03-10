
COORDINATE_MENU = {
    ClassName = "COORDINATE_MENU",
    Num = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
}


function COORDINATE_MENU:New(coa, parent_menu)
    self = BASE:Inherit(self, BASE:New())
    self.generated_menus = {}
    self.coalition = coa or coalition.side.BLUE
    self.parent_menu = parent_menu
    self.confirm_function = nil
    self:__ResetAll()

    return self
end

function COORDINATE_MENU:__ResetAll()
    self.latitude            = "X"
    self.longitude           = "X"
    self.lat_minutes         = "00"
    self.lat_seconds         = "00"
    self.lat_decimal_seconds = "000"

    self.lon_minutes         = "000"
    self.lon_seconds         = "00"
    self.lon_decimal_seconds = "000"

    self.final_string = ""
end

function COORDINATE_MENU:SetConfirmFunction(f, ...)
    self.args = {...}
    self.confirm_function = f
end

function COORDINATE_MENU:Remove()
    self:__ResetAll()
    if self.parent_menu ~= nil then
        self.parent_menu:Remove()
        return
    end

    for _, menu in pairs(self.generated_menus) do
        pcall(menu:Remove())
    end
end

function COORDINATE_MENU:MakeLLDMString()

    local final_string = self.latitude .. " "
    final_string = final_string .. self.lat_minutes .. " "
    final_string = final_string .. self.lat_seconds .. " "
    final_string = final_string .. self.lat_decimal_seconds .. "-"

    final_string = final_string .. self.longitude .. " "
    final_string = final_string .. self.lon_minutes .. " "
    final_string = final_string .. self.lon_seconds .. " "
    final_string = final_string .. self.lon_decimal_seconds
    return final_string
end

function COORDINATE_MENU:LLDM(latitude, longitude)
    self.latitude = latitude or "X"
    self.longitude = longitude or "X"

    if self.parent_menu ~= nil then
        table.insert(self.generated_menus, self.parent_menu)
    end

    local latitude_menu = MENU_COALITION:New(self.coalition, "Latitude", self.parent_menu)

    if self.latitude == "X" then
        MENU_COALITION_COMMAND:New(
            self.coalition,
            "North",
            latitude_menu,
            function()
                self.latitude = "N"
                MessageToAll(self:MakeLLDMString(), 9999, true)
            end
        )
        MENU_COALITION_COMMAND:New(
            self.coalition,
            "South",
            latitude_menu,
            function()
                self.latitude = "S"
                MessageToAll(self:MakeLLDMString(), 9999, true)
            end
        )
    end

    local lat_minutes_menu = MENU_COALITION:New(self.coalition, "Minutes", latitude_menu)
    UTILS.NestedMenu({self.Num, self.Num},
                          1,
                          lat_minutes_menu,
                          self.coalition,
                          nil,
                          true,
                          function(minutes)
                              self.lat_minutes = minutes
                              MessageToAll(self:MakeLLDMString(), 9999, true)
                          end
    )

    local lat_seconds_menu = MENU_COALITION:New(self.coalition, "Seconds", latitude_menu)
    UTILS.NestedMenu({self.Num, self.Num},
                          1,
                          lat_seconds_menu,
                          self.coalition,
                          nil,
                          true,
                          function(seconds)
                              self.lat_seconds = seconds
                              MessageToAll(self:MakeLLDMString(), 9999, true)
                          end
    )
    
    local lat_dec_minutes_menu = MENU_COALITION:New(self.coalition, "Decimals", latitude_menu)
    UTILS.NestedMenu({self.Num, self.Num, self.Num},
                          1,
                          lat_dec_minutes_menu,
                          self.coalition,
                          nil,
                          true,
                          function(seconds)
                              self.lat_decimal_seconds = seconds
                              MessageToAll(self:MakeLLDMString(), 9999, true)
                          end
    )
    
    local longitude_menu = MENU_COALITION:New(self.coalition, "Longitude", self.parent_menu)

    if self.longitude == "X" then
        MENU_COALITION_COMMAND:New(
            self.coalition,
            "East",
            longitude_menu,
            function()
                self.longitude = "E"
                MessageToAll(self:MakeLLDMString(), 9999, true)
            end
        )
        MENU_COALITION_COMMAND:New(
            self.coalition,
            "West",
            longitude_menu,
            function()
                self.longitude = "W"
                MessageToAll(self:MakeLLDMString(), 9999, true)
            end
        )
    end

    
    local lon_minutes_menu = MENU_COALITION:New(self.coalition, "Minutes", longitude_menu)
    UTILS.NestedMenu({self.Num, self.Num, self.Num},
                          1,
                          lon_minutes_menu,
                          self.coalition,
                          nil,
                          true,
                          function(minutes)
                              self.lon_minutes = minutes
                              MessageToAll(self:MakeLLDMString(), 9999, true)
                          end
    )
    
    local lon_seconds_menu = MENU_COALITION:New(self.coalition, "Seconds", longitude_menu)
    UTILS.NestedMenu({self.Num, self.Num},
                          1,
                          lon_seconds_menu,
                          self.coalition,
                          nil,
                          true,
                          function(seconds)
                              self.lon_seconds = seconds
                              MessageToAll(self:MakeLLDMString(), 9999, true)
                          end
    )
    
    local lon_dec_minutes_menu = MENU_COALITION:New(self.coalition, "Decimals", longitude_menu)
    UTILS.NestedMenu({self.Num, self.Num, self.Num},
                          1,
                          lon_dec_minutes_menu,
                          self.coalition,
                          nil,
                          true,
                          function(seconds)
                              self.lon_decimal_seconds = seconds
                              MessageToAll(self:MakeLLDMString(), 9999, true)
                          end
    )


    local confirm_cmd = MENU_COALITION_COMMAND:New(
        self.coalition,
    "Confirm choice",
        self.parent_menu,
        function() self.confirm_function(unpack(self.args)) end
    )

    table.insert(self.generated_menus, latitude_menu)
    table.insert(self.generated_menus, longitude_menu)
    table.insert(self.generated_menus, lat_minutes_menu)
    table.insert(self.generated_menus, lat_seconds_menu)
    table.insert(self.generated_menus, lat_dec_minutes_menu)
    table.insert(self.generated_menus, lon_minutes_menu)
    table.insert(self.generated_menus, lon_seconds_menu)
    table.insert(self.generated_menus, lon_dec_minutes_menu)
    table.insert(self.generated_menus, confirm_cmd)

end

function COORDINATE_MENU:LLP()

end

function COORDINATE_MENU:MGRS()

end

function COORDINATE_MENU:LL()

end
