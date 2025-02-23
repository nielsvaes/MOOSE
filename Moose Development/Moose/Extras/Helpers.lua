BIG_NUMBER = 999999999
SMALL_NUMBER = 0.000001

function table.random(tbl)
    return tbl[math.random(1, #tbl)]
end

--- One liners

function dev_message(message, clear, time_delay)
    if not DEVCODE then
        return
    end
    clear = clear or false

    if time_delay then
        delay(time_delay, function()
            trigger.action.outText("[DEV: " .. message .. "]", 10, clear)
        end)
        BASE:I("[DEV: " .. message .. "]")
    else
        trigger.action.outText("[DEV: " .. message .. "]", 10, clear)
        BASE:I("[DEV: " .. message .. "]")
    end
end

function message_to_all(message, clear, on_screen_seconds, time_delay)
    clear = clear or false
    on_screen_seconds = on_screen_seconds or 10
    time_delay = time_delay or false
    
    if time_delay then
        delay(time_delay, function()
            trigger.action.outText(message, on_screen_seconds, clear)
        end)
    else
        trigger.action.outText(message, on_screen_seconds, clear)
    end
end

function delay(t, f)
    BASE:ScheduleOnce(t, f)
end

function ask_user(text, flagname_true, flagname_false, usersound)
    if usersound then
        usersound:ToAll()
    end

    MESSAGE:New(text, BIG_NUMBER):ToAll()
    local question = [[c_start_wait_for_user("]] .. flagname_true .. [[", "]] .. flagname_false .. [[")]]
    net.dostring_in('mission', question)
end

function clear_text()
    MESSAGE:New("", 1, nil, true):ToAll()
end

function go_refuel(group)
    if type(group) == "string" then
        group = GROUP:FindByName(group)
    end
    local task = group:TaskRefueling()
    group:SetTask(task)

    dev_message(group:GetName() .. " is hitting the tanker")

end

function listen_for_cockpit_command(device_num, command_num, flag, hits_to_trigger, min_value, max_value)
    hits_to_trigger = hits_to_trigger or 1
    min_value = min_value or -1000000
    max_value = max_value or  1000000

    local cmd = 'a_start_listen_command(' .. tostring(command_num) .. ', "' .. flag .. '", ' .. tostring(hits_to_trigger) .. ', ' .. tostring(min_value) .. ', ' .. tostring(max_value) .. ', ' .. tostring(device_num) .. ')'
    net.dostring_in("mission", cmd)
    BASE:I("COMMAND LISTENER: Device: " .. tostring(device_num) .. ", command: " .. tostring(command_num) .. ", firing after " .. tostring(hits_to_trigger) .. " hits")
end

function all_of_group_in_zone(group, zone)
    if type(zone) == "string" then
        zone = ZONE:FindByName(zone)
    end

    if type(group) == "string" then
        group = GROUP:FindByName(group)
    end

    if zone == nil then
        BASE:E("Couldn't find a zone named " .. zone:GetName())
    end

    if group == nil then
        BASE:E("Couldn't find a group named " .. zone:GetName())
    end

    for _, unit in pairs(group:GetUnits()) do
        if not zone:IsVec2InZone(unit:GetVec2()) then
            return false
        end
    end
    return true
end

function part_of_group_in_zone(group, zone)
    if type(zone) == "string" then
        zone = ZONE:FindByName(zone)
    end

    if type(group) == "string" then
        group = GROUP:FindByName(group)
    end

    if zone == nil then
        BASE:E("Couldn't find a zone named " .. zone:GetName())
    end

    if group == nil then
        BASE:E("Couldn't find a group named " .. zone:GetName())
    end

    for _, unit in pairs(group:GetUnits()) do
        if zone:IsVec2InZone(unit:GetVec2()) then
            return true
        end
    end
    return false
end

function get_userflag(flag_name)
    return trigger.misc.getUserFlag(flag_name)
end

function set_userflag(flag_name, value)
    if value == false then
        value = 0
    end
    trigger.action.setUserFlag(flag_name, value)
end

function userflag_equals(flag_name, value)
    if value == true then
        value = 1
    elseif value == false then
        value = 0
    end

    return trigger.misc.getUserFlag(flag_name) == value
end

function get_percentage_of(num_percentage, total) 
    return (total * num_percentage) / 100
end

function go_to_waypoint(group, waypoint)
    waypoint = waypoint + 1
    local cmd = group:CommandSwitchWayPoint(1, waypoint)
    group:SetCommand(cmd)
end

function DMS_to_DD(coord) -- input like "N31*50.800" or "E036*46.200"
    -- Adjust the pattern to match coordinates without a space after the direction
    local direction, degrees, minutes = coord:match("([NSEW])(%d+)%*(%d+%.%d+)")

    -- Convert degrees and minutes to numbers
    degrees = tonumber(degrees)
    minutes = tonumber(minutes)

    -- Calculate decimal degrees
    local decimal_degrees = degrees + (minutes / 60)

    -- Adjust for direction, assuming North and East are positive, South and West are negative
    if direction == 'S' or direction == 'W' then
        decimal_degrees = -decimal_degrees
    end

    return decimal_degrees
end

function DMS_to_coordinate(lat, lon)
    dec_lat = DMS_to_DD(lat)
    dec_lon = DMS_to_DD(lon)
    BASE:I(coord.LLtoLO(dec_lat, dec_lon))
    return COORDINATE:NewFromVec3(coord.LLtoLO(dec_lat, dec_lon))
end

function table.compare(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not table.compare(v1, v2, ignore_mt) then return false end
    end
    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not table.compare(v1, v2, ignore_mt) then return false end
    end
    return true
end


function string.remove_last_characters(str, num_characters)
    return str:sub(1, -num_characters - 1)
end


--- tanker_menu = MENU_COALITION:New(
---         coalition.side.BLUE,
---         "TANKER"
--- )
---
--- local speed = { {2, 3, 4}, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, {0, 1, 2, 3, 4, 5, 6, 7, 8, 9} }
--- UTILS.NestedMenu(speed,
---                  1,
---                  tanker_menu,
---                  coalition.side.BLUE,
---                  nil,
---                  true,
---                  function(speed, message) BASE:I("Setting speed to " .. tostring(speed) .. " and printing " .. message) end, "hellloooo!!")
local nested_menu_text = ""
function nested_menu(list, depth, parent_menu, coa, label, last_item_is_first_arg, f, ...)
    local args = {...}
    coa = coa or coalition.side.BLUE
    depth = depth or 1

    local root = {}
    for _, item in ipairs(list[depth]) do
        if label == nil then
            nested_menu_text = tostring(item)
        else
            nested_menu_text = label .. tostring(item)
        end
        --BASE:I("menu text is " .. menu_text)

        local sub_menu = MENU_COALITION:New(coa, nested_menu_text, parent_menu)
        root[sub_menu] = {}
        if depth + 1 < #list then
            root[sub_menu] = nested_menu(list, depth + 1, sub_menu, coa, nested_menu_text, last_item_is_first_arg, f, unpack(args))
        else
            local prev_menu_text = nested_menu_text
            for _, last_item in ipairs(list[depth + 1]) do
                nested_menu_text = prev_menu_text .. tostring(last_item)
                --BASE:I("menu text for last item is " .. menu_text)

                local exec_command
                if last_item_is_first_arg then
                    exec_command = MENU_COALITION_COMMAND:New(
                                        coa,
                                        tostring(nested_menu_text),
                                        sub_menu,
                                        f, nested_menu_text, unpack(args)
                    )
                else
                    exec_command = MENU_COALITION_COMMAND:New(
                                        coa,
                                        tostring(nested_menu_text),
                                        sub_menu,
                                        f, unpack(args)
                    )
                end
                table.insert(root[sub_menu], exec_command)
            end
            nested_menu_text = ""
        end
    end
    return root
end

function AmmoDumpExplosionRectangular(Coordinate, InitialIntensity, Vertices, SubExplosionChance, SubExplosionMinIntensity, SubExplosionMaxIntensity, FlarePercentage, SubExplosionInterval, CookOffTime, CookOffBeginTime)
    SubExplosionChance = SubExplosionChance or 50  
    SubExplosionMinIntensity = SubExplosionMaxIntensity or 0.5
    SubExplosionMaxIntensity = SubExplosionMaxIntensity or 10
    FlarePercentage = FlarePercentage or 85
    SubExplosionInterval = SubExplosionInterval or 0.9
    CookOffTime = CookOffTime or math.random(40, 120)
    CookOffBeginTime = CookOffBeginTime or math.random(5, CookOffTime / 3)
    Coordinate:Explosion(InitialIntensity)
    local triangles = {
        { Vertices[1], Vertices[2], Vertices[3] },
        { Vertices[3], Vertices[4], Vertices[1] },
    }
    local cookoff_timer = TIMER:New(function()
        if UTILS.PercentageChance(SubExplosionChance) then
            local triangle = triangles[math.random(1, 2)]
            local vec2 = UTILS.RandomPointInTriangle(triangle[1], triangle[2], triangle[3])
            local new_pos = COORDINATE:NewFromVec2(vec2)
            new_pos:Explosion(math.random(SubExplosionMinIntensity, SubExplosionMaxIntensity))
            if UTILS.PercentageChance(FlarePercentage) then
                for i = 0, math.random(0, 3) do
                    new_pos:FlareRed(math.random(0, 90))
                end
            end
        end
    end)
    cookoff_timer:Start(CookOffBeginTime, SubExplosionInterval, CookOffTime)
end
