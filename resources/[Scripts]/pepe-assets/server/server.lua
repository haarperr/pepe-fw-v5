Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-assets:server:tackle:player')
AddEventHandler('pepe-assets:server:tackle:player', function(playerId)
    TriggerClientEvent("pepe-assets:client:get:tackeled", playerId)
end)

RegisterServerEvent('pepe-assets:server:display:text')
AddEventHandler('pepe-assets:server:display:text', function(Text)
	TriggerClientEvent('pepe-assets:client:me:show', -1, Text, source)
end)

RegisterServerEvent('pepe-assets:server:drop')
AddEventHandler('pepe-assets:server:drop', function()
	if not Framework.Functions.HasPermission(source, 'admin') then
		TriggerEvent("pepe-logs:server:SendLog", "anticheat", "Nui Devtools", "red", "**".. GetPlayerName(source).. "** Tried opening devtools.")
		DropPlayer(source, 'Do not open DevTools.')
	end
end)

Framework.Commands.Add("id", "Xem số id của bạn", {}, false, function(source, args)
    TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "ID: "..source)
end)
Framework.Commands.Add("shuff", "Ghế shuffle.", {}, false, function(source, args)
 TriggerClientEvent('pepe-assets:client:seat:shuffle', source)
end)

Framework.Commands.Add("me", "Thực hiện một văn bản trên PED", {}, false, function(source, args)
  local Text = table.concat(args, ' ')
  TriggerClientEvent('pepe-assets:client:me:show', -1, Text, source)
end)