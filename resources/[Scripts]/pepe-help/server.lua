
Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)




RegisterCommand('help', function(source, args, rawCommand) 
	TriggerClientEvent('rgz_help:start', source)
end, false)


---------invio ID
RegisterServerEvent('id:server:Player')
AddEventHandler('id:server:Player', function()
    local src = source
   
	TriggerClientEvent('sho:client:id', src, src)
			
end)
