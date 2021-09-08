Config = {}

Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Config.Priority = {}

Config.RequireSteam = true

Config.PriorityOnly = false

Config.DisableHardCap = true

Config.ConnectTimeOut = 600

Config.QueueTimeOut = 90

Config.EnableGrace = true

Config.GracePower = 2

Config.GraceTime = 120

Config.JoinDelay = 30000

Config.ShowTemp = false

Config.Language = {
    joining = "\xF0\x9F\x8E\x89Joining..",
    connecting = "\xE2\x8F\xB3Connecting...",
    idrr = "\xE2\x9D\x97[Queue] Error: Can not reach ID, Try restarting.",
    err = "\xE2\x9D\x97[Queue] ERROR",
    pos = "\xF0\x9F\x90\x8CYou are %d/%d in queue \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Error: Can not enter queue..",
    timedout = "\xE2\x9D\x97[Queue] Error: Timed out",
    wlonly = "\xE2\x9D\x97[Queue] You require a whitelist to join this server..",
    steam = "\xE2\x9D\x97 [Queue] Error: Steam is required to play.."
}

Citizen.CreateThread(function()
	LoadQueueDatabase()
end)

function LoadQueueDatabase()
	Framework.Functions.ExecuteSql(false, "SELECT * FROM `server_extra`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				Config.Priority[v.steam] = tonumber(v.priority)
			end
		end
	end)
end

Framework.Commands.Add("reloadprio", "Reload queue", {}, false, function(source, args)
	LoadQueueDatabase()
	TriggerClientEvent('Framework:Notify', Player.PlayerData.source, "Queue refreshed..", "success")	
end, "user")

Framework.Commands.Add("addpriority", "Give queue priority", {{name="id", help="Player ID"}, {name="priority", help="Priority level"}}, true, function(source, args)
    local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	local level = tonumber(args[2])
	if Player ~= nil then
		AddPriority(Player.PlayerData.source, level)
		TriggerClientEvent('Framework:Notify', Player.PlayerData.source, "Je queue prioriteit is aangepast.", "success")
        TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "Je hebt " .. GetPlayerName(Player.PlayerData.source) .. " prioriteit gegeven ("..level..")")	
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")	
	end
end, "user")

Framework.Commands.Add("removepriority", "Take away queue priority", {{name="id", help="Player ID"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		RemovePriority(Player.PlayerData.source)
		TriggerClientEvent('Framework:Notify', Player.PlayerData.source, "Your queue priority has been taken.", "error")
        TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "You took queue priority of " .. GetPlayerName(Player.PlayerData.source))	
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")	
	end
end, "user")

function AddPriority(source, level)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then 
		Config.Priority[GetPlayerIdentifiers(source)[1]] = level
		Framework.Functions.ExecuteSql(true, "INSERT INTO `server_extra` (`name`, `steam`, `license`, `priority`, `permission`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..level.."'), '"..Framework.Functions.GetPermission(source).."'")
		Player.Functions.UpdatePlayerData()
	end
end

function RemovePriority(source)
	local Player = Framework.Functions.GetPlayer(source)
	if Player ~= nil then 
		Config.Priority[GetPlayerIdentifiers(source)[1]] = nil
		Framework.Functions.ExecuteSql(true, "DELETE FROM `server_extra` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
	end
end