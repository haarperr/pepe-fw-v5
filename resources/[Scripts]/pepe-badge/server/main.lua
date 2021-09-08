local Framework = nil

TriggerEvent("Framework:GetObject", function(obj) 
    Framework = obj 
end)

RegisterServerEvent('pepe-badge:open')
AddEventHandler('pepe-badge:open', function(ID, targetID, type)
	local Player = Framework.Functions.GetPlayer(ID)

	local data = {
		name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
		functie = Player.PlayerData.job.grade,
		dob = Player.PlayerData.charinfo.dob
	}

	TriggerClientEvent('pepe-badge:open', targetID, data)
	TriggerClientEvent('pepe-badge:shot', targetID, source )
end)

Framework.Functions.CreateUseableItem('specialbadge', function(source, item)
    TriggerClientEvent('pepe-badge:openPD', source, true)
end)