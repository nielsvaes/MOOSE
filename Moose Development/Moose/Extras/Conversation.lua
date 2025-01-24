CONVERSATION = {
    ClassName = "CONVERSATION"
}


function CONVERSATION:PlayNumber(number, radio_unit, initial_delay, before_play_function, after_play_function, voice_line_table)
    number = tostring(number)
    local pause = initial_delay or 0
    voice_line_table = voice_line_table or MIZ.VOICELINES

    if before_play_function then
        BASE:ScheduleOnce(initial_delay, before_play_function())
    end

    for _, voice_line in pairs(voice_line_table) do
        BASE:ScheduleOnce(pause,
            function()
                local radio
                if radio_unit ~= nil then
                    radio = radio_unit:GetRadio()
                else
                    radio = UNIT:FindByName(voice_line.speaker_name):GetRadio()
                end
                radio:SetPower(1000)
                local subtitle_duration = voice_line.duration + 3

                radio:NewUnitTransmission(voice_line.sound_file, voice_line.subtitle, subtitle_duration, voice_line.frequency, voice_line.modulation, false)
                radio:Broadcast()
                dev_message("Playing line: " .. voice_line.subtitle)
            end
        )
        pause = pause + voice_line.duration + 0.5
    end

    if after_play_function then
        BASE:ScheduleOnce(pause, after_play_function())
    end
end

