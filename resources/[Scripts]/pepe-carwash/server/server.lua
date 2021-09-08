Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('pepe-carwash:server:can:wash', function(source, cb, price)
    local CanWash = false
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "car-wash") then
        CanWash = true
    else 
        CanWash = false
    end
    cb(CanWash)
end)

RegisterServerEvent('pepe-carwash:server:set:busy')
AddEventHandler('pepe-carwash:server:set:busy', function(CarWashId, bool)
 Config.CarWashLocations[CarWashId]['Busy'] = bool
 TriggerClientEvent('pepe-carwash:client:set:busy', -1, CarWashId, bool)
end)

RegisterServerEvent('pepe-carwash:server:sync:wash')
AddEventHandler('pepe-carwash:server:sync:wash', function(Vehicle)
 TriggerClientEvent('pepe-carwash:client:sync:wash', -1, Vehicle)
end)

RegisterServerEvent('pepe-carwash:server:sync:water')
AddEventHandler('pepe-carwash:server:sync:water', function(WaterId)
 TriggerClientEvent('pepe-carwash:client:sync:water', -1, WaterId)
end)

RegisterServerEvent('pepe-carwash:server:stop:water')
AddEventHandler('pepe-carwash:server:stop:water', function(WaterId)
 TriggerClientEvent('pepe-carwash:client:stop:water', -1, WaterId)
end)
