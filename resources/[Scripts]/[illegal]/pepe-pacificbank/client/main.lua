Framework = nil

Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173
}

Citizen.CreateThread(
    function()
        while Framework == nil do
            TriggerEvent(
                "Framework:GetObject",
                function(obj)
                    Framework = obj
                end
            )
            Citizen.Wait(0)
        end
    end
)

local robberyAlert = false

local isLoggedIn = true

local firstAlarm = false

local requiredItemsShowed = false
local ExplosiveNeeded = false
local copsCalled = false
local LockDownEnded = false
local ExplosiveRange = false
local deuropen = false
local SmokeAlpha = 1.0
local LockPicking = false
local pctjuhgekraakt = false
local SmokePfx = nil
local PlayerJob = {}

CurrentCops = 0
local laser =
    Laser.new(
    vector3(256.861, 236.227, 101.466),
    {
        vector3(258.066, 233.33, 97.743),
        vector3(258.075, 235.983, 101.362),
        vector3(256.688, 236.307, 100.097),
        vector3(256.348, 234.129, 97.483),
        vector3(259.385, 235.561, 97.82),
        vector3(260.238, 235.251, 98.771),
        vector3(258.232, 235.863, 97.594),
        vector3(257.274, 233.463, 97.683)
    },
    {
        travelTimeBetweenTargets = {1.0, 1.0},
        waitTimeAtTargets = {0.0, 0.0},
        randomTargetSelection = true,
        name = "Pepe1"
    }
)
local laser2 =
    Laser.new(
    {
        vector3(254.509, 230.322, 101.924),
        vector3(254.924, 231.46, 101.031),
        vector3(255.263, 232.393, 100.339),
        vector3(255.672, 233.515, 99.481),
        vector3(256.077, 234.628, 98.78),
        vector3(256.688, 236.308, 98.634),
        vector3(258.848, 235.757, 98.645),
        vector3(255.969, 233.924, 101.526),
        vector3(257.932, 232.766, 101.73),
        vector3(255.88, 230.411, 103.348)
    },
    {
        vector3(256.79, 229.257, 101.501),
        vector3(257.199, 230.379, 101.034),
        vector3(257.649, 231.617, 100.156),
        vector3(257.91, 232.332, 99.689),
        vector3(258.108, 233.329, 98.479),
        vector3(258.099, 233.356, 98.793),
        vector3(259.286, 232.915, 98.429),
        vector3(256.355, 232.208, 98.683),
        vector3(256.219, 230.043, 100.077),
        vector3(256.47, 228.773, 100.724)
    },
    {travelTimeBetweenTargets = {1.0, 1.0}, waitTimeAtTargets = {0.0, 0.0}, name = "Pepe2"}
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000 * 60 * 5)
            if copsCalled then
                copsCalled = false
            end
        end
    end
)

RegisterNetEvent("Framework:Client:OnJobUpdate")
AddEventHandler(
    "Framework:Client:OnJobUpdate",
    function(JobInfo)
        PlayerJob = JobInfo
        --onDuty = true
    end
)

RegisterNetEvent("police:SetCopCount")
AddEventHandler(
    "police:SetCopCount",
    function(amount)
        CurrentCops = amount
    end
)

RegisterNetEvent("Framework:Client:SetDuty")
AddEventHandler(
    "Framework:Client:SetDuty",
    function(duty)
        onDuty = duty
    end
)

RegisterNetEvent("Framework:Client:OnPlayerLoaded")
AddEventHandler(
    "Framework:Client:OnPlayerLoaded",
    function()
        PlayerJob = Framework.Functions.GetPlayerData().job
        Framework.Functions.TriggerCallback(
            "pepe-pacific:server:GetConfig",
            function(config)
                Config = config
            end
        )
        onDuty = true
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        local requiredItems = {
            [1] = {
                name = Framework.Shared.Items["electronickit"]["name"],
                image = Framework.Shared.Items["electronickit"]["image"]
            },
            [2] = {
                name = Framework.Shared.Items["trojan_usb"]["name"],
                image = Framework.Shared.Items["trojan_usb"]["image"]
            }
        }
        local Alarm = {
            [1] = {
                name = Framework.Shared.Items["black-card"]["name"],
                image = Framework.Shared.Items["black-card"]["image"]
            }
        }
        local ExplosiveItem = {
            [1] = {
                name = Framework.Shared.Items["explosive"]["name"],
                image = Framework.Shared.Items["explosive"]["image"]
            }
        }
        while true do
            local pos = GetEntityCoords(PlayerPedId())
            local ped = PlayerPedId()
            if Framework ~= nil then
                NearAnything = false
                if Config.PacificB["lights"] then
                    laser.setActive(true)
                    laser2.setActive(true)

                    local Area =
                        GetDistanceBetweenCoords(
                        GetEntityCoords(PlayerPedId()),
                        Config.PacificB["isOpenedStart"]["x"],
                        Config.PacificB["isOpenedStart"]["y"],
                        Config.PacificB["isOpenedStart"]["z"],
                        true
                    )
                    if Area < 2.0 then
                        NearAnything = true
                        DrawMarker(
                            2,
                            Config.PacificB["isOpenedStart"]["x"],
                            Config.PacificB["isOpenedStart"]["y"],
                            Config.PacificB["isOpenedStart"]["z"],
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.1,
                            0.1,
                            0.05,
                            255,
                            255,
                            255,
                            255,
                            false,
                            false,
                            false,
                            1,
                            false,
                            false,
                            false
                        )

                        if not AlarmItem then
                            AlarmItem = true
                            TriggerEvent("pepe-inventory:client:requiredItems", Alarm, true)
                        end
                    else
                        if AlarmItem then
                            AlarmItem = false
                            TriggerEvent("pepe-inventory:client:requiredItems", Alarm, false)
                        end
                    end
                else
                    laser.setActive(false)
                    laser2.setActive(false)
                end

                if not Config.PacificB["isOpened"] then
                    local dist =
                        GetDistanceBetweenCoords(
                        pos.x,
                        pos.y,
                        pos.z,
                        Config.PacificB["coords"]["x"],
                        Config.PacificB["coords"]["y"],
                        Config.PacificB["coords"]["z"],
                        true
                    )
                    if dist < 3.0 then
                        DrawMarker(
                            2,
                            Config.PacificB["coords"].x,
                            Config.PacificB["coords"].y,
                            Config.PacificB["coords"].z,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.1,
                            0.1,
                            0.05,
                            255,
                            255,
                            255,
                            255,
                            false,
                            false,
                            false,
                            1,
                            false,
                            false,
                            false
                        )

                        NearAnything = true
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent("pepe-inventory:client:requiredItems", requiredItems, true)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent("pepe-inventory:client:requiredItems", requiredItems, false)
                        end
                    end
                end
                if Config.PacificB["isOpened"] then
                    for Troll, Trolly in pairs(Config.Trollys) do
                        local TrollyDistance =
                            GetDistanceBetweenCoords(
                            GetEntityCoords(PlayerPedId()),
                            Trolly["Coords"]["X"],
                            Trolly["Coords"]["Y"],
                            Trolly["Coords"]["Z"],
                            true
                        )
                        if TrollyDistance < 1.5 then
                            NearAnything = true
                            if not Trolly["Open-State"] then
                                DrawMarker(
                                    2,
                                    Trolly["Grab-Coords"]["X"],
                                    Trolly["Grab-Coords"]["Y"],
                                    Trolly["Grab-Coords"]["Z"],
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.1,
                                    0.1,
                                    0.05,
                                    242,
                                    148,
                                    41,
                                    255,
                                    false,
                                    false,
                                    false,
                                    1,
                                    false,
                                    false,
                                    false
                                )
                                Framework.Functions.DrawText3D(
                                    Trolly["Grab-Coords"]["X"],
                                    Trolly["Grab-Coords"]["Y"],
                                    Trolly["Grab-Coords"]["Z"],
                                    _U("grabmoney")
                                )
                                if IsControlJustReleased(0, 38) then
                                    GetMoneyFromTrolly(Troll)
                                end
                            end
                        end
                    end
                end

                if not Config.PacificB["explosive"]["isOpened"] then
                    if
                        GetDistanceBetweenCoords(
                            pos,
                            Config.PacificB["explosive"]["x"],
                            Config.PacificB["explosive"]["y"],
                            Config.PacificB["explosive"]["z"],
                            true
                        ) < 2.5
                     then
                        ExplosiveRange = true
                        if not Config.PacificB["explosive"]["isOpened"] then
                            -- local dist = GetDistanceBetweenCoords(pos, Config.PacificB["explosive"]["x"], Config.PacificB["explosive"]["y"], Config.PacificB["explosive"]["z"], true)
                            -- if dist < 1 then
                            --     if not ExplosiveNeeded then
                            ExplosiveNeeded = true
                        --         TriggerEvent('pepe-inventory:client:requiredItems', ExplosiveItem, true)
                        --     end
                        -- else
                        --     if ExplosiveNeeded then
                        --         ExplosiveNeeded = false
                        --         TriggerEvent('pepe-inventory:client:requiredItems', ExplosiveItem, false)
                        --     end
                        -- end
                        end
                    else
                        ExplosiveRange = false
                    end
                end
            end

            if not NearAnything then
                Citizen.Wait(5000)
            else
                Citizen.Wait(3)
            end
        end
    end
)

RegisterNetEvent("pepe-pacific:client:PoliceAlertMessage")
AddEventHandler(
    "pepe-pacific:client:PoliceAlertMessage",
    function(title, coords, blip)
        if blip then
            TriggerEvent(
                "pepe-policealerts:client:AddPoliceAlert",
                {
                    timeOut = 5000,
                    alertTitle = title,
                    details = {
                        [1] = {
                            icon = '<i class="fas fa-gem"></i>',
                            detail = _U("reportheader")
                        },
                        [2] = {
                            icon = '<i class="fas fa-video"></i>',
                            detail = _U("reportcam")
                        },
                        [3] = {
                            icon = '<i class="fas fa-globe-europe"></i>',
                            detail = _U("reportheader")
                        }
                    },
                    callSign = Framework.Functions.GetPlayerData().metadata["callsign"]
                }
            )
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Citizen.Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            Citizen.Wait(100)
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            local transG = 100
            local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
            SetBlipSprite(blip, 9)
            SetBlipColour(blip, 1)
            SetBlipAlpha(blip, transG)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(_U("reportheader"))
            EndTextCommandSetBlipName(blip)
            while transG ~= 0 do
                Wait(180 * 4)
                transG = transG - 1
                SetBlipAlpha(blip, transG)
                if transG == 0 then
                    SetBlipSprite(blip, 2)
                    RemoveBlip(blip)
                    return
                end
            end
        else
            if not robberyAlert then
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                TriggerEvent(
                    "pepe-policealerts:client:AddPoliceAlert",
                    {
                        timeOut = 5000,
                        alertTitle = title,
                        details = {
                            [1] = {
                                icon = '<i class="fas fa-gem"></i>',
                                detail = _U("reportheader")
                            },
                            [2] = {
                                icon = '<i class="fas fa-video"></i>',
                                detail = _U("reportcam")
                            },
                            [3] = {
                                icon = '<i class="fas fa-globe-europe"></i>',
                                detail = _U("reportheader")
                            }
                        },
                        callSign = Framework.Functions.GetPlayerData().metadata["callsign"]
                    }
                )
                robberyAlert = true
            end
        end
    end
)

RegisterNetEvent("pepe-pacific:client:Klapdebank")
AddEventHandler(
    "pepe-pacific:client:Klapdebank",
    function(state)
        Config.PacificB["explosive"]["isOpened"] = state
    end
)

--Citizen.CreateThread(
   -- function()
     --   Citizen.Wait(18000)
     --   TriggerServerEvent("pepe:licenseCheck")
   -- end
--)

RegisterNetEvent("pepe-pacific:client:setfirstState")
AddEventHandler(
    "pepe-pacific:client:setfirstState",
    function(state)
        Config.PacificB["explosive"]["isOpened"] = state
        TriggerServerEvent("pepe-pacific:server:setTimeout")
    end
)

RegisterNetEvent("pepe-pacific:client:setLockerState")
AddEventHandler(
    "pepe-pacific:client:setLockerState",
    function(lockerId, state, bool)
        Config.PacificB["lockers"][lockerId][state] = bool
    end
)

RegisterNetEvent("pepe-pacific:client:set:lights:state")
AddEventHandler(
    "pepe-pacific:client:set:lights:state",
    function(bool)
        Config.PacificB["lights"] = bool
    end
)

RegisterNetEvent("pepe-pacific:client:set:trol:state")
AddEventHandler(
    "pepe-pacific:client:set:trol:state",
    function(state)
        Config.PacificB["isOpened"] = state
        TriggerServerEvent("pepe-pacific:server:setTimeout")
    end
)

RegisterNetEvent("pepe-pacific:client:DoSmokePfx")
AddEventHandler(
    "pepe-pacific:client:DoSmokePfx",
    function()
        if SmokePfx == nil then
            loadParticleDict("des_vaultdoor")
            UseParticleFxAssetNextCall("des_vaultdoor")
            SmokePfx =
                StartParticleFxLoopedOnEntity(
                "ent_ray_pro1_residual_smoke",
                GetClosestObjectOfType(
                    Config.PacificB["explosive"]["x"],
                    Config.PacificB["explosive"]["y"],
                    Config.PacificB["explosive"]["z"],
                    2.0,
                    GetHashKey("v_ilev_bl_doorpool"),
                    false,
                    false,
                    false
                ),
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.5,
                false,
                false,
                false
            )
            SetTimeout(
                30000,
                function()
                    for i = 1, 1000, 1 do
                        SetParticleFxLoopedAlpha(SmokePfx, SmokeAlpha)
                        SmokeAlpha = SmokeAlpha - 0.005
                        if SmokeAlpha - 0.005 < 0 then
                            RemoveParticleFx(SmokePfx, 0)
                            RemoveParticleFxFromEntity(
                                GetClosestObjectOfType(
                                    Config.PacificB["explosive"]["x"],
                                    Config.PacificB["explosive"]["y"],
                                    Config.PacificB["explosive"]["z"],
                                    2.0,
                                    GetHashKey("v_ilev_bl_doorpool"),
                                    false,
                                    false,
                                    false
                                )
                            )
                            SmokeAlpha = 1.0
                            SmokePfx = nil
                            break
                        end
                        Wait(25)
                    end
                end
            )
        end
    end
)

RegisterNetEvent("pepe-pacific:client:clear:trollys")
AddEventHandler(
    "pepe-pacific:client:clear:trollys",
    function()
        Count = 0
        for k, v in pairs(Config.Trollys) do
            local ObjectOne =
                GetClosestObjectOfType(
                v["Coords"]["X"],
                v["Coords"]["Y"],
                v["Coords"]["Z"],
                20.0,
                269934519,
                false,
                false,
                false
            )
            local ObjectTwo =
                GetClosestObjectOfType(
                v["Coords"]["X"],
                v["Coords"]["Y"],
                v["Coords"]["Z"],
                20.0,
                769923921,
                false,
                false,
                false
            )
            DeleteEntity(ObjectOne)
            DeleteObject(ObjectOne)
            DeleteEntity(ObjectTwo)
            DeleteObject(ObjectTwo)
        end
        for k, v in pairs(Config.Trollys) do
            v["Open-State"] = false
        end
    end
)

RegisterNetEvent("pepe-pacific:client:set:trolly:state")
AddEventHandler(
    "pepe-pacific:client:set:trolly:state",
    function(TrollyNumber, bool)
        Config.Trollys[TrollyNumber]["Open-State"] = bool
    end
)
