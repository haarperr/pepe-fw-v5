Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
	TriggerClientEvent("pepe-binds:client:openUI", source)
end)

RegisterServerEvent('pepe-binds:server:setKeyMeta')
AddEventHandler('pepe-binds:server:setKeyMeta', function(keyMeta)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("commandbinds", keyMeta)
end)