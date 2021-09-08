local PlayerData, Framework = nil, nil

Citizen.CreateThread(function()
	while Framework == nil do
		TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
		Citizen.Wait(200)
	end

	while Framework.Functions.GetPlayerData() == nil do
		Wait(0)
	end

	while Framework.Functions.GetPlayerData().job == nil do
		Wait(0)
	end

	PlayerData = Framework.Functions.GetPlayerData()
end)

RegisterNetEvent("Framework:Client:OnJobUpdate")
AddEventHandler("Framework:Client:OnJobUpdate", function(JobInfo)
	PlayerData.job = JobInfo
end)

CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)
        local letSleep = true
        
        if PlayerData and PlayerData.job.name == 'weapondealer' then

            local stash = Config.Locations['stash']
            local shop = Config.Locations['shop']

            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stash.x, stash.y, stash.z, true) < 10) then
                letSleep = false
                DrawMarker(2, stash.x, stash.y, stash.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, stash.x, stash.y, stash.z, true) < 1.5) then
                    Framework.Functions.DrawText3D(stash.x, stash.y, stash.z, "~g~E~w~ - Opbevaring")
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "weapondealer")
                        TriggerEvent("pepe-inventory:client:SetCurrentStash", "weapondealer")

                    end
                end  
            end

            if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 10) and PlayerData.job.isboss then
                letSleep = false
                DrawMarker(2, shop.x, shop.y, shop.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                 if (GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, shop.x, shop.y, shop.z, true) < 1.5) then
                    Framework.Functions.DrawText3D(shop.x, shop.y, shop.z, "~g~E~w~ - Shop")
                    if IsControlJustReleased(0, 38) then
					
                                    local items = Maakitems(PlayerData.job.grade.level)
                        TriggerServerEvent("pepe-inventory:server:OpenInventory", "shop", "weapondealer", items)
                    end
                end  
            end
        end


        if letSleep then
            Wait(2000)
        end

        Wait(1)
    end
end)


function WeaponAlreadyInArmory(items, nna)
    for k, v in pairs(items) do
        if v.name == nna then
            return true
        end
    end
    return false
end


function Maakitems(grade)
    local playerArmoryItems = Config.Items
    local grade = tonumber(grade) ~= nil and tonumber(grade) or 1
    if grade > 1 then
        if not WeaponAlreadyInArmory(playerArmoryItems.items, "weapon_smg") then
            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "weapon_smg",
                price = 0,
                amount = 1,
                info = {
                    serie = "",                
                    attachments = {
                        {component = "COMPONENT_AT_SCOPE_MACRO_02", label = "1x Scope"},
                        {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    }
                },
                type = "weapon",
                slot = #playerArmoryItems.items + 1,
            }

            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "smg_ammo",
                price = 0,
                amount = 5,
                info = {},
                type = "item",
                slot = #playerArmoryItems.items + 1,
            }
        end
    end

    if grade > 4 then
        if not WeaponAlreadyInArmory(playerArmoryItems.items, "weapon_carbinerifle") then
            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "weapon_carbinerifle",
                price = 0,
                amount = 1,
                info = {
                    serie = "",
                    attachments = {
                        {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                        {component = "COMPONENT_AT_SCOPE_MEDIUM", label = "3x Scope"},
                    }
                },
                type = "weapon",
                slot = #playerArmoryItems.items + 1,
            }

            playerArmoryItems.items[#playerArmoryItems.items + 1] = {
                name = "rifle_ammo",
                price = 0,
                amount = 5,
                info = {},
                type = "item",
                slot = #playerArmoryItems.items + 1,
            }
        end
    end

    playerArmoryItems.slots = #playerArmoryItems.items

    for k, v in pairs(playerArmoryItems.items) do
        if v.type == 'weapon' then
            playerArmoryItems.items[k].info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        end
    end

    return playerArmoryItems
end