do
    IMPACT_AREA = {
        ClassName = "IMPACT_AREA",
        TYPE = {
            SHAPE = "SHAPE",
            ZONE = "ZONE",
            UNDEFINED = "UNDEFINED"
        }
    }

    --- The function passed to an impact area will always have the impact_point and impact_area object added as
    --- the last 2 arguments of the function. A good way to construct the functions when creating the
    --- impact area object is


    --- local function on_impact(...)
    ---     local arg = {...}
    ---     local ccweapon = arg[1]
    ---     local impact_area = arg[2]
    ---
    ---     BASE:I(#arg)
    ---     BASE:I("-------------------------")
    ---
    ---     BASE:I("this is where the function thinks the weapon fell")
    ---     BASE:I(ccweapon.impact_coordinate_terrain:GetVec2())
    ---     BASE:I("Bomb impacted in " .. impact_area:GetName())
    ---     MessageToAll(("Bomb impacted in " .. impact_area:GetName()))
    ---
    ---     local distance = impact_area:GetCoordinate():Get2DDistance(ccweapon.impact_coordinate_terrain)
    ---     BASE:I("Bomb impact distance " .. tostring(UTILS.MetersToFeet(distance)))
    ---     BASE:I("Bomb impact angle " .. tostring(ccweapon.impact_angle))
    ---     MessageToAll("Bomb impact distance " .. tostring(UTILS.MetersToFeet(distance)), 20)
    --- end
    ---
    --- local ia_circle = IMPACT_AREA:New(CIRCLE:Find("ia_circle"), IMPACT_AREA.TYPE.SHAPE, say_hello, { "Nissa"})
    --- IMPACT_AREA_MANAGER:Get():Add(ia_circle)


    function IMPACT_AREA:New(area, type, impact_function, impact_function_args, delete_after_impact, name)
        self = BASE:Inherit(self, BASE:New())
        self.f = impact_function
        self.args = impact_function_args or {}
        self.type = type
        self.area = area
        self.name = name or area:GetName()
        self.attached_unit = nil
        self.min_height = -100
        self.max_height = -100
        self.delete_after_impact = delete_after_impact or false

        return self
    end

    function IMPACT_AREA:ContainsPoint(point, height)
        height = height or -100
        local in_area = false
        local correct_height = false

        if self.min_height == -100 then
            correct_height = true
        else
            if height > self.min_height and height < self.max_height then
                correct_height = true
            end
        end

        if self.type == IMPACT_AREA.TYPE.ZONE then
            if UTILS.IsInRadius(point, self.area:GetVec2(), self.area:GetRadius()) then
                in_area = true
            end
        else
            if self.area:ContainsPoint(point) then
                in_area = true
            end
        end

        self:I(self:GetCoordinate():GetVec2())
        self:I(self:GetName() .. ": in_area        -> " .. tostring(in_area))
        self:I(self:GetName() .. ": correct_height -> " .. tostring(correct_height))
        return in_area and correct_height
    end

    function IMPACT_AREA:ExecImpactFunction(ccweapon)
        BASE:I("passing this weapon to the function")
        BASE:I(ccweapon.id)

        local args = {ccweapon, self}
        for _, argument in pairs(self.args) do
            table.insert(args, #args + 1, argument)
        end

        return self.f(unpack(args))
    end

    function IMPACT_AREA:GetName()
        return self.name
    end

    function IMPACT_AREA:GetCoordinate()
        return self.area:GetCoordinate()
    end

    function IMPACT_AREA:AttachToUnit(moose_unit)
        self.attached_unit = moose_unit
    end

    function IMPACT_AREA:UpdateLocationBasedOnUnit()
        if not self.attached_unit:IsAlive() or self.attached_unit == nil then
            GAMELOOP:Get():RemoveByID(self.name)
            return
        end

        self.area:Offset(self.attached_unit:GetCoordinate():GetVec2())
    end

    function IMPACT_AREA:SetMinHeight(value)
        self.min_height = value
    end

    function IMPACT_AREA:SetMaxHeight(value)
        self.max_height = value
    end

    function IMPACT_AREA:Add()
        IMPACT_AREA_MANAGER:Get():Add(self)
    end
end



