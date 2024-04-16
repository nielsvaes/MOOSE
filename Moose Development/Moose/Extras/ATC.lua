ATC = {
    ClassName = "ATC",
}

ATC.BLOCKER = {
    category = "Personnel",
    shape_name = "carrier_lso1_usa",
    type = "Carrier LSO Personell 1",
    y = 0,
    x = 0,
    heading = 0,
}

function ATC:New(airbase, spawnable_aircraft)
    local self = BASE:Inherit(self, BASE)
    self.airbase = airbase


    self.pattern_01_pt1 = {}
    self.pattern_01_pt2 = {}

    self.pattern_02_pt1 = {}
    self.pattern_02_pt2 = {}

    self.in_parking_spot = {}
    self.taxiing = {}
    self.holding_short = {}
    self.on_runway = {}

    self.spawnable_aircraft = spawnable_aircraft

    self:HandleEvent(EVENTS.Birth)
    self:HandleEvent(EVENTS.Takeoff)


    self.all_groups = {}


    return self
end

function ATC:OnEventBirth(event_data)
    local unit = event_data.IniUnit
    local group = event_data.IniGroup

    BASE:I(unit:GetName() .. " spawned!")
end

function ATC:OnEventTakeoff(event_data)
    BASE:I("take off!")
    BASE:I(event_data)

    local unit = event_data.IniUnit
    local group = event_data.IniGroup

    BASE:I(unit:GetName() .. " took off!!")
    BASE:I(group:GetName() .. " group took off!")
end


function ATC:DetectInOuterArea()
    -- sort into in outer area
end

function ATC:WantToSpawn(area)
    -- check if area is clear
      -- yes: spawn
      -- no: wait x seconds, check again
end

function ATC:DetectSpawnedGroup()
    -- find zone
      -- parking spot
      -- on runway
    -- sort into list "waiting for taxi", "taxiing", "holding short", "on runway"

    -- audio Requesting startup
    -- audio startup approved
end

function ATC:SortIntoWaitingForStartup()

end

function ATC:SortIntoWaitingForTaxi()
    -- audio request taxi to runway
    -- audio taxi to runway approved
end

function ATC:SortIntoTaxi()

end

function ATC:SortIntoHoldingShort()
    -- audio holding short runway whatever
    -- audio cleared runway, winds 139 6 knots, QFE 29,99 take off when ready
end

function ATC:SortIntoOnRunway()

end


function ATC:DetectTakeOffGroup()

end


function ATC:SortIntoInnerArea()

end


function ATC:SortIntoOuterArea()
    -- audio Shark entering base area
    -- audio Shark we have you on radar, cleared for straight in runway 23
end

function ATC:SortIntoOnApproach()

end

function ATC:DetectLanded()
    -- audio welcome home taxi to 12 via golf, hotel
    -- audio 12 via golf hotel
end

function ATC:SpawnGroup(group)
    local spawned_group = SPAWN:New("ai_dutch_viper_single")
                               :SpawnAtParkingSpot(self.airbase, {PHOENIXMISSION.GetParkingID("07")}, SPAWN.Takeoff.Cold)

    local blocker
    BASE:ScheduleOnce(1, function()
        blocker = SPAWNSTATIC:NewFromType(ATC.BLOCKER.type, ATC.BLOCKER.category, country.CJTF_BLUE)
                          :InitNamePrefix(spawned_group:GetName() .. "_blocker")
                          :InitShape(ATC.BLOCKER.shape_name)
                          :InitHeading(UTILS.ClampAngle(spawned_group:GetHeading() - 180))
                          :SpawnFromCoordinate(spawned_group:GetCoordinate():Translate(15, spawned_group:GetHeading(), true))
        spawned_group.blocker = blocker
    end)

    table.add(self.all_groups, spawned_group)
end

function ATC:DestroyBlocker(group)
    if group.blocker then
        group.blocker:Destroy()
    end
end

function ATC:DestroyAllGroups()
    for _, grp in pairs(self.all_groups) do
        grp:Destroy()
    end
end

function ATC:AskForStartup()

end

function ATC:AskTaxiToRunway()

end

function ATC:AskForStartup()

end


