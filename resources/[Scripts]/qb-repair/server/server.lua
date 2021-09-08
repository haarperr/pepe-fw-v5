Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

--Framework.Commands.Add("repair", "for testing the script", {}, false, function(source, args)
	--local _player = Framework.Functions.GetPlayer(source)
	--if _player.PlayerData.job.name == "mechanic" then 
	--TriggerClientEvent('ft-repair:client:triggerMenu', source)
	--end
--end)