ExplosiveRange = false
RegisterNetEvent("electronickit:UseElectronickit")
AddEventHandler(
    "electronickit:UseElectronickit",
    function()
        print("Used electronic kit.")
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
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
            print("Within distance.")
            DrawMarker(
                2,
                Config.PacificB["coords"]["x"],
                Config.PacificB["coords"]["y"],
                Config.PacificB["coords"]["z"],
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
            if CurrentCops >= Config.PacificBPolice then
                print("Current cops good.")
                if not Config.PacificB["isOpened"] then
                    print("Pacific bank is being robbed.")
                    Framework.Functions.TriggerCallback(
                        "Framework:HasItem",
                        function(result)
                            if result then
                                print("Has item.")
                                TriggerEvent("pepe-inventory:client:requiredItems", requiredItems, false)
                                print("Starting hack...")
                                exports["minigame-phone"]:ShowHack()
                                exports["minigame-phone"]:StartHack(
                                    math.random(3, 5),
                                    math.random(15, 22),
                                    function(Success)
                                        if Success then
                                            CreateTrollys()
                                            LockDownEnded = true
                                            pctjuhgekraakt = true
                                            deuropen = true
                                            TriggerServerEvent("Framework:Server:RemoveItem", "electronickit", 1)
                                            TriggerServerEvent("Framework:Server:RemoveItem", "trojan_usb", 1)

                                            TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["electronickit"], "remove")

                                            TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items["trojan_usb"], "remove")

                                            TriggerEvent("pepe-inventory:client:set:busy", false)

                                            TriggerServerEvent("pepe-doorlock:server:updateState", 36, false)

                                            TriggerServerEvent("pepe-pacific:server:set:trollyz", true)
                                        else
                                            Framework.Functions.Notify(_U("failedtask"), "error")
                                            TriggerEvent("pepe-inventory:client:set:busy", false)
                                        end
                                        exports["minigame-phone"]:HideHack()
                                    end
                                )
                            else
                                Framework.Functions.Notify(_U("missingitem"), "error")
                            end
                        end,
                        "trojan_usb"
                    )
                else
                    Framework.Functions.Notify(_U("canthack"), "error")
                end
            else
                Framework.Functions.Notify(_U("nocops"), "error")
            end
        end
    end
)

RegisterNetEvent("explosive:UseExplosivePacific")
AddEventHandler(
    "explosive:UseExplosivePacific",
    function()
        local Positie = GetEntityCoords(PlayerPedId())
        local dist =
            GetDistanceBetweenCoords(
            Positie.x,
            Positie.y,
            Positie.z,
            Config.PacificB["explosive"]["x"],
            Config.PacificB["explosive"]["y"],
            Config.PacificB["explosive"]["z"],
            true
        )
        if dist < 2.8 then
            ExplosiveRange = true
        else
            ExplosiveRange = false
        end
        if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", Positie)
        end
        if CurrentCops >= Config.PacificBPolice then
            if ExplosiveRange then
                Framework.Functions.TriggerCallback(
                    "pepe-pacific:server:isRobberyActive",
                    function(isBusy)
                        if not isBusy then
                            TriggerEvent("pepe-inventory:client:busy:status", true)
                            GiveWeaponToPed(PlayerPedId(), GetHashKey("weapon_stickybomb"), 1, false, true)
                            Citizen.Wait(1000)
                            TaskPlantBomb(PlayerPedId(), Positie.x, Positie.y, Positie.z, 218.5)
                            TriggerServerEvent("Framework:Server:RemoveItem", "explosive", 1)
                            TriggerServerEvent("pepe-pacific:server:DoSmokePfx")
                            TriggerEvent("pepe-inventory:client:busy:status", false)
                            local time = 5
                            local coords = GetEntityCoords(PlayerPedId())
                            while time > 0 do
                                Citizen.Wait(1000)
                                time = time - 1
                            end
                            AddExplosion(
                                Config.PacificB["explosive"]["x"],
                                Config.PacificB["explosive"]["y"],
                                Config.PacificB["explosive"]["z"],
                                EXPLOSION_STICKYBOMB,
                                4.0,
                                true,
                                false,
                                20.0
                            )
                            deuren = true
                            deuropen = true
                            TriggerServerEvent("pepe-doorlock:server:updateState", 35, false)
                            TriggerServerEvent("pepe-pacific:server:Klapdebank", true)
                            Framework.Functions.TriggerCallback(
                                "pepe-pacific:server:PoliceAlertMessage",
                                function(result)
                                end,
                                "Pacific Bank",
                                Positie,
                                true
                            )
                        else
                            Framework.Functions.Notify(_U("lockdownactive"), "error", 5500)
                        end
                    end
                )
            else
                Framework.Functions.Notify(_U("cannotuse"), "error")
            end
        else
            Framework.Functions.Notify(_U("nocops"), "error")

            TriggerServerEvent("pepe-scoreboard:server:SetActivityBusy", "humanelabs", false)
        end
    end
)

RegisterNetEvent("pepe-pacificbank:client:use:black-card")
AddEventHandler(
    "pepe-pacificbank:client:use:black-card",
    function()
        if not Config.PacificB["isOpenedStart"]["isOpened"] then
            local Area =
                GetDistanceBetweenCoords(
                GetEntityCoords(PlayerPedId()),
                Config.PacificB["isOpenedStart"]["x"],
                Config.PacificB["isOpenedStart"]["y"],
                Config.PacificB["isOpenedStart"]["z"],
                true
            )
            if Area < 1.35 then
                if CurrentCops >= Config.PacificBPolice then
                    Framework.Functions.TriggerCallback(
                        "pepe-pacificbank:server:HasItem",
                        function(HasItem)
                            if HasItem then
                                if Config.PacificB["lights"] then
                                    TriggerEvent("pepe-inventory:client:set:busy", true)
                                    TriggerEvent("pepe-inventory:client:requiredItems", PacificItems, false)
                                    exports["minigame-phone"]:ShowHack()
                                    exports["minigame-phone"]:StartHack(
                                        math.random(1, 4),
                                        130,
                                        function(Success)
                                            if Success then
                                                TriggerEvent(
                                                    "utk_fingerprint:Start",
                                                    1,
                                                    1,
                                                    1,
                                                    function(Outcome)
                                                        if Outcome then
                                                            TriggerServerEvent("pepe-pacific:server:set:lights", false)
                                                            TriggerServerEvent(
                                                                "Framework:Server:RemoveItem",
                                                                "black-card",
                                                                1
                                                            )
                                                            TriggerEvent(
                                                                "pepe-inventory:client:ItemBox",
                                                                Framework.Shared.Items["black-card"],
                                                                "remove"
                                                            )
                                                            TriggerEvent("pepe-inventory:client:set:busy", false)
                                                            Framework.Functions.Notify(_U("lightsoff"), "success")
                                                            LockDownStart()
                                                        end
                                                    end
                                                )
                                            else
                                                Framework.Functions.Notify(_U("failed"), "error")
                                                TriggerEvent("pepe-inventory:client:set:busy", false)
                                            end
                                            exports["minigame-phone"]:HideHack()
                                        end
                                    )
                                end
                            else
                                Framework.Functions.Notify("You are missing something..", "error")
                            end
                        end,
                        "electronickit"
                    )
                else
                    Framework.Functions.Notify(_U("nocops"), "info")
                end
            end
        end
    end
)
