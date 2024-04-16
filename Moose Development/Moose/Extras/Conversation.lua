CONVERSATION = {
    ClassName = "CONVERSATION"
}


function CONVERSATION:PlayNumber(number, radio_unit, initial_delay)
    number = tostring(number)
    local pause = initial_delay or 0

    for _, voice_line in pairs(PHOENIXMISSION.VOICELINES[number]) do
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
                BASE:I("Playing line: " .. voice_line.subtitle)
            end
        )
        pause = pause + voice_line.duration + 0.5
    end
end

