local Framework = nil

TriggerEvent("Framework:GetObject", function(library)
    Framework = library
end)

RegisterServerEvent('mechanic:sv:removeCash')
AddEventHandler('mechanic:sv:removeCash', function(amount)
	local src = source

    amount = tonumber(amount)
    if (not amount or amount <= 0) then return end
    
    local xPlayer = Framework.Functions.GetPlayer(src)
    if (xPlayer) then
        xPlayer.Functions.RemoveMoney('cash', amount)
    end
end)

RegisterServerEvent("mechanic:sv:saveVehicleProps")
AddEventHandler("mechanic:sv:saveVehicleProps", function(vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        Framework.Functions.ExecuteSql(false, "UPDATE `characters_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

RegisterServerEvent("lscustoms:server:SaveVehicleProps") -- FOR RESOURCE COMPATABILITY UNTIL I CHANGE ALL *lscustoms:server:SaveVehicleProps* TO *mechanic:sv:saveVehicleProps*
AddEventHandler("lscustoms:server:SaveVehicleProps", function(vehicleProps)
	local src = source
    if IsVehicleOwned(vehicleProps.plate) then
        Framework.Functions.ExecuteSql(false, "UPDATE `characters_vehicles` SET `mods` = '"..json.encode(vehicleProps).."' WHERE `plate` = '"..vehicleProps.plate.."'")
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    Framework.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end
