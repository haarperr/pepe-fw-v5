Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local inRange = true

            local LabDist =
                GetDistanceBetweenCoords(
                pos,
                Config.PacificB["coords"]["x"],
                Config.PacificB["coords"]["y"],
                Config.PacificB["coords"]["z"],
                true
            )

            if LabDist < 15 then
                inRange = true
                if Config.PacificB["isOpened"] then
                    --local object = GetClosestObjectOfType(Config.PacificB["coords"]["x"], Config.PacificB["coords"]["y"], Config.PacificB["coords"]["z"], 5.0, Config.PacificB["object"], false, false, false)
                    --if object ~= 0 then
                    --    SetEntityHeading(object, Config.BigBanks["paleto"]["heading"].open)
                    --end
                    TriggerServerEvent("pepe-doorlock:server:updateState", 36, false)
                else
                    --local object = GetClosestObjectOfType(Config.PacificB["coords"]["x"], Config.PacificB["coords"]["y"], Config.PacificB["coords"]["z"], 5.0, Config.PacificB["object"], false, false, false)
                    --if object ~= 0 then
                    --    SetEntityHeading(object, Config.PacificB["heading"].closed)
                    --end
                    TriggerServerEvent("pepe-doorlock:server:updateState", 36, true)
                end
            end

            if not inRange then
                Citizen.Wait(5000)
            end

            Citizen.Wait(1000)
        end
    end
)

RegisterNetEvent("pepe-pacific:client:ClearTimeoutDoors")
AddEventHandler(
    "pepe-pacific:client:ClearTimeoutDoors",
    function()
        TriggerServerEvent("pepe-doorlock:server:updateState", 35, true)
        TriggerServerEvent("pepe-doorlock:server:updateState", 36, true)
        local DoorPObject =
            GetClosestObjectOfType(
            Config.PacificB["coords"]["x"],
            Config.PacificB["coords"]["y"],
            Config.PacificB["coords"]["z"],
            5.0,
            Config.PacificB["object"],
            false,
            false,
            false
        )
        if DoorPObject ~= 0 then
            SetEntityHeading(PaletoObject, Config.PacificB["heading"].closed)
        end

        Config.PacificB["isOpened"] = false
        Config.PacificB["lights"] = false
        Config.PacificB["explosive"]["isOpened"] = false
    end
)
