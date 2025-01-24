BARCAPLINE = {
    ClassName = "BARCAPLINE",
}

function BARCAPLINE:FindByName(line_name, number_of_sections, double_groups, plane_coalition, plane_country)
    local self = BASE:Inherit(self, LINE:FindOnMap(line_name))
    self.number_of_sections = number_of_sections or 0
    self.double_groups = double_groups or true
    self.spawn_templates = {}
    self.groups = {}

    if plane_coalition ~= nil then
        self.coalition = plane_coalition
        self.country = plane_country
    else
        BASE:I(self:GetColorRGBA())
        if self:GetColorRGBA().B > 200 then
            self.coalition = coalition.side.BLUE
            self.country = country.id.CJTF_BLUE
        else
            self.coalition = coalition.side.RED
            self.country = country.id.CJTF_RED
        end
    end

    self.height_stack = 0

    return self
end

function BARCAPLINE:SetSpawnTemplates(spawn_templates)
    self.spawn_templates = spawn_templates
    for _, each in pairs(self.spawn_templates) do
        CCMISSIONDB:Get():Add(each, Group.Category.AIRPLANE, self.country, self.coalition)
    end
end

function BARCAPLINE:Activate()
    local points = self:GetPointsInbetween(UTILS.Clamp((self.number_of_sections - 1), 0, 99999))
    local point_pairs = {}
    for i = 1, #points - 1 do
        table.insert(point_pairs, { points[i], points[i + 1] })
    end

    for _, point_pair in ipairs(point_pairs) do
        local alt = math.random(UTILS.FeetToMeters(17000), UTILS.FeetToMeters(19000))
        local c1 = COORDINATE:NewFromVec2(point_pair[1])
        local c2 = COORDINATE:NewFromVec2(point_pair[2])
        c1:SetAltitude(alt)
        c2:SetAltitude(alt)

        self:SpawnAndSetupGroup(c1, c2)

        if self.double_groups then
            self:SpawnAndSetupGroup(c2, c1, true)
        end

        self.height_stack = self.height_stack + 1000
    end
end

function BARCAPLINE:SpawnAndSetupGroup(orbit_begin_coord, orbit_end_coord, reverse)
    local random_group_name = self.spawn_templates[math.random(1, #self.spawn_templates)].name
    local spawned_grp = SPAWN:NewWithAlias(random_group_name, UTILS.UniqueName(random_group_name))
                             :SpawnFromCoordinate(orbit_begin_coord)
    table.insert(self.groups, spawned_grp)
    local task
    if not reverse then
        task = spawned_grp:TaskOrbit(orbit_begin_coord, orbit_begin_coord.y + self.height_stack, UTILS.KnotsToMps(math.random(370, 410)), orbit_end_coord)
    else
        self.height_stack = self.height_stack + 1000
        task = spawned_grp:TaskOrbit(orbit_end_coord, orbit_end_coord.y + self.height_stack, UTILS.KnotsToMps(math.random(370, 410)), orbit_begin_coord)
    end
    BASE:ScheduleOnce(1, function()
        spawned_grp:SetTask(task)
        spawned_grp:CommandSetUnlimitedFuel(true)
    end)
end


function BARCAPLINE:DestroyGroups()
    for _, grp in pairs(self.groups) do
        grp:Destroy()
    end
end
