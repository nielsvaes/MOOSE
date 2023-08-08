
JAMMER_TARGET_UNIT = {
    ClassName = "JAMMER_TARGET_UNIT",
    Inf = 999999
}

JAMMER_TARGET_UNIT.RADAR_INFO = {
    --- EWRs
    ["1L13 EWR"] = {
        burn_through_range = 30,
        memory_time = 10,
        engage_distance = 0,
        track_distance = 100,
        weapon_identify_ability = 1,
        can_shoot_down_weapon = false
    },
    ["55G6 EWR"] = {
        burn_through_range = 30,
        memory_time = 10,
        engage_distance = 0,
        track_distance = 100,
        weapon_identify_ability = 1,
        can_shoot_down_weapon = false
    },

    --- Short range
    ["Dog Ear radar"] = {
        burn_through_range = 11,
        memory_time = 6,
        engage_distance = 0,
        track_distance = 19,
        weapon_identify_ability = 1,
        can_shoot_down_weapon = false
    },
    ["M48 Chaparral"] = {
        memory_time = 5,
        engage_distance = 4.5,
        track_distance = 5,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["M6 Linebacker"] = {
        burn_through_range = 3,
        memory_time = 6,
        engage_distance = 2.4,
        track_distance = 4.3,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Osa 9A33 ln"] = {  -- SA-8
        burn_through_range = 12,
        memory_time = 6,
        engage_distance = 5.45,
        track_distance = 16.18,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Tor 9A331"] = {   -- SA-15
        burn_through_range = 8,
        memory_time = 8,
        engage_distance = 6.5,
        track_distance = 13.5,
        weapon_identify_ability = 95,
        can_shoot_down_weapon = true
    },
    ["2S6 Tunguska"] = {   -- SA-19
        burn_through_range = 7,
        memory_time = 8,
        engage_distance = 4.28,
        track_distance = 9.76,
        weapon_identify_ability = 95,
        can_shoot_down_weapon = true
    },

    --- HAWK
    ["Hawk cwar"] = {
        memory_time = 8,
        engage_distance = 0,
        track_distance = 37.8,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Hawk ln"] = {
        memory_time = 0,
        engage_distance = 24.2,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Hawk sr"] = {
        burn_through_range = 30,
        memory_time = 8,
        engage_distance = 0,
        track_distance = 48.6,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Hawk tr"] = {
        burn_through_range = 26,
        memory_time = 8,
        engage_distance = 0,
        track_distance = 48.4,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- NASAMS
    ["NASAMS_Radar_MPQ64F1"] = {
        burn_through_range = 15,
        memory_time = 8,
        engage_distance = 8.1,
        track_distance = 27.3,
        weapon_identify_ability = 3,
        can_shoot_down_weapon = false
    },
    ["NASAMS_LN_C"] = {
        memory_time = 0,
        engage_distance = 8.1,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["NASAMS_LN_B"] = {
        memory_time = 0,
        engage_distance = 0,
        track_distance = 8.1,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- Patriot
    ["Patriot AMG"] = {
        memory_time = 0,
        engage_distance = 0,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Patriot ECS"] = {
        memory_time = 0,
        engage_distance = 0,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Patriot EPP"] = {
        memory_time = 0,
        engage_distance = 0,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Patriot str"] = {
        burn_through_range = 40,
        memory_time = 8,
        engage_distance = 0,
        track_distance = 105,
        weapon_identify_ability = 3,
        view_angle = 110,
        can_shoot_down_weapon = false
    },

    --- Rapier
    ["rapier_fsa_blindfire_radar"] = {
        burn_through_range = 9,
        memory_time = 5,
        engage_distance = 3.6,
        track_distance = 16.3,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["rapier_fsa_launcher"] = {
        memory_time = 0,
        engage_distance = 3.6,
        track_distance = 16.3,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["rapier_fsa_optical_tracker_unit"] = {
        memory_time = 5,
        engage_distance = 0,
        track_distance = 11,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- Roland
    ["Roland ADS"] = {
        memory_time = 5,
        engage_distance = 4.29,
        track_distance = 6.4,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["Roland Radar"] = {
        burn_through_range = 9,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 18.9,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- HQ-7
    ["HQ-7_STR_SP"] = {
        burn_through_range = 11,
        memory_time = 5,
        engage_distance = 6.5,
        track_distance = 16.1,
        weapon_identify_ability = 3,
        can_shoot_down_weapon = false
    },
    ["HQ-7_LN_SP"] = {
        memory_time = 5,
        engage_distance = 6.5,
        track_distance = 16.1,
        weapon_identify_ability = 3,
        can_shoot_down_weapon = false
    },


    --- SA-2
    ["SNR_75V"] = {
        burn_through_range = 22,
        memory_time = 10,
        engage_distance = 0,
        track_distance = 54,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["S_75M_Volhov"] = {
        memory_time = 10,
        engage_distance = 23,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["p-19 s-125 sr"] = {
        burn_through_range = 26,
        memory_time = 8,
        engage_distance = 0,
        track_distance = 86,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- SA-3
    ["5p73 s-125 ln"] = {
        memory_time = 0,
        engage_distance = 9.7,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["snr s-125 tr"] = {
        burn_through_range = 21,
        memory_time = 10,
        engage_distance = 0,
        track_distance = 54,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- SA-5
    ["S-200_Launcher"] = {
        memory_time = 0,
        engage_distance = 136,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["RPC_5N62V"] = {   -- TR
        burn_through_range = 38,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 216,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },
    ["RLS_19J6"] = {   -- TR
        burn_through_range = 31,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 81,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- SA-6
    ["Kub 1S91 str"] = {
        burn_through_range = 16,
        memory_time = 6,
        engage_distance = 11,
        track_distance = 28,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    ["Kub 2P25 ln"] = {
        memory_time = 0,
        engage_distance = 13,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = false
    },

    --- SA-10
    ["S-300PS 64H6E sr"] = {
        burn_through_range = 26,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 85.7,
        weapon_identify_ability = 98,
        can_shoot_down_weapon = false
    },
    ["S-300PS 40B6MD sr"] = {
        burn_through_range = 16,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 32.1,
        weapon_identify_ability = 98,
        can_shoot_down_weapon = false
    },
    ["S-300PS 40B6M tr"] = {
        burn_through_range = 28,
        memory_time = 5,
        engage_distance = 64.7,
        track_distance = 85,
        weapon_identify_ability = 95,
        can_shoot_down_weapon = false
    },
    ["S-300PS 5P85D ln"] = {
        memory_time = 0,
        engage_distance = 64.7,
        track_distance = 0,
        weapon_identify_ability = 0,
        can_shoot_down_weapon = true
    },
    ["S-300PS 5P85C ln"] = {
        memory_time = 0,
        engage_distance = 64.7,
        track_distance = 0,
        weapon_identify_ability = 95,
        can_shoot_down_weapon = true
    },

    --- SA-11
    ["SA-11 Buk SR 9S18M1"] = {
        burn_through_range = 25,
        memory_time = 5,
        engage_distance = 0,
        track_distance = 53.5,
        weapon_identify_ability = 85,
        can_shoot_down_weapon = false
    },
    ["SA-11 Buk LN 9A310M1"] = {
        burn_through_range = 13,
        memory_time = 5,
        engage_distance = 19.2,
        track_distance = 26.6,
        weapon_identify_ability = 85,
        can_shoot_down_weapon = false
    },
}

JAMMER_TARGET_UNIT.SKILL_INFO = {}
JAMMER_TARGET_UNIT.SKILL_INFO["Average"] = {
    penalty = 5,
    recovery_time = 4,
    lucky_chance = 2,
    needed_hits = 1,
}
JAMMER_TARGET_UNIT.SKILL_INFO["Good"] = {
    penalty = 10,
    recovery_time = 3.1,
    lucky_chance = 3,
    needed_hits = 1,
}
JAMMER_TARGET_UNIT.SKILL_INFO["High"] = {
    penalty = 15,
    recovery_time = 2.7,
    lucky_chance = 4,
    needed_hits = 2,
}
JAMMER_TARGET_UNIT.SKILL_INFO["Excellent"] = {
    penalty = 25,
    recovery_time = 0.9,
    lucky_chance = 5,
    needed_hits = 3,
}
JAMMER_TARGET_UNIT.SKILL_INFO["Random"] = {
    penalty = math.random(JAMMER_TARGET_UNIT.SKILL_INFO["Average"].penalty, JAMMER_TARGET_UNIT.SKILL_INFO["Excellent"].penalty),
    recovery_time = math.random(JAMMER_TARGET_UNIT.SKILL_INFO["Average"].recovery_time, JAMMER_TARGET_UNIT.SKILL_INFO["Excellent"].recovery_time)
}

function JAMMER_TARGET_UNIT:New(unit_name, jammer_plane)
    self = BASE:Inherit(self, UNIT:FindByName(unit_name))
    if self == nil then
        self:E("Couldn't find a unit with the name " .. unit_name)
    end

    local skill = self:GetSkill()
    local type = self:GetTypeName()

    self.penalty                 = JAMMER_TARGET_UNIT.SKILL_INFO[skill].penalty
    self.recovery_time           = JAMMER_TARGET_UNIT.SKILL_INFO[skill].recovery_time
    self.lucky_chance            = JAMMER_TARGET_UNIT.SKILL_INFO[skill].lucky_chance
    self.needed_hits             = JAMMER_TARGET_UNIT.SKILL_INFO[skill].needed_hits

    self.first_triangulation_try = true
    self.triangulated            = false
    self.actual_pos              = self:GetVec2()
    self.actual_coord            = COORDINATE:NewFromVec2(self.actual_pos)
    self.guessed_pos             = {x=JAMMER_TARGET_UNIT.Inf, y=JAMMER_TARGET_UNIT.Inf}
    self.final_guessed_pos       = nil

    self.initial_headings        = nil
    self.scan_headings           = { UTILS.HdgTo(jammer_plane:GetVec3(), self:GetVec3()), UTILS.HdgTo(jammer_plane:GetVec3(), self:GetVec3()) }

    self.active_at               = 0
    self.times_hit               = 1
    self.burn_through_range      = JAMMER_TARGET_UNIT.RADAR_INFO[type].burn_through_range

    self.circle                  = CIRCLE:New(self:GetVec2(), self.__min_minor_axis)
    self.oval = OVAL:New(self:GetVec2(),
                JAMMER_TARGET_UNIT.Inf,
                JAMMER_TARGET_UNIT.Inf,
                360)

    --_EVENTDISPATCHER:CreateEventNewJTU(self)
    return self
end

