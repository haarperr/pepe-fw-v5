Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('CrashTackle')
AddEventHandler('CrashTackle', function(playerId)
	TriggerClientEvent("playerTackled", playerId)
end)

RegisterServerEvent('undragTarget')
AddEventHandler('undragTarget', function(playerId)
	TriggerClientEvent("undragPlayer", playerId, source)
end)

RegisterServerEvent('dragTarget')
AddEventHandler('dragTarget', function(playerId)
	TriggerClientEvent("dragPlayer", playerId, source)
end)

RegisterServerEvent("pepe-carry:beingCarried")
AddEventHandler("pepe-carry:beingCarried", function(beingCarried)
	local src = source
	local Player = Framework.Functions.GetPlayer(src)
	TriggerClientEvent("pepe-carry:beingCarried", src, beingCarried)
	Player.Functions.SetMetaData('incarry', beingCarried)
end)