Framework.Commands = {}
Framework.Commands.List = {}

Framework.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	Framework.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

Framework.Commands.Refresh = function(source)
	local Player = Framework.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(Framework.Commands.List) do
			if Framework.Functions.HasPermission(source, "user") or Framework.Functions.HasPermission(source, Framework.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

Framework.Commands.Add("tp", "Teleport to player or coords", {{name="id/x", help="Player id or X Position"}, {name="y", help="Y Position"}, {name="z", help="Z Position"}}, false, function(source, args)
	if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
		-- tp to player
		local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('Framework:Command:TeleportToPlayer', source, Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online.")
		end
	else
		-- tp to location
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			TriggerClientEvent('Framework:Command:TeleportToCoords', source, x, y, z)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Invalid format (x, y, z)")
		end
	end
end, "user")

Framework.Commands.Add("addpermission", "Give perms (god/admin)", {{name="id", help="Player id"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		Framework.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online.")	
	end
end, "user")

Framework.Commands.Add("removepermission", "Remove perms", {{name="id", help="Player id"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Framework.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online.")	
	end
end, "user")

Framework.Commands.Add("sv", "Spawn vehicle", {{name="model", help="Model name of the vehicle"}}, true, function(source, args)
	TriggerClientEvent('Framework:Command:SpawnVehicle', source, args[1])
end, "user")

Framework.Commands.Add("debug", "Debug mode on or off", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "user")

Framework.Commands.Add("closenui", "Close nui", {}, false, function(source, args)
	TriggerClientEvent('pepe-core:client:closenui', source)
end)

Framework.Commands.Add("opennui", "Open nui", {}, false, function(source, args)
	TriggerClientEvent('pepe-core:client:opennui', source)
end)

Framework.Commands.Add("dv", "Delete vehicle", {}, false, function(source, args)
	TriggerClientEvent('Framework:Command:DeleteVehicle', source)
end, "user")

Framework.Commands.Add("tpm", "Teleport to marker", {}, false, function(source, args)
	TriggerClientEvent('Framework:Command:GoToMarker', source)
end, "user")

Framework.Commands.Add("givemoney", "Give money to a player", {{name="id", help="Player id"},{name="moneytype", help="What sort of money (cash, bank, crypto)"}, {name="amount", help="Amount"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online.")
	end
end, "user")

Framework.Commands.Add("setmoney", "Set money for player", {{name="id", help="Player id"},{name="moneytype", help="What sort of money (cash, bank, crypto)"}, {name="amount", help="Amount"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online.")
	end
end, "user")

Framework.Commands.Add("setjob", "Give a job to a player", {{name="id", help="Player id"}, {name="job", help="Name of the job"}}, true, function(source, args)
	local Player = Framework.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		if not Player.Functions.SetJob(tostring(args[2]), args[3]) then
			TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Job format incorrect")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online.")
	end
end, "user")

Framework.Commands.Add("job", "Check job and grade", {}, false, function(source, args)
	local Player = Framework.Functions.GetPlayer(source)
	local duty = ""
	if Player.PlayerData.job.onduty then
		duty = "In Duty"
	else
		duty = "Off Duty"
	end
	
	local grade = (Player.PlayerData.job.grade ~= nil and Player.PlayerData.job.grade.name ~= nil) and Player.PlayerData.job.grade.name or 'No Grades'
	TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message" style="background-color: rgba(219, 52, 235, 0.75);"><b>Job Information</b> {0} [{1}] | {2}</div>',
    	args = { Player.PlayerData.job.label, duty, grade}
	})
end)

Framework.Commands.Add("clearinv", "Clear own inventory or someone else", {{name="id", help="Player id"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = Framework.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player not online.")
	end
end, "user")

Framework.Commands.Add("ooc", "Out of character message to citizens around you", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent("Framework:Client:LocalOutOfCharacter", -1, source, GetPlayerName(source), message)
	local Players = Framework.Functions.GetPlayers()

	for k, v in pairs(Framework.Functions.GetPlayers()) do
		if Framework.Functions.HasPermission(v, "admin") then
			if Framework.Functions.IsOptin(v) then
				TriggerClientEvent('chatMessage', v, "OOC | " .. GetPlayerName(source), "normal", message)
			end
		end
	end
end)