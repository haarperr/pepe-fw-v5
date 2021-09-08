Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Functions.CreateCallback("pepe-doorlock:server:get:config", function(source, cb)
    cb(Config)
  end)

RegisterServerEvent('pepe-doorlock:server:updateState')
AddEventHandler('pepe-doorlock:server:updateState', function(doorID, state)
 Config.Doors[doorID]['Locked'] = state
 TriggerClientEvent('pepe-doorlock:client:setState', -1, doorID, state)
end)