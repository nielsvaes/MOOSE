BIG_NUMBER = 999999999
SMALL_NUMBER = 0.000001

function table.random(tbl)
    return tbl[math.random(1, #tbl)]
end

function dev_message(message, time_delay)
    if time_delay then
        delay(time_delay, function() trigger.action.outText("[DEV: " .. message .. "]", 10)  end)
        BASE:I("[DEV: " .. message .. "]")
    else
        trigger.action.outText("[DEV: " .. message .. "]", 10)
        BASE:I("[DEV: " .. message .. "]")
    end
end

function delay(t, f)
    BASE:ScheduleOnce(t, f)
end


--- Extra USERFLAG

function USERFLAG:Get(flag_name)
    return trigger.misc.getUserFlag(flag_name)
end

function USERFLAG:Set(flag_name, value)
    if value == false then
        value = 0
    end
    trigger.action.setUserFlag(flag_name, value)
end

function USERFLAG:Equals(flag_name, value)
    if value == true then
        value = 1
    elseif value == false then
        value = 0
    end

    return trigger.misc.getUserFlag(flag_name) == value
end


