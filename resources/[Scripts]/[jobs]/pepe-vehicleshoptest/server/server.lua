Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-vehicleshoptest.requestInfo')
AddEventHandler('pepe-vehicleshoptest.requestInfo', function()
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local rows    

    TriggerClientEvent('pepe-vehicleshoptest.receiveInfo', src, xPlayer.PlayerData.money['bank'], xPlayer.PlayerData.firstname)
    TriggerClientEvent("pepe-vehicleshoptest.vehiclesInfos", src , resultVehicles)    
    TriggerClientEvent("pepe-vehicleshoptest.notify", src, 'error', 'Use A and D To Rotate')
end)

Framework.Functions.CreateCallback('pepe-vehicleshoptest.isPlateTaken', function (source, cb, plate)
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        cb(result[1] ~= nil)
    end)
end)

RegisterServerEvent('pepe-vehicleshoptest.CheckMoneyForVeh')
AddEventHandler('pepe-vehicleshoptest.CheckMoneyForVeh', function(veh, price, name, vehicleProps)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}

    if xPlayer.PlayerData.money['bank'] >= tonumber(price) then
        xPlayer.Functions.RemoveMoney('bank', tonumber(price))
        local vehiclePropsjson = json.encode(vehicleProps)
        if Config.SpawnVehicle then
            stateVehicle = 0
        else
            stateVehicle = 1
        end

        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..xPlayer.PlayerData.citizenid.."', '"..veh.."', '"..vehicleProps.plate.."', 'Rode Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
        TriggerClientEvent("pepe-vehicleshoptest.successfulbuy", source, name, vehicleProps.plate, price)
        TriggerClientEvent('pepe-vehicleshoptest.receiveInfo', source, xPlayer.PlayerData.money['bank'])    
        TriggerClientEvent('pepe-vehicleshoptest.spawnVehicle', source, veh, vehicleProps.plate)
    else
        TriggerClientEvent("pepe-vehicleshoptest.notify", source, 'error', 'Not Enough Money')
    end
end)