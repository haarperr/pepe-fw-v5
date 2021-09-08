RegisterServerEvent('pepe-sound:server:play')
AddEventHandler('pepe-sound:server:play', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('pepe-sound:client:play', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('pepe-sound:server:play:source')
AddEventHandler('pepe-sound:server:play:source', function(soundFile, soundVolume)
    TriggerClientEvent('pepe-sound:client:play', source, soundFile, soundVolume)
end)

RegisterServerEvent('pepe-sound:server:play:distance')
AddEventHandler('pepe-sound:server:play:distance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('pepe-sound:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
end)