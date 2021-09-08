local NearSmelt = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearSmelt = false
            local Playercoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(Playercoords.x, Playercoords.y, Playercoords.z, Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'], true) <= 1.5 then
                NearSmelt = true
                if not Config.Smelting then
                    if Config.CanTake then
                        DrawMarker(2, Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        DrawText3D(Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'] + 0.15, "~g~E~w~ - Retrieve Gold")
                        if IsControlJustReleased(0, 38) then
                            Config.Smelting = false
                            Config.CanTake = false
                            Config.MeltTime = 300
                            TriggerServerEvent('pepe-pawnshop:server:redeem:gold:bars')
                        end
                    else
                        DrawMarker(2, Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 39, 196, 27, 255, false, false, false, 1, false, false, false)
                        DrawText3D(Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'] + 0.15, "~g~E~w~ - Melt Gold")
                        if IsControlJustReleased(0, 38) then
                            Framework.Functions.Progressbar("sell-gold", "Smelting Gold..", math.random(10000, 15000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                TriggerServerEvent('pepe-pawnshop:server:smelt:gold')
                            end, function() -- Cancel
                                Framework.Functions.Notify("Cancelled..", "error")
                            end)
                        end
                    end
                elseif Config.Smelting and Config.SmeltTime > 0 then
                    DrawMarker(2, Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 227, 142, 39, 255, false, false, false, 1, false, false, false)
                    DrawText3D(Config.Locations['Smeltery'][1]['X'], Config.Locations['Smeltery'][1]['Y'], Config.Locations['Smeltery'][1]['Z'] + 0.15, "~o~Melting: ~s~"..Config.SmeltTime..'s')
                end
            end
            if not NearSmelt then
                Citizen.Wait(2500)
            end
        end
    end
end)

RegisterNetEvent('pepe-pawnshop:client:start:process')
AddEventHandler('pepe-pawnshop:client:start:process', function()
    if not Config.Smelting then
        Config.Smelting = true
        while Config.Smelting do
          if Config.SmeltTime > 0 then
            Config.SmeltTime = Config.SmeltTime - 1
          end
          if Config.SmeltTime <= 0 then
            Config.CanTake = true
            Config.Smelting = false
          end
          Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('pepe-pawnshop:server:reset:smelter')
AddEventHandler('pepe-pawnshop:server:reset:smelter', function()
    Config.Smelting = false
    Config.CanTake = false
    Config.SmeltTime = 300 -- Adjust the time if you like 300 sec = 5 minutes. Highleaks.com Pepe Framework
end)