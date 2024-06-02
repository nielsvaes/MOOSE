BIG_NUMBER = 999999999
SMALL_NUMBER = 0.000001

function table.random(tbl)
    return tbl[math.random(1, #tbl)]
end

--- One liners

function dev_message(message, time_delay)
    if not DEVCODE then
        return
    end

    if time_delay then
        delay(time_delay, function()
            trigger.action.outText("[DEV: " .. message .. "]", 10)
        end)
        BASE:I("[DEV: " .. message .. "]")
    else
        trigger.action.outText("[DEV: " .. message .. "]", 10)
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
