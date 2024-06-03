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
