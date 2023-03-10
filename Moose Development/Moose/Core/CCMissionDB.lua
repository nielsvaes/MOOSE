--- USAGE:
--- local unit_tbl = CCMISSIONDB:CreateUnitsTable("compound_unit", CCGROUND_UNITS.ANTIAIR.SA18IglaSmanpad, CCGROUND_UNITS.INFANTRY.InfantryAKIns, CCGROUND_UNITS.INFANTRY.InfantryAKIns)
--- local grp_tbl = CCMISSIONDB:CreateGroupTable("compund_group", unit_tbl)
--- local grp = CCMISSIONDB:Get():Add(grp_tbl, Group.Category.GROUND, country.id.CJTF_RED, coalition.side.RED)



CCGROUND_UNITS = {}
CCGROUND_UNITS.ARMOR = {
    AAV7 = "AAV7",
    BTR80 = "BTR-80",
    BTR82A = "BTR-82A",
    Cobra = "Cobra",
    M1043HMMWVArmament = "M1043 HMMWV Armament",
    M1126StrykerICV = "M1126 Stryker ICV",
    M113 = "M-113",
    BRDM2 = "BRDM-2",
    BTR_D = "BTR_D",
    M1045HMMWVTOW = "M1045 HMMWV TOW",
    M1134StrykerATGM = "M1134 Stryker ATGM",
    Grad_FDDM = "Grad_FDDM",
    BMD1 = "BMD-1",
    BMP1 = "BMP-1",
    BMP2 = "BMP-2",
    BMP3 = "BMP-3",
    LAV25 = "LAV-25",
    M2Bradley = "M-2 Bradley",
    Marder = "Marder",
    MCV80 = "MCV-80",
    M1128StrykerMGS = "M1128 Stryker MGS",
    TPZ = "TPZ",
    ZBD04A = "ZBD04A",
    MTLB = "MTLB",
    Challenger2 = "Challenger2",
    Leclerc = "Leclerc",
    Leopard1A3 = "Leopard1A3",
    Leopard2 = "Leopard-2",
    M1Abrams = "M-1 Abrams",
    M60 = "M-60",
    Merkava_Mk4 = "Merkava_Mk4",
    T72B = "T-72B",
    T72B3 = "T-72B3",
    T80UD = "T-80UD",
    ZTZ96B = "ZTZ96B",
    T90 = "T-90",
    T55 = "T-55",
}
CCGROUND_UNITS.ARTILLERY = {
    TwoB11mortar = "2B11 mortar",
    Smerch = "Smerch",
    Uragan_BM27 = "Uragan_BM-27",
    GradURAL = "Grad-URAL",
    MLRSFDDM = "MLRS FDDM",
    MLRS = "MLRS",
    SAUGvozdika = "SAU Gvozdika",
    SAUMsta = "SAU Msta",
    SAUAkatsia = "SAU Akatsia",
    M109 = "M-109",
    SpGH_Dana = "SpGH_Dana",
    SAU2C9 = "SAU 2-C9",
    T155_Firtina = "T155_Firtina",
    PLZ05 = "PLZ05",
    Smerch_HE = "Smerch_HE",
}
CCGROUND_UNITS.FORTIFICATION = {
    armed_house = "houseA_arm",
    barracks = "house1arm",
    Sandbox = "Sandbox",
    Bunker = "Bunker",
    outpost = "outpost",
    outpost_road = "outpost_road",
    watch_tower = "house2arm"
}
CCGROUND_UNITS.INFANTRY = {
    SoldierM4GRG = "Soldier M4 GRG",
    SoldierM4 = "Soldier M4",
    SoldierAK = "Soldier AK",
    SoldierM249 = "Soldier M249",
    InfantryAKIns = "Infantry AK Ins",
    InfantryAK = "Infantry AK",
    ParatrooperAKS74 = "Paratrooper AKS-74",
    ParatrooperRPG16 = "Paratrooper RPG-16",
}
CCGROUND_UNITS.UNARMED = {
    Hummer = "Hummer",
    Tigr_233036 = "Tigr_233036",
    PredatorGCS = "Predator GCS",
    PredatorTrojanSpirit = "Predator TrojanSpirit",
    SKP11 = "SKP-11",
    Ural375PBU = "Ural-375 PBU",
    ATMZ5 = "ATMZ-5",
    Ural4320APA5D = "Ural-4320 APA-5D",
    ATZ10 = "ATZ-10",
    ZiL131APA80 = "ZiL-131 APA-80",
    HEMTTTFFT = "HEMTT TFFT",
    M978HEMTTTanker = "M978 HEMTT Tanker",
    UralATsP6 = "Ural ATsP-6",
    GAZ3307 = "GAZ-3307",
    GAZ3308 = "GAZ-3308",
    GAZ66 = "GAZ-66",
    IKARUSBus = "IKARUS Bus",
    KAMAZTruck = "KAMAZ Truck",
    KrAZ6322 = "KrAZ6322",
    LAZBus = "LAZ Bus",
    LiAZBus = "LiAZ Bus",
    M818 = "M 818",
    MAZ6303 = "MAZ-6303",
    UAZ469 = "UAZ-469",
    Ural375 = "Ural-375",
    Ural432031 = "Ural-4320-31",
    Ural4320T = "Ural-4320T",
    VAZCar = "VAZ Car",
    ZIL131KUNG = "ZIL-131 KUNG",
    ZIL4331 = "ZIL-4331",
    ZIL135 = "ZIL-135",
    Trolleybus = "Trolley bus",
    Vulcan = "Vulcan",
}
CCGROUND_UNITS.ANTIAIR = {
    ZSU_57_2 = "ZSU_57_2",
    ZU23EmplacementClosed = "ZU-23 Emplacement Closed",
    ZU23Emplacement = "ZU-23 Emplacement",
    ZU23Insurgent = "ZU-23 Insurgent",
    ZU23ClosedInsurgent = "ZU-23 Closed Insurgent",
    Ural375ZU23Insurgent = "Ural-375 ZU-23 Insurgent",
    Ural375ZU23 = "Ural-375 ZU-23",
    ZSU234Shilka = "ZSU-23-4 Shilka",
    Gepard = "Gepard",
    DogEarradar = "Dog Ear radar",
    EWR1L13 = "1L13 EWR",
    G6EWR55 = "55G6 EWR",
    p19s125sr = "p-19 s-125 sr",
    M6Linebacker = "M6 Linebacker",
    Osa9A33ln = "Osa 9A33 ln",
    SA8 = "Osa 9A33 ln",
    Strela19P31 = "Strela-1 9P31",
    Soldierstinger = "Soldier stinger",
    M1097Avenger = "M1097 Avenger",
    M48Chaparral = "M48 Chaparral",
    Strela10M3 = "Strela-10M3",
    SA13 = "Strela-10M3",
    twoS6Tunguska = "2S6 Tunguska",
    SA19 = "2S6 Tunguska",
    HQ7_STR_SP = "HQ-7_STR_SP",
    HQ7_LN_SP = "HQ-7_LN_SP",
    rapier_fsa_launcher = "rapier_fsa_launcher",
    rapier_fsa_blindfire_radar = "rapier_fsa_blindfire_radar",
    rapier_fsa_optical_tracker_unit = "rapier_fsa_optical_tracker_unit",
    Hawkpcp = "Hawk pcp",
    Hawkcwar = "Hawk cwar",
    Hawksr = "Hawk sr",
    Hawktr = "Hawk tr",
    Hawkln = "Hawk ln",
    PatriotAMG = "Patriot AMG",
    PatriotECS = "Patriot ECS",
    PatriotEPP = "Patriot EPP",
    Patriotcp = "Patriot cp",
    Patriotstr = "Patriot str",
    Patriotln = "Patriot ln",
    RolandRadar = "Roland Radar",
    RolandADS = "Roland ADS",
    S300PS54K6cp = "S-300PS 54K6 cp",
    S300PS64H6Esr = "S-300PS 64H6E sr",
    S300PS40B6Mtr = "S-300PS 40B6M tr",
    S300PS5P85Cln = "S-300PS 5P85C ln",
    Tor9A331 = "Tor 9A331",
    SA15 = "Tor 9A331",
    SA18IglaSmanpad = "SA-18 Igla-S manpad",
    SA18IglaScomm = "SA-18 Igla-S comm",
    SA11BukCC9S470M1 = "SA-11 Buk CC 9S470M1",
    SA11BukSR9S18M1 = "SA-11 Buk SR 9S18M1",
    SA11BukLN9A310M1 = "SA-11 Buk LN 9A310M1",
    Kub1S91str = "Kub 1S91 str",
    Kub2P25ln = "Kub 2P25 ln",
    snrs125tr = "snr s-125 tr",
    fivep73s125ln = "5p73 s-125 ln",
    SNR_75V = "SNR_75V",
    S_75M_Volhov = "S_75M_Volhov",
    Stingercommdsr = "Stinger comm dsr",
    Stingercomm = "Stinger comm",
    RPC_5N62V = "RPC_5N62V",
    S200_Launcher = "S-200_Launcher",
    RLS_19J6 = "RLS_19J6",
    NASAMS_Command_Post = "NASAMS_Command_Post",
    NASAMS_Radar_MPQ64F1 = "NASAMS_Radar_MPQ64F1",
    NASAMS_LN_C = "NASAMS_LN_C",
    NASAMS_LN_B = "NASAMS_LN_B",
}
CCNAVAL = {
    B052 = "052B",
    C052 = "052C",
    A052 = "054A",
    ALBATROS = "ALBATROS",
    Drycargoship1 = "Dry-cargo ship-1",
    Drycargoship2 = "Dry-cargo ship-2",
    ELNYA = "ELNYA",
    KILO = "KILO",
    MOLNIYA = "MOLNIYA",
    MOSCOW = "MOSCOW",
    NEUSTRASH = "NEUSTRASH",
    PERRY = "PERRY",
    PIOTR = "PIOTR",
    REZKY = "REZKY",
    SOM = "SOM",
    speedboat = "speedboat",
    TICONDEROG = "TICONDEROG",
    Type093 = "Type 093",
    USS_Arleigh_Burke_IIa = "USS_Arleigh_Burke_IIa",
    ZWEZDNY = "ZWEZDNY",
    Type_071 = "Type_071",
    HandyWind = "HandyWind",
    Seawise_Giant = "Seawise_Giant",
}

CCMISSIONDB = {
    ClassName = "CCMISIONDB"
}

CCMISSIONDB.DEFAULTS = {
    coalition_id = coalition.side.RED,
    country_id = country.id.CJTF_RED,
    category = Group.Category.GROUND
}

CCMISSIONDB.GROUP_TEMPLATE = {
        ["visible"] = true,
        ["tasks"] = {},
        ["uncontrollable"] = false,
        ["task"] = "Ground Nothing",
        ["route"] =
        {
            ["spans"] = {}, -- end of ["spans"]
            ["points"] =
            {
                [1] =
                {
                    ["alt"] = 0,
                    ["type"] = "Turning Point",
                    ["ETA"] = 0,
                    ["alt_type"] = "BARO",
                    ["formation_template"] = "",
                    ["y"] = 0,
                    ["x"] = 0,
                    ["ETA_locked"] = true,
                    ["speed"] = 0,
                    ["action"] = "Off Road",
                    ["task"] =
                    {
                        ["id"] = "ComboTask",
                        ["params"] =
                        {
                            ["tasks"] =
                            {
                            }, -- end of ["tasks"]
                        }, -- end of ["params"]
                    }, -- end of ["task"]
                    ["speed_locked"] = true,
                }, -- end of [1]
            }, -- end of ["points"]
        }, -- end of ["route"]
        ["hidden"] = false,
        ["y"] = 0,
        ["x"] = 0,
        ["name"] = "GROUP_TEMPLATE",
        ["lateActivation"] = true,
        ["units"] = { }
}

CCMISSIONDB.UNIT_TEMPLATE = {
        ["type"] = "",
        ["transportable"] = { ["randomTransportable"] = false},
        ["coldAtStart"] = false,
        ["skill"] = "Excellent",
        ["heading"] = 0,
        ["y"] = 0,
        ["x"] = 0,
        ["name"] = "UNIT_TEMPLATE",
        ["heading"] = 0,
        ["playerCanDrive"] = true
}

function CCMISSIONDB:Get()
    if _G["cc_mission_db"] == nil then
        self = BASE:Inherit(self, BASE:New())

        self.generated_ground = {}
        self.generated_air = {}
        self.generated_ships = {}

        _G["cc_mission_db"] = self
        self:I("Making new CCMISSIONDB")
    end
    return _G["cc_mission_db"]
end

function CCMISSIONDB:CreateUnitsTable(base_name, ...)
    local type_names
    if type(...) == "table" then
        type_names = ...
    else
        type_names = {...}
    end
    BASE:I(type_names)
    local units = {}
    for _, type_name in pairs(type_names) do
        local unit_table = UTILS.DeepCopy(CCMISSIONDB.UNIT_TEMPLATE)
        unit_table.name = UTILS.UniqueName(base_name)
        unit_table.type = type_name
        table.insert(units, unit_table)
    end
    return units
end

function CCMISSIONDB:CreateGroupTable(base_name, unit_table)
    local group_table = UTILS.DeepCopy(CCMISSIONDB.GROUP_TEMPLATE)
    group_table.name = UTILS.UniqueName(base_name)
    group_table.units = unit_table

    return group_table
end

--- https://wiki.hoggitworld.com/view/DCS_enum_country
--- https://wiki.hoggitworld.com/view/DCS_enum_coalition
function CCMISSIONDB:Add(group_table, category, country_id, coalition_id)
    country_id = country_id or CCMISSIONDB.DEFAULTS.country_id
    coalition_id = coalition_id or CCMISSIONDB.DEFAULTS.coalition_id
    category = category or CCMISSIONDB.DEFAULTS.category

    coalition.addGroup(country_id, category, group_table)
    local grp = GROUP:NewTemplate(group_table, coalition_id, category, country_id)
    _DATABASE:AddGroup(grp:GetName())
    for _, unit_table in pairs(group_table["units"]) do
        _DATABASE:AddUnit(unit_table["name"])
    end

    if category == Group.Category.GROUND then
        table.insert(self.generated_ground, grp)
    elseif category == Group.Category.AIRPLANE  then
        table.insert(self.generated_air, grp)
    else
        table.insert(self.generated_ships, grp)
    end
    return grp
end


function CCMISSIONDB:GenerateGroundUnits(unit_type, base_name, number, initial_point, offset)
    self:I("DEPRECATED, USE CreateUnitsTable INSTEAD!")
    local generated_units = {}
    for _ = 1, number do
        local unit_template = CCMISSIONDB.UNIT_TEMPLATE
        unit_template.name = UTILS.UniqueName(base_name)
        unit_template.type = unit_type
        table.insert(generated_units, UTILS.DeepCopy(unit_template))
    end
    return generated_units
end

function CCMISSIONDB:GenerateGroundGroup(name, unit_table, num_units, unit_type)
    self:I("DEPRECATED, USE CreateGroupTable INSTEAD!")
    num_units = num_units or 1
    if unit_table == nil then
        unit_table = self:GenerateGroundUnits(unit_type, name, num_units)
    end

    local generated_group = CCMISSIONDB.GROUP_TEMPLATE
    generated_group.units = unit_table
    generated_group.name = name
    return generated_group
end
