
RANGE_CIRCLE = {
    ClassName = "RANGE_CIRCLE",

    SCORES = {
        DIRECT_HIT = {
            distance = 45,
            grade = "DIRECT HIT"
        },
        GOOD_HIT = {
            distance = 100,
            grade = "GOOD HIT"
        },
        POOR = {
            distance = 200,
            grade = "POOR"
        },
        COMPLETE_MISS = {
            distance = 999999,
            grade = "COMPLETE MISS"
        },
    },

    OBJECTS = {
        CONTAINER_20ft = {
            type = "container_20ft",
            category = "Fortifications",
            shape = "container_20ft",
            size = 20,
            rotation_offset = 0
        },
        CONTAINER_40ft = {
            type = "container_40ft",
            category = "Fortifications",
            shape = "container_40ft",
            size = 40,
            rotation_offset = 0
        },
        CONTAINER_WHITE = {
            type = "Container white",
            category = "Fortifications",
            shape = "konteiner_white",
            size = 30,
            rotation_offset = 0
        },
        ISO_CONTAINER = {
            type = "iso_container",
            category = "Cargos",
            shape = "iso_container_cargo",
            size = 30,
            rotation_offset = 90
        },
        ISO_CONTAINER_SMALL = {
            type = "iso_container_small",
            category = "Cargos",
            shape = "iso_container_small_cargo",
            size = 16,
            rotation_offset = 90
        },
        BARRIER = {
            type = "f_bar_cargo",
            category = "Cargos",
            shape = "f_bar_cargo",
            size = 15,
            rotation_offset = 90
        },
        TRUNKS_LONG = {
            type = "trunks_long_cargo",
            category = "Cargos",
            shape = "trunks_long_cargo",
            size = 35,
            rotation_offset = 90
        },
        TRUNKS_SHORT = {
            type = "trunks_small_cargo",
            category = "Cargos",
            shape = "trunks_small_cargo",
            size = 15,
            rotation_offset = 90
        },
        PIPES = {
            type = "pipes_big_cargo",
            category = "Cargos",
            shape = "pipes_big_cargo",
            size = 40,
            rotation_offset = 90
        },
        TETRAPOD = {
            type = "tetrapod_cargo",
            category = "Cargos",
            shape = "tetrapod_cargo",
            size = 10,
            rotation_offset = 0
        },
        TIRE_BLACK = {
            type = "Black_Tyre",
            category = "Fortifications",
            shape = "H-tyre_B",
            size = 5,
            rotation_offset = 90
        },
        TIRE_WHITE = {
            type = "White_Tyre",
            category = "Fortifications",
            shape = "H-H-tyre_W",
            size = 5,
            rotation_offset = 90
        },
        REVERMENT = {
            type = "M92_Reverment",
            category = "Fortifications",
            shape = "M92_Reverment",
            size = 100,
            rotation_offset = 90
        },
        DOUBLE_WALL = {
            type = "Twall_x6_3mts",
            category = "Fortifications",
            shape = "M92_Twall_x6_3mts",
            size = 40,
            rotation_offset = 90
        },
        HESCO_WALL_PERIMETER = {
            type = "HESCO_wallperimeter_1",
            category = "Fortifications",
            shape = "M92_HESCO_wallperimeter_1",
            size = 45,
            rotation_offset = 0
        },
        TANK_CAR_A = {
            type = "Coach a tank yellow",
            category = "",
            shape = "",
            size = 39,
            rotation_offset = 0
        },
        TANK_CAR_TRINITY = {
            type = "Tankcartrinity",
            category = "",
            shape = "",
            size = 58,
            rotation_offset = 0
        },
        BARBED_WIRE_FENCE = {
            type = "ERO_Barbed_Wire_Fence",
            category = "Fortifications",
            shape = "",
            size = 42,
            rotation_offset = 0
        },
        ROLLED_BARBED_WIRE_FENCE = {
            type = "M92_Fences_2",
            category = "Fortifications",
            shape = "",
            size = 17,
            rotation_offset = 90
        },
    }
}

function RANGE_CIRCLE:New(zone_or_circle, object_table, gap_percentage, perfect, height_offset, center_static, center_static_dead)
    local self = BASE:Inherit(self, BASE:New())

    gap_percentage = gap_percentage or 0
    height_offset = height_offset or 0
    if perfect == nil then
        perfect = true
    else
        perfect = perfect
    end

    center_static = center_static or RANGE_CIRCLE.OBJECTS.CONTAINER_20ft
    center_static_dead = center_static_dead or true

    self.statics = {}
    self.name = zone_or_circle:GetName()
    self.center = zone_or_circle:GetCoordinate()
    self.num_rings = table.length(object_table)
    self.radius = zone_or_circle:GetRadius()
    local current_radius = self.radius

    if self.num_rings > 0 then
        local radius_decr = zone_or_circle:GetRadius() / self.num_rings
        for ring = self.num_rings, 1, -1 do
            self.circumference = UTILS.MetersToFeet(2 * math.pi * current_radius)
            local amount = self.circumference / object_table[ring].size
            local rotation = object_table[ring].rotation_offset
            for _ = 0, math.floor(amount - 1) do
                if math.random(0, 100) < 100 - gap_percentage then
                    local pt = self.center:Translate(current_radius, rotation - 1)
                    local heading = rotation + object_table[ring].rotation_offset
                    if not perfect then
                        pt = self.center:Translate(current_radius + math.random(-1, 1), rotation - 1)
                        heading = heading + math.random(-10, 10)
                    end
                    pt.y = pt.y + height_offset
                    local static = SPAWNSTATIC:NewFromType(object_table[ring].type, object_table[ring].category, country.CJTF_BLUE)
                                              :InitNamePrefix(self.name .. tostring(math.random(0, 99999)))
                                              :InitShape(object_table[ring].shape)
                                              :InitHeading(heading)
                                              :SpawnFromCoordinate(pt)
                    table.insert(self.statics, static)
                end
                rotation = rotation + (360 / amount)
            end
            current_radius = current_radius - radius_decr
        end
        SPAWNSTATIC:NewFromType(center_static.type, center_static.category, country.CJTF_BLUE)
                      :InitNamePrefix(self.name .. tostring(math.random(0, 99999)))
                      :InitShape(center_static.shape)
                      :InitHeading(math.random(0, 360))
                      :InitDead(center_static_dead)
                      :SpawnFromCoordinate(self.center)
    end

    return self
end


function RANGE_CIRCLE:AddHeading(heading, object, gap_percentage, perfect)
    --if heading == 0 then heading = 360 end
    --local heading_line_01 = self.center:Translate(heading, self.radius + 10)
    --local heading_line_02 = heading_line_01:Translate(heading, self.radius)
    --local heading_line = LINE:New(heading_line_01:GetVec2(), heading_line_02:GetVec2())
    --local heading_line_length = heading_line:GetLength()
    --local center = COORDINATE:NewFromVec2(heading_line:GetPointsInbetween(1)[1])
    --
    --local amount = heading_line_length / object.size
    --for _, pt in pairs(heading_line:GetPointsInbetween(amount)) do
    --    local static = SPAWNSTATIC:NewFromType(object.type, object.category, country.CJTF_BLUE)
    --                              :InitNamePrefix(self.name .. tostring(math.random(0, 99999)))
    --                              :InitShape(object.shape)
    --                              :InitHeading(heading + object.rotation_offset)
    --                              :SpawnFromCoordinate(COORDINATE:NewFromVec2(pt))
    --    table.add(self.statics, static)
    --end


    --local cross_left_01 = center:Translate(heading - 90, 10)
    --local cross_left_02 = cross_left_01:Translate(heading - 90, heading_line_length / 4)
    --local cross_left_line = LINE:New(cross_left_01:GetVec2(), cross_left_02:GetVec2())
    --local cross_left_line_length = cross_left_line:GetLength()
    --
    --local cross_right_01 = center:Translate(heading + 90, 10)
    --local cross_right_02 = cross_right_01:Translate(heading - 90, heading_line_length / 4)
    --local cross_right_line = LINE:New(cross_right_01:GetVec2(), cross_right_02:GetVec2())
    --local cross_right_line_length = cross_right_line:GetLength()
    --
    --local end_01 = heading_line.Coords[2]:Translate(heading - 90, heading_line_length)
    --local end_02 = end_01:Translate(heading + 90, heading_line * 2)
    --local end_line = LINE:New(end_01:GetVec2(), end_02:GetVec2())
    --
    --local cross_amount = cross_left_line_length / object.size
    --local cross_left_difference = {}
    --
    --for i=1, cross_amount do
    --
    --end


end

function RANGE_CIRCLE:Remove()
    for _, static in pairs(self.statics) do
        static:Destroy()
    end
end
