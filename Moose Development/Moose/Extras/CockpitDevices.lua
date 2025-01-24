COCKPITDEVICES = {}
COCKPITDEVICES.VIPER = {}
COCKPITDEVICES.VIPER.PANELS = {
    FM_PROXY             =  1,
    CONTROL_INTERFACE    =  2,
    ELEC_INTERFACE       =  3,
    FUEL_INTERFACE       =  4,
    HYDRO_INTERFACE      =  5,
    ENGINE_INTERFACE     =  6,
    GEAR_INTERFACE       =  7,
    OXYGEN_INTERFACE     =  8,
    HEARING_SENS         =  9,
    CPT_MECH             = 10,
    EXTLIGHTS_SYSTEM     = 11,
    CPTLIGHTS_SYSTEM     = 12,
    ECS_INTERFACE        = 13,
    INS                  = 14,
    RALT                 = 15,
    HOTAS                = 16,
    UFC                  = 17,
    MUX                  = 18,
    MMC                  = 19,
    CADC                 = 20,
    FLCC                 = 21,
    SMS                  = 22,
    HUD                  = 23,
    MFD_LEFT             = 24,
    MFD_RIGHT            = 25,
    DED                  = 26,
    PFLD                 = 27,
    EHSI                 = 28,
    HELMET               = 29,
    HMCS                 = 30,
    FCR                  = 31,
    CMDS                 = 32,
    RWR                  = 33,
    IFF                  = 34,
    IFF_CONTROL_PANEL    = 35,
    UHF_RADIO            = 36,
    UHF_CONTROL_PANEL    = 37,
    VHF_RADIO            = 38,
    INTERCOM             = 39,
    MIDS_RT              = 40,
    MIDS                 = 41,
    KY58                 = 42,
    ILS                  = 43,
    AOA_INDICATOR        = 44,
    AAU34                = 45,
    AMI                  = 46,
    SAI                  = 47,
    VVI                  = 48,
    STANDBY_COMPASS      = 49,
    ADI                  = 50,
    CLOCK                = 51,
    MACROS               = 52,
    AIHelper             = 53,
    KNEEBOARD            = 54,
    ARCADE               = 55,
    TACAN_CTRL_PANEL     = 56,
    SIDEWINDER_INTERFACE = 57,
    TGP_INTERFACE        = 58,
    GPS                  = 59,
    IDM                  = 60,
    MAP                  = 61,
    MAV_INTERFACE        = 62,
    HARM_INTERFACE       = 63,
    HTS_INTERFACE        = 64,
    DTE                  = 65,
    ECM_INTERFACE        = 66
}

COCKPITDEVICES.VIPER.COMMANDS = {}
COCKPITDEVICES.VIPER.COMMANDS.control_commands = {
     DigitalBackup             = 3001,
     AltFlaps                  = 3002,
     BitSw                     = 3003,
     FlcsReset                 = 3004,
     LeFlaps                   = 3005,
     TrimApDisc                = 3006,
     RollTrim                  = 3007,
     PitchTrim                 = 3008,
     YawTrim                   = 3009,
     ManualPitchOverride       = 3010,
     StoresConfig              = 3011,
     ApPitchAtt                = 3012,
     ApPitchAlt                = 3013,
     ApRoll                    = 3014,
     AdvMode                   = 3015,
     ManualTfFlyup             = 3016,
     ThrottleFriction          = 3017,
     AB_DETENT                 = 3018,
     DigitalBackup_ITER        = 3019,
     AltFlaps_ITER             = 3020,
     LeFlaps_ITER              = 3021,
     TrimApDisc_ITER           = 3022,
     RollTrim_ITER             = 3023,
     RollTrim_AXIS             = 3024,
     PitchTrim_ITER            = 3025,
     PitchTrim_AXIS            = 3026,
     YawTrim_ITER              = 3027,
     YawTrim_AXIS              = 3028,
     ManualPitchOverride_ITER  = 3029,
     StoresConfig_ITER         = 3030,
     ApPitchAtt_EXT            = 3031,
     ApPitchAlt_EXT            = 3032,
     ApRoll_ITER               = 3033,
     AdvMode_ITER              = 3034,
     ManualTfFlyup_ITER        = 3035,
     ThrottleFriction_ITER     = 3036
}

COCKPITDEVICES.VIPER.COMMANDS.elec_commands = {
    MainPwrSw                = 3001,
    CautionResetBtn          = 3002,
    FlcsPwrTestSwMAINT       = 3003,
    FlcsPwrTestSwTEST        = 3004,
    EPU_GEN_TestSw           = 3005,
    ProbeHeatSw              = 3006,
    ProbeHeatSwTEST          = 3007,
    MainPwrSw_ITER           = 3008,
    FlcsPwrTestSw_ITER       = 3009,
    EPU_GEN_TestSw_ITER      = 3010,
    ProbeHeatSw_EXT          = 3011,
    ProbeHeatSw_ITER         = 3012,
    EpuSwCvrOn_ITER          = 3013,
    EpuSwCvrOff_ITER         = 3014
}

COCKPITDEVICES.VIPER.COMMANDS.engine_commands = {
    EpuSwCvrOn               = 3001,
    EpuSwCvrOff              = 3002,
    EpuSw                    = 3003,
    EngAntiIceSw             = 3004,
    JfsSwStart1              = 3005,
    JfsSwStart2              = 3006,
    EngContSwCvr             = 3007,
    EngContSw                = 3008,
    MaxPowerSw               = 3009,
    ABResetSwReset           = 3010,
    ABResetSwEngData         = 3011,
    FireOheatTestBtn         = 3012,
    EngAntiIceSw_ITER        = 3013,
    EngContSwCvr_ITER        = 3014,
    EngContSw_ITER           = 3015,
    MaxPowerSw_ITER          = 3016,
    LGHandle                 = 3017,
    DownLockRelBtn           = 3018,
    ParkingSw                = 3019,
    AntiSkidSw               = 3020,
    BrakesChannelSw          = 3021,
    HookSw                   = 3022,
    HornSilencerBtn          = 3023,
    AltGearHandle            = 3024,
    AltGearResetBtn          = 3025
}

COCKPITDEVICES.VIPER.COMMANDS.fuel_commands = {
    FuelMasterSw             = 3001,
    FuelMasterSwCvr          = 3002,
    ExtFuelTransferSw        = 3003,
    EngineFeedSw             = 3004,
    FuelQtySelSw             = 3005,
    FuelQtySelSwTEST         = 3006,
    TankInertingSw           = 3007,
    AirRefuelSw              = 3008,
    FuelMasterSw_ITER        = 3009,
    FuelMasterSwCvr_ITER     = 3010,
    ExtFuelTransferSw_ITER   = 3011,
    EngineFeedSw_ITER        = 3012,
    FuelQtySelSw_ITER        = 3013
}

COCKPITDEVICES.VIPER.COMMANDS.gear_commands = {
    LGHandle                 = 3001,
    DownLockRelBtn           = 3002,
    ParkingSw                = 3003,
    AntiSkidSw               = 3004,
    BrakesChannelSw          = 3005,
    HookSw                   = 3006,
    HornSilencerBtn          = 3007,
    AltGearHandle            = 3008,
    AltGearResetBtn          = 3009
}

COCKPITDEVICES.VIPER.COMMANDS.extlights_commands = {
    AntiCollKn               = 3001,
    PosFlash                 = 3002,
    PosWingTail              = 3003,
    PosFus                   = 3004,
    FormKn                   = 3005,
    Master                   = 3006,
    AerialRefuel             = 3007,
    LandingTaxi              = 3008,
    AntiCollKn_ITER          = 3009,
    PosFlash_ITER            = 3010,
    PosWingTail_ITER         = 3011,
    PosFus_ITER              = 3012,
    FormKn_ITER              = 3013,
    FormKn_AXIS              = 3014
}

COCKPITDEVICES.VIPER.COMMANDS.cpt_commands = {
    CanopyHandcrank          = 3001,
    CanopySwitchOpen         = 3002,
    CanopySwitchClose        = 3003,
    CanopyHandle             = 3004,
    CanopyTHandle            = 3005,
    EjectionHandle           = 3006,
    ShoulderHarnessKnob      = 3007,
    EmergencyOxygenGreenRing = 3008,
    EjectionSafetyLever      = 3009,
    RadioBeaconSwitch        = 3010,
    SurvivalKitDeploymentSwitch = 3011,
    EmergencyManualChuteHandle = 3012,
    SeatAdjSwitchUp          = 3013,
    SeatAdjSwitchDown        = 3014,
    StickHide                = 3015,
    CanopyHandcrank_ITER     = 3016,
    CanopySwitch_ITER        = 3017,
    CanopyHandle_ITER        = 3018,
    CanopyTHandle_ITER       = 3019,
    ShoulderHarnessKnob_ITER = 3020,
    EjectionSafetyLever_ITER = 3021
}

COCKPITDEVICES.VIPER.COMMANDS.oxygen_commands = {
    SupplyLever              = 3001,
    DiluterLever             = 3002,
    EmergencyLever           = 3003,
    EmergencyLeverTestMask   = 3004,
    ObogsBitSw               = 3005,
    SupplyLever_ITER         = 3006,
    DiluterLever_ITER        = 3007,
    EmergencyLever_ITER      = 3008
}

COCKPITDEVICES.VIPER.COMMANDS.hotas_commands = {
    STICK_NWS_AR_DISC_MSL_STEP = 3001,
    STICK_TRIMMER_UP           = 3002,
    STICK_TRIMMER_DOWN         = 3003,
    STICK_TRIMMER_LEFT         = 3004,
    STICK_TRIMMER_RIGHT        = 3005,
    STICK_DISP_MANAGE_UP       = 3006,
    STICK_DISP_MANAGE_DOWN     = 3007,
    STICK_DISP_MANAGE_LEFT     = 3008,
    STICK_DISP_MANAGE_RIGHT    = 3009,
    STICK_TGT_MANAGE_UP        = 3010,
    STICK_TGT_MANAGE_DOWN      = 3011,
    STICK_TGT_MANAGE_LEFT      = 3012,
    STICK_TGT_MANAGE_RIGHT     = 3013,
    STICK_CMS_MANAGE_FWD       = 3014,
    STICK_CMS_MANAGE_AFT       = 3015,
    STICK_CMS_MANAGE_LEFT      = 3016,
    STICK_CMS_MANAGE_RIGHT     = 3017,
    STICK_EXPAND_FOV           = 3018,
    STICK_PADDLE               = 3019,
    STICK_TRIGGER_1ST_DETENT   = 3020,
    STICK_TRIGGER_2ND_DETENT   = 3021,
    STICK_WEAPON_RELEASE       = 3022
}

COCKPITDEVICES.VIPER.COMMANDS.ufc_commands = {
    UFC_Sw                   = 3001,
    DIG0_M_SEL               = 3002,
    DIG1_T_ILS               = 3003,
    DIG2_ALOW                = 3004,
    DIG3                     = 3005,
    DIG4_STPT                = 3006,
    DIG5_CRUS                = 3007,
    DIG6_TIME                = 3008,
    DIG7_MARK                = 3009,
    DIG8_FIX                 = 3010,
    DIG9_A_CAL               = 3011,
    COM1                     = 3012,
    COM2                     = 3013,
    IFF                      = 3014,
    LIST                     = 3015,
    ENTR                     = 3016,
    RCL                      = 3017,
    AA                       = 3018,
    AG                       = 3019,
    RET_DEPR_Knob            = 3020,
    CONT_Knob                = 3021,
    SYM_Knob                 = 3022,
    BRT_Knob                 = 3023,
    Wx                       = 3024,
    FLIR_INC                 = 3025,
    FLIR_DEC                 = 3026,
    FLIR_GAIN_Sw             = 3027,
    DRIFT_CUTOUT             = 3028,
    WARN_RESET               = 3029,
    DED_INC                  = 3030,
    DED_DEC                  = 3031,
    DCS_RTN                  = 3032,
    DCS_SEQ                  = 3033,
    DCS_UP                   = 3034,
    DCS_DOWN                 = 3035,
    F_ACK                    = 3036,
    IFF_IDENT                = 3037,
    RF_Sw                    = 3038,
    UFC_Sw_ITER              = 3039,
    SYM_Knob_ITER            = 3040,
    SYM_Knob_AXIS            = 3041,
    RET_DEPR_Knob_ITER       = 3042,
    RET_DEPR_Knob_AXIS       = 3043,
    BRT_Knob_ITER            = 3044,
    BRT_Knob_AXIS            = 3045,
    CONT_Knob_ITER           = 3046,
    CONT_Knob_AXIS           = 3047,
    FLIR_GAIN_Sw_ITER        = 3048,
    DriftCO_WarnReset_ITER   = 3049
}

COCKPITDEVICES.VIPER.COMMANDS.ecs_commands = {
    AirSourceKnob            = 3001,
    TempKnob                 = 3002,
    DefogLever               = 3003,
    AirSourceKnob_ITER       = 3004,
    TempKnob_ITER            = 3005,
    TempKnob_AXIS            = 3006,
    DefogLever_ITER          = 3007,
    DefogLever_AXIS          = 3008
}

COCKPITDEVICES.VIPER.COMMANDS.mmc_commands = {
    MmcPwr                   = 3001,
    MasterArmSw              = 3002,
    EmerStoresJett           = 3003,
    GroundJett               = 3004,
    AltRel                   = 3005,
    VvVah                    = 3006,
    AttFpm                   = 3007,
    DedData                  = 3008,
    DeprRet                  = 3009,
    Spd                      = 3010,
    Alt                      = 3011,
    Brt                      = 3012,
    Test                     = 3013,
    MFD                      = 3014,
    MmcPwr_ITER              = 3015,
    MasterArmSw_ITER         = 3016,
    MasterArmSw_EXT          = 3017,
    GroundJett_ITER          = 3018,
    VvVah_EXT                = 3019,
    AttFpm_EXT               = 3020,
    DedData_EXT              = 3021,
    DeprRet_EXT              = 3022,
    Spd_EXT                  = 3023,
    Alt_EXT                  = 3024,
    Brt_EXT                  = 3025,
    Test_EXT                 = 3026,
    MFD_ITER                 = 3027
}

COCKPITDEVICES.VIPER.COMMANDS.hmcs_commands = {
    IntKnob                  = 3001,
    IntKnob_ITER             = 3002,
    IntKnob_AXIS             = 3003
}

COCKPITDEVICES.VIPER.COMMANDS.rwr_commands = {
    IntKnob                  = 3001,
    Handoff                  = 3002,
    Launch                   = 3003,
    Mode                     = 3004,
    UnknownShip              = 3005,
    SysTest                  = 3006,
    TgtSep                   = 3007,
    BrtKnob                  = 3008,
    Search                   = 3009,
    ActPwr                   = 3010,
    Power                    = 3011,
    Altitude                 = 3012,
    IntKnob_ITER             = 3013,
    BrtKnob_ITER             = 3014,
    BrtKnob_AXIS             = 3015
}

COCKPITDEVICES.VIPER.COMMANDS.iff_commands = {
    CNI_Knob                 = 3001,
    MasterKnob               = 3002,
    M4CodeSw                 = 3003,
    M4ReplySw                = 3004,
    M4MonitorSw              = 3005,
    EnableSw                 = 3006,
    M1M3Selector1_Inc        = 3007,
    M1M3Selector1_Dec        = 3008,
    M1M3Selector2_Inc        = 3009,
    M1M3Selector2_Dec        = 3010,
    M1M3Selector3_Inc        = 3011,
    M1M3Selector3_Dec        = 3012,
    M1M3Selector4_Inc        = 3013,
    M1M3Selector4_Dec        = 3014,
    CNI_Knob_ITER            = 3015,
    MasterKnob_ITER          = 3016,
    M4CodeSw_ITER            = 3017,
    M4ReplySw_ITER           = 3018,
    M4MonitorSw_ITER         = 3019,
    EnableSw_ITER            = 3020
}

COCKPITDEVICES.VIPER.COMMANDS.mfd_commands = {
    OSB_1                    = 3001,
    OSB_2                    = 3002,
    OSB_3                    = 3003,
    OSB_4                    = 3004,
    OSB_5                    = 3005,
    OSB_6                    = 3006,
    OSB_7                    = 3007,
    OSB_8                    = 3008,
    OSB_9                    = 3009,
    OSB_10                   = 3010,
    OSB_11                   = 3011,
    OSB_12                   = 3012,
    OSB_13                   = 3013,
    OSB_14                   = 3014,
    OSB_15                   = 3015,
    OSB_16                   = 3016,
    OSB_17                   = 3017,
    OSB_18                   = 3018,
    OSB_19                   = 3019,
    OSB_20                   = 3020
}

COCKPITDEVICES.VIPER.COMMANDS.sms_commands = {
    StStaSw                  = 3001,
    LeftHDPT                 = 3002,
    RightHDPT                = 3003,
    LaserSw                  = 3004,
    StSta_ITER               = 3005,
    LeftHDPT_ITER            = 3006,
    RightHDPT_ITER           = 3007,
    LaserSw_ITER             = 3008,
    ChangeLaserCode100       = 3009,
    ChangeLaserCode10        = 3010,
    ChangeLaserCode1         = 3011
}

COCKPITDEVICES.VIPER.COMMANDS.sai_commands = {
    test                     = 3001,
    cage                     = 3002,
    reference                = 3003,
    power                    = 3004,
    reference_EXT            = 3005,
    power_EXT                = 3006,
    cage_EXT                 = 3007,
    reference_AXIS           = 3008
}

COCKPITDEVICES.VIPER.COMMANDS.uhf_commands = {
    ChannelKnob              = 3001,
    FreqSelector100Mhz       = 3002,
    FreqSelector10Mhz        = 3003,
    FreqSelector1Mhz         = 3004,
    FreqSelector01Mhz        = 3005,
    FreqSelector0025Mhz      = 3006,
    FreqModeKnob             = 3007,
    FunctionKnob             = 3008,
    TToneSw                  = 3009,
    SquelchSw                = 3010,
    VolumeKnob               = 3011,
    TestDisplayBtn           = 3012,
    StatusBtn                = 3013,
    AccessDoor               = 3014,
    LoadBtn                  = 3015,
    ZeroSw                   = 3016,
    MnSq                     = 3017,
    GdSq                     = 3018,
    FunctionKnob_ITER        = 3019,
    FreqModeKnob_ITER        = 3020,
    TToneSw_ITER             = 3021,
    SquelchSw_ITER           = 3022,
    VolumeKnob_ITER          = 3023,
    VolumeKnob_AXIS          = 3024,
    AccessDoor_ITER          = 3025,
    ZeroSw_ITER              = 3026
}

COCKPITDEVICES.VIPER.COMMANDS.ky58_commands = {
    KY58_ModeSw              = 3001,
    KY58_FillSw              = 3002,
    KY58_FillSw_Pull         = 3003,
    KY58_PowerSw             = 3004,
    KY58_Volume              = 3005,
    KY58_ModeSw_ITER         = 3006,
    KY58_FillSw_ITER         = 3007,
    KY58_PowerSw_ITER        = 3008,
    KY58_Volume_ITER         = 3009,
    KY58_Volume_AXIS         = 3010
}

COCKPITDEVICES.VIPER.COMMANDS.alt_commands = {
    PNEU                     = 3001,
    ELEC                     = 3002,
    ZERO                     = 3003
}

COCKPITDEVICES.VIPER.COMMANDS.mids_commands = {
    PwrSw                    = 3001,
    PwrSw_ITER               = 3002
}

COCKPITDEVICES.VIPER.COMMANDS.clock_commands = {
    CLOCK_left_lev_up        = 3001,
    CLOCK_left_lev_rotate    = 3002,
    CLOCK_right_lev_down     = 3003
}

COCKPITDEVICES.VIPER.COMMANDS.ins_commands = {
    ModeKnob                 = 3001,
    ModeKnob_ITER            = 3002
}

COCKPITDEVICES.VIPER.COMMANDS.gps_commands = {
    PwrSw                    = 3001,
    PwrSw_ITER               = 3002
}

COCKPITDEVICES.VIPER.COMMANDS.idm_commands = {
    PwrSw                    = 3001,
    PwrSw_ITER               = 3002
}

COCKPITDEVICES.VIPER.COMMANDS.map_commands = {
    PwrSw                    = 3001,
    PwrSw_ITER               = 3002
}



