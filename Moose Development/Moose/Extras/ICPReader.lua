ICPREADER = {
    ClassName = "ICPREADER",
}

ICPREADERBUTTONS = {
    "COM1", "COM2", "IFF", "LIST", "AA", "AG",
    "1", "2", "3", "RCL",
    "4", "5", "6", "ENTR",
    "7", "8", "9", "0",
    "DCSUp", "DCSDown", "DCSLeft", "DCSRight",
    "RockerUp", "RockerDown"
}

function ICPREADER:New()
    self = BASE:Inherit(self, BASE:New())
    self.current_combo = {}

    self.state = "default"

    self.coordinate_input = false

    self.inputted_coordinate = ""


    return self
end


function ICPREADER:RegisterButton(button)
    if button == "DCSLeft" then
        self:Reset()
        return
    end

    if self.state == "default" then
        table.insert(self.current_combo, button)
        self:CheckCombo()

    elseif self.state == "coordinate_input" then
        if button == "RCL" then

            -- N63*58.352 E253*55.896 ELEV: 12
            if string.len(self.inputted_coordinate) == 29 then
                self.inputted_coordinate = string.remove_last_characters(self.inputted_coordinate, 8)
            elseif string.len(self.inputted_coordinate) == 5 or
                   string.len(self.inputted_coordinate) == 8 or
                   string.len(self.inputted_coordinate) == 17 or
                   string.len(self.inputted_coordinate) == 20 then
                self.inputted_coordinate = string.remove_last_characters(self.inputted_coordinate, 3)
            elseif string.len(self.inputted_coordinate) == 13 then
                self.inputted_coordinate = string.remove_last_characters(self.inputted_coordinate, 4)
            else
                self.inputted_coordinate = string.remove_last_characters(self.inputted_coordinate, 1)
            end

            dev_message(self.inputted_coordinate, true )
            dev_message(tostring(string.len(self.inputted_coordinate)))
            return
        end

        -- LAT
        if string.len(self.inputted_coordinate) == 0 then
            if button == "2" or button == "8" then
                self.inputted_coordinate = self.inputted_coordinate .. (button == "2" and "N" or "S")
            end


        elseif string.match(self.inputted_coordinate, "^[NS]") and not string.match(self.inputted_coordinate, "[WE]") then
            if string.len(self.inputted_coordinate) < 10 then
                if string.len(self.inputted_coordinate) == 3 then
                    self.inputted_coordinate = self.inputted_coordinate .. "°"
                elseif string.len(self.inputted_coordinate) == 6 then
                    self.inputted_coordinate = self.inputted_coordinate .. "."
                end
                if button:match("%d") then
                    self.inputted_coordinate = self.inputted_coordinate .. button
                end

                if string.len(self.inputted_coordinate) == 10 then
                    self.inputted_coordinate = self.inputted_coordinate .. " "
                end

            elseif string.len(self.inputted_coordinate) == 11 then
                if button == "4" or button == "6" then
                    self.inputted_coordinate = self.inputted_coordinate .. (button == "4" and "W" or "E")
                end
            end

        elseif string.match(self.inputted_coordinate, "[WE]") and string.len(self.inputted_coordinate) < 22 then
                if string.len(self.inputted_coordinate) == 15 then
                    self.inputted_coordinate = self.inputted_coordinate .. "°"
                elseif string.len(self.inputted_coordinate) == 18 then
                    self.inputted_coordinate = self.inputted_coordinate .. "."
                end
                if button:match("%d") then
                    self.inputted_coordinate = self.inputted_coordinate .. button
                end

                if string.len(self.inputted_coordinate) == 22 then
                    self.inputted_coordinate = self.inputted_coordinate .. " ELEV: "
                end

        -- elevation
        elseif string.len(self.inputted_coordinate) >= 22 then
            if button:match("%d") then
                self.inputted_coordinate = self.inputted_coordinate .. button
            end
        end

        dev_message(self.inputted_coordinate, true )
        dev_message(tostring(string.len(self.inputted_coordinate)))

        if string.len(self.inputted_coordinate) > 29 and button == "ENTR" then
            dev_message("sending coordinate: " .. self.inputted_coordinate, true)
            self.inputted_coordinate = ""
        end
    end
end

function ICPREADER:CheckCombo()
    if table.compare({"LIST", "0", "7"}, self.current_combo) then
        self.state = "coordinate_input"
        dev_message(self.state)
    end
end

function ICPREADER:Reset()
    self.current_combo = {}
    self.inputted_coordinate = ""
    self.state = "default"
end



